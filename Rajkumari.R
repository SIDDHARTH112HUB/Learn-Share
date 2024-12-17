

























































Ques1:
Generate sufficient random numbers from exponential distribution where the parameter is of your choice. Let consider these generated numbers as a lifetime of the patients then obtain the patient lifetime using the following censoring schemes:
Right Censoring
a.     Type-I Censoring Scheme
b.      Type-II Censoring Scheme
c.       Random Censoring
Left Censoring
Interval Censoring
Also compare the censored data with the complete data.
Code
#Right censoring
n <- 100
lambda <- 0.5
life_time <- rexp(n, rate = lambda)
#Type1 censoring

c1=50
censored_data<-ifelse(life_time>c1,c1,life_time)
censored_data


#Type-II Censoring (Stop after a certain number of events)
life_time <- rexp(n, rate = lambda)
c2 <- 70  # Number of events we want to observe before stopping
life_time=sort(life_time)
censored_data<-ifelse(life_time>life_time[c2],life_time[c2],life_time)
censored_data

#Type-III Censoring
ctime <- rexp(100, rate=lambda)
ctime
cdata <- ifelse(life_time<=ctime,life_time, ctime)
cstuts <- ifelse(life_time<=ctime,1, 0)
random.data <- cbind(cdata, cstuts)
print(random.data)


#Left censoring
n <- 100
lambda <- 0.5
life_time<-rexp(n, rate = lambda)
c3=1
left_censored=life_time<c3
left_censored
life_time[left_censored]=c3
life_time

#Interval_censoring
n <- 100
lambda <- 0.5
life_time=rexp(n, rate = lambda)
list=c(2,4,6,8,10,12)
for(i in list){
  interval_censored=(life_time>=i)&(life_time<=i+1)
  print(length(life_time[interval_censored]))
}


Ques2:
Obtain a sufficiently large sample from an exponential distribution under a Type II
censoring scheme. After generating the sample, calculate the maximum likelihood
(ML) estimate of the distribution parameter. Also, evaluate the performance of the
estimate by computing the bias, variance, and mean squared error (MSE) for different
sample sizes.

Code:
n<-200
lamda<-0.3
m<-c(40,80,120,150,180,200)
simulation<-1000
evaluate_performace<-function(n,rate,m,simulation){
  estimates<-numeric(simulation)
  for(i in 1:simulation){
  life<-rexp(n,rate)
  censored_life<-sort(life)[1:m]
  estimates[i]<-m/(sum(censored_life)+(n-m)*sort(life)[m])
  }
  bias<-mean(estimates)-rate
  variance<-var(estimates)
  mse<-mean((estimates-rate)^2)
  return(list(bias=bias,variance=variance,mse=mse,estimate=mean(estimates)))
}
results<-data.frame(
  m=integer(),
  lamda_hat=numeric(),
  bias=numeric(),
  mse=numeric()
)
#starting loop for different m
for (i in m){
  performance<-evaluate_performace(n,lamda,i,simulation)
  #creating table
  results<-rbind(results,data.frame(
    m=i,
    lamda_hat=performance$estimate,
    bias=performance$bias,
    variance=performance$variance,
    mse=performance$mse
     )) 
}
print(results) 


Ques3:
Obtain a sufficiently large sample from a Weibull distribution under a Type I
censoring scheme. After generating the sample, calculate the maximum likelihood
(ML) estimate of the distribution parameters. Also, evaluate the performance of the
estimate by computing the bias, variance, and mean squared error (MSE) for different
sample sizes.
Code:
# Parameters
set.seed(123)
n_values <- c(100, 200, 300)       # Sample sizes
true_shape <- 2                    # True Weibull shape parameter
true_scale <- 3                    # True Weibull scale parameter
censoring_time <- 5                # Censoring time for Type-I censoring
simulation <- 1000                 # Number of simulations

# Log-likelihood function for censored Weibull data
weibull_log_likelihood <- function(params, data, censoring_time) {
  shape <- params[1]; scale <- params[2]
  uncensored <- data[data <= censoring_time]
  censored <- data[data > censoring_time]
  
  # Log-likelihood: uncensored and censored contributions
  ll_uncensored <- sum(dweibull(uncensored, shape, scale, log = TRUE))
  ll_censored <- sum(pweibull(censored, shape, scale, lower.tail = FALSE, log.p = TRUE))
  
  return(-(ll_uncensored + ll_censored))  # Negative log-likelihood
}

# Performance Evaluation for Type-I Censoring
evaluate_performance <- function(n, shape, scale, censoring_time, simulation) {
  shape_estimates <- scale_estimates <- numeric(simulation)
  
  for (i in 1:simulation) {
    # Generate and censor data
    life <- rweibull(n, shape, scale)
    censored_life <- pmin(life, censoring_time)
    
    # Estimate parameters via MLE
    fit <- optim(par = c(1, 1), fn = weibull_log_likelihood, data = censored_life,
                 censoring_time = censoring_time, method = "L-BFGS-B", lower = c(0.1, 0.1))
    shape_estimates[i] <- fit$par[1]
    scale_estimates[i] <- fit$par[2]
  }
  
  # Calculate bias, variance, MSE
  return(list(
    bias_shape = mean(shape_estimates) - shape, 
    bias_scale = mean(scale_estimates) - scale,
    var_shape = var(shape_estimates), 
    var_scale = var(scale_estimates),
    mse_shape = mean((shape_estimates - shape)^2),
    mse_scale = mean((scale_estimates - scale)^2)
  ))
}

# Run simulations and collect results
results <- data.frame()
for (n in n_values) {
  perf <- evaluate_performance(n, true_shape, true_scale, censoring_time, simulation)
  results <- rbind(results, data.frame(
    n = n, shape_hat = true_shape - perf$bias_shape, scale_hat = true_scale - perf$bias_scale,
    bias_shape = perf$bias_shape, bias_scale = perf$bias_scale, 
    var_shape = perf$var_shape, var_scale = perf$var_scale,
    mse_shape = perf$mse_shape, mse_scale = perf$mse_scale
  ))
}

print(results)


Ques4:
Obtain a sufficiently large sample from a Weibull distribution under type II censoring
scheme. After generating the sample, calculate the maximum likelihood (ML)
estimate of the distribution parameters. Also, evaluate the performance of the estimate
by computing the bias, variance, and mean squared error (MSE) for different sample
sizes.
Code:
# Parameters
set.seed(123)
n_values <- c(100, 200, 300)     # Sample sizes
true_shape <- 2                  # True Weibull shape parameter
true_scale <- 3                  # True Weibull scale parameter
c2 <- 80                         # Number of observed events before censoring (Type-II)
simulation <- 1000               # Number of simulations

# Log-likelihood function for Type-II censored Weibull data
weibull_log_likelihood <- function(params, data, c2) {
  shape <- params[1]; scale <- params[2]
  uncensored <- data[1:c2]                    # First c2 events are observed (uncensored)
  censored_part <- (length(data) - c2) * log(pweibull(data[c2], shape, scale, lower.tail = FALSE))
  ll_uncensored <- sum(dweibull(uncensored, shape, scale, log = TRUE))
  return(-(ll_uncensored + censored_part))    # Negative log-likelihood
}

# Performance Evaluation for Type-II Censoring
evaluate_performance <- function(n, shape, scale, c2, simulation) {
  shape_estimates <- scale_estimates <- numeric(simulation)
  
  for (i in 1:simulation) {
    # Generate and sort Weibull sample
    life <- sort(rweibull(n, shape, scale))
    
    # Estimate parameters using MLE on censored data
    fit <- optim(par = c(1, 1), fn = weibull_log_likelihood, data = life,
                 c2 = c2, method = "L-BFGS-B", lower = c(0.1, 0.1))
    shape_estimates[i] <- fit$par[1]
    scale_estimates[i] <- fit$par[2]
  }
  
  # Calculate bias, variance, and MSE
  return(list(
    bias_shape = mean(shape_estimates) - shape, 
    bias_scale = mean(scale_estimates) - scale,
    var_shape = var(shape_estimates), 
    var_scale = var(scale_estimates),
    mse_shape = mean((shape_estimates - shape)^2),
    mse_scale = mean((scale_estimates - scale)^2)
  ))
}

# Run simulations and collect results for different sample sizes
results <- data.frame()
for (n in n_values) {
  perf <- evaluate_performance(n, true_shape, true_scale, c2, simulation)
  results <- rbind(results, data.frame(
    n = n, shape_hat = true_shape - perf$bias_shape, scale_hat = true_scale - perf$bias_scale,
    bias_shape = perf$bias_shape, bias_scale = perf$bias_scale, 
    var_shape = perf$var_shape, var_scale = perf$var_scale,
    mse_shape = perf$mse_shape, mse_scale = perf$mse_scale
  ))
}

