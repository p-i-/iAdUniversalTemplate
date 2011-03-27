//
//  MyView.m
//  ___PROJECTNAME___
//
//  Created by pi on 13/08/2010.
//

#import "MyView.h"

@implementation MyView

/*
- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
	}
    return self;
}
*/
 
- (void)drawRect:(CGRect)rect 
{
	NSLog(@"MyView:drawRect...");

	CGContextRef X = UIGraphicsGetCurrentContext();	
	
	CGRect bounds =  CGContextGetClipBoundingBox(X);
	CGPoint center = CGPointMake((bounds.size.width / 2), (bounds.size.height / 2));
	
	NSLog(@"--> (drawRect) bounds:'%@'", NSStringFromCGRect(bounds));
	
	// fill background rect dark red
	CGContextSetRGBFillColor(X, 0.3,0,0, 1.0);
	CGContextFillRect(X, bounds);
	
	// circle
	CGContextSetRGBFillColor(X, 0.6,0,0, 1.0);
	CGContextFillEllipseInRect(X, bounds);
	
	// fat rounded-cap line from origin to center of view
	CGContextSetRGBStrokeColor(X, 1,0,0, 1.0);
	CGContextSetLineWidth(X, 30);	
	CGContextSetLineCap(X, kCGLineCapRound);
	CGContextBeginPath(X);
	CGContextMoveToPoint(X, 0,0);
	CGContextAddLineToPoint(X, center.x, center.y);
	CGContextStrokePath(X);
	
	// Draw the text "No XIB !" in light blue
    char* text = "No XIB !";
    CGContextSelectFont(X, "Helvetica Bold", 36.0f, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(X, kCGTextFill);
    CGContextSetRGBFillColor(X, 0.1f, 0.3f, 0.8f,  1.0f);	
    CGAffineTransform xform = CGAffineTransformMake(
													1.0f,  0.0f,
													0.0f, -1.0f,
													0.0f,  0.0f   );
    CGContextSetTextMatrix(X, xform);	
    CGContextShowTextAtPoint(X, center.x, center.y, text, strlen(text));
}


- (void)dealloc {
    [super dealloc];
}


@end
