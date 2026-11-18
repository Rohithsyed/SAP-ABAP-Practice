CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS CalculateValues
      FOR DETERMINE ON MODIFY
      keys FOR Item~CalculateValues.

ENDCLASS.



CLASS lhc_item IMPLEMENTATION.

  METHOD CalculateValues.

    "------------------------------------------------------------
    " 1. Read changed Item values
    "------------------------------------------------------------
    READ ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
      ENTITY Item
      FIELDS (
        Quantity
        UnitPrice
        TaxRate
      )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).


    "------------------------------------------------------------
    " 2. Calculate Item Net Value and Tax Value
    "------------------------------------------------------------
    LOOP AT lt_items INTO DATA(ls_item).

      DATA(lv_net_value) =
        ls_item-Quantity * ls_item-UnitPrice.

      DATA(lv_tax_value) =
        lv_net_value * ls_item-TaxRate / 100.


      MODIFY ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
        ENTITY Item
        UPDATE FIELDS (
          NetValue
          TaxValue
        )
        WITH VALUE #(
          (
            %tky     = ls_item-%tky
            NetValue = lv_net_value
            TaxValue = lv_tax_value
          )
        ).

    ENDLOOP.


    "------------------------------------------------------------
    " 3. Read the Parent Invoice
    "------------------------------------------------------------
    READ ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
      ENTITY Item BY \_Header
      FIELDS (
        InvoiceId
      )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).


    "------------------------------------------------------------
    " 4. Calculate totals for every affected Invoice
    "------------------------------------------------------------
    LOOP AT lt_headers INTO DATA(ls_header).


      "----------------------------------------------------------
      " Read all Items belonging to this Invoice
      "----------------------------------------------------------
      READ ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
        ENTITY Invoice BY \_Item
        FIELDS (
          NetValue
          TaxValue
        )
        WITH VALUE #(
          (
            %tky = ls_header-%tky
          )
        )
        RESULT DATA(lt_all_items).


      "----------------------------------------------------------
      " Initialize totals
      "----------------------------------------------------------
      DATA(lv_net_amount) =
        CONV zde_currinv( 0 ).

      DATA(lv_tax_amount) =
        CONV zde_currinv( 0 ).


      "----------------------------------------------------------
      " Add all Item values
      "----------------------------------------------------------
      LOOP AT lt_all_items INTO DATA(ls_all_item).

        lv_net_amount =
          lv_net_amount + ls_all_item-NetValue.

        lv_tax_amount =
          lv_tax_amount + ls_all_item-TaxValue.

      ENDLOOP.


      "----------------------------------------------------------
      " Calculate Total Amount
      "----------------------------------------------------------
      DATA(lv_total_amount) =
        lv_net_amount + lv_tax_amount.


      "----------------------------------------------------------
      " Update Invoice Header
      "----------------------------------------------------------
      MODIFY ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
        ENTITY Invoice
        UPDATE FIELDS (
          NetAmount
          TaxAmount
          TotalAmount
        )
        WITH VALUE #(
          (
            %tky        = ls_header-%tky
            NetAmount   = lv_net_amount
            TaxAmount   = lv_tax_amount
            TotalAmount = lv_total_amount
          )
        ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.



CLASS lhc_Invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations
      FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations
      FOR Invoice
      RESULT result.

    METHODS Approve
      FOR MODIFY
      keys FOR ACTION Invoice~Approve
      RESULT result.

    METHODS MarkAsPaid
      FOR MODIFY
      keys FOR ACTION Invoice~MarkAsPaid
      RESULT result.

    METHODS Reject
      FOR MODIFY
      keys FOR ACTION Invoice~Reject
      RESULT result.

    METHODS Submit
      FOR MODIFY
      keys FOR ACTION Invoice~Submit
      RESULT result.
    METHODS SetInvoiceId FOR DETERMINE ON MODIFY
      keys FOR Invoice~SetInvoiceId.


ENDCLASS.



