//
//  ImageScrollViewController.h
//  ImageScroll
//
//  Created by Evgenii Neumerzhitckii on 19/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo+Methods.h"
#import <MessageUI/MessageUI.h>

@interface ImageScrollViewController : UIViewController <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) Photo *photo;



@end
