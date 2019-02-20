/*
 * ipmi_pef.h
 *
 * OpenIPMI interface for dealing with platform event filters
 *
 * Author: Intel Corporation
 *         Jeff Zheng <Jeff.Zheng@intel.com>
 *
 * Mostly rewritten by: MontaVista Software, Inc.
 *                      Corey Minyard <minyard@mvista.com>
 *                      source@mvista.com
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

#ifndef OPENIPMI_PEF_H
#define OPENIPMI_PEF_H

#include <OpenIPMI/ipmi_types.h>

#ifdef __cplusplus
extern "C" {
#endif

/* The abstract type for pef.  Note that if you use this directly, you
   must understand about PEF locking.  If you want easier access to
   the configuration, see the ipmi_pef_config_t type later in this
   file. */
typedef struct ipmi_pef_s ipmi_pef_t;


/* Generic callback used to tell when a PEF operation is done. */
typedef void (*ipmi_pef_done_cb)(ipmi_pef_t *pef,
				 int        err,
				 void       *cb_data);

/* Generic callback for iterating. */
typedef void (*ipmi_pef_ptr_cb)(ipmi_pef_t *pef,
				void       *cb_data);

/* Allocate a PEF.  The PEF will not be usable (it can only be
   destroyed) until the done callback is called. */
int ipmi_pef_alloc(ipmi_mc_t        *mc,
		   ipmi_pef_done_cb done,
		   void             *cb_data,
		   ipmi_pef_t       **new_pef);

/* Destroy a PEF. */
int ipmi_pef_destroy(ipmi_pef_t       *pef,
                     ipmi_pef_done_cb handler,
                     void             *cb_data);

/* Used to track references to a pef.  You can use this instead of
   ipmi_pef_destroy, but use of the destroy function is
   recommended.  This is primarily here to help reference-tracking
   garbage collection systems like what is in Perl to be able to
   automatically destroy pefs when they are done. */
void ipmi_pef_ref(ipmi_pef_t *pef);
void ipmi_pef_deref(ipmi_pef_t *pef);

void ipmi_pef_iterate_pefs(ipmi_domain_t   *domain,
			   ipmi_pef_ptr_cb handler,
			   void            *cb_data);

/* Fetch a parameter value from the PEF.  The "set" and "block"
   parameters are the set selector and block selectors.  If those are
   not relevant for the given parm, then set them to zero.  On the
   return data, the parameter version is the first byte, followed by
   the data. */
typedef void (*ipmi_pef_get_cb)(ipmi_pef_t    *pef,
				int           err,
				unsigned char *data,
				unsigned int  data_len,
				void          *cb_data);
int ipmi_pef_get_parm(ipmi_pef_t      *pef,
		      unsigned int    parm,
		      unsigned int    set,
		      unsigned int    block,
		      ipmi_pef_get_cb done,
		      void            *cb_data);

/* Set the parameter value in the PEF to the given data. */
int ipmi_pef_set_parm(ipmi_pef_t       *pef,
		      unsigned int     parm,
		      unsigned char    *data,
		      unsigned int     data_len,
		      ipmi_pef_done_cb done,
		      void             *cb_data);

/* Returns if the MC has a valid working PEF. */
int ipmi_pef_valid(ipmi_pef_t *pef);

/* Information fetched from the PEF capabilities. */
int ipmi_pef_supports_diagnostic_interrupt(ipmi_pef_t *pef);
int ipmi_pef_supports_oem_action(ipmi_pef_t *pef);
int ipmi_pef_supports_power_cycle(ipmi_pef_t *pef);
int ipmi_pef_supports_reset(ipmi_pef_t *pef);
int ipmi_pef_supports_power_down(ipmi_pef_t *pef);
int ipmi_pef_supports_alert(ipmi_pef_t *pef);

unsigned int ipmi_pef_major_version(ipmi_pef_t *pef);
unsigned int ipmi_pef_minor_version(ipmi_pef_t *pef);

unsigned int num_event_filter_table_entries(ipmi_pef_t *pef);

