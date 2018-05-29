//
//  ViewController.m
//  Demo
//
//  Created by liufengting on 2018/5/29.
//  Copyright © 2018年 liufengting. All rights reserved.
//

#import "ViewController.h"
#import "FTFoldableTableView.h"
#import "DemoSectionHeaderView.h"
#import "DemoTableViewCell.h"

@interface ViewController () <FTFoldableTableViewDataSource, FTFoldableTableViewDelegate>

@property (weak, nonatomic) IBOutlet FTFoldableTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

#pragma mark - FTFoldableTableViewDataSource, FTFoldableTableViewDelegate

- (NSInteger)numberOfSectionsInFoldableTableView:(FTFoldableTableView *)tableView {
    return 3;
}

- (NSInteger)foldableTableView:(FTFoldableTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)foldableTableView:(FTFoldableTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}

//- (CGFloat)foldableTableView:(FTFoldableTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 210.f;
//}

- (FTFoldableSectionHeader *)foldableTableView:(FTFoldableTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DemoSectionHeaderView *header = [[NSBundle mainBundle] loadNibNamed:DemoSectionHeaderViewNibName owner:nil options:nil].firstObject;
    return header;
}

- (UITableViewCell *)foldableTableView:(FTFoldableTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:DemoTableViewCellIdentifier forIndexPath:indexPath];
}

- (void)foldableTableView:(FTFoldableTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
