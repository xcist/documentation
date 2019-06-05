## Welcome to XCIST: X-ray-based Cancer Imaging Toolkit

XCIST will provide the ability to simulate X-ray/CT images of virtual patients (with or without tumors). These images will accurately represent images that would be produced by a real scanner.

XCIST will include three primary groups of components:
- Simulation components, including physics-based models of scanner hardware and physical processes
- Imaging subjects (phantoms) including geometric objects and numerical anthropomorphic phantoms (virtual patients) with or without tumors
- Image reconstruction

XCIST will be downloadable as a straighforward, ready-to-use, GUI-driven Python application that will run under both Linux and Windows. (The compute-intensive work will be done in run-time-linked binary libraries.) To perform a simulation, users will need to have Python installed. Then, using either our GUI or simple configuration files, you will simply need to
1. Select an imaging system configuration from a pre-defined standard system with or without variations based on several available component models (or advanced users can develop their own models).
2. Select a scan protocol from several pre-defined protocols and multiple user-selectable variations such as kVp, mA, rotation time, focal spot, bowtie, etc.
3. Select simulation options from several pre-defined configurations and multiple user-selectable variations including oversampling, with or without quantum and/or electronic noise, etc.
4. Select a subject to be scanned (i.e a numerical phantom) from a rich library of geometric phantoms and virtual patient models with and without tumors (or advanced users can develop their own phantoms).
5. Select a reconstruction algorithm from several pre-defined options (or advanced users can develop their own reconstruction).
6. Launch your simulation.
7. Review the results! (available as simple binary files and/or in DICOM format)

The standard components are being developed by:
* Simulation and validation - GE Research
  - [Bruno De Man (Principle Investigator)](https://www.ge.com/research/people/bruno-de-man)
  - [Mingye Wu](https://www.ge.com/research/people/mingye-wu)
  - [Brion Sarachan](https://www.ge.com/research/people/brion-sarachan)
  - [Paul FitzGerald](https://www.ge.com/research/people/paul-fitzgerald)
* Anthropomorphic numerical phantoms - Duke University
  - [Paul Segars](https://radiology.duke.edu/faculty/w-paul-segars-phd/)
  - [Ehsan Samei](https://radiology.duke.edu/faculty/ehsan-samei-phd/)
* Image reconstruction - UMass Lowell
  - [Hengyong Yu](https://www.uml.edu/engineering/electrical-computer/faculty/yu-hengyong.aspx)

You are invited to join our project! The code repository is [here](https://github.com/PaulFitzGerald/practice).

This open-access project is supported by the National Cancer Institute of the National Institutes of Health under Award Number U01CA231860.

The authors request that any publications that rely on this project should cite the project by referencing [![DOI](https://zenodo.org/badge/190272273.svg)](https://zenodo.org/badge/latestdoi/190272273) (the DOI for this project) or a [relevant publication found on ResearchGate](https://www.researchgate.net/project/XCIST-X-ray-based-Cancer-Imaging-Toolkit).
