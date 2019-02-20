/*
 * os_handler.h
 *
 * MontaVista IPMI os handler interface.
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

#ifndef OS_HANDLER_H
#define OS_HANDLER_H

#include <stdarg.h>
#include <sys/time.h>
#include <OpenIPMI/ipmi_log.h>

/************************************************************************
 * WARNINGWARNINGWARNINGWARNINGWARNINGWARNINGWARNINGWARNINGWARNINGWARNING
 *
 * In order to make this data structure extensible, you should never
 * declare a static version of the OS handler.  You should *always*
 * allocate it with the allocation routine at the end of this file,
 * and free it with the free routine found there.  That way, if new
 * items are added to the end of this data structure, you are ok.  You
 * have been warned!  Note that if you use the standard OS handlers,
 * then you are ok.
 *
 ************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

/* An os-independent normal lock. */
typedef struct os_hnd_lock_s os_hnd_lock_t;

/* An os-independent read/write lock. */
typedef struct os_hnd_rwlock_s os_hnd_rwlock_t;

/* An os-independent condition variable. */
typedef struct os_hnd_cond_s os_hnd_cond_t;

/* An os-independent file descriptor holder. */
typedef struct os_hnd_fd_id_s os_hnd_fd_id_t;

/* An os-independent timer. */
typedef struct os_hnd_timer_id_s os_hnd_timer_id_t;

/* This is a structure that defined the os-dependent stuff required by
   threaded code.  In general, return values of these should be zero
   on success, or an errno value on failure.  The errno values will be
   propigated back up to the commands that caused these to be called,
   if possible. */
typedef void (*os_data_ready_t)(int fd, void *cb_data, os_hnd_fd_id_t *id);
typedef void (*os_timed_out_t)(void *cb_data, os_hnd_timer_id_t *id);

/* This can be registered with add_fd_to_wait_for, it will be called
   if the fd handler is freed or replaced.  This can be used to avoid
   free race conditions, handlers may be in callbacks when you remove
   an fd to wait for, this will be called when all handlers are
   done. */
typedef void (*os_fd_data_freed_t)(int fd, void *data);

/* This can be registered with free_timer, it will be called if the
   time free actually occurs.  This can be used to avoid free race
   conditions, handlers may be in callbacks when you free the timer,
   this will be called when all handlers are done. */
typedef void (*os_timer_freed_t)(void *data);

typedef struct os_handler_s os_handler_t;

/* A function to output logs, used to override the default functions. */
typedef void (*os_vlog_t)(os_handler_t         *handler,
			  const char           *format,
			  enum ipmi_log_type_e log_type,
			  va_list              ap);

struct os_handler_s
{
    /* Allocate and free data, like malloc() and free().  These are
       only used in the "main" os handler, too, not in the oned
       registered for domains. */
    void *(*mem_alloc)(int size);
    void (*mem_free)(void *data);

    /* This is called by the user code to register a callback handler
       to be called when data is ready to be read on the given file
       descriptor.  I know, it's kind of wierd, a callback to register
       a callback, but it's the best way I could think of to do this.
       This call will return an id that can then be used to cancel
       the wait.  The called code should register that whenever data
       is ready to be read from the given file descriptor, data_ready
       should be called with the given cb_data.  If this is NULL, you
       may only call the commands ending in "_wait", the event-driven
       code will return errors.  You also may not receive commands or
       events.  Note that these calls may NOT block. */
    int (*add_fd_to_wait_for)(os_handler_t       *handler,
			      int                fd,
			      os_data_ready_t    data_ready,
			      void               *cb_data,
			      os_fd_data_freed_t freed,
			      os_hnd_fd_id_t     **id);
    int (*remove_fd_to_wait_for)(os_handler_t   *handler,
				 os_hnd_fd_id_t *id);

