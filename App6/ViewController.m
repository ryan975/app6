//
//  ViewController.m
//  App6
//
//  Created by Ryan Hennessee on 11/29/13.
//  Copyright (c) 2013 Ryan Hennessee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize cobraImage, lionImage, rabbitImage, iScoreVal, iScoreHeader, pScoreVal, pScoreHeader;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    [titleImage setFrame: CGRectMake(140,35,40,10)];
    [self.view addSubview: titleImage];
    
    
    [UIView animateWithDuration: 2.0
                     animations:^ { [titleImage setFrame: CGRectMake(0,0,320,80)];}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration: 1.0
                                          animations:^{ [titleImage setAlpha:0];}
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:2.0
                                                               animations:^{
                                                                   [iScoreHeader setAlpha:1.0];
                                                                   [pScoreHeader setAlpha:1.0];
                                                                   [iScoreVal setAlpha: 1.0];
                                                                   [pScoreVal setAlpha: 1.0];
                                                               }
                                                               completion:nil];
                                          }
                          ];
                     }
     ];
        
    cobraImage = [[MovingImageView alloc] initWithFrame:CGRectMake(48,384, 64, 64)];
    lionImage = [[MovingImageView alloc] initWithFrame:CGRectMake(128,384, 64, 64)];
    rabbitImage = [[MovingImageView alloc] initWithFrame:CGRectMake(208,384, 64, 64)];
    
    [cobraImage setTag: 10];
    [lionImage setTag: 20];
    [rabbitImage setTag: 30];
  
    [cobraImage setImage: [UIImage imageNamed:@"cobra.png"]];
    [lionImage setImage: [UIImage imageNamed:@"lion2.png"]];
    lionImage.animationImages = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"lion0.png"],
                          [UIImage imageNamed:@"lion1.png"],
                          [UIImage imageNamed:@"lion2.png"],
                          [UIImage imageNamed:@"lion3.png"], nil];
    
    lionImage.animationDuration = 0.15 * [lionImage.animationImages count];
    
    [rabbitImage setImage: [UIImage imageNamed:@"rabbit.png"]];
    
    [self.view addSubview:cobraImage];
    [self.view addSubview:lionImage];
    [self.view addSubview:rabbitImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) playRound: (MovingImageView*) playerImage
{
    cobraImage.userInteractionEnabled = FALSE;
    rabbitImage.userInteractionEnabled = FALSE;
    lionImage.userInteractionEnabled = FALSE;
    
    MovingImageView *iOSimage;
    NSMutableArray *gameImages = [[NSMutableArray alloc] initWithObjects:cobraImage, lionImage, rabbitImage, nil];
        
    NSInteger index = arc4random() % 3;
    
    if (playerImage == [gameImages objectAtIndex: index])
    {
        MovingImageView *temp = [gameImages objectAtIndex: index];
        //create duplicate of image
        iOSimage = [[MovingImageView alloc] initWithFrame:CGRectMake(208,188,64,64)];
        [iOSimage setImage: temp.image];
        [iOSimage setTag: temp.tag];
        [iOSimage setAlpha: 0];
        [self.view addSubview:iOSimage];
        [UIView animateWithDuration:2
                         animations:^{[iOSimage setAlpha:1];}
                         completion:^(BOOL finished) {[self move_iOSimage:playerImage :iOSimage];}
         ];
    }
    else
    {
        iOSimage = [gameImages objectAtIndex:index];
        [self move_iOSimage:playerImage :iOSimage];
    }
}
- (void) move_iOSimage:(MovingImageView*) playerImage :(MovingImageView*) iOSimage
{

    [UIView animateWithDuration: 3
                     animations:^{
                         iOSimage.frame = CGRectMake(208,188,64,64);
                         if (iOSimage.tag == 30)
                         {
                             iOSimage.transform = CGAffineTransformMakeScale(-1.0, 1.0);
                         }
                     }
                    completion:^(BOOL finished) {[self whoWon:playerImage :iOSimage];}
     ];

}

