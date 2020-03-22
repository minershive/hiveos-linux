# Inspired by:
#   https://github.com/kobalicek/amdtweak/blob/master/lib/vbios.js
#   https://github.com/torvalds/linux/blob/master/drivers/gpu/drm/amd/powerplay

# Don't expect this to be anywhere close to PEP8 standards

# Mapping between base C types and Python struct types, '<' indicates little-endian
base_types = [ 'B', 'b', '<H', '<h', '<I', '<i', 'f']
uint8_t  =  'B'
int8_t   =  'b'
uint16_t = '<H'
int16_t  = '<h'
uint32_t = '<I'
int32_t  = '<i'
float32  =  'f'

# Common PowerPlay header for all GCN Radeon GPUs
PowerPlay_header = [
    { 'name': 'StructureSize'                  , 'type': 'uint16_t' },
    { 'name': 'TableFormatRevision'            , 'type': 'uint8_t', 'ref': 'PowerPlayTable' },
    { 'name': 'TableContentRevision'           , 'type': 'uint8_t'  }
]

# Polaris, Tonga
# drivers/gpu/drm/amd/powerplay/hwmgr/pptable_v1_0.h
PowerPlayTable_v7 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "TableSize"                      , 'type': 'uint16_t' },
    { 'name': "GoldenPPId"                     , 'type': 'uint32_t' }, # PPGen use only
    { 'name': "GoldenRevision"                 , 'type': 'uint32_t' }, # PPGen use only
    { 'name': "FormatId"                       , 'type': 'uint16_t' }, # PPGen use only
    { 'name': "VoltageTime"                    , 'type': 'uint16_t' }, # In [ms]
    { 'name': "PlatformCaps"                   , 'type': 'uint32_t' },
    { 'name': "SocClockMaxOD"                  , 'type': 'uint32_t' },
    { 'name': "MemClockMaxOD"                  , 'type': 'uint32_t' },
    { 'name': "PowerControlLimit"              , 'type': 'uint16_t' },
    { 'name': "UlvVoltageOffset"               , 'type': 'uint16_t' }, # In [mV] unit
    { 'name': "StateTable"                     , 'type': 'uint16_t' , 'ref': 'StateTable'               },
    { 'name': "FanTable"                       , 'type': 'uint16_t' , 'ref': 'FanTable'                 },
    { 'name': "ThermalController"              , 'type': 'uint16_t' , 'ref': 'ThermalController'        },
    { 'name': "Reserved1"                      , 'type': 'uint16_t' },
    { 'name': "MemClockDependencyTable"        , 'type': 'uint16_t' , 'ref': 'MemClockDependencyTable'  },
    { 'name': "SocClockDependencyTable"        , 'type': 'uint16_t' , 'ref': 'Tonga_SocClockDependencyTable' },
    { 'name': "VddcLookupTable"                , 'type': 'uint16_t' , 'ref': 'VoltageLookupTable'       },
    { 'name': "VddGfxLookupTable"              , 'type': 'uint16_t' , 'ref': 'VoltageLookupTable'       },
    { 'name': "MMDependencyTable"              , 'type': 'uint16_t' , 'ref': 'MMDependencyTable'        },
    { 'name': "VCEStateTable"                  , 'type': 'uint16_t' , 'ref': 'VCEStateTable'            },
    { 'name': "PPMTable"                       , 'type': 'uint16_t' , 'ref': 'PPMTable'                 },
    { 'name': "PowerTuneTable"                 , 'type': 'uint16_t' , 'ref': 'PowerTuneTable'           },
    { 'name': "HardLimitTable"                 , 'type': 'uint16_t' , 'ref': 'HardLimitTable'           },
    { 'name': "PCIETable"                      , 'type': 'uint16_t' , 'ref': 'PCIETable'                },
    { 'name': "GPIOTable"                      , 'type': 'uint16_t' , 'ref': 'GPIOTable'                },
    { 'name': "Reserved2"                      , 'type': 'uint16_t' },
    { 'name': "Reserved3"                      , 'type': 'uint16_t' },
    { 'name': "Reserved4"                      , 'type': 'uint16_t' },
    { 'name': "Reserved5"                      , 'type': 'uint16_t' },
    { 'name': "Reserved6"                      , 'type': 'uint16_t' },
    { 'name': "Reserved7"                      , 'type': 'uint16_t' }
]

# Vega 10
# drivers/gpu/drm/amd/powerplay/hwmgr/vega10_pptable.h
PowerPlayTable_v8 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "TableSize"                      , 'type': 'uint16_t' },
    { 'name': "GoldenPPId"                     , 'type': 'uint32_t' },
    { 'name': "GoldenRevision"                 , 'type': 'uint32_t' },
    { 'name': "FormatId"                       , 'type': 'uint16_t' },
    { 'name': "PlatformCaps"                   , 'type': 'uint32_t' },
    { 'name': "SocClockMaxOD"                  , 'type': 'uint32_t' },
    { 'name': "MemClockMaxOD"                  , 'type': 'uint32_t' },
    { 'name': "PowerControlLimit"              , 'type': 'uint16_t' },
    { 'name': "UlvVoltageOffset"               , 'type': 'uint16_t' }, # In [mV] unit.
    { 'name': "UlvSmnClockDid"                 , 'type': 'uint16_t' },
    { 'name': "UlvMp1ClockDid"                 , 'type': 'uint16_t' },
    { 'name': "UlvGfxClockBypass"              , 'type': 'uint16_t' },
    { 'name': "GfxClockSlewRate"               , 'type': 'uint16_t' },
    { 'name': "GfxVoltageMode"                 , 'type': 'uint8_t'  },
    { 'name': "SocVoltageMode"                 , 'type': 'uint8_t'  },
    { 'name': "UCLKVoltageMode"                , 'type': 'uint8_t'  },
    { 'name': "UVDVoltageMode"                 , 'type': 'uint8_t'  },
    { 'name': "VCEVoltageMode"                 , 'type': 'uint8_t'  },
    { 'name': "Mp0VoltageMode"                 , 'type': 'uint8_t'  },
    { 'name': "DCEFVoltageMode"                , 'type': 'uint8_t'  },
    { 'name': "StateTable"                     , 'type': 'uint16_t' , 'ref': 'StateTable'               },
    { 'name': "FanTable"                       , 'type': 'uint16_t' , 'ref': 'FanTable'                 },
    { 'name': "ThermalController"              , 'type': 'uint16_t' , 'ref': 'ThermalController'        },
    { 'name': "SocClockDependencyTable"        , 'type': 'uint16_t' , 'ref': 'Vega_SocClockDependencyTable' },
    { 'name': "MemClockDependencyTable"        , 'type': 'uint16_t' , 'ref': 'MemClockDependencyTable'  },
    { 'name': "GfxClockDependencyTable"        , 'type': 'uint16_t' , 'ref': 'GfxClockDependencyTable'  },
    { 'name': "DcefClockDependencyTable"       , 'type': 'uint16_t' , 'ref': 'DcefClockDependencyTable' },
    { 'name': "VddcLookupTable"                , 'type': 'uint16_t' , 'ref': 'VoltageLookupTable'       },
    { 'name': "VddGfxLookupTable"              , 'type': 'uint16_t' , 'ref': 'VoltageLookupTable'       },
    { 'name': "MMDependencyTable"              , 'type': 'uint16_t' , 'ref': 'MMDependencyTable'        },
    { 'name': "VCEStateTable"                  , 'type': 'uint16_t' , 'ref': 'VCEStateTable'            },
    { 'name': "Reserved"                       , 'type': 'uint16_t' },
    { 'name': "PowerTuneTable"                 , 'type': 'uint16_t' , 'ref': 'PowerTuneTable'           },
    { 'name': "HardLimitTable"                 , 'type': 'uint16_t' , 'ref': 'HardLimitTable'           },
    { 'name': "VddciLookupTable"               , 'type': 'uint16_t' , 'ref': 'VoltageLookupTable'       },
    { 'name': "PCIETable"                      , 'type': 'uint16_t' , 'ref': 'PCIETable'                },
    { 'name': "PixClockDependencyTable"        , 'type': 'uint16_t' , 'ref': 'PixClockDependencyTable'  },
    { 'name': "DispClockDependencyTable"       , 'type': 'uint16_t' , 'ref': 'DispClockDependencyTable' },
    { 'name': "PhyClockDependencyTable"        , 'type': 'uint16_t' , 'ref': 'PhyClockDependencyTable'  }
]

# Vega VII, totally flat table without any offsets and sub-table revision info?!
# drivers/gpu/drm/amd/powerplay/hwmgr/vega20_pptable.h
PowerPlayTable_v11 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "TableSize"                      , 'type': 'uint16_t' },
    { 'name': "GoldenPPId"                     , 'type': 'uint32_t' },
    { 'name': "GoldenRevision"                 , 'type': 'uint32_t' },
    { 'name': "FormatId"                       , 'type': 'uint16_t' },
    { 'name': "PlatformCaps"                   , 'type': 'uint32_t' },
    { 'name': "ThermalControllerType"          , 'type': 'uint8_t'  },
    { 'name': "SmallPowerLimit1"               , 'type': 'uint16_t' },
    { 'name': "SmallPowerLimit2"               , 'type': 'uint16_t' },
    { 'name': "BoostPowerLimit"                , 'type': 'uint16_t' },
    { 'name': "ODTurboPowerLimit"              , 'type': 'uint16_t' },
    { 'name': "ODPowerSavePowerLimit"          , 'type': 'uint16_t' },
    { 'name': "SoftwareShutdownTemp"           , 'type': 'uint16_t' },
    { 'name': "PowerSavingClockTable"          , 'type': 'ATOM_VEGA20_POWER_SAVING_CLOCK_RECORD' }, # PowerSavingClock Mode Clock Min/Max array
    { 'name': "OverDrive8Table"                , 'type': 'ATOM_VEGA20_OVERDRIVE8_RECORD' },         # OverDrive8 Feature capabilities and Settings Range (Max and Min)
    { 'name': "Reserved"                       , 'type': 'uint16_t'  , 'max_count': 5 },
    { 'name': "smcPPTable"                     , 'type': 'Vega_PPTable_t' }
]

