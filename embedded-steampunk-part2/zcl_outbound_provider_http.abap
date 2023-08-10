*
* ABAP Cloud wrapper class with API state Contract C1 (system internally released for ABAP Cloud).
* This way non-ABAP-Cloud-compliant classes like the cl_http_client can be used safely
*
CLASS zcl_outbound_provider_http DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS create_by_destination
      IMPORTING
        !i_sm59_destination       TYPE rfcdest
      RETURNING
        VALUE(r_http_destination) TYPE REF TO if_http_destination
      RAISING
        cx_abap_invalid_value .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_outbound_provider_http IMPLEMENTATION.

  METHOD create_by_destination.
    TRY.
        r_http_destination = cl_outbound_provider_http=>create_by_destination( i_sm59_destination ).
      CATCH cx_outbound_provider_http INTO DATA(lx_outbound_provider_http).
        DATA(lx_http_wrapper) = NEW cx_abap_invalid_value(
          previous      = lx_outbound_provider_http
          value = lx_outbound_provider_http->get_text(  )
        ).
        RAISE EXCEPTION lx_http_wrapper.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.