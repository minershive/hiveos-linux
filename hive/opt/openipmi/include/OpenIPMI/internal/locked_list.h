/*
 * locked_list.h
 *
 * A list that handles locking properly. 
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

#ifndef OPENIPMI_LOCKED_LIST_H
#define OPENIPMI_LOCKED_LIST_H

/*
 * This is a locked list structure that is multi-thread safe.  You can
 * add items and remove items while the list is being iterated, and
 * iterate by multiple threads simultaneously.  The handlers are
 * called without any locks being held.
 */

typedef struct locked_list_s locked_list_t;

/* The callback to the locked list iterator.  If it returns the
   CONTINUE value, iteration will continue.  If it returns the STOP
   value, iteration will not continue.  SKIP is only valid from
   a prefunc, it tells the code to skip this value. */
#define LOCKED_LIST_ITER_CONTINUE	0
#define LOCKED_LIST_ITER_STOP		1
#define LOCKED_LIST_ITER_SKIP		2
typedef int (*locked_list_handler_cb)(void *cb_data,
				      void *item1,
				      void *item2);

/* Allocate and free locked lists. */
locked_list_t *locked_list_alloc(os_handler_t *os_hnd);
void locked_list_destroy(locked_list_t *ll);

/* Add an item to the locked list.  If the item is a duplicate, this
   operation will be ignored but a value of "2" will be returned.  It
   returns true if successful or false if memory could not be
   allocated. */
int locked_list_add(locked_list_t *ll, void *item1, void *item2);

/* Remove an item from the locked list.  It returns true if the item
   was found on the list and false if not. */
int locked_list_remove(locked_list_t *ll, void *item, void *item2);

/* Iterate over the items of the list.  The prefunc version has a
   function that can be called before the lock is removed.  This allows
   the refcount on an object to be incremented or whatnot. */
void locked_list_iterate(locked_list_t          *ll,
			 locked_list_handler_cb handler,
			 void                   *cb_data);
void locked_list_iterate_prefunc(locked_list_t          *ll,
				 locked_list_handler_cb prefunc,
				 locked_list_handler_cb handler,
				 void                   *cb_data);

/* Return the number of items in the list. */
unsigned int locked_list_num_entries(locked_list_t *ll);

/* Allocate and free entries for a locked list.  With a pre-allocated
   entry, the add cannot fail.  This is primarily so you can
   pre-allocate data for the list and later adds won't fail. */
typedef struct locked_list_entry_s locked_list_entry_t;
locked_list_entry_t *locked_list_alloc_entry(void);
void locked_list_free_entry(locked_list_entry_t *entry);

/* This add will not fail if you supply the entry (non-null, allocated
   from locked_list_alloc_entry()). Note that once you pass the entry
   into this function, you may no longer free it or use it for
   anything else. */
int locked_list_add_entry(locked_list_t *ll, void *item1, void *item2,
			  locked_list_entry_t *entry);

/* These functions are like the previous functions, but allow the user
   to have their own lock function.  The nolock functions must be
   called with the lock already held.  */
typedef void (*locked_list_lock_cb)(void *cb_data);
locked_list_t *locked_list_alloc_my_lock(locked_list_lock_cb lock_func,
					 locked_list_lock_cb unlock_func,
					 void              *lock_func_cb_data);
int locked_list_add_nolock(locked_list_t *ll, void *item1, void *item2);
int locked_list_add_entry_nolock(locked_list_t *ll, void *item1, void *item2,
				 locked_list_entry_t *entry);
int locked_list_remove_nolock(locked_list_t *ll, void *item, void *item2);
void locked_list_iterate_nolock(locked_list_t          *ll,
				locked_list_handler_cb handler,
				void                   *cb_data);
void locked_list_iterate_prefunc_nolock(locked_list_t          *ll,
					locked_list_handler_cb prefunc,
					locked_list_handler_cb handler,
					void                   *cb_data);
unsigned int locked_list_num_entries_nolock(locked_list_t *ll);

/* Lock and unlock the lock in the locked list, useful with the
   previous nolock calls. */
void locked_list_lock(locked_list_t *ll);
void locked_list_unlock(locked_list_t *ll);

#endif /* OPENIPMI_LOCKED_LIST_H */
