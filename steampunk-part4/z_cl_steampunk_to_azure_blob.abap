CLASS z_cl_steampunk_to_azure_blob DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS Z_CL_STEAMPUNK_TO_AZURE_BLOB IMPLEMENTATION.

    METHOD if_oo_adt_classrun~main.
      out->write( 'Starting Azure Storage Account SAS call setup' ).
      DATA(azureStorageAccountName) = 'your storage account name'.
      DATA(azureBlobContainer) = 'your blob container name'.
      DATA(azureBlobFileName) = 'your azure blob name living within the container'.
      DATA(azureSAS) = 'your shared access signature'.
      Data azureBlobURL type string.
      azureBlobURL = |https://| & |{ azureStorageAccountName }| & |.blob.core.windows.net/| & |{ azureBlobContainer }| & |/| & |{ azureBlobFileName }| & |?| & |{ azureSAS }|.

      try.
          DATA(dest) = cl_http_destination_provider=>create_by_url( azureBlobURL ).
          DATA(client) = cl_web_http_client_manager=>create_by_http_destination( dest ).
          DATA(req) = client->get_http_request(  ).
*    **** Create JSON payload from booking item properties
          select * from zevent_c_bookingtp_0000 into table @data(lt_booking) up to 5 ROWS.
          DATA(lv_json) = /ui2/cl_json=>serialize( lt_booking ).

          req->set_text( lv_json ).
          req->set_header_field( i_name = 'x-ms-blob-type' i_value = 'BlockBlob' ).
          req->set_header_field( i_name = 'Content-Type' i_value = 'application/json; charset=UTF-8' ).

*    **** POST message to Azure BLOB on storage account
          DATA(create_response) = client->execute( if_web_http_client=>put )->get_status(  ).
          out->write( create_response ).
          out->write( 'ABAP Cloud object posted to Azure Blob!' ).
          client->close(  ).
      CATCH CX_WEB_HTTP_CLIENT_ERROR INTO DATA(ex).
        out->write( ex->get_text( ) ).
      CATCH  CX_HTTP_DEST_PROVIDER_ERROR INTO DATA(ex1).
        out->write( ex1->get_text( ) ).
      ENDTRY.
    ENDMETHOD.

ENDCLASS.