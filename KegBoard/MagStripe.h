//
//  MagStripe.h
//  KegBoard
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

#include <inttypes.h>

#define MAGSTRIPE_DEBUG 0
#define MAGSTRIPE_BUFFER_SIZE 250

class MagStripe {
  public:
    MagStripe(uint8_t clockPin, uint8_t dataPin, uint8_t cardPresentPin);
    bool dataAvailable;
    void reset();
    int getData(char **data);
    void clockData();
  private:
    volatile unsigned char m_buffer[MAGSTRIPE_BUFFER_SIZE];
    volatile int m_bufferIndex;
    // Buffer for data, though this sucks since each char only uses a bit
    char m_cardData[40]; // holds card id string
    int m_dataSize; // length of card id string
    uint8_t m_clockPin;
    uint8_t m_dataPin;
    uint8_t m_cardPresentPin;
    int findStartSentinal();
    void decode();
    char saveByte(char thisByte[]);
    char decodeByte(char thisByte[]);
    void printBuffer();
};

