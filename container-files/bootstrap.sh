#!/bin/bash
set -eu
#### "Magic starts Here" - H. Potter #####
check_install_status () {
    if [[ ! -e /workdir/mkdocs ]]; then
        mkdir -p /workdir/mkdocs
    fi
    cd /workdir/mkdocs
    if [[ ! -e "mkdocs.yml" ]]; then
    echo "No previous config. Starting fresh instalation"
    mkdocs new .
    fi
}
#### "Magic starts Here" - H. Potter #####
install_plugins () {
    if [[ ! -z ${PLUGIN_LIST} ]]; then

        for plugin in  $(echo $PLUGIN_LIST | sed "s/,/ /g"); do
          pip install ${plugin}
        done
    fi
}
start_mkdocs () {
    if [[ ${LIVE_RELOAD_SUPPORT} == 'true' ]]; then
        LRS='--no-livereload'
    else
        LRS=''
    fi
    cd /workdir/mkdocs
    echo "Starting MKDocs"
    mkdocs serve -a $(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1):8000 $LRS
}

get_docs () {
    if [[ ! -e /workdir/mkdocs ]]; then
        echo "Downloading documentation from Git Repository"
        git clone ${GIT_REPO} /workdir/mkdocs
    fi
}

if [ ${GIT_REPO} != 'false' ]; then
    get_docs
else
    install_plugins
    check_install_status
fi

cmd=${1-empty}
if [ "$cmd" = 'empty' ]; then
      start_mkdocs
fi

exec "$@"