# Navi10, another flat table without any offsets & sub-table revision info :|
# drivers/gpu/drm/amd/powerplay/inc/smu_v11_0_pptable.h
PowerPlayTable_v12 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "TableSize"                      , 'type': 'uint16_t' },
    { 'name': "GoldenPPId"                     , 'type': 'uint32_t' },
    { 'name': "GoldenRevision"                 , 'type': 'uint32_t' },
    { 'name': "FormatId"                       , 'type': 'uint16_t' },
    { 'name': "PlatformCaps"                   , 'type': 'uint32_t' },
    { 'name': "ThermalControllerType"          , 'type': 'uint8_t'  },
    { 'name': "SmallPowerLimit1"               , 'type': 'uint16_t' },
    { 'name': "SmallPowerLimit2"               , 'type': 'uint16_t' },
    { 'name': "BoostPowerLimit"                , 'type': 'uint16_t' },
    { 'name': "ODTurboPowerLimit"              , 'type': 'uint16_t' },
    { 'name': "ODPowerSavePowerLimit"          , 'type': 'uint16_t' },
    { 'name': "SoftwareShutdownTemp"           , 'type': 'uint16_t' },
    { 'name': "Reserved0"                      , 'type': 'uint16_t'  , 'max_count': 6 },
    { 'name': "PowerSavingClockTable"          , 'type': 'smu_11_0_power_saving_clock_table' },     # PowerSavingClock Mode Clock Min/Max array
    { 'name': "OverDrive8Table"                , 'type': 'smu_11_0_overdrive_table' },              # OverDrive8 Feature capabilities and Settings Range (Max and Min)
    { 'name': "smcPPTable"                     , 'type': 'Navi10_PPTable_t' }
]

SMU_11_0_MAX_PPCLOCK = 16
smu_11_0_power_saving_clock_table = [
    { 'name': "ucTableRevision"                , 'type': 'uint8_t'  },
    { 'name': "Reserve"                        , 'type': 'PaddingByte', 'max_count': 3 },
    { 'name': "PowerSavingClockCount"          , 'type': 'uint32_t' },
    { 'name': "PowerSavingClockMax"            , 'type': 'PowerSavingClockMax', 'max_count': SMU_11_0_MAX_PPCLOCK },
    { 'name': "PowerSavingClockMin"            , 'type': 'PowerSavingClockMin', 'max_count': SMU_11_0_MAX_PPCLOCK }
]

SMU_11_0_MAX_ODFEATURE = SMU_11_0_MAX_ODSETTING = 32
smu_11_0_overdrive_table = [
    { 'name': "ucODTableRevision"              , 'type': 'uint8_t'  },
    { 'name': "Reserve"                        , 'type': 'PaddingByte', 'max_count': 3 },
    { 'name': "ODFeatureCount"                 , 'type': 'uint32_t' },
    { 'name': "ODSettingCount"                 , 'type': 'uint32_t' },
    { 'name': "ODFeatureCapabilities"          , 'type': 'ODFeatureCapabilities', 'max_count': SMU_11_0_MAX_ODFEATURE },
    { 'name': "ODSettingsMax"                  , 'type': 'ODSettingsMax', 'max_count': SMU_11_0_MAX_ODSETTING },
    { 'name': "ODSettingsMin"                  , 'type': 'ODSettingsMin', 'max_count': SMU_11_0_MAX_ODSETTING }
]


ATOM_VEGA20_PPCLOCK_MAX_COUNT = 16
ATOM_VEGA20_POWER_SAVING_CLOCK_RECORD = [
    { 'name': "ucTableRevision"                , 'type': 'uint8_t'  },
    { 'name': "PowerSavingClockCount"          , 'type': 'uint32_t' },
    { 'name': "PowerSavingClockMax"            , 'type': 'PowerSavingClockMax', 'max_count': ATOM_VEGA20_PPCLOCK_MAX_COUNT },
    { 'name': "PowerSavingClockMin"            , 'type': 'PowerSavingClockMin', 'max_count': ATOM_VEGA20_PPCLOCK_MAX_COUNT }
]
PowerSavingClockMax = PowerSavingClockMin = [
    { 'name': "Frequency"                      , 'type': 'uint32_t' }
]

ATOM_VEGA20_ODFEATURE_MAX_COUNT = ATOM_VEGA20_ODSETTING_MAX_COUNT = 32
ATOM_VEGA20_OVERDRIVE8_RECORD = [
    { 'name': "ucODTableRevision"              , 'type': 'uint8_t'  },
    { 'name': "ODFeatureCount"                 , 'type': 'uint32_t' },
    { 'name': "ODFeatureCapabilities"          , 'type': 'ODFeatureCapabilities', 'max_count': ATOM_VEGA20_ODFEATURE_MAX_COUNT },
    { 'name': "ODSettingCount"                 , 'type': 'uint32_t' },
    { 'name': "ODSettingsMax"                  , 'type': 'ODSettingsMax', 'max_count': ATOM_VEGA20_ODSETTING_MAX_COUNT },
    { 'name': "ODSettingsMin"                  , 'type': 'ODSettingsMin', 'max_count': ATOM_VEGA20_ODSETTING_MAX_COUNT }
]
ODFeatureCapabilities = [
    { 'name': "Capability"                     , 'type': 'uint8_t'  }
]
ODSettingsMax = ODSettingsMin = [
    { 'name': "Setting"                        , 'type': 'uint32_t' }
]

StateTable_v1 = StateTable_v2 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t', 'ref': 'StateEntry' },
]
StateEntry_v1 = StateEntry_v2 = [
    { 'name': "SocClockIndexHigh"              , 'type': 'uint8_t'  },
    { 'name': "SocClockIndexLow"               , 'type': 'uint8_t'  },
    { 'name': "GfxClockIndexHigh"              , 'type': 'uint8_t'  },
    { 'name': "GfxClockIndexLow"               , 'type': 'uint8_t'  },
    { 'name': "MemClockIndexHigh"              , 'type': 'uint8_t'  },
    { 'name': "MemClockIndexLow"               , 'type': 'uint8_t'  },
    { 'name': "Classification"                 , 'type': 'uint16_t' },
    { 'name': "CapsAndSettings"                , 'type': 'uint32_t' },
    { 'name': "Classification2"                , 'type': 'uint16_t' }
]

FanTable_v9 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "THyst"                          , 'type': 'uint8_t'  }, # Temperature hysteresis.
    { 'name': "TMin"                           , 'type': 'uint16_t' }, # The temperature, in 0.01 centigrades, below which we just run at a minimal PWM.
    { 'name': "TMed"                           , 'type': 'uint16_t' }, # The middle temperature where we change slopes.
    { 'name': "THigh"                          , 'type': 'uint16_t' }, # The high point above TMed for adjusting the second slope.
    { 'name': "PWMMin"                         , 'type': 'uint16_t' }, # The minimum PWM value in percent (0.01% increments).
    { 'name': "PWMMed"                         , 'type': 'uint16_t' }, # The PWM value (in percent) at TMed.
    { 'name': "PWMHigh"                        , 'type': 'uint16_t' }, # The PWM value at THigh.
    { 'name': "TMax"                           , 'type': 'uint16_t' }, # The max temperature.
    { 'name': "FanControlMode"                 , 'type': 'uint8_t'  }, # Legacy or Fuzzy Fan mode.
    { 'name': "FanPWMMax"                      , 'type': 'uint16_t' }, # Maximum allowed fan power in percent.
    { 'name': "FanOutputSensitivity"           , 'type': 'uint16_t' }, # Sensitivity of fan reaction to temepature changes.
    { 'name': "FanRPMMax"                      , 'type': 'uint16_t' }, # The default value in RPM.
    { 'name': "MinFanSocClockAcousticLimit"    , 'type': 'uint32_t' }, # Minimum fan controller SOC clock frequency acoustic limit.
    { 'name': "TargetTemperature"              , 'type': 'uint8_t'  }, # Advanced fan controller target temperature.
    { 'name': "MinimumPWMLimit"                , 'type': 'uint8_t'  }, # The minimum PWM that the advanced fan controller can set.  This should be set to the highest PWM that will run the fan at its lowest RPM.
    { 'name': "Reserved1"                      , 'type': 'uint16_t' }
]
FanTable_v11 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "FanOutputSensitivity"           , 'type': 'uint16_t' },
    { 'name': "FanAcousticLimitRPM"            , 'type': 'uint16_t' },
    { 'name': "ThrottlingRPM"                  , 'type': 'uint16_t' },
    { 'name': "TargetTemperature"              , 'type': 'uint16_t' },
    { 'name': "MinimumPWMLimit"                , 'type': 'uint16_t' },
    { 'name': "TargetGfxClock"                 , 'type': 'uint16_t' },
    { 'name': "FanGainEdge"                    , 'type': 'uint16_t' },
    { 'name': "FanGainHotspot"                 , 'type': 'uint16_t' },
    { 'name': "FanGainLiquid"                  , 'type': 'uint16_t' },
    { 'name': "FanGainVrVddc"                  , 'type': 'uint16_t' },
    { 'name': "FanGainVrMvdd"                  , 'type': 'uint16_t' },
    { 'name': "FanGainPPX"                     , 'type': 'uint16_t' },
    { 'name': "FanGainHBM"                     , 'type': 'uint16_t' },
    { 'name': "EnableZeroRPM"                  , 'type': 'uint8_t'  },
    { 'name': "FanStopTemperature"             , 'type': 'uint16_t' },
    { 'name': "FanStartTemperature"            , 'type': 'uint16_t' },
    { 'name': "FanParameters"                  , 'type': 'uint8_t'  },
    { 'name': "FanMinRPM"                      , 'type': 'uint8_t'  },
    { 'name': "FanMaxRPM"                      , 'type': 'uint8_t'  }
]

ThermalController_v1 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "ControlType"                    , 'type': 'uint8_t'  },
    { 'name': "I2CLine"                        , 'type': 'uint8_t'  }, # As interpreted by DAL I2C.
    { 'name': "I2CAddress"                     , 'type': 'uint8_t'  },
    { 'name': "FanParameters"                  , 'type': 'uint8_t'  },
    { 'name': "FanMinRPM"                      , 'type': 'uint8_t'  }, # Minimum RPM (hundreds), for display purposes only.
    { 'name': "FanMaxRPM"                      , 'type': 'uint8_t'  }, # Maximum RPM (hundreds), for display purposes only.
    { 'name': "Flags"                          , 'type': 'uint8_t'  }
]

MemClockDependencyTable_v0 = MemClockDependencyTable_v1 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t', 'ref': 'MemClockDependencyEntry' }
]
MemClockDependencyEntry_v0 = [
    { 'name': "Vddc"                           , 'type': 'uint8_t'  },
    { 'name': "Vddci"                          , 'type': 'uint16_t' },
    { 'name': "VddcGfxOffset"                  , 'type': 'uint16_t' }, # Offset relative to Vddc voltage.
    { 'name': "Mvdd"                           , 'type': 'uint16_t' },
    { 'name': "MemClock"                       , 'type': 'uint32_t' },
    { 'name': "Reserved1"                      , 'type': 'uint16_t' }
]
MemClockDependencyEntry_v1 = [
    { 'name': "MemClock"                       , 'type': 'uint32_t' },
    { 'name': "VddIndex"                       , 'type': 'uint8_t'  },
    { 'name': "VddMemIndex"                    , 'type': 'uint8_t'  },
    { 'name': "VddciIndex"                     , 'type': 'uint8_t'  }
]

