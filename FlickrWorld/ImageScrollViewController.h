
#import <UIKit/UIKit.h>
#import "Photo+Methods.h"
#import <MessageUI/MessageUI.h>

@interface ImageScrollViewController : UIViewController <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) Photo *photo;



@end
