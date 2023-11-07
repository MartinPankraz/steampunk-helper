**********************************************************************
* Generated class from SAP Developer tutorial step 7:
* https://developers.sap.com/tutorials/abap-environment-create-s4hana-rap-business-events.html#01eeb70f-6783-40bc-bfbf-ba229cafd2c5
* save_modified overriden with http client to call Microsoft APIs
* 
* Applicable only to BTP ABAP environment!!!
*
**********************************************************************
CLASS LHC_BOOKING DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR BOOKING
        RESULT result.
ENDCLASS.

CLASS LHC_BOOKING IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_event_handler DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
      METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

***** Make your changes below
  METHOD save_modified.

***** Act on booking create action. Use update, delete, etc. for alternate behavior.
    IF create IS NOT INITIAL.

***** get destination for http client by com arrangement in steampunk
      " DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
      "                             comm_scenario  = 'Your Comm Scneario'
      "                             service_id     = 'Your Service ID'

***** Setup http request to Azure Logic Apps directly when not using comm arrangement above.
***** Check the blog series for details on how to protect the Logic Apps endpoint with OAuth2/OIDC or
***** direct calls to Microosft Graph API with ABAP SDK for Azure
      DATA(dest) = cl_http_destination_provider=>create_by_url(
  'https://prod-78.eastus.logic.azure.com:443/workflows/your-id/triggers/manual/paths/invoke?api-version=2016-10-01&sp=your-access-signature' ).
      DATA(client) = cl_web_http_client_manager=>create_by_http_destination( dest ).
      DATA(req) = client->get_http_request(  ).
***** Create JSON payload from booking item properties
      DATA(lv_json) = /ui2/cl_json=>serialize( create-booking ).

      req->set_text( lv_json ).
      req->set_header_field( i_name = 'Content-Type' i_value = 'application/json; charset=UTF-8' ).

***** POST message to Azure Logic Apps
      DATA(create_response) = client->execute( if_web_http_client=>post )->get_text(  ).
      client->close(  ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