Tonga_SocClockDependencyTable_v0 = Tonga_SocClockDependencyTable_v1 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'Tonga_SocClockDependencyEntry' }
]
Tonga_SocClockDependencyEntry_v0 = [
    { 'name': "VddIndex"                       , 'type': 'uint8_t'  }, # Base voltage.
    { 'name': "VddcOffset"                     , 'type': 'uint16_t' }, # Offset relative to base voltage.
    { 'name': "SocClock"                       , 'type': 'uint32_t' },
    { 'name': "EDCCurrent"                     , 'type': 'uint16_t' },
    { 'name': "ReliabilityTemperature"         , 'type': 'uint8_t'  },
    { 'name': "CKSOffsetAndDisable"            , 'type': 'uint8_t'  }  # Bits 0~6: Voltage offset for CKS, Bit 7: Disable/enable for the SOC clock level.
]
Tonga_SocClockDependencyEntry_v1 = [
    { 'name': "Vddc"                           , 'type': 'uint8_t'  }, # Base voltage.
    { 'name': "VddcOffset"                     , 'type': 'uint16_t' }, # Offset relative to base voltage.
    { 'name': "SocClock"                       , 'type': 'uint32_t' },
    { 'name': "EDCCurrent"                     , 'type': 'uint16_t' },
    { 'name': "ReliabilityTemperature"         , 'type': 'uint8_t'  },
    { 'name': "CKSOffsetAndDisable"            , 'type': 'uint8_t'  }, # Bits 0~6: Voltage offset for CKS, Bit 7: Disable/enable for the SOC clock level.
    { 'name': "SocClockOffset"                 , 'type': 'int32_t'  }
]

VoltageLookupTable_v0 = VoltageLookupTable_v1 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'VoltageLookupEntry' }
]
VoltageLookupEntry_v0 = [
    { 'name': "Vdd"                            , 'type': 'uint16_t' }, # Base voltage.
    { 'name': "CACLow"                         , 'type': 'uint16_t' },
    { 'name': "CACMid"                         , 'type': 'uint16_t' },
    { 'name': "CACHigh"                        , 'type': 'uint16_t' }
]
VoltageLookupEntry_v1 = [
    { 'name': "Vdd"                            , 'type': 'uint16_t' } # Base voltage only?
]

MMDependencyTable_v0 = MMDependencyTable_v1 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'MMDependencyEntry' }
]
MMDependencyEntry_v0 = [
    { 'name': "Vddc"                           , 'type': 'uint8_t'  }, # Vddc voltage.
    { 'name': "VddcGfxOffset"                  , 'type': 'uint16_t' }, # Offset relative to Vddc voltage.
    { 'name': "DCLK"                           , 'type': 'uint32_t' }, # UVD D-clock.
    { 'name': "VCLK"                           , 'type': 'uint32_t' }, # UVD V-clock.
    { 'name': "ECLK"                           , 'type': 'uint32_t' }, # VCE clock.
    { 'name': "ACLK"                           , 'type': 'uint32_t' }, # ACP clock.
    { 'name': "SAMUCLK"                        , 'type': 'uint32_t' }  # SAMU clock.
]
MMDependencyEntry_v1 = [
    { 'name': "VddcInd"                        , 'type': 'uint8_t'  }, # SOC_VDD voltage index
    { 'name': "DCLK"                           , 'type': 'uint32_t' }, # UVD D-clock
    { 'name': "VCLK"                           , 'type': 'uint32_t' }, # UVD V-clock
    { 'name': "ECLK"                           , 'type': 'uint32_t' }, # VCE clock
    { 'name': "PSPClk"                         , 'type': 'uint32_t' }  # PSP clock
]

VCEStateTable_v1 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'VCEStateEntry' }
]
VCEStateEntry_v1 = [
    { 'name': "VCEClockIndex"                  , 'type': 'uint8_t'  }, # Index into 'VCEDependencyTableOffset' of 'MMDependencyTable'.
    { 'name': "Flag"                           , 'type': 'uint8_t'  }, # 2 bits indicates memory p-states.
    { 'name': "SocClockIndex"                  , 'type': 'uint8_t'  }, # Index into 'SocClockDependencyTable'.
    { 'name': "MemClockIndex"                  , 'type': 'uint8_t'  }  # Index into 'MemClockDependencyTable'.
]

PPMTable_v52 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "PPMDesign"                      , 'type': 'uint8_t'  },
    { 'name': "CPUCoreNumber"                  , 'type': 'uint16_t' },
    { 'name': "PlatformTDP"                    , 'type': 'uint32_t' },
    { 'name': "SmallACPPlatformTDP"            , 'type': 'uint32_t' },
    { 'name': "PlatformTDC"                    , 'type': 'uint32_t' },
    { 'name': "SmallACPPlatformTDC"            , 'type': 'uint32_t' },
    { 'name': "APUTDP"                         , 'type': 'uint32_t' },
    { 'name': "DGPUTDP"                        , 'type': 'uint32_t' },
    { 'name': "DGPUULVPower"                   , 'type': 'uint32_t' },
    { 'name': "TjMax"                          , 'type': 'uint32_t' }
]

PowerTuneTable_v4 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "TDP"                            , 'type': 'uint16_t' },
    { 'name': "ConfigurableTDP"                , 'type': 'uint16_t' },
    { 'name': "TDC"                            , 'type': 'uint16_t' },
    { 'name': "BatteryPowerLimit"              , 'type': 'uint16_t' },
    { 'name': "SmallPowerLimit"                , 'type': 'uint16_t' },
    { 'name': "LowCACLeakage"                  , 'type': 'uint16_t' },
    { 'name': "HighCACLeakage"                 , 'type': 'uint16_t' },
    { 'name': "MaximumPowerDeliveryLimit"      , 'type': 'uint16_t' },
    { 'name': "TjMax"                          , 'type': 'uint16_t' },
    { 'name': "PowerTuneDataSetId"             , 'type': 'uint16_t' },
    { 'name': "EDCLimit"                       , 'type': 'uint16_t' },
    { 'name': "SoftwareShutdownTemp"           , 'type': 'uint16_t' },
    { 'name': "ClockStretchAmount"             , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitHotspot"        , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitLiquid1"        , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitLiquid2"        , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitVrVddc"         , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitVrMvdd"         , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitPlx"            , 'type': 'uint16_t' },
    { 'name': "Liquid1I2CAddress"              , 'type': 'uint8_t'  },
    { 'name': "Liquid2I2CAddress"              , 'type': 'uint8_t'  },
    { 'name': "LiquidI2CLine"                  , 'type': 'uint8_t'  },
    { 'name': "VrI2CAddress"                   , 'type': 'uint8_t'  },
    { 'name': "VrI2CLine"                      , 'type': 'uint8_t'  },
    { 'name': "PlxI2CAddress"                  , 'type': 'uint8_t'  },
    { 'name': "PlxI2CLine"                     , 'type': 'uint8_t'  },
    { 'name': "Reserved1"                      , 'type': 'uint16_t' }
]
PowerTuneTable_v6 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "SocketPowerLimit"               , 'type': 'uint16_t' },
    { 'name': "BatteryPowerLimit"              , 'type': 'uint16_t' },
    { 'name': "SmallPowerLimit"                , 'type': 'uint16_t' },
    { 'name': "TDCLimit"                       , 'type': 'uint16_t' },
    { 'name': "EDCLimit"                       , 'type': 'uint16_t' },
    { 'name': "SoftwareShutdownTemp"           , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitHotSpot"        , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitLiquid1"        , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitLiquid2"        , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitHBM"            , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitVrSoc"          , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitVrMem"          , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitPlx"            , 'type': 'uint16_t' },
    { 'name': "LoadLineResistance"             , 'type': 'uint16_t' },
    { 'name': "Liquid1I2CAddress"              , 'type': 'uint8_t'  },
    { 'name': "Liquid2I2CAddress"              , 'type': 'uint8_t'  },
    { 'name': "LiquidI2CLine"                  , 'type': 'uint8_t'  },
    { 'name': "VrI2CAddress"                   , 'type': 'uint8_t'  },
    { 'name': "VrI2CLine"                      , 'type': 'uint8_t'  },
    { 'name': "PlxI2CAddress"                  , 'type': 'uint8_t'  },
    { 'name': "PlxI2CLine"                     , 'type': 'uint8_t'  },
    { 'name': "TemperatureLimitTedge"          , 'type': 'uint16_t' }
]
PowerTuneTable_v7 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "SocketPowerLimit"               , 'type': 'uint16_t' },
    { 'name': "BatteryPowerLimit"              , 'type': 'uint16_t' },
    { 'name': "SmallPowerLimit"                , 'type': 'uint16_t' },
    { 'name': "TDCLimit"                       , 'type': 'uint16_t' },
    { 'name': "EDCLimit"                       , 'type': 'uint16_t' },
    { 'name': "SoftwareShutdownTemp"           , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitHotSpot"        , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitLiquid1"        , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitLiquid2"        , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitHBM"            , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitVrSoc"          , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitVrMem"          , 'type': 'uint16_t' },
    { 'name': "TemperatureLimitPlx"            , 'type': 'uint16_t' },
    { 'name': "LoadLineResistance"             , 'type': 'uint16_t' },
    { 'name': "Liquid1I2CAddress"              , 'type': 'uint8_t'  },
    { 'name': "Liquid2I2CAddress"              , 'type': 'uint8_t'  },
    { 'name': "LiquidI2CLine"                  , 'type': 'uint8_t'  },
    { 'name': "VrI2CAddress"                   , 'type': 'uint8_t'  },
    { 'name': "VrI2CLine"                      , 'type': 'uint8_t'  },
    { 'name': "PlxI2CAddress"                  , 'type': 'uint8_t'  },
    { 'name': "PlxI2CLine"                     , 'type': 'uint8_t'  },
    { 'name': "TemperatureLimitTedge"          , 'type': 'uint16_t' },
    { 'name': "BoostStartTemperature"          , 'type': 'uint16_t' },
    { 'name': "BoostStopTemperature"           , 'type': 'uint16_t' },
    { 'name': "BoostClock"                     , 'type': 'uint32_t' },
    { 'name': "Reserved1"                      , 'type': 'uint32_t' },
    { 'name': "Reserved2"                      , 'type': 'uint32_t' }
]