CLASS lhc_Invoice IMPLEMENTATION.


  METHOD get_instance_authorizations.

  ENDMETHOD.



  METHOD Approve.

    READ ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
      ENTITY Invoice
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_invoice).

    LOOP AT lt_invoice INTO DATA(ls_invoice).

      IF ls_invoice-Status = 'SUBMITTED'.

        MODIFY ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
          ENTITY Invoice
          UPDATE FIELDS ( Status )
          WITH VALUE #(
            (
              %tky   = ls_invoice-%tky
              Status = 'APPROVED'
            )
          ).

      ELSE.

        APPEND VALUE #(
          %tky = ls_invoice-%tky
        ) TO failed-Invoice.

        APPEND VALUE #(
          %tky = ls_invoice-%tky
          %msg = new_message(
            id       = 'ZINV'
            number   = '002'
            severity = if_abap_behv_message=>severity-error
            v1       = 'Only SUBMITTED invoices can be approved'
          )
        ) TO reported-Invoice.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD MarkAsPaid.

    READ ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
      ENTITY Invoice
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_invoice).

    LOOP AT lt_invoice INTO DATA(ls_invoice).

      IF ls_invoice-Status = 'APPROVED'.

        MODIFY ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
          ENTITY Invoice
          UPDATE FIELDS ( Status )
          WITH VALUE #(
            (
              %tky   = ls_invoice-%tky
              Status = 'PAID'
            )
          ).

      ELSE.

        APPEND VALUE #(
          %tky = ls_invoice-%tky
        ) TO failed-Invoice.

        APPEND VALUE #(
          %tky = ls_invoice-%tky
          %msg = new_message(
            id       = 'ZINV'
            number   = '004'
            severity = if_abap_behv_message=>severity-error
            v1       = 'Only APPROVED invoices can be marked as paid'
          )
        ) TO reported-Invoice.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD Reject.

    READ ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
      ENTITY Invoice
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_invoice).

    LOOP AT lt_invoice INTO DATA(ls_invoice).

      IF ls_invoice-Status = 'SUBMITTED'.

        MODIFY ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
          ENTITY Invoice
          UPDATE FIELDS ( Status )
          WITH VALUE #(
            (
              %tky   = ls_invoice-%tky
              Status = 'REJECTED'
            )
          ).

      ELSE.

        APPEND VALUE #(
          %tky = ls_invoice-%tky
        ) TO failed-Invoice.

        APPEND VALUE #(
          %tky = ls_invoice-%tky
          %msg = new_message(
            id       = 'ZINV'
            number   = '003'
            severity = if_abap_behv_message=>severity-error
            v1       = 'Only SUBMITTED invoices can be rejected'
          )
        ) TO reported-Invoice.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD Submit.

  READ ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
    ENTITY Invoice
    FIELDS ( Status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_invoice).

  LOOP AT lt_invoice INTO DATA(ls_invoice).

    IF ls_invoice-Status = 'NEW'.

      MODIFY ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
        ENTITY Invoice
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          (
            %tky   = ls_invoice-%tky
            Status = 'SUBMITTED'
          )
        ).

      APPEND VALUE #(
        %tky = ls_invoice-%tky
        %param = ls_invoice
      ) TO result.

    ELSE.

      APPEND VALUE #(
        %tky = ls_invoice-%tky
      ) TO failed-invoice.

      APPEND VALUE #(
        %tky = ls_invoice-%tky
        %msg = new_message(
          id       = 'ZINV'
          number   = '001'
          severity = if_abap_behv_message=>severity-error
        )
      ) TO reported-invoice.

    ENDIF.

  ENDLOOP.

ENDMETHOD.


 METHOD SetInvoiceId.

  READ ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
    ENTITY Invoice
    FIELDS ( InvoiceId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_invoice).

  SELECT MAX( invoice_id )
    FROM zinv_header
    INTO @DATA(lv_max_id).

  DATA(lv_number) = 0.

  IF lv_max_id IS NOT INITIAL.

    DATA(lv_number_text) = lv_max_id+3(7).

    TRY.
        lv_number = CONV i( lv_number_text ).
      CATCH cx_sy_conversion_no_number.
        lv_number = 0.
    ENDTRY.

  ENDIF.

  LOOP AT lt_invoice ASSIGNING FIELD-SYMBOL(<ls_invoice>).

    IF <ls_invoice>-InvoiceId IS INITIAL.

      lv_number = lv_number + 1.

      DATA(lv_new_id) = |INV{ lv_number WIDTH = 7 ALIGN = RIGHT PAD = '0' }|.

      MODIFY ENTITIES OF ZI_INV_HEADER_RO IN LOCAL MODE
        ENTITY Invoice
        UPDATE FIELDS ( InvoiceId )
        WITH VALUE #(
          (
            %tky      = <ls_invoice>-%tky
            InvoiceId = lv_new_id
          )
        ).

    ENDIF.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
