//
//  FlashCollectionViewCell.h
//  IosTest
//
//  Copyright © 2018 Ruaa Samara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *flashItemImage;
@property (weak, nonatomic) IBOutlet UILabel *flashItemName;
@property (weak, nonatomic) IBOutlet UILabel *flashItemOldPrice;
@property (weak, nonatomic) IBOutlet UIButton *flashItemAddToCartBtn;
@property (weak, nonatomic) IBOutlet UILabel *flashItemNewPrice;


@end
