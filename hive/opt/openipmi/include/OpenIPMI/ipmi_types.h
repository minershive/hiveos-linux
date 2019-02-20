/*
 * ipmi_types.h
 *
 * MontaVista IPMI interface general types.
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

#ifndef OPENIPMI_TYPES_H
#define OPENIPMI_TYPES_H

#include <stdint.h>
#include <OpenIPMI/ipmi_addr.h>
#include <OpenIPMI/deprecator.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * These are the main types the user has to deal with.
 */

/*
 * This represents IPMI system, called a "domain".  A domain is where
 * a set of entities reside.
 */
typedef struct ipmi_domain_s ipmi_domain_t;
typedef struct ipmi_domain_id_s ipmi_domain_id_t;

/*
 * An entity is a physical device that can be monitored or controlled.
 */
typedef struct ipmi_entity_s ipmi_entity_t;
typedef struct ipmi_entity_id_s ipmi_entity_id_t;

/* 
 * A fru is something that an entity contains that holds information
 * about the entity in a defined format.
 */
typedef struct ipmi_fru_s ipmi_fru_t;

/*
 * A sensor is something connected to an entity that can monitor or control
 * the entity.
 */
typedef struct ipmi_sensor_s ipmi_sensor_t;
typedef struct ipmi_sensor_id_s ipmi_sensor_id_t;

/*
 * A control is an output device, such as a light, relay, or display.
 */
typedef struct ipmi_control_s ipmi_control_t;
typedef struct ipmi_control_id_s ipmi_control_id_t;

/* Used to represent a time difference, in nanoseconds. */
typedef int64_t ipmi_timeout_t;

#define IPMI_INVALID_TIME INT64_MIN
/* Used to represent an absolute time, in nanoseconds since 00:00 Jan
   1, 1970 */
typedef int64_t ipmi_time_t;

/* This type holds the arguments for an IPMI connection. */
typedef struct ipmi_args_s ipmi_args_t;

#ifndef __LINUX_IPMI_H /* Don't include this is we are including the kernel */

#define IPMI_MAX_MSG_LENGTH	256

/* A raw IPMI message without any addressing.  This covers both
   commands and responses.  The completion code is always the first
   byte of data in the response (as the spec shows the messages laid
   out). */
typedef struct ipmi_msg
{
    unsigned char  netfn;
    unsigned char  cmd;
    unsigned short data_len;
    unsigned char  *data;
} ipmi_msg_t;

#else

/* Generate a type for the kernel version of this. */
typedef struct ipmi_msg ipmi_msg_t;

#endif

/* A structure used to hold messages that can be put into a linked
   list. */
typedef struct ipmi_msg_item_s
{
    ipmi_addr_t   addr;
    unsigned int  addr_len;
    ipmi_msg_t    msg;
    unsigned char data[IPMI_MAX_MSG_LENGTH];
    struct ipmi_msg_item_s *next;
    void          *data1;
    void          *data2;
    void          *data3;
    void          *data4;
} ipmi_msgi_t;

/* Return values for function that take the previous item. */
/* Use this if you are not keeping the message structure for later user. */
#define IPMI_MSG_ITEM_NOT_USED	0
/* If you keep the message data in a callback, return this so the caller
   knows to not free the data itself.  You must free it later. */
#define IPMI_MSG_ITEM_USED	1

/* Pay no attention to the contents of these structures... */
struct ipmi_domain_id_s
{
    ipmi_domain_t *domain;
};
#define IPMI_DOMAIN_ID_INVALID { NULL }

struct ipmi_entity_id_s
{
    ipmi_domain_id_t domain_id;
    unsigned int     entity_id       : 8;
    unsigned int     entity_instance : 8;
    unsigned int     channel         : 4;
    unsigned int     address         : 8;
    long             seq;
};
#define IPMI_ENTITY_ID_INVALID { IPMI_DOMAIN_ID_INVALID, 0, 0, 0, 0, 0 }

/* This structure is kind of a cheap hack.  It's internal and
   definately *NOT* for use by the user.  It can represent two
   different types of addresses.  An IPMI will have a normal channel
   number (usually 0 or 1) and the IPMB address will be in "mc_num".
   A direct connection to a system interface (KCS, LAN, etc.) is
   represented as IPMI_BMC_CHANNEL in the channel number and the
   interface number in mc_num.  Multiple interface numbers are used
   because you can have more than one connection to a domain; the
   first connection will be mc_num 0, the second will be mc_num 1,
   etc. */
typedef struct ipmi_mcid_s
{
    ipmi_domain_id_t domain_id;
    unsigned char    mc_num;
    unsigned char    channel;
    long             seq;
} ipmi_mcid_t;
#define IPMI_MCID_INVALID { IPMI_DOMAIN_ID_INVALID, 0, 0, 0 }

typedef struct ipmi_mc_s ipmi_mc_t;

struct ipmi_sensor_id_s
{
    ipmi_mcid_t  mcid;
    unsigned int lun        : 3;
    unsigned int sensor_num : 8;
};
#define IPMI_SENSOR_ID_INVALID { IPMI_MCID_INVALID, 0, 0 }

struct ipmi_control_id_s
{
    ipmi_mcid_t  mcid;
    unsigned int lun         : 3;
    unsigned int control_num : 8;
};
#define IPMI_CONTROL_ID_INVALID { IPMI_MCID_INVALID, 0, 0 }

/* The event structure is no longer public. */
typedef struct ipmi_event_s ipmi_event_t;

/* This represents a low-level connection. */
typedef struct ipmi_con_s ipmi_con_t;

/*
 * Channel information for a connection.
 */
typedef struct ipmi_chan_info_s
{
    unsigned int medium : 7;
    unsigned int xmit_support : 1;
    unsigned int recv_lun : 3;
    unsigned int protocol : 5;
    unsigned int session_support : 2;
    unsigned int vendor_id : 24;
    unsigned int aux_info : 16;
} ipmi_chan_info_t;

#define MAX_IPMI_USED_CHANNELS 14

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_TYPES_H */
