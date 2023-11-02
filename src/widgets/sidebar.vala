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
    [GtkTemplate(ui = "/valaxlm/pedromigueldev/github/ui/sidebar.ui")]
    public class SideBar : Adw.NavigationPage {

        public static GLib.HashTable<string, string> fav_list = new GLib.HashTable<string, string>(null,null);
        private static GLib.Settings settings = new GLib.Settings ("valaxlm.pedromigueldev.github");

        [GtkChild] private unowned Gtk.ListBox tab_container;
        [GtkChild] public unowned Gtk.ToggleButton show_sidebar_button;
        [GtkChild] public unowned ValaXml.Search search_bar;

        private bool _sidebar_active;
        public bool sidebar_active {
            get { return _sidebar_active; }
            set {
                _sidebar_active = value;
            }
        }

        protected delegate void CreateWebView (string uuid, string url);
        public static void load_favorites (CreateWebView create_web_view) {
            var list = settings.get_strv ("favorites");

            foreach (string tab in list) {
                string[] tab_split = tab.split ("!::", 10);
                fav_list.set (tab_split[0], tab_split[1]);
            }

            fav_list.foreach ((uuid, url) => {
                create_web_view (uuid, url);
                stdout.printf ("key: %s ; val: %s \n",uuid, url);
            });

        }
        public static void save_favorites () {
            string[] to_save = {};

            if(fav_list.length <= 0) {
                settings.set_strv ("favorites", to_save);
                print("nothing to print");
                return;
            }

            print("----------fav----------\n");
            fav_list.foreach ((uuid, url) => {
                to_save += uuid + "!::" + url;
            });

            foreach (string tab in to_save) {
                stdout.printf ("%s\n", tab);
            }

            settings.set_strv ("favorites", to_save);
            return;
        }
        public static void add_favorite(string r_uuid, string r_url) {
            bool exists = false;

            fav_list.find ((uuid, url) => {
                if (uuid == r_uuid) {
                    print("something\n");
                    exists = true;
                    return true;
                }
                return false;
            });

            if( !exists )
                fav_list.set (r_uuid, r_url);

            save_favorites ();
        }

        public static void remove_favorite(string r_uuid) {
            fav_list.foreach_remove ((uuid, url) => {
                if (uuid == r_uuid)
                    return true;
                return false;
            });
            save_favorites ();
        }

        public void add_web_view(string uri, Adw.ViewStack web_container, bool is_favorite = false, string uuid = "") {
            ValaXml.WebViewApp web_box = new ValaXml.WebViewApp();
            ValaXml.Tab tab = new ValaXml.Tab (this, web_box, web_container, tab_container);

            if(is_favorite) {
                tab.is_favorite = true;
                tab.uuid = uuid;
                web_box.uuid = uuid;
                tab_container.insert (tab, 1);
                web_container.add_named (web_box, uuid);
            } else {
                web_container.add_named (web_box, web_box.uuid);
                tab_container.append (tab);
            }

            web_box.web_view.load_uri(uri);
            tab.set_web_visible();

            tab_container.get_last_child().focus(Gtk.DirectionType.TAB_FORWARD);
        }

        public SideBar () {
        }

        construct {
            ValaXml.Tab fav_button = new ValaXml.Tab.control_button (this.tab_container, _("Favorites"), "starred-symbolic");
            ValaXml.Tab add_button = new ValaXml.Tab.control_button_with_action (this.tab_container, _("New Tab"), "list-add-symbolic", "win.add_tab");

            tab_container.append (fav_button);
            tab_container.append (add_button);

        }

    }
}