print(results)

Ques5:
The following data represents the readmission times(weeks) for 21 people of
leukemia patients. Group 1 is the treatment group and group 2 is the placebo group
 Group 1(treatment)
6,6,6,7,10,13,16,22,23,6+,
9+,10+,11+,17+,19+,20+,
25+,32+,32+,34+,35+
Group 2(placebo)
1,1,2,2,3,4,4,5,5,
8,8,8,8,11,11,12,
12,15,17,22,23
 Note: + denotes censored
Estimate the survival and hazard curve for both group by the Kaplan-Meier method.



Code:

# Data for both groups (time in weeks)
group1 <- c(6, 6, 6, 7, 10, 13, 16, 22, 23, 6, 9, 10, 11, 17, 19, 20, 25, 32, 32, 34, 35)  # Treatment
group1_censored <- c(6, 9, 10, 11, 17, 19, 20, 25, 32, 32, 34, 35)  # Censored times for Treatment

group2 <- c(1, 1, 2, 2, 3, 4, 4, 5, 5, 8, 8, 8, 8, 11, 11, 12, 12, 15, 17, 22, 23)  # Placebo

# Combine data into a single data frame (with censoring for Group 1)
treatment_data <- data.frame(time = c(group1, group1_censored), status = c(rep(1, length(group1)), rep(0, length(group1_censored))))
placebo_data <- data.frame(time = group2, status = rep(1, length(group2)))

# Kaplan-Meier function to estimate survival probabilities
kaplan_meier <- function(time, status) {
  # Combine time and status into a data frame and sort by time
  df <- data.frame(time = time, status = status)
  df <- df[order(df$time), ]
  
  # Initialize survival probabilities (first survival probability is 1)
  df$survival_prob <- rep(1, nrow(df))
  
  # Calculate survival probabilities at each time point
  for (i in 1:nrow(df)) {
    # Calculate the number at risk at time[i]
    at_risk <- sum(df$time >= df$time[i])
    
    # If the event occurred (status = 1), calculate survival probability
    if (df$status[i] == 1) {
      if (i == 1) {
        df$survival_prob[i] <- 1 - 1 / at_risk  # First time point, initial survival probability
      } else {
        df$survival_prob[i] <- df$survival_prob[i - 1] * (1 - 1 / at_risk)
      }
    } else {
      df$survival_prob[i] <- df$survival_prob[i - 1]  # If censored, carry forward previous survival probability
    }
  }
  
  return(df)
}

# Apply Kaplan-Meier estimator for both groups
treatment_km <- kaplan_meier(treatment_data$time, treatment_data$status)
placebo_km <- kaplan_meier(placebo_data$time, placebo_data$status)

# Show survival probabilities for both groups
cat("Treatment Group Survival Probabilities:\n")
print(treatment_km[, c("time", "survival_prob")])

cat("\nPlacebo Group Survival Probabilities:\n")
print(placebo_km[, c("time", "survival_prob")])

# Plot the Kaplan-Meier survival curves
plot(treatment_km$time, treatment_km$survival_prob, type = "s", col = "blue", lwd = 2, xlab = "Time (weeks)", ylab = "Survival Probability", main = "Kaplan-Meier Survival Curve")
lines(placebo_km$time, placebo_km$survival_prob, type = "s", col = "red", lwd = 2)

# Add legend
legend("topright", legend = c("Treatment", "Placebo"), col = c("blue", "red"), lwd = 2)
Ques6:
A clinical trial investigates the effectiveness of a new drug on 10 lung cancer patients.
The study started in January 2011 and continued till December 2012. The data is
divided into two groups. Group A (treated with the new drug) and group B (treated with
the standard treatment). The survival time is given in months. During the trial, some
people joined. The data looks like below:
Patient id Group Survival
time(months)
 
Event(1=death,0=censored)
 
1 A 5 1
2 A 12 1
3 A 18 0(censored)
4 A 20 0(censored)
5 A 24 1
6 B 8 1
7 B 10 0(censored)
8 B 15 1
9 B 16 1
10 B 22 1
Calculate and plot the PL estimate of the probability of surviving 2 years or more for
both groups. Also, comment on the plots.
b) Suppose that 10 patients joined at the beginning of 24 months; during those months
4 patients died and 6 patients survived. Estimate the proportion of patients in the
population surviving for 24 months or more if the study terminates at 24 months.


Code:

# Input data
time <- c(5, 12, 18, 20, 24, 8, 10, 15, 18, 22)
event <- c(1, 1, 0, 0, 1, 1, 0, 1, 1, 1)  # 1 = death, 0 = censored
group <- c("A", "A", "A", "A", "A", "B", "B", "B", "B", "B")

# Split data by group
group_A <- which(group == "A")
group_B <- which(group == "B")

# Function to calculate Kaplan-Meier estimates manually
km_manual <- function(times, events) {
  # Sort by time
  order_idx <- order(times)
  times <- times[order_idx]
  events <- events[order_idx]
  
  # Initialize variables
  survival <- 1
  km_survival <- c(survival)
  n_risk <- length(times)  # Start with all patients at risk
  
  # Iterate through time points
  for (i in 1:length(times)) {
    if (events[i] == 1) {  # Only consider uncensored data (death)
      survival <- survival * (1 - 1 / n_risk)  # Update survival probability
    }
    km_survival <- c(km_survival, survival)
    n_risk <- n_risk - 1  # Reduce the number of people at risk
  }
  
  return(km_survival[-1])  # Return survival probabilities (excluding initial 1)
}

# Calculate KM estimates for Group A and Group B
km_A <- km_manual(time[group_A], event[group_A])
km_B <- km_manual(time[group_B], event[group_B])

# Plot KM estimates for Group A
plot(c(0, time[group_A]), c(1, km_A), type = "s", col = "blue", ylim = c(0, 1),
     xlab = "Time in months", ylab = "Survival Probability",
     main = "Kaplan-Meier Survival Curves", lwd = 2, las=1)

# Add KM estimates for Group B
lines(c(0, time[group_B]), c(1, km_B), type = "s", col = "red", lwd = 2)

# Annotate points on Group A curve with survival probabilities
text(c(0, time[group_A]), c(1, km_A), labels = round(c(1, km_A), 2), 
     col = "blue", pos = 3, cex = 0.8)

# Annotate points on Group B curve with survival probabilities
text(c(0, time[group_B]), c(1, km_B), labels = round(c(1, km_B), 2), 
     col = "red", pos = 3, cex = 0.8)

# Add legend to distinguish between groups
legend("bottomleft", legend = c("Group A", "Group B"), col = c("blue", "red"), lwd = 2)

# Display the KM estimates in the console
cat("Kaplan-Meier survival estimates for Group A:\n", round(km_A, 2), "\n")
cat("Kaplan-Meier survival estimates for Group B:\n", round(km_B, 2), "\n")

# Part b data
total_patients <- 10
deaths <- 4
survivors <- total_patients - deaths

# Proportion of patients surviving after 24 months
proportion_surviving <- survivors / total_patients
cat("Proportion of patients surviving after 24 months: ", proportion_surviving, "\n")

Ques7:
Generate sufficient random numbers from a normal distribution where the parameters
are of your choices. Construct a normal probability paper and show that the generated
sample gives the evidence to belong to the normal distribution. Also, comment on
your result.
2. Generate sufficient random numbers from a distribution as per your roll number. Let's
consider these generated numbers as the failure time of machines. First construct a
probability paper for fitting purpose and then verify that the generated data well fits on
the probability paper. Also, comment on your result.
S. No. Model Name Exam Roll No.
1. Exponential 01-15
2. Gamma 16-30
3. Weibull 31-45
4. Lognormal 45-60
Code:
#question1 mandatory for everyone
x1<-qnorm(seq(0.01,0.99,0.01))
x2<-qnorm(seq(0.01,0.99,0.01))
plot(x1,x2,type="n")
abline(h=x1)
abline(v=x1)
n=300
s1<-sort(rnorm(n))
tq<-qnorm(seq(0.01,0.99,length=n))
points(s1,tq,col=2,pch=16)

#q2exp distn
x1<-qexp(seq(0.01,0.99,0.01))
x2<-qexp(seq(0.01,0.99,0.01))
plot(x1,x2,type="n")
abline(h=x1)
abline(v=x1)
n=300
s1<-sort(rexp(n))
tq<-qexp(seq(0.01,0.99,length=n))
points(s1,tq,col=2,pch=16)

