/*
 * ipmi_cmdlang.h
 *
 * A command interpreter for OpenIPMI
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

#ifndef OPENIPMI_CMDLANG_H
#define OPENIPMI_CMDLANG_H

#include <OpenIPMI/selector.h>
#include <OpenIPMI/ipmi_bits.h>
#include <OpenIPMI/ipmi_types.h>
#include <OpenIPMI/ipmi_addr.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Forward declaration */
typedef struct ipmi_cmd_info_s ipmi_cmd_info_t;

/*
 * A structure that must be passed into the command parser; it has
 * general information about the how the parser should handle thing
 * and generate its output.
 */
typedef struct ipmi_cmdlang_s ipmi_cmdlang_t;

/* Output is done in name:value pairs.  If you don't have a value,
   pass in NULL. */
typedef void (*cmd_out_cb)(ipmi_cmdlang_t *info,
			   const char     *name,
			   const char     *value);
typedef void (*cmd_out_b_cb)(ipmi_cmdlang_t *info,
			     const char     *name,
			     const char     *value,
			     unsigned int   len);

/* Command-specific info. */
typedef void (*cmd_info_cb)(ipmi_cmdlang_t *info);

/* The user provides one of these when they call the command language
   interpreter.  It is used to report errors and generate output. */
struct ipmi_cmdlang_s
{
    cmd_out_cb   out;	   /* Generate output with this. */
    cmd_info_cb  down;     /* Go down a level (new indention or
			      nesting) */
    cmd_info_cb  up;       /* Go up a level (leave the current
			      indention or nesting) */
    cmd_info_cb  done;     /* Called when the command is done.  If
			      there was an error, the err value in
			      info will be non-null. */
    cmd_out_b_cb out_binary; /* Generate binary output with this. */
    cmd_out_b_cb out_unicode; /* Generate unicode output with this. */

    /* OS handler to use for the commands.  Note that this may be set
       to NULL if not required, don't depend on them except in certain
       circumstances. */
    os_handler_t *os_hnd;

    /* Tells if we are outputting help. */
    int         help;

    /*
     * Error reporting
     */
    int          err;      /* If non-zero, the errno code of the error
			      that occurred. */

    /* If non-NULL, an error occurred and this is the error info.  If
       the error string is dynamically allocated (and thus should be
       freed), errstr_dynalloc should be set to true. */
    char         *errstr;
    int          errstr_dynalloc;

    /* If an error occurs, this will be set to the object name that
       was dealing with the error.  It may be an empty string if
       no object is handling the error.  This must be pre-allocated
       and the length set properly. */
    char         *objstr;
    int          objstr_len;

    /* This is the location of an error. */
    char         *location;


    void         *user_data; /* User data for anything the user wants */
};

/* Parse and handle the given command string.  This always calls the
   done function when complete. */
void ipmi_cmdlang_handle(ipmi_cmdlang_t *cmdlang, char *str);

/* If the event info is true, then the system will output object
   information with each add or change event. */
void ipmi_cmdlang_set_evinfo(int evinfo);
int ipmi_cmdlang_get_evinfo(void);

/*
 * This is used to hold command information.
 */
typedef struct ipmi_cmdlang_cmd_s ipmi_cmdlang_cmd_t;

typedef void (*ipmi_cmdlang_handler_cb)(ipmi_cmd_info_t *cmd_info);
typedef void (*ipmi_help_finisher_cb)(ipmi_cmdlang_t *cmdlang);

/* Register a command as a subcommand of the parent, or into the main
   command list if parent is NULL.  The command will have the given
   name and help text.  When the command is executed, the handler will
   be called with a cmd_info structure passed in.  The handler_data parm
   passed in below will be in the "handler_data" field of the cmd_info
   structure.  Note that if you are attaching subcommands to this
   command, you should pass in a NULL handler.  Returns an error value. */
int ipmi_cmdlang_reg_cmd(ipmi_cmdlang_cmd_t      *parent,
			 char                    *name,
			 char                    *help,
			 ipmi_cmdlang_handler_cb handler,
			 void                    *handler_data,
			 ipmi_help_finisher_cb   help_finish,
			 ipmi_cmdlang_cmd_t      **rv);

