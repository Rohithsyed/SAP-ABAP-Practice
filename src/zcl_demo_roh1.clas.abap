CLASS zcl_demo_roh1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_demo_roh1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  data my_var1 type string.
  data my_var2 type i.
  data my_var3 type i.
  data my_var4 type i.
  my_var1 = 'hello world'.
  my_var2 = 45.
  my_var3 = my_var2.
  my_var4 = my_var2 + my_var3 .
  out->write( my_var4 ).

  ENDMETHOD.
ENDCLASS.
