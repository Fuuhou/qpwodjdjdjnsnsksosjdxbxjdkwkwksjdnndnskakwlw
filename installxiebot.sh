#!/bin/bash

function install-bot() {
    echo "Memulai instalasi XieBot..."

    # Update dan upgrade sistem
    apt update -y && apt upgrade -y
    apt install python3 python3-pip git p7zip-full -y
    sleep 2

    # Download file ZIP bot
    echo "Mengunduh file bot..."
    wget -q --show-progress https://raw.githubusercontent.com/Fuuhou/qpwodjdjdjnsnsksosjdxbxjdkwkwksjdnndnskakwlw/main/xiebot.zip
    sleep 2

    # Maksimum percobaan password
    max_attempts=3
    attempts=0

    while [ $attempts -lt $max_attempts ]; do
        echo "Masukkan password untuk unzip: "
        read -s password

        # Ekstrak file ZIP dengan 7z
        if 7z x -p"$password" xiebot.zip -o/tmp/xiebot/ -y &>/dev/null; then
            echo "Password benar! Mengekstrak file..."
            break
        else
            echo "Password salah, coba lagi."
            attempts=$((attempts+1))
        fi

        # Jika gagal 3 kali, batalkan instalasi
        if [ $attempts -ge $max_attempts ]; then
            echo "Terlalu banyak percobaan. Instalasi dibatalkan!"
            rm -rf xiebot.zip /tmp/xiebot
            exit 1
        fi
    done

    mv /tmp/xiebot/* /root/

    # Buat direktori downloads jika belum ada
    mkdir -p /root/downloads/
    sleep 2

    pip3 install -r /root/xiebot/requirements.txt
    if [ $? -ne 0 ]; then
        echo "Gagal menginstal dependensi."
        exit 1
    fi

    # Hapus file ZIP dan folder sementara
    rm -rf xiebot.zip /tmp/xiebot

    # Membuat systemd service untuk bot
    cat > /etc/systemd/system/xiebot.service << EOF
[Unit]
Description=XieBot - @superxiez
After=syslog.target network-online.target

[Service]
WorkingDirectory=/root/xiebot
ExecStart=/usr/bin/python3 -m /root/xiebot
Restart=always
User=root
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd, enable, dan start service xiebot
    systemctl daemon-reload
    if [ $? -ne 0 ]; then
        echo "Gagal reload systemd."
        exit 1
    fi
    sleep 2

    systemctl enable xiebot
    systemctl start xiebot
systemctl status xiebot
    echo "Instalasi selesai! XieBot telah berjalan."
}

# Jalankan fungsi install-bot
install-bot
