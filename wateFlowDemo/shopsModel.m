//
//  shopsModel.m
//  wateFlowDemo
//
//  Created by locojoy on 16/1/25.
//  Copyright © 2016年 fcihpy. All rights reserved.
//

#import "shopsModel.h"

@implementation shopsModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.img = [dict valueForKey:@"img"];
        self.price = [dict valueForKey:@"price"];
    }
    return self;
}

@end
