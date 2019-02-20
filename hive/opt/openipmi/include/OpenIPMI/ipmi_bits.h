/*
 * ipmi_bits.h
 *
 * MontaVista IPMI interface, various values.
 *
 * Author: MontaVista Software, Inc.
 *         Corey Minyard <minyard@mvista.com>
 *         source@mvista.com
 *
 * Copyright 2003,2004,2005 MontaVista Software Inc.
 *
 * This software is available to you under a choice of one of two
 * licenses.  You may choose to be licensed under the terms of the GNU
 * Lesser General Public License (GPL) Version 2 or the modified BSD
 * license below.  The following disclamer applies to both licenses:
 *
 *  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
 *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 *  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 *  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * GNU Lesser General Public Licence
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this program; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * Modified BSD Licence
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above
 *      copyright notice, this list of conditions and the following
 *      disclaimer in the documentation and/or other materials provided
 *      with the distribution.
 *   3. The name of the author may not be used to endorse or promote
 *      products derived from this software without specific prior
 *      written permission.
 */

#ifndef OPENIPMI_BITS_H
#define OPENIPMI_BITS_H

#include <limits.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Used in various operations to tell what has happened to a sensor,
   control, entity, or whatever. */
enum ipmi_update_e { IPMI_ADDED = 0, IPMI_DELETED = 1, IPMI_CHANGED = 2 };
const char *ipmi_update_e_string(enum ipmi_update_e val);

/*
 * Like the above, but with an error value.  Certain things, like
 * reading FRU data, can result in an error, this is used to report
 * those situations.  Must match the previous values.
 */
enum ipmi_update_werr_e { IPMIE_ADDED = 0, IPMIE_DELETED = 1, IPMIE_CHANGED = 2,
			  IPMIE_ERROR = 3 };
const char *ipmi_update_werr_e_string(enum ipmi_update_werr_e val);

/*
 * When dealing with strings, they can be unicode or ASCII, and some
 * can be binary.
 */
enum ipmi_str_type_e {
  IPMI_ASCII_STR	= 0,
  IPMI_UNICODE_STR	= 1,
  IPMI_BINARY_STR	= 2,
};

/* Used to tell if some value is present.  */
enum ipmi_value_present_e { IPMI_NO_VALUES_PRESENT,
			    IPMI_RAW_VALUE_PRESENT,
			    IPMI_BOTH_VALUES_PRESENT };

/*
 * Sensor bits
 */

/* Note that a sensor with a settable hysteresis value can also be
   read, but a fixed value cannot be read (it's in the SDR). */
#define IPMI_HYSTERESIS_SUPPORT_NONE		0
#define IPMI_HYSTERESIS_SUPPORT_READABLE	1
#define IPMI_HYSTERESIS_SUPPORT_SETTABLE	2
#define IPMI_HYSTERESIS_SUPPORT_FIXED		3
const char *ipmi_get_hysteresis_support_string(unsigned int val);

#define IPMI_THRESHOLD_ACCESS_SUPPORT_NONE	0
#define IPMI_THRESHOLD_ACCESS_SUPPORT_READABLE	1
#define IPMI_THRESHOLD_ACCESS_SUPPORT_SETTABLE	2
#define IPMI_THRESHOLD_ACCESS_SUPPORT_FIXED	3
const char *ipmi_get_threshold_access_support_string(unsigned int val);

#define IPMI_EVENT_SUPPORT_PER_STATE		0
#define IPMI_EVENT_SUPPORT_ENTIRE_SENSOR	1
#define IPMI_EVENT_SUPPORT_GLOBAL_ENABLE	2
#define IPMI_EVENT_SUPPORT_NONE			3
const char *ipmi_get_event_support_string(unsigned int val);


