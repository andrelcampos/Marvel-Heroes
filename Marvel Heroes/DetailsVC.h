//
//  DetailsVC.h
//  Marvel Heroes
//
//  Created by Andre Campos on 17/04/17.
//  Copyright © 2017 Andre Campos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAOCharacter;

@interface DetailsVC : UIViewController{
	__weak IBOutlet UIWebView *_webView;
	
	__weak IBOutlet UILabel
	*_lblName,
	*_lblDesc,
	*_lblComics,
	*_lblEvents,
	*_lblSeries,
	*_lblStories;
	
	__weak IBOutlet UIImageView *_imgView;
	
	__weak IBOutlet UIScrollView *_scrollView;
}

@property (nonatomic) DAOCharacter *character;

@end
