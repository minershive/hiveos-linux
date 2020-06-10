#include "generic_common.h"
#include "generic_config.h"

__kernel void getconfig(__global config_t* conf)
{
        config_t c;
        c.N_ = N;
        c.SIZE_ = SIZE;
        c.STRIPES_ = STRIPES;
        c.WIDTH_ = WIDTH;
        c.PCOUNT_ = PCOUNT;
        c.TARGET_ = TARGET;
        c.LIMIT13_ = LIMIT13;
        c.LIMIT14_ = LIMIT14;
        c.LIMIT15_ = LIMIT15;
        c.GCN_ = 0;
        *conf = c;
}
