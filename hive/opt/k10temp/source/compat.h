/*---------------------------------------------------------------------------
 *
 * compat.h
 *     Copyright (c) 2018 Guenter Roeck <linux@roeck-us.net>
 *
 *---------------------------------------------------------------------------
 */

#ifndef COMPAT_H
#define COMPAT_H

#include <linux/version.h>

#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 14, 0)
#define x86_stepping	x86_mask
#endif

#ifndef SENSOR_DEVICE_ATTR_RO
#define SENSOR_DEVICE_ATTR_RO(_name, _func, _index)		\
	SENSOR_DEVICE_ATTR(_name, 0444, _func##_show, NULL, _index)
#endif

#ifndef PCI_DEVICE_ID_AMD_17H_DF_F3
#define PCI_DEVICE_ID_AMD_17H_DF_F3		0x1463
#endif

#ifndef PCI_DEVICE_ID_AMD_17H_M10H_DF_F3
#define PCI_DEVICE_ID_AMD_17H_M10H_DF_F3	0x15eb
#endif

#ifndef PCI_DEVICE_ID_AMD_17H_M30H_DF_F3
#define PCI_DEVICE_ID_AMD_17H_M30H_DF_F3	0x1493
#endif

#ifndef PCI_DEVICE_ID_AMD_17H_M70H_DF_F3
#define PCI_DEVICE_ID_AMD_17H_M70H_DF_F3	0x1443
#define AMD_17H_M70H_DF_F3_LOCAL
#endif

#ifndef PCI_VENDOR_ID_HYGON
#define PCI_VENDOR_ID_HYGON			0x1d94
#endif

#endif /* COMPAT_H */
