// ==================================================================================== //
//   Gmacs: Generalized Modeling for Alaskan Crab Stocks.
//
//   Authors: Athol Whitten and Jim Ianelli
//            University of Washington, Seattle
//            and Alaska Fisheries Science Centre, NOAA, Seattle
//
//   Info: https://github.com/awhitten/gmacs or write to whittena@uw.edu
//   Copyright (c) 2014. All rights reserved.
//
//   Acknowledgement: The format of this code, and many of the details,
//   were adapted from code developed for the NPFMC by Andre Punt (2012), 
//   and on the 'LSMR' model by Steven Martell (2011).
//
//  NOTE: This is current development version. As at 6pm Seattle time, June 6th 2014.
//
//  INDEXES:
//    g = group
//    h = sex
//    i = year
//    j = time step (years)
//    k = gear or fleet
//    l = index for length class
//    m = index for maturity state
//    n = index for shell condition.
// ==================================================================================== //

DATA_SECTION
	// |------------------------|
	// | DATA AND CONTROL FILES |
	// |------------------------|
	init_adstring datafile;
	init_adstring controlfile;

	!! ad_comm::change_datafile_name(datafile); ECHO(datafile);ECHO(controlfile);

	// |------------------|
	// | MODEL DIMENSIONS |
	// |------------------|
	init_int syr;		///> initial year
	init_int nyr;		///> terminal year
	vector mod_yrs(syr,nyr) ///> Model years
	!! mod_yrs.fill_seqadd(syr,1);
	init_number jstep;  ///> time step (years)
	init_int nfleet;	///> number of gears
	init_int nsex;		///> number of sexes
	init_int nshell;	///> number of shell conditions
	init_int nmature;	///> number of maturity types
	init_int nclass;	///> number of size-classes

	init_vector size_breaks(1,nclass+1);
	vector       mid_points(1,nclass);
	!! mid_points = size_breaks(1,nclass) + first_difference(size_breaks);
	!! ECHO(syr); ECHO(nyr); ECHO(mod_yrs);ECHO(nfleet); ECHO(nsex); ECHO(nshell);ECHO(nmature); ECHO(nclass);

	// |-----------|
	// | ALLOMETRY |
	// |-----------|
	init_vector lw_alfa(1,nsex);
	init_vector lw_beta(1,nsex);
	matrix mean_wt(1,nsex,1,nclass);
	LOC_CALCS
		for(int h = 1; h <= nsex; h++ )
		{
			mean_wt(h) = lw_alfa(h) * pow(mid_points,lw_beta(h));
		}
	END_CALCS
	!! ECHO(lw_alfa); ECHO(lw_beta); ECHO(mean_wt);

	// |-------------|
	// | FLEET NAMES |
	// |-------------|
	init_adstring name_read_flt;        
	init_adstring name_read_srv;
	!! ECHO(name_read_srv); ECHO(name_read_flt);

	// |--------------|
	// | CATCH SERIES |
	// |--------------|
	init_int nCatchRows;						// number of rows in dCatchData
	init_matrix dCatchData(1,nCatchRows,1,10);	// array of catch data
	vector obs_catch(1,nCatchRows);
	vector  catch_cv(1,nCatchRows);
	!! obs_catch = column(dCatchData,5);
	!!  catch_cv = column(dCatchData,6);
	!! ECHO(obs_catch); ECHO(catch_cv);

	// From the catch series determine the number of fishing mortality
	// rate parameters that need to be estimated.  Note that  there is
	// a number of combinations which require a F to be estimated. 
	ivector nFparams(1,nfleet);
	imatrix fhit(syr,nyr,1,nfleet);

	LOC_CALCS
		nFparams.initialize();
		fhit.initialize();
		for(int i = 1; i <= nCatchRows; i++ )
		{
			int k = dCatchData(i,3);
			int y = dCatchData(i,1);
			if(!fhit(y,k))
			{
				fhit(y,k)   ++;
				nFparams(k) ++;
			}
		}
	END_CALCS

	// |----------------------------|
	// | RELATIVE ABUNDANCE INDICES |
	// |----------------------------|
	init_int nSurveys;
	init_ivector nSurveyRows(1,nSurveys);
	init_3darray dSurveyData(1,nSurveys,1,nSurveyRows,1,7);
	matrix obs_cpue(1,nSurveys,1,nSurveyRows);
	matrix  cpue_cv(1,nSurveys,1,nSurveyRows);
	LOC_CALCS
		for(int k = 1; k <= nSurveys; k++ )
		{
			obs_cpue(k) = column(dSurveyData(k),5);
			 cpue_cv(k) = column(dSurveyData(k),6);
		}
		ECHO(obs_cpue); ECHO(cpue_cv); 
	END_CALCS

	init_int nSizeComps;
	init_ivector nSizeCompRows(1,nSizeComps);
	init_ivector nSizeCompCols(1,nSizeComps);
	init_3darray d3_SizeComps(1,nSizeComps,1,nSizeCompRows,-7,nSizeCompCols);
	3darray d3_obs_size_comps(1,nSizeComps,1,nSizeCompRows,1,nSizeCompCols);
	LOC_CALCS
		for(int k = 1; k <= nSizeComps; k++ )
		{
			dmatrix tmp = trans(d3_SizeComps(k)).sub(1,nSizeCompCols(k));
			d3_obs_size_comps(k) = trans(tmp);
		}
		ECHO(nSizeComps); 
		ECHO(d3_obs_size_comps); 
	END_CALCS

	// |------------------|
	// | END OF DATA FILE |
	// |------------------|
	init_int eof;
	!! if (eof != 9999) {cout<<"Error reading data"<<endl; exit(1);}













	!! ad_comm::change_datafile_name(controlfile);
	// |----------------------------|
	// | LEADING PARAMETER CONTROLS |
	// |----------------------------|
	init_int ntheta;
	init_matrix theta_control(1,ntheta,1,7);
	vector theta_ival(1,ntheta);
	vector theta_lb(1,ntheta);
	vector theta_ub(1,ntheta);
	ivector theta_phz(1,ntheta);
	LOC_CALCS
		theta_ival = column(theta_control,1);
		theta_lb   = column(theta_control,2);
		theta_ub   = column(theta_control,3);
		theta_phz  = ivector(column(theta_control,4));
	END_CALCS
	

	// |--------------------------------|
	// | SELECTIVITY PARAMETER CONTROLS |
	// |--------------------------------|
	int nslx;
	!! nslx = 2 * nfleet;
	init_ivector slx_nsel_blocks(1,nslx);
	ivector nc(1,nslx);
	!! nc = 11 + slx_nsel_blocks;
	init_matrix slx_control(1,nslx,1,nc);
	ivector slx_indx(1,nslx);
	ivector slx_type(1,nslx);
	ivector slx_phzm(1,nslx);
	ivector slx_bsex(1,nslx);			// boolean 0 sex-independent, 1 sex-dependent
	ivector slx_xnod(1,nslx);
	ivector slx_inod(1,nslx);
	ivector slx_rows(1,nslx);
	ivector slx_cols(1,nslx);
	 vector slx_mean(1,nslx);
	 vector slx_stdv(1,nslx);
	 vector slx_lam1(1,nslx);
	 vector slx_lam2(1,nslx);
	 vector slx_lam3(1,nslx);
	imatrix slx_blks(1,nslx,1,slx_nsel_blocks);

	LOC_CALCS
		slx_indx = ivector(column(slx_control,1));
		slx_type = ivector(column(slx_control,2));
		slx_mean = column(slx_control,3);
		slx_stdv = column(slx_control,4);
		slx_bsex = ivector(column(slx_control,5));
		slx_xnod = ivector(column(slx_control,6));
		slx_inod = ivector(column(slx_control,7));
		slx_phzm = ivector(column(slx_control,8));
		slx_lam1 = column(slx_control,9);
		slx_lam2 = column(slx_control,10);
		slx_lam3 = column(slx_control,11);

		// count up number of parameters required
		slx_rows.initialize();
		slx_cols.initialize();
		for(int k = 1; k <= nslx; k++ )
		{
			/* multiplier for sex dependent selex */
			int bsex = 1;
			if(slx_bsex(k)) bsex = 2;	
			
			switch (slx_type(k))
			{
				case 1:	// coefficients
					slx_cols(k) = nclass - 1;
					slx_rows(k) = bsex * slx_nsel_blocks(k);
				break;

				case 2: // logistic
					slx_cols(k) = 2;
					slx_rows(k) = bsex * slx_nsel_blocks(k);
				break;

				case 3: // logistic95
					slx_cols(k) = 2;
					slx_rows(k) = bsex * slx_nsel_blocks(k);
				break;
			}
			ivector tmp = ivector(slx_control(k).sub(12,11+slx_nsel_blocks(k)));
			slx_blks(k) = tmp.shift(1);
		}
	END_CALCS


	// |---------------------------------------------------------|
	// | PENALTIES FOR MEAN FISHING MORTALITY RATE FOR EACH GEAR |
	// |---------------------------------------------------------|
	init_matrix f_controls(1,nfleet,1,4);
	ivector f_phz(1,nfleet);
	vector pen_fbar(1,nfleet);
	vector log_pen_fbar(1,nfleet);
	matrix pen_fstd(1,2,1,nfleet);
	LOC_CALCS
		pen_fbar = column(f_controls,1);
		log_pen_fbar = log(pen_fbar+1.0e-14);
		for(int i=1; i<=2; i++)
			pen_fstd(i) = trans(f_controls)(i+1);
		f_phz    = ivector(column(f_controls,4));
	END_CALCS

	// |---------------------------------------------------------|
	// | OTHER CONTROLS                                          |
	// |---------------------------------------------------------|
	init_vector model_controls(1,3);
	int rdv_phz; 										///> Estimated rec_dev phase
	int verbose;										///> Flag to print to screen
	int bInitializeUnfished;				///> Flag to initialize at unfished conditions
	LOC_CALCS
		rdv_phz = int(model_controls(1));
		verbose = int(model_controls(2));
		bInitializeUnfished = int(model_controls(3));
	END_CALCS
	!! cout<<"end of control section"<<endl;
	

