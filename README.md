# SpinProduct
A Mathematica Paclet/Package for manipulation of spin product states in terms of matrix language.


## How it works?

The essential part of this Paclet is constructing the matrix representation for the spin operators and spin product states for arbitary spin sites with designed quantum spin number $S$. Thus, the action of spin operators on the product states is straightforward by doing a **matrix multiplication**. This Paclet also provides a function to translate the results to the product states written in Dirac ket notation. 


## Installation

Download and put the ```SpinProduct.wl``` file in the following path
```
Mathematica\Contents\AddOns\ExtracPackages
```
or somewhere your Mathematica could find ($Path).

To load the package:
```
Needs["SpinProduct`"]
```
or one use following command, which will reload the package (overwite the variables) every time being called

```Get["SpinProduct`"] ```

The above command should be equivalent with
```
<<"SpinProduct`"
```
After the package is sucessfully loaded, type ```?SpinProduct`* ``` to see all variables and available functions.

## Examples



## Functions



## Updates

* Version-1.0 2025/07/02
  
  First version of AFMVisual!
