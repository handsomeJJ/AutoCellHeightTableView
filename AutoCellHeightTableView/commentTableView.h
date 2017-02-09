//
//  commentTableView.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/8.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentTableView : UIView

@property(strong,nonatomic)NSString *likeStr;
@property(strong,nonatomic)NSMutableArray *commentArr;


-(CGFloat)configWithlikes:(NSMutableArray *)likeArr comments:(NSMutableArray *)commentArr;

@end
