#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

#include "global.h"
#include "gpio_fcntl.h"

char buffer[DIMCHAR];

int gpioExport(gpio_t *gpio) {
    if ((gpio->fd = open("/sys/class/gpio/export", O_WRONLY | O_NDELAY, 0)) == -1) {
        printf("could not open file");
        exit(-1);
    } else {
        snprintf(buffer, 5, "%d", gpio->id);
        write(gpio->fd, buffer, strlen(buffer));
        close(gpio->fd);
    }
    return 1;
}

int gpioUnexport(gpio_t *gpio) {
    if ((gpio->fd = open("/sys/class/gpio/unexport", O_WRONLY | O_NDELAY, 0)) == -1) {
        printf("could not open file");
        exit(-1);
    } else {
        snprintf(buffer, 5, "%d", gpio->id);
        write(gpio->fd, buffer, strlen(buffer));
        close(gpio->fd);
    }
    return 1;
}

int gpioDir(gpio_t *gpio) {
    if ((gpio->fd = open("/sys/class/gpio/gpio138/direction", O_WRONLY | O_NDELAY, 0)) == -1) {
        printf("could not open file");
        exit(-1);
    } else {
        snprintf(buffer, 4, "%s", "out");
        write(gpio->fd, buffer, strlen(buffer));
        close(gpio->fd);
    }
    return 1;
}

int gpioSetValue(gpio_t *gpio, unsigned short int value) {
    if ((gpio->fd = open("/sys/class/gpio/gpio138/value", O_WRONLY | O_NDELAY, 0)) == -1) {
        printf("could not open file");
        exit(-1);
    } else {
        snprintf(buffer, 2, "%d", value);
        write(gpio->fd, buffer, strlen(buffer));
        close(gpio->fd);
    }
    return 1;
}

int gpioSwapValue(gpio_t *gpio) {
    return 1;
}

int gpioOpenValue(gpio_t *gpio) {
    return 1;
}

int gpioCloseValue(gpio_t *gpio) {
    return 1;
}

int testprint() {
    return 1;
}