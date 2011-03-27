//
//  ___PROJECTNAME___AppDelegate.m
//  ___PROJECTNAME___
//
//  Created by pi on 13/08/2010.
//

#import "Settings.h"
#import "AppDelegate.h"
#import "___PROJECTNAME___ViewController.h"

@implementation ___PROJECTNAME___AppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary *) launchOptions 
{
	NSLog(@"--> ___PROJECTNAME___AppDelegate:didFinishLaunchingWithOptions...");
	
    // FIXED: now entry in info.plist hides SB BEFORE launch
    [[UIApplication sharedApplication] setStatusBarHidden:(SHOW_SB ? NO : YES)];

	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	NSLog(@"    * appFrame:'%@'", 
		  NSStringFromCGRect(appFrame));
	
	// Create the window that will host the viewController
	
	// windowRect must start at 0, 0
	// if (SHOW_SB == YES), appFrame will be '{{0, 20}, {320, 460}}'
	CGRect windowRect = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
	NSLog(@"    * windowRect:'%@'", 
		  NSStringFromCGRect(windowRect)  );
	
	self.window = [[[UIWindow alloc] initWithFrame:windowRect] autorelease];
	NSLog(@"    * window.bounds:'%@'", 
		  NSStringFromCGRect(window.bounds)  );
	
	
	/* NOTE: init_withFrame lets the view controller know the dimensions of the view it must create.
	it will create the view when loadView is triggered.  This will occur automatically the first time 
	viewController.view is accessed.  ie in [window addSubview:viewController.view]; below */
	self.viewController = [___PROJECTNAME___ViewController alloc];
    [self.viewController init_withFrame: appFrame
                                  // iAds: IADS_ENABLED
     ];
    [self.viewController autorelease];
	
	/* viewController.view: If you access this property and its value is currently nil, 
	 the view controller automatically calls the loadView method. 
	 The default loadView method attempts to load the view from the nib file 
	 associated with the view controller (if any). If your view controller does
	 not have an associated nib file, you should override the loadView 
	 method and use it to create the root view and all of its subviews. */
	
	// so can't do this: 
	//NSLog(@"    * viewController.view.bounds:'%@'", 
	//	  NSStringFromCGRect(viewController.view.bounds)  );
	// or LoadView then viewDidLoad would get triggered
	 
	// accessing a nil viewController.view forces loadView then viewDidLoad to be called
    [window addSubview:viewController.view];
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
