//
//  JPLDE.swift
//  Occult
//
//  Created by Michele Bigi on 11/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation


    enum PlanetType:Int {
        case Mercury = 1,
        Venus,
        Earth,
        Mars,
        Jupiter,
        Saturn,
        Uranus,
        Neptune,
        Pluto,
        Moon,
        Sun,
        Barycenter,
        EMBarycenter,
        Nutations,
        Librations
    }
    
    enum aps_error: Int{
        case APS_JPL_NO_ERROR = 0,
        APS_JPL_INIT,
        APS_JPL_INIT_CONST,
        APS_JPL_REINIT,
        APS_JPL_CONST,
        APS_JPL_GET
    }

class APSJPLERR {
    var ErrCode : Int
    
    init( aErrCode : Int ) {
        ErrCode = aErrCode
    }
    
    func GetErrCode()->Int {
        return( ErrCode )
        
    }
}

class JPLDE {
    var ephem : UnsafeMutableRawPointer!
    
    init() {
        //ephem = UnsafePointer<Int8>.
    }
        //std::map <const std::string,double> constants;
    func Init( FilePath: String )-> Int {
        
        return 0
    }
    
    func jpl_get_double( ephem:UnsafeMutableRawPointer, value :Int )->Double {
        let dPointer = ephem + value
        let dVal = dPointer.load(as: CDouble.self )
        return dVal
    }
    
    func jpl_get_long( ephem:UnsafeMutableRawPointer, value :Int )->Int32 {
        let dPointer = ephem + value
        let dVal = dPointer.load(as: Int32.self )
        return dVal
    }
    
