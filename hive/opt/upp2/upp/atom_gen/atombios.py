# -*- coding: utf-8 -*-
#
# TARGET arch is: ['--include', 'stdint.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '--include', 'linux/drivers/gpu/drm/amd/include/atom-types.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '']
# WORD_SIZE is: 8
# POINTER_SIZE is: 8
# LONGDOUBLE_SIZE is: 16
#
import ctypes




class struct__ATOM_COMMON_TABLE_HEADER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usStructureSize', ctypes.c_uint16),
    ('ucTableFormatRevision', ctypes.c_ubyte),
    ('ucTableContentRevision', ctypes.c_ubyte),
     ]

class struct__ATOM_ROM_HEADER(ctypes.Structure):
    pass

ATOM_COMMON_TABLE_HEADER = struct__ATOM_COMMON_TABLE_HEADER
struct__ATOM_ROM_HEADER._pack_ = True # source:False
struct__ATOM_ROM_HEADER._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('uaFirmWareSignature', ctypes.c_ubyte * 4),
    ('usBiosRuntimeSegmentAddress', ctypes.c_uint16),
    ('usProtectedModeInfoOffset', ctypes.c_uint16),
    ('usConfigFilenameOffset', ctypes.c_uint16),
    ('usCRC_BlockOffset', ctypes.c_uint16),
    ('usBIOS_BootupMessageOffset', ctypes.c_uint16),
    ('usInt10Offset', ctypes.c_uint16),
    ('usPciBusDevInitCode', ctypes.c_uint16),
    ('usIoBaseAddress', ctypes.c_uint16),
    ('usSubsystemVendorID', ctypes.c_uint16),
    ('usSubsystemID', ctypes.c_uint16),
    ('usPCI_InfoOffset', ctypes.c_uint16),
    ('usMasterCommandTableOffset', ctypes.c_uint16),
    ('usMasterDataTableOffset', ctypes.c_uint16),
    ('ucExtendedFunctionCode', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
]

class struct__ATOM_ROM_HEADER_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('uaFirmWareSignature', ctypes.c_ubyte * 4),
    ('usBiosRuntimeSegmentAddress', ctypes.c_uint16),
    ('usProtectedModeInfoOffset', ctypes.c_uint16),
    ('usConfigFilenameOffset', ctypes.c_uint16),
    ('usCRC_BlockOffset', ctypes.c_uint16),
    ('usBIOS_BootupMessageOffset', ctypes.c_uint16),
    ('usInt10Offset', ctypes.c_uint16),
    ('usPciBusDevInitCode', ctypes.c_uint16),
    ('usIoBaseAddress', ctypes.c_uint16),
    ('usSubsystemVendorID', ctypes.c_uint16),
    ('usSubsystemID', ctypes.c_uint16),
    ('usPCI_InfoOffset', ctypes.c_uint16),
    ('usMasterCommandTableOffset', ctypes.c_uint16),
    ('usMasterDataTableOffset', ctypes.c_uint16),
    ('ucExtendedFunctionCode', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ulPSPDirTableOffset', ctypes.c_uint32),
     ]

class struct__ATOM_MASTER_LIST_OF_COMMAND_TABLES(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ASIC_Init', ctypes.c_uint16),
    ('GetDisplaySurfaceSize', ctypes.c_uint16),
    ('ASIC_RegistersInit', ctypes.c_uint16),
    ('VRAM_BlockVenderDetection', ctypes.c_uint16),
    ('DIGxEncoderControl', ctypes.c_uint16),
    ('MemoryControllerInit', ctypes.c_uint16),
    ('EnableCRTCMemReq', ctypes.c_uint16),
    ('MemoryParamAdjust', ctypes.c_uint16),
    ('DVOEncoderControl', ctypes.c_uint16),
    ('GPIOPinControl', ctypes.c_uint16),
    ('SetEngineClock', ctypes.c_uint16),
    ('SetMemoryClock', ctypes.c_uint16),
    ('SetPixelClock', ctypes.c_uint16),
    ('EnableDispPowerGating', ctypes.c_uint16),
    ('ResetMemoryDLL', ctypes.c_uint16),
    ('ResetMemoryDevice', ctypes.c_uint16),
    ('MemoryPLLInit', ctypes.c_uint16),
    ('AdjustDisplayPll', ctypes.c_uint16),
    ('AdjustMemoryController', ctypes.c_uint16),
    ('EnableASIC_StaticPwrMgt', ctypes.c_uint16),
    ('SetUniphyInstance', ctypes.c_uint16),
    ('DAC_LoadDetection', ctypes.c_uint16),
    ('LVTMAEncoderControl', ctypes.c_uint16),
    ('HW_Misc_Operation', ctypes.c_uint16),
    ('DAC1EncoderControl', ctypes.c_uint16),
    ('DAC2EncoderControl', ctypes.c_uint16),
    ('DVOOutputControl', ctypes.c_uint16),
    ('CV1OutputControl', ctypes.c_uint16),
    ('GetConditionalGoldenSetting', ctypes.c_uint16),
    ('SMC_Init', ctypes.c_uint16),
    ('PatchMCSetting', ctypes.c_uint16),
    ('MC_SEQ_Control', ctypes.c_uint16),
    ('Gfx_Harvesting', ctypes.c_uint16),
    ('EnableScaler', ctypes.c_uint16),
    ('BlankCRTC', ctypes.c_uint16),
    ('EnableCRTC', ctypes.c_uint16),
    ('GetPixelClock', ctypes.c_uint16),
    ('EnableVGA_Render', ctypes.c_uint16),
    ('GetSCLKOverMCLKRatio', ctypes.c_uint16),
    ('SetCRTC_Timing', ctypes.c_uint16),
    ('SetCRTC_OverScan', ctypes.c_uint16),
    ('GetSMUClockInfo', ctypes.c_uint16),
    ('SelectCRTC_Source', ctypes.c_uint16),
    ('EnableGraphSurfaces', ctypes.c_uint16),
    ('UpdateCRTC_DoubleBufferRegisters', ctypes.c_uint16),
    ('LUT_AutoFill', ctypes.c_uint16),
    ('SetDCEClock', ctypes.c_uint16),
    ('GetMemoryClock', ctypes.c_uint16),
    ('GetEngineClock', ctypes.c_uint16),
    ('SetCRTC_UsingDTDTiming', ctypes.c_uint16),
    ('ExternalEncoderControl', ctypes.c_uint16),
    ('LVTMAOutputControl', ctypes.c_uint16),
    ('VRAM_BlockDetectionByStrap', ctypes.c_uint16),
    ('MemoryCleanUp', ctypes.c_uint16),
    ('ProcessI2cChannelTransaction', ctypes.c_uint16),
    ('WriteOneByteToHWAssistedI2C', ctypes.c_uint16),
    ('ReadHWAssistedI2CStatus', ctypes.c_uint16),
    ('SpeedFanControl', ctypes.c_uint16),
    ('PowerConnectorDetection', ctypes.c_uint16),
    ('MC_Synchronization', ctypes.c_uint16),
    ('ComputeMemoryEnginePLL', ctypes.c_uint16),
    ('Gfx_Init', ctypes.c_uint16),
    ('VRAM_GetCurrentInfoBlock', ctypes.c_uint16),
    ('DynamicMemorySettings', ctypes.c_uint16),
    ('MemoryTraining', ctypes.c_uint16),
    ('EnableSpreadSpectrumOnPPLL', ctypes.c_uint16),
    ('TMDSAOutputControl', ctypes.c_uint16),
    ('SetVoltage', ctypes.c_uint16),
    ('DAC1OutputControl', ctypes.c_uint16),
    ('ReadEfuseValue', ctypes.c_uint16),
    ('ComputeMemoryClockParam', ctypes.c_uint16),
    ('ClockSource', ctypes.c_uint16),
    ('MemoryDeviceInit', ctypes.c_uint16),
    ('GetDispObjectInfo', ctypes.c_uint16),
    ('DIG1EncoderControl', ctypes.c_uint16),
    ('DIG2EncoderControl', ctypes.c_uint16),
    ('DIG1TransmitterControl', ctypes.c_uint16),
    ('DIG2TransmitterControl', ctypes.c_uint16),
    ('ProcessAuxChannelTransaction', ctypes.c_uint16),
    ('DPEncoderService', ctypes.c_uint16),
    ('GetVoltageInfo', ctypes.c_uint16),
     ]

class struct__ATOM_MASTER_COMMAND_TABLE(ctypes.Structure):
    pass

ATOM_MASTER_LIST_OF_COMMAND_TABLES = struct__ATOM_MASTER_LIST_OF_COMMAND_TABLES
struct__ATOM_MASTER_COMMAND_TABLE._pack_ = True # source:False
struct__ATOM_MASTER_COMMAND_TABLE._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ListOfCommandTables', ATOM_MASTER_LIST_OF_COMMAND_TABLES),
]

class struct__ATOM_TABLE_ATTRIBUTE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('WS_SizeInBytes', ctypes.c_uint16, 8),
    ('PS_SizeInBytes', ctypes.c_uint16, 7),
    ('UpdatedByUtility', ctypes.c_uint16, 1),
     ]

class struct__ATOM_COMMON_ROM_COMMAND_TABLE_HEADER(ctypes.Structure):
    pass

ATOM_TABLE_ATTRIBUTE = struct__ATOM_TABLE_ATTRIBUTE
struct__ATOM_COMMON_ROM_COMMAND_TABLE_HEADER._pack_ = True # source:False
struct__ATOM_COMMON_ROM_COMMAND_TABLE_HEADER._fields_ = [
    ('CommonHeader', ATOM_COMMON_TABLE_HEADER),
    ('TableAttribute', ATOM_TABLE_ATTRIBUTE),
]

class struct__ATOM_ADJUST_MEMORY_CLOCK_FREQ(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClockFreq', ctypes.c_uint32, 24),
    ('ulMemoryModuleNumber', ctypes.c_uint32, 7),
    ('ulPointerReturnFlag', ctypes.c_uint32, 1),
     ]

class struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ctypes.c_uint32),
    ('ucAction', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ucFbDiv', ctypes.c_ubyte),
    ('ucPostDiv', ctypes.c_ubyte),
     ]

class struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ctypes.c_uint32),
    ('ucAction', ctypes.c_ubyte),
    ('usFbDiv', ctypes.c_uint16),
    ('ucPostDiv', ctypes.c_ubyte),
     ]

class struct__ATOM_COMPUTE_CLOCK_FREQ(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClockFreq', ctypes.c_uint32, 24),
    ('ulComputeClockFlag', ctypes.c_uint32, 8),
     ]

class struct__ATOM_S_MPLL_FB_DIVIDER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usFbDivFrac', ctypes.c_uint16),
    ('usFbDiv', ctypes.c_uint16),
     ]

class struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V3(ctypes.Structure):
    pass

class union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V3_0(ctypes.Union):
    pass

ATOM_COMPUTE_CLOCK_FREQ = struct__ATOM_COMPUTE_CLOCK_FREQ
ATOM_S_MPLL_FB_DIVIDER = struct__ATOM_S_MPLL_FB_DIVIDER
union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V3_0._pack_ = True # source:False
union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V3_0._fields_ = [
    ('ulClock', ATOM_COMPUTE_CLOCK_FREQ),
    ('ulClockParams', ctypes.c_uint32),
    ('ulFbDiv', ATOM_S_MPLL_FB_DIVIDER),
]

struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V3._pack_ = True # source:False
struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V3._fields_ = [
    ('_0', union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V3_0),
    ('ucRefDiv', ctypes.c_ubyte),
    ('ucPostDiv', ctypes.c_ubyte),
    ('ucCntlFlag', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
]

class struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V4(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ctypes.c_uint32, 24),
    ('ucPostDiv', ctypes.c_uint32, 8),
     ]

class struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5(ctypes.Structure):
    pass

class union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5_1(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucCntlFlag', ctypes.c_ubyte),
    ('ucInputFlag', ctypes.c_ubyte),
     ]

class union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ATOM_COMPUTE_CLOCK_FREQ),
    ('ulClockParams', ctypes.c_uint32),
    ('ulFbDiv', ATOM_S_MPLL_FB_DIVIDER),
     ]

struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5._pack_ = True # source:False
struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5._fields_ = [
    ('_0', union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5_0),
    ('ucRefDiv', ctypes.c_ubyte),
    ('ucPostDiv', ctypes.c_ubyte),
    ('_3', union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5_1),
    ('ucReserved', ctypes.c_ubyte),
]

class struct__COMPUTE_GPU_CLOCK_INPUT_PARAMETERS_V1_6(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ATOM_COMPUTE_CLOCK_FREQ),
    ('ulReserved', ctypes.c_uint32 * 2),
     ]

class struct__COMPUTE_GPU_CLOCK_OUTPUT_PARAMETERS_V1_6(ctypes.Structure):
    pass

COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V4 = struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V4
struct__COMPUTE_GPU_CLOCK_OUTPUT_PARAMETERS_V1_6._pack_ = True # source:False
struct__COMPUTE_GPU_CLOCK_OUTPUT_PARAMETERS_V1_6._fields_ = [
    ('ulClock', COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V4),
    ('ulFbDiv', ATOM_S_MPLL_FB_DIVIDER),
    ('ucPllRefDiv', ctypes.c_ubyte),
    ('ucPllPostDiv', ctypes.c_ubyte),
    ('ucPllCntlFlag', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
]

class struct__COMPUTE_GPU_CLOCK_INPUT_PARAMETERS_V1_7(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ATOM_COMPUTE_CLOCK_FREQ),
    ('ulReserved', ctypes.c_uint32 * 5),
     ]

class struct__COMPUTE_GPU_CLOCK_OUTPUT_PARAMETERS_V1_7(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V4),
    ('usSclk_fcw_frac', ctypes.c_uint16),
    ('usSclk_fcw_int', ctypes.c_uint16),
    ('ucSclkPostDiv', ctypes.c_ubyte),
    ('ucSclkVcoMode', ctypes.c_ubyte),
    ('ucSclkPllRange', ctypes.c_ubyte),
    ('ucSscEnable', ctypes.c_ubyte),
    ('usSsc_fcw1_frac', ctypes.c_uint16),
    ('usSsc_fcw1_int', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
    ('usPcc_fcw_int', ctypes.c_uint16),
    ('usSsc_fcw_slew_frac', ctypes.c_uint16),
    ('usPcc_fcw_slew_frac', ctypes.c_uint16),
     ]

class struct__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1(ctypes.Structure):
    pass

class union__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ctypes.c_uint32),
    ('ulFbDiv', ATOM_S_MPLL_FB_DIVIDER),
     ]

class union__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1_1(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucInputFlag', ctypes.c_ubyte),
    ('ucPllCntlFlag', ctypes.c_ubyte),
     ]

struct__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1._pack_ = True # source:False
struct__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1._fields_ = [
    ('_0', union__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1_0),
    ('ucDllSpeed', ctypes.c_ubyte),
    ('ucPostDiv', ctypes.c_ubyte),
    ('_3', union__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1_1),
    ('ucBWCntl', ctypes.c_ubyte),
]

class struct__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V4),
    ('ulReserved', ctypes.c_uint32),
     ]

class struct__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V4),
    ('usMclk_fcw_frac', ctypes.c_uint16),
    ('usMclk_fcw_int', ctypes.c_uint16),
     ]

class struct__DYNAMICE_MEMORY_SETTINGS_PARAMETER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ATOM_COMPUTE_CLOCK_FREQ),
    ('ulReserved', ctypes.c_uint32 * 2),
     ]

class struct__DYNAMICE_ENGINE_SETTINGS_PARAMETER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ATOM_COMPUTE_CLOCK_FREQ),
    ('ulMemoryClock', ctypes.c_uint32),
    ('ulReserved', ctypes.c_uint32),
     ]

class struct__DYNAMICE_MC_DPM_SETTINGS_PARAMETER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClock', ATOM_COMPUTE_CLOCK_FREQ),
    ('ucMclkDPMState', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('ulReserved', ctypes.c_uint32),
     ]

class struct__SET_ENGINE_CLOCK_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulTargetEngineClock', ctypes.c_uint32),
     ]

class struct__SET_ENGINE_CLOCK_PS_ALLOCATION(ctypes.Structure):
    pass

COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS = struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS
struct__SET_ENGINE_CLOCK_PS_ALLOCATION._pack_ = True # source:False
struct__SET_ENGINE_CLOCK_PS_ALLOCATION._fields_ = [
    ('ulTargetEngineClock', ctypes.c_uint32),
    ('sReserved', COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS),
]

class struct__SET_ENGINE_CLOCK_PS_ALLOCATION_V1_2(ctypes.Structure):
    pass

COMPUTE_GPU_CLOCK_INPUT_PARAMETERS_V1_7 = struct__COMPUTE_GPU_CLOCK_INPUT_PARAMETERS_V1_7
struct__SET_ENGINE_CLOCK_PS_ALLOCATION_V1_2._pack_ = True # source:False
struct__SET_ENGINE_CLOCK_PS_ALLOCATION_V1_2._fields_ = [
    ('ulTargetEngineClock', ctypes.c_uint32),
    ('sReserved', COMPUTE_GPU_CLOCK_INPUT_PARAMETERS_V1_7),
]

class struct__SET_MEMORY_CLOCK_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulTargetMemoryClock', ctypes.c_uint32),
     ]

class struct__SET_MEMORY_CLOCK_PS_ALLOCATION(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulTargetMemoryClock', ctypes.c_uint32),
    ('sReserved', COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS),
     ]

class struct__ASIC_INIT_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulDefaultEngineClock', ctypes.c_uint32),
    ('ulDefaultMemoryClock', ctypes.c_uint32),
     ]

class struct__ASIC_INIT_PS_ALLOCATION(ctypes.Structure):
    pass

ASIC_INIT_PARAMETERS = struct__ASIC_INIT_PARAMETERS
SET_ENGINE_CLOCK_PS_ALLOCATION = struct__SET_ENGINE_CLOCK_PS_ALLOCATION
struct__ASIC_INIT_PS_ALLOCATION._pack_ = True # source:False
struct__ASIC_INIT_PS_ALLOCATION._fields_ = [
    ('sASICInitClocks', ASIC_INIT_PARAMETERS),
    ('sReserved', SET_ENGINE_CLOCK_PS_ALLOCATION),
]

class struct__ASIC_INIT_CLOCK_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClkFreqIn10Khz', ctypes.c_uint32, 24),
    ('ucClkFlag', ctypes.c_uint32, 8),
     ]

class struct__ASIC_INIT_PARAMETERS_V1_2(ctypes.Structure):
    pass

ASIC_INIT_CLOCK_PARAMETERS = struct__ASIC_INIT_CLOCK_PARAMETERS
struct__ASIC_INIT_PARAMETERS_V1_2._pack_ = True # source:False
struct__ASIC_INIT_PARAMETERS_V1_2._fields_ = [
    ('asSclkClock', ASIC_INIT_CLOCK_PARAMETERS),
    ('asMemClock', ASIC_INIT_CLOCK_PARAMETERS),
]

class struct__ASIC_INIT_PS_ALLOCATION_V1_2(ctypes.Structure):
    pass

ASIC_INIT_PARAMETERS_V1_2 = struct__ASIC_INIT_PARAMETERS_V1_2
struct__ASIC_INIT_PS_ALLOCATION_V1_2._pack_ = True # source:False
struct__ASIC_INIT_PS_ALLOCATION_V1_2._fields_ = [
    ('sASICInitClocks', ASIC_INIT_PARAMETERS_V1_2),
    ('ulReserved', ctypes.c_uint32 * 8),
]

class struct__DYNAMIC_CLOCK_GATING_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEnable', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 3),
     ]

class struct__ENABLE_DISP_POWER_GATING_PARAMETERS_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDispPipeId', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
     ]

class struct__ENABLE_DISP_POWER_GATING_PS_ALLOCATION(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDispPipeId', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
    ('ulReserved', ctypes.c_uint32 * 4),
     ]

class struct__ENABLE_ASIC_STATIC_PWR_MGT_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEnable', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 3),
     ]

class struct__DAC_LOAD_DETECTION_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usDeviceID', ctypes.c_uint16),
    ('ucDacType', ctypes.c_ubyte),
    ('ucMisc', ctypes.c_ubyte),
     ]

class struct__DAC_LOAD_DETECTION_PS_ALLOCATION(ctypes.Structure):
    pass

DAC_LOAD_DETECTION_PARAMETERS = struct__DAC_LOAD_DETECTION_PARAMETERS
struct__DAC_LOAD_DETECTION_PS_ALLOCATION._pack_ = True # source:False
struct__DAC_LOAD_DETECTION_PS_ALLOCATION._fields_ = [
    ('sDacload', DAC_LOAD_DETECTION_PARAMETERS),
    ('Reserved', ctypes.c_uint32 * 2),
]

class struct__DAC_ENCODER_CONTROL_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('ucDacStandard', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
     ]

class struct__DIG_ENCODER_CONTROL_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('ucConfig', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucEncoderMode', ctypes.c_ubyte),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_DIG_ENCODER_CONFIG_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDPLinkRate', ctypes.c_ubyte, 1),
    ('ucReserved', ctypes.c_ubyte, 1),
    ('ucLinkSel', ctypes.c_ubyte, 1),
    ('ucTransmitterSel', ctypes.c_ubyte, 2),
    ('ucReserved1', ctypes.c_ubyte, 2),
    ('PADDING_0', ctypes.c_ubyte, 1),
     ]

class struct__DIG_ENCODER_CONTROL_PARAMETERS_V2(ctypes.Structure):
    pass

ATOM_DIG_ENCODER_CONFIG_V2 = struct__ATOM_DIG_ENCODER_CONFIG_V2
struct__DIG_ENCODER_CONTROL_PARAMETERS_V2._pack_ = True # source:False
struct__DIG_ENCODER_CONTROL_PARAMETERS_V2._fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('acConfig', ATOM_DIG_ENCODER_CONFIG_V2),
    ('ucAction', ctypes.c_ubyte),
    ('ucEncoderMode', ctypes.c_ubyte),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ucStatus', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
]

class struct__ATOM_DIG_ENCODER_CONFIG_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDPLinkRate', ctypes.c_ubyte, 1),
    ('ucReserved', ctypes.c_ubyte, 3),
    ('ucDigSel', ctypes.c_ubyte, 3),
    ('ucReserved1', ctypes.c_ubyte, 1),
     ]

class struct__DIG_ENCODER_CONTROL_PARAMETERS_V3(ctypes.Structure):
    pass

ATOM_DIG_ENCODER_CONFIG_V3 = struct__ATOM_DIG_ENCODER_CONFIG_V3
class union__DIG_ENCODER_CONTROL_PARAMETERS_V3_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEncoderMode', ctypes.c_ubyte),
    ('ucPanelMode', ctypes.c_ubyte),
     ]

struct__DIG_ENCODER_CONTROL_PARAMETERS_V3._pack_ = True # source:False
struct__DIG_ENCODER_CONTROL_PARAMETERS_V3._fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('acConfig', ATOM_DIG_ENCODER_CONFIG_V3),
    ('ucAction', ctypes.c_ubyte),
    ('_3', union__DIG_ENCODER_CONTROL_PARAMETERS_V3_0),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ucBitPerColor', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
]

class struct__ATOM_DIG_ENCODER_CONFIG_V4(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDPLinkRate', ctypes.c_ubyte, 2),
    ('ucReserved', ctypes.c_ubyte, 2),
    ('ucDigSel', ctypes.c_ubyte, 3),
    ('ucReserved1', ctypes.c_ubyte, 1),
     ]

class struct__DIG_ENCODER_CONTROL_PARAMETERS_V4(ctypes.Structure):
    pass

class union__DIG_ENCODER_CONTROL_PARAMETERS_V4_0(ctypes.Union):
    pass

ATOM_DIG_ENCODER_CONFIG_V4 = struct__ATOM_DIG_ENCODER_CONFIG_V4
union__DIG_ENCODER_CONTROL_PARAMETERS_V4_0._pack_ = True # source:False
union__DIG_ENCODER_CONTROL_PARAMETERS_V4_0._fields_ = [
    ('acConfig', ATOM_DIG_ENCODER_CONFIG_V4),
    ('ucConfig', ctypes.c_ubyte),
]

class union__DIG_ENCODER_CONTROL_PARAMETERS_V4_1(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEncoderMode', ctypes.c_ubyte),
    ('ucPanelMode', ctypes.c_ubyte),
     ]

struct__DIG_ENCODER_CONTROL_PARAMETERS_V4._pack_ = True # source:False
struct__DIG_ENCODER_CONTROL_PARAMETERS_V4._fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('_1', union__DIG_ENCODER_CONTROL_PARAMETERS_V4_0),
    ('ucAction', ctypes.c_ubyte),
    ('_3', union__DIG_ENCODER_CONTROL_PARAMETERS_V4_1),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ucBitPerColor', ctypes.c_ubyte),
    ('ucHPD_ID', ctypes.c_ubyte),
]

class struct__ENCODER_STREAM_SETUP_PARAMETERS_V5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDigId', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucDigMode', ctypes.c_ubyte),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ulPixelClock', ctypes.c_uint32),
    ('ucBitPerColor', ctypes.c_ubyte),
    ('ucLinkRateIn270Mhz', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__ENCODER_LINK_SETUP_PARAMETERS_V5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDigId', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucDigMode', ctypes.c_ubyte),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ulSymClock', ctypes.c_uint32),
    ('ucHPDSel', ctypes.c_ubyte),
    ('ucDigEncoderSel', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__DP_PANEL_MODE_SETUP_PARAMETERS_V5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDigId', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucPanelMode', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ulReserved', ctypes.c_uint32 * 2),
     ]

class struct__ENCODER_GENERIC_CMD_PARAMETERS_V5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDigId', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
    ('ulReserved', ctypes.c_uint32 * 2),
     ]

class struct__ATOM_DP_VS_MODE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucLaneSel', ctypes.c_ubyte),
    ('ucLaneSet', ctypes.c_ubyte),
     ]

class struct__DIG_TRANSMITTER_CONTROL_PARAMETERS(ctypes.Structure):
    pass

class union__DIG_TRANSMITTER_CONTROL_PARAMETERS_0(ctypes.Union):
    pass

ATOM_DP_VS_MODE = struct__ATOM_DP_VS_MODE
union__DIG_TRANSMITTER_CONTROL_PARAMETERS_0._pack_ = True # source:False
union__DIG_TRANSMITTER_CONTROL_PARAMETERS_0._fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('usInitInfo', ctypes.c_uint16),
    ('asMode', ATOM_DP_VS_MODE),
]

struct__DIG_TRANSMITTER_CONTROL_PARAMETERS._pack_ = True # source:False
struct__DIG_TRANSMITTER_CONTROL_PARAMETERS._fields_ = [
    ('_0', union__DIG_TRANSMITTER_CONTROL_PARAMETERS_0),
    ('ucConfig', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 4),
]

class struct__ATOM_DIG_TRANSMITTER_CONFIG_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('fDualLinkConnector', ctypes.c_ubyte, 1),
    ('fCoherentMode', ctypes.c_ubyte, 1),
    ('ucLinkSel', ctypes.c_ubyte, 1),
    ('ucEncoderSel', ctypes.c_ubyte, 1),
    ('fDPConnector', ctypes.c_ubyte, 1),
    ('ucReserved', ctypes.c_ubyte, 1),
    ('ucTransmitterSel', ctypes.c_ubyte, 2),
     ]

class struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V2(ctypes.Structure):
    pass

ATOM_DIG_TRANSMITTER_CONFIG_V2 = struct__ATOM_DIG_TRANSMITTER_CONFIG_V2
class union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V2_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('usInitInfo', ctypes.c_uint16),
    ('asMode', ATOM_DP_VS_MODE),
     ]

struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V2._pack_ = True # source:False
struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V2._fields_ = [
    ('_0', union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V2_0),
    ('acConfig', ATOM_DIG_TRANSMITTER_CONFIG_V2),
    ('ucAction', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 4),
]

class struct__ATOM_DIG_TRANSMITTER_CONFIG_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('fDualLinkConnector', ctypes.c_ubyte, 1),
    ('fCoherentMode', ctypes.c_ubyte, 1),
    ('ucLinkSel', ctypes.c_ubyte, 1),
    ('ucEncoderSel', ctypes.c_ubyte, 1),
    ('ucRefClkSource', ctypes.c_ubyte, 2),
    ('ucTransmitterSel', ctypes.c_ubyte, 2),
     ]

class struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V3(ctypes.Structure):
    pass

class union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V3_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('usInitInfo', ctypes.c_uint16),
    ('asMode', ATOM_DP_VS_MODE),
     ]

ATOM_DIG_TRANSMITTER_CONFIG_V3 = struct__ATOM_DIG_TRANSMITTER_CONFIG_V3
struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V3._pack_ = True # source:False
struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V3._fields_ = [
    ('_0', union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V3_0),
    ('acConfig', ATOM_DIG_TRANSMITTER_CONFIG_V3),
    ('ucAction', ctypes.c_ubyte),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
]

class struct__ATOM_DP_VS_MODE_V4(ctypes.Structure):
    pass

class union__ATOM_DP_VS_MODE_V4_0(ctypes.Union):
    pass

class struct__ATOM_DP_VS_MODE_V4_0_0(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVOLTAGE_SWING', ctypes.c_ubyte, 3),
    ('ucPRE_EMPHASIS', ctypes.c_ubyte, 3),
    ('ucPOST_CURSOR2', ctypes.c_ubyte, 2),
     ]

union__ATOM_DP_VS_MODE_V4_0._pack_ = True # source:False
union__ATOM_DP_VS_MODE_V4_0._fields_ = [
    ('ucLaneSet', ctypes.c_ubyte),
    ('_1', struct__ATOM_DP_VS_MODE_V4_0_0),
]

struct__ATOM_DP_VS_MODE_V4._pack_ = True # source:False
struct__ATOM_DP_VS_MODE_V4._fields_ = [
    ('ucLaneSel', ctypes.c_ubyte),
    ('_1', union__ATOM_DP_VS_MODE_V4_0),
]

class struct__ATOM_DIG_TRANSMITTER_CONFIG_V4(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('fDualLinkConnector', ctypes.c_ubyte, 1),
    ('fCoherentMode', ctypes.c_ubyte, 1),
    ('ucLinkSel', ctypes.c_ubyte, 1),
    ('ucEncoderSel', ctypes.c_ubyte, 1),
    ('ucRefClkSource', ctypes.c_ubyte, 2),
    ('ucTransmitterSel', ctypes.c_ubyte, 2),
     ]

class struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4(ctypes.Structure):
    pass

class union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_0(ctypes.Union):
    pass

ATOM_DP_VS_MODE_V4 = struct__ATOM_DP_VS_MODE_V4
union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_0._pack_ = True # source:False
union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_0._fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('usInitInfo', ctypes.c_uint16),
    ('asMode', ATOM_DP_VS_MODE_V4),
]

class union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_1(ctypes.Union):
    pass

ATOM_DIG_TRANSMITTER_CONFIG_V4 = struct__ATOM_DIG_TRANSMITTER_CONFIG_V4
union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_1._pack_ = True # source:False
union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_1._fields_ = [
    ('acConfig', ATOM_DIG_TRANSMITTER_CONFIG_V4),
    ('ucConfig', ctypes.c_ubyte),
]

struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4._pack_ = True # source:False
struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4._fields_ = [
    ('_0', union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_0),
    ('_1', union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_1),
    ('ucAction', ctypes.c_ubyte),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
]

class struct__ATOM_DIG_TRANSMITTER_CONFIG_V5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucReserved', ctypes.c_ubyte, 1),
    ('ucCoherentMode', ctypes.c_ubyte, 1),
    ('ucPhyClkSrcId', ctypes.c_ubyte, 2),
    ('ucHPDSel', ctypes.c_ubyte, 3),
    ('ucReservd1', ctypes.c_ubyte, 1),
     ]

class struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_5(ctypes.Structure):
    pass

class union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_5_0(ctypes.Union):
    pass

ATOM_DIG_TRANSMITTER_CONFIG_V5 = struct__ATOM_DIG_TRANSMITTER_CONFIG_V5
union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_5_0._pack_ = True # source:False
union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_5_0._fields_ = [
    ('asConfig', ATOM_DIG_TRANSMITTER_CONFIG_V5),
    ('ucConfig', ctypes.c_ubyte),
]

struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_5._pack_ = True # source:False
struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_5._fields_ = [
    ('usSymClock', ctypes.c_uint16),
    ('ucPhyId', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ucConnObjId', ctypes.c_ubyte),
    ('ucDigMode', ctypes.c_ubyte),
    ('_6', union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_5_0),
    ('ucDigEncoderSel', ctypes.c_ubyte),
    ('ucDPLaneSet', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ucReserved1', ctypes.c_ubyte),
]

class struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_6(ctypes.Structure):
    pass

class union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_6_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDigMode', ctypes.c_ubyte),
    ('ucDPLaneSet', ctypes.c_ubyte),
     ]

struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_6._pack_ = True # source:False
struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_6._fields_ = [
    ('ucPhyId', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('_2', union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_6_0),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ulSymClock', ctypes.c_uint32),
    ('ucHPDSel', ctypes.c_ubyte),
    ('ucDigEncoderSel', ctypes.c_ubyte),
    ('ucConnObjId', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ulReserved', ctypes.c_uint32),
]

class struct__EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3(ctypes.Structure):
    pass

class union__EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('usConnectorId', ctypes.c_uint16),
     ]

struct__EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3._pack_ = True # source:False
struct__EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3._fields_ = [
    ('_0', union__EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3_0),
    ('ucConfig', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucEncoderMode', ctypes.c_ubyte),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ucBitPerColor', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
]

class struct__EXTERNAL_ENCODER_CONTROL_PS_ALLOCATION_V3(ctypes.Structure):
    pass

EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3 = struct__EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3
struct__EXTERNAL_ENCODER_CONTROL_PS_ALLOCATION_V3._pack_ = True # source:False
struct__EXTERNAL_ENCODER_CONTROL_PS_ALLOCATION_V3._fields_ = [
    ('sExtEncoder', EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3),
    ('ulReserved', ctypes.c_uint32 * 2),
]

class struct__DISPLAY_DEVICE_OUTPUT_CONTROL_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucAction', ctypes.c_ubyte),
    ('aucPadding', ctypes.c_ubyte * 3),
     ]

class struct__LVTMA_OUTPUT_CONTROL_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucAction', ctypes.c_ubyte),
    ('ucBriLevel', ctypes.c_ubyte),
    ('usPwmFreq', ctypes.c_uint16),
     ]

class struct__BLANK_CRTC_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucCRTC', ctypes.c_ubyte),
    ('ucBlanking', ctypes.c_ubyte),
    ('usBlackColorRCr', ctypes.c_uint16),
    ('usBlackColorGY', ctypes.c_uint16),
    ('usBlackColorBCb', ctypes.c_uint16),
     ]

class struct__ENABLE_CRTC_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucCRTC', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
     ]

class struct__SET_CRTC_OVERSCAN_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usOverscanRight', ctypes.c_uint16),
    ('usOverscanLeft', ctypes.c_uint16),
    ('usOverscanBottom', ctypes.c_uint16),
    ('usOverscanTop', ctypes.c_uint16),
    ('ucCRTC', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 3),
     ]

class struct__SET_CRTC_REPLICATION_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucH_Replication', ctypes.c_ubyte),
    ('ucV_Replication', ctypes.c_ubyte),
    ('usCRTC', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte),
     ]

class struct__SELECT_CRTC_SOURCE_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucCRTC', ctypes.c_ubyte),
    ('ucDevice', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
     ]

