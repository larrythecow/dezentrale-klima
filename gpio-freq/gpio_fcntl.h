/*
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

Author: imran shamshad
Email: sid@projekt-turm.de
*/


#ifndef GPIO_FCNTL_H
#define	GPIO_FCNTL_H
#include "global.h"



int gpioExport(gpio_t *gpio);
int gpioDir(gpio_t *gpio, int dir);
int gpioSetValue(gpio_t *gpio, unsigned short int value);
int gpioSwapValue(gpio_t *gpio);
int gpioUnexport(gpio_t *gpio);
int gpioOpenValue(gpio_t *gpio);
int gpioCloseValue(gpio_t *gpio);
int testprint();

#endif	/* GPIO_FCNTL_H */

