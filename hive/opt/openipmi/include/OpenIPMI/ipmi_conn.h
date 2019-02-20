/*
 * ipmi_conn.h
 *
 * MontaVista IPMI interface, definition for a low-level connection (like a
 * LAN interface, or system management interface, etc.).
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

#ifndef OPENIPMI_CONN_H
#define OPENIPMI_CONN_H

#include <OpenIPMI/ipmi_types.h>
#include <OpenIPMI/ipmi_addr.h>
#include <OpenIPMI/os_handler.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Called when an IPMI response to a command comes in from the BMC. */
typedef int (*ipmi_ll_rsp_handler_t)(ipmi_con_t   *ipmi,
				     ipmi_msgi_t  *rspi);

/* Called when an IPMI event comes in from the BMC.  Note that the
   event may be NULL, meaning that an event came in but did not have
   enough information to build a full event message.  So this is just
   an indication that there is a new event in the event log.  Note that
   if an event is delivered here, it's mcid might be invalid, so that
   may need to be established here. */
typedef void (*ipmi_ll_evt_handler_t)(ipmi_con_t         *ipmi,
				      const ipmi_addr_t  *addr,
				      unsigned int       addr_len,
				      ipmi_event_t       *event,
				      void               *cb_data);

/* Called when an incoming command is received by the IPMI code. */
typedef void (*ipmi_ll_cmd_handler_t)(ipmi_con_t        *ipmi,
				      const ipmi_addr_t *addr,
				      unsigned int      addr_len,
				      const ipmi_msg_t  *cmd,
				      long              sequence,
				      void              *cmd_data,
				      void              *data2,
				      void              *data3);

/* Called when a low-level connection has failed or come up.  If err
   is zero, the connection has come up after being failed.  if err is
   non-zero, it's an error number to report why the failure occurred.
   Since some connections support multiple ports into the system, this
   is used to report partial failures as well as full failures.
   port_num will be the port number that has failed (if err is
   nonzero) or has just come up (if err is zero).  What port_num that
   means depends on the connection type.  any_port_up will be true if
   the system still has connectivity through other ports. */
typedef void (*ipmi_ll_con_changed_cb)(ipmi_con_t   *ipmi,
				       int          err,
				       unsigned int port_num,
				       int          any_port_up,
				       void         *cb_data);

/* Used when fetching the IPMB address of the connection. The active
   parm tells if the interface is active or not, this callback is also
   used to inform the upper layer when the connection becomes active
   or inactive.  Note that there can be one IPMB address per channel,
   so this allows an array of IPMBs to be passed, one per channel.
   Set the IPMB to 0 if unknown. */
typedef void (*ipmi_ll_ipmb_addr_cb)(ipmi_con_t    *ipmi,
				     int           err,
				     const unsigned char ipmb_addr[],
				     unsigned int  num_ipmb_addr,
				     int           active,
				     unsigned int  hacks,
				     void          *cb_data);

/* Used to handle knowing when the connection shutdown is complete. */
typedef void (*ipmi_ll_con_closed_cb)(ipmi_con_t *ipmi, void *cb_data);

/* Statistics interfaces. */
typedef struct ipmi_ll_stat_info_s ipmi_ll_stat_info_t;
typedef void (*ipmi_ll_con_add_stat_cb)(ipmi_ll_stat_info_t *info,
					void                *stat,
					int                 count);
typedef int (*ipmi_ll_con_register_stat_cb)(ipmi_ll_stat_info_t *info,
					    const char          *name,
					    const char          *instance,
					    void                **stat);
typedef void (*ipmi_ll_con_unregister_stat_cb)(ipmi_ll_stat_info_t *info,
					       void                *stat);
ipmi_ll_stat_info_t *ipmi_ll_con_alloc_stat_info(void);
void ipmi_ll_con_free_stat_info(ipmi_ll_stat_info_t *info);
void ipmi_ll_con_stat_info_set_adder(ipmi_ll_stat_info_t     *info,
				     ipmi_ll_con_add_stat_cb adder);
void ipmi_ll_con_stat_info_set_register(ipmi_ll_stat_info_t          *info,
					ipmi_ll_con_register_stat_cb reg);
void ipmi_ll_con_stat_info_set_unregister(ipmi_ll_stat_info_t            *info,
					  ipmi_ll_con_unregister_stat_cb ureg);