    /*****************************************************************************
     **           jpl_pleph( ephem,et,ntar,ncent,rrd,calc_velocity)              **
     ******************************************************************************
     **                                                                          **
     **    This subroutine reads the jpl planetary ephemeris                     **
     **    and gives the position and velocity of the point 'ntarg'              **
     **    with respect to 'ncent'.                                              **
     **                                                                          **
     **    Calling sequence parameters:                                          **
     **                                                                          **
     **      et = (double) julian ephemeris date at which interpolation          **
     **           is wanted.                                                     **
     **                                                                          **
     **    ntarg = integer number of 'target' point.                             **
     **                                                                          **
     **    ncent = integer number of center point.                               **
     **                                                                          **
     **    The numbering convention for 'ntarg' and 'ncent' is:                  **
     **                                                                          **
     **            1 = mercury           8 = neptune                             **
     **            2 = venus             9 = pluto                               **
     **            3 = earth            10 = moon                                **
     **            4 = mars             11 = sun                                 **
     **            5 = jupiter          12 = solar-system barycenter             **
     **            6 = saturn           13 = earth-moon barycenter               **
     **            7 = uranus           14 = nutations (longitude and obliq)     **
     **                                 15 = librations, if on eph. file         **
     **                                                                          **
     **            (If nutations are wanted, set ntarg = 14.                     **
     **             For librations, set ntarg = 15. set ncent= 0)                **
     **                                                                          **
     **     rrd = output 6-element, double array of position and velocity        **
     **           of point 'ntarg' relative to 'ncent'. The units are au and     **
     **           au/day. For librations the units are radians and radians       **
     **           per day. In the case of nutations the first four words of      **
     **           rrd will be set to nutations and rates, having units of        **
     **           radians and radians/day.                                       **
     **                                                                          **
     **           The option is available to have the units in km and km/sec.    **
     **           for this, set km=TRUE at the begining of the program.          **
     **                                                                          **
     **     calc_velocity = integer flag;  if nonzero,  velocities will be       **
     **           computed,  otherwise not.                                      **
     **                                                                          **
     *****************************************************************************/
    func jpl_pleph( ephem :UnsafeMutableRawPointer, et :Double, ntarg :Int, ncent :Int, rrd :inout Vector, calc_velocity: Int) -> Int {
        var rval : Int = 0
        
        var eph = ephem.load(as: jpl_eph_data.self )
        //var pv = Array(repeating: Array<Double>(repeating: 0, count: 6), count: 13)
        var pv = Array(repeating: ( 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ), count: 13)
        /* pv is the position/velocity array NUMBERED FROM ZERO: 0=Mercury,1=Venus,... 8=Pluto,9=Moon,10=Sun,11=SSBary,12=EMBary
               First 10 elements (0-9) are affected by jpl_state(), all are adjusted here.         */

        let list_val :Int32 = (calc_velocity==0 ? 2 : 1);

        var list :[Int32] = [Int32]( repeating: 0, count: 12)
        /* list is a vector denoting, for which "body" ephemeris values should be calculated by jpl_state():  0=Mercury,1=Venus,2=EMBary,..., 8=Pluto,  9=geocentric Moon, 10=nutations in long. & obliq.  11= lunar librations  */
        
        for i in 0...6 {
            rrd[i] = 0.0
        }
        if( ntarg == ncent ){
            return 0
        }
        for i in 0...12 {
            list[i] = 0
        }
        
        /*   check for nutation call    */
        if( ntarg == 14 ) {
            if( eph.ipt.11.1 > 0) {
               
                if( jpl_state( ephem, et, &list, &pv, &rrd, 0) != 0 ) {
                    rval = -1;
                }
                
            } else {
                    rval = -2
                
            }
            return rval
        }

        /*  check for librations   */
        if( ntarg == 15) {
            /* there are librations on ephemeris file */
            if( eph.ipt.12.1 > 0 ){
                list[11] = list_val
                if( jpl_state( ephem, et, &list, &pv, &rrd, 0) != 0 ) {
                    rval = -3;
                }
                /* librations */
                rrd[0] = pv[10].0
                rrd[1] = pv[10].1
                rrd[2] = pv[10].2
                rrd[3] = pv[10].3
                rrd[4] = pv[10].4
                rrd[5] = pv[10].5
            } else {
                rval = -4
            }
            return rval
        }
        /*  force barycentric output by 'state'     */
        /*  set up proper entries in 'list' array for state call     */
        for i in 0...2 {
            var k = ntarg-1
            if( i == 1) {
                k = ncent - 1   /* same for ntarg & ncent */
            }
            if ( k <= 9 ) {
                list[k] = list_val;   /* Major planets */
            }
            if ( k == 9 ) {
                list[2] = list_val;   /* for moon,  earth state is needed */
            }
            if ( k == 2 ) {
                list[9] = list_val;   /* for earth,  moon state is needed */
            }
            if ( k == 12 ) {
                list[2] = list_val;  /* EMBary state additionaly */
            }
        }
        /*   make call to state   */
        if( jpl_state( &eph, et, list, &pv, &rrd, 1) != 0 ) {
            rval = -5
        }
        /* Solar System barycentric Sun state goes to pv[10][] */
        if( ntarg == 11 || ncent == 11) {
            pv[10].0 = eph.pvsun.0
            pv[10].1 = eph.pvsun.1
            pv[10].2 = eph.pvsun.2
            pv[10].3 = eph.pvsun.3
            pv[10].4 = eph.pvsun.4
            pv[10].5 = eph.pvsun.5
        }
        /* Solar System Barycenter coordinates & velocities equal to zero */
        if( ntarg == 12 || ncent == 12) {
            pv[11].0 = 0.0
            pv[11].1 = 0.0
            pv[11].2 = 0.0
            pv[11].3 = 0.0
            pv[11].4 = 0.0
            pv[11].5 = 0.0
        }
        /* Solar System barycentric EMBary state:  */
        if( ntarg == 13 || ncent == 13) {
            pv[12].0 = pv[2].0
            pv[12].1 = pv[2].1
            pv[12].2 = pv[2].2
            pv[12].3 = pv[2].3
            pv[12].4 = pv[2].4
            pv[12].5 = pv[2].5
        }

        /* if moon from earth or earth from moon ..... */
        if( (ntarg*ncent) == 30 && (ntarg+ncent) == 13) {
            pv[2].0 = 0.0
            pv[2].1 = 0.0
            pv[2].2 = 0.0
            pv[2].3 = 0.0
            pv[2].4 = 0.0
            pv[2].5 = 0.0
        } else {
            if( list[2] != 0 ) {
                /* calculate earth state from EMBary */
                pv[2].0 = pv[9].0 / (1.0 + eph.emrat )
                pv[2].1 = pv[9].1 / (1.0 + eph.emrat )
                pv[2].2 = pv[9].2 / (1.0 + eph.emrat )
            }
            if( list[2] != 0 ) {
                /* calculate Solar System barycentric moon state */
                pv[9].0 += pv[2].0
                pv[9].1 += pv[2].1
                pv[9].2 += pv[2].2
            }
            
        }
        
        if( calc_velocity == 0){
            rrd[0] = pv[ntarg-1].0 - pv[ncent-1].0
            rrd[1] = pv[ntarg-1].1 - pv[ncent-1].1
            rrd[2] = pv[ntarg-1].2 - pv[ncent-1].2
        } else {
            rrd[3] = pv[ntarg-1].3 - pv[ncent-1].3
            rrd[4] = pv[ntarg-1].4 - pv[ncent-1].4
            rrd[5] = pv[ntarg-1].5 - pv[ncent-1].5
        }

        return rval
    }
    
