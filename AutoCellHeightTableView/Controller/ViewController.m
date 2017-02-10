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
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceThemeModel.h"

//键盘上面的工具条
#define kChatToolBarHeight              49
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define VIEWWIDTH (kScreenWidth - 90)
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ChatKeyBoardDelegate,ChatKeyBoardDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *infoArr;
@property(strong,nonatomic)NSMutableDictionary *cellHeight;


//cell的坐标
@property (nonatomic,assign)CGRect rectSelected;
// 评论框架
@property(strong,nonatomic)ChatKeyBoard *chatKeyBoard;
// 评论某人  余下评论的高度
@property(assign,nonatomic)CGFloat restCommentHeight;
// 当前操作的cell
@property(strong,nonatomic)NSIndexPath *currentCellIndex;
// 回复某人的评论
@property(strong,nonatomic)NSIndexPath *currentCmtIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
    self.title = @"朋友圈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item4 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item5 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item6 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item7 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item8 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item9 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    return @[item1];
    
    return @[item1, item2, item3, item4];
}
- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}

#pragma mark -- chatKeyBoard
-(ChatKeyBoard *)chatKeyBoard{
    if (!_chatKeyBoard) {
        _chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.placeHolder = @"评论";
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
        
    }
    return _chatKeyBoard;
}
#pragma mark -- 键盘通知
-(void)keyBoardWillShow:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//animationDurationNSTimeInterval
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (animationDuration == 0) {
        NSLog(@"--return--");
        return;
    }
    
    NSLog(@"--userinfo--%@",userInfo);
    
    NSValue *keyBoardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyBoardRect = [keyBoardValue CGRectValue];
    
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    
    
    CGFloat delta = self.rectSelected.origin.y + self.rectSelected.size.height - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyBoardHeight - kChatToolBarHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = -64;
    }
    [self.tableView setContentOffset:offset animated:YES];
    [self.chatKeyBoard keyboardUpforComment];
}
-(void)keyBoardWillHide:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    
    NSLog(@"--keyBoardWillHide--%@",dict);    
}
-(void)chatKeyBoardSendText:(NSString *)text{
    
    NSLog(@"--输入的评论是--%@",text);
    [self.chatKeyBoard keyboardDownForComment];
    
    ListModel *model = self.infoArr[self.currentCellIndex.row];
    
    NSDictionary *replyDict = [NSDictionary dictionary];
    NSMutableArray *commentArr = model.commentArr;
    
    if (self.currentCmtIndex) {
        
        NSDictionary *dict = commentArr[self.currentCmtIndex.row];
        
        replyDict = @{@"nickname":@"你帅帅的爹地郭德纲",
                       @"toNickname":dict[@"nickname"],
                       @"content":text};
    }else{
        replyDict = @{@"nickname":@"你帅帅的爹地郭德纲",
                       @"toNickname":@"",
                       @"content":text};
    }
    [commentArr addObject:replyDict];
    model.commentArr = commentArr;
    self.infoArr[self.currentCellIndex.row] = model;
    [self.tableView reloadRowsAtIndexPaths:@[self.currentCellIndex] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)chatKeyBoardFacePicked:(ChatKeyBoard *)chatKeyBoard faceStyle:(NSInteger)faceStyle faceName:(NSString *)faceName delete:(BOOL)isDeleteKey{
    NSLog(@"%@",faceName);
}
- (void)chatKeyBoardAddFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
}
- (void)chatKeyBoardSetFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
    
}


