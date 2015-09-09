// Code Written by B S SasiKanth, Indian Institute of Technology Guwahati.
// Website: www.bsasikanth.com
// E-Mail:  bsasikanth@gmail.com
// 
// This function computes the Modified Hausdorff Distance (MHD) which is 
// proven to function better than the directed HD as per Dubuisson et al. 
// in the following work:
// 
// M. P. Dubuisson and A. K. Jain. A Modified Hausdorff distance for object 
// matching. In ICPR94, pages A:566-568, Jerusalem, Israel, 1994.
// http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=576361
// 
// The function computed the forward and reverse distances and outputs the 
// minimum of both.
// 
// Format for calling function:
// 
// MHD = ModHausdorffDist(A,B);
// 
// where
// MHD = Modified Hausdorff Distance.
// A -> Point set 1
// B -> Point set 2
// 
// No. of samples of each point set may be different but the dimension of
// the points must be the same.

#include <math.h>
#include <mex.h>

#if !defined(MAX)
#define	MAX(A, B)	((A) > (B) ? (A) : (B))
#endif


void mexFunction(int nlhs, mxArray *plhs[],	int nrhs, const mxArray *prhs[]) {
    
    // Mapping inputs and outputs
    
    double *mhd, *A, *B, mindist, tempdist;
    int i, j;
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    A = mxGetPr(prhs[0]);
    B = mxGetPr(prhs[1]);
    mhd = mxGetPr(plhs[0]);
    
    // Get the sizes of the input arrays
    
    size_t Arows, Acols, Brows, Bcols;
    Arows = mxGetM(prhs[0]);
    Acols = mxGetN(prhs[0]);
    Brows = mxGetM(prhs[1]);
    Bcols = mxGetN(prhs[1]);
    
    // Check for same dimensions
    
    if(Acols != Bcols)
    mexErrMsgTxt("The dimensions of the points in the two feature vectors are different");
    
    // Calculate the forward HD
    
    double fhd=0;
    
    for(i=0;i<Arows;i++) {
        mindist = 9999999;
        for(j=0;j<Brows;j++) {
            tempdist = sqrt(((A[i]-B[j])*(A[i]-B[j])) + ((A[Arows+i]-B[Brows+j])*(A[Arows+i]-B[Brows+j])));
            if(tempdist<mindist)
                mindist=tempdist;
        }
        fhd = fhd + mindist;
    }
    fhd = fhd/Arows;
    
    // Calculate the reverse HD
    
    double rhd=0;
    
    for(i=0;i<Brows;i++) {
        mindist = 9999999;
        for(j=0;j<Arows;j++) {
            tempdist = sqrt(((A[j]-B[i])*(A[j]-B[i])) + ((A[Arows+j]-B[Brows+i])*(A[Arows+j]-B[Brows+i])));
            if(tempdist<mindist)
                mindist=tempdist;
        }
        rhd = rhd + mindist;
    }
    rhd = rhd/Brows;
    
    mhd[0] = MAX(fhd,rhd);
    
    
}