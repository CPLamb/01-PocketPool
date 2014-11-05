//
//  ViewController.m
//  ButtonDrive
//
//  Created by Jon Carroll on 12/9/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import "ViewController.h"

#import "RobotKit/RobotKit.h"

#import "RobotUIKit/RobotUIKit.h"

@implementation ViewController
@synthesize speedValueLabel = _speedValueLabel;
@synthesize headingValueLabel = _headingValueLabel;
@synthesize timeValueLabel = _timeValueLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    /*Register for application lifecycle notifications so we known when to connect and disconnect from the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];

    /*Only start the blinking loop when the view loads*/
    robotOnline = NO;

    calibrateHandler = [[RUICalibrateGestureHandler alloc] initWithView:self.view];
    
// Sets initial values for the ball
    shotSpeed = 0.5;
    shotHeading = 180.0;
    shotTime = 1.5;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)appWillResignActive:(NSNotification*)notification {
    /*When the application is entering the background we need to close the connection to the robot*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
    [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:0.0 blue:0.0];
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
}

-(void)appDidBecomeActive:(NSNotification*)notification {
    /*When the application becomes active after entering the background we try to connect to the robot*/
    [self setupRobotConnection];
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:1.0 blue:0.0];
}

- (void)handleRobotOnline {
    /*The robot is now online, we can begin sending commands*/

    robotOnline = YES;
}

-(void)setupRobotConnection {
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl]) {
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];        
    }
}

#pragma mark -
#pragma mark Interface interaction


-(IBAction)zeroPressed:(id)sender {
    [RKRollCommand sendCommandWithHeading:0.0 velocity:shotSpeed];
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:1.0 blue:1.0];
}

-(IBAction)zeroReleased:(id)sender {
    [RKRollCommand sendStop];
    [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:1.0 blue:1.0];
}

-(IBAction)ninetyPressed:(id)sender {
    [RKRollCommand sendCommandWithHeading:90.0 velocity:shotSpeed];
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:1.0 blue:0.0];
}

-(IBAction)oneEightyPressed:(id)sender {
    [RKRollCommand sendCommandWithHeading:180.0 velocity:shotSpeed];
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];
}

-(IBAction)twoSeventyPressed:(id)sender {
    [RKRollCommand sendCommandWithHeading:270.0 velocity:shotSpeed];
    [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:0.0 blue:0.0];
}

-(IBAction)stopPressed:(id)sender {
    //The sendStop method sends a roll command with zero velocity and the last heading to make Sphero stop
    [RKRollCommand sendStop];
    [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:1.0 blue:1.0];
    
}
                                 
#pragma mark Custom Methods

-(IBAction)headingSliderChanged:(id)sender {
//    NSLog(@"Sets the shotTIME with the slider");
    
    UISlider *slider = (UISlider *)sender;
    shotHeading = slider.value;
    self.headingValueLabel.text = [NSString stringWithFormat:@"%f3.0",shotHeading];
}


- (IBAction)speedSliderChanged:(id)sender {
//    NSLog(@"Sets the ballSPEED with the slider");
    
    UISlider *slider = (UISlider *)sender;
    shotSpeed = slider.value;
    self.speedValueLabel.text = [NSString stringWithFormat:@"%f1.1",shotSpeed];
}

- (IBAction)timeSliderChanged:(id)sender {
//    NSLog(@"Sets the shotTIME with the slider");
    
    UISlider *slider = (UISlider *)sender;
    shotTime = slider.value;
    self.timeValueLabel.text = [NSString stringWithFormat:@"%f1",shotTime];
}

-(void)endShot:(NSTimer *)timer {
//    NSLog(@"stops the ball & changes color");
    
    [RKRollCommand sendStop];
    [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:1.0 blue:1.0];
}

-(IBAction)shootButtonPressed:(id)sender {
//    NSLog(@"shoots the ball at shotSpeed & shotHeading for shotTime, and changes color also");

    [RKRollCommand sendCommandWithHeading:shotHeading velocity:shotSpeed];
// Timer
    [NSTimer scheduledTimerWithTimeInterval:shotTime
                    target:self
                    selector:@selector(endShot:)
                    userInfo:nil
                    repeats:NO];
}

@end
