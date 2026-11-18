@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Item Projection'
@Metadata.allowExtensions: true

define view entity ZC_INV_ITEM_RO
  as projection on ZI_INV_ITEM_RO
{
  @EndUserText.label: 'Invoice ID'
  key InvoiceId,

  @EndUserText.label: 'Item ID'
  key ItemId,

  @EndUserText.label: 'Description'
  Description,

  @EndUserText.label: 'Quantity'
  Quantity,

  @EndUserText.label: 'Currency'
  Currency,

  @EndUserText.label: 'Unit Price'
  UnitPrice,

  @EndUserText.label: 'Net Value'
  NetValue,

  @EndUserText.label: 'Tax Rate'
  TaxRate,

  @EndUserText.label: 'Tax Value'
  TaxValue,

  _Header : redirected to parent ZC_INV_HEADER_RO
}