#define IPMI_SENSOR_TYPE_TEMPERATURE			0x01
#define IPMI_SENSOR_TYPE_VOLTAGE			0x02
#define IPMI_SENSOR_TYPE_CURRENT			0x03
#define IPMI_SENSOR_TYPE_FAN				0x04
#define IPMI_SENSOR_TYPE_PHYSICAL_SECURITY		0x05
#define IPMI_SENSOR_TYPE_PLATFORM_SECURITY		0x06
#define IPMI_SENSOR_TYPE_PROCESSOR			0x07
#define IPMI_SENSOR_TYPE_POWER_SUPPLY			0x08
#define IPMI_SENSOR_TYPE_POWER_UNIT			0x09
#define IPMI_SENSOR_TYPE_COOLING_DEVICE			0x0a
#define IPMI_SENSOR_TYPE_OTHER_UNITS_BASED_SENSOR	0x0b
#define IPMI_SENSOR_TYPE_MEMORY				0x0c
#define IPMI_SENSOR_TYPE_DRIVE_SLOT			0x0d
#define IPMI_SENSOR_TYPE_POWER_MEMORY_RESIZE		0x0e
#define IPMI_SENSOR_TYPE_SYSTEM_FIRMWARE_PROGRESS	0x0f
#define IPMI_SENSOR_TYPE_EVENT_LOGGING_DISABLED		0x10
#define IPMI_SENSOR_TYPE_WATCHDOG_1			0x11
#define IPMI_SENSOR_TYPE_SYSTEM_EVENT			0x12
#define IPMI_SENSOR_TYPE_CRITICAL_INTERRUPT		0x13
#define IPMI_SENSOR_TYPE_BUTTON				0x14
#define IPMI_SENSOR_TYPE_MODULE_BOARD			0x15
#define IPMI_SENSOR_TYPE_MICROCONTROLLER_COPROCESSOR	0x16
#define IPMI_SENSOR_TYPE_ADD_IN_CARD			0x17
#define IPMI_SENSOR_TYPE_CHASSIS			0x18
#define IPMI_SENSOR_TYPE_CHIP_SET			0x19
#define IPMI_SENSOR_TYPE_OTHER_FRU			0x1a
#define IPMI_SENSOR_TYPE_CABLE_INTERCONNECT		0x1b
#define IPMI_SENSOR_TYPE_TERMINATOR			0x1c
#define IPMI_SENSOR_TYPE_SYSTEM_BOOT_INITIATED		0x1d
#define IPMI_SENSOR_TYPE_BOOT_ERROR			0x1e
#define IPMI_SENSOR_TYPE_OS_BOOT			0x1f
#define IPMI_SENSOR_TYPE_OS_CRITICAL_STOP		0x20
#define IPMI_SENSOR_TYPE_SLOT_CONNECTOR			0x21
#define IPMI_SENSOR_TYPE_SYSTEM_ACPI_POWER_STATE	0x22
#define IPMI_SENSOR_TYPE_WATCHDOG_2			0x23
#define IPMI_SENSOR_TYPE_PLATFORM_ALERT			0x24
#define IPMI_SENSOR_TYPE_ENTITY_PRESENCE		0x25
#define IPMI_SENSOR_TYPE_MONITOR_ASIC_IC		0x26
#define IPMI_SENSOR_TYPE_LAN				0x27
#define IPMI_SENSOR_TYPE_MANAGEMENT_SUBSYSTEM_HEALTH	0x28
#define IPMI_SENSOR_TYPE_BATTERY			0x29
#define IPMI_SENSOR_TYPE_SESSION_AUDIT			0x2a
#define IPMI_SENSOR_TYPE_VERSION_CHANGE			0x2b
#define IPMI_SENSOR_TYPE_FRU_STATE			0x2c
const char *ipmi_get_sensor_type_string(unsigned int val);

