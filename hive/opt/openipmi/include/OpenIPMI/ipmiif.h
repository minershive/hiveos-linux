/*
 * ipmiif.h
 *
 * MontaVista IPMI main interface
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

#ifndef OPENIPMIIF_H
#define OPENIPMIIF_H

#include <time.h>
#include <OpenIPMI/ipmi_types.h>
#include <OpenIPMI/ipmi_bits.h>
#include <OpenIPMI/os_handler.h>
#include <OpenIPMI/deprecator.h>

#ifdef __cplusplus
extern "C" {
#endif

/* For version detection */
#define OPENIPMI_VERSION_MAJOR 2
#define OPENIPMI_VERSION_MINOR 0
#define OPENIPMI_VERSION_RELEASE 26
#define OPENIPMI_VERSION_EXTRA 
#define OPENIPMI_STRINGX(x) #x
#define OPENIPMI_XSTRING(x) OPENIPMI_STRINGX(x)
#define OPENIPMI_VERSION OPENIPMI_XSTRING(OPENIPMI_VERSION_MAJOR) \
        "." OPENIPMI_XSTRING(OPENIPMI_VERSION_MINOR) \
        "." OPENIPMI_XSTRING(OPENIPMI_VERSION_RELEASE) \
        OPENIPMI_XSTRING(OPENIPMI_VERSION_EXTRA)

/* Return the version number (ie "1.2.7") of the OpenIPMI library in
   use. */
char *ipmi_openipmi_version(void);


/*
 * This is the main include file for dealing with IPMI.  It provides
 * an abstract interface to the IPMI system, so you don't have to deal
 * with all the nitty-gritty details of IPMI.  You only deal with
 * four things:
 *
 *  Domain - This is the main interface to the IPMI system.
 *  Entities - These are things that sensors monitor, they can be
 *             FRUs, or whatnot.
 *  Sensors - These are monitors for FRUs.
 *  Controls - These are output devices
 *
 * You don't have to deal with Management Controllers (MCs), IPMI
 * addressing, or anything like that.  This software will go out onto
 * the IPMB bus, detect all the MCs and entities present there, and
 * call you when it detects something.  It reads the SDR database and
 * detects all the entities and entity relationships.  It lets you add
 * entities and relationships to the local copies, and write the
 * information back into the database.
 *
 * You have to be careful with locking in this system.  The four things
 * you deal with all have two ways to get at them: An ID, and a pointer.
 * The ID is always valid, you can store that off on your own and use it
 * later.  The pointer is only valid inside a callback, the system is
 * free to change the pointers for a thing when no callbacks are active.
 *
 * To convert an ID to a pointer that you can work on, you have to go
 * through a callback.  These are provided for each type.  This is a
 * little inconvenient, but it's a lot faster than copying a lot of
 * data around all the time or re-validating an ID on every operation.
 * If a callback gives you a pointer to a sensor, entity, or domain, the
 * lock for that things will be held while you are in the callback.
 *
 * This interface is completely event-driven, meaning that a call will
 * never block.  Instead, if a call cannot complete inside the call
 * itself, you provide a "callback" that will be called when the
 * operation completes.  If you don't care about the results, you can
 * provide a NULL callback.  However, you will not receive any error
 * information about the operation; if it fails you will not know.
 * Note that if a function that you provide a callback returns an
 * error, the callback will NEVER be called.
 *
 * Callbacks are possible on things that have ceased to exist.  For
 * example, if you start an operation on a sensor and the sensor
 * ceases to exist during the operation, you will get an error
 * callback with a NULL sensor.  The same goes for controls, entities,
 * or anything else.
 *
 * You should NEVER block or exit in a callback.  Locks are held in
 * callbacks, so you will constipate the system if you block in
 * callbacks.  Just don't do it.
 */

/* This is the maximum size of any name in OpenIPMI */
#define IPMI_MAX_NAME_LEN 64

/* This is how you convert a pointer to and ID and convert an ID to a
   pointer.  Pointers are ONLY valid in callbacks, the system is free
   to change the pointer value outside the callback.  So you should
   only store IDs.  IDs are good all the time, but you must go through
   the "pointer_cb" functions to get a usable pointer you can operate
   on.  This is how the locking works for this, inside the callback
   you will hold the locks so the item you are using will not change.
   It's kind of a pain, but it improves reliability.  This way, you
   cannot "forget" to release the lock for something.  Note that this
   callback function you provide will be called immediately in the
   same thread of execution, this callback is not delayed or spawned
   off to another thread. */
/* The comparisons below return -1 if id1<id2, 0 if id1==id2, and 1 if
   id1>id2. */
/* This ipmi_xxx_id_set_invalid() functions set the passed in domain
   id to an invalid value that is always the same and guaranteed to be
   invalid. */
ipmi_domain_id_t ipmi_domain_convert_to_id(ipmi_domain_t *domain);
typedef void (*ipmi_domain_ptr_cb)(ipmi_domain_t *domain, void *cb_data);
int ipmi_domain_pointer_cb(ipmi_domain_id_t   id,
			   ipmi_domain_ptr_cb handler,
			   void               *cb_data);
int ipmi_cmp_domain_id(ipmi_domain_id_t id1, ipmi_domain_id_t id2);
void ipmi_domain_id_set_invalid(ipmi_domain_id_t *id);
int ipmi_domain_id_is_invalid(const ipmi_domain_id_t *id);

ipmi_entity_id_t ipmi_entity_convert_to_id(ipmi_entity_t *ent);
int ipmi_cmp_entity_id(ipmi_entity_id_t id1, ipmi_entity_id_t id2);
typedef void (*ipmi_entity_ptr_cb)(ipmi_entity_t *entity, void *cb_data);
int ipmi_entity_pointer_cb(ipmi_entity_id_t   id,
			   ipmi_entity_ptr_cb handler,
			   void               *cb_data);
int ipmi_entity_find_id(ipmi_domain_id_t domain_id,
			int entity_id, int entity_instance,
			int channel, int slave_address,
			ipmi_entity_id_t *id);
int ipmi_cmp_entity_id(ipmi_entity_id_t id1, ipmi_entity_id_t id2);
void ipmi_entity_id_set_invalid(ipmi_entity_id_t *id);
int ipmi_entity_id_is_invalid(const ipmi_entity_id_t *id);

ipmi_sensor_id_t ipmi_sensor_convert_to_id(ipmi_sensor_t *sensor);
typedef void (*ipmi_sensor_ptr_cb)(ipmi_sensor_t *sensor, void *cb_data);
int ipmi_sensor_pointer_cb(ipmi_sensor_id_t   id,
			   ipmi_sensor_ptr_cb handler,
			   void               *cb_data);
int ipmi_cmp_sensor_id(ipmi_sensor_id_t id1, ipmi_sensor_id_t id2);
int ipmi_sensor_find_id(ipmi_domain_id_t domain_id,
			int entity_id, int entity_instance,
			int channel, int slave_address,
			char *id_name,
			ipmi_sensor_id_t *id);
void ipmi_sensor_id_set_invalid(ipmi_sensor_id_t *id);
int ipmi_sensor_id_is_invalid(const ipmi_sensor_id_t *id);

ipmi_control_id_t ipmi_control_convert_to_id(ipmi_control_t *control);
typedef void (*ipmi_control_ptr_cb)(ipmi_control_t *control, void *cb_data);
int ipmi_control_pointer_cb(ipmi_control_id_t   id,
			    ipmi_control_ptr_cb handler,
			    void                *cb_data);
int ipmi_cmp_control_id(ipmi_control_id_t id1, ipmi_control_id_t id2);
int ipmi_control_find_id(ipmi_domain_id_t domain_id,
			 int entity_id, int entity_instance,
			 int channel, int slave_address,
			 char *id_name,
			 ipmi_control_id_t *id);
void ipmi_control_id_set_invalid(ipmi_control_id_t *id);
int ipmi_control_id_is_invalid(const ipmi_control_id_t *id);


/************************************************************************
 * 
 * Domains
 *
 ***********************************************************************/

/* Callback used for generic domain reporting. */
typedef void (*ipmi_domain_cb)(ipmi_domain_t *domain, int err, void *cb_data);

/* Iterate through all the domains. */
void ipmi_domain_iterate_domains(ipmi_domain_ptr_cb handler,
				 void               *cb_data);

/* Get the "name" for the domain.  Returns the length of the string
   (minus the closing \0). */
#define IPMI_DOMAIN_NAME_LEN 32
int ipmi_domain_get_name(ipmi_domain_t *domain, char *name, int length);

/* Domains come in different flavors.  It might be useful to know the
   type of domain you are hooked to, so this function will return the
   domain type (assuming it can be determined).  Also includes a
   function to convert the name to a human-readable string. */
enum ipmi_domain_type
{
    IPMI_DOMAIN_TYPE_UNKNOWN = 0,
    IPMI_DOMAIN_TYPE_MXP,
    IPMI_DOMAIN_TYPE_ATCA,
    IPMI_DOMAIN_TYPE_ATCA_BLADE /* A local blade domain on an ATCA system */
};
enum ipmi_domain_type ipmi_domain_get_type(ipmi_domain_t *domain);
const char *ipmi_domain_get_type_string(enum ipmi_domain_type dtype);

/* Return the system GUID for the domain.  The guid must point to an
   array of 16 characters.  Returns ENOSYS if the domain didn't have a
   GUID. */
int ipmi_domain_get_guid(ipmi_domain_t *domain, unsigned char *guid);

/* Add and remove a function to be called when the connection or port
   to the domain goes down or back up.  Being down does NOT mean the
   domain has been shutdown, it is still active, and OpenIPMI will
   continue to attempt to reconnect to the domain.  When the
   connection goes down, The "err" value in the callback will be
   non-zero to report the reason for the failure.  When the connection
   goes up, the "err" value will be zero reporting that the connection
   is now available.  The particular connections that went up or down
   is reported.  conn_num is the connection number (which ipmi_con_t
   supplied in the array at startup), port_num is the particular port
   on the connection, and depends on the connection type.
   still_connected is true if the system still has a valid connection
   to the target, or false if all connection are gone.  Note that the
   connect change handler is called with a lock held, but the lock is
   only used for that purpose (to sequence connection changes
   delivered to the user).  This means that you cannot do something
   that will call another connection change from within a connection
   change handler, basically you cannot perform operations that wait
   for I/O. */
typedef void (*ipmi_domain_con_cb)(ipmi_domain_t *domain,
				   int           err,
				   unsigned int  conn_num,
				   unsigned int  port_num,
				   int           still_connected,
				   void          *cb_data);
int ipmi_domain_add_connect_change_handler(ipmi_domain_t      *domain,
					   ipmi_domain_con_cb handler,
					   void               *cb_data);
int ipmi_domain_remove_connect_change_handler(ipmi_domain_t      *domain,
					      ipmi_domain_con_cb handler,
					      void               *cb_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_domain_con_cl_cb)(ipmi_domain_con_cb handler,
				      void               *handler_val,
				      void               *cb_data);
int ipmi_domain_add_connect_change_handler_cl(ipmi_domain_t         *domain,
					      ipmi_domain_con_cl_cb handler,
					      void                  *cb_data);
int ipmi_domain_remove_connect_change_handler_cl(ipmi_domain_t         *domain,
						 ipmi_domain_con_cl_cb handler,
						 void                  *cb_data);

/* Scan a set of addresses on the bmc for mcs.  This can be used by OEM
   code to add an MC if it senses that one has become present. */
int ipmi_start_ipmb_mc_scan(ipmi_domain_t  *domain,
			    int            channel,
			    unsigned int   start_addr,
			    unsigned int   end_addr,
			    ipmi_domain_cb done_handler,
			    void           *cb_data);

/* Rescan every channel in the domain. */
void ipmi_domain_start_full_ipmb_scan(ipmi_domain_t *domain);

/* Register a handler to be called when an MC is added to the domain
   or removed from the domain. */
typedef void (*ipmi_domain_mc_upd_cb)(enum ipmi_update_e op,
				      ipmi_domain_t      *domain,
				      ipmi_mc_t          *mc,
				      void               *cb_data);
int ipmi_domain_add_mc_updated_handler(ipmi_domain_t         *domain,
				       ipmi_domain_mc_upd_cb handler,
				       void                  *cb_data);
int ipmi_domain_remove_mc_updated_handler(ipmi_domain_t         *domain,
					  ipmi_domain_mc_upd_cb handler,
					  void                  *cb_data);
/* Called for each handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_domain_mc_upd_cl_cb)(ipmi_domain_mc_upd_cb handler,
					 void                  *handler_data,
					 void                  *cb_data);
int ipmi_domain_add_mc_updated_handler_cl(ipmi_domain_t            *domain,
					  ipmi_domain_mc_upd_cl_cb handler,
					  void                     *cb_data);
int ipmi_domain_remove_mc_updated_handler_cl(ipmi_domain_t            *domain,
					     ipmi_domain_mc_upd_cl_cb handler,
					     void                    *cb_data);

/* Iterate over all the mc's that the given domain represents. */
typedef void (*ipmi_domain_iterate_mcs_cb)(ipmi_domain_t *domain,
					   ipmi_mc_t     *mc,
					   void          *cb_data);
int ipmi_domain_iterate_mcs(ipmi_domain_t              *domain,
			    ipmi_domain_iterate_mcs_cb handler,
			    void                       *cb_data);
int ipmi_domain_iterate_mcs_rev(ipmi_domain_t              *domain,
				ipmi_domain_iterate_mcs_cb handler,
				void                       *cb_data);

/* Like ipmi_mc_send_command, but sends it directly to the address
   specified, not to an MC. */
typedef int (*ipmi_addr_response_handler_t)(ipmi_domain_t *domain,
					    ipmi_msgi_t   *rspi);
int
ipmi_send_command_addr(ipmi_domain_t                *domain,
		       const ipmi_addr_t            *addr,
		       unsigned int                 addr_len,
		       const ipmi_msg_t             *msg,
		       ipmi_addr_response_handler_t rsp_handler,
		       void                         *rsp_data1,
		       void                         *rsp_data2);
int
ipmi_send_command_addr_sideeff(ipmi_domain_t                *domain,
			       const ipmi_addr_t            *addr,
			       unsigned int                 addr_len,
			       const ipmi_msg_t             *msg,
			       ipmi_addr_response_handler_t rsp_handler,
			       void                         *rsp_data1,
			       void                         *rsp_data2);

/* Rescan the entities for possible presence changes.  "force" causes
   a full rescan even if nothing on an entity has changed. */
int ipmi_detect_domain_presence_changes(ipmi_domain_t *domain, int force);


/* The domain has two timers, one for the SEL rescan interval and one for
   the IPMB bus rescan interval. */

/* The SEL rescan timer is the time between when the SEL will be
   checked for new events.  This timer is in seconds, and will
   currently default to 10 seconds.  You need to set this depending on
   how fast you need to know if events have come in.  If you set this
   value to zero, it will turn off SEL scanning. */
void ipmi_domain_set_sel_rescan_time(ipmi_domain_t *domain,
				     unsigned int  seconds);
unsigned int ipmi_domain_get_sel_rescan_time(ipmi_domain_t *domain);

