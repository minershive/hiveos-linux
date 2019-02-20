/* ipmi_string.h - IPMI string handling
 * Copyright (C) 2012 MontaVista Software.
 * Corey Minyard <cminyard@mvista.com>
 *
 * This file is part of the IPMI Interface (IPMIIF).
 *
 * This is for handling strings in SDRs and FRU data.
 *
 * This software is available to you under a choice of one of two
 * licenses.  You may choose to be licensed under the terms of the GNU
 * Lesser General Public License (GPL) Version 2 or the modified BSD
 * license below.  The following disclamer applies to both licenses:
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
 * GNU Lesser General Public Licence
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this program; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * Modified BSD Licence
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above
 *      copyright notice, this list of conditions and the following
 *      disclaimer in the documentation and/or other materials provided
 *      with the distribution.
 *   3. The name of the author may not be used to endorse or promote
 *      products derived from this software without specific prior
 *      written permission.
 */

#ifndef OPENIPMI_STRING_H
#define OPENIPMI_STRING_H

#include <OpenIPMI/ipmi_bits.h>

/* If we have a 6-bit field, we can have up to 63 items, and with BCD
   there may be 2 characters per byte, so 126 max. */
#define IPMI_MAX_STR_LEN 126

/* Fetch an IPMI device string as defined in section 37.14 of the IPMI
   version 1.5 manual.  The in_len is the number of input bytes in the
   string, including the type/length byte.  It may be longer than the
   actual length.  The max_out_len is the maximum number of characters
   to output, including the nil.  The type will be set to either
   unicode or ASCII.  The number of bytes put into the output string
   is returned in out_len.  The input pointer will be updated to point
   to the character after the used data.  This returns a standard
   error value. */
#define IPMI_STR_SDR_SEMANTICS	0
#define IPMI_STR_FRU_SEMANTICS	1
int ipmi_get_device_string(unsigned char        **input,
			   unsigned int         in_len,
			   char                 *output,
			   int                  semantics,
			   int                  force_unicode,
			   enum ipmi_str_type_e *type,
			   unsigned int         max_out_len,
			   unsigned int         *out_len);

/* Store an IPMI device string in the most compact form possible.
   input is the input string (nil terminated), output is where to
   place the output (including the type/length byte) and out_len is a
   pointer to the max size of output (including the type/length byte).
   Upon return, out_len will be set to the actual output length. */
void ipmi_set_device_string(const char           *input,
			    enum ipmi_str_type_e type,
			    unsigned int         in_len,
			    unsigned char        *output,
			    int                  force_unicode,
			    unsigned int         *out_len);

/* Like ipmi_set_device_string, but include options.  See ipmi_bits.h
   for IPMI_STRING_OPTION_xxx. */
void ipmi_set_device_string2(const char           *input,
			     enum ipmi_str_type_e type,
			     unsigned int         in_len,
			     unsigned char        *output,
			     int                  force_unicode,
			     unsigned int         *out_len,
			     unsigned int         options);

#endif /* OPENIPMI_STRING_H */