#define IPMI_EVENT_READING_TYPE_THRESHOLD			0x01
#define IPMI_EVENT_READING_TYPE_DISCRETE_USAGE			0x02
#define IPMI_EVENT_READING_TYPE_DISCRETE_STATE			0x03
#define IPMI_EVENT_READING_TYPE_DISCRETE_PREDICTIVE_FAILURE	0x04
#define IPMI_EVENT_READING_TYPE_DISCRETE_LIMIT_EXCEEDED		0x05
#define IPMI_EVENT_READING_TYPE_DISCRETE_PERFORMANCE_MET	0x06
#define IPMI_EVENT_READING_TYPE_DISCRETE_SEVERITY		0x07
#define IPMI_EVENT_READING_TYPE_DISCRETE_DEVICE_PRESENCE	0x08
#define IPMI_EVENT_READING_TYPE_DISCRETE_DEVICE_ENABLE		0x09
#define IPMI_EVENT_READING_TYPE_DISCRETE_AVAILABILITY		0x0a
#define IPMI_EVENT_READING_TYPE_DISCRETE_REDUNDANCY		0x0b
#define IPMI_EVENT_READING_TYPE_DISCRETE_ACPI_POWER		0x0c
#define IPMI_EVENT_READING_TYPE_SENSOR_SPECIFIC			0x6f
const char *ipmi_get_event_reading_type_string(unsigned int val);

#define IPMI_SENSOR_DIRECTION_UNSPECIFIED	0
#define IPMI_SENSOR_DIRECTION_INPUT		1
#define IPMI_SENSOR_DIRECTION_OUTPUT		2
const char *ipmi_get_sensor_direction_string(unsigned int val);

const char *ipmi_get_reading_name(unsigned int event_reading_type,
				  unsigned int sensor_type,
				  unsigned int val);

#define IPMI_ANALOG_DATA_FORMAT_UNSIGNED   0
#define IPMI_ANALOG_DATA_FORMAT_1_COMPL    1
#define IPMI_ANALOG_DATA_FORMAT_2_COMPL    2
#define IPMI_ANALOG_DATA_FORMAT_NOT_ANALOG 3

enum ipmi_rate_unit_e {
    IPMI_RATE_UNIT_NONE = 0,
    IPMI_RATE_UNIT_PER_US,
    IPMI_RATE_UNIT_PER_MS,
    IPMI_RATE_UNIT_PER_SEC,
    IPMI_RATE_UNIT_MIN,
    IPMI_RATE_UNIT_HOUR,
    IPMI_RATE_UNIT_DAY,
};
const char *ipmi_get_rate_unit_string(enum ipmi_rate_unit_e val);

