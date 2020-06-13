#!/bin/bash

log() {
    echo `date '+%Y/%m/%d %H:%M:%S'`" - ${1}"
}

#
#   catch all signals that come from outside the container
#   to be able to exit gracefully
#
trapper() {
    "$@" &
    pid="$!"
    log "Running the entrypoint script with PID ${pid}"
    trap "log 'Stopping entrypoint script with $pid'; kill -SIGTERM $pid" SIGINT SIGTERM

    while kill -0 $pid > /dev/null 2>&1; do
        wait
    done
}

trapper /opt/project-hop/load-and-execute.sh $@
