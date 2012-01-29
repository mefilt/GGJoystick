//
//  HelloWorldLayer.m
//  GGJoystick
//
//  Created by RUSLAN PROKOFYEV on 29.01.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//
#import "GGJoystick.h"

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{

	if( (self=[super init])) {
        blob=[CCSprite spriteWithFile:@"blob.png"];
        [blob setPosition:ccp(400, 400)];
        [self addChild:blob];
		CCSprite *sprite = [CCSprite spriteWithFile:@"controller.png"];
       joy = [[GGJoystick alloc]initWithFile:@"joy.png" controller:sprite] ;
        [joy setPosition:ccp(100, 100)];
        [joy setRadius:100];
        [joy setDelegate:self];
        [self addChild:joy];

	}
	return self;
}
-(void)joystickControlDidUpdate:(CGFloat)xSpeedRatio toYSpeedRatio:(CGFloat)ySpeedRatio{
    [blob setPosition:ccp(blob.position.x+xSpeedRatio, blob.position.y+ySpeedRatio)];
}

- (void) dealloc
{
    [joy release];
	[super dealloc];
}


@end
