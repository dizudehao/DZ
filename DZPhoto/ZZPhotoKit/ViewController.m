//
//  ViewController.m
//  ZZPhotoKit
//
//  Created by Yuan on 16/1/4.
//  Copyright © 2016年 Ace. All rights reserved.
//
#define dMaxWidth 1024
#define dMaxHeight 768
#define kQuitAlertTag 1001
#define ZZ_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define ZZ_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//  上传成功通知
#define kNotify_Image_Upload_Success      @"kNotifyImageUploadSuccess"

#import "ViewController.h"
#import "ZZPhotoKit.h"
#import "PicsCell.h"
#import "DZImageTableViewCell.h"
#import "MPageData.h"
#import "SyImageClassModel.h"
#import "MAttachment.h"
#import "SyImageModel.h"
#import "DZUploadViewController.h"
#import "SyCollaborationImageListControllerParam.h"
#import "AppDelegate.h"
#import "DZSettingViewController.h"

#import "FMDB.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "SBJson5.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(strong, nonatomic) UILabel *firstlab;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *array;
@property(strong, nonatomic) UIView *backView;
@property(strong, nonatomic) UIScrollView *bScrollView;
@property(strong, nonatomic) UIImageView *bImageView;
@property(strong, nonatomic) UIProgressView* proView;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) UIButton *addBtn;
@property(strong, nonatomic) NSMutableArray *picArray;
@property(strong, nonatomic) NSArray *classIdArr;
@property(assign, nonatomic) NSInteger totalRemoteCount;

@property(strong, nonatomic) NSMutableArray *colArr_0;
@property(strong, nonatomic) NSMutableArray *colArr_1;
@property(strong, nonatomic) NSMutableArray *colArr_2;
@property(strong, nonatomic) NSMutableArray *colArr_3;
@property(strong, nonatomic) NSMutableArray *colArr_4;
@property(strong, nonatomic) NSMutableArray *colArr_5;

@property(strong, nonatomic) NSMutableDictionary *colDic;

@property(strong, nonatomic) NSMutableArray *classArr;
@property(strong, nonatomic) NSMutableArray *classNameArr;
@property(strong, nonatomic) NSMutableArray *headerKeyArray;
@property(strong, nonatomic) NSMutableDictionary *dataInfoDict;

//@property(strong, nonatomic) FMDatabase *db;
@property(strong, nonnull) FMDatabaseQueue * queue;
@property(strong, nonatomic) MBProgressHUD *hud;

@property(strong, nonatomic) NSString *dbPath;
@property(assign, nonatomic) NSInteger currentSelIndex;

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



@property(assign, nonatomic) BOOL isTakePhoto;
@property(strong, nonatomic) NSString *pType;                 //是否从M1传来了数据

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *locationStr;
@end

@implementation ViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"图片列表";
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
                                                                          target:self action:@selector(onLeftButton)];
        [leftButtonItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
       
        
        UIBarButtonItem *rightButtonItemSec = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(turnToSetting)];
        [rightButtonItemSec setTintColor:[UIColor whiteColor]];
        
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain
                                                                           target:self action:@selector(OnRightButton:)];
        [rightButtonItem setTintColor:[UIColor whiteColor]];
        //self.navigationItem.rightBarButtonItem = rightButtonItem;

        NSArray *buttons = [NSArray arrayWithObjects:rightButtonItem,rightButtonItemSec, nil];
        [self.navigationItem setRightBarButtonItems:buttons];

       
    }
    return self;
}


- (void)OnRightButton:(id)sender
{

    
    
    
    NSInteger localImageCount=0;
    for (SyImageClassModel *classModel in self.headerKeyArray) {
        NSArray *imageArray=[self.dataInfoDict objectForKey:classModel.classID];
        for (SyImageModel *imageModel in imageArray) {
            if(imageModel.isLocalPhoto)
            {
                localImageCount++;
            }
        }
    }
    if (localImageCount<=0) {
        //alert
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息" message:@"请选择上传图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 101;
        [alert show];

        NSLog(@"nononono");
        return;
    }
    DZUploadViewController *controller=[[DZUploadViewController alloc] init];
    controller.cID = _cID;
    controller.claZZ = _claZZ;
    controller.param = _param;
    controller.vMode = _vMode;
    controller.paramCNName = _paramCNName;
    controller.paramENName = _paramENName;
    controller.paramPriName = _paramPriName;
    controller.address = _address;
    controller.uuid = _uuid;
    controller.headerKeyArray=self.headerKeyArray;
    controller.dataInfoDict=_dataInfoDict;
    
    
    
    [self.navigationController pushViewController:controller animated:YES];
    

}

- (void)turnToSetting
{


    UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"设置" message:nil
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
    //UIAlertControllerStyleActionSheet:显示在屏幕底部
    //设置按钮
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    UIAlertAction*actionClear = [UIAlertAction
                                 actionWithTitle:@"清除缓存"
                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                     SDWebImageManager *mgr = [SDWebImageManager sharedManager];
                                     [mgr cancelAll];
                                     [mgr.imageCache clearMemory];
                                     
                                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"缓存清理完毕" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                     [alert show];
                                 }];
    
    
    UIAlertAction*actionIp = [UIAlertAction
                              actionWithTitle:@"设置地址"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                  
                                  DZSettingViewController *vc = [[DZSettingViewController alloc]init];
                                  vc.view.backgroundColor = [UIColor whiteColor];
                                  [self.navigationController pushViewController:vc animated:YES];
                                  
                              }];
    UIAlertAction*actionNo = [UIAlertAction
                              actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * _Nonnull action) {
                                  
                              }];
    [alert addAction:actionIp];
    [alert addAction:actionClear];
    [alert addAction:actionNo];
    [self presentViewController:alert
                       animated:YES completion:nil];



}

