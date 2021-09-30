#!/bin/bash

GetEnvPackages(){
    if [ -z "${DBM_TOOL_PATH:=${DBMAESTRO_TOOL_PATH:-'tools/dbmaestro'}}" ]; then echo "DBmaestro tool path is not set"&&exit 1; fi
    if [ -z "${DBM_SERVER_ADDRESS:=$DBMAESTRO_SERVER_ADDRESS}" ]; then echo "DBmaestro server address is not set"&&exit 1; fi
    if [ -z "${DBM_USE_SSL:=${DBMAESTRO_USE_SSL:-n}}" ]; then echo "DBmaestro SSL usage is not set"&&exit 1; fi
    if [ -z "${DBM_AUTH_TYPE:=${DBMAESTRO_AUTH_TYPE:-DBmaestroAccount}}" ]; then echo "DBmaestro auth type is not set"&&exit 1; fi
    if [ -z "${DBM_USERNAME:=$DBMAESTRO_USERNAME}" ]; then echo "DBmaestro username is not set"&&exit 1; fi
    if [ -z "${DBM_PWD:=${!DBM_PASSWORD}}" ]; then echo "DBMAESTRO_PASSWORD variable is not set"&&exit 1; fi
    CMDLINE='java -jar "'$DBM_TOOL_PATH'/DBmaestroAgent.jar" -GetEnvPackages -ProjectName "'$DBM_PROJECT_NAME'" -EnvName "'$DBM_ENVIRONMENT_NAME'"'
    if [[  -n ${DBM_FROM_DATE} ]]; then
        CMDLINE=$CMDLINE' -FromDate "'$DBM_FROM_DATE' "'
    fi
    if [[  -n ${DBM_TO_DATE} ]]; then
        CMDLINE=$CMDLINE'-ToDate "'$DBM_TO_DATE' "'
    fi
    if [[  -n ${DBM_DATE_FORMAT} ]]; then
        CMDLINE=$CMDLINE'-DateFormat "'$DBM_DATE_FORMAT' "'
    fi
    if [[  -n ${DBM_FILE_PATH} ]]; then
        CMDLINE=$CMDLINE'-FilePath "'$DBM_FILE_PATH' "'
    fi
    CMDLINE=$CMDLINE' -Server "'$DBM_SERVER_ADDRESS'" -AuthType "'$DBM_AUTH_TYPE'" -UserName "'$DBM_USERNAME'" -Password "'$DBM_PWD'"'
    eval "$CMDLINE"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    GetEnvPackages
fi