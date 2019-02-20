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

#ifndef __MSG_H_
#define __MSG_H_

#include <stdint.h>

typedef struct channel_s channel_t;

typedef struct msg_s
{
    void *src_addr;
    int  src_len;

    long oem_data; /* For use by OEM handlers.  This will be set to
                      zero by the calling code. */

    unsigned char channel;

    /* The channel the message originally came in on. */
    channel_t *orig_channel;

    unsigned char authtype;
    uint32_t      seq;
    uint32_t      sid;

    union {
	struct {
	    /* RMCP parms */
	    unsigned char *authcode;
	    unsigned char authcode_data[16];
	} rmcp;
	struct {
	    /* RMCP+ parms */
	    unsigned char payload;
	    unsigned char encrypted;
	    unsigned char authenticated;
	    unsigned char iana[3];
	    uint16_t      payload_id;
	    unsigned char *authdata;
	    unsigned int  authdata_len;
	} rmcpp;
    };

    unsigned char netfn;
    unsigned char rs_addr;
    unsigned char rs_lun;
    unsigned char rq_addr;
    unsigned char rq_lun;
    unsigned char rq_seq;
    unsigned char cmd;

    unsigned char *data;
    unsigned int  len;

    uint32_t iana; /* Set for IANA commands */

    struct msg_s *next;
} msg_t;

#define IPMI_SIM_MAX_MSG_LENGTH 255

typedef struct rsp_msg
{
    uint8_t        netfn;
    uint8_t        cmd;
    unsigned short data_len;
    uint8_t        *data;
} rsp_msg_t;

typedef struct sys_data_s sys_data_t;
typedef struct startcmd_s startcmd_t;
typedef struct user_s user_t;
typedef struct pef_data_s pef_data_t;

#endif /* __MSG_H_ */
