//
//  HomeCollectionViewCell.h
//  Kmanager
//
//  Created by Khánh on 12/02/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (strong, nonatomic) NSString *strTenNhanVien;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *dateofbirth;


@end
