vala_xml_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'sidebar.vala',
  'Tab.vala'
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
