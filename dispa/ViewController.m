//
//  ViewController.m
//  dispa
//
//  Created by Ahmed Adel  on 6/28/16.
//  Copyright © 2016 Ahmed Adel . All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlText;
@property (weak, nonatomic) IBOutlet UITextField *verbText;
@property (weak, nonatomic) IBOutlet UITextField *parametersText;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITextField *imageUrlText;
@property (weak, nonatomic) IBOutlet UITextView *responseText;
@property (strong, nonatomic) dispatch_queue_t serialQueue;

@property NSString *responseString;

@end


@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    _activity.hidden = true;
    _serialQueue = dispatch_queue_create("com.blah.queue", DISPATCH_QUEUE_SERIAL);
}

- (IBAction)sendRequest:(id)sender {
    
    if ( ![_urlText.text  isEqual: @""] && ![_verbText.text  isEqual: @""] && ![_parametersText.text  isEqual: @""]) {
        
        NSDictionary *params = @{@"firstname": @"John", @"lastname": @"Doe"};
        NSString *verb = _verbText.text;
        NSURL *url = [NSURL URLWithString:_urlText.text];
        [self requestWithURL:(NSURL*)url withVerb:(NSString*)verb withParams:(NSDictionary*)params];
        _urlText.text = @"";
        _verbText.text = @"";
        _parametersText.text = @"";
    }
    
}
- (IBAction)downloadImage:(id)sender {
    
    if ( ![_imageUrlText.text  isEqual: @""]) {
        _activity.hidden = false;
        
        dispatch_async(_serialQueue, ^{
            NSString *imageUrl = _imageUrlText.text;
            
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
            
            if ( data == nil )
                return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _image1.image = [UIImage imageWithData: data];
                _activity.hidden = true;
                _imageUrlText.text = @"";
                
            });
        });
    }
}


- (void)requestWithURL:(NSURL*)url withVerb:(NSString*)verb withParams:(NSDictionary*)params{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:verb];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    request.HTTPBody = jsonData;
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    dispatch_async(_serialQueue, ^{
        [connection start];
    });
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    NSString *stringFromData = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", stringFromData);
    
    
    _responseText.text = [_responseText.text stringByAppendingString: stringFromData];
    _responseText.text = [_responseText.text stringByAppendingString: @"///////////////////////////NEXT_REQUEST//////////////////////////////"];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // There was an error!!
    NSLog(@"%@", error);
    if (error) {
        _responseText.text = [_responseText.text stringByAppendingString: error.description];
        _responseText.text = [_responseText.text stringByAppendingString: @"//////////////////////////NEXT_REQUEST//////////////////////////////"];
        
    }
    
}

@end
