//
//  TLComposeVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLComposeVC.h"
#import "TLEmoticonInputView.h"
#import "TLComposeTextView.h"
#import "SVProgressHUD.h"
#import "TLComposeToolBar.h"
#import "TLEmoticonHelper.h"
#import "TLTextStorage.h"
#import "MLLinkLabel.h"
#import "NSString+MLExpression.h"
#import "PYPhotosView.h"
#import "TLPhotoChooseView.h"
#import "TLImagePicker.h"
#import "TLPlateChooseView.h"
//#import "TZImagePickerController.h"
#import "TLImagePickerController.h"


#define TITLE_MARGIN 10
#define TEXT_MARGIN 5

@interface TLComposeVC ()<UITextViewDelegate,TLImagePickerControllerDelegate>

@property (nonatomic, strong) TLEmoticonInputView *emoticonInputView;
@property (nonatomic, strong) TLComposeToolBar *toolBar;

@property (nonatomic, strong) TLComposeTextView *titleTextView;

@property (nonatomic, strong) TLComposeTextView *composeTextView;
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) TLPhotoChooseView *photoChooseView;
@property (nonatomic, strong) TLImagePicker *imagePicker;
@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic, strong) TLPlateChooseView *plateChooseView;

@property (nonatomic, copy) NSArray <TLPhotoChooseItem *>*replacePhotoItems;

@end

@implementation TLComposeVC
- (void)injected {

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];

}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
    //键盘通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    //背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - TOOLBAR_EFFECTIVE_HEIGHT)];
    self.bgScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.bgScrollView];
//    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 0 + 10);

    
    //板块选择
    self.navigationItem.titleView = self.titleBtn;
    [self.titleBtn addTarget:self action:@selector(changeTopic) forControlEvents:UIControlEventTouchUpInside];
    
    
    //标题栏--可变
    self.titleTextView = [[TLComposeTextView alloc] initWithFrame:CGRectMake(0, 5, self.bgScrollView.width, [FONT(18) lineHeight] + 2*TITLE_MARGIN)];
    self.titleTextView.font = FONT(18);
    self.titleTextView.placholder = @"标题";
    self.titleTextView.delegate = self;
    self.titleTextView.placeholderLbl.y = 10;
    self.titleTextView.textContainerInset = UIEdgeInsetsMake(TITLE_MARGIN, TEXT_MARGIN, TITLE_MARGIN, TEXT_MARGIN);
    [self.bgScrollView addSubview:self.titleTextView];
    
    //线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [self.bgScrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTextView.mas_bottom);
        make.left.equalTo(self.titleTextView.mas_left);
        make.width.equalTo(self.titleTextView.mas_width);
        make.height.mas_equalTo(1);
    }];

    //内容栏
    self.composeTextView.y = self.titleTextView.yy + 1;
    self.composeTextView.font = FONT(15);
    self.composeTextView.textColor = [UIColor textColor];
    self.composeTextView.textContainerInset = UIEdgeInsetsMake(TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN);
    [self.bgScrollView addSubview:self.composeTextView];
    
#pragma mark- 图片选择
    TLPhotoChooseView *photoChooseView = [[TLPhotoChooseView alloc] initWithFrame:CGRectMake(10, self.composeTextView.yy, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20)];
    self.photoChooseView = photoChooseView;
    [self.bgScrollView addSubview:photoChooseView];
    
    [photoChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.composeTextView.mas_bottom).offset(10);
        make.centerX.equalTo(self.bgScrollView.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
        make.height.mas_equalTo(SCREEN_WIDTH - 20);

    }];
    
    if (photoChooseView.yy + 20 < self.bgScrollView.height) {
        
       self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.bgScrollView.height + 20);
        
    } else {
    
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, photoChooseView.yy + 20);
    }
   
    
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
            
            
        } else if (type == ChangeTypePhoto) {
            
            //要把已经选中的图片回源，显示已经展示得图片
             TLImagePickerController *imagePickerController = [[TLImagePickerController alloc] init];
            imagePickerController.pickerDelegate = self;
            imagePickerController.replacePhotoItems = self.replacePhotoItems;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        
        } else { // At
        
        
        }
    
    };
    
#pragma mark- 板块选择
    self.plateChooseView.choosePlate = ^(NSInteger idx){
    
        
    };
    

}


