# Inferring Basis Mismatch in image representations

>Objective is to reduce problem of *Basis mismatch* using **Alternating Convex Search**. 

[![Build Status][travis-image]][travis-url]

## Research Problem

In theory of compressive sensing, 

![equation](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20y%20%3D%20%5CPhi%20z%20&plus;%20%5Ceta)

where ![eq](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20y%20%5Cin%20%5Ctext%7BR%7D%5E%7BM%7D%20%2C%20%5CPhi%20%5Cin%20%5Ctext%7BR%7D%5E%7BM%5Ctext%7Bx%7DN%7D%20%2C%20z%20%5Cin%20%5Ctext%7BR%7D%5EN) And ![eq](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5Ceta%20%5Cin%20%5Ctext%7BR%7D%5EM)

Here we have to determine original signal/image ![z](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20z) from Sensing matrix ![\Phi](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPhi) and measured signal/image ![y](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20y).
For ![M < N$ , $y = \Phi z](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20M%20%3C%20N%20%2C%5C%20%5C%20y%20%3D%20%5CPhi%20z) becomes under-determined and does not have a closed
form solution for ![z](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20z)(infinite many ![z](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20z)'s maps to same ![y](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20y)). 

But compressive sensing theory says we can uniquely estimate ![z](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20z) from ![\Phi](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPhi) and ![y](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20y), given ![z](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20z) should be sparse in some basis matrix say ![\Psi](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPsi)(commonly DFT, DCT or wavelet) which is theoretically known and ![\Phi](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPhi) should be incoherent with ![\Psi](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPsi). 

So equation becomes, 

![eq](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20y%20%3D%20%5CPhi%20%5CPsi%20%5Ctext%7Bx%7D%20&plus;%20%5Ceta)

where ![\Psi \in \R^{N\text{x}N}](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPsi%20%5Cin%20%5Ctext%7BR%7D%7B%5Ccolor%7BRed%7D%20%7D%5E%7BN%5Ctext%7Bx%7DN%7D) and ![x \in \R^{N}](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20x%20%5Cin%20%5Ctext%7BR%7D%5E%7BN%7D).

>**In practice, even small deviation from exact signal can cause drastic increase in estimation error. This is called *Basis Mismatch problem*.**

>**Note-** Basis mismatch always exists because of noise or discrete representation of bases as the sensed signal is almost never going to lay on the exact grid of ![\Psi](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPsi).
So sparse signals w.r.t. sparsifying matrix ![\Psi](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPsi) could become non-sparse or less sparse under another matrix say ![\Psi'](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPsi%27) , such that ![\Psi \Psi' \neq I](https://latex.codecogs.com/gif.latex?%5Cdpi%7B120%7D%20%5Cfn_cs%20%5Clarge%20%5CPsi%20%5CPsi%27%20%5Cneq%20I).

Therefore it remained the predominant question of ***how to reduce the Basis Mismatch effect?***

## Solution Approaches

**Previous Approaches:**
  - Oversample the frequency space i.e. ![\Psi \in \R^{N\text{x}QN}](https://latex.codecogs.com/gif.latex?%5Cfn_cs%20%5Clarge%20%5CPsi%20%5Cin%20%5Ctext%7BR%7D%5E%7BN%5Ctext%7Bx%7DQN%7D) contain sinusoids with frequencies ![1](https://latex.codecogs.com/gif.latex?%5Cdpi%7B100%7D%20%5Cfn_cs%201) / ![QN](https://latex.codecogs.com/gif.latex?%5Cdpi%7B100%7D%20%5Cfn_cs%20QN) apart instead of ![1](https://latex.codecogs.com/gif.latex?%5Cdpi%7B100%7D%20%5Cfn_cs%201) / ![N](https://latex.codecogs.com/gif.latex?%5Cdpi%7B100%7D%20%5Cfn_cs%20N) apart.
  - Treat both the model coefficients and the associated frequency as unknown which need to be solved. Isolates the unknown frequencies in separate, non-overlapping bins and then solves for their location and amplitude. 
  - Both frequency locations and amplitudes can be estimated by solving the constrained **Atomic Norm Minimization** by *semi-definite programming*. Also Atomic Norm Minimization constrain can be solved by [*greedy forward-backward (GFB) algorithm*](http://ieeexplore.ieee.org/document/6638793/).
  
**Proposed Approaches- *Alternating Convex Search (ACS):*** This method is implemented as shown in this [paper](https://ieeexplore.ieee.org/abstract/document/6815988/). Here, we solve the basis mismatch problem using *Alternating Convex Search (ACS)* which is trying to estimate both frequency bases matrix and coefficients. 

![eq](https://latex.codecogs.com/gif.latex?%5Cdpi%7B120%7D%20%5Cfn_cs%20%5Clarge%20%28%5Chat%7B%5Ctext%7Bx%7D%7D%2C%5Chat%7B%5Ctheta%7D%29%20%3D%20argmin_%7B%5Ctext%7Bx%7D%2C%5Ctheta%7D%20%5C%20f%28%5Ctext%7Bx%7D%2C%5Ctheta%29%20%3D%20%7C%7Cy%20-%20%5CPhi%20%5CPsi_%7B%5Ctheta%7D%20%5Ctext%7Bx%7D%7C%7C_%7B2%7D%5E2%20&plus;%20%5Clambda%20%7C%7C%5Ctext%7Bx%7D%7C%7C_1)

This method uses standard  ![l_1](https://latex.codecogs.com/gif.latex?%5Cdpi%7B100%7D%20%5Cfn_cs%20l_1%20-%20%5Ctext%7Bminimization%20problem%7D) to find out the signal model coefficients i.e. ![x](https://latex.codecogs.com/gif.latex?%5Cdpi%7B120%7D%20%5Cfn_cs%20%5Clarge%20x) by keeping frequency parameter ![\theta](https://latex.codecogs.com/gif.latex?%5Cdpi%7B120%7D%20%5Cfn_cs%20%5Clarge%20%5Ctheta) fixed. 
Then using this coefficients find out the signal model using **component-wise minimization** like ***coordinate descent*** on the *frequency parameter*. 
These steps are repeated this until convergence criteria is met.
  

## References
- [Compressed sensing](http://ieeexplore.ieee.org/document/1614066/) by D. L. Donoho
- [Reducing Basis Mismatch in Harmonic Signal Recovery via Alternating Convex Search](https://ieeexplore.ieee.org/abstract/document/6815988/) by Jonathan M. Nichols, Albert K. Oh, and Rebecca M. Willett


<!-- Markdown link & img dfn's -->
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
