//
// Created by Seshan Ravikumar on 2020-12-01.
//
#include <string>
#include <vector>
#include "SinewareProcess.h"

SinewareProcess::SinewareProcess(std::string cexec, std::vector<std::string> cargv) {
    exec = cexec;
    argv = cargv;

    started = false;
}

bool SinewareProcess::spawn() {
    return false;
}