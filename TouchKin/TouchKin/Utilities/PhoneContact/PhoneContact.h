
#import <AddressBook/AddressBook.h>
#import <Foundation/Foundation.h>

@class YMLPhoneContactPerson;

@protocol PhoneContactDelegate;

@interface PhoneContact : NSObject

@property (nonatomic, weak) id<PhoneContactDelegate> delegate;

- (void) fetchContact;
-(void)readContactList;

@end


@protocol PhoneContactDelegate <NSObject>

@optional
- (void) phoneContact:(PhoneContact *)phoneContact parseRecord:(ABRecordRef)record toContactPerson:(YMLPhoneContactPerson *)contactPerson;
- (void) phoneContact:(PhoneContact *)phoneContact didFinishFetching:(NSMutableArray *)contacts;
- (void) phoneContactPermissionDenied:(PhoneContact *)phoneContact;
- (void) phoneUpdatedContact:(PhoneContact *)phoneContact didFinishFetching:(NSMutableArray *)contacts;

@end
