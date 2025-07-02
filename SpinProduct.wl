(* ::Package:: *)

BeginPackage["SpinProduct`"];
	(*Initialization: clear all variables with the same names*)
	ClearAll[SU2Rep,SpinVersion,TotalSpin,ProductState,SpinOp,ToProduct];
	(*Version info*)
	SpinVersion = "1.0";

	SU2Rep::usage = "SU(2) irreps of any dimension";
	SU2Rep::arg = "The input `1` is not an integer greater than or equal to 2\:ff01";
	TotalSpin::usage = "List of Total spin at each site";
	TotalSpin::arg1 = "The input must be a list and at least one input is needed!";
	TotalSpin::arg2 = "The input list `1` is not a simple list with only scalar as its element! Tips: Use 3/2 instead of 1.5 for total S!";
	TotalSpin::arg3 = "Each total S must be a positive integer or half integer!";
	TotalS::usage = "Store the info of Total S at eact site";
	Sites::usage = "Length of sites";
	Sites = 0;
	ProductState::usage = "create a product state by specifying sz at each sites";
	ProductState::arg1 = "Before creating product state, at least one total spin must be specified by calling TotalSpin function!";
	ProductState::arg2 = "The length of input list (`1`) for Sz must be the same as the number of sites (`2`)!";
	ProductState::arg3 = "The input Sz must be an integer or half integer and satisfies -S<=Sz<=S for each site!";
	ProductState::arg4 = "The input Sz does not match the total S!";
	SpinOp::usage = "Spin operator";
	SpinOp::arg1 = "Before creating spin operator, at least one total spin must be specified by calling TotalSpin function!";
	SpinOp::arg2 = "The specified site `1` does not fall into the range [1, `2`] or it's not an integer!"
	SpinOp::arg3 = "Invalid operator! The input must be one of the six choices: Sx,Sy,Sz,Sp,Sm,S2!"
	ToProduct::usage = "Decouple the product state into the initial form";
	ToProduct::arg1 = "Before decoupling, at least one total spin must be specified by calling TotalSpin function!";
	ToProduct::arg2 = "The input state must be in the form of column vector: {{v1},{v2},...}";
	ToProduct::arg3 = "The state is not a valid product state, please check the input!";

	Begin["`Private`"];
	
		(*Create N sites with each assigned total spin quantum number S*)
		TotalSpin[list_]:=Module[{N},
			N=Length[list];
			If[!(N>=1), Message[TotalSpin::arg1]; Return[$Failed];];
			If[!(Depth[list]==2), Message[TotalSpin::arg2,list]; Return[$Failed];];
			If[!AllTrue[2*list, IntegerQ[#] && # >= 1 &], Message[TotalSpin::arg3]; Return[$Failed];];
			TotalS = list;
			Sites = N;
			Print["TotalS=",TotalS]]
		
	
		(*N-dimensional irreps of SU(2) group*)
		SU2Rep[n_]:=Module[{j,mList,Jplus,Jminus,Sx,Sy,Sz},
			(*Input validation:require integer n\[GreaterEqual]2*)
			If[!(IntegerQ[n]&&n>=2), Message[SU2Rep::arg,n]; Return[$Failed];];
			(*Compute spin quantum number j=(n-1)/2*)
			j=(n-1)/2;
			(*Build list of magnetic quantum numbers m=j,j-1,\[Ellipsis],-j*)
			mList=Table[j-k,{k,0,n-1}];
			(*Construct the raising operator J+ with entries \:27e8m\:2081|J+|m\:2082\:27e9=\[Sqrt][j(j+1)-m\:2081 m\:2082] if m\:2082=m\:2081+1, else 0*)Jplus=Table[If[mList[[j1]]==mList[[j2]]+1,Sqrt[j*(j+1)-mList[[j1]]*mList[[j2]]],0],{j1,n},{j2,n}];
			(*Lowering operator J- is the Hermitian transpose of J+*)
			Jminus=ConjugateTranspose[Jplus];
			(*Diagonal Sz with entries m*)
			Sz=DiagonalMatrix[mList];
			(*Sx and Sy from J\[PlusMinus]*)
			Sx=(Jplus+Jminus)/2;
			Sy=(Jplus-Jminus)/(2*I);
			(*Return an Association for easy indexing*)
			{"Sx"->Sx,"Sy"->Sy,"Sz"->Sz}]
		
		
		(*Generate the spin product state*)
		ProductState[listSz_]:= Module[{N,StateList}, N=Length[listSz];
			If[!(Sites>=1), Message[ProductState::arg1]; Return[$Failed];];
			If[Sites!=N, Message[ProductState::arg2,N,Sites]; Return[$Failed];];
			If[!AllTrue[Transpose[{TotalS, listSz}], (IntegerQ[#[[2]]*2]&&-#[[1]]<=#[[2]]<=#[[1]])&],Message[ProductState::arg3]; Return[$Failed];];
			StateList=Table[
				Module[{pos,temp},
					temp=ConstantArray[0, {2*TotalS[[i]]+1,1}];
					pos=TotalS[[i]]-listSz[[i]]+1;
					If[!IntegerQ[pos],Message[ProductState::arg4]; Return[$Failed];];
					temp[[pos]]={1};
					temp]
			,{i,1,N}];
			If[N==1,Return[StateList[[1]]]];
			KroneckerProduct@@StateList]
			
		
		(*Construct the matrix for spin operator*)
		SpinOp[site_,op_] := Module[{irreps, temp, Sx, Sy, Sz,res},
			If[!(Sites>=1), Message[SpinOp::arg1]; Return[$Failed];];
			If[!(1<=site<=Sites)||!IntegerQ[site],Message[SpinOp::arg2,site,Sites]; Return[$Failed]];
			If[!MemberQ[{"Sx","Sy","Sz","Sp","Sm","S2"}, op], Message[SpinOp::arg3]; Return[$Failed];];
			irreps = SU2Rep[2*TotalS[[site]]+1];
			Sx = "Sx"/.irreps;
			Sy = "Sy"/.irreps;
			Sz = "Sz"/.irreps;
			temp=Which[
				op == "Sx", Sx,
				op == "Sy", Sy,
				op == "Sz", Sz,
				op == "Sp", Sx+I*Sy,
				op == "Sm", Sx-I*Sy,
				op == "S2", Sx . Sx+Sy . Sy+Sz . Sz
				];
			If[Sites==1, Return[temp]];
			res = Table[IdentityMatrix[2*TotalS[[i]]+1],{i,1,Sites}];
			res[[site]]=temp;
			KroneckerProduct@@res
			]
		
		
		
		(* To check whether the input is a column Vector*)
		columnVectorQ[v_]:=ListQ[v]&&VectorQ[v,ListQ[#]&&Length[#]==1&];
		(*To check whether the input is in a valid form*)
		SameOrZeroQ[list_]:=Length[DeleteCases[list,{0}]]<=1;
		(*Find first nonzero index for the product state*)
		findFirstNonzeroIndex[list_,dims_]:=Module[{arr}, arr=ArrayReshape[list,dims]; First@Position[arr,x_/;x!=0]];
		(* Decouple the product state to an explicit form*)
		ToProduct[state_]:=Module[{dim, coeff, pos, res},
		If[!(Sites>=1), Message[ToProduct::arg1]; Return[$Failed];];
		If[!(columnVectorQ[state]), Message[ToProduct::arg2]; Return[$Failed];];
		If[!(SameOrZeroQ[state]), Message[ToProduct::arg3]; Return[$Failed];];
		If[Norm[state]==0, Return[0];];
		dim=2*TotalS+1;
		coeff=SelectFirst[state, #!={0} &][[1]];
		pos = findFirstNonzeroIndex[Flatten[state],dim][[1;;Sites]];
		res = Table[Table[i,{i,TotalS[[j]],-TotalS[[j]],-1}][[pos[[j]]]],{j,1,Length[pos]}];
		If[coeff==1,
		Print[Row[{Magnify["|",1.7],Sequence@@Riffle[res,","],Magnify[">",1.7/1.1]}]],
		Print[coeff,Row[{Magnify["|",1.7],Sequence@@Riffle[res,","],Magnify[">",1.7/1.1]}]]]
		]
		
		
		
	End[];

	(* Ending infos*)
	Print["SpinProduct loaded successfully." <> " Version: " <> SpinVersion];
	Print["Developed by Junyu Tang (UCR). Licensed under MIT License."]
	Print["Type ?SpinProduct`* to see all variables and available functions."];
	Print["Visit https://github.com/Junyu-Tang/SpinProduct for more infomation."]
EndPackage[];


(* ::InheritFromParent:: *)
(**)
