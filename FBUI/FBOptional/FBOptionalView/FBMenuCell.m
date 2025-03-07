//
//  FBMenuCell.m
//  FaceBeautyDemo
//

#import "FBMenuCell.h"
#import "FBUIConfig.h"

@implementation FBMenuCell

- (FBButton *)item{
    if (!_item) {
        _item = [[FBButton alloc] init];
        _item.userInteractionEnabled = NO;
    }
    return _item;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

@end