INITIALIZATION_SECTION
	theta theta_ival;
	log_fbar  log_pen_fbar;
	alpha     3.733;
	beta      0.2;
	scale    50.1;
	

PARAMETER_SECTION
	// Leading parameters
	//      M = theta(1)
	// ln(Ro) = theta(2)
	// ra     = theta(3)
	// rbeta  = theta(4)
	init_bounded_number_vector theta(1,ntheta,theta_lb,theta_ub,theta_phz);

	// Molt increment parameters
	init_bounded_vector alpha(1,nsex,0,100,-1);
	init_bounded_vector beta(1,nsex,0,10,-1);
	init_bounded_vector scale(1,nsex,1,100,-1);

	// Molt probability parameters
	init_bounded_vector molt_mu(1,nsex,0,200,1);
	init_bounded_vector molt_cv(1,nsex,0,1,1);

	// Selectivity parameters
	init_bounded_matrix_vector log_slx_pars(1,nslx,1,slx_rows,1,slx_cols,-25,25,slx_phzm);
	LOC_CALCS
		for(int k = 1; k <= nslx; k++ )
		{
			if(slx_type(k) == 2)
			{
				for(int j = 1; j <= slx_rows(k); j++ )
				{
					log_slx_pars(k)(j,1) = log(slx_mean(k));
					log_slx_pars(k)(j,2) = log(slx_stdv(k));
				}
			}
		}
	END_CALCS

	// Fishing mortality rate parameters
	init_bounded_number_vector log_fbar(1,nfleet,-30.0,5.0,f_phz);
	init_bounded_vector_vector log_fdev(1,nfleet,1,nFparams,-10.,10.,f_phz);


	// Recruitment deviation parameters
	init_bounded_dev_vector rec_ini(1,nclass,-5.0,5.0,rdv_phz);  ///> initial size devs
	init_bounded_dev_vector rec_dev(syr,nyr,-15.0,15.0,rdv_phz); ///> recruitment deviations

	vector nloglike(1,3);
	vector nlogPenalty(1,2);
	objective_function_value objfun;

	number M0;				///> natural mortality rate
	number logR0;			///> logarithm of unfished recruits.
	number logRbar;		///> logarithm of average recruits(syr+1,nyr)
	number logRini;   ///> logarithm of initial recruitment(syr).
	number ra;				///> shape parameter for recruitment distribution
	number rbeta;			///> rate parameter for recruitment distribution

	vector rec_sdd(1,nclass);			///> recruitment size_density_distribution
	vector recruits(syr,nyr);			///> vector of estimated recruits
	vector survey_q(1,nSurveys);	///> scalers for relative abundance indices (q)

	vector pre_catch(1,nCatchRows);		///> predicted catch from Barnov catch equatoin
	vector res_catch(1,nCatchRows);		///> catch residuals in log-space

	matrix pre_cpue(1,nSurveys,1,nSurveyRows);	///> predicted relative abundance index
	matrix res_cpue(1,nSurveys,1,nSurveyRows);	///> relative abundance residuals
	
	matrix molt_increment(1,nsex,1,nclass);		///> linear molt increment
	matrix molt_probability(1,nsex,1,nclass); ///> probability of molting

	3darray size_transition(1,nsex,1,nclass,1,nclass);
	3darray M(1,nsex,syr,nyr,1,nclass);		///> Natural mortality
	3darray Z(1,nsex,syr,nyr,1,nclass);		///> Total mortality
	3darray S(1,nsex,syr,nyr,1,nclass);		///> Surival Rate (S=exp(-Z))
	3darray F(1,nsex,syr,nyr,1,nclass);		///> Fishing mortality

	3darray N(1,nsex,syr,nyr+1,1,nclass);		///> Numbers-at-length
	3darray ft(1,nfleet,1,nsex,syr,nyr);		///> Fishing mortality by gear
	3darray d3_pre_size_comps(1,nSizeComps,1,nSizeCompRows,1,nSizeCompCols);
	3darray d3_res_size_comps(1,nSizeComps,1,nSizeCompRows,1,nSizeCompCols);

	4darray log_slx_capture(1,nfleet,1,nsex,syr,nyr,1,nclass);
	4darray log_slx_retaind(1,nfleet,1,nsex,syr,nyr,1,nclass);
	4darray log_slx_discard(1,nfleet,1,nsex,syr,nyr,1,nclass);

	sdreport_vector sd_recruits(syr,nyr);

