//
//  DZWelcomeViewController.m
//  ZZPhotoKit
//
//  Created by DZ on 2017/5/24.
//  Copyright © 2017年 Ace. All rights reserved.
//
#define TFWidth self.view.bounds.size.width - 48
#import "DZWelcomeViewController.h"
#import "DZSettingViewController.h"
#import "SDWebImageManager.h"

@interface DZWelcomeViewController ()

@end

@implementation DZWelcomeViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"";
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
                                                                          target:self action:@selector(onLeftButton)];
        [leftButtonItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        
        
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain
                                                                           target:self action:@selector(OnRightButton:)];
        [rightButtonItem setTintColor:[UIColor whiteColor]];
        
        
        UIBarButtonItem *rightButtonItemSec = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(OnRightButton:)];
        [rightButtonItemSec setTintColor:[UIColor whiteColor]];

        
        //NSArray *buttons = [NSArray arrayWithObjects:rightButtonItem,rightButtonItemSec, nil];
       // [self.navigationItem setRightBarButtonItems:buttons];
       self.navigationItem.rightBarButtonItem = rightButtonItemSec;
        
        
        
    }
    return self;
}

- (void)OnRightButton:(id)sender
{
    
    UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"设置" message:nil
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
    //UIAlertControllerStyleActionSheet:显示在屏幕底部
    //设置按钮
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0,0,2.0,1.0);
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
    
    
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"zzm1://" ]];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhbx_water.png"]];
    [self.view addSubview:logoView];
    [logoView setFrame:CGRectMake(self.view.bounds.size.width/2 - 57, 80, 114, 114)];

    UILabel *nameLabel = [[UILabel alloc]init];
    [self.view addSubview:nameLabel];
    [nameLabel setFrame:CGRectMake(0, 80 + 114 + 15, self.view.bounds.size.width, 20)];
    nameLabel.text = @"请从M1中进入";
    nameLabel.font = [UIFont systemFontOfSize:20.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithRed:251/255.0 green:13/255.0 blue:27/255.0 alpha:1];
    CGPoint center = nameLabel.center;
    center.x = self.view.center.x;
    nameLabel.center = center;
    
    
    UIColor *TFColor = [UIColor colorWithRed:251/255.0 green:13/255.0 blue:27/255.0 alpha:1];
    UIButton * btnEnterMeeting = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnEnterMeeting.clipsToBounds = YES;
    btnEnterMeeting.layer.cornerRadius = 15;
    [btnEnterMeeting setFrame:CGRectMake(24,80 + 114 + 15 +55 , TFWidth, 46)];
    [btnEnterMeeting setTitle:@"返回M1" forState:UIControlStateNormal];
    [btnEnterMeeting setTitle:@"返回M1" forState:UIControlStateHighlighted];
    [btnEnterMeeting setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btnEnterMeeting.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [btnEnterMeeting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnEnterMeeting setBackgroundColor:TFColor];
    [btnEnterMeeting setTitleColor:[UIColor whiteColor] forState:normal];
    [btnEnterMeeting addTarget:self action:@selector(onLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEnterMeeting];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
