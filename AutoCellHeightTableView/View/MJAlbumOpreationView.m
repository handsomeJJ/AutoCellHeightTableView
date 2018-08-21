//
//  MJAlbumOpreationView.m
//  AutoCellHeightTableView
//
//  Created by none on 17/2/14.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "MJAlbumOpreationView.h"

@interface MJAlbumOpreationView ()
@property(strong,nonatomic)UIButton *likeButton;
@property(strong,nonatomic)UIButton *replyButton;
@property(assign,nonatomic)CGRect targetRect;
@end

@implementation MJAlbumOpreationView
+(instancetype)initialOperationView{
    MJAlbumOpreationView* operationView=[[MJAlbumOpreationView alloc] initWithFrame:CGRectZero];
    return operationView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.8];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self addSubview:self.likeButton];
        [self addSubview:self.replyButton];
    }
    return self;
}
-(UIButton*)likeButton{
    if(_likeButton==nil){
        _likeButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, MJAlbumOperationViewWidth/2, MJAlbumOperationViewHeight)];
        _likeButton.tag = MJAlbumOperationTypeLike;
        _likeButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_likeButton addTarget:self action:@selector(operationViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

-(UIButton*)replyButton{
    if(_replyButton==nil){
        _replyButton=[[UIButton alloc] initWithFrame:CGRectMake(MJAlbumOperationViewWidth/2, 0, MJAlbumOperationViewWidth/2, MJAlbumOperationViewHeight)];
        _replyButton.tag = MJAlbumOperationTypeReply;
        _replyButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_replyButton addTarget:self action:@selector(operationViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyButton;
}
-(void)operationViewDidClick:(UIButton*)sender{
    [self.albumOperationViewDelegate albumOperationView:self didClickOfType:sender.tag];
}
-(void)showAtView:(UIView*)containerView rect:(CGRect)targetRect{
    if(_shouldShowed){
        return;
    }
    _shouldShowed=YES;
    self.targetRect=targetRect;
    [containerView addSubview:self];
    
    self.frame=CGRectMake(targetRect.origin.x, targetRect.origin.y, 0, MJAlbumOperationViewHeight);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame=CGRectMake(targetRect.origin.x-MJAlbumOperationViewWidth, targetRect.origin.y, MJAlbumOperationViewWidth, MJAlbumOperationViewHeight);
    } completion:^(BOOL finished) {
        [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"AlbumLike"] forState:UIControlStateNormal];
        [_replyButton setTitle:@"评论" forState:UIControlStateNormal];
        [_replyButton setImage:[UIImage imageNamed:@"AlbumComment"] forState:UIControlStateNormal];
    }];
}

-(void)dismiss{
    if(self.shouldShowed==NO){
        return;
    }
    self.shouldShowed=NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame=CGRectMake(_targetRect.origin.x, _targetRect.origin.y, 0, MJAlbumOperationViewHeight);
    } completion:^(BOOL finished) {
        [_likeButton setTitle:nil forState:UIControlStateNormal];
        [_replyButton setTitle:nil forState:UIControlStateNormal];
        [self removeFromSuperview];
    }];
}

@end
