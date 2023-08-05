# Force Wayland for Mozilla Firefox
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1

# Force Wayland for Qt apps
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME=qt5ct

# Force Wayland for EFL (Enlightenment) apps
export ECORE_EVAS_ENGINE="wayland-egl"
export ELM_ACCEL="gl"

# Java XWayland blank screens fix
export _JAVA_AWT_WM_NONREPARENTING=1