/* The IPMB rescan timer is the time between scans of the IPMB bus to
   see if new MCs have appeared on the bus.  The timer is in seconds,
   and defaults to 600 seconds (10 minutes).  The setting of this
   timer depends on how fast you need to know if new devices have
   appeared, and if your system has proprietary extensions to detect
   insertion of devices more quickly.  */
void ipmi_domain_set_ipmb_rescan_time(ipmi_domain_t *domain,
				      unsigned int  seconds);
unsigned int ipmi_domain_get_ipmb_rescan_time(ipmi_domain_t *domain);

/* Events come in this format. */
typedef void (*ipmi_event_handler_cb)(ipmi_domain_t *domain,
				      ipmi_event_t  *event,
				      void          *event_data);

/* Register a handler to receive events.  Multiple handlers may be
   registered, they will all receive all events.  The event_data will
   be passed in with every event received.  This will only catch
   events that are not sent to a sensor, so if you get a system
   software event or an event from a sensor the software doesn't know
   about, this handler will get it. */
int ipmi_domain_add_event_handler(ipmi_domain_t           *domain,
				  ipmi_event_handler_cb   handler,
				  void                    *event_data);
/* Deregister an event handler. */
int ipmi_domain_remove_event_handler(ipmi_domain_t           *domain,
				     ipmi_event_handler_cb   handler,
				     void                    *event_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_event_handler_cl_cb)(ipmi_event_handler_cb handler,
					 void                  *handler_data,
					 void                  *cb_data);
int ipmi_domain_add_event_handler_cl(ipmi_domain_t            *domain,
				     ipmi_event_handler_cl_cb handler,
				     void                     *event_data);
int ipmi_domain_remove_event_handler_cl(ipmi_domain_t            *domain,
					ipmi_event_handler_cl_cb handler,
					void                     *event_data);

/* Globally enable or disable events on the domain's interfaces. */
int ipmi_domain_enable_events(ipmi_domain_t *domain);
int ipmi_domain_disable_events(ipmi_domain_t *domain);

/* This is the old domain event deleter.  Since events now carry with
   them more useful information, there is no need for this any more,
   but it still works. */
int ipmi_domain_del_event(ipmi_domain_t  *domain,
			  ipmi_event_t   *event,
			  ipmi_domain_cb done_handler,
			  void           *cb_data);

/* You can also scan the current set of events stored in the system.
   They return an NULL if the SEL is empty, or if you try to go past
   the last or before the first event.  The first and last function
   return the event, the next and prev function take the current event
   in "event" and return the next or previous event in "event".  Note
   that you must free any events returned with this using
   ipmi_event_free(). */
ipmi_event_t *ipmi_domain_first_event(ipmi_domain_t *domain);
ipmi_event_t *ipmi_domain_last_event(ipmi_domain_t *domain);
ipmi_event_t *ipmi_domain_next_event(ipmi_domain_t *domain,
				     const ipmi_event_t *p);
ipmi_event_t *ipmi_domain_prev_event(ipmi_domain_t *domain,
				     const ipmi_event_t *n);

/* Return the number of non-deleted entries in the local copy of the
   SEL. */
int ipmi_domain_sel_count(ipmi_domain_t *domain,
			  unsigned int  *count);

/* Return the number of entries estimated to be used in the real SEL.
   If there are deleted event in the local copy of the SEL, they are
   not necessarily deleted from the real SEL, so this takes that into
   account. */
int ipmi_domain_sel_entries_used(ipmi_domain_t *domain,
				 unsigned int  *count);

/* Force rereading all the SELs in the domain.  The handler will be
   called after they are all reread. */
int ipmi_domain_reread_sels(ipmi_domain_t  *domain,
			    ipmi_domain_cb handler,
			    void           *cb_data);

/* A callback that will be called when entities are added to and
   removed from the domain, and when their presence changes. */
typedef void (*ipmi_domain_entity_cb)(enum ipmi_update_e op,
				      ipmi_domain_t      *domain,
				      ipmi_entity_t      *entity,
				      void               *cb_data);

/* Add and remove and entity update handler.  This interface allows
   multiple handlers to be registered. */
int ipmi_domain_add_entity_update_handler(ipmi_domain_t         *domain,
					  ipmi_domain_entity_cb handler,
					  void                  *cb_data);
int ipmi_domain_remove_entity_update_handler(ipmi_domain_t         *domain,
					     ipmi_domain_entity_cb handler,
					     void                  *cb_data);
/* Called for each handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_domain_entity_cl_cb)(ipmi_domain_entity_cb handler,
					 void                  *handler_data,
					 void                  *cb_data);
int ipmi_domain_add_entity_update_handler_cl(ipmi_domain_t            *domain,
					     ipmi_domain_entity_cl_cb handler,
					     void                    *cb_data);
int ipmi_domain_remove_entity_update_handler_cl(ipmi_domain_t          *domain,
					     ipmi_domain_entity_cl_cb handler,
					     void                    *cb_data);

/* Iterate over all the entities in the domain, calling the given
   function with each entity.  The entities will not change while this
   is happening. */
typedef void (*ipmi_entities_iterate_entity_cb)(ipmi_entity_t *entity,
						void          *cb_data);
int ipmi_domain_iterate_entities(ipmi_domain_t                   *domain,
				 ipmi_entities_iterate_entity_cb handler,
				 void                            *cb_data);

/* Store all the information I have locally into the SDR repository.
   This is a moderately dangerous operation, as it can wipe out your
   SDR repository if you are not careful. */
int ipmi_domain_store_entities(ipmi_domain_t  *domain,
			       ipmi_domain_cb done,
			       void           *cb_data);

/* Returns if the domain thinks it has a connection up. */
int ipmi_domain_con_up(ipmi_domain_t *domain);

/*
 * Returns true if the domain has finished coming up, false if not.
 */
int ipmi_domain_is_fully_up(ipmi_domain_t *domain);

/* Iterate through the connections on a domain. */
typedef void (*ipmi_connection_ptr_cb)(ipmi_domain_t *domain, int conn,
				       void *cb_data);
void ipmi_domain_iterate_connections(ipmi_domain_t          *domain,
				     ipmi_connection_ptr_cb handler,
				     void                   *cb_data);

/* Attempt to activate a given connection. */
int ipmi_domain_activate_connection(ipmi_domain_t *domain,
				    unsigned int  connection);

/* Returns if a connection is active. */
int ipmi_domain_is_connection_active(ipmi_domain_t *domain,
				     unsigned int  connection,
				     unsigned int  *active);

/* Is the connection up? */
int ipmi_domain_is_connection_up(ipmi_domain_t *domain,
				 unsigned int  connection,
				 unsigned int  *up);

/* Number of ports in the connection?  A connection may have multiple
   ports (ie, multiple IP addresses to the same BMC, whereas a
   separate connection is a connection to a different BMC); these
   functions let you check their status. */
int ipmi_domain_num_connection_ports(ipmi_domain_t *domain,
				     unsigned int  connection,
				     unsigned int  *ports);

/* Is a specific port in the connection up? */
int ipmi_domain_is_connection_port_up(ipmi_domain_t *domain,
				      unsigned int  connection,
				      unsigned int  port,
				      unsigned int  *up);

/* Get information about a port.  This is a string that is
   interface-type dependent.  The length of "info" is passed in
   info_len, that returns the number of chars that would have been
   used, even if "info" was not long enough to hold it. */
int ipmi_domain_get_port_info(ipmi_domain_t *domain,
			      unsigned int  connection,
			      unsigned int  port,
			      char          *info,
			      int           *info_len);

/* Get the args for a domain's connection. */
ipmi_args_t *ipmi_domain_get_connection_args(ipmi_domain_t *domain,
					     unsigned int  connection);

/* Get the reported connection type for the connection. */
char *ipmi_domain_get_connection_type(ipmi_domain_t *domain,
				      unsigned int  connection);

/* Get the connection object for the given connection of the domain.
   The usecount of the connection is incremented.  NULL is returned if
   the connection is invalid or the connection does not support
   usecounts. */
ipmi_con_t *ipmi_domain_get_connection(ipmi_domain_t *domain,
				       unsigned int  connection);

/* Domain statistics are used to track information about things
   happening in the low-level code.  Each statistic has a name and an
   instance.  The name is general (it, "MC", the instance is the
   specific instance of the name. */
typedef struct ipmi_domain_stat_s ipmi_domain_stat_t;
typedef void (*ipmi_stat_cb)(ipmi_domain_t *domain, ipmi_domain_stat_t *stat,
			     void *cb_data);

/* Create a new statistic or return an existing one if the name and
   instance already exists.  You must put() the statistic when you are
   done with it. */
int ipmi_domain_stat_register(ipmi_domain_t      *domain,
			      const char         *name,
			      const char         *instance,
			      ipmi_domain_stat_t **stat);

/* Find a statistic by name and instance.  You must put() the
   statistic when you are done with it. */
int ipmi_domain_find_stat(ipmi_domain_t      *domain,
			  const char         *name,
			  const char         *instance,
			  ipmi_domain_stat_t **stat);

/* Say you are done with a statistic. */
void ipmi_domain_stat_put(ipmi_domain_stat_t *stat);

/* Increment the value of a statistic by the given amount.  Negative
   values are ok. */
void ipmi_domain_stat_add(ipmi_domain_stat_t *stat, int amount);

/* Get the value of the statistic. */
unsigned int ipmi_domain_stat_get(ipmi_domain_stat_t *stat);

/* Atomically get the value of the statistic and set it to zero. */
unsigned int ipmi_domain_stat_get_and_zero(ipmi_domain_stat_t *stat);

/* Get the name and instance of the statistic.  DON'T CHANGE THESE! */
const char *ipmi_domain_stat_get_name(ipmi_domain_stat_t *stat);
const char *ipmi_domain_stat_get_instance(ipmi_domain_stat_t *stat);

/* Iterate through all the statistics.  This will get and put the stat
   for you, you should not put the stat (unless you make your own
   copy). */
void ipmi_domain_stat_iterate(ipmi_domain_t *domain,
			      const char    *name,
			      const char    *instance,
			      ipmi_stat_cb  handler,
			      void          *cb_data);


/************************************************************************
 * 
 * Events
 *
 ***********************************************************************/

/* Events in OpenIPMI are opaque structures.  If an event is given to
   you in a callback (such as the event handler), you *cannot* keep
   that event, you may keep a duplicate made with ipmi_event_dup().
   If you fetch an event using ipmi_domain_xxx_event(), you are given
   a duplicated copy.  You *must* free that event, or you will leak.
   Note that the duplicates are currently kept with refcounts (since
   the events are immutable) so duplicating an event doesn't take any
   more memory or much CPU.  */

/* Copy an event.  If you need to keep your own local copy of an event
   (to delete later, for instance) you should use this. */
ipmi_event_t *ipmi_event_dup(ipmi_event_t *event);

/* When you are done with an event, you should free it.  This frees up
   the internal store for the event and removes it from the external
   system event event.  Note that you must delete every event you
   duplicate. Note that this does *NOT* remove the event from the
   event log, you have to call ipmi_event_delete() for that. */
void ipmi_event_free(ipmi_event_t *event);

/* When you are done with an event, you should delete it.  This
   removes the event from the local event queue and removes it from
   the external system event log. */
int ipmi_event_delete(ipmi_event_t   *event,
		      ipmi_domain_cb done_handler,
		      void           *cb_data);

/* Return the management controller that "owns" the event (where the
   event is stored, *not* the mc that generated the event). */
ipmi_mcid_t ipmi_event_get_mcid(const ipmi_event_t *event);

/* Return the sensor id the event is associated with.  Returns an
   invalid sensor id (test with ipmi_sensor_id_is_invalid()) if the
   event has no sensor.  The "sel_mc" is the MC that holds the SEL the
   event came from (fetched with ipmi_event_get_mcid()) and is only
   used for software ID based events.  You may pass in NULL if you
   don't care about software ID based events. */
ipmi_sensor_id_t ipmi_event_get_generating_sensor_id(ipmi_domain_t *domain,
						     ipmi_mc_t     *sel_mc,
						     const ipmi_event_t *event);

/* Return a unique (in the MC) record identifier for the event. */
unsigned int ipmi_event_get_record_id(const ipmi_event_t *event);

#define OPENIPMI_OEM_EVENT_START	0x10000
/* Return the event type.  Normal IPMI events should be in the
   000-0xff range.  Other events should start at
   OPENIPMI_OEM_EVENT_START and higher.*/
unsigned int ipmi_event_get_type(const ipmi_event_t *event);

/* Get the timestamp for the event.  This will be IPMI_INVALID_TIME if
   the timestamp is invalid. */
ipmi_time_t ipmi_event_get_timestamp(const ipmi_event_t *event);

/* Get the length of the data attached to the event. */
unsigned int ipmi_event_get_data_len(const ipmi_event_t *event);

/* Copy some of the data attached to the event, starting at the given
   offset to an array.  Copy "len" bytes. */
unsigned int ipmi_event_get_data(const ipmi_event_t *event,
				 unsigned char      *data,
				 unsigned int       offset,
				 unsigned int       len);

/* The following deal with interpreting existing events.  You can take
   an existing event and pass it through these functions to do the
   processing that normally happens on incoming events.

   To use this, you must allocate an event with
   ipmi_event_handlers_alloc() and set the event handlers you want
   (either threshold, discrete, or both) to be called for the event.
   The data in the event_handlers_t has no state, so you can use the
   same allocated event handler structure for multiple calls, eg you
   can allocate one ahead of time and use it for everything that needs
   those particular functions.

   Then call ipmi_event_call_handler() with the domain, event, and
   handlers.  It will return EINVAL if the sensor for the event is no
   longer value, EAGAIN if you didn't register an event handler for
   that type (threshold or discrete).  If successfull, the proper
   event handler will be called.

   The return values from the event handlers is currently ignored, but
   you should generally return either IPMI_EVENT_NOT_HANDLED or
   IPMI_EVENT_HANDLED or IPMI_EVENT_HANDLED_PASS depending on if you
   did or did not handle the event and whether you want other event
   handlers to see it. */

typedef struct ipmi_event_handlers_s ipmi_event_handlers_t;

typedef int (*ipmi_sensor_threshold_event_cb)(
    ipmi_sensor_t               *sensor,
    enum ipmi_event_dir_e       dir,
    enum ipmi_thresh_e          threshold,
    enum ipmi_event_value_dir_e high_low,
    enum ipmi_value_present_e   value_present,
    unsigned int                raw_value,
    double                      value,
    void                        *cb_data,
    ipmi_event_t                *event);

typedef int (*ipmi_sensor_discrete_event_cb)(
    ipmi_sensor_t         *sensor,
    enum ipmi_event_dir_e dir,
    int                   offset,
    int                   severity,
    int                   prev_severity,
    void                  *cb_data,
    ipmi_event_t          *event);

ipmi_event_handlers_t *ipmi_event_handlers_alloc(void);
void ipmi_event_handlers_free(ipmi_event_handlers_t *handlers);
void ipmi_event_handlers_set_threshold(ipmi_event_handlers_t         *handlers,
				       ipmi_sensor_threshold_event_cb handler);
