#!/usr/bin/env python3

# To run without install relative imports needs to match the module ones, which
# is true when in 'src' directory, then: python3 -m upp.upp --help

VERSION="0.0.9-1"

import click
import tempfile
from upp import decode
#import pkg_resources
import os.path
import sys


CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])
REG_CTRL_CLASS = 'Control\\Class\\{4d36e968-e325-11ce-bfc1-08002be10318}\\0000'
REG_KEY = 'ControlSet001\\' + REG_CTRL_CLASS
REG_KEY_VAL = 'PP_PhmSoftPowerPlayTable'
REG_HEADER = 'Windows Registry Editor Version 5.00' + 2 * '\r\n' + \
             '[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\' + \
             REG_CTRL_CLASS + ']\r\n'


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def _normalize_var_path(var_path_str):
    var_path_list = var_path_str.strip('/').split('/')
    normalized_var_path_list = [
      int(item) if item.isdigit() else item for item in var_path_list]
    return normalized_var_path_list


def _is_int_or_float(value):
    if value.isdigit():
        return True
    try:
        float(value)
        return True
    except ValueError:
        pass
    return False


def _validate_set_pair(set_pair):
    valid = False
    if '=' in set_pair and _is_int_or_float(set_pair.split('=')[-1]):
        return set_pair.split('=')
    else:
        eprint("ERROR: Invalid variable assignment '{}'. ".format(set_pair),
              "Assignment must be specified in <variable-path>=<value> ",
              "format. For example: /PowerTuneTable/TDP=75")
        return None, None


def _get_pp_data_from_registry(reg_file_path):
    reg_path = 'HKLM\\SYSTEM\\' + REG_KEY + ':' + REG_KEY_VAL
    tmp_pp_file = tempfile.NamedTemporaryFile(prefix='reg_pp_table_',
                                              delete=False)
    msg = ' Soft PowerPlay data from {}\n  key:value > {}\n'
    try:
        from Registry import Registry
    except ImportError as e:
        eprint('ERROR: -f/--from-registry option requires python-registry',
              'package, consider installing it with PIP.')
        sys.exit(-2)
    try:
        reg = Registry.Registry(reg_file_path)
        key = reg.open(REG_KEY)
        data_type = key.value(REG_KEY_VAL).value_type_str()
        registry_data = key.value(REG_KEY_VAL).raw_data()
    except Exception as e:
        eprint(('ERROR: Can not get' + msg).format(reg_file_path, reg_path))
        eprint(e)
        return None
    print(('Successfully loaded' + msg).format(reg_file_path, reg_path))
    decode._write_binary_file(tmp_pp_file.name, registry_data)
    tmp_pp_file.close()

    return tmp_pp_file.name


def _check_file_writeable(filename):
    if os.path.exists(filename):
        if os.path.isfile(filename):
            return os.access(filename, os.W_OK)
        else:
            return False
    pdir = os.path.dirname(filename)
    if not pdir:
        pdir = '.'
    return os.access(pdir, os.W_OK)


def _write_pp_to_reg_file(filename, data, debug=False):
    if _check_file_writeable(filename):
        reg_string = REG_KEY_VAL[3:] + '"=hex:' + data.hex(',')
        reg_lines = [reg_string[i:i+75] for i in range(0, len(reg_string), 75)]
        reg_lines[0] = '"' + REG_KEY_VAL[:3] + reg_lines[0]
        formatted_reg_string = '\\\r\n  '.join(reg_lines)
        reg_pp_data = REG_HEADER + formatted_reg_string + 2 * '\r\n'
        if debug:
            print(reg_pp_data)
        decode._write_binary_file(filename, reg_pp_data.encode('utf-16'))
        print('Written {} Soft PowerPlay bytes to {}'.format(len(data),
                                                             filename))
    else:
        eprint('Can not write to {}'.format(filename))
    return 0


@click.group(context_settings=CONTEXT_SETTINGS)
@click.option('-p', '--pp-file', help='Input/output PP table binary file.',
              metavar='<filename>',
              default='/sys/class/drm/card0/device/pp_table')
@click.option('-f', '--from-registry',
              help='Import PP_PhmSoftPowerPlayTable from Windows registry ' +
                   '(overrides -p / --pp-file option).',
              metavar='<filename>')
@click.option('--debug/--no-debug', '-d/ ', default='False',
              help='Debug mode.')
@click.option('--ignore/--no-ignore ', '-i/ ', default='False',
              help='Ignore invalid params and continue.')