# Lognormal Distribution
x1 <- qlnorm(seq(0.01, 0.99, 0.01), meanlog = 0, sdlog = 1)  # Theoretical Lognormal quantiles
x2 <- qlnorm(seq(0.01, 0.99, 0.01), meanlog = 0, sdlog = 1)
plot(x1, x2, type = "n", main = "Lognormal Q-Q Plot")
abline(h = x1)
abline(v = x1)
n <- 300
s1 <- sort(rlnorm(n, meanlog = 0, sdlog = 1))  # Sample Lognormal data
theoretical_quantile <- qlnorm(seq(0.01, 0.99, length = n), meanlog = 0, sdlog = 1)
points(s1, theoretical_quantile, col = 2, pch = 16)

# Weibull Distribution
x1 <- qweibull(seq(0.01, 0.99, 0.01), shape = 2)  # Theoretical Weibull quantiles with shape parameter 2
x2 <- qweibull(seq(0.01, 0.99, 0.01), shape = 2)
plot(x1, x2, type = "n", main = "Weibull Q-Q Plot")
abline(h = x1)
abline(v = x1)
n <- 300
s1 <- sort(rweibull(n, shape = 2)) #sample points
theoretical_quantile <- qweibull(seq(0.01, 0.99, length = n), shape = 2)
points(s1, theoretical_quantile, col = 2, pch = 16)

# Gamma Distribution
x1 <- qgamma(seq(0.01, 0.99, 0.01), shape = 2)  # Theoretical Gamma quantiles with shape parameter 2
x2 <- qgamma(seq(0.01, 0.99, 0.01), shape = 2)
plot(x1, x2, type = "n", main = "Gamma Q-Q Plot")
abline(h = x1)
abline(v = x1)
n <- 300
s1 <- sort(rgamma(n, shape = 2))  # Sample Gamma data with shape parameter 2
theoretical_quantile <- qgamma(seq(0.01, 0.99, length = n), shape = 2)
points(s1, theoretical_quantile, col = 2, pch = 16)
Ques8:
Patient ID Failure time(months) Patient ID Failure time(months)
1 16.5 16 15.4
2 11.7 17 9.9
3 25.3 18 18.7
4 7.8 19 30.6
5 19.2 20 12.3
6 10.6 21 21.1
7 22.7 22 4.9
8 5.1 23 13.5
9 13.9 24 16.1
10 24.6 25 6.2
11 17.3 26 19.8
12 8.4 27 27.4
13 28.2 28 14.7
14 6.7 29 23.9
15 20.5 30 26.5
Suppose that the above data has been extracted from an experiment. The data represents
the lifetime of patients. First, make a probability plot for the data and verify the
distribution from which the data has been generated, and then estimate the parameter
by using a graphical method.


Code:
f_t=c(16.5, 11.7, 25.3, 7.8, 19.2, 10.6, 22.7, 5.1, 13.9, 24.6, 17.3, 8.4, 28.2, 6.7, 20.5, 15.4, 9.9, 18.7, 30.6, 12.3,21.1, 4.9, 13.5, 16.1, 6.2, 19.8, 27.4, 14.7, 23.9, 26.5)
n = length(f_t)
f_t1 = sort(f_t)
prob <- (1:n - 0.5) / n
mean_time = mean(f_t1)
sd_time = sd(f_t1)
t_q =qnorm(prob,mean = mean_time, sd = sd_time)

x1=qnorm(seq(0.01,.99,.01),mean_time,sd_time)
x2=qnorm(seq(0.01,.99,.01),mean_time,sd_time)
plot(x1,x2, type="n",xlim=c(0,35),ylim=c(0,35))
abline(h=x1,xlim=c(0,35))
abline(v=x2,ylim=c(0,35))

points(t_q, f_t1, main = "Normal Probability Plot", xlab = "Theoretical Quantiles", ylab = "Ordered Failure Times" ,col="red",pch=18)
abline(0,1,col="blue",lwd=2)





Ques9:
The remission times of 42 patients with acute leukemia were reported in a clinical trial
to assess the ability of 6-mercaptopurine(6-MP) to maintain remission. Patients were
randomly selected to receive 6-MP or placebo. The study was terminated after one year.
The following remission times, in weeks, were recorded:
 
6-MP (21 patients)
6,6,6,7,10,13,16,22,23,
6+,9+,10+,11+,17+,19+,
20+,25+,32+,32+,34+,35+
Placebo (21 patients)
1,1,2,2,3,4,4,
5,5,8,8,8,8,11,11,
12,12,15,17,22,23
 
a) Now, fit a distribution to the remission duration of 6-MP patients using the hazard
plotting technique.
b) Estimate the parameter/parameters of the distribution.


Code:
# Data: Remission times for 6-MP group
remission_times_6MP <- c(6, 6, 6, 7, 10, 13, 16, 22, 23, 6, 9, 10, 11, 17, 19, 20, 25, 32, 32, 34, 35)
status_6MP <- c(rep(1, 9), rep(0, 12))  # 1 = observed, 0 = censored

# Sort remission times in increasing order
sorted_times <- sort(remission_times_6MP)

# Hazard plotting: Create ranks for plotting
ranks <- rank(sorted_times)

# Calculate the cumulative hazard H(t)
n <- length(sorted_times)
cum_hazard <- (ranks - 0.5) / n

# Plot the empirical hazard function (log-log plot)
plot(log(sorted_times), log(-log(1 - cum_hazard)), 
     xlab = "log(Time (weeks))", ylab = "log(-log(1 - F(t)))", 
     main = "Hazard Plot for 6-MP Patients", pch = 16)

# Estimate Weibull parameters (Shape and Scale)
# Linear regression on log-log transformed data
X <- log(sorted_times)
Y <- log(-log(1 - cum_hazard))

# Linear regression (manually without using lm() function)
n <- length(X)
x_mean <- mean(X)
y_mean <- mean(Y)

# Calculate slope (beta) and intercept (alpha)
beta <- sum((X - x_mean) * (Y - y_mean)) / sum((X - x_mean)^2)
alpha <- y_mean - beta * x_mean

# Weibull parameters:
# Shape parameter (k) is the slope
shape_weibull <- beta

# Scale parameter (lambda) can be derived from intercept
scale_weibull <- exp(-alpha / shape_weibull)

cat("Estimated Weibull Parameters: \n")
cat("Shape (k):", shape_weibull, "\n")
cat("Scale (lambda):", scale_weibull, "\n")

# Plot the fitted Weibull line
lines(X, alpha + beta * X, col = "red")
legend("bottomright", legend = c("Data", "Weibull Fit"), col = c("black", "red"), lty = 1)


Output:


Ques10:
The following dataset is collected from a clinical trial in which researchers are testing
the effectiveness of a new drug compared to a standard drug in increasing the survival
time of cancer patients. Use a non-parametric method such as the Cox-Mantel test to
determine if the new drug prolongs survival significantly compared to the standard
Drug.

New drug Standard drug
10 7
22 11
12+ 14
15+ 17
17+ 18
19+ 18
23+ 19



Code:
# The following dataset is collected from a clinical trial in which researchers are testing
# the effectiveness of a new drug compared to a standard drug in increasing the survival
# time of cancer patients. Use a non-parametric method such as the Cox-Mantel test to
# determine if the new drug prolongs survival significantly compared to the standard
# drug.

# New drug  : 10, 22, 12+ , 15+, 17+, 19+, 23+
# Standard drug: 7,11,14,17,18,18,19


lifetimes <- data.frame(
  time = c(10, 22, 12, 15, 17, 19, 23, 7, 11, 14, 17, 18, 18, 19),
  event = c(1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1),
  group = c(rep("A", 7), rep("B", 7))
)


n1 <- sum(lifetimes$group == "A")
n2 <- sum(lifetimes$group == "B")
n <- n1 + n2

r1 <- sum(lifetimes$group =="A" & lifetimes$event == 1)
r2 <- sum(lifetimes$group =="B" & lifetimes$event == 1)

df_cen <- lifetimes[lifetimes$event == 1, ]
time_counts <- data.frame(table(df_cen$time))
time_counts$Var1 <- as.numeric(as.character(time_counts$Var1))  

df <- data.frame(time = c(), m = c(), G1 = c(), G2 = c(), R = c(), A = c())


for (i in 1:nrow(time_counts)) {
  time_point <- time_counts$Var1[i]
  
  G1 <- sum(lifetimes$group == "A" & lifetimes$time >= time_point)
  G2 <- sum(lifetimes$group == "B" & lifetimes$time >= time_point)
  
  R <- G1 + G2
  A <- G2 / R  
  
  df_row <- data.frame(
    time = time_point,
    m = time_counts$Freq[i],
    G1 = G1,
    G2 = G2,
    R = R,
    A = A
  )
  df <- rbind(df, df_row)
}
print(df)

