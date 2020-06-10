#include "generic_config_kernel.h"
#include "generic_Fermat_procs.h"

__kernel void multiplyBenchmark320to96u(__global uint32_t *m1,
                                        __global uint32_t *m2,
                                        __global uint32_t *out,
                                        unsigned elementsNum)
{
#define Operand1Size 10
#define Operand2Size 3
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    mulProductScan320to96(result, op1, op2);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void multiplyBenchmark320to128u(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 10
#define Operand2Size 4
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    mulProductScan320to128(result, op1, op2);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void multiplyBenchmark320to192u(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 10
#define Operand2Size 6
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    mulProductScan320to192(result, op1, op2);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void multiplyBenchmark352to96u(__global uint32_t *m1,
                                        __global uint32_t *m2,
                                        __global uint32_t *out,
                                        unsigned elementsNum)
{
#define Operand1Size 11
#define Operand2Size 3
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    mulProductScan352to96(result, op1, op2);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void multiplyBenchmark352to128u(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 11
#define Operand2Size 4
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    mulProductScan352to128(result, op1, op2);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void multiplyBenchmark352to192u(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 11
#define Operand2Size 6
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    mulProductScan352to192(result, op1, op2);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void squareBenchmark320u(__global uint32_t *m1,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 10
#define ResultSize (2*OperandSize)
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);
  const unsigned ResultMemSize = (2*OperandMemSize);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*OperandMemSize + j];

    uint32_t result[ResultSize];
    sqrProductScan320(result, op1);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef ResultSize
#undef OperandSize
}

__kernel void squareBenchmark352u(__global uint32_t *m1,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 11
#define ResultSize (2*OperandSize)
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);
  const unsigned ResultMemSize = (2*OperandMemSize);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*OperandMemSize + j];

    uint32_t result[ResultSize];
    sqrProductScan352(result, op1);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef ResultSize
#undef OperandSize
}

__kernel void squareBenchmark640u(__global uint32_t *m1,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 20
#define ResultSize (2*OperandSize)
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);
  const unsigned ResultMemSize = (2*OperandMemSize);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*OperandMemSize + j];

    uint32_t result[ResultSize];
    sqrProductScan640(result, op1);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef ResultSize
#undef OperandSize
}

__kernel void multiplyBenchmark320to320u(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 10
#define Operand2Size 10
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    mulProductScan320to320(result, op1, op2);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void multiplyBenchmark352to352u(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 11
#define Operand2Size 11
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    mulProductScan352to352(result, op1, op2);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void multiplyBenchmark640to640u(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 20
#define Operand2Size 20
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    mulProductScan640to640(result, op1, op2);

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void squareBenchmark320p(__global uint32_t *m1,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 10
#define ResultSize (2*OperandSize)
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);
  const unsigned ResultMemSize = (2*OperandMemSize);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*OperandMemSize + j];

    uint32_t result[ResultSize];
    for (unsigned repeatNum = 0; repeatNum < MulOpsNum; repeatNum++) {
      sqrProductScan320(result, op1);
      for (unsigned k = 0; k < OperandSize; k++)
        op1[k] = result[k+OperandSize];
    }

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef ResultSize
#undef OperandSize
}

__kernel void squareBenchmark352p(__global uint32_t *m1,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 11
#define ResultSize (2*OperandSize)
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);
  const unsigned ResultMemSize = (2*OperandMemSize);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*OperandMemSize + j];

    uint32_t result[ResultSize];
    for (unsigned repeatNum = 0; repeatNum < MulOpsNum; repeatNum++) {
      sqrProductScan352(result, op1);
      for (unsigned k = 0; k < OperandSize; k++)
        op1[k] = result[k+OperandSize];
    }

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef ResultSize
#undef OperandSize
}

__kernel void squareBenchmark640p(__global uint32_t *m1,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 20
#define ResultSize (2*OperandSize)
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);
  const unsigned ResultMemSize = (2*OperandMemSize);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*OperandMemSize + j];

    uint32_t result[ResultSize];
    for (unsigned repeatNum = 0; repeatNum < MulOpsNum; repeatNum++) {
      sqrProductScan640(result, op1);
      for (unsigned k = 0; k < OperandSize; k++)
        op1[k] = result[k+OperandSize];
    }

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef ResultSize
#undef OperandSize
}

