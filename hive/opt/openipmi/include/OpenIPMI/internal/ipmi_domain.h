/*
 * ipmi_domain.h
 *
 * MontaVista IPMI interface for management domains
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2002,2003 MontaVista Software Inc.
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

#ifndef OPENIPMI_DOMAIN_H
#define OPENIPMI_DOMAIN_H
#include <OpenIPMI/ipmi_types.h>
#include <OpenIPMI/os_handler.h>
#include <OpenIPMI/ipmi_sdr.h>
#include <OpenIPMI/ipmi_addr.h>
#include <OpenIPMI/ipmi_fru.h>

#include <OpenIPMI/internal/ipmi_entity.h>
#include <OpenIPMI/internal/ipmi_sensor.h>
#include <OpenIPMI/internal/ipmi_control.h>

/* Handle validation and usecounts on domains. */
int i_ipmi_domain_get(ipmi_domain_t *domain);
void i_ipmi_domain_put(ipmi_domain_t *domain);

/* Return the OS handler used by the mc. */
os_handler_t *ipmi_domain_get_os_hnd(ipmi_domain_t *domain);

/* Return the entity info for the given domain. */
ipmi_entity_info_t *ipmi_domain_get_entities(ipmi_domain_t *domain);

/* Should the BMC do a full bus scan at startup?  This is so OEM
   code can turn this function off.  The value is a boolean. */
int ipmi_domain_set_full_bus_scan(ipmi_domain_t *domain, int val);

int ipmi_domain_get_event_rcvr(ipmi_domain_t *domain);

/* Allocate an MC in the domain.  It doesn't add it to the domain's
   list, to allow the MC to be setup before that happens. */
int ipmi_create_mc(ipmi_domain_t     *domain,
		   const ipmi_addr_t *addr,
		   unsigned int      addr_len,
		   ipmi_mc_t         **new_mc);

int i_ipmi_remove_mc_from_domain(ipmi_domain_t *domain, ipmi_mc_t *mc);

/* Attempt to find the MC, and if it doesn't exist create it and
   return it. */
int i_ipmi_find_or_create_mc_by_slave_addr(ipmi_domain_t *domain,
					   unsigned int  channel,
					   unsigned int  slave_addr,
					   ipmi_mc_t     **mc);

/* Find the MC with the given IPMI address, or return NULL if not
   found. */
ipmi_mc_t *i_ipmi_find_mc_by_addr(ipmi_domain_t     *domain,
				  const ipmi_addr_t *addr,
				  unsigned int      addr_len);

/* Return the SDRs for the given MC, or the main set of SDRs if the MC
   is NULL. */
void i_ipmi_get_sdr_sensors(ipmi_domain_t *domain,
			    ipmi_mc_t     *mc,
			    ipmi_sensor_t ***sensors,
			    unsigned int  *count);

/* Set the SDRs for the given MC, or the main set of SDRs if the MC is
   NULL. */
void i_ipmi_set_sdr_sensors(ipmi_domain_t *domain,
			    ipmi_mc_t     *mc,
			    ipmi_sensor_t **sensors,
			    unsigned int  count);

/* Returns/set the SDRs entity info for the given MC, or the main set
   of SDRs if the MC is NULL. */
void *i_ipmi_get_sdr_entities(ipmi_domain_t *domain,
			     ipmi_mc_t     *mc);
void i_ipmi_set_sdr_entities(ipmi_domain_t *domain,
			    ipmi_mc_t     *mc,
			    void          *entities);

/* Add an MC to the list of MCs in the domain. */
int ipmi_add_mc_to_domain(ipmi_domain_t *domain, ipmi_mc_t *mc);

/* Remove an MC from the list of MCs in the domain. */
int ipmi_remove_mc_from_domain(ipmi_domain_t *domain, ipmi_mc_t *mc);

/* The old interfaces (for backwards compatability).  DON'T USE THESE!! */
struct ipmi_domain_mc_upd_s;
typedef struct ipmi_domain_mc_upd_s ipmi_domain_mc_upd_t
     IPMI_TYPE_DEPRECATED;
int ipmi_domain_register_mc_update_handler(ipmi_domain_t         *domain,
					   ipmi_domain_mc_upd_cb handler,
					   void                  *cb_data,
					   struct ipmi_domain_mc_upd_s  **id)
     IPMI_FUNC_DEPRECATED;
void ipmi_domain_remove_mc_update_handler(ipmi_domain_t        *domain,
					  struct ipmi_domain_mc_upd_s *id)
     IPMI_FUNC_DEPRECATED;

/* Call any OEM handlers for the given MC. */
int i_ipmi_domain_check_oem_handlers(ipmi_domain_t *domain, ipmi_mc_t *mc);

/* Scan a system interface address for an MC. */
int ipmi_start_si_scan(ipmi_domain_t *domain,
		       int            si_num,
		       ipmi_domain_cb done_handler,
		       void           *cb_data);

