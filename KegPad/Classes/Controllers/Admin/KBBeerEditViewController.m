//
//  KBBeerEditViewController.m
//  KegPad
//
//  Created by Gabe on 9/30/10.
//  Copyright 2010 rel.me. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "KBBeerEditViewController.h"

#import "KBUser.h"
#import "KBApplication.h"
#import "KBNotifications.h"

@interface KBBeerEditViewController ()
@property (readonly, retain, nonatomic) UIWebView *webView;
@end

@implementation KBBeerEditViewController

@dynamic delegate;
@synthesize webView=webView_;

- (id)init {
  return [self initWithTitle:@"Beer"];
}

- (id)initWithTitle:(NSString *)title {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = title;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(_save)] autorelease];

    nameField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Name" text:nil] retain];
    [nameField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:nameField_];
    infoField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Info" text:nil] retain];
    [self addForm:infoField_];
    typeField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Type" text:nil] retain];
    [self addForm:typeField_];
    abvField_ = [[KBUIFormTextField formTextFieldWithTitle:@"ABV" text:nil] retain];
    [self addForm:abvField_];
    countryField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Country" text:nil] retain];
    [self addForm:countryField_];

    imageNameField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Image" text:nil] retain];
    [self addForm:imageNameField_ section:1];
    [self addForm:[KBUIForm formWithTitle:@"Choose image from photo library" text:@"" target:self action:@selector(_selectFromPhotoLibrary) showDisclosure:NO] section:1];    

    [self addForm:[KBUIForm formWithTitle:@"Google Search in UIWebView" text:@"" target:self action:@selector(_googleSearch) showDisclosure:YES] section:2];    
    [self addForm:[KBUIForm formWithTitle:@"Google Image Search in Safari (Exits KegPad)" text:@"" target:self action:@selector(_googleImageSearch) showDisclosure:YES] section:2];    
  }
  return self;
}

- (void)dealloc {
  [nameField_ release];
  [typeField_ release];
  [infoField_ release];
  [abvField_ release];
  [countryField_ release];
  [imageNameField_ release];
  [_beerEditId release];
  [super dealloc];
}

- (void)setBeer:(KBBeer *)beer {
  [_beerEditId autorelease];
  _beerEditId = [beer.id retain];
  nameField_.text = beer.name;
  infoField_.text = beer.info;
  typeField_.text = beer.type;
  abvField_.text = [NSString stringWithFormat:@"%0.2f", beer.abvValue];
  countryField_.text = beer.country;
  imageNameField_.text = beer.imageName;
}

- (BOOL)validate {
  NSString *name = nameField_.textField.text;
  return (!([NSString gh_isBlank:name]));
}

- (void)_updateNavigationItem {
  self.navigationItem.rightBarButtonItem.enabled = [self validate];
}

- (void)_onTextFieldDidChange:(id)sender {
  [self _updateNavigationItem];
}

- (void)_save {
  if (![self validate]) return;
  
  NSString *name = nameField_.textField.text;
  NSString *info = infoField_.textField.text;
  NSString *type = typeField_.textField.text;
  NSString *country = countryField_.textField.text;
  NSString *imageName = imageNameField_.textField.text;
  float abv = [abvField_.textField.text floatValue];
  
  NSString *identifier = _beerEditId;
  if (!identifier) identifier = name;

  NSError *error = nil;
  KBBeer *beer = [[KBApplication dataStore] addOrUpdateBeerWithId:identifier name:name info:info type:type country:country imageName:imageName abv:abv error:&error];
    
  if (!beer) {
    [self showError:error];
    return;
  }
  
  [self.delegate beerEditViewController:self didSaveBeer:beer];
  [[NSNotificationCenter defaultCenter] postNotificationName:KBBeerDidEditNotification object:beer];
}

- (void)_selectFromPhotoLibrary {
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.allowsEditing = YES;
  imagePickerController.delegate = self;
  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
  [popoverController presentPopoverFromRect:self.view.frame
                                     inView:self.view
                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                   animated:YES];
  [imagePickerController release];
}

#pragma mark WebView

- (UIWebView *)webView {
  if (!webView_) {
    webView_ = [[UIWebView alloc] initWithFrame:self.view.frame];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton addTarget:webView_ action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(10, webView_.frame.size.height - 40, 50, 30);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [webView_ addSubview:backButton];

    UIButton *useCopiedImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [useCopiedImageButton addTarget:self action:@selector(_pasteImage) forControlEvents:UIControlEventTouchUpInside];
    useCopiedImageButton.frame = CGRectMake(70, webView_.frame.size.height - 40, 150, 30);
    [useCopiedImageButton setTitle:@"Use Copied Image" forState:UIControlStateNormal];
    [webView_ addSubview:useCopiedImageButton];
    
    NSString *urlAddress = [NSString stringWithFormat:@"http://www.google.com/search?q=%@",
                            [nameField_.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    // Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
  }
  return webView_;
}

- (void)_googleSearch {
  UIViewController *webViewController = [[UIViewController alloc] init];  
  webViewController.view = self.webView;
  [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)_googleImageSearch {
  NSString *urlAddress = [NSString stringWithFormat:@"http://www.google.com/images?q=%@",
                          [nameField_.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSURL *url = [NSURL URLWithString:urlAddress];
  [[UIApplication sharedApplication] openURL:url];
}

- (void)_pasteImage {  
  //KBDebug(@"%@", [[UIPasteboard generalPasteboard] items]);
  id data = [[[UIPasteboard generalPasteboard] dataForPasteboardType:@"Apple Web Archive pasteboard type" inItemSet:nil] gh_firstObject];
  //KBDebug(@"%@: %@", [data class], data);
  NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  KBDebug(@"String UTF8: %@", dataString);
  dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
  KBDebug(@"String ASCII: %@", dataString);
  dataString = [[NSString alloc] initWithData:data encoding:NSNEXTSTEPStringEncoding];
  KBDebug(@"String NS: %@", dataString);
  dataString = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
  KBDebug(@"String UNICODE: %@", dataString);
  dataString = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
  KBDebug(@"String ASCIINL: %@", dataString);
  dataString = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
  KBDebug(@"String UTF16: %@", dataString);
  NSString *error;
  //NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:data format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
  //KBDebug(@"Plist Data: %@, %@", plistData, error);
  //id plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:NSPropertyListOpenStepFormat errorDescription:nil];
  //KBDebug(@"Plist %@", plist);
  NSPropertyListFormat format;
  id dma = [NSPropertyListSerialization propertyListFromData:data
                                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                      format:&format
                                            errorDescription:&error];
  KBDebug(@"%@, %@, %d, %@", [dma class], dma, format, error);
}

#pragma mark Delegates (UIImagePickerController)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  KBDebug(@"%@", info);
  NSString *fileName = [NSString stringWithFormat:@"%@.png", nameField_.textField.text];
  NSString *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", fileName]];
  UIImage *beerImage = [info objectForKey:UIImagePickerControllerEditedImage];
  // Write image to PNG
  [UIImagePNGRepresentation(beerImage) writeToFile:imagePath atomically:YES];
  imageNameField_.textField.text = fileName;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {}

#pragma mark Delegates (UINavigationController)

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {}

@end

