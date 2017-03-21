//
//  TLPhotoChooseView.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLPhotoChooseView.h"
#import "TLPhotoChooseCell.h"
#import "TLImagePicker.h"

@interface TLPhotoChooseView()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *photoChooseCollectionView;
@property (nonatomic, strong) NSMutableArray <TLPhotoItem *>*photoRooms;
@property (nonatomic, strong) TLImagePicker *imagePicker;

@end


@implementation TLPhotoChooseView


- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        
        UIResponder *nextResponder = [self nextResponder];
        
        do {
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                break;
            }
            nextResponder = [nextResponder nextResponder];
            
        } while (1);
     
        _imagePicker = [[TLImagePicker alloc] initWithVC:(UIViewController *)nextResponder];
        __weak typeof(self) weakself = self;
        _imagePicker.pickFinish = ^(NSDictionary *info, UIImage *img) {
            
            UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
            [weakself beginChooseWithImg:image];
            
        };
        
    }
    return _imagePicker;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self photoChooseWithFrame:frame];
        self.photoRooms = [[NSMutableArray alloc] init];
        [self initData];
    }
    return self;
}


- (void)photoChooseWithFrame:(CGRect)frame {
    
    //取短边
    CGFloat w = frame.size.width > frame.size.height ? frame.size.height : frame.size.width;
    
    //布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //
    CGFloat itemWidth = (w - 2*5)/3.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
//  flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //
    UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, w, w) collectionViewLayout:flowLayout];
    photoCollectionView.backgroundColor = [UIColor backgroundColor];
    self.photoChooseCollectionView = photoCollectionView;
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    photoCollectionView.showsVerticalScrollIndicator = NO;
    photoCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:photoCollectionView];
    
    [photoCollectionView registerClass:[TLPhotoChooseCell class] forCellWithReuseIdentifier:@"photoCell"];
    
    //手势
//    UILongPressGestureRecognizer *longPresss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    longPresss.delegate = self;
//    [photoCollectionView addGestureRecognizer:longPresss];
    
}


- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    
    //问题 1.最好增加按钮不可点击,解决了主动移动该item的可能
    // 2. 增加选项，被动移动问题
    CGPoint touchPoint = [longPress locationInView:self.photoChooseCollectionView];
    NSIndexPath *indexPath = [self.photoChooseCollectionView indexPathForItemAtPoint:touchPoint];
    if (!indexPath ||self.photoRooms[indexPath.row].isAdd) {
        return;
    }
    
    UICollectionViewCell *cell = [self.photoChooseCollectionView cellForItemAtIndexPath:indexPath];
    
    //取消移动--回到原来的位置
    UIGestureRecognizerState state = longPress.state;
    
    NSLog(@"%ld",state);
    
    BOOL lastStateIsChanged = NO;
    switch (state) {
            
            //取消
        case UIGestureRecognizerStateCancelled: {
            
            cell.transform = CGAffineTransformIdentity;
            [self.photoChooseCollectionView cancelInteractiveMovement];
            
        }
            break;
            
            //结束
        case UIGestureRecognizerStateEnded: {
            
            cell.transform = CGAffineTransformIdentity;
            [self.photoChooseCollectionView endInteractiveMovement];
            
        }
            break;
            
            //开始
        case UIGestureRecognizerStateBegan: {
            
            cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
            [self.photoChooseCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            if (CGAffineTransformEqualToTransform(cell.transform,CGAffineTransformIdentity)) {
                cell.transform = CGAffineTransformMakeScale(1.2, 1.2);

            }
            lastStateIsChanged = YES;
            
#warning -此处有bug
            [self.photoChooseCollectionView updateInteractiveMovementTargetPosition:touchPoint];
            
        }
            break;
            
        case UIGestureRecognizerStateFailed: {
            [self.photoChooseCollectionView cancelInteractiveMovement];
            
        }
            break;
            
        case UIGestureRecognizerStatePossible: {
            [self.photoChooseCollectionView cancelInteractiveMovement];
            
        }
            break;
            
        default: {
        
            [self.photoChooseCollectionView cancelInteractiveMovement];

        }

    }
    
    if (lastStateIsChanged) {
        
//        [self.photoChooseCollectionView cancelInteractiveMovement];

    }
    
}

