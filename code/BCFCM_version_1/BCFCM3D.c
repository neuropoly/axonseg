#include "mex.h"
#include "math.h"
#include "string.h"
#define absd(a) ((a)>(-a)?(a):(-a))
#define EPS 1e-10f
#ifndef min
#define min(a,b)        ((a) < (b) ? (a): (b))
#endif
#ifndef max
#define max(a,b)        ((a) > (b) ? (a): (b))
#endif
#define clamp(a, b1, b2) min(max(a, b1), b2);

/*
* This function BCFCM3D, segments (clusters) an image in object classes,
* and estimates the bias field.
*
* It's an implementation of the paper of M.N. Ahmed et. al. "A Modified Fuzzy 
* C-Means Algorithm for Bias Field estimation and Segmentation of MRI Data"
* 20002, IEEE Transactions on medical imaging.
*
* [U,B]=BCFCM3D(Y,v,Options)
*
* Inputs,
*   Y : The 3D greyscale input image of type Single
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
* Function is written by D.Kroon University of Twente (November 2009)
*/

__inline double pow2(double a) { return a*a; }
__inline double nonzero(double a) { return (absd(a)>EPS?a:EPS); }

struct options {
    double p;
    double alpha;
    double epsilon;
    double sigma;
    size_t maxit;
};
void setdefaultoptions(struct options* t) {
    t->p=2.0;
    t->alpha=1.0;
    t->epsilon=0.01;
    t->sigma=2.0;
    t->maxit=10;
}

float * mallocf(size_t a)
{
    float *ptr = malloc(a*sizeof(float));
    if (ptr == NULL) { mexErrMsgTxt("Out of Memory"); }
    return ptr;
}


double * mallocd(size_t a)
{
    double *ptr = malloc(a*sizeof(double));
    if (ptr == NULL) { mexErrMsgTxt("Out of Memory"); }
    return ptr;
}


