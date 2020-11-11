# -*- coding: utf-8 -*-
#
# TARGET arch is: ['--include', 'stdint.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '--include', 'linux/drivers/gpu/drm/amd/include/atom-types.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '--include', 'linux/drivers/gpu/drm/amd/include/atomfirmware.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '--include', 'linux/drivers/gpu/drm/amd/powerplay/inc/smu11_driver_if_navi10.h', '']
# WORD_SIZE is: 8
# POINTER_SIZE is: 8
# LONGDOUBLE_SIZE is: 16
#
import ctypes




class struct_atom_common_table_header(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('structuresize', ctypes.c_uint16),
    ('format_revision', ctypes.c_ubyte),
    ('content_revision', ctypes.c_ubyte),
     ]

class struct_c__SA_I2cControllerConfig_t(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('Enabled', ctypes.c_ubyte),
    ('Speed', ctypes.c_ubyte),
    ('Padding', ctypes.c_ubyte * 2),
    ('SlaveAddress', ctypes.c_uint32),
    ('ControllerPort', ctypes.c_ubyte),
    ('ControllerName', ctypes.c_ubyte),
    ('ThermalThrotter', ctypes.c_ubyte),
    ('I2cProtocol', ctypes.c_ubyte),
     ]

class struct_c__SA_QuadraticInt_t(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('a', ctypes.c_uint32),
    ('b', ctypes.c_uint32),
    ('c', ctypes.c_uint32),
     ]

class struct_c__SA_LinearInt_t(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('m', ctypes.c_uint32),
    ('b', ctypes.c_uint32),
     ]

class struct_c__SA_DroopInt_t(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('a', ctypes.c_uint32),
    ('b', ctypes.c_uint32),
    ('c', ctypes.c_uint32),
     ]

class struct_c__SA_DpmDescriptor_t(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('VoltageMode', ctypes.c_ubyte),
    ('SnapToDiscrete', ctypes.c_ubyte),
    ('NumDiscreteLevels', ctypes.c_ubyte),
    ('Padding', ctypes.c_ubyte),
    ('ConversionToAvfsClk', struct_c__SA_LinearInt_t),
    ('SsCurve', struct_c__SA_QuadraticInt_t),
     ]

