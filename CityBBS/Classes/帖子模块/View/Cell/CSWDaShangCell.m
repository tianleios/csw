//
//  CSWDaShangCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDaShangCell.h"
#import "CSWDSRecord.h"
#import "UIButton+WebCache.h"
#import "CSWDaShangRecordListVC.h"

@interface CSWDaShangCell()

//@property (nonatomic, strong) UIButton *daShangBtn;
//@property (nonatomic, strong) iconView *<#name#>;
@property (nonatomic, strong) UIImageView *dsImageView;

@property (nonatomic, strong) UIImageView *encourageImageView;
@property (nonatomic, strong) UILabel *hintLbl;


@end

@implementation CSWDaShangCell


- (void)setRecordRoom:(NSArray<CSWDSRecord *> *)recordRoom {

    _recordRoom = [recordRoom copy];
    
    
    if (!recordRoom || recordRoom.count == 0) {
        //无记录
        
        [self.encourageImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.width.height.mas_equalTo(25);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.hintLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.encourageImageView.mas_right).offset(15);
            make.centerY.equalTo(self.encourageImageView.mas_centerY);
        }];
        self.hintLbl.font = FONT(15);
        
        return;
    }
    
    [self.encourageImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.hintLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.encourageImageView.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.centerY.equalTo(self.encourageImageView.mas_centerY);
    }];
    self.hintLbl.font = FONT(13);

    
    CGFloat w = SCREEN_WIDTH - 15 - 15*2 - 50;
    NSInteger count = (NSInteger) w/45;
    
    NSArray <CSWDSRecord *> *newArr;
    if (_recordRoom.count < count) {
        
        newArr = _recordRoom;
        
    } else {
    
        newArr = [_recordRoom subarrayWithRange:NSMakeRange(0, count - 1)];

    }
    
    [newArr enumerateObjectsUsingBlock:^(CSWDSRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        content_reward_more
        UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(15 + idx*45, 35, 35, 35)];
        imageView.layer.cornerRadius = imageView.height/2.0;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor backgroundColor];
        [self.contentView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[obj.photo convertImageUrl]] forState:UIControlStateNormal placeholderImage:USER_PLACEHOLDER_SMALL];
         
        if (idx == newArr.count - 1) {
            //添加更多
            
            UIButton *moreImageView = [[UIButton alloc] initWithFrame:CGRectMake(imageView.xx + 10, 35, 35, 35)];
            moreImageView.layer.cornerRadius = imageView.height/2.0;
            moreImageView.layer.masksToBounds = YES;
            [moreImageView setImage:[UIImage imageNamed:@"content_reward_more"] forState:UIControlStateNormal];
//            moreImageView.backgroundColor = [UIColor orangeColor];
            [self.contentView addSubview:moreImageView];
            [moreImageView addTarget:self action:@selector(goRecordFlow) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }];
    
}

- (void)goRecordFlow {

    
   CSWDaShangRecordListVC *recordListVC = [[CSWDaShangRecordListVC alloc] init];
   recordListVC.articleCode = self.recordRoom[0].postCode;
   [[self nextNavController] pushViewController:recordListVC animated:YES];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //
        self.dsImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.dsImageView];
        [self.dsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.mas_equalTo(50);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        self.dsImageView.image = [UIImage imageNamed:@"打赏"];
        
        //line
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.dsImageView.mas_left).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(0.7);
            make.height.equalTo(self.dsImageView.mas_height).multipliedBy(0.7);;
            
        }];
        
        //
        UIImageView *iconImageV = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageV];
        iconImageV.image = [UIImage imageNamed:@"article_ds_encourage"];
  
        
        self.encourageImageView = iconImageV;
        
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor colorWithHexString:@"#999"] font:FONT(13) textColor:[UIColor textColor]];
        [self.contentView addSubview:hintLbl];
        hintLbl.text = @"好贴就要任兴赏";
        self.hintLbl = hintLbl;
        
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(10);
        }];
        
        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageV.mas_right).offset(5);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.centerY.equalTo(iconImageV.mas_centerY);
        }];
        
        //
//        UIView *assitline = [[UIView alloc] init];
//        assitline.backgroundColor = [UIColor lineColor];
//        [self addSubview:assitline];
//        [assitline mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left);
//            make.width.equalTo(@100);
//            make.top.equalTo(iconImageV.mas_bottom);
//            make.height.equalTo(@0.5);
//        }];
    
    }
    
    return self;

}

@end
