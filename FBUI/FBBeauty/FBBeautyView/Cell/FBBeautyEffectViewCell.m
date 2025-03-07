//
//  FBBeautyEffectViewCell.m
//  FaceBeautyDemo
//

#import "FBBeautyEffectViewCell.h"
#import "FBUIConfig.h"
#import "FBTool.h"

@implementation FBBeautyEffectViewCell

- (FBButton *)item{
    if (!_item) {
        _item = [[FBButton alloc] init];
        _item.userInteractionEnabled = NO;
    }
    return _item;
}

- (UIView *)pointView{
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.backgroundColor = MAIN_COLOR;
        _pointView.layer.cornerRadius = FBWidth(2);
        [_pointView setHidden:YES];
    }
    return _pointView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.contentView);
            make.width.mas_equalTo(FBWidth(48));
            make.height.mas_equalTo(FBHeight(70));
        }];
        [self.contentView addSubview:self.pointView];
        [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self.contentView);
            make.width.height.mas_equalTo(FBWidth(4));
        }];
    }
    return self;
}

#pragma mark - 美颜美型赋值
- (void)setSkinShapeModel:(FBModel *)model themeWhite:(BOOL)white {
    
    if (model.selected) {
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.selectedIcon] : model.selectedIcon] imageWidth:FBWidth(48) title:[FBTool isCurrentLanguageChinese] ? model.title : model.title_en];
        [self.item setTextColor:MAIN_COLOR];
    }else{
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.icon] : model.icon] imageWidth:FBWidth(48) title:[FBTool isCurrentLanguageChinese] ? model.title : model.title_en];
        [self.item setTextColor:white ? [UIColor blackColor] : FBColors(255, 1.0)];
    }
    [self.item setTextFont:FBFontRegular(12)];
    
    if([FBTool getFloatValueForKey:model.key] == 0) {
        [self.pointView setHidden:YES];
    }else{
        [self.pointView setHidden:NO];
    }
}

#pragma mark - 美体赋值
- (void)setBodyModel:(FBModel *)model themeWhite:(BOOL)white {
    
    if (model.selected) {
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.selectedIcon] : model.selectedIcon] imageWidth:FBWidth(48) title:[FBTool isCurrentLanguageChinese] ? model.title : model.title_en];
        [self.item setTextColor:MAIN_COLOR];
    }else{
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.icon] : model.icon] imageWidth:FBWidth(48) title:[FBTool isCurrentLanguageChinese] ? model.title : model.title_en];
        [self.item setTextColor:white ? [UIColor blackColor] : FBColors(255, 1.0)];
    }
    [self.item setTextFont:FBFontRegular(12)];
    
    if([FBTool getFloatValueForKey:model.key] == model.defaultValue) {
        [self.pointView setHidden:YES];
    }else{
        [self.pointView setHidden:NO];
    }
    
}

@end
