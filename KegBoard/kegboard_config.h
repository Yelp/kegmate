//
// Feature configuration
//

// You may enable/disable kegboard features here as desired. The default are
// safe.

// Check for & report 1-wire temperature sensors?
#define KB_ENABLE_ONEWIRE_THERMO   1

// Check for & report 1-wire devices on the ID bus?
#define KB_ENABLE_ONEWIRE_PRESENCE 0

// Enable a selftest pulse?
#define KB_ENABLE_SELFTEST  0

// Enable buzzer?
#define KB_ENABLE_BUZZER    0

// Enable serial LCD?
#define KB_ENABLE_SERIAL_LCD 0

// Enable ID12?
#define KB_ENABLE_ID12 0

// Enable Analog?
#define KB_ENABLE_ANALOG_TEMP 0

// Enable MagStripe reader?
// WARNING: MagStripe needs an input capture interrupt to work, but so does
// KB_PIN_METER_B. Currently you cannot use meter b with MagStripe enabled
#define KB_ENABLE_MAGSTRIPE 1

//
// Pin configuration
//

// You may change values in this section if you know what you are doing --
// though you ordinarily shouldn't need to change these.
//
// The default digital pin allocation is:
//   2 - flowmeter 0 pulse (input)
//   3 - flowmeter 1 pulse (input)
//   4 - relay 0 control (output)
//   5 - relay 1 control (output)
//   6
//   7 - thermo onewire bus (1-wire, input/output)
//   8 - presence onewire bus (1-wire, input/output)
//   9 - alarm (output)
//   10
//   11 - buzzer (output)
//   12 - test pulse train (output)
//   13 - arduino onboard LED (if applicable)

#define KB_PIN_METER_A            2
//#define KB_PIN_METER_B            3
#define KB_PIN_RELAY_A            4
#define KB_PIN_RELAY_B            5
#define KB_PIN_ONEWIRE_THERMO     7
#define KB_PIN_ONEWIRE_PRESENCE   8
#define KB_PIN_ALARM              9
#define KB_PIN_BUZZER             11
#define KB_PIN_TEST_PULSE         12
#define KB_PIN_ANALOG_TEMP        3
// Sets this pin and the one after as NewSoftSerial port
// TODO(johnb): Since we don't need TX to the ID12 RFID reader, check and see if we can
// safely set the NewSoftSerial TX pin to 0
#define KB_PIN_ID12               6

#define KB_PIN_MAGSTRIPE_CLOCK    17
#define KB_PIN_MAGSTRIPE_DATA     18
#define KB_PIN_MAGSTRIPE_CARD_PRESENT 19

#define KB_PIN_SERIAL_LCD_TX 6
#define KB_PIN_SERIAL_LCD_RX 10

// Atmega1280 (aka Arduino mega) section
#ifdef __AVR_ATmega1280__
#define KB_ATMEGA_1280            1
#define KB_NUM_METERS             6

//#define KB_PIN_METER_C            21
//#define KB_PIN_METER_D            20
//#define KB_PIN_METER_E            19
//#define KB_PIN_METER_F            18
#else
#define KB_NUM_METERS             1
#endif

//
// Device configuration defaults
//

#define KB_DEFAULT_BOARDNAME          "kegboard"
#define KB_DEFAULT_BOARDNAME_LEN      8  // must match #chars above
#define KB_DEFAULT_BAUD_RATE          115200

// Size in entries of the onewire presence bus cache.  This many IDs can be
// concurrently tracked on the bus.
#define ONEWIRE_CACHE_SIZE 8

// Number of full onewire bus searches to complete before considering a
// non-responding onewire id missing.  This is used to dampen against glitches
// where a device might be absent from a search.
#define ONEWIRE_CACHE_MAX_MISSING_SEARCHES 4
