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
    [[UIApplication sharedApplication] setStatusBarHidden: (SHOW_SB ? NO : YES)];

	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	
	// windowRect must start at 0, 0
	// if (SHOW_SB == YES), appFrame will be '{{0, 20}, {320, 460}}'
	CGRect windowRect = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
		
    self.window = [[[UIWindow alloc] initWithFrame: windowRect] autorelease];
		
	self.viewController = [ [ [ ___PROJECTNAME___ViewController alloc ] init ] autorelease ];
		 
    [self.window setRootViewController: viewController];
    
    // triggers loadView
    [self.window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc 
{
    [viewController release];
    [window release];
    [super dealloc];
}


@end
