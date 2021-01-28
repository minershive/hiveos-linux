# -*- coding: utf-8 -*-
#
# TARGET arch is: ['--include', 'stdint.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '--include', 'linux/drivers/gpu/drm/amd/include/atom-types.h', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '--include', 'linux/drivers/gpu/drm/amd/include/atombios.h']
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

TONGA_PPTABLE_H = True # macro
ATOM_TONGA_PP_FANPARAMETERS_TACHOMETER_PULSES_PER_REVOLUTION_MASK = 0x0f # macro
ATOM_TONGA_PP_FANPARAMETERS_NOFAN = 0x80 # macro
ATOM_TONGA_PP_THERMALCONTROLLER_NONE = 0 # macro
ATOM_TONGA_PP_THERMALCONTROLLER_LM96163 = 17 # macro
ATOM_TONGA_PP_THERMALCONTROLLER_TONGA = 21 # macro
ATOM_TONGA_PP_THERMALCONTROLLER_FIJI = 22 # macro
ATOM_TONGA_PP_THERMALCONTROLLER_ADT7473_WITH_INTERNAL = 0x89 # macro
ATOM_TONGA_PP_THERMALCONTROLLER_EMC2103_WITH_INTERNAL = 0x8D # macro
ATOM_TONGA_PP_PLATFORM_CAP_VDDGFX_CONTROL = 0x1 # macro
ATOM_TONGA_PP_PLATFORM_CAP_POWERPLAY = 0x2 # macro
ATOM_TONGA_PP_PLATFORM_CAP_SBIOSPOWERSOURCE = 0x4 # macro
ATOM_TONGA_PP_PLATFORM_CAP_DISABLE_VOLTAGE_ISLAND = 0x8 # macro
____RETIRE16____ = 0x10 # macro
ATOM_TONGA_PP_PLATFORM_CAP_HARDWAREDC = 0x20 # macro
____RETIRE64____ = 0x40 # macro
____RETIRE128____ = 0x80 # macro
____RETIRE256____ = 0x100 # macro
____RETIRE512____ = 0x200 # macro
____RETIRE1024____ = 0x400 # macro
____RETIRE2048____ = 0x800 # macro
ATOM_TONGA_PP_PLATFORM_CAP_MVDD_CONTROL = 0x1000 # macro
____RETIRE2000____ = 0x2000 # macro
____RETIRE4000____ = 0x4000 # macro
ATOM_TONGA_PP_PLATFORM_CAP_VDDCI_CONTROL = 0x8000 # macro
____RETIRE10000____ = 0x10000 # macro
ATOM_TONGA_PP_PLATFORM_CAP_BACO = 0x20000 # macro
ATOM_TONGA_PP_PLATFORM_CAP_OUTPUT_THERMAL2GPIO17 = 0x100000 # macro
ATOM_TONGA_PP_PLATFORM_COMBINE_PCC_WITH_THERMAL_SIGNAL = 0x1000000 # macro
ATOM_TONGA_PLATFORM_LOAD_POST_PRODUCTION_FIRMWARE = 0x2000000 # macro
ATOM_PPLIB_CLASSIFICATION_UI_MASK = 0x0007 # macro
ATOM_PPLIB_CLASSIFICATION_UI_SHIFT = 0 # macro
ATOM_PPLIB_CLASSIFICATION_UI_NONE = 0 # macro
ATOM_PPLIB_CLASSIFICATION_UI_BATTERY = 1 # macro
ATOM_PPLIB_CLASSIFICATION_UI_BALANCED = 3 # macro
ATOM_PPLIB_CLASSIFICATION_UI_PERFORMANCE = 5 # macro
ATOM_PPLIB_CLASSIFICATION_BOOT = 0x0008 # macro
ATOM_PPLIB_CLASSIFICATION_THERMAL = 0x0010 # macro
ATOM_PPLIB_CLASSIFICATION_LIMITEDPOWERSOURCE = 0x0020 # macro
ATOM_PPLIB_CLASSIFICATION_REST = 0x0040 # macro
ATOM_PPLIB_CLASSIFICATION_FORCED = 0x0080 # macro
ATOM_PPLIB_CLASSIFICATION_ACPI = 0x1000 # macro
ATOM_PPLIB_CLASSIFICATION2_LIMITEDPOWERSOURCE_2 = 0x0001 # macro
ATOM_Tonga_DISALLOW_ON_DC = 0x00004000 # macro
ATOM_Tonga_ENABLE_VARIBRIGHT = 0x00008000 # macro
ATOM_Tonga_TABLE_REVISION_TONGA = 7 # macro
class struct__ATOM_Tonga_POWERPLAYTABLE(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('sHeader', struct__ATOM_COMMON_TABLE_HEADER),
    ('ucTableRevision', ctypes.c_ubyte),
    ('usTableSize', ctypes.c_uint16),
    ('ulGoldenPPID', ctypes.c_uint32),
    ('ulGoldenRevision', ctypes.c_uint32),
    ('usFormatID', ctypes.c_uint16),
    ('usVoltageTime', ctypes.c_uint16),
    ('ulPlatformCaps', ctypes.c_uint32),
    ('ulMaxODEngineClock', ctypes.c_uint32),
    ('ulMaxODMemoryClock', ctypes.c_uint32),
    ('usPowerControlLimit', ctypes.c_uint16),
    ('usUlvVoltageOffset', ctypes.c_uint16),
    ('usStateArrayOffset', ctypes.c_uint16),
    ('usFanTableOffset', ctypes.c_uint16),
    ('usThermalControllerOffset', ctypes.c_uint16),
    ('usReserv', ctypes.c_uint16),
    ('usMclkDependencyTableOffset', ctypes.c_uint16),
    ('usSclkDependencyTableOffset', ctypes.c_uint16),
    ('usVddcLookupTableOffset', ctypes.c_uint16),
    ('usVddgfxLookupTableOffset', ctypes.c_uint16),
    ('usMMDependencyTableOffset', ctypes.c_uint16),
    ('usVCEStateTableOffset', ctypes.c_uint16),
    ('usPPMTableOffset', ctypes.c_uint16),
    ('usPowerTuneTableOffset', ctypes.c_uint16),
    ('usHardLimitTableOffset', ctypes.c_uint16),
    ('usPCIETableOffset', ctypes.c_uint16),
    ('usGPIOTableOffset', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16 * 6),
     ]

