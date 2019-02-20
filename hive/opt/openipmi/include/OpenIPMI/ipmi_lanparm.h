/*
 * ipmi_lanparm.h
 *
 * Routines for setting up a connection to an IPMI LAN interface.
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

#ifndef OPENIPMI_LANPARM_H
#define OPENIPMI_LANPARM_H

#include <OpenIPMI/ipmi_types.h>

#ifdef __cplusplus
extern "C" {
#endif

/* The abstract type for lanparm. */
typedef struct ipmi_lanparm_s ipmi_lanparm_t;


/* Generic callback used to tell when a LANPARM operation is done. */
typedef void (*ipmi_lanparm_done_cb)(ipmi_lanparm_t *lanparm,
				     int            err,
				     void           *cb_data);

/* Generic callback for iterating. */
typedef void (*ipmi_lanparm_ptr_cb)(ipmi_lanparm_t *lanparm,
				    void           *cb_data);

/* Allocate a LANPARM. */
int ipmi_lanparm_alloc(ipmi_mc_t      *mc,
		       unsigned int   channel,
		       ipmi_lanparm_t **new_lanparm);

/* Destroy a LANPARM. */
int ipmi_lanparm_destroy(ipmi_lanparm_t       *lanparm,
			 ipmi_lanparm_done_cb handler,
			 void                 *cb_data);

/* Used to track references to a lanparm.  You can use this instead of
   ipmi_lanparm_destroy, but use of the destroy function is
   recommended.  This is primarily here to help reference-tracking
   garbage collection systems like what is in Perl to be able to
   automatically destroy lanparms when they are done. */
void ipmi_lanparm_ref(ipmi_lanparm_t *lanparm);
void ipmi_lanparm_deref(ipmi_lanparm_t *lanparm);

void ipmi_lanparm_iterate_lanparms(ipmi_domain_t       *domain,
				   ipmi_lanparm_ptr_cb handler,
				   void                *cb_data);

ipmi_mcid_t ipmi_lanparm_get_mc_id(ipmi_lanparm_t *lanparm);
unsigned int ipmi_lanparm_get_channel(ipmi_lanparm_t *lanparm);

#define IPMI_LANPARM_NAME_LEN 64
int ipmi_lanparm_get_name(ipmi_lanparm_t *lanparm, char *name, int length);



/* Fetch a parameter value from the LANPARM.  The "set" and "block"
   parameters are the set selector and block selectors.  If those are
   not relevant for the given parm, then set them to zero.  Note that
   on the return data, the first byte (byte 0) is the revision number,
   the data starts in the second byte. */
typedef void (*ipmi_lanparm_get_cb)(ipmi_lanparm_t    *lanparm,
				    int               err,
				    unsigned char     *data,
				    unsigned int      data_len,
				    void              *cb_data);
int ipmi_lanparm_get_parm(ipmi_lanparm_t      *lanparm,
			  unsigned int        parm,
			  unsigned int        set,
			  unsigned int        block,
			  ipmi_lanparm_get_cb done,
			  void                *cb_data);

/* Set the parameter value in the LANPARM to the given data. */
int ipmi_lanparm_set_parm(ipmi_lanparm_t       *lanparm,
			  unsigned int         parm,
			  unsigned char        *data,
			  unsigned int         data_len,
			  ipmi_lanparm_done_cb done,
			  void                 *cb_data);

