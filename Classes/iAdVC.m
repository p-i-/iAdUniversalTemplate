//
//  iAdVC.m
//  ___PROJECTNAME___
//
//  Created by Pi on 27/03/2011.
//  Copyright 2011 Pi. All rights reserved.
//

#import "iAdVC.h"
#import "Settings.h"


// #import "MyView.h"


@interface iAdVC ()

@property (retain) UIView * uberView;
@property (assign) ADBannerView * adBannerView;

- (ADBannerView *) makeAdBanner;
@end



@implementation iAdVC

@synthesize  contentView;

@synthesize uberView, adBannerView;
@synthesize uberFrame; // , iAdsEnabled;

- (id) init_withFrame: (CGRect) in_frame
                // iAds: (BOOL) in_iAdsEnabled
{
	uberFrame = in_frame;
    //iAdsEnabled = in_iAdsEnabled;
    
	return [self init];
}

- (UIView *) makeViewUsingFrame: (CGRect) viewFrame 
{
    return nil;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
/* The view controller calls this method when the view property is requested but is currently nil. 
 If you create your views manually, you must override this method and use it to create your views. 
 
 If you use Interface Builder to create your views and initialize the view controller —- that is,
 you initialize the view using the initWithNibName:bundle: method, set the nibName and nibBundle 
 properties directly, or create both your views and view controller in Interface Builder -— then 
 you must not override this method. */
- (void) loadView 
{	
	NSLog(@"    --> iAdVC : loadView...");
    
    self.uberView = [[[UIView alloc] initWithFrame: uberFrame] autorelease];
    self.uberView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //self.uberView.autoresizesSubviews = YES;
    [self setView: uberView];
    
    
    self.contentView = [self makeViewUsingFrame: uberFrame]; // [[[MyView alloc] initWithFrame: uberFrame] autorelease];
    NSLog(@"%@", self.contentView);
    
    //self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[uberView addSubview: contentView];
    
    adBannerView = IADS_ENABLED ? [self makeAdBanner] : nil;
    adBannerView.hidden = YES;
    [uberView addSubview: adBannerView];
	
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
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

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation 
{	
    return YES;
}


- (void) resizeEverything: (UIInterfaceOrientation) newOrientation
{
    bool isLandscape = UIInterfaceOrientationIsLandscape(newOrientation);
    
    float w = uberFrame.size.width, h = uberFrame.size.height;
    float m = MIN(w, h), M = MAX(w, h);
    
    CGSize port = CGSizeMake(m, M), land = CGSizeMake(M, m);
    
	// change banner size dep. on orientation
    [self.adBannerView setCurrentContentSizeIdentifier: isLandscape ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifierPortrait ];
    
    NSLog(@"%@", NSStringFromCGRect(adBannerView.frame)); // !!! HUH? ok now...

    CGSize f = isLandscape ? land : port;    
    
    CGRect bannerFrame = CGRectZero;
    if (adBannerView && ! adBannerView.hidden) 
        bannerFrame.size = adBannerView.frame.size;
    
    CGRect contentFrame = CGRectMake(0, 
                                     bannerFrame.size.height, 
                                     f.width, 
                                     f.height - bannerFrame.size.height);
    
    self.adBannerView.frame = bannerFrame;
    self.contentView.frame = contentFrame;
}


- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) newOrientation 
								 duration: (NSTimeInterval) duration
{
    [self resizeEverything: newOrientation];
}

/*
 - (void) resizeEverything
 {
 UIInterfaceOrientation O = [[UIApplication sharedApplication] statusBarOrientation];
 [self resizeEverything: O];
 }
 */


#pragma mark Banner

- (ADBannerView *) makeAdBanner 
{
    ADBannerView * B;
    
	assert (!self.adBannerView);
	
    B = [ [ [ADBannerView alloc] initWithFrame: CGRectZero] autorelease];
	if ( ! B ) 
		return nil;
	
    B.hidden = YES;
    
	[B setRequiredContentSizeIdentifiers:[NSSet setWithObjects: 
                                          ADBannerContentSizeIdentifierPortrait, 
                                          ADBannerContentSizeIdentifierLandscape, nil]];	
        
	[B setDelegate: self];
    
    return B;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void) bannerViewDidLoadAd: (ADBannerView *) banner 
{    
    if (self.adBannerView.hidden)
    {        
        [UIView setAnimationsEnabled:NO];
        self.adBannerView.alpha = 0.;
        [UIView setAnimationsEnabled:YES];
        
        // NOTE: no need to position ad-view as it's always (0,0)
        
        // change banner size dep. on orientation
        //    ... this will get set after every rotation, but right at the start we need to do it.
        {
            bool isLandscape = UIInterfaceOrientationIsLandscape( [[UIApplication sharedApplication] statusBarOrientation] );
            [self.adBannerView setCurrentContentSizeIdentifier: isLandscape ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifierPortrait ];
        }
        
        self.adBannerView.hidden = NO;
        
        NSLog(@"%@", NSStringFromCGRect(adBannerView.frame)); // !!! FIXME IS 0,0,0,0 WHY???
        
        // resize content frame & fade ad in        
        CGRect newContentFrame = uberView.bounds;
        newContentFrame.size.height -= adBannerView.frame.size.height;
        newContentFrame.origin.y += adBannerView.frame.size.height;   
        
        NSTimeInterval duration = 5.;
        [UIView animateWithDuration: duration / 2.
                         animations: ^ { 
                             self.contentView.frame = newContentFrame;
                         }
                         completion: ^ (BOOL finished) { 
                             self.adBannerView.alpha = 1.0; 
                         }
         ];
    }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void) bannerView: (ADBannerView *) banner 
didFailToReceiveAdWithError: (NSError *) error
{
    if (! self.adBannerView.hidden)
    {
        self.adBannerView.hidden = YES;
        
        // increase content-view to fullscreen
        NSTimeInterval duration = 0.5;
        [UIView animateWithDuration: duration
                         animations: ^ { 
                             self.contentView.frame = uberView.bounds; 
                         }
                         completion: nil 
         ];
    }
}



@end
