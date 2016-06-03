//
//  TKCardActionView.m
//  AnimationTest
//
//  Created by 谭柯 on 16/5/31.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import "TKCardActionView.h"

@interface TKCardActionView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TKCardActionView

- (void)drawRect:(CGRect)rect{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = rect.size.width/2;
}

- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    
    self.backgroundColor = tintColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel setFrame:self.bounds];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    if (!self.titleLabel) {
        self.titleLabel = [UILabel new];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
    }
    self.titleLabel.text = title;
}

@end
