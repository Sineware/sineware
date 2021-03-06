//  Copyright (C) 2020 Seshan Ravikumar
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

// Welcome to my disaster of an init.

#include <unistd.h> // mmm POSIX
#include <sys/mount.h>
#include <cerrno>
#include <iostream>
#include <fstream>
#include <csignal>
#include <sys/wait.h>
#include <vector>
#include <cassert>

#include "inipp.h"
#include "running_process.h"

bool is_booting = true;

void print_status_screen();
void update_boot_screen(const std::string& msg);

void fatal_error(const std::string& err_msg);

sigset_t set;

int main() {
    update_boot_screen("Starting Sineware...");
    if(mount("proc", "/proc", "proc", NULL, NULL) != 0) { fatal_error("Mount proc: " + std::to_string(errno)); }
    if(mount("sysfs", "/sys", "sysfs", NULL, NULL) != 0) { fatal_error("Mount sys: " + std::to_string(errno)); }

    update_boot_screen("Getting ready...");

    // Load config options.
    inipp::Ini<char> ini;
    std::ifstream is("/sineware.ini");
    ini.parse(is);

    std::string config_version;
    inipp::extract(ini.sections["sineware"]["version"], config_version);
    std::cout << "Version " << config_version << std::endl;

    std::string config_init;
    inipp::extract(ini.sections["sineware"]["init"], config_init);
    std::cout << "Starting with: " << config_init << std::endl;

    sethostname("sineware-live", 13);

    if(mount(NULL, "/", NULL, MS_REMOUNT, NULL) != 0) { fatal_error("Remount /: " + std::to_string(errno)); }

    if(mount("/proc", "/root_a/proc", "proc", NULL, NULL) != 0) { fatal_error("Mount proc in chroot: " + std::to_string(errno)); }

    if(mount("/sys", "/root_a/sys/", NULL, MS_BIND | MS_REC, NULL) != 0) { fatal_error("Bind sys in chroot: " + std::to_string(errno)); }

    if(mount("/dev", "/root_a/dev/", NULL, MS_BIND | MS_REC, NULL) != 0) { fatal_error("Bind dev in chroot: " + std::to_string(errno)); }

    if(mount("/", "/root_a/sineware/", NULL, MS_BIND | MS_REC, NULL) != 0) { fatal_error("Bind root in chroot: " + std::to_string(errno)); }


    // Switch into the rootfs and boot up processes!
    // todo should we fork off so the main process remains in real root?
    update_boot_screen("Switching into rootfs...");
    chdir("/root_a");
    if (chroot("/root_a") != 0) {
        perror("chroot /root_a");
        fatal_error("chroot /root_a");
        return 1;
    }

    // Create an empty signal set
    sigemptyset(&set);

    // Add signals to the set
    sigaddset(&set, SIGINT);
    sigaddset(&set, SIGCHLD);
    sigaddset(&set, SIGUSR1);

    // Block all signals we set (i.e make them caught by sigwait)
    sigprocmask(SIG_BLOCK, &set, NULL);

    int sig;

    // Start OpenRC
    system("mkdir /run/openrc");
    sleep(1);
    system("touch /run/openrc/softlevel");
    sleep(1);
    system("/sbin/openrc sysinit");
    system("/sbin/openrc boot");
    system("/sbin/openrc default");

    is_booting = false;
    //print_status_screen();
    std::cout << "Welcome to Sineware! (Switching into init loop)" << std::endl;
    while(true) {
        sigwait(&set, &sig);
        int status;
        int pid = waitpid(-1, &status, WNOHANG);
        switch(sig) {
            case SIGINT:
                std::cout << "caught sigint" << std::endl;
                return 0;
            case SIGCHLD:
                std::cout << "caught sigchld (a child process has exited)" << std::endl;
                std::cout << "The Signal is " << status << std::endl;
                std::cout << "The Child was " << pid << std::endl;
                while (waitpid(-1, NULL, WNOHANG) > 0); // Reap the child
                break;
            case SIGUSR1:
                // todo use this to make init do stuff
                break;
            default:
                std::cout << "The Signal is " << sig << std::endl;
                std::cout << "The Child was " << pid << std::endl;
        }
    }

    // Should never get here...
    fatal_error("Init Exited");
    return 0;
}


void print_status_screen() {
    //std::cout << "\033[2J";
    std::cout << "\u001B[1;1H"
        << std::string(80, '-')
        << "\u001B[24;1H"
        << std::string(80, '-')
        << std::flush;

    for(int i = 2; i < 24; i++) {
        printf("\033[%d;1H|", i);
        printf("\033[%d;80H|", i);
    }

    if (!is_booting) {
        std::cout << "\u001B[4;4H Welcome to \u001b[35mSineware\u001b[0m!"
                     "\u001B[6;4H System Status: \u001b[33m"
                     "Unknown"
                     "\u001B[0m"
                     "\u001B[10;4H IP Address: \u001b[32m"
                     "Unknown"
                     "\u001B[0m"
                     "\u001B[11;4H The Web Interface is available on port 8086."
                     "\u001B[12;4H Press Ctrl+Alt+F2 to access the command line."
                     "\u001B[16;4H\u001b[32mDEVELOPMENT BUILD. For Evaluation Purposes Only."
                     << std::endl;
    } else {
        std::cout << "\u001B[4;4H Welcome to \u001b[35mSineware\u001b[0m!"
                     "\u001B[6;4H System Status: \u001b[33mStarting Up...\u001B[0m"
                     "\u001B[16;4H\u001b[32mDEVELOPMENT BUILD. For Evaluation Purposes Only."
                     << std::endl;
    }

}

void update_boot_screen(const std::string& msg) {
    //print_status_screen(); [14;4H
    std::cout << "\u001b[33m" << msg << std::endl;
}

void fatal_error(const std::string& err_msg) {
    std::cout << "\033[2J \u001B[1;1H"
              << std::string(80, '-')
              << "Sineware has run into an unrecoverable error and had to stop.\n"
              << "Error: " << err_msg << "\n\n\n"
              << std::endl;
    while (true);
}