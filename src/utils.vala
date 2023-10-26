/* utils.vala
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
    public class Utils {
        public Utils() {}

        public static bool verify_url (string URL) {

            string Pattern = "[(http(s)?):\\/\\/(www\\.)?a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)";
            Regex Rgx;
            bool is_valid;

            try {
                Rgx = new Regex(Pattern);
                is_valid = Rgx.match (URL, 0);

            } catch (Error e) {
                print("\n" + e.message);
                is_valid = false;
            }

            print(is_valid ? "VALID: " + URL + "\n" : "NOT VALID: " + URL + "\n");
            return is_valid;
        }

    }
}

