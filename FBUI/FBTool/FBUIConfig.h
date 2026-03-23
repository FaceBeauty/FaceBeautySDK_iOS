//
//  FBUIConfig.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
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

/* 美妆模块用来记录颜色选中位置 */
static NSString * const FB_MAKEUP_LIPSTICK_POSITION = @"HT_MAKEUP_LIPSTICK_POSITION";
static NSString * const FB_MAKEUP_BLUSH_POSITION    = @"HT_MAKEUP_BLUSH_POSITION";
static NSString * const FB_MAKEUP_EYEBROW_POSITION  = @"HT_MAKEUP_EYEBROW_POSITION";
static  NSString * _Nonnull const FB_MAKEUP_POSITION_MAP[3] = {
    [0] = FB_MAKEUP_LIPSTICK_POSITION,
    [1] = FB_MAKEUP_BLUSH_POSITION,
    [2] = FB_MAKEUP_EYEBROW_POSITION
};

/* 非3D采集界面用来记录返回按钮点击缓存，第一次点击退出后，第二次进入不再进行所有特效参数的初始化 */
static NSString * _Nullable const FB_ALL_EFFECT_CACHES = @"FB_ALL_EFFECT_CACHES";

/* AI抠图模块用来记录绿幕背景色选中位置信息缓存 */
static NSString * _Nullable const FBMattingScreenGreen  = @"#00ff00";
static NSString * _Nullable const FBMattingScreenBlue   = @"#0000ff";
static NSString * _Nullable const FBMattingScreenRed    = @"#ff0000";
// 这个是 Map NSString * 类型的数组
static  NSString * _Nonnull const FBScreenCurtainColorMap[3] = {
    [0] = FBMattingScreenGreen,
    [1] = FBMattingScreenBlue,
    [2] = FBMattingScreenRed
};

/* 美颜模块用来记录选中位置信息缓存 */
static NSString * const FB_HAIR_SELECTED_POSITION = @"HT_HAIR_SELECTED_POSITION";
static NSString * const FB_LIGHT_MAKEUP_SELECTED_POSITION = @"HT_LIGHT_MAKEUP_SELECTED_POSITION";
static NSString * const FB_MAKEUP_STYLE_NAME = @"HT_MAKEUP_STYLE_NAME";
static NSString * const FB_MAKEUP_STYLE_SLIDER  = @"HT_MAKEUP_STYLE_SLIDER";

/* AR道具模块用来记录选中位置信息缓存 */
static NSString * const FB_ARITEM_STICKER_POSITION  = @"HT_ARITEM_STICKER_POSITION";
static NSString * const FB_ARITEM_MASK_POSITION  = @"HT_ARITEM_MASK_POSITION";
static NSString * const FB_ARITEM_GIFT_POSITION  = @"HT_ARITEM_GIFT_POSITION";
static NSString * const FB_ARITEM_WATERMARK_POSITION  = @"HT_ARITEM_WATERMARK_POSITION";
static  NSString * _Nonnull const FB_ARITEM_POSITION_MAP[4] = {
    [0] = FB_ARITEM_STICKER_POSITION,
    [1] = FB_ARITEM_MASK_POSITION,
    [2] = FB_ARITEM_GIFT_POSITION,
    [3] = FB_ARITEM_GIFT_POSITION,
};

/* AI抠图模块用来记录选中位置信息缓存 */
static NSString * const FB_MATTING_AI_POSITION  = @"HT_MATTING_AI_POSITION";
static NSString * const FB_MATTING_GS_POSITION  = @"HT_MATTING_GS_POSITION";

//* 手势特效用来记录选中位置信息缓存 */
static NSString * const FB_GESTURE_SELECTED_POSITION  = @"HT_GESTURE_SELECTED_POSITION";

//* 滤镜模块用来记录选中位置信息缓存 */
static NSString * const FB_STYLE_FILTER_NAME  = @"HT_STYLE_FILTER_NAME";
static NSString * const FB_STYLE_FILTER_SELECTED_POSITION  = @"HT_STYLE_FILTER_SELECTED_POSITION";
static NSString * const FB_EFFECT_FILTER_SELECTED_POSITION  = @"HT_EFFECT_FILTER_SELECTED_POSITION";
static NSString * const FB_HAHA_FILTER_SELECTED_POSITION  = @"HT_HAHA_FILTER_SELECTED_POSITION";
static  NSString * _Nonnull const FB_FILTER_POSITION_MAP[3] = {
    [0] = FB_STYLE_FILTER_SELECTED_POSITION,
    [1] = FB_EFFECT_FILTER_SELECTED_POSITION,
    [2] = FB_HAHA_FILTER_SELECTED_POSITION
};

/* 切换幕布模块用来记录选中位置信息缓存 */
static NSString * const FB_MATTING_SWITCHSCREEN_POSITION  = @"HT_MATTING_SWITCHSCREEN_POSITION";


/* 滤镜模块用来记录Value值信息缓存 */
static NSString * const FB_STYLE_FILTER_SLIDER  = @"HT_STYLE_FILTER_SLIDER";
static NSString * const FB_EFFECT_FILTER_SLIDER  = @"HT_EFFECT_FILTER_SLIDER";
static NSString * const FB_HAHA_FILTER_SLIDER  = @"HT_HAHA_FILTER_SLIDER";
/* 美颜模块的SLIDER Key在json文件中配置 */

