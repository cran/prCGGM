## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", fig.width = 5,
                      fig.height = 4.5)

## ----setup--------------------------------------------------------------------
library(prCGGM)

## ----data---------------------------------------------------------------------
data(prcggm_example)
x <- prcggm_example$x
covariates <- prcggm_example$covariates
prior <- prcggm_example$prior
dim(x)
table(covariates$x1)
prior[1:5, 1:5]

## ----variants-----------------------------------------------------------------
set.seed(1)
fit_ggm <- prcggm(x)
fit_ggm
fit_full <- prcggm(x, covariates = covariates, prior = prior, tune = FALSE)
fit_full

## ----tuning-------------------------------------------------------------------
set.seed(1)
fit <- prcggm(x, covariates = covariates, prior = prior,
              alpha_grid = c(0.5, 0.9), theta_grid = c(1, 1.3))
fit$tuning

## ----summary------------------------------------------------------------------
summary(fit)

## ----plot-baseline------------------------------------------------------------
plot(fit)

## ----plot-covariate-----------------------------------------------------------
plot(fit, component = "x1_1")

## ----predict------------------------------------------------------------------
new_subjects <- data.frame(x1 = factor(c("0", "1")))
nets <- predict(fit, new_subjects)
names(nets)
compare_networks(nets$Subject_1, nets$Subject_2, method = "frobenius")

## ----plot-difference----------------------------------------------------------
plot_network_difference(nets$Subject_2, nets$Subject_1)

## ----simulate-----------------------------------------------------------------
set.seed(2)
sim <- simulate_prcggm_data(n = 500, p = 8, n_binary = 1, n_continuous = 1,
                            prior = "noisy")
fit_sim <- prcggm(sim$x, covariates = sim$covariates, prior = sim$prior,
                  tune = FALSE)
names(fit_sim$networks)

## ----parallel, eval = FALSE---------------------------------------------------
# fit <- prcggm(x, covariates = covariates, prior = prior, ncores = 4)

## ----slurm, eval = FALSE------------------------------------------------------
# # 1. Prepare the inputs and job scripts in a shared directory
# job <- prcggm_slurm_prepare(x, covariates = covariates, prior = prior,
#                             dir = "/scratch/my_project/prcggm")
# job$command   # the sbatch command to submit from a shell
# 
# # 2. Each array task runs prcggm_node() through the copied job script.
# #    Edit prcggm_node.sbatch (partition, memory, R module) before submitting.
# 
# # 3. When all tasks have completed
# fit <- prcggm_slurm_collect("/scratch/my_project/prcggm")