ATOM_Tonga_POWERPLAYTABLE = struct__ATOM_Tonga_POWERPLAYTABLE
class struct__ATOM_Tonga_State(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucEngineClockIndexHigh', ctypes.c_ubyte),
    ('ucEngineClockIndexLow', ctypes.c_ubyte),
    ('ucMemoryClockIndexHigh', ctypes.c_ubyte),
    ('ucMemoryClockIndexLow', ctypes.c_ubyte),
    ('ucPCIEGenLow', ctypes.c_ubyte),
    ('ucPCIEGenHigh', ctypes.c_ubyte),
    ('ucPCIELaneLow', ctypes.c_ubyte),
    ('ucPCIELaneHigh', ctypes.c_ubyte),
    ('usClassification', ctypes.c_uint16),
    ('ulCapsAndSettings', ctypes.c_uint32),
    ('usClassification2', ctypes.c_uint16),
    ('ucUnused', ctypes.c_ubyte * 4),
     ]

ATOM_Tonga_State = struct__ATOM_Tonga_State
class struct__ATOM_Tonga_State_Array(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Tonga_State * 1),
     ]

ATOM_Tonga_State_Array = struct__ATOM_Tonga_State_Array
class struct__ATOM_Tonga_MCLK_Dependency_Record(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVddcInd', ctypes.c_ubyte),
    ('usVddci', ctypes.c_uint16),
    ('usVddgfxOffset', ctypes.c_uint16),
    ('usMvdd', ctypes.c_uint16),
    ('ulMclk', ctypes.c_uint32),
    ('usReserved', ctypes.c_uint16),
     ]

ATOM_Tonga_MCLK_Dependency_Record = struct__ATOM_Tonga_MCLK_Dependency_Record
class struct__ATOM_Tonga_MCLK_Dependency_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Tonga_MCLK_Dependency_Record * 1),
     ]

