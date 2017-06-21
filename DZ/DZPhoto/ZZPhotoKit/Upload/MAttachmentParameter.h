//
//  MAttachmentParameter.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/11.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAttachmentParameter : NSObject
@property(nonatomic, copy)NSString        *fileUrl;
@property(nonatomic, copy)NSString        *name;
@property(nonatomic, assign)long long        reference;
@property(nonatomic, assign)long long        subReference;
@property(nonatomic, assign)long long        size;
@property(nonatomic, copy)NSString        *createDate;
@property(nonatomic, copy)NSString        *mimeType;
@property(nonatomic, assign)NSInteger        type;
@property(nonatomic, copy)NSString        *classType;


@end
