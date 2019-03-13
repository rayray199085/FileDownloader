//
//  SCFileDownloader.h
//  HTTP13
//
//  Created by Stephen Cao on 13/3/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCFileDownloader : NSOperation
+(instancetype)downloaderWithUrlString:(NSString *)path WithProcess:(void(^)(float percentage))process andWithSucess:(void(^)(NSString * urlStr))success andWithError:(void(^)(NSError *error))error;
-(void)pauseDownloadProcess;
@end

NS_ASSUME_NONNULL_END
