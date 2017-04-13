//
//  TLComposeVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWSendCommentVC.h"
#import "TLEmoticonInputView.h"
#import "TLComposeTextView.h"
#import "SVProgressHUD.h"
#import "TLComposeToolBar.h"
#import "TLEmoticonHelper.h"
#import "TLTextStorage.h"
#import "MLLinkLabel.h"
#import "NSString+MLExpression.h"

//#import "PYPhotosView.h"
//#import "TLPhotoChooseView.h"

//#import "TLImagePicker.h"
//#import "TLPlateChooseView.h"
//#import "TZImagePickerController.h"
//#import "TLImagePickerController.h"

#import "CSWSmallPlateModel.h"
//#import "QNUploadManager.h"

#define TITLE_MARGIN 10
#define TEXT_MARGIN 5

@interface CSWSendCommentVC ()<UITextViewDelegate>

@property (nonatomic, strong) TLEmoticonInputView *emoticonInputView;
@property (nonatomic, strong) TLComposeToolBar *toolBar;

@property (nonatomic, strong) TLComposeTextView *composeTextView;
@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIButton *titleBtn;//顶部板块吊起
@property (nonatomic, strong) UILabel *titleLbl;


//数据
@property (nonatomic, copy) NSArray <CSWSmallPlateModel *>*smallPlateModelRoom;

@end

@implementation CSWSendCommentVC
{
    dispatch_group_t _uploadGroup;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
    //键盘通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _uploadGroup = dispatch_group_create();
    
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    //背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - TOOLBAR_EFFECTIVE_HEIGHT)];
    self.bgScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.bgScrollView];
    //    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 0 + 10);
    
    
    //板块选择
    self.navigationItem.titleView = self.titleBtn;

    //-----//
    //内容栏
    self.composeTextView.y = 0;
    self.composeTextView.font = FONT(15);
    self.composeTextView.textColor = [UIColor textColor];
    self.composeTextView.textContainerInset = UIEdgeInsetsMake(TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN);
    [self.bgScrollView addSubview:self.composeTextView];

#pragma mark- 工具栏
    TLComposeToolBar *toolBar = [[TLComposeToolBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_EFFECTIVE_HEIGHT - 64, SCREEN_WIDTH, 0)];
    
    //解决切换 效果差
    toolBar.height = 350;
    [self.view addSubview:toolBar];
    self.toolBar  = toolBar;
    
#pragma mark- 切换工具
    __weak typeof(self) weakself = self;
    toolBar.changeType = ^(ChangeType type){
        
        if (type == ChangeTypeEmoticon) {
            
            if (!weakself.composeTextView.inputView) {
                
                weakself.composeTextView.inputView = weakself.emoticonInputView;
                [weakself.composeTextView reloadInputViews];
                [weakself.composeTextView becomeFirstResponder];
                
            } else {
                
                weakself.composeTextView.inputView = nil;
                [weakself.composeTextView reloadInputViews];
                [weakself.composeTextView becomeFirstResponder];
                
            }
            
        }  else { // At
            
            
        }
        
    };
    

 
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    
    
}

#pragma mark-
- (void)textViewDidChange:(UITextView *)textView {
    
        //内容
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.width - 10, MAXFLOAT)];
        if (size.height + 10 > COMPOSE_ORG_HEIGHT) {
            
            textView.height = size.height + 10;
            
        } else  {
            
            textView.height = COMPOSE_ORG_HEIGHT;
        }
        
    
    if (self.composeTextView.yy + SCREEN_WIDTH - 20 > (SCREEN_HEIGHT - 64 - TOOLBAR_EFFECTIVE_HEIGHT) + 10) {
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.composeTextView.yy + SCREEN_WIDTH + 20);
        
    } else {
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.bgScrollView.height + 20);
    }
    
    
}


