//
//  ViewController.m
//  测试上传图片
//
//  Created by 施斌 on 2018/2/7.
//  Copyright © 2018年 施斌. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    /*
     Content-type: multipart/form-data, boundary=AaB03x
     */
    
    /*
     上传格图片格式： name就是后台给的名字，类似于form表单中<input name="field1" type="img" />
     --AaB03x
     Content-Disposition: form-data; name="file"; filename="currentImage.png"
     Content-Type: image/png
     */
    
    /*
     上传格其他参数格式：
     --AaB03x
     Content-Disposition: form-data; name="字段名"
     Hello 哈哈哈哈
     */
    
    /*
     最后需要一个结束符
     --AaB03x--
     */
    
    
    /*
     Content-type: multipart/form-data, boundary=AaB03x
     Content-Length: 123123123
     
     --AaB03x
     Content-Disposition: form-data; name="file"; filename="currentImage1.png"
     Content-Type: image/png
     这里是图片流图片流图片流图片流图片流图片流图片流图片流图片流图片流
     
     --AaB03x
     Content-Disposition: form-data; name="file"; filename="currentImage2.png"
     Content-Type: image/png
     这里是图片流图片流图片流图片流图片流图片流图片流图片流图片流图片流
     
     --AaB03x--
     
     */

    
    //https://mobileapi-preview.ebowin.com/jsdoctor-mobile-api/common/image/upload
    

    NSString *url = @"测试地址";

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:30];
    request.HTTPMethod = @"POST";
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    
   
    NSMutableArray<UIImage *> *list = @[[UIImage imageNamed:@"icon_20"],[UIImage imageNamed:@"icon_20"]].mutableCopy;
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    for (NSInteger i = 0; i<list.count; i++) {
        NSMutableString *bodyStr = [[NSMutableString alloc]init];
        UIImage *image = list[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.000001);
        //添加分界线，换行
        [bodyStr appendFormat:@"%@\r\n",MPboundary];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
        [bodyStr appendFormat:@"%@", [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filename\"; filename=\"%@\"\r\n",fileName]];
        //声明上传文件的格式
        [bodyStr appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
        //将body字符串转化为UTF8格式的二进制
        NSLog(@"%@",bodyStr);
        [myRequestData appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:imageData];
        //换行
        [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //声明结束符：--AaB03x--
    NSString * end = [[NSString alloc]initWithFormat:@"%@",endMPboundary];
    //    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

    
    
    
    
    /*
     Content-type:multipart/form-data; boundary=AaB03x
     */
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //网络请求失败
        if (error != nil) {
            return;
        }
        //成功进行解析
        NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@--%@",dic, response);
    }];
    
    [task resume];
    
    
}




@end
