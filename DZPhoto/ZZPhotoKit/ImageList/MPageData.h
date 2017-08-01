//
//  MPageData.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/6.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import "MBaseVO.h"

@interface MPageData : MBaseVO
@property(nonatomic, assign)NSInteger        total;
@property(nonatomic, retain)NSArray        *dataList;
@property(nonatomic, copy)NSString        *extend;
@end
