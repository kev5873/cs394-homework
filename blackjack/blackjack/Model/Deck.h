//
//  Deck.h
//  blackjack
//
//  Created by Kevin on 2/23/14.
//  Copyright (c) 2014 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

@property (strong,nonatomic) NSMutableArray *cards;

-(void) makeDeck;
-(void) displayDeck;
-(void) shuffle;
-(Card *) drawCard;

@end
