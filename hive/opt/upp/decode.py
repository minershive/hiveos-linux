#!/usr/bin/env python3

import codecs
import collections
import struct
import vbios


def odict(init_data=None):
    """
    Returns ordered dictionary (for consistent behavior on Python 2.7 & 3.6+)
    """
    if init_data:
        return collections.OrderedDict(init_data)
    else:
        return collections.OrderedDict()


def _read_pp_tables_file(filename):
    f = open(filename, 'rb')
    raw_data = f.read()
    f.close()
    return bytearray(raw_data)


def _write_pp_tables_file(filename, raw_data):
    try:
        f = open(filename, 'wb')
        f.write(raw_data)
        f.close()
    except PermissionError as e:
        msg = 'ERROR: {}\n' + \
              'To make PowerPlay table file writtable: sudo chmod o+w {}'
        print(msg.format(e, filename, filename))
        print(e)


def _bytes2hex(bytes):
    """
    Hex decoding helper

    Does special gymnastics to ensure consistent decoding on Python 2.7 & 3.x
    """
    return codecs.encode(bytes, 'hex_codec').decode()


def _get_array_len(array):
    all_data_items = '='
    for item in getattr(vbios, array):
        if item['type'] in vbios.base_types:
            all_data_items += item['type']
        else:
            array_size = 1
            array_type = getattr(vbios, item['type'])
            if 'max_count' in item:
                array_size = item['max_count']
                array_types = getattr(vbios, array_type[0]['type'])
                all_data_items += array_types * array_size
            else:
                if array_type in vbios.base_types:
                    all_data_items += array_type
                else:
                    for member in array_type:
                        all_data_items += getattr(vbios, member['type'])

    return struct.calcsize(all_data_items.replace('<', ''))


