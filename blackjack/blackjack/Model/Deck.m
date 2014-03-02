//
//  Deck.m
//  blackjack
//
//  Created by Kevin on 2/23/14.
//  Copyright (c) 2014 Kevin. All rights reserved.
//

#import "Deck.h"
#import "Card.h"

@implementation Deck

-(void) makeDeck{
    _cards = [[NSMutableArray alloc] init];
    NSArray *ranks = @[@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    NSArray *suits = @[@"♥",@"♦",@"♠",@"♣"];
    
    for (int i = 0; i < [ranks count];i++) {
        for (int j = 0; j < [suits count];j++){
            Card *drawnCard = [[Card alloc] init];
            [drawnCard setSuit:suits[j]];
            [drawnCard setRank:ranks[i]];
            [_cards addObject:drawnCard];
        }
    }
}

-(void) displayDeck{
    for(int i = 0; i < [_cards count]; i++) {
        NSLog(@"%i %@ %@", i, [_cards[i] rank], [_cards[i] suit]);
    }
}

- (void)shuffle
{
    for (int i = 0; i < [_cards count]; ++i) {
        int numberOfElements = [_cards count] - i;
        int n = arc4random_uniform(numberOfElements) + i;
        [_cards exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

-(Card*) drawCard
{
    Card* lastCard = [_cards lastObject];
    [_cards removeLastObject];
    [lastCard displayCard];
    return lastCard;
}

@end
