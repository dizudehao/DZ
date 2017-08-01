//
//  PicsCell.m
//  ZZPhotoKit
//
//  Created by Yuan on 16/1/13.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "PicsCell.h"

@implementation PicsCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 50)/3;
        
        _photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, photoSize, photoSize)];
        
        _photo.layer.masksToBounds = YES;
        
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_photo];
        
        //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(turnFullScreen)];
        //[self addGestureRecognizer:tap];
    }
    return self;
    
   
    
}


- (void)turnFullScreen
{

    UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:0.9];
    _backView = backView;
    [self.window.rootViewController.view addSubview:_backView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imgView.center = backView.center;
    //要显示的图片，即要放大的图片
    [imgView setImage:_origin];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:imgView];
    
    imgView.userInteractionEnabled = YES;
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [imgView addGestureRecognizer:tapGesture];



}

- (void)closeView
{
    
    [_backView removeFromSuperview];
    
}


@end
