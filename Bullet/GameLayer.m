//
//  GameLayer.m
//  Bullet
//
//  Created by Mobile-X on 13. 6. 27..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#define FRONT_CLOUD_SIZE 563
#define BACK_CLOUD_SIZE  509
#define FRONT_CLOUD_TOP  310
#define BACK_CLOUD_TOP   230
//최대 총알의 개수(7개)를 매크로상수로 정의합니다.
#define MAX_BULLET_COUNT 7


@implementation GameLayer

-(void)dealloc {
    [sitAnimate release];
    [tailAnimate release];
    [smokeAnimate release];
    
    [gunSmoke release];
    [birdArray release];
    
    [super dealloc];
}
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}

- (void)createCloudWithSize:(int)imgSize top:(int)imgTop fileName:(NSString*)fileName interval:(int)interval z:(int)z {
    id enterRight	= [CCMoveTo actionWithDuration:interval position:ccp(0, imgTop)];
    id enterRight2	= [CCMoveTo actionWithDuration:interval position:ccp(0, imgTop)];
    id exitLeft		= [CCMoveTo actionWithDuration:interval position:ccp(-imgSize, imgTop)];
    id exitLeft2	= [CCMoveTo actionWithDuration:interval position:ccp(-imgSize, imgTop)];
    id reset		= [CCMoveTo actionWithDuration:0  position:ccp( imgSize, imgTop)];
    id reset2		= [CCMoveTo actionWithDuration:0  position:ccp( imgSize, imgTop)];
    id seq1			= [CCSequence actions: exitLeft, reset, enterRight, nil];
    id seq2			= [CCSequence actions: enterRight2, exitLeft2, reset2, nil];
    
    CCSprite *spCloud1 = [CCSprite spriteWithFile:fileName];
    [spCloud1 setAnchorPoint:ccp(0,1)];
    [spCloud1.texture setAliasTexParameters];
    [spCloud1 setPosition:ccp(0, imgTop)];
    [spCloud1 runAction:[CCRepeatForever actionWithAction:seq1]];
    [self addChild:spCloud1 z:z ];
    
    CCSprite *spCloud2 = [CCSprite spriteWithFile:fileName];
    [spCloud2 setAnchorPoint:ccp(0,1)];
    [spCloud2.texture setAliasTexParameters];
    [spCloud2 setPosition:ccp(imgSize, imgTop)];
    [spCloud2 runAction:[CCRepeatForever actionWithAction:seq2]];
    [self addChild:spCloud2 z:z ];
}

- (void)createGun {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gun.plist"];
    
    gunSmoke = [[CCSprite alloc] init];
    [self addChild:gunSmoke z:7];
    
    
    NSMutableArray *smokeFrames = [NSMutableArray array];
    for(NSInteger idx = 1; idx < 10; idx++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"shotgun_smoke2_%04d.png",idx]];
        [smokeFrames addObject:frame];
    }
    CCAnimation *smokeAnimation = [CCAnimation animationWithSpriteFrames:smokeFrames delay:.05f];
    smokeAnimate = [[CCAnimate alloc] initWithAnimation:smokeAnimation];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"gun.plist"];
}

-(CGPoint)getStartPosition {
	int starty=0;
    int startx = arc4random()%540-30;
    if (startx>0 && startx<480) {
        starty=400;
    } else {
        starty = arc4random()%200+100;
    }
	return ccp(startx, starty);
}


