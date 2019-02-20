/*
 * ipmi_mc.h
 *
 * MontaVista IPMI interface for management controllers
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

#ifndef OPENIPMI_MC_INTERNAL_H
#define OPENIPMI_MC_INTERNAL_H

#include <OpenIPMI/ipmi_mc.h>

#include <OpenIPMI/internal/ipmi_sensor.h>
#include <OpenIPMI/internal/ipmi_control.h>

/* Allow entities to keep information that came from an MC in the MC
   itself so that when the MC is destroyed, it can be cleaned up. */
void *i_ipmi_mc_get_sdr_entities(ipmi_mc_t *mc);
void i_ipmi_mc_set_sdr_entities(ipmi_mc_t *mc, void *entities);

/* Some stupid systems don't have some settings right, this lets the
   OEM code fix it. */
void ipmi_mc_set_provides_device_sdrs(ipmi_mc_t *mc, int val);
void ipmi_mc_set_sel_device_support(ipmi_mc_t *mc, int val);
void ipmi_mc_set_sdr_repository_support(ipmi_mc_t *mc, int val);
void ipmi_mc_set_sensor_device_support(ipmi_mc_t *mc, int val);
void ipmi_mc_set_device_available(ipmi_mc_t *mc, int val);
void ipmi_mc_set_chassis_support(ipmi_mc_t *mc, int val);
void ipmi_mc_set_bridge_support(ipmi_mc_t *mc, int val);
void ipmi_mc_set_ipmb_event_generator_support(ipmi_mc_t *mc, int val);
void ipmi_mc_set_ipmb_event_receiver_support(ipmi_mc_t *mc, int val);
void ipmi_mc_set_fru_inventory_support(ipmi_mc_t *mc, int val);

/* Use the "main" SDR repository as a device SDR repository. This
   means that any SDRs in the "main" SDR repository on the MC will
   appear as sensors, etc as if they were in the device SDR
   repository. */
int ipmi_mc_set_main_sdrs_as_device(ipmi_mc_t *mc);

/* Used to refcount when the MC is completely up. */
void i_ipmi_mc_startup_get(ipmi_mc_t *mc, char *caller);
void i_ipmi_mc_startup_put(ipmi_mc_t *mc, char *caller);

/* Force the MC to be active, do not report to the user.  DON'T USE
   THIS UNLESS YOU *REALLY* KNOW WHAT YOU ARE DOING.  It is used to
   handle certain startup conditions on connections, and that's really
   all it's for. */
void i_ipmi_mc_force_active(ipmi_mc_t *mc, int val);

/* Get the sensors that the given MC owns. */
ipmi_sensor_info_t *i_ipmi_mc_get_sensors(ipmi_mc_t *mc);

/* Get the controls that the given MC owns. */
ipmi_control_info_t *i_ipmi_mc_get_controls(ipmi_mc_t *mc);

int i_ipmi_create_mc(ipmi_domain_t *domain,
		     ipmi_addr_t   *addr,
		     unsigned int  addr_len,
		     ipmi_mc_t     **new_mc);

/* Destroy an MC. */
void i_ipmi_cleanup_mc(ipmi_mc_t *mc);

/* Get the device SDRs for the given MC. */
ipmi_sdr_info_t *ipmi_mc_get_sdrs(ipmi_mc_t *mc);

/* These are called to claim and release the use of an MC.  An MC will
   not change while it has been gotten.  Must be holding the
   domain->mc_lock to call these. */
int i_ipmi_mc_get(ipmi_mc_t *mc);
void i_ipmi_mc_put(ipmi_mc_t *mc);


#if 0
/* FIXME - need to handle this somehow. */
/* This should be called from OEM code for an SMI, ONLY WHEN THE NEW
   MC HANDLER IS CALLED, if the slave address of the SMI is not 0x20.
   This will allow the bmc t know it's own address, which is pretty
   important.  You pass in a function that the code will call (and
   pass in it's own function) when it wants the address. */
typedef void (*ipmi_mc_got_slave_addr_cb)(ipmi_mc_t    *bmc,
					  int          err,
					  unsigned int addr,
					  void         *cb_data);
typedef int (*ipmi_mc_slave_addr_fetch_cb)(
    ipmi_mc_t                 *bmc,
    ipmi_mc_got_slave_addr_cb handler,
    void                      *cb_data);
int ipmi_bmc_set_smi_slave_addr_fetcher(
    ipmi_mc_t                   *bmc,
    ipmi_mc_slave_addr_fetch_cb handler);
#endif

