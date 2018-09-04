//
//  ViewController.m
//  DocSharing
//
//  Created by Kanchan on 11/05/18.
//  Copyright © 2018 Kanchan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *nameArr;
    UIDocumentPickerViewController *importMenu;
    UIDocumentInteractionController *showDoc;
    //var nameArr:NSMutableArray = []
}
@property (weak, nonatomic) IBOutlet UICollectionView *doclist;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    nameArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // launches interaction controller to read and enable sharing of file
    
    showDoc = [UIDocumentInteractionController interactionControllerWithURL:[nameArr objectAtIndex:indexPath.row]];
    showDoc.delegate = self;
    [showDoc presentPreviewAnimated:YES];

}

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.doclist dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *lbl = [cell viewWithTag:3];
    NSURL *urlStr = [nameArr objectAtIndex:indexPath.row];
    lbl.text = [[urlStr.absoluteString componentsSeparatedByString:@"/"] lastObject];  //name of file

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return nameArr.count;
}

- (IBAction)addDoc:(id)sender
{
    // View controller for icloud drive is launched
    
    importMenu = [[UIDocumentPickerViewController alloc]initWithDocumentTypes:[[NSArray alloc]initWithObjects:@"public.image", @"public.audio", @"public.movie", @"public.text", @"public.item", @"public.content", @"public.source-code", nil] inMode:UIDocumentPickerModeImport];
    importMenu.delegate = self;
    importMenu.allowsMultipleSelection = YES;
    [self presentViewController:importMenu animated:YES completion:nil];

}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls
{
    // called when file or files selection is done and iCloud Drive VC is closed
   
    NSLog(@"found something  %@",urls.description);
   
    for(NSURL *url in urls)
    {
        [nameArr addObject:url];
    }
   
    [self.doclist reloadData];
}



-(void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
    
    UIAlertController *cancelled = [UIAlertController alertControllerWithTitle:@"cancelled :(" message:@"You just cancelled the document option" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [cancelled addAction:act];
    [self presentViewController:cancelled animated:YES completion:nil];
    
    NSLog(@"unfortunately cancelled");
}

@end
