
## toexport
arc2.download.iridl <- function(GalParams, nbfile = 3, GUI = TRUE, verbose = TRUE){
    dlpath <- "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.CPC/.FEWS/.Africa"
    vardir <- switch(GalParams$tstep,
                      "daily" = ".DAILY/.ARC2/.daily/.est_prcp",
                      "dekadal" = ".TEN-DAY/.ARC2/.est_prcp",
                      "monthly" = ".DAILY/.ARC2/.monthly/.est_prcp"
                    )

    rlon <- unlist(GalParams$bbox[c('minlon', 'maxlon')])
    rlon <- paste(c('X', rlon, 'RANGE'), collapse = "/")
    rlat <- unlist(GalParams$bbox[c('minlat', 'maxlat')])
    rlat <- paste(c('Y', rlat, 'RANGE'), collapse = "/")

    rdate <- iridl.format.date(GalParams$tstep, GalParams$date.range)
    urls <- urltools::url_encode(paste0("(", rdate$dates, ")"))
    urls <- paste0("T", "/", urls, "/", "VALUE")

    urls <- paste(dlpath, vardir, rlon, rlat, urls, 'data.nc', sep = "/")

    #########
    data.name <- paste0("CHIRPSv2_", GalParams$tstep)
    outdir <- file.path(GalParams$dir2save, data.name)
    dir.create(outdir, showWarnings = FALSE, recursive = TRUE)
    destfiles <- file.path(outdir, paste0("chirps_", rdate$out, ".nc"))

    ret <- cdt.download.data(urls, destfiles, destfiles, nbfile, GUI,
                             verbose, data.name, iridl.download.data)

    return(ret)
}

## toexport
arc2.download.cpc.noaa <- function(GalParams, nbfile = 3, GUI = TRUE, verbose = TRUE){
    rdate <- table.format.date.time(GalParams$tstep, GalParams$date.range)
    ftp.cpc <- "ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/geotiff"
    filename <- sprintf("africa_arc.%s%s%s.tif.zip", rdate[, 1], rdate[, 2], rdate[, 3])
    urls <- file.path(ftp.cpc, filename)
    ncfiles <- sprintf("arc2_%s%s%s.nc", rdate[, 1], rdate[, 2], rdate[, 3])

    #########
    data.name <- paste0("ARC2_", GalParams$tstep)
    outdir <- file.path(GalParams$dir2save, data.name)
    extrdir <- file.path(outdir, "Extracted")
    dir.create(extrdir, showWarnings = FALSE, recursive = TRUE)
    origdir <- file.path(outdir, "Data_Africa")
    dir.create(origdir, showWarnings = FALSE, recursive = TRUE)
    destfiles <- file.path(origdir, filename)
    ncfiles <- file.path(extrdir, ncfiles)

    ret <- cdt.download.data(urls, destfiles, ncfiles, nbfile, GUI,
                             verbose, data.name, fews.download.data.tif,
                             bbox = GalParams$bbox, arc = TRUE)

    return(ret)
}
