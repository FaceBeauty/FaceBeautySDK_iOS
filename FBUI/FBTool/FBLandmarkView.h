//
//  FBLandmarkView.h
//  FaceBeautyDemo
//

#import <UIKit/UIKit.h>

@interface FBLandmarkView : UIView

#define LANDMARKS_KEY @"LANDMARKS_KEY"
#define RECT_KEY   @"RECT_KEY"

@property (nonatomic , strong) NSArray *faceDataArray;

@property (nonatomic, strong) NSMutableArray *pointXArray;
@property (nonatomic, strong) NSMutableArray *pointYArray;
@property (nonatomic, assign) CGRect faceRect;
@property (nonatomic, assign) NSNumber *drawEnable;

@end
