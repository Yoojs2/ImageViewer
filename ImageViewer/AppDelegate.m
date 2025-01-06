//
//  AppDelegate.m
//  ImageViewer
//
//  Created by 유재성 on 1/6/25.
//

#import "AppDelegate.h"
#import "CoreImage/CoreImage.h"
@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property CGFloat currentScale; // 현재 이미지 스케일 저장
@property (strong, nonatomic) NSImage *originalImage; // 원본 컬러 이미지 저장

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
        
        NSLog(@"이미지가 없습니다.");
        return;
    }
    
    NSSize newSize = NSMakeSize(image.size.width * self.currentScale, image.size.height * self.currentScale);
    
    //이미지 뷰의 프레임 크기 조정
    [self.imageViewer setFrameSize:newSize];
    //이미지 스케일 방식 설정
    [self.imageViewer setImageScaling:NSImageScaleAxesIndependently];
}



- (IBAction)onBtnGrayScale:(id)sender {
    
    // 현재 이미지 가져오기
        NSImage *image = self.imageViewer.image;
        
        if (!image) {
            NSLog(@"이미지가 없습니다.");
            return;
        }
        
        // 흑백 상태를 저장하는 플래그
        static BOOL isGrayScale = NO;
        
        if (!isGrayScale) {
            // 1. 원본 컬러 이미지를 저장
            self.originalImage = image;
            
            // 2. 이미지를 흑백으로 변환
            NSImage *grayImage = [self convertToGrayScale:image];
            self.imageViewer.image = grayImage;
            isGrayScale = YES;
        } else {
            // 3. 원래 컬러 이미지로 복원
            self.imageViewer.image = self.originalImage;
            isGrayScale = NO;
        }
    
}


- (NSImage *)convertToGrayScale:(NSImage *)image
{
    //1. 새로운 흑백 이미지 생성
    NSSize imageSize = image.size;
    NSImage *grayImage = [[NSImage alloc] initWithSize:imageSize];
    
    [grayImage lockFocus];
    
    //2. 흑백 필터를 사용해 변환
    CIImage *ciImage = [[CIImage alloc] initWithData:[image TIFFRepresentation]];
    //CIFilter *grayFilter = [CIFilter filterWithName:@"CIColorControls"];
    CIFilter *grayFilter = [CIFilter filterWithName:@"CIColorControls"];
    [grayFilter setValue:ciImage forKey:kCIInputImageKey];
    [grayFilter setValue:@0 forKey:@"inputSaturation"]; // 채도를 0으로 설정하여 흑백 처리
    
    CIImage *outputImage = [grayFilter valueForKey:kCIOutputImageKey];
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:outputImage];
    NSImage *finalGrayImage = [[NSImage alloc] initWithSize:imageSize];
    
    [finalGrayImage addRepresentation:rep];
    
    [finalGrayImage drawAtPoint:NSZeroPoint
                       fromRect:NSMakeRect(0, 0, imageSize.width, imageSize.height)
                      operation:NSCompositingOperationCopy
                       fraction:1.0];
    
    [grayImage unlockFocus];
    
    return grayImage;
}



- (IBAction)onBtnImageRotateCCW:(id)sender {
    
    // 현재 이미지 가져오기
        NSImage *image = self.imageViewer.image;
        if (!image) {
            NSLog(@"이미지가 없습니다.");
            return;
        }
        
        // 새로운 회전된 이미지를 생성
        NSImage *rotatedImage = [[NSImage alloc] initWithSize:NSMakeSize(image.size.height, image.size.width)];
        
        [rotatedImage lockFocus]; // 이미지를 그리기 위해 잠금
        
        NSAffineTransform *transform = [NSAffineTransform transform];
        [transform translateXBy:image.size.height / 2 yBy:image.size.width / 2]; // 중심점으로 이동
        [transform rotateByDegrees:-90]; // 반시계 방향으로 90도 회전
        [transform translateXBy:-image.size.width / 2 yBy:-image.size.height / 2]; // 원래 좌표로 이동
        [transform concat]; // 변환 적용
        
        [image drawAtPoint:NSZeroPoint fromRect:NSMakeRect(0, 0, image.size.width, image.size.height) operation:NSCompositingOperationCopy fraction:1.0];
        [rotatedImage unlockFocus]; // 잠금 해제
        
        // 회전된 이미지를 이미지 뷰에 설정
        self.imageViewer.image = rotatedImage;
    
}

- (IBAction)onBtnImageRotateCW:(id)sender {
    
    //NSLog(@"")
    // 현재 이미지 가져오기
        NSImage *image = self.imageViewer.image;
        if (!image) {
            NSLog(@"이미지가 없습니다.");
            return;
        }
        
        // 새로운 회전된 이미지를 생성
        NSImage *rotatedImage = [[NSImage alloc] initWithSize:NSMakeSize(image.size.height, image.size.width)];
        
        [rotatedImage lockFocus]; // 이미지를 그리기 위해 잠금
        
        NSAffineTransform *transform = [NSAffineTransform transform];
        [transform translateXBy:image.size.height / 2 yBy:image.size.width / 2]; // 중심점으로 이동
        [transform rotateByDegrees:90]; // 시계 방향으로 90도 회전
        [transform translateXBy:-image.size.width / 2 yBy:-image.size.height / 2]; // 원래 좌표로 이동
        [transform concat]; // 변환 적용
        
        [image drawAtPoint:NSZeroPoint fromRect:NSMakeRect(0, 0, image.size.width, image.size.height) operation:NSCompositingOperationCopy fraction:1.0];
        [rotatedImage unlockFocus]; // 잠금 해제
        
        // 회전된 이미지를 이미지 뷰에 설정
        self.imageViewer.image = rotatedImage;
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
