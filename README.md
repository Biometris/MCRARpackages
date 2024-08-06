
## Package repository for packages used in the MCRA project

This repository is a package repository set up using the `drat` package. It contains binary versions of R packages used in the MCRA project. All packages that are loaded directly in the MCRA project are included in the repository, as well as all their dependencies. The aim of the repository is to provide a stable set of dependency packages.

For all packages a binary version is included for R versions 4.2 and 4.3. The current (5 Feb 2024) R version used in MCRA is R.4.2.1. Packages for R 4.3 are included to ease moving to a newer version of R when desired.
The `proast70.3` package is distributed by RIVM. For this package only a R 4.0 binary is available. This binary can be used for both R.4.2 and R.4.3.

The addMCRApackages.R script can be used to update this repository and add the latest versions of the R packages used in MCRA and their dependencies. The full script can be run directly in R. In the script the following steps are taken:

- The `proast` package is downloaded from the RIVM website using the link specified in the script. The downloaded file is renamed to comply with the default naming scheme used in CRAN-like repositories. Failing to do so results in the package not being installable. The renamed package is then added to the repository.
- All packages specified in rpackages.txt are read. This file should contain all R packages that are loaded directly in MCRA
- For all packages in the file, all dependencies are extracted.
- For R versions 4.2 and 4.3 the latest available binary versions for all packages are checked on CRAN. If they are newer than the version already present in the repository the repository is updated with the newest version, i.e. the newer version is added to the repository.

Addition of packages to the repository is done using the `drat` package. This package takes care of the bookkeeping and assures packages are put in the correct directories. The structure of the repository is identical to that of CRAN. Because of this the standard `install.packages` function can be used to install packages from this repository. Installing a single package can be done like this:
```r
install.packages("ggplot2",
                 contriburl = "https://biometris.github.io/MCRARpackages/bin/windows/contrib/4.2",                      type="win.binary")
```



