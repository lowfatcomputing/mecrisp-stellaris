// Filter to upload files to amforth from minicom
// Al Williams http://www.hotsolder.com
// Originally for the elf (if you were wondering about the names)
// 17 Sept 2010 -- Public Domain
// 22 Sept 2010 -- Added forced return at end of file
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <ctype.h>
#include <getopt.h>

// Minicom uploader has stdin connected to serial input,
// stdout connected to serial output
// stderr connects back to minicom
// exit code 0 for success or non zero for fail

// To set this up, use Control+AO and configure file transfer 
// protcols. Set a name and the program file name 
// Set Name=Y, U/D to U, FullScrn to N, IO-Red to Y, and Multi to N

// OR you can put this in /etc/minicom/minirc.amforth

/****************  Start file on line below
# Machine-generated file - use setup menu in minicom to change parameters.
pu pname10          YUNYNamforth
pu pprog10          am4up
pu baudrate         9600
pu bits             8
pu parity           N
pu stopbits         1
pu minit            
pu mreset           
pu backspace        BS
pu rtscts           No

 **************** Line above was the last line of the file */
// Then start minicom like this:
// minicom -w -D /dev/ttyUSB1 amforth
// This presumes you have am4up (this file compiled with gcc) on your path
// and you are using /dev/ttyUSB1.
// 
// To compile this file:
// gcc -o am4up am4up.c 
// Then copy the am4up executable to your path somewhere 

// The character pacing is handled by waiting for the echo
// The line pacing is handled by waiting for > or k
// A ? in the prompt output indicates an error
// Note you might still be in a defining word so 
// when you get an error you might have to enter a ; to get back
// to a normal prompt.

int meputc(int c, FILE *fdev) {
	return fdev != NULL ? putc(c,fdev) : putchar(c);
}

int megetc(FILE *fdev) {
	return fdev != NULL ? getc(fdev) : getchar();
}

// wait for prompt -- errc is an error character
void elfwait(int errc,FILE *fdev)
{
	int c;
	// wait for response
	while ((c=megetc(fdev))!='>' && c!='k') {
		fputc(c,stderr);
		if (c==errc) { fprintf(stderr,"\nError - %c\n",errc); exit(2); }
	}
	fputc(c,stderr);
}

int main(int argc, char *argv[])
{
	FILE *f=NULL,*fdev=NULL;
	time_t t0,t1;
	int c;
	int lastchar;
	//fprintf(stderr,"am4up V2 by Al Williams\nhttp://www.hotsolder.com\nUploading ");
	/*if (argc<1) {
		fprintf(stderr,"%s...\n",argv[1]);
	}*/
	while ((c = getopt (argc, argv, "d:")) != -1) {
		switch (c) {
			case 'd':
				fdev=fopen(optarg,"a+");
				break;
			default:
				fdev=NULL;
				break;
		}
	}
	time(&t0);
	for (int index = optind; index < argc; index++) {
		fprintf(stderr,"\033[4mReading %s\033[0m\n",argv[index]);
		f=fopen(argv[index],"r");
		if (!f) { fprintf(stderr, "No file\n"); exit(1); }
		meputc('\r',fdev); meputc('\n',fdev);
		elfwait('\0',fdev);
		lastchar='\n';
		while (lastchar!=EOF) {
			int c1;
			c=getc(f);
			if (c==EOF && lastchar=='\n') break;
			// newline == CRLF
			if ((c=='\n'||c=='\r') && lastchar=='\n') continue; // blank line
			if (c=='\\' && lastchar=='\n') {
				// comment
				while (c!='\n' && c!=EOF) c=getc(f);
				if (c==EOF) break;
				continue;
			}
			// remember  last character except leading blanks
			if (c==EOF || lastchar!='\n' || !isspace(c)) lastchar=c;
			if (c=='\t') c=' ';
			if (c=='\r') c='\n';
			if (c==EOF) c='\n';  // final return
			meputc(c,fdev);
			// read echo
			do {
				c1=megetc(fdev); 
				fputc(c1,stderr);
			} while (c1!=c);

			if (c=='\r' || c==EOF) {
				elfwait('?',fdev);
			}
		}
	}
	time(&t1);
	fprintf(stderr,"\n\033[4mTransfer time=%ld seconds\033[0m\n",t1-t0);

	return 0;
}
