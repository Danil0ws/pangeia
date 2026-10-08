# shellcheck shell=bash
# Pangeia - domain: translate a generic package name to a distro name.
#
# Only names that actually differ are listed; anything absent is a 1:1
# mapping. Add a case arm when a package is called something else on a
# given family.

pangeia_package_name() {
    # $1 = manager id, $2 = generic package name
    case "$1:$2" in
        apt:python-pip) echo python3-pip ;;
        dnf:python-pip) echo python3-pip ;;
        pacman:python-pip) echo python-pip ;;
        apk:python-pip) echo py3-pip ;;

        apt:apache) echo apache2 ;;
        dnf:apache) echo httpd ;;
        pacman:apache) echo apache ;;
        apk:apache) echo apache2 ;;
        zypper:apache) echo apache2 ;;

        apt:openssh) echo openssh-server ;;
        dnf:openssh) echo openssh-server ;;
        pacman:openssh) echo openssh ;;
        apk:openssh) echo openssh ;;

        apt:build-tools) echo build-essential ;;
        dnf:build-tools) echo "@development-tools" ;;
        pacman:build-tools) echo base-devel ;;
        apk:build-tools) echo build-base ;;

        *) echo "$2" ;;
    esac
}
