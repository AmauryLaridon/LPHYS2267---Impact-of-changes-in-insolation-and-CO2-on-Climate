# LPHYS2267-Impact of changes in insolation and CO2 on Climate


![ts_CO2_1](https://github.com/AmauryLaridon/LPHYS2267---Impact-of-changes-in-insolation-and-CO2-on-Climate/assets/58213378/c415f447-db35-4945-a4d2-6cd3bae5bc40)


### Why this repository ? 
GitHub made for the Project : **Investigate the impacts of changes in insolation and CO2 on climate based on
model simulations** of the LPHYS2267 - Paleoclimate dynamics and modelling class. 

The goal of this project is to : 

- Diagnose the outputs of the LOVECLIM climate model
- Understand what are the majors impacts of precession and CO2 on some fundamental climate variables such as temperature, precipitation and sea ice. In our group we investigate the impacts of surface temperature and sea surface temperature. 

More informations can be found in the *Instructions* folder. 

The final report around these questions and the analysis can be found at the *report.pdf* file. This project has been done by Élise Françoisse, Augustin Lambotte and Amaury Laridon.

### Organisation of the files 

- The Data are all stored in the *Data* folder which is decomposed with the *CTL_run* data and the *Exercise1*, *Exercise2* corresponding to the changing precession experiment and the doubling CO2 experiment. 

- All the figures are stored in the *Figures* folder. Again they are classified with respect to the experiment perform. 

- In the *Instructions* folder there is the *.pdf* file of the project statements

- The *.ncl* script used to analyse the data and to perform the figures is in the *Script* folder

### How to run ? 

Simply clone this repository on your computer then run the *data_analysis.ncl* script by using 
`ncl data_analysis.ncl`

To do so it is needed to have the NCL Language install. Check the following URL if you haven't : https://www.ncl.ucar.edu/Download/conda.shtml
Caution that in order to run the script you need to change the path of the data to your local folder where they are store. 




