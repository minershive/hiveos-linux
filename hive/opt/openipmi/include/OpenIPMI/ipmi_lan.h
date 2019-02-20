/*
 * ipmi_lan.h
 *
 * Routines for setting up a connection to an IPMI Lan interface.
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

#ifndef OPENIPMI_LAN_H
#define OPENIPMI_LAN_H

#include <OpenIPMI/ipmi_addr.h>
#include <OpenIPMI/ipmi_conn.h>
#include <netinet/in.h>

#ifdef __cplusplus
extern "C" {
#endif

#define IPMI_LAN_STD_PORT	623
#define IPMI_LAN_STD_PORT_STR	"623"

/*
 * Yet another interface to set up a LAN connection.  This is the
 * most flexible, and hopefully will be the last one.  This one is
 * flexible enough to handle RMCP+ connections and will also handle
 * normal LAN connections.  The parameters are:
 *
 *  ip_addrs - The IP addresses of the remote BMC.  You may list
 *     multiple IP addresses in an array, each address *must* be to the
 *     same BMC.  This is an array of string pointers to the string
 *     representations of the IP addresses, you can pass in names or
 *     dot notation.  It takes IPV4 and IPV6 addresses.
 *  ports - The UDP ports to use, one for each address.  It should
 *     generally be IPMI_LAN_STD_PORT.  This is an array of string
 *     pointers to string representations of the port.  You can pass
 *     in names or numeric values.
 *  num_ip_addrs - The number of ip addresses (and thus ports) in the
 *     arrays above.
 *  parms - An array of items used to configure the connection.
 *     See the individual parms for details.  This may be NULL if
 *     num_parms is zero.
 *  num_parms - The number of parms in the parms array.
 *  handlers - The set of OS handlers to use for this connection.
 *  user_data - This will be put into the BMC and may be fetched by the
 *     user.  The user can use it for anything they like.
 *  new_con - The new connection is returned here.
 */
typedef struct ipmi_lanp_parm_s
{
    int          parm_id;
    int          parm_val;
    void         *parm_data;
    unsigned int parm_data_len;
} ipmi_lanp_parm_t;
int ipmi_lanp_setup_con(ipmi_lanp_parm_t *parms,
			unsigned int     num_parms,
			os_handler_t     *handlers,
			void             *user_data,
			ipmi_con_t       **new_con);

/* Set the authorization type for a connection.  If not specified,
   this will default to the best available one.  The type is in the
   parm_val, the parm_data is not used. */
#define IPMI_LANP_PARMID_AUTHTYPE	1

/* Set the privilege level requested for a connection.  If not
   specified, this will default to admin.  The type is in the
   parm_val, the parm_data is not used. */
#define IPMI_LANP_PARMID_PRIVILEGE	2

/* Set the password for the connection.  If not specified, a NULL
   password will be used.  The password is in the parm_data, the
   parm_val is not used. */
#define IPMI_LANP_PARMID_PASSWORD	3

/* Set the password for the connection.  If not specified, User 1 (the
   default user) will be used.  The name is in the parm_data, the
   parm_val is not used. */
#define IPMI_LANP_PARMID_USERNAME	4

/* Set the addresses used for the connection.  This should be supplied
   as an array of pointers to characters in the parm_data value.  The
   parm_val is not used.  To use this, have something like:
     char *ips[2];
     ips[0] = ...;
     ips[1] = ...;
     parms[i].parm_id = IPMI_LANP_PARMID_ADDRS;
     parms[i].parm_data = ips;
     parms[i].parm_data_len = 2;
   Note that the parm_data_len is the number of elements in the array
   of addresses, not the size of the array.  This parameter must be
   specified. */
#define IPMI_LANP_PARMID_ADDRS		5

/* Set the ports used for the connection.  This should be supplied
   as an array of pointers to characters in the parm_data value.  The
   parm_val is not used.  To use this, have something like:
     char *ips[2];
     ips[0] = ...;
     ips[1] = ...;
     parms[i].parm_id = IPMI_LANP_PARMID_ADDRS;
     parms[i].parm_data = ips;
     parms[i].parm_data_len = 2;
   Note that the parm_data_len is the number of elements in the array
   of addresses, not the size of the array.  If not specified, this
   defaults to IPMI_LAN_STD_PORT for every address.  Note that the length
   of this must match the length of the number of addresses. */
