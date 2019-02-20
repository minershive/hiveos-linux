/*
 * mcserv.h
 *
 * MontaVista IPMI LAN server include file
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2003,2004,2005 MontaVista Software Inc.
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

#ifndef __MCSERV_H
#define __MCSERV_H

#include <OpenIPMI/msg.h>
#include <OpenIPMI/os_handler.h>

typedef struct lmc_data_s lmc_data_t;

typedef struct solparm_s {
    int enabled;
    int bitrate;
    int bitrate_nonv;
    int default_bitrate;
} solparm_t;

typedef struct soldata_s soldata_t;

typedef struct ipmi_sol_s {
    int configured;

    char *device;

    /* TCP-specific information. */
    const char *tcpdest;
    const char *tcpport;
    int do_telnet;

    int set_in_progress;
    solparm_t solparm;
    solparm_t solparm_rollback;
    void (*update_bitrate)(lmc_data_t *mc);

    int active;
    uint32_t session_id;

    /* A history buffer, hooking to instance 2 will dump it, if it's non-zero */
    unsigned int history_size;
    int history_active;
    uint32_t history_session_id;

    /* History is stored in this file is the program fails. */
    char *backupfile;

    int use_rtscts;
    int readclear;

    soldata_t *soldata;
} ipmi_sol_t;

int ipmi_mc_alloc_unconfigured(sys_data_t *sys, unsigned char ipmb,
			       lmc_data_t **rmc);

unsigned char ipmi_mc_get_ipmb(lmc_data_t *mc);
channel_t **ipmi_mc_get_channelset(lmc_data_t *mc);
ipmi_sol_t *ipmi_mc_get_sol(lmc_data_t *mc);
startcmd_t *ipmi_mc_get_startcmdinfo(lmc_data_t *mc);
user_t *ipmi_mc_get_users(lmc_data_t *mc);
pef_data_t *ipmi_mc_get_pef(lmc_data_t *mc);
int ipmi_mc_is_power_on(lmc_data_t *mc);

void ipmi_mc_destroy(lmc_data_t *mc);

void ipmi_mc_disable(lmc_data_t *mc);
void ipmi_mc_enable(lmc_data_t *mc);

void ipmi_resend_atn(channel_t *chan);
msg_t *ipmi_mc_get_next_recv_q(channel_t *chan);

int ipmi_emu_set_mc_guid(lmc_data_t *mc,
			 unsigned char guid[16],
			 int force);

int ipmi_mc_enable_sel(lmc_data_t    *emu,
		       int           max_entries,
		       unsigned char flags);

int ipmi_mc_add_to_sel(lmc_data_t    *emu,
		       unsigned char record_type,
		       unsigned char event[13],
		       unsigned int  *recid);

int ipmi_mc_add_main_sdr(lmc_data_t    *mc,
			 unsigned char *data,
			 unsigned int  data_len);

int ipmi_mc_add_device_sdr(lmc_data_t    *mc,
			   unsigned char lun,
			   unsigned char *data,
			   unsigned int  data_len);

enum fru_io_cb_op { FRU_IO_READ, FRU_IO_WRITE };

typedef int (*fru_io_cb)(void *cb_data,
			 enum fru_io_cb_op op,
			 unsigned char *data,
			 unsigned int offset,
			 unsigned int length);

/*
 * Add a fru inventory device to the MC.  If fru_io_cb is NULL, the data
 * and length is the initial data for the FRU.  Otherwise, fru_io_cb is
 * called for reads and writes, and the data is the callback data for
 * fru_io_cb.
 */
int ipmi_mc_add_fru_data(lmc_data_t    *mc,
			 unsigned char device_id,
			 unsigned int  length,
			 fru_io_cb     fru_io_cb,
			 void          *data);

/*
 * Add a fru inventory device to the MC, mapping it to a file at the
 * given filename, starting in the file at the given offset.
 */
int ipmi_mc_add_fru_file(lmc_data_t    *mc,
			 unsigned char device_id,
			 unsigned int  length,
			 unsigned int  file_offset,
			 const char    *filename);

int ipmi_mc_get_fru_data_len(lmc_data_t    *mc,
			     unsigned char device_id,
			     unsigned int  *length);

int ipmi_mc_get_fru_data(lmc_data_t    *mc,
			 unsigned char device_id,
			 unsigned int  length,
			 unsigned char *data);

/*
 * FRUs have a semaphore that can be use to grant exclusive access.
 * The semaphore is attempted to get before read and write operations,
 * if it fails then an error is returned.  If something else reads or
 * writes the FRU, then it should claim the semaphore before posting.
 */
