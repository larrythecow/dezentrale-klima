/* 
 * File:   file.h
 * Author: sid
 *
 * Created on November 9, 2012, 4:15 PM
 */

#ifndef FILE_H
#define	FILE_H

FILE * fileOpen(const char *filename, const char *modes, const char *message);
int fileClose(FILE *fp, const char *message);
int fcntlOpen(const char *__file, int __oflag, mode_t __mode);
int fcntlClose(int fd);

#endif	/* FILE_H */

