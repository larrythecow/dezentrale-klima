#include <stdio.h>
#include "global.h"
#include "gpio.h"

int testprint() {
    printf("XXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
    return 1;
}

int gpioOpenValue(gpio_t *gpio) {
    snprintf(gpio->path, DIMCHAR, "%sgpio%d/value", PATH, gpio->id);
    gpio->fp = fileopen(gpio->path, "w", "value");
    return 1;
}

int gpioCloseValue(gpio_t * gpio) {
    fileclose(gpio->fp, "value");
    gpio->fp=NULL;
    return 1;
}

int gpioExport(gpio_t *gpio) {
    snprintf(gpio->path, DIMCHAR, "%sexport", PATH);
    gpio->fp = fileopen(gpio->path, "w", "export");
    fprintf(gpio->fp, "%d", gpio->id);
    fileclose(gpio->fp, "export");
    gpio->fp=NULL;
    return 1;
}

int gpioDir(gpio_t *gpio) {
    snprintf(gpio->path, DIMCHAR, "%sgpio%d/direction", PATH, gpio->id);
    gpio->fp = fileopen(gpio->path, "w", "direction");
    fprintf(gpio->fp, "out");
    fileclose(gpio->fp, "direction");
    gpio->fp=NULL;
    return 1;
}

int gpioSetValue(gpio_t *gpio, unsigned short int value) {
    fprintf(gpio->fp, "%d", value);
    return 1;
}

int gpioUnexport(gpio_t *gpio) {
    snprintf(gpio->path, DIMCHAR, "%sunexport", PATH);
    gpio->fp = fileopen(gpio->path, "w", "unexport");
    fprintf(gpio->fp, "%d", gpio->id);
    fileclose(gpio->fp, "unexport");
    gpio->fp=NULL;
    return 1;
}

gpioSwapValue(gpio_t *gpio) {
    static int tmp;
    snprintf(gpio->path, DIMCHAR, "%sgpio%d/value", PATH, gpio->id);
    gpio->fp = fileopen(gpio->path, "w", "value");
    fscanf(gpio->fp, "%d", &tmp);
    //fread((void *)tmp, sizeof(int), 1, gpio->fp);
    printf("%d\n", tmp);
    //fprintf(gpio->fp, "%d", tmp%2);
    fileclose(gpio->fp, "value");
    return 1;
}
