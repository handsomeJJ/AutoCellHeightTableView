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

@interface xibCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet photoView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
