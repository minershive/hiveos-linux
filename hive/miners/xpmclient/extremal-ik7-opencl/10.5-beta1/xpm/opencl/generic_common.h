#ifndef __CLCOMMON_H_
#define __CLCOMMON_H_

typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
typedef unsigned long uint64_t;

typedef struct {
  uint index;
  uint hashid;
  uchar origin;
  uchar chainpos;
  uchar type;
  uchar reserved;
} fermat_t;


typedef struct {
  uint N_;
  uint SIZE_;
  uint STRIPES_;
  uint WIDTH_;
  uint PCOUNT_;
  uint TARGET_;
  uint LIMIT13_;
  uint LIMIT14_;
  uint LIMIT15_;
  uint GCN_;
} config_t;

#define N 12

#if defined(__gfx900__) ||\
    defined(__gfx901__) ||\
    defined(__gfx902__) ||\
    defined(__gfx903__) ||\
    defined(__gfx904__) ||\
    defined(__gfx905__) ||\
    defined(__gfx906__) ||\
    defined(__gfx907__)
#define __AMDVEGA
#endif

#define MulOpsNum 512

void sub(uint32_t *a, const uint32_t *b, int size)
{
  uint32_t A[2];
  A[0] = a[0];
  a[0] -= b[0];
#pragma unroll
  for (int i = 1; i < size; i++) {
    A[1] = a[i];
    a[i] -= b[i] + (a[i-1] > A[0]);
    A[0] = A[1];
  }
}

#endif //__CLCOMMON_H_
