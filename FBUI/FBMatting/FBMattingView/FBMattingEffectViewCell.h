//
//  FBMattingEffectViewCell.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import <UIKit/UIKit.h>
#import "FBModel.h"
#import "FBUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBMattingEffectViewCell : UICollectionViewCell

@property (nonatomic, strong,readonly) UIImageView *htImageView;
- (void)setHtImage:(UIImage *_Nullable)image isCancelEffect:(BOOL)isCancelEffect;
- (void)startAnimation;
- (void)endAnimation;
- (void)setSelectedBorderHidden:(BOOL)hidden borderColor:(UIColor *)color;
- (void)hiddenDownloaded:(BOOL)hidden;


@property (nonatomic, strong) FBModel *model;
- (void)setDataArray:(NSArray *)dataArray index:(NSInteger)index;
//是否正在编辑
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) void (^longPressEditBlock)(NSInteger index);
@property (nonatomic, copy) void (^editDeleteBlock)(NSInteger index);


@end

NS_ASSUME_NONNULL_END
