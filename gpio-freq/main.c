#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
//#include <time.h>

// https://en.wikipedia.org/wiki/File_descriptor
#include <fcntl.h>

#include "global.h"
#include "gpio_fcntl.h"
#include "gpio.h"

//#include <sched.h>
//#include <sys/io.h>
//#include <sys/inotify.h>
//#include <sys/types.h>
//#include <sys/stat.h>

/*
 * 
 */

int main(int argc, char** argv) {
    int i;
    int lhc=100;
    gpio_t gpio_led1 = {"GPIO138 led1", 138, "out"};

    printf("hallo welt\n");
    gpioExport(&gpio_led1);
    gpioUnexport(&gpio_led1);
    gpioExport(&gpio_led1);
    gpioDir(&gpio_led1);
    gpioSetValue(&gpio_led1, 1);
    
    
    //    
    //    printf("4 %p\n", gpio_led1.fp);
    //    printf("path: %s\n", gpio_led1.path);
    //    for (i = 0; i < 5; i++) {
    //        gpioOpenValue(&gpio_led1);
    //        fprintf(gpio_led1.fp, "%d\n", i % 2);
    //        gpioCloseValue(&gpio_led1);
    //        sleep(1);
    //    }
    //    printf("5 %p\n", gpio_led1.fp);
    //        
    //    gpioUnexport(&gpio_led1);
    printf("hallo schwarzes loch\n");


    return 0;
}