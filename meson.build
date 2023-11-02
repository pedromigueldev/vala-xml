project('vala-xml', ['c', 'vala'],
          version: '0.1.0',
    meson_version: '>= 0.62.0',
  default_options: [ 'warning_level=2', 'werror=false', ],
)

i18n = import('i18n')
gnome = import('gnome')

config_data = configuration_data()
config_data.set('GETTEXT_PACKAGE', meson.project_name())
config_data.set('LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
config_data.set_quoted('PROJECT_NAME', meson.project_name())
config_data.set_quoted('VERSION', meson.project_version())
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())

add_global_arguments(
	'-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
	'-DLOCALEDIR="@0@"'.format(get_option('localedir')),
	language:'c'
)


subdir('data')
subdir('src')
subdir('po')

gnome.post_install(
     glib_compile_schemas: true,
    gtk_update_icon_cache: true,
  update_desktop_database: true,
)