enum ipmi_unit_type_e {
    IPMI_UNIT_TYPE_UNSPECIFIED = 0,
    IPMI_UNIT_TYPE_DEGREES_C,
    IPMI_UNIT_TYPE_DEGREES_F,
    IPMI_UNIT_TYPE_DEGREES_K,
    IPMI_UNIT_TYPE_VOLTS,
    IPMI_UNIT_TYPE_AMPS,
    IPMI_UNIT_TYPE_WATTS,
    IPMI_UNIT_TYPE_JOULES,
    IPMI_UNIT_TYPE_COULOMBS,
    IPMI_UNIT_TYPE_VA,
    IPMI_UNIT_TYPE_NITS = 10,
    IPMI_UNIT_TYPE_LUMENS,
    IPMI_UNIT_TYPE_LUX,
    IPMI_UNIT_TYPE_CANDELA,
    IPMI_UNIT_TYPE_KPA,
    IPMI_UNIT_TYPE_PSI,
    IPMI_UNIT_TYPE_NEWTONS,
    IPMI_UNIT_TYPE_CFM,
    IPMI_UNIT_TYPE_RPM,
    IPMI_UNIT_TYPE_HZ,
    IPMI_UNIT_TYPE_USECONDS = 20,
    IPMI_UNIT_TYPE_MSECONDS,
    IPMI_UNIT_TYPE_SECONDS,
    IPMI_UNIT_TYPE_MINUTE,
    IPMI_UNIT_TYPE_HOUR,
    IPMI_UNIT_TYPE_DAY,
    IPMI_UNIT_TYPE_WEEK,
    IPMI_UNIT_TYPE_MIL,
    IPMI_UNIT_TYPE_INCHES,
    IPMI_UNIT_TYPE_FEET,
    IPMI_UNIT_TYPE_CUBIC_INCHS = 30,
    IPMI_UNIT_TYPE_CUBIC_FEET,
    IPMI_UNIT_TYPE_MILLIMETERS,
    IPMI_UNIT_TYPE_CENTIMETERS,
    IPMI_UNIT_TYPE_METERS,
    IPMI_UNIT_TYPE_CUBIC_CENTIMETERS,
    IPMI_UNIT_TYPE_CUBIC_METERS,
    IPMI_UNIT_TYPE_LITERS,
    IPMI_UNIT_TYPE_FL_OZ,
    IPMI_UNIT_TYPE_RADIANS,
    IPMI_UNIT_TYPE_SERADIANS = 40,
    IPMI_UNIT_TYPE_REVOLUTIONS,
    IPMI_UNIT_TYPE_CYCLES,
    IPMI_UNIT_TYPE_GRAVITIES,
    IPMI_UNIT_TYPE_OUNCES,
    IPMI_UNIT_TYPE_POUNDS,
    IPMI_UNIT_TYPE_FOOT_POUNDS,
    IPMI_UNIT_TYPE_OUNCE_INCHES,
    IPMI_UNIT_TYPE_GAUSS,
    IPMI_UNIT_TYPE_GILBERTS,
    IPMI_UNIT_TYPE_HENRIES = 50,
    IPMI_UNIT_TYPE_MHENRIES,
    IPMI_UNIT_TYPE_FARADS,
    IPMI_UNIT_TYPE_UFARADS,
    IPMI_UNIT_TYPE_OHMS,
    IPMI_UNIT_TYPE_SIEMENS,
    IPMI_UNIT_TYPE_MOLES,
    IPMI_UNIT_TYPE_BECQUERELS,
    IPMI_UNIT_TYPE_PPM,
    IPMI_UNIT_TYPE_reserved1,
    IPMI_UNIT_TYPE_DECIBELS = 60,
    IPMI_UNIT_TYPE_DbA,
    IPMI_UNIT_TYPE_DbC,
    IPMI_UNIT_TYPE_GRAYS,
    IPMI_UNIT_TYPE_SIEVERTS,
    IPMI_UNIT_TYPE_COLOR_TEMP_DEG_K,
    IPMI_UNIT_TYPE_BITS,
    IPMI_UNIT_TYPE_KBITS,
    IPMI_UNIT_TYPE_MBITS,
    IPMI_UNIT_TYPE_GBITS,
    IPMI_UNIT_TYPE_BYTES = 70,
    IPMI_UNIT_TYPE_KBYTES,
    IPMI_UNIT_TYPE_MBYTES,
    IPMI_UNIT_TYPE_GBYTES,
    IPMI_UNIT_TYPE_WORDS,
    IPMI_UNIT_TYPE_DWORDS,
    IPMI_UNIT_TYPE_QWORDS,
    IPMI_UNIT_TYPE_LINES,
    IPMI_UNIT_TYPE_HITS,
    IPMI_UNIT_TYPE_MISSES,
    IPMI_UNIT_TYPE_RETRIES = 80,
    IPMI_UNIT_TYPE_RESETS,
    IPMI_UNIT_TYPE_OVERRUNS,
    IPMI_UNIT_TYPE_UNDERRUNS,
    IPMI_UNIT_TYPE_COLLISIONS,
    IPMI_UNIT_TYPE_PACKETS,
    IPMI_UNIT_TYPE_MESSAGES,
    IPMI_UNIT_TYPE_CHARACTERS,
    IPMI_UNIT_TYPE_ERRORS,
    IPMI_UNIT_TYPE_CORRECTABLE_ERRORS,
    IPMI_UNIT_TYPE_UNCORRECTABLE_ERRORS = 90,
    IPMI_UNIT_TYPE_FATAL_ERRORS,
    IPMI_UNIT_TYPE_GRAMS,
};
const char *ipmi_get_unit_type_string(enum ipmi_unit_type_e val);

