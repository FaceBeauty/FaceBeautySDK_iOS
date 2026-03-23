//
//  FBBtBodyView.h
//  FaceBeautyDemo
//
//  Created by Eddie on 2023/9/11.
//

#import <UIKit/UIKit.h>
@class FBModel;
NS_ASSUME_NONNULL_BEGIN
/**
 *
 *  美体视图
 *
 */
@interface FBBtBodyView : UIView

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, assign) BOOL isThemeWhite;

/**
 * 通知外部弹出提示框
 */
@property (nonatomic, copy) void(^bodyShowAlertBlock)(void);

/**
 * 通知外部弹出拉条并设置效果特效
 */
@property (nonatomic, copy) void(^bodyDidSelectedBlock)(FBModel *model);

/**
 *  外部menu点击后的刷新collectionview
 */
- (void)updateBodyEffectData:(NSArray *)listArray;

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
