//
//  TKCardDeckView.m
//  AnimationTest
//
//  Created by 谭柯 on 16/5/25.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import "TKCardDeckView.h"

#define NumOfBehindCard 2
#define BehindCardOffset 8.0
#define BehindCardScale 0.02
#define ActionWidth 60

@interface TKCardDeckView()<TKCardViewDelegate>

@property (nonatomic, assign) NSInteger currentDisplayIndex;
@property (nonatomic, strong) NSMutableArray *behindCards;
@property (nonatomic, strong) TKCardView *frontCard;
@property (nonatomic, assign) BOOL isDrawing;
@property (nonatomic, assign) TKCardActionDirection lastDirection;

@property (nonatomic, strong) TKCardActionView *leftAction;
@property (nonatomic, strong) TKCardActionView *rightAction;
@property (nonatomic, strong) TKCardActionView *topAction;
@property (nonatomic, strong) TKCardActionView *bottomAction;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@end

@implementation TKCardDeckView

- (instancetype)init{
    self = [super init];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self commonInit];
    
    return self;
}

- (void)commonInit{
    self.backgroundColor = [UIColor clearColor];
    self.currentDisplayIndex = 0;
    self.isDrawing = NO;
}

#pragma mark - 布局

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.frontCard && !self.isDrawing) {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[TKCardView class]]) {
                [subView removeFromSuperview];
            }
        }
        NSInteger cardCount = [self.delegate numberOfCardsInCardDeckView:self];
        if (self.currentDisplayIndex < cardCount) {
            //背后的卡片
            self.behindCards = [NSMutableArray new];
            for (NSInteger i=1; i<NumOfBehindCard + 1; i++) {
                NSInteger index = self.currentDisplayIndex + i;
                if (index < cardCount) {
                    TKCardView *cardView = [self.delegate cardDeckView:self cardViewForRowAtIndex:index];
                    if (cardView) {
                        cardView.isOnFront = NO;
                        cardView.delegate = self;
                        [self insertSubview:cardView atIndex:0];
                        [cardView setFrame:self.bounds];
                        
                        cardView.alpha = (NumOfBehindCard - i*1.0 + 1.0)/(NumOfBehindCard + 1);
                        CATransform3D transform3D = CATransform3DIdentity;
                        transform3D = CATransform3DScale(transform3D, 1 - i*BehindCardScale, 1 - i*BehindCardScale, 1);
                        cardView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + i*BehindCardOffset);
                        cardView.layer.transform = transform3D;
                        
                        [self.behindCards insertObject:cardView atIndex:0];
                    }
                }
            }
            //前面的卡片
            self.frontCard = [self.delegate cardDeckView:self cardViewForRowAtIndex:self.currentDisplayIndex];
            if (self.frontCard) {
                self.frontCard.isOnFront = YES;
                self.frontCard.delegate = self;
                [self.frontCard setFrame:self.bounds];
                [self addSubview:self.frontCard];
            }
        }
    }
}

#pragma - 重置

- (void)reset{
    self.currentDisplayIndex = 0;
    self.frontCard = nil;
    [self layoutSubviews];
}

- (void)willBeginDrawCardView:(TKCardView *)cardView{
    self.isDrawing = YES;
    self.lastDirection = TKCardActionDirectionNull;
    
    if ([self.delegate respondsToSelector:@selector(cardDeckView:cardActionViewForDirection:)]) {
        [self createActionWithCardActionDirection:TKCardActionDirectionLeft];
        [self createActionWithCardActionDirection:TKCardActionDirectionTop];
        [self createActionWithCardActionDirection:TKCardActionDirectionRight];
        [self createActionWithCardActionDirection:TKCardActionDirectionBottom];
    }
    
    if (self.currentDisplayIndex + NumOfBehindCard + 1 < [self.delegate numberOfCardsInCardDeckView:self]) {
        TKCardView *cardView = [self.delegate cardDeckView:self cardViewForRowAtIndex:self.currentDisplayIndex + NumOfBehindCard + 1];
        cardView.isOnFront = NO;
        cardView.delegate = self;
        [cardView setFrame:self.bounds];
        
        cardView.alpha = 0;
        CATransform3D transform3D = CATransform3DIdentity;
        transform3D = CATransform3DScale(transform3D, 1 - (NumOfBehindCard + 1)*BehindCardScale, 1 - (NumOfBehindCard + 1)*BehindCardScale, 1);
        cardView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + (NumOfBehindCard + 1)*BehindCardOffset);
        cardView.layer.transform = transform3D;
        
        [self.behindCards insertObject:cardView atIndex:0];
        [self insertSubview:cardView atIndex:0];
    }
}

