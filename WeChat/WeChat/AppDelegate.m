//
//  AppDelegate.m
//  WeChat
//
//  Created by 袁艳祥 on 15/12/2.
//  Copyright © 2015年 袁艳祥. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
/*
 * 在AppDelegate实现登录
 
 1. 初始化XMPPStream
 2. 连接到服务器[传一个JID]
 3. 连接到服务成功后，再发送密码授权
 4. 授权成功后，发送"在线" 消息
 */

@interface AppDelegate ()<XMPPStreamDelegate>
{
    XMPPStream *_xmppStream;
}
//1. 初始化XMPPStream
- (void)setupXMPPStream;

//2. 连接到服务器[传一个JID]
- (void)connectToHost;

//3. 连接到服务成功后，再发送密码授权
- (void)sendPwdToHost;

//4. 授权成功后，发送"在线" 消息
- (void)sendOnlineToHost;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self connectToHost];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -私有方法
#pragma mark -初始化XMPPStream
- (void)setupXMPPStream
{
    _xmppStream = [[XMPPStream alloc] init];
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark -连接到服务器
- (void)connectToHost
{
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    //设置JID
    //resource标识用户登录的客户端 iphone
    XMPPJID *myJID = [XMPPJID jidWithUser:@"zhansan" domain:@"yuan.local" resource:@"iPhone"];
    _xmppStream.myJID = myJID;
    
    //设置服务器域名
    _xmppStream.hostName = @"yuan.local";//还可以是IP地址
    
    //设置端口
    //_xmppStream.hostPort = 5222;
    
    NSError *err = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
        NSLog(@"%@",err);
    }
}

#pragma mark -连接到服务成功后，再发送密码授权
- (void)sendPwdToHost
{
    NSError *err = nil;
    [_xmppStream authenticateWithPassword:@"123456" error:&err];
    if (err) {
        NSLog(@"%@", err);
    }
}

#pragma mark -授权成功后，发送"在线" 消息
- (void)sendOnlineToHost
{
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"%@", presence);
    [_xmppStream sendElement:presence];
}


#pragma mark -XMPPStream的代理方法
#pragma mark -与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"与主机连接成功");
    
    //连接成功发送密码给服务器进行授权
    [self sendPwdToHost];
}

#pragma mark -与主机连接断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
        NSLog(@"与主机连接断开连接,%@", error);
}

#pragma mark -授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"授权成功");
    [self sendOnlineToHost];
}

#pragma mark -授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
     NSLog(@"授权失败,%@", error);
}

#pragma mark -公共方法
-(void)logout{
    // 1." 发送 "离线" 消息"
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
}

@end
