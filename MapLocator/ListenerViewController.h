//
//  ListenerViewController.h
//  SafeSound
//
//  Created by Demetri Miller on 10/25/10.
//  Copyright 2010 Demetri Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RIOInterface;

@protocol SecondDelegate <NSObject>
@optional
-(void)openChirpView:(NSString*)theChirpCode;
@required
@end

@interface ListenerViewController : UIViewController {
	IBOutlet UILabel *currentPitchLabel;
	IBOutlet UIButton *listenButton;
	
	BOOL isListening;
	RIOInterface *rioRef;
	
	NSMutableString *key;
	float currentFrequency;
	NSString *prevChar;
    
    BOOL play;
    NSString *lastChar;
    NSMutableString *start;
}

@property(nonatomic, retain) UILabel *currentPitchLabel;
@property(nonatomic, retain) UIButton *listenButton;
@property(nonatomic, retain) NSMutableString *key;
@property(nonatomic, retain) NSMutableString *start;
@property(nonatomic, retain) NSString *prevChar;
@property(nonatomic, assign) RIOInterface *rioRef;
@property(nonatomic, assign) float currentFrequency;
@property(assign) BOOL isListening;
@property (retain, nonatomic) IBOutlet UILabel *outLabel;
@property (nonatomic, retain) id<SecondDelegate> delegate;


#pragma mark Listener Controls
- (IBAction)toggleListening:(id)sender;
- (void)startListener;
- (void)stopListener;

- (void)frequencyChangedWithValue:(float)newFrequency;
- (void)updateFrequencyLabel;

@end
