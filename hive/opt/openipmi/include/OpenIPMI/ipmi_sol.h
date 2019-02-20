/*
 * ipmi_sol.h
 *
 * IPMI Serial-over-LAN Client Code
 *
 * Author: Cyclades Australia Pty. Ltd.
 *         Darius Davis <darius.davis@cyclades.com>
 *
 * Copyright 2005 Cyclades Australia Pty. Ltd.
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

/**
 * @file include/OpenIPMI/ipmi_sol.h
 * Interface for OpenIPMI Serial-over-LAN support.
 * 
 * In keeping with the design of OpenIPMI, the SoL (Serial over LAN) API is
 * designed for asynchronous, event-based use.  Once you have an ipmi_con_t
 * representing a LAN-based connection to a BMC, you can pass that structure
 * to ipmi_sol_create to create an ipmi_sol_conn_t structure which will
 * represent the SoL connection.
 *
 * At this point, one registers callbacks for events as required (i.e. data
 * received, break received, connection state change), configures the bit rate,
 * authentication and encryption, then calls ipmi_sol_open.
 *
 * The client software can then call ipmi_write(...) to send data to the BMC,
 * and will receive data through the callback(s) that have been registered.
 *
 * When the connection is no longer required, the client is to call
 * ipmi_sol_close, which closes the SoL connection.  ipmi_sol_free is then
 * used to dispose of the connection structure if it is no longer required.
 *
 * SoL supports a number of nonvolatile configuration parameters.  These
 * parameters are supported through a series of functions to set the
 * default bit rate, required levels of permission, authentication and
 * encryption, as well as flow-control parameters (Character Accumulate
 * Interval and Character Send Threshold) and retry parameters (Retry
 * Count and Retry Interval).  These functions are a part of the separate
 * ipmi_sol_config interface. (YET TO BE IMPLEMENTED)
 *
 *
 * Reference:
 *  [1] "IPMI - Intelligent Platform Management Interface Specification
 *	Second Generation v2.0", Document Revision 1.0, February 12, 2004,
 *	with June 1, 2004 Markup.  Accessed at:
 *    ftp://download.intel.com/design/servers/ipmi/IPMIv2_0rev1_0markup.pdf
 *
 * For configuration of SoL parameters, refer to:
 *	include/OpenIPMI/include/ipmi_sol.h
 */

#ifndef OPENIPMI_SOL_H
#define OPENIPMI_SOL_H

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Queue identification constants for ipmi_sol_flush(...).
 */
#define IPMI_SOL_BMC_TRANSMIT_QUEUE                0x01
#define IPMI_SOL_BMC_RECEIVE_QUEUE                 0x02
#define IPMI_SOL_MANAGEMENT_CONSOLE_TRANSMIT_QUEUE 0x04
#define IPMI_SOL_MANAGEMENT_CONSOLE_RECEIVE_QUEUE  0x08

#define IPMI_SOL_BMC_QUEUES (IPMI_SOL_BMC_TRANSMIT_QUEUE \
			     | IPMI_SOL_BMC_RECEIVE_QUEUE)

#define IPMI_SOL_MANAGEMENT_CONSOLE_QUEUES \
	(IPMI_SOL_MANAGEMENT_CONSOLE_TRANSMIT_QUEUE \
	 | IPMI_SOL_MANAGEMENT_CONSOLE_RECEIVE_QUEUE)

#define IPMI_SOL_ALL_QUEUES (IPMI_SOL_BMC_QUEUES \
			     | IPMI_SOL_MANAGEMENT_CONSOLE_QUEUES)


/**
 * Bit rate constants (almost the same as baud rates)
 */
#define IPMI_SOL_BIT_RATE_DEFAULT		0x00
#define IPMI_SOL_BIT_RATE_9600			0x06
#define IPMI_SOL_BIT_RATE_19200			0x07
#define IPMI_SOL_BIT_RATE_38400			0x08
#define IPMI_SOL_BIT_RATE_57600			0x09
#define IPMI_SOL_BIT_RATE_115200		0x0a


