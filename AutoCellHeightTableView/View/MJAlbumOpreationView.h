//
//  MJAlbumOpreationView.h
//  AutoCellHeightTableView
//
//  Created by none on 17/2/14.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJAlbumOpreationView;

typedef enum : NSUInteger{
    MJAlbumOperationTypeLike=0,
    MJAlbumOperationTypeReply
}MJAlbumOperationType;

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define MJAlbumOperationViewWidth  (kScreenWidth == 320 ? 150 : 180)
#define MJAlbumOperationViewHeight 34



@protocol MJAlbumOpreationViewDelegate <NSObject>

@optional
-(void)albumOperationView:(MJAlbumOpreationView*)albumOperationView didClickOfType:(MJAlbumOperationType)operationType;

@end

@interface MJAlbumOpreationView : UIView

@property (nonatomic,assign) BOOL shouldShowed;

@property(assign,nonatomic)id<MJAlbumOpreationViewDelegate> albumOperationViewDelegate;

+(instancetype)initialOperationView;

-(void)showAtView:(UIView*)containerView rect:(CGRect)targetRect;

-(void)dismiss;

@end