@click.pass_context
def cli(ctx, debug, pp_file, from_registry, ignore):
    """UPP: Uplift Power Play

    A tool for parsing, dumping and modifying data in Radeon PowerPlay tables.

    UPP is able to parse and modify binary data structures of PowerPlay
    tables commonly found on certain AMD Radeon GPUs. Drivers on recent
    AMD GPUs allow PowerPlay tables to be dynamically modified on runtime,
    which may be known as "soft PowerPlay tables". On Linux, the PowerPlay
    table is by default found at:

    \b
       /sys/class/drm/card0/device/pp_table

    There are also two alternative ways of getting PowerPlay data that this
    tool supports:

    \b
     - By extracting PowerPlay table from Video ROM image (see extract command)
     - Import "Soft PowerPlay" table from Windows registry, directly from
       offline Windows/System32/config/SYSTEM file on disk, so it would work
       from Linux distro that has acces to mounted Windows partition
       (path to SYSTEM registry file is specified with --from-registry option)

    This tool currently supports parsing and modifying PowerPlay tables
    found on the following AMD GPU families:

    \b
      - Polaris
      - Vega
      - Radeon VII
      - Navi 10, 14
      - Navi 21, 22, 23

    Note: iGPUs found in many recent AMD APUs are using completely different
    PowerPlay control methods, this tool does not support them.

    If you have bugs to report or features to request please check:

      github.com/sibradzic/upp
    """
    ctx.ensure_object(dict)
    ctx.obj['DEBUG'] = debug
    ctx.obj['PPBINARY'] = pp_file
    ctx.obj['FROMREGISTRY'] = from_registry
    ctx.obj['IGNORE'] = ignore


@click.command(short_help='Show UPP version.')
def version():
    """Shows UPP version."""
    version = VERSION #pkg_resources.require("upp")[0].version
    click.echo(version)


@click.command(short_help='Dumps all PowerPlay parameters to console.')
@click.option('--raw/--no-raw', '-r/ ', help='Show raw binary data.',
              default='False')
@click.pass_context
def dump(ctx, raw):
    """Dumps all PowerPlay data to console

    De-serializes PowerPlay binary data into a human-readable text output.
    For example:

    \b
        upp --pp-file=radeon.pp_table dump

    In standard mode all data will be dumped to console, where
    data tree hierarchy is indicated by indentation.

    In raw mode a table showing all hex and binary data, as well
    as variable names and values, will be dumped.
    """
    debug = ctx.obj['DEBUG']
    pp_file = ctx.obj['PPBINARY']
    from_registry = ctx.obj['FROMREGISTRY']
    if from_registry:
        pp_file = _get_pp_data_from_registry(from_registry)
    decode.dump_pp_table(pp_file, rawdump=raw, debug=debug)
    return 0


@click.command(short_help='Extract PowerPlay table from Video BIOS ROM image.')
@click.option('-r', '--video-rom', required=True, metavar='<filename>',
              help='Input Video ROM binary image file.')
@click.pass_context
def extract(ctx, video_rom):
    """Extracts PowerPlay data from full VBIOS ROM image

    The source video ROM binary must be specified with -r/--video-rom
    parameter, and extracted PowerPlay table will be saved into file
    specified with -p/--pp-file. For example:

    \b
        upp --pp-file=extracted.pp_table extract -r VIDEO.rom

    Default output file name will be an original ROM file name with an
    additional .pp_table extension.
    """
    pp_file = ctx.obj['PPBINARY']
    ctx.obj['ROMBINARY'] = video_rom
    # Override default, we don't want to extract any random VBIOS into sysfs
    if pp_file.endswith('device/pp_table'):
        pp_file = video_rom + '.pp_table'
    msg = "Extracting PP table from '{}' ROM image..."
    print(msg.format(video_rom))
    if decode.extract_rom(video_rom, pp_file):
        print('Done')

    return 0


@click.command(short_help='Inject PowerPlay table into Video BIOS ROM image.')
@click.option('-i', '--input-rom', required=True, metavar='<filename>',
              help='Input Video ROM binary image file.')
@click.option('-o', '--output-rom', required=False, metavar='<filename>',
              help='Output Video ROM binary image file.')
