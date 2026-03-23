//
//  FBFilterView.h
//  FaceBeautyDemo
//
//  Created by MBPC001 on 2023/3/30.
//

#import <UIKit/UIKit.h>
#import "FBSliderRelatedView.h"
#import "FBUIConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    滤镜视图
 
 */
@interface FBFilterView : UIView

// FB内部模块拆开展示，重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame filterType:(FBFilterType)filterType;

// 滑动条相关View
@property (nonatomic, strong) FBSliderRelatedView *sliderRelatedView;
//@property (nonatomic, copy) void(^filterBackBlock)(void);

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
