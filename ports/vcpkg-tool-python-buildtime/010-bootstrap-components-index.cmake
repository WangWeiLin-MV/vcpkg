#[=======================================================================[.rst:
VcpkgGetPipPrecandidateHelpers
------------------------------

Helper functions for getting the precandidate package in pip install candidate.

.. command:: z_vcpkg_vgpph_initialize_bootstrap_components_find

    Find compatible components::

    z_vcpkg_vgpph_initialize_bootstrap_components_find([version])

.. code-block:: cmake

    set(S "@B@" )

All.
#]=======================================================================]

# SCRIPT_NAMESPACE_PRIFIX z_vcpkg_vgpph_table
include_guard(GLOBAL)


include(CMakePrintHelpers)


function(expect_identifier arg_IDENTIFIER)
    if(NOT ARGN STREQUAL "")
        message(FATAL_ERROR "Unexpected arguments: `${ARGN}`")
    endif()

    if(NOT arg_IDENTIFIER MATCHES "^[a-zA-Z0-9_-]+$")
        message(FATAL_ERROR "Invalid identifier `${arg_IDENTIFIER}`.")
    endif()
endfunction()


function(expect_unused_prefix arg_PREFIX)
    if(NOT ARGN STREQUAL "")
        message(FATAL_ERROR "Unexpected arguments: `${ARGN}`")
    endif()

    expect_identifier("${arg_PREFIX}")

    get_cmake_property(_variableNames VARIABLES)
    foreach(_variableName IN LISTS _variableNames)
        if(_variableName MATCHES "^${arg_PREFIX}")
            message(FATAL_ERROR "Prefix is used by `${_variableName}`.")
        endif()
    endforeach()
endfunction()


expect_unused_prefix("z_vcpkg_vgpph_table")


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


function(get_prefix arg_VAR_PREFIX arg_BASE_NAME)
    if(NOT ARGN STREQUAL "")
        message(FATAL_ERROR "Unexpected arguments: `${ARGN}`")
    endif()

    expect_identifier("${arg_VAR_PREFIX}")
    expect_identifier("${arg_BASE_NAME}")

    set(_namespace_prefix "z_vcpkg_vgpph_table_prefix__${arg_BASE_NAME}")

    set("${arg_VAR_PREFIX}" "${_namespace_prefix}" PARENT_SCOPE)
endfunction()


function(create_table arg_TABLE_NAME)
    set(_ks_opt "")
    set(_ks_sgl "")
    set(_ks_mlt "TABLE_COLUMNS")
    parse_args(1)

    get_prefix(_table_prefix "${arg_TABLE_NAME}")
    expect_unused_prefix("${_table_prefix}")

    foreach(_column_name IN LISTS arg_TABLE_COLUMNS)
        expect_identifier("${_column_name}")
    endforeach()

    set("${_table_prefix}__columns"   "${arg_TABLE_COLUMNS}"  PARENT_SCOPE)
    set("${_table_prefix}__keys"      ""                      PARENT_SCOPE)
endfunction()


function(insert_into arg_TABLE_NAME)
    get_prefix(_table_prefix "${arg_TABLE_NAME}")
    if(NOT DEFINED "${_table_prefix}__columns")
        message(FATAL_ERROR "Table `${arg_TABLE_NAME}` does not exist.")
    endif()

    set(_ks_opt "")
    set(_ks_sgl "RECORD_KEY;${${_table_prefix}__columns}")
    set(_ks_mlt "")
    parse_args(1)

    set(__columns   "${${_table_prefix}__columns}")
    set(__keys      "${${_table_prefix}__keys}")

    expect_identifier("${arg_RECORD_KEY}")
    if("${arg_RECORD_KEY}" IN_LIST __columns)
        message(FATAL_ERROR "RECORD_KEY `${arg_RECORD_KEY}` is duplicated with columns.")
    endif()
    if("${arg_RECORD_KEY}" IN_LIST __keys)
        message(FATAL_ERROR "RECORD_KEY `${arg_RECORD_KEY}` is duplicated with keys.")
    endif()

    foreach(_column_name IN LISTS __columns)
        set("${_table_prefix}__line_${arg_RECORD_KEY}_${_column_name}" "${arg_${_column_name}}" PARENT_SCOPE)
    endforeach()
    list(APPEND __keys "${arg_RECORD_KEY}")
    set("${_table_prefix}__keys" "${__keys}" PARENT_SCOPE)
