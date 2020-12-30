# -*- coding: utf-8 -*-
#
# TARGET arch is: ['--include', 'stdint.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '--include', 'linux/drivers/gpu/drm/amd/include/atom-types.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '--include', 'linux/drivers/gpu/drm/amd/include/atomfirmware.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '--include', 'linux/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_sienna_cichlid.h', '']
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
    ('SlaveAddress', ctypes.c_ubyte),
    ('ControllerPort', ctypes.c_ubyte),
    ('ControllerName', ctypes.c_ubyte),
    ('ThermalThrotter', ctypes.c_ubyte),
    ('I2cProtocol', ctypes.c_ubyte),
    ('PaddingConfig', ctypes.c_ubyte),
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

class struct_c__SA_PiecewiseLinearDroopInt_t(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('Fset', ctypes.c_uint32 * 5),
    ('Vdroop', ctypes.c_uint32 * 5),
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
    ('SsFmin', ctypes.c_uint16),
    ('Padding16', ctypes.c_uint16),
     ]

class struct_c__SA_UclkDpmChangeRange_t(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('Fmin', ctypes.c_uint16),
    ('Fmax', ctypes.c_uint16),
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
    ('TdcLimit', ctypes.c_uint16 * 2),
    ('TdcLimitTau', ctypes.c_uint16 * 2),
    ('TemperatureLimit', ctypes.c_uint16 * 10),
    ('FitLimit', ctypes.c_uint32),
    ('TotalPowerConfig', ctypes.c_ubyte),
    ('TotalPowerPadding', ctypes.c_ubyte * 3),
    ('ApccPlusResidencyLimit', ctypes.c_uint32),
    ('SmnclkDpmFreq', ctypes.c_uint16 * 2),
    ('SmnclkDpmVoltage', ctypes.c_uint16 * 2),
    ('PaddingAPCC', ctypes.c_uint32 * 4),
    ('ThrottlerControlMask', ctypes.c_uint32),
    ('FwDStateMask', ctypes.c_uint32),
    ('UlvVoltageOffsetSoc', ctypes.c_uint16),
    ('UlvVoltageOffsetGfx', ctypes.c_uint16),
    ('MinVoltageUlvGfx', ctypes.c_uint16),
    ('MinVoltageUlvSoc', ctypes.c_uint16),
    ('SocLIVmin', ctypes.c_uint16),
    ('PaddingLIVmin', ctypes.c_uint16),
    ('GceaLinkMgrIdleThreshold', ctypes.c_ubyte),
    ('paddingRlcUlvParams', ctypes.c_ubyte * 3),
    ('MinVoltageGfx', ctypes.c_uint16),
    ('MinVoltageSoc', ctypes.c_uint16),
    ('MaxVoltageGfx', ctypes.c_uint16),
    ('MaxVoltageSoc', ctypes.c_uint16),
    ('LoadLineResistanceGfx', ctypes.c_uint16),
    ('LoadLineResistanceSoc', ctypes.c_uint16),
    ('VDDGFX_TVmin', ctypes.c_uint16),
    ('VDDSOC_TVmin', ctypes.c_uint16),
    ('VDDGFX_Vmin_HiTemp', ctypes.c_uint16),
    ('VDDGFX_Vmin_LoTemp', ctypes.c_uint16),
    ('VDDSOC_Vmin_HiTemp', ctypes.c_uint16),
    ('VDDSOC_Vmin_LoTemp', ctypes.c_uint16),
    ('VDDGFX_TVminHystersis', ctypes.c_uint16),
    ('VDDSOC_TVminHystersis', ctypes.c_uint16),
    ('DpmDescriptor', struct_c__SA_DpmDescriptor_t * 13),
    ('FreqTableGfx', ctypes.c_uint16 * 16),
    ('FreqTableVclk', ctypes.c_uint16 * 8),
    ('FreqTableDclk', ctypes.c_uint16 * 8),
    ('FreqTableSocclk', ctypes.c_uint16 * 8),
    ('FreqTableUclk', ctypes.c_uint16 * 4),
    ('FreqTableDcefclk', ctypes.c_uint16 * 8),
    ('FreqTableDispclk', ctypes.c_uint16 * 8),
    ('FreqTablePixclk', ctypes.c_uint16 * 8),
    ('FreqTablePhyclk', ctypes.c_uint16 * 8),
    ('FreqTableDtbclk', ctypes.c_uint16 * 8),
    ('FreqTableFclk', ctypes.c_uint16 * 8),
    ('Paddingclks', ctypes.c_uint32 * 16),
    ('DcModeMaxFreq', ctypes.c_uint32 * 13),
    ('FreqTableUclkDiv', ctypes.c_ubyte * 4),
    ('FclkBoostFreq', ctypes.c_uint16),
    ('FclkParamPadding', ctypes.c_uint16),
    ('Mp0clkFreq', ctypes.c_uint16 * 2),
    ('Mp0DpmVoltage', ctypes.c_uint16 * 2),
    ('MemVddciVoltage', ctypes.c_uint16 * 4),
    ('MemMvddVoltage', ctypes.c_uint16 * 4),
    ('GfxclkFgfxoffEntry', ctypes.c_uint16),
    ('GfxclkFinit', ctypes.c_uint16),
    ('GfxclkFidle', ctypes.c_uint16),
    ('GfxclkSource', ctypes.c_ubyte),
    ('GfxclkPadding', ctypes.c_ubyte),
    ('GfxGpoSubFeatureMask', ctypes.c_ubyte),
    ('GfxGpoEnabledWorkPolicyMask', ctypes.c_ubyte),
    ('GfxGpoDisabledWorkPolicyMask', ctypes.c_ubyte),
    ('GfxGpoPadding', ctypes.c_ubyte * 1),
    ('GfxGpoVotingAllow', ctypes.c_uint32),
    ('GfxGpoPadding32', ctypes.c_uint32 * 4),
    ('GfxDcsFopt', ctypes.c_uint16),
    ('GfxDcsFclkFopt', ctypes.c_uint16),
    ('GfxDcsUclkFopt', ctypes.c_uint16),
    ('DcsGfxOffVoltage', ctypes.c_uint16),
    ('DcsMinGfxOffTime', ctypes.c_uint16),
    ('DcsMaxGfxOffTime', ctypes.c_uint16),
    ('DcsMinCreditAccum', ctypes.c_uint32),
    ('DcsExitHysteresis', ctypes.c_uint16),
    ('DcsTimeout', ctypes.c_uint16),
    ('DcsParamPadding', ctypes.c_uint32 * 5),
    ('FlopsPerByteTable', ctypes.c_uint16 * 16),
    ('LowestUclkReservedForUlv', ctypes.c_ubyte),
    ('PaddingMem', ctypes.c_ubyte * 3),
    ('UclkDpmPstates', ctypes.c_ubyte * 4),
    ('UclkDpmSrcFreqRange', struct_c__SA_UclkDpmChangeRange_t),
    ('UclkDpmTargFreqRange', struct_c__SA_UclkDpmChangeRange_t),
    ('UclkDpmMidstepFreq', ctypes.c_uint16),
    ('UclkMidstepPadding', ctypes.c_uint16),
    ('PcieGenSpeed', ctypes.c_ubyte * 2),
    ('PcieLaneCount', ctypes.c_ubyte * 2),
    ('LclkFreq', ctypes.c_uint16 * 2),
    ('FanStopTemp', ctypes.c_uint16),
    ('FanStartTemp', ctypes.c_uint16),
    ('FanGain', ctypes.c_uint16 * 10),
    ('FanPwmMin', ctypes.c_uint16),
    ('FanAcousticLimitRpm', ctypes.c_uint16),
    ('FanThrottlingRpm', ctypes.c_uint16),
    ('FanMaximumRpm', ctypes.c_uint16),
    ('MGpuFanBoostLimitRpm', ctypes.c_uint16),
    ('FanTargetTemperature', ctypes.c_uint16),
    ('FanTargetGfxclk', ctypes.c_uint16),
    ('FanPadding16', ctypes.c_uint16),
    ('FanTempInputSelect', ctypes.c_ubyte),
    ('FanPadding', ctypes.c_ubyte),
    ('FanZeroRpmEnable', ctypes.c_ubyte),
    ('FanTachEdgePerRev', ctypes.c_ubyte),
    ('FuzzyFan_ErrorSetDelta', ctypes.c_int16),
    ('FuzzyFan_ErrorRateSetDelta', ctypes.c_int16),
    ('FuzzyFan_PwmSetDelta', ctypes.c_int16),
    ('FuzzyFan_Reserved', ctypes.c_uint16),
    ('OverrideAvfsGb', ctypes.c_ubyte * 2),
    ('dBtcGbGfxDfllModelSelect', ctypes.c_ubyte),
    ('Padding8_Avfs', ctypes.c_ubyte),
    ('qAvfsGb', struct_c__SA_QuadraticInt_t * 2),
    ('dBtcGbGfxPll', struct_c__SA_DroopInt_t),
    ('dBtcGbGfxDfll', struct_c__SA_DroopInt_t),
    ('dBtcGbSoc', struct_c__SA_DroopInt_t),
    ('qAgingGb', struct_c__SA_LinearInt_t * 2),
    ('PiecewiseLinearDroopIntGfxDfll', struct_c__SA_PiecewiseLinearDroopInt_t),
    ('qStaticVoltageOffset', struct_c__SA_QuadraticInt_t * 2),
    ('DcTol', ctypes.c_uint16 * 2),
    ('DcBtcEnabled', ctypes.c_ubyte * 2),
    ('Padding8_GfxBtc', ctypes.c_ubyte * 2),
    ('DcBtcMin', ctypes.c_uint16 * 2),
    ('DcBtcMax', ctypes.c_uint16 * 2),
    ('DcBtcGb', ctypes.c_uint16 * 2),
    ('XgmiDpmPstates', ctypes.c_ubyte * 2),
    ('XgmiDpmSpare', ctypes.c_ubyte * 2),
    ('DebugOverrides', ctypes.c_uint32),
    ('ReservedEquation0', struct_c__SA_QuadraticInt_t),
    ('ReservedEquation1', struct_c__SA_QuadraticInt_t),
    ('ReservedEquation2', struct_c__SA_QuadraticInt_t),
    ('ReservedEquation3', struct_c__SA_QuadraticInt_t),
    ('CustomerVariant', ctypes.c_ubyte),
    ('VcBtcEnabled', ctypes.c_ubyte),
    ('VcBtcVminT0', ctypes.c_uint16),
    ('VcBtcFixedVminAgingOffset', ctypes.c_uint16),
    ('VcBtcVmin2PsmDegrationGb', ctypes.c_uint16),
    ('VcBtcPsmA', ctypes.c_uint32),
    ('VcBtcPsmB', ctypes.c_uint32),
    ('VcBtcVminA', ctypes.c_uint32),
    ('VcBtcVminB', ctypes.c_uint32),
    ('SkuReserved', ctypes.c_uint32 * 9),
    ('GamingClk', ctypes.c_uint32 * 6),
    ('I2cControllers', struct_c__SA_I2cControllerConfig_t * 16),
    ('GpioScl', ctypes.c_ubyte),
    ('GpioSda', ctypes.c_ubyte),
    ('FchUsbPdSlaveAddr', ctypes.c_ubyte),
    ('I2cSpare', ctypes.c_ubyte * 1),
    ('VddGfxVrMapping', ctypes.c_ubyte),
    ('VddSocVrMapping', ctypes.c_ubyte),
    ('VddMem0VrMapping', ctypes.c_ubyte),
    ('VddMem1VrMapping', ctypes.c_ubyte),
    ('GfxUlvPhaseSheddingMask', ctypes.c_ubyte),
    ('SocUlvPhaseSheddingMask', ctypes.c_ubyte),
    ('VddciUlvPhaseSheddingMask', ctypes.c_ubyte),
    ('MvddUlvPhaseSheddingMask', ctypes.c_ubyte),
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
    ('MvddRatio', ctypes.c_uint32),
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
    ('LedEnableMask', ctypes.c_ubyte),
    ('LedPcie', ctypes.c_ubyte),
    ('LedError', ctypes.c_ubyte),
    ('LedSpare1', ctypes.c_ubyte * 2),
    ('PllGfxclkSpreadEnabled', ctypes.c_ubyte),
    ('PllGfxclkSpreadPercent', ctypes.c_ubyte),
    ('PllGfxclkSpreadFreq', ctypes.c_uint16),
    ('DfllGfxclkSpreadEnabled', ctypes.c_ubyte),
    ('DfllGfxclkSpreadPercent', ctypes.c_ubyte),
    ('DfllGfxclkSpreadFreq', ctypes.c_uint16),
    ('UclkSpreadPadding', ctypes.c_uint16),
    ('UclkSpreadFreq', ctypes.c_uint16),
    ('FclkSpreadEnabled', ctypes.c_ubyte),
    ('FclkSpreadPercent', ctypes.c_ubyte),
    ('FclkSpreadFreq', ctypes.c_uint16),
    ('MemoryChannelEnabled', ctypes.c_uint32),
    ('DramBitWidth', ctypes.c_ubyte),
    ('PaddingMem1', ctypes.c_ubyte * 3),
    ('TotalBoardPower', ctypes.c_uint16),
    ('BoardPowerPadding', ctypes.c_uint16),
    ('XgmiLinkSpeed', ctypes.c_ubyte * 4),
    ('XgmiLinkWidth', ctypes.c_ubyte * 4),
    ('XgmiFclkFreq', ctypes.c_uint16 * 4),
    ('XgmiSocVoltage', ctypes.c_uint16 * 4),
    ('HsrEnabled', ctypes.c_ubyte),
    ('VddqOffEnabled', ctypes.c_ubyte),
    ('PaddingUmcFlags', ctypes.c_ubyte * 2),
    ('UclkSpreadPercent', ctypes.c_ubyte * 16),
    ('BoardReserved', ctypes.c_uint32 * 11),
    ('MmHubPadding', ctypes.c_uint32 * 8),
     ]