/* Return the MC this PEF uses. */
ipmi_mcid_t ipmi_pef_get_mc(ipmi_pef_t *pef);
#define IPMI_PEF_NAME_LEN 64
int ipmi_pef_get_name(ipmi_pef_t *pef, char *name, int length);

/* Standard entries in the PEF configuration. */

#define IPMI_PEFPARM_SET_IN_PROGRESS		0
#define IPMI_PEFPARM_CONTROL			1
#define IPMI_PEFPARM_ACTION_GLOBAL_CONTROL	2
#define IPMI_PEFPARM_STARTUP_DELAY		3
#define IPMI_PEFPARM_ALERT_STARTUP_DELAY	4
#define IPMI_PEFPARM_NUM_EVENT_FILTERS		5
#define IPMI_PEFPARM_EVENT_FILTER_TABLE		6
#define IPMI_PEFPARM_EVENT_FILTER_TABLE_DATA1	7
#define IPMI_PEFPARM_NUM_ALERT_POLICIES		8
#define IPMI_PEFPARM_ALERT_POLICY_TABLE		9
#define IPMI_PEFPARM_SYSTEM_GUID		10
#define IPMI_PEFPARM_NUM_ALERT_STRINGS		11
#define IPMI_PEFPARM_ALERT_STRING_KEY		12
#define IPMI_PEFPARM_ALERT_STRING		13


/*
 * *** NOTE *** READ THIS BEFORE USING THE CONFIG STUFF BELOW
 *
 * The configuration working below is strongly tied to locking of the
 * PEF.  If you successfully get a configuration (no error), then the
 * PEF *will* be locked, and you hold the lock.  You must call either
 * ipmi_pef_set_config() or ipmi_pef_clear_lock() to clean up the
 * lock.
 *
 * This allows you to do a read-modify-write operation and blocking
 * other operations on the PEF while you are doing this.
 */

/* A full PEF configuration. */
typedef struct ipmi_pef_config_s ipmi_pef_config_t;

/* Get the full PEF configuration and lock the PEF.  Note that if the
   PEF is locked by another, you will get an EAGAIN error in the
   callback.  You can retry the operation, or if you are sure that it
   is free, you can call ipmi_pef_clear_lock() before retrying.   Note
   that the config in the callback *must* be freed by you.*/
typedef void (*ipmi_pef_get_config_cb)(ipmi_pef_t        *pef,
				       int               err,
				       ipmi_pef_config_t *config,
				       void              *cb_data);
int ipmi_pef_get_config(ipmi_pef_t             *pef,
			ipmi_pef_get_config_cb done,
			void                   *cb_data);

/* Set the full PEF configuration.  The config *MUST* be locked and
   the pef must match the PEF that it was fetched with.  Note that a
   copy is made of the configuration, so you are free to do whatever
   you like with it after this.  Note that this unlocks the config, so
   it cannot be used for future set operations. */
int ipmi_pef_set_config(ipmi_pef_t        *pef,
			ipmi_pef_config_t *pefc,
			ipmi_pef_done_cb  done,
			void              *cb_data);

/* Clear the lock on a PEF.  If the PEF config is non-NULL, then it's
   lock is also cleared. */
int ipmi_pef_clear_lock(ipmi_pef_t        *pef,
			ipmi_pef_config_t *pefc,
			ipmi_pef_done_cb  done,
			void              *cb_data);

/* Free a PEF configuration. */
void ipmi_pef_free_config(ipmi_pef_config_t *config);

/* This interface lets you fetch and set the data values by parm
   num. Note that the parm nums *DO NOT* correspond to the
   IPMI_PEFPARM_xxx values above. */

enum ipmi_pefconf_val_type_e { IPMI_PEFCONFIG_INT, IPMI_PEFCONFIG_BOOL,
			       IPMI_PEFCONFIG_DATA, IPMI_PEFCONFIG_STR };
