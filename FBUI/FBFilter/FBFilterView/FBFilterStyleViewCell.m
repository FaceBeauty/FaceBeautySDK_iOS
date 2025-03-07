//
//  FBFilterStyleViewCell.m
//  FaceBeautyDemo
//

#import "FBFilterStyleViewCell.h"
#import "FBUIConfig.h"
#import "FBButton.h"
#import "FBTool.h"

@interface FBFilterStyleViewCell ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) FBButton *item;
@end

@implementation FBFilterStyleViewCell

- (FBButton *)item{
    if (!_item) {
        _item = [[FBButton alloc] init];
        _item.userInteractionEnabled = NO;
    }
    return _item;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] init];
        _lineView.image = [UIImage imageNamed:@"ht_line.png"];
    }
    return _lineView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(FBWidth(55));
        }];
        [self.contentView addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.contentView);
            make.width.height.mas_equalTo(FBWidth(55));
        }];
        [self.maskView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.maskView);
            make.width.mas_equalTo(FBWidth(30));
            make.height.mas_equalTo(FBHeight(3));
        }];
    }
    return self;
}

- (void)setMaskViewColor:(UIColor *)color selected:(BOOL)selected{
    if (selected) {
        [self.maskView setBackgroundColor:color];
    }
    [self.maskView setHidden:!selected];
}

- (void)setItemCornerRadius:(CGFloat)radius{
    [self.maskView.layer setCornerRadius:radius];
    [self.item setImageCornerRadius:radius];
}

#pragma mark - 赋值
- (void)setModel:(FBModel *)model isWhite:(BOOL)isWhite{
    
    [self.item setImage:[UIImage imageNamed:model.icon] imageWidth:FBWidth(55) title:[FBTool isCurrentLanguageChinese] ? model.title : model.title_en];
    if (model.selected) {
        [self.item setTextColor:isWhite ? [UIColor blackColor] : MAIN_COLOR];
    }else{
        [self.item setTextColor:isWhite ? [UIColor blackColor] : FBColors(255, 1.0)];
    }
    [self setItemCornerRadius:FBWidth(5)];
    [self setMaskViewColor:COVER_COLOR selected:model.selected];
    [self.item setTextFont:FBFontRegular(12)];
}

#pragma mark - 美妆空cell赋值
- (void)setNoneImage:(BOOL)selected isThemeWhite:(BOOL)isWhite{
    
    [self.item setImage:[UIImage imageNamed:@"makeup_none"] imageWidth:FBWidth(55) title:[FBTool isCurrentLanguageChinese] ? @"无" : @"None"];
    if (selected) {
        [self.item setTextColor:isWhite ? [UIColor blackColor] : MAIN_COLOR];
    }else{
        [self.item setTextColor:isWhite ? [UIColor blackColor] : FBColors(255, 1.0)];
    }
    
    [self setItemCornerRadius:FBWidth(5)];
    [self setMaskViewColor:COVER_COLOR selected:selected];
    [self.item setTextFont:FBFontRegular(12)];
}


@end
