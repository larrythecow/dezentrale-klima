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

void _gpio_direction(FILE * fp, char path[256], int gpio, int dir)
{
   snprintf(path, 256, "/sys/class/gpio/gpio%d/direction", gpio);
   if ((fp = fopen(path, "w")) == NULL) {
       perror(path);
       exit(EXIT_FAILURE);
   }
   if(dir == 1)
		fprintf(fp, "out\n");
   else if(dir == 0)
		fprintf(fp, "in\n");
   else
		printf("Could not set direction\n");
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

int main(int argc, char *argv[]){
	int value = 1;
	char path[256];
	int gpioLed = 138;
	FILE * fp;

	_check_cmd(argc, argv, gpioLed);
	_gpio_export(fp, path[256], gpioLed);
	_gpio_direction(fp, path[256], gpioLed, 1);

	_gpio_mainLoop(fp, path, gpioLed);

	_gpio_unexport(fp, path[256], gpioLed);

	return 0;
}