#define IPMI_LANP_PARMID_PORTS		6

/* Allow the specific authentication, integrity, and confidentiality
   algorithms to be specified by the user.  Note that you can specify
   OEM values here.  The defaults are RACKP_HMAC_SHA1, HMAC_SHA1_96, and
   AES_CBC_128 for the best mandatory security. */
#define IPMI_LANP_AUTHENTICATION_ALGORITHM	7
#define IPMI_LANP_AUTHENTICATION_ALGORITHM_BMCPICK		(~0)
#define IPMI_LANP_AUTHENTICATION_ALGORITHM_RAKP_NONE		0
#define IPMI_LANP_AUTHENTICATION_ALGORITHM_RAKP_HMAC_SHA1	1
#define IPMI_LANP_AUTHENTICATION_ALGORITHM_RAKP_HMAC_MD5	2
#define IPMI_LANP_INTEGRITY_ALGORITHM		8
#define IPMI_LANP_INTEGRITY_ALGORITHM_BMCPICK			(~0)
#define IPMI_LANP_INTEGRITY_ALGORITHM_NONE			0
#define IPMI_LANP_INTEGRITY_ALGORITHM_HMAC_SHA1_96		1
#define IPMI_LANP_INTEGRITY_ALGORITHM_HMAC_MD5_128		2
#define IPMI_LANP_INTEGRITY_ALGORITHM_MD5_128			3
#define IPMI_LANP_CONFIDENTIALITY_ALGORITHM	9
#define IPMI_LANP_CONFIDENTIALITY_ALGORITHM_BMCPICK		(~0)
#define IPMI_LANP_CONFIDENTIALITY_ALGORITHM_NONE		0
#define IPMI_LANP_CONFIDENTIALITY_ALGORITHM_AES_CBC_128		1
#define IPMI_LANP_CONFIDENTIALITY_ALGORITHM_xRC4_128		2
#define IPMI_LANP_CONFIDENTIALITY_ALGORITHM_xRC4_40		3

/*
 * If true (the default) this will do a classic IPMI 1.5 name lookup.
 * If false, this will use the privilege as part of the lookup and
 * will match the first user with the matching name and privilege.
 * See the RAKP message 1 for details.
 */
#define IPMI_LANP_NAME_LOOKUP_ONLY		10

/* Set the BMC key for the connection (RMCP+ only).  If not specified,
   all zeros will be used.  The key is in the parm_data, the parm_val
   is not used. */
#define IPMI_LANP_BMC_KEY			11

/* Allow the maximum outstanding message count to be set.  Normally
   this is 2, but 2 may even be too much for some systems.  A larger
   number may improve performance for systems that can handle it.  The
   maximum value is 63, but that's way bigger than anyone should need.
   5-6 should be enough for anything.  The value is set in parm_val */
#define IPMI_LANP_MAX_OUTSTANDING_MSG_COUNT	12

/* Address family, integer value, generally AF_INET or AF_INET6.  If
   unspecified, it used AF_UNSPEC. */
#define IPMI_LANP_ADDRESS_FAMILY		13

/*
 * Set up an IPMI LAN connection.  The boatload of parameters are:
 *
 *  ip_addrs - The IP addresses of the remote BMC.  You may list
 *     multiple IP addresses in an array, each address *must* be to the
 *     same BMC.  This is an array of string pointers to the string
 *     representations of the IP addresses, you can pass in names or
 *     dot notation.  It takes IPV4 and IPV6 addresses.
 *  ports - The UDP ports to use, one for each address.  It should
 *     generally be IPMI_LAN_STD_PORT.  This is an array of string
 *     pointers to string representations of the port.  You can pass
 *     in names or numeric values.
 *  num_ip_addrs - The number of ip addresses (and thus ports) in the
 *     arrays above.
 *  authtype - The authentication type to use, from ipmi_auth.h
 *  privilege - The privilege level to request for the connection, from
 *     the set of values in ipmi_auth.h.
 *  username - The 16-byte max username to use for the connection.
 *  username_len - The length of username.
 *  password - The 16-byte max password to use for the connection.
 *  password_len - The length of password.
 *  handlers - The set of OS handlers to use for this connection.
 *  user_data - This will be put into the BMC and may be fetched by the
 *     user.  The user can use it for anything they like.
 *  new_con - The new connection is returned here.
 */