endfunction()


################################################################################


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


#[[
    # Append item to the table of components.
    #
    # @param {string}       _table_prefix
    # @param {string}       _field_key
    # @param {string}       _field_compatibility
    # @param {string}       _field_get_virtualenv
    # @param {string}       _field_get_pip
    # @param {string}       _field_precandidate_diff
    # @param {string}       _field_pip
    # @param {string}       _field_setuptools
    # @param {string}       _field_wheel
    #
    # @get {integer[]}      ${arg__table_prefix}_schema_keys
    #
    # @set {integer[]}      ${arg__table_prefix}_schema_keys
    # @set {string}         ${arg__table_prefix}_${_field_key}_field_key
    # @set {string}         ${arg__table_prefix}_${_field_key}_field_compatibility
    # @set {string}         ${arg__table_prefix}_${_field_key}_field_get_virtualenv
    # @set {string}         ${arg__table_prefix}_${_field_key}_field_get_pip
    # @set {string}         ${arg__table_prefix}_${_field_key}_field_precandidate_diff
    # @set {string}         ${arg__table_prefix}_${_field_key}_field_pip
    # @set {string}         ${arg__table_prefix}_${_field_key}_field_setuptools
    # @set {string}         ${arg__table_prefix}_${_field_key}_field_wheel
]]#
function(z_vcpkg_vgpph__initialize_bootstrap_components__new_record)
    z_vcpkg_vgpph__initialize_bootstrap_components__schemas(FIELD _schema_fields)

    set(_k_opt)
    set(_k_sgl "_table_prefix" "${_schema_fields}")
    set(_k_mlt)

    cmake_parse_arguments(PARSE_ARGV 0 arg "${_k_opt}" "${_k_sgl}" "${_k_mlt}")
    if(DEFINED arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unexpected arguments: `${arg_UNPARSED_ARGUMENTS}`")
    endif()

    set(_schema_keys "${${arg__table_prefix}_schema_keys}")

    if(NOT arg__field_key)
        message(FATAL_ERROR "Table primary key `_field_key` is required.")
    elseif(NOT arg__field_key MATCHES "^[a-zA-Z0-9_-]+$")
        message(FATAL_ERROR "Table primary key `${arg__field_key}` is invalid.")
    elseif(arg__field_key IN_LIST _schema_keys)
            message(FATAL_ERROR "Table primary key duplicate with `${arg__field_key}`.")
    else()
        list(APPEND _schema_keys "${arg__field_key}")
    endif()

    foreach(_field_name IN LISTS _schema_fields)
        set(_field_full_name "${arg__table_prefix}_${arg__field_key}${_field_name}")
        set("${_field_full_name}" "${arg_${_field_name}}" PARENT_SCOPE)
    endforeach()
    set("${arg__table_prefix}_schema_keys" "${_schema_keys}" PARENT_SCOPE)

endfunction()


#[[
    # Get the column table of components that are required to bootstrap the virtualenv environment.
    # 
    # @return {string}      z_vcpkg_vgpph_components_schema_prefix
    # @return {string[]}    z_vcpkg_vgpph_components_schema_columns
    # @return {integer}     z_vcpkg_vgpph_components_schema_auto_increment
    # @return {integer[]}   z_vcpkg_vgpph_components_column_id
    # @return {string[]}    z_vcpkg_vgpph_components_column_compatibility
    # @return {string[]}    z_vcpkg_vgpph_components_column_get_virtualenv
    # @return {string[]}    z_vcpkg_vgpph_components_column_get_pip
    # @return {string[]}    z_vcpkg_vgpph_components_column_precandidate_diff
    # @return {string[]}    z_vcpkg_vgpph_components_column_pip
    # @return {string[]}    z_vcpkg_vgpph_components_column_setuptools
    # @return {string[]}    z_vcpkg_vgpph_components_column_wheel
]]#
function(z_vcpkg_vgpph__initialize_bootstrap_components__table)
    set(_opts "")
    set(_sgl "")
    set(_mlt "")
    cmake_parse_arguments(PARSE_ARGV 0 arg "${_opts}" "${_sgl}" "${_mlt}") # arg_UNPARSED_ARGUMENTS

    set(z_vcpkg_vgpph_components_schema_prefix "z_vcpkg_vgpph_components")
    set(z_vcpkg_vgpph_components_schema_columns
        "_column_id"
        "_column_compatibility"
        "_column_get_virtualenv"
        "_column_get_pip"
        "_column_precandidate_diff"
        "_column_pip"
        "_column_setuptools"
        "_column_wheel"
    )
    set(z_vcpkg_vgpph_components_schema_auto_increment 0)

    foreach(_column_name IN LISTS z_vcpkg_vgpph_components_schema_columns)
        set("${_column_name}" "")
    endforeach()

    # TODO: new table

    z_vcpkg_vgpph_initialize_bootstrap_components_new_record(
        _table_prefix               z_vcpkg_vgpph_components_schema_prefix
        _column_id                  207
        _column_compatibility       "SameMinorVersion:2.7"
        _column_get_virtualenv      "pypa/get-virtualenv/blob/20.26.2/public/2.7/virtualenv.pyz"
        _column_get_pip             "pypa/get-pip/blob/24.0/public/2.7/get-pip.py"
        _column_precandidate_diff   "py-pip-24.0-precandidate.diff"
        _column_pip                 "pip-20.3.4-py2.py3-none-any.whl"
        _column_setuptools          "setuptools-44.1.1-py2.py3-none-any.whl"
        _column_wheel               "wheel-0.37.1-py2.py3-none-any.whl"
    )

    z_vcpkg_vgpph_initialize_bootstrap_components_new_record(
        _table_prefix               z_vcpkg_vgpph_components_schema_prefix
        _column_id                  304
        _column_compatibility       "SameMinorVersion:3.4"
        _column_get_virtualenv      "pypa/get-virtualenv/blob/20.26.2/public/3.4/virtualenv.pyz"
        _column_get_pip             "pypa/get-pip/blob/24.0/public/3.4/get-pip.py"
        _column_precandidate_diff   "py-pip-24.0-precandidate.diff"
        _column_pip                 "pip-19.1.1-py2.py3-none-any.whl"
        _column_setuptools          ""
        _column_wheel               ""
    )

    z_vcpkg_vgpph_initialize_bootstrap_components_new_record(
        _table_prefix               z_vcpkg_vgpph_components_schema_prefix
        _column_compatibility       "SameMinorVersion:3.5"
        _column_get_virtualenv      "pypa/get-virtualenv/blob/20.26.2/public/3.5/virtualenv.pyz"
        _column_get_pip             "pypa/get-pip/blob/24.0/public/3.5/get-pip.py"
        _column_precandidate_diff   "py-pip-24.0-precandidate.diff"
        _column_pip                 "pip-20.3.4-py2.py3-none-any.whl"
        _column_setuptools          ""
        _column_wheel               ""
    )

    z_vcpkg_vgpph_initialize_bootstrap_components_new_record(
        _table_prefix               z_vcpkg_vgpph_components_schema_prefix
        _column_compatibility       "SameMinorVersion:3.6"
        _column_get_virtualenv      "pypa/get-virtualenv/blob/20.26.2/public/3.6/virtualenv.pyz"
        _column_get_pip             "pypa/get-pip/blob/24.0/public/3.6/get-pip.py"
        _column_precandidate_diff   "py-pip-24.0-precandidate.diff"
        _column_pip                 "pip-21.3.1-py3-none-any.whl"
        _column_setuptools          ""
        _column_wheel               ""
    )

    z_vcpkg_vgpph_initialize_bootstrap_components_new_record(
        _table_prefix               z_vcpkg_vgpph_components_schema_prefix
        _column_id                  307
        _column_compatibility       "AnyNewerVersion:3.7"
        _column_get_virtualenv      "pypa/get-virtualenv/blob/20.26.2/public/virtualenv.pyz"
        _column_get_pip             "pypa/get-pip/blob/24.0/public/get-pip.py"
        _column_precandidate_diff   "py-pip-24.0-precandidate.diff"
        _column_pip                 "pip-24.0-py3-none-any.whl"
        _column_setuptools          ""
        _column_wheel               ""
    )

    # TODO: function to combine intervals
    # Square brackets cannot be used in lists https://discourse.cmake.org/t/1229
    set(z_vcpkg_vgpph_components_compatibility_intervals "{2.7,2.8);{3.4,)")
    set(z_vcpkg_vgpph_components_compatibility_map_intervals "{2.7,2.8);{3.4,3.5);{3.5,3.6);{3.6,3.7);{3.7,)")
    set(z_vcpkg_vgpph_components_compatibility_map_ids "207;304;305;306;307")

    # return
    foreach(_column_name IN LISTS z_vcpkg_vgpph_components_schema_columns)
        set(_column_full_name "${z_vcpkg_vgpph_components_schema_prefix}${_column_name}")
        set("${_column_full_name}" "${${_column_full_name}}" PARENT_SCOPE)
    endforeach()
    return(PROPAGATE
        z_vcpkg_vgpph_components_schema_prefix
        z_vcpkg_vgpph_components_schema_columns
        z_vcpkg_vgpph_components_schema_auto_increment
        z_vcpkg_vgpph_components_compatibility_intervals
        z_vcpkg_vgpph_components_compatibility_map_intervals
        z_vcpkg_vgpph_components_compatibility_map_ids
    )

