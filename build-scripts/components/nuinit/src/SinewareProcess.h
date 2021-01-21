//
// Created by Seshan Ravikumar on 2020-11-30.
//

#ifndef NUINIT_SINEWAREPROCESS_H
#define NUINIT_SINEWAREPROCESS_H
class SinewareProcess {
private:

public:
    SinewareProcess(std::string exec, std::vector<std::string> argv);
    bool spawn();

    std::string exec;
    std::vector<std::string> argv;
    bool started = false;
    int pid;
};
#endif //NUINIT_SINEWAREPROCESS_H