/* When getting the value, the valtype will be set to int or data.  If
   it is int or bool, the value is returned in ival and the dval is
   not used.  If it is data, the data will be returned in an allocated
   array in dval and the length set in dval_len.  The data must be
   freed with ipmi_pefconfig_data_free().  The is used for some data
   items (the priv level for authentication type, the destination for
   alerts and destination addresses); for other items it is ignored.
   The index should point to the value to fetch (starting at zero), it
   will be updated to the next value or -1 if no more are left.  The
   index will be unchanged if the parm does not support an index.

   The string name is returned in the name field, if it is not NULL.

   Note that when fetching a value, if the passed in pointer is NULL
   the data will not be filled in (except for index, which must always
   be present).  That lets you get the value type without getting the
   data, for instance. */
int ipmi_pefconfig_get_val(ipmi_pef_config_t *pefc,
			   unsigned int      parm,
			   const char        **name,
			   int               *index,
			   enum ipmi_pefconf_val_type_e *valtype,
			   unsigned int      *ival,
			   unsigned char     **dval,
			   unsigned int      *dval_len);
  /* Set a value in the pef config.  You must know ahead of time the
     actual value type and set the proper one. */
int ipmi_pefconfig_set_val(ipmi_pef_config_t *pefc,
			   unsigned int      parm,
			   int               index,
			   unsigned int      ival,
			   unsigned char     *dval,
			   unsigned int      dval_len);
/* If the value is an integer, this can be used to determine if it is
   an enumeration and what the values are.  If the parm is not an
   enumeration, this will return ENOSYS for the parm.  Otherwise, if
   you pass in zero, you will get either the first enumeration value,
   or EINVAL if zero is not a valid enumeration, but there are others.
   If this returns EINVAL or 0, nval will be set to the next valid
   enumeration value, or -1 if val is the last or past the last
   enumeration value.  If this returns 0, val will be set to the
   string value for the enumeration. */
int ipmi_pefconfig_enum_val(unsigned int parm, int val, int *nval,
			    const char **sval);
/* Sometimes array indexes may be enumerations.  This allows the user
   to detect if a specific parm's array index is an enumeration, and
   to get the enumeration values.  */
int ipmi_pefconfig_enum_idx(unsigned int parm, int idx, const char **sval);
/* Free data from ipmi_pefconfig_get_val(). */
void ipmi_pefconfig_data_free(void *data);
/* Convert a string to a pefconfig parm number.  Returns -1 if the
   string is invalid. */
unsigned int ipmi_pefconfig_str_to_parm(char *name);
/* Convert the parm to a string name. */
const char *ipmi_pefconfig_parm_to_str(unsigned int parm);
/* Get the type of a specific parm. */
int ipmi_pefconfig_parm_to_type(unsigned int                 parm,
				enum ipmi_pefconf_val_type_e *valtype);


/*
 * Main configuration items for the PEF.
 */
unsigned int
ipmi_pefconfig_get_alert_startup_delay_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_alert_startup_delay_enabled(ipmi_pef_config_t *pefc,
						   unsigned int val);
unsigned int ipmi_pefconfig_get_startup_delay_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_startup_delay_enabled(ipmi_pef_config_t *pefc,
					     unsigned int val);
unsigned int ipmi_pefconfig_get_event_messages_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_event_messages_enabled(ipmi_pef_config_t *pefc,
					      unsigned int val);
unsigned int ipmi_pefconfig_get_pef_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_pef_enabled(ipmi_pef_config_t *pefc, unsigned int val);
unsigned int
ipmi_pefconfig_get_diagnostic_interrupt_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_diagnostic_interrupt_enabled(ipmi_pef_config_t *pefc,
						    unsigned int val);
unsigned int ipmi_pefconfig_get_oem_action_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_oem_action_enabled(ipmi_pef_config_t *pefc,
					  unsigned int val);
unsigned int ipmi_pefconfig_get_power_cycle_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_power_cycle_enabled(ipmi_pef_config_t *pefc,
					   unsigned int val);
unsigned int ipmi_pefconfig_get_reset_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_reset_enabled(ipmi_pef_config_t *pefc, unsigned int val);
unsigned int ipmi_pefconfig_get_power_down_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_power_down_enabled(ipmi_pef_config_t *pefc,
					  unsigned int val);
