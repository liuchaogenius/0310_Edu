//
//  UIInputToolbar.m
//  testinputBar
//
//  Created by  striveliu on 13-9-12.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "UIInputToolbar.h"
#define kTextViewWidth    248
#define kMaxStringLength  140
#define kDefaultFont  18
#define kTextViewHeight 22
#define kDefaultTextColor RGBCOLOR(146, 146, 146)
#define kInputTextColor  RGBCOLOR(51, 51, 51)
#define kTextViewOffsetY   6
#define kTextViewOffsetX    10


#define kTextInsetX 4
#define kTextInsetBottom 0

@implementation UIInputToolbar
@synthesize textview;
@synthesize sendButton;
@synthesize strSendComContent;
@synthesize delegate;
@synthesize isSendCom;
@synthesize isFillContent;
@synthesize strReplayName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        line = 1;
        retunLine = 0;
        selfOldRect = frame;
        isFillContent = NO;
        //self.backgroundColor = [UIColor whiteColor];
        [self initTextView];
    }
    return self;
}

#pragma mark  setMaxLine
- (void)setMaxLine:(int)aMaxLine
{
    iMaxLine = aMaxLine;
    [self setMaximumNumberOfLines:iMaxLine];
    [self setMinimumNumberOfLines:1];
}

#pragma mark init TextView
- (void)initTextView
{
    if(textview == nil)
    {
        textview = [[UIExpandingTextViewInternal alloc] initWithFrame:CGRectMake(kTextViewOffsetX, kTextViewOffsetY, self.frame.size.width-(kTextViewOffsetX*2), self.frame.size.height-(kTextViewOffsetY*2))];
        
        textview.textColor = kDefaultTextColor;
        textview.delegate = self;
        [self addSubview:textview];
    }
    textview.showsVerticalScrollIndicator = NO;
    textview.backgroundColor = [UIColor whiteColor];
    //[textview sizeToFit];
    textview.font = [UIFont systemFontOfSize:kDefaultFont];
    textview.textAlignment = 0;
    textview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //textview.inputView.backgroundColor = [UIColor whiteColor];
    textview.contentInset = UIEdgeInsetsMake(0, 0, 6, 0);
}

#pragma mark setPlaceholder
- (void)setPlaceholder:(NSString *)aDefaultCon
{
    textview.text = aDefaultCon;
    defaultContent = aDefaultCon;
    strSendComContent = aDefaultCon;
    textview.textColor = kDefaultTextColor;
}

#pragma mark setReplay
- (void)setReplyName:(NSString*)aDefaultCon
{
    strReplayName = aDefaultCon;
    textview.textColor = kDefaultTextColor;
}

#pragma mark setFont
- (void)setFont:(UIFont *)aFont
{
    textview.font = aFont;
    font = aFont;
}

#pragma mark setMaxheight  setminheight
-(void)setMinimumNumberOfLines:(int)m
{
    NSString *newText         = @"-";
    textview.hidden   = YES;
    NSString *saveText        = textview.text;
    for (int i = 2; i < m; ++i)
    {
        newText = [newText stringByAppendingString:@"\n|W|"];
    }
    textview.text     = newText;
    minimumHeight             = textview.contentSize.height;
    textview.text     = saveText;
    textview.hidden   = NO;
    textview.delegate = self;
    //[self sizeToFit];
}

-(void)setMaximumNumberOfLines:(int)n
{
    NSString *newText         = @"-";
    NSString *saveText        = textview.text;
    textview.hidden   = YES;
    for (int i = 2; i < n; ++i)
    {
        newText = [newText stringByAppendingString:@"\n|W|"];
    }
    textview.text     = newText;
    maximumHeight             = textview.contentSize.height;
    textview.text     = saveText;
    textview.hidden   = NO;
    textview.delegate = self;
}

