#!/usr/bin/env python3

import click
import decode

CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])


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
        print("ERROR: Invalid variable assignment '{}'. ".format(set_pair),
              "Assignment must be specified in <variable-path>=<value> ",
              "format. For example: /PowerTuneTable/TDP=75")
        return None, None


@click.group(context_settings=CONTEXT_SETTINGS)
@click.option('-i', '--input-file', help='Path to PP table binary file',
              default='/sys/class/drm/card0/device/pp_table')
@click.option('--debug/--no-debug', '-d/ ', default='False',
              help='Debug mode')
@click.pass_context
def cli(ctx, debug, input_file):
    """UPP: Uplift Power Play

    A tool for parsing, dumping and modifying data in Radeon PowerPlay tables.

    UPP is able to parse and modify binary data structures of PowerPlay
    tables commonly found on certain AMD Radeon GPUs. Drivers on recent
    AMD GPUs allow PowerPlay tables to be dynamically modified on runtime,
    which may be known as "soft-PowerPlay" in coin-mining community. On
    Linux, the PP table is by default found at:

    \b
       /sys/class/drm/card0/device/pp_table

    This tool currently supports reading and modifying PowerPlay tables
    found on the following AMD GPU families:

    \b
      - Polaris
      - Vega
      - Radeon VII
      - Navi 10

    Note: iGPUs found in many recent AMD APUs are using completely different
    PowerPlay control methods, this tool does not support them.

    I you have bugs to report or features to request please check:

      github.com/sibradzic/upp
    """
    ctx.ensure_object(dict)
    ctx.obj['DEBUG'] = debug
    ctx.obj['PPBINARY'] = input_file

@click.command(short_help='Dumps all PowerPlay parameters to console')
@click.option('--raw/--no-raw', '-r/ ', help='Show raw binary data',
              default='False')
@click.pass_context
def dump(ctx, raw):
    """Dumps all PowerPlay data to console

    De-serializes PowerPlay binary data into a Python dictionary.

    In standard mode all data will be dumped to console, where
    data hierarchy is indicated by indentation.

    In raw mode a table showing all hex and binary data, as well
    as variable names and values, will be dumped.
    """
    debug = ctx.obj['DEBUG']
    input_file = ctx.obj['PPBINARY']
    msg = "Dumping {} PP table from '{}' binary..."
    if raw:
        print(msg.format('raw', input_file))
        decode.decode_pp_table(input_file, debug=True)
    else:
        print(msg.format('the', input_file))
        decode.dump_pp_table(input_file, debug=debug)
    return 0


@click.command(short_help='Gets current value of a particular PP parameter')
@click.argument('variable-path')
@click.pass_context
def get(ctx, variable_path):
    """Retrieves current value of a particular PP parameter

    The parameter variable path must be specified in
    "/<param> notation", for example:

    \b
        /FanTable/TargetTemperature
        /VddGfxLookupTable/7/Vdd

    The raw value of the parameter will be retrieved,
    decoded and displayed on console.
    """
    debug = ctx.obj['DEBUG']
    input_file = ctx.obj['PPBINARY']
    var_path = _normalize_var_path(variable_path)
    res = decode.get_value(input_file, var_path, debug=debug)
    if res:
        print(res['value'])
    return 0


@click.command(short_help='Sets values to PP parameters')
@click.argument('variable-path-set', nargs=-1, required=True)
@click.option('-w', '--write', is_flag=True,
              help='Write changes to PP binary', default=False)
@click.pass_context
def set(ctx, variable_path_set, write):
    """Sets values to one or multiple PP parameters

    The parameter path and value must be specified in
    "/<param>=<value> notation", for example:

    \b
        /PowerTuneTable/TDP=75 /SocClockDependencyTable/7/SocClock=107000

    Multiple PP parameters can be set at the same time.
    The PP tables will not be changed unless additional
    --write option is set.
    """
    debug = ctx.obj['DEBUG']
    input_file = ctx.obj['PPBINARY']
    set_pairs = []
    for set_pair_str in variable_path_set:
        var, val = _validate_set_pair(set_pair_str)
        if var and val:
            var_path = _normalize_var_path(var)
            res = decode.get_value(input_file, var_path)
            if res:
                if (val.isdigit()):
                    set_pairs += [var_path + [int(val)]]
                else:
                    set_pairs += [var_path + [float(val)]]
            else:
                print('ERROR: Incorrect variable path:', var)
                return 2
        else:
            return 2
    data = decode.decode_pp_table(input_file, debug=debug)
    for set_list in set_pairs:
        decode.set_value(input_file, set_list[:-1], set_list[-1],
                         data_dict=data, write=False, debug=debug)
    if write:
        print("Commiting changes to '{}'.".format(input_file))
        decode._write_pp_tables_file(input_file, decode.pp_tbl_bytes)
    else:
        print("WARNING: Nothing was written to '{}'.".format(input_file),
              "Add --write option to commit the changes for real!")

    return 0


cli.add_command(dump)
cli.add_command(get)
cli.add_command(set)

if __name__ == "__main__":
    cli(obj={})()
