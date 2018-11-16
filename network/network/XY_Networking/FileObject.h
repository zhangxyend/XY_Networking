//
//  FileObject.h
//  network
//
//  Created by Yulin Zhao on 2018/11/15.
//  Copyright © 2018年 Yulin Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileObject : NSObject
@property(nonatomic,strong)NSData * data;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * fileName;
@property(nonatomic,strong)NSString * mimeType;
@end