enum ipmi_modifier_unit_use_e {
    IPMI_MODIFIER_UNIT_NONE = 0,
    IPMI_MODIFIER_UNIT_BASE_DIV_MOD,
    IPMI_MODIFIER_UNIT_BASE_MULT_MOD,
};

#define IPMI_LINEARIZATION_LINEAR	0
#define IPMI_LINEARIZATION_LN		1
#define IPMI_LINEARIZATION_LOG10	2
#define IPMI_LINEARIZATION_LOG2		3
#define IPMI_LINEARIZATION_E		4
#define IPMI_LINEARIZATION_EXP10	5
#define IPMI_LINEARIZATION_EXP2		6
#define IPMI_LINEARIZATION_1_OVER_X	7
#define IPMI_LINEARIZATION_SQR		8
#define IPMI_LINEARIZATION_CUBE		9
#define IPMI_LINEARIZATION_SQRT		10
#define IPMI_LINEARIZATION_1_OVER_CUBE	11
#define IPMI_LINEARIZATION_NONLINEAR	0x70

/* Event types and directions for sensors. */
enum ipmi_thresh_e {
    IPMI_LOWER_NON_CRITICAL = 0,
    IPMI_LOWER_CRITICAL,
    IPMI_LOWER_NON_RECOVERABLE,
    IPMI_UPPER_NON_CRITICAL,
    IPMI_UPPER_CRITICAL,
    IPMI_UPPER_NON_RECOVERABLE
};
const char *ipmi_get_threshold_string(enum ipmi_thresh_e val);

enum ipmi_event_value_dir_e {
    IPMI_GOING_LOW = 0,
    IPMI_GOING_HIGH
};
const char *ipmi_get_value_dir_string(enum ipmi_event_value_dir_e val);

enum ipmi_event_dir_e {
    IPMI_ASSERTION = 0,
    IPMI_DEASSERTION
};
const char *ipmi_get_event_dir_string(enum ipmi_event_dir_e val);

/* Global init field for MC device locator SDR. */
#define IPMI_GLOBAL_INIT_ENABLE_EVENT_MSG_GENERATION 0
#define IPMI_GLOBAL_INIT_DISABLE_EVENT_MSG_GENERATION 1
#define IPMI_GLOBAL_INIT_DO_NOT_INIT 2

/*
 * Entity IDs
 */
