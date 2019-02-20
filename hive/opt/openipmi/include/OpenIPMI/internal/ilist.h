/*
 * ilist.h
 *
 * Generic lists in C
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

#ifndef OPENIPMI_ILIST_H
#define OPENIPMI_ILIST_H

typedef struct ilist_s ilist_t;
typedef struct ilist_iter_s ilist_iter_t;

/* This is only so the user can supply their own data chunks for the
   list entries.  This is ugly, but it allows the user to pre-allocate
   (or allocate as part of the entry) the data for the list chunks,
   and avoid having to worry about error returns from the list
   operations. */
typedef struct ilist_item_s ilist_item_t;

/* Returns NULL on failure. */
ilist_t *alloc_ilist(void);
ilist_iter_t *alloc_ilist_iter(ilist_t *list);
void free_ilist(ilist_t *list);
void free_ilist_iter(ilist_iter_t *iter);

/* Returns true if the list is empty, false if not. */
int ilist_empty(ilist_t *list);

/* Return false on failure, true on success.  entry may be NULL,
   meaning you want the ilist code to supply the entry.  If you supply
   an entry, the "malloced" flag will be set to zero for you. */
int ilist_add_head(ilist_t *list, void *item, ilist_item_t *entry);
int ilist_add_tail(ilist_t *list, void *item, ilist_item_t *entry);
int ilist_add_before(ilist_iter_t *iter, void *item, ilist_item_t *entry);
int ilist_add_after(ilist_iter_t *iter, void *item, ilist_item_t *entry);

/* Return false on failure, true on success.  This will return a
   failure (false) if you try to position past the end of the array or
   try to set first or last on an empty array.  In that case it will
   leave the iterator unchanged. */
int ilist_first(ilist_iter_t *iter);
int ilist_last(ilist_iter_t *iter);
int ilist_next(ilist_iter_t *iter);
int ilist_prev(ilist_iter_t *iter);

/* Remove the first or last item from the list.  It will be deleted
   from the list and returned.  If the list is empty, NULL will be
   returned. */
void *ilist_remove_first(ilist_t *list);
void *ilist_remove_last(ilist_t *list);

/* Remove a given item from the list, if it is there.  Return 1 if it
   was found and 0 if it was not found. */
int ilist_remove_item_from_list(ilist_t *list, void *item);

/* Returns failue (false) if unpositioned. */
int ilist_delete(ilist_iter_t *iter); /* Position on next element after del */

/* Set unpositioned.  Next will go to the first item, prev to the last
   item. */
void ilist_unpositioned(ilist_iter_t *iter);

/* Returns NULL if unpositioned or list empty. */
void *ilist_get(ilist_iter_t *iter);

/* This should return true if the item matches, false if not. */
typedef int (*ilist_search_cb)(void *item, void *cb_data);

/* Search forward (starting at the next item) for something.  Returns
   NULL if not found, the item if found.  iter will be positioned on
   the item, too.  To search from the beginning, set the iterator to
   the "unpositioined" position. */
void *ilist_search_iter(ilist_iter_t *iter, ilist_search_cb cmp, void *cb_data);

/* Search from the beginning, but without an iterator.  This will return
   the first item found. */
void *ilist_search(ilist_t *list, ilist_search_cb cmp, void *cb_data);

/* Called with an iterator positioned on the item. */
typedef void (*ilist_iter_cb)(ilist_iter_t *iter, void *item, void *cb_data);

/* Call the given handler for each item in the list.  You may delete
   the current item the iterator references while this is happening,
   but no other items. */
void ilist_iter(ilist_t *list, ilist_iter_cb handler, void *cb_data);

/* Call the given handler for each item in the list, but run the list
   backwards.  You may delete the current item the iterator references
   while this is happening, but no other items. */
void ilist_iter_rev(ilist_t *list, ilist_iter_cb handler, void *cb_data);

/* Initialize a statically declared iterator. */
void ilist_init_iter(ilist_iter_t *iter, ilist_t *list);

/* Return -1 if item1 < item2, 0 if item1 == item2, and 1 if item1 > item2 */
typedef int (*ilist_sort_cb)(void *item1, void *item2);

void ilist_sort(ilist_t *list, ilist_sort_cb cmp);

/* A two-item list.  This is useful for managing list of handlers
   where you have a callback handler and a data item.  You create it
   with the given two data items, and when you call
   ilist_iter_twoitem, it will call the handler you pass in with the
   two data items you have given. */

typedef void (*ilist_twoitem_cb)(void *data, void *cb_data1, void *cb_data2);

/* Add an entry to the list.  Returns 0 upon failure, 1 if successful.
   Duplicates are allowed. */
int ilist_add_twoitem(ilist_t *list, void *cb_data1, void *cb_data2);

/* Remove an entry, returns 1 if present, 0 if not. */
int ilist_remove_twoitem(ilist_t *list, void *cb_data1, void *cb_data2);

/* Returns 1 if the entry exists in the list, 0 if not. */
int ilist_twoitem_exists(ilist_t *list, void *cb_data1, void *cb_data2);

/* Call all the callbacks in the list */
void ilist_iter_twoitem(ilist_t *ilist, ilist_twoitem_cb handler, void *data);

void ilist_twoitem_destroy(ilist_t *list);

/* Internal data structures, DO NOT USE THESE. */

struct ilist_item_s
{
    int malloced;
    ilist_item_t *next, *prev;
    void *item;
};

struct ilist_s
{
    ilist_item_t *head;
};

struct ilist_iter_s
{
    ilist_t      *list;
    ilist_item_t *curr;
};

/* You must define these. */
void *ilist_mem_alloc(size_t size);
void ilist_mem_free(void *data);

#endif /* OPENIPMI_ILIST_H */
