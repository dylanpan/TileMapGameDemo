//
//  TileMapScene.m
//
//  Created by : 潘安宇
//  Project    : 90DegreeTileMapGameTwo
//  Date       : 2017/10/24
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "TileMapScene.h"
#import "ScoreHUDLayer.h"
#import "Helper.h"
#import "Enemy.h"
#import "TankBullet.h"
#import "GameOverScene.h"
#import "TowerBullet.h"

@interface TileMapScene(PrivateMethods)
- (void)setViewPointCenter:(CGPoint)point;
- (void)divisionRegionInFourParts;
@end

// -----------------------------------------------------------------

@implementation TileMapScene

// -----------------------------------------------------------------
static Player *insranceOfPlayer;
static CGFloat tanAngle;
static CGFloat rotateAngle;

+ (id)scene{
    CCScene *scene = [CCScene node];
    TileMapScene *tileMapLayer = [TileMapScene node];
    [scene addChild:tileMapLayer];
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
        _tileMap = [CCTiledMap tiledMapWithFile:@"tank.tmx"];
        [self addChild:_tileMap z:-1 name:@"TileMapNode"];
        self.userInteractionEnabled = YES;
        
        _backgroundLayer = [_tileMap layerNamed:@"BackgroundLayer"];
        _getThingLayer = [_tileMap layerNamed:@"GetThingLayer"];
        _eventLayer = [_tileMap layerNamed:@"EventLayer"];
        _eventLayer.visible = NO;
        
        _player = [Player spawnPlayer];
        _player.position = [self GLPointInTileMapByObjectLayerName:@"StartPoint"];
        _player.anchorPoint = CGPointMake(0.5f, 0.5f);
        insranceOfPlayer = _player;
        //若player成为self的child有问题，解决了player的初始位置不显示与移动和tile map不同步的问题，参照点问题
        [_tileMap addChild:_player z:1 name:@"PlayerNode"];
        
        _tower = [Tower spawnTower];
        _tower.position = [self GLPointInTileMapByObjectLayerName:@"TowerPoint"];
        _tower.userObject = [NSValue valueWithCGPoint:[self GLPointInTileMapByObjectLayerName:@"TowerPoint"]];
        _tower.anchorPoint = CGPointMake(0.366f, 0.5f);
        [_tileMap addChild:_tower z:0 name:@"TowerNode"];
        
        [self setViewPointCenter:_player.position];
        [self divisionRegionInFourParts];
        _currentType = MoveDirectionTypeNone;
        
        ScoreHUDLayer *scoreLabel = [ScoreHUDLayer node];
        [self addChild:scoreLabel z:2 name:@"ScoreLabelNode"];
        
        _enemies = [[NSMutableArray alloc] init];
        _bullets = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (Player *)sharePlayer{
    return insranceOfPlayer;
}

- (CGPoint)GLPointInTileMapByObjectLayerName:(NSString *)objectLayerName{
    CCTiledMapObjectGroup *objectLayer = [_tileMap objectGroupNamed:@"ObjectLayer"];
    NSMutableDictionary *GLPoint = [objectLayer objectNamed:objectLayerName];
    NSInteger GLPosX = [[GLPoint valueForKey:@"x"] integerValue];
    NSInteger GLPosY = [[GLPoint valueForKey:@"y"] integerValue];
    return CGPointMake(GLPosX, GLPosY);
}

- (void)setViewPointCenter:(CGPoint)point{
    CGPoint screenCenter = [Helper screenCenter];
    
    //屏幕左边、下边用max，屏幕右边、上边用min
    NSInteger posX = MAX(point.x, screenCenter.x);
    posX = MIN(posX, _tileMap.mapSize.width * _tileMap.tileSize.width - screenCenter.x);
    NSInteger posY = MAX(point.y, screenCenter.y);
    posY = MIN(posY, _tileMap.mapSize.height * _tileMap.tileSize.height - screenCenter.y);
    
    CGPoint actualPoint = CGPointMake(posX, posY);
    CGPoint diffPoint = CGPointMake(screenCenter.x - actualPoint.x, screenCenter.y - actualPoint.y);
    //相当于坐标系转换，地图移动
    //为什么self.position不能出发touch delegate methods？？
    _tileMap.position = diffPoint;
    //NSLog(@"\nplayer pos:%f,%f\ntile map pos:%f,%f\nself pos:%f,%f",_player.position.x,_player.position.y,diffPoint.x,diffPoint.y,self.position.x,self.position.y);
}

//需要修改成对角线划分的四区域
- (void)divisionRegionInFourParts{
    CGPoint screenCenter = [Helper screenCenter];
    _upperLeftAreaRect = CGRectMake(0.0f, screenCenter.y, screenCenter.x, screenCenter.y);
    _lowerLeftAreaRect = CGRectMake(0.0f, 0.0f, screenCenter.x, screenCenter.y);
    _lowerRightAreaRect = CGRectMake(screenCenter.x, 0.0f, screenCenter.x, screenCenter.y);
    _upperRightAreaRect = CGRectMake(screenCenter.x, screenCenter.y, screenCenter.x, screenCenter.y);
    
    _moveOffsets = [[NSMutableArray alloc] initWithCapacity:MoveDirectionTypesMax];
    [_moveOffsets insertObject:[NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)] atIndex:MoveDirectionTypeNone];
    [_moveOffsets insertObject:[NSValue valueWithCGPoint:CGPointMake(0.0f, -1.0f)] atIndex:MoveDirectionTypeUpper];
    [_moveOffsets insertObject:[NSValue valueWithCGPoint:CGPointMake(-1.0f, -1.0f)] atIndex:MoveDirectionTypeUpperLeft];
    [_moveOffsets insertObject:[NSValue valueWithCGPoint:CGPointMake(-1.0f, 0.0f)] atIndex:MoveDirectionTypeLeft];
    [_moveOffsets insertObject:[NSValue valueWithCGPoint:CGPointMake(-1.0f, 1.0f)] atIndex:MoveDirectionTypeLowerLeft];
    [_moveOffsets insertObject:[NSValue valueWithCGPoint:CGPointMake(0.0f, 1.0f)] atIndex:MoveDirectionTypeLower];
    [_moveOffsets insertObject:[NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)] atIndex:MoveDirectionTypeLowerRight];
    [_moveOffsets insertObject:[NSValue valueWithCGPoint:CGPointMake(1.0f, 0.0f)] atIndex:MoveDirectionTypeRight];
    [_moveOffsets insertObject:[NSValue valueWithCGPoint:CGPointMake(1.0f, -1.0f)] atIndex:MoveDirectionTypeUpperRight];
    
}

