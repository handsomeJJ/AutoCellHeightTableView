//
//  publishNewViewController.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/22.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "publishNewViewController.h"
#import "UploadImageTool.h"
#import "HX_AddPhotoView.h"
#import "MJTextView.h"
#import "HX_AssetManager.h"
#import "MBProgressHUD.h"
#import "ListModel.h"

#pragma mark -- 屏幕宽高
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height
#define padding 20
#define QiNiuBaseUrl @"http://olrax8cua.bkt.clouddn.com/"


@interface publishNewViewController ()<UITextViewDelegate>
@property(weak,nonatomic)MJTextView *textView;
@property(weak,nonatomic)UIScrollView *bgScrollV;
@property(weak,nonatomic)HX_AddPhotoView *photoView;

@property(strong,nonatomic)NSMutableArray *uploadPhotoArr;
@property(strong,nonatomic)NSMutableArray *imageUrlArr;

@end

@implementation publishNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];

}
- (void)dealloc{

    [HX_AssetManager sharedManager].selectedPhotos = nil;
}
-(void)configUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *bgScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    bgScrollV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    bgScrollV.showsVerticalScrollIndicator = YES;
    bgScrollV.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgScrollV];
    self.bgScrollV = bgScrollV;
    
    MJTextView *textView = [[MJTextView alloc]initWithFrame:CGRectMake(padding, padding, kScreenWidth - padding * 2, 60)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholderText = @"说点什么呗...";
    [bgScrollV addSubview:textView];
    self.textView = textView;
    
    CGFloat photoVY = CGRectGetMaxY(textView.frame)+padding+64;
    HX_AddPhotoView *photoView = [[HX_AddPhotoView alloc]initWithMaxPhotoNum:9 WithSelectType:SelectPhoto];
    photoView.frame = CGRectMake(padding, photoVY, kScreenWidth - padding*2, 0);
//    photoView.customName = @"circleDemo";
    photoView.lineNum = 3;
    self.photoView = photoView;
    [self.bgScrollV addSubview:photoView];
    
    
    UIImage *image = [UIImage imageNamed:@"theFirstImage"];
    
    // 上传文件
//    NSString *token = [UploadImageTool getToken];
//    QNUploadManager *uploadM = [[QNUploadManager alloc]init];
//    
//    NSDictionary *dict = @{@"name":@"lmj",@"time":@"2.22"};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    
//    [uploadM putData:data key:@"111" token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        
//        NSLog(@"info = %@\n", info);
//        NSLog(@"key = %@\n",key);
//        NSLog(@"resp = %@\n", resp);
//        
//        
//    } option:nil];
    
    // 图片单张上传
//    [UploadImageTool uploadImage:image progress:^(NSString *key, float percent) {
//        
//        NSLog(@"--key--%@--percent--%f",key,percent);
//        
//    } success:^(NSString *url) {
//        
//        NSLog(@"--上传成功 url--%@",url);
//        
//    } failure:^{
//        
//        NSLog(@"--上传失败了--");
//    }];
    
    //多张上传
//    NSArray *imageArr = @[image,image,image];
//    
//    [UploadImageTool uploadImages:imageArr progress:^(CGFloat progress) {
//        
//        NSLog(@"qi niu --%f",progress);
//        
//    } success:^(NSArray *urlArr) {
//        
//        NSLog(@"qi niu --%@",urlArr);
//        
//    } failure:^{
//        
//        NSLog(@" --->> error:   ");
//        
//    }];
    
}
#pragma marl -- publishAction{
-(void)publishAction{
    
    NSArray *photoArr = [HX_AssetManager sharedManager].selectedPhotos;
    for (HX_PhotoModel *model in photoArr) {
        
        [self.uploadPhotoArr addObject:model.image];
    }

    if (self.uploadPhotoArr.count) {
        [self upLoadImageList:self.uploadPhotoArr];
    }else{
        [self publishNewWithImages:nil];
    }
    
}
-(void)publishNewWithImages:(NSArray *)imagesArr{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"imagesArr"] = imagesArr;
    dict[@"desc"] = self.textView.text;
    dict[@"title"] = @"并没有title";
    dict[@"likesArr"] = [NSMutableArray array];
    dict[@"commentArr"] = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUBLISHNEW" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 上传多图
- (void)upLoadImageList:(NSArray *)imageList{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"上传大图中...";
    
    [UploadImageTool uploadImages:imageList progress:^(CGFloat progress) {

        NSLog(@"qi niu --%f",progress);

    } success:^(NSArray *urlArr) {

        NSLog(@"qi niu --%@",urlArr);
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self publishNewWithImages:urlArr];
        
    } failure:^{

        NSLog(@" --->> error:   ");
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
    /*
    NSMutableArray *urlList = [NSMutableArray array];
    __block int getSuccessful = 0;
    __block int getFail = 0;
    //全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_apply([imageList count], queue, ^(size_t index) {
       
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
           
            // 上传文件名由 时间+随机8位字符组成
            NSString *key = [NSString stringWithFormat:@"%@_%@.png", [UploadImageTool getDateTimeString], [UploadImageTool randomStringWithLength:8]];
            // 上传token
            NSString *token = [UploadImageTool getToken];
            
            PHAsset *asset = imageList[index];
            QNUploadManager *manager = [[QNUploadManager alloc]init];
            [manager putPHAsset:asset key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                if (!info.error) {
                    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",QiNiuBaseUrl,key];
                    [urlList addObject:imageUrl];
                    getSuccessful ++;
                    NSLog(@"imageurl  getSuccessful >>>> %@ >>> ",imageUrl);
                    dispatch_group_leave(group);
                }else{
                    NSString *imageUrl = [NSString stringWithFormat:@"error%zd",index];
                    [urlList addObject:imageUrl];
                    getFail++;
                    NSLog(@"imageurl  getFail >>>> %@ >>> ",imageUrl);
                    dispatch_group_leave(group);
                }
            } option:nil];
            
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
           
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //根据数据里面的 url 如果是error的话，那就说明该图片没上传完成
            NSLog(@"全部上传完成 >>> %@",urlList);
            [self publishNewWithImages:urlList];
            
        });
        
        
    });
    
     */
}


#pragma mark -- textView delegate
-(void)textViewDidChange:(UITextView *)textView{
    NSString *text = textView.text;
    CGFloat height = [text boundingRectWithSize:CGSizeMake(kScreenWidth - padding * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    NSLog(@"--height--%f",height);
    if (height > 60 && height <= 200) {
        self.textView.frame = CGRectMake(padding, padding, kScreenWidth - padding * 2, height);
        CGFloat photoVY = CGRectGetMaxY(self.textView.frame) + 64 + padding;
        self.photoView.frame = CGRectMake(padding, photoVY, kScreenWidth - padding * 2, 0);
    }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)uploadPhotoArr{
    if (!_uploadPhotoArr) {
        _uploadPhotoArr = [NSMutableArray array];
    }
    return _uploadPhotoArr;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
