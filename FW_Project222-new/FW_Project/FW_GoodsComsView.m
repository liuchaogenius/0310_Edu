//
//  FW_GoodsComsView.m
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_GoodsComsView.h"
#import "FW_CommentCell.h"
#import "GoodsCommentData.h"
#import "NetManager.h"

@implementation FW_GoodsComsView

@synthesize tableview;
@synthesize comsArry;
@synthesize inputToolBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        comsArry = [[NSMutableArray alloc] init];
        [self createTableView];
        [self addInputTextview];
        [self registerKeyNotify];
    }
    return self;
}

- (void)registerKeyNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createTableView
{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth(self), kViewHeight(self)-44) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableview];
}

#pragma mark inputbar delegate
-(void)inputButtonPressed:(NSString *)inputText
{
   if(inputText && inputText.length>0)
   {
       [self sendComment:inputText];
   }
}

- (void)requestComment:(NSString *)aStrid
{
    strProductID = aStrid;
    __weak FW_GoodsComsView *weakself = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:aStrid forKey:@"productId"];
    [NetManager requestWith:dict url:kCommentUrl method:@"GET"
             parameEncoding:AFJSONParameterEncoding
                       succ:^(NSDictionary *successDict) {
                           if([successDict objectForKey:@"success"])
                           {
                               GoodsCommentList *list = [GoodsCommentList unPacketCommentList:successDict];
                               [weakself.comsArry addObjectsFromArray:list.commentArry];
                               [weakself.tableview reloadData];
                               
                           }
                       }
                    failure:^(NSDictionary *failDict, NSError *error) {
                        
                    }];
}

- (void)sendComment:(NSString *)aStrCom
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:aStrCom forKey:@"comment"];
    [dict setObject:strProductID forKey:@"productId"];
    [dict setObject:[ToolUtil getIPAddress] forKey:@"userId"];
    __weak FW_GoodsComsView *weakself = self;
    [NetManager requestWith:dict url:kCommentUrl method:@"POST"
             parameEncoding:AFJSONParameterEncoding
                       succ:^(NSDictionary *successDict) {
                           if([successDict objectForKey:@"success"])
                           {
                               GoodsCommentData *data = [[GoodsCommentData alloc] init];
                               [data unPacketGoodsComment:successDict];
                               [weakself.comsArry insertObject:data atIndex:0];
                               [weakself.tableview reloadData];
                           }
                       }
                    failure:^(NSDictionary *failDict, NSError *error) {
                        [weakself.comsArry removeAllObjects];
                    }];
}

-(void) addInputTextview
{
     if(!inputToolBar)
     {
         inputToolBar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height-44, kViewWidth(self), 44)];
         inputBarRect = inputToolBar.frame;
         [self addSubview:inputToolBar];
     }
    inputToolBar.backgroundColor = [UIColor grayColor];
    inputToolBar.delegate = self;
    //    inputToolBar.textView.placeholder = @"点击进行评论";
    [inputToolBar setPlaceholder:@"点击进行评论"];
    //    inputToolBar.textView.font = [UIFont fontWithName:TBFontHei size:13];
    [inputToolBar setFont:kFontSize(12)];
    [inputToolBar setMaxLine:4];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(inputToolBar)
    {
        [inputToolBar.textview resignFirstResponder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(comsArry)
    {
        return [comsArry count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if(comsArry && indexPath.row < [comsArry count])
    {
        GoodsCommentData *data = [comsArry objectAtIndex:indexPath.row];
        height = [FW_CommentCell getHeight:data];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FW_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if(cell == nil)
    {
        cell = [[FW_CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(comsArry && indexPath.row < [comsArry count])
    {
        [cell setCommentData:[comsArry objectAtIndex:indexPath.row]];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    /* Move the toolbar to above the keyboard */
    //int height = 0;
    
    __weak FW_GoodsComsView *vc = self;
    self.inputToolBar.isFillContent = NO;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    

    CGRect frame = inputBarRect;
    ///modify tableview contentset
    //CGSize tSize = tableview.contentSize;
//    CGFloat  cellOffsetHeight = keyboardRect.size.height+self.inputToolBar.frame.size.height;
//    if(iComType == 2 && isShowKey == NO)
//    {
//        CGPoint point = tableview.contentOffset;
//        CGFloat offY = cellR.origin.y+cellR.size.height-point.y;
//        if((offY+44) > (self.view.frame.size.height-cellOffsetHeight))
//        {
//            [tableview setContentOffset:CGPointMake(0, 44+point.y+(offY-(self.view.frame.size.height-cellOffsetHeight))) animated:NO];
//            
//        }
//    }
//    if(isShowKey == NO)
//    {
//        //[tableview setContentSize:CGSizeMake(tSize.width, tSize.height+cellOffsetHeight)];
//        
//    }
    frame.origin.y += oldKeyHeight;
    frame.origin.y = inputBarRect.origin.y - keyboardRect.size.height;
    frame.origin.y+= 50;
    oldKeyHeight = keyboardRect.size.height;
    ////modify inputbar height
    
    [UIView animateWithDuration:0.3 animations:^{
        vc.inputToolBar.frame = frame;
    } completion:^(BOOL finished) {
        //if(vc.isShowKey == NO)
        {
            [vc.inputToolBar ShowSendButto:@"发布"];
        }
        //vc.isShowKey = YES;
    }];
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
    oldKeyHeight = 0;
    self.inputToolBar.isFillContent = NO;
//    if(isShowKey == YES && isShowKeyLoadData == NO)
//    {
//        //[tableview setContentSize:CGSizeMake(tSize.width, tSize.height-cellOffsetHeight)];
//    }
//    isShowKeyLoadData = NO;
    CGRect rect = CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 44);
    
    __weak FW_GoodsComsView *vc = self;
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

- (void)dealloc
{
    tableview.delegate = nil;
    tableview.dataSource = nil;
    tableview = nil;
    tableview = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
