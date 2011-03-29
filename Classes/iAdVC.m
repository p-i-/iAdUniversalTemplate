//
//  iAdVC.m
//  ___PROJECTNAME___
//
//  Created by Pi on 27/03/2011.
//  Copyright 2011 Pi. All rights reserved.
//

#import "iAdVC.h"
#import "Settings.h"

// = = = = = = = = = = = = = = = = = = = = = = = = = = 

@interface iAdVC ()

    @property (retain) UIView * uberView;
    @property (retain) ADBannerView * adBannerView;

    - (ADBannerView *) makeAdBanner;

@end

// = = = = = = = = = = = = = = = = = = = = = = = = = = 

@implementation iAdVC

// - - - - - - - - - - - - - - - - - - - - - - - - - -

@synthesize uberView, adBannerView;

// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (UIView *) makeViewUsingFrame: (CGRect) viewFrame 
{
    return nil;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void) loadView 
{	    
    self.uberView = [[[UIView alloc] initWithFrame: [UIScreen mainScreen].applicationFrame] autorelease];
    self.uberView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.uberView.autoresizesSubviews = YES;
    [self setView: uberView];
    
    showingBanner = NO;
    adBannerView = nil;
    if (IADS_ENABLED)
    {
        NSString * P = ADBannerContentSizeIdentifierPortrait;
        NSString * L = ADBannerContentSizeIdentifierLandscape;
        
        adBannerView = [[[ADBannerView alloc] initWithFrame:CGRectZero] autorelease];
        
        adBannerView.delegate = self;
        adBannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects: P, L, nil];
        adBannerView.currentContentSizeIdentifier = UIInterfaceOrientationIsPortrait( self.interfaceOrientation ) ? P : L ;
        
        [uberView addSubview: adBannerView];
    }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

#pragma mark Autorotate

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation 
{	
    return YES;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) newOrientation 
								 duration: (NSTimeInterval) duration
{
    bool isLandscape = UIInterfaceOrientationIsLandscape(newOrientation);
    self.adBannerView.currentContentSizeIdentifier = isLandscape ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifierPortrait ;
}


#pragma mark Banner

// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void) bannerViewDidLoadAd: (ADBannerView *) banner 
{   
    if (! showingBanner)
    {
        showingBanner = YES;
        // ... (optionally animate in)
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void) bannerView: (ADBannerView *) banner 
didFailToReceiveAdWithError: (NSError *) error
{
    NSLog(@"FAIL");
    
    if (showingBanner)
    {
        showingBanner = NO;
        // ... (optionally animate out)
    }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

-(BOOL) bannerViewActionShouldBegin: (ADBannerView *) banner 
               willLeaveApplication: (BOOL) willLeave
{
    return YES;
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = 

#pragma mark Tidy-up
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void) viewDidUnload
{
}

- (void) dealloc
{
    [self.adBannerView removeFromSuperview]; self.adBannerView.delegate = nil; [self.adBannerView release]; self.adBannerView = nil;
    
    [self.uberView removeFromSuperview]; [self.uberView release]; self.uberView = nil;
    
    [super dealloc];
}

@end
