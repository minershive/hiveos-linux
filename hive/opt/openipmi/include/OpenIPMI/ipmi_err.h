/*
 * ipmi_err.h
 *
 * MontaVista IPMI interface, error values.
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

#ifndef OPENIPMI_ERR_H
#define OPENIPMI_ERR_H

/*
 * Error values
 *
 * Return errors or reported errors can be due to OS problems or to 
 * reported IPMI errors for messages this code handled.  These macros
 * differentiate these.  Note that this is NOT for handling the first
 * byte of a response (the completion code) on a message you handle, it
 * will simply be a byte of information.
 */
#define IPMI_OS_ERR_TOP		0x00000000
#define IPMI_IPMI_ERR_TOP	0x01000000
#define IPMI_RMCPP_ERR_TOP	0x02000000
#define IPMI_SOL_ERR_TOP	0x03000000
#define IPMI_IS_OS_ERR(E)	(((E) & 0xffffff00) == IPMI_OS_ERR_TOP)
#define IPMI_GET_OS_ERR(E)	((E) & 0xff)
#define IPMI_OS_ERR_VAL(v)	((v) | IPMI_OS_ERR_TOP)
#define IPMI_IS_IPMI_ERR(E)	(((E) & 0xffffff00) == IPMI_IPMI_ERR_TOP)
#define IPMI_GET_IPMI_ERR(E)	((E) & 0xff)
#define IPMI_IPMI_ERR_VAL(v)	((v) | IPMI_IPMI_ERR_TOP)
#define IPMI_IS_RMCPP_ERR(E)	(((E) & 0xffffff00) == IPMI_RMCPP_ERR_TOP)
#define IPMI_GET_RMCPP_ERR(E)	((E) & 0xff)
#define IPMI_RMCPP_ERR_VAL(v)	((v) | IPMI_RMCPP_ERR_TOP)
#define IPMI_IS_SOL_ERR(E)	(((E) & 0xffffff00) == IPMI_SOL_ERR_TOP)
#define IPMI_GET_SOL_ERR(E)	((E) & 0xff)
#define IPMI_SOL_ERR_VAL(v)	((v) | IPMI_SOL_ERR_TOP)

/* The following local system completion codes are defined to be
 * returned by OpenIPMI:
 *
 * EBADF
 * EINVAL
 * E2BIG
 * ENOMEM
 * ENOENT
 * ECANCELED
 * ENOSYS
 * EEXIST
 * EAGAIN
 * EPERM
 */

/*
 * Completion codes for IPMI.
 */
#define IPMI_NODE_BUSY_CC			0xC0
#define IPMI_INVALID_CMD_CC			0xC1
#define IPMI_COMMAND_INVALID_FOR_LUN_CC		0xC2
#define IPMI_TIMEOUT_CC				0xC3
#define IPMI_OUT_OF_SPACE_CC			0xC4
#define IPMI_INVALID_RESERVATION_CC		0xC5
#define IPMI_REQUEST_DATA_TRUNCATED_CC		0xC6
#define IPMI_REQUEST_DATA_LENGTH_INVALID_CC	0xC7
#define IPMI_REQUESTED_DATA_LENGTH_EXCEEDED_CC	0xC8
#define IPMI_PARAMETER_OUT_OF_RANGE_CC		0xC9
#define IPMI_CANNOT_RETURN_REQ_LENGTH_CC	0xCA
#define IPMI_NOT_PRESENT_CC			0xCB
#define IPMI_INVALID_DATA_FIELD_CC		0xCC
#define IPMI_COMMAND_ILLEGAL_FOR_SENSOR_CC	0xCD
#define IPMI_COULD_NOT_PROVIDE_RESPONSE_CC	0xCE
#define IPMI_CANNOT_EXEC_DUPLICATE_REQUEST_CC	0xCF
#define IPMI_REPOSITORY_IN_UPDATE_MODE_CC	0xD0
#define IPMI_DEVICE_IN_FIRMWARE_UPDATE_CC	0xD1
#define IPMI_BMC_INIT_IN_PROGRESS_CC		0xD2
#define IPMI_DESTINATION_UNAVAILABLE_CC		0xD3
#define IPMI_INSUFFICIENT_PRIVILEGE_CC		0xD4
#define IPMI_NOT_SUPPORTED_IN_PRESENT_STATE_CC	0xD5
#define IPMI_UNKNOWN_ERR_CC			0xff

/* Error codes from RMCP+ */
#define IPMI_RMCPP_INSUFFICIENT_RESOURCES_FOR_SESSION	0x01
#define IPMI_RMCPP_INVALID_SESSION_ID			0x02
#define IPMI_RMCPP_INVALID_PAYLOAD_TYPE			0x03
#define IPMI_RMCPP_INVALID_AUTHENTICATION_ALGORITHM	0x04
#define IPMI_RMCPP_INVALID_INTEGRITY_ALGORITHM		0x05
#define IPMI_RMCPP_NO_MATCHING_AUTHENTICATION_PAYLOAD	0x06
#define IPMI_RMCPP_NO_MATCHING_INTEGRITY_PAYLOAD	0x07
#define IPMI_RMCPP_INACTIVE_SESSION_ID			0x08
#define IPMI_RMCPP_INVALID_ROLE				0x09
#define IPMI_RMCPP_UNAUTHORIZED_ROLE_OR_PRIVILEGE	0x0a
#define IPMI_RMCPP_INSUFFICIENT_RESOURCES_FOR_ROLE	0x0b
#define IPMI_RMCPP_INVALID_NAME_LENGTH			0x0c
#define IPMI_RMCPP_UNAUTHORIZED_NAME			0x0d
#define IPMI_RMCPP_UNAUTHORIZED_GUID			0x0e
#define IPMI_RMCPP_INVALID_INTEGRITY_CHECK_VALUE	0x0f
#define IPMI_RMCPP_INVALID_CONFIDENTIALITY_ALGORITHM	0x10
#define IPMI_RMCPP_NO_CIPHER_SUITE_MATCHES		0x11
#define IPMI_RMCPP_ILLEGAL_PARAMETER			0x12

/**
 * Serial-over-LAN error codes
 */
#define IPMI_SOL_CHARACTER_TRANSFER_UNAVAILABLE	0x01 ///< The request was NACKed because Char Trans was Unavail
#define IPMI_SOL_DEACTIVATED			0x02 ///< The managed system deactivated SoL
#define IPMI_SOL_NOT_AVAILABLE			0x03 ///< SoL is not available due to managed system configuration.
#define IPMI_SOL_DISCONNECTED			0x04 ///< The connection has been forcibly disconnected.
#define IPMI_SOL_UNCONFIRMABLE_OPERATION	0x05 ///< The operation has been attempted, but no confirmation is possible.
#define IPMI_SOL_FLUSHED			0x06 ///< The packet containing the request was flushed before transmission.

#ifdef __cplusplus
extern "C" {
#endif

/* Convert a completion code into a string.  You must pass a buffer in
   (32 bytes is good) and the buffer length.  The string will be
   stored in that buffer and also returned. */
char *ipmi_get_cc_string(unsigned int cc,
			 char         *buffer,
			 unsigned int buf_len);
int ipmi_get_cc_string_len(unsigned int cc);

char *ipmi_get_error_string(unsigned int err,
			    char *buffer,
			    unsigned int buf_len);
int ipmi_get_error_string_len(unsigned int err);

#ifdef __cplusplus
}
#endif

#include <errno.h>

#endif /* OPENIPMI_ERR_H */
