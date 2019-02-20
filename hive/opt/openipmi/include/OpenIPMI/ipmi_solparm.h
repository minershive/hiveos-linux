/*
 * ipmi_solparm.h
 *
 * Routines for configuring IPMI SoL data.
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2006 MontaVista Software Inc.
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

#ifndef OPENIPMI_SOLPARM_H
#define OPENIPMI_SOLPARM_H

#include <OpenIPMI/ipmi_types.h>

#ifdef __cplusplus
extern "C" {
#endif

/* The abstract type for solparm. */
typedef struct ipmi_solparm_s ipmi_solparm_t;


/* Generic callback used to tell when a SOLPARM operation is done. */
typedef void (*ipmi_solparm_done_cb)(ipmi_solparm_t *solparm,
				     int            err,
				     void           *cb_data);

/* Generic callback for iterating. */
typedef void (*ipmi_solparm_ptr_cb)(ipmi_solparm_t *solparm,
				    void           *cb_data);

/* Allocate a SOLPARM. */
int ipmi_solparm_alloc(ipmi_mc_t      *mc,
		       unsigned int   channel,
		       ipmi_solparm_t **new_solparm);

/* Destroy a SOLPARM. */
int ipmi_solparm_destroy(ipmi_solparm_t       *solparm,
			 ipmi_solparm_done_cb handler,
			 void                 *cb_data);

/* Used to track references to a solparm.  You can use this instead of
   ipmi_solparm_destroy, but use of the destroy function is
   recommended.  This is primarily here to help reference-tracking
   garbage collection systems like what is in Perl to be able to
   automatically destroy solparms when they are done. */
void ipmi_solparm_ref(ipmi_solparm_t *solparm);
void ipmi_solparm_deref(ipmi_solparm_t *solparm);

void ipmi_solparm_iterate_solparms(ipmi_domain_t       *domain,
				   ipmi_solparm_ptr_cb handler,
				   void                *cb_data);

ipmi_mcid_t ipmi_solparm_get_mc_id(ipmi_solparm_t *solparm);
unsigned int ipmi_solparm_get_channel(ipmi_solparm_t *solparm);

#define IPMI_SOLPARM_NAME_LEN 64
int ipmi_solparm_get_name(ipmi_solparm_t *solparm, char *name, int length);



/* Fetch a parameter value from the SOLPARM.  The "set" and "block"
   parameters are the set selector and block selectors.  If those are
   not relevant for the given parm, then set them to zero.  Note that
   on the return data, the first byte (byte 0) is the revision number,
   the data starts in the second byte. */
typedef void (*ipmi_solparm_get_cb)(ipmi_solparm_t    *solparm,
				    int               err,
				    unsigned char     *data,
				    unsigned int      data_len,
				    void              *cb_data);
int ipmi_solparm_get_parm(ipmi_solparm_t      *solparm,
			  unsigned int        parm,
			  unsigned int        set,
			  unsigned int        block,
			  ipmi_solparm_get_cb done,
			  void                *cb_data);

/* Set the parameter value in the SOLPARM to the given data. */
int ipmi_solparm_set_parm(ipmi_solparm_t       *solparm,
			  unsigned int         parm,
			  unsigned char        *data,
			  unsigned int         data_len,
			  ipmi_solparm_done_cb done,
			  void                 *cb_data);

/* The various SoL config parms. */
#define IPMI_SOLPARM_SET_IN_PROGRESS		0
#define IPMI_SOLPARM_ENABLE			1
#define IPMI_SOLPARM_AUTHENTICATION		2
#define IPMI_SOLPARM_CHAR_SETTINGS		3
#define IPMI_SOLPARM_RETRY			4
#define IPMI_SOLPARM_NONVOLATILE_BITRATE	5
#define IPMI_SOLPARM_VOLATILE_BITRATE		6
#define IPMI_SOLPARM_PAYLOAD_CHANNEL		7
#define IPMI_SOLPARM_PAYLOAD_PORT_NUMBER	8

/* A full SoL configuration.  Note that you cannot allocate one of
   these, you can only fetch them, modify them, set them, and free
   them. */
typedef struct ipmi_sol_config_s ipmi_sol_config_t;

/* Get the full SOL configuration and lock the SOL.  Note that if the
   SOL is locked by another, you will get an EAGAIN error in the
   callback.  You can retry the operation, or if you are sure that it
   is free, you can call ipmi_sol_clear_lock() before retrying.  Note
   that the config in the callback *must* be freed by you. */
typedef void (*ipmi_sol_get_config_cb)(ipmi_solparm_t    *solparm,
				       int               err,
				       ipmi_sol_config_t *config,
				       void              *cb_data);
int ipmi_sol_get_config(ipmi_solparm_t         *solparm,
			ipmi_sol_get_config_cb done,
			void                   *cb_data);

/* Set the full SOL configuration.  The config *MUST* be locked and
   the solparm must match the SOL that it was fetched with.  Note that
   a copy is made of the configuration, so you are free to do whatever
   you like with it after this.  Note that this unlocks the config, so
   it cannot be used for future set operations. */
