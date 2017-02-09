//
//  ListModel.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/6.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject
@property(copy,nonatomic)NSString *desc;
@property(copy,nonatomic)NSString *title;
@property(strong,nonatomic)NSMutableArray *imagesArr;


@property(assign,nonatomic)BOOL isLike;
@property(strong,nonatomic)NSMutableArray *likesArr;

@property(strong,nonatomic)NSMutableArray *commentArr;


//cell高度值
@property(assign,nonatomic)NSInteger cellHeight;

@end
