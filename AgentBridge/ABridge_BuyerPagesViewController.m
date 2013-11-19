//
//  ABridge_BuyerPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_BuyerPagesViewController.h"
#import "Constants.h"

@interface ABridge_BuyerPagesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPage;
@property (weak, nonatomic) IBOutlet UILabel *labelBuyerName;
@property (weak, nonatomic) IBOutlet UILabel *labelBuyerType;
@property (weak, nonatomic) IBOutlet UILabel *labelZipcode;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelExpiry;
@property (weak, nonatomic) IBOutlet UIImageView *imageProperty;
@property (weak, nonatomic) IBOutlet UITextView *textFeatures;
@property (weak, nonatomic) IBOutlet UILabel *labelSaved;
@property (weak, nonatomic) IBOutlet UILabel *labelNew;

@end

@implementation ABridge_BuyerPagesViewController
@synthesize index;
@synthesize buyerDetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.labelPage.text = [NSString stringWithFormat:@"%li",(long)self.index+1];
    
    self.labelBuyerName.text = self.buyerDetails.name;
    self.labelBuyerType.text = self.buyerDetails.buyer_type;
    self.labelZipcode.text = [NSString stringWithFormat:@"%@",self.buyerDetails.zip];
    NSMutableString *priceText = [NSMutableString stringWithString:@"$"];
    [priceText appendString:self.buyerDetails.price_value];
    if ([priceText rangeOfString:@"-"].location != NSNotFound) {
        [priceText insertString:@"$" atIndex:[priceText rangeOfString:@"-"].location+1];
    }
    self.labelPrice.text = priceText;
    self.labelExpiry.text = [NSString stringWithFormat:@"Expiry of %@ days", self.buyerDetails.expiry];
    
    NSMutableString *featuresString = [NSMutableString stringWithFormat:@""];
    NSEntityDescription *entity = [self.buyerDetails entity];
    NSDictionary *attributes = [entity attributesByName];
    int count = 0;
    for (NSString *attribute in attributes) {
        if([attribute isEqualToString:@"available_sqft"]||[attribute isEqualToString:@"bathroom"]||[attribute isEqualToString:@"bedroom"]||[attribute isEqualToString:@"bldg_sqft"]||[attribute isEqualToString:@"cap_rate"]||[attribute isEqualToString:@"ceiling_height"]||[attribute isEqualToString:@"condition"]||[attribute isEqualToString:@"furnished"]||[attribute isEqualToString:@"garage"]||[attribute isEqualToString:@"grm"]||[attribute isEqualToString:@"lot_size"]||[attribute isEqualToString:@"lot_sqft"]||[attribute isEqualToString:@"view"]||[attribute isEqualToString:@"year_built"]||[attribute isEqualToString:@"stories"]||[attribute isEqualToString:@"unit_sqft"]){
            
//            NSLog(@"%@ value:%@",([self isNull:[buyerDetails valueForKey:attribute]])?@"YES":@"NO",[buyerDetails valueForKey:attribute]);
            
            if (count == 5) {
                break;
            }
            else {
                if (![self isNull:[self.buyerDetails valueForKey:attribute]]) {
                   
                    [featuresString appendFormat:@"%@",[NSString stringWithFormat:@"%@ %@, ",[self.buyerDetails valueForKey:attribute],attribute]];
                }
            }
            
            count++;
            
        }
        else if([attribute isEqualToString:@"features1"]||[attribute isEqualToString:@"features2"]||[attribute isEqualToString:@"features3"]){
            [featuresString appendFormat:@"%@, ", [self.buyerDetails valueForKey:attribute]];
        }
    }
    
    NSString *removedLastComma = [featuresString substringToIndex:[featuresString length]-2];
    
    [featuresString setString:removedLastComma];
    
    [featuresString appendFormat:@"\n\nNote: %@",self.buyerDetails.desc];
    
    self.textFeatures.text = featuresString;
    
    self.imageProperty.image = [UIImage imageNamed:[self imageStringForPropertyType:[self.buyerDetails.property_type integerValue] andSubType:[self.buyerDetails.sub_type integerValue]]];
    
    self.labelSaved.text = [NSString stringWithFormat:@"Saved (%@)",self.buyerDetails.hasnew_2];
    self.labelNew.text = [NSString stringWithFormat:@"New (%@)",self.buyerDetails.hasnew];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isNull:(id)value {
    return ([[NSNull class] isMemberOfClass:[((NSNull *) value) class]]);
}

