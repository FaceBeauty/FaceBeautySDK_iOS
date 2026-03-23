//
//  FBGestureEffectView.h
//  FaceBeautyDemo
//
//  Created by MBPC001 on 2023/4/17.
//

#import <UIKit/UIKit.h>
#import "FBUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBGestureEffectView : UIView

@property (nonatomic, copy) void(^didSelectedModelBlock)(FBModel *model,NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

/**
 * 外部点击menu选项后刷新CollectionView
 *
 * @param dic 数据
 */
- (void)updateGestureDataWithDict:(NSDictionary *)dic;

/**
 * 重置选中状态
 */
- (void)resetSelectedState;

@end

NS_ASSUME_NONNULL_END