//左上角到右下角的直线方程
- (BOOL)negativeLinearEquation:(CGPoint)point{
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    CGFloat y = - screenSize.height * point.x / (CGFloat)screenSize.width + screenSize.height;
    if (y <= point.y) {
        return YES;
    }else{
        return NO;
    }
}
//左下角到右上角的直线方程
- (BOOL)positiveLinearEquation:(CGPoint)point{
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    CGFloat y = screenSize.height * point.x / (CGFloat)screenSize.width;
    if (y <= point.y) {
        return YES;
    }else{
        return NO;
    }
}

- (void)divisionRegionInFourParts:(MoveDirectionTypes)areaType touchPoint:(CGPoint)point{
    switch (areaType) {
        case MoveDirectionTypeUpperLeft:
            //左上角区域
            if ([self negativeLinearEquation:point]) {
                _currentType = MoveDirectionTypeUpper;
            }else{
                _currentType = MoveDirectionTypeLeft;
            }
            break;
            
        case MoveDirectionTypeLowerRight:
            //右下角区域
            if ([self negativeLinearEquation:point]) {
                _currentType = MoveDirectionTypeRight;
            }else{
                _currentType = MoveDirectionTypeLower;
            }
            break;
            
        case MoveDirectionTypeUpperRight:
            //右上角区域
            if ([self positiveLinearEquation:point]) {
                _currentType = MoveDirectionTypeUpper;
            }else{
                _currentType = MoveDirectionTypeRight;
            }
            break;
            
        case MoveDirectionTypeLowerLeft:
            //左下角区域
            if ([self positiveLinearEquation:point]) {
                _currentType = MoveDirectionTypeLeft;
            }else{
                _currentType = MoveDirectionTypeLower;
            }
            break;
            
        default:
            [NSException exceptionWithName:@"TouchArea Exception" reason:@"unhandled TouchArea type" userInfo:nil];
            break;
    }
}

