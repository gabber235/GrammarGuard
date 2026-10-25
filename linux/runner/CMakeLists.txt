cmake_minimum_required(VERSION 3.13)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME}
  "main.cc"
  "global_shortcut.cc"
  "my_application.cc"
  "portal.cc"
  "text_bridge.cc"
  "wayland_selection.cc"
  "wayland_toplevels.cc"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the application ID.
add_definitions(-DAPPLICATION_ID="${APPLICATION_ID}")

# Add dependency libraries. Add any application-specific dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)

# X11 and XTest let the text bridge read the active window and send Ctrl+V.
pkg_check_modules(X11DEPS REQUIRED IMPORTED_TARGET x11 xtst)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::X11DEPS)

# The Wayland protocols the runner speaks are vendored: older
# wayland-protocols releases (Ubuntu 22.04) do not have ext-data-control yet.
pkg_check_modules(WAYLAND REQUIRED IMPORTED_TARGET wayland-client)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::WAYLAND)
find_program(WAYLAND_SCANNER wayland-scanner REQUIRED)
foreach(PROTOCOL ext-data-control-v1 wlr-foreign-toplevel-management-unstable-v1)
  set(XML "${CMAKE_CURRENT_SOURCE_DIR}/protocols/${PROTOCOL}.xml")
  set(HEADER "${CMAKE_CURRENT_BINARY_DIR}/${PROTOCOL}-client-protocol.h")
  set(CODE "${CMAKE_CURRENT_BINARY_DIR}/${PROTOCOL}-protocol.c")
  add_custom_command(
    OUTPUT "${HEADER}" "${CODE}"
    COMMAND "${WAYLAND_SCANNER}" client-header "${XML}" "${HEADER}"
    COMMAND "${WAYLAND_SCANNER}" private-code "${XML}" "${CODE}"
    DEPENDS "${XML}"
  )
  target_sources(${BINARY_NAME} PRIVATE "${HEADER}" "${CODE}")
endforeach()
enable_language(C)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_CURRENT_BINARY_DIR}")

# xkbcommon names the shortcut's key for the GlobalShortcuts portal.
pkg_check_modules(XKBCOMMON REQUIRED IMPORTED_TARGET xkbcommon)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::XKBCOMMON)

target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")
