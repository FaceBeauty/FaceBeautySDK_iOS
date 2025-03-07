//
//  FBFilterHahaViewCell.h
//  FaceBeautyDemo
//
//  Created by Eddie on 2023/4/6.
//

#import <UIKit/UIKit.h>
#import "FBButton.h"
#import "FBModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FBFilterHahaViewCell : UICollectionViewCell

@property (nonatomic, strong) FBButton *item;
//@property (nonatomic, strong) FBModel *model;
@property (nonatomic, assign) BOOL sel;

// 赋值
-(void)setModel:(FBModel *)model theme:(BOOL)white;

@end

NS_ASSUME_NONNULL_END