void ipmi_event_handlers_set_discrete(ipmi_event_handlers_t         *handlers,
				      ipmi_sensor_discrete_event_cb handler);

int ipmi_event_call_handler(ipmi_domain_t         *domain,
			    ipmi_event_handlers_t *handlers,
			    ipmi_event_t          *event,
			    void                  *cb_data);

/************************************************************************
 * 
 * Entities
 *
 ***********************************************************************/

/* For the given entity, iterate over all the children of the entity,
   calling the given handler with each child.  The children will not
   change while this is happening. */
typedef void (*ipmi_entity_iterate_child_cb)(ipmi_entity_t *ent,
					     ipmi_entity_t *child,
					     void          *cb_data);
void ipmi_entity_iterate_children(ipmi_entity_t                *ent,
				  ipmi_entity_iterate_child_cb handler,
				  void                         *cb_data);

/* Iterate over the parents of the given entitiy.
   FIXME - can an entity have more than one parent? */
typedef void (*ipmi_entity_iterate_parent_cb)(ipmi_entity_t *ent,
					      ipmi_entity_t *parent,
					      void          *cb_data);
void ipmi_entity_iterate_parents(ipmi_entity_t                 *ent,
				 ipmi_entity_iterate_parent_cb handler,
				 void                          *cb_data);

/* Iterate over all the sensors of an entity. */
typedef void (*ipmi_entity_iterate_sensor_cb)(ipmi_entity_t *ent,
					      ipmi_sensor_t *sensor,
					      void          *cb_data);
void ipmi_entity_iterate_sensors(ipmi_entity_t                 *ent,
				 ipmi_entity_iterate_sensor_cb handler,
				 void                          *cb_data);

/* Iterate over all the controls of an entity. */
typedef void (*ipmi_entity_iterate_control_cb)(ipmi_entity_t  *ent,
					       ipmi_control_t *control,
					       void           *cb_data);
void ipmi_entity_iterate_controls(ipmi_entity_t                  *ent,
				  ipmi_entity_iterate_control_cb handler,
				  void                           *cb_data);

/* Add a handler to monitor the presence of an entity. This call
   allows multiple handlers to be attached to the entity.  It should
   return IPMI_EVENT_HANDLED if it handled the event,
   IPMI_EVENT_HANDLED_PASS if it handled the event but wants to allow
   other event handlers to see the event data, or
   IPMI_EVENT_NOT_HANDLED if it didn't handle the event.  "Handling"
   the event means that is will manage the event (delete it when it is
   time).  If no sensor handles the event, then it will be delivered
   to the "main" unhandled event handler for the domain. */
typedef int (*ipmi_entity_presence_change_cb)(ipmi_entity_t *entity,
					      int           present,
					      void          *cb_data,
					      ipmi_event_t  *event);
int ipmi_entity_add_presence_handler(ipmi_entity_t                  *ent,
				     ipmi_entity_presence_change_cb handler,
				     void                           *cb_data);
int ipmi_entity_remove_presence_handler
(ipmi_entity_t                  *ent,
 ipmi_entity_presence_change_cb handler,
 void                           *cb_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_entity_presence_cl_cb)
       (ipmi_entity_presence_change_cb handler,
	void                           *handler_data,
	void                           *cb_data);
int ipmi_entity_add_presence_handler_cl(ipmi_entity_t              *entity,
					ipmi_entity_presence_cl_cb handler,
					void                      *event_data);
int ipmi_entity_remove_presence_handler_cl(ipmi_entity_t              *entity,
					   ipmi_entity_presence_cl_cb handler,
					   void                   *event_data);

/* Detect if the presence of an entity has changed.  If "force" is zero,
   then it will only do this if OpenIPMI has some reason to think the
   presence has changed.  If "force" is non-zero, it will force OpenIPMI
   to detect the current presence of the entity. */
int ipmi_detect_entity_presence_change(ipmi_entity_t *entity, int force);

/* Handlers that are called after an entity becomes present when all
   the data for the entity is fetched. */
int ipmi_entity_add_fully_up_handler(ipmi_entity_t      *ent,
				     ipmi_entity_ptr_cb handler,
				     void               *cb_data);
int ipmi_entity_remove_fully_up_handler(ipmi_entity_t      *ent,
					ipmi_entity_ptr_cb handler,
					void               *cb_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_entity_fully_up_cl_cb)(ipmi_entity_ptr_cb handler,
					   void               *handler_data,
					   void               *cb_data);
int ipmi_entity_add_fully_up_handler_cl(ipmi_entity_t              *entity,
					ipmi_entity_fully_up_cl_cb handler,
					void                      *event_data);
int ipmi_entity_remove_fully_up_handler_cl(ipmi_entity_t              *entity,
					   ipmi_entity_fully_up_cl_cb handler,
					   void                   *event_data);

/*
 * Set a presence detector for an entity that will override normal
 * presence detection.  When the handler is called, it must either
 * return an error or call ipmi_entity_detector_done().  It must do
 * one of those and must not do both.
 *
 * To set the presence back to normal means, the detector can be
 * set to NULL.
 */
typedef int (*ipmi_entity_presence_detect_cb)(ipmi_entity_t *entity,
					      void *handler_data);
void ipmi_entity_set_presence_detector(ipmi_entity_t *entity,
				       ipmi_entity_presence_detect_cb handler,
				       void *handler_data);
void ipmi_entity_detector_done(ipmi_entity_t *entity,
			       int present);
  
/* Type of entities.  Note that you will never see EAR and DREAR
   entities, so don't worry about those. */
enum ipmi_dlr_type_e { IPMI_ENTITY_UNKNOWN = 0,
		       IPMI_ENTITY_MC,
		       IPMI_ENTITY_FRU,
		       IPMI_ENTITY_GENERIC,
		       IPMI_ENTITY_EAR,
		       IPMI_ENTITY_DREAR };

/* Get information about an entity.  Most of this is IPMI specific. */

/* The entity type.  Depending on the return value from this,
   different field will be valid as marked below. */
enum ipmi_dlr_type_e ipmi_entity_get_type(ipmi_entity_t *ent);

/* These are valid for all entities. */

/* Get a useful string name for the entity.  The return value is the
   number of characters in the string put into name.  The length is the
   length of the "name" array. */
#define IPMI_ENTITY_NAME_LEN (IPMI_DOMAIN_NAME_LEN + 32)
int ipmi_entity_get_name(ipmi_entity_t *entity, char *name, int length);

int ipmi_entity_get_is_fru(ipmi_entity_t *ent);
ipmi_domain_t *ipmi_entity_get_domain(ipmi_entity_t *ent);
int ipmi_entity_get_entity_id(ipmi_entity_t *ent);
int ipmi_entity_get_entity_instance(ipmi_entity_t *ent);
/* If the entity instance is 0x60 or greater, then the channel and
   address are also important since the entity is device-relative. */
int ipmi_entity_get_device_channel(ipmi_entity_t *ent);
int ipmi_entity_get_device_address(ipmi_entity_t *ent);

/* Return the FRU for this entity, or NULL if it doesn't have one
   or the fetch has not completed. */
ipmi_fru_t *ipmi_entity_get_fru(ipmi_entity_t *ent);

int ipmi_entity_get_presence_sensor_always_there(ipmi_entity_t *ent);
int ipmi_entity_get_is_child(ipmi_entity_t *ent);
int ipmi_entity_get_is_parent(ipmi_entity_t *ent);

/* Valid for all entities except unknown. */
int ipmi_entity_get_channel(ipmi_entity_t *ent);
int ipmi_entity_get_lun(ipmi_entity_t *ent);
int ipmi_entity_get_oem(ipmi_entity_t *ent);

/* Valid for FRU and Generic */
int ipmi_entity_get_access_address(ipmi_entity_t *ent);
int ipmi_entity_get_private_bus_id(ipmi_entity_t *ent);
int ipmi_entity_get_device_type(ipmi_entity_t *ent);
int ipmi_entity_get_device_modifier(ipmi_entity_t *ent);

/* Valid for MC and Generic */
int ipmi_entity_get_slave_address(ipmi_entity_t *ent);
int ipmi_entity_get_mc_id(ipmi_entity_t *ent, ipmi_mcid_t *mc_id);

/* Valid for FRU only. */
int ipmi_entity_get_is_logical_fru(ipmi_entity_t *ent);
int ipmi_entity_get_fru_device_id(ipmi_entity_t *ent);

/* Valid for MC only */
int ipmi_entity_get_ACPI_system_power_notify_required(ipmi_entity_t *ent);
int ipmi_entity_get_ACPI_device_power_notify_required(ipmi_entity_t *ent);
int ipmi_entity_get_controller_logs_init_agent_errors(ipmi_entity_t *ent);
int ipmi_entity_get_log_init_agent_errors_accessing(ipmi_entity_t *ent);
int ipmi_entity_get_global_init(ipmi_entity_t *ent);
int ipmi_entity_get_chassis_device(ipmi_entity_t *ent);
int ipmi_entity_get_bridge(ipmi_entity_t *ent);
int ipmi_entity_get_IPMB_event_generator(ipmi_entity_t *ent);
int ipmi_entity_get_IPMB_event_receiver(ipmi_entity_t *ent);
int ipmi_entity_get_FRU_inventory_device(ipmi_entity_t *ent);
int ipmi_entity_get_SEL_device(ipmi_entity_t *ent);
int ipmi_entity_get_SDR_repository_device(ipmi_entity_t *ent);
int ipmi_entity_get_sensor_device(ipmi_entity_t *ent);

/* Valid for Generic only */
int ipmi_entity_get_address_span(ipmi_entity_t *ent);

/* Get the string name for the entity ID. */
const char *ipmi_entity_get_entity_id_string(ipmi_entity_t *ent);

/* The ID from the SDR. */
int ipmi_entity_get_id_length(ipmi_entity_t *ent);
enum ipmi_str_type_e ipmi_entity_get_id_type(ipmi_entity_t *ent);
int ipmi_entity_get_id(ipmi_entity_t *ent, char *id, int length);

/* This can be set bo OEM code to register the "slot number" an entity
   is in.  This returns ENOSYS if the entity does not have a slot number
   associated with it. */
int ipmi_entity_get_physical_slot_num(ipmi_entity_t *ent,
				      unsigned int *slot_num);

/* Is the entity currently present?  Note that this value can change
   dynamically, so an "_id_" function is provided, too, that takes an
   entity id as well as an entity.  Note that this call returns an
   error can fail if the entity has ceased to exist. */
int ipmi_entity_is_present(ipmi_entity_t *ent);
int ipmi_entity_id_is_present(ipmi_entity_id_t id, int *present);

/* A generic callback for entities. */
typedef void (*ipmi_entity_cb)(ipmi_entity_t *ent,
			       int           err,
			       void          *cb_data);
typedef void (*ipmi_entity_val_cb)(ipmi_entity_t *ent,
				   int           err,
				   int           val,
				   void          *cb_data);
typedef void (*ipmi_entity_time_cb)(ipmi_entity_t  *ent,
				    int            err,
				    ipmi_timeout_t val,
				    void           *cb_data);

/* Register a handler that will be called fru information is added,
   deleted, or modified.  If you call this in the entity added
   callback for the domain, you are guaranteed to get this set before
   any fru exists.  The "add/remove" function allow multiple handlers
   to be added.

   This is deprecated, use the version below with werr.  If the FRU update
   has an issue, this interface is unable to report that. */
typedef void (*ipmi_entity_fru_cb)(enum ipmi_update_e op,
				   ipmi_entity_t      *ent,
				   void               *cb_data);
int ipmi_entity_add_fru_update_handler(ipmi_entity_t     *ent,
				       ipmi_entity_fru_cb handler,
				       void              *cb_data);
int ipmi_entity_remove_fru_update_handler(ipmi_entity_t     *ent,
					  ipmi_entity_fru_cb handler,
					  void              *cb_data);

/*
 * Like the about, but with error handling.  You will get an
 * IPMIE_ADDED if the FRU data is added and it wasn't already present,
 * IPMIE_DELETED if the FRU data was present and the FRU becomes not
 * present, IPMIE_CHANGED if FRU data was already present and changed
 * for some reason (SDR update, for instance) and IPMIE_ERROR if the
 * FRU data fetch fails.  If you get IPMIE_ERROR, if FRU data was
 * already present then the old data will still be kept.  The "err"
 * value is only set for IPMIE_ERROR.
 */
typedef void (*ipmi_entity_fru_werr_cb)(enum ipmi_update_werr_e op,
					int                     err,
					ipmi_entity_t           *ent,
					void                    *cb_data);
int ipmi_entity_add_fru_update_werr_handler(ipmi_entity_t      *ent,
				       ipmi_entity_fru_werr_cb handler,
				       void                    *cb_data);
int ipmi_entity_remove_fru_update_werr_handler(ipmi_entity_t           *ent,
					       ipmi_entity_fru_werr_cb handler,
					       void                    *cb_data);

/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_entity_fru_cl_cb)(ipmi_entity_fru_cb handler,
				      void               *handler_data,
				      void               *cb_data);
int ipmi_entity_add_fru_update_handler_cl(ipmi_entity_t         *entity,
					  ipmi_entity_fru_cl_cb handler,
					  void                  *event_data);
int ipmi_entity_remove_fru_update_handler_cl(ipmi_entity_t         *entity,
					     ipmi_entity_fru_cl_cb handler,
					     void                 *event_data);
/* Called for updated with err handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_entity_fru_werr_cl_cb)(ipmi_entity_fru_werr_cb handler,
					   void               *handler_data,
					   void               *cb_data);
int ipmi_entity_add_fru_update_werr_handler_cl(ipmi_entity_t         *entity,
					  ipmi_entity_fru_werr_cl_cb handler,
					  void                  *event_data);
int ipmi_entity_remove_fru_update_werr_handler_cl(ipmi_entity_t         *entity,
					     ipmi_entity_fru_werr_cl_cb handler,
					     void                 *event_data);


/* Register a handler that will be called when a sensor that monitors
   this entity is added, deleted, or modified.  If you call this in
   the entity added callback for the domain, you are guaranteed to get
   this set before any sensors exist.  The "add/remove" function allow
   multiple handlers to be added. */
typedef void (*ipmi_entity_sensor_cb)(enum ipmi_update_e op,
				      ipmi_entity_t      *ent,
				      ipmi_sensor_t      *sensor,
				      void               *cb_data);
int ipmi_entity_add_sensor_update_handler(ipmi_entity_t         *ent,
					  ipmi_entity_sensor_cb handler,
					  void                  *cb_data);
int ipmi_entity_remove_sensor_update_handler(ipmi_entity_t         *ent,
					     ipmi_entity_sensor_cb handler,
					     void                  *cb_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_entity_sensor_cl_cb)(ipmi_entity_sensor_cb handler,
					 void                  *handler_data,
					 void                  *cb_data);
int ipmi_entity_add_sensor_update_handler_cl(ipmi_entity_t            *entity,
					     ipmi_entity_sensor_cl_cb handler,
					     void                 *event_data);
