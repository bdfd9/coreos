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


    # systemctl -q --root "$initdir" add-requires "dropbear-prepare-keys.service" "initrd.target" || exit 1
    # systemctl -q --root "$initdir" add-requires "dropbear-ssh.service" "initrd.target" || exit 1

    # systemctl -q --root "$initdir" add-requires "initrd.target" "dropbear-prepare-keys.service" || exit 1
    # systemctl -q --root "$initdir" add-requires "initrd.target" "dropbear-ssh.service" || exit 1

    # systemctl -q --root "$initdir" add-wants "dropbear-prepare-keys.service" "initrd.target" || exit 1
    # systemctl -q --root "$initdir" add-wants "dropbear-ssh.service" "dropbear-prepare-keys.service" || exit 1

    systemctl -q --root "$initdir" enable dropbear-prepare-keys.service
    systemctl -q --root "$initdir" enable dropbear-ssh.service
}
