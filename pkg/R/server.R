#' setup the python evironment for development
#' 
#' @param path where to install the devel files, directory is created if it doesn't exist
#' @export
setup <- function(path=".", python_binary="python") {
  script_path=system.file("inst", package="healthvisDevel")
  cmd=sprintf("%s/setup.sh %s %s %s", script_path, path, script_path, python_binary)
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
  if (res != "0")
    stop("Error starting server")
  
  url=sprintf("http://localhost:%d", port)
  assign(".localURL", url, env=healthvisDevel:::.params)
  assign(".serverPath", path, env=healthvisDevel:::.params)
  return(url)
}

#' stop the local healthvis http server
#' 
#' @param path path to installation directory
#' @export
stopServer <- function(verbose=FALSE) {
  path=get(".serverPath", env=healthvisDevel:::.params)
  cmd=sprintf("sh %s/healthvisServer/bin/stopserver.sh %s", path, path)
  invisible(system(cmd, ignore.stdout=TRUE, ignore.stderr=TRUE))
}

#' check if local server is running
#' 
#' @export
isServerRunning <- function() {
  url=get(".localURL", env=healthvisDevel:::.params)
  txt=try(RCurl::getURLContent(url))
  return(!inherits(txt,"try-error"))
}

#' get the local server url
#' 
#' @export
getURL <- function() {
  get(".localURL", env=.params)
}
