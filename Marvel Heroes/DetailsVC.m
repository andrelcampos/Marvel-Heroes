//
//  DetailsVC.m
//  Marvel Heroes
//
//  Created by Andre Campos on 17/04/17.
//  Copyright © 2017 Andre Campos. All rights reserved.
//

#import "DetailsVC.h"
#import "DAOCharacter.h"

@interface DetailsVC () 

@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setTitle:@"Detalhes"];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	_lblName.text = _character.nameCharacter;
	_lblDesc.text = _character.descriptionCharacter;
	_imgView.image = _character.image;
	
	_lblComics.text = [NSString stringWithFormat:@"COMICS: %d",_character.comics];
	_lblEvents.text = [NSString stringWithFormat:@"EVENTS: %d",_character.events];
	_lblSeries.text = [NSString stringWithFormat:@"SERIES: %d",_character.series];
	_lblStories.text = [NSString stringWithFormat:@"STORIES: %d",_character.stories];
}

@end