- (void)imagePickerControllerDidCancel:(TLImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerController:(TLImagePickerController *)picker didFinishPickingWithImages:(NSArray <UIImage *> *)imgs chooseItems:(NSArray<TLPhotoChooseItem *> *)items{

    if (items) {
        self.replacePhotoItems = items;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (TLImagePicker *)imagePicker {

    if (!_imagePicker) {
        
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        __weak typeof(self) weakself = self;
        _imagePicker.pickFinish = ^(NSDictionary *info,UIImage *img) {
        
            UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
            [weakself.photoChooseView beginChooseWithImg:image];
            
        };
        
    }
    return _imagePicker;

}


- (void)textViewDidEndEditing:(UITextView *)textView {



}

#pragma mark-
- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView isEqual:self.titleTextView] && textView.text) {//titile
        
     CGSize size = [textView.text calculateStringSize:CGSizeMake(textView.width - 2*TEXT_MARGIN, MAXFLOAT) font:textView.font];
        
//         CGSize size = [textView sizeThatFits:CGSizeMake(textView.width - 10, MAXFLOAT)];
        
        if ((size.height + 2*TITLE_MARGIN) > ([textView.font lineHeight] + 2*TITLE_MARGIN) ) {
            
            textView.height = size.height + 2*TITLE_MARGIN;
            

        } else {
            
            textView.height = [textView.font lineHeight] + 2*TITLE_MARGIN;

        }
        self.composeTextView.y = self.titleTextView.yy + 1;
    } else {
        
        //内容
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.width - 10, MAXFLOAT)];
        if (size.height + 10 > COMPOSE_ORG_HEIGHT) {
            
            textView.height = size.height + 10;
            
        } else  {
            
            textView.height = COMPOSE_ORG_HEIGHT;
        }
    
    }
    
    if (self.composeTextView.yy + SCREEN_WIDTH - 20 > (SCREEN_HEIGHT - 64 - TOOLBAR_EFFECTIVE_HEIGHT) + 10) {
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.composeTextView.yy + SCREEN_WIDTH + 20);
    } else {
        
          self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.bgScrollView.height + 20);
    
    }
    
   
    
    
}

#pragma mark- 改变话题
- (void)changeTopic {

    //--
    if (self.plateChooseView.isShow) {
        
        [self.plateChooseView dismiss];
 
    } else {
    
        [self.plateChooseView show];

    }
    

}

#pragma mark- 发布
- (void)send {

    if (![self.composeTextView.attributedText string].length) {
        return;
    }
    NSMutableString *plainStr = [self.composeTextView.attributedText string].mutableCopy;
    
    //倒叙遍历
    [self.composeTextView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.composeTextView.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[TLTextAttachment class]]) {
            TLTextAttachment *textAttachment = (TLTextAttachment *)value;
            
            [plainStr replaceCharactersInRange:NSMakeRange(range.location, 1) withString:textAttachment.emoticon.chs];
            
        }
        
    }];
    
    //--//
//    _lbl.attributedText = [TLEmoticonHelper convertEmoticonStrToAttributedString:plainStr];
    
    
}

#pragma mark- 取消发布
- (void)cancle {
    [self.plateChooseView dismiss];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 选择图片


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
    
    if (self.titleTextView.isFirstResponder) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.toolBar.y = SCREEN_HEIGHT - TOOLBAR_EFFECTIVE_HEIGHT - 64;

        }];
        return;
    }
    
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
        TLComposeTextView *editTextView = [[TLComposeTextView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, COMPOSE_ORG_HEIGHT) textContainer:textContainer];
//        editTextView.scrollEnabled = NO;
        editTextView.keyboardType = UIKeyboardTypeTwitter;
        editTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 0, 5);
        editTextView.delegate = self;
        editTextView.font = [UIFont systemFontOfSize:15];
        editTextView.placholder = @"分享新鲜事...";
        _composeTextView = editTextView;
        
        textStorage.textView = editTextView;
    }
    
    return _composeTextView;
    
}

- (TLPlateChooseView *)plateChooseView {

    if (!_plateChooseView) {
        
        _plateChooseView = [[TLPlateChooseView alloc] init];
    }
    
    return _plateChooseView;

}

- (UIButton *)titleBtn {
    
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 30)];
        
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
        titlelbl.text = @"选择板块";
        
        //
        UIImageView *arrawView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headline_location_arrow"]];
        [_titleBtn addSubview:arrawView];
        [arrawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titlelbl.mas_right).offset(7);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(8);
            make.centerY.equalTo(titlelbl.mas_centerY);
        }];
        
    }
    return _titleBtn;
    
}


@end
