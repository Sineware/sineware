# Sineware Init
PID 1, aka the init system, for Sineware.

On a day to day, it's responsible for basic hardware bring-up and housekeeping, creating mountpoints, validating everything, then switching over to the 
Adelie RootFS on the correct A/B folder.

It's also responsible for the reverse (aka shutting down the machine).

Written in C++!