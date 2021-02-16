const axios = require('axios').default;
const chalk = require('chalk');
const fs = require("fs");
const logSymbols = require('log-symbols');
const TOML = require('@iarna/toml')

function checkDirectoriesExist(arr) {
    for(let i of arr) {
        if (fs.existsSync("./" + i)) {
            console.log(logSymbols.success, "Integrity Check Passed: " + i);
        } else {
            console.log(logSymbols.error, "Integrity Check failed for: " + i);
            process.exit(-1);
        }
    }

}

function stringifyConfig(config) {
    let configStr = "";
    for (const [key, value] of Object.entries(config)) {
        console.log(`${key}: ${value}`);
        switch(typeof value){
            case "number":
                configStr += "export " + key + "=" + value + "\n"
                break;
            case "string":
                configStr += "export " + key + "=\"" + value + "\"\n"
                break;
            default:
                console.error(logSymbols.error, "Unsupported config value type: " + typeof value);
                process.exit(-1);
        }
    }
    return configStr
}

async function main() {
    console.log(logSymbols.info, chalk.cyan.underline('Setting up the build environment...'));

    // todo actually do useful things here
    console.log(logSymbols.info, "Verifying file integrity...");
    let dirs = ["artifacts", "build-scripts", "buildmeta", "initramfs-gen", "iso-build-scripts", "kernel-gen", "os-variants", "tools"];
    checkDirectoriesExist(dirs);

    // Determine the next build number
    console.log(logSymbols.info, "Contacting the update server for the latest build number...");
    let updatesReq;
    let buildNum;
    try {
        updatesReq = await axios.get("https://update.sineware.ca/wp-json/wp/v2/update");
        //console.log(updatesReq.data[0]);
        buildNum = parseInt(updatesReq.data[0].build);
    } catch (e) {
        console.log(logSymbols.error, "Could not contact the update server:");
        console.error(e);
        process.exit(-1);
    }
    console.log(logSymbols.info, "Latest build is " + buildNum);
    buildNum++;
    console.log(logSymbols.success, "Setting new build number to: " + buildNum);

    let buildConfig = {};
    // Machine readable (sineware.ini)
    buildConfig.SINEWARE_BUILD = buildNum;
    buildConfig.SINEWARE_PRODUCT = "prolinux-server"
    buildConfig.SINEWARE_CHANNEL = "devel"
    // Pretty Names
    buildConfig.SINEWARE_PRETTY_NAME="Sineware ProLinux Server"
    buildConfig.SINEWARE_PRETTY_VERSION="1.0-" + buildNum

    fs.writeFileSync('./buildmeta/buildconfig.sh', stringifyConfig(buildConfig))

}
main().then();

