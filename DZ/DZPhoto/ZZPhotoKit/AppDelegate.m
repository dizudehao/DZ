//
//  AppDelegate.m
//  ZZPhotoKit
//
//  Created by Yuan on 16/1/4.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DZWelcomeViewController.h"
#import "AFNetworking.h"
#import "DZSettingViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    UIImage *navBarBgImage = [self imageWithColor:[UIColor colorWithRed:77/255.0 green:161/255.0 blue:210/255.0 alpha:1.0]];
    
  [[UINavigationBar appearance] setBackgroundImage:navBarBgImage forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f],NSFontAttributeName,nil]];

    
    
   
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    DZWelcomeViewController *mainViewController = [[DZWelcomeViewController alloc]initWithNibName:nil bundle:nil];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    return YES;
}


-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

static AFHTTPSessionManager *manager ;

- (AFHTTPSessionManager *)sharedHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10;
    });
    return manager;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{


    
    NSString *str = url.absoluteString;
    str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ViewController *mainViewController = [[ViewController alloc]initWithNibName:nil bundle:nil];
    mainViewController.infoStr = str;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    self.window.rootViewController = navi;
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    DZWelcomeViewController *mainViewController = [[DZWelcomeViewController alloc]initWithNibName:nil bundle:nil];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    NSLog(@"内存警告了⚠️⚠️⚠️⚠️⚠️⚠️⚠️");
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}
@end
