/*
 * serv.h
 *
 * MontaVista IPMI server include file
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2003,2004,2005,2012 MontaVista Software Inc.
 *
 * This software is available to you under a choice of one of two
 * licenses.  You may choose to be licensed under the terms of the GNU
 * Lesser General Public License (GPL) Version 2 or the modified BSD
 * license below.  The following disclamer applies to both licenses:
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
 * GNU Lesser General Public Licence
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this program; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * Modified BSD Licence
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above
 *      copyright notice, this list of conditions and the following
 *      disclaimer in the documentation and/or other materials provided
 *      with the distribution.
 *   3. The name of the author may not be used to endorse or promote
 *      products derived from this software without specific prior
 *      written permission.
 */

#ifndef __SERV_H_
#define __SERV_H_

#include <stdint.h>
#include <stdio.h>
#include <sys/uio.h> /* for iovec */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/nameser.h>
#include <resolv.h>
#include <netdb.h>
#include <OpenIPMI/msg.h>
#include <OpenIPMI/mcserv.h>

#ifndef __GNUC__
#  ifndef __attribute__
#    define  __attribute__(x)  /*NOTHING*/
#  endif
#endif

typedef void (*handle_oem_cb)(channel_t *chan, void *cb_data);
typedef struct oem_handler_s
{
    unsigned int  manufacturer_id;
    unsigned int  product_id;
    handle_oem_cb handler;
    void          *cb_data;

    struct oem_handler_s *next;
} oem_handler_t;

/* Register a new OEM handler. */
void ipmi_register_oem(oem_handler_t *handler);

typedef struct oem_handlers_s
{
    void *oem_data;
    void *user_data;

    /* IPMB address changed.  Can be called by OEM code if it detects
       an IPMB address change.  It should be ignored if NULL. */
    void (*ipmb_addr_change)(channel_t *chan, unsigned char addr);

    /* Do OEM message handling; this is called after the message is
       authenticated.  Should return 0 if the standard handling should
       continue, or non-zero if the message should not go through
       normal handling.  This field may be NULL, and it will be
       ignored. */
    int (*oem_handle_msg)(channel_t *chan, msg_t *msg);

    /* Called before a response is sent.  Should return 0 if the
       standard handling should continue, or non-zero if the OEM
       handled the response itself. */
    int (*oem_handle_rsp)(channel_t *chan, msg_t *msg, rsp_msg_t *rsp);

    /* Check the privilege of a command to see if it is permitted. */
    int (*oem_check_permitted)(unsigned char priv,
			       unsigned char netfn,
			       unsigned char cmd);
} oem_handlers_t;

#define IPMI_MAX_CHANNELS 16
#define NUM_PRIV_LEVEL 4
struct channel_s
{
    lmc_data_t *mc;

    unsigned char medium_type;
    unsigned char protocol_type;
    unsigned char session_support;

    unsigned int PEF_alerting : 1;
    unsigned int PEF_alerting_nonv : 1;
    unsigned int per_msg_auth : 1;

    /* We don't support user-level authentication disable, and access
       mode is always available and cannot be set. */

    unsigned int privilege_limit : 4;
    unsigned int privilege_limit_nonv : 4;

#define MAX_SESSIONS 63
    unsigned int active_sessions : 6;

    struct {
	unsigned char allowed_auths;
    } priv_info[NUM_PRIV_LEVEL];

    /* Information about the MC we are hooked to. */
    unsigned int  manufacturer_id;
    unsigned int  product_id;

    unsigned int channel_num;

    int has_recv_q;
    msg_t *recv_q_head;
    msg_t *recv_q_tail;

    /* Used by channel code. */
    void (*log)(channel_t *chan, int logtype, msg_t *msg,
		const char *format, ...)
	__attribute__ ((__format__ (__printf__, 4, 5)));

    int (*smi_send)(channel_t *chan, msg_t *msg);
    void *(*alloc)(channel_t *chan, int size);
    void (*free)(channel_t *chan, void *data);

    /* Set by channel code */
    void (*return_rsp)(channel_t *chan, msg_t *msg, rsp_msg_t *rsp);
    /* Available for the specific channel code. */
    void *chan_info;

    /* Set or clear the attn flag.  If irq is set, set/clear the irq. */
    void (*set_atn)(channel_t *chan, int val, int irq);

    /* Something is about to be added to the receive queue.  If this returns
       true, then this function consumed the message and it shouldn't
       be queued. */
    int (*recv_in_q)(channel_t *chan, msg_t *msg);