- (void)playerRotate{
    if (_currentType == MoveDirectionTypeRight) {
        _player.rotation = 90;
    }else if (_currentType == MoveDirectionTypeLower) {
        _player.rotation = 180;
    }else if (_currentType == MoveDirectionTypeLeft) {
        _player.rotation = 270;
    }else if (_currentType == MoveDirectionTypeUpper) {
        _player.rotation = 0;
    }
    
}

- (CGPoint)tileCoordFromLocation:(CGPoint)location{
    NSInteger posX = location.x / _tileMap.tileSize.width;
    NSInteger posY = (_tileMap.mapSize.height * _tileMap.tileSize.height - location.y) / _tileMap.tileSize.height;
    return CGPointMake(posX, posY);
}

- (BOOL)checkCollisionsInEventLayer:(CGPoint)point{
    BOOL isCollisions = NO;
    CGPoint collisionPos = [self tileCoordFromLocation:point];
    NSUInteger tileGID = [_eventLayer tileGIDAt:collisionPos];
    if (tileGID != 0) {
        NSDictionary *properties = [_tileMap propertiesForGID:tileGID];
        if (properties) {
            NSString *stringInEventLayer = [properties valueForKey:@"isCollisions"];
            isCollisions = [stringInEventLayer boolValue];
        }
    }
    return isCollisions;
}

//判断碰撞的是单个tile的四边形的右上角顶点
- (void)checkCollectableInGetThingLayer:(CGPoint)point{
    CGPoint collectablePos = [self tileCoordFromLocation:point];
    NSUInteger tileGID = [_eventLayer tileGIDAt:collectablePos];
    if (tileGID != 0) {
        NSDictionary *properties = [_tileMap propertiesForGID:tileGID];
        if (properties) {
            NSString *stringInEventLayer = [properties valueForKey:@"isCollectable"];
            if ([stringInEventLayer boolValue]) {
                [self getScoreByCollected];
                [_eventLayer removeTileAt:collectablePos];
                [_getThingLayer removeTileAt:collectablePos];
            }
        }
    }
}