int ipmi_ip_setup_con(char         * const ip_addrs[],
		      char         * const ports[],
		      unsigned int num_ip_addrs,
		      unsigned int authtype,
		      unsigned int privilege,
		      void         *username,
		      unsigned int username_len,
		      void         *password,
		      unsigned int password_len,
		      os_handler_t *handlers,
		      void         *user_data,
		      ipmi_con_t   **new_con);

/* This is the old version of the above call, it only works on IPv4
   addresses.  Its use is deprecated. */
int ipmi_lan_setup_con(struct in_addr *ip_addrs,
		       int            *ports,
		       unsigned int   num_ip_addrs,
		       unsigned int   authtype,
		       unsigned int   privilege,
		       void           *username,
		       unsigned int   username_len,
		       void           *password,
		       unsigned int   password_len,
		       os_handler_t   *handlers,
		       void           *user_data,
		       ipmi_con_t     **new_con);

/* Used to handle SNMP traps.  If the msg is NULL, that means that the
   trap sender didn't send enough information to handle the trap
   immediately, and the SEL needs to be scanned. */
int ipmi_lan_handle_external_event(const struct sockaddr *src_addr,
				   const ipmi_msg_t      *msg,
				   const unsigned char   *pet_ack);

/*
 * RMCP+ payload handling.  To register a payload, pass in a static
 * ipmi_payload_t stucture with the various functions set.  Note that
 * IPMI and OEM expicit payloads have special handling, you cannot
 * register those payload types.  Registering a NULL payload removes
 * the handler.
 */
#define IPMI_RMCPP_PAYLOAD_TYPE_IPMI		0
#define IPMI_RMCPP_PAYLOAD_TYPE_SOL		1
#define IPMI_RMCPP_PAYLOAD_TYPE_OEM_EXPLICIT	2

#define IPMI_RMCPP_PAYLOAD_TYPE_OPEN_SESSION_REQUEST	0x10
#define IPMI_RMCPP_PAYLOAD_TYPE_OPEN_SESSION_RESPONSE	0x11
#define IPMI_RMCPP_PAYLOAD_TYPE_RAKP_1			0x12
#define IPMI_RMCPP_PAYLOAD_TYPE_RAKP_2			0x13
#define IPMI_RMCPP_PAYLOAD_TYPE_RAKP_3			0x14
#define IPMI_RMCPP_PAYLOAD_TYPE_RAKP_4			0x15

#define IPMI_RMCPP_ADDR_SOL (IPMI_RMCPP_ADDR_START + IPMI_RMCPP_PAYLOAD_TYPE_SOL)

typedef struct ipmi_payload_s
{
    /* Format a message for transmit on this payload.  The address and
       message is the one specified by the user.  The out_data is a
       pointer to where to store the output, out_data_len will point
       to the length of the buffer to store the output and should be
       updatated to be the actual length.  The seq is a 6-bit value
       that should be store somewhere so the that response to this
       message can be identified.  If the netfn is odd, the sequence
       number is not used.  The out_of_session variable is set to zero
       by default; if the message is meant to be sent out of session,
       then the formatter should set this value to 1. */
    int (*format_for_xmit)(ipmi_con_t        *conn,
			   const ipmi_addr_t *addr,
			   unsigned int      addr_len,
			   const ipmi_msg_t  *msg,
			   unsigned char     *out_data,
			   unsigned int      *out_data_len,
			   int               *out_of_session,
			   unsigned char     seq);

    /* Get the recv sequence number from the message.  Return ENOSYS
       if the sequence number is not valid for the message (it is
       asynchronous). */
    int (*get_recv_seq)(ipmi_con_t    *conn,
			unsigned char *data,
			unsigned int  data_len,
			unsigned char *seq);

    /* Fill in the rspi data structure from the given data, responses
       only.  This does *not* deliver the message, that is done by the
       LAN code.  If this returns -1, that means the LAN code should
       call handle_send_rsp_err on the connection if it is defined. */
    int (*handle_recv_rsp)(ipmi_con_t    *conn,
			   ipmi_msgi_t   *rspi,
			   ipmi_addr_t   *orig_addr,
			   unsigned int  orig_addr_len,
			   ipmi_msg_t    *orig_msg,
			   unsigned char *data,
			   unsigned int  data_len);

    /* Handle an asynchronous message.  This *should* deliver the
       message, if possible. */
    void (*handle_recv_async)(ipmi_con_t    *conn,
			      unsigned char *data,
			      unsigned int  data_len);

    /* If the message has a tag, return it in "tag".  This field may
       be NULL if the payload doesn't have tags.  If this field is
       present, it should return an error if the message is not valid
       or the tag could not be extracted.  Note that tags are only for
       identifying sessions ids for out-of-connection messages
       that have zero in the session id field, and thus this is not
       generally used by most payloads. */
    int (*get_msg_tag)(unsigned char *data, unsigned int data_len,
		       unsigned char *tag);
} ipmi_payload_t;

