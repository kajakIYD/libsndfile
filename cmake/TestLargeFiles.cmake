include (CheckIncludeFile)
include (CheckTypeSize)
include (CMakePushCheckState)

macro (TEST_LARGE_FILES VARIABLE)

if (NOT DEFINED ${VARIABLE})

	cmake_push_check_state()

	message (STATUS "")
	message (STATUS "")
	message (STATUS "Checking large files support...")

	message (STATUS "")
	check_include_file(sys/types.h HAVE_SYS_TYPES_H)
	check_include_file(stdint.h HAVE_STDINT_H)
	check_include_file(stddef.h HAVE_STDDEF_H)
	message (STATUS "")

	message (STATUS "Checking size of off_t without any definitions:")
	check_type_size (off_t SIZEOF_OFF_T)
	message (STATUS "Checking of off_t without any definitions: ${SIZEOF_OFF_T}")
	if (SIZEOF_OFF_T EQUAL 8)
		set (LARGE_FILES_DEFINITIONS "" CACHE INTERNAL "64-bit off_t required definitions")
		set (FILE64 TRUE)
	else ()
		unset (HAVE_SIZEOF_OFF_T CACHE)
		unset (SIZEOF_OFF_T CACHE)
		unset (SIZEOF_OFF_T_CODE CACHE)
		cmake_pop_check_state()
		set (FILE64 FALSE)
	endif ()

	if (NOT FILE64)
		set (CMAKE_REQUIRED_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS} /D_FILE_OFFSET_BITS=64)
		message (STATUS "")
		message (STATUS "Checking size of off_t with _FILE_OFFSET_BITS=64:")
		check_type_size (off_t SIZEOF_OFF_T)
		message (STATUS "Checking size of off_t with _FILE_OFFSET_BITS=64: ${SIZEOF_OFF_T}")
		if (SIZEOF_OFF_T EQUAL 8)
			set (_FILE_OFFSET_BITS 64 CACHE INTERNAL "")
			set (_FILE_OFFSET_BITS_CODE "#define _FILE_OFFSET_BITS 64" CACHE INTERNAL "")
			set (LARGE_FILES_DEFINITIONS ${LARGE_FILES_DEFINITIONS} "/D_FILE_OFFSET_BITS=64" CACHE INTERNAL "64-bit off_t required definitions")
			set (FILE64 TRUE)
		else ()
			set (_FILE_OFFSET_BITS_CODE "" CACHE INTERNAL "")
			unset (HAVE_SIZEOF_OFF_T CACHE)
			unset (SIZEOF_OFF_T CACHE)
			unset (SIZEOF_OFF_T_CODE CACHE)
			cmake_pop_check_state()
			set (FILE64 FALSE)
		endif ()
	endif ()

	if (NOT FILE64)
		set (CMAKE_REQUIRED_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS} /D_LARGE_FILES)
		message (STATUS "")
		message (STATUS "Checking size of off_t with _LARGE_FILES:")
		check_type_size (off_t SIZEOF_OFF_T)
		message (STATUS "Checking size of off_t with _LARGE_FILES: ${SIZEOF_OFF_T}")
		if (SIZEOF_OFF_T EQUAL 8)
			set (_LARGE_FILES 1 CACHE INTERNAL "")
			set (LARGE_FILES_DEFINITIONS ${LARGE_FILES_DEFINITIONS} "/D_LARGE_FILES" CACHE INTERNAL "64-bit off_t required definitions")
			set (FILE64 TRUE)
		else ()
			unset (HAVE_SIZEOF_OFF_T CACHE)
			unset (SIZEOF_OFF_T CACHE)
			unset (SIZEOF_OFF_T_CODE CACHE)
			cmake_pop_check_state()
			set (FILE64 FALSE)
		endif ()
	endif ()

	if (NOT FILE64)
		set (CMAKE_REQUIRED_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS} /D_LARGEFILE_SOURCE)
		unset (HAVE_SIZEOF_OFF_T CACHE)
		unset (SIZEOF_OFF_T CACHE)
		unset (SIZEOF_OFF_T_CODE CACHE)
		message (STATUS "")
		message (STATUS "Checking size of off_t with _LARGEFILE_SOURCE:")
		check_type_size (off_t SIZEOF_OFF_T)
		message (STATUS "Checking size of off_t with _LARGEFILE_SOURCE: ${SIZEOF_OFF_T}")
		if (SIZEOF_OFF_T EQUAL 8)
			set (_LARGEFILE_SOURCE 1 CACHE INTERNAL "")
			set (LARGE_FILES_DEFINITIONS ${LARGE_FILES_DEFINITIONS} "/D_LARGEFILE_SOURCE"  CACHE INTERNAL "64-bit off_t required definitions")
			set (FILE64 TRUE)
		else ()
			cmake_pop_check_state()
			set (FILE64 FALSE)
		endif ()
	endif ()

	message (STATUS "")
	if (FILE64)
		set (${VARIABLE} 1 CACHE INTERNAL "Result of tests for large file support" FORCE)
		if (NOT SIZEOF_OFF_T_REQURED_DEFINITIONS)
			message (STATUS "Result of checking large files support: supported")
		else ()
			message (STATUS "Result of checking large files support: supported with ${LARGE_FILES_DEFINITIONS}")
			message (STATUS "Add LARGE_FILES_DEFINITIONS to your compiler definitions or configure with _FILE_OFFSET_BITS,")
			message (STATUS "_FILE_OFFSET_BITS_CODE, _LARGE_FILES and _LARGEFILE_SOURCE variables.")
		endif ()
	else ()
		message ("Result of checking large files support: not supported")
		set (${VARIABLE} 0 CACHE INTERNAL "Result of test for large file support" FORCE)
	endif ()
	message ("")
	message ("")

endif (NOT DEFINED ${VARIABLE})

endmacro (TEST_LARGE_FILES VARIABLE)
