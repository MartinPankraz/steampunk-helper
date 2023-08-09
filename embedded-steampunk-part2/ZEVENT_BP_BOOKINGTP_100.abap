**********************************************************************
* Generated class from SAP Developer tutorial step 7 with deterimination instead of additional save implementation:
* https://developers.sap.com/tutorials/abap-environment-create-s4hana-rap-business-events.html#01eeb70f-6783-40bc-bfbf-ba229cafd2c5
* determination for on save added to inject Description from Azure OpenAI before final save.
*
* Maintain your Azure OpenAI settings in get_sdk method line 34 onwards
**********************************************************************
CLASS LHC_BOOKING DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.CLASS LCL_HANDLER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR BOOKING
        RESULT result.

    METHODS generateDescriptionWithAI FOR DETERMINE ON SAVE
      IMPORTING keys FOR Booking~generateDescriptionWithAI.
ENDCLASS.

CLASS LCL_HANDLER IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD generateDescriptionWithAI.

    DATA:
      chatcompl_input  TYPE zif_peng_azoai_sdk_types=>ty_chatcompletion_input,
      chatcompl_output TYPE zif_peng_azoai_sdk_types=>ty_chatcompletion_output,
      status_code      TYPE i,                                 "Return Status Code
      status_reason    TYPE string,                            "Return Status Reason
      returnjson       TYPE string,                            "Return JSON. The content of this JSON string is parsed and made available through ABAP data types.
      error            TYPE zif_peng_azoai_sdk_types=>ty_error. "ABAP Type for Error

        TRY.
            data(sdk_instance) = zcl_peng_azoai_sdk_factory=>get_instance( )->get_sdk(
                                                                      api_version = '2023-03-15-preview'
                                                                      api_base    = 'https://your-instance-openai-your-region.openai.azure.com'
                                                                      api_type    = zif_peng_azoai_sdk_constants=>c_apitype-azure
                                                                      api_key     = 'your API key'
                                                                    ).
          "Limit the tokens being used per OpenAI GPT request
          chatcompl_input-max_tokens = 4000.
          "Construct the prompt with system and user roles.
          APPEND INITIAL LINE TO chatcompl_input-messages ASSIGNING FIELD-SYMBOL(<fs_message>).
          <fs_message>-role = zif_peng_azoai_sdk_constants=>c_chatcompletion_role-system.
          <fs_message>-content = |You are a virtual assistant suggesting creative business justification of the travel request on behalf of the user. Use less than 3 sentences.|.

          "Apply few-shot samples to using past booking entries to set the prompt context for the GPT model
          "https://learn.microsoft.com/azure/ai-services/openai/concepts/advanced-prompt-engineering?pivots=programming-language-chat-completions#few-shot-learning
          select * from zevent_c_bookingtp_100 into table @data(lt_booking).

          Loop at lt_booking into data(wa_booking).
            APPEND INITIAL LINE TO chatcompl_input-messages ASSIGNING <fs_message>.
            <fs_message>-role = zif_peng_azoai_sdk_constants=>c_chatcompletion_role-user.
            <fs_message>-content = |Create a booking description based on the following attributes:Purpose-{ wa_booking-TravelPurpose },Category-{ wa_booking-Category },UserID-{ wa_booking-CustomerID }|.

            APPEND INITIAL LINE TO chatcompl_input-messages ASSIGNING <fs_message>.
            <fs_message>-role = zif_peng_azoai_sdk_constants=>c_chatcompletion_role-assistant.
            <fs_message>-content = |{ wa_booking-Description }|.
          endloop.

          "Supply Category, Travel Purpose and CustomerID from new Booking request to OpenAI for description generation
          APPEND INITIAL LINE TO chatcompl_input-messages ASSIGNING <fs_message>.
          <fs_message>-role = zif_peng_azoai_sdk_constants=>c_chatcompletion_role-user.
          <fs_message>-content = |Create a booking description based on the following attributes:|.
          "
          READ ENTITIES OF zevent_r_bookingtp_100 IN LOCAL MODE
            ENTITY booking
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(Booking).
          "Iterate through individual booking fields to get access to current RAP BO
          Loop at Booking into data(mybooking).
            <fs_message>-content = |{ <fs_message>-content } Purpose-{ mybooking-TravelPurpose },Category-{ mybooking-Category },UserID-{ mybooking-CustomerID }|.
          endloop.

          " Execute Chat Completion request with Azure OpenAI
          " It is recommended to tune the prompt using the Azure OpenAI studio: https://oai.azure.com/portal
          " Learn more about design techniques here: https://learn.microsoft.com/azure/ai-services/openai/concepts/advanced-prompt-engineering?pivots=programming-language-chat-completions#start-with-clear-instructions
          sdk_instance->chat_completions( )->create(
            EXPORTING
              deploymentid = 'chatgpt-demo'
              prompts      = chatcompl_input
            IMPORTING
              statuscode   = status_code
              statusreason = status_reason
              response     = chatcompl_output
              error        = error
          ).

        if error is initial.

            DATA update_line TYPE STRUCTURE FOR UPDATE zevent_r_bookingtp_100\\booking.
            Data update type table for update zevent_r_bookingtp_100\\booking.
            clear update_line.

           update_line-%tky = mybooking-%tky.
           "Set new Description from Azure OpenAI generated text
           update_line-Description = chatcompl_output-choices[ 1 ]-message-content.
           append update_line to update.

        else.
          APPEND VALUE #( %tky = mybooking-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-information
                                   text     = 'error' )
                        ) TO reported-booking.
        endif.
    " write back the AI generated Description to newly created booking before final save :-)
    MODIFY ENTITIES OF zevent_r_bookingtp_100 IN LOCAL MODE
      ENTITY booking
        UPDATE FIELDS ( Description )
        WITH update
    REPORTED DATA(update_reported)."collect issues into report

    reported = CORRESPONDING #( DEEP update_reported )."report any issues back to UI

    CATCH zcx_peng_azoai_sdk_exception INTO DATA(ex). " MSPENG:Azure Open AI ABAP SDK Exception
          APPEND VALUE #( %tky = mybooking-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-information
                                   text     = ex->get_text( ) )
                        ) TO reported-booking.
  ENDTRY.

  ENDMETHOD.
ENDCLASS.