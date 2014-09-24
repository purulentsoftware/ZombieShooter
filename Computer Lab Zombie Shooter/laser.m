//
//  laser.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/18/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "laser.h"

@implementation laser
-(id)init{
    self=[super initWithImageNamed:@"laser.png"];
    self.xScale=.25;
    self.yScale=1.0;
    return self;
}

@end
