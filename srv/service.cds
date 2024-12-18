using {API_BUSINESS_PARTNER as api} from './external/API_BUSINESS_PARTNER';

service LogaliGroup {

    @cds.persistence.exists
    @cds.persistence.skip
    entity SuppliersSet as
        projection on api.A_Supplier {
            key Supplier,
                SupplierName,
                SupplierFullName,
                to_SupplierCompany as toCompany : redirected to CompaniesSet
        }

    @cds.persistence.exists
    @cds.persistence.skip
    entity CompaniesSet as
        projection on api.A_SupplierCompany {
            key CompanyCode     as Code,
                CompanyCodeName as Name
        };

    type MySupplier {
        Supplier            : SuppliersSet:Supplier;
        SupplierName        : SuppliersSet:SupplierName;
        SupplierFullName    : SuppliersSet:SupplierFullName;
        toCompany           : {
            CompanyCode     : CompaniesSet:Code;
            CompanyCodeName : CompaniesSet:Name
        }
    };

    function getSupplier(ID : SuppliersSet:Supplier) returns MySupplier;
}