-(NSString*)imageStringForPropertyType:(NSInteger)property_type andSubType:(NSInteger)sub_type {
    NSMutableString *imageString = [NSMutableString stringWithString:@""];
    switch (property_type) {
        case RESIDENTIAL_PURCHASE:
            [imageString appendString:@"residential-purchase-"];
            break;
        case RESIDENTIAL_LEASE:
            [imageString appendString:@"residential-lease-"];
            break;
        case COMMERCIAL_PURCHASE:
            [imageString appendString:@"commercial-purchase-"];
            break;
        case COMMERCIAL_LEASE:
            [imageString appendString:@"commercial-lease-"];
            break;
        default:
            [imageString appendString:@"residential-purchase-"];
            break;
    }
    switch (sub_type) {
        case RESIDENTIAL_PURCHASE_SFR: case RESIDENTIAL_LEASE_SFR:
            [imageString appendString:@"sfr"];
            break;
        case RESIDENTIAL_PURCHASE_CONDO: case RESIDENTIAL_LEASE_CONDO:
            [imageString appendString:@"condo"];
            break;
        case RESIDENTIAL_PURCHASE_LAND: case RESIDENTIAL_LEASE_LAND:
            [imageString appendString:@"land"];
            break;
        case RESIDENTIAL_PURCHASE_TOWNHOUSE: case RESIDENTIAL_LEASE_TOWNHOUSE:
            [imageString appendString:@"townhouse"];
            break;
        /*case RESIDENTIAL_LEASE_SFR:
            [imageString appendString:@"sfr"];
            break;
        case RESIDENTIAL_LEASE_CONDO:
            [imageString appendString:@"condo"];
            break;
        case RESIDENTIAL_LEASE_LAND:
            [imageString appendString:@"land"];
            break;
        case RESIDENTIAL_LEASE_TOWNHOUSE:
            [imageString appendString:@"townhouse"];
            break;*/
        case COMMERCIAL_PURCHASE_ASSISTED_CARE:
            [imageString appendString:@"assist"];
            break;
        case COMMERCIAL_PURCHASE_INDUSTRIAL: case COMMERCIAL_LEASE_INDUSTRIAL:
            [imageString appendString:@"industrial"];
            break;
        case COMMERCIAL_PURCHASE_MOTEL:
            [imageString appendString:@"motel"];
            break;
        case COMMERCIAL_PURCHASE_MULTI_FAMILY:
            [imageString appendString:@"multi-family"];
            break;
        case COMMERCIAL_PURCHASE_OFFICE: case COMMERCIAL_LEASE_OFFICE:
            [imageString appendString:@"office"];
            break;
        case COMMERCIAL_PURCHASE_RETAIL: case COMMERCIAL_LEASE_RETAIL:
            [imageString appendString:@"retail"];
            break;
        case COMMERCIAL_PURCHASE_SPECIAL_PURPOSE:
            [imageString appendString:@"special"];
            break;
        /*case COMMERCIAL_LEASE_INDUSTRIAL:
            [imageString appendString:@"industrial"];
            break;
        case COMMERCIAL_LEASE_OFFICE:
            [imageString appendString:@"office"];
            break;
        case COMMERCIAL_LEASE_RETAIL:
            [imageString appendString:@"retail"];
            break;*/
        default:
            [imageString appendString:@"sfr"];
            break;
    }
    [imageString appendString:@".png"];
    return imageString;
}
@end