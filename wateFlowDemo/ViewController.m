//
//  ViewController.m
//  wateFlowDemo
//
//  Created by locojoy on 16/1/25.
//  Copyright © 2016年 fcihpy. All rights reserved.
//

#import "ViewController.h"
#import "FCWaterFlowView.h"
#import "shopsCell.h"
#import "shopsModel.h"


@interface ViewController ()<FCWaterFlowViewDataSource,FCWaterFlowViewDelegate>

@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, weak) FCWaterFlowView *waterflowView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     // 1.瀑布流控件
    FCWaterFlowView *waterFlow = [[FCWaterFlowView alloc]init];
    waterFlow.backgroundColor = [UIColor redColor];
    
    // 跟随着父控件的尺寸而自动伸缩
    waterFlow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    waterFlow.frame = self.view.bounds;
    waterFlow.dataSource = self;
    waterFlow.delegate = self;
    [self.view addSubview:waterFlow];
    self.waterflowView = waterFlow;
}


- (NSMutableArray *)shops{
    if (!_shops) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
        NSArray *arry  = [NSArray arrayWithContentsOfFile:plistPath];
        NSMutableArray *tempArry = [NSMutableArray array];
        for (NSDictionary *dict in arry) {
            shopsModel *model = [[shopsModel alloc]initWithDict:dict];
            [tempArry addObject:model];
        }
        _shops = tempArry;
    }
    return _shops;
}



#pragma mark - ------------------FCWaterFlowViewDataSource,FCWaterFlowViewDelegate----
- (NSUInteger)numberOfCellsInWaterFlow:(FCWaterFlowView *)waterFlowView{
    return self.shops.count;
}

- (FCWaterFlowViewCell *)waterFlowView:(FCWaterFlowView *)waterFlowView cellItemAtIndex:(NSUInteger)index{
    shopsCell *cell = [shopsCell cellWithWaterFlowView:waterFlowView];
    shopsModel *model  = self.shops[index];
    model.price = [NSString stringWithFormat:@"price- %ld",index];
    cell.model = model;
    return cell;
}

- (CGFloat)waterflowView:(FCWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index{
    switch (index % 3) {
        case 1:
            return 70;
            break;
        case 2:
            return 90;
            break;
        case 3:
            return 50;
            break;
        default:
            break;
    }
    return 110;
    
//    shopsModel *model = self.shops[index];
//    return waterFlowView.cellWith * model.h / model.w;
}

@end
