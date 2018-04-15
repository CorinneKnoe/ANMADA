# Advanced Numerical Methods and Data Analysis
This repository contains projects for the course offered in Spring 2018 at the University of St. Gallen (HSG). The two contributors are [Corinne](https://github.com/CorinneKnoe) and [Simon](https://github.com/Sommer1872).

## [COS-FFT](https://github.com/CorinneKnoe/ANMADA/tree/master/COS-FFT)
Implements the option pricing method developed by [Fang & Oosterlee, 2008](https://mpra.ub.uni-muenchen.de/9319/).

## [server-project](https://github.com/CorinneKnoe/ANMADA/tree/master/server-project)
Describes the setup of a personal data server from scratch (using [DigitalOcean](https://www.digitalocean.com)) and documents how we used [Quandl](https://www.quandl.com) to pull millions of futures data points to an SQL database on the server with only a few lines of python code.

# User Manual

## Requirements

### 1. Download code from github

You can either download this repository via the green `Clone or Download` button at the top of the page; or use git from your local terminal via
```
git clone https://github.com/CorinneKnoe/ANMADA.git
```
(downloads this repository into the location of your terminal session).

### 2. Python, Anaconda and Jupyter
With Anaconda we recommend the widely used and powerful package manager for python that also includes Jupyter Notebooks (which are needed to run the code above locally).  You can download the installer for Python 3.6 [here](https://www.continuum.io/downloads).
### 3. Install Packages
Next, open up a new terminal (command line) and navigate to the ANMADA folder, which you downloaded in __1.__ (there should be a ﬁle named environment.yml in it). Then, run
```
conda env create -f environment.yml
```
This should create a new conda environment and install a list of packages. If you see an error in the installation process due to missing dependency, you should install missing dependency and then continue installation of required packages via:
```
conda env update -f environment.yml
```
You're now all set to open jupyter notebooks.

## Jupyter Notebooks

Navigate to the ANMADA directory in your terminal and type:
```
jupyter notebook
```
This opens a new browser window and shows the files in the directory. Simply click on the `.ipynb` files to open them. You should now be able to explore and run the python code locally.
