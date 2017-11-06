//
//  TankBullet.m
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/26
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "TankBullet.h"
#import "TileMapScene.h"
#import "Enemy.h"
#import "Player.h"

// -----------------------------------------------------------------

@implementation TankBullet

// -----------------------------------------------------------------
static Enemy *instanceOfEnemy;

+ (id)spwanBullet{
    return [[self alloc] initWithBulletImage];
}
- (id)initWithBulletImage{
    if ((self = [super initWithImageNamed:@"tankbullet.png"])) {
    }
    return self;
}

- (void)addBulletInTileMap:(CCTiledMap *)tileMap tracingEnemy:(Enemy *)enemy{
    Player *player = [TileMapScene sharePlayer];
    if (player.rotation == 0) {
        self.position = CGPointMake(player.position.x, player.position.y + player.contentSize.height * 0.5f);
    }else if (player.rotation == 90) {
        self.position = CGPointMake(player.position.x + player.contentSize.width * 0.5f, player.position.y);
        self.rotation = 90;
    }else if (player.rotation == 180) {
        self.position = CGPointMake(player.position.x, player.position.y - player.contentSize.height * 0.5f);
    }else if (player.rotation == 270) {
        self.position = CGPointMake(player.position.x - player.contentSize.width * 0.5f, player.position.y);
        self.rotation = 90;
    }
    
    //self.anchorPoint = CGPointMake(0.5f, 0.5f);
    instanceOfEnemy = enemy;
    [self animateBulletTracingEnemy:enemy];
    [tileMap addChild:self z:1 name:@"BulletNode"];
}

- (void)animateBulletTracingEnemy:(Enemy *)enemy{
    CGPoint diffPos = CGPointMake(enemy.position.x - self.position.x, enemy.position.y - self.position.y);
    self.userObject = [NSValue valueWithCGPoint:self.position];
    
//    //跟踪弹
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
    CCActionMoveBy *actionMove = [CCActionMoveBy actionWithDuration:0.3f position:CGPointMake(diffPos.x * 15.0f, diffPos.y * 15.0f)];
    CCActionCallFunc *actionMoveDone = [CCActionCallFunc actionWithTarget:self selector:@selector(bulletMoveFinished)];
    [self runAction:[CCActionSequence actions:actionMove, actionMoveDone, nil]];
}

- (void)bulletMoveFinished{
   [self animateBulletTracingEnemy:instanceOfEnemy];
}

// -----------------------------------------------------------------

@end





