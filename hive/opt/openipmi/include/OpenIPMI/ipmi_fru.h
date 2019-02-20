/*
 * ipmi_fru.h
 *
 * IPMI interface for FRUs
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2003 MontaVista Software Inc.
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *
 *  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
 *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 *  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 *  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this program; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef OPENIPMI_FRU_H
#define OPENIPMI_FRU_H

#include <OpenIPMI/ipmi_types.h>
#include <OpenIPMI/ipmi_bits.h>
#include <time.h>

#define IPMI_FRU_NAME_LEN 64

#ifdef __cplusplus
extern "C" {
#endif

enum ipmi_fru_data_type_e
{
    IPMI_FRU_DATA_INT,
    IPMI_FRU_DATA_TIME,
    IPMI_FRU_DATA_ASCII,
    IPMI_FRU_DATA_BINARY,
    IPMI_FRU_DATA_UNICODE,
    IPMI_FRU_DATA_BOOLEAN,
    IPMI_FRU_DATA_FLOAT,
    IPMI_FRU_DATA_SUB_NODE,
};

typedef struct ipmi_fru_node_s ipmi_fru_node_t;



/* The the domain the FRU uses. */
ipmi_domain_id_t ipmi_fru_get_domain_id(ipmi_fru_t *fru);

/* Name of the FRU. */
int ipmi_fru_get_name(ipmi_fru_t *fru, char *name, int length);

/*
 * Allocate a FRU and start fetching it.
 */
typedef void (*ipmi_fru_fetched_cb)(ipmi_fru_t *fru, int err, void *cb_data);
int ipmi_fru_alloc(ipmi_domain_t       *domain,
		   unsigned char       is_logical,
		   unsigned char       device_address,
		   unsigned char       device_id,
		   unsigned char       lun,
		   unsigned char       private_bus,
		   unsigned char       channel,
		   ipmi_fru_fetched_cb fetched_handler,
		   void                *fetched_cb_data,
		   ipmi_fru_t          **new_fru);

/*
 * Allocate a FRU and start fetching it.  Like the above, but the
 * callback passes the domain.
 */
typedef void (*ipmi_fru_cb)(ipmi_domain_t *domain,
			    ipmi_fru_t    *fru,
			    int           err,
			    void          *cb_data);
int ipmi_domain_fru_alloc(ipmi_domain_t *domain,
			  unsigned char is_logical,
			  unsigned char device_address,
			  unsigned char device_id,
			  unsigned char lun,
			  unsigned char private_bus,
			  unsigned char channel,
			  ipmi_fru_cb   fetched_handler,
			  void          *fetched_cb_data,
			  ipmi_fru_t    **new_fru);

/* Destroy an FRU.  Note that if the FRU is currently fetching SDRs,
   the destroy cannot complete immediately, it will be marked for
   destruction later.  You can supply a callback that, if not NULL,
   will be called when the sdr is destroyed. */
typedef void (*ipmi_fru_destroyed_cb)(ipmi_fru_t *fru, void *cb_data);
int ipmi_fru_destroy(ipmi_fru_t            *fru,
		     ipmi_fru_destroyed_cb handler,
		     void                  *cb_data);

/* Generic callback for iterating.  This only applies to FRU data
   objects that are created by the user.  Other FRUs (like ones
   automatically fetched by entities or for other functions) do not
   appear here. */
typedef void (*ipmi_fru_ptr_cb)(ipmi_fru_t *fru,
				void       *cb_data);
void ipmi_fru_iterate_frus(ipmi_domain_t   *domain,
			   ipmi_fru_ptr_cb handler,
			   void            *cb_data);

/* Return the length of the data in the FRU.  Note that this will be
   non-zero if the FRU information was fetched, even if there was an
   error reading the data.  So if this is non-zero, even if the FRU is
   corrupt, you can create areas and fields and write out to the
   FRU. */
unsigned int ipmi_fru_get_data_length(ipmi_fru_t *fru);

/* Used to track references to a FRU.  You can use this instead of
   ipmi_fru_destroy, but use of the destroy function is recommended.
   This is primarily here to help reference-tracking garbage
   collection systems like what is in Perl to be able to automatically
   destroy FRUs when they are done. */
void ipmi_fru_ref(ipmi_fru_t *fru);
void ipmi_fru_deref(ipmi_fru_t *fru);

