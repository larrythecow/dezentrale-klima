/* 
 * File:   file.h
 * Author: sid
 *
 * Created on November 9, 2012, 4:15 PM
 */

#ifndef FILE_H
#define	FILE_H

FILE * fileopen(const char *filename, const char *modes, const char *message);
int fileclose(FILE *fp, const char *message);

#endif	/* FILE_H */

