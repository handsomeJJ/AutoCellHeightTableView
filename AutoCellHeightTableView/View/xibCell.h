//
//  xibCell.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/6.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListModel,xibCell;

typedef void (^cellBlock)(xibCell *cell, NSInteger tag, NSIndexPath *indexPath);

typedef void (^comentBlock)(xibCell *cell, UIButton *button);

@interface xibCell : UITableViewCell

@property(strong,nonatomic)ListModel *model;

@property(copy,nonatomic)cellBlock block;
@property(copy,nonatomic)comentBlock commentBlock;

@end
