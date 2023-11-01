#Установка и запуск Промисиуса и Графаны

sudo apt install prometheus -y
sudo systemctl start prometheus
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/oss/release/grafana_9.2.4_amd64.deb && sudo dpkg -i grafana_9.2.4_amd64.deb
sudo systemctl enable grafana-server && sudo systemctl start grafana-server