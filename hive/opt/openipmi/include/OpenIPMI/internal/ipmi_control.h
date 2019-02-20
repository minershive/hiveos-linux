/*
 * ipmi_control.h
 *
 * MontaVista IPMI interface for dealing with controls
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

#ifndef OPENIPMI_CONTROL_H
#define OPENIPMI_CONTROL_H

#include <OpenIPMI/ipmi_types.h>
#include <OpenIPMI/ipmi_addr.h>

/* The abstract type for controls. */
typedef struct ipmi_control_info_s ipmi_control_info_t;

/* Allocate a repository for holding controls for an MC. */
int ipmi_controls_alloc(ipmi_mc_t *mc, ipmi_control_info_t **new_controls);

/* Destroy a control repository and all the controls in it. */
int ipmi_controls_destroy(ipmi_control_info_t *controls);

/* Must be called with the i_ipmi_domain_entity_lock() held. */
int i_ipmi_control_get(ipmi_control_t *control);

/* Must be called with no locks held. */
void i_ipmi_control_put(ipmi_control_t *control);

/* Return the number of controls in the data structure. */
unsigned int ipmi_controls_get_count(ipmi_control_info_t *controls);

/* Operations and callbacks for control operations.  Operations on a
   control that can be delayed should be serialized (to avoid user
   confusion and for handling multi-part operations properly), thus
   each control has an operation queue, only one operation at a time
   may be running.  If you want to do an operation that requires
   sending a message and getting a response, you must put that
   operation into the opq.  When the handler you registered in the opq
   is called, you can actually perform the operation.  When your
   operation completes (no matter what, you must call it, even if the
   operation fails), you must call ipmi_control_opq_done.  The control
   will be locked properly for your callback.  To handle the control
   locking for you for command responses, you can send the message
   with ipmi_control_send_command, it will return the response when it
   comes in to your handler with the control locked. */

typedef void (*ipmi_control_rsp_cb)(ipmi_control_t *control,
				    int            err,
				    ipmi_msg_t     *rsp,
				    void           *cb_data);

typedef struct ipmi_control_op_info_s
{
    ipmi_control_id_t   __control_id;
    ipmi_control_t      *__control;
    void                *__cb_data;
    ipmi_control_op_cb  __handler;
    ipmi_control_rsp_cb __rsp_handler;
    ipmi_msg_t          *__rsp;
} ipmi_control_op_info_t;

/* Add an operation to the control operation queue.  If nothing is in
   the operation queue, the handler will be performed immediately.  If
   something else is currently being operated on, the operation will
   be queued until other operations before it have been completed.
   Then the handler will be called. */
int ipmi_control_add_opq(ipmi_control_t        *control,
			ipmi_control_op_cb     handler,
			ipmi_control_op_info_t *info,
			void                   *cb_data);

/* When an operation is completed (even if it fails), this *MUST* be
   called to cause the next operation to run. */
void ipmi_control_opq_done(ipmi_control_t *control);

/* Send an IPMI command to a specific MC.  The response handler will
   be called with the control locked. */
int ipmi_control_send_command(ipmi_control_t        *control,
			     ipmi_mc_t              *mc,
			     unsigned int           lun,
			     ipmi_msg_t             *msg,
			     ipmi_control_rsp_cb    handler,
			     ipmi_control_op_info_t *info,
			     void                   *cb_data);

/* Send an IPMI command to a specific address on the BMC.  This way,
   if you don't have an MC to represent the address, you can still
   send the command.  The response handler will be called with the
   control locked. */
int ipmi_control_send_command_addr(ipmi_domain_t          *domain,
				   ipmi_control_t         *control,
				   ipmi_addr_t            *addr,
				   unsigned int           addr_len,
				   ipmi_msg_t             *msg,
				   ipmi_control_rsp_cb    handler,
				   ipmi_control_op_info_t *info,
				   void                   *cb_data);

/* Set this if the control should be ignored for presence handling. */
void ipmi_control_set_ignore_for_presence(ipmi_control_t *control, int ignore);
int ipmi_control_get_ignore_for_presence(ipmi_control_t *control);


