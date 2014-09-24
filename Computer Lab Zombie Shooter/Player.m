//
//  Player.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/18/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id)init{
    self=[super initWithImageNamed:@"player_sprite.png"];
    [self setColorBlendFactor:0.0];
    [self setColor:[UIColor redColor]];
    return self;
}

@end
