#!/usr/bin/env bash

bootstrap_clone() {
    set -eu
    local BRANCH=${BRANCH:-master}
    echo "Cloning $@"
    local URL=$1
    shift
    local CLONE_DIR=$1
    shift
    CWD=$(pwd)
    rm -rf ${CLONE_DIR}
    git clone -b ${BRANCH} --single-branch --depth=1 --recurse-submodules --shallow-submodules ${URL} ${CLONE_DIR}
    code=$?
    cd ${CWD}
    return "$?"
}

# Print the OS platform this machine should bootstrap as: omarchy, linux, or darwin.
bootstrap_platform() {
    case "$(uname -s)" in
        Darwin*)
            echo darwin
            return
            ;;
        Linux*)
            ;;
        *)
            echo unknown
            return
            ;;
    esac
    if [[ -r /etc/os-release ]]; then
        local os_id
        os_id="$(
            # shellcheck disable=SC1091
            . /etc/os-release
            printf '%s %s' "${ID:-}" "${ID_LIKE:-}"
        )"
        case "${os_id}" in
            *omarchy*)
                echo omarchy
                return
                ;;
        esac
    fi
    echo linux
}

# Debian package names used by setup scripts, translated to Arch names.
# An empty result means the package has no Omarchy equivalent and should be skipped.
bootstrap_omarchy_package() {
    case "$1" in
        apt-transport-https) ;;
        build-essential) echo base-devel ;;
        guile-3.0) echo guile ;;
        gh) echo github-cli ;;
        pkg-config) echo pkgconf ;;
        python3) echo python ;;
        uidmap) echo shadow ;;
        libfreetype6-dev) echo freetype2 ;;
        libfontconfig1-dev) echo fontconfig ;;
        libxcb-xfixes0-dev) echo libxcb ;;
        libxkbcommon-dev) echo libxkbcommon ;;
        docker-ce|docker-ce-cli) echo docker ;;
        containerd.io) echo containerd ;;
        docker-buildx-plugin) echo docker-buildx ;;
        docker-compose-plugin) echo docker-compose ;;
        *) echo "$1" ;;
    esac
}

bootstrap_install() {
    set -eu
    local PLATFORM
    PLATFORM="$(bootstrap_platform)"
    case ${PLATFORM} in
        linux)
            local RETRIES=3
            local BACKOFF=1
            local packages=""
            for package in $@; do
                packages="${package} ${packages}"
            done
            if sudo -v; then
                local IN_CONTAINER=${IN_CONTAINER:-0}
                if command -v aptdcon; then
                    echo 'y' | sudo aptdcon \
                        --hide-terminal \
                        --install \
                        "${packages}"
                else
                    sudo apt-get \
                        -qy \
                        install \
                        ${packages}
                fi
            fi
            ;;
        omarchy)
            local pkg mapped_pkg mapped=""
            for pkg in "$@"; do
                mapped_pkg="$(bootstrap_omarchy_package "${pkg}")"
                if [[ -z "${mapped_pkg}" ]]; then
                    continue
                fi
                case " ${mapped} " in
                    *" ${mapped_pkg} "*) ;;
                    *) mapped="${mapped} ${mapped_pkg}" ;;
                esac
            done
            if [[ -z "${mapped// /}" ]]; then
                return 0
            fi
            # Package names are single words.
            omarchy pkg add ${mapped}
            ;;
        darwin)
					  if ! HOMEBREW_NO_AUTO_UPDATE= brew install $@; then
						    HOMEBREW_NO_AUTO_UPDATE= brew reinstall $@
						fi
            ;;
        *)          echo "UNKNOWN:${PLATFORM}"; exit 1;;
    esac
    return
}

log_common() {
    set -eu
	local LEVEL=$1
	shift
	local PREFIX=$1
	shift
	echo "${LEVEL}:${PREFIX}:$@"
    return
}

info_common() {
    set -eu
	log_common INFO $@
    return
}

# Work hosts have "jorson" in the hostname (e.g. dev-jorson0, work Mac).
is_work_host() {
    [[ $(hostname) == *jorson* ]]
}
