//
//  GameOverScene.m
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/27
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameOverScene.h"
#import "Helper.h"
#import "TileMapScene.h"

// -----------------------------------------------------------------

@implementation GameOverScene

// -----------------------------------------------------------------

+ (id)scene{
    CCScene *scene = [CCScene node];
    GameOverScene *gameOverLayer = [GameOverScene node];
    [scene addChild:gameOverLayer];
    return scene;
}

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
        CCNodeColor *backgroundLayer = [[CCNodeColor alloc] initWithColor:[CCColor cyanColor] width:[Helper screenSize].width height:[Helper screenSize].height];
        [self addChild:backgroundLayer z:0];
        
        _restartLabel = [CCLabelTTF labelWithString:@"Restart" fontName:@"ArialMT" fontSize:24];
        _restartLabel.color = [CCColor grayColor];
        _restartLabel.position = CGPointMake([Helper screenSize].width * 0.5f, [Helper screenSize].height * 0.33f);
        self.userInteractionEnabled = YES;
        [self addChild:_restartLabel z:1];
        
        _label = [CCLabelTTF labelWithString:@"" fontName:@"ArialMT" fontSize:32];
        _label.color = [CCColor grayColor];
        _label.position = CGPointMake([Helper screenSize].width * 0.5f, [Helper screenSize].height * 0.66f);
        [self addChild:_label z:1];
    }
    return self;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint touchLocation = [Helper locationFromTouch:touch];
    //NSLog(@"touch pos:%f,%f",touchLocation.x,touchLocation.y);
    CGRect restartLabelRect = CGRectMake(_restartLabel.position.x - _restartLabel.contentSize.width * 0.5f, _restartLabel.position.y - _restartLabel.contentSize.height * 0.5f, _restartLabel.contentSize.width, _restartLabel.contentSize.height);
    //NSLog(@"restartLabelRect:%f,%f,%f,%f",restartLabelRect.origin.x,restartLabelRect.origin.y,restartLabelRect.size.width,restartLabelRect.size.height);
    if (CGRectContainsPoint(restartLabelRect, touchLocation)) {
        TileMapScene *tileMapscene = [TileMapScene scene];
        [[CCDirector sharedDirector] replaceScene:tileMapscene];
    }
}

// -----------------------------------------------------------------

@end

                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               