# "Special" revision 1, found on some Laptops with embedded Polaris GPUs
HardLimitTable_v1 = HardLimitTable_v52 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'HardLimitEntry' }
]
HardLimitEntry_v1 = HardLimitEntry_v52 = [
    { 'name': "SocClockLimit"                  , 'type': 'uint32_t' },
    { 'name': "MemClockLimit"                  , 'type': 'uint32_t' },
    { 'name': "VddcLimit"                      , 'type': 'uint16_t' },
    { 'name': "VddciLimit"                     , 'type': 'uint16_t' },
    { 'name': "VddGfxLimit"                    , 'type': 'uint16_t' }
]

PCIETable_v1 = PCIETable_v2 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'PCIEEntry' }
]
PCIEEntry_v1 = [
    { 'name': "PCIEGenSpeed"                   , 'type': 'uint8_t'  },
    { 'name': "PCIELaneWidth"                  , 'type': 'uint8_t'  },
    { 'name': "Reserved1"                      , 'type': 'uint16_t' },
    { 'name': "PCIEClock"                      , 'type': 'uint32_t' }
]
PCIEEntry_v2 = [
    { 'name': "LCLK"                           , 'type': 'uint32_t' }, # L Clock
    { 'name': "PCIEGenSpeed"                   , 'type': 'uint8_t'  }, # PCIE Gen
    { 'name': "PCIELaneWidth"                  , 'type': 'uint8_t'  }  # PCIE Lane Width
]

GPIOTable_v0 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "VRHotTriggeredSocClockDPMIndex" , 'type': 'uint8_t'  }, # If VRHot signal is triggered SOC clock will be limited to this DPM level.
    { 'name': "Reserved1"                      , 'type': 'uint8_t'  },
    { 'name': "Reserved2"                      , 'type': 'uint8_t'  },
    { 'name': "Reserved3"                      , 'type': 'uint8_t'  },
    { 'name': "Reserved4"                      , 'type': 'uint8_t'  },
    { 'name': "Reserved5"                      , 'type': 'uint8_t'  }
]

GfxClockDependencyTable_v0 = GfxClockDependencyTable_v1 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'GfxClockDependencyEntry' },
]
GfxClockDependencyEntry_v0 = [
    { 'name': "Clock"                          , 'type': 'uint32_t' },
    { 'name': "VddIndex"                       , 'type': 'uint8_t'  }
]
GfxClockDependencyEntry_v1 = [
    { 'name': "Clock"                          , 'type': 'uint32_t' },
    { 'name': "VddIndex"                       , 'type': 'uint8_t'  },
    { 'name': "CKSVOffsetAndDisable"           , 'type': 'uint16_t' },
    { 'name': "AVFSOffset"                     , 'type': 'uint16_t' },
    { 'name': "ACGEnable"                      , 'type': 'uint8_t'  },
    { 'name': "Reserved1"                      , 'type': 'uint16_t' },
    { 'name': "Reserved2"                      , 'type': 'uint8_t'  }
]

Vega_SocClockDependencyTable_v0 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'Vega10_CLK_Dependency_Record' }
]
DcefClockDependencyTable_v0 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'Vega10_CLK_Dependency_Record' }
]
PixClockDependencyTable_v0 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'Vega10_CLK_Dependency_Record' }
]
DispClockDependencyTable_v0 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'Vega10_CLK_Dependency_Record' }
]
PhyClockDependencyTable_v0 = [
    { 'name': "RevisionId"                     , 'type': 'uint8_t'  },
    { 'name': "NumEntries"                     , 'type': 'uint8_t'  , 'ref': 'Vega10_CLK_Dependency_Record' }
]
Vega10_CLK_Dependency_Record_v0 = [
    { 'name': "ulClk"                          , 'type': 'uint32_t' }, # Frequency of Clock
    { 'name': "ucVddInd"                       , 'type': 'uint8_t'  }  # Base voltage.
]


# drivers/gpu/drm/amd/powerplay/inc/smu11_driver_if.h
Vega_PPCLK_COUNT = 11
NUM_GFXCLK_DPM_LEVELS = 16
NUM_VCLK_DPM_LEVELS = NUM_DCLK_DPM_LEVELS = NUM_ECLK_DPM_LEVELS = \
NUM_SOCCLK_DPM_LEVELS = NUM_FCLK_DPM_LEVELS = NUM_DCEFCLK_DPM_LEVELS = \
NUM_DISPCLK_DPM_LEVELS = NUM_PIXCLK_DPM_LEVELS = NUM_PHYCLK_DPM_LEVELS = 8
NUM_UCLK_DPM_LEVELS = 4
NUM_MP0CLK_DPM_LEVELS = 2
NUM_LINK_LEVELS = 2
AVFS_VOLTAGE_COUNT = 2
NUM_XGMI_LEVELS = 2
I2C_CONTROLLER_NAME_COUNT = 7

FeaturesToRun = [
    { 'name': "Features"                       , 'type': 'uint32_t' }
]

DpmDescriptor_t = [
    { 'name': "VoltageMode"                    , 'type': 'uint8_t'  },
    { 'name': "SnapToDiscrete"                 , 'type': 'uint8_t'  },
    { 'name': "NumDiscreteLevels"              , 'type': 'uint8_t'  },
    { 'name': "padding"                        , 'type': 'uint8_t'  },
    { 'name': "ConversionToAvfsClk"            , 'type': 'LinearInt_t' },
    { 'name': "SsCurve"                        , 'type': 'QuadraticInt_t' }
]
LinearInt_t = [
    { 'name': "m"                              , 'type': 'float32'  },
    { 'name': "b"                              , 'type': 'float32'  }
]
QuadraticInt_t = DroopInt_t = [
    { 'name': "a"                              , 'type': 'float32'  },
    { 'name': "b"                              , 'type': 'float32'  },
    { 'name': "c"                              , 'type': 'float32'  }
]

FreqTableGfx = FreqTableVclk = FreqTableDclk = FreqTableEclk = \
FreqTableSocclk = FreqTableUclk = FreqTableFclk = FreqTableDcefclk = \
FreqTableDispclk = FreqTablePixclk = FreqTablePhyclk = DcModeMaxFreq = \
Mp0clkFreq = LclkFreq = XgmiFclkFreq = XgmiUclkFreq = XgmiSocclkFreq = \
SsFmin = \
[
    { 'name': "Frequency"                      , 'type': 'uint16_t' }
]

Mp0DpmVoltage = XgmiSocVoltage = DcTol = DcBtcMin = DcBtcMax = DcBtcGb = \
MemVddciVoltage = MemMvddVoltage =\
[
    { 'name': "Voltage"                        , 'type': 'uint16_t' }
]

PowerLimit = \
[
    { 'name': "Wattage"                        , 'type': 'uint16_t' }
]
PowerLimitTau = \
[
    { 'name': "Time"                           , 'type': 'uint16_t' }
]


Padding567 = Padding8_Uclk = Padding8_Avfs = OverrideAvfsGb = \
Padding8_GfxBtc = DcBtcEnabled = XgmiLinkWidth = PaddingByte = \
FreqTableUclkDiv = PaddingMem = \
[
    { 'name': "Byte"                           , 'type': 'uint8_t'  }
]
Padding32 = PaddingAPCC = \
[
    { 'name': "Padding32"                      , 'type': 'uint32_t' }
]

PcieGenSpeed  = XgmiLinkSpeed = [
    { 'name': "Speed"                          , 'type': 'uint8_t'  }
]
PcieLaneCount  = [
    { 'name': "Count"                          , 'type': 'uint8_t'  }
]

Vega_I2cControllerConfig_t = [
    { 'name': "Enabled"                        , 'type': 'uint32_t' },
    { 'name': "SlaveAddress"                   , 'type': 'uint32_t' },
    { 'name': "ControllerPort"                 , 'type': 'uint32_t' },
    { 'name': "ControllerName"                 , 'type': 'uint32_t' },
    { 'name': "ThermalThrottler"               , 'type': 'uint32_t' },
    { 'name': "I2cProtocol"                    , 'type': 'uint32_t' },
    { 'name': "I2cSpeed"                       , 'type': 'uint32_t' },
]

