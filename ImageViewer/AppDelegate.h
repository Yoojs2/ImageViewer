//
//  AppDelegate.h
//  ImageViewer
//
//  Created by 유재성 on 1/6/25.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (weak) IBOutlet NSImageView *imageViewer;
- (IBAction)onBtnImageOpen:(id)sender;
- (IBAction)btnZoomIn:(id)sender;
- (IBAction)btnZoomOut:(id)sender;
- (IBAction)onBtnImageRotateCW:(id)sender;
- (IBAction)onBtnImageRotateCCW:(id)sender;
- (IBAction)onBtnGrayScale:(id)sender;






@end

