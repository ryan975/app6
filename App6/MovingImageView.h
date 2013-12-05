//
//  MovingImageView.h
//  App6
//
//  Created by Ryan Hennessee on 12/3/13.
//  Copyright (c) 2013 Ryan Hennessee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MovingImageView : UIImageView

@property CGPoint startPosition;
@property (strong, nonatomic) AVAudioPlayer *audio;

@end