void ipmi_ll_con_stat_call_adder(ipmi_ll_stat_info_t *info,
				 void                *stat,
				 int                 count);
int ipmi_ll_con_stat_call_register(ipmi_ll_stat_info_t *info,
				   const char          *name,
				   const char          *instance,
				   void                **stat);
void ipmi_ll_con_stat_call_unregister(ipmi_ll_stat_info_t *info,
				      void                *stat);
void ipmi_ll_con_stat_set_user_data(ipmi_ll_stat_info_t *info,
				    void                *data);
void *ipmi_ll_con_stat_get_user_data(ipmi_ll_stat_info_t *info);

/* Set this bit in the hacks if, even though the connection is to a
   device not at 0x20, the first part of a LAN command should always
   use 0x20. */
#define IPMI_CONN_HACK_20_AS_MAIN_ADDR		0x00000001

/* Some systems (incorrectly, according to the spec) use only the
   bottom 4 bits or ROLE(m) for authentication in the RAKP3 message.
   The spec says to use all 8 bits, but enabling this hack makes
   OpenIPMI only use the bottom 4 bits. */
#define IPMI_CONN_HACK_RAKP3_WRONG_ROLEM	0x00000002

/* The spec is vague (perhaps wrong), but the default for RMCP+ seems
   to be to use K(1) as the integrity key.  That is thus the default
   of OpenIPMI, but this hack lets you use SIK as it says in one part
   of the spec. */
#define IPMI_CONN_HACK_RMCPP_INTEG_SIK		0x00000004

/*
 * Used to pass special options for sending messages.
 */
typedef struct ipmi_con_option_s
{
    int option;
    union {
	long ival;
	void *pval;
    };
} ipmi_con_option_t;

/* Used to mark the end of the option list.  Must always be the last
   option. */
#define IPMI_CON_OPTION_LIST_END		0

/* Enable/disable authentication on the message (set by ival).
   Default is enabled. */
#define IPMI_CON_MSG_OPTION_AUTH		1

/* Enable/disable confidentiality (encryption) on the message (set by
   ival).  Default is enabled. */
#define IPMI_CON_MSG_OPTION_CONF		2

/* The command has side effects.  Handle this command
   specially to avoid side effects.  Primarily used for reserve
   commands, where on a slow link a command may be retransmitted
   but the previous response is received.  If not implemented,
   this is ignored.*/
#define IPMI_CON_MSG_OPTION_SIDE_EFFECTS	3


/* The data structure representing a connection.  The low-level handler
   fills this out then calls ipmi_init_con() with the connection. */
struct ipmi_con_s
{
    /* If this is zero, the domain handling code will not attempt to
       scan the system interface address of the connection.  If 1, it
       will.  Generally, if the system interface will respond on a
       IPMB address, you should set this to zero.  If it does not
       respond on an IPMB, you should set this to one if it is a
       management controller. */
    int scan_sysaddr;

    /* The low-level handler should provide one of these for doing os-type
       things (locks, random numbers, etc.) */
    os_handler_t *os_hnd;

    /* This data can be fetched by the user and used for anything they
       like. */
    void *user_data;

    /* Connection-specific data for the underlying connection. */
    void *con_data;

    /* If OEM code want to attach some data, it can to it here. */
    void *oem_data;
    void (*oem_data_cleanup)(ipmi_con_t *ipmi);

    /* This allows the connection to tell the upper layer that broadcasting
       will not work on this interface. */
    int broadcast_broken;

    /* Calls for the interface.  These should all return standard
       "errno" errors if they fail. */

    /* Start processing on a connection.  Note that the handler *must*
       be called with the global read lock not held, because the
       handler must write lock the global lock in order to add the MC
       to the global list.  This will report success/failure with the
       con_changed_handler, so set that up first. */
    int (*start_con)(ipmi_con_t *ipmi);

    /* Add a callback to call when the connection goes down or up. */
    int (*add_con_change_handler)(ipmi_con_t             *ipmi,
				  ipmi_ll_con_changed_cb handler,
				  void                   *cb_data);
    int (*remove_con_change_handler)(ipmi_con_t             *ipmi,
				     ipmi_ll_con_changed_cb handler,
				     void                   *cb_data);