/* Add an IPMB address to a list of addresses to not scan.  This way,
   if you have weak puny devices in IPMB that will break if you do
   normal IPMB operations, you can have them be ignored. */
int ipmi_domain_add_ipmb_ignore(ipmi_domain_t *domain,
				unsigned char channel,
				unsigned char ipmb_addr);
int ipmi_domain_add_ipmb_ignore_range(ipmi_domain_t *domain,
				      unsigned char channel,
				      unsigned char first_ipmb_addr,
				      unsigned char last_ipmb_addr);

/* If OEM code gets and event and it doesn't deliver it to the user,
   it should deliver it this way, that way it can be delivered to the
   user to be deleted. */
void ipmi_handle_unhandled_event(ipmi_domain_t *domain, ipmi_event_t *event);

/* Handle a new event from something, usually from an SEL. */
void i_ipmi_domain_system_event_handler(ipmi_domain_t *domain,
				       ipmi_mc_t     *mc,
				       ipmi_event_t  *event);

/* Returns the main SDR repository for the domain, or NULL if there is
   not one. */
ipmi_sdr_info_t *ipmi_domain_get_main_sdrs(ipmi_domain_t *domain);

/* Get the number of channels the domain supports. */
int ipmi_domain_get_num_channels(ipmi_domain_t *domain, int *val);

/* Get information about a channel by index.  The index is not
   necessarily the channel number, just an array index (up to the
   number of channels).  Get the channel number from the returned
   information. */
int ipmi_domain_get_channel(ipmi_domain_t    *domain,
			    int              index,
			    ipmi_chan_info_t *chan);

/* These calls deal with OEM-type handlers for domains.  Certain
   domains can be detected with special means (beyond just the
   manufacturer and product id) and this allows handlers for these
   types of domains to be registered.  At the very initial connection
   of every domain, the handler will be called and it must detect
   whether this is the specific type of domain or not, do any setup
   for that domain type, and then call the done routine passed in.
   Note that the done routine may be called later, (allowing this
   handler to send messages and the like) but it *must* be called.
   Note that the error value in the check_done routine should be
   ENOSYS if the specific OEM handlers were not applicable, 0 if the
   OEM handlers were installed, and anything else for specific
   errors installing the OEM handlers. */
typedef void (*ipmi_domain_oem_check_done)(ipmi_domain_t *domain,
					   int           err,
					   void          *cb_data);
typedef int (*ipmi_domain_oem_check)(ipmi_domain_t              *domain,
				     ipmi_domain_oem_check_done done,
				     void                       *cb_data);
int ipmi_register_domain_oem_check(ipmi_domain_oem_check check,
				   void                  *cb_data);
int ipmi_deregister_domain_oem_check(ipmi_domain_oem_check check,
				     void                  *cb_data);

/* Register OEM data for the domain.  Note that you can set a function
   that will be called after all the domain messages have been flushed
   but before anything else is destroyed.  If the OEM data or
   destroyer is NULL, it will not be called. */
typedef void (*ipmi_domain_destroy_oem_data_cb)(ipmi_domain_t *domain,
						void          *oem_data);
void ipmi_domain_set_oem_data(ipmi_domain_t                   *domain,
			      void                            *oem_data,
			      ipmi_domain_destroy_oem_data_cb destroyer);
void *ipmi_domain_get_oem_data(ipmi_domain_t *domain);

/* Register a call that will be done at the beginning of the domain
   shutdown process.  Setting it to NULL will disable it. */
typedef void (*ipmi_domain_shutdown_cb)(ipmi_domain_t *domain);
void ipmi_domain_set_oem_shutdown_handler(ipmi_domain_t           *domain,
					  ipmi_domain_shutdown_cb handler);

/* Used to implement special handling of FRU data for locking,
   timestamps, etc. */
typedef int (*i_ipmi_domain_fru_setup_cb)(ipmi_domain_t *domain,
					  unsigned char is_logical,
					  unsigned char device_address,
					  unsigned char device_id,
					  unsigned char lun,
					  unsigned char private_bus,
					  unsigned char channel,
					  ipmi_fru_t    *fru,
					  void          *cb_data);
int i_ipmi_domain_fru_set_special_setup(ipmi_domain_t             *domain,
					i_ipmi_domain_fru_setup_cb setup,
					void                      *cb_data);
int i_ipmi_domain_fru_call_special_setup(ipmi_domain_t *domain,
					 unsigned char is_logical,
					 unsigned char device_address,
					 unsigned char device_id,
					 unsigned char lun,
					 unsigned char private_bus,
					 unsigned char channel,
					 ipmi_fru_t    *fru);

/* Set the domain type for a domain. */
void ipmi_domain_set_type(ipmi_domain_t *domain, enum ipmi_domain_type dtype);

/* OEM code can call this to do its own bus scanning to speed things
   up. Must be holding the domain MC lock (i_ipmi_domain_mc_lock()) to
   call this. */
