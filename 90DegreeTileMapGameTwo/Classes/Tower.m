//
//  Tower.m
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/27
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Tower.h"

// -----------------------------------------------------------------

@implementation Tower

// -----------------------------------------------------------------

+ (id)spawnTower{
    return [[self alloc] initWithTowerImage];
}

- (id)initWithTowerImage{
    if (self = [super initWithImageNamed:@"tower.png"]) {
        ;
    }
    return self;
}

// -----------------------------------------------------------------

@end