int ipmi_rmcpp_register_payload(unsigned int   payload_type,
				ipmi_payload_t *payload);

/* Register a payload to be called when the specific payload type
   (must be an OEM number) comes in with the iana and payload id or
   goes out with those values in the address.  The payload id is only
   used for payload type 2. */
int ipmi_rmcpp_register_oem_payload(unsigned int   payload_type,
				    unsigned char  iana[3],
				    unsigned int   payload_id,
				    ipmi_payload_t *payload);

/*
 * RMCP+ algorithm handling.
 *
 * Note that all registered data structures should be static.  Note that
 * you can deregister an algorithm by setting it to zero, but this is
 * discouraged because of race conditions.  You should also not change
 * these pointers dynamically, as the RMCP code may copy these to internal
 * places for its own and you wouldn't be able to change those copies.
 */

/* The auth data structure.  The one passed to the algorithm is
   guaranteed to be valid until the free function is called on the
   algorithm.  For authentication, an error value will be returned
   from ipmi_lan_send_command_forceip() (you are using that, right?)
   before the data goes away.  The auth algorithm should fill in the
   data it is defined to set.  Note that this returns pointers to the
   actual data and returns the full length of the data.  Be careful
   not to overrun it when setting things.  The password and bmc_key
   values will be filled out to zeros to the max_length.  Note that
   the LAN code will make sure to zero the sensitive values upon
   shutdown. */
typedef struct ipmi_rmcpp_auth_s ipmi_rmcpp_auth_t;

uint32_t ipmi_rmcpp_auth_get_my_session_id(ipmi_rmcpp_auth_t *ainfo);
uint32_t ipmi_rmcpp_auth_get_mgsys_session_id(ipmi_rmcpp_auth_t *ainfo);
uint8_t ipmi_rmcpp_auth_get_role(ipmi_rmcpp_auth_t *ainfo);
const unsigned char *ipmi_rmcpp_auth_get_username(ipmi_rmcpp_auth_t *ainfo,
						  unsigned int      *max_len);
unsigned int ipmi_rmcpp_auth_get_username_len(ipmi_rmcpp_auth_t *ainfo);
const unsigned char *ipmi_rmcpp_auth_get_password(ipmi_rmcpp_auth_t *ainfo,
						  unsigned int      *max_len);
unsigned int ipmi_rmcpp_auth_get_password_len(ipmi_rmcpp_auth_t *ainfo);
int ipmi_rmcpp_auth_get_use_two_keys(ipmi_rmcpp_auth_t *ainfo);
const unsigned char *ipmi_rmcpp_auth_get_bmc_key(ipmi_rmcpp_auth_t *ainfo,
						 unsigned int      *max_len);
unsigned int ipmi_rmcpp_auth_get_bmc_key_len(ipmi_rmcpp_auth_t *ainfo);

/* From the get channel auth. */
const unsigned char *ipmi_rmcpp_auth_get_oem_iana(ipmi_rmcpp_auth_t *ainfo,
						  unsigned int      *len);
unsigned char ipmi_rmcpp_auth_get_oem_aux(ipmi_rmcpp_auth_t *ainfo);

/* Should be filled in by the auth algorithm. */
unsigned char *ipmi_rmcpp_auth_get_my_rand(ipmi_rmcpp_auth_t *ainfo,
					   unsigned int      *max_len);
unsigned int ipmi_rmcpp_auth_get_my_rand_len(ipmi_rmcpp_auth_t *ainfo);
void ipmi_rmcpp_auth_set_my_rand_len(ipmi_rmcpp_auth_t *ainfo,
				     unsigned int      length);
