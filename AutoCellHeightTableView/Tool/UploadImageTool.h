//
//  UploadImageTool.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/22.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QiniuSDK.h"

@interface UploadImageTool : NSObject

// 获取七牛上传token
+ (NSString *)getToken;

/**
 *  上传图片
 *
 *  @param image    需要上传的image
 *  @param progress 上传进度block
 *  @param success  成功block 返回url地址
 *  @param failure  失败block
 */
+ (void)uploadImage:(id)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure;

// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure;


+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey;

+ (NSString *)marshal;

// 字典json化
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (NSString *)getDateTimeString;

+ (NSString *)randomStringWithLength:(int)len;
@end
