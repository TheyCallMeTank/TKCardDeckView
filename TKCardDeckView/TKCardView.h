//
//  TKCardView.h
//  AnimationTest
//
//  Created by 谭柯 on 16/5/26.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AnimationDuring 0.3

@class TKCardView;
@protocol TKCardViewDelegate <NSObject>

@optional
- (void)willBeginDrawCardView:(TKCardView *)cardView;
- (void)didBeginDrawCardView:(TKCardView *)cardView;
- (void)willEndDrawCardView:(TKCardView *)cardView;
- (void)didEndDrawCardView:(TKCardView *)cardView;

- (void)cardView:(TKCardView *)cardView translation:(CGPoint)translation maxDistanceX:(CGFloat)maxDistanceX maxDistanceY:(CGFloat)maxDistanceY;
- (void)cardView:(TKCardView *)cardView didEndDrawWithTranslation:(CGPoint)translation maxDistanceX:(CGFloat)maxDistanceX maxDistanceY:(CGFloat)maxDistanceY;

@end

@interface TKCardView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isOnFront;
@property (nonatomic, assign) BOOL isRemoved;

@property (nonatomic, weak) id<TKCardViewDelegate> delegate;

@end
