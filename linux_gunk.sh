########################################
# Bluetooth
########################################

# look up keys in windows registry
cd /mnt/c/Windows/System32/config
sudo chntpw -e SYSTEM
cd ControlSet001\Services\BTHPORT\Parameters\Keys\1002b509f591
hex 88d039a3e0eb
# then echo "KEY" | tr -d " "
# copy result to /var/lib/bluetooth/controller_mac/device_mac/info

# set headphone profile to audio sink???
pactl list cards short
pacmd set-card-profile 8 a2dp_sink

# fix stuttering, set bluetooth latency to e.g 15000 microsec
pactl set-port-latency-offset bluez_card.<MAC_ADDRESS> headset-output 15000

########################################
# Docker
########################################

# list volumes and mount points of containers
docker ps -a --format '{{ .ID }}' | xargs -I {} docker inspect -f '{{ .Name }}{{ printf "\n" }}{{ range .Mounts }}{{ printf "\n\t" }}{{ .Type }} {{ if eq .Type "bind" }}{{ .Source }}{{ end }}{{ .Name }} => {{ .Destination }}{{ end }}{{ printf "\n" }}' {}

########################################
# General
########################################

# list actual disk usage of files
du -sh *
btrfs fi df -h /

# power usage
awk '{print $1*10^-6 " W"}' /sys/class/power_supply/BAT0/power_now
upower --dump
watch awk "'{print \$1*10^-6 \" W\"}' /sys/class/power_supply/BAT0/power_now"

# kill x session
Ctrl + Alt + Backspace

# get heat data
cat /sys/class/thermal/thermal_zone*/temp

# ascii movie
nc towel.blinkenlights.nl 23

########################################
# Log
########################################

#kernel log
dmesg

# running systemlog (follow)
journalctl -f

# systemlog since date
journalctl --since "2020-01-01 00:00:00"

########################################
# Network
########################################

# scan
sudo nmap -A -v -sC -sV -sS -n <IP>

# turn off ipv6
# these do not work...
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
# adding boot loader kernel param does:
ipv6.disable=1


# wifi hotspot (does not work for 5GHz ...)
nmcli dev wifi hotspot band bg channel 1 ifname wlp2s0 ssid test password "12345678"

# arp ping
arping <host>

# list open TCP sockets
lsof -iTCP -sTCP:LISTEN

# reverse lookup
dig -x ADDR

# open ssh tunnel for a local port to a port of the remote host
ssh -NL <localport>:<host>:<foreignport> -i <idrsa> <host>
ssh -NL 8080:localhost:8888 -i $IDRSA ubuntu@$UBIP

########################################
# Packages
########################################

# import key
sudo rpm --import <key>

# check signature
sudo rpm --checksig -v <rpm package>

# list files of a package
sudo rpm -ql <package>

# get packages dependent on <package>, -i: only installed
zypper se --requires <package>

# list imported keys
rpm -qi gpg-pubkey-\* | grep -E ^Packager
rpm -qi gpg-pubkey-\*
rpm -q gpg-pubkey  --qf "%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n"

# delete unneeded dependencies
zypper pa --unneeded

# delete package with cleaning deps
zypper rm --clean-deps <package>
