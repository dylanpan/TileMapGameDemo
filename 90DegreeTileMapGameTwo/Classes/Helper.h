//
//  Helper.h
//  90DegreeTileMapGameTwo
//
//  Created by 潘安宇 on 2017/10/24.
//  Copyright © 2017年 潘安宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Helper : NSObject

+ (CGPoint) locationFromTouch:(CCTouch *)touch;
+ (CGPoint) screenCenter;
+ (CGSize)screenSize;

@end
