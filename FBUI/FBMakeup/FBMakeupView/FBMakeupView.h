//
//  FBMakeupView.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2023/03/30.
//

#import <UIKit/UIKit.h>
#import "FBUIConfig.h"
#import "FBSliderRelatedView.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    美颜Base视图
 
 */
@interface FBMakeupView : UIView

// 滑动条相关View
@property (nonatomic, strong) FBSliderRelatedView *sliderRelatedView;

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
