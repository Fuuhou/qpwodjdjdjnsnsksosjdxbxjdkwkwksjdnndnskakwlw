#!/bin/bash

function install-bot() {
    echo "🔵 Memulai instalasi XieBot..."

    # Update dan upgrade sistem
    apt update -y && apt upgrade -y
    apt install python3 python3-pip git speedtest-cli p7zip-full -y

    # Hentikan proses bot jika sedang berjalan
    systemctl stop xiebot 2>/dev/null
    pkill -f xiebot 2>/dev/null

    # Hapus folder lama jika ada
    if [ -d "/usr/bin/xiebot" ]; then
        echo "🔴 Folder lama /usr/bin/xiebot ditemukan. Menghapusnya..."
        rm -rf /usr/bin/xiebot
    fi

    # Download file ZIP bot
    echo "📥 Mengunduh file bot..."
    wget -q --show-progress https://raw.githubusercontent.com/Fuuhou/qpwodjdjdjnsnsksosjdxbxjdkwkwksjdnndnskakwlw/main/xiebot.zip

    # Maksimum percobaan password
    max_attempts=3
    attempts=0

    while [ $attempts -lt $max_attempts ]; do
        echo "🔑 Masukkan password untuk unzip: "
        read -s password

        # Coba ekstrak file ZIP dengan 7z
        if 7z x -p"$password" xiebot.zip -o/tmp/xiebot/ -y &>/dev/null; then
            echo "✅ Password benar! Mengekstrak file..."
            break
        else
            echo "❌ Password salah, coba lagi."
            attempts=$((attempts+1))
        fi

        # Jika gagal 3 kali, batalkan instalasi
        if [ $attempts -ge $max_attempts ]; then
            echo "🚨 Terlalu banyak percobaan. Instalasi dibatalkan!"
            rm -rf xiebot.zip /tmp/xiebot
            exit 1
        fi
    done

    # Pindahkan isi folder xiebot ke /usr/bin/
    mv /tmp/xiebot/* /usr/bin/

    # Buat direktori downloads jika belum ada
    mkdir -p /usr/bin/downloads/

    # Install dependensi bot
    pip3 install -r /usr/bin/xiebot/requirements.txt

    # Berikan izin eksekusi pada file bot
    chmod +x /usr/bin/xiebot/*

    # Hapus file ZIP dan folder sementara
    rm -rf xiebot.zip /tmp/xiebot

    # Membuat systemd service untuk bot
    cat > /etc/systemd/system/xiebot.service << EOF
[Unit]
Description=XieBot - @superxiez
After=syslog.target network-online.target

[Service]
WorkingDirectory=/usr/bin/xiebot
ExecStart=/usr/bin/python3 -m xiebot
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd, enable, dan start service xiebot
    systemctl daemon-reload
    systemctl enable xiebot
    systemctl start xiebot

    echo "🟢 Instalasi selesai! XieBot telah berjalan."
}

# Jalankan fungsi install-bot
install-bot