- (void)onLeftButton
{

    
    
    _totalRemoteCount=0;
    int localImageCount=0;
    for (SyImageClassModel *classModel in self.headerKeyArray) {
        NSArray *imageArray=[self.dataInfoDict objectForKey:classModel.classID];
        for (SyImageModel *imageModel in imageArray) {
            if(imageModel.isLocalPhoto)
            {
                localImageCount++;
            }
            else{
                _totalRemoteCount++;
            }
        }
    }
    if (localImageCount<=0) {
       
        
       // 替换字段名称
        NSString *formfield = _paramENName;
        formfield = [formfield stringByReplacingOccurrencesOfString :@"kczp" withString:@"field"];
        
        
        [self deleteTable];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"002" forKey:@"fmdb"];

        
        NSString *urlStr = [NSString stringWithFormat:@"zzm1://?%@_%ld",formfield,(long)_totalRemoteCount];
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
      
        return;
    }
    
    UIAlertView *versonAlert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                          message:@"退出之后未上传完成的图片将终止上传，确定吗？"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
    
    versonAlert.tag = kQuitAlertTag;
    [versonAlert show];
    
    

}


- (void)viewDidAppear:(BOOL)animated
{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *ipStr = [userDefault objectForKey:@"userIp"];
    NSString *portStr = [userDefault objectForKey:@"userPort"];
    
    if (ipStr.length>0&&portStr.length>0) {
        _address = [NSString stringWithFormat:@"%@:%@",ipStr,portStr];
    }else if (ipStr.length>0){
    
    _address = [NSString stringWithFormat:@"%@",ipStr];
    }

}
- (void)loadFMDB
{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否导入未上传图片" delegate:self cancelButtonTitle:@"不导入" otherButtonTitles:@"导入",nil];
    alert.tag = 10086;
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    [self loadNotify];
    [self createDB];
    [self createTable];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fType = [userDefaults objectForKey:@"fmdb"];
    if ([fType isEqualToString:@"001"]) {
        [self loadFMDB];
    }
    
    
    if (!_dataInfoDict) {
        _dataInfoDict = [[NSMutableDictionary alloc]init];
    }
    
    _pType = @"0";
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    
    //处理传过来的数据
    [self handleHeaderInfoWithStr:_infoStr];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *ipStr = [userDefault objectForKey:@"userIp"];
    NSString *portStr = [userDefault objectForKey:@"userPort"];
    
    if (ipStr.length>0&&portStr.length>0) {
        _address = [NSString stringWithFormat:@"%@:%@",ipStr,portStr];
    }else if (ipStr.length>0){
        
        _address = [NSString stringWithFormat:@"%@",ipStr];
    }

    
    if ([_pType isEqualToString:@"1"]) {
        //请求分类数据
        [self requestEnums];

    }
    
  
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZZ_VW, ZZ_VH-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;//不要分隔线
    [self.view addSubview:_tableView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat photoSize = (self.view.frame.size.width - 50) / 3;
    flowLayout.minimumInteritemSpacing = 10.0;//item 之间的行的距离
    flowLayout.minimumLineSpacing = 10.0;//item 之间竖的距离
    flowLayout.itemSize = (CGSize){photoSize,photoSize};
    //self.sectionInset = UIEdgeInsetsMake(0, 2, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ZZ_VW, photoSize * 2) collectionViewLayout:flowLayout];
    [_collectionView registerClass:[PicsCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView setUserInteractionEnabled:YES];
   // [self.view addSubview:_collectionView];
    
   
    
    if (!_picArray) {
        _picArray = [[NSMutableArray alloc]init];
    }
    if (!_colDic) {
        _colDic = [[NSMutableDictionary alloc]init];
    }
    if (!_colArr_0) {
        _colArr_0 = [[NSMutableArray alloc]init];
    }
    if (!_colArr_1) {
        _colArr_1 = [[NSMutableArray alloc]init];
    }
    if (!_colArr_2) {
        _colArr_2 = [[NSMutableArray alloc]init];
    }
    if (!_colArr_3) {
        _colArr_3 = [[NSMutableArray alloc]init];
    }
    if (!_colArr_4) {
        _colArr_4 = [[NSMutableArray alloc]init];
    }
    if (!_colArr_5) {
        _colArr_5 = [[NSMutableArray alloc]init];
    }
}


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headerKeyArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{


    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, ZZ_VW, 60);
    headerView.backgroundColor = [UIColor grayColor];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellitem_bg"]];
    backImageView.frame = headerView.frame;
    [headerView addSubview:backImageView];
    
    UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    albumBtn.frame = CGRectMake(0, 10, 45, 40);
    //albumBtn.backgroundColor = [UIColor redColor];
    [albumBtn setImage:[UIImage imageNamed:@"photo_ablum"] forState:normal];
    [albumBtn addTarget:self action:@selector(albumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    albumBtn.tag = section;
    //判断是否为已办
    if ([_vMode isEqualToString:@"1"]) {
        [headerView addSubview:albumBtn];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
    {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(55, 10, 45, 40);
    //photoBtn.backgroundColor = [UIColor blueColor];
    [photoBtn setImage:[UIImage imageNamed:@"photo"] forState:normal];
    photoBtn.tag = section;
    [photoBtn addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([_vMode isEqualToString:@"1"]) {
         [headerView addSubview:photoBtn];
    }
   


    UILabel *classLabel = [[UILabel alloc]init];
    classLabel.frame = CGRectMake(110, 10, 100, 40);
    SyImageClassModel *classModel = self.headerKeyArray[section];
    classLabel.text = classModel.className;
    [headerView addSubview:classLabel];

    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    if(cell)
    {
        return cell.frame.size.height;
    }
    return 50;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    /*
     * 1
     */

//    NSString *reuseIdentifier = @"cell";
//    DZImageTableViewCell *cell = (DZImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    
//    if (cell == nil) {
//        cell = [[DZImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//    }
    
    
    /*
     * 2
     */
//    
//    DZImageTableViewCell *cell = [[DZImageTableViewCell alloc]initWithType:1];
//
//    
//   SyImageClassModel *classModel = self.headerKeyArray[indexPath.section];
//   NSMutableArray *imageArray=[_dataInfoDict objectForKey:classModel.classID];
//
//    if (imageArray) {
//        cell.infoArr = imageArray;
//        
//        }
//    
    
    /*
     * 3
     */
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: reuseIdentifier];
    }
   
        [self makeCellView:cell withSection:section withRows:row withCellHeight:50];
   
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
}

#pragma mark - 添加图片按钮

- (void)FMDBPhotoAction:(id)sender
{
   
    [self getData];


}


-(void)albumBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    ZZPhotoController *photoController = [[ZZPhotoController alloc]init];
    photoController.selectPhotoOfMax = 8;
    //设置相册中完成按钮旁边小圆点颜色。
    // photoController.roundColor = [UIColor greenColor];
    
    SyImageClassModel *classModel=(SyImageClassModel *)[self.headerKeyArray objectAtIndex:btn.tag];
    NSMutableArray *imageArray=[self.dataInfoDict objectForKey:classModel.classID];
    if (!imageArray) {
        imageArray=[[NSMutableArray alloc] init];
    }

    
    [photoController showIn:self result:^(id responseObject){
        
       
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"001" forKey:@"fmdb"];
        
        NSArray *array = (NSArray *)responseObject;
        
          NSMutableArray *muArr = [[NSMutableArray alloc]init];
        if (array.count != 0) {
            
            
            if ([array[0] isKindOfClass:[ZZPhoto class]]) {
                
                for (ZZPhoto *photo in array) {
                    NSData *data = [self shapeWithImageData:nil image:photo.originImage];
                    [muArr addObject:data];
                    
                    NSInteger dataCount=[imageArray count];
                    SyImageModel *tmpModel=[[SyImageModel alloc] init];
                    tmpModel.isLocalPhoto=true;
                    tmpModel.localImage=[UIImage imageWithData:data];
                    tmpModel.thumbImage = [self imageWithImageSimple:[UIImage imageWithData:data] scaledToSize:CGSizeZero];
                    tmpModel.classID=classModel.classID;
                    //tmpModel.url = assetURL;
                    tmpModel.imageObjKey=[NSString stringWithFormat:@"%ld",(long)dataCount];
                    
                    [self addImageWithName:classModel.classID classId:dataCount type:tmpModel.imageObjKey avtar:data];
                    /**
                     *yyp 170209
                     */
                    NSString *numStr = [NSString stringWithFormat:@"%@Num",tmpModel.classID];
                    NSString *num = [self.dataInfoDict objectForKey:numStr];
                    
                    NSInteger IDNum = [num integerValue];
                    
                    tmpModel.num = IDNum + 1;
                    
                    [imageArray addObject:tmpModel];
                    
                    NSString *finalNum = [NSString stringWithFormat:@"%lu",(unsigned long)tmpModel.num];
                    [_dataInfoDict setObject:finalNum forKey:numStr];
                    
                    //////////////////////
                    
                    [_dataInfoDict setObject:imageArray forKey:classModel.classID];
                    
                }
            }
            
                       [_tableView reloadData];
        }
        
    }];
    
}

-(void)photoBtnAction:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    ZZCameraController *cameraController = [[ZZCameraController alloc]init];
    cameraController.takePhotoOfMax = 8;
    
    cameraController.isSaveLocal = NO;
    
    SyImageClassModel *classModel=(SyImageClassModel *)[self.headerKeyArray objectAtIndex:btn.tag];
    NSMutableArray *imageArray=[self.dataInfoDict objectForKey:classModel.classID];
    if (!imageArray) {
        imageArray=[[NSMutableArray alloc] init];
    }

    [cameraController showIn:self result:^(id responseObject){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"001" forKey:@"fmdb"];

        
        NSLog(@"%@",responseObject);
        NSArray *array = (NSArray *)responseObject;
 
        NSMutableArray *muArr = [[NSMutableArray alloc]init];

        
    if (array.count != 0) {
        if ([array[0] isKindOfClass:[ZZCamera class]]){
            for (ZZCamera *camera in array) {
                NSData *data = [self shapeWithImageData:camera.imageData image:nil];
                [muArr addObject:data];
               
                NSInteger dataCount=[imageArray count];
                SyImageModel *tmpModel=[[SyImageModel alloc] init];
                tmpModel.isLocalPhoto=true;
                tmpModel.localImage=[UIImage imageWithData:data];
                tmpModel.thumbImage = [self imageWithImageSimple:[UIImage imageWithData:data] scaledToSize:CGSizeZero];
                tmpModel.classID=classModel.classID;
                //tmpModel.url = assetURL;
                tmpModel.imageObjKey=[NSString stringWithFormat:@"%ld",(long)dataCount];
                
                
                 [self addImageWithName:classModel.classID classId:dataCount type:@"1" avtar:data];
                /**
                 *yyp 170209
                 */
                NSString *numStr = [NSString stringWithFormat:@"%@Num",tmpModel.classID];
                NSString *num = [self.dataInfoDict objectForKey:numStr];
                
                NSInteger IDNum = [num integerValue];
                
                tmpModel.num = IDNum + 1;
                
                [imageArray addObject:tmpModel];
                
                NSString *finalNum = [NSString stringWithFormat:@"%lu",(unsigned long)tmpModel.num];
                [_dataInfoDict setObject:finalNum forKey:numStr];
                
                //////////////////////
                
                [_dataInfoDict setObject:imageArray forKey:classModel.classID];

                
                
                
            }
        
        
        }
        
        
      
        [_tableView reloadData];
        }
    }];


    
//    
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        return;
//    }
//    UIButton *btn=(UIButton*)sender;
//    NSInteger tag=btn.tag;
//    NSInteger headerIndex=tag;
//  _currentSelIndex=headerIndex;
//    
//    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
//    picker.delegate=self;
//    //picker.allowsImageEditing=YES;
//    
//    //照相
//    //_isTakePhoto=true;
//    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//    picker.showsCameraControls=TRUE;
//    
//    [self presentViewController:picker animated:YES completion:nil];
    
    

}

