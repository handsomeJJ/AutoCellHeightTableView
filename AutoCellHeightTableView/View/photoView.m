//
//  photoView.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/7.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "photoView.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define VIEWWIDTH (kScreenWidth - 70)

@interface photoView ()<SDPhotoBrowserDelegate>
@property(strong,nonatomic)NSMutableArray *imageArr;
@end

@implementation photoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(CGFloat)configImage:(NSMutableArray *)imagesArr{
    
    self.imageArr = imagesArr;
    
    NSInteger count = imagesArr.count;
    CGFloat padding = 5;
    CGFloat imageContentViewWidth = VIEWWIDTH;
    CGFloat imageWidth = (imageContentViewWidth - padding * 2) / 3;
    CGFloat imageHeight = imageWidth;
    
    
    for (int i = 0; i < count; i ++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        CGFloat imageX = (padding + imageWidth) * (i % 3);
        CGFloat imageY = (padding + imageHeight) * (i / 3);
        imageV.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
        if (![imagesArr[i] hasPrefix:@"http"]) {
            
            imageV.image = [UIImage imageNamed:imagesArr[i]];
            
        }else{
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:imagesArr[i]] placeholderImage:[UIImage imageNamed:@"iconImage.jpg"]];
            
        }
        
        [self addSubview:imageV];
        imageV.tag = i;
        
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageV addGestureRecognizer:tapG];
        
    }
    
    CGFloat height;
    if (!count) {
        height = 0;
    }else if (count > 0 && count <= 3){
        height = imageHeight;
    }else if (count > 3 && count <= 6){
        height = imageHeight * 2 + padding;
    }else{
        height = imageHeight * 3 + padding * 2;
    }
    return height;
}

-(void)tapAction:(UITapGestureRecognizer *)sender{
    UIImageView *imageV = (UIImageView *)sender.view;
    SDPhotoBrowser *browser = [SDPhotoBrowser new];
    browser.delegate = self;
    browser.currentImageIndex = imageV.tag;
    browser.imageCount = self.imageArr.count;
    browser.sourceImagesContainerView = self;
    [browser show];
    
    // 通知下退出键盘
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TAGIMAGE" object:nil];
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlString = self.imageArr[index];
    if (![urlString hasPrefix:@"http"]) {
        return nil;
    }else
    return [NSURL URLWithString:urlString];
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}
@end
