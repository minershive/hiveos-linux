/*
 * ipmi_sdr.h
 *
 * MontaVista IPMI interface for SDRs
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

#ifndef OPENIPMI_SDR_H
#define OPENIPMI_SDR_H
#include <OpenIPMI/ipmi_types.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define MAX_SDR_DATA 255

/* Generic information about an SDR. */
typedef struct ipmi_sdr_s
{
    uint16_t record_id;
    uint8_t  major_version;
    uint8_t  minor_version;
    uint8_t  type;
    uint8_t  length;
    uint8_t  data[MAX_SDR_DATA];
} ipmi_sdr_t;

/* Opaque type representing a remote SDR repository. */
typedef struct ipmi_sdr_info_s ipmi_sdr_info_t;

/* Create a local representation of a remote SDR repository.  When
   created, it will not automatically fetch the remote SDRs, you need
   to do that.  If "sensor" is true, then this will fetch the "sensor"
   SDRs using GET DEVICE SDR.  If not, it will use GET SDR for
   fetching SDRs. */
int ipmi_sdr_info_alloc(ipmi_domain_t   *domain,
			ipmi_mc_t       *mc,
			unsigned int    lun,
			int             sensor,
			ipmi_sdr_info_t **new_sdrs);

/* Remove all the SDRs, but don't destroy the SDR repository. */
void ipmi_sdr_clean_out_sdrs(ipmi_sdr_info_t *sdrs);

/* Stop any timer operation; if the MC is in shutdown this should halt
   any running operations. */
void ipmi_sdr_cleanout_timer(ipmi_sdr_info_t *sdrs);

/* Destroy an SDR.  Note that if the SDR is currently fetching SDRs,
   the destroy cannot complete immediatly, it will be marked for
   destruction later.  You can supply a callback that, if not NULL,
   will be called when the sdr is destroyed. */
typedef void (*ipmi_sdr_destroyed_t)(ipmi_sdr_info_t *sdrs, void *cb_data);
int ipmi_sdr_info_destroy(ipmi_sdr_info_t      *sdrs,
			  ipmi_sdr_destroyed_t handler,
			  void                 *cb_data);

/* Fetch the remote SDRs, but do not wait until the fetch is complete,
   return immediately.  When the fetch is complete, call the given
   handler. */
typedef void (*ipmi_sdrs_fetched_t)(ipmi_sdr_info_t *sdrs,
				    int             err,
				    int             changed,
				    unsigned int    count,
				    void            *cb_data);
int ipmi_sdr_fetch(ipmi_sdr_info_t     *sdrs,
		   ipmi_sdrs_fetched_t handler,
		   void                *cb_data);

/* Return the number of SDRs in the sdr repository. */
int ipmi_get_sdr_count(ipmi_sdr_info_t *sdr,
		       unsigned int    *count);

/* Find the SDR with the given record id. */
int ipmi_get_sdr_by_recid(ipmi_sdr_info_t *sdr,
			  int             recid,
			  ipmi_sdr_t      *return_sdr);

/* Find the first SDR with the given type. */
int ipmi_get_sdr_by_type(ipmi_sdr_info_t *sdr,
			 int             type,
			 ipmi_sdr_t      *return_sdr);

/* Find the SDR with the given index. The indexes are the internal
   array indexes for the SDR, this can be used to iterate through the
   SDRs. */
int ipmi_get_sdr_by_index(ipmi_sdr_info_t *sdr,
			  int             index,
			  ipmi_sdr_t      *return_sdr);

/* Set an SDR's value.  This is primarily for the OEM SDR fixup code,
   so it can fix an SDR and write it back. */
int ipmi_set_sdr_by_index(ipmi_sdr_info_t *sdrs,
			  int             index,
			  ipmi_sdr_t      *sdr);

/* Fetch all the sdrs.  The array size should point to a value that
   holds the number of elements in the passed in array.  The
   array_size will be set to the actual number of elements put into
   the array.  If the number of SDRs is larger than the supplied
   array_size, this will return E2BIG and do nothing. */
int ipmi_get_all_sdrs(ipmi_sdr_info_t *sdr,
		      int             *array_size,
		      ipmi_sdr_t      *array);

/* Get various information from the IPMI SDR info commands. */
int ipmi_sdr_get_major_version(ipmi_sdr_info_t *sdr, int *val);
int ipmi_sdr_get_minor_version(ipmi_sdr_info_t *sdr, int *val);
int ipmi_sdr_get_overflow(ipmi_sdr_info_t *sdr, int *val);
int ipmi_sdr_get_update_mode(ipmi_sdr_info_t *sdr, int *val);
int ipmi_sdr_get_supports_delete_sdr(ipmi_sdr_info_t *sdr, int *val);
int ipmi_sdr_get_supports_partial_add_sdr(ipmi_sdr_info_t *sdr, int *val);
int ipmi_sdr_get_supports_reserve_sdr(ipmi_sdr_info_t *sdr, int *val);
int ipmi_sdr_get_supports_get_sdr_repository_allocation(ipmi_sdr_info_t *sdr,
							int             *val);
int ipmi_sdr_get_dynamic_population(ipmi_sdr_info_t *sdr, int *val);
int ipmi_sdr_get_lun_has_sensors(ipmi_sdr_info_t *sdr,
				 unsigned int    lun,
				 int             *val);

/* Append the SDR to the repository. */
int ipmi_sdr_add(ipmi_sdr_info_t *sdrs,
		 ipmi_sdr_t      *sdr);

/* Store the SDRs into the SDR repository. */
typedef void (*ipmi_sdr_save_cb)(ipmi_sdr_info_t *sdrs, int err, void *cb_data);
int ipmi_sdr_save(ipmi_sdr_info_t  *sdrs,
		  ipmi_sdr_save_cb done,
		  void             *cb_data);

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_SDR_H */
