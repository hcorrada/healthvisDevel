inst_path="."

test_that("survival works on gae", {
  if (!healthvisDevel::isServerRunning()) {
    healthvisDevel::startServer(path=inst_path)
    Sys.sleep(5)
  }
  
  url=healthvisDevel::getURL()
  
 # url="http://localhost:5000"
  require(survival)
  cobj=coxph(Surv(time, status) ~ trt+age+celltype,data=veteran)  
  visCobj=healthvis::survivalVis(cobj, veteran, plot.title="Veteran survival test",url=url,plot=TRUE)
  expect_that(visCobj@serverID!="error", is_true())
})