void i_ipmi_start_mc_scan_one(ipmi_domain_t *domain, int chan,
			      int first, int last);

/* Can be used to generate unique numbers for a domain. */
unsigned int ipmi_domain_get_unique_num(ipmi_domain_t *domain);

/* Initialize the domain code, called only once at init time. */
int i_ipmi_domain_init(void);

/* Clean up the global domain memory. */
void i_ipmi_domain_shutdown(void);

/* Is the domain currently in shutdown? */
int i_ipmi_domain_in_shutdown(ipmi_domain_t *domain);

/* Used as a refcount to know when the domain is completely
   operational. */
void i_ipmi_get_domain_fully_up(ipmi_domain_t *domain, const char *name);
void i_ipmi_put_domain_fully_up(ipmi_domain_t *domain, const char *name);

/* Return connections for a domain. */
int i_ipmi_domain_get_connection(ipmi_domain_t *domain,
				 int           con_num,
				 ipmi_con_t    **con);

/* Option settings. */
int ipmi_option_SDRs(ipmi_domain_t *domain);
int ipmi_option_SEL(ipmi_domain_t *domain);
int ipmi_option_FRUs(ipmi_domain_t *domain);
int ipmi_option_IPMB_scan(ipmi_domain_t *domain);
int ipmi_option_OEM_init(ipmi_domain_t *domain);
int ipmi_option_set_event_rcvr(ipmi_domain_t *domain);
int ipmi_option_set_sel_time(ipmi_domain_t *domain);
int ipmi_option_activate_if_possible(ipmi_domain_t *domain);
int ipmi_option_local_only(ipmi_domain_t *domain);
int ipmi_option_use_cache(ipmi_domain_t *domain);

void i_ipmi_option_set_local_only_if_not_specified(ipmi_domain_t *domain,
						   int           val);

/*
 * Domain attribute handling.
 *
 * An attribute is a string name that is registered with the domain along
 * with a void data item.  This allows things to be attached to the domain
 * but not directly coupled to the domain.  Names that begin with "ipmi_"
 * belong to OpenIPMI, DON'T USE THEM.  OEM names should start with
 * "oem_<type>_".  Other names are free for use by the application.
 *
 * Note that attributes are ummutable after creation and cannot be
 * destroyed.  Destruction only happens when the domain goes away, but
 * may be delayed to after the domain is gone due to race conditions.
 */

/* Attr init function.  Return the data item in the data field.  Returns
   an error value. */
typedef int (*ipmi_domain_attr_init_cb)(ipmi_domain_t *domain, void *cb_data,
					void **data);

/* Called when the attribute is destroyed.  Note that this may happen
   after domain destruction, so the domain may not exist any more. */
typedef void (*ipmi_domain_attr_kill_cb)(void *cb_data, void *data);

typedef struct ipmi_domain_attr_s ipmi_domain_attr_t;

/* Find an attribute for a domain.  If the attribute is not found,
   register the attribute.  If the registration occurs, the init()
   function will be called (if non-null); it must return the data item
   in the data field.  When the domain is destroyed, the destroy
   function will be called (if not null). */
int ipmi_domain_register_attribute(ipmi_domain_t            *domain,
				   char                     *name,
				   ipmi_domain_attr_init_cb init,
				   ipmi_domain_attr_kill_cb destroy,
				   void                     *cb_data,
				   ipmi_domain_attr_t       **attr);

/* Find an attribute in an domain.  Returns EINVAL if the name is not
   registered.  Returns 0 on success, and the data item is
   returned. */
int ipmi_domain_find_attribute(ipmi_domain_t      *domain,
			       char               *name,
			       ipmi_domain_attr_t **attr);

/* Like the previous call, but takes a domain id. */
int ipmi_domain_id_find_attribute(ipmi_domain_id_t   domain_id,
				  char               *name,
				  ipmi_domain_attr_t **data);

/* Get the data item from the attr. */
void *ipmi_domain_attr_get_data(ipmi_domain_attr_t *attr);

/* Call this when you are done with the attr. */
void ipmi_domain_attr_put(ipmi_domain_attr_t *attr);

/* Add/Remove a function, that is called when any new sensor is
   added to the system and it allows OEM code to update information
   about  it if there are domain-specific sensor types that need
   to be adjusted.
*/
typedef void (*ipmi_domain_sensor_cb)(ipmi_domain_t *domain,
                                      ipmi_sensor_t *sensor,
                                      void          *cb_data);

int
ipmi_domain_add_new_sensor_handler(ipmi_domain_t         *domain,
                                   ipmi_domain_sensor_cb handler,
                                   void                  *cb_data);

int
ipmi_domain_remove_new_sensor_handler(ipmi_domain_t        *domain,
                                      ipmi_domain_sensor_cb handler,
                                      void                *cb_data);

int
i_call_new_sensor_handlers(ipmi_domain_t *domain,
                         ipmi_sensor_t *sensor);


#endif /* OPENIPMI_DOMAIN_H */
