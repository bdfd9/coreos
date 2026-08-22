#!/bin/bash

check() {
    return 0
}

depends() {
    echo network systemd
}

install() {
    inst dropbear

    inst_simple "$moddir/prepare-dropbear-keys.service" "$systemdsystemunitdir/prepare-dropbear-keys.service"
    inst_simple "$moddir/prepare-dropbear-keys" "/usr/sbin/prepare-dropbear-keys"

    inst_simple "$moddir/dropbear-ssh.service" "$systemdsystemunitdir/dropbear-ssh.service"
    inst_simple "$moddir/dropbear-ssh" "/usr/sbin/dropbear-ssh"


    systemctl -q --root "$initdir" add-requires "prepare-dropbear-keys.service" "initrd.target" || exit 1
    systemctl -q --root "$initdir" add-requires "dropbear-ssh.service" "initrd.target" || exit 1

    systemctl -q --root "$initdir" add-wants "prepare-dropbear-keys.service" "initrd.target" || exit 1
    systemctl -q --root "$initdir" add-wants "dropbear-ssh.service" "prepare-dropbear-keys.service" || exit 1

    # systemctl -q --root "$initdir" enable prepare-dropbear-keys.service
    # systemctl -q --root "$initdir" enable dropbear-ssh.service
}
