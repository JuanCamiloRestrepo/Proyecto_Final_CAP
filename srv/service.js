require('dotenv').config();
const cds = require('@sap/cds');
/* const { Readable } = require('node:stream');
const { uploadImage, downloadImage, deleteImage } = require('./lib/dropbox'); */
const { SELECT } = require('@sap/cds/lib/ql/cds-ql');

module.exports = class Sales extends cds.ApplicationService {

    async init() {

        const { Sales, Items } = this.entities;

        this.before('NEW',Sales.drafts, async (req) => {
            req.data.orderStatus_code = 'Open';
            req.data.createOn    = new Date();
            const result     = await SELECT.one.from(Sales).columns('max(salesID) as maxSalesID');
            req.data.salesID = (result.maxSalesID || 0) + 1;
        });

        /*this.before(['CREATE', 'UPDATE'], Sales, async (req) => {
            const incoming = req.data.imageUrl;
            if (incoming === undefined) return;

            const ID = req.data.ID || req.params?.[0]?.ID;

            if (incoming === null) {
                const prev = await SELECT.one.from(Products).columns('fileName').where({ ID });
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
        });*/

        /* this.before('CREATE',Sales, async (req) => {
            console.log(req.data);
        }); */

        this.before('NEW',Items.drafts, async (req) => {
            const result     = await SELECT.one.from(Items).columns('max(itemID) as maxItemID');
            req.data.itemID = (result.maxItemID || 0) + 1;
        });

       /*  this.on('rejectOrder', async (req) => {
            
            console.log(req.data);

        }); */

        return super.init();
    }
};