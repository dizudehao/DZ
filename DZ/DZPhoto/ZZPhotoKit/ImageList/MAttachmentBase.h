//
//  MAttachmentBase.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/6.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import "MBaseVO.h"

@interface MAttachmentBase : MBaseVO
@property(nonatomic, assign)long long        identifier;
@property(nonatomic, copy)NSString        *name;
@property(nonatomic, assign)long long        size;
@property(nonatomic, copy)NSString        *createDate;
@property(nonatomic, copy)NSString        *modifyTime;
@property(nonatomic, assign)long long        reference;
@property(nonatomic, assign)long long        subReference;
@property(nonatomic, assign)NSInteger        category;
@property(nonatomic, copy)NSString        *mimeType;
@property(nonatomic, copy)NSString        *verifyCode;
@end