#pragma mark  addLabel and removeLabel
- (void)addLabelToButton:(int)aNum
{
    if(sendButton.userInteractionEnabled == YES)
    {
        UIImage *buttonImage = [UIImage imageNamed:@"feedComButtonExBg.png"];
        //if(kSystemVersion<6.99)
        {
            buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
        }
//        else
//        {
//            buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
//        }
        [sendButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [sendButton setTitle:@"" forState:UIControlStateNormal];
    }
    if(!label1)
    {
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(sendButton.frame.origin.x+1, sendButton.frame.origin.y+1, sendButton.frame.size.width-2, sendButton.frame.size.height/2-1)];
        [self addSubview:label1];
    }
    label1.frame = CGRectMake(sendButton.frame.origin.x+1, sendButton.frame.origin.y+1, sendButton.frame.size.width-2, sendButton.frame.size.height/2-1);
    label1.hidden = NO;
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"超出";
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = RGBCOLOR(221, 221, 221);
    label1.textAlignment = UITextAlignmentCenter;
    
    if(!numLabel)
    {
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(sendButton.frame.origin.x+1,sendButton.frame.origin.y+sendButton.frame.size.height/2+1, sendButton.frame.size.width-2, sendButton.frame.size.height/2-2)];
        [self addSubview:numLabel];
    }
    numLabel.hidden = NO;
    numLabel.frame = CGRectMake(sendButton.frame.origin.x+1,sendButton.frame.origin.y+sendButton.frame.size.height/2+1, sendButton.frame.size.width-2, sendButton.frame.size.height/2-2);
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.text = [NSString stringWithFormat:@"%d",aNum];
    numLabel.font = [UIFont systemFontOfSize:20];
    numLabel.textColor = RGBCOLOR(51, 51, 51);
    numLabel.textAlignment = UITextAlignmentCenter;
    
    sendButton.userInteractionEnabled = NO;
}

- (void)setLabelFrame
{
    if(label1)
    {
        label1.frame = CGRectMake(sendButton.frame.origin.x+1, sendButton.frame.origin.y+1, sendButton.frame.size.width-2, sendButton.frame.size.height/2-1);
    }
    if(numLabel)
    {
        numLabel.frame = CGRectMake(sendButton.frame.origin.x+1,sendButton.frame.origin.y+sendButton.frame.size.height/2+1, sendButton.frame.size.width-2, sendButton.frame.size.height/2-2);
    }
}

