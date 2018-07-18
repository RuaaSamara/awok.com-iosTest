//
//  HomeCollectionViewCell.h
//  IosTest
//
//  Copyright © 2018 Ruaa Samara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *homeImageViewCell;
@property (weak, nonatomic) IBOutlet UILabel *homeCellName;
@property (weak, nonatomic) IBOutlet UILabel *homeCellOldPrice;
@property (weak, nonatomic) IBOutlet UILabel *homeCellNewPrice;
@property (weak, nonatomic) IBOutlet UIButton *homeCellState;

@end
