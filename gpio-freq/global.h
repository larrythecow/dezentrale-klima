/* 
 * File:   global.h
 * Author: sid
 *
 * Created on November 9, 2012, 3:46 PM
 */

#ifndef GLOBAL_H
#define	GLOBAL_H

#define DIMCHAR 265
//#define DEBUGFILE 1
#define PATH "/sys/class/gpio/"

/* 
 * darf ein fp/fd mehrmals verwendet werden
 * oder sollte jeweils ein eigener angelegt werden 
 * (fdValue, fdExport, fdUnexport
 */

typedef struct {
    char name[DIMCHAR];
    int id ;
    char dir[4];
    char path[DIMCHAR];
    FILE * fp;
    int fd;
    int (*test)();
} gpio_t;

#endif	/* GLOBAL_H */

