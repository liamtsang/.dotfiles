# Nushell Environment Config File
#
# version = "0.96.1"

def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)
path add /home/liamt/.local/bin
path add /home/liamt/.cargo/bin
path add /root/.local/bin
path add /var/lib/flatpak/exports/share
path add /home/liamt/.local/share/flatpak/exports/share
path add /usr/local/go/bin
path add /home/liamt/go/bin
path add ~/.bun/bin
path add /opt/thunderbird
path add /home/liamt/.fly/bin
path add /home/liamt/.local/share/pnpm
path add /home/liamt/.local/share/fnm

# $env.CLOUDFLARE_API_TOKEN = "7EbuKk0q4kjEdQRy5MQLXJh7ZtGeGKyj9JZXcBbU"
# $env.CLOUDFLARE_ACCOUNT_ID = "6f15a8824cd9137f63041853473f071f"
$env.METIS_CONFIG = "/etc/metis/config.ini"

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

zoxide init nushell | save -f ~/.zoxide.nu

# export-env { $env.STARSHIP_SHELL = "nu"; load-env {
#     STARSHIP_SESSION_KEY: (random chars -l 16)
#     PROMPT_MULTILINE_INDICATOR: (
#         ^/usr/local/bin/starship prompt --continuation
#     )

#     # Does not play well with default character module.
#     # TODO: Also Use starship vi mode indicators?
#     PROMPT_INDICATOR: ""

#     PROMPT_COMMAND: {||
#         # jobs are not supported
#         (
#             ^/usr/local/bin/starship prompt
#                 --cmd-duration $env.CMD_DURATION_MS
#                 $"--status=($env.LAST_EXIT_CODE)"
#                 --terminal-width (term size).columns
#         )
#     }

#     config: ($env.config? | default {} | merge {
#         render_right_prompt_on_last_line: true
#     })

#     PROMPT_COMMAND_RIGHT: {||
#         (
#             ^/usr/local/bin/starship prompt
#                 --right
#                 --cmd-duration $env.CMD_DURATION_MS
#                 $"--status=($env.LAST_EXIT_CODE)"
#                 --terminal-width (term size).columns
#         )
#     }
# }}

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
