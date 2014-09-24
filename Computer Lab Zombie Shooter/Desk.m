//
//  Desk.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/19/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "Desk.h"
#import "Desktop.h"
@implementation Desk
-(id)init{
    self=[super initWithImageNamed:@"desk.png"];
    computers=[[NSMutableArray alloc] init];
    [self setScale:0.75];
    Desktop *desk=[[Desktop alloc] init];
    desk.position=CGPointMake(-150, 0);
    [self addChild:desk];
    lastHit=0;
    Desktop *comp1=[[Desktop alloc] init];
    comp1.position=CGPointMake(-100, 0);
    [self addChild:comp1];
    lastHit=0;
    [computers addObject:desk];
    [computers addObject:comp1];
    return self;
}
-(void)deskHit{
    if([[NSDate date] timeIntervalSince1970]-lastHit>5){
        lastHit=[[NSDate date] timeIntervalSince1970];
        if([computers count]>0){
            Desktop *desk=(Desktop *)[computers objectAtIndex:[computers count]-1];
            [desk runAction:[SKAction removeFromParent]];
            [computers removeObject:desk];
        }
    }
}

@end
