library(drat)

## Configuration
## Production values
## flag to commit the separate packages to the local repository
CommitPackagesToRepo <- TRUE
RemoteWriteRepo <- 'https://biometris.github.io/MCRARpackages'
## after the script completes, push manually to the remote repo.

## Test values, adjust folder names to suit your test environment
## uncomment these to run tests
# CommitPackagesToRepo <- FALSE
# RemoteWriteRepo <- 'x:/Data/MCRARPackagesBare.git'

RemoteDownloadRepo <- 'https://cran.r-project.org'

## Get all installed packages.
pkgInst <- installed.packages()

## Load file with packages used in MCRA.
pkgList <- read.delim("./rpackages.txt", header = FALSE)$V1

## Get all dependencies.
pkgDeps <- sapply(X = pkgList,
                  FUN = packrat:::recursivePackageDependencies,
                  ignores = "", lib.loc = .libPaths())

pkgInstFull <- unique(c(unlist(pkgDeps), pkgList))
## proast and opex are not available on CRAN and have to be installed by hand.
## Exclude them from the list.
pkgInstFull <- setdiff(pkgInstFull, c("proast71.1", "opex"))

pkgInstDat <- as.data.frame(pkgInst[rownames(pkgInst) %in% pkgInstFull &
                                      is.na(pkgInst[, "Priority"]), ])

## Add to github repo for R versions 4.2 and 4.3 and 4.4 and 4.5

options(dratBranch = "docs")

tmpDir <- tempdir()

## Add proast to repo.
## proast is compiled for R 4.3.2.
download.file("https://www.rivm.nl/sites/default/files/2025-06/proast71.1.zip",
              destfile = file.path(tmpDir, "proast71.1.zip"))

file.rename(file.path(tmpDir, "proast71.1.zip"),
            file.path(tmpDir, "proast71.1_0.01.zip"))

insertPackage(file = file.path(tmpDir, "proast71.1_0.01.zip"),
              repodir = paste0("."),
              commit = CommitPackagesToRepo)

## Add opex to repo.
## For opex the source code is available. From this we compiled binaries for
## R4.6, (previously R.4.2/3/4/5) These are added to the repo.
insertPackage(file = file.path("./opex/4.6", "opex_2.0.0.zip"),
              repodir = paste0("."),
              commit = CommitPackagesToRepo)

## Add all other packages to github repo.
## Packages are added for R versions 4.x.y
## Only packages for which a newer version is available are added.
for (Rver in c("4.6")) {
  repoLoc <- paste0(RemoteWriteRepo, "/bin/windows/contrib/", Rver)
  pkgInstMCRA <- as.data.frame(available.packages(repoLoc))
  for (i in 1:nrow(pkgInstDat)) {
    pkgName <- pkgInstDat$Package[i]
    pkgVer <- pkgInstDat$Version[i]
    instVersion <- pkgInstMCRA[pkgName, "Version"]
    if (is.na(instVersion) || pkgVer > instVersion) {
      pkgString <- paste0(pkgName, "_", pkgVer, ".zip")
      download.file(paste0(RemoteDownloadRepo, "/bin/windows/contrib/",
                           Rver, "/", pkgString),
                    destfile = file.path(tmpDir, pkgString))
      insertPackage(file = file.path(tmpDir, pkgString),
                    repodir = paste0("."),
                    commit = CommitPackagesToRepo)
    }
  }
}
