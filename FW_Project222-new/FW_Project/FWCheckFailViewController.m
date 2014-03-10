//
//  FWCheckFailViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-12-6.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FWCheckFailViewController.h"
#import "FW_SearchManager.h"
#import "FWAllBrandsViewController.h"
#import "FW_GoodsDetailViewController.h"

@interface FWCheckFailViewController ()
{
    UIView *headview;
    UITextField *textfield;
    NSString *strContext;
    UIView *searchview;
    CGRect searchRect;
    CGRect inputBarRect;
    int oldKeyHeight;
}
@property (nonatomic, strong)FW_SearchManager *searchManager;

@end

@implementation FWCheckFailViewController
@synthesize searchManager;
@synthesize inputToolBar;
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
//    if(kSystemVersion<6.99)
//    {
//        self.view.frame = CGRectMake(0, 0, 320, 460-44);
//    }
    if(!searchManager)
    {
        searchManager = [[FW_SearchManager alloc] init];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    if([UIScreen mainScreen].bounds.size.height>480)
    {
        headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 161)];
    }
    else
    {
        headview = [[UIView alloc] initWithFrame:CGRectMake(0, -44, 320, 161)];
    }
    headview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"checkFail_head"]];
    [self.view addSubview:headview];
    
    UILabel *labelTips = [[UILabel alloc] initWithFrame:CGRectMake(30, headview.bottom-34, 267, 34)];
    [labelTips setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkFailTipsBg@2x"]]];
    labelTips.textColor = [UIColor whiteColor];//RGBCOLOR(<#r#>, <#g#>, <#b#>)
    labelTips.text = @"别担心,小超人努力帮您解决";
    labelTips.textAlignment = 1;
    labelTips.font = [UIFont systemFontOfSize:15];
    CALayer *layer = [labelTips layer];
    layer.cornerRadius = 2;
    [self.view addSubview:labelTips];
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, headview.bottom, self.view.frame.size.width, self.view.frame.size.height-headview.bottom)];
    imgview.contentMode = UIViewContentModeScaleAspectFill;
    [imgview setImage:[UIImage imageNamed:@"checkFail_tail@2x"]];
    [self.view addSubview:imgview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgview.left+60, imgview.top+15,240, 21)];
    if([UIScreen mainScreen].bounds.size.height>480)
    {
        label.frame = CGRectMake(imgview.left+50, imgview.top+15,240, 21);
    }
    label.text = @"请谨慎购买! 没找到您扫描的商品!";
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = RGBCOLOR(51, 51, 51);
    label.textAlignment = UITextAlignmentLeft;
    [label resizeToFit];
    [self.view addSubview:label];
    
    [self addInputTextview];
    
    self.navigationItem.titleView = [ToolUtil getNavgationTitleView:@"防伪小超人" fontsize:18];
}

-(void) addInputTextview
{
    if(!inputToolBar)
    {
        inputToolBar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, kViewWidth(self.view), 44)];
        inputBarRect = inputToolBar.frame;
        [self.view addSubview:inputToolBar];
    }
    inputToolBar.backgroundColor = [UIColor grayColor];
    inputToolBar.delegate = self;
    inputToolBar.sendButtonTitle = @"搜索";
    //    inputToolBar.textView.placeholder = @"点击进行评论";
    [inputToolBar setPlaceholder:@"请输入搜索内容"];
    //    inputToolBar.textView.font = [UIFont fontWithName:TBFontHei size:13];
    [inputToolBar setFont:kFontSize(12)];
    [inputToolBar setMaxLine:4];
}

-(void)inputButtonPressed:(NSString *)inputText
{
    if(inputText && inputText.length>0)
    {
        [self sendComment:inputText];
    }
    else
    {
        [TBHint toast:@"请输入搜索的内容!" toView:self.view];
    }
}

- (void)sendComment:(NSString *)aStrCom
{
    __weak FWCheckFailViewController *weakself = self;
    if(aStrCom)
    {
        __weak FWCheckFailViewController *weakSelf = self;
        [searchManager reqSearchProduct:aStrCom result:^(NSArray *arry) {
            if(arry && [arry count] > 0)
            {
               [weakself pushAllBrandVC:arry title:aStrCom];
            }
            else
            {
                [TBHint toast:@"没找到您想要的产品!" toView:weakSelf.view];
            }
        } key:@"name"];
    }
    else
    {
        [TBHint toast:@"没找到您想要的产品!" toView:self.view];
    }
}

- (void)pushAllBrandVC:(NSArray *)arry title:(NSString *)aTitle
{
    FWAllBrandsViewController *bvc = [[FWAllBrandsViewController alloc] init];
    classAppDelegate *appDelegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
    [bvc.arry addObjectsFromArray:arry];
    bvc.viewType = e_lrViewType;
    [bvc setNavgationItemTitle:aTitle];
    //bvc.isHeadView = YES;
    //[bvc setHeadViewDesc:@"您或许想了解这些产品" height:30];
    [appDelegate.nav pushViewController:bvc animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj == inputToolBar)
        {
            [inputToolBar.textview resignFirstResponder];
        }
        //[((UIView*)obj) resignFirstResponder];
    }];
}

#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    /* Move the toolbar to above the keyboard */
    //int height = 0;
    
    __weak FWCheckFailViewController *vc = self;
    self.inputToolBar.isFillContent = NO;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    
    CGRect frame = inputBarRect;
    frame.origin.y += oldKeyHeight;
    frame.origin.y = inputBarRect.origin.y - keyboardRect.size.height;
    //frame.origin.y+= 50;
    oldKeyHeight = keyboardRect.size.height;
    ////modify inputbar height
    
    [UIView animateWithDuration:0.3 animations:^{
        vc.inputToolBar.frame = frame;
    } completion:^(BOOL finished) {
        //if(vc.isShowKey == NO)
        {
            [vc.inputToolBar ShowSendButto:@"搜索"];
        }
        //vc.isShowKey = YES;
    }];
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
    oldKeyHeight = 0;
    self.inputToolBar.isFillContent = NO;

    CGRect rect = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    
    __weak FWCheckFailViewController *vc = self;
    [UIView animateWithDuration:0.2 animations:^{
        vc.inputToolBar.frame = rect;
    } completion:^(BOOL finished) {
        if (vc.inputToolBar.isSendCom)
        {
            [vc.inputToolBar HiddenSendButton:YES];
        }
        else
        {
            [vc.inputToolBar HiddenSendButton:NO];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
