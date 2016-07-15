#include "mex.h"
#include "math.h"
#include "string.h"
#define absd(a) ((a)>(-a)?(a):(-a))
#define EPS 1e-15
#ifndef min
#define min(a, b)        ((a) < (b) ? (a): (b))
#endif
#ifndef max
#define max(a, b)        ((a) > (b) ? (a): (b))
#endif
#define clamp(a, b1, b2) min(max(a, b1), b2);

/*
 * This function BCFCM2D, segments (clusters) an image in object classes,
 * and estimates the bias field.
 *
 * It's an implementation of the paper of M.N. Ahmed et. al. "A Modified Fuzzy
 * C-Means Algorithm for Bias Field estimation and Segmentation of MRI Data"
 * 20002, IEEE Transactions on medical imaging.
 *
 * [U,B]=BCFCM2D(Y,v,Options)
 *
 * Inputs,
 *   Y : The 2D input image greyscale or color, of type double
 *   v : Class prototypes. A vector with approximations of the greyscale
 *       means of all image classes.
 *   Options : A struct with options
 *   Options.epsilon : The function stops if difference between class means
 *                   of two itterations is smaller than epsilon
 *   Options.alpha : Scales the effect of neighbours, must be large if
 *                   it is a noisy image, default 1.
 *   Options.maxit : Maximum number of function itterations
 *   Options.sigma : Sigma of Gaussian smoothing of the bias field (slow
 *                   varying non uniform illumination in CT or MRI scan).
 *   Options.p : Norm constant FCM objective function, must be larger than one
 *               defaults to 2.
 * Outputs,
 *   U : Fuzzy Partition matrix (Class membership)
 *   B : The estimated bias field
 *
 * Example,
 *
 * % Load test image
 *   Y=im2double(imread('test_biasfield_noise.png'));
 * % Class prototypes (means)
 *   v = [0.42 0.56 0.64];
 * % Do the fuzzy clustering
 *   [U,B]=BCFCM2D(Y,v,struct('maxit',5,'epsilon',1e-5));
 * % Show results
 *   figure,
 *   subplot(2,2,1), imshow(Y), title('input image');
 *   subplot(2,2,2), imshow(U), title('Partition matrix');
 *   subplot(2,2,3), imshow(B,[]), title('Estimated biasfield');
 *   subplot(2,2,4), imshow(Y-B), title('Corrected image');
 *
 * Function is written by D.Kroon University of Twente (November 2009)
 */

__inline double pow2(double a) { return a*a; }
__inline double nonzero(double a) { return (absd(a)>EPS?a:EPS); }

struct options {
    double p;
    double alpha;
    double epsilon;
    double sigma;
    int maxit;
};
void setdefaultoptions(struct options* t) {
    t->p=2.0;
    t->alpha=1.0;
    t->epsilon=0.01;
    t->sigma=2.0;
    t->maxit=10;
}

double * mallocd(int a) {
    double *ptr = malloc(a*sizeof(double));
    if (ptr == NULL) { mexErrMsgTxt("Out of Memory"); }
    return ptr;
}

void imfilter1D_double(double *I, int lengthI, double *H, int lengthH, double *J) {
    int x, i, index, offset;
    int b2, offset2;
    if(lengthI==1) {
        J[0]=I[0];
    }
    else {
        offset=(lengthH-1)/2;
        for(x=0; x<min(offset, lengthI); x++) {
            J[x]=0;
            b2=lengthI-1; offset2=x-offset;
            for(i=0; i<lengthH; i++) {
                index=clamp(i+offset2, 0, b2); J[x]+=I[index]*H[i];
            }
        }
        
        for(x=offset; x<(lengthI-offset); x++) {
            J[x]=0;
            b2=lengthI-1; offset2=x-offset;
            for(i=0; i<lengthH; i++) {
                index=i+offset2; J[x]+=I[index]*H[i];
            }
        }
        
        b2=lengthI-1;
        for(x=max(lengthI-offset, offset); x<lengthI; x++) {
            J[x]=0;
            offset2=x-offset;
            for(i=0; i<lengthH; i++) {
                index=clamp(i+offset2, 0, b2); J[x]+=I[index]*H[i];
            }
        }
        
    }
}