/* The various LAN config parms. */
#define IPMI_LANPARM_SET_IN_PROGRESS		0
#define IPMI_LANPARM_AUTH_TYPE_SUPPORT		1
#define IPMI_LANPARM_AUTH_TYPE_ENABLES		2
#define IPMI_LANPARM_IP_ADDRESS			3
#define IPMI_LANPARM_IP_ADDRESS_SRC		4
#define IPMI_LANPARM_MAC_ADDRESS		5
#define IPMI_LANPARM_SUBNET_MASK		6
#define IPMI_LANPARM_IPV4_HDR_PARMS		7
#define IPMI_LANPARM_PRIMARY_RMCP_PORT		8
#define IPMI_LANPARM_SECONDARY_RMCP_PORT	9
#define IPMI_LANPARM_BMC_GENERATED_ARP_CNTL	10
#define IPMI_LANPARM_GRATUIDOUS_ARP_INTERVAL	11
#define IPMI_LANPARM_DEFAULT_GATEWAY_ADDR	12
#define IPMI_LANPARM_DEFAULT_GATEWAY_MAC_ADDR	13
#define IPMI_LANPARM_BACKUP_GATEWAY_ADDR	14
#define IPMI_LANPARM_BACKUP_GATEWAY_MAC_ADDR	15
#define IPMI_LANPARM_COMMUNITY_STRING		16
#define IPMI_LANPARM_NUM_DESTINATIONS		17
#define IPMI_LANPARM_DEST_TYPE			18
#define IPMI_LANPARM_DEST_ADDR			19
#define IPMI_LANPARM_VLAN_ID			20
#define IPMI_LANPARM_VLAN_PRIORITY		21
#define IPMI_LANPARM_NUM_CIPHER_SUITE_ENTRIES	22
#define IPMI_LANPARM_CIPHER_SUITE_ENTRY_SUPPORT	23
#define IPMI_LANPARM_CIPHER_SUITE_ENTRY_PRIV	24
#define IPMI_LANPARM_DEST_VLAN_TAG		25

#define IPMI_LANPARM_IP_ADDR_SRC_STATIC		1
#define IPMI_LANPARM_IP_ADDR_SRC_DHCP		2
#define IPMI_LANPARM_IP_ADDR_SRC_BIOS		3
#define IPMI_LANPARM_IP_ADDR_SRC_OTHER		4

/* A full LAN configuration.  Note that you cannot allocate one of
   these, you can only fetch them, modify them, set them, and free
   them. */
typedef struct ipmi_lan_config_s ipmi_lan_config_t;

/* Get the full LAN configuration and lock the LAN.  Note that if the
   LAN is locked by another, you will get an EAGAIN error in the
   callback.  You can retry the operation, or if you are sure that it
   is free, you can call ipmi_lan_clear_lock() before retrying.  Note
   that the config in the callback *must* be freed by you. */
typedef void (*ipmi_lan_get_config_cb)(ipmi_lanparm_t    *lanparm,
				       int               err,
				       ipmi_lan_config_t *config,
				       void              *cb_data);
int ipmi_lan_get_config(ipmi_lanparm_t         *lanparm,
			ipmi_lan_get_config_cb done,
			void                   *cb_data);

/* Set the full LAN configuration.  The config *MUST* be locked and
   the lanparm must match the LAN that it was fetched with.  Note that
   a copy is made of the configuration, so you are free to do whatever
   you like with it after this.  Note that this unlocks the config, so
   it cannot be used for future set operations. */
int ipmi_lan_set_config(ipmi_lanparm_t       *lanparm,
			ipmi_lan_config_t    *config,
			ipmi_lanparm_done_cb done,
			void                 *cb_data);

/* Clear the lock on a LAN.  If the LAN config is non-NULL, then it's
   lock is also cleared. */
int ipmi_lan_clear_lock(ipmi_lanparm_t       *lanparm,
			ipmi_lan_config_t    *lanc,
			ipmi_lanparm_done_cb done,
			void                 *cb_data);

/* Free a LAN config. */
void ipmi_lan_free_config(ipmi_lan_config_t *config);

/*
 * Boatloads of data from the LAN config.  Note that all IP addresses,
 * ports, etc. are in network order.
 */

/* This interface lets you fetch and set the data values by parm
   num. Note that the parm nums *DO NOT* correspond to the
   IPMI_LANPARM_xxx values above. */

enum ipmi_lanconf_val_type_e { IPMI_LANCONFIG_INT, IPMI_LANCONFIG_BOOL,
			       IPMI_LANCONFIG_DATA,
			       IPMI_LANCONFIG_IP, IPMI_LANCONFIG_MAC };
