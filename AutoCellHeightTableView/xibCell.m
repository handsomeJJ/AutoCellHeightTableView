//
//  xibCell.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/6.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "xibCell.h"
#import "ListModel.h"
#import "photoView.h"
#import "albumOperateView.h"
#import "commentTableView.h"

@interface xibCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet photoView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIButton *albumOperateBtn;
@property(strong,nonatomic)albumOperateView *opView;
@property (weak, nonatomic) IBOutlet commentTableView *cmtTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTabHeight;
@end

@implementation xibCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(ListModel *)model{
    _model = model;
    self.image.image = [UIImage imageNamed:@"iconImage.jpg"];
    self.title.text = model.title;
    self.content.text = model.desc;
    
    self.imageHeight.constant = [self.photoView configImage:model.imagesArr];
    
    
    __weak typeof(self) weakSelf = self;
    self.cmtTableView.block = ^(NSIndexPath *indexPath){
      
        if (weakSelf.block) {
            weakSelf.block(self,0,indexPath);
        }
    };
    self.commentTabHeight.constant = [self.cmtTableView configWithlikes:model.likesArr comments:model.commentArr];
    
}
- (IBAction)albumOperateAction:(UIButton *)sender {
    
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[albumOperateView class]]) {
            
            // 回调到控制器更新改行cell，销毁opView
            if (self.block) {
                self.block(self,10,nil);
            }
            
        }else{
            CGFloat albumOperateY = CGRectGetMaxY(self.albumOperateBtn.frame) - 30;
            CGFloat albumOperateX = CGRectGetMinX(self.albumOperateBtn.frame) - 180;
            _opView = [albumOperateView showOperateView];
            
            _opView.frame = CGRectMake(albumOperateX, albumOperateY, 160, 40);

            [self addSubview:_opView];
            
            __weak typeof(self) weakSelf = self;
            self.opView.block = ^(UIButton *sender){
                
                NSLog(@"--%ld--",(long)sender.tag);
                
                if (sender.tag == 1) {
                    // 点赞
                    if (weakSelf.block) {
                        weakSelf.block(weakSelf,11,nil);
                    }
                }else if(sender.tag == 3){
                    // 评论
                    if (weakSelf.block) {
                        weakSelf.block(weakSelf,12,nil);
                    }
                }
                
            };
        }
    }

    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