    /* If OEM code discovers that an IPMB address has changed, it can
       use this to change it.  The hacks are the same as the ones in
       the IPMB address handler. */
    void (*set_ipmb_addr)(ipmi_con_t    *ipmi,
			  const unsigned char ipmb_addr[],
			  unsigned int  num_ipmb_addr,
			  int           active,
			  unsigned int  hacks);

    /* Add a handler that will be called when the IPMB address changes. */
    int (*add_ipmb_addr_handler)(ipmi_con_t           *ipmi,
				 ipmi_ll_ipmb_addr_cb handler,
				 void                 *cb_data);
    int (*remove_ipmb_addr_handler)(ipmi_con_t           *ipmi,
				    ipmi_ll_ipmb_addr_cb handler,
				    void                 *cb_data);

    /* This call gets the IPMB address of the connection.  It may be
       NULL if the connection does not support this.  This call may be
       set or overridden by the OEM code.  This is primarily for use
       by the connection code itself, the OEM code for the BMC
       connected to should set this.  If it is not set, the IPMB
       address is assumed to be 0x20.  This *should* send a message to
       the device, because connection code will assume that and use it
       to check for device function.  This should also check if the
       device is active.  If this is non-null, it will be called
       periodically. */
    int (*get_ipmb_addr)(ipmi_con_t           *ipmi,
			 ipmi_ll_ipmb_addr_cb handler,
			 void                 *cb_data);

    /* Change the state of the connection to be active or inactive.
       This may be NULL if the connection does not support this.  The
       interface code may set this, the OEM code should override this
       if necessary. */
    int (*set_active_state)(ipmi_con_t           *ipmi,
			    int                  is_active,
			    ipmi_ll_ipmb_addr_cb handler,
			    void                 *cb_data);

    /* Send an IPMI command (in "msg" on the "ipmi" connection to the
       given "addr".  When the response comes in or the message times
       out, rsp_handler will be called with the following four data
       items.  Note that the lower layer MUST guarantee that the
       reponse handler is called, even if it fails or the message is
       dropped. */
    int (*send_command)(ipmi_con_t            *ipmi,
			const ipmi_addr_t     *addr,
			unsigned int          addr_len,
			const ipmi_msg_t      *msg,
			ipmi_ll_rsp_handler_t rsp_handler,
			ipmi_msgi_t           *rspi);

    /* Register to receive IPMI events from the interface. */
    int (*add_event_handler)(ipmi_con_t                 *ipmi,
			     ipmi_ll_evt_handler_t      handler,
			     void                       *cb_data);

    /* Remove an event handler. */
    int (*remove_event_handler)(ipmi_con_t                 *ipmi,
				ipmi_ll_evt_handler_t      handler,
				void                       *cb_data);

    /* Send a response message.  This is not supported on all
       interfaces, primarily only on system management interfaces.  If
       not supported, this should return ENOSYS. */
    int (*send_response)(ipmi_con_t        *ipmi,
			 const ipmi_addr_t *addr,
			 unsigned int      addr_len,
			 const ipmi_msg_t  *msg,
			 long              sequence);

    /* Register to receive incoming commands.  This is not supported
       on all interfaces, primarily only on system management
       interfaces.  If not supported, this should return ENOSYS. */
    int (*register_for_command)(ipmi_con_t            *ipmi,
				unsigned char         netfn,
				unsigned char         cmd,
				ipmi_ll_cmd_handler_t handler,
				void                  *cmd_data,
				void                  *data2,
				void                  *data3);

    /* Deregister a command registration.  This is not supported on
       all interfaces, primarily only on system management interfaces.
       If not supported, this should return ENOSYS. */
    int (*deregister_for_command)(ipmi_con_t    *ipmi,
				  unsigned char netfn,
				  unsigned char cmd);

    /* Close an IPMI connection. */
    int (*close_connection)(ipmi_con_t *ipmi);

    /* This is set by OEM code to handle certain conditions when a
       send message fails.  It is currently only used by the IPMI LAN
       code, if a send messages response is an error, this will be
       called first.  If this function returns true, then the IPMI LAN
       code will not do anything with the message. */
    int (*handle_send_rsp_err)(ipmi_con_t *con, ipmi_msg_t *msg);

    /* Name the connection code can use for logging and instance names
       for statistics.  Must be dynamically allocated with
       ipmi_mem_alloc().  The connection code will free this.  May be
       NULL. */
    char *name;

    /* The connection code may put a string here to identify
       itself. */
    char *con_type;

