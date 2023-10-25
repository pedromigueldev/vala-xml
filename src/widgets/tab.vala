/* tab.vala
 *
 * Copyright 2023 Pedro Miguel
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace ValaXml {
    [GtkTemplate(ui = "/valaxlm/pedromigueldev/github/ui/tab_button.ui")]
    public class Tab : Gtk.ListBoxRow {

        [GtkChild]  private unowned Gtk.Image tab_image_icon;
        [GtkChild]  private unowned Gtk.Label tab_label;

        [GtkCallback] private void tab_clicked () { this.set_web_visible (); }
        [GtkCallback] private void tab_focused () { this.set_web_visible (); }

        [GtkCallback] private Gdk.ContentProvider on_drag_prepare() {
            tab_container.select_row (this);
            this.set_sensitive (false);
            return new Gdk.ContentProvider.for_value (this);
        }
        [GtkCallback] private void on_drag_end () {
            this.set_sensitive (true);
        }
        [GtkCallback] private void on_drag_begin (Gdk.Drag drag)   {
            Gtk.DragIcon icon = (Gtk.DragIcon) Gtk.DragIcon.get_for_drag (drag);

            //omg im so happy that i finally figured it out how to drag and drop this f** thing 😭️😭️😭️
            var button_tab = new Gtk.Button() {
                margin_start = 10,
                margin_end = 10,
                child = new Gtk.Label(this.tab_label.label) {
                    halign = Gtk.Align.START,
                    valign = Gtk.Align.FILL,
                    ellipsize = Pango.EllipsizeMode.END
                }
            };

            icon.set_child(button_tab);
        }

       [GtkCallback] public bool on_task_top_drop(Gtk.DropTarget target, GLib.Value data, double x, double y) {
            var tab = (ValaXml.Tab) data;

            if (tab.parent == this.parent) {
                tab_container.remove (tab);
                tab_container.insert (tab, this.get_index ());
            }
            return false;
        }


        [GtkCallback] private void close_tab () {
            ValaXml.WebViewApp box = (ValaXml.WebViewApp) web_container.get_child_by_name (uuid);
            Gtk.ListBoxRow tab = (Gtk.ListBoxRow) tab_container.get_focus_child ();

            ValaXml.WebViewApp next_visible = (bool) box.get_next_sibling () ?
                (ValaXml.WebViewApp) box.get_next_sibling () : (ValaXml.WebViewApp) box.get_prev_sibling ();

            Gtk.ListBoxRow next_visible_tab = (bool) tab.get_next_sibling () ?
                (Gtk.ListBoxRow) tab.get_next_sibling () : (Gtk.ListBoxRow) tab.get_prev_sibling ();

            if (box.is_visible () && (bool) next_visible && (bool) next_visible_tab) {
                web_container.set_visible_child (next_visible);
                tab_container.set_focus_child (next_visible_tab);
            }

            web_container.remove (box);
            tab_container.remove (this);
            sidebar.search_bar.entry.set_text ("");
        }


        private string _uuid;
        private Adw.ViewStack _web_container;
        private WebViewApp _web_box;
        private Gtk.ListBox _tab_container;
        private ValaXml.SideBar _sidebar;

        public string uuid
        {
            get { return _uuid; }
            set {
                _uuid = value;
            }
        }

        public Adw.ViewStack web_container
        {
            get { return _web_container; }
            set {
                _web_container = value;
            }
        }

        public WebViewApp web_box
        {
            get { return _web_box; }
            set {
                _web_box = value;
            }
        }

        public Gtk.ListBox tab_container
        {
            get { return _tab_container; }
            set {
                _tab_container = value;
            }
        }

        public ValaXml.SideBar sidebar
        {
            get { return _sidebar; }
            set {
                _sidebar = value;
            }
        }

        public Tab (SideBar sidebar, ValaXml.WebViewApp web_box, Adw.ViewStack web_container, Gtk.ListBox tab_container)
        {
            this.uuid = web_box.uuid;
            this.web_box = web_box;
            this.web_container = web_container;
            this.tab_container = tab_container;
            this.sidebar = sidebar;

            web_box.web_view.load_changed.connect(e => {
                switch (e) {
                    case WebKit.LoadEvent.STARTED:

                        break;
                    case WebKit.LoadEvent.COMMITTED:
                        tab_image_icon.icon_name = "process-working-symbolic";
                        tab_label.set_label("carregando...");
                        break;
                    case WebKit.LoadEvent.FINISHED:
                        tab_image_icon.icon_name = "selection-mode-symbolic";
                        tab_label.set_label(web_box.web_view.title);

                        break;
                    default:
                        break;
                };
            });

        }

        public void set_web_visible ()
        {


            sidebar.search_bar.active_url = this.web_box.web_view.uri;

            ValaXml.WebViewApp.focused_webview = this.web_box.web_view;
            web_container.set_visible_child_name(this.uuid);

        }

    }
}

