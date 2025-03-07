//
//  FBBeautyMenuViewCell.m
//  FaceBeautyDemo
//

#import "FBBeautyMenuViewCell.h"
#import "FBUIConfig.h"

@interface FBBeautyMenuViewCell ()

@property (strong, nonatomic) UILabel *label;

@end

@implementation FBBeautyMenuViewCell

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.userInteractionEnabled = NO;
        _label.font = FBFontRegular(17);
        _label.textColor = FBColors(255, 1.0);
    }
    return _label;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
//            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title textColor:(UIColor *)color{
    [self.label setText:title];
    [self.label setTextColor:color];
}

@end
