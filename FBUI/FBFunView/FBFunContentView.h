//
//  FBFunMenuView.h
//  Face Beauty
//
//  Created by Kyle on 2025/3/6.
//

#import <UIKit/UIKit.h>
#import "FBUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBFunContentView : UIView

@property (nonatomic, copy) void (^onUpdateSliderHiddenBlock)(FBModel *model,NSInteger index);

@property (nonatomic, assign) FBARItemTypes type;
@property (nonatomic, assign) BOOL isThemeWhite;
/**
 *  通知外部弹框
 */
@property (nonatomic, copy) void (^filterTipBlock)(void);


@end

NS_ASSUME_NONNULL_END