    /* The privilege level of the connection */
    unsigned int priv_level;

    /* Close an IPMI connection and report that it is closed. */
    int (*close_connection_done)(ipmi_con_t            *ipmi,
				 ipmi_ll_con_closed_cb handler,
				 void                  *cb_data);

    /* Hacks reported by OEM code.  This should be set by the lower
       layer or by the user interface code. */
    unsigned int  hacks;

    /* The IPMB address as reported by the lower layer. */
    unsigned char ipmb_addr[MAX_IPMI_USED_CHANNELS];

    /* Handle an async event for the connection reported by something
       else. */
    void (*handle_async_event)(ipmi_con_t        *con,
			       const ipmi_addr_t *addr,
			       unsigned int      addr_len,
			       const ipmi_msg_t  *msg);

    /* Used by the connection attribute code.  Don't do anything with
       this yourself!.  The thing that creates this connection should
       call ipmi_con_attr_init() when the connection is created and
       ipmi_con_attr_cleanup() when the connection is destroyed. */
    void *attr;

    /* Old statistics interfaces.  Do not use these, they don't work
       any more. */
    int (*register_stat)(void *user_data, char *name,
			 char *instance,  void **stat);
    void (*add_stat)(void *user_data, void *stat, int value);
    void (*finished_with_stat)(void *user_data, void *stat);

    /* Return the arguments or the connection. */
    ipmi_args_t *(*get_startup_args)(ipmi_con_t *con);

    /* Increment the usecount of the connection; for each use, the
       connection must be closed.  This may be NULL if the connection
       type does not support being reused. */
    void (*use_connection)(ipmi_con_t *con);

    /* Like send_command, but with options.  options may be NULL if
       none.  If options are passed in, they must be terminated with
       the proper option.  This field may be NULL if the connection
       does not support options. */
    int (*send_command_option)(ipmi_con_t              *ipmi,
			       const ipmi_addr_t       *addr,
			       unsigned int            addr_len,
			       const ipmi_msg_t        *msg,
			       const ipmi_con_option_t *options,
			       ipmi_ll_rsp_handler_t   rsp_handler,
			       ipmi_msgi_t             *rspi);

    /* Returns the number of ports on the connection (one more than
       the max_port that can be reported by ipmi_ll_con_changed_cb().
       If NULL, assume 1. */
    unsigned int (*get_num_ports)(ipmi_con_t *ipmi);

    /* New statistics interface. */
    int (*register_stat_handler)(ipmi_con_t          *ipmi,
				 ipmi_ll_stat_info_t *info);
    int (*unregister_stat_handler)(ipmi_con_t          *ipmi,
				   ipmi_ll_stat_info_t *info);

    /* Get a string about the port.  This may be NULL, and the format
       varies with the particular interface.  The length if the "info"
       string is passed in info_len, the number of characters that
       would have been used is returned in info_len, even if it was
       not long enough to hold it. */
    int (*get_port_info)(ipmi_con_t *ipmi, unsigned int port,
			 char *info, int *info_len);

    /* Disable the connection.  This is primarily for handling a fork,
       make sure nothing happens on the connection after this is
       called.  To call this, you should make sure that no thread is
       in any event loop (before the fork) and there are no calls into
       the library.  After calling this you should call close. */
    void (*disable)(ipmi_con_t *ipmi);
};

#define IPMI_CONN_NAME(c) (c->name ? c->name : "")

/* Initialization code for the initialization the connection code. */
int i_ipmi_conn_init(os_handler_t *os_hnd);
void i_ipmi_conn_shutdown(void);


/* Address types for external addresses. */
#define IPMI_EXTERN_ADDR_IP	1

/* Handle a trap from an external SNMP source.  It returns 1 if the
   event was handled an zero if it was not. */
int ipmi_handle_snmp_trap_data(const void          *src_addr,
			       unsigned int        src_addr_len,
			       int                 src_addr_type,
			       long                specific,
			       const unsigned char *data,
			       unsigned int        data_len);

/* These calls deal with OEM-type handlers for connections.  Certain
   connections can be detected with special means (beyond just the
   manufacturer and product id) and this allows handlers for these
   types of connections to be registered.  At the very initial
   connection of every connection, the handler will be called and it
   must detect whether this is the specific type of connection or not,
   do any setup for that connection type, and then call the done
   routine passed in.  Note that the done routine may be called later,
   (allowing this handler to send messages and the like) but it *must*
   be called.  Note that this has no cancellation handler.  It relies
   on the lower levels returning responses for all the commands with
   NULL connections. */