- (void)createBird {
    //스프라이트 프레임 케쉬에 스프라이트를 저장합니다.
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bluebird.plist"];
    
    CCSprite *bird = [[CCSprite alloc] init];
    // getStartPosition에서 생성된 좌표값을 bird 좌표에 반환합니다.
    [bird setPosition:[self getStartPosition]];
    
    [self addChild:bird z:5];
    // birdArray 배열에 bird를 넣습니다.
    [birdArray addObject:bird];
    
    [bird release];
    
    //프레임을 담을 NSMutableArray형의 flyFrames이름의 배열을 만듭니다.
    NSMutableArray *flyFrames = [NSMutableArray array];
    //NSInteger형의 idx변수가 1부터 17미만이 될 때까지 1씩 증가시키며 for구문을 실행시킵니다.
    for(NSInteger idx = 1; idx < 17; idx++) {
        //알맞은 이미지를 프레임에 순서대로 담습니다.
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"blue_fly%04d.png",idx]];
        //프레임을 배열에 저장합니다.
        [flyFrames addObject:frame];
    }
    //프레임으로 CCAimation을 만듭니다. 각 프레임당 시간을 0.05초로 정해줍니다.
    CCAnimation *flyAnimation = [CCAnimation animationWithSpriteFrames:flyFrames delay:0.05f];
    //CCAnimation에  action을 줄 CCAnimte를 만듭니다.
    CCAnimate *flyAnimate = [[CCAnimate alloc] initWithAnimation:flyAnimation];
    
    //프레임을 담을 NSMutableArray형의 sitFrames이름의 배열을 만듭니다.
    NSMutableArray *sitFrames = [NSMutableArray array];
    //NSInteger형의 idx변수가 1부터 61미만이 될 때까지 1씩 증가시키며 for구문을 실행시킵니다.
    for (NSInteger idx = 1; idx <61; idx++)  {
        //알맞은 이미지를 프레임에 순서대로 담습니다.
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"blue_sit_%04d.png",idx]];
        //프레임을 배열에 저장합니다.
        [sitFrames addObject:frame];
    }
    //프레임으로 CCAimation을 만듭니다. 각 프레임당 시간을 0.05초로 정해줍니다.
    CCAnimation *sitAnimation = [CCAnimation animationWithSpriteFrames:sitFrames delay:0.05f];
    //CCAnimation에  action을 줄 CCAnimte를 만듭니다.
    sitAnimate = [[CCAnimate alloc] initWithAnimation:sitAnimation];
    NSMutableArray *tailFrames = [NSMutableArray array];
    for (NSInteger idx = 1; idx <16; idx++)  {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"blue_tail_%04d.png",idx]];
        [tailFrames addObject:frame];
    }
    
    CCAnimation *tailAnimation = [CCAnimation animationWithSpriteFrames:tailFrames delay:0.05f];
    tailAnimate = [[CCAnimate alloc] initWithAnimation:tailAnimation];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"bluebird.plist"];
    
    
    
    //CCRepeatForever를 사용하여 flyAnimaite를 반복 실행합니다.
    id actionFlyRepeat  = [CCRepeatForever actionWithAction:flyAnimate];
    //runAction을 사용하여 새가 움직이도록 해 봅니다.
    [bird runAction:actionFlyRepeat];
    
    // sitPositions 배열에 저장해 놓은 좌표 중 하나를 value에 넣습니다.
    //(sitPositions 배열의 갯수가 10개 이므로 (sitPositions 정의 부분 참고) arc4random()%10 을 이용하여 0 번째부터 9 번째 배열중 하나를 value에 넣는 것입니다.)
    NSValue *value = [sitPositions objectAtIndex:arc4random()%10];
    
    // value를 CGPoint형으로 변환시켜 sitPoint를 만듭니다.
    // sutPoint는 새가 앉는 위치 입니다.
    CGPoint sitPoint = [value CGPointValue];
    
    //  sitPoint까지 움직이는 객체를 생성하고, moveComlete를 수행하는 객체를 만들어 두 동작을 이어 하는 actionSeqence를 만듭니다.
    id actionMoveTo = [CCMoveTo actionWithDuration:2 position:sitPoint];
    id moveComplete = [CCCallFuncN actionWithTarget:self selector:@selector(moveComplete:)];
    id actionSeqence= [CCSequence actions:actionMoveTo, moveComplete, nil];
    
    // bird에게 actionSeqence를 실행하게 합니다.
    [bird runAction:actionSeqence];
}

-(void)moveComplete:(id)bird {
    //미리 만든 bird스프라이트에서 하나씩 실행합니다.
    CCSprite *sprite = (CCSprite *)bird;
    //스프라이트의 모든 액션을 중지합니다.
    [sprite stopAllActions];
    //CCRepeatForever를 사용하여 sitAnimate를 실행하도록 합니다.
    id actionSitRepeat = [CCRepeatForever actionWithAction:sitAnimate];
    //runAction을 사용하여 주어진 액션을 실행하도록합니다.
    [sprite runAction:actionSitRepeat];
    
}



// 객체가 터치 되었는지 판별하는 메소드입니다.
// ccpDistance는 target 과 터치한 위치 touchPoint 간의 거리를 계산해 줍니다.
- (BOOL)isHitWithTarget:(CCSprite *)target touchPoint:(CGPoint)touchPoint {
    // target과 touchPoint 간의 거리가 (target의 크기/2) 이면 터치한 것으로 판단하여 YES 값을 반환합니다.
	if(ccpDistance(target.position, touchPoint) < target.contentSize.width /2) return YES;
    // 그러지 않다면 NO 값을 반환합니다.
	return NO;
}

