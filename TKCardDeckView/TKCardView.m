//
//  TKCardView.m
//  AnimationTest
//
//  Created by 谭柯 on 16/5/26.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import "TKCardView.h"

@implementation TKCardView

- (instancetype)init{
    self = [super init];
    
    self.tintColor = [UIColor blueColor];
    
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4.0);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 4;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:pan];
    
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.imageView setFrame:self.bounds];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    if (!self.isOnFront) {
        return;
    }
    static CGPoint initCenter;
    
    CGPoint translation = [pan translationInView:self];
    
//    //拖动距离
    CGFloat maxXPanDistance = self.bounds.size.width/2;
    CGFloat maxYPanDistance = self.bounds.size.height/2;
    
//    CGFloat panXDistance = translation.x < 0 ? MAX(-maxXPanDistance, translation.x) : MIN(maxXPanDistance, translation.x);
//    CGFloat panYDistance = translation.y < 0 ? MAX(-maxYPanDistance, translation.y) : MIN(maxYPanDistance, translation.y);
    
//    //大小变化
//    CGFloat maxScaleChange = 0.2;
//    CGFloat scaleChange = maxScaleChange * (sqrt((panXDistance*panXDistance) + (panYDistance*panYDistance))/sqrt((maxXPanDistance*maxXPanDistance) + (maxYPanDistance*maxYPanDistance)));
//    
//    //旋转变化
//    CGFloat X =MIN(maxXPanDistance,MAX(0,ABS(translation.x)));
//    CGFloat factorOfXAngle = MAX(0,-4/(maxXPanDistance*maxXPanDistance)*X*(X-maxXPanDistance));
//    
//    CGFloat Y =MIN(maxYPanDistance,MAX(0,ABS(translation.y)));
//    CGFloat factorOfYAngle = MAX(0,-4/(maxYPanDistance*maxYPanDistance)*Y*(Y-maxYPanDistance));
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            if ([self.delegate respondsToSelector:@selector(willBeginDrawCardView:)]) {
                [self.delegate willBeginDrawCardView:self];
            }
            initCenter = self.center;
            if ([self.delegate respondsToSelector:@selector(didBeginDrawCardView:)]) {
                [self.delegate didBeginDrawCardView:self];
            }
            break;
        case UIGestureRecognizerStateEnded:{
            if ([self.delegate respondsToSelector:@selector(willEndDrawCardView:)]) {
                [self.delegate willEndDrawCardView:self];
            }
            if ([self.delegate respondsToSelector:@selector(cardView:didEndDrawWithTranslation:maxDistanceX:maxDistanceY:)]) {
                [self.delegate cardView:self didEndDrawWithTranslation:translation maxDistanceX:maxXPanDistance maxDistanceY:maxYPanDistance];
            }
            [UIView animateWithDuration:AnimationDuring delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.center = initCenter;
                self.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(didEndDrawCardView:)]) {
                    [self.delegate didEndDrawCardView:self];
                }
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //大小变化
            //            self.center = CGPointMake(initCenter.x + translation.x*(1 - maxScaleChange), initCenter.y + translation.y*(1 - maxScaleChange));
            self.center = CGPointMake(initCenter.x + translation.x, initCenter.y + translation.y);
            
            //CATransform3D t = CATransform3DIdentity;
//            t.m34  = 1.0/-2000;
//            t = CATransform3DRotate(t, factorOfXAngle*(M_PI/12), 0, panXDistance>0?1:-1, 0);
//            t = CATransform3DRotate(t, factorOfYAngle*(M_PI/12), panYDistance>0?-1:1 ,0, 0);
//            t = CATransform3DScale(t, 1 - scaleChange, 1 - scaleChange, 1);
//            self.layer.transform = t;
            if ([self.delegate respondsToSelector:@selector(cardView:translation:maxDistanceX:maxDistanceY:)]) {
                [self.delegate cardView:self translation:translation maxDistanceX:maxXPanDistance maxDistanceY:maxYPanDistance];
            }
            break;
            
        default:
            break;
    }
}

@end
