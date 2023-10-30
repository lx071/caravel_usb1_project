
#ifndef _VARIANT_RISCDUINO
#define _VARIANT_RISCDUINO


#include <stdint.h>

#define RISCDUINO_PLATFORM
#define RISCDUINO
#define RISCV
#include "platform.h"


/*----------------------------------------------------------------------------
*        Headers
*----------------------------------------------------------------------------*/

#include "Arduino.h"
#ifdef __cplusplus
#include "UARTClass.h"
#include "TIMERClass.h"
#endif


/* LEDs */
#define PIN_LED_13          13
#define PIN_LED             3
#define LED_BUILTIN         3

#ifdef __cplusplus
extern UARTClass Serial;
extern UARTClass Serial1;
extern TIMERClass Timer;
#endif

/*
 * SPI Interfaces
 */

#define SPI_INTERFACES_COUNT 1
#define SPI_REG(x) SPI0_REG(x)

#define UART_INTERFACES_COUNT 1
//#define UART_REG(x) UART0_REG(x)
#define UART_REGP(base,i) _REG32P(base, (i))

// we only want to enable 3 peripheral managed SPI pins: SCK, MOSI, MISO
// CS pins can either be handled by hardware or bit banged as GPIOs

static const uint8_t SS   = PIN_SPI1_SS0;
static const uint8_t SS1  = PIN_SPI1_SS1;
static const uint8_t SS2  = PIN_SPI1_SS2;
static const uint8_t SS3  = PIN_SPI1_SS3;
static const uint8_t MOSI = PIN_SPI1_MOSI;
static const uint8_t MISO = PIN_SPI1_MISO;
static const uint8_t SCK  = PIN_SPI1_SCK;

static const uint32_t SPI_IOF_MASK  = 0x400;
static const uint32_t IOF_UART_MASK = IOF0_UART0_MASK;

#define VARIANT_DIGITAL_PIN_MAP  { \
    {.io_port = 0, .bit_pos = 24, .pwm_num = 0xF, .pwm_cmp_num = 0, .ws281x_num = 0}, \
	{.io_port = 0, .bit_pos = 25, .pwm_num = 0xF, .pwm_cmp_num = 0, .ws281x_num = 0}, \
	{.io_port = 0, .bit_pos = 26, .pwm_num = 0xF, .pwm_cmp_num = 0, .ws281x_num = 0}, \
	{.io_port = 0, .bit_pos = 27, .pwm_num = 1,   .pwm_cmp_num = 1, .ws281x_num = 1}, \
	{.io_port = 0, .bit_pos = 28, .pwm_num = 1,   .pwm_cmp_num = 0, .ws281x_num = 1}, \
	{.io_port = 0, .bit_pos = 29, .pwm_num = 1,   .pwm_cmp_num = 2, .ws281x_num = 0}, \
	{.io_port = 0, .bit_pos = 30, .pwm_num = 1,   .pwm_cmp_num = 3, .ws281x_num = 0}, \
	{.io_port = 0, .bit_pos = 31, .pwm_num = 0xF, .pwm_cmp_num = 0, .ws281x_num = 0}, \
	{.io_port = 0, .bit_pos = 8,  .pwm_num = 0,   .pwm_cmp_num = 0, .ws281x_num = 0}, \
	{.io_port = 0, .bit_pos = 9,  .pwm_num = 0,   .pwm_cmp_num = 1, .ws281x_num = 1}, \
	{.io_port = 0, .bit_pos = 10, .pwm_num = 0,   .pwm_cmp_num = 2, .ws281x_num = 1}, \
	{.io_port = 0, .bit_pos = 11, .pwm_num = 0,   .pwm_cmp_num = 3, .ws281x_num = 1}, \
	{.io_port = 0, .bit_pos = 12, .pwm_num = 0xF, .pwm_cmp_num = 0, .ws281x_num = 1}, \
	{.io_port = 0, .bit_pos = 13, .pwm_num = 0xF, .pwm_cmp_num = 0, .ws281x_num = 0xF}, \
	{.io_port = 0, .bit_pos = 16, .pwm_num = 0xF, .pwm_cmp_num = 0, .ws281x_num = 0xF}, \
	{.io_port = 0, .bit_pos = 17, .pwm_num = 0xF, .pwm_cmp_num = 0, .ws281x_num = 0xF}, \
	{.io_port = 0, .bit_pos = 18, .pwm_num = 2,   .pwm_cmp_num = 0, .ws281x_num = 0xF}, \
	{.io_port = 0, .bit_pos = 19, .pwm_num = 2,   .pwm_cmp_num = 1, .ws281x_num = 0xF}, \
	{.io_port = 0, .bit_pos = 20, .pwm_num = 2,   .pwm_cmp_num = 2, .ws281x_num = 0xF}, \
	{.io_port = 0, .bit_pos = 21, .pwm_num = 2,   .pwm_cmp_num = 2, .ws281x_num = 0xF}, \
	{.io_port = 0, .bit_pos = 14, .pwm_num = 2,   .pwm_cmp_num = 2, .ws281x_num = 1}, \
	{.io_port = 0, .bit_pos = 15, .pwm_num = 2,   .pwm_cmp_num = 2, .ws281x_num = 1}, \
	{.io_port = 0, .bit_pos = 22, .pwm_num = 2,   .pwm_cmp_num = 3, .ws281x_num = 0}}

#define VARIANT_NUM_PIN (23)

#define VARIANT_PWM_LIST {(volatile void *) PWM0_BASE_ADDR, \
      (volatile void *) PWM1_BASE_ADDR, \
      (volatile void *) PWM2_BASE_ADDR}

#define VARIANT_NUM_WS281X (4)
#define VARIANT_NUM_PWM (3)
#define VARIANT_NUM_SPI (1)
// For interfacing with the onboard SPI Flash.
#define VARIANT_NUM_QSPI (1)
#define VARIANT_NUM_UART (1)

#endif 