- (void)getScoreByCollected{
    _score++;
    CCNode *node = [self getChildByName:@"ScoreLabelNode" recursively:YES];
    NSAssert([node isKindOfClass:[ScoreHUDLayer class]], @"not a ScoreHUDLayer node");
    ScoreHUDLayer *scoreLabel = (ScoreHUDLayer *)node;
    [scoreLabel numCollectedChanged:_score];
    //[[OALSimpleAudio sharedInstance] playEffect:@"alien-sfx.caf"];
    if (_score == 10) {
        //game over - win页面
        GameOverScene *gameOverScene = [GameOverScene node];
        gameOverScene.label.string = [NSString stringWithFormat:@"YOU WIN"];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
}

- (BOOL)checkSpawnEnemyLineInEventLayer:(CGPoint)point{
    BOOL isSpawnEnemy = NO;
    CGPoint collisionsPos = [self tileCoordFromLocation:point];
    NSUInteger tileGID = [_eventLayer tileGIDAt:collisionsPos];
    if (tileGID != 0) {
        NSDictionary *properties = [_tileMap propertiesForGID:tileGID];
        if (properties) {
            NSString *stringInEventLayer = [properties valueForKey:@"isSpawnEnemy"];
            isSpawnEnemy = [stringInEventLayer boolValue];
        }
    }
    return isSpawnEnemy;
}

- (void)checkEnemyCollisionsByBullet{
    CGRect enemyRect;
    CGRect bulletRect;
    CGRect playerRect = CGRectMake(_player.position.x, _player.position.y, _player.contentSize.width, _player.contentSize.height);
    
    NSArray *children = [_tileMap children];
    //NSLog(@"%@",children);
    NSMutableArray *myChildren = [[NSMutableArray alloc] initWithArray:children];
    for (CCNode *node in myChildren) {
        if ([node isKindOfClass:[Enemy class]]) {
            Enemy *enemy = (Enemy *)node;
            CGPoint enemyGLPos = [enemy.userObject CGPointValue];
            enemyRect = CGRectMake(enemyGLPos.x, enemyGLPos.y, enemy.contentSize.width, enemy.contentSize.height);
            if (CGRectIntersectsRect(playerRect, enemyRect)) {
                //game over - lose页面
                GameOverScene *gameOverScene = [GameOverScene node];
                gameOverScene.label.string = [NSString stringWithFormat:@"YOU LOSE"];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
                break;
            }
            for (CCNode *nodeIn in myChildren) {
                if ([nodeIn isKindOfClass:[TankBullet class]]) {
                    TankBullet *bullet = (TankBullet *)nodeIn;
                    CGPoint bulletGLPos = [bullet.userObject CGPointValue];
                    bulletRect = CGRectMake(bulletGLPos.x, bulletGLPos.y, bullet.contentSize.width, bullet.contentSize.height);
                    if (CGRectIntersectsRect(bulletRect, enemyRect)) {
                        [self getScoreByCollected];
                        //当多个敌人重叠时，与子弹发生碰撞，会产生bug【This node does not contain the specified child.】
                        [_tileMap removeChild:enemy cleanup:YES];
                        [_tileMap removeChild:bullet cleanup:YES];
                        _numberOfEnemy--;
                        _updateCount = 0;
                    }
                }else if ([nodeIn isKindOfClass:[TowerBullet class]]) {
                    TowerBullet *bullet = (TowerBullet *)nodeIn;
                    CGPoint bulletGLPos = bullet.position;
                    bulletRect = CGRectMake(bulletGLPos.x, bulletGLPos.y, bullet.contentSize.width, bullet.contentSize.height);
                    if (CGRectIntersectsRect(bulletRect, enemyRect)) {
                        [self getScoreByCollected];
                        [_tileMap removeChild:enemy cleanup:YES];
                        [_tileMap removeChild:bullet cleanup:YES];
                        _numberOfEnemy--;
                        _updateCount = 0;
                        _numberOfTowerBullet = 0;
                    }
                }
            }
        }
    }
}

- (void)checkEnemyByTower{
    CGPoint towerGLPos = [_tower.userObject CGPointValue];
    CGRect towerRect = CGRectMake(towerGLPos.x - _tileMap.tileSize.width * 4.0f, towerGLPos.y - _tileMap.tileSize.height * 3.0f, _tileMap.tileSize.width * 6.0f, _tileMap.tileSize.height * 6.0f);
    
    NSArray *children = [_tileMap children];
    //NSLog(@"%@",children);
    NSMutableArray *myChildren = [[NSMutableArray alloc] initWithArray:children];
    for (CCNode *node in myChildren) {
        if ([node isKindOfClass:[Enemy class]]) {
            Enemy *enemy = (Enemy *)node;
            CGPoint enemyGLPos = [enemy.userObject CGPointValue];
            CGPoint diffPos = ccpSub(towerGLPos, enemyGLPos);
            if (CGRectContainsPoint(towerRect, enemyGLPos)) {
                if (_numberOfTowerBullet < 1) {
                    //tower转向
                    [self towerRotateAction:_tower RotateByPoint:diffPos];
                    //发射子弹
                    TowerBullet *towerBullet = [TowerBullet spwanTowerBullet];
                    _numberOfTowerBullet++;
                    [_tileMap addChild:towerBullet z:1 name:@"TowerBulletNode"];
                    towerBullet.position = towerGLPos;
                    //子弹发射后的终点
                    [self towerShootEnemy:diffPos towerBullet:towerBullet];
                }
            }
        }
    }
}

- (void)towerRotateAction:(Tower *)tower RotateByPoint:(CGPoint)diffPos{
    CGFloat angleRadians = atanf((CGFloat)diffPos.y / (CGFloat)diffPos.x);
    CGFloat angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    tanAngle = fabs(angleDegrees);
    CGFloat rotateSpeed = 0.5f / M_PI;//0.5转PI
    CGFloat rotateDuration = fabs(angleRadians * rotateSpeed);
    if (diffPos.x > 0 && diffPos.y < 0) {//以tower为中心，左上角区域
        rotateAngle = (-1) * (180 - tanAngle);
    }else if (diffPos.x < 0 && diffPos.y < 0) {//以tower为中心，右上角区域
        rotateAngle = (-1) * tanAngle;
    }else if (diffPos.x < 0 && diffPos.y > 0) {//以tower为中心，右下角区域
        rotateAngle = tanAngle;
    }else if (diffPos.x > 0 && diffPos.y > 0) {//以tower为中心，左下角区域
        rotateAngle = 180 - tanAngle;
    }else if (diffPos.x == 0 && diffPos.y < 0) {//以tower为中心，上边
        rotateAngle = -90;
    }else if (diffPos.x == 0 && diffPos.y > 0) {//以tower为中心，下边
        rotateAngle = 90;
    }else if (diffPos.x > 0 && diffPos.y == 0) {//以tower为中心，左边
        rotateAngle = 180;
    }else if (diffPos.x < 0 && diffPos.y == 0) {//以tower为中心，右边
        rotateAngle = 0;
    }
    CCActionRotateTo *actionRotate = [CCActionRotateTo actionWithDuration:rotateDuration angle:rotateAngle];
    [tower runAction:actionRotate];
}

- (void)towerShootEnemy:(CGPoint)diffPos towerBullet:(TowerBullet *)towerBullet{
    CGPoint towerGLPos = [_tower.userObject CGPointValue];
    CGFloat tileMapWidth = _tileMap.mapSize.width * _tileMap.tileSize.width;
    CGFloat tileMapHeight = _tileMap.mapSize.height * _tileMap.tileSize.height;
    CGFloat tanValue = fabs((CGFloat)diffPos.y / (CGFloat)diffPos.x);
    CGPoint endPos;
    if (diffPos.x > 0 && diffPos.y < 0) {//以tower为中心，左上角区域
        if (tanAngle < 45) {
            endPos = CGPointMake(0.0f, towerGLPos.y + tanValue * towerGLPos.x);
        }else if (tanAngle == 45) {
            endPos = CGPointMake(0.0f, tileMapHeight);
        }else if (tanAngle > 45) {
            endPos = CGPointMake(towerGLPos.x - (tileMapHeight - towerGLPos.y) / tanValue, tileMapHeight);
        }
    }else if (diffPos.x < 0 && diffPos.y < 0) {//以tower为中心，右上角区域
        if (tanAngle < 45) {
            endPos = CGPointMake(tileMapWidth, towerGLPos.y + tanValue * (tileMapWidth - towerGLPos.x));
        }else if (tanAngle == 45) {
            endPos = CGPointMake(tileMapWidth, tileMapHeight);
        }else if (tanAngle > 45) {
            endPos = CGPointMake(towerGLPos.x + (tileMapHeight - towerGLPos.y) / tanValue, tileMapHeight);
        }
    }else if (diffPos.x < 0 && diffPos.y > 0) {//以tower为中心，右下角区域
        if (tanAngle < 45) {
            endPos = CGPointMake(tileMapWidth, towerGLPos.y - tanValue * (tileMapWidth - towerGLPos.x));
        }else if (tanAngle == 45) {
            endPos = CGPointMake(tileMapWidth, 0.0f);
        }else if (tanAngle > 45) {
            endPos = CGPointMake(towerGLPos.x + towerGLPos.y / tanValue, 0.0f);
        }
    }else if (diffPos.x > 0 && diffPos.y > 0) {//以tower为中心，左下角区域
        if (tanAngle < 45) {
            endPos = CGPointMake(0.0f, towerGLPos.y - tanValue * towerGLPos.x);
        }else if (tanAngle == 45) {
            endPos = CGPointMake(0.0f, 0.0f);
        }else if (tanAngle > 45) {
            endPos = CGPointMake(towerGLPos.x - towerGLPos.y / tanValue, 0.0f);
        }
    }else if (diffPos.x == 0 && diffPos.y < 0) {//以tower为中心，上边
        endPos = CGPointMake(towerGLPos.x, tileMapHeight);
    }else if (diffPos.x == 0 && diffPos.y > 0) {//以tower为中心，下边
        endPos = CGPointMake(towerGLPos.x, 0.0f);
    }else if (diffPos.x > 0 && diffPos.y == 0) {//以tower为中心，左边
        endPos = CGPointMake(0.0f, towerGLPos.y) ;
    }else if (diffPos.x < 0 && diffPos.y == 0) {//以tower为中心，右边
        endPos = CGPointMake(tileMapWidth, towerGLPos.y);
    }
    
    //子弹的速度
    NSInteger offEndX = endPos.x - towerBullet.position.x;
    NSInteger offEndY = endPos.y - towerBullet.position.y;
    CGFloat length = sqrtf((offEndX * offEndX) + (offEndY * offEndY));
    CGFloat velocity = 568 / 1.0f;//568pixels / 1sec
    CGFloat moveDuration = length / velocity;
    
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:moveDuration position:endPos];
    CCActionCallFunc *actionMoveDone = [CCActionCallFunc actionWithTarget:self selector:@selector(actionMoveDone)];
    [towerBullet runAction:[CCActionSequence actions:actionMove, actionMoveDone, nil]];
}

