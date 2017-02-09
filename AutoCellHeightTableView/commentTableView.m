//
//  commentTableView.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/8.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "commentTableView.h"
#import "commentCell.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define VIEWWIDTH (kScreenWidth - 90)

@interface commentTableView ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;

@property(assign,nonatomic)CGFloat headHeight, tableHeight;
@end

@implementation commentTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}
-(CGFloat)configWithlikes:(NSMutableArray *)likeArr comments:(NSMutableArray *)commentArr{
    
    CGFloat headHeight;
    if (!likeArr.count) {
        self.likeStr = nil;
        headHeight = 0;
    }else{
        NSString *likeStr = @"💕";
        for (NSString *per in likeArr) {
            
            likeStr = [likeStr stringByAppendingString:per];
            likeStr = [likeStr stringByAppendingString:@" "];
        }
        likeStr = [likeStr stringByAppendingString:@"觉得很赞"];
        self.likeStr = likeStr;
        
        headHeight = [self sizeWithText:self.likeStr font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(VIEWWIDTH - 20, MAXFLOAT)].height + 10;
    }
    
    self.commentArr = commentArr;
    CGFloat cellHeight;
    for (NSDictionary *dict in commentArr) {
        NSString *string = @"";
        if ([dict[@"toNickname"] isEqualToString:@""]) {
            string = [NSString stringWithFormat:@"%@: %@",dict[@"nickname"],dict[@"content"]];
            
        }else{
            string = [NSString stringWithFormat:@"%@ 回复 %@: %@",dict[@"nickname"],dict[@"toNickname"],dict[@"content"]];
            
        }
        cellHeight  += [self sizeWithText:string font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(VIEWWIDTH - 20, MAXFLOAT)].height;
        cellHeight += 10;
    }
    
    self.headHeight = headHeight;
    self.tableHeight = cellHeight + headHeight;
    
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, self.tableHeight)];
    bgView.image = [self resizableImage:@"LikeCmtBg"];
    [self addSubview:bgView];
    [self addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, VIEWWIDTH, self.tableHeight);
    
    return self.tableHeight;
}

#pragma mark -- delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.likeStr == nil) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(0, 0, VIEWWIDTH - 20, 5);
        
        return view;
    }
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc]init];

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.likeStr];
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor colorWithRed:64/255.0 green:76/255.0 blue:117/255.0 alpha:1.0]
                   range:NSMakeRange(0, [self.likeStr length] - 4)];
    
    lab.attributedText = attStr;
    lab.font = [UIFont systemFontOfSize:15];
    lab.numberOfLines = 0;
    lab.frame = CGRectMake(5, 3, VIEWWIDTH - 10, self.headHeight);
    [view addSubview:lab];
    
    // 底部线条
    UIView *lineV = [[UIView alloc]init];
    lineV.frame = CGRectMake(0, CGRectGetMaxY(lab.frame) - 3, VIEWWIDTH, 1);
    lineV.backgroundColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
    [view addSubview:lineV];
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"--indexpath--%ld",indexPath.row);
    
    if (self.block) {
        self.block(indexPath);
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"mjTabV";
    commentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"commentCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.commentArr[indexPath.row];
    [cell configCellWithDict:dict];
    
    return cell;
}

#pragma mark -- get
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, self.tableHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.userInteractionEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"commentHeadView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"comentHead"];
    }
    return _tableView;
}


/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
-(UIImage *)resizableImage:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}





@end
