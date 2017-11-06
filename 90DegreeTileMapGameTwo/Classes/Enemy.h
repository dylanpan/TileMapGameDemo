//
//  Enemy.h
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

@class Player;
// -----------------------------------------------------------------

@interface Enemy : CCSprite

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
+ (id)spwanEnemy;
- (void)addEnemyInTileMap:(CCTiledMap *)tileMap tracingPlayer:(Player *)player;
// -----------------------------------------------------------------

@end




