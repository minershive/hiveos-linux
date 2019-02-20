/*
 * ipmi_mc.h
 *
 * MontaVista IPMI interface for management controllers
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2002,2003,2004 MontaVista Software Inc.
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

#ifndef OPENIPMI_MC_H
#define OPENIPMI_MC_H
#include <OpenIPMI/ipmi_types.h>
#include <OpenIPMI/ipmi_sdr.h>
#include <OpenIPMI/ipmi_bits.h>

#ifdef __cplusplus
extern "C" {
#endif

/* MCs are mostly internal items in OpenIPMI, but they are here because
   they are sometimes useful.  It is at least theoretically possible to
   put a non-IPMI system under OpenIPMI, and if you do the MCs won't
   be very useful.  You generally shouldn't need them anyway. */

ipmi_mcid_t ipmi_mc_convert_to_id(ipmi_mc_t *mc);
typedef void (*ipmi_mc_ptr_cb)(ipmi_mc_t *mc, void *cb_data);
int ipmi_mc_pointer_cb(ipmi_mcid_t    id,
		       ipmi_mc_ptr_cb handler,
		       void           *cb_data);
int ipmi_mc_pointer_noseq_cb(ipmi_mcid_t    id,
			     ipmi_mc_ptr_cb handler,
			     void           *cb_data);
int ipmi_cmp_mc_id(ipmi_mcid_t id1, ipmi_mcid_t id2);
int ipmi_cmp_mc_id_noseq(ipmi_mcid_t id1, ipmi_mcid_t id2);
void ipmi_mc_id_set_invalid(ipmi_mcid_t *id);
/* Is it the invalid MCID? */
int ipmi_mc_id_is_invalid(ipmi_mcid_t *id);


/* Generic callback type for MCs */
typedef void (*ipmi_mc_done_cb)(ipmi_mc_t *mc, int err, void *cb_data);
typedef void (*ipmi_mc_data_done_cb)(ipmi_mc_t *mc, int err, int value,
				     void *cb_data);

/* Get the name of an MC. */
#define IPMI_MC_NAME_LEN (IPMI_DOMAIN_NAME_LEN + 32)
int ipmi_mc_get_name(ipmi_mc_t *mc, char *name, int length);

/* Return the domain for the given MC. */
ipmi_domain_t *ipmi_mc_get_domain(ipmi_mc_t *mc);

/* Basic information about a MC.  */
int ipmi_mc_provides_device_sdrs(ipmi_mc_t *mc);
int ipmi_mc_device_available(ipmi_mc_t *mc);
int ipmi_mc_chassis_support(ipmi_mc_t *mc);
int ipmi_mc_bridge_support(ipmi_mc_t *mc);
int ipmi_mc_ipmb_event_generator_support(ipmi_mc_t *mc);
int ipmi_mc_ipmb_event_receiver_support(ipmi_mc_t *mc);
int ipmi_mc_fru_inventory_support(ipmi_mc_t *mc);
int ipmi_mc_sel_device_support(ipmi_mc_t *mc);
int ipmi_mc_sdr_repository_support(ipmi_mc_t *mc);
int ipmi_mc_sensor_device_support(ipmi_mc_t *mc);
int ipmi_mc_device_id(ipmi_mc_t *mc);
int ipmi_mc_device_revision(ipmi_mc_t *mc);
int ipmi_mc_major_fw_revision(ipmi_mc_t *mc);
int ipmi_mc_minor_fw_revision(ipmi_mc_t *mc);
int ipmi_mc_major_version(ipmi_mc_t *mc);
int ipmi_mc_minor_version(ipmi_mc_t *mc);
int ipmi_mc_manufacturer_id(ipmi_mc_t *mc);
int ipmi_mc_product_id(ipmi_mc_t *mc);
void ipmi_mc_aux_fw_revision(ipmi_mc_t *mc, unsigned char val[]);

/* Get the GUID (if it is available).  Returns ENOSYS if the GUID is
   not available.  guid must point to 16 bytes of data. */
int ipmi_mc_get_guid(ipmi_mc_t *mc, unsigned char *guid);

/* Check to see if the MC is operational in the system.  If this is
   false, then the MC was referred to by an SDR, but it doesn't really
   exist. */
int ipmi_mc_is_active(ipmi_mc_t *mc);

/* Used to monitor when the MC goes active or inactive. */
typedef void (*ipmi_mc_active_cb)(ipmi_mc_t *mc,
				  int       active,
				  void      *cb_data);
int ipmi_mc_add_active_handler(ipmi_mc_t         *mc,
			       ipmi_mc_active_cb handler,
			       void              *cb_data);
