// See LICENSE file for license details.

#include "Arduino.h"

__BEGIN_DECLS

void
pinMode(uint32_t pin, uint32_t mode)
{
  
  if (pin >= variant_pin_map_size)
    return;
  
  switch (mode) {
  case INPUT_PULLUP:
    GPIO_REG(GPIO_DSEL)      &= digitalPinToBitMask(pin);
    break;
  case INPUT:
    GPIO_REG(GPIO_DSEL)      &= digitalPinToBitMask(pin);
    break;
  case OUTPUT:
    //GPIO_REG(GPIO_TYPE)      & ~digitalPinToBitMask(pin);
    GPIO_REG(GPIO_DSEL)      |= digitalPinToBitMask(pin);
    break;
  }
}


void
digitalWrite(uint32_t pin, uint32_t val)
{
  if (pin >= variant_pin_map_size)
    return;
  
  if (val)
    GPIO_REG(GPIO_ODATA) |=  digitalPinToBitMask(pin);
  else
    GPIO_REG(GPIO_ODATA) &= ~digitalPinToBitMask(pin);

}

int
digitalRead(uint32_t pin)
{
if (pin >= variant_pin_map_size)
  return 0;

 return ((GPIO_REG(GPIO_IDATA) & digitalPinToBitMask(pin)) != 0);
}

__END_DECLS
