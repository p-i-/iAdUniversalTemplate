//
//  iAdVC.h
//  ___PROJECTNAME___
//
//  Created by Pi on 27/03/2011.
//  Copyright 2011 Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iAd/ADBannerView.h"


@interface iAdVC : UIViewController < ADBannerViewDelegate >
{ }

@property CGRect uberFrame;
//@property BOOL iAdsEnabled;

@property (retain) UIView * contentView;

- (id) init_withFrame : (CGRect) in_frame ;
                 // iAds: (BOOL) in_iAdsEnabled ;

// OVERRIDE
- (UIView *) makeViewUsingFrame: (CGRect) viewFrame ;

@end
