//
//  UIInputToolbar.h
//  testinputBar
//
//  Created by  striveliu on 13-9-12.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExpandingTextViewInternal.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]
#define kTextViewWidth    248


@protocol UIInputToolbarDelegate <NSObject>
@optional
-(void)inputButtonPressed:(NSString *)inputText;
@end

@interface UIInputToolbar : UIView<UITextViewDelegate>
{
    UILabel *label1;
    UILabel *numLabel;
    int maxHeight;
    int line;
    int iMaxLine;
    CGRect selfOldRect;
    NSString *defaultContent;
    UIFont *font;
    int retunLine;
    CGFloat maximumHeight;
    CGFloat minimumHeight;
}
@property(nonatomic, strong)NSString *strReplayName;
@property(nonatomic, assign)BOOL isFillContent;
@property(nonatomic, assign)BOOL isSendCom;
@property(nonatomic, weak)id<UIInputToolbarDelegate> delegate;
@property(nonatomic, strong)NSString *strSendComContent;
@property(nonatomic, strong)UIExpandingTextViewInternal *textview;
@property(nonatomic, strong)UIButton *sendButton;
@property(nonatomic, strong)NSString *sendButtonTitle;
////这里的行数是从1开始的 最大行数为3 该值就需要设置为4
- (void)setMaxLine:(int)aMaxLine;

- (void)HiddenSendButton:(BOOL)isSendCom;

- (void)ShowSendButto:(NSString *)strTitleLabel;

- (void)setPlaceholder:(NSString *)aStr;

- (void)setFont:(UIFont *)aFont;

- (void)setReplyName:(NSString*)aDefaultCon;
@end
