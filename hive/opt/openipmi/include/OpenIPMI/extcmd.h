/*
 * extcmd.h
 *
 * MontaVista IPMI IPMI LAN interface extern command handler
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

#ifndef _EXTCMD_H_
#define _EXTCMD_H_

#include <OpenIPMI/serv.h>
#include <stddef.h>

enum extcmd_info_type_e {
    extcmd_ip,
    extcmd_mac,
    extcmd_uchar,
    extcmd_int,
    extcmd_ident,
};

typedef struct extcmd_map_s {
    int value;
    char *name;
} extcmd_map_t;

#define extcmdglue(a, b) a ## b
#define EXTCMD_MEMB(name, type) \
    [extcmdglue(name, _o)] = { #name, type, NULL, offsetof(BASETYPE, name) }
#define EXTCMD_MEMB_MAPUCHAR(name, map) \
    [extcmdglue(name, _o)] = { #name, extcmd_uchar, map,		\
			       offsetof(BASETYPE, name) }
typedef struct extcmd_info_s {
    const char *name;
    enum extcmd_info_type_e type;
    extcmd_map_t *map;
    size_t offset;
} extcmd_info_t;

int extcmd_getvals(sys_data_t *sys,
		   void *baseloc, const char *cmd,
		   extcmd_info_t *ts, unsigned int count);
int extcmd_setvals(sys_data_t *sys,
		   void *baseloc, const char *cmd,
		   extcmd_info_t *ts, unsigned char *setit,
		   unsigned int count);
int extcmd_checkvals(sys_data_t *sys, void *baseloc, const char *cmd,
		     extcmd_info_t *ts, unsigned int count);


#endif /* _EXTCMD_H_ */