void imfilter2D_double(double *I, int * sizeI, double *H, int lengthH, double *J) {
    int y, x, i, y2;
    double *Irow, *Crow;
    int index=0, line=0;
    double *RCache;
    int *nCache;
    int hks, offset, offset2;
    RCache=(double *)malloc(lengthH*sizeI[0]*sizeof(double));
    for(i=0; i<lengthH*sizeI[0]; i++) { RCache[i]=0; }
    nCache=(int *)malloc(lengthH*sizeof(int));
    for(i=0; i<lengthH; i++) { nCache[i]=0; }
    hks=((lengthH-1)/2);
    for(y=0; y<min(hks, sizeI[1]); y++) {
        Irow=&I[index];
        Crow=&RCache[line*sizeI[0]];
        imfilter1D_double(Irow, sizeI[0], H, lengthH, Crow);
        index+=sizeI[0];
        if(y!=(sizeI[1]-1)) {
            line++; if(line>(lengthH-1)) { line=0; }
        }
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }
    for(y2=y; y2<hks; y2++) {
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }
    
    for(y=hks; y<(sizeI[1]-1); y++) {
        Irow=&I[index];
        Crow=&RCache[line*sizeI[0]];
        imfilter1D_double(Irow, sizeI[0], H, lengthH, Crow);
        offset=(y-hks)*sizeI[0]; offset2=nCache[0]*sizeI[0];
        for(x=0; x<sizeI[0]; x++) { J[offset+x]=RCache[offset2+x]*H[0]; }
        for(i=1; i<lengthH; i++) {
            offset2=nCache[i]*sizeI[0];
            for(x=0; x<sizeI[0]; x++) { J[offset+x]+=RCache[offset2+x]*H[i]; }
        }
        index+=sizeI[0];
        line++; if(line>(lengthH-1)) { line=0; }
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }
    
    for(y=max(sizeI[1]-1, hks); y<sizeI[1]; y++) {
        Irow=&I[index];
        Crow=&RCache[line*sizeI[0]];
        imfilter1D_double(Irow, sizeI[0], H, lengthH, Crow);
        offset=(y-hks)*sizeI[0]; offset2=nCache[0]*sizeI[0];
        for(x=0; x<sizeI[0]; x++) { J[offset+x]=RCache[offset2+x]*H[0]; }
        for(i=1; i<lengthH; i++) {
            offset2=nCache[i]*sizeI[0];
            for(x=0; x<sizeI[0]; x++) { J[offset+x]+=RCache[offset2+x]*H[i]; }
        }
        index+=sizeI[0];
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }
    
    for(y=max(sizeI[1], hks); y<(sizeI[1]+hks); y++) {
        offset=(y-hks)*sizeI[0]; offset2=nCache[0]*sizeI[0];
        for(x=0; x<sizeI[0]; x++) { J[offset+x]=RCache[offset2+x]*H[0]; }
        for(i=1; i<lengthH; i++) {
            offset2=nCache[i]*sizeI[0];
            for(x=0; x<sizeI[0]; x++) { J[offset+x]+=RCache[offset2+x]*H[i]; }
        }
        index+=sizeI[0];
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }
    
    free(RCache);
}

void GaussianFiltering2D_double(double *I, double *J, int *dimsI, double sigma, double kernel_size) {
    int kernel_length, i;
    double x, *H, totalH=0;
    
    /* Construct the 1D gaussian kernel */
    if(kernel_size<1) { kernel_size=1; }
    kernel_length=(int)(2*ceil(kernel_size/2)+1);
    H = (double *)malloc(kernel_length*sizeof(double));
    x=-ceil(kernel_size/2);
    for (i=0; i<kernel_length; i++) { H[i]=exp(-((x*x)/(2*(sigma*sigma)))); totalH+=H[i]; x++; }
    for (i=0; i<kernel_length; i++) { H[i]/=totalH; }
    
    /* Do the filtering */
    imfilter2D_double(I, dimsI, H, kernel_length, J);
    /* Clear memory gaussian kernel */
    free(H);
}

