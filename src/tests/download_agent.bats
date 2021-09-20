# Runs prior to every test
setup() {
    # Load our script file.
    source ./src/scripts/download-agent.sh
}

@test '1: Download agent' {
    # Mock environment variables or functions by exporting them (after the script has been sourced)
    export PARAM_DBM_TOOL_PATH="tools/dbmaestro"
    # Capture the output of our "Greet" function
    result=$(Download)
    [ -f "${PARAM_DBM_TOOL_PATH}/DBmaestroAgent.jar" ]
}