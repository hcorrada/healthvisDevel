inst_path="."
python_binary="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/python2.7"
test_that("server setup works", {
  healthvisDevel::setup(path=inst_path, python_binary=python_binary)
  expect_that(file.exists(file.path(inst_path,"healthvisServer")), is_true())
})

test_that("startServer works", {
  url=healthvisDevel::startServer(path=inst_path)
  Sys.sleep(5)
  expect_that(file.exists(file.path(inst_path,"healthvisServer/.serverpid")), is_true())
})

test_that("isServerRunning works", {
  expect_that(healthvisDevel::isServerRunning(), is_true())
})

test_that("getURL works", {
  url=healthvisDevel::getURL()
  browseURL(url)
  expect_that(is.character(RCurl::getURLContent(url)), is_true())
})

test_that("stopServer works", {
  healthvisDevel::stopServer()
  expect_that(file.exists(file.path(inst_path,"healthvisServer/.serverpid")), is_false())
  expect_that(healthvisDevel::isServerRunning(), is_false())
})