//
//  LhpLinkLabel.h
//  LHPLinkLabel
//
//  Created by lhp on 2018/5/7.
//  Copyright © 2018年 lhp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LhpLinkLabel;

/// The delegate of a PPLabel object
@protocol LhpLinkLabelDelegate <NSObject>

/**
 Tells the delegate that the label was touched and returns which character was touched.
 
 @param label The instance of PPLabel that called this method.
 @param touch The touch that triggered this event.
 @param charIndex of a character at given point or NSNotFound.
 
 @return Return YES if the delegate handled this touch and should not be propagated any further.
 */
- (BOOL)label:(LhpLinkLabel*)label didBeginTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;

/**
 Tells the delegate that the touch was moved.
 
 @param label The instance of PPLabel that called this method.
 @param touch The touch that triggered this event.
 @param charIndex of a character at given point or NSNotFound.
 
 @return Return YES if the delegate handled this touch and should not be propagated any further.
 */
- (BOOL)label:(LhpLinkLabel*)label didMoveTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;

/**
 Tells the delegate that the label that it's not being touched anymore.
 
 @param label The instance of PPLabel that called this method.
 @param touch The touch that triggered this event.
 @param charIndex of a character at given point or NSNotFound.
 
 @return Return YES if the delegate handled this touch and should not be propagated any further.
 */
- (BOOL)label:(LhpLinkLabel*)label didEndTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;

/**
 Tells the delegate that the label that it's not being touched anymore.
 
 @param label The instance of PPLabel that called this method.
 @param touch The touch that triggered this event.
 
 @return Return YES if the delegate handled this touch and should not be propagated any further.
 */
- (BOOL)label:(LhpLinkLabel*)label didCancelTouch:(UITouch*)touch;

@end


/// Subclass of PPLabel which can detect touches and report which character was touched.
@interface LhpLinkLabel : UILabel

/**
 The object that acts as the delegate of the receiving label.
 
 @see PPLabelDelegate
 */
@property(nonatomic, weak) id <LhpLinkLabelDelegate> delegate;

/**
 Cancels current touch and calls didCancelTouch: on the delegate.
 
 This method does nothing if there is no touch session.
 */
- (void)cancelCurrentTouch;

/**
 Returns the index of character at provided point or NSNotFound.
 
 @param point The point indicating where to look for.
 
 @return Index of a character at given point or NSNotFound.
 */
- (CFIndex)characterIndexAtPoint:(CGPoint)point;

@end
