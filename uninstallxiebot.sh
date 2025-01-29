function uninstall-bot(){
    # Hentikan dan nonaktifkan service xiebot
    systemctl stop xiebot &> /dev/null
    systemctl disable xiebot &> /dev/null
    rm -f /etc/systemd/system/xiebot.service

    # Hapus cron job cekbot
    rm -f /etc/cron.d/cekbot

    # Hapus file bot yang ada di /usr/bin
    rm -f /usr/bin/xiebot*

    # Hapus skrip cekbot
    rm -f /usr/bin/cekbot

    # Tampilkan pesan selesai
    echo "🛑 Bot telah dihapus dan sistem telah dibersihkan."
}

# Jalankan fungsi uninstall-bot
uninstall-bot