/* The matlab mex function */
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
    double *Y, *v, *vin, *v_old, *U, *Up, *B, *B2, *Bout, *Uout, *D, *Gamma;
    double *Yr, *Yg, *Yb;
    double *Br, *Br2, *vr, *vr_old, *Bg, *Bg2, *vg, *vg_old , *Bb, *Bb2, *vb, *vb_old;
    double p, pinv, alpha, alphan, epsilon, sigma;
    int maxit, c;
    
    const mwSize *dimsY;
    const mwSize *dimsc;
    int sizeY[3];
    int sizeU[3];
    struct options Options;
    double temp;
    int field_num;
    int i, j, k;
    int xd, yd, x, y;
    int N, Nr;
    int itt;
    int index;
    double s, s2, sr , sg, sb, sr2, sg2, sb2;
    double a, b;
    double nomt, nomtr, nomtb, nomtg, dent;
    int Nind[8];
    double diff;
    int ind;
    double *nom, *nomr, *nomg, *nomb, *den;
    
    /* Check properties of image I */
    if((mxGetNumberOfDimensions(prhs[0])<2)||(mxGetNumberOfDimensions(prhs[0])>3)) {
        mexErrMsgTxt("Image must be 2D grayscale or color");
    }
    if(!mxIsDouble(prhs[0])){ mexErrMsgTxt("Image must be double"); }
    dimsY = mxGetDimensions(prhs[0]);
    sizeY[0]=dimsY[0]; sizeY[1]=dimsY[1];
    if(mxGetNumberOfDimensions(prhs[0])>2) {
        if(dimsY[2]!=3) { mexErrMsgTxt("Image must be 2D grayscale or color"); }
        sizeY[2]=3;
    }
    else { sizeY[2]=1; }
    
    /* Check properties of parameters*/
    if(!mxIsDouble(prhs[1])){ mexErrMsgTxt("Parameters must be double"); }
    
    /* Check options */
    setdefaultoptions(&Options);
    if(nrhs==3) {
        if(!mxIsStruct(prhs[2])){ mexErrMsgTxt("Options must be structure"); }
        field_num = mxGetFieldNumber(prhs[2], "p");
        if(field_num>=0) {
            Options.p=mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
        }
        field_num = mxGetFieldNumber(prhs[2], "alpha");
        if(field_num>=0) {
            Options.alpha=mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
        }
        field_num = mxGetFieldNumber(prhs[2], "epsilon");
        if(field_num>=0) {
            Options.epsilon=mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
        }
        field_num = mxGetFieldNumber(prhs[2], "sigma");
        if(field_num>=0) {
            Options.sigma=mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
        }
        field_num = mxGetFieldNumber(prhs[2], "maxit");
        if(field_num>=0) {
            Options.maxit=(int)mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
        }
    }
    
    
    /* Assign pointers to each input. */
    Y=(double *)mxGetData(prhs[0]);
    vin=(double *)mxGetData(prhs[1]);
    
    // Number of pixels
    N=(int)dimsY[0]*dimsY[1];
    
    if(sizeY[2]==3) {
        Yr = &Y[0]; Yg = &Y[N]; Yb = &Y[2*N];
    }
    // Number of classes
    dimsc = mxGetDimensions(prhs[1]);
    if(sizeY[2]==1) { c=(int)mxGetNumberOfElements(prhs[1]); } else { c=dimsc[0]; }
    
    // Create a copy of the read-only input v
    if(sizeY[2]==1) {  v=mallocd(c); for(i=0; i<c; i++) { v[i]=vin[i]; } }
    else {
        vr=mallocd(c);  vg=mallocd(c);  vb=mallocd(c);
        for(i=0; i<c; i++) { vr[i]=vin[i]; vg[i]=vin[i+c]; vb[i]=vin[i+c*2]; }
    }
    
    // Step 1, intialization
    
    // Constant in FCM objective function , must be larger than 1
    p = Options.p;
    
    // Effect of neighbors
    alpha = Options.alpha;
    
    // Stop if difference between current and previous class prototypes
    // is smaller than epsilon
    epsilon = Options.epsilon;
    
    // Bias field Gaussian smoothing sigma
    sigma= Options.sigma;
    
    // Maximun number of iterations
    maxit = Options.maxit;
    
    // Previous class prototypes (means)
    if(sizeY[2]==1) { v_old=mallocd(c); }
    else { vr_old=mallocd(c); vg_old=mallocd(c); vb_old=mallocd(c); }
    
    // Bias field estimate
    if(sizeY[2]==1) { B = mallocd(N); for(i=0; i<N; i++) { B[i]=1e-4; } }
    else {
        Br = mallocd(N); Bg = mallocd(N);  Bb = mallocd(N);
        for(i=0; i<N; i++) { Br[i]=1e-4; Bg[i]=1e-4;  Bb[i]=1e-4;  }
    }
    // Partition matrix
    U = mallocd(c*N);
    Up = mallocd(c*N);
    
    // Distance to clusters
    D = mallocd(c);
    
    // Number of neighbours
    Nr =8;
    
    // Neighbour class influence
    Gamma =  mallocd(c);
    
    //Init variables
    if(sizeY[2]==1) { nom = mallocd(c); }
    else { nomr = mallocd(c); nomg = mallocd(c); nomb = mallocd(c); }
    den = mallocd(c);
    
    // pre-calculate
    pinv=1/(p-1);
    
    
    alphan= alpha/((double)Nr);
    itt=0;
    diff=epsilon+1.0;
    while((diff>=epsilon)&&(itt<=maxit)) {
        itt++;
        
        // Cluster update storage
        if(sizeY[2]==1) { for(i=0;i<c;i++) { nom[i]=0; den[i]=0; }  }
        else { for(i=0;i<c;i++) { nomr[i]=0; nomg[i]=0; nomb[i]=0; den[i]=0; } }
        
        // Loop through all pixels
        k=0;
        for(yd=0; yd<sizeY[1]; yd++) {
            for(xd=0; xd<sizeY[0]; xd++) {
                index=k*c;
                
                // Get neighbour pixel indices
                x=min(max(xd, 1), sizeY[0]-2); y=min(max(yd, 1), sizeY[1]-2);
                ind=x+y*sizeY[0];
                Nind[0]=ind-1; Nind[1]=ind+1;
                Nind[2]=ind-sizeY[0]; Nind[3]=Nind[2]-1; Nind[4]=Nind[2]+1;
                Nind[5]=ind-sizeY[0]; Nind[6]=Nind[5]-1; Nind[7]=Nind[5]+1;
                
                // Calculate distance to class means for each (bias corrected) pixel and neighbours
                if(sizeY[2]==1) {
                    for(i=0;i<c;i++) {
                        Gamma[i]=0; for(j=0;j<Nr; j++) { Gamma[i]+=pow2( Y[Nind[j]]-B[Nind[j]] - v[i] ); }
                        D[i] = pow2( Y[k]-B[k]-v[i] );
                    }
                    
                    // step 3a, update the prototypes (means) of the clusters
                    s2=0; for(j=0;j<Nr; j++) { s2+=Y[Nind[j]]-B[Nind[j]]; }
                    s = (Y[k]-B[k]) + alphan*s2;
                }
                else {
                    
                    for(i=0;i<c;i++) {
                        Gamma[i]=0;
                        for(j=0;j<Nr; j++) {
                            Gamma[i]+=pow2( Yr[Nind[j]]-Br[Nind[j]] - vr[i] );
                            Gamma[i]+=pow2( Yg[Nind[j]]-Bg[Nind[j]] - vg[i] );
                            Gamma[i]+=pow2( Yb[Nind[j]]-Bb[Nind[j]] - vb[i] );
                        }
                        D[i]  = pow2(Yr[k]-Br[k]-vr[i]) + pow2(Yg[k]-Bg[k]-vg[i]) + pow2(Yb[k]-Bb[k]-vb[i]);
                        
                    }
                    // step 3a, update the prototypes (means) of the clusters
                    sr2=0; sg2=0; sb2=0;
                    for(j=0;j<Nr; j++) {
                        sr2+=Yr[Nind[j]]-Br[Nind[j]]; 
						sg2+=Yg[Nind[j]]-Bg[Nind[j]]; 
						sb2+=Yb[Nind[j]]-Bb[Nind[j]];
                    }
                    sr = (Yr[k]-Br[k]) + alphan*sr2; 
					sg = (Yg[k]-Bg[k]) + alphan*sg2;
					sb = (Yb[k]-Bb[k]) + alphan*sb2;
                }
                
                
                // step 2, Calculate robust partition matrix
                for(i=0;i<c;i++) {
                    dent=0;
                    a = D[i] + alphan * Gamma[i];
                    for(j=0;j<c;j++) {
                        b = D[j] + alphan * Gamma[j];
                        dent += pow(a/nonzero(b), pinv);
                    }
                    
                    U[i+index] = 1 / nonzero(dent); Up[i+index] = pow(U[i+index], p);
                    
                    // step 3b, update the prototypes (means) of the clusters
                    if(sizeY[2]==1) { nom[i]+=Up[i+index]*s; }
                    else { 
						nomr[i]+=Up[i+index]*sr; 
						nomg[i]+=Up[i+index]*sg; 
						nomb[i]+=Up[i+index]*sb; 
					}
                    den[i]+=Up[i+index];
                }
                
                k++;
            }
        }
        
        
        // Step 3c, update the prototypes (means) of the clusters
        if(sizeY[2]==1){
            for(i=0;i<c;i++) {
                v_old[i]=v[i]; v[i]=nom[i]/((1+alpha)*nonzero(den[i]));
            }
        }
        else {
            for(i=0;i<c;i++) {
                temp=((1+alpha)*nonzero(den[i]));
			    vr_old[i]=vr[i];  vg_old[i]=vg[i]; vb_old[i]=vb[i];
                vr[i]=nomr[i]/temp; vg[i]=nomg[i]/temp; vb[i]=nomb[i]/temp;
			}
        }
        
        // step 4, Estimate the (new) Bias-Field
        if(sizeY[2]==1){
            for(k=0; k<N; k++) {
                nomt=0; dent=0;
                index=k*c;
                for(i=0; i<c; i++) { nomt+=Up[i+index]*v[i]; dent+=Up[i+index]; }
                B[k]=Y[k] - nomt/nonzero(dent);
            }
        }
        else {
            for(k=0; k<N; k++) {
                nomtr=0; nomtg=0; nomtb=0; dent=0;
                index=k*c;
                for(i=0; i<c; i++) {
                    nomtr+=Up[i+index]*vr[i];
                    nomtg+=Up[i+index]*vg[i];
                    nomtb+=Up[i+index]*vb[i];
                    dent+=Up[i+index];
                }
                Br[k]=Yr[k] - nomtr/nonzero(dent);
                Bg[k]=Yg[k] - nomtg/nonzero(dent);
                Bb[k]=Yb[k] - nomtb/nonzero(dent);
            }
        }
        
        // Low-pass filter Bias-Field, as regularization
        if(sigma>0) {
            if(sizeY[2]==1){
                B2=mallocd(N); GaussianFiltering2D_double(B, B2, sizeY, sigma, ceil(sigma*6)); free(B); B=B2;
            }
            else{
                Br2=mallocd(N); GaussianFiltering2D_double(Br, Br2, sizeY, sigma, ceil(sigma*6)); free(Br); Br=Br2;
                Bg2=mallocd(N); GaussianFiltering2D_double(Bg, Bg2, sizeY, sigma, ceil(sigma*6)); free(Bg); Bg=Bg2;
                Bb2=mallocd(N); GaussianFiltering2D_double(Bb, Bb2, sizeY, sigma, ceil(sigma*6)); free(Bb); Bb=Bb2;
            }
        }
        
        // Difference in cluster intensities
        diff=0;
        if(sizeY[2]==1){
            for(i=0;i<c;i++) { diff+=pow2(v[i]-v_old[i]); }
        }
        else{
            for(i=0;i<c;i++) { diff+=pow2(vr[i]-vr_old[i])+pow2(vg[i]-vg_old[i])+pow2(vb[i]-vb_old[i]); }
        }
        
    }
    
    plhs[0] = mxCreateNumericArray(3, sizeY, mxDOUBLE_CLASS, mxREAL);
    Bout = (double*)mxGetData(plhs[0]);
    if(sizeY[2]==1){
        for(k=0; k<N; k++) { Bout[k]=B[k]; }
    }
    else {
        i=0;
        for(k=0; k<N; k++) { Bout[i]=Br[k]; i++;}
        for(k=0; k<N; k++) { Bout[i]=Bg[k]; i++;}
        for(k=0; k<N; k++) { Bout[i]=Bb[k]; i++;}
    }
    
    if( nlhs>1) {
        // Reshape Partition table to image style
        sizeU[0]=sizeY[0]; sizeU[1]=sizeY[1]; sizeU[2]=c;
        plhs[1] = mxCreateNumericArray(3, sizeU, mxDOUBLE_CLASS, mxREAL);
        Uout = (double*)mxGetData(plhs[1]);
        j=0; for(k=0; k<N; k++) { for(i=0;i<c;i++) { Uout[i*N+k]=U[j]; j++; } }
    }
    
    // Free memmory
    if(sizeY[2]==1){
        free(v); free(v_old); free(B);
    }
    else {
        free(vr); free(vr_old); free(Br);
        free(vg); free(vg_old); free(Bg);
        free(vb); free(vb_old); free(Bb);
    }
    free(U); free(Up); free(D); free(Gamma);
}






