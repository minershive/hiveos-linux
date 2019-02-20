/*
 * ipmi_fru.h
 *
 * internal IPMI interface for FRUs
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

#ifndef OPENIPMI_FRU_INTERNAL_H
#define OPENIPMI_FRU_INTERNAL_H

#include <OpenIPMI/ipmi_fru.h>
#include <OpenIPMI/ipmi_err.h>
#include <OpenIPMI/os_handler.h>

os_handler_t *i_ipmi_fru_get_os_handler(ipmi_fru_t *fru);

/* The callbacks for FRU multi-record OEM handler, to decode the multi-record 
   and get individual field.
   ipmi_fru_multi_record_oem_decoder_cb(): record is the raw binary multi-record
      record_len is the length of this raw binary multi-record,
      the doceded OEM FRU information is outputted and stored in *explain_data_p.
   ipmi_fru_get_multi_record_oem_field_handler_cb(): this callback is called
      when user call ipmi_fru_multi_record_get_field(). Please refer to the 
      comments for ipmi_fru_multi_record_get_field().
   ipmi_fru_multi_record_free_explain_data_cb(): this callback is used to free
   the OEM FRU specific data structures.

*/

/* Free the data in the node. */
typedef void (*ipmi_fru_oem_node_cb)(ipmi_fru_node_t *node);

typedef int (*ipmi_fru_oem_node_get_field_cb)
     (ipmi_fru_node_t           *node,
      unsigned int              index,
      const char                **name,
      enum ipmi_fru_data_type_e *dtype,
      int                       *intval,
      time_t                    *time,
      double                    *floatval,
      char                      **data,
      unsigned int              *data_len,
      ipmi_fru_node_t           **sub_node);

typedef int (*ipmi_fru_oem_node_set_field_cb)
     (ipmi_fru_node_t           *node,
      unsigned int              index,
      enum ipmi_fru_data_type_e dtype,
      int                       intval,
      time_t                    time,
      double                    floatval,
      char                      *data,
      unsigned int              data_len);

typedef int (*ipmi_fru_oem_node_settable_cb)
     (ipmi_fru_node_t           *node,
      unsigned int              index);

typedef int (*ipmi_fru_oem_node_subtype_cb)
     (ipmi_fru_node_t           *node,
      enum ipmi_fru_data_type_e *dtype);

typedef int (*ipmi_fru_oem_node_enum_val_cb)(ipmi_fru_node_t *node,
					     unsigned int    index,
					     int             *pos,
					     int             *nextpos,
					     const char      **data);

ipmi_fru_node_t *i_ipmi_fru_node_alloc(ipmi_fru_t *fru);

void *i_ipmi_fru_node_get_data(ipmi_fru_node_t *node);
void i_ipmi_fru_node_set_data(ipmi_fru_node_t *node, void *data);
void *i_ipmi_fru_node_get_data2(ipmi_fru_node_t *node);
void i_ipmi_fru_node_set_data2(ipmi_fru_node_t *node, void *data2);

void i_ipmi_fru_node_set_destructor(ipmi_fru_node_t      *node,
				    ipmi_fru_oem_node_cb destroy);
void i_ipmi_fru_node_set_get_field(ipmi_fru_node_t                *node,
				   ipmi_fru_oem_node_get_field_cb get_field);
void i_ipmi_fru_node_set_set_field(ipmi_fru_node_t                *node,
				   ipmi_fru_oem_node_set_field_cb set_field);
void i_ipmi_fru_node_set_settable(ipmi_fru_node_t               *node,
				  ipmi_fru_oem_node_settable_cb settable);
void i_ipmi_fru_node_set_get_subtype(ipmi_fru_node_t              *node,
				     ipmi_fru_oem_node_subtype_cb get_subtype);
void i_ipmi_fru_node_set_get_enum(ipmi_fru_node_t               *node,
				  ipmi_fru_oem_node_enum_val_cb get_enum);

/* Get the root node of a multi-record.  Note that the root record
   must not be an array.  Note that you cannot keep a copy of the fru
   pointer around after this call returns; it will be unlocked and
   could go away after this returns. */
