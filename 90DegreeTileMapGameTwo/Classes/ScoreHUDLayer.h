//
//  ScoreHUDLayer.h
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/25
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------

@interface ScoreHUDLayer : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) CCLabelTTF *scoreLabel;

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;
- (void)numCollectedChanged:(NSInteger)numCollected;

// -----------------------------------------------------------------

@end




