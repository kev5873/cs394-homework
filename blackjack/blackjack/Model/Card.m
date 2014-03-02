//
//  Card.m
//  blackjack
//
//  Created by Kevin on 2/23/14.
//  Copyright (c) 2014 Kevin. All rights reserved.
//

#import "Card.h"

@implementation Card

-(NSString*) displayCard {
    return [[self rank] stringByAppendingString:[self suit]];
}

@end