/**
 * The possible states of a SoL connection object.
 */
typedef enum
{
    /* The connection is closed; no data transfer is possible. */
    ipmi_sol_state_closed,

    /* The connection is currently starting up; no data transfer yet. */
    ipmi_sol_state_connecting,

    /* The connection is up and operational. */
    ipmi_sol_state_connected,

    /* The connection is up, but the BMC has reported Character
       Transfer Unavailable.  This means the BMC is flow-controlling
       us. */
    ipmi_sol_state_connected_ctu,

    /* The connection is going down.  No data transfer. */
    ipmi_sol_state_closing
} ipmi_sol_state;


/**
 * Values to specify serial alert behavior while SoL is activated.
 */
typedef enum
{
    ipmi_sol_serial_alerts_fail = 0,
    ipmi_sol_serial_alerts_deferred = 1,
    ipmi_sol_serial_alerts_succeed = 2
} ipmi_sol_serial_alert_behavior;


/**
 * Opaque data structure representing an IPMI SoL connection.
 */
typedef struct ipmi_sol_conn_s ipmi_sol_conn_t;


/**
 * IPMI SoL callbacks
 */

/**
 * This callback is used to indicate a change in the state of a connection.
 *
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] state	Identifies the state of the SoL connection.
 * @param [in] error	A value indicating the circumstances causing the change.
 *	- zero: The state change was due to a request from the client library.
 *	- IPMI_SOL_DISCONNECTED: The state change was due to the loss of a
 *		connection to the managed system.
 *	- IPMI_SOL_NOT_AVAILABLE: This indicates that the management console
 *		responded inappropriately while the library was trying to
 *		connect to SoL on the BMC, so the connection attempt has been
 *		abandoned.  Only given on a transition from ipmi_sol_state_connecting
 *		to ipmi_sol_state_closed.
 *	- IPMI_RMCPP_INVALID_PAYLOAD_TYPE: The remote indicates that it can not
 *		support a compatible version of the SoL payload.  This error
 *		will only be given on a transition from ipmi_sol_state_connecting
 *		to ipmi_sol_state_closed.
 *	- IPMI_SOL_DEACTIVATED: The change is because SoL has been deactivated on the
 *		managed system.
 *	- Another error code from IPMI or the Operating System.
 * @param [in] cb_data	The user-defined value provided when registering
 *			for the callback.
 */
typedef void (*ipmi_sol_connection_state_cb)(ipmi_sol_conn_t *conn,
					     ipmi_sol_state  state,
					     int             error,
					     void            *cb_data);


/**
 * This callback is called for each write request or control-line status
 * request.
 *
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] error	The result of the transmit operation:
 *	- zero: The request has been ACKed and was successful.
 *	- IPMI_SOL_DISCONNECTED: A packet has failed to be delivered
 *		after the configured number of retries.  The connection is lost
 *		and the request is discarded.
 *	- IPMI_SOL_CHARACTER_TRANSFER_UNAVAIL: The managed system is powered down
 *		or is otherwise unable to accept a character transfer.
 *	- IPMI_SOL_DEACTIVATED: The BMC has lost the serial connection
 *		due to intervention at the managed system.
 *	- IPMI_SOL_UNCONFIRMABLE_OPERATION: The request has been transmitted to
 *		the managed system, but the managed system is not expected
 *		acknowledge receipt.
 *	- Another error code (i.e. ENOMEM) to indicate another type of failure.
 * @param [in] cb_data	The user-defined value provided when registering
 *			for the callback.
 */
typedef void (*ipmi_sol_transmit_complete_cb)(ipmi_sol_conn_t *conn,
					      int             error,
					      void            *cb_data);