__kernel void multiplyBenchmark320to320p(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 10
#define Operand2Size 10
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    for (unsigned repeatNum = 0; repeatNum < MulOpsNum; repeatNum++) {
      mulProductScan320to320(result, op1, op2);
      for (unsigned k = 0; k < Operand1Size; k++)
        op1[k] = result[k+Operand2Size];
    }

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void multiplyBenchmark352to352p(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 11
#define Operand2Size 11
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    for (unsigned repeatNum = 0; repeatNum < MulOpsNum; repeatNum++) {
      mulProductScan352to352(result, op1, op2);
      for (unsigned k = 0; k < Operand1Size; k++)
        op1[k] = result[k+Operand2Size];
    }

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void multiplyBenchmark640to640p(__global uint32_t *m1,
                                         __global uint32_t *m2,
                                         __global uint32_t *out,
                                         unsigned elementsNum)
{
#define Operand1Size 20
#define Operand2Size 20
#define ResultSize (Operand1Size + Operand2Size)
  const unsigned Operand1MemSize = Operand1Size + (Operand1Size % 2);
  const unsigned Operand2MemSize = Operand2Size + (Operand2Size % 2);
  const unsigned ResultMemSize = Operand1MemSize + Operand2MemSize;

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[Operand1Size];
    uint32_t op2[Operand2Size];
    for (unsigned j = 0; j < Operand1Size; j++)
      op1[j] = m1[i*Operand1MemSize + j];
    for (unsigned j = 0; j < Operand2Size; j++)
      op2[j] = m2[i*Operand2MemSize + j];

    uint32_t result[ResultSize];
    for (unsigned repeatNum = 0; repeatNum < MulOpsNum; repeatNum++) {
      mulProductScan640to640(result, op1, op2);
      for (unsigned k = 0; k < Operand1Size; k++)
        op1[k] = result[k+Operand2Size];
    }

    for (unsigned j = 0; j < ResultSize; j++)
      out[i*ResultMemSize + j] = result[j];
  }
#undef Operand1Size
#undef Operand2Size
#undef ResultSize
}

__kernel void monsqrBenchmark320u(__global uint32_t *m1,
                                  __global uint32_t *mmod,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 10
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op[OperandSize];
    uint32_t mod[OperandSize];

    for (unsigned j = 0; j < OperandSize; j++)
      op[j] = m1[i*OperandMemSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      mod[j] = mmod[i*OperandMemSize + j];

    monSqr320(op, mod, invert_limb(mod[0]));

    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = op[j];
  }
#undef OperandSize
}

__kernel void monmulBenchmark320u(__global uint32_t *m1,
                                  __global uint32_t *m2,
                                  __global uint32_t *mmod,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 10
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    uint32_t op2[OperandSize];
    uint32_t mod[OperandSize];

    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*OperandMemSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      op2[j] = m2[i*OperandMemSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      mod[j] = mmod[i*OperandMemSize + j];

    monMul320(op1, op2, mod, invert_limb(mod[0]));

    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = op1[j];
  }
#undef OperandSize
}

__kernel void redchalfBenchmark320u(__global uint32_t *m1,
                                    __global uint32_t *mmod,
                                    __global uint32_t *out,
                                    unsigned elementsNum)
{
#define OperandSize 10
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op[OperandSize];
    uint32_t mod[OperandSize];

    for (unsigned j = 0; j < OperandSize; j++)
      op[j] = m1[i*OperandMemSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      mod[j] = mmod[i*OperandMemSize + j];

    redcHalf320(op, mod, invert_limb(mod[0]));

    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = op[j];
  }
#undef OperandSize
}

__kernel void redcifyBenchmark320u(__global uint32_t *mquotient,
                                   __global uint32_t *mmod,
                                   __global uint32_t *out,
                                   unsigned elementsNum)
{
#define OperandSize 10
#define WindowSize 7
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t quotient[OperandSize];
    uint32_t mod[OperandSize];
    uint32_t result[OperandSize];

    for (unsigned j = 0; j < 8; j++)
      quotient[j] = mquotient[i*8 + j];
    for (unsigned j = 0; j < OperandSize; j++)
      mod[j] = mmod[i*OperandMemSize + j];

    redcify320(i % (1 << WindowSize), quotient, mod, result, WindowSize);

    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = result[j];
  }
#undef OperandSize
}

__kernel void monsqrBenchmark352u(__global uint32_t *m1,
                                  __global uint32_t *mmod,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 11
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op[OperandSize];
    uint32_t mod[OperandSize];

    for (unsigned j = 0; j < OperandSize; j++)
      op[j] = m1[i*OperandMemSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      mod[j] = mmod[i*OperandMemSize + j];

    monSqr352(op, mod, invert_limb(mod[0]));

    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = op[j];
  }
#undef OperandSize
}

__kernel void monmulBenchmark352u(__global uint32_t *m1,
                                  __global uint32_t *m2,
                                  __global uint32_t *mmod,
                                  __global uint32_t *out,
                                  unsigned elementsNum)
{
#define OperandSize 11
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    uint32_t op2[OperandSize];
    uint32_t mod[OperandSize];

    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*OperandMemSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      op2[j] = m2[i*OperandMemSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      mod[j] = mmod[i*OperandMemSize + j];

    monMul352(op1, op2, mod, invert_limb(mod[0]));

    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = op1[j];
  }
#undef OperandSize
}

