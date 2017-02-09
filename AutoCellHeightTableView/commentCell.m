//
//  commentCell.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/9.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "commentCell.h"

@interface commentCell ()
@property (weak, nonatomic) IBOutlet UILabel *commentLab;


@end

@implementation commentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configCellWithDict:(NSDictionary *)dict{
    
    NSString *string;
    NSMutableAttributedString *attStr;
    if ([dict[@"toNickname"] isEqualToString:@""]) {
        string = [NSString stringWithFormat:@"%@: %@",dict[@"nickname"],dict[@"content"]];
        
        attStr = [[NSMutableAttributedString alloc]initWithString:string];
        
        [attStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor colorWithRed:64/255.0 green:76/255.0 blue:117/255.0 alpha:1.0]
         
                              range:NSMakeRange(0,[dict[@"nickname"] length])];
        
        
    }else{
        string = [NSString stringWithFormat:@"%@ 回复 %@: %@",dict[@"nickname"],dict[@"toNickname"],dict[@"content"]];
        
        attStr = [[NSMutableAttributedString alloc]initWithString:string];
        [attStr addAttribute:NSForegroundColorAttributeName
         
                       value:[UIColor colorWithRed:64/255.0 green:76/255.0 blue:117/255.0 alpha:1.0]
         
                       range:NSMakeRange(0,[dict[@"nickname"] length])];
        
        [attStr addAttribute:NSForegroundColorAttributeName
         
                       value:[UIColor colorWithRed:64/255.0 green:76/255.0 blue:117/255.0 alpha:1.0]
         
                       range:NSMakeRange([dict[@"nickname"] length] + 4,[dict[@"toNickname"] length])];
        
    }
    

    self.commentLab.attributedText = attStr;
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
