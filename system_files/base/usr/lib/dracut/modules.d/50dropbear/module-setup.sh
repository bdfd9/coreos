#!/bin/bash

check() {
    return 0
}

depends() {
    echo network systemd
}

install() {
    inst dropbear
    inst dropbearkey

    inst_simple "$moddir/dropbear-prepare-keys.service" "$systemdsystemunitdir/dropbear-prepare-keys.service"
    inst_simple "$moddir/dropbear-prepare-keys" "/usr/bin/dropbear-prepare-keys"

    inst_simple "$moddir/dropbear-ssh.service" "$systemdsystemunitdir/dropbear-ssh.service"
    inst_simple "$moddir/dropbear-ssh" "/usr/bin/dropbear-ssh"

    systemctl -q --root "$initdir" enable dropbear-prepare-keys.service
    systemctl -q --root "$initdir" enable dropbear-ssh.service

    # Add the command to unlock LUKS volumes to the bash history for easier access.
    echo systemd-tty-ask-password-agent >> "$initdir/root/.bash_history"
    chmod 600 "$initdir/root/.bash_history"

    inst_simple "${moddir}/motd" /etc/motd
    inst_simple "${moddir}/profile" "$initdir/root/.profile"
}
