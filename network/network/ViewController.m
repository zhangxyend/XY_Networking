//
//  ViewController.m
//  network
//
//  Created by Yulin Zhao on 2018/11/15.
//  Copyright © 2018年 Yulin Zhao. All rights reserved.
//

#import "ViewController.h"
#import "BaseNetworking.h"
#import "XY_Networking.h"
#import "FileObject.h"
#import "BaseNetworking.h"
@interface ViewController ()<XY_NetworkingDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XY_Networking * network = [XY_Networking instance];
    NSMutableArray * arr = [NSMutableArray array];
    NSArray * array = @[@"640-960-w.png",@"640-1136-w.png",@"1242-2208-w.png",@"1125-2436-w.png",@"750-1334-w.png"];
    for (NSString * key in array) {
        UIImage * image = [UIImage imageNamed:key];
        NSData * data = UIImagePNGRepresentation(image);
        FileObject * fileObject =  [[FileObject alloc]init];
        fileObject.data = data;
        fileObject.name = @"smfile";
        fileObject.fileName = key;
        fileObject.mimeType = @"image/png";
        [arr addObject:fileObject];
    }
    
    [network setHttpHeader:@{@"cookie":@"cid=Pe6LyFvuND9i/F9pBlcDAg==; PHPSESSID=2e3q9uem0bq7g8iida38sift5i"}];
//上传一组图片
[network UploadWithUrl:@"https://sm.ms/api/upload?inajax=1&ssl=1" parameters:@{@"file_id":@"0"} fileArray:[arr copy] ];
    
//上传单张图片
//    UIImage * image = [UIImage imageNamed:@"640-960-w.png"];
//    NSData * data = UIImagePNGRepresentation(image);
//    [network UploadWithUrl:@"https://sm.ms/api/upload?inajax=1&ssl=1" parameters:@{@"file_id":@"0"} data:data name:@"smfile" fileName:@"640-960-w.png" mimeType:@"image/png"];
    network.delegate = self;
    
    
}
-(void)getTaskResult:(id)result{
    NSLog(@"%@",result);
    NSLog(@"%@",result[@"error"]);
}

-(void)getError:(NSError *)error{
    NSLog(@"%@--%d",error.localizedDescription,1);
}

-(void)getProgress:(CGFloat)progress{
    NSLog(@"%f",progress);
}

-(void)uploadFileError:(NSError *)error index:(int)index{
    NSLog(@"%@--%d",error,index);
}
-(void)uploadFileResult:(id)result index:(int)index{
      NSLog(@"%@--%d",result,index);
}
-(void)uploadFileProgress:(CGFloat)progress index:(int)index{
    // NSLog(@"%f--%d",progress,index);
}
@end