    /* Create a timer.  This will allocate all the data required for
       the timer, so no other timer operations should fail due to lack
       of memory. */
    int (*alloc_timer)(os_handler_t      *handler,
		       os_hnd_timer_id_t **id);
    /* Free the memory for the given timer.  If the timer is running,
       stop it first. */
    int (*free_timer)(os_handler_t      *handler,
		      os_hnd_timer_id_t *id);
    /* This is called to register a callback handler to be called
       after the given amount of time (relative).  After the given
       time has passed, the "timed_out" will be called with the given
       cb_data.  The identifier in "id" just be one previously
       allocated with alloc_timer().  Note that timed_out may NOT
       block. */
    int (*start_timer)(os_handler_t      *handler,
		       os_hnd_timer_id_t *id,
		       struct timeval    *timeout,
		       os_timed_out_t    timed_out,
		       void              *cb_data);
    /* Cancel the given timer.  If the timer has already been called
       (or is in the process of being called) this should return
       ESRCH, and it may not return ESRCH for any other reason.  In
       other words, if ESRCH is returned, the timer is valid and the
       timeout handler has or will be called.  */
    int (*stop_timer)(os_handler_t      *handler,
		      os_hnd_timer_id_t *id);

    /* Used to implement locking primitives for multi-threaded access.
       If these are NULL, then the code will assume that the system is
       single-threaded and doesn't need locking.  Note that these no
       longer have to be recursive locks, they may be normal
       non-recursive locks. */
    int (*create_lock)(os_handler_t  *handler,
		       os_hnd_lock_t **id);
    int (*destroy_lock)(os_handler_t  *handler,
			os_hnd_lock_t *id);
    int (*lock)(os_handler_t  *handler,
		os_hnd_lock_t *id);
    int (*unlock)(os_handler_t  *handler,
		  os_hnd_lock_t *id);

    /* Return "len" bytes of random data into "data". */
    int (*get_random)(os_handler_t  *handler,
		      void          *data,
		      unsigned int  len);

    /* Log reports some through here.  They will not end in newlines.
       See the log types defined in ipmiif.h for more information on
       handling these. */
    void (*log)(os_handler_t         *handler,
		enum ipmi_log_type_e log_type, 
		const char           *format,
		...);
    void (*vlog)(os_handler_t         *handler,
		 enum ipmi_log_type_e log_type, 
		 const char           *format,
		 va_list              ap);

    /* The user may use this for whatever they like. */
    void *user_data;


    /* The rest of these are not used by OpenIPMI proper, but are here
       for upper layers if they need them.  If your upper layer
       doesn't use theses, you don't have to provide them. */

    /* Condition variables, like in POSIX Threads. */
    int (*create_cond)(os_handler_t  *handler,
		       os_hnd_cond_t **cond);
    int (*destroy_cond)(os_handler_t  *handler,
			os_hnd_cond_t *cond);
    int (*cond_wait)(os_handler_t  *handler,
		     os_hnd_cond_t *cond,
		     os_hnd_lock_t *lock);
    /* The timeout here is relative, not absolute. */
    int (*cond_timedwait)(os_handler_t   *handler,
			  os_hnd_cond_t  *cond,
			  os_hnd_lock_t  *lock,
			  struct timeval *timeout);
    int (*cond_wake)(os_handler_t  *handler,
		     os_hnd_cond_t *cond);
    int (*cond_broadcast)(os_handler_t  *handler,
			  os_hnd_cond_t *cond);

    /* Thread management */
    int (*create_thread)(os_handler_t       *handler,
			 int                priority,
			 void               (*startup)(void *data),
			 void               *data);
    /* Terminate the running thread. */
    int (*thread_exit)(os_handler_t *handler);

    /* Should *NOT* be used by the user, this is for the OS handler's
       internal use. */
    void *internal_data;

    /***************************************************************/

    /* These are basic function on the OS handler that are here for
       convenience to the user.  These are not used by OpenIPMI
       proper.  Depending on the specific OS handler, these may or may
       not be implemented.  If you are not sure, check for NULL. */

    /* Free the OS handler passed in.  After this call, the OS handler
       may not be used any more.  May sure that nothing is using it
       before this is called. */
    void (*free_os_handler)(os_handler_t *handler);

