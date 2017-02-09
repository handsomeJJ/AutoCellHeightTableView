//
//  ViewController.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/6.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "ViewController.h"
#import "ListModel.h"
#import "xibCell.h"
#import "albumOperateView.h"
#import "YYFPSLabel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *infoArr;
@property(strong,nonatomic)NSMutableDictionary *cellHeight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];

    self.title = @"朋友圈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
}
#pragma mark -- delegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = cell.frame.size.height;
    [self.cellHeight setObject:@(height) forKey:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *cellHeight = [self.cellHeight objectForKey:indexPath];
    CGFloat height = cellHeight.floatValue;
    if (height) {
        return height;
    }else
    
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"mjcell";
    xibCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"xibCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ListModel *model = self.infoArr[indexPath.row];
    cell.model = model;

    __weak typeof (self) weakSelf = self;
    cell.block = ^(xibCell *xibCe, NSInteger tag){
      
        NSLog(@"--%ld--",tag);
        for (UIView *view in [xibCe subviews]) {
            if ([view isKindOfClass:[albumOperateView class]]) {
                [view removeFromSuperview];

            }
        }
        if (tag == 10) {
            
            
        }else if (tag == 11){
            
            NSLog(@"点赞事件");
            NSMutableArray *likesArr = model.likesArr;
            [likesArr addObject:@"你爸爸"];

            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (tag == 12){
            
            NSLog(@"评论事件");
        }
        
        
    };
    
    return cell;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 移除opView
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 移除opView
    
}
#pragma mark -- get
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
-(NSMutableArray *)infoArr{
    if (!_infoArr) {
        _infoArr = [NSMutableArray array];
        NSString *string = @"90%的人问了同一个问题，上班通勤已经很累了，回家只想倒头就睡，根本没有力气再做业余活动，更无法动手动脑把业余活动做出什么成就来，这简直就是一个无法破的死循环，该怎么办！以我的实际经验告诉你，早晨去健身，去健身，去健身。那会不会让身体更累呢？你去试试看，真的去试试看。我从早晨健身后，整个一天都精神振奋的想大跳，观察我身边的健身妹子们，以前一个个都是加班狗，上班一年就一个个暮气沉沉，健身后一个个感觉都朝着网红路上走了。人的精神和外貌都改变成这样了，随时随地精神百倍！这些人现在干点啥都发朋友圈，简直都想屏蔽她们.";
        
        //生成假数据
        NSArray *netImagesArr=@[
                                @"2.png",
                                @"8",
                                 @"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
                                 @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
                                 @"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
                                 @"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
                                 @"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
                                 @"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
                                 @"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
                                 @"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
                                 @"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg"
                                 ];
        NSArray *imagesArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        
        NSArray *name = @[@"特立独行的猪",@"小岳岳",@"大长今",@"文常",@"宋小宝",@"吴秀波",@"郭麒麟"];
        for (int i = 0; i < 10; i++)
        {
            ListModel *model = [[ListModel alloc] init];
            NSInteger index = (arc4random()%(string.length / 20)) * 20;
            model.desc = [string substringToIndex:MAX(20, index)];
            
            model.title = name[arc4random() % 6];
                        
            model.imagesArr = [[imagesArr subarrayWithRange:NSMakeRange(0, arc4random() % 10)]mutableCopy];
            
            if (i) {
                NSArray *array = @[@"宋小宝",@"吴秀波",@"郭麒麟",@"宋小宝",@"吴秀波",@"郭麒麟",@"宋小宝",@"吴秀波",@"郭麒麟",@"宋小宝",@"吴秀波",@"郭麒麟",@"宋小宝",@"吴秀波",@"郭麒麟"];
                model.likesArr = [array mutableCopy];
            }
            
            
            NSDictionary *dict = @{@"nickname":@"吴秀波",@"toNickname":@"",@"content":@"楼主长的真帅-----"};
            NSDictionary *dict1 = @{@"nickname":@"宋小宝",@"toNickname":@"吴秀波",@"content":@"怪我咯傻逼---"};
            NSDictionary *dict2 = @{@"nickname":@"吴秀波",@"toNickname":@"宋小宝",@"content":@"就怪你啊大傻逼---"};
            NSDictionary *dict3 = @{@"nickname":@"常远",@"toNickname":@"",@"content":@"你们都是大傻逼，谁也别让这谁---"};
            NSDictionary *dict4 = @{@"nickname":@"岳云鹏",@"toNickname":@"",@"content":@"人的精神和外貌都改变成这样了，随时随地精神百倍！这些人现在干点啥都发朋友圈，简直都想屏蔽她们---"};
            NSArray *commentArr = [NSArray arrayWithObjects:dict2,dict1,dict,dict3,dict4, nil];
            if (i % 3) {
                model.commentArr = [commentArr mutableCopy];
            }
            
  
            [_infoArr addObject:model];
        }
    }
    return _infoArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