/* Allocate a control, it will not be associated with anything yet. */
int ipmi_control_alloc_nonstandard(ipmi_control_t **new_control);

/* Destroy a control. */
int ipmi_control_destroy(ipmi_control_t *control);

typedef void (*ipmi_control_destroy_cb)(ipmi_control_t *control,
					void           *cb_data);
/* Add a control for the given MC and put it into the given entity.
   Note that control will NOT appear as owned by the MC, the MC is
   used for the OS handler and such.  The source_mc is used to show
   which MC "owns" the creation of the control, and may be NULL if the
   control is presumed to come from the "main" SDR repository. */
int ipmi_control_add_nonstandard(
    ipmi_mc_t               *mc,
    ipmi_mc_t               *source_mc,
    ipmi_control_t          *control,
    unsigned int            num,
    ipmi_entity_t           *ent,
    ipmi_control_destroy_cb destroy_handler,
    void                    *destroy_handler_cb_data);

typedef int (*ipmi_control_set_val_cb)(ipmi_control_t     *control,
				       int                *val,
				       ipmi_control_op_cb handler,
				       void               *cb_data);

typedef int (*ipmi_control_get_val_cb)(ipmi_control_t      *control,
				       ipmi_control_val_cb handler,
				       void                *cb_data);

typedef int (*ipmi_control_set_display_string_cb)(ipmi_control_t *control,
						  unsigned int   start_row,
						  unsigned int   start_column,
						  char           *str,
						  unsigned int   len,
						  ipmi_control_op_cb handler,
						  void           *cb_data);

typedef int (*ipmi_control_get_display_string_cb)(ipmi_control_t  *control,
						  unsigned int    start_row,
						  unsigned int    start_column,
						  unsigned int    len,
						  ipmi_control_str_cb handler,
						  void            *cb_data);
typedef int (*ipmi_control_identifier_get_val_cb)(
    ipmi_control_t                 *control,
    ipmi_control_identifier_val_cb handler,
    void                           *cb_data);

typedef int (*ipmi_control_identifier_set_val_cb)(ipmi_control_t     *control,
						  unsigned char      *val,
						  int                length,
						  ipmi_control_op_cb handler,
						  void               *cb_data);

typedef int (*ipmi_control_set_light_cb)(ipmi_control_t       *control,
					 ipmi_light_setting_t *settings,
					 ipmi_control_op_cb   handler,
					 void                 *cb_data);
typedef int (*ipmi_control_get_light_cb)(ipmi_control_t         *control,
					 ipmi_light_settings_cb handler,
					 void                   *cb_data);

typedef struct ipmi_control_cbs_s
{
    ipmi_control_set_val_cb	          set_val;
    ipmi_control_get_val_cb	          get_val;
    ipmi_control_set_display_string_cb    set_display_string;
    ipmi_control_get_display_string_cb    get_display_string;
    ipmi_control_identifier_get_val_cb    get_identifier_val;
    ipmi_control_identifier_set_val_cb    set_identifier_val;
    ipmi_control_set_light_cb             set_light;
    ipmi_control_get_light_cb             get_light;
} ipmi_control_cbs_t;

/* For settings-based LEDs. */
int ipmi_control_add_light_color_support(ipmi_control_t *control,
					 int            light_num,
					 unsigned int   color);
int ipmi_control_light_set_has_local_control(ipmi_control_t *control,
					     int            light_num,
					     int            val);

void ipmi_control_identifier_set_max_length(ipmi_control_t *control,
					    unsigned int   val);

void ipmi_control_set_id(ipmi_control_t *control, char *id,
			 enum ipmi_str_type_e type, int length);
void ipmi_control_set_type(ipmi_control_t *control, int val);
void ipmi_control_set_settable(ipmi_control_t *control, int val);
void ipmi_control_set_readable(ipmi_control_t *control, int val);
void ipmi_control_set_ignore_if_no_entity(ipmi_control_t *control,
				          int            ignore_if_no_entity);
