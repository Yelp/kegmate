#!/usr/bin/python
#  beer_csv_parser.py
#  KegMate
#
#  Code to parse through the beer data dumps from openbeerdb.
#  THIS IS UNFINISHED
#
#  Created by John Boiles on 10/5/10.
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

import csv
import optparse

def beers_from_csv(filename):
	user_dicts = []
	user_rows = csv.reader(open(filename, 'rb'), delimiter=',', quotechar='"')
	first_row = True
	keys = []
	for beer_row in user_rows:
		if first_row:
			for key in beer_row:
				keys.append(key)
			continue
		for value in beer_row:
			
		user_dict = {}
		print beer_row
		raise Exception()
		#id, obdbid, brewery_id, name, cat_id, style_id, abv, ibu, srm, upc, filepath, descript, last_mod = beer_row
		#print "%s, %s, %s" % (name, abv, descript)

def generate_json_for_beer_dicts(beer_dicts):
	"""Generates a json array of dicts containing tag_id, first_name, and last_name.
	For importing json fixtures into the kegpad db"""
	json = "["
	for user_dict in user_dicts:
		json += "{\n"
		card_string = generate_ascii_representation_from_bcd_value(generate_bcd_value_for_id(user_dict['id'], 100))
		json += "  \"tag_id\": \"%s\", //%d\n" % (card_string, user_dict['id'])
		json += "  \"first_name\": \"%s\",\n" % user_dict['first_name']
		json += "  \"last_name\": \"%s\"\n" % user_dict['last_name']
		json += "}, "
	# Strip off the comma and space for the last element
	json = json[:len(json) - 2]
	json += "]\n"
	return json

if __name__ == '__main__':
	option_parser = optparse.OptionParser()
	(opts, args) = option_parser.parse_args()
	beer_dicts = beers_from_csv(args[0])
	print beers_from_csv()