#pragma mark - 创建和移除Action

- (void)createActionWithCardActionDirection:(TKCardActionDirection)direction{
    TKCardActionView *actionView = [self.delegate cardDeckView:self cardActionViewForDirection:direction];
    if (actionView) {
        [self insertSubview:actionView atIndex:0];
        [actionView setFrame:CGRectMake(self.bounds.size.width/2 - ActionWidth/2, self.bounds.size.height/2 - ActionWidth/2, ActionWidth, ActionWidth)];
        
        [UIView animateWithDuration:AnimationDuring delay:direction/20.0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            switch (direction) {
                case TKCardActionDirectionLeft:
                    [actionView setFrame:CGRectMake(-ActionWidth - ActionWidth/2, self.bounds.size.height/2 - ActionWidth/2, ActionWidth, ActionWidth)];
                    break;
                case TKCardActionDirectionTop:
                    [actionView setFrame:CGRectMake(self.bounds.size.width/2 - ActionWidth/2, -ActionWidth - ActionWidth/2, ActionWidth, ActionWidth)];
                    break;
                case TKCardActionDirectionRight:
                    [actionView setFrame:CGRectMake(self.bounds.size.width + ActionWidth/2, self.bounds.size.height/2 - ActionWidth/2, ActionWidth, ActionWidth)];
                    break;
                case TKCardActionDirectionBottom:
                    [actionView setFrame:CGRectMake(self.bounds.size.width/2 - ActionWidth/2, self.bounds.size.height + ActionWidth/2, ActionWidth, ActionWidth)];
                    break;
                    
                default:
                    break;
            }
        } completion:nil];
    }
    switch (direction) {
        case TKCardActionDirectionLeft:
            self.leftAction = actionView;
            break;
        case TKCardActionDirectionTop:
            self.topAction = actionView;
            break;
        case TKCardActionDirectionRight:
            self.rightAction = actionView;
            break;
        case TKCardActionDirectionBottom:
            self.bottomAction = actionView;
            break;
            
        default:
            break;
    }
}

- (void)removeActionWithCardActionDirection:(TKCardActionDirection)direction{
    TKCardActionView *cardActionView;
    switch (direction) {
        case TKCardActionDirectionLeft:
            cardActionView = self.leftAction;
            self.leftAction = nil;
            break;
        case TKCardActionDirectionRight:
            cardActionView = self.rightAction;
            self.rightAction = nil;
            break;
        case TKCardActionDirectionBottom:
            cardActionView = self.bottomAction;
            self.bottomAction = nil;
            break;
        case TKCardActionDirectionTop:
            cardActionView = self.topAction;
            self.topAction = nil;
            break;
            
        default:
            break;
    }
    if (!cardActionView) {
        return;
    }
    [UIView animateWithDuration:AnimationDuring animations:^{
        [cardActionView setFrame:CGRectMake(self.bounds.size.width/2 - ActionWidth/2, self.bounds.size.height/2 - ActionWidth/2, 60, 60)];
    } completion:^(BOOL finished) {
        [cardActionView removeFromSuperview];
    }];
}

#pragma mark - CardView代理

- (void)didEndDrawCardView:(TKCardView *)cardView{
    self.isDrawing = NO;
    [self.backgroundLayer removeFromSuperlayer];
    
    [self removeActionWithCardActionDirection:TKCardActionDirectionLeft];
    [self removeActionWithCardActionDirection:TKCardActionDirectionTop];
    [self removeActionWithCardActionDirection:TKCardActionDirectionRight];
    [self removeActionWithCardActionDirection:TKCardActionDirectionBottom];
    
    if (self.currentDisplayIndex >= [self.delegate numberOfCardsInCardDeckView:self]) {
        if ([self.delegate respondsToSelector:@selector(didAllCardActionCompleteCardDeckView:)]) {
            [self.delegate didAllCardActionCompleteCardDeckView:self];
        }
    }
}

