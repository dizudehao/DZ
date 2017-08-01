//
//  DZUploadViewController.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/6.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyCollaborationImageListControllerParam.h"

@interface DZUploadViewController : UIViewController
{

    BOOL _isStop;
    BOOL _isUploadOver;
    
    NSInteger _overCount;

}
@property (nonatomic, strong)NSMutableDictionary *dataInfoDic;


//@property (nonatomic, retain) SyCollaborationImageListControllerParam *param;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *headerKeyArray;
@property (nonatomic, retain) NSMutableDictionary *dataInfoDict;

@property (nonatomic, retain) NSMutableArray *dataShowArray;
@property (nonatomic, retain) NSMutableArray *uploadBizArray;
@property (nonatomic, retain) NSMutableDictionary *urlDic;

@property(strong, nonatomic) NSString *vMode;
@property(strong, nonatomic) NSString *cID;
@property(strong, nonatomic) NSString *claZZ;
@property(strong, nonatomic) NSString *param;
@property(strong, nonatomic) NSString *teamName;
@property(strong, nonatomic) NSString *address;
@property(strong, nonatomic) NSString *uuid;
//分解Param
@property (nonatomic, copy) NSString *paramENName;//kczp0005
@property (nonatomic, copy) NSString *paramCNName;//照片分类
@property (nonatomic, copy) NSString *paramPriName;//权限组
@end