/* Set options for the FRU.  See ipmi_bits.h for IPMI_STRING_OPTION_xxx. */
void ipmi_fru_set_options(ipmi_fru_t *fru, unsigned int options);
unsigned int ipmi_fru_get_options(ipmi_fru_t *fru);

/*
 * The following is the node-based access to the FRU information.
 * This is an abstract, tree structured interface that lets you get at
 * the data in the FRU without having to know anything about it
 * beforehand.
 *
 * A "node" here is a data structure holding fields.  It may have
 * sub-nodes (thus making the tree structure)
 *
 * To dump all the FRU data, get the root node first.  Then dump all
 * the fields in that node.  If you get a node with dtype
 * IPMI_FRU_DATA_SUB_NODE, then dump all the data in the sub node you
 * get.
 */

/* Return the main node of a FRU and the type of fru.  You must free
   the returned node using ipmi_fru_put_node(). */
int ipmi_fru_get_root_node(ipmi_fru_t      *fru,
			   const char      **type,
			   ipmi_fru_node_t **node);

/* If you need to copy a fru node for your own use (store it someplace
   else), you should probably "get" the node when you copy it and
   "put" the node when you are done with it.  These are refcount type
   things for the pointers. */
void ipmi_fru_get_node(ipmi_fru_node_t *node);
void ipmi_fru_put_node(ipmi_fru_node_t *node);

/*
 * Fetch a field in a FRU node.  The fields are sequentially indexed
 * items in a node.
 *
 * There are two types of nodes.  An array node is simply an array,
 * the individual elements are not named.  The "index" is an index
 * into the array itself, starting at 0.  The elements of an array
 * node will always set the "name" to NULL.  If you fetch beyond the
 * end of an array, it will return EINVAL.  If you fetch a field and
 * it returns a SUB_NODE type and "intval" is not -1, the sub_node
 * field will be set to an array subnode.
 *
 * A record node is a node that has a set of elements that are named,
 * the "name" will always be set to a value when fetching one of
 * these.  The index tells which field of the record to fetch.  Note
 * that, unlike arrays, individual fields in a record node may not be
 * present.  Fetching these fields will return ENOSYS, but there may
 * be valid fields after this.  This returns EINVAL if you go beyond
 * the last field.  If you fetch a field and it returns a SUB_NODE
 * type and "intval" is -1, the sub_node field will be set to an
 * record subnode.
 *
 * The various dtypes are:
 *    IPMI_FRU_DATA_INT  - sets "intval"
 *    IPMI_FRU_DATA_TIME - sets "time"
 *    IPMI_FRU_DATA_ASCII - sets "data" and "data_len"
 *    IPMI_FRU_DATA_BINARY - sets "data" and "data_len"
 *    IPMI_FRU_DATA_UNICODE - sets "data" and "data_len"
 *    IPMI_FRU_DATA_BOOLEAN - sets "intval"
 *    IPMI_FRU_DATA_FLOAT - sets "floatval"
 *    IPMI_FRU_DATA_SUB_NODE - sets "sub_node".  "intval" will be -1
 *          if not an array or the array length if it is an array.
 *
 * Note that if data is set, you must free the data passed back using
 * ipmi_fru_data_free().
 *
 * For sub-nodes, you must free the returned sub_node using
 * ipmi_fru_put_node().
 *
 * Any of the return values may be NULL, that value will just not be
 * returned.
 */
int ipmi_fru_node_get_field(ipmi_fru_node_t           *node,
			    unsigned int              index,
			    const char                **name,
			    enum ipmi_fru_data_type_e *dtype,
			    int                       *intval,
			    time_t                    *time,
			    double                    *floatval,
			    char                      **data,
			    unsigned int              *data_len,
			    ipmi_fru_node_t           **sub_node);

/*
 * Set an index in a node.  See the information for ipmi_fru_node_get_field
 * above for information on the types and data values.
 *
 * This function returns EPERM if the field is not writable or EINVAL if
 * something is invalid about the data or index or data type.
 *
 * Setting a base value (int, float, time, etc.) will set that value
 * for the field.  Nothing magical or suprising.
 *
 * Setting an index that returns an array will insert a new value into
 * the array at the given index (if the index is positive) or delete
 * the value at -index-1 (if the index is negative).  To extend an
 * array, write to an index beyond the current length and it will be
 * automatically extended by one value.  The new element will be set
 * to some initial value.
 *
 * Setting a record type subnode is not supported.
 */