/* When getting the value, the valtype will be set to int or data.  If
   it is int or bool, the value is returned in ival and the dval is
   not used.  If it is data, ip, or mac, the data will be returned in
   an allocated array in dval and the length set in dval_len.  The
   data must be freed with ipmi_lanconfig_data_free().  The is used
   for some data items (the priv level for authentication type, the
   destination for alerts and destination addresses); for other items
   it is ignored.  The index should point to the value to fetch
   (starting at zero), it will be updated to the next value or -1 if
   no more are left.  The index will be unchanged if the parm does not
   support an index.

   The string name is returned in the name field, if it is not NULL.

   Note that when fetching a value, if the passed in pointer is NULL
   the data will not be filled in (except for index, which must always
   be present).  That lets you get the value type without getting the
   data, for instance. */
int ipmi_lanconfig_get_val(ipmi_lan_config_t *lanc,
			   unsigned int      parm,
			   const char        **name,
			   int               *index,
			   enum ipmi_lanconf_val_type_e *valtype,
			   unsigned int      *ival,
			   unsigned char     **dval,
			   unsigned int      *dval_len);
  /* Set a value in the lan config.  You must know ahead of time the
     actual value type and set the proper one. */
int ipmi_lanconfig_set_val(ipmi_lan_config_t *lanc,
			   unsigned int      parm,
			   int               index,
			   unsigned int      ival,
			   unsigned char     *dval,
			   unsigned int      dval_len);
/* If the value is an integer, this can be used to determine if it is
   an enumeration and what the values are.  If the parm is not an
   enumeration, this will return ENOSYS for the parm.  Otherwise, if
   you pass in zero, you will get either the first enumeration value,
   or EINVAL if zero is not a valid enumeration, but there are others.
   If this returns EINVAL or 0, nval will be set to the next valid
   enumeration value, or -1 if val is the last or past the last
   enumeration value.  If this returns 0, val will be set to the
   string value for the enumeration. */
int ipmi_lanconfig_enum_val(unsigned int parm, int val, int *nval,
			    const char **sval);
/* Sometimes array indexes may be enumerations.  This allows the user
   to detect if a specific parm's array index is an enumeration, and
   to get the enumeration values.  */
int ipmi_lanconfig_enum_idx(unsigned int parm, int idx, const char **sval);
/* Free data from ipmi_lanconfig_get_val(). */
void ipmi_lanconfig_data_free(void *data);
/* Convert a string to a lanconfig parm number.  Returns -1 if the
   string is invalid. */
unsigned int ipmi_lanconfig_str_to_parm(char *name);
/* Convert the parm to a string name. */
const char *ipmi_lanconfig_parm_to_str(unsigned int parm);
/* Get the type of a specific parm. */
int ipmi_lanconfig_parm_to_type(unsigned int                 parm,
				enum ipmi_lanconf_val_type_e *valtype);


/* The first set of parameters here must be present, so they are
   returned directly, no errors for getting.  Setting returns an
   error. */

/* Supported authentication types. This is read-only. */
unsigned int ipmi_lanconfig_get_support_auth_oem(ipmi_lan_config_t *lanc);
unsigned int ipmi_lanconfig_get_support_auth_straight(ipmi_lan_config_t *lanc);
unsigned int ipmi_lanconfig_get_support_auth_md5(ipmi_lan_config_t *lanc);
unsigned int ipmi_lanconfig_get_support_auth_md2(ipmi_lan_config_t *lanc);
unsigned int ipmi_lanconfig_get_support_auth_none(ipmi_lan_config_t *lanc);

/* Various IP-related information. */
unsigned int ipmi_lanconfig_get_ip_addr_source(ipmi_lan_config_t *lanc);
int ipmi_lanconfig_set_ip_addr_source(ipmi_lan_config_t *lanc,
				      unsigned int      val);

/* Number of allowed alert destinations.  This is read-only.  Note
   that this is *not* the value returned from the config, it is one
   more than the value, so it is the actual number of alert
   destinations (including the volatile destination 0). */
unsigned int ipmi_lanconfig_get_num_alert_destinations(ipmi_lan_config_t *c);


/* Everything else below returns an error. */
int ipmi_lanconfig_get_ipv4_ttl(ipmi_lan_config_t *lanc,
				unsigned int      *val);