PROCEDURE_SECTION
	initialize_model_parameters();

	// Fishing fleet dynamics ...
	calc_selectivities();
	calc_fishing_mortality();

	// Population dynamics ...
	calc_growth_increments();
	calc_size_transition_matrix();
	calc_natural_mortality();
	calc_total_mortality();
	calc_molting_probability();
	calc_recruitment_size_distribution();
	calc_initial_numbers_at_length();
	update_population_numbers_at_length();

	// observation models ...
	calc_predicted_catch();
	calc_relative_abundance();
	calc_predicted_composition();

	// objective function ...
	calc_objective_function();

	// sd_report variables
	if( last_phase() ) calc_sdreport();



	/**
	 * @brief calculate sdreport variables in final phase
	 */
FUNCTION calc_sdreport
	sd_recruits = recruits;
	

	/**
	 * @brief Initialize model parameters
	 * @details Set global variable equal to the estimated parameter vectors.
	 */
FUNCTION initialize_model_parameters
	 // Get parameters from theta control matrix:
	M0      = theta(1);
	logR0   = theta(2);
	logRini = theta(3);
	logRbar = theta(4);
	ra      = theta(5);
	rbeta   = theta(6);


	/**
	 * @brief Calculate selectivies for each gear.
	 * @author Steve Martell
	 * @details Three selectivities must be accounted for by each fleet.
	 * 1) capture probability, 2) retention probability, and 3) release probability.
	 * 
	 * Maintain the possibility of estimating selectivity independently for
	 * each sex; assumes there are data to estimate female selex.
	 * 
	 * Psuedocode:
	 * 	-# Loop over each gear:
	 * 	-# Create a pointer array with length = number of blocks
	 * 	-# Based on slx_type, fill pointer with parameter estimates.
	 * 	-# Loop over years and block-in the log_selectivity at mid points.
	 * 	
	 */
