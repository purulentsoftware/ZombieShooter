//
//  Desktop.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/19/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "Desktop.h"
static const uint32_t laserCat     =  0x1 << 0;
static const uint32_t zombieCat        =  0x1 << 1;
static const uint32_t playerCat        =  0x1 << 2;
static const uint32_t deskCat        =  0x1 << 2;
static const uint32_t compCat        =  0x1 << 3;

@implementation Desktop
-(id)init{
    self=[super initWithImageNamed:@"computer.png"];
    [self setScale:0.5];
    self.zPosition=M_PI;
    return self;
}

@end
