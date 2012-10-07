//http://www.blaess.fr/christophe/2012/05/09/gpio-pandaboard-temps-reel-1/
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static volatile int exit_loop = 0;

void handler_signal(int unused)
{
    exit_loop = 1;
}

void _check_cmd(int argc, char * argv[], int * gpio)
{
    if ((argc > 2) || ((argc == 2) && (sscanf(argv[1], "%d", gpio) != 1))) {
        fprintf(stderr, "usage: %s [gpio]\n", argv[0]);
        exit(EXIT_FAILURE);
    }
}

void _gpio_export(FILE * fp, char path[256], int gpio)
{
    snprintf(path, 256, "/sys/class/gpio/export");
    if ((fp = fopen(path, "w")) == NULL) {
        perror(path);
        exit(EXIT_FAILURE);
    }
    fprintf(fp, "%d\n", gpio);
    fclose(fp);
}

void _gpio_direction(FILE * fp, char path[256], int gpio)
{
    snprintf(path, 256, "/sys/class/gpio/gpio%d/direction", gpio);
    if ((fp = fopen(path, "w")) == NULL) {
        perror(path);
        exit(EXIT_FAILURE);
    }
    fprintf(fp, "out\n");
    fclose(fp);
}

void _gpio_mainLoop(FILE * fp, char path[256], int gpio)
{
	int value;
    snprintf(path, 256, "/sys/class/gpio/gpio%d/value", gpio);
    if ((fp = fopen(path, "w")) == NULL) {
        perror(path);
        exit(EXIT_FAILURE);
    }
    while (! exit_loop) {
        fprintf(fp, "%d\n", value);
        fflush(fp);
        value = 1 - value;
        usleep(1000);
    }
}

void _gpio_unexport(FILE * fp, char path[256], int gpio)
{
    if ((fp = fopen("/sys/class/gpio/unexport", "w")) == NULL) {
        perror("/sys/class/gpio/unexport");
        exit(EXIT_FAILURE);
    }
    fprintf(fp, "%d\n", gpio);
    fclose(fp);
}

int main(int argc, char * argv[])
{
    int value = 1;
    char path[256];
    int gpio = 138;
    FILE * fp;

    _check_cmd(argc, argv, &gpio);
    _gpio_export(fp, path, gpio);

    // Intercepter Controle-C pour finir proprement
    signal(SIGINT, handler_signal);

    _gpio_direction(fp, path, gpio);
    _gpio_mainLoop(fp, path, gpio);
    _gpio_unexport(fp, path, gpio);

    return EXIT_SUCCESS;
}

