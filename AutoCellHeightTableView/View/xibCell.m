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
#import "commentTableView.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define VIEWWIDTH (kScreenWidth - 70)

@interface xibCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet photoView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIButton *albumOperateBtn;
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
    
    CGFloat titleH = [self sizeWithText:model.title font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(VIEWWIDTH, MAXFLOAT)].height;
    CGFloat contentH = [self sizeWithText:model.desc font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(VIEWWIDTH, MAXFLOAT)].height;

    CGFloat photoH = [self.photoView configImage:model.imagesArr];
    self.imageHeight.constant = photoH;
    
    CGFloat cmtH = [self.cmtTableView configWithlikes:model.likesArr comments:model.commentArr];
    
    __weak typeof(self) weakSelf = self;
    self.cmtTableView.block = ^(NSIndexPath *indexPath){
      
        if (weakSelf.block) {
            weakSelf.block(self,0,indexPath);
        }
    };
    self.commentTabHeight.constant = cmtH;
    
    CGFloat cellHeight = 70 + titleH + contentH + photoH + cmtH;//控件之间的垂直间距加起来70
    model.cellHeight = cellHeight;
        
}
- (IBAction)albumOperateAction:(UIButton *)sender {
    
    if (self.commentBlock) {
        self.commentBlock(self,sender);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
