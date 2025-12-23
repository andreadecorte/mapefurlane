#!/bin/bash -e
# copied from https://install.duckdb.org/
# prevent partial execution if download is partial for some reason
main () {
    OS=$(uname -s)
    ARCH=$(uname -m)

    command -v curl >/dev/null 2>&1 || { echo >&2 "Required tool curl could not be found. Aborting."; exit 1; }
    command -v zcat >/dev/null 2>&1 || { echo >&2 "Required tool zcat could not be found. Hint: install the gzip package. Aborting."; exit 1; }

    #LATEST_VER=$(curl -s https://duckdb.org/data/latest_stable_version.txt)
    LATEST_VER=1.4.3

    # figure out latest version or use the one from the environment
    if [ -z "${DUCKDB_VERSION}" ] 
    then
        VER=$LATEST_VER
    else
        VER="$DUCKDB_VERSION"
    fi
    
    eval PREFIX="~/.duckdb/cli"
    INST="${PREFIX}/${VER}"
    LATEST="${PREFIX}/latest"

    DIST=

    if [ "${OS}" = "Linux" ]
    then
        if [ "${ARCH}" = "x86_64" ] || [ "${ARCH}" = "amd64" ]
        then
            DIST=linux-amd64
        elif [ "${ARCH}" = "aarch64" ] || [ "${ARCH}" = "arm64" ]
        then
            DIST=linux-arm64
        fi
    elif [ "${OS}" = "Darwin" ]
    then
        if [ "${ARCH}" = "x86_64" ]
        then
            DIST=osx-amd64
        elif [ "${ARCH}" = "arm64" ]
        then
            DIST=osx-arm64
        fi
    fi

    if [ -z "${DIST}" ]
    then
        echo "Operating system '${OS}' / architecture '${ARCH}' is unsupported." 1>&2
        exit 1
    fi

    URL="https://install.duckdb.org/v${VER}/duckdb_cli-${DIST}.gz"
    echo
    echo "*** DuckDB Linux/MacOS installation script, version ${VER} ***"
    echo
    echo
    echo "         .;odxdl,            "
    echo "       .xXXXXXXXXKc          "
    echo "       0XXXXXXXXXXXd  cooo:  "
    echo "      ,XXXXXXXXXXXXK  OXXXXd "
    echo "       0XXXXXXXXXXXo  cooo:  "
    echo "       .xXXXXXXXXKc          "
    echo "         .;odxdl,  "
    echo 
    echo

    test_installed_duckdb() {
        "${INST}/duckdb" -noheader -init /dev/null -csv -batch -s "SELECT 2*3*7" 2>/dev/null
    }

    if [ -f "${INST}/duckdb" ] && [ "$(test_installed_duckdb)" = "42" ]; then
        echo "Destination binary ${INST}/duckdb already exists and seems to work"
    else  
        mkdir -p "${INST}"

        if [ ! -d "${INST}" ]; then
            echo "Failed to create install directory ${INST}." 1>&2
            exit 1
        fi

        curl --fail --location --progress-bar "${URL}" > "${INST}/duckdb.gz" || exit 1
        cat "${INST}/duckdb.gz" | zcat > "${INST}/duckdb"
        chmod a+x "${INST}/duckdb"

        if [ ! -f "${INST}/duckdb" ]; then
            echo "Failed to download/unpack binary at ${INST}/duckdb" 1>&2
            exit 1
        fi

        # lets test if this works
        if  [ ! $(test_installed_duckdb) = "42" ]; then
            echo "Failed to execute installed binary :/ ${INST}." 1>&2
            exit 1  
        fi
        echo
        echo "Successfully installed DuckDB ${VER} to ${INST}/duckdb"
    fi

    if [ $VER = $LATEST_VER ] ; then
        # update symlink
         rm -f "${LATEST}" || exit 1
        ln -s "${INST}" "${LATEST}" || exit 1
        echo "Updated symlink from ${LATEST}/duckdb to"
        echo "                     ${INST}/duckdb"

        echo
        echo "Hint: Append the following line to your shell profile:"
        echo "export PATH='${LATEST}':\$PATH"
    else
        echo
        echo "Hint: Append the following line to your shell profile:"
        echo "export PATH='${INST}':\$PATH"
    fi

    # maybe ~/.local/bin exists and is writeable and does not have duckdb yet
    # if so, symlink
    eval LOCALBIN="${HOME}/.local/bin"
    if [ $VER = $LATEST_VER ] && [ -d "${LOCALBIN}" ] && [ -w "${LOCALBIN}" ] && [ ! -f "${LOCALBIN}/duckdb" ]; then
        ln -s "${LATEST}/duckdb" "${LOCALBIN}/duckdb" || exit 1
        echo "Also created a symlink from ${LOCALBIN}/duckdb 
                         to ${LATEST}/duckdb"
    fi

    echo
    echo "To launch DuckDB ${VER} now, type"
    if [ $VER = $LATEST_VER ] ; then
        echo "${LATEST}/duckdb"
    else
        echo "${INST}/duckdb"
    fi


}
main