/**
 * This callback is called asynchronously when characters have been received
 * from the remote.
 *
 * This callback is registered using
 * ipmi_register_data_received_callback.  The recipient of this
 * callback has the opportunity to refuse (NACK) the data by returning
 * a nonzero value; conversely, it should return zero if the packet
 * contents have been accepted.  Note that if a NACK is returned, the
 * BMC will hold packets until ipmi_sol_release_nack() is called or
 * a flush is done.
 *
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] buf	A pointer to the character data.
 * @param [in] count	The number of characters in the buffer.
 * @param [in] cb_data	The user-defined value provided when registering
 *			for the callback.
 * @return	Zero if the data is accepted, nonzero if the data should be
 *		NACKed.
 */
typedef int (*ipmi_sol_data_received_cb)(ipmi_sol_conn_t *conn,
					 const void      *buf,
					 size_t          count,
					 void            *cb_data);


/**
 * This callback will be called upon the successful completion of a flush 
 * operation, or upon the determination of an error condition during the
 * flush operation.
 *
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] error	The result of the flush operation:
 *	- zero: The flush operation completed successfully.
 *	- IPMI_SOL_DISCONNECTED: A packet has failed to be delivered
 *		after the configured number of retries.  The connection is lost.
 *	- IPMI_SOL_DEACTIVATED: The BMC has lost the serial connection
 *		due to intervention at the managed system.
 *	- IPMI_SOL_UNCONFIRMABLE_OPERATION: The data has been transmitted to the
 *		managed system, the managed system can not be expected confirm
 *		receipt.
 * @param [in] queue_selectors_flushed	A bit mask indicating which queues
 *			were successfully flushed.
 * @param [in] cb_data	The user-defined value provided when registering
 *			for the callback.
 */
typedef void (*ipmi_sol_flush_complete_cb)(ipmi_sol_conn_t *conn,
					   int             error,
					   int         queue_selectors_flushed,
					   void            *cb_data);


/**
 * This callback is called asynchronously when the remote indicates it has 
 * detected a serial "break".
 *
 * This callback is registered using ipmi_register_break_detected_callback.
 *
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] cb_data	The user-defined value provided when registering
 *			for the callback.
 */
typedef void (*ipmi_sol_break_detected_cb)(ipmi_sol_conn_t *conn,
					   void            *cb_data);


/**
 * This callback is called asynchronously when the remote BMC indicates that
 * it has encountered a transmitter overrun.  Some incoming data may have
 * been lost.
 *
 * This callback is registered using ipmi_register_bmc_transmit_overrun_callback.
 *
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] cb_data	The user-defined value provided when registering
 *			for the callback.
 */
typedef void (*ipmi_sol_bmc_transmit_overrun_cb)(ipmi_sol_conn_t *conn,
						 void            *cb_data);


/**
 * Constructs a handle for managing an SoL session.
 *
 * This function does NOT communicate with the BMC or activate the SoL payload.
 *
 * @param [in] ipmi	the existing IPMI over LAN session.
 * @param [out] sol_conn	the address into which to store the allocated
 *				IPMI SoL connection structure.
 * @return	zero on success, or ENOMEM if memory allocation fails.
 */
int ipmi_sol_create(ipmi_con_t      *ipmi,
		    ipmi_sol_conn_t **sol_conn);



/**************************************************************************
 ** IPMI SoL connection configuration
 **/


/**
 * Register for callbacks.  For each of the following eight functions, the 
 * parameters are as follows:
 *
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] cb	The callback to register.
 * @param [in] cb_data	The user-defined data to pass to the callback.
 * @return Zero on success, or a nonzero error code.
 */
int ipmi_sol_register_connection_state_callback(ipmi_sol_conn_t *conn,
					       ipmi_sol_connection_state_cb cb,
						void            *cb_data);
int ipmi_sol_deregister_connection_state_callback(ipmi_sol_conn_t *conn,
					       ipmi_sol_connection_state_cb cb,
						  void *cb_data);

int ipmi_sol_register_data_received_callback(ipmi_sol_conn_t *conn,
					     ipmi_sol_data_received_cb cb,
					     void            *cb_data);
int ipmi_sol_deregister_data_received_callback(ipmi_sol_conn_t *conn,
					       ipmi_sol_data_received_cb cb,
					       void            *cb_data);

