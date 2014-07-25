echo `scutil --get ComputerName`;

hour=`date "+%l:%M %p" | cut -d ':' -f 1`
if [[ $hour -gt 9 ]]; 
then
	date "+%I:%M %p"
else
	date "+%l:%M %p" | cut -d ' ' -f 2-3
fi

date "+%A, %B %d, %Y"

curl http://checkip.dyndns.org | cut -d ':' -f 2 | cut -d '<' -f 1 | cut -d ' ' -f 2

ipconfig getifaddr en0

top -l 1 | awk '/CPU usage/ {print $1 " " $2" " $3" "$4" "$5" "$6" "$7" "$8}' ;
export memTotal=`sysctl -n hw.memsize | awk '{print $0/1048576}'`;
export memUsed=`(top -l 1 | awk '/PhysMem/' | awk '{print $2}';) | cut -d 'M' -f 1  | cut -d 'G' -f 1`;
export memFree=`echo $memTotal - $memUsed | bc`;
export memShortFree=`echo "scale=2;$memFree / 1024" | bc -l`;
export memShortUsed=`echo "scale=2;$memUsed / 1024" | bc -l`;

echo Active memory: $memShortFree GB of RAM" "- "$(( 100* $memFree / $memTotal ))"%;

uptime | awk '{sub(/[0-9]|user,|users,|load/, "", $6);
sub(/mins,|min,/, "min", $6);
sub(/user,|users,/, "", $5); sub(",", "min", $5);
sub(":", "h ", $5); sub(/[0-9]/, "", $4);
sub(/day,/, " day ", $4); sub(/days,/, " days ", $4);
sub(/mins,|min,/, "min", $4); sub("hrs,", "h", $4);
sub(":", "h ", $3);
sub(",", "min", $3);
print "System Uptime: "$3$4$5$6}'

my_ac_adapt=`ioreg -w0 -l | grep ExternalConnected | awk '{print $5}'`
if [ "$my_ac_adapt" == "Yes" ]
then
    echo "Power: External"
else
    cur_power=`ioreg -w0 -l | grep CurrentCapacity | awk '{print $5}'`
    max_power=`ioreg -w0 -l | grep MaxCapacity | awk '{print $5}'`
    bat_percent=`echo "scale=2;$cur_power / $max_power" | bc`
    bat_percent=`echo "$bat_percent * 100" | bc | sed 's/.00//'`
    echo "Power: Battery ($bat_percent%)"
fi

osascript /Users/Ben/Dropbox/Developer/GeekTool/Position.scpt