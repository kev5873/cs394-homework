//
//  Player.h
//  blackjack
//
//  Created by Kevin on 2/27/14.
//  Copyright (c) 2014 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (strong,nonatomic) NSMutableArray *cards;

-(void)takeCard:card;
-(int)numberOfCards;
-(int)valueOfCardsHeld;

@end