int ipmi_lanconfig_set_ipv4_ttl(ipmi_lan_config_t *lanc,
				unsigned int      val);
int ipmi_lanconfig_get_ipv4_flags(ipmi_lan_config_t *lanc,
				  unsigned int      *val);
int ipmi_lanconfig_set_ipv4_flags(ipmi_lan_config_t *lanc,
				  unsigned int      val);
int ipmi_lanconfig_get_ipv4_precedence(ipmi_lan_config_t *lanc,
				       unsigned int      *val);
int ipmi_lanconfig_set_ipv4_precedence(ipmi_lan_config_t *lanc,
				       unsigned int      val);
int ipmi_lanconfig_get_ipv4_tos(ipmi_lan_config_t *lanc,
				unsigned int      *val);
int ipmi_lanconfig_set_ipv4_tos(ipmi_lan_config_t *lanc,
				unsigned int      val);

/* Authorization enables for the various authentication levels. */
int ipmi_lanconfig_get_enable_auth_oem(ipmi_lan_config_t *lanc,
				       unsigned int      user,
				       unsigned int      *val);
int ipmi_lanconfig_get_enable_auth_straight(ipmi_lan_config_t *lanc,
					    unsigned int      user,
					    unsigned int      *val);
int ipmi_lanconfig_get_enable_auth_md5(ipmi_lan_config_t *lanc,
				       unsigned int      user,
				       unsigned int      *val);
int ipmi_lanconfig_get_enable_auth_md2(ipmi_lan_config_t *lanc,
				       unsigned int      user,
				       unsigned int      *val);
int ipmi_lanconfig_get_enable_auth_none(ipmi_lan_config_t *lanc,
					unsigned int      user,
					unsigned int      *val);
int ipmi_lanconfig_set_enable_auth_oem(ipmi_lan_config_t *lanc,
				       unsigned int      user,
				       unsigned int      val);
int ipmi_lanconfig_set_enable_auth_straight(ipmi_lan_config_t *lanc,
					    unsigned int      user,
					    unsigned int      val);
int ipmi_lanconfig_set_enable_auth_md5(ipmi_lan_config_t *lanc,
				       unsigned int      user,
				       unsigned int      val);
int ipmi_lanconfig_set_enable_auth_md2(ipmi_lan_config_t *lanc,
				       unsigned int      user,
				       unsigned int      val);
int ipmi_lanconfig_set_enable_auth_none(ipmi_lan_config_t *lanc,
					unsigned int      user,
					unsigned int      val);

/* Addressing for the BMC. */
int ipmi_lanconfig_get_ip_addr(ipmi_lan_config_t *lanc,
			       unsigned char     *data,
			       unsigned int      *data_len);
int ipmi_lanconfig_set_ip_addr(ipmi_lan_config_t *lanc,
			       unsigned char     *data,
			       unsigned int      data_len);

int ipmi_lanconfig_get_mac_addr(ipmi_lan_config_t *lanc,
				unsigned char     *data,
				unsigned int      *data_len);
int ipmi_lanconfig_set_mac_addr(ipmi_lan_config_t *lanc,
				unsigned char     *data,
				unsigned int      data_len);

int ipmi_lanconfig_get_subnet_mask(ipmi_lan_config_t *lanc,
				   unsigned char     *data,
				   unsigned int      *data_len);
int ipmi_lanconfig_set_subnet_mask(ipmi_lan_config_t *lanc,
				   unsigned char     *data,
				   unsigned int      data_len);

int ipmi_lanconfig_get_primary_rmcp_port(ipmi_lan_config_t *lanc,
					 unsigned char     *data,
					 unsigned int      *data_len);
int ipmi_lanconfig_set_primary_rmcp_port(ipmi_lan_config_t *lanc,
					 unsigned char     *data,
					 unsigned int      data_len);
int ipmi_lanconfig_get_port_rmcp_primary(ipmi_lan_config_t *lanc,
					 unsigned int      *val);
int ipmi_lanconfig_set_port_rmcp_primary(ipmi_lan_config_t *lanc,
					 unsigned int      val);
