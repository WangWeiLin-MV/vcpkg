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


include(CMakePrintHelpers)


#[[
    # Append item to the column table of components.
    #
    # @param {string}       _table_prefix
    # @param {string=}      _column_id
    # @param {string}       _column_compatibility
    # @param {string}       _column_get_virtualenv
    # @param {string}       _column_get_pip
    # @param {string}       _column_precandidate_diff
    # @param {string}       _column_pip
    # @param {string}       _column_setuptools
    # @param {string}       _column_wheel
    #
    # @reset {string[]}     ${arg__table_prefix}_schema_columns
    # @reset {integer}      ${arg__table_prefix}_schema_auto_increment
    # @reset {integer[]}    ${arg__table_prefix}_column_id
    # @reset {string[]}     ${arg__table_prefix}_column_compatibility
    # @reset {string[]}     ${arg__table_prefix}_column_get_virtualenv
    # @reset {string[]}     ${arg__table_prefix}_column_get_pip
    # @reset {string[]}     ${arg__table_prefix}_column_precandidate_diff
    # @reset {string[]}     ${arg__table_prefix}_column_pip
    # @reset {string[]}     ${arg__table_prefix}_column_setuptools
    # @reset {string[]}     ${arg__table_prefix}_column_wheel
]]#
function(z_vcpkg_vgpph_initialize_bootstrap_components_new_record)
    set(_schema_columns
        "_column_id"
        "_column_compatibility"
        "_column_get_virtualenv"
        "_column_get_pip"
        "_column_precandidate_diff"
        "_column_pip"
        "_column_setuptools"
        "_column_wheel"
    )
    set(_opts "")
    set(_sgl "_table_prefix" "${_schema_columns}")
    set(_mlt "")
    cmake_parse_arguments(PARSE_ARGV 0 arg "${_opts}" "${_sgl}" "${_mlt}") # arg_UNPARSED_ARGUMENTS

    if(DEFINED "${arg__table_prefix}_schema_auto_increment")
        set(_schema_auto_increment "${${arg__table_prefix}_schema_auto_increment}")
    else()
        set(_schema_auto_increment 0)
    endif()

    list(LENGTH arg__column_id _list_length)
    if(_list_length EQUAL 0)
        set(arg__column_id "${_schema_auto_increment}")
        math(EXPR _schema_auto_increment "${_schema_auto_increment} + 1")
    elseif(_list_length EQUAL 1)
        if(NOT arg__column_id MATCHES "^(0|[1-9][0-9]*)$")
            message(FATAL_ERROR "Table primary key must be a natrual number, but got `${arg__column_id}`.")
        endif()
        if(arg__column_id GREATER_EQUAL _schema_auto_increment)
            math(EXPR _schema_auto_increment "${arg__column_id} + 1")
        endif()
    endif()

    if(arg__column_id IN_LIST "${arg__table_prefix}_column_id")
        message(FATAL_ERROR "Table primary key duplicate with ${arg__column_id}.")
    endif()

    foreach(_column_name IN LISTS "${arg__table_prefix}_schema_columns")
        set(_column_full_name "${_table_prefix}${_column_name}")
        set(_value "${arg_${_column_name}}")
        list(LENGTH _value _list_length)
        if(_list_length GREATER 1)
            message(FATAL_ERROR "Table does not support entry with list `${_column_name} ${_value}`.")
        elseif(_list_length EQUAL 0)
            set(_value "-")
        endif()
        list(APPEND "${_column_full_name}" "${_value}")
        set("${_column_full_name}" "${${_column_full_name}}" PARENT_SCOPE)
    endforeach()

    set("${arg__table_prefix}_schema_columns" "${_schema_columns}" PARENT_SCOPE)
    set("${arg__table_prefix}_schema_auto_increment" "${_schema_auto_increment}" PARENT_SCOPE)

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
function(z_vcpkg_vgpph_initialize_bootstrap_components_table)
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
        _column_precandidate_diff   ""
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
        _column_precandidate_diff   ""
        _column_pip                 "pip-19.1.1-py2.py3-none-any.whl"
        _column_setuptools          ""
        _column_wheel               ""
    )

    z_vcpkg_vgpph_initialize_bootstrap_components_new_record(
        _table_prefix               z_vcpkg_vgpph_components_schema_prefix
        _column_compatibility       "SameMinorVersion:3.5"
        _column_get_virtualenv      "pypa/get-virtualenv/blob/20.26.2/public/3.5/virtualenv.pyz"
        _column_get_pip             "pypa/get-pip/blob/24.0/public/3.5/get-pip.py"
        _column_precandidate_diff   ""
        _column_pip                 "pip-20.3.4-py2.py3-none-any.whl"
        _column_setuptools          ""
        _column_wheel               ""
    )

    z_vcpkg_vgpph_initialize_bootstrap_components_new_record(
        _table_prefix               z_vcpkg_vgpph_components_schema_prefix
        _column_compatibility       "SameMinorVersion:3.6"
        _column_get_virtualenv      "pypa/get-virtualenv/blob/20.26.2/public/3.6/virtualenv.pyz"
        _column_get_pip             "pypa/get-pip/blob/24.0/public/3.6/get-pip.py"
        _column_precandidate_diff   ""
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
function(z_vcpkg_vgpph_initialize_bootstrap_components_find COMPATIBLE_VERSION)
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

z_vcpkg_vgpph_initialize_bootstrap_components_find(2
    CALLBACK_CODE [[
        message(STATUS "==-==")
        cmake_print_variables(x)
        set(__c )
    ]]
)
