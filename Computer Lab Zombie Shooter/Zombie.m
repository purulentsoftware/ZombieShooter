//
//  Zombie.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/18/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie
-(id)init{
    NSString *imageName=@"zombie_red_shirt.png";
    self=[super initWithImageNamed:imageName];
    return self;
}
@end
