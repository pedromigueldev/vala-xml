namespace ValaXml
{
    public class WebViewApp : Gtk.Box {
        public WebKit.WebView web_view = new WebKit.WebView();
        private static WebKit.WebView _focused_webview;
        public string uuid = GLib.Uuid.string_random();

        public static WebKit.WebView focused_webview {
            get { return _focused_webview;}
            set {
                _focused_webview = value;
            }
        }
        public Gtk.ScrolledWindow content_view = new Gtk.ScrolledWindow() {
            hexpand = true,
            vexpand = true,
            overflow = Gtk.Overflow.HIDDEN,
            css_classes = { "rounded_wv", "card" }
        };

        public WebViewApp() {
            vexpand = true;
            hexpand = true;

            content_view.set_child(web_view);
            this.append(content_view);

            WebViewApp.focused_webview = this.web_view;
        }

        public static void refresh () {
            WebViewApp._focused_webview.reload ();
        }
        public static bool go_back () {
            if( !WebViewApp._focused_webview.can_go_back () ) return false;
            WebViewApp._focused_webview.go_back ();
            return true;
        }
        public static bool go_forward () {
            if( !WebViewApp._focused_webview.can_go_forward ()) return false;
            WebViewApp._focused_webview.go_forward ();
            return true;
        }
        public static string uri () {
            return WebViewApp._focused_webview.uri;
        }
    }
}
