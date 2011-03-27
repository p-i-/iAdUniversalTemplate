//
//  ___PROJECTNAME___AppDelegate.h
//  ___PROJECTNAME___
//
//  Created by pi on 13/08/2010.
//

#import <UIKit/UIKit.h>

@class ___PROJECTNAME___ViewController;

@interface ___PROJECTNAME___AppDelegate : NSObject < UIApplicationDelegate > 
{
    UIWindow *                          window;
    ___PROJECTNAME___ViewController *   viewController;
}

/* I used the ' view based application ' template to create this project. The IBOutlet 
 token tells Xcode to look to the .XIB for creating these objects -- the .XIB would 
 have all sorts of information such as size, whether to show the status bar etc.
 
 Anyway, IBOutlet can be taken out now, as I have removed the .XIB.  It wouldn't hurt 
 to leave it there as it is an empty #define, but that would be bad form. */ 

@property (nonatomic, retain) /*IBOutlet*/ UIWindow * window;
@property (nonatomic, retain) /*IBOutlet*/ ___PROJECTNAME___ViewController * viewController;

@end

