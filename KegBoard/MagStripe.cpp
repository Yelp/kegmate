//
//  MagStripe.m
//  KegBoard
//
//  Handles input from Magnetic stripe card readers
//  Based on code by Stephan King http://www.kingsdesign.com
//
//  Created by John Boiles on 9/25/10.
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include "MagStripe.h"
#include "pins_arduino.h"
#include "WProgram.h"

/*
Ideally this would use 2 external interrupts, one for the card present pin,
 and one of the clock pin. However, because this is limited there are several
 possibilities to work around this.
 1. Ignore card present signal and process data as it is clocked in. (handling state
 could be a bit difficult)
 2. Poll card present when getData is called (this assumes getData is called frequently,
 but is easy to implement)
 3. Use pin change interrupts (PCINT) so that this could be connected to any pin. (This
 is clearly the most reusable/generic, but could prove challenging)
 */

MagStripe::MagStripe(uint8_t clockPin, uint8_t dataPin, uint8_t cardPresentPin) {
  _clockPin = clockPin;
  pinMode(clockPin, INPUT);
  _dataPin = dataPin;
  pinMode(dataPin, INPUT);
  _cardPresentPin = cardPresentPin;
  pinMode(cardPresentPin, INPUT);
  reset();
}

int MagStripe::getData(char **data) {
  // If card is present, we're reading data, don't return anything
  if (digitalRead(_cardPresentPin) == LOW) return 0;
  // If data is available, return data, reset values
  if (dataAvailable) {
    decode();
    *data = _cardData;
    int dataSize = _dataSize;
    reset();
    return dataSize;
  }
  return 0;
}

void MagStripe::reset() {
  _bufferIndex = 0;
  _dataSize = 0;
  dataAvailable = false;
}

// Writes the bit to the buffer
void MagStripe::clockData() {
  if (_bufferIndex > MAGSTRIPE_BUFFER_SIZE) return;
  _buffer[_bufferIndex] = !digitalRead(_dataPin);
  _bufferIndex++;
  dataAvailable = true;
}

// prints the buffer
void MagStripe::printBuffer() {
#if MAGSTRIPE_DEBUG
  Serial.print("Buffer:");
  for (int j = 0; j < MAGSTRIPE_BUFFER_SIZE; j = j + 1) {
    Serial.println(_buffer[j], DEC);
  }
  Serial.println("End Buffer");
#endif
}

// Find the index of the start sentinel ';'
int MagStripe::findStartSentinal() {
  char queue[5];
  int sentinal = 0;

  for (int j = 0; j < MAGSTRIPE_BUFFER_SIZE; j = j + 1) {
    queue[4] = queue[3];
    queue[3] = queue[2];
    queue[2] = queue[1];
    queue[1] = queue[0];
    queue[0] = _buffer[j];

#if MAGSTRIPE_DEBUG
    Serial.print(queue[0], DEC);
    Serial.print(queue[1], DEC);
    Serial.print(queue[2], DEC);
    Serial.print(queue[3], DEC);
    Serial.println(queue[4], DEC);
#endif

    if (queue[0] == 0 & queue[1] == 1 & queue[2] == 0 & queue[3] == 1 & queue[4] == 1) {
      sentinal = j - 4;
      break;
    }
  }

#if MAGSTRIPE_DEBUG
  Serial.print("sentinal:");
  Serial.println(sentinal);
  Serial.println("");
#endif

  return sentinal;
}

void MagStripe::decode() {
  int sentinal = findStartSentinal();
  int i = 0;
  int k = 0;
  char thisByte[5];

  for (int j = sentinal; j < MAGSTRIPE_BUFFER_SIZE - sentinal; j = j + 1) {
    thisByte[i] = _buffer[j];
    i++;
    if (i % 5 == 0) {
      i = 0;
      if (thisByte[0] == 0 & thisByte[1] == 0 & thisByte[2] == 0 & thisByte[3] == 0 & thisByte[4] == 0) {
        break;
      }
      char value = saveByte(thisByte);
      // TODO(johnb): Do some validation. Maybe return false if there wasn't an end sentinel.
      if (value == '?') break; // End sentinel
    }
  }
#if MAGSTRIPE_DEBUG 
  Serial.print("Stripe_Data:");
  for (k = 0; k < _dataSize; k = k + 1) {
    Serial.print(_cardData[k]);
  }
  Serial.println("");
#endif
}