- (void)actionMoveDone{
    NSArray *children = [_tileMap children];
    //NSLog(@"%@",children);
    NSMutableArray *myChildren = [[NSMutableArray alloc] initWithArray:children];
    for (CCNode *node in myChildren) {
        if ([node isKindOfClass:[TowerBullet class]]) {
            TowerBullet *towerBullet = (TowerBullet *)node;
            [towerBullet stopAllActions];
            [_tileMap removeChild:towerBullet cleanup:YES];
            _numberOfTowerBullet = 0;
        }
    }
}

- (void)playerShootEnemy:(CGPoint)touchLocation{
    NSArray *children = [_tileMap children];
    //NSLog(@"%@",children);
    NSMutableArray *myChildren = [[NSMutableArray alloc] initWithArray:children];
    for (CCNode *node in myChildren) {
        if ([node isKindOfClass:[Enemy class]]) {
            Enemy *enemy = (Enemy *)node;
            CGPoint enemyGLPos = [enemy.userObject CGPointValue];
            CGPoint touchGLPos = ccpSub(touchLocation, _tileMap.position);
            //NSLog(@"\n----------\nenemy pos info:%f,%f\ntouch pos info:%f,%f\n----------\n",enemyGLPos.x,enemyGLPos.y,touchGLPos.x,touchGLPos.y);
            CGRect enemyRect = CGRectMake(enemyGLPos.x, enemyGLPos.y, enemy.contentSize.width, enemy.contentSize.height);
            if (CGRectContainsPoint(enemyRect, touchGLPos)) {
                //player发射子弹
                TankBullet *bullet = [TankBullet spwanBullet];
                [bullet addBulletInTileMap:_tileMap tracingEnemy:enemy];
                _currentType = MoveDirectionTypeNone;
                [_bullets addObject:bullet];
            }
        }
    }
}

