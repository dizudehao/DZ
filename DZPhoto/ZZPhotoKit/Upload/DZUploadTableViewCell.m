//
//  DZUploadTableViewCell.m
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/7.
//  Copyright © 2017年 Ace. All rights reserved.
//

#import "DZUploadTableViewCell.h"


#define SWidth self.frame.size.width
#define SHeight self.frame.size.height
@implementation DZUploadTableViewCell



-(instancetype)init
{
    if (self = [super init]) {
        
        
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.frame = CGRectMake(self.frame.size.width - 100, 10, 80, 50);
        [self.contentView addSubview:_statusLabel];
        
        _enumsLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_enumsLabel];
        
        
        _thumbImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_thumbImage];
    }

    return self;

}









- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