class struct__SELECT_CRTC_SOURCE_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucCRTC', ctypes.c_ubyte),
    ('ucEncoderID', ctypes.c_ubyte),
    ('ucEncodeMode', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte),
     ]

class struct__SELECT_CRTC_SOURCE_PARAMETERS_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucCRTC', ctypes.c_ubyte),
    ('ucEncoderID', ctypes.c_ubyte),
    ('ucEncodeMode', ctypes.c_ubyte),
    ('ucDstBpc', ctypes.c_ubyte),
     ]

class struct__PIXEL_CLOCK_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('usRefDiv', ctypes.c_uint16),
    ('usFbDiv', ctypes.c_uint16),
    ('ucPostDiv', ctypes.c_ubyte),
    ('ucFracFbDiv', ctypes.c_ubyte),
    ('ucPpll', ctypes.c_ubyte),
    ('ucRefDivSrc', ctypes.c_ubyte),
    ('ucCRTC', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte),
     ]

class struct__PIXEL_CLOCK_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('usRefDiv', ctypes.c_uint16),
    ('usFbDiv', ctypes.c_uint16),
    ('ucPostDiv', ctypes.c_ubyte),
    ('ucFracFbDiv', ctypes.c_ubyte),
    ('ucPpll', ctypes.c_ubyte),
    ('ucRefDivSrc', ctypes.c_ubyte),
    ('ucCRTC', ctypes.c_ubyte),
    ('ucMiscInfo', ctypes.c_ubyte),
     ]

class struct__PIXEL_CLOCK_PARAMETERS_V3(ctypes.Structure):
    pass

class union__PIXEL_CLOCK_PARAMETERS_V3_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEncoderMode', ctypes.c_ubyte),
    ('ucDVOConfig', ctypes.c_ubyte),
     ]

struct__PIXEL_CLOCK_PARAMETERS_V3._pack_ = True # source:False
struct__PIXEL_CLOCK_PARAMETERS_V3._fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('usRefDiv', ctypes.c_uint16),
    ('usFbDiv', ctypes.c_uint16),
    ('ucPostDiv', ctypes.c_ubyte),
    ('ucFracFbDiv', ctypes.c_ubyte),
    ('ucPpll', ctypes.c_ubyte),
    ('ucTransmitterId', ctypes.c_ubyte),
    ('_7', union__PIXEL_CLOCK_PARAMETERS_V3_0),
    ('ucMiscInfo', ctypes.c_ubyte),
]

class struct__PIXEL_CLOCK_PARAMETERS_V5(ctypes.Structure):
    pass

class union__PIXEL_CLOCK_PARAMETERS_V5_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucReserved', ctypes.c_ubyte),
    ('ucFracFbDiv', ctypes.c_ubyte),
     ]

struct__PIXEL_CLOCK_PARAMETERS_V5._pack_ = True # source:False
struct__PIXEL_CLOCK_PARAMETERS_V5._fields_ = [
    ('ucCRTC', ctypes.c_ubyte),
    ('_1', union__PIXEL_CLOCK_PARAMETERS_V5_0),
    ('usPixelClock', ctypes.c_uint16),
    ('usFbDiv', ctypes.c_uint16),
    ('ucPostDiv', ctypes.c_ubyte),
    ('ucRefDiv', ctypes.c_ubyte),
    ('ucPpll', ctypes.c_ubyte),
    ('ucTransmitterID', ctypes.c_ubyte),
    ('ucEncoderMode', ctypes.c_ubyte),
    ('ucMiscInfo', ctypes.c_ubyte),
    ('ulFbDivDecFrac', ctypes.c_uint32),
]

class struct__CRTC_PIXEL_CLOCK_FREQ(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulPixelClock', ctypes.c_uint32, 24),
    ('ucCRTC', ctypes.c_uint32, 8),
     ]

class struct__PIXEL_CLOCK_PARAMETERS_V6(ctypes.Structure):
    pass

class union__PIXEL_CLOCK_PARAMETERS_V6_0(ctypes.Union):
    pass

CRTC_PIXEL_CLOCK_FREQ = struct__CRTC_PIXEL_CLOCK_FREQ
union__PIXEL_CLOCK_PARAMETERS_V6_0._pack_ = True # source:False
union__PIXEL_CLOCK_PARAMETERS_V6_0._fields_ = [
    ('ulCrtcPclkFreq', CRTC_PIXEL_CLOCK_FREQ),
    ('ulDispEngClkFreq', ctypes.c_uint32),
]

struct__PIXEL_CLOCK_PARAMETERS_V6._pack_ = True # source:False
struct__PIXEL_CLOCK_PARAMETERS_V6._fields_ = [
    ('_0', union__PIXEL_CLOCK_PARAMETERS_V6_0),
    ('usFbDiv', ctypes.c_uint16),
    ('ucPostDiv', ctypes.c_ubyte),
    ('ucRefDiv', ctypes.c_ubyte),
    ('ucPpll', ctypes.c_ubyte),
    ('ucTransmitterID', ctypes.c_ubyte),
    ('ucEncoderMode', ctypes.c_ubyte),
    ('ucMiscInfo', ctypes.c_ubyte),
    ('ulFbDivDecFrac', ctypes.c_uint32),
]

class struct__GET_DISP_PLL_STATUS_INPUT_PARAMETERS_V2(ctypes.Structure):
    pass

PIXEL_CLOCK_PARAMETERS_V3 = struct__PIXEL_CLOCK_PARAMETERS_V3
struct__GET_DISP_PLL_STATUS_INPUT_PARAMETERS_V2._pack_ = True # source:False
struct__GET_DISP_PLL_STATUS_INPUT_PARAMETERS_V2._fields_ = [
    ('sDispClkInput', PIXEL_CLOCK_PARAMETERS_V3),
]

class struct__GET_DISP_PLL_STATUS_OUTPUT_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucStatus', ctypes.c_ubyte),
    ('ucRefDivSrc', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__GET_DISP_PLL_STATUS_INPUT_PARAMETERS_V3(ctypes.Structure):
    pass

PIXEL_CLOCK_PARAMETERS_V5 = struct__PIXEL_CLOCK_PARAMETERS_V5
struct__GET_DISP_PLL_STATUS_INPUT_PARAMETERS_V3._pack_ = True # source:False
struct__GET_DISP_PLL_STATUS_INPUT_PARAMETERS_V3._fields_ = [
    ('sDispClkInput', PIXEL_CLOCK_PARAMETERS_V5),
]

class struct__PIXEL_CLOCK_PARAMETERS_V7(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulPixelClock', ctypes.c_uint32),
    ('ucPpll', ctypes.c_ubyte),
    ('ucTransmitterID', ctypes.c_ubyte),
    ('ucEncoderMode', ctypes.c_ubyte),
    ('ucMiscInfo', ctypes.c_ubyte),
    ('ucCRTC', ctypes.c_ubyte),
    ('ucDeepColorRatio', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
    ('ulReserved', ctypes.c_uint32),
     ]

class struct__SET_DCE_CLOCK_PARAMETERS_V1_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulDISPClkFreq', ctypes.c_uint32),
    ('ucFlag', ctypes.c_ubyte),
    ('ucCrtc', ctypes.c_ubyte),
    ('ucPpllId', ctypes.c_ubyte),
    ('ucDeepColorRatio', ctypes.c_ubyte),
     ]

class struct__SET_DCE_CLOCK_PS_ALLOCATION_V1_1(ctypes.Structure):
    pass

SET_DCE_CLOCK_PARAMETERS_V1_1 = struct__SET_DCE_CLOCK_PARAMETERS_V1_1
struct__SET_DCE_CLOCK_PS_ALLOCATION_V1_1._pack_ = True # source:False
struct__SET_DCE_CLOCK_PS_ALLOCATION_V1_1._fields_ = [
    ('asParam', SET_DCE_CLOCK_PARAMETERS_V1_1),
    ('ulReserved', ctypes.c_uint32 * 2),
]

class struct__SET_DCE_CLOCK_PARAMETERS_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulDCEClkFreq', ctypes.c_uint32),
    ('ucDCEClkType', ctypes.c_ubyte),
    ('ucDCEClkSrc', ctypes.c_ubyte),
    ('ucDCEClkFlag', ctypes.c_ubyte),
    ('ucCRTC', ctypes.c_ubyte),
     ]

class struct__SET_DCE_CLOCK_PS_ALLOCATION_V2_1(ctypes.Structure):
    pass

SET_DCE_CLOCK_PARAMETERS_V2_1 = struct__SET_DCE_CLOCK_PARAMETERS_V2_1
struct__SET_DCE_CLOCK_PS_ALLOCATION_V2_1._pack_ = True # source:False
struct__SET_DCE_CLOCK_PS_ALLOCATION_V2_1._fields_ = [
    ('asParam', SET_DCE_CLOCK_PARAMETERS_V2_1),
    ('ulReserved', ctypes.c_uint32 * 2),
]

class struct__ADJUST_DISPLAY_PLL_PARAMETERS(ctypes.Structure):
    pass

class union__ADJUST_DISPLAY_PLL_PARAMETERS_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDVOConfig', ctypes.c_ubyte),
    ('ucConfig', ctypes.c_ubyte),
     ]

struct__ADJUST_DISPLAY_PLL_PARAMETERS._pack_ = True # source:False
struct__ADJUST_DISPLAY_PLL_PARAMETERS._fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('ucTransmitterID', ctypes.c_ubyte),
    ('ucEncodeMode', ctypes.c_ubyte),
    ('_3', union__ADJUST_DISPLAY_PLL_PARAMETERS_0),
    ('ucReserved', ctypes.c_ubyte * 3),
]

class struct__ADJUST_DISPLAY_PLL_INPUT_PARAMETERS_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('ucTransmitterID', ctypes.c_ubyte),
    ('ucEncodeMode', ctypes.c_ubyte),
    ('ucDispPllConfig', ctypes.c_ubyte),
    ('ucExtTransmitterID', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__ADJUST_DISPLAY_PLL_OUTPUT_PARAMETERS_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulDispPllFreq', ctypes.c_uint32),
    ('ucRefDiv', ctypes.c_ubyte),
    ('ucPostDiv', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__ADJUST_DISPLAY_PLL_PS_ALLOCATION_V3(ctypes.Structure):
    pass

class union__ADJUST_DISPLAY_PLL_PS_ALLOCATION_V3_0(ctypes.Union):
    pass

ADJUST_DISPLAY_PLL_INPUT_PARAMETERS_V3 = struct__ADJUST_DISPLAY_PLL_INPUT_PARAMETERS_V3
ADJUST_DISPLAY_PLL_OUTPUT_PARAMETERS_V3 = struct__ADJUST_DISPLAY_PLL_OUTPUT_PARAMETERS_V3
union__ADJUST_DISPLAY_PLL_PS_ALLOCATION_V3_0._pack_ = True # source:False
union__ADJUST_DISPLAY_PLL_PS_ALLOCATION_V3_0._fields_ = [
    ('sInput', ADJUST_DISPLAY_PLL_INPUT_PARAMETERS_V3),
    ('sOutput', ADJUST_DISPLAY_PLL_OUTPUT_PARAMETERS_V3),
]

struct__ADJUST_DISPLAY_PLL_PS_ALLOCATION_V3._pack_ = True # source:False
struct__ADJUST_DISPLAY_PLL_PS_ALLOCATION_V3._fields_ = [
    ('_0', union__ADJUST_DISPLAY_PLL_PS_ALLOCATION_V3_0),
]

class struct__ENABLE_YUV_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEnable', ctypes.c_ubyte),
    ('ucCRTC', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
     ]

class struct__GET_MEMORY_CLOCK_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulReturnMemoryClock', ctypes.c_uint32),
     ]

class struct__GET_ENGINE_CLOCK_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulReturnEngineClock', ctypes.c_uint32),
     ]

class struct__READ_EDID_FROM_HW_I2C_DATA_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPrescale', ctypes.c_uint16),
    ('usVRAMAddress', ctypes.c_uint16),
    ('usStatus', ctypes.c_uint16),
    ('ucSlaveAddr', ctypes.c_ubyte),
    ('ucLineNumber', ctypes.c_ubyte),
     ]

class struct__WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPrescale', ctypes.c_uint16),
    ('usByteOffset', ctypes.c_uint16),
    ('ucData', ctypes.c_ubyte),
    ('ucStatus', ctypes.c_ubyte),
    ('ucSlaveAddr', ctypes.c_ubyte),
    ('ucLineNumber', ctypes.c_ubyte),
     ]

class struct__SET_UP_HW_I2C_DATA_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPrescale', ctypes.c_uint16),
    ('ucSlaveAddr', ctypes.c_ubyte),
    ('ucLineNumber', ctypes.c_ubyte),
     ]

class struct__POWER_CONNECTOR_DETECTION_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucPowerConnectorStatus', ctypes.c_ubyte),
    ('ucPwrBehaviorId', ctypes.c_ubyte),
    ('usPwrBudget', ctypes.c_uint16),
     ]

class struct_POWER_CONNECTOR_DETECTION_PS_ALLOCATION(ctypes.Structure):
    pass

WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS = struct__WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS
struct_POWER_CONNECTOR_DETECTION_PS_ALLOCATION._pack_ = True # source:False
struct_POWER_CONNECTOR_DETECTION_PS_ALLOCATION._fields_ = [
    ('ucPowerConnectorStatus', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('usPwrBudget', ctypes.c_uint16),
    ('sReserved', WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS),
]

class struct__ENABLE_LVDS_SS_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usSpreadSpectrumPercentage', ctypes.c_uint16),
    ('ucSpreadSpectrumType', ctypes.c_ubyte),
    ('ucSpreadSpectrumStepSize_Delay', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 3),
     ]

class struct__ENABLE_LVDS_SS_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usSpreadSpectrumPercentage', ctypes.c_uint16),
    ('ucSpreadSpectrumType', ctypes.c_ubyte),
    ('ucSpreadSpectrumStep', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('ucSpreadSpectrumDelay', ctypes.c_ubyte),
    ('ucSpreadSpectrumRange', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte),
     ]

class struct__ENABLE_SPREAD_SPECTRUM_ON_PPLL(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usSpreadSpectrumPercentage', ctypes.c_uint16),
    ('ucSpreadSpectrumType', ctypes.c_ubyte),
    ('ucSpreadSpectrumStep', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('ucSpreadSpectrumDelay', ctypes.c_ubyte),
    ('ucSpreadSpectrumRange', ctypes.c_ubyte),
    ('ucPpll', ctypes.c_ubyte),
     ]

class struct__ENABLE_SPREAD_SPECTRUM_ON_PPLL_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usSpreadSpectrumPercentage', ctypes.c_uint16),
    ('ucSpreadSpectrumType', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('usSpreadSpectrumAmount', ctypes.c_uint16),
    ('usSpreadSpectrumStep', ctypes.c_uint16),
     ]

class struct__ENABLE_SPREAD_SPECTRUM_ON_PPLL_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usSpreadSpectrumAmountFrac', ctypes.c_uint16),
    ('ucSpreadSpectrumType', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('usSpreadSpectrumAmount', ctypes.c_uint16),
    ('usSpreadSpectrumStep', ctypes.c_uint16),
     ]

class struct__SET_PIXEL_CLOCK_PS_ALLOCATION(ctypes.Structure):
    pass

ENABLE_SPREAD_SPECTRUM_ON_PPLL = struct__ENABLE_SPREAD_SPECTRUM_ON_PPLL
PIXEL_CLOCK_PARAMETERS = struct__PIXEL_CLOCK_PARAMETERS
struct__SET_PIXEL_CLOCK_PS_ALLOCATION._pack_ = True # source:False
struct__SET_PIXEL_CLOCK_PS_ALLOCATION._fields_ = [
    ('sPCLKInput', PIXEL_CLOCK_PARAMETERS),
    ('sReserved', ENABLE_SPREAD_SPECTRUM_ON_PPLL),
]

class struct__MEMORY_TRAINING_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulTargetMemoryClock', ctypes.c_uint32),
     ]

class struct__MEMORY_TRAINING_PARAMETERS_V1_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usMemTrainingMode', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
     ]

class struct__LVDS_ENCODER_CONTROL_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('ucMisc', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
     ]

class struct__LVDS_ENCODER_CONTROL_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('ucMisc', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucTruncate', ctypes.c_ubyte),
    ('ucSpatial', ctypes.c_ubyte),
    ('ucTemporal', ctypes.c_ubyte),
    ('ucFRC', ctypes.c_ubyte),
     ]

class struct__ENABLE_EXTERNAL_TMDS_ENCODER_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEnable', ctypes.c_ubyte),
    ('ucMisc', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
     ]

class struct__ENABLE_EXTERNAL_TMDS_ENCODER_PS_ALLOCATION(ctypes.Structure):
    pass

ENABLE_EXTERNAL_TMDS_ENCODER_PARAMETERS = struct__ENABLE_EXTERNAL_TMDS_ENCODER_PARAMETERS
struct__ENABLE_EXTERNAL_TMDS_ENCODER_PS_ALLOCATION._pack_ = True # source:False
struct__ENABLE_EXTERNAL_TMDS_ENCODER_PS_ALLOCATION._fields_ = [
    ('sXTmdsEncoder', ENABLE_EXTERNAL_TMDS_ENCODER_PARAMETERS),
    ('sReserved', WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS),
]

class struct__ENABLE_EXTERNAL_TMDS_ENCODER_PS_ALLOCATION_V2(ctypes.Structure):
    pass

LVDS_ENCODER_CONTROL_PARAMETERS_V2 = struct__LVDS_ENCODER_CONTROL_PARAMETERS_V2
struct__ENABLE_EXTERNAL_TMDS_ENCODER_PS_ALLOCATION_V2._pack_ = True # source:False
struct__ENABLE_EXTERNAL_TMDS_ENCODER_PS_ALLOCATION_V2._fields_ = [
    ('sXTmdsEncoder', LVDS_ENCODER_CONTROL_PARAMETERS_V2),
    ('sReserved', WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS),
]

class struct__EXTERNAL_ENCODER_CONTROL_PS_ALLOCATION(ctypes.Structure):
    pass

DIG_ENCODER_CONTROL_PARAMETERS = struct__DIG_ENCODER_CONTROL_PARAMETERS
struct__EXTERNAL_ENCODER_CONTROL_PS_ALLOCATION._pack_ = True # source:False
struct__EXTERNAL_ENCODER_CONTROL_PS_ALLOCATION._fields_ = [
    ('sDigEncoder', DIG_ENCODER_CONTROL_PARAMETERS),
    ('sReserved', WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS),
]

class struct__DVO_ENCODER_CONTROL_PARAMETERS_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('ucDVOConfig', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucReseved', ctypes.c_ubyte * 4),
     ]

class struct__DVO_ENCODER_CONTROL_PARAMETERS_V1_4(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('ucDVOConfig', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucBitPerColor', ctypes.c_ubyte),
    ('ucReseved', ctypes.c_ubyte * 3),
     ]

class struct__SET_VOLTAGE_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVoltageType', ctypes.c_ubyte),
    ('ucVoltageMode', ctypes.c_ubyte),
    ('ucVoltageIndex', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__SET_VOLTAGE_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVoltageType', ctypes.c_ubyte),
    ('ucVoltageMode', ctypes.c_ubyte),
    ('usVoltageLevel', ctypes.c_uint16),
     ]

class struct__SET_VOLTAGE_PARAMETERS_V1_3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVoltageType', ctypes.c_ubyte),
    ('ucVoltageMode', ctypes.c_ubyte),
    ('usVoltageLevel', ctypes.c_uint16),
     ]

class struct__SET_VOLTAGE_PS_ALLOCATION(ctypes.Structure):
    pass

SET_VOLTAGE_PARAMETERS = struct__SET_VOLTAGE_PARAMETERS
struct__SET_VOLTAGE_PS_ALLOCATION._pack_ = True # source:False
struct__SET_VOLTAGE_PS_ALLOCATION._fields_ = [
    ('sASICSetVoltage', SET_VOLTAGE_PARAMETERS),
    ('sReserved', WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS),
]

class struct__GET_VOLTAGE_INFO_INPUT_PARAMETER_V1_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVoltageType', ctypes.c_ubyte),
    ('ucVoltageMode', ctypes.c_ubyte),
    ('usVoltageLevel', ctypes.c_uint16),
    ('ulReserved', ctypes.c_uint32),
     ]

class struct__GET_VOLTAGE_INFO_OUTPUT_PARAMETER_V1_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulVotlageGpioState', ctypes.c_uint32),
    ('ulVoltageGPioMask', ctypes.c_uint32),
     ]

class struct__GET_LEAKAGE_VOLTAGE_INFO_OUTPUT_PARAMETER_V1_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usVoltageLevel', ctypes.c_uint16),
    ('usVoltageId', ctypes.c_uint16),
    ('ulReseved', ctypes.c_uint32),
     ]

class struct__GET_VOLTAGE_INFO_INPUT_PARAMETER_V1_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVoltageType', ctypes.c_ubyte),
    ('ucVoltageMode', ctypes.c_ubyte),
    ('usVoltageLevel', ctypes.c_uint16),
    ('ulSCLKFreq', ctypes.c_uint32),
     ]

class struct__GET_EVV_VOLTAGE_INFO_OUTPUT_PARAMETER_V1_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usVoltageLevel', ctypes.c_uint16),
    ('usVoltageId', ctypes.c_uint16),
    ('usTDP_Current', ctypes.c_uint16),
    ('usTDP_Power', ctypes.c_uint16),
     ]

class struct__GET_VOLTAGE_INFO_INPUT_PARAMETER_V1_3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVoltageType', ctypes.c_ubyte),
    ('ucVoltageMode', ctypes.c_ubyte),
    ('usVoltageLevel', ctypes.c_uint16),
    ('ulSCLKFreq', ctypes.c_uint32),
    ('ulReserved', ctypes.c_uint32 * 3),
     ]

class struct__GET_EVV_VOLTAGE_INFO_OUTPUT_PARAMETER_V1_3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulVoltageLevel', ctypes.c_uint32),
    ('ulReserved', ctypes.c_uint32 * 4),
     ]

class struct__GET_SMU_CLOCK_INFO_INPUT_PARAMETER_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulDfsPllOutputFreq', ctypes.c_uint32, 24),
    ('ucDfsDivider', ctypes.c_uint32, 8),
     ]

class struct__GET_SMU_CLOCK_INFO_OUTPUT_PARAMETER_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulDfsOutputFreq', ctypes.c_uint32),
     ]

class struct__TV_ENCODER_CONTROL_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('ucTvStandard', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
     ]

class struct__TV_ENCODER_CONTROL_PS_ALLOCATION(ctypes.Structure):
    pass

TV_ENCODER_CONTROL_PARAMETERS = struct__TV_ENCODER_CONTROL_PARAMETERS
struct__TV_ENCODER_CONTROL_PS_ALLOCATION._pack_ = True # source:False
struct__TV_ENCODER_CONTROL_PS_ALLOCATION._fields_ = [
    ('sTVEncoder', TV_ENCODER_CONTROL_PARAMETERS),
    ('sReserved', WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS),
]

class struct__ATOM_MASTER_LIST_OF_DATA_TABLES(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('UtilityPipeLine', ctypes.c_uint16),
    ('MultimediaCapabilityInfo', ctypes.c_uint16),
    ('MultimediaConfigInfo', ctypes.c_uint16),
    ('StandardVESA_Timing', ctypes.c_uint16),
    ('FirmwareInfo', ctypes.c_uint16),
    ('PaletteData', ctypes.c_uint16),
    ('LCD_Info', ctypes.c_uint16),
    ('DIGTransmitterInfo', ctypes.c_uint16),
    ('SMU_Info', ctypes.c_uint16),
    ('SupportedDevicesInfo', ctypes.c_uint16),
    ('GPIO_I2C_Info', ctypes.c_uint16),
    ('VRAM_UsageByFirmware', ctypes.c_uint16),
    ('GPIO_Pin_LUT', ctypes.c_uint16),
    ('VESA_ToInternalModeLUT', ctypes.c_uint16),
    ('GFX_Info', ctypes.c_uint16),
    ('PowerPlayInfo', ctypes.c_uint16),
    ('GPUVirtualizationInfo', ctypes.c_uint16),
    ('SaveRestoreInfo', ctypes.c_uint16),
    ('PPLL_SS_Info', ctypes.c_uint16),
    ('OemInfo', ctypes.c_uint16),
    ('XTMDS_Info', ctypes.c_uint16),
    ('MclkSS_Info', ctypes.c_uint16),
    ('Object_Header', ctypes.c_uint16),
    ('IndirectIOAccess', ctypes.c_uint16),
    ('MC_InitParameter', ctypes.c_uint16),
    ('ASIC_VDDC_Info', ctypes.c_uint16),
    ('ASIC_InternalSS_Info', ctypes.c_uint16),
    ('TV_VideoMode', ctypes.c_uint16),
    ('VRAM_Info', ctypes.c_uint16),
    ('MemoryTrainingInfo', ctypes.c_uint16),
    ('IntegratedSystemInfo', ctypes.c_uint16),
    ('ASIC_ProfilingInfo', ctypes.c_uint16),
    ('VoltageObjectInfo', ctypes.c_uint16),
    ('PowerSourceInfo', ctypes.c_uint16),
    ('ServiceInfo', ctypes.c_uint16),
     ]

class struct__ATOM_MASTER_DATA_TABLE(ctypes.Structure):
    pass

ATOM_MASTER_LIST_OF_DATA_TABLES = struct__ATOM_MASTER_LIST_OF_DATA_TABLES
struct__ATOM_MASTER_DATA_TABLE._pack_ = True # source:False
struct__ATOM_MASTER_DATA_TABLE._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ListOfDataTables', ATOM_MASTER_LIST_OF_DATA_TABLES),
]

class struct__ATOM_MULTIMEDIA_CAPABILITY_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulSignature', ctypes.c_uint32),
    ('ucI2C_Type', ctypes.c_ubyte),
    ('ucTV_OutInfo', ctypes.c_ubyte),
    ('ucVideoPortInfo', ctypes.c_ubyte),
    ('ucHostPortInfo', ctypes.c_ubyte),
     ]

class struct__ATOM_MULTIMEDIA_CONFIG_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulSignature', ctypes.c_uint32),
    ('ucTunerInfo', ctypes.c_ubyte),
    ('ucAudioChipInfo', ctypes.c_ubyte),
    ('ucProductID', ctypes.c_ubyte),
    ('ucMiscInfo1', ctypes.c_ubyte),
    ('ucMiscInfo2', ctypes.c_ubyte),
    ('ucMiscInfo3', ctypes.c_ubyte),
    ('ucMiscInfo4', ctypes.c_ubyte),
    ('ucVideoInput0Info', ctypes.c_ubyte),
    ('ucVideoInput1Info', ctypes.c_ubyte),
    ('ucVideoInput2Info', ctypes.c_ubyte),
    ('ucVideoInput3Info', ctypes.c_ubyte),
    ('ucVideoInput4Info', ctypes.c_ubyte),
     ]

class struct__ATOM_FIRMWARE_CAPABILITY(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('FirmwarePosted', ctypes.c_uint16, 1),
    ('DualCRTC_Support', ctypes.c_uint16, 1),
    ('ExtendedDesktopSupport', ctypes.c_uint16, 1),
    ('MemoryClockSS_Support', ctypes.c_uint16, 1),
    ('EngineClockSS_Support', ctypes.c_uint16, 1),
    ('GPUControlsBL', ctypes.c_uint16, 1),
    ('WMI_SUPPORT', ctypes.c_uint16, 1),
    ('PPMode_Assigned', ctypes.c_uint16, 1),
    ('HyperMemory_Support', ctypes.c_uint16, 1),
    ('HyperMemory_Size', ctypes.c_uint16, 4),
    ('PostWithoutModeSet', ctypes.c_uint16, 1),
    ('SCL2Redefined', ctypes.c_uint16, 1),
    ('Reserved', ctypes.c_uint16, 1),
     ]

class struct__ATOM_FIRMWARE_INFO(ctypes.Structure):
    pass

class union__ATOM_FIRMWARE_CAPABILITY_ACCESS(ctypes.Union):
    pass

ATOM_FIRMWARE_CAPABILITY = struct__ATOM_FIRMWARE_CAPABILITY
union__ATOM_FIRMWARE_CAPABILITY_ACCESS._pack_ = True # source:False
union__ATOM_FIRMWARE_CAPABILITY_ACCESS._fields_ = [
    ('sbfAccess', ATOM_FIRMWARE_CAPABILITY),
    ('susAccess', ctypes.c_uint16),
]

ATOM_FIRMWARE_CAPABILITY_ACCESS = union__ATOM_FIRMWARE_CAPABILITY_ACCESS
struct__ATOM_FIRMWARE_INFO._pack_ = True # source:False
struct__ATOM_FIRMWARE_INFO._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulFirmwareRevision', ctypes.c_uint32),
    ('ulDefaultEngineClock', ctypes.c_uint32),
    ('ulDefaultMemoryClock', ctypes.c_uint32),
    ('ulDriverTargetEngineClock', ctypes.c_uint32),
    ('ulDriverTargetMemoryClock', ctypes.c_uint32),
    ('ulMaxEngineClockPLL_Output', ctypes.c_uint32),
    ('ulMaxMemoryClockPLL_Output', ctypes.c_uint32),
    ('ulMaxPixelClockPLL_Output', ctypes.c_uint32),
    ('ulASICMaxEngineClock', ctypes.c_uint32),
    ('ulASICMaxMemoryClock', ctypes.c_uint32),
    ('ucASICMaxTemperature', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 3),
    ('aulReservedForBIOS', ctypes.c_uint32 * 3),
    ('usMinEngineClockPLL_Input', ctypes.c_uint16),
    ('usMaxEngineClockPLL_Input', ctypes.c_uint16),
    ('usMinEngineClockPLL_Output', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMaxMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Output', ctypes.c_uint16),
    ('usMaxPixelClock', ctypes.c_uint16),
    ('usMinPixelClockPLL_Input', ctypes.c_uint16),
    ('usMaxPixelClockPLL_Input', ctypes.c_uint16),
    ('usMinPixelClockPLL_Output', ctypes.c_uint16),
    ('usFirmwareCapability', ATOM_FIRMWARE_CAPABILITY_ACCESS),
    ('usReferenceClock', ctypes.c_uint16),
    ('usPM_RTS_Location', ctypes.c_uint16),
    ('ucPM_RTS_StreamSize', ctypes.c_ubyte),
    ('ucDesign_ID', ctypes.c_ubyte),
    ('ucMemoryModule_ID', ctypes.c_ubyte),
]