ATOM_Tonga_MCLK_Dependency_Table = struct__ATOM_Tonga_MCLK_Dependency_Table
class struct__ATOM_Tonga_SCLK_Dependency_Record(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVddInd', ctypes.c_ubyte),
    ('usVddcOffset', ctypes.c_uint16),
    ('ulSclk', ctypes.c_uint32),
    ('usEdcCurrent', ctypes.c_uint16),
    ('ucReliabilityTemperature', ctypes.c_ubyte),
    ('ucCKSVOffsetandDisable', ctypes.c_ubyte),
     ]

ATOM_Tonga_SCLK_Dependency_Record = struct__ATOM_Tonga_SCLK_Dependency_Record
class struct__ATOM_Tonga_SCLK_Dependency_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Tonga_SCLK_Dependency_Record * 1),
     ]

ATOM_Tonga_SCLK_Dependency_Table = struct__ATOM_Tonga_SCLK_Dependency_Table
class struct__ATOM_Polaris_SCLK_Dependency_Record(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVddInd', ctypes.c_ubyte),
    ('usVddcOffset', ctypes.c_uint16),
    ('ulSclk', ctypes.c_uint32),
    ('usEdcCurrent', ctypes.c_uint16),
    ('ucReliabilityTemperature', ctypes.c_ubyte),
    ('ucCKSVOffsetandDisable', ctypes.c_ubyte),
    ('ulSclkOffset', ctypes.c_uint32),
     ]

ATOM_Polaris_SCLK_Dependency_Record = struct__ATOM_Polaris_SCLK_Dependency_Record
class struct__ATOM_Polaris_SCLK_Dependency_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Polaris_SCLK_Dependency_Record * 1),
     ]

ATOM_Polaris_SCLK_Dependency_Table = struct__ATOM_Polaris_SCLK_Dependency_Table
class struct__ATOM_Tonga_PCIE_Record(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucPCIEGenSpeed', ctypes.c_ubyte),
    ('usPCIELaneWidth', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
     ]

ATOM_Tonga_PCIE_Record = struct__ATOM_Tonga_PCIE_Record
class struct__ATOM_Tonga_PCIE_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Tonga_PCIE_Record * 1),
     ]

ATOM_Tonga_PCIE_Table = struct__ATOM_Tonga_PCIE_Table
class struct__ATOM_Polaris10_PCIE_Record(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucPCIEGenSpeed', ctypes.c_ubyte),
    ('usPCIELaneWidth', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte * 2),
    ('ulPCIE_Sclk', ctypes.c_uint32),
     ]

ATOM_Polaris10_PCIE_Record = struct__ATOM_Polaris10_PCIE_Record
class struct__ATOM_Polaris10_PCIE_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Polaris10_PCIE_Record * 1),
     ]

ATOM_Polaris10_PCIE_Table = struct__ATOM_Polaris10_PCIE_Table
class struct__ATOM_Tonga_MM_Dependency_Record(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVddcInd', ctypes.c_ubyte),
    ('usVddgfxOffset', ctypes.c_uint16),
    ('ulDClk', ctypes.c_uint32),
    ('ulVClk', ctypes.c_uint32),
    ('ulEClk', ctypes.c_uint32),
    ('ulAClk', ctypes.c_uint32),
    ('ulSAMUClk', ctypes.c_uint32),
     ]

ATOM_Tonga_MM_Dependency_Record = struct__ATOM_Tonga_MM_Dependency_Record
class struct__ATOM_Tonga_MM_Dependency_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Tonga_MM_Dependency_Record * 1),
     ]

ATOM_Tonga_MM_Dependency_Table = struct__ATOM_Tonga_MM_Dependency_Table
class struct__ATOM_Tonga_Voltage_Lookup_Record(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('usVdd', ctypes.c_uint16),
    ('usCACLow', ctypes.c_uint16),
    ('usCACMid', ctypes.c_uint16),
    ('usCACHigh', ctypes.c_uint16),
     ]

ATOM_Tonga_Voltage_Lookup_Record = struct__ATOM_Tonga_Voltage_Lookup_Record
class struct__ATOM_Tonga_Voltage_Lookup_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Tonga_Voltage_Lookup_Record * 1),
     ]