@click.pass_context
def inject(ctx, input_rom, output_rom):
    """Injects PowerPlay data from file into VBIOS ROM image

    The input video ROM binary must be specified with -i/--input-rom
    parameter, and the output ROM can be specified with an optional
    -o/--output-rom parameter.

    \b
        upp -p modded.pp_table inject -i original.rom -o modded.rom

    The output filename defaults to <input ROM file name>.modded.

    WARNING: Modified vROM image is probalby not going to work if flashed as
    is to your card, due to ROM signature checks on recent Radeon cards.
    Authors of this tool are in no way responsible for any damage that may
    happen to your expansive graphics card if you choose to flash the modified
    video ROM, you are doing it entierly on your own risk.
    """
    pp_file = ctx.obj['PPBINARY']
    if not output_rom:
        output_rom = input_rom + '.modded'
    msg = "Injecting {} PP table into {} ROM image..."
    print(msg.format(pp_file, input_rom))
    if decode.inject_pp_table(input_rom, output_rom, pp_file):
        print('Saved modified vROM image as {}.'.format(output_rom))

    return 0


@click.command(short_help='Get current value of a PowerPlay parameter(s).')
@click.argument('variable-path-set', nargs=-1, required=True)
@click.pass_context
def get(ctx, variable_path_set):
    """Retrieves current value of one or multiple PP parameters

    The parameter variable path must be specified in
    "/<param> notation", for example:

    \b
        upp get /FanTable/TargetTemperature /VddgfxLookupTable/7/Vdd

    The raw value of the parameter will be retrieved,
    decoded and displayed on console.
    Multiple PP parameters can be specified at the same time.
    """
    ignore = ctx.obj['IGNORE']
    debug = ctx.obj['DEBUG']
    pp_file = ctx.obj['PPBINARY']
    from_registry = ctx.obj['FROMREGISTRY']
    if from_registry:
        pp_file = _get_pp_data_from_registry(from_registry)
    pp_bytes = decode._read_binary_file(pp_file)
    data = decode.select_pp_struct(pp_bytes, debug=debug)

    for set_pair_str in variable_path_set:
        var_path = _normalize_var_path(set_pair_str)
        res = decode.get_value(pp_file, var_path, data, debug=debug)
        if res:
            print('{:n}'.format(res['value']))
        else:
            eprint('ERROR: Incorrect variable path:', set_pair_str)
            if ignore:
               print('null')
            else:
               return 2

    return 0


@click.command(short_help='Set value to PowerPlay parameter(s).')
@click.argument('variable-path-set', nargs=-1, required=True)
@click.option('-w', '--write', is_flag=True,
              help='Write changes to PP binary.', default=False)
@click.option('-t', '--to-registry', metavar='<filename>',
              help='Output to Windows registry .reg file.')
@click.pass_context
def set(ctx, variable_path_set, to_registry, write):
    """Sets value to one or multiple PP parameters

    The parameter path and value must be specified in
    "/<param>=<value> notation", for example:

    \b
        upp set /PowerTuneTable/TDP=75 /SclkDependencyTable/7/Sclk=107000

    Multiple PP parameters can be set at the same time.
    The PP tables will not be changed unless additional
    --write option is set.

    Optionally, if -t/--to-registry output is specified, an additional Windows
    registry format file with '.reg' extension will be generated, for example:

    \b
        upp set /PowerTuneTable/TDP=75 --to-registry=test

    will produce the file test.reg in the current working directory.
    """
    ignore = ctx.obj['IGNORE']
    debug = ctx.obj['DEBUG']
    pp_file = ctx.obj['PPBINARY']
    set_pairs = []
    for set_pair_str in variable_path_set:
        var, val = _validate_set_pair(set_pair_str)
        if var and val:
            var_path = _normalize_var_path(var)
            res = decode.get_value(pp_file, var_path)
            if res:
                if (val.isdigit()):
                    set_pairs += [var_path + [int(val)]]
                else:
                    set_pairs += [var_path + [float(val)]]
            else:
                eprint('ERROR: Incorrect variable path:', var)
                if not ignore:
                    return 2
        else:
            return 2

    pp_bytes = decode._read_binary_file(pp_file)
    data = decode.select_pp_struct(pp_bytes)

    for set_list in set_pairs:
        decode.set_value(pp_file, pp_bytes, set_list[:-1], set_list[-1],
                         data_dict=data, write=False, debug=debug)
    if write:
        #eprint("Commiting changes to '{}'.".format(pp_file))
        decode._write_binary_file(pp_file, pp_bytes)
    else:
        eprint("WARNING: Nothing was written to '{}'.".format(pp_file),
              "Add --write option to commit the changes for real!")
    if to_registry:
        _write_pp_to_reg_file(to_registry + '.reg', pp_bytes, debug=debug)

    return 0


cli.add_command(extract)
cli.add_command(inject)
cli.add_command(dump)
cli.add_command(get)
cli.add_command(set)
cli.add_command(version)


def main():
    cli(obj={})()


if __name__ == "__main__":
    main()
