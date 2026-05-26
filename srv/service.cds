using {com.logaligroup as entities} from '../db/schema';

service SalesService {
    @odata.draft.enabled
    entity Sales          as projection on entities.Sales
        actions {
            @Core.OperationAvailable: {$edmJson: {$And: [
                {$If: [
                    {$Eq: [
                        {$Path: 'IsActiveEntity'},
                        false
                    ]},
                    false,
                    true
                ]},
                {$Not: {$Eq: [
                    {$Path: 'orderStatus_code'},
                    'Rejected'
                ]}}
            ]}}
            action rejectOrder() returns Sales;
        };

    entity Items          as projection on entities.Items
        actions {
            @Core.OperationAvailable: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'IsActiveEntity'},
                    false
                ]},
                false,
                true
            ]}}
            action releaseItem()     returns Items;
            @Core.OperationAvailable: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'IsActiveEntity'},
                    false
                ]},
                false,
                true
            ]}}
            action discontinueItem() returns Items;
        };

    //Value Help
    entity OrderStatus    as projection on entities.OrderStatus;
    entity UnitsOfMeasure as projection on entities.UnitsOfMeasure;
    entity Countries      as projection on entities.Countries;
}
