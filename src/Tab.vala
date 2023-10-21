/* sidebar.vala
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


        private string _uuid;
        private Adw.ViewStack _web_container;
        private WebViewApp _web_box;
        private Gtk.ListBox _tab_container;

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

        ~Tab() {
        }

        public Tab (ValaXml.WebViewApp web_box, Adw.ViewStack web_container, Gtk.ListBox tab_container)
        {
            this.uuid = web_box.uuid;
            this.web_box = web_box;
            this.web_container = web_container;
            this.tab_container = tab_container;

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

        [GtkCallback] private void tab_clicked(Gtk.GestureClick gesture, int number, double x, double y)
        {
             web_container.set_visible_child_name(this.uuid);
        }

        [GtkCallback] private void close_tab ()
        {
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
        }

    }
}