ATOM_Tonga_Voltage_Lookup_Table = struct__ATOM_Tonga_Voltage_Lookup_Table
class struct__ATOM_Tonga_Fan_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucTHyst', ctypes.c_ubyte),
    ('usTMin', ctypes.c_uint16),
    ('usTMed', ctypes.c_uint16),
    ('usTHigh', ctypes.c_uint16),
    ('usPWMMin', ctypes.c_uint16),
    ('usPWMMed', ctypes.c_uint16),
    ('usPWMHigh', ctypes.c_uint16),
    ('usTMax', ctypes.c_uint16),
    ('ucFanControlMode', ctypes.c_ubyte),
    ('usFanPWMMax', ctypes.c_uint16),
    ('usFanOutputSensitivity', ctypes.c_uint16),
    ('usFanRPMMax', ctypes.c_uint16),
    ('ulMinFanSCLKAcousticLimit', ctypes.c_uint32),
    ('ucTargetTemperature', ctypes.c_ubyte),
    ('ucMinimumPWMLimit', ctypes.c_ubyte),
    ('usReserved', ctypes.c_uint16),
     ]

ATOM_Tonga_Fan_Table = struct__ATOM_Tonga_Fan_Table
class struct__ATOM_Fiji_Fan_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucTHyst', ctypes.c_ubyte),
    ('usTMin', ctypes.c_uint16),
    ('usTMed', ctypes.c_uint16),
    ('usTHigh', ctypes.c_uint16),
    ('usPWMMin', ctypes.c_uint16),
    ('usPWMMed', ctypes.c_uint16),
    ('usPWMHigh', ctypes.c_uint16),
    ('usTMax', ctypes.c_uint16),
    ('ucFanControlMode', ctypes.c_ubyte),
    ('usFanPWMMax', ctypes.c_uint16),
    ('usFanOutputSensitivity', ctypes.c_uint16),
    ('usFanRPMMax', ctypes.c_uint16),
    ('ulMinFanSCLKAcousticLimit', ctypes.c_uint32),
    ('ucTargetTemperature', ctypes.c_ubyte),
    ('ucMinimumPWMLimit', ctypes.c_ubyte),
    ('usFanGainEdge', ctypes.c_uint16),
    ('usFanGainHotspot', ctypes.c_uint16),
    ('usFanGainLiquid', ctypes.c_uint16),
    ('usFanGainVrVddc', ctypes.c_uint16),
    ('usFanGainVrMvdd', ctypes.c_uint16),
    ('usFanGainPlx', ctypes.c_uint16),
    ('usFanGainHbm', ctypes.c_uint16),
    ('usReserved', ctypes.c_uint16),
     ]

ATOM_Fiji_Fan_Table = struct__ATOM_Fiji_Fan_Table
class struct__ATOM_Tonga_Thermal_Controller(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucType', ctypes.c_ubyte),
    ('ucI2cLine', ctypes.c_ubyte),
    ('ucI2cAddress', ctypes.c_ubyte),
    ('ucFanParameters', ctypes.c_ubyte),
    ('ucFanMinRPM', ctypes.c_ubyte),
    ('ucFanMaxRPM', ctypes.c_ubyte),
    ('ucReserved', ctypes.c_ubyte),
    ('ucFlags', ctypes.c_ubyte),
     ]

ATOM_Tonga_Thermal_Controller = struct__ATOM_Tonga_Thermal_Controller
class struct__ATOM_Tonga_VCE_State_Record(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucVCEClockIndex', ctypes.c_ubyte),
    ('ucFlag', ctypes.c_ubyte),
    ('ucSCLKIndex', ctypes.c_ubyte),
    ('ucMCLKIndex', ctypes.c_ubyte),
     ]

ATOM_Tonga_VCE_State_Record = struct__ATOM_Tonga_VCE_State_Record
class struct__ATOM_Tonga_VCE_State_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Tonga_VCE_State_Record * 1),
     ]

