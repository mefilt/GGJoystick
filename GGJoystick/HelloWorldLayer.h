//
//  HelloWorldLayer.h
//  GGJoystick
//
//  Created by RUSLAN PROKOFYEV on 29.01.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//




// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GGJoystick.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GGJoystickDelegate>{
    GGJoystick *joy;
    CCSprite *blob;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