U <- r2 - sum(df$m * df$A)

I <- sum(df$m* (df$R - df$m)*df$A*(1-df$A)/(df$R - 1))

Z <- U/sqrt(I)
cat("Cox-Mantel Test Statistic (U):", U)



11. Generate 100 observa ons from Weibull distribu on with shape parameter 3 and scale parameter 
10. Hence obtain the ML esma on of its parameters. Also draw the two-dimensional likelihood plot 
of Weibull model for the given dataset. Finally obtain the ML esmate of Mean failure me and 
compare it with sample mean. 


CODE: 
shape_param <- 3     # Shape  
scale_param <- 10    # Scale 
n_samples <- 100     # Number of observa ons 
# Weibull-distributed data 
data <- scale_param * (-log(runif(n_samples)))^(1 / shape_param) 
# Nega ve log-likelihood func on 
neg_log_likelihood <- func on(alpha, beta) { 
if (alpha <= 0 || beta <= 0) return(Inf) # Ensure parameters are posi ve 
n <- length(data) 
log_likelihood <-  
n * log(alpha) - n * log(beta) + 
(alpha - 1) * sum(log(data)) - 
sum((data / beta)^alpha) 
return(-log_likelihood)  # Nega ve log-likelihood 
} 
# Generate 2D grid for shape (alpha) and scale (beta) 
alpha_vals <- seq(2, 4, length.out = 50)  # Shape parameter grid 
beta_vals <- seq(8, 12, length.out = 50)  # Scale parameter grid 
likelihood_matrix <- matrix(0, nrow = length(alpha_vals), ncol = length(beta_vals)) 
# Compu ng log-likelihood for each combina on 
for (i in 1:length(alpha_vals)) { 
for (j in 1:length(beta_vals)) { 
    likelihood_matrix[i, j] <- -neg_log_likelihood(alpha_vals[i], beta_vals[j]) 
  }} 
# 2D likelihood plot 
filled.contour( 
  x = alpha_vals, y = beta_vals, z = likelihood_matrix, 
  xlab = "Shape (alpha)", ylab = "Scale (beta)", 
  main = "2D Likelihood Plot of Weibull Model" 
) 
# MLE Esma on 
result <- opm(par = c(2, 5), fn = func on(params) neg_log_likelihood(params[1], params[2]),  
                method = "L-BFGS-B", lower = c(1e-5, 1e-5)) 
mle_shape <- result$par[1] 
mle_scale <- result$par[2] 
 
# Mean failure me 
mean_failure_me <- mle_scale * gamma(1 + 1 / mle_shape)  # Using Weibull formula 
sample_mean <- mean(data)  # Sample mean 
#results 
cat("MLE Shape (alpha):", mle_shape, "\n") 
cat("MLE Scale (beta):", mle_scale, "\n") 
cat("MLE Mean Failure Time:", mean_failure_me, "\n") 
cat("Sample Mean Failure Time:", sample_mean, "\n") 
 



OUTPUT: 
MLE Shape (alpha): 5.570699e+13  
MLE Scale (beta): 1.543671e+14  
MLE Mean Failure Time: 1.543671e+14  
Sample Mean Failure Time: 8.980911 
 
 
 
 
 
 
 
 
  
 
 
 
 
 
2. fi y leukaemia pa ents were subjected to a test and the test is terminated when 35 pa ents were 
failed. Their lifemes (in weeks) are given below: 
22.3 26.8 30.3 31.9 32.1 33.3 33.7 33.9 34.7 36.1 36.4 36.5 36.6, 37.1 37.6 38.2 38.5 38.7 38.7 38.9 
38.9 39.1 41.1 41.1 41.4 42.4 43.6 43.8 44.0 45.3 45.8 50.4 51.3 51.4 51.5 
Assume lifemes follow lognormal distribu on and esmate the two parameters of the distribu on. 
Also esmate mean me to failure and median me to failure. Draw survival and hazard curve. 
 


CODE: 
# Given data 
lifemes <- c(22.3, 26.8, 30.3, 31.9, 32.1, 33.3, 33.7, 33.9, 34.7, 36.1, 36.4, 36.5,  
               36.6, 37.1, 37.6, 38.2, 38.5, 38.7, 38.7, 38.9, 38.9, 39.1, 41.1, 41.1,  
               41.4, 42.4, 43.6, 43.8, 44.0, 45.3, 45.8, 50.4, 51.3, 51.4, 51.5) 
# Log-transform the data 
log_lifemes <- log(lifemes) 
 
# Esmate parameters (mu and sigma) using MLE 
mu_hat <- mean(log_lifemes) 
sigma_hat <- sd(log_lifemes) 
 
# Calculate Mean and Median Time to Failure 
mean_me_to_failure <- exp(mu_hat + (sigma_hat^2 / 2)) 
median_me_to_failure <- exp(mu_hat) 
 
# Survival Func on 
survival_func on <- func on(t) { 
  1 - pnorm((log(t) - mu_hat) / sigma_hat) 
} 
# Hazard Func on 
hazard_func on <- func on(t) { 
  dnorm((log(t) - mu_hat) / sigma_hat) / (t * survival_func on(t)) 
} 
# Generate a sequence of mes for plo ng 
me_seq <- seq(min(lifemes), max(lifemes), length.out = 100) 
# Survival and Hazard values 
survival_vals <- survival_func on( me_seq) 
hazard_vals <- hazard_func on( me_seq) 
 
# Plot Survival Curve 
plot( me_seq, survival_vals, type = "l", col = "blue", lwd = 2, 
     xlab = "Time (weeks)", ylab = "Survival Probability", 
     main = "Survival Curve") 
# Plot Hazard Curve 
plot( me_seq, hazard_vals, type = "l", col = "red", lwd = 2, 
     xlab = "Time (weeks)", ylab = "Hazard Rate", 
     main = "Hazard Curve") 
# results 
cat("Esmated Parameters:\n") 
cat("Mu (mean of log-lifemes):", mu_hat, "\n") 
cat("Sigma (std. dev. of log-lifemes):", sigma_hat, "\n\n") 
cat("Mean Time to Failure (MTTF):", mean_me_to_failure, "weeks\n") 
cat("Median Time to Failure:", median_me_to_failure, "weeks\n") 



OUTPUT: 
Esmated Parameters: 
Mu (mean of log-lifemes): 3.647393  
Sigma (std. dev. of log-lifemes): 0.1789301  
Mean Time to Failure (MTTF): 38.99373 weeks 
Median Time to Failure: 38.37449 weeks 





3.The recorded death mes of 15 pa ents were 7.35, 8.69, 8.80, 9.63, 9.63, 9.89, 9.98, 10.24, 10.36, 
10.37, 10.48, 11.33, 11.39, 12.02 and 13.12 days, 10 pa ents whose are alive were removed from the 
test at 20 days. Suppose recorded me follows Weibull distribu on, then 
a) Find maximum likelihood esmates of parameter. 
b) Using esmates of part 1 draw survival and hazard rate curve. 
c) Comment on behaviour of hazard rate.  




CODE: 
death_mes <- c(7.35, 8.69, 8.80, 9.63, 9.63, 9.89, 9.98, 10.24, 10.36, 10.37,  
10.48, 11.33, 11.39, 12.02, 13.12)  # Complete data 
censored_mes <- rep(20, 10)  # Right-censored data 
# Combine data 
all_mes <- c(death_mes, censored_mes) 
status <- c(rep(1, length(death_mes)), rep(0, length(censored_mes)))  # 1=death, 0=censored 
# Nega ve log-likelihood func on 
neg_log_likelihood <- func on(params) { 
alpha <- params[1]  # Shape parameter 
beta <- params[2]   # Scale parameter 
if (alpha <= 0 || beta <= 0) return(Inf)  
log_f <- log(alpha / beta) + (alpha - 1) * log(death_mes / beta) - (death_mes / beta)^alpha 
log_S <- -(censored_mes / beta)^alpha 
total_log_likelihood <- sum(log_f) + sum(log_S) 
return(-total_log_likelihood)  # Nega ve log-likelihood for minimiza on 
} 
# Ini al guesses for alpha and beta 
ini al_guess <- c(1, 15) 
# MLE using opm 
result <- opm(par = ini al_guess, fn = neg_log_likelihood, method = "L-BFGS-B",  
lower = c(1e-5, 1e-5)) 
mle_alpha <- result$par[1] 
mle_beta <- result$par[2] 
# Survival func on 
survival_func on <- func on(t) { 
exp(-(t / mle_beta)^mle_alpha) 
} 
# Hazard func on 
hazard_func on <- func on(t) { 
(mle_alpha / mle_beta) * (t / mle_beta)^(mle_alpha - 1) 
} 
# Generate me sequence for plo ng 
me_seq <- seq(0, 25, length.out = 100) 
# Survival and hazard values 
survival_vals <- survival_func on( me_seq) 
hazard_vals <- hazard_func on( me_seq) 
# Plo ng Survival Curve 
plot( me_seq, survival_vals, type = "l", col = "blue", lwd = 2, 
xlab = "Time (days)", ylab = "Survival Probability", main = "Survival Curve") 
# Plo ng Hazard Rate Curve 
plot( me_seq, hazard_vals, type = "l", col = "red", lwd = 2, 
xlab = "Time (days)", ylab = "Hazard Rate", main = "Hazard Curve") 
# Results 
cat("MLE Esmates:\n") 
cat("Shape (alpha):", mle_alpha, "\n") 
cat("Scale (beta):", mle_beta, "\n") 


