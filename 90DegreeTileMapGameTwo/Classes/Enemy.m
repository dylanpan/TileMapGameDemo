//
//  Enemy.m
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/26
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Enemy.h"
#import "TileMapScene.h"
#import "Player.h"


@interface Enemy(PrivateMethods)
- (void)animateEnemyTracingPlayer:(Player *)player;
@end
// -----------------------------------------------------------------

@implementation Enemy

// -----------------------------------------------------------------
+ (id)spwanEnemy{
    return [[self alloc] initWithEnemyImage];
}
- (id)initWithEnemyImage{
    if ((self = [super initWithImageNamed:@"ninja.png"])) {
    }
    return self;
}

- (void)addEnemyInTileMap:(CCTiledMap *)tileMap tracingPlayer:(Player *)player{
    CCTiledMapObjectGroup *objectLayer = [tileMap objectGroupNamed:@"ObjectLayer"];
    NSMutableDictionary *spawnPoint = [objectLayer objectNamed:@"EnemyPoint"];
    NSInteger enemySpawnPosX = [[spawnPoint valueForKey:@"x"] integerValue];
    NSInteger enemySpawnPosY = [[spawnPoint valueForKey:@"y"] integerValue];
    CGPoint spawnPos = CGPointMake(enemySpawnPosX, enemySpawnPosY);
    self.position = spawnPos;
    self.anchorPoint = CGPointMake(0.0f, 0.0f);
    [self animateEnemyTracingPlayer:player];
    [tileMap addChild:self z:1 name:@"EnemyNode"];
}

- (void)animateEnemyTracingPlayer:(Player *)player{
    CGPoint diffPos = CGPointMake(player.position.x - self.position.x, player.position.y - self.position.y);
    self.userObject = [NSValue valueWithCGPoint:self.position];
//    //使enemy每次移动都面向player
//    CGFloat angleRadians = atanf((CGFloat)diffPos.y/(CGFloat)diffPos.x);
//    CGFloat angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
//    CGFloat cocosAngle = -1 * angleDegrees;
//    if (diffPos.x < 0) {
//        cocosAngle += 180;
//    }
//    self.rotation = cocosAngle;
    
    //返回长度为1的向量
    diffPos = CGPointMake(diffPos.x * (1.0f / sqrtf(diffPos.x * diffPos.x + diffPos.y * diffPos.y)), diffPos.y * (1.0f / sqrtf(diffPos.x * diffPos.x + diffPos.y * diffPos.y)));
    CCActionMoveBy *actionMove = [CCActionMoveBy actionWithDuration:0.3f position:CGPointMake(diffPos.x * 5.0f, diffPos.y * 5.0f)];
    CCActionCallFunc *actionMoveDone = [CCActionCallFunc actionWithTarget:self selector:@selector(enemyMoveFinished)];
    [self runAction:[CCActionSequence actions:actionMove, actionMoveDone, nil]];
}

- (void)enemyMoveFinished{
    [self animateEnemyTracingPlayer:[TileMapScene sharePlayer]];
}

// -----------------------------------------------------------------

@end





