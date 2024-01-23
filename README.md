# How trees keep our cities cool: Effects of urban forest characteristics on microclimate cooling.

Mathieu Johnson, to complete the requirements for SCOL391 at Concordia University


[![DOI](https://zenodo.org/badge/747253548.svg)](https://zenodo.org/doi/10.5281/zenodo.10557185)


## Abstract
The urban heat island effect (UHI) is a phenomenon wherein an urban area will be significantly warmer than its surrounding environment. The urban forest can aid in counteracting this effect by cooling the surrounding air though cooling and evapotranspiration. Our study aims to investigate the relationships between air temperature and 4 variables of interest used to describe the urban forest, namely canopy cover, specific leaf are, diversity and low green cover. We used a mobile temperature sensing apparatus to measure air temperature in Notre-Dame-de-Grace, a Montreal neighbourhood. A significant negative relationship was found between canopy cover and air temperature. A significant positive relationship was found between specific leaf area and air temperature. No significant relationship was found between either diversity or low green cover and air temperature.

## How to Use
QGIS was used to generate "buffers.csv", which has data about each tree grouped by 80x80m squares placed along the bike path. 
"trees.csv" is data about each tree individually. Functional groups were defined by [Paquette et al (2021)](https://doi.org/10.1016/j.ufug.2021.127157). Note that some of the trees do not have an associated functional group, as they were not found in the paquette et al excel file. 

To reproduce generating "buffers.csv", load all gpkg files into QGIS from the `input/QGIS/` folder, as well as "660_IndiceCanopee_2019.tif" in the "660_IndiceCanopee_2019_TIF" folder. The zonal statistics function was used to calculate canopy%, low green%, and impervious%. To group points along the bike path by buffer, the "join attributes by location" function was used. 