class struct_c__SA_PPTable_t(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('Version', ctypes.c_uint32),
    ('FeaturesToRun', ctypes.c_uint32 * 2),
    ('SocketPowerLimitAc', ctypes.c_uint16 * 4),
    ('SocketPowerLimitAcTau', ctypes.c_uint16 * 4),
    ('SocketPowerLimitDc', ctypes.c_uint16 * 4),
    ('SocketPowerLimitDcTau', ctypes.c_uint16 * 4),
    ('TdcLimitSoc', ctypes.c_uint16),
    ('TdcLimitSocTau', ctypes.c_uint16),
    ('TdcLimitGfx', ctypes.c_uint16),
    ('TdcLimitGfxTau', ctypes.c_uint16),
    ('TedgeLimit', ctypes.c_uint16),
    ('ThotspotLimit', ctypes.c_uint16),
    ('TmemLimit', ctypes.c_uint16),
    ('Tvr_gfxLimit', ctypes.c_uint16),
    ('Tvr_mem0Limit', ctypes.c_uint16),
    ('Tvr_mem1Limit', ctypes.c_uint16),
    ('Tvr_socLimit', ctypes.c_uint16),
    ('Tliquid0Limit', ctypes.c_uint16),
    ('Tliquid1Limit', ctypes.c_uint16),
    ('TplxLimit', ctypes.c_uint16),
    ('FitLimit', ctypes.c_uint32),
    ('PpmPowerLimit', ctypes.c_uint16),
    ('PpmTemperatureThreshold', ctypes.c_uint16),
    ('ThrottlerControlMask', ctypes.c_uint32),
    ('FwDStateMask', ctypes.c_uint32),
    ('UlvVoltageOffsetSoc', ctypes.c_uint16),
    ('UlvVoltageOffsetGfx', ctypes.c_uint16),
    ('GceaLinkMgrIdleThreshold', ctypes.c_ubyte),
    ('paddingRlcUlvParams', ctypes.c_ubyte * 3),
    ('UlvSmnclkDid', ctypes.c_ubyte),
    ('UlvMp1clkDid', ctypes.c_ubyte),
    ('UlvGfxclkBypass', ctypes.c_ubyte),
    ('Padding234', ctypes.c_ubyte),
    ('MinVoltageUlvGfx', ctypes.c_uint16),
    ('MinVoltageUlvSoc', ctypes.c_uint16),
    ('MinVoltageGfx', ctypes.c_uint16),
    ('MinVoltageSoc', ctypes.c_uint16),
    ('MaxVoltageGfx', ctypes.c_uint16),
    ('MaxVoltageSoc', ctypes.c_uint16),
    ('LoadLineResistanceGfx', ctypes.c_uint16),
    ('LoadLineResistanceSoc', ctypes.c_uint16),
    ('DpmDescriptor', struct_c__SA_DpmDescriptor_t * 9),
    ('FreqTableGfx', ctypes.c_uint16 * 16),
    ('FreqTableVclk', ctypes.c_uint16 * 8),
    ('FreqTableDclk', ctypes.c_uint16 * 8),
    ('FreqTableSocclk', ctypes.c_uint16 * 8),
    ('FreqTableUclk', ctypes.c_uint16 * 4),
    ('FreqTableDcefclk', ctypes.c_uint16 * 8),
    ('FreqTableDispclk', ctypes.c_uint16 * 8),
    ('FreqTablePixclk', ctypes.c_uint16 * 8),
    ('FreqTablePhyclk', ctypes.c_uint16 * 8),
    ('Paddingclks', ctypes.c_uint32 * 16),
    ('DcModeMaxFreq', ctypes.c_uint16 * 9),
    ('Padding8_Clks', ctypes.c_uint16),
    ('FreqTableUclkDiv', ctypes.c_ubyte * 4),
    ('Mp0clkFreq', ctypes.c_uint16 * 2),
    ('Mp0DpmVoltage', ctypes.c_uint16 * 2),
    ('MemVddciVoltage', ctypes.c_uint16 * 4),
    ('MemMvddVoltage', ctypes.c_uint16 * 4),
    ('GfxclkFgfxoffEntry', ctypes.c_uint16),
    ('GfxclkFinit', ctypes.c_uint16),
    ('GfxclkFidle', ctypes.c_uint16),
    ('GfxclkSlewRate', ctypes.c_uint16),
    ('GfxclkFopt', ctypes.c_uint16),
    ('Padding567', ctypes.c_ubyte * 2),
    ('GfxclkDsMaxFreq', ctypes.c_uint16),
    ('GfxclkSource', ctypes.c_ubyte),
    ('Padding456', ctypes.c_ubyte),
    ('LowestUclkReservedForUlv', ctypes.c_ubyte),
    ('paddingUclk', ctypes.c_ubyte * 3),
    ('MemoryType', ctypes.c_ubyte),
    ('MemoryChannels', ctypes.c_ubyte),
    ('PaddingMem', ctypes.c_ubyte * 2),
    ('PcieGenSpeed', ctypes.c_ubyte * 2),
    ('PcieLaneCount', ctypes.c_ubyte * 2),
    ('LclkFreq', ctypes.c_uint16 * 2),
    ('EnableTdpm', ctypes.c_uint16),
    ('TdpmHighHystTemperature', ctypes.c_uint16),
    ('TdpmLowHystTemperature', ctypes.c_uint16),
    ('GfxclkFreqHighTempLimit', ctypes.c_uint16),
    ('FanStopTemp', ctypes.c_uint16),
    ('FanStartTemp', ctypes.c_uint16),
    ('FanGainEdge', ctypes.c_uint16),
    ('FanGainHotspot', ctypes.c_uint16),
    ('FanGainLiquid0', ctypes.c_uint16),
    ('FanGainLiquid1', ctypes.c_uint16),
    ('FanGainVrGfx', ctypes.c_uint16),
    ('FanGainVrSoc', ctypes.c_uint16),
    ('FanGainVrMem0', ctypes.c_uint16),
    ('FanGainVrMem1', ctypes.c_uint16),
    ('FanGainPlx', ctypes.c_uint16),
    ('FanGainMem', ctypes.c_uint16),
    ('FanPwmMin', ctypes.c_uint16),
    ('FanAcousticLimitRpm', ctypes.c_uint16),
    ('FanThrottlingRpm', ctypes.c_uint16),
    ('FanMaximumRpm', ctypes.c_uint16),
    ('FanTargetTemperature', ctypes.c_uint16),
    ('FanTargetGfxclk', ctypes.c_uint16),
    ('FanTempInputSelect', ctypes.c_ubyte),
    ('FanPadding', ctypes.c_ubyte),
    ('FanZeroRpmEnable', ctypes.c_ubyte),
    ('FanTachEdgePerRev', ctypes.c_ubyte),
    ('FuzzyFan_ErrorSetDelta', ctypes.c_int16),
    ('FuzzyFan_ErrorRateSetDelta', ctypes.c_int16),
    ('FuzzyFan_PwmSetDelta', ctypes.c_int16),
    ('FuzzyFan_Reserved', ctypes.c_uint16),
    ('OverrideAvfsGb', ctypes.c_ubyte * 2),
    ('Padding8_Avfs', ctypes.c_ubyte * 2),
    ('qAvfsGb', struct_c__SA_QuadraticInt_t * 2),
    ('dBtcGbGfxPll', struct_c__SA_DroopInt_t),
    ('dBtcGbGfxDfll', struct_c__SA_DroopInt_t),
    ('dBtcGbSoc', struct_c__SA_DroopInt_t),
    ('qAgingGb', struct_c__SA_LinearInt_t * 2),
    ('qStaticVoltageOffset', struct_c__SA_QuadraticInt_t * 2),
    ('DcTol', ctypes.c_uint16 * 2),
    ('DcBtcEnabled', ctypes.c_ubyte * 2),
    ('Padding8_GfxBtc', ctypes.c_ubyte * 2),
    ('DcBtcMin', ctypes.c_uint16 * 2),
    ('DcBtcMax', ctypes.c_uint16 * 2),
    ('DebugOverrides', ctypes.c_uint32),
    ('ReservedEquation0', struct_c__SA_QuadraticInt_t),
    ('ReservedEquation1', struct_c__SA_QuadraticInt_t),
    ('ReservedEquation2', struct_c__SA_QuadraticInt_t),
    ('ReservedEquation3', struct_c__SA_QuadraticInt_t),
    ('TotalPowerConfig', ctypes.c_ubyte),
    ('TotalPowerSpare1', ctypes.c_ubyte),
    ('TotalPowerSpare2', ctypes.c_uint16),
    ('PccThresholdLow', ctypes.c_uint16),
    ('PccThresholdHigh', ctypes.c_uint16),
    ('MGpuFanBoostLimitRpm', ctypes.c_uint32),
    ('PaddingAPCC', ctypes.c_uint32 * 5),
    ('VDDGFX_TVmin', ctypes.c_uint16),
    ('VDDSOC_TVmin', ctypes.c_uint16),
    ('VDDGFX_Vmin_HiTemp', ctypes.c_uint16),
    ('VDDGFX_Vmin_LoTemp', ctypes.c_uint16),
    ('VDDSOC_Vmin_HiTemp', ctypes.c_uint16),
    ('VDDSOC_Vmin_LoTemp', ctypes.c_uint16),
    ('VDDGFX_TVminHystersis', ctypes.c_uint16),
    ('VDDSOC_TVminHystersis', ctypes.c_uint16),
    ('BtcConfig', ctypes.c_uint32),
    ('SsFmin', ctypes.c_uint16 * 10),
    ('DcBtcGb', ctypes.c_uint16 * 2),
    ('Reserved', ctypes.c_uint32 * 8),
    ('I2cControllers', struct_c__SA_I2cControllerConfig_t * 8),
    ('MaxVoltageStepGfx', ctypes.c_uint16),
    ('MaxVoltageStepSoc', ctypes.c_uint16),
    ('VddGfxVrMapping', ctypes.c_ubyte),
    ('VddSocVrMapping', ctypes.c_ubyte),
    ('VddMem0VrMapping', ctypes.c_ubyte),
    ('VddMem1VrMapping', ctypes.c_ubyte),
    ('GfxUlvPhaseSheddingMask', ctypes.c_ubyte),
    ('SocUlvPhaseSheddingMask', ctypes.c_ubyte),
    ('ExternalSensorPresent', ctypes.c_ubyte),
    ('Padding8_V', ctypes.c_ubyte),
    ('GfxMaxCurrent', ctypes.c_uint16),
    ('GfxOffset', ctypes.c_byte),
    ('Padding_TelemetryGfx', ctypes.c_ubyte),
    ('SocMaxCurrent', ctypes.c_uint16),
    ('SocOffset', ctypes.c_byte),
    ('Padding_TelemetrySoc', ctypes.c_ubyte),
    ('Mem0MaxCurrent', ctypes.c_uint16),
    ('Mem0Offset', ctypes.c_byte),
    ('Padding_TelemetryMem0', ctypes.c_ubyte),
    ('Mem1MaxCurrent', ctypes.c_uint16),
    ('Mem1Offset', ctypes.c_byte),
    ('Padding_TelemetryMem1', ctypes.c_ubyte),
    ('AcDcGpio', ctypes.c_ubyte),
    ('AcDcPolarity', ctypes.c_ubyte),
    ('VR0HotGpio', ctypes.c_ubyte),
    ('VR0HotPolarity', ctypes.c_ubyte),
    ('VR1HotGpio', ctypes.c_ubyte),
    ('VR1HotPolarity', ctypes.c_ubyte),
    ('GthrGpio', ctypes.c_ubyte),
    ('GthrPolarity', ctypes.c_ubyte),
    ('LedPin0', ctypes.c_ubyte),
    ('LedPin1', ctypes.c_ubyte),
    ('LedPin2', ctypes.c_ubyte),
    ('padding8_4', ctypes.c_ubyte),
    ('PllGfxclkSpreadEnabled', ctypes.c_ubyte),
    ('PllGfxclkSpreadPercent', ctypes.c_ubyte),
    ('PllGfxclkSpreadFreq', ctypes.c_uint16),
    ('DfllGfxclkSpreadEnabled', ctypes.c_ubyte),
    ('DfllGfxclkSpreadPercent', ctypes.c_ubyte),
    ('DfllGfxclkSpreadFreq', ctypes.c_uint16),
    ('UclkSpreadEnabled', ctypes.c_ubyte),
    ('UclkSpreadPercent', ctypes.c_ubyte),
    ('UclkSpreadFreq', ctypes.c_uint16),
    ('SoclkSpreadEnabled', ctypes.c_ubyte),
    ('SocclkSpreadPercent', ctypes.c_ubyte),
    ('SocclkSpreadFreq', ctypes.c_uint16),
    ('TotalBoardPower', ctypes.c_uint16),
    ('BoardPadding', ctypes.c_uint16),
    ('MvddRatio', ctypes.c_uint32),
    ('RenesesLoadLineEnabled', ctypes.c_ubyte),
    ('GfxLoadlineResistance', ctypes.c_ubyte),
    ('SocLoadlineResistance', ctypes.c_ubyte),
    ('Padding8_Loadline', ctypes.c_ubyte),
    ('BoardReserved', ctypes.c_uint32 * 8),
    ('MmHubPadding', ctypes.c_uint32 * 8),
     ]