int ipmi_entity_remove_sensor_update_handler_cl
(ipmi_entity_t            *entity,
 ipmi_entity_sensor_cl_cb handler,
 void                     *event_data);

/* Register a handler that will be called when an control on this
   entity is added, deleted, or modified.  If you call this in the
   entity added callback for the domain, you are guaranteed to get
   this set before any sensors exist.  The "add/remove" function allow
   multiple handlers to be added. */
typedef void (*ipmi_entity_control_cb)(enum ipmi_update_e op,
				       ipmi_entity_t      *ent,
				       ipmi_control_t     *control,
				       void               *cb_data);
int ipmi_entity_add_control_update_handler(ipmi_entity_t          *ent,
					   ipmi_entity_control_cb handler,
					   void                   *cb_data);
int ipmi_entity_remove_control_update_handler(ipmi_entity_t          *ent,
					      ipmi_entity_control_cb handler,
					      void                   *cb_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_entity_control_cl_cb)(ipmi_entity_control_cb handler,
					  void                   *handler_data,
					  void                   *cb_data);
int ipmi_entity_add_control_update_handler_cl(ipmi_entity_t            *entity,
					     ipmi_entity_control_cl_cb handler,
					     void                 *event_data);
int ipmi_entity_remove_control_update_handler_cl
(ipmi_entity_t             *entity,
 ipmi_entity_control_cl_cb handler,
 void                      *event_data);

/* Hot-swap is done on entities.  We have a hot-swap model defined
   here that controls basic hot-swap operation on an entity. */

/* The hot-swap states correspond exactly to the ATCA state machine
   states, although unlike ATCA not all states may be used in all
   hot-swap state machines.  The states are:

   NOT_PRESENT - the entity is not physically present in the system.
   INACTIVE - The entity is present, but turned off.
   ACTIVATION_REQUESTED - Something has requested that the entity be
       activated.
   ACTIVATION_IN_PROGRESS - The activation is in progress, but has not
       yet completed.
   ACTIVE - The device is operational.
   DEACTIVATION_REQUESTED - Something has requested that the entity
       be deactivated.
   DEACTIVATION_IN_PROGRESS - The device is being deactivated, but
       has not yet completed.
   OUT_OF_CON - The board is (probably) installed, but cannot be
       communicated with.

   The basic state machine goes in order of the states, except that
   INACTIVE normally occurs afer DEACTIVATION_IN_PROGRESS.  States may
   be skipped if the state machine does not implement them; the
   simplest state machine would only have NOT_PRESENT and
   ACTIVE.  NOT_PRESENT can occur after any state on an unmanaged
   extraction.  DEACTIVATION_IN_PROGRESS or INACTIVE can also occur
   after any state, except that DEACTIVATION_IN_PROGRESS cannot occur
   after NOT_PRESENT

   The state machine may also go from DEACTIVATION_REQUESTED to ACTIVE
   if the deactivation was aborted.
*/
enum ipmi_hot_swap_states {
    IPMI_HOT_SWAP_NOT_PRESENT = 0,
    IPMI_HOT_SWAP_INACTIVE = 1,
    IPMI_HOT_SWAP_ACTIVATION_REQUESTED = 2,
    IPMI_HOT_SWAP_ACTIVATION_IN_PROGRESS = 3,
    IPMI_HOT_SWAP_ACTIVE = 4,
    IPMI_HOT_SWAP_DEACTIVATION_REQUESTED = 5,
    IPMI_HOT_SWAP_DEACTIVATION_IN_PROGRESS = 6,
    IPMI_HOT_SWAP_OUT_OF_CON = 7,
};

/* Get a string name for the hot swap state. */
const char *ipmi_hot_swap_state_name(enum ipmi_hot_swap_states state);

/* Does the entity implement a hot-swap state machine? */
int ipmi_entity_hot_swappable(ipmi_entity_t *ent);

/* If this returns true and the entity is hot-swappable, then it
   supports managed hot swap.  If this returns false and the entity is
   hot-swappable, it supports only the not-present and active hot-swap
   states and the changes cannot be managed. */
int ipmi_entity_supports_managed_hot_swap(ipmi_entity_t *ent);

/* Register to receive the hot-swap state when it changes.  the
   handler returns an integer.  It should return IPMI_EVENT_HANDLED if
   it handled the event, IPMI_EVENT_HANDLED_PASS if it handled the
   event but wants to allow other event handlers to see the event
   data, or IPMI_EVENT_NOT_HANDLED if it didn't handle the event.
   "Handling" the event means that is will manage the event (delete it
   when it is time).  If no sensor handles the event, then it will be
   delivered to the "main" unhandled event handler for the domain. */
typedef int (*ipmi_entity_hot_swap_cb)(ipmi_entity_t             *ent,
				       enum ipmi_hot_swap_states last_state,
				       enum ipmi_hot_swap_states curr_state,
				       void                      *cb_data,
				       ipmi_event_t              *event);
int ipmi_entity_add_hot_swap_handler(ipmi_entity_t           *ent,
				     ipmi_entity_hot_swap_cb handler,
				     void                    *cb_data);
int ipmi_entity_remove_hot_swap_handler(ipmi_entity_t           *ent,
					ipmi_entity_hot_swap_cb handler,
					void                    *cb_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_entity_hot_swap_cl_cb)(ipmi_entity_hot_swap_cb handler,
					   void                  *handler_data,
					   void                  *cb_data);
int ipmi_entity_add_hot_swap_handler_cl(ipmi_entity_t              *entity,
					ipmi_entity_hot_swap_cl_cb handler,
					void                      *event_data);
int ipmi_entity_remove_hot_swap_handler_cl(ipmi_entity_t              *entity,
					   ipmi_entity_hot_swap_cl_cb handler,
					   void                   *event_data);

/* Get the current hot-swap state. */
typedef void (*ipmi_entity_hot_swap_state_cb)(ipmi_entity_t             *ent,
					      int                       err,
					      enum ipmi_hot_swap_states state,
					      void                   *cb_data);
int ipmi_entity_get_hot_swap_state(ipmi_entity_t                 *ent,
				   ipmi_entity_hot_swap_state_cb handler,
				   void                          *cb_data);

/* Thses set whether the device will automatically be activated and
   deactivated by the hardware or OpenIPMI.  Both values are get/set
   together.  By default devices will automatically be
   activated/deactivated and this value is set to zero, or
   IPMI_TIMEOUT_NOW (upon insertion, they will transition directly to
   active state.  Upon a removal request, it will transition directly
   to inactive).  If this is set to IPMI_TIMEOUT_FOREVER, then the
   state machine will stop in the inactive/removal pending state and
   the user must call the activate or deactivate routines below to
   push it out of those states.  Otherwise, the timeout is the time in
   nanoseconds for the operation. */
int ipmi_entity_supports_auto_activate_time(ipmi_entity_t *ent);
int ipmi_entity_get_auto_activate_time(ipmi_entity_t       *ent,
				       ipmi_entity_time_cb handler,
				       void                *cb_data);
int ipmi_entity_set_auto_activate_time(ipmi_entity_t  *ent,
				       ipmi_timeout_t auto_act,
				       ipmi_entity_cb done,
				       void           *cb_data);
int ipmi_entity_supports_auto_deactivate_time(ipmi_entity_t *ent);
int ipmi_entity_get_auto_deactivate_time(ipmi_entity_t       *ent,
					 ipmi_entity_time_cb handler,
					 void                *cb_data);
int ipmi_entity_set_auto_deactivate_time(ipmi_entity_t  *ent,
					 ipmi_timeout_t auto_deact,
					 ipmi_entity_cb done,
					 void           *cb_data);

/* Cause the entity to move from INACTIVE to ACTIVATION_REQUESTED
   state, if possible. If the entity does not support this operation,
   this will return ENOSYS and you can move straight from INACTIVE to
   ACTIVE state by calling ipmi_entity_activate. */
int ipmi_entity_set_activation_requested(ipmi_entity_t  *ent,
					 ipmi_entity_cb done,
					 void           *cb_data);

/* Attempt to activate or deactivate an entity.  Activate will cause a
   transition from INACTIVE to ACTIVE (but only if
   ipmi_entity_set_activation_requested() returns ENOSYS), or from
   ACTIVATION_REQUESTED to ACTIVE.  Deactivate will cause a transition
   from DEACTIVATION_REQUESTED or ACTIVE to INACTIVE. */
int ipmi_entity_activate(ipmi_entity_t  *ent,
			 ipmi_entity_cb done,
			 void           *cb_data);
int ipmi_entity_deactivate(ipmi_entity_t  *ent,
			   ipmi_entity_cb done,
			   void           *cb_data);

/* Check the state of hot-swap for the entity. */
int ipmi_entity_check_hot_swap_state(ipmi_entity_t *ent);

/* It seems like a bad idea to directly modify the hot-swap indicators
   and requesters.  But, HPI provides it, so we have to have it for
   that. */
int ipmi_entity_get_hot_swap_indicator(ipmi_entity_t      *ent,
				       ipmi_entity_val_cb handler,
				       void               *cb_data);
int ipmi_entity_set_hot_swap_indicator(ipmi_entity_t  *ent,
				       int            val,
				       ipmi_entity_cb done,
				       void           *cb_data);
int ipmi_entity_get_hot_swap_requester(ipmi_entity_t      *ent,
				       ipmi_entity_val_cb handler,
				       void               *cb_data);
int ipmi_entity_id_get_hot_swap_indicator(ipmi_entity_id_t   id,
					  ipmi_entity_val_cb handler,
					  void               *cb_data);
int ipmi_entity_id_set_hot_swap_indicator(ipmi_entity_id_t id,
					  int              val,
					  ipmi_entity_cb   done,
					  void             *cb_data);
int ipmi_entity_id_get_hot_swap_requester(ipmi_entity_id_t   id,
					  ipmi_entity_val_cb handler,
					  void               *cb_data);


/* Entity ID based versions of some of the above calls. */
int ipmi_entity_id_get_hot_swap_state(ipmi_entity_id_t              id,
				      ipmi_entity_hot_swap_state_cb handler,
				      void                          *cb_data);
int ipmi_entity_id_get_auto_activate_time(ipmi_entity_id_t    id,
					  ipmi_entity_time_cb handler,
					  void                *cb_data);
int ipmi_entity_id_set_auto_activate_time(ipmi_entity_id_t  id,
					  ipmi_timeout_t    auto_act,
					  ipmi_entity_cb    done,
					  void              *cb_data);
int ipmi_entity_id_get_auto_deactivate_time(ipmi_entity_id_t    id,
					    ipmi_entity_time_cb handler,
					    void                *cb_data);
int ipmi_entity_id_set_auto_deactivate_time(ipmi_entity_id_t id,
					    ipmi_timeout_t   auto_deact,
					    ipmi_entity_cb   done,
					    void             *cb_data);
int ipmi_entity_id_activate(ipmi_entity_id_t id,
			    ipmi_entity_cb   done,
			    void             *cb_data);
int ipmi_entity_id_deactivate(ipmi_entity_id_t id,
			      ipmi_entity_cb   done,
			      void             *cb_data);
int ipmi_entity_id_check_hot_swap_state(ipmi_entity_id_t id);


/************************************************************************
 * 
 * Sensors
 *
 ***********************************************************************/

/* Handle events from a given sensor.  This allows multiple handlers
   to be added to a sensor.  Also, the handler returns an integer.  It
   should return IPMI_EVENT_HANDLED if it handled the event,
   IPMI_EVENT_HANDLED_PASS if it handled the event but wants to allow
   other event handlers to see the event data, or
   IPMI_EVENT_NOT_HANDLED if it didn't handle the event.  "Handling"
   the event means that is will manage the event (delete it when it is
   time).  If no sensor handles the event, then it will be delivered
   to the "main" unhandled event handler for the domain. */
int ipmi_sensor_add_threshold_event_handler(
    ipmi_sensor_t                  *sensor,
    ipmi_sensor_threshold_event_cb handler,
    void                           *cb_data);
int ipmi_sensor_remove_threshold_event_handler(
    ipmi_sensor_t                  *sensor,
    ipmi_sensor_threshold_event_cb handler,
    void                           *cb_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_sensor_threshold_event_cl_cb)
       (ipmi_sensor_threshold_event_cb handler,
	void                           *handler_data,
	void                           *cb_data);
int ipmi_sensor_add_threshold_event_handler_cl
(ipmi_sensor_t                     *sensor,
 ipmi_sensor_threshold_event_cl_cb handler,
 void                              *event_data);
int ipmi_sensor_remove_threshold_event_handler_cl
(ipmi_sensor_t                     *sensor,
 ipmi_sensor_threshold_event_cl_cb handler,
 void                              *event_data);

/* Register a handler to be called for incoming events on the
   sensor. This call allows multiple handlers to be added to a sensor.
   Also, the handler returns an integer.  It should return
   IPMI_EVENT_HANDLED if it handled the event, IPMI_EVENT_HANDLED_PASS
   if it handled the event but wants to allow other event handlers to
   see the event data, or IPMI_EVENT_NOT_HANDLED if it didn't handle
   the event.  "Handling" the event means that is will manage the
   event (delete it when it is time).  If no sensor handles the event,
   then it will be delivered to the "main" unhandled event handler for
   the domain. */
int ipmi_sensor_add_discrete_event_handler(
    ipmi_sensor_t                 *sensor,
    ipmi_sensor_discrete_event_cb handler,
    void                          *cb_data);
int ipmi_sensor_remove_discrete_event_handler(
    ipmi_sensor_t                 *sensor,
    ipmi_sensor_discrete_event_cb handler,
    void                          *cb_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_sensor_discrete_event_cl_cb)
       (ipmi_sensor_discrete_event_cb handler,
	void                          *handler_data,
	void                          *cb_data);
int ipmi_sensor_add_discrete_event_handler_cl
(ipmi_sensor_t                    *sensor,
 ipmi_sensor_discrete_event_cl_cb handler,
 void                             *event_data);
int ipmi_sensor_remove_discrete_event_handler_cl
(ipmi_sensor_t                    *sensor,
 ipmi_sensor_discrete_event_cl_cb handler,
 void                             *event_data);

/* The event state is which events are set and cleared for the given
   sensor.  Events are enumerated for threshold events and numbered
   for discrete events.  Use the provided functions to initialize,
   read, and modify an event state. */
typedef struct ipmi_event_state_s ipmi_event_state_t;

/* Return the size of an event state data structure, so you can
   allocate your own and copy them. */
unsigned int ipmi_event_state_size(void);
void ipmi_copy_event_state(ipmi_event_state_t *dest, ipmi_event_state_t *src);

/* Routines to init, clear, set, and query values in the event state. */
void ipmi_event_state_init(ipmi_event_state_t *events);
void ipmi_event_state_set_events_enabled(ipmi_event_state_t *events, int val);
int ipmi_event_state_get_events_enabled(ipmi_event_state_t *events);
void ipmi_event_state_set_scanning_enabled(ipmi_event_state_t *events,int val);
int ipmi_event_state_get_scanning_enabled(ipmi_event_state_t *events);
void ipmi_event_state_set_busy(ipmi_event_state_t *events, int val);
int ipmi_event_state_get_busy(ipmi_event_state_t *events);
void ipmi_threshold_event_clear(ipmi_event_state_t          *events,
				enum ipmi_thresh_e          threshold,
				enum ipmi_event_value_dir_e value_dir,
				enum ipmi_event_dir_e       dir);
