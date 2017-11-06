//
//  TowerBullet.m
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/27
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "TowerBullet.h"

// -----------------------------------------------------------------

@implementation TowerBullet

// -----------------------------------------------------------------

+ (id)spwanTowerBullet{
    return [[self alloc] initWithTowerBulletImage];
}
- (id)initWithTowerBulletImage{
    if ((self = [super initWithImageNamed:@"towerbullet.png"])) {
    }
    return self;
}

// -----------------------------------------------------------------

@end