#pragma mark- 发布
- (void)send {
    
    if (!self.toObjCode) {
        [TLAlert alertWithInfo:@"填写操作对象"];
        return;
    }
    
    if (![[self.composeTextView.attributedText string] valid]) {
        [TLProgressHUD showErrorWithStatus:@"请输入评论内容"];
        return ;
    }
    
   
    
    NSMutableString *plainStr = [self.composeTextView.attributedText string].mutableCopy;
    
    //倒叙遍历
    [self.composeTextView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.composeTextView.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[TLTextAttachment class]]) {
            TLTextAttachment *textAttachment = (TLTextAttachment *)value;
            
            [plainStr replaceCharactersInRange:NSMakeRange(range.location, 1) withString:textAttachment.emoticon.chs];
            
        }
        
    }];
    
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
//    1 帖子的评论 2 评论的评论

    http.code = @"610112";
    http.parameters[@"type"] = self.type == CSWSendCommentActionTypeToArticle  ? @"1" : @"2";
    
    http.parameters[@"content"] = plainStr;
    http.parameters[@"parentCode"] = self.toObjCode;
    http.parameters[@"commer"] = [TLUser user].userId;
    
    
    CSWCommentModel *commentModel = nil;
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    Apr 13, 2017 2:50:16 PM
    if (self.type == CSWSendCommentActionTypeToArticle) {
        
        commentModel =    [[CSWCommentModel alloc]
                           initWithCommentUserId:[TLUser user].userId
                           commentUserNickname:[TLUser user].nickname
                           commentContent:plainStr
                           parentCommentUserNickname: nil
                           commentDatetime:[dateFormatter stringFromDate:date]];
    } else {
        
        if (!self.toObjNickName) {
            [TLAlert alertWithInfo:@"填写操作对象"];
            return;
        }
//        2017-04-11 14:24:36
       
        
        commentModel =  [[CSWCommentModel alloc]
                           initWithCommentUserId: [TLUser user].userId
                           commentUserNickname: [TLUser user].nickname
                           commentContent: plainStr
                           parentCommentUserNickname: self.toObjNickName
                           commentDatetime:[dateFormatter stringFromDate:date]];
    
    }
 

    //
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithInfo:@"评论成功"];
        
        if (self.commentSuccess) {
            self.commentSuccess(commentModel);
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
     
        
    } failure:^(NSError *error) {
        
    }];

    
    
}



#pragma mark- 取消发布
- (void)cancle {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   
}


- (TLEmoticonInputView *)emoticonInputView {
    
    if (!_emoticonInputView) {
        
        TLEmoticonInputView *emoticonInputView = [TLEmoticonInputView shareView];
        
        _emoticonInputView = emoticonInputView;
        
        emoticonInputView.editAction = ^(BOOL isDelete, TLEmoticon *emoction){
            
            if (isDelete) {
                
                if (self.composeTextView.attributedText.length == 0) {
                    
                    return ;
                }
                
                [self.composeTextView deleteEmoticon:emoction];
                
                return ;
            }
            [self.composeTextView appendEmoticon:emoction];
            
        };
        
    }
    
    return _emoticonInputView;
    
}


- (void)keyboardWillAppear:(NSNotification *)notification {
    
    
    //获取键盘高度
    CGFloat duration =  [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyBoardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    

    
    [UIView animateWithDuration:duration delay:0 options: 458752 | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.toolBar.y = CGRectGetMinY(keyBoardFrame) - TOOLBAR_EFFECTIVE_HEIGHT - 64;
        
        
    } completion:NULL];
    
    
}


- (TLComposeTextView *)composeTextView {
    
    if (!_composeTextView) {
        
        //textConiter
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
        
        //layoutManager
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [layoutManager addTextContainer:textContainer];
        
        //textStorage
        TLTextStorage *textStorage = [[TLTextStorage alloc] init];
        [textStorage addLayoutManager:layoutManager];
        [textStorage setAttributedString:[[NSAttributedString alloc] init]];
        
        //
        TLComposeTextView *editTextView = [[TLComposeTextView alloc] initWithFrame:CGRectMake(0, 64 + 5, SCREEN_WIDTH, COMPOSE_ORG_HEIGHT) textContainer:textContainer];
        //        editTextView.scrollEnabled = NO;
        editTextView.keyboardType = UIKeyboardTypeTwitter;
        editTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 0, 5);
        editTextView.delegate = self;
        editTextView.font = [UIFont systemFontOfSize:15];
        editTextView.placholder = @"请输入评论内容";
        _composeTextView = editTextView;
        
        textStorage.textView = editTextView;
    }
    
    return _composeTextView;
    
}


- (UIButton *)titleBtn {
    
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 30)];
        _titleBtn.enabled = NO;
        UILabel *titlelbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(18)
                                          textColor:[UIColor whiteColor]];
        [_titleBtn addSubview:titlelbl];
        [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleBtn.mas_centerX);
            make.bottom.equalTo(_titleBtn.mas_bottom).offset(-4);
            
        }];
        titlelbl.text = @"发布评论";
        self.titleLbl = titlelbl;
        
        //
//        UIImageView *arrawView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headline_location_arrow"]];
//        [_titleBtn addSubview:arrawView];
//        [arrawView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(titlelbl.mas_right).offset(7);
//            make.width.mas_equalTo(14);
//            make.height.mas_equalTo(8);
//            make.centerY.equalTo(titlelbl.mas_centerY);
//        }];
        
    }
    return _titleBtn;
    
}


@end
