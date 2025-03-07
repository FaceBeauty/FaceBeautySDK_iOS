//
//  FBSliderRelatedView.h
//  FaceBeautyDemo
//

#import <UIKit/UIKit.h>
#import "FBSliderView.h"

@interface FBSliderRelatedView : UIView

// 自定义Slider
@property (nonatomic, strong) FBSliderView *sliderView;

- (void)setSliderHidden:(BOOL)hidden;

@property (nonatomic, assign) BOOL isThemeWhite;

@end
