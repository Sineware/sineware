//
// Created by Seshan Ravikumar on 2020-11-23.
//
#include <string>
#ifndef SINEWARE_INIT_RUNNING_PROCESS_H
#define SINEWARE_INIT_RUNNING_PROCESS_H


class running_process {
public:
    std::string name;

    std::string exec;
    std::vector<std::string> argv;

    std::string type;

    int level;

    int pid;
};


#endif //SINEWARE_INIT_RUNNING_PROCESS_H
