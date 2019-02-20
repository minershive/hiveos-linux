/*
 * ipmi_mc.ui
 *
 * MontaVista IPMI interface for a basic curses UI
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

#ifndef OPENIPMI_UI_H
#define OPENIPMI_UI_H

#include <OpenIPMI/ipmi_types.h>
#include <OpenIPMI/os_handler.h>
#include <OpenIPMI/selector.h>

#ifdef __cplusplus
extern "C" {
#endif

extern os_handler_t ipmi_ui_cb_handlers;

int ipmi_ui_init(os_handler_t *os_hnd, int full_screen);
void ipmi_ui_shutdown(void);

void ipmi_ui_set_first_domain(ipmi_domain_id_t fdomain_id);

void ipmi_ui_setup_done(ipmi_domain_t *mc,
			int           err,
			unsigned int  conn_num,
			unsigned int  port_num,
			int           still_connected,
			void          *user_data);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_UI_H */
