//
//  iAdVC.m
//  ___PROJECTNAME___
//
//  Created by Pi on 27/03/2011.
//  Copyright 2011 Pi. All rights reserved.
//

#import "iAdVC.h"
#import "Settings.h"

#import "MyView.h"

// = = = = = = = = = = = = = = = = = = = = = = = = = = 
#pragma mark PRIVATE INTERFACE

@interface iAdVC ()

    @property (retain) UIView * uberView;
    @property (retain) ADBannerView * adBannerView;

    @property (retain) UIView * contentView;

+ (NSString *) bannerTokenForOrientation:  (UIInterfaceOrientation) ori ;
+ (CGSize) bannerSizeForOrientation: (UIInterfaceOrientation) ori ;

@end

// = = = = = = = = = = = = = = = = = = = = = = = = = = 
#pragma mark IMPLEMENTATION

@implementation iAdVC

// - - - - - - - - - - - - - - - - - - - - - - - - - -

@synthesize uberView, adBannerView;
@synthesize contentView;

// = = = = = = = = = = = = = = = = = = = = = = = = = = 

- (UIView *) makeViewUsingFrame: (CGRect) viewFrame 
{
    NSLog(@"OVERRIDE ME!!!");
    //MyView * v = [[[MyView alloc] initWithFrame: viewFrame] autorelease];
    
    return nil; //(UIView *) v;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void) loadView 
{	    
    self.uberView = [[[UIView alloc] initWithFrame: [UIScreen mainScreen].applicationFrame] autorelease];
    self.uberView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.uberView.autoresizesSubviews = YES;
    
    // UIKit bug: need this
    self.uberView.backgroundColor = [UIColor blackColor];
    
    [self setView: uberView];
    
    showingBanner = NO;
    adBannerView = nil;
    if (IADS_ENABLED)
    {
        NSString * P = ADBannerContentSizeIdentifierPortrait;
        NSString * L = ADBannerContentSizeIdentifierLandscape;
        
        self.adBannerView = [[[ADBannerView alloc] initWithFrame:CGRectZero] autorelease];
        
        self.adBannerView.delegate = self;
        self.adBannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        self.adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects: P, L, nil];
        
        // Apps always start in Portrait, then rotate as necessary
        self.adBannerView.currentContentSizeIdentifier = P;
        self.adBannerView.hidden = YES;
        
        [uberView addSubview: adBannerView];
    }
    
    
    self.contentView = [self makeViewUsingFrame: uberView.frame];
    
    NSLog(@"%@", self.contentView);

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [uberView addSubview: contentView];
    
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = 
#pragma mark etc

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation 
{	
    return YES; // support all orientations
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

-(BOOL) bannerViewActionShouldBegin: (ADBannerView *) banner 
               willLeaveApplication: (BOOL) willLeave
{
    return YES; // allow execution
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

+ (NSString *) bannerTokenForOrientation:  (UIInterfaceOrientation) ori
{
    NSString * P = ADBannerContentSizeIdentifierPortrait;
    NSString * L = ADBannerContentSizeIdentifierLandscape;
    
    return UIInterfaceOrientationIsPortrait( ori ) ? P : L ;
}

// - - - 

+ (CGSize) bannerSizeForOrientation: (UIInterfaceOrientation) ori
{
    NSString * token = [self bannerTokenForOrientation: ori];
    
    CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier: token];
    
    return bannerSize;
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = 
#pragma mark things that change layout

- (void) bannerViewDidLoadAd: (ADBannerView *) banner 
{
    CGSize bannerSize = [iAdVC bannerSizeForOrientation: self.interfaceOrientation];
    CGRect bannerRect = CGRectMake(0, 0, bannerSize.width, bannerSize.height);
    
    // exchange old ad for new
    if ( ! self.adBannerView.hidden )
    {
        // whoosh off to side
        [UIView animateWithDuration: 0.33
                              delay: .0 
                            options: (UIViewAnimationOptions) 0
                         animations: ^ { self.adBannerView.frame = CGRectOffset(bannerRect, -bannerSize.width, 0); } 
                         completion: ^ (BOOL ret) {
                             // ... & whoosh new one in
                             [UIView setAnimationsEnabled:NO];
                             self.adBannerView.frame = CGRectOffset(bannerRect, bannerSize.width, 0);
                             [UIView setAnimationsEnabled:YES];
                             
                             [UIView animateWithDuration: .33
                                                   delay: .0 
                                                 options: (UIViewAnimationOptions) 0
                                              animations: ^ { self.adBannerView.frame = bannerRect; } 
                                              completion: nil
                              ];
                         }
         ];
        
        return;
    }
    
    else
    {
        // start banner offscreen
        [UIView setAnimationsEnabled:NO];
        {
            self.adBannerView.frame = CGRectOffset(bannerRect, 0, -bannerSize.height);
        }
        [UIView setAnimationsEnabled:YES];
        

        // ... & drop ad in from top, squashing content-view
        self.adBannerView.hidden = NO;
        
        CGRect newContentFrame = uberView.bounds;
        newContentFrame.size.height -= bannerSize.height;
        newContentFrame.origin.y += bannerSize.height;  

        [UIView animateWithDuration: .9
                              delay: .0 
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionLayoutSubviews
                         animations: ^ { 
                             self.contentView.frame = newContentFrame; 
                             self.adBannerView.frame = bannerRect;
                         } 
                         completion: nil
         ];
        
        return;
    }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void) bannerView: (ADBannerView *) banner 
didFailToReceiveAdWithError: (NSError *) error
{
    if (! self.adBannerView.hidden)
    {
        CGSize bannerSize = [iAdVC bannerSizeForOrientation: self.interfaceOrientation];
        CGRect bannerRect = CGRectMake(0, 0, bannerSize.width, bannerSize.height);
        
        // slide banner up & out ...
        [UIView animateWithDuration: .9
                              delay: .0 
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionLayoutSubviews
                         animations: ^ { 
                             self.contentView.frame = uberView.bounds; 
                             self.adBannerView.frame = CGRectOffset(bannerRect, 0, -bannerSize.height);
                         } 
                         completion: ^ (BOOL ret) { self.adBannerView.hidden = YES; }
         ];
    }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) newOrientation 
								 duration: (NSTimeInterval) duration
{
    bool isLandscape = UIInterfaceOrientationIsLandscape(newOrientation);
    self.adBannerView.currentContentSizeIdentifier = isLandscape ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifierPortrait ;
    
    if (! adBannerView.hidden)
    {
        CGSize bannerSize = [iAdVC bannerSizeForOrientation: newOrientation];
        CGRect bannerRect = CGRectMake(0, 0, bannerSize.width, bannerSize.height);    
        
        CGRect newContentFrame = uberView.bounds;
        newContentFrame.size.height -= bannerSize.height;
        newContentFrame.origin.y += bannerSize.height;  
        
        [UIView animateWithDuration: duration
                              delay: .0 
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionLayoutSubviews
                         animations: ^ { 
                             self.contentView.frame = newContentFrame; 
                             self.adBannerView.frame = bannerRect;
                         } 
                         completion: nil
         ];
    }
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = 
#pragma mark Tidy-up

- (void) didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void) viewDidUnload
{ }

- (void) dealloc
{
    [self.adBannerView removeFromSuperview]; 
    self.adBannerView.delegate = nil; 
    self.adBannerView = nil;
    
    [self.uberView removeFromSuperview]; 
    self.uberView = nil;
    
    [super dealloc];
}

@end
