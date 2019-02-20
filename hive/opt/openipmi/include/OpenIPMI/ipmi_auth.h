/*
 * ipmi_auth.h
 *
 * MontaVista IPMI interface for authorization
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


#ifndef OPENIPMI_AUTH_H
#define OPENIPMI_AUTH_H

#ifdef __cplusplus
extern "C" {
#endif

/* Data is provided to the authorization code as an array of these items, a
   "scatter-gather" list.  The algorithm will go through the item in the
   array until "data" is NULL. */
typedef struct ipmi_auth_sg_s
{
    void *data; /* NULL to terminate. */
    int  len;
} ipmi_auth_sg_t;

/* A handle for an authorization algorithm to use. */
typedef struct ipmi_authdata_s *ipmi_authdata_t;

typedef struct ipmi_auth_s
{
    /* Initialize the authorization engine and return a handle for it.
       You must pass this handle into the other authorization
       calls.  Return 0 on success or an errno on failure. */
    int (*authcode_init)(unsigned char   *password,
			 ipmi_authdata_t *handle,
			 void            *info,
			 void            *(*mem_alloc)(void *info, int size),
			 void            (*mem_free)(void *info, void *data));

    /* Generate a 16-byte authorization code and put it into
       "output". Returns 0 on success and an errno on failure.  */
    int (*authcode_gen)(ipmi_authdata_t handle,
			ipmi_auth_sg_t  data[],
			void            *output);

    /* Check that the 16-byte authorization code given in "code" is valid.
       This will return 0 if it is valid or EINVAL if not. */
    int (*authcode_check)(ipmi_authdata_t handle,
			  ipmi_auth_sg_t  data[],
			  void            *code);

    /* Free the handle.  You MUST call this when you are done with the
       handle. */
    void (*authcode_cleanup)(ipmi_authdata_t handle);
} ipmi_auth_t;

#define IPMI_USERNAME_MAX	16
#define IPMI_PASSWORD_MAX	20

/* Standard IPMI authentication algorithms. */
#define IPMI_AUTHTYPE_DEFAULT	(~0) /* Choose the most secure available */
#define IPMI_AUTHTYPE_NONE	0
#define IPMI_AUTHTYPE_MD2	1
#define IPMI_AUTHTYPE_MD5	2
#define IPMI_AUTHTYPE_STRAIGHT	4
#define IPMI_AUTHTYPE_OEM	5
#define IPMI_AUTHTYPE_RMCP_PLUS	6
const char *ipmi_authtype_string(int authtype);

/* This is a table of authentication algorithms. */
#define MAX_IPMI_AUTHS		6
extern ipmi_auth_t ipmi_auths[MAX_IPMI_AUTHS];

/* IPMI privilege levels */
#define IPMI_PRIVILEGE_CALLBACK		1
#define IPMI_PRIVILEGE_USER		2
#define IPMI_PRIVILEGE_OPERATOR		3
#define IPMI_PRIVILEGE_ADMIN		4
#define IPMI_PRIVILEGE_OEM		5
const char *ipmi_privilege_string(int privilege);


/* Tell if a specific command is permitted for the given priviledge
   level.  Returns one of the following. */
#define IPMI_PRIV_INVALID	-1
#define IPMI_PRIV_DENIED	0
#define IPMI_PRIV_PERMITTED	1
#define IPMI_PRIV_SEND		2 /* Special send message handling needed. */
#define IPMI_PRIV_BOOT		3 /* Special set system boot options handling.*/

int ipmi_cmd_permitted(unsigned char priv,
		       unsigned char netfn,
		       unsigned char cmd);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_AUTH_H */