int ipmi_mc_fru_sem_wait(lmc_data_t *mc, unsigned char device_id);
int ipmi_mc_fru_sem_trywait(lmc_data_t *mc, unsigned char device_id);
int ipmi_mc_fru_sem_post(lmc_data_t *mc, unsigned char device_id);

int ipmi_mc_sensor_set_bit(lmc_data_t   *mc,
			   unsigned char lun,
			   unsigned char sens_num,
			   unsigned char bit,
			   unsigned char value,
			   int           gen_event);

int ipmi_mc_sensor_set_bit_clr_rest(lmc_data_t   *mc,
				    unsigned char lun,
				    unsigned char sens_num,
				    unsigned char bit,
				    int           gen_event);

int ipmi_mc_sensor_set_enabled(lmc_data_t    *mc,
			       unsigned char lun,
			       unsigned char sens_num,
			       unsigned char enabled);

int ipmi_mc_sensor_set_value(lmc_data_t    *mc,
			     unsigned char lun,
			     unsigned char sens_num,
			     unsigned char value,
			     int           gen_event);

int ipmi_mc_sensor_set_hysteresis(lmc_data_t    *mc,
				  unsigned char lun,
				  unsigned char sens_num,
				  unsigned char support,
				  unsigned char positive,
				  unsigned char negative);

int ipmi_mc_sensor_set_threshold(lmc_data_t    *mc,
				 unsigned char lun,
				 unsigned char sens_num,
				 unsigned char support,
				 uint16_t supported,
				 int set_values,
				 unsigned char values[6]);

int ipmi_mc_sensor_add_rearm_handler(lmc_data_t    *mc,
				     unsigned char lun,
				     unsigned char sens_num,
				     int (*handler)(void *cb_data,
						    uint16_t assert,
						    uint16_t deassert),
				     void *cb_data);

int ipmi_mc_sensor_set_event_support(lmc_data_t    *mc,
				     unsigned char lun,
				     unsigned char sens_num,
				     unsigned char init_events,
				     unsigned char events_enable,
				     unsigned char init_scanning,
				     unsigned char scanning_enable,
				     unsigned char support,
				     uint16_t assert_supported,
				     uint16_t deassert_supported,
				     uint16_t assert_enabled,
				     uint16_t deassert_enabled);

struct ipmi_sensor_handler_s
{
    char *name;
    int (*poll)(void *cb_data, unsigned int *val, const char **errstr);
    int (*init)(lmc_data_t *mc, unsigned char lun, unsigned char sensor_num,
		char **toks, void *cb_data, void **rcb_data,
		const char **errstr);
    int (*postinit)(void *cb_data, const char **errstr);
    void *cb_data;

    struct ipmi_sensor_handler_s *next;
};
typedef struct ipmi_sensor_handler_s ipmi_sensor_handler_t;

int ipmi_sensor_add_handler(ipmi_sensor_handler_t *handler);
ipmi_sensor_handler_t *ipmi_sensor_find_handler(const char *name);

int ipmi_mc_add_sensor(lmc_data_t    *mc,
		       unsigned char lun,
		       unsigned char sens_num,
		       unsigned char type,
		       unsigned char event_reading_code,
		       int           event_only);

int ipmi_mc_add_polled_sensor(lmc_data_t    *mc,
			      unsigned char lun,
			      unsigned char sens_num,
			      unsigned char type,
			      unsigned char event_reading_code,
			      unsigned int poll_rate,
			      int (*poll)(void *cb_data, unsigned int *val,
					  const char **errstr),
			      void *cb_data);

int ipmi_mc_set_power(lmc_data_t *mc, unsigned char power, int gen_int);

int ipmi_mc_set_num_leds(lmc_data_t   *mc,
			 unsigned int count);

void ipmi_emu_set_device_id(lmc_data_t *emu, unsigned char device_id);
unsigned char ipmi_emu_get_device_id(lmc_data_t *emu);
void ipmi_set_has_device_sdrs(lmc_data_t *emu, unsigned char has_device_sdrs);
unsigned char ipmi_get_has_device_sdrs(lmc_data_t *emu);
void ipmi_set_device_revision(lmc_data_t *emu, unsigned char device_revision);
unsigned char ipmi_get_device_revision(lmc_data_t *emu);
void ipmi_set_major_fw_rev(lmc_data_t *emu, unsigned char major_fw_rev);
unsigned char ipmi_get_major_fw_rev(lmc_data_t *emu);
void ipmi_set_minor_fw_rev(lmc_data_t *emu, unsigned char minor_fw_rev);
unsigned char ipmi_get_minor_fw_rev(lmc_data_t *emu);
void ipmi_set_device_support(lmc_data_t *emu, unsigned char device_support);
unsigned char ipmi_get_device_support(lmc_data_t *emu);
void ipmi_set_mfg_id(lmc_data_t *emu, unsigned char mfg_id[3]);
void ipmi_get_mfg_id(lmc_data_t *emu, unsigned char mfg_id[3]);
void ipmi_set_product_id(lmc_data_t *emu, unsigned char product_id[3]);
void ipmi_get_product_id(lmc_data_t *emu, unsigned char product_id[3]);
void ipmi_set_chassis_control_prog(lmc_data_t *mc, const char *prog);

