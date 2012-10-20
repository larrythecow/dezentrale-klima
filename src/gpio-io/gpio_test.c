#include <linux/version.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/cdev.h>
#include <linux/gpio.h>
#include <linux/fs.h>

#include <asm/uaccess.h>
#include "panda.h"

#define DIV_HZ 1

static void timer_oscillateur(unsigned long);
static struct timer_list timer;

unsigned long int i=0;


static int __init init_gpio_test (void)
{
	int err;
	
	printk("mod-loaded\n");
	printk("expires:%lu jiffies:%lu HZ:%d DIV_HZ:%d\n", jiffies + HZ/DIV_HZ, jiffies, HZ, DIV_HZ);	
	if ((err = gpio_request(LED1, THIS_MODULE->name)) != 0) {
		return err;
	}
	if ((err = gpio_direction_output(LED1, 1)) != 0) {
		gpio_free(LED1);
		return err;
	}
	init_timer (& timer);
	timer.function = timer_oscillateur;
	timer.data = 0;
	timer.expires = jiffies + HZ/DIV_HZ;
	add_timer(& timer);
	
	return 0; 
}


static void __exit exit_gpio_test (void)
{
	del_timer(& timer);
	gpio_free(LED1);
	printk("exit i=%lu\n", i);
}


static void timer_oscillateur(unsigned long unused)
{
	static int value = 0;
	gpio_set_value(LED1, value);
	value = 1 - value;
	mod_timer(& timer, jiffies + HZ/DIV_HZ);
	i++;
}


module_init(init_gpio_test);
module_exit(exit_gpio_test);
MODULE_LICENSE("GPL");

