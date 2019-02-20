/*
 * persist.h
 *
 * MontaVista IPMI LAN server persistence tool
 *
 * Author: MontaVista Software, LLC.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2012 MontaVista Software LLC.
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

#ifndef __PERSIST_H__
#define __PERSIST_H__

typedef struct persist_s persist_t;

int persist_init(const char *app, const char *instance, const char *basedir);

persist_t *alloc_persist(const char *name, ...);
persist_t *read_persist(const char *name, ...);
int write_persist(persist_t *p);
int write_persist_file(persist_t *p, FILE *f);
void free_persist(persist_t *p);

int add_persist_data(persist_t *p, void *data, unsigned int len,
		     const char *name, ...);
int read_persist_data(persist_t *p, void **data, unsigned int *len,
		      const char *name, ...);
int add_persist_int(persist_t *p, long val, const char *name, ...);
int read_persist_int(persist_t *p, long *val, const char *name, ...);
int add_persist_str(persist_t *p, const char *val, const char *name, ...);
int read_persist_str(persist_t *p, char **val, const char *name, ...);

/*
 * Iterate over all the values in the persist.  Call the data function
 * for each data or string entry, and call the int function for each
 * integer.
 */
#define ITER_PERSIST_CONTINUE 0
#define ITER_PERSIST_STOP 1
int iterate_persist(persist_t *p,
		    void *cb_data,
		    int (*data_func)(const char *name,
				     void *data, unsigned int len,
				     void *cb_data),
		    int (*int_func)(const char *name,
				    long val, void *cb_data));

/* Free the values return by read_persist_data() and read_persist_str() */
void free_persist_data(void *data);
void free_persist_str(char *str);

/* Can be set to zero to disable persistence. */
extern int persist_enable;

#endif /* __PERSIST_H__ */