# Megalomaniac Vega VII PP table
Vega_PPTable_t = [
    { 'name': "TableVersion"                   , 'type': 'uint32_t' },

    { 'name': "FeaturesToRun"                  , 'type': 'FeaturesToRun', 'max_count': 2 },

    { 'name': "SocketPowerLimitAc0"            , 'type': 'uint16_t' },
    { 'name': "SocketPowerLimitAc0Tau"         , 'type': 'uint16_t' },
    { 'name': "SocketPowerLimitAc1"            , 'type': 'uint16_t' },
    { 'name': "SocketPowerLimitAc1Tau"         , 'type': 'uint16_t' },
    { 'name': "SocketPowerLimitAc2"            , 'type': 'uint16_t' },
    { 'name': "SocketPowerLimitAc2Tau"         , 'type': 'uint16_t' },
    { 'name': "SocketPowerLimitAc3"            , 'type': 'uint16_t' },
    { 'name': "SocketPowerLimitAc3Tau"         , 'type': 'uint16_t' },
    { 'name': "SocketPowerLimitDc"             , 'type': 'uint16_t' },
    { 'name': "SocketPowerLimitDcTau"          , 'type': 'uint16_t' },
    { 'name': "TdcLimitSoc"                    , 'type': 'uint16_t' },
    { 'name': "TdcLimitSocTau"                 , 'type': 'uint16_t' },
    { 'name': "TdcLimitGfx"                    , 'type': 'uint16_t' },
    { 'name': "TdcLimitGfxTau"                 , 'type': 'uint16_t' },

    { 'name': "TedgeLimit"                     , 'type': 'uint16_t' },
    { 'name': "ThotspotLimit"                  , 'type': 'uint16_t' },
    { 'name': "ThbmLimit"                      , 'type': 'uint16_t' },
    { 'name': "Tvr_gfxLimit"                   , 'type': 'uint16_t' },
    { 'name': "Tvr_memLimit"                   , 'type': 'uint16_t' },
    { 'name': "Tliquid1Limit"                  , 'type': 'uint16_t' },
    { 'name': "Tliquid2Limit"                  , 'type': 'uint16_t' },
    { 'name': "TplxLimit"                      , 'type': 'uint16_t' },
    { 'name': "FitLimit"                       , 'type': 'uint32_t' },
    { 'name': "PpmPowerLimit"                  , 'type': 'uint16_t' },
    { 'name': "PpmTemperatureThreshold"        , 'type': 'uint16_t' },
    { 'name': "MemoryOnPackage"                , 'type': 'uint8_t'  },
    { 'name': "padding8_limits"                , 'type': 'uint8_t'  },
    { 'name': "Tvr_socLimit"                   , 'type': 'uint16_t' },
    { 'name': "UlvVoltageOffsetSoc"            , 'type': 'uint16_t' },
    { 'name': "UlvVoltageOffsetGfx"            , 'type': 'uint16_t' },
    { 'name': "UlvSmnclkDid"                   , 'type': 'uint8_t'  },
    { 'name': "UlvMp1clkDid"                   , 'type': 'uint8_t'  },
    { 'name': "UlvGfxclkBypass"                , 'type': 'uint8_t'  },
    { 'name': "Padding234"                     , 'type': 'uint8_t'  },

    { 'name': "MinVoltageGfx"                  , 'type': 'uint16_t' },
    { 'name': "MinVoltageSoc"                  , 'type': 'uint16_t' },
    { 'name': "MaxVoltageGfx"                  , 'type': 'uint16_t' },
    { 'name': "MaxVoltageSoc"                  , 'type': 'uint16_t' },

    { 'name': "LoadLineResistanceGfx"          , 'type': 'uint16_t' },
    { 'name': "LoadLineResistanceSoc"          , 'type': 'uint16_t' },

    { 'name': "DpmDescriptor"                  , 'type': 'DpmDescriptor_t'  , 'max_count': Vega_PPCLK_COUNT       },

    { 'name': "FreqTableGfx"                   , 'type': 'FreqTableGfx'     , 'max_count': NUM_GFXCLK_DPM_LEVELS  },
    { 'name': "FreqTableVclk"                  , 'type': 'FreqTableVclk'    , 'max_count': NUM_VCLK_DPM_LEVELS    },
    { 'name': "FreqTableDclk"                  , 'type': 'FreqTableDclk'    , 'max_count': NUM_DCLK_DPM_LEVELS    },
    { 'name': "FreqTableEclk"                  , 'type': 'FreqTableEclk'    , 'max_count': NUM_ECLK_DPM_LEVELS    },
    { 'name': "FreqTableSocclk"                , 'type': 'FreqTableSocclk'  , 'max_count': NUM_SOCCLK_DPM_LEVELS  },
    { 'name': "FreqTableUclk"                  , 'type': 'FreqTableUclk'    , 'max_count': NUM_UCLK_DPM_LEVELS    },
    { 'name': "FreqTableFclk"                  , 'type': 'FreqTableFclk'    , 'max_count': NUM_FCLK_DPM_LEVELS    },
    { 'name': "FreqTableDcefclk"               , 'type': 'FreqTableDcefclk' , 'max_count': NUM_DCEFCLK_DPM_LEVELS },
    { 'name': "FreqTableDispclk"               , 'type': 'FreqTableDispclk' , 'max_count': NUM_DISPCLK_DPM_LEVELS },
    { 'name': "FreqTablePixclk"                , 'type': 'FreqTablePixclk'  , 'max_count': NUM_PIXCLK_DPM_LEVELS  },
    { 'name': "FreqTablePhyclk"                , 'type': 'FreqTablePhyclk'  , 'max_count': NUM_PHYCLK_DPM_LEVELS  },

    { 'name': "DcModeMaxFreq"                  , 'type': 'DcModeMaxFreq'    , 'max_count': Vega_PPCLK_COUNT       },
    { 'name': "Padding8_Clks"                  , 'type': 'uint16_t' },

    { 'name': "Mp0clkFreq"                     , 'type': 'Mp0clkFreq'       , 'max_count': NUM_MP0CLK_DPM_LEVELS  },
    { 'name': "Mp0DpmVoltage"                  , 'type': 'Mp0DpmVoltage'    , 'max_count': NUM_MP0CLK_DPM_LEVELS  },

    { 'name': "GfxclkFidle"                    , 'type': 'uint16_t' },
    { 'name': "GfxclkSlewRate"                 , 'type': 'uint16_t' },
    { 'name': "CksEnableFreq"                  , 'type': 'uint16_t' },
    { 'name': "Padding789"                     , 'type': 'uint16_t' },
    { 'name': "CksVoltageOffset"               , 'type': 'QuadraticInt_t' },
    { 'name': "Padding567"                     , 'type': 'Padding567'          , 'max_count': 4},
    { 'name': "GfxclkDsMaxFreq"                , 'type': 'uint16_t' },
    { 'name': "GfxclkSource"                   , 'type': 'uint8_t'  },
    { 'name': "Padding456"                     , 'type': 'uint8_t'  },

    { 'name': "LowestUclkReservedForUlv"       , 'type': 'uint8_t'  },
    { 'name': "Padding8_Uclk"                  , 'type': 'Padding8_Uclk'       , 'max_count': 3},

    { 'name': "PcieGenSpeed"                   , 'type': 'PcieGenSpeed'        , 'max_count': NUM_LINK_LEVELS        },
    { 'name': "PcieLaneCount"                  , 'type': 'PcieLaneCount'       , 'max_count': NUM_LINK_LEVELS        },
    { 'name': "LclkFreq"                       , 'type': 'LclkFreq'            , 'max_count': NUM_LINK_LEVELS        },

    { 'name': "EnableTdpm"                     , 'type': 'uint16_t' },
    { 'name': "TdpmHighHystTemperature"        , 'type': 'uint16_t' },
    { 'name': "TdpmLowHystTemperature"         , 'type': 'uint16_t' },
    { 'name': "GfxclkFreqHighTempLimit"        , 'type': 'uint16_t' },

    { 'name': "FanStopTemp"                    , 'type': 'uint16_t' },
    { 'name': "FanStartTemp"                   , 'type': 'uint16_t' },

    { 'name': "FanGainEdge"                    , 'type': 'uint16_t' },
    { 'name': "FanGainHotspot"                 , 'type': 'uint16_t' },
    { 'name': "FanGainLiquid"                  , 'type': 'uint16_t' },
    { 'name': "FanGainVrGfx"                   , 'type': 'uint16_t' },
    { 'name': "FanGainVrSoc"                   , 'type': 'uint16_t' },
    { 'name': "FanGainPlx"                     , 'type': 'uint16_t' },
    { 'name': "FanGainHbm"                     , 'type': 'uint16_t' },
    { 'name': "FanPwmMin"                      , 'type': 'uint16_t' },
    { 'name': "FanAcousticLimitRpm"            , 'type': 'uint16_t' },
    { 'name': "FanThrottlingRpm"               , 'type': 'uint16_t' },
    { 'name': "FanMaximumRpm"                  , 'type': 'uint16_t' },
    { 'name': "FanTargetTemperature"           , 'type': 'uint16_t' },
    { 'name': "FanTargetGfxclk"                , 'type': 'uint16_t' },
    { 'name': "FanZeroRpmEnable"               , 'type': 'uint8_t'  },
    { 'name': "FanTachEdgePerRev"              , 'type': 'uint8_t'  },

    { 'name': "FuzzyFan_ErrorSetDelta"         , 'type': 'int16_t'  },
    { 'name': "FuzzyFan_ErrorRateSetDelta"     , 'type': 'int16_t'  },
    { 'name': "FuzzyFan_PwmSetDelta"           , 'type': 'int16_t'  },
    { 'name': "FuzzyFan_Reserved"              , 'type': 'uint16_t' },

    { 'name': "OverrideAvfsGb"                 , 'type': 'OverrideAvfsGb'      , 'max_count': AVFS_VOLTAGE_COUNT     },
    { 'name': "Padding8_Avfs"                  , 'type': 'Padding8_Avfs'       , 'max_count': 2                      },

    { 'name': "qAvfsGb"                        , 'type': 'QuadraticInt_t'      , 'max_count': AVFS_VOLTAGE_COUNT     },
    { 'name': "dBtcGbGfxCksOn"                 , 'type': 'DroopInt_t' },
    { 'name': "dBtcGbGfxCksOff"                , 'type': 'DroopInt_t' },
    { 'name': "dBtcGbGfxAfll"                  , 'type': 'DroopInt_t' },
    { 'name': "dBtcGbSoc"                      , 'type': 'DroopInt_t' },
    { 'name': "qAgingGb"                       , 'type': 'LinearInt_t'         , 'max_count': AVFS_VOLTAGE_COUNT     },

    { 'name': "qStaticVoltageOffset"           , 'type': 'QuadraticInt_t'      , 'max_count': AVFS_VOLTAGE_COUNT     },

    { 'name': "DcTol"                          , 'type': 'DcTol'               , 'max_count': AVFS_VOLTAGE_COUNT     },

    { 'name': "DcBtcEnabled"                   , 'type': 'DcBtcEnabled'        , 'max_count': AVFS_VOLTAGE_COUNT     },
    { 'name': "Padding8_GfxBtc"                , 'type': 'Padding8_GfxBtc'     , 'max_count': 2                      },

    { 'name': "DcBtcMin"                       , 'type': 'DcBtcMin'            , 'max_count': AVFS_VOLTAGE_COUNT     },
    { 'name': "DcBtcMax"                       , 'type': 'DcBtcMax'            , 'max_count': AVFS_VOLTAGE_COUNT     },

    { 'name': "XgmiLinkSpeed"                  , 'type': 'XgmiLinkSpeed'       , 'max_count': NUM_XGMI_LEVELS        },
    { 'name': "XgmiLinkWidth"                  , 'type': 'XgmiLinkWidth'       , 'max_count': NUM_XGMI_LEVELS        },
    { 'name': "XgmiFclkFreq"                   , 'type': 'XgmiFclkFreq'        , 'max_count': NUM_XGMI_LEVELS        },
    { 'name': "XgmiUclkFreq"                   , 'type': 'XgmiUclkFreq'        , 'max_count': NUM_XGMI_LEVELS        },
    { 'name': "XgmiSocclkFreq"                 , 'type': 'XgmiSocclkFreq'      , 'max_count': NUM_XGMI_LEVELS        },
    { 'name': "XgmiSocVoltage"                 , 'type': 'XgmiSocVoltage'      , 'max_count': NUM_XGMI_LEVELS        },

    { 'name': "DebugOverrides"                 , 'type': 'uint32_t' },
    { 'name': "ReservedEquation0"              , 'type': 'QuadraticInt_t' },
    { 'name': "ReservedEquation1"              , 'type': 'QuadraticInt_t' },
    { 'name': "ReservedEquation2"              , 'type': 'QuadraticInt_t' },
    { 'name': "ReservedEquation3"              , 'type': 'QuadraticInt_t' },

    { 'name': "MinVoltageUlvGfx"               , 'type': 'uint16_t' },
    { 'name': "MinVoltageUlvSoc"               , 'type': 'uint16_t' },

    { 'name': "MGpuFanBoostLimitRpm"           , 'type': 'uint16_t' },
    { 'name': "padding16_Fan"                  , 'type': 'uint16_t' },

    { 'name': "FanGainVrMem0"                  , 'type': 'uint16_t' },
    { 'name': "FanGainVrMem1"                  , 'type': 'uint16_t' },

    { 'name': "DcBtcGb"                        , 'type': 'DcBtcGb'             , 'max_count': AVFS_VOLTAGE_COUNT     },

    { 'name': "Reserved"                       , 'type': 'Padding32'           , 'max_count': 11 },
    { 'name': "Padding32"                      , 'type': 'Padding32'           , 'max_count': 3 },

    { 'name': "MaxVoltageStepGfx"              , 'type': 'uint16_t' },
    { 'name': "MaxVoltageStepSoc"              , 'type': 'uint16_t' },

    { 'name': "VddGfxVrMapping"                , 'type': 'uint8_t'  },
    { 'name': "VddSocVrMapping"                , 'type': 'uint8_t'  },
    { 'name': "VddMem0VrMapping"               , 'type': 'uint8_t'  },
    { 'name': "VddMem1VrMapping"               , 'type': 'uint8_t'  },

    { 'name': "GfxUlvPhaseSheddingMask"        , 'type': 'uint8_t'  },
    { 'name': "SocUlvPhaseSheddingMask"        , 'type': 'uint8_t'  },
    { 'name': "ExternalSensorPresent"          , 'type': 'uint8_t'  },
    { 'name': "Padding8_V"                     , 'type': 'uint8_t'  },

    { 'name': "GfxMaxCurrent"                  , 'type': 'uint16_t' },
    { 'name': "GfxOffset"                      , 'type': 'int8_t'   },
    { 'name': "Padding_TelemetryGfx"           , 'type': 'uint8_t'  },

    { 'name': "SocMaxCurrent"                  , 'type': 'uint16_t' },
    { 'name': "SocOffset"                      , 'type': 'int8_t'   },
    { 'name': "Padding_TelemetrySoc"           , 'type': 'uint8_t'  },

    { 'name': "Mem0MaxCurrent"                 , 'type': 'uint16_t' },
    { 'name': "Mem0Offset"                     , 'type': 'int8_t'  },
    { 'name': "Padding_TelemetryMem0"          , 'type': 'uint8_t'  },

    { 'name': "Mem1MaxCurrent"                 , 'type': 'uint16_t' },
    { 'name': "Mem1Offset"                     , 'type': 'int8_t'  },
    { 'name': "Padding_TelemetryMem1"          , 'type': 'uint8_t'  },

    { 'name': "AcDcGpio"                       , 'type': 'uint8_t'  },
    { 'name': "AcDcPolarity"                   , 'type': 'uint8_t'  },
    { 'name': "VR0HotGpio"                     , 'type': 'uint8_t'  },
    { 'name': "VR0HotPolarity"                 , 'type': 'uint8_t'  },

    { 'name': "VR1HotGpio"                     , 'type': 'uint8_t'  },
    { 'name': "VR1HotPolarity"                 , 'type': 'uint8_t'  },
    { 'name': "Padding1"                       , 'type': 'uint8_t'  },
    { 'name': "Padding2"                       , 'type': 'uint8_t'  },

    { 'name': "LedPin0"                        , 'type': 'uint8_t'  },
    { 'name': "LedPin1"                        , 'type': 'uint8_t'  },
    { 'name': "LedPin2"                        , 'type': 'uint8_t'  },
    { 'name': "padding8_4"                     , 'type': 'uint8_t'  },

    { 'name': "PllGfxclkSpreadEnabled"         , 'type': 'uint8_t'  },
    { 'name': "PllGfxclkSpreadPercent"         , 'type': 'uint8_t'  },
    { 'name': "PllGfxclkSpreadFreq"            , 'type': 'uint16_t' },

    { 'name': "UclkSpreadEnabled"              , 'type': 'uint8_t'  },
    { 'name': "UclkSpreadPercent"              , 'type': 'uint8_t'  },
    { 'name': "UclkSpreadFreq"                 , 'type': 'uint16_t' },

    { 'name': "FclkSpreadEnabled"              , 'type': 'uint8_t'  },
    { 'name': "FclkSpreadPercent"              , 'type': 'uint8_t'  },
    { 'name': "FclkSpreadFreq"                 , 'type': 'uint16_t' },

    { 'name': "FllGfxclkSpreadEnabled"         , 'type': 'uint8_t'  },
    { 'name': "FllGfxclkSpreadPercent"         , 'type': 'uint8_t'  },
    { 'name': "FllGfxclkSpreadFreq"            , 'type': 'uint16_t' },

    { 'name': "I2cControllers"                 , 'type': 'Vega_I2cControllerConfig_t', 'max_count': I2C_CONTROLLER_NAME_COUNT },

    { 'name': "BoardReserved"                  , 'type': 'Padding32'           , 'max_count': 10 },

    { 'name': "MmHubPadding"                   , 'type': 'Padding32'           , 'max_count': 8 }
]

