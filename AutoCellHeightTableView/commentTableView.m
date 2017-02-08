//
//  commentTableView.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/8.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "commentTableView.h"

@interface commentTableView ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UIView *headView;
@end

@implementation commentTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}
-(CGFloat)configWithlikes:(NSMutableArray *)likesArr comments:(NSMutableArray *)commentArr{
    
    self.tableView.tableHeaderView = self.headView;
    
    CGFloat tableHeight;
    
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 90, 300)];
    bgView.image = [self resizableImage:@"LikeCmtBg"];
    [self addSubview:bgView];
    [self addSubview:self.tableView];
    
    NSLog(@"--%@--%@",likesArr,commentArr);
    
    return 300;
}

#pragma mark -- delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"mjTabV";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    
    return cell;
}

#pragma mark -- get
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
-(UIView *)headView{
    if (_headView) {
        _headView = [[UIView alloc]init];
        _headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 90, 100);
        _headView.backgroundColor = [UIColor redColor];
    }
    return _headView;
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




@end
