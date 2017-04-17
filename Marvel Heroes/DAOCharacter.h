//
//  DAOComics.h
//  Marvel Heroes
//
//  Created by Andre Campos on 12/04/17.
//  Copyright © 2017 Andre Campos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DAOCharacter : NSObject

//@property (nonatomic, weak) NSArray *

@property (nonatomic) NSString *idCharacter;

@property (nonatomic) NSString *nameCharacter;

@property (nonatomic) NSString *descriptionCharacter;

@property (nonatomic) NSString *thumbnailPath;

@property (nonatomic) NSString *thumbnailExtension;

@property (nonatomic) NSString *urlDetails;

@property (nonatomic) int comics;

@property (nonatomic) int events;

@property (nonatomic) int series;

@property (nonatomic) int stories;


@property (nonatomic) UIImage *image;

- (instancetype)initFromDictionary:(NSDictionary *)dic;

@end
