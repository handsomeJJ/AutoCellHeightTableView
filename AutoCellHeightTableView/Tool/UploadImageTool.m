//
//  UploadImageTool.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/22.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "UploadImageTool.h"
#import "AFNetworking.h"
#import "QiniuUploadHelper.h"

#import "GTMBase64.h"
#include <CommonCrypto/CommonCrypto.h>
#import "AFNetworking.h"

#define QiNiuBaseUrl @"http://olrax8cua.bkt.clouddn.com/"

#define AccessKey @"3kfO1b7pDq2XeSKI1sv6IcC1uBaFLHcaSJH3k3OK"
#define SecretKey @"-_ao4g_fX-mZEI31mXkMB-mF0Azzye95OGp5_Hsx"

@implementation UploadImageTool


#pragma mark - Helpers
//给图片命名

+ (NSString *)getDateTimeString {
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}


+ (NSString *)randomStringWithLength:(int)len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i = 0; i<len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

+ (NSString *)marshal{
    
    time_t deadline;
    time(&deadline);//返回当前系统时间
    //@property (nonatomic , assign) int expires; 怎么定义随你...
//    deadline += (self.expires > 0) ? self.expires : 3600; // +3600秒,即默认token保存1小时.
    
    deadline += 3600;
    
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //users是我开辟的公共空间名（即bucket），aaa是文件的key，
    //按七牛“上传策略”的描述：    <bucket>:<key>，表示只允许用户上传指定key的文件。在这种格式下文件默认允许“修改”，若已存在同名资源则会被覆盖。如果只希望上传指定key的文件，并且不允许修改，那么可以将下面的 insertOnly 属性值设为 1。
    //所以如果参数只传users的话，下次上传key还是aaa的文件会提示存在同名文件，不能上传。
    //传users:aaa的话，可以覆盖更新，但实测延迟较长，我上传同名新文件上去，下载下来的还是老文件。
    [dic setObject:@"uploadimgdemo" forKey:@"scope"];//根据
    
    [dic setObject:deadlineNumber forKey:@"deadline"];
    
    //    NSString *json = [dic JSONString];
    NSString *json = [self dictionaryToJson:dic];
    
    return json;
}

//上传单张图片
+ (void)uploadImage:(id )image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure {
    
    NSString *token = [UploadImageTool getToken];
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", [UploadImageTool getDateTimeString], [UploadImageTool randomStringWithLength:8]];
    
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                               progressHandler:progress
                                                        params:nil
                                                      checkCrc:NO
                                            cancellationSignal:nil];
    QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
    
    if ([image isKindOfClass:[UIImage class]]) {
        // UIimage对象
        NSData *data = UIImageJPEGRepresentation(image, 0.01);
        
        if (!data) {
            
            if (failure) {
                
                failure();
            }
            return;
        }
        
        [uploadManager putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          
              if (info.statusCode == 200 && resp) {
                  NSString *url= [NSString stringWithFormat:@"%@%@", QiNiuBaseUrl, resp[@"key"]];
                  if (success) {
                      
                      success(url);
                  }
              }
              else {
                  if (failure) {
                      
                      failure();
                  }
              }
            
          } option:opt];
    }else{
        // phasset对象
        PHAsset *asset = (PHAsset *)image;
        [uploadManager putPHAsset:asset key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode == 200 && resp) {
                NSString *url= [NSString stringWithFormat:@"%@%@", QiNiuBaseUrl, resp[@"key"]];
                if (success) {
                    
                    success(url);
                }
            }
            else {
                if (failure) {
                    
                    failure();
                }
            }
        } option:opt];
        
    }
}

//上传多张图片
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    QiNiuUploadHelper *uploadHelper = [QiNiuUploadHelper sharedUploadHelper];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            NSLog(@"---%ld",(unsigned long)currentIndex);
            
            if (currentIndex<imageArray.count) {
                
                [UploadImageTool uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
            }
            
        }
    };
    
    [UploadImageTool uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}

+ (NSString *)getToken{
    return [UploadImageTool makeToken:AccessKey secretKey:SecretKey];
}
// 制作token
+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    const char *secretKeyStr = [secretKey UTF8String];
    
    NSString *policy = [UploadImageTool marshal];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    
    return token;//得到了token
}


// 字典json化
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
