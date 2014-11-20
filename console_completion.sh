#!/bin/sh
#
# Symfony2 App/Console autocompletion (commands and arguments only)
# Copyright (c) 2014, Joshua Thijssen
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or
#   other materials provided with the distribution.
#
# * Neither the name of the {organization} nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# Usable for both bash and zsh (probably)
#
# Usage:
#    Load the script (or add to your .bashrc)
#
#           source ./console_completion.sh
#
#    Autocomplete:
#
#           ./app/console <TAB>
#
#   Will autocomplete both commands and its arguments.
#

if [[ -n ${ZSH_VERSION-} ]]; then
    autoload -U +X bashcompinit && bashcompinit
fi

_complete_sf2_app_console() {
    local cur

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Assume first word is the actual app/console command
    console="${COMP_WORDS[0]}"

    if [[ ${COMP_CWORD} == 1 ]] ; then
        # No command found, return the list of available commands
        cmds=` ${console}  --no-ansi | sed -n -e '/^Available commands/,//p' | grep -n '^ ' | sed -e 's/^ \+//' | awk '{ print $2 }'`
    else
        # Commands found, parse options
        cmds=` ${console} ${COMP_WORDS[1]} --no-ansi --help | sed -n -e '/^Options/,/^$/p' | grep -n '^ ' | sed -e 's/^ \+//' | awk '{ print $2 }'`
    fi

    COMPREPLY=( $(compgen -W "${cmds}" -- ${cur}) )
    return 0
}

export COMP_WORDBREAKS="\ \"\\'><=;|&("
complete -F _complete_sf2_app_console console