SMU_11_0_PPTABLE_H = True # macro
SMU_11_0_TABLE_FORMAT_REVISION = 12 # macro
SMU_11_0_PP_PLATFORM_CAP_POWERPLAY = 0x1 # macro
SMU_11_0_PP_PLATFORM_CAP_SBIOSPOWERSOURCE = 0x2 # macro
SMU_11_0_PP_PLATFORM_CAP_HARDWAREDC = 0x4 # macro
SMU_11_0_PP_PLATFORM_CAP_BACO = 0x8 # macro
SMU_11_0_PP_PLATFORM_CAP_MACO = 0x10 # macro
SMU_11_0_PP_PLATFORM_CAP_SHADOWPSTATE = 0x20 # macro
SMU_11_0_PP_THERMALCONTROLLER_NONE = 0 # macro
SMU_11_0_PP_OVERDRIVE_VERSION = 0x0800 # macro
SMU_11_0_PP_POWERSAVINGCLOCK_VERSION = 0x0100 # macro
SMU_11_0_MAX_ODFEATURE = 32 # macro
SMU_11_0_MAX_ODSETTING = 32 # macro
class struct_smu_11_0_overdrive_table(ctypes.Structure):
    _pack_ = True # source:True
    _fields_ = [
    ('revision', ctypes.c_ubyte),
    ('reserve', ctypes.c_ubyte * 3),
    ('feature_count', ctypes.c_uint32),
    ('setting_count', ctypes.c_uint32),
    ('cap', ctypes.c_ubyte * 32),
    ('max', ctypes.c_uint32 * 32),
    ('min', ctypes.c_uint32 * 32),
     ]

