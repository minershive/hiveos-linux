/*
 * ipmi_msgbits.h
 *
 * MontaVista IPMI interface, values used for messages.
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

#ifndef OPENIPMI_MSGBITS_H
#define OPENIPMI_MSGBITS_H

#define MAX_IPMI_DATA_SIZE 36

/*
 * IPMI commands
 */

/* Chassis netfn (0x00) */
#define IPMI_GET_CHASSIS_CAPABILITIES_CMD	0x00
#define IPMI_GET_CHASSIS_STATUS_CMD		0x01
#define IPMI_CHASSIS_CONTROL_CMD		0x02
#define IPMI_CHASSIS_RESET_CMD			0x03
#define IPMI_CHASSIS_IDENTIFY_CMD		0x04
#define IPMI_SET_CHASSIS_CAPABILITIES_CMD	0x05
#define IPMI_SET_POWER_RESTORE_POLICY_CMD	0x06
#define IPMI_GET_SYSTEM_RESTART_CAUSE_CMD	0x07
#define IPMI_SET_SYSTEM_BOOT_OPTIONS_CMD	0x08
#define IPMI_GET_SYSTEM_BOOT_OPTIONS_CMD	0x09

#define IPMI_GET_POH_COUNTER_CMD		0x0f

/* Bridge netfn (0x00) */
#define IPMI_GET_BRIDGE_STATE_CMD		0x00
#define IPMI_SET_BRIDGE_STATE_CMD		0x01
#define IPMI_GET_ICMB_ADDRESS_CMD		0x02
#define IPMI_SET_ICMB_ADDRESS_CMD		0x03
#define IPMI_SET_BRIDGE_PROXY_ADDRESS_CMD	0x04
#define IPMI_GET_BRIDGE_STATISTICS_CMD		0x05
#define IPMI_GET_ICMB_CAPABILITIES_CMD		0x06

#define IPMI_CLEAR_BRIDGE_STATISTICS_CMD	0x08
#define IPMI_GET_BRIDGE_PROXY_ADDRESS_CMD	0x09
#define IPMI_GET_ICMB_CONNECTOR_INFO_CMD	0x0a
#define IPMI_SET_ICMB_CONNECTOR_INFO_CMD	0x0b
#define IPMI_SEND_ICMB_CONNECTION_ID_CMD	0x0c

#define IPMI_PREPARE_FOR_DISCOVERY_CMD		0x10
#define IPMI_GET_ADDRESSES_CMD			0x11
#define IPMI_SET_DISCOVERED_CMD			0x12
#define IPMI_GET_CHASSIS_DEVICE_ID_CMD		0x13
#define IPMI_SET_CHASSIS_DEVICE_ID_CMD		0x14

#define IPMI_BRIDGE_REQUEST_CMD			0x20
#define IPMI_BRIDGE_MESSAGE_CMD			0x21

#define IPMI_GET_EVENT_COUNT_CMD		0x30
#define IPMI_SET_EVENT_DESTINATION_CMD		0x31
#define IPMI_SET_EVENT_RECEPTION_STATE_CMD	0x32
#define IPMI_SEND_ICMB_EVENT_MESSAGE_CMD	0x33
#define IPMI_GET_EVENT_DESTIATION_CMD		0x34
#define IPMI_GET_EVENT_RECEPTION_STATE_CMD	0x35

#define IPMI_ERROR_REPORT_CMD			0xff

/* Sensor/Event netfn (0x04) */
#define IPMI_SET_EVENT_RECEIVER_CMD		0x00
#define IPMI_GET_EVENT_RECEIVER_CMD		0x01
#define IPMI_PLATFORM_EVENT_CMD			0x02

#define IPMI_GET_PEF_CAPABILITIES_CMD		0x10
#define IPMI_ARM_PEF_POSTPONE_TIMER_CMD		0x11
#define IPMI_SET_PEF_CONFIG_PARMS_CMD		0x12
#define IPMI_GET_PEF_CONFIG_PARMS_CMD		0x13
#define IPMI_SET_LAST_PROCESSED_EVENT_ID_CMD	0x14
#define IPMI_GET_LAST_PROCESSED_EVENT_ID_CMD	0x15
#define IPMI_ALERT_IMMEDIATE_CMD		0x16
#define IPMI_PET_ACKNOWLEDGE_CMD		0x17

#define IPMI_GET_DEVICE_SDR_INFO_CMD		0x20
#define IPMI_GET_DEVICE_SDR_CMD			0x21
#define IPMI_RESERVE_DEVICE_SDR_REPOSITORY_CMD	0x22
#define IPMI_GET_SENSOR_READING_FACTORS_CMD	0x23
#define IPMI_SET_SENSOR_HYSTERESIS_CMD		0x24
#define IPMI_GET_SENSOR_HYSTERESIS_CMD		0x25
#define IPMI_SET_SENSOR_THRESHOLD_CMD		0x26
#define IPMI_GET_SENSOR_THRESHOLD_CMD		0x27
#define IPMI_SET_SENSOR_EVENT_ENABLE_CMD	0x28
#define IPMI_GET_SENSOR_EVENT_ENABLE_CMD	0x29
#define IPMI_REARM_SENSOR_EVENTS_CMD		0x2a
#define IPMI_GET_SENSOR_EVENT_STATUS_CMD	0x2b
#define IPMI_GET_SENSOR_READING_CMD		0x2d
#define IPMI_SET_SENSOR_TYPE_CMD		0x2e
#define IPMI_GET_SENSOR_TYPE_CMD		0x2f