// 객체가 터치 되었는지 판별하는 메소드입니다.
// ccpDistance 을 사용하지 않는 방법입니다.
- (BOOL)isTouchInside:(CCSprite*)sprite touchPoint:(CGPoint)touchPoint {
	CGFloat halfWidth   = sprite.contentSize.width /2.0;
	CGFloat halfHeight  = sprite.contentSize.height /2.0;
    
    // touchPoint 가 sprite의 넓이 외에 있으면 터치되지 않은 것으로 판별하여 NO 값을 반환합니다.
	if (touchPoint.x>(sprite.position.x+halfWidth) ||
		touchPoint.x<(sprite.position.x-halfWidth) ||
		touchPoint.y<(sprite.position.y-halfHeight)||
		touchPoint.y>(sprite.position.y+halfHeight) )		{
		return NO;
	}
    
    // 그렇지 않다면 YES 값을 반환합니다.
	return YES;
}

// 새가 터치가 되었을 시 수행하는 동작을 담은 메소드입니다.
-(void)birdisDead:(CCSprite*)bird {
    
    // bird 행하는 모든 Action을 멈춥니다.
    [bird stopAllActions];
    
    // removeBird: 메소드를 담은 객체 tailComplete 만듭니다.
    id tailComplete = [CCCallFuncN actionWithTarget:self selector:@selector(removeBird:)];
    
    // tailAnimate,  tailComplete를 순차적으로 진행하는 객체 actionSeq를 만든 뒤,
    // bird가  actionSeq를 행하도록 실행시킵니다.
    id actionSeq = [CCSequence actions:tailAnimate, tailComplete, nil];
    [bird runAction:actionSeq];
}

// removeBird: 메소드는 bird 를 메모리 해제하는 메소드 입니다.
-(void)removeBird:(CCSprite*)bird {
    // removeChild란 addChild 한 객체를 지워주는 매개변수입니다.
    // bird를 제거함으로서 메모리가 불필요하게 쌓이는 것을 막습니다.
    [self removeChild:bird cleanup:YES];
}

-(id) init
{
	if( (self=[super init])) {
        self.isTouchEnabled = YES;
        //남은 총알의 개수를 최대 총알의 개수로 지정합니다.
        bulletCount = MAX_BULLET_COUNT;
        
        //총이 쐈을 경우를 위한 사운드 효과를 preload를 사용하여 미리 메모리에 올려 놓습니다.
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"handgun_fire.wav"];
        //배경음악을 위한 음악을 preload를 사용하여 미리 메모리에 올려 놓습니다.
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bird.m4a"];
        //게임이 시작되면 배경 백그라운드 음악이 재생됩니다.
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bird.m4a" loop:YES];
        //배경 백그라운드 음악의 음량을 0.5로 조절합니다.
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
        //사운드 효과의 음량을 0.5로 지정합니다.
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5f];
        
        // CCArray 형 birdArray를 만듭니다.
        // CCArray는 cocos2d 에서 제공하는 배열입니다.
        // birdArray는 생성되는 bird를 담아두는 배열입니다.
        // 후에 bird sprite를 충돌 검사를 할 시에 쓰입니다.
        birdArray = [[CCArray alloc] init];
        
        CCSprite *back = [CCSprite spriteWithFile:@"back.png"];
        [back setPosition:ccp(240, 160)];
        [self addChild:back z:0];
        
        CCSprite *setting = [CCSprite spriteWithFile:@"setting.png"];
        [setting setPosition:ccp(240, 160)];
        [self addChild:setting z:2];
        
        CCSprite *pole = [CCSprite spriteWithFile:@"pole.png"];
        [pole setAnchorPoint:ccp(0.5f, 0.0f)];
        [pole setPosition:ccp(240, 0)];
        [self addChild:pole z:2];
        
 
        //총의 종류를 나타내는 이미지를 생성
        CCSprite *spGun = [CCSprite spriteWithFile:@"ui_handgun.png"];
        //이 이미지의 anchorPoint와 위치를 지정합니다.
        spGun.anchorPoint = ccp(0.5, 0.5);
        spGun.position = ccp(40,280);
        //spGun을 GameLayer의 자식으로 둡니다. z 값은 6으로 지정합니다.
        [self addChild:spGun z:6];
        
        //총알의 이미지 자체를 나타내는 스프라이트 ptBulletSprite를 "bullet_handgun.png"로 지정합니다.
        ptBulletSprite = [CCSprite spriteWithFile:@"bullet_handgun.png"];
        //총알의 개수를 막대형식의 바(bar)로 나타내는 ptBullet의 이미지를 위에서 정의한 ptBulletSprite로 지정합니다.
        ptBullet = [CCProgressTimer progressWithSprite:ptBulletSprite];
        
        //ptBullet의 형태를 수평막대 형으로 지정합니다.
        ptBullet.type = kCCProgressTimerTypeBar;
        //ptBullet의 anchorPoint와 위치를 지정합니다.
        ptBullet.anchorPoint = ccp(0, 0.5f);
        ptBullet.position = ccp(80, 285);
        //ptBullet의 총알 이미지가 줄어드는 형태를 지정해주는 옵션입니다. ccp(1,0)으로 지정하면 가로로 이미지가 줄어들고 ccp(0,1)로 지정하면 세로로 이미지가 줄어듭니다.
        ptBullet.barChangeRate = ccp(1,0);
        //ptBullet의 총알 이미지가 줄어드는 방향(왼쪽 또는 오른쪽)을 지정해주는 옵션입니다. ccp(0,1)이면 오른쪽부터 이미지가 줄어들고 ccp(1,0)이면 왼쪽부터 이미지가 줄어듭니다.
        ptBullet.midpoint = ccp(0,1);
        //ptBullet의 비율을 100으로 잡습니다.
        ptBullet.percentage=100;
        //ptBullet을 GameLayer의 자식으로 둡니다. z 값은 21로 지정합니다.
        [self addChild:ptBullet z:21];

        
        [self createCloudWithSize:FRONT_CLOUD_SIZE top:FRONT_CLOUD_TOP fileName:@"cloud_front.png" interval:15 z:2];
        [self createCloudWithSize:BACK_CLOUD_SIZE  top:BACK_CLOUD_TOP  fileName:@"cloud_back.png"  interval:30 z:1];
        
        [self createGun];
        
        // 배열에 NSValue 형태로 CGPoint 값을 넣습니다.
        // CGPoint, CGRect 등의 기본 자료형들은 NSArray, Dicionary 등에 바로 쓸 수 없습니다. 객체만 받아들이기 때문입니다.
        // 그래서 기본 자료형들을 NSValue로 형태를 변환시킨 후 넣어야 합니다.
        // 이런 과정을 레핑(Wrapping) 이라고 합니다.
        // NSValue는 CGPoint, CGRect 등을 객체화시키고,
        // NSNumber은 int, float 등을 객체화 시킵니다.
        sitPositions = [NSArray arrayWithObjects:
                        [NSValue valueWithCGPoint:ccp(70,  193)],
                        [NSValue valueWithCGPoint:ccp(107, 178)],
                        [NSValue valueWithCGPoint:ccp(144, 167)],
                        [NSValue valueWithCGPoint:ccp(181, 158)],
                        [NSValue valueWithCGPoint:ccp(218, 155)],
                        [NSValue valueWithCGPoint:ccp(255, 156)],
                        [NSValue valueWithCGPoint:ccp(292, 161)],
                        [NSValue valueWithCGPoint:ccp(329, 168)],
                        [NSValue valueWithCGPoint:ccp(366, 180)],
                        [NSValue valueWithCGPoint:ccp(403, 195)],
                        nil];
        // 내부의 retainCount 를 하나 늘린다.
        [sitPositions retain];
        
        //        [self createBird];
        //3초 간격으로 createBird 메소드를 호출한다.
        [self schedule:@selector(createBird) interval:3.0f];
    }
	return self;
}

