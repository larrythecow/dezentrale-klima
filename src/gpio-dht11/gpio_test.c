//#include <linux/delay.h>
//#include <linux/version.h>
//#include <linux/device.h>
#include <linux/module.h>
//#include <linux/sched.h>
//#include <linux/cdev.h>
//#include <linux/gpio.h>
//#include <linux/fs.h>

//#include <plat/omap_device.h>
#include <asm/gpio.h>
//#include <asm/uaccess.h>
#include <asm/delay.h>
#include "panda.h"

#define DIV_HZ 1

unsigned long int i=0;


static int __init init_gpio_test (void)
{
	int err;
	
	printk("module loaded\n");
	if ((err = gpio_request(LED1, THIS_MODULE->name)) != 0) {
		return err;
	}
	if ((err = gpio_direction_output(LED1, 1)) != 0) {
		gpio_free(LED1);
		return err;
	}
	printk("\ton\n");
	gpio_set_value(LED1, 1);
	delay(500);
	gpio_set_value(LED1, 0); 	
	printk("\toff\n");
	return 0; 
}

static void __exit exit_gpio_test (void)
{
	gpio_free(LED1);
	printk("module unloaded\n");
}

module_init(init_gpio_test);
module_exit(exit_gpio_test);
MODULE_LICENSE("GPL");