/* Return the timestamp that was fetched before the first SEL fetch.
   This is so that OEM code can properly ignore old events.  Note that
   this value will be set to zero after the first SEL fetch, it really
   not good for anything but comparing timestamps to see if the event
   is old. */
ipmi_time_t ipmi_mc_get_startup_SEL_time(ipmi_mc_t *bmc);

/* Some OEM boxes may have special SEL delete requirements, so we have
   a special hook to let the OEM code delete events on an MC with SEL
   support. */
typedef int (*ipmi_mc_del_event_cb)(ipmi_mc_t                 *mc,
				    ipmi_event_t              *event,
				    ipmi_mc_del_event_done_cb done_handler,
				    void                      *cb_data);
void ipmi_mc_set_del_event_handler(ipmi_mc_t            *mc,
				   ipmi_mc_del_event_cb handler);
typedef int (*ipmi_mc_add_event_cb)(ipmi_mc_t                 *mc,
				    ipmi_event_t              *event,
				    ipmi_mc_add_event_done_cb done_handler,
				    void                      *cb_data);
void ipmi_mc_set_add_event_handler(ipmi_mc_t            *mc,
				   ipmi_mc_add_event_cb handler);
void ipmi_mc_set_sel_clear_handler(ipmi_mc_t            *mc,
				   ipmi_mc_del_event_cb handler);

/* Check the event receiver for the MC. */
void i_ipmi_mc_check_event_rcvr(ipmi_mc_t *mc);


int i_ipmi_mc_init(void);
void i_ipmi_mc_shutdown(void);

/* Returns EEXIST if the event is already there. */
int i_ipmi_mc_sel_event_add(ipmi_mc_t *mc, ipmi_event_t *event);

int i_ipmi_mc_check_oem_event_handler(ipmi_mc_t *mc, ipmi_event_t *event);
int i_ipmi_mc_check_sel_oem_event_handler(ipmi_mc_t *mc, ipmi_event_t *event);

/* Set and get the OEM data pointer in the mc. */
void ipmi_mc_set_oem_data(ipmi_mc_t *mc, void *data);
void *ipmi_mc_get_oem_data(ipmi_mc_t *mc);

/* Set the GUID for the MC */
void ipmi_mc_set_guid(ipmi_mc_t *mc, unsigned char *data);

/* Used by the sensor code to report a new sensor to the MC.  The new
   sensor call should return 1 if the sensor code should not add the
   sensor to its database. */
void i_ipmi_mc_fixup_sensor(ipmi_mc_t     *mc,
			    ipmi_sensor_t *sensor);
int i_ipmi_mc_new_sensor(ipmi_mc_t     *mc,
			 ipmi_entity_t *ent,
			 ipmi_sensor_t *sensor,
			 void          *link);

/* This should be called with a new device id for an MC we don't have
   active in the system (it may be inactive). */
int i_ipmi_mc_get_device_id_data_from_rsp(ipmi_mc_t *mc, ipmi_msg_t *rsp);

/* Compares the data in a get device id response (in rsp) with the
   data in the MC, returns true if they are the same and false if
   not.  Must be called with an error-free message. */
int i_ipmi_mc_device_data_compares(ipmi_mc_t *mc, ipmi_msg_t *rsp);

/* Called when a new MC has been added to the system, to kick of
   processing it. */
int i_ipmi_mc_handle_new(ipmi_mc_t *mc);

/* Allow sensors to keep information that came from an MC in the MC
   itself so that when the MC is destroyed, it can be cleaned up. */
void i_ipmi_mc_get_sdr_sensors(ipmi_mc_t     *mc,
			       ipmi_sensor_t ***sensors,
			       unsigned int  *count);
void i_ipmi_mc_set_sdr_sensors(ipmi_mc_t     *mc,
			       ipmi_sensor_t **sensors,
			       unsigned int  count);

/* Used to create external references to an MC so it won't go away
   even if it is released. */
void i_ipmi_mc_use(ipmi_mc_t *mc);
void i_ipmi_mc_release(ipmi_mc_t *mc);

/* Used to periodically check that the MC data is current and valid. */
void i_ipmi_mc_check_mc(ipmi_mc_t *mc);

/* Create chassis conrols for an MC. */
int i_ipmi_chassis_create_controls(ipmi_mc_t *mc, unsigned char instance);

/* Generate a unique number for the MC. */
unsigned int ipmi_mc_get_unique_nmu(ipmi_mc_t *mc);

#endif /* OPENIPMI_MC_INTERNAL_H */
