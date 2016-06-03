# TKCardDeckView

TKCardDeckView是一个用于挑选图片的控件，它的使用方式和系统的UITableView非常相似。

![image](https://github.com/TheyCallMeTank/TKCardDeckView/blob/master/TKCardDeckViewDemo/demo.gif)

# 如何使用

只需实现TKCardDeckViewDelegate协议即可，其中numberOfCardsInCardDeckView:和cardDeckView:cardViewForRowAtIndex:必须实现，用于设置显示的内容。

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //显示的图片数据
    self.cardDeckData = [NSMutableArray arrayWithArray:@[@"格罗玛什·地狱咆哮",@"先知维纶",@"提里奥佛丁",@"霸王龙",@"塞纳留斯",@"爱德温范克里夫",@"加拉克苏斯",@"安东尼达斯"]];
    
    //设置代理
    self.cardDeckView.delegate = self;
}
```

实现数据代理
```objc
//一共有多少张卡片
- (NSInteger)numberOfCardsInCardDeckView:(TKCardDeckView *)cardDeckView{
    return self.cardDeckData.count;
}

//每张卡片的内容
- (TKCardView *)cardDeckView:(TKCardDeckView *)cardDeckView cardViewForRowAtIndex:(NSInteger)index{
    TKCardView *cardView = [TKCardView new];
    
    [cardView.imageView setImage:[UIImage imageNamed:self.cardDeckData[index]]];
    
    return cardView;
}

```

将卡片拖向不同的方向显示的选项代理
```objc
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

```

拖向某个方向松开后的事件
```objc
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

```