int ipmi_fru_node_set_field(ipmi_fru_node_t           *node,
			    unsigned int              index,
			    enum ipmi_fru_data_type_e dtype,
			    int                       intval,
			    time_t                    time,
			    double                    floatval,
			    char                      *data,
			    unsigned int              data_len);

/*
 * Can an index in a node be set?  Returns 0 if so, an error if not.
 */
int ipmi_fru_node_settable(ipmi_fru_node_t *node,
			   unsigned int    index);

/* Only for arrays, get's the array's subtype. */
int ipmi_fru_node_get_subtype(ipmi_fru_node_t           *node,
			      enum ipmi_fru_data_type_e *subtype);

/* Used to map enum-type values, where there is a limited set of value
   values.  Pass in -1 for "pos" to get the first value, "pos" will be
   set to the actual value.  nextpos will be set to the next valid
   value.  data will return a pointer to an allocated string for the
   value.  For integer values, pos will map to the actual intval
   values.  For others, the order is undetermined. */
int ipmi_fru_node_get_enum_val(ipmi_fru_node_t *node,
			       unsigned int    index,
			       int             *pos,
			       int             *nextpos,
			       const char      **data);

/* Free data that comes from ipmi_fru_node_get_field if the data return is
   non-NULL. */
void ipmi_fru_data_free(char *data);


/************************************************************************
 *
 * Everything below this is "old", it only works with standard FRU
 * information and doesn't use the new, more abstract, interface to
 * FRU data.
 *
 * You need the stuff below if you are setting data in a standard FRU.
 * Otherwise, you should probably use the standard interface.
 *
 ************************************************************************/

/* The following functions get boatloads of information from the FRU.
   These all will return ENOSYS if the information is not available.
   All these function return error, not lengths.

   The string return functions allow you to fetch the type and length.
   The length returns for ASCII strings does include the nil
   character, and it will be put on to the end of the get string.
   Also, when fetching the string, you must set the max_len variable
   to the maximum length of the returned data.  The actual length
   copied into the output string is returned in max_len. */
int ipmi_fru_get_internal_use_version(ipmi_fru_t    *fru,
				      unsigned char *version);
int ipmi_fru_get_internal_use_len(ipmi_fru_t   *fru,
				  unsigned int *length);
int ipmi_fru_get_internal_use(ipmi_fru_t    *fru,
			      unsigned char *data,
			      unsigned int  *max_len);

int ipmi_fru_get_chassis_info_version(ipmi_fru_t    *fru,
				      unsigned char *version);
int ipmi_fru_get_chassis_info_type(ipmi_fru_t    *fru,
				   unsigned char *type);

int ipmi_fru_get_chassis_info_part_number_len(ipmi_fru_t   *fru,
					      unsigned int *length);
int ipmi_fru_get_chassis_info_part_number_type(ipmi_fru_t           *fru,
					       enum ipmi_str_type_e *type);
int ipmi_fru_get_chassis_info_part_number(ipmi_fru_t   *fru,
					  char         *str,
					  unsigned int *strlen);
int ipmi_fru_get_chassis_info_serial_number_len(ipmi_fru_t   *fru,
						unsigned int *length);
int ipmi_fru_get_chassis_info_serial_number_type(ipmi_fru_t           *fru,
						 enum ipmi_str_type_e *type);
int ipmi_fru_get_chassis_info_serial_number(ipmi_fru_t   *fru,
					    char         *str,
					    unsigned int *strlen);
int ipmi_fru_get_chassis_info_custom_len(ipmi_fru_t   *fru,
					 unsigned int num,
					 unsigned int *length);
int ipmi_fru_get_chassis_info_custom_type(ipmi_fru_t           *fru,
					  unsigned int         num,
					  enum ipmi_str_type_e *type);
int ipmi_fru_get_chassis_info_custom(ipmi_fru_t   *fru,
				     unsigned int num,
				     char         *str,
				     unsigned int *strlen);

int ipmi_fru_get_board_info_version(ipmi_fru_t    *fru,
				    unsigned char *version);
int ipmi_fru_get_board_info_lang_code(ipmi_fru_t    *fru,
				      unsigned char *type);
