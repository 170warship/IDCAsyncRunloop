在项目中，有时手势滑动的时候，如果执行了其它操作，会有卡顿感的感觉，如果能在手势滑动时，不作处理，等到滑动完成后，在回调，卡顿感会好些, 详情请看代码。



调用方法，

1 ：在Appdelegate中的didFinishLaunchingWithOptions调用：

[IDCAsyncRunloop registerInMainRunloopObserver];



2：正式的调用示例，如在ASIHttpRequest框架中，请求数据

// 3.创建操作对象
AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [IDCAsyncRunloop addTransactionContainer:^{
        //在这里处理responseObject数据
    }];


.........


