#!/bin/bash

# Update the system
sudo yum update -y

# Download Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-amd64.tar.gz

# Extract the downloaded tarball
tar -xvf prometheus-2.24.0.linux-amd64.tar.gz

# Rename the extracted directory
mv prometheus-2.24.0.linux-amd64 prometheus-files

# Create a system user for Prometheus
sudo useradd --no-create-home --shell /bin/false prometheus

# Create necessary directories
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Change ownership of the directories to the prometheus user
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Copy Prometheus binaries to /usr/local/bin/
sudo cp prometheus-files/prometheus /usr/local/bin/
sudo cp prometheus-files/promtool /usr/local/bin/

# Change ownership of the binaries to the prometheus user
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Copy console libraries and templates to the configuration directory
sudo cp -r prometheus-files/consoles /etc/prometheus
sudo cp -r prometheus-files/console_libraries /etc/prometheus

# Change ownership of console files
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

# Create Prometheus configuration file
cat <<EOL | sudo tee /etc/prometheus/prometheus.yml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]
EOL

# Create systemd service file for Prometheus
cat <<EOL | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd daemon to recognize the new service file
sudo systemctl daemon-reload

# Start Prometheus service
sudo systemctl start prometheus

# Enable Prometheus to start on boot
sudo systemctl enable prometheus

# Check the status of Prometheus service
sudo systemctl status prometheus