ipmi_domain_t *ipmi_control_get_domain(ipmi_control_t *control);

/* Returns true if this control is a hot-swap indicator, meaning that
   is is used to indicate to the operator when it is save to remove a
   hot-swappable device.  Setting "val" to one enables the control as
   a hot-swap power control.  The 'val" setting is retured by the get
   function.  The active_val is the value to use to turn off the
   indicator (in active state).  The req_act_val is the value to set
   when requesting deactivation.  The req_deact_val is the value to set
   when requesting deactivation.  The inactive val is the value to use
   when inactive. */
int ipmi_control_is_hot_swap_indicator(ipmi_control_t *control,
				       int            *req_act_val,
				       int            *active_val,
				       int            *req_deact_val,
				       int            *inactive_val);
void ipmi_control_set_hot_swap_indicator(ipmi_control_t *control,
					 int            val,
					 int            req_act_val,
					 int            active_val,
					 int            req_deact_val,
					 int            inactive_val);

/* Get/set the control as a hot-swap power control.  This must be set
   to 1 to turn the power on and zero to turn it off. */
int ipmi_control_is_hot_swap_power(ipmi_control_t *control);
void ipmi_control_set_hot_swap_power(ipmi_control_t *control, int val);

/* Can this control generate events? */
void ipmi_control_set_has_events(ipmi_control_t *control, int val);

/* Allow OEM code to call the event handlers.  Note that if the event
   is handled by the handlers, then "*event" will be set to NULL and
   *handled will be set to true.  If the event is not handled, then
   *handled will be set to false and the event value will be
   unchanged.  This is to help the OEM handlers only deliver the event
   once to the user. */
void ipmi_control_call_val_event_handlers(ipmi_control_t *control,
					  int            *valid_vals,
					  int            *vals,
					  ipmi_event_t   **event,
					  int            *handled);

typedef struct ipmi_control_transition_s
{
    unsigned int color;
    unsigned int time;
} ipmi_control_transition_t;
typedef struct ipmi_control_value_s
{
    unsigned int          num_transitions;
    ipmi_control_transition_t *transitions;
} ipmi_control_value_t;
typedef struct ipmi_control_light_s
{
    unsigned int         num_values;
    ipmi_control_value_t *values;
} ipmi_control_light_t;
void ipmi_control_light_set_lights(ipmi_control_t       *control,
				   unsigned int         num_lights,
				   ipmi_control_light_t *lights);

void ipmi_control_set_num_elements(ipmi_control_t *control, unsigned int val);

int ipmi_control_get_num(ipmi_control_t *control,
			 int            *lun,
			 int            *num);

typedef void (*ipmi_control_cleanup_oem_info_cb)(ipmi_control_t *control,
						 void           *oem_info);
void ipmi_control_set_oem_info(ipmi_control_t *control, void *oem_info,
			       ipmi_control_cleanup_oem_info_cb cleanup_handler);
void *ipmi_control_get_oem_info(ipmi_control_t *control);

/* Can be used by OEM code to replace some or all of the callbacks for
   a control. */
void ipmi_control_get_callbacks(ipmi_control_t     *control,
				ipmi_control_cbs_t *cbs);
void ipmi_control_set_callbacks(ipmi_control_t     *control,
				ipmi_control_cbs_t *cbs);

/* Get the MC that the control is in. */
ipmi_mc_t *ipmi_control_get_mc(ipmi_control_t *control);

/* OpenIPMI defines controls f0-ff for its own use, don't use them for your
   controls.  Here's some controls it defines. */
#define IPMI_CHASSIS_POWER_CONTROL	0xf0
#define IPMI_CHASSIS_RESET_CONTROL	0xf1

/* Do a pointer callback but ignore the sequence number in the MC.
   This is primarily for handling incoming events, where the sequence
   number doesn't matter. */
int ipmi_control_pointer_noseq_cb(ipmi_control_id_t   id,
				  ipmi_control_ptr_cb handler,
				  void                *cb_data);

#endif /* OPENIPMI_CONTROL_H */
