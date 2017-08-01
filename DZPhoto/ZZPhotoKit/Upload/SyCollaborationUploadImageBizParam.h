//
//  SyCollaborationUploadImageBizParam.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/11.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyAttachment.h"
@interface SyCollaborationUploadImageBizParam : NSObject



@property (nonatomic,retain) NSString *moduleID;
@property (nonatomic,retain) NSString *voID;
@property (nonatomic,retain) NSString *imageObjKey;
@property (nonatomic,retain) SyAttachment *atta;
//@property (nonatomic,assign) SyBaseViewController *showLoadingVC;
@property (nonatomic,retain) NSString *paramENName;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,retain) NSString *ENName;


@end
