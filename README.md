# A parametric reduced-order model based on tensor decomposition for unstructured mesh data

## Overview
<p align="center" width="100%">
  <img width=98% src="./fig/construction(4).png" >
  <br />
</p>

<p align="center" width="100%">
  <img width=98% src="./fig/procedure(7).png" >
  <br />
</p>

## Workflow
1. Data preparation
  - **data.mat**
    - **data_train** of shape (num_points, num_train)
    - **data_test** of shape (num_points, num_test)
    - **input_train** of shape (num_train, num_params)
    - **input_test** of shape (num_test, num_params)
  - **point.txt**
    - physical coordinates of all the grid points, each line representing a point (e.g., x y).
2. Generate transfer tensor (matrix) with **split.py**. Use **point.txt** as input and obtain the transfer tensor (e.g., **transmatrix.txt**).
3. Parametric prediction
  - **pod_kriging.m**
    - Input: **data.mat**
    - Set tolerance
    - kriging/fitrgp interpolation
    - Output: **pred** (errors printed)
  - **tucker_kriging.m**
    - Input: **data.mat**, **transmatrix.txt**
    - Set tolerance
    - kriging/fitrgp interpolation
    - Output: **preds** (errors printed)
  - **cp_kriging.m**
    - Input: **data.mat**, **transmatrix.txt**
    - Set number of CP modes
    - kriging/fitrgp interpolation
    - Output: **preds** (errors printed)

**data(2).mat**, **datap(2).mat**, and **transmatrix(2).txt** are provided as the dataset for Flow around a circular cylinder case (velocity-x and pressure fields).

## Issues
- Current version does not support multi-dimensional unstructured mesh data.

## Cite
```bibtex
@article{tong_parametric_2025,
	title = {A parametric reduced-order model based on tensor decomposition for unstructured mesh data},
	volume = {541},
	issn = {0021-9991},
	url = {https://www.sciencedirect.com/science/article/pii/S0021999125005832},
	doi = {https://doi.org/10.1016/j.jcp.2025.114300},
	journal = {Journal of Computational Physics},
	author = {Tong, Yanjie and Lu, Qingzhou and Ding, Siyu and Wang, Xingjian},
	year = {2025},
	pages = {114300},
}
```