SMU_11_0_MAX_PPCLOCK = 16 # macro
class struct_smu_11_0_power_saving_clock_table(ctypes.Structure):
    _pack_ = True # source:True
    _fields_ = [
    ('revision', ctypes.c_ubyte),
    ('reserve', ctypes.c_ubyte * 3),
    ('count', ctypes.c_uint32),
    ('max', ctypes.c_uint32 * 16),
    ('min', ctypes.c_uint32 * 16),
     ]

class struct_smu_11_0_powerplay_table(ctypes.Structure):
    _pack_ = True # source:True
    _fields_ = [
    ('header', struct_atom_common_table_header),
    ('table_revision', ctypes.c_ubyte),
    ('table_size', ctypes.c_uint16),
    ('golden_pp_id', ctypes.c_uint32),
    ('golden_revision', ctypes.c_uint32),
    ('format_id', ctypes.c_uint16),
    ('platform_caps', ctypes.c_uint32),
    ('thermal_controller_type', ctypes.c_ubyte),
    ('small_power_limit1', ctypes.c_uint16),
    ('small_power_limit2', ctypes.c_uint16),
    ('boost_power_limit', ctypes.c_uint16),
    ('od_turbo_power_limit', ctypes.c_uint16),
    ('od_power_save_power_limit', ctypes.c_uint16),
    ('software_shutdown_temp', ctypes.c_uint16),
    ('reserve', ctypes.c_uint16 * 6),
    ('power_saving_clock', struct_smu_11_0_power_saving_clock_table),
    ('overdrive_table', struct_smu_11_0_overdrive_table),
    ('smc_pptable', struct_c__SA_PPTable_t),
     ]

