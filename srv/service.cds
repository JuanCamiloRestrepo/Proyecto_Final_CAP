using {com.logaligroup as entities} from '../db/schema';

service Sales {

    entity Sales as projection on entities.Sales;
    entity Items as projection on entities.Items;
    entity OrderStatus as projection on entities.OrderStatus;
    entity UnitsOfMeasure as projection on entities.UnitsOfMeasure;
    entity Countries as projection on entities.sap.common.Countries;

    action rejectOrder() returns Sales;
    action releaseItem() returns Items;
    action discontinueItem() returns Items;
}