typedef int (*ipmi_fru_oem_multi_record_get_root_node_cb)
     (ipmi_fru_t          *fru,
      unsigned int        mr_rec_num,
      unsigned int        manufacturer_id,
      unsigned char       record_type_id,
      unsigned char       *mr_data,
      unsigned int        mr_data_len,
      void                *cb_data,
      const char          **name,
      ipmi_fru_node_t     **node);

/* Register/deregister a multi-record handler.  Note that if the
   record type id is < 0xc0 (not OEM) then the manufacturer id does
   not matter. */
int i_ipmi_fru_register_multi_record_oem_handler
(unsigned int                               manufacturer_id,
 unsigned char                              record_type_id,
 ipmi_fru_oem_multi_record_get_root_node_cb get_root,
 void                                       *cb_data);

int i_ipmi_fru_deregister_multi_record_oem_handler
(unsigned int  manufacturer_id,
 unsigned char record_type_id);

void i_ipmi_fru_lock(ipmi_fru_t *fru);
void i_ipmi_fru_unlock(ipmi_fru_t *fru);

/* You must be holding the fru lock to call this. */
void i_ipmi_fru_ref_nolock(ipmi_fru_t *fru);

/*
 * Some specialized FRU data repositories have protection against
 * multiple readers/writers to keep them from colliding.  The model
 * here is similar to the other parts of IPMI.  You have a timestamp
 * that tells the last time the repository changed.  On reading, the
 * code will check the timestamp before and after to make sure the
 * data hasn't changed while being written.  There is a lock for
 * writers.  The code will lock (prepare to write), check the
 * timestamp to make sure another writer has not modified, then write,
 * then unlock and commit (write complete).  Note that you can have
 * the reader timestamp without the lock, or the lock without the
 * timestamp.
 *
 * You can also override the function that sends the write message.
 * this function will get the data as formatted for a normal FRU
 * write.
 */
typedef void (*i_ipmi_fru_timestamp_cb)(ipmi_fru_t    *fru,
					ipmi_domain_t *domain,
					int           err,
					uint32_t      timestamp);
typedef void (*i_ipmi_fru_op_cb)(ipmi_fru_t    *fru,
				 ipmi_domain_t *domain,
				 int           err);

typedef int (*i_ipmi_fru_get_timestamp_cb)(ipmi_fru_t             *fru,
					   ipmi_domain_t          *domain,
					   i_ipmi_fru_timestamp_cb handler);
typedef int (*i_ipmi_fru_prepare_write_cb)(ipmi_fru_t      *fru,
					   ipmi_domain_t   *domain,
					   uint32_t        timestamp,
					   i_ipmi_fru_op_cb done);
typedef int (*i_ipmi_fru_write_cb)(ipmi_fru_t      *fru,
				   ipmi_domain_t   *domain,
				   unsigned char   *data,
				   unsigned int    data_len,
				   i_ipmi_fru_op_cb done);
typedef int (*i_ipmi_fru_complete_write_cb)(ipmi_fru_t      *fru,
					    ipmi_domain_t   *domain,
					    int             abort,
					    uint32_t        timestamp,
					    i_ipmi_fru_op_cb done);

int i_ipmi_fru_set_get_timestamp_handler(ipmi_fru_t                 *fru,
					 i_ipmi_fru_get_timestamp_cb handler);
int i_ipmi_fru_set_prepare_write_handler(ipmi_fru_t                 *fru,
					 i_ipmi_fru_prepare_write_cb handler);
int i_ipmi_fru_set_write_handler(ipmi_fru_t         *fru,
				 i_ipmi_fru_write_cb handler);
int i_ipmi_fru_set_complete_write_handler(ipmi_fru_t                  *fru,
					  i_ipmi_fru_complete_write_cb handler);

typedef void (*i_ipmi_fru_setup_data_clean_cb)(ipmi_fru_t *fru, void *data);
void i_ipmi_fru_set_setup_data(ipmi_fru_t                    *fru,
			       void                          *data,
			       i_ipmi_fru_setup_data_clean_cb cleanup);