SMU_11_0_7_PPTABLE_H = True # macro
SMU_11_0_7_TABLE_FORMAT_REVISION = 15 # macro
SMU_11_0_7_PP_PLATFORM_CAP_POWERPLAY = 0x1 # macro
SMU_11_0_7_PP_PLATFORM_CAP_SBIOSPOWERSOURCE = 0x2 # macro
SMU_11_0_7_PP_PLATFORM_CAP_HARDWAREDC = 0x4 # macro
SMU_11_0_7_PP_PLATFORM_CAP_BACO = 0x8 # macro
SMU_11_0_7_PP_PLATFORM_CAP_MACO = 0x10 # macro
SMU_11_0_7_PP_PLATFORM_CAP_SHADOWPSTATE = 0x20 # macro
SMU_11_0_7_PP_THERMALCONTROLLER_NONE = 0 # macro
SMU_11_0_7_PP_THERMALCONTROLLER_SIENNA_CICHLID = 28 # macro
SMU_11_0_7_PP_OVERDRIVE_VERSION = 0x81 # macro
SMU_11_0_7_PP_POWERSAVINGCLOCK_VERSION = 0x01 # macro
SMU_11_0_7_MAX_ODFEATURE = 32 # macro
SMU_11_0_7_MAX_ODSETTING = 64 # macro
SMU_11_0_7_MAX_PMSETTING = 32 # macro
class struct_smu_11_0_7_overdrive_table(ctypes.Structure):
    _pack_ = True # source:True
    _fields_ = [
    ('revision', ctypes.c_ubyte),
    ('reserve', ctypes.c_ubyte * 3),
    ('feature_count', ctypes.c_uint32),
    ('setting_count', ctypes.c_uint32),
    ('cap', ctypes.c_ubyte * 32),
    ('max', ctypes.c_uint32 * 64),
    ('min', ctypes.c_uint32 * 64),
    ('pm_setting', ctypes.c_int16 * 32),
     ]