int ipmi_sol_register_break_detected_callback(ipmi_sol_conn_t *conn,
					      ipmi_sol_break_detected_cb cb,
					      void            *cb_data);
int ipmi_sol_deregister_break_detected_callback(ipmi_sol_conn_t *conn,
						ipmi_sol_break_detected_cb cb,
						void            *cb_data);

int ipmi_sol_register_bmc_transmit_overrun_callback(ipmi_sol_conn_t *conn,
					   ipmi_sol_bmc_transmit_overrun_cb cb,
						    void            *cb_data);
int ipmi_sol_deregister_bmc_transmit_overrun_callback(ipmi_sol_conn_t *conn,
					   ipmi_sol_bmc_transmit_overrun_cb cb,
						      void           *cb_data);


/**
 * Set the timeout to wait for an ACK from the BMC (for packets that expect an
 * ACK).
 *
 * @param [in] conn	The IPMI SoL connection to configure.
 * @param [in] timeout_usec	The timeout, in microseconds.
 */
void ipmi_sol_set_ACK_timeout(ipmi_sol_conn_t *conn, int timeout_usec);

/**
 * Get the timeout to wait for an ACK from the BMC (for packets that expect an
 * ACK).
 *
 * @param [in] conn	The IPMI SoL connection to configure.
 *
 * @return	The timeout
 */
int ipmi_sol_get_ACK_timeout(ipmi_sol_conn_t *conn);


/**
 * Set the number of retries that we make before declaring a packet "lost".
 *
 * @param [in] conn	The IPMI SoL connection to configure.
 * @param [in] retries	The number of retries before a packet is declared lost.
 */
void ipmi_sol_set_ACK_retries(ipmi_sol_conn_t *conn, int retries);

/**
 * Get the number of retries that we make before declaring a packet "lost".
 *
 * @param [in] conn	The IPMI SoL connection to configure.
 *
 * @return	The number of retries
 */
int ipmi_sol_get_ACK_retries(ipmi_sol_conn_t *conn);

/**
 * Configure the authentication to use for the SoL packets.
 *
 * @param [in] conn	The IPMI SoL connection to configure.
 * @param [in] use_authentication	Nonzero to use authentication for the
 * 					SoL packets.
 * @return	Zero on success, otherwise an error code.
 */
int ipmi_sol_set_use_authentication(ipmi_sol_conn_t *conn,
				    int             use_authentication);

/**
 * Query the authentication configuration for the SoL packets.
 *
 * @param [in] conn	The IPMI SoL connection to query.
 * @return	Nonzero iff the connection will attempt to use authentication
 *		for SoL packets.
 */
int ipmi_sol_get_use_authentication(ipmi_sol_conn_t *conn);


/**
 * Configure the encryption to use for the SoL packets.
 * 
 * @param [in] conn	The IPMI SoL connection to configure.
 * @param [in] use_encryption	Nonzero to use encryption for the
 *				SoL packets.
 * @return	Zero on success, otherwise an error code.
 */
int ipmi_sol_set_use_encryption(ipmi_sol_conn_t *conn, int use_encryption);

/**
 * Query the encryption configuration for the SoL packets.
 *
 * @param [in] conn	The IPMI SoL connection to query.
 * @return	Nonzero iff the connection will attempt to use encryption
 *		for SoL packets.
 */
int ipmi_sol_get_use_encryption(ipmi_sol_conn_t *conn);


/**
 * Configure the shared serial alert behavior for the SoL connection.
 * 
 * @param [in] conn	The IPMI SoL connection to configure.
 * @param [in] behavior	A constant identifying the desired shared serial alert
 *			behavior during the SoL connection.
 * @return	Zero on success, otherwise an error code.
 */
int ipmi_sol_set_shared_serial_alert_behavior(ipmi_sol_conn_t *conn,
				      ipmi_sol_serial_alert_behavior behavior);

/**
 * Query the shared serial alerts behavior configuration for the SoL connection.
 *
 * @param [in] conn	The IPMI SoL connection to query.
 * @return	A value identifying the shared serial alert behavior that
 *		will be in force during the connection.
 */
