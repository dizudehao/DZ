//
//  IOSUtils.m
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/11.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import "IOSUtils.h"
#import <UIKit/UIKit.h>

@implementation IOSUtils




+(UILabel *)getCustomLabelObject:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color xPos:(float)x yPos:(float)y textAlign:(int)textalign
{
    CGSize fontSize=[title sizeWithFont:font];
    return [self getCustomLabelObject:title font:font textColor:color xPos:x yPos:y labelWidth:fontSize.width labelHeight:fontSize.height textAlign:textalign];
}

+(UILabel *)getCustomLabelObject:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color xPos:(float)x yPos:(float)y labelWidth:(float)labelwidth labelHeight:(float)labelheight textAlign:(int)textalign
{
    if (title==nil) {
        title=@"--";
    }
    UILabel *ltypeTitleLabel = [[UILabel alloc] init];
    ltypeTitleLabel.backgroundColor = [UIColor clearColor];
    ltypeTitleLabel.font = font;
    ltypeTitleLabel.textColor=color;
    ltypeTitleLabel.numberOfLines = 0;
    ltypeTitleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    ltypeTitleLabel.text = title;
    ltypeTitleLabel.textAlignment=textalign;
    ltypeTitleLabel.frame=CGRectMake(x,y, labelwidth, labelheight);
    
    return ltypeTitleLabel;
}


@end
