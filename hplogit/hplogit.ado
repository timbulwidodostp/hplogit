*! Version 1.0.0 
* POISSON-LOGIT HURDLE REGRESSION :  Joseph Hilbe  :  7Oct2005
program hplogit, eclass properties(svyb svyj  svyr)
    version    9                        
    syntax [varlist] [if] [in] [fweight pweight aweight  iweight] [, ///
        CENsor(string)  Level(cilevel)                ///
        OFFset(passthru)  EXposure(passthru)            ///
        CLuster(passthru) IRr Robust noLOG FROM(string asis) *  ]   
    gettoken  lhs rhs : varlist

    mlopts mlopts, `options'

    if ("`weight'" != "")   local weight "[`weight'   `exp']"
    if (`"`from'"' != `""') local initopt `"init(`from')"'

    ml model lf jhpoi_logit_ll (logit: `lhs' =  `rhs', `offset' `exposure')   ///
         (poisson: `lhs' = `rhs', `offset' `exposure')                   ///
        `if' `in' `weight',                     ///
        `mlopts' `robust' `cluster'             ///
        title("Poisson-Logit Hurdle Regression")           ///
        maximize `log' `initopt'                ///
        

    ml display, level(`level') `irr'

qui {
* AIC
    tempvar aic
    local nobs e(N)
    local npred e(df_m)
    local df = e(N) - e(df_m) -1
    local llike  e(ll)
    gen `aic' = ((-2*`llike') +  2*(`npred'+1))/`nobs'

}
di in gr _col(1) "AIC Statistic = " in ye %9.3f `aic' 
end