void ipmi_threshold_event_set(ipmi_event_state_t          *events,
			      enum ipmi_thresh_e          threshold,
			      enum ipmi_event_value_dir_e value_dir,
			      enum ipmi_event_dir_e       dir);
int ipmi_is_threshold_event_set(ipmi_event_state_t          *events,
				enum ipmi_thresh_e          threshold,
				enum ipmi_event_value_dir_e value_dir,
				enum ipmi_event_dir_e       dir);
void ipmi_discrete_event_clear(ipmi_event_state_t    *events,
			       int                   event_offset,
			       enum ipmi_event_dir_e dir);
void ipmi_discrete_event_set(ipmi_event_state_t    *events,
			     int                   event_offset,
			     enum ipmi_event_dir_e dir);
int ipmi_is_discrete_event_set(ipmi_event_state_t    *events,
			       int                   event_offset,
			       enum ipmi_event_dir_e dir);

/* A generic callback for a lot of things. */
typedef void (*ipmi_sensor_done_cb)(ipmi_sensor_t *sensor,
				    int           err,
				    void          *cb_data);

/* Set the event enables for the given sensor to exactly the states
   given in the "states" parameter.  This will first enable the
   events/thresholds that are set, then disable the events/thresholds
   that are not set. */
int ipmi_sensor_set_event_enables(ipmi_sensor_t         *sensor,
				  ipmi_event_state_t    *states,
				  ipmi_sensor_done_cb   done,
				  void                  *cb_data);

/* Enable the states that are set in the "states" parameter.  This
   will *only* enable those states, it will not disable any states.
   It will, however, set the "events_enabled" flag and the
   "scanning_enabled" flag for the sensor to the value in the states
   parameter. */
int ipmi_sensor_enable_events(ipmi_sensor_t         *sensor,
			      ipmi_event_state_t    *states,
			      ipmi_sensor_done_cb   done,
			      void                  *cb_data);

/* Disable the states that are set in the "states" parameter.  This
   will *only* disable those states, it will not enable any states.
   It will, however, set the "events_enabled" flag and the
   "scanning_enabled" flag for the sensor to the value in the states
   parameter. */
int ipmi_sensor_disable_events(ipmi_sensor_t         *sensor,
			       ipmi_event_state_t    *states,
			       ipmi_sensor_done_cb   done,
			       void                  *cb_data);

/* Get the event enables for the given sensor. */
typedef void (*ipmi_sensor_event_enables_cb)(ipmi_sensor_t      *sensor,
					     int                err,
					     ipmi_event_state_t *states,
					     void               *cb_data);
int ipmi_sensor_get_event_enables(ipmi_sensor_t                *sensor,
				  ipmi_sensor_event_enables_cb done,
				  void                         *cb_data);

/* Rearm the current sensor.  This will cause the sensor to resend
   it's current event state if it is out of range.  If
   ipmi_sensor_get_supports_auto_rearm() returns false and you receive
   an event, you have to rearm a sensor manually to get another event
   from it.  If global_enable is set, all events are enabled and the
   state is ignored (and may be NULL).  Otherwise, the events set in
   the state are enabled. */
int ipmi_sensor_rearm(ipmi_sensor_t       *sensor,
		      int                 global_enable,
		      ipmi_event_state_t  *state,
		      ipmi_sensor_done_cb done,
		      void                *cb_data);

/* Get the hysteresis values for the given sensor.
   FIXME - these are currently the raw values, how do I get the
   cooked values?  There doesn't seem to be an easy way to calculate them. */
typedef void (*ipmi_sensor_hysteresis_cb)
     (ipmi_sensor_t *sensor,
      int           err,
      unsigned int  positive_hysteresis,
      unsigned int  negative_hysteresis,
      void          *cb_data);
int ipmi_sensor_get_hysteresis(ipmi_sensor_t             *sensor,
			       ipmi_sensor_hysteresis_cb done,
			       void                      *cb_data);

/* Set the hysteresis values for the given sensor.
   FIXME - these are currently the raw values, how do I handle the
   cooked values?  There doesn't seem to be an easy way to calculate them. */
int ipmi_sensor_set_hysteresis(ipmi_sensor_t       *sensor,
			       unsigned int        positive_hysteresis,
			       unsigned int        negative_hysteresis,
			       ipmi_sensor_done_cb done,
			       void                *cb_data);

/* Get the sensor's Owner ID, and the LUN and sensor number for the sensor,
   as viewed from its management controller.  These are really kind of
   internal but are required for CIM mappings. */
int ipmi_sensor_get_owner(ipmi_sensor_t *sensor);
int ipmi_sensor_get_num(ipmi_sensor_t *sensor,
			int           *lun,
			int           *num);

/* Get a useful string name for the sensor.  The return value is the
   number of characters in the string put into name.  The length is the
   length of the "name" array. */
#define IPMI_SENSOR_NAME_LEN (IPMI_ENTITY_NAME_LEN + 34)
int ipmi_sensor_get_name(ipmi_sensor_t *sensor, char *name, int length);

/* Strings for various values for a sensor.  We put them in here, and
   they will be the correct strings even for OEM values. */
const char *ipmi_sensor_get_sensor_type_string(ipmi_sensor_t *sensor);
const char *ipmi_sensor_get_event_reading_type_string(ipmi_sensor_t *sensor);
const char *ipmi_sensor_get_rate_unit_string(ipmi_sensor_t *sensor);
const char *ipmi_sensor_get_base_unit_string(ipmi_sensor_t *sensor);
const char *ipmi_sensor_get_modifier_unit_string(ipmi_sensor_t *sensor);

/* This call is a little different from the other string calls.  For a
   discrete sensor, you can pass the offset into this call and it will
   return the string associated with the reading.  This way, OEM
   sensors can supply their own strings as necessary for the various
   offsets. */
const char *ipmi_sensor_reading_name_string(ipmi_sensor_t *sensor, int offset);

/* Get the entity the sensor is hooked to. */
int ipmi_sensor_get_entity_id(ipmi_sensor_t *sensor);
int ipmi_sensor_get_entity_instance(ipmi_sensor_t *sensor);
ipmi_entity_t *ipmi_sensor_get_entity(ipmi_sensor_t *sensor);

/* Information about a sensor from it's SDR.  These are things that
   are specified by IPMI, see the spec for more details. */
int ipmi_sensor_get_sensor_init_scanning(ipmi_sensor_t *sensor);
int ipmi_sensor_get_sensor_init_events(ipmi_sensor_t *sensor);
int ipmi_sensor_get_sensor_init_thresholds(ipmi_sensor_t *sensor);
int ipmi_sensor_get_sensor_init_hysteresis(ipmi_sensor_t *sensor);
int ipmi_sensor_get_sensor_init_type(ipmi_sensor_t *sensor);
int ipmi_sensor_get_sensor_init_pu_events(ipmi_sensor_t *sensor);
int ipmi_sensor_get_sensor_init_pu_scanning(ipmi_sensor_t *sensor);
int ipmi_sensor_get_ignore_if_no_entity(ipmi_sensor_t *sensor);
int ipmi_sensor_get_supports_auto_rearm(ipmi_sensor_t *sensor);

/* Returns IPMI_THRESHOLD_ACCESS_SUPPORT_xxx */
int ipmi_sensor_get_threshold_access(ipmi_sensor_t *sensor);

/* Returns IPMI_HYSTERESIS_SUPPORT_xxx */
int ipmi_sensor_get_hysteresis_support(ipmi_sensor_t *sensor);

/* Returns IPMI_EVENT_SUPPORT_xxx */
int ipmi_sensor_get_event_support(ipmi_sensor_t *sensor);

/* Returns IPMI_SENSOR_TYPE_xxx */
int ipmi_sensor_get_sensor_type(ipmi_sensor_t *sensor);

/* Returns IPMI_EVENT_READING_TYPE_xxx */
int ipmi_sensor_get_event_reading_type(ipmi_sensor_t *sensor);

/* Returns IPMI_SENSOR_DIRECTION_xxx */
int ipmi_sensor_get_sensor_direction(ipmi_sensor_t *sensor);

/* Returns if the sensor can be read (either reading or states,
   depending on the sensor type).  Event-only sensors and sensors with
   system software ID owners cannot be read. */
int ipmi_sensor_get_is_readable(ipmi_sensor_t *sensor);

/* Sets "val" to if an event is supported for this particular sensor. */
int ipmi_sensor_threshold_event_supported(
    ipmi_sensor_t               *sensor,
    enum ipmi_thresh_e          event,
    enum ipmi_event_value_dir_e value_dir,
    enum ipmi_event_dir_e       dir,
    int                         *val);

/* Sets "val" to if a specific threshold can be set. */
int ipmi_sensor_threshold_settable(ipmi_sensor_t      *sensor,
				   enum ipmi_thresh_e threshold,
				   int                *val);

/* Sets "val" to if a specific threshold can be read. */
int ipmi_sensor_threshold_readable(ipmi_sensor_t      *sensor,
				   enum ipmi_thresh_e threshold,
				   int                *val);

/* Sets "val" to if a specific threshold has its reading returned when
   reading the value of the threshold sensor. */
int ipmi_sensor_threshold_reading_supported(ipmi_sensor_t      *sensor,
					    enum ipmi_thresh_e thresh,
					    int                *val);

/* Sets "val" to if the specific offset can send an event for the
   given direction. */
int ipmi_sensor_discrete_event_supported(ipmi_sensor_t         *sensor,
					 int                   offset,
					 enum ipmi_event_dir_e dir,
					 int                   *val);

/* Sets "val" to if the specific event can be read (is supported). */
int ipmi_sensor_discrete_event_readable(ipmi_sensor_t *sensor,
					int           event,
					int           *val);

/* Returns IPMI_RATE_UNIT_xxx */
enum ipmi_rate_unit_e ipmi_sensor_get_rate_unit(ipmi_sensor_t *sensor);

/* Returns IPMI_MODIFIER_UNIT_xxx */
enum ipmi_modifier_unit_use_e ipmi_sensor_get_modifier_unit_use(
    ipmi_sensor_t *sensor);

/* Returns if the value is a percentage. */
int ipmi_sensor_get_percentage(ipmi_sensor_t *sensor);

/* Returns IPMI_UNIT_TYPE_xxx */
enum ipmi_unit_type_e ipmi_sensor_get_base_unit(ipmi_sensor_t *sensor);

/* Returns IPMI_UNIT_TYPE_xxx */
enum ipmi_unit_type_e ipmi_sensor_get_modifier_unit(ipmi_sensor_t *sensor);

/* Sensor reading information from the SDR. */
int ipmi_sensor_get_tolerance(ipmi_sensor_t *sensor,
			      int           val,
			      double        *tolerance);
int ipmi_sensor_get_accuracy(ipmi_sensor_t *sensor, int val, double *accuracy);
int ipmi_sensor_get_normal_min_specified(ipmi_sensor_t *sensor);
int ipmi_sensor_get_normal_max_specified(ipmi_sensor_t *sensor);
int ipmi_sensor_get_nominal_reading_specified(ipmi_sensor_t *sensor);
int ipmi_sensor_get_nominal_reading(ipmi_sensor_t *sensor,
				    double *nominal_reading);
int ipmi_sensor_get_normal_max(ipmi_sensor_t *sensor, double *normal_max);
int ipmi_sensor_get_normal_min(ipmi_sensor_t *sensor, double *normal_min);
int ipmi_sensor_get_sensor_max(ipmi_sensor_t *sensor, double *sensor_max);
int ipmi_sensor_get_sensor_min(ipmi_sensor_t *sensor, double *sensor_min);

int ipmi_sensor_get_oem1(ipmi_sensor_t *sensor);

/* The ID string from the SDR. */
int ipmi_sensor_get_id_length(ipmi_sensor_t *sensor);
enum ipmi_str_type_e ipmi_sensor_get_id_type(ipmi_sensor_t *sensor);
int ipmi_sensor_get_id(ipmi_sensor_t *sensor, char *id, int length);


/* This is the implementation for a set of thresholds for a
   threshold-based sensor. */
typedef struct ipmi_thresholds_s ipmi_thresholds_t;

/* Return the size of a threshold data structure, so you can allocate
   your own and copy them. */
unsigned int ipmi_thresholds_size(void);
void ipmi_copy_thresholds(ipmi_thresholds_t *dest, ipmi_thresholds_t *src);

/* Clear out all the thresholds. */
int ipmi_thresholds_init(ipmi_thresholds_t *th);

/* Set a threshold and make it valid in the thresholds data structure.
   If sensor is non-null, it verifies that the given threshold can be
   set for the sensor.  Note that this does not actually set the
   threshold in the real sensor, just in the "th" data structure. */
int ipmi_threshold_set(ipmi_thresholds_t  *th,
		       ipmi_sensor_t      *sensor,
		       enum ipmi_thresh_e threshold,
		       double             value);
/* Return the value of the threshold in the set of thresholds.
   Returns an error if the threshold is not set.  This does not
   actually get the threshold from the real sensor, it get the local
   value in the "th" data structure. */
int ipmi_threshold_get(ipmi_thresholds_t  *th,
		       enum ipmi_thresh_e threshold,
		       double             *value);

		       
/* Return the default threshold settings for a sensor. */
int ipmi_get_default_sensor_thresholds(ipmi_sensor_t     *sensor,
				       ipmi_thresholds_t *th);

/* Set the thresholds for the given sensor. */
int ipmi_sensor_set_thresholds(ipmi_sensor_t       *sensor,
			       ipmi_thresholds_t   *thresholds,
			       ipmi_sensor_done_cb done,
			       void                *cb_data);

/* Fetch the thresholds from the given sensor. */
typedef void (*ipmi_sensor_thresholds_cb)(ipmi_sensor_t     *sensor,
					  int               err,
					  ipmi_thresholds_t *th,
					  void              *cb_data);
int ipmi_sensor_get_thresholds(ipmi_sensor_t             *sensor,
			       ipmi_sensor_thresholds_cb done,
			       void                      *cb_data);

/* Discrete states, or threshold status.  This is the set of states or
   thresholds that the sensor has enabled event for, and the global
   event state of the sensor. */
typedef struct ipmi_states_s ipmi_states_t;

/* Get the size of ipmi_states_t, so you can allocate your own and
   copy them. */
unsigned int ipmi_states_size(void);
void ipmi_copy_states(ipmi_states_t *dest, ipmi_states_t *src);

/* Various global values in the states value.  See the IPMI "Get
   Sensor Readings" command in the IPMI spec for details on the
   meanings of these. */
int ipmi_is_event_messages_enabled(ipmi_states_t *states);
int ipmi_is_sensor_scanning_enabled(ipmi_states_t *states);
int ipmi_is_initial_update_in_progress(ipmi_states_t *states);

/* Use to tell if a discrete offset is set in the states. */
int ipmi_is_state_set(ipmi_states_t *states,
		      int           state_num);

