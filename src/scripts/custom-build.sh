#!/bin/bash

CustomBuild(){
    if [ -z "${DBM_TOOL_PATH:=${DBMAESTRO_TOOL_PATH:-'tools/dbmaestro'}}" ]; then echo "DBmaestro tool path is not set"&&exit 1; fi
    if [ -z "${DBM_SERVER_ADDRESS:=$DBMAESTRO_SERVER_ADDRESS}" ]; then echo "DBmaestro server address is not set"&&exit 1; fi
    if [ -z "${DBM_USE_SSL:=${DBMAESTRO_USE_SSL:-n}}" ]; then echo "DBmaestro SSL usage is not set"&&exit 1; fi
    if [ -z "${DBM_AUTH_TYPE:=${DBMAESTRO_AUTH_TYPE:-DBmaestroAccount}}" ]; then echo "DBmaestro auth type is not set"&&exit 1; fi
    if [ -z "${DBM_USERNAME:=$DBMAESTRO_USERNAME}" ]; then echo "DBmaestro username is not set"&&exit 1; fi
    if [ -z "${DBM_PWD:=${!DBM_PASSWORD}}" ]; then echo "DBMAESTRO_PASSWORD variable is not set"&&exit 1; fi
    CMDLINE='java -jar "'$DBM_TOOL_PATH'/DBmaestroAgent.jar" -CustomBuild -SourceProjectName "'$DBM_SOURCE_PROJECT_NAME'" -SourceEnvName "'$DBM_SOURCE_ENVIRONMENT_NAME'" -TargetProjectName "'$DBM_TARGET_PROJECT_NAME'" -TargetEnvName "'$DBM_TARGET_ENVIRONMENT_NAME'" '
    if [[  -n ${DBM_BASELINE_PROJECT_NAME} &&  -n ${DBM_BASELINE_ENVIRONMENT_NAME} ]]; then
        CMDLINE=$CMDLINE'-BaselineProjectName "'$DBM_BASELINE_PROJECT_NAME' -BaselineEnvName "'$DBM_BASELINE_ENVIRONMENT_NAME'" '
    fi
    CMDLINE=$CMDLINE'-SourceVersionType "'$DBM_SOURCE_VERSION_TYPE'" -TargetVersionType "'$DBM_TARGET_VERSION_TYPE'" '
    if [[  -n ${DBM_SOURCE_LABEL_NAME} ]]; then
        CMDLINE=$CMDLINE'-SourceLabelName "'$DBM_SOURCE_LABEL_NAME' "'
    fi
    if [[  -n ${DBM_TARGET_LABEL_NAME} ]]; then
        CMDLINE=$CMDLINE'-TargetLabelName "'$DBM_TARGET_LABEL_NAME' "'
    fi
    CMDLINE=$CMDLINE' -Server "'$DBM_SERVER_ADDRESS'" -AuthType "'$DBM_AUTH_TYPE'" -UserName "'$DBM_USERNAME'" -Password "'$DBM_PWD'"'
    echo "$CMDLINE"
    eval "$CMDLINE"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    CustomBuild
fi