# Another megalomaniac PP table, this time for Navi10 (at least some values are documented)
# drivers/gpu/drm/amd/powerplay/inc/smu11_driver_if_navi10.h

Navi_I2cControllerConfig_t = [
    { 'name': "Enabled"                        , 'type': 'uint8_t'  },
    { 'name': "Speed"                          , 'type': 'uint8_t'  },
    { 'name': "Padding0"                       , 'type': 'uint8_t'  },
    { 'name': "Padding1"                       , 'type': 'uint8_t'  },
    { 'name': "SlaveAddress"                   , 'type': 'uint32_t' },
    { 'name': "ControllerPort"                 , 'type': 'uint8_t'  },
    { 'name': "ControllerName"                 , 'type': 'uint8_t'  },
    { 'name': "ThermalThrottler"               , 'type': 'uint8_t'  },
    { 'name': "I2cProtocol"                    , 'type': 'uint8_t'  },
]

Navi_PPCLK_COUNT = 9
PPT_THROTTLER_COUNT = 4
NUM_I2C_CONTROLLERS = 8

Navi10_PPTable_t = [
    { 'name': "TableVersion"                   , 'type': 'uint32_t' },

    # SECTION: Feature Enablement
    { 'name': "FeaturesToRun"                  , 'type': 'FeaturesToRun'    , 'max_count': 2 },

    # SECTION: Infrastructure Limits
    { 'name': "SocketPowerLimitAc"             , 'type': 'PowerLimit'       , 'max_count': PPT_THROTTLER_COUNT },
    { 'name': "SocketPowerLimitAcTau"          , 'type': 'PowerLimitTau'    , 'max_count': PPT_THROTTLER_COUNT },
    { 'name': "SocketPowerLimitDc"             , 'type': 'PowerLimit'       , 'max_count': PPT_THROTTLER_COUNT },
    { 'name': "SocketPowerLimitDcTau"          , 'type': 'PowerLimitTau'    , 'max_count': PPT_THROTTLER_COUNT },

    { 'name': "TdcLimitSoc"                    , 'type': 'uint16_t' }, # Amps
    { 'name': "TdcLimitSocTau"                 , 'type': 'uint16_t' }, # Time constant of LPF in ms
    { 'name': "TdcLimitGfx"                    , 'type': 'uint16_t' }, # Amps
    { 'name': "TdcLimitGfxTau"                 , 'type': 'uint16_t' }, # Time constant of LPF in ms

    { 'name': "TedgeLimit"                     , 'type': 'uint16_t' }, # Celsius
    { 'name': "ThotspotLimit"                  , 'type': 'uint16_t' }, # Celsius
    { 'name': "TmemLimit"                      , 'type': 'uint16_t' }, # Celsius
    { 'name': "Tvr_gfxLimit"                   , 'type': 'uint16_t' }, # Celsius
    { 'name': "Tvr_mem0Limit"                  , 'type': 'uint16_t' }, # Celsius
    { 'name': "Tvr_mem1Limit"                  , 'type': 'uint16_t' }, # Celsius
    { 'name': "Tvr_socLimit"                   , 'type': 'uint16_t' }, # Celsius
    { 'name': "Tliquid0Limit"                  , 'type': 'uint16_t' }, # Celsius
    { 'name': "Tliquid1Limit"                  , 'type': 'uint16_t' }, # Celsius
    { 'name': "TplxLimit"                      , 'type': 'uint16_t' }, # Celsius
    { 'name': "FitLimit"                       , 'type': 'uint32_t' }, # Failures in time (failures per million parts over the defined lifetime)

    { 'name': "PpmPowerLimit"                  , 'type': 'uint16_t' }, # Switch this power limit when temperature is above PpmTempThreshold
    { 'name': "PpmTemperatureThreshold"        , 'type': 'uint16_t' },

    # SECTION: Throttler settings
    { 'name': "ThrottlerControlMask"           , 'type': 'uint32_t' }, # See Throtter masks defines

    # SECTION: FW DSTATE Settings
    { 'name': "FwDStateMask"                   , 'type': 'uint32_t' }, # See FW DState masks defines

    # SECTION: ULV Settings
    { 'name': "UlvVoltageOffsetSoc"            , 'type': 'uint16_t' }, # In mV(Q2)
    { 'name': "UlvVoltageOffsetGfx"            , 'type': 'uint16_t' }, # In mV(Q2)

    { 'name': "GceaLinkMgrIdleThreshold"       , 'type': 'uint8_t'  }, # Set by SMU FW during enablment of SOC_ULV. Controls delay for GFX SDP port disconnection during idle events
    { 'name': "paddingRlcUlvParams0"           , 'type': 'uint8_t'  },
    { 'name': "paddingRlcUlvParams1"           , 'type': 'uint8_t'  },
    { 'name': "paddingRlcUlvParams2"           , 'type': 'uint8_t'  },

    { 'name': "UlvSmnclkDid"                   , 'type': 'uint8_t'  }, # DID for ULV mode. 0 means CLK will not be modified in ULV.
    { 'name': "UlvMp1clkDid"                   , 'type': 'uint8_t'  }, # DID for ULV mode. 0 means CLK will not be modified in ULV.
    { 'name': "UlvGfxclkBypass"                , 'type': 'uint8_t'  }, # 1 to turn off/bypass Gfxclk during ULV, 0 to leave Gfxclk on during ULV
    { 'name': "Padding234"                     , 'type': 'uint8_t'  },

    { 'name': "MinVoltageUlvGfx"               , 'type': 'uint16_t' }, # In mV(Q2)  Minimum Voltage ("Vmin") of VDD_GFX in ULV mode
    { 'name': "MinVoltageUlvSoc"               , 'type': 'uint16_t' }, # In mV(Q2)  Minimum Voltage ("Vmin") of VDD_SOC in ULV mode

    # SECTION: Voltage Control Parameters
    { 'name': "MinVoltageGfx"                  , 'type': 'uint16_t' }, # In mV(Q2) Minimum Voltage ("Vmin") of VDD_GFX
    { 'name': "MinVoltageSoc"                  , 'type': 'uint16_t' }, # In mV(Q2) Minimum Voltage ("Vmin") of VDD_SOC
    { 'name': "MaxVoltageGfx"                  , 'type': 'uint16_t' }, # In mV(Q2) Maximum Voltage allowable of VDD_GFX
    { 'name': "MaxVoltageSoc"                  , 'type': 'uint16_t' }, # In mV(Q2) Maximum Voltage allowable of VDD_SOC

    { 'name': "LoadLineResistanceGfx"          , 'type': 'uint16_t' }, # In mOhms with 8 fractional bits
    { 'name': "LoadLineResistanceSoc"          , 'type': 'uint16_t' }, # In mOhms with 8 fractional bits

    # SECTION: DPM Config 1
    { 'name': "DpmDescriptor"                  , 'type': 'DpmDescriptor_t'  , 'max_count': Navi_PPCLK_COUNT       },

    { 'name': "FreqTableGfx"                   , 'type': 'FreqTableGfx'     , 'max_count': NUM_GFXCLK_DPM_LEVELS  }, # In MHz
    { 'name': "FreqTableVclk"                  , 'type': 'FreqTableVclk'    , 'max_count': NUM_VCLK_DPM_LEVELS    }, # In MHz
    { 'name': "FreqTableDclk"                  , 'type': 'FreqTableDclk'    , 'max_count': NUM_DCLK_DPM_LEVELS    }, # In MHz
    { 'name': "FreqTableSocclk"                , 'type': 'FreqTableSocclk'  , 'max_count': NUM_SOCCLK_DPM_LEVELS  }, # In MHz
    { 'name': "FreqTableUclk"                  , 'type': 'FreqTableUclk'    , 'max_count': NUM_UCLK_DPM_LEVELS    }, # In MHz
    { 'name': "FreqTableDcefclk"               , 'type': 'FreqTableDcefclk' , 'max_count': NUM_DCEFCLK_DPM_LEVELS }, # In MHz
    { 'name': "FreqTableDispclk"               , 'type': 'FreqTableDispclk' , 'max_count': NUM_DISPCLK_DPM_LEVELS }, # In MHz
    { 'name': "FreqTablePixclk"                , 'type': 'FreqTablePixclk'  , 'max_count': NUM_PIXCLK_DPM_LEVELS  }, # In MHz
    { 'name': "FreqTablePhyclk"                , 'type': 'FreqTablePhyclk'  , 'max_count': NUM_PHYCLK_DPM_LEVELS  }, # In MHz
    { 'name': "Paddingclks"                    , 'type': 'Padding32'        , 'max_count': 16                     },

    { 'name': "DcModeMaxFreq"                  , 'type': 'DcModeMaxFreq'    , 'max_count': Navi_PPCLK_COUNT       }, # In MHz
    { 'name': "Padding8_Clks"                  , 'type': 'uint16_t' },

    { 'name': "FreqTableUclkDiv"               , 'type': 'FreqTableUclkDiv' , 'max_count': NUM_UCLK_DPM_LEVELS    }, # 0:Div-1, 1:Div-1/2, 2:Div-1/4, 3:Div-1/8

    # SECTION: DPM Config 2
    { 'name': "Mp0clkFreq"                     , 'type': 'Mp0clkFreq'       , 'max_count': NUM_MP0CLK_DPM_LEVELS  }, # In MHz
    { 'name': "Mp0DpmVoltage"                  , 'type': 'Mp0DpmVoltage'    , 'max_count': NUM_MP0CLK_DPM_LEVELS  }, # mV(Q2)
    { 'name': "MemVddciVoltage"                , 'type': 'MemVddciVoltage'  , 'max_count': NUM_UCLK_DPM_LEVELS    }, # mV(Q2)
    { 'name': "MemMvddVoltage"                 , 'type': 'MemMvddVoltage'   , 'max_count': NUM_UCLK_DPM_LEVELS    }, # mV(Q2)

    # SECTION: GFXCLK DPM
    { 'name': "GfxclkFgfxoffEntry"             , 'type': 'uint16_t' }, # in Mhz
    { 'name': "GfxclkFinit"                    , 'type': 'uint16_t' }, # in Mhz
    { 'name': "GfxclkFidle"                    , 'type': 'uint16_t' }, # in Mhz
    { 'name': "GfxclkSlewRate"                 , 'type': 'uint16_t' }, # for PLL babystepping?
    { 'name': "GfxclkFopt"                     , 'type': 'uint16_t' }, # in Mhz
    { 'name': "Padding567"                     , 'type': 'Padding567'          , 'max_count': 2},
    { 'name': "GfxclkDsMaxFreq"                , 'type': 'uint16_t' }, # in Mhz
    { 'name': "GfxclkSource"                   , 'type': 'uint8_t'  }, # 0 = PLL, 1 = DFLL
    { 'name': "Padding456"                     , 'type': 'uint8_t'  },

    # SECTION: UCLK
    { 'name': "LowestUclkReservedForUlv"       , 'type': 'uint8_t'  }, # Set this to 1 if UCLK DPM0 is reserved for ULV-mode only
    { 'name': "Padding8_Uclk"                  , 'type': 'Padding8_Uclk'       , 'max_count': 3},

    { 'name': "MemoryType"                     , 'type': 'uint8_t'  }, # 0-GDDR6, 1-HBM
    { 'name': "MemoryChannels"                 , 'type': 'uint8_t'  },
    { 'name': "PaddingMem"                     , 'type': 'PaddingMem'          , 'max_count': 2},

    # SECTION: Link DPM Settings
    { 'name': "PcieGenSpeed"                   , 'type': 'PcieGenSpeed'        , 'max_count': NUM_LINK_LEVELS        }, # 0:PciE-gen1 1:PciE-gen2 2:PciE-gen3 3:PciE-gen4
    { 'name': "PcieLaneCount"                  , 'type': 'PcieLaneCount'       , 'max_count': NUM_LINK_LEVELS        }, # 1=x1, 2=x2, 3=x4, 4=x8, 5=x12, 6=x16
    { 'name': "LclkFreq"                       , 'type': 'LclkFreq'            , 'max_count': NUM_LINK_LEVELS        },

    # SECTION: GFXCLK Thermal DPM (formerly 'Boost' Settings)
    { 'name': "EnableTdpm"                     , 'type': 'uint16_t' },
    { 'name': "TdpmHighHystTemperature"        , 'type': 'uint16_t' },
    { 'name': "TdpmLowHystTemperature"         , 'type': 'uint16_t' },
    { 'name': "GfxclkFreqHighTempLimit"        , 'type': 'uint16_t' }, # High limit on GFXCLK when temperature is high, for reliability

    # SECTION: Fan Control
    { 'name': "FanStopTemp"                    , 'type': 'uint16_t' }, # Celsius
    { 'name': "FanStartTemp"                   , 'type': 'uint16_t' }, # Celsius

    { 'name': "FanGainEdge"                    , 'type': 'uint16_t' },
    { 'name': "FanGainHotspot"                 , 'type': 'uint16_t' },
    { 'name': "FanGainLiquid0"                 , 'type': 'uint16_t' },
    { 'name': "FanGainLiquid1"                 , 'type': 'uint16_t' },
    { 'name': "FanGainVrGfx"                   , 'type': 'uint16_t' },
    { 'name': "FanGainVrSoc"                   , 'type': 'uint16_t' },
    { 'name': "FanGainVrMem0"                  , 'type': 'uint16_t' },
    { 'name': "FanGainVrMem1"                  , 'type': 'uint16_t' },
    { 'name': "FanGainPlx"                     , 'type': 'uint16_t' },
    { 'name': "FanGainMem"                     , 'type': 'uint16_t' },
    { 'name': "FanPwmMin"                      , 'type': 'uint16_t' },
    { 'name': "FanAcousticLimitRpm"            , 'type': 'uint16_t' },
    { 'name': "FanThrottlingRpm"               , 'type': 'uint16_t' },
    { 'name': "FanMaximumRpm"                  , 'type': 'uint16_t' },
    { 'name': "FanTargetTemperature"           , 'type': 'uint16_t' },
    { 'name': "FanTargetGfxclk"                , 'type': 'uint16_t' },
    { 'name': "FanTempInputSelect"             , 'type': 'uint8_t'  },
    { 'name': "FanPadding"                     , 'type': 'uint8_t'  },
    { 'name': "FanZeroRpmEnable"               , 'type': 'uint8_t'  },
    { 'name': "FanTachEdgePerRev"              , 'type': 'uint8_t'  },

    # The following are AFC override parameters. Leave at 0 to use FW defaults
    { 'name': "FuzzyFan_ErrorSetDelta"         , 'type': 'int16_t'  },
    { 'name': "FuzzyFan_ErrorRateSetDelta"     , 'type': 'int16_t'  },
    { 'name': "FuzzyFan_PwmSetDelta"           , 'type': 'int16_t'  },
    { 'name': "FuzzyFan_Reserved"              , 'type': 'uint16_t' },

    # SECTION: AVFS
    # Overrides
    { 'name': "OverrideAvfsGb"                 , 'type': 'OverrideAvfsGb'      , 'max_count': AVFS_VOLTAGE_COUNT     },
    { 'name': "Padding8_Avfs"                  , 'type': 'Padding8_Avfs'       , 'max_count': 2                      },

    { 'name': "qAvfsGb"                        , 'type': 'QuadraticInt_t'      , 'max_count': AVFS_VOLTAGE_COUNT     }, # GHz->V Override of fused curve
    { 'name': "dBtcGbGfxPll"                   , 'type': 'DroopInt_t' }, # GHz->V BtcGb
    { 'name': "dBtcGbGfxDfll"                  , 'type': 'DroopInt_t' }, # GHz->V BtcGb
    { 'name': "dBtcGbSoc"                      , 'type': 'DroopInt_t' }, # GHz->V BtcGb
    { 'name': "qAgingGb"                       , 'type': 'LinearInt_t'         , 'max_count': AVFS_VOLTAGE_COUNT     }, # GHz->V

    { 'name': "qStaticVoltageOffset"           , 'type': 'QuadraticInt_t'      , 'max_count': AVFS_VOLTAGE_COUNT     }, # GHz->V

    { 'name': "DcTol"                          , 'type': 'DcTol'               , 'max_count': AVFS_VOLTAGE_COUNT     }, # mV Q2

    { 'name': "DcBtcEnabled"                   , 'type': 'DcBtcEnabled'        , 'max_count': AVFS_VOLTAGE_COUNT     },
    { 'name': "Padding8_GfxBtc"                , 'type': 'Padding8_GfxBtc'     , 'max_count': 2                      },

    { 'name': "DcBtcMin"                       , 'type': 'DcBtcMin'            , 'max_count': AVFS_VOLTAGE_COUNT     }, # mV Q2
    { 'name': "DcBtcMax"                       , 'type': 'DcBtcMax'            , 'max_count': AVFS_VOLTAGE_COUNT     }, # mV Q2

    # SECTION: Advanced Options
    { 'name': "DebugOverrides"                 , 'type': 'uint32_t' },
    { 'name': "ReservedEquation0"              , 'type': 'QuadraticInt_t' },
    { 'name': "ReservedEquation1"              , 'type': 'QuadraticInt_t' },
    { 'name': "ReservedEquation2"              , 'type': 'QuadraticInt_t' },
    { 'name': "ReservedEquation3"              , 'type': 'QuadraticInt_t' },

    # Total Power configuration, use defines from PwrConfig_e
    { 'name': "TotalPowerConfig"               , 'type': 'uint8_t'  }, # 0-TDP, 1-TGP, 2-TCP Estimated, 3-TCP Measured
    { 'name': "TotalPowerSpare1"               , 'type': 'uint8_t'  },
    { 'name': "TotalPowerSpare2"               , 'type': 'uint16_t' },

    # APCC Settings
    { 'name': "PccThresholdLow"                , 'type': 'uint16_t' },
    { 'name': "PccThresholdHigh"               , 'type': 'uint16_t' },
    { 'name': "MGpuFanBoostLimitRpm"           , 'type': 'uint32_t' },
    { 'name': "PaddingAPCC"                    , 'type': 'PaddingAPCC'         , 'max_count': 5 }, # FIXME pending SPEC

    # Temperature Dependent Vmin
    { 'name': "VDDGFX_TVmin"                   , 'type': 'uint16_t' }, # Celsius
    { 'name': "VDDSOC_TVmin"                   , 'type': 'uint16_t' }, # Celsius
    { 'name': "VDDGFX_Vmin_HiTemp"             , 'type': 'uint16_t' }, # mV Q2
    { 'name': "VDDGFX_Vmin_LoTemp"             , 'type': 'uint16_t' }, # mV Q2
    { 'name': "VDDSOC_Vmin_HiTemp"             , 'type': 'uint16_t' }, # mV Q2
    { 'name': "VDDSOC_Vmin_LoTemp"             , 'type': 'uint16_t' }, # mV Q2

    { 'name': "VDDGFX_TVminHystersis"          , 'type': 'uint16_t' }, # Celsius
    { 'name': "VDDSOC_TVminHystersis"          , 'type': 'uint16_t' }, # Celsius

    # BTC Setting
    { 'name': "BtcConfig"                      , 'type': 'uint32_t' },

    { 'name': "SsFmin"                         , 'type': 'SsFmin'              , 'max_count': 10 }, # PPtable value to function similar to VFTFmin for SS Curve; Size is PPCLK_COUNT rounded to nearest multiple of 2
    { 'name': "DcBtcGb"                        , 'type': 'DcBtcGb'             , 'max_count': AVFS_VOLTAGE_COUNT },

    # SECTION: Board Reserved
    { 'name': "Reserved"                       , 'type': 'Padding32'           , 'max_count': 8 },

    # SECTION: Board Parameters
    # I2C Control
    { 'name': "I2cControllers"                 , 'type': 'Navi_I2cControllerConfig_t', 'max_count': NUM_I2C_CONTROLLERS },

    # SVI2 Board Parameters
    { 'name': "MaxVoltageStepGfx"              , 'type': 'uint16_t' }, # In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value
    { 'name': "MaxVoltageStepSoc"              , 'type': 'uint16_t' }, # In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value

    { 'name': "VddGfxVrMapping"                , 'type': 'uint8_t'  }, # Use VR_MAPPING* bitfields
    { 'name': "VddSocVrMapping"                , 'type': 'uint8_t'  }, # Use VR_MAPPING* bitfields
    { 'name': "VddMem0VrMapping"               , 'type': 'uint8_t'  }, # Use VR_MAPPING* bitfields
    { 'name': "VddMem1VrMapping"               , 'type': 'uint8_t'  }, # Use VR_MAPPING* bitfields

    { 'name': "GfxUlvPhaseSheddingMask"        , 'type': 'uint8_t'  }, # set this to 1 to set PSI0/1 to 1 in ULV mode
    { 'name': "SocUlvPhaseSheddingMask"        , 'type': 'uint8_t'  }, # set this to 1 to set PSI0/1 to 1 in ULV mode
    { 'name': "ExternalSensorPresent"          , 'type': 'uint8_t'  }, # External RDI connected to TMON (aka TEMP IN)
    { 'name': "Padding8_V"                     , 'type': 'uint8_t'  },

    # Telemetry Settings
    { 'name': "GfxMaxCurrent"                  , 'type': 'uint16_t' }, # in Amps
    { 'name': "GfxOffset"                      , 'type': 'int8_t'   }, # in Amps
    { 'name': "Padding_TelemetryGfx"           , 'type': 'uint8_t'  },

    { 'name': "SocMaxCurrent"                  , 'type': 'uint16_t' }, # in Amps
    { 'name': "SocOffset"                      , 'type': 'int8_t'   }, # in Amps
    { 'name': "Padding_TelemetrySoc"           , 'type': 'uint8_t'  },

    { 'name': "Mem0MaxCurrent"                 , 'type': 'uint16_t' }, # in Amps
    { 'name': "Mem0Offset"                     , 'type': 'int8_t'   }, # in Amps
    { 'name': "Padding_TelemetryMem0"          , 'type': 'uint8_t'  },

    { 'name': "Mem1MaxCurrent"                 , 'type': 'uint16_t' }, # in Amps
    { 'name': "Mem1Offset"                     , 'type': 'int8_t'   }, # in Amps
    { 'name': "Padding_TelemetryMem1"          , 'type': 'uint8_t'  },

    # GPIO Settings
    { 'name': "AcDcGpio"                       , 'type': 'uint8_t'  }, # GPIO pin configured for AC/DC switching
    { 'name': "AcDcPolarity"                   , 'type': 'uint8_t'  }, # GPIO polarity for AC/DC switching
    { 'name': "VR0HotGpio"                     , 'type': 'uint8_t'  }, # GPIO pin configured for VR0 HOT event
    { 'name': "VR0HotPolarity"                 , 'type': 'uint8_t'  }, # GPIO polarity for VR0 HOT event

    { 'name': "VR1HotGpio"                     , 'type': 'uint8_t'  }, # GPIO pin configured for VR1 HOT event
    { 'name': "VR1HotPolarity"                 , 'type': 'uint8_t'  }, # GPIO polarity for VR1 HOT event
    { 'name': "GthrGpio"                       , 'type': 'uint8_t'  }, # GPIO pin configured for GTHR Event
    { 'name': "GthrPolarity"                   , 'type': 'uint8_t'  }, # replace GPIO polarity for GTHR

    # LED Display Settings
    { 'name': "LedPin0"                        , 'type': 'uint8_t'  }, # GPIO number for LedPin[0]
    { 'name': "LedPin1"                        , 'type': 'uint8_t'  }, # GPIO number for LedPin[1]
    { 'name': "LedPin2"                        , 'type': 'uint8_t'  }, # GPIO number for LedPin[2]
    { 'name': "padding8_4"                     , 'type': 'uint8_t'  },

    # GFXCLK PLL Spread Spectrum
    { 'name': "PllGfxclkSpreadEnabled"         , 'type': 'uint8_t'  }, # on or off
    { 'name': "PllGfxclkSpreadPercent"         , 'type': 'uint8_t'  }, # Q4.4
    { 'name': "PllGfxclkSpreadFreq"            , 'type': 'uint16_t' }, # kHz

    # GFXCLK DFLL Spread Spectrum
    { 'name': "DfllGfxclkSpreadEnabled"        , 'type': 'uint8_t'  }, # on or off
    { 'name': "DfllGfxclkSpreadPercent"        , 'type': 'uint8_t'  }, # Q4.4
    { 'name': "DfllGfxclkSpreadFreq"           , 'type': 'uint16_t' }, # kHz

    # UCLK Spread Spectrum
    { 'name': "UclkSpreadEnabled"              , 'type': 'uint8_t'  }, # on or off
    { 'name': "UclkSpreadPercent"              , 'type': 'uint8_t'  }, # Q4.4
    { 'name': "UclkSpreadFreq"                 , 'type': 'uint16_t' }, # kHz

    # SOCCLK Spread Spectrum
    { 'name': "SoclkSpreadEnabled"             , 'type': 'uint8_t'  }, # on or off
    { 'name': "SocclkSpreadPercent"            , 'type': 'uint8_t'  }, # Q4.4
    { 'name': "SocclkSpreadFreq"               , 'type': 'uint16_t' }, # kHz

    # Total board power
    { 'name': "TotalBoardPower"                , 'type': 'uint16_t' }, # Only needed for TCP Estimated case, where TCP = TGP+Total Board Power
    { 'name': "BoardPadding"                   , 'type': 'uint16_t' },

    # Mvdd Svi2 Div Ratio Setting
    { 'name': "MvddRatio"                      , 'type': 'uint32_t' }, # This is used for MVDD Vid workaround. It has 16 fractional bits (Q16.16)

    { 'name': "RenesesLoadLineEnabled"         , 'type': 'uint8_t'  },
    { 'name': "GfxLoadlineResistance"          , 'type': 'uint8_t'  },
    { 'name': "SocLoadlineResistance"          , 'type': 'uint8_t'  },
    { 'name': "Padding8_Loadline"              , 'type': 'uint8_t'  },

    { 'name': "BoardReserved"                  , 'type': 'Padding32', 'max_count': 8 },

    # Padding for MMHUB - do not modify this
    { 'name': "MmHubPadding"                   , 'type': 'Padding32', 'max_count': 8 } # SMU internal use
]
