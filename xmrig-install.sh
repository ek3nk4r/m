
#!/bin/bash

# Update and install required packages
sudo apt-get update
sudo apt-get install -y git build-essential cmake automake libtool autoconf

# Clone XMRig repository
sudo git clone https://github.com/xmrig/xmrig.git/opt/xmrig

# Build XMRig
cd /opt/xmrig
sudo mkdir build && cd scripts
sudo ./build_deps.sh
cd ../build
sudo cmake .. -DXMRIG_DEPS=scripts/deps
sudo make -j$(nproc)

# Set up systemd service for XMRig
SERVICE_FILE=/etc/systemd/system/xmrig.service

sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=XMRig Crypto Miner
After=network.target

[Service]
ExecStart=/opt/xmrig/build/xmrig -o "151.115.73.241:14444" -u "0xGamerHash:ek3nk4r#Machineek3nk4r" --background --cpu-max-threads-hint="25" --coin monero -a rx/0
Restart=always
User=root
WorkingDirectory=/opt/xmrig/build
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd, enable, and start XMRig service
sudo systemctl daemon-reload
sudo systemctl enable xmrig.service
sudo systemctl start xmrig.service

echo "XMRig setup and startup configuration complete."
