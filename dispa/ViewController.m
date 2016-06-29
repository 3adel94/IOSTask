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

@property (weak, nonatomic) IBOutlet UITextView *responseText;



@end


@implementation ViewController

- (IBAction)startDown:(id)sender {
    
    if ( ![_urlText.text  isEqual: @""] && ![_verbText.text  isEqual: @""] && ![_parametersText.text  isEqual: @""]) {
        
        printf("start");
        
        
        NSDictionary *params = @{@"firstname": @"John", @"lastname": @"Doe"};
        NSString *verb = _verbText.text;
        NSURL *url = [NSURL URLWithString:@"http://jsonplaceholder.typicode.com/posts"];
        [self requestWithURL:(NSURL*)url withVerb:(NSString*)verb withParams:(NSDictionary*)params];
        
        
    }
 
}


- (void)requestWithURL:(NSURL*)url withVerb:(NSString*)verb withParams:(NSDictionary*)params{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:verb];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    
    request.HTTPBody = jsonData;
    
    NSLog(@"%@", request);
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];

    dispatch_queue_t serialQueue = dispatch_queue_create("com.blah.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        [connection start];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSString *stringFromData = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        NSArray *eachLineOfString = [stringFromData componentsSeparatedByString:@"\n"];
        for (NSString *line in eachLineOfString) {
            // DO SOMETHING WITH THIS LINE
            NSLog(@"%@", line);
//            _urlText.text = @"";
//            _verbText.text = @"";
//            _parametersText.text = @"";
        }
            _responseText.text = stringFromData;

//    });
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@", error);
    if (error) {
        _responseText.text = error.description;

    }

}




    

    
    //    dispatch_queue_t serialQueue = dispatch_queue_create("com.blah.queue", DISPATCH_QUEUE_SERIAL);
    //
    //    dispatch_async(serialQueue, ^{
    //
    //        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg"]];
    //        printf("1");
    //
    //        if ( data == nil )
    //            return;
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            _img1.image = [UIImage imageWithData: data];
    //            printf("one done");
    //        });
    //    });
    //
    //
    //
    //
    //    dispatch_async(serialQueue, ^{
    //        //block2
    //        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg"]];
    //        printf("2");
    //
    //        if ( data == nil )
    //            return;
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            _img2.image = [UIImage imageWithData: data];
    //            printf("two done");
    //
    //        });
    //    });
    //
    //    dispatch_async(serialQueue, ^{
    //
    //
    //        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://algoos.com/wp-content/uploads/2015/08/ireland-02.jpg"]];
    //        printf("3");
    //
    //        if ( data == nil )
    //            return;
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            _img3.image = [UIImage imageWithData: data];
    //            printf("three done");
    //        });
    //    });
    //
    //    dispatch_async(serialQueue, ^{
    //
    //        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://bdo.se/wp-content/uploads/2014/01/Stockholm1.jpg"]];
    //        printf("4");
    //
    //        if ( data == nil )
    //            return;
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            _img4.image = [UIImage imageWithData: data];
    //            printf("four done");
    //            _act.hidden = true;
    //
    //        });
    //    });
    
    


@end