int ipmi_mc_remove_active_handler(ipmi_mc_t         *mc,
				  ipmi_mc_active_cb handler,
				  void              *cb_data);
typedef void (*ipmi_mc_active_cl_cb)(ipmi_mc_active_cb handler,
				     void              *handler_data,
				     void              *cb_data);
int ipmi_mc_add_active_handler_cl(ipmi_mc_t            *mc,
				  ipmi_mc_active_cl_cb handler,
				  void                 *event_data);
int ipmi_mc_remove_active_handler_cl(ipmi_mc_t            *mc,
				     ipmi_mc_active_cl_cb handler,
				     void                 *event_data);

/* Used to tell when an MC goes "fully up" meaning that all its SDRs
   have been read, etc. */
int ipmi_mc_add_fully_up_handler(ipmi_mc_t      *mc,
				 ipmi_mc_ptr_cb handler,
				 void           *cb_data);
int ipmi_mc_remove_fully_up_handler(ipmi_mc_t      *mc,
				    ipmi_mc_ptr_cb handler,
				    void           *cb_data);
typedef void (*ipmi_mc_fully_up_cl_cb)(ipmi_mc_ptr_cb handler,
				       void           *handler_data,
				       void           *cb_data);
int ipmi_mc_add_fully_up_handler_cl(ipmi_mc_t              *mc,
				    ipmi_mc_fully_up_cl_cb handler,
				    void                   *event_data);
int ipmi_mc_remove_fully_up_handler_cl(ipmi_mc_t              *mc,
				       ipmi_mc_fully_up_cl_cb handler,
				       void                  *event_data);

/* Send the command in "msg" and register a handler to handle the
   response.  This will return without blocking; when the response
   comes back the handler will be called.  The handler may be NULL;
   then the response is ignored.  Note that if non-NULL the response
   handler will always be called; if no response is received in time
   the code will return a timeout response. rsp_data is passed to the
   response handler, it may contain anything the user likes.  Note
   that if the mc goes away between the time the command is sent and
   the response comes back, this callback WILL be called, but the MC
   value will be NULL.  You must handle that.

   The sideeff version is for commands that have side effects.  This
   is primarily reserve commands, where if a link is slow a retransmit
   can cause problems. */
typedef void (*ipmi_mc_response_handler_t)(ipmi_mc_t  *src,
					   ipmi_msg_t *msg,
					   void       *rsp_data);
int ipmi_mc_send_command(ipmi_mc_t                  *mc,
			 unsigned int               lun,
			 const ipmi_msg_t           *cmd,
			 ipmi_mc_response_handler_t rsp_handler,
			 void                       *rsp_data);
int ipmi_mc_send_command_sideeff(ipmi_mc_t                  *mc,
				 unsigned int               lun,
				 const ipmi_msg_t           *cmd,
				 ipmi_mc_response_handler_t rsp_handler,
				 void                       *rsp_data);

/* Reset the MC, either a cold or warm reset depending on the type.
   Note that the effects of a reset are not defined by IPMI, so this
   might do wierd things.  Some systems do not support resetting the
   MC.  This is not a standard control because there is no entity to
   hang if from and you don't want people messing with it unless they
   really know what they are doing. */
#define IPMI_MC_RESET_COLD 1
#define IPMI_MC_RESET_WARM 2
int ipmi_mc_reset(ipmi_mc_t       *mc,
		  int             reset_type,
		  ipmi_mc_done_cb done,
		  void            *cb_data);

/* Get and set the setting to enable events for the entire MC.  The
   value returned by the get function is a boolean telling whether
   events are enabled.  The "val" passed in to the set function is a
   boolean telling whether to turn events on (true) or off (false). */
int ipmi_mc_get_events_enable(ipmi_mc_t *mc);
int ipmi_mc_set_events_enable(ipmi_mc_t       *mc,
			      int             val,
			      ipmi_mc_done_cb done,
			      void            *cb_data);

/*
 * Get and set the event log enable flag on the MC.  If this is
 * enabled (true), events will go into the event log on the MC.  If
 * this is disabled, events will be ignored by the MC (except for ones
 * added directly with an add_event call).
 *
 * NOTE: This is a somewhat dangerous call to set, since other flags
 * are also set in the same message and there is no way to set them
 * individually.  The set function does a read-modify-write, but there
 * is a race condition.  If other things are also setting the same
 * flags (like a device driver), it is recommended that you *NOT* use
 * this function.  In fact, in general, it is recommended that you not
 * use this function except perhaps to ensure that events are on.
 * They should be on by default, anyway.
 */
