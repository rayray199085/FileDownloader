//
//  SCFileDownloaderManager.h
//  HTTP13
//
//  Created by Stephen Cao on 13/3/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCFileDownloader.h"
NS_ASSUME_NONNULL_BEGIN

@interface SCFileDownloaderManager : NSObject
+(instancetype)defaultManager;
-(void)downloadWithUrlString:(NSString *)path WithProcess:(void(^)(float percentage))process andWithSucess:(void(^)(NSString * urlStr))success andWithError:(void(^)(NSError *error))error;
-(void)pauseDownloadProcessWithUrlStr:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