unsigned char *ipmi_rmcpp_auth_get_mgsys_rand(ipmi_rmcpp_auth_t *ainfo,
					      unsigned int      *max_len);
unsigned int ipmi_rmcpp_auth_get_mgsys_rand_len(ipmi_rmcpp_auth_t *ainfo);
void ipmi_rmcpp_auth_set_mgsys_rand_len(ipmi_rmcpp_auth_t *ainfo,
					unsigned int      length);
unsigned char *ipmi_rmcpp_auth_get_mgsys_guid(ipmi_rmcpp_auth_t *ainfo,
					      unsigned int      *max_len);
unsigned int ipmi_rmcpp_auth_get_mgsys_guid_len(ipmi_rmcpp_auth_t *ainfo);
void ipmi_rmcpp_auth_set_mgsys_guid_len(ipmi_rmcpp_auth_t *ainfo,
					unsigned int      length);
unsigned char *ipmi_rmcpp_auth_get_sik(ipmi_rmcpp_auth_t *ainfo,
				       unsigned int      *max_len);
unsigned int ipmi_rmcpp_auth_get_sik_len(ipmi_rmcpp_auth_t *ainfo);
void ipmi_rmcpp_auth_set_sik_len(ipmi_rmcpp_auth_t *ainfo,
				 unsigned int      length);
unsigned char *ipmi_rmcpp_auth_get_k1(ipmi_rmcpp_auth_t *ainfo,
				      unsigned int      *max_len);
unsigned int ipmi_rmcpp_auth_get_k1_len(ipmi_rmcpp_auth_t *ainfo);
void ipmi_rmcpp_auth_set_k1_len(ipmi_rmcpp_auth_t *ainfo,
				unsigned int      length);
unsigned char *ipmi_rmcpp_auth_get_k2(ipmi_rmcpp_auth_t *ainfo,
				      unsigned int      *max_len);
unsigned int ipmi_rmcpp_auth_get_k2_len(ipmi_rmcpp_auth_t *ainfo);
void ipmi_rmcpp_auth_set_k2_len(ipmi_rmcpp_auth_t *ainfo,
				unsigned int      length);


typedef void (*ipmi_rmcpp_finish_auth_cb)(ipmi_con_t    *ipmi,
					  int           err,
					  int           addr_num,
					  void          *cb_data);
typedef int (*ipmi_rmcpp_set_info_cb)(ipmi_con_t        *ipmi,
				      int               addr_num,
				      ipmi_rmcpp_auth_t *ainfo,
				      void              *cb_data);

typedef struct ipmi_rmcpp_authentication_s
{
    /* Call the set function after the key info is obtained but before
       the final "ack".  This lets the algorithm fail the connection
       if the lan code cannot set up the data.  The msg_tag is a value
       that should be extractable from the message response (ie the
       rakp message tag). */
    int (*start_auth)(ipmi_con_t                *ipmi,
		      int                       addr_num,
		      unsigned char             msg_tag,
		      ipmi_rmcpp_auth_t         *ainfo,
		      ipmi_rmcpp_set_info_cb    set,
		      ipmi_rmcpp_finish_auth_cb done,
		      void                      *cb_data);
} ipmi_rmcpp_authentication_t;

int ipmi_rmcpp_register_authentication(unsigned int                auth_num,
				       ipmi_rmcpp_authentication_t *auth);

/* Register an OEM auth algorithm, the auth_num must be in the OEM range. */
int ipmi_rmcpp_register_oem_authentication(unsigned int                auth_num,
					   unsigned char               iana[3],
					   ipmi_rmcpp_authentication_t *auth);

