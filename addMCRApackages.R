library(drat)

## Get all installed packages.
pkgInst <- installed.packages()

## Load file with packages used in MCRA.
pkgList <- read.delim("./rpackages.txt", header = FALSE)$V1 

## Get all dependencies.
pkgDeps <- sapply(X = pkgList,
                  FUN = packrat:::recursivePackageDependencies, 
                  ignores = "", lib.loc = .libPaths())

pkgInstFull <- unique(c(unlist(pkgDeps), pkgList))
pkgInstFull <- setdiff(pkgInstFull, "proast70.3")

pkgInstDat <- as.data.frame(pkgInst[rownames(pkgInst) %in% pkgInstFull &
                                      is.na(pkgInst[, "Priority"]), ])

## Add to github repo for R versions 4.2 and 4.3

options(dratBranch = "docs")

tmpDir <- tempdir()

## Add proast to repo.
## proast is compiled for R 4.0. 

download.file("https://www.rivm.nl/sites/default/files/2021-06/proast70.3.zip",
              destfile = file.path(tmpDir, "proast70.3.zip"))

file.rename(file.path(tmpDir, "proast70.3.zip"), 
            file.path(tmpDir, "proast70.3_0.01.zip"))

insertPackage(file = file.path(tmpDir, "proast70.3_0.01.zip"),
              repodir = paste0("."),
              commit = TRUE)

## Add all other packages to github repo.
## Packages are added for R versions 4.2.x and 4.3.x.
## Only packages for which a newer version is available are added.
for (Rver in c("4.2", "4.3")) {
  repoLoc <- paste0("https://biometris.github.io/MCRARpackages/bin/windows/contrib/", Rver)
  pkgInstMCRA <- as.data.frame(available.packages(repoLoc))
  for (i in 1:nrow(pkgInstDat)) {
    pkgName <- pkgInstDat$Package[i]
    pkgVer <- pkgInstDat$Version[i]
    instVersion <- pkgInstMCRA[pkgName, "Version"]
    if (pkgVer > instVersion) {
      pkgString <- paste0(pkgName, "_", pkgVer, ".zip")
      download.file(paste0("https://cran.r-project.org/bin/windows/contrib/", 
                           Rver, "/", pkgString),
                    destfile = file.path(tmpDir, pkgString))
      insertPackage(file = file.path(tmpDir, pkgString),
                    repodir = paste0("."),
                    commit = TRUE)    }
  }
}