FUNCTION calc_selectivities
	int h,i,j,k;
	int block;
	dvariable p1,p2;
	dvar_vector pv;
	log_slx_capture.initialize();
	log_slx_discard.initialize();
	log_slx_retaind.initialize();

	for( k = 1; k <= nslx; k++ )
	{	
		block = 1;
		cstar::Selex<dvar_vector> *pSLX[slx_rows(k)-1];
		for( j = 0; j < slx_rows(k); j++ )
		{
			switch (slx_type(k))
			{
			case 1:  //coefficients
				pv   = mfexp(log_slx_pars(k)(block));
				pSLX[j] = new cstar::SelectivityCoefficients<dvar_vector>(pv);
			break;

			case 2:  //logistic
				p1 = mfexp(log_slx_pars(k,block,1));
				p2 = mfexp(log_slx_pars(k,block,2));
				pSLX[j] = new cstar::LogisticCurve<dvar_vector,dvariable>(p1,p2);
			break;

			case 3:  // logistic95
				p1 = mfexp(log_slx_pars(k,block,1));
				p2 = mfexp(log_slx_pars(k,block,2));
				pSLX[j] = new cstar::LogisticCurve95<dvar_vector,dvariable>(p1,p2);
			break;
			}
			block ++;
		}
		
		// fill array with selectivity coefficients
		j = -1;
		block = 1;
		for( h = 1; h <= nsex; h++ )
		{
			for( i = syr; i <= nyr; i++ )
			{
				if(i == slx_blks(k)(block))
				{
					j ++;
					if(block != slx_nsel_blocks(k)) block ++;
				}
				
				int kk = fabs(slx_indx(k));
				
				if(slx_indx(k) > 0)
				{
					log_slx_capture(kk)(h)(i) = pSLX[j]->logSelectivity(mid_points);
				}
				else
				{
					log_slx_retaind(kk)(h)(i) = pSLX[j]->logSelectivity(mid_points);
					log_slx_discard(kk)(h)(i) = log(1.0 - exp(log_slx_retaind(kk)(h)(i)));
				}
			}
			
			if(!slx_bsex(k)){
				j-= slx_nsel_blocks(k);
				block = 1;
			} 
		}

		// delete pointers
		delete *pSLX;
	}
	



	/**
	 * @brief Calculate fishing mortality rates for each fleet.
	 * @details For each fleet estimate scaler log_fbar and deviates (f_devs).
	 * 
	 * In the event that there is effort data and catch data, then it's possible
	 * to estimate a catchability coefficient and predict the catch for the
	 * period of missing catch/discard data.  Best option for this would be
	 * to use F = q*E, where q = F/E.  Then in the objective function, minimize
	 * the variance in the estimates of q, and use the mean q to predict catch.
	 * Or minimize the first difference and assume a random walk in q.
	 * 
	 * Note that this function calculates the fishing mortality rate including
	 * deaths due to discards.  Where lambda is the discard mortality rate.
	 */
