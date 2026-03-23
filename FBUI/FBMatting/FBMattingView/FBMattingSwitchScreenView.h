//
//  FBMattingSwitchScreenView.h
//  FaceBeautyDemo
//
//  Created by Eddie on 2023/4/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 
    绿幕抠图的颜色视图
 
 */

@interface FBMattingSwitchScreenView : UIView


@end

@interface FBMattingSwitchScreenViewCell : UICollectionViewCell

-(void)setColor:(UIColor *)color  Sel:(BOOL)sel;

@end



NS_ASSUME_NONNULL_END