ATOM_Tonga_VCE_State_Table = struct__ATOM_Tonga_VCE_State_Table
class struct__ATOM_Tonga_PowerTune_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('usTDP', ctypes.c_uint16),
    ('usConfigurableTDP', ctypes.c_uint16),
    ('usTDC', ctypes.c_uint16),
    ('usBatteryPowerLimit', ctypes.c_uint16),
    ('usSmallPowerLimit', ctypes.c_uint16),
    ('usLowCACLeakage', ctypes.c_uint16),
    ('usHighCACLeakage', ctypes.c_uint16),
    ('usMaximumPowerDeliveryLimit', ctypes.c_uint16),
    ('usTjMax', ctypes.c_uint16),
    ('usPowerTuneDataSetID', ctypes.c_uint16),
    ('usEDCLimit', ctypes.c_uint16),
    ('usSoftwareShutdownTemp', ctypes.c_uint16),
    ('usClockStretchAmount', ctypes.c_uint16),
    ('usReserve', ctypes.c_uint16 * 2),
     ]

ATOM_Tonga_PowerTune_Table = struct__ATOM_Tonga_PowerTune_Table
class struct__ATOM_Fiji_PowerTune_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('usTDP', ctypes.c_uint16),
    ('usConfigurableTDP', ctypes.c_uint16),
    ('usTDC', ctypes.c_uint16),
    ('usBatteryPowerLimit', ctypes.c_uint16),
    ('usSmallPowerLimit', ctypes.c_uint16),
    ('usLowCACLeakage', ctypes.c_uint16),
    ('usHighCACLeakage', ctypes.c_uint16),
    ('usMaximumPowerDeliveryLimit', ctypes.c_uint16),
    ('usTjMax', ctypes.c_uint16),
    ('usPowerTuneDataSetID', ctypes.c_uint16),
    ('usEDCLimit', ctypes.c_uint16),
    ('usSoftwareShutdownTemp', ctypes.c_uint16),
    ('usClockStretchAmount', ctypes.c_uint16),
    ('usTemperatureLimitHotspot', ctypes.c_uint16),
    ('usTemperatureLimitLiquid1', ctypes.c_uint16),
    ('usTemperatureLimitLiquid2', ctypes.c_uint16),
    ('usTemperatureLimitVrVddc', ctypes.c_uint16),
    ('usTemperatureLimitVrMvdd', ctypes.c_uint16),
    ('usTemperatureLimitPlx', ctypes.c_uint16),
    ('ucLiquid1_I2C_address', ctypes.c_ubyte),
    ('ucLiquid2_I2C_address', ctypes.c_ubyte),
    ('ucLiquid_I2C_Line', ctypes.c_ubyte),
    ('ucVr_I2C_address', ctypes.c_ubyte),
    ('ucVr_I2C_Line', ctypes.c_ubyte),
    ('ucPlx_I2C_address', ctypes.c_ubyte),
    ('ucPlx_I2C_Line', ctypes.c_ubyte),
    ('usReserved', ctypes.c_uint16),
     ]

ATOM_Fiji_PowerTune_Table = struct__ATOM_Fiji_PowerTune_Table
ATOM_PPM_A_A = 1 # macro
ATOM_PPM_A_I = 2 # macro
class struct__ATOM_Tonga_PPM_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucPpmDesign', ctypes.c_ubyte),
    ('usCpuCoreNumber', ctypes.c_uint16),
    ('ulPlatformTDP', ctypes.c_uint32),
    ('ulSmallACPlatformTDP', ctypes.c_uint32),
    ('ulPlatformTDC', ctypes.c_uint32),
    ('ulSmallACPlatformTDC', ctypes.c_uint32),
    ('ulApuTDP', ctypes.c_uint32),
    ('ulDGpuTDP', ctypes.c_uint32),
    ('ulDGpuUlvPower', ctypes.c_uint32),
    ('ulTjmax', ctypes.c_uint32),
     ]

ATOM_Tonga_PPM_Table = struct__ATOM_Tonga_PPM_Table
class struct__ATOM_Tonga_Hard_Limit_Record(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ulSCLKLimit', ctypes.c_uint32),
    ('ulMCLKLimit', ctypes.c_uint32),
    ('usVddcLimit', ctypes.c_uint16),
    ('usVddciLimit', ctypes.c_uint16),
    ('usVddgfxLimit', ctypes.c_uint16),
     ]

