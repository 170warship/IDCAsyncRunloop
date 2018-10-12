//
//  IDCAsyncRunloop.h
//  爱豆
//
//  Created by idol_ios on 2018/3/2.
//  Copyright © 2018年 idol_ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCAsyncRunloop : NSObject
+ (void)registerInMainRunloopObserver;
+ (void)addTransactionContainer:(void (^)())block;
@end