#define IPMI_ENTITY_ID_UNSPECIFIED			0
#define IPMI_ENTITY_ID_OTHER				1
#define IPMI_ENTITY_ID_UNKOWN				2
#define IPMI_ENTITY_ID_PROCESSOR			3
#define IPMI_ENTITY_ID_DISK				4
#define IPMI_ENTITY_ID_PERIPHERAL			5
#define IPMI_ENTITY_ID_SYSTEM_MANAGEMENT_MODULE		6
#define IPMI_ENTITY_ID_SYSTEM_BOARD			7
#define IPMI_ENTITY_ID_MEMORY_MODULE			8
#define IPMI_ENTITY_ID_PROCESSOR_MODULE			9
#define IPMI_ENTITY_ID_POWER_SUPPLY			10
#define IPMI_ENTITY_ID_ADD_IN_CARD			11
#define IPMI_ENTITY_ID_FRONT_PANEL_BOARD		12
#define IPMI_ENTITY_ID_BACK_PANEL_BOARD			13
#define IPMI_ENTITY_ID_POWER_SYSTEM_BOARD		14
#define IPMI_ENTITY_ID_DRIVE_BACKPLANE			15
#define IPMI_ENTITY_ID_SYSTEM_INTERNAL_EXPANSION_BOARD	16
#define IPMI_ENTITY_ID_OTHER_SYSTEM_BOARD		17
#define IPMI_ENTITY_ID_PROCESSOR_BOARD			18
#define IPMI_ENTITY_ID_POWER_UNIT			19
#define IPMI_ENTITY_ID_POWER_MODULE			20
#define IPMI_ENTITY_ID_POWER_MANAGEMENT_BOARD		21
#define IPMI_ENTITY_ID_CHASSIS_BACK_PANEL_BOARD		22
#define IPMI_ENTITY_ID_SYSTEM_CHASSIS			23
#define IPMI_ENTITY_ID_SUB_CHASSIS			24
#define IPMI_ENTITY_ID_OTHER_CHASSIS_BOARD		25
#define IPMI_ENTITY_ID_DISK_DRIVE_BAY			26
#define IPMI_ENTITY_ID_PERIPHERAL_BAY			27
#define IPMI_ENTITY_ID_DEVICE_BAY			28
#define IPMI_ENTITY_ID_FAN_COOLING			29
#define IPMI_ENTITY_ID_COOLING_UNIT			30
#define IPMI_ENTITY_ID_CABLE_INTERCONNECT		31
#define IPMI_ENTITY_ID_MEMORY_DEVICE			32
#define IPMI_ENTITY_ID_SYSTEM_MANAGEMENT_SOFTWARE	33
#define IPMI_ENTITY_ID_BIOS				34
#define IPMI_ENTITY_ID_OPERATING_SYSTEM			35
#define IPMI_ENTITY_ID_SYSTEM_BUS			36
#define IPMI_ENTITY_ID_GROUP				37
#define IPMI_ENTITY_ID_REMOTE_MGMT_COMM_DEVICE		38
#define IPMI_ENTITY_ID_EXTERNAL_ENVIRONMENT		39
#define IPMI_ENTITY_ID_BATTERY				40
#define IPMI_ENTITY_ID_PROCESSING_BLADE			41
#define IPMI_ENTITY_ID_CONNECTIVITY_SWITCH		42
#define IPMI_ENTITY_ID_PROCESSOR_MEMORY_MODULE		43
#define IPMI_ENTITY_ID_IO_MODULE			44
#define IPMI_ENTITY_ID_PROCESSOR_IO_MODULE		45
#define IPMI_ENTITY_ID_MGMT_CONTROLLER_FIRMWARE		46
#define IPMI_ENTITY_ID_IPMI_CHANNEL			47
#define IPMI_ENTITY_ID_PCI_BUS				48
#define IPMI_ENTITY_ID_PCI_EXPRESS_BUS			49
#define IPMI_ENTITY_ID_SCSI_BUS				50
#define IPMI_ENTITY_ID_SATA_SAS_BUS			51
#define IPMI_ENTITY_ID_PROCESSOR_FRONT_SIDE_BUS		52
const char *ipmi_get_entity_id_string(unsigned int val);


/*
 * Control types.
 */
#define IPMI_CONTROL_LIGHT		1
#define IPMI_CONTROL_RELAY		2
#define IPMI_CONTROL_DISPLAY		3
#define IPMI_CONTROL_ALARM		4
#define IPMI_CONTROL_RESET		5
#define IPMI_CONTROL_POWER		6
#define IPMI_CONTROL_FAN_SPEED		7
#define IPMI_CONTROL_IDENTIFIER		8
#define IPMI_CONTROL_ONE_SHOT_RESET	9
#define IPMI_CONTROL_OUTPUT		10
#define IPMI_CONTROL_ONE_SHOT_OUTPUT	11
const char *ipmi_get_control_type_string(unsigned int val);

