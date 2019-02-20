/*
 * ipmi_sel.h
 *
 * MontaVista IPMI interface for the system event log
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2002,2003 MontaVista Software Inc.
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
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
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this program; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef OPENIPMI_SEL_H
#define OPENIPMI_SEL_H
#include <OpenIPMI/ipmi_types.h>


/* Opaque type representing a remote SEL repository. */
typedef struct ipmi_sel_info_s ipmi_sel_info_t;

/* Create a local representation of a remote SEL repository.  When
   created, it will not automatically fetch the remote SELs, you need
   to do that.  If "sensor" is true, then this will fetch the "sensor"
   SELs using GET DEVICE SEL.  If not, it will use GET SEL for
   fetching SELs. */
int ipmi_sel_alloc(ipmi_mc_t       *mc,
		   unsigned int    lun,
		   ipmi_sel_info_t **new_sel);

/* Destroy an SEL.  Note that if the SEL is currently fetching events,
   the destroy cannot complete immediatly, it will be marked for
   destruction later.  You can supply a callback that, if not NULL,
   will be called when the sel is destroyed. */
typedef void (*ipmi_sel_destroyed_t)(ipmi_sel_info_t *sel, void *cb_data);
int ipmi_sel_destroy(ipmi_sel_info_t      *sel,
		     ipmi_sel_destroyed_t handler,
		     void                 *cb_data);

/* Add a new event to the SEL. */
int ipmi_sel_event_add(ipmi_sel_info_t *sel,
		       ipmi_event_t    *new_event);

/* Fetch the remote SELs, but do not wait until the fetch is complete,
   return immediately.  When the fetch is complete, call the given
   handler. */
typedef void (*ipmi_sels_fetched_t)(ipmi_sel_info_t *sel,
				    int             err,
				    int             changed,
				    unsigned int    count,
				    void            *cb_data);
int ipmi_sel_get(ipmi_sel_info_t     *sel,
		 ipmi_sels_fetched_t handler,
		 void                *cb_data);

/* Get the number of undeleted entries in the SEL. */
int ipmi_get_sel_count(ipmi_sel_info_t *sel,
		       unsigned int    *count);

/* Get the number of entries that are used in the real SEL.  This
   takes into account events that have been deleted locally but have
   not yet been deleted from the real SEL. */
int ipmi_get_sel_entries_used(ipmi_sel_info_t *sel,
			      unsigned int    *count);

ipmi_event_t *ipmi_sel_get_first_event(ipmi_sel_info_t *sel);
ipmi_event_t *ipmi_sel_get_last_event(ipmi_sel_info_t *sel);
ipmi_event_t *ipmi_sel_get_next_event(ipmi_sel_info_t    *sel,
				      const ipmi_event_t *p);
ipmi_event_t *ipmi_sel_get_prev_event(ipmi_sel_info_t    *sel,
				      const ipmi_event_t *n);
ipmi_event_t *ipmi_sel_get_event_by_recid(ipmi_sel_info_t *sel,
					  unsigned int    record_id);

/* This callback will be called when a new event is added to the SEL. */
typedef void (*ipmi_sel_new_event_handler_cb)(ipmi_sel_info_t *sel,
					      ipmi_mc_t       *mc,
					      ipmi_event_t    *event,
					      void            *cb_data);
int ipmi_sel_set_new_event_handler(ipmi_sel_info_t               *sel,
				   ipmi_sel_new_event_handler_cb handler,
				   void                          *cb_data);

/* Fetch all the sels.  The array size should point to a value that
   holds the number of elements in the passed in array.  The
   array_size will be set to the actual number of elements put into
   the array.  If the number of SELs is larger than the supplied
   array_size, this will return E2BIG and do nothing. */
int ipmi_get_all_sels(ipmi_sel_info_t *sel,
		      int             *array_size,
		      ipmi_event_t    **array);

typedef void (*ipmi_sel_op_done_cb_t)(ipmi_sel_info_t *sel,
				      void            *cb_data,
				      int             err);

/* Delete an event log entry. */
int ipmi_sel_del_event(ipmi_sel_info_t       *sel,
		       ipmi_event_t          *event,
		       ipmi_sel_op_done_cb_t handler,
		       void                  *cb_data);

int ipmi_sel_del_event_by_recid(ipmi_sel_info_t       *sel,
				unsigned int          record_id,
				ipmi_sel_op_done_cb_t handler,
				void                  *cb_data);

/* Clear all events in the SEL, but only if the last event in the SEL
   matches "last_event".  If the clear operation fails or cannot be
   done because the event doesn't match up, then an error is returned.
   Note that use of this is *HIGHLY* discouraged.  This is only here
   for HPI support.  In general, you should delete individual events
   and OpenIPMI will do the right thing (do a clear if they are all
   done, do individual deletes if possible otherwise, etc.).  If you
   pass in NULL for last_event, it forces a clear of the SEL without
   checking anything.  Very dangerous, events can be lost. */
int ipmi_sel_clear(ipmi_sel_info_t       *sel,
		   ipmi_event_t          *last_event,
		   ipmi_sel_op_done_cb_t handler,
		   void                  *cb_data);

/* Get various information from the IPMI SEL info commands. */
int ipmi_sel_get_major_version(ipmi_sel_info_t *sel, int *val);
int ipmi_sel_get_minor_version(ipmi_sel_info_t *sel, int *val);
int ipmi_sel_get_num_entries(ipmi_sel_info_t *sel, int *val);
int ipmi_sel_get_free_bytes(ipmi_sel_info_t *sel, int *val);
int ipmi_sel_get_overflow(ipmi_sel_info_t *sel, int *val);
int ipmi_sel_get_supports_delete_sel(ipmi_sel_info_t *sel, int *val);
int ipmi_sel_get_supports_partial_add_sel(ipmi_sel_info_t *sel, int *val);
int ipmi_sel_get_supports_reserve_sel(ipmi_sel_info_t *sel, int *val);
int ipmi_sel_get_supports_get_sel_allocation(ipmi_sel_info_t *sel,
					     int             *val);
int ipmi_sel_get_last_addition_timestamp(ipmi_sel_info_t *sel, int *val);

/* Add a event to the internal representation of the system event log.
   This will return EEXIST if the event already exists. */
int ipmi_sel_event_add(ipmi_sel_info_t *sel,
		       ipmi_event_t    *new_event);

/* Add an event to the remote SEL.  This will not immediately add it
   to the internal SEL.  The record id of the added record is returned
   in the callback (if there is no error). */
typedef void (*ipmi_sel_add_op_done_cb_t)(ipmi_sel_info_t *sel,
					  void            *cb_data,
					  int             err,
					  unsigned int    record_id);
int ipmi_sel_add_event_to_sel(ipmi_sel_info_t          *sel,
			      ipmi_event_t             *event_to_add,
			      ipmi_sel_add_op_done_cb_t done,
			      void                     *cb_data);

#endif /* OPENIPMI_SEL_H */

