#!/usr/bin/env bash
set -e

echo "Grabbing IPs..."
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

function installDependencies() {
  echo "Installing dependencies..."
  sudo apt-get -qq update &>/dev/null
  sudo apt-get -yqq install unzip &>/dev/null
}

function installDocker() {
  echo "Installing Docker..."
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
  sudo apt-get update &>/dev/null
  sudo apt-get install -y docker-engine &>/dev/null
}

function installConsul() {
  echo "Fetching Consul..."
  cd /tmp
  curl -sLo consul.zip https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
  
  echo "Installing Consul..."
  unzip consul.zip >/dev/null
  sudo chmod +x consul
  sudo mv consul /usr/local/bin/consul
  
  # Setup Consul
  sudo mkdir -p /mnt/consul
  sudo mkdir -p /etc/consul.d
  sudo tee /etc/consul.d/config.json > /dev/null <<EOF
  ${consul_config}
EOF
  
  sudo tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
[Unit]
Description=Consul Agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
Environment=CONSUL_ALLOW_PRIVILEGED_PORTS=true
ExecStart=/usr/local/bin/consul agent -config-dir="/etc/consul.d" -dns-port="53" -recursor="172.31.0.2"
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF
}

function installNomad() {
  echo "Fetching Nomad..."
  cd /tmp
  curl -sLo nomad.zip https://releases.hashicorp.com/nomad/${nomad_version}/nomad_${nomad_version}_linux_amd64.zip
  
  echo "Installing Nomad..."
  unzip nomad.zip >/dev/null
  sudo chmod +x nomad
  sudo mv nomad /usr/local/bin/nomad
  
  # Setup Nomad
  sudo mkdir -p /mnt/nomad
  sudo mkdir -p /etc/nomad.d
  sudo tee /etc/nomad.d/config.hcl > /dev/null <<EOF
  ${nomad_config}
EOF
  
  sudo tee /etc/systemd/system/nomad.service > /dev/null <<"EOF"
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/
Wants=network-online.target
After=network-online.target
Wants=consul.service
After=consul.service

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d
KillMode=process
KillSignal=SIGINT
LimitNOFILE=infinity
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
StartLimitBurst=3
StartLimitIntervalSec=10
TasksMax=infinity

[Install]
WantedBy=multi-user.target
EOF
}


# Install software
installDependencies

installConsul ${consul_version}

installNomad ${nomad_version}

if [[  ${nomad_mode} == "client" ]]; then
  installDocker
fi

echo "Starting services..."
# Start services
sudo systemctl daemon-reload
  
# Start Consul
sudo systemctl enable consul.service
sudo systemctl start consul.service

# Start Nomad
sudo systemctl enable nomad.service
sudo systemctl start nomad.service
