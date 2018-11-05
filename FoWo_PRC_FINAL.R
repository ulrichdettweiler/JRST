# FoWo_PRC_FINAL

plot(JAGS_Run_FoWo_Hyper)
print(JAGS_Run_FoWo_Hyper)

FoWoResult = JAGS_Run_FoWo_Hyper$summary
write.csv(FoWoResult, file ="FoWoResult.csv", na="")

library(jagsUI)
pp.check(JAGS_Run_FoWo_Hyper, actual = 'fit', new = 'fit.new')

MCMCplot(JAGS_Run_FoWo_Hyper, 
         params = c('betaCond' ,'betaGend', 'betaMD'),
         xlim = c(-1, 1),
         horiz = TRUE,
         rank = FALSE,
         ref_ovl = TRUE,
         xlab = 'Parameter Estimate', 
         main = 'Perceived Relevance of Contents (Study A)', 
         labels = c('Context', 'Gender', 
                    'Autonomy (Normal)', 
                    'Autonomy (EOtC)', 
                    'Competence (Normal)', 
                    'Competence (EOtC)', 
                    'Rel. Teacher (Normal)', 
                    'Rel. Teacher (EOtC)', 
                    'Rel. Student (Normal)',
                    'Rel. Student (EOtC)'),
         labels_sz = 1, med_sz = 2, thick_sz = 4, thin_sz = 3, 
         ax_sz = 3, main_text_sz = 1.5)