class struct__ATOM_FIRMWARE_INFO_V1_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulFirmwareRevision', ctypes.c_uint32),
    ('ulDefaultEngineClock', ctypes.c_uint32),
    ('ulDefaultMemoryClock', ctypes.c_uint32),
    ('ulDriverTargetEngineClock', ctypes.c_uint32),
    ('ulDriverTargetMemoryClock', ctypes.c_uint32),
    ('ulMaxEngineClockPLL_Output', ctypes.c_uint32),
    ('ulMaxMemoryClockPLL_Output', ctypes.c_uint32),
    ('ulMaxPixelClockPLL_Output', ctypes.c_uint32),
    ('ulASICMaxEngineClock', ctypes.c_uint32),
    ('ulASICMaxMemoryClock', ctypes.c_uint32),
    ('ucASICMaxTemperature', ctypes.c_ubyte),
    ('ucMinAllowedBL_Level', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
    ('aulReservedForBIOS', ctypes.c_uint32 * 2),
    ('ulMinPixelClockPLL_Output', ctypes.c_uint32),
    ('usMinEngineClockPLL_Input', ctypes.c_uint16),
    ('usMaxEngineClockPLL_Input', ctypes.c_uint16),
    ('usMinEngineClockPLL_Output', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMaxMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Output', ctypes.c_uint16),
    ('usMaxPixelClock', ctypes.c_uint16),
    ('usMinPixelClockPLL_Input', ctypes.c_uint16),
    ('usMaxPixelClockPLL_Input', ctypes.c_uint16),
    ('usMinPixelClockPLL_Output', ctypes.c_uint16),
    ('usFirmwareCapability', ATOM_FIRMWARE_CAPABILITY_ACCESS),
    ('usReferenceClock', ctypes.c_uint16),
    ('usPM_RTS_Location', ctypes.c_uint16),
    ('ucPM_RTS_StreamSize', ctypes.c_ubyte),
    ('ucDesign_ID', ctypes.c_ubyte),
    ('ucMemoryModule_ID', ctypes.c_ubyte),
     ]

class struct__ATOM_FIRMWARE_INFO_V1_3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulFirmwareRevision', ctypes.c_uint32),
    ('ulDefaultEngineClock', ctypes.c_uint32),
    ('ulDefaultMemoryClock', ctypes.c_uint32),
    ('ulDriverTargetEngineClock', ctypes.c_uint32),
    ('ulDriverTargetMemoryClock', ctypes.c_uint32),
    ('ulMaxEngineClockPLL_Output', ctypes.c_uint32),
    ('ulMaxMemoryClockPLL_Output', ctypes.c_uint32),
    ('ulMaxPixelClockPLL_Output', ctypes.c_uint32),
    ('ulASICMaxEngineClock', ctypes.c_uint32),
    ('ulASICMaxMemoryClock', ctypes.c_uint32),
    ('ucASICMaxTemperature', ctypes.c_ubyte),
    ('ucMinAllowedBL_Level', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
    ('aulReservedForBIOS', ctypes.c_uint32),
    ('ul3DAccelerationEngineClock', ctypes.c_uint32),
    ('ulMinPixelClockPLL_Output', ctypes.c_uint32),
    ('usMinEngineClockPLL_Input', ctypes.c_uint16),
    ('usMaxEngineClockPLL_Input', ctypes.c_uint16),
    ('usMinEngineClockPLL_Output', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMaxMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Output', ctypes.c_uint16),
    ('usMaxPixelClock', ctypes.c_uint16),
    ('usMinPixelClockPLL_Input', ctypes.c_uint16),
    ('usMaxPixelClockPLL_Input', ctypes.c_uint16),
    ('usMinPixelClockPLL_Output', ctypes.c_uint16),
    ('usFirmwareCapability', ATOM_FIRMWARE_CAPABILITY_ACCESS),
    ('usReferenceClock', ctypes.c_uint16),
    ('usPM_RTS_Location', ctypes.c_uint16),
    ('ucPM_RTS_StreamSize', ctypes.c_ubyte),
    ('ucDesign_ID', ctypes.c_ubyte),
    ('ucMemoryModule_ID', ctypes.c_ubyte),
     ]

class struct__ATOM_FIRMWARE_INFO_V1_4(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulFirmwareRevision', ctypes.c_uint32),
    ('ulDefaultEngineClock', ctypes.c_uint32),
    ('ulDefaultMemoryClock', ctypes.c_uint32),
    ('ulDriverTargetEngineClock', ctypes.c_uint32),
    ('ulDriverTargetMemoryClock', ctypes.c_uint32),
    ('ulMaxEngineClockPLL_Output', ctypes.c_uint32),
    ('ulMaxMemoryClockPLL_Output', ctypes.c_uint32),
    ('ulMaxPixelClockPLL_Output', ctypes.c_uint32),
    ('ulASICMaxEngineClock', ctypes.c_uint32),
    ('ulASICMaxMemoryClock', ctypes.c_uint32),
    ('ucASICMaxTemperature', ctypes.c_ubyte),
    ('ucMinAllowedBL_Level', ctypes.c_ubyte),
    ('usBootUpVDDCVoltage', ctypes.c_uint16),
    ('usLcdMinPixelClockPLL_Output', ctypes.c_uint16),
    ('usLcdMaxPixelClockPLL_Output', ctypes.c_uint16),
    ('ul3DAccelerationEngineClock', ctypes.c_uint32),
    ('ulMinPixelClockPLL_Output', ctypes.c_uint32),
    ('usMinEngineClockPLL_Input', ctypes.c_uint16),
    ('usMaxEngineClockPLL_Input', ctypes.c_uint16),
    ('usMinEngineClockPLL_Output', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMaxMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Output', ctypes.c_uint16),
    ('usMaxPixelClock', ctypes.c_uint16),
    ('usMinPixelClockPLL_Input', ctypes.c_uint16),
    ('usMaxPixelClockPLL_Input', ctypes.c_uint16),
    ('usMinPixelClockPLL_Output', ctypes.c_uint16),
    ('usFirmwareCapability', ATOM_FIRMWARE_CAPABILITY_ACCESS),
    ('usReferenceClock', ctypes.c_uint16),
    ('usPM_RTS_Location', ctypes.c_uint16),
    ('ucPM_RTS_StreamSize', ctypes.c_ubyte),
    ('ucDesign_ID', ctypes.c_ubyte),
    ('ucMemoryModule_ID', ctypes.c_ubyte),
     ]

class struct__ATOM_FIRMWARE_INFO_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulFirmwareRevision', ctypes.c_uint32),
    ('ulDefaultEngineClock', ctypes.c_uint32),
    ('ulDefaultMemoryClock', ctypes.c_uint32),
    ('ulReserved1', ctypes.c_uint32),
    ('ulReserved2', ctypes.c_uint32),
    ('ulMaxEngineClockPLL_Output', ctypes.c_uint32),
    ('ulMaxMemoryClockPLL_Output', ctypes.c_uint32),
    ('ulMaxPixelClockPLL_Output', ctypes.c_uint32),
    ('ulBinaryAlteredInfo', ctypes.c_uint32),
    ('ulDefaultDispEngineClkFreq', ctypes.c_uint32),
    ('ucReserved1', ctypes.c_ubyte),
    ('ucMinAllowedBL_Level', ctypes.c_ubyte),
    ('usBootUpVDDCVoltage', ctypes.c_uint16),
    ('usLcdMinPixelClockPLL_Output', ctypes.c_uint16),
    ('usLcdMaxPixelClockPLL_Output', ctypes.c_uint16),
    ('ulReserved4', ctypes.c_uint32),
    ('ulMinPixelClockPLL_Output', ctypes.c_uint32),
    ('usMinEngineClockPLL_Input', ctypes.c_uint16),
    ('usMaxEngineClockPLL_Input', ctypes.c_uint16),
    ('usMinEngineClockPLL_Output', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMaxMemoryClockPLL_Input', ctypes.c_uint16),
    ('usMinMemoryClockPLL_Output', ctypes.c_uint16),
    ('usMaxPixelClock', ctypes.c_uint16),
    ('usMinPixelClockPLL_Input', ctypes.c_uint16),
    ('usMaxPixelClockPLL_Input', ctypes.c_uint16),
    ('usMinPixelClockPLL_Output', ctypes.c_uint16),
    ('usFirmwareCapability', ATOM_FIRMWARE_CAPABILITY_ACCESS),
    ('usCoreReferenceClock', ctypes.c_uint16),
    ('usMemoryReferenceClock', ctypes.c_uint16),
    ('usUniphyDPModeExtClkFreq', ctypes.c_uint16),
    ('ucMemoryModule_ID', ctypes.c_ubyte),
    ('ucReserved4', ctypes.c_ubyte * 3),
     ]

class struct__PRODUCT_BRANDING(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEMBEDDED_CAP', ctypes.c_ubyte, 2),
    ('ucReserved', ctypes.c_ubyte, 2),
    ('ucBRANDING_ID', ctypes.c_ubyte, 4),
     ]

class struct__ATOM_FIRMWARE_INFO_V2_2(ctypes.Structure):
    pass

PRODUCT_BRANDING = struct__PRODUCT_BRANDING
struct__ATOM_FIRMWARE_INFO_V2_2._pack_ = True # source:False
struct__ATOM_FIRMWARE_INFO_V2_2._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulFirmwareRevision', ctypes.c_uint32),
    ('ulDefaultEngineClock', ctypes.c_uint32),
    ('ulDefaultMemoryClock', ctypes.c_uint32),
    ('ulSPLL_OutputFreq', ctypes.c_uint32),
    ('ulGPUPLL_OutputFreq', ctypes.c_uint32),
    ('ulReserved1', ctypes.c_uint32),
    ('ulReserved2', ctypes.c_uint32),
    ('ulMaxPixelClockPLL_Output', ctypes.c_uint32),
    ('ulBinaryAlteredInfo', ctypes.c_uint32),
    ('ulDefaultDispEngineClkFreq', ctypes.c_uint32),
    ('ucReserved3', ctypes.c_ubyte),
    ('ucMinAllowedBL_Level', ctypes.c_ubyte),
    ('usBootUpVDDCVoltage', ctypes.c_uint16),
    ('usLcdMinPixelClockPLL_Output', ctypes.c_uint16),
    ('usLcdMaxPixelClockPLL_Output', ctypes.c_uint16),
    ('ulReserved4', ctypes.c_uint32),
    ('ulMinPixelClockPLL_Output', ctypes.c_uint32),
    ('ucRemoteDisplayConfig', ctypes.c_ubyte),
    ('ucReserved5', ctypes.c_ubyte * 3),
    ('ulReserved6', ctypes.c_uint32),
    ('ulReserved7', ctypes.c_uint32),
    ('usReserved11', ctypes.c_uint16),
    ('usMinPixelClockPLL_Input', ctypes.c_uint16),
    ('usMaxPixelClockPLL_Input', ctypes.c_uint16),
    ('usBootUpVDDCIVoltage', ctypes.c_uint16),
    ('usFirmwareCapability', ATOM_FIRMWARE_CAPABILITY_ACCESS),
    ('usCoreReferenceClock', ctypes.c_uint16),
    ('usMemoryReferenceClock', ctypes.c_uint16),
    ('usUniphyDPModeExtClkFreq', ctypes.c_uint16),
    ('ucMemoryModule_ID', ctypes.c_ubyte),
    ('ucCoolingSolution_ID', ctypes.c_ubyte),
    ('ucProductBranding', PRODUCT_BRANDING),
    ('ucReserved9', ctypes.c_ubyte),
    ('usBootUpMVDDCVoltage', ctypes.c_uint16),
    ('usBootUpVDDGFXVoltage', ctypes.c_uint16),
    ('ulReserved10', ctypes.c_uint32 * 3),
]

class struct__ATOM_INTEGRATED_SYSTEM_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulBootUpEngineClock', ctypes.c_uint32),
    ('ulBootUpMemoryClock', ctypes.c_uint32),
    ('ulMaxSystemMemoryClock', ctypes.c_uint32),
    ('ulMinSystemMemoryClock', ctypes.c_uint32),
    ('ucNumberOfCyclesInPeriodHi', ctypes.c_ubyte),
    ('ucLCDTimingSel', ctypes.c_ubyte),
    ('usReserved1', ctypes.c_uint16),
    ('usInterNBVoltageLow', ctypes.c_uint16),
    ('usInterNBVoltageHigh', ctypes.c_uint16),
    ('ulReserved', ctypes.c_uint32 * 2),
    ('usFSBClock', ctypes.c_uint16),
    ('usCapabilityFlag', ctypes.c_uint16),
    ('usPCIENBCfgReg7', ctypes.c_uint16),
    ('usK8MemoryClock', ctypes.c_uint16),
    ('usK8SyncStartDelay', ctypes.c_uint16),
    ('usK8DataReturnTime', ctypes.c_uint16),
    ('ucMaxNBVoltage', ctypes.c_ubyte),
    ('ucMinNBVoltage', ctypes.c_ubyte),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucNumberOfCyclesInPeriod', ctypes.c_ubyte),
    ('ucStartingPWM_HighTime', ctypes.c_ubyte),
    ('ucHTLinkWidth', ctypes.c_ubyte),
    ('ucMaxNBVoltageHigh', ctypes.c_ubyte),
    ('ucMinNBVoltageHigh', ctypes.c_ubyte),
     ]

class struct__ATOM_INTEGRATED_SYSTEM_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulBootUpEngineClock', ctypes.c_uint32),
    ('ulReserved1', ctypes.c_uint32 * 2),
    ('ulBootUpUMAClock', ctypes.c_uint32),
    ('ulBootUpSidePortClock', ctypes.c_uint32),
    ('ulMinSidePortClock', ctypes.c_uint32),
    ('ulReserved2', ctypes.c_uint32 * 6),
    ('ulSystemConfig', ctypes.c_uint32),
    ('ulBootUpReqDisplayVector', ctypes.c_uint32),
    ('ulOtherDisplayMisc', ctypes.c_uint32),
    ('ulDDISlot1Config', ctypes.c_uint32),
    ('ulDDISlot2Config', ctypes.c_uint32),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucUMAChannelNumber', ctypes.c_ubyte),
    ('ucDockingPinBit', ctypes.c_ubyte),
    ('ucDockingPinPolarity', ctypes.c_ubyte),
    ('ulDockingPinCFGInfo', ctypes.c_uint32),
    ('ulCPUCapInfo', ctypes.c_uint32),
    ('usNumberOfCyclesInPeriod', ctypes.c_uint16),
    ('usMaxNBVoltage', ctypes.c_uint16),
    ('usMinNBVoltage', ctypes.c_uint16),
    ('usBootUpNBVoltage', ctypes.c_uint16),
    ('ulHTLinkFreq', ctypes.c_uint32),
    ('usMinHTLinkWidth', ctypes.c_uint16),
    ('usMaxHTLinkWidth', ctypes.c_uint16),
    ('usUMASyncStartDelay', ctypes.c_uint16),
    ('usUMADataReturnTime', ctypes.c_uint16),
    ('usLinkStatusZeroTime', ctypes.c_uint16),
    ('usDACEfuse', ctypes.c_uint16),
    ('ulHighVoltageHTLinkFreq', ctypes.c_uint32),
    ('ulLowVoltageHTLinkFreq', ctypes.c_uint32),
    ('usMaxUpStreamHTLinkWidth', ctypes.c_uint16),
    ('usMaxDownStreamHTLinkWidth', ctypes.c_uint16),
    ('usMinUpStreamHTLinkWidth', ctypes.c_uint16),
    ('usMinDownStreamHTLinkWidth', ctypes.c_uint16),
    ('usFirmwareVersion', ctypes.c_uint16),
    ('usFullT0Time', ctypes.c_uint16),
    ('ulReserved3', ctypes.c_uint32 * 96),
     ]

class struct__ATOM_INTEGRATED_SYSTEM_INFO_V5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulBootUpEngineClock', ctypes.c_uint32),
    ('ulDentistVCOFreq', ctypes.c_uint32),
    ('ulLClockFreq', ctypes.c_uint32),
    ('ulBootUpUMAClock', ctypes.c_uint32),
    ('ulReserved1', ctypes.c_uint32 * 8),
    ('ulBootUpReqDisplayVector', ctypes.c_uint32),
    ('ulOtherDisplayMisc', ctypes.c_uint32),
    ('ulReserved2', ctypes.c_uint32 * 4),
    ('ulSystemConfig', ctypes.c_uint32),
    ('ulCPUCapInfo', ctypes.c_uint32),
    ('usMaxNBVoltage', ctypes.c_uint16),
    ('usMinNBVoltage', ctypes.c_uint16),
    ('usBootUpNBVoltage', ctypes.c_uint16),
    ('ucHtcTmpLmt', ctypes.c_ubyte),
    ('ucTjOffset', ctypes.c_ubyte),
    ('ulReserved3', ctypes.c_uint32 * 4),
    ('ulDDISlot1Config', ctypes.c_uint32),
    ('ulDDISlot2Config', ctypes.c_uint32),
    ('ulDDISlot3Config', ctypes.c_uint32),
    ('ulDDISlot4Config', ctypes.c_uint32),
    ('ulReserved4', ctypes.c_uint32 * 4),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucUMAChannelNumber', ctypes.c_ubyte),
    ('usReserved', ctypes.c_uint16),
    ('ulReserved5', ctypes.c_uint32 * 4),
    ('ulCSR_M3_ARB_CNTL_DEFAULT', ctypes.c_uint32 * 10),
    ('ulCSR_M3_ARB_CNTL_UVD', ctypes.c_uint32 * 10),
    ('ulCSR_M3_ARB_CNTL_FS3D', ctypes.c_uint32 * 10),
    ('ulReserved6', ctypes.c_uint32 * 61),
     ]

class struct__ATOM_GPU_VIRTUALIZATION_INFO_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulMCUcodeRomStartAddr', ctypes.c_uint32),
    ('ulMCUcodeLength', ctypes.c_uint32),
    ('ulSMCUcodeRomStartAddr', ctypes.c_uint32),
    ('ulSMCUcodeLength', ctypes.c_uint32),
    ('ulRLCVUcodeRomStartAddr', ctypes.c_uint32),
    ('ulRLCVUcodeLength', ctypes.c_uint32),
    ('ulTOCUcodeStartAddr', ctypes.c_uint32),
    ('ulTOCUcodeLength', ctypes.c_uint32),
    ('ulSMCPatchTableStartAddr', ctypes.c_uint32),
    ('ulSmcPatchTableLength', ctypes.c_uint32),
    ('ulSystemFlag', ctypes.c_uint32),
     ]

class struct__ATOM_I2C_ID_CONFIG(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('bfI2C_LineMux', ctypes.c_ubyte, 4),
    ('bfHW_EngineID', ctypes.c_ubyte, 3),
    ('bfHW_Capable', ctypes.c_ubyte, 1),
     ]

class struct__ATOM_GPIO_I2C_ASSIGMENT(ctypes.Structure):
    pass

class union__ATOM_I2C_ID_CONFIG_ACCESS(ctypes.Union):
    pass

ATOM_I2C_ID_CONFIG = struct__ATOM_I2C_ID_CONFIG
union__ATOM_I2C_ID_CONFIG_ACCESS._pack_ = True # source:False
union__ATOM_I2C_ID_CONFIG_ACCESS._fields_ = [
    ('sbfAccess', ATOM_I2C_ID_CONFIG),
    ('ucAccess', ctypes.c_ubyte),
]

ATOM_I2C_ID_CONFIG_ACCESS = union__ATOM_I2C_ID_CONFIG_ACCESS
struct__ATOM_GPIO_I2C_ASSIGMENT._pack_ = True # source:False
struct__ATOM_GPIO_I2C_ASSIGMENT._fields_ = [
    ('usClkMaskRegisterIndex', ctypes.c_uint16),
    ('usClkEnRegisterIndex', ctypes.c_uint16),
    ('usClkY_RegisterIndex', ctypes.c_uint16),
    ('usClkA_RegisterIndex', ctypes.c_uint16),
    ('usDataMaskRegisterIndex', ctypes.c_uint16),
    ('usDataEnRegisterIndex', ctypes.c_uint16),
    ('usDataY_RegisterIndex', ctypes.c_uint16),
    ('usDataA_RegisterIndex', ctypes.c_uint16),
    ('sucI2cId', ATOM_I2C_ID_CONFIG_ACCESS),
    ('ucClkMaskShift', ctypes.c_ubyte),
    ('ucClkEnShift', ctypes.c_ubyte),
    ('ucClkY_Shift', ctypes.c_ubyte),
    ('ucClkA_Shift', ctypes.c_ubyte),
    ('ucDataMaskShift', ctypes.c_ubyte),
    ('ucDataEnShift', ctypes.c_ubyte),
    ('ucDataY_Shift', ctypes.c_ubyte),
    ('ucDataA_Shift', ctypes.c_ubyte),
    ('ucReserved1', ctypes.c_ubyte),
    ('ucReserved2', ctypes.c_ubyte),
]

class struct__ATOM_GPIO_I2C_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asGPIO_Info', struct__ATOM_GPIO_I2C_ASSIGMENT * 16),
     ]

class struct__ATOM_MODE_MISC_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('HorizontalCutOff', ctypes.c_uint16, 1),
    ('HSyncPolarity', ctypes.c_uint16, 1),
    ('VSyncPolarity', ctypes.c_uint16, 1),
    ('VerticalCutOff', ctypes.c_uint16, 1),
    ('H_ReplicationBy2', ctypes.c_uint16, 1),
    ('V_ReplicationBy2', ctypes.c_uint16, 1),
    ('CompositeSync', ctypes.c_uint16, 1),
    ('Interlace', ctypes.c_uint16, 1),
    ('DoubleClock', ctypes.c_uint16, 1),
    ('RGB888', ctypes.c_uint16, 1),
    ('Reserved', ctypes.c_uint16, 6),
     ]

class struct__SET_CRTC_USING_DTD_TIMING_PARAMETERS(ctypes.Structure):
    pass

class union__ATOM_MODE_MISC_INFO_ACCESS(ctypes.Union):
    pass

ATOM_MODE_MISC_INFO = struct__ATOM_MODE_MISC_INFO
union__ATOM_MODE_MISC_INFO_ACCESS._pack_ = True # source:False
union__ATOM_MODE_MISC_INFO_ACCESS._fields_ = [
    ('sbfAccess', ATOM_MODE_MISC_INFO),
    ('usAccess', ctypes.c_uint16),
]

ATOM_MODE_MISC_INFO_ACCESS = union__ATOM_MODE_MISC_INFO_ACCESS
struct__SET_CRTC_USING_DTD_TIMING_PARAMETERS._pack_ = True # source:False
struct__SET_CRTC_USING_DTD_TIMING_PARAMETERS._fields_ = [
    ('usH_Size', ctypes.c_uint16),
    ('usH_Blanking_Time', ctypes.c_uint16),
    ('usV_Size', ctypes.c_uint16),
    ('usV_Blanking_Time', ctypes.c_uint16),
    ('usH_SyncOffset', ctypes.c_uint16),
    ('usH_SyncWidth', ctypes.c_uint16),
    ('usV_SyncOffset', ctypes.c_uint16),
    ('usV_SyncWidth', ctypes.c_uint16),
    ('susModeMiscInfo', ATOM_MODE_MISC_INFO_ACCESS),
    ('ucH_Border', ctypes.c_ubyte),
    ('ucV_Border', ctypes.c_ubyte),
    ('ucCRTC', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 3),
]

class struct__SET_CRTC_TIMING_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usH_Total', ctypes.c_uint16),
    ('usH_Disp', ctypes.c_uint16),
    ('usH_SyncStart', ctypes.c_uint16),
    ('usH_SyncWidth', ctypes.c_uint16),
    ('usV_Total', ctypes.c_uint16),
    ('usV_Disp', ctypes.c_uint16),
    ('usV_SyncStart', ctypes.c_uint16),
    ('usV_SyncWidth', ctypes.c_uint16),
    ('susModeMiscInfo', ATOM_MODE_MISC_INFO_ACCESS),
    ('ucCRTC', ctypes.c_ubyte),
    ('ucOverscanRight', ctypes.c_ubyte),
    ('ucOverscanLeft', ctypes.c_ubyte),
    ('ucOverscanBottom', ctypes.c_ubyte),
    ('ucOverscanTop', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ATOM_MODE_TIMING(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usCRTC_H_Total', ctypes.c_uint16),
    ('usCRTC_H_Disp', ctypes.c_uint16),
    ('usCRTC_H_SyncStart', ctypes.c_uint16),
    ('usCRTC_H_SyncWidth', ctypes.c_uint16),
    ('usCRTC_V_Total', ctypes.c_uint16),
    ('usCRTC_V_Disp', ctypes.c_uint16),
    ('usCRTC_V_SyncStart', ctypes.c_uint16),
    ('usCRTC_V_SyncWidth', ctypes.c_uint16),
    ('usPixelClock', ctypes.c_uint16),
    ('susModeMiscInfo', ATOM_MODE_MISC_INFO_ACCESS),
    ('usCRTC_OverscanRight', ctypes.c_uint16),
    ('usCRTC_OverscanLeft', ctypes.c_uint16),
    ('usCRTC_OverscanBottom', ctypes.c_uint16),
    ('usCRTC_OverscanTop', ctypes.c_uint16),
    ('usReserve', ctypes.c_uint16),
    ('ucInternalModeNumber', ctypes.c_ubyte),
    ('ucRefreshRate', ctypes.c_ubyte),
     ]

class struct__ATOM_DTD_FORMAT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPixClk', ctypes.c_uint16),
    ('usHActive', ctypes.c_uint16),
    ('usHBlanking_Time', ctypes.c_uint16),
    ('usVActive', ctypes.c_uint16),
    ('usVBlanking_Time', ctypes.c_uint16),
    ('usHSyncOffset', ctypes.c_uint16),
    ('usHSyncWidth', ctypes.c_uint16),
    ('usVSyncOffset', ctypes.c_uint16),
    ('usVSyncWidth', ctypes.c_uint16),
    ('usImageHSize', ctypes.c_uint16),
    ('usImageVSize', ctypes.c_uint16),
    ('ucHBorder', ctypes.c_ubyte),
    ('ucVBorder', ctypes.c_ubyte),
    ('susModeMiscInfo', ATOM_MODE_MISC_INFO_ACCESS),
    ('ucInternalModeNumber', ctypes.c_ubyte),
    ('ucRefreshRate', ctypes.c_ubyte),
     ]

class struct__ATOM_LVDS_INFO(ctypes.Structure):
    pass

ATOM_DTD_FORMAT = struct__ATOM_DTD_FORMAT
struct__ATOM_LVDS_INFO._pack_ = True # source:False
struct__ATOM_LVDS_INFO._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('sLCDTiming', ATOM_DTD_FORMAT),
    ('usModePatchTableOffset', ctypes.c_uint16),
    ('usSupportedRefreshRate', ctypes.c_uint16),
    ('usOffDelayInMs', ctypes.c_uint16),
    ('ucPowerSequenceDigOntoDEin10Ms', ctypes.c_ubyte),
    ('ucPowerSequenceDEtoBLOnin10Ms', ctypes.c_ubyte),
    ('ucLVDS_Misc', ctypes.c_ubyte),
    ('ucPanelDefaultRefreshRate', ctypes.c_ubyte),
    ('ucPanelIdentification', ctypes.c_ubyte),
    ('ucSS_Id', ctypes.c_ubyte),
]

class struct__ATOM_LVDS_INFO_V12(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('sLCDTiming', ATOM_DTD_FORMAT),
    ('usExtInfoTableOffset', ctypes.c_uint16),
    ('usSupportedRefreshRate', ctypes.c_uint16),
    ('usOffDelayInMs', ctypes.c_uint16),
    ('ucPowerSequenceDigOntoDEin10Ms', ctypes.c_ubyte),
    ('ucPowerSequenceDEtoBLOnin10Ms', ctypes.c_ubyte),
    ('ucLVDS_Misc', ctypes.c_ubyte),
    ('ucPanelDefaultRefreshRate', ctypes.c_ubyte),
    ('ucPanelIdentification', ctypes.c_ubyte),
    ('ucSS_Id', ctypes.c_ubyte),
    ('usLCDVenderID', ctypes.c_uint16),
    ('usLCDProductID', ctypes.c_uint16),
    ('ucLCDPanel_SpecialHandlingCap', ctypes.c_ubyte),
    ('ucPanelInfoSize', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_LCD_REFRESH_RATE_SUPPORT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucSupportedRefreshRate', ctypes.c_ubyte),
    ('ucMinRefreshRateForDRR', ctypes.c_ubyte),
     ]

class struct__ATOM_LCD_INFO_V13(ctypes.Structure):
    pass

class union__ATOM_LCD_INFO_V13_0(ctypes.Union):
    pass

ATOM_LCD_REFRESH_RATE_SUPPORT = struct__ATOM_LCD_REFRESH_RATE_SUPPORT
union__ATOM_LCD_INFO_V13_0._pack_ = True # source:False
union__ATOM_LCD_INFO_V13_0._fields_ = [
    ('usSupportedRefreshRate', ctypes.c_uint16),
    ('sRefreshRateSupport', ATOM_LCD_REFRESH_RATE_SUPPORT),
]

struct__ATOM_LCD_INFO_V13._pack_ = True # source:False
struct__ATOM_LCD_INFO_V13._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('sLCDTiming', ATOM_DTD_FORMAT),
    ('usExtInfoTableOffset', ctypes.c_uint16),
    ('_3', union__ATOM_LCD_INFO_V13_0),
    ('ulReserved0', ctypes.c_uint32),
    ('ucLCD_Misc', ctypes.c_ubyte),
    ('ucPanelDefaultRefreshRate', ctypes.c_ubyte),
    ('ucPanelIdentification', ctypes.c_ubyte),
    ('ucSS_Id', ctypes.c_ubyte),
    ('usLCDVenderID', ctypes.c_uint16),
    ('usLCDProductID', ctypes.c_uint16),
    ('ucLCDPanel_SpecialHandlingCap', ctypes.c_ubyte),
    ('ucPanelInfoSize', ctypes.c_ubyte),
    ('usBacklightPWM', ctypes.c_uint16),
    ('ucPowerSequenceDIGONtoDE_in4Ms', ctypes.c_ubyte),
    ('ucPowerSequenceDEtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucPowerSequenceVARY_BLtoDE_in4Ms', ctypes.c_ubyte),
    ('ucPowerSequenceDEtoDIGON_in4Ms', ctypes.c_ubyte),
    ('ucOffDelay_in4Ms', ctypes.c_ubyte),
    ('ucPowerSequenceVARY_BLtoBLON_in4Ms', ctypes.c_ubyte),
    ('ucPowerSequenceBLONtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucReserved1', ctypes.c_ubyte),
    ('ucDPCD_eDP_CONFIGURATION_CAP', ctypes.c_ubyte),
    ('ucDPCD_MAX_LINK_RATE', ctypes.c_ubyte),
    ('ucDPCD_MAX_LANE_COUNT', ctypes.c_ubyte),
    ('ucDPCD_MAX_DOWNSPREAD', ctypes.c_ubyte),
    ('usMaxPclkFreqInSingleLink', ctypes.c_uint16),
    ('uceDPToLVDSRxId', ctypes.c_ubyte),
    ('ucLcdReservd', ctypes.c_ubyte),
    ('ulReserved', ctypes.c_uint32 * 2),
]

class struct__ATOM_PATCH_RECORD_MODE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRecordType', ctypes.c_ubyte),
    ('usHDisp', ctypes.c_uint16),
    ('usVDisp', ctypes.c_uint16),
     ]

class struct__ATOM_LCD_RTS_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRecordType', ctypes.c_ubyte),
    ('ucRTSValue', ctypes.c_ubyte),
     ]

class struct__ATOM_LCD_MODE_CONTROL_CAP(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRecordType', ctypes.c_ubyte),
    ('usLCDCap', ctypes.c_uint16),
     ]

class struct__ATOM_FAKE_EDID_PATCH_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRecordType', ctypes.c_ubyte),
    ('ucFakeEDIDLength', ctypes.c_ubyte),
    ('ucFakeEDIDString', ctypes.c_ubyte * 1),
     ]

class struct__ATOM_PANEL_RESOLUTION_PATCH_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRecordType', ctypes.c_ubyte),
    ('usHSize', ctypes.c_uint16),
    ('usVSize', ctypes.c_uint16),
     ]

class struct__ATOM_SPREAD_SPECTRUM_ASSIGNMENT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usSpreadSpectrumPercentage', ctypes.c_uint16),
    ('ucSpreadSpectrumType', ctypes.c_ubyte),
    ('ucSS_Step', ctypes.c_ubyte),
    ('ucSS_Delay', ctypes.c_ubyte),
    ('ucSS_Id', ctypes.c_ubyte),
    ('ucRecommendedRef_Div', ctypes.c_ubyte),
    ('ucSS_Range', ctypes.c_ubyte),
     ]

class struct__ATOM_SPREAD_SPECTRUM_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asSS_Info', struct__ATOM_SPREAD_SPECTRUM_ASSIGNMENT * 16),
     ]

class struct__ATOM_ANALOG_TV_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucTV_SuppportedStandard', ctypes.c_ubyte),
    ('ucTV_BootUpDefaultStandard', ctypes.c_ubyte),
    ('ucExt_TV_ASIC_ID', ctypes.c_ubyte),
    ('ucExt_TV_ASIC_SlaveAddr', ctypes.c_ubyte),
    ('aModeTimings', struct__ATOM_DTD_FORMAT * 2),
     ]

class struct__ATOM_DPCD_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevisionNumber', ctypes.c_ubyte),
    ('ucMaxLinkRate', ctypes.c_ubyte),
    ('ucMaxLane', ctypes.c_ubyte),
    ('ucMaxDownSpread', ctypes.c_ubyte),
     ]

class struct__ATOM_FIRMWARE_VRAM_RESERVE_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulStartAddrUsedByFirmware', ctypes.c_uint32),
    ('usFirmwareUseInKb', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
     ]

class struct__ATOM_VRAM_USAGE_BY_FIRMWARE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asFirmwareVramReserveInfo', struct__ATOM_FIRMWARE_VRAM_RESERVE_INFO * 1),
     ]

class struct__ATOM_FIRMWARE_VRAM_RESERVE_INFO_V1_5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulStartAddrUsedByFirmware', ctypes.c_uint32),
    ('usFirmwareUseInKb', ctypes.c_uint16),
    ('usFBUsedByDrvInKb', ctypes.c_uint16),
     ]

class struct__ATOM_VRAM_USAGE_BY_FIRMWARE_V1_5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asFirmwareVramReserveInfo', struct__ATOM_FIRMWARE_VRAM_RESERVE_INFO_V1_5 * 1),
     ]

class struct__ATOM_GPIO_PIN_ASSIGNMENT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usGpioPin_AIndex', ctypes.c_uint16),
    ('ucGpioPinBitShift', ctypes.c_ubyte),
    ('ucGPIO_ID', ctypes.c_ubyte),
     ]

class struct__ATOM_GPIO_PIN_LUT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asGPIO_Pin', struct__ATOM_GPIO_PIN_ASSIGNMENT * 1),
     ]

class struct__ATOM_GPIO_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usAOffset', ctypes.c_uint16),
    ('ucSettings', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ATOM_COMPONENT_VIDEO_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usMask_PinRegisterIndex', ctypes.c_uint16),
    ('usEN_PinRegisterIndex', ctypes.c_uint16),
    ('usY_PinRegisterIndex', ctypes.c_uint16),
    ('usA_PinRegisterIndex', ctypes.c_uint16),
    ('ucBitShift', ctypes.c_ubyte),
    ('ucPinActiveState', ctypes.c_ubyte),
    ('sReserved', ATOM_DTD_FORMAT),
    ('ucMiscInfo', ctypes.c_ubyte),
    ('uc480i', ctypes.c_ubyte),
    ('uc480p', ctypes.c_ubyte),
    ('uc720p', ctypes.c_ubyte),
    ('uc1080i', ctypes.c_ubyte),
    ('ucLetterBoxMode', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('ucNumOfWbGpioBlocks', ctypes.c_ubyte),
    ('aWbGpioStateBlock', struct__ATOM_GPIO_INFO * 5),
    ('aModeTimings', struct__ATOM_DTD_FORMAT * 5),
     ]

class struct__ATOM_COMPONENT_VIDEO_INFO_V21(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucMiscInfo', ctypes.c_ubyte),
    ('uc480i', ctypes.c_ubyte),
    ('uc480p', ctypes.c_ubyte),
    ('uc720p', ctypes.c_ubyte),
    ('uc1080i', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ucLetterBoxMode', ctypes.c_ubyte),
    ('ucNumOfWbGpioBlocks', ctypes.c_ubyte),
    ('aWbGpioStateBlock', struct__ATOM_GPIO_INFO * 5),
    ('aModeTimings', struct__ATOM_DTD_FORMAT * 5),
     ]

class struct__ATOM_OBJECT_HEADER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usDeviceSupport', ctypes.c_uint16),
    ('usConnectorObjectTableOffset', ctypes.c_uint16),
    ('usRouterObjectTableOffset', ctypes.c_uint16),
    ('usEncoderObjectTableOffset', ctypes.c_uint16),
    ('usProtectionObjectTableOffset', ctypes.c_uint16),
    ('usDisplayPathTableOffset', ctypes.c_uint16),
     ]

class struct__ATOM_OBJECT_HEADER_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usDeviceSupport', ctypes.c_uint16),
    ('usConnectorObjectTableOffset', ctypes.c_uint16),
    ('usRouterObjectTableOffset', ctypes.c_uint16),
    ('usEncoderObjectTableOffset', ctypes.c_uint16),
    ('usProtectionObjectTableOffset', ctypes.c_uint16),
    ('usDisplayPathTableOffset', ctypes.c_uint16),
    ('usMiscObjectTableOffset', ctypes.c_uint16),
     ]

class struct__ATOM_DISPLAY_OBJECT_PATH(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usDeviceTag', ctypes.c_uint16),
    ('usSize', ctypes.c_uint16),
    ('usConnObjectId', ctypes.c_uint16),
    ('usGPUObjectId', ctypes.c_uint16),
    ('usGraphicObjIds', ctypes.c_uint16 * 1),
     ]

class struct__ATOM_DISPLAY_EXTERNAL_OBJECT_PATH(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usDeviceTag', ctypes.c_uint16),
    ('usSize', ctypes.c_uint16),
    ('usConnObjectId', ctypes.c_uint16),
    ('usGPUObjectId', ctypes.c_uint16),
    ('usGraphicObjIds', ctypes.c_uint16 * 2),
     ]

class struct__ATOM_DISPLAY_OBJECT_PATH_TABLE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucNumOfDispPath', ctypes.c_ubyte),
    ('ucVersion', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
    ('asDispPath', struct__ATOM_DISPLAY_OBJECT_PATH * 1),
     ]

class struct__ATOM_OBJECT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usObjectID', ctypes.c_uint16),
    ('usSrcDstTableOffset', ctypes.c_uint16),
    ('usRecordOffset', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
     ]

class struct__ATOM_OBJECT_TABLE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucNumberOfObjects', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 3),
    ('asObjects', struct__ATOM_OBJECT * 1),
     ]

class struct__ATOM_SRC_DST_TABLE_FOR_ONE_OBJECT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucNumberOfSrc', ctypes.c_ubyte),
    ('usSrcObjectID', ctypes.c_uint16 * 1),
    ('ucNumberOfDst', ctypes.c_ubyte),
    ('usDstObjectID', ctypes.c_uint16 * 1),
     ]

class struct__ATOM_DP_CONN_CHANNEL_MAPPING(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDP_Lane0_Source', ctypes.c_ubyte, 2),
    ('ucDP_Lane1_Source', ctypes.c_ubyte, 2),
    ('ucDP_Lane2_Source', ctypes.c_ubyte, 2),
    ('ucDP_Lane3_Source', ctypes.c_ubyte, 2),
     ]

class struct__ATOM_DVI_CONN_CHANNEL_MAPPING(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucDVI_DATA2_Source', ctypes.c_ubyte, 2),
    ('ucDVI_DATA1_Source', ctypes.c_ubyte, 2),
    ('ucDVI_DATA0_Source', ctypes.c_ubyte, 2),
    ('ucDVI_CLK_Source', ctypes.c_ubyte, 2),
     ]

class struct__EXT_DISPLAY_PATH(ctypes.Structure):
    pass

class union__EXT_DISPLAY_PATH_0(ctypes.Union):
    pass