char MagStripe::saveByte(char thisByte[]) {
#if MAGSTRIPE_DEBUG
  for (int i = 0; i < 5; i = i + 1) {
    Serial.print(thisByte[i], DEC);
  }
  Serial.print("\t");
  Serial.print(decodeByte(thisByte));
  Serial.println("");
#endif
  char value = decodeByte(thisByte);
  if (value == ';') return ';'; // Ignore start sentinel
  if (value == '?') return '?'; // Ignore end sentinel
  _cardData[_dataSize] = value;
  _dataSize++;
  return value;
}

char MagStripe::decodeByte(char thisByte[]) {
  // 4 bits then parity
  if (thisByte[0] == 0 & thisByte[1] == 0 & thisByte[2] == 0 & thisByte[3] == 0 & thisByte[4] == 1){
    return '0';
  }

  if (thisByte[0] == 1 & thisByte[1] == 0 & thisByte[2] == 0 & thisByte[3] == 0 & thisByte[4] == 0){
    return '1';
  }

  if (thisByte[0] == 0 & thisByte[1] == 1 & thisByte[2] == 0 & thisByte[3] == 0 & thisByte[4] == 0){
    return '2';
  }

  if (thisByte[0] == 1 & thisByte[1] == 1 & thisByte[2] == 0 & thisByte[3] == 0 & thisByte[4] == 1){
    return '3';
  }

  if (thisByte[0] == 0 & thisByte[1] == 0 & thisByte[2] == 1 & thisByte[3] == 0 & thisByte[4] == 0){
    return '4';
  }

  if (thisByte[0] == 1 & thisByte[1] == 0 & thisByte[2] == 1 & thisByte[3] == 0 & thisByte[4] == 1){
    return '5';
  }

  if (thisByte[0] == 0 & thisByte[1] == 1 & thisByte[2] == 1 & thisByte[3] == 0 & thisByte[4] == 1){
    return '6';
  }

  if (thisByte[0] == 1 & thisByte[1] == 1 & thisByte[2] == 1 & thisByte[3] == 0 & thisByte[4] == 0){
    return '7';
  }

  if (thisByte[0] == 0 & thisByte[1] == 0 & thisByte[2] == 0 & thisByte[3] == 1 & thisByte[4] == 0){
    return '8';
  }

  if (thisByte[0] == 1 & thisByte[1] == 0 & thisByte[2] == 0 & thisByte[3] == 1 & thisByte[4] == 1){
    return '9';
  }

  if (thisByte[0] == 0 & thisByte[1] == 1 & thisByte[2] == 0 & thisByte[3] == 1 & thisByte[4] == 1){
    return ':';
  }

  if (thisByte[0] == 1 & thisByte[1] == 1 & thisByte[2] == 0 & thisByte[3] == 1 & thisByte[4] == 0){
    return ';';
  }

  if (thisByte[0] == 0 & thisByte[1] == 0 & thisByte[2] == 1 & thisByte[3] == 1 & thisByte[4] == 1){
    return '<';
  }

  if (thisByte[0] == 1 & thisByte[1] == 0 & thisByte[2] == 1 & thisByte[3] == 1 & thisByte[4] == 0){
    return '=';
  }

  if (thisByte[0] == 0 & thisByte[1] == 1 & thisByte[2] == 1 & thisByte[3] == 1 & thisByte[4] == 0){
    return '>';
  }

  if (thisByte[0] == 1 & thisByte[1] == 1 & thisByte[2] == 1 & thisByte[3] == 1 & thisByte[4] == 1){
    return '?';
  }

  return '*';
}


