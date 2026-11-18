@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Item Interface View'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_INV_ITEM_RO
  as select from zinv_item

  association to parent ZI_INV_HEADER_RO as _Header
    on $projection.InvoiceId = _Header.InvoiceId

{
  key invoice_id  as InvoiceId,
  key item_id     as ItemId,

      description as Description,
      quantity    as Quantity,

      cuky_field  as Currency,

      @Semantics.amount.currencyCode: 'Currency'
      unit_price  as UnitPrice,

      @Semantics.amount.currencyCode: 'Currency'
      net_value   as NetValue,

      tax_rate    as TaxRate,

      @Semantics.amount.currencyCode: 'Currency'
      tax_value   as TaxValue,

      _Header
}
