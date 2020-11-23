#include <unistd.h> // mmm POSIX
#include <sys/mount.h>
#include <cerrno>
#include <iostream>
#include <fstream>
#include <csignal>
#include <sys/wait.h>

#include "inipp.h"

bool is_booting = true;

void print_status_screen();
void update_boot_screen(const std::string& msg);

void fatal_error(const std::string& err_msg);

sigset_t set;

// adapted from sinit
static void spawn(char *const argv[]) {
    int pid = fork();
    switch (pid) {
        case 0:
            // Unblock the signals because the child handles it, not us
            sigprocmask(SIG_UNBLOCK, &set, NULL);
            setsid();
            execvp(argv[0], argv); // spawn the child process!
            perror("execvp");
            _exit(1);
        case -1:
            perror("fork");
        default:
            std::cout << "Started Child Process with PID " << pid << std::endl;
    }
}

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
    std::cout << "Starting with processes: " << config_init << std::endl;

    sethostname("sineware-live", 13);

    if(mount(NULL, "/", NULL, MS_REMOUNT, NULL) != 0) { fatal_error("Remount /: " + std::to_string(errno)); }

    if(mount("/proc", "/root_a/proc", "proc", NULL, NULL) != 0) { fatal_error("Mount proc in chroot: " + std::to_string(errno)); }

    if(mount("/sys", "/root_a/sys/", NULL, MS_BIND | MS_REC, NULL) != 0) { fatal_error("Bind sys in chroot: " + std::to_string(errno)); }

    if(mount("/dev", "/root_a/dev/", NULL, MS_BIND | MS_REC, NULL) != 0) { fatal_error("Bind dev in chroot: " + std::to_string(errno)); }

//    system("cat /sineware-release");

//    std::cout << "Copyright (C) 2020 Seshan Ravikumar\n"
//                 "    This program comes with ABSOLUTELY NO WARRANTY.\n"
//                 "    This is free software, and you are welcome to redistribute it\n"
//                 "    under the conditions of the GNU GPLv3 or later.\n"
//                 "\n"
//                 "Development Build. For Evaluation Purposes Only." << std::endl;
//
//    std::cout << "Welcome to Sineware!\n"
//                 "(An administrative logon prompt is available on tty2, \n"
//                 "press Ctrl+Alt+F2 to access it)\n"
//                 "(Access to the Sineware Boot Environment is available on tty3)\n"
//                 "Go get your noodles!\n" << std::endl;


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

    // Block all signals we set (i.e make them caught by sigwait)
    sigprocmask(SIG_BLOCK, &set, NULL);

    int sig;

    char *const rcinitcmd[]  = { "/bin/bash", NULL }; // temp

    while(true) {
        spawn(rcinitcmd);

        is_booting = false;
        print_status_screen();

        sigwait(&set, &sig);
        int pid = waitpid(-1, NULL, WNOHANG);
        switch(sig) {
            case SIGINT:
                std::cout << "caught sigint" << std::endl;
                return 0;
            case SIGCHLD:
                std::cout << "caught sigchld (a child process has exited)" << std::endl;
                std::cout << "The Signal is " << sig << std::endl;
                std::cout << "The Child was " << pid << std::endl;
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
    std::cout << "\033[2J \u001B[1;1H"
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
    print_status_screen();
    std::cout << "\u001B[14;4H\u001b[33m" << msg << std::endl;
}

void fatal_error(const std::string& err_msg) {
    std::cout << "\033[2J \u001B[1;1H"
              << std::string(80, '-')
              << "Sineware has run into an unrecoverable error and had to stop.\n"
              << "Error: " << err_msg << "\n\n\n"
              << std::endl;
    while (true);
}