#pragma mark -- delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    实测从缓存读取和数据源读取影响都不大啊
//    NSNumber *height = [self.cellHeight objectForKey:indexPath];
//    CGFloat cellHeight = height.floatValue;
//    if(cellHeight)
//    {
//        NSLog(@"--indexPath--%ld cellHeight-%f",indexPath.row, cellHeight);
//        return cellHeight;
//    }else{
//        ListModel *model = self.infoArr[indexPath.row];
//        return model.cellHeight;
//    }
    
    ListModel *model = self.infoArr[indexPath.row];
    return model.cellHeight;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSNumber *height = @(cell.frame.size.height);
    [self.cellHeight setObject:height forKey:indexPath];
}
#warning 采用这种传统方法计算行高容易造成更新指定cell时tableView会上下跳
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSNumber *cellHeight = [self.cellHeight objectForKey:indexPath];
//    CGFloat height = cellHeight.floatValue;
//    if (height) {
//        return height;
//    }else
//    
//    return 100;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"mjcell";
    __weak xibCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"xibCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ListModel *model = self.infoArr[indexPath.row];
    cell.model = model;

    __weak typeof (self) weakSelf = self;
    cell.block = ^(xibCell *xibCe, NSInteger tag, NSIndexPath *commentPath){
      
        self.currentCmtIndex = commentPath;
        // 拿到currentModel
        NSIndexPath *currentIndex = [weakSelf.tableView indexPathForCell:xibCe];
        self.currentCellIndex = currentIndex;
        ListModel *currentModel = weakSelf.infoArr[currentIndex.row];
        
        // 当前cell的rect
        CGRect rectInTableView = [weakSelf.tableView rectForRowAtIndexPath:currentIndex];
        
        self.rectSelected = [weakSelf.tableView convertRect:rectInTableView toView:weakSelf.view];
        
        NSLog(@"--%ld--",tag);
        for (UIView *view in [xibCe subviews]) {
            if ([view isKindOfClass:[albumOperateView class]]) {
                [view removeFromSuperview];

            }
        }
        if (tag == 10) {
            
            
        }else if (tag == 1){
            
            NSLog(@"点赞事件");
            NSMutableArray *likesArr = currentModel.likesArr;
            [likesArr addObject:@"你帅帅的爹地郭德纲"];
            currentModel.likesArr = likesArr;
            currentModel.isLike = YES;
            cell.model = currentModel;
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (tag == 2){
            NSLog(@"取消赞--");
            NSMutableArray *likesArr = currentModel.likesArr;
            [likesArr removeObject:@"你帅帅的爹地郭德纲"];
            currentModel.likesArr = likesArr;
            currentModel.isLike = NO;
            cell.model = currentModel;
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        else if (tag == 3){
            
            NSLog(@"评论楼主");
            weakSelf.chatKeyBoard.placeHolder = @"评论";
            [weakSelf.chatKeyBoard keyboardUpforComment];

        }else if(tag == 0){
            NSLog(@"评论第--%ld--条回复",commentPath.row);
            NSMutableArray *array = currentModel.commentArr;
            NSDictionary *commentDict = array[commentPath.row];

            if ([commentDict[@"nickname"] isEqualToString:@"你帅帅的爹地郭德纲"]) {
                
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定删除该条评论？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   
                    [array removeObjectAtIndex:commentPath.row];
                    currentModel.commentArr = array;
                    cell.model = currentModel;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
                    
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                [alertC addAction:action1];
                [alertC addAction:action2];
                [self presentViewController:alertC animated:YES completion:nil];
            }else{
                weakSelf.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",commentDict[@"nickname"]];
                
                [weakSelf.chatKeyBoard keyboardUpforComment];
            }
            
            
        }
        
        
    };
    
    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 移除键盘
    [self.chatKeyBoard keyboardDownForComment];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.chatKeyBoard keyboardDownForComment];
}
#pragma mark -- get
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
-(NSMutableDictionary *)cellHeight{
    if (!_cellHeight) {
        _cellHeight = [NSMutableDictionary dictionary];
    }
    return _cellHeight;
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
        
        NSArray *name = @[@"特立独行的猪",@"小岳岳",@"你帅帅的爹地郭德纲",@"常远",@"宋小宝",@"吴秀波",@"郭麒麟"];
        for (int i = 0; i < 100; i++)
        {
            ListModel *model = [[ListModel alloc] init];
            NSInteger index = (arc4random()%(string.length / 20)) * 20;
            model.desc = [string substringToIndex:MAX(20, index)];
            
            model.title = name[arc4random() % 6];
                        
            model.imagesArr = [[imagesArr subarrayWithRange:NSMakeRange(0, arc4random() % 10)]mutableCopy];
            
            if (i) {
                NSArray *array = @[@"宋小宝",@"吴秀波",@"郭麒麟"];
                model.likesArr = [array mutableCopy];
            }else{
                model.likesArr = [NSMutableArray array];
            }
            
            
            NSDictionary *dict = @{@"nickname":@"吴秀波",@"toNickname":@"",@"content":@"楼主长的真帅-----"};
            NSDictionary *dict1 = @{@"nickname":@"宋小宝",@"toNickname":@"吴秀波",@"content":@"怪我咯傻逼---"};
            NSDictionary *dict2 = @{@"nickname":@"吴秀波",@"toNickname":@"宋小宝",@"content":@"就怪你啊大傻逼---"};
            NSDictionary *dict3 = @{@"nickname":@"常远",@"toNickname":@"",@"content":@"你们都是大傻逼，谁也别让这谁---"};
            NSDictionary *dict4 = @{@"nickname":@"岳云鹏",@"toNickname":@"",@"content":@"人的精神和外貌都改变成这样了，随时随地精神百倍！这些人现在干点啥都发朋友圈，简直都想屏蔽她们---"};
            NSArray *commentArr = [NSArray arrayWithObjects:dict2,dict1,dict,dict3,dict4, nil];
            if (i) {
                model.commentArr = [commentArr mutableCopy];
            }else{
                model.commentArr = [NSMutableArray array];
            }
            
  
            [_infoArr addObject:model];
        }
    }
    return _infoArr;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"CommentViewController dealloc");
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