#pragma mark - imagepickercontrollerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    UIImage *fImage = [self shapeWithImageData:nil image:portraitImg];
//    
//    SyImageClassModel *classModel=(SyImageClassModel *)[self.headerKeyArray objectAtIndex:_currentSelIndex];
//    NSMutableArray *imageArray=[self.dataInfoDict objectForKey:classModel.classID];
//    if (!imageArray) {
//        imageArray=[[NSMutableArray alloc] init];
//    }
//    
//
//    
//    
//    
//        unsigned long dataCount=[imageArray count];
//        SyImageModel *tmpModel=[[SyImageModel alloc] init];
//        tmpModel.isLocalPhoto=true;
//        tmpModel.localImage=fImage;
//        tmpModel.classID=classModel.classID;
//        //tmpModel.url = assetURL;
//        tmpModel.imageObjKey=[NSString stringWithFormat:@"%ld",dataCount];
//        /**
//         *yyp 170209
//         */
//        NSString *numStr = [NSString stringWithFormat:@"%@Num",tmpModel.classID];
//        NSString *num = [self.dataInfoDict objectForKey:numStr];
//        
//        NSInteger IDNum = [num integerValue];
//        
//        tmpModel.num = IDNum + 1;
//        
//        [imageArray addObject:tmpModel];
//        
//        NSString *finalNum = [NSString stringWithFormat:@"%lu",(unsigned long)tmpModel.num];
//        [self.dataInfoDict setObject:finalNum forKey:numStr];
//        
//        //////////////////////
//        
//        [self.dataInfoDict setObject:imageArray forKey:classModel.classID];
//        [_tableView reloadData];
//        
//        
//
//    /////////////////////////////////
//    
//    
//    
//    //闪一下后继续拍照
//    
//    // [picker dismissModalViewControllerAnimated:YES];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    _isTakePhoto=true;
//    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//    picker.showsCameraControls=TRUE;
//    
//    [self presentViewController:picker animated:YES completion:nil];
//    //    [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
//    
//    
//    //    });
//    
}




