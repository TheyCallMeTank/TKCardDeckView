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