OUTPUT: 
ML Esmates: 
Shape (alpha): 2.009786  
Scale (beta): 19. 29775 







MSMS – 301 Time Series Analysis 
Practical 1 
For the “Nile” dataset available in R, obtain the results given below by wri ng a suitable R program 
a) Autocorrela on up to order three 
b) Par al autocorrela on 
c) Also plot these using suitable diagram
CODE: 
library(datasets) 
data=Nile 
plot(data) 
require(graphics) 
data1<-ts(data,start=c(1871,1), end=c(1970,12), frequency=12) 
decomp<-decompose(data1) # to decompose the data into different components 
plot(decomp) 
# (a) Autocorrela on up to order three 
Autocorr<-acf(data1,lag.max = 3,plot=FALSE) 
Autocorr 
# (b) Par al Autocorrela on 
Par al_Autocorr<-acf(data1,lag.max = 3,type=c("par al"),plot=FALSE) 
Par al_Autocorr 
# (c) Plot the autocorrela on and par al autocorrela on func ons 
par(mfrow = c(2, 1)) # Set layout for two plots in one column 
acf(data1, lag.max = 10, main = "Autocorrela on Func on") 
pacf(data1, main = "Par al Autocorrela on Func on") 
 output:
>Autocorrela ons of series ‘data1’, by lag 
0.0000 0.0833 0.1667 0.2500 
1.000   0.487   0.357   0.296 
>Par al autocorrela ons of series ‘data1’, by lag 
0.0833 0.1667 0.2500 
0.487   0.158   0.0986






MSMS – 302 Statistical Machine Learning 

Practical 1 
1. For the following dataset, obtain kernel density esmate and Naïve density esmator. Also plot both 
the esmators. 
5.65746599   5.38283914   2.79892121   2.85423660   2.95252721   5.42626667 
7.66239113   -0.18001073   0.65083500   2.40276530 -0.09929884 6.32619215 
5.03650752   2.07470777   1.78019174   6.12891558   4.05352439   2.02686971 
3.50834853 -2.76449768   4.98428763   3.01292677   2.82448038   3.98110437 
5.09371862   5.97961648   4.56968496 -0.48814532 5.08736697 2.41757609 
CODE: 
# Dataset 
data <- c(5.65746599, 5.38283914, 2.79892121, 2.85423660, 2.95252721, 5.42626667, 
7.66239113, -0.18001073, 0.65083500, 2.40276530, -0.09929884, 6.32619215, 
5.03650752, 2.07470777, 1.78019174, 6.12891558, 4.05352439, 2.02686971, 
3.50834853, -2.76449768, 4.98428763, 3.01292677, 2.82448038, 3.98110437, 
5.09371862, 5.97961648, 4.56968496, -0.48814532, 5.08736697, 2.41757609) 
# Kernel Density Esmate 
kde <- density(data) 
kde 
# Naïve Density Esmator 
naive_density <- func on(x, data, h) { 
n <- length(data) 
return(sum((abs(x - data) <= h) / (2 * h)) / n) 
} 
# Naïve Density Esmator for a range of x 
h <- 1.0 # Bandwidth for Naïve Density Esma on 
x_range <- seq(min(data) - 1, max(data) + 1, length.out = 100) 
naive_esmates <- sapply(x_range, naive_density, data = data, h = h) 
# Plo ng both 
plot(kde, main = "Kernel Density Esmate vs Naïve Density Esmator", 
col = "blue", lwd = 2, ylim = c(0, max(kde$y, naive_esmates)), xlab = "X", ylab = "Density") 
lines(x_range, naive_esmates, col = "red", lwd = 2) 
legend("topright", legend = c("KDE", "Naïve Density"), col = c("blue", "red"), lty = 1, lwd = 2)
Interpretation: 
KDE (blue) and the Naïve Density Estimator (red) are contrasted in the graph. 
· The KDE efficiently captures the general shape and offers a smooth and reliable estimation of 
the data distribution. 
Because of its restricted bandwidth and sensitivity to data points, 
· The Naïve Density Estimator is imprecise and unable to accurately depict the distribution. 
KDE is favored because it represents density in a more fluid and understandable manner. 


Practical 2 

2. Hosmer & Lerneshow (1989) give a dataset (“birthwt” available in R MASS library) on 189 births at 
a US hospital, with the main interest being in low birth weight. The main variable of interest is low 
birth weight, a binary response variable low. You can use variable “low” as binary response variable 
and remining variables as regressor variable. Divide the whole dataset into training and test dataset 
as solve perform following task 
a) Learn logis c classifica on model from training dataset and predict response using test 
dataset predictors.  
b) Obtain specificity, sensi vity, posi ve predic ve value, nega ve predic ve value of the model 
using test data set. 
Code: 
data("birthwt", package = "MASS") 
birthwt <- birthwt 
birthwt$low <- as.numeric(birthwt$low)
# Split data into training and test sets 
train_indices <- sample(1:nrow(birthwt), size = 0.7 * nrow(birthwt))  # 70% training 
train_data <- birthwt[train_indices, ] 
test_data <- birthwt[-train_indices, ] 
 
# Logis c func on 
logis c <- func on(x) { 
  1 / (1 + exp(-x)) 
} 
 
# Fit logis c regression using Newton-Raphson 
fit_logis c <- func on(X, y, max_iter = 100, tol = 1e-6) { 
  n <- nrow(X) 
  p <- ncol(X) 
   
  # Ini alize beta coefficients 
  beta <- matrix(0, nrow = p, ncol = 1) 
  epsilon <- 1e-8   
   
  for (i in 1:max_iter) { 
    eta <- X %*% beta  # Linear predictor 
    mu <- logis c(eta)  # Predicted probabili es 
    mu <- pmin(pmax(mu, epsilon), 1 - epsilon) 
     
    # Compute gradient and Hessian 
    W <- diag(as.vector(mu * (1 - mu)), n, n)   
    z <- eta + (y - mu) / (mu * (1 - mu)) 
 
    Hessian <- t(X) %*% W %*% X 
    gradient <- t(X) %*% (y - mu) 
    beta_new <- beta + solve(Hessian + diag(epsilon, p)) %*% gradient  # Regularized update 
     
    if (any(is.na(beta_new))) stop("Divergence detected in Newton-Raphson method.") 
    if (max(abs(beta_new - beta)) < tol) break 
     
    beta <- beta_new 
  } 
  return(beta) 
} 
 
# Addding intercept to training data 
X_train <- cbind(1, as.matrix(train_data[, -1]))  # Intercept and regressors 
y_train <- train_data$low 
 
# Fi ng logis c regression model 
beta <- fit_logis c(X_train, y_train) 
 
# Logis c model equa on 
logis c_model_eq <- paste("log(odds) =", paste(round(beta, 4), c("(Intercept)", colnames(train_data)[
1]), collapse = " + ")) 
cat("Logis c Model Equa on:\n", logis c_model_eq, "\n\n")
# Predict on test data 
X_test <- cbind(1, as.matrix(test_data[, -1])) 
y_test <- test_data$low 
log_odds <- X_test %*% beta 
probs <- logis c(log_odds) 
predic ons <- ifelse(probs > 0.5, 1, 0) 
 
# Calcula ng confusion matrix 
confusion_matrix <- table(Predicted = predic ons, Actual = y_test) 
cat("Confusion Matrix:\n") 
print(confusion_matrix) 
 
# Extrac ng metrics from confusion matrix 
true_posi ve <- confusion_matrix["1", "1"] 
true_nega ve <- confusion_matrix["0", "0"] 
false_posi ve <- confusion_matrix["1", "0"] 
false_nega ve <- confusion_matrix["0", "1"] 
 
