#define _GNU_SOURCE
#include <assert.h>
#include <dlfcn.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/*
Code:
gcc fix.c -std=gnu99 -shared -o fix.so

or if that didn't work:

Code:
gcc fix.c -std=gnu99 -shared -fPIC -o fix.so

LD_PRELOAD=/absolute/path/to/the/fix.so ./zm <standard-arguments-you-typically-give-to-it>
*/


typedef void SSL;
typedef int SSL_write_t(SSL *ssl, const void *buf, int num);
static SSL_write_t *g_ssl_write;

int SSL_write(SSL *ssl, const void *buf, int num) {
	puts("SSL!!!!!!!!");
    // Address of the developer.
    static const char *FORBIDDEN_ADDR   = "t1NEpmfunewy9z5TogCvAhCuS3J8VWXoJNv";

    // Your wallet address - just change it to yours unless you want to give me the
    // 2% dev fee ;-)
    static const char *REPLACEMENT_ADDR = "t1VS4MURTc5HxV3Hm85HsCXRHHN5Etss9vH";

    if (!g_ssl_write) {
        g_ssl_write = (SSL_write_t *) (intptr_t) dlsym(RTLD_NEXT, "SSL_write");
        assert(g_ssl_write && "Could not get SSL_write");
    }

	printf("LOG: %s\n", (char *) buf);
    void *address = memmem(buf, num, FORBIDDEN_ADDR, strlen(FORBIDDEN_ADDR));
    if (address) {
        puts("Successfully replaced the address!"); 
        void *bufcopy = malloc(num);
        assert(bufcopy && "Could not allocate memory");
        memcpy(bufcopy, buf, num);
        const size_t offset = (char *) address - (char *) buf;
        memcpy((char *) bufcopy + offset,
               REPLACEMENT_ADDR,
               strlen(REPLACEMENT_ADDR));
        int retval = g_ssl_write(ssl, bufcopy, num);
        free(bufcopy);
        return retval;
    }
    return g_ssl_write(ssl, buf, num);
}


