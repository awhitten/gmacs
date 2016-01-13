#
#  ——————————————————————————————————————————————————————————————————————————————————————  #                                
#  Controls  for  leading  parameter  vector  theta                        
#  LEGEND  FOR  PRIOR:                              
#  0  ->  uniform                              
#  1  ->  normal                              
#  2  ->  lognormal                              
#  3  ->  beta                              
#  4  ->  gamma                              
#  ——————————————————————————————————————————————————————————————————————————————————————  #                                
#  ntheta                                  
9
# —————————————————————————————————————————————————————————————————————————————————————— #
# ival        lb        ub        phz   prior     p1      p2         # parameter         #                            
# —————————————————————————————————————————————————————————————————————————————————————— #
  0.18      0.01         1         -5       2   0.18    0.04         # M
   7.0       -10        20         -1       1    3.0     5.0         # logR0
   7.0       -10        20          2       1    3.0     5.0         # logR1      
   7.0       -10        20          2       1    3.0     5.0         # logRbar      
  72.5        65       150          4       1   72.5    7.25         # Recruitment mBeta
  1.50       0.1         5         -4       0    0.1       5         # Recruitment m50
 -0.51       -10      0.75         -4       0    -10    0.75         # ln(sigma_R)
  0.75      0.20      1.00         -4       3    3.0    2.00         # steepness
  0.001     0.00      1.00         -3       3    1.01   1.01         # recruitment autocorrelation
## ———————————————————————————————————————————————————————————————————————————————————— ##

## ———————————————————————————————————————————————————————————————————————————————————— ##
## GROWTH PARAM CONTROLS                                                                ##
# nGrwth
##                                                                                      ##
## Two lines for each parameter if split sex, one line if not                           ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
# ival        lb        ub        phz   prior     p1      p2         # parameter         #                            
# —————————————————————————————————————————————————————————————————————————————————————— #
  17.5      10.0      30.0         -3       0    0.0    20.0         # alpha males or combined
  0.10       0.0       0.5         -3       0    0.0    10.0         # beta males or combined
   0.75      1.0      30.0         -3       0    0.0     3.0         # gscale males or combined
  115.      65.0     165.0         -2       0    0.0     3.0         # molt_mu males or combined
   0.2       0.0       1.0          3       0    0.0     3.0         # molt_cv males or combined
# ———————————————————————————————————————————————————————————————————————————————————— ##
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
##  SELECTIVITY  CONTROLS  ##                              
##  -Each  gear  must  have  a  selectivity  and  a  retention  selectivity  ##              
##  LEGEND  sel_type:1=coefficients  2=logistic  3=logistic95  ##                          
##  Index:  use  #NAME?  for  selectivity  #NAME?  for  retention                    
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
##  ivector  for  number  of  year  blocks  or  nodes  ##                  
##  Gear-1  Gear-2  Gear-3  ...                            
  1  1 1 1 1 1   #Selectivity  blocks                        
  0  0 0 0 0 0   #Sex spp selex
	2  2 2 2 2 2   #Male selex type (Logistic)
  1  1 1 1 1 1   #Retention  blocks                        
  0  0 0 0 0 0   #male   retention flag (0 -> no, 1 -> yes)
  3  2 2 2 2 2   #male   retention type
  1  0 0 0 0 0   #male   retention flag (0 -> no, 1 -> yes)
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
##  Selectivity  P(capture  of  all  sizes)                          
## ———————————————————————————————————————————————————————————————————————————————————— ##
## gear  par   sel                                             phz    start  end        ##
## index index par sex  ival  lb    ub     prior p1     p2     mirror period period     ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
# Gear-1
   1     1     1   0    129    1    200    0      1     200   -1     1976   2014
   1     2     2   0    156    1    200    0      1     200   -1     1976   2014
# Gear-2
   2     3     1   0    090    10   200    0      10    200    2     1976   2014
   2     4     2   0    180    10   200    0      10    200   -2     1976   2014
# Gear-3
   3     5     1   0    136   60    200    0       1    200   -3     1976   2014
   3     6     2   0    182   60    200    0       1    200   -3     1976   2014
# Gear-4
   4     9     1   0     80    1    200    0       1    200   -4     1976   2014
   4     10    2   0     90    1    200    0       1    200   -4     1976   2014
# Gear-5
   4     9     1   0     80    1    200    0       1    200   -4     1976   2014
   5     10    2   0     90    1    200    0       1    200   -4     1976   2014
# Gear-6
   6     9     1   0     80    1    200    0       1    200   -4     1976   2014
   6     10    2   0     90    1    200    0       1    200   -4     1976   2014
## ———————————————————————————————————————————————————————————————————————————————————— ##
## Retained
## gear  par   sel                                             phz    start  end        ##
## index index par sex  ival  lb    ub     prior p1     p2     mirror period period     ##
# Gear-1
  -1     11    1   0    133   50    200    0      1    900   -1     1976   2014
  -1     12    2   0    137   50    200    0      1    900   -1     1976   2014