int ipmi_sol_set_config(ipmi_solparm_t       *solparm,
			ipmi_sol_config_t    *config,
			ipmi_solparm_done_cb done,
			void                 *cb_data);

/* Clear the lock on a SOL.  If the SOL config is non-NULL, then it's
   lock is also cleared. */
int ipmi_sol_clear_lock(ipmi_solparm_t       *solparm,
			ipmi_sol_config_t    *solc,
			ipmi_solparm_done_cb done,
			void                 *cb_data);

/* Free a SOL config. */
void ipmi_sol_free_config(ipmi_sol_config_t *config);

/*
 * Boatloads of data from the SOL config.  Note that all IP addresses,
 * ports, etc. are in network order.
 */

/* This interface lets you fetch and set the data values by parm
   num. Note that the parm nums *DO NOT* correspond to the
   IPMI_SOLPARM_xxx values above. */

enum ipmi_solconf_val_type_e { IPMI_SOLCONFIG_INT, IPMI_SOLCONFIG_BOOL,
			       IPMI_SOLCONFIG_DATA,
			       IPMI_SOLCONFIG_IP, IPMI_SOLCONFIG_MAC };
/* When getting the value, the valtype will be set to int or data.  If
   it is int or bool, the value is returned in ival and the dval is
   not used.  If it is data, ip, or mac, the data will be returned in
   an allocated array in dval and the length set in dval_len.  The
   data must be freed with ipmi_solconfig_data_free().  The is used
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
int ipmi_solconfig_get_val(ipmi_sol_config_t *solc,
			   unsigned int      parm,
			   const char        **name,
			   int               *index,
			   enum ipmi_solconf_val_type_e *valtype,
			   unsigned int      *ival,
			   unsigned char     **dval,
			   unsigned int      *dval_len);
  /* Set a value in the sol config.  You must know ahead of time the
     actual value type and set the proper one. */
int ipmi_solconfig_set_val(ipmi_sol_config_t *solc,
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
int ipmi_solconfig_enum_val(unsigned int parm, int val, int *nval,
			    const char **sval);
/* Sometimes array indexes may be enumerations.  This allows the user
   to detect if a specific parm's array index is an enumeration, and
   to get the enumeration values.  */
int ipmi_solconfig_enum_idx(unsigned int parm, int idx, const char **sval);
/* Free data from ipmi_solconfig_get_val(). */
void ipmi_solconfig_data_free(void *data);
/* Convert a string to a solconfig parm number.  Returns -1 if the
   string is invalid. */
unsigned int ipmi_solconfig_str_to_parm(char *name);
/* Convert the parm to a string name. */
const char *ipmi_solconfig_parm_to_str(unsigned int parm);
/* Get the type of a specific parm. */
int ipmi_solconfig_parm_to_type(unsigned int                 parm,
				enum ipmi_solconf_val_type_e *valtype);


/* Settings for getting at individual parameters directly. */

unsigned int
ipmi_solconfig_get_enable(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_enable(ipmi_sol_config_t *solc,
			  unsigned int      val);

unsigned int
ipmi_solconfig_get_force_payload_encryption(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_force_payload_encryption(ipmi_sol_config_t *solc,
					    unsigned int      val);

unsigned int
ipmi_solconfig_get_force_payload_authentication(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_force_payload_authentication(ipmi_sol_config_t *solc,
						unsigned int      val);

unsigned int
ipmi_solconfig_get_privilege_level(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_privilege_level(ipmi_sol_config_t *solc,
				   unsigned int      val);

unsigned int
ipmi_solconfig_get_char_accumulation_interval(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_char_accumulation_interval(ipmi_sol_config_t *solc,
					      unsigned int      val);

unsigned int
ipmi_solconfig_get_char_send_threshold(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_char_send_threshold(ipmi_sol_config_t *solc,
				       unsigned int      val);

unsigned int
ipmi_solconfig_get_retry_count(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_retry_count(ipmi_sol_config_t *solc,
			       unsigned int      val);

unsigned int
ipmi_solconfig_get_retry_interval(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_retry_interval(ipmi_sol_config_t *solc,
				  unsigned int      val);

unsigned int
ipmi_solconfig_get_non_volatile_bitrate(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_non_volatile_bitrate(ipmi_sol_config_t *solc,
					unsigned int      val);

unsigned int
ipmi_solconfig_get_volatile_bitrate(ipmi_sol_config_t *solc);
int
ipmi_solconfig_set_volatile_bitrate(ipmi_sol_config_t *solc,
				   unsigned int      val);

int
ipmi_solconfig_get_port_number(ipmi_sol_config_t *solc,
			       unsigned int      *data);
int
ipmi_solconfig_set_port_number(ipmi_sol_config_t *solc,
			       unsigned int      val);

int
ipmi_solconfig_get_payload_channel(ipmi_sol_config_t *solc,
				   unsigned int      *data);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_SOLPARM_H */
