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

<img src="./Demo/FindGSres2.png" alt="Alt Text" width="400" height="250">

## Functions

 * ``` TotalSpin[listS_]```

 Add seversal quantum spin number $S$ (total spin number). The input ```listS``` is a list (vector) contains only positive integer or half integer (S = 1/2, 1, 3/2, 2, 5/2,...$). For three spin sites with spin-1/2 for all of the sites, one can use the input ```listS={1/2,1/2,1/2}```. Tips: Use 3/2 instead of 1.5 for the quantum spin number $S$. The length of input list is recorded to a variable ```Sites```, which can be directly called.
 <br/><br/>

 * ``` SU2Rep[N_]```

This function returns an association of the ```N```-dimensional irreducible representation (matrices) for three generators of SU(2) group. The dimension ```N``` must be an positive integer that is larger or equal to 2. In principle, one could use these matrices to construct any spin operators in the spin space. In the following, we provide a more convenient way by calling the ```SpinOp```` function
<br/><br/>

 * ``` SpinOp[i_, op_]```

This function returns a representation (matrix) of operator ```op``` at spin site ```i```. The valid input of operator ```op``` includes ```op="Sx", "Sy", "Sz", "Sp", "Sm", "S2"```.
 <br/><br/>


## Updates

* Version-1.0 2025/07/02
  
  First version of SpinProduct!