/* App netfn (0x06) */
#define IPMI_GET_DEVICE_ID_CMD			0x01
#define IPMI_BROADCAST_GET_DEVICE_ID_CMD	0x01
#define IPMI_COLD_RESET_CMD			0x02
#define IPMI_WARM_RESET_CMD			0x03
#define IPMI_GET_SELF_TEST_RESULTS_CMD		0x04
#define IPMI_MANUFACTURING_TEST_ON_CMD		0x05
#define IPMI_SET_ACPI_POWER_STATE_CMD		0x06
#define IPMI_GET_ACPI_POWER_STATE_CMD		0x07
#define IPMI_GET_DEVICE_GUID_CMD		0x08
#define IPMI_RESET_WATCHDOG_TIMER_CMD		0x22
#define IPMI_SET_WATCHDOG_TIMER_CMD		0x24
#define IPMI_GET_WATCHDOG_TIMER_CMD		0x25
#define IPMI_SET_BMC_GLOBAL_ENABLES_CMD		0x2e
#define IPMI_GET_BMC_GLOBAL_ENABLES_CMD		0x2f
#define IPMI_CLEAR_MSG_FLAGS_CMD		0x30
#define IPMI_GET_MSG_FLAGS_CMD			0x31
#define IPMI_ENABLE_MESSAGE_CHANNEL_RCV_CMD	0x32
#define IPMI_GET_MSG_CMD			0x33
#define IPMI_SEND_MSG_CMD			0x34
#define IPMI_READ_EVENT_MSG_BUFFER_CMD		0x35
#define IPMI_GET_BT_INTERFACE_CAPABILITIES_CMD	0x36
#define IPMI_GET_SYSTEM_GUID_CMD		0x37
#define IPMI_GET_CHANNEL_AUTH_CAPABILITIES_CMD	0x38
#define IPMI_GET_SESSION_CHALLENGE_CMD		0x39
#define IPMI_ACTIVATE_SESSION_CMD		0x3a
#define IPMI_SET_SESSION_PRIVILEGE_CMD		0x3b
#define IPMI_CLOSE_SESSION_CMD			0x3c
#define IPMI_GET_SESSION_INFO_CMD		0x3d

#define IPMI_GET_AUTHCODE_CMD			0x3f
#define IPMI_SET_CHANNEL_ACCESS_CMD		0x40
#define IPMI_GET_CHANNEL_ACCESS_CMD		0x41
#define IPMI_GET_CHANNEL_INFO_CMD		0x42
#define IPMI_SET_USER_ACCESS_CMD		0x43
#define IPMI_GET_USER_ACCESS_CMD		0x44
#define IPMI_SET_USER_NAME_CMD			0x45
#define IPMI_GET_USER_NAME_CMD			0x46
#define IPMI_SET_USER_PASSWORD_CMD		0x47
#define IPMI_ACTIVATE_PAYLOAD_CMD		0x48
#define IPMI_DEACTIVATE_PAYLOAD_CMD		0x49
#define IPMI_GET_PAYLOAD_ACTIVATION_STATUS_CMD	0x4a
#define IPMI_GET_PAYLOAD_INSTANCE_INFO_CMD	0x4b
#define IPMI_SET_USER_PAYLOAD_ACCESS_CMD	0x4c
#define IPMI_GET_USER_PAYLOAD_ACCESS_CMD	0x4d
#define IPMI_GET_CHANNEL_PAYLOAD_SUPPORT_CMD	0x4e
#define IPMI_GET_CHANNEL_PAYLOAD_VERSION_CMD	0x4f
#define IPMI_GET_CHANNEL_OEM_PAYLOAD_INFO_CMD	0x50

#define IPMI_MASTER_READ_WRITE_CMD		0x52

#define IPMI_GET_CHANNEL_CIPHER_SUITES_CMD	0x54
#define IPMI_SUSPEND_RESUME_PAYLOAD_ENCRYPTION_CMD 0x55
#define IPMI_SET_CHANNEL_SECURITY_KEY_CMD	0x56
#define IPMI_GET_SYSTEM_INTERFACE_CAPABILITIES_CMD 0x57


/* Storage netfn (0x0a) */
#define IPMI_GET_FRU_INVENTORY_AREA_INFO_CMD	0x10
#define IPMI_READ_FRU_DATA_CMD			0x11
#define IPMI_WRITE_FRU_DATA_CMD			0x12

