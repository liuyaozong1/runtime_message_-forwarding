//
//  ViewController.m
//  test1
//
//  Created by liuyaozong on 2021/8/14.
//

#import "ViewController.h"
#import "Dog.h"
#import <objc/runtime.h> //包含对类、成员变量、属性、方法的操作
#import <objc/message.h> //包含消息机制
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //方法调用
    [[Dog new] sendMessage:@"hello"];
    //上面的代码等同于下面的代码
//    objc_msgSend([Dog new],@selector(sendMessage:),@"hello");

    
}


@end
