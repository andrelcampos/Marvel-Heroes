//
//  CharacterCell.h
//  Marvel Heroes
//
//  Created by Andre Campos on 17/04/17.
//  Copyright © 2017 Andre Campos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAOCharacter;

@interface CharacterCell : UITableViewCell{
	__weak IBOutlet UILabel *_lblName, *_lblDesc;
	__weak IBOutlet UIImageView *_imgChar;
}

@property (nonatomic) DAOCharacter *character;

- (void)setCellWithCharacter:(DAOCharacter *)character;

- (void)setImageInCharacter;

@end
