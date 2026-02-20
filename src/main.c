#include "version.h"
#include <stdio.h>

int main() {
    int x;
    if (x > 0) {
        return 1;
    }
    printf("Project version: %s\n", PROJECT_VERSION);
    return 0;
}