void *i_ipmi_fru_get_setup_data(ipmi_fru_t *fru);

void i_ipmi_fru_get_addr(ipmi_fru_t   *fru,
			 ipmi_addr_t  *addr,
			 unsigned int *addr_len);


/* Add a record telling that a specific area of the FRU data needs to
   be written.  Called from the write handler. */
int i_ipmi_fru_new_update_record(ipmi_fru_t   *fru,
				 unsigned int offset,
				 unsigned int length);

/* Get/set the fru-type secific data.  Note that the cleanup_recs
   function will be called on any rec_data.  The right way to set this
   data is to set the rec data then set your ops. */
void *i_ipmi_fru_get_rec_data(ipmi_fru_t *fru);
void i_ipmi_fru_set_rec_data(ipmi_fru_t *fru, void *rec_data);

/* Get a pointer to the fru data and the length.  Only valid during
   decoding and writing. */
void *i_ipmi_fru_get_data_ptr(ipmi_fru_t *fru);
unsigned int i_ipmi_fru_get_data_len(ipmi_fru_t *fru);

/* Get a debug name for the FRU */ 
char *i_ipmi_fru_get_iname(ipmi_fru_t *fru);

/* Misc data about the FRU. */
unsigned int i_ipmi_fru_get_fetch_mask(ipmi_fru_t *fru);
int i_ipmi_fru_is_normal_fru(ipmi_fru_t *fru);
void i_ipmi_fru_set_is_normal_fru(ipmi_fru_t *fru, int val);

/*
 * Interface between the generic FRU code and the specific FRU
 * decoders.
 */

typedef void (*ipmi_fru_void_op)(ipmi_fru_t *fru);
typedef int (*ipmi_fru_err_op)(ipmi_fru_t *fru);
typedef int (*ipmi_fru_get_root_node_op)(ipmi_fru_t      *fru,
					 const char      **name,
					 ipmi_fru_node_t **rnode);

/* Add a function to cleanup the FRU record data (free all the memory)
   as the FRU is destroyed. */
void i_ipmi_fru_set_op_cleanup_recs(ipmi_fru_t *fru, ipmi_fru_void_op op);

/* Called when a write operations completes successfully, to clear out
   all the write information. */
void i_ipmi_fru_set_op_write_complete(ipmi_fru_t *fru, ipmi_fru_void_op op);

/* Called to copy all the changed data into the FRU block of data and
   add update records for the changed data. */
void i_ipmi_fru_set_op_write(ipmi_fru_t *fru, ipmi_fru_err_op op);

/* Get the root node for the user to decode. */
void i_ipmi_fru_set_op_get_root_node(ipmi_fru_t                *fru,
				    ipmi_fru_get_root_node_op op);

/* Register a decoder for FRU data.  The provided function should
   return success if the FRU is supported and can be decoded properly,
   ENOSYS if the FRU information doesn't match the format, or anything
   else for invalid FRU data.  It should register the nodes  */
int i_ipmi_fru_register_decoder(ipmi_fru_err_op op);
int i_ipmi_fru_deregister_decoder(ipmi_fru_err_op op);

/***********************************************************************
 *
 * Table-driven multirecord FRU handling.
 *
 * This makes describing the contents of multi-record data much easier
 * that writing your own field handling routines.
 *
 * You describe your data by filling in layout structures.  Three
 * different structures exist:
 *
 *  struct - Defines a record node.  The top-level of a multi record
 *  is always a record node, and arrays always consist of record
 *  nodes.
 *
 *  item - These are individual data items (floats, ints, strings,
 *  etc).  You supply an array of these in a struct layout to describe
 *  the basic items in a record.
 *
 *  array - A variable-sized set of record nodes, items (or other
 *  arrays, though that is not yet implemented).  You can insert
 *  elements in the array and delete them.
 *
 * NOTE: you cannot have an array of bitfields.
 *
 **********************************************************************/
