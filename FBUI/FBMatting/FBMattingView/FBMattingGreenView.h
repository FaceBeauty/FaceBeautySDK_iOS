//
//  FBMattingGreenView.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2023/4/12.
//

#import <UIKit/UIKit.h>
@class FBModel;
NS_ASSUME_NONNULL_BEGIN
/**
 
 AI抠图的绿幕视图
 
 */
@interface FBMattingGreenView : UIView

/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

/**
 * ??? 旧方法
 */
@property (nonatomic, copy) void (^mattingGreenDownladCompleteBlock)(NSInteger index);

/**
 * 编辑滑条更新
 */
@property (nonatomic,copy) void (^mattingSliderHiddenBlock)(BOOL show, FBModel *model);

/**
 * 通知外部弹出提示框
 */
@property (nonatomic, copy) void(^mattingShowAlertBlock)(void);

/**
 * 通知外部弹出提示框
 */
@property (nonatomic, copy) void(^mattingDidSelectedBlock)(FBModel *model);

/**
 * 是否展示滑条
 */
- (void)showOrHideSilder;

/**
 * 恢复按钮是否可以点击
 */
- (void)checkRestoreButton;

/**
 * 恢复默认值
 */
- (void)restore;

/**
 * 重置选中状态
 */
- (void)resetSelectedState;

@end

NS_ASSUME_NONNULL_END
