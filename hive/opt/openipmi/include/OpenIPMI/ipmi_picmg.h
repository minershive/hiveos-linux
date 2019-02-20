/*
 * ipmi_msgbits.h
 *
 * MontaVista IPMI interface, values used for messages.
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2004,2005 MontaVista Software Inc.
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

#ifndef OPENIPMI_PICMG_H
#define OPENIPMI_PICMG_H

/* The Group Extension defined for PICMG. */
#define IPMI_PICMG_GRP_EXT		0

/* PICMG Commands */
#define IPMI_PICMG_CMD_GET_PROPERTIES			0x00
#define IPMI_PICMG_CMD_GET_ADDRESS_INFO			0x01
#define IPMI_PICMG_CMD_GET_SHELF_ADDRESS_INFO		0x02
#define IPMI_PICMG_CMD_SET_SHELF_ADDRESS_INFO		0x03
#define IPMI_PICMG_CMD_FRU_CONTROL			0x04
#define IPMI_PICMG_CMD_GET_FRU_LED_PROPERTIES		0x05
#define IPMI_PICMG_CMD_GET_LED_COLOR_CAPABILITIES	0x06
#define IPMI_PICMG_CMD_SET_FRU_LED_STATE		0x07
#define IPMI_PICMG_CMD_GET_FRU_LED_STATE		0x08
#define IPMI_PICMG_CMD_SET_IPMB_STATE			0x09
#define IPMI_PICMG_CMD_SET_FRU_ACTIVATION_POLICY	0x0a
#define IPMI_PICMG_CMD_GET_FRU_ACTIVATION_POLICY	0x0b
#define IPMI_PICMG_CMD_SET_FRU_ACTIVATION		0x0c
#define IPMI_PICMG_CMD_GET_DEVICE_LOCATOR_RECORD	0x0d
#define IPMI_PICMG_CMD_SET_PORT_STATE			0x0e
#define IPMI_PICMG_CMD_GET_PORT_STATE			0x0f
#define IPMI_PICMG_CMD_COMPUTE_POWER_PROPERTIES		0x10
#define IPMI_PICMG_CMD_SET_POWER_LEVEL			0x11
#define IPMI_PICMG_CMD_GET_POWER_LEVEL			0x12
#define IPMI_PICMG_CMD_RENEGOTIATE_POWER		0x13
#define IPMI_PICMG_CMD_GET_FAN_SPEED_PROPERTIES		0x14
#define IPMI_PICMG_CMD_SET_FAN_LEVEL			0x15
#define IPMI_PICMG_CMD_GET_FAN_LEVEL			0x16
#define IPMI_PICMG_CMD_BUSED_RESOURCE			0x17
#define IPMI_PICMG_CMD_IPMB_LINK_INFO			0x18
#define IPMI_PICMG_CMD_SET_AMC_PORT_STATE               0x19
#define IPMI_PICMG_CMD_GET_AMC_PORT_STATE               0x1a
#define IPMI_PICMG_CMD_SHELF_MANAGER_IPMB_ADDRESS	0x1b
#define IPMI_PICMG_CMD_SET_FAN_POLICY			0x1c
#define IPMI_PICMG_CMD_GET_FAN_POLICY			0x1d
#define IPMI_PICMG_CMD_FRU_CONTROL_CAPABILITIES		0x1e
#define IPMI_PICMG_CMD_FRU_INVENTORY_DEVICE_LOCK_CONTROL 0x1f
#define IPMI_PICMG_CMD_FRU_INVENTORY_DEVICE_WRITE	0x20
#define IPMI_PICMG_CMD_GET_SHELF_MANAGER_IP_ADDRESSES	0x21
#define IPMI_PICMG_CMD_SHELF_POWER_ALLOCATION           0x22

#endif /* OPENIPMI_PICMG_H */
