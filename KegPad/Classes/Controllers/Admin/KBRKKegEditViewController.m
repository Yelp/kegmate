//
//  KBRKKegEditViewController.m
//  KegPad
//
//  Created by John Boiles on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKKegEditViewController.h"
#import "KBRKBeerType.h"

@implementation KBRKKegEditViewController

@dynamic delegate;

- (id)init {
  return [self initWithTitle:@"Keg" useEnabled:NO];
}

- (id)initWithTitle:(NSString *)title useEnabled:(BOOL)useEnabled {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = title;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(_save)] autorelease];

    //NSArray *beers = [[KBApplication dataStore] beersWithOffset:0 limit:200 error:nil];
    //NSMutableArray *beerNames = [NSMutableArray arrayWithCapacity:[beers count]];
    //for (KBBeer *beer in beers) [beerNames addObject:[beer id]];
    //beerTypeSelect_ = [[KBUIFormListSelect formListSelectWithTitle:@"Beer" values:beerNames selectedValue:nil target:self action:@selector(_beerSelect) context:nil] retain];
    //[self addForm:beerTypeSelect_];

    volumeAdjustedField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Volume adjusted" text:@"0"] retain];
    [self addForm:volumeAdjustedField_];
    volumePouredField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Volume poured" text:@"0"] retain];
    [self addForm:volumePouredField_];
    volumeTotalField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Volume total" text:@"58.67"] retain];
    [self addForm:volumeTotalField_];

    if (useEnabled)
      [self addForm:[KBUIForm formWithTitle:@"Use keg" text:nil target:self action:@selector(_kegSelect) showDisclosure:NO] section:1];
    
  }
  return self;
}

- (void)dealloc {
  [beerTypeSelect_ release];
  [volumeAdjustedField_ release];
  [volumePouredField_ release];
  [volumeTotalField_ release];
  [keg_ release];
  [super dealloc];
}

- (void)_kegSelect {
  //if (keg_)
    //[[KBApplication dataStore] setKeg:keg_ position:0];
}

- (void)_beerSelect {
  KBRKBeerTypesViewController *beersViewController = [[KBRKBeerTypesViewController alloc] init];
  beersViewController.delegate = self;
  [beersViewController refresh];
  [self.navigationController pushViewController:beersViewController animated:YES];
  [beersViewController release];
}

- (void)setKeg:(KBRKKeg *)keg {
  [keg retain];
  [keg_ release];
  keg_ = keg;
  //beerSelect_.selectedValue = keg.type.name;
  //volumeAdjustedField_.text = [NSString stringWithFormat:@"%0.2f", keg.volumeAdjustedValue];
  //volumePouredField_.text = [NSString stringWithFormat:@"%0.2f", keg.volumePouredValue];
  volumeTotalField_.text = [NSString stringWithFormat:@"%0.2f", keg.sizeVolumeMl];
}

- (BOOL)validate {
  /*
  NSString *beerName = beerTypeSelect_.selectedValue; // TODO  
  KBRKBeerType *beer = [[KBApplication dataStore] beerWithId:beerName error:nil];  
  if (!beer) {
    [self showAlertWithTitle:nil message:@"Enter a valid beer"];
    return NO;
  }
  float total = [volumeTotalField_.textField.text floatValue];
  if (total <= 0) {
    [self showAlertWithTitle:nil message:@"Total must be > 0"];
    return NO;
  }
  return YES;
   */
  return NO;
}

- (void)_save {
  /*
  if (![self validate]) return;
  
  NSString *identifier = nil;
  if (keg_) identifier = keg_.id;
  else identifier = [NSString gh_uuid];
  
  NSString *beerName = beerSelect_.selectedValue;
  KBBeer *beer = [[KBApplication dataStore] beerWithId:beerName error:nil];
  float volumeAdjusted = [volumeAdjustedField_.textField.text floatValue];
  float volumeTotal = [volumeTotalField_.textField.text floatValue]; // Volume in liters of full keg
  
  NSError *error = nil;
  KBKeg *keg = [[KBApplication dataStore] addOrUpdateKegWithId:identifier beer:beer volumeAdjusted:volumeAdjusted volumeTotal:volumeTotal error:&error];
  
  if (!keg) {
    [self showError:error];
    return;
  }
  
  // Set new keg as current keg
  [[KBApplication dataStore] setKeg:keg position:0];
  [self.delegate kegEditViewController:self didSaveKeg:keg];
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegDidEditNotification object:keg];
  */
}

#pragma mark KBBeersViewControllerDelegate

- (void)beerTypesViewController:(KBRKBeerTypesViewController *)beerTypesViewController didSelectBeerType:(KBRKBeerType *)beerType {
  beerTypeSelect_.selectedValue = beerType.identifier;
  [self.navigationController popToViewController:self animated:YES];
}


@end
