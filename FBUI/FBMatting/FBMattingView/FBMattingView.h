//
//  FBMattingView.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FBMattingType) {
    FBMattingTypeSegmentation = 0,  // 人像分割
    FBMattingTypeChromaKeying = 1   // 绿幕抠图
};

/**

    AI抠图 视图

 */
@interface FBMattingView : UIView

/**
 * 指定类型初始化
 */
- (instancetype)initWithFrame:(CGRect)frame type:(FBMattingType)type;

/**
 * 重置选中状态
 */
- (void)resetSelectedState;

@end

NS_ASSUME_NONNULL_END
