require('dotenv').config()
const axios = require('axios').default;
const FormData = require('form-data');
const fs = require("fs");
const logSymbols = require('log-symbols');
const readlineSync = require('readline-sync');
const tar = require('tar');


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
        /*await tar.c({
                gzip: true,
                file: upFileName
            }, files);*/
        console.log(logSymbols.success, "Successfully created update package: " + upFileName);
        // todo sign it

        console.log(logSymbols.info, "Deploying to Sineware Update...");

        // Get JWT Token
        const tokenRes = await axios.post("https://update.sineware.ca/wp-json/jwt-auth/v1/token",
            {
                "username": process.env.UPDATE_USERNAME,
                "password": process.env.UPDATE_PASSWORD
            });
        const token = tokenRes.data.token
        console.log(logSymbols.success, "Successfully Authenticated (got a JWT)");
        console.log(logSymbols.info, "Uploading update package...");
        const form = new FormData();
        form.append('file', fs.readFileSync(upFileName));
        const fuploadRes = await axios.post("https://update.sineware.ca/wp-json/wp/v2/media",
            form.getBuffer(),
            {
                'maxContentLength': Infinity,
                'maxBodyLength': Infinity,
                headers: {
                    "Authorization": "Bearer " + token,
                    ...form.getHeaders()
                }
            });
        console.log(fuploadRes)
        console.log(logSymbols.success, "Successfully uploaded package!");

    } catch (e) {
        console.log(logSymbols.error, "An unexpected error has occurred.");
        console.error(e);
    }
}

main().then();