/* Register a table of commands. */
typedef struct ipmi_cmdlang_init_s
{
    char                    *name;
    ipmi_cmdlang_cmd_t      **parent;
    char                    *help;
    ipmi_cmdlang_handler_cb handler;
    void                    *cb_data;
    ipmi_cmdlang_cmd_t      **new_val;
    ipmi_help_finisher_cb   help_finish;
} ipmi_cmdlang_init_t;
int ipmi_cmdlang_reg_table(ipmi_cmdlang_init_t *table, int len);


/* The following functions handle parsing various OpenIPMI objects
   according to the naming standard.  If you pass it into a command
   registration as the handler and pass your function as the
   handler_data, your function will be called with the specified
   object.  The specific function type is given in the individual
   functions.  The cmd_info will be passed in as the cb_data.

   For instance, if you have a command that take an entity argument,
   then you could write:
     void ent_cmd_hnd(ipmi_entity_t *entity, void *cb_data)
     {
         ipmi_cmd_info_t *cmd_info = cb_data;
     }

     rv = ipmi_cmdlang_reg_cmd(parent, "ent_cmd", "The ent command",
			       ipmi_cmdlang_entity_handler, ent_cmd_hnd,
			       &cmd);
*/

/* ipmi_domain_ptr_cb */
void ipmi_cmdlang_domain_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_entity_ptr_cb */
void ipmi_cmdlang_entity_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_sensor_ptr_cb */
void ipmi_cmdlang_sensor_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_control_ptr_cb */
void ipmi_cmdlang_control_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_mc_ptr_cb */
void ipmi_cmdlang_mc_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_connection_ptr_cb */
void ipmi_cmdlang_connection_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_pet_ptr_cb */
void ipmi_cmdlang_pet_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_lanparm_ptr_cb */
void ipmi_cmdlang_lanparm_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_solparm_ptr_cb */
void ipmi_cmdlang_solparm_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_fru_ptr_cb */
void ipmi_cmdlang_fru_handler(ipmi_cmd_info_t *cmd_info);

/* ipmi_pef_ptr_cb */
void ipmi_cmdlang_pef_handler(ipmi_cmd_info_t *cmd_info);


/* All output from the command language is in name/value pairs.  The
   value field may be NULL. */
void ipmi_cmdlang_out(ipmi_cmd_info_t *info,
		      const char      *name,
		      const char      *value);
void ipmi_cmdlang_out_int(ipmi_cmd_info_t *info,
			  const char      *name,
			  int             value);
void ipmi_cmdlang_out_double(ipmi_cmd_info_t *info,
			     const char      *name,
			     double          value);
void ipmi_cmdlang_out_hex(ipmi_cmd_info_t *info,
			  const char      *name,
			  int             value);
void ipmi_cmdlang_out_long(ipmi_cmd_info_t *info,
			   const char      *name,
			   long            value);
void ipmi_cmdlang_out_binary(ipmi_cmd_info_t *info,
			     const char      *name,
			     const char      *value,
			     unsigned int    len);
void ipmi_cmdlang_out_unicode(ipmi_cmd_info_t *info,
			      const char      *name,
			      const char      *value,
			      unsigned int    len);
void ipmi_cmdlang_out_type(ipmi_cmd_info_t      *info,
			   char                 *name,
			   enum ipmi_str_type_e type,
			   const char           *value,
			   unsigned int         len);
void ipmi_cmdlang_out_ip(ipmi_cmd_info_t *info,
			 const char      *name,
			 struct in_addr  *ip_addr);
void ipmi_cmdlang_out_mac(ipmi_cmd_info_t *info,
			  const char      *name,
			  unsigned char   mac_addr[6]);
void ipmi_cmdlang_out_bool(ipmi_cmd_info_t *info,
			   const char      *name,
			   int             value);
void ipmi_cmdlang_out_time(ipmi_cmd_info_t *info,
			   const char      *name,
			   ipmi_time_t     value);
void ipmi_cmdlang_out_timeout(ipmi_cmd_info_t *info,
			      const char      *name,
			      ipmi_timeout_t  value);

/* Generate info for an event. */
void ipmi_cmdlang_event_out(ipmi_event_t    *event,
			    ipmi_cmd_info_t *cmd_info);

