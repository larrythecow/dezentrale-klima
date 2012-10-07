#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/hrtimer.h>
#include <linux/gpio.h>
#include <linux/ktime.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/version.h>
#include <asm/uaccess.h>

static enum hrtimer_restart timer_oscillateur(struct hrtimer *);
static struct hrtimer htimer;

static int periode_us = 1000;
module_param(periode_us, int, 0644);
static ktime_t kt_periode;


// 138 Broche 10 du port J3 (Expansion A) de la Pandaboard
#define GPIO_OSCILLATEUR 138

static int __init init_oscillateur (void)
{
	int err;

	kt_periode = ktime_set(0, 1000 * periode_us);

	if ((err = gpio_request(GPIO_OSCILLATEUR, THIS_MODULE->name)) != 0) {
		return err;
	}
	if ((err = gpio_direction_output(GPIO_OSCILLATEUR, 1)) != 0) {
		gpio_free(GPIO_OSCILLATEUR);
		return err;
	}
	hrtimer_init (& htimer, CLOCK_REALTIME, HRTIMER_MODE_REL);
	htimer.function = timer_oscillateur;
	hrtimer_start(& htimer, kt_periode, HRTIMER_MODE_REL);
	
	return 0; 
}



static void __exit exit_oscillateur (void)
{
	hrtimer_cancel(& htimer);
	gpio_free(GPIO_OSCILLATEUR);
}



static enum hrtimer_restart timer_oscillateur(struct hrtimer * unused)
{
	static int value = 0;
	gpio_set_value(GPIO_OSCILLATEUR, value);
	value = 1 - value;
	hrtimer_forward_now(& htimer, kt_periode);
	return HRTIMER_RESTART;
}



module_init(init_oscillateur);
module_exit(exit_oscillateur);
MODULE_LICENSE("GPL");

