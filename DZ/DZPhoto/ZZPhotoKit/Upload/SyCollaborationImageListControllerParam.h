//
//  SyCollaborationImageListControllerParam.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/10.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyCollaborationImageListControllerParam : NSObject

@property (nonatomic, copy) NSString *cID;
@property (nonatomic, copy) NSString *claZZ;
@property (nonatomic, copy) NSString *param;
@property (nonatomic, copy) NSString *vmode;

//分解Param
@property (nonatomic, copy) NSString *paramENName;//kczp0005
@property (nonatomic, copy) NSString *paramCNName;//照片分类
@property (nonatomic, copy) NSString *paramPriName;//权限组

@end
