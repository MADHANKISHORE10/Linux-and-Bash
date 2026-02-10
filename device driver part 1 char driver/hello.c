#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>

MODULE_LICENSE ("GPL"); 
static int __init hello_init(void){
	printk("initialisation of driver\n");
		return 0;
}
static void __exit hello_exit(void)
{
	printk("cleaning the driver\n");
}

module_init(hello_init);
module_exit(hello_exit);

