//
//  GGJoystick.m
//  GGScrollShooter
//
//  Created by RUSLAN PROKOFYEV on 26.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GGJoystick.h"
#import "CCDirector.h"
#import "CCDirectorIOS.h"
#import "CCTouchDispatcher.h"
#import "CCScheduler.h"
@implementation GGJoystick
@synthesize isBlock=_isBlock,radius=_radius,speedMultiplier=_speedMultiplier,delegate=_delegate,isJoystickEnabled=_isJoystickEnabled;
-(id)initWithFile:(NSString *)filename controller:(CCSprite*)controllerS{
    if (self =[super initWithFile:filename]) {

        self.speedMultiplier = 5;
        self.radius =100;
        controller =[controllerS retain];
        [self addChild:controller];
         
    }
    return self;
}
-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
}
-(CGFloat)distanceBetweenTwoPoints:(CGPoint)point1 pointTwo:(CGPoint)point2{
    CGFloat fX = point2.x -point1.x;
    CGFloat fY = point2.y -point1.y;
    CGFloat temp = sqrt(fX*fX + fY*fY);
return temp;
}
-(CGFloat)slopeBetweenTwoPoints:(CGPoint)point1 pointTwo:(CGPoint)point2{
    CGFloat fX = point2.x -point1.x;
    CGFloat fY = point2.y -point1.y;
    CGFloat temp = fY/fX;
    return temp;
}
-(void)update1:(ccTime)time{
    
    if ([self.delegate respondsToSelector:@selector(joystickControlSpeedMultiplier)]) {
        [self setSpeedMultiplier:[self.delegate joystickControlSpeedMultiplier]];
    }
    float xSpeedRatio = ABS(actualPoint.x /_radius*_speedMultiplier)*fx;
    float ySpeedRatio = ABS(actualPoint.y/_radius*_speedMultiplier)*fy;
    
    if ([self.delegate respondsToSelector:@selector(joystickControlDidUpdate:toYSpeedRatio:)]) {
        [self.delegate joystickControlDidUpdate:xSpeedRatio toYSpeedRatio:ySpeedRatio];
    }
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_isJoystickEnabled) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location =[[CCDirector sharedDirector]  convertToGL:location];
    CGFloat distance =[self distanceBetweenTwoPoints:self.position pointTwo:location];
    if (distance<=self.radius) {
        _isJoystickEnabled = true;
        actualPoint = CGPointMake(location.x-self.position.x, location.y -self.position.y);
        
        CGPoint point = CGPointMake(self.boundingBox.size.width/2 +actualPoint.x, self.boundingBox.size.height/2+actualPoint.y);
        if ([self.delegate respondsToSelector:@selector(joystickControlBegan:)]) {
            [self.delegate joystickControlBegan:point];
        }
        [controller setPosition:point];
        [[[CCDirector sharedDirector]scheduler]scheduleSelector:@selector(update1:) forTarget:self interval:0 paused:false];
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location =[[CCDirector sharedDirector]  convertToGL:location];
    CGFloat distance =[self distanceBetweenTwoPoints:self.position pointTwo:location];
  
    actualPoint= CGPointMake(location.x-self.position.x, location.y -self.position.y);
    if (self.isJoystickEnabled) {
           CGPoint point;
        if (actualPoint.x <=0) {
            fx =-1;
        }else{
            fx =1;
        }
        if (actualPoint.y <=0) {
            fy = -1;
        }else{
            fy = 1;
        }
        if (distance<=self.radius) {
            point = CGPointMake(self.boundingBox.size.width/2 +actualPoint.x, self.boundingBox.size.height/2+actualPoint.y);
            [controller setPosition:point];
//              _distanceController = distance;
        }else{
           
            CGFloat slope = [self slopeBetweenTwoPoints:CGPointMake(0, 0) pointTwo:actualPoint];
         
            if (slope == (-INFINITY || INFINITY)) {
                point = CGPointMake(0, _radius);
            }else{
                CGFloat newX = cosf(atanf(slope))*_radius;
                CGFloat newY = sinf(atanf(slope))*_radius;
                point =CGPointMake(ABS(newX), ABS(newY));
            }
//            int fx =1;
//            int fy =1;
    
            point =CGPointMake(point.x*fx, point.y*fy);
            
            point = CGPointMake(self.boundingBox.size.width/2 +point.x,self.boundingBox.size.height/2+point.y);
                       [controller setPosition:point];
        }
//        _distanceController = point;

        if ([self.delegate respondsToSelector:@selector(joystickControlMoved:)]) {
            [self.delegate joystickControlMoved:point];
        }
    }
    
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self ccTouchesCancelled:touches withEvent:event];
}
-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.isJoystickEnabled) {
        _isJoystickEnabled = false;
        if ([self.delegate respondsToSelector:@selector(joystickControlEnded:)]) {
            [self.delegate joystickControlEnded:controller.position];
        }
      [controller setPosition:CGPointMake(self.boundingBox.size.width/2, self.boundingBox.size.height/2)];
        [[[CCDirector sharedDirector]scheduler]unscheduleSelector:@selector(update1:) forTarget:self];
    }
}
-(void)onEnter{
    [super onEnter];
    CCTouchDispatcher *touchDis= [[CCDirectorIOS sharedDirector] touchDispatcher];
    [touchDis addStandardDelegate:self priority:0];
}
-(void)onExit{
    [super onExit];
    CCTouchDispatcher *touchDis= [[CCDirectorIOS sharedDirector] touchDispatcher];
    [touchDis removeDelegate:self];
    
}
-(void)dealloc{
    [controller release];
    [self.delegate release];
    [super dealloc];
}
@end