- (void) whoWon:(MovingImageView*) playerImage :(MovingImageView*) iOSimage
{
    // 10 beats 20, 20 beats 30,  30 beats 10
    
    if ((playerImage.tag == 10 && iOSimage.tag == 20) ||
        (playerImage.tag == 20 && iOSimage.tag == 30) ||
        (playerImage.tag == 30 && iOSimage.tag == 10) )
        
    {
        //player wins
        [UIView animateWithDuration:3
                         animations:^{[playerImage setFrame:iOSimage.frame];}
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:2
                                              animations:^{ [iOSimage setAlpha:0]; }
                                              completion:^(BOOL finished){
                                                  [self resetGame:playerImage :iOSimage];
                                                  [self declareWinner:playerImage.tag loser:iOSimage.tag award:pScoreVal];
                                              }
                              ];
                         }
         ];
        //int iScore = [pScoreVal.text integerValue];
        
    }
    else if (playerImage.tag == iOSimage.tag)
    {
        [UIView animateWithDuration:2
                         animations:^{ [iOSimage setAlpha:0];}
                         completion:^(BOOL finished) {[iOSimage removeFromSuperview];}
         ];

        [self declareWinner:playerImage.tag loser:iOSimage.tag award:NULL];
        [self resetGame:playerImage :iOSimage];
        
    }
    else
    {
        // iOS wins
        [UIView animateWithDuration:3
                         animations:^{[iOSimage setFrame:playerImage.frame];}
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:2
                                              animations:^{ [playerImage setAlpha:0]; }
                                              completion:^(BOOL finished){
                                                  [self resetGame: playerImage :iOSimage];
                                                  [self declareWinner:iOSimage.tag loser:playerImage.tag award:iScoreVal];
                                              }
                              ];
                         }
         ];
    };
    
}

- (void) resetGame:(MovingImageView*) playerImage :(MovingImageView*) iOSimage
{

    // reset image positions
    [UIView animateWithDuration: 3
                     animations:^{
                         [iOSimage setFrame: CGRectMake(iOSimage.startPosition.x, iOSimage.startPosition.y, 64,64)];
                         [playerImage setFrame:CGRectMake(playerImage.startPosition.x, playerImage.startPosition.y, 64, 64)];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:3
                                          animations: ^{
                                              [iOSimage setAlpha:1.0];
                                              [iOSimage setTransform: CGAffineTransformMakeScale(1.0, 1.0)];
                                              [playerImage setAlpha:1.0];
                                              [playerImage setTransform: CGAffineTransformMakeScale(1.0, 1.0)];
                                          }
                                          completion: nil
                          ];
                    }
     ];
    iOSimage = NULL;
    playerImage = NULL;
    
}

- (void) enableInteraction
{
    cobraImage.userInteractionEnabled = TRUE;
    lionImage.userInteractionEnabled = TRUE;
    rabbitImage.userInteractionEnabled = TRUE;
}

- (void) declareWinner:(int)winnerTag loser:(int)loserTag award:(UILabel*)points
{
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 81, 320, 285)];
    [message setAlpha:0];
    [message setTextAlignment: NSTextAlignmentCenter];
    [message setFont: [UIFont boldSystemFontOfSize:18]];
   
    
    [self.view addSubview:message];
    
    if (winnerTag == loserTag)
    {
        [message setText: @"TIE!"];
        [message setBackgroundColor:[UIColor lightGrayColor]];
    }
    else
    {
        NSString *winner;
        NSString *loser;
        NSString *suffix;
        
        if (points == pScoreVal)
        {
            suffix = @"win!";
            [message setBackgroundColor: [UIColor greenColor]];
        }
        else
        {
            suffix = @"lose.";
             [message setBackgroundColor: [UIColor redColor]];
        }
        
        switch (winnerTag)
        {
            case 10:
                winner = @"Cobra";
                break;
            case 20:
                winner = @"Lion";
                break;
            case 30:
                winner = @"Rabbit";
                break;
        }
    
        switch (loserTag)
        {
            case 10:
                loser = @"Cobra";
                break;
            case 20:
                loser = @"Lion";
                break;
            case 30:
                loser = @"Rabbit";
                break;
        }
        
        [message setText: [NSString stringWithFormat:@"%@ defeats %@! You %@", winner, loser, suffix]];
    }
    
    
    [UIView animateWithDuration:3
                     animations:^{[message setAlpha:1];}
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:3
                                          animations:^{[message setAlpha:0];}
                                        completion:^(BOOL finished) {
                                              [message removeFromSuperview];
                                              [self enableInteraction];
                          }
                          ];
                         
                     }
     ];
    
    if (points)
    {
        int pts = [points.text integerValue] + 1;
        [points setText: [NSString stringWithFormat:@"%d", pts]];
    }
    
    
    
}

@end
 