#pragma mark - 通知
-(void)loadNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DealNotifyImageUpload_Success:)
                                                 name:kNotify_Image_Upload_Success
                                               object:nil
     ];
}

//处理通知结果
-(void)DealNotifyImageUpload_Success:(NSNotification *)notification
{
    SyImageModel *imageModel=(SyImageModel *)notification.object;
    if(!imageModel)
    {
        return;
    }
    NSString *classID=imageModel.classID;
    NSMutableArray *imageArray=[self.dataInfoDict objectForKey:classID];
    for (SyImageModel *tmpModel in imageArray) {
        if ([tmpModel.imageObjKey isEqualToString:imageModel.imageObjKey]) {
            tmpModel.isLocalPhoto=false;
            
        }
    }
    [_tableView reloadData];
}




#pragma mark - 裁剪和加水印

//裁剪
- ( UIImage *)imageWithImageSimple:( UIImage *)image scaledToSize:( CGSize )newSize

{
    
    newSize = CGSizeMake(150, 100);
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


- (NSData *)shapeWithImageData:(NSData *)imageData image:(UIImage *)image
{
    UIImage *portraitImg = nil;
    if (imageData) {
       portraitImg = [UIImage imageWithData:imageData];

    }
    else
    {
    portraitImg = image;
    
    }
        
    
  /*
   * 裁剪
   */
    
        CGFloat btWidth = 0.0f;
        CGFloat btHeight = 0.0f;
        if (portraitImg.size.width > portraitImg.size.height) {
            btHeight = dMaxHeight;
            btWidth = portraitImg.size.width * (dMaxHeight / portraitImg.size.height);
        } else {
            btWidth = dMaxHeight;
            btHeight = portraitImg.size.height * (dMaxHeight / portraitImg.size.width);
        }
        CGSize targetSize = CGSizeMake(btWidth, btHeight);
    
        UIImage *newImage = nil;
        CGSize imageSize = portraitImg.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = targetSize.width;
        CGFloat targetHeight = targetSize.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;
        CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
        if (CGSizeEqualToSize(imageSize, targetSize) == NO)
        {
            CGFloat widthFactor = targetWidth / width;
            CGFloat heightFactor = targetHeight / height;
    
            if (widthFactor > heightFactor)
                scaleFactor = widthFactor; // scale to fit height
            else
                scaleFactor = heightFactor; // scale to fit width
            scaledWidth  = width * scaleFactor;
            scaledHeight = height * scaleFactor;
    
            // center the image
            if (widthFactor > heightFactor)
            {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }
            else
                if (widthFactor < heightFactor)
                {
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
                }
        }
//    targetSize = CGSizeMake(1024, 768);
        UIGraphicsBeginImageContext(targetSize); // this will crop
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width  = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
    
        [portraitImg drawInRect:thumbnailRect];
    
        //newImage = UIGraphicsGetImageFromCurrentImageContext();
        CGContextRef nContext = UIGraphicsGetCurrentContext();
        CGImageRef nImage = CGBitmapContextCreateImage(nContext);
    
        newImage = [UIImage imageWithCGImage:nImage];
        CGImageRelease(nImage);
    
        if(newImage == nil) NSLog(@"could not scale image");
    
    
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    
    
    
    
      /*
       *加水印
       */
    
            UIImage *waterImage = nil;
            if(1)
            {
                NSDateFormatter *df=[[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *nowDateStr=[df stringFromDate:[NSDate date]];
//                if (_timeIsReady) {
//                    nowDateStr=_currentTime;
//                }
                NSString *addressInfo=@"暂时未知";
                if(_locationStr)
                {
                    addressInfo=_locationStr;
                }
              
    
                //////////////////////////
    
                //上下文的大小
                int w = newImage.size.width;
                int h = newImage.size.height;
    
                UIFont *font = [UIFont fontWithName:@"Helvetica" size:25];
    
                CGSize destSize;
                destSize.width=w;
                destSize.height=h;
                UIGraphicsBeginImageContext(destSize);
                [newImage drawInRect:CGRectMake(0,0,newImage.size.width,newImage.size.height)];
                [[UIColor whiteColor] set];
                //看谁长
                CGSize fontSize=[addressInfo sizeWithAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName : [UIColor redColor]}];
                CGSize fontSizetime=[nowDateStr sizeWithAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName : [UIColor redColor]}];
                if(fontSizetime.width >fontSize.width){
                    fontSize.width = fontSizetime.width;
                }
                if (imageData) {
                float tmpY=h-10.0f-fontSize.height;
       
                [addressInfo drawAtPoint:CGPointMake(w-fontSize.width-10.0f,tmpY) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
                tmpY=tmpY-5.0f-fontSize.height;
                [nowDateStr drawAtPoint:CGPointMake(w-fontSize.width-10.0f,tmpY) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName : [UIColor whiteColor]}];
                }
                else
                {
                    fontSize = CGSizeZero;
                
                }
 
                CGContextRef rContext = UIGraphicsGetCurrentContext();
                CGImageRef rImage = CGBitmapContextCreateImage(rContext);
                UIImage *resultImage = [UIImage imageWithCGImage:rImage];
                CGImageRelease(rImage);
               
                UIGraphicsEndImageContext();
    
                //logo
                //
                UIImage *logoImage = [UIImage imageNamed:@"zhbx_water"];
                int logoWidth = logoImage.size.width +8;
                int logoHeight = logoImage.size.height +8;
    
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                //create a graphic context with CGBitmapContextCreate
                
                CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
                CGContextDrawImage(context, CGRectMake(0, 0, w, h), resultImage.CGImage);
                CGContextDrawImage(context, CGRectMake(w-logoWidth-20.0-fontSize.width, 15.0f, logoWidth, logoHeight), [logoImage CGImage]);
                CGImageRef imageMasked = CGBitmapContextCreateImage(context);
                CGContextRelease(context);
                CGColorSpaceRelease(colorSpace);
                resultImage = [UIImage imageWithCGImage:imageMasked];
                CGImageRelease(imageMasked);
                waterImage = resultImage;
         
        }
    
    
    
    return UIImageJPEGRepresentation(waterImage, 0.8);
   // return waterImage;
}


#pragma mark - appGroups


#pragma mark - 处理跳转过来的数据
- (void)handleHeaderInfoWithStr:(NSString *)str
{
   

    
    NSArray *arr_0 = [str componentsSeparatedByString:@"?"];
    NSString *str_0 = [arr_0 lastObject];
    
    NSArray *arr_1 = [str_0 componentsSeparatedByString:@","];
    if (arr_1.count == 0) {
        return;
    }
    _pType = @"1";
    _cID = [[arr_1[0] componentsSeparatedByString:@"="] lastObject];
    _claZZ = [[arr_1[1] componentsSeparatedByString:@"="] lastObject];
    _param = [[arr_1[2] componentsSeparatedByString:@"="] lastObject];
    _vMode = [[arr_1[3] componentsSeparatedByString:@"="] lastObject];
    _address = [[arr_1[4] componentsSeparatedByString:@"="] lastObject];
    _uuid = [[arr_1[5] componentsSeparatedByString:@"="] lastObject];
    NSArray *arr_2 = [_param componentsSeparatedByString:@"|"];
    
    _teamName = arr_2[2];
    _paramENName = arr_2[0];
    _paramCNName = arr_2[1];
    _paramPriName = arr_2[2];
    
}

#pragma mark - colection
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{


    return 0;
}


#pragma mark - 获取位置


//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // 总是授权
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *message = nil;

    if ([error code] == kCLErrorDenied) {
       NSLog(@"访问被拒绝");
        message = @"访问被拒绝";
            }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
        message = @"无法获取位置信息";
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.thoroughfare;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            _locationStr = city;
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}