typedef struct ipmi_mr_struct_layout_s ipmi_mr_struct_layout_t;
typedef struct ipmi_mr_item_layout_s ipmi_mr_item_layout_t;
typedef struct ipmi_mr_array_layout_s ipmi_mr_array_layout_t;

typedef struct ipmi_mr_item_info_s ipmi_mr_item_info_t;
typedef struct ipmi_mr_struct_info_s ipmi_mr_struct_info_t;
typedef struct ipmi_mr_array_info_s ipmi_mr_array_info_t;

typedef struct ipmi_mr_offset_s ipmi_mr_offset_t;

/* The offset structure is in all info structures as the first item,
   it is sort of the "base type" of all the info types.  If an item is
   contained within another item (like an item or structure in an
   array, or an array or item in a structure), then the contained item
   will have a pointer to the parent item's offset structure.  If an
   item is in an array, the "next" pointer of this structure will
   point to the next item's offset structure in the list.

   All this complexity is used to keep the offsets and lengths sane.
   If you change an item's size (adding or deleting an element in an
   array) you must change the length of all the parent items and the
   offset of all succeeding items for the changed item and all items
   succeeding all parents.  The fact that the offset is relative to
   the parent means you have to go to all the parents to calculate the
   real offset, but you don't have to go down arrays to recalculate
   offsets. */
struct ipmi_mr_offset_s {
    /* Items that contain this item, if we adjust this items length we
       need to adjust the parent's lengths as well. */
    ipmi_mr_offset_t *parent;

    /* Items after this one that need their offset adjusted if we
       alter this item's length. */
    ipmi_mr_offset_t *next;

    /* Offset from the beginning of the *parent*, not the whole
       structure. */
    uint8_t          offset;

    uint8_t          length;
};

/* Stores in the data2 information for the root FRU node. */
typedef struct ipmi_mr_fru_info_s {
    ipmi_fru_t   *fru;
    unsigned int mr_rec_num;
} ipmi_mr_fru_info_t;

/* A convenience structure for passing to the item get and set
   routines. */
typedef struct ipmi_mr_getset_s {
    ipmi_mr_item_layout_t     *layout;
    ipmi_mr_offset_t          *offset;
    unsigned char             *rdata;
    ipmi_mr_fru_info_t        *finfo;
} ipmi_mr_getset_t;

/* Information about an array. */
struct ipmi_mr_array_info_s {
    ipmi_mr_offset_t       offset;
    uint8_t                count;    /* Number of array elements. */
    uint8_t                nr_after; /* Number of arrays after me. */
    ipmi_mr_array_layout_t *layout;  /* Array layout */

    /* An array of ipmi_mr_struct_info_t, ipmi_mr_array_info_t, or
       ipmi_mr_item_info_t, depending on layout functions. */
    ipmi_mr_offset_t       **items;
};

/* Information about a single item.  Note that this is only used in
   arrays; structures use a different mechanism to manage items so
   they can store their data more efficiently. */
struct ipmi_mr_item_info_s
{
    ipmi_mr_offset_t      offset;
    uint8_t               len;
    ipmi_mr_item_layout_t *layout;
    unsigned char         *data;
};

/* Information about a structure.  The "data" field holds the data for
   all items in the structure and the layout start offsets are used to
   calculated how to get the individual items. */
struct ipmi_mr_struct_info_s
{
    ipmi_mr_offset_t        offset;
    ipmi_mr_struct_layout_t *layout;
    unsigned char           *data;
    ipmi_mr_array_info_t    *arrays;
};

/* A descriptor for a single item.  This an appear in a structure item
   list or in as an arrays elem_layout. */
struct ipmi_mr_item_layout_s
{
    char                      *name;
    enum ipmi_fru_data_type_e dtype;

    uint8_t settable;

    /* Start offset and length, either in bits for a bit offset field
       or bytes for everything else. */
    uint16_t start;
    uint16_t length;

    union {
	float multiplier;
	void *tab_data;
    } u;

