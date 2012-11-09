/* 
 * File:   gpio.h
 * Author: sid
 *
 * Created on November 9, 2012, 3:43 PM
 */

#ifndef GPIO_H
#define	GPIO_H
#include "global.h"

int gpioExport(gpio_t *gpio);
int gpioDir(gpio_t *gpio);
int gpioSetValue(gpio_t *gpio, unsigned short int value);
int gpioSwapValue(gpio_t *gpio);
int gpioUnexport(gpio_t *gpio);
int gpioOpenValue(gpio_t *gpio);
int gpioCloseValue(gpio_t *gpio);
int testprint();

#endif	/* GPIO_H */