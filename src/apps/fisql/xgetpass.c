#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <unistd.h>
#include <termios.h>
#include "xgetpass.h"

#define CHUNK 512

char *
xgetpass(const char *prompt)
{
  FILE *ttyfp;
  char *buf;
  int buflen;
  int bufidx = 0;
  volatile struct termios oterm;
  struct termios nterm;
  char c;
  int literal = 0;
  char chunkbuf[CHUNK];
  char *chunkp;
  int rc;

  if ((ttyfp = fopen(ctermid((char *) NULL), "w+")) == NULL) {
    return NULL;
  }
  if ((tcgetattr(fileno(ttyfp), (struct termios *) &oterm)) == -1) {
    return NULL;
  }
  nterm = oterm;
  nterm.c_lflag &= ~(ICANON|ECHO);
  nterm.c_cc[VMIN] = 1;
  nterm.c_cc[VTIME] = (signed char) -1;
  if ((tcsetattr(fileno(ttyfp), TCSANOW, (struct termios *) &nterm)) == -1) {
    return NULL;
  }
  if ((buf = malloc((CHUNK + 1) * sizeof(char))) == NULL) {
    return NULL;
  }
  buflen = CHUNK;
  fputs(prompt, stderr);
  fflush(stderr);
  while ((rc = read(fileno(ttyfp), chunkbuf, CHUNK)) >= 0) {
    for (chunkp = chunkbuf; chunkp < (chunkbuf + rc); chunkp++) {
      c = *chunkp;
      if (!literal && (c == oterm.c_cc[VERASE])) {
	if (bufidx) bufidx--;
      } else if (!literal && (c == oterm.c_cc[VKILL])) {
	bufidx = 0;
      } else if (!literal && (c == oterm.c_cc[VEOF])) {
	if (bufidx == 0) {
	  tcsetattr(fileno(ttyfp), TCSANOW, (struct termios *) &oterm);
	  free(buf);
	  return NULL;
	}
      } else if (!literal && ((c == oterm.c_cc[VEOL])
			      || (c == oterm.c_cc[VEOL2])
			      || (c == '\n'))) {
	buf[bufidx] = '\0';
	if ((tcsetattr(fileno(ttyfp), TCSANOW,
		       (struct termios *) &oterm)) == -1) {
	  free(buf);
	  return NULL;
	}
	fputc('\n', stderr);
	return buf;
      } else if (!literal && ((c == oterm.c_cc[VSTART])
			      || (c == oterm.c_cc[VSTOP])
			      || (c == oterm.c_cc[VDISCARD])
			      || (c == oterm.c_cc[VREPRINT]))) {
	/* nop */
      } else if (!literal && (c == oterm.c_cc[VWERASE])) {
	while (bufidx && (!(isspace(buf[bufidx])))) {
	  bufidx--;
	}
      } else if (!literal && (c == oterm.c_cc[VLNEXT])) {
	literal = 2;
      } else {
	buf[bufidx] = c;
	bufidx++;
	if (buflen == bufidx) {
	  buflen += CHUNK;
	  if ((buf = realloc(buf, (buflen + 1) * sizeof(char))) == NULL) {
	    tcsetattr(fileno(ttyfp), TCSANOW, (struct termios *) &oterm);
	    return NULL;
	  }
	}
      }
      if (literal > 0) literal--;
    }
  }
  tcsetattr(fileno(ttyfp), TCSANOW, (struct termios *) &oterm);
  free(buf);
  return NULL;
}