//
//  shopsCell.h
//  wateFlowDemo
//
//  Created by locojoy on 16/1/25.
//  Copyright © 2016年 fcihpy. All rights reserved.
//

#import "FCWaterFlowViewCell.h"

@class FCWaterFlowView,shopsModel;

@interface shopsCell : FCWaterFlowViewCell

+ (instancetype)cellWithWaterFlowView:(FCWaterFlowView *)waterFlowView;

@property (nonatomic,strong) shopsModel *model;

@end
