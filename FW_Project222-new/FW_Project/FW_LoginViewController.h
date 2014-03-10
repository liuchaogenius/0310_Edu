//
//  FW_LoginViewController.h
//  FW_Project
//
//  Created by  striveliu on 13-10-27.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LoginTextFieldType)
{
    LOGIN_ACCOUTNTEXTFIELD,
    LOGIN_PASSWORDTEXTFIELD,
};
@interface FW_LoginViewController : BaseViewController<UITextFieldDelegate>
{
    UITextField *accountTextField;
    UITextField *passwordTextField;
    NSString *strAccount;
    NSString *strPassword;
    UIButton *loginButton;
    UIButton *cancelButton;
}
//@property(nonatomic, copy)void(^loginSuccessBlock)(int state);
//@property(nonatomic, assign)int loginType;
//- (void)setLoginStateBlock:(void(^)(int state))aBlock;
@end
