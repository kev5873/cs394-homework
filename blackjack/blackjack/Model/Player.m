//
//  Player.m
//  blackjack
//
//  Created by Kevin on 2/27/14.
//  Copyright (c) 2014 Kevin. All rights reserved.
//

#import "Player.h"
#import "Card.h"

@implementation Player

-(id) init {
    self = [super init];
    if(self)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)takeCard:(Card*) card {
    [_cards addObject:card];
}

-(int)numberOfCards {
    return [_cards count];
}

// NSArray *ranks = @[@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
// NSArray *suits = @[@"♥",@"♦",@"♠",@"♣"];

-(int)valueOfCardsHeld {
    int value = 0;
    for (int i = 0; i < [_cards count]; i++)
    {

        if ([[_cards[i] rank] isEqualToString:@"J"] || [[_cards[i] rank] isEqualToString:@"Q"] || [[_cards[i] rank] isEqualToString:@"K"])
        {
            value += 10;
        }
        else if ([[_cards[i] rank] isEqualToString:@"A"])
        {
            value += 11;
        }
        else
        {
            value += [[_cards[i] rank] intValue];
        }
    }
    if(value > 21) {
        value = 0;
        for (int i = 0; i < [_cards count]; i++)
        {
            
            if ([[_cards[i] rank] isEqualToString:@"J"] || [[_cards[i] rank] isEqualToString:@"Q"] || [[_cards[i] rank] isEqualToString:@"K"])
            {
                value += 10;
            }
            else if ([[_cards[i] rank] isEqualToString:@"A"])
            {
                value += 1;
            }
            else
            {
                value += [[_cards[i] rank] intValue];
            }
        }
    }
    return value;
}

@end
