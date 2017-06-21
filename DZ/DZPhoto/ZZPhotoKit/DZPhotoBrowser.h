//
//  DZPhotoBrowser.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/5/26.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZPhotoBrowser : UIView<UIScrollViewDelegate>

@property (nonatomic, retain) UIView *sourceImagesContainerView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, retain) NSMutableArray *sourceImageArray;
@property (nonatomic, assign) CGRect sourceViewFrame;

- (void)show;


@end
