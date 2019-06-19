# Usage Overview
XCIST will be downloadable as a straighforward, ready-to-use, GUI-driven Python application that will run under both Linux and Windows. (The compute-intensive work will be done in run-time-linked binary libraries.) To perform a simulation, users will need to have [Python installed](https://github.com/xcist/documentation/wiki/Installing-Python). Then, using either our GUI or simple configuration files, you will simply need to
1. Select an imaging system configuration from a pre-defined standard system with or without variations based on several available component models (or advanced users can develop their own models).
2. Select a scan protocol from several pre-defined protocols and multiple user-selectable variations such as kVp, mA, rotation time, focal spot, bowtie, etc.
3. Select simulation options from several pre-defined configurations and multiple user-selectable variations including oversampling, with or without quantum and/or electronic noise, etc.
4. Select a subject to be scanned (i.e a numerical phantom) from a rich library of geometric phantoms and virtual patient models with and without tumors (or advanced users can develop their own phantoms).
5. Select a reconstruction algorithm from several pre-defined options (or advanced users can develop their own reconstruction).
6. Launch your simulation.
7. Review the results! (available as simple binary files and/or in DICOM format)

**The code repository is [here](https://github.com/xcist/code).**
