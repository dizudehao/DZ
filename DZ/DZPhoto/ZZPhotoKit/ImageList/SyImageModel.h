//
//  SyImageModel.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/6.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAttachment.h"
#import "SyImageClassModel.h"
#import <UIKit/UIKit.h>

@interface SyImageModel : NSObject

@property(nonatomic,retain) NSString *classID;
@property(nonatomic,retain) NSString *imageObjKey;
@property(nonatomic,assign) BOOL isLocalPhoto;//是否本地图片 本地 远程
@property(nonatomic,strong) UIImage *localImage;//本地图片
@property(nonatomic,strong) UIImage *thumbImage;//本地图片
@property(nonatomic,assign) BOOL isUpload;//是否上传
@property(nonatomic,retain) NSString *uploadStatus;//上传状态

@property(nonatomic,retain) MAttachment *remoteAttchment;//附件
@property(nonatomic,assign) BOOL deleteStatus;//删除状态

@property(nonatomic,retain) SyImageClassModel *imageClassModel;//删除状态

@property(nonatomic,retain) NSURL *url;

@property(nonatomic,assign) NSInteger  num;

@property(nonatomic,retain) NSString *path;
@property(nonatomic,retain) NSString *thumbPath;


@end
