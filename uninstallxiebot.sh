function uninstall-bot(){
    echo "🔴 Menghentikan bot dan membersihkan sistem..."

    # Hentikan dan nonaktifkan service xiebot
    systemctl stop xiebot &> /dev/null
    systemctl disable xiebot &> /dev/null
    rm -f /etc/systemd/system/xiebot.service

    # Reload systemd daemon untuk memastikan perubahan diterapkan
    systemctl daemon-reload &> /dev/null

    # Hapus cron job cekbot
    rm -f /etc/cron.d/cekbot

    # Hapus semua file bot di /usr/bin
    rm -rf /usr/bin/xiebot*

    # Hapus skrip cekbot jika ada
    rm -f /usr/bin/cekbot

    # Hapus folder downloads jika ada
    if [ -d "./downloads/" ]; then
        rm -rf ./downloads/
    fi

    # Pastikan semua operasi file selesai sebelum keluar
    sync

    echo "🛑 Bot telah berhasil dihapus dan sistem telah dibersihkan."
}

# Jalankan fungsi uninstall-bot
uninstall-bot