/* 3D模块用来记录选中位置信息缓存 */
static NSString * const FB_3D_SELECTED_POSITION  = @"HT_3D_SELECTED_POSITION";


@interface FBUIConfig : NSObject

#pragma mark -- UI保存参数时对应滑动条的键值枚举
typedef NS_ENUM(NSInteger, FBDataCategoryType) {
    FB_SKIN_SLIDER    = 0, // 美肤滑动条
    FB_RESHAPE_SLIDER = 1, // 美型滑动条
    FB_FILTER_SLIDER  = 2, // 滤镜滑动条
    FB_HAIR_SLIDER    = 3, // 美发滑动条
    FB_MAKEUP_SLIDER  = 4, // 美妆滑动条
    FB_BODY_SLIDER    = 5, // 美体滑动条
    FB_STYLE_SLIDER   = 6, // 妆容推荐滑动条
    FB_LIGHTMAKEUP_SLIDER , //轻彩妆滑动条
    FB_FACESHAPE_SLIDER     ,//脸型滑动条
};

/**
 * AR道具类型枚举
 */
typedef NS_ENUM(NSInteger, FBARItemType) {
    FB_Sticker   = 0, // 贴纸
    FB_Mask      = 1, // 面具
    FB_Gift      = 2, // 礼物
    FB_WaterMark = 3, // 水印
};

/**
 * 滤镜类型枚举
 */
typedef NS_ENUM(NSInteger, FBFilterType) {
    FB_Filter_Beauty = 0, // 风格滤镜
    FB_Filter_Effect = 1, // 特效滤镜
    FB_Filter_Funny  = 2  // 哈哈镜
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
#define FBFaceShapePath [[NSBundle mainBundle] pathForResource:@"FBFaceShape" ofType:@"json"]
#define FBMakeupBeautyPath [[NSBundle mainBundle] pathForResource:@"FBMakeupBeauty" ofType:@"json"]
#define FBBodyBeautyPath [[NSBundle mainBundle] pathForResource:@"FBBodyBeauty" ofType:@"json"]

// 防止block的循环引用
#define WeakSelf __weak typeof(self) weakSelf = self;
/************************* Seperate Line ****************************/
 

// 滤镜滑动条默认参数
#define FilterStyleDefaultName @"zhigan1"
#define FilterStyleDefaultPositionIndex 1



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
     return  (CGFloat)[[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;\
    } else {\
     return  (CGFloat)0.f;\
    }\
}()

#define SafeAreaTopHeight (IPHONE_X ? 88 : 64)

#define SafeAreaBottomHeight (IPHONE_X ? (49 + 34) : 49)


/// 尺寸相关

// 滑动条视图高度
#define kSliderViewHeight FBHeight(53)
// 菜单视图高度
#define kMenuViewHeight FBHeight(45)

// 模块功能视图高度
#define kBeautyViewHeight FBHeight(236)  // 美颜容器视图高度
#define kHairViewHeight FBHeight(200)  // 美发容器视图高度
#define kBodyViewHeight FBHeight(236+53)  // 美体容器视图高度
//#define kFilterViewHeight FBHeight(236)  // 滤镜容器视图高度
#define kFilterViewHeight FBHeight(120)  // 滤镜容器视图高度
#define kGestureViewHeight FBHeight(236)  // 手势容器视图高度
#define kMakeupViewHeight FBHeight(236+28)  // 美妆容器视图高度
//#define kARItemViewHeight FBHeight(278)  // AR道具视图高度
#define kARItemViewHeight FBHeight(120)  // AR道具视图高度
#define kFunViewHeight FBHeight(120)  // 美妆容器视图高度
#define kMattingViewHeight FBHeight(353)  // 抠图视图高度

// 各模块容器视图高度
//#define kContainerHeightBeauty FBHeight(258)  // 美颜容器视图高度
//#define kContainerHeightHair FBHeight(258)  // 美发容器视图高度
//#define kContainerHeightBody FBHeight(258)  // 美体容器视图高度
//#define kContainerHeightFilter FBHeight(258)  // 滤镜容器视图高度
//#define kContainerHeightGesture FBHeight(258)  // 手势容器视图高度
//#define kContainerHeightMakeup FBHeight(258)  // 美妆容器视图高度
//#define kContainerHeightFun FBHeight(258)  // 贴纸、面具、礼物、水印容器视图高度

#define kContainerHeightBeauty FBHeight(236)  // 美颜容器视图高度
#define kContainerHeightHair FBHeight(200)  // 美发容器视图高度
#define kContainerHeightBody FBHeight(236)  // 美体容器视图高度
#define kContainerHeightFilter FBHeight(120)  // 滤镜容器视图高度
#define kContainerHeightGesture FBHeight(236)  // 手势容器视图高度
#define kContainerHeightMakeup FBHeight(236+28)  // 美妆容器视图高度
#define kContainerHeightFun FBHeight(120)  // 贴纸、面具、礼物、水印容器视图高度
#define kContainerHeightMatting FBHeight(353)  // 抠图视图高度

// 拍照按钮的宽高
#define kCaptureViewWH FBWidth(80)

// 效果点击提示弹框视图距离功能视图的间距
#define kMarginBetweenToastAndFunctionView FBHeight(40)

#endif /* FB_CONFIG_H */


NS_ASSUME_NONNULL_END
