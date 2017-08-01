//
//  DZSettingViewController.m
//  ZZPhotoKit
//
//  Created by DZ on 2017/6/14.
//  Copyright © 2017年 Ace. All rights reserved.
//
#define ScreenW self.view.bounds.size.width
#define ScrennH self.view.bounds.size.height
#define TFWidth self.view.bounds.size.width - 48
#import "DZSettingViewController.h"

@interface DZSettingViewController ()
<UITextFieldDelegate>{
    UITextField *textFieldUserName;
    UITextField *textFieldPcode;
    UITextField *textFieldUserId;
    UILabel *labelServer;
    UILabel *language;
    UILabel *userNameLabel;
    UILabel *userIdLabel;
    UILabel *pCodeLabel;
    NSUserDefaults *_defaults;
    
}

@end

@implementation DZSettingViewController

- (void)setUpUI
{
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhbx_water.png"]];
    [self.view addSubview:logoView];
    [logoView setFrame:CGRectMake(self.view.bounds.size.width/2 - 57, 80, 114, 114)];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [self.view addSubview:nameLabel];
    [nameLabel setFrame:CGRectMake(self.view.bounds.size.width/2 - 57, 80 + 114 + 15, 114, 20)];
    nameLabel.text = @"地址设置";
    nameLabel.font = [UIFont systemFontOfSize:20.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithRed:251/255.0 green:13/255.0 blue:27/255.0 alpha:1];
    CGPoint center = nameLabel.center;
    center.x = self.view.center.x;
    nameLabel.center = center;
    
}

- (void)addLineWithY:(CGFloat)y
{
    
    UILabel *line = [[UILabel alloc]init];
    [line setFrame:CGRectMake(24, y, TFWidth, 1)];
    UIColor *lineGrayColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    line.backgroundColor = lineGrayColor;
    [self.view addSubview:line];
    
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
    UIColor *TFColor = [UIColor colorWithRed:251/255.0 green:13/255.0 blue:27/255.0 alpha:1];
    //UIColor *strColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    
    if (!_defaults) {
        _defaults  = [NSUserDefaults standardUserDefaults];
    }
    
    
    CGFloat y = 80+114+15+20+15;
    
    
    textFieldUserId = [[UITextField alloc]initWithFrame:CGRectMake(68, y +17, TFWidth - 40, 24)];
    NSString *userId = [_defaults objectForKey:@"userId"];
    if (userId) {
        textFieldUserId.text = userId;
    }
    NSString *placeholderIp = [_defaults objectForKey:@"userIp"];
    if (![placeholderIp isEqualToString:@""]) {
        placeholderIp = [_defaults objectForKey:@"userIp"];
    }else{
    placeholderIp = @"ip地址";
    
    }
    textFieldUserId.placeholder = placeholderIp;
    textFieldUserId.borderStyle = UITextBorderStyleNone;
    textFieldUserId.backgroundColor = [UIColor whiteColor];
    textFieldUserId.textAlignment = NSTextAlignmentLeft;
    textFieldUserId.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textFieldUserId];
    UIImageView *image_userId = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userId.png"]];
    image_userId.frame = CGRectMake(24, y + 17 , 24, 24);
    [self.view addSubview:image_userId];
    y+=50;
    [self addLineWithY:y];
    y+=1;
    
    
    textFieldUserName = [[UITextField alloc]initWithFrame:CGRectMake(68, y + 17, TFWidth - 40, 24)];
    textFieldUserName.backgroundColor = [UIColor whiteColor];
    textFieldUserName.borderStyle = UITextBorderStyleNone;
    NSString *placeholderPort = [_defaults objectForKey:@"userPort"];
    if (![placeholderPort isEqualToString:@""]) {
        placeholderPort = [_defaults objectForKey:@"userPort"];
    }else{
        placeholderPort = @"端口地址";
    }
    textFieldUserName.placeholder = placeholderPort;
    textFieldUserName.textAlignment = NSTextAlignmentLeft;
    textFieldUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIImageView *image_userName=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userId.png"]];
    image_userName.frame = CGRectMake(24, y + 17 , 24, 24);
    [self.view addSubview:image_userName];
    
    NSString *userName = [_defaults objectForKey:@"userName"];
    if (userName) {
        textFieldUserName.text = userName;
    }
    [self.view addSubview:textFieldUserName];
    y+=50;
    [self addLineWithY:y];
    y+=1;
    
    
//    textFieldPcode = [[UITextField alloc]initWithFrame:CGRectMake(68, y +17,TFWidth-40, 24)];
//    NSString *pcode = [_defaults objectForKey:@"pcode"];
//    if (pcode) {
//        textFieldPcode.text = pcode;
//    }
//    textFieldPcode.placeholder = @"会议密码";
//    textFieldPcode.borderStyle = UITextBorderStyleNone;
//    textFieldPcode.backgroundColor = [UIColor whiteColor];
//    textFieldPcode.textAlignment = NSTextAlignmentLeft;
//    textFieldPcode.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textFieldPcode.delegate = self;
//    [self.view addSubview:textFieldPcode];
//    UIImageView *image_pcode=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pCode.png"]];
//    image_pcode.frame = CGRectMake(24, y + 17 , 24, 24);
//    [self.view addSubview:image_pcode];
//    
//    y+=50;
//    [self addLineWithY:y];
//    y+=1;
    
    y+=20;
    
    UIButton * btnEnterMeeting = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnEnterMeeting.clipsToBounds = YES;
    btnEnterMeeting.layer.cornerRadius = 15;
    [btnEnterMeeting setFrame:CGRectMake(24, y , TFWidth, 46)];
    [btnEnterMeeting setTitle:@"确定" forState:UIControlStateNormal];
    [btnEnterMeeting setTitle:@"确定" forState:UIControlStateHighlighted];
    [btnEnterMeeting setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btnEnterMeeting.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [btnEnterMeeting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnEnterMeeting setBackgroundColor:TFColor];
    [btnEnterMeeting setTitleColor:[UIColor whiteColor] forState:normal];
    [btnEnterMeeting addTarget:self action:@selector(actionEnterMeeting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEnterMeeting];
    //btnEnterMeeting.center = CGPointMake(self.view.center.x  , self.view.center.y +140 );
}



-(void)actionEnterMeeting:(UIButton *)btn{
       //保存上一次输入的参数
    if (![textFieldUserName.text isEqualToString:@""]) {
        [_defaults setObject:textFieldUserName.text forKey:@"userPort"];
    }
     if (![textFieldUserId.text isEqualToString:@""]) {
    [_defaults setObject:textFieldUserId.text forKey:@"userIp"];
     }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [textFieldPcode resignFirstResponder];
    [textFieldUserId resignFirstResponder];
    [textFieldUserName resignFirstResponder];
    
}

//输入框编辑开始时候调用
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 70 +80  - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
