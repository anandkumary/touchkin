//
//  Define.h
//  TouchKin
//
//  Created by Anand kumar on 7/18/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

typedef NS_ENUM(NSInteger, AlertType) {
    
    ALERTDEFAULTTYPE,
    ALERTWITHYESNOTYPE
};

typedef NS_ENUM(NSInteger, DashboardType) {
    
    DASHBOARDIMAGETYPE,
    DASHBOARDMAPTYPE,
    DASHBOARDCELLULARTYPE,
    DASHBOARDNOCAREGIVERS
};

typedef NS_ENUM(NSInteger, NavigationType) {
    NAVIGATIONTYPEMORE,
    NAVIGATIONTYPENORMAL,
    NAVIGATIONTYPECAMERA
};

typedef NS_ENUM(NSInteger, FamilyType) {
    MYFAMILYTYPE,
    OTHERSFAMILYTYPE
};

typedef NS_ENUM(NSInteger, ProfileType) {
    DASHBOARDPROFILE,
    LOGINPROFILE
};


typedef NS_ENUM(NSInteger, AddCareGivers) {
    ADDCAREGIVERSFORME,
    ADDCAREGIVERSFOROTHERS
    
};