typedef struct ipmi_rmcpp_confidentiality_s
{
    int (*conf_init)(ipmi_con_t        *ipmi,
		     ipmi_rmcpp_auth_t *ainfo,
		     void              **conf_data);
    void (*conf_free)(ipmi_con_t *ipmi,
		     void        *conf_data);

    /* This adds the confidentiality header and trailer.  The payload
       points to a pointer to the payload data itself.  The header
       length points to the number of bytes available before the
       payload.  The payload length points to the length of the
       payload.  The function should add the header and trailer to the
       payload, update the payload to point to the start of the
       header, update the header length to remove the data it used for
       its header, and update the payload length for any trailer used.
       The original payload_len value plus the trailer data should not
       exceed the max_payload_len for the trailer nor should
       header_len go negative.  Note that if you use header data, you
       should increase max_payload_len appropriately. */
    int (*conf_encrypt)(ipmi_con_t    *ipmi,
			void          *conf_data,
			unsigned char **payload,
			unsigned int  *header_len,
			unsigned int  *payload_len,
			unsigned int  *max_payload_len);


    /* Decrypt the given data (in place).  The payload starts at
       beginning of the confidentiality header and the payload length
       includes the confidentiality trailer.  This function should
       update the payload to remove the header and the payload_len to
       remove any headers and trailers, including all padding. */
    int (*conf_decrypt)(ipmi_con_t    *ipmi,
			void          *conf_data,
			unsigned char **payload,
			unsigned int  *payload_len);

} ipmi_rmcpp_confidentiality_t;

int ipmi_rmcpp_register_confidentiality(unsigned int                 conf_num,
					ipmi_rmcpp_confidentiality_t *conf);

/* Register an OEM conf algorithm, the conf_num must be in the OEM range. */
int ipmi_rmcpp_register_oem_confidentiality(unsigned int                  conf_num,
					    unsigned char                 iana[3],
					    ipmi_rmcpp_confidentiality_t *conf);


typedef struct ipmi_rmcpp_integrity_s
{
    int (*integ_init)(ipmi_con_t       *ipmi,
		     ipmi_rmcpp_auth_t *ainfo,
		      void             **integ_data);
    void (*integ_free)(ipmi_con_t *ipmi,
		       void       *integ_data);

    /* This adds the integrity trailer padding after the payload data.
       It should add any padding after the payload and update the
       payload length.  The payload_len should not exceed
       max_payload_len.  The payload starts at beginning of the user
       message (the RMCP version). */
    int (*integ_pad)(ipmi_con_t    *ipmi,
		     void          *integ_data,
		     unsigned char *payload,
		     unsigned int  *payload_len,
		     unsigned int  max_payload_len);

    /* This adds the integrity trailer after the payload data (and
       padding).  The payload_len should not exceed max_payload_len.
       The payload starts at beginning of the user message (the RMCP
       version). */
    int (*integ_add)(ipmi_con_t    *ipmi,
		     void          *integ_data,
		     unsigned char *payload,
		     unsigned int  *payload_len,
		     unsigned int  max_payload_len);

    /* Verify the integrity of the given data.  The payload starts at
       beginning of the user message (the RMCP version).  The payload
       length is the length including any integrity padding but not
       the next header or authcode data. The total length includes all
       the data, including the autocode data. */
    int (*integ_check)(ipmi_con_t    *ipmi,
		       void          *integ_data,
		       unsigned char *payload,
		       unsigned int  payload_len,
		       unsigned int  total_len);

} ipmi_rmcpp_integrity_t;

int ipmi_rmcpp_register_integrity(unsigned int           integ_num,
				  ipmi_rmcpp_integrity_t *integ);

/* Register an OEM integ algorithm, the integ_num must be in the OEM range. */
int ipmi_rmcpp_register_oem_integrity(unsigned int           integ_num,
				      unsigned char          iana[3],
				      ipmi_rmcpp_integrity_t *integ);

/* Authentication algorithms should use this to send messages.  Note
   that when yo use this interface, it will always set rspi->data4 to
   the address number, you must cast it with (long) rspi->data4. */
int ipmi_lan_send_command_forceip(ipmi_con_t            *ipmi,
				  int                   addr_num,
				  ipmi_addr_t           *addr,
				  unsigned int          addr_len,
				  ipmi_msg_t            *msg,
				  ipmi_ll_rsp_handler_t rsp_handler,
				  ipmi_msgi_t           *rspi);


/*
 * Hacks for various things.  Don't use this stuff unless you *really*
 * know what you are doing.
 */

/* Call the connection change handlers on the LAN interface.  This can
   be used for OEM connection code that needs to manage its own
   connections.  Note that the OEM code must make sure this is
   single-threaded. */
void i_ipmi_lan_call_con_change_handlers(ipmi_con_t   *ipmi,
					int          err,
					unsigned int port);

void i_ipmi_lan_con_change_lock(ipmi_con_t *ipmi);

void i_ipmi_lan_con_change_unlock(ipmi_con_t *ipmi);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_LAN_H */