#define IPMI_GET_SDR_REPOSITORY_INFO_CMD	0x20
#define IPMI_GET_SDR_REPOSITORY_ALLOC_INFO_CMD	0x21
#define IPMI_RESERVE_SDR_REPOSITORY_CMD		0x22
#define IPMI_GET_SDR_CMD			0x23
#define IPMI_ADD_SDR_CMD			0x24
#define IPMI_PARTIAL_ADD_SDR_CMD		0x25
#define IPMI_DELETE_SDR_CMD			0x26
#define IPMI_CLEAR_SDR_REPOSITORY_CMD		0x27
#define IPMI_GET_SDR_REPOSITORY_TIME_CMD	0x28
#define IPMI_SET_SDR_REPOSITORY_TIME_CMD	0x29
#define IPMI_ENTER_SDR_REPOSITORY_UPDATE_CMD	0x2a
#define IPMI_EXIT_SDR_REPOSITORY_UPDATE_CMD	0x2b
#define IPMI_RUN_INITIALIZATION_AGENT_CMD	0x2c

#define IPMI_GET_SEL_INFO_CMD			0x40
#define IPMI_GET_SEL_ALLOCATION_INFO_CMD	0x41
#define IPMI_RESERVE_SEL_CMD			0x42
#define IPMI_GET_SEL_ENTRY_CMD			0x43
#define IPMI_ADD_SEL_ENTRY_CMD			0x44
#define IPMI_PARTIAL_ADD_SEL_ENTRY_CMD		0x45
#define IPMI_DELETE_SEL_ENTRY_CMD		0x46
#define IPMI_CLEAR_SEL_CMD			0x47
#define IPMI_GET_SEL_TIME_CMD			0x48
#define IPMI_SET_SEL_TIME_CMD			0x49
#define IPMI_GET_AUXILIARY_LOG_STATUS_CMD	0x5a
#define IPMI_SET_AUXILIARY_LOG_STATUS_CMD	0x5b

/* Transport netfn (0x0c) */
#define IPMI_SET_LAN_CONFIG_PARMS_CMD		0x01
#define IPMI_GET_LAN_CONFIG_PARMS_CMD		0x02
#define IPMI_SUSPEND_BMC_ARPS_CMD		0x03
#define IPMI_GET_IP_UDP_RMCP_STATS_CMD		0x04

#define IPMI_SET_SERIAL_MODEM_CONFIG_CMD	0x10
#define IPMI_GET_SERIAL_MODEM_CONFIG_CMD	0x11
#define IPMI_SET_SERIAL_MODEM_MUX_CMD		0x12
#define IPMI_GET_TAP_RESPONSE_CODES_CMD		0x13
#define IPMI_SET_PPP_UDP_PROXY_XMIT_DATA_CMD	0x14
#define IPMI_GET_PPP_UDP_PROXY_XMIT_DATA_CMD	0x15
#define IPMI_SEND_PPP_UDP_PROXY_PACKET_CMD	0x16
#define IPMI_GET_PPP_UDP_PROXY_RECV_DATA_CMD	0x17
#define IPMI_SERIAL_MODEM_CONN_ACTIVE_CMD	0x18
#define IPMI_CALLBACK_CMD			0x19
#define IPMI_SET_USER_CALLBACK_OPTIONS_CMD	0x1a
#define IPMI_GET_USER_CALLBACK_OPTIONS_CMD	0x1b

#define IPMI_SOL_ACTIVATING_CMD			0x20
#define IPMI_SET_SOL_CONFIGURATION_PARAMETERS	0x21
#define IPMI_GET_SOL_CONFIGURATION_PARAMETERS	0x22

/*
 * NetFNs
 */
#define IPMI_CHASSIS_NETFN		0x00
#define IPMI_BRIDGE_NETFN		0x02
#define IPMI_SENSOR_EVENT_NETFN		0x04
#define IPMI_APP_NETFN			0x06
#define IPMI_FIRMWARE_NETFN		0x08
#define IPMI_STORAGE_NETFN		0x0a
#define IPMI_TRANSPORT_NETFN		0x0c
#define IPMI_GROUP_EXTENSION_NETFN	0x2c
#define IPMI_OEM_GROUP_NETFN		0x2e

#ifdef __cplusplus
extern "C" {
#endif

/* Convert a netfn into a string.  You must pass a buffer in (32
   bytes is good) and the buffer length.  The string will be stored in
   that buffer and also returned. */
char *ipmi_get_netfn_string(unsigned int netfn,
			    char         *buffer,
			    unsigned int buf_len);

/* Convert a netfn/cmd into a string.  You must pass a buffer in (32
   bytes is good) and the buffer length.  The string will be stored in
   that buffer and also returned. */
char *ipmi_get_command_string(unsigned int netfn,
			      unsigned int cmd,
			      char         *buffer,
			      unsigned int buf_len);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_MSGBITS_H */