    /*****************************************************************************
     **                     interp(buf,t,ncf,ncm,na,ifl,pv)                      **
     ******************************************************************************
     **                                                                          **
     **    this subroutine differentiates and interpolates a                     **
     **    set of chebyshev coefficients to give position and velocity           **
     **                                                                          **
     **    calling sequence parameters:                                          **
     **                                                                          **
     **      input:                                                              **
     **                                                                          **
     **      iinfo   stores certain chunks of interpolation info,  in hopes      **
     **              that if you call again with similar parameters,  the        **
     **              function won't have to re-compute all coefficients/data.    **
     **                                                                          **
     **       coef   1st location of array of d.p. chebyshev coefficients        **
     **              of position                                                 **
     **                                                                          **
     **          t   t[0] is double fractional time in interval covered by       **
     **              coefficients at which interpolation is wanted               **
     **              (0 <= t[0] <= 1).  t[1] is dp length of whole               **
     **              interval in input time units.                               **
     **                                                                          **
     **        ncf   # of coefficients per component                             **
     **                                                                          **
     **        ncm   # of components per set of coefficients                     **
     **                                                                          **
     **         na   # of sets of coefficients in full array                     **
     **              (i.e., # of sub-intervals in full interval)                 **
     **                                                                          **
     **         ifl  integer flag: =1 for positions only                         **
     **                            =2 for pos and vel                            **
     **                                                                          **
     **                                                                          **
     **      output:                                                             **
     **                                                                          **
     **    posvel   interpolated quantities requested.  dimension                **
     **              expected is posvel[ncm*ifl], double precision.              **
     **                                                                          **
     *****************************************************************************/
    func interp( iinfo : interpolation_info , coeff: [Double], t2: Double, ncf: Int32, ncm: Int32, na: Int32, ifl: Int32, posvel: Vector ) {
//        double dna, dt1, temp, tc, vfac, temp1;
//        int l, i, j;
//
//        /*  entry point. get correct sub-interval number for this set
//         of coefficients and then get normalized chebyshev time
//         within that subinterval.                                             */
//
//        dna = (double)na;
//        modf( t[0], &dt1);
//        temp = dna * t[0];
//        l = (int)(temp - dt1);
//
//        /*  tc is the normalized chebyshev time (-1 <= tc <= 1)    */
//
//        tc = 2.0 * (modf( temp, &temp1) + dt1) - 1.0;
//
//        /*  check to see whether chebyshev time has changed,
//         and compute new polynomial values if it has.
//         (the element iinfo->pc[1] is the value of t1[tc] and hence
//         contains the value of tc on the previous call.)     */
//
//        if(tc != iinfo->pc[1])
//        {
//            iinfo->np = 2;
//            iinfo->nv = 3;
//            iinfo->pc[1] = tc;
//            iinfo->twot = tc+tc;
//        }
//
//        /*  be sure that at least 'ncf' polynomials have been evaluated
//         and are stored in the array 'iinfo->pc'.    */
//
//        if(iinfo->np < ncf)
//        {
//            double *pc_ptr = iinfo->pc + iinfo->np;
//
//            for(i=ncf - iinfo->np; i; i--, pc_ptr++)
//            *pc_ptr = iinfo->twot * pc_ptr[-1] - pc_ptr[-2];
//            iinfo->np=ncf;
//        }
//
//        /*  interpolate to get position for each component  */
//
//        for( i = 0; i < ncm; ++i)        /* ncm is a number of coordinates */
//        {
//            const double *coeff_ptr = coef + ncf * (i + l * ncm + 1);
//            const double *pc_ptr = iinfo->pc + ncf;
//
//            posvel[i]=0.0;
//            for( j = ncf; j; j--)
//            posvel[i] += (*--pc_ptr) * (*--coeff_ptr);
//        }
//
//        if(ifl <= 1) return;
//
//        /*  if velocity interpolation is wanted, be sure enough
//         derivative polynomials have been generated and stored.    */
//
//        vfac=(dna+dna)/t[1];
//        iinfo->vc[2] = iinfo->twot + iinfo->twot;
//        if( iinfo->nv < ncf)
//        {
//            double *vc_ptr = iinfo->vc + iinfo->nv;
//            const double *pc_ptr = iinfo->pc + iinfo->nv - 1;
//
//            for( i = ncf - iinfo->nv; i; i--, vc_ptr++, pc_ptr++)
//            *vc_ptr = iinfo->twot * vc_ptr[-1] + *pc_ptr + *pc_ptr - vc_ptr[-2];
//            iinfo->nv = ncf;
//        }
//
//        /*  interpolate to get velocity for each component    */
//
//        for( i = 0; i < ncm; ++i)
//        {
//            double tval = 0.;
//            const double *coeff_ptr = coef + ncf * (i + l * ncm + 1);
//            const double *vc_ptr = iinfo->vc + ncf;
//
//            for( j = ncf; j; j--)
//            tval += (*--vc_ptr) * (*--coeff_ptr);
//            posvel[ i + ncm] = tval * vfac;
//        }
//        return;
//    }
//
//    /* swap_long_integer() and swap_double() are used when reading a binary
//     ephemeris that was created on a machine with 'opposite' byte order to
//     the currently-used machine (signalled by the 'swap_bytes' flag in the
//     jpl_eph_data structure).  In such cases,  every double and integer
//     value read from the ephemeris must be byte-swapped by these two functions. */
//
//    #define SWAP_MACRO( A, B, TEMP)   { TEMP = A;  A = B;  B = TEMP; }
//
//    static void swap_long_integer( void *ptr)
//{
//    char *tptr = (char *)ptr, tchar;
//
//    SWAP_MACRO( tptr[0], tptr[3], tchar);
//    SWAP_MACRO( tptr[1], tptr[2], tchar);
//    }
//
//    static void swap_double( void *ptr, int32_t count)
//{
//    char *tptr = (char *)ptr, tchar;
//
//    while( count--)
//    {
//    SWAP_MACRO( tptr[0], tptr[7], tchar);
//    SWAP_MACRO( tptr[1], tptr[6], tchar);
//    SWAP_MACRO( tptr[2], tptr[5], tchar);
//    SWAP_MACRO( tptr[3], tptr[4], tchar);
//    tptr += 8;
//    }
//    }

        
    }
        //struct interpolation_info *iinfo,
    //const double coef[], const double t[2], const int ncf,
    //const int ncm, const int na, const int ifl, double posvel[])
    
