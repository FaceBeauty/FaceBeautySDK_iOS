//
//  FBButton.m
//  FaceBeautyDemo
//

#import "FBButton.h"
#import "FBUIConfig.h"

@interface FBButton()

@property (strong, nonatomic) UIImageView *fbImgView;
@property (strong, nonatomic) UILabel *label;

@end

@implementation FBButton

- (UIImageView *)fbImgView{
    if (!_fbImgView) {
        _fbImgView = [[UIImageView alloc] init];
        _fbImgView.contentMode = UIViewContentModeScaleAspectFill;
        _fbImgView.clipsToBounds = YES;
        _fbImgView.userInteractionEnabled = NO;
    }
    return _fbImgView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.userInteractionEnabled = NO;
        _label.font = FBFontRegular(12);
        _label.textColor = FBColors(68, 1.0);
    }
    return _label;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.fbImgView];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
        }];
    }
    return self;
}

- (void)setImageWidthAndHeight:(CGFloat)square title:(NSString *)title{
    self.label.text = title;
    [self.fbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(square);
    }];
}

- (void)setImage:(UIImage *)image {
    
    self.fbImgView.image = image;
}

- (void)setImage:(UIImage *)image imageWidth:(CGFloat)width title:(NSString *)title{
    self.label.text = title;
    self.fbImgView.image = image;
    [self.fbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(width);
    }];
}

- (void)setTextColor:(UIColor *)color{
    self.label.textColor = color;
}

- (void)setTextFont:(UIFont *)font{
    [self.label setFont:font];
}

- (void)setImageCornerRadius:(CGFloat)radius{
    [self.fbImgView.layer setMasksToBounds:YES];
    [self.fbImgView.layer setCornerRadius:radius];
}

- (void)setTextBackgroundColor:(UIColor *)color{
    [self.label setBackgroundColor:color];
}

- (NSString *)getTitle {
    
    if (self.label) {
        return self.label.text;
    }
    return @"";
}
@end
