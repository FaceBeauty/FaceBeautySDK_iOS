//
//  FBMattingMenuView.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import <UIKit/UIKit.h>
#import "FBMattingView.h"

NS_ASSUME_NONNULL_BEGIN
/**

    人像分割顶部视图

 */
@interface FBMattingMenuView : UIView

@property (nonatomic, copy) void (^mattingOnClickBlock)(NSArray *array,NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr type:(FBMattingType)type;

@property (nonatomic, strong) NSArray *listArr;

@property (nonatomic, assign) FBMattingType mattingType;

@end

NS_ASSUME_NONNULL_END
