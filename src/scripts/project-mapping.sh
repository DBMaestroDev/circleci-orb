#!/bin/bash

ProjectMapping(){
    if [ -z "${DBM_TOOL_PATH:=${DBMAESTRO_TOOL_PATH:-'tools/dbmaestro'}}" ]; then echo "DBmaestro tool path is not set"&&exit 1; fi
    if [ -z "${DBM_SERVER_ADDRESS:=$DBMAESTRO_SERVER_ADDRESS}" ]; then echo "DBmaestro server address is not set"&&exit 1; fi
    if [ -z "${DBM_USE_SSL:=${DBMAESTRO_USE_SSL:-n}}" ]; then echo "DBmaestro SSL usage is not set"&&exit 1; fi
    if [ -z "${DBM_AUTH_TYPE:=${DBMAESTRO_AUTH_TYPE:-DBmaestroAccount}}" ]; then echo "DBmaestro auth type is not set"&&exit 1; fi
    if [ -z "${DBM_USERNAME:=$DBMAESTRO_USERNAME}" ]; then echo "DBmaestro username is not set"&&exit 1; fi
    if [ -z "$DBMAESTRO_PASSWORD" ]; then echo "DBMAESTRO_PASSWORD variable is not set"&&exit 1; fi
    CMDLINE='java -jar "'$DBM_TOOL_PATH'/DBmaestroAgent.jar" -ProjectMapping -ProjectName "'$DBM_PROJECT_NAME'" -TargetProjectName "'$DBM_TARGET_PROJECT_NAME'" '
    if [[  -n ${DBM_SCHEMA_MAP} ]]; then
        CMDLINE=$CMDLINE'-SchemaMap "'$DBM_SCHEMA_MAP'" '
    fi
    if [[  -n ${DBM_TRANSFER_OPENED_PACKAGE} ]]; then
        CMDLINE=$CMDLINE'-TransferOpenedPackage "'$DBM_TRANSFER_OPENED_PACKAGE'" '
    fi
    if [[  -n ${DBM_KEEP_STATE} ]]; then
        CMDLINE=$CMDLINE'-KeepState "'$DBM_KEEP_STATE'" '
    fi
    CMDLINE=$CMDLINE' -Server "'$DBM_SERVER_ADDRESS'" -AuthType "'$DBM_AUTH_TYPE'" -UserName "'$DBM_USERNAME'" -Password "'$DBMAESTRO_PASSWORD'"'
    echo "$CMDLINE"
    eval "$CMDLINE"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    ProjectMapping
fi