def decode_pp_table(pp_bin_file, data_struct=vbios.PowerPlay_header,
                    decoded_data=None, offset=0, debug=False):
    """
    De-serializes PowerPlay binary data into a Python dictionary

    This relies heavily on vbios.py binary file definition, where variable
    names as well as table and array structures are defined.

    Parameters:
    pp_bin_file (file): a file used for getting raw binary PowerPlay data
    data_struct (list): a special list of dictionaries defined in vbios.py
                        that describe binary C-like data structures containing
                        PowerPlay (PP) parameteres. Supports rudimentary
                        versioning of PP tables and arrays. A common structure
                        for all PP tables is defined in vbios.PowerPlay_header

    decoded_data (dict): A resulting PowerPlay data-structure dictionary, used
                         as parameter due to recursive nature of this function
    offset (int): An offset pointing to a parameter/table/array in a binary
                  file that is currently being decoded
    debug (bool): Debbuging output enabled

    Returns:
    decoded_data (dict): A resulting PowerPlay data-structure dictionary

    """

    if decoded_data is None:
        decoded_data = odict()
        global pp_tbl_bytes
        pp_tbl_bytes = _read_pp_tables_file(pp_bin_file)
        if debug:
            print(' Offset (dec.) t Raw val. Variable name ' + ' '*18 +
                  'Decoded value\n' + '-'*71)
    for field in data_struct:
        name = field['name']
        d_type = d_type = getattr(vbios, field['type'])
        # We decode standard types (char, short int, long int, etc.) as is
        if d_type in vbios.base_types and 'max_count' not in field:
            d_size = struct.calcsize(d_type)
            raw_bytes = pp_tbl_bytes[offset:offset+d_size]
            d_value = struct.unpack(d_type, raw_bytes)[0]
        # We're walking through simple base-type array here
        elif d_type in vbios.base_types and 'max_count' in field:
            decoded_data[name] = []
            fld_len = struct.calcsize(getattr(vbios,
                                              field['type']).replace('<', ''))
            for i in range(field['max_count']):
                decoded_data[name] += [odict()]
                data = decoded_data[name][i]
                array_field = [odict({'name': field['name'],
                                      'type': field['type']})]
                decode_pp_table(None, array_field, data, offset, debug)
                offset += fld_len
            continue
        # Non-standard types that are 'non-referenced'. These are the
        # immediately folllowing data tables or arrays (no jumping to offset)
        else:
            if debug:
                dbg_msg = ' 0x{:04x} Recursive dive into {}'
                print(dbg_msg.format(offset, name))
            decoded_data[name] = odict()
            # 'max_count' here indicates complex array of pre-determined size
            if 'max_count' in field:
                decoded_data[name] = []
                for i in range(field['max_count']):
                    array_len = _get_array_len(field['type'])
                    decoded_data[name] += [odict()]
                    data = decoded_data[name][i]
                    decode_pp_table(None, d_type, data, offset, debug)
                    offset = offset + array_len
            # For other tables or arrays we need to determine the size
            else:
                data = decoded_data[name]
                decode_pp_table(None, d_type, data, offset, debug)
                offset = offset + _get_array_len(field['type'])
            continue
        if debug:
            dbg_msg = ' 0x{:04x} ({:04n}) {} {:>8} {:32s}: {:n}'
            print(dbg_msg.format(offset, offset, d_type[-1],
                                 _bytes2hex(raw_bytes), name, d_value))
        decoded_data[name] = {'value':  d_value,
                              'offset': offset,
                              'type':   d_type}
        offset += d_size
        if name == 'RevisionId':
            current_rev = str(d_value)

        # Referenced data structures are always located at some offset, and
        # they always have RevisionId, which is always a frist field in the
        # structure. We need to know which version of a table to expect in
        # advance. Exception to this rule is root PowerPlay header version,
        # indicated by 'TableFormatRevision'
        if 'ref' in field:
            # Some tables are empty, indicated by null-pointer
            if not d_value:
                decoded_data[name] = None
                continue
            # 'NumEntries' indicates referenced array data structure, where we
            # need to iterate through NumEntries of entires whose structure is
            # defined in 'ref' ('RevisionId' also aplies here)
            if name == 'NumEntries':
                table_rev = current_rev
                array_len = _get_array_len(field['ref']+'_v'+table_rev)
                if 'Entries' not in decoded_data:
                    decoded_data['Entries'] = []
                for i in range(d_value):
                    decoded_data['Entries'] += [odict()]
                    data = decoded_data['Entries'][i]
                    off = offset + i*array_len
                    table_name = field['ref'] + '_v' + table_rev
                    if debug:
                        dbg_msg = ' 0x{:04x} Recursive dive into {} v{}' + \
                                  ' array entry {}'
                        print(dbg_msg.format(offset, field['ref'],
                                             table_rev, i))
                    decode_pp_table(None, getattr(vbios, table_name), data,
                                    off, debug)
            else:
                # Special case, only at the beginning of PowerPlay table
                if name == 'TableFormatRevision':
                    table_rev = str(d_value)
                    data = decoded_data
                    off = offset + 1
                else:
                    decoded_data[name] = odict()
                    raw_rev = pp_tbl_bytes[d_value:d_value+1]
                    table_rev = str(struct.unpack('B', raw_rev)[0])
                    data = decoded_data[name]
                    off = d_value
                table_name = field['ref'] + '_v' + table_rev
                if debug:
                    dbg_msg = ' 0x{:04x} Recursive dive into {} v{}' + \
                              ' @ 0x{:04x}'
                    print(dbg_msg.format(offset, name, table_rev, off))
                decode_pp_table(None, getattr(vbios, table_name), data,
                                off, debug)

    return decoded_data


def dump_pp_table(pp_bin_file, data_dict=None, indent=0, debug=False):
    """
    Prints all decoded PowerPlay parameters and their values to console
    """
    if data_dict is None:
        data_dict = decode_pp_table(pp_bin_file, debug=debug)
    for member in data_dict:
        if isinstance(data_dict[member], list):

            print('{}{}:'.format(' '*indent, member))
            i = 0
            for element in data_dict[member]:
                if len(element) == 1:
                    name = list(element.keys())[0]
                    if 'value' in element[name]:
                        print('{}{} {}: {}'.format(' '*(indent+2), name, i,
                                                   element[name]['value']))
                else:
                    print('{}{} {}:'.format(' '*(indent+2), member, i))
                    dump_pp_table(None, element, indent+4)
                i += 1
        elif data_dict[member] is None:
            print('{}{}: UNUSED'.format(' '*indent, member))
        elif 'value' in data_dict[member]:
            print('{}{}: {}'.format(' '*indent, member,
                                    data_dict[member]['value']))
        else:
            print('{}{}:'.format(' '*indent, member))
            dump_pp_table(None, data_dict[member], indent+2)