    void (*start_cmd)(channel_t *chan);
    void (*stop_cmd)(channel_t *chan, int do_it_now);

    /* Perform some hardware operations. */
#define HW_OP_RESET		0
#define HW_OP_POWERON		1
#define HW_OP_POWEROFF		2
#define HW_OP_SEND_NMI		3
#define HW_OP_IRQ_ENABLE	4
#define HW_OP_IRQ_DISABLE	5
#define HW_OP_GRACEFUL_SHUTDOWN	6
#define HW_OP_CHECK_POWER	7
    unsigned int hw_capabilities; /* Bitmask of above bits for capabilities. */
#define HW_OP_CAN_RESET(chan) ((chan)->hw_capabilities & (1 << HW_OP_RESET))
#define HW_OP_CAN_POWER(chan) ((chan)->hw_capabilities & (1 << HW_OP_POWERON))
#define HW_OP_CAN_NMI(chan) ((chan)->hw_capabilities & (1 << HW_OP_SEND_NMI))
#define HW_OP_CAN_IRQ(chan) ((chan)->hw_capabilities & (1 << HW_OP_IRQ_ENABLE))
#define HW_OP_CAN_GRACEFUL_SHUTDOWN(chan) ((chan)->hw_capabilities & \
					   (1 << HW_OP_GRACEFUL_SHUTDOWN))
    int (*hw_op)(channel_t *chan, unsigned int op);

    /* Special command handlers. */
    void (*set_lan_parms)(channel_t *chan, msg_t *msg, unsigned char *rdata,
			  unsigned int *rdata_len);
    void (*get_lan_parms)(channel_t *chan, msg_t *msg, unsigned char *rdata,
			  unsigned int *rdata_len);
    void (*set_chan_access)(channel_t *chan, msg_t *msg, unsigned char *rdata,
			    unsigned int *rdata_len);
    int (*set_associated_mc)(channel_t *chan, uint32_t session_id,
			     unsigned int payload, lmc_data_t *mc,
			     uint16_t *port,
			     void (*close)(lmc_data_t *mc, uint32_t session_id,
					   void *cb_data),
			     void *cb_data);
    lmc_data_t *(*get_associated_mc)(channel_t *chan, uint32_t session_id,
				     unsigned int payload);

    oem_handlers_t oem;

    /*
     * Set by the low-level interface code if it needs to handle
     * received messages specially.
     */
    int (*oem_intf_recv_handler)(channel_t *chan, msg_t *msg,
				 unsigned char *rdata, unsigned int *rdata_len);
};

struct user_s
{
    unsigned char valid;
    unsigned char link_auth;
    unsigned char cb_only;
    unsigned char username[16];
    unsigned char pw[20];
    unsigned char privilege;
    unsigned char max_sessions;
    unsigned char curr_sessions;

    /* Set by the user code. */
    int           idx; /* My idx in the table. */
};

/*
 * Restrictions: <=64 users (per spec, 6 bits)
 */
#define MAX_USERS		63
#define USER_BITS_REQ		6 /* Bits required to hold a user. */
#define USER_MASK		0x3f

#define MAX_EVENT_FILTERS 16
#define MAX_ALERT_POLICIES 16
#define MAX_ALERT_STRINGS 16
#define MAX_ALERT_STRING_LEN 64

struct pef_data_s
{
    unsigned int set_in_progress : 2;
    void (*commit)(sys_data_t *sys); /* Called when the commit occurs. */

    unsigned char pef_control;
    unsigned char pef_action_global_control;
    unsigned char pef_startup_delay;
    unsigned char pef_alert_startup_delay;
    unsigned char num_event_filters;
    unsigned char event_filter_table[MAX_EVENT_FILTERS][21];
    unsigned char event_filter_data1[MAX_EVENT_FILTERS][2];
    unsigned char num_alert_policies;
    unsigned char alert_policy_table[MAX_ALERT_POLICIES][4];
    unsigned char system_guid[17];
    unsigned char num_alert_strings;
    unsigned char alert_string_keys[MAX_ALERT_STRINGS][3];
    unsigned char alert_strings[MAX_ALERT_STRINGS][MAX_ALERT_STRING_LEN];