ipmi_sol_serial_alert_behavior ipmi_sol_get_shared_serial_alert_behavior
						      (ipmi_sol_conn_t *conn);


/**
 * Configure the CTS, DCD and DSR deassert-on-connect behavior to use for
 * the SoL connection.
 * 
 * @param [in] conn	The IPMI SoL connection to configure.
 * @param [in] assert	Nonzero to deassert the handshaking signals at the
 * 			start of the SoL connection.
 * @return	Zero on success, otherwise an error code.
 */
int ipmi_sol_set_deassert_CTS_DCD_DSR_on_connect(ipmi_sol_conn_t *conn,
						 int             assert);

/**
 * Query the CTS, DCD and DSR deassert-on-connect configuration for the 
 * SoL connection.
 *
 * @param [in] conn	The IPMI SoL connection to query.
 * @return	Nonzero iff the connection will deassert CTS, DCD and DSR upon
 *		connection.
 */
int ipmi_sol_get_deassert_CTS_DCD_DSR_on_connect(ipmi_sol_conn_t *conn);


/**
 * Configure the bit rate to use on connection.
 *
 * @param [in] conn	The IPMI SoL connection to configure.
 * @param [in] rate	The bit rate constant (IPMI_SOL_BIT_RATE_xxxxx)
 * @return	Zero on success, otherwise an error code.
 */
int ipmi_sol_set_bit_rate(ipmi_sol_conn_t *conn, unsigned char rate);


/**
 * Query the bit rate to be used upon connection.
 *
 * @param [in] conn	The IPMI SoL connection to query.
 * @return		The bit rate that will be used (IPMI_SOL_BIT_RATE_xxxxx)
 */
unsigned char ipmi_sol_get_bit_rate(ipmi_sol_conn_t *conn);


/**
 * Opens the SoL connection using the previously set nonvolatile and
 * volatile parameters.
 *
 * This contacts the BMC and checks that we share a compatible revision of
 * SoL, and that this connection has the privileges to activate SoL.  If this
 * function returns an ERROR, the callback will never be called.  If it returns
 * no error, the callback WILL be called, indicating whether the connection was
 * successful or not.
 *
 * @param [in] conn	The IPMI SoL connection handle from ipmi_sol_create.
 * @param [in] cb	The callback to use to indicate success or failure
 *			of the operation.  This is only used if ipmi_sol_open
 *			returns zero.
 * @param [in] cb_data	User-defined data to pass to the callback.
 *
 * @return	Zero on success.
 *		EINVAL if this handle is already connected.
 *		A nonzero IPMI error code on other failure.
 */
int ipmi_sol_open(ipmi_sol_conn_t *conn);


/**
 * Requests the closure of the SoL session.
 *
 * Closing the SoL session also restores the baseboard serial mux to its
 * initial state.
 * 
 * @param [in] conn	The IPMI SoL connection to close.
 * @return	Zero on success.
 *		EINVAL if this handle was already closing or closed.  If the
 * 			handle is closing, consider using ipmi_sol_force_close
 *			to hurry it along.
 *		A nonzero error code on other failure.
 */
int ipmi_sol_close(ipmi_sol_conn_t *conn);

/**
 * Requests the closure of the SoL session.
 *
 * Closing the SoL session also restores the baseboard serial mux to its
 * initial state.
 *
 * @param [in] conn	The IPMI SoL connection to close.
 * @param [in] rem_close Nonzero if the connection should send a close to
 *			the remote end.  If false, don't inform the remote
 *			end of the close.
 * @return	Zero on success.
 *		EINVAL if this handle was already closing or closed.  If the
 * 			handle is closing, consider using ipmi_sol_force_close
 *			to hurry it along.
 *		A nonzero error code on other failure.
 */
int ipmi_sol_force_close_wsend(ipmi_sol_conn_t *conn, int rem_close);

