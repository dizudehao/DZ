//
//  DZImageTableViewCell.h
//  ZZPhotoKit
//
//  Created by DZ on 2017/5/18.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZImageTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>


- (instancetype)initWithType:(NSInteger)type;

@property (nonatomic ,strong) NSMutableArray *picArr;
@property (nonatomic ,strong) NSMutableArray *infoArr;
@end
