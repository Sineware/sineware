// Go get your noodles...
#include <iostream>
#include <vector>
#include <unistd.h>

#include "SinewareProcess.h"

// Globals
std::vector<SinewareProcess> running_procs;

void fatal_error(int code, const char* friendly_msg) {
    printf("NuInit ERROR: %i %s\n", code, friendly_msg);
    while (1);
}

int main() {
    printf("Welcome to Sineware NuInit...\n");
    std::vector<std::string> argv;
    SinewareProcess s("/bin/sh", argv);




    fatal_error(-1, "NuInit has exited");
}