ATOM_DVI_CONN_CHANNEL_MAPPING = struct__ATOM_DVI_CONN_CHANNEL_MAPPING
ATOM_DP_CONN_CHANNEL_MAPPING = struct__ATOM_DP_CONN_CHANNEL_MAPPING
union__EXT_DISPLAY_PATH_0._pack_ = True # source:False
union__EXT_DISPLAY_PATH_0._fields_ = [
    ('ucChannelMapping', ctypes.c_ubyte),
    ('asDPMapping', ATOM_DP_CONN_CHANNEL_MAPPING),
    ('asDVIMapping', ATOM_DVI_CONN_CHANNEL_MAPPING),
]

struct__EXT_DISPLAY_PATH._pack_ = True # source:False
struct__EXT_DISPLAY_PATH._fields_ = [
    ('usDeviceTag', ctypes.c_uint16),
    ('usDeviceACPIEnum', ctypes.c_uint16),
    ('usDeviceConnector', ctypes.c_uint16),
    ('ucExtAUXDDCLutIndex', ctypes.c_ubyte),
    ('ucExtHPDPINLutIndex', ctypes.c_ubyte),
    ('usExtEncoderObjId', ctypes.c_uint16),
    ('_6', union__EXT_DISPLAY_PATH_0),
    ('ucChPNInvert', ctypes.c_ubyte),
    ('usCaps', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
]

class struct__ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucGuid', ctypes.c_ubyte * 16),
    ('sPath', struct__EXT_DISPLAY_PATH * 7),
    ('ucChecksum', ctypes.c_ubyte),
    ('uc3DStereoPinId', ctypes.c_ubyte),
    ('ucRemoteDisplayConfig', ctypes.c_ubyte),
    ('uceDPToLVDSRxId', ctypes.c_ubyte),
    ('ucFixDPVoltageSwing', ctypes.c_ubyte),
    ('Reserved', ctypes.c_ubyte * 3),
     ]

class struct__ATOM_COMMON_RECORD_HEADER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRecordType', ctypes.c_ubyte),
    ('ucRecordSize', ctypes.c_ubyte),
     ]

class struct__ATOM_I2C_RECORD(ctypes.Structure):
    pass

ATOM_COMMON_RECORD_HEADER = struct__ATOM_COMMON_RECORD_HEADER
struct__ATOM_I2C_RECORD._pack_ = True # source:False
struct__ATOM_I2C_RECORD._fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('sucI2cId', ATOM_I2C_ID_CONFIG),
    ('ucI2CAddr', ctypes.c_ubyte),
]

class struct__ATOM_HPD_INT_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucHPDIntGPIOID', ctypes.c_ubyte),
    ('ucPlugged_PinState', ctypes.c_ubyte),
     ]

class struct__ATOM_OUTPUT_PROTECTION_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucProtectionFlag', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ATOM_CONNECTOR_DEVICE_TAG(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulACPIDeviceEnum', ctypes.c_uint32),
    ('usDeviceID', ctypes.c_uint16),
    ('usPadding', ctypes.c_uint16),
     ]

class struct__ATOM_CONNECTOR_DEVICE_TAG_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucNumberOfDevice', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('asDeviceTag', struct__ATOM_CONNECTOR_DEVICE_TAG * 1),
     ]

class struct__ATOM_CONNECTOR_DVI_EXT_INPUT_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucConfigGPIOID', ctypes.c_ubyte),
    ('ucConfigGPIOState', ctypes.c_ubyte),
    ('ucFlowinGPIPID', ctypes.c_ubyte),
    ('ucExtInGPIPID', ctypes.c_ubyte),
     ]

class struct__ATOM_ENCODER_FPGA_CONTROL_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucCTL1GPIO_ID', ctypes.c_ubyte),
    ('ucCTL1GPIOState', ctypes.c_ubyte),
    ('ucCTL2GPIO_ID', ctypes.c_ubyte),
    ('ucCTL2GPIOState', ctypes.c_ubyte),
    ('ucCTL3GPIO_ID', ctypes.c_ubyte),
    ('ucCTL3GPIOState', ctypes.c_ubyte),
    ('ucCTLFPGA_IN_ID', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 3),
     ]

class struct__ATOM_CONNECTOR_CVTV_SHARE_DIN_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucGPIOID', ctypes.c_ubyte),
    ('ucTVActiveState', ctypes.c_ubyte),
     ]

class struct__ATOM_JTAG_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucTMSGPIO_ID', ctypes.c_ubyte),
    ('ucTMSGPIOState', ctypes.c_ubyte),
    ('ucTCKGPIO_ID', ctypes.c_ubyte),
    ('ucTCKGPIOState', ctypes.c_ubyte),
    ('ucTDOGPIO_ID', ctypes.c_ubyte),
    ('ucTDOGPIOState', ctypes.c_ubyte),
    ('ucTDIGPIO_ID', ctypes.c_ubyte),
    ('ucTDIGPIOState', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_GPIO_PIN_CONTROL_PAIR(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucGPIOID', ctypes.c_ubyte),
    ('ucGPIO_PinState', ctypes.c_ubyte),
     ]

class struct__ATOM_OBJECT_GPIO_CNTL_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucFlags', ctypes.c_ubyte),
    ('ucNumberOfPins', ctypes.c_ubyte),
    ('asGpio', struct__ATOM_GPIO_PIN_CONTROL_PAIR * 1),
     ]

class struct__ATOM_ENCODER_DVO_CF_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ulStrengthControl', ctypes.c_uint32),
    ('ucPadding', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_ENCODER_CAP_RECORD(ctypes.Structure):
    pass

class union__ATOM_ENCODER_CAP_RECORD_0(ctypes.Union):
    pass

class struct__ATOM_ENCODER_CAP_RECORD_0_0(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usHBR2Cap', ctypes.c_uint16, 1),
    ('usHBR2En', ctypes.c_uint16, 1),
    ('usReserved', ctypes.c_uint16, 14),
     ]

union__ATOM_ENCODER_CAP_RECORD_0._pack_ = True # source:False
union__ATOM_ENCODER_CAP_RECORD_0._fields_ = [
    ('usEncoderCap', ctypes.c_uint16),
    ('_1', struct__ATOM_ENCODER_CAP_RECORD_0_0),
]

struct__ATOM_ENCODER_CAP_RECORD._pack_ = True # source:False
struct__ATOM_ENCODER_CAP_RECORD._fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('_1', union__ATOM_ENCODER_CAP_RECORD_0),
]

class struct__ATOM_ENCODER_CAP_RECORD_V2(ctypes.Structure):
    pass

class union__ATOM_ENCODER_CAP_RECORD_V2_0(ctypes.Union):
    pass

class struct__ATOM_ENCODER_CAP_RECORD_V2_0_0(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usMSTEn', ctypes.c_uint16, 1),
    ('usHBR2En', ctypes.c_uint16, 1),
    ('usHDMI6GEn', ctypes.c_uint16, 1),
    ('usHBR3En', ctypes.c_uint16, 1),
    ('usReserved', ctypes.c_uint16, 12),
     ]

union__ATOM_ENCODER_CAP_RECORD_V2_0._pack_ = True # source:False
union__ATOM_ENCODER_CAP_RECORD_V2_0._fields_ = [
    ('usEncoderCap', ctypes.c_uint16),
    ('_1', struct__ATOM_ENCODER_CAP_RECORD_V2_0_0),
]

struct__ATOM_ENCODER_CAP_RECORD_V2._pack_ = True # source:False
struct__ATOM_ENCODER_CAP_RECORD_V2._fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('_1', union__ATOM_ENCODER_CAP_RECORD_V2_0),
]

class struct__ATOM_CONNECTOR_CF_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('usMaxPixClk', ctypes.c_uint16),
    ('ucFlowCntlGpioId', ctypes.c_ubyte),
    ('ucSwapCntlGpioId', ctypes.c_ubyte),
    ('ucConnectedDvoBundle', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte),
     ]

class struct__ATOM_CONNECTOR_HARDCODE_DTD_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('asTiming', ATOM_DTD_FORMAT),
     ]

class struct__ATOM_CONNECTOR_PCIE_SUBCONNECTOR_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucSubConnectorType', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ATOM_ROUTER_DDC_PATH_SELECT_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucMuxType', ctypes.c_ubyte),
    ('ucMuxControlPin', ctypes.c_ubyte),
    ('ucMuxState', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_ROUTER_DATA_CLOCK_PATH_SELECT_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucMuxType', ctypes.c_ubyte),
    ('ucMuxControlPin', ctypes.c_ubyte),
    ('ucMuxState', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_CONNECTOR_HPDPIN_LUT_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucHPDPINMap', ctypes.c_ubyte * 8),
     ]

class struct__ATOM_CONNECTOR_AUXDDC_LUT_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucAUXDDCMap', struct__ATOM_I2C_ID_CONFIG * 8),
     ]

class struct__ATOM_OBJECT_LINK_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('usObjectID', ctypes.c_uint16),
     ]

class struct__ATOM_CONNECTOR_REMOTE_CAP_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('usReserved', ctypes.c_uint16),
     ]

class struct__ATOM_CONNECTOR_FORCED_TMDS_CAP_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucMaxTmdsClkRateIn2_5Mhz', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ATOM_CONNECTOR_LAYOUT_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usConnectorObjectId', ctypes.c_uint16),
    ('ucConnectorType', ctypes.c_ubyte),
    ('ucPosition', ctypes.c_ubyte),
     ]

class struct__ATOM_BRACKET_LAYOUT_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sheader', ATOM_COMMON_RECORD_HEADER),
    ('ucLength', ctypes.c_ubyte),
    ('ucWidth', ctypes.c_ubyte),
    ('ucConnNum', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('asConnInfo', struct__ATOM_CONNECTOR_LAYOUT_INFO * 1),
     ]

class struct__ATOM_VOLTAGE_INFO_HEADER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usVDDCBaseLevel', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
    ('ucNumOfVoltageEntries', ctypes.c_ubyte),
    ('ucBytesPerVoltageEntry', ctypes.c_ubyte),
    ('ucVoltageStep', ctypes.c_ubyte),
    ('ucDefaultVoltageEntry', ctypes.c_ubyte),
    ('ucVoltageControlI2cLine', ctypes.c_ubyte),
    ('ucVoltageControlAddress', ctypes.c_ubyte),
    ('ucVoltageControlOffset', ctypes.c_ubyte),
     ]

class struct__ATOM_VOLTAGE_INFO(ctypes.Structure):
    pass

ATOM_VOLTAGE_INFO_HEADER = struct__ATOM_VOLTAGE_INFO_HEADER
struct__ATOM_VOLTAGE_INFO._pack_ = True # source:False
struct__ATOM_VOLTAGE_INFO._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('viHeader', ATOM_VOLTAGE_INFO_HEADER),
    ('ucVoltageEntries', ctypes.c_ubyte * 64),
]

class struct__ATOM_VOLTAGE_FORMULA(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usVoltageBaseLevel', ctypes.c_uint16),
    ('usVoltageStep', ctypes.c_uint16),
    ('ucNumOfVoltageEntries', ctypes.c_ubyte),
    ('ucFlag', ctypes.c_ubyte),
    ('ucBaseVID', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ucVIDAdjustEntries', ctypes.c_ubyte * 32),
     ]

class struct__VOLTAGE_LUT_ENTRY(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usVoltageCode', ctypes.c_uint16),
    ('usVoltageValue', ctypes.c_uint16),
     ]

class struct__ATOM_VOLTAGE_FORMULA_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucNumOfVoltageEntries', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('asVIDAdjustEntries', struct__VOLTAGE_LUT_ENTRY * 32),
     ]

class struct__ATOM_VOLTAGE_CONTROL(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVoltageControlId', ctypes.c_ubyte),
    ('ucVoltageControlI2cLine', ctypes.c_ubyte),
    ('ucVoltageControlAddress', ctypes.c_ubyte),
    ('ucVoltageControlOffset', ctypes.c_ubyte),
    ('usGpioPin_AIndex', ctypes.c_uint16),
    ('ucGpioPinBitShift', ctypes.c_ubyte * 9),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ATOM_VOLTAGE_OBJECT(ctypes.Structure):
    pass

ATOM_VOLTAGE_CONTROL = struct__ATOM_VOLTAGE_CONTROL
ATOM_VOLTAGE_FORMULA = struct__ATOM_VOLTAGE_FORMULA
struct__ATOM_VOLTAGE_OBJECT._pack_ = True # source:False
struct__ATOM_VOLTAGE_OBJECT._fields_ = [
    ('ucVoltageType', ctypes.c_ubyte),
    ('ucSize', ctypes.c_ubyte),
    ('asControl', ATOM_VOLTAGE_CONTROL),
    ('asFormula', ATOM_VOLTAGE_FORMULA),
]

class struct__ATOM_VOLTAGE_OBJECT_V2(ctypes.Structure):
    pass

ATOM_VOLTAGE_FORMULA_V2 = struct__ATOM_VOLTAGE_FORMULA_V2
struct__ATOM_VOLTAGE_OBJECT_V2._pack_ = True # source:False
struct__ATOM_VOLTAGE_OBJECT_V2._fields_ = [
    ('ucVoltageType', ctypes.c_ubyte),
    ('ucSize', ctypes.c_ubyte),
    ('asControl', ATOM_VOLTAGE_CONTROL),
    ('asFormula', ATOM_VOLTAGE_FORMULA_V2),
]

class struct__ATOM_VOLTAGE_OBJECT_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asVoltageObj', struct__ATOM_VOLTAGE_OBJECT * 3),
     ]

class struct__ATOM_VOLTAGE_OBJECT_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asVoltageObj', struct__ATOM_VOLTAGE_OBJECT_V2 * 3),
     ]

class struct__ATOM_LEAKID_VOLTAGE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucLeakageId', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('usVoltage', ctypes.c_uint16),
     ]

class struct__ATOM_VOLTAGE_OBJECT_HEADER_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVoltageType', ctypes.c_ubyte),
    ('ucVoltageMode', ctypes.c_ubyte),
    ('usSize', ctypes.c_uint16),
     ]

class struct__VOLTAGE_LUT_ENTRY_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulVoltageId', ctypes.c_uint32),
    ('usVoltageValue', ctypes.c_uint16),
     ]

class struct__LEAKAGE_VOLTAGE_LUT_ENTRY_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usVoltageLevel', ctypes.c_uint16),
    ('usVoltageId', ctypes.c_uint16),
    ('usLeakageId', ctypes.c_uint16),
     ]

class struct__ATOM_I2C_VOLTAGE_OBJECT_V3(ctypes.Structure):
    pass

ATOM_VOLTAGE_OBJECT_HEADER_V3 = struct__ATOM_VOLTAGE_OBJECT_HEADER_V3
struct__ATOM_I2C_VOLTAGE_OBJECT_V3._pack_ = True # source:False
struct__ATOM_I2C_VOLTAGE_OBJECT_V3._fields_ = [
    ('sHeader', ATOM_VOLTAGE_OBJECT_HEADER_V3),
    ('ucVoltageRegulatorId', ctypes.c_ubyte),
    ('ucVoltageControlI2cLine', ctypes.c_ubyte),
    ('ucVoltageControlAddress', ctypes.c_ubyte),
    ('ucVoltageControlOffset', ctypes.c_ubyte),
    ('ucVoltageControlFlag', ctypes.c_ubyte),
    ('ulReserved', ctypes.c_ubyte * 3),
    ('asVolI2cLut', struct__VOLTAGE_LUT_ENTRY * 1),
]

class struct__ATOM_GPIO_VOLTAGE_OBJECT_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_VOLTAGE_OBJECT_HEADER_V3),
    ('ucVoltageGpioCntlId', ctypes.c_ubyte),
    ('ucGpioEntryNum', ctypes.c_ubyte),
    ('ucPhaseDelay', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ulGpioMaskVal', ctypes.c_uint32),
    ('asVolGpioLut', struct__VOLTAGE_LUT_ENTRY_V2 * 1),
     ]

class struct__ATOM_LEAKAGE_VOLTAGE_OBJECT_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_VOLTAGE_OBJECT_HEADER_V3),
    ('ucLeakageCntlId', ctypes.c_ubyte),
    ('ucLeakageEntryNum', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
    ('ulMaxVoltageLevel', ctypes.c_uint32),
    ('asLeakageIdLut', struct__LEAKAGE_VOLTAGE_LUT_ENTRY_V2 * 1),
     ]

class struct__ATOM_SVID2_VOLTAGE_OBJECT_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_VOLTAGE_OBJECT_HEADER_V3),
    ('usLoadLine_PSI', ctypes.c_uint16),
    ('ucSVDGpioId', ctypes.c_ubyte),
    ('ucSVCGpioId', ctypes.c_ubyte),
    ('ulReserved', ctypes.c_uint32),
     ]

class struct__ATOM_MERGED_VOLTAGE_OBJECT_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_VOLTAGE_OBJECT_HEADER_V3),
    ('ucMergedVType', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
     ]

class struct__ATOM_EVV_DPM_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulDPMSclk', ctypes.c_uint32),
    ('usVAdjOffset', ctypes.c_uint16),
    ('ucDPMTblVIndex', ctypes.c_ubyte),
    ('ucDPMState', ctypes.c_ubyte),
     ]

class struct__ATOM_EVV_VOLTAGE_OBJECT_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_VOLTAGE_OBJECT_HEADER_V3),
    ('asEvvDpmList', struct__ATOM_EVV_DPM_INFO * 8),
     ]

class struct__ATOM_VOLTAGE_OBJECT_INFO_V3_1(ctypes.Structure):
    pass

class union__ATOM_VOLTAGE_OBJECT_V3(ctypes.Union):
    pass

ATOM_I2C_VOLTAGE_OBJECT_V3 = struct__ATOM_I2C_VOLTAGE_OBJECT_V3
ATOM_EVV_VOLTAGE_OBJECT_V3 = struct__ATOM_EVV_VOLTAGE_OBJECT_V3
ATOM_LEAKAGE_VOLTAGE_OBJECT_V3 = struct__ATOM_LEAKAGE_VOLTAGE_OBJECT_V3
ATOM_GPIO_VOLTAGE_OBJECT_V3 = struct__ATOM_GPIO_VOLTAGE_OBJECT_V3
ATOM_SVID2_VOLTAGE_OBJECT_V3 = struct__ATOM_SVID2_VOLTAGE_OBJECT_V3
union__ATOM_VOLTAGE_OBJECT_V3._pack_ = True # source:False
union__ATOM_VOLTAGE_OBJECT_V3._fields_ = [
    ('asGpioVoltageObj', ATOM_GPIO_VOLTAGE_OBJECT_V3),
    ('asI2cVoltageObj', ATOM_I2C_VOLTAGE_OBJECT_V3),
    ('asLeakageObj', ATOM_LEAKAGE_VOLTAGE_OBJECT_V3),
    ('asSVID2Obj', ATOM_SVID2_VOLTAGE_OBJECT_V3),
    ('asEvvObj', ATOM_EVV_VOLTAGE_OBJECT_V3),
]

struct__ATOM_VOLTAGE_OBJECT_INFO_V3_1._pack_ = True # source:False
struct__ATOM_VOLTAGE_OBJECT_INFO_V3_1._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asVoltageObj', union__ATOM_VOLTAGE_OBJECT_V3 * 3),
]

class struct__ATOM_ASIC_PROFILE_VOLTAGE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucProfileId', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('usSize', ctypes.c_uint16),
    ('usEfuseSpareStartAddr', ctypes.c_uint16),
    ('usFuseIndex', ctypes.c_uint16 * 8),
    ('asLeakVol', struct__ATOM_LEAKID_VOLTAGE * 2),
     ]

class struct__ATOM_ASIC_PROFILING_INFO(ctypes.Structure):
    pass

ATOM_ASIC_PROFILE_VOLTAGE = struct__ATOM_ASIC_PROFILE_VOLTAGE
struct__ATOM_ASIC_PROFILING_INFO._pack_ = True # source:False
struct__ATOM_ASIC_PROFILING_INFO._fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('asVoltage', ATOM_ASIC_PROFILE_VOLTAGE),
]

class struct__ATOM_ASIC_PROFILING_INFO_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucLeakageBinNum', ctypes.c_ubyte),
    ('usLeakageBinArrayOffset', ctypes.c_uint16),
    ('ucElbVDDC_Num', ctypes.c_ubyte),
    ('usElbVDDC_IdArrayOffset', ctypes.c_uint16),
    ('usElbVDDC_LevelArrayOffset', ctypes.c_uint16),
    ('ucElbVDDCI_Num', ctypes.c_ubyte),
    ('usElbVDDCI_IdArrayOffset', ctypes.c_uint16),
    ('usElbVDDCI_LevelArrayOffset', ctypes.c_uint16),
     ]

class struct__EFUSE_LOGISTIC_FUNC_PARAM(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usEfuseIndex', ctypes.c_uint16),
    ('ucEfuseBitLSB', ctypes.c_ubyte),
    ('ucEfuseLength', ctypes.c_ubyte),
    ('ulEfuseEncodeRange', ctypes.c_uint32),
    ('ulEfuseEncodeAverage', ctypes.c_uint32),
     ]

class struct__EFUSE_LINEAR_FUNC_PARAM(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usEfuseIndex', ctypes.c_uint16),
    ('ucEfuseBitLSB', ctypes.c_ubyte),
    ('ucEfuseLength', ctypes.c_ubyte),
    ('ulEfuseEncodeRange', ctypes.c_uint32),
    ('ulEfuseMin', ctypes.c_uint32),
     ]

class struct__ATOM_ASIC_PROFILING_INFO_V3_1(ctypes.Structure):
    pass

EFUSE_LOGISTIC_FUNC_PARAM = struct__EFUSE_LOGISTIC_FUNC_PARAM
EFUSE_LINEAR_FUNC_PARAM = struct__EFUSE_LINEAR_FUNC_PARAM
struct__ATOM_ASIC_PROFILING_INFO_V3_1._pack_ = True # source:False
struct__ATOM_ASIC_PROFILING_INFO_V3_1._fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulEvvDerateTdp', ctypes.c_uint32),
    ('ulEvvDerateTdc', ctypes.c_uint32),
    ('ulBoardCoreTemp', ctypes.c_uint32),
    ('ulMaxVddc', ctypes.c_uint32),
    ('ulMinVddc', ctypes.c_uint32),
    ('ulLoadLineSlop', ctypes.c_uint32),
    ('ulLeakageTemp', ctypes.c_uint32),
    ('ulLeakageVoltage', ctypes.c_uint32),
    ('sCACm', EFUSE_LINEAR_FUNC_PARAM),
    ('sCACb', EFUSE_LINEAR_FUNC_PARAM),
    ('sKt_b', EFUSE_LOGISTIC_FUNC_PARAM),
    ('sKv_m', EFUSE_LOGISTIC_FUNC_PARAM),
    ('sKv_b', EFUSE_LOGISTIC_FUNC_PARAM),
    ('usLkgEuseIndex', ctypes.c_uint16),
    ('ucLkgEfuseBitLSB', ctypes.c_ubyte),
    ('ucLkgEfuseLength', ctypes.c_ubyte),
    ('ulLkgEncodeLn_MaxDivMin', ctypes.c_uint32),
    ('ulLkgEncodeMax', ctypes.c_uint32),
    ('ulLkgEncodeMin', ctypes.c_uint32),
    ('ulEfuseLogisticAlpha', ctypes.c_uint32),
    ('usPowerDpm0', ctypes.c_uint16),
    ('usCurrentDpm0', ctypes.c_uint16),
    ('usPowerDpm1', ctypes.c_uint16),
    ('usCurrentDpm1', ctypes.c_uint16),
    ('usPowerDpm2', ctypes.c_uint16),
    ('usCurrentDpm2', ctypes.c_uint16),
    ('usPowerDpm3', ctypes.c_uint16),
    ('usCurrentDpm3', ctypes.c_uint16),
    ('usPowerDpm4', ctypes.c_uint16),
    ('usCurrentDpm4', ctypes.c_uint16),
    ('usPowerDpm5', ctypes.c_uint16),
    ('usCurrentDpm5', ctypes.c_uint16),
    ('usPowerDpm6', ctypes.c_uint16),
    ('usCurrentDpm6', ctypes.c_uint16),
    ('usPowerDpm7', ctypes.c_uint16),
    ('usCurrentDpm7', ctypes.c_uint16),
]

class struct__ATOM_ASIC_PROFILING_INFO_V3_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulEvvLkgFactor', ctypes.c_uint32),
    ('ulBoardCoreTemp', ctypes.c_uint32),
    ('ulMaxVddc', ctypes.c_uint32),
    ('ulMinVddc', ctypes.c_uint32),
    ('ulLoadLineSlop', ctypes.c_uint32),
    ('ulLeakageTemp', ctypes.c_uint32),
    ('ulLeakageVoltage', ctypes.c_uint32),
    ('sCACm', EFUSE_LINEAR_FUNC_PARAM),
    ('sCACb', EFUSE_LINEAR_FUNC_PARAM),
    ('sKt_b', EFUSE_LOGISTIC_FUNC_PARAM),
    ('sKv_m', EFUSE_LOGISTIC_FUNC_PARAM),
    ('sKv_b', EFUSE_LOGISTIC_FUNC_PARAM),
    ('usLkgEuseIndex', ctypes.c_uint16),
    ('ucLkgEfuseBitLSB', ctypes.c_ubyte),
    ('ucLkgEfuseLength', ctypes.c_ubyte),
    ('ulLkgEncodeLn_MaxDivMin', ctypes.c_uint32),
    ('ulLkgEncodeMax', ctypes.c_uint32),
    ('ulLkgEncodeMin', ctypes.c_uint32),
    ('ulEfuseLogisticAlpha', ctypes.c_uint32),
    ('usPowerDpm0', ctypes.c_uint16),
    ('usPowerDpm1', ctypes.c_uint16),
    ('usPowerDpm2', ctypes.c_uint16),
    ('usPowerDpm3', ctypes.c_uint16),
    ('usPowerDpm4', ctypes.c_uint16),
    ('usPowerDpm5', ctypes.c_uint16),
    ('usPowerDpm6', ctypes.c_uint16),
    ('usPowerDpm7', ctypes.c_uint16),
    ('ulTdpDerateDPM0', ctypes.c_uint32),
    ('ulTdpDerateDPM1', ctypes.c_uint32),
    ('ulTdpDerateDPM2', ctypes.c_uint32),
    ('ulTdpDerateDPM3', ctypes.c_uint32),
    ('ulTdpDerateDPM4', ctypes.c_uint32),
    ('ulTdpDerateDPM5', ctypes.c_uint32),
    ('ulTdpDerateDPM6', ctypes.c_uint32),
    ('ulTdpDerateDPM7', ctypes.c_uint32),
     ]

class struct__ATOM_ASIC_PROFILING_INFO_V3_3(ctypes.Structure):
    pass

class union__ATOM_ASIC_PROFILING_INFO_V3_3_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usPowerDpm0', ctypes.c_uint16),
    ('usParamNegFlag', ctypes.c_uint16),
     ]

struct__ATOM_ASIC_PROFILING_INFO_V3_3._pack_ = True # source:False
struct__ATOM_ASIC_PROFILING_INFO_V3_3._fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulEvvLkgFactor', ctypes.c_uint32),
    ('ulBoardCoreTemp', ctypes.c_uint32),
    ('ulMaxVddc', ctypes.c_uint32),
    ('ulMinVddc', ctypes.c_uint32),
    ('ulLoadLineSlop', ctypes.c_uint32),
    ('ulLeakageTemp', ctypes.c_uint32),
    ('ulLeakageVoltage', ctypes.c_uint32),
    ('sCACm', EFUSE_LINEAR_FUNC_PARAM),
    ('sCACb', EFUSE_LINEAR_FUNC_PARAM),
    ('sKt_b', EFUSE_LOGISTIC_FUNC_PARAM),
    ('sKv_m', EFUSE_LOGISTIC_FUNC_PARAM),
    ('sKv_b', EFUSE_LOGISTIC_FUNC_PARAM),
    ('usLkgEuseIndex', ctypes.c_uint16),
    ('ucLkgEfuseBitLSB', ctypes.c_ubyte),
    ('ucLkgEfuseLength', ctypes.c_ubyte),
    ('ulLkgEncodeLn_MaxDivMin', ctypes.c_uint32),
    ('ulLkgEncodeMax', ctypes.c_uint32),
    ('ulLkgEncodeMin', ctypes.c_uint32),
    ('ulEfuseLogisticAlpha', ctypes.c_uint32),
    ('_20', union__ATOM_ASIC_PROFILING_INFO_V3_3_0),
    ('usPowerDpm1', ctypes.c_uint16),
    ('usPowerDpm2', ctypes.c_uint16),
    ('usPowerDpm3', ctypes.c_uint16),
    ('usPowerDpm4', ctypes.c_uint16),
    ('usPowerDpm5', ctypes.c_uint16),
    ('usPowerDpm6', ctypes.c_uint16),
    ('usPowerDpm7', ctypes.c_uint16),
    ('ulTdpDerateDPM0', ctypes.c_uint32),
    ('ulTdpDerateDPM1', ctypes.c_uint32),
    ('ulTdpDerateDPM2', ctypes.c_uint32),
    ('ulTdpDerateDPM3', ctypes.c_uint32),
    ('ulTdpDerateDPM4', ctypes.c_uint32),
    ('ulTdpDerateDPM5', ctypes.c_uint32),
    ('ulTdpDerateDPM6', ctypes.c_uint32),
    ('ulTdpDerateDPM7', ctypes.c_uint32),
    ('sRoFuse', EFUSE_LINEAR_FUNC_PARAM),
    ('ulRoAlpha', ctypes.c_uint32),
    ('ulRoBeta', ctypes.c_uint32),
    ('ulRoGamma', ctypes.c_uint32),
    ('ulRoEpsilon', ctypes.c_uint32),
    ('ulATermRo', ctypes.c_uint32),
    ('ulBTermRo', ctypes.c_uint32),
    ('ulCTermRo', ctypes.c_uint32),
    ('ulSclkMargin', ctypes.c_uint32),
    ('ulFmaxPercent', ctypes.c_uint32),
    ('ulCRPercent', ctypes.c_uint32),
    ('ulSFmaxPercent', ctypes.c_uint32),
    ('ulSCRPercent', ctypes.c_uint32),
    ('ulSDCMargine', ctypes.c_uint32),
]

class struct__ATOM_ASIC_PROFILING_INFO_V3_4(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulEvvLkgFactor', ctypes.c_uint32),
    ('ulBoardCoreTemp', ctypes.c_uint32),
    ('ulMaxVddc', ctypes.c_uint32),
    ('ulMinVddc', ctypes.c_uint32),
    ('ulLoadLineSlop', ctypes.c_uint32),
    ('ulLeakageTemp', ctypes.c_uint32),
    ('ulLeakageVoltage', ctypes.c_uint32),
    ('sCACm', EFUSE_LINEAR_FUNC_PARAM),
    ('sCACb', EFUSE_LINEAR_FUNC_PARAM),
    ('sKt_b', EFUSE_LOGISTIC_FUNC_PARAM),
    ('sKv_m', EFUSE_LOGISTIC_FUNC_PARAM),
    ('sKv_b', EFUSE_LOGISTIC_FUNC_PARAM),
    ('usLkgEuseIndex', ctypes.c_uint16),
    ('ucLkgEfuseBitLSB', ctypes.c_ubyte),
    ('ucLkgEfuseLength', ctypes.c_ubyte),
    ('ulLkgEncodeLn_MaxDivMin', ctypes.c_uint32),
    ('ulLkgEncodeMax', ctypes.c_uint32),
    ('ulLkgEncodeMin', ctypes.c_uint32),
    ('ulEfuseLogisticAlpha', ctypes.c_uint32),
    ('usPowerDpm0', ctypes.c_uint16),
    ('usPowerDpm1', ctypes.c_uint16),
    ('usPowerDpm2', ctypes.c_uint16),
    ('usPowerDpm3', ctypes.c_uint16),
    ('usPowerDpm4', ctypes.c_uint16),
    ('usPowerDpm5', ctypes.c_uint16),
    ('usPowerDpm6', ctypes.c_uint16),
    ('usPowerDpm7', ctypes.c_uint16),
    ('ulTdpDerateDPM0', ctypes.c_uint32),
    ('ulTdpDerateDPM1', ctypes.c_uint32),
    ('ulTdpDerateDPM2', ctypes.c_uint32),
    ('ulTdpDerateDPM3', ctypes.c_uint32),
    ('ulTdpDerateDPM4', ctypes.c_uint32),
    ('ulTdpDerateDPM5', ctypes.c_uint32),
    ('ulTdpDerateDPM6', ctypes.c_uint32),
    ('ulTdpDerateDPM7', ctypes.c_uint32),
    ('sRoFuse', EFUSE_LINEAR_FUNC_PARAM),
    ('ulEvvDefaultVddc', ctypes.c_uint32),
    ('ulEvvNoCalcVddc', ctypes.c_uint32),
    ('usParamNegFlag', ctypes.c_uint16),
    ('usSpeed_Model', ctypes.c_uint16),
    ('ulSM_A0', ctypes.c_uint32),
    ('ulSM_A1', ctypes.c_uint32),
    ('ulSM_A2', ctypes.c_uint32),
    ('ulSM_A3', ctypes.c_uint32),
    ('ulSM_A4', ctypes.c_uint32),
    ('ulSM_A5', ctypes.c_uint32),
    ('ulSM_A6', ctypes.c_uint32),
    ('ulSM_A7', ctypes.c_uint32),
    ('ucSM_A0_sign', ctypes.c_ubyte),
    ('ucSM_A1_sign', ctypes.c_ubyte),
    ('ucSM_A2_sign', ctypes.c_ubyte),
    ('ucSM_A3_sign', ctypes.c_ubyte),
    ('ucSM_A4_sign', ctypes.c_ubyte),
    ('ucSM_A5_sign', ctypes.c_ubyte),
    ('ucSM_A6_sign', ctypes.c_ubyte),
    ('ucSM_A7_sign', ctypes.c_ubyte),
    ('ulMargin_RO_a', ctypes.c_uint32),
    ('ulMargin_RO_b', ctypes.c_uint32),
    ('ulMargin_RO_c', ctypes.c_uint32),
    ('ulMargin_fixed', ctypes.c_uint32),
    ('ulMargin_Fmax_mean', ctypes.c_uint32),
    ('ulMargin_plat_mean', ctypes.c_uint32),
    ('ulMargin_Fmax_sigma', ctypes.c_uint32),
    ('ulMargin_plat_sigma', ctypes.c_uint32),
    ('ulMargin_DC_sigma', ctypes.c_uint32),
    ('ulReserved', ctypes.c_uint32 * 8),
     ]

