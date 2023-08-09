@Metadata.layer: #CORE
@UI: {
  headerInfo: {
    typeName: 'BOOKING', 
    typeNamePlural: 'BOOKINGs'
  }
}
annotate view ZEVENT_C_BOOKINGTP_100 with
{
  @UI.facet: [ {
    id: 'idIdentification', 
    type: #IDENTIFICATION_REFERENCE, 
    label: 'BOOKING', 
    position: 10 
  } ]
  @UI.lineItem: [ {
    position: 10 , 
    importance: #MEDIUM, 
    label: 'TravelID'
  } ]
  @UI.identification: [ {
    position: 10 , 
    label: 'TravelID'
  } ]
  TravelID;
  
  @UI.lineItem: [ {
    position: 20 , 
    importance: #MEDIUM, 
    label: 'AgencyID'
  } ]
  @UI.identification: [ {
    position: 20 , 
    label: 'AgencyID'
  } ]
  AgencyID;
  
  @UI.lineItem: [ {
    position: 30 , 
    importance: #MEDIUM, 
    label: 'Category'
  } ]
  @UI.identification: [ {
    position: 30 , 
    label: 'Category'
  } ]
  Category;
  
  @UI.lineItem: [ {
    position: 30 , 
    importance: #MEDIUM, 
    label: 'TravelPurpose'
  } ]
  @UI.identification: [ {
    position: 30 , 
    label: 'TravelPurpose'
  } ]
  TravelPurpose;
  
  @UI.lineItem: [ {
    position: 30 , 
    importance: #MEDIUM, 
    label: 'CustomerID'
  } ]
  @UI.identification: [ {
    position: 30 , 
    label: 'CustomerID'
  } ]
  CustomerID;
  
  @UI.lineItem: [ {
    position: 40 , 
    importance: #MEDIUM, 
    label: 'BeginDate'
  } ]
  @UI.identification: [ {
    position: 40 , 
    label: 'BeginDate'
  } ]
  BeginDate;
  
  @UI.lineItem: [ {
    position: 50 , 
    importance: #MEDIUM, 
    label: 'EndDate'
  } ]
  @UI.identification: [ {
    position: 50 , 
    label: 'EndDate'
  } ]
  EndDate;
  
  @UI.lineItem: [ {
    position: 60 , 
    importance: #MEDIUM, 
    label: 'BookingFee'
  } ]
  @UI.identification: [ {
    position: 60 , 
    label: 'BookingFee'
  } ]
  BookingFee;
  
  @UI.lineItem: [ {
    position: 70 , 
    importance: #MEDIUM, 
    label: 'TotalPrice'
  } ]
  @UI.identification: [ {
    position: 70 , 
    label: 'TotalPrice'
  } ]
  TotalPrice;
  
  @UI.lineItem: [ {
    position: 80 , 
    importance: #MEDIUM, 
    label: 'CurrencyCode'
  } ]
  @UI.identification: [ {
    position: 80 , 
    label: 'CurrencyCode'
  } ]
  CurrencyCode;
  
  @UI.multiLineText: true
  @UI.lineItem: [ {
    position: 90 , 
    importance: #MEDIUM, 
    label: 'Description'
  } ]
  @UI.identification: [ {
    position: 90 , 
    label: 'Description'
  } ]
  Description;
  
  @UI.lineItem: [ {
    position: 100 , 
    importance: #MEDIUM, 
    label: 'OverallStatus'
  } ]
  @UI.identification: [ {
    position: 100 , 
    label: 'OverallStatus'
  } ]
  OverallStatus;
  
  @UI.hidden: true
  LastChangedAt;
}