def get_value(pp_bin_file, var_path, data_dict=None, debug=False):
    """
    Returns value of a PowerPlay parameter specified in var_path

    Parameters:
    pp_bin_file (file): a file used for getting raw binary PowerPlay data
    var_path (list): a list containing representing a pp_table key names.
                     for example:
                         ['FanTable', 'TargetTemperature']
                         ['VddGfxLookupTable', 7, 'Vdd']
    data_dict (dict): Reuse existing PowerPlay data-structure dictionary
    debug (bool): Debbuging output enabled

    Returns:
    dict: A descriptor of a parameter, containing decoded 'value', decimal
          'offset' and struct type 'type' keys.

    """
    if data_dict is None:
        data = decode_pp_table(pp_bin_file, debug=debug)
    else:
        data = data_dict.copy()
    for category in var_path:
        if category is not None:
            # helper that allows skipping the 'Entries' key name
            if (isinstance(category, int)
               and isinstance(data, dict) and 'Entries' in data):
                data = data['Entries']
            try:
                data = data[category]
            except KeyError:
                msg = 'ERROR: Invalid parameter "{}", available ones are: {}'
                print(msg.format(category, ', '.join([k for k in data])))
                return None
            except (TypeError, IndexError):
                if isinstance(data, list):
                    indices = [str(i) for i in range(len(data))]
                else:
                    indices = []
                msg = 'ERROR: Invalid parameter "{}", available ones are: {}'
                print(msg.format(category, ', '.join(indices)))
                return None
    if data is None:
        print('ERROR: Table {} does not point anywhere'.format(category))
    if isinstance(data, list):
        print('ERROR: Decoded data does not contain any value, you probably',
              'wanna look deeper into data;',
              ', '.join([str(i) for i in range(len(data))]))
        return None
    if isinstance(data, dict) and 'value' not in data:
        # helper that allows skipping the key name of the element of the array
        if len(data) == 1 and isinstance(data, dict):
            key = list(data.keys())[0]
            if 'value' in data[key]:
                return data[key]
        print('ERROR: Decoded data does not contain any value, you probably',
              'wanna look deeper into data;', ', '.join(list(data.keys())))
        return None
    if not isinstance(data, dict):
        print('ERROR: Decoded data does not contain any final values, you',
              'probably wanna go back one step into the data structure')
        return None

    return data


def set_value(pp_bin_file, var_path, new_value, data_dict=None,
              write=False, debug=False):
    """
    Sets a PowerPlay parameter specified in var_path to a specified new value

    This will call a get_value(var_path) first, where parameter value will
    get decoded, and then the new value will be set. Finally, the new pp_table
    file with updated value will be written.

    Parameters:
    pp_bin_file (file): a file used for reading & writting raw binary PP data
    var_path (list): a list containing representing a pp_table key names.
                     for example:
                         ['FanTable', 'TargetTemperature']
                         ['VddGfxLookupTable', 7, 'Vdd']
    new_value (int): New value to be set
    data_dict (dict): Reuse existing PowerPlay data-structure dictionary
    write (bool): Actually writting data to PP-tables binary file
    debug (bool): Debbuging output enabled

    """
    var_pth_str = '.'.join([str(el) for el in var_path])
    current_data = get_value(pp_bin_file, var_path,
                             data_dict=data_dict, debug=debug)
    if current_data:
        curr_val = current_data['value']
        off = current_data['offset']
        d_type = current_data['type']
        d_size = struct.calcsize(d_type)
        msg = 'Changing {} from {} to {} at 0x{:03x}'
        print(msg.format(var_pth_str, curr_val, new_value, off))
    else:
        print('Can\'t decode {}'.format(var_path))
    bytes_value = struct.pack(d_type, new_value)
    if debug:
        current_bytes_value = pp_tbl_bytes[off:off+d_size]
        current_d_value = struct.unpack(d_type, current_bytes_value)[0]
        dbg_msg = ' 0x{:04x} ({:04n}) {} {:>8} {:32s}: {:n} {}'
        print(dbg_msg.format(off, off, d_type[-1],
                             _bytes2hex(current_bytes_value), var_pth_str,
                             current_d_value, 'CHANGES TO:'))
        print(dbg_msg.format(off, off, d_type[-1], _bytes2hex(bytes_value),
                             var_pth_str, new_value, ''))
    pp_tbl_bytes[off:off+d_size] = bytes_value
    if write:
        _write_pp_tables_file(pp_bin_file, pp_tbl_bytes)