    /* Wait up to the amount of time specified in timeout (relative
       time) to perform one operation (a timeout, file operation,
       etc.) then return.  This return a standard errno.  If timeout
       is NULL, then this will wait forever. */
    int (*perform_one_op)(os_handler_t   *handler,
			  struct timeval *timeout);

    /* Loop continuously handling operations.  This function does not
       return. */
    void (*operation_loop)(os_handler_t *handler);


    /* The following are no longer implemented because they are
       race-prone, unneeded, and/or difficult to implement.  You may
       safely set these to NULL, but they are here for backwards
       compatability with old os handlers. */
    int (*is_locked)(os_handler_t  *handler,
		     os_hnd_lock_t *id);
    int (*create_rwlock)(os_handler_t  *handler,
			 os_hnd_rwlock_t **id);
    int (*destroy_rwlock)(os_handler_t  *handler,
			  os_hnd_rwlock_t *id);
    int (*read_lock)(os_handler_t  *handler,
		     os_hnd_rwlock_t *id);
    int (*read_unlock)(os_handler_t  *handler,
		       os_hnd_rwlock_t *id);
    int (*write_lock)(os_handler_t  *handler,
		      os_hnd_rwlock_t *id);
    int (*write_unlock)(os_handler_t  *handler,
			os_hnd_rwlock_t *id);
    int (*is_readlocked)(os_handler_t    *handler,
			 os_hnd_rwlock_t *id);
    int (*is_writelocked)(os_handler_t    *handler,
			  os_hnd_rwlock_t *id);

    /* Database storage and retrieval routines.  These are used by
       things in OpenIPMI to speed up various operations by caching
       data locally instead of going to the actual system to get them.
       The key is a arbitrary length character string.  The find
       routine returns an error on failure.  Otherwise, if it can
       fetch the data without delay, it allocates a block of data and
       returns it in data (with the length in data_len) and sets
       fetch_completed to true.  Otherwise, if it cannot fetch the
       data without delay, it will set fetch_completed to false and
       start the database operation, calling got_data() when it is
       done.

       The data returned should be freed by database_free.  Note that
       these routines are optional and do not need to be here, they
       simply speed up operation when working correctly.  Also, if
       these routines fail for some reason it is not fatal to the
       operation of OpenIPMI.  It is not a big deal. */
    int (*database_store)(os_handler_t  *handler,
			  char          *key,
			  unsigned char *data,
			  unsigned int  data_len);
    int (*database_find)(os_handler_t  *handler,
			 char          *key,
			 unsigned int  *fetch_completed,
			 unsigned char **data,
			 unsigned int  *data_len,
			 void (*got_data)(void          *cb_data,
					  int           err,
					  unsigned char *data,
					  unsigned int  data_len),
			 void *cb_data);
    void (*database_free)(os_handler_t  *handler,
			  unsigned char *data);
    /* Sets the filename to use for the database to the one specified.
       The meaning is system-dependent.  On *nix systems it defaults
       to $HOME/.OpenIPMI_db.  This is for use by the user, OpenIPMI
       proper does not use this. */
    int (*database_set_filename)(os_handler_t *handler,
				 char         *name);

    /* Set the function to send logs to. */
    void (*set_log_handler)(os_handler_t *handler,
			    os_vlog_t    log_handler);

    /* For fd handlers, allow write and except handling to be done,
       and allow any of the I/O types to be enabled and disabled. */
    void (*set_fd_handlers)(os_handler_t *handler, os_hnd_fd_id_t *id,
			    os_data_ready_t write_ready,
			    os_data_ready_t except_ready);
    int (*set_fd_enables)(os_handler_t *handler, os_hnd_fd_id_t *id,
			  int read, int write, int except);

    int (*get_monotonic_time)(os_handler_t *handler, struct timeval *tv);
    int (*get_real_time)(os_handler_t *handler, struct timeval *tv);
};

