require('dotenv').config();
const cds = require('@sap/cds');
const registerImageHandlers = require('./handlers/sales-image');
const { Readable } = require('node:stream');
const { uploadImage, downloadImage, deleteImage } = require('./lib/dropbox');
const { UPDATE, SELECT } = require('@sap/cds/lib/ql/cds-ql');
const { release } = require('node:os');
const { disconnect } = require('node:cluster');

module.exports = class SalesService extends cds.ApplicationService {

    async init() {

        const { Sales, Items } = this.entities;

        this.before('CREATE', Sales.drafts, async (req) => {
            req.data.orderStatus_code = 'Open';
        });

        this.before('NEW', Sales.drafts, async (req) => {
            if (!req.data.orderStatus_code) {
                req.data.orderStatus_code = 'Open';
            }
            /* req.data.orderStatus_code = 'Open'; */
            req.data.createOn = new Date();
            const result = await SELECT.one.from(Sales).columns('max(salesID) as maxSalesID');
            req.data.salesID = (result.maxSalesID || 0) + 1;
        });

        this.before(['CREATE', 'UPDATE'], Sales, async (req) => {
            const incoming = req.data.imageUrl;
            if (incoming === undefined) return;

            const ID = req.data.ID || req.params?.[0]?.ID;

            if (incoming === null) {
                const prev = await SELECT.one.from(Sales).columns('fileName').where({ ID });
                if (prev?.fileName) await deleteImage(prev.fileName);
                req.data.fileName = null;
                req.data.image = null;
                return;
            }

            const buf = Buffer.isBuffer(incoming) ? incoming : await streamToBuffer(incoming);
            const ext = (req.data.imageType || 'image/png').split('/')[1] || 'png';
            const path = await uploadImage(ID, buf, ext);

            req.data.fileName = path;
            req.data.imageType = req.data.imageType || 'image/png';
            req.data.image = null;
        });

        /* this.before('CREATE',Sales, async (req) => {
            console.log(req.data);
        }); */

        this.before('NEW', Items.drafts, async (req) => {
            const result = await SELECT.one.from(Items).columns('max(itemID) as maxItemID');
            req.data.itemID = (result.maxItemID || 0) + 1;
        });

        this.before(['CREATE', 'UPDATE'], Sales, async (req) => {

            if (req.data.deliveryDate) {

                const today = new Date();
                today.setHours(0, 0, 0, 0);

                const deliveryDate = new Date(req.data.deliveryDate);

                if (deliveryDate <= today) {
                    req.error(400, 'Delivery date must be greater than current date');
                }
            }
        });

        this.on('rejectOrder', Sales, async (req) => {

            const ID = req.params[0].ID;

            await UPDATE(Sales)
                .set({ orderStatus_code: 'Rejected' })
                .where({ ID });

        });

        this.on('releaseItem', Items, async (req) => {

            const ID = req.params[0].ID;

            await UPDATE(Items)
                .set({ releaseDate: new Date() })
                .where({ ID });

            return SELECT.one.from(Items).where({ ID });

        });

        this.on('discontinueItem', Items, async (req) => {

            const ID = req.params[0].ID;

            await UPDATE(Items)
                .set({ discontinuedDate: new Date() })
                .where({ ID });

            return SELECT.one.from(Items).where({ ID });

        });

        // Integración con Dropbox
        registerImageHandlers(this);

        return super.init();
    }
};