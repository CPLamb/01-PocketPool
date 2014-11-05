//
//  ViewController.h
//  ButtonDrive
//
//  Created by Jon Carroll on 12/9/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RobotUIKit/RobotUIKit.h>

@interface ViewController : UIViewController {
    BOOL robotOnline;
    RUICalibrateGestureHandler *calibrateHandler;
    float shotSpeed;
    float shotTime;
    float shotHeading;
}
// Pocket Pool properties & methods
@property (nonatomic, retain)IBOutlet UILabel *speedValueLabel;
@property (nonatomic, retain)IBOutlet UILabel *timeValueLabel;
@property (nonatomic, retain)IBOutlet UILabel *headingValueLabel;

-(IBAction)speedSliderChanged:(id)sender;
-(IBAction)timeSliderChanged:(id)sender;
-(IBAction)headingSliderChanged:(id)sender;
-(IBAction)shootButtonPressed:(id)sender;

-(void)setupRobotConnection;
-(void)handleRobotOnline;

//Interface interactions
-(IBAction)zeroPressed:(id)sender;
-(IBAction)zeroReleased:(id)sender;

-(IBAction)ninetyPressed:(id)sender;
-(IBAction)oneEightyPressed:(id)sender;
-(IBAction)twoSeventyPressed:(id)sender;
-(IBAction)stopPressed:(id)sender;

@end