class struct__ATOM_ASIC_PROFILING_INFO_V3_5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulMaxVddc', ctypes.c_uint32),
    ('ulMinVddc', ctypes.c_uint32),
    ('usLkgEuseIndex', ctypes.c_uint16),
    ('ucLkgEfuseBitLSB', ctypes.c_ubyte),
    ('ucLkgEfuseLength', ctypes.c_ubyte),
    ('ulLkgEncodeLn_MaxDivMin', ctypes.c_uint32),
    ('ulLkgEncodeMax', ctypes.c_uint32),
    ('ulLkgEncodeMin', ctypes.c_uint32),
    ('sRoFuse', EFUSE_LINEAR_FUNC_PARAM),
    ('ulEvvDefaultVddc', ctypes.c_uint32),
    ('ulEvvNoCalcVddc', ctypes.c_uint32),
    ('ulSpeed_Model', ctypes.c_uint32),
    ('ulSM_A0', ctypes.c_uint32),
    ('ulSM_A1', ctypes.c_uint32),
    ('ulSM_A2', ctypes.c_uint32),
    ('ulSM_A3', ctypes.c_uint32),
    ('ulSM_A4', ctypes.c_uint32),
    ('ulSM_A5', ctypes.c_uint32),
    ('ulSM_A6', ctypes.c_uint32),
    ('ulSM_A7', ctypes.c_uint32),
    ('ucSM_A0_sign', ctypes.c_ubyte),
    ('ucSM_A1_sign', ctypes.c_ubyte),
    ('ucSM_A2_sign', ctypes.c_ubyte),
    ('ucSM_A3_sign', ctypes.c_ubyte),
    ('ucSM_A4_sign', ctypes.c_ubyte),
    ('ucSM_A5_sign', ctypes.c_ubyte),
    ('ucSM_A6_sign', ctypes.c_ubyte),
    ('ucSM_A7_sign', ctypes.c_ubyte),
    ('ulMargin_RO_a', ctypes.c_uint32),
    ('ulMargin_RO_b', ctypes.c_uint32),
    ('ulMargin_RO_c', ctypes.c_uint32),
    ('ulMargin_fixed', ctypes.c_uint32),
    ('ulMargin_Fmax_mean', ctypes.c_uint32),
    ('ulMargin_plat_mean', ctypes.c_uint32),
    ('ulMargin_Fmax_sigma', ctypes.c_uint32),
    ('ulMargin_plat_sigma', ctypes.c_uint32),
    ('ulMargin_DC_sigma', ctypes.c_uint32),
    ('ulReserved', ctypes.c_uint32 * 12),
     ]

class struct__ATOM_ASIC_PROFILING_INFO_V3_6(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulMaxVddc', ctypes.c_uint32),
    ('ulMinVddc', ctypes.c_uint32),
    ('usLkgEuseIndex', ctypes.c_uint16),
    ('ucLkgEfuseBitLSB', ctypes.c_ubyte),
    ('ucLkgEfuseLength', ctypes.c_ubyte),
    ('ulLkgEncodeLn_MaxDivMin', ctypes.c_uint32),
    ('ulLkgEncodeMax', ctypes.c_uint32),
    ('ulLkgEncodeMin', ctypes.c_uint32),
    ('sRoFuse', EFUSE_LINEAR_FUNC_PARAM),
    ('ulEvvDefaultVddc', ctypes.c_uint32),
    ('ulEvvNoCalcVddc', ctypes.c_uint32),
    ('ulSpeed_Model', ctypes.c_uint32),
    ('ulSM_A0', ctypes.c_uint32),
    ('ulSM_A1', ctypes.c_uint32),
    ('ulSM_A2', ctypes.c_uint32),
    ('ulSM_A3', ctypes.c_uint32),
    ('ulSM_A4', ctypes.c_uint32),
    ('ulSM_A5', ctypes.c_uint32),
    ('ulSM_A6', ctypes.c_uint32),
    ('ulSM_A7', ctypes.c_uint32),
    ('ucSM_A0_sign', ctypes.c_ubyte),
    ('ucSM_A1_sign', ctypes.c_ubyte),
    ('ucSM_A2_sign', ctypes.c_ubyte),
    ('ucSM_A3_sign', ctypes.c_ubyte),
    ('ucSM_A4_sign', ctypes.c_ubyte),
    ('ucSM_A5_sign', ctypes.c_ubyte),
    ('ucSM_A6_sign', ctypes.c_ubyte),
    ('ucSM_A7_sign', ctypes.c_ubyte),
    ('ulMargin_RO_a', ctypes.c_uint32),
    ('ulMargin_RO_b', ctypes.c_uint32),
    ('ulMargin_RO_c', ctypes.c_uint32),
    ('ulMargin_fixed', ctypes.c_uint32),
    ('ulMargin_Fmax_mean', ctypes.c_uint32),
    ('ulMargin_plat_mean', ctypes.c_uint32),
    ('ulMargin_Fmax_sigma', ctypes.c_uint32),
    ('ulMargin_plat_sigma', ctypes.c_uint32),
    ('ulMargin_DC_sigma', ctypes.c_uint32),
    ('ulLoadLineSlop', ctypes.c_uint32),
    ('ulaTDClimitPerDPM', ctypes.c_uint32 * 8),
    ('ulaNoCalcVddcPerDPM', ctypes.c_uint32 * 8),
    ('ulAVFS_meanNsigma_Acontant0', ctypes.c_uint32),
    ('ulAVFS_meanNsigma_Acontant1', ctypes.c_uint32),
    ('ulAVFS_meanNsigma_Acontant2', ctypes.c_uint32),
    ('usAVFS_meanNsigma_DC_tol_sigma', ctypes.c_uint16),
    ('usAVFS_meanNsigma_Platform_mean', ctypes.c_uint16),
    ('usAVFS_meanNsigma_Platform_sigma', ctypes.c_uint16),
    ('ulGB_VDROOP_TABLE_CKSOFF_a0', ctypes.c_uint32),
    ('ulGB_VDROOP_TABLE_CKSOFF_a1', ctypes.c_uint32),
    ('ulGB_VDROOP_TABLE_CKSOFF_a2', ctypes.c_uint32),
    ('ulGB_VDROOP_TABLE_CKSON_a0', ctypes.c_uint32),
    ('ulGB_VDROOP_TABLE_CKSON_a1', ctypes.c_uint32),
    ('ulGB_VDROOP_TABLE_CKSON_a2', ctypes.c_uint32),
    ('ulAVFSGB_FUSE_TABLE_CKSOFF_m1', ctypes.c_uint32),
    ('usAVFSGB_FUSE_TABLE_CKSOFF_m2', ctypes.c_uint16),
    ('ulAVFSGB_FUSE_TABLE_CKSOFF_b', ctypes.c_uint32),
    ('ulAVFSGB_FUSE_TABLE_CKSON_m1', ctypes.c_uint32),
    ('usAVFSGB_FUSE_TABLE_CKSON_m2', ctypes.c_uint16),
    ('ulAVFSGB_FUSE_TABLE_CKSON_b', ctypes.c_uint32),
    ('usMaxVoltage_0_25mv', ctypes.c_uint16),
    ('ucEnableGB_VDROOP_TABLE_CKSOFF', ctypes.c_ubyte),
    ('ucEnableGB_VDROOP_TABLE_CKSON', ctypes.c_ubyte),
    ('ucEnableGB_FUSE_TABLE_CKSOFF', ctypes.c_ubyte),
    ('ucEnableGB_FUSE_TABLE_CKSON', ctypes.c_ubyte),
    ('usPSM_Age_ComFactor', ctypes.c_uint16),
    ('ucEnableApplyAVFS_CKS_OFF_Voltage', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ATOM_SCLK_FCW_RANGE_ENTRY_V1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulMaxSclkFreq', ctypes.c_uint32),
    ('ucVco_setting', ctypes.c_ubyte),
    ('ucPostdiv', ctypes.c_ubyte),
    ('ucFcw_pcc', ctypes.c_uint16),
    ('ucFcw_trans_upper', ctypes.c_uint16),
    ('ucRcw_trans_lower', ctypes.c_uint16),
     ]

class struct__ATOM_SMU_INFO_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucSclkEntryNum', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('asSclkFcwRangeEntry', struct__ATOM_SCLK_FCW_RANGE_ENTRY_V1 * 8),
     ]

class struct__ATOM_GFX_INFO_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('GfxIpMinVer', ctypes.c_ubyte),
    ('GfxIpMajVer', ctypes.c_ubyte),
    ('max_shader_engines', ctypes.c_ubyte),
    ('max_tile_pipes', ctypes.c_ubyte),
    ('max_cu_per_sh', ctypes.c_ubyte),
    ('max_sh_per_se', ctypes.c_ubyte),
    ('max_backends_per_se', ctypes.c_ubyte),
    ('max_texture_channel_caches', ctypes.c_ubyte),
     ]

class struct__ATOM_POWER_SOURCE_OBJECT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucPwrSrcId', ctypes.c_ubyte),
    ('ucPwrSensorType', ctypes.c_ubyte),
    ('ucPwrSensId', ctypes.c_ubyte),
    ('ucPwrSensSlaveAddr', ctypes.c_ubyte),
    ('ucPwrSensRegIndex', ctypes.c_ubyte),
    ('ucPwrSensRegBitMask', ctypes.c_ubyte),
    ('ucPwrSensActiveState', ctypes.c_ubyte),
    ('ucReserve', ctypes.c_ubyte * 3),
    ('usSensPwr', ctypes.c_uint16),
     ]

class struct__ATOM_POWER_SOURCE_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('asPwrbehave', ctypes.c_ubyte * 16),
    ('asPwrObj', struct__ATOM_POWER_SOURCE_OBJECT * 1),
     ]

class struct__ATOM_CLK_VOLT_CAPABILITY(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulVoltageIndex', ctypes.c_uint32),
    ('ulMaximumSupportedCLK', ctypes.c_uint32),
     ]

class struct__ATOM_CLK_VOLT_CAPABILITY_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usVoltageLevel', ctypes.c_uint16),
    ('ulMaximumSupportedCLK', ctypes.c_uint32),
     ]

class struct__ATOM_AVAILABLE_SCLK_LIST(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulSupportedSCLK', ctypes.c_uint32),
    ('usVoltageIndex', ctypes.c_uint16),
    ('usVoltageID', ctypes.c_uint16),
     ]

class struct__ATOM_INTEGRATED_SYSTEM_INFO_V6(ctypes.Structure):
    pass

ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO = struct__ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO
struct__ATOM_INTEGRATED_SYSTEM_INFO_V6._pack_ = True # source:False
struct__ATOM_INTEGRATED_SYSTEM_INFO_V6._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulBootUpEngineClock', ctypes.c_uint32),
    ('ulDentistVCOFreq', ctypes.c_uint32),
    ('ulBootUpUMAClock', ctypes.c_uint32),
    ('sDISPCLK_Voltage', struct__ATOM_CLK_VOLT_CAPABILITY * 4),
    ('ulBootUpReqDisplayVector', ctypes.c_uint32),
    ('ulOtherDisplayMisc', ctypes.c_uint32),
    ('ulGPUCapInfo', ctypes.c_uint32),
    ('ulSB_MMIO_Base_Addr', ctypes.c_uint32),
    ('usRequestedPWMFreqInHz', ctypes.c_uint16),
    ('ucHtcTmpLmt', ctypes.c_ubyte),
    ('ucHtcHystLmt', ctypes.c_ubyte),
    ('ulMinEngineClock', ctypes.c_uint32),
    ('ulSystemConfig', ctypes.c_uint32),
    ('ulCPUCapInfo', ctypes.c_uint32),
    ('usNBP0Voltage', ctypes.c_uint16),
    ('usNBP1Voltage', ctypes.c_uint16),
    ('usBootUpNBVoltage', ctypes.c_uint16),
    ('usExtDispConnInfoOffset', ctypes.c_uint16),
    ('usPanelRefreshRateRange', ctypes.c_uint16),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucUMAChannelNumber', ctypes.c_ubyte),
    ('ulCSR_M3_ARB_CNTL_DEFAULT', ctypes.c_uint32 * 10),
    ('ulCSR_M3_ARB_CNTL_UVD', ctypes.c_uint32 * 10),
    ('ulCSR_M3_ARB_CNTL_FS3D', ctypes.c_uint32 * 10),
    ('sAvail_SCLK', struct__ATOM_AVAILABLE_SCLK_LIST * 5),
    ('ulGMCRestoreResetTime', ctypes.c_uint32),
    ('ulMinimumNClk', ctypes.c_uint32),
    ('ulIdleNClk', ctypes.c_uint32),
    ('ulDDR_DLL_PowerUpTime', ctypes.c_uint32),
    ('ulDDR_PLL_PowerUpTime', ctypes.c_uint32),
    ('usPCIEClkSSPercentage', ctypes.c_uint16),
    ('usPCIEClkSSType', ctypes.c_uint16),
    ('usLvdsSSPercentage', ctypes.c_uint16),
    ('usLvdsSSpreadRateIn10Hz', ctypes.c_uint16),
    ('usHDMISSPercentage', ctypes.c_uint16),
    ('usHDMISSpreadRateIn10Hz', ctypes.c_uint16),
    ('usDVISSPercentage', ctypes.c_uint16),
    ('usDVISSpreadRateIn10Hz', ctypes.c_uint16),
    ('SclkDpmBoostMargin', ctypes.c_uint32),
    ('SclkDpmThrottleMargin', ctypes.c_uint32),
    ('SclkDpmTdpLimitPG', ctypes.c_uint16),
    ('SclkDpmTdpLimitBoost', ctypes.c_uint16),
    ('ulBoostEngineCLock', ctypes.c_uint32),
    ('ulBoostVid_2bit', ctypes.c_ubyte),
    ('EnableBoost', ctypes.c_ubyte),
    ('GnbTdpLimit', ctypes.c_uint16),
    ('usMaxLVDSPclkFreqInSingleLink', ctypes.c_uint16),
    ('ucLvdsMisc', ctypes.c_ubyte),
    ('ucLVDSReserved', ctypes.c_ubyte),
    ('ulReserved3', ctypes.c_uint32 * 15),
    ('sExtDispConnInfo', ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO),
]

class struct__ATOM_FUSION_SYSTEM_INFO_V1(ctypes.Structure):
    pass

ATOM_INTEGRATED_SYSTEM_INFO_V6 = struct__ATOM_INTEGRATED_SYSTEM_INFO_V6
struct__ATOM_FUSION_SYSTEM_INFO_V1._pack_ = True # source:False
struct__ATOM_FUSION_SYSTEM_INFO_V1._fields_ = [
    ('sIntegratedSysInfo', ATOM_INTEGRATED_SYSTEM_INFO_V6),
    ('ulPowerplayTable', ctypes.c_uint32 * 128),
]

class struct__ATOM_TDP_CONFIG_BITS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('uCTDP_Enable', ctypes.c_uint32, 2),
    ('uCTDP_Value', ctypes.c_uint32, 14),
    ('uTDP_Value', ctypes.c_uint32, 14),
    ('uReserved', ctypes.c_uint32, 2),
     ]

class struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_7(ctypes.Structure):
    pass

class union__ATOM_TDP_CONFIG(ctypes.Union):
    pass

ATOM_TDP_CONFIG_BITS = struct__ATOM_TDP_CONFIG_BITS
union__ATOM_TDP_CONFIG._pack_ = True # source:False
union__ATOM_TDP_CONFIG._fields_ = [
    ('TDP_config', ATOM_TDP_CONFIG_BITS),
    ('TDP_config_all', ctypes.c_uint32),
]

ATOM_TDP_CONFIG = union__ATOM_TDP_CONFIG
struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_7._pack_ = True # source:False
struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_7._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulBootUpEngineClock', ctypes.c_uint32),
    ('ulDentistVCOFreq', ctypes.c_uint32),
    ('ulBootUpUMAClock', ctypes.c_uint32),
    ('sDISPCLK_Voltage', struct__ATOM_CLK_VOLT_CAPABILITY * 4),
    ('ulBootUpReqDisplayVector', ctypes.c_uint32),
    ('ulOtherDisplayMisc', ctypes.c_uint32),
    ('ulGPUCapInfo', ctypes.c_uint32),
    ('ulSB_MMIO_Base_Addr', ctypes.c_uint32),
    ('usRequestedPWMFreqInHz', ctypes.c_uint16),
    ('ucHtcTmpLmt', ctypes.c_ubyte),
    ('ucHtcHystLmt', ctypes.c_ubyte),
    ('ulMinEngineClock', ctypes.c_uint32),
    ('ulSystemConfig', ctypes.c_uint32),
    ('ulCPUCapInfo', ctypes.c_uint32),
    ('usNBP0Voltage', ctypes.c_uint16),
    ('usNBP1Voltage', ctypes.c_uint16),
    ('usBootUpNBVoltage', ctypes.c_uint16),
    ('usExtDispConnInfoOffset', ctypes.c_uint16),
    ('usPanelRefreshRateRange', ctypes.c_uint16),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucUMAChannelNumber', ctypes.c_ubyte),
    ('strVBIOSMsg', ctypes.c_ubyte * 40),
    ('asTdpConfig', ATOM_TDP_CONFIG),
    ('ulReserved', ctypes.c_uint32 * 19),
    ('sAvail_SCLK', struct__ATOM_AVAILABLE_SCLK_LIST * 5),
    ('ulGMCRestoreResetTime', ctypes.c_uint32),
    ('ulMinimumNClk', ctypes.c_uint32),
    ('ulIdleNClk', ctypes.c_uint32),
    ('ulDDR_DLL_PowerUpTime', ctypes.c_uint32),
    ('ulDDR_PLL_PowerUpTime', ctypes.c_uint32),
    ('usPCIEClkSSPercentage', ctypes.c_uint16),
    ('usPCIEClkSSType', ctypes.c_uint16),
    ('usLvdsSSPercentage', ctypes.c_uint16),
    ('usLvdsSSpreadRateIn10Hz', ctypes.c_uint16),
    ('usHDMISSPercentage', ctypes.c_uint16),
    ('usHDMISSpreadRateIn10Hz', ctypes.c_uint16),
    ('usDVISSPercentage', ctypes.c_uint16),
    ('usDVISSpreadRateIn10Hz', ctypes.c_uint16),
    ('SclkDpmBoostMargin', ctypes.c_uint32),
    ('SclkDpmThrottleMargin', ctypes.c_uint32),
    ('SclkDpmTdpLimitPG', ctypes.c_uint16),
    ('SclkDpmTdpLimitBoost', ctypes.c_uint16),
    ('ulBoostEngineCLock', ctypes.c_uint32),
    ('ulBoostVid_2bit', ctypes.c_ubyte),
    ('EnableBoost', ctypes.c_ubyte),
    ('GnbTdpLimit', ctypes.c_uint16),
    ('usMaxLVDSPclkFreqInSingleLink', ctypes.c_uint16),
    ('ucLvdsMisc', ctypes.c_ubyte),
    ('ucTravisLVDSVolAdjust', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqDIGONtoDE_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqDEtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqVARY_BLtoDE_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqDEtoDIGON_in4Ms', ctypes.c_ubyte),
    ('ucLVDSOffToOnDelay_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqVARY_BLtoBLON_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqBLONtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucMinAllowedBL_Level', ctypes.c_ubyte),
    ('ulLCDBitDepthControlVal', ctypes.c_uint32),
    ('ulNbpStateMemclkFreq', ctypes.c_uint32 * 4),
    ('usNBP2Voltage', ctypes.c_uint16),
    ('usNBP3Voltage', ctypes.c_uint16),
    ('ulNbpStateNClkFreq', ctypes.c_uint32 * 4),
    ('ucNBDPMEnable', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('ucDPMState0VclkFid', ctypes.c_ubyte),
    ('ucDPMState0DclkFid', ctypes.c_ubyte),
    ('ucDPMState1VclkFid', ctypes.c_ubyte),
    ('ucDPMState1DclkFid', ctypes.c_ubyte),
    ('ucDPMState2VclkFid', ctypes.c_ubyte),
    ('ucDPMState2DclkFid', ctypes.c_ubyte),
    ('ucDPMState3VclkFid', ctypes.c_ubyte),
    ('ucDPMState3DclkFid', ctypes.c_ubyte),
    ('sExtDispConnInfo', ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO),
]

class struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_8(ctypes.Structure):
    pass

ATOM_CLK_VOLT_CAPABILITY = struct__ATOM_CLK_VOLT_CAPABILITY
struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_8._pack_ = True # source:False
struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_8._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulBootUpEngineClock', ctypes.c_uint32),
    ('ulDentistVCOFreq', ctypes.c_uint32),
    ('ulBootUpUMAClock', ctypes.c_uint32),
    ('sDISPCLK_Voltage', struct__ATOM_CLK_VOLT_CAPABILITY * 4),
    ('ulBootUpReqDisplayVector', ctypes.c_uint32),
    ('ulVBIOSMisc', ctypes.c_uint32),
    ('ulGPUCapInfo', ctypes.c_uint32),
    ('ulDISP_CLK2Freq', ctypes.c_uint32),
    ('usRequestedPWMFreqInHz', ctypes.c_uint16),
    ('ucHtcTmpLmt', ctypes.c_ubyte),
    ('ucHtcHystLmt', ctypes.c_ubyte),
    ('ulReserved2', ctypes.c_uint32),
    ('ulSystemConfig', ctypes.c_uint32),
    ('ulCPUCapInfo', ctypes.c_uint32),
    ('ulReserved3', ctypes.c_uint32),
    ('usGPUReservedSysMemSize', ctypes.c_uint16),
    ('usExtDispConnInfoOffset', ctypes.c_uint16),
    ('usPanelRefreshRateRange', ctypes.c_uint16),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucUMAChannelNumber', ctypes.c_ubyte),
    ('strVBIOSMsg', ctypes.c_ubyte * 40),
    ('asTdpConfig', ATOM_TDP_CONFIG),
    ('ulReserved', ctypes.c_uint32 * 19),
    ('sAvail_SCLK', struct__ATOM_AVAILABLE_SCLK_LIST * 5),
    ('ulGMCRestoreResetTime', ctypes.c_uint32),
    ('ulReserved4', ctypes.c_uint32),
    ('ulIdleNClk', ctypes.c_uint32),
    ('ulDDR_DLL_PowerUpTime', ctypes.c_uint32),
    ('ulDDR_PLL_PowerUpTime', ctypes.c_uint32),
    ('usPCIEClkSSPercentage', ctypes.c_uint16),
    ('usPCIEClkSSType', ctypes.c_uint16),
    ('usLvdsSSPercentage', ctypes.c_uint16),
    ('usLvdsSSpreadRateIn10Hz', ctypes.c_uint16),
    ('usHDMISSPercentage', ctypes.c_uint16),
    ('usHDMISSpreadRateIn10Hz', ctypes.c_uint16),
    ('usDVISSPercentage', ctypes.c_uint16),
    ('usDVISSpreadRateIn10Hz', ctypes.c_uint16),
    ('ulGPUReservedSysMemBaseAddrLo', ctypes.c_uint32),
    ('ulGPUReservedSysMemBaseAddrHi', ctypes.c_uint32),
    ('s5thDISPCLK_Voltage', ATOM_CLK_VOLT_CAPABILITY),
    ('ulReserved5', ctypes.c_uint32),
    ('usMaxLVDSPclkFreqInSingleLink', ctypes.c_uint16),
    ('ucLvdsMisc', ctypes.c_ubyte),
    ('ucTravisLVDSVolAdjust', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqDIGONtoDE_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqDEtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqVARY_BLtoDE_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqDEtoDIGON_in4Ms', ctypes.c_ubyte),
    ('ucLVDSOffToOnDelay_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqVARY_BLtoBLON_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqBLONtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucMinAllowedBL_Level', ctypes.c_ubyte),
    ('ulLCDBitDepthControlVal', ctypes.c_uint32),
    ('ulNbpStateMemclkFreq', ctypes.c_uint32 * 4),
    ('ulPSPVersion', ctypes.c_uint32),
    ('ulNbpStateNClkFreq', ctypes.c_uint32 * 4),
    ('usNBPStateVoltage', ctypes.c_uint16 * 4),
    ('usBootUpNBVoltage', ctypes.c_uint16),
    ('usReserved2', ctypes.c_uint16),
    ('sExtDispConnInfo', ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO),
]

class struct__ATOM_I2C_REG_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucI2cRegIndex', ctypes.c_ubyte),
    ('ucI2cRegVal', ctypes.c_ubyte),
     ]

class struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_9(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulBootUpEngineClock', ctypes.c_uint32),
    ('ulDentistVCOFreq', ctypes.c_uint32),
    ('ulBootUpUMAClock', ctypes.c_uint32),
    ('sDISPCLK_Voltage', struct__ATOM_CLK_VOLT_CAPABILITY * 4),
    ('ulBootUpReqDisplayVector', ctypes.c_uint32),
    ('ulVBIOSMisc', ctypes.c_uint32),
    ('ulGPUCapInfo', ctypes.c_uint32),
    ('ulDISP_CLK2Freq', ctypes.c_uint32),
    ('usRequestedPWMFreqInHz', ctypes.c_uint16),
    ('ucHtcTmpLmt', ctypes.c_ubyte),
    ('ucHtcHystLmt', ctypes.c_ubyte),
    ('ulReserved2', ctypes.c_uint32),
    ('ulSystemConfig', ctypes.c_uint32),
    ('ulCPUCapInfo', ctypes.c_uint32),
    ('ulReserved3', ctypes.c_uint32),
    ('usGPUReservedSysMemSize', ctypes.c_uint16),
    ('usExtDispConnInfoOffset', ctypes.c_uint16),
    ('usPanelRefreshRateRange', ctypes.c_uint16),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucUMAChannelNumber', ctypes.c_ubyte),
    ('strVBIOSMsg', ctypes.c_ubyte * 40),
    ('asTdpConfig', ATOM_TDP_CONFIG),
    ('ucExtHDMIReDrvSlvAddr', ctypes.c_ubyte),
    ('ucExtHDMIReDrvRegNum', ctypes.c_ubyte),
    ('asExtHDMIRegSetting', struct__ATOM_I2C_REG_INFO * 9),
    ('ulReserved', ctypes.c_uint32 * 2),
    ('sDispClkVoltageMapping', struct__ATOM_CLK_VOLT_CAPABILITY_V2 * 8),
    ('sAvail_SCLK', struct__ATOM_AVAILABLE_SCLK_LIST * 5),
    ('ulGMCRestoreResetTime', ctypes.c_uint32),
    ('ulReserved4', ctypes.c_uint32),
    ('ulIdleNClk', ctypes.c_uint32),
    ('ulDDR_DLL_PowerUpTime', ctypes.c_uint32),
    ('ulDDR_PLL_PowerUpTime', ctypes.c_uint32),
    ('usPCIEClkSSPercentage', ctypes.c_uint16),
    ('usPCIEClkSSType', ctypes.c_uint16),
    ('usLvdsSSPercentage', ctypes.c_uint16),
    ('usLvdsSSpreadRateIn10Hz', ctypes.c_uint16),
    ('usHDMISSPercentage', ctypes.c_uint16),
    ('usHDMISSpreadRateIn10Hz', ctypes.c_uint16),
    ('usDVISSPercentage', ctypes.c_uint16),
    ('usDVISSpreadRateIn10Hz', ctypes.c_uint16),
    ('ulGPUReservedSysMemBaseAddrLo', ctypes.c_uint32),
    ('ulGPUReservedSysMemBaseAddrHi', ctypes.c_uint32),
    ('ulReserved5', ctypes.c_uint32 * 3),
    ('usMaxLVDSPclkFreqInSingleLink', ctypes.c_uint16),
    ('ucLvdsMisc', ctypes.c_ubyte),
    ('ucTravisLVDSVolAdjust', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqDIGONtoDE_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqDEtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqVARY_BLtoDE_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqDEtoDIGON_in4Ms', ctypes.c_ubyte),
    ('ucLVDSOffToOnDelay_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqVARY_BLtoBLON_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqBLONtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucMinAllowedBL_Level', ctypes.c_ubyte),
    ('ulLCDBitDepthControlVal', ctypes.c_uint32),
    ('ulNbpStateMemclkFreq', ctypes.c_uint32 * 4),
    ('ulPSPVersion', ctypes.c_uint32),
    ('ulNbpStateNClkFreq', ctypes.c_uint32 * 4),
    ('usNBPStateVoltage', ctypes.c_uint16 * 4),
    ('usBootUpNBVoltage', ctypes.c_uint16),
    ('ucEDPv1_4VSMode', ctypes.c_ubyte),
    ('ucReserved2', ctypes.c_ubyte),
    ('sExtDispConnInfo', ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO),
     ]

class struct__DPHY_TIMING_PARA(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucProfileID', ctypes.c_ubyte),
    ('ucPara', ctypes.c_uint32),
     ]

class struct__DPHY_ELEC_PARA(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usPara', ctypes.c_uint16 * 3),
     ]

class struct__CAMERA_MODULE_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucID', ctypes.c_ubyte),
    ('strModuleName', ctypes.c_ubyte * 8),
    ('asTimingPara', struct__DPHY_TIMING_PARA * 6),
     ]

class struct__FLASHLIGHT_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucID', ctypes.c_ubyte),
    ('strName', ctypes.c_ubyte * 8),
     ]

class struct__CAMERA_DATA(ctypes.Structure):
    pass

DPHY_ELEC_PARA = struct__DPHY_ELEC_PARA
FLASHLIGHT_INFO = struct__FLASHLIGHT_INFO
struct__CAMERA_DATA._pack_ = True # source:False
struct__CAMERA_DATA._fields_ = [
    ('ulVersionCode', ctypes.c_uint32),
    ('asCameraInfo', struct__CAMERA_MODULE_INFO * 3),
    ('asFlashInfo', FLASHLIGHT_INFO),
    ('asDphyElecPara', DPHY_ELEC_PARA),
    ('ulCrcVal', ctypes.c_uint32),
]

class struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_10(ctypes.Structure):
    pass

CAMERA_DATA = struct__CAMERA_DATA
struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_10._pack_ = True # source:False
struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_10._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulBootUpEngineClock', ctypes.c_uint32),
    ('ulDentistVCOFreq', ctypes.c_uint32),
    ('ulBootUpUMAClock', ctypes.c_uint32),
    ('ulReserved0', ctypes.c_uint32 * 8),
    ('ulBootUpReqDisplayVector', ctypes.c_uint32),
    ('ulVBIOSMisc', ctypes.c_uint32),
    ('ulGPUCapInfo', ctypes.c_uint32),
    ('ulReserved1', ctypes.c_uint32),
    ('usRequestedPWMFreqInHz', ctypes.c_uint16),
    ('ucHtcTmpLmt', ctypes.c_ubyte),
    ('ucHtcHystLmt', ctypes.c_ubyte),
    ('ulReserved2', ctypes.c_uint32),
    ('ulSystemConfig', ctypes.c_uint32),
    ('ulCPUCapInfo', ctypes.c_uint32),
    ('ulReserved3', ctypes.c_uint32),
    ('usGPUReservedSysMemSize', ctypes.c_uint16),
    ('usExtDispConnInfoOffset', ctypes.c_uint16),
    ('usPanelRefreshRateRange', ctypes.c_uint16),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucUMAChannelNumber', ctypes.c_ubyte),
    ('ulMsgReserved', ctypes.c_uint32 * 10),
    ('asTdpConfig', ATOM_TDP_CONFIG),
    ('ulReserved', ctypes.c_uint32 * 7),
    ('sDispClkVoltageMapping', struct__ATOM_CLK_VOLT_CAPABILITY_V2 * 8),
    ('ulReserved6', ctypes.c_uint32 * 10),
    ('ulGMCRestoreResetTime', ctypes.c_uint32),
    ('ulReserved4', ctypes.c_uint32),
    ('ulIdleNClk', ctypes.c_uint32),
    ('ulDDR_DLL_PowerUpTime', ctypes.c_uint32),
    ('ulDDR_PLL_PowerUpTime', ctypes.c_uint32),
    ('usPCIEClkSSPercentage', ctypes.c_uint16),
    ('usPCIEClkSSType', ctypes.c_uint16),
    ('usLvdsSSPercentage', ctypes.c_uint16),
    ('usLvdsSSpreadRateIn10Hz', ctypes.c_uint16),
    ('usHDMISSPercentage', ctypes.c_uint16),
    ('usHDMISSpreadRateIn10Hz', ctypes.c_uint16),
    ('usDVISSPercentage', ctypes.c_uint16),
    ('usDVISSpreadRateIn10Hz', ctypes.c_uint16),
    ('ulGPUReservedSysMemBaseAddrLo', ctypes.c_uint32),
    ('ulGPUReservedSysMemBaseAddrHi', ctypes.c_uint32),
    ('ulReserved5', ctypes.c_uint32 * 3),
    ('usMaxLVDSPclkFreqInSingleLink', ctypes.c_uint16),
    ('ucLvdsMisc', ctypes.c_ubyte),
    ('ucTravisLVDSVolAdjust', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqDIGONtoDE_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqDEtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqVARY_BLtoDE_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqDEtoDIGON_in4Ms', ctypes.c_ubyte),
    ('ucLVDSOffToOnDelay_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOnSeqVARY_BLtoBLON_in4Ms', ctypes.c_ubyte),
    ('ucLVDSPwrOffSeqBLONtoVARY_BL_in4Ms', ctypes.c_ubyte),
    ('ucMinAllowedBL_Level', ctypes.c_ubyte),
    ('ulLCDBitDepthControlVal', ctypes.c_uint32),
    ('ulNbpStateMemclkFreq', ctypes.c_uint32 * 2),
    ('ulReserved7', ctypes.c_uint32 * 2),
    ('ulPSPVersion', ctypes.c_uint32),
    ('ulNbpStateNClkFreq', ctypes.c_uint32 * 4),
    ('usNBPStateVoltage', ctypes.c_uint16 * 4),
    ('usBootUpNBVoltage', ctypes.c_uint16),
    ('ucEDPv1_4VSMode', ctypes.c_ubyte),
    ('ucReserved2', ctypes.c_ubyte),
    ('sExtDispConnInfo', ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO),
    ('asCameraInfo', CAMERA_DATA),
    ('ulReserved8', ctypes.c_uint32 * 29),
]

class struct__ATOM_FUSION_SYSTEM_INFO_V2(ctypes.Structure):
    pass

ATOM_INTEGRATED_SYSTEM_INFO_V1_8 = struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_8
struct__ATOM_FUSION_SYSTEM_INFO_V2._pack_ = True # source:False
struct__ATOM_FUSION_SYSTEM_INFO_V2._fields_ = [
    ('sIntegratedSysInfo', ATOM_INTEGRATED_SYSTEM_INFO_V1_8),
    ('ulPowerplayTable', ctypes.c_uint32 * 128),
]

class struct__ATOM_FUSION_SYSTEM_INFO_V3(ctypes.Structure):
    pass

ATOM_INTEGRATED_SYSTEM_INFO_V1_10 = struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_10
struct__ATOM_FUSION_SYSTEM_INFO_V3._pack_ = True # source:False
struct__ATOM_FUSION_SYSTEM_INFO_V3._fields_ = [
    ('sIntegratedSysInfo', ATOM_INTEGRATED_SYSTEM_INFO_V1_10),
    ('ulPowerplayTable', ctypes.c_uint32 * 192),
]

class struct__ATOM_I2C_DATA_RECORD(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucNunberOfBytes', ctypes.c_ubyte),
    ('ucI2CData', ctypes.c_ubyte * 1),
     ]

class struct__ATOM_I2C_DEVICE_SETUP_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sucI2cId', ATOM_I2C_ID_CONFIG_ACCESS),
    ('ucSSChipID', ctypes.c_ubyte),
    ('ucSSChipSlaveAddr', ctypes.c_ubyte),
    ('ucNumOfI2CDataRecords', ctypes.c_ubyte),
    ('asI2CData', struct__ATOM_I2C_DATA_RECORD * 1),
     ]

class struct__ATOM_ASIC_MVDD_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asI2CSetup', struct__ATOM_I2C_DEVICE_SETUP_INFO * 1),
     ]

class struct__ATOM_ASIC_SS_ASSIGNMENT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulTargetClockRange', ctypes.c_uint32),
    ('usSpreadSpectrumPercentage', ctypes.c_uint16),
    ('usSpreadRateInKhz', ctypes.c_uint16),
    ('ucClockIndication', ctypes.c_ubyte),
    ('ucSpreadSpectrumMode', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_ASIC_SS_ASSIGNMENT_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulTargetClockRange', ctypes.c_uint32),
    ('usSpreadSpectrumPercentage', ctypes.c_uint16),
    ('usSpreadRateIn10Hz', ctypes.c_uint16),
    ('ucClockIndication', ctypes.c_ubyte),
    ('ucSpreadSpectrumMode', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_ASIC_INTERNAL_SS_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asSpreadSpectrum', struct__ATOM_ASIC_SS_ASSIGNMENT * 4),
     ]

class struct__ATOM_ASIC_INTERNAL_SS_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asSpreadSpectrum', struct__ATOM_ASIC_SS_ASSIGNMENT_V2 * 1),
     ]