# Gear-2
  -2     15    1   0    595    1    700    0      1    900   -3     1976   2014
  -2     16    2   0     10    1    700    0      1    900   -3     1976   2014
# Gear-3
  -3     17    1   0    590    1    700    0      1    900   -3     1976   1981
  -3     18    2   0     10    1    700    0      1    900   -3     1986   2014
# Gear-4
  -4     19    1   0    580    1    700    0      1    900   -3     1976   2014
  -4     20    2   0     20    1    700    0      1    900   -3     1976   2014
# Gear-5
  -5     19    1   0    580    1    700    0      1    900   -3     1976   2014
  -5     20    2   0     20    1    700    0      1    900   -3     1976   2014
# Gear-6
  -6     19    1   0    580    1    700    0      1    900   -3     1976   2014
  -6     20    2   0     20    1    700    0      1    900   -3     1976   2014
## ———————————————————————————————————————————————————————————————————————————————————— ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## PRIORS FOR CATCHABILITY
##  TYPE: 0 = UNINFORMATIVE, 1 - NORMAL (log-space), 2 = time-varying (nyi)
## ———————————————————————————————————————————————————————————————————————————————————— ##
## SURVEYS/INDICES ONLY
## NMFS_Trawl:ADFG:STCPUE                                        
## TYPE     Mean_q    SD_q       lambda
     1      0.896      0.23      1.0
     1      0.896     10.23      1.0
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
## ADDITIONAL CV FOR SURVEYS/INDICES
##     If a uniform prior is selected for a parameter then the lb and ub are used (p1   ##
##     and p2 are ignored). ival must be > 0                                            ##
## LEGEND                                                                               ##
##     prior type: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma          ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## ival        lb        ub        phz   prior     p1      p2
   0.001       0.0       10.0      -4    4         1.0     100   # NMFS
   0.001       0.0       10.0      -4    4         1.0     100   # BSFRF
## ———————————————————————————————————————————————————————————————————————————————————— ##
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
##  PENALTIES  FOR  AVERAGE  FISHING  MORTALITY  RATE  FOR  EACH  GEAR                  
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
##  Trap  Trawl  NMFS  BSFRF                            
##  Mean_F  STD_PHZ1  STD_PHZ2  PHZ                            
  0.2         0.1       1.1      1                            
  0.1         0.1       1.1      1                            
  0.01        2         2       -1                            
  0.01        2         2       -1                            
  0.01        2         2       -1                            
  0.01        2         2       -1                            
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
##  OPTIONS  FOR  SIZE  COMPOSTION  DATA  (COLUMN  FOR  EACH  MATRIX)                  
##  LIKELIHOOD  OPTIONS:                                
##  -1)  multinomial  with  estimated/fixed  sample  size                        
##  -2)  logistic  normal                              
##  -3)  multivariate-t                                
##  AUTOTAIL  COMPRESSION:                                
##  -  pmin  is  the  cumulative  proportion  used  in  tail  compression.                
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
  1  1  1  1  # 1  1  #1  1  1  #  Type  of  likelihood.          
  0  0  0  0  # 0  0  #0  0  0  #  Auto  tail  compression  (pmin)        
	1  1  1  1  # Initial value for effN
 -4 -4 -4 -4  # 4  4  #4  4  4  #  Phz  for  estimating  effective  sample  size  (if  appl.)
  1  2  3  4  # 4  4  #4  4  4  #  Phz  for  estimating  effective  sample  size  (if  appl.)
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
##  TIME  VARYING  NATURAL  MORTALIIY  RATES  ##                        
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
##  TYPE:                                  
##  0  =  constant  natural  mortality                          
##  1  =  Random  walk  (deviates  constrained  by  variance  in  M)                
##  2  =  Cubic  Spline  (deviates  constrined  by  nodes  &  node-placement)                
  0                                  
##  Phase  of  estimation                              
-3                                  
##  STDEV  in  m_dev  for  Random  walk                        
  0.01                                  
##  Number  of  nodes  for  cubic  spline                        
  6                                  
##  Year  position  of  the  knots  (vector  must  be  equal  to  the  number  of  nodes)        
  1976  1982  1985  1991  2002  2014                        
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
##  OTHER  CONTROLS                                
##  ————————————————————————————————————————————————————————————————————————————————————  ##                                
  3     #  Estimated  rec_dev  phase                          
  0     #  VERBOSE  FLAG  (0  =  off  1  =  on  2  =  objective  func)        
  0     #  INITIALIZE  MODEL  AT  UNFISHED  RECRUITS  (0=FALSE  1=TRUE)                  
  1984  #  First  year  for  average  recruitment  for  Bspr  calculation.                
  2013  #  Last  year  for  average  recruitment  for  Bspr  calculation.                
  0.35  #  Target  SPR  ratio  for  Bmsy  proxy.                    
  1     #  Gear  index  for  SPR  calculations  (i.e.  directed  fishery).                
  1     #  Lambda  (proportion  of  mature  male  biomass  for  SPR  reference  points.)            
  1     # Use empirical molt increment data (0=FALSE, 1=TRUE)
  0     # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)
##  EOF                                  
9999                                    