#pragma mark -
#pragma mark TouchHandler

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // touch 라는 문구를 출력합니다.
    // 화면의 터치하는 곳의 좌표를 glLocation으로 정의하고 glLocation인 곳에서 연기를 나타내는 스프라이트인 gunSmoke를 나타나게합니다.
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	CGPoint glLocation = [[CCDirector sharedDirector] convertToGL:location];
	[gunSmoke setPosition:glLocation];
    
       //남은 총알의 개수가 0보다 크다면 안의 코드들을 수행한다.
    if (bulletCount>0) {
        //남은 총알의 개수를 하나 감소시킨다.
        bulletCount -=1;
        ptBullet.percentage = bulletCount *100 / MAX_BULLET_COUNT;
        
        //연기 애니메이션을 나타내는 smokeAnimate가 일어나지 않으면 gunSmoke가 smokeAnimate를 하지않게 합니다.
        if (![smokeAnimate isDone]) [gunSmoke stopAction:smokeAnimate];
        //gunSmoke가 smokeAnimate를 수행하게 합니다.
        [gunSmoke runAction:smokeAnimate];
        //사운드 효과를 재생한다.
        [[SimpleAudioEngine sharedEngine] playEffect:@"handgun_fire.wav"];
        
        // for in을 써서 birdArray 안의 객체를 하나하나 다 터치가 되었는지 검사하는 부분입니다.
        for (CCSprite *sprite in birdArray){
            // birdArray 중의 객체 sprite를 isHitWithTarget:: 메소드를 써서 터치를 판별합니다.
            if ([self isHitWithTarget:sprite touchPoint:glLocation])
                // 터치가 되었을 시 birdisDead: 메소드를 수행합니다.
                [self birdisDead:sprite];
        }
    }
    //총알이 0이면 빈 총 소리가 난다.(새를 없앨 수는 없다.)
    else {
        [[SimpleAudioEngine sharedEngine] playEffect:@"handgun_noammo.wav"];
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end
