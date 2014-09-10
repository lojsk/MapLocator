//
//  ListenerViewController.m
//  SafeSound
//
//  Created by Demetri Miller on 10/25/10.
//  Copyright 2010 Demetri Miller. All rights reserved.
//

#import "ListenerViewController.h"
#import "RIOInterface.h"
#import "KeyHelper.h"

@implementation ListenerViewController

@synthesize currentPitchLabel;
@synthesize listenButton;
@synthesize key;
@synthesize prevChar;
@synthesize isListening;
@synthesize	rioRef;
@synthesize currentFrequency;
@synthesize outLabel;
@synthesize start;
@synthesize delegate;

#pragma mark -
#pragma mark Listener Controls
- (IBAction)toggleListening:(id)sender {
	if (isListening) {
		[self stopListener];
		[listenButton setTitle:@"Begin Listening" forState:UIControlStateNormal];
	} else {
		[self startListener];
		[listenButton setTitle:@"Stop Listening" forState:UIControlStateNormal];
	}
	
	isListening = !isListening;
}

- (void)startListener {
	[rioRef startListening:self];
}

- (void)stopListener {
	[rioRef stopListening];
}



#pragma mark -
#pragma mark Lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    play = NO;
    lastChar = @"";
    start = @"";
	rioRef = [RIOInterface sharedInstance];
    
    [self startListener];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	currentPitchLabel = nil;
    listenButton = nil;
    [self setOutLabel:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [outLabel release];
	[super dealloc];
}

#pragma mark -
#pragma mark Key Management
// This method gets called by the rendering function. Update the UI with
// the character type and store it in our string.
- (void)frequencyChangedWithValue:(float)newFrequency{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	self.currentFrequency = newFrequency;
	[self performSelectorInBackground:@selector(updateFrequencyLabel) withObject:nil];
	
	
	/*
	 * If you want to display letter values for pitches, uncomment this code and
	 * add your frequency to pitch mappings in KeyHelper.m
	 */
	
	
	KeyHelper *helper = [KeyHelper sharedInstance];
    NSString *closestChar = @"";
    if(newFrequency > 1600.00 && newFrequency < 11000.00) {
        closestChar = [helper closestCharForFrequency:newFrequency];
        if(![lastChar isEqualToString:closestChar]) {
            NSString *appendedString = [start stringByAppendingString:closestChar];
            self.start = [NSMutableString stringWithString:appendedString];
        }
    }
    
   // NSLog(@"%@", start);
    if (play && [start rangeOfString:@"aka"].location != NSNotFound) {
        play = NO;
        start = @"";
    }
    
    if (!play && [start rangeOfString:@"dqd"].location != NSNotFound) {
        play = YES;
        [outLabel setText:@""];
        start = @"";
    }
    
    
    
    if([start length] > 5)
        start = @"";
    
    
    /*
     if (newFrequency > 8600.00 && newFrequency < 9000.00) {
     play = NO;
     }
     */
    if(play) {
        if(![lastChar isEqualToString:closestChar] && ![closestChar isEqualToString:@"Y"] && ![closestChar isEqualToString:@"X"] && [closestChar intValue]){
            [outLabel setText:[NSString stringWithFormat:@"%@%@",outLabel.text, closestChar]];
            NSLog(@"%@", outLabel.text);
        }
        // NSLog(@"%@ - %f",closestChar, newFrequency);
    }
    
    lastChar = closestChar;
    
	// If the new sample has the same frequency as the last one, we should ignore
	// it. This is a pretty inefficient way of doing comparisons, but it works.
	if (![prevChar isEqualToString:closestChar]) {
		self.prevChar = closestChar;
		if ([closestChar isEqualToString:@"0"]) {
            //	[self toggleListening:nil];
		}
		//[self performSelectorInBackground:@selector(updateFrequencyLabel) withObject:nil];
		NSString *appendedString = [key stringByAppendingString:closestChar];
		self.key = [NSMutableString stringWithString:appendedString];
	}
	
	[pool drain];
	pool = nil;
	
}
- (IBAction)backButton:(id)sender {
    [self stopListener];
    
    if([delegate respondsToSelector:@selector(openChirpView:)]) {
        [delegate openChirpView:outLabel.text];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateFrequencyLabel {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	self.currentPitchLabel.text = [NSString stringWithFormat:@"%@", outLabel.text];
	[self.currentPitchLabel setNeedsDisplay];
	[pool drain];
    if(outLabel.text.length >= 10) {
        [self backButton:nil];
    }
	pool = nil;
}


@end
