//
//  ViewController.m
//  blackjack
//
//  Created by Kevin on 2/23/14.
//  Copyright (c) 2014 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"
#import "Deck.h"
#import "Player.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dealerLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *playerLabels;
@property (strong, nonatomic) Deck * theDeck;
@property (strong, nonatomic) Player * thePlayer;
@property (strong, nonatomic) Player * theDealer;
@property (weak, nonatomic) IBOutlet UILabel *playerValueOfCardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealerValueOfCardsLabel;
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *standButton;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UIButton *doubleButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *betLabel;
@property (weak, nonatomic) IBOutlet UITextField *betArea;

@property int numberOfGames;
@property int score;
@property int currentBet;

@end

@implementation ViewController


- (IBAction)hit:(id)sender {
    [self hitCard];
    [self checkIfPlayerBustWhileHitting];
}

- (IBAction)doubleBet:(id)sender {
    [self hitCard];
    [self doubleTheBet];
    if (![self checkIfPlayerBustWhileHitting])
    {
        [self stand:nil];
    }
}

- (void) hitCard {
    [_thePlayer takeCard:[_theDeck drawCard]];
    [self updateCards:_thePlayer withUICollection:_playerLabels andValueLabel:_playerValueOfCardsLabel];
    [_doubleButton setEnabled:false];
}

- (IBAction)stand:(id)sender {
    [self dealerAI];
    [_doubleButton setEnabled:false];
}

- (IBAction)start:(id)sender {
    _thePlayer = [[Player alloc] init];
    _theDealer = [[Player alloc] init];
    if (_score <= 0)
    {
        [_playerValueOfCardsLabel setText:@"NO $$"];
    }
    else
    {
        if (_numberOfGames > 4 || _numberOfGames == 0)
        {
            [_theDeck makeDeck];
            [_theDeck shuffle];
            [_theDeck displayDeck];
            _numberOfGames = 0;
        }
        [_thePlayer takeCard:[_theDeck drawCard]];
        [_thePlayer takeCard:[_theDeck drawCard]];
        
        [_theDealer takeCard:[_theDeck drawCard]];
        
        [_dealButton setEnabled:false];
        [_hitButton setEnabled:true];
        [_standButton setEnabled:true];
        [self makeBet];
        [self clearAll];
        [self updateCards:_thePlayer withUICollection:_playerLabels andValueLabel:_playerValueOfCardsLabel];
        [self updateCards:_theDealer withUICollection:_dealerLabels andValueLabel:_dealerValueOfCardsLabel];
        _numberOfGames++;
    }
}

-(void)updateCards:(Player *)player withUICollection:(NSArray *)withUICards andValueLabel:(UILabel *)valueLabel{
    for(UILabel *aCard in withUICards)
    {
        if ([aCard tag] < [player numberOfCards])
        {
            Card *theCard = player.cards[[aCard tag]];
            [aCard setText:[theCard displayCard]];
            UIColor * lightBlueColor = [UIColor colorWithRed:197/255.0f green:232/255.0f blue:255/255.0f alpha:1.0f];
            [aCard setBackgroundColor:lightBlueColor];
        }
    }
    NSString *cardLabel = [NSString stringWithFormat:@"%i",[player valueOfCardsHeld]];
    [valueLabel setText:cardLabel];
}

