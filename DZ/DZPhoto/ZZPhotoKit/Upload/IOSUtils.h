//
//  IOSUtils.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/11.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface IOSUtils : NSObject



+(UILabel *)getCustomLabelObject:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color xPos:(float)x yPos:(float)y textAlign:(int)textalign;

+(UILabel *)getCustomLabelObject:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color xPos:(float)x yPos:(float)y labelWidth:(float)labelwidth labelHeight:(float)labelheight textAlign:(int)textalign;

@end