/* Use to tell if a threshold is out of range in a threshold sensor. */
int ipmi_is_threshold_out_of_range(ipmi_states_t      *states,
				   enum ipmi_thresh_e thresh);

/* The following functions allow you to create and modify your own
   states structure. */
void ipmi_init_states(ipmi_states_t *states);
void ipmi_set_event_messages_enabled(ipmi_states_t *states, int val);
void ipmi_set_sensor_scanning_enabled(ipmi_states_t *states, int val);
void ipmi_set_initial_update_in_progress(ipmi_states_t *states, int val);
void ipmi_set_state(ipmi_states_t *states,
		    int           state_num,
		    int           val);
void ipmi_set_threshold_out_of_range(ipmi_states_t      *states,
				     enum ipmi_thresh_e thresh,
				     int                val);

/* Read the current value of the given threshold sensor.  It also
   returns the states of all the thresholds. */
typedef void (*ipmi_sensor_reading_cb)(ipmi_sensor_t             *sensor,
				       int                       err,
				       enum ipmi_value_present_e value_present,
				       unsigned int              raw_value,
				       double                    val,
				       ipmi_states_t             *states,
				       void                      *cb_data);
int ipmi_sensor_get_reading(ipmi_sensor_t          *sensor,
			    ipmi_sensor_reading_cb done,
			    void                   *cb_data);

/* Read the current value of the given threshold sensor, returning the
   set of states that are active. */
typedef void (*ipmi_sensor_states_cb)(ipmi_sensor_t *sensor,
				      int           err,
				      ipmi_states_t *states,
				      void          *cb_data);
int ipmi_sensor_get_states(ipmi_sensor_t         *sensor,
			   ipmi_sensor_states_cb done,
			   void                  *cb_data);


/* These are convenience functions that take a sensor id, not a
   sensor, and set/get remote values from the sensor */
int ipmi_sensor_id_set_event_enables(ipmi_sensor_id_t      sensor_id,
				     ipmi_event_state_t    *states,
				     ipmi_sensor_done_cb   done,
				     void                  *cb_data);
int ipmi_sensor_id_enable_events(ipmi_sensor_id_t      sensor_id,
				 ipmi_event_state_t    *states,
				 ipmi_sensor_done_cb   done,
				 void                  *cb_data);
int ipmi_sensor_id_disable_events(ipmi_sensor_id_t      sensor_id,
				  ipmi_event_state_t    *states,
				  ipmi_sensor_done_cb   done,
				  void                  *cb_data);
int ipmi_sensor_id_get_event_enables(ipmi_sensor_id_t             sensor_id,
				     ipmi_sensor_event_enables_cb done,
				     void                         *cb_data);
int ipmi_sensor_id_rearm(ipmi_sensor_id_t    sensor_id,
			 int                 global_enable,
			 ipmi_event_state_t  *state,
			 ipmi_sensor_done_cb done,
			 void                *cb_data);
int ipmi_sensor_id_get_hysteresis(ipmi_sensor_id_t          sensor_id,
				  ipmi_sensor_hysteresis_cb done,
				  void                      *cb_data);
int ipmi_sensor_id_set_hysteresis(ipmi_sensor_id_t    sensor_id,
				  unsigned int        positive_hysteresis,
				  unsigned int        negative_hysteresis,
				  ipmi_sensor_done_cb done,
				  void                *cb_data);
int ipmi_sensor_id_set_thresholds(ipmi_sensor_id_t    sensor_id,
				  ipmi_thresholds_t   *thresholds,
				  ipmi_sensor_done_cb done,
				  void                *cb_data);
int ipmi_sensor_id_get_thresholds(ipmi_sensor_id_t          sensor_id,
				  ipmi_sensor_thresholds_cb done,
				  void                      *cb_data);
int ipmi_sensor_id_get_reading(ipmi_sensor_id_t       sensor_id,
			       ipmi_sensor_reading_cb done,
			       void                   *cb_data);
int ipmi_sensor_id_get_states(ipmi_sensor_id_t      sensor_id,
			      ipmi_sensor_states_cb done,
			      void                  *cb_data);


/************************************************************************
 * 
 * Controls
 *
 ***********************************************************************/

/*
 * Controls are lights, relays, displays, alarms, or other things of
 * that nature.  Basically, output devices.  IPMI does not define
 * these, but they are pretty fundamental for system management.
 */

/* Get a useful string name for the control.  The return value is the
   number of characters in the string put into name.  The length is the
   length of the "name" array. */
#define IPMI_CONTROL_NAME_LEN (IPMI_DOMAIN_NAME_LEN + 34)
int ipmi_control_get_name(ipmi_control_t *sensor, char *name, int length);

/* The type of control.  Returns something in the form IPMI_CONTROL_xxx */
int ipmi_control_get_type(ipmi_control_t *control);

int ipmi_control_get_id_length(ipmi_control_t *control);
enum ipmi_str_type_e ipmi_control_get_id_type(ipmi_control_t *control);
int ipmi_control_get_id(ipmi_control_t *control, char *id, int length);
int ipmi_control_get_entity_id(ipmi_control_t *control);
int ipmi_control_get_entity_instance(ipmi_control_t *control);
int ipmi_control_is_settable(ipmi_control_t *control);
int ipmi_control_is_readable(ipmi_control_t *control);
ipmi_entity_t *ipmi_control_get_entity(ipmi_control_t *control);
const char *ipmi_control_get_type_string(ipmi_control_t *control);
int ipmi_control_get_ignore_if_no_entity(ipmi_control_t *control);

/* Returns true if the control can generate events upon change, and
   false if not. */
int ipmi_control_has_events(ipmi_control_t *control);

/* Get the number of values the control supports. */
int ipmi_control_get_num_vals(ipmi_control_t *control);


/* A general callback for control operations that don't received
   any data. */
typedef void (*ipmi_control_op_cb)(ipmi_control_t *control,
				   int            err,
				   void           *cb_data);

/* Set the setting of an control.  Note that an control may
 support more than one element, the array passed in to "val" must
 match the number of elements the control supports.  All the
 elements will be set simultaneously. */
int ipmi_control_set_val(ipmi_control_t     *control,
			 int                *val,
			 ipmi_control_op_cb handler,
			 void               *cb_data);

/* Get the setting of an control.  Like setting controls, this
   returns an array of values, one for each of the number of elements
   the control supports. */
typedef void (*ipmi_control_val_cb)(ipmi_control_t *control,
				    int            err,
				    int            *val,
				    void           *cb_data);
int ipmi_control_get_val(ipmi_control_t      *control,
			 ipmi_control_val_cb handler,
			 void                *cb_data);

/* Register a handler that will be called when the control changes
   value.  Note that if the control does not support this operation,
   it will return ENOSYS.  The valid_vals array is an array of
   booleans telling if the given value in the vals array is a valid
   value.  The event must be handled just like sensor events.  The
   handler should return IPMI_EVENT_HANDLED if it handled the event,
   IPMI_EVENT_HANDLED_PASS if it handled the event but wants to allow
   other event handlers to see the event data, or
   IPMI_EVENT_NOT_HANDLED if it didn't handle the event.  "Handling"
   the event means that is will manage the event (delete it when it is
   time).  If no sensor handles the event, then it will be delivered
   to the "main" unhandled event handler for the domain. */
typedef int (*ipmi_control_val_event_cb)(ipmi_control_t *control,
					 int            *valid_vals,
					 int            *vals,
					 void           *cb_data,
					 ipmi_event_t   *event);
int ipmi_control_add_val_event_handler(ipmi_control_t            *control,
				       ipmi_control_val_event_cb handler,
				       void                      *cb_data);
int ipmi_control_remove_val_event_handler(ipmi_control_t            *control,
					  ipmi_control_val_event_cb handler,
					  void                      *cb_data);
/* Called for updated handler still registered when a domain is
   destroyed. */
typedef void (*ipmi_control_val_event_cl_cb)
       (ipmi_control_val_event_cb handler,
	void                           *handler_data,
	void                           *cb_data);
int ipmi_control_add_val_event_handler_cl
(ipmi_control_t               *control,
 ipmi_control_val_event_cl_cb handler,
 void                         *event_data);
int ipmi_control_remove_val_event_handler_cl
(ipmi_control_t               *control,
 ipmi_control_val_event_cl_cb handler,
 void                         *event_data);

/* For LIGHT types.  */

/* A light control may control one or more lights.  If a light
   control controls more than one light, the lights may not
   be set individually, they are controlled as a group, one set
   command will set them all. */

/* This describes a setting for a light.  There are two types of
   lights.  One type has a general ability to be set to a color, on
   time, and off time.  The other has a pre-defined set of
   transitions.  For transition-based lights, each light is defined to
   go through a number of transitions.  Each transition is described
   by a color, a time (in milliseconds) that the color is present.
   For non-blinking lights, there will only be one transition.  For
   blinking lights, there will be one or more transitions. */

/* If this returns true, then you set the light with the
   ipmi_control_set_light() function and get the values with the
   ipmi_control_get_light() function.  Otherwise you set it with the
   normal set_control command and use the transitions functions to get
   what the LED can do. */
int ipmi_control_light_set_with_setting(ipmi_control_t *control);

/* Allows detecting if a setting light supports a specific color. */
int ipmi_control_light_is_color_sup(ipmi_control_t *control,
				    int            light_num,
				    unsigned int   color);

/* Allows detecting if a setting light supports local control. */
int ipmi_control_light_has_loc_ctrl(ipmi_control_t *control,
				    int            light_num);

/* Old interfaces, only works with light number zero.  Don't use this. */
int ipmi_control_light_is_color_supported(ipmi_control_t *control,
					  unsigned int   color);
int ipmi_control_light_has_local_control(ipmi_control_t *control);


/* Handling the settings variable for a settings type light.  Note
   that setting the on time to zero will turn off the LED (the off
   time should be positive) and setting the off time to zero will turn
   on the LED (the on time should be positive).

   Local control is a state that some LED support where the target
   system has control of the LED. */
typedef struct ipmi_light_setting_s ipmi_light_setting_t;
unsigned int ipmi_light_setting_get_count(ipmi_light_setting_t *setting);
int ipmi_light_setting_in_local_control(ipmi_light_setting_t *setting,
					int                  num,
					int                  *lc);
int ipmi_light_setting_set_local_control(ipmi_light_setting_t *setting,
					 int                  num,
					 int                  lc);

int ipmi_light_setting_get_color(ipmi_light_setting_t *setting, int num,
				 int *color);
int ipmi_light_setting_set_color(ipmi_light_setting_t *setting, int num,
				 int color);
/* Times are in milliseconds. */
int ipmi_light_setting_get_on_time(ipmi_light_setting_t *setting, int num,
				   int *time);
int ipmi_light_setting_set_on_time(ipmi_light_setting_t *setting, int num,
				   int time);
int ipmi_light_setting_get_off_time(ipmi_light_setting_t *setting, int num,
				    int *time);
int ipmi_light_setting_set_off_time(ipmi_light_setting_t *setting, int num,
				    int time);
ipmi_light_setting_t *ipmi_alloc_light_settings(unsigned int count);
void ipmi_free_light_settings(ipmi_light_setting_t *settings);
ipmi_light_setting_t *ipmi_light_settings_dup(ipmi_light_setting_t *settings);


/* Set and get the light's settings.  Note that the settings value you
   get is freed by the system, if you want to keep it around you must
   duplicate it. */
int ipmi_control_set_light(ipmi_control_t       *control,
			   ipmi_light_setting_t *settings,
			   ipmi_control_op_cb   handler,
			   void                 *cb_data);
typedef void (*ipmi_light_settings_cb)(ipmi_control_t       *control,
				       int                  err,
				       ipmi_light_setting_t *settings,
				       void                 *cb_data);
int ipmi_control_get_light(ipmi_control_t         *control,
			   ipmi_light_settings_cb handler,
			   void                   *cb_data);
		       
/* Now the functions for a transition based light. */

/* Get the setting for the specific number.  These all return -1 for
   an invalid number.  Otherwise they return the information.

   Each control has one or more lights.  Each light is an lightable
   device, but all the lights in a control are changed together.

   Each light has a number of values that it may be set to.  The value
   is what is passed to set_control().

   Each value of a light has a number of transitions that it may go
   through.  Each transition has a color and a time when that colors
   runs.

   This all sounds complicated, but it is really fairly simple.
   Suppose a control has two lights.  Say light 0 is a red led.  Light
   0 has 4 values: off, 100ms on and 900ms off, 900ms on and 100ms
   off, and 100% on.  For value 0, it will have one transition and the
   color will be black (time is irrelevant with one transition).  For
   value 1, it will have two transitions, the first has a color of
   black and a time of 900 and the second has a color of red and a
   time of 100.  Likewise, value 2 has two transitions, the first is
   black with a time of 100 and the second is red with a value of 900.
   Value 4 has one transition with a red color.
 */
int ipmi_control_get_num_light_values(ipmi_control_t *control,
				      unsigned int   light);
int ipmi_control_get_num_light_transitions(ipmi_control_t *control,
					   unsigned int   light,
					   unsigned int   value);
int ipmi_control_get_light_color(ipmi_control_t *control,
				 unsigned int   light,
				 unsigned int   value,
				 unsigned int   transition);
int ipmi_control_get_light_color_time(ipmi_control_t *control,
				      unsigned int   light,
				      unsigned int   value,
				      unsigned int   transition);


/* RELAY types have no settings. */

/* ALARM types have no settings. */

/* IDENTIFIER types are represented as arrays of unsigned data.
   Identifiers do not support multiple elements, and have their own
   setting function. */
typedef void (*ipmi_control_identifier_val_cb)(ipmi_control_t *control,
					       int            err,
					       unsigned char  *val,
					       int            length,
					       void           *cb_data);
int ipmi_control_identifier_get_val(ipmi_control_t                 *control,
				    ipmi_control_identifier_val_cb handler,
				    void                           *cb_data);
int ipmi_control_identifier_set_val(ipmi_control_t     *control,
				    unsigned char      *val,
				    int                length,
				    ipmi_control_op_cb handler,
				    void               *cb_data);
unsigned int ipmi_control_identifier_get_max_length(ipmi_control_t *control);


/* For DISPLAY types, which are string displays. Displays do not
   support multiple elements, and have their own setting function. */
/* Get the dimensions of the display device.  This assumes a square, which
   is usually (but maybe not always) a good assumption. */
void ipmi_control_get_display_dimensions(ipmi_control_t *control,
					 unsigned int   *columns,
					 unsigned int   *rows);

int ipmi_control_set_display_string(ipmi_control_t     *control,
				    unsigned int       start_row,
				    unsigned int       start_column,
				    char               *str,
				    unsigned int       len,
				    ipmi_control_op_cb handler,
				    void               *cb_data);
				
/* Fetch a string from the display. */
typedef void (*ipmi_control_str_cb)(ipmi_control_t *control,
				    int            err,
				    char           *str,
				    unsigned int   len,
				    void           *cb_data);
int ipmi_control_get_display_string(ipmi_control_t      *control,
				    unsigned int        start_row,
				    unsigned int        start_column,
				    unsigned int        len,
				    ipmi_control_str_cb handler,
				    void                *cb_data);

