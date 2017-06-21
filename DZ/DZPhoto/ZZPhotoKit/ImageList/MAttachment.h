//
//  MAttachment.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/6.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import "MAttachmentBase.h"

@interface MAttachment : MAttachmentBase
@property(nonatomic, assign)long long        attID;
@property(nonatomic, copy)NSString        *suffix;
@property(nonatomic, copy)NSString        *classId;
@property(nonatomic, copy)NSString        *className;



- (instancetype)initWithDic:(NSDictionary *)Dic;
@end
