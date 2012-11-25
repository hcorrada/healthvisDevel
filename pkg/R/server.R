#' check if local server is running
#' 
#' @export
isServerRunning <- function() {
  txt=try(RCurl::getURLContent(healthvis:::.localURL))
  return(!inherits(txt,"try-error"))
}

#' start the local healthvis http server
#' 
#' @export
startServer <- function() {
  dir=system.file("inst", package="healthvis")
  cwd=getwd()
  setwd(dir)
  res=system("python runit.py", wait=FALSE, ignore.stdout=TRUE, ignore.stderr=TRUE)
  setwd(cwd)
  return(res)
}