//
//  MMDrawerController+Storyboard.m
//
//  Created by Nicholas Hodapp on 5/28/13.
//  Copyright (c) 2013 Nicholas Hodapp. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MMDrawerController+Storyboard.h"
#import "MMDrawerController.h"


// custom placeholder segue
@interface MMDrawerControllerSegue : UIStoryboardSegue
@end

@implementation MMDrawerControllerSegue
-(void)perform
{
    // noop
    
    NSAssert( [self.sourceViewController isKindOfClass: [MMDrawerController class]], @"MMDrawerControllerSegue only to be used to define left/center/right controllers for a MMDrawerController!");
}
@end

@implementation MMDrawerController (Storyboard)

-(void)awakeFromNib
{
    // If we were instantiated via a storybard then we'll assume that we have pre-defined segues to denote
    // our center controller, and optionally left and right controllers!
    if ( self.storyboard != nil )
    {
        // Required segue "mm_center".  Uncaught exception if undefined in storyboard.
        [self performSegueWithIdentifier: @"mm_center" sender: self];

        // Optional segue "mm_left".
        @try
        {
            [self performSegueWithIdentifier: @"mm_left" sender: self];
        }
        @catch (NSException *exception)
        {
        }
        @finally
        {
        }
        
        @try
        {
        
            
        
               [self performSegueWithIdentifier: @"mm_right" sender: self];
            
        }
        @catch (NSException *exception)
        {
        }
        @finally
        {
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString: @"mm_center"] )
    {
        NSParameterAssert( [segue isKindOfClass: [MMDrawerControllerSegue class]]);
        [self setCenterViewController: segue.destinationViewController];
    }
    else
    if ( [segue.identifier isEqualToString: @"mm_left"] )
    {
        NSParameterAssert( [segue isKindOfClass: [MMDrawerControllerSegue class]]);
        [self setLeftDrawerViewController: segue.destinationViewController];
    }
    else 
    if ( [segue.identifier isEqualToString: @"mm_right"] )
    {
        NSParameterAssert( [segue isKindOfClass: [MMDrawerControllerSegue class]]);
        [self setRightDrawerViewController: segue.destinationViewController];
    }
}

@end
