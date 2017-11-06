//
//  Player.m
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/24
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Player.h"

// -----------------------------------------------------------------

@implementation Player

// -----------------------------------------------------------------

+ (id)spawnPlayer{
    return [[self alloc] initWithPlayerImage];
}

- (id)initWithPlayerImage{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        self = [super initWithImageNamed:@"tank0.png"];
    }
    
    
    
    return self;
}

// -----------------------------------------------------------------

@end





