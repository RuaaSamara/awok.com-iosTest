//
//  ViewController.m
//  IosTest
//
//  Copyright © 2018 Ruaa Samara. All rights reserved.
//

#import "ViewController.h"
#import "HomeCollectionViewCell.h"
#import "FlashCollectionViewCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *flashCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *homeCollectionView;
@property (strong, nonatomic) NSArray *flashItems;
@property (strong, nonatomic) NSArray *homeItems;

@end

@implementation ViewController
int flag;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeCollectionView.delegate = self;
    self.flashCollectionView.delegate = self;
    self.homeCollectionView.dataSource = self;
    self.flashCollectionView.dataSource = self;
    [self connect];
}

- (void) connect{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableURLRequest *flashRequest = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.awok.com/api/home/?apilang=en&App-Version=1832"]];
    [request setHTTPMethod:@"GET"];
    [flashRequest setURL:[NSURL URLWithString:@"http://www.awok.com/api/flash/?apilang=en&App-Version=1832"]];
    [flashRequest setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (data == nil) {
                                          [self printCannotLoad];
                                      } else {
                                          [self parseJSON:data];
                                      }
                                  }];
    [task resume];
    NSURLSession *flashSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *flashTask = [flashSession dataTaskWithRequest:flashRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (data == nil) {
                                          [self printCannotLoad];
                                      } else {
                                          [self parseFlashJSON:data];
                                      }
                                      
                                  }];
    [flashTask resume];
}
- (void) parseJSON:(NSData *) jsonData {
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:jsonData
                 options:0
                 error:&error];
    
    if(error) {
        [self printCannotLoad];
        return;
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *output = [object valueForKey:@"OUTPUT"];
        NSDictionary *data = [output valueForKey:@"DATA"];
        self.homeItems = [data valueForKey:@"ITEMS"];
        dispatch_async(dispatch_get_main_queue(), ^{
            flag = 0;
            [self.homeCollectionView reloadData];
        });
    } else {
        
    }
}
- (void) parseFlashJSON:(NSData *) jsonData {
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:jsonData
                 options:0
                 error:&error];
    
    if(error) {
        [self printCannotLoad];
        return;
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *output = [object valueForKey:@"OUTPUT"];
        NSDictionary *data = [output valueForKey:@"DATA"];
        self.flashItems = [data valueForKey:@"ITEMS"];
        dispatch_async(dispatch_get_main_queue(), ^{
            flag = 1;
            [self.flashCollectionView reloadData];
        
        });
    } else {
        
    }
}

- (void) printCannotLoad {
    dispatch_async(dispatch_get_main_queue(), ^{
        //valueLabel.text = @"cannot load";
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.homeCollectionView){
        return self.homeItems.count;
    }
    return self.flashItems.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // get the object
    if(collectionView == self.homeCollectionView){
        NSDictionary *item = [self.homeItems objectAtIndex:indexPath.row];
        static NSString *cellIdentifier = @"homeCell";
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        // populate the cell
        NSDictionary *image = [item valueForKey:@"IMAGE"];
        NSString *imgSrc = [image valueForKey:@"SRC"];
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgSrc]];
        NSDictionary *prices = [item valueForKey:@"PRICES"];
        NSString *oldPriceString = [NSString stringWithFormat:@"%@", [prices valueForKey:@"PRICE_OLD"]];
        NSString *newPriceString = [NSString stringWithFormat:@"%@", [prices valueForKey:@"PRICE_NEW"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.homeCellName.text = [item valueForKey:@"NAME"];
            cell.homeCellOldPrice.text = [oldPriceString stringByAppendingString:@" AED"];
            cell.homeCellNewPrice.text = [newPriceString stringByAppendingString:@" AED"];
            cell.homeImageViewCell.image = [UIImage imageWithData: data];
        });
        return cell;
    }else{
        NSDictionary *item = [self.flashItems objectAtIndex:indexPath.row];
        static NSString *cellIdentifier = @"flashCell";
        FlashCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        // populate the cell
        NSDictionary *image = [item valueForKey:@"IMAGE"];
        NSString *imgSrc = [image valueForKey:@"SRC"];
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgSrc]];
        NSDictionary *prices = [item valueForKey:@"PRICES"];
        NSString *oldPriceString = [NSString stringWithFormat:@"%@", [prices valueForKey:@"PRICE_OLD"]];
        NSString *newPriceString = [NSString stringWithFormat:@"%@", [prices valueForKey:@"PRICE_NEW"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.flashItemName.text = [item valueForKey:@"NAME"];
            cell.flashItemOldPrice.text = [oldPriceString stringByAppendingString:@" AED"];
            cell.flashItemNewPrice.text = [newPriceString stringByAppendingString:@" AED"];
            cell.flashItemImage.image = [UIImage imageWithData: data];
        });
         return cell;
    }
    
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selected = [self.flashItems objectAtIndex:indexPath.row];
    NSLog(@"selected=%@", selected);
}
- (IBAction)flashAddToCartButton:(id)sender {
    
}
- (IBAction)homeAddToCartButton:(id)sender {
}



@end
