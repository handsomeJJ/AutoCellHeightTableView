//
//  UIScrollView+_MJTouches.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/16.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "UIScrollView+_MJTouches.h"

@implementation UIScrollView (_MJTouches)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
@end
