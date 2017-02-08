//
//  commentTableView.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/8.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentTableView : UIView

@property(strong,nonatomic)NSMutableArray *likeArr;
@property(strong,nonatomic)NSMutableArray *commentArr;


-(CGFloat)configWithlikes:(NSMutableArray *)likesArr comments:(NSMutableArray *)commentArr;

@end
