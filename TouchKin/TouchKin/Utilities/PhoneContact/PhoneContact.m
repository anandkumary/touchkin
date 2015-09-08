
#import "YMLPhoneContactPerson.h"
#import "PhoneContact.h"

@interface PhoneContact ()

@property (nonatomic) ABAddressBookRef addressBookRef;

- (YMLPhoneContactPerson *) parseContact:(ABRecordRef)record;

@end

@implementation PhoneContact

- (id)init
{
    self = [super init];
    if (self) {
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    return self;
}


#pragma mark - Private Methods

- (YMLPhoneContactPerson *) parseContact:(ABRecordRef)record {
    
    
    YMLPhoneContactPerson *contactPerson = [[YMLPhoneContactPerson alloc] init];
    
    // Personal Info
    [contactPerson setContactID:[NSString stringWithFormat:@"%d", ABRecordGetRecordID(record)]];
    [contactPerson setFirstName:(__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty)];
    [contactPerson setLastName:(__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty)];
    [contactPerson setMiddleName:(__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonMiddleNameProperty)];
    [contactPerson setJobTitle:(__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonJobTitleProperty)];
    
    
    if (ABPersonHasImageData(record)) {
        
        NSData *imgData = (__bridge NSData*)ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail);
     
        [contactPerson setImageData:imgData];
        CFRelease((__bridge CFTypeRef)(imgData));
    }
    
    // Email
    ABMultiValueRef emailMultiValueRef = ABRecordCopyValue(record, kABPersonEmailProperty);
    [contactPerson setEmails:[NSMutableArray arrayWithArray:(__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(emailMultiValueRef)]];
    CFRelease(emailMultiValueRef);
    
    
    // Phone number
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(record, kABPersonPhoneProperty);
    NSMutableArray *phoneNumbersArray = [[NSMutableArray alloc] init];
    // If the contact has multiple phone numbers, iterate on each of them
    for (int i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
        NSString *phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
        
        // Remove all formatting symbols that might be in both phone number being compared
        NSCharacterSet *toExclude = [NSCharacterSet characterSetWithCharactersInString:@"/.()-+x "];
        phone = [[phone componentsSeparatedByCharactersInSet:toExclude] componentsJoinedByString: @""];
        [phoneNumbersArray addObject:phone];
    }
    [contactPerson setPhoneNumbers:phoneNumbersArray];
    CFRelease(phoneNumbers);
    
    
    // Profile Image
//    NSData *imgData = (__bridge NSData *)(ABPersonCopyImageData(record));
//    UIImage *img = [UIImage imageWithData:imgData];
//    [contactPerson setImage:img];
    
    // Give user an option select their own values
    if ([_delegate respondsToSelector:@selector(phoneContact:parseRecord:toContactPerson:)]) {
        [_delegate phoneContact:self parseRecord:record toContactPerson:contactPerson];
    }
    
    return contactPerson;
}


#pragma mark - Public Methods
-(void)readContactList{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        typeof(self) __weak weakSelf = self;
        ABAddressBookRequestAccessWithCompletion(_addressBookRef, ^(bool granted, CFErrorRef error) {
            PhoneContact *strongSelf = weakSelf;
            if (strongSelf) {
                if (granted) {
                    // granted
                    [strongSelf updatedContacts];
                }
                
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // Granted fetch contact
        [self updatedContacts];
    }
}

- (void) fetchContact {
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        typeof(self) __weak weakSelf = self;
        ABAddressBookRequestAccessWithCompletion(_addressBookRef, ^(bool granted, CFErrorRef error) {
            PhoneContact *strongSelf = weakSelf;
            if (strongSelf) {
                if (granted) {
                    // granted
                    [strongSelf getContacts];
                }
                else {
                    // Not granted
                    if ([strongSelf->_delegate respondsToSelector:@selector(phoneContactPermissionDenied:)]) {
                        [strongSelf->_delegate phoneContactPermissionDenied:strongSelf];
                    }
                }
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // Granted fetch contact
        [self getContacts];
    }
    else {
        // Not granted
        if ([_delegate respondsToSelector:@selector(phoneContactPermissionDenied:)]) {
            [_delegate phoneContactPermissionDenied:self];
        }
    }
}

- (void) getContacts {
    
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
    
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    for (int i = 0; i < CFArrayGetCount(allContacts); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(allContacts, i);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phoneNumbers);
        CFRelease(phoneNumbers);
        if(phoneCount){
            //NSLog(@"add phone %@",phoneNumbers);
            [contacts addObject:[self parseContact:record]];

        }
        
    }
    
    if ([_delegate respondsToSelector:@selector(phoneContact:didFinishFetching:)]) {
        [_delegate phoneContact:self didFinishFetching:contacts];
    }
    
    CFRelease(allContacts);
}

-(void)updatedContacts{
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
    
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    for (int i = 0; i < CFArrayGetCount(allContacts); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(allContacts, i);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phoneNumbers);
        CFRelease(phoneNumbers);
        if(phoneCount){
           // NSLog(@"add phone %@",phoneNumbers);
            [contacts addObject:[self parseContact:record]];
        }

        
    }
    
    if ([_delegate respondsToSelector:@selector(phoneUpdatedContact:didFinishFetching:)]) {
        [_delegate phoneUpdatedContact:self didFinishFetching:contacts];
    }
    
    CFRelease(allContacts);
}

@end
