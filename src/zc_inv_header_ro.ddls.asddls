@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Header Projection'

@Metadata.allowExtensions: true
define root view entity ZC_INV_HEADER_RO
  provider contract transactional_query
  as projection on ZI_INV_HEADER_RO
{
  key InvoiceId,
@Consumption.valueHelpDefinition: [
  {
    entity: {
      name: 'ZVH_VENDOR_RO',
      element: 'VendorId'
    }
  }
]
VendorId,
      InvoiceNumber,
      InvoiceDate,
      DueDate,
      Currency,
      NetAmount,
      
      TaxAmount,
      TotalAmount,
      Status,
      CreatedBy,
      CreatedAt,
      LastChangedAt,

      _Vendor,
      _Item : redirected to composition child ZC_INV_ITEM_RO
}
