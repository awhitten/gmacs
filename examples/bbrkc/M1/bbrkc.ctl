# Set up to do Stock Reduction Analysis using Catch data and informative priors.
# —————————————————————————————————————————————————————————————————————————————————————— #
# Controls for leading parameter vector theta   
# LEGEND FOR PRIOR:
#                  0 -> uniform
#                  1 -> normal
#                  2 -> lognormal
#                  3 -> beta
#                  4 -> gamma
# —————————————————————————————————————————————————————————————————————————————————————— #
# ntheta
  9
# —————————————————————————————————————————————————————————————————————————————————————— #
# ival        lb        ub        phz   prior     p1      p2         # parameter         #                            
# —————————————————————————————————————————————————————————————————————————————————————— #
  0.18      0.01         1          4       2   0.18    0.02         # M
  -1.2       -10        20          2       1   -1.2     0.1         # logR0
   5.0       -10        20         -2       1    3.0     5.0         # logR1      
   5.0       -10        20         -1       1    3.0     5.0         # logRbar      
  72.5        55       100         -4       1   72.5    7.25         # Recruitment Expected Value
  0.55       0.1         5         -3       0    0.1       5         # Recruitment scale (variance component)
 -0.6931     -10      0.75         -4       0    -10    0.75         # ln(sigma_R)
  0.75      0.20      1.00          2       3    3.0    2.00         # steepness
  0.001     0.00      1.00         -3       3    1.01   1.01         # recruitment autocorrelation
## ———————————————————————————————————————————————————————————————————————————————————— ##

## ———————————————————————————————————————————————————————————————————————————————————— ##
## GROWTH PARAM CONTROLS                                                                ##
## nGrwth
##                                                                                      ##
## Two lines for each parameter if split sex, one line if not                           ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
# ival        lb        ub        phz   prior     p1      p2         # parameter         #                            
# —————————————————————————————————————————————————————————————————————————————————————— #
  17.5      10.0      30.0         -3       0    0.0    20.0         # alpha males or combined
  0.10       0.0       0.5         -3       0    0.0    10.0         # beta males or combined
  0.30       0.01      1.0         -3       0    0.0     3.0         # gscale males or combined
  140.      65.0     165.0         -4       0    0.0     3.0         # molt_mu males or combined
  0.071      0.0       1.0         -3       0    0.0     3.0         # molt_cv males or combined
# ———————————————————————————————————————————————————————————————————————————————————— ##

## ———————————————————————————————————————————————————————————————————————————————————— ##
## SELECTIVITY CONTROLS                                                                 ##
##    -Each gear must have a selectivity and a retention selectivity                    ##
## LEGEND sel_type:1=coefficients,2=logistic,3=logistic95                               ##
##        Index: use +ve for selectivity, -ve for retention
##        sex dep: 0 for sex-independent, 1 for sex-dependent.
## ———————————————————————————————————————————————————————————————————————————————————— ##
## ivector for number of year blocks or nodes
## POT       TBycatch  NMFS_S   BSFR_S
## Gear-1    Gear-2    Gear-3   Gear-4    
   1         1         2        1         #Selectivity blocks
   1         1         1        1         #Retention blocks 
   1         0         0        0         #male   retention flag (0 -> no, 1 -> yes)
## ———————————————————————————————————————————————————————————————————————————————————— ##
##        sel   sel  sel sex  size   year  phz                       start  end         ##
## Index  type  mu   sd  dep  nodes  nodes mirror lam1  lam2  lam3 | block  block       ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## Selectivity P(capture of all sizes)
   1      3    100  120  0    1      1    -1      12.5  12.5  12.5   1975   2014
   2      3    110  130  0    1      1    -2      12.5  12.5  12.5   1975   2014 
   3      3     60   65  1    1      1    -3      12.5  12.5  12.5   1975   1981
   3      3     60   65  1    1      1    -4      12.5  12.5  12.5   1982   2014
   4      3     70   90  0    1      1    -5      12.5  12.5  12.5   1975   2014
