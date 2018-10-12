//
//  IDCAsyncRunloop.m
//  爱豆
//
//  Created by idol_ios on 2018/3/2.
//  Copyright © 2018年 idol_ios. All rights reserved.
//

#import "IDCAsyncRunloop.h"


/*
+ (void)registerTransactionGroupAsMainRunloopObserver:(_ASAsyncTransactionGroup *)transactionGroup
{
    ASDisplayNodeAssertMainThread();
    static CFRunLoopObserverRef observer;
    ASDisplayNodeAssert(observer == NULL, @"A _ASAsyncTransactionGroup should not be registered on the main runloop twice");
    // defer the commit of the transaction so we can add more during the current runloop iteration
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFOptionFlags activities = (kCFRunLoopBeforeWaiting | // before the run loop starts sleeping
                                kCFRunLoopExit);          // before exiting a runloop run
    CFRunLoopObserverContext context = {
        0,           // version
        (__bridge void *)transactionGroup,  // info
        &CFRetain,   // retain
        &CFRelease,  // release
        NULL         // copyDescription
    };
    
    observer = CFRunLoopObserverCreate(NULL,        // allocator
                                       activities,  // activities
                                       YES,         // repeats
                                       INT_MAX,     // order after CA transaction commits
                                       &_transactionGroupRunLoopObserverCallback,  // callback
                                       &context);   // context
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}
*/


 
@implementation IDCAsyncRunloop{
    
}

static NSHashTable* sContainerFuns = nil;

+ (NSHashTable*)containerFuns{
    return sContainerFuns;
}

static void _transactionRunLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    @synchronized([IDCAsyncRunloop class]) {
        for (void (^block)() in [IDCAsyncRunloop containerFuns]) {
            if (block) {
                block();
            }
        }
        
        [[IDCAsyncRunloop containerFuns] removeAllObjects];
    }
}

//记得调用这个方法时，不能在主线程，不然在_transactionRunLoopObserverCallback在主线程调用，会有死锁
+ (void)addTransactionContainer:(void (^)())block
{
    @synchronized(self) {
        if (sContainerFuns == nil) {
            sContainerFuns = [NSHashTable hashTableWithOptions:NSPointerFunctionsObjectPointerPersonality];
        }
        
        [sContainerFuns addObject:block];
    }
}



+(void)registerInMainRunloopObserver{
    
    static CFRunLoopObserverRef observer;
    
    NSAssert([NSThread isMainThread], @"[IDCAsyncRunloop registerInMainRunloopObserver] must be used in main thread.");
    
    // defer the commit of the transaction so we can add more during the current runloop iteration
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFOptionFlags activities = (kCFRunLoopBeforeWaiting | // before the run loop starts sleeping
                                kCFRunLoopExit);          // before exiting a runloop run
    CFRunLoopObserverContext context = {
        0,           // version
        NULL,  // info
        NULL,
        NULL
    };
    
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,        // allocator
                                       activities,  // activities
                                       YES,         // repeats
                                       INT_MAX,     // order after CA transaction commits
                                       &_transactionRunLoopObserverCallback,  // callback
                                       &context);   // context
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopDefaultMode);
    
    
    
}

@end