/**
 * Forces the closure of the SoL session.
 *
 * The BMC is notified that the connection will should close, but no attempt
 * is made to wait for a response from the BMC.  Otherwise, this function does
 * purely local cleanup of outstanding transmit callbacks and connection-
 * oriented memory allocations.
 * 
 * @param [in] conn	The IPMI SoL connection to close.
 * @return	Zero on success.
 *		EINVAL if this handle was already closed.
 *		A nonzero IPMI error code on other failure.
 */
int ipmi_sol_force_close(ipmi_sol_conn_t *conn);


/**
 * Frees the memory used by the SoL connection structure.  No callbacks will
 * occur after this function is called.  The connection will be forced closed
 * if it was still open when the function was called.
 * 
 * @param [in] conn	The IPMI SoL connection to release.
 * @return	Zero on success, or a nonzero IPMI error code on failure.
 */
int ipmi_sol_free(ipmi_sol_conn_t *conn);



/******************************************************************************
 ** IPMI SoL write operations (and sundry operations that cause a transmit)
 **/
 
/**
 * Send a sequence of bytes to the remote.
 *
 * This function (like all the others!) will either return an ERROR and
 * never call the callback, or will return success and then WILL call
 * the callback, indicating an error later if necessary. The callback is
 * an indication that the BMC has ACKed *all* of the bytes in this request.
 * There is no guarantee that the packet will not be fragmented or
 * coalesced in transmission.
 *
 * @param [in] conn	The IPMI SoL connection over which to transmit.
 * @param [in] buf	A pointer to the data to transmit.
 * @param [in] count	The nonzero number of bytes to send.
 * @param [in] cb	The callback to call when the transmission is complete.
 *			This callback will only be called if this function call
 *			returns zero.
 * @param [in] cb_data	User-defined data to pass to the callback.
 * @return	Zero on success
 *		EINVAL	if a request is made to transmit zero bytes
 *		or a nonzero IPMI error code on failure.
 */
int ipmi_sol_write(ipmi_sol_conn_t *conn,
		   const void      *buf,
		   int             count,
		   ipmi_sol_transmit_complete_cb cb,
		   void            *cb_data);


/**
 * Release a NACK
 *
 * This function will release a NACK returned by the receive routine.
 * For every NACK a receive routine returns, this must be called to
 * reactivate receiving packets from the BMC.
 *
 * @param [in] conn	The IPMI SoL connection over which to transmit.
 * @return	Zero on success
 *		EINVAL	No NACK is pending.
 */
int ipmi_sol_release_nack(ipmi_sol_conn_t *conn);


/**
 * Request that the BMC send a serial "break" to the managed system.
 *
 * @param [in] conn	The IPMI SoL connection over which to transmit.
 * @param [in] cb	The callback to call when the transmission is complete.
 *			This callback will only be called if this function call
 *			returns zero.
 * @param [in] cb_data	User-defined data to pass to the callback.
 * @return	Zero on success, or a nonzero IPMI error code on failure.
 *		Callback is likely to receive IPMI_SOL_UNCONFIRMABLE_OPERATION
 *		because the BMC will not bother to acknowledge the receipt of
 *		this request unless it is sent at the same time as a block of
 * 		data.
 */
int ipmi_sol_send_break(ipmi_sol_conn_t *conn,
			ipmi_sol_transmit_complete_cb cb,
			void            *cb_data);


/**
 * Controls CTS at the BMC, to request that the system attached to the BMC
 * ceases transmitting characters. No guarantee is given that the BMC and/or
 * baseboard will honour this request. Further buffered characters might still
 * be received after CTS is deasserted.
 *
 * Choosing to "deassert" CTS here really puts CTS under the control of the BMC
 * for its own flow control.
 * 
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] assertable	Nonzero puts the CTS signal in the control of
 *				the BMC.  Zero prevents the BMC from asserting
 *				the CTS signal.
 * @param [in] cb	The callback to call when the operation is complete.
 *			This callback will only be called if this function call
 *			returns zero.
 * @param [in] cb_data	User-defined data to pass to the callback.
 * @return	Zero on success, or a nonzero IPMI error code on failure.
 *		Callback is likely to receive IPMI_SOL_UNCONFIRMABLE_OPERATION
 *		because the BMC will not bother to acknowledge the receipt of
 *		this request unless it is sent at the same time as a block of
 * 		data.
 */
