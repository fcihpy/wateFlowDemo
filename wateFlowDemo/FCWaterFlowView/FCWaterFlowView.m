//
//  FCWaterFlowView.m
//  wateFlowDemo
//
//  Created by locojoy on 16/1/25.
//  Copyright © 2016年 fcihpy. All rights reserved.
//

#import "FCWaterFlowView.h"
#import "FCWaterFlowViewCell.h"
const NSUInteger FCWaterFlowViewDefaultCellHeight = 70.f;
const NSUInteger FCWaterFlowViewDefaultMargin = 8.f;
const NSUInteger FCWaterFlowViewDefaultnumberOfColumns = 3;

@interface FCWaterFlowView ()
/**
 *  所有cell的frame数据
 */
@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 *  正在展示的cell
 */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;
/**
 *  缓存池（用Set，存放离开屏幕的cell）
 */
@property (nonatomic, strong) NSMutableSet *reusableCells;
@end

@implementation FCWaterFlowView

#pragma mark - ------------setter/getter-----------
- (NSMutableArray *)cellFrames{
    if (!_cellFrames) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells{
    if (!_displayingCells) {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

- (NSMutableSet *)reusableCells{
    if (!_reusableCells) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadData];
}


#pragma mark - 公共接口
/**
 *  cell的宽度
 */
- (CGFloat)cellWith{
    //总列数
    NSUInteger numberOfColumns = [self numberOfColumns];
    CGFloat leftM = [self marginForType:FCWaterFlowViewMarginTypeLeft];
    CGFloat rightM = [self marginForType:FCWaterFlowViewMarginTypeRight];
    CGFloat columnM = [self marginForType:FCWaterFlowViewMarginTypeColumn];
    return (self.bounds.size.width - leftM - rightM - (numberOfColumns - 1) * columnM) /numberOfColumns;
}

/**
 *  刷新数据
 */
- (void)reloadData{
    //清空之前所有的数据，并移除下在显示的cell
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusableCells removeAllObjects];
    
    //cell的总个数
    NSUInteger numberOfCells = [self.dataSource numberOfCellsInWaterFlow:self];
    //cell的总列数
    NSUInteger numberOfColumns = [self numberOfColumns];
    //cell的间距
    CGFloat topM = [self marginForType:FCWaterFlowViewMarginTypeLeft];
    CGFloat bottomM = [self marginForType:FCWaterFlowViewMarginTypeBottom];
    CGFloat leftM = [self marginForType:FCWaterFlowViewMarginTypeLeft];
    CGFloat columnM = [self marginForType:FCWaterFlowViewMarginTypeColumn];
    CGFloat rowM = [self marginForType:FCWaterFlowViewMarginTypeRow];
    //cell的宽度
    CGFloat cellWidth = [self cellWith];
    //用一个C语言数组存放所有列的最大Y值
    CGFloat maxYOfColums[numberOfColumns];
    for (int i = 0; i < numberOfColumns; i ++) {
        maxYOfColums[i] = 0.0f;
    }
    //计算所有cell的frame
    for (int i = 0; i < numberOfCells; i ++) {
        //cell处在第几列(最短的一列)
        NSUInteger cellColum = 0;
        //cell所处那列的最大Y值(最短那一列的最大Y值)
        CGFloat maxYOfCellColumn = maxYOfColums[cellColum];
        //求出最短的一列
        for (int j = 1; j < numberOfColumns; j ++) {
            if (maxYOfColums[j] < maxYOfCellColumn) {
                cellColum = j;
                maxYOfCellColumn = maxYOfColums[j];
            }
        }
        //询问代理i位置的高度
        CGFloat cellHeight = [self heightAtIndex:i];
        //cell的位置
        CGFloat cellX = leftM + cellColum * (cellWidth + columnM);
        CGFloat cellY = 0;
        if (maxYOfCellColumn == 0.0) { //首行
            cellY = topM;
        }else{
            cellY = maxYOfCellColumn + rowM;
        }
        //添加frame到数组中
        CGRect cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        //更新最短那一列的最大Y值
        maxYOfColums[cellColum] = CGRectGetMaxY(cellFrame);
    }
    //设置contentSize
    CGFloat contentH = maxYOfColums[0];
    for (int j = 1; j < numberOfColumns; j ++) {
        if (maxYOfColums[j] > contentH) {
            contentH = maxYOfColums[j];
        }
    }
    contentH += bottomM;
    self.contentSize = CGSizeMake(0, contentH);
}

/**
 *  当UIScrollView滚动的时候也会调用这个方法
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //向数据源索要对应位置的cell
    NSUInteger numberOfCells = self.cellFrames.count;
    for (int i = 0; i < numberOfCells; i ++) {
        //取出i位置cell的frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        //取出i对应位置的cell
        FCWaterFlowViewCell *cell = self.displayingCells[@(i)];
        //判断i对应位置的frame在不在屏幕上
        if ([self iscellInScreen:cellFrame]) {
            if (!cell) {
                cell = [self.dataSource waterFlowView:self cellItemAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                
                //存储到字典中
                self.displayingCells[@(i)]  = cell;
            }
        }else{
            if (cell) {
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                //存入到缓存池
                [self.reusableCells addObject:cell];
            }
        }
    }
}


- (id)dequeueReuseableCellWithIentifier:(NSString *)identifier{
    __block FCWaterFlowViewCell *reuseableCell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(FCWaterFlowViewCell *cell, BOOL * _Nonnull stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reuseableCell = cell;
            *stop = YES;
        }
    }];
    // 从缓存池中移除
    if (reuseableCell) {
        [self.reusableCells removeObject:reuseableCell];
    }
    return reuseableCell;
}


#pragma mark - 私有方法
/**
 *  判断一个frame有无显示在屏幕上
 */
- (BOOL)iscellInScreen:(CGRect)frame{
    return (CGRectGetMaxY(frame) > self.contentOffset.y) &&(CGRectGetMinY(frame) < self.contentOffset.y + self.bounds.size.height);
}

/**
 *  间距
 */
- (CGFloat)marginForType:(FCWaterFlowViewMarginType)type{
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        return [self.delegate waterflowView:self marginForType:type];
    }else{
        return FCWaterFlowViewDefaultMargin;
    }
}

/**
 *  总列数
 */
- (NSUInteger)numberOfColumns{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumns)]) {
        return [self.dataSource numberOfCellsInWaterFlow:self];
    }else{
        return  FCWaterFlowViewDefaultnumberOfColumns;
    }
}
/**
 *  index位置对应的高度
 */
- (CGFloat)heightAtIndex:(NSUInteger)index{
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]) {
        return [self.delegate waterflowView:self heightAtIndex:index];
    }else{
        return FCWaterFlowViewDefaultCellHeight;
    }
}


#pragma mark - 事件处理
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.delegate respondsToSelector:@selector(waterflowView:didSelectAtIndex:)]) return;
    
    // 获得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber *selectIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, FCWaterFlowViewCell *cell, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
    }];
    
    if (selectIndex) {
        [self.delegate waterflowView:self didSelectAtIndex:selectIndex.unsignedIntegerValue];
    }
}

@end