/* These are convenience functions that take a control id, not a
   control, and set/get remote values from the control. */
int ipmi_control_id_set_val(ipmi_control_id_t  control_id,
			    int                *val,
			    ipmi_control_op_cb handler,
			    void               *cb_data);
int ipmi_control_id_get_val(ipmi_control_id_t   control_id,
			    ipmi_control_val_cb handler,
			    void                *cb_data);
int ipmi_control_id_identifier_get_val
(ipmi_control_id_t              control_id,
 ipmi_control_identifier_val_cb handler,
 void                           *cb_data);
int ipmi_control_id_identifier_set_val(ipmi_control_id_t  control_id,
				       unsigned char      *val,
				       int                length,
				       ipmi_control_op_cb handler,
				       void               *cb_data);


/************************************************************************
 * 
 * Domain startup and shutdown.
 *
 ***********************************************************************/

/* Create a new domain with the given IPMI connections.  The name is
   the name to give to the domain that is used by OpenIPMI for logs
   and things of that nature.  The con array is an array of
   connections to use , num_con is the number of connections
   (currently up to two connections are supported, assuming the
   underlying connections have proper support).  Options is an array
   of option values of length num_options.  If num_options is 0, then
   options may be NULL.  The new domain is returned in the new_domain
   variable, the id for the connection change handler is return in
   con_change_id.  The "domain_fully_up" function will be called when
   the domain is fully operational (and if non-NULL), all the busses
   have been scanned, SDRs read, and SELs fetched.  Note that if the
   domain never comes up, this function will *never* be called. */
typedef struct ipmi_open_option_s
{
    int option;
    union {
	long ival;
	void *pval;
    };
} ipmi_open_option_t;
int ipmi_open_domain(const char         *name,
		     ipmi_con_t         *con[],
		     unsigned int       num_con,
		     ipmi_domain_con_cb con_change_handler,
		     void               *con_change_cb_data,
		     ipmi_domain_ptr_cb domain_fully_up,
		     void               *domain_fully_up_cb_data,
		     ipmi_open_option_t *options,
		     unsigned int       num_options,
		     ipmi_domain_id_t   *new_domain);

/* Options for ipmi_open_domain */

/* integer used as a boolean.  If this is true, the other processing
   options are ignored and everything is done.  Otherwise, only the
   specific options are turned on.  This is true by default. */
#define IPMI_OPEN_OPTION_ALL		1

/* Read the SDRs.  This is false by default */
#define IPMI_OPEN_OPTION_SDRS		2

/* Read the FRUs.  This is false by default */
#define IPMI_OPEN_OPTION_FRUS		3

/* Start SEL scanning.  This is false by default */
#define IPMI_OPEN_OPTION_SEL		4

/* Start IPMB scanning.  This is false by default */
#define IPMI_OPEN_OPTION_IPMB_SCAN	5

/* Do OEM initialization.  This is false by default */
#define IPMI_OPEN_OPTION_OEM_INIT	6

/* Set event receivers.  This is not affected by option_all and is
   true by default if the privilege level is admin or greater, false
   by default if the privilege level is less than admin. */
#define IPMI_OPEN_OPTION_SET_EVENT_RCVR	7

/* Set SEL time to the current system time.  This is not affected by
   option_all and is true by default if the privilege level is admin
   or greater, false by default if the privilege level is less than
   admin.  Note that you should really set the system time, the BMC
   will start with it set to zero and you really want to know what
   time it is.  This, of course, assumes that your system time is
   correct, but you are using NTP, right?  Also, the time in the BMC
   is GMT, so timezones/DST don't matter. */
#define IPMI_OPEN_OPTION_SET_SEL_TIME   8

/* If possible, activate the connection that we are using.  This is
   system-dependent, on some systems it sets the IPMB address of the
   connection, on some it enables operations on one connection.  By
   default this is true.  This is not affected by option_all. */
#define IPMI_OPEN_OPTION_ACTIVATE_IF_POSSIBLE 9

/* Only with the the "local" resource.  This is system-dependent, but
   in general, when working in a larger system, This causes the system
   to only operate on the "local" resource.  In ATCA, when run on a
   blade, for instance, this allows just the resources on a blade to
   appear.  It won't go out to the system manager or on the IPMB bus.
   This is not affected by option_all and does not apply to all
   systems.  The default value depends on the system, but will
   generally default to "true" on local connections and "false" on
   external connections. */
#define IPMI_OPEN_OPTION_LOCAL_ONLY 10

/*
 * Use or don't use the local cache for SDRs and other things.  This
 * is not affected by the "all" option above, cache use is always
 * enabled unless disabled by this option.
 */
#define IPMI_OPEN_OPTION_USE_CACHE 11


/* Close an IPMI connection.  This will free all memory associated
   with the connections, any outstanding responses will be lost, etc.
   All slave MC's will be closed when this is closed. */
typedef void (*ipmi_domain_close_done_cb)(void *cb_data);
int ipmi_domain_close(ipmi_domain_t             *domain,
		      ipmi_domain_close_done_cb close_done,
		      void                      *cb_data);


/* Domain monitoring, catches add and deletes. */
typedef void (*ipmi_domain_change_cb)(ipmi_domain_t      *domain,
				      enum ipmi_update_e op,
				      void               *cb_data);
int ipmi_domain_add_domain_change_handler(ipmi_domain_change_cb handler,
					  void                  *cb_data);
int ipmi_domain_remove_domain_change_handler(ipmi_domain_change_cb handler,
					     void                  *cb_data);

/* The following are functions for parsing IPMI arguments for
   connections in some standard manner.  These can be used to discover
   and set the valid arguments for any connection type. */

/* Allocate an args object for the given connection type. */
int ipmi_args_alloc(char *con_type, ipmi_args_t **args);

/* Returns the type (smi, lan, etc) of the connextion.  Returns a
   static string (should not be freed). */
const char *ipmi_args_get_type(ipmi_args_t *args);

/* The following lets you discover the valid fields in an args array.
   The fields in an ipmi_arg_t are indexed sequentially from zero by
   argnum.  When the argnum is invalid (past the end) this will return
   E2BIG.  The name, type, and current value of the field is returned.
   The name field will not contain spaces, but will contain "_" where
   a space would be.  All data passed back and forth is in strings.
   The type fields are currently: bool, enum, and str.  The returned
   value is allocated, you must free it with ipmi_args_free_str (if
   not NULL).  A NULL value is allowed for all values (though it may
   not be supported if the value is required): it basically means "not
   set".  Values for bool are "true" and "false".  The range is only
   currently used for enums, it returns an array of string values
   terminated by NULL.  The value will be one of these in the range.
   The help field returns extra helpful information about the field.
   If the first character of the help field is "*", then the value is
   required, otherwise it is optional.  If the next character is '!',
   then it is a password. */
int ipmi_args_get_val(ipmi_args_t  *args,
		      unsigned int argnum,
		      const char   **name,
		      const char   **type,
		      const char   **help,
		      char         **value,
		      const char   ***range);
/* Set the value of the field in the argument.  If "name" is non-NULL,
   it is used to find the field with that name.  If "name" is NULL,
   then argnum is used for the field.  A NULL value means the value is
   not set; an argument may or may not support this.  Otherwise the
   value must be "true" or "false" for bools and one of the valid enum
   values for an enum.  There may be other interpretation behind a
   string value (such as an integer), so setting the value may fail if
   the semantics are incorrect. */
int ipmi_args_set_val(ipmi_args_t  *args,
		      unsigned int argnum,
		      const char   *name,
		      const char   *value);

/* Used to free the string returned as a value from ipmi_args_get_val(). */
void ipmi_args_free_str(ipmi_args_t *args, char *str);

/* Create a new copy of the arguments */
ipmi_args_t *ipmi_args_copy(ipmi_args_t *args);

/* Returns true if the argument has all the info to form a connection,
   false if not.  The argnum of the first argument with a problem is
   returned in argnum if false is returned. */
int ipmi_args_validate(ipmi_args_t *args, int *argnum);

/* This must be called before calling any other IPMI functions.  It
   sets a mutex and mutex operations for the smi.  You must provide
   an OS handler to use for the system. */
int ipmi_init(os_handler_t *handler);

/* This will clean up all the memory associated with IPMI. */
void ipmi_shutdown(void);

/* Parse a possible option, returns EINVAL if the option is not valid. */
int ipmi_parse_options(ipmi_open_option_t *option,
		       char               *arg);
/* Help text for the options available from the above command */
const char *ipmi_parse_options_help(void);

/* Parse the arguments and extract a connection.  curr_arg should be
   passed in as the current argument, it will be set to the argument
   after the last argument parsed.  arg_count should be the total
   number of arguments.  args is the arguments (in argv style), and
   the data is returned in the iargs value.  Note that on an error, a
   non-zero value is returned and curr_arg will be set to the argument
   that had the error.  You must use ipmi_free_args() to free the
   value returned in iargs.  Note that this is the old version and you
   really should not use it.  Use ipmi_parse_args2(). */
int ipmi_parse_args(int         *curr_arg,
		    int         arg_count,
		    char        * const *args,
		    ipmi_args_t **iargs);

/* Parse the arguments and extract a connection.  curr_arg should be
   passed in as the current argument in the args array, it will be set
   to the argument after the last argument parsed.  arg_count
   should be the total number of arguments.  args is the arguments (in
   argv style), and the data is returned in the iargs value.  Note
   that on an error, a non-zero value is returned and curr_arg will be
   set to the argument that had the error.  You must use
   ipmi_free_args() to free the value returned in iargs.

   The arguments are parsed as:
      lan [-U <username>] [-P <password>] [-A <authtype>] [-L <privilege>]
          [-s] [-p[2] <port number>] <IP> [<IP>]
   for a RMCP LAN connection or
      smi <smi num>
   for a system interface connection.  For multiple IP addresses to the
   same BMC, use the -s option and the second IP (and -p2)
   for the second IP address.  OpenIPMI supports multiple IP
   addresses, detecting failures, switching between
   addresses, and other fault-tolerant things.  It does this
   transparently to the user. */
int ipmi_parse_args2(int         *curr_arg,
		     int         arg_count,
		     char        * const *args,
		     ipmi_args_t **iargs);

/* Free an argument structure. */
void ipmi_free_args(ipmi_args_t *args);

/* Iterate the help for all registered connection types (smi, lan,
   etc.).  This can also be used to find out all the supported
   connection types, as each name is retuned in the name field. */
typedef void (*ipmi_iter_help_cb)(const char *name, const char *help,
				  void *cb_data);
void ipmi_parse_args_iter_help(ipmi_iter_help_cb help_cb, void *cb_data);

/* Set up a connection from an argument structure. */
int ipmi_args_setup_con(ipmi_args_t  *args,
			os_handler_t *handlers,
			void         *user_data,
			ipmi_con_t   **con);

/***********************************************************************
 *
 * Crufty backwards-compatible interfaces.  Don't use these as they
 * are deprecated.
 *
 **********************************************************************/

struct ipmi_domain_con_change_s;
typedef struct ipmi_domain_con_change_s ipmi_domain_con_change_t
     IPMI_TYPE_DEPRECATED;

int ipmi_domain_add_con_change_handler(ipmi_domain_t            *domain,
				       ipmi_domain_con_cb       handler,
				       void                     *cb_data,
				       struct ipmi_domain_con_change_s **id)
     IPMI_FUNC_DEPRECATED;
void ipmi_domain_remove_con_change_handler
(ipmi_domain_t            *domain,
 struct ipmi_domain_con_change_s *id)
     IPMI_FUNC_DEPRECATED;

int ipmi_init_domain(ipmi_con_t               *con[],
		     unsigned int             num_con,
		     ipmi_domain_con_cb       con_change_handler,
		     void                     *con_change_cb_data,
		     struct ipmi_domain_con_change_s **con_change_id,
		     ipmi_domain_id_t         *new_domain)
     IPMI_FUNC_DEPRECATED;

struct ipmi_event_handler_id_s;
typedef struct ipmi_event_handler_id_s ipmi_event_handler_id_t
     IPMI_TYPE_DEPRECATED;

int ipmi_register_for_events(ipmi_domain_t           *domain,
			     ipmi_event_handler_cb   handler,
			     void                    *event_data,
			     struct ipmi_event_handler_id_s **id)
     IPMI_FUNC_DEPRECATED;
int ipmi_deregister_for_events(ipmi_domain_t           *domain,
			       struct ipmi_event_handler_id_s *id)
     IPMI_FUNC_DEPRECATED;

typedef void (*ipmi_sensor_threshold_event_handler_nd_cb)(
    ipmi_sensor_t               *sensor,
    enum ipmi_event_dir_e       dir,
    enum ipmi_thresh_e          threshold,
    enum ipmi_event_value_dir_e high_low,
    enum ipmi_value_present_e   value_present,
    unsigned int                raw_value,
    double                      value,
    void                        *cb_data,
    ipmi_event_t                *event);
typedef ipmi_sensor_threshold_event_handler_nd_cb
  ipmi_sensor_threshold_event_handler_cb
  IPMI_TYPE_DEPRECATED;;

int ipmi_sensor_threshold_set_event_handler
(ipmi_sensor_t                             *sensor,
 ipmi_sensor_threshold_event_handler_nd_cb handler,
 void                                      *cb_data)
     IPMI_FUNC_DEPRECATED;

typedef void (*ipmi_sensor_discrete_event_handler_nd_cb)(
    ipmi_sensor_t         *sensor,
    enum ipmi_event_dir_e dir,
    int                   offset,
    int                   severity,
    int                   prev_severity,
    void                  *cb_data,
    ipmi_event_t          *event);
typedef ipmi_sensor_discrete_event_handler_nd_cb
  ipmi_sensor_discrete_event_handler_cb
  IPMI_TYPE_DEPRECATED;;
int
ipmi_sensor_discrete_set_event_handler(
    ipmi_sensor_t                            *sensor,
    ipmi_sensor_discrete_event_handler_nd_cb handler,
    void                                     *cb_data)
     IPMI_FUNC_DEPRECATED;

int ipmi_domain_set_entity_update_handler(ipmi_domain_t         *domain,
					  ipmi_domain_entity_cb handler,
					  void                  *cb_data)
     IPMI_FUNC_DEPRECATED;

typedef void (*ipmi_entity_presence_nd_cb)(ipmi_entity_t *entity,
					   int           present,
					   void          *cb_data,
					   ipmi_event_t  *event);
typedef ipmi_entity_presence_nd_cb ipmi_entity_presence_cb
  IPMI_TYPE_DEPRECATED ;
int ipmi_entity_set_presence_handler(ipmi_entity_t              *ent,
				     ipmi_entity_presence_nd_cb handler,
				     void                       *cb_data)
     IPMI_FUNC_DEPRECATED;

int ipmi_entity_set_sensor_update_handler(ipmi_entity_t         *ent,
					  ipmi_entity_sensor_cb handler,
					  void                  *cb_data)
     IPMI_FUNC_DEPRECATED;

