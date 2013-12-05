//
//  MovingImageView.m
//  App6
//
//  Created by Ryan Hennessee on 12/3/13.
//  Copyright (c) 2013 Ryan Hennessee. All rights reserved.
//

#import "MovingImageView.h"
#import "ViewController.h"

@implementation MovingImageView

@synthesize audio, startPosition;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.startPosition = frame.origin;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.tag == 20)
    {
        [self startAnimating];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self];
    CGPoint previousLocation = [aTouch previousLocationInView:self];
    self.frame = CGRectOffset(self.frame, location.x - previousLocation.x, location.y - previousLocation.y);
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    
    if (location.y > 113 && location.y < 334)
    {
        //animate to player position
        [UIView animateWithDuration:2.0
                        animations:^
                        {
                            self.frame = CGRectMake(48,188,64,64);
                            if (self.tag == 10 || self.tag == 20)
                            {
                                 self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
                            }
                        }
                        completion:^ (BOOL finished)
                        {
                            if ([self.superview.nextResponder isKindOfClass:[ViewController class]])
                            {
                                [(ViewController*) self.superview.nextResponder playRound:self];
                            }
                        }];
    }
    else
    {
        [UIView animateWithDuration:1.0
                        animations:^
                        {
                            self.frame = CGRectMake(self.startPosition.x, self.startPosition.y, 64, 64);
                        }
                        completion:nil];
    }
    
    if (self.tag == 20)
    {
        [self stopAnimating];
    }
    
}

- (IBAction) tapped:(UIGestureRecognizer*)sender
{
    if (self.tag == 20)
    {
        [self stopAnimating];
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"LionRoar" ofType:@"mp3"];
        NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
        audio = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        [audio play];
    }
    
}
@end