SMU_11_0_7_MAX_PPCLOCK = 16 # macro
class struct_smu_11_0_7_power_saving_clock_table(ctypes.Structure):
    _pack_ = True # source:True
    _fields_ = [
    ('revision', ctypes.c_ubyte),
    ('reserve', ctypes.c_ubyte * 3),
    ('count', ctypes.c_uint32),
    ('max', ctypes.c_uint32 * 16),
    ('min', ctypes.c_uint32 * 16),
     ]

class struct_smu_11_0_7_powerplay_table(ctypes.Structure):
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
    ('software_shutdown_temp', ctypes.c_uint16),
    ('reserve', ctypes.c_uint16 * 8),
    ('power_saving_clock', struct_smu_11_0_7_power_saving_clock_table),
    ('overdrive_table', struct_smu_11_0_7_overdrive_table),
    ('smc_pptable', struct_c__SA_PPTable_t),
     ]

__all__ = \
    ['SMU_11_0_7_MAX_ODFEATURE', 'SMU_11_0_7_MAX_ODSETTING',
    'SMU_11_0_7_MAX_PMSETTING', 'SMU_11_0_7_MAX_PPCLOCK',
    'SMU_11_0_7_PPTABLE_H', 'SMU_11_0_7_PP_OVERDRIVE_VERSION',
    'SMU_11_0_7_PP_PLATFORM_CAP_BACO',
    'SMU_11_0_7_PP_PLATFORM_CAP_HARDWAREDC',
    'SMU_11_0_7_PP_PLATFORM_CAP_MACO',
    'SMU_11_0_7_PP_PLATFORM_CAP_POWERPLAY',
    'SMU_11_0_7_PP_PLATFORM_CAP_SBIOSPOWERSOURCE',
    'SMU_11_0_7_PP_PLATFORM_CAP_SHADOWPSTATE',
    'SMU_11_0_7_PP_POWERSAVINGCLOCK_VERSION',
    'SMU_11_0_7_PP_THERMALCONTROLLER_NONE',
    'SMU_11_0_7_PP_THERMALCONTROLLER_SIENNA_CICHLID',
    'SMU_11_0_7_TABLE_FORMAT_REVISION',
    'struct_atom_common_table_header', 'struct_c__SA_DpmDescriptor_t',
    'struct_c__SA_DroopInt_t', 'struct_c__SA_I2cControllerConfig_t',
    'struct_c__SA_LinearInt_t', 'struct_c__SA_PPTable_t',
    'struct_c__SA_PiecewiseLinearDroopInt_t',
    'struct_c__SA_QuadraticInt_t',
    'struct_c__SA_UclkDpmChangeRange_t',
    'struct_smu_11_0_7_overdrive_table',
    'struct_smu_11_0_7_power_saving_clock_table',
    'struct_smu_11_0_7_powerplay_table']