    int (*set_field)(ipmi_mr_getset_t          *getset,
		     enum ipmi_fru_data_type_e dtype,
		     int                       intval,
		     time_t                    time,
		     double                    floatval,
		     char                      *data,
		     unsigned int              data_len);
    int (*get_field)(ipmi_mr_getset_t          *getset,
		     enum ipmi_fru_data_type_e *dtype,
		     int                       *intval,
		     time_t                    *time,
		     double                    *floatval,
		     char                      **data,
		     unsigned int              *data_len);
    int (*get_enum)(ipmi_mr_getset_t *getset,
		    int              *pos,
		    int              *nextpos,
		    const char       **data);
};

/* Describes an array. */
struct ipmi_mr_array_layout_s
{
    char    *name;
    uint8_t has_count;
    uint8_t min_elem_size;
    uint8_t settable;

    /* Either a struct, item, or array layout, depending on the
       functions. */
    void *elem_layout;

    /* Check to make sure the data is valid and calculate the length
       of the data needed for the element. */
    int (*elem_check)(void                    *layout,
		      unsigned char           **mr_data,
		      unsigned int            *mr_data_len);
    /* Decode the element.  The new record is returned in "rec". */
    int (*elem_decode)(void                  *layout,
		       unsigned int          offset,
		       ipmi_mr_offset_t      *offset_parent,
		       ipmi_mr_offset_t      **rec,
		       unsigned char         **mr_data,
		       unsigned int          *mr_data_len);
    /* Cleanup the array. */
    void (*cleanup)(ipmi_mr_array_info_t *arec);
    /* Get a field from the array. */
    int (*get_field)(ipmi_mr_array_info_t      *arec,
		     ipmi_fru_node_t           *rnode,
		     enum ipmi_fru_data_type_e *dtype,
		     int                       *intval,
		     time_t                    *time,
		     double                    *floatval,
		     char                      **data,
		     unsigned int              *data_len,
		     ipmi_fru_node_t           **sub_node);
    /* Set a field in the array. */
    int (*set_field)(ipmi_mr_array_info_t      *arec,
		     ipmi_mr_fru_info_t        *finfo,
		     enum ipmi_fru_data_type_e dtype,
		     int                       intval,
		     time_t                    time,
		     double                    floatval,
		     char                      *data,
		     unsigned int              data_len);
};

struct ipmi_mr_struct_layout_s
{
    char                   *name;
    uint8_t                length; /* Excluding arrays. */
    unsigned int           item_count;
    ipmi_mr_item_layout_t  *items;
    unsigned int           array_count;
    ipmi_mr_array_layout_t *arrays;

    void (*cleanup)(ipmi_mr_struct_info_t *rec);
};

/* Get the actual offset from the beginning of the multi-record. */
uint8_t ipmi_mr_full_offset(ipmi_mr_offset_t *o);

/* Resized something, adjust all the lengths and offsets in the parents. */
void ipmi_mr_adjust_len(ipmi_mr_offset_t *o, int len);

/* Functions for processing arrays of structures. */
void ipmi_mr_struct_array_cleanup(ipmi_mr_array_info_t *arec);
int ipmi_mr_struct_array_get_field(ipmi_mr_array_info_t      *arec,
				   ipmi_fru_node_t           *rnode,
				   enum ipmi_fru_data_type_e *dtype,
				   int                       *intval,
				   time_t                    *time,
				   double                    *floatval,
				   char                      **data,
				   unsigned int              *data_len,
				   ipmi_fru_node_t           **sub_node);
int ipmi_mr_struct_array_set_field(ipmi_mr_array_info_t      *arec,
				   ipmi_mr_fru_info_t        *finfo,
				   enum ipmi_fru_data_type_e dtype,
				   int                       intval,
				   time_t                    time,
				   double                    floatval,
				   char                      *data,
				   unsigned int              data_len);

/* Functions for processing arrays of items. */
void ipmi_mr_item_array_cleanup(ipmi_mr_array_info_t *arec);
int ipmi_mr_item_array_get_field(ipmi_mr_array_info_t      *arec,
				 ipmi_fru_node_t           *rnode,
				 enum ipmi_fru_data_type_e *dtype,
				 int                       *intval,
				 time_t                    *time,
				 double                    *floatval,
				 char                      **data,
				 unsigned int              *data_len,
				 ipmi_fru_node_t           **sub_node);
