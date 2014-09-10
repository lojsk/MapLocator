//
//  DragableView.m
//  MapLocator
//
//  Created by lojsk on 29/07/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "DragableView.h"

@implementation DragableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    [UIView beginAnimations:@"Dragging A DraggableView" context:nil];
    
    if(location.y < 135)
        location.y = 135;
    if(location.y > screenSize.height-110)
        location.y = screenSize.height-110;
    
    self.frame = CGRectMake(self.frame.origin.x, location.y,
                            self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

@end
