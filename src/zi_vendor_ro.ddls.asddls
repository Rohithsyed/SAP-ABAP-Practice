@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ddef for vendor'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_VENDOR_RO as select from zbd_vendor_ro
{
key vendor_id as VendorId,
vendor_name as VendorName,
email as Email,
phone as Phone,
city as City,
status as Status,
created_by as CreatedBy,
created_at as CreatedAt
}
