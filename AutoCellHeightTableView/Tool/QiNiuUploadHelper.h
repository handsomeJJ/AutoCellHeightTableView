//
//  QiNiuUploadHelper.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/22.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiNiuUploadHelper : NSObject
@property (copy, nonatomic) void (^singleSuccessBlock)(NSString *);
@property (copy, nonatomic) void (^singleFailureBlock)();

+ (instancetype)sharedUploadHelper;
@end
