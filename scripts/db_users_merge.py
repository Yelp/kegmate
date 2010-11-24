#!/usr/bin/python
#  db_users_merge.py
#  KegMate
#
#  Code to parse through core data sqlite dbs and produce static
#  user fixtures in json of the format:
#
#   [{
#   "tag_id": "29009401239F",
#   "first_name": "John",
#   "last_name": "Boiles",
#   "is_admin": true
#   "pour_count": 1,
#   "volume_poured": 0.320984
#   }]
#
#  Created by John Boiles on 2/6/11.
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.

#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http:#www.gnu.org/licenses/>.
#
import sqlite3 as sqlite

DEBUG = 0

sqlite_files = [
'/Users/johnb/Desktop/Beer/DB Backup/KegPad-3-20101123.sqlite',
'/Users/johnb/Desktop/Beer/DB Backup/KegPad-2-20101123.sqlite',
'/Users/johnb/Desktop/Beer/DB Backup/KegPad-1-20101117.sqlite']

class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

def load_users_from_sqlite(sqlite_file):
    con = sqlite.connect(sqlite_file)
    cur = con.cursor()
    cur.execute('SELECT * FROM ZKBUSER')
    user_rows = cur.fetchall()
    users = []
    user_dict = {}
    for user_row in user_rows:
        primary_key, _, _, pour_count, is_admin, volume_poured, last_name, first_name, tag_id = user_row
        user = {'pour_count': pour_count, 'volume_poured': volume_poured, 'tag_id': tag_id, 'first_name': first_name, 'last_name': last_name, 'is_admin': bool(is_admin)}
        users.append(user)
    return users

def find_users_with_name(users, first_name, last_name):
    """Sorting the list could make this log(n) instead of n"""
    matching_users = []
    for user in users:
        if (user['first_name'] == first_name) and (user['last_name'] == last_name):
            matching_users.append(user)
    return matching_users

def sanity_check_users(users):
    """Verify that every tag_id is unique. I'm not sure, but it may have occured
    that someone left the company and their tag has been reused.
    Verify that users never have volume without a pour."""
    pass

def merge_duplicate_users(users):
    """Merge any obvious duplicates in the users array, return a new array"""
    unique_users = []
    while len(users) > 0:
        # Find users with the same name
        duplicates = find_users_with_name(users, users[0]['first_name'], users[0]['last_name'])
        if DEBUG:
            print "Found %d users with name %s %s" % (len(duplicates), users[0]['first_name'], users[0]['last_name'])
        # Remove duplicates from the users list
        for duplicate in duplicates:
            users.remove(duplicate)

        duplicates_by_tag_id = {}
        tag_ids = []
        has_pours = False

        # Merge obvious duplicates (same name & tag id)
        for duplicate in duplicates:
            tag_id = duplicate['tag_id']
            if (duplicate['pour_count'] > 0):
                has_pours = True
            if tag_id in duplicates_by_tag_id:
                duplicates_by_tag_id[tag_id]['pour_count'] += duplicate['pour_count']
                duplicates_by_tag_id[tag_id]['volume_poured'] += duplicate['volume_poured']
                # If any duplicate is an admin, make the user an admin
                if duplicate['is_admin']:
                    duplicates_by_tag_id[tag_id]['is_admin'] = True
            else:
                tag_ids.append(tag_id)
                duplicates_by_tag_id[tag_id] = duplicate

        # If there is a user with pours, remove any users with no pours
        if has_pours:
            for tag_id in tag_ids:
                if duplicates_by_tag_id[tag_id]['pour_count'] <= 0:
                    if DEBUG:
                        print Colors.FAIL + (" removing %s" % duplicates_by_tag_id[tag_id]) + Colors.ENDC
                    duplicates_by_tag_id.pop(tag_id)
        if DEBUG:
            for _, duplicate in duplicates_by_tag_id.iteritems():
                print Colors.OKGREEN + (" keeping %s" % duplicate) + Colors.ENDC
        unique_users.extend(duplicates_by_tag_id.values())
    return unique_users

def json_dict_for_users(users):
    json_string = "[\n"
    index = 0
    while index < len(users):
        user = users[index]
        json_dict = '{\n"last_name": "%s",\n' % user['last_name']
        json_dict += '"first_name": "%s",\n' % user['first_name']
        json_dict += '"tag_id": "%s",\n' % user['tag_id']
        json_dict += '"is_admin": %s,\n' % str(user['is_admin'])
        json_dict += '"pour_count": %d,\n' % user['pour_count']
        json_dict += '"volume_poured": %f\n}' % user['volume_poured']
        if index < (len(users) - 1):
            json_dict += ','
        json_dict += '\n'
        json_string += json_dict
        index += 1
    json_string += "]\n"
    return json_string

if __name__ == '__main__':
    users = []
    for sqlite_file in sqlite_files:
        users.extend(load_users_from_sqlite(sqlite_file))
    unique_users = merge_duplicate_users(users)
    print json_dict_for_users(unique_users)