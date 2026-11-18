@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Header Interface View'

define root view entity ZI_INV_HEADER_RO
  as select from zinv_header

  association [0..1] to ZI_VENDOR_RO as _Vendor
    on $projection.VendorId = _Vendor.VendorId

  composition [0..*] of ZI_INV_ITEM_RO as _Item

{
    key invoice_id as InvoiceId,

  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZVH_VENDOR_RO',
        element: 'VendorId'
      }
    }
  ]
      vendor_id       as VendorId,
      invoice_number  as InvoiceNumber,
      invoice_date    as InvoiceDate,
      due_date        as DueDate,

      cuky_field      as Currency,

      @Semantics.amount.currencyCode: 'Currency'
      net_amount      as NetAmount,

      @Semantics.amount.currencyCode: 'Currency'
      tax_amount      as TaxAmount,

      @Semantics.amount.currencyCode: 'Currency'
      total_amount    as TotalAmount,

      status as Status,

@Semantics.user.createdBy: true
created_by as CreatedBy,

@Semantics.systemDateTime.createdAt: true
created_at as CreatedAt,

@Semantics.systemDateTime.lastChangedAt: true
last_changed_at as LastChangedAt,

      _Vendor,
      _Item
}
