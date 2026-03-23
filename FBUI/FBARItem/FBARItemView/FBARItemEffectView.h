//
//  FBARItemEffectView.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import <UIKit/UIKit.h>
#import "FBUIConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    AR道具功能视图
 
 */
@interface FBARItemEffectView : UIView

@property (nonatomic, assign) FBARItemTypes itemType;
@property (nonatomic, strong) NSMutableArray *listArr;

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;


@property (nonatomic, copy) void (^arDownladCompleteBlock)(NSInteger index);


/**
 * 清除特效
 */
-(void)clean;

/**
 * 外部点击menu选项后刷新CollectionView
 *
 * @param dic 数据
 */
- (void)updateDataWithDict:(NSDictionary *)dic;

@end



NS_ASSUME_NONNULL_END
