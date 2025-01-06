//
//  AppDelegate.m
//  ImageViewer
//
//  Created by 유재성 on 1/6/25.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property CGFloat currentScale; // 현재 이미지 스케일 저장


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.currentScale = 1.0;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (void)zoomImageBy:(CGFloat)scaleFactor{
    //현재 스케일 업데이트
    self.currentScale *= scaleFactor;
    
    //이미지 뷰의 현재 이미지 가져오기
    NSImage *image = self.imageViewer.image;
    if(!image)
    {
        self.currentScale = 1.0; //이미지 로드 시 초기 스케일로 설정
        [self.imageViewer setImage:image];
        [self.imageViewer setFrameSize:image.size]; //이미지 뷰 크기 초기화
        
        NSLog(@"이미지가 없습니다."ㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷ);
        return;
    }
    
    NSSize newSize = NSMakeSize(image.size.width * self.currentScale, image.size.height * self.currentScale);
    
    //이미지 뷰의 프레임 크기 조정
    [self.imageViewer setFrameSize:newSize];
    [self.imageViewer setImageScaling:NSImageScaleAxesIndependently]; //이미지 스케일 방식 설정
}





- (IBAction)btnZoomOut:(id)sender {
    
    [self zoomImageBy:0.8];
}

- (IBAction)btnZoomIn:(id)sender {
    [self zoomImageBy:1.2];
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
