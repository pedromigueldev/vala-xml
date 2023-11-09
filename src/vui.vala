namespace vui
{
    private class Box : Gtk.Box{
            Box () {}

            public Box.horizontal (int spacing = 0) {
                this.set_orientation (Gtk.Orientation.HORIZONTAL);
                this.set_spacing (spacing);
            }
            public Box.vertical (int spacing = 0) {
                this.set_orientation (Gtk.Orientation.VERTICAL);
                this.set_spacing (spacing);
            }

            public Box children (Gtk.Widget[] widgets) {
                foreach (var item in widgets)
                    this.append (item);
                return this;
            }
    }

    private class Button : Gtk.Button {
        private Gtk.Box button_internal_box;

        Button () {}

        public Button.horizontal (int spacing = 0) {
            button_internal_box = new vui.Box.horizontal (spacing);
        }
        public Button.vertical (int spacing = 0) {
            button_internal_box = new vui.Box.horizontal (spacing);
        }
        public Button children (Gtk.Widget[] widgets) {
            foreach (var item in widgets)
                    button_internal_box.append (item);

            this.child = button_internal_box;

            return this;
        }
    }

}
