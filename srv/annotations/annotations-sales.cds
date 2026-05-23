using {Sales as myservice} from '../service';

annotate myservice.Sales with @odata.draft.enabled;

annotate myservice.Sales with {
    salesID      @title: 'Sales ID';
    email        @title: 'Email';
    firstName    @title: 'First Name';
    lastName     @title: 'Last Name';
    country      @title: 'Country';
    createOn     @title: 'Created On';
    deliveryDate @title: 'Delivery Date';
    orderStatus  @title: 'Order Status';
    imageUrl     @title: 'Image'  @UI.IsImage;
};

annotate myservice.Sales with {
    salesID     @Common: {
        Text           : salesID,
        TextArrangement: #TextOnly,
    };
    country     @(
        Common.ValueList      : {
            Label         : 'Country',
            CollectionPath: 'Countries',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: country_code,
                    ValueListProperty: 'code'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                }
            ]
        },

        Common.Text           : country.name,
        Common.TextArrangement: #TextFirst
    );
    orderStatus @Common: {
        Text           : orderStatus.name,
        TextArrangement: #TextOnly,
    };
};

annotate myservice.Sales with @(
    UI.SelectionFields      : [
        email,
        firstName,
        lastName
    ],
    UI.HeaderInfo           : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Sale',
        TypeNamePlural: 'Sales',
        Title         : {
            $Type: 'UI.DataField',
            Value: salesID
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: email
        }
    },
    UI.LineItem             : [
        {
            $Type: 'UI.DataField',
            Value: salesID
        },
        {
            $Type: 'UI.DataField',
            Value: email
        },
        {
            $Type: 'UI.DataField',
            Value: firstName
        },
        {
            $Type: 'UI.DataField',
            Value: lastName
        },
        {
            $Type: 'UI.DataField',
            Value: country_code
        },
        {
            $Type: 'UI.DataField',
            Value: createOn
        },
        {
            $Type: 'UI.DataField',
            Value: deliveryDate
        },
        {
            $Type: 'UI.DataField',
            Value: orderStatus_code
        },
        {
            $Type: 'UI.DataField',
            Value: imageUrl
        }
    ],
    UI.FieldGroup #Group_H_A: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: firstName
            },
            {
                $Type: 'UI.DataField',
                Value: lastName
            }
        ]
    },
    UI.FieldGroup #Group_H_B: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: country_code
            },
            {
                $Type: 'UI.DataField',
                Value: createOn
            },
            {
                $Type: 'UI.DataField',
                Value: deliveryDate
            },
            {
                $Type: 'UI.DataField',
                Value: orderStatus_code
            }
        ]
    },
    UI.FieldGroup #Picture  : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type: 'UI.DataField',
            Value: imageUrl,
            Label: ''
        }]
    },
   /*  UI.HeaderFacets         : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Group_H_A'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Group_H_B'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Picture'
        }
    ], */
    UI.Facets               : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : 'HeaderSection',
            Label : 'Sales Order',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Group_H_A',
                    Label : 'Información del objeto'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Group_H_B'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Picture'
                }
            ]
        },
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Items',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: 'items/@UI.LineItem#Items',
                Label : 'Items'
            }]
        }
    ]
);
