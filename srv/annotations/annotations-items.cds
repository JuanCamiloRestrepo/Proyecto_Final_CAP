using {Sales as myservice} from '../service';

annotate myservice.Items with {
    itemID           @title: 'Item ID';
    salesID          @title: 'Sales ID';
    name             @title: 'Name';
    description      @title: 'Description'      @UI.MultiLineText;
    releaseDate      @title: 'Release Date';
    discontinuedData @title: 'Discontinued Date';
    price            @title: 'Price';
    height           @title: 'Height'           @Measures.Unit: uom;
    width            @title: 'Width'            @Measures.Unit: uom;
    depth            @title: 'Depth'            @Measures.Unit: uom;
    quantity         @title: 'Quantity';
    uom              @title: 'Unit of Measure'  @Common.IsUnit;
};

annotate myservice.Items with @(
    UI.HeaderInfo           : {
        TypeName      : 'Item',
        TypeNamePlural: 'Items',
        Title         : {
            $Type: 'UI.DataField',
            Value: name
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: description
        }
    },
    UI.LineItem #Items : [
        {
            $Type: 'UI.DataField',
            Value: name
        },
        {
            $Type: 'UI.DataField',
            Value: description
        },
        {
            $Type: 'UI.DataField',
            Value: releaseDate
        },
        {
            $Type: 'UI.DataField',
            Value: discontinuedData
        },
        {
            $Type             : 'UI.DataField',
            Value             : price,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem',
            },
        },
        {
            $Type: 'UI.DataField',
            Value: height
        },
        {
            $Type: 'UI.DataField',
            Value: width
        },
        {
            $Type: 'UI.DataField',
            Value: depth
        },
        {
            $Type: 'UI.DataField',
            Value: quantity
        },
        {
            $Type: 'UI.DataField',
            Value: uom
        }
    ],
    UI.FieldGroup #Group_D_A: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: releaseDate
            },
            {
                $Type: 'UI.DataField',
                Value: discontinuedData
            },
            {
                $Type: 'UI.DataField',
                Value: price
            }
        ]
    },
    UI.FieldGroup #Group_D_B: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: height
            },
            {
                $Type: 'UI.DataField',
                Value: width
            },
            {
                $Type: 'UI.DataField',
                Value: depth
            },
            {
                $Type: 'UI.DataField',
                Value: quantity
            },
            {
                $Type: 'UI.DataField',
                Value: uom
            }
        ]
    },
    UI.DataPoint #Price: {
        $Type         : 'UI.DataPointType', 
        Value         : price, 
        Visualization : #Number, 
        Title         : 'Price'
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Group_D_A'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Group_D_B'
        }
    ]

);
