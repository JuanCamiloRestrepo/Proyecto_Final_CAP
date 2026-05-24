using {SalesService as myservice} from '../service';

annotate myservice.Items with {
    itemID            @title: 'Item ID'            @readonly;
    sales             @title: 'Sales ID';
    name              @title: 'Name';
    description       @title: 'Description'        @UI.MultiLineText;
    releaseDate       @title: 'Release Date'       @readonly;
    discontinuedDate  @title: 'Discontinued Date'  @readonly;
    price             @title: 'Price';
    height            @title: 'Height'             @Measures.Unit: uom_code;
    width             @title: 'Width'              @Measures.Unit: uom_code;
    depth             @title: 'Depth'              @Measures.Unit: uom_code;
    quantity          @title: 'Quantity';
    uom               @title: 'Unit of Measure'    @Common.IsUnit;
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
    UI.LineItem #Items      : [
        {
            $Type: 'UI.DataField',
            Value: itemID
        },
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
            Value: discontinuedDate
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
            Value: uom_code
        },
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'SalesService.releaseItem',
            Label: 'Release Item',
        },
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'SalesService.discontinueItem',
            Label: 'Discontinue Item',
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
                Value: discontinuedDate
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
                Value: uom_code
            }
        ]
    },
    UI.DataPoint #Price     : {
        $Type        : 'UI.DataPointType',
        Value        : price,
        Visualization: #Number,
        Title        : 'Price'
    },
    UI.HeaderFacets         : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Group_D_A'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Group_D_B'
        }
    ]

);
