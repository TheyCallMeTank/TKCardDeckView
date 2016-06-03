//
//  TKCardDeckView.h
//  AnimationTest
//
//  Created by 谭柯 on 16/5/25.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCardView.h"
#import "TKCardActionView.h"

typedef NS_ENUM(NSUInteger, TKCardActionDirection) {
    TKCardActionDirectionLeft = 0,
    TKCardActionDirectionTop = 1,
    TKCardActionDirectionRight = 2,
    TKCardActionDirectionBottom = 3,
    TKCardActionDirectionNull = 4
};

@class TKCardDeckView;
@protocol TKCardDeckViewDelegate <NSObject>

@required
- (NSInteger)numberOfCardsInCardDeckView:(TKCardDeckView *)cardDeckView;
- (TKCardView *)cardDeckView:(TKCardDeckView *)cardDeckView cardViewForRowAtIndex:(NSInteger)index;

@optional
- (TKCardActionView *)cardDeckView:(TKCardDeckView *)cardDeckView cardActionViewForDirection:(TKCardActionDirection)direction;
- (void)cardDeckView:(TKCardDeckView *)cardDeckView actionToDirection:(TKCardActionDirection)direction atCardViewIndex:(NSInteger)index;
- (void)didAllCardActionCompleteCardDeckView:(TKCardDeckView *)cardDeckView;

@end

@interface TKCardDeckView : UIView

@property (nonatomic, weak) id<TKCardDeckViewDelegate> delegate;
@property (nonatomic, assign) BOOL emitterEnable;

- (void)reset;

@end