## ———————————————————————————————————————————————————————————————————————————————————— ##
## Retained
  -1      3    133  137  0    1      1    -1      12.5  12.5  12.5   1975   2014
  -2      2    595   10  0    1      1    -2      12.5  12.5  12.5   1975   2014
  -3      2    590   10  0    1      1    -3      12.5  12.5  12.5   1975   2014
  -4      2    580   20  0    1      1    -4      12.5  12.5  12.5   1975   2014
## ———————————————————————————————————————————————————————————————————————————————————— ##

## ———————————————————————————————————————————————————————————————————————————————————— ##
## PRIORS FOR CATCHABILITY
##  TYPE: 0 = UNINFORMATIVE, 1 - NORMAL (log-space), 2 = time-varying (nyi)
##  LAMBDA: Arbitrary relative weights for each series, 0 = do not fit.
## ———————————————————————————————————————————————————————————————————————————————————— ##
## SURVEYS/INDICES ONLY
## NMFS  BSFRF
## TYPE     Mean_q    SD_q      LAMBDA   
     0      0.896     0.13      0
     0      0.001     0.01      0
## ———————————————————————————————————————————————————————————————————————————————————— ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## PENALTIES FOR AVERAGE FISHING MORTALITY RATE FOR EACH GEAR
## ———————————————————————————————————————————————————————————————————————————————————— ##
## Trap  Trawl NMFS  BSFRF
## Mean_F  STD_PHZ1  STD_PHZ2     PHZ
     0.30      0.07      0.50     1
     0.002     0.01      0.50     1
     0.00      2.00      20.00   -1
     0.00      2.00      20.00   -1
## ———————————————————————————————————————————————————————————————————————————————————— ##

## ———————————————————————————————————————————————————————————————————————————————————— ##
## OPTIONS FOR SIZE COMPOSTION DATA (COLUMN FOR EACH MATRIX)
## LIKELIHOOD OPTIONS:
##  • 0 ignore composition data in model fitting.
##  • 1 multinomial with estimated/fixed sample size
##  • 2 robust_multi. Robust approximation to multinomial
##  • 3 logistic normal  (NIY)
##  • 4 multivariate-t   (NIY)
## AUTOTAIL COMPRESSION:
##   - pmin is the cumulative proportion used in tail compression.
## ———————————————————————————————————————————————————————————————————————————————————— ##
 0   0   0   0   0   0 #  2   2   2   # Type of likelihood.
 0   0   0   0   0   0 #  0   0   0   # Auto tail compression (pmin)
-4  -4  -4  -4  -4  -4 # -4  -4  -4   # Phz for estimating effective sample size (if appl.)
## ———————————————————————————————————————————————————————————————————————————————————— ##

## ———————————————————————————————————————————————————————————————————————————————————— ##
## TIME VARYING NATURAL MORTALIIY RATES                                                 ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## TYPE: 
##      0 = constant natural mortality
##      1 = Random walk (deviates constrained by variance in M)
##      2 = Cubic Spline (deviates constrained by nodes & node-placement)
##      3 = Blocked changes (deviates constrained by variance AT specific knots)
  0
## Phase of estimation
 -3
## STDEV in m_dev for Random walk
  0.20
## Number of nodes for cubic spline or number of step-changes for option 3
  4
## Year position of the knots (vector must be equal to the number of nodes)
   1976 1980 1985 1994



## ———————————————————————————————————————————————————————————————————————————————————— ##
## OTHER CONTROLS
## ———————————————————————————————————————————————————————————————————————————————————— ##
  3       # Estimated rec_dev phase
  0       # VERBOSE FLAG (0 = off, 1 = on, 2 = objective func)
  1       # INITIALIZE MODEL AT UNFISHED RECRUITS (0=FALSE, 1=TRUE)
  1984    # First year for average recruitment for Bspr calculation.
  2014    # Last year for average recruitment for Bspr calculation.
  0.35    # Target SPR ratio for Bmsy proxy.
  1       # Gear index for SPR calculations (i.e., directed fishery).
  1       # Lambda (proportion of mature male biomass for SPR reference points.)
  0       # Use empirical molt increment data (0=FALSE, 1=TRUE)
  1       # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)
## EOF
9999
