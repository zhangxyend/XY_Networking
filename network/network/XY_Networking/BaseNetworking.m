//
//  BaseNetworking.m
//  network
//
//  Created by Yulin Zhao on 2018/11/15.
//  Copyright © 2018年 Yulin Zhao. All rights reserved.
//

#import "BaseNetworking.h"
@interface BaseNetworking ()
@property(nonatomic,strong)NSMutableArray * tasks;
@property(nonatomic,strong) AFHTTPSessionManager * manager;
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@end
@implementation BaseNetworking
static BaseNetworking * baseNetworking;

+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!baseNetworking) {
            baseNetworking = [[self alloc]init];
        }
    });
    return baseNetworking;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!baseNetworking) {
            baseNetworking = [super allocWithZone:zone];
        }
    });
    return baseNetworking;
}

-(instancetype)init{
    if (!_tasks) {
         _tasks = [NSMutableArray array];
    }
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.requestSerializer.timeoutInterval = 20;
    //更改响应默认的解析方式为字符串解析
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
   
    return baseNetworking;
}
//设置请求头
-(void)setHttpHeader:(NSDictionary*)dic{
    for (NSString * key  in dic) {
         [_manager.requestSerializer setValue:[dic objectForKey:key] forHTTPHeaderField:key];
    }
}
//GET
-(void)getUrl:(NSString *)url parameters:(id)parameters getSuccess:(void(^)(id responseObject))getSuccess getFailure:(void(^)(NSError* error))getFailure{
     __weak typeof(self) weakself = self;
   
   
  NSURLSessionDataTask * task = [_manager GET:url parameters:parameters progress:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      [weakself.tasks removeObject:task];
      if (getSuccess) {
          getSuccess(responseObject);
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     [weakself.tasks removeObject:task];
        if (getFailure) {
            getFailure(error);
        }
     
    }];
    [weakself.tasks addObject:task];
}

//POST
-(void)postUrl:(NSString *)url parameters:(id)parameters postSuccess:(void(^)(id responseObject))postSuccess postFailure:(void(^)(NSError* error))postFailure{
     __weak typeof(self) weakself = self;
    
  NSURLSessionDataTask * task = [_manager POST:url parameters:parameters progress:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
       [weakself.tasks removeObject:task];
      if (postSuccess) {
          postSuccess(responseObject);
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself.tasks removeObject:task];
        if (postFailure) {
            postFailure(error);
        }
    }];
      [weakself.tasks addObject:task];
}
//上传文件
-(void)uploadUrl:(NSString *)url parameters:(id)parameters constructingBodyWithBlock:(void(^)(id<AFMultipartFormData>  _Nonnull formData))constructingBodyWithBlock  currentProgress:(void(^)(CGFloat progress))currentProgress  uploadSuccess:(void(^)(id responseObject))uploadSuccess uploadFailure:(void(^)(NSError* error))uploadFailure{
     __weak typeof(self) weakself = self;
    
  NSURLSessionDataTask * task = [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      constructingBodyWithBlock(formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (currentProgress) {
            currentProgress(uploadProgress.completedUnitCount*1.0/uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [weakself.tasks removeObject:task];
        if (uploadSuccess) {
            uploadSuccess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [weakself.tasks removeObject:task];
        if (uploadFailure) {
            uploadFailure(error);
        }
    }];
      [weakself.tasks addObject:task];
}

-(void)downloadTaskWithUrl:(NSString*)url parameters:(id)parameters currentProgress:(void(^)(CGFloat progress))currentProgress downloadSuccess:(void(^)(id responseObject))downloadSuccess downloadFailure:(void(^)(NSError* error))downloadFailure{
    
  __weak typeof(self) weakself = self;
  __block NSURLSessionDownloadTask *task =  [_manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:^(NSProgress * _Nonnull downloadProgress) {
      if (currentProgress) {
          currentProgress(downloadProgress.completedUnitCount*1.0/downloadProgress.totalUnitCount);
      }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //拼接文件全路径
        NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *filePathUrl = [NSURL fileURLWithPath:fullpath];
        return filePathUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (downloadSuccess) {
            downloadSuccess([filePath path]);
        }
        
        if (downloadFailure) {
            downloadFailure(error);
        }
        
        [weakself.tasks removeObject:task];
    }];
    [task resume];
    [weakself.tasks addObject:task];
    _downloadTask = task;
    
}
//开始
-(void)downloadResume{
     if (_downloadTask) {
    [_downloadTask resume];
     }
}
//挂起
-(void)downloadSuspend{
    if (_downloadTask) {
    [_downloadTask suspend];
    }
}
//取消
-(void)downloadCancel{
    if (_downloadTask) {
        [_downloadTask cancel];
    }
}

//取消所有任务
-(void)cancelAllTask{
    for (NSURLSessionDataTask * task  in _tasks) {
        [task cancel];
    }
}
@end