    /* Tells what has changed, so the commit can do something about it. */
    struct {
	unsigned int pef_control : 1;
	unsigned int pef_action_global_control : 1;
	unsigned int pef_startup_delay : 1;
	unsigned int pef_alert_startup_delay : 1;
	unsigned int system_guid : 1;
	unsigned char event_filter_table[MAX_EVENT_FILTERS];
	unsigned char event_filter_data1[MAX_EVENT_FILTERS];
	unsigned char alert_policy_table[MAX_ALERT_POLICIES];
	unsigned int alert_string_keys[MAX_ALERT_STRINGS];
	unsigned int alert_strings[MAX_ALERT_STRINGS];
    } changed;
};

typedef struct ipmi_timer_s ipmi_timer_t;
typedef struct ipmi_io_s ipmi_io_t;

typedef struct sockaddr_ip_s {
    union
        {
	    struct sockaddr s_addr0;
            struct sockaddr_in  s_addr4;
#ifdef PF_INET6
            struct sockaddr_in6 s_addr6;
#endif
        } s_ipsock;
/*    socklen_t addr_len;*/
} sockaddr_ip_t;

typedef struct lan_addr_s {
    sockaddr_ip_t addr;
    socklen_t     addr_len;
} lan_addr_t;

struct startcmd_s {
    /* Command to start a VM */
    char *startcmd;
    unsigned int startnow; /* Start startcmd at simulator startup? */
    unsigned int poweroff_wait_time;
    unsigned int kill_wait_time;
    int vmpid; /* Process id of the VM, 0 if not running. */
    int wait_poweroff;
};

/*
 * Note that we keep odd addresses, too.  In some cases that's useful
 * in virtual systems that don't have I2C restrictions.
 */
#define IPMI_MAX_MCS 256

/*
 * Generic data about the system that is global for the whole system and
 * required for all server types.
 */
struct sys_data_s {
    char *name;

    /* The MCs in the system */
    lmc_data_t *ipmb_addrs[IPMI_MAX_MCS];

#define DEBUG_RAW_MSG	(1 << 0)
#define DEBUG_MSG	(1 << 1)
#define DEBUG_SOL	(1 << 2)
    unsigned int debug;

#define NEW_SESSION			1
#define NEW_SESSION_FAILED		2
#define SESSION_CLOSED			3
#define SESSION_CHALLENGE		4
#define SESSION_CHALLENGE_FAILED	5
#define AUTH_FAILED			6
#define INVALID_MSG			7
#define OS_ERROR			8
#define LAN_ERR				9
#define INFO				10
#define DEBUG				11
#define SETUP_ERROR			12
    void (*log)(sys_data_t *sys, int type, msg_t *msg, const char *format, ...)
	__attribute__ ((__format__ (__printf__, 4, 5)));

    /* Console port.  Length is zero if not set. */
    sockaddr_ip_t console_addr;
    socklen_t console_addr_len;
    int console_fd;

    unsigned char bmc_ipmb;
    int sol_present;

    void *info;

    /*
     * When reading in config, this tracks which information we are
     * working on.  This is initialized to the MC at 0x20, setting
     * the working MC changes these to the new MC.
     */
    channel_t **chan_set;
    startcmd_t *startcmd;
    user_t *cusers;
    pef_data_t *cpef;
    ipmi_sol_t *sol;
    lmc_data_t *mc;

    void *(*alloc)(sys_data_t *sys, int size);
    void (*free)(sys_data_t *sys, void *data);

    int (*get_monotonic_time)(sys_data_t *sys, struct timeval *tv);
    int (*get_real_time)(sys_data_t *sys, struct timeval *tv);

    int (*alloc_timer)(sys_data_t *sys, void (*cb)(void *cb_data),
		       void *cb_data, ipmi_timer_t **timer);
    int (*start_timer)(ipmi_timer_t *timer, struct timeval *timeout);
    int (*stop_timer)(ipmi_timer_t *timer);
    void (*free_timer)(ipmi_timer_t *timer);

    int (*add_io_hnd)(sys_data_t *sys, int fd,
		      void (*read_hnd)(int fd, void *cb_data),
		      void *cb_data, ipmi_io_t **io);
    void (*remove_io_hnd)(ipmi_io_t *io);
    void (*io_set_hnds)(ipmi_io_t *io,
			void (*write_hnd)(int fd, void *cb_data),
			void (*except_hnd)(int fd, void *cb_data));
    void (*io_set_enables)(ipmi_io_t *io, int read, int write, int except);

    int (*gen_rand)(sys_data_t *sys, void *data, int len);

    /* Called by interface code to report that the target did a reset. */
    /* FIXME - move */
    void (*target_reset)(sys_data_t *sys);

