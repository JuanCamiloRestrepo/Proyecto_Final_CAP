namespace com.logaligroup;

using {
    cuid,
    managed,
    sap.common.CodeList,
} from '@sap/cds/common';

entity Sales : cuid, managed {
    salesID      : String(10);
    email        : String(40);
    firstName    : String(40);
    lastName     : String(40);
    country      : Association to Countries;
    createOn     : Date;
    deliveryDate : Date;
    orderStatus  : Association to OrderStatus;
    imageUrl     : LargeBinary  @Core.MediaType: imageType  @Core.ContentDisposition.Filename: fileName;
    imageType    : String       @Core.IsMediaType;
    fileName     : String;
    items        : Composition of many Items
                       on items.salesID = $self;
};

entity Items : cuid, managed {
    itemID           : String(10);
    salesID          : Association to Sales;
    name             : String(40);
    description      : String(40);
    releaseDate      : Date;
    discontinuedDate : Date;
    price            : Decimal(12, 2);
    height           : Decimal(15, 3);
    width            : Decimal(13, 3);
    depth            : Decimal(12, 2);
    quantity         : Decimal(16, 2);
    uom              : Association to UnitsOfMeasure;
};

entity OrderStatus : CodeList {
    key code : String(20) enum {
            Open = 'Open';
            PartProc = 'Partially Processed';
            Completed = 'Completed';
            Rejected = 'Rejected';
            Blocked = 'Blocked';
            InProc = 'In Process';
        }
};

entity UnitsOfMeasure : CodeList {
    key code : String(3);
        name : String(10);
};

entity Countries : CodeList {
    key code : String(3); //> ISO 3166-1 alpha-2 codes (or alpha-3)
        name : String(60);
};