endfunction()


#[[
    # Get the compatible components for the given version.
    # 
    # @return {string}      z_vcpkg_vgpph_components_schema_prefix
    # @return {string[]}    z_vcpkg_vgpph_components_schema_columns
    # @return {integer}     z_vcpkg_vgpph_components_schema_auto_increment
    # @return {integer}     z_vcpkg_vgpph_compatible_id
    # @return {string}      z_vcpkg_vgpph_compatible_compatibility
    # @return {string}      z_vcpkg_vgpph_compatible_get_virtualenv
    # @return {string}      z_vcpkg_vgpph_compatible_get_pip
    # @return {string}      z_vcpkg_vgpph_compatible_precandidate_diff
    # @return {string}      z_vcpkg_vgpph_compatible_pip
    # @return {string}      z_vcpkg_vgpph_compatible_setuptools
    # @return {string}      z_vcpkg_vgpph_compatible_wheel
]]#
function(z_vcpkg_vgpph__initialize_bootstrap_components__find COMPATIBLE_VERSION)
    set(_opts "")
    set(_sgl "")
    set(_mlt "")
    cmake_parse_arguments(PARSE_ARGV 0 arg "${_opts}" "${_sgl}" "${_mlt}") # arg_UNPARSED_ARGUMENTS

    z_vcpkg_vgpph_initialize_bootstrap_components_table()

    # TODO: function to compare intervals from the compatibility map
    if(2 EQUAL COMPATIBLE_VERSION)
        set(compatible_indices 207)
    elseif(3 EQUAL COMPATIBLE_VERSION)
        set(compatible_indices 307)
    else()
        message(FATAL_ERROR "Invalid version `${COMPATIBLE_VERSION}`, only 2 or 3 are supported for now.")
    endif()

    list(FIND z_vcpkg_vgpph_components_column_id ${compatible_indices} _components_index)

    # cmake_print_variables(arg_CALLBACK_CODE)
    # foreach(x RANGE 0 3)
    #     cmake_language(EVAL CODE ${arg_CALLBACK_CODE})
    # endforeach()

    # # set(debug 1)
    # if(debug)
    #     set(compatible_indices "")
    #     foreach(x IN LISTS z_vcpkg_vgpph_components_column_compatibility)
    #         cmake_print_variables(x)
    #     endforeach()
    #     cmake_print_variables(COMPATIBLE_VERSION)
    #     foreach(_column_name IN LISTS z_vcpkg_vgpph_components_schema_columns)
    #         cmake_print_variables("${z_vcpkg_vgpph_components_schema_prefix}${_column_name}")
    #     endforeach()
    #     cmake_print_variables(z_vcpkg_vgpph_components_schema_prefix)
    #     cmake_print_variables(z_vcpkg_vgpph_components_schema_columns)
    #     cmake_print_variables(z_vcpkg_vgpph_components_schema_auto_increment)
    #     cmake_print_variables(z_vcpkg_vgpph_components_compatibility_intervals)
    #     cmake_print_variables(z_vcpkg_vgpph_components_compatibility_map_intervals)
    #     cmake_print_variables(z_vcpkg_vgpph_components_compatibility_map_ids)
    # endif()

endfunction()

# z_vcpkg_vgpph__initialize_bootstrap_components__find(2
#     CALLBACK_CODE [[
#         message(STATUS "==-==")
#         cmake_print_variables(x)
#         set(__c )
#     ]]
# )
