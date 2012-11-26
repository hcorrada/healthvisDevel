path=tempdir()

test_that("server setup works", {
  healthvisDevel::setup(path=path)
  expect_that(file.exists(file.path(path,"healthvisServer")), is_true())
})

test_that("startServer works", {
  url=healthvisDevel::startServer(path=path)
  Sys.sleep(5)
  browseURL(url)
  expect_that(file.exists(file.path(path,"healthvisServer/.serverpid")), is_true())
})

test_that("isServerRunning works", {
  expect_that(healthvisDevel::isServerRunning(), is_true())
})

test_that("stopServer works", {
  healthvisDevel::stopServer(path=path)
  expect_that(file.exists(file.path(path,"healthvisServer/.serverpid")), is_false())
})