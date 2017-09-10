


# The time flag file path
updateFlagFilePath="/tmp/.time_flag.txt"

# Save the current seconds, only if it is not already saved
if ! [ -f $updateFlagFilePath ]
then
    # Create a flag file to avoid override the initial time and save it.
    echo "$(date +%s.%N)" > $updateFlagFilePath
    echo "Current time: $(date)"
fi

# Calculates and prints to the screen the seconds elapsed since this script started.
showTheElapsedSeconds()
{
    # Clean the flag file and read the time
    scriptStartSecond=$(cleanUpdateFlagFile)

    # Calculates whether the seconds program parameter is an integer number
    isFloatNumber $scriptStartSecond

    # `$?` captures the return value of the previous function call command
    # Print help when it is not passed a second command line argument integer
    if [ $? -eq 1 ]
    then
        scripExecutionTimeResult=$(awk "BEGIN {printf \"%.2f\",$(date +%s.%N)-$scriptStartSecond}")
        printf "Took '$(convert_seconds $(float_to_integer $scripExecutionTimeResult))' "
        printf "seconds to run the script '$1'.\n"
    else
        printf "Could not calculate the seconds to run '$1'.\n"
    fi
}

# Convert seconds to hours, minutes, seconds
# https://stackoverflow.com/questions/12199631/convert-seconds-to-hours-minutes-seconds
convert_seconds()
{
    ((h=${1}/3600))
    ((m=(${1}%3600)/60))
    ((s=${1}%60))

    printf "%02d:%02d:%02d" $h $m $s
}

# Bash: Float to Integer
# https://unix.stackexchange.com/questions/89712/bash-float-to-integer
float_to_integer()
{
    awk 'BEGIN{for (i=1; i<ARGC;i++)
        printf "%.0f\n", ARGV[i]}' "$@"
}

# Clean the flag file
cleanUpdateFlagFile()
{
    if [ -f $updateFlagFilePath ]
    then
        cat $updateFlagFilePath
        rm $updateFlagFilePath
    fi
}

# Determine whether its first parameter is empty or not.
#
# Returns 1 if empty, otherwise returns 0.
isEmpty()
{
    if [ -z ${1+x} ]
    then
        return 1
    fi

    return 0
}


# Determine whether the first parameter is an integer or not.
#
# Returns 1 if the specified string is an integer, otherwise returns 0.
isInteger()
{
    # Calculates whether the first function parameter $1 is a number
    isEmpty $1

    # `$?` captures the return value of the previous function call command
    # Notify an invalid USB port number passed as parameter.
    if ! [ $? -eq 1 ]
    then
        if [ "$1" -eq "$1" ] 2>/dev/null
        then
            return 1
        fi
    fi

    return 0
}


# Determine whether the first parameter is an integer or not.
#
# Returns 1 if the specified string is an integer, otherwise returns 0.
isFloatNumber()
{
    # Calculates whether the first function parameter $1 is a number
    isEmpty $1

    # `$?` captures the return value of the previous function call command
    # Notify an invalid USB port number passed as parameter.
    if ! [ $? -eq 1 ]
    then
        # Removed the file extension, just in case there exists.
        firstFloatNumberPart=$(echo $1 | cut -d'.' -f 1)
        secondFloatNumberPart=$(echo $1 | cut -d'.' -f 2)

        # Checks whether the first float number part is an integer.
        isInteger $firstFloatNumberPart

        if ! [ $# -eq 1 ]
        then
            return 0
        fi

        # Checks whether the second float number part is an integer.
        isInteger $secondFloatNumberPart

        if [ $# -eq 1 ]
        then
            return 1
        fi
    fi

    return 0
}














