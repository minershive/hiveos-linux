/*
 * log.h
 *
 * Interfaces for logging info, warnings, errors, etc. to a system log
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


#ifndef OPENIPMI_LOG_H_
#define OPENIPMI_LOG_H_

#ifdef __cplusplus
extern "C" {
#endif

/* Types of logs that may be generated. */
enum ipmi_log_type_e
{
    /* General information about something that happens. */
    IPMI_LOG_INFO,

    /* An internal error (not reported directly to the user) occurred,
       but it's not a big deal, the system can still operate. */
    IPMI_LOG_WARNING,

    /* An internal error (not reported directly to the user) occured,
       and it will affect the operation of the system.  This system
       will still operation, but probably in a degraded mode. */
    IPMI_LOG_SEVERE,

    /* An internal error occured, and it is dangerous for the system
       to keep operating. */
    IPMI_LOG_FATAL,

    /* When returning errors to the user, this will often be used to
       report the general cause of the error if the cause would be
       difficult to determine from just the error return code. */
    IPMI_LOG_ERR_INFO,

    /* Debug information is being generated. */
    IPMI_LOG_DEBUG,

    /* Sometimes debug information is generated in multiple parts.
       These log types mark the first, intermediate, and end of a
       multi-part log.  These will all be generated together from the
       same thread. */
    IPMI_LOG_DEBUG_START,
    IPMI_LOG_DEBUG_CONT,
    IPMI_LOG_DEBUG_END,
};

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_LOG_H_ */
