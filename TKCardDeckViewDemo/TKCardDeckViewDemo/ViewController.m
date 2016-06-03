//
//  ViewController.m
//  TKCardDeckViewDemo
//
//  Created by 谭柯 on 16/6/3.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import "ViewController.h"
#import "TKCardDeckView.h"

@interface ViewController ()<TKCardDeckViewDelegate>

@property (weak, nonatomic) IBOutlet TKCardDeckView *cardDeckView;
@property (nonatomic, strong) UILabel *tintLabel;

@property (nonatomic, strong) NSMutableArray *cardDeckData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(reset)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.cardDeckData = [NSMutableArray arrayWithArray:@[@"格罗玛什·地狱咆哮",@"先知维纶",@"提里奥佛丁",@"霸王龙",@"塞纳留斯",@"爱德温范克里夫",@"加拉克苏斯",@"安东尼达斯"]];
    
    self.cardDeckView.emitterEnable = YES;
    self.cardDeckView.delegate = self;
}
- (void)reset{
    self.title = nil;
    self.tintLabel.hidden = YES;
    [self.cardDeckView reset];
}

- (NSInteger)numberOfCardsInCardDeckView:(TKCardDeckView *)cardDeckView{
    return self.cardDeckData.count;
}

- (TKCardView *)cardDeckView:(TKCardDeckView *)cardDeckView cardViewForRowAtIndex:(NSInteger)index{
    TKCardView *card = [TKCardView new];
    
    [card.imageView setImage:[UIImage imageNamed:self.cardDeckData[index]]];
    
    return card;
}

- (TKCardActionView *)cardDeckView:(TKCardDeckView *)cardDeckView cardActionViewForDirection:(TKCardActionDirection)direction{
    
    switch (direction) {
        case TKCardActionDirectionLeft:{
            TKCardActionView *actionView = [TKCardActionView new];
            actionView.title = @"Good";
            actionView.tintColor = [UIColor greenColor];
            return actionView;
        }
            break;
        case TKCardActionDirectionTop:{
            TKCardActionView *actionView = [TKCardActionView new];
            actionView.title = @"Like";
            actionView.tintColor = [UIColor redColor];
            return actionView;
        }
            break;
        case TKCardActionDirectionRight:{
            TKCardActionView *actionView = [TKCardActionView new];
            actionView.title = @"Normal";
            actionView.tintColor = [UIColor blueColor];
            return actionView;
        }
            break;
        case TKCardActionDirectionBottom:{
            TKCardActionView *actionView = [TKCardActionView new];
            actionView.title = @"Bad";
            actionView.tintColor = [UIColor blackColor];
            return actionView;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)cardDeckView:(TKCardDeckView *)cardDeckView actionToDirection:(TKCardActionDirection)direction atCardViewIndex:(NSInteger)index{
    switch (direction) {
        case TKCardActionDirectionLeft:
            self.title = [NSString stringWithFormat:@"%@:Good",self.cardDeckData[index]];
            NSLog(@"Good:%@",self.cardDeckData[index]);
            break;
        case TKCardActionDirectionTop:
            self.title = [NSString stringWithFormat:@"%@:Like",self.cardDeckData[index]];
            NSLog(@"Like:%@",self.cardDeckData[index]);
            break;
        case TKCardActionDirectionRight:
            self.title = [NSString stringWithFormat:@"%@:Normal",self.cardDeckData[index]];
            NSLog(@"Normal:%@",self.cardDeckData[index]);
            break;
        case TKCardActionDirectionBottom:
            self.title = [NSString stringWithFormat:@"%@:Bad",self.cardDeckData[index]];
            NSLog(@"Bad:%@",self.cardDeckData[index]);
            break;
            
        default:
            break;
    }
}

- (void)didAllCardActionCompleteCardDeckView:(TKCardDeckView *)cardDeckView{
    if (!self.tintLabel) {
        self.tintLabel = [UILabel new];
        self.tintLabel.text = @"完成";
        self.tintLabel.textAlignment = NSTextAlignmentCenter;
        [self.tintLabel setFont:[UIFont systemFontOfSize:30]];
        [self.tintLabel setFrame:self.view.bounds];
        [self.view addSubview:self.tintLabel];
    }
    self.tintLabel.hidden = NO;
}
@end
