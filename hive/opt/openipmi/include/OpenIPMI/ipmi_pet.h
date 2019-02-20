/*
 * ipmi_pet.h
 *
 * MontaVista IPMI interface for setting up and handling platform event
 * traps.
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

#ifndef OPENIPMI_PET_H
#define OPENIPMI_PET_H

#include <OpenIPMI/ipmi_types.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct ipmi_pet_s ipmi_pet_t;

typedef void (*ipmi_pet_done_cb)(ipmi_pet_t *pet, int err, void *cb_data);

/* Create and configure a Platform Event Trap handler for the given
 * channel in the given domain.  Parameters are: 
 *
 *  channel - The specific channel to configure.  There is not real
 *      way to know all the channels and what IP addresses should
 *      be used for each.
 *  ip_addr - The IP address to tell the PET to send messages to, if
 *      applicable for this domain.
 *  mac_addr - The MAC address to tell the PET to send messages to,
 *      if applicable for this domain.
 *  eft_sel - the Event Filter selector to use for this PET destination.
 *      Note that this does *not* need to be unique for different OpenIPMI
 *      instances that are using the same channel, since the configuration
 *      will be exactly the same for all EFT entries using the same
 *      channel, assuming they share the same policy number.
 *  policy_num - The policy number to use for the alert policy.  This
 *      should be the same for all users of a domain.
 *  apt_sel - The Alert Policy selector to use for this PET destination.
 *      Note that as eft_sel, this needs to be unique for each different
 *      OpenIPMI instance on the same channel, as it specifies the
 *      destination to use.
 *  lan_dest_sel - The LAN configuration destination selector for this PET
 *      destination.  Unlike eft_sel and apt_sel, this *must* be unique
 *      for each OpenIPMI instance on the same channel.
 *
 * Creating one of these in a domain will cause event traps to be received
 * and handled as standard events in OpenIPMI.
 *
 * Note that this uses the standard SNMP trap port (162), so you
 * cannot run SNMP software that receives traps and an IPMI PET at
 * the same time on the same machine.
 */
int ipmi_pet_create(ipmi_domain_t    *domain,
		    unsigned int     connection,
		    unsigned int     channel,
		    struct in_addr   ip_addr,
		    unsigned char    mac_addr[6],
		    unsigned int     eft_sel,
		    unsigned int     policy_num,
		    unsigned int     apt_sel,
		    unsigned int     lan_dest_sel,
		    ipmi_pet_done_cb done,
		    void             *cb_data,
		    ipmi_pet_t       **pet);

/*
 * Like the previous call, but takes an MC instead of a domain and
 * channel.
 */
int ipmi_pet_create_mc(ipmi_mc_t        *mc,
		       unsigned int     channel,
		       struct in_addr   ip_addr,
		       unsigned char    mac_addr[6],
		       unsigned int     eft_sel,
		       unsigned int     policy_num,
		       unsigned int     apt_sel,
		       unsigned int     lan_dest_sel,
		       ipmi_pet_done_cb done,
		       void             *cb_data,
		       ipmi_pet_t       **ret_pet);

/* Destroy a PET.  Note that if you destroy all PETs, this will result
   in the SNMP trap UDP port being closed. */
int ipmi_pet_destroy(ipmi_pet_t       *pet,
		     ipmi_pet_done_cb done,
		     void             *cb_data);

/* Used to track references to a pet.  You can use this instead of
   ipmi_pet_destroy, but use of the destroy function is
   recommended.  This is primarily here to help reference-tracking
   garbage collection systems like what is in Perl to be able to
   automatically destroy pets when they are done. */
void ipmi_pet_ref(ipmi_pet_t *pet);
void ipmi_pet_deref(ipmi_pet_t *pet);

/* Get the "name" for the PET.  Returns the length of the string
   (minus the closing \0).  PET names are auto-assigned. */
#define IPMI_PET_NAME_LEN 64
int ipmi_pet_get_name(ipmi_pet_t *pet, char *name, int len);

/* Iterate through all the PETs. */
typedef void (*ipmi_pet_ptr_cb)(ipmi_pet_t *pet, void *cb_data);
void ipmi_pet_iterate_pets(ipmi_domain_t   *domain,
			   ipmi_pet_ptr_cb handler,
			   void            *cb_data);

ipmi_mcid_t ipmi_pet_get_mc_id(ipmi_pet_t *pet);
unsigned int ipmi_pet_get_channel(ipmi_pet_t *pet);
struct in_addr *ipmi_pet_get_ip_addr(ipmi_pet_t *pet, struct in_addr *ip_addr);
unsigned char *ipmi_pet_get_mac_addr(ipmi_pet_t    *pet,
				     unsigned char mac_addr[6]);
unsigned int ipmi_pet_get_eft_sel(ipmi_pet_t *pet);
unsigned int ipmi_pet_get_policy_num(ipmi_pet_t *pet);
unsigned int ipmi_pet_get_apt_sel(ipmi_pet_t *pet);
unsigned int ipmi_pet_get_lan_dest_sel(ipmi_pet_t *pet);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_PET_H */
