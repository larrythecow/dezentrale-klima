#include <linux/version.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/cdev.h>
#include <linux/gpio.h>
#include <linux/fs.h>

#include <asm/uaccess.h>

static void timer_oscillateur(unsigned long);
static struct timer_list timer;

// 138 Broche 10 du port J3 (Expansion A) de la Pandaboard
#define GPIO_OSCILLATEUR 138

static int __init init_oscillateur (void)
{
	int err;
	
	if ((err = gpio_request(GPIO_OSCILLATEUR, THIS_MODULE->name)) != 0) {
		return err;
	}
	if ((err = gpio_direction_output(GPIO_OSCILLATEUR, 1)) != 0) {
		gpio_free(GPIO_OSCILLATEUR);
		return err;
	}
	init_timer (& timer);
	timer.function = timer_oscillateur;
	timer.data = 0;
	timer.expires = jiffies + HZ/1000;
	add_timer(& timer);
	
	return 0; 
}


static void __exit exit_oscillateur (void)
{
	del_timer(& timer);
	gpio_free(GPIO_OSCILLATEUR);
}


static void timer_oscillateur(unsigned long unused)
{
	static int value = 0;
	gpio_set_value(GPIO_OSCILLATEUR, value);
	value = 1 - value;
	mod_timer(& timer, jiffies + HZ/1000);
}


module_init(init_oscillateur);
module_exit(exit_oscillateur);
MODULE_LICENSE("GPL");

