/*
 * opq.h
 *
 * Code for handling an operation queue.
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2002 MontaVista Software Inc.
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

#ifndef OPENIPMI_OPQ_H
#define OPENIPMI_OPQ_H

#include <OpenIPMI/os_handler.h>

typedef struct opq_s opq_t;

#define OPQ_HANDLER_STARTED	0
#define OPQ_HANDLER_ABORTED	1
/* The callback to start an operation.  If shutdown is true, then the
   queue is being destroyed, and the callee should take appropriate
   action.  This should return either IPQ_HANDLER_STARTED if the
   operation is started or OPQ_HANDLER_ABORTED if the operation does
   not start for some reason.  If this returns OPQ_HANDLER_ABORTED,
   the opq will go on to the next operation. */
typedef int (*opq_handler_cb)(void *cb_data, int shutdown);

/* The callback from opq done operations.  If shutdown is true, then
   the queue is being destroyed, and the callee should take
   appropriate action. */
typedef void (*opq_done_cb)(void *cb_data, int shutdown);

opq_t *opq_alloc(os_handler_t *os_hnd);

/* Call all the done handlers for everything in the queue, and free
   all the elements and free the queue. */
void opq_destroy(opq_t *opq);

/* A new operation is ready.  If the opq is empty, the handler will be
   called immediately and the opq will be set in use.  Otherwise, the
   operations will be queued.  If "nowait" is true, then this will
   return immediately with -1 if it would have been queued.  Returns 1
   on success, 0 on failure, or -1 if it would have been queued. */
int opq_new_op(opq_t *opq, opq_handler_cb handler, void *cb_data, int nowait);

typedef struct opq_elem_s opq_elem_t;
opq_elem_t *opq_alloc_elem(void);
void opq_free_elem(opq_elem_t *elem);

/* Like opq_new_op, but allows the head or tail to be specified.  The
   interface is open to support real priorities, but there's no
   requirement for that yet.  Also allows an opq_elem_t to be passed
   in; then the operation cannot fail.  Note that if this succeeds,
   you do *not* need to free the elem, and the elem must be allocated
   with opq_alloc_elem(). */
#define OPQ_ADD_HEAD	100
#define OPQ_ADD_TAIL	0
int opq_new_op_prio(opq_t *opq, opq_handler_cb handler, void *cb_data,
		    int nowait, int prio, opq_elem_t *elem);

/* A new operation is ready.  If the opq is empty, the handler will be
   called immediately and the opq will be set in use.  Otherwise, the
   operation is queued.  When the operation is done, the done handler
   for the operation is called, and any subsequent handlers registered
   this way will have their done handler called.  The handlers for the
   subsequent operations with done will NOT be called, just the done
   handlers.  If an operation is registered without a done handler (or
   with a NULL done handler) then it will "block" the queue, all the
   ones with done handlers before it will be called, but the ones with
   done handlers registered after this one will be call after the
   "blocker" one runs. */
int opq_new_op_with_done(opq_t          *opq,
			 opq_handler_cb handler,
			 void           *handler_data,
			 opq_done_cb    done,
			 void           *done_data);

/* Adds a "block" at the current point in the opq.  Any "with done"
   handlers that get called after a block is added will be held.  This
   way, the user can say "Anything new ops after now will have their
   handler called. */
void opq_add_block(opq_t *opq);

/* Must be called when an operation completes, this will cause all the
   done handlers to run if there are any, then allow the next
   operation to run, if there is one. */
void opq_op_done(opq_t *opq);

/* Returns true if the queue has current working stuff, false if not. */
int opq_stuff_in_progress(opq_t *opq);

#endif /* OPENIPMI_OPQ_H */
