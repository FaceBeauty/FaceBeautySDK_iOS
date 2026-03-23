//
//  FBARItemEffectViewCell.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import <UIKit/UIKit.h>
#import "FBModel.h"
#import "FBUIConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface FBARItemEffectViewCell : UICollectionViewCell
 
@property (nonatomic, strong) FBModel *model;

-(void)setModel:(FBModel *)model effectType:(FBARItemType)type index:(NSInteger)index;
//是否正在编辑
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, copy) void (^longPressEditBlock)(NSInteger index);
@property (nonatomic, copy) void (^editDeleteBlock)(NSInteger index);

//@property (nonatomic, strong,readonly) UIImageView *htImageView;
//- (void)setHtImage:(UIImage * _Nullable)image isCancelEffect:(BOOL)isCancelEffect;
//- (void)startAnimation;
//- (void)endAnimation;
//- (void)setSelectedBorderHidden:(BOOL)hidden borderColor:(UIColor *)color;
//- (void)hiddenDownloaded:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