int ipmi_fru_get_board_info_mfg_time(ipmi_fru_t   *fru,
				     time_t *time);
int ipmi_fru_get_board_info_board_manufacturer_len(ipmi_fru_t   *fru,
						   unsigned int *length);
int ipmi_fru_get_board_info_board_manufacturer_type(ipmi_fru_t           *fru,
						    enum ipmi_str_type_e *type);
int ipmi_fru_get_board_info_board_manufacturer(ipmi_fru_t   *fru,
					       char         *str,
					       unsigned int *strlen);
int ipmi_fru_get_board_info_board_product_name_len(ipmi_fru_t   *fru,
						   unsigned int *length);
int ipmi_fru_get_board_info_board_product_name_type(ipmi_fru_t           *fru,
						    enum ipmi_str_type_e *type);
int ipmi_fru_get_board_info_board_product_name(ipmi_fru_t   *fru,
					       char         *str,
					       unsigned int *strlen);
int ipmi_fru_get_board_info_board_serial_number_len(ipmi_fru_t   *fru,
						    unsigned int *length);
int ipmi_fru_get_board_info_board_serial_number_type(ipmi_fru_t           *fru,
						     enum ipmi_str_type_e *type);
int ipmi_fru_get_board_info_board_serial_number(ipmi_fru_t   *fru,
						char         *str,
						unsigned int *strlen);
int ipmi_fru_get_board_info_board_part_number_len(ipmi_fru_t   *fru,
						  unsigned int *length);
int ipmi_fru_get_board_info_board_part_number_type(ipmi_fru_t           *fru,
						   enum ipmi_str_type_e *type);
int ipmi_fru_get_board_info_board_part_number(ipmi_fru_t   *fru,
					      char         *str,
					      unsigned int *strlen);
int ipmi_fru_get_board_info_fru_file_id_len(ipmi_fru_t   *fru,
					    unsigned int *length);
int ipmi_fru_get_board_info_fru_file_id_type(ipmi_fru_t           *fru,
					     enum ipmi_str_type_e *type);
int ipmi_fru_get_board_info_fru_file_id(ipmi_fru_t   *fru,
					char         *str,
					unsigned int *strlen);
int ipmi_fru_get_board_info_custom_len(ipmi_fru_t   *fru,
				       unsigned int num,
				       unsigned int *length);
int ipmi_fru_get_board_info_custom_type(ipmi_fru_t           *fru,
					unsigned int         num,
					enum ipmi_str_type_e *type);
int ipmi_fru_get_board_info_custom(ipmi_fru_t   *fru,
				   unsigned int num,
				   char         *str,
				   unsigned int *strlen);

int ipmi_fru_get_product_info_version(ipmi_fru_t    *fru,
				      unsigned char *version);
int ipmi_fru_get_product_info_lang_code(ipmi_fru_t    *fru,
					unsigned char *type);
int ipmi_fru_get_product_info_manufacturer_name_len(ipmi_fru_t   *fru,
						    unsigned int *length);
int ipmi_fru_get_product_info_manufacturer_name_type(ipmi_fru_t           *fru,
						     enum ipmi_str_type_e *type);
int ipmi_fru_get_product_info_manufacturer_name(ipmi_fru_t   *fru,
						char         *str,
						unsigned int *strlen);
int ipmi_fru_get_product_info_product_name_len(ipmi_fru_t   *fru,
					       unsigned int *length);
int ipmi_fru_get_product_info_product_name_type(ipmi_fru_t           *fru,
						enum ipmi_str_type_e *type);
int ipmi_fru_get_product_info_product_name(ipmi_fru_t   *fru,
					   char         *str,
					   unsigned int *strlen);
int ipmi_fru_get_product_info_product_part_model_number_len(ipmi_fru_t   *fru,
							    unsigned int *length);
int ipmi_fru_get_product_info_product_part_model_number_type(ipmi_fru_t           *fru,
							     enum ipmi_str_type_e *type);
int ipmi_fru_get_product_info_product_part_model_number(ipmi_fru_t   *fru,
							char         *str,
							unsigned int *strlen);
int ipmi_fru_get_product_info_product_version_len(ipmi_fru_t   *fru,
						  unsigned int *length);
