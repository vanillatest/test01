#!/bin/bash

#for x in $(find /tmp -maxdepth 2 -mindepth 2 -type f -iname "config" 2>/dev/null); do  PID=$(echo "${x%/*}" | /bin/grep -Eo "\-[0-9]+\-"|tr -d '-');  FP=$(/bin/ps ax | grep -Ev "/bin/grep" | /bin/grep $PID);  [[ -z $FP ]] && rm -rf  $x  ; done


oIFS="$IFS"
IFS=$'\n'
VPIDS=($( /bin/ps ax | /bin/grep -Ev "/bin/grep" | /bin/grep -E " ruby .*/bin/vagrant"))
NOZAP=()
for P in ${VPIDS[@]}; do
    NOZAP+=$(echo $P | awk '{print $1}')
done
IFS="$oIFS"
##echo -e "c:${#NOZAP[@]} \n${NOZAP[@]}"


CONFIGS=($(find /tmp -maxdepth 2 -mindepth 2 -type f -iname "config" 2>/dev/null))
for x in ${CONFIGS[@]}; do
    F="${x%/*}"
    PID=$(echo "$F" | /bin/grep -Eo "\-[0-9]+\-"|tr -d '-')
    ##echo "$PID $F"
    CMD=$(/bin/ps ax | /bin/grep -Ev "/bin/grep" | /bin/grep -E "^ *$PID +.* ruby .*/bin/vagrant .*")
    ##echo $CMD
    [[ -z $CMD ]] && rm -rf "$F"
done


vagrants=($(find /tmp -maxdepth 1 -mindepth 1 -type f -iname "vagrant*-*-*" 2>/dev/null))
for F in ${vagrants[@]}; do
    if [[ ${#NOZAP[@]} == 0 ]]; then
	rm -f "$F"
    else
	PID=$(echo "$F" | /bin/grep -Eo "\-[0-9]+\-" |tr -d '-')
	for (( i=0; i<${#NOZAP[@]}; i++ )); do
	    [[ $PID != ${NOZAP[$i]} ]] && rm -f "$F"
	done
    fi
done

vboxipcs=($(find /tmp -maxdepth 1 -mindepth 1 -type d -iname ".vbox-*-ipc" 2>/dev/null))
for F in ${vboxipcs[@]}; do
    LF=$(find "$F" -maxdepth 1 -mindepth 1 -name "lock" 2>/dev/null)
    if [[ -z $LF ]]; then
	rm -rf $F
    else
	#[[ -n $LF ]] && echo "n $LF"
	PID=$(cat "$LF")
	P=$(/bin/ps ax | /bin/grep -Ev "/bin/grep" | /bin/grep -E "^ *$PID +")
	[[ -z $P ]] && rm -rf "$F"
    fi
done
echo "" > /dev/null
