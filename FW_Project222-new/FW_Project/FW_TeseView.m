//
//  FW_TeseView.m
//  FW_Project
//
//  Created by  striveliu on 14-1-6.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "FW_TeseView.h"
#import "NetManager.h"
#import "GoodsTeseData.h"

@implementation FW_TeseView
@synthesize data;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self createScrollerview];
    }
    return self;
}

- (void)createScrollerview
{
    scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    scrollview.alwaysBounceVertical = YES;
    scrollview.alwaysBounceHorizontal = NO;
    [self addSubview:scrollview];
}

- (void)requestTeseData:(NSString *)aStrid
{

    __weak FW_TeseView *weakself = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:aStrid forKey:@"id"];
    [NetManager requestWith:dict url:kProductPlay_URL method:@"GET"
             parameEncoding:AFJSONParameterEncoding
                       succ:^(NSDictionary *successDict) {
                           if([successDict objectForKey:@"success"])
                           {
                               if(!weakself.data)
                               {
                                   weakself.data = [[GoodsTeseData alloc] init];
                                   [weakself.data unPacketTeseData:successDict];
                                   [weakself addContent];
                               }
                           }
                       }
                    failure:^(NSDictionary *failDict, NSError *error) {
                        
                    }];
}

- (void)addContent
{
    CGFloat height = 0;
    if(self.data.strInstructions)
    {
        if(!label1)
        {
            label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 16)];
            label1.font = [UIFont fontWithName:@"AmericanTypewriter"size:14];
            [scrollview addSubview:label1];
        }
//        int line = [ToolUtil stringLine:label1.font str:self.data.strAntifakeContent rang:290];
//        height = line *17;
//        label1.frame = CGRectMake(10, 5, 300, height);
//        label1.numberOfLines = line;
        label1.text = self.data.strInstructions;
        label1.textColor = RGBCOLOR(102, 102, 102);
        [label1 resizeToFit];
        //CGRect temRect = label1.frame;
        label1.textAlignment = 1;
//        label1.frame = CGRectMake(temRect.origin.x-5, temRect.origin.y-1, temRect.size.width+10, temRect.size.height+2);
        CALayer *layer = [label1 layer];
        layer.borderWidth = 0.5;
        layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
        if(height > scrollview.contentSize.height)
        {
            scrollview.contentSize = CGSizeMake(self.width, height);
        }
    }
    if(self.data.strAttentions)
    {
        if(!label2)
        {
            label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, label1.bottom+5, 300, 16)];
            label2.font = [UIFont fontWithName:@"AmericanTypewriter"size:14];
            [scrollview addSubview:label2];
        }
//        int line = [ToolUtil stringLine:label2.font str:self.data.strAttentions rang:290];
//        int label2Height = line *17;
//        label2.frame = CGRectMake(10, height, 300, label2Height);
//        label2.numberOfLines = line;
        label2.text = self.data.strAttentions;
        label2.textColor = RGBCOLOR(102, 102, 102);
        [label2 resizeToFit];
        label2.textAlignment = 1;
        CALayer *layer = [label2 layer];
        layer.borderWidth = 0.5;
        layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
        if((label2.bottom+5) > scrollview.contentSize.height)
        {
            scrollview.contentSize = CGSizeMake(self.width, (label2.bottom+5));
        }
    }
    if(self.data.strAntifakeContent)
    {
        if(!label3)
        {
            label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, label2.bottom+5, 300, 16)];
            label3.font = [UIFont fontWithName:@"AmericanTypewriter"size:14];
            [scrollview addSubview:label3];
        }
//        int line = [ToolUtil stringLine:label3.font str:self.data.strInstructions rang:290];
//        int label2Height = line *17;
//        label3.frame = CGRectMake(10, label2.bottom+5, 300, label2Height);
//        label3.numberOfLines = line;
        label3.text = self.data.strAntifakeContent;
        label3.textColor = RGBCOLOR(102, 102, 102);
        CALayer *layer = [label3 layer];
        layer.borderWidth = 0.5;
        layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
        [label3 resizeToFit];
        label3.textAlignment = 1;
        if((label3.bottom+5) > scrollview.contentSize.height)
        {
            scrollview.contentSize = CGSizeMake(self.width, (label3.bottom+5));
        }
    }
//    if(self.data.strProductId)
//    {
//        if(!label4)
//        {
//            label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, label3.bottom+5, 300, 16)];
//            label4.font = [UIFont fontWithName:@"AmericanTypewriter"size:14];
//            [scrollview addSubview:label4];
//        }
//        int line = [ToolUtil stringLine:label4.font str:self.data.strProductId rang:290];
//        int label2Height = line *16;
//        label4.frame = CGRectMake(10, label3.bottom+5, 300, label2Height);
//        label4.numberOfLines = line;
//        label4.text = self.data.strAttentions;
//        if((height+label2Height) > scrollview.contentSize.height)
//        {
//            scrollview.contentSize = CGSizeMake(self.width, (height+label2Height));
//        }
//    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    if(self.data)
//    {
//        if(self.data.strAntifakeContent)
//        {
//            //NSString *strUse = @"使用方式: ";
//            NSMutableArray *arry = [ToolUtil stringRangForArry:self.data.strAntifakeContent font:kFontSize(14) rangWidth:280];
//            int height = 16*[arry count];
//            if(height>self.bottom)
//            {
//                self.contentSize = CGSizeMake(self.width, height);
//            }
//            int offsetY = 10;
//            if(kSystemVersion>6.99)
//            {
//                UIColor *stringColor = RGBCOLOR(51, 51, 51);
//                NSDictionary* attrs =@{NSForegroundColorAttributeName:stringColor,
//                                       NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter"size:14],
//                                       };
////                [strUse drawInRect:CGRectMake(10, 10, ceilf([strUse sizeWithFont:[UIFont systemFontOfSize:14]].width), 17) withAttributes:attrs];
//                
//                for(NSString *content in arry) {
//                    [content drawAtPoint:CGPointMake(10, offsetY) withAttributes:attrs];
//                    offsetY += 16;
//                }
//
//            }
//            else
//            {
////                [strUse drawInRect:CGRectMake(10, 10, ceilf([strUse sizeWithFont:[UIFont systemFontOfSize:14]].width), 17) withFont:[UIFont systemFontOfSize:14]];
//                for(NSString *content in arry) {
//                    [content drawAtPoint:CGPointMake(10, offsetY) withFont:[UIFont systemFontOfSize:14]];
//                    offsetY += 16;
//                }
//            }
//        }
//    }
//}


@end
