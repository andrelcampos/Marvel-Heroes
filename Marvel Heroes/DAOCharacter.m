//
//  DAOComics.m
//  Marvel Heroes
//
//  Created by Andre Campos on 12/04/17.
//  Copyright © 2017 Andre Campos. All rights reserved.
//

#import "DAOCharacter.h"

@implementation DAOCharacter

-(instancetype)initFromDictionary:(NSDictionary *)dic{
	self = [super init];
	
	if (self) {
		if (dic) {
			self.idCharacter = [dic valueForKey:@"id"];
			self.nameCharacter = [dic valueForKey:@"name"];
			self.descriptionCharacter = [dic valueForKey:@"description"];
			self.thumbnailPath = [[dic valueForKey:@"thumbnail"] valueForKey:@"path"];
			self.thumbnailExtension = [[dic valueForKey:@"thumbnail"] valueForKey:@"extension"];
			
			self.comics = (int)[[dic valueForKey:@"comics"] valueForKey:@"available"];
			self.events = (int)[[dic valueForKey:@"events"] valueForKey:@"available"];
			self.stories = (int)[[dic valueForKey:@"stories"] valueForKey:@"available"];
			self.series = (int)[[dic valueForKey:@"series"] valueForKey:@"available"];
			
			for (NSDictionary *d in [dic valueForKey:@"urls"]) {
				if ([[d valueForKey:@"type"] isEqualToString:@"detail"]) {
					self.urlDetails = [d valueForKey:@"url"];
					break;
				}
			}
			
		}
	}
	
	return self;
}

@end
