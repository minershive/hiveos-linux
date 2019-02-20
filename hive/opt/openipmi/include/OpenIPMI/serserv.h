/*
 * serserv.h
 *
 * MontaVista IPMI serial server include file
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2012 MontaVista Software Inc.
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

#ifndef __SERSERV_H
#define __SERSERV_H

#include <OpenIPMI/serv.h>
#include <OpenIPMI/os_handler.h>

typedef struct serserv_data_s serserv_data_t;

typedef struct ser_codec_s {
    const char *name;
    void (*handle_char)(unsigned char ch, serserv_data_t *si);
    void (*send)(msg_t *msg, serserv_data_t *si);
    int (*setup)(serserv_data_t *si);
    void (*connected)(serserv_data_t *si);
    void (*disconnected)(serserv_data_t *si);
} ser_codec_t;

typedef struct ser_oem_handler_s {
    const char *name;
    int (*handler)(channel_t *chan, msg_t *msg, unsigned char *rdata,
		   unsigned int *rdata_len);
    void (*init)(serserv_data_t *si);
} ser_oem_handler_t;

struct serserv_data_s {
    lan_addr_t addr;

    channel_t channel;

    os_handler_t *os_hnd;

    sys_data_t *sysinfo;

    void *user_info;

    int bind_fd;
    int con_fd;

    int connected;

    void (*send_out)(serserv_data_t *si, unsigned char *data,
		     unsigned int data_len);

    ser_codec_t *codec;
    void *codec_info;

    ser_oem_handler_t *oem;
    void *oem_info;

    /* Settings */
    int           debug;
    unsigned int  do_connect : 1;
    unsigned int  echo : 1;
    unsigned int  do_attn : 1;
    unsigned char my_ipmb;
    unsigned char global_enables;
    unsigned char attn_chars[8];
    unsigned int  attn_chars_len;
};

int serserv_read_config(char **tokptr, sys_data_t *sys, const char **errstr);
int serserv_init(serserv_data_t *ser);
void serserv_handle_data(serserv_data_t *ser, uint8_t *data, unsigned int len);

#endif /* __SERSERV_H */
