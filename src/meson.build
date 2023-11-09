vala_xml_sources = [
	'widgets/main.vala',
	'widgets/application.vala',
	'widgets/window.vala',
	'widgets/sidebar.vala',
	'widgets/tab.vala',
	'widgets/dialog.vala',
	'widgets/search.vala',
	'widgets/webview.vala',
  	'utils.vala',
  	'vui.vala',
  	configure_file(
		input: 'widgets/config.vala.in',
		output: '@BASENAME@',
		configuration: config_data
	),
]

vala_xml_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('webkitgtk-6.0', required: true)
]

vala_xml_sources += gnome.compile_resources('vala-xml-resources',
  'vala-xml.gresource.xml',
  c_name: 'vala_xml'
)

executable('vala-xml', vala_xml_sources,
  dependencies: vala_xml_deps,
       install: true,
)
