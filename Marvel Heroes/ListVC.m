//
//  ListVC.m
//  Marvel Heroes
//
//  Created by Andre Campos on 12/04/17.
//  Copyright © 2017 Andre Campos. All rights reserved.
//

#import "ListVC.h"
#import "DAOCharacter.h"
#import "CharacterCell.h"
#import "DetailsVC.h"

#define URLCharacters @"https://gateway.marvel.com:443/v1/public/characters?"
#define HASH @"apikey=5ad85c573c20a7d2971136b297fec1a3&ts=1&hash=7ebaba09016f5a0dcd2e1165af1c0071"
#define URLWhitSkyp @"https://gateway.marvel.com:443/v1/public/characters?limit=10&offset="
#define SEARCH @"&nameStartsWith="

@interface ListVC ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
//	NSURL *_url;
	NSURLConnection *_connection;
	NSURLRequest *_request;
	NSMutableData *_mutableData;
	NSString *_searchTerm;
	int _searching;
	NSMutableArray *_tableViewData;
	int skip, totalChar;
	__weak IBOutlet UISearchBar *_searchCharacter;
}

@end

@implementation ListVC

- (void)viewDidLoad {
	[super viewDidLoad];
	_searching = 0;
	_tableViewData = [NSMutableArray array];
	_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
	[_searchCharacter setKeyboardAppearance:UIKeyboardAppearanceDark];
	[self.navigationController setNavigationBarHidden:YES animated:NO];

	[self loadMoreCharacters];
}


#pragma mark - CONNECTION

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	if (connection == _connection) {
		[_mutableData appendData:data];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if (_connection == connection){
		NSError* error;
		NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:_mutableData
																	 options:NSJSONReadingMutableContainers error:&error];
		[self setTableViewDataWithJson:resultados];
		_mutableData = nil;
		_connection = nil;
		if(!error){
			return;
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"Error: %@ %@", error, [error userInfo]);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - SET DATA

- (void)setTableViewDataWithJson:(NSDictionary *)json{
	if (json) {
		
		NSArray *res = [[json valueForKey:@"data"] valueForKey:@"results"];
		NSMutableArray *new = [NSMutableArray array];
		int old = (int)_tableViewData.count;
		
		for (NSDictionary *character in res) {
			DAOCharacter *c = [[DAOCharacter alloc] initFromDictionary:character];
			[new addObject:c];
			[_tableViewData addObject:c];
		}
		
		if (_searching > 0) {
			[_tableView reloadData];
			_searching --;
		}
		else {
			[CATransaction begin];
			
			[_tableView beginUpdates];
			NSMutableArray *mut = [NSMutableArray arrayWithCapacity:[_tableViewData count]];
			int i = 0;
			while (i < [new count]) {
				[mut addObject:[NSIndexPath indexPathForRow:i + old inSection:0]];
				i++;
			}

			[_tableView insertRowsAtIndexPaths:mut withRowAnimation:UITableViewRowAnimationNone];
			[_tableView endUpdates];
			
			[CATransaction commit];
		}
		
		skip = (int)_tableViewData.count;
		totalChar = (int)[[json valueForKey:@"data"] valueForKey:@"total"];
	}
}

- (void)loadMoreCharacters{
	if (skip == 0 && totalChar == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		if(_connection){
			[_connection cancel];
		}
		_mutableData = [NSMutableData data];

		NSString *url = [NSString stringWithFormat:@"%@%@",URLCharacters,HASH];
		if (_searchTerm.length > 0) {
			url = [NSString stringWithFormat:@"%@%@%@&%@",URLCharacters,SEARCH, _searchTerm,HASH];
		}
		NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:url]
												cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
		_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

	}
	else if (skip < totalChar) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		if(_connection){
			[_connection cancel];
		}
		_mutableData = [NSMutableData data];
		NSString *url = [NSString stringWithFormat:@"%@%d&%@",URLWhitSkyp,skip,HASH];
		if (_searchTerm.length > 0) {
			url = [NSString stringWithFormat:@"%@%d%@%@&%@",URLWhitSkyp,skip, SEARCH, _searchTerm, HASH];
		}
		NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:url]
												cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
		_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

	}
}

#pragma mark - TABLEVIEW METHODS

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _tableViewData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	CharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CharacterCell"];
	
	if (!cell) {
		cell = [[CharacterCell alloc] init];
	}

	[cell setCellWithCharacter:_tableViewData[indexPath.row]];
	if (indexPath.row +1 == _tableViewData.count) {
		[self loadMoreCharacters];
	}
	return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_searchCharacter resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//	DetailsVC *det = [[DetailsVC alloc] init];
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	DetailsVC *det = segue.destinationViewController;
	CharacterCell *cell = sender;
	[cell setImageInCharacter];
	det.character = cell.character;
}
#pragma mark - SEARCHBAR

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	_searching ++;
	_searchTerm = searchText;
	skip = totalChar = 0;
	[_tableViewData removeAllObjects];
	[self loadMoreCharacters];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}
@end