FUNCTION calc_fishing_mortality
	int h,i,k,ik;
	double lambda = 0.5;  // discard mortality rate from control file
	F.initialize();
	ft.initialize();
	dvar_vector sel(1,nclass);
	dvar_vector ret(1,nclass);
	dvar_vector tmp(1,nclass);

	for( k = 1; k <= nfleet; k++ )
	{
		for( h = 1; h <= nsex; h++ )
		{
			ik=1;
			for( i = syr; i <= nyr; i++ )
			{
				if(fhit(i,k))
				{
					ft(k)(h)(i) = mfexp(log_fbar(k)+log_fdev(k,ik++));
					//ft(k)(h)(i) = mfexp(log_fbar(k) + log_fdev(k,i));
					sel = exp(log_slx_capture(k)(h)(i));
					ret = exp(log_slx_retaind(k)(h)(i));
					tmp = elem_prod(sel,ret+(1.0 - ret)*lambda);
					F(h)(i) += ft(k,h,i) * tmp;
				}
			}
		}
	}
	//COUT(F(1)(syr));
	//COUT(F(1)(syr));

	//COUT(log_fbar);
	




	/**
	 * @brief Molt increment as a linear function of pre-molt size.
	 */
FUNCTION calc_growth_increments
	int h,l;

	for( h = 1; h <= nsex; h++ )
	{
		for( l = 1; l <= nclass; l++ )
		{
			molt_increment(h)(l) = alpha(h) + beta(h) * mid_points(l);
		}
	}
	






	/**
	 * \brief Calclate the size transtion matrix.
	 * \Authors Steven Martell
	 * \details Calculates the size transition matrix for each sex based on
	 * growth increments, which is a linear function of the size interval, and
	 * the scale parameter for the gamma distribution.  This function does the 
	 * proper integration from the lower to upper size bin, where the mode of 
	 * the growth increment is scaled by the scale parameter.
	 * 
	 * This function loops over sex, then loops over the rows of the size
	 * transition matrix for each sex.  The probability of transitioning from 
	 * size l to size ll is based on the vector molt_increment and the 
	 * scale parameter. In all there are three parameters that define the size
	 * transition matrix (alpha, beta, scale) for each sex.
	 */
FUNCTION calc_size_transition_matrix
	int h,l,ll;
	dvariable tmp;
	dvar_vector psi(1,nclass+1);
	dvar_matrix At(1,nclass,1,nclass);
	size_transition.initialize();


	for( h = 1; h <= nsex; h++ )
	{
		for( l = 1; l <= nclass; l++ )
		{
			tmp = molt_increment(h)(l)/scale(h);
			
			psi.initialize();
			for( ll = l; ll <= nclass+1; ll++ )
			{
				psi(ll) = cumd_gamma(size_breaks(ll)/scale(h),tmp);
			}
			At(l)(l,nclass)  = first_difference(psi(l,nclass+1));
			At(l)(l,nclass) /= sum(At(l));
		}
		size_transition(h) = trans(At);
	}

	







	/**
	 * @brief Calculate natural mortality array
	 * @details Natural mortality (M) is a 3d array for sex, year and size.
	 * @return NULL
	 * 
	 * todo:  
	 * 		- Add time varying components
	 * 		- Size-dependent mortality
	 * 
	 */
FUNCTION calc_natural_mortality
	int h;
	M.initialize();
	for( h = 1; h <= nsex; h++ )
	{
		M(h) = M0;
	}






	/**
	 * @brief Calculate total instantaneous mortality rate and survival rate
	 * @details \f$ S = exp(-Z) \f$
	 * @return NULL
	 * 
	 * 
	 */
FUNCTION calc_total_mortality
	int h;
	Z.initialize();
	S.initialize();
	for( h = 1; h <= nsex; h++ )
	{
		 Z(h) = M(h) + F(h);
		 S(h) = mfexp(-Z(h));
	}





	/**
	 * \brief Calculate the probability of moulting vs carapace width.
	 * \details Note that the parameters molt_mu and molt cv can only be
	 * estimated in cases where there is new shell and old shell data.
	 */
FUNCTION calc_molting_probability
	int h;
	molt_probability.initialize();

	for( h = 1; h <= nsex; h++ )
	{
		dvariable mu = molt_mu(h);
		dvariable sd = mu* molt_cv(h);
		//molt_probability(h) = 1.0 - plogis(mid_points,mu,sd);
		molt_probability(h) = 1.0 - 1.0/(1+exp((mid_points-mu)/sd));
	}







	/**
	 * @brief calculate size distribution for new recuits.
	 * @details Based on the gamma distribution, calculates the probability
	 * of a new recruit being in size-interval size
	 */
