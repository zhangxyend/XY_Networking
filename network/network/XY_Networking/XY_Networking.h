//
//  XY_Networking.h
//  network
//
//  Created by Yulin Zhao on 2018/11/15.
//  Copyright © 2018年 Yulin Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  FileObject;
@protocol XY_NetworkingDelegate <NSObject>

@required
-(void)getTaskResult:(id)result ;//获取网络任务结果

@optional
-(void)getError:(NSError*)error ;//获取网络任务错误信息

-(void)getProgress:(CGFloat)progress;//获取网络任务进度

-(void)uploadFileResult:(id)result index:(int)index;//获取网络任务结果

-(void)uploadFileError:(NSError*)error index:(int)index;//获取网络任务错误信息

-(void)uploadFileProgress:(CGFloat)progress index:(int)index;//获取网络任务进度

@end
@interface XY_Networking : NSObject
/*
 *初始化
 */
+(instancetype)instance;
/*
 *设置请求头
 */
-(void)setHttpHeader:(NSDictionary*)dic;
/*
 *GET
 *get请求
 */
-(void)GetWithUrl:(NSString *)url parameters:(id)parameters;
/*
 *POST
 *post请求
 */
-(void)PostWithUrl:(NSString *)url parameters:(id)parameters;
/*
 *UPLOAD
 *上传文件
 */
-(void)UploadWithUrl:(NSString *)url parameters:(id)parameters data:(NSData*)data name:(NSString*)name fileName:(NSString *)fileName mimeType:(NSString*)mimeType;

/*
 *UPLOAD
 *上传批量文件:分批次上传,可以返回对应文件信息及进度
 */

-(void)UploadWithUrl:(NSString *)url parameters:(id)parameters fileArray:(NSArray<FileObject *>*)fileArray;


/*
 *UPLOAD
 *上传批量文件:一次性上传批量文件，只返回一次结果
 */
-(void)UploadOnceReturnWithUrl:(NSString *)url parameters:(id)parameters fileArray:(NSArray<FileObject *>*)fileArray;

/*
 *UPLOAD
 *下载文件
 */
-(void)downloadTaskWithUrl:(NSString*)url parameters:(id)parameters;

/*
 *CANCELall
 *取消所有任务
 */
-(void)cancelAllTask;

/*
 *Resume
 *开始下载任务
 */
-(void)downloadResume;

/*
 *Suspend
 *挂起下载任务
 */
-(void)downloadSuspend;

/*
 *CANCEL
 *取消下载任务
 */
-(void)downloadCancel;

@property(nonatomic,weak)id<XY_NetworkingDelegate> delegate;//网络回调代理

@end