#pragma mark - Network
/*
 *获取一个协同下面所有的栏目及栏目中的图片
 *id	    文件ID	        String	对应表单的SummaryID
 *name	    表单扩展定义字段	String	对应表单设计中的参数配置
 *teamname	组名称	        String	设计中配置的组名称
 */
- (void)requestEnums
{
    AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [aDelegate sharedHTTPSession];
    
    NSString *URL = [NSString stringWithFormat:@"http://%@/seeyon/filehtp.do?",_address];
    
    NSDictionary *parameters = @{@"method":@"getEnumsByName",@"id":_cID,@"name":_param,@"teamname":_teamName};
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        
        
        
        self.headerKeyArray=[[NSMutableArray alloc] init];
        
        MPageData *pageData = [[MPageData alloc]init];
        pageData.dataList = [responseObject objectForKey:@"dataList"];
        
        for (NSDictionary *dict in pageData.dataList) {
            
            SyImageClassModel *tmpClass=[[SyImageClassModel alloc] init];
            tmpClass.classID=(NSString *)[dict objectForKey:@"enumid"];
            tmpClass.className=(NSString *)[dict objectForKey:@"enums"];
            [self.headerKeyArray addObject:tmpClass];
            
            
            NSMutableArray *imageArray=[[NSMutableArray alloc] init];
            
            MPageData *pictureData = [[MPageData alloc]init];
            pictureData.classType = [[dict objectForKey:@"pictures"] objectForKey:@"classType"];
            pictureData.dataList = [[dict objectForKey:@"pictures"] objectForKey:@"dataList"];
            
            pictureData.total = [[[dict objectForKey:@"pictures"] objectForKey:@"total"]integerValue];
            
            NSLog(@"%@",[[dict objectForKey:@"pictures"] objectForKey:@"total"]);
            
            if(pictureData && pictureData.total > 0)
            {
                for (NSDictionary *tmpAttachment in pictureData.dataList) {
                    unsigned long dataCount=[imageArray count];
                    SyImageModel *tmpModel=[[SyImageModel alloc] init];
                    tmpModel.isLocalPhoto=false;
                    tmpModel.remoteAttchment=[[MAttachment alloc]initWithDic:tmpAttachment];
                    tmpModel.classID=tmpClass.classID;
                    tmpModel.imageObjKey=[NSString stringWithFormat:@"%ld",dataCount];
                    [imageArray addObject:tmpModel];
                   
                }
            }
            
            [_dataInfoDict setObject:imageArray forKey:tmpClass.classID];
            
            
            ////////////////////////yyp 170209
            NSString *numStr = [NSString stringWithFormat:@"%@Num",tmpClass.classID];
            NSString *num = [NSString stringWithFormat:@"%lu",(unsigned long)imageArray.count];
            [_dataInfoDict setObject:num forKey:numStr];
            
            ////////////////////////
            
        }
        
        if (self.headerKeyArray.count ) {
            for (int i = 0; i < self.headerKeyArray.count; i++) {
            }
         
            
           [_tableView reloadData];
                   }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure");
        
    }];


}