    //    double GetConst( const std::string & ConstName ) const;
        
    //    double GetAU( void ) const;
        
    //    int GetPosVelEph( const double Mjd, const int Target, const int Center, APSVec3d & Pos, APSVec3d & Vel ) const;
        
    //    APSVec3d GetPosEph( const double Mjd, const int Target, const int Center ) const;
        
    //    APSVec3d SunEquPos( const double Mjd ) const;
        
    //    APSVec3d EarthBaryEquPos( const double Mjd ) const;
        
    //    APSVec3d MoonEquPos( const double Mjd ) const;
        
    //    const std::map <const std::string,double> & GetAllConstants( void ) const
    //    { return( constants ); }
        
    //    void Print( std::ostream & s ) const;

}

/*****
 /*****************************************************************************
 **                     interp(buf,t,ncf,ncm,na,ifl,pv)                      **
 ******************************************************************************
 **                                                                          **
 **    this subroutine differentiates and interpolates a                     **
 **    set of chebyshev coefficients to give position and velocity           **
 **                                                                          **
 **    calling sequence parameters:                                          **
 **                                                                          **
 **      input:                                                              **
 **                                                                          **
 **      iinfo   stores certain chunks of interpolation info,  in hopes      **
 **              that if you call again with similar parameters,  the        **
 **              function won't have to re-compute all coefficients/data.    **
 **                                                                          **
 **       coef   1st location of array of d.p. chebyshev coefficients        **
 **              of position                                                 **
 **                                                                          **
 **          t   t[0] is double fractional time in interval covered by       **
 **              coefficients at which interpolation is wanted               **
 **              (0 <= t[0] <= 1).  t[1] is dp length of whole               **
 **              interval in input time units.                               **
 **                                                                          **
 **        ncf   # of coefficients per component                             **
 **                                                                          **
 **        ncm   # of components per set of coefficients                     **
 **                                                                          **
 **         na   # of sets of coefficients in full array                     **
 **              (i.e., # of sub-intervals in full interval)                 **
 **                                                                          **
 **         ifl  integer flag: =1 for positions only                         **
 **                            =2 for pos and vel                            **
 **                                                                          **
 **                                                                          **
 **      output:                                                             **
 **                                                                          **
 **    posvel   interpolated quantities requested.  dimension                **
 **              expected is posvel[ncm*ifl], double precision.              **
 **                                                                          **
 *****************************************************************************/
 static void interp( struct interpolation_info *iinfo,
 const double coef[], const double t[2], const int ncf,
 const int ncm, const int na, const int ifl, double posvel[])
 {
 double dna, dt1, temp, tc, vfac, temp1;
 int l, i, j;
 
 /*  entry point. get correct sub-interval number for this set
 of coefficients and then get normalized chebyshev time
 within that subinterval.                                             */
 
 dna = (double)na;
 modf( t[0], &dt1);
 temp = dna * t[0];
 l = (int)(temp - dt1);
 
 /*  tc is the normalized chebyshev time (-1 <= tc <= 1)    */
 
 tc = 2.0 * (modf( temp, &temp1) + dt1) - 1.0;
 
 /*  check to see whether chebyshev time has changed,
 and compute new polynomial values if it has.
 (the element iinfo->pc[1] is the value of t1[tc] and hence
 contains the value of tc on the previous call.)     */
 
 if(tc != iinfo->pc[1])
 {
 iinfo->np = 2;
 iinfo->nv = 3;
 iinfo->pc[1] = tc;
 iinfo->twot = tc+tc;
 }
 
 /*  be sure that at least 'ncf' polynomials have been evaluated
 and are stored in the array 'iinfo->pc'.    */
 
 if(iinfo->np < ncf)
 {
 double *pc_ptr = iinfo->pc + iinfo->np;
 
 for(i=ncf - iinfo->np; i; i--, pc_ptr++)
 *pc_ptr = iinfo->twot * pc_ptr[-1] - pc_ptr[-2];
 iinfo->np=ncf;
 }
 
 /*  interpolate to get position for each component  */
 
 for( i = 0; i < ncm; ++i)        /* ncm is a number of coordinates */
 {
 const double *coeff_ptr = coef + ncf * (i + l * ncm + 1);
 const double *pc_ptr = iinfo->pc + ncf;
 
 posvel[i]=0.0;
 for( j = ncf; j; j--)
 posvel[i] += (*--pc_ptr) * (*--coeff_ptr);
 }
 
 if(ifl <= 1) return;
 
 /*  if velocity interpolation is wanted, be sure enough
 derivative polynomials have been generated and stored.    */
 
 vfac=(dna+dna)/t[1];
 iinfo->vc[2] = iinfo->twot + iinfo->twot;
 if( iinfo->nv < ncf)
 {
 double *vc_ptr = iinfo->vc + iinfo->nv;
 const double *pc_ptr = iinfo->pc + iinfo->nv - 1;
 
 for( i = ncf - iinfo->nv; i; i--, vc_ptr++, pc_ptr++)
 *vc_ptr = iinfo->twot * vc_ptr[-1] + *pc_ptr + *pc_ptr - vc_ptr[-2];
 iinfo->nv = ncf;
 }
 
 /*  interpolate to get velocity for each component    */
 
 for( i = 0; i < ncm; ++i)
 {
 double tval = 0.;
 const double *coeff_ptr = coef + ncf * (i + l * ncm + 1);
 const double *vc_ptr = iinfo->vc + ncf;
 
 for( j = ncf; j; j--)
 tval += (*--vc_ptr) * (*--coeff_ptr);
 posvel[ i + ncm] = tval * vfac;
 }
 return;
 }
 
 /* swap_long_integer() and swap_double() are used when reading a binary
 ephemeris that was created on a machine with 'opposite' byte order to
 the currently-used machine (signalled by the 'swap_bytes' flag in the
 jpl_eph_data structure).  In such cases,  every double and integer
 value read from the ephemeris must be byte-swapped by these two functions. */
 
 #define SWAP_MACRO( A, B, TEMP)   { TEMP = A;  A = B;  B = TEMP; }
 
 static void swap_long_integer( void *ptr)
 {
 char *tptr = (char *)ptr, tchar;
 
 SWAP_MACRO( tptr[0], tptr[3], tchar);
 SWAP_MACRO( tptr[1], tptr[2], tchar);
 }
 
 static void swap_double( void *ptr, int32_t count)
 {
 char *tptr = (char *)ptr, tchar;
 
 while( count--)
 {
 SWAP_MACRO( tptr[0], tptr[7], tchar);
 SWAP_MACRO( tptr[1], tptr[6], tchar);
 SWAP_MACRO( tptr[2], tptr[5], tchar);
 SWAP_MACRO( tptr[3], tptr[4], tchar);
 tptr += 8;
 }
 }
***/
