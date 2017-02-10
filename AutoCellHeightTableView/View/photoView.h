//
//  photoView.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/7.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoView : UIView

@property(strong,nonatomic)NSMutableArray *imagesArr;

-(CGFloat)configImage:(NSMutableArray *)imagesArr;

@end
