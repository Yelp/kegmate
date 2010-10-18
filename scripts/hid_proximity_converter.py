#!/usr/bin/python
#  hid_proximity_converter.py
#  KegMate
#
#  Code to decode the clock+data output from a HID Proximity reader to
#  an integer ID and vice versa. This code assumes the reader gives us
#  data in this format
#
#  For our HID cards (and probably others) data is encoded as wiegand26
#  1 bit parity - 8 bit facility code - 16 bit card id - 1 bit parity
#
#  Using a clock+data-emulating reader, we're sent groups of 5 bits including
#  3 data bits, 1 parity bit, and one extra bit (for compatibility with
#  magnetic stripe systems). We check and strip the parity bit in firmware,
#  and send the card ID as an ascii string (for flexibility in card formats).
#  That leaves us with a string containing ascii chars that represent 0-7.
#  Functions included in this file allow us to convert that ascii string
#  to binary values that represent the facility code and card id as is
#  typical of wiegand26 readers.
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
import math
import optparse

def parity_bit(int_type, odd=False):
	"""Calculate the parity bit of a given integer"""
	if odd:
		parity = 1
	else:
		parity = 0
	while (int_type):
		parity ^= 1
		int_type = int_type & (int_type - 1)
	return(parity)

def string_from_binary(s, length=0):
	"""Create a string representing binary. For debugging purposes"""
	string = str(s) if s<=1 else string_from_binary(s>>1) + str(s&1)
	# Prepend leading zeros
	while(len(string) < length):
		string = '0' + string;
	return string

def generate_bcd_value_for_id(card_id, facility_code, card_id_length=16, facility_code_length=8):
	"""Creates a bitstring of the binary coded decimal value from a HID
	Proximity card ID. This converts the card ID as printed on the back of
	the card to a value like that which is passed out from a 
	clock+data-emulating HID reader"""
	card_bits = card_id
	card_bits |= (facility_code << card_id_length)
	# Add the odd parity bit in the lsb for the lowest 13 bits
	end_parity_bit = parity_bit(card_bits & 0xFFF, odd=True)
	# Even parity bit in the msb for the highest 13 bits
	start_parity_bit = parity_bit(card_bits & 0xFFF000)
	# Make space for the trailing parity bit, set bits
	card_bits <<= 1
	card_bits |= end_parity_bit
	card_bits |= (start_parity_bit << 25)
	# I'm not sure what this bit is, but it always seems to be one. The HID
	# docs I've found about decoding this information says ignore all bits > 25
	card_bits |= (1 << 26)
	# Figure out how many groups of 3 bits we should expect
	group_count = int(math.ceil((card_id_length + facility_code_length + 3) / 3))
	# For each of the groups of 3 bits, shift left 4 so that we add
	# the leading zero
	bcd_value = 0
	for i in range(0, group_count):
		group = 0x7 & card_bits
		card_bits >>= 3;
		bcd_value |= (group << (i * 4))
	return bcd_value

def decode_id_for_bcd_string(bcd_string):
	"""Given a string representing the binary coded decimal format the HID
	reader sends us, generate the corresponding integer value
	
	Arguments
	bcd_string -- the string representation of a bcd number (ie '73892')
	"""
	output = 0
	for char in bcd_string:
		output <<= 3
		output |= int(char)
	return output

def print_binary_id(card_id):
	"""Prints out a formatted binary card id separated by parity bits, facility
	code, and card id. Useful for debugging"""
	print string_from_binary((card_id >> 26) & 1),
	print string_from_binary((card_id >> 25) & 1),
	print string_from_binary((card_id >> 17) & 0xFF, length=8),
	print string_from_binary((card_id >> 1) & 0xFFFF, length=16),
	print string_from_binary(card_id & 1)

def generate_ascii_representation_from_bcd_value(bcd_id):
	"""Prints a string of len == 16 representing the whole card value"""
	return "%.16X" % bcd_id

def user_dicts_from_csv(filename):
	"""Reads a .csv file that contains lines like "Boiles, John","12345"
	and processes them into dicts like:
	{"first_name": "John", "last_name": "Boiles", "id": 12345}"""
	user_dicts = []
	user_rows = csv.reader(open(filename, 'rb'), delimiter=',', quotechar='"')
	for user_row in user_rows:
		user_dict = {}
		name = user_row[0].split(', ')
		# Throw out names that don't have both a first and last name
		if len(name) > 1:
			# Remove '  CM' from the end of the first name
			if name[1][(len(name[1]) - 4):] == '  CM':
				name[1] = name[1][:(len(name[1]) - 4)]
			user_dict['last_name'] = name[0]
			user_dict['first_name'] = name[1]
			user_dict['id'] = int(user_row[1])
			user_dicts.append(user_dict)
		else:
			pass
			#print "Throwing out invalid name: %s" % name[0]
	return user_dicts

def generate_sql_for_user_dicts(user_dicts):
	"""Generates SQL insert lines for users. For a more quick and dirty way of
	inserting users into the kegpad db. Note: this is untested."""
	sql = ""
	for user_dict in user_dicts:
		card_string = generate_ascii_representation_from_bcd_value(generate_bcd_value_for_id(user_dict['id'], 100))
		sql += "INSERT INTO \"ZKBUSER\" VALUES(6,6,4,0.0,'%s','%s','%s');\n" % (user_dict['first_name'], card_string, user_dict['last_name'])
	return sql

def generate_json_for_user_dicts(user_dicts):
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
	option_parser.add_option('--file', dest='file', help='CSV file to convert (contains lines like "Boiles, John","12345")')
	option_parser.add_option('--format', dest='format', default='json', help='Output format. json or sql (default:%default)')	
	(opts, args) = option_parser.parse_args()
	user_dicts = user_dicts_from_csv(opts.file)
	if opts.format == 'json':
		print generate_json_for_user_dicts(user_dicts)
	elif opts.format == 'sql':
		print generate_sql_for_user_dicts(user_dicts)