int ipmi_mc_get_event_log_enable(ipmi_mc_t            *mc,
				 ipmi_mc_data_done_cb done,
				 void                 *cb_data);
int ipmi_mc_set_event_log_enable(ipmi_mc_t       *mc,
				 int             val,
				 ipmi_mc_done_cb done,
				 void            *cb_data);

/* Reread all the sensors for a given mc.  This will request the
   device SDRs for that mc (And only for that MC) and change the
   sensors as necessary. */
int ipmi_mc_reread_sensors(ipmi_mc_t       *mc,
			   ipmi_mc_done_cb done,
			   void            *done_data);

/*
 * SEL support for the MC
 */
void ipmi_mc_set_sel_rescan_time(ipmi_mc_t *mc, unsigned int seconds);
unsigned int ipmi_mc_get_sel_rescan_time(ipmi_mc_t *mc);

/* Reread the sel.  When the hander is called, all the events in the
   SEL have been fetched into the local copy of the SEL (with the
   obvious caveat that this is a distributed system and other things
   may have come in after the read has finised). */
int ipmi_mc_reread_sel(ipmi_mc_t       *mc,
		       ipmi_mc_done_cb handler,
		       void            *cb_data);

/* Fetch the current time from the SEL. */
typedef void (*sel_get_time_cb)(ipmi_mc_t     *mc,
				int           err,
				unsigned long time,
				void          *cb_data);
int ipmi_mc_get_current_sel_time(ipmi_mc_t       *mc,
				 sel_get_time_cb handler,
				 void            *cb_data);

/* Set the time for the SEL.  Note that this function is rather
   dangerous to do, especially if you don't set it to the current
   time, as it can cause old events to be interpreted as new
   events on this and other systems. */
int ipmi_mc_set_current_sel_time(ipmi_mc_t            *mc,
				 const struct timeval *time,
				 ipmi_mc_done_cb      handler,
				 void                 *cb_data);


/* Add an event to the real SEL.  This does not directly put it into
   the internal copy of the SEL. */
typedef void (*ipmi_mc_add_event_done_cb)(ipmi_mc_t    *mc,
					  unsigned int record_id,
					  int          err,
					  void         *cb_data);
int ipmi_mc_add_event_to_sel(ipmi_mc_t                 *mc,
			     ipmi_event_t              *event,
			     ipmi_mc_add_event_done_cb handler,
			     void                      *cb_data);

/* Allocate an event with the given data.  This is required so you can
   add it to the SEL. */
ipmi_event_t *ipmi_event_alloc(ipmi_mcid_t   mcid,
			       unsigned int  record_id,
			       unsigned int  type,
			       ipmi_time_t   timestamp,
			       unsigned char *data,
			       unsigned int  data_len);

typedef void (ipmi_mc_del_event_done_cb)(ipmi_mc_t *mc, int err, void *cb_data);
int ipmi_mc_del_event(ipmi_mc_t                 *mc,
		      ipmi_event_t              *event, 
		      ipmi_mc_del_event_done_cb handler,
		      void                      *cb_data);

/* Clear out all the events in the SEL if and only if the last_event
   passed in is the last event in the SEL.  Note that use of this is
   *HIGHLY* discouraged.  This is only here for HPI support.  In
   general, you should delete individual events and OpenIPMI will do
   the right thing (do a clear if they are all gone, do individual
   deletes if possible otherwise, etc.).  If you pass in NULL for
   last_event, it forces a clear of the SEL without checking anything.
   Very dangerous, events can be lost. */
int ipmi_mc_sel_clear(ipmi_mc_t                 *mc,
		      ipmi_event_t              *last_event, 
		      ipmi_mc_del_event_done_cb handler,
		      void                      *cb_data);


ipmi_event_t *ipmi_mc_first_event(ipmi_mc_t *mc);
ipmi_event_t *ipmi_mc_last_event(ipmi_mc_t *mc);
ipmi_event_t *ipmi_mc_next_event(ipmi_mc_t *mc, const ipmi_event_t *event);
ipmi_event_t *ipmi_mc_prev_event(ipmi_mc_t *mc, const ipmi_event_t *event);
ipmi_event_t *ipmi_mc_event_by_recid(ipmi_mc_t *mc,
				     unsigned int record_id);
