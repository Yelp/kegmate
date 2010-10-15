#!/usr/bin/python
#  debug_log_parser.py
#  KegMate
#
#  Code to parse and plot information from the KegMate debug logs.
#
#  Created by John Boiles on 10/28/10.
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

import optparse
import re
import matplotlib.pyplot as plt

def findFlowValueInLine(line):
	pattern = re.compile(".*flow0 _meterReading ([0-9]*)")
	values = re.findall(pattern, line)
	if len(values) > 0:
		return int(values[0])
	else:
		return None

def findTimeStampInLine(line):
	pattern = re.compile("([0-9]*)-([0-9]*)-([0-9]*) ([0-9]*):([0-9]*):([0-9]*.[0-9]*)")
	result = re.findall(pattern, line)
	if len(result) > 0:
		year, month, day, hour, minute, second = result[0]
		return int(hour) * 60 * 60 + int(minute) * 60 + float(second)
	else:
		return None

"""Flow meter got Volume 0.536885 and flow rate 0.123188"""
def findMeterFlowInLine(line):
	pattern = re.compile(".*Flow meter got Volume [0-9.]* and flow rate ([0-9.]*)")
	find_iter = pattern.finditer(line)
	result = re.findall(pattern, line)
	if len(result) > 0:
		return float(result[0])
	else:
		return None

def findMeterVolumeInLine(line):
	pattern = re.compile(".*Flow meter got Volume ([0-9.]*) and flow rate")
	find_iter = pattern.finditer(line)
	result = re.findall(pattern, line)
	if len(result) > 0:
		return float(result[0])
	else:
		return None

def plotFlowForLogFile(file, includeVolumeTicks=True, includePourVolume=False, includeFlowRate=False):
	log_file = open(file, 'r')
	flowTimeStamps = []
	volumeTicks = []
	meterTimeStamps = []
	pourVolumes = []
	flowRates = []
	for line in log_file:
		timeStamp = findTimeStampInLine(line)
		volumeTick = findFlowValueInLine(line)
		flowRate = findMeterFlowInLine(line)
		pourVolume = findMeterVolumeInLine(line)
		if volumeTick:
			print "Flow value %f, %d" % (timeStamp, volumeTick)
			flowTimeStamps.append(timeStamp)
			volumeTicks.append(volumeTick)
		elif pourVolume:
			print "Meter input %f, volume: %f flow: %f" % (timeStamp, pourVolume, flowRate)
			meterTimeStamps.append(timeStamp)
			pourVolumes.append(pourVolume)
			flowRates.append(flowRate)
	if includeVolumeTicks:
		plt.plot(flowTimeStamps, volumeTicks, '-x')
	if includePourVolume:
		plt.plot(meterTimeStamps, pourVolumes, '-x')
	if includeFlowRate:
		plt.plot(meterTimeStamps, flowRates, '-o')
	plt.ylabel('flow values')
	plt.show()

if __name__ == '__main__':
	option_parser = optparse.OptionParser()
	option_parser.add_option('-t', dest='ticks', action="store_true", help='Volume in absolute flowmeter ticks')
	option_parser.add_option('-v', dest='volume', action="store_true", help='Volume in litres (resets each pour)')
	option_parser.add_option('-f', dest='flow', action="store_true", help='Flow rate as passed to the flow meter')
	(opts, args) = option_parser.parse_args()
	plotFlowForLogFile(args[0], includeVolumeTicks=opts.ticks, includePourVolume=opts.volume, includeFlowRate=opts.flow)
