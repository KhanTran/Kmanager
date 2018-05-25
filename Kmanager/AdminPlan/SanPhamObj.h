//
//  SanPhamObj.h
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SanPhamObj : NSObject
@property(strong,nonatomic)NSString * idSanPham;
@property(strong,nonatomic)NSString * tenSanPham;
@property(strong,nonatomic)NSString * modelSanPham;
@property(strong,nonatomic)NSString * soLuong;
@property(nonatomic)BOOL isCheck;

@end