int ipmi_fru_get_product_info_product_version_type(ipmi_fru_t           *fru,
						   enum ipmi_str_type_e *type);
int ipmi_fru_get_product_info_product_version(ipmi_fru_t   *fru,
					      char         *str,
					      unsigned int *strlen);
int ipmi_fru_get_product_info_product_serial_number_len(ipmi_fru_t   *fru,
							unsigned int *length);
int ipmi_fru_get_product_info_product_serial_number_type(ipmi_fru_t           *fru,
							 enum ipmi_str_type_e *type);
int ipmi_fru_get_product_info_product_serial_number(ipmi_fru_t   *fru,
						    char         *str,
						    unsigned int *strlen);
int ipmi_fru_get_product_info_asset_tag_len(ipmi_fru_t   *fru,
					    unsigned int *length);
int ipmi_fru_get_product_info_asset_tag_type(ipmi_fru_t           *fru,
					     enum ipmi_str_type_e *type);
int ipmi_fru_get_product_info_asset_tag(ipmi_fru_t   *fru,
					char         *str,
					unsigned int *strlen);
int ipmi_fru_get_product_info_fru_file_id_len(ipmi_fru_t   *fru,
					      unsigned int *length);
int ipmi_fru_get_product_info_fru_file_id_type(ipmi_fru_t           *fru,
					       enum ipmi_str_type_e *type);
int ipmi_fru_get_product_info_fru_file_id(ipmi_fru_t   *fru,
					  char         *str,
					  unsigned int *strlen);
int ipmi_fru_get_product_info_custom_len(ipmi_fru_t   *fru,
					 unsigned int num,
					 unsigned int *length);
int ipmi_fru_get_product_info_custom_type(ipmi_fru_t           *fru,
					  unsigned int         num,
					  enum ipmi_str_type_e *type);
int ipmi_fru_get_product_info_custom(ipmi_fru_t   *fru,
				     unsigned int num,
				     char         *str,
				     unsigned int *strlen);

/*
 * Multi-records work differently from other record types.  They are always
 * blocks of binary data.  The "type" field (along with the other fields)
 * is the field from the record.  It does not tell you the data type like
 * the above "type" fields do.
 */
unsigned int ipmi_fru_get_num_multi_records(ipmi_fru_t *fru);
int ipmi_fru_get_multi_record_type(ipmi_fru_t    *fru,
				   unsigned int  num,
				   unsigned char *type);
int ipmi_fru_get_multi_record_format_version(ipmi_fru_t    *fru,
					     unsigned int  num,
					     unsigned char *ver);
int ipmi_fru_get_multi_record_data_len(ipmi_fru_t   *fru,
				       unsigned int num,
				       unsigned int *len);
/* Note that length is a in/out parameter, you must set the length to
   the length of the buffer and the function will set it to the actual
   length. */
int ipmi_fru_get_multi_record_data(ipmi_fru_t    *fru,
				   unsigned int  num,
				   unsigned char *data,
				   unsigned int  *length);
/* Get part of the multirecord data. */
int ipmi_fru_get_multi_record_slice(ipmi_fru_t    *fru,
				    unsigned int  num,
				    unsigned int  offset,
				    unsigned int  length,
				    unsigned char *data);

/*
 * This interface lets you get the FRU data by name.
 */

/*
 * Get the FRU information by index.  This is a rather complex
 * function, but gives probably the simplest possible way to iterate
 * through the FRU data.  The index is a contiguous range from zero
 * that holds every FRU data item.  So you can iterate through the
 * indexes from 0 until it returns EINVAL to find all the names.
 *
 * name returns the string name for the index.  Note that the
 * indexes may change between release, so don't rely on absolute
 * numbers.  The names will remain the same, so you can rely on
 * those.
 *
 * The number is a pointer to an integer with the number of the item
 * to get within the field.  Some fields (custom records,
 * multi-records) have multiple items in them.  The first item will be
 * zero, and the integer here will be updated to reference the next
 * item.  When the last item is reached, the field will be updated
 * to -1.  For fields that don't have multiple items, this will
 * not modify the value num points to.
 *
 * The dtype field will be set to the data type.  If it is an integer
 * value, then intval will be set to whatever the value is.  If it is
 * a time value, then the time field will be filled in.  If it is not,
 * then a block of data will be allocated to hold the field and placed
 * into data, the length of the data will be in data_len.  You must
 * free the data when you are done with ipmi_fru_data_free().
 *
 * Returns EINVAL if the index is out of range, ENOSYS if the
 * particular index is not supported (the name will still be set), or
 * E2BIG if the num is too big (again, the name will be set).
 *
 * Any of the return values may be passed NULL to ignore the data.
 *
 * This does *not* include the multi-records.
 *
 * Note this is old an you should use the fru node stuf at the top of
 * this file.
 */
