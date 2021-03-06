file(GLOB CODEGEN_COMMON_SOURCES
	${TELEGRAM_SOURCES_DIR}/codegen/common/*.h
	${TELEGRAM_SOURCES_DIR}/codegen/common/*.cpp
)

add_library(codegen_common OBJECT ${CODEGEN_COMMON_SOURCES})
target_include_directories(codegen_common PUBLIC $<TARGET_PROPERTY:Qt5::Core,INTERFACE_INCLUDE_DIRECTORIES>)
target_compile_options(codegen_common PUBLIC $<TARGET_PROPERTY:Qt5::Core,INTERFACE_COMPILE_OPTIONS>)

foreach(TOOL emoji lang numbers style)
	file(GLOB CODEGEN_${TOOL}_SOURCES
		${TELEGRAM_SOURCES_DIR}/codegen/${TOOL}/*.h
		${TELEGRAM_SOURCES_DIR}/codegen/${TOOL}/*.cpp
	)

	add_executable(codegen_${TOOL} ${CODEGEN_${TOOL}_SOURCES} $<TARGET_OBJECTS:codegen_common>)
	target_link_libraries(codegen_${TOOL} Qt5::Core Qt5::Gui)
endforeach()
