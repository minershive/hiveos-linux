__kernel void squareBenchmark320(__global uint32_t *m1,
                                 __global uint32_t *out,
                                 unsigned elementsNum)
{
#define OperandSize 10
#define GmpOperandSize 10
  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*GmpOperandSize + j];  

      uint32_t result[20];

    for (unsigned repeatNum = 0; repeatNum < 512; repeatNum++) {
      sqrProductScan320(result, op1);
      for (unsigned k = 0; k < 10; k++)
        op1[k] = result[k+10];
    }

    for (unsigned j = 0; j < OperandSize*2; j++)
      out[i*OperandSize*2 + j] = result[j];
  }
#undef GmpOperandSize
#undef OperandSize
}

__kernel void squareBenchmark352(__global uint32_t *m1,
                                 __global uint32_t *out,
                                 unsigned elementsNum)
{
#define OperandSize 11
#define GmpOperandSize 12  
  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*GmpOperandSize + j];  

    uint32_t result[22];
    for (unsigned repeatNum = 0; repeatNum < 512; repeatNum++) {
      sqrProductScan352(result, op1);
      for (unsigned k = 0; k < 11; k++)
        op1[k] = result[k+11];      
    }

    for (unsigned j = 0; j < OperandSize*2; j++)
      out[i*OperandSize*2 + j] = result[j];
  }
#undef GmpOperandSize
#undef OperandSize
}


__kernel void multiplyBenchmark320(__global uint32_t *m1,
                                   __global uint32_t *m2,
                                   __global uint32_t *out,
                                   unsigned elementsNum)
{
#define OperandSize 10
#define GmpOperandSize 10  
  unsigned globalSize = get_global_size(0);

  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    uint32_t op2[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*GmpOperandSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      op2[j] = m2[i*GmpOperandSize + j];    
    
    uint32_t result[20];

    for (unsigned repeatNum = 0; repeatNum < 512; repeatNum++) {
      mulProductScan320to320(result, op1, op2);
      for (unsigned k = 0; k < 10; k++)
        op1[k] = result[k+10];      
    }

    for (unsigned j = 0; j < OperandSize*2; j++)
      out[i*OperandSize*2 + j] = result[j];
  }
#undef GmpOperandSize
#undef OperandSize
}

__kernel void multiplyBenchmark352(__global uint32_t *m1,
                                   __global uint32_t *m2,
                                   __global uint32_t *out,
                                   unsigned elementsNum)
{
#define OperandSize 11
#define GmpOperandSize 12  
  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t op1[OperandSize];
    uint32_t op2[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      op1[j] = m1[i*GmpOperandSize + j];
    for (unsigned j = 0; j < OperandSize; j++)
      op2[j] = m2[i*GmpOperandSize + j];    
    
    uint32_t result[22];    

    for (unsigned repeatNum = 0; repeatNum < 512; repeatNum++) {
      mulProductScan352to352(result, op1, op2);
      for (unsigned k = 0; k < 11; k++)
        op1[k] = result[k+11];         
    }

    for (unsigned j = 0; j < OperandSize*2; j++)
      out[i*OperandSize*2 + j] = result[j];
  }
  
#undef GmpOperandSize
#undef OperandSize
}


__kernel void fermatTestBenchMark320(__global uint32_t *restrict numbers,
                                     __global uint32_t *restrict out,
                                     unsigned elementsNum)
{
#define OperandSize 10  
  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t lNumbers[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      lNumbers[j] = numbers[i*OperandSize+j];

    uint4 result[3];
    
    uint4 lNumbersv[3] = {
      (uint4){lNumbers[0], lNumbers[1], lNumbers[2], lNumbers[3]}, 
      (uint4){lNumbers[4], lNumbers[5], lNumbers[6], lNumbers[7]}, 
      (uint4){lNumbers[8], lNumbers[9], 0, 0}
    };    

    FermatTest320(lNumbersv, result);
      
    uint32_t *pResult = (uint32_t*)result;    
    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandSize + j] = pResult[j];  
  }
#undef OperandSize
}


__kernel void fermatTestBenchMark352(__global uint32_t *restrict numbers,
                                     __global uint32_t *restrict out,
                                     unsigned elementsNum)
{
#define OperandSize 11  
  unsigned globalSize = get_global_size(0);
  for (unsigned i = get_global_id(0); i < elementsNum; i += globalSize) {
    uint32_t lNumbers[OperandSize];
    for (unsigned j = 0; j < OperandSize; j++)
      lNumbers[j] = numbers[i*OperandSize+j];

    uint4 result[3];
    
    uint4 lNumbersv[3] = {
      (uint4){lNumbers[0], lNumbers[1], lNumbers[2], lNumbers[3]}, 
      (uint4){lNumbers[4], lNumbers[5], lNumbers[6], lNumbers[7]}, 
      (uint4){lNumbers[8], lNumbers[9], lNumbers[10], 0}
    };    

    FermatTest352(lNumbersv, result);
      
    uint32_t *pResult = (uint32_t*)result;    
    for (unsigned j = 0; j < OperandSize; j++)
      out[i*OperandSize + j] = pResult[j];  
  }
#undef OperandSize
}
