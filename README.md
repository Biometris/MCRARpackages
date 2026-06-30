
## Package repository for packages used in the MCRA project

This repository is a package repository set up using the `drat` package.
It contains binary versions of R packages used in the MCRA project.
All packages that are loaded directly in the MCRA project are included in the repository,
as well as all their dependencies.
The aim of the repository is to provide a stable set of dependency packages.

For all packages a binary version is included for R versions 4.2 up to 4.5.
The current (11 July 2025) R version used in MCRA is R.4.5.1.
Packages for R 4.3 are included to ease moving to a newer version of R when desired.
The `proast71.1` package is distributed by RIVM. For this package only a R 4.3 binary is available.
This binary can be used for R 4.3 up to 4.5 (compiled with R 4.3)

The addMCRApackages.R script can be used to update this repository and add the latest versions
of the R packages used in MCRA and their dependencies.
The full script can be run directly in R. In the script the following steps are taken:

- The `proast` package is downloaded from the RIVM website using the link specified in the script.
  The downloaded file is renamed to comply with the default naming scheme used in CRAN-like repositories.
  Failing to do so results in the package not being installable.
  The renamed package is then added to the repository.
- All packages specified in rpackages.txt are read.
  This file should contain all R packages that are loaded directly in MCRA
- For all packages in the file, all dependencies are extracted.
- For R versions 4.2 and 4.3 the latest available binary versions for all packages
  are checked on CRAN. If they are newer than the version already present in the repository
  the repository is updated with the newest version, i.e. the newer version is added to the repository.

Addition of packages to the repository is done using the `drat` package.
This package takes care of the bookkeeping and assures packages are put in the correct directories.
The structure of the repository is identical to that of CRAN.
Because of this the standard `install.packages` function can be used to install packages from this repository.
Installing a single package can be done like this:

```r
install.packages("ggplot2",
                 contriburl = "https://biometris.github.io/MCRARpackages/bin/windows/contrib/4.2",
                 type="win.binary")
```

## Update R repository MCRA

The dependencies for the R installation for MCRA are cached in this repository (win binaries) to
be able to always have the same versions for a longer period (year) for MCRA as binary files.

### Prepare local R installation

- Install latest R version locally
- Install drat package `install.packages('drat', 'packrat')`
- Install git
- Install MCRA packages using this R version manually:

  using RStudio, install manually `svglite deSolve factoextra glasso huge igraph jsonlite lme4`

  or run this (choose a )

  `install.packages(c('drat','packrat','svglite','deSolve','factoextra','glasso','huge','igraph','jsonlite','lme4'), dependencies=TRUE, type='win.binary', destdir='x:/r_downloaded_pkgs')`

- Install [proast zip file](https://www.rivm.nl/sites/default/files/2025-06/proast71.1.zip) and OPEX package manually using `install from package archive`
- Update MCRA to use the new version of R
- Make it work, check everything

After the local R installation is complete and MCRA works correctly, the `addMCRApackages.R` script can be run.

### Test script locally

To test the flow and not commit directly to GitHub, create a local bare repository, add it as remote to test the `addMCRApackages.R` script,
do update the R script to use the local repo(s)

```sh
cd /x/Data/
# Create a bare repository based on the github repo to use as the remote during the test.
git clone --bare https://github.com/Biometris/MCRARpackages /x/Data/MCRARPackagesBare.git

# OR clone to bare from local dev repo connected to github
git clone --bare /d/Git2/MCRARPackages /x/Data/MCRARPackagesBare.git

# Clone this repo to have it's remote set to the bare clone created above
git clone MCRARPackagesBare.git rpackstest
cd rpackstest/

```

Update the R script to test uploading a new version.
