# Team Waste Dashboard Project

This dashboard allows users to explore the destinations of different kinds of waste origninating in Wales through interactive
maps. It also contains visualisations of waste over time and waste outliers, so that users can look for areas where more
waste is being produced.

# Project Brief

The client wants an app that helps them understand and analyse the problem of waste misbalances. They want a dashboard that:

- Lets them explore this dataset and gain insights.
- Gives insight into possible anomalies in the data.
- A map that helps them explore the data.
- The data is static, so this is less a dashboard that provides insights at a glance, but rather an exploration tool.
- The app should be supported by documentation that contains definitions and assumptions.

# Code and Data Used

This is a RShiny Dashboard, built in Rstudio. The data used is synthesised, and is based on real data that tracks waste
movement from Welsh Authorities, broken into waste types. The data was cleaned in R and then visualised using ggplot. 
Leaflet was used to build the maps.

# Features

The maps in the dashboard are fully interactive and allow users to select which authority they are interested in, as well
as the types of waste and the levels of waste facilities they would like to examine. The visualisatons are also interactive,
as well as highlighting particular areas of interest such as the countries outside the UK where waste is processed.

# Credits

This project was part of the Data Analysis course at CodeClan.