- (void)removeLabel
{
    if(sendButton.userInteractionEnabled == NO)
    {
        UIImage *buttonImage = [UIImage imageNamed:@"feedComButtonBg.png"];
        //if(kSystemVersion<6.99)
        {
            buttonImage = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
        }
//        else
//        {
//            buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
//        }
        [sendButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        if(self.sendButtonTitle)
        {
            [sendButton setTitle:self.sendButtonTitle forState:UIControlStateNormal];
        }
        else
        {
            [sendButton setTitle:@"发布" forState:UIControlStateNormal];
        }
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if(label1)
    {
        label1.hidden = YES;
    }
    if(numLabel)
    {
        numLabel.hidden = YES;
    }
    sendButton.userInteractionEnabled = YES;
}

#pragma mark showSendButton  And hiddenSendButton
- (void)ShowSendButto:(NSString *)strTitleLabel
{
    /* Create custom send button*/
    CGRect rect = textview.frame;
    rect.size.width = kTextViewWidth;
    
    textview.frame = rect;//CGRectMake(rect.origin.x, kTextViewOffsetY, kTextViewWidth, self.frame.size.height-(kTextViewOffsetY*2));
    if(strSendComContent && strSendComContent.length > 0)
    {
        isFillContent = YES;
        textview.text = strSendComContent;
        [self textViewDidChange:textview];
    }
    UIImage *buttonImage = [UIImage imageNamed:@"feedComButtonBg.png"];
    //if(kSystemVersion<6.99)
    {
        buttonImage = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
    }
//    else
//    {
//        buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
//    }
    if(sendButton == nil)
    {
        sendButton = [[UIButton alloc] init];
        [self addSubview:sendButton];
    }
    if(sendButton.hidden == YES)
    {
        sendButton.hidden = NO;
    }
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.titleLabel.font         = [UIFont boldSystemFontOfSize:15.0f];
    //sendButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    sendButton.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    sendButton.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
    sendButton.contentMode             = UIViewContentModeScaleToFill;
    
    [sendButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [sendButton setTitle:strTitleLabel forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[[UIImage imageNamed:@"feedComButtonBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10)] forState:UIControlStateHighlighted];
    
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(inputButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [sendButton sizeToFit];
    sendButton.frame = CGRectMake(self.textview.frame.origin.x+self.textview.frame.size.width+5, self.textview.frame.origin.y-1, self.frame.size.width-(self.textview.frame.origin.x+self.textview.frame.size.width+5+5), self.textview.frame.size.height+3);
    if(textview.text.length > kMaxStringLength)
    {
        [sendButton setBackgroundImage:nil forState:UIControlStateNormal];
        [sendButton setTitle:@"" forState:UIControlStateNormal];
        [self addLabelToButton:(textview.text.length-kMaxStringLength)];
    }
    [self setNeedsDisplay];
}

- (void)HiddenSendButton:(BOOL)aIsSendCom
{
    sendButton.hidden = YES;
    
    //self.frame = selfOldRect;
    CGRect rect = CGRectMake(kTextViewOffsetX, kTextViewOffsetY, self.frame.size.width-(kTextViewOffsetX*2), self.frame.size.height-(kTextViewOffsetY*2));
    textview.frame = rect;
    if(strSendComContent && strSendComContent.length > 0)
    {
        isFillContent = YES;
        NSString *str = strSendComContent;
        strSendComContent = str;
        
        if(aIsSendCom == NO)
        {
            [textview setText:strSendComContent];
        }

        [self removeLabel];
        
    }
    [self setNeedsDisplay];
}
#pragma  delegate
- (void)inputButtonPressed
{
    isSendCom = YES;
    [self.textview resignFirstResponder];
}

#pragma mark textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"%@", textview.text);
    if([textview.text compare:defaultContent] == 0)
    {
        textview.text = @"";
    }
    if([strSendComContent compare:defaultContent] == 0)
    {
        strSendComContent = @"";
    }
    isFillContent = NO;
    textview.textColor = kInputTextColor;
    if([textView.text compare:strReplayName] == 0)
    {
        textview.textColor = kDefaultTextColor;
        textView.selectedRange = NSMakeRange(0, 0);
    }

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([strSendComContent compare:strReplayName] == 0)
    {
        strSendComContent = @"";
        textView.text = @"";
        textview.textColor = kInputTextColor;
    }
    strSendComContent = [textView.text stringByReplacingCharactersInRange:range withString:text];
    isFillContent = NO;
    if([text isEqualToString:@"\n"])
    {
        retunLine += 1;
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger newHeight = textview.contentSize.height;
    if(newHeight < minimumHeight || !textview.hasText)
    {
        newHeight = minimumHeight;
    }


    //int iline = [UIInputToolbar stringLine:font str:strSendComContent rang:(textview.frame.size.width-5)];

    //iline += retunLine;
    //if(iline != line && iline<iMaxLine && iline>0)
    {
        //if(iline > line)
        {
            //int returnHeight = retunLine*16;
            CGFloat fw = textview.frame.size.width-15;
            CGSize maxContentSize = CGSizeMake(fw, INFINITY);
            CGSize contentSize = [strSendComContent sizeWithFont:textview.font
                                               constrainedToSize:maxContentSize
                                                   lineBreakMode:0];
            int offsetHeight = contentSize.height+16;//+returnHeight;
            if(offsetHeight>maximumHeight)
            {
                textview.scrollEnabled = YES;
                offsetHeight = maximumHeight;
            }
            else
            {
                textview.scrollEnabled = NO;
            }
            if(offsetHeight < minimumHeight)
            {
                offsetHeight = minimumHeight;
            }
            CGFloat delta = offsetHeight - textview.frame.size.height;
            textview.contentInset = UIEdgeInsetsZero;
            CGRect sRect = self.frame;
            sRect.origin.y-=delta;
            sRect.size.height += delta;
            self.frame = sRect;
            
            CGRect rect = textview.frame;
            rect.size.height += delta;//sRect.size.height-kTextViewOffsetY*2;
            textview.frame = rect;
            if(isFillContent == YES)
            {
                textview.text = strSendComContent;
                if([strSendComContent compare:strReplayName] == 0)
                {
                    textView.selectedRange = NSMakeRange(0, 0);
                }
                isFillContent = NO;
            }
            
            textview.contentInset = UIEdgeInsetsMake(0, 0, 6, 0);
            CGRect sendButtonRect = sendButton.frame;
            sendButtonRect.size.height = rect.size.height+2;
            sendButton.frame = sendButtonRect;
            [self setLabelFrame];
            [self setNeedsDisplay];
        }
        
    }
    if ([strSendComContent length] <= kMaxStringLength)
    {
        [self removeLabel];
        [self setNeedsDisplay];
    }
    else
    {
        [self addLabelToButton:([strSendComContent length] - kMaxStringLength)];
        [self setNeedsDisplay];
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    strSendComContent = textView.text;
    if (isSendCom == YES && [delegate respondsToSelector:@selector(inputButtonPressed:)])
    {
        if(strReplayName && strReplayName.length > 0)
        {
            strSendComContent = [NSString stringWithFormat:@"%@%@",strReplayName, strSendComContent];
        }
        [delegate inputButtonPressed:strSendComContent];
        isSendCom = NO;
        strReplayName = nil;
        [self.textview resignFirstResponder];
        [self setPlaceholder:defaultContent];
    }
    if(!strSendComContent || strSendComContent.length == 0)
    {
        [self setPlaceholder:defaultContent];
    }
}

#pragma mark draw
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetRGBStrokeColor(context,221.0/256.0, 221.0/256.0, 221.0/256.0, 1);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextStrokePath(context);
    
    //if(!sendButton || sendButton.hidden == YES)
    {
        CGRect rect = CGRectMake(kTextViewOffsetX-2, kTextViewOffsetY-2, self.textview.frame.size.width+3, self.textview.frame.size.height+3);//self.textview.frame;
        //rect.origin.y -= 1;
       // rect.size.height += 2;
        if(sendButton && sendButton.hidden == NO)
        {
            CGContextSetRGBStrokeColor(context, 51.0/256.0, 51.0/256.0, 51.0/256.0, 1);
        }
        else
        {
            CGContextSetRGBStrokeColor(context, 221.0/256.0, 221.0/256.0, 221.0/256.0, 1);
        }
        CGContextSetLineWidth(context, 0.5f);
        CGContextMoveToPoint(context, rect.origin.x+1, rect.origin.y+1);
        CGContextAddLineToPoint(context, rect.origin.x+1, rect.origin.y+1+rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x+1+rect.size.width, rect.origin.y+1+rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x+1+rect.size.width, rect.origin.y+1);
        CGContextAddLineToPoint(context, rect.origin.x+1, rect.origin.y+1);
        
//        CGContextAddRect(context,CGRectMake(rect.origin.x+1, rect.origin.y+1,rect.size.width,rect.size.height));
        CGContextStrokePath(context);
//        CGContextSetRGBStrokeColor(context, 221.0/256.0, 221.0/256.0, 221.0/256.0, 1);
//        CGContextSetLineWidth(context, 0.5);
//        
//        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
//        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+rect.size.height);
//        CGContextAddLineToPoint(context, self.frame.size.width-rect.origin.x, rect.origin.y+rect.size.height);
//        CGContextAddLineToPoint(context, self.frame.size.width-rect.origin.x, rect.origin.y);
//        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
//        CGContextStrokePath(context);
    }
//    else if(sendButton && sendButton.hidden == NO)
//    {
//        CGRect rect = self.textview.frame;
//        rect.origin.y -= 1;
//        rect.size.height += 2;
//        CGContextSetRGBStrokeColor(context, 221.0/256.0, 221.0/256.0, 221.0/256.0, 1);
//        CGContextSetLineWidth(context, 1);
//        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
//        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+rect.size.height);
//        CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
//        CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y);
//        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
//        CGContextStrokePath(context);
//    }
}


+ (int)stringLine:(UIFont*)aFont str:(NSString*)aStr rang:(int)aWidth
{
    if(aStr == nil)
    {
        return 0;
    }
    int line = 0;
    int availableWidth=aWidth;
    float usedWidth=0;
    CGSize chSize=CGSizeZero;
    CGSize constrainedSize=CGSizeMake(aWidth, 50);
    
    int lastloopend = -1;
    NSString* content = aStr;
    
    int length = content.length;
    
    for(int iloop = 0; iloop < length; iloop++)
    {
        
        NSString* ch=[content substringWithRange:NSMakeRange(iloop, 1)];
        
        chSize = [ch sizeWithFont: aFont constrainedToSize:constrainedSize lineBreakMode:0];
        if (chSize.width+usedWidth>=availableWidth)
        {
            line++;
            lastloopend = iloop-1;
            
            iloop--;
            
            usedWidth = 0;
        }
        else
        {
            usedWidth+=chSize.width;
        }
    }
    
    line += 1;
    
    return line;
}
@end
