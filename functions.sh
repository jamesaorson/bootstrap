#! /bin/bash

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

bootstrap_install() {
    set -eu
    local RETRIES=3
    local BACKOFF=1
    local PLATFORM="$(uname -s)"
    local packages=""
    for package in $@; do
        packages="${package} ${packages}"
    done
    case ${PLATFORM} in
        Linux*)
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
        Darwin*)
            if ! command -v; then
                if ! HOMEBREW_NO_AUTO_UPDATE= brew install $@; then
                    HOMEBREW_NO_AUTO_UPDATE= brew reinstall $@
                fi
            fi
            ;;
        *)          echo "UNKNOWN:${unameOut}"; exit 1;;
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
