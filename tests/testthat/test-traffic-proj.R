context("Traffic projections")

test_that("Traffic projections are correct", {
    expect_equal(as.numeric(
        traffic_proj(base_yr = 2016,
                     base_aadt = 18000,
                     opening_yr = 2019,
                     pc_hgv = 0.05,
                     region = "Mid-East")[66, 4]),
        8991132)
    expect_equal(nrow(
        traffic_proj(base_yr = 2016,
                     base_aadt = 18000,
                     opening_yr = 2019,
                     pc_hgv = 0.05,
                     region = "Mid-East")),
        76)
    expect_is(traffic_proj(base_yr = 2016,
                           base_aadt = 18000,
                           opening_yr = 2019,
                           pc_hgv = 0.05,
                           region = "Mid-East"),
              "data.frame")
})