#define IPMI_CONTROL_COLOR_BLACK	0
#define IPMI_CONTROL_COLOR_WHITE	1
#define IPMI_CONTROL_COLOR_RED		2
#define IPMI_CONTROL_COLOR_GREEN	3
#define IPMI_CONTROL_COLOR_BLUE		4
#define IPMI_CONTROL_COLOR_YELLOW	5
#define IPMI_CONTROL_COLOR_ORANGE	6
const char *ipmi_get_color_string(unsigned int val);


/*
 * chassis types from FRUs
 */
#define IPMI_FRU_CT_OTHER                  1
#define IPMI_FRU_CT_UNKNOWN                2
#define IPMI_FRU_CT_DESKTOP                3
#define IPMI_FRU_CT_LOW_PROFILE_DESKTOP    4
#define IPMI_FRU_CT_PIZZA_BOX              5
#define IPMI_FRU_CT_MINI_TOWER             6
#define IPMI_FRU_CT_TOWER                  7
#define IPMI_FRU_CT_PORTABLE               8
#define IPMI_FRU_CT_LAPTOP                 9
#define IPMI_FRU_CT_NOTEBOOK              10
#define IPMI_FRU_CT_HANDHELD              11
#define IPMI_FRU_CT_DOCKING_STATION       12
#define IPMI_FRU_CT_ALL_IN_ONE            13
#define IPMI_FRU_CT_SUB_NOTEBOOK          14
#define IPMI_FRU_CT_SPACE_SAVING          15
#define IPMI_FRU_CT_LUNCH_BOX             16
#define IPMI_FRU_CT_MAIN_SERVER_CHASSIS   17
#define IPMI_FRU_CT_EXPANSION_CHASSIS     18
#define IPMI_FRU_CT_SUB_CHASSIS           19
#define IPMI_FRU_CT_BUS_EXPANSION_CHASSIS 20
#define IPMI_FRU_CT_PERIPERAL_CHASSIS     21
#define IPMI_FRU_CT_RAID_CHASSIS          22
#define IPMI_FRU_CT_RACK_MOUNT_CHASSIS    23


/* 
 * Various SDR values
 */
#define IPMI_SDR_FULL_SENSOR_RECORD		0x01
#define IPMI_SDR_COMPACT_SENSOR_RECORD		0x02
#define IPMI_SDR_ENTITY_ASSOCIATION_RECORD	0x08
#define IPMI_SDR_DR_ENTITY_ASSOCIATION_RECORD	0x09
#define IPMI_SDR_GENERIC_DEVICE_LOCATOR_RECORD	0x10
#define IPMI_SDR_FRU_DEVICE_LOCATOR_RECORD	0x11
#define IPMI_SDR_MC_DEVICE_LOCATOR_RECORD	0x12
#define IPMI_SDR_MC_CONFIRMATION_RECORD		0x13
#define IPMI_SDR_MC_BMC_MESSAGE_CHANNEL_RECORD	0x14

/*
 * Misc values
 */
/* Event was handled (so don't send it to the unhandled event
   handler), and do NOT pass the event contents to other event
   handlers. */
#define IPMI_EVENT_HANDLED		0
/* I did not handle this event. */
#define IPMI_EVENT_NOT_HANDLED		1
/* Event was handled (so don't send it to the unhandled event
   handler), but still pass the event contents to other event
   handlers. */
#define IPMI_EVENT_HANDLED_PASS		2

#define IPMI_TIMEOUT_NOW	0
#define IPMI_TIMEOUT_FOREVER	LONG_MAX

/* Used when setting data that can be volatile or non-volatile. */
enum ipmi_set_dest_e {
    IPMI_SET_DEST_NON_VOLATILE = 1,
    IPMI_SET_DEST_VOLATILE = 2
};

/* Used for options on FRUs and strings. */
#define IPMI_STRING_OPTION_NONE		0
#define IPMI_STRING_OPTION_8BIT_ONLY	(1 << 0) /* Don't use 4/6 bit chars */

#ifdef __cplusplus
}
#endif

#endif /* OPENIPMI_BITS_H */
