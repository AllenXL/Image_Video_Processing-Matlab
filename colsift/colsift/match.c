/************************************************************************
  Copyright (c) 2004. David G. Lowe, University of British Columbia.
  This software is being made available for research purposes only
  (see file LICENSE for conditions).  This notice must be retained on
  all copies and modified versions of this software.
*************************************************************************/
/************************************************************************
  ADAPTED for color sift by Jan-Mark Geusebroek, University of Amsterdam.
  These adaptations are being made available for research purposes only
  (see file LICENSE for conditions).  This notice must be retained on
  all copies and modified versions of this software.
*************************************************************************/

/* match.c:
   This file contains an example program to match two keypoint descriptions.
*/

#include "keycol.h"

/* -------------------- Local function prototypes ------------------------ */
Keypoint ReadKeypoints(FILE *fp);
int MatchKeypoints(Keypoint keys1, Keypoint keys2, FILE *out);


/*----------------------------- Routines ----------------------------------*/


/* Top level routine.  Read two keypoint files and calculate their
   matching score.
   Either report the number of matches, or output to file.
*/

int main (int argc, char **argv)
{
    int arg = 0, printusage = 1;
    Keypoint k1, k2, k;
    FILE *in1 = 0, *in2 = 0, *out = 0;
    int  count = 0;

    /* Parse command line arguments.  */
    while (++arg < argc) {
      if (! strcmp(argv[arg], "-keys1") ||
          ! strcmp(argv[arg], "-k1")) {
        in1 = fopen(argv[arg+1], "r");
        arg++;
      }
      else if (! strcmp(argv[arg], "-keys2") ||
            !strcmp(argv[arg], "-k2")) {
        in2 = fopen(argv[arg+1], "r");
        arg++;
      }
      else if (! strcmp(argv[arg], "-out")) {
        out = fopen(argv[arg+1], "w");
        arg++;
      }
      else {
        if (argc>1)
          fprintf(stderr, "Invalid command line argument: %s\n", argv[arg]);
        printusage=2;
      }
    }

    if (in1 && in2 && printusage==1)
        printusage=0;

    if (printusage) {
      fprintf(stderr,
        "use: %s -keys1 [keyfile] -keys2 [keyfile] {-out [outfile]}\n",
        argv[0]);
      exit(1);
    }

    k1 = ReadKeypoints(in1);
    k2 = ReadKeypoints(in2);

    if (out) {
        for (k = k1; k != NULL; k = k->next)
            count++;
        fprintf(out, "%d\n", count);
    }

    count = MatchKeypoints(k1, k2, out);

    printf("%d matches\n", count);

    return 0;
}

Keypoint ReadKeypoints(FILE *fp)
{
    int i, j, count = 0, len = 0, col = 0;
    Keypoint k = NULL, keys = NULL;
	char buf[128];

	if (!fp)
		return NULL;

	fgets(buf, 128, fp);
	sscanf(buf, "%d %d %d\n", &count, &len, &col);

	if (len != VecLength)
		return NULL;

    /* Read data for each keypoint. */
	for (j=0; j<count; j++) {
	  if (!keys) {
		k = calloc(1,sizeof(*k));
	  	keys = k;
	  }
	  else {
		k->next = calloc(1,sizeof(*k));
		k = k->next;
	  }
	  k->next = NULL;
      fscanf(fp, "%f %f %f %f", &k->row, &k->col, &k->scale,
	      &k->ori);
	  k->ivec = malloc(sizeof(*k->ivec)*len);
	  for (i = 0; i < len; i++) {
	    fscanf(fp, " %d", &(k->ivec[i]));
	  }
	  if (col>=2) {
		  k->ybvec = malloc(sizeof(*k->ybvec)*len);
		  for (i = 0; i < len; i++) {
			fscanf(fp, " %d", &(k->ybvec[i]));
		  }
	  }
	  if (col>=3) {
		  k->rgvec = malloc(sizeof(*k->rgvec)*len);
		  for (i = 0; i < len; i++) {
			fscanf(fp, " %d", &(k->rgvec[i]));
		  }
	  }
    }

	fclose (fp);

	return keys;
}

int MatchKeypoints(Keypoint keys1, Keypoint keys2, FILE *out)
{
    int dsq, dsqyb, dsqrg, distsq1, distsq2;
    Keypoint k1, k2, best;
    unsigned char *pk1, *pk2;
    int i, dif;
    int count = 0, n1 = 0, n2 = 0;

    /* Find the two closest matches, and put their squared distances in
       distsq1 and distsq2.
    */
    for (k1 = keys1; k1 != NULL; k1 = k1->next) {
      distsq1 = 1000000000;
      distsq2 = 1000000000;

      for (k2 = keys2; k2 != NULL; k2 = k2->next) {
        dsq = 0;

        pk1 = k1->ivec;
        pk2 = k2->ivec;

        for (i = 0; i < 128; i++) {
          dif = (int) *pk1++ - (int) *pk2++;
          dsq += dif * dif;
        }

        /* check color vectors */
        dsqyb = 0;

        pk1 = k1->ybvec;
        pk2 = k2->ybvec;

        if (pk1 && pk2) {
          for (i = 0; i < 128; i++) {
            dif = (int) *pk1++ - (int) *pk2++;
            dsqyb += dif * dif;
          }
        }

        dsqrg = 0;

        pk1 = k1->rgvec;
        pk2 = k2->rgvec;

        if (pk1 && pk2) {
          for (i = 0; i < 128; i++) {
            dif = (int) *pk1++ - (int) *pk2++;
            dsqrg += dif * dif;
          }
        }

        dsq += (int)(dsqyb+dsqrg);
        if (dsq < distsq1) {
          distsq2 = distsq1;
          distsq1 = dsq;
          best = k2;
        } else if (dsq < distsq2) {
          distsq2 = dsq;
        }
      }

      /* Check whether closest distance is less than 0.6 of second. */
      if (out) {
        fprintf(out, "%4.2f %4.2f %4.2f %4.3f  ", k1->row, k1->col, k1->scale,
          k1->ori);
        fprintf(out, "  %4.2f %4.2f %4.2f %4.3f ", best->row, best->col, best->scale,
          best->ori);
      }

      if (10 * 10 * distsq1 < 6 * 6 * distsq2) {
        count++;
        if (out)
            fprintf(out, " * %.2f\n", sqrt(distsq1));
      }
      else if (out)
            fprintf(out, " _ %.2f\n", sqrt(distsq1));
    }

    return count;
}
