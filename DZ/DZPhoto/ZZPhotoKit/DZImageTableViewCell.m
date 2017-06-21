//
//  DZImageTableViewCell.m
//  ZZPhotoKit
//
//  Created by DZ on 2017/5/18.
//  Copyright © 2017年 Ace. All rights reserved.
//
#define dMaxHeight 768

#import "DZImageTableViewCell.h"
#import "PicsCell.h"
#import "ZZPhoto.h"
#import "ZZCamera.h"
#import "DZPhotoBrowser.h"
#import "SyImageModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDImageCache.h"



#define DZ_VW (self.frame.size.width)
#define DZ_VH (self.frame.size.height)

@interface DZImageTableViewCell ()

@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, strong) UICollectionView *myCollection;

@end

@implementation DZImageTableViewCell



-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    [self creatCollectionViewWithType:0];
   // self.contentView.backgroundColor = [UIColor blueColor];
    return self;

}

- (instancetype)initWithType:(NSInteger)type
{
    self = [super init];
    
    if (!_picArr) {
        _picArr = [[NSMutableArray alloc]init];
    }
    if (!_urlArr) {
        _urlArr = [[NSMutableArray alloc]init];
    }
    if (_picArr) {
        [_picArr removeAllObjects];
    }
    [self creatCollectionViewWithType:type];
    // self.contentView.backgroundColor = [UIColor blueColor];
    return self;


}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!_picArr) {
        _picArr = [[NSMutableArray alloc]init];
    }
    if (!_urlArr) {
        _urlArr = [[NSMutableArray alloc]init];
    }
    if (_picArr) {
        [_picArr removeAllObjects];
    }
    if (!_infoArr) {
        _infoArr = [[NSMutableArray alloc]init];
    }

    [self creatCollectionViewWithType:1];
    return self;
}

-(void )creatCollectionViewWithType:(NSInteger)type
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 50)/3;
   // CGFloat photoSize = 180;
    flowLayout.minimumInteritemSpacing = 10.0;//item 之间的行的距离
    flowLayout.minimumLineSpacing = 10.0;//item 之间竖的距离
    flowLayout.itemSize = (CGSize){photoSize,photoSize};
    //self.sectionInset = UIEdgeInsetsMake(0, 2, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    CGFloat colHeight = 20;
    if (type == 1) {
        colHeight = 400;
    }
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20,colHeight) collectionViewLayout:flowLayout];
    
    [collectionView registerClass:[PicsCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView setUserInteractionEnabled:YES];
    
    _myCollection = collectionView;
    [self.contentView addSubview:_myCollection];
    
    
}



#pragma mark - collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return _picArr.count;
   //return _infoArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
   // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    
    PicsCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    if (!photoCell) {
        photoCell = [[PicsCell alloc]init];
    }
    
    
    
    
//   SyImageModel *imageModel=(SyImageModel *)[_infoArr objectAtIndex:indexPath.row];
//    
//    if (imageModel.localImage) {
//        
//        
//        UIImage *dImage = imageModel.localImage;
//        photoCell.photo.image = [self imageWithImageSimple:dImage scaledToSize:dImage.size];
//        photoCell.origin = dImage;
//        [_picArr addObject:imageModel.localImage];
//        
//    }else{
//    
//    NSString *attID = [NSString stringWithFormat:@"%lld",imageModel.remoteAttchment.attID];
//        
////    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.211/seeyon/filehtp.do?method=fileDownload&token=&fileId=%@",attID];
//    
//     NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.211/seeyon/filehtp.do?method=getPhotoThumails&id=%@",attID];
////    [photoCell.photo sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"photo@2x.png"]];
//         [photoCell.photo sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"photo@2x.png"] options:SDWebImageLowPriority];
//
////    if (![_urlArr containsObject:urlStr]) {
////        [_urlArr addObject:urlStr];
//// 
////        [self doSomeNetworkWorkWithProgressWithUrlStr:urlStr];
////    }
//   
//    }
//    
    
    
    
    
       if (_picArr.count != 0) {
        
//           UIImage *dImage = [UIImage imageWithData:[_picArr objectAtIndex:indexPath.row]];
           UIImage *dImage = [_picArr objectAtIndex:indexPath.row];
           photoCell.photo.image = [self imageWithImageSimple:dImage scaledToSize:dImage.size];
           photoCell.origin = dImage;
       }
        
  
    return photoCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_picArr.count != _infoArr.count) {
        return;
    }
    DZPhotoBrowser *browser = [[DZPhotoBrowser alloc]init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.sourceViewFrame=[UIScreen mainScreen].bounds;
    browser.imageCount = _picArr.count; // 图片总数
    browser.currentImageIndex = (int)indexPath.row;
    
//    NSMutableArray *mPicArr = [[NSMutableArray alloc]init];
//    for (NSData *data in _picArr) {
//        UIImage *image = [UIImage imageWithData:data];
//        [mPicArr addObject:image];
//    }
//    browser.sourceImageArray=mPicArr;
    browser.sourceImageArray = _picArr;
    [browser show];


}

//裁剪
- ( UIImage *)imageWithImageSimple:( UIImage *)image scaledToSize:( CGSize )newSize

{
    
    newSize = CGSizeMake(200, 150);
    // Create a graphics image context
    
    UIGraphicsBeginImageContext (newSize);
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    
    [image drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];
    
    // Get the new image from the context
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
    
    // End the context
    
    UIGraphicsEndImageContext ();
    
    // Return the new image.
    
    return newImage;
    
}


- (void)doSomeNetworkWorkWithProgressWithUrlStr:(NSString *)urlStr
{
   
    NSInteger a = 0;
    
    
   
    
   
    UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
            
            if (thumbnailImage) {
                
                a++;
                NSLog(@"已有%ld",(long)a);
                if (![_picArr containsObject:thumbnailImage]) {
                    [_picArr addObject:thumbnailImage];
                    
                }
               
            }
            else{
                
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                
                [manager.imageDownloader downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                   // NSLog(@"%ld",receivedSize/expectedSize);
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    
                    NSLog(@"%@",data);
                    if (![_picArr containsObject:image]) {
                         [_picArr addObject:image];
                    }
                   
                }];
                
            }
    

    
    
}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (!decelerate) {
//        [self loadCoverimageForVisibleCells];
//    }
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self loadCoverimageForVisibleCells];
//}
//
//-(void)loadCoverimageForVisibleCells
//{
//    NSArray *visibleCells = [_myCollection indexPathsForVisibleItems];
// //   NSMutableArray *visibleArr = [NSMutableArray array];
////    for (NSIndexPath *index in visibleCells) {
////        
////    }
//    [_myCollection reloadItemsAtIndexPaths:visibleCells];
//}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
