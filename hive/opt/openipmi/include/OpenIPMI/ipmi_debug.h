/*
 * ipmi_debug.h
 *
 * MontaVista IPMI interface, debug information.
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

#ifndef OPENIPMI_DEBUG_H
#define OPENIPMI_DEBUG_H

#include <OpenIPMI/os_handler.h>

#ifdef __cplusplus
extern "C" {
#endif

extern unsigned int i__ipmi_log_mask;

/* Log normal IPMI messages, but not low-level protocol messages. */
#define DEBUG_MSG_BIT		(1 << 0)

/* Log all messages. */
#define DEBUG_RAWMSG_BIT	(1 << 1)

/* Log events that are received. */
#define DEBUG_EVENTS_BIT	(1 << 3)

/* Force the given connection to no longer work */
#define DEBUG_CON0_FAIL_BIT	(1 << 4)
#define DEBUG_CON1_FAIL_BIT	(1 << 5)
#define DEBUG_CON2_FAIL_BIT	(1 << 6)
#define DEBUG_CON3_FAIL_BIT	(1 << 7)

#define DEBUG_MSG_ERR_BIT	(1 << 8)

#define DEBUG_MSG	(i__ipmi_log_mask & DEBUG_MSG_BIT)
#define DEBUG_MSG_ENABLE() i__ipmi_log_mask |= DEBUG_MSG_BIT
#define DEBUG_MSG_DISABLE() i__ipmi_log_mask &= ~DEBUG_MSG_BIT

#define DEBUG_RAWMSG	(i__ipmi_log_mask & DEBUG_RAWMSG_BIT)
#define DEBUG_RAWMSG_ENABLE() i__ipmi_log_mask |= DEBUG_RAWMSG_BIT
#define DEBUG_RAWMSG_DISABLE() i__ipmi_log_mask &= ~DEBUG_RAWMSG_BIT

#define DEBUG_EVENTS	(i__ipmi_log_mask & DEBUG_EVENTS_BIT)
#define DEBUG_EVENTS_ENABLE() i__ipmi_log_mask |= DEBUG_EVENTS_BIT
#define DEBUG_EVENTS_DISABLE() i__ipmi_log_mask &= ~DEBUG_EVENTS_BIT

#define DEBUG_CON_FAIL(con)    (i__ipmi_log_mask & (DEBUG_CON0_FAIL_BIT << con))
#define DEBUG_CON_FAIL_ENABLE(con) \
	i__ipmi_log_mask |= (DEBUG_CON0_FAIL_BIT << con)
#define DEBUG_CON_FAIL_DISABLE(con) \
	i__ipmi_log_mask &= ~(DEBUG_CON0_FAIL_BIT << con)

#define DEBUG_MSG_ERR	(i__ipmi_log_mask & DEBUG_MSG_ERR_BIT)
#define DEBUG_MSG_ERR_ENABLE() i__ipmi_log_mask |= DEBUG_MSG_ERR_BIT
#define DEBUG_MSG_ERR_DISABLE() i__ipmi_log_mask &= ~DEBUG_MSG_ERR_BIT

#ifdef IPMI_CHECK_LOCKS
void ipmi_report_lock_error(os_handler_t *handler, char *str);
#define IPMI_REPORT_LOCK_ERROR(handler, str) ipmi_report_lock_error(handler, \
								    str)
#else
#define IPMI_REPORT_LOCK_ERROR(handler, str) do {} while (0)
#endif

extern int i__ipmi_debug_locks;
#define DEBUG_LOCKS	(i__ipmi_debug_locks)
#define DEBUG_LOCKS_ENABLE() i__ipmi_debug_locks = 1
#define DEBUG_LOCKS_DISABLE() i__ipmi_debug_locks = 0

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_DEBUG_H */
