//
//  commentCell.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/9.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;

-(void)configCellWithDict:(NSDictionary *)dict;

@end
