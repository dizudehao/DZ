//
//  DZPhotoBrowser.m
//  ZZPhotoKit
//
//  Created by DZ on 2017/5/26.
//  Copyright © 2017年 Ace. All rights reserved.
//

// browser背景颜色
#define SDPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]
// browser中显示图片动画时长
#define SDPhotoBrowserHideImageAnimationDuration 0.8f
// browser中图片间的margin
#define SDPhotoBrowserImageViewMargin 0

#import "DZPhotoBrowser.h"
#import "VIPhotoView.h"

@implementation DZPhotoBrowser
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIActivityIndicatorView *_indicatorView;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor clearColor];
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    //_scrollView.backgroundColor = [UIColor redColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    
    for (int i = 0; i < self.imageCount; i++) {
        CGRect frame= CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        VIPhotoView *imageView = [[VIPhotoView alloc] initWithFrame:frame andImage:[self.sourceImageArray objectAtIndex:i]];
        
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
        [_scrollView addSubview:imageView];
    }
    
    
    //[self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    VIPhotoView *photoView = _scrollView.subviews[index];
    //[imageView eliminateScale];
    
    photoView.imageView.image = [self.sourceImageArray objectAtIndex:index];
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    _scrollView.hidden = YES;
    
//    VIPhotoView *currentImageView = (VIPhotoView *)recognizer.view;
//   // NSInteger currentIndex = currentImageView.tag;
//    
//    UIView *sourceView = self.sourceImagesContainerView;
//    CGRect targetTemp = CGRectMake(self.center.x, self.center.y, sourceView.frame.size.width, sourceView.frame.size.height);
//    //CGRect targetTemp=sourceView.frame;
//    
//    UIImageView *tempView = [[UIImageView alloc] init];
//    tempView.image = currentImageView.imageView.image;
//    CGFloat h = (self.bounds.size.width / currentImageView.imageView.image.size.width) * currentImageView.imageView.image.size.height;
//    
//    if (!currentImageView.imageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
//        h = self.bounds.size.height;
//    }
//    
//    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
//    tempView.center = self.center;
//    
//    [self addSubview:tempView];
//    
//    
//    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
//        tempView.frame = targetTemp;
//        self.backgroundColor = [UIColor clearColor];
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = SDPhotoBrowserImageViewMargin;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height - SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(VIPhotoView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    _scrollView.pagingEnabled = YES;
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)showFirstImage
{
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动100后清除缩放
    CGFloat margin = 100.0;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        //VIPhotoView *imageView = _scrollView.subviews[index];
        //        if (imageView.isScaled) {
        //            [UIView animateWithDuration:0.5 animations:^{
        //                imageView.transform = CGAffineTransformIdentity;
        //            } completion:^(BOOL finished) {
        //                [imageView eliminateScale];
        //            }];
        //        }
    }
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    [self setupImageOfImageViewForIndex:index];
}

@end
