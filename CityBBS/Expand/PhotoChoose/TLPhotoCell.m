//
//  TLPhotoCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLPhotoCell.h"
#import <Photos/Photos.h>
#import "TLChooseResultManager.h"

@interface TLPhotoCell()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation TLPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.photoImageView];
        self.photoImageView.clipsToBounds = YES;
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            
        }];
        
        //按钮
        self.selectedBtn = [[UIButton alloc] init];
        [self.selectedBtn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectedBtn];
        [self.selectedBtn setImage:[UIImage imageNamed:@"photo_unselected"] forState:UIControlStateNormal];
         [self.selectedBtn setImage:[UIImage imageNamed:@"photo_selected"] forState:UIControlStateSelected];
        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).offset(1);
            make.right.equalTo(self.contentView.mas_right).offset(-1);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);

        }];
        
    }
    return self;
}

- (void)choose {
    
    //将要选中，该对象。判断是否超标
    if (self.photoItem.isSelected == NO) {
        
        //超标 + 警告
        if([TLChooseResultManager manager].hasChooseItems.count >= [TLChooseResultManager manager].maxCount) {
            
            NSLog(@"最多选择9张图片");
            return;

        } else {
        
            self.photoItem.isSelected = !self.photoItem.isSelected;
            self.selectedBtn.selected = self.photoItem.isSelected;
            
            if (self.chooseHandle) {
                self.chooseHandle(self.photoItem,YES);
            }
            [[TLChooseResultManager manager].hasChooseItems addObject:self.photoItem];
        }
        
    } else {
    
        self.photoItem.isSelected = !self.photoItem.isSelected;
        self.selectedBtn.selected = self.photoItem.isSelected;
        
        if (self.chooseHandle) {
            self.chooseHandle(self.photoItem,NO);
        }
    
        [[TLChooseResultManager manager].hasChooseItems removeObject:self.photoItem];

    }

 

}

- (void)setPhotoItem:(TLPhotoChooseItem *)photoItem {

    _photoItem = photoItem;
    
    
    if (photoItem.isCamera) {
        //相机选项
        self.selectedBtn.hidden = YES;
        self.photoImageView.image = [UIImage imageNamed:@"toolbar_icon_camera"];
        self.photoImageView.contentMode = UIViewContentModeCenter;
        return;
    }
    
    self.selectedBtn.hidden = NO;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.selectedBtn.selected = _photoItem.isSelected;

    [[PHCachingImageManager defaultManager] requestImageForAsset:_photoItem.asset targetSize:_photoItem.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        self.photoImageView.image = result;
        
    }];
    

}

@end