int ipmi_entity_set_control_update_handler(ipmi_entity_t          *ent,
					   ipmi_entity_control_cb handler,
					   void                   *cb_data)
     IPMI_FUNC_DEPRECATED;

int ipmi_entity_set_fru_update_handler(ipmi_entity_t     *ent,
				       ipmi_entity_fru_cb handler,
				       void              *cb_data)
     IPMI_FUNC_DEPRECATED;

int ipmi_sensor_threshold_assertion_event_supported(
    ipmi_sensor_t               *sensor,
    enum ipmi_thresh_e          threshold,
    enum ipmi_event_value_dir_e dir,
    int                         *val)
     IPMI_FUNC_DEPRECATED;

int ipmi_sensor_threshold_deassertion_event_supported(
    ipmi_sensor_t               *sensor,
    enum ipmi_thresh_e          threshold,
    enum ipmi_event_value_dir_e dir,
    int                         *val)
     IPMI_FUNC_DEPRECATED;

int ipmi_sensor_discrete_assertion_event_supported(ipmi_sensor_t *sensor,
						   int           event,
						   int           *val)
     IPMI_FUNC_DEPRECATED;

int ipmi_sensor_discrete_deassertion_event_supported(ipmi_sensor_t *sensor,
						     int           event,
						     int           *val)
     IPMI_FUNC_DEPRECATED;

int ipmi_control_get_num_light_settings(ipmi_control_t *control,
					unsigned int   light)
     IPMI_FUNC_DEPRECATED;

typedef void (*ipmi_event_enables_get_cb)(ipmi_sensor_t      *sensor,
					  int                err,
					  ipmi_event_state_t *states,
					  void               *cb_data)
     IPMI_TYPE_DEPRECATED;
int ipmi_sensor_events_enable_get(ipmi_sensor_t                *sensor,
				  ipmi_sensor_event_enables_cb done,
				  void                         *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_events_disable(ipmi_sensor_t         *sensor,
			       ipmi_event_state_t    *states,
			       ipmi_sensor_done_cb   done,
			       void                  *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_events_enable(ipmi_sensor_t         *sensor,
			      ipmi_event_state_t    *states,
			      ipmi_sensor_done_cb   done,
			      void                  *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_events_enable_set(ipmi_sensor_t         *sensor,
				  ipmi_event_state_t    *states,
				  ipmi_sensor_done_cb   done,
				  void                  *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_id_events_enable_set(ipmi_sensor_id_t      sensor_id,
				     ipmi_event_state_t    *states,
				     ipmi_sensor_done_cb   done,
				     void                  *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_id_events_enable(ipmi_sensor_id_t      sensor_id,
				 ipmi_event_state_t    *states,
				 ipmi_sensor_done_cb   done,
				 void                  *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_id_events_disable(ipmi_sensor_id_t      sensor_id,
				  ipmi_event_state_t    *states,
				  ipmi_sensor_done_cb   done,
				  void                  *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_id_events_enable_get(ipmi_sensor_id_t             sensor_id,
				     ipmi_sensor_event_enables_cb done,
				     void                         *cb_data)
     IPMI_FUNC_DEPRECATED;

typedef void (*ipmi_states_read_cb)(ipmi_sensor_t *sensor,
				    int           err,
				    ipmi_states_t *states,
				    void          *cb_data)
     IPMI_TYPE_DEPRECATED;
int ipmi_states_get(ipmi_sensor_t         *sensor,
		    ipmi_sensor_states_cb done,
		    void                  *cb_data)
     IPMI_FUNC_DEPRECATED;
typedef void (*ipmi_reading_done_cb)(ipmi_sensor_t             *sensor,
				     int                       err,
				     enum ipmi_value_present_e value_present,
				     unsigned int              raw_value,
				     double                    val,
				     ipmi_states_t             *states,
				     void                      *cb_data)
     IPMI_TYPE_DEPRECATED;
int ipmi_reading_get(ipmi_sensor_t          *sensor,
		     ipmi_sensor_reading_cb done,
		     void                   *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_thresholds_set(ipmi_sensor_t       *sensor,
			ipmi_thresholds_t   *thresholds,
			ipmi_sensor_done_cb done,
			void                *cb_data)
     IPMI_FUNC_DEPRECATED;
typedef void (*ipmi_thresh_get_cb)(ipmi_sensor_t     *sensor,
				   int               err,
				   ipmi_thresholds_t *th,
				   void              *cb_data)
     IPMI_TYPE_DEPRECATED;
int ipmi_thresholds_get(ipmi_sensor_t             *sensor,
			ipmi_sensor_thresholds_cb done,
			void                      *cb_data)
     IPMI_FUNC_DEPRECATED;

int ipmi_sensor_id_thresholds_set(ipmi_sensor_id_t    sensor_id,
				  ipmi_thresholds_t   *thresholds,
				  ipmi_sensor_done_cb done,
				  void                *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_id_thresholds_get(ipmi_sensor_id_t          sensor_id,
				  ipmi_sensor_thresholds_cb done,
				  void                      *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_id_reading_get(ipmi_sensor_id_t       sensor_id,
			       ipmi_sensor_reading_cb done,
			       void                   *cb_data)
     IPMI_FUNC_DEPRECATED;
int ipmi_sensor_id_states_get(ipmi_sensor_id_t      sensor_id,
			      ipmi_sensor_states_cb done,
			      void                  *cb_data)
     IPMI_FUNC_DEPRECATED;
typedef void (*ipmi_hysteresis_get_cb)(ipmi_sensor_t *sensor,
				       int           err,
				       unsigned int  positive_hysteresis,
				       unsigned int  negative_hysteresis,
				       void          *cb_data)
     IPMI_TYPE_DEPRECATED;

int ipmi_close_connection(ipmi_domain_t             *domain,
			  ipmi_domain_close_done_cb close_done,
			  void                      *cb_data)
     IPMI_FUNC_DEPRECATED;

/* The following are not marked as deprecated, but don't use. */

/* OpenIPMI used to say that the FRU type was internal and that you
   should use the functions below instead.  That has changed, the
   FRU data is a first-class external type now; use it instead.
   The functions below are still provided, but are not necessary
   any more and should not be used.
  
   The following structures get boatloads of information from the FRU.
   These all will return ENOSYS if the information is not available.
   All these function return error, not lengths.

   The string return functions allow you to fetch the type and length.
   The length returns for ASCII strings does include the nil
   character, and it will be put on to the end of the get string.
   Also, when fetching the string, you must set the max_len variable
   to the maximum length of the returned data.  The actual length
   copied into the output string is returned in max_len. */
int ipmi_entity_get_internal_use_version(ipmi_entity_t *entity,
					 unsigned char *version);
int ipmi_entity_get_internal_use_length(ipmi_entity_t *entity,
					unsigned int  *length);
int ipmi_entity_get_internal_use_data(ipmi_entity_t *entity,
				      unsigned char *data,
				      unsigned int  *max_len);

int ipmi_entity_get_chassis_info_version(ipmi_entity_t *entity,
					 unsigned char *version);
int  ipmi_entity_get_chassis_info_type(ipmi_entity_t *entity,
				       unsigned char *type);

int ipmi_entity_get_chassis_info_part_number_len(ipmi_entity_t *entity,
						 unsigned int  *length);
int ipmi_entity_get_chassis_info_part_number_type(ipmi_entity_t        *entity,
						  enum ipmi_str_type_e *type);
int ipmi_entity_get_chassis_info_part_number(ipmi_entity_t *entity,
					     char          *str,
					     unsigned int  *strlen);
int ipmi_entity_get_chassis_info_serial_number_len(ipmi_entity_t *entity,
						   unsigned int  *length);
int ipmi_entity_get_chassis_info_serial_number_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_chassis_info_serial_number(ipmi_entity_t *entity,
					       char          *str,
					       unsigned int  *strlen);
int ipmi_entity_get_chassis_info_custom_len(ipmi_entity_t *entity,
					    unsigned int  num,
					    unsigned int  *length);
int ipmi_entity_get_chassis_info_custom_type(ipmi_entity_t        *entity,
					     unsigned int         num,
					     enum ipmi_str_type_e *type);
int ipmi_entity_get_chassis_info_custom(ipmi_entity_t *entity,
					unsigned int  num,
					char          *str,
					unsigned int  *strlen);

int ipmi_entity_get_board_info_version(ipmi_entity_t *entity,
				       unsigned char *version);
int ipmi_entity_get_board_info_lang_code(ipmi_entity_t *entity,
					 unsigned char *type);
int ipmi_entity_get_board_info_mfg_time(ipmi_entity_t *fru,
					time_t        *time);
int ipmi_entity_get_board_info_board_manufacturer_len(ipmi_entity_t *entity,
						      unsigned int  *length);
int ipmi_entity_get_board_info_board_manufacturer_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_board_info_board_manufacturer(ipmi_entity_t *entity,
						  char          *str,
						  unsigned int  *strlen);
int ipmi_entity_get_board_info_board_product_name_len(ipmi_entity_t *entity,
						      unsigned int  *length);
int ipmi_entity_get_board_info_board_product_name_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_board_info_board_product_name(ipmi_entity_t *entity,
						  char          *str,
						  unsigned int  *strlen);
int ipmi_entity_get_board_info_board_serial_number_len(ipmi_entity_t *entity,
						       unsigned int  *length);
int ipmi_entity_get_board_info_board_serial_number_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_board_info_board_serial_number(ipmi_entity_t *entity,
						   char          *str,
						   unsigned int  *strlen);
int ipmi_entity_get_board_info_board_part_number_len(ipmi_entity_t   *entity,
						  unsigned int *length);
int ipmi_entity_get_board_info_board_part_number_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_board_info_board_part_number(ipmi_entity_t *entity,
						 char          *str,
						 unsigned int  *strlen);
int ipmi_entity_get_board_info_fru_file_id_len(ipmi_entity_t *entity,
					       unsigned int  *length);
int ipmi_entity_get_board_info_fru_file_id_type(ipmi_entity_t        *entity,
						enum ipmi_str_type_e *type);
int ipmi_entity_get_board_info_fru_file_id(ipmi_entity_t *entity,
					   char          *str,
					   unsigned int  *strlen);
int ipmi_entity_get_board_info_custom_len(ipmi_entity_t *entity,
					  unsigned int  num,
					  unsigned int  *length);
int ipmi_entity_get_board_info_custom_type(ipmi_entity_t        *entity,
					   unsigned int         num,
					   enum ipmi_str_type_e *type);
int ipmi_entity_get_board_info_custom(ipmi_entity_t *entity,
				      unsigned int  num,
				      char          *str,
				      unsigned int  *strlen);

int ipmi_entity_get_product_info_version(ipmi_entity_t *entity,
					 unsigned char *version);
int ipmi_entity_get_product_info_lang_code(ipmi_entity_t *entity,
					   unsigned char *type);
int ipmi_entity_get_product_info_manufacturer_name_len(ipmi_entity_t *entity,
						       unsigned int  *length);
int ipmi_entity_get_product_info_manufacturer_name_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_product_info_manufacturer_name(ipmi_entity_t *entity,
						   char          *str,
						   unsigned int  *strlen);
int ipmi_entity_get_product_info_product_name_len(ipmi_entity_t *entity,
						  unsigned int  *length);
int ipmi_entity_get_product_info_product_name_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_product_info_product_name(ipmi_entity_t *entity,
					      char          *str,
					      unsigned int  *strlen);
int ipmi_entity_get_product_info_product_part_model_number_len
  (ipmi_entity_t *entity,
   unsigned int  *length);
int ipmi_entity_get_product_info_product_part_model_number_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_product_info_product_part_model_number
  (ipmi_entity_t *entity,
   char          *str,
   unsigned int  *strlen);
int ipmi_entity_get_product_info_product_version_len(ipmi_entity_t *entity,
						     unsigned int  *length);
int ipmi_entity_get_product_info_product_version_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_product_info_product_version(ipmi_entity_t *entity,
						 char          *str,
						 unsigned int  *strlen);
int ipmi_entity_get_product_info_product_serial_number_len
  (ipmi_entity_t *entity,
   unsigned int  *length);
int ipmi_entity_get_product_info_product_serial_number_type
  (ipmi_entity_t        *entity,
   enum ipmi_str_type_e *type);
int ipmi_entity_get_product_info_product_serial_number(ipmi_entity_t *entity,
						       char          *str,
						       unsigned int  *strlen);
int ipmi_entity_get_product_info_asset_tag_len(ipmi_entity_t *entity,
					       unsigned int  *length);
int ipmi_entity_get_product_info_asset_tag_type(ipmi_entity_t        *entity,
						enum ipmi_str_type_e *type);
int ipmi_entity_get_product_info_asset_tag(ipmi_entity_t *entity,
					   char          *str,
					   unsigned int  *strlen);
int ipmi_entity_get_product_info_fru_file_id_len(ipmi_entity_t *entity,
						 unsigned int  *length);
int ipmi_entity_get_product_info_fru_file_id_type(ipmi_entity_t        *entity,
						  enum ipmi_str_type_e *type);
int ipmi_entity_get_product_info_fru_file_id(ipmi_entity_t *entity,
					     char          *str,
					     unsigned int  *strlen);
int ipmi_entity_get_product_info_custom_len(ipmi_entity_t *entity,
					    unsigned int  num,
					    unsigned int  *length);
int ipmi_entity_get_product_info_custom_type(ipmi_entity_t        *entity,
					     unsigned int         num,
					     enum ipmi_str_type_e *type);
int ipmi_entity_get_product_info_custom(ipmi_entity_t *entity,
					unsigned int  num,
					char          *str,
					unsigned int  *strlen);

unsigned int ipmi_entity_get_num_multi_records(ipmi_entity_t *entity);
int ipmi_entity_get_multi_record_type(ipmi_entity_t *entity,
				      unsigned int  num,
				      unsigned char *type);
int ipmi_entity_get_multi_record_format_version(ipmi_entity_t *entity,
						unsigned int  num,
						unsigned char *ver);
int ipmi_entity_get_multi_record_data_len(ipmi_entity_t *entity,
					  unsigned int  num,
					  unsigned int  *len);
/* Note that length is a in/out parameter, you must set the length to
   the length of the buffer and the function will set it tot he actual
   length. */
int ipmi_entity_get_multi_record_data(ipmi_entity_t *entity,
				      unsigned int  num,
				      unsigned char *data,
				      unsigned int  *length);

/* For OpenHPI to find when bus scans complete. */
int ipmi_domain_set_bus_scan_handler(ipmi_domain_t  *domain,
				     ipmi_domain_cb handler,
				     void           *cb_data);

/* Set a handler that will be called when the main SDR repository is
   read.  This is primarily here for OpenHPI to meet their
   requirements, generally you should do this dynamically.  There is
   only one handler, and it will only be called when the main SDR
   repository is first read. */
int ipmi_domain_set_main_SDRs_read_handler(ipmi_domain_t  *domain,
					   ipmi_domain_cb handler,
					   void           *cb_data);

int ipmi_discrete_event_readable(ipmi_sensor_t *sensor,
				 int           event,
				 int           *val)
     IPMI_FUNC_DEPRECATED;

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMIIF_H */
