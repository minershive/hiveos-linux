/*
 * ipmi_locks.h
 *
 * MontaVista IPMI locking abstraction
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

#ifndef OPENIPMI_LOCKS_H
#define OPENIPMI_LOCKS_H

#include <OpenIPMI/os_handler.h>

/* This is a generic lock used by the IPMI code. */
typedef struct ipmi_lock_s ipmi_lock_t;

/* Create a lock but us your own OS handlers. */
int ipmi_create_lock_os_hnd(os_handler_t *os_hnd, ipmi_lock_t **lock);

/* Destroy a lock. */
void ipmi_destroy_lock(ipmi_lock_t *lock);

/* Lock the lock.  Locks are recursive, so the same thread can claim
   the same lock multiple times, and must release it the same number
   of times. */
void ipmi_lock(ipmi_lock_t *lock);

/* Release the lock. */
void ipmi_unlock(ipmi_lock_t *lock);

/* Like the above locks, but read/write locks. */
typedef struct ipmi_rwlock_s ipmi_rwlock_t;
int ipmi_create_rwlock_os_hnd(os_handler_t *os_hnd, ipmi_rwlock_t **new_lock);
void ipmi_destroy_rwlock(ipmi_rwlock_t *lock);
void ipmi_rwlock_read_lock(ipmi_rwlock_t *lock);
void ipmi_rwlock_read_unlock(ipmi_rwlock_t *lock);
void ipmi_rwlock_write_lock(ipmi_rwlock_t *lock);
void ipmi_rwlock_write_unlock(ipmi_rwlock_t *lock);

#endif /* OPENIPMI_LOCKS_H */