unsigned int ipmi_pefconfig_get_alert_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_alert_enabled(ipmi_pef_config_t *pefc, unsigned int val);
int ipmi_pefconfig_get_startup_delay(ipmi_pef_config_t *pefc,
				     unsigned int *val);
int ipmi_pefconfig_set_startup_delay(ipmi_pef_config_t *pefc,
				     unsigned int val);
int ipmi_pefconfig_get_alert_startup_delay(ipmi_pef_config_t *pefc,
					   unsigned int *val);
int ipmi_pefconfig_set_alert_startup_delay(ipmi_pef_config_t *pefc,
					   unsigned int val);

unsigned int ipmi_pefconfig_get_guid_enabled(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_set_guid_enabled(ipmi_pef_config_t *pefc,
				    unsigned int      val);
int ipmi_pefconfig_get_guid_val(ipmi_pef_config_t *pefc,
				unsigned char     *data,
				unsigned int      *data_len);
int ipmi_pefconfig_set_guid_val(ipmi_pef_config_t *pefc,
				unsigned char     *data,
				unsigned int      data_len);

/*
 * The following is for the event filter table entries.
 *
 * NOTE! The event filter table in IPMI is one-based (entry zero is not
 * used, entry 1 is the first entry).  This might make Ada programmers
 * happy, but to make it so C programmers are not confused, this
 * implementation converts it to be zero-based (entry zero *is* the
 * first entry)
 */
unsigned int ipmi_pefconfig_get_num_event_filters(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_get_enable_filter(ipmi_pef_config_t *pefc,
				     unsigned int      sel,
				     unsigned int      *val);
int ipmi_pefconfig_set_enable_filter(ipmi_pef_config_t *pefc,
				     unsigned int      sel,
				     unsigned int      val);

/* PEF Filter types */
#define IPMI_PEFPARM_EFT_FILTER_CONFIG_MANUFACTURE_CONFIG 2
#define IPMI_PEFPARM_EFT_FILTER_CONFIG_SOFTWARE_CONFIG 0

int ipmi_pefconfig_get_filter_type(ipmi_pef_config_t *pefc,
				   unsigned int      sel,
				   unsigned int      *val);
int ipmi_pefconfig_set_filter_type(ipmi_pef_config_t *pefc,
				   unsigned int      sel,
				   unsigned int      val);

int ipmi_pefconfig_get_diagnostic_interrupt(ipmi_pef_config_t *pefc,
					    unsigned int      sel,
					    unsigned int      *val);
int ipmi_pefconfig_set_diagnostic_interrupt(ipmi_pef_config_t *pefc,
					    unsigned int      sel,
					    unsigned int      val);

int ipmi_pefconfig_get_oem_action(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      *val);
int ipmi_pefconfig_set_oem_action(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      val);

int ipmi_pefconfig_get_power_cycle(ipmi_pef_config_t *pefc,
				   unsigned int      sel,
				   unsigned int      *val);
int ipmi_pefconfig_set_power_cycle(ipmi_pef_config_t *pefc,
				   unsigned int      sel,
				   unsigned int      val);

int ipmi_pefconfig_get_reset(ipmi_pef_config_t *pefc,
			     unsigned int      sel,
			     unsigned int      *val);
int ipmi_pefconfig_set_reset(ipmi_pef_config_t *pefc,
			     unsigned int      sel,
			     unsigned int      val);

int ipmi_pefconfig_get_power_down(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      *val);
int ipmi_pefconfig_set_power_down(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      val);

int ipmi_pefconfig_get_alert(ipmi_pef_config_t *pefc,
			     unsigned int      sel,
			     unsigned int      *val);
int ipmi_pefconfig_set_alert(ipmi_pef_config_t *pefc,
			     unsigned int      sel,
			     unsigned int      val);

int ipmi_pefconfig_get_alert_policy_number(ipmi_pef_config_t *pefc,
					   unsigned int      sel,
					   unsigned int      *val);
int ipmi_pefconfig_set_alert_policy_number(ipmi_pef_config_t *pefc,
					   unsigned int      sel,
					   unsigned int      val);

/* PEF event severities */
#define IPMI_PEFPARM_EVENT_SEVERITY_UNSPECIFIED 	0x00
#define IPMI_PEFPARM_EVENT_SEVERITY_MONITOR		0x01
#define IPMI_PEFPARM_EVENT_SEVERITY_INFORMATION		0x02
#define IPMI_PEFPARM_EVENT_SEVERITY_OK			0x04
#define IPMI_PEFPARM_EVENT_SEVERITY_NON_CRITICAL	0x08
#define IPMI_PEFPARM_EVENT_SEVERITY_CRITICAL		0x10
#define IPMI_PEFPARM_EVENT_SEVERITY_NON_RECOVERABLE	0x20
int ipmi_pefconfig_get_event_severity(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      *val);
int ipmi_pefconfig_set_event_severity(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      val);

int ipmi_pefconfig_get_generator_id_addr(ipmi_pef_config_t *pefc,
					 unsigned int      sel,
					 unsigned int      *val);
int ipmi_pefconfig_set_generator_id_addr(ipmi_pef_config_t *pefc,
					 unsigned int      sel,
					 unsigned int      val);

int ipmi_pefconfig_get_generator_id_channel_lun(ipmi_pef_config_t *pefc,
						unsigned int      sel,
						unsigned int      *val);
int ipmi_pefconfig_set_generator_id_channel_lun(ipmi_pef_config_t *pefc,
						unsigned int      sel,
						unsigned int      val);

int ipmi_pefconfig_get_sensor_type(ipmi_pef_config_t *pefc,
				   unsigned int      sel,
				   unsigned int      *val);
int ipmi_pefconfig_set_sensor_type(ipmi_pef_config_t *pefc,
				   unsigned int      sel,
				   unsigned int      val);

int ipmi_pefconfig_get_sensor_number(ipmi_pef_config_t *pefc,
				     unsigned int      sel,
				     unsigned int      *val);
int ipmi_pefconfig_set_sensor_number(ipmi_pef_config_t *pefc,
				     unsigned int      sel,
				     unsigned int      val);

int ipmi_pefconfig_get_event_trigger(ipmi_pef_config_t *pefc,
				     unsigned int      sel,
				     unsigned int      *val);
int ipmi_pefconfig_set_event_trigger(ipmi_pef_config_t *pefc,
				     unsigned int      sel,
				     unsigned int      val);

int ipmi_pefconfig_get_data1_offset_mask(ipmi_pef_config_t *pefc,
					 unsigned int      sel,
					 unsigned int      *val);
int ipmi_pefconfig_set_data1_offset_mask(ipmi_pef_config_t *pefc,
					 unsigned int      sel,
					 unsigned int      val);
int ipmi_pefconfig_get_data1_mask(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      *val);
int ipmi_pefconfig_set_data1_mask(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      val);
int ipmi_pefconfig_get_data1_compare1(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      *val);
int ipmi_pefconfig_set_data1_compare1(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      val);
int ipmi_pefconfig_get_data1_compare2(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      *val);
int ipmi_pefconfig_set_data1_compare2(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      val);

int ipmi_pefconfig_get_data2_mask(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      *val);
int ipmi_pefconfig_set_data2_mask(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      val);
int ipmi_pefconfig_get_data2_compare1(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      *val);
int ipmi_pefconfig_set_data2_compare1(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      val);
int ipmi_pefconfig_get_data2_compare2(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      *val);
int ipmi_pefconfig_set_data2_compare2(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      val);

int ipmi_pefconfig_get_data3_mask(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      *val);
int ipmi_pefconfig_set_data3_mask(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      val);
int ipmi_pefconfig_get_data3_compare1(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      *val);
int ipmi_pefconfig_set_data3_compare1(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      val);
int ipmi_pefconfig_get_data3_compare2(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      *val);
int ipmi_pefconfig_set_data3_compare2(ipmi_pef_config_t *pefc,
				      unsigned int      sel,
				      unsigned int      val);

/*
 * Values from the alert policy table.
 *
 * NOTE! The event filter table in IPMI is one-based (entry zero is not
 * used, entry 1 is the first entry).  This might make Ada programmers
 * happy, but to make it so C programmers are not confused, this
 * implementation converts it to be zero-based (entry zero *is* the
 * first entry)
 */
unsigned int ipmi_pefconfig_get_num_alert_policies(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_get_policy_num(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      *val);
int ipmi_pefconfig_set_policy_num(ipmi_pef_config_t *pefc,
				  unsigned int      sel,
				  unsigned int      val);
int ipmi_pefconfig_get_enabled(ipmi_pef_config_t *pefc,
			       unsigned int      sel,
			       unsigned int      *val);
int ipmi_pefconfig_set_enabled(ipmi_pef_config_t *pefc,
			       unsigned int      sel,
			       unsigned int      val);
int ipmi_pefconfig_get_policy(ipmi_pef_config_t *pefc,
			      unsigned int      sel,
			      unsigned int      *val);
int ipmi_pefconfig_set_policy(ipmi_pef_config_t *pefc,
			      unsigned int      sel,
			      unsigned int      val);
int ipmi_pefconfig_get_channel(ipmi_pef_config_t *pefc,
			       unsigned int      sel,
			       unsigned int      *val);
int ipmi_pefconfig_set_channel(ipmi_pef_config_t *pefc,
			       unsigned int      sel,
			       unsigned int      val);
int ipmi_pefconfig_get_destination_selector(ipmi_pef_config_t *pefc,
					    unsigned int      sel,
					    unsigned int      *val);
int ipmi_pefconfig_set_destination_selector(ipmi_pef_config_t *pefc,
					    unsigned int      sel,
					    unsigned int      val);
int ipmi_pefconfig_get_alert_string_event_specific(ipmi_pef_config_t *pefc,
						   unsigned int      sel,
						   unsigned int      *val);
int ipmi_pefconfig_set_alert_string_event_specific(ipmi_pef_config_t *pefc,
						   unsigned int      sel,
						   unsigned int      val);
int ipmi_pefconfig_get_alert_string_selector(ipmi_pef_config_t *pefc,
					     unsigned int      sel,
					     unsigned int      *val);
int ipmi_pefconfig_set_alert_string_selector(ipmi_pef_config_t *pefc,
					     unsigned int      sel,
					     unsigned int      val);

/*
 * Values from the alert string keys and alert strings.  Note that
 * unlike the other PEF set data, there is a zero value here so the
 * numbering matches the numbering in the actual data.
 */
unsigned int ipmi_pefconfig_get_num_alert_strings(ipmi_pef_config_t *pefc);
int ipmi_pefconfig_get_event_filter(ipmi_pef_config_t *pefc,
				    unsigned int      sel,
				    unsigned int      *val);
int ipmi_pefconfig_set_event_filter(ipmi_pef_config_t *pefc,
				    unsigned int      sel,
				    unsigned int      val);
int ipmi_pefconfig_get_alert_string_set(ipmi_pef_config_t *pefc,
					unsigned int      sel,
					unsigned int      *val);
int ipmi_pefconfig_set_alert_string_set(ipmi_pef_config_t *pefc,
					unsigned int      sel,
					unsigned int      val);
int ipmi_pefconfig_get_alert_string(ipmi_pef_config_t *pefc, unsigned int sel,
				    unsigned char *val, unsigned int *len);
int ipmi_pefconfig_set_alert_string(ipmi_pef_config_t *pefc, unsigned int sel,
				    unsigned char *val);


/*
 * Cruft, don't use
 */
int ipmi_pefconfig_get_guid(ipmi_pef_config_t *pefc,
			    unsigned int      *enabled,
			    unsigned char     *data,
			    unsigned int      *data_len);
int ipmi_pefconfig_set_guid(ipmi_pef_config_t *pefc, unsigned int enabled,
			    unsigned char *data, unsigned int data_len);


#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_PEF_H */
