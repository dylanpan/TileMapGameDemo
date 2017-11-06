//
//  GameOverScene.h
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/27
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------

@interface GameOverScene : CCScene

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) CCLabelTTF *label;
@property (nonatomic, strong) CCLabelTTF *restartLabel;

// -----------------------------------------------------------------
// methods
+ (id)scene;
+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




