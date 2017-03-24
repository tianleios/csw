//
//  CSWSJCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWSJCell.h"

@interface CSWSJCell()

@property (nonatomic, strong) UILabel *typeLbl;

@property (nonatomic, strong) UILabel *awardLbl;

@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation CSWSJCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.typeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(14)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.typeLbl];
        
        //
        self.awardLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(14)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.awardLbl];
        
        //
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(13)
                                     textColor:[UIColor textColor2]];
        [self.contentView addSubview:self.timeLbl];
        
        
        [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.awardLbl.mas_left);
        }];
        
        [self.awardLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.contentView);
            
        }];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.greaterThanOrEqualTo(self.awardLbl.mas_right);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    
    self.typeLbl.text = @"发帖奖励";
    self.awardLbl.text = @"+4";
    self.timeLbl.text = @"2100-32-32";

    return self;
    
}

@end
