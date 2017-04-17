//
//  CharacterCell.m
//  Marvel Heroes
//
//  Created by Andre Campos on 17/04/17.
//  Copyright © 2017 Andre Campos. All rights reserved.
//

#import "CharacterCell.h"
#import "DAOCharacter.h"

@implementation CharacterCell{
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithCharacter:(DAOCharacter *)character{
	_character = character;
	
	if (_character) {
		_lblName.text = _character.nameCharacter;
		_lblDesc.text = _character.descriptionCharacter;

		[self setImageCharacter];
	}
}

- (void)setImageCharacter{
	_imgChar.image = nil;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		int myID = _character.idCharacter.intValue;
		NSString *urlString = [NSString stringWithFormat:@"%@.%@",_character.thumbnailPath, _character.thumbnailExtension];
		NSURL *imageURL = [NSURL URLWithString:urlString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
					   
        //This is your completion handler
        dispatch_sync(dispatch_get_main_queue(), ^{
			if (_character.idCharacter.intValue == myID) {
				UIImage *image = [UIImage imageWithData:imageData];
				
				NSData *imageData = UIImageJPEGRepresentation(image, 0.3f);
				
				_imgChar.image = [UIImage imageWithData:imageData];
			}
		});
	});
	
}

-(void)setImageInCharacter{
	_character.image = _imgChar.image;
}
@end
