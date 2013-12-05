//
//  ViewController.h
//  App6
//
//  Created by Ryan Hennessee on 11/29/13.
//  Copyright (c) 2013 Ryan Hennessee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovingImageView.h"

@interface ViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel* iScoreVal, *iScoreHeader;
@property (strong, nonatomic) IBOutlet UILabel* pScoreVal, *pScoreHeader;

@property (strong, nonatomic) MovingImageView* cobraImage;
@property (strong, nonatomic) MovingImageView* lionImage;
@property (strong, nonatomic) MovingImageView* rabbitImage;


- (void) playRound: (MovingImageView*) playerImage;


@end