class struct__ATOM_ASIC_SS_ASSIGNMENT_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulTargetClockRange', ctypes.c_uint32),
    ('usSpreadSpectrumPercentage', ctypes.c_uint16),
    ('usSpreadRateIn10Hz', ctypes.c_uint16),
    ('ucClockIndication', ctypes.c_ubyte),
    ('ucSpreadSpectrumMode', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_ASIC_INTERNAL_SS_INFO_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asSpreadSpectrum', struct__ATOM_ASIC_SS_ASSIGNMENT_V3 * 1),
     ]

class struct__MEMORY_PLLINIT_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulTargetMemoryClock', ctypes.c_uint32),
    ('ucAction', ctypes.c_ubyte),
    ('ucFbDiv_Hi', ctypes.c_ubyte),
    ('ucFbDiv', ctypes.c_ubyte),
    ('ucPostDiv', ctypes.c_ubyte),
     ]

class struct__GPIO_PIN_CONTROL_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucGPIO_ID', ctypes.c_ubyte),
    ('ucGPIOBitShift', ctypes.c_ubyte),
    ('ucGPIOBitVal', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
     ]

class struct__ENABLE_SCALER_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucScaler', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('ucTVStandard', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 1),
     ]

class struct__ENABLE_HARDWARE_ICON_CURSOR_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usHWIconHorzVertPosn', ctypes.c_uint32),
    ('ucHWIconVertOffset', ctypes.c_ubyte),
    ('ucHWIconHorzOffset', ctypes.c_ubyte),
    ('ucSelection', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
     ]

class struct__ENABLE_HARDWARE_ICON_CURSOR_PS_ALLOCATION(ctypes.Structure):
    pass

ENABLE_HARDWARE_ICON_CURSOR_PARAMETERS = struct__ENABLE_HARDWARE_ICON_CURSOR_PARAMETERS
ENABLE_CRTC_PARAMETERS = struct__ENABLE_CRTC_PARAMETERS
struct__ENABLE_HARDWARE_ICON_CURSOR_PS_ALLOCATION._pack_ = True # source:False
struct__ENABLE_HARDWARE_ICON_CURSOR_PS_ALLOCATION._fields_ = [
    ('sEnableIcon', ENABLE_HARDWARE_ICON_CURSOR_PARAMETERS),
    ('sReserved', ENABLE_CRTC_PARAMETERS),
]

class struct__ENABLE_GRAPH_SURFACE_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usHight', ctypes.c_uint16),
    ('usWidth', ctypes.c_uint16),
    ('ucSurface', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 3),
     ]

class struct__ENABLE_GRAPH_SURFACE_PARAMETERS_V1_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usHight', ctypes.c_uint16),
    ('usWidth', ctypes.c_uint16),
    ('ucSurface', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
     ]

class struct__ENABLE_GRAPH_SURFACE_PARAMETERS_V1_3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usHight', ctypes.c_uint16),
    ('usWidth', ctypes.c_uint16),
    ('ucSurface', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('usDeviceId', ctypes.c_uint16),
     ]

class struct__ENABLE_GRAPH_SURFACE_PARAMETERS_V1_4(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usHight', ctypes.c_uint16),
    ('usWidth', ctypes.c_uint16),
    ('usGraphPitch', ctypes.c_uint16),
    ('ucColorDepth', ctypes.c_ubyte),
    ('ucPixelFormat', ctypes.c_ubyte),
    ('ucSurface', ctypes.c_ubyte),
    ('ucEnable', ctypes.c_ubyte),
    ('ucModeType', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ENABLE_GRAPH_SURFACE_PS_ALLOCATION(ctypes.Structure):
    pass

ENABLE_GRAPH_SURFACE_PARAMETERS = struct__ENABLE_GRAPH_SURFACE_PARAMETERS
ENABLE_YUV_PARAMETERS = struct__ENABLE_YUV_PARAMETERS
struct__ENABLE_GRAPH_SURFACE_PS_ALLOCATION._pack_ = True # source:False
struct__ENABLE_GRAPH_SURFACE_PS_ALLOCATION._fields_ = [
    ('sSetSurface', ENABLE_GRAPH_SURFACE_PARAMETERS),
    ('sReserved', ENABLE_YUV_PARAMETERS),
]

class struct__MEMORY_CLEAN_UP_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usMemoryStart', ctypes.c_uint16),
    ('usMemorySize', ctypes.c_uint16),
     ]

class struct__GET_DISPLAY_SURFACE_SIZE_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usX_Size', ctypes.c_uint16),
    ('usY_Size', ctypes.c_uint16),
     ]

class struct__GET_DISPLAY_SURFACE_SIZE_PARAMETERS_V2(ctypes.Structure):
    pass

class union__GET_DISPLAY_SURFACE_SIZE_PARAMETERS_V2_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usX_Size', ctypes.c_uint16),
    ('usSurface', ctypes.c_uint16),
     ]

struct__GET_DISPLAY_SURFACE_SIZE_PARAMETERS_V2._pack_ = True # source:False
struct__GET_DISPLAY_SURFACE_SIZE_PARAMETERS_V2._fields_ = [
    ('_0', union__GET_DISPLAY_SURFACE_SIZE_PARAMETERS_V2_0),
    ('usY_Size', ctypes.c_uint16),
    ('usDispXStart', ctypes.c_uint16),
    ('usDispYStart', ctypes.c_uint16),
]

class struct__PALETTE_DATA_CONTROL_PARAMETERS_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucLutId', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('usLutStartIndex', ctypes.c_uint16),
    ('usLutLength', ctypes.c_uint16),
    ('usLutOffsetInVram', ctypes.c_uint16),
     ]

class struct__INTERRUPT_SERVICE_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucInterruptId', ctypes.c_ubyte),
    ('ucServiceId', ctypes.c_ubyte),
    ('ucStatus', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__EFUSE_INPUT_PARAMETER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usEfuseIndex', ctypes.c_uint16),
    ('ucBitShift', ctypes.c_ubyte),
    ('ucBitLength', ctypes.c_ubyte),
     ]

class struct__INDIRECT_IO_ACCESS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('IOAccessSequence', ctypes.c_ubyte * 256),
     ]

class struct__ATOM_OEM_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('sucI2cId', ATOM_I2C_ID_CONFIG_ACCESS),
     ]

class struct__ATOM_TV_MODE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVMode_Num', ctypes.c_ubyte),
    ('ucTV_Mode_Num', ctypes.c_ubyte),
     ]

class struct__ATOM_BIOS_INT_TVSTD_MODE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usTV_Mode_LUT_Offset', ctypes.c_uint16),
    ('usTV_FIFO_Offset', ctypes.c_uint16),
    ('usNTSC_Tbl_Offset', ctypes.c_uint16),
    ('usPAL_Tbl_Offset', ctypes.c_uint16),
    ('usCV_Tbl_Offset', ctypes.c_uint16),
     ]

class struct__ATOM_TV_MODE_SCALER_PTR(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucFilter0_Offset', ctypes.c_uint16),
    ('usFilter1_Offset', ctypes.c_uint16),
    ('ucTV_Mode_Num', ctypes.c_ubyte),
     ]

class struct__ATOM_STANDARD_VESA_TIMING(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('aModeTimings', struct__ATOM_DTD_FORMAT * 16),
     ]

class struct__ATOM_STD_FORMAT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usSTD_HDisp', ctypes.c_uint16),
    ('usSTD_VDisp', ctypes.c_uint16),
    ('usSTD_RefreshRate', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
     ]

class struct__ATOM_VESA_TO_EXTENDED_MODE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usVESA_ModeNumber', ctypes.c_uint16),
    ('usExtendedModeNumber', ctypes.c_uint16),
     ]

class struct__ATOM_VESA_TO_INTENAL_MODE_LUT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asVESA_ToExtendedModeInfo', struct__ATOM_VESA_TO_EXTENDED_MODE * 76),
     ]

class struct__ATOM_MEMORY_VENDOR_BLOCK(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucMemoryVendor', ctypes.c_ubyte),
    ('ucAdjMCId', ctypes.c_ubyte),
    ('ucDynClkId', ctypes.c_ubyte),
    ('ulDllResetClkRange', ctypes.c_uint32),
     ]

class struct__ATOM_MEMORY_SETTING_ID_CONFIG(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulMemClockRange', ctypes.c_uint32, 24),
    ('ucMemBlkId', ctypes.c_uint32, 8),
     ]

class struct__ATOM_MEMORY_SETTING_DATA_BLOCK(ctypes.Structure):
    pass

class union__ATOM_MEMORY_SETTING_ID_CONFIG_ACCESS(ctypes.Union):
    pass

ATOM_MEMORY_SETTING_ID_CONFIG = struct__ATOM_MEMORY_SETTING_ID_CONFIG
union__ATOM_MEMORY_SETTING_ID_CONFIG_ACCESS._pack_ = True # source:False
union__ATOM_MEMORY_SETTING_ID_CONFIG_ACCESS._fields_ = [
    ('slAccess', ATOM_MEMORY_SETTING_ID_CONFIG),
    ('ulAccess', ctypes.c_uint32),
]

ATOM_MEMORY_SETTING_ID_CONFIG_ACCESS = union__ATOM_MEMORY_SETTING_ID_CONFIG_ACCESS
struct__ATOM_MEMORY_SETTING_DATA_BLOCK._pack_ = True # source:False
struct__ATOM_MEMORY_SETTING_DATA_BLOCK._fields_ = [
    ('ulMemoryID', ATOM_MEMORY_SETTING_ID_CONFIG_ACCESS),
    ('aulMemData', ctypes.c_uint32 * 1),
]

class struct__ATOM_INIT_REG_INDEX_FORMAT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usRegIndex', ctypes.c_uint16),
    ('ucPreRegDataLength', ctypes.c_ubyte),
     ]

class struct__ATOM_INIT_REG_BLOCK(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usRegIndexTblSize', ctypes.c_uint16),
    ('usRegDataBlkSize', ctypes.c_uint16),
    ('asRegIndexBuf', struct__ATOM_INIT_REG_INDEX_FORMAT * 1),
    ('asRegDataBuf', struct__ATOM_MEMORY_SETTING_DATA_BLOCK * 1),
     ]

class struct__ATOM_MC_INIT_PARAM_TABLE(ctypes.Structure):
    pass

ATOM_INIT_REG_BLOCK = struct__ATOM_INIT_REG_BLOCK
struct__ATOM_MC_INIT_PARAM_TABLE._pack_ = True # source:False
struct__ATOM_MC_INIT_PARAM_TABLE._fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usAdjustARB_SEQDataOffset', ctypes.c_uint16),
    ('usMCInitMemTypeTblOffset', ctypes.c_uint16),
    ('usMCInitCommonTblOffset', ctypes.c_uint16),
    ('usMCInitPowerDownTblOffset', ctypes.c_uint16),
    ('ulARB_SEQDataBuf', ctypes.c_uint32 * 32),
    ('asMCInitMemType', ATOM_INIT_REG_BLOCK),
    ('asMCInitCommon', ATOM_INIT_REG_BLOCK),
]

class struct__ATOM_REG_INIT_SETTING(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usRegIndex', ctypes.c_uint16),
    ('ulRegValue', ctypes.c_uint32),
     ]

class struct__ATOM_MC_INIT_PARAM_TABLE_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulMCUcodeVersion', ctypes.c_uint32),
    ('ulMCUcodeRomStartAddr', ctypes.c_uint32),
    ('ulMCUcodeLength', ctypes.c_uint32),
    ('usMcRegInitTableOffset', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
     ]

class struct__MCuCodeHeader(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulSignature', ctypes.c_uint32),
    ('ucRevision', ctypes.c_ubyte),
    ('ucChecksum', ctypes.c_ubyte),
    ('ucReserved1', ctypes.c_ubyte),
    ('ucReserved2', ctypes.c_ubyte),
    ('usParametersLength', ctypes.c_uint16),
    ('usUCodeLength', ctypes.c_uint16),
    ('usReserved1', ctypes.c_uint16),
    ('usReserved2', ctypes.c_uint16),
     ]

class struct__ATOM_VRAM_MODULE_V1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulReserved', ctypes.c_uint32),
    ('usEMRSValue', ctypes.c_uint16),
    ('usMRSValue', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
    ('ucExtMemoryID', ctypes.c_ubyte),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucMemoryVenderID', ctypes.c_ubyte),
    ('ucMemoryDeviceCfg', ctypes.c_ubyte),
    ('ucRow', ctypes.c_ubyte),
    ('ucColumn', ctypes.c_ubyte),
    ('ucBank', ctypes.c_ubyte),
    ('ucRank', ctypes.c_ubyte),
    ('ucChannelNum', ctypes.c_ubyte),
    ('ucChannelConfig', ctypes.c_ubyte),
    ('ucDefaultMVDDQ_ID', ctypes.c_ubyte),
    ('ucDefaultMVDDC_ID', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_VRAM_MODULE_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulReserved', ctypes.c_uint32),
    ('ulFlags', ctypes.c_uint32),
    ('ulEngineClock', ctypes.c_uint32),
    ('ulMemoryClock', ctypes.c_uint32),
    ('usEMRS2Value', ctypes.c_uint16),
    ('usEMRS3Value', ctypes.c_uint16),
    ('usEMRSValue', ctypes.c_uint16),
    ('usMRSValue', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
    ('ucExtMemoryID', ctypes.c_ubyte),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucMemoryVenderID', ctypes.c_ubyte),
    ('ucMemoryDeviceCfg', ctypes.c_ubyte),
    ('ucRow', ctypes.c_ubyte),
    ('ucColumn', ctypes.c_ubyte),
    ('ucBank', ctypes.c_ubyte),
    ('ucRank', ctypes.c_ubyte),
    ('ucChannelNum', ctypes.c_ubyte),
    ('ucChannelConfig', ctypes.c_ubyte),
    ('ucDefaultMVDDQ_ID', ctypes.c_ubyte),
    ('ucDefaultMVDDC_ID', ctypes.c_ubyte),
    ('ucRefreshRateFactor', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
     ]

class struct__ATOM_MEMORY_TIMING_FORMAT(ctypes.Structure):
    pass

class union__ATOM_MEMORY_TIMING_FORMAT_2(ctypes.Union):
    pass

class struct__ATOM_MEMORY_TIMING_FORMAT_2_0(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucflag', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

union__ATOM_MEMORY_TIMING_FORMAT_2._pack_ = True # source:False
union__ATOM_MEMORY_TIMING_FORMAT_2._fields_ = [
    ('_0', struct__ATOM_MEMORY_TIMING_FORMAT_2_0),
    ('usDDR3_MR2', ctypes.c_uint16),
]

class union__ATOM_MEMORY_TIMING_FORMAT_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usMRS', ctypes.c_uint16),
    ('usDDR3_MR0', ctypes.c_uint16),
     ]

class union__ATOM_MEMORY_TIMING_FORMAT_1(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usEMRS', ctypes.c_uint16),
    ('usDDR3_MR1', ctypes.c_uint16),
     ]

struct__ATOM_MEMORY_TIMING_FORMAT._pack_ = True # source:False
struct__ATOM_MEMORY_TIMING_FORMAT._fields_ = [
    ('ulClkRange', ctypes.c_uint32),
    ('_1', union__ATOM_MEMORY_TIMING_FORMAT_0),
    ('_2', union__ATOM_MEMORY_TIMING_FORMAT_1),
    ('ucCL', ctypes.c_ubyte),
    ('ucWL', ctypes.c_ubyte),
    ('uctRAS', ctypes.c_ubyte),
    ('uctRC', ctypes.c_ubyte),
    ('uctRFC', ctypes.c_ubyte),
    ('uctRCDR', ctypes.c_ubyte),
    ('uctRCDW', ctypes.c_ubyte),
    ('uctRP', ctypes.c_ubyte),
    ('uctRRD', ctypes.c_ubyte),
    ('uctWR', ctypes.c_ubyte),
    ('uctWTR', ctypes.c_ubyte),
    ('uctPDIX', ctypes.c_ubyte),
    ('uctFAW', ctypes.c_ubyte),
    ('uctAOND', ctypes.c_ubyte),
    ('_17', union__ATOM_MEMORY_TIMING_FORMAT_2),
]

class struct__ATOM_MEMORY_TIMING_FORMAT_V1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClkRange', ctypes.c_uint32),
    ('usMRS', ctypes.c_uint16),
    ('usEMRS', ctypes.c_uint16),
    ('ucCL', ctypes.c_ubyte),
    ('ucWL', ctypes.c_ubyte),
    ('uctRAS', ctypes.c_ubyte),
    ('uctRC', ctypes.c_ubyte),
    ('uctRFC', ctypes.c_ubyte),
    ('uctRCDR', ctypes.c_ubyte),
    ('uctRCDW', ctypes.c_ubyte),
    ('uctRP', ctypes.c_ubyte),
    ('uctRRD', ctypes.c_ubyte),
    ('uctWR', ctypes.c_ubyte),
    ('uctWTR', ctypes.c_ubyte),
    ('uctPDIX', ctypes.c_ubyte),
    ('uctFAW', ctypes.c_ubyte),
    ('uctAOND', ctypes.c_ubyte),
    ('ucflag', ctypes.c_ubyte),
    ('uctCCDL', ctypes.c_ubyte),
    ('uctCRCRL', ctypes.c_ubyte),
    ('uctCRCWL', ctypes.c_ubyte),
    ('uctCKE', ctypes.c_ubyte),
    ('uctCKRSE', ctypes.c_ubyte),
    ('uctCKRSX', ctypes.c_ubyte),
    ('uctFAW32', ctypes.c_ubyte),
    ('ucMR5lo', ctypes.c_ubyte),
    ('ucMR5hi', ctypes.c_ubyte),
    ('ucTerminator', ctypes.c_ubyte),
     ]

class struct__ATOM_MEMORY_TIMING_FORMAT_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulClkRange', ctypes.c_uint32),
    ('usMRS', ctypes.c_uint16),
    ('usEMRS', ctypes.c_uint16),
    ('ucCL', ctypes.c_ubyte),
    ('ucWL', ctypes.c_ubyte),
    ('uctRAS', ctypes.c_ubyte),
    ('uctRC', ctypes.c_ubyte),
    ('uctRFC', ctypes.c_ubyte),
    ('uctRCDR', ctypes.c_ubyte),
    ('uctRCDW', ctypes.c_ubyte),
    ('uctRP', ctypes.c_ubyte),
    ('uctRRD', ctypes.c_ubyte),
    ('uctWR', ctypes.c_ubyte),
    ('uctWTR', ctypes.c_ubyte),
    ('uctPDIX', ctypes.c_ubyte),
    ('uctFAW', ctypes.c_ubyte),
    ('uctAOND', ctypes.c_ubyte),
    ('ucflag', ctypes.c_ubyte),
    ('uctCCDL', ctypes.c_ubyte),
    ('uctCRCRL', ctypes.c_ubyte),
    ('uctCRCWL', ctypes.c_ubyte),
    ('uctCKE', ctypes.c_ubyte),
    ('uctCKRSE', ctypes.c_ubyte),
    ('uctCKRSX', ctypes.c_ubyte),
    ('uctFAW32', ctypes.c_ubyte),
    ('ucMR4lo', ctypes.c_ubyte),
    ('ucMR4hi', ctypes.c_ubyte),
    ('ucMR5lo', ctypes.c_ubyte),
    ('ucMR5hi', ctypes.c_ubyte),
    ('ucTerminator', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ATOM_MEMORY_FORMAT(ctypes.Structure):
    pass

class union__ATOM_MEMORY_FORMAT_1(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usEMRS3Value', ctypes.c_uint16),
    ('usDDR3_MR3', ctypes.c_uint16),
     ]

class union__ATOM_MEMORY_FORMAT_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usEMRS2Value', ctypes.c_uint16),
    ('usDDR3_Reserved', ctypes.c_uint16),
     ]

struct__ATOM_MEMORY_FORMAT._pack_ = True # source:False
struct__ATOM_MEMORY_FORMAT._fields_ = [
    ('ulDllDisClock', ctypes.c_uint32),
    ('_1', union__ATOM_MEMORY_FORMAT_0),
    ('_2', union__ATOM_MEMORY_FORMAT_1),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucMemoryVenderID', ctypes.c_ubyte),
    ('ucRow', ctypes.c_ubyte),
    ('ucColumn', ctypes.c_ubyte),
    ('ucBank', ctypes.c_ubyte),
    ('ucRank', ctypes.c_ubyte),
    ('ucBurstSize', ctypes.c_ubyte),
    ('ucDllDisBit', ctypes.c_ubyte),
    ('ucRefreshRateFactor', ctypes.c_ubyte),
    ('ucDensity', ctypes.c_ubyte),
    ('ucPreamble', ctypes.c_ubyte),
    ('ucMemAttrib', ctypes.c_ubyte),
    ('asMemTiming', struct__ATOM_MEMORY_TIMING_FORMAT * 5),
]

class struct__ATOM_VRAM_MODULE_V3(ctypes.Structure):
    pass

ATOM_MEMORY_FORMAT = struct__ATOM_MEMORY_FORMAT
struct__ATOM_VRAM_MODULE_V3._pack_ = True # source:False
struct__ATOM_VRAM_MODULE_V3._fields_ = [
    ('ulChannelMapCfg', ctypes.c_uint32),
    ('usSize', ctypes.c_uint16),
    ('usDefaultMVDDQ', ctypes.c_uint16),
    ('usDefaultMVDDC', ctypes.c_uint16),
    ('ucExtMemoryID', ctypes.c_ubyte),
    ('ucChannelNum', ctypes.c_ubyte),
    ('ucChannelSize', ctypes.c_ubyte),
    ('ucVREFI', ctypes.c_ubyte),
    ('ucNPL_RT', ctypes.c_ubyte),
    ('ucFlag', ctypes.c_ubyte),
    ('asMemory', ATOM_MEMORY_FORMAT),
]

class struct__ATOM_VRAM_MODULE_V4(ctypes.Structure):
    pass

class union__ATOM_VRAM_MODULE_V4_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usEMRS2Value', ctypes.c_uint16),
    ('usDDR3_Reserved', ctypes.c_uint16),
     ]

class union__ATOM_VRAM_MODULE_V4_1(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('usEMRS3Value', ctypes.c_uint16),
    ('usDDR3_MR3', ctypes.c_uint16),
     ]

struct__ATOM_VRAM_MODULE_V4._pack_ = True # source:False
struct__ATOM_VRAM_MODULE_V4._fields_ = [
    ('ulChannelMapCfg', ctypes.c_uint32),
    ('usModuleSize', ctypes.c_uint16),
    ('usPrivateReserved', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
    ('ucExtMemoryID', ctypes.c_ubyte),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucChannelNum', ctypes.c_ubyte),
    ('ucChannelWidth', ctypes.c_ubyte),
    ('ucDensity', ctypes.c_ubyte),
    ('ucFlag', ctypes.c_ubyte),
    ('ucMisc', ctypes.c_ubyte),
    ('ucVREFI', ctypes.c_ubyte),
    ('ucNPL_RT', ctypes.c_ubyte),
    ('ucPreamble', ctypes.c_ubyte),
    ('ucMemorySize', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('_16', union__ATOM_VRAM_MODULE_V4_0),
    ('_17', union__ATOM_VRAM_MODULE_V4_1),
    ('ucMemoryVenderID', ctypes.c_ubyte),
    ('ucRefreshRateFactor', ctypes.c_ubyte),
    ('ucReserved2', ctypes.c_ubyte * 2),
    ('asMemTiming', struct__ATOM_MEMORY_TIMING_FORMAT * 5),
]

class struct__ATOM_VRAM_MODULE_V5(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulChannelMapCfg', ctypes.c_uint32),
    ('usModuleSize', ctypes.c_uint16),
    ('usPrivateReserved', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
    ('ucExtMemoryID', ctypes.c_ubyte),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucChannelNum', ctypes.c_ubyte),
    ('ucChannelWidth', ctypes.c_ubyte),
    ('ucDensity', ctypes.c_ubyte),
    ('ucFlag', ctypes.c_ubyte),
    ('ucMisc', ctypes.c_ubyte),
    ('ucVREFI', ctypes.c_ubyte),
    ('ucNPL_RT', ctypes.c_ubyte),
    ('ucPreamble', ctypes.c_ubyte),
    ('ucMemorySize', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('usEMRS2Value', ctypes.c_uint16),
    ('usEMRS3Value', ctypes.c_uint16),
    ('ucMemoryVenderID', ctypes.c_ubyte),
    ('ucRefreshRateFactor', ctypes.c_ubyte),
    ('ucFIFODepth', ctypes.c_ubyte),
    ('ucCDR_Bandwidth', ctypes.c_ubyte),
    ('asMemTiming', struct__ATOM_MEMORY_TIMING_FORMAT_V1 * 5),
     ]

class struct__ATOM_VRAM_MODULE_V6(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulChannelMapCfg', ctypes.c_uint32),
    ('usModuleSize', ctypes.c_uint16),
    ('usPrivateReserved', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
    ('ucExtMemoryID', ctypes.c_ubyte),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucChannelNum', ctypes.c_ubyte),
    ('ucChannelWidth', ctypes.c_ubyte),
    ('ucDensity', ctypes.c_ubyte),
    ('ucFlag', ctypes.c_ubyte),
    ('ucMisc', ctypes.c_ubyte),
    ('ucVREFI', ctypes.c_ubyte),
    ('ucNPL_RT', ctypes.c_ubyte),
    ('ucPreamble', ctypes.c_ubyte),
    ('ucMemorySize', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('usEMRS2Value', ctypes.c_uint16),
    ('usEMRS3Value', ctypes.c_uint16),
    ('ucMemoryVenderID', ctypes.c_ubyte),
    ('ucRefreshRateFactor', ctypes.c_ubyte),
    ('ucFIFODepth', ctypes.c_ubyte),
    ('ucCDR_Bandwidth', ctypes.c_ubyte),
    ('asMemTiming', struct__ATOM_MEMORY_TIMING_FORMAT_V2 * 5),
     ]

class struct__ATOM_VRAM_MODULE_V7(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulChannelMapCfg', ctypes.c_uint32),
    ('usModuleSize', ctypes.c_uint16),
    ('usPrivateReserved', ctypes.c_uint16),
    ('usEnableChannels', ctypes.c_uint16),
    ('ucExtMemoryID', ctypes.c_ubyte),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucChannelNum', ctypes.c_ubyte),
    ('ucChannelWidth', ctypes.c_ubyte),
    ('ucDensity', ctypes.c_ubyte),
    ('ucReserve', ctypes.c_ubyte),
    ('ucMisc', ctypes.c_ubyte),
    ('ucVREFI', ctypes.c_ubyte),
    ('ucNPL_RT', ctypes.c_ubyte),
    ('ucPreamble', ctypes.c_ubyte),
    ('ucMemorySize', ctypes.c_ubyte),
    ('usSEQSettingOffset', ctypes.c_uint16),
    ('ucReserved', ctypes.c_ubyte),
    ('usEMRS2Value', ctypes.c_uint16),
    ('usEMRS3Value', ctypes.c_uint16),
    ('ucMemoryVenderID', ctypes.c_ubyte),
    ('ucRefreshRateFactor', ctypes.c_ubyte),
    ('ucFIFODepth', ctypes.c_ubyte),
    ('ucCDR_Bandwidth', ctypes.c_ubyte),
    ('strMemPNString', ctypes.c_char * 20),
     ]

class struct__ATOM_VRAM_MODULE_V8(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulChannelMapCfg', ctypes.c_uint32),
    ('usModuleSize', ctypes.c_uint16),
    ('usMcRamCfg', ctypes.c_uint16),
    ('usEnableChannels', ctypes.c_uint16),
    ('ucExtMemoryID', ctypes.c_ubyte),
    ('ucMemoryType', ctypes.c_ubyte),
    ('ucChannelNum', ctypes.c_ubyte),
    ('ucChannelWidth', ctypes.c_ubyte),
    ('ucDensity', ctypes.c_ubyte),
    ('ucBankCol', ctypes.c_ubyte),
    ('ucMisc', ctypes.c_ubyte),
    ('ucVREFI', ctypes.c_ubyte),
    ('usReserved', ctypes.c_uint16),
    ('usMemorySize', ctypes.c_uint16),
    ('ucMcTunningSetId', ctypes.c_ubyte),
    ('ucRowNum', ctypes.c_ubyte),
    ('usEMRS2Value', ctypes.c_uint16),
    ('usEMRS3Value', ctypes.c_uint16),
    ('ucMemoryVenderID', ctypes.c_ubyte),
    ('ucRefreshRateFactor', ctypes.c_ubyte),
    ('ucFIFODepth', ctypes.c_ubyte),
    ('ucCDR_Bandwidth', ctypes.c_ubyte),
    ('ulChannelMapCfg1', ctypes.c_uint32),
    ('ulBankMapCfg', ctypes.c_uint32),
    ('ulReserved', ctypes.c_uint32),
    ('strMemPNString', ctypes.c_char * 20),
     ]

class struct__ATOM_VRAM_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucNumOfVRAMModule', ctypes.c_ubyte),
    ('aVramInfo', struct__ATOM_VRAM_MODULE_V3 * 16),
     ]

class struct__ATOM_VRAM_INFO_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usMemAdjustTblOffset', ctypes.c_uint16),
    ('usMemClkPatchTblOffset', ctypes.c_uint16),
    ('usRerseved', ctypes.c_uint16),
    ('aVID_PinsShift', ctypes.c_ubyte * 9),
    ('ucNumOfVRAMModule', ctypes.c_ubyte),
    ('aVramInfo', struct__ATOM_VRAM_MODULE_V3 * 16),
    ('asMemPatch', ATOM_INIT_REG_BLOCK),
     ]

class struct__ATOM_VRAM_INFO_V4(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usMemAdjustTblOffset', ctypes.c_uint16),
    ('usMemClkPatchTblOffset', ctypes.c_uint16),
    ('usRerseved', ctypes.c_uint16),
    ('ucMemDQ7_0ByteRemap', ctypes.c_ubyte),
    ('ulMemDQ7_0BitRemap', ctypes.c_uint32),
    ('ucReservde', ctypes.c_ubyte * 4),
    ('ucNumOfVRAMModule', ctypes.c_ubyte),
    ('aVramInfo', struct__ATOM_VRAM_MODULE_V4 * 16),
    ('asMemPatch', ATOM_INIT_REG_BLOCK),
     ]

class struct__ATOM_VRAM_INFO_HEADER_V2_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usMemAdjustTblOffset', ctypes.c_uint16),
    ('usMemClkPatchTblOffset', ctypes.c_uint16),
    ('usPerBytePresetOffset', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16 * 3),
    ('ucNumOfVRAMModule', ctypes.c_ubyte),
    ('ucMemoryClkPatchTblVer', ctypes.c_ubyte),
    ('ucVramModuleVer', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('aVramInfo', struct__ATOM_VRAM_MODULE_V7 * 16),
     ]

class struct__ATOM_VRAM_INFO_HEADER_V2_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usMemAdjustTblOffset', ctypes.c_uint16),
    ('usMemClkPatchTblOffset', ctypes.c_uint16),
    ('usMcAdjustPerTileTblOffset', ctypes.c_uint16),
    ('usMcPhyInitTableOffset', ctypes.c_uint16),
    ('usDramDataRemapTblOffset', ctypes.c_uint16),
    ('usReserved1', ctypes.c_uint16),
    ('ucNumOfVRAMModule', ctypes.c_ubyte),
    ('ucMemoryClkPatchTblVer', ctypes.c_ubyte),
    ('ucVramModuleVer', ctypes.c_ubyte),
    ('ucMcPhyTileNum', ctypes.c_ubyte),
    ('aVramInfo', struct__ATOM_VRAM_MODULE_V8 * 16),
     ]

class struct__ATOM_DRAM_DATA_REMAP(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucByteRemapCh0', ctypes.c_ubyte),
    ('ucByteRemapCh1', ctypes.c_ubyte),
    ('ulByte0BitRemapCh0', ctypes.c_uint32),
    ('ulByte1BitRemapCh0', ctypes.c_uint32),
    ('ulByte2BitRemapCh0', ctypes.c_uint32),
    ('ulByte3BitRemapCh0', ctypes.c_uint32),
    ('ulByte0BitRemapCh1', ctypes.c_uint32),
    ('ulByte1BitRemapCh1', ctypes.c_uint32),
    ('ulByte2BitRemapCh1', ctypes.c_uint32),
    ('ulByte3BitRemapCh1', ctypes.c_uint32),
     ]

class struct__ATOM_VRAM_GPIO_DETECTION_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('aVID_PinsShift', ctypes.c_ubyte * 9),
     ]

class struct__ATOM_MEMORY_TRAINING_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucTrainingLoop', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('asMemTrainingSetting', ATOM_INIT_REG_BLOCK),
     ]

class struct__ATOM_MEMORY_TRAINING_INFO_V3_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ulMCUcodeVersion', ctypes.c_uint32),
    ('usMCIOInitLen', ctypes.c_uint16),
    ('usMCUcodeLen', ctypes.c_uint16),
    ('usMCIORegInitOffset', ctypes.c_uint16),
    ('usMCUcodeOffset', ctypes.c_uint16),
     ]

class struct_SW_I2C_CNTL_DATA_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucControl', ctypes.c_ubyte),
    ('ucData', ctypes.c_ubyte),
    ('ucSatus', ctypes.c_ubyte),
    ('ucTemp', ctypes.c_ubyte),
     ]

class struct__SW_I2C_IO_DATA_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('GPIO_Info', ctypes.c_uint16),
    ('ucAct', ctypes.c_ubyte),
    ('ucData', ctypes.c_ubyte),
     ]

class struct__PTR_32_BIT_STRUCTURE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('Offset16', ctypes.c_uint16),
    ('Segment16', ctypes.c_uint16),
     ]

class struct__VBE_1_2_INFO_BLOCK_UPDATABLE(ctypes.Structure):
    pass

class union__PTR_32_BIT_UNION(ctypes.Union):
    pass

PTR_32_BIT_STRUCTURE = struct__PTR_32_BIT_STRUCTURE
union__PTR_32_BIT_UNION._pack_ = True # source:False
union__PTR_32_BIT_UNION._fields_ = [
    ('SegmentOffset', PTR_32_BIT_STRUCTURE),
    ('Ptr32_Bit', ctypes.c_uint32),
]

PTR_32_BIT_UNION = union__PTR_32_BIT_UNION
struct__VBE_1_2_INFO_BLOCK_UPDATABLE._pack_ = True # source:False
struct__VBE_1_2_INFO_BLOCK_UPDATABLE._fields_ = [
    ('VbeSignature', ctypes.c_ubyte * 4),
    ('VbeVersion', ctypes.c_uint16),
    ('OemStringPtr', PTR_32_BIT_UNION),
    ('Capabilities', ctypes.c_ubyte * 4),
    ('VideoModePtr', PTR_32_BIT_UNION),
    ('TotalMemory', ctypes.c_uint16),
]

class struct__VBE_2_0_INFO_BLOCK_UPDATABLE(ctypes.Structure):
    pass

