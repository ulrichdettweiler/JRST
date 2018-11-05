# Same Prior as FOWO
model_PRC_HD  = '
model
{
  # Likelihood
  for (i in 1:N) {
  y[i] ~ dnorm(alpha_rID[ID[i]] + 
  beta_BN[grps[i],1]*x[i,1] + 
  beta_BN[grps[i],2]*x[i,2] + 
  beta_BN[grps[i],3]*x[i,3] + 
  beta_BN[grps[i],4]*x[i,4] + 
  beta_eqr*x5[i] +
  beta_gdr*x6[i] +
  beta_grp*grps[i],  
  sigma^-2)
  y_sim[i] ~ dnorm(alpha_rID[ID[i]] + 
  beta_BN[grps[i],1]*x[i,1] + 
  beta_BN[grps[i],2]*x[i,2] + 
  beta_BN[grps[i],3]*x[i,3] + 
  beta_BN[grps[i],4]*x[i,4] + 
  beta_eqr*x5[i] + 
  beta_gdr*x6[i] +
  beta_grp*grps[i],  
  sigma^-2)
  
  res[i] <- y[i] - y_sim[i]   
  emp.new[i] ~ dnorm(y_sim[i], sigma^-2)
  res.new[i] <- emp.new[i] - y_sim[i]
  
  }
  # Priors
  for (j in 1:N_ID) {
  alpha_rID[j] ~ dnorm(0, sigma_alpha^-2)
  }
  
  for (k in 1:4) {
  for (l in 1:N_grp) {
  beta_BN[l,k] ~ dnorm(mu_alpha, 1)
  }
  }
  
  mu_alpha ~ dnorm(0, 2^-2)
  sigma_alpha ~ dt(0, 5, 1)T(0, )
  sigma ~ dnorm(0, 1)T(0,)
  beta_gdr ~ dnorm(0,5^2)
  beta_eqr ~ dnorm(0,5^2)
  beta_grp ~ dnorm(0, 5^2)

  
  #Derived parameters
  fit <- sum(res[])
  fit.new <- sum(res.new[])
}
'
HD_GCM_dataNA$IDs = as.numeric(HD_GCM_dataNA$ID)
HD_GCM_dataNA$grps = as.numeric(HD_GCM_dataNA$grp)

# Run the model in R

# Noon Data 

NoonData = subset(HD_GCM_dataNA, TimePoint == "noon")

JAGSRunPRC_HD = jags(data = list(N = nrow(NoonData),
                               N_ID = length(unique(NoonData$IDs)),
                               N_grp = length(unique(NoonData$grps)),
                               #y = log(HD_GCM_dataNA$PRC),
                               y = NoonData$PRC,
                               x = as.matrix(NoonData[,49:52]),
                               ID = NoonData$IDs,
                               grps = NoonData$grps,
                               x5 = NoonData$enquiry,
                               x6 = NoonData$gender),
                   parameters.to.save = c('alpha_rID',
                                          'beta_BN',
                                          'beta_eqr',
                                          'mu_alpha',
                                          'sigma_alpha',
                                          'beta_gdr',
                                          'beta_grp',
                                          'sigma',
                                          'y_sim',
                                          'fit',
                                          'fit.new'),
                   n.iter = 50000,
                   n.thin = 10,
                   n.chains = 6,
                   n.burnin = 25000,
                   model.file = textConnection(model_PRC_HD))

print(JAGSRunPRC_HD)

pp.check(JAGSRunPRC_HD, actual = 'fit', new = 'fit.new')

MCMCplot(JAGSRunPRC_HD, 
         params = c('beta_grp', 'beta_gdr', 'beta_eqr','beta_BN'),
         xlim = c(-1, 2.5),
         horiz = TRUE,
         rank = FALSE,
         ref_ovl = TRUE,
         xlab = 'Parameter Estimate', 
         main = 'Perceived Relevance of Contents (Study B)', 
         labels = c('Context', 
                    'Gender', 
                    'Enquiry', 
                    'Autonomy (Normal)', 
                    'Autonomy (EOtC)', 
                    'Competence (Normal)', 
                    'Competence (EOtC)', 
                    'Rel.Teacher (Normal)', 
                    'Rel.Teacher (EOtC)', 
                    'Rel.Student (Normal)',
                    'Rel.Student (EOtC)'),
         labels_sz = 1, med_sz = 2, thick_sz = 4, thin_sz = 3, 
         ax_sz = 3, main_text_sz = 1.5)

ResultHD = JAGSRunPRC_HD$summary
write.csv(ResultHD, file ="ResultHD.csv", na="")


# VIF
library(fmsb)
VIF(lm(PRC ~ Group * (A_c + C_c + RT_c + RS_c) + gender, data=NoonData))
resHD = lm(PRC ~ Group * (A_c + C_c + RT_c + RS_c) + gender, data=NoonData)
summary(resHD)