int ipmi_fru_get(ipmi_fru_t                *fru,
		 int                       index,
		 const char                **name,
		 int                       *num,
		 enum ipmi_fru_data_type_e *dtype,
		 int                       *intval,
		 time_t                    *time,
		 char                      **data,
		 unsigned int              *data_len);

/* Convert an idx to a name (does not require a FRU).  Return an error
   if the index is out of range. */
char *ipmi_fru_index_to_str(int idx);

/*
 * Find the index number for the given string.  Returns -1 if the string
 * is invalid.
 */
int ipmi_fru_str_to_index(char *name);

/* More internal stuff.  The average user will not need to be able
   to use the following functions, but they are here just in case. */

/* FIXME - for OEM code (if ever necessary) add a way to create an
   empty FRU, fill it with data, and put it into an entity. */


/*
 * Create and destroy FRU areas and get information about them.  Note
 * that these set the version to 1, which is all we support for now.
 * The offset is from the beginning of the FRU, and may not be zero.
 * The length is the total length of the area; the actual FRU information
 * may use less.  The used_length is the actual amount of bytes used
 * in the FRU area, the free space in the area is length - used_length.
 * Note that offsets must be multiples of 8 and <= 2040.  Lengths will
 * be truncated to a multiple of 8.
 */
#define IPMI_FRU_FTR_INTERNAL_USE_AREA 0
#define IPMI_FRU_FTR_CHASSIS_INFO_AREA 1
#define IPMI_FRU_FTR_BOARD_INFO_AREA   2
#define IPMI_FRU_FTR_PRODUCT_INFO_AREA 3
#define IPMI_FRU_FTR_MULTI_RECORD_AREA 4
#define IPMI_FRU_FTR_NUMBER            (IPMI_FRU_FTR_MULTI_RECORD_AREA + 1)

/* Note that the length for adding multi-records is ignored, it will
   calculate it to the end of the data. */

/* If you set the length to zero when adding an area, you will get a
   minimally sized area. */
int ipmi_fru_add_area(ipmi_fru_t   *fru,
		      unsigned int area,
		      unsigned int offset,
		      unsigned int length);
int ipmi_fru_delete_area(ipmi_fru_t *fru, int area);
int ipmi_fru_area_get_offset(ipmi_fru_t   *fru,
			     unsigned int area,
			     unsigned int *offset);
int ipmi_fru_area_get_length(ipmi_fru_t   *fru,
			     unsigned int area,
			     unsigned int *length);
int ipmi_fru_area_set_offset(ipmi_fru_t   *fru,
			     unsigned int area,
			     unsigned int offset);
int ipmi_fru_area_set_length(ipmi_fru_t   *fru,
			     unsigned int area,
			     unsigned int length);
int ipmi_fru_area_get_used_length(ipmi_fru_t *fru,
				  unsigned int area,
				  unsigned int *used_length);

/*
 * Set the values for the FRU data.  Old data will be freed and new
 * data added if the data already exists.  For custom records (and
 * multi-records, too), setting a number larger than the current
 * number of records will cause a new record to be added onto the end.
 * It will *not* use the specified number in this case.  If you use a
 * number <= the last one, it will replace the given number.
 *
 * When setting an ASCII string type, the len value *does not* include
 * the terminating NIL character.  It is not stored, so is not necessary.
 *
 * Passing in a "NULL" for the data of a custom string field or a
 * multi-record to zero will cause it to be deleted.  This will
 * renumber the fields/records, so be careful.  Also, if you have no
 * multi-records, no multi-record fields will be written and the area
 * will be deleted automatically.
 */
int ipmi_fru_set_internal_use(ipmi_fru_t    *fru,
			      unsigned char *data,
			      unsigned int  len);

int ipmi_fru_set_chassis_info_type(ipmi_fru_t    *fru,
				   unsigned char type);
