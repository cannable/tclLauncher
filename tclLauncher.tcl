#! /usr/bin/env wish

# tclLauncher.tcl --
#
#     Extremely simple launcher.
# 
# Copyright 2019 C. Annable
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package provide tclLauncher 1.0


# ------------------------------------------------------------------------------
# Default Variables

set ::guiIdx 0
set ::columns 1
set ::colCounter -1
set ::rowIndex(0) -1


# ------------------------------------------------------------------------------
# Procedure Definitions


# printHelp --
#
#           Prints help info
#
# Arguments:
#           none
#
# Results:
#           Prints help blurb stdout
#
proc printHelp {} {
    puts {Usage: tclLauncher config.tl}
    puts "\ntclLauncher - Extremely simple launcher.\n"
}


# getCoords --
#
#           Returns the column index for a new GUI object
#
# Arguments:
#           none
#
# Results:
#           Returns the column index for a new GUI object
#
proc getCoords {} {
    # Determine column index
    if {$::colCounter < ($::columns - 1)} {
        incr ::colCounter
    } else {
        set ::colCounter 0
    }

    set col $::colCounter

    # Determine Row index
    set row [incr ::rowIndex($col)]

    return [list $col $row]
}


# gridStuff --
#
#           Provides a consistent mechanism for adding GUI elements
#
# Arguments:
#           none
#
# Results:
#           Uses grid to add the GUI object
#

proc gridStuff {w} {
    set coords [getCoords]
    puts "coords: $coords"

    grid $w \
            -column [lindex $coords 0] \
            -row [lindex $coords 1] \
            -sticky ew
}


# ------------------------------------------------------------------------------
# Extensible UI


# Columns --
#
#           Sets the number of columns for the UI
#
# arguments:
#           none
#
# results:
#           Adjusts the number of columns
#
proc Columns {cols} {
    if {! [string is integer $cols]} {
        error "Columns must be an integer."
        exit 1
    }

    if {$cols < 1} {
        error "Number of columns must be greater than 1."
        exit 1
    }

    # Set the number of columns
    set ::columns $cols

    # Set the row counters
    for {set col 0} {$col <= $cols} {incr col} {
        set ::rowIndex($col) -1
    }
}


# Button --
#
#           adds a button
#
# arguments:
#           none
#
# results:
#           add a button to the ui
#
proc Button {title command} {
    set id ".button[incr ::guiIdx]"
    puts "id: $id"

    ttk::button $id -text $title \
        -command [list catch [list exec -- {*}$command &]]

    gridStuff $id
}


# tclButton --
#
#           Adds a Button, but one that runs Tcl code directly
#
# Arguments:
#           none
#
# Results:
#           Add a button to the UI
#
proc tclButton {title command} {
    set id ".button[incr ::guiIdx]"
    puts $id

    ttk::button $id -text $title -command $command
    #grid $id -column [getCoords]
    #pack $id -expand 1 -fill both

    gridStuff $id
}


# ------------------------------------------------------------------------------
# 'Main'


# No arguments, print usage info
if {$argc != 1} {
    printHelp
    exit
}

set cfgFile [lindex $argv 0]

puts "cfgFile: $cfgFile"

if {! [file exists $cfgFile]} {
    error "Config file '$cfgFile' doesn't exist."
    exit 1
}

if {! [file isfile $cfgFile]} {
    error "'$cfgFile' isn't a file."
    exit 1
}


# ------------------------------------------------------------------------------
# Build Base UI

# Defaults
bind all <Control-q> exit

source $cfgFile
