typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
typedef unsigned long uint64_t;
 
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

// Generated for AMD OpenCL compiler, do not edit!

void monSqr320(uint32_t *op, uint32_t *mod, uint32_t invm)
{
  uint32_t invValue[10];
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op[0]*op[0];
    accHi += mul_hi(op[0], op[0]);
    invValue[0] = invm * (uint32_t)accLow;
    accLow += invValue[0]*mod[0];
    accHi += mul_hi(invValue[0], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[1];
    uint32_t hi0 = mul_hi(op[0], op[1]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += invValue[0]*mod[1];
    accHi += mul_hi(invValue[0], mod[1]);
    invValue[1] = invm * (uint32_t)accLow;
    accLow += invValue[1]*mod[0];
    accHi += mul_hi(invValue[1], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[2];
    uint32_t hi0 = mul_hi(op[0], op[2]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += op[1]*op[1];
    accHi += mul_hi(op[1], op[1]);
    accLow += invValue[0]*mod[2];
    accHi += mul_hi(invValue[0], mod[2]);
    accLow += invValue[1]*mod[1];
    accHi += mul_hi(invValue[1], mod[1]);
    invValue[2] = invm * (uint32_t)accLow;
    accLow += invValue[2]*mod[0];
    accHi += mul_hi(invValue[2], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[3];
    uint32_t hi0 = mul_hi(op[0], op[3]);
    uint32_t low1 = op[1]*op[2];
    uint32_t hi1 = mul_hi(op[1], op[2]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += invValue[0]*mod[3];
    accHi += mul_hi(invValue[0], mod[3]);
    accLow += invValue[1]*mod[2];
    accHi += mul_hi(invValue[1], mod[2]);
    accLow += invValue[2]*mod[1];
    accHi += mul_hi(invValue[2], mod[1]);
    invValue[3] = invm * (uint32_t)accLow;
    accLow += invValue[3]*mod[0];
    accHi += mul_hi(invValue[3], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[4];
    uint32_t hi0 = mul_hi(op[0], op[4]);
    uint32_t low1 = op[1]*op[3];
    uint32_t hi1 = mul_hi(op[1], op[3]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += op[2]*op[2];
    accHi += mul_hi(op[2], op[2]);
    accLow += invValue[0]*mod[4];
    accHi += mul_hi(invValue[0], mod[4]);
    accLow += invValue[1]*mod[3];
    accHi += mul_hi(invValue[1], mod[3]);
    accLow += invValue[2]*mod[2];
    accHi += mul_hi(invValue[2], mod[2]);
    accLow += invValue[3]*mod[1];
    accHi += mul_hi(invValue[3], mod[1]);
    invValue[4] = invm * (uint32_t)accLow;
    accLow += invValue[4]*mod[0];
    accHi += mul_hi(invValue[4], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[5];
    uint32_t hi0 = mul_hi(op[0], op[5]);
    uint32_t low1 = op[1]*op[4];
    uint32_t hi1 = mul_hi(op[1], op[4]);
    uint32_t low2 = op[2]*op[3];
    uint32_t hi2 = mul_hi(op[2], op[3]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += invValue[0]*mod[5];
    accHi += mul_hi(invValue[0], mod[5]);
    accLow += invValue[1]*mod[4];
    accHi += mul_hi(invValue[1], mod[4]);
    accLow += invValue[2]*mod[3];
    accHi += mul_hi(invValue[2], mod[3]);
    accLow += invValue[3]*mod[2];
    accHi += mul_hi(invValue[3], mod[2]);
    accLow += invValue[4]*mod[1];
    accHi += mul_hi(invValue[4], mod[1]);
    invValue[5] = invm * (uint32_t)accLow;
    accLow += invValue[5]*mod[0];
    accHi += mul_hi(invValue[5], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[6];
    uint32_t hi0 = mul_hi(op[0], op[6]);
    uint32_t low1 = op[1]*op[5];
    uint32_t hi1 = mul_hi(op[1], op[5]);
    uint32_t low2 = op[2]*op[4];
    uint32_t hi2 = mul_hi(op[2], op[4]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += op[3]*op[3];
    accHi += mul_hi(op[3], op[3]);
    accLow += invValue[0]*mod[6];
    accHi += mul_hi(invValue[0], mod[6]);
    accLow += invValue[1]*mod[5];
    accHi += mul_hi(invValue[1], mod[5]);
    accLow += invValue[2]*mod[4];
    accHi += mul_hi(invValue[2], mod[4]);
    accLow += invValue[3]*mod[3];
    accHi += mul_hi(invValue[3], mod[3]);
    accLow += invValue[4]*mod[2];
    accHi += mul_hi(invValue[4], mod[2]);
    accLow += invValue[5]*mod[1];
    accHi += mul_hi(invValue[5], mod[1]);
    invValue[6] = invm * (uint32_t)accLow;
    accLow += invValue[6]*mod[0];
    accHi += mul_hi(invValue[6], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[7];
    uint32_t hi0 = mul_hi(op[0], op[7]);
    uint32_t low1 = op[1]*op[6];
    uint32_t hi1 = mul_hi(op[1], op[6]);
    uint32_t low2 = op[2]*op[5];
    uint32_t hi2 = mul_hi(op[2], op[5]);
    uint32_t low3 = op[3]*op[4];
    uint32_t hi3 = mul_hi(op[3], op[4]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += invValue[0]*mod[7];
    accHi += mul_hi(invValue[0], mod[7]);
    accLow += invValue[1]*mod[6];
    accHi += mul_hi(invValue[1], mod[6]);
    accLow += invValue[2]*mod[5];
    accHi += mul_hi(invValue[2], mod[5]);
    accLow += invValue[3]*mod[4];
    accHi += mul_hi(invValue[3], mod[4]);
    accLow += invValue[4]*mod[3];
    accHi += mul_hi(invValue[4], mod[3]);
    accLow += invValue[5]*mod[2];
    accHi += mul_hi(invValue[5], mod[2]);
    accLow += invValue[6]*mod[1];
    accHi += mul_hi(invValue[6], mod[1]);
    invValue[7] = invm * (uint32_t)accLow;
    accLow += invValue[7]*mod[0];
    accHi += mul_hi(invValue[7], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[8];
    uint32_t hi0 = mul_hi(op[0], op[8]);
    uint32_t low1 = op[1]*op[7];
    uint32_t hi1 = mul_hi(op[1], op[7]);
    uint32_t low2 = op[2]*op[6];
    uint32_t hi2 = mul_hi(op[2], op[6]);
    uint32_t low3 = op[3]*op[5];
    uint32_t hi3 = mul_hi(op[3], op[5]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += op[4]*op[4];
    accHi += mul_hi(op[4], op[4]);
    accLow += invValue[0]*mod[8];
    accHi += mul_hi(invValue[0], mod[8]);
    accLow += invValue[1]*mod[7];
    accHi += mul_hi(invValue[1], mod[7]);
    accLow += invValue[2]*mod[6];
    accHi += mul_hi(invValue[2], mod[6]);
    accLow += invValue[3]*mod[5];
    accHi += mul_hi(invValue[3], mod[5]);
    accLow += invValue[4]*mod[4];
    accHi += mul_hi(invValue[4], mod[4]);
    accLow += invValue[5]*mod[3];
    accHi += mul_hi(invValue[5], mod[3]);
    accLow += invValue[6]*mod[2];
    accHi += mul_hi(invValue[6], mod[2]);
    accLow += invValue[7]*mod[1];
    accHi += mul_hi(invValue[7], mod[1]);
    invValue[8] = invm * (uint32_t)accLow;
    accLow += invValue[8]*mod[0];
    accHi += mul_hi(invValue[8], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[9];
    uint32_t hi0 = mul_hi(op[0], op[9]);
    uint32_t low1 = op[1]*op[8];
    uint32_t hi1 = mul_hi(op[1], op[8]);
    uint32_t low2 = op[2]*op[7];
    uint32_t hi2 = mul_hi(op[2], op[7]);
    uint32_t low3 = op[3]*op[6];
    uint32_t hi3 = mul_hi(op[3], op[6]);
    uint32_t low4 = op[4]*op[5];
    uint32_t hi4 = mul_hi(op[4], op[5]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += low4; accLow += low4;
    accHi += hi4; accHi += hi4;
    accLow += invValue[0]*mod[9];
    accHi += mul_hi(invValue[0], mod[9]);
    accLow += invValue[1]*mod[8];
    accHi += mul_hi(invValue[1], mod[8]);
    accLow += invValue[2]*mod[7];
    accHi += mul_hi(invValue[2], mod[7]);
    accLow += invValue[3]*mod[6];
    accHi += mul_hi(invValue[3], mod[6]);
    accLow += invValue[4]*mod[5];
    accHi += mul_hi(invValue[4], mod[5]);
    accLow += invValue[5]*mod[4];
    accHi += mul_hi(invValue[5], mod[4]);
    accLow += invValue[6]*mod[3];
    accHi += mul_hi(invValue[6], mod[3]);
    accLow += invValue[7]*mod[2];
    accHi += mul_hi(invValue[7], mod[2]);
    accLow += invValue[8]*mod[1];
    accHi += mul_hi(invValue[8], mod[1]);
    invValue[9] = invm * (uint32_t)accLow;
    accLow += invValue[9]*mod[0];
    accHi += mul_hi(invValue[9], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[1]*op[9];
    uint32_t hi0 = mul_hi(op[1], op[9]);
    uint32_t low1 = op[2]*op[8];
    uint32_t hi1 = mul_hi(op[2], op[8]);
    uint32_t low2 = op[3]*op[7];
    uint32_t hi2 = mul_hi(op[3], op[7]);
    uint32_t low3 = op[4]*op[6];
    uint32_t hi3 = mul_hi(op[4], op[6]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += op[5]*op[5];
    accHi += mul_hi(op[5], op[5]);
    accLow += invValue[1]*mod[9];
    accHi += mul_hi(invValue[1], mod[9]);
    accLow += invValue[2]*mod[8];
    accHi += mul_hi(invValue[2], mod[8]);
    accLow += invValue[3]*mod[7];
    accHi += mul_hi(invValue[3], mod[7]);
    accLow += invValue[4]*mod[6];
    accHi += mul_hi(invValue[4], mod[6]);
    accLow += invValue[5]*mod[5];
    accHi += mul_hi(invValue[5], mod[5]);
    accLow += invValue[6]*mod[4];
    accHi += mul_hi(invValue[6], mod[4]);
    accLow += invValue[7]*mod[3];
    accHi += mul_hi(invValue[7], mod[3]);
    accLow += invValue[8]*mod[2];
    accHi += mul_hi(invValue[8], mod[2]);
    accLow += invValue[9]*mod[1];
    accHi += mul_hi(invValue[9], mod[1]);
    op[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[2]*op[9];
    uint32_t hi0 = mul_hi(op[2], op[9]);
    uint32_t low1 = op[3]*op[8];
    uint32_t hi1 = mul_hi(op[3], op[8]);
    uint32_t low2 = op[4]*op[7];
    uint32_t hi2 = mul_hi(op[4], op[7]);
    uint32_t low3 = op[5]*op[6];
    uint32_t hi3 = mul_hi(op[5], op[6]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += invValue[2]*mod[9];
    accHi += mul_hi(invValue[2], mod[9]);
    accLow += invValue[3]*mod[8];
    accHi += mul_hi(invValue[3], mod[8]);
    accLow += invValue[4]*mod[7];
    accHi += mul_hi(invValue[4], mod[7]);
    accLow += invValue[5]*mod[6];
    accHi += mul_hi(invValue[5], mod[6]);
    accLow += invValue[6]*mod[5];
    accHi += mul_hi(invValue[6], mod[5]);
    accLow += invValue[7]*mod[4];
    accHi += mul_hi(invValue[7], mod[4]);
    accLow += invValue[8]*mod[3];
    accHi += mul_hi(invValue[8], mod[3]);
    accLow += invValue[9]*mod[2];
    accHi += mul_hi(invValue[9], mod[2]);
    op[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[3]*op[9];
    uint32_t hi0 = mul_hi(op[3], op[9]);
    uint32_t low1 = op[4]*op[8];
    uint32_t hi1 = mul_hi(op[4], op[8]);
    uint32_t low2 = op[5]*op[7];
    uint32_t hi2 = mul_hi(op[5], op[7]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += op[6]*op[6];
    accHi += mul_hi(op[6], op[6]);
    accLow += invValue[3]*mod[9];
    accHi += mul_hi(invValue[3], mod[9]);
    accLow += invValue[4]*mod[8];
    accHi += mul_hi(invValue[4], mod[8]);
    accLow += invValue[5]*mod[7];
    accHi += mul_hi(invValue[5], mod[7]);
    accLow += invValue[6]*mod[6];
    accHi += mul_hi(invValue[6], mod[6]);
    accLow += invValue[7]*mod[5];
    accHi += mul_hi(invValue[7], mod[5]);
    accLow += invValue[8]*mod[4];
    accHi += mul_hi(invValue[8], mod[4]);
    accLow += invValue[9]*mod[3];
    accHi += mul_hi(invValue[9], mod[3]);
    op[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[4]*op[9];
    uint32_t hi0 = mul_hi(op[4], op[9]);
    uint32_t low1 = op[5]*op[8];
    uint32_t hi1 = mul_hi(op[5], op[8]);
    uint32_t low2 = op[6]*op[7];
    uint32_t hi2 = mul_hi(op[6], op[7]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += invValue[4]*mod[9];
    accHi += mul_hi(invValue[4], mod[9]);
    accLow += invValue[5]*mod[8];
    accHi += mul_hi(invValue[5], mod[8]);
    accLow += invValue[6]*mod[7];
    accHi += mul_hi(invValue[6], mod[7]);
    accLow += invValue[7]*mod[6];
    accHi += mul_hi(invValue[7], mod[6]);
    accLow += invValue[8]*mod[5];
    accHi += mul_hi(invValue[8], mod[5]);
    accLow += invValue[9]*mod[4];
    accHi += mul_hi(invValue[9], mod[4]);
    op[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[5]*op[9];
    uint32_t hi0 = mul_hi(op[5], op[9]);
    uint32_t low1 = op[6]*op[8];
    uint32_t hi1 = mul_hi(op[6], op[8]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += op[7]*op[7];
    accHi += mul_hi(op[7], op[7]);
    accLow += invValue[5]*mod[9];
    accHi += mul_hi(invValue[5], mod[9]);
    accLow += invValue[6]*mod[8];
    accHi += mul_hi(invValue[6], mod[8]);
    accLow += invValue[7]*mod[7];
    accHi += mul_hi(invValue[7], mod[7]);
    accLow += invValue[8]*mod[6];
    accHi += mul_hi(invValue[8], mod[6]);
    accLow += invValue[9]*mod[5];
    accHi += mul_hi(invValue[9], mod[5]);
    op[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[6]*op[9];
    uint32_t hi0 = mul_hi(op[6], op[9]);
    uint32_t low1 = op[7]*op[8];
    uint32_t hi1 = mul_hi(op[7], op[8]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += invValue[6]*mod[9];
    accHi += mul_hi(invValue[6], mod[9]);
    accLow += invValue[7]*mod[8];
    accHi += mul_hi(invValue[7], mod[8]);
    accLow += invValue[8]*mod[7];
    accHi += mul_hi(invValue[8], mod[7]);
    accLow += invValue[9]*mod[6];
    accHi += mul_hi(invValue[9], mod[6]);
    op[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[7]*op[9];
    uint32_t hi0 = mul_hi(op[7], op[9]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += op[8]*op[8];
    accHi += mul_hi(op[8], op[8]);
    accLow += invValue[7]*mod[9];
    accHi += mul_hi(invValue[7], mod[9]);
    accLow += invValue[8]*mod[8];
    accHi += mul_hi(invValue[8], mod[8]);
    accLow += invValue[9]*mod[7];
    accHi += mul_hi(invValue[9], mod[7]);
    op[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[8]*op[9];
    uint32_t hi0 = mul_hi(op[8], op[9]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += invValue[8]*mod[9];
    accHi += mul_hi(invValue[8], mod[9]);
    accLow += invValue[9]*mod[8];
    accHi += mul_hi(invValue[9], mod[8]);
    op[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op[9]*op[9];
    accHi += mul_hi(op[9], op[9]);
    accLow += invValue[9]*mod[9];
    accHi += mul_hi(invValue[9], mod[9]);
    op[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  op[9] = accLow;
  Int.v64 = accLow;
  if (Int.v32.y)
    sub(op, mod, 10);
}
void monMul320(uint32_t *op1, uint32_t *op2, uint32_t *mod, uint32_t invm)
{
  uint32_t invValue[10];
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    invValue[0] = invm * (uint32_t)accLow;
    accLow += invValue[0]*mod[0];
    accHi += mul_hi(invValue[0], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    accLow += invValue[0]*mod[1];
    accHi += mul_hi(invValue[0], mod[1]);
    invValue[1] = invm * (uint32_t)accLow;
    accLow += invValue[1]*mod[0];
    accHi += mul_hi(invValue[1], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    accLow += invValue[0]*mod[2];
    accHi += mul_hi(invValue[0], mod[2]);
    accLow += invValue[1]*mod[1];
    accHi += mul_hi(invValue[1], mod[1]);
    invValue[2] = invm * (uint32_t)accLow;
    accLow += invValue[2]*mod[0];
    accHi += mul_hi(invValue[2], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[3];
    accHi += mul_hi(op1[0], op2[3]);
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    accLow += invValue[0]*mod[3];
    accHi += mul_hi(invValue[0], mod[3]);
    accLow += invValue[1]*mod[2];
    accHi += mul_hi(invValue[1], mod[2]);
    accLow += invValue[2]*mod[1];
    accHi += mul_hi(invValue[2], mod[1]);
    invValue[3] = invm * (uint32_t)accLow;
    accLow += invValue[3]*mod[0];
    accHi += mul_hi(invValue[3], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[4];
    accHi += mul_hi(op1[0], op2[4]);
    accLow += op1[1]*op2[3];
    accHi += mul_hi(op1[1], op2[3]);
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    accLow += invValue[0]*mod[4];
    accHi += mul_hi(invValue[0], mod[4]);
    accLow += invValue[1]*mod[3];
    accHi += mul_hi(invValue[1], mod[3]);
    accLow += invValue[2]*mod[2];
    accHi += mul_hi(invValue[2], mod[2]);
    accLow += invValue[3]*mod[1];
    accHi += mul_hi(invValue[3], mod[1]);
    invValue[4] = invm * (uint32_t)accLow;
    accLow += invValue[4]*mod[0];
    accHi += mul_hi(invValue[4], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[5];
    accHi += mul_hi(op1[0], op2[5]);
    accLow += op1[1]*op2[4];
    accHi += mul_hi(op1[1], op2[4]);
    accLow += op1[2]*op2[3];
    accHi += mul_hi(op1[2], op2[3]);
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    accLow += invValue[0]*mod[5];
    accHi += mul_hi(invValue[0], mod[5]);
    accLow += invValue[1]*mod[4];
    accHi += mul_hi(invValue[1], mod[4]);
    accLow += invValue[2]*mod[3];
    accHi += mul_hi(invValue[2], mod[3]);
    accLow += invValue[3]*mod[2];
    accHi += mul_hi(invValue[3], mod[2]);
    accLow += invValue[4]*mod[1];
    accHi += mul_hi(invValue[4], mod[1]);
    invValue[5] = invm * (uint32_t)accLow;
    accLow += invValue[5]*mod[0];
    accHi += mul_hi(invValue[5], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[6];
    accHi += mul_hi(op1[0], op2[6]);
    accLow += op1[1]*op2[5];
    accHi += mul_hi(op1[1], op2[5]);
    accLow += op1[2]*op2[4];
    accHi += mul_hi(op1[2], op2[4]);
    accLow += op1[3]*op2[3];
    accHi += mul_hi(op1[3], op2[3]);
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    accLow += invValue[0]*mod[6];
    accHi += mul_hi(invValue[0], mod[6]);
    accLow += invValue[1]*mod[5];
    accHi += mul_hi(invValue[1], mod[5]);
    accLow += invValue[2]*mod[4];
    accHi += mul_hi(invValue[2], mod[4]);
    accLow += invValue[3]*mod[3];
    accHi += mul_hi(invValue[3], mod[3]);
    accLow += invValue[4]*mod[2];
    accHi += mul_hi(invValue[4], mod[2]);
    accLow += invValue[5]*mod[1];
    accHi += mul_hi(invValue[5], mod[1]);
    invValue[6] = invm * (uint32_t)accLow;
    accLow += invValue[6]*mod[0];
    accHi += mul_hi(invValue[6], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[7];
    accHi += mul_hi(op1[0], op2[7]);
    accLow += op1[1]*op2[6];
    accHi += mul_hi(op1[1], op2[6]);
    accLow += op1[2]*op2[5];
    accHi += mul_hi(op1[2], op2[5]);
    accLow += op1[3]*op2[4];
    accHi += mul_hi(op1[3], op2[4]);
    accLow += op1[4]*op2[3];
    accHi += mul_hi(op1[4], op2[3]);
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    accLow += invValue[0]*mod[7];
    accHi += mul_hi(invValue[0], mod[7]);
    accLow += invValue[1]*mod[6];
    accHi += mul_hi(invValue[1], mod[6]);
    accLow += invValue[2]*mod[5];
    accHi += mul_hi(invValue[2], mod[5]);
    accLow += invValue[3]*mod[4];
    accHi += mul_hi(invValue[3], mod[4]);
    accLow += invValue[4]*mod[3];
    accHi += mul_hi(invValue[4], mod[3]);
    accLow += invValue[5]*mod[2];
    accHi += mul_hi(invValue[5], mod[2]);
    accLow += invValue[6]*mod[1];
    accHi += mul_hi(invValue[6], mod[1]);
    invValue[7] = invm * (uint32_t)accLow;
    accLow += invValue[7]*mod[0];
    accHi += mul_hi(invValue[7], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[8];
    accHi += mul_hi(op1[0], op2[8]);
    accLow += op1[1]*op2[7];
    accHi += mul_hi(op1[1], op2[7]);
    accLow += op1[2]*op2[6];
    accHi += mul_hi(op1[2], op2[6]);
    accLow += op1[3]*op2[5];
    accHi += mul_hi(op1[3], op2[5]);
    accLow += op1[4]*op2[4];
    accHi += mul_hi(op1[4], op2[4]);
    accLow += op1[5]*op2[3];
    accHi += mul_hi(op1[5], op2[3]);
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    accLow += invValue[0]*mod[8];
    accHi += mul_hi(invValue[0], mod[8]);
    accLow += invValue[1]*mod[7];
    accHi += mul_hi(invValue[1], mod[7]);
    accLow += invValue[2]*mod[6];
    accHi += mul_hi(invValue[2], mod[6]);
    accLow += invValue[3]*mod[5];
    accHi += mul_hi(invValue[3], mod[5]);
    accLow += invValue[4]*mod[4];
    accHi += mul_hi(invValue[4], mod[4]);
    accLow += invValue[5]*mod[3];
    accHi += mul_hi(invValue[5], mod[3]);
    accLow += invValue[6]*mod[2];
    accHi += mul_hi(invValue[6], mod[2]);
    accLow += invValue[7]*mod[1];
    accHi += mul_hi(invValue[7], mod[1]);
    invValue[8] = invm * (uint32_t)accLow;
    accLow += invValue[8]*mod[0];
    accHi += mul_hi(invValue[8], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[9];
    accHi += mul_hi(op1[0], op2[9]);
    accLow += op1[1]*op2[8];
    accHi += mul_hi(op1[1], op2[8]);
    accLow += op1[2]*op2[7];
    accHi += mul_hi(op1[2], op2[7]);
    accLow += op1[3]*op2[6];
    accHi += mul_hi(op1[3], op2[6]);
    accLow += op1[4]*op2[5];
    accHi += mul_hi(op1[4], op2[5]);
    accLow += op1[5]*op2[4];
    accHi += mul_hi(op1[5], op2[4]);
    accLow += op1[6]*op2[3];
    accHi += mul_hi(op1[6], op2[3]);
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    accLow += invValue[0]*mod[9];
    accHi += mul_hi(invValue[0], mod[9]);
    accLow += invValue[1]*mod[8];
    accHi += mul_hi(invValue[1], mod[8]);
    accLow += invValue[2]*mod[7];
    accHi += mul_hi(invValue[2], mod[7]);
    accLow += invValue[3]*mod[6];
    accHi += mul_hi(invValue[3], mod[6]);
    accLow += invValue[4]*mod[5];
    accHi += mul_hi(invValue[4], mod[5]);
    accLow += invValue[5]*mod[4];
    accHi += mul_hi(invValue[5], mod[4]);
    accLow += invValue[6]*mod[3];
    accHi += mul_hi(invValue[6], mod[3]);
    accLow += invValue[7]*mod[2];
    accHi += mul_hi(invValue[7], mod[2]);
    accLow += invValue[8]*mod[1];
    accHi += mul_hi(invValue[8], mod[1]);
    invValue[9] = invm * (uint32_t)accLow;
    accLow += invValue[9]*mod[0];
    accHi += mul_hi(invValue[9], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[9];
    accHi += mul_hi(op1[1], op2[9]);
    accLow += op1[2]*op2[8];
    accHi += mul_hi(op1[2], op2[8]);
    accLow += op1[3]*op2[7];
    accHi += mul_hi(op1[3], op2[7]);
    accLow += op1[4]*op2[6];
    accHi += mul_hi(op1[4], op2[6]);
    accLow += op1[5]*op2[5];
    accHi += mul_hi(op1[5], op2[5]);
    accLow += op1[6]*op2[4];
    accHi += mul_hi(op1[6], op2[4]);
    accLow += op1[7]*op2[3];
    accHi += mul_hi(op1[7], op2[3]);
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    accLow += invValue[1]*mod[9];
    accHi += mul_hi(invValue[1], mod[9]);
    accLow += invValue[2]*mod[8];
    accHi += mul_hi(invValue[2], mod[8]);
    accLow += invValue[3]*mod[7];
    accHi += mul_hi(invValue[3], mod[7]);
    accLow += invValue[4]*mod[6];
    accHi += mul_hi(invValue[4], mod[6]);
    accLow += invValue[5]*mod[5];
    accHi += mul_hi(invValue[5], mod[5]);
    accLow += invValue[6]*mod[4];
    accHi += mul_hi(invValue[6], mod[4]);
    accLow += invValue[7]*mod[3];
    accHi += mul_hi(invValue[7], mod[3]);
    accLow += invValue[8]*mod[2];
    accHi += mul_hi(invValue[8], mod[2]);
    accLow += invValue[9]*mod[1];
    accHi += mul_hi(invValue[9], mod[1]);
    op1[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[9];
    accHi += mul_hi(op1[2], op2[9]);
    accLow += op1[3]*op2[8];
    accHi += mul_hi(op1[3], op2[8]);
    accLow += op1[4]*op2[7];
    accHi += mul_hi(op1[4], op2[7]);
    accLow += op1[5]*op2[6];
    accHi += mul_hi(op1[5], op2[6]);
    accLow += op1[6]*op2[5];
    accHi += mul_hi(op1[6], op2[5]);
    accLow += op1[7]*op2[4];
    accHi += mul_hi(op1[7], op2[4]);
    accLow += op1[8]*op2[3];
    accHi += mul_hi(op1[8], op2[3]);
    accLow += op1[9]*op2[2];
    accHi += mul_hi(op1[9], op2[2]);
    accLow += invValue[2]*mod[9];
    accHi += mul_hi(invValue[2], mod[9]);
    accLow += invValue[3]*mod[8];
    accHi += mul_hi(invValue[3], mod[8]);
    accLow += invValue[4]*mod[7];
    accHi += mul_hi(invValue[4], mod[7]);
    accLow += invValue[5]*mod[6];
    accHi += mul_hi(invValue[5], mod[6]);
    accLow += invValue[6]*mod[5];
    accHi += mul_hi(invValue[6], mod[5]);
    accLow += invValue[7]*mod[4];
    accHi += mul_hi(invValue[7], mod[4]);
    accLow += invValue[8]*mod[3];
    accHi += mul_hi(invValue[8], mod[3]);
    accLow += invValue[9]*mod[2];
    accHi += mul_hi(invValue[9], mod[2]);
    op1[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[9];
    accHi += mul_hi(op1[3], op2[9]);
    accLow += op1[4]*op2[8];
    accHi += mul_hi(op1[4], op2[8]);
    accLow += op1[5]*op2[7];
    accHi += mul_hi(op1[5], op2[7]);
    accLow += op1[6]*op2[6];
    accHi += mul_hi(op1[6], op2[6]);
    accLow += op1[7]*op2[5];
    accHi += mul_hi(op1[7], op2[5]);
    accLow += op1[8]*op2[4];
    accHi += mul_hi(op1[8], op2[4]);
    accLow += op1[9]*op2[3];
    accHi += mul_hi(op1[9], op2[3]);
    accLow += invValue[3]*mod[9];
    accHi += mul_hi(invValue[3], mod[9]);
    accLow += invValue[4]*mod[8];
    accHi += mul_hi(invValue[4], mod[8]);
    accLow += invValue[5]*mod[7];
    accHi += mul_hi(invValue[5], mod[7]);
    accLow += invValue[6]*mod[6];
    accHi += mul_hi(invValue[6], mod[6]);
    accLow += invValue[7]*mod[5];
    accHi += mul_hi(invValue[7], mod[5]);
    accLow += invValue[8]*mod[4];
    accHi += mul_hi(invValue[8], mod[4]);
    accLow += invValue[9]*mod[3];
    accHi += mul_hi(invValue[9], mod[3]);
    op1[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[9];
    accHi += mul_hi(op1[4], op2[9]);
    accLow += op1[5]*op2[8];
    accHi += mul_hi(op1[5], op2[8]);
    accLow += op1[6]*op2[7];
    accHi += mul_hi(op1[6], op2[7]);
    accLow += op1[7]*op2[6];
    accHi += mul_hi(op1[7], op2[6]);
    accLow += op1[8]*op2[5];
    accHi += mul_hi(op1[8], op2[5]);
    accLow += op1[9]*op2[4];
    accHi += mul_hi(op1[9], op2[4]);
    accLow += invValue[4]*mod[9];
    accHi += mul_hi(invValue[4], mod[9]);
    accLow += invValue[5]*mod[8];
    accHi += mul_hi(invValue[5], mod[8]);
    accLow += invValue[6]*mod[7];
    accHi += mul_hi(invValue[6], mod[7]);
    accLow += invValue[7]*mod[6];
    accHi += mul_hi(invValue[7], mod[6]);
    accLow += invValue[8]*mod[5];
    accHi += mul_hi(invValue[8], mod[5]);
    accLow += invValue[9]*mod[4];
    accHi += mul_hi(invValue[9], mod[4]);
    op1[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[9];
    accHi += mul_hi(op1[5], op2[9]);
    accLow += op1[6]*op2[8];
    accHi += mul_hi(op1[6], op2[8]);
    accLow += op1[7]*op2[7];
    accHi += mul_hi(op1[7], op2[7]);
    accLow += op1[8]*op2[6];
    accHi += mul_hi(op1[8], op2[6]);
    accLow += op1[9]*op2[5];
    accHi += mul_hi(op1[9], op2[5]);
    accLow += invValue[5]*mod[9];
    accHi += mul_hi(invValue[5], mod[9]);
    accLow += invValue[6]*mod[8];
    accHi += mul_hi(invValue[6], mod[8]);
    accLow += invValue[7]*mod[7];
    accHi += mul_hi(invValue[7], mod[7]);
    accLow += invValue[8]*mod[6];
    accHi += mul_hi(invValue[8], mod[6]);
    accLow += invValue[9]*mod[5];
    accHi += mul_hi(invValue[9], mod[5]);
    op1[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*op2[9];
    accHi += mul_hi(op1[6], op2[9]);
    accLow += op1[7]*op2[8];
    accHi += mul_hi(op1[7], op2[8]);
    accLow += op1[8]*op2[7];
    accHi += mul_hi(op1[8], op2[7]);
    accLow += op1[9]*op2[6];
    accHi += mul_hi(op1[9], op2[6]);
    accLow += invValue[6]*mod[9];
    accHi += mul_hi(invValue[6], mod[9]);
    accLow += invValue[7]*mod[8];
    accHi += mul_hi(invValue[7], mod[8]);
    accLow += invValue[8]*mod[7];
    accHi += mul_hi(invValue[8], mod[7]);
    accLow += invValue[9]*mod[6];
    accHi += mul_hi(invValue[9], mod[6]);
    op1[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[7]*op2[9];
    accHi += mul_hi(op1[7], op2[9]);
    accLow += op1[8]*op2[8];
    accHi += mul_hi(op1[8], op2[8]);
    accLow += op1[9]*op2[7];
    accHi += mul_hi(op1[9], op2[7]);
    accLow += invValue[7]*mod[9];
    accHi += mul_hi(invValue[7], mod[9]);
    accLow += invValue[8]*mod[8];
    accHi += mul_hi(invValue[8], mod[8]);
    accLow += invValue[9]*mod[7];
    accHi += mul_hi(invValue[9], mod[7]);
    op1[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[8]*op2[9];
    accHi += mul_hi(op1[8], op2[9]);
    accLow += op1[9]*op2[8];
    accHi += mul_hi(op1[9], op2[8]);
    accLow += invValue[8]*mod[9];
    accHi += mul_hi(invValue[8], mod[9]);
    accLow += invValue[9]*mod[8];
    accHi += mul_hi(invValue[9], mod[8]);
    op1[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[9]*op2[9];
    accHi += mul_hi(op1[9], op2[9]);
    accLow += invValue[9]*mod[9];
    accHi += mul_hi(invValue[9], mod[9]);
    op1[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  op1[9] = accLow;
  Int.v64 = accLow;
  if (Int.v32.y)
    sub(op1, mod, 10);
}
void redcHalf320(uint32_t *op, uint32_t *mod, uint32_t invm)
{
  uint32_t invValue[10];
  uint64_t accLow = op[0], accHi = op[1];
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    invValue[0] = invm * (uint32_t)accLow;
    accLow += invValue[0]*mod[0];
    accHi += mul_hi(invValue[0], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[2];
  }
  {
    accLow += invValue[0]*mod[1];
    accHi += mul_hi(invValue[0], mod[1]);
    invValue[1] = invm * (uint32_t)accLow;
    accLow += invValue[1]*mod[0];
    accHi += mul_hi(invValue[1], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[3];
  }
  {
    accLow += invValue[0]*mod[2];
    accHi += mul_hi(invValue[0], mod[2]);
    accLow += invValue[1]*mod[1];
    accHi += mul_hi(invValue[1], mod[1]);
    invValue[2] = invm * (uint32_t)accLow;
    accLow += invValue[2]*mod[0];
    accHi += mul_hi(invValue[2], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[4];
  }
  {
    accLow += invValue[0]*mod[3];
    accHi += mul_hi(invValue[0], mod[3]);
    accLow += invValue[1]*mod[2];
    accHi += mul_hi(invValue[1], mod[2]);
    accLow += invValue[2]*mod[1];
    accHi += mul_hi(invValue[2], mod[1]);
    invValue[3] = invm * (uint32_t)accLow;
    accLow += invValue[3]*mod[0];
    accHi += mul_hi(invValue[3], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[5];
  }
  {
    accLow += invValue[0]*mod[4];
    accHi += mul_hi(invValue[0], mod[4]);
    accLow += invValue[1]*mod[3];
    accHi += mul_hi(invValue[1], mod[3]);
    accLow += invValue[2]*mod[2];
    accHi += mul_hi(invValue[2], mod[2]);
    accLow += invValue[3]*mod[1];
    accHi += mul_hi(invValue[3], mod[1]);
    invValue[4] = invm * (uint32_t)accLow;
    accLow += invValue[4]*mod[0];
    accHi += mul_hi(invValue[4], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[6];
  }
  {
    accLow += invValue[0]*mod[5];
    accHi += mul_hi(invValue[0], mod[5]);
    accLow += invValue[1]*mod[4];
    accHi += mul_hi(invValue[1], mod[4]);
    accLow += invValue[2]*mod[3];
    accHi += mul_hi(invValue[2], mod[3]);
    accLow += invValue[3]*mod[2];
    accHi += mul_hi(invValue[3], mod[2]);
    accLow += invValue[4]*mod[1];
    accHi += mul_hi(invValue[4], mod[1]);
    invValue[5] = invm * (uint32_t)accLow;
    accLow += invValue[5]*mod[0];
    accHi += mul_hi(invValue[5], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[7];
  }
  {
    accLow += invValue[0]*mod[6];
    accHi += mul_hi(invValue[0], mod[6]);
    accLow += invValue[1]*mod[5];
    accHi += mul_hi(invValue[1], mod[5]);
    accLow += invValue[2]*mod[4];
    accHi += mul_hi(invValue[2], mod[4]);
    accLow += invValue[3]*mod[3];
    accHi += mul_hi(invValue[3], mod[3]);
    accLow += invValue[4]*mod[2];
    accHi += mul_hi(invValue[4], mod[2]);
    accLow += invValue[5]*mod[1];
    accHi += mul_hi(invValue[5], mod[1]);
    invValue[6] = invm * (uint32_t)accLow;
    accLow += invValue[6]*mod[0];
    accHi += mul_hi(invValue[6], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[8];
  }
  {
    accLow += invValue[0]*mod[7];
    accHi += mul_hi(invValue[0], mod[7]);
    accLow += invValue[1]*mod[6];
    accHi += mul_hi(invValue[1], mod[6]);
    accLow += invValue[2]*mod[5];
    accHi += mul_hi(invValue[2], mod[5]);
    accLow += invValue[3]*mod[4];
    accHi += mul_hi(invValue[3], mod[4]);
    accLow += invValue[4]*mod[3];
    accHi += mul_hi(invValue[4], mod[3]);
    accLow += invValue[5]*mod[2];
    accHi += mul_hi(invValue[5], mod[2]);
    accLow += invValue[6]*mod[1];
    accHi += mul_hi(invValue[6], mod[1]);
    invValue[7] = invm * (uint32_t)accLow;
    accLow += invValue[7]*mod[0];
    accHi += mul_hi(invValue[7], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[9];
  }
  {
    accLow += invValue[0]*mod[8];
    accHi += mul_hi(invValue[0], mod[8]);
    accLow += invValue[1]*mod[7];
    accHi += mul_hi(invValue[1], mod[7]);
    accLow += invValue[2]*mod[6];
    accHi += mul_hi(invValue[2], mod[6]);
    accLow += invValue[3]*mod[5];
    accHi += mul_hi(invValue[3], mod[5]);
    accLow += invValue[4]*mod[4];
    accHi += mul_hi(invValue[4], mod[4]);
    accLow += invValue[5]*mod[3];
    accHi += mul_hi(invValue[5], mod[3]);
    accLow += invValue[6]*mod[2];
    accHi += mul_hi(invValue[6], mod[2]);
    accLow += invValue[7]*mod[1];
    accHi += mul_hi(invValue[7], mod[1]);
    invValue[8] = invm * (uint32_t)accLow;
    accLow += invValue[8]*mod[0];
    accHi += mul_hi(invValue[8], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[0]*mod[9];
    accHi += mul_hi(invValue[0], mod[9]);
    accLow += invValue[1]*mod[8];
    accHi += mul_hi(invValue[1], mod[8]);
    accLow += invValue[2]*mod[7];
    accHi += mul_hi(invValue[2], mod[7]);
    accLow += invValue[3]*mod[6];
    accHi += mul_hi(invValue[3], mod[6]);
    accLow += invValue[4]*mod[5];
    accHi += mul_hi(invValue[4], mod[5]);
    accLow += invValue[5]*mod[4];
    accHi += mul_hi(invValue[5], mod[4]);
    accLow += invValue[6]*mod[3];
    accHi += mul_hi(invValue[6], mod[3]);
    accLow += invValue[7]*mod[2];
    accHi += mul_hi(invValue[7], mod[2]);
    accLow += invValue[8]*mod[1];
    accHi += mul_hi(invValue[8], mod[1]);
    invValue[9] = invm * (uint32_t)accLow;
    accLow += invValue[9]*mod[0];
    accHi += mul_hi(invValue[9], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[1]*mod[9];
    accHi += mul_hi(invValue[1], mod[9]);
    accLow += invValue[2]*mod[8];
    accHi += mul_hi(invValue[2], mod[8]);
    accLow += invValue[3]*mod[7];
    accHi += mul_hi(invValue[3], mod[7]);
    accLow += invValue[4]*mod[6];
    accHi += mul_hi(invValue[4], mod[6]);
    accLow += invValue[5]*mod[5];
    accHi += mul_hi(invValue[5], mod[5]);
    accLow += invValue[6]*mod[4];
    accHi += mul_hi(invValue[6], mod[4]);
    accLow += invValue[7]*mod[3];
    accHi += mul_hi(invValue[7], mod[3]);
    accLow += invValue[8]*mod[2];
    accHi += mul_hi(invValue[8], mod[2]);
    accLow += invValue[9]*mod[1];
    accHi += mul_hi(invValue[9], mod[1]);
    op[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[2]*mod[9];
    accHi += mul_hi(invValue[2], mod[9]);
    accLow += invValue[3]*mod[8];
    accHi += mul_hi(invValue[3], mod[8]);
    accLow += invValue[4]*mod[7];
    accHi += mul_hi(invValue[4], mod[7]);
    accLow += invValue[5]*mod[6];
    accHi += mul_hi(invValue[5], mod[6]);
    accLow += invValue[6]*mod[5];
    accHi += mul_hi(invValue[6], mod[5]);
    accLow += invValue[7]*mod[4];
    accHi += mul_hi(invValue[7], mod[4]);
    accLow += invValue[8]*mod[3];
    accHi += mul_hi(invValue[8], mod[3]);
    accLow += invValue[9]*mod[2];
    accHi += mul_hi(invValue[9], mod[2]);
    op[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[3]*mod[9];
    accHi += mul_hi(invValue[3], mod[9]);
    accLow += invValue[4]*mod[8];
    accHi += mul_hi(invValue[4], mod[8]);
    accLow += invValue[5]*mod[7];
    accHi += mul_hi(invValue[5], mod[7]);
    accLow += invValue[6]*mod[6];
    accHi += mul_hi(invValue[6], mod[6]);
    accLow += invValue[7]*mod[5];
    accHi += mul_hi(invValue[7], mod[5]);
    accLow += invValue[8]*mod[4];
    accHi += mul_hi(invValue[8], mod[4]);
    accLow += invValue[9]*mod[3];
    accHi += mul_hi(invValue[9], mod[3]);
    op[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[4]*mod[9];
    accHi += mul_hi(invValue[4], mod[9]);
    accLow += invValue[5]*mod[8];
    accHi += mul_hi(invValue[5], mod[8]);
    accLow += invValue[6]*mod[7];
    accHi += mul_hi(invValue[6], mod[7]);
    accLow += invValue[7]*mod[6];
    accHi += mul_hi(invValue[7], mod[6]);
    accLow += invValue[8]*mod[5];
    accHi += mul_hi(invValue[8], mod[5]);
    accLow += invValue[9]*mod[4];
    accHi += mul_hi(invValue[9], mod[4]);
    op[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[5]*mod[9];
    accHi += mul_hi(invValue[5], mod[9]);
    accLow += invValue[6]*mod[8];
    accHi += mul_hi(invValue[6], mod[8]);
    accLow += invValue[7]*mod[7];
    accHi += mul_hi(invValue[7], mod[7]);
    accLow += invValue[8]*mod[6];
    accHi += mul_hi(invValue[8], mod[6]);
    accLow += invValue[9]*mod[5];
    accHi += mul_hi(invValue[9], mod[5]);
    op[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[6]*mod[9];
    accHi += mul_hi(invValue[6], mod[9]);
    accLow += invValue[7]*mod[8];
    accHi += mul_hi(invValue[7], mod[8]);
    accLow += invValue[8]*mod[7];
    accHi += mul_hi(invValue[8], mod[7]);
    accLow += invValue[9]*mod[6];
    accHi += mul_hi(invValue[9], mod[6]);
    op[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[7]*mod[9];
    accHi += mul_hi(invValue[7], mod[9]);
    accLow += invValue[8]*mod[8];
    accHi += mul_hi(invValue[8], mod[8]);
    accLow += invValue[9]*mod[7];
    accHi += mul_hi(invValue[9], mod[7]);
    op[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[8]*mod[9];
    accHi += mul_hi(invValue[8], mod[9]);
    accLow += invValue[9]*mod[8];
    accHi += mul_hi(invValue[9], mod[8]);
    op[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[9]*mod[9];
    accHi += mul_hi(invValue[9], mod[9]);
    op[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  op[9] = accLow;
  Int.v64 = accLow;
  if (Int.v32.y)
    sub(op, mod, 10);
}
void mulProductScan320to96(uint32_t *out, uint32_t *op1, uint32_t *op2)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
//   {
//     accLow += op1[9]*op2[2];
//     accHi += mul_hi(op1[9], op2[2]);
//     out[11] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   out[12] = accLow;
}
void mulProductScan320to128(uint32_t *out, uint32_t *op1, uint32_t *op2)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[3];
    accHi += mul_hi(op1[0], op2[3]);
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[3];
    accHi += mul_hi(op1[1], op2[3]);
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[3];
    accHi += mul_hi(op1[2], op2[3]);
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[3];
    accHi += mul_hi(op1[3], op2[3]);
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[3];
    accHi += mul_hi(op1[4], op2[3]);
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[3];
    accHi += mul_hi(op1[5], op2[3]);
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*op2[3];
    accHi += mul_hi(op1[6], op2[3]);
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[7]*op2[3];
    accHi += mul_hi(op1[7], op2[3]);
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
//   {
//     accLow += op1[8]*op2[3];
//     accHi += mul_hi(op1[8], op2[3]);
//     accLow += op1[9]*op2[2];
//     accHi += mul_hi(op1[9], op2[2]);
//     out[11] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   {
//     accLow += op1[9]*op2[3];
//     accHi += mul_hi(op1[9], op2[3]);
//     out[12] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   out[13] = accLow;
}
void mulProductScan320to192(uint32_t *out, uint32_t *op1, uint32_t *op2)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[3];
    accHi += mul_hi(op1[0], op2[3]);
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[4];
    accHi += mul_hi(op1[0], op2[4]);
    accLow += op1[1]*op2[3];
    accHi += mul_hi(op1[1], op2[3]);
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[5];
    accHi += mul_hi(op1[0], op2[5]);
    accLow += op1[1]*op2[4];
    accHi += mul_hi(op1[1], op2[4]);
    accLow += op1[2]*op2[3];
    accHi += mul_hi(op1[2], op2[3]);
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[5];
    accHi += mul_hi(op1[1], op2[5]);
    accLow += op1[2]*op2[4];
    accHi += mul_hi(op1[2], op2[4]);
    accLow += op1[3]*op2[3];
    accHi += mul_hi(op1[3], op2[3]);
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[5];
    accHi += mul_hi(op1[2], op2[5]);
    accLow += op1[3]*op2[4];
    accHi += mul_hi(op1[3], op2[4]);
    accLow += op1[4]*op2[3];
    accHi += mul_hi(op1[4], op2[3]);
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[5];
    accHi += mul_hi(op1[3], op2[5]);
    accLow += op1[4]*op2[4];
    accHi += mul_hi(op1[4], op2[4]);
    accLow += op1[5]*op2[3];
    accHi += mul_hi(op1[5], op2[3]);
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[5];
    accHi += mul_hi(op1[4], op2[5]);
    accLow += op1[5]*op2[4];
    accHi += mul_hi(op1[5], op2[4]);
    accLow += op1[6]*op2[3];
    accHi += mul_hi(op1[6], op2[3]);
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[5];
    accHi += mul_hi(op1[5], op2[5]);
    accLow += op1[6]*op2[4];
    accHi += mul_hi(op1[6], op2[4]);
    accLow += op1[7]*op2[3];
    accHi += mul_hi(op1[7], op2[3]);
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
//   {
//     accLow += op1[6]*op2[5];
//     accHi += mul_hi(op1[6], op2[5]);
//     accLow += op1[7]*op2[4];
//     accHi += mul_hi(op1[7], op2[4]);
//     accLow += op1[8]*op2[3];
//     accHi += mul_hi(op1[8], op2[3]);
//     accLow += op1[9]*op2[2];
//     accHi += mul_hi(op1[9], op2[2]);
//     out[11] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   {
//     accLow += op1[7]*op2[5];
//     accHi += mul_hi(op1[7], op2[5]);
//     accLow += op1[8]*op2[4];
//     accHi += mul_hi(op1[8], op2[4]);
//     accLow += op1[9]*op2[3];
//     accHi += mul_hi(op1[9], op2[3]);
//     out[12] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   {
//     accLow += op1[8]*op2[5];
//     accHi += mul_hi(op1[8], op2[5]);
//     accLow += op1[9]*op2[4];
//     accHi += mul_hi(op1[9], op2[4]);
//     out[13] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   {
//     accLow += op1[9]*op2[5];
//     accHi += mul_hi(op1[9], op2[5]);
//     out[14] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   out[15] = accLow;
}
void monSqr352(uint32_t *op, uint32_t *mod, uint32_t invm)
{
  uint32_t invValue[11];
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op[0]*op[0];
    accHi += mul_hi(op[0], op[0]);
    invValue[0] = invm * (uint32_t)accLow;
    accLow += invValue[0]*mod[0];
    accHi += mul_hi(invValue[0], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[1];
    uint32_t hi0 = mul_hi(op[0], op[1]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += invValue[0]*mod[1];
    accHi += mul_hi(invValue[0], mod[1]);
    invValue[1] = invm * (uint32_t)accLow;
    accLow += invValue[1]*mod[0];
    accHi += mul_hi(invValue[1], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[2];
    uint32_t hi0 = mul_hi(op[0], op[2]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += op[1]*op[1];
    accHi += mul_hi(op[1], op[1]);
    accLow += invValue[0]*mod[2];
    accHi += mul_hi(invValue[0], mod[2]);
    accLow += invValue[1]*mod[1];
    accHi += mul_hi(invValue[1], mod[1]);
    invValue[2] = invm * (uint32_t)accLow;
    accLow += invValue[2]*mod[0];
    accHi += mul_hi(invValue[2], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[3];
    uint32_t hi0 = mul_hi(op[0], op[3]);
    uint32_t low1 = op[1]*op[2];
    uint32_t hi1 = mul_hi(op[1], op[2]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += invValue[0]*mod[3];
    accHi += mul_hi(invValue[0], mod[3]);
    accLow += invValue[1]*mod[2];
    accHi += mul_hi(invValue[1], mod[2]);
    accLow += invValue[2]*mod[1];
    accHi += mul_hi(invValue[2], mod[1]);
    invValue[3] = invm * (uint32_t)accLow;
    accLow += invValue[3]*mod[0];
    accHi += mul_hi(invValue[3], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[4];
    uint32_t hi0 = mul_hi(op[0], op[4]);
    uint32_t low1 = op[1]*op[3];
    uint32_t hi1 = mul_hi(op[1], op[3]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += op[2]*op[2];
    accHi += mul_hi(op[2], op[2]);
    accLow += invValue[0]*mod[4];
    accHi += mul_hi(invValue[0], mod[4]);
    accLow += invValue[1]*mod[3];
    accHi += mul_hi(invValue[1], mod[3]);
    accLow += invValue[2]*mod[2];
    accHi += mul_hi(invValue[2], mod[2]);
    accLow += invValue[3]*mod[1];
    accHi += mul_hi(invValue[3], mod[1]);
    invValue[4] = invm * (uint32_t)accLow;
    accLow += invValue[4]*mod[0];
    accHi += mul_hi(invValue[4], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[5];
    uint32_t hi0 = mul_hi(op[0], op[5]);
    uint32_t low1 = op[1]*op[4];
    uint32_t hi1 = mul_hi(op[1], op[4]);
    uint32_t low2 = op[2]*op[3];
    uint32_t hi2 = mul_hi(op[2], op[3]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += invValue[0]*mod[5];
    accHi += mul_hi(invValue[0], mod[5]);
    accLow += invValue[1]*mod[4];
    accHi += mul_hi(invValue[1], mod[4]);
    accLow += invValue[2]*mod[3];
    accHi += mul_hi(invValue[2], mod[3]);
    accLow += invValue[3]*mod[2];
    accHi += mul_hi(invValue[3], mod[2]);
    accLow += invValue[4]*mod[1];
    accHi += mul_hi(invValue[4], mod[1]);
    invValue[5] = invm * (uint32_t)accLow;
    accLow += invValue[5]*mod[0];
    accHi += mul_hi(invValue[5], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[6];
    uint32_t hi0 = mul_hi(op[0], op[6]);
    uint32_t low1 = op[1]*op[5];
    uint32_t hi1 = mul_hi(op[1], op[5]);
    uint32_t low2 = op[2]*op[4];
    uint32_t hi2 = mul_hi(op[2], op[4]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += op[3]*op[3];
    accHi += mul_hi(op[3], op[3]);
    accLow += invValue[0]*mod[6];
    accHi += mul_hi(invValue[0], mod[6]);
    accLow += invValue[1]*mod[5];
    accHi += mul_hi(invValue[1], mod[5]);
    accLow += invValue[2]*mod[4];
    accHi += mul_hi(invValue[2], mod[4]);
    accLow += invValue[3]*mod[3];
    accHi += mul_hi(invValue[3], mod[3]);
    accLow += invValue[4]*mod[2];
    accHi += mul_hi(invValue[4], mod[2]);
    accLow += invValue[5]*mod[1];
    accHi += mul_hi(invValue[5], mod[1]);
    invValue[6] = invm * (uint32_t)accLow;
    accLow += invValue[6]*mod[0];
    accHi += mul_hi(invValue[6], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[7];
    uint32_t hi0 = mul_hi(op[0], op[7]);
    uint32_t low1 = op[1]*op[6];
    uint32_t hi1 = mul_hi(op[1], op[6]);
    uint32_t low2 = op[2]*op[5];
    uint32_t hi2 = mul_hi(op[2], op[5]);
    uint32_t low3 = op[3]*op[4];
    uint32_t hi3 = mul_hi(op[3], op[4]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += invValue[0]*mod[7];
    accHi += mul_hi(invValue[0], mod[7]);
    accLow += invValue[1]*mod[6];
    accHi += mul_hi(invValue[1], mod[6]);
    accLow += invValue[2]*mod[5];
    accHi += mul_hi(invValue[2], mod[5]);
    accLow += invValue[3]*mod[4];
    accHi += mul_hi(invValue[3], mod[4]);
    accLow += invValue[4]*mod[3];
    accHi += mul_hi(invValue[4], mod[3]);
    accLow += invValue[5]*mod[2];
    accHi += mul_hi(invValue[5], mod[2]);
    accLow += invValue[6]*mod[1];
    accHi += mul_hi(invValue[6], mod[1]);
    invValue[7] = invm * (uint32_t)accLow;
    accLow += invValue[7]*mod[0];
    accHi += mul_hi(invValue[7], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[8];
    uint32_t hi0 = mul_hi(op[0], op[8]);
    uint32_t low1 = op[1]*op[7];
    uint32_t hi1 = mul_hi(op[1], op[7]);
    uint32_t low2 = op[2]*op[6];
    uint32_t hi2 = mul_hi(op[2], op[6]);
    uint32_t low3 = op[3]*op[5];
    uint32_t hi3 = mul_hi(op[3], op[5]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += op[4]*op[4];
    accHi += mul_hi(op[4], op[4]);
    accLow += invValue[0]*mod[8];
    accHi += mul_hi(invValue[0], mod[8]);
    accLow += invValue[1]*mod[7];
    accHi += mul_hi(invValue[1], mod[7]);
    accLow += invValue[2]*mod[6];
    accHi += mul_hi(invValue[2], mod[6]);
    accLow += invValue[3]*mod[5];
    accHi += mul_hi(invValue[3], mod[5]);
    accLow += invValue[4]*mod[4];
    accHi += mul_hi(invValue[4], mod[4]);
    accLow += invValue[5]*mod[3];
    accHi += mul_hi(invValue[5], mod[3]);
    accLow += invValue[6]*mod[2];
    accHi += mul_hi(invValue[6], mod[2]);
    accLow += invValue[7]*mod[1];
    accHi += mul_hi(invValue[7], mod[1]);
    invValue[8] = invm * (uint32_t)accLow;
    accLow += invValue[8]*mod[0];
    accHi += mul_hi(invValue[8], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[9];
    uint32_t hi0 = mul_hi(op[0], op[9]);
    uint32_t low1 = op[1]*op[8];
    uint32_t hi1 = mul_hi(op[1], op[8]);
    uint32_t low2 = op[2]*op[7];
    uint32_t hi2 = mul_hi(op[2], op[7]);
    uint32_t low3 = op[3]*op[6];
    uint32_t hi3 = mul_hi(op[3], op[6]);
    uint32_t low4 = op[4]*op[5];
    uint32_t hi4 = mul_hi(op[4], op[5]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += low4; accLow += low4;
    accHi += hi4; accHi += hi4;
    accLow += invValue[0]*mod[9];
    accHi += mul_hi(invValue[0], mod[9]);
    accLow += invValue[1]*mod[8];
    accHi += mul_hi(invValue[1], mod[8]);
    accLow += invValue[2]*mod[7];
    accHi += mul_hi(invValue[2], mod[7]);
    accLow += invValue[3]*mod[6];
    accHi += mul_hi(invValue[3], mod[6]);
    accLow += invValue[4]*mod[5];
    accHi += mul_hi(invValue[4], mod[5]);
    accLow += invValue[5]*mod[4];
    accHi += mul_hi(invValue[5], mod[4]);
    accLow += invValue[6]*mod[3];
    accHi += mul_hi(invValue[6], mod[3]);
    accLow += invValue[7]*mod[2];
    accHi += mul_hi(invValue[7], mod[2]);
    accLow += invValue[8]*mod[1];
    accHi += mul_hi(invValue[8], mod[1]);
    invValue[9] = invm * (uint32_t)accLow;
    accLow += invValue[9]*mod[0];
    accHi += mul_hi(invValue[9], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[10];
    uint32_t hi0 = mul_hi(op[0], op[10]);
    uint32_t low1 = op[1]*op[9];
    uint32_t hi1 = mul_hi(op[1], op[9]);
    uint32_t low2 = op[2]*op[8];
    uint32_t hi2 = mul_hi(op[2], op[8]);
    uint32_t low3 = op[3]*op[7];
    uint32_t hi3 = mul_hi(op[3], op[7]);
    uint32_t low4 = op[4]*op[6];
    uint32_t hi4 = mul_hi(op[4], op[6]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += low4; accLow += low4;
    accHi += hi4; accHi += hi4;
    accLow += op[5]*op[5];
    accHi += mul_hi(op[5], op[5]);
    accLow += invValue[0]*mod[10];
    accHi += mul_hi(invValue[0], mod[10]);
    accLow += invValue[1]*mod[9];
    accHi += mul_hi(invValue[1], mod[9]);
    accLow += invValue[2]*mod[8];
    accHi += mul_hi(invValue[2], mod[8]);
    accLow += invValue[3]*mod[7];
    accHi += mul_hi(invValue[3], mod[7]);
    accLow += invValue[4]*mod[6];
    accHi += mul_hi(invValue[4], mod[6]);
    accLow += invValue[5]*mod[5];
    accHi += mul_hi(invValue[5], mod[5]);
    accLow += invValue[6]*mod[4];
    accHi += mul_hi(invValue[6], mod[4]);
    accLow += invValue[7]*mod[3];
    accHi += mul_hi(invValue[7], mod[3]);
    accLow += invValue[8]*mod[2];
    accHi += mul_hi(invValue[8], mod[2]);
    accLow += invValue[9]*mod[1];
    accHi += mul_hi(invValue[9], mod[1]);
    invValue[10] = invm * (uint32_t)accLow;
    accLow += invValue[10]*mod[0];
    accHi += mul_hi(invValue[10], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[1]*op[10];
    uint32_t hi0 = mul_hi(op[1], op[10]);
    uint32_t low1 = op[2]*op[9];
    uint32_t hi1 = mul_hi(op[2], op[9]);
    uint32_t low2 = op[3]*op[8];
    uint32_t hi2 = mul_hi(op[3], op[8]);
    uint32_t low3 = op[4]*op[7];
    uint32_t hi3 = mul_hi(op[4], op[7]);
    uint32_t low4 = op[5]*op[6];
    uint32_t hi4 = mul_hi(op[5], op[6]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += low4; accLow += low4;
    accHi += hi4; accHi += hi4;
    accLow += invValue[1]*mod[10];
    accHi += mul_hi(invValue[1], mod[10]);
    accLow += invValue[2]*mod[9];
    accHi += mul_hi(invValue[2], mod[9]);
    accLow += invValue[3]*mod[8];
    accHi += mul_hi(invValue[3], mod[8]);
    accLow += invValue[4]*mod[7];
    accHi += mul_hi(invValue[4], mod[7]);
    accLow += invValue[5]*mod[6];
    accHi += mul_hi(invValue[5], mod[6]);
    accLow += invValue[6]*mod[5];
    accHi += mul_hi(invValue[6], mod[5]);
    accLow += invValue[7]*mod[4];
    accHi += mul_hi(invValue[7], mod[4]);
    accLow += invValue[8]*mod[3];
    accHi += mul_hi(invValue[8], mod[3]);
    accLow += invValue[9]*mod[2];
    accHi += mul_hi(invValue[9], mod[2]);
    accLow += invValue[10]*mod[1];
    accHi += mul_hi(invValue[10], mod[1]);
    op[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[2]*op[10];
    uint32_t hi0 = mul_hi(op[2], op[10]);
    uint32_t low1 = op[3]*op[9];
    uint32_t hi1 = mul_hi(op[3], op[9]);
    uint32_t low2 = op[4]*op[8];
    uint32_t hi2 = mul_hi(op[4], op[8]);
    uint32_t low3 = op[5]*op[7];
    uint32_t hi3 = mul_hi(op[5], op[7]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += op[6]*op[6];
    accHi += mul_hi(op[6], op[6]);
    accLow += invValue[2]*mod[10];
    accHi += mul_hi(invValue[2], mod[10]);
    accLow += invValue[3]*mod[9];
    accHi += mul_hi(invValue[3], mod[9]);
    accLow += invValue[4]*mod[8];
    accHi += mul_hi(invValue[4], mod[8]);
    accLow += invValue[5]*mod[7];
    accHi += mul_hi(invValue[5], mod[7]);
    accLow += invValue[6]*mod[6];
    accHi += mul_hi(invValue[6], mod[6]);
    accLow += invValue[7]*mod[5];
    accHi += mul_hi(invValue[7], mod[5]);
    accLow += invValue[8]*mod[4];
    accHi += mul_hi(invValue[8], mod[4]);
    accLow += invValue[9]*mod[3];
    accHi += mul_hi(invValue[9], mod[3]);
    accLow += invValue[10]*mod[2];
    accHi += mul_hi(invValue[10], mod[2]);
    op[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[3]*op[10];
    uint32_t hi0 = mul_hi(op[3], op[10]);
    uint32_t low1 = op[4]*op[9];
    uint32_t hi1 = mul_hi(op[4], op[9]);
    uint32_t low2 = op[5]*op[8];
    uint32_t hi2 = mul_hi(op[5], op[8]);
    uint32_t low3 = op[6]*op[7];
    uint32_t hi3 = mul_hi(op[6], op[7]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += invValue[3]*mod[10];
    accHi += mul_hi(invValue[3], mod[10]);
    accLow += invValue[4]*mod[9];
    accHi += mul_hi(invValue[4], mod[9]);
    accLow += invValue[5]*mod[8];
    accHi += mul_hi(invValue[5], mod[8]);
    accLow += invValue[6]*mod[7];
    accHi += mul_hi(invValue[6], mod[7]);
    accLow += invValue[7]*mod[6];
    accHi += mul_hi(invValue[7], mod[6]);
    accLow += invValue[8]*mod[5];
    accHi += mul_hi(invValue[8], mod[5]);
    accLow += invValue[9]*mod[4];
    accHi += mul_hi(invValue[9], mod[4]);
    accLow += invValue[10]*mod[3];
    accHi += mul_hi(invValue[10], mod[3]);
    op[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[4]*op[10];
    uint32_t hi0 = mul_hi(op[4], op[10]);
    uint32_t low1 = op[5]*op[9];
    uint32_t hi1 = mul_hi(op[5], op[9]);
    uint32_t low2 = op[6]*op[8];
    uint32_t hi2 = mul_hi(op[6], op[8]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += op[7]*op[7];
    accHi += mul_hi(op[7], op[7]);
    accLow += invValue[4]*mod[10];
    accHi += mul_hi(invValue[4], mod[10]);
    accLow += invValue[5]*mod[9];
    accHi += mul_hi(invValue[5], mod[9]);
    accLow += invValue[6]*mod[8];
    accHi += mul_hi(invValue[6], mod[8]);
    accLow += invValue[7]*mod[7];
    accHi += mul_hi(invValue[7], mod[7]);
    accLow += invValue[8]*mod[6];
    accHi += mul_hi(invValue[8], mod[6]);
    accLow += invValue[9]*mod[5];
    accHi += mul_hi(invValue[9], mod[5]);
    accLow += invValue[10]*mod[4];
    accHi += mul_hi(invValue[10], mod[4]);
    op[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[5]*op[10];
    uint32_t hi0 = mul_hi(op[5], op[10]);
    uint32_t low1 = op[6]*op[9];
    uint32_t hi1 = mul_hi(op[6], op[9]);
    uint32_t low2 = op[7]*op[8];
    uint32_t hi2 = mul_hi(op[7], op[8]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += invValue[5]*mod[10];
    accHi += mul_hi(invValue[5], mod[10]);
    accLow += invValue[6]*mod[9];
    accHi += mul_hi(invValue[6], mod[9]);
    accLow += invValue[7]*mod[8];
    accHi += mul_hi(invValue[7], mod[8]);
    accLow += invValue[8]*mod[7];
    accHi += mul_hi(invValue[8], mod[7]);
    accLow += invValue[9]*mod[6];
    accHi += mul_hi(invValue[9], mod[6]);
    accLow += invValue[10]*mod[5];
    accHi += mul_hi(invValue[10], mod[5]);
    op[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[6]*op[10];
    uint32_t hi0 = mul_hi(op[6], op[10]);
    uint32_t low1 = op[7]*op[9];
    uint32_t hi1 = mul_hi(op[7], op[9]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += op[8]*op[8];
    accHi += mul_hi(op[8], op[8]);
    accLow += invValue[6]*mod[10];
    accHi += mul_hi(invValue[6], mod[10]);
    accLow += invValue[7]*mod[9];
    accHi += mul_hi(invValue[7], mod[9]);
    accLow += invValue[8]*mod[8];
    accHi += mul_hi(invValue[8], mod[8]);
    accLow += invValue[9]*mod[7];
    accHi += mul_hi(invValue[9], mod[7]);
    accLow += invValue[10]*mod[6];
    accHi += mul_hi(invValue[10], mod[6]);
    op[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[7]*op[10];
    uint32_t hi0 = mul_hi(op[7], op[10]);
    uint32_t low1 = op[8]*op[9];
    uint32_t hi1 = mul_hi(op[8], op[9]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += invValue[7]*mod[10];
    accHi += mul_hi(invValue[7], mod[10]);
    accLow += invValue[8]*mod[9];
    accHi += mul_hi(invValue[8], mod[9]);
    accLow += invValue[9]*mod[8];
    accHi += mul_hi(invValue[9], mod[8]);
    accLow += invValue[10]*mod[7];
    accHi += mul_hi(invValue[10], mod[7]);
    op[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[8]*op[10];
    uint32_t hi0 = mul_hi(op[8], op[10]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += op[9]*op[9];
    accHi += mul_hi(op[9], op[9]);
    accLow += invValue[8]*mod[10];
    accHi += mul_hi(invValue[8], mod[10]);
    accLow += invValue[9]*mod[9];
    accHi += mul_hi(invValue[9], mod[9]);
    accLow += invValue[10]*mod[8];
    accHi += mul_hi(invValue[10], mod[8]);
    op[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[9]*op[10];
    uint32_t hi0 = mul_hi(op[9], op[10]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += invValue[9]*mod[10];
    accHi += mul_hi(invValue[9], mod[10]);
    accLow += invValue[10]*mod[9];
    accHi += mul_hi(invValue[10], mod[9]);
    op[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op[10]*op[10];
    accHi += mul_hi(op[10], op[10]);
    accLow += invValue[10]*mod[10];
    accHi += mul_hi(invValue[10], mod[10]);
    op[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  op[10] = accLow;
  Int.v64 = accLow;
  if (Int.v32.y)
    sub(op, mod, 11);
}
void monMul352(uint32_t *op1, uint32_t *op2, uint32_t *mod, uint32_t invm)
{
  uint32_t invValue[11];
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    invValue[0] = invm * (uint32_t)accLow;
    accLow += invValue[0]*mod[0];
    accHi += mul_hi(invValue[0], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    accLow += invValue[0]*mod[1];
    accHi += mul_hi(invValue[0], mod[1]);
    invValue[1] = invm * (uint32_t)accLow;
    accLow += invValue[1]*mod[0];
    accHi += mul_hi(invValue[1], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    accLow += invValue[0]*mod[2];
    accHi += mul_hi(invValue[0], mod[2]);
    accLow += invValue[1]*mod[1];
    accHi += mul_hi(invValue[1], mod[1]);
    invValue[2] = invm * (uint32_t)accLow;
    accLow += invValue[2]*mod[0];
    accHi += mul_hi(invValue[2], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[3];
    accHi += mul_hi(op1[0], op2[3]);
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    accLow += invValue[0]*mod[3];
    accHi += mul_hi(invValue[0], mod[3]);
    accLow += invValue[1]*mod[2];
    accHi += mul_hi(invValue[1], mod[2]);
    accLow += invValue[2]*mod[1];
    accHi += mul_hi(invValue[2], mod[1]);
    invValue[3] = invm * (uint32_t)accLow;
    accLow += invValue[3]*mod[0];
    accHi += mul_hi(invValue[3], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[4];
    accHi += mul_hi(op1[0], op2[4]);
    accLow += op1[1]*op2[3];
    accHi += mul_hi(op1[1], op2[3]);
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    accLow += invValue[0]*mod[4];
    accHi += mul_hi(invValue[0], mod[4]);
    accLow += invValue[1]*mod[3];
    accHi += mul_hi(invValue[1], mod[3]);
    accLow += invValue[2]*mod[2];
    accHi += mul_hi(invValue[2], mod[2]);
    accLow += invValue[3]*mod[1];
    accHi += mul_hi(invValue[3], mod[1]);
    invValue[4] = invm * (uint32_t)accLow;
    accLow += invValue[4]*mod[0];
    accHi += mul_hi(invValue[4], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[5];
    accHi += mul_hi(op1[0], op2[5]);
    accLow += op1[1]*op2[4];
    accHi += mul_hi(op1[1], op2[4]);
    accLow += op1[2]*op2[3];
    accHi += mul_hi(op1[2], op2[3]);
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    accLow += invValue[0]*mod[5];
    accHi += mul_hi(invValue[0], mod[5]);
    accLow += invValue[1]*mod[4];
    accHi += mul_hi(invValue[1], mod[4]);
    accLow += invValue[2]*mod[3];
    accHi += mul_hi(invValue[2], mod[3]);
    accLow += invValue[3]*mod[2];
    accHi += mul_hi(invValue[3], mod[2]);
    accLow += invValue[4]*mod[1];
    accHi += mul_hi(invValue[4], mod[1]);
    invValue[5] = invm * (uint32_t)accLow;
    accLow += invValue[5]*mod[0];
    accHi += mul_hi(invValue[5], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[6];
    accHi += mul_hi(op1[0], op2[6]);
    accLow += op1[1]*op2[5];
    accHi += mul_hi(op1[1], op2[5]);
    accLow += op1[2]*op2[4];
    accHi += mul_hi(op1[2], op2[4]);
    accLow += op1[3]*op2[3];
    accHi += mul_hi(op1[3], op2[3]);
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    accLow += invValue[0]*mod[6];
    accHi += mul_hi(invValue[0], mod[6]);
    accLow += invValue[1]*mod[5];
    accHi += mul_hi(invValue[1], mod[5]);
    accLow += invValue[2]*mod[4];
    accHi += mul_hi(invValue[2], mod[4]);
    accLow += invValue[3]*mod[3];
    accHi += mul_hi(invValue[3], mod[3]);
    accLow += invValue[4]*mod[2];
    accHi += mul_hi(invValue[4], mod[2]);
    accLow += invValue[5]*mod[1];
    accHi += mul_hi(invValue[5], mod[1]);
    invValue[6] = invm * (uint32_t)accLow;
    accLow += invValue[6]*mod[0];
    accHi += mul_hi(invValue[6], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[7];
    accHi += mul_hi(op1[0], op2[7]);
    accLow += op1[1]*op2[6];
    accHi += mul_hi(op1[1], op2[6]);
    accLow += op1[2]*op2[5];
    accHi += mul_hi(op1[2], op2[5]);
    accLow += op1[3]*op2[4];
    accHi += mul_hi(op1[3], op2[4]);
    accLow += op1[4]*op2[3];
    accHi += mul_hi(op1[4], op2[3]);
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    accLow += invValue[0]*mod[7];
    accHi += mul_hi(invValue[0], mod[7]);
    accLow += invValue[1]*mod[6];
    accHi += mul_hi(invValue[1], mod[6]);
    accLow += invValue[2]*mod[5];
    accHi += mul_hi(invValue[2], mod[5]);
    accLow += invValue[3]*mod[4];
    accHi += mul_hi(invValue[3], mod[4]);
    accLow += invValue[4]*mod[3];
    accHi += mul_hi(invValue[4], mod[3]);
    accLow += invValue[5]*mod[2];
    accHi += mul_hi(invValue[5], mod[2]);
    accLow += invValue[6]*mod[1];
    accHi += mul_hi(invValue[6], mod[1]);
    invValue[7] = invm * (uint32_t)accLow;
    accLow += invValue[7]*mod[0];
    accHi += mul_hi(invValue[7], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[8];
    accHi += mul_hi(op1[0], op2[8]);
    accLow += op1[1]*op2[7];
    accHi += mul_hi(op1[1], op2[7]);
    accLow += op1[2]*op2[6];
    accHi += mul_hi(op1[2], op2[6]);
    accLow += op1[3]*op2[5];
    accHi += mul_hi(op1[3], op2[5]);
    accLow += op1[4]*op2[4];
    accHi += mul_hi(op1[4], op2[4]);
    accLow += op1[5]*op2[3];
    accHi += mul_hi(op1[5], op2[3]);
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    accLow += invValue[0]*mod[8];
    accHi += mul_hi(invValue[0], mod[8]);
    accLow += invValue[1]*mod[7];
    accHi += mul_hi(invValue[1], mod[7]);
    accLow += invValue[2]*mod[6];
    accHi += mul_hi(invValue[2], mod[6]);
    accLow += invValue[3]*mod[5];
    accHi += mul_hi(invValue[3], mod[5]);
    accLow += invValue[4]*mod[4];
    accHi += mul_hi(invValue[4], mod[4]);
    accLow += invValue[5]*mod[3];
    accHi += mul_hi(invValue[5], mod[3]);
    accLow += invValue[6]*mod[2];
    accHi += mul_hi(invValue[6], mod[2]);
    accLow += invValue[7]*mod[1];
    accHi += mul_hi(invValue[7], mod[1]);
    invValue[8] = invm * (uint32_t)accLow;
    accLow += invValue[8]*mod[0];
    accHi += mul_hi(invValue[8], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[9];
    accHi += mul_hi(op1[0], op2[9]);
    accLow += op1[1]*op2[8];
    accHi += mul_hi(op1[1], op2[8]);
    accLow += op1[2]*op2[7];
    accHi += mul_hi(op1[2], op2[7]);
    accLow += op1[3]*op2[6];
    accHi += mul_hi(op1[3], op2[6]);
    accLow += op1[4]*op2[5];
    accHi += mul_hi(op1[4], op2[5]);
    accLow += op1[5]*op2[4];
    accHi += mul_hi(op1[5], op2[4]);
    accLow += op1[6]*op2[3];
    accHi += mul_hi(op1[6], op2[3]);
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    accLow += invValue[0]*mod[9];
    accHi += mul_hi(invValue[0], mod[9]);
    accLow += invValue[1]*mod[8];
    accHi += mul_hi(invValue[1], mod[8]);
    accLow += invValue[2]*mod[7];
    accHi += mul_hi(invValue[2], mod[7]);
    accLow += invValue[3]*mod[6];
    accHi += mul_hi(invValue[3], mod[6]);
    accLow += invValue[4]*mod[5];
    accHi += mul_hi(invValue[4], mod[5]);
    accLow += invValue[5]*mod[4];
    accHi += mul_hi(invValue[5], mod[4]);
    accLow += invValue[6]*mod[3];
    accHi += mul_hi(invValue[6], mod[3]);
    accLow += invValue[7]*mod[2];
    accHi += mul_hi(invValue[7], mod[2]);
    accLow += invValue[8]*mod[1];
    accHi += mul_hi(invValue[8], mod[1]);
    invValue[9] = invm * (uint32_t)accLow;
    accLow += invValue[9]*mod[0];
    accHi += mul_hi(invValue[9], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[10];
    accHi += mul_hi(op1[0], op2[10]);
    accLow += op1[1]*op2[9];
    accHi += mul_hi(op1[1], op2[9]);
    accLow += op1[2]*op2[8];
    accHi += mul_hi(op1[2], op2[8]);
    accLow += op1[3]*op2[7];
    accHi += mul_hi(op1[3], op2[7]);
    accLow += op1[4]*op2[6];
    accHi += mul_hi(op1[4], op2[6]);
    accLow += op1[5]*op2[5];
    accHi += mul_hi(op1[5], op2[5]);
    accLow += op1[6]*op2[4];
    accHi += mul_hi(op1[6], op2[4]);
    accLow += op1[7]*op2[3];
    accHi += mul_hi(op1[7], op2[3]);
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    accLow += op1[10]*op2[0];
    accHi += mul_hi(op1[10], op2[0]);
    accLow += invValue[0]*mod[10];
    accHi += mul_hi(invValue[0], mod[10]);
    accLow += invValue[1]*mod[9];
    accHi += mul_hi(invValue[1], mod[9]);
    accLow += invValue[2]*mod[8];
    accHi += mul_hi(invValue[2], mod[8]);
    accLow += invValue[3]*mod[7];
    accHi += mul_hi(invValue[3], mod[7]);
    accLow += invValue[4]*mod[6];
    accHi += mul_hi(invValue[4], mod[6]);
    accLow += invValue[5]*mod[5];
    accHi += mul_hi(invValue[5], mod[5]);
    accLow += invValue[6]*mod[4];
    accHi += mul_hi(invValue[6], mod[4]);
    accLow += invValue[7]*mod[3];
    accHi += mul_hi(invValue[7], mod[3]);
    accLow += invValue[8]*mod[2];
    accHi += mul_hi(invValue[8], mod[2]);
    accLow += invValue[9]*mod[1];
    accHi += mul_hi(invValue[9], mod[1]);
    invValue[10] = invm * (uint32_t)accLow;
    accLow += invValue[10]*mod[0];
    accHi += mul_hi(invValue[10], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[10];
    accHi += mul_hi(op1[1], op2[10]);
    accLow += op1[2]*op2[9];
    accHi += mul_hi(op1[2], op2[9]);
    accLow += op1[3]*op2[8];
    accHi += mul_hi(op1[3], op2[8]);
    accLow += op1[4]*op2[7];
    accHi += mul_hi(op1[4], op2[7]);
    accLow += op1[5]*op2[6];
    accHi += mul_hi(op1[5], op2[6]);
    accLow += op1[6]*op2[5];
    accHi += mul_hi(op1[6], op2[5]);
    accLow += op1[7]*op2[4];
    accHi += mul_hi(op1[7], op2[4]);
    accLow += op1[8]*op2[3];
    accHi += mul_hi(op1[8], op2[3]);
    accLow += op1[9]*op2[2];
    accHi += mul_hi(op1[9], op2[2]);
    accLow += op1[10]*op2[1];
    accHi += mul_hi(op1[10], op2[1]);
    accLow += invValue[1]*mod[10];
    accHi += mul_hi(invValue[1], mod[10]);
    accLow += invValue[2]*mod[9];
    accHi += mul_hi(invValue[2], mod[9]);
    accLow += invValue[3]*mod[8];
    accHi += mul_hi(invValue[3], mod[8]);
    accLow += invValue[4]*mod[7];
    accHi += mul_hi(invValue[4], mod[7]);
    accLow += invValue[5]*mod[6];
    accHi += mul_hi(invValue[5], mod[6]);
    accLow += invValue[6]*mod[5];
    accHi += mul_hi(invValue[6], mod[5]);
    accLow += invValue[7]*mod[4];
    accHi += mul_hi(invValue[7], mod[4]);
    accLow += invValue[8]*mod[3];
    accHi += mul_hi(invValue[8], mod[3]);
    accLow += invValue[9]*mod[2];
    accHi += mul_hi(invValue[9], mod[2]);
    accLow += invValue[10]*mod[1];
    accHi += mul_hi(invValue[10], mod[1]);
    op1[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[10];
    accHi += mul_hi(op1[2], op2[10]);
    accLow += op1[3]*op2[9];
    accHi += mul_hi(op1[3], op2[9]);
    accLow += op1[4]*op2[8];
    accHi += mul_hi(op1[4], op2[8]);
    accLow += op1[5]*op2[7];
    accHi += mul_hi(op1[5], op2[7]);
    accLow += op1[6]*op2[6];
    accHi += mul_hi(op1[6], op2[6]);
    accLow += op1[7]*op2[5];
    accHi += mul_hi(op1[7], op2[5]);
    accLow += op1[8]*op2[4];
    accHi += mul_hi(op1[8], op2[4]);
    accLow += op1[9]*op2[3];
    accHi += mul_hi(op1[9], op2[3]);
    accLow += op1[10]*op2[2];
    accHi += mul_hi(op1[10], op2[2]);
    accLow += invValue[2]*mod[10];
    accHi += mul_hi(invValue[2], mod[10]);
    accLow += invValue[3]*mod[9];
    accHi += mul_hi(invValue[3], mod[9]);
    accLow += invValue[4]*mod[8];
    accHi += mul_hi(invValue[4], mod[8]);
    accLow += invValue[5]*mod[7];
    accHi += mul_hi(invValue[5], mod[7]);
    accLow += invValue[6]*mod[6];
    accHi += mul_hi(invValue[6], mod[6]);
    accLow += invValue[7]*mod[5];
    accHi += mul_hi(invValue[7], mod[5]);
    accLow += invValue[8]*mod[4];
    accHi += mul_hi(invValue[8], mod[4]);
    accLow += invValue[9]*mod[3];
    accHi += mul_hi(invValue[9], mod[3]);
    accLow += invValue[10]*mod[2];
    accHi += mul_hi(invValue[10], mod[2]);
    op1[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[10];
    accHi += mul_hi(op1[3], op2[10]);
    accLow += op1[4]*op2[9];
    accHi += mul_hi(op1[4], op2[9]);
    accLow += op1[5]*op2[8];
    accHi += mul_hi(op1[5], op2[8]);
    accLow += op1[6]*op2[7];
    accHi += mul_hi(op1[6], op2[7]);
    accLow += op1[7]*op2[6];
    accHi += mul_hi(op1[7], op2[6]);
    accLow += op1[8]*op2[5];
    accHi += mul_hi(op1[8], op2[5]);
    accLow += op1[9]*op2[4];
    accHi += mul_hi(op1[9], op2[4]);
    accLow += op1[10]*op2[3];
    accHi += mul_hi(op1[10], op2[3]);
    accLow += invValue[3]*mod[10];
    accHi += mul_hi(invValue[3], mod[10]);
    accLow += invValue[4]*mod[9];
    accHi += mul_hi(invValue[4], mod[9]);
    accLow += invValue[5]*mod[8];
    accHi += mul_hi(invValue[5], mod[8]);
    accLow += invValue[6]*mod[7];
    accHi += mul_hi(invValue[6], mod[7]);
    accLow += invValue[7]*mod[6];
    accHi += mul_hi(invValue[7], mod[6]);
    accLow += invValue[8]*mod[5];
    accHi += mul_hi(invValue[8], mod[5]);
    accLow += invValue[9]*mod[4];
    accHi += mul_hi(invValue[9], mod[4]);
    accLow += invValue[10]*mod[3];
    accHi += mul_hi(invValue[10], mod[3]);
    op1[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[10];
    accHi += mul_hi(op1[4], op2[10]);
    accLow += op1[5]*op2[9];
    accHi += mul_hi(op1[5], op2[9]);
    accLow += op1[6]*op2[8];
    accHi += mul_hi(op1[6], op2[8]);
    accLow += op1[7]*op2[7];
    accHi += mul_hi(op1[7], op2[7]);
    accLow += op1[8]*op2[6];
    accHi += mul_hi(op1[8], op2[6]);
    accLow += op1[9]*op2[5];
    accHi += mul_hi(op1[9], op2[5]);
    accLow += op1[10]*op2[4];
    accHi += mul_hi(op1[10], op2[4]);
    accLow += invValue[4]*mod[10];
    accHi += mul_hi(invValue[4], mod[10]);
    accLow += invValue[5]*mod[9];
    accHi += mul_hi(invValue[5], mod[9]);
    accLow += invValue[6]*mod[8];
    accHi += mul_hi(invValue[6], mod[8]);
    accLow += invValue[7]*mod[7];
    accHi += mul_hi(invValue[7], mod[7]);
    accLow += invValue[8]*mod[6];
    accHi += mul_hi(invValue[8], mod[6]);
    accLow += invValue[9]*mod[5];
    accHi += mul_hi(invValue[9], mod[5]);
    accLow += invValue[10]*mod[4];
    accHi += mul_hi(invValue[10], mod[4]);
    op1[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[10];
    accHi += mul_hi(op1[5], op2[10]);
    accLow += op1[6]*op2[9];
    accHi += mul_hi(op1[6], op2[9]);
    accLow += op1[7]*op2[8];
    accHi += mul_hi(op1[7], op2[8]);
    accLow += op1[8]*op2[7];
    accHi += mul_hi(op1[8], op2[7]);
    accLow += op1[9]*op2[6];
    accHi += mul_hi(op1[9], op2[6]);
    accLow += op1[10]*op2[5];
    accHi += mul_hi(op1[10], op2[5]);
    accLow += invValue[5]*mod[10];
    accHi += mul_hi(invValue[5], mod[10]);
    accLow += invValue[6]*mod[9];
    accHi += mul_hi(invValue[6], mod[9]);
    accLow += invValue[7]*mod[8];
    accHi += mul_hi(invValue[7], mod[8]);
    accLow += invValue[8]*mod[7];
    accHi += mul_hi(invValue[8], mod[7]);
    accLow += invValue[9]*mod[6];
    accHi += mul_hi(invValue[9], mod[6]);
    accLow += invValue[10]*mod[5];
    accHi += mul_hi(invValue[10], mod[5]);
    op1[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*op2[10];
    accHi += mul_hi(op1[6], op2[10]);
    accLow += op1[7]*op2[9];
    accHi += mul_hi(op1[7], op2[9]);
    accLow += op1[8]*op2[8];
    accHi += mul_hi(op1[8], op2[8]);
    accLow += op1[9]*op2[7];
    accHi += mul_hi(op1[9], op2[7]);
    accLow += op1[10]*op2[6];
    accHi += mul_hi(op1[10], op2[6]);
    accLow += invValue[6]*mod[10];
    accHi += mul_hi(invValue[6], mod[10]);
    accLow += invValue[7]*mod[9];
    accHi += mul_hi(invValue[7], mod[9]);
    accLow += invValue[8]*mod[8];
    accHi += mul_hi(invValue[8], mod[8]);
    accLow += invValue[9]*mod[7];
    accHi += mul_hi(invValue[9], mod[7]);
    accLow += invValue[10]*mod[6];
    accHi += mul_hi(invValue[10], mod[6]);
    op1[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[7]*op2[10];
    accHi += mul_hi(op1[7], op2[10]);
    accLow += op1[8]*op2[9];
    accHi += mul_hi(op1[8], op2[9]);
    accLow += op1[9]*op2[8];
    accHi += mul_hi(op1[9], op2[8]);
    accLow += op1[10]*op2[7];
    accHi += mul_hi(op1[10], op2[7]);
    accLow += invValue[7]*mod[10];
    accHi += mul_hi(invValue[7], mod[10]);
    accLow += invValue[8]*mod[9];
    accHi += mul_hi(invValue[8], mod[9]);
    accLow += invValue[9]*mod[8];
    accHi += mul_hi(invValue[9], mod[8]);
    accLow += invValue[10]*mod[7];
    accHi += mul_hi(invValue[10], mod[7]);
    op1[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[8]*op2[10];
    accHi += mul_hi(op1[8], op2[10]);
    accLow += op1[9]*op2[9];
    accHi += mul_hi(op1[9], op2[9]);
    accLow += op1[10]*op2[8];
    accHi += mul_hi(op1[10], op2[8]);
    accLow += invValue[8]*mod[10];
    accHi += mul_hi(invValue[8], mod[10]);
    accLow += invValue[9]*mod[9];
    accHi += mul_hi(invValue[9], mod[9]);
    accLow += invValue[10]*mod[8];
    accHi += mul_hi(invValue[10], mod[8]);
    op1[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[9]*op2[10];
    accHi += mul_hi(op1[9], op2[10]);
    accLow += op1[10]*op2[9];
    accHi += mul_hi(op1[10], op2[9]);
    accLow += invValue[9]*mod[10];
    accHi += mul_hi(invValue[9], mod[10]);
    accLow += invValue[10]*mod[9];
    accHi += mul_hi(invValue[10], mod[9]);
    op1[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[10]*op2[10];
    accHi += mul_hi(op1[10], op2[10]);
    accLow += invValue[10]*mod[10];
    accHi += mul_hi(invValue[10], mod[10]);
    op1[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  op1[10] = accLow;
  Int.v64 = accLow;
  if (Int.v32.y)
    sub(op1, mod, 11);
}
void redcHalf352(uint32_t *op, uint32_t *mod, uint32_t invm)
{
  uint32_t invValue[11];
  uint64_t accLow = op[0], accHi = op[1];
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    invValue[0] = invm * (uint32_t)accLow;
    accLow += invValue[0]*mod[0];
    accHi += mul_hi(invValue[0], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[2];
  }
  {
    accLow += invValue[0]*mod[1];
    accHi += mul_hi(invValue[0], mod[1]);
    invValue[1] = invm * (uint32_t)accLow;
    accLow += invValue[1]*mod[0];
    accHi += mul_hi(invValue[1], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[3];
  }
  {
    accLow += invValue[0]*mod[2];
    accHi += mul_hi(invValue[0], mod[2]);
    accLow += invValue[1]*mod[1];
    accHi += mul_hi(invValue[1], mod[1]);
    invValue[2] = invm * (uint32_t)accLow;
    accLow += invValue[2]*mod[0];
    accHi += mul_hi(invValue[2], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[4];
  }
  {
    accLow += invValue[0]*mod[3];
    accHi += mul_hi(invValue[0], mod[3]);
    accLow += invValue[1]*mod[2];
    accHi += mul_hi(invValue[1], mod[2]);
    accLow += invValue[2]*mod[1];
    accHi += mul_hi(invValue[2], mod[1]);
    invValue[3] = invm * (uint32_t)accLow;
    accLow += invValue[3]*mod[0];
    accHi += mul_hi(invValue[3], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[5];
  }
  {
    accLow += invValue[0]*mod[4];
    accHi += mul_hi(invValue[0], mod[4]);
    accLow += invValue[1]*mod[3];
    accHi += mul_hi(invValue[1], mod[3]);
    accLow += invValue[2]*mod[2];
    accHi += mul_hi(invValue[2], mod[2]);
    accLow += invValue[3]*mod[1];
    accHi += mul_hi(invValue[3], mod[1]);
    invValue[4] = invm * (uint32_t)accLow;
    accLow += invValue[4]*mod[0];
    accHi += mul_hi(invValue[4], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[6];
  }
  {
    accLow += invValue[0]*mod[5];
    accHi += mul_hi(invValue[0], mod[5]);
    accLow += invValue[1]*mod[4];
    accHi += mul_hi(invValue[1], mod[4]);
    accLow += invValue[2]*mod[3];
    accHi += mul_hi(invValue[2], mod[3]);
    accLow += invValue[3]*mod[2];
    accHi += mul_hi(invValue[3], mod[2]);
    accLow += invValue[4]*mod[1];
    accHi += mul_hi(invValue[4], mod[1]);
    invValue[5] = invm * (uint32_t)accLow;
    accLow += invValue[5]*mod[0];
    accHi += mul_hi(invValue[5], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[7];
  }
  {
    accLow += invValue[0]*mod[6];
    accHi += mul_hi(invValue[0], mod[6]);
    accLow += invValue[1]*mod[5];
    accHi += mul_hi(invValue[1], mod[5]);
    accLow += invValue[2]*mod[4];
    accHi += mul_hi(invValue[2], mod[4]);
    accLow += invValue[3]*mod[3];
    accHi += mul_hi(invValue[3], mod[3]);
    accLow += invValue[4]*mod[2];
    accHi += mul_hi(invValue[4], mod[2]);
    accLow += invValue[5]*mod[1];
    accHi += mul_hi(invValue[5], mod[1]);
    invValue[6] = invm * (uint32_t)accLow;
    accLow += invValue[6]*mod[0];
    accHi += mul_hi(invValue[6], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[8];
  }
  {
    accLow += invValue[0]*mod[7];
    accHi += mul_hi(invValue[0], mod[7]);
    accLow += invValue[1]*mod[6];
    accHi += mul_hi(invValue[1], mod[6]);
    accLow += invValue[2]*mod[5];
    accHi += mul_hi(invValue[2], mod[5]);
    accLow += invValue[3]*mod[4];
    accHi += mul_hi(invValue[3], mod[4]);
    accLow += invValue[4]*mod[3];
    accHi += mul_hi(invValue[4], mod[3]);
    accLow += invValue[5]*mod[2];
    accHi += mul_hi(invValue[5], mod[2]);
    accLow += invValue[6]*mod[1];
    accHi += mul_hi(invValue[6], mod[1]);
    invValue[7] = invm * (uint32_t)accLow;
    accLow += invValue[7]*mod[0];
    accHi += mul_hi(invValue[7], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[9];
  }
  {
    accLow += invValue[0]*mod[8];
    accHi += mul_hi(invValue[0], mod[8]);
    accLow += invValue[1]*mod[7];
    accHi += mul_hi(invValue[1], mod[7]);
    accLow += invValue[2]*mod[6];
    accHi += mul_hi(invValue[2], mod[6]);
    accLow += invValue[3]*mod[5];
    accHi += mul_hi(invValue[3], mod[5]);
    accLow += invValue[4]*mod[4];
    accHi += mul_hi(invValue[4], mod[4]);
    accLow += invValue[5]*mod[3];
    accHi += mul_hi(invValue[5], mod[3]);
    accLow += invValue[6]*mod[2];
    accHi += mul_hi(invValue[6], mod[2]);
    accLow += invValue[7]*mod[1];
    accHi += mul_hi(invValue[7], mod[1]);
    invValue[8] = invm * (uint32_t)accLow;
    accLow += invValue[8]*mod[0];
    accHi += mul_hi(invValue[8], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = op[10];
  }
  {
    accLow += invValue[0]*mod[9];
    accHi += mul_hi(invValue[0], mod[9]);
    accLow += invValue[1]*mod[8];
    accHi += mul_hi(invValue[1], mod[8]);
    accLow += invValue[2]*mod[7];
    accHi += mul_hi(invValue[2], mod[7]);
    accLow += invValue[3]*mod[6];
    accHi += mul_hi(invValue[3], mod[6]);
    accLow += invValue[4]*mod[5];
    accHi += mul_hi(invValue[4], mod[5]);
    accLow += invValue[5]*mod[4];
    accHi += mul_hi(invValue[5], mod[4]);
    accLow += invValue[6]*mod[3];
    accHi += mul_hi(invValue[6], mod[3]);
    accLow += invValue[7]*mod[2];
    accHi += mul_hi(invValue[7], mod[2]);
    accLow += invValue[8]*mod[1];
    accHi += mul_hi(invValue[8], mod[1]);
    invValue[9] = invm * (uint32_t)accLow;
    accLow += invValue[9]*mod[0];
    accHi += mul_hi(invValue[9], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[0]*mod[10];
    accHi += mul_hi(invValue[0], mod[10]);
    accLow += invValue[1]*mod[9];
    accHi += mul_hi(invValue[1], mod[9]);
    accLow += invValue[2]*mod[8];
    accHi += mul_hi(invValue[2], mod[8]);
    accLow += invValue[3]*mod[7];
    accHi += mul_hi(invValue[3], mod[7]);
    accLow += invValue[4]*mod[6];
    accHi += mul_hi(invValue[4], mod[6]);
    accLow += invValue[5]*mod[5];
    accHi += mul_hi(invValue[5], mod[5]);
    accLow += invValue[6]*mod[4];
    accHi += mul_hi(invValue[6], mod[4]);
    accLow += invValue[7]*mod[3];
    accHi += mul_hi(invValue[7], mod[3]);
    accLow += invValue[8]*mod[2];
    accHi += mul_hi(invValue[8], mod[2]);
    accLow += invValue[9]*mod[1];
    accHi += mul_hi(invValue[9], mod[1]);
    invValue[10] = invm * (uint32_t)accLow;
    accLow += invValue[10]*mod[0];
    accHi += mul_hi(invValue[10], mod[0]);
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[1]*mod[10];
    accHi += mul_hi(invValue[1], mod[10]);
    accLow += invValue[2]*mod[9];
    accHi += mul_hi(invValue[2], mod[9]);
    accLow += invValue[3]*mod[8];
    accHi += mul_hi(invValue[3], mod[8]);
    accLow += invValue[4]*mod[7];
    accHi += mul_hi(invValue[4], mod[7]);
    accLow += invValue[5]*mod[6];
    accHi += mul_hi(invValue[5], mod[6]);
    accLow += invValue[6]*mod[5];
    accHi += mul_hi(invValue[6], mod[5]);
    accLow += invValue[7]*mod[4];
    accHi += mul_hi(invValue[7], mod[4]);
    accLow += invValue[8]*mod[3];
    accHi += mul_hi(invValue[8], mod[3]);
    accLow += invValue[9]*mod[2];
    accHi += mul_hi(invValue[9], mod[2]);
    accLow += invValue[10]*mod[1];
    accHi += mul_hi(invValue[10], mod[1]);
    op[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[2]*mod[10];
    accHi += mul_hi(invValue[2], mod[10]);
    accLow += invValue[3]*mod[9];
    accHi += mul_hi(invValue[3], mod[9]);
    accLow += invValue[4]*mod[8];
    accHi += mul_hi(invValue[4], mod[8]);
    accLow += invValue[5]*mod[7];
    accHi += mul_hi(invValue[5], mod[7]);
    accLow += invValue[6]*mod[6];
    accHi += mul_hi(invValue[6], mod[6]);
    accLow += invValue[7]*mod[5];
    accHi += mul_hi(invValue[7], mod[5]);
    accLow += invValue[8]*mod[4];
    accHi += mul_hi(invValue[8], mod[4]);
    accLow += invValue[9]*mod[3];
    accHi += mul_hi(invValue[9], mod[3]);
    accLow += invValue[10]*mod[2];
    accHi += mul_hi(invValue[10], mod[2]);
    op[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[3]*mod[10];
    accHi += mul_hi(invValue[3], mod[10]);
    accLow += invValue[4]*mod[9];
    accHi += mul_hi(invValue[4], mod[9]);
    accLow += invValue[5]*mod[8];
    accHi += mul_hi(invValue[5], mod[8]);
    accLow += invValue[6]*mod[7];
    accHi += mul_hi(invValue[6], mod[7]);
    accLow += invValue[7]*mod[6];
    accHi += mul_hi(invValue[7], mod[6]);
    accLow += invValue[8]*mod[5];
    accHi += mul_hi(invValue[8], mod[5]);
    accLow += invValue[9]*mod[4];
    accHi += mul_hi(invValue[9], mod[4]);
    accLow += invValue[10]*mod[3];
    accHi += mul_hi(invValue[10], mod[3]);
    op[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[4]*mod[10];
    accHi += mul_hi(invValue[4], mod[10]);
    accLow += invValue[5]*mod[9];
    accHi += mul_hi(invValue[5], mod[9]);
    accLow += invValue[6]*mod[8];
    accHi += mul_hi(invValue[6], mod[8]);
    accLow += invValue[7]*mod[7];
    accHi += mul_hi(invValue[7], mod[7]);
    accLow += invValue[8]*mod[6];
    accHi += mul_hi(invValue[8], mod[6]);
    accLow += invValue[9]*mod[5];
    accHi += mul_hi(invValue[9], mod[5]);
    accLow += invValue[10]*mod[4];
    accHi += mul_hi(invValue[10], mod[4]);
    op[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[5]*mod[10];
    accHi += mul_hi(invValue[5], mod[10]);
    accLow += invValue[6]*mod[9];
    accHi += mul_hi(invValue[6], mod[9]);
    accLow += invValue[7]*mod[8];
    accHi += mul_hi(invValue[7], mod[8]);
    accLow += invValue[8]*mod[7];
    accHi += mul_hi(invValue[8], mod[7]);
    accLow += invValue[9]*mod[6];
    accHi += mul_hi(invValue[9], mod[6]);
    accLow += invValue[10]*mod[5];
    accHi += mul_hi(invValue[10], mod[5]);
    op[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[6]*mod[10];
    accHi += mul_hi(invValue[6], mod[10]);
    accLow += invValue[7]*mod[9];
    accHi += mul_hi(invValue[7], mod[9]);
    accLow += invValue[8]*mod[8];
    accHi += mul_hi(invValue[8], mod[8]);
    accLow += invValue[9]*mod[7];
    accHi += mul_hi(invValue[9], mod[7]);
    accLow += invValue[10]*mod[6];
    accHi += mul_hi(invValue[10], mod[6]);
    op[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[7]*mod[10];
    accHi += mul_hi(invValue[7], mod[10]);
    accLow += invValue[8]*mod[9];
    accHi += mul_hi(invValue[8], mod[9]);
    accLow += invValue[9]*mod[8];
    accHi += mul_hi(invValue[9], mod[8]);
    accLow += invValue[10]*mod[7];
    accHi += mul_hi(invValue[10], mod[7]);
    op[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[8]*mod[10];
    accHi += mul_hi(invValue[8], mod[10]);
    accLow += invValue[9]*mod[9];
    accHi += mul_hi(invValue[9], mod[9]);
    accLow += invValue[10]*mod[8];
    accHi += mul_hi(invValue[10], mod[8]);
    op[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[9]*mod[10];
    accHi += mul_hi(invValue[9], mod[10]);
    accLow += invValue[10]*mod[9];
    accHi += mul_hi(invValue[10], mod[9]);
    op[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += invValue[10]*mod[10];
    accHi += mul_hi(invValue[10], mod[10]);
    op[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  op[10] = accLow;
  Int.v64 = accLow;
  if (Int.v32.y)
    sub(op, mod, 11);
}
void mulProductScan352to96(uint32_t *out, uint32_t *op1, uint32_t *op2)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    accLow += op1[10]*op2[0];
    accHi += mul_hi(op1[10], op2[0]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[9]*op2[2];
    accHi += mul_hi(op1[9], op2[2]);
    accLow += op1[10]*op2[1];
    accHi += mul_hi(op1[10], op2[1]);
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
//   {
//     accLow += op1[10]*op2[2];
//     accHi += mul_hi(op1[10], op2[2]);
//     out[12] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   out[13] = accLow;
}
void mulProductScan352to128(uint32_t *out, uint32_t *op1, uint32_t *op2)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[3];
    accHi += mul_hi(op1[0], op2[3]);
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[3];
    accHi += mul_hi(op1[1], op2[3]);
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[3];
    accHi += mul_hi(op1[2], op2[3]);
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[3];
    accHi += mul_hi(op1[3], op2[3]);
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[3];
    accHi += mul_hi(op1[4], op2[3]);
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[3];
    accHi += mul_hi(op1[5], op2[3]);
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*op2[3];
    accHi += mul_hi(op1[6], op2[3]);
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[7]*op2[3];
    accHi += mul_hi(op1[7], op2[3]);
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    accLow += op1[10]*op2[0];
    accHi += mul_hi(op1[10], op2[0]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[8]*op2[3];
    accHi += mul_hi(op1[8], op2[3]);
    accLow += op1[9]*op2[2];
    accHi += mul_hi(op1[9], op2[2]);
    accLow += op1[10]*op2[1];
    accHi += mul_hi(op1[10], op2[1]);
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
//   {
//     accLow += op1[9]*op2[3];
//     accHi += mul_hi(op1[9], op2[3]);
//     accLow += op1[10]*op2[2];
//     accHi += mul_hi(op1[10], op2[2]);
//     out[12] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   {
//     accLow += op1[10]*op2[3];
//     accHi += mul_hi(op1[10], op2[3]);
//     out[13] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   out[14] = accLow;
}
void mulProductScan352to192(uint32_t *out, uint32_t *op1, uint32_t *op2)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[3];
    accHi += mul_hi(op1[0], op2[3]);
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[4];
    accHi += mul_hi(op1[0], op2[4]);
    accLow += op1[1]*op2[3];
    accHi += mul_hi(op1[1], op2[3]);
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[5];
    accHi += mul_hi(op1[0], op2[5]);
    accLow += op1[1]*op2[4];
    accHi += mul_hi(op1[1], op2[4]);
    accLow += op1[2]*op2[3];
    accHi += mul_hi(op1[2], op2[3]);
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[5];
    accHi += mul_hi(op1[1], op2[5]);
    accLow += op1[2]*op2[4];
    accHi += mul_hi(op1[2], op2[4]);
    accLow += op1[3]*op2[3];
    accHi += mul_hi(op1[3], op2[3]);
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[5];
    accHi += mul_hi(op1[2], op2[5]);
    accLow += op1[3]*op2[4];
    accHi += mul_hi(op1[3], op2[4]);
    accLow += op1[4]*op2[3];
    accHi += mul_hi(op1[4], op2[3]);
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[5];
    accHi += mul_hi(op1[3], op2[5]);
    accLow += op1[4]*op2[4];
    accHi += mul_hi(op1[4], op2[4]);
    accLow += op1[5]*op2[3];
    accHi += mul_hi(op1[5], op2[3]);
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[5];
    accHi += mul_hi(op1[4], op2[5]);
    accLow += op1[5]*op2[4];
    accHi += mul_hi(op1[5], op2[4]);
    accLow += op1[6]*op2[3];
    accHi += mul_hi(op1[6], op2[3]);
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[5];
    accHi += mul_hi(op1[5], op2[5]);
    accLow += op1[6]*op2[4];
    accHi += mul_hi(op1[6], op2[4]);
    accLow += op1[7]*op2[3];
    accHi += mul_hi(op1[7], op2[3]);
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    accLow += op1[10]*op2[0];
    accHi += mul_hi(op1[10], op2[0]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*op2[5];
    accHi += mul_hi(op1[6], op2[5]);
    accLow += op1[7]*op2[4];
    accHi += mul_hi(op1[7], op2[4]);
    accLow += op1[8]*op2[3];
    accHi += mul_hi(op1[8], op2[3]);
    accLow += op1[9]*op2[2];
    accHi += mul_hi(op1[9], op2[2]);
    accLow += op1[10]*op2[1];
    accHi += mul_hi(op1[10], op2[1]);
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
//   {
//     accLow += op1[7]*op2[5];
//     accHi += mul_hi(op1[7], op2[5]);
//     accLow += op1[8]*op2[4];
//     accHi += mul_hi(op1[8], op2[4]);
//     accLow += op1[9]*op2[3];
//     accHi += mul_hi(op1[9], op2[3]);
//     accLow += op1[10]*op2[2];
//     accHi += mul_hi(op1[10], op2[2]);
//     out[12] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   {
//     accLow += op1[8]*op2[5];
//     accHi += mul_hi(op1[8], op2[5]);
//     accLow += op1[9]*op2[4];
//     accHi += mul_hi(op1[9], op2[4]);
//     accLow += op1[10]*op2[3];
//     accHi += mul_hi(op1[10], op2[3]);
//     out[13] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   {
//     accLow += op1[9]*op2[5];
//     accHi += mul_hi(op1[9], op2[5]);
//     accLow += op1[10]*op2[4];
//     accHi += mul_hi(op1[10], op2[4]);
//     out[14] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   {
//     accLow += op1[10]*op2[5];
//     accHi += mul_hi(op1[10], op2[5]);
//     out[15] = accLow;
//     Int.v64 = accLow;
//     accHi += Int.v32.y;
//     accLow = accHi;
//     accHi = 0;
//   }
//   out[16] = accLow;
}
sqrProductScan320(uint32_t *out, uint32_t *op)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op[0]*op[0];
    accHi += mul_hi(op[0], op[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[1];
    uint32_t hi0 = mul_hi(op[0], op[1]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[2];
    uint32_t hi0 = mul_hi(op[0], op[2]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += op[1]*op[1];
    accHi += mul_hi(op[1], op[1]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[3];
    uint32_t hi0 = mul_hi(op[0], op[3]);
    uint32_t low1 = op[1]*op[2];
    uint32_t hi1 = mul_hi(op[1], op[2]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[4];
    uint32_t hi0 = mul_hi(op[0], op[4]);
    uint32_t low1 = op[1]*op[3];
    uint32_t hi1 = mul_hi(op[1], op[3]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += op[2]*op[2];
    accHi += mul_hi(op[2], op[2]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[5];
    uint32_t hi0 = mul_hi(op[0], op[5]);
    uint32_t low1 = op[1]*op[4];
    uint32_t hi1 = mul_hi(op[1], op[4]);
    uint32_t low2 = op[2]*op[3];
    uint32_t hi2 = mul_hi(op[2], op[3]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[6];
    uint32_t hi0 = mul_hi(op[0], op[6]);
    uint32_t low1 = op[1]*op[5];
    uint32_t hi1 = mul_hi(op[1], op[5]);
    uint32_t low2 = op[2]*op[4];
    uint32_t hi2 = mul_hi(op[2], op[4]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += op[3]*op[3];
    accHi += mul_hi(op[3], op[3]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[7];
    uint32_t hi0 = mul_hi(op[0], op[7]);
    uint32_t low1 = op[1]*op[6];
    uint32_t hi1 = mul_hi(op[1], op[6]);
    uint32_t low2 = op[2]*op[5];
    uint32_t hi2 = mul_hi(op[2], op[5]);
    uint32_t low3 = op[3]*op[4];
    uint32_t hi3 = mul_hi(op[3], op[4]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[8];
    uint32_t hi0 = mul_hi(op[0], op[8]);
    uint32_t low1 = op[1]*op[7];
    uint32_t hi1 = mul_hi(op[1], op[7]);
    uint32_t low2 = op[2]*op[6];
    uint32_t hi2 = mul_hi(op[2], op[6]);
    uint32_t low3 = op[3]*op[5];
    uint32_t hi3 = mul_hi(op[3], op[5]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += op[4]*op[4];
    accHi += mul_hi(op[4], op[4]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[9];
    uint32_t hi0 = mul_hi(op[0], op[9]);
    uint32_t low1 = op[1]*op[8];
    uint32_t hi1 = mul_hi(op[1], op[8]);
    uint32_t low2 = op[2]*op[7];
    uint32_t hi2 = mul_hi(op[2], op[7]);
    uint32_t low3 = op[3]*op[6];
    uint32_t hi3 = mul_hi(op[3], op[6]);
    uint32_t low4 = op[4]*op[5];
    uint32_t hi4 = mul_hi(op[4], op[5]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += low4; accLow += low4;
    accHi += hi4; accHi += hi4;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[1]*op[9];
    uint32_t hi0 = mul_hi(op[1], op[9]);
    uint32_t low1 = op[2]*op[8];
    uint32_t hi1 = mul_hi(op[2], op[8]);
    uint32_t low2 = op[3]*op[7];
    uint32_t hi2 = mul_hi(op[3], op[7]);
    uint32_t low3 = op[4]*op[6];
    uint32_t hi3 = mul_hi(op[4], op[6]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += op[5]*op[5];
    accHi += mul_hi(op[5], op[5]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[2]*op[9];
    uint32_t hi0 = mul_hi(op[2], op[9]);
    uint32_t low1 = op[3]*op[8];
    uint32_t hi1 = mul_hi(op[3], op[8]);
    uint32_t low2 = op[4]*op[7];
    uint32_t hi2 = mul_hi(op[4], op[7]);
    uint32_t low3 = op[5]*op[6];
    uint32_t hi3 = mul_hi(op[5], op[6]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[3]*op[9];
    uint32_t hi0 = mul_hi(op[3], op[9]);
    uint32_t low1 = op[4]*op[8];
    uint32_t hi1 = mul_hi(op[4], op[8]);
    uint32_t low2 = op[5]*op[7];
    uint32_t hi2 = mul_hi(op[5], op[7]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += op[6]*op[6];
    accHi += mul_hi(op[6], op[6]);
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[4]*op[9];
    uint32_t hi0 = mul_hi(op[4], op[9]);
    uint32_t low1 = op[5]*op[8];
    uint32_t hi1 = mul_hi(op[5], op[8]);
    uint32_t low2 = op[6]*op[7];
    uint32_t hi2 = mul_hi(op[6], op[7]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[5]*op[9];
    uint32_t hi0 = mul_hi(op[5], op[9]);
    uint32_t low1 = op[6]*op[8];
    uint32_t hi1 = mul_hi(op[6], op[8]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += op[7]*op[7];
    accHi += mul_hi(op[7], op[7]);
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[6]*op[9];
    uint32_t hi0 = mul_hi(op[6], op[9]);
    uint32_t low1 = op[7]*op[8];
    uint32_t hi1 = mul_hi(op[7], op[8]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[7]*op[9];
    uint32_t hi0 = mul_hi(op[7], op[9]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += op[8]*op[8];
    accHi += mul_hi(op[8], op[8]);
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[8]*op[9];
    uint32_t hi0 = mul_hi(op[8], op[9]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op[9]*op[9];
    accHi += mul_hi(op[9], op[9]);
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[19] = accLow;
}
sqrProductScan352(uint32_t *out, uint32_t *op)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op[0]*op[0];
    accHi += mul_hi(op[0], op[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[1];
    uint32_t hi0 = mul_hi(op[0], op[1]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[2];
    uint32_t hi0 = mul_hi(op[0], op[2]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += op[1]*op[1];
    accHi += mul_hi(op[1], op[1]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[3];
    uint32_t hi0 = mul_hi(op[0], op[3]);
    uint32_t low1 = op[1]*op[2];
    uint32_t hi1 = mul_hi(op[1], op[2]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[4];
    uint32_t hi0 = mul_hi(op[0], op[4]);
    uint32_t low1 = op[1]*op[3];
    uint32_t hi1 = mul_hi(op[1], op[3]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += op[2]*op[2];
    accHi += mul_hi(op[2], op[2]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[5];
    uint32_t hi0 = mul_hi(op[0], op[5]);
    uint32_t low1 = op[1]*op[4];
    uint32_t hi1 = mul_hi(op[1], op[4]);
    uint32_t low2 = op[2]*op[3];
    uint32_t hi2 = mul_hi(op[2], op[3]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[6];
    uint32_t hi0 = mul_hi(op[0], op[6]);
    uint32_t low1 = op[1]*op[5];
    uint32_t hi1 = mul_hi(op[1], op[5]);
    uint32_t low2 = op[2]*op[4];
    uint32_t hi2 = mul_hi(op[2], op[4]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += op[3]*op[3];
    accHi += mul_hi(op[3], op[3]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[7];
    uint32_t hi0 = mul_hi(op[0], op[7]);
    uint32_t low1 = op[1]*op[6];
    uint32_t hi1 = mul_hi(op[1], op[6]);
    uint32_t low2 = op[2]*op[5];
    uint32_t hi2 = mul_hi(op[2], op[5]);
    uint32_t low3 = op[3]*op[4];
    uint32_t hi3 = mul_hi(op[3], op[4]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[8];
    uint32_t hi0 = mul_hi(op[0], op[8]);
    uint32_t low1 = op[1]*op[7];
    uint32_t hi1 = mul_hi(op[1], op[7]);
    uint32_t low2 = op[2]*op[6];
    uint32_t hi2 = mul_hi(op[2], op[6]);
    uint32_t low3 = op[3]*op[5];
    uint32_t hi3 = mul_hi(op[3], op[5]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += op[4]*op[4];
    accHi += mul_hi(op[4], op[4]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[9];
    uint32_t hi0 = mul_hi(op[0], op[9]);
    uint32_t low1 = op[1]*op[8];
    uint32_t hi1 = mul_hi(op[1], op[8]);
    uint32_t low2 = op[2]*op[7];
    uint32_t hi2 = mul_hi(op[2], op[7]);
    uint32_t low3 = op[3]*op[6];
    uint32_t hi3 = mul_hi(op[3], op[6]);
    uint32_t low4 = op[4]*op[5];
    uint32_t hi4 = mul_hi(op[4], op[5]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += low4; accLow += low4;
    accHi += hi4; accHi += hi4;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[0]*op[10];
    uint32_t hi0 = mul_hi(op[0], op[10]);
    uint32_t low1 = op[1]*op[9];
    uint32_t hi1 = mul_hi(op[1], op[9]);
    uint32_t low2 = op[2]*op[8];
    uint32_t hi2 = mul_hi(op[2], op[8]);
    uint32_t low3 = op[3]*op[7];
    uint32_t hi3 = mul_hi(op[3], op[7]);
    uint32_t low4 = op[4]*op[6];
    uint32_t hi4 = mul_hi(op[4], op[6]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += low4; accLow += low4;
    accHi += hi4; accHi += hi4;
    accLow += op[5]*op[5];
    accHi += mul_hi(op[5], op[5]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[1]*op[10];
    uint32_t hi0 = mul_hi(op[1], op[10]);
    uint32_t low1 = op[2]*op[9];
    uint32_t hi1 = mul_hi(op[2], op[9]);
    uint32_t low2 = op[3]*op[8];
    uint32_t hi2 = mul_hi(op[3], op[8]);
    uint32_t low3 = op[4]*op[7];
    uint32_t hi3 = mul_hi(op[4], op[7]);
    uint32_t low4 = op[5]*op[6];
    uint32_t hi4 = mul_hi(op[5], op[6]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += low4; accLow += low4;
    accHi += hi4; accHi += hi4;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[2]*op[10];
    uint32_t hi0 = mul_hi(op[2], op[10]);
    uint32_t low1 = op[3]*op[9];
    uint32_t hi1 = mul_hi(op[3], op[9]);
    uint32_t low2 = op[4]*op[8];
    uint32_t hi2 = mul_hi(op[4], op[8]);
    uint32_t low3 = op[5]*op[7];
    uint32_t hi3 = mul_hi(op[5], op[7]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    accLow += op[6]*op[6];
    accHi += mul_hi(op[6], op[6]);
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[3]*op[10];
    uint32_t hi0 = mul_hi(op[3], op[10]);
    uint32_t low1 = op[4]*op[9];
    uint32_t hi1 = mul_hi(op[4], op[9]);
    uint32_t low2 = op[5]*op[8];
    uint32_t hi2 = mul_hi(op[5], op[8]);
    uint32_t low3 = op[6]*op[7];
    uint32_t hi3 = mul_hi(op[6], op[7]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += low3; accLow += low3;
    accHi += hi3; accHi += hi3;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[4]*op[10];
    uint32_t hi0 = mul_hi(op[4], op[10]);
    uint32_t low1 = op[5]*op[9];
    uint32_t hi1 = mul_hi(op[5], op[9]);
    uint32_t low2 = op[6]*op[8];
    uint32_t hi2 = mul_hi(op[6], op[8]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    accLow += op[7]*op[7];
    accHi += mul_hi(op[7], op[7]);
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[5]*op[10];
    uint32_t hi0 = mul_hi(op[5], op[10]);
    uint32_t low1 = op[6]*op[9];
    uint32_t hi1 = mul_hi(op[6], op[9]);
    uint32_t low2 = op[7]*op[8];
    uint32_t hi2 = mul_hi(op[7], op[8]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += low2; accLow += low2;
    accHi += hi2; accHi += hi2;
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[6]*op[10];
    uint32_t hi0 = mul_hi(op[6], op[10]);
    uint32_t low1 = op[7]*op[9];
    uint32_t hi1 = mul_hi(op[7], op[9]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    accLow += op[8]*op[8];
    accHi += mul_hi(op[8], op[8]);
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[7]*op[10];
    uint32_t hi0 = mul_hi(op[7], op[10]);
    uint32_t low1 = op[8]*op[9];
    uint32_t hi1 = mul_hi(op[8], op[9]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += low1; accLow += low1;
    accHi += hi1; accHi += hi1;
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[8]*op[10];
    uint32_t hi0 = mul_hi(op[8], op[10]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    accLow += op[9]*op[9];
    accHi += mul_hi(op[9], op[9]);
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    uint32_t low0 = op[9]*op[10];
    uint32_t hi0 = mul_hi(op[9], op[10]);
    accLow += low0; accLow += low0;
    accHi += hi0; accHi += hi0;
    out[19] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op[10]*op[10];
    accHi += mul_hi(op[10], op[10]);
    out[20] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[21] = accLow;
}
void mulProductScan320to320(uint32_t *out, uint32_t *op1, uint32_t *op2)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[3];
    accHi += mul_hi(op1[0], op2[3]);
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[4];
    accHi += mul_hi(op1[0], op2[4]);
    accLow += op1[1]*op2[3];
    accHi += mul_hi(op1[1], op2[3]);
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[5];
    accHi += mul_hi(op1[0], op2[5]);
    accLow += op1[1]*op2[4];
    accHi += mul_hi(op1[1], op2[4]);
    accLow += op1[2]*op2[3];
    accHi += mul_hi(op1[2], op2[3]);
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[6];
    accHi += mul_hi(op1[0], op2[6]);
    accLow += op1[1]*op2[5];
    accHi += mul_hi(op1[1], op2[5]);
    accLow += op1[2]*op2[4];
    accHi += mul_hi(op1[2], op2[4]);
    accLow += op1[3]*op2[3];
    accHi += mul_hi(op1[3], op2[3]);
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[7];
    accHi += mul_hi(op1[0], op2[7]);
    accLow += op1[1]*op2[6];
    accHi += mul_hi(op1[1], op2[6]);
    accLow += op1[2]*op2[5];
    accHi += mul_hi(op1[2], op2[5]);
    accLow += op1[3]*op2[4];
    accHi += mul_hi(op1[3], op2[4]);
    accLow += op1[4]*op2[3];
    accHi += mul_hi(op1[4], op2[3]);
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[8];
    accHi += mul_hi(op1[0], op2[8]);
    accLow += op1[1]*op2[7];
    accHi += mul_hi(op1[1], op2[7]);
    accLow += op1[2]*op2[6];
    accHi += mul_hi(op1[2], op2[6]);
    accLow += op1[3]*op2[5];
    accHi += mul_hi(op1[3], op2[5]);
    accLow += op1[4]*op2[4];
    accHi += mul_hi(op1[4], op2[4]);
    accLow += op1[5]*op2[3];
    accHi += mul_hi(op1[5], op2[3]);
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[9];
    accHi += mul_hi(op1[0], op2[9]);
    accLow += op1[1]*op2[8];
    accHi += mul_hi(op1[1], op2[8]);
    accLow += op1[2]*op2[7];
    accHi += mul_hi(op1[2], op2[7]);
    accLow += op1[3]*op2[6];
    accHi += mul_hi(op1[3], op2[6]);
    accLow += op1[4]*op2[5];
    accHi += mul_hi(op1[4], op2[5]);
    accLow += op1[5]*op2[4];
    accHi += mul_hi(op1[5], op2[4]);
    accLow += op1[6]*op2[3];
    accHi += mul_hi(op1[6], op2[3]);
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[9];
    accHi += mul_hi(op1[1], op2[9]);
    accLow += op1[2]*op2[8];
    accHi += mul_hi(op1[2], op2[8]);
    accLow += op1[3]*op2[7];
    accHi += mul_hi(op1[3], op2[7]);
    accLow += op1[4]*op2[6];
    accHi += mul_hi(op1[4], op2[6]);
    accLow += op1[5]*op2[5];
    accHi += mul_hi(op1[5], op2[5]);
    accLow += op1[6]*op2[4];
    accHi += mul_hi(op1[6], op2[4]);
    accLow += op1[7]*op2[3];
    accHi += mul_hi(op1[7], op2[3]);
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[9];
    accHi += mul_hi(op1[2], op2[9]);
    accLow += op1[3]*op2[8];
    accHi += mul_hi(op1[3], op2[8]);
    accLow += op1[4]*op2[7];
    accHi += mul_hi(op1[4], op2[7]);
    accLow += op1[5]*op2[6];
    accHi += mul_hi(op1[5], op2[6]);
    accLow += op1[6]*op2[5];
    accHi += mul_hi(op1[6], op2[5]);
    accLow += op1[7]*op2[4];
    accHi += mul_hi(op1[7], op2[4]);
    accLow += op1[8]*op2[3];
    accHi += mul_hi(op1[8], op2[3]);
    accLow += op1[9]*op2[2];
    accHi += mul_hi(op1[9], op2[2]);
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[9];
    accHi += mul_hi(op1[3], op2[9]);
    accLow += op1[4]*op2[8];
    accHi += mul_hi(op1[4], op2[8]);
    accLow += op1[5]*op2[7];
    accHi += mul_hi(op1[5], op2[7]);
    accLow += op1[6]*op2[6];
    accHi += mul_hi(op1[6], op2[6]);
    accLow += op1[7]*op2[5];
    accHi += mul_hi(op1[7], op2[5]);
    accLow += op1[8]*op2[4];
    accHi += mul_hi(op1[8], op2[4]);
    accLow += op1[9]*op2[3];
    accHi += mul_hi(op1[9], op2[3]);
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[9];
    accHi += mul_hi(op1[4], op2[9]);
    accLow += op1[5]*op2[8];
    accHi += mul_hi(op1[5], op2[8]);
    accLow += op1[6]*op2[7];
    accHi += mul_hi(op1[6], op2[7]);
    accLow += op1[7]*op2[6];
    accHi += mul_hi(op1[7], op2[6]);
    accLow += op1[8]*op2[5];
    accHi += mul_hi(op1[8], op2[5]);
    accLow += op1[9]*op2[4];
    accHi += mul_hi(op1[9], op2[4]);
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[9];
    accHi += mul_hi(op1[5], op2[9]);
    accLow += op1[6]*op2[8];
    accHi += mul_hi(op1[6], op2[8]);
    accLow += op1[7]*op2[7];
    accHi += mul_hi(op1[7], op2[7]);
    accLow += op1[8]*op2[6];
    accHi += mul_hi(op1[8], op2[6]);
    accLow += op1[9]*op2[5];
    accHi += mul_hi(op1[9], op2[5]);
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*op2[9];
    accHi += mul_hi(op1[6], op2[9]);
    accLow += op1[7]*op2[8];
    accHi += mul_hi(op1[7], op2[8]);
    accLow += op1[8]*op2[7];
    accHi += mul_hi(op1[8], op2[7]);
    accLow += op1[9]*op2[6];
    accHi += mul_hi(op1[9], op2[6]);
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[7]*op2[9];
    accHi += mul_hi(op1[7], op2[9]);
    accLow += op1[8]*op2[8];
    accHi += mul_hi(op1[8], op2[8]);
    accLow += op1[9]*op2[7];
    accHi += mul_hi(op1[9], op2[7]);
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[8]*op2[9];
    accHi += mul_hi(op1[8], op2[9]);
    accLow += op1[9]*op2[8];
    accHi += mul_hi(op1[9], op2[8]);
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[9]*op2[9];
    accHi += mul_hi(op1[9], op2[9]);
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[19] = accLow;
}
void mulProductScan352to352(uint32_t *out, uint32_t *op1, uint32_t *op2)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*op2[0];
    accHi += mul_hi(op1[0], op2[0]);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[1];
    accHi += mul_hi(op1[0], op2[1]);
    accLow += op1[1]*op2[0];
    accHi += mul_hi(op1[1], op2[0]);
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[2];
    accHi += mul_hi(op1[0], op2[2]);
    accLow += op1[1]*op2[1];
    accHi += mul_hi(op1[1], op2[1]);
    accLow += op1[2]*op2[0];
    accHi += mul_hi(op1[2], op2[0]);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[3];
    accHi += mul_hi(op1[0], op2[3]);
    accLow += op1[1]*op2[2];
    accHi += mul_hi(op1[1], op2[2]);
    accLow += op1[2]*op2[1];
    accHi += mul_hi(op1[2], op2[1]);
    accLow += op1[3]*op2[0];
    accHi += mul_hi(op1[3], op2[0]);
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[4];
    accHi += mul_hi(op1[0], op2[4]);
    accLow += op1[1]*op2[3];
    accHi += mul_hi(op1[1], op2[3]);
    accLow += op1[2]*op2[2];
    accHi += mul_hi(op1[2], op2[2]);
    accLow += op1[3]*op2[1];
    accHi += mul_hi(op1[3], op2[1]);
    accLow += op1[4]*op2[0];
    accHi += mul_hi(op1[4], op2[0]);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[5];
    accHi += mul_hi(op1[0], op2[5]);
    accLow += op1[1]*op2[4];
    accHi += mul_hi(op1[1], op2[4]);
    accLow += op1[2]*op2[3];
    accHi += mul_hi(op1[2], op2[3]);
    accLow += op1[3]*op2[2];
    accHi += mul_hi(op1[3], op2[2]);
    accLow += op1[4]*op2[1];
    accHi += mul_hi(op1[4], op2[1]);
    accLow += op1[5]*op2[0];
    accHi += mul_hi(op1[5], op2[0]);
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[6];
    accHi += mul_hi(op1[0], op2[6]);
    accLow += op1[1]*op2[5];
    accHi += mul_hi(op1[1], op2[5]);
    accLow += op1[2]*op2[4];
    accHi += mul_hi(op1[2], op2[4]);
    accLow += op1[3]*op2[3];
    accHi += mul_hi(op1[3], op2[3]);
    accLow += op1[4]*op2[2];
    accHi += mul_hi(op1[4], op2[2]);
    accLow += op1[5]*op2[1];
    accHi += mul_hi(op1[5], op2[1]);
    accLow += op1[6]*op2[0];
    accHi += mul_hi(op1[6], op2[0]);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[7];
    accHi += mul_hi(op1[0], op2[7]);
    accLow += op1[1]*op2[6];
    accHi += mul_hi(op1[1], op2[6]);
    accLow += op1[2]*op2[5];
    accHi += mul_hi(op1[2], op2[5]);
    accLow += op1[3]*op2[4];
    accHi += mul_hi(op1[3], op2[4]);
    accLow += op1[4]*op2[3];
    accHi += mul_hi(op1[4], op2[3]);
    accLow += op1[5]*op2[2];
    accHi += mul_hi(op1[5], op2[2]);
    accLow += op1[6]*op2[1];
    accHi += mul_hi(op1[6], op2[1]);
    accLow += op1[7]*op2[0];
    accHi += mul_hi(op1[7], op2[0]);
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[8];
    accHi += mul_hi(op1[0], op2[8]);
    accLow += op1[1]*op2[7];
    accHi += mul_hi(op1[1], op2[7]);
    accLow += op1[2]*op2[6];
    accHi += mul_hi(op1[2], op2[6]);
    accLow += op1[3]*op2[5];
    accHi += mul_hi(op1[3], op2[5]);
    accLow += op1[4]*op2[4];
    accHi += mul_hi(op1[4], op2[4]);
    accLow += op1[5]*op2[3];
    accHi += mul_hi(op1[5], op2[3]);
    accLow += op1[6]*op2[2];
    accHi += mul_hi(op1[6], op2[2]);
    accLow += op1[7]*op2[1];
    accHi += mul_hi(op1[7], op2[1]);
    accLow += op1[8]*op2[0];
    accHi += mul_hi(op1[8], op2[0]);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[9];
    accHi += mul_hi(op1[0], op2[9]);
    accLow += op1[1]*op2[8];
    accHi += mul_hi(op1[1], op2[8]);
    accLow += op1[2]*op2[7];
    accHi += mul_hi(op1[2], op2[7]);
    accLow += op1[3]*op2[6];
    accHi += mul_hi(op1[3], op2[6]);
    accLow += op1[4]*op2[5];
    accHi += mul_hi(op1[4], op2[5]);
    accLow += op1[5]*op2[4];
    accHi += mul_hi(op1[5], op2[4]);
    accLow += op1[6]*op2[3];
    accHi += mul_hi(op1[6], op2[3]);
    accLow += op1[7]*op2[2];
    accHi += mul_hi(op1[7], op2[2]);
    accLow += op1[8]*op2[1];
    accHi += mul_hi(op1[8], op2[1]);
    accLow += op1[9]*op2[0];
    accHi += mul_hi(op1[9], op2[0]);
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[0]*op2[10];
    accHi += mul_hi(op1[0], op2[10]);
    accLow += op1[1]*op2[9];
    accHi += mul_hi(op1[1], op2[9]);
    accLow += op1[2]*op2[8];
    accHi += mul_hi(op1[2], op2[8]);
    accLow += op1[3]*op2[7];
    accHi += mul_hi(op1[3], op2[7]);
    accLow += op1[4]*op2[6];
    accHi += mul_hi(op1[4], op2[6]);
    accLow += op1[5]*op2[5];
    accHi += mul_hi(op1[5], op2[5]);
    accLow += op1[6]*op2[4];
    accHi += mul_hi(op1[6], op2[4]);
    accLow += op1[7]*op2[3];
    accHi += mul_hi(op1[7], op2[3]);
    accLow += op1[8]*op2[2];
    accHi += mul_hi(op1[8], op2[2]);
    accLow += op1[9]*op2[1];
    accHi += mul_hi(op1[9], op2[1]);
    accLow += op1[10]*op2[0];
    accHi += mul_hi(op1[10], op2[0]);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*op2[10];
    accHi += mul_hi(op1[1], op2[10]);
    accLow += op1[2]*op2[9];
    accHi += mul_hi(op1[2], op2[9]);
    accLow += op1[3]*op2[8];
    accHi += mul_hi(op1[3], op2[8]);
    accLow += op1[4]*op2[7];
    accHi += mul_hi(op1[4], op2[7]);
    accLow += op1[5]*op2[6];
    accHi += mul_hi(op1[5], op2[6]);
    accLow += op1[6]*op2[5];
    accHi += mul_hi(op1[6], op2[5]);
    accLow += op1[7]*op2[4];
    accHi += mul_hi(op1[7], op2[4]);
    accLow += op1[8]*op2[3];
    accHi += mul_hi(op1[8], op2[3]);
    accLow += op1[9]*op2[2];
    accHi += mul_hi(op1[9], op2[2]);
    accLow += op1[10]*op2[1];
    accHi += mul_hi(op1[10], op2[1]);
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*op2[10];
    accHi += mul_hi(op1[2], op2[10]);
    accLow += op1[3]*op2[9];
    accHi += mul_hi(op1[3], op2[9]);
    accLow += op1[4]*op2[8];
    accHi += mul_hi(op1[4], op2[8]);
    accLow += op1[5]*op2[7];
    accHi += mul_hi(op1[5], op2[7]);
    accLow += op1[6]*op2[6];
    accHi += mul_hi(op1[6], op2[6]);
    accLow += op1[7]*op2[5];
    accHi += mul_hi(op1[7], op2[5]);
    accLow += op1[8]*op2[4];
    accHi += mul_hi(op1[8], op2[4]);
    accLow += op1[9]*op2[3];
    accHi += mul_hi(op1[9], op2[3]);
    accLow += op1[10]*op2[2];
    accHi += mul_hi(op1[10], op2[2]);
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*op2[10];
    accHi += mul_hi(op1[3], op2[10]);
    accLow += op1[4]*op2[9];
    accHi += mul_hi(op1[4], op2[9]);
    accLow += op1[5]*op2[8];
    accHi += mul_hi(op1[5], op2[8]);
    accLow += op1[6]*op2[7];
    accHi += mul_hi(op1[6], op2[7]);
    accLow += op1[7]*op2[6];
    accHi += mul_hi(op1[7], op2[6]);
    accLow += op1[8]*op2[5];
    accHi += mul_hi(op1[8], op2[5]);
    accLow += op1[9]*op2[4];
    accHi += mul_hi(op1[9], op2[4]);
    accLow += op1[10]*op2[3];
    accHi += mul_hi(op1[10], op2[3]);
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*op2[10];
    accHi += mul_hi(op1[4], op2[10]);
    accLow += op1[5]*op2[9];
    accHi += mul_hi(op1[5], op2[9]);
    accLow += op1[6]*op2[8];
    accHi += mul_hi(op1[6], op2[8]);
    accLow += op1[7]*op2[7];
    accHi += mul_hi(op1[7], op2[7]);
    accLow += op1[8]*op2[6];
    accHi += mul_hi(op1[8], op2[6]);
    accLow += op1[9]*op2[5];
    accHi += mul_hi(op1[9], op2[5]);
    accLow += op1[10]*op2[4];
    accHi += mul_hi(op1[10], op2[4]);
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*op2[10];
    accHi += mul_hi(op1[5], op2[10]);
    accLow += op1[6]*op2[9];
    accHi += mul_hi(op1[6], op2[9]);
    accLow += op1[7]*op2[8];
    accHi += mul_hi(op1[7], op2[8]);
    accLow += op1[8]*op2[7];
    accHi += mul_hi(op1[8], op2[7]);
    accLow += op1[9]*op2[6];
    accHi += mul_hi(op1[9], op2[6]);
    accLow += op1[10]*op2[5];
    accHi += mul_hi(op1[10], op2[5]);
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*op2[10];
    accHi += mul_hi(op1[6], op2[10]);
    accLow += op1[7]*op2[9];
    accHi += mul_hi(op1[7], op2[9]);
    accLow += op1[8]*op2[8];
    accHi += mul_hi(op1[8], op2[8]);
    accLow += op1[9]*op2[7];
    accHi += mul_hi(op1[9], op2[7]);
    accLow += op1[10]*op2[6];
    accHi += mul_hi(op1[10], op2[6]);
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[7]*op2[10];
    accHi += mul_hi(op1[7], op2[10]);
    accLow += op1[8]*op2[9];
    accHi += mul_hi(op1[8], op2[9]);
    accLow += op1[9]*op2[8];
    accHi += mul_hi(op1[9], op2[8]);
    accLow += op1[10]*op2[7];
    accHi += mul_hi(op1[10], op2[7]);
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[8]*op2[10];
    accHi += mul_hi(op1[8], op2[10]);
    accLow += op1[9]*op2[9];
    accHi += mul_hi(op1[9], op2[9]);
    accLow += op1[10]*op2[8];
    accHi += mul_hi(op1[10], op2[8]);
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[9]*op2[10];
    accHi += mul_hi(op1[9], op2[10]);
    accLow += op1[10]*op2[9];
    accHi += mul_hi(op1[10], op2[9]);
    out[19] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[10]*op2[10];
    accHi += mul_hi(op1[10], op2[10]);
    out[20] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[21] = accLow;
}

void mulProductScan352to32(uint32_t *out, const uint32_t *op1, uint32_t M)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  {
    accLow += op1[0]*M;
    accHi += mul_hi(op1[0], M);
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[1]*M;
    accHi += mul_hi(op1[1], M);
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[2]*M;
    accHi += mul_hi(op1[2], M);
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[3]*M;
    accHi += mul_hi(op1[3], M);
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[4]*M;
    accHi += mul_hi(op1[4], M);
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[5]*M;
    accHi += mul_hi(op1[5], M);
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[6]*M;
    accHi += mul_hi(op1[6], M);
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[7]*M;
    accHi += mul_hi(op1[7], M);
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[8]*M;
    accHi += mul_hi(op1[8], M);
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[9]*M;
    accHi += mul_hi(op1[9], M);
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    accLow += op1[10]*M;
    accHi += mul_hi(op1[10], M);
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[11] = accLow;
}


unsigned divide512to352reg(uint32_t dv0, uint32_t dv1, uint32_t dv2, uint32_t dv3, uint32_t dv4, uint32_t dv5, uint32_t dv6, uint32_t dv7, uint32_t dv8, uint32_t dv9, uint32_t dv10, uint32_t dv11, uint32_t dv12, uint32_t dv13, uint32_t dv14, uint32_t dv15,
    uint32_t ds0, uint32_t ds1, uint32_t ds2, uint32_t ds3, uint32_t ds4, uint32_t ds5, uint32_t ds6, uint32_t ds7, uint32_t ds8, uint32_t ds9, uint32_t ds10,
    uint32_t *q0, uint32_t *q1, uint32_t *q2, uint32_t *q3, uint32_t *q4, uint32_t *q5, uint32_t *q6, uint32_t *q7)
{
  unsigned dividendSize = 16;
  unsigned divisorSize = 11;
  while (ds10 == 0) {
    ds10 = ds9;
    ds9 = ds8;
    ds8 = ds7;
    ds7 = ds6;
    ds6 = ds5;
    ds5 = ds4;
    ds4 = ds3;
    ds3 = ds2;
    ds2 = ds1;
    ds1 = ds0;
    ds0 = 0;
    divisorSize--;
  }

  unsigned shiftCount = clz(ds10);
  if (shiftCount) {
    ds10 = (ds10 << shiftCount) | (ds9 >> (32-shiftCount));
    ds9 = (ds9 << shiftCount) | (ds8 >> (32-shiftCount));
    ds8 = (ds8 << shiftCount) | (ds7 >> (32-shiftCount));
    ds7 = (ds7 << shiftCount) | (ds6 >> (32-shiftCount));
    ds6 = (ds6 << shiftCount) | (ds5 >> (32-shiftCount));
    ds5 = (ds5 << shiftCount) | (ds4 >> (32-shiftCount));
    ds4 = (ds4 << shiftCount) | (ds3 >> (32-shiftCount));
    ds3 = (ds3 << shiftCount) | (ds2 >> (32-shiftCount));
    ds2 = (ds2 << shiftCount) | (ds1 >> (32-shiftCount));
    ds1 = (ds1 << shiftCount) | (ds0 >> (32-shiftCount));
    ds0 = ds0 << shiftCount;
    dv15 = (dv15 << shiftCount) | (dv14 >> (32-shiftCount));
  }

  unsigned cyclesNum = min(dividendSize-divisorSize, 8u);
  for (unsigned i = 0; i < cyclesNum; i++) {
    uint32_t i32quotient = 0;
    if (dv15 == ds10) {
      i32quotient = 0xFFFFFFFF;
    } else {
      uint64_t i64dividend = (((uint64_t)dv15) << 32) | dv14;
      i32quotient = i64dividend / ds10;
    }

    {
      uint32_t carry0;
      uint32_t carry1;
      uint32_t lo;
      uint32_t hi;
      lo = ds0*i32quotient;
      carry0 = dv4 < lo;
      dv4 -= lo;
      hi = mul_hi(ds0, i32quotient);
      lo = ds1 * i32quotient;
      carry1 = dv5 < hi; dv5 -= hi;
      carry1 += dv5 < lo; dv5 -= lo;
      carry1 += dv5 < carry0; dv5 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds1, i32quotient);
      lo = ds2 * i32quotient;
      carry1 = dv6 < hi; dv6 -= hi;
      carry1 += dv6 < lo; dv6 -= lo;
      carry1 += dv6 < carry0; dv6 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds2, i32quotient);
      lo = ds3 * i32quotient;
      carry1 = dv7 < hi; dv7 -= hi;
      carry1 += dv7 < lo; dv7 -= lo;
      carry1 += dv7 < carry0; dv7 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds3, i32quotient);
      lo = ds4 * i32quotient;
      carry1 = dv8 < hi; dv8 -= hi;
      carry1 += dv8 < lo; dv8 -= lo;
      carry1 += dv8 < carry0; dv8 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds4, i32quotient);
      lo = ds5 * i32quotient;
      carry1 = dv9 < hi; dv9 -= hi;
      carry1 += dv9 < lo; dv9 -= lo;
      carry1 += dv9 < carry0; dv9 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds5, i32quotient);
      lo = ds6 * i32quotient;
      carry1 = dv10 < hi; dv10 -= hi;
      carry1 += dv10 < lo; dv10 -= lo;
      carry1 += dv10 < carry0; dv10 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds6, i32quotient);
      lo = ds7 * i32quotient;
      carry1 = dv11 < hi; dv11 -= hi;
      carry1 += dv11 < lo; dv11 -= lo;
      carry1 += dv11 < carry0; dv11 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds7, i32quotient);
      lo = ds8 * i32quotient;
      carry1 = dv12 < hi; dv12 -= hi;
      carry1 += dv12 < lo; dv12 -= lo;
      carry1 += dv12 < carry0; dv12 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds8, i32quotient);
      lo = ds9 * i32quotient;
      carry1 = dv13 < hi; dv13 -= hi;
      carry1 += dv13 < lo; dv13 -= lo;
      carry1 += dv13 < carry0; dv13 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds9, i32quotient);
      lo = ds10 * i32quotient;
      carry1 = dv14 < hi; dv14 -= hi;
      carry1 += dv14 < lo; dv14 -= lo;
      carry1 += dv14 < carry0; dv14 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds10, i32quotient);
      dv15 -= hi;
      dv15 -= carry0;
    }

    uint32_t borrow = dv15;
    dv15 = dv14;
    dv14 = dv13;
    dv13 = dv12;
    dv12 = dv11;
    dv11 = dv10;
    dv10 = dv9;
    dv9 = dv8;
    dv8 = dv7;
    dv7 = dv6;
    dv6 = dv5;
    dv5 = dv4;
    dv4 = dv3;
    dv3 = dv2;
    dv2 = dv1;
    dv1 = dv0;
    dv0 = 0;
    if (borrow) {
      i32quotient--;
      dv5 += ds0;
      dv6 += ds1 + (dv5 < ds0);
      dv7 += ds2 + (dv6 < ds1);
      dv8 += ds3 + (dv7 < ds2);
      dv9 += ds4 + (dv8 < ds3);
      dv10 += ds5 + (dv9 < ds4);
      dv11 += ds6 + (dv10 < ds5);
      dv12 += ds7 + (dv11 < ds6);
      dv13 += ds8 + (dv12 < ds7);
      dv14 += ds9 + (dv13 < ds8);
      dv15 += ds10 + (dv14 < ds9);
      if (dv15 > ds10) {
        i32quotient--;
        dv5 += ds0;
        dv6 += ds1 + (dv5 < ds0);
        dv7 += ds2 + (dv6 < ds1);
        dv8 += ds3 + (dv7 < ds2);
        dv9 += ds4 + (dv8 < ds3);
        dv10 += ds5 + (dv9 < ds4);
        dv11 += ds6 + (dv10 < ds5);
        dv12 += ds7 + (dv11 < ds6);
        dv13 += ds8 + (dv12 < ds7);
        dv14 += ds9 + (dv13 < ds8);
        dv15 += ds10 + (dv14 < ds9);
      }
    }
    *q7 = *q6;
    *q6 = *q5;
    *q5 = *q4;
    *q4 = *q3;
    *q3 = *q2;
    *q2 = *q1;
    *q1 = *q0;
    *q0 = i32quotient;
  }
  
  return 352 - 32*(11-divisorSize) - shiftCount;  
}

unsigned divide480to320reg(uint32_t dv0, uint32_t dv1, uint32_t dv2, uint32_t dv3, uint32_t dv4, uint32_t dv5, uint32_t dv6, uint32_t dv7, uint32_t dv8, uint32_t dv9, uint32_t dv10, uint32_t dv11, uint32_t dv12, uint32_t dv13, uint32_t dv14,
    uint32_t ds0, uint32_t ds1, uint32_t ds2, uint32_t ds3, uint32_t ds4, uint32_t ds5, uint32_t ds6, uint32_t ds7, uint32_t ds8, uint32_t ds9,
    uint32_t *q0, uint32_t *q1, uint32_t *q2, uint32_t *q3, uint32_t *q4, uint32_t *q5, uint32_t *q6, uint32_t *q7)
{
  unsigned dividendSize = 15;
  unsigned divisorSize = 10;
  while (ds9 == 0) {
    ds9 = ds8;
    ds8 = ds7;
    ds7 = ds6;
    ds6 = ds5;
    ds5 = ds4;
    ds4 = ds3;
    ds3 = ds2;
    ds2 = ds1;
    ds1 = ds0;
    ds0 = 0;
    divisorSize--;
  }

  unsigned shiftCount = clz(ds9);
  if (shiftCount) {
    ds9 = (ds9 << shiftCount) | (ds8 >> (32-shiftCount));
    ds8 = (ds8 << shiftCount) | (ds7 >> (32-shiftCount));
    ds7 = (ds7 << shiftCount) | (ds6 >> (32-shiftCount));
    ds6 = (ds6 << shiftCount) | (ds5 >> (32-shiftCount));
    ds5 = (ds5 << shiftCount) | (ds4 >> (32-shiftCount));
    ds4 = (ds4 << shiftCount) | (ds3 >> (32-shiftCount));
    ds3 = (ds3 << shiftCount) | (ds2 >> (32-shiftCount));
    ds2 = (ds2 << shiftCount) | (ds1 >> (32-shiftCount));
    ds1 = (ds1 << shiftCount) | (ds0 >> (32-shiftCount));
    ds0 = ds0 << shiftCount;
    dv14 = (dv14 << shiftCount) | (dv13 >> (32-shiftCount));
  }

  unsigned cyclesNum = min(dividendSize-divisorSize, 8u);
  for (unsigned i = 0; i < cyclesNum; i++) {
    uint32_t i32quotient = 0;
    if (dv14 == ds9) {
      i32quotient = 0xFFFFFFFF;
    } else {
      uint64_t i64dividend = (((uint64_t)dv14) << 32) | dv13;
      i32quotient = i64dividend / ds9;
    }

    {
      uint32_t carry0;
      uint32_t carry1;
      uint32_t lo;
      uint32_t hi;
      lo = ds0*i32quotient;
      carry0 = dv4 < lo;
      dv4 -= lo;
      hi = mul_hi(ds0, i32quotient);
      lo = ds1 * i32quotient;
      carry1 = dv5 < hi; dv5 -= hi;
      carry1 += dv5 < lo; dv5 -= lo;
      carry1 += dv5 < carry0; dv5 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds1, i32quotient);
      lo = ds2 * i32quotient;
      carry1 = dv6 < hi; dv6 -= hi;
      carry1 += dv6 < lo; dv6 -= lo;
      carry1 += dv6 < carry0; dv6 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds2, i32quotient);
      lo = ds3 * i32quotient;
      carry1 = dv7 < hi; dv7 -= hi;
      carry1 += dv7 < lo; dv7 -= lo;
      carry1 += dv7 < carry0; dv7 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds3, i32quotient);
      lo = ds4 * i32quotient;
      carry1 = dv8 < hi; dv8 -= hi;
      carry1 += dv8 < lo; dv8 -= lo;
      carry1 += dv8 < carry0; dv8 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds4, i32quotient);
      lo = ds5 * i32quotient;
      carry1 = dv9 < hi; dv9 -= hi;
      carry1 += dv9 < lo; dv9 -= lo;
      carry1 += dv9 < carry0; dv9 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds5, i32quotient);
      lo = ds6 * i32quotient;
      carry1 = dv10 < hi; dv10 -= hi;
      carry1 += dv10 < lo; dv10 -= lo;
      carry1 += dv10 < carry0; dv10 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds6, i32quotient);
      lo = ds7 * i32quotient;
      carry1 = dv11 < hi; dv11 -= hi;
      carry1 += dv11 < lo; dv11 -= lo;
      carry1 += dv11 < carry0; dv11 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds7, i32quotient);
      lo = ds8 * i32quotient;
      carry1 = dv12 < hi; dv12 -= hi;
      carry1 += dv12 < lo; dv12 -= lo;
      carry1 += dv12 < carry0; dv12 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds8, i32quotient);
      lo = ds9 * i32quotient;
      carry1 = dv13 < hi; dv13 -= hi;
      carry1 += dv13 < lo; dv13 -= lo;
      carry1 += dv13 < carry0; dv13 -= carry0;
      carry0 = carry1;
      hi = mul_hi(ds9, i32quotient);
      dv14 -= hi;
      dv14 -= carry0;
    }

    uint32_t borrow = dv14;
    dv14 = dv13;
    dv13 = dv12;
    dv12 = dv11;
    dv11 = dv10;
    dv10 = dv9;
    dv9 = dv8;
    dv8 = dv7;
    dv7 = dv6;
    dv6 = dv5;
    dv5 = dv4;
    dv4 = dv3;
    dv3 = dv2;
    dv2 = dv1;
    dv1 = dv0;
    dv0 = 0;
    if (borrow) {
      i32quotient--;
      dv5 += ds0;
      dv6 += ds1 + (dv5 < ds0);
      dv7 += ds2 + (dv6 < ds1);
      dv8 += ds3 + (dv7 < ds2);
      dv9 += ds4 + (dv8 < ds3);
      dv10 += ds5 + (dv9 < ds4);
      dv11 += ds6 + (dv10 < ds5);
      dv12 += ds7 + (dv11 < ds6);
      dv13 += ds8 + (dv12 < ds7);
      dv14 += ds9 + (dv13 < ds8);
      if (dv14 > ds9) {
        i32quotient--;
        dv5 += ds0;
        dv6 += ds1 + (dv5 < ds0);
        dv7 += ds2 + (dv6 < ds1);
        dv8 += ds3 + (dv7 < ds2);
        dv9 += ds4 + (dv8 < ds3);
        dv10 += ds5 + (dv9 < ds4);
        dv11 += ds6 + (dv10 < ds5);
        dv12 += ds7 + (dv11 < ds6);
        dv13 += ds8 + (dv12 < ds7);
        dv14 += ds9 + (dv13 < ds8);
      }
    }
    *q7 = *q6;
    *q6 = *q5;
    *q5 = *q4;
    *q4 = *q3;
    *q3 = *q2;
    *q2 = *q1;
    *q1 = *q0;
    *q0 = i32quotient;
  }
  
  return 320 - 32*(10-divisorSize) - shiftCount;
}