#pragma touch delegate methods
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint touchLocation = [Helper locationFromTouch:touch];
    [self playerShootEnemy:touchLocation];
    
    if (CGRectContainsPoint(_upperLeftAreaRect, touchLocation)) {
        [self divisionRegionInFourParts:MoveDirectionTypeUpperLeft touchPoint:touchLocation];
    }else if (CGRectContainsPoint(_lowerLeftAreaRect, touchLocation)) {
        [self divisionRegionInFourParts:MoveDirectionTypeLowerLeft touchPoint:touchLocation];
    }else if (CGRectContainsPoint(_lowerRightAreaRect, touchLocation)) {
        [self divisionRegionInFourParts:MoveDirectionTypeLowerRight touchPoint:touchLocation];
    }else if (CGRectContainsPoint(_upperRightAreaRect, touchLocation)) {
        [self divisionRegionInFourParts:MoveDirectionTypeUpperRight touchPoint:touchLocation];
    }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    _currentType = MoveDirectionTypeNone;
}


- (void)update:(CCTime)delta{
    _updateCount++;
    if (_currentType != MoveDirectionTypeNone) {
        CGPoint offsetPoint = [[_moveOffsets objectAtIndex:_currentType] CGPointValue];
        CGPoint moveToPoint = CGPointMake(_player.position.x + offsetPoint.x, _player.position.y + offsetPoint.y * (-1));
        if (moveToPoint.x <= ((_tileMap.mapSize.width - 1) * _tileMap.tileSize.width) && moveToPoint.y <= ((_tileMap.mapSize.height - 1) * _tileMap.tileSize.height) && moveToPoint.x >= 0 && moveToPoint.y >= 0) {
            if ([self checkCollisionsInEventLayer:moveToPoint]) {
                _currentType = MoveDirectionTypeNone;
            }else{
                [self checkCollectableInGetThingLayer:moveToPoint];
                _player.position = moveToPoint;
                [self playerRotate];
            }
            if ([self checkSpawnEnemyLineInEventLayer:moveToPoint]) {
                if (_numberOfEnemy < 5 && (_updateCount % 240 == 0)) {
                    Enemy *enemy = [Enemy spwanEnemy];
                    [enemy addEnemyInTileMap:_tileMap tracingPlayer:_player];
                    [_enemies addObject:enemy];
                    _numberOfEnemy++;
                }
            }
        }
        [self setViewPointCenter:CGPointMake(_player.position.x, _player.position.y)];
    }
    [self checkEnemyCollisionsByBullet];
    [self checkEnemyByTower];
}

// -----------------------------------------------------------------

@end