sensi vity <- true_posi ve / (true_posi ve + false_nega ve) 
specificity <- true_nega ve / (true_nega ve + false_posi ve) 
posi ve_predic ve_value <- true_posi ve / (true_posi ve + false_posi ve) 
nega ve_predic ve_value <- true_nega ve / (true_nega ve + false_nega ve) 
# Prinng evolu on metrics 
cat("\nModel Performance Metrics:\n") 
cat("Sensi vity (True Posi ve Rate):", round(sensi vity, 4), "\n") 
cat("Specificity (True Nega ve Rate):", round(specificity, 4), "\n") 
cat("Posi ve Predic ve Value (PPV):", round(posi ve_predic ve_value, 4), "\n") 
cat("Nega ve Predic ve Value (NPV):", round(nega ve_predic ve_value, 4), "\n") 


 
OUTPUT: 
Logis c Model Equa on: 
 log(odds) = 525.4902 (Intercept) + -0.321 age + 0.1733 lwt + 11.9778 race + 22.6441 smoke + 31.4374 
ptl + 15.8446 ht + -16.0707 ui + 5.0071 v + -0.227 bwt 
Confusion Matrix:        
                                         Actual 
                                        0         1 
Predicted        0            40        0 
                         1            1         16 
Model Performance Metrics: 
· Sensitivity (True Positive Rate): 0.95  
Interpreta on: The model correctly iden fies 95% of the cases where the actual outcome is 
posi ve (e.g., predic ng "low birth weight" when it truly is low). 
· Specificity (True Negative Rate): 0.973  
Interpreta on: The model correctly iden fies 97.3% of the cases where the actual outcome 
is nega ve (e.g., predic ng "normal birth weight" when it truly is normal). 
· Positive Predictive Value (PPV): 0.95  
Interpreta on: When the model predicts a posi ve outcome, it is correct 95% of the me. 
· Negative Predictive Value (NPV): 0.973 
Interpreta on: When the model predicts a nega ve outcome, it is correct 97.3% of the me. 
*High PPV and NPV indicate that the model is reliable in its predic ons, with minimal false posi ves 
and false nega ves. This makes it effec ve for prac cal use, especially in scenarios where both types 
of errors (false posi ves and false nega ves) must be minimized.  


Practical 3 

Generate 100 observa ons from a gamma distribu on with shape parameter = 2 and scale 
parameter = 5. Obtain kernel density esmates using the Gaussian kernel and plot these esmates. 
[bandwidth may be 0.1, 0.2, 0.5] 


Code: 
#Genera ng 100 observa ons from a Gamma distribu on 
shape <- 2 
scale <- 5 
data <- rgamma(100, shape = shape, scale = scale) 
bandwidths <- c(0.1, 0.2, 0.5) 
plot(NULL, xlim = range(data), ylim = c(0, 0.3),  
xlab = "Value", ylab = "Density",  
main = "Kernel Density Esmates with Gaussian Kernel") 
# Colors for different bandwidths 
colors <- c("red", "blue", "green") 
# Plo ng kernel density esmates for each bandwidth 
for (i in 1:length(bandwidths)) { 
bw <- bandwidths[i] 
density_esmate <- density(data, kernel = "gaussian", bw = bw) 
lines(density_esmate, col = colors[i], lwd = 2) 
} 
# Adding a legend to the plot 
legend("topright", legend = paste("Bandwidth =", bandwidths),  
col = colors, lwd = 2, cex = 1) 

INTERPRETATION: From the above graph, I can conclude that: 
· Bandwidth = 0.1 (Red): Highly sensitive to data, resulting in an overfitted and jagged density 
estimate. 
· Bandwidth = 0.2 (Blue): Gives a balance between smoothness and detail, providing a 
reasonable representation of the distribution. 
· Bandwidth = 0.5 (Green): Produces a smooth, generalized density estimate but we may lose 
finer details in the data. 
Smaller bandwidths emphasize local variations, while larger bandwidths prioritize overall trends.

MSMS – 303 Multivariate Analysis 

Practical 1 
Find MLE of Σ ,𝜇 𝑎𝑛𝑑 𝜌 for the data given in table and also find the result given below. 
 
Head Length, 
First Son (𝑥) 
Head Breadth, 
First Son (𝑥 ) 
Head Length, 
Second Son (𝑥 ) 
Head Breadth,first digit 191 last digit 150

CODE: 
# Data Entry 
head_length_first_son <- c(191, 195, 181, 176, 208, 189, 188, 192, 179, 183, 190, 188, 163, 186, 181, 
192) 
head_breadth_first_son <- c(155, 149, 148, 144, 157, 150, 152, 152, 158, 147, 159, 151, 137, 153, 
140, 154) 
head_length_second_son <- c(179, 201, 185, 171, 192, 190, 197, 186, 187, 174, 195, 187, 161, 173, 
182, 185) 
head_breadth_second_son <- c(145, 152, 149, 142, 152, 149, 159, 151, 148, 147, 157, 158, 130, 148, 
146, 152) 
# Crea ng Matrix 
data <- cbind( 
x1 = head_length_first_son, 
x2 = head_breadth_first_son, 
x3 = head_length_second_son, 
x4 = head_breadth_second_son 
) 
# 1. Mean Vector (MLE of μ) 
n <- nrow(data) 
mean_vector <- apply(data, 2, func on(col) sum(col) / n) # Manual mean calcula on 
cat("Mean Vector (MLE of μ):\n") 
print(mean_vector) 
# 2. Covariance Matrix (MLE of Σ) 
cov_matrix <- matrix(0, ncol = 4, nrow = 4) 
for (i in 1:4) { 
for (j in 1:4) { 
cov_matrix[i, j] <- sum((data[, i] - mean_vector[i]) * (data[, j] - mean_vector[j])) / (n - 1) 
} 
} 
cat("Covariance Matrix (MLE of Σ):\n") 
print(cov_matrix) 
# 3. Correla on Matrix (ρ) 
cor_matrix <- matrix(0, ncol = 4, nrow = 4) 
for (i in 1:4) { 
for (j in 1:4) { 
cor_matrix[i, j] <- cov_matrix[i, j] / sqrt(cov_matrix[i, i] * cov_matrix[j, j]) 
} 
} 
cat("Correla on Matrix (ρ):\n") 
print(cor_matrix) 
# 4. Condi onal Distribu on Parameters 
S11 <- cov_matrix[1:2, 1:2]      # Sub-matrix for (x1, x2) 
S12 <- cov_matrix[1:2, 3:4]      # Sub-matrix between (x1, x2) and (x3, x4) 
S21 <- t(S12)                    
# Transpose of S12 
S22 <- cov_matrix[3:4, 3:4]      # Sub-matrix for (x3, x4) 
# Solving for S11 Inverse using Manual Inversion (2x2 matrix) 
inv_S11 <- matrix(0, 2, 2) 
det_S11 <- S11[1, 1] * S11[2, 2] - S11[1, 2] * S11[2, 1] 
inv_S11[1, 1] <- S11[2, 2] / det_S11 
inv_S11[2, 2] <- S11[1, 1] / det_S11 
inv_S11[1, 2] <- -S11[1, 2] / det_S11 
inv_S11[2, 1] <- -S11[2, 1] / det_S11 
# Condi onal Covariance: S22.1 = S22 - S21 * inv(S11) * S12 
S22_1 <- S22 - S21 %*% inv_S11 %*% S12 
cat("Condi onal Covariance Matrix (S22.1):\n") 
print(S22_1) 
# 5. Par al Correla on Between x3 and x4 Given x1, x2 
inv_cov <- solve(cov_matrix) # Manually inverted covariance matrix using built-in solve() 
r34.12 <- -inv_cov[3, 4] / sqrt(inv_cov[3, 3] * inv_cov[4, 4]) 
cat("Par al Correla on r34.12:\n", r34.12, "\n") 
# 6. Fisher's Z for Confidence Interval 
z_value <- 0.5 * log((1 + r34.12) / (1 - r34.12)) # Fisher's Z-transform 
se <- 1 / sqrt(n - 4) 
lower <- tanh(z_value - 1.96 * se) 
upper <- tanh(z_value + 1.96 * se) 
cat("95% Confidence Interval for r34.12:\n") 
cat("Lower Bound:", lower, "\nUpper Bound:", upper, "\n") 
# 7. Sample Mul ple Correla on Coefficient 
# Manual Calcula on for x3 ~ (x1, x2) 
X <- as.matrix(cbind(1, data[, 1:2]))  # Adding intercept term 
Y_x3 <- data[, 3] 
beta_x3 <- solve(t(X) %*% X) %*% t(X) %*% Y_x3  # Regression Coefficients 
Y_hat_x3 <- X %*% beta_x3 
RSS_x3 <- sum((Y_x3 - Y_hat_x3)^2) 
TSS_x3 <- sum((Y_x3 - mean(Y_x3))^2) 
R_x3 <- sqrt(1 - RSS_x3 / TSS_x3) 
cat("Mul ple Correla on Coefficient (x3 ~ x1, x2):\n", R_x3, "\n") 
#Calcula on for x4 ~ (x1, x2) 
Y_x4 <- data[, 4] 
beta_x4 <- solve(t(X) %*% X) %*% t(X) %*% Y_x4 
Y_hat_x4 <- X %*% beta_x4 
RSS_x4 <- sum((Y_x4 - Y_hat_x4)^2) 
TSS_x4 <- sum((Y_x4 - mean(Y_x4))^2) 
R_x4 <- sqrt(1 - RSS_x4 / TSS_x4) 
cat("Mul ple Correlaion Coefficient (x4 ~ x1, x2):\n", R_x4, "\n") 


