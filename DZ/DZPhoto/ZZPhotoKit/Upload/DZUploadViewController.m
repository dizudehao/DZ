//
//  DZUploadViewController.m
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/6.
//  Copyright © 2017年 Ace. All rights reserved.
//

#define kQuitAlertTag 1001
#define kTableViewRowHeight 70
#define kNotify_Image_Upload_Success      @"kNotifyImageUploadSuccess"

#import "DZUploadViewController.h"
#import "SyImageModel.h"
#import "SyImageClassModel.h"
#import "MAttachment.h"
#import "SyAttachment.h"
#import "SyCollaborationUploadImageBizParam.h"
#import "IOSUtils.h"
#import "AFNetworking.h"
#import "MAttachmentParameter.h"
#import "SBJson5.h"
#import "AppDelegate.h"

@interface DZUploadViewController ()<UITableViewDelegate,UITableViewDataSource>
{

UIButton *_rightNavButton;

}
@property (nonatomic ,strong) dispatch_semaphore_t semaphore;
@property (nonatomic ,strong) dispatch_group_t downloadGroup;
@property (nonatomic ,assign) NSInteger iCount;
@property (nonatomic ,assign) NSInteger iCountMax;
@end

@implementation DZUploadViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self initTableData];
    [self setUpUI];
    _isStop=true;
    _isUploadOver=false;
    _overCount=0;

    _downloadGroup = dispatch_group_create();
    
    _iCount = 0;
    _iCountMax = [_dataShowArray count];
}


#pragma mark - 显示图片的数据
-(void)initTableData
{
    _dataShowArray=[[NSMutableArray alloc] init];
    for (SyImageClassModel *classModel in self.headerKeyArray) {
        NSArray *imageArray=[_dataInfoDict objectForKey:classModel.classID];
        
        
        for (SyImageModel *imageModel in imageArray) {
            
            if(imageModel.isLocalPhoto)
            {
                imageModel.imageClassModel=classModel;
                imageModel.isUpload=false;
                imageModel.uploadStatus=@"";
                [_dataShowArray addObject:imageModel];
            }
        }
    }
}


#pragma mark - navigation
- (void)setNavi
{

    self.navigationItem.title = @"";
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
                                                                      target:self action:@selector(onLeftButton)];
    [leftButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
    
   

    
    
    float btnWidth=95.0f;
    float btnHeight=30.0f;
    _rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightNavButton setFrame:CGRectMake(0, 0, btnWidth,btnHeight)];
    [_rightNavButton setTitle:@"开始上传" forState:UIControlStateNormal];
    
    _rightNavButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rightNavButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightNavButton addTarget:self action:@selector(onRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNavButton];
   self.navigationItem.rightBarButtonItem = rightButtonItem;
   

}
- (void)onLeftButton
{

    if(_isUploadOver)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *versonAlert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                              message:@"退出之后未上传完成的图片将终止上传，继续吗？"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"确定", nil];
        
        versonAlert.tag = kQuitAlertTag;
        [versonAlert show];
       
    }
}


