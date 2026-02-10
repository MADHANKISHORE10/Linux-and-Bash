#include<linux/module.h>
#include<linux/init.h>
#include<linux/fs.h>
#include<linux/sched.h>
#include<linux/errno.h>
#include<asm/current.h>
#include<asm/segment.h>
#include<asm/uaccess.h>

int ret;
static char kernelbuffer[1024];
static int datasize = 0;

MODULE_LICENSE ("GPL");
static int __init rinit(void);
static void __exit rexit(void);
int myopen(struct inode *inode,struct file *filep);
int myrelease(struct inode *inode,struct file *filep);
static ssize_t charread(struct file *fp, char __user *buf, size_t len, loff_t *off_set);
static ssize_t charwrite(struct file *fp, const char __user *buf, size_t len, loff_t *off_set);

static ssize_t charread(struct file *fp, char __user *buf, size_t len, loff_t *off_set)
{
    printk("<8> charread: copy_to_user\n");

    if (*off_set >= datasize)
        return 0;  // EOF

    if (len > datasize - *off_set)
        len = datasize - *off_set;

    if (copy_to_user(buf, kernelbuffer + *off_set, len))
        return -EFAULT;

    *off_set += len;
    return len;
}
static ssize_t charwrite(struct file *fp, char const __user *buf, size_t len, loff_t *off_set)
{
    printk("<8> charwrite: copy_from_user\n");

    if (len > sizeof(kernelbuffer) - *off_set)
        len = sizeof(kernelbuffer) - *off_set;

    if (copy_from_user(kernelbuffer + *off_set, buf, len))
        return -EFAULT;

    *off_set += len;
    datasize = *off_set;

    return len;
}

struct file_operations my_ops={
    .owner = THIS_MODULE,
    .open = myopen,
    .read = charread,
    .write = charwrite,
    .release = myrelease,

};

int myopen(struct inode *inode,struct file *filep)
{
printk("open is called\n");
return 0;
}
int myrelease(struct inode *inode,struct file *filep)
{
printk("close is called\n");
return 0;
}

module_init(rinit);
module_exit(rexit);

static int __init rinit(void)
{
printk("registering the char driver\n");
ret=register_chrdev(222,"new_device",&my_ops);
if(ret<0)
{
printk("<1> failed to register");
}
return 0;
}

static void __exit rexit(void)
{
printk("unregistering the char driver\n");
unregister_chrdev(222,"new_device");
}