OUTPUT: 
 
Mean Vector (MLE of μ): 
      x1              x2                 x3                x4  
186.3750   150.3750   184.0625   149.0625  
Covariance Matrix (MLE of Σ): 
         [,1]             [,2]                 [,3]              [,4] 
[1,] 95.31667   41.18333    72.57500    47.17500 
[2,] 41.18333   37.98333    37.70833    28.57500 
[3,] 72.57500   37.70833    110.06250   60.59583 
[4,] 47.17500   28.57500    60.59583     47.79583 
Correla on Matrix (ρ): 
          [,1]                   [,2]             [,3]                 [,4] 
[1,] 1.0000000   0.6844481   0.7085703   0.6989280 
[2,] 0.6844481   1.0000000   0.5832048   0.6706481 
[3,] 0.7085703   0.5832048   1.0000000    0.8354646 
[4,] 0.6989280   0.6706481   0.8354646    1.0000000 
Condi onal Covariance Matrix (S22.1): 
         [,1]                   [,2] 
[1,] 52.80539      22.09934 
[2,] 22.09934      21.12343 
95% Confidence Interval for r34.12:: 
Lower Bound: 0.2260468  
Upper Bound: 0.8767696 
Mul ple Correla on Coefficient (x3 ~ x1, x2): 
 0.7212653 
Mul ple Correla on Coefficient (x4 ~ x1, x2): 
 0.7470265 




 
 practical2 : machine anova

# Input Data 
data <- matrix( 
c(15, 14, 19, 18,  
17, 12, 20, 16,  
16, 18, 16, 17,  
16, 16, 15, 15),  
nrow = 4, byrow = TRUE 
) 
rownames(data) <- c("Machinist1", "Machinist2", "Machinist3", "Machinist4") 
colnames(data) <- c("Machine1", "Machine2", "Machine3", "Machine4") 
# Total Observa ons 
N <- length(data) # Total number of observa ons 
n_row <- nrow(data) # Number of Machinists 
n_col <- ncol(data) # Number of Machines 
# Step 1: Grand Mean 
grand_mean <- mean(data) 
# Step 2: Total Sum of Squares (SST) 
SST <- sum((data - grand_mean)^2) 
# Step 3: Row Sum of Squares (SSR - for Machinists) 
row_means <- rowMeans(data) 
SSR <- n_col * sum((row_means - grand_mean)^2) 
# Step 4: Column Sum of Squares (SSC - for Machines) 
col_means <- colMeans(data) 
SSC <- n_row * sum((col_means - grand_mean)^2) 
# Step 5: Interac on Sum of Squares (SSI) 
interac on_component <- 0 
for (i in 1:n_row) { 
for (j in 1:n_col) { 
interac on_component <- interac on_component +  
(data[i, j] - row_means[i] - col_means[j] + grand_mean)^2 
} 
} 
SSI <- interac on_component 
# Step 6: Residual/Error Sum of Squares (SSE) 
SSE <- SST - SSR - SSC - SSI 
# Step 7: Mean Squares 
MSR <- SSR / (n_row - 1)    # Mean Square for Rows (Machinists) 
MSC <- SSC / (n_col - 1)    # Mean Square for Columns (Machines) 
MSI <- SSI / ((n_row - 1) * (n_col - 1))  # Mean Square for Interac on 
MSE <- SSE / ((n_row - 1) * (n_col - 1))  # Mean Square for Error 
# Step 8: F-sta s cs 
F_Rows <- MSR / MSE        
# F-sta s c for Rows 
F_Columns <- MSC / MSE     # F-sta s c for Columns 
F_Interac on <- MSI / MSE # F-sta s c for Interac on 
# Step 9: Display Results 
cat("Two-Way ANOVA Results:\n") 
cat("-------------------------------------------------\n") 
cat("SST (Total Sum of Squares):", SST, "\n") 
cat("SSR (Machinist Sum of Squares):", SSR, "\n") 
cat("SSC (Machine Sum of Squares):", SSC, "\n") 
cat("SSI (Interac on Sum of Squares):", SSI, "\n") 
cat("SSE (Error Sum of Squares):", SSE, "\n\n") 
cat("Mean Squares:\n") 
cat("MSR (Rows):", MSR, "\n") 
cat("MSC (Columns):", MSC, "\n") 
cat("MSI (Interac on):", MSI, "\n") 
cat("MSE (Error):", MSE, "\n\n") 
cat("F-sta s cs:\n") 
cat("F for Rows (Machinists):", F_Rows, "\n") 
cat("F for Columns (Machines):", F_Columns, "\n") 
cat("F for Interac on:", F_Interac on, "\n") 


OUTPUT: 
Two-Way ANOVA Results: 
SST (Total Sum of Squares): 57  
SSR (Machinist Sum of Squares): 3.5  
SSC (Machine Sum of Squares): 13  
SSI (Interac on Sum of Squares): 40.5  
SSE (Error Sum of Squares): 0  
Mean Squares: 
MSR (Rows): 1.166667  
MSC (Columns): 4.333333  
MSI (Interac on): 4.5  
MSE (Error): 0  
F-sta s cs: 
F for Rows (Machinists): Inf  
F for Columns (Machines): Inf  
F for Interac on: Inf
 F-statistics: Infinite due to zero error variance, which means the treatment effects (machinists, 
machines, and interaction) fully explain the variation in the data. 

Biostatistics 


1. Imagine that the incidence of gun violence is compared in two ci es, one with relaxed gun 
laws (A), the other with strict gun laws (B). In the city with relaxed gun laws, there were 50 
shoo ngs in a popula on of 100,000 and in the other city, 10 shoo ngs in a popula on of 
100,000. 
a) What is the rela ve risk of gun violence in the city with relaxed gun laws (A)? 
b) What is the rela ve risk of gun violence in the city with strict gun laws (B)? 
c) What ques ons need to be asked before concluding that there is an associa on 
between shoo ngs and gun laws? 

Code: 
# (a) Rela ve risk for city A (relaxed gun laws) 
shoo ngs_A <- 50 
popula on_A <- 100000 
risk_A <- shoo ngs_A / popula on_A 
shoo ngs_B <- 10 
popula on_B <- 100000 
risk_B <- shoo ngs_B / popula on_B 
# Rela ve risk of gun violence in city A 
rela ve_risk_A <- risk_A / risk_B 
cat("Rela ve Risk of gun violence in city A:", rela ve_risk_A, "\n") 
# (b) Rela ve risk for city B (strict gun laws) 
rela ve_risk_B <- risk_B / risk_A 
cat("Rela ve Risk of gun violence in city B:", rela ve_risk_B, "\n") 
cat("This means the risk of gun violence in city B is 20% of the risk in city A, or 5 mes lower.:\n") 
# (c) Addi onal ques ons to consider: 
cat("Ques ons to consider before concluding associa on:\n") 
cat("1. Are the popula ons comparable in demographics and economic factors?\n") 
cat("2. Could other factors (like law enforcement or economic condi ons) influence gun violence 
rates?\n") 
cat("3. Are the data collec on periods the same for both ci es?\n") 
cat("4. Is the gun law the only difference between the ci es?\n") 
cat("5. How is gun violence measured (e.g., homicides, accidents, suicides)?\n") 


OUTPUT: 
Rela ve Risk of gun violence in city A: 5 
Rela ve Risk of gun violence in city B: 0.2 
· This means the risk of gun violence in city B is 20% of the risk in city A, or 5 mes 
lower. 
Ques ons to consider before concluding associa on: 
I. 
Are the popula ons comparable in demographics and economic factors? 
II. 
III. 
IV. 
V. 

qs 2. 
Could other factors (like law enforcement or economic condi ons) influence gun 
violence rates? 
Are the data collec on periods the same for both ci es? 
Is the gun law the only difference between the ci es? 
How is gun violence measured (e.g., homicides, accidents, suicides)? 
A study looking at breast cancer in women compared cases with non-cases, and 
found that 75/100 cases did not use calcium supplements compared with 25/100 of the 
non-cases. 
a) Develop a table to display the data. 
b) Calculate the odds of exposure in cases and non-cases. 
c) Calculate the odds ra o using the cross-product ra o 
d) How does the difference between the two prevalence of breast cancer (75% vs 25%) 
compare to the odds ra o? 