- (void)onRightButton
{

    if(_overCount==[_dataShowArray count]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"所有图片上传完毕" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    if ([_dataShowArray count]<=0) {
        return;
    }
    if (_iCount == _iCountMax ){
        return;
    }
//    if (_isStop) {
        //当前是停止的

//        _isStop=false;
    
        _uploadBizArray=[[NSMutableArray alloc] init];
        
        SyImageModel *imageModel = [_dataShowArray objectAtIndex:_iCount];
        
        SyCollaborationUploadImageBizParam *vParam = [[SyCollaborationUploadImageBizParam alloc] init];
        vParam.moduleID = _cID;
        
        vParam.voID = imageModel.imageClassModel.classID;
        
        //////////////////yyp 070209
        
        NSString *num = [NSString stringWithFormat:@"%ld",(long)imageModel.num];
        
        NSString *paramENName = [NSString stringWithFormat:@"%@|%@",_paramENName,num];
        
        ///////////////////
        
        vParam.paramENName = paramENName;
        
        vParam.ENName = _paramENName;
        
        vParam.imageObjKey=[NSString stringWithFormat:@"%ld",(long)_iCount];
        
        vParam.num = imageModel.num;
            
        
        [_uploadBizArray addObject:vParam];
            
        
        [self didSyCollaborationUploadImageBizBizUploading:vParam];
            
        
        NSData *data = UIImageJPEGRepresentation(imageModel.localImage, 1);
                        
        
        NSString *base =  [data base64EncodedStringWithOptions:0];
            
                        
        
        [self uploadWithImage:base classId:imageModel.classID pENName:paramENName param:vParam];
    
    NSString *loadProgress = [NSString stringWithFormat:@"上传%ld/%ld",(long)_iCount,(long)_iCountMax];
    
    [_rightNavButton setTitle:loadProgress forState:UIControlStateNormal];

    _rightNavButton.enabled = NO;
    
        
//        for (int i=0;i<[_dataShowArray count]; i++)
//        {
//            SyImageModel *imageModel=[_dataShowArray objectAtIndex:i];
//            if(imageModel.isUpload)
//            {
//                continue;
//            }
//            
//            
//            
//            
//            SyCollaborationUploadImageBizParam *vParam = [[SyCollaborationUploadImageBizParam alloc] init];
//            vParam.moduleID = _cID;
//            vParam.voID = imageModel.imageClassModel.classID;
//            //////////////////yyp 070209
//            NSString *num = [NSString stringWithFormat:@"%ld",(long)imageModel.num];
//            NSString *paramENName = [NSString stringWithFormat:@"%@|%@",_paramENName,num];
//            ///////////////////
//            vParam.paramENName = paramENName;
//            vParam.ENName = _paramENName;
//            vParam.imageObjKey=[NSString stringWithFormat:@"%d",i];
//            vParam.num = imageModel.num;
//            
//            [_uploadBizArray addObject:vParam];
//            
//            [self didSyCollaborationUploadImageBizBizUploading:vParam];
//
//            NSData *data = UIImageJPEGRepresentation(imageModel.localImage, 1);
//            
//            NSString *base =  [data base64EncodedStringWithOptions:0];
//
//            
//            [self uploadWithImage:base classId:imageModel.classID pENName:paramENName param:vParam];
//            
//        }
        
//      [_rightNavButton setTitle:@"暂停" forState:UIControlStateNormal];
    
//    }
//    else
//    {
//        //当前正在传
//        _isStop=true;
//        for (int i=0;i<[_uploadBizArray count]; i++)
//        {
//         
//            
//        }
//        
//        [_rightNavButton setTitle:@"启动" forState:UIControlStateNormal];
//    }
//

}


#pragma mark - UI
- (void)setUpUI
{

    CGRect frame = self.view.bounds;
    if (_myTableView) {
        [_myTableView removeFromSuperview];
    }
    _myTableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.backgroundColor=[UIColor whiteColor];
    _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];



}

#pragma mark - tableview


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSInteger row=indexPath.row;
    if (row==0) {
        return kTableViewRowHeight+5.0f;
    }
    else{
        return kTableViewRowHeight;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return [_dataShowArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: reuseIdentifier];
    }
    [self makeCellView:cell withSection:section withRows:row withCellHeight:kTableViewRowHeight];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;

}



