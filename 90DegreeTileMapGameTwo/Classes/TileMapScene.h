//
//  TileMapScene.h
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/24
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Tower.h"

typedef NS_ENUM(NSInteger, MoveDirectionTypes){
    MoveDirectionTypeNone = 0,
    MoveDirectionTypeUpper,
    MoveDirectionTypeUpperLeft,
    MoveDirectionTypeLeft,
    MoveDirectionTypeLowerLeft,
    MoveDirectionTypeLower,
    MoveDirectionTypeLowerRight,
    MoveDirectionTypeRight,
    MoveDirectionTypeUpperRight,
    MoveDirectionTypesMax,
};

// -----------------------------------------------------------------

@interface TileMapScene : CCScene

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) CCTiledMap *tileMap;
@property (nonatomic, strong) CCTiledMapLayer *backgroundLayer;
@property (nonatomic, strong) CCTiledMapLayer *eventLayer;
@property (nonatomic, strong) CCTiledMapLayer *getThingLayer;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Tower *tower;
@property (nonatomic) NSInteger numberOfEnemy;
@property (nonatomic) NSInteger numberOfTowerBullet;
@property (nonatomic) NSInteger updateCount;
@property (nonatomic) MoveDirectionTypes currentType;
@property (nonatomic, strong) NSMutableArray *moveOffsets;
@property (nonatomic) CGRect upperLeftAreaRect;
@property (nonatomic) CGRect lowerLeftAreaRect;
@property (nonatomic) CGRect lowerRightAreaRect;
@property (nonatomic) CGRect upperRightAreaRect;
@property (nonatomic) NSInteger score;
@property (nonatomic, strong) NSMutableArray *enemies;
@property (nonatomic, strong) NSMutableArray *bullets;

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;
+ (id)scene;
+ (Player *)sharePlayer;

// -----------------------------------------------------------------

@end