typedef void (*ipmi_conn_oem_check_done)(ipmi_con_t *conn,
					 void       *cb_data);
typedef int (*ipmi_conn_oem_check)(ipmi_con_t               *conn,
				   void                     *check_cb_data,
				   ipmi_conn_oem_check_done done,
				   void                     *done_cb_data);
int ipmi_register_conn_oem_check(ipmi_conn_oem_check check,
				 void                *cb_data);
int ipmi_deregister_conn_oem_check(ipmi_conn_oem_check check,
				   void                *cb_data);
/* Should be called by the connection code for any new connection. */
int ipmi_conn_check_oem_handlers(ipmi_con_t               *conn,
				 ipmi_conn_oem_check_done done,
				 void                     *cb_data);

/* Generic message handling */
void ipmi_handle_rsp_item(ipmi_con_t            *ipmi,
			  ipmi_msgi_t           *rspi,
			  ipmi_ll_rsp_handler_t rsp_handler);

void ipmi_handle_rsp_item_copymsg(ipmi_con_t            *ipmi,
				  ipmi_msgi_t           *rspi,
				  const ipmi_msg_t      *msg,
				  ipmi_ll_rsp_handler_t rsp_handler);

void ipmi_handle_rsp_item_copyall(ipmi_con_t            *ipmi,
				  ipmi_msgi_t           *rspi,
				  const ipmi_addr_t     *addr,
				  unsigned int          addr_len,
				  const ipmi_msg_t      *msg,
				  ipmi_ll_rsp_handler_t rsp_handler);

/* You should use these for allocating and freeing mesage items.  Note
   that if you set item->msg.data to a non-NULL value that is not
   item->data, the system will free it with ipmi_free_msg_item_data().
   So you should allocate it with ipmi_alloc_msg_item_data9). */
ipmi_msgi_t *ipmi_alloc_msg_item(void);
void ipmi_free_msg_item(ipmi_msgi_t *item);
void *ipmi_alloc_msg_item_data(unsigned int size);
void ipmi_free_msg_item_data(void *data);
/* Move the data from the old message item to the new one, NULL-ing
   out the old item's data.  This will free the new_item's original
   data if necessary.  This will *not* copy the data items, just the
   address and message. */
void ipmi_move_msg_item(ipmi_msgi_t *new_item, ipmi_msgi_t *old_item);

/*
 * Connection attributes.  These are named items that code may create
 * to attach a void data item to a connection by name.  It can then
 * look up the data item by name.  Note that you can call
 * ipmi_con_register_attribute multiple times.  The first time will
 * create the item, the rest of the times will return the existing
 * item.
 *
 * When the connection is destroyed, the destroy function will be
 * called on the attribute so the memory (or anything else) can be
 * cleaned up.
 *
 * This is especially for use by RMCP+ payloads so they may attach
 * data to the connection they are associated with.
 */
typedef struct ipmi_con_attr_s ipmi_con_attr_t;

/* Attr init function.  Return the data item in the data field.  Returns
   an error value.  Will only be called once for the attribute.  */
typedef int (*ipmi_con_attr_init_cb)(ipmi_con_t *con, void *cb_data,
				     void **data);

/* Called when the attribute is destroyed.  Note that this may happen
   after connection destruction, so the connection may not exist any
   more. */
typedef void (*ipmi_con_attr_kill_cb)(void *cb_data, void *data);

int ipmi_con_register_attribute(ipmi_con_t            *con,
				char                  *name,
				ipmi_con_attr_init_cb init,
				ipmi_con_attr_kill_cb destroy,
				void                  *cb_data,
				ipmi_con_attr_t       **attr);
int ipmi_con_find_attribute(ipmi_con_t      *con,
			    char             *name,
			    ipmi_con_attr_t **attr);
void *ipmi_con_attr_get_data(ipmi_con_attr_t *attr);
/* You must call the put operation of every attribute returned by
   register or find. */
void ipmi_con_attr_put(ipmi_con_attr_t *attr);
int ipmi_con_attr_init(ipmi_con_t *con);
void ipmi_con_attr_cleanup(ipmi_con_t *con);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_CONN_H */
