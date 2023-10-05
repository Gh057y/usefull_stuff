#!/bin/bash


function fn_ip_address() {

    # Loop through the interfaces and check for the interface that is up.
    for file in /sys/class/net/*; do

        iface=$(basename $file);

        read status < $file/operstate;

        [ "$status" == "up" ] && ip addr show $iface | awk '/inet /{printf $2" "}'

    done

}

function fn_cpuinfo() {

                printf "%s " "$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')"

}

function fn_memory_usage() {

    if [ "$(which bc)" ]; then

        # Display used, total, and percentage of memory using the free command.
        read used total <<< $(free -m | awk '/Mem/{printf $2" "$3}')
        # Calculate the percentage of memory used with bc.
        percent=$(bc -l <<< "100 * $total / $used")
        # Feed the variables into awk and print the values with formating.
        awk -v u=$used -v t=$total -v p=$percent 'BEGIN {printf "%sMi/%sMi %.1f% ", t, u, p}'

    fi

}

function fn_load_average() {

    printf "%s " "$(uptime | awk -F: '{printf $NF}' | tr -d ',')"

}

function fn_uptime() {

                printf "%s " "$(uptime | cut -f 4-5 -d ' ' | cut -f 1 -d ',')"

}

function main() {

    fn_ip_address
                fn_cpuinfo
    fn_memory_usage
                fn_load_average
                fn_uptime

}

main
