/*
 * os_handler.h
 *
 * MontaVista IPMI os handler interface.
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

#ifndef OPENIPMI_POSIX_H
#define OPENIPMI_POSIX_H

#include <OpenIPMI/os_handler.h>
#include <OpenIPMI/selector.h>
#include <OpenIPMI/deprecator.h>

#ifdef __cplusplus
extern "C" {
#endif

/* These are the defined OS handlers for POSIX with and without
   threading.  If you use these (and thus link with the OpenIPMIposix
   or OpenIPMIpthread libraries) you must provide posix_vlog().  It is
   not provided by the library. */
/* DEPRECATED - This should no longer be used, you should use the
   OS-handler function to set your log handler.  If you do not supply
   your own os_vlog handler, logs will go to stderr.  If you supply a
   posix_vlog handler and don't call set_log_handler in the OS handler,
   posix_vlog() will still be used. */
void posix_vlog(char *format,
		enum ipmi_log_type_e log_type,
		va_list ap);

/* Non-threaded os handler operations */

/**********************************************************************
 * Allocate and set up an OS handler and selector for non-threaded
 * use.  This is the one you should use unless you have special needs
 * for the selector.
 *********************************************************************/
/* Allocate and configure an OS handler. */
os_handler_t *ipmi_posix_setup_os_handler(void);
/* Gets the selector associated with the OS handler. */
struct selector_s *ipmi_posix_os_handler_get_sel(os_handler_t *os_hnd);


/**********************************************************************
 * Allocate and free an OS handler that uses non-threaded POSIX calls.
 * These are required if you need to know about your selector ahead of
 * time.  To use this, do something like:
 *   os_hnd = ipmi_posix_get_os_handler();
 *   if (!os_hnd) {
 *	printf("ipmi_smi_setup_con: Unable to allocate os handler\n");
 *	exit(1);
 *  }
 *
 *  rv = sel_alloc_selector_nothread(&sel);
 *  if (rv)
 *      handle_error();
 *
 *  ipmi_posix_os_handler_set_sel(os_hnd, sel);
 *
 *  ipmi_init(os_hnd);
 *
 * You only really need to use this in special circumstances.
 *********************************************************************/
os_handler_t *ipmi_posix_get_os_handler(void);
void ipmi_posix_free_os_handler(os_handler_t *os_hnd);
/* You MUST set the SEL you alloc in the OS handler before you do
   anything else with the OS handler. */
void ipmi_posix_os_handler_set_sel(os_handler_t *os_hnd,
				   struct selector_s *sel);


/**********************************************************************
 * Allocate and set up an OS handler and selector for hreaded use.
 * This is the one you should use unless you have special needs for
 * the selector.
 *********************************************************************/
/* Set up a selector.  wake_sig is used to wake up selects when things
   change and they need to wake up.  It must be some unused signal (it
   does not have to be queued); a signal handler will be installed for
   it. */
os_handler_t *ipmi_posix_thread_setup_os_handler(int wake_sig);
/* Gets the selector associated with the OS handler. */
struct selector_s *ipmi_posix_thread_os_handler_get_sel(os_handler_t *os_hnd);

/**********************************************************************
 * Special code, like the previous non-threaded ones.  Only needed
 * if you have special selector needs.  Don't use
 * ipmi_posix_thread_get_os_handler(), it has no way to set the
 * wake signal.
 *********************************************************************/
os_handler_t *ipmi_posix_thread_get_os_handler(void);
os_handler_t *ipmi_posix_thread_get_os_handler2(int wake_sig);
void ipmi_posix_thread_free_os_handler(os_handler_t *os_hnd);
void ipmi_posix_thread_os_handler_set_sel(os_handler_t *os_hnd,
					  struct selector_s *sel);

/**********************************************************************
 * Cruft, do not use these function any more.
 *********************************************************************/

#ifndef IPMI_FUNC_DEPRECATED
# if (__GNUC__ > 3) || ((__GNUC__ == 3) && (__GNUC_MINOR__ >= 2))
#  define IPMI_FUNC_DEPRECATED __attribute__ ((deprecated))
#  define IPMI_TYPE_DEPRECATED __attribute__ ((deprecated))
#  define IPMI_VAR_DEPRECATED __attribute__ ((deprecated))
# else
#  define IPMI_FUNC_DEPRECATED
#  define IPMI_TYPE_DEPRECATED
#  define IPMI_VAR_DEPRECATED
# endif
#endif

/* Cleanup and free an OS handler. */
void ipmi_posix_cleanup_os_handler(os_handler_t *os_hnd)
     IPMI_FUNC_DEPRECATED;
/* Calls sel_select() with the proper data. */
int ipmi_posix_sel_select(os_handler_t   *os_hnd,
			   struct timeval *timeout)
     IPMI_FUNC_DEPRECATED;
/* Calls sel_select_loop() with the proper data. */
void ipmi_posix_sel_select_loop(os_handler_t *os_hnd)
     IPMI_FUNC_DEPRECATED;

/* Clean up the threaded selector, including returning the signal to
   its original state. */
void ipmi_posix_thread_cleanup_os_handler(os_handler_t *os_hnd)
     IPMI_FUNC_DEPRECATED;
/* Calls sel_select() with the proper data.  Note that if you send
   "wake_sig" to the calling thread, this will return. */
int ipmi_posix_thread_sel_select(os_handler_t   *os_hnd,
				 struct timeval *timeout)
     IPMI_FUNC_DEPRECATED;
/* Calls sel_select_loop() with the proper data. */
void ipmi_posix_thread_sel_select_loop(os_handler_t *os_hnd)
     IPMI_FUNC_DEPRECATED;

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_POSIX_H */
