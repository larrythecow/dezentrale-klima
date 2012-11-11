#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sched.h>

#include <sys/io.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>

#include "global.h"
#include "gpio_fcntl.h"

//#include <sys/io.h>
//#include <sys/inotify.h>
//#include <sys/types.h>
//#include <sys/stat.h>

/*
 * 
 */

/* using clock_nanosleep of librt */
extern int clock_nanosleep(clockid_t __clock_id, int __flags,
        __const struct timespec *__req,
        struct timespec *__rem);

static inline void tsnorm(struct timespec *ts) {
    while (ts->tv_nsec >= NSEC_PER_SEC) {
        ts->tv_nsec -= NSEC_PER_SEC;
        ts->tv_sec++;
    }
}

void setPriority(struct sched_param *param, int __sched_priority) {
    param->sched_priority = __sched_priority;
    // Enable realtime fifo scheduling.
    if (sched_setscheduler(0, SCHED_FIFO, param) == -1) {
        perror("Error: sched_setscheduler failed.");
        exit(-1);
    }
}

int main(int argc, char** argv) {
    int i;
    clock_t t1, t2;
    gpio_t gpio_led1 = {"GPIO138 led1", 138, "out"};

    struct timespec timer;
    struct sched_param param;
    int interval = 1000; // 50000ns = 50us, cycle duration = 100us
    
    setPriority(&param, 99);

    printf("hallo welt\n");
    gpioExport(&gpio_led1);
    gpioDir(&gpio_led1, 1);
    gpioOpenValue(&gpio_led1);

    clock_gettime(0, &timer); // Get current time.
    timer.tv_sec++; // Start after one second.

    t1 = clock();
    for (i = 0; i < 1000000; i++) {
        clock_nanosleep(0, TIMER_ABSTIME, &timer, NULL);
        gpioSetValue(&gpio_led1, i % 2);
        timer.tv_nsec += interval;
        tsnorm(&timer);
    }
    t2 = clock();
    printf("needed %f time", ((float) t2 - (float) t1) / 1000000.0F);

    gpioCloseValue(&gpio_led1);
    gpioUnexport(&gpio_led1);
    printf("hallo schwarzes loch\n");

    return 0;
}