#import "OpenFilePlugin.h"


static NSString *const CHANNEL_NAME = @"open_file";

@implementation OpenFilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:CHANNEL_NAME
                                     binaryMessenger:[registrar messenger]];
    UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    OpenFilePlugin* instance = [[OpenFilePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"open_file" isEqualToString:call.method]) {
        NSString *msg = call.arguments[@"file_path"];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        BOOL fileExist=[fileManager fileExistsAtPath:msg];
        if(fileExist){
//            NSURL *resourceToOpen = [NSURL fileURLWithPath:msg];
            NSString *exestr = [msg pathExtension];
            UIDocumentInteractionController* documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:msg]];
            documentController.delegate=[UIApplication sharedApplication].delegate.window.rootViewController.transitioningDelegate;
            if([exestr isEqualToString:@"rtf"]){
                documentController.UTI=@"public.rtf";
            }else if([exestr isEqualToString:@"txt"]){
                documentController.UTI=@"public.plain-text";
            }else if([exestr isEqualToString:@"html"]||
                     [exestr isEqualToString:@"htm"]){
                documentController.UTI=@"public.html";
            }else if([exestr isEqualToString:@"xml"]){
                documentController.UTI=@"public.xml";
            }else if([exestr isEqualToString:@"tar"]){
                documentController.UTI=@"public.tar-archive";
            }else if([exestr isEqualToString:@"gz"]||
                     [exestr isEqualToString:@"gzip"]){
                documentController.UTI=@"org.gnu.gnu-zip-archive";
            }else if([exestr isEqualToString:@"tgz"]){
                documentController.UTI=@"org.gnu.gnu-zip-tar-archive";
            }else if([exestr isEqualToString:@"jpg"]||
                     [exestr isEqualToString:@"jpeg"]){
                documentController.UTI=@"public.jpeg";
            }else if([exestr isEqualToString:@"png"]){
                documentController.UTI=@"public.png";
            }else if([exestr isEqualToString:@"avi"]){
                documentController.UTI=@"public.avi";
            }else if([exestr isEqualToString:@"mpg"]||
                     [exestr isEqualToString:@"mpeg"]){
                documentController.UTI=@"public.mpeg";
            }else if([exestr isEqualToString:@"mp4"]){
                documentController.UTI=@"public.mpeg-4";
            }else if([exestr isEqualToString:@"3gpp"]||
                     [exestr isEqualToString:@"3gp"]){
                documentController.UTI=@"public.3gpp";
            }else if([exestr isEqualToString:@"mp3"]){
                documentController.UTI=@"public.mp3";
            }else if([exestr isEqualToString:@"zip"]){
                documentController.UTI=@"com.pkware.zip-archive";
            }else if([exestr isEqualToString:@"gif"]){
                documentController.UTI=@"com.compuserve.gif";
            }else if([exestr isEqualToString:@"bmp"]){
                documentController.UTI=@"com.microsoft.bmp";
            }else if([exestr isEqualToString:@"ico"]){
                documentController.UTI=@"com.microsoft.ico";
            }else if([exestr isEqualToString:@"doc"]){
                documentController.UTI=@"com.microsoft.word.doc";
            }else if([exestr isEqualToString:@"xls"]){
                documentController.UTI=@"com.microsoft.excel.xls";
            }else if([exestr isEqualToString:@"ppt"]){
                documentController.UTI=@"com.microsoft.powerpoint.​ppt";
            }else if([exestr isEqualToString:@"wav"]){
                documentController.UTI=@"com.microsoft.waveform-​audio";
            }else if([exestr isEqualToString:@"wm"]){
                documentController.UTI=@"com.microsoft.windows-​media-wm";
            }else if([exestr isEqualToString:@"wmv"]){
                documentController.UTI=@"com.microsoft.windows-​media-wmv";
            }else if([exestr isEqualToString:@"pdf"]){
                documentController.UTI=@"com.adobe.pdf";
            }
            [documentController presentOpenInMenuFromRect:CGRectMake(500,20,100,100) inView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:YES];
            
            result(@"done");
            
        }else{
            result(@"the file is not exist");
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}


@end
