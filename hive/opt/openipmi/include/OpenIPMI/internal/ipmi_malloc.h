/*
 * ipmi_malloc.h
 *
 * MontaVista IPMI interface, internal memory allocation
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

#ifndef OPENIPMI_MALLOC_H
#define OPENIPMI_MALLOC_H

#include <OpenIPMI/ipmi_log.h>

/* IPMI uses this for memory allocation, so it can easily be
   substituted, etc. */
void *ipmi_mem_alloc(int size);
void ipmi_mem_free(void *data);

/* strdup using the above memory allocation routines. */
char *ipmi_strdup(const char *str);
char *ipmi_strndup(const char *str, int n);

/* If you have debug allocations on, then you should call this to
   check for data you haven't freed (after you have freed all the
   data, of course).  It's safe to call even if malloc debugging is
   turned off. */
void ipmi_debug_malloc_cleanup(void);

extern int i__ipmi_debug_malloc;
#define DEBUG_MALLOC	(i__ipmi_debug_malloc)
#define DEBUG_MALLOC_ENABLE() i__ipmi_debug_malloc = 1

/* Used by the malloc code to generate logs.  If not set, logs will go
   nowhere. */
extern void (*ipmi_malloc_log)(enum ipmi_log_type_e log_type,
			       const char *format, ...)
#if __GNUC__ > 2
     __attribute__ ((__format__ (__printf__, 2, 3)))
#endif
;

#endif /* OPENIPMI_MALLOC_H */
