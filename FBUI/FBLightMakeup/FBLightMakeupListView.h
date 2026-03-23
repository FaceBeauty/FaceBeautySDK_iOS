//
//  FBLightMakeupListView.h
//  FaceBeautyDemo
//
//  Created by Kyle on 2026/1/28.
//

#import <UIKit/UIKit.h>
#import "FBUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBLightMakeupListView : UIView

@property (nonatomic, copy) void (^beautyHairBlock)(FBModel *model, NSString *key);

@property (nonatomic, assign) BOOL isThemeWhite;
- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@end

NS_ASSUME_NONNULL_END
