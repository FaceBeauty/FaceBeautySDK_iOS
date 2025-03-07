//
//  FBUIConfig.h
//  FaceBeautyDemo
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import "FBAdapter.h"
#import <FaceBeauty/FaceBeautyView.h>
#import <FaceBeauty/FaceBeautyInterface.h>
#import "FBUIColor+ColorChange.h"
#import "FBModel.h"
#import "MJHUD.h"

NS_ASSUME_NONNULL_BEGIN


/* 非3D采集界面用来记录返回按钮点击缓存，第一次点击退出后，第二次进入不再进行所有特效参数的初始化 */
static NSString * _Nullable const FB_ALL_EFFECT_CACHES = @"FB_ALL_EFFECT_CACHES";


/* 美颜模块用来记录选中位置信息缓存 */
static NSString * const FB_HAIR_SELECTED_POSITION = @"FB_HAIR_SELECTED_POSITION";
static NSString * const FB_LIGHT_MAKEUP_SELECTED_POSITION = @"FB_LIGHT_MAKEUP_SELECTED_POSITION";
static NSString * const FB_MAKEUP_STYLE_NAME = @"FB_MAKEUP_STYLE_NAME";
static NSString * const FB_MAKEUP_STYLE_SLIDER  = @"FB_MAKEUP_STYLE_SLIDER";

/* AR道具模块用来记录选中位置信息缓存 */
static NSString * const FB_ARITEM_STICKER_POSITION  = @"FB_ARITEM_STICKER_POSITION";
static NSString * const FB_ARITEM_MASK_POSITION  = @"FB_ARITEM_MASK_POSITION";
static NSString * const FB_ARITEM_GIFT_POSITION  = @"FB_ARITEM_GIFT_POSITION";
static NSString * const FB_ARITEM_WATERMARK_POSITION  = @"FB_ARITEM_WATERMARK_POSITION";
static  NSString * _Nonnull const FB_ARITEM_POSITION_MAP[4] = {
    [0] = FB_ARITEM_STICKER_POSITION,
    [1] = FB_ARITEM_MASK_POSITION,
    [2] = FB_ARITEM_GIFT_POSITION,
    [3] = FB_ARITEM_GIFT_POSITION,
};

/* AI抠图模块用来记录选中位置信息缓存 */
static NSString * const FB_MATTING_AI_POSITION  = @"FB_MATTING_AI_POSITION";
static NSString * const FB_MATTING_GS_POSITION  = @"FB_MATTING_GS_POSITION";

//* 手势特效用来记录选中位置信息缓存 */
static NSString * const FB_GESTURE_SELECTED_POSITION  = @"FB_GESTURE_SELECTED_POSITION";

//* 滤镜模块用来记录选中位置信息缓存 */
static NSString * const FB_STYLE_FILTER_NAME  = @"FB_STYLE_FILTER_NAME";
static NSString * const FB_STYLE_FILTER_SELECTED_POSITION  = @"FB_STYLE_FILTER_SELECTED_POSITION";
static NSString * const FB_EFFECT_FILTER_SELECTED_POSITION  = @"FB_EFFECT_FILTER_SELECTED_POSITION";
static NSString * const FB_HAHA_FILTER_SELECTED_POSITION  = @"FB_HAHA_FILTER_SELECTED_POSITION";
static  NSString * _Nonnull const FB_FILTER_POSITION_MAP[3] = {
    [0] = FB_STYLE_FILTER_SELECTED_POSITION,
    [1] = FB_EFFECT_FILTER_SELECTED_POSITION,
    [2] = FB_HAHA_FILTER_SELECTED_POSITION
};

/* 切换幕布模块用来记录选中位置信息缓存 */
static NSString * const FB_MATTING_SWITCHSCREEN_POSITION  = @"FB_MATTING_SWITCHSCREEN_POSITION";


/* 滤镜模块用来记录Value值信息缓存 */
static NSString * const FB_STYLE_FILTER_SLIDER  = @"FB_STYLE_FILTER_SLIDER";
static NSString * const FB_EFFECT_FILTER_SLIDER  = @"FB_EFFECT_FILTER_SLIDER";
static NSString * const FB_HAHA_FILTER_SLIDER  = @"FB_HAHA_FILTER_SLIDER";
/* 美颜模块的SLIDER Key在json文件中配置 */


@interface FBUIConfig : NSObject

#pragma mark -- UI保存参数时对应滑动条的键值枚举
typedef NS_ENUM(NSInteger, FBDataCategoryType) {
    FB_SKIN_SLIDER = 0,     // 美肤滑动条
    FB_RESHAPE_SLIDER = 1,  // 美型滑动条
    FB_FILTER_SLIDER = 2,   // 滤镜滑动条
    FB_HAIR_SLIDER = 3,
    FB_MAKEUP_SLIDER = 4,
    FB_BODY_SLIDER = 5,
};


typedef NS_ENUM(NSInteger, FBARItemType) {
    FB_Sticker = 0,
    FB_Mask = 1,
    FB_Gift = 2,
    FB_WaterMark = 3,
};


@end

#ifndef FB_CONFIG_H
#define FB_CONFIG_H

//主色调
//#define MAIN_COLOR [UIColor colorWithRed:170/255.0 green:242/255.0 blue:0/255.0 alpha:1.0]
#define MAIN_COLOR [UIColor colorWithRed:56/255.0 green:168/255.0 blue:255/255.0 alpha:1.0]
#define COVER_COLOR [UIColor colorWithRed:198/255.0 green:161/255.0 blue:134/255.0 alpha:0.8]

#define FBColor(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define FBColors(s,a) [UIColor colorWithRed:((s) / 255.0) green:((s) / 255.0) blue:((s) / 255.0) alpha:(a)]

#define FBFontRegular(s) [UIFont fontWithName:@"PingFang-SC-Regular" size:s]
#define FBFontMedium(s) [UIFont fontWithName:@"PingFang-SC-Medium" size:s]

#define FBWidth(width) [[FBAdapter shareInstance] getAfterAdaptionWidth:width]
#define FBHeight(height) [[FBAdapter shareInstance] getAfterAdaptionHeight:height]

#define FBSkinBeautyPath [[NSBundle mainBundle] pathForResource:@"FBSkinBeauty" ofType:@"json"]
#define FBFaceBeautyPath [[NSBundle mainBundle] pathForResource:@"FBFaceBeauty" ofType:@"json"]
#define FBMakeupBeautyPath [[NSBundle mainBundle] pathForResource:@"FBMakeupBeauty" ofType:@"json"]
#define FBBodyBeautyPath [[NSBundle mainBundle] pathForResource:@"FBBodyBeauty" ofType:@"json"]

// 防止block的循环引用
#define WeakSelf __weak typeof(self) weakSelf = self;
/************************* Seperate Line ****************************/
 

// 滤镜滑动条默认参数
#define FilterStyleDefaultName @"ziran2"
#define FilterStyleDefaultPositionIndex 2



// 屏幕尺寸相关
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define kSafeAreaBottom \
^(){\
   if (@available(iOS 11.0, *)) {\
     return  (CGFloat)UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;\
    } else {\
     return  (CGFloat)0.f;\
    }\
}()

#define SafeAreaTopHeight (IPHONE_X ? 88 : 64)

#define SafeAreaBottomHeight (IPHONE_X ? (49 + 34) : 49)





#endif /* FB_CONFIG_H */


NS_ASSUME_NONNULL_END