int ipmi_fru_set_chassis_info_part_number(ipmi_fru_t   *fru,
					  enum ipmi_str_type_e type,
					  char         *str,
					  unsigned int len);
int ipmi_fru_set_chassis_info_serial_number(ipmi_fru_t   *fru,
					    enum ipmi_str_type_e type,
					    char         *str,
					    unsigned int len);
int ipmi_fru_set_chassis_info_custom(ipmi_fru_t   *fru,
				     unsigned int num,
				     enum ipmi_str_type_e type,
				     char         *str,
				     unsigned int len);

int ipmi_fru_set_board_info_lang_code(ipmi_fru_t    *fru,
				      unsigned char type);
int ipmi_fru_set_board_info_mfg_time(ipmi_fru_t   *fru,
				     time_t       time);
int ipmi_fru_set_board_info_board_manufacturer(ipmi_fru_t   *fru,
					       enum ipmi_str_type_e type,
					       char         *str,
					       unsigned int len);
int ipmi_fru_set_board_info_board_product_name(ipmi_fru_t   *fru,
					       enum ipmi_str_type_e type,
					       char         *str,
					       unsigned int len);
int ipmi_fru_set_board_info_board_serial_number(ipmi_fru_t   *fru,
						enum ipmi_str_type_e type,
						char         *str,
						unsigned int len);
int ipmi_fru_set_board_info_board_part_number(ipmi_fru_t   *fru,
					      enum ipmi_str_type_e type,
					      char         *str,
					      unsigned int len);
int ipmi_fru_set_board_info_fru_file_id(ipmi_fru_t   *fru,
					enum ipmi_str_type_e type,
					char         *str,
					unsigned int len);
int ipmi_fru_set_board_info_custom(ipmi_fru_t   *fru,
				   unsigned int num,
				   enum ipmi_str_type_e type,
				   char         *str,
				   unsigned int len);

int ipmi_fru_set_product_info_lang_code(ipmi_fru_t    *fru,
					unsigned char type);
int ipmi_fru_set_product_info_manufacturer_name(ipmi_fru_t   *fru,
						enum ipmi_str_type_e type,
						char         *str,
						unsigned int len);
int ipmi_fru_set_product_info_product_name(ipmi_fru_t   *fru,
					   enum ipmi_str_type_e type,
					   char         *str,
					   unsigned int len);
int ipmi_fru_set_product_info_product_part_model_number(ipmi_fru_t   *fru,
							enum ipmi_str_type_e type,
							char         *str,
							unsigned int len);
int ipmi_fru_set_product_info_product_version(ipmi_fru_t   *fru,
					      enum ipmi_str_type_e type,
					      char         *str,
					      unsigned int len);
int ipmi_fru_set_product_info_product_serial_number(ipmi_fru_t   *fru,
						    enum ipmi_str_type_e type,
						    char         *str,
						    unsigned int len);
int ipmi_fru_set_product_info_asset_tag(ipmi_fru_t   *fru,
					enum ipmi_str_type_e type,
					char         *str,
					unsigned int len);
int ipmi_fru_set_product_info_fru_file_id(ipmi_fru_t   *fru,
					  enum ipmi_str_type_e type,
					  char         *str,
					  unsigned int len);
int ipmi_fru_set_product_info_custom(ipmi_fru_t   *fru,
				     unsigned int num,
				     enum ipmi_str_type_e type,
				     char         *str,
				     unsigned int len);

/* Set the type field for a multi-record. */
int ipmi_fru_set_multi_record_type(ipmi_fru_t    *fru,
				   unsigned int  num,
				   unsigned char type);
/* Replace the data in a multi-record.  "data" may not be NULL. */
int ipmi_fru_set_multi_record_data(ipmi_fru_t    *fru,
				   unsigned int  num,
				   unsigned char *data,
				   unsigned int  length);
/* If "data" is non-NULL, overwrite an existing multirecord with new
   information, or insert a new record at the end if "num" is the same
   or larger then the current number of multirecords.  If "data" is
   NULL, then delete the given multirecord.  For deletion, type and
   version are ignored. */
int ipmi_fru_set_multi_record(ipmi_fru_t    *fru,
			      unsigned int  num,
			      unsigned char type,
			      unsigned char version,
			      unsigned char *data,
			      unsigned int  length);
