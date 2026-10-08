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
    pangeia_query apk search "$@"
}

# The manager's own version. `pangeia --version` prints Pangeia's.
pangeia_adapter_version() {
    pangeia_query apk --version
}

pangeia_adapter_list() {
    pangeia_query apk info "$@"
}

pangeia_adapter_info() {
    pangeia_query apk info "$@"
}

pangeia_adapter_clean() {
    pangeia_run apk cache clean
}

# The manager's own help. `pangeia help` prints Pangeia's.
pangeia_adapter_help() {
    pangeia_query apk --help
}