VBE_1_2_INFO_BLOCK_UPDATABLE = struct__VBE_1_2_INFO_BLOCK_UPDATABLE
struct__VBE_2_0_INFO_BLOCK_UPDATABLE._pack_ = True # source:False
struct__VBE_2_0_INFO_BLOCK_UPDATABLE._fields_ = [
    ('CommonBlock', VBE_1_2_INFO_BLOCK_UPDATABLE),
    ('OemSoftRev', ctypes.c_uint16),
    ('OemVendorNamePtr', PTR_32_BIT_UNION),
    ('OemProductNamePtr', PTR_32_BIT_UNION),
    ('OemProductRevPtr', PTR_32_BIT_UNION),
]

class struct__VBE_INFO_BLOCK(ctypes.Structure):
    pass

class union__VBE_VERSION_UNION(ctypes.Union):
    pass

VBE_2_0_INFO_BLOCK_UPDATABLE = struct__VBE_2_0_INFO_BLOCK_UPDATABLE
union__VBE_VERSION_UNION._pack_ = True # source:False
union__VBE_VERSION_UNION._fields_ = [
    ('VBE_2_0_InfoBlock', VBE_2_0_INFO_BLOCK_UPDATABLE),
    ('VBE_1_2_InfoBlock', VBE_1_2_INFO_BLOCK_UPDATABLE),
    ('PADDING_0', ctypes.c_ubyte * 14),
]

VBE_VERSION_UNION = union__VBE_VERSION_UNION
struct__VBE_INFO_BLOCK._pack_ = True # source:False
struct__VBE_INFO_BLOCK._fields_ = [
    ('UpdatableVBE_Info', VBE_VERSION_UNION),
    ('Reserved', ctypes.c_ubyte * 222),
    ('OemData', ctypes.c_ubyte * 256),
]

class struct__VBE_FP_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('HSize', ctypes.c_uint16),
    ('VSize', ctypes.c_uint16),
    ('FPType', ctypes.c_uint16),
    ('RedBPP', ctypes.c_ubyte),
    ('GreenBPP', ctypes.c_ubyte),
    ('BlueBPP', ctypes.c_ubyte),
    ('ReservedBPP', ctypes.c_ubyte),
    ('RsvdOffScrnMemSize', ctypes.c_uint32),
    ('RsvdOffScrnMEmPtr', ctypes.c_uint32),
    ('Reserved', ctypes.c_ubyte * 14),
     ]

class struct__VESA_MODE_INFO_BLOCK(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ModeAttributes', ctypes.c_uint16),
    ('WinAAttributes', ctypes.c_ubyte),
    ('WinBAttributes', ctypes.c_ubyte),
    ('WinGranularity', ctypes.c_uint16),
    ('WinSize', ctypes.c_uint16),
    ('WinASegment', ctypes.c_uint16),
    ('WinBSegment', ctypes.c_uint16),
    ('WinFuncPtr', ctypes.c_uint32),
    ('BytesPerScanLine', ctypes.c_uint16),
    ('XResolution', ctypes.c_uint16),
    ('YResolution', ctypes.c_uint16),
    ('XCharSize', ctypes.c_ubyte),
    ('YCharSize', ctypes.c_ubyte),
    ('NumberOfPlanes', ctypes.c_ubyte),
    ('BitsPerPixel', ctypes.c_ubyte),
    ('NumberOfBanks', ctypes.c_ubyte),
    ('MemoryModel', ctypes.c_ubyte),
    ('BankSize', ctypes.c_ubyte),
    ('NumberOfImagePages', ctypes.c_ubyte),
    ('ReservedForPageFunction', ctypes.c_ubyte),
    ('RedMaskSize', ctypes.c_ubyte),
    ('RedFieldPosition', ctypes.c_ubyte),
    ('GreenMaskSize', ctypes.c_ubyte),
    ('GreenFieldPosition', ctypes.c_ubyte),
    ('BlueMaskSize', ctypes.c_ubyte),
    ('BlueFieldPosition', ctypes.c_ubyte),
    ('RsvdMaskSize', ctypes.c_ubyte),
    ('RsvdFieldPosition', ctypes.c_ubyte),
    ('DirectColorModeInfo', ctypes.c_ubyte),
    ('PhysBasePtr', ctypes.c_uint32),
    ('Reserved_1', ctypes.c_uint32),
    ('Reserved_2', ctypes.c_uint16),
    ('LinBytesPerScanLine', ctypes.c_uint16),
    ('BnkNumberOfImagePages', ctypes.c_ubyte),
    ('LinNumberOfImagPages', ctypes.c_ubyte),
    ('LinRedMaskSize', ctypes.c_ubyte),
    ('LinRedFieldPosition', ctypes.c_ubyte),
    ('LinGreenMaskSize', ctypes.c_ubyte),
    ('LinGreenFieldPosition', ctypes.c_ubyte),
    ('LinBlueMaskSize', ctypes.c_ubyte),
    ('LinBlueFieldPosition', ctypes.c_ubyte),
    ('LinRsvdMaskSize', ctypes.c_ubyte),
    ('LinRsvdFieldPosition', ctypes.c_ubyte),
    ('MaxPixelClock', ctypes.c_uint32),
    ('Reserved', ctypes.c_ubyte),
     ]

class struct__ASIC_TRANSMITTER_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usTransmitterObjId', ctypes.c_uint16),
    ('usSupportDevice', ctypes.c_uint16),
    ('ucTransmitterCmdTblId', ctypes.c_ubyte),
    ('ucConfig', ctypes.c_ubyte),
    ('ucEncoderID', ctypes.c_ubyte),
    ('ucOptionEncoderID', ctypes.c_ubyte),
    ('uc2ndEncoderID', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ASIC_ENCODER_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEncoderID', ctypes.c_ubyte),
    ('ucEncoderConfig', ctypes.c_ubyte),
    ('usEncoderCmdTblId', ctypes.c_uint16),
     ]

class struct__ATOM_DISP_OUT_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ptrTransmitterInfo', ctypes.c_uint16),
    ('ptrEncoderInfo', ctypes.c_uint16),
    ('asTransmitterInfo', struct__ASIC_TRANSMITTER_INFO * 1),
    ('asEncoderInfo', struct__ASIC_ENCODER_INFO * 1),
     ]

class struct__ATOM_DISP_OUT_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ptrTransmitterInfo', ctypes.c_uint16),
    ('ptrEncoderInfo', ctypes.c_uint16),
    ('ptrMainCallParserFar', ctypes.c_uint16),
    ('asTransmitterInfo', struct__ASIC_TRANSMITTER_INFO * 1),
    ('asEncoderInfo', struct__ASIC_ENCODER_INFO * 1),
     ]

class struct__ATOM_DISP_CLOCK_ID(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucPpllId', ctypes.c_ubyte),
    ('ucPpllAttribute', ctypes.c_ubyte),
     ]

class struct__ASIC_TRANSMITTER_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usTransmitterObjId', ctypes.c_uint16),
    ('usDispClkIdOffset', ctypes.c_uint16),
    ('ucTransmitterCmdTblId', ctypes.c_ubyte),
    ('ucConfig', ctypes.c_ubyte),
    ('ucEncoderID', ctypes.c_ubyte),
    ('ucOptionEncoderID', ctypes.c_ubyte),
    ('uc2ndEncoderID', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
     ]

class struct__ATOM_DISP_OUT_INFO_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ptrTransmitterInfo', ctypes.c_uint16),
    ('ptrEncoderInfo', ctypes.c_uint16),
    ('ptrMainCallParserFar', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
    ('ucDCERevision', ctypes.c_ubyte),
    ('ucMaxDispEngineNum', ctypes.c_ubyte),
    ('ucMaxActiveDispEngineNum', ctypes.c_ubyte),
    ('ucMaxPPLLNum', ctypes.c_ubyte),
    ('ucCoreRefClkSource', ctypes.c_ubyte),
    ('ucDispCaps', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
    ('asTransmitterInfo', struct__ASIC_TRANSMITTER_INFO_V2 * 1),
     ]

class struct__ATOM_DISPLAY_DEVICE_PRIORITY_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('asDevicePriority', ctypes.c_uint16 * 16),
     ]

class struct__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS(ctypes.Structure):
    pass

class union__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucReplyStatus', ctypes.c_ubyte),
    ('ucDelay', ctypes.c_ubyte),
     ]

struct__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS._pack_ = True # source:False
struct__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS._fields_ = [
    ('lpAuxRequest', ctypes.c_uint16),
    ('lpDataOut', ctypes.c_uint16),
    ('ucChannelID', ctypes.c_ubyte),
    ('_3', union__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_0),
    ('ucDataOutLen', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
]

class struct__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2(ctypes.Structure):
    pass

class union__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucReplyStatus', ctypes.c_ubyte),
    ('ucDelay', ctypes.c_ubyte),
     ]

struct__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2._pack_ = True # source:False
struct__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2._fields_ = [
    ('lpAuxRequest', ctypes.c_uint16),
    ('lpDataOut', ctypes.c_uint16),
    ('ucChannelID', ctypes.c_ubyte),
    ('_3', union__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2_0),
    ('ucDataOutLen', ctypes.c_ubyte),
    ('ucHPD_ID', ctypes.c_ubyte),
]

class struct__DP_ENCODER_SERVICE_PARAMETERS(ctypes.Structure):
    pass

class union__DP_ENCODER_SERVICE_PARAMETERS_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucConfig', ctypes.c_ubyte),
    ('ucI2cId', ctypes.c_ubyte),
     ]

struct__DP_ENCODER_SERVICE_PARAMETERS._pack_ = True # source:False
struct__DP_ENCODER_SERVICE_PARAMETERS._fields_ = [
    ('ucLinkClock', ctypes.c_uint16),
    ('_1', union__DP_ENCODER_SERVICE_PARAMETERS_0),
    ('ucAction', ctypes.c_ubyte),
    ('ucStatus', ctypes.c_ubyte),
    ('ucLaneNum', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
]

class struct__DP_ENCODER_SERVICE_PARAMETERS_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usExtEncoderObjId', ctypes.c_uint16),
    ('ucAuxId', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('ucSinkType', ctypes.c_ubyte),
    ('ucHPDId', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

class struct__DP_ENCODER_SERVICE_PS_ALLOCATION_V2(ctypes.Structure):
    pass

DP_ENCODER_SERVICE_PARAMETERS_V2 = struct__DP_ENCODER_SERVICE_PARAMETERS_V2
PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2 = struct__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2
struct__DP_ENCODER_SERVICE_PS_ALLOCATION_V2._pack_ = True # source:False
struct__DP_ENCODER_SERVICE_PS_ALLOCATION_V2._fields_ = [
    ('asDPServiceParam', DP_ENCODER_SERVICE_PARAMETERS_V2),
    ('asAuxParam', PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2),
]

class struct__PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS(ctypes.Structure):
    pass

class union__PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS_0(ctypes.Union):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRegIndex', ctypes.c_ubyte),
    ('ucStatus', ctypes.c_ubyte),
     ]

struct__PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS._pack_ = True # source:False
struct__PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS._fields_ = [
    ('ucI2CSpeed', ctypes.c_ubyte),
    ('_1', union__PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS_0),
    ('lpI2CDataOut', ctypes.c_uint16),
    ('ucFlag', ctypes.c_ubyte),
    ('ucTransBytes', ctypes.c_ubyte),
    ('ucSlaveAddr', ctypes.c_ubyte),
    ('ucLineNumber', ctypes.c_ubyte),
]

class struct__ATOM_HW_MISC_OPERATION_INPUT_PARAMETER_V1_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucCmd', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('ulReserved', ctypes.c_uint32),
     ]

class struct__ATOM_HW_MISC_OPERATION_OUTPUT_PARAMETER_V1_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucReturnCode', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
    ('ulReserved', ctypes.c_uint32),
     ]

class struct__ATOM_HW_MISC_OPERATION_PS_ALLOCATION(ctypes.Structure):
    pass

PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS = struct__PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS
ATOM_HW_MISC_OPERATION_INPUT_PARAMETER_V1_1 = struct__ATOM_HW_MISC_OPERATION_INPUT_PARAMETER_V1_1
struct__ATOM_HW_MISC_OPERATION_PS_ALLOCATION._pack_ = True # source:False
struct__ATOM_HW_MISC_OPERATION_PS_ALLOCATION._fields_ = [
    ('sInput_Output', ATOM_HW_MISC_OPERATION_INPUT_PARAMETER_V1_1),
    ('sReserved', PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS),
]

class struct__SET_HWBLOCK_INSTANCE_PARAMETER_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucHWBlkInst', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 3),
     ]

class struct__DIG_TRANSMITTER_INFO_HEADER_V3_1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usDPVsPreEmphSettingOffset', ctypes.c_uint16),
    ('usPhyAnalogRegListOffset', ctypes.c_uint16),
    ('usPhyAnalogSettingOffset', ctypes.c_uint16),
    ('usPhyPllRegListOffset', ctypes.c_uint16),
    ('usPhyPllSettingOffset', ctypes.c_uint16),
     ]

class struct__DIG_TRANSMITTER_INFO_HEADER_V3_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usDPVsPreEmphSettingOffset', ctypes.c_uint16),
    ('usPhyAnalogRegListOffset', ctypes.c_uint16),
    ('usPhyAnalogSettingOffset', ctypes.c_uint16),
    ('usPhyPllRegListOffset', ctypes.c_uint16),
    ('usPhyPllSettingOffset', ctypes.c_uint16),
    ('usDPSSRegListOffset', ctypes.c_uint16),
    ('usDPSSSettingOffset', ctypes.c_uint16),
     ]

class struct__DIG_TRANSMITTER_INFO_HEADER_V3_3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usDPVsPreEmphSettingOffset', ctypes.c_uint16),
    ('usPhyAnalogRegListOffset', ctypes.c_uint16),
    ('usPhyAnalogSettingOffset', ctypes.c_uint16),
    ('usPhyPllRegListOffset', ctypes.c_uint16),
    ('usPhyPllSettingOffset', ctypes.c_uint16),
    ('usDPSSRegListOffset', ctypes.c_uint16),
    ('usDPSSSettingOffset', ctypes.c_uint16),
    ('usEDPVsLegacyModeOffset', ctypes.c_uint16),
    ('useDPVsLowVdiffModeOffset', ctypes.c_uint16),
    ('useDPVsHighVdiffModeOffset', ctypes.c_uint16),
    ('useDPVsStretchModeOffset', ctypes.c_uint16),
    ('useDPVsSingleVdiffModeOffset', ctypes.c_uint16),
    ('useDPVsVariablePremModeOffset', ctypes.c_uint16),
     ]

class struct__CLOCK_CONDITION_REGESTER_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usRegisterIndex', ctypes.c_uint16),
    ('ucStartBit', ctypes.c_ubyte),
    ('ucEndBit', ctypes.c_ubyte),
     ]

class struct__CLOCK_CONDITION_SETTING_ENTRY(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usMaxClockFreq', ctypes.c_uint16),
    ('ucEncodeMode', ctypes.c_ubyte),
    ('ucPhySel', ctypes.c_ubyte),
    ('ulAnalogSetting', ctypes.c_uint32 * 1),
     ]

class struct__CLOCK_CONDITION_SETTING_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usEntrySize', ctypes.c_uint16),
    ('asClkCondSettingEntry', struct__CLOCK_CONDITION_SETTING_ENTRY * 1),
     ]

class struct__PHY_CONDITION_REG_VAL(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulCondition', ctypes.c_uint32),
    ('ulRegVal', ctypes.c_uint32),
     ]

class struct__PHY_CONDITION_REG_VAL_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulCondition', ctypes.c_uint32),
    ('ucCondition2', ctypes.c_ubyte),
    ('ulRegVal', ctypes.c_uint32),
     ]

class struct__PHY_CONDITION_REG_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usRegIndex', ctypes.c_uint16),
    ('usSize', ctypes.c_uint16),
    ('asRegVal', struct__PHY_CONDITION_REG_VAL * 1),
     ]

class struct__PHY_CONDITION_REG_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usRegIndex', ctypes.c_uint16),
    ('usSize', ctypes.c_uint16),
    ('asRegVal', struct__PHY_CONDITION_REG_VAL_V2 * 1),
     ]

class struct__PHY_ANALOG_SETTING_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEncodeMode', ctypes.c_ubyte),
    ('ucPhySel', ctypes.c_ubyte),
    ('usSize', ctypes.c_uint16),
    ('asAnalogSetting', struct__PHY_CONDITION_REG_INFO * 1),
     ]

class struct__PHY_ANALOG_SETTING_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEncodeMode', ctypes.c_ubyte),
    ('ucPhySel', ctypes.c_ubyte),
    ('usSize', ctypes.c_uint16),
    ('asAnalogSetting', struct__PHY_CONDITION_REG_INFO_V2 * 1),
     ]

class struct__GFX_HAVESTING_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucGfxBlkId', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ucActiveUnitNumPerSH', ctypes.c_ubyte),
    ('ucMaxUnitNumPerSH', ctypes.c_ubyte),
     ]

class struct__VBIOS_ROM_HEADER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('PciRomSignature', ctypes.c_ubyte * 2),
    ('ucPciRomSizeIn512bytes', ctypes.c_ubyte),
    ('ucJumpCoreMainInitBIOS', ctypes.c_ubyte),
    ('usLabelCoreMainInitBIOS', ctypes.c_uint16),
    ('PciReservedSpace', ctypes.c_ubyte * 18),
    ('usPciDataStructureOffset', ctypes.c_uint16),
    ('Rsvd1d_1a', ctypes.c_ubyte * 4),
    ('strIbm', ctypes.c_char * 3),
    ('CheckSum', ctypes.c_ubyte * 14),
    ('ucBiosMsgNumber', ctypes.c_ubyte),
    ('str761295520', ctypes.c_char * 16),
    ('usLabelCoreVPOSTNoMode', ctypes.c_uint16),
    ('usSpecialPostOffset', ctypes.c_uint16),
    ('ucSpeicalPostImageSizeIn512Bytes', ctypes.c_ubyte),
    ('Rsved47_45', ctypes.c_ubyte * 3),
    ('usROM_HeaderInformationTableOffset', ctypes.c_uint16),
    ('Rsved4f_4a', ctypes.c_ubyte * 6),
    ('strBuildTimeStamp', ctypes.c_char * 20),
    ('ucJumpCoreXFuncFarHandler', ctypes.c_ubyte),
    ('usCoreXFuncFarHandlerOffset', ctypes.c_uint16),
    ('ucRsved67', ctypes.c_ubyte),
    ('ucJumpCoreVFuncFarHandler', ctypes.c_ubyte),
    ('usCoreVFuncFarHandlerOffset', ctypes.c_uint16),
    ('Rsved6d_6b', ctypes.c_ubyte * 3),
    ('usATOM_BIOS_MESSAGE_Offset', ctypes.c_uint16),
     ]

class struct__ATOM_DAC_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usMaxFrequency', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
     ]

class struct__COMPASSIONATE_DATA(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucDAC1_BG_Adjustment', ctypes.c_ubyte),
    ('ucDAC1_DAC_Adjustment', ctypes.c_ubyte),
    ('usDAC1_FORCE_Data', ctypes.c_uint16),
    ('ucDAC2_CRT2_BG_Adjustment', ctypes.c_ubyte),
    ('ucDAC2_CRT2_DAC_Adjustment', ctypes.c_ubyte),
    ('usDAC2_CRT2_FORCE_Data', ctypes.c_uint16),
    ('usDAC2_CRT2_MUX_RegisterIndex', ctypes.c_uint16),
    ('ucDAC2_CRT2_MUX_RegisterInfo', ctypes.c_ubyte),
    ('ucDAC2_NTSC_BG_Adjustment', ctypes.c_ubyte),
    ('ucDAC2_NTSC_DAC_Adjustment', ctypes.c_ubyte),
    ('usDAC2_TV1_FORCE_Data', ctypes.c_uint16),
    ('usDAC2_TV1_MUX_RegisterIndex', ctypes.c_uint16),
    ('ucDAC2_TV1_MUX_RegisterInfo', ctypes.c_ubyte),
    ('ucDAC2_CV_BG_Adjustment', ctypes.c_ubyte),
    ('ucDAC2_CV_DAC_Adjustment', ctypes.c_ubyte),
    ('usDAC2_CV_FORCE_Data', ctypes.c_uint16),
    ('usDAC2_CV_MUX_RegisterIndex', ctypes.c_uint16),
    ('ucDAC2_CV_MUX_RegisterInfo', ctypes.c_ubyte),
    ('ucDAC2_PAL_BG_Adjustment', ctypes.c_ubyte),
    ('ucDAC2_PAL_DAC_Adjustment', ctypes.c_ubyte),
    ('usDAC2_TV2_FORCE_Data', ctypes.c_uint16),
     ]

class struct__ATOM_CONNECTOR_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('bfAssociatedDAC', ctypes.c_ubyte, 4),
    ('bfConnectorType', ctypes.c_ubyte, 4),
     ]

class struct__ATOM_CONNECTOR_INFO_I2C(ctypes.Structure):
    pass

class union__ATOM_CONNECTOR_INFO_ACCESS(ctypes.Union):
    pass

ATOM_CONNECTOR_INFO = struct__ATOM_CONNECTOR_INFO
union__ATOM_CONNECTOR_INFO_ACCESS._pack_ = True # source:False
union__ATOM_CONNECTOR_INFO_ACCESS._fields_ = [
    ('sbfAccess', ATOM_CONNECTOR_INFO),
    ('ucAccess', ctypes.c_ubyte),
]

ATOM_CONNECTOR_INFO_ACCESS = union__ATOM_CONNECTOR_INFO_ACCESS
struct__ATOM_CONNECTOR_INFO_I2C._pack_ = True # source:False
struct__ATOM_CONNECTOR_INFO_I2C._fields_ = [
    ('sucConnectorInfo', ATOM_CONNECTOR_INFO_ACCESS),
    ('sucI2cId', ATOM_I2C_ID_CONFIG_ACCESS),
]

class struct__ATOM_SUPPORTED_DEVICES_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usDeviceSupport', ctypes.c_uint16),
    ('asConnInfo', struct__ATOM_CONNECTOR_INFO_I2C * 10),
     ]

class struct__ATOM_CONNECTOR_INC_SRC_BITMAP(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucIntSrcBitmap', ctypes.c_ubyte),
     ]

class struct__ATOM_SUPPORTED_DEVICES_INFO_2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usDeviceSupport', ctypes.c_uint16),
    ('asConnInfo', struct__ATOM_CONNECTOR_INFO_I2C * 10),
    ('asIntSrcInfo', struct__ATOM_CONNECTOR_INC_SRC_BITMAP * 10),
     ]

class struct__ATOM_SUPPORTED_DEVICES_INFO_2d1(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usDeviceSupport', ctypes.c_uint16),
    ('asConnInfo', struct__ATOM_CONNECTOR_INFO_I2C * 16),
    ('asIntSrcInfo', struct__ATOM_CONNECTOR_INC_SRC_BITMAP * 16),
     ]

class struct__ATOM_MISC_CONTROL_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usFrequency', ctypes.c_uint16),
    ('ucPLL_ChargePump', ctypes.c_ubyte),
    ('ucPLL_DutyCycle', ctypes.c_ubyte),
    ('ucPLL_VCO_Gain', ctypes.c_ubyte),
    ('ucPLL_VoltageSwing', ctypes.c_ubyte),
     ]

class struct__ATOM_TMDS_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usMaxFrequency', ctypes.c_uint16),
    ('asMiscInfo', struct__ATOM_MISC_CONTROL_INFO * 4),
     ]

class struct__ATOM_ENCODER_ANALOG_ATTRIBUTE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucTVStandard', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 1),
     ]

class struct__ATOM_ENCODER_DIGITAL_ATTRIBUTE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucAttribute', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 1),
     ]

class struct__DVO_ENCODER_CONTROL_PARAMETERS(ctypes.Structure):
    pass

class union__ATOM_ENCODER_ATTRIBUTE(ctypes.Union):
    pass

ATOM_ENCODER_ANALOG_ATTRIBUTE = struct__ATOM_ENCODER_ANALOG_ATTRIBUTE
ATOM_ENCODER_DIGITAL_ATTRIBUTE = struct__ATOM_ENCODER_DIGITAL_ATTRIBUTE
union__ATOM_ENCODER_ATTRIBUTE._pack_ = True # source:False
union__ATOM_ENCODER_ATTRIBUTE._fields_ = [
    ('sAlgAttrib', ATOM_ENCODER_ANALOG_ATTRIBUTE),
    ('sDigAttrib', ATOM_ENCODER_DIGITAL_ATTRIBUTE),
]

ATOM_ENCODER_ATTRIBUTE = union__ATOM_ENCODER_ATTRIBUTE
struct__DVO_ENCODER_CONTROL_PARAMETERS._pack_ = True # source:False
struct__DVO_ENCODER_CONTROL_PARAMETERS._fields_ = [
    ('usPixelClock', ctypes.c_uint16),
    ('usEncoderID', ctypes.c_uint16),
    ('ucDeviceType', ctypes.c_ubyte),
    ('ucAction', ctypes.c_ubyte),
    ('usDevAttr', ATOM_ENCODER_ATTRIBUTE),
]

class struct__DVO_ENCODER_CONTROL_PS_ALLOCATION(ctypes.Structure):
    pass

DVO_ENCODER_CONTROL_PARAMETERS = struct__DVO_ENCODER_CONTROL_PARAMETERS
struct__DVO_ENCODER_CONTROL_PS_ALLOCATION._pack_ = True # source:False
struct__DVO_ENCODER_CONTROL_PS_ALLOCATION._fields_ = [
    ('sDVOEncoder', DVO_ENCODER_CONTROL_PARAMETERS),
    ('sReserved', WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS),
]

class struct__ATOM_XTMDS_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('usSingleLinkMaxFrequency', ctypes.c_uint16),
    ('sucI2cId', ATOM_I2C_ID_CONFIG_ACCESS),
    ('ucXtransimitterID', ctypes.c_ubyte),
    ('ucSupportedLink', ctypes.c_ubyte),
    ('ucSequnceAlterID', ctypes.c_ubyte),
    ('ucMasterAddress', ctypes.c_ubyte),
    ('ucSlaveAddress', ctypes.c_ubyte),
     ]

class struct__DFP_DPMS_STATUS_CHANGE_PARAMETERS(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEnable', ctypes.c_ubyte),
    ('ucDevice', ctypes.c_ubyte),
    ('ucPadding', ctypes.c_ubyte * 2),
     ]

class struct__ATOM_POWERMODE_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulMiscInfo', ctypes.c_uint32),
    ('ulReserved1', ctypes.c_uint32),
    ('ulReserved2', ctypes.c_uint32),
    ('usEngineClock', ctypes.c_uint16),
    ('usMemoryClock', ctypes.c_uint16),
    ('ucVoltageDropIndex', ctypes.c_ubyte),
    ('ucSelectedPanel_RefreshRate', ctypes.c_ubyte),
    ('ucMinTemperature', ctypes.c_ubyte),
    ('ucMaxTemperature', ctypes.c_ubyte),
    ('ucNumPciELanes', ctypes.c_ubyte),
     ]

class struct__ATOM_POWERMODE_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulMiscInfo', ctypes.c_uint32),
    ('ulMiscInfo2', ctypes.c_uint32),
    ('ulEngineClock', ctypes.c_uint32),
    ('ulMemoryClock', ctypes.c_uint32),
    ('ucVoltageDropIndex', ctypes.c_ubyte),
    ('ucSelectedPanel_RefreshRate', ctypes.c_ubyte),
    ('ucMinTemperature', ctypes.c_ubyte),
    ('ucMaxTemperature', ctypes.c_ubyte),
    ('ucNumPciELanes', ctypes.c_ubyte),
     ]

class struct__ATOM_POWERMODE_INFO_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulMiscInfo', ctypes.c_uint32),
    ('ulMiscInfo2', ctypes.c_uint32),
    ('ulEngineClock', ctypes.c_uint32),
    ('ulMemoryClock', ctypes.c_uint32),
    ('ucVoltageDropIndex', ctypes.c_ubyte),
    ('ucSelectedPanel_RefreshRate', ctypes.c_ubyte),
    ('ucMinTemperature', ctypes.c_ubyte),
    ('ucMaxTemperature', ctypes.c_ubyte),
    ('ucNumPciELanes', ctypes.c_ubyte),
    ('ucVDDCI_VoltageDropIndex', ctypes.c_ubyte),
     ]

class struct__ATOM_POWERPLAY_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucOverdriveThermalController', ctypes.c_ubyte),
    ('ucOverdriveI2cLine', ctypes.c_ubyte),
    ('ucOverdriveIntBitmap', ctypes.c_ubyte),
    ('ucOverdriveControllerAddress', ctypes.c_ubyte),
    ('ucSizeOfPowerModeEntry', ctypes.c_ubyte),
    ('ucNumOfPowerModeEntries', ctypes.c_ubyte),
    ('asPowerPlayInfo', struct__ATOM_POWERMODE_INFO * 8),
     ]

class struct__ATOM_POWERPLAY_INFO_V2(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucOverdriveThermalController', ctypes.c_ubyte),
    ('ucOverdriveI2cLine', ctypes.c_ubyte),
    ('ucOverdriveIntBitmap', ctypes.c_ubyte),
    ('ucOverdriveControllerAddress', ctypes.c_ubyte),
    ('ucSizeOfPowerModeEntry', ctypes.c_ubyte),
    ('ucNumOfPowerModeEntries', ctypes.c_ubyte),
    ('asPowerPlayInfo', struct__ATOM_POWERMODE_INFO_V2 * 8),
     ]

class struct__ATOM_POWERPLAY_INFO_V3(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', ATOM_COMMON_TABLE_HEADER),
    ('ucOverdriveThermalController', ctypes.c_ubyte),
    ('ucOverdriveI2cLine', ctypes.c_ubyte),
    ('ucOverdriveIntBitmap', ctypes.c_ubyte),
    ('ucOverdriveControllerAddress', ctypes.c_ubyte),
    ('ucSizeOfPowerModeEntry', ctypes.c_ubyte),
    ('ucNumOfPowerModeEntries', ctypes.c_ubyte),
    ('asPowerPlayInfo', struct__ATOM_POWERMODE_INFO_V3 * 8),
     ]

class struct__ATOM_HOLE_INFO(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usOffset', ctypes.c_uint16),
    ('usLength', ctypes.c_uint16),
     ]

class struct__ATOM_SERVICE_DESCRIPTION(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevision', ctypes.c_ubyte),
    ('ucAlgorithm', ctypes.c_ubyte),
    ('ucSignatureType', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('usSigOffset', ctypes.c_uint16),
    ('usSigLength', ctypes.c_uint16),
     ]

class struct__ATOM_SERVICE_INFO(ctypes.Structure):
    pass

ATOM_SERVICE_DESCRIPTION = struct__ATOM_SERVICE_DESCRIPTION
struct__ATOM_SERVICE_INFO._pack_ = True # source:False
struct__ATOM_SERVICE_INFO._fields_ = [
    ('asHeader', ATOM_COMMON_TABLE_HEADER),
    ('asDescr', ATOM_SERVICE_DESCRIPTION),
    ('ucholesNo', ctypes.c_ubyte),
    ('holes', struct__ATOM_HOLE_INFO * 1),
]

class struct_c__SA_AMD_ACPI_DESCRIPTION_HEADER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('Signature', ctypes.c_uint32),
    ('TableLength', ctypes.c_uint32),
    ('Revision', ctypes.c_ubyte),
    ('Checksum', ctypes.c_ubyte),
    ('OemId', ctypes.c_ubyte * 6),
    ('OemTableId', ctypes.c_ubyte * 8),
    ('OemRevision', ctypes.c_uint32),
    ('CreatorId', ctypes.c_uint32),
    ('CreatorRevision', ctypes.c_uint32),
     ]

class struct_c__SA_UEFI_ACPI_VFCT(ctypes.Structure):
    pass

AMD_ACPI_DESCRIPTION_HEADER = struct_c__SA_AMD_ACPI_DESCRIPTION_HEADER
struct_c__SA_UEFI_ACPI_VFCT._pack_ = True # source:False
struct_c__SA_UEFI_ACPI_VFCT._fields_ = [
    ('SHeader', AMD_ACPI_DESCRIPTION_HEADER),
    ('TableUUID', ctypes.c_ubyte * 16),
    ('VBIOSImageOffset', ctypes.c_uint32),
    ('Lib1ImageOffset', ctypes.c_uint32),
    ('Reserved', ctypes.c_uint32 * 4),
]

class struct_c__SA_VFCT_IMAGE_HEADER(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('PCIBus', ctypes.c_uint32),
    ('PCIDevice', ctypes.c_uint32),
    ('PCIFunction', ctypes.c_uint32),
    ('VendorID', ctypes.c_uint16),
    ('DeviceID', ctypes.c_uint16),
    ('SSVID', ctypes.c_uint16),
    ('SSID', ctypes.c_uint16),
    ('Revision', ctypes.c_uint32),
    ('ImageLength', ctypes.c_uint32),
     ]

class struct_c__SA_GOP_VBIOS_CONTENT(ctypes.Structure):
    pass

VFCT_IMAGE_HEADER = struct_c__SA_VFCT_IMAGE_HEADER
struct_c__SA_GOP_VBIOS_CONTENT._pack_ = True # source:False
struct_c__SA_GOP_VBIOS_CONTENT._fields_ = [
    ('VbiosHeader', VFCT_IMAGE_HEADER),
    ('VbiosContent', ctypes.c_ubyte * 1),
]

class struct_c__SA_GOP_LIB1_CONTENT(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('Lib1Header', VFCT_IMAGE_HEADER),
    ('Lib1Content', ctypes.c_ubyte * 1),
     ]

