const cds = require('@sap/cds');

module.exports = class LogaliGroup extends cds.ApplicationService {

   async init () {

        const {SuppliersSet, CompaniesSet} = this.entities;
        const api = await cds.connect.to("API_BUSINESS_PARTNER");

        this.on('READ', [SuppliersSet, CompaniesSet], async (req)=>{
            return await api.tx(req).send({
                query: req.query,
                headers: {
                    apikey: process.env.APIKEY
                }
            })
        });

        this.on('getSupplier', async (req)=>{

            return await api.tx(req).send({
                query:
                SELECT.one.from(SuppliersSet, supplier => {
                    supplier.Supplier,
                    supplier.SupplierName,
                    supplier.SupplierFullName,
                    supplier.toCompany(company => {
                        company('CompanyCode'),
                        company('CompanyCodeName')
                    })
                }).where({Supplier: req.data.ID}),
                headers: {
                    apikey: process.env.APIKEY
                }
            });

      })

        return super.init();
    }
}