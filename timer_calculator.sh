#!/bin/bash
#
# time_calculator.sh
# Copyright (c) 2019 Evandro Coan
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# The time flag file path
updateFlagFilePath="$(pwd)/.time_flag.txt";

# Save the current seconds, only if it is not already saved
if ! [ -f "$updateFlagFilePath" ];
then
    # Create a flag file to avoid override the initial time and save it.
    printf "%s" "$(date +%s.%N)" > "$updateFlagFilePath";

    # printf "$1\\n";
    printf "Current time: %s\\n" "$(date)";
fi;

# Clean the flag file
cleanUpdateFlagFile()
{
    if [ -f "$updateFlagFilePath" ];
    then
        cat "$updateFlagFilePath"
        rm "$updateFlagFilePath";
    fi;
}

# Calculates and prints to the screen the seconds elapsed since this script started.
showTheElapsedSeconds()
{
    # Clean the flag file and read the time
    scriptStartSecond=$(cleanUpdateFlagFile);

    # Calculates whether the seconds program parameter is an integer number
    isFloatNumber "$scriptStartSecond";

    # `$?` captures the return value of the previous function call command
    # Print help when it is not passed a second command line argument integer
    if [ "$?" -eq 1 ];
    then
        scripExecutionTimeResult="$(awk "BEGIN {printf \"%.2f\",$(date +%s.%N)-$scriptStartSecond}")";
        integer_time="$(float_to_integer "$scripExecutionTimeResult")"

        # printf "integer_time '%s'\\n" "${integer_time}"
        # printf "scripExecutionTimeResult '%s'\\n" "${scripExecutionTimeResult}"

        printf "Took '%s' " "$(convert_seconds "$integer_time" "$scripExecutionTimeResult")";
        printf "seconds to run the script, %s.\\n" "$(date +%H:%M:%S)";
    else
        printf "Could not calculate the seconds to run '%s'.\\n" "$1";
    fi;
}

# Convert seconds to hours, minutes, seconds, milliseconds
# https://stackoverflow.com/questions/12199631/convert-seconds-to-hours-minutes-seconds
#
# Awk printf number in width and round it up
# https://unix.stackexchange.com/questions/131073/awk-printf-number-in-width-and-round-it-up
convert_seconds()
{
    printf "%s %s" "$1" "$2" | awk '{printf("%d:%02d:%02d:%02d.%02.0f", ($1/60/60/24), ($1/60/60%24), ($1/60%60), ($1%60), (($2-$1)*100))}';
}

# Bash: Float to Integer
# https://unix.stackexchange.com/questions/89712/bash-float-to-integer
# https://stackoverflow.com/questions/12929848/how-make-float-to-integer-in-awk
float_to_integer()
{
    awk 'BEGIN{for (i=1; i<ARGC;i++) printf "%d", int( ARGV[i] )}' "$@";
}

# Determine whether its first parameter is empty or not.
#
# Returns 1 if empty, otherwise returns 0.
isEmpty()
{
    if [ -z ${1+x} ];
    then
        return 1;
    fi;

    return 0;
}


# Determine whether the first parameter is an integer or not.
#
# Returns 1 if the specified string is an integer, otherwise returns 0.
isInteger()
{
    # Calculates whether the first function parameter $1 is a number
    isEmpty "$1";

    # `$?` captures the return value of the previous function call command
    # Notify an invalid USB port number passed as parameter.
    if ! [ $? -eq 1 ];
    then
        if [ "$1" -eq "$1" ] 2>/dev/null;
        then
            return 1;
        fi;
    fi;

    return 0;
}


# Determine whether the first parameter is an integer or not.
#
# Returns 1 if the specified string is an integer, otherwise returns 0.
isFloatNumber()
{
    # Calculates whether the first function parameter $1 is a number
    isEmpty "$1";

    # `$?` captures the return value of the previous function call command
    # Notify an invalid USB port number passed as parameter.
    if ! [ $? -eq 1 ];
    then
        # Removed the file extension, just in case there exists.
        firstFloatNumberPart=$(printf "%s" "$1" | cut -d'.' -f 1);
        secondFloatNumberPart=$(printf "%s" "$1" | cut -d'.' -f 2);

        # Checks whether the first float number part is an integer.
        isInteger "$firstFloatNumberPart";

        if ! [ $# -eq 1 ];
        then
            return 0;
        fi;

        # Checks whether the second float number part is an integer.
        isInteger "$secondFloatNumberPart";

        if [ $# -eq 1 ];
        then
            return 1;
        fi;
    fi;

    return 0;
}