__all__ = \
    ['ADJUST_DISPLAY_PLL_INPUT_PARAMETERS_V3',
    'ADJUST_DISPLAY_PLL_OUTPUT_PARAMETERS_V3',
    'AMD_ACPI_DESCRIPTION_HEADER', 'ASIC_INIT_CLOCK_PARAMETERS',
    'ASIC_INIT_PARAMETERS', 'ASIC_INIT_PARAMETERS_V1_2',
    'ATOM_ASIC_PROFILE_VOLTAGE', 'ATOM_CLK_VOLT_CAPABILITY',
    'ATOM_COMMON_RECORD_HEADER', 'ATOM_COMMON_TABLE_HEADER',
    'ATOM_COMPUTE_CLOCK_FREQ', 'ATOM_CONNECTOR_INFO',
    'ATOM_CONNECTOR_INFO_ACCESS', 'ATOM_DIG_ENCODER_CONFIG_V2',
    'ATOM_DIG_ENCODER_CONFIG_V3', 'ATOM_DIG_ENCODER_CONFIG_V4',
    'ATOM_DIG_TRANSMITTER_CONFIG_V2',
    'ATOM_DIG_TRANSMITTER_CONFIG_V3',
    'ATOM_DIG_TRANSMITTER_CONFIG_V4',
    'ATOM_DIG_TRANSMITTER_CONFIG_V5', 'ATOM_DP_CONN_CHANNEL_MAPPING',
    'ATOM_DP_VS_MODE', 'ATOM_DP_VS_MODE_V4', 'ATOM_DTD_FORMAT',
    'ATOM_DVI_CONN_CHANNEL_MAPPING', 'ATOM_ENCODER_ANALOG_ATTRIBUTE',
    'ATOM_ENCODER_ATTRIBUTE', 'ATOM_ENCODER_DIGITAL_ATTRIBUTE',
    'ATOM_EVV_VOLTAGE_OBJECT_V3',
    'ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO',
    'ATOM_FIRMWARE_CAPABILITY', 'ATOM_FIRMWARE_CAPABILITY_ACCESS',
    'ATOM_GPIO_VOLTAGE_OBJECT_V3',
    'ATOM_HW_MISC_OPERATION_INPUT_PARAMETER_V1_1',
    'ATOM_I2C_ID_CONFIG', 'ATOM_I2C_ID_CONFIG_ACCESS',
    'ATOM_I2C_VOLTAGE_OBJECT_V3', 'ATOM_INIT_REG_BLOCK',
    'ATOM_INTEGRATED_SYSTEM_INFO_V1_10',
    'ATOM_INTEGRATED_SYSTEM_INFO_V1_8',
    'ATOM_INTEGRATED_SYSTEM_INFO_V6', 'ATOM_LCD_REFRESH_RATE_SUPPORT',
    'ATOM_LEAKAGE_VOLTAGE_OBJECT_V3',
    'ATOM_MASTER_LIST_OF_COMMAND_TABLES',
    'ATOM_MASTER_LIST_OF_DATA_TABLES', 'ATOM_MEMORY_FORMAT',
    'ATOM_MEMORY_SETTING_ID_CONFIG',
    'ATOM_MEMORY_SETTING_ID_CONFIG_ACCESS', 'ATOM_MODE_MISC_INFO',
    'ATOM_MODE_MISC_INFO_ACCESS', 'ATOM_SERVICE_DESCRIPTION',
    'ATOM_SVID2_VOLTAGE_OBJECT_V3', 'ATOM_S_MPLL_FB_DIVIDER',
    'ATOM_TABLE_ATTRIBUTE', 'ATOM_TDP_CONFIG', 'ATOM_TDP_CONFIG_BITS',
    'ATOM_VOLTAGE_CONTROL', 'ATOM_VOLTAGE_FORMULA',
    'ATOM_VOLTAGE_FORMULA_V2', 'ATOM_VOLTAGE_INFO_HEADER',
    'ATOM_VOLTAGE_OBJECT_HEADER_V3', 'CAMERA_DATA',
    'COMPUTE_GPU_CLOCK_INPUT_PARAMETERS_V1_7',
    'COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS',
    'COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V4',
    'CRTC_PIXEL_CLOCK_FREQ', 'DAC_LOAD_DETECTION_PARAMETERS',
    'DIG_ENCODER_CONTROL_PARAMETERS', 'DPHY_ELEC_PARA',
    'DP_ENCODER_SERVICE_PARAMETERS_V2',
    'DVO_ENCODER_CONTROL_PARAMETERS', 'EFUSE_LINEAR_FUNC_PARAM',
    'EFUSE_LOGISTIC_FUNC_PARAM', 'ENABLE_CRTC_PARAMETERS',
    'ENABLE_EXTERNAL_TMDS_ENCODER_PARAMETERS',
    'ENABLE_GRAPH_SURFACE_PARAMETERS',
    'ENABLE_HARDWARE_ICON_CURSOR_PARAMETERS',
    'ENABLE_SPREAD_SPECTRUM_ON_PPLL', 'ENABLE_YUV_PARAMETERS',
    'EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3', 'FLASHLIGHT_INFO',
    'LVDS_ENCODER_CONTROL_PARAMETERS_V2', 'PIXEL_CLOCK_PARAMETERS',
    'PIXEL_CLOCK_PARAMETERS_V3', 'PIXEL_CLOCK_PARAMETERS_V5',
    'PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2',
    'PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS', 'PRODUCT_BRANDING',
    'PTR_32_BIT_STRUCTURE', 'PTR_32_BIT_UNION',
    'SET_DCE_CLOCK_PARAMETERS_V1_1', 'SET_DCE_CLOCK_PARAMETERS_V2_1',
    'SET_ENGINE_CLOCK_PS_ALLOCATION', 'SET_VOLTAGE_PARAMETERS',
    'TV_ENCODER_CONTROL_PARAMETERS', 'VBE_1_2_INFO_BLOCK_UPDATABLE',
    'VBE_2_0_INFO_BLOCK_UPDATABLE', 'VBE_VERSION_UNION',
    'VFCT_IMAGE_HEADER', 'WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS',
    'struct_POWER_CONNECTOR_DETECTION_PS_ALLOCATION',
    'struct_SW_I2C_CNTL_DATA_PARAMETERS',
    'struct__ADJUST_DISPLAY_PLL_INPUT_PARAMETERS_V3',
    'struct__ADJUST_DISPLAY_PLL_OUTPUT_PARAMETERS_V3',
    'struct__ADJUST_DISPLAY_PLL_PARAMETERS',
    'struct__ADJUST_DISPLAY_PLL_PS_ALLOCATION_V3',
    'struct__ASIC_ENCODER_INFO', 'struct__ASIC_INIT_CLOCK_PARAMETERS',
    'struct__ASIC_INIT_PARAMETERS',
    'struct__ASIC_INIT_PARAMETERS_V1_2',
    'struct__ASIC_INIT_PS_ALLOCATION',
    'struct__ASIC_INIT_PS_ALLOCATION_V1_2',
    'struct__ASIC_TRANSMITTER_INFO',
    'struct__ASIC_TRANSMITTER_INFO_V2',
    'struct__ATOM_ADJUST_MEMORY_CLOCK_FREQ',
    'struct__ATOM_ANALOG_TV_INFO',
    'struct__ATOM_ASIC_INTERNAL_SS_INFO',
    'struct__ATOM_ASIC_INTERNAL_SS_INFO_V2',
    'struct__ATOM_ASIC_INTERNAL_SS_INFO_V3',
    'struct__ATOM_ASIC_MVDD_INFO',
    'struct__ATOM_ASIC_PROFILE_VOLTAGE',
    'struct__ATOM_ASIC_PROFILING_INFO',
    'struct__ATOM_ASIC_PROFILING_INFO_V2_1',
    'struct__ATOM_ASIC_PROFILING_INFO_V3_1',
    'struct__ATOM_ASIC_PROFILING_INFO_V3_2',
    'struct__ATOM_ASIC_PROFILING_INFO_V3_3',
    'struct__ATOM_ASIC_PROFILING_INFO_V3_4',
    'struct__ATOM_ASIC_PROFILING_INFO_V3_5',
    'struct__ATOM_ASIC_PROFILING_INFO_V3_6',
    'struct__ATOM_ASIC_SS_ASSIGNMENT',
    'struct__ATOM_ASIC_SS_ASSIGNMENT_V2',
    'struct__ATOM_ASIC_SS_ASSIGNMENT_V3',
    'struct__ATOM_AVAILABLE_SCLK_LIST',
    'struct__ATOM_BIOS_INT_TVSTD_MODE',
    'struct__ATOM_BRACKET_LAYOUT_RECORD',
    'struct__ATOM_CLK_VOLT_CAPABILITY',
    'struct__ATOM_CLK_VOLT_CAPABILITY_V2',
    'struct__ATOM_COMMON_RECORD_HEADER',
    'struct__ATOM_COMMON_ROM_COMMAND_TABLE_HEADER',
    'struct__ATOM_COMMON_TABLE_HEADER',
    'struct__ATOM_COMPONENT_VIDEO_INFO',
    'struct__ATOM_COMPONENT_VIDEO_INFO_V21',
    'struct__ATOM_COMPUTE_CLOCK_FREQ',
    'struct__ATOM_CONNECTOR_AUXDDC_LUT_RECORD',
    'struct__ATOM_CONNECTOR_CF_RECORD',
    'struct__ATOM_CONNECTOR_CVTV_SHARE_DIN_RECORD',
    'struct__ATOM_CONNECTOR_DEVICE_TAG',
    'struct__ATOM_CONNECTOR_DEVICE_TAG_RECORD',
    'struct__ATOM_CONNECTOR_DVI_EXT_INPUT_RECORD',
    'struct__ATOM_CONNECTOR_FORCED_TMDS_CAP_RECORD',
    'struct__ATOM_CONNECTOR_HARDCODE_DTD_RECORD',
    'struct__ATOM_CONNECTOR_HPDPIN_LUT_RECORD',
    'struct__ATOM_CONNECTOR_INC_SRC_BITMAP',
    'struct__ATOM_CONNECTOR_INFO', 'struct__ATOM_CONNECTOR_INFO_I2C',
    'struct__ATOM_CONNECTOR_LAYOUT_INFO',
    'struct__ATOM_CONNECTOR_PCIE_SUBCONNECTOR_RECORD',
    'struct__ATOM_CONNECTOR_REMOTE_CAP_RECORD',
    'struct__ATOM_DAC_INFO', 'struct__ATOM_DIG_ENCODER_CONFIG_V2',
    'struct__ATOM_DIG_ENCODER_CONFIG_V3',
    'struct__ATOM_DIG_ENCODER_CONFIG_V4',
    'struct__ATOM_DIG_TRANSMITTER_CONFIG_V2',
    'struct__ATOM_DIG_TRANSMITTER_CONFIG_V3',
    'struct__ATOM_DIG_TRANSMITTER_CONFIG_V4',
    'struct__ATOM_DIG_TRANSMITTER_CONFIG_V5',
    'struct__ATOM_DISPLAY_DEVICE_PRIORITY_INFO',
    'struct__ATOM_DISPLAY_EXTERNAL_OBJECT_PATH',
    'struct__ATOM_DISPLAY_OBJECT_PATH',
    'struct__ATOM_DISPLAY_OBJECT_PATH_TABLE',
    'struct__ATOM_DISP_CLOCK_ID', 'struct__ATOM_DISP_OUT_INFO',
    'struct__ATOM_DISP_OUT_INFO_V2', 'struct__ATOM_DISP_OUT_INFO_V3',
    'struct__ATOM_DPCD_INFO', 'struct__ATOM_DP_CONN_CHANNEL_MAPPING',
    'struct__ATOM_DP_VS_MODE', 'struct__ATOM_DP_VS_MODE_V4',
    'struct__ATOM_DP_VS_MODE_V4_0_0', 'struct__ATOM_DRAM_DATA_REMAP',
    'struct__ATOM_DTD_FORMAT',
    'struct__ATOM_DVI_CONN_CHANNEL_MAPPING',
    'struct__ATOM_ENCODER_ANALOG_ATTRIBUTE',
    'struct__ATOM_ENCODER_CAP_RECORD',
    'struct__ATOM_ENCODER_CAP_RECORD_0_0',
    'struct__ATOM_ENCODER_CAP_RECORD_V2',
    'struct__ATOM_ENCODER_CAP_RECORD_V2_0_0',
    'struct__ATOM_ENCODER_DIGITAL_ATTRIBUTE',
    'struct__ATOM_ENCODER_DVO_CF_RECORD',
    'struct__ATOM_ENCODER_FPGA_CONTROL_RECORD',
    'struct__ATOM_EVV_DPM_INFO', 'struct__ATOM_EVV_VOLTAGE_OBJECT_V3',
    'struct__ATOM_EXTERNAL_DISPLAY_CONNECTION_INFO',
    'struct__ATOM_FAKE_EDID_PATCH_RECORD',
    'struct__ATOM_FIRMWARE_CAPABILITY', 'struct__ATOM_FIRMWARE_INFO',
    'struct__ATOM_FIRMWARE_INFO_V1_2',
    'struct__ATOM_FIRMWARE_INFO_V1_3',
    'struct__ATOM_FIRMWARE_INFO_V1_4',
    'struct__ATOM_FIRMWARE_INFO_V2_1',
    'struct__ATOM_FIRMWARE_INFO_V2_2',
    'struct__ATOM_FIRMWARE_VRAM_RESERVE_INFO',
    'struct__ATOM_FIRMWARE_VRAM_RESERVE_INFO_V1_5',
    'struct__ATOM_FUSION_SYSTEM_INFO_V1',
    'struct__ATOM_FUSION_SYSTEM_INFO_V2',
    'struct__ATOM_FUSION_SYSTEM_INFO_V3',
    'struct__ATOM_GFX_INFO_V2_1', 'struct__ATOM_GPIO_I2C_ASSIGMENT',
    'struct__ATOM_GPIO_I2C_INFO', 'struct__ATOM_GPIO_INFO',
    'struct__ATOM_GPIO_PIN_ASSIGNMENT',
    'struct__ATOM_GPIO_PIN_CONTROL_PAIR', 'struct__ATOM_GPIO_PIN_LUT',
    'struct__ATOM_GPIO_VOLTAGE_OBJECT_V3',
    'struct__ATOM_GPU_VIRTUALIZATION_INFO_V2_1',
    'struct__ATOM_HOLE_INFO', 'struct__ATOM_HPD_INT_RECORD',
    'struct__ATOM_HW_MISC_OPERATION_INPUT_PARAMETER_V1_1',
    'struct__ATOM_HW_MISC_OPERATION_OUTPUT_PARAMETER_V1_1',
    'struct__ATOM_HW_MISC_OPERATION_PS_ALLOCATION',
    'struct__ATOM_I2C_DATA_RECORD',
    'struct__ATOM_I2C_DEVICE_SETUP_INFO',
    'struct__ATOM_I2C_ID_CONFIG', 'struct__ATOM_I2C_RECORD',
    'struct__ATOM_I2C_REG_INFO', 'struct__ATOM_I2C_VOLTAGE_OBJECT_V3',
    'struct__ATOM_INIT_REG_BLOCK',
    'struct__ATOM_INIT_REG_INDEX_FORMAT',
    'struct__ATOM_INTEGRATED_SYSTEM_INFO',
    'struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_10',
    'struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_7',
    'struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_8',
    'struct__ATOM_INTEGRATED_SYSTEM_INFO_V1_9',
    'struct__ATOM_INTEGRATED_SYSTEM_INFO_V2',
    'struct__ATOM_INTEGRATED_SYSTEM_INFO_V5',
    'struct__ATOM_INTEGRATED_SYSTEM_INFO_V6',
    'struct__ATOM_JTAG_RECORD', 'struct__ATOM_LCD_INFO_V13',
    'struct__ATOM_LCD_MODE_CONTROL_CAP',
    'struct__ATOM_LCD_REFRESH_RATE_SUPPORT',
    'struct__ATOM_LCD_RTS_RECORD',
    'struct__ATOM_LEAKAGE_VOLTAGE_OBJECT_V3',
    'struct__ATOM_LEAKID_VOLTAGE', 'struct__ATOM_LVDS_INFO',
    'struct__ATOM_LVDS_INFO_V12', 'struct__ATOM_MASTER_COMMAND_TABLE',
    'struct__ATOM_MASTER_DATA_TABLE',
    'struct__ATOM_MASTER_LIST_OF_COMMAND_TABLES',
    'struct__ATOM_MASTER_LIST_OF_DATA_TABLES',
    'struct__ATOM_MC_INIT_PARAM_TABLE',
    'struct__ATOM_MC_INIT_PARAM_TABLE_V2_1',
    'struct__ATOM_MEMORY_FORMAT',
    'struct__ATOM_MEMORY_SETTING_DATA_BLOCK',
    'struct__ATOM_MEMORY_SETTING_ID_CONFIG',
    'struct__ATOM_MEMORY_TIMING_FORMAT',
    'struct__ATOM_MEMORY_TIMING_FORMAT_2_0',
    'struct__ATOM_MEMORY_TIMING_FORMAT_V1',
    'struct__ATOM_MEMORY_TIMING_FORMAT_V2',
    'struct__ATOM_MEMORY_TRAINING_INFO',
    'struct__ATOM_MEMORY_TRAINING_INFO_V3_1',
    'struct__ATOM_MEMORY_VENDOR_BLOCK',
    'struct__ATOM_MERGED_VOLTAGE_OBJECT_V3',
    'struct__ATOM_MISC_CONTROL_INFO', 'struct__ATOM_MODE_MISC_INFO',
    'struct__ATOM_MODE_TIMING',
    'struct__ATOM_MULTIMEDIA_CAPABILITY_INFO',
    'struct__ATOM_MULTIMEDIA_CONFIG_INFO', 'struct__ATOM_OBJECT',
    'struct__ATOM_OBJECT_GPIO_CNTL_RECORD',
    'struct__ATOM_OBJECT_HEADER', 'struct__ATOM_OBJECT_HEADER_V3',
    'struct__ATOM_OBJECT_LINK_RECORD', 'struct__ATOM_OBJECT_TABLE',
    'struct__ATOM_OEM_INFO', 'struct__ATOM_OUTPUT_PROTECTION_RECORD',
    'struct__ATOM_PANEL_RESOLUTION_PATCH_RECORD',
    'struct__ATOM_PATCH_RECORD_MODE', 'struct__ATOM_POWERMODE_INFO',
    'struct__ATOM_POWERMODE_INFO_V2',
    'struct__ATOM_POWERMODE_INFO_V3', 'struct__ATOM_POWERPLAY_INFO',
    'struct__ATOM_POWERPLAY_INFO_V2',
    'struct__ATOM_POWERPLAY_INFO_V3',
    'struct__ATOM_POWER_SOURCE_INFO',
    'struct__ATOM_POWER_SOURCE_OBJECT',
    'struct__ATOM_REG_INIT_SETTING', 'struct__ATOM_ROM_HEADER',
    'struct__ATOM_ROM_HEADER_V2_1',
    'struct__ATOM_ROUTER_DATA_CLOCK_PATH_SELECT_RECORD',
    'struct__ATOM_ROUTER_DDC_PATH_SELECT_RECORD',
    'struct__ATOM_SCLK_FCW_RANGE_ENTRY_V1',
    'struct__ATOM_SERVICE_DESCRIPTION', 'struct__ATOM_SERVICE_INFO',
    'struct__ATOM_SMU_INFO_V2_1',
    'struct__ATOM_SPREAD_SPECTRUM_ASSIGNMENT',
    'struct__ATOM_SPREAD_SPECTRUM_INFO',
    'struct__ATOM_SRC_DST_TABLE_FOR_ONE_OBJECT',
    'struct__ATOM_STANDARD_VESA_TIMING', 'struct__ATOM_STD_FORMAT',
    'struct__ATOM_SUPPORTED_DEVICES_INFO',
    'struct__ATOM_SUPPORTED_DEVICES_INFO_2',
    'struct__ATOM_SUPPORTED_DEVICES_INFO_2d1',
    'struct__ATOM_SVID2_VOLTAGE_OBJECT_V3',
    'struct__ATOM_S_MPLL_FB_DIVIDER', 'struct__ATOM_TABLE_ATTRIBUTE',
    'struct__ATOM_TDP_CONFIG_BITS', 'struct__ATOM_TMDS_INFO',
    'struct__ATOM_TV_MODE', 'struct__ATOM_TV_MODE_SCALER_PTR',
    'struct__ATOM_VESA_TO_EXTENDED_MODE',
    'struct__ATOM_VESA_TO_INTENAL_MODE_LUT',
    'struct__ATOM_VOLTAGE_CONTROL', 'struct__ATOM_VOLTAGE_FORMULA',
    'struct__ATOM_VOLTAGE_FORMULA_V2', 'struct__ATOM_VOLTAGE_INFO',
    'struct__ATOM_VOLTAGE_INFO_HEADER', 'struct__ATOM_VOLTAGE_OBJECT',
    'struct__ATOM_VOLTAGE_OBJECT_HEADER_V3',
    'struct__ATOM_VOLTAGE_OBJECT_INFO',
    'struct__ATOM_VOLTAGE_OBJECT_INFO_V2',
    'struct__ATOM_VOLTAGE_OBJECT_INFO_V3_1',
    'struct__ATOM_VOLTAGE_OBJECT_V2',
    'struct__ATOM_VRAM_GPIO_DETECTION_INFO',
    'struct__ATOM_VRAM_INFO_HEADER_V2_1',
    'struct__ATOM_VRAM_INFO_HEADER_V2_2', 'struct__ATOM_VRAM_INFO_V2',
    'struct__ATOM_VRAM_INFO_V3', 'struct__ATOM_VRAM_INFO_V4',
    'struct__ATOM_VRAM_MODULE_V1', 'struct__ATOM_VRAM_MODULE_V2',
    'struct__ATOM_VRAM_MODULE_V3', 'struct__ATOM_VRAM_MODULE_V4',
    'struct__ATOM_VRAM_MODULE_V5', 'struct__ATOM_VRAM_MODULE_V6',
    'struct__ATOM_VRAM_MODULE_V7', 'struct__ATOM_VRAM_MODULE_V8',
    'struct__ATOM_VRAM_USAGE_BY_FIRMWARE',
    'struct__ATOM_VRAM_USAGE_BY_FIRMWARE_V1_5',
    'struct__ATOM_XTMDS_INFO', 'struct__BLANK_CRTC_PARAMETERS',
    'struct__CAMERA_DATA', 'struct__CAMERA_MODULE_INFO',
    'struct__CLOCK_CONDITION_REGESTER_INFO',
    'struct__CLOCK_CONDITION_SETTING_ENTRY',
    'struct__CLOCK_CONDITION_SETTING_INFO',
    'struct__COMPASSIONATE_DATA',
    'struct__COMPUTE_GPU_CLOCK_INPUT_PARAMETERS_V1_6',
    'struct__COMPUTE_GPU_CLOCK_INPUT_PARAMETERS_V1_7',
    'struct__COMPUTE_GPU_CLOCK_OUTPUT_PARAMETERS_V1_6',
    'struct__COMPUTE_GPU_CLOCK_OUTPUT_PARAMETERS_V1_7',
    'struct__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1',
    'struct__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_2',
    'struct__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_3',
    'struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS',
    'struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V2',
    'struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V3',
    'struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V4',
    'struct__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5',
    'struct__CRTC_PIXEL_CLOCK_FREQ',
    'struct__DAC_ENCODER_CONTROL_PARAMETERS',
    'struct__DAC_LOAD_DETECTION_PARAMETERS',
    'struct__DAC_LOAD_DETECTION_PS_ALLOCATION',
    'struct__DFP_DPMS_STATUS_CHANGE_PARAMETERS',
    'struct__DIG_ENCODER_CONTROL_PARAMETERS',
    'struct__DIG_ENCODER_CONTROL_PARAMETERS_V2',
    'struct__DIG_ENCODER_CONTROL_PARAMETERS_V3',
    'struct__DIG_ENCODER_CONTROL_PARAMETERS_V4',
    'struct__DIG_TRANSMITTER_CONTROL_PARAMETERS',
    'struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_5',
    'struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_6',
    'struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V2',
    'struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V3',
    'struct__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4',
    'struct__DIG_TRANSMITTER_INFO_HEADER_V3_1',
    'struct__DIG_TRANSMITTER_INFO_HEADER_V3_2',
    'struct__DIG_TRANSMITTER_INFO_HEADER_V3_3',
    'struct__DISPLAY_DEVICE_OUTPUT_CONTROL_PARAMETERS',
    'struct__DPHY_ELEC_PARA', 'struct__DPHY_TIMING_PARA',
    'struct__DP_ENCODER_SERVICE_PARAMETERS',
    'struct__DP_ENCODER_SERVICE_PARAMETERS_V2',
    'struct__DP_ENCODER_SERVICE_PS_ALLOCATION_V2',
    'struct__DP_PANEL_MODE_SETUP_PARAMETERS_V5',
    'struct__DVO_ENCODER_CONTROL_PARAMETERS',
    'struct__DVO_ENCODER_CONTROL_PARAMETERS_V1_4',
    'struct__DVO_ENCODER_CONTROL_PARAMETERS_V3',
    'struct__DVO_ENCODER_CONTROL_PS_ALLOCATION',
    'struct__DYNAMICE_ENGINE_SETTINGS_PARAMETER',
    'struct__DYNAMICE_MC_DPM_SETTINGS_PARAMETER',
    'struct__DYNAMICE_MEMORY_SETTINGS_PARAMETER',
    'struct__DYNAMIC_CLOCK_GATING_PARAMETERS',
    'struct__EFUSE_INPUT_PARAMETER',
    'struct__EFUSE_LINEAR_FUNC_PARAM',
    'struct__EFUSE_LOGISTIC_FUNC_PARAM',
    'struct__ENABLE_ASIC_STATIC_PWR_MGT_PARAMETERS',
    'struct__ENABLE_CRTC_PARAMETERS',
    'struct__ENABLE_DISP_POWER_GATING_PARAMETERS_V2_1',
    'struct__ENABLE_DISP_POWER_GATING_PS_ALLOCATION',
    'struct__ENABLE_EXTERNAL_TMDS_ENCODER_PARAMETERS',
    'struct__ENABLE_EXTERNAL_TMDS_ENCODER_PS_ALLOCATION',
    'struct__ENABLE_EXTERNAL_TMDS_ENCODER_PS_ALLOCATION_V2',
    'struct__ENABLE_GRAPH_SURFACE_PARAMETERS',
    'struct__ENABLE_GRAPH_SURFACE_PARAMETERS_V1_2',
    'struct__ENABLE_GRAPH_SURFACE_PARAMETERS_V1_3',
    'struct__ENABLE_GRAPH_SURFACE_PARAMETERS_V1_4',
    'struct__ENABLE_GRAPH_SURFACE_PS_ALLOCATION',
    'struct__ENABLE_HARDWARE_ICON_CURSOR_PARAMETERS',
    'struct__ENABLE_HARDWARE_ICON_CURSOR_PS_ALLOCATION',
    'struct__ENABLE_LVDS_SS_PARAMETERS',
    'struct__ENABLE_LVDS_SS_PARAMETERS_V2',
    'struct__ENABLE_SCALER_PARAMETERS',
    'struct__ENABLE_SPREAD_SPECTRUM_ON_PPLL',
    'struct__ENABLE_SPREAD_SPECTRUM_ON_PPLL_V2',
    'struct__ENABLE_SPREAD_SPECTRUM_ON_PPLL_V3',
    'struct__ENABLE_YUV_PARAMETERS',
    'struct__ENCODER_GENERIC_CMD_PARAMETERS_V5',
    'struct__ENCODER_LINK_SETUP_PARAMETERS_V5',
    'struct__ENCODER_STREAM_SETUP_PARAMETERS_V5',
    'struct__EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3',
    'struct__EXTERNAL_ENCODER_CONTROL_PS_ALLOCATION',
    'struct__EXTERNAL_ENCODER_CONTROL_PS_ALLOCATION_V3',
    'struct__EXT_DISPLAY_PATH', 'struct__FLASHLIGHT_INFO',
    'struct__GET_DISPLAY_SURFACE_SIZE_PARAMETERS',
    'struct__GET_DISPLAY_SURFACE_SIZE_PARAMETERS_V2',
    'struct__GET_DISP_PLL_STATUS_INPUT_PARAMETERS_V2',
    'struct__GET_DISP_PLL_STATUS_INPUT_PARAMETERS_V3',
    'struct__GET_DISP_PLL_STATUS_OUTPUT_PARAMETERS_V2',
    'struct__GET_ENGINE_CLOCK_PARAMETERS',
    'struct__GET_EVV_VOLTAGE_INFO_OUTPUT_PARAMETER_V1_2',
    'struct__GET_EVV_VOLTAGE_INFO_OUTPUT_PARAMETER_V1_3',
    'struct__GET_LEAKAGE_VOLTAGE_INFO_OUTPUT_PARAMETER_V1_1',
    'struct__GET_MEMORY_CLOCK_PARAMETERS',
    'struct__GET_SMU_CLOCK_INFO_INPUT_PARAMETER_V2_1',
    'struct__GET_SMU_CLOCK_INFO_OUTPUT_PARAMETER_V2_1',
    'struct__GET_VOLTAGE_INFO_INPUT_PARAMETER_V1_1',
    'struct__GET_VOLTAGE_INFO_INPUT_PARAMETER_V1_2',
    'struct__GET_VOLTAGE_INFO_INPUT_PARAMETER_V1_3',
    'struct__GET_VOLTAGE_INFO_OUTPUT_PARAMETER_V1_1',
    'struct__GFX_HAVESTING_PARAMETERS',
    'struct__GPIO_PIN_CONTROL_PARAMETERS',
    'struct__INDIRECT_IO_ACCESS',
    'struct__INTERRUPT_SERVICE_PARAMETERS_V2',
    'struct__LEAKAGE_VOLTAGE_LUT_ENTRY_V2',
    'struct__LVDS_ENCODER_CONTROL_PARAMETERS',
    'struct__LVDS_ENCODER_CONTROL_PARAMETERS_V2',
    'struct__LVTMA_OUTPUT_CONTROL_PARAMETERS_V2',
    'struct__MCuCodeHeader', 'struct__MEMORY_CLEAN_UP_PARAMETERS',
    'struct__MEMORY_PLLINIT_PARAMETERS',
    'struct__MEMORY_TRAINING_PARAMETERS',
    'struct__MEMORY_TRAINING_PARAMETERS_V1_2',
    'struct__PALETTE_DATA_CONTROL_PARAMETERS_V3',
    'struct__PHY_ANALOG_SETTING_INFO',
    'struct__PHY_ANALOG_SETTING_INFO_V2',
    'struct__PHY_CONDITION_REG_INFO',
    'struct__PHY_CONDITION_REG_INFO_V2',
    'struct__PHY_CONDITION_REG_VAL',
    'struct__PHY_CONDITION_REG_VAL_V2',
    'struct__PIXEL_CLOCK_PARAMETERS',
    'struct__PIXEL_CLOCK_PARAMETERS_V2',
    'struct__PIXEL_CLOCK_PARAMETERS_V3',
    'struct__PIXEL_CLOCK_PARAMETERS_V5',
    'struct__PIXEL_CLOCK_PARAMETERS_V6',
    'struct__PIXEL_CLOCK_PARAMETERS_V7',
    'struct__POWER_CONNECTOR_DETECTION_PARAMETERS',
    'struct__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS',
    'struct__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2',
    'struct__PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS',
    'struct__PRODUCT_BRANDING', 'struct__PTR_32_BIT_STRUCTURE',
    'struct__READ_EDID_FROM_HW_I2C_DATA_PARAMETERS',
    'struct__SELECT_CRTC_SOURCE_PARAMETERS',
    'struct__SELECT_CRTC_SOURCE_PARAMETERS_V2',
    'struct__SELECT_CRTC_SOURCE_PARAMETERS_V3',
    'struct__SET_CRTC_OVERSCAN_PARAMETERS',
    'struct__SET_CRTC_REPLICATION_PARAMETERS',
    'struct__SET_CRTC_TIMING_PARAMETERS',
    'struct__SET_CRTC_USING_DTD_TIMING_PARAMETERS',
    'struct__SET_DCE_CLOCK_PARAMETERS_V1_1',
    'struct__SET_DCE_CLOCK_PARAMETERS_V2_1',
    'struct__SET_DCE_CLOCK_PS_ALLOCATION_V1_1',
    'struct__SET_DCE_CLOCK_PS_ALLOCATION_V2_1',
    'struct__SET_ENGINE_CLOCK_PARAMETERS',
    'struct__SET_ENGINE_CLOCK_PS_ALLOCATION',
    'struct__SET_ENGINE_CLOCK_PS_ALLOCATION_V1_2',
    'struct__SET_HWBLOCK_INSTANCE_PARAMETER_V2',
    'struct__SET_MEMORY_CLOCK_PARAMETERS',
    'struct__SET_MEMORY_CLOCK_PS_ALLOCATION',
    'struct__SET_PIXEL_CLOCK_PS_ALLOCATION',
    'struct__SET_UP_HW_I2C_DATA_PARAMETERS',
    'struct__SET_VOLTAGE_PARAMETERS',
    'struct__SET_VOLTAGE_PARAMETERS_V1_3',
    'struct__SET_VOLTAGE_PARAMETERS_V2',
    'struct__SET_VOLTAGE_PS_ALLOCATION',
    'struct__SW_I2C_IO_DATA_PARAMETERS',
    'struct__TV_ENCODER_CONTROL_PARAMETERS',
    'struct__TV_ENCODER_CONTROL_PS_ALLOCATION',
    'struct__VBE_1_2_INFO_BLOCK_UPDATABLE',
    'struct__VBE_2_0_INFO_BLOCK_UPDATABLE', 'struct__VBE_FP_INFO',
    'struct__VBE_INFO_BLOCK', 'struct__VBIOS_ROM_HEADER',
    'struct__VESA_MODE_INFO_BLOCK', 'struct__VOLTAGE_LUT_ENTRY',
    'struct__VOLTAGE_LUT_ENTRY_V2',
    'struct__WRITE_ONE_BYTE_HW_I2C_DATA_PARAMETERS',
    'struct_c__SA_AMD_ACPI_DESCRIPTION_HEADER',
    'struct_c__SA_GOP_LIB1_CONTENT', 'struct_c__SA_GOP_VBIOS_CONTENT',
    'struct_c__SA_UEFI_ACPI_VFCT', 'struct_c__SA_VFCT_IMAGE_HEADER',
    'union__ADJUST_DISPLAY_PLL_PARAMETERS_0',
    'union__ADJUST_DISPLAY_PLL_PS_ALLOCATION_V3_0',
    'union__ATOM_ASIC_PROFILING_INFO_V3_3_0',
    'union__ATOM_CONNECTOR_INFO_ACCESS',
    'union__ATOM_DP_VS_MODE_V4_0', 'union__ATOM_ENCODER_ATTRIBUTE',
    'union__ATOM_ENCODER_CAP_RECORD_0',
    'union__ATOM_ENCODER_CAP_RECORD_V2_0',
    'union__ATOM_FIRMWARE_CAPABILITY_ACCESS',
    'union__ATOM_I2C_ID_CONFIG_ACCESS', 'union__ATOM_LCD_INFO_V13_0',
    'union__ATOM_MEMORY_FORMAT_0', 'union__ATOM_MEMORY_FORMAT_1',
    'union__ATOM_MEMORY_SETTING_ID_CONFIG_ACCESS',
    'union__ATOM_MEMORY_TIMING_FORMAT_0',
    'union__ATOM_MEMORY_TIMING_FORMAT_1',
    'union__ATOM_MEMORY_TIMING_FORMAT_2',
    'union__ATOM_MODE_MISC_INFO_ACCESS', 'union__ATOM_TDP_CONFIG',
    'union__ATOM_VOLTAGE_OBJECT_V3', 'union__ATOM_VRAM_MODULE_V4_0',
    'union__ATOM_VRAM_MODULE_V4_1',
    'union__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1_0',
    'union__COMPUTE_MEMORY_CLOCK_PARAM_PARAMETERS_V2_1_1',
    'union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V3_0',
    'union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5_0',
    'union__COMPUTE_MEMORY_ENGINE_PLL_PARAMETERS_V5_1',
    'union__DIG_ENCODER_CONTROL_PARAMETERS_V3_0',
    'union__DIG_ENCODER_CONTROL_PARAMETERS_V4_0',
    'union__DIG_ENCODER_CONTROL_PARAMETERS_V4_1',
    'union__DIG_TRANSMITTER_CONTROL_PARAMETERS_0',
    'union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_5_0',
    'union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V1_6_0',
    'union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V2_0',
    'union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V3_0',
    'union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_0',
    'union__DIG_TRANSMITTER_CONTROL_PARAMETERS_V4_1',
    'union__DP_ENCODER_SERVICE_PARAMETERS_0',
    'union__EXTERNAL_ENCODER_CONTROL_PARAMETERS_V3_0',
    'union__EXT_DISPLAY_PATH_0',
    'union__GET_DISPLAY_SURFACE_SIZE_PARAMETERS_V2_0',
    'union__PIXEL_CLOCK_PARAMETERS_V3_0',
    'union__PIXEL_CLOCK_PARAMETERS_V5_0',
    'union__PIXEL_CLOCK_PARAMETERS_V6_0',
    'union__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_0',
    'union__PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2_0',
    'union__PROCESS_I2C_CHANNEL_TRANSACTION_PARAMETERS_0',
    'union__PTR_32_BIT_UNION', 'union__VBE_VERSION_UNION']
