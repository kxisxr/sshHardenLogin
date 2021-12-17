#!/bin/bash -i
#Author: kxisxr
greenColour="\x1B[0;32m\033[1m"
endColour="\033[0m\x1B[0m"
redColour="\x1B[0;31m\033[1m"
blueColour="\x1B[0;34m\033[1m"
yellowColour="\x1B[0;33m\033[1m"
purpleColour="\x1B[0;35m\033[1m"
turquoiseColour="\x1B[0;36m\033[1m"
grayColour="\x1B[0;37m\033[1m"

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo -e -n "${redColour}"'Not running as root \nExiting...'"${endColour}"
    exit
fi

echo -e "${greenColour}"'Checking for sponge...'"${endColour}\n"

if ! command -v sponge &> /dev/null
then
echo -e "${greenColour}"'Installing utilities...'"${endColour}"
sudo apt install moreutils -y > /dev/null 2>&1
echo -e ' '
fi

source ~/.bashrc
sleep 1
echo -e "${greenColour}"'1.- Enable password login.'"${endColour}"
echo -e "${redColour}"'2.- Disable password login.\n'"${endColour}"

echo -e -n "${yellowColour}"'Select an option: '"${endColour}"
read -e value

if [ $value == '1' ]
then
sed 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config | sponge /etc/ssh/sshd_config

sed 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config | sponge /etc/ssh/sshd_config

sed 's/UsePAM no/UsePAM yes/g' /etc/ssh/sshd_config | sponge /etc/ssh/sshd_config

sed 's/PermitRootLogin no/#PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config | sponge /etc/ssh/sshd_config

echo -e ' '
sleep 0.5
echo -e "${turquoiseColour}"'Reloading /etc/init.d/ssh service.\n'"${endColour}"
/etc/init.d/ssh reload > /dev/null 2>&1
sleep 0.5
echo -e ' '

else

sed 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config | sponge /etc/ssh/sshd_config

sed 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config | sponge /etc/ssh/sshd_config

sed 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config | sponge /etc/ssh/sshd_config

sed 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config | sponge /etc/ssh/sshd_config

echo -e ' '
sleep 0.5
echo -e "${turquoiseColour}"'Reloading /etc/init.d/ssh service.\n'"${endColour}"
/etc/init.d/ssh reload > /dev/null 2>&1
sleep 0.5
echo -e ' '

fi
