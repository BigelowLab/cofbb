library(devtools)

on.exit({
  setwd(orig_dir)
})

data_path = "/mnt/s1/projects/ecocast/coredata/cofbb/bbox_lonlat.csv"
pkg_path = "/mnt/s1/projects/ecocast/corecode/R/cofbb"
out_path = file.path(pkg_path, "inst/bbox_lonlat.csv")
ok = file.copy(data_path, out_path, overwrite = TRUE)
if (system("whoami", intern = TRUE) == "root"){
  devtools::install(pkg_path)
}

orig_dir = getwd()
setwd(pkg_path)
ok = system(sprintf("git commit -a -m '%s'", format(Sys.time(), "%Y-%m-%dT%H:%M:%S")))
if (ok == 0){
  ok = system("git push origin main")
  if (ok != 0) stop("unable to push to github")
} else {
  stop("unable to make commitment")
}

