#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

#include "global.h"
#include "gpio_fcntl.h"
#include <errno.h>

char buffer[DIMCHAR];

int gpioExport(gpio_t *gpio) {
    if ((gpio->fd = open(EXPORT, O_WRONLY | O_NDELAY, 0)) == -1) {
        printf("could not export %d\n", gpio->id);
        exit(-1);
    } else if (errno = !NULL) {
        printf("WARNING: gpioExport: %d\n", errno);
        //perror("Warning: already exported?");
    }

    snprintf(buffer, DIMCHAR, "%d", gpio->id);
    write(gpio->fd, buffer, strlen(buffer));
    close(gpio->fd);
    snprintf(gpio->path, DIMCHAR, "%sgpio%d/", PATH, gpio->id);

    return errno;
}

int gpioUnexport(gpio_t *gpio) {
    if ((gpio->fd = open(UNEXPORT, O_WRONLY | O_NDELAY, 0)) == -1) {
        printf("could not unexport %d\n", gpio->id);
        exit(-1);
    } else {
        snprintf(buffer, DIMCHAR, "%d", gpio->id);
        write(gpio->fd, buffer, strlen(buffer));
        close(gpio->fd);
        snprintf(gpio->path, DIMCHAR, "\0");
    }
    return errno;
}

int gpioDir(gpio_t *gpio, int dir) {
    snprintf(buffer, DIMCHAR, "%sdirection", gpio->path);
    if ((gpio->fd = open(buffer, O_WRONLY | O_NDELAY, 0)) == -1) {
        printf("could not open dir");
        exit(-1);
    } else {
        if (dir >= 0) {
            snprintf(buffer, DIMCHAR, "%s", "out");
        } else {
            snprintf(buffer, DIMCHAR, "%s", "in");
        }
        write(gpio->fd, buffer, strlen(buffer));
        close(gpio->fd);
    }
    return errno;
}

int gpioSetValue(gpio_t *gpio, unsigned short int value) {
    snprintf(buffer, DIMCHAR, "%d", value);
    write(gpio->fd, buffer, strlen(buffer));

    return errno;
}

int gpioSwapValue(gpio_t *gpio) {
    return errno;
}

int gpioOpenValue(gpio_t *gpio) {
    snprintf(buffer, DIMCHAR, "%svalue", gpio->path);
    if ((gpio->fd = open(buffer, O_WRONLY | O_NDELAY, 0)) == -1) {
        printf("could not value\n");
        exit(-1);
    }
    return errno;
}

int gpioCloseValue(gpio_t *gpio) {
    close(gpio->fd);
    return errno;
}

int testprint() {
    return 1;
}