__kernel void redchalfBenchmark352u(__global uint32_t *m1,
                                    __global uint32_t *mmod,
                                    __global uint32_t *out,
                                    unsigned elementsNum)
{
#define OperandSize 11
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op[OperandSize];
    uint32_t mod[OperandSize];

    for (unsigned j = 0; j < OperandSize; j++)
      op[j] = m1[i*OperandMemSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      mod[j] = mmod[i*OperandMemSize + j];

    redcHalf352(op, mod, invert_limb(mod[0]));

    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = op[j];
  }
#undef OperandSize
}

__kernel void redcifyBenchmark352u(__global uint32_t *mquotient,
                                   __global uint32_t *mmod,
                                   __global uint32_t *out,
                                   unsigned elementsNum)
{
#define OperandSize 11
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t quotient[OperandSize];
    uint32_t mod[OperandSize];
    uint32_t result[OperandSize];

    for (unsigned j = 0; j < 8; j++)
      quotient[j] = mquotient[i*8 + j];
    for (unsigned j = 0; j < OperandSize; j++)
      mod[j] = mmod[i*OperandMemSize + j];

    redcify352(i % (1 << WindowSize), quotient, mod, result, WindowSize);

    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = result[j];
  }
#undef OperandSize
}

__kernel void divideBenchmark480to320u(__global uint32_t *mdivisor,
                                       __global uint32_t *mquotient,
                                       __global uint32_t *msize,
                                       unsigned elementsNum)
{
#define OperandSize 10
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t d[OperandSize];
    uint32_t q[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    for (unsigned j = 0; j < OperandSize; j++)
      d[j] = mdivisor[i*OperandMemSize + j];

    int remaining = divide480to320reg(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                      d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8], d[9],
                      &q[0], &q[1], &q[2], &q[3], &q[4], &q[5], &q[6], &q[7]);

    for (unsigned j = 0; j < 8; j++)
      mquotient[i*8 + j] = q[j];
    msize[i] = remaining;
  }

#undef OperandSize
}

__kernel void divideBenchmark512to352u(__global uint32_t *mdivisor,
                                       __global uint32_t *mquotient,
                                       __global uint32_t *msize,
                                       unsigned elementsNum)
{
#define OperandSize 11
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);

  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t d[OperandSize];
    uint32_t q[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    for (unsigned j = 0; j < OperandSize; j++)
      d[j] = mdivisor[i*OperandMemSize + j];

  int remaining = divide512to352reg(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                    d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8], d[9], d[10],
                    &q[0], &q[1], &q[2], &q[3], &q[4], &q[5], &q[6], &q[7]);

    for (unsigned j = 0; j < 8; j++)
      mquotient[i*8 + j] = q[j];
    msize[i] = remaining;
  }

#undef OperandSize
}

__kernel void fermatTestBenchmark320(__global uint32_t *restrict numbers,
                                     __global uint32_t *restrict out,
                                     unsigned elementsNum)
{
#define OperandSize 10  
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);
  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t lNumbers[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      lNumbers[j] = numbers[i*OperandMemSize+j];

    uint4 result[3];
    
    uint4 lNumbersv[3] = {
      (uint4){lNumbers[0], lNumbers[1], lNumbers[2], lNumbers[3]}, 
      (uint4){lNumbers[4], lNumbers[5], lNumbers[6], lNumbers[7]}, 
      (uint4){lNumbers[8], lNumbers[9], 0, 0}
    };    

    FermatTest320(lNumbersv, result);
      
    uint32_t *pResult = (uint32_t*)result;    
    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = pResult[j];
  }
#undef OperandSize
}


__kernel void fermatTestBenchmark352(__global uint32_t *restrict numbers,
                                     __global uint32_t *restrict out,
                                     unsigned elementsNum)
{
#define OperandSize 11  
  const unsigned OperandMemSize = OperandSize + (OperandSize % 2);
  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t lNumbers[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      lNumbers[j] = numbers[i*OperandMemSize+j];

    uint4 result[3];
    
    uint4 lNumbersv[3] = {
      (uint4){lNumbers[0], lNumbers[1], lNumbers[2], lNumbers[3]}, 
      (uint4){lNumbers[4], lNumbers[5], lNumbers[6], lNumbers[7]}, 
      (uint4){lNumbers[8], lNumbers[9], lNumbers[10], 0}
    };    

    FermatTest352(lNumbersv, result);
      
    uint32_t *pResult = (uint32_t*)result;    
    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandMemSize + j] = pResult[j];
  }
#undef OperandSize
}
