#!/usr/bin/env bash

set -Eeup pipefail  ### set is used for debbuging bash-scripts

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
LVM=$(lsblk | grep "lvm" | wc -l)
LVM_string=$(if [ $LVM -eq 0 ]; then echo NO; else echo YEEESSSIR; fi)

#### Color output
YELLOW="\033[0;93m"
CYAN="\033[0;96m"
RESET="\033[0m"

printf "\n${YELLOW}#################################################################################################${RESET}\n\n"

# - The architecture of your operating system and its kernel version.
printf "Machine architecture && kernel version:${CYAN}   $(uname -srvm) ${RESET}\n"
# - The number of physical processors.
printf "Number of physical proc: ${CYAN}    $(cat /proc/cpuinfo | grep "physical id" | wc -l) ${RESET}\n" # sot | uniq
# - The number of virtual processors.
printf "Number of virtual proc: ${CYAN}    $(grep "^processor" /proc/cpuinfo | wc -l)${RESET}\n"
# - The current available RAM on your server and its utilization rate as a percentage.
printf "Current available RAM, megabytes: ${CYAN}   $(free --mega | awk '$1 == "Mem:" {print $4}')${RESET}\n"
printf "RAM utilization rate, percentage: ${CYAN}   $(free | awk '$1 == "Mem:" {print $3/$2*100}')${RESET}\n"
# - The current available memory on your server and its utilization rate as a percentage.
printf "Current available MEM, G:${CYAN}    $(df -Bg | grep "^/dev" | grep -v "/boot" | awk '{available += $4} END {print available}')${RESET}\n"
printf "Mem utilization rate, percentage:${CYAN}   $(df -Bm | grep "^/dev" | grep -v "/boot" | awk '{availeble += $4} {used += $3} END {print used/(availeble+used)*100}') ${RESET}\n"
# - The current utilization rate of your processors as a percentage.
printf "Utilization of CPU, percentage:${CYAN}    $(top -bn1 | grep "^%Cpu" | awk '{printf("%.1f"), $2 + $4}')${RESET}\n"
# - The date and time of the last reboot.
printf "Data-time of the last reboot: ${CYAN}    $(who -b | awk '{print $3 " " $4}')${RESET}\n"
# - Whether LVM is active or not.
printf "LVM:${CYAN}       $LVM_string ${RESET}\n"
# - The number of active connections.
printf "Active TCP connections:${CYAN}     $(cat /proc/net/tcp | tail -n +2 | wc -l) ${RESET}\n"
# - The number of users using the server.
printf "Current number of users:${CYAN}    $(users | wc -w)${RESET}\n"
# - The IPv4 address of your server and its MAC (Media Access Control) address.
printf "IPv4 && MAC:${CYAN}      $(hostname -I) $(ip link | grep "link/ether" | awk '{print $2}')${RESET}\n"
# - The number of commands executed with the sudo program.
printf "Number of commands executed with the sudo:${CYAN}  $(journalctl -q _COMM=sudo | grep COMMAND | wc -l)${RESET}\n"
# - Prints script location
printf "Script directory is:${CYAN}     $script_dir ${RESET}\n"

printf "\n${YELLOW}###############################################################################################${RESET}\n\n"