- (void)cardView:(TKCardView *)cardView didEndDrawWithTranslation:(CGPoint)translation maxDistanceX:(CGFloat)maxDistanceX maxDistanceY:(CGFloat)maxDistanceY{
    CGFloat progress = MIN(1.0, sqrt(translation.x*translation.x + translation.y*translation.y)/sqrt(maxDistanceX*maxDistanceX + maxDistanceY*maxDistanceY));
    BOOL isNeedAction = NO;
    if (progress >= 1) {
        TKCardActionDirection currentDirection = [self directionForTranslation:translation];
        TKCardActionView *cardActionView;
        switch (currentDirection) {
            case TKCardActionDirectionLeft:
                cardActionView = self.leftAction;
                break;
            case TKCardActionDirectionTop:
                cardActionView = self.topAction;
                break;
            case TKCardActionDirectionRight:
                cardActionView = self.rightAction;
                break;
            case TKCardActionDirectionBottom:
                cardActionView = self.bottomAction;
                break;
                
            default:
                break;
        }
        isNeedAction = cardActionView != nil;
        if (isNeedAction) {
            if ([self.delegate respondsToSelector:@selector(cardDeckView:actionToDirection:atCardViewIndex:)]) {
                [self.delegate cardDeckView:self actionToDirection:currentDirection atCardViewIndex:self.currentDisplayIndex];
            }
            //前面卡片消失动画
            UIImageView *frontImageView = [[UIImageView alloc] initWithImage:[self imageConvertFromView:self.frontCard]];
            UIWindow *window=[UIApplication sharedApplication].keyWindow;
            [frontImageView setFrame:[self.frontCard convertRect:self.frontCard.bounds toView:window]];
            [window addSubview:frontImageView];
            //粒子效果
            if (self.emitterEnable) {
                CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
                emitterLayer.emitterPosition = CGPointMake(frontImageView.bounds.size.width/2, frontImageView.bounds.size.height/2);
                emitterLayer.emitterSize = frontImageView.bounds.size;
                emitterLayer.emitterShape = kCAEmitterLayerRectangle;
                emitterLayer.emitterMode = kCAEmitterLayerSurface;
                emitterLayer.preservesDepth = YES;
                
                CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
                emitterCell.birthRate = 1000.0;
                emitterCell.lifetime = 1.0;
                emitterCell.velocity = -10;
                emitterCell.velocityRange = 10;
                emitterCell.yAcceleration = 20;
                emitterCell.xAcceleration = 40;
                emitterCell.contents = (id)[[self imageConvertFromView:({
                    UIView *view = [UIView new];
                    [view setFrame:CGRectMake(0, 0, 6, 6)];
                    view.layer.masksToBounds = YES;
                    view.layer.cornerRadius = 3;
                    view.backgroundColor = cardActionView.tintColor;
                    view.alpha = 0.2;
                    view;
                })] CGImage];
                emitterLayer.emitterCells = @[emitterCell];
                [frontImageView.layer addSublayer:emitterLayer];
            }
            
            [UIView animateWithDuration:AnimationDuring*2 animations:^{
                frontImageView.alpha = 0;
            } completion:^(BOOL finished) {
                [frontImageView removeFromSuperview];
            }];
            
            //后面的卡片到前面
            [self.frontCard removeFromSuperview];
            self.frontCard = nil;
            TKCardView *behindCard = [self.behindCards lastObject];
            if (behindCard) {
                behindCard.isOnFront = YES;
                [self.behindCards removeObject:behindCard];
                self.frontCard = behindCard;
            }
            
            self.currentDisplayIndex++;
        }
    }
    if (!isNeedAction) {
        if (self.behindCards.count >= NumOfBehindCard) {
            TKCardView *cardView = [self.behindCards firstObject];
            [cardView removeFromSuperview];
            [self.behindCards removeObject:cardView];
        }
        for (NSInteger i=0; i<self.behindCards.count; i++) {
            TKCardView *cardView = self.behindCards[i];
            
            NSInteger index = NumOfBehindCard + 1 - self.behindCards.count + i;
            
            [UIView animateWithDuration:AnimationDuring/2 animations:^{
                cardView.alpha = (progress + index*1.0)/(NumOfBehindCard + 1);
                CATransform3D t = CATransform3DIdentity;
                t = CATransform3DScale(t, 1 - (NumOfBehindCard - index)*BehindCardScale - BehindCardScale, 1 - (NumOfBehindCard - index)*BehindCardScale - BehindCardScale, 1);
                cardView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + ((NumOfBehindCard + 1) - index)*BehindCardOffset);
                cardView.layer.transform = t;
            }];
        }
    }
    self.frontCard.alpha = 1.0;
}

