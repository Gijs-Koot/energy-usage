data {
     int<lower=0> N;
     real read[N];
}

parameters {
     real est_usage[N];
}

model {
     est_usage ~ normal(read, 1);
}

