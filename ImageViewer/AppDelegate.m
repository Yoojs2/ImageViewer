//
//  AppDelegate.m
//  ImageViewer
//
//  Created by 유재성 on 1/6/25.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


- (IBAction)btnZoomOut:(id)sender {
}

- (IBAction)btnZoomIn:(id)sender {
}

- (IBAction)onBtnImageOpen:(id)sender {
    
    //1. NSOpenPanel 생성
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES]; // 파일 선택 허용
    [openPanel setCanChooseDirectories:NO]; // 디렉토리 선택 비허용
    [openPanel setAllowsMultipleSelection:NO]; // 다중 선택 비허용
    [openPanel setAllowedFileTypes:@[@"png", @"jpg", @"jpeg", @"gif", @"tiff"]];
 
    //2. 폴더 다이얼로그 실행
    if([openPanel runModal] == NSModalResponseOK)
    {
        //3. 선택된 파일 URL 가져오기
        NSURL *fileURL = [openPanel URL];
        
        //4. NSImage로 이미지 로드
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:fileURL];
        
        if(image)
        {
            [self.imageViewer setImage:image];
            
        }
        
        else
        {
            NSLog(@"이미지를 로드할 수 없습니다. %@", fileURL);
        }
        
    }
}
@end
