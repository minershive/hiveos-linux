/*
 * ipmi_addr.h
 *
 * Addressing information for IPMI interfaces.
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2002,2003,2004,2005 MontaVista Software Inc.
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

#ifndef OPENIPMI_ADDR_H
#define OPENIPMI_ADDR_H

/* To get a socket. */
#include <netinet/in.h>

#ifdef __cplusplus
extern "C" {
#endif

/* The formats of these MUST match the formats for the kernel. */

#ifndef __LINUX_IPMI_H /* Don't include this if we are including the kernel */

/* This is an overlay for all the address types, so it's easy to
   determine the actual address type.  This is kind of like addresses
   work for sockets. */
#define IPMI_MAX_ADDR_SIZE 32
struct ipmi_addr
{
	 /* Try to take these from the "Channel Medium Type" table
	    in section 6.5 of the IPMI 1.5 manual. */
	int   addr_type;
	short channel;
	char  data[IPMI_MAX_ADDR_SIZE];
};

/* When the address is not used, the type will be set to this value.
   The channel is the BMC's channel number for the channel (usually
   0), or IPMC_BMC_CHANNEL if communicating directly with the BMC. */
#define IPMI_SYSTEM_INTERFACE_ADDR_TYPE	0xc
struct ipmi_system_interface_addr
{
	int           addr_type;
	short         channel;
	unsigned char lun;
};

/* An IPMB Address. */
#define IPMI_IPMB_ADDR_TYPE	1
/* Used for broadcast get device id as described in section 17.9 of the
   IPMI 1.5 manual. */
#define IPMI_IPMB_BROADCAST_ADDR_TYPE   0x41
struct ipmi_ipmb_addr
{
	int           addr_type;
	short         channel;
	unsigned char slave_addr;
	unsigned char lun;
};

/*
 * A LAN Address.  This is an address to/from a LAN interface bridged
 * by the BMC, not an address actually out on the LAN.
 *
 * A concious decision was made here to deviate slightly from the IPMI
 * spec.  We do not use rqSWID and rsSWID like it shows in the
 * message.  Instead, we use remote_SWID and local_SWID.  This means
 * that any message (a request or response) from another device will
 * always have exactly the same address.  If you didn't do this,
 * requests and responses from the same device would have different
 * addresses, and that's not too cool.
 *
 * In this address, the remote_SWID is always the SWID the remote
 * message came from, or the SWID we are sending the message to.
 * local_SWID is always our SWID.  Note that having our SWID in the
 * message is a little wierd, but this is required.
 */
#define IPMI_LAN_ADDR_TYPE		0x04
struct ipmi_lan_addr
{
	int           addr_type;
	short         channel;
	unsigned char privilege;
	unsigned char session_handle;
	unsigned char remote_SWID;
	unsigned char local_SWID;
	unsigned char lun;
};

/* Channel for talking directly with the BMC.  When using this
   channel, This is for the system interface address type only.
   FIXME - is this right, or should we use -1? */
#define IPMI_BMC_CHANNEL  0xf

/* The channel that means "The channel we are talking on". */
#define IPMI_SELF_CHANNEL 0xe

#define IPMI_NUM_CHANNELS 0x10

#endif /* __LINUX_IPMI_H */

/* RMCP+ address types are in this range.  These map to payloads.  Note
   that 0x100 is specially used; it would be IPMI if there was no
   special handling, but it is used for RMCP messages outside the
   session. */
#define IPMI_RMCPP_ADDR_START		0x100
#define IPMI_RMCPP_ADDR_END		0x13f
typedef struct ipmi_rmcpp_addr
{
	int           addr_type;

        /* These fields are only used if this is a type 2 payload
	   (0x102 for the addr_type).  The IANA comes from the lan
	   challenge for the other oem payload types (0x20-0x27) */
	unsigned char oem_iana[3];
	uint16_t      oem_payload_id;
} ipmi_rmcpp_addr_t;

/* This is outside the range of normal NETFNs, it is used for
   registering for RMCP things. */
#define IPMI_RMCPP_DUMMY_NETFN		0x40

/* Generate types for the kernel versions of these. */
typedef struct ipmi_addr ipmi_addr_t;
typedef struct ipmi_system_interface_addr ipmi_system_interface_addr_t;
typedef struct ipmi_ipmb_addr ipmi_ipmb_addr_t;
typedef struct ipmi_lan_addr ipmi_lan_addr_t;

/* An 802.3 LAN address */
#define IPMI_802_3_ADDR_TYPE 4
typedef struct ipmi_802_3_addr_s
{
	int            addr_type;
	short          channel;
	struct in_addr addr;
	unsigned short port;
} ipmi_802_3_addr_t;

/* Compare two IPMI addresses, and return false if they are equal and
   true if they are not. */
int ipmi_addr_equal(const ipmi_addr_t *addr1,
		    int               addr1_len,
		    const ipmi_addr_t *addr2,
		    int               addr2_len);
unsigned int ipmi_addr_get_lun(const ipmi_addr_t *addr);
int ipmi_addr_set_lun(ipmi_addr_t *addr, unsigned int lun);

/* Like the above, but do not use the LUN in the comparison. */
int ipmi_addr_equal_nolun(const ipmi_addr_t *addr1,
			  int               addr1_len,
			  const ipmi_addr_t *addr2,
			  int               addr2_len);

/* Get the slave address from the address, returns 0 if the address
   does not have a slave address. */
unsigned int ipmi_addr_get_slave_addr(const ipmi_addr_t *addr);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_ADDR_H */
