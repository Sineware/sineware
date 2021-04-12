require('dotenv').config()
const axios = require('axios').default;
const FormData = require('form-data');
const fs = require("fs");
const logSymbols = require('log-symbols');
const readlineSync = require('readline-sync');
const tar = require('tar');
const crypto = require('crypto');

function checkFSExists(arr) {
    for(let i of arr) {
        if (fs.existsSync("./" + i)) {
            console.log(logSymbols.success, "Integrity Check Passed: " + i);
        } else {
            console.log(logSymbols.error, "Integrity Check failed for: " + i);
            process.exit(-1);
        }
    }

}


async function main() {
    if(typeof process.env.SINEWARE_PRODUCT === "undefined") {
        console.error(logSymbols.error, "Environment Variables not set! Did you source buildconfig.sh?")
    }
    console.log(logSymbols.warning, "Warning! This script deploys to the production Update server!");
    const userSure = readlineSync.keyInYN(logSymbols.warning + " Are you *sure* you want to continue? ");
    if(!userSure) {
        console.log(logSymbols.info, "Exiting... No changes have been made.");
        process.exit(0);
    }
    console.log(logSymbols.info, "Verifying file integrity...");

    const files = [
        "./artifacts/bzImage",
        "./artifacts/sineware-initramfs.cpio.gz",
        "./artifacts/sineware.squashfs.img",
        "./buildmeta/buildconfig.sh"
    ];
    checkFSExists(files);

    try {
        console.log(logSymbols.info, "Creating the update package...");
        const upFileName = "./artifacts/prolinux-full-update.tar.gz";
        await tar.c({
                gzip: true,
                file: upFileName
            }, files);
        console.log(logSymbols.success, "Successfully created update package: " + upFileName);
        // todo sign it

        console.log(logSymbols.info, "Deploying to Sineware Update...");

        // Get JWT Token
        const apiKey = process.env.API_KEY
        console.log(logSymbols.info, "Uploading update package...");
        const form = new FormData();
        form.append('update_package', fs.readFileSync(upFileName));
        const fuploadRes = await axios.post("https://update.sineware.ca/api/v1/update/upload",
            form.getBuffer(),
            {
                'maxContentLength': Infinity,
                'maxBodyLength': Infinity,
                headers: {
                    "X-API-Key": apiKey,
                    ...form.getHeaders()
                }
            });
        console.log(logSymbols.success, "Uploaded! UUID is: " + fuploadRes.data.uuid)

        console.log(logSymbols.success, "Successfully uploaded package!");

        console.log(logSymbols.info, "Sending Update Metadata...");
        // Get File Hash
        const fileBuffer = fs.readFileSync(upFileName);
        const hashSum = crypto.createHash('sha256');
        hashSum.update(fileBuffer);
        const hex = hashSum.digest('hex');
        console.log(logSymbols.info, "Computed file hash: " + hex);

        const dataRes = await axios.post("https://update.sineware.ca/api/v1/update",
            {
                "uuid": fuploadRes.data.uuid,
                "product": process.env.SINEWARE_PRODUCT,
                "variant": process.env.SINEWARE_VARIANT,
                "channel": process.env.SINEWARE_CHANNEL,
                "build": parseInt(process.env.SINEWARE_BUILD),
                "hash": hex,
                "status": "ready",
                "setPointer": true
            },
            { headers: { "X-API-Key": apiKey } });
        console.log(logSymbols.success, "Successfully uploaded update!");
    } catch (e) {
        console.log(logSymbols.error, "An unexpected error has occurred.");
        console.error(e);
    }
}

main().then();