#pragma mark 上传状态
-(void)didSyCollaborationUploadImageBizBizUploadFail:(id)sender{
    if (!sender) {
        return;
    }
    
    @synchronized(self)
    {
        _overCount++;
    }
    
    SyCollaborationUploadImageBizParam *param=(SyCollaborationUploadImageBizParam *)sender;
    [self updateUploadStatus:param withStatus:11];
    
    @synchronized(self)
    {
        if(_overCount==[_dataShowArray count])
        {
            _isUploadOver=true;
            _isStop=true;
            _rightNavButton.enabled = YES;
            [_rightNavButton setTitle:@"开始上传" forState:UIControlStateNormal];
            
          
        }
    }
}
-(void)didSyCollaborationUploadImageBizBizUploadSuccess:(id)sender{
    if (!sender) {
        return;
    }
    @synchronized(self)
    {
        _overCount++;
    }
    
    SyCollaborationUploadImageBizParam *param=(SyCollaborationUploadImageBizParam *)sender;
    [self updateUploadStatus:param withStatus:10];
    
    //发送成功通知
    int objIndex=[param.imageObjKey intValue];
    SyImageModel *imageModel=[_dataShowArray objectAtIndex:objIndex];
    
    
    
    if(imageModel)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Image_Upload_Success object:imageModel];
    }
    
    
    @synchronized(self)
    {
        if(_overCount==[_dataShowArray count])
        {
            _isUploadOver=true;
            _isStop=true;
            _rightNavButton.enabled = YES;
            [_rightNavButton setTitle:@"上传完毕" forState:UIControlStateNormal];
           
            //updateAllNum
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"002" forKey:@"fmdb"];
            
        }
    }
    
}
-(void)didSyCollaborationUploadImageBizBizUploading:(id)sender{
    if (!sender) {
        return;
    }
    SyCollaborationUploadImageBizParam *param=(SyCollaborationUploadImageBizParam *)sender;
    [self updateUploadStatus:param withStatus:1];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


// status 1:uploading 10:Success 11:fail
-(void)updateUploadStatus:(SyCollaborationUploadImageBizParam *)param withStatus:(int)status
{
    if(!param)
    {
        return;
    }
    NSString *imageObjNo=param.imageObjKey;
    int rowIndex=[imageObjNo intValue];
    SyImageModel *imageModel=[_dataShowArray objectAtIndex:rowIndex];
    
    if(status==1)
    {
        imageModel.uploadStatus=@"上传中";
    }
    else if(status==10)
    {
        _iCount ++;
        _isStop = YES;
        [self onRightButton];
        
        imageModel.isUpload=true;
        imageModel.uploadStatus=@"上传成功";
        NSInteger selIndex=-1;
        for (int i=0; i<[_uploadBizArray count]; i++)
        {
          SyCollaborationUploadImageBizParam *sParam = [_uploadBizArray objectAtIndex:i];
            if (sParam == param) {
                selIndex=i;
                break;
            }
            
        }
        if(selIndex>=0)
        {
            
            [_uploadBizArray removeObjectAtIndex:selIndex];
        }
    }
    else if(status==11)
    {
        imageModel.isUpload=true;
        imageModel.uploadStatus=@"上传失败";
        int selIndex=-1;
        for (int i=0; i<[_uploadBizArray count]; i++)
        {
          
            SyCollaborationUploadImageBizParam *sParam = [_uploadBizArray objectAtIndex:i];
            if (sParam == param) {
                selIndex=i;
                break;
            }

        }
        if(selIndex>=0)
        {
            [_uploadBizArray removeObjectAtIndex:selIndex];
        }
    }
    [_dataShowArray replaceObjectAtIndex:rowIndex withObject:imageModel];
    NSIndexPath *refreshCell = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:refreshCell, nil] withRowAnimation:UITableViewRowAnimationNone];
}



-(void)makeCellView:(UITableViewCell *)cell withSection:(NSInteger )section withRows:(NSInteger )row withCellHeight:(float)cellHeight
{
    for (UIView *tmpView in cell.contentView.subviews) {
        [tmpView removeFromSuperview];
    }
    cell.backgroundColor=[UIColor clearColor];
    CGRect screenRect=[[UIScreen mainScreen]bounds];
    int screenWidth=screenRect.size.width;
    
    float leftMargin  = 4.0f;
    float topMargin=0.0f;
    float rowHeight=kTableViewRowHeight;
    if (row==0) {
        topMargin=5.0f;
        rowHeight=kTableViewRowHeight+5.0f;
    }
    
    NSString *bkImageName=@"cellitem_bg";
    
    UIImage *bkImage=[UIImage imageNamed:bkImageName];
    bkImage=[bkImage stretchableImageWithLeftCapWidth:150 topCapHeight:15];
    UIImageView *bkImageView=[[UIImageView alloc] initWithImage:bkImage];
    bkImageView.frame=CGRectMake(leftMargin, topMargin, screenWidth-2*leftMargin,kTableViewRowHeight);
    [cell.contentView addSubview:bkImageView];
    
//    float contentLeftMargin=10.0f;
//    float contentVMargin=5.0f;
//    int cellCount=3;
    float currentX=0;
    float currentY=0;
    float picWidth=50.0f;
    float picHeight=50.0f;
    
    SyImageModel *imageModel=[_dataShowArray objectAtIndex:row];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
    CGSize fontSize=[imageModel.imageClassModel.className sizeWithAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName : [UIColor redColor]}];
    currentX=10.0f;
    currentY=topMargin+(kTableViewRowHeight-fontSize.height)/2;
    
    UILabel *label=[IOSUtils getCustomLabelObject:imageModel.imageClassModel.className font:font textColor:[UIColor redColor] xPos:currentX yPos:currentY textAlign:NSTextAlignmentLeft];
    [cell.contentView addSubview:label];
    
    currentX=label.frame.origin.x+label.frame.size.width+10.0f;
    currentY=topMargin+(kTableViewRowHeight-picHeight)/2;
    
    if(!imageModel.isLocalPhoto)
    {
        
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lbs_default_image.png"]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 1000+row;
       

        imageView.image = imageModel.localImage;
        imageView.frame = CGRectMake(currentX, currentY, picWidth,picHeight);
        [cell.contentView addSubview:imageView];
        
        
    }
    else
    {
        UIImage *tmpImage=imageModel.localImage;
        UIImageView *imageButton = [[UIImageView alloc] initWithImage:tmpImage];
        imageButton.frame=CGRectMake(currentX, currentY, picWidth,picHeight);
        NSInteger tag=1000+row;
        imageButton.tag=tag;
        
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        [imageButton addGestureRecognizer:aTap];
        
        [cell.contentView addSubview:imageButton];
    }
    NSString *uploadStatus=@"---";
    fontSize=[@"正在上传" sizeWithAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName : [UIColor redColor]}];
    if(imageModel.uploadStatus && [imageModel.uploadStatus length]>0)
    {
        uploadStatus=imageModel.uploadStatus;
    }
    
    currentX=screenWidth-2*leftMargin-fontSize.width;
    currentY=topMargin+(kTableViewRowHeight-fontSize.height)/2;
    UILabel *statusLabel=[IOSUtils getCustomLabelObject:uploadStatus font:font textColor:[UIColor redColor] xPos:currentX yPos:currentY textAlign:NSTextAlignmentLeft];
    statusLabel.tag=10000;
    [cell.contentView addSubview:statusLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 上传
/*
*上传
*/
- (void)uploadWithImage:(NSString *)imageDataBase64 classId:(NSString *)classId pENName:(NSString *)pENName param:(SyCollaborationUploadImageBizParam *)sParam
{

    
    /*step.1
     *upload
     *返回文件信息
     */
    AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [aDelegate sharedHTTPSession];

    NSString *URL = [NSString stringWithFormat: @"http://%@/seeyon/filehtp.do?method=uploadFiles&extensions=jpg&type=0&applicationCategory=1",_address];
   
    
    NSDictionary *parameters = @{@"fileID":_uuid,@"filePath":imageDataBase64};
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSLog(@"%@",responseObject);
        
        NSMutableDictionary *mParam = [[NSMutableDictionary alloc]init];
        [mParam setObject:[responseObject objectForKey:@"id"] forKey:@"fileUrl"];
        [mParam setObject:[responseObject objectForKey:@"filename"] forKey:@"name"];
        [mParam setObject:[responseObject objectForKey:@"size"] forKey:@"size"];
        [mParam setObject:[responseObject objectForKey:@"createDate"] forKey:@"createDate"];
        [mParam setObject:[responseObject objectForKey:@"mimeType"] forKey:@"mimeType"];
        [mParam setObject:[responseObject objectForKey:@"type"] forKey:@"type"];
        NSDictionary *param = [mParam copy];
        
        
        
      [self saveAttfileWithParam:param classId:classId pENName:pENName param:sParam];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure");
        [self showAlert];
        
    }];
    

}

    
    
    /*step.2
     *saveAttFileForIos
     */
