@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'vendor projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_VENDOR_RO provider contract transactional_query as projection on ZI_VENDOR_RO
{
    key VendorId,
    VendorName,
    Email,
    Phone,
    City,
    Status,
    CreatedBy,
    CreatedAt
}