- (void)upupupup
{
    
    UIImage *image = [UIImage imageNamed:@"zzicon.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 1);

    
     NSString *base =  [data base64EncodedStringWithOptions:0];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URL = [NSString stringWithFormat:@"http://%@/seeyon/filehtp.do?method=uploadFiles&extensions=jpg&type=0&applicationCategory=1",_address];
    
    NSDictionary *parameters = @{@"fileID":@"908BF41D-6D93-4E75-AFFF-FDB3DA0ED10E",@"filePath":base};
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure");
        
    }];


    
    
//    //1。创建管理者对象
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    //2.上传文件
//    NSDictionary *dict = @{@"fileID":@"908BF41D-6D93-4E75-AFFF-FDB3DA0ED10E"};
//    
//    NSString *urlString = @"http://192.168.0.211/seeyon/filehtp.do?method=uploadFiles&extensions=jpg&type=0&applicationCategory=1";
//    
//    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        //上传文件参数
//        UIImage *iamge = [UIImage imageNamed:@"zzicon.jpg"];
//        NSData *data = UIImageJPEGRepresentation(iamge, 1);
//        
//       
//        //这个就是参数
//        [formData appendPartWithFileData:data name:@"file" fileName:@"123.jpg" mimeType:@"image/jpg"];
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        //打印下上传进度
//        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        //请求成功
//        NSLog(@"请求成功：%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        //请求失败
//        NSLog(@"请求失败：%@",error);
//    }];
//    
//
//
}

- (void)doSomeNetworkDownloadWork
{
    NSInteger a = 0;
    
    
    
    for (SyImageClassModel *model in self.headerKeyArray) {
        
        NSArray *mArr = [_dataInfoDict objectForKey:model.classID];
        
        for (SyImageModel *iModel in mArr) {
            
            MAttachment *attach = iModel.remoteAttchment;
            NSLog(@"%lld",attach.attID);
            
            NSString *urlStr = [NSString stringWithFormat:@"http://%@/seeyon/filehtp.do?method=fileDownload&token=&fileId=%lld",_address,attach.attID];
            
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
            
            if (thumbnailImage) {
                
                a++;
                NSLog(@"已有%ld",(long)a);
                 [_colArr_0 addObject:thumbnailImage];
            }
            else{
                
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                
                [manager.imageDownloader downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                   
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    
                    NSLog(@"+1");
                    [_colArr_0 addObject:image];
                }];
                
            }
        }
    }
    
    if (_colArr_0.count == 43  ) {
        [_tableView reloadData];
    }
}
#pragma mark - FMDB

- (void) createDB {
    
    //数据库在沙盒中的路径
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(13, 1, 1)lastObject]stringByAppendingPathComponent:@"zhPhotoOfFMDB.sqlite"];
    NSLog(@"%@",fileName);
    
    _dbPath = fileName;
    //创建数据库
    self.queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
       
    
}