ATOM_Tonga_Hard_Limit_Record = struct__ATOM_Tonga_Hard_Limit_Record
class struct__ATOM_Tonga_Hard_Limit_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucNumEntries', ctypes.c_ubyte),
    ('entries', struct__ATOM_Tonga_Hard_Limit_Record * 1),
     ]

ATOM_Tonga_Hard_Limit_Table = struct__ATOM_Tonga_Hard_Limit_Table
class struct__ATOM_Tonga_GPIO_Table(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
    ('ucVRHotTriggeredSclkDpmIndex', ctypes.c_ubyte),
    ('ucReserve', ctypes.c_ubyte * 5),
     ]

ATOM_Tonga_GPIO_Table = struct__ATOM_Tonga_GPIO_Table
class struct__PPTable_Generic_SubTable_Header(ctypes.Structure):
    _pack_ = True # source:False
    _fields_ = [
    ('ucRevId', ctypes.c_ubyte),
     ]

PPTable_Generic_SubTable_Header = struct__PPTable_Generic_SubTable_Header
__all__ = \
    ['ATOM_Fiji_Fan_Table', 'ATOM_Fiji_PowerTune_Table',
    'ATOM_PPLIB_CLASSIFICATION2_LIMITEDPOWERSOURCE_2',
    'ATOM_PPLIB_CLASSIFICATION_ACPI',
    'ATOM_PPLIB_CLASSIFICATION_BOOT',
    'ATOM_PPLIB_CLASSIFICATION_FORCED',
    'ATOM_PPLIB_CLASSIFICATION_LIMITEDPOWERSOURCE',
    'ATOM_PPLIB_CLASSIFICATION_REST',
    'ATOM_PPLIB_CLASSIFICATION_THERMAL',
    'ATOM_PPLIB_CLASSIFICATION_UI_BALANCED',
    'ATOM_PPLIB_CLASSIFICATION_UI_BATTERY',
    'ATOM_PPLIB_CLASSIFICATION_UI_MASK',
    'ATOM_PPLIB_CLASSIFICATION_UI_NONE',
    'ATOM_PPLIB_CLASSIFICATION_UI_PERFORMANCE',
    'ATOM_PPLIB_CLASSIFICATION_UI_SHIFT', 'ATOM_PPM_A_A',
    'ATOM_PPM_A_I', 'ATOM_Polaris10_PCIE_Record',
    'ATOM_Polaris10_PCIE_Table',
    'ATOM_Polaris_SCLK_Dependency_Record',
    'ATOM_Polaris_SCLK_Dependency_Table',
    'ATOM_TONGA_PLATFORM_LOAD_POST_PRODUCTION_FIRMWARE',
    'ATOM_TONGA_PP_FANPARAMETERS_NOFAN',
    'ATOM_TONGA_PP_FANPARAMETERS_TACHOMETER_PULSES_PER_REVOLUTION_MASK',
    'ATOM_TONGA_PP_PLATFORM_CAP_BACO',
    'ATOM_TONGA_PP_PLATFORM_CAP_DISABLE_VOLTAGE_ISLAND',
    'ATOM_TONGA_PP_PLATFORM_CAP_HARDWAREDC',
    'ATOM_TONGA_PP_PLATFORM_CAP_MVDD_CONTROL',
    'ATOM_TONGA_PP_PLATFORM_CAP_OUTPUT_THERMAL2GPIO17',
    'ATOM_TONGA_PP_PLATFORM_CAP_POWERPLAY',
    'ATOM_TONGA_PP_PLATFORM_CAP_SBIOSPOWERSOURCE',
    'ATOM_TONGA_PP_PLATFORM_CAP_VDDCI_CONTROL',
    'ATOM_TONGA_PP_PLATFORM_CAP_VDDGFX_CONTROL',
    'ATOM_TONGA_PP_PLATFORM_COMBINE_PCC_WITH_THERMAL_SIGNAL',
    'ATOM_TONGA_PP_THERMALCONTROLLER_ADT7473_WITH_INTERNAL',
    'ATOM_TONGA_PP_THERMALCONTROLLER_EMC2103_WITH_INTERNAL',
    'ATOM_TONGA_PP_THERMALCONTROLLER_FIJI',
    'ATOM_TONGA_PP_THERMALCONTROLLER_LM96163',
    'ATOM_TONGA_PP_THERMALCONTROLLER_NONE',
    'ATOM_TONGA_PP_THERMALCONTROLLER_TONGA',
    'ATOM_Tonga_DISALLOW_ON_DC', 'ATOM_Tonga_ENABLE_VARIBRIGHT',
    'ATOM_Tonga_Fan_Table', 'ATOM_Tonga_GPIO_Table',
    'ATOM_Tonga_Hard_Limit_Record', 'ATOM_Tonga_Hard_Limit_Table',
    'ATOM_Tonga_MCLK_Dependency_Record',
    'ATOM_Tonga_MCLK_Dependency_Table',
    'ATOM_Tonga_MM_Dependency_Record',
    'ATOM_Tonga_MM_Dependency_Table', 'ATOM_Tonga_PCIE_Record',
    'ATOM_Tonga_PCIE_Table', 'ATOM_Tonga_POWERPLAYTABLE',
    'ATOM_Tonga_PPM_Table', 'ATOM_Tonga_PowerTune_Table',
    'ATOM_Tonga_SCLK_Dependency_Record',
    'ATOM_Tonga_SCLK_Dependency_Table', 'ATOM_Tonga_State',
    'ATOM_Tonga_State_Array', 'ATOM_Tonga_TABLE_REVISION_TONGA',
    'ATOM_Tonga_Thermal_Controller', 'ATOM_Tonga_VCE_State_Record',
    'ATOM_Tonga_VCE_State_Table', 'ATOM_Tonga_Voltage_Lookup_Record',
    'ATOM_Tonga_Voltage_Lookup_Table',
    'PPTable_Generic_SubTable_Header', 'TONGA_PPTABLE_H',
    '____RETIRE10000____', '____RETIRE1024____', '____RETIRE128____',
    '____RETIRE16____', '____RETIRE2000____', '____RETIRE2048____',
    '____RETIRE256____', '____RETIRE4000____', '____RETIRE512____',
    '____RETIRE64____', 'struct__ATOM_COMMON_TABLE_HEADER',
    'struct__ATOM_Fiji_Fan_Table',
    'struct__ATOM_Fiji_PowerTune_Table',
    'struct__ATOM_Polaris10_PCIE_Record',
    'struct__ATOM_Polaris10_PCIE_Table',
    'struct__ATOM_Polaris_SCLK_Dependency_Record',
    'struct__ATOM_Polaris_SCLK_Dependency_Table',
    'struct__ATOM_Tonga_Fan_Table', 'struct__ATOM_Tonga_GPIO_Table',
    'struct__ATOM_Tonga_Hard_Limit_Record',
    'struct__ATOM_Tonga_Hard_Limit_Table',
    'struct__ATOM_Tonga_MCLK_Dependency_Record',
    'struct__ATOM_Tonga_MCLK_Dependency_Table',
    'struct__ATOM_Tonga_MM_Dependency_Record',
    'struct__ATOM_Tonga_MM_Dependency_Table',
    'struct__ATOM_Tonga_PCIE_Record', 'struct__ATOM_Tonga_PCIE_Table',
    'struct__ATOM_Tonga_POWERPLAYTABLE',
    'struct__ATOM_Tonga_PPM_Table',
    'struct__ATOM_Tonga_PowerTune_Table',
    'struct__ATOM_Tonga_SCLK_Dependency_Record',
    'struct__ATOM_Tonga_SCLK_Dependency_Table',
    'struct__ATOM_Tonga_State', 'struct__ATOM_Tonga_State_Array',
    'struct__ATOM_Tonga_Thermal_Controller',
    'struct__ATOM_Tonga_VCE_State_Record',
    'struct__ATOM_Tonga_VCE_State_Table',
    'struct__ATOM_Tonga_Voltage_Lookup_Record',
    'struct__ATOM_Tonga_Voltage_Lookup_Table',
    'struct__PPTable_Generic_SubTable_Header']
