//
//  HX_VideoManager.m
//  城市2.0
//
//  Created by 洪欣 on 16/8/26.
//  Copyright © 2016年 NRH. All rights reserved.
//

#import "HX_VideoManager.h"
#import "HX_PhotoModel.h"
#import "HX_AlbumModel.h"
@interface HX_VideoManager ()
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *allAlbumAy;
@property (strong, nonatomic) NSMutableArray *allGroup;
@end


static HX_VideoManager *sharedManager = nil;
static BOOL ifVideoOne = YES;


@implementation HX_VideoManager
+ (instancetype)sharedManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSMutableArray *)selectedPhotos
{
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    
    return _selectedPhotos;
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

#pragma mark - < 所有相册封面信息 >
- (NSMutableArray *)allAlbumAy
{
    if (!_allAlbumAy) {
        _allAlbumAy = [NSMutableArray array];
    }
    return _allAlbumAy;
}

#pragma mark - < 所有相册里的所有图片信息 >
- (NSMutableArray *)allGroup
{
    if (!_allGroup) {
        _allGroup = [NSMutableArray array];
    }
    return _allGroup;
}

#pragma mark - < 是否重新加载图片 >
- (void)setIfRefresh:(BOOL)ifRefresh
{
    _ifRefresh = ifRefresh;
    
    ifVideoOne = ifRefresh;
}

/**  获取所有相册信息  */
- (void)getAllAlbumWithStart:(void (^)())start WithEnd:(void (^)(NSArray *, NSArray *))album WithFailure:(void (^)(NSError *))failure
{
    if (start) {
        start();
    }
    
    if (ifVideoOne) {
        [self.allAlbumAy removeAllObjects];
        [self.allGroup removeAllObjects];
        
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {

                [group setAssetsFilter:[ALAssetsFilter allVideos]];
     
                
                if ([group numberOfAssets] != 0) {
                    HX_AlbumModel *album = [[HX_AlbumModel alloc] init];
                    
                    album.coverImage = [UIImage imageWithCGImage:[group posterImage]];
                    
                    album.group = group;
                    [self.allAlbumAy addObject:album];
                    
                    NSMutableArray *ay = [NSMutableArray array];
                    
                    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        
                        if (result) {
                            HX_PhotoModel *model = [[HX_PhotoModel alloc] init];
                            model.tableViewIndex = self.allAlbumAy.count - 1;
                            
                            
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                                model.type = HX_Photo;
                            }else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                                model.type = HX_Video;
                                NSTimeInterval duration = [[result valueForProperty:ALAssetPropertyDuration] integerValue];
                                NSString *timeLength = [NSString stringWithFormat:@"%0.0f",duration];
                                model.videoTime = [self getNewTimeFromDurationSecond:timeLength.integerValue];
                            }else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeUnknown]) {
                                model.type = HX_Unknown;
                            }
                            
                            //                            model.image = [UIImage imageWithCGImage:[result aspectRatioThumbnail]];
                            model.asset = result;
                            
                            [ay addObject:model];
                        }
                    }];
                    [self.allGroup addObject:ay];
                }
                
            }else {
                if (self.allAlbumAy.count > 0) {
                    if (album) {
                        album(self.allAlbumAy,self.allGroup);
                        ifVideoOne = NO;
                    }
                }else {
                    if (failure) {
                        failure([[NSError alloc] init]);
                    }
                }
            }
        } failureBlock:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }else {
        if (album) {
            album(self.allAlbumAy,self.allGroup);
        }
    }
}

#pragma mark - < 获取视频的大小 >
- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"00:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"00:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

@end