void read_persist_users(sys_data_t *sys);
int write_persist_users(sys_data_t *sys);
int read_sol_config(sys_data_t *sys);
int write_sol_config(lmc_data_t *mc);
int sol_read_config(char **tokptr, sys_data_t *sys, const char **err);

int ipmi_mc_users_changed(lmc_data_t *mc);

/*
 * Types and functions for registering handlers with the MC emulator.
 */
typedef void (*cmd_handler_f)(lmc_data_t    *mc,
			      msg_t         *msg,
			      unsigned char *rdata,
			      unsigned int  *rdata_len,
			      void          *cb_data);
int ipmi_emu_register_cmd_handler(unsigned char netfn, unsigned char cmd,
				  cmd_handler_f handler, void *cb_data);

/*
 * Note that for IANA command handlers the IANA is stripped (and put into
 * msg->iana) before being passed to the handler, and inserted into the
 * response message automatically.  So the handler should handle this
 * like a normal message, setting the data and length as if the IANA was
 * not there.  This way standard handling functions will work properly,
 * and it simplifies the handling of IANA messages.
 */
int ipmi_emu_register_iana_handler(uint32_t iana, cmd_handler_f handler,
				   void *cb_data);
int ipmi_emu_register_oi_iana_handler(uint8_t cmd, cmd_handler_f handler,
				      void *cb_data);

#define OPENIPMI_IANA_CMD_SET_HISTORY_RETURN_SIZE	1
#define OPENIPMI_IANA_CMD_GET_HISTORY_RETURN_SIZE	2

/*
 * SOL handling
 */

void ipmi_sol_activate(lmc_data_t    *mc,
		       channel_t     *channel,
		       msg_t         *msg,
		       unsigned char *rdata,
		       unsigned int  *rdata_len);

void ipmi_sol_deactivate(lmc_data_t    *mc,
			 channel_t     *channel,
			 msg_t         *msg,
			 unsigned char *rdata,
			 unsigned int  *rdata_len);

int sol_init_mc(sys_data_t *sys, lmc_data_t *mc);
int sol_init(sys_data_t *sys);
unsigned char *sol_set_frudata(lmc_data_t *mc, unsigned int *size);
void sol_free_frudata(lmc_data_t *mc, unsigned char *data);

typedef unsigned char *(*get_frudata_f)(lmc_data_t *mc, unsigned int *size);
typedef void (*free_frudata_f)(lmc_data_t *mc, unsigned char *data);
int ipmi_mc_set_frudata_handler(lmc_data_t *mc, unsigned int fru,
				get_frudata_f handler, free_frudata_f freefunc);


#define CHASSIS_CONTROL_POWER 0
#define CHASSIS_CONTROL_RESET 1
#define CHASSIS_CONTROL_BOOT  2
#define CHASSIS_CONTROL_BOOT_INFO_ACK  3
#define CHASSIS_CONTROL_GRACEFUL_SHUTDOWN  4
#define CHASSIS_CONTROL_IDENTIFY 5
void ipmi_mc_set_chassis_control_func(lmc_data_t *mc,
				      int (*set)(lmc_data_t *mc, int op,
						 unsigned char *val,
						 void *cb_data),
				      int (*get)(lmc_data_t *mc, int op,
						 unsigned char *val,
						 void *cb_data),
				      void *cb_data);

/*
 * Message handling.
 */

void handle_invalid_cmd(lmc_data_t    *mc,
			unsigned char *rdata,
			unsigned int  *rdata_len);
int check_msg_length(msg_t         *msg,
		     unsigned int  len,
		     unsigned char *rdata,
		     unsigned int  *rdata_len);

void ipmi_mc_set_dev_revision(lmc_data_t *mc, unsigned char dev_revision);
void ipmi_mc_set_fw_revision(lmc_data_t *mc, unsigned char fw_revision_major,
			     unsigned char fw_revision_minor);
void ipmi_mc_set_aux_fw_revision(lmc_data_t *mc,
				 unsigned char aux_fw_revision[4]);
const char *get_lanserv_version(void);

#endif /* __MCSERV_H */
