//
//  ABridge_ParentViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ABridge_MenuViewController.h"
#import "ABridge_SearchViewController.h"
#import "ECSlidingViewController.h"
#import "ABridge_AppDelegate.h"
#import "LoginDetails.h"
#import "Constants.h"

@interface ABridge_ParentViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfURLConnection;
@property (strong, nonatomic) IBOutlet UIView *imageViewTopBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewReload;
@property (weak, nonatomic) IBOutlet UILabel *labelPull;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealSearch:(id)sender;
- (IBAction)goBackToRoot:(id)sender;
- (void) showOverlayWithMessage:(NSString*) message withIndicator:(BOOL) with_indicator;
- (void) dismissOverlay;
- (void) reloadData;

- (NSURLConnection*)urlConnectionWithURLString:(NSString*)urlString andParameters:(NSString*)parameters;
- (void)addURLConnection:(NSURLConnection*)urlConnection;
- (NSArray*)fetchObjectsWithEntityName:(NSString*)entity andPredicate:(NSPredicate*)predicate;

@end