/* Only use these to allocate/free OS handlers. */
os_handler_t *ipmi_alloc_os_handler(void);
void ipmi_free_os_handler(os_handler_t *handler);

/**********************************************************************
 *
 * Tools to use OS handlers to wait.
 *
 * Well, you shouldn't have to wait for OpenIPMI to do things, you
 * should use callbacks and event-drive your programs.  However, it's
 * not always that simple.  Broken APIs that require blocking exist,
 * and it makes things ugly.
 *
 * The tools below help you with this.  They provide a way with an OS
 * handler to do blocking operations more easily.  They handle all the
 * nastiness of threading, single-threaded, and whatnot.
 *
 * To use this, allocate a waiter factory.  Then when you need to
 * wait, allocate a waiter from the factory.  It is allocated with a
 * usecount of 1.  For every operation you start, "use" the waiter.
 * When you are done starting operations, do one "release" of the
 * waiter and then wait on the waiter.  When operations complete, they
 * "release" the waiter.  When the last operation is done the wait
 * operation will return.  Then free the waiter.  You cannot reuse
 * waiters, you must allocate new ones.
 *
 * This interface has three basic modes.  If you have a
 * single-threaded OS handler (no threads support in the handler) then
 * you must set num_threads = 0 and it runs single-threaded.  The code
 * will run an event loop while waiting for the operations to complete.
 *
 * If you have multiple thread support in the OS handler and set
 * num_threads > 0, it will allocate num_threads event loop threads.
 * The event loop will not be run from the waiting thread (there are
 * race conditions with this) but condition variable are used to wake
 * the waiting thread.
 *
 * If you have multiple thread support in the OS handler and set
 * num_threads = 0, things are more complex.  This allows a
 * single-threaded application, but permits a multi-threaded
 * application.  Another thread is allocated to run the event loop.
 * It will *only* run when a thread is waiting.  Thus it preserved
 * single-threaded operation for single-threaded programs, but does
 * not have races in multi-threaded programs.
 *
 * Be careful using the timeout.  You want to be *sure* that you don't
 * free the waiter before anything else that might wake up and release
 * it.
 *
 *********************************************************************/

typedef struct os_handler_waiter_factory_s os_handler_waiter_factory_t;
typedef struct os_handler_waiter_s os_handler_waiter_t;

/* Allocate a factory to get waiters from.  This is the thing that
   owns the event loop threads (if you have them).  The event loop
   threads are allocated with thread_priority. */
int os_handler_alloc_waiter_factory(os_handler_t *os_hnd,
				    unsigned int num_threads,
				    int          thread_priority,
				    os_handler_waiter_factory_t **factory);

/* Free a waiter factory.  This will fail with EAGAIN if there are any
   waiters allocated from it that have not been freed. */
int os_handler_free_waiter_factory(os_handler_waiter_factory_t *factory);

/* Allocate a waiter from the factory.  Returns NULL on failure. It is
   allocated with a use count of 1. */
os_handler_waiter_t *os_handler_alloc_waiter
  (os_handler_waiter_factory_t *factory);

/* Free a waiter.  It cannot be waiting or an error is returned (EAGAIN). */
int os_handler_free_waiter(os_handler_waiter_t *waiter);

/* Increment the use count of the waiter. */
void os_handler_waiter_use(os_handler_waiter_t *waiter);

/* Decrement the use count of the waiter.  When the usecount reaches
   zero the waiter will return. */
void os_handler_waiter_release(os_handler_waiter_t *waiter);

/* Wait for the waiter's use count to reach zero.  If timeout is
   non-NULL, it will wait up to that amount of time. */
int os_handler_waiter_wait(os_handler_waiter_t *waiter,
			   struct timeval      *timeout);

/*
 * This is for shutting down to a level that you can restart the
 * system again.  It basically removes the built-in OS handler
 * used for memory allocation so it can be re-assigned.
 */
void os_handler_global_shutdown(void);

#ifdef __cplusplus
}
#endif

#endif /* OS_HANDLER_H */
