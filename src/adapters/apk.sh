# shellcheck shell=bash
# Adapter: Alpine Linux and derivatives (apk).

pangeia_adapter_update() {
    pangeia_run apk update
    pangeia_run apk upgrade
}

pangeia_adapter_install() {
    pangeia_run apk add "$@"
}

pangeia_adapter_remove() {
    pangeia_run apk del "$@"
}

pangeia_adapter_search() {
    apk search "$@"
}