- (void)cardView:(TKCardView *)cardView translation:(CGPoint)translation maxDistanceX:(CGFloat)maxDistanceX maxDistanceY:(CGFloat)maxDistanceY{
    CGFloat progress = MIN(1.0, sqrt(translation.x*translation.x + translation.y*translation.y)/sqrt(maxDistanceX*maxDistanceX + maxDistanceY*maxDistanceY));
    if (progress < 1) {
        for (NSInteger i=0; i<self.behindCards.count; i++) {
            TKCardView *cardView = self.behindCards[i];
            
            NSInteger index = NumOfBehindCard + 1 - self.behindCards.count + i;
            
            cardView.alpha = (progress + index*1.0)/(NumOfBehindCard + 1);
            CATransform3D t = CATransform3DIdentity;
            t = CATransform3DScale(t, 1 - (NumOfBehindCard - index)*BehindCardScale - BehindCardScale*(1-progress), 1 - (NumOfBehindCard - index)*BehindCardScale - BehindCardScale*(1-progress), 1);
            cardView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + ((NumOfBehindCard + 1) - index - progress)*BehindCardOffset);
            cardView.layer.transform = t;
        }
    }
    if (progress >= 1) {
        TKCardActionDirection currentDirection = [self directionForTranslation:translation];
        if (currentDirection != self.lastDirection) {
            self.lastDirection = currentDirection;
            TKCardActionView *cardActionView;
            switch (currentDirection) {
                case TKCardActionDirectionLeft:
                    cardActionView = self.leftAction;
                    break;
                case TKCardActionDirectionRight:
                    cardActionView = self.rightAction;
                    break;
                case TKCardActionDirectionTop:
                    cardActionView = self.topAction;
                    break;
                case TKCardActionDirectionBottom:
                    cardActionView = self.bottomAction;
                    break;
                    
                default:
                    break;
            }
            if (cardActionView) {
                [self.backgroundLayer removeFromSuperlayer];
                self.backgroundLayer = [CAShapeLayer layer];
                CGFloat startAngle = 0;
                switch (currentDirection) {
                    case TKCardActionDirectionLeft:
                        startAngle = M_PI_2 + M_PI_4;
                        break;
                    case TKCardActionDirectionTop:
                        startAngle = M_PI + M_PI_4;
                        break;
                    case TKCardActionDirectionRight:
                        startAngle = M_PI + M_PI_2 + M_PI_4;
                        break;
                    case TKCardActionDirectionBottom:
                        startAngle = M_PI_4;
                        break;
                        
                    default:
                        break;
                }
                UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
                                                                    radius:sqrt(self.bounds.size.width*self.bounds.size.width + self.bounds.size.height*self.bounds.size.height)
                                                                startAngle:startAngle endAngle:startAngle + M_PI_2 clockwise:YES];
                [path addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
                self.backgroundLayer.path = path.CGPath;
                self.backgroundLayer.fillColor = cardActionView.tintColor.CGColor;
                self.backgroundLayer.opacity = 0.5;
                
                CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
                opacity.duration = AnimationDuring;
                opacity.fromValue = @0.0;
                opacity.toValue = @0.5;
                [self.backgroundLayer addAnimation:opacity forKey:nil];
                
                [self.layer insertSublayer:self.backgroundLayer atIndex:0];
            }
        }
    }else{
        self.lastDirection = TKCardActionDirectionNull;
        [self.backgroundLayer removeFromSuperlayer];
    }
}

#pragma mark - 获取移动方向
- (TKCardActionDirection)directionForTranslation:(CGPoint)translation{
    CGFloat tan = translation.y/translation.x;
    if (fabs(tan) < 1) {
        if (translation.x > 0) {
            return TKCardActionDirectionRight;
        }else{
            return TKCardActionDirectionLeft;
        }
    }else{
        if (translation.y > 0) {
            return TKCardActionDirectionBottom;
        }else{
            return TKCardActionDirectionTop;
        }
    }
}

#pragma mark - View转Image

- (UIImage *)imageConvertFromView:(UIView*)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