    /*
     * These are a hack so the channel code in the MCs can pick up
     * these functions.
     */
    void (*clog)(channel_t *chan, int logtype, msg_t *msg,
		 const char *format, ...);
    int (*csmi_send)(channel_t *chan, msg_t *msg);
    void *(*calloc)(channel_t *chan, int size);
    void (*cfree)(channel_t *chan, void *data);
    int (*lan_channel_init)(void *info, channel_t *chan);
    int (*ser_channel_init)(void *info, channel_t *chan);
};

static inline void
zero_extend_ascii(uint8_t *c, unsigned int len)
{
    unsigned int i;

    i = 0;
    while ((i < len) && (*c != 0)) {
	c++;
	i++;
    }
    while (i < len) {
	*c = 0;
	c++;
	i++;
    }
}

typedef struct ipmi_tick_handler_s {
    void (*handler)(void *info, unsigned int seconds);
    void *info;
    struct ipmi_tick_handler_s *next;
} ipmi_tick_handler_t;

void ipmi_register_tick_handler(ipmi_tick_handler_t *handler);

typedef struct ipmi_child_quit_s {
    void (*handler)(void *info, pid_t pid);
    void *info;
    struct ipmi_child_quit_s *next;
} ipmi_child_quit_t;

void ipmi_register_child_quit_handler(ipmi_child_quit_t *handler);

typedef struct ipmi_shutdown_s {
    void (*handler)(void *info, int sig);
    void *info;
    struct ipmi_shutdown_s *next;
} ipmi_shutdown_t;

void ipmi_register_shutdown_handler(ipmi_shutdown_t *handler);

/* A helper function to allow OEM code to send messages. */
int ipmi_oem_send_msg(channel_t     *chan,
		      unsigned char netfn,
		      unsigned char cmd,
		      unsigned char *data,
		      unsigned int  len,
		      long          oem_data);

void ipmi_handle_smi_rsp(channel_t *chan, msg_t *msg,
			 unsigned char *rsp, int rsp_len);

int channel_smi_send(channel_t *chan, msg_t *msg);

/*
 * Start the "startcmd" specified in the configuration file.
 */
void ipmi_do_start_cmd(startcmd_t *startcmd);
void ipmi_do_kill(startcmd_t *startcmd, int noblock);

int chan_init(channel_t *chan);
void sysinfo_init(sys_data_t *sys);


#define MAX_CONFIG_LINE 1024

const char *mystrtok(char *str, const char *delim, char **next);

/*
 * Note that "value" must be dynamically allocated.  "name" does not have
 * to be.
 */
int add_variable(const char *name, char *value);
const char *find_bvariable(const char *name);

int get_delim_str(char **rtokptr, char **rval, const char **err);

int get_bool(char **tokptr, unsigned int *rval, const char **err);

int get_uint(char **tokptr, unsigned int *rval, const char **err);

int get_int(char **tokptr, int *rval, const char **err);

int get_priv(char **tokptr, unsigned int *rval, const char **err);

int get_auths(char **tokptr, unsigned int *rval, const char **err);

int read_bytes(char **tokptr, unsigned char *data, const char **err,
	       unsigned int len);

int get_sock_addr(char **tokptr, sockaddr_ip_t *addr, socklen_t *len,
		  char *def_port, int socktype, const char **err);

int read_config(sys_data_t    *sys,
		char          *config_file,
		int	      print_version);
int load_dynamic_libs(sys_data_t *sys, int print_version);
void post_init_dynamic_libs(sys_data_t *sys);

void debug_log_raw_msg(sys_data_t *sys,
		       unsigned char *data, unsigned int len,
		       const char *format, ...);

unsigned int ipmi_get_uint16(uint8_t *data);
void ipmi_set_uint16(uint8_t *data, int val);
unsigned int ipmi_get_uint32(uint8_t *data);
void ipmi_set_uint32(uint8_t *data, int val);

uint8_t ipmb_checksum(uint8_t *data, int size, uint8_t start);

/*
 * Command handler interface.
 */
typedef struct emu_data_s emu_data_t;
typedef struct emu_out_s
{
    void (*eprintf)(struct emu_out_s *out, char *format, ...);
    void *data;
} emu_out_t;

#define MC	1
#define NOMC	0
typedef int (*ipmi_emu_cmd_handler)(emu_out_t  *out,
				    emu_data_t *emu,
				    lmc_data_t *mc,
				    char       **toks);
int ipmi_emu_add_cmd(const char *name, unsigned int flags,
		     ipmi_emu_cmd_handler handler);


#endif /* __SERV_H_ */