int ipmi_mr_item_array_set_field(ipmi_mr_array_info_t      *arec,
				 ipmi_mr_fru_info_t        *finfo,
				 enum ipmi_fru_data_type_e dtype,
				 int                       intval,
				 time_t                    time,
				 double                    floatval,
				 char                      *data,
				 unsigned int              data_len);

/* Functions for handling structures. */
void ipmi_mr_struct_cleanup(ipmi_mr_struct_info_t *rec);
int ipmi_mr_struct_elem_check(void          *vlayout,
			      unsigned char **rmr_data,
			      unsigned int  *rmr_data_len);
int ipmi_mr_struct_decode(void             *vlayout,
			  unsigned int     offset,
			  ipmi_mr_offset_t *offset_parent,
			  ipmi_mr_offset_t **rrec,
			  unsigned char    **rmr_data,
			  unsigned int     *rmr_data_len);

/* Functions for handling items (in arrays only). */
int ipmi_mr_item_elem_check(void          *vlayout,
			    unsigned char **rmr_data,
			    unsigned int  *rmr_data_len);
int ipmi_mr_item_decode(void             *vlayout,
			unsigned int     offset,
			ipmi_mr_offset_t *offset_parent,
			ipmi_mr_offset_t **rrec,
			unsigned char    **rmr_data,
			unsigned int     *rmr_data_len);

/* Create a root node based upon a structure layout. */
int ipmi_mr_struct_root(ipmi_fru_t              *fru,
			unsigned int            mr_rec_num,
			unsigned char           *rmr_data,
			unsigned int            rmr_data_len,
			ipmi_mr_struct_layout_t *layout,
			const char              **name,
			ipmi_fru_node_t         **rnode);

/***********************************************************************
 *
 * Generic field encoders and decoders.
 *
 **********************************************************************/

/* Little-endian integer, one or more bytes. */
int ipmi_mr_int_set_field(ipmi_mr_getset_t          *getset,
			  enum ipmi_fru_data_type_e dtype,
			  int                       intval,
			  time_t                    time,
			  double                    floatval,
			  char                      *data,
			  unsigned int              data_len);
int ipmi_mr_int_get_field(ipmi_mr_getset_t          *getset,
			  enum ipmi_fru_data_type_e *dtype,
			  int                       *intval,
			  time_t                    *time,
			  double                    *floatval,
			  char                      **data,
			  unsigned int              *data_len);

/* An integer that has is converted to float.  You must set the
   multiplier field in the layout. */
int ipmi_mr_intfloat_set_field(ipmi_mr_getset_t          *getset,
			       enum ipmi_fru_data_type_e dtype,
			       int                       intval,
			       time_t                    time,
			       double                    floatval,
			       char                      *data,
			       unsigned int              data_len);
int ipmi_mr_intfloat_get_field(ipmi_mr_getset_t          *getset,
			       enum ipmi_fru_data_type_e *dtype,
			       int                       *intval,
			       time_t                    *time,
			       double                    *floatval,
			       char                      **data,
			       unsigned int              *data_len);

/* A bit field in the structure.  Note that this is little endian and
   the "start" and "length" field of the layout are in bits, not
   bytes. */
int ipmi_mr_bitint_set_field(ipmi_mr_getset_t          *getset,
			     enum ipmi_fru_data_type_e dtype,
			     int                       intval,
			     time_t                    time,
			     double                    floatval,
			     char                      *data,
			     unsigned int              data_len);
int ipmi_mr_bitint_get_field(ipmi_mr_getset_t          *getset,
			     enum ipmi_fru_data_type_e *dtype,
			     int                       *intval,
			     time_t                    *time,
			     double                    *floatval,
			     char                      **data,
			     unsigned int              *data_len);

/* A bitint that is a set of strings indexed by the integer value.
   The tab_data field must be set to an ipmi_mr_tab_item_t
   structure. */
