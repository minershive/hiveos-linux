/*
 * ipmi_user.h
 *
 * MontaVista IPMI interface for users/passwords
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2004 MontaVista Software Inc.
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

#ifndef OPENIPMI_USER_H
#define OPENIPMI_USER_H

#include <OpenIPMI/ipmi_mc.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * A list of users.
 */
typedef struct ipmi_user_list_s ipmi_user_list_t;

/*
 * Fetch the users from the given MC and get the user info for the
 * given channel.  The user name and password is global for all
 * channels on an MC, the rest of the parameters are per-channel.
 * You can fetch a specific user number, or IPMI_MC_ALL_USERS
 * to fetch everything.
 */
typedef void (*ipmi_user_list_cb)(ipmi_mc_t        *mc,
				  int              err,
				  ipmi_user_list_t *list,
				  void             *cb_data);
#define IPMI_MC_ALL_USERS	0
int ipmi_mc_get_users(ipmi_mc_t         *mc,
		      unsigned int      channel,
		      unsigned int      user,
		      ipmi_user_list_cb handler,
		      void              *cb_data);

int ipmi_user_list_get_channel(ipmi_user_list_t *list, unsigned int *channel);
int ipmi_user_list_get_max_user(ipmi_user_list_t *list, unsigned int *max);
int ipmi_user_list_get_enabled_users(ipmi_user_list_t *list, unsigned int *e);
int ipmi_user_list_get_fixed_users(ipmi_user_list_t *list, unsigned int *f);

/*
 * You may not keep the user list returned from ipmi_mc_get_users(),
 * but this lets you keep a copy of it and free that copy.  DO NOT
 * free the copy given to you by ipmi_mc_get_users().
 */
ipmi_user_list_t *ipmi_user_list_copy(ipmi_user_list_t *list);
void ipmi_user_list_free(ipmi_user_list_t *list);

/*
 * An individual user.
 */
typedef struct ipmi_user_s ipmi_user_t;

/*
 * Get the number of users and fetch individual users.  Note
 * that the fetched user is a copy and must be freed with
 * ipmi_user_free().  The users are indexed sequentially and
 * not necessarily by number.
 */
unsigned int ipmi_user_list_get_user_count(ipmi_user_list_t *users);
ipmi_user_t *ipmi_user_list_get_user(ipmi_user_list_t *list,
				     unsigned int     idx);

/*
 * Allows users to be copied and freed.
 */
ipmi_user_t *ipmi_user_copy(ipmi_user_t *user);
void ipmi_user_free(ipmi_user_t *user);

/* Write the user info to the given user number on the given MC.  Note
   that the user number in the user data structure is ignore, the
   passed in one is used. */
int ipmi_mc_set_user(ipmi_mc_t       *mc,
		     unsigned int    channel,
		     unsigned int    num,
		     ipmi_user_t     *user,
		     ipmi_mc_done_cb handler,
		     void            *cb_data);

int ipmi_user_get_channel(ipmi_user_t *user, unsigned int *channel);

/*
 * Get/set the number for the user.
 */
int ipmi_user_get_num(ipmi_user_t *user, unsigned int *num);
int ipmi_user_set_num(ipmi_user_t *user, unsigned int num);

/*
 * Get/set the name for the user.  When getting the name, the pointer
 * to "len" should point to a value of the length of "name".  "len"
 * will be updated to the actual number of characters copied.  The
 * password set is for 16-byte passwords, the password2 is for 20-byte
 * passwords.
 */
int ipmi_user_get_name_len(ipmi_user_t *user, unsigned int *len);
int ipmi_user_get_name(ipmi_user_t *user, char *name, unsigned int *len);
int ipmi_user_set_name(ipmi_user_t *user, char *name, unsigned int len);
int ipmi_user_set_password(ipmi_user_t *user, char *pw, unsigned int len);
int ipmi_user_set_password2(ipmi_user_t *user, char *pw, unsigned int len);

/*
 * Various bits of information about a user, this is per-channel.
 */
int ipmi_user_get_link_auth_enabled(ipmi_user_t *user, unsigned int *val);
int ipmi_user_set_link_auth_enabled(ipmi_user_t *user, unsigned int val);
int ipmi_user_get_msg_auth_enabled(ipmi_user_t *user, unsigned int *val);
int ipmi_user_set_msg_auth_enabled(ipmi_user_t *user, unsigned int val);
int ipmi_user_get_access_cb_only(ipmi_user_t *user, unsigned int *val);
int ipmi_user_set_access_cb_only(ipmi_user_t *user, unsigned int val);
int ipmi_user_get_privilege_limit(ipmi_user_t *user, unsigned int *val);
int ipmi_user_set_privilege_limit(ipmi_user_t *user, unsigned int val);
int ipmi_user_get_session_limit(ipmi_user_t *user, unsigned int *val);
int ipmi_user_set_session_limit(ipmi_user_t *user, unsigned int val);

/*
 * The enable for the user.  Note that the enable value cannot be
 * fetched and will return an error unless set.
 */
int ipmi_user_get_enable(ipmi_user_t *user, unsigned int *val);
int ipmi_user_set_enable(ipmi_user_t *user, unsigned int val);


/*
 * Normally only the fields set for a user are actually modified.
 * This will force all fields to be written.
 */
int ipmi_user_set_all(ipmi_user_t *user);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_USER_H */
