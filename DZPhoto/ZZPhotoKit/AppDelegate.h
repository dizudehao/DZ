//
//  AppDelegate.h
//  ZZPhotoKit
//
//  Created by Yuan on 16/1/4.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (AFHTTPSessionManager *)sharedHTTPSession;

@end

