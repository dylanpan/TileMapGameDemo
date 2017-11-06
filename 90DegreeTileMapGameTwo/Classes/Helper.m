//
//  Helper.m
//  90DegreeTileMapGameTwo
//
//  Created by 潘安宇 on 2017/10/24.
//  Copyright © 2017年 潘安宇. All rights reserved.
//


#import "Helper.h"

@implementation Helper

+ (CGPoint)locationFromTouch:(CCTouch *)touch{
    CGPoint touchLocation = [touch locationInView:[touch view]];
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

+ (CGPoint)screenCenter{
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    return CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
}

+ (CGSize)screenSize{
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    return screenSize;
}

@end
