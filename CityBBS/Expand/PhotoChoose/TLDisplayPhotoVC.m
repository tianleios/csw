//
//  TLDisplayPhotoVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLDisplayPhotoVC.h"
#import <Photos/Photos.h>
#import "TLPhotoChooseItem.h"
#import "TLPhotoCell.h"
#import "TLChooseResultManager.h"

@interface TLDisplayPhotoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray <PHAsset *> *assetRoom;
@property (nonatomic, strong) NSMutableArray <TLPhotoChooseItem *> *photoItems;

@end

@implementation TLDisplayPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complection)];
    }
    
    self.assetRoom = [NSMutableArray array];
    self.photoItems = [NSMutableArray array];
    //第一格为照相，先添加
    TLPhotoChooseItem *cameraItem = [TLPhotoChooseItem new];
    cameraItem.isCamera = YES;
    [self.photoItems addObject:cameraItem];
    
    
    //
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    
    CGFloat w = (SCREEN_WIDTH - 2*3)/4.0;
    flowLayout.itemSize = CGSizeMake(w, w);
    
    //
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor backgroundColor];
    
    //
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    
    [collectionView registerClass:[TLPhotoCell class] forCellWithReuseIdentifier:@"id"];
    
    
    //----// 以下为获取图片
    
    
    //图片库
    PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    
    //一、  PHAsset 和 PHCollection 两种途径获取资源
    //二、  两个子类 1.PHCollectionList:文件夹  2.PHAssetCollection:相册
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        NSLog(@"获取权限");
    }];
    
    
    //拉取选项
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    //    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    //获取相册
    PHFetchResult<PHAssetCollection *> *albumResult =	 [PHAssetCollection
                                                          
                                                          fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                          subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                          options:fetchOptions];
    
    //遍历相册
    [albumResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if ([obj isKindOfClass:[PHAssetCollection class]]) {
            
            PHFetchOptions *assetsFetchOptions = [[PHFetchOptions alloc] init];
            assetsFetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            
            PHFetchResult<PHAsset *> *assetsResult =  [PHAsset fetchAssetsInAssetCollection:obj options:nil];
            //遍历相册里的图片
            [assetsResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
                
                //只获取图片资源
                if (asset.mediaType == PHAssetMediaTypeImage) {
                    
                    [self.assetRoom addObject:asset];
                    TLPhotoChooseItem *photoItem = [TLPhotoChooseItem new];
                    photoItem.thumbnailSize = CGSizeMake(w, w);
                    photoItem.asset = asset;
                    [self.photoItems addObject:photoItem];
                }
                
            }];
            *stop = YES;
        }
        
    }];
    //从相册中，获取图片资源
    
    
    //由 asset 获取图片
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    //带有缓存的取出图片 比PHImageManager 性能更好
    //什么时候缓存完成呢
    PHCachingImageManager *cachingImageManager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
    [cachingImageManager startCachingImagesForAssets:self.assetRoom targetSize:CGSizeMake(w, w) contentMode:PHImageContentModeAspectFit options:imageRequestOptions];
    
    //取出图片 取出图片放在
    
    //    [self.assetRoom enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
    //
    //        [cachingImageManager requestImageForAsset:asset targetSize:CGSizeMake(w, w) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    //
    //
    //
    //        }];
    //
    //    }];
}

#pragma mark- 确定图片选择
- (void)complection {
    
    NSMutableArray <UIImage *>*imgs = [NSMutableArray array];
    CGFloat count = [TLChooseResultManager manager].hasChooseItems.count;
    
    //外界希望得到的应该是原图
    [[TLChooseResultManager manager].hasChooseItems enumerateObjectsUsingBlock:^(TLPhotoChooseItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [[PHImageManager defaultManager] requestImageForAsset:obj.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
//            NSLog(@"%@",result);
            [imgs addObject:result];
            NSLog(@"%@",self.delegate);
            if (idx == count - 1 && self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingWithImages:)]) {
                
                [self.delegate imagePickerController:self.pickerCtrl didFinishPickingWithImages:imgs];
                
            }
            
        }];
        
        

        
    }];
    
    
    
 
    
}

- (void)cancel {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        
        [self.delegate imagePickerControllerDidCancel:self.pickerCtrl];
        
    }
 
    
}

#pragma mark- imagePickerDelegate//  选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = (UIImage *)info[@"UIImagePickerControllerOriginalImage"];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.photoItems[indexPath.row].isCamera) { //拍照
        
        UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
        cameraController.delegate = self;
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraController animated:YES completion:nil];
        
    } else {//选择图片
        
        
    }
    
}
#pragma mark- dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoItems.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TLPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    cell.photoItem = self.photoItems[indexPath.row];
    return cell;
    
}

@end
