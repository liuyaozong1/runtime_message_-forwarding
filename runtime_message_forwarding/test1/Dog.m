//
//  Dog.m
//  test1
//
//  Created by liuyaozong on 2021/8/14.
//

#import "Dog.h"
#import <objc/runtime.h> //包含对类、成员变量、属性、方法的操作
#import <objc/message.h> //包含消息机制
#import "Cat.h"
@implementation Dog

void sendMessage(id self , SEL _CMD, NSString * msg) {
    NSLog(@"狗吃屎了 ");
}

//动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    //1.先要匹配方法 获取方法名称
    NSString *methodName = NSStringFromSelector(sel);
    if ([methodName isEqualToString:@"sendMessage:"]) {
        /*
         Class cls: 将要给添加方法的类，传的类型 ［类名  class］
         SEL name: 将要添加的方法名，传的类型   @selector(方法名)
         IMP imp：实现这个方法的函数 ，传的类型   1，C语言写法：（IMP）方法名    2，OC的写法：class_getMethodImplementation(self,@selector(方法名：))
         const char *types：表示我们要添加的方法的返回值和参数
         "v@:@"：v：是添加方法无返回值    @表示是id(也就是要添加的类) ：表示添加的方法类型  @表示：参数类型
         */
        return  class_addMethod(self, sel, (IMP)sendMessage, "V@:@");
    }
    return  NO;
}

//快速转发  找到一个备用的接受者来接收它
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    //1.先要匹配方法 获取方法名称
//    NSString *methodName = NSStringFromSelector(aSelector);
//    if ([methodName isEqualToString:@"sendMessage:"]) {
//        //如果 Cat 类实现了 sendMessage:的方法,则会调用 Cat 的方法
//        return  [Cat new];
//    }
    return  [super forwardingTargetForSelector:aSelector];
}

//方法签名
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    //1.先要匹配方法 获取方法名称
    NSString *methodName = NSStringFromSelector(aSelector);
    if ([methodName isEqualToString:@"sendMessage:"]) {
        //利用下面的方法进行方法签名
        return  [NSMethodSignature signatureWithObjCTypes:"V@:@"];
    }
    //继续按照默认步骤走, 进入最后慢速阶段的消息转发
    return  [super methodSignatureForSelector:aSelector];
    
}
//消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = [anInvocation selector];
    //找到一个备用者
    Cat *cat = [Cat new];
    //是否能响应方法
    if ([cat respondsToSelector:sel]) {
        //把当前的方法指给这个对象
        [anInvocation invokeWithTarget:cat];
    } else {
        //继续走对应默认的步骤  指向崩溃方法
        [super forwardInvocation:anInvocation];
    }
}

//提供报错信息  重写这个方法可以防止崩溃哦
-(void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"不会崩溃哦");
}

@end