__all__ = \
    ['SMU_11_0_MAX_ODFEATURE', 'SMU_11_0_MAX_ODSETTING',
    'SMU_11_0_MAX_PPCLOCK', 'SMU_11_0_PPTABLE_H',
    'SMU_11_0_PP_OVERDRIVE_VERSION', 'SMU_11_0_PP_PLATFORM_CAP_BACO',
    'SMU_11_0_PP_PLATFORM_CAP_HARDWAREDC',
    'SMU_11_0_PP_PLATFORM_CAP_MACO',
    'SMU_11_0_PP_PLATFORM_CAP_POWERPLAY',
    'SMU_11_0_PP_PLATFORM_CAP_SBIOSPOWERSOURCE',
    'SMU_11_0_PP_PLATFORM_CAP_SHADOWPSTATE',
    'SMU_11_0_PP_POWERSAVINGCLOCK_VERSION',
    'SMU_11_0_PP_THERMALCONTROLLER_NONE',
    'SMU_11_0_TABLE_FORMAT_REVISION',
    'struct_atom_common_table_header', 'struct_c__SA_DpmDescriptor_t',
    'struct_c__SA_DroopInt_t', 'struct_c__SA_I2cControllerConfig_t',
    'struct_c__SA_LinearInt_t', 'struct_c__SA_PPTable_t',
    'struct_c__SA_QuadraticInt_t', 'struct_smu_11_0_overdrive_table',
    'struct_smu_11_0_power_saving_clock_table',
    'struct_smu_11_0_powerplay_table']
