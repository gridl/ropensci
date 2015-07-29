## Start with the rstudio image providing 'base R' as well as RStudio based on Debian testing
FROM rocker/hadleyverse
MAINTAINER Carl Boettiger cboettig@ropensci.org

## Refresh package list and upgrade
RUN apt-get update \
&& apt-get install -y --no-install-recommends -t unstable \
    cdbs \
    gdal-bin \
    icedtea-netx \
    libxslt1-dev \
    libgeos-dev \
    libgeos-c1 \
    libgdal1h \
    libgdal1-dev \
    libgl1-mesa-dev \ 
    libhiredis-dev \
    libproj-dev \
    librdf0-dev \
    libsasl2-dev \
		libv8-dev \
    netcdf-bin \
    python-pip

## Install additional Omegahat dependencies, with fallback to Github-based install 
RUN rm -rf /tmp/*.rds \
&& install2.r --error \
    -r http://cran.rstudio.com \
    -r http://www.omegahat.org/R \
    -r http://datacube.wu.ac.at \
    dismo \
    geiger \
    git2r \
    knitcitations \
    pander \
    phylobase \
    phytools \
    Rcampdf \
    Rcompression \
    RHTMLForms \
    ROOXML \
    RWordXML \
    SSOAP \
    Sxslt \
    XMLSchema \
||  installGithub.r \
    omegahat/Rcompression \
    omegahat/RHTMLForms \
    duncantl/ROOXML \
    duncantl/RWordXML \
    omegahat/XMLSchema \
    omegahat/SSOAP/Install \
    omegahat/Sxslt \
&&  installGithub.r \
    DataONEorg/rdataone/dataonelibs \
    ropensci/rdataone/dataone \
    eddelbuettel/drat \
    egonw/rrdf/rrdflibs \
    egonw/rrdf/rrdf \
    ramnathv/rcharts \
    ropensci/EML \
    ropensci/ropkgs \
    cboettig/drat.builder \
    cloudyr/aws.signature \
    cloudyr/aws.s3@cboettig \
    eddelbuettel/rcppredis \
    iDigBio/ridigbio \
&& Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("rhdf5", ask=FALSE); biocLite("sangerseqR", ask=FALSE)' \
&& pip install retriever \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds 

## Install the rOpenSci R packages that are currently on CRAN. must use single quote notation
RUN R -e 'out <- ropkgs::ro_pkgs(); install.packages(out$packages$name[out$packages$on_cran])' \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