int ipmi_sol_set_CTS_assertable(ipmi_sol_conn_t *conn,
				int             asserted,
				ipmi_sol_transmit_complete_cb cb,
				void            *cb_data);


/**
 * Asserts DCD and DSR at the BMC, as if we've answered the phone line.
 * 
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] asserted	Nonzero if DCD and DSR should be asserted.
 * @param [in] cb	The callback to call when the operation is complete.
 *			This callback will only be called if this function call
 *			returns zero.
 * @param [in] cb_data	User-defined data to pass to the callback.
 * @return	Zero on success, or a nonzero IPMI error code on failure.
 *		Callback is likely to receive IPMI_SOL_UNCONFIRMABLE_OPERATION
 *		because the BMC will not bother to acknowledge the receipt of
 *		this request unless it is sent at the same time as a block of
 * 		data.
 */
int ipmi_sol_set_DCD_DSR_asserted(ipmi_sol_conn_t *conn,
				  int             asserted,
				  ipmi_sol_transmit_complete_cb cb,
				  void            *cb_data);


/**
 * Asserts RI, as if the phone line is ringing.
 *
 * The stated aim of this operation is to allow use of the Wake-on-Ring feature
 * to power-up and gain the attention of a system.
 * 
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] asserted	Nonzero if RI should be asserted by the BMC.
 * @param [in] cb	The callback to call when the operation is complete.
 *			This callback will only be called if this function call
 *			returns zero.
 * @param [in] cb_data	User-defined data to pass to the callback.
 * @return	Zero on success, or a nonzero IPMI error code on failure.
 *		Callback is likely to receive IPMI_SOL_UNCONFIRMABLE_OPERATION
 *		because the BMC will not bother to acknowledge the receipt of
 *		this request unless it is sent at the same time as a block of
 * 		data.
 */
int ipmi_sol_set_RI_asserted(ipmi_sol_conn_t *conn,
			     int             asserted,
			     ipmi_sol_transmit_complete_cb cb,
			     void            *cb_data);


/**
 * Requests a flush of the transmit queue(s) identified by queue_selector.
 * 
 * If no error is returned, the callback will be called in a synchronous
 * manner if the flush does not involve the BMC, asynchronous if it does.
 *
 * @param [in] conn	The IPMI SoL connection.
 * @param [in] queue_selectors	 Identifies the queues to flush.  This is
 *				specified as a bitwise-OR of the following:
 *
 *			- IPMI_SOL_BMC_TRANSMIT_QUEUE
 *			- IPMI_SOL_BMC_RECEIVE_QUEUE
 *			- IPMI_SOL_MANAGEMENT_CONSOLE_TRANSMIT_QUEUE
 *			- IPMI_SOL_MANAGEMENT_CONSOLE_RECEIVE_QUEUE
 *
 *			or use IPMI_SOL_ALL_QUEUES, IPMI_SOL_BMC_QUEUES or
 *			IPMI_SOL_MANAGEMENT_CONSOLE_QUEUES
 *
 * @param [in] cb	The callback to call when the operation is complete.
 *			This callback will only be called if this function call
 *			returns zero.
 * @param [in] cb_data	User-defined data to pass to the callback.
 * @return	Zero on success, or a nonzero IPMI error code on failure.
 *		Callback is likely to receive IPMI_SOL_UNCONFIRMABLE_OPERATION
 *		because the BMC will not bother to acknowledge the receipt of
 *		this request unless it is sent at the same time as a block of
 * 		data.
 */
int ipmi_sol_flush(ipmi_sol_conn_t *conn,
		   int             queue_selectors,
		   ipmi_sol_flush_complete_cb cb,
		   void            *cb_data);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_SOL_H */
