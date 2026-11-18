@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Value Help'

@ObjectModel.dataCategory: #VALUE_HELP

define view entity ZVH_VENDOR_RO
  as select from ZI_VENDOR_RO
{
  key VendorId,
      VendorName,
      City,
      Email,
      Phone,
      Status
}
