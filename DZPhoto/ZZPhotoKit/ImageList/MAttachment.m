//
//  MAttachment.m
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/6.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import "MAttachment.h"

@implementation MAttachment



- (instancetype)initWithDic:(NSDictionary *)Dic
{

    self = [super init];
    if (self) {
        self.subReference = [Dic[@"subReference"]longLongValue];
        self.category = [Dic[@"category"]longLongValue];
        self.suffix = Dic[@"suffix"];
        self.mimeType = Dic[@"mimeType"];
        self.createDate = Dic[@"creatDate"];
        self.verifyCode = Dic[@"verifyCode"];
        self.size = [Dic[@"size"]longLongValue];
        self.identifier = [Dic[@"identifier"]longLongValue];
        self.attID = [Dic[@"attID"]longLongValue];
        self.classType = Dic[@"classType"];
        self.modifyTime = Dic[@"modifyTime"];
        self.reference = [Dic[@"reference"]longLongValue];
        self.name = Dic[@"name"];
    }

    return self;


}
@end