int ipmi_lanconfig_get_secondary_rmcp_port(ipmi_lan_config_t *lanc,
					   unsigned char     *data,
					   unsigned int      *data_len);
int ipmi_lanconfig_set_secondary_rmcp_port(ipmi_lan_config_t *lanc,
					   unsigned char     *data,
					   unsigned int      data_len);
int ipmi_lanconfig_get_port_rmcp_secondary(ipmi_lan_config_t *lanc,
					   unsigned int      *val);
int ipmi_lanconfig_set_port_rmcp_secondary(ipmi_lan_config_t *lanc,
					   unsigned int      val);

/* Control of ARP-ing.  These are optional and so may return errors. */
int ipmi_lanconfig_get_bmc_generated_arps(ipmi_lan_config_t *lanc,
					  unsigned int      *val);
int ipmi_lanconfig_set_bmc_generated_arps(ipmi_lan_config_t *lanc,
					  unsigned int      val);
int ipmi_lanconfig_get_bmc_generated_garps(ipmi_lan_config_t *lanc,
					   unsigned int      *val);
int ipmi_lanconfig_set_bmc_generated_garps(ipmi_lan_config_t *lanc,
					   unsigned int      val);
int ipmi_lanconfig_get_garp_interval(ipmi_lan_config_t *lanc,
				     unsigned int      *val);
int ipmi_lanconfig_set_garp_interval(ipmi_lan_config_t *lanc,
				     unsigned int      val);

/* Gateway handling */
int ipmi_lanconfig_get_default_gateway_ip_addr(ipmi_lan_config_t *lanc,
					       unsigned char     *data,
					       unsigned int      *data_len);
int ipmi_lanconfig_set_default_gateway_ip_addr(ipmi_lan_config_t *lanc,
					       unsigned char     *data,
					       unsigned int      data_len);
int ipmi_lanconfig_get_default_gateway_mac_addr(ipmi_lan_config_t *lanc,
						unsigned char     *data,
						unsigned int      *data_len);
int ipmi_lanconfig_set_default_gateway_mac_addr(ipmi_lan_config_t *lanc,
						unsigned char     *data,
						unsigned int      data_len);
int ipmi_lanconfig_get_backup_gateway_ip_addr(ipmi_lan_config_t *lanc,
					      unsigned char     *data,
					      unsigned int      *data_len);
int ipmi_lanconfig_set_backup_gateway_ip_addr(ipmi_lan_config_t *lanc,
					      unsigned char     *data,
					      unsigned int      data_len);
int ipmi_lanconfig_get_backup_gateway_mac_addr(ipmi_lan_config_t *lanc,
					       unsigned char     *data,
					       unsigned int      *data_len);
int ipmi_lanconfig_set_backup_gateway_mac_addr(ipmi_lan_config_t *lanc,
					       unsigned char     *data,
					       unsigned int      data_len);

/* The community string for SNMP traps sent. */
int ipmi_lanconfig_get_community_string(ipmi_lan_config_t *lanc,
					unsigned char     *data,
					unsigned int      *data_len);
int ipmi_lanconfig_set_community_string(ipmi_lan_config_t *lanc,
					unsigned char     *data,
					unsigned int      data_len);

/* Everthing else is part of the LAN Alert destination table and is
   addressed on a per-destination basis. */
int ipmi_lanconfig_get_alert_ack(ipmi_lan_config_t *lanc,
				 unsigned int      dest,
				 unsigned int      *val);
int ipmi_lanconfig_set_alert_ack(ipmi_lan_config_t *lanc,
				 unsigned int      dest,
				 unsigned int      val);
int ipmi_lanconfig_get_dest_type(ipmi_lan_config_t *lanc,
				 unsigned int      dest,
				 unsigned int      *val);
int ipmi_lanconfig_set_dest_type(ipmi_lan_config_t *lanc,
				 unsigned int      dest,
				 unsigned int      val);
int ipmi_lanconfig_get_alert_retry_interval(ipmi_lan_config_t *lanc,
					    unsigned int      dest,
					    unsigned int      *val);
