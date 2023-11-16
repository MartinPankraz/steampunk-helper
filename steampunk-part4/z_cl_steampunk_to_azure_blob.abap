CLASS z_cl_steampunk_to_azure_blob DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    "! get destination based on Communication Arrangement
    METHODS
      get_destination
        RETURNING VALUE(destination) TYPE REF TO if_http_destination
        RAISING   cx_http_dest_provider_error.

ENDCLASS.



CLASS z_cl_steampunk_to_azure_blob IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*      out->write( 'Starting Azure Storage Account SAS call setup' ).
*      DATA(azureStorageAccountName) = 'abapcloudstorage'.
    DATA(azureBlobContainer) = 'abap-cloud'.
    DATA(azureBlobFileName) = 'test.json'.
    DATA(azureSAS) = 'your SAS token'.
*      Data azureBlobURL type string.
*    *Generate SAS token URL. Good for quick and easy testing but Entra ID authentication advisable for production
*      azureBlobURL = |https://| & |{ azureStorageAccountName }| & |.blob.core.windows.net/| & |{ azureBlobContainer }| & |/| & |{ azureBlobFileName }| & |?| & |{ azureSAS }|.

    TRY.
*          DATA(destination) = cl_http_destination_provider=>create_by_url( azureBlobURL ).

        DATA(destination) = get_destination( ).
        DATA(client) = cl_web_http_client_manager=>create_by_http_destination( destination ).
        DATA(req) = client->get_http_request(  ).
*    **** Create JSON payload from booking item properties
        SELECT * FROM zevent_c_bookingtp_0000 INTO TABLE @DATA(lt_booking) UP TO 5 ROWS.
        DATA(lv_json) = /ui2/cl_json=>serialize( lt_booking ).

        req->set_text( lv_json ).
        req->set_header_field( i_name = 'x-ms-blob-type' i_value = 'BlockBlob' ).
        req->set_header_field( i_name = 'Content-Type' i_value = 'application/json; charset=UTF-8' ).
        req->set_header_field( i_name = 'x-ms-version' i_value = '2023-08-03' ).
        req->set_uri_path( i_uri_path = |/| & |{ azureBlobContainer }| & |/| & |{ azureBlobFileName }| ).
        "req->set_uri_path( i_uri_path = |/| & |{ azureBlobFileName }| ).
        "req->set_query( query = |{ azureSAS }| ).

*    **** POST message to Azure BLOB on storage account
        DATA(create_response) = client->execute( if_web_http_client=>put )->get_status(  ).
        out->write( create_response ).
        out->write( 'ABAP Cloud object posted to Azure Blob!' ).
*    **** GET message from Azure BLOB on storage account
        out->write( 'Reading Azure Blob using Microsoft Entra ID!' ).
        DATA(get_response) = client->execute( if_web_http_client=>get ).
        DATA(get_status) = get_response->get_status(  ).
        DATA(get_blob) = get_response->get_text(  ).
        out->write( get_status ).
        out->write( get_blob ).

        client->close(  ).

      CATCH cx_http_dest_provider_error
        cx_web_http_client_error INTO DATA(exception).
        DATA(exception_text) = exception->get_text( ).
        out->write( exception_text ).
        ASSERT FIELDS exception_text CONDITION 1 = 2.
      CATCH cx_root INTO DATA(ex).
        WHILE ex IS BOUND.
          out->write( ex->get_text( ) ).
          ex = ex->previous.
        ENDWHILE.
    ENDTRY.

  ENDMETHOD.


  METHOD get_destination.

    CONSTANTS c_comm_scenario TYPE if_com_management=>ty_cscn_id          VALUE 'ZAZURE_BLOB_SCENARIO'.
    CONSTANTS c_service_id    TYPE if_com_management=>ty_cscn_outb_srv_id VALUE 'ZAZURE_BLOB_DATA_DUMP_REST'.

    "destination = cl_http_destination_provider=>create_by_comm_arrangement(
    "    comm_scenario  = c_comm_scenario
    "    service_id     = c_service_id
    ").

    destination = cl_http_destination_provider=>create_by_cloud_destination(
        i_name = |azure-blob|
        "i_service_instance_name = |SAP_BTP_DESTINATION|
        i_authn_mode = if_a4c_cp_service=>service_specific
    ).

  ENDMETHOD.

ENDCLASS.