CODE: 
cases_no_calcium <- 75 
cases_use_calcium <- 25 
non_cases_no_calcium <- 25 
non_cases_use_calcium <- 75 
# (b) Calculate odds of exposure in cases and non-cases 
odds_cases <- cases_no_calcium / cases_use_calcium 
odds_non_cases <- non_cases_no_calcium / non_cases_use_calcium 
cat("Odds of exposure in cases:", odds_cases, "\n") 
cat("Odds of exposure in non-cases:", odds_non_cases, "\n") 
# (c) Calculate the odds ra o using cross-product 
odds_ra o <- (cases_no_calcium * non_cases_use_calcium) / (cases_use_calcium * 
non_cases_no_calcium) 
cat("Odds Ra o:", odds_ra o, "\n") 
# (d) Compare prevalence ra o and odds ra o 
prevalence_ra o <- (cases_no_calcium / 100) / (non_cases_no_calcium / 100) 
cat("Prevalence Ra o:", prevalence_ra o, "\n") 
cat("The odds ra o magnifies the difference compared to the prevalence ra o.\n") 
#Key Difference: 
cat("The prevalence ra o (3) compares rela ve exposure percentages,  
while the odds ra o (9) compares the likelihood of exposure between groups.  
The odds ra o magnifies differences, especially for common events, making it a stronger 
measure of associa on.") 



OUTPUT: 
(a) Odds of exposure in cases: 3 
(b) Odds of exposure in non-cases: 0.3333333 
(c) Odds Ra o: 9 
(d) Prevalence Ra o: 3 
The odds ra o magnifies the difference compared to the prevalence ra o. The prevalence 
ra o (3) compares rela ve exposure percentages,  
while the odds ra o (9) compares the likelihood of exposure between groups.  
The odds ra o magnifies differences, especially for common events, making it a stronger 
measure of associa on. 






qs 3

Let us consider the rela onship between smoking and lung cancer. Suppose exposure to 
cigare e smoke increases the incidence of lung cancer by 20% (i.e. the rela ve risk is 1.2). Lung 
cancer has a base line incidence of 3% per year (in the non- exposed group). Suppose as well that 
baseline incidence in obese individuals is 1/3 less (i.e. 1%/yr.), and the rela ve risk associated with 
the exposure is also 1.2. You follow up 1000 non-obese and 1000 obese subjects with the exposure, 
and an equivalent number without the exposure. The study lasts 25 years. Work with 25-year 
cumula ve incidence and a denominator of1000. 
a) Create a table to show the data for obese and non-obese subjects. 
b) Calculate the odds ra o of disease in the exposed group in rela on to those who are not 
exposed. 
c) Compare the odds ra o with the rela ve risk of 1.2. 



CODE: 
# Given data are: 
non_obese_non_exposed <- 0.03 
non_obese_exposed <- non_obese_non_exposed * 1.2 
obese_non_exposed <- non_obese_non_exposed * (2 / 3) 
obese_exposed <- obese_non_exposed * 1.2 
# Create a data frame to display incidence rates 
incidence_table <- data.frame( 
  Group = c("Non-Obese, Non-Exposed", "Non-Obese, Exposed", "Obese, Non-Exposed", "Obese, 
Exposed"), 
  Incidence_Rate = c(non_obese_non_exposed, non_obese_exposed, obese_non_exposed, 
obese_exposed) 
) 
print(incidence_table) 
 
# Calcula ng Odds and Odds Ra o for Non-Obese group as an example 
odds_non_exposed <- non_obese_non_exposed / (1 - non_obese_non_exposed) 
odds_exposed <- non_obese_exposed / (1 - non_obese_exposed) 
odds_ra o <- odds_exposed / odds_non_exposed 
 
# Displaying Odds Ra o and Rela ve Risk 
cat("Odds Ra o (Non-Obese):", odds_ra o, "\n") 
cat("Rela ve Risk (given): 1.2\n") 
 


OUTPUT: 
(a) Table            
                                                     Group Incidence Rate 
1 Non-Obese, Non-Exposed                0.030 
2 Non-Obese, Exposed                         0.036 
3 Obese, Non-Exposed                         0.020 
4 Obese, Exposed                                  0.024 
 
(b) Odds Ra o (Non-Obese): 1.207469 
(c) Rela ve Risk (given): 1.2 
 

4. Use the following table to calculate the a ributable risk associated with taking a supplement 
containing folate during pregnancy: 
 
 
 
CODE: 
no_folate_neural <- 631            # Neural tube defects (No folate) 
folate_neural <- 24                     # Neural tube defects (Folate) 
no_folate_premature <- 727    # Premature births (No folate) 
folate_premature <- 563          # Premature births (Folate) 
 
# A ributable Risk (AR) calcula ons 
AR_neural <- no_folate_neural - folate_neural 
AR_premature <- no_folate_premature - folate_premature 
 
cat("A ributable Risk for Neural Tube Defects:", AR_neural, "per 100,000\n") 
cat("A ributable Risk for Premature Births:", AR_premature, "per 100,000\n") 

OUTPUT: 
1. A ributable Risk for Neural Tube Defects: 607 per 100,000 
· Meaning: If pregnant women take a folate supplement, 607 cases of neural tube defects per 
100,000 births could be prevented compared to women who do not take folate. 
2. A ributable Risk for Premature Births: 164 per 100,0006 
Meaning: If pregnant women take a folate supplement, 164 cases of premature births per 
100,000 births could be prevented compared to women who do not take folate. 




MSMS- 307 SAS and Sta s cal Compu ng 



Q.1 At your young neighbour’s T-ball game (that’s where the players hit the ball from the top of a tee 
instead of having the ball pitched to them), he said to you, “You can tell how far they’ll hit the ball by 
how tall they are.” To give him a li le prac cal lesson in sta s cs, you decide to test his hypothesis. 
You gather data from 30 players, measuring their height in inches and their longest of three hits in 
feet. The following are the data.  
Read the data in the SAS program and perform Regression Analysis using PROC REG. 

/* Input the data */ 
data Tball_data; 
input Height Distance; 
datalines; 
50 110 
50 143 
47 136 
50 118 
45 121 
49 130 
49 135 
48 129 
53 150 
48 124 
51 126 
53 146 
52 144 
47 124 
50 133 
50 128 
48 135 
47 129 
45 126 
48 118 
48 135 
47 129 
45 126 
48 118 
48 135 
47 129 
45 126 
53 142 
46 122 
47 119 
51 134 
46 132 
51 144 
50 132 
50 131 
; 
run; 
/* Regression Analysis */ 
proc reg data=Tball_data; 
model Distance = Height; 
run; 

COMMENT: 
The regression analysis shows a sta s cally significant posi ve rela onship between height and 
distance. For every inch increase in height, the distance increases by 2.15 feet. The model explains 
30.78% of the variability in the distance, with an R-squared value of 0.3078. The F-test (p = 0.0005) 
and t-test for height (p = 0.0005) confirm the model and height's significance. However, about 
69.22% of the varia on in distance remains unexplained, indica ng that other factors influence the 
distance as well. 
 


2. Each student in an a sta s cs class recorded three values: test score, the number of hours spent 
watching television in the week prior to the test, and the number of hours spent exercising during 
the same week. Here are the raw data:

/* Entering data */ 
DATA student_data; 
INPUT Test_Score TV_Hours Exercise_Hours; 
datalines; 
56 6 2 
44 9 0 
85 1 6 
64 4 1 
87 8 4 
78 5 2 
78 7 4 
76 5 1 
67 4 2 
73 0 5 
73 8 3 
69 4 1 
84 5 5 
87 3 3 
90 5 5 
78 5 2 
100 0 6 
64 7 1 
73 4 0 
92 2 7 
84 6 5 
69 6 1 
54 8 0 
73 7 3 
90 3 4 
75 8 3 
74 5 2 
56 7 1 
81 5 4 
65 6 2 
; 
run; 
/* Correla on Analysis */ 
proc corr data=student_data; 
var Test_Score TV_Hours Exercise_Hours; 
run; 

  
 
 
 
 
 