- (void)beginChooseWithImg:(UIImage *)img {

  
    
    if (self.photoRooms.count == 0) {
        
        TLPhotoItem *firstItem = [TLPhotoItem new];
        firstItem.isAdd = NO;
        firstItem.img = img;
        
        //
        TLPhotoItem *addItem = [TLPhotoItem new];
        addItem.isAdd = YES;
        
        [self.photoRooms addObjectsFromArray:@[firstItem,addItem]];
        
    } else if(self.photoRooms.count <= 8) {
    
        TLPhotoItem *item = [TLPhotoItem new];
        item.isAdd = NO;
        item.img = img;
        [self.photoRooms insertObject:item atIndex:self.photoRooms.count - 1];

    } else if(self.photoRooms.count == 9) {
    
   
       __block TLPhotoItem *item;
        [self.photoRooms enumerateObjectsUsingBlock:^(TLPhotoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isAdd) {
                
                item = obj;
            }
        }];
        
        //是否有删除按钮
        //1.有
        //2.无
        //去除添加按钮
        
        if (item) {//有删除
            
            [self.photoRooms removeObject:item];
            
            TLPhotoItem *lastItem = [TLPhotoItem new];
            lastItem.isAdd = NO;
            lastItem.img = img;
            [self.photoRooms addObject:lastItem];
        } else {
        
            return;
        
        }
  
        
    }

    [self.photoChooseCollectionView  reloadData];
}

- (void)initData {

    
}

#pragma mark- collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

  
}

#pragma mark- collectionView-DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoRooms.count;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TLPhotoChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.deleteItem = ^(UICollectionViewCell *cell) {
    //删除某个
    
    };
    __weak typeof(self) weakself = self;
    cell.add = ^() {
        [weakself.imagePicker picker];
    
    };
    cell.backgroundColor = RANDOM_COLOR;
    cell.phototItem  = self.photoRooms[indexPath.row];
    return cell;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    TLPhotoItem *photoItem = (TLPhotoItem *)self.photoRooms[indexPath.row];

    if (photoItem.isAdd) {
        return NO;
    }
    
    return YES;
    
}


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath  {
    
    return;
    
    //位置变动一定会调用该方法，重新对photoItem进行排序
    
    TLPhotoItem *photoItem = (TLPhotoItem *)self.photoRooms[destinationIndexPath.row];
    if (photoItem.isAdd) {
        
        [collectionView cancelInteractiveMovement];
    }
    
    //怕段有无添加按钮
    __block BOOL addItem = nil;
    [self.photoRooms enumerateObjectsUsingBlock:^(TLPhotoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isAdd) {
            
            addItem = obj;
        }
    }];
    
    if (addItem) {//有添加按钮
        
        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:self.photoRooms.count];
        
        NSInteger count = self.photoRooms.count - 1;
        for (NSInteger i = 0; i < count; i ++) {
            
            TLPhotoChooseCell *cell = (TLPhotoChooseCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [mutableArr addObject:cell.phototItem];
            
            //
            [self.photoRooms removeObject:cell.phototItem];
            
        }
        //添加
        [mutableArr addObject:self.photoRooms[0]];
        
        self.photoRooms = mutableArr;
        
        
    } else {//无，9个
        
        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:self.photoRooms.count];
        
        for (NSInteger i = 0; i < self.photoRooms.count; i ++) {
            
            TLPhotoChooseCell *cell = (TLPhotoChooseCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [mutableArr addObject:cell.phototItem];

        }
        
        //添加
        self.photoRooms = mutableArr;
        
    
    }
    
}


#pragma mark- 手势代理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {


    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    NSLog(@"%@",NSStringFromSelector(_cmd));

    return YES;
}



//
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    
    return YES;
    
}

#pragma mark- 手势失败
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return NO;

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer  {
    
    return NO;
}




@end