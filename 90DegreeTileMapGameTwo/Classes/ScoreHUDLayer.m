//
//  ScoreHUDLayer.m
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/25
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "ScoreHUDLayer.h"

// -----------------------------------------------------------------

@implementation ScoreHUDLayer

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        _scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Maker Felt" fontSize:16];
        _scoreLabel.position = CGPointMake(screenSize.width * 0.5f,screenSize.height - _scoreLabel.contentSize.height * 0.5f);
        _scoreLabel.color = [CCColor blackColor];
        _scoreLabel.horizontalAlignment = CCTextAlignmentCenter;
        [self addChild:_scoreLabel z:2 name:@"ScoreLabelNode"];
    }
    return self;
}

- (void)numCollectedChanged:(NSInteger)numCollected{
    _scoreLabel.string = [NSString stringWithFormat:@"%ld",(long)numCollected];
}

// -----------------------------------------------------------------

@end