typedef struct ipmi_mr_tab_item_s {
    unsigned int count;
    const char   *table[];
} ipmi_mr_tab_item_t;
int ipmi_mr_bitvaltab_set_field(ipmi_mr_getset_t          *getset,
				enum ipmi_fru_data_type_e dtype,
				int                       intval,
				time_t                    time,
				double                    floatval,
				char                      *data,
				unsigned int              data_len);
int ipmi_mr_bitvaltab_get_field(ipmi_mr_getset_t          *getset,
				enum ipmi_fru_data_type_e *dtype,
				int                       *intval,
				time_t                    *time,
				double                    *floatval,
				char                      **data,
				unsigned int              *data_len);
int ipmi_mr_bitvaltab_get_enum(ipmi_mr_getset_t *getset,
			       int              *pos,
			       int              *nextpos,
			       const char       **data);

/* A bitint that is a set of floating point values indexed by integer
   value.  The tab_data field must be set to an
   ipmi_mr_floattab_item_t structure. */
typedef struct ipmi_mr_floattab_item_s {
    unsigned int count;
    double       defval; /* Default when initialized */
    /* You specify a low, nominal, and high value.  The nominal value
       is what it is converted to.  Anything between low and high will
       convert to this value. */
    struct {
	float      low;
	float      nominal;
	float      high;
	const char *nominal_str;
    } table[];
} ipmi_mr_floattab_item_t;
int ipmi_mr_bitfloatvaltab_set_field(ipmi_mr_getset_t          *getset,
				     enum ipmi_fru_data_type_e dtype,
				     int                       intval,
				     time_t                    time,
				     double                    floatval,
				     char                      *data,
				     unsigned int              data_len);
int ipmi_mr_bitfloatvaltab_get_field(ipmi_mr_getset_t          *getset,
				     enum ipmi_fru_data_type_e *dtype,
				     int                       *intval,
				     time_t                    *time,
				     double                    *floatval,
				     char                      **data,
				     unsigned int              *data_len);
int ipmi_mr_bitfloatvaltab_get_enum(ipmi_mr_getset_t *getset,
				    int              *pos,
				    int              *nextpos,
				    const char       **data);

/* A fixed-size area for a standard IPMI FRU string. */
int ipmi_mr_str_set_field(ipmi_mr_getset_t          *getset,
			  enum ipmi_fru_data_type_e dtype,
			  int                       intval,
			  time_t                    time,
			  double                    floatval,
			  char                      *data,
			  unsigned int              data_len);
int ipmi_mr_str_get_field(ipmi_mr_getset_t          *getset,
			  enum ipmi_fru_data_type_e *dtype,
			  int                       *intval,
			  time_t                    *time,
			  double                    *floatval,
			  char                      **data,
			  unsigned int              *data_len);

/* A fixed-size area for a chunk of bytes. */
int ipmi_mr_binary_set_field(ipmi_mr_getset_t          *getset,
			     enum ipmi_fru_data_type_e dtype,
			     int                       intval,
			     time_t                    time,
			     double                    floatval,
			     char                      *data,
			     unsigned int              data_len);
int ipmi_mr_binary_get_field(ipmi_mr_getset_t          *getset,
			     enum ipmi_fru_data_type_e *dtype,
			     int                       *intval,
			     time_t                    *time,
			     double                    *floatval,
			     char                      **data,
			     unsigned int              *data_len);

/* A four-byte IP address, represented as a string. */
int ipmi_mr_ip_set_field(ipmi_mr_getset_t          *getset,
			 enum ipmi_fru_data_type_e dtype,
			 int                       intval,
			 time_t                    time,
			 double                    floatval,
			 char                      *data,
			 unsigned int              data_len);
int ipmi_mr_ip_get_field(ipmi_mr_getset_t          *getset,
			 enum ipmi_fru_data_type_e *dtype,
			 int                       *intval,
			 time_t                    *time,
			 double                    *floatval,
			 char                      **data,
			 unsigned int              *data_len);

#endif /* OPENIPMI_FRU_INTERNAL_H */
