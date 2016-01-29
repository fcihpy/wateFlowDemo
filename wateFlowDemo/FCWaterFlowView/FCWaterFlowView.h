//
//  FCWaterFlowView.h
//  wateFlowDemo
//
//  Created by locojoy on 16/1/25.
//  Copyright © 2016年 fcihpy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FCWaterFlowViewMarginType) {
    FCWaterFlowViewMarginTypeTop,
    FCWaterFlowViewMarginTypeBottom,
    FCWaterFlowViewMarginTypeLeft,
    FCWaterFlowViewMarginTypeRight,
    FCWaterFlowViewMarginTypeColumn,    //每一列
    FCWaterFlowViewMarginTypeRow,       //每一行
};
@class FCWaterFlowView,FCWaterFlowViewCell;
/** 
 *  数据源方法 
 */
@protocol FCWaterFlowViewDataSource <NSObject>
@required
/** 
 *  -共多少个cellItem数据 
 */
- (NSUInteger)numberOfCellsInWaterFlow:(FCWaterFlowView *)waterFlowView;
/** 
 *  返回index位置对应的cell
 */
- (FCWaterFlowViewCell *)waterFlowView:(FCWaterFlowView *)waterFlowView cellItemAtIndex:(NSUInteger)index;

@optional
/** 
 *  一共多少列 
 */
- (NSUInteger)numberOfColumnsInWaterFlowView:(FCWaterFlowView *)waterFlowView;
@end



/** 代理方法 */
@protocol FCWaterFlowViewDelegate <UIScrollViewDelegate>
@optional
/**
 *  第index位置cell对应的高度
 */
- (CGFloat)waterflowView:(FCWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index;

/**
 *  选中第index位置的cell
 */
- (void)waterflowView:(FCWaterFlowView *)waterFlowView didSelectAtIndex:(NSUInteger)index;

/**
 *  返回间距
 */
- (CGFloat)waterflowView:(FCWaterFlowView *)waterFlowView marginForType:(FCWaterFlowViewMarginType)type;

@end

/** 
 *  瀑布流控件 
 */
@interface FCWaterFlowView : UIScrollView

/** 
 *  数据源 
 */
@property (nonatomic, weak) id<FCWaterFlowViewDataSource> dataSource;

/** 
 *  代理方法 
 */
@property (nonatomic, weak) id<FCWaterFlowViewDelegate>delegate;

/**
 *  刷新数据
 */
- (void)reloadData;

/** 
 *  cell宽度
 */
- (CGFloat)cellWith;


/** 
 *  根据重用标识去缓存池中查找可循环利用的cell 
 */
- (id)dequeueReuseableCellWithIentifier:(NSString *)identifier;

@end
