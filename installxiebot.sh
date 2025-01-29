function install-bot(){
    # Update dan upgrade sistem
    apt update -y && apt upgrade -y
    apt install python3 python3-pip git speedtest-cli p7zip-full -y
    apt install python3-pip -y

    # Pindah ke direktori /usr/bin dan clear terminal
    cd /usr/bin
    clear

    # Download dan unzip file bot pertama
    wget https://raw.githubusercontent.com/Fuuhou/qpwodjdjdjnsnsksosjdxbxjdkwkwksjdnndnskakwlw/main/xiebot.zip
    echo "Enter the unzip password : "
    read -s password  # Input password dari pengguna
    unzip -P "$password" xiebot.zip -d /tmp/xiebot  # Ekstrak ke direktori sementara

    # Pindahkan isi folder xiebot ke /usr/bin tanpa menyalin folder xiebot itu sendiri
    mv /tmp/xiebot/* /usr/bin/
    
    # Berikan izin eksekusi pada file bot
    chmod +x /usr/bin/*

    # Hapus file ZIP dan folder sementara setelah ekstraksi
    rm -rf xiebot.zip /tmp/xiebot

    # Membuat cron job untuk pengecekan status bot
    echo "SHELL=/bin/sh" > /etc/cron.d/cekbot
    echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >> /etc/cron.d/cekbot
    echo "*/1 * * * * root /usr/bin/cekbot" >> /etc/cron.d/cekbot

    # Membuat script pengecekan status bot
    cat > /usr/bin/cekbot << END
nginx=\$( systemctl status xiebot | grep Active | awk '{print \$3}' | sed 's/(//g' | sed 's/)//g' )
if [[ \$nginx == "running" ]]; then
    echo -ne
else
    systemctl restart xiebot
    systemctl start xiebot
fi

xiebot=\$( systemctl status xiebot | grep "TERM" | wc -l )
if [[ \$xiebot == "0" ]]; then
    echo -ne
else
    systemctl restart xiebot
    systemctl start xiebot
fi
END

    # Membuat systemd service untuk menjalankan bot
    cat > /etc/systemd/system/xiebot.service << END
[Unit]
Description=XieBot - @superxiez
After=syslog.target network-online.target

[Service]
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/python3 -m xiebot
Restart=always

[Install]
WantedBy=multi-user.target
END

    # Reload systemd, enable dan start service xiebot
    systemctl daemon-reload &> /dev/null
    systemctl enable xiebot &> /dev/null
    systemctl start xiebot &> /dev/null
    systemctl restart xiebot &> /dev/null

    echo "🟢 Bot has been installed and is running."
}

# Jalankan fungsi install-bot
install-bot
