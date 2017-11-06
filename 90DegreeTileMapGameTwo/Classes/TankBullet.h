//
//  TankBullet.h
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/26
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Enemy;
// -----------------------------------------------------------------

@interface TankBullet : CCSprite

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
+ (id)spwanBullet;
- (void)addBulletInTileMap:(CCTiledMap *)tileMap tracingEnemy:(Enemy *)enemy;

// -----------------------------------------------------------------

@end