void imfilter1D_float(float *I, size_t lengthI, float *H, size_t lengthH, float *J) {
    size_t x, i, index, offset;
    size_t b2, offset2;
    if(lengthI==1)  
    { 
        J[0]=I[0];
    }
    else
    {
        offset=(lengthH-1)/2;
        for(x=0; x<min(offset,lengthI); x++) {
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
         for(x=max(lengthI-offset,offset); x<lengthI; x++) {
              J[x]=0;
              offset2=x-offset;
              for(i=0; i<lengthH; i++) {
                  index=clamp(i+offset2, 0, b2); J[x]+=I[index]*H[i];
             }
         }
       
    }
}

void imfilter2D_float(float *I, size_t * sizeI, float *H, size_t lengthH, float *J) {
    size_t y, x, i, y2;
    float *Irow, *Crow;
    size_t index=0, line=0;
    float *RCache;
    size_t *nCache;
    size_t hks, offset, offset2;
    RCache=mallocf(lengthH*sizeI[0]);
    for(i=0; i<lengthH*sizeI[0]; i++) { RCache[i]=0; }
    nCache=(size_t *)malloc(lengthH*sizeof(size_t));
    for(i=0; i<lengthH; i++) { nCache[i]=0; }
    hks=((lengthH-1)/2);
    for(y=0; y<min(hks,sizeI[1]); y++) {
        Irow=&I[index];
        Crow=&RCache[line*sizeI[0]];
        imfilter1D_float(Irow, sizeI[0], H, lengthH, Crow);
        index+=sizeI[0];
        if(y!=(sizeI[1]-1))
        {
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
        imfilter1D_float(Irow, sizeI[0], H, lengthH, Crow);
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

    for(y=max(sizeI[1]-1,hks); y<sizeI[1]; y++) {
        Irow=&I[index];
        Crow=&RCache[line*sizeI[0]];
        imfilter1D_float(Irow, sizeI[0], H, lengthH, Crow);
        offset=(y-hks)*sizeI[0]; offset2=nCache[0]*sizeI[0];
        for(x=0; x<sizeI[0]; x++) { J[offset+x]=RCache[offset2+x]*H[0]; }
        for(i=1; i<lengthH; i++) {
            offset2=nCache[i]*sizeI[0];
            for(x=0; x<sizeI[0]; x++) { J[offset+x]+=RCache[offset2+x]*H[i]; }
        }
        index+=sizeI[0];
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }

    for(y=max(sizeI[1],hks); y<(sizeI[1]+hks); y++) {
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

void imfilter3D_float(float *I, size_t * sizeI, float *H, size_t lengthH, float *J) {
    size_t z, j, i, z2;
    float *Islice, *Cslice;
    size_t index=0, line=0;
    float *SCache;
    size_t *nCache;
    size_t hks, offset, offset2;
    size_t nslice;
    nslice=sizeI[0]*sizeI[1];
    SCache=mallocf(lengthH*nslice);
	for(i=0; i<nslice; i++) { SCache[i]=0; }
    nCache=(size_t *)malloc(lengthH*sizeof(size_t));
    for(i=0; i<lengthH; i++) { nCache[i]=0; }
    hks=((lengthH-1)/2);
    for(z=0; z<min(hks,sizeI[2]); z++) {
        Islice=&I[index];
        Cslice=&SCache[line*nslice];
        imfilter2D_float(Islice, sizeI, H, lengthH, Cslice);
        index+=nslice;
        if(z!=(sizeI[2]-1))
        {
            line++; if(line>(lengthH-1)) { line=0; }
        }
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }
    for(z2=z; z2<hks; z2++) {
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }
    for(z=hks; z<(sizeI[2]-1); z++) {
        Islice=&I[index];
        Cslice=&SCache[line*nslice];
        imfilter2D_float(Islice, sizeI, H, lengthH, Cslice);
        offset=(z-hks)*nslice; offset2=nCache[0]*nslice;
        for(j=0; j<nslice; j++) { J[offset+j]=SCache[offset2+j]*H[0]; }
        for(i=1; i<lengthH; i++) {
            offset2=nCache[i]*nslice;
            for(j=0; j<nslice; j++) { J[offset+j]+=SCache[offset2+j]*H[i]; }
        }
        index+=nslice;
        line++; if(line>(lengthH-1)) { line=0; }
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }
    for(z=max(sizeI[2]-1,hks); z<sizeI[2]; z++) {
        Islice=&I[index];
        Cslice=&SCache[line*nslice];
        imfilter2D_float(Islice, sizeI, H, lengthH, Cslice);
        offset=(z-hks)*nslice; offset2=nCache[0]*nslice;
        for(j=0; j<nslice; j++) { J[offset+j]=SCache[offset2+j]*H[0]; }
        for(i=1; i<lengthH; i++) {
            offset2=nCache[i]*nslice;
            for(j=0; j<nslice; j++) { J[offset+j]+=SCache[offset2+j]*H[i]; }
        }
        index+=nslice;
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }
    for(z=max(sizeI[2],hks); z<(sizeI[2]+hks); z++) {
        offset=(z-hks)*nslice; offset2=nCache[0]*nslice;
        for(j=0; j<nslice; j++) { J[offset+j]=SCache[offset2+j]*H[0]; }
        for(i=1; i<lengthH; i++) {
            offset2=nCache[i]*nslice;
            for(j=0; j<nslice; j++) { J[offset+j]+=SCache[offset2+j]*H[i]; }
        }
        index+=nslice;
        for(i=0; i<(lengthH-1); i++) { nCache[i]=nCache[i+1]; } nCache[lengthH-1]=line;
    }

    free(SCache);
}

void GaussianFiltering3D_float(float *I, float *J, size_t *dimsI, double sigma, double kernel_size)
{
	size_t kernel_length,i;
    double x;
    float *H, totalH=0;
	
	/* Construct the 1D gaussian kernel */
	if(kernel_size<1) { kernel_size=1; }
    kernel_length=(size_t)(2*ceil(kernel_size/2)+1);
	H = mallocf(kernel_length);
	x=-ceil(kernel_size/2);
	for (i=0; i<kernel_length; i++) { H[i]=(float)exp(-((x*x)/(2*(sigma*sigma)))); totalH+=H[i]; x++; }
	for (i=0; i<kernel_length; i++) { H[i]/=totalH; }
	
	/* Do the filtering */
	imfilter3D_float(I, dimsI, H, kernel_length, J);
    /* Clear memory gaussian kernel */
	free(H);
}



/* The matlab mex function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {    
    double *v, *v_old, *D, *Gamma;
	float *Y, *vin_f, *B, *B2, *U, *Up, *Bout, *Uout;
	double *vin_d;
    double p, pinv, alpha, alphan, epsilon, sigma;
    size_t maxit,c;
 
    const mwSize *dimsY;
    size_t sizeY[3];
	int sizeU[4];
    struct options Options;
    int field_num;
    size_t i,j,k;
    size_t xd, yd, zd, x, y, z;
    size_t N, Nslice, Nr;
    size_t itt;
    size_t index;
	double s, s2;
    double a,b;
    double nomt, dent;
    size_t Nind[27];
    double diff;
    size_t ind;
    double *nom, *den;
	
    /* Check properties of image I */
    if(mxGetNumberOfDimensions(prhs[0])!=3) { mexErrMsgTxt("Image must be 3D"); }
    if(!mxIsSingle(prhs[0])){ mexErrMsgTxt("Image must be single"); }
    dimsY = mxGetDimensions(prhs[0]);
    sizeY[0]=dimsY[0]; sizeY[1]=dimsY[1]; sizeY[2]=dimsY[2];

     
    /* Check options */
    setdefaultoptions(&Options);
    if(nrhs==3) {
        if(!mxIsStruct(prhs[2])){ mexErrMsgTxt("Options must be structure"); }
        field_num = mxGetFieldNumber(prhs[2], "p");
        if(field_num>=0) {
            Options.p=(double)mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
        }
        field_num = mxGetFieldNumber(prhs[2], "alpha");
        if(field_num>=0) {
            Options.alpha=(double)mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
        }
        field_num = mxGetFieldNumber(prhs[2], "epsilon");
        if(field_num>=0) {
            Options.epsilon=(double)mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
        }
        field_num = mxGetFieldNumber(prhs[2], "sigma");
        if(field_num>=0) {
            Options.sigma=(double)mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
	    }
        field_num = mxGetFieldNumber(prhs[2], "maxit");
        if(field_num>=0) {
            Options.maxit=(size_t)mxGetPr(mxGetFieldByNumber(prhs[2], 0, field_num))[0];
        }
    }
    
	// Number of classes
    c=(size_t)mxGetNumberOfElements(prhs[1]);
  
    /* Assign posize_ters to each input. */
    Y=(float *)mxGetData(prhs[0]); 
	if(mxIsSingle(prhs[1]))
	{
		vin_f=(float *)mxGetData(prhs[1]); 
		v=mallocd(c); for(i=0; i<c; i++) { v[i]=(double)vin_f[i]; }
	}
	else if (mxIsDouble(prhs[1]))
	{
		vin_d=(double *)mxGetData(prhs[1]); 
		v=mallocd(c); for(i=0; i<c; i++) { v[i]=(double)vin_d[i]; }
	}
	else
	{
		mexErrMsgTxt("v must be single or double"); 
	}
    // Step 1, size_tialization

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
    v_old=mallocd(c);
    
    // Number of pixels
    N=(size_t)mxGetNumberOfElements(prhs[0]);
    
	// Number of pixels in a 2D slice
	Nslice=dimsY[0]*dimsY[1];
	
    // Bias field estimate
    B = mallocf(N);
    for(i=0; i<N; i++) { B[i]=1e-4f; }
    
    // Partition matrix    
    U = mallocf(c*N);
    Up = mallocf(c*N);

    // Distance to clusters
    D = mallocd(c);
	
    // Number of neighbours
    Nr =26;

	
    // Neighbour class influence
    Gamma =  mallocd(c);

    //Init variables
    nom = mallocd(c);
    den = mallocd(c);
 
    // pre-calculate
    pinv=1/(p-1);
    
	alphan= alpha/((double)Nr);
    itt=0;
    diff=epsilon+1.0;
    while((diff>=epsilon)&&(itt<=maxit))
    {
        itt=itt+1;
        //disp(['itteration ' num2str(itt)]);

        // Cluster update storage
        for(i=0;i<c;i++) { nom[i]=0; den[i]=0; }    

        // Loop through all pixels
        k=0;
        for(zd=0; zd<dimsY[2]; zd++)
        {
			for(yd=0; yd<dimsY[1]; yd++)
			{
				for(xd=0; xd<dimsY[0]; xd++)
				{
					index=k*c;
					// Get neighbour pixel indices
					x=min(max(xd,1),dimsY[0]-2); y=min(max(yd,1),dimsY[1]-2); z=min(max(zd,1),dimsY[2]-2);
					ind=x+y*dimsY[0]+z*Nslice;
					Nind[0]=ind         ; Nind[1]=Nind[0]-1; Nind[2]=Nind[0]+1;
					Nind[3]=ind-dimsY[0]; Nind[4]=Nind[3]-1; Nind[5]=Nind[3]+1;
					Nind[6]=ind+dimsY[0]; Nind[7]=Nind[6]-1; Nind[8]=Nind[6]+1;
					
					for(i=0;i<9;i++)
					{   
						Nind[i+9]=Nind[i]-Nslice;
						Nind[i+18]=Nind[i]+Nslice;
					}
					Nind[0]=Nind[26];
					
					// Calculate distance to class means for each (bias corrected) pixel and neighbours
					for(i=0;i<c;i++)
					{        
						Gamma[i]=0; for(j=0;j<Nr; j++) { Gamma[i]+=pow2( (double)(Y[Nind[j]]-B[Nind[j]]) - v[i] ); }
						D[i] = pow2( (double)(Y[k]-B[k])-v[i] );
					}

					// step 3a, update the prototypes (means) of the clusters
					s2=0; for(j=0;j<Nr; j++) { s2+=(double)(Y[Nind[j]]-B[Nind[j]]); }   
					s = (double)(Y[k]-B[k]) + alphan*s2;
	 
					// step 2, Calculate robust partition matrix
					for(i=0;i<c;i++)
					{        
						dent=0;
						a = D[i] + alphan * Gamma[i];
						for(j=0;j<c;j++)
						{
							b = D[j] + alphan * Gamma[j];
							dent += pow(a/nonzero(b),pinv);
						}
				   
						U[i+index] = 1.0f/ (float)nonzero(dent); 
						Up[i+index] = powf(U[i+index],(float)p);
						
						// step 3b, update the prototypes (means) of the clusters
						nom[i]+=(double)Up[i+index]*s;
						den[i]+=(double)Up[i+index];
					}
					k++;
				}
			}
		}

        // Step 3c, update the prototypes (means) of the clusters
        for(i=0;i<c;i++)
        {        
        	v_old[i]=v[i];        
			v[i]=nom[i]/((1+alpha)*nonzero(den[i]));
		}
		
        // step 4, Estimate the (new) Bias-Field
        for(k=0; k<N; k++)
        {
            nomt=0; dent=0;
            index=k*c;
            for(i=0; i<c; i++)
            {
                nomt+=(double)Up[i+index]*v[i];
                dent+=(double)Up[i+index];
            }
            B[k]=Y[k] - (float)nomt/(float)nonzero(dent);
        }

        // Low-pass filter Bias-Field, as regularization
		if(sigma>0)
		{
			B2=mallocf(N);
			GaussianFiltering3D_float(B, B2, sizeY, sigma, ceil(sigma*6));
			free(B);
			B=B2;
		}
		
        // Difference in cluster size_tensities
        diff=0; for(i=0;i<c;i++) { diff+=pow2(v[i]-v_old[i]); }
    }

		
	plhs[0] = mxCreateNumericArray(3, dimsY, mxSINGLE_CLASS, mxREAL);
	Bout = (float*)mxGetData(plhs[0]);
	for(k=0; k<N; k++) { Bout[k]=B[k]; }

    if( nlhs>1)
	{
		// Reshape Partition table to image style
		sizeU[0]=(int)sizeY[0]; sizeU[1]=(int)sizeY[1]; sizeU[2]=(int)sizeY[2]; sizeU[3]=(int)c;
		plhs[1] = mxCreateNumericArray(4, sizeU, mxSINGLE_CLASS, mxREAL);
		Uout = (float*)mxGetData(plhs[1]);
		j=0; for(k=0; k<N; k++) { for(i=0;i<c;i++) { Uout[i*N+k]=U[j]; j++; } }
	}

    // Free memmory
    free(v); free(v_old); free(U); free(B);
    free(Up); free(D); free(Gamma);
}