FUNCTION calc_recruitment_size_distribution
	dvariable ralpha = ra / rbeta;

	for(int l=1; l<=nclass; l++)
	{
		dvariable x1 = size_breaks(l) / rbeta;
		dvariable x2 = size_breaks(l+1) / rbeta;
		rec_sdd(l) = cumd_gamma(x2, ralpha) 
									 - cumd_gamma(x1, ralpha);
	}
	rec_sdd /= sum(rec_sdd);   // Standardize so each row sums to 1.0
	//COUT(rbeta);
	//COUT(ra);
	//COUT(rec_sdd);




	/**
	 * @brief initialiaze populations numbers-at-length in syr
	 * @author Steve Martell
	 * @details This function initializes the populations numbers-at-length
	 * in the initial year of the model.  
	 * 
	 * Psuedocode:  See note from Dave Fournier.
	 * 
	 * Athol, I think a better option here is to estimate a vector of 
	 * deviates, one for each size class, and have the option to initialize
	 * the model at unfished equilibrium, or some other steady state condition.
	 * 	
	 */
FUNCTION calc_initial_numbers_at_length
	dvariable log_initial_recruits;
	N.initialize();

	// Initial recrutment.
	if ( bInitializeUnfished )
	{
		log_initial_recruits = logR0;
	}
	else
	{
		log_initial_recruits = logRini;
	}
	dvar_vector rt = 0.5 * mfexp( log_initial_recruits ) * rec_sdd;

	// Equilibrium soln.
	dmatrix Id=identity_matrix(1,nclass);
	dvar_vector x(1,nclass);
	dvar_matrix A(1,nclass,1,nclass);
	for(int h = 1; h <= nsex; h++ )
	{
		A = size_transition(h);
		//cout<<"start"<<endl;
		//COUT(diagonal(A));
		//COUT(S(h)(syr));
		for(int l = 1; l <= nclass; l++ )
		{
			A(l) = elem_prod( A(l), S(h)(syr) );
		}
		x = -solve(A-Id,rt);
		//COUT(diagonal(A));
		//cout<<"stop"<<endl;
		N(h)(syr) = elem_prod(x,exp(rec_ini));
	}
	
//	// Specification for initial numbers option (TODO: make part of control file)
//  int init_n = 1;
//
//  switch(init_n)
//  {
//    case 1: // Initial N's option 1: equilibrium approach
//		{
//
//		}
//
//		case 2: // Initial N's option 2: estimate one parameter per size-class
//  	{
//
//  	}
//
//  }



	
	







	/**
	 * @brief Update numbers-at-length
	 * @author Steve Martell
	 */
FUNCTION update_population_numbers_at_length
	int h,i,l;
	dvar_matrix A(1,nclass,1,nclass);
	

	for( h = 1; h <= nsex; h++ )
	{
		for( i = syr; i <= nyr; i++ )
		{
			A = size_transition(h);
			for( l = 1; l <= nclass; l++ )
			{
				A(l) = elem_prod( A(l), S(h)(i) );
			}

			recruits(i) = mfexp(logRbar+rec_dev(i));
			N(h)(i+1)   = (0.5 * recruits(i)) * rec_sdd;
			N(h)(i+1)   += A * N(h)(i);
		}
	}
	//COUT(N(nsex));
	//exit(1);








	/**
	 * @brief Calculate predicted catch observations
	 * @details The function uses the Baranov catch equation to predict the retained
	 * and discarded catch.
	 * 
	 * @param  [description]
	 * @return [description]
	 */
FUNCTION calc_predicted_catch
	int h,i,j,k;
	int type,unit;
	pre_catch.initialize();
	dvariable tmp_ft;
	dvar_vector sel(1,nclass);
	dvar_vector nal(1,nclass);		// numbers or biomass at length.
	


	for( j = 1; j <= nCatchRows; j++ )
	{	
		i = dCatchData(j,1);		// year index
		k = dCatchData(j,3);		// gear index
		h = dCatchData(j,4); 		// sex index

		// Type of catch (retained = 1, discard = 2)
		type = int(dCatchData(j,7));

		// Units of catch equation (1 = biomass, 2 = numbers)
		unit = int(dCatchData(j,8));
		
		// Total catch
		if(h)	// sex specific 
		{
			switch(type)
			{
				case 1:		// retained catch
					sel = exp( log_slx_capture(k)(h)(i) );
				break;

				case 2:		// discard catch
					sel = 1.0 - exp( log_slx_retaind(k)(h)(i) );
				break;
			}
			tmp_ft = ft(k)(h)(i);
			unit==1?nal=elem_prod(N(h)(i),mean_wt(h)):N(h)(i);

			pre_catch(j) = nal * elem_div(elem_prod(tmp_ft*sel,1.0-exp(-Z(h)(i))),Z(h)(i));
		}
		else 	// sexes combibed
		{
			for( h = 1; h <= nsex; h++ )
			{
				switch(type)
				{
					case 1:		// retained catch
						sel = exp( log_slx_capture(k)(h)(i) );
					break;

					case 2:		// discard catch
						sel = 1.0 - exp( log_slx_retaind(k)(h)(i) );
					break;
				}
				tmp_ft = ft(k)(h)(i);
				unit==1?nal=elem_prod(N(h)(i),mean_wt(h)):N(h)(i);

				pre_catch(j) += nal * elem_div(elem_prod(tmp_ft*sel,1.0-exp(-Z(h)(i))),Z(h)(i));
			}
		}
	}

	// Catch residuals
	res_catch = log(obs_catch) - log(pre_catch);








	/**
	 * @brief Calculate predicted relative abundance and residuals
	 * @author Steve Martell
	 * 
	 * @details This function uses the conditional mle for q to scale
	 * the population to the relative abundance index.  Assumed errors in 
	 * relative abundance are lognormal.
	 */
