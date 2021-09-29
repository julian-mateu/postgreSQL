#!/bin/bash
set -e -o pipefail

NC='\033[m' # No Color

main() {
    parse_arguments "${@}"

    docker-compose up -d

    sleep 15

    if [[ "${COMMAND}" == "install" ]]; then
        echo "creating ${NAME} user, and ${NAME}_db and ${NAME}_test_db databases"
        docker-compose exec postgres createuser "${NAME}" -U postgres
        docker-compose exec postgres createdb -O "${NAME}" "${NAME}_db" -U postgres
        docker-compose exec postgres createdb -O "${NAME}" "${NAME}_test_db" -U postgres
        echo -e "run $(fmt_code "createall") on the ${NAME} package to create tables"
        echo -e "run $(fmt_code "docker-compose down") on this directory to teardown the container"
    fi
}

parse_arguments() {
    while getopts "hi:" o; do
        case "${o}" in
        h)
            usage
            exit 0
            ;;
        i)
            COMMAND="install"
            NAME="${OPTARG}"
            ;;
        \? | *)
            usage
            exit 1
            ;;
        esac
    done

    shift $((OPTIND - 1))

    if [[ "${#}" -ne 0 ]]; then
        echo "Illegal number of parameters ${0}: got ${#} but expected exactly 0: ${*}" >&2
        usage
        exit 1
    fi
}

usage() {
    cat <<-EOF >&2
		Usage: ${0##*/} [OPTIONS]

		Runs a postgreSQL DB in a docker container, using the docker-compose.yml file in ${PWD}. It can optionally create default DBs for a system given a name.

		    -i NAME     Create default tables for the service <NAME>
		    -h          display this help and exit
	EOF
}

fmt_code() {
    # shellcheck disable=SC2016 # backtic in single-quote
    printf '`\033[38;5;247m%s%s`\n' "$*" "${NC}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi
