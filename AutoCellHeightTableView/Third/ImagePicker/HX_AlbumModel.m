//
//  HX_AlbumModel.m
//  测试
//
//  Created by 洪欣 on 16/8/20.
//  Copyright © 2016年 洪欣. All rights reserved.
//

#import "HX_AlbumModel.h"
#import "HX_AssetManager.h"
@implementation HX_AlbumModel

- (NSUInteger)photosNum
{
    if (_photosNum == 0) {
        _photosNum = [_group numberOfAssets];
    }
    return _photosNum;
}

- (NSString *)albumName
{
    if (!_albumName) {
        _albumName = [_group valueForProperty:ALAssetsGroupPropertyName];
        if ([_albumName isEqualToString:@"All Photos"]) {
            if ([HX_AssetManager sharedManager].type == HX_SelectVideo) {
                _albumName = @"所有视频";
            }else {
               _albumName = @"所有照片";
            }
        }else if ([_albumName isEqualToString:@"Camera Roll"]){
            _albumName = @"相机胶卷";
        }
    }
    return _albumName;
}

//- (UIImage *)coverImage
//{
//    if (!_coverImage) {
//        _coverImage = [UIImage imageWithCGImage:[_group posterImage]];
//    }
//    return _coverImage;
//}

@end
