# sampling_in_gsm
### Project description

Network model of V1 simple cells which represent a complete probability distribution by a sequence of multivariate stochastic samples. Perceptual inference in a model of natural images is assumed to result in a posterior probability distribution. The image model used is a Gaussian Scale Mixture model that was shown to be both an effective computer vision model for denoising and compression, but also as a good predictor of the mean activity of simple cells in response to various stimuli.

This is a repository of matlab files underying the paper:

*Orban G, Berkes P, Fiser J, Lengyel M (2016) Neural Variability and Sampling-Based Probabilistic Representations in the Visual Cortex. 92:1-14.*

Some routines use the lightspeed toolbox (http://research.microsoft.com/en-us/um/people/minka/software/lightspeed/)

By Gergo Orban

### CONTENTS

model_parameters.mat  
get_pz_x_max.m  
infer_u_and_z_indivzrange.m,     dependecy: <- get_pz_x_max.m
calc_firing_rate.m

### DESCRIPTION

**model_parameters.mat**  
The file contains parmaeters used in the simulations

Dx:     scalar, number of observed variables or pixels of the image patches - 16x16=256  
Dy:     scalar, number of filters/latent variables in the GSM, equivalent to the number of neurons in the population (Du)  
wnode:  matrix of size Dx x Dx, whitening filters for preprocessing natural images  
A:      matrix of size Dx x Dy, filter bank for 16x16 image patches  
rho:    matrix of size Dy x Dy, prior covariance matrix (denoted as C in the equations of the paper)  
sigmaX: scalar, observation noise in GSM  
kGam:   scalar, shape parmaeter of Gamma distribution, prior of contrast variable z  
thGam:  scalar, scale parmaeter of Gamma distribution, prior of contrast variable z  
alpha:  scalar, exponent of the membrane potential nonlinearity  
uTh:    scalar, membrane potential threshold for the firing rate nonlinearity  
m:      scalar, gain of the firing rate nonlinearity  
beta:   scalar, exponent of the power-law of the firing rate nonlinearity  

**get_pz_x_max.m**  
Function to determine the range of integration for the posterior distribution, P(z|x), of contrast variable z.

**infer_u_and_z_indivzrange.m**  
Function to make inference over the latent variable y upon presenting a stimulus x. The resulting posterior is P(y | x) = int P(y | x, z) P(z | x) dz. The first term in the integral is a gaussian, with mean and covariance depending on z. The second term is the posterior of z, which is evaluated at discrete points and is an output of the function. Means and covariances of the first term are also assessed at the didcrete z's and are also part of the output of the function. 

The function implements *Equations 4* and *5* in the paper.

**calc_firing_rate.m**  
Function to calculate firing rates and membrane potentials from latent variable activations. 

The function implements *Equations 6* and *7* in the paper.