int ipmi_mc_sel_count(ipmi_mc_t *mc);
int ipmi_mc_sel_entries_used(ipmi_mc_t *mc);
int ipmi_mc_sel_get_major_version(ipmi_mc_t *mc);
int ipmi_mc_sel_get_minor_version(ipmi_mc_t *mc);
int ipmi_mc_sel_get_num_entries(ipmi_mc_t *mc);
int ipmi_mc_sel_get_free_bytes(ipmi_mc_t *mc);
int ipmi_mc_sel_get_overflow(ipmi_mc_t *mc);
int ipmi_mc_sel_get_supports_delete_sel(ipmi_mc_t *mc);
int ipmi_mc_sel_get_supports_partial_add_sel(ipmi_mc_t *mc);
int ipmi_mc_sel_get_supports_reserve_sel(ipmi_mc_t *mc);
int ipmi_mc_sel_get_supports_get_sel_allocation(ipmi_mc_t *mc);
int ipmi_mc_sel_get_last_addition_timestamp(ipmi_mc_t *mc);


/* Get the MC's full IPMI address. */
void ipmi_mc_get_ipmi_address(ipmi_mc_t    *mc,
			      ipmi_addr_t  *addr,
			      unsigned int *addr_len);

/* Get the IPMI slave address of the given MC. */
unsigned ipmi_mc_get_address(ipmi_mc_t *mc);

/* Get the channel for the given MC. */
unsigned ipmi_mc_get_channel(ipmi_mc_t *mc);


/***********************************************************************
 *
 * Channel handling for MCs.
 *
 ***********************************************************************/

/* 
 * Fetch channel information.  Note that you cannot keep the channel
 * info data structure passed to you, you can just use it to extract
 * the data you want.
 */
typedef struct ipmi_channel_info_s ipmi_channel_info_t;
typedef void (*ipmi_channel_info_cb)(ipmi_mc_t           *mc,
				     int                 err,
				     ipmi_channel_info_t *info,
				     void                *cb_data);
int ipmi_mc_channel_get_info(ipmi_mc_t            *mc,
			     unsigned int         channel,
			     ipmi_channel_info_cb handler,
			     void                 *cb_data);

/*
 * Allow the user to keep their own copy of the info data.  Note that
 * you should *NOT* free the info data you get from the get_info.
 */
ipmi_channel_info_t *ipmi_channel_info_copy(ipmi_channel_info_t *info);
void ipmi_channel_info_free(ipmi_channel_info_t *info);

/*
 * Extract various data from the channel.
 */
int ipmi_channel_info_get_channel(ipmi_channel_info_t *info,
				  unsigned int        *channel);

/* IANA-assigned number for IPMI, used for some defaults */
#define IPMI_ENTERPRISE_NUMBER		0x001bf2

#define IPMI_CHANNEL_MEDIUM_IPMB	1
#define IPMI_CHANNEL_MEDIUM_ICMB_V10	2
#define IPMI_CHANNEL_MEDIUM_ICMB_V09	3
#define IPMI_CHANNEL_MEDIUM_8023_LAN	4
#define IPMI_CHANNEL_MEDIUM_RS232	5
#define IPMI_CHANNEL_MEDIUM_OTHER_LAN	6
#define IPMI_CHANNEL_MEDIUM_PCI_SMBUS	7
#define IPMI_CHANNEL_MEDIUM_SMBUS_v1	8
#define IPMI_CHANNEL_MEDIUM_SMBUS_v2	9
#define IPMI_CHANNEL_MEDIUM_USB_v1	10
#define IPMI_CHANNEL_MEDIUM_USB_v2	11
#define IPMI_CHANNEL_MEDIUM_SYS_INTF	12
const char *ipmi_channel_medium_string(int val);
int ipmi_channel_info_get_medium(ipmi_channel_info_t *info,
				 unsigned int        *medium);
#define IPMI_CHANNEL_PROTOCOL_IPMB	1
#define IPMI_CHANNEL_PROTOCOL_ICMB	2
#define IPMI_CHANNEL_PROTOCOL_SMBus	4
#define IPMI_CHANNEL_PROTOCOL_KCS	5
#define IPMI_CHANNEL_PROTOCOL_SMIC	6
#define IPMI_CHANNEL_PROTOCOL_BT_v10	7
#define IPMI_CHANNEL_PROTOCOL_BT_v15	8
#define IPMI_CHANNEL_PROTOCOL_TMODE	9
const char *ipmi_channel_protocol_string(int val);
int ipmi_channel_info_get_protocol_type(ipmi_channel_info_t *info,
					unsigned int        *prot_type);

#define IPMI_CHANNEL_SESSION_LESS	0
#define IPMI_CHANNEL_SINGLE_SESSION	1
#define IPMI_CHANNEL_MULTI_SESSION	2
#define IPMI_CHANNEL_SESSION_BASED	3
const char *ipmi_channel_session_support_string(int val);
int ipmi_channel_info_get_session_support(ipmi_channel_info_t *info,
					  unsigned int        *sup);