FUNCTION calc_relative_abundance
	int g,h,i,j,k;
	int unit;
	dvar_vector nal(1,nclass);	// numbers at length
	dvar_vector sel(1,nclass);	// selectivity at length

	for( k = 1; k <= nSurveys; k++ )
	{
		dvar_vector V(1,nSurveyRows(k));	
		nal.initialize();
		V.initialize();
		for( j = 1; j <= nSurveyRows(k); j++ )
		{
			i = dSurveyData(k)(j)(1);		// year index
			g = dSurveyData(k)(j)(3);		// gear index
			h = dSurveyData(k)(j)(4);		//  sex index
			unit = dSurveyData(k)(j)(7);	// units 1==biomass

			if(h)
			{
				sel = exp(log_slx_capture(g)(h)(i));
				unit==1?nal=elem_prod(N(h)(i),mean_wt(h)):N(h)(i);
				V(j) = nal * sel;
			}
			else
			{
				for( h = 1; h <= nsex; h++ )
				{
					sel = exp(log_slx_capture(g)(h)(i));
					unit==1?nal=elem_prod(N(h)(i),mean_wt(h)):N(h)(i);
					V(j) += nal * sel;
				}
			}
		} // nSurveyRows(k)
		dvar_vector zt = log(obs_cpue(k)) - log(V);
		dvariable zbar = mean(zt);
		res_cpue(k)    = zt - zbar;
		survey_q(k)    = mfexp(zbar);
		pre_cpue(k)    = survey_q(k) * V;
	}





	/**
	 * @brief Calculate predicted size composition data.
	 * @details   Predicted size composition data are given in proportions.
	 * Size composition strata:
	 * 	- sex
	 * 	- type (retained or discard)
	 * 	- shell condition
	 * 	- mature or immature
	 * 
	 * NB Sitting in a campground on the Orgeon Coast writing this code,
	 * with baby Tabitha sleeping on my back.
	 * 
	 * TODO: 
	 * 	- add pointers for shell type.
	 * 	- add pointers for maturity state.
	 */
FUNCTION calc_predicted_composition
	int h,i,j,k;
	int type,shell,maturity;
	d3_pre_size_comps.initialize();
	dvar_vector dNtmp(1,nclass);


	for(int ii = 1; ii <= nSizeComps; ii++ )
	{
		for(int jj = 1; jj <= nSizeCompRows(ii); jj++ )
		{
			dNtmp.initialize();
			i        = d3_SizeComps(ii)(jj,-7);		// year
			j        = d3_SizeComps(ii)(jj,-6);		// seas
			k        = d3_SizeComps(ii)(jj,-5);		// gear
			h        = d3_SizeComps(ii)(jj,-4);		// sex
			type     = d3_SizeComps(ii)(jj,-3);		
			shell    = d3_SizeComps(ii)(jj,-2);	
			maturity = d3_SizeComps(ii)(jj,-1);

			if(h) // sex specific
			{
				dvar_vector sel = log_slx_capture(k)(h)(i);
				dvar_vector ret = log_slx_retaind(k)(h)(i);
				dvar_vector dis = log_slx_discard(k)(h)(i);
				dvar_vector tmp = N(h)(i);

				switch (type)
				{
					case 1:
						dNtmp = elem_prod(tmp,ret);
					break;
					case 2:
						dNtmp = elem_prod(tmp,dis);
					break;
					default:
						dNtmp = elem_prod(tmp,sel);
					break;
				}

			}
			else
			{
				for( h = 1; h <= nsex; h++ )
				{
					dvar_vector sel = log_slx_capture(k)(h)(i);
					dvar_vector ret = log_slx_retaind(k)(h)(i);
					dvar_vector dis = log_slx_discard(k)(h)(i);
					dvar_vector tmp = N(h)(i);

					switch (type)
					{
						case 1:
							dNtmp += elem_prod(tmp,ret);
						break;
						case 2:
							dNtmp += elem_prod(tmp,dis);
						break;
						default:
							dNtmp += elem_prod(tmp,sel);
						break;
					}
				}
			}
			d3_pre_size_comps(ii)(jj) = dNtmp / sum(dNtmp);
		}
	}




	/**
	 * @brief calculate objective function
	 * @details 
	 * 
	 * Likelihood components
	 * 	-# likelihood of the catch data (assume lognormal error)
	 * 	-# likelihood of relative abundance data
	 * 	-# likelihood of size composition data
	 * 
	 * Penalty components
	 * 	-# Penalty on log_fdev to ensure they sum to zero.
	 * 	-# Penalty to regularize values of log_fbar.
	 * 
	 */
