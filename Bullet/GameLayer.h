//
//  GameLayer.h
//  Bullet
//
//  Created by Mobile-X on 13. 6. 27..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface GameLayer : CCLayer {
    
    CCAnimate *sitAnimate;
    CCAnimate *smokeAnimate;
    CCAnimate *tailAnimate;
    CCSprite *gunSmoke;
    CCArray *birdArray;
    CCArray *sitPositions;
    
    //int형인 남은 총알의 개수 bulletCountf를 전역변수로 선언합니다.
    int bulletCount;
    //총알의 전체적인 이미지를 나타내는 스프라이트 ptBulletSprite를 전역변수로 선언합니다.
    CCSprite *ptBulletSprite;
    //총알의 개수를 막대이미지로 나타내는 CCProgressTimer 타입의 ptBullet을 전역변수로 선언합니다.
    CCProgressTimer *ptBullet;

}
+(CCScene *) scene;
-(CGPoint)getStartPosition;
@end
