@EndUserText.label : 'DB for booking'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zbooking_000 {
  key client            : abap.clnt not null;
  key travel_id         : abap.numc(8) not null;
  @EndUserText.label : 'short_description'
  agency_id             : abap.numc(6);
  customer_id           : abap.numc(6);
  category              : abap.char(40);
  travel_purpose        : abap.char(40);
  begin_date            : abap.dats;
  end_date              : abap.dats;
  @Semantics.amount.currencyCode : 'zbooking_000.currency_code'
  booking_fee           : abap.curr(16,2);
  @Semantics.amount.currencyCode : 'zbooking_000.currency_code'
  total_price           : abap.curr(16,2);
  currency_code         : abap.cuky;
  description           : abap.sstring(1024);
  overall_status        : abap.char(1);
  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  last_changed_by       : abp_locinst_lastchange_user;
  last_changed_at       : abp_locinst_lastchange_tstmpl;
  local_last_changed_at : abp_lastchange_tstmpl;

}