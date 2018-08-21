//
//  HX_AddPhotoView.m
//  测试
//
//  Created by 洪欣 on 16/8/18.
//  Copyright © 2016年 洪欣. All rights reserved.
//

#import "HX_AddPhotoView.h"
#import "HX_AlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HX_AssetManager.h"
#import "HX_AddPhotoViewCell.h"
#import "HX_AssetContainerVC.h"
#import "MBProgressHUD.h"
#import "HX_VideoContainerVC.h"
#import "HX_AssetContainerVC.h"
#import "HX_VideoManager.h"
@interface HX_AddPhotoView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photosAy;
@property (assign, nonatomic) NSInteger maxNum;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (assign, nonatomic) SelectType type;
@property (assign, nonatomic) BOOL ifVideo;
@end

@implementation HX_AddPhotoView

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (instancetype)initWithMaxPhotoNum:(NSInteger)num WithSelectType:(SelectType)type
{
    if (self = [super init]) {
        self.maxNum = num;
        self.type = type;
        HX_AssetManager *manager = [HX_AssetManager sharedManager];
        if (type == SelectPhoto) {
            manager.type = HX_SelectPhoto;
        }else if (type == SelectVideo) {
            self.maxNum = 1;
            
            self.ifVideo = YES;
        }else if (type == SelectPhotoAndVideo) {
            manager.type = HX_SelectPhotoAndVieo;
        }
        [self setup];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureSelectPhotos:) name:@"HX_SureSelectPhotosNotice" object:nil];
    }
    return self;
}

- (NSMutableArray *)photosAy
{
    if (!_photosAy) {
        _photosAy = [NSMutableArray array];
    }
    return _photosAy;
}

- (void)setup
{
    if (self.lineNum == 0) {
        self.lineNum = 4;
    }
    
    HX_PhotoModel *model = [[HX_PhotoModel alloc] init];
    model.image = [UIImage imageNamed:@"tianjiatupian@2x.png"];
    model.ifSelect = NO;
    model.ifAdd = NO;
    model.type = HX_Unknown;
    [self.photosAy addObject:model];
    HX_PhotoModel *model2 = [[HX_PhotoModel alloc] init];
    model2.type = HX_Unknown;
    model2.ifAdd = NO;
    model2.ifSelect = NO;
    [self.photosAy addObject:model2];
    
    self.flowLayout.minimumLineSpacing = 5;
    self.flowLayout.minimumInteritemSpacing = 5;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 5, 0, 0) collectionViewLayout:self.flowLayout];
    collectionView.backgroundColor = self.backgroundColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    _collectionView = collectionView;
    
    [collectionView registerClass:[HX_AddPhotoViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)sureSelectPhotos:(NSNotification *)info
{
    [self.photosAy removeAllObjects];
    
    HX_AssetManager *assetManager = [HX_AssetManager sharedManager];
    HX_VideoManager *videoManager = [HX_VideoManager sharedManager];
    
    if (!self.ifVideo) {
        self.photosAy = [NSMutableArray arrayWithArray:assetManager.selectedPhotos.mutableCopy];
        self.selectNum = assetManager.selectedPhotos.count;
        
        NSMutableArray *array = [NSMutableArray array];
        [self.photosAy enumerateObjectsUsingBlock:^(HX_PhotoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array addObject:model.asset];
        }];
        if (self.selectPhotos) {
            self.selectPhotos(array.mutableCopy,[HX_AssetManager sharedManager].ifOriginal);
        }
    }else {
        self.photosAy = [NSMutableArray arrayWithArray:videoManager.selectedPhotos.mutableCopy];
        self.selectNum = videoManager.selectedPhotos.count;
        
        NSMutableArray *array = [NSMutableArray array];
        [self.photosAy enumerateObjectsUsingBlock:^(HX_PhotoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array addObject:model.asset];
        }];
        if (self.selectVideo) {
            self.selectVideo(array.mutableCopy);
        }
    }
    
    NSInteger count = self.photosAy.count;
    HX_PhotoModel *model = self.photosAy.firstObject;
    
    if (model.type == HX_Video) {
        ////
    }else {
        if (self.photosAy.count != self.maxNum) {
            HX_PhotoModel *model = [[HX_PhotoModel alloc] init];
            model.image = [UIImage imageNamed:@"tianjiatupian@2x.png"];
            model.ifSelect = NO;
            model.type = HX_Unknown;
            [self.photosAy addObject:model];
        }
        
        if (count == 0) {
            HX_PhotoModel *model2 = [[HX_PhotoModel alloc] init];
            model.type = HX_Unknown;
            [self.photosAy addObject:model2];
        }

    }
    [self setupNewFrame];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosAy.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HX_AddPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.model = self.photosAy[indexPath.item];
    cell.type = self.type;
    
    __weak typeof(self) weakSelf = self;
    [cell setDeleteBlock:^(UICollectionViewCell *cell) {
        HX_AssetManager *manager = [HX_AssetManager sharedManager];
        HX_VideoManager *videoManager = [HX_VideoManager sharedManager];
        NSIndexPath *indexP = [collectionView indexPathForCell:cell];
        [weakSelf.photosAy removeObjectAtIndex:indexP.item];
        
        if (!weakSelf.ifVideo) {
            HX_PhotoModel *model = manager.selectedPhotos[indexP.item];
            model.ifAdd = NO;
            model.ifSelect = NO;
            [manager.selectedPhotos removeObjectAtIndex:indexP.item];
            weakSelf.selectNum = manager.selectedPhotos.count;
            
            if (manager.selectedPhotos.count == 0) {
                manager.ifOriginal = NO;
            }
            
            for (int i = 0 ; i < manager.selectedPhotos.count ; i++) {
                HX_PhotoModel *PH = manager.selectedPhotos[i];
                PH.index = i;
            }
            
            NSMutableArray *array = [NSMutableArray array];
            [manager.selectedPhotos enumerateObjectsUsingBlock:^(HX_PhotoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:model.asset];
            }];
            if (weakSelf.selectPhotos) {
                weakSelf.selectPhotos(array.mutableCopy,[HX_AssetManager sharedManager].ifOriginal);
            }
            
        }else {
            [videoManager.selectedPhotos removeObjectAtIndex:indexP.item];
            weakSelf.selectNum = videoManager.selectedPhotos.count;
            
            NSMutableArray *array = [NSMutableArray array];
            [videoManager.selectedPhotos enumerateObjectsUsingBlock:^(HX_PhotoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:model.asset];
            }];
            if (weakSelf.selectVideo) {
                weakSelf.selectVideo(array.mutableCopy);
            }
        }
        
        [collectionView deleteItemsAtIndexPaths:@[indexP]];
        
        if (!weakSelf.ifVideo) {
            NSInteger count = manager.selectedPhotos.count;
            BOOL ifAdd = NO;
            for (int i = 0; i < weakSelf.photosAy.count; i ++) {
                HX_PhotoModel *modeli = weakSelf.photosAy[i];
                if (!modeli.ifSelect) {
                    ifAdd = YES;
                }
            }
            
            if (weakSelf.photosAy.count != weakSelf.maxNum && !ifAdd) {
                HX_PhotoModel *model1 = [[HX_PhotoModel alloc] init];
                model1.image = [UIImage imageNamed:@"tianjiatupian@2x.png"];
                model1.ifSelect = NO;
                model1.ifAdd = NO;
                model1.type = HX_Unknown;
                [weakSelf.photosAy addObject:model1];
            }
            
            if (count == 0) {
                HX_PhotoModel *model2 = [[HX_PhotoModel alloc] init];
                model2.ifSelect = NO;
                model2.ifAdd = NO;
                model2.type = HX_Unknown;
                [weakSelf.photosAy addObject:model2];
            }
            [weakSelf setupNewFrame];
            [weakSelf.collectionView reloadData];
        }else {
            NSInteger count = videoManager.selectedPhotos.count;
            
            if (weakSelf.photosAy.count != weakSelf.maxNum) {
                HX_PhotoModel *model1 = [[HX_PhotoModel alloc] init];
                model1.image = [UIImage imageNamed:@"tianjiatupian@2x.png"];
                model1.ifSelect = NO;
                model1.ifAdd = NO;
                model1.type = HX_Unknown;
                [weakSelf.photosAy addObject:model1];
            }
            
            if (count == 0) {
                HX_PhotoModel *model2 = [[HX_PhotoModel alloc] init];
                model2.ifSelect = NO;
                model2.ifAdd = NO;
                model2.type = HX_Unknown;
                [weakSelf.photosAy addObject:model2];
            }
            [weakSelf setupNewFrame];
            [weakSelf.collectionView reloadData];
            
        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HX_PhotoModel *model = self.photosAy[indexPath.row];
    if (!self.ifVideo) {
        if (model.type == HX_Video) {
            HX_VideoContainerVC *vc = [[HX_VideoContainerVC alloc] init];
            vc.model = model;
            vc.ifPush = NO;
            [[self viewController:self] presentViewController:vc animated:YES completion:nil];
            return;
        }
        
        if (model.type == HX_Photo) {
            HX_AssetContainerVC *vc = [[HX_AssetContainerVC alloc] init];
            vc.ifLookPic = YES;
            vc.photoAy = [HX_AssetManager sharedManager].selectedPhotos;
            vc.currentIndex = indexPath.item;
            vc.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[self viewController:self] presentViewController:vc animated:YES completion:nil];
            return;
        }
        
        NSInteger count = [HX_AssetManager sharedManager].selectedPhotos.count;
        if (self.photosAy.count == 2 && indexPath.item == 0 && count == 0) {
            [self goAddPhotoVC];
            return;
        }
        
        if (self.photosAy.count <= self.maxNum && indexPath.item == self.photosAy.count - 1) {
            if (count == self.maxNum) return;
            [self goAddPhotoVC];
        }
        
    }else {
        if (model.type == HX_Video) {
            HX_VideoContainerVC *vc = [[HX_VideoContainerVC alloc] init];
            vc.model = model;
            vc.ifPush = NO;
            [[self viewController:self] presentViewController:vc animated:YES completion:nil];
            return;
        }
        NSInteger count = [HX_VideoManager sharedManager].selectedPhotos.count;
        if (self.photosAy.count == 2 && indexPath.item == 0 && count == 0) {
            [self goAddPhotoVC];
            return;
        }
    }
}

- (void)goAddPhotoVC
{
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {

        tipTextWhenNoPhotosAuthorization = @"请在设备的\"设置-隐私-照片\"选项中，允许访问你的手机相册";
        // 展示提示语
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        UIView *view = [[UIView alloc] init];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrcode_ar_failed@2x.png"]];
        [view addSubview:imageView];
        
        view.frame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height + 10);
        
        hud.customView = view;
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = tipTextWhenNoPhotosAuthorization;
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.margin = 10.f;
        
        [hud hide:YES afterDelay:3.0f];
    }
    //    NSLog(@"%f",VERSION);
    
    HX_AlbumViewController *photo = [[HX_AlbumViewController alloc] init];
    photo.maxNum = self.maxNum;
    photo.ifVideo = self.ifVideo;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photo];
    [[self viewController:self] presentViewController:nav animated:YES completion:nil];
}
- (UIViewController*)viewController:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)setupNewFrame
{
    CGFloat width = self.frame.size.width;
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    
    CGFloat itemW = ((width - 10) - 5 * (self.lineNum - 1)) / self.lineNum;
    
    self.flowLayout.itemSize = CGSizeMake(itemW, itemW);
    
    static NSInteger numofLinesOld = 1;
    
    NSInteger numOfLinesNew = (_photosAy.count / self.lineNum) + 1;
    
    if (_photosAy.count % _lineNum == 0) {
        numOfLinesNew -= 1;
    }
    
    if (numOfLinesNew == 1) {
        self.flowLayout.minimumLineSpacing = 0;
    }else {
        self.flowLayout.minimumLineSpacing = 5;
    }
    
    if (numOfLinesNew != numofLinesOld) {
        
        CGFloat newHeight = numOfLinesNew * itemW + 5 * numOfLinesNew + 5;
        
        self.frame = CGRectMake(x, y, width, newHeight);

        numofLinesOld = numOfLinesNew;
        if ([self.delegate respondsToSelector:@selector(updateViewFrame:WithView:)]) {
            [self.delegate updateViewFrame:self.frame WithView:self];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupNewFrame];
    
    if (self.photosAy.count == 2) {
        CGFloat width = self.frame.size.width;
        CGFloat itemW = ((width - 10) - 5 * (self.lineNum - 1)) / self.lineNum;
        self.bounds = CGRectMake(0, 0, width, itemW + 10);
    }
    NSInteger numOfLinesNew = (_photosAy.count / _lineNum) + 1;
    if (_photosAy.count % _lineNum == 0) {
        numOfLinesNew -= 1;
    }
    _collectionView.frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10);
    
}

- (void)dealloc
{
    HX_AssetManager *manager = [HX_AssetManager sharedManager];
    manager.ifRefresh = YES;
    for (HX_PhotoModel *model in manager.selectedPhotos) {
        model.ifAdd = NO;
        model.ifSelect = NO;
    }
    [manager.selectedPhotos removeAllObjects];
    manager.ifOriginal = NO;
    
    [HX_VideoManager sharedManager].ifRefresh = YES;
    [[HX_VideoManager sharedManager].selectedPhotos removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
