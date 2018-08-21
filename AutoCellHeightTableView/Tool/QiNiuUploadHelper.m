//
//  QiNiuUploadHelper.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/22.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "QiNiuUploadHelper.h"

@implementation QiNiuUploadHelper
static id _instance = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedUploadHelper {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return _instance;
}
@end