-(BOOL) checkIfPlayerBustWhileHitting {
    if ([_thePlayer valueOfCardsHeld] > 21)
    {
        [_playerValueOfCardsLabel setText:@"BUST"];
        [_theDealer takeCard:[_theDeck drawCard]];
        [self updateCards:_theDealer withUICollection:_dealerLabels andValueLabel:_dealerValueOfCardsLabel];
        [self gameFinishUI];
        [self loseScore];
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)checkWin {
    if ([_thePlayer valueOfCardsHeld] > [_theDealer valueOfCardsHeld])
    {
        [_playerValueOfCardsLabel setText:@"WIN"];
        [self winScore];
    }
    else if ([_thePlayer valueOfCardsHeld] < [_theDealer valueOfCardsHeld] && [_theDealer valueOfCardsHeld] < 22)
    {
        [_playerValueOfCardsLabel setText:@"LOSE"];
        [self loseScore];
    }
    else if ([_thePlayer valueOfCardsHeld] == [_theDealer valueOfCardsHeld])
    {
        [_playerValueOfCardsLabel setText:@"PUSH"];
        [self pushScore];
    }
    else if([_theDealer valueOfCardsHeld] > 21)
    {
        [_playerValueOfCardsLabel setText:@"WIN"];
        [self winScore];
    }
    [self gameFinishUI];
}

- (void)dealerAI {
    while ([_theDealer valueOfCardsHeld] < 17)
    {
        [_theDealer takeCard:[_theDeck drawCard]];
        [self updateCards:_theDealer withUICollection:_dealerLabels andValueLabel:_dealerValueOfCardsLabel];
    }
    [self checkWin];
}

// UI Cleanup Functions

-(void)clearAll {
    for(UILabel *aCard in _playerLabels)
    {
        [aCard setBackgroundColor:nil];
        [aCard setText:@""];
    }
    for(UILabel *aCard in _dealerLabels)
    {
        [aCard setBackgroundColor:nil];
        [aCard setText:@""];
        if ([aCard tag] == 1)
        {
            UIColor * lightBlueColor = [UIColor colorWithRed:197/255.0f green:232/255.0f blue:255/255.0f alpha:1.0f];
            [aCard setBackgroundColor:lightBlueColor];
            [aCard setText:@""];
        }
    }
}

-(void)gameFinishUI {
    [_dealButton setEnabled:true];
    [_hitButton setEnabled:false];
    [_standButton setEnabled:false];
    [_doubleButton setEnabled:false];
}

// Money Related Functions

-(void) makeBet {
    _currentBet = [[_betArea text] intValue];
    if (_currentBet > _score)
    {
        _currentBet = _score;
    }
    else if (_currentBet == 0)
    {
        _currentBet = 1;
    }
    _score = _score - _currentBet;
    [self allowDoubleAction];
    [self updateMoneyLabels];
}

-(void) allowDoubleAction {
    if (_score >= _currentBet)
    {
        [_doubleButton setEnabled:true];
    }
    else
    {
        [_doubleButton setEnabled:false];
    }
}

-(void) doubleTheBet {
    _score = _score - _currentBet;
    _currentBet = (_currentBet * 2);
    [self updateMoneyLabels];
}

-(void) winScore {
    _score = _score + (_currentBet * 2);
    [self updateMoneyLabels];
}

-(void) loseScore {
    [self updateMoneyLabels];
}

-(void) pushScore {
    _score = _score + _currentBet;
    [self updateMoneyLabels];
}

-(void) updateMoneyLabels {
    [_betLabel setText:[NSString stringWithFormat:@"$ %i", _currentBet]];
    [_moneyLabel setText:[NSString stringWithFormat:@"$ %i", _score]];
}

// Automatic Code below

- (void)viewDidLoad
{
    _numberOfGames = 0;
    _score = 100;
    _theDeck = [[Deck alloc] init];
    
    [_moneyLabel setText:[NSString stringWithFormat:@"$%i", _score]];
    [_betArea setDelegate:self];
    
    for(UILabel *aCard in _playerLabels)
    {
        [aCard setBackgroundColor:nil];
        [aCard setText:@""];
    }
    for(UILabel *aCard in _dealerLabels)
    {
        [aCard setBackgroundColor:nil];
        [aCard setText:@""];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber* candidateNumber;
    
    NSString* candidateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    range = NSMakeRange(0, [candidateString length]);
    
    [numberFormatter getObjectValue:&candidateNumber forString:candidateString range:&range error:nil];
    
    if (([candidateString length] > 0) && (candidateNumber == nil || range.length < [candidateString length])) {
        
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([_betArea isFirstResponder] && [touch view] != _betArea) {
        [_betArea resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
