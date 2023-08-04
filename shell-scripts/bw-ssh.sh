#!/usr/bin/env bash
set -e

############################################################################################
# 2023-08-02                                                                               #
# Will use Bitwarden CLI to get password and then use it to connect to a host over sshpass #
############################################################################################

function get_info {
  echo "Enter IP for the host you want to connect to: "
  read -r IP
  echo "Enter username: "
  read -r USER
}

function check_dnf {
  if [ "$(dnf list installed | /usr/bin/grep -o 'nodejs-npm')" != "nodejs-npm" ]; then
    sudo dnf install npm -y
  else
    sleep 1s
  fi
   if [ "$(dnf list installed | /usr/bin/grep -o 'sshpass')" != "sshpass" ]; then
    sudo dnf install sshpass -y
  else
    sleep 1s
  fi
  if [ "$(npm ls -g | /usr/bin/grep -o 'bitwarden')" != "bitwarden" ]; then
    sudo npm install -g @bitwarden/cli
  else
    sleep 1s
  fi
}

function check_apt {
  if [ "$(dpkg -l | /usr/bin/grep -o 'snap' | tail -n 1)" != "snap" ]; then
    sudo apt install snapd -y
    sudo snap install bw
  else
    sleep 1s
  fi
  if [ "$(dpkg -l | /usr/bin/grep -o 'sshpass' | tail -n 1)" != "sshpass" ]; then
    sudo apt install sshpass -y
  else
    sleep 1s
  fi
}

function check_brew {
  if [ "$(which brew)" != "/opt/homebrew/bin/brew" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    sleep 1s
  fi
  if [ "$(brew list | /usr/bin/grep -o 'bitwarden-cli')" != "bitwarden-cli" ]; then
    brew install bitwarden-cli
  else
    sleep 1s
  fi
}

## CHECK IF BW IS INSTALLED ##
if [ "$(uname -s)" = "Linux" ] && [ "$(cat /proc/version | /usr/bin/grep -o 'Red Hat')" = "Red Hat" ]; then
  check_dnf
elif [ "$(uname -s)" = "Linux" ] && [ "$(cat /proc/version | /usr/bin/grep -o 'debian' | tail -n 1)" = "debian" ]; then
  check_apt
elif [ "$(uname -s)" = "Darwin" ]; then
  check_brew
else
  echo "Installation failed - try again, but maybe use 'bash -x bw-ssh.sh'"
fi

## RUN THE COMMAND ##
if [ "$(uname -s)" = "Linux" ]; then
  get_info
  sshpass -p "$(bw get password $IP)" ssh "$USER"@"$IP"
elif [ "$(uname -s)" = "Darwin" ]; then
  get_info
  bw get password "$IP" | pbcopy
  echo "Password is copied to clipboard - use cmd+v to insert when prompted for password"
  ssh "$USER"@"$IP"
else
  echo "SSH command failed - try again, but maybe use 'bash -x bw-ssh.sh'"
fi
