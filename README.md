# CyPlotContact
CyPlotContact is a MATLAB GUIDE program I wrote at early stages of my PhD in order to calculate and analyze Contact Mode Colloidal AFM force measurements. The program imports Igor's software IBW files containing deflection and stage position information and converts them into force vs distance curves. The program features a grouping mechanism that allows to group multiple force curves and average them to increase signal-to-noise ratio.

The "Cy" in the program name is after the name of the main AFM I worked on, which is Cypher VRS by Asylum Research.

## Features
- Easy and quick calculation of force curves
- Grouping of force curves and represent them by an average curve
- Coloring groups for further convenience
- Exports MATLAB struct with all relevant force group data
- Spring constant is extracted from the IBW file
- Fits data to DLVO theory. Other fit models can be added easily
- Plot in linear, semiology and log-log scales.
- Option to plot an arbitrary function together with the force curves.


Note that many of the program options are available through right-click on the relevant area (tables and figures)

## Images
The image below shows file import and force calculation on the left, and force groups on the right.
![](./images/program.png)
