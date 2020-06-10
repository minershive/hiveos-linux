// Generated for AMD OpenCL compiler, do not edit!
//  Date: 2020-06-09 18:52:25

void monSqr320(uint32_t *op, const uint32_t *mod, uint32_t invm)
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

void monMul320(uint32_t *op1, const uint32_t *op2, const uint32_t *mod, uint32_t invm)
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

void redcHalf320(uint32_t *op, const uint32_t *mod, uint32_t invm)
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

void mulProductScan320to96(uint32_t *out, const uint32_t *op1, const uint32_t *op2)
{
  uint64_t accLow = 0;
  uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;
  {
    lo = op1[0]*op2[0]; accLow += lo;
    hi = mul_hi(op1[0], op2[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[1]; accLow += lo;
    hi = mul_hi(op1[0], op2[1]); accHi += hi;
    lo = op1[1]*op2[0]; accLow += lo;
    hi = mul_hi(op1[1], op2[0]); accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[2]; accLow += lo;
    hi = mul_hi(op1[0], op2[2]); accHi += hi;
    lo = op1[1]*op2[1]; accLow += lo;
    hi = mul_hi(op1[1], op2[1]); accHi += hi;
    lo = op1[2]*op2[0]; accLow += lo;
    hi = mul_hi(op1[2], op2[0]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[1]*op2[2]; accLow += lo;
    hi = mul_hi(op1[1], op2[2]); accHi += hi;
    lo = op1[2]*op2[1]; accLow += lo;
    hi = mul_hi(op1[2], op2[1]); accHi += hi;
    lo = op1[3]*op2[0]; accLow += lo;
    hi = mul_hi(op1[3], op2[0]); accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[2]*op2[2]; accLow += lo;
    hi = mul_hi(op1[2], op2[2]); accHi += hi;
    lo = op1[3]*op2[1]; accLow += lo;
    hi = mul_hi(op1[3], op2[1]); accHi += hi;
    lo = op1[4]*op2[0]; accLow += lo;
    hi = mul_hi(op1[4], op2[0]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[3]*op2[2]; accLow += lo;
    hi = mul_hi(op1[3], op2[2]); accHi += hi;
    lo = op1[4]*op2[1]; accLow += lo;
    hi = mul_hi(op1[4], op2[1]); accHi += hi;
    lo = op1[5]*op2[0]; accLow += lo;
    hi = mul_hi(op1[5], op2[0]); accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[4]*op2[2]; accLow += lo;
    hi = mul_hi(op1[4], op2[2]); accHi += hi;
    lo = op1[5]*op2[1]; accLow += lo;
    hi = mul_hi(op1[5], op2[1]); accHi += hi;
    lo = op1[6]*op2[0]; accLow += lo;
    hi = mul_hi(op1[6], op2[0]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[5]*op2[2]; accLow += lo;
    hi = mul_hi(op1[5], op2[2]); accHi += hi;
    lo = op1[6]*op2[1]; accLow += lo;
    hi = mul_hi(op1[6], op2[1]); accHi += hi;
    lo = op1[7]*op2[0]; accLow += lo;
    hi = mul_hi(op1[7], op2[0]); accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[6]*op2[2]; accLow += lo;
    hi = mul_hi(op1[6], op2[2]); accHi += hi;
    lo = op1[7]*op2[1]; accLow += lo;
    hi = mul_hi(op1[7], op2[1]); accHi += hi;
    lo = op1[8]*op2[0]; accLow += lo;
    hi = mul_hi(op1[8], op2[0]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[7]*op2[2]; accLow += lo;
    hi = mul_hi(op1[7], op2[2]); accHi += hi;
    lo = op1[8]*op2[1]; accLow += lo;
    hi = mul_hi(op1[8], op2[1]); accHi += hi;
    lo = op1[9]*op2[0]; accLow += lo;
    hi = mul_hi(op1[9], op2[0]); accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[8]*op2[2]; accLow += lo;
    hi = mul_hi(op1[8], op2[2]); accHi += hi;
    lo = op1[9]*op2[1]; accLow += lo;
    hi = mul_hi(op1[9], op2[1]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[9]*op2[2]; accLow += lo;
    hi = mul_hi(op1[9], op2[2]); accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[12] = accLow;
}

void mulProductScan320to128(uint32_t *out, const uint32_t *op1, const uint32_t *op2)
{
  uint64_t accLow = 0;
  uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;
  {
    lo = op1[0]*op2[0]; accLow += lo;
    hi = mul_hi(op1[0], op2[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[1]; accLow += lo;
    hi = mul_hi(op1[0], op2[1]); accHi += hi;
    lo = op1[1]*op2[0]; accLow += lo;
    hi = mul_hi(op1[1], op2[0]); accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[2]; accLow += lo;
    hi = mul_hi(op1[0], op2[2]); accHi += hi;
    lo = op1[1]*op2[1]; accLow += lo;
    hi = mul_hi(op1[1], op2[1]); accHi += hi;
    lo = op1[2]*op2[0]; accLow += lo;
    hi = mul_hi(op1[2], op2[0]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[3]; accLow += lo;
    hi = mul_hi(op1[0], op2[3]); accHi += hi;
    lo = op1[1]*op2[2]; accLow += lo;
    hi = mul_hi(op1[1], op2[2]); accHi += hi;
    lo = op1[2]*op2[1]; accLow += lo;
    hi = mul_hi(op1[2], op2[1]); accHi += hi;
    lo = op1[3]*op2[0]; accLow += lo;
    hi = mul_hi(op1[3], op2[0]); accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[1]*op2[3]; accLow += lo;
    hi = mul_hi(op1[1], op2[3]); accHi += hi;
    lo = op1[2]*op2[2]; accLow += lo;
    hi = mul_hi(op1[2], op2[2]); accHi += hi;
    lo = op1[3]*op2[1]; accLow += lo;
    hi = mul_hi(op1[3], op2[1]); accHi += hi;
    lo = op1[4]*op2[0]; accLow += lo;
    hi = mul_hi(op1[4], op2[0]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[2]*op2[3]; accLow += lo;
    hi = mul_hi(op1[2], op2[3]); accHi += hi;
    lo = op1[3]*op2[2]; accLow += lo;
    hi = mul_hi(op1[3], op2[2]); accHi += hi;
    lo = op1[4]*op2[1]; accLow += lo;
    hi = mul_hi(op1[4], op2[1]); accHi += hi;
    lo = op1[5]*op2[0]; accLow += lo;
    hi = mul_hi(op1[5], op2[0]); accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[3]*op2[3]; accLow += lo;
    hi = mul_hi(op1[3], op2[3]); accHi += hi;
    lo = op1[4]*op2[2]; accLow += lo;
    hi = mul_hi(op1[4], op2[2]); accHi += hi;
    lo = op1[5]*op2[1]; accLow += lo;
    hi = mul_hi(op1[5], op2[1]); accHi += hi;
    lo = op1[6]*op2[0]; accLow += lo;
    hi = mul_hi(op1[6], op2[0]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[4]*op2[3]; accLow += lo;
    hi = mul_hi(op1[4], op2[3]); accHi += hi;
    lo = op1[5]*op2[2]; accLow += lo;
    hi = mul_hi(op1[5], op2[2]); accHi += hi;
    lo = op1[6]*op2[1]; accLow += lo;
    hi = mul_hi(op1[6], op2[1]); accHi += hi;
    lo = op1[7]*op2[0]; accLow += lo;
    hi = mul_hi(op1[7], op2[0]); accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[5]*op2[3]; accLow += lo;
    hi = mul_hi(op1[5], op2[3]); accHi += hi;
    lo = op1[6]*op2[2]; accLow += lo;
    hi = mul_hi(op1[6], op2[2]); accHi += hi;
    lo = op1[7]*op2[1]; accLow += lo;
    hi = mul_hi(op1[7], op2[1]); accHi += hi;
    lo = op1[8]*op2[0]; accLow += lo;
    hi = mul_hi(op1[8], op2[0]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[6]*op2[3]; accLow += lo;
    hi = mul_hi(op1[6], op2[3]); accHi += hi;
    lo = op1[7]*op2[2]; accLow += lo;
    hi = mul_hi(op1[7], op2[2]); accHi += hi;
    lo = op1[8]*op2[1]; accLow += lo;
    hi = mul_hi(op1[8], op2[1]); accHi += hi;
    lo = op1[9]*op2[0]; accLow += lo;
    hi = mul_hi(op1[9], op2[0]); accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[7]*op2[3]; accLow += lo;
    hi = mul_hi(op1[7], op2[3]); accHi += hi;
    lo = op1[8]*op2[2]; accLow += lo;
    hi = mul_hi(op1[8], op2[2]); accHi += hi;
    lo = op1[9]*op2[1]; accLow += lo;
    hi = mul_hi(op1[9], op2[1]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[8]*op2[3]; accLow += lo;
    hi = mul_hi(op1[8], op2[3]); accHi += hi;
    lo = op1[9]*op2[2]; accLow += lo;
    hi = mul_hi(op1[9], op2[2]); accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[9]*op2[3]; accLow += lo;
    hi = mul_hi(op1[9], op2[3]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[13] = accLow;
}

void mulProductScan320to192(uint32_t *out, const uint32_t *op1, const uint32_t *op2)
{
  uint64_t accLow = 0;
  uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;
  {
    lo = op1[0]*op2[0]; accLow += lo;
    hi = mul_hi(op1[0], op2[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[1]; accLow += lo;
    hi = mul_hi(op1[0], op2[1]); accHi += hi;
    lo = op1[1]*op2[0]; accLow += lo;
    hi = mul_hi(op1[1], op2[0]); accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[2]; accLow += lo;
    hi = mul_hi(op1[0], op2[2]); accHi += hi;
    lo = op1[1]*op2[1]; accLow += lo;
    hi = mul_hi(op1[1], op2[1]); accHi += hi;
    lo = op1[2]*op2[0]; accLow += lo;
    hi = mul_hi(op1[2], op2[0]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[3]; accLow += lo;
    hi = mul_hi(op1[0], op2[3]); accHi += hi;
    lo = op1[1]*op2[2]; accLow += lo;
    hi = mul_hi(op1[1], op2[2]); accHi += hi;
    lo = op1[2]*op2[1]; accLow += lo;
    hi = mul_hi(op1[2], op2[1]); accHi += hi;
    lo = op1[3]*op2[0]; accLow += lo;
    hi = mul_hi(op1[3], op2[0]); accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[4]; accLow += lo;
    hi = mul_hi(op1[0], op2[4]); accHi += hi;
    lo = op1[1]*op2[3]; accLow += lo;
    hi = mul_hi(op1[1], op2[3]); accHi += hi;
    lo = op1[2]*op2[2]; accLow += lo;
    hi = mul_hi(op1[2], op2[2]); accHi += hi;
    lo = op1[3]*op2[1]; accLow += lo;
    hi = mul_hi(op1[3], op2[1]); accHi += hi;
    lo = op1[4]*op2[0]; accLow += lo;
    hi = mul_hi(op1[4], op2[0]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[5]; accLow += lo;
    hi = mul_hi(op1[0], op2[5]); accHi += hi;
    lo = op1[1]*op2[4]; accLow += lo;
    hi = mul_hi(op1[1], op2[4]); accHi += hi;
    lo = op1[2]*op2[3]; accLow += lo;
    hi = mul_hi(op1[2], op2[3]); accHi += hi;
    lo = op1[3]*op2[2]; accLow += lo;
    hi = mul_hi(op1[3], op2[2]); accHi += hi;
    lo = op1[4]*op2[1]; accLow += lo;
    hi = mul_hi(op1[4], op2[1]); accHi += hi;
    lo = op1[5]*op2[0]; accLow += lo;
    hi = mul_hi(op1[5], op2[0]); accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[1]*op2[5]; accLow += lo;
    hi = mul_hi(op1[1], op2[5]); accHi += hi;
    lo = op1[2]*op2[4]; accLow += lo;
    hi = mul_hi(op1[2], op2[4]); accHi += hi;
    lo = op1[3]*op2[3]; accLow += lo;
    hi = mul_hi(op1[3], op2[3]); accHi += hi;
    lo = op1[4]*op2[2]; accLow += lo;
    hi = mul_hi(op1[4], op2[2]); accHi += hi;
    lo = op1[5]*op2[1]; accLow += lo;
    hi = mul_hi(op1[5], op2[1]); accHi += hi;
    lo = op1[6]*op2[0]; accLow += lo;
    hi = mul_hi(op1[6], op2[0]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[2]*op2[5]; accLow += lo;
    hi = mul_hi(op1[2], op2[5]); accHi += hi;
    lo = op1[3]*op2[4]; accLow += lo;
    hi = mul_hi(op1[3], op2[4]); accHi += hi;
    lo = op1[4]*op2[3]; accLow += lo;
    hi = mul_hi(op1[4], op2[3]); accHi += hi;
    lo = op1[5]*op2[2]; accLow += lo;
    hi = mul_hi(op1[5], op2[2]); accHi += hi;
    lo = op1[6]*op2[1]; accLow += lo;
    hi = mul_hi(op1[6], op2[1]); accHi += hi;
    lo = op1[7]*op2[0]; accLow += lo;
    hi = mul_hi(op1[7], op2[0]); accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[3]*op2[5]; accLow += lo;
    hi = mul_hi(op1[3], op2[5]); accHi += hi;
    lo = op1[4]*op2[4]; accLow += lo;
    hi = mul_hi(op1[4], op2[4]); accHi += hi;
    lo = op1[5]*op2[3]; accLow += lo;
    hi = mul_hi(op1[5], op2[3]); accHi += hi;
    lo = op1[6]*op2[2]; accLow += lo;
    hi = mul_hi(op1[6], op2[2]); accHi += hi;
    lo = op1[7]*op2[1]; accLow += lo;
    hi = mul_hi(op1[7], op2[1]); accHi += hi;
    lo = op1[8]*op2[0]; accLow += lo;
    hi = mul_hi(op1[8], op2[0]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[4]*op2[5]; accLow += lo;
    hi = mul_hi(op1[4], op2[5]); accHi += hi;
    lo = op1[5]*op2[4]; accLow += lo;
    hi = mul_hi(op1[5], op2[4]); accHi += hi;
    lo = op1[6]*op2[3]; accLow += lo;
    hi = mul_hi(op1[6], op2[3]); accHi += hi;
    lo = op1[7]*op2[2]; accLow += lo;
    hi = mul_hi(op1[7], op2[2]); accHi += hi;
    lo = op1[8]*op2[1]; accLow += lo;
    hi = mul_hi(op1[8], op2[1]); accHi += hi;
    lo = op1[9]*op2[0]; accLow += lo;
    hi = mul_hi(op1[9], op2[0]); accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[5]*op2[5]; accLow += lo;
    hi = mul_hi(op1[5], op2[5]); accHi += hi;
    lo = op1[6]*op2[4]; accLow += lo;
    hi = mul_hi(op1[6], op2[4]); accHi += hi;
    lo = op1[7]*op2[3]; accLow += lo;
    hi = mul_hi(op1[7], op2[3]); accHi += hi;
    lo = op1[8]*op2[2]; accLow += lo;
    hi = mul_hi(op1[8], op2[2]); accHi += hi;
    lo = op1[9]*op2[1]; accLow += lo;
    hi = mul_hi(op1[9], op2[1]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[6]*op2[5]; accLow += lo;
    hi = mul_hi(op1[6], op2[5]); accHi += hi;
    lo = op1[7]*op2[4]; accLow += lo;
    hi = mul_hi(op1[7], op2[4]); accHi += hi;
    lo = op1[8]*op2[3]; accLow += lo;
    hi = mul_hi(op1[8], op2[3]); accHi += hi;
    lo = op1[9]*op2[2]; accLow += lo;
    hi = mul_hi(op1[9], op2[2]); accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[7]*op2[5]; accLow += lo;
    hi = mul_hi(op1[7], op2[5]); accHi += hi;
    lo = op1[8]*op2[4]; accLow += lo;
    hi = mul_hi(op1[8], op2[4]); accHi += hi;
    lo = op1[9]*op2[3]; accLow += lo;
    hi = mul_hi(op1[9], op2[3]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[8]*op2[5]; accLow += lo;
    hi = mul_hi(op1[8], op2[5]); accHi += hi;
    lo = op1[9]*op2[4]; accLow += lo;
    hi = mul_hi(op1[9], op2[4]); accHi += hi;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[9]*op2[5]; accLow += lo;
    hi = mul_hi(op1[9], op2[5]); accHi += hi;
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[15] = accLow;
}

void monSqr352(uint32_t *op, const uint32_t *mod, uint32_t invm)
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

void monMul352(uint32_t *op1, const uint32_t *op2, const uint32_t *mod, uint32_t invm)
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

void redcHalf352(uint32_t *op, const uint32_t *mod, uint32_t invm)
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

void mulProductScan352to32(uint32_t *out, uint32_t *op1, uint32_t M)
{
  uint64_t accLow = 0, accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo0;
  uint32_t hi0;
  {
    lo0 = op1[0]*M;
    hi0 = mul_hi(op1[0], M);
    accLow += lo0;
    accHi += hi0;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[1]*M;
    hi0 = mul_hi(op1[1], M);
    accLow += lo0;
    accHi += hi0;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[2]*M;
    hi0 = mul_hi(op1[2], M);
    accLow += lo0;
    accHi += hi0;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[3]*M;
    hi0 = mul_hi(op1[3], M);
    accLow += lo0;
    accHi += hi0;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[4]*M;
    hi0 = mul_hi(op1[4], M);
    accLow += lo0;
    accHi += hi0;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[5]*M;
    hi0 = mul_hi(op1[5], M);
    accLow += lo0;
    accHi += hi0;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[6]*M;
    hi0 = mul_hi(op1[6], M);
    accLow += lo0;
    accHi += hi0;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[7]*M;
    hi0 = mul_hi(op1[7], M);
    accLow += lo0;
    accHi += hi0;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[8]*M;
    hi0 = mul_hi(op1[8], M);
    accLow += lo0;
    accHi += hi0;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[9]*M;
    hi0 = mul_hi(op1[9], M);
    accLow += lo0;
    accHi += hi0;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo0 = op1[10]*M;
    hi0 = mul_hi(op1[10], M);
    accLow += lo0;
    accHi += hi0;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[11] = accLow;
}

void mulProductScan352to96(uint32_t *out, const uint32_t *op1, const uint32_t *op2)
{
  uint64_t accLow = 0;
  uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;
  {
    lo = op1[0]*op2[0]; accLow += lo;
    hi = mul_hi(op1[0], op2[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[1]; accLow += lo;
    hi = mul_hi(op1[0], op2[1]); accHi += hi;
    lo = op1[1]*op2[0]; accLow += lo;
    hi = mul_hi(op1[1], op2[0]); accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[2]; accLow += lo;
    hi = mul_hi(op1[0], op2[2]); accHi += hi;
    lo = op1[1]*op2[1]; accLow += lo;
    hi = mul_hi(op1[1], op2[1]); accHi += hi;
    lo = op1[2]*op2[0]; accLow += lo;
    hi = mul_hi(op1[2], op2[0]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[1]*op2[2]; accLow += lo;
    hi = mul_hi(op1[1], op2[2]); accHi += hi;
    lo = op1[2]*op2[1]; accLow += lo;
    hi = mul_hi(op1[2], op2[1]); accHi += hi;
    lo = op1[3]*op2[0]; accLow += lo;
    hi = mul_hi(op1[3], op2[0]); accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[2]*op2[2]; accLow += lo;
    hi = mul_hi(op1[2], op2[2]); accHi += hi;
    lo = op1[3]*op2[1]; accLow += lo;
    hi = mul_hi(op1[3], op2[1]); accHi += hi;
    lo = op1[4]*op2[0]; accLow += lo;
    hi = mul_hi(op1[4], op2[0]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[3]*op2[2]; accLow += lo;
    hi = mul_hi(op1[3], op2[2]); accHi += hi;
    lo = op1[4]*op2[1]; accLow += lo;
    hi = mul_hi(op1[4], op2[1]); accHi += hi;
    lo = op1[5]*op2[0]; accLow += lo;
    hi = mul_hi(op1[5], op2[0]); accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[4]*op2[2]; accLow += lo;
    hi = mul_hi(op1[4], op2[2]); accHi += hi;
    lo = op1[5]*op2[1]; accLow += lo;
    hi = mul_hi(op1[5], op2[1]); accHi += hi;
    lo = op1[6]*op2[0]; accLow += lo;
    hi = mul_hi(op1[6], op2[0]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[5]*op2[2]; accLow += lo;
    hi = mul_hi(op1[5], op2[2]); accHi += hi;
    lo = op1[6]*op2[1]; accLow += lo;
    hi = mul_hi(op1[6], op2[1]); accHi += hi;
    lo = op1[7]*op2[0]; accLow += lo;
    hi = mul_hi(op1[7], op2[0]); accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[6]*op2[2]; accLow += lo;
    hi = mul_hi(op1[6], op2[2]); accHi += hi;
    lo = op1[7]*op2[1]; accLow += lo;
    hi = mul_hi(op1[7], op2[1]); accHi += hi;
    lo = op1[8]*op2[0]; accLow += lo;
    hi = mul_hi(op1[8], op2[0]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[7]*op2[2]; accLow += lo;
    hi = mul_hi(op1[7], op2[2]); accHi += hi;
    lo = op1[8]*op2[1]; accLow += lo;
    hi = mul_hi(op1[8], op2[1]); accHi += hi;
    lo = op1[9]*op2[0]; accLow += lo;
    hi = mul_hi(op1[9], op2[0]); accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[8]*op2[2]; accLow += lo;
    hi = mul_hi(op1[8], op2[2]); accHi += hi;
    lo = op1[9]*op2[1]; accLow += lo;
    hi = mul_hi(op1[9], op2[1]); accHi += hi;
    lo = op1[10]*op2[0]; accLow += lo;
    hi = mul_hi(op1[10], op2[0]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[9]*op2[2]; accLow += lo;
    hi = mul_hi(op1[9], op2[2]); accHi += hi;
    lo = op1[10]*op2[1]; accLow += lo;
    hi = mul_hi(op1[10], op2[1]); accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[10]*op2[2]; accLow += lo;
    hi = mul_hi(op1[10], op2[2]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[13] = accLow;
}

void mulProductScan352to128(uint32_t *out, const uint32_t *op1, const uint32_t *op2)
{
  uint64_t accLow = 0;
  uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;
  {
    lo = op1[0]*op2[0]; accLow += lo;
    hi = mul_hi(op1[0], op2[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[1]; accLow += lo;
    hi = mul_hi(op1[0], op2[1]); accHi += hi;
    lo = op1[1]*op2[0]; accLow += lo;
    hi = mul_hi(op1[1], op2[0]); accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[2]; accLow += lo;
    hi = mul_hi(op1[0], op2[2]); accHi += hi;
    lo = op1[1]*op2[1]; accLow += lo;
    hi = mul_hi(op1[1], op2[1]); accHi += hi;
    lo = op1[2]*op2[0]; accLow += lo;
    hi = mul_hi(op1[2], op2[0]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[3]; accLow += lo;
    hi = mul_hi(op1[0], op2[3]); accHi += hi;
    lo = op1[1]*op2[2]; accLow += lo;
    hi = mul_hi(op1[1], op2[2]); accHi += hi;
    lo = op1[2]*op2[1]; accLow += lo;
    hi = mul_hi(op1[2], op2[1]); accHi += hi;
    lo = op1[3]*op2[0]; accLow += lo;
    hi = mul_hi(op1[3], op2[0]); accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[1]*op2[3]; accLow += lo;
    hi = mul_hi(op1[1], op2[3]); accHi += hi;
    lo = op1[2]*op2[2]; accLow += lo;
    hi = mul_hi(op1[2], op2[2]); accHi += hi;
    lo = op1[3]*op2[1]; accLow += lo;
    hi = mul_hi(op1[3], op2[1]); accHi += hi;
    lo = op1[4]*op2[0]; accLow += lo;
    hi = mul_hi(op1[4], op2[0]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[2]*op2[3]; accLow += lo;
    hi = mul_hi(op1[2], op2[3]); accHi += hi;
    lo = op1[3]*op2[2]; accLow += lo;
    hi = mul_hi(op1[3], op2[2]); accHi += hi;
    lo = op1[4]*op2[1]; accLow += lo;
    hi = mul_hi(op1[4], op2[1]); accHi += hi;
    lo = op1[5]*op2[0]; accLow += lo;
    hi = mul_hi(op1[5], op2[0]); accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[3]*op2[3]; accLow += lo;
    hi = mul_hi(op1[3], op2[3]); accHi += hi;
    lo = op1[4]*op2[2]; accLow += lo;
    hi = mul_hi(op1[4], op2[2]); accHi += hi;
    lo = op1[5]*op2[1]; accLow += lo;
    hi = mul_hi(op1[5], op2[1]); accHi += hi;
    lo = op1[6]*op2[0]; accLow += lo;
    hi = mul_hi(op1[6], op2[0]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[4]*op2[3]; accLow += lo;
    hi = mul_hi(op1[4], op2[3]); accHi += hi;
    lo = op1[5]*op2[2]; accLow += lo;
    hi = mul_hi(op1[5], op2[2]); accHi += hi;
    lo = op1[6]*op2[1]; accLow += lo;
    hi = mul_hi(op1[6], op2[1]); accHi += hi;
    lo = op1[7]*op2[0]; accLow += lo;
    hi = mul_hi(op1[7], op2[0]); accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[5]*op2[3]; accLow += lo;
    hi = mul_hi(op1[5], op2[3]); accHi += hi;
    lo = op1[6]*op2[2]; accLow += lo;
    hi = mul_hi(op1[6], op2[2]); accHi += hi;
    lo = op1[7]*op2[1]; accLow += lo;
    hi = mul_hi(op1[7], op2[1]); accHi += hi;
    lo = op1[8]*op2[0]; accLow += lo;
    hi = mul_hi(op1[8], op2[0]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[6]*op2[3]; accLow += lo;
    hi = mul_hi(op1[6], op2[3]); accHi += hi;
    lo = op1[7]*op2[2]; accLow += lo;
    hi = mul_hi(op1[7], op2[2]); accHi += hi;
    lo = op1[8]*op2[1]; accLow += lo;
    hi = mul_hi(op1[8], op2[1]); accHi += hi;
    lo = op1[9]*op2[0]; accLow += lo;
    hi = mul_hi(op1[9], op2[0]); accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[7]*op2[3]; accLow += lo;
    hi = mul_hi(op1[7], op2[3]); accHi += hi;
    lo = op1[8]*op2[2]; accLow += lo;
    hi = mul_hi(op1[8], op2[2]); accHi += hi;
    lo = op1[9]*op2[1]; accLow += lo;
    hi = mul_hi(op1[9], op2[1]); accHi += hi;
    lo = op1[10]*op2[0]; accLow += lo;
    hi = mul_hi(op1[10], op2[0]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[8]*op2[3]; accLow += lo;
    hi = mul_hi(op1[8], op2[3]); accHi += hi;
    lo = op1[9]*op2[2]; accLow += lo;
    hi = mul_hi(op1[9], op2[2]); accHi += hi;
    lo = op1[10]*op2[1]; accLow += lo;
    hi = mul_hi(op1[10], op2[1]); accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[9]*op2[3]; accLow += lo;
    hi = mul_hi(op1[9], op2[3]); accHi += hi;
    lo = op1[10]*op2[2]; accLow += lo;
    hi = mul_hi(op1[10], op2[2]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[10]*op2[3]; accLow += lo;
    hi = mul_hi(op1[10], op2[3]); accHi += hi;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[14] = accLow;
}

void mulProductScan352to192(uint32_t *out, const uint32_t *op1, const uint32_t *op2)
{
  uint64_t accLow = 0;
  uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;
  {
    lo = op1[0]*op2[0]; accLow += lo;
    hi = mul_hi(op1[0], op2[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[1]; accLow += lo;
    hi = mul_hi(op1[0], op2[1]); accHi += hi;
    lo = op1[1]*op2[0]; accLow += lo;
    hi = mul_hi(op1[1], op2[0]); accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[2]; accLow += lo;
    hi = mul_hi(op1[0], op2[2]); accHi += hi;
    lo = op1[1]*op2[1]; accLow += lo;
    hi = mul_hi(op1[1], op2[1]); accHi += hi;
    lo = op1[2]*op2[0]; accLow += lo;
    hi = mul_hi(op1[2], op2[0]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[3]; accLow += lo;
    hi = mul_hi(op1[0], op2[3]); accHi += hi;
    lo = op1[1]*op2[2]; accLow += lo;
    hi = mul_hi(op1[1], op2[2]); accHi += hi;
    lo = op1[2]*op2[1]; accLow += lo;
    hi = mul_hi(op1[2], op2[1]); accHi += hi;
    lo = op1[3]*op2[0]; accLow += lo;
    hi = mul_hi(op1[3], op2[0]); accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[4]; accLow += lo;
    hi = mul_hi(op1[0], op2[4]); accHi += hi;
    lo = op1[1]*op2[3]; accLow += lo;
    hi = mul_hi(op1[1], op2[3]); accHi += hi;
    lo = op1[2]*op2[2]; accLow += lo;
    hi = mul_hi(op1[2], op2[2]); accHi += hi;
    lo = op1[3]*op2[1]; accLow += lo;
    hi = mul_hi(op1[3], op2[1]); accHi += hi;
    lo = op1[4]*op2[0]; accLow += lo;
    hi = mul_hi(op1[4], op2[0]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[5]; accLow += lo;
    hi = mul_hi(op1[0], op2[5]); accHi += hi;
    lo = op1[1]*op2[4]; accLow += lo;
    hi = mul_hi(op1[1], op2[4]); accHi += hi;
    lo = op1[2]*op2[3]; accLow += lo;
    hi = mul_hi(op1[2], op2[3]); accHi += hi;
    lo = op1[3]*op2[2]; accLow += lo;
    hi = mul_hi(op1[3], op2[2]); accHi += hi;
    lo = op1[4]*op2[1]; accLow += lo;
    hi = mul_hi(op1[4], op2[1]); accHi += hi;
    lo = op1[5]*op2[0]; accLow += lo;
    hi = mul_hi(op1[5], op2[0]); accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[1]*op2[5]; accLow += lo;
    hi = mul_hi(op1[1], op2[5]); accHi += hi;
    lo = op1[2]*op2[4]; accLow += lo;
    hi = mul_hi(op1[2], op2[4]); accHi += hi;
    lo = op1[3]*op2[3]; accLow += lo;
    hi = mul_hi(op1[3], op2[3]); accHi += hi;
    lo = op1[4]*op2[2]; accLow += lo;
    hi = mul_hi(op1[4], op2[2]); accHi += hi;
    lo = op1[5]*op2[1]; accLow += lo;
    hi = mul_hi(op1[5], op2[1]); accHi += hi;
    lo = op1[6]*op2[0]; accLow += lo;
    hi = mul_hi(op1[6], op2[0]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[2]*op2[5]; accLow += lo;
    hi = mul_hi(op1[2], op2[5]); accHi += hi;
    lo = op1[3]*op2[4]; accLow += lo;
    hi = mul_hi(op1[3], op2[4]); accHi += hi;
    lo = op1[4]*op2[3]; accLow += lo;
    hi = mul_hi(op1[4], op2[3]); accHi += hi;
    lo = op1[5]*op2[2]; accLow += lo;
    hi = mul_hi(op1[5], op2[2]); accHi += hi;
    lo = op1[6]*op2[1]; accLow += lo;
    hi = mul_hi(op1[6], op2[1]); accHi += hi;
    lo = op1[7]*op2[0]; accLow += lo;
    hi = mul_hi(op1[7], op2[0]); accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[3]*op2[5]; accLow += lo;
    hi = mul_hi(op1[3], op2[5]); accHi += hi;
    lo = op1[4]*op2[4]; accLow += lo;
    hi = mul_hi(op1[4], op2[4]); accHi += hi;
    lo = op1[5]*op2[3]; accLow += lo;
    hi = mul_hi(op1[5], op2[3]); accHi += hi;
    lo = op1[6]*op2[2]; accLow += lo;
    hi = mul_hi(op1[6], op2[2]); accHi += hi;
    lo = op1[7]*op2[1]; accLow += lo;
    hi = mul_hi(op1[7], op2[1]); accHi += hi;
    lo = op1[8]*op2[0]; accLow += lo;
    hi = mul_hi(op1[8], op2[0]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[4]*op2[5]; accLow += lo;
    hi = mul_hi(op1[4], op2[5]); accHi += hi;
    lo = op1[5]*op2[4]; accLow += lo;
    hi = mul_hi(op1[5], op2[4]); accHi += hi;
    lo = op1[6]*op2[3]; accLow += lo;
    hi = mul_hi(op1[6], op2[3]); accHi += hi;
    lo = op1[7]*op2[2]; accLow += lo;
    hi = mul_hi(op1[7], op2[2]); accHi += hi;
    lo = op1[8]*op2[1]; accLow += lo;
    hi = mul_hi(op1[8], op2[1]); accHi += hi;
    lo = op1[9]*op2[0]; accLow += lo;
    hi = mul_hi(op1[9], op2[0]); accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[5]*op2[5]; accLow += lo;
    hi = mul_hi(op1[5], op2[5]); accHi += hi;
    lo = op1[6]*op2[4]; accLow += lo;
    hi = mul_hi(op1[6], op2[4]); accHi += hi;
    lo = op1[7]*op2[3]; accLow += lo;
    hi = mul_hi(op1[7], op2[3]); accHi += hi;
    lo = op1[8]*op2[2]; accLow += lo;
    hi = mul_hi(op1[8], op2[2]); accHi += hi;
    lo = op1[9]*op2[1]; accLow += lo;
    hi = mul_hi(op1[9], op2[1]); accHi += hi;
    lo = op1[10]*op2[0]; accLow += lo;
    hi = mul_hi(op1[10], op2[0]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[6]*op2[5]; accLow += lo;
    hi = mul_hi(op1[6], op2[5]); accHi += hi;
    lo = op1[7]*op2[4]; accLow += lo;
    hi = mul_hi(op1[7], op2[4]); accHi += hi;
    lo = op1[8]*op2[3]; accLow += lo;
    hi = mul_hi(op1[8], op2[3]); accHi += hi;
    lo = op1[9]*op2[2]; accLow += lo;
    hi = mul_hi(op1[9], op2[2]); accHi += hi;
    lo = op1[10]*op2[1]; accLow += lo;
    hi = mul_hi(op1[10], op2[1]); accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[7]*op2[5]; accLow += lo;
    hi = mul_hi(op1[7], op2[5]); accHi += hi;
    lo = op1[8]*op2[4]; accLow += lo;
    hi = mul_hi(op1[8], op2[4]); accHi += hi;
    lo = op1[9]*op2[3]; accLow += lo;
    hi = mul_hi(op1[9], op2[3]); accHi += hi;
    lo = op1[10]*op2[2]; accLow += lo;
    hi = mul_hi(op1[10], op2[2]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[8]*op2[5]; accLow += lo;
    hi = mul_hi(op1[8], op2[5]); accHi += hi;
    lo = op1[9]*op2[4]; accLow += lo;
    hi = mul_hi(op1[9], op2[4]); accHi += hi;
    lo = op1[10]*op2[3]; accLow += lo;
    hi = mul_hi(op1[10], op2[3]); accHi += hi;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[9]*op2[5]; accLow += lo;
    hi = mul_hi(op1[9], op2[5]); accHi += hi;
    lo = op1[10]*op2[4]; accLow += lo;
    hi = mul_hi(op1[10], op2[4]); accHi += hi;
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[10]*op2[5]; accLow += lo;
    hi = mul_hi(op1[10], op2[5]); accHi += hi;
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[16] = accLow;
}

void sqrProductScan320(uint32_t *out, uint32_t *op)
{
  uint64_t accLow = 0; uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;

  {
    lo = op[0]*op[0]; accLow += lo;
    hi = mul_hi(op[0], op[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[1]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[1]); accHi += hi; accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[2]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[2]); accHi += hi; accHi += hi;
    lo = op[1]*op[1]; accLow += lo;
    hi = mul_hi(op[1], op[1]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[3]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[3]); accHi += hi; accHi += hi;
    lo = op[1]*op[2]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[2]); accHi += hi; accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[4]); accHi += hi; accHi += hi;
    lo = op[1]*op[3]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[3]); accHi += hi; accHi += hi;
    lo = op[2]*op[2]; accLow += lo;
    hi = mul_hi(op[2], op[2]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[5]); accHi += hi; accHi += hi;
    lo = op[1]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[4]); accHi += hi; accHi += hi;
    lo = op[2]*op[3]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[3]); accHi += hi; accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[6]); accHi += hi; accHi += hi;
    lo = op[1]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[5]); accHi += hi; accHi += hi;
    lo = op[2]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[4]); accHi += hi; accHi += hi;
    lo = op[3]*op[3]; accLow += lo;
    hi = mul_hi(op[3], op[3]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[7]); accHi += hi; accHi += hi;
    lo = op[1]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[6]); accHi += hi; accHi += hi;
    lo = op[2]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[5]); accHi += hi; accHi += hi;
    lo = op[3]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[4]); accHi += hi; accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[8]); accHi += hi; accHi += hi;
    lo = op[1]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[7]); accHi += hi; accHi += hi;
    lo = op[2]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[6]); accHi += hi; accHi += hi;
    lo = op[3]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[5]); accHi += hi; accHi += hi;
    lo = op[4]*op[4]; accLow += lo;
    hi = mul_hi(op[4], op[4]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[9]); accHi += hi; accHi += hi;
    lo = op[1]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[8]); accHi += hi; accHi += hi;
    lo = op[2]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[7]); accHi += hi; accHi += hi;
    lo = op[3]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[6]); accHi += hi; accHi += hi;
    lo = op[4]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[5]); accHi += hi; accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[1]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[9]); accHi += hi; accHi += hi;
    lo = op[2]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[8]); accHi += hi; accHi += hi;
    lo = op[3]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[7]); accHi += hi; accHi += hi;
    lo = op[4]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[6]); accHi += hi; accHi += hi;
    lo = op[5]*op[5]; accLow += lo;
    hi = mul_hi(op[5], op[5]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[2]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[9]); accHi += hi; accHi += hi;
    lo = op[3]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[8]); accHi += hi; accHi += hi;
    lo = op[4]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[7]); accHi += hi; accHi += hi;
    lo = op[5]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[6]); accHi += hi; accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[3]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[9]); accHi += hi; accHi += hi;
    lo = op[4]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[8]); accHi += hi; accHi += hi;
    lo = op[5]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[7]); accHi += hi; accHi += hi;
    lo = op[6]*op[6]; accLow += lo;
    hi = mul_hi(op[6], op[6]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[4]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[9]); accHi += hi; accHi += hi;
    lo = op[5]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[8]); accHi += hi; accHi += hi;
    lo = op[6]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[7]); accHi += hi; accHi += hi;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[5]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[9]); accHi += hi; accHi += hi;
    lo = op[6]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[8]); accHi += hi; accHi += hi;
    lo = op[7]*op[7]; accLow += lo;
    hi = mul_hi(op[7], op[7]); accHi += hi;
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[6]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[9]); accHi += hi; accHi += hi;
    lo = op[7]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[8]); accHi += hi; accHi += hi;
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[7]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[9]); accHi += hi; accHi += hi;
    lo = op[8]*op[8]; accLow += lo;
    hi = mul_hi(op[8], op[8]); accHi += hi;
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[8]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[9]); accHi += hi; accHi += hi;
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[9]*op[9]; accLow += lo;
    hi = mul_hi(op[9], op[9]); accHi += hi;
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[19] = accLow;
}
void sqrProductScan352(uint32_t *out, uint32_t *op)
{
  uint64_t accLow = 0; uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;

  {
    lo = op[0]*op[0]; accLow += lo;
    hi = mul_hi(op[0], op[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[1]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[1]); accHi += hi; accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[2]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[2]); accHi += hi; accHi += hi;
    lo = op[1]*op[1]; accLow += lo;
    hi = mul_hi(op[1], op[1]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[3]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[3]); accHi += hi; accHi += hi;
    lo = op[1]*op[2]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[2]); accHi += hi; accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[4]); accHi += hi; accHi += hi;
    lo = op[1]*op[3]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[3]); accHi += hi; accHi += hi;
    lo = op[2]*op[2]; accLow += lo;
    hi = mul_hi(op[2], op[2]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[5]); accHi += hi; accHi += hi;
    lo = op[1]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[4]); accHi += hi; accHi += hi;
    lo = op[2]*op[3]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[3]); accHi += hi; accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[6]); accHi += hi; accHi += hi;
    lo = op[1]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[5]); accHi += hi; accHi += hi;
    lo = op[2]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[4]); accHi += hi; accHi += hi;
    lo = op[3]*op[3]; accLow += lo;
    hi = mul_hi(op[3], op[3]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[7]); accHi += hi; accHi += hi;
    lo = op[1]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[6]); accHi += hi; accHi += hi;
    lo = op[2]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[5]); accHi += hi; accHi += hi;
    lo = op[3]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[4]); accHi += hi; accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[8]); accHi += hi; accHi += hi;
    lo = op[1]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[7]); accHi += hi; accHi += hi;
    lo = op[2]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[6]); accHi += hi; accHi += hi;
    lo = op[3]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[5]); accHi += hi; accHi += hi;
    lo = op[4]*op[4]; accLow += lo;
    hi = mul_hi(op[4], op[4]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[9]); accHi += hi; accHi += hi;
    lo = op[1]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[8]); accHi += hi; accHi += hi;
    lo = op[2]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[7]); accHi += hi; accHi += hi;
    lo = op[3]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[6]); accHi += hi; accHi += hi;
    lo = op[4]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[5]); accHi += hi; accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[10]); accHi += hi; accHi += hi;
    lo = op[1]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[9]); accHi += hi; accHi += hi;
    lo = op[2]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[8]); accHi += hi; accHi += hi;
    lo = op[3]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[7]); accHi += hi; accHi += hi;
    lo = op[4]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[6]); accHi += hi; accHi += hi;
    lo = op[5]*op[5]; accLow += lo;
    hi = mul_hi(op[5], op[5]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[1]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[10]); accHi += hi; accHi += hi;
    lo = op[2]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[9]); accHi += hi; accHi += hi;
    lo = op[3]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[8]); accHi += hi; accHi += hi;
    lo = op[4]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[7]); accHi += hi; accHi += hi;
    lo = op[5]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[6]); accHi += hi; accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[2]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[10]); accHi += hi; accHi += hi;
    lo = op[3]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[9]); accHi += hi; accHi += hi;
    lo = op[4]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[8]); accHi += hi; accHi += hi;
    lo = op[5]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[7]); accHi += hi; accHi += hi;
    lo = op[6]*op[6]; accLow += lo;
    hi = mul_hi(op[6], op[6]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[3]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[10]); accHi += hi; accHi += hi;
    lo = op[4]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[9]); accHi += hi; accHi += hi;
    lo = op[5]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[8]); accHi += hi; accHi += hi;
    lo = op[6]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[7]); accHi += hi; accHi += hi;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[4]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[10]); accHi += hi; accHi += hi;
    lo = op[5]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[9]); accHi += hi; accHi += hi;
    lo = op[6]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[8]); accHi += hi; accHi += hi;
    lo = op[7]*op[7]; accLow += lo;
    hi = mul_hi(op[7], op[7]); accHi += hi;
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[5]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[10]); accHi += hi; accHi += hi;
    lo = op[6]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[9]); accHi += hi; accHi += hi;
    lo = op[7]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[8]); accHi += hi; accHi += hi;
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[6]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[10]); accHi += hi; accHi += hi;
    lo = op[7]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[9]); accHi += hi; accHi += hi;
    lo = op[8]*op[8]; accLow += lo;
    hi = mul_hi(op[8], op[8]); accHi += hi;
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[7]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[10]); accHi += hi; accHi += hi;
    lo = op[8]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[9]); accHi += hi; accHi += hi;
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[8]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[10]); accHi += hi; accHi += hi;
    lo = op[9]*op[9]; accLow += lo;
    hi = mul_hi(op[9], op[9]); accHi += hi;
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[9]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[10]); accHi += hi; accHi += hi;
    out[19] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[10]*op[10]; accLow += lo;
    hi = mul_hi(op[10], op[10]); accHi += hi;
    out[20] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[21] = accLow;
}
void sqrProductScan640(uint32_t *out, uint32_t *op)
{
  uint64_t accLow = 0; uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;

  {
    lo = op[0]*op[0]; accLow += lo;
    hi = mul_hi(op[0], op[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[1]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[1]); accHi += hi; accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[2]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[2]); accHi += hi; accHi += hi;
    lo = op[1]*op[1]; accLow += lo;
    hi = mul_hi(op[1], op[1]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[3]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[3]); accHi += hi; accHi += hi;
    lo = op[1]*op[2]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[2]); accHi += hi; accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[4]); accHi += hi; accHi += hi;
    lo = op[1]*op[3]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[3]); accHi += hi; accHi += hi;
    lo = op[2]*op[2]; accLow += lo;
    hi = mul_hi(op[2], op[2]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[5]); accHi += hi; accHi += hi;
    lo = op[1]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[4]); accHi += hi; accHi += hi;
    lo = op[2]*op[3]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[3]); accHi += hi; accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[6]); accHi += hi; accHi += hi;
    lo = op[1]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[5]); accHi += hi; accHi += hi;
    lo = op[2]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[4]); accHi += hi; accHi += hi;
    lo = op[3]*op[3]; accLow += lo;
    hi = mul_hi(op[3], op[3]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[7]); accHi += hi; accHi += hi;
    lo = op[1]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[6]); accHi += hi; accHi += hi;
    lo = op[2]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[5]); accHi += hi; accHi += hi;
    lo = op[3]*op[4]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[4]); accHi += hi; accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[8]); accHi += hi; accHi += hi;
    lo = op[1]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[7]); accHi += hi; accHi += hi;
    lo = op[2]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[6]); accHi += hi; accHi += hi;
    lo = op[3]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[5]); accHi += hi; accHi += hi;
    lo = op[4]*op[4]; accLow += lo;
    hi = mul_hi(op[4], op[4]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[9]); accHi += hi; accHi += hi;
    lo = op[1]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[8]); accHi += hi; accHi += hi;
    lo = op[2]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[7]); accHi += hi; accHi += hi;
    lo = op[3]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[6]); accHi += hi; accHi += hi;
    lo = op[4]*op[5]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[5]); accHi += hi; accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[10]); accHi += hi; accHi += hi;
    lo = op[1]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[9]); accHi += hi; accHi += hi;
    lo = op[2]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[8]); accHi += hi; accHi += hi;
    lo = op[3]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[7]); accHi += hi; accHi += hi;
    lo = op[4]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[6]); accHi += hi; accHi += hi;
    lo = op[5]*op[5]; accLow += lo;
    hi = mul_hi(op[5], op[5]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[11]); accHi += hi; accHi += hi;
    lo = op[1]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[10]); accHi += hi; accHi += hi;
    lo = op[2]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[9]); accHi += hi; accHi += hi;
    lo = op[3]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[8]); accHi += hi; accHi += hi;
    lo = op[4]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[7]); accHi += hi; accHi += hi;
    lo = op[5]*op[6]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[6]); accHi += hi; accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[12]); accHi += hi; accHi += hi;
    lo = op[1]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[11]); accHi += hi; accHi += hi;
    lo = op[2]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[10]); accHi += hi; accHi += hi;
    lo = op[3]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[9]); accHi += hi; accHi += hi;
    lo = op[4]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[8]); accHi += hi; accHi += hi;
    lo = op[5]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[7]); accHi += hi; accHi += hi;
    lo = op[6]*op[6]; accLow += lo;
    hi = mul_hi(op[6], op[6]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[13]); accHi += hi; accHi += hi;
    lo = op[1]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[12]); accHi += hi; accHi += hi;
    lo = op[2]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[11]); accHi += hi; accHi += hi;
    lo = op[3]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[10]); accHi += hi; accHi += hi;
    lo = op[4]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[9]); accHi += hi; accHi += hi;
    lo = op[5]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[8]); accHi += hi; accHi += hi;
    lo = op[6]*op[7]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[7]); accHi += hi; accHi += hi;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[14]); accHi += hi; accHi += hi;
    lo = op[1]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[13]); accHi += hi; accHi += hi;
    lo = op[2]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[12]); accHi += hi; accHi += hi;
    lo = op[3]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[11]); accHi += hi; accHi += hi;
    lo = op[4]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[10]); accHi += hi; accHi += hi;
    lo = op[5]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[9]); accHi += hi; accHi += hi;
    lo = op[6]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[8]); accHi += hi; accHi += hi;
    lo = op[7]*op[7]; accLow += lo;
    hi = mul_hi(op[7], op[7]); accHi += hi;
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[15]); accHi += hi; accHi += hi;
    lo = op[1]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[14]); accHi += hi; accHi += hi;
    lo = op[2]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[13]); accHi += hi; accHi += hi;
    lo = op[3]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[12]); accHi += hi; accHi += hi;
    lo = op[4]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[11]); accHi += hi; accHi += hi;
    lo = op[5]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[10]); accHi += hi; accHi += hi;
    lo = op[6]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[9]); accHi += hi; accHi += hi;
    lo = op[7]*op[8]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[8]); accHi += hi; accHi += hi;
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[16]); accHi += hi; accHi += hi;
    lo = op[1]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[15]); accHi += hi; accHi += hi;
    lo = op[2]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[14]); accHi += hi; accHi += hi;
    lo = op[3]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[13]); accHi += hi; accHi += hi;
    lo = op[4]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[12]); accHi += hi; accHi += hi;
    lo = op[5]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[11]); accHi += hi; accHi += hi;
    lo = op[6]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[10]); accHi += hi; accHi += hi;
    lo = op[7]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[9]); accHi += hi; accHi += hi;
    lo = op[8]*op[8]; accLow += lo;
    hi = mul_hi(op[8], op[8]); accHi += hi;
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[17]); accHi += hi; accHi += hi;
    lo = op[1]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[16]); accHi += hi; accHi += hi;
    lo = op[2]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[15]); accHi += hi; accHi += hi;
    lo = op[3]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[14]); accHi += hi; accHi += hi;
    lo = op[4]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[13]); accHi += hi; accHi += hi;
    lo = op[5]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[12]); accHi += hi; accHi += hi;
    lo = op[6]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[11]); accHi += hi; accHi += hi;
    lo = op[7]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[10]); accHi += hi; accHi += hi;
    lo = op[8]*op[9]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[9]); accHi += hi; accHi += hi;
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[18]); accHi += hi; accHi += hi;
    lo = op[1]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[17]); accHi += hi; accHi += hi;
    lo = op[2]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[16]); accHi += hi; accHi += hi;
    lo = op[3]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[15]); accHi += hi; accHi += hi;
    lo = op[4]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[14]); accHi += hi; accHi += hi;
    lo = op[5]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[13]); accHi += hi; accHi += hi;
    lo = op[6]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[12]); accHi += hi; accHi += hi;
    lo = op[7]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[11]); accHi += hi; accHi += hi;
    lo = op[8]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[10]); accHi += hi; accHi += hi;
    lo = op[9]*op[9]; accLow += lo;
    hi = mul_hi(op[9], op[9]); accHi += hi;
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[0]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[0], op[19]); accHi += hi; accHi += hi;
    lo = op[1]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[18]); accHi += hi; accHi += hi;
    lo = op[2]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[17]); accHi += hi; accHi += hi;
    lo = op[3]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[16]); accHi += hi; accHi += hi;
    lo = op[4]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[15]); accHi += hi; accHi += hi;
    lo = op[5]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[14]); accHi += hi; accHi += hi;
    lo = op[6]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[13]); accHi += hi; accHi += hi;
    lo = op[7]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[12]); accHi += hi; accHi += hi;
    lo = op[8]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[11]); accHi += hi; accHi += hi;
    lo = op[9]*op[10]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[10]); accHi += hi; accHi += hi;
    out[19] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[1]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[1], op[19]); accHi += hi; accHi += hi;
    lo = op[2]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[18]); accHi += hi; accHi += hi;
    lo = op[3]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[17]); accHi += hi; accHi += hi;
    lo = op[4]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[16]); accHi += hi; accHi += hi;
    lo = op[5]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[15]); accHi += hi; accHi += hi;
    lo = op[6]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[14]); accHi += hi; accHi += hi;
    lo = op[7]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[13]); accHi += hi; accHi += hi;
    lo = op[8]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[12]); accHi += hi; accHi += hi;
    lo = op[9]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[11]); accHi += hi; accHi += hi;
    lo = op[10]*op[10]; accLow += lo;
    hi = mul_hi(op[10], op[10]); accHi += hi;
    out[20] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[2]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[2], op[19]); accHi += hi; accHi += hi;
    lo = op[3]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[18]); accHi += hi; accHi += hi;
    lo = op[4]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[17]); accHi += hi; accHi += hi;
    lo = op[5]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[16]); accHi += hi; accHi += hi;
    lo = op[6]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[15]); accHi += hi; accHi += hi;
    lo = op[7]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[14]); accHi += hi; accHi += hi;
    lo = op[8]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[13]); accHi += hi; accHi += hi;
    lo = op[9]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[12]); accHi += hi; accHi += hi;
    lo = op[10]*op[11]; accLow += lo; accLow += lo;
    hi = mul_hi(op[10], op[11]); accHi += hi; accHi += hi;
    out[21] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[3]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[3], op[19]); accHi += hi; accHi += hi;
    lo = op[4]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[18]); accHi += hi; accHi += hi;
    lo = op[5]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[17]); accHi += hi; accHi += hi;
    lo = op[6]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[16]); accHi += hi; accHi += hi;
    lo = op[7]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[15]); accHi += hi; accHi += hi;
    lo = op[8]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[14]); accHi += hi; accHi += hi;
    lo = op[9]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[13]); accHi += hi; accHi += hi;
    lo = op[10]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[10], op[12]); accHi += hi; accHi += hi;
    lo = op[11]*op[11]; accLow += lo;
    hi = mul_hi(op[11], op[11]); accHi += hi;
    out[22] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[4]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[4], op[19]); accHi += hi; accHi += hi;
    lo = op[5]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[18]); accHi += hi; accHi += hi;
    lo = op[6]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[17]); accHi += hi; accHi += hi;
    lo = op[7]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[16]); accHi += hi; accHi += hi;
    lo = op[8]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[15]); accHi += hi; accHi += hi;
    lo = op[9]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[14]); accHi += hi; accHi += hi;
    lo = op[10]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[10], op[13]); accHi += hi; accHi += hi;
    lo = op[11]*op[12]; accLow += lo; accLow += lo;
    hi = mul_hi(op[11], op[12]); accHi += hi; accHi += hi;
    out[23] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[5]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[5], op[19]); accHi += hi; accHi += hi;
    lo = op[6]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[18]); accHi += hi; accHi += hi;
    lo = op[7]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[17]); accHi += hi; accHi += hi;
    lo = op[8]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[16]); accHi += hi; accHi += hi;
    lo = op[9]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[15]); accHi += hi; accHi += hi;
    lo = op[10]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[10], op[14]); accHi += hi; accHi += hi;
    lo = op[11]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[11], op[13]); accHi += hi; accHi += hi;
    lo = op[12]*op[12]; accLow += lo;
    hi = mul_hi(op[12], op[12]); accHi += hi;
    out[24] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[6]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[6], op[19]); accHi += hi; accHi += hi;
    lo = op[7]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[18]); accHi += hi; accHi += hi;
    lo = op[8]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[17]); accHi += hi; accHi += hi;
    lo = op[9]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[16]); accHi += hi; accHi += hi;
    lo = op[10]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[10], op[15]); accHi += hi; accHi += hi;
    lo = op[11]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[11], op[14]); accHi += hi; accHi += hi;
    lo = op[12]*op[13]; accLow += lo; accLow += lo;
    hi = mul_hi(op[12], op[13]); accHi += hi; accHi += hi;
    out[25] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[7]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[7], op[19]); accHi += hi; accHi += hi;
    lo = op[8]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[18]); accHi += hi; accHi += hi;
    lo = op[9]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[17]); accHi += hi; accHi += hi;
    lo = op[10]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[10], op[16]); accHi += hi; accHi += hi;
    lo = op[11]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[11], op[15]); accHi += hi; accHi += hi;
    lo = op[12]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[12], op[14]); accHi += hi; accHi += hi;
    lo = op[13]*op[13]; accLow += lo;
    hi = mul_hi(op[13], op[13]); accHi += hi;
    out[26] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[8]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[8], op[19]); accHi += hi; accHi += hi;
    lo = op[9]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[18]); accHi += hi; accHi += hi;
    lo = op[10]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[10], op[17]); accHi += hi; accHi += hi;
    lo = op[11]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[11], op[16]); accHi += hi; accHi += hi;
    lo = op[12]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[12], op[15]); accHi += hi; accHi += hi;
    lo = op[13]*op[14]; accLow += lo; accLow += lo;
    hi = mul_hi(op[13], op[14]); accHi += hi; accHi += hi;
    out[27] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[9]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[9], op[19]); accHi += hi; accHi += hi;
    lo = op[10]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[10], op[18]); accHi += hi; accHi += hi;
    lo = op[11]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[11], op[17]); accHi += hi; accHi += hi;
    lo = op[12]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[12], op[16]); accHi += hi; accHi += hi;
    lo = op[13]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[13], op[15]); accHi += hi; accHi += hi;
    lo = op[14]*op[14]; accLow += lo;
    hi = mul_hi(op[14], op[14]); accHi += hi;
    out[28] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[10]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[10], op[19]); accHi += hi; accHi += hi;
    lo = op[11]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[11], op[18]); accHi += hi; accHi += hi;
    lo = op[12]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[12], op[17]); accHi += hi; accHi += hi;
    lo = op[13]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[13], op[16]); accHi += hi; accHi += hi;
    lo = op[14]*op[15]; accLow += lo; accLow += lo;
    hi = mul_hi(op[14], op[15]); accHi += hi; accHi += hi;
    out[29] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[11]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[11], op[19]); accHi += hi; accHi += hi;
    lo = op[12]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[12], op[18]); accHi += hi; accHi += hi;
    lo = op[13]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[13], op[17]); accHi += hi; accHi += hi;
    lo = op[14]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[14], op[16]); accHi += hi; accHi += hi;
    lo = op[15]*op[15]; accLow += lo;
    hi = mul_hi(op[15], op[15]); accHi += hi;
    out[30] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[12]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[12], op[19]); accHi += hi; accHi += hi;
    lo = op[13]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[13], op[18]); accHi += hi; accHi += hi;
    lo = op[14]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[14], op[17]); accHi += hi; accHi += hi;
    lo = op[15]*op[16]; accLow += lo; accLow += lo;
    hi = mul_hi(op[15], op[16]); accHi += hi; accHi += hi;
    out[31] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[13]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[13], op[19]); accHi += hi; accHi += hi;
    lo = op[14]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[14], op[18]); accHi += hi; accHi += hi;
    lo = op[15]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[15], op[17]); accHi += hi; accHi += hi;
    lo = op[16]*op[16]; accLow += lo;
    hi = mul_hi(op[16], op[16]); accHi += hi;
    out[32] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[14]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[14], op[19]); accHi += hi; accHi += hi;
    lo = op[15]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[15], op[18]); accHi += hi; accHi += hi;
    lo = op[16]*op[17]; accLow += lo; accLow += lo;
    hi = mul_hi(op[16], op[17]); accHi += hi; accHi += hi;
    out[33] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[15]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[15], op[19]); accHi += hi; accHi += hi;
    lo = op[16]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[16], op[18]); accHi += hi; accHi += hi;
    lo = op[17]*op[17]; accLow += lo;
    hi = mul_hi(op[17], op[17]); accHi += hi;
    out[34] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[16]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[16], op[19]); accHi += hi; accHi += hi;
    lo = op[17]*op[18]; accLow += lo; accLow += lo;
    hi = mul_hi(op[17], op[18]); accHi += hi; accHi += hi;
    out[35] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[17]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[17], op[19]); accHi += hi; accHi += hi;
    lo = op[18]*op[18]; accLow += lo;
    hi = mul_hi(op[18], op[18]); accHi += hi;
    out[36] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[18]*op[19]; accLow += lo; accLow += lo;
    hi = mul_hi(op[18], op[19]); accHi += hi; accHi += hi;
    out[37] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op[19]*op[19]; accLow += lo;
    hi = mul_hi(op[19], op[19]); accHi += hi;
    out[38] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[39] = accLow;
}
void mulProductScan320to320(uint32_t *out, const uint32_t *op1, const uint32_t *op2)
{
  uint64_t accLow = 0;
  uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;
  {
    lo = op1[0]*op2[0]; accLow += lo;
    hi = mul_hi(op1[0], op2[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[1]; accLow += lo;
    hi = mul_hi(op1[0], op2[1]); accHi += hi;
    lo = op1[1]*op2[0]; accLow += lo;
    hi = mul_hi(op1[1], op2[0]); accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[2]; accLow += lo;
    hi = mul_hi(op1[0], op2[2]); accHi += hi;
    lo = op1[1]*op2[1]; accLow += lo;
    hi = mul_hi(op1[1], op2[1]); accHi += hi;
    lo = op1[2]*op2[0]; accLow += lo;
    hi = mul_hi(op1[2], op2[0]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[3]; accLow += lo;
    hi = mul_hi(op1[0], op2[3]); accHi += hi;
    lo = op1[1]*op2[2]; accLow += lo;
    hi = mul_hi(op1[1], op2[2]); accHi += hi;
    lo = op1[2]*op2[1]; accLow += lo;
    hi = mul_hi(op1[2], op2[1]); accHi += hi;
    lo = op1[3]*op2[0]; accLow += lo;
    hi = mul_hi(op1[3], op2[0]); accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[4]; accLow += lo;
    hi = mul_hi(op1[0], op2[4]); accHi += hi;
    lo = op1[1]*op2[3]; accLow += lo;
    hi = mul_hi(op1[1], op2[3]); accHi += hi;
    lo = op1[2]*op2[2]; accLow += lo;
    hi = mul_hi(op1[2], op2[2]); accHi += hi;
    lo = op1[3]*op2[1]; accLow += lo;
    hi = mul_hi(op1[3], op2[1]); accHi += hi;
    lo = op1[4]*op2[0]; accLow += lo;
    hi = mul_hi(op1[4], op2[0]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[5]; accLow += lo;
    hi = mul_hi(op1[0], op2[5]); accHi += hi;
    lo = op1[1]*op2[4]; accLow += lo;
    hi = mul_hi(op1[1], op2[4]); accHi += hi;
    lo = op1[2]*op2[3]; accLow += lo;
    hi = mul_hi(op1[2], op2[3]); accHi += hi;
    lo = op1[3]*op2[2]; accLow += lo;
    hi = mul_hi(op1[3], op2[2]); accHi += hi;
    lo = op1[4]*op2[1]; accLow += lo;
    hi = mul_hi(op1[4], op2[1]); accHi += hi;
    lo = op1[5]*op2[0]; accLow += lo;
    hi = mul_hi(op1[5], op2[0]); accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[6]; accLow += lo;
    hi = mul_hi(op1[0], op2[6]); accHi += hi;
    lo = op1[1]*op2[5]; accLow += lo;
    hi = mul_hi(op1[1], op2[5]); accHi += hi;
    lo = op1[2]*op2[4]; accLow += lo;
    hi = mul_hi(op1[2], op2[4]); accHi += hi;
    lo = op1[3]*op2[3]; accLow += lo;
    hi = mul_hi(op1[3], op2[3]); accHi += hi;
    lo = op1[4]*op2[2]; accLow += lo;
    hi = mul_hi(op1[4], op2[2]); accHi += hi;
    lo = op1[5]*op2[1]; accLow += lo;
    hi = mul_hi(op1[5], op2[1]); accHi += hi;
    lo = op1[6]*op2[0]; accLow += lo;
    hi = mul_hi(op1[6], op2[0]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[7]; accLow += lo;
    hi = mul_hi(op1[0], op2[7]); accHi += hi;
    lo = op1[1]*op2[6]; accLow += lo;
    hi = mul_hi(op1[1], op2[6]); accHi += hi;
    lo = op1[2]*op2[5]; accLow += lo;
    hi = mul_hi(op1[2], op2[5]); accHi += hi;
    lo = op1[3]*op2[4]; accLow += lo;
    hi = mul_hi(op1[3], op2[4]); accHi += hi;
    lo = op1[4]*op2[3]; accLow += lo;
    hi = mul_hi(op1[4], op2[3]); accHi += hi;
    lo = op1[5]*op2[2]; accLow += lo;
    hi = mul_hi(op1[5], op2[2]); accHi += hi;
    lo = op1[6]*op2[1]; accLow += lo;
    hi = mul_hi(op1[6], op2[1]); accHi += hi;
    lo = op1[7]*op2[0]; accLow += lo;
    hi = mul_hi(op1[7], op2[0]); accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[8]; accLow += lo;
    hi = mul_hi(op1[0], op2[8]); accHi += hi;
    lo = op1[1]*op2[7]; accLow += lo;
    hi = mul_hi(op1[1], op2[7]); accHi += hi;
    lo = op1[2]*op2[6]; accLow += lo;
    hi = mul_hi(op1[2], op2[6]); accHi += hi;
    lo = op1[3]*op2[5]; accLow += lo;
    hi = mul_hi(op1[3], op2[5]); accHi += hi;
    lo = op1[4]*op2[4]; accLow += lo;
    hi = mul_hi(op1[4], op2[4]); accHi += hi;
    lo = op1[5]*op2[3]; accLow += lo;
    hi = mul_hi(op1[5], op2[3]); accHi += hi;
    lo = op1[6]*op2[2]; accLow += lo;
    hi = mul_hi(op1[6], op2[2]); accHi += hi;
    lo = op1[7]*op2[1]; accLow += lo;
    hi = mul_hi(op1[7], op2[1]); accHi += hi;
    lo = op1[8]*op2[0]; accLow += lo;
    hi = mul_hi(op1[8], op2[0]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[9]; accLow += lo;
    hi = mul_hi(op1[0], op2[9]); accHi += hi;
    lo = op1[1]*op2[8]; accLow += lo;
    hi = mul_hi(op1[1], op2[8]); accHi += hi;
    lo = op1[2]*op2[7]; accLow += lo;
    hi = mul_hi(op1[2], op2[7]); accHi += hi;
    lo = op1[3]*op2[6]; accLow += lo;
    hi = mul_hi(op1[3], op2[6]); accHi += hi;
    lo = op1[4]*op2[5]; accLow += lo;
    hi = mul_hi(op1[4], op2[5]); accHi += hi;
    lo = op1[5]*op2[4]; accLow += lo;
    hi = mul_hi(op1[5], op2[4]); accHi += hi;
    lo = op1[6]*op2[3]; accLow += lo;
    hi = mul_hi(op1[6], op2[3]); accHi += hi;
    lo = op1[7]*op2[2]; accLow += lo;
    hi = mul_hi(op1[7], op2[2]); accHi += hi;
    lo = op1[8]*op2[1]; accLow += lo;
    hi = mul_hi(op1[8], op2[1]); accHi += hi;
    lo = op1[9]*op2[0]; accLow += lo;
    hi = mul_hi(op1[9], op2[0]); accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[1]*op2[9]; accLow += lo;
    hi = mul_hi(op1[1], op2[9]); accHi += hi;
    lo = op1[2]*op2[8]; accLow += lo;
    hi = mul_hi(op1[2], op2[8]); accHi += hi;
    lo = op1[3]*op2[7]; accLow += lo;
    hi = mul_hi(op1[3], op2[7]); accHi += hi;
    lo = op1[4]*op2[6]; accLow += lo;
    hi = mul_hi(op1[4], op2[6]); accHi += hi;
    lo = op1[5]*op2[5]; accLow += lo;
    hi = mul_hi(op1[5], op2[5]); accHi += hi;
    lo = op1[6]*op2[4]; accLow += lo;
    hi = mul_hi(op1[6], op2[4]); accHi += hi;
    lo = op1[7]*op2[3]; accLow += lo;
    hi = mul_hi(op1[7], op2[3]); accHi += hi;
    lo = op1[8]*op2[2]; accLow += lo;
    hi = mul_hi(op1[8], op2[2]); accHi += hi;
    lo = op1[9]*op2[1]; accLow += lo;
    hi = mul_hi(op1[9], op2[1]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[2]*op2[9]; accLow += lo;
    hi = mul_hi(op1[2], op2[9]); accHi += hi;
    lo = op1[3]*op2[8]; accLow += lo;
    hi = mul_hi(op1[3], op2[8]); accHi += hi;
    lo = op1[4]*op2[7]; accLow += lo;
    hi = mul_hi(op1[4], op2[7]); accHi += hi;
    lo = op1[5]*op2[6]; accLow += lo;
    hi = mul_hi(op1[5], op2[6]); accHi += hi;
    lo = op1[6]*op2[5]; accLow += lo;
    hi = mul_hi(op1[6], op2[5]); accHi += hi;
    lo = op1[7]*op2[4]; accLow += lo;
    hi = mul_hi(op1[7], op2[4]); accHi += hi;
    lo = op1[8]*op2[3]; accLow += lo;
    hi = mul_hi(op1[8], op2[3]); accHi += hi;
    lo = op1[9]*op2[2]; accLow += lo;
    hi = mul_hi(op1[9], op2[2]); accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[3]*op2[9]; accLow += lo;
    hi = mul_hi(op1[3], op2[9]); accHi += hi;
    lo = op1[4]*op2[8]; accLow += lo;
    hi = mul_hi(op1[4], op2[8]); accHi += hi;
    lo = op1[5]*op2[7]; accLow += lo;
    hi = mul_hi(op1[5], op2[7]); accHi += hi;
    lo = op1[6]*op2[6]; accLow += lo;
    hi = mul_hi(op1[6], op2[6]); accHi += hi;
    lo = op1[7]*op2[5]; accLow += lo;
    hi = mul_hi(op1[7], op2[5]); accHi += hi;
    lo = op1[8]*op2[4]; accLow += lo;
    hi = mul_hi(op1[8], op2[4]); accHi += hi;
    lo = op1[9]*op2[3]; accLow += lo;
    hi = mul_hi(op1[9], op2[3]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[4]*op2[9]; accLow += lo;
    hi = mul_hi(op1[4], op2[9]); accHi += hi;
    lo = op1[5]*op2[8]; accLow += lo;
    hi = mul_hi(op1[5], op2[8]); accHi += hi;
    lo = op1[6]*op2[7]; accLow += lo;
    hi = mul_hi(op1[6], op2[7]); accHi += hi;
    lo = op1[7]*op2[6]; accLow += lo;
    hi = mul_hi(op1[7], op2[6]); accHi += hi;
    lo = op1[8]*op2[5]; accLow += lo;
    hi = mul_hi(op1[8], op2[5]); accHi += hi;
    lo = op1[9]*op2[4]; accLow += lo;
    hi = mul_hi(op1[9], op2[4]); accHi += hi;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[5]*op2[9]; accLow += lo;
    hi = mul_hi(op1[5], op2[9]); accHi += hi;
    lo = op1[6]*op2[8]; accLow += lo;
    hi = mul_hi(op1[6], op2[8]); accHi += hi;
    lo = op1[7]*op2[7]; accLow += lo;
    hi = mul_hi(op1[7], op2[7]); accHi += hi;
    lo = op1[8]*op2[6]; accLow += lo;
    hi = mul_hi(op1[8], op2[6]); accHi += hi;
    lo = op1[9]*op2[5]; accLow += lo;
    hi = mul_hi(op1[9], op2[5]); accHi += hi;
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[6]*op2[9]; accLow += lo;
    hi = mul_hi(op1[6], op2[9]); accHi += hi;
    lo = op1[7]*op2[8]; accLow += lo;
    hi = mul_hi(op1[7], op2[8]); accHi += hi;
    lo = op1[8]*op2[7]; accLow += lo;
    hi = mul_hi(op1[8], op2[7]); accHi += hi;
    lo = op1[9]*op2[6]; accLow += lo;
    hi = mul_hi(op1[9], op2[6]); accHi += hi;
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[7]*op2[9]; accLow += lo;
    hi = mul_hi(op1[7], op2[9]); accHi += hi;
    lo = op1[8]*op2[8]; accLow += lo;
    hi = mul_hi(op1[8], op2[8]); accHi += hi;
    lo = op1[9]*op2[7]; accLow += lo;
    hi = mul_hi(op1[9], op2[7]); accHi += hi;
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[8]*op2[9]; accLow += lo;
    hi = mul_hi(op1[8], op2[9]); accHi += hi;
    lo = op1[9]*op2[8]; accLow += lo;
    hi = mul_hi(op1[9], op2[8]); accHi += hi;
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[9]*op2[9]; accLow += lo;
    hi = mul_hi(op1[9], op2[9]); accHi += hi;
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[19] = accLow;
}

void mulProductScan352to352(uint32_t *out, const uint32_t *op1, const uint32_t *op2)
{
  uint64_t accLow = 0;
  uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;
  {
    lo = op1[0]*op2[0]; accLow += lo;
    hi = mul_hi(op1[0], op2[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[1]; accLow += lo;
    hi = mul_hi(op1[0], op2[1]); accHi += hi;
    lo = op1[1]*op2[0]; accLow += lo;
    hi = mul_hi(op1[1], op2[0]); accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[2]; accLow += lo;
    hi = mul_hi(op1[0], op2[2]); accHi += hi;
    lo = op1[1]*op2[1]; accLow += lo;
    hi = mul_hi(op1[1], op2[1]); accHi += hi;
    lo = op1[2]*op2[0]; accLow += lo;
    hi = mul_hi(op1[2], op2[0]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[3]; accLow += lo;
    hi = mul_hi(op1[0], op2[3]); accHi += hi;
    lo = op1[1]*op2[2]; accLow += lo;
    hi = mul_hi(op1[1], op2[2]); accHi += hi;
    lo = op1[2]*op2[1]; accLow += lo;
    hi = mul_hi(op1[2], op2[1]); accHi += hi;
    lo = op1[3]*op2[0]; accLow += lo;
    hi = mul_hi(op1[3], op2[0]); accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[4]; accLow += lo;
    hi = mul_hi(op1[0], op2[4]); accHi += hi;
    lo = op1[1]*op2[3]; accLow += lo;
    hi = mul_hi(op1[1], op2[3]); accHi += hi;
    lo = op1[2]*op2[2]; accLow += lo;
    hi = mul_hi(op1[2], op2[2]); accHi += hi;
    lo = op1[3]*op2[1]; accLow += lo;
    hi = mul_hi(op1[3], op2[1]); accHi += hi;
    lo = op1[4]*op2[0]; accLow += lo;
    hi = mul_hi(op1[4], op2[0]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[5]; accLow += lo;
    hi = mul_hi(op1[0], op2[5]); accHi += hi;
    lo = op1[1]*op2[4]; accLow += lo;
    hi = mul_hi(op1[1], op2[4]); accHi += hi;
    lo = op1[2]*op2[3]; accLow += lo;
    hi = mul_hi(op1[2], op2[3]); accHi += hi;
    lo = op1[3]*op2[2]; accLow += lo;
    hi = mul_hi(op1[3], op2[2]); accHi += hi;
    lo = op1[4]*op2[1]; accLow += lo;
    hi = mul_hi(op1[4], op2[1]); accHi += hi;
    lo = op1[5]*op2[0]; accLow += lo;
    hi = mul_hi(op1[5], op2[0]); accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[6]; accLow += lo;
    hi = mul_hi(op1[0], op2[6]); accHi += hi;
    lo = op1[1]*op2[5]; accLow += lo;
    hi = mul_hi(op1[1], op2[5]); accHi += hi;
    lo = op1[2]*op2[4]; accLow += lo;
    hi = mul_hi(op1[2], op2[4]); accHi += hi;
    lo = op1[3]*op2[3]; accLow += lo;
    hi = mul_hi(op1[3], op2[3]); accHi += hi;
    lo = op1[4]*op2[2]; accLow += lo;
    hi = mul_hi(op1[4], op2[2]); accHi += hi;
    lo = op1[5]*op2[1]; accLow += lo;
    hi = mul_hi(op1[5], op2[1]); accHi += hi;
    lo = op1[6]*op2[0]; accLow += lo;
    hi = mul_hi(op1[6], op2[0]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[7]; accLow += lo;
    hi = mul_hi(op1[0], op2[7]); accHi += hi;
    lo = op1[1]*op2[6]; accLow += lo;
    hi = mul_hi(op1[1], op2[6]); accHi += hi;
    lo = op1[2]*op2[5]; accLow += lo;
    hi = mul_hi(op1[2], op2[5]); accHi += hi;
    lo = op1[3]*op2[4]; accLow += lo;
    hi = mul_hi(op1[3], op2[4]); accHi += hi;
    lo = op1[4]*op2[3]; accLow += lo;
    hi = mul_hi(op1[4], op2[3]); accHi += hi;
    lo = op1[5]*op2[2]; accLow += lo;
    hi = mul_hi(op1[5], op2[2]); accHi += hi;
    lo = op1[6]*op2[1]; accLow += lo;
    hi = mul_hi(op1[6], op2[1]); accHi += hi;
    lo = op1[7]*op2[0]; accLow += lo;
    hi = mul_hi(op1[7], op2[0]); accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[8]; accLow += lo;
    hi = mul_hi(op1[0], op2[8]); accHi += hi;
    lo = op1[1]*op2[7]; accLow += lo;
    hi = mul_hi(op1[1], op2[7]); accHi += hi;
    lo = op1[2]*op2[6]; accLow += lo;
    hi = mul_hi(op1[2], op2[6]); accHi += hi;
    lo = op1[3]*op2[5]; accLow += lo;
    hi = mul_hi(op1[3], op2[5]); accHi += hi;
    lo = op1[4]*op2[4]; accLow += lo;
    hi = mul_hi(op1[4], op2[4]); accHi += hi;
    lo = op1[5]*op2[3]; accLow += lo;
    hi = mul_hi(op1[5], op2[3]); accHi += hi;
    lo = op1[6]*op2[2]; accLow += lo;
    hi = mul_hi(op1[6], op2[2]); accHi += hi;
    lo = op1[7]*op2[1]; accLow += lo;
    hi = mul_hi(op1[7], op2[1]); accHi += hi;
    lo = op1[8]*op2[0]; accLow += lo;
    hi = mul_hi(op1[8], op2[0]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[9]; accLow += lo;
    hi = mul_hi(op1[0], op2[9]); accHi += hi;
    lo = op1[1]*op2[8]; accLow += lo;
    hi = mul_hi(op1[1], op2[8]); accHi += hi;
    lo = op1[2]*op2[7]; accLow += lo;
    hi = mul_hi(op1[2], op2[7]); accHi += hi;
    lo = op1[3]*op2[6]; accLow += lo;
    hi = mul_hi(op1[3], op2[6]); accHi += hi;
    lo = op1[4]*op2[5]; accLow += lo;
    hi = mul_hi(op1[4], op2[5]); accHi += hi;
    lo = op1[5]*op2[4]; accLow += lo;
    hi = mul_hi(op1[5], op2[4]); accHi += hi;
    lo = op1[6]*op2[3]; accLow += lo;
    hi = mul_hi(op1[6], op2[3]); accHi += hi;
    lo = op1[7]*op2[2]; accLow += lo;
    hi = mul_hi(op1[7], op2[2]); accHi += hi;
    lo = op1[8]*op2[1]; accLow += lo;
    hi = mul_hi(op1[8], op2[1]); accHi += hi;
    lo = op1[9]*op2[0]; accLow += lo;
    hi = mul_hi(op1[9], op2[0]); accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[10]; accLow += lo;
    hi = mul_hi(op1[0], op2[10]); accHi += hi;
    lo = op1[1]*op2[9]; accLow += lo;
    hi = mul_hi(op1[1], op2[9]); accHi += hi;
    lo = op1[2]*op2[8]; accLow += lo;
    hi = mul_hi(op1[2], op2[8]); accHi += hi;
    lo = op1[3]*op2[7]; accLow += lo;
    hi = mul_hi(op1[3], op2[7]); accHi += hi;
    lo = op1[4]*op2[6]; accLow += lo;
    hi = mul_hi(op1[4], op2[6]); accHi += hi;
    lo = op1[5]*op2[5]; accLow += lo;
    hi = mul_hi(op1[5], op2[5]); accHi += hi;
    lo = op1[6]*op2[4]; accLow += lo;
    hi = mul_hi(op1[6], op2[4]); accHi += hi;
    lo = op1[7]*op2[3]; accLow += lo;
    hi = mul_hi(op1[7], op2[3]); accHi += hi;
    lo = op1[8]*op2[2]; accLow += lo;
    hi = mul_hi(op1[8], op2[2]); accHi += hi;
    lo = op1[9]*op2[1]; accLow += lo;
    hi = mul_hi(op1[9], op2[1]); accHi += hi;
    lo = op1[10]*op2[0]; accLow += lo;
    hi = mul_hi(op1[10], op2[0]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[1]*op2[10]; accLow += lo;
    hi = mul_hi(op1[1], op2[10]); accHi += hi;
    lo = op1[2]*op2[9]; accLow += lo;
    hi = mul_hi(op1[2], op2[9]); accHi += hi;
    lo = op1[3]*op2[8]; accLow += lo;
    hi = mul_hi(op1[3], op2[8]); accHi += hi;
    lo = op1[4]*op2[7]; accLow += lo;
    hi = mul_hi(op1[4], op2[7]); accHi += hi;
    lo = op1[5]*op2[6]; accLow += lo;
    hi = mul_hi(op1[5], op2[6]); accHi += hi;
    lo = op1[6]*op2[5]; accLow += lo;
    hi = mul_hi(op1[6], op2[5]); accHi += hi;
    lo = op1[7]*op2[4]; accLow += lo;
    hi = mul_hi(op1[7], op2[4]); accHi += hi;
    lo = op1[8]*op2[3]; accLow += lo;
    hi = mul_hi(op1[8], op2[3]); accHi += hi;
    lo = op1[9]*op2[2]; accLow += lo;
    hi = mul_hi(op1[9], op2[2]); accHi += hi;
    lo = op1[10]*op2[1]; accLow += lo;
    hi = mul_hi(op1[10], op2[1]); accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[2]*op2[10]; accLow += lo;
    hi = mul_hi(op1[2], op2[10]); accHi += hi;
    lo = op1[3]*op2[9]; accLow += lo;
    hi = mul_hi(op1[3], op2[9]); accHi += hi;
    lo = op1[4]*op2[8]; accLow += lo;
    hi = mul_hi(op1[4], op2[8]); accHi += hi;
    lo = op1[5]*op2[7]; accLow += lo;
    hi = mul_hi(op1[5], op2[7]); accHi += hi;
    lo = op1[6]*op2[6]; accLow += lo;
    hi = mul_hi(op1[6], op2[6]); accHi += hi;
    lo = op1[7]*op2[5]; accLow += lo;
    hi = mul_hi(op1[7], op2[5]); accHi += hi;
    lo = op1[8]*op2[4]; accLow += lo;
    hi = mul_hi(op1[8], op2[4]); accHi += hi;
    lo = op1[9]*op2[3]; accLow += lo;
    hi = mul_hi(op1[9], op2[3]); accHi += hi;
    lo = op1[10]*op2[2]; accLow += lo;
    hi = mul_hi(op1[10], op2[2]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[3]*op2[10]; accLow += lo;
    hi = mul_hi(op1[3], op2[10]); accHi += hi;
    lo = op1[4]*op2[9]; accLow += lo;
    hi = mul_hi(op1[4], op2[9]); accHi += hi;
    lo = op1[5]*op2[8]; accLow += lo;
    hi = mul_hi(op1[5], op2[8]); accHi += hi;
    lo = op1[6]*op2[7]; accLow += lo;
    hi = mul_hi(op1[6], op2[7]); accHi += hi;
    lo = op1[7]*op2[6]; accLow += lo;
    hi = mul_hi(op1[7], op2[6]); accHi += hi;
    lo = op1[8]*op2[5]; accLow += lo;
    hi = mul_hi(op1[8], op2[5]); accHi += hi;
    lo = op1[9]*op2[4]; accLow += lo;
    hi = mul_hi(op1[9], op2[4]); accHi += hi;
    lo = op1[10]*op2[3]; accLow += lo;
    hi = mul_hi(op1[10], op2[3]); accHi += hi;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[4]*op2[10]; accLow += lo;
    hi = mul_hi(op1[4], op2[10]); accHi += hi;
    lo = op1[5]*op2[9]; accLow += lo;
    hi = mul_hi(op1[5], op2[9]); accHi += hi;
    lo = op1[6]*op2[8]; accLow += lo;
    hi = mul_hi(op1[6], op2[8]); accHi += hi;
    lo = op1[7]*op2[7]; accLow += lo;
    hi = mul_hi(op1[7], op2[7]); accHi += hi;
    lo = op1[8]*op2[6]; accLow += lo;
    hi = mul_hi(op1[8], op2[6]); accHi += hi;
    lo = op1[9]*op2[5]; accLow += lo;
    hi = mul_hi(op1[9], op2[5]); accHi += hi;
    lo = op1[10]*op2[4]; accLow += lo;
    hi = mul_hi(op1[10], op2[4]); accHi += hi;
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[5]*op2[10]; accLow += lo;
    hi = mul_hi(op1[5], op2[10]); accHi += hi;
    lo = op1[6]*op2[9]; accLow += lo;
    hi = mul_hi(op1[6], op2[9]); accHi += hi;
    lo = op1[7]*op2[8]; accLow += lo;
    hi = mul_hi(op1[7], op2[8]); accHi += hi;
    lo = op1[8]*op2[7]; accLow += lo;
    hi = mul_hi(op1[8], op2[7]); accHi += hi;
    lo = op1[9]*op2[6]; accLow += lo;
    hi = mul_hi(op1[9], op2[6]); accHi += hi;
    lo = op1[10]*op2[5]; accLow += lo;
    hi = mul_hi(op1[10], op2[5]); accHi += hi;
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[6]*op2[10]; accLow += lo;
    hi = mul_hi(op1[6], op2[10]); accHi += hi;
    lo = op1[7]*op2[9]; accLow += lo;
    hi = mul_hi(op1[7], op2[9]); accHi += hi;
    lo = op1[8]*op2[8]; accLow += lo;
    hi = mul_hi(op1[8], op2[8]); accHi += hi;
    lo = op1[9]*op2[7]; accLow += lo;
    hi = mul_hi(op1[9], op2[7]); accHi += hi;
    lo = op1[10]*op2[6]; accLow += lo;
    hi = mul_hi(op1[10], op2[6]); accHi += hi;
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[7]*op2[10]; accLow += lo;
    hi = mul_hi(op1[7], op2[10]); accHi += hi;
    lo = op1[8]*op2[9]; accLow += lo;
    hi = mul_hi(op1[8], op2[9]); accHi += hi;
    lo = op1[9]*op2[8]; accLow += lo;
    hi = mul_hi(op1[9], op2[8]); accHi += hi;
    lo = op1[10]*op2[7]; accLow += lo;
    hi = mul_hi(op1[10], op2[7]); accHi += hi;
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[8]*op2[10]; accLow += lo;
    hi = mul_hi(op1[8], op2[10]); accHi += hi;
    lo = op1[9]*op2[9]; accLow += lo;
    hi = mul_hi(op1[9], op2[9]); accHi += hi;
    lo = op1[10]*op2[8]; accLow += lo;
    hi = mul_hi(op1[10], op2[8]); accHi += hi;
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[9]*op2[10]; accLow += lo;
    hi = mul_hi(op1[9], op2[10]); accHi += hi;
    lo = op1[10]*op2[9]; accLow += lo;
    hi = mul_hi(op1[10], op2[9]); accHi += hi;
    out[19] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[10]*op2[10]; accLow += lo;
    hi = mul_hi(op1[10], op2[10]); accHi += hi;
    out[20] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[21] = accLow;
}

void mulProductScan640to640(uint32_t *out, const uint32_t *op1, const uint32_t *op2)
{
  uint64_t accLow = 0;
  uint64_t accHi = 0;
  union {
    uint2 v32;
    ulong v64;
  } Int;
  uint32_t lo;
  uint32_t hi;
  {
    lo = op1[0]*op2[0]; accLow += lo;
    hi = mul_hi(op1[0], op2[0]); accHi += hi;
    out[0] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[1]; accLow += lo;
    hi = mul_hi(op1[0], op2[1]); accHi += hi;
    lo = op1[1]*op2[0]; accLow += lo;
    hi = mul_hi(op1[1], op2[0]); accHi += hi;
    out[1] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[2]; accLow += lo;
    hi = mul_hi(op1[0], op2[2]); accHi += hi;
    lo = op1[1]*op2[1]; accLow += lo;
    hi = mul_hi(op1[1], op2[1]); accHi += hi;
    lo = op1[2]*op2[0]; accLow += lo;
    hi = mul_hi(op1[2], op2[0]); accHi += hi;
    out[2] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[3]; accLow += lo;
    hi = mul_hi(op1[0], op2[3]); accHi += hi;
    lo = op1[1]*op2[2]; accLow += lo;
    hi = mul_hi(op1[1], op2[2]); accHi += hi;
    lo = op1[2]*op2[1]; accLow += lo;
    hi = mul_hi(op1[2], op2[1]); accHi += hi;
    lo = op1[3]*op2[0]; accLow += lo;
    hi = mul_hi(op1[3], op2[0]); accHi += hi;
    out[3] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[4]; accLow += lo;
    hi = mul_hi(op1[0], op2[4]); accHi += hi;
    lo = op1[1]*op2[3]; accLow += lo;
    hi = mul_hi(op1[1], op2[3]); accHi += hi;
    lo = op1[2]*op2[2]; accLow += lo;
    hi = mul_hi(op1[2], op2[2]); accHi += hi;
    lo = op1[3]*op2[1]; accLow += lo;
    hi = mul_hi(op1[3], op2[1]); accHi += hi;
    lo = op1[4]*op2[0]; accLow += lo;
    hi = mul_hi(op1[4], op2[0]); accHi += hi;
    out[4] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[5]; accLow += lo;
    hi = mul_hi(op1[0], op2[5]); accHi += hi;
    lo = op1[1]*op2[4]; accLow += lo;
    hi = mul_hi(op1[1], op2[4]); accHi += hi;
    lo = op1[2]*op2[3]; accLow += lo;
    hi = mul_hi(op1[2], op2[3]); accHi += hi;
    lo = op1[3]*op2[2]; accLow += lo;
    hi = mul_hi(op1[3], op2[2]); accHi += hi;
    lo = op1[4]*op2[1]; accLow += lo;
    hi = mul_hi(op1[4], op2[1]); accHi += hi;
    lo = op1[5]*op2[0]; accLow += lo;
    hi = mul_hi(op1[5], op2[0]); accHi += hi;
    out[5] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[6]; accLow += lo;
    hi = mul_hi(op1[0], op2[6]); accHi += hi;
    lo = op1[1]*op2[5]; accLow += lo;
    hi = mul_hi(op1[1], op2[5]); accHi += hi;
    lo = op1[2]*op2[4]; accLow += lo;
    hi = mul_hi(op1[2], op2[4]); accHi += hi;
    lo = op1[3]*op2[3]; accLow += lo;
    hi = mul_hi(op1[3], op2[3]); accHi += hi;
    lo = op1[4]*op2[2]; accLow += lo;
    hi = mul_hi(op1[4], op2[2]); accHi += hi;
    lo = op1[5]*op2[1]; accLow += lo;
    hi = mul_hi(op1[5], op2[1]); accHi += hi;
    lo = op1[6]*op2[0]; accLow += lo;
    hi = mul_hi(op1[6], op2[0]); accHi += hi;
    out[6] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[7]; accLow += lo;
    hi = mul_hi(op1[0], op2[7]); accHi += hi;
    lo = op1[1]*op2[6]; accLow += lo;
    hi = mul_hi(op1[1], op2[6]); accHi += hi;
    lo = op1[2]*op2[5]; accLow += lo;
    hi = mul_hi(op1[2], op2[5]); accHi += hi;
    lo = op1[3]*op2[4]; accLow += lo;
    hi = mul_hi(op1[3], op2[4]); accHi += hi;
    lo = op1[4]*op2[3]; accLow += lo;
    hi = mul_hi(op1[4], op2[3]); accHi += hi;
    lo = op1[5]*op2[2]; accLow += lo;
    hi = mul_hi(op1[5], op2[2]); accHi += hi;
    lo = op1[6]*op2[1]; accLow += lo;
    hi = mul_hi(op1[6], op2[1]); accHi += hi;
    lo = op1[7]*op2[0]; accLow += lo;
    hi = mul_hi(op1[7], op2[0]); accHi += hi;
    out[7] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[8]; accLow += lo;
    hi = mul_hi(op1[0], op2[8]); accHi += hi;
    lo = op1[1]*op2[7]; accLow += lo;
    hi = mul_hi(op1[1], op2[7]); accHi += hi;
    lo = op1[2]*op2[6]; accLow += lo;
    hi = mul_hi(op1[2], op2[6]); accHi += hi;
    lo = op1[3]*op2[5]; accLow += lo;
    hi = mul_hi(op1[3], op2[5]); accHi += hi;
    lo = op1[4]*op2[4]; accLow += lo;
    hi = mul_hi(op1[4], op2[4]); accHi += hi;
    lo = op1[5]*op2[3]; accLow += lo;
    hi = mul_hi(op1[5], op2[3]); accHi += hi;
    lo = op1[6]*op2[2]; accLow += lo;
    hi = mul_hi(op1[6], op2[2]); accHi += hi;
    lo = op1[7]*op2[1]; accLow += lo;
    hi = mul_hi(op1[7], op2[1]); accHi += hi;
    lo = op1[8]*op2[0]; accLow += lo;
    hi = mul_hi(op1[8], op2[0]); accHi += hi;
    out[8] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[9]; accLow += lo;
    hi = mul_hi(op1[0], op2[9]); accHi += hi;
    lo = op1[1]*op2[8]; accLow += lo;
    hi = mul_hi(op1[1], op2[8]); accHi += hi;
    lo = op1[2]*op2[7]; accLow += lo;
    hi = mul_hi(op1[2], op2[7]); accHi += hi;
    lo = op1[3]*op2[6]; accLow += lo;
    hi = mul_hi(op1[3], op2[6]); accHi += hi;
    lo = op1[4]*op2[5]; accLow += lo;
    hi = mul_hi(op1[4], op2[5]); accHi += hi;
    lo = op1[5]*op2[4]; accLow += lo;
    hi = mul_hi(op1[5], op2[4]); accHi += hi;
    lo = op1[6]*op2[3]; accLow += lo;
    hi = mul_hi(op1[6], op2[3]); accHi += hi;
    lo = op1[7]*op2[2]; accLow += lo;
    hi = mul_hi(op1[7], op2[2]); accHi += hi;
    lo = op1[8]*op2[1]; accLow += lo;
    hi = mul_hi(op1[8], op2[1]); accHi += hi;
    lo = op1[9]*op2[0]; accLow += lo;
    hi = mul_hi(op1[9], op2[0]); accHi += hi;
    out[9] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[10]; accLow += lo;
    hi = mul_hi(op1[0], op2[10]); accHi += hi;
    lo = op1[1]*op2[9]; accLow += lo;
    hi = mul_hi(op1[1], op2[9]); accHi += hi;
    lo = op1[2]*op2[8]; accLow += lo;
    hi = mul_hi(op1[2], op2[8]); accHi += hi;
    lo = op1[3]*op2[7]; accLow += lo;
    hi = mul_hi(op1[3], op2[7]); accHi += hi;
    lo = op1[4]*op2[6]; accLow += lo;
    hi = mul_hi(op1[4], op2[6]); accHi += hi;
    lo = op1[5]*op2[5]; accLow += lo;
    hi = mul_hi(op1[5], op2[5]); accHi += hi;
    lo = op1[6]*op2[4]; accLow += lo;
    hi = mul_hi(op1[6], op2[4]); accHi += hi;
    lo = op1[7]*op2[3]; accLow += lo;
    hi = mul_hi(op1[7], op2[3]); accHi += hi;
    lo = op1[8]*op2[2]; accLow += lo;
    hi = mul_hi(op1[8], op2[2]); accHi += hi;
    lo = op1[9]*op2[1]; accLow += lo;
    hi = mul_hi(op1[9], op2[1]); accHi += hi;
    lo = op1[10]*op2[0]; accLow += lo;
    hi = mul_hi(op1[10], op2[0]); accHi += hi;
    out[10] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[11]; accLow += lo;
    hi = mul_hi(op1[0], op2[11]); accHi += hi;
    lo = op1[1]*op2[10]; accLow += lo;
    hi = mul_hi(op1[1], op2[10]); accHi += hi;
    lo = op1[2]*op2[9]; accLow += lo;
    hi = mul_hi(op1[2], op2[9]); accHi += hi;
    lo = op1[3]*op2[8]; accLow += lo;
    hi = mul_hi(op1[3], op2[8]); accHi += hi;
    lo = op1[4]*op2[7]; accLow += lo;
    hi = mul_hi(op1[4], op2[7]); accHi += hi;
    lo = op1[5]*op2[6]; accLow += lo;
    hi = mul_hi(op1[5], op2[6]); accHi += hi;
    lo = op1[6]*op2[5]; accLow += lo;
    hi = mul_hi(op1[6], op2[5]); accHi += hi;
    lo = op1[7]*op2[4]; accLow += lo;
    hi = mul_hi(op1[7], op2[4]); accHi += hi;
    lo = op1[8]*op2[3]; accLow += lo;
    hi = mul_hi(op1[8], op2[3]); accHi += hi;
    lo = op1[9]*op2[2]; accLow += lo;
    hi = mul_hi(op1[9], op2[2]); accHi += hi;
    lo = op1[10]*op2[1]; accLow += lo;
    hi = mul_hi(op1[10], op2[1]); accHi += hi;
    lo = op1[11]*op2[0]; accLow += lo;
    hi = mul_hi(op1[11], op2[0]); accHi += hi;
    out[11] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[12]; accLow += lo;
    hi = mul_hi(op1[0], op2[12]); accHi += hi;
    lo = op1[1]*op2[11]; accLow += lo;
    hi = mul_hi(op1[1], op2[11]); accHi += hi;
    lo = op1[2]*op2[10]; accLow += lo;
    hi = mul_hi(op1[2], op2[10]); accHi += hi;
    lo = op1[3]*op2[9]; accLow += lo;
    hi = mul_hi(op1[3], op2[9]); accHi += hi;
    lo = op1[4]*op2[8]; accLow += lo;
    hi = mul_hi(op1[4], op2[8]); accHi += hi;
    lo = op1[5]*op2[7]; accLow += lo;
    hi = mul_hi(op1[5], op2[7]); accHi += hi;
    lo = op1[6]*op2[6]; accLow += lo;
    hi = mul_hi(op1[6], op2[6]); accHi += hi;
    lo = op1[7]*op2[5]; accLow += lo;
    hi = mul_hi(op1[7], op2[5]); accHi += hi;
    lo = op1[8]*op2[4]; accLow += lo;
    hi = mul_hi(op1[8], op2[4]); accHi += hi;
    lo = op1[9]*op2[3]; accLow += lo;
    hi = mul_hi(op1[9], op2[3]); accHi += hi;
    lo = op1[10]*op2[2]; accLow += lo;
    hi = mul_hi(op1[10], op2[2]); accHi += hi;
    lo = op1[11]*op2[1]; accLow += lo;
    hi = mul_hi(op1[11], op2[1]); accHi += hi;
    lo = op1[12]*op2[0]; accLow += lo;
    hi = mul_hi(op1[12], op2[0]); accHi += hi;
    out[12] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[13]; accLow += lo;
    hi = mul_hi(op1[0], op2[13]); accHi += hi;
    lo = op1[1]*op2[12]; accLow += lo;
    hi = mul_hi(op1[1], op2[12]); accHi += hi;
    lo = op1[2]*op2[11]; accLow += lo;
    hi = mul_hi(op1[2], op2[11]); accHi += hi;
    lo = op1[3]*op2[10]; accLow += lo;
    hi = mul_hi(op1[3], op2[10]); accHi += hi;
    lo = op1[4]*op2[9]; accLow += lo;
    hi = mul_hi(op1[4], op2[9]); accHi += hi;
    lo = op1[5]*op2[8]; accLow += lo;
    hi = mul_hi(op1[5], op2[8]); accHi += hi;
    lo = op1[6]*op2[7]; accLow += lo;
    hi = mul_hi(op1[6], op2[7]); accHi += hi;
    lo = op1[7]*op2[6]; accLow += lo;
    hi = mul_hi(op1[7], op2[6]); accHi += hi;
    lo = op1[8]*op2[5]; accLow += lo;
    hi = mul_hi(op1[8], op2[5]); accHi += hi;
    lo = op1[9]*op2[4]; accLow += lo;
    hi = mul_hi(op1[9], op2[4]); accHi += hi;
    lo = op1[10]*op2[3]; accLow += lo;
    hi = mul_hi(op1[10], op2[3]); accHi += hi;
    lo = op1[11]*op2[2]; accLow += lo;
    hi = mul_hi(op1[11], op2[2]); accHi += hi;
    lo = op1[12]*op2[1]; accLow += lo;
    hi = mul_hi(op1[12], op2[1]); accHi += hi;
    lo = op1[13]*op2[0]; accLow += lo;
    hi = mul_hi(op1[13], op2[0]); accHi += hi;
    out[13] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[14]; accLow += lo;
    hi = mul_hi(op1[0], op2[14]); accHi += hi;
    lo = op1[1]*op2[13]; accLow += lo;
    hi = mul_hi(op1[1], op2[13]); accHi += hi;
    lo = op1[2]*op2[12]; accLow += lo;
    hi = mul_hi(op1[2], op2[12]); accHi += hi;
    lo = op1[3]*op2[11]; accLow += lo;
    hi = mul_hi(op1[3], op2[11]); accHi += hi;
    lo = op1[4]*op2[10]; accLow += lo;
    hi = mul_hi(op1[4], op2[10]); accHi += hi;
    lo = op1[5]*op2[9]; accLow += lo;
    hi = mul_hi(op1[5], op2[9]); accHi += hi;
    lo = op1[6]*op2[8]; accLow += lo;
    hi = mul_hi(op1[6], op2[8]); accHi += hi;
    lo = op1[7]*op2[7]; accLow += lo;
    hi = mul_hi(op1[7], op2[7]); accHi += hi;
    lo = op1[8]*op2[6]; accLow += lo;
    hi = mul_hi(op1[8], op2[6]); accHi += hi;
    lo = op1[9]*op2[5]; accLow += lo;
    hi = mul_hi(op1[9], op2[5]); accHi += hi;
    lo = op1[10]*op2[4]; accLow += lo;
    hi = mul_hi(op1[10], op2[4]); accHi += hi;
    lo = op1[11]*op2[3]; accLow += lo;
    hi = mul_hi(op1[11], op2[3]); accHi += hi;
    lo = op1[12]*op2[2]; accLow += lo;
    hi = mul_hi(op1[12], op2[2]); accHi += hi;
    lo = op1[13]*op2[1]; accLow += lo;
    hi = mul_hi(op1[13], op2[1]); accHi += hi;
    lo = op1[14]*op2[0]; accLow += lo;
    hi = mul_hi(op1[14], op2[0]); accHi += hi;
    out[14] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[15]; accLow += lo;
    hi = mul_hi(op1[0], op2[15]); accHi += hi;
    lo = op1[1]*op2[14]; accLow += lo;
    hi = mul_hi(op1[1], op2[14]); accHi += hi;
    lo = op1[2]*op2[13]; accLow += lo;
    hi = mul_hi(op1[2], op2[13]); accHi += hi;
    lo = op1[3]*op2[12]; accLow += lo;
    hi = mul_hi(op1[3], op2[12]); accHi += hi;
    lo = op1[4]*op2[11]; accLow += lo;
    hi = mul_hi(op1[4], op2[11]); accHi += hi;
    lo = op1[5]*op2[10]; accLow += lo;
    hi = mul_hi(op1[5], op2[10]); accHi += hi;
    lo = op1[6]*op2[9]; accLow += lo;
    hi = mul_hi(op1[6], op2[9]); accHi += hi;
    lo = op1[7]*op2[8]; accLow += lo;
    hi = mul_hi(op1[7], op2[8]); accHi += hi;
    lo = op1[8]*op2[7]; accLow += lo;
    hi = mul_hi(op1[8], op2[7]); accHi += hi;
    lo = op1[9]*op2[6]; accLow += lo;
    hi = mul_hi(op1[9], op2[6]); accHi += hi;
    lo = op1[10]*op2[5]; accLow += lo;
    hi = mul_hi(op1[10], op2[5]); accHi += hi;
    lo = op1[11]*op2[4]; accLow += lo;
    hi = mul_hi(op1[11], op2[4]); accHi += hi;
    lo = op1[12]*op2[3]; accLow += lo;
    hi = mul_hi(op1[12], op2[3]); accHi += hi;
    lo = op1[13]*op2[2]; accLow += lo;
    hi = mul_hi(op1[13], op2[2]); accHi += hi;
    lo = op1[14]*op2[1]; accLow += lo;
    hi = mul_hi(op1[14], op2[1]); accHi += hi;
    lo = op1[15]*op2[0]; accLow += lo;
    hi = mul_hi(op1[15], op2[0]); accHi += hi;
    out[15] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[16]; accLow += lo;
    hi = mul_hi(op1[0], op2[16]); accHi += hi;
    lo = op1[1]*op2[15]; accLow += lo;
    hi = mul_hi(op1[1], op2[15]); accHi += hi;
    lo = op1[2]*op2[14]; accLow += lo;
    hi = mul_hi(op1[2], op2[14]); accHi += hi;
    lo = op1[3]*op2[13]; accLow += lo;
    hi = mul_hi(op1[3], op2[13]); accHi += hi;
    lo = op1[4]*op2[12]; accLow += lo;
    hi = mul_hi(op1[4], op2[12]); accHi += hi;
    lo = op1[5]*op2[11]; accLow += lo;
    hi = mul_hi(op1[5], op2[11]); accHi += hi;
    lo = op1[6]*op2[10]; accLow += lo;
    hi = mul_hi(op1[6], op2[10]); accHi += hi;
    lo = op1[7]*op2[9]; accLow += lo;
    hi = mul_hi(op1[7], op2[9]); accHi += hi;
    lo = op1[8]*op2[8]; accLow += lo;
    hi = mul_hi(op1[8], op2[8]); accHi += hi;
    lo = op1[9]*op2[7]; accLow += lo;
    hi = mul_hi(op1[9], op2[7]); accHi += hi;
    lo = op1[10]*op2[6]; accLow += lo;
    hi = mul_hi(op1[10], op2[6]); accHi += hi;
    lo = op1[11]*op2[5]; accLow += lo;
    hi = mul_hi(op1[11], op2[5]); accHi += hi;
    lo = op1[12]*op2[4]; accLow += lo;
    hi = mul_hi(op1[12], op2[4]); accHi += hi;
    lo = op1[13]*op2[3]; accLow += lo;
    hi = mul_hi(op1[13], op2[3]); accHi += hi;
    lo = op1[14]*op2[2]; accLow += lo;
    hi = mul_hi(op1[14], op2[2]); accHi += hi;
    lo = op1[15]*op2[1]; accLow += lo;
    hi = mul_hi(op1[15], op2[1]); accHi += hi;
    lo = op1[16]*op2[0]; accLow += lo;
    hi = mul_hi(op1[16], op2[0]); accHi += hi;
    out[16] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[17]; accLow += lo;
    hi = mul_hi(op1[0], op2[17]); accHi += hi;
    lo = op1[1]*op2[16]; accLow += lo;
    hi = mul_hi(op1[1], op2[16]); accHi += hi;
    lo = op1[2]*op2[15]; accLow += lo;
    hi = mul_hi(op1[2], op2[15]); accHi += hi;
    lo = op1[3]*op2[14]; accLow += lo;
    hi = mul_hi(op1[3], op2[14]); accHi += hi;
    lo = op1[4]*op2[13]; accLow += lo;
    hi = mul_hi(op1[4], op2[13]); accHi += hi;
    lo = op1[5]*op2[12]; accLow += lo;
    hi = mul_hi(op1[5], op2[12]); accHi += hi;
    lo = op1[6]*op2[11]; accLow += lo;
    hi = mul_hi(op1[6], op2[11]); accHi += hi;
    lo = op1[7]*op2[10]; accLow += lo;
    hi = mul_hi(op1[7], op2[10]); accHi += hi;
    lo = op1[8]*op2[9]; accLow += lo;
    hi = mul_hi(op1[8], op2[9]); accHi += hi;
    lo = op1[9]*op2[8]; accLow += lo;
    hi = mul_hi(op1[9], op2[8]); accHi += hi;
    lo = op1[10]*op2[7]; accLow += lo;
    hi = mul_hi(op1[10], op2[7]); accHi += hi;
    lo = op1[11]*op2[6]; accLow += lo;
    hi = mul_hi(op1[11], op2[6]); accHi += hi;
    lo = op1[12]*op2[5]; accLow += lo;
    hi = mul_hi(op1[12], op2[5]); accHi += hi;
    lo = op1[13]*op2[4]; accLow += lo;
    hi = mul_hi(op1[13], op2[4]); accHi += hi;
    lo = op1[14]*op2[3]; accLow += lo;
    hi = mul_hi(op1[14], op2[3]); accHi += hi;
    lo = op1[15]*op2[2]; accLow += lo;
    hi = mul_hi(op1[15], op2[2]); accHi += hi;
    lo = op1[16]*op2[1]; accLow += lo;
    hi = mul_hi(op1[16], op2[1]); accHi += hi;
    lo = op1[17]*op2[0]; accLow += lo;
    hi = mul_hi(op1[17], op2[0]); accHi += hi;
    out[17] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[18]; accLow += lo;
    hi = mul_hi(op1[0], op2[18]); accHi += hi;
    lo = op1[1]*op2[17]; accLow += lo;
    hi = mul_hi(op1[1], op2[17]); accHi += hi;
    lo = op1[2]*op2[16]; accLow += lo;
    hi = mul_hi(op1[2], op2[16]); accHi += hi;
    lo = op1[3]*op2[15]; accLow += lo;
    hi = mul_hi(op1[3], op2[15]); accHi += hi;
    lo = op1[4]*op2[14]; accLow += lo;
    hi = mul_hi(op1[4], op2[14]); accHi += hi;
    lo = op1[5]*op2[13]; accLow += lo;
    hi = mul_hi(op1[5], op2[13]); accHi += hi;
    lo = op1[6]*op2[12]; accLow += lo;
    hi = mul_hi(op1[6], op2[12]); accHi += hi;
    lo = op1[7]*op2[11]; accLow += lo;
    hi = mul_hi(op1[7], op2[11]); accHi += hi;
    lo = op1[8]*op2[10]; accLow += lo;
    hi = mul_hi(op1[8], op2[10]); accHi += hi;
    lo = op1[9]*op2[9]; accLow += lo;
    hi = mul_hi(op1[9], op2[9]); accHi += hi;
    lo = op1[10]*op2[8]; accLow += lo;
    hi = mul_hi(op1[10], op2[8]); accHi += hi;
    lo = op1[11]*op2[7]; accLow += lo;
    hi = mul_hi(op1[11], op2[7]); accHi += hi;
    lo = op1[12]*op2[6]; accLow += lo;
    hi = mul_hi(op1[12], op2[6]); accHi += hi;
    lo = op1[13]*op2[5]; accLow += lo;
    hi = mul_hi(op1[13], op2[5]); accHi += hi;
    lo = op1[14]*op2[4]; accLow += lo;
    hi = mul_hi(op1[14], op2[4]); accHi += hi;
    lo = op1[15]*op2[3]; accLow += lo;
    hi = mul_hi(op1[15], op2[3]); accHi += hi;
    lo = op1[16]*op2[2]; accLow += lo;
    hi = mul_hi(op1[16], op2[2]); accHi += hi;
    lo = op1[17]*op2[1]; accLow += lo;
    hi = mul_hi(op1[17], op2[1]); accHi += hi;
    lo = op1[18]*op2[0]; accLow += lo;
    hi = mul_hi(op1[18], op2[0]); accHi += hi;
    out[18] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[0]*op2[19]; accLow += lo;
    hi = mul_hi(op1[0], op2[19]); accHi += hi;
    lo = op1[1]*op2[18]; accLow += lo;
    hi = mul_hi(op1[1], op2[18]); accHi += hi;
    lo = op1[2]*op2[17]; accLow += lo;
    hi = mul_hi(op1[2], op2[17]); accHi += hi;
    lo = op1[3]*op2[16]; accLow += lo;
    hi = mul_hi(op1[3], op2[16]); accHi += hi;
    lo = op1[4]*op2[15]; accLow += lo;
    hi = mul_hi(op1[4], op2[15]); accHi += hi;
    lo = op1[5]*op2[14]; accLow += lo;
    hi = mul_hi(op1[5], op2[14]); accHi += hi;
    lo = op1[6]*op2[13]; accLow += lo;
    hi = mul_hi(op1[6], op2[13]); accHi += hi;
    lo = op1[7]*op2[12]; accLow += lo;
    hi = mul_hi(op1[7], op2[12]); accHi += hi;
    lo = op1[8]*op2[11]; accLow += lo;
    hi = mul_hi(op1[8], op2[11]); accHi += hi;
    lo = op1[9]*op2[10]; accLow += lo;
    hi = mul_hi(op1[9], op2[10]); accHi += hi;
    lo = op1[10]*op2[9]; accLow += lo;
    hi = mul_hi(op1[10], op2[9]); accHi += hi;
    lo = op1[11]*op2[8]; accLow += lo;
    hi = mul_hi(op1[11], op2[8]); accHi += hi;
    lo = op1[12]*op2[7]; accLow += lo;
    hi = mul_hi(op1[12], op2[7]); accHi += hi;
    lo = op1[13]*op2[6]; accLow += lo;
    hi = mul_hi(op1[13], op2[6]); accHi += hi;
    lo = op1[14]*op2[5]; accLow += lo;
    hi = mul_hi(op1[14], op2[5]); accHi += hi;
    lo = op1[15]*op2[4]; accLow += lo;
    hi = mul_hi(op1[15], op2[4]); accHi += hi;
    lo = op1[16]*op2[3]; accLow += lo;
    hi = mul_hi(op1[16], op2[3]); accHi += hi;
    lo = op1[17]*op2[2]; accLow += lo;
    hi = mul_hi(op1[17], op2[2]); accHi += hi;
    lo = op1[18]*op2[1]; accLow += lo;
    hi = mul_hi(op1[18], op2[1]); accHi += hi;
    lo = op1[19]*op2[0]; accLow += lo;
    hi = mul_hi(op1[19], op2[0]); accHi += hi;
    out[19] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[1]*op2[19]; accLow += lo;
    hi = mul_hi(op1[1], op2[19]); accHi += hi;
    lo = op1[2]*op2[18]; accLow += lo;
    hi = mul_hi(op1[2], op2[18]); accHi += hi;
    lo = op1[3]*op2[17]; accLow += lo;
    hi = mul_hi(op1[3], op2[17]); accHi += hi;
    lo = op1[4]*op2[16]; accLow += lo;
    hi = mul_hi(op1[4], op2[16]); accHi += hi;
    lo = op1[5]*op2[15]; accLow += lo;
    hi = mul_hi(op1[5], op2[15]); accHi += hi;
    lo = op1[6]*op2[14]; accLow += lo;
    hi = mul_hi(op1[6], op2[14]); accHi += hi;
    lo = op1[7]*op2[13]; accLow += lo;
    hi = mul_hi(op1[7], op2[13]); accHi += hi;
    lo = op1[8]*op2[12]; accLow += lo;
    hi = mul_hi(op1[8], op2[12]); accHi += hi;
    lo = op1[9]*op2[11]; accLow += lo;
    hi = mul_hi(op1[9], op2[11]); accHi += hi;
    lo = op1[10]*op2[10]; accLow += lo;
    hi = mul_hi(op1[10], op2[10]); accHi += hi;
    lo = op1[11]*op2[9]; accLow += lo;
    hi = mul_hi(op1[11], op2[9]); accHi += hi;
    lo = op1[12]*op2[8]; accLow += lo;
    hi = mul_hi(op1[12], op2[8]); accHi += hi;
    lo = op1[13]*op2[7]; accLow += lo;
    hi = mul_hi(op1[13], op2[7]); accHi += hi;
    lo = op1[14]*op2[6]; accLow += lo;
    hi = mul_hi(op1[14], op2[6]); accHi += hi;
    lo = op1[15]*op2[5]; accLow += lo;
    hi = mul_hi(op1[15], op2[5]); accHi += hi;
    lo = op1[16]*op2[4]; accLow += lo;
    hi = mul_hi(op1[16], op2[4]); accHi += hi;
    lo = op1[17]*op2[3]; accLow += lo;
    hi = mul_hi(op1[17], op2[3]); accHi += hi;
    lo = op1[18]*op2[2]; accLow += lo;
    hi = mul_hi(op1[18], op2[2]); accHi += hi;
    lo = op1[19]*op2[1]; accLow += lo;
    hi = mul_hi(op1[19], op2[1]); accHi += hi;
    out[20] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[2]*op2[19]; accLow += lo;
    hi = mul_hi(op1[2], op2[19]); accHi += hi;
    lo = op1[3]*op2[18]; accLow += lo;
    hi = mul_hi(op1[3], op2[18]); accHi += hi;
    lo = op1[4]*op2[17]; accLow += lo;
    hi = mul_hi(op1[4], op2[17]); accHi += hi;
    lo = op1[5]*op2[16]; accLow += lo;
    hi = mul_hi(op1[5], op2[16]); accHi += hi;
    lo = op1[6]*op2[15]; accLow += lo;
    hi = mul_hi(op1[6], op2[15]); accHi += hi;
    lo = op1[7]*op2[14]; accLow += lo;
    hi = mul_hi(op1[7], op2[14]); accHi += hi;
    lo = op1[8]*op2[13]; accLow += lo;
    hi = mul_hi(op1[8], op2[13]); accHi += hi;
    lo = op1[9]*op2[12]; accLow += lo;
    hi = mul_hi(op1[9], op2[12]); accHi += hi;
    lo = op1[10]*op2[11]; accLow += lo;
    hi = mul_hi(op1[10], op2[11]); accHi += hi;
    lo = op1[11]*op2[10]; accLow += lo;
    hi = mul_hi(op1[11], op2[10]); accHi += hi;
    lo = op1[12]*op2[9]; accLow += lo;
    hi = mul_hi(op1[12], op2[9]); accHi += hi;
    lo = op1[13]*op2[8]; accLow += lo;
    hi = mul_hi(op1[13], op2[8]); accHi += hi;
    lo = op1[14]*op2[7]; accLow += lo;
    hi = mul_hi(op1[14], op2[7]); accHi += hi;
    lo = op1[15]*op2[6]; accLow += lo;
    hi = mul_hi(op1[15], op2[6]); accHi += hi;
    lo = op1[16]*op2[5]; accLow += lo;
    hi = mul_hi(op1[16], op2[5]); accHi += hi;
    lo = op1[17]*op2[4]; accLow += lo;
    hi = mul_hi(op1[17], op2[4]); accHi += hi;
    lo = op1[18]*op2[3]; accLow += lo;
    hi = mul_hi(op1[18], op2[3]); accHi += hi;
    lo = op1[19]*op2[2]; accLow += lo;
    hi = mul_hi(op1[19], op2[2]); accHi += hi;
    out[21] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[3]*op2[19]; accLow += lo;
    hi = mul_hi(op1[3], op2[19]); accHi += hi;
    lo = op1[4]*op2[18]; accLow += lo;
    hi = mul_hi(op1[4], op2[18]); accHi += hi;
    lo = op1[5]*op2[17]; accLow += lo;
    hi = mul_hi(op1[5], op2[17]); accHi += hi;
    lo = op1[6]*op2[16]; accLow += lo;
    hi = mul_hi(op1[6], op2[16]); accHi += hi;
    lo = op1[7]*op2[15]; accLow += lo;
    hi = mul_hi(op1[7], op2[15]); accHi += hi;
    lo = op1[8]*op2[14]; accLow += lo;
    hi = mul_hi(op1[8], op2[14]); accHi += hi;
    lo = op1[9]*op2[13]; accLow += lo;
    hi = mul_hi(op1[9], op2[13]); accHi += hi;
    lo = op1[10]*op2[12]; accLow += lo;
    hi = mul_hi(op1[10], op2[12]); accHi += hi;
    lo = op1[11]*op2[11]; accLow += lo;
    hi = mul_hi(op1[11], op2[11]); accHi += hi;
    lo = op1[12]*op2[10]; accLow += lo;
    hi = mul_hi(op1[12], op2[10]); accHi += hi;
    lo = op1[13]*op2[9]; accLow += lo;
    hi = mul_hi(op1[13], op2[9]); accHi += hi;
    lo = op1[14]*op2[8]; accLow += lo;
    hi = mul_hi(op1[14], op2[8]); accHi += hi;
    lo = op1[15]*op2[7]; accLow += lo;
    hi = mul_hi(op1[15], op2[7]); accHi += hi;
    lo = op1[16]*op2[6]; accLow += lo;
    hi = mul_hi(op1[16], op2[6]); accHi += hi;
    lo = op1[17]*op2[5]; accLow += lo;
    hi = mul_hi(op1[17], op2[5]); accHi += hi;
    lo = op1[18]*op2[4]; accLow += lo;
    hi = mul_hi(op1[18], op2[4]); accHi += hi;
    lo = op1[19]*op2[3]; accLow += lo;
    hi = mul_hi(op1[19], op2[3]); accHi += hi;
    out[22] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[4]*op2[19]; accLow += lo;
    hi = mul_hi(op1[4], op2[19]); accHi += hi;
    lo = op1[5]*op2[18]; accLow += lo;
    hi = mul_hi(op1[5], op2[18]); accHi += hi;
    lo = op1[6]*op2[17]; accLow += lo;
    hi = mul_hi(op1[6], op2[17]); accHi += hi;
    lo = op1[7]*op2[16]; accLow += lo;
    hi = mul_hi(op1[7], op2[16]); accHi += hi;
    lo = op1[8]*op2[15]; accLow += lo;
    hi = mul_hi(op1[8], op2[15]); accHi += hi;
    lo = op1[9]*op2[14]; accLow += lo;
    hi = mul_hi(op1[9], op2[14]); accHi += hi;
    lo = op1[10]*op2[13]; accLow += lo;
    hi = mul_hi(op1[10], op2[13]); accHi += hi;
    lo = op1[11]*op2[12]; accLow += lo;
    hi = mul_hi(op1[11], op2[12]); accHi += hi;
    lo = op1[12]*op2[11]; accLow += lo;
    hi = mul_hi(op1[12], op2[11]); accHi += hi;
    lo = op1[13]*op2[10]; accLow += lo;
    hi = mul_hi(op1[13], op2[10]); accHi += hi;
    lo = op1[14]*op2[9]; accLow += lo;
    hi = mul_hi(op1[14], op2[9]); accHi += hi;
    lo = op1[15]*op2[8]; accLow += lo;
    hi = mul_hi(op1[15], op2[8]); accHi += hi;
    lo = op1[16]*op2[7]; accLow += lo;
    hi = mul_hi(op1[16], op2[7]); accHi += hi;
    lo = op1[17]*op2[6]; accLow += lo;
    hi = mul_hi(op1[17], op2[6]); accHi += hi;
    lo = op1[18]*op2[5]; accLow += lo;
    hi = mul_hi(op1[18], op2[5]); accHi += hi;
    lo = op1[19]*op2[4]; accLow += lo;
    hi = mul_hi(op1[19], op2[4]); accHi += hi;
    out[23] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[5]*op2[19]; accLow += lo;
    hi = mul_hi(op1[5], op2[19]); accHi += hi;
    lo = op1[6]*op2[18]; accLow += lo;
    hi = mul_hi(op1[6], op2[18]); accHi += hi;
    lo = op1[7]*op2[17]; accLow += lo;
    hi = mul_hi(op1[7], op2[17]); accHi += hi;
    lo = op1[8]*op2[16]; accLow += lo;
    hi = mul_hi(op1[8], op2[16]); accHi += hi;
    lo = op1[9]*op2[15]; accLow += lo;
    hi = mul_hi(op1[9], op2[15]); accHi += hi;
    lo = op1[10]*op2[14]; accLow += lo;
    hi = mul_hi(op1[10], op2[14]); accHi += hi;
    lo = op1[11]*op2[13]; accLow += lo;
    hi = mul_hi(op1[11], op2[13]); accHi += hi;
    lo = op1[12]*op2[12]; accLow += lo;
    hi = mul_hi(op1[12], op2[12]); accHi += hi;
    lo = op1[13]*op2[11]; accLow += lo;
    hi = mul_hi(op1[13], op2[11]); accHi += hi;
    lo = op1[14]*op2[10]; accLow += lo;
    hi = mul_hi(op1[14], op2[10]); accHi += hi;
    lo = op1[15]*op2[9]; accLow += lo;
    hi = mul_hi(op1[15], op2[9]); accHi += hi;
    lo = op1[16]*op2[8]; accLow += lo;
    hi = mul_hi(op1[16], op2[8]); accHi += hi;
    lo = op1[17]*op2[7]; accLow += lo;
    hi = mul_hi(op1[17], op2[7]); accHi += hi;
    lo = op1[18]*op2[6]; accLow += lo;
    hi = mul_hi(op1[18], op2[6]); accHi += hi;
    lo = op1[19]*op2[5]; accLow += lo;
    hi = mul_hi(op1[19], op2[5]); accHi += hi;
    out[24] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[6]*op2[19]; accLow += lo;
    hi = mul_hi(op1[6], op2[19]); accHi += hi;
    lo = op1[7]*op2[18]; accLow += lo;
    hi = mul_hi(op1[7], op2[18]); accHi += hi;
    lo = op1[8]*op2[17]; accLow += lo;
    hi = mul_hi(op1[8], op2[17]); accHi += hi;
    lo = op1[9]*op2[16]; accLow += lo;
    hi = mul_hi(op1[9], op2[16]); accHi += hi;
    lo = op1[10]*op2[15]; accLow += lo;
    hi = mul_hi(op1[10], op2[15]); accHi += hi;
    lo = op1[11]*op2[14]; accLow += lo;
    hi = mul_hi(op1[11], op2[14]); accHi += hi;
    lo = op1[12]*op2[13]; accLow += lo;
    hi = mul_hi(op1[12], op2[13]); accHi += hi;
    lo = op1[13]*op2[12]; accLow += lo;
    hi = mul_hi(op1[13], op2[12]); accHi += hi;
    lo = op1[14]*op2[11]; accLow += lo;
    hi = mul_hi(op1[14], op2[11]); accHi += hi;
    lo = op1[15]*op2[10]; accLow += lo;
    hi = mul_hi(op1[15], op2[10]); accHi += hi;
    lo = op1[16]*op2[9]; accLow += lo;
    hi = mul_hi(op1[16], op2[9]); accHi += hi;
    lo = op1[17]*op2[8]; accLow += lo;
    hi = mul_hi(op1[17], op2[8]); accHi += hi;
    lo = op1[18]*op2[7]; accLow += lo;
    hi = mul_hi(op1[18], op2[7]); accHi += hi;
    lo = op1[19]*op2[6]; accLow += lo;
    hi = mul_hi(op1[19], op2[6]); accHi += hi;
    out[25] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[7]*op2[19]; accLow += lo;
    hi = mul_hi(op1[7], op2[19]); accHi += hi;
    lo = op1[8]*op2[18]; accLow += lo;
    hi = mul_hi(op1[8], op2[18]); accHi += hi;
    lo = op1[9]*op2[17]; accLow += lo;
    hi = mul_hi(op1[9], op2[17]); accHi += hi;
    lo = op1[10]*op2[16]; accLow += lo;
    hi = mul_hi(op1[10], op2[16]); accHi += hi;
    lo = op1[11]*op2[15]; accLow += lo;
    hi = mul_hi(op1[11], op2[15]); accHi += hi;
    lo = op1[12]*op2[14]; accLow += lo;
    hi = mul_hi(op1[12], op2[14]); accHi += hi;
    lo = op1[13]*op2[13]; accLow += lo;
    hi = mul_hi(op1[13], op2[13]); accHi += hi;
    lo = op1[14]*op2[12]; accLow += lo;
    hi = mul_hi(op1[14], op2[12]); accHi += hi;
    lo = op1[15]*op2[11]; accLow += lo;
    hi = mul_hi(op1[15], op2[11]); accHi += hi;
    lo = op1[16]*op2[10]; accLow += lo;
    hi = mul_hi(op1[16], op2[10]); accHi += hi;
    lo = op1[17]*op2[9]; accLow += lo;
    hi = mul_hi(op1[17], op2[9]); accHi += hi;
    lo = op1[18]*op2[8]; accLow += lo;
    hi = mul_hi(op1[18], op2[8]); accHi += hi;
    lo = op1[19]*op2[7]; accLow += lo;
    hi = mul_hi(op1[19], op2[7]); accHi += hi;
    out[26] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[8]*op2[19]; accLow += lo;
    hi = mul_hi(op1[8], op2[19]); accHi += hi;
    lo = op1[9]*op2[18]; accLow += lo;
    hi = mul_hi(op1[9], op2[18]); accHi += hi;
    lo = op1[10]*op2[17]; accLow += lo;
    hi = mul_hi(op1[10], op2[17]); accHi += hi;
    lo = op1[11]*op2[16]; accLow += lo;
    hi = mul_hi(op1[11], op2[16]); accHi += hi;
    lo = op1[12]*op2[15]; accLow += lo;
    hi = mul_hi(op1[12], op2[15]); accHi += hi;
    lo = op1[13]*op2[14]; accLow += lo;
    hi = mul_hi(op1[13], op2[14]); accHi += hi;
    lo = op1[14]*op2[13]; accLow += lo;
    hi = mul_hi(op1[14], op2[13]); accHi += hi;
    lo = op1[15]*op2[12]; accLow += lo;
    hi = mul_hi(op1[15], op2[12]); accHi += hi;
    lo = op1[16]*op2[11]; accLow += lo;
    hi = mul_hi(op1[16], op2[11]); accHi += hi;
    lo = op1[17]*op2[10]; accLow += lo;
    hi = mul_hi(op1[17], op2[10]); accHi += hi;
    lo = op1[18]*op2[9]; accLow += lo;
    hi = mul_hi(op1[18], op2[9]); accHi += hi;
    lo = op1[19]*op2[8]; accLow += lo;
    hi = mul_hi(op1[19], op2[8]); accHi += hi;
    out[27] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[9]*op2[19]; accLow += lo;
    hi = mul_hi(op1[9], op2[19]); accHi += hi;
    lo = op1[10]*op2[18]; accLow += lo;
    hi = mul_hi(op1[10], op2[18]); accHi += hi;
    lo = op1[11]*op2[17]; accLow += lo;
    hi = mul_hi(op1[11], op2[17]); accHi += hi;
    lo = op1[12]*op2[16]; accLow += lo;
    hi = mul_hi(op1[12], op2[16]); accHi += hi;
    lo = op1[13]*op2[15]; accLow += lo;
    hi = mul_hi(op1[13], op2[15]); accHi += hi;
    lo = op1[14]*op2[14]; accLow += lo;
    hi = mul_hi(op1[14], op2[14]); accHi += hi;
    lo = op1[15]*op2[13]; accLow += lo;
    hi = mul_hi(op1[15], op2[13]); accHi += hi;
    lo = op1[16]*op2[12]; accLow += lo;
    hi = mul_hi(op1[16], op2[12]); accHi += hi;
    lo = op1[17]*op2[11]; accLow += lo;
    hi = mul_hi(op1[17], op2[11]); accHi += hi;
    lo = op1[18]*op2[10]; accLow += lo;
    hi = mul_hi(op1[18], op2[10]); accHi += hi;
    lo = op1[19]*op2[9]; accLow += lo;
    hi = mul_hi(op1[19], op2[9]); accHi += hi;
    out[28] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[10]*op2[19]; accLow += lo;
    hi = mul_hi(op1[10], op2[19]); accHi += hi;
    lo = op1[11]*op2[18]; accLow += lo;
    hi = mul_hi(op1[11], op2[18]); accHi += hi;
    lo = op1[12]*op2[17]; accLow += lo;
    hi = mul_hi(op1[12], op2[17]); accHi += hi;
    lo = op1[13]*op2[16]; accLow += lo;
    hi = mul_hi(op1[13], op2[16]); accHi += hi;
    lo = op1[14]*op2[15]; accLow += lo;
    hi = mul_hi(op1[14], op2[15]); accHi += hi;
    lo = op1[15]*op2[14]; accLow += lo;
    hi = mul_hi(op1[15], op2[14]); accHi += hi;
    lo = op1[16]*op2[13]; accLow += lo;
    hi = mul_hi(op1[16], op2[13]); accHi += hi;
    lo = op1[17]*op2[12]; accLow += lo;
    hi = mul_hi(op1[17], op2[12]); accHi += hi;
    lo = op1[18]*op2[11]; accLow += lo;
    hi = mul_hi(op1[18], op2[11]); accHi += hi;
    lo = op1[19]*op2[10]; accLow += lo;
    hi = mul_hi(op1[19], op2[10]); accHi += hi;
    out[29] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[11]*op2[19]; accLow += lo;
    hi = mul_hi(op1[11], op2[19]); accHi += hi;
    lo = op1[12]*op2[18]; accLow += lo;
    hi = mul_hi(op1[12], op2[18]); accHi += hi;
    lo = op1[13]*op2[17]; accLow += lo;
    hi = mul_hi(op1[13], op2[17]); accHi += hi;
    lo = op1[14]*op2[16]; accLow += lo;
    hi = mul_hi(op1[14], op2[16]); accHi += hi;
    lo = op1[15]*op2[15]; accLow += lo;
    hi = mul_hi(op1[15], op2[15]); accHi += hi;
    lo = op1[16]*op2[14]; accLow += lo;
    hi = mul_hi(op1[16], op2[14]); accHi += hi;
    lo = op1[17]*op2[13]; accLow += lo;
    hi = mul_hi(op1[17], op2[13]); accHi += hi;
    lo = op1[18]*op2[12]; accLow += lo;
    hi = mul_hi(op1[18], op2[12]); accHi += hi;
    lo = op1[19]*op2[11]; accLow += lo;
    hi = mul_hi(op1[19], op2[11]); accHi += hi;
    out[30] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[12]*op2[19]; accLow += lo;
    hi = mul_hi(op1[12], op2[19]); accHi += hi;
    lo = op1[13]*op2[18]; accLow += lo;
    hi = mul_hi(op1[13], op2[18]); accHi += hi;
    lo = op1[14]*op2[17]; accLow += lo;
    hi = mul_hi(op1[14], op2[17]); accHi += hi;
    lo = op1[15]*op2[16]; accLow += lo;
    hi = mul_hi(op1[15], op2[16]); accHi += hi;
    lo = op1[16]*op2[15]; accLow += lo;
    hi = mul_hi(op1[16], op2[15]); accHi += hi;
    lo = op1[17]*op2[14]; accLow += lo;
    hi = mul_hi(op1[17], op2[14]); accHi += hi;
    lo = op1[18]*op2[13]; accLow += lo;
    hi = mul_hi(op1[18], op2[13]); accHi += hi;
    lo = op1[19]*op2[12]; accLow += lo;
    hi = mul_hi(op1[19], op2[12]); accHi += hi;
    out[31] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[13]*op2[19]; accLow += lo;
    hi = mul_hi(op1[13], op2[19]); accHi += hi;
    lo = op1[14]*op2[18]; accLow += lo;
    hi = mul_hi(op1[14], op2[18]); accHi += hi;
    lo = op1[15]*op2[17]; accLow += lo;
    hi = mul_hi(op1[15], op2[17]); accHi += hi;
    lo = op1[16]*op2[16]; accLow += lo;
    hi = mul_hi(op1[16], op2[16]); accHi += hi;
    lo = op1[17]*op2[15]; accLow += lo;
    hi = mul_hi(op1[17], op2[15]); accHi += hi;
    lo = op1[18]*op2[14]; accLow += lo;
    hi = mul_hi(op1[18], op2[14]); accHi += hi;
    lo = op1[19]*op2[13]; accLow += lo;
    hi = mul_hi(op1[19], op2[13]); accHi += hi;
    out[32] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[14]*op2[19]; accLow += lo;
    hi = mul_hi(op1[14], op2[19]); accHi += hi;
    lo = op1[15]*op2[18]; accLow += lo;
    hi = mul_hi(op1[15], op2[18]); accHi += hi;
    lo = op1[16]*op2[17]; accLow += lo;
    hi = mul_hi(op1[16], op2[17]); accHi += hi;
    lo = op1[17]*op2[16]; accLow += lo;
    hi = mul_hi(op1[17], op2[16]); accHi += hi;
    lo = op1[18]*op2[15]; accLow += lo;
    hi = mul_hi(op1[18], op2[15]); accHi += hi;
    lo = op1[19]*op2[14]; accLow += lo;
    hi = mul_hi(op1[19], op2[14]); accHi += hi;
    out[33] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[15]*op2[19]; accLow += lo;
    hi = mul_hi(op1[15], op2[19]); accHi += hi;
    lo = op1[16]*op2[18]; accLow += lo;
    hi = mul_hi(op1[16], op2[18]); accHi += hi;
    lo = op1[17]*op2[17]; accLow += lo;
    hi = mul_hi(op1[17], op2[17]); accHi += hi;
    lo = op1[18]*op2[16]; accLow += lo;
    hi = mul_hi(op1[18], op2[16]); accHi += hi;
    lo = op1[19]*op2[15]; accLow += lo;
    hi = mul_hi(op1[19], op2[15]); accHi += hi;
    out[34] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[16]*op2[19]; accLow += lo;
    hi = mul_hi(op1[16], op2[19]); accHi += hi;
    lo = op1[17]*op2[18]; accLow += lo;
    hi = mul_hi(op1[17], op2[18]); accHi += hi;
    lo = op1[18]*op2[17]; accLow += lo;
    hi = mul_hi(op1[18], op2[17]); accHi += hi;
    lo = op1[19]*op2[16]; accLow += lo;
    hi = mul_hi(op1[19], op2[16]); accHi += hi;
    out[35] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[17]*op2[19]; accLow += lo;
    hi = mul_hi(op1[17], op2[19]); accHi += hi;
    lo = op1[18]*op2[18]; accLow += lo;
    hi = mul_hi(op1[18], op2[18]); accHi += hi;
    lo = op1[19]*op2[17]; accLow += lo;
    hi = mul_hi(op1[19], op2[17]); accHi += hi;
    out[36] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[18]*op2[19]; accLow += lo;
    hi = mul_hi(op1[18], op2[19]); accHi += hi;
    lo = op1[19]*op2[18]; accLow += lo;
    hi = mul_hi(op1[19], op2[18]); accHi += hi;
    out[37] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  {
    lo = op1[19]*op2[19]; accLow += lo;
    hi = mul_hi(op1[19], op2[19]); accHi += hi;
    out[38] = accLow;
    Int.v64 = accLow;
    accHi += Int.v32.y;
    accLow = accHi;
    accHi = 0;
  }
  out[39] = accLow;
}

uint32_t divide512to352reg(uint32_t dv0, uint32_t dv1, uint32_t dv2, uint32_t dv3, uint32_t dv4, uint32_t dv5, uint32_t dv6, uint32_t dv7, uint32_t dv8, uint32_t dv9, uint32_t dv10, uint32_t dv11, uint32_t dv12, uint32_t dv13, uint32_t dv14, uint32_t dv15,
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
    dv14 = (dv14 << shiftCount) | (dv13 >> (32-shiftCount));
    dv13 = (dv13 << shiftCount) | (dv12 >> (32-shiftCount));
    dv12 = (dv12 << shiftCount) | (dv11 >> (32-shiftCount));
    dv11 = (dv11 << shiftCount) | (dv10 >> (32-shiftCount));
    dv10 = (dv10 << shiftCount) | (dv9 >> (32-shiftCount));
    dv9 = (dv9 << shiftCount) | (dv8 >> (32-shiftCount));
    dv8 = (dv8 << shiftCount) | (dv7 >> (32-shiftCount));
    dv7 = (dv7 << shiftCount) | (dv6 >> (32-shiftCount));
    dv6 = (dv6 << shiftCount) | (dv5 >> (32-shiftCount));
    dv5 = (dv5 << shiftCount) | (dv4 >> (32-shiftCount));
    dv4 = (dv4 << shiftCount) | (dv3 >> (32-shiftCount));
    dv3 = (dv3 << shiftCount) | (dv2 >> (32-shiftCount));
    dv2 = (dv2 << shiftCount) | (dv1 >> (32-shiftCount));
    dv1 = (dv1 << shiftCount) | (dv0 >> (32-shiftCount));
    dv0 = dv0 << shiftCount;
  }

  while (dv15 == 0) {
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
    dividendSize--;
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

uint32_t divide480to320reg(uint32_t dv0, uint32_t dv1, uint32_t dv2, uint32_t dv3, uint32_t dv4, uint32_t dv5, uint32_t dv6, uint32_t dv7, uint32_t dv8, uint32_t dv9, uint32_t dv10, uint32_t dv11, uint32_t dv12, uint32_t dv13, uint32_t dv14,
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
    dv13 = (dv13 << shiftCount) | (dv12 >> (32-shiftCount));
    dv12 = (dv12 << shiftCount) | (dv11 >> (32-shiftCount));
    dv11 = (dv11 << shiftCount) | (dv10 >> (32-shiftCount));
    dv10 = (dv10 << shiftCount) | (dv9 >> (32-shiftCount));
    dv9 = (dv9 << shiftCount) | (dv8 >> (32-shiftCount));
    dv8 = (dv8 << shiftCount) | (dv7 >> (32-shiftCount));
    dv7 = (dv7 << shiftCount) | (dv6 >> (32-shiftCount));
    dv6 = (dv6 << shiftCount) | (dv5 >> (32-shiftCount));
    dv5 = (dv5 << shiftCount) | (dv4 >> (32-shiftCount));
    dv4 = (dv4 << shiftCount) | (dv3 >> (32-shiftCount));
    dv3 = (dv3 << shiftCount) | (dv2 >> (32-shiftCount));
    dv2 = (dv2 << shiftCount) | (dv1 >> (32-shiftCount));
    dv1 = (dv1 << shiftCount) | (dv0 >> (32-shiftCount));
    dv0 = dv0 << shiftCount;
  }

  while (dv14 == 0) {
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
    dividendSize--;
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