/* The output from the command language is done at a nesting level.
   When you start outputting data for a new thing, you should "down"
   to create a new nesting level.  When you are done, you should
   "up". */
void ipmi_cmdlang_down(ipmi_cmd_info_t *info);
void ipmi_cmdlang_up(ipmi_cmd_info_t *info);

/* A cmd info structure is refcounted, if you save a pointer to it you
   must "get" it.  When you are done, you must "put" it.  It will be
   destroyed (and the done routine called) after the last user puts it. */
void ipmi_cmdlang_cmd_info_get(ipmi_cmd_info_t *info);
void ipmi_cmdlang_cmd_info_put(ipmi_cmd_info_t *info);

/* Helper functions */
void ipmi_cmdlang_get_int(char *str, int *val, ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_double(char *str, double *val, ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_uchar(char *str, unsigned char *val,
			    ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_user(char *str, int *val, ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_time(char *str, ipmi_time_t *val, ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_timeout(char *str, ipmi_timeout_t *val,
			      ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_bool(char *str, int *val, ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_ip(char *str, struct in_addr *val,
			 ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_mac(char *str, unsigned char val[6],
			  ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_color(char *str, int *val, ipmi_cmd_info_t *info);
void ipmi_cmdlang_get_threshold_ev(char                        *str,
				   enum ipmi_thresh_e          *rthresh,
				   enum ipmi_event_value_dir_e *rvalue_dir,
				   enum ipmi_event_dir_e       *rdir,
				   ipmi_cmd_info_t             *info);
void ipmi_cmdlang_get_discrete_ev(char                  *str,
				  int                   *roffset,
				  enum ipmi_event_dir_e *rdir,
				  ipmi_cmd_info_t       *info);
void ipmi_cmdlang_get_threshold(char               *str,
				enum ipmi_thresh_e *rthresh,
				ipmi_cmd_info_t    *info);

/* Call these to initialize and setup the command interpreter.  init
   should be called after the IPMI library proper is initialized, but
   before using it. */
int ipmi_cmdlang_init(os_handler_t *os_hnd);
void ipmi_cmdlang_cleanup(void);


/* Allocate a cmd info structure that can be used to generate
   information to an event.  Make sure to call the put function when
   all the data has been output.  Note that the refcounts work like
   normal, you get it at one, when it goes to zero the structure will
   be returned. */
ipmi_cmd_info_t *ipmi_cmdlang_alloc_event_info(void);

typedef struct ipmi_cmdlang_event_s ipmi_cmdlang_event_t;

/* Move to the first field. */
void ipmi_cmdlang_event_restart(ipmi_cmdlang_event_t *event);

enum ipmi_cmdlang_out_types {
    IPMI_CMDLANG_STRING,
    IPMI_CMDLANG_BINARY,
    IPMI_CMDLANG_UNICODE
};

/* Returns true if successful, false if no more fields left. */
int ipmi_cmdlang_event_next_field(ipmi_cmdlang_event_t        *event,
				  unsigned int                *level,
				  enum ipmi_cmdlang_out_types *type,
				  char                        **name,
				  unsigned int                *len,
				  char                        **value);

/* Supplied by the user, used to report global errors (ones that don't
   deal with a specific command invocation).  The objstr is the name
   of the object dealing with the error (like the domain name, entity
   name, etc) or NULL if none.  The location is the file and procedure
   where the error occurred.  The errstr is a descriptive string and
   errval is an IPMI error value to be printed. */
void ipmi_cmdlang_global_err(char *objstr,
			     char *location,
			     char *errstr,
			     int  errval);

/* Supplied by the user to report events. */
void ipmi_cmdlang_report_event(ipmi_cmdlang_event_t *event);

/* In callbacks, you must use these to lock the cmd_info structure. */
void ipmi_cmdlang_lock(ipmi_cmd_info_t *info);
void ipmi_cmdlang_unlock(ipmi_cmd_info_t *info);

int ipmi_cmdlang_get_argc(ipmi_cmd_info_t *info);
char **ipmi_cmdlang_get_argv(ipmi_cmd_info_t *info);
int ipmi_cmdlang_get_curr_arg(ipmi_cmd_info_t *info);
ipmi_cmdlang_t *ipmi_cmdinfo_get_cmdlang(ipmi_cmd_info_t *info);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_CMDLANG_H */