FUNCTION calc_objective_function

	// |---------------------------------------------------------------------------------|
	// | NEGATIVE LOGLIKELIHOOD COMPONENTS FOR THE OBJECTIVE FUNCTION                    |
	// |---------------------------------------------------------------------------------|
	nloglike.initialize();
	
	// 1) Likelihood of the catch data.
	nloglike(1) = dnorm(res_catch,catch_cv);




	// 2) Likelihood of the relative abundance data.
	for(int k = 1; k <= nSurveys; k++ )
	{
		nloglike(2) += dnorm(res_cpue(k),cpue_cv(k));
	}





	// 3) Likelihood for size composition data.
	double minP = 0;
	double variance;
	for(int ii = 1; ii <= nSizeComps; ii++)
	{
		dmatrix     O = d3_obs_size_comps(ii);
		dvar_matrix P = d3_pre_size_comps(ii);
		nloglike(3)  += dmultinom(O,P,d3_res_size_comps(ii),variance,minP);
	}

	// |---------------------------------------------------------------------------------|
	// | PENALTIES AND CONSTRAINTS                                                       |
	// |---------------------------------------------------------------------------------|
	nlogPenalty.initialize();

	// 1) Penalty on log_fdev to ensure they sum to zero 
	for(int k = 1; k <= nfleet; k++ )
	{
		dvariable s    = mean(log_fdev(k));
		nlogPenalty(1) += 10000.0*s*s;
	}


	// 2) Penalty on mean F to regularize the solution.
	int irow=1;
	if(last_phase()) irow=2;
	for(int k = 1; k <= nfleet; k++ )
	{
		nlogPenalty(2) += dnorm(exp(log_fbar(k)),pen_fbar(k),pen_fstd(irow,k));
	}



	objfun = sum(nloglike) + sum(nlogPenalty);



REPORT_SECTION
	REPORT(mod_yrs);
	REPORT(size_breaks);
	REPORT(nloglike);
	REPORT(nlogPenalty);
	REPORT(obs_catch);
	REPORT(pre_catch);
	REPORT(res_catch);
	REPORT(obs_cpue);
	REPORT(pre_cpue);
	REPORT(res_cpue);
	REPORT(log_slx_capture);
	REPORT(log_slx_retaind);
	REPORT(log_slx_discard);
	REPORT(d3_obs_size_comps);
	REPORT(d3_pre_size_comps);
	REPORT(ft);
	REPORT(N);
	REPORT(rec_dev);
	REPORT(recruits);




GLOBALS_SECTION
	#include <admodel.h>
	#include <time.h>
	#include <contrib.h>
	#include "../../CSTAR/include/cstar.h"

	time_t start,finish;
	long hour,minute,second;
	double elapsed_time;

	// Define objects for report file, echoinput, etc.
	/**
	\def report(object)
	Prints name and value of \a object on ADMB report %ofstream file.
	*/
	#undef REPORT
	#define REPORT(object) report << #object "\n" << object << endl;

	/**
	 *
	 * \def COUT(object)
	 * Prints object to screen during runtime.
	 * cout <<setw(6) << setprecision(3) << setfixed() << x << endl;
	 */
	 #undef COUT
	 #define COUT(object) cout << #object "\n" << setw(6) \
	 << setprecision(3) << setfixed() << object << endl;
	/**

	\def ECHO(object)
	Prints name and value of \a object on echoinput %ofstream file.
	*/
	 #undef ECHO
	 #define ECHO(object) echoinput << #object << "\n" << object << endl;
	 // #define ECHO(object,text) echoinput << object << "\t" << text << endl;
 
	 /**
	 \def check(object)
	 Prints name and value of \a object on checkfile %ofstream output file.
	 */
	 #define check(object) checkfile << #object << "\n" << object << endl;
	 // Open output files using ofstream
	 ofstream echoinput("echoinput.rep");
	 ofstream checkfile("checkfile.rep");

TOP_OF_MAIN_SECTION
	time(&start);
	arrmblsize = 50000000;
	gradient_structure::set_GRADSTACK_BUFFER_SIZE(1.e7);
	gradient_structure::set_CMPDIF_BUFFER_SIZE(1.e7);
	gradient_structure::set_MAX_NVAR_OFFSET(5000);
	gradient_structure::set_NUM_DEPENDENT_VARIABLES(5000);
	gradient_structure::set_MAX_DLINKS(50000); 
