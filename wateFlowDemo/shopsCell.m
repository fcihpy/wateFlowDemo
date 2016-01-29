//
//  shopsCell.m
//  wateFlowDemo
//
//  Created by locojoy on 16/1/25.
//  Copyright © 2016年 fcihpy. All rights reserved.
//

#import "shopsCell.h"
#import "FCWaterFlowView.h"
#import "UIImageView+WebCache.h"
#import "shopsModel.h"

@interface shopsCell ()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *priceLabel;

@end

@implementation shopsCell

+ (instancetype)cellWithWaterFlowView:(FCWaterFlowView *)waterFlowView{
    static NSString *identyfiy = @"test";
    shopsCell *cell = [waterFlowView dequeueReuseableCellWithIentifier:identyfiy];
    if (!cell) {
        cell = [[shopsCell alloc]init];
        cell.identifier = identyfiy;
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor whiteColor];
        [self addSubview:priceLabel];
        self.priceLabel = priceLabel;
    }
    return self;
}


- (void)setModel:(shopsModel *)model{
    _model = model;
    self.priceLabel.text = model.price;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"loading"]];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    
    CGFloat priceX = 0;
    CGFloat priceH = 25;
    CGFloat priceY = self.bounds.size.height - priceH;
    CGFloat priceW = self.bounds.size.width;
    self.priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
}

@end