/* Overwrite data in the given multirecord's data with new
   information.  Overwrite data at the given offset to the given
   length.  The length must be within the multirecord's current
   length. */
int ipmi_fru_ovw_multi_record_data(ipmi_fru_t    *fru,
				   unsigned int  num,
				   unsigned char *data,
				   unsigned int  offset,
				   unsigned int  length);
/* Insert new data in the given multirecord.  The total length may not
   exceed the maximum length of a multirecord. */
int ipmi_fru_ins_multi_record_data(ipmi_fru_t    *fru,
				   unsigned int  num,
				   unsigned char *data,
				   unsigned int  offset,
				   unsigned int  length);
/* Delete data in the given multirecord.  The total length may not
   go below zero. */
int ipmi_fru_del_multi_record_data(ipmi_fru_t    *fru,
				   unsigned int  num,
				   unsigned int  offset,
				   unsigned int  length);

/*
 * A generic interface for setting values by index.  The function to use
 * depends on the data type.  If the data type does not match, these will
 * return an error.  Note that the "num" field is ignored if the data
 * is not a custom.  Also, multi-records are not settable through this
 * interface.  Also note that the "version" fields are note settable
 * and are always set to 1 (per the spec).
 */
int ipmi_fru_set_int_val(ipmi_fru_t *fru,
			 int        index,
			 int        num,
			 int        val);
int ipmi_fru_set_time_val(ipmi_fru_t *fru,
			  int        index,
			  int        num,
			  time_t     time);
int ipmi_fru_set_float_val(ipmi_fru_t *fru,
			   int        index,
			   int        num,
			   double     val);
int ipmi_fru_set_data_val(ipmi_fru_t                *fru,
			  int                       index,
			  int                       num,
			  enum ipmi_fru_data_type_e dtype,
			  char                      *data,
			  unsigned int              len);


/*
 * Write the information in the FRU back out.  Note that only the modified
 * data is written, any unchanged data will not be written.  This is an
 * extremely dangerous operation and should only be done with the utmost
 * care.  There are no locks for the FRU data.  This means that two writers
 * can be simultaneously writing the FRU data without knowing about it,
 * resulting in corruptions.  Be careful.
 */
int ipmi_fru_write(ipmi_fru_t *fru, ipmi_fru_cb done, void *cb_data);


/* The interface to get individual field from the decoded OEM FRU
 * multi-record hierarchy.  Usage:
 *
 * Step 1: before traversing the hierarchy, you first need to call
 * ipmi_fru_multi_record_get_root_node() to get the root node.  you
 * may think of node as the root node of sub-hierarchy.
 *
 * Step 2: ipmi_fru_node_get_field() is similar to
 * ipmi_fru_get(), the only special part is "sub_node", which is an
 * output parameter.  If the data type is IPMI_FRU_DATA_SUB_NODE, the
 * given index is the root to a sub-parameter.  The sub_node will be
 * set and if the node is an array, the intval will be set to the
 * length of the array.  The intval will be set to -1 if it is not an
 * array.  You may notice that this is a recursive process.
 *
 * Step 3: after finishing traversing a node, you need to call
 * ipmi_fru_put_node() to return the resource to system.
 *
 * Note that if the returned "name" is NULL, then the node is an array
 * element (the parent is an array) and the name of the first parent
 * object with a name is the one to use for the array.
 *
 * There's a sample code to demonstrate how to use this interface in
 * dump_fru_info() in ui/ui.c.  This is a very flexible interface, you
 * can choose whatever way you like to traverse the decoded OEM FRU
 * hierarchy. Enjoy it!
 *
 * Fetching the root node is multi-thread safe, but the operations
 * on fru nodes are not.  If you have multiple threads accessing the
 * same FRU node, you must provide your own locks.
 */

int ipmi_fru_multi_record_get_root_node(ipmi_fru_t      *fru,
					unsigned int    record_num,
					const char      **name,
					ipmi_fru_node_t **node);


/************************************************************************
 *
 * Cruft
 *
 ************************************************************************/
int ipmi_fru_get_internal_use_data(ipmi_fru_t    *fru,
				   unsigned char *data,
				   unsigned int  *max_len);

int ipmi_fru_get_internal_use_length(ipmi_fru_t   *fru,
				     unsigned int *length);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_FRU_H */
