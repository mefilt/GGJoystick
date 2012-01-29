//
//  GGJoystick.h
//  GGScrollShooter
//
//  Created by RUSLAN PROKOFYEV on 26.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "CCSprite.h"

@protocol GGJoystickDelegate <NSObject>
-(void)joystickControlBegan:(CGPoint)Point;
-(void)joystickControlMoved:(CGPoint)Point;
-(void)joystickControlEnded:(CGPoint)Point;
-(CGFloat)joystickControlSpeedMultiplier;
-(void)joystickControlDidUpdate:(CGFloat)xSpeedRatio toYSpeedRatio:(CGFloat)ySpeedRatio;


@end
@interface GGJoystick : CCSprite <CCStandardTouchDelegate,GGJoystickDelegate>{
    CGFloat _radius;
    CGFloat _speedMultiplier;
    BOOL _isJoystickEnabled;
    BOOL _isBlock;
    CCSprite *controller;
    CGPoint actualPoint;
    id<GGJoystickDelegate> _delegate;
    int fx;
    int fy;
}
-(id)initWithFile:(NSString *)filename controller:(CCSprite*)controllerS;
@property (nonatomic,readwrite,retain) id<GGJoystickDelegate> delegate;
@property (nonatomic,readwrite) BOOL isBlock;
@property (nonatomic,readwrite) CGFloat radius;
@property (nonatomic,readwrite) CGFloat speedMultiplier;
@property (nonatomic,readonly) BOOL isJoystickEnabled;
@end
