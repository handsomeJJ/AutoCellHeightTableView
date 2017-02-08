//
//  albumOperateView.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/8.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "albumOperateView.h"

@interface albumOperateView ()
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation albumOperateView

+(instancetype)showOperateView{
    return [[[NSBundle mainBundle]loadNibNamed:@"albumOperateView" owner:self options:nil]lastObject];
}

- (IBAction)likeAction:(UIButton *)sender {
    
    if (self.block) {
        self.block(sender);
    }
}

- (IBAction)commentAction:(UIButton *)sender {
    
    if (self.block) {
        self.block(sender);
    }
}


@end
