managed implementation in class ZEVENT_BP_BOOKINGTP_100 unique;
strict ( 2 );
with draft;

define behavior for ZEVENT_R_BOOKINGTP_100 alias BOOKING
persistent table zbooking_000
draft table ZEVENT_BOOK100
etag master LastChangedAt
lock master total etag LocalLastChangedAt
authorization master( global )

{
  field ( readonly )
   CreatedAt,
   CreatedBy,
   LocalLastChangedAt,
   LastChangedAt,
   LastChangedBy;

  create;
  update;
  delete;

  draft action Edit;
  draft action Activate;
  draft action Discard;
  draft action Resume;
  draft determine action Prepare;

  determination GenerateDescriptionWithAI on save { create; }//field Description; }

  mapping for ZBOOKING_000
  {
    TravelID = TRAVEL_ID;
    AgencyID = AGENCY_ID;
    CustomerID = CUSTOMER_ID;
    Category = CATEGORY;
    TravelPurpose = TRAVEL_PURPOSE;
    BeginDate = BEGIN_DATE;
    EndDate = END_DATE;
    BookingFee = BOOKING_FEE;
    TotalPrice = TOTAL_PRICE;
    CurrencyCode = CURRENCY_CODE;
    Description = DESCRIPTION;
    OverallStatus = OVERALL_STATUS;
    CreatedBy = CREATED_BY;
    CreatedAt = CREATED_AT;
    LastChangedBy = LAST_CHANGED_BY;
    LastChangedAt = LAST_CHANGED_AT;
    LocalLastChangedAt = LOCAL_LAST_CHANGED_AT;
  }
}