//创建表
- (void) createTable {
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            BOOL createTable = [db executeUpdate:@"create table if not exists zh_pOfFMDB (name text, classId integer, type text,image blob)"];
            if (createTable) {
                NSLog(@"创建表成功");
            }
            else{
                NSLog(@"创建表失败");
            }
        }
        
        [db close];
    }];
}
//插入数据
- (void) addImageWithName:(NSString *)name classId:(NSInteger) classId type:(NSString *)type avtar:(NSData*)data{
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            BOOL flag = [db executeUpdate:@"insert into zh_pOfFMDB (name,classId,type,image) values(?,?,?,?)",name,@(classId),type,data];
            
            if (flag) {
                NSLog(@"插入成功");
            }else{
                NSLog(@"插入失败");
            }
            
            
        }
        [db close];
    }];
}
//删除数据
- (void) deleteTable
{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            BOOL success =  [db executeUpdate:@"DELETE FROM zh_pOfFMDB"];
            
            if (success) {
                NSLog(@"删除成功");
            }else{
                
                
            }
        }
    }];
    
    
}
//获取数据
- (void) getData {
    
    
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            //返回查询数据的结果集
            
            FMResultSet * resultSet = [db executeQuery:@"select * from zh_pOfFMDB"];
            
            //查询表中的每一个记录
            
            while ([resultSet next]) {
                
                
              
                NSString *classID = [resultSet stringForColumn:@"name"];
                NSData * data = [resultSet dataForColumn:@"image"];
              
                NSMutableArray *muArr = [[NSMutableArray alloc]init];

                
                NSMutableArray *imageArray=[self.dataInfoDict objectForKey:classID];
                if (!imageArray) {
                    imageArray=[[NSMutableArray alloc] init];
                }

                
               [muArr addObject:data];
                
                NSInteger dataCount=[imageArray count];
                SyImageModel *tmpModel=[[SyImageModel alloc] init];
                tmpModel.isLocalPhoto=true;
                tmpModel.localImage=[UIImage imageWithData:data];
                tmpModel.thumbImage = [self imageWithImageSimple:[UIImage imageWithData:data] scaledToSize:CGSizeZero];
                tmpModel.classID=classID;
                
                tmpModel.imageObjKey=[NSString stringWithFormat:@"%ld",dataCount];
                /**
                 *yyp 170209
                 */
                NSString *numStr = [NSString stringWithFormat:@"%@Num",tmpModel.classID];
                NSString *num = [self.dataInfoDict objectForKey:numStr];
                
                NSInteger IDNum = [num integerValue];
                
                tmpModel.num = IDNum + 1;
                
                [imageArray addObject:tmpModel];
                
                NSString *finalNum = [NSString stringWithFormat:@"%lu",(unsigned long)tmpModel.num];
                [_dataInfoDict setObject:finalNum forKey:numStr];
                
                //////////////////////
                
                [_dataInfoDict setObject:imageArray forKey:classID];
                
            }
        
        }
        [db close];
    }];
    
     [_tableView reloadData];
}



#pragma mark - 图片在cell上的显示
-(void)makeCellView:(UITableViewCell *)cell withSection:(NSInteger)section withRows:(NSInteger)row withCellHeight:(float)cellHeight
{
    for (UIView *tmpView in cell.contentView.subviews) {
        [tmpView removeFromSuperview];
    }
    cell.backgroundColor=[UIColor clearColor];
    CGRect screenRect=[[UIScreen mainScreen]bounds];
    int screenWidth=screenRect.size.width;
    
    //float leftMargin  = 5.0f;
    float contentLeftMargin=10.0f;
    float contentVMargin=5.0f;
    float currentX=0;
    float currentY=0;
    int cellCount=3;
    float picWidth=100.0f;
    float picHeight=100.0f;
    
    SyImageClassModel *classModel=(SyImageClassModel *)[self.headerKeyArray objectAtIndex:section];
    NSMutableArray *imageArray=[self.dataInfoDict objectForKey:classModel.classID];
    if (imageArray) {
        currentX=contentLeftMargin;
        currentY=contentVMargin;
        for (int i=0;i<[imageArray count];i++) {
         
                
                SyImageModel *imageModel=(SyImageModel *)[imageArray objectAtIndex:i];
            
                    MAttachment *att = imageModel.remoteAttchment;
            
            NSString *urlStr = [NSString stringWithFormat:@"http://%@/seeyon/filehtp.do?method=getPhotoThumails&id=%lld",_address,att.attID];
            

            UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.userInteractionEnabled = YES;
                    imageView.tag = 1000+section*1000+i;
            if (imageModel.thumbImage) {
                imageView.image = imageModel.thumbImage;
            }else{
               
                    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"zwPic.png"]];
                
            }
                    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageButton:)];
                    [imageView addGestureRecognizer:aTap];
                    imageView.frame = CGRectMake(currentX, currentY, picWidth,picHeight);
                    [cell.contentView addSubview:imageView];
  
            
        
        if (i%cellCount==cellCount-1) {
            currentX=contentLeftMargin;
            currentY+=contentVMargin+picHeight;
        }
        else
        {
            currentX+=contentLeftMargin+picHeight;
        }
        
    }

        if ([imageArray count]%cellCount!=0)
        {
    currentY+=contentVMargin+picHeight;

        }

    }

    else

    {
    currentX=0;
    currentY=0;

    }



//UIImage *bkImage=[UIImage imageNamed:@"zzicon.jpg"];
//bkImage=[bkImage stretchableImageWithLeftCapWidth:150 topCapHeight:15];
//UIImageView *bkImageView=[[UIImageView alloc] initWithImage:bkImage];
//bkImageView.frame=CGRectMake(leftMargin, 0, screenWidth-2*leftMargin,currentY);
//[cell.contentView insertSubview:bkImageView atIndex:0];



CGRect frame=CGRectMake(0, 0, screenWidth, currentY);
cell.frame=frame;

    }



//点击显示图片
//-(void)clickImageButton:(id)sender
//{
//   
//    
//    
//    UITapGestureRecognizer *recognizer=(UITapGestureRecognizer *)sender;
//    UIView *tmpView=recognizer.view;
//    
//   
//    NSInteger imageSection=-1;
//    NSInteger imageIndex=-1;
//    
//    UIImageView *imgObj=(UIImageView *)tmpView;
//    imageSection=(imgObj.tag-1000)/1000;
//    imageIndex=imgObj.tag%1000;
//    
//    if (imageSection<0) {
//        return;
//    }
//    
//    SyImageClassModel *classModel=(SyImageClassModel *)[self.headerKeyArray objectAtIndex:imageSection];
//    NSMutableArray *imageObjectArray=[self.dataInfoDict objectForKey:classModel.classID];
//
//    SyImageModel *iModel = imageObjectArray[imageIndex];
//    
//    
//    
//    
//    UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    backView.backgroundColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:0.9];
//    _backView = backView;
//    [self.view.window.rootViewController.view addSubview:_backView];
//    
//    
//    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    imgView.center = backView.center;
//    //要显示的图片，即要放大的图片
//    
//    
//    MAttachment *att = iModel.remoteAttchment;
//    
//    
//    NSString *urlStr = [NSString stringWithFormat:@"http://%@/seeyon/filehtp.do?method=fileDownload&token=&fileId=%lld",_address,att.attID];
//
//    
//    if (iModel.localImage) {
//        imgView.image = iModel.localImage;
//    }else{
//    
//    [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"zzicon.jpg"]];
//    }
//    
//    
//    imgView.contentMode = UIViewContentModeScaleAspectFit;
//   [backView addSubview:imgView];
//    
//    imgView.userInteractionEnabled = YES;
//    //添加点击手势（即点击图片后退出全屏）
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
//    [imgView addGestureRecognizer:tapGesture];
//    
//    
//    
// }
//


//- (void)closeView
//{
//    
//    [_backView removeFromSuperview];
//    
//}


-(void)clickImageButton:(id)sender
{

   UIScrollView* scrollView=[[UIScrollView alloc]initWithFrame:self.view.window.bounds];
    scrollView.backgroundColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:0.9];
    scrollView.maximumZoomScale=5.0;//图片的放大倍数
    scrollView.minimumZoomScale=1.0;//图片的最小倍率
    scrollView.contentSize=CGSizeMake(self.view.bounds.size.width*1.5, self.view.bounds.size.height*1.5);
    scrollView.delegate=self;
    
    
    
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.userInteractionEnabled=YES;//注意:imageView默认是不可以交互,在这里设置为可以交互
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    tap.numberOfTapsRequired=1;//单击
    tap.numberOfTouchesRequired=1;//单点触碰
    [imageView addGestureRecognizer:tap];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;//避免单击与双击冲突
    [tap requireGestureRecognizerToFail:doubleTap];
    [imageView addGestureRecognizer:doubleTap];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    _bImageView = imageView;
    [scrollView addSubview:_bImageView];
    _bScrollView = scrollView;
    [self.view.window addSubview:_bScrollView];
    
    
    UITapGestureRecognizer *recognizer=(UITapGestureRecognizer *)sender;
    
        UIView *tmpView=recognizer.view;
    
        NSInteger imageSection=-1;
        NSInteger imageIndex=-1;
    
        UIImageView *imgObj=(UIImageView *)tmpView;
        imageSection=(imgObj.tag-1000)/1000;
        imageIndex=imgObj.tag%1000;
    
        if (imageSection<0) {
            return;
        }
    
    
    
        SyImageClassModel *classModel=(SyImageClassModel *)[self.headerKeyArray objectAtIndex:imageSection];
        NSMutableArray *imageObjectArray=[self.dataInfoDict objectForKey:classModel.classID];
    
        SyImageModel *iModel = imageObjectArray[imageIndex];
    
        //要显示的图片，即要放大的图片
    
    
        MAttachment *att = iModel.remoteAttchment;
    
    
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/seeyon/filehtp.do?method=fileDownload&token=&fileId=%lld",_address,att.attID];
    
  
    
        if (iModel.localImage) {
            _bImageView.image = iModel.localImage;
        }else{
        
      [_bImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"zwPic.png"]];
           
           
        }
    
   
    
   
    



}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  //委托方法,必须设置  delegate
{
    return _bImageView;//要放大的视图
}

-(void)doubleTap:(id)sender
{
    _bScrollView.zoomScale=2.0;//双击放大到两倍
}
- (void)tapImage:(id)sender
{
    [_bScrollView removeFromSuperview];//单击图像,关闭图片详情(当前图片页面)
}






-(UIStatusBarStyle)preferredStatusBarStyle
{
   
    return UIStatusBarStyleLightContent;
    
}


#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kQuitAlertTag) {
        if (buttonIndex == 0 )
        {
            return;
        }
        else
        {
            [self deleteTable];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"002" forKey:@"fmdb"];

            
            // 替换字段名称
            NSString *formfield = _paramENName;
            formfield = [formfield stringByReplacingOccurrencesOfString :@"kczp" withString:@"field"];
            
         
            
            
            NSString *urlStr = [NSString stringWithFormat:@"zzm1://?%@_%ld",formfield,(long)_totalRemoteCount];
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            

          
            
        }
    }else if (alertView.tag == 10086){
        if (buttonIndex == 0) {
            [self deleteTable];
        }else if (buttonIndex == 1){
        
            [self getData];
        
        }else if (buttonIndex == 2){
        
        
            
        }
    
    
    
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
