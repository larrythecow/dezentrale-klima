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

#ifndef GLOBAL_H
#define	GLOBAL_H

#define DIMCHAR 265
//#define DEBUGFILE 1
#define PATH "/sys/class/gpio/"
#define EXPORT "/sys/class/gpio/export"
#define UNEXPORT "/sys/class/gpio/unexport"
#define NSEC_PER_SEC    1000000000

typedef struct {
    char name[DIMCHAR];
    int id ;
    char dir[4];
    char path[DIMCHAR];
//    FILE * fp;
    int fd;
    int (*test)();
} gpio_t;

#endif	/* GLOBAL_H */

