//
//  ABridge_PropertyPagesViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Property.h"

@protocol ABridge_PropertyPagesViewControllerDelegate <NSObject>

- (void) zoomImage:(NSData*)image_data;
@optional
- (void) hideSaveButton:(BOOL)hide;
- (void) replaceSaveWithText:(NSString*)string;

@end

@interface ABridge_PropertyPagesViewController : UIViewController <UIScrollViewDelegate, NSURLConnectionDelegate>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) Property *propertyDetails;
@property (assign, nonatomic) id <ABridge_PropertyPagesViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL buyers_view;
    @property (assign, nonatomic) BOOL fromSearch;
@property (assign, nonatomic) NSInteger buyer_id;
@property (strong, nonatomic) NSString *buyer_name;
@end
