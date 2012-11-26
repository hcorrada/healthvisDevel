#' setup the python evironment for development
#' 
#' @param path where to install the devel files, directory is created if it doesn't exist
#' @exprt
setup <- function(path=".") {
  script_path=system.file("inst", package="healthvisDevel")
  cmd=sprintf("%s/setup.sh %s %s", script_path, path, script_path)
  res=system(cmd,wait=TRUE)
  if (res>0) 
    stop("Error setting up healthvisDevel")
  invisible(path)
}

#' start the local healthvis http server
#' 
#' @param path path to installation directory
#' @return http server url (including port)
#' @export
startServer <- function(path=".", verbose=FALSE) {
  for (port in seq(5000,5100)) {
    if (verbose)
      cat("Trying port ", port, "\n")
    cmd=sprintf("sh %s/healthvisServer/bin/startserver.sh %s %d", path, path, port)
    res=system(cmd, wait=TRUE)
    if (res == "0") break
  }
  url=sprintf("http://localhost:%d", port)
  assign(".localURL", url, env=.params)
  return(url)
}

#' stop the local healthvis http server
#' 
#' @param path path to installation directory
#' @export
stopServer <- function(path=".", verbose=FALSE) {
  cmd=sprintf("sh %s/healthvisServer/bin/stopserver.sh %s", path, path)
  invisible(system(cmd, ignore.stdout=TRUE, ignore.stderr=TRUE))
}

#' check if local server is running
#' 
#' @export
isServerRunning <- function() {
  url=get(".localURL", env=.params)
  txt=try(RCurl::getURLContent(url))
  return(!inherits(txt,"try-error"))
}
