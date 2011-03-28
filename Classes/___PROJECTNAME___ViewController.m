//
//  ___PROJECTNAME___ViewController.m
//  ___PROJECTNAME___
//
//  Created by pi on 13/08/2010.
//

#import "___PROJECTNAME___ViewController.h"

#import "iAd/ADBannerView.h"


@interface ___PROJECTNAME___ViewController()
@end

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

@implementation ___PROJECTNAME___ViewController


// Implement loadView to create a view hierarchy programmatically, without using a nib.
/* The view controller calls this method when the view property is requested but is currently nil. 
 If you create your views manually, you must override this method and use it to create your views. 
 
 If you use Interface Builder to create your views and initialize the view controller —- that is,
 you initialize the view using the initWithNibName:bundle: method, set the nibName and nibBundle 
 properties directly, or create both your views and view controller in Interface Builder -— then 
 you must not override this method. */
- (UIView *) makeViewUsingFrame: (CGRect) viewFrame 
{	
	NSLog(@"    --> ___PROJECTNAME___ViewController : makeViewUsingFrame: %@", NSStringFromCGRect(viewFrame));
		
    return (UIView *) [[[MyView alloc] initWithFrame: viewFrame] autorelease];
}

/* Discussion
 This method is called after the view controller has loaded its associated views into memory. 
 This method is called regardless of whether the views were stored in a nib file or 
 created programmatically in the loadView method. 
 
 This method is most commonly used to perform additional initialization steps on 
 views that are loaded from nib files. */

/*
- (void)viewDidLoad 
{
    [super viewDidLoad];
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}



#pragma mark Autorotate

/* override ... or get default to ALL rots supported
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation 
{	
    return YES;
}
*/

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) newOrientation 
								 duration: (NSTimeInterval) duration
{
    // needed as iAdVC's implementation of this rearranges iAd & contentView
    [super willRotateToInterfaceOrientation: newOrientation
                                   duration: duration ];
    
    // ... any extra rotation code here
}


@end