- (void)saveAttfileWithParam:(NSDictionary *)param classId:(NSString *)classId pENName:(NSString *)pENName param:(SyCollaborationUploadImageBizParam *)sParam
{
    AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [aDelegate sharedHTTPSession];
    
    
    NSString *URL = [NSString stringWithFormat:@"http://%@/seeyon/filehtp.do?method=saveAttFileForIOS",_address];
    
    NSString *jStr = [self convertToJsonData:param];
    
    NSDictionary *parameters = @{@"moduleId":_cID,@"file":jStr};
     
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"message"]) {
            NSString *aid = [responseObject objectForKey:@"message"];
            [self uploadCollaboratoinImageID:aid classId:classId pENName:pENName param:sParam];

        }else{
            [self showAlert];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure");
        [self showAlert];
        
       
    }];
    
    

}


    /*step.3
     *绑定aid  saveOneItem
     */
- (void)uploadCollaboratoinImageID:(NSString *)aId classId:(NSString *)classId pENName:(NSString *)pENName param:(SyCollaborationUploadImageBizParam *)sParam
{

    AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [aDelegate sharedHTTPSession];

    
    NSString *URL = [NSString stringWithFormat:@"http://%@/seeyon/filehtp.do?method=saveOneItem",_address];
    NSString *itemdata = [NSString stringWithFormat:@"%@|%@",classId,aId];
    
    NSDictionary *parameters = @{@"itemdata":itemdata,@"id":_cID,@"kz":pENName};

    
       [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        NSLog(@"success");
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"success"]);
        if ([[responseObject objectForKey:@"success"] isEqualToString:@"true"]) {
             [self didSyCollaborationUploadImageBizBizUploadSuccess:sParam];
        }
        else
        {
        [self didSyCollaborationUploadImageBizBizUploadFail:sParam];
            [self showAlert];
        
        }
   
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure");
        [self showAlert];
   
    }];
    
  


}






//字典转json
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
- (void)showAlert
{


    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

@end
