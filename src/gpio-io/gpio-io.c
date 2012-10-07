#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/gpio.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/version.h>
#include <asm/uaccess.h>

// 138 Broche 10 du port J3 (Expansion A) de la Pandaboard
#define GPIO_OSCILLATEUR 138

static int __init init_gpio-io (void)
{

  return 0;
}

static void __exit exit_gpio-io (void)
{
}

static void timer_gpio-io(unsigned long unused)
{
}

module_init(init_gpio-io);
module_exit(exit_gpio-io);
MODULE_LICENSE("GPL");