/* Data is 3 bytes long */
int ipmi_channel_info_get_vendor_id(ipmi_channel_info_t *info,
				    unsigned char       *data);
/* Data is 2 bytes long */
int ipmi_channel_info_get_aux_info(ipmi_channel_info_t *info,
				   unsigned char       *data);

/*
 * Get and set the channel access information.  You should generally
 * get the items you want, modify them, then write them back out.
 */
typedef struct ipmi_channel_access_s ipmi_channel_access_t;
typedef void (*ipmi_channel_access_cb)(ipmi_mc_t             *mc,
				       int                   err,
				       ipmi_channel_access_t *info,
				       void                  *cb_data);
int ipmi_mc_channel_get_access(ipmi_mc_t              *mc,
			       unsigned int           channel,
			       enum ipmi_set_dest_e   dest,
			       ipmi_channel_access_cb handler,
			       void                   *cb_data);
int ipmi_mc_channel_set_access(ipmi_mc_t             *mc,
			       unsigned int           channel,
			       enum ipmi_set_dest_e  dest,
			       ipmi_channel_access_t *access,
			       ipmi_mc_done_cb       handler,
			       void                  *cb_data);

/*
 * Allow the user to keep their own copy of the info data.  Note that
 * you should *NOT* free the info data you get from the get_access.
 */
ipmi_channel_access_t *ipmi_channel_access_copy(ipmi_channel_access_t *access);
void ipmi_channel_access_free(ipmi_channel_access_t *access);

/*
 * Get and set various fields in the channel.
 */
int ipmi_channel_access_get_channel(ipmi_channel_access_t *access,
				    unsigned int          *channel);
int ipmi_channel_access_get_alerting_enabled(ipmi_channel_access_t *access,
					     unsigned int          *enab);
int ipmi_channel_access_set_alerting_enabled(ipmi_channel_access_t *access,
					     unsigned int          enab);
int ipmi_channel_access_get_per_msg_auth(ipmi_channel_access_t *access,
					 unsigned int          *msg_auth);
int ipmi_channel_access_set_per_msg_auth(ipmi_channel_access_t *access,
					 unsigned int          msg_auth);
int ipmi_channel_access_get_user_auth(ipmi_channel_access_t *access,
				      unsigned int          *user_auth);
int ipmi_channel_access_set_user_auth(ipmi_channel_access_t *access,
				      unsigned int          user_auth);
#define IPMI_CHANNEL_ACCESS_MODE_DISABLED	0
#define IPMI_CHANNEL_ACCESS_MODE_PRE_BOOT	1
#define IPMI_CHANNEL_ACCESS_MODE_ALWAYS		2
#define IPMI_CHANNEL_ACCESS_MODE_SHARED		3
const char *ipmi_channel_access_mode_string(int val);
int ipmi_channel_access_get_access_mode(ipmi_channel_access_t *access,
					unsigned int          *access_mode);
int ipmi_channel_access_set_access_mode(ipmi_channel_access_t *access,
					unsigned int          access_mode);
/* See IPMI_PRIVILEGE_xxx for the values. */
int ipmi_channel_access_get_priv_limit(ipmi_channel_access_t *access,
				       unsigned int          *priv_limit);
int ipmi_channel_access_set_priv_limit(ipmi_channel_access_t *access,
				       unsigned int          priv_limit);
/* Normally setting will only set the values you have changed.  This
   forces all the values to be set. */
int ipmi_channel_access_setall(ipmi_channel_access_t *access);

/***********************************************************************
 *
 * Misc stuff...
 *
 **********************************************************************/

/* Get the MC that the message is sent to for reading and controlling
   the sensor.  The SDR for the sensor may not have come from here.
   Note that this is not refcounted, it is held in existance by the
   sensor's refcount.  So don't keep this after the sensor pointer
   ceases to exist. */
ipmi_mc_t *ipmi_sensor_get_mc(ipmi_sensor_t *sensor);


/***********************************************************************
 *
 * Crufty backwards-compatible interfaces.  Don't use these as they
 * are deprecated.
 *
 **********************************************************************/

/* A monitor to tell when the SDRs and SELs for an MC are read for the
   first time and are finished being processed.  Setting the handler
   to NULL disables it.  Note this only works for the first time, it
   will not be called on subsequent SDR and SEL reads and checks. */
int ipmi_mc_set_sdrs_first_read_handler(ipmi_mc_t      *mc,
					ipmi_mc_ptr_cb handler,
					void           *cb_data);
int ipmi_mc_set_sels_first_read_handler(ipmi_mc_t      *mc,
					ipmi_mc_ptr_cb handler,
					void           *cb_data);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_MC_H */
