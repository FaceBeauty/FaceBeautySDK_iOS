//
//  FBFilterEffectView.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import <UIKit/UIKit.h>
#import "FBUIConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    滤镜 功能视图
 
 */

@interface FBFilterEffectView : UIView

@property (nonatomic, copy) void (^onUpdateSliderHiddenBlock)(FBModel *model,NSInteger index);
// FB内部模块拆开展示，重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr filterType:(FBFilterType)filterType;

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, assign) BOOL isThemeWhite;

// 外部menu点击后刷新collectionview
- (void)updateFilterListData:(NSDictionary *)dic;

/**
 *  通知外部弹框
 */
@property (nonatomic, copy) void (^filterTipBlock)(void);

@end

NS_ASSUME_NONNULL_END
