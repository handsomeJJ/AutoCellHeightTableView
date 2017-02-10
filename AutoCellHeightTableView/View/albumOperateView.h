//
//  albumOperateView.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/8.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^btnBlock)(UIButton *sender);

@interface albumOperateView : UIView

@property(copy,nonatomic)btnBlock block;

+(instancetype)showOperateView;


@end
