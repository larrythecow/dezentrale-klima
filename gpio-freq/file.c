#include <stdio.h>
#include <stdlib.h>
#include <sys/inotify.h>
#include "global.h"
#include "file.h"

/*###########################################################################
file open 
###########################################################################*/
FILE * fileopen(const char *filename, const char *modes, const char *message) {
    static FILE *fp;
#ifdef DEBUGFILE
    printf("\ttry to open:\t%s\n", filename);
#endif
    if (((fp = fopen(filename, modes)) == NULL)) {
        printf("\t\tPANIC: Could not open file %s\n", message);
#ifndef DEBUGGPIO
        exit(-1);
    }
#endif
#ifdef DEBUGFILE
    printf("\t\topen successful\n");
#endif
    return fp;
}

/*###########################################################################
file close
###########################################################################*/
int fileclose(FILE *fp, const char *message) {
    if (fclose(fp) == EOF) {
        printf("\t\tWARNING: Could not close:\t%s\n", message);
    }
    return 0;
}
