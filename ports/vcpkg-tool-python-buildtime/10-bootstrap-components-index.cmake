# SCRIPT_NAMESPACE_PRIFIX z_vcpkg_vgpph_table
include_guard(GLOBAL)


include(CMakePrintHelpers)


function(expect_identifier arg_STRING)
    if(NOT ARGN STREQUAL "")
        message(FATAL_ERROR "Unexpected arguments: `${ARGN}`")
    endif()

    if(NOT arg_STRING MATCHES "^[a-zA-Z0-9_-]+$")
        message(FATAL_ERROR "Invalid identifier `${arg_STRING}`.")
    endif()
endfunction()

function(expect_natural arg_STRING)
    if(NOT ARGN STREQUAL "")
        message(FATAL_ERROR "Unexpected arguments: `${ARGN}`")
    endif()

    if(NOT arg_STRING MATCHES "^[1-9][0-9]*$")
        message(FATAL_ERROR "Invalid natural number `${arg_STRING}`.")
    endif()
endfunction()


########


function(handle_create_command)
    # handle_append_command(${ARGN})
    message(STATUS "=======handle_create_command")
    message("ARGC: ${ARGC}")
    message("ARGN: ${ARGN}")
    message("ARGV0: ${ARGV0}")
    message("ARGV1: ${ARGV1}")
    message("ARGV2: ${ARGV2}")
    message("ARGV3: ${ARGV3}")
    message("ARGV4: ${ARGV4}")
    message("ARGV5: ${ARGV5}")
    get_cmake_property(_variableNames VARIABLES)
    cmake_print_variables(_variableNames)
endfunction()

function(handle_append_command)
    message(STATUS "handle_append_command")
    message("ARGC: ${ARGC}")
    message("ARGN: ${ARGN}")
    message("ARGV0: ${ARGV0}")
    message("ARGV1: ${ARGV1}")
    message("ARGV2: ${ARGV2}")
    message("ARGV3: ${ARGV3}")
    message("ARGV4: ${ARGV4}")
    message("ARGV5: ${ARGV5}")
    get_cmake_property(_variableNames VARIABLES)
    cmake_print_variables(_variableNames)
endfunction()

function(handle_indices_command)
    message(STATUS "handle_indices_command")
endfunction()

function(handle_columns_command)
    message(STATUS "handle_columns_command")
endfunction()

function(handle_get_command)
    message(STATUS "handle_get_command")
endfunction()


macro(parse_args N)
    cmake_parse_arguments(PARSE_ARGV "${N}" arg "${_ks_opt}" "${_ks_sgl}" "${_ks_mlt}")
    block()
        if(DEFINED arg_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "Unexpected arguments: `${arg_UNPARSED_ARGUMENTS}`")
        endif()
        foreach(_k_sgl IN LISTS _ks_sgl)
            list(LENGTH "arg_${_k_sgl}" _length)
            if(_length GREATER 1)
                message(FATAL_ERROR "Single value param `${_k_sgl}` does not allow `${arg_${_k_sgl}}`.")
            endif()
        endforeach()
    endblock()
endmacro()


function(get_eval_call_with_argn_as_is arg_CODE_VAR)
    set(_ks_opt "")
    set(_ks_sgl "COMMAND_VAR;START;COUNT")
    set(_ks_mlt "TABLE_COLUMNS")
    parse_args(1)

    expect_natural("${arg_START}")
    expect_natural("${arg_COUNT}")

    set(_eval_code "")

    string(APPEND _eval_code "cmake_language(CALL \"\${${arg_COMMAND_VAR}}\"")

    if(arg_COUNT GREATER arg_START)
        math(EXPR _index_stop "${arg_COUNT} - 1")
        foreach(_iterator RANGE ${arg_START} ${_index_stop})
            string(APPEND _eval_code " \"\${ARGV${_iterator}}\"")
        endforeach()
    endif()

    string(APPEND _eval_code ")")

    cmake_print_variables(_eval_code)

    set("${arg_CODE_VAR}" "${_eval_code}" PARENT_SCOPE)
endfunction()


function(table arg_SUBCOMMAND)

    block(PROPAGATE _handle_command _eval_code)
        set(_subcommand_list "CREATE" "APPEND" "INDICES" "COLUMNS" "GET")
        foreach(_subcommand_upper IN LISTS _subcommand_list)
            string(TOLOWER "${_subcommand_upper}" _subcommand_lower)
            set(_handle_command "handle_${_subcommand_lower}_command")
            if(NOT COMMAND ${_handle_command})
                message(FATAL_ERROR "Missing handle command: `${_handle_command}`")
            endif()
        endforeach()

        if(NOT arg_SUBCOMMAND IN_LIST _subcommand_list)
            message(FATAL_ERROR "Unknown sub-command: `${arg_SUBCOMMAND}`")
        endif()

        string(TOLOWER "${arg_SUBCOMMAND}" _subcommand_name)

        set(_handle_command "handle_${_subcommand_name}_command")

        get_eval_call_with_argn_as_is(_eval_code
            COMMAND_VAR _handle_command
            START       1
            COUNT       ${ARGC}
        )
    endblock()

    cmake_language(EVAL CODE "${_eval_code}")


    message(STATUS "=======table")
    message("ARGC: ${ARGC}")
    message("ARGN: ${ARGN}")
    message("ARGV0: ${ARGV0}")
    message("ARGV1: ${ARGV1}")
    message("ARGV2: ${ARGV2}")
    message("ARGV3: ${ARGV3}")
    message("ARGV4: ${ARGV4}")
    message("ARGV5: ${ARGV5}")
    get_cmake_property(_variableNames VARIABLES)
    cmake_print_variables(_variableNames)
endfunction()

# table()
table(CREATE "b1;b2" "c1\;c2" "d1 d2" e)
return()

table(CREATE "hio"
    COLUMNS
        _field_compatibility
        _field_get_virtualenv
        _field_get_pip
        _field_precandidate_diff
        _field_pip
        _field_setuptools
        _field_wheel
)

return()

table(APPEND "hio"
    RECORD_INDEX "a"
    RECORD_ENTRIES
        _field_compatibility        "a-"
        _field_get_virtualenv       "a-"
        _field_get_pip              "a-"
        _field_precandidate_diff    "a-"
        _field_pip                  "a-"
        _field_setuptools           "a-"
        _field_wheel                "a-"
)

table(INDICES "hio"                 _table_indices)
table(COLUMNS "hio"                 _table_columns)
table(GET "hio" "a"                 _record_list)
table(GET "hio" "a" "_field_wheel"  _record_list)
