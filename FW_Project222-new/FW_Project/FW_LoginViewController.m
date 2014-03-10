//
//  FW_LoginViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-10-27.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_LoginViewController.h"

@interface FW_LoginViewController ()

@end

@implementation FW_LoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.title = @"账号登录";
    //[self addNavItemLeftButton];
    UIImage *accountImg = [UIImage imageNamed:@"input.png"];
    
    
    UIImageView *accLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 245, 32)];
    [accLeftView setImage:accountImg];
    [self.view addSubview:accLeftView];
    
    UIImage *img = [UIImage imageNamed:@"icon_email.png"];
    UIImageView *emimgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 12, 12)];
    [emimgview setImage:img];
    [accLeftView addSubview:emimgview];
    
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(74, accLeftView.frame.origin.y+4, 210, 32)];
    accountTextField.delegate = self;
    accountTextField.tag = LOGIN_ACCOUTNTEXTFIELD;
    accountTextField.returnKeyType = UIReturnKeyDone;
    accountTextField.placeholder = @"请输入账号";
    [self.view addSubview:accountTextField];
    
    UIImageView *passLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(40, accountTextField.frame.origin.y+accountTextField.frame.size.height+20, 245, 32)];
    [passLeftView setImage:accountImg];
    [self.view addSubview:passLeftView];
    
    UIImage *passimg = [UIImage imageNamed:@"icon_password.png"];
    UIImageView *passimgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 12, 12)];
    [passimgview setImage:passimg];
    [passLeftView addSubview:passimgview];
    
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(74, passLeftView.frame.origin.y+4, 210, 32)];
    passwordTextField.delegate = self;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.placeholder = @"请输入密码";
    passwordTextField.tag = LOGIN_PASSWORDTEXTFIELD;
    [self.view addSubview:passwordTextField];
    
    
    UIImage *regButImg = [[UIImage imageNamed:@"btn_red.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 4, 10, 4)];
    
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(40, passwordTextField.frame.origin.y+passwordTextField.frame.size.height+20, 245, 32)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:regButImg forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}


#pragma mark textField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField.tag == LOGIN_ACCOUTNTEXTFIELD)
    {
        strAccount = temp;
    }
    else if(textField.tag == LOGIN_PASSWORDTEXTFIELD)
    {
        
        strPassword = temp;
    }
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if(textField.tag == LOGIN_ACCOUTNTEXTFIELD)
//    {
//        //if([ToolUtil isEmail:textField.text])15858292371
//        {
//            strAccount = textField.text;
//        }
//        //else if([ToolUtil isMobile:textField.text])
//        {
//            //strAccount = textField.text;
//        }
////        else
////        {
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名必须是邮箱或者电话号码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
////            [alert show];
////            return;
////        }
//    }
//    else if(textField.tag == LOGIN_PASSWORDTEXTFIELD)
//    {
////        if(textField.text.length > 16)
////        {
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码有误" message:@"密码长度小于16位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
////            [alert show];
////            return;
////        }
////        else if(textField.text.length < 6)
////        {
////            if(textField.text.length > 16)
////            {
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码有误" message:@"密码长度至少6位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
////                [alert show];
////                return;
////            }
////        }
//        strPassword = textField.text;
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