int ipmi_lanconfig_set_alert_retry_interval(ipmi_lan_config_t *lanc,
					    unsigned int      dest,
					    unsigned int      val);
int ipmi_lanconfig_get_max_alert_retries(ipmi_lan_config_t *lanc,
					 unsigned int      dest,
					 unsigned int      *val);
int ipmi_lanconfig_set_max_alert_retries(ipmi_lan_config_t *lanc,
					 unsigned int      dest,
					 unsigned int      val);
int ipmi_lanconfig_get_dest_format(ipmi_lan_config_t *lanc,
				   unsigned int      dest,
				   unsigned int      *val);
int ipmi_lanconfig_set_dest_format(ipmi_lan_config_t *lanc,
				   unsigned int      dest,
				   unsigned int      val);
int ipmi_lanconfig_get_gw_to_use(ipmi_lan_config_t *lanc,
				 unsigned int      dest,
				 unsigned int      *val);
int ipmi_lanconfig_set_gw_to_use(ipmi_lan_config_t *lanc,
				 unsigned int      dest,
				 unsigned int      val);
int ipmi_lanconfig_get_dest_ip_addr(ipmi_lan_config_t *lanc,
				    unsigned int      dest,
				    unsigned char     *data,
				    unsigned int      *data_len);
int ipmi_lanconfig_set_dest_ip_addr(ipmi_lan_config_t *lanc,
				    unsigned int      dest,
				    unsigned char     *data,
				    unsigned int      data_len);
int ipmi_lanconfig_get_dest_mac_addr(ipmi_lan_config_t *lanc,
				     unsigned int      dest,
				     unsigned char     *data,
				     unsigned int      *data_len);
int ipmi_lanconfig_set_dest_mac_addr(ipmi_lan_config_t *lanc,
				     unsigned int      dest,
				     unsigned char     *data,
				     unsigned int      data_len);
int ipmi_lanconfig_get_dest_vlan_tag_type(ipmi_lan_config_t *lanc,
					  unsigned int      dest,
					  unsigned int      *val);
int ipmi_lanconfig_set_dest_vlan_tag_type(ipmi_lan_config_t *lanc,
					  unsigned int      dest,
					  unsigned int      val);
int ipmi_lanconfig_get_dest_vlan_tag(ipmi_lan_config_t *lanc,
				     unsigned int      dest,
				     unsigned int      *val);
int ipmi_lanconfig_set_dest_vlan_tag(ipmi_lan_config_t *lanc,
				     unsigned int      dest,
				     unsigned int      val);

/* VLAN support */
int ipmi_lanconfig_get_vlan_id(ipmi_lan_config_t *lanc,
			       unsigned int      *val);
int ipmi_lanconfig_set_vlan_id(ipmi_lan_config_t *lanc,
			       unsigned int      val);
int ipmi_lanconfig_get_vlan_id_enable(ipmi_lan_config_t *lanc,
				      unsigned int      *val);
int ipmi_lanconfig_set_vlan_id_enable(ipmi_lan_config_t *lanc,
				      unsigned int      val);
int ipmi_lanconfig_get_vlan_priority(ipmi_lan_config_t *lanc,
				     unsigned int      *val);
int ipmi_lanconfig_set_vlan_priority(ipmi_lan_config_t *lanc,
				     unsigned int      val);

/* Cipher Suites */
unsigned int ipmi_lanconfig_get_num_cipher_suites(ipmi_lan_config_t *lanc);
					   
int ipmi_lanconfig_get_cipher_suite_entry(ipmi_lan_config_t *lanc,
					  unsigned int      entry,
					  unsigned int      *val);
int ipmi_lanconfig_set_cipher_suite_entry(ipmi_lan_config_t *lanc,
					  unsigned int      entry,
					  unsigned int      val);
int ipmi_lanconfig_get_max_priv_for_cipher_suite(ipmi_lan_config_t *lanc,
						 unsigned int      entry,
						 unsigned int      *val);
int ipmi_lanconfig_set_max_priv_for_cipher_suite(ipmi_lan_config_t *lanc,
						 unsigned int      entry,
						 unsigned int      val);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_LANPARM_H */
