//------------------------------------------------------------------------------
//
// File:    apsjpleph.h
//
// Purpose: JPL ephemeris data. 
//   
// (c) 2006 Plekhanov Andrey
//
// Initial version 0.1 09.01.2006
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
//
//------------------------------------------------------------------------------

#ifndef APS_JPL_EPH_H
#define APS_JPL_EPH_H  1

#include "string.h"
//#include "map.h"
//#include "iostream.h"



  namespace apsastrodata {

using apsmathlib::APSVec3d; 

enum PlanetType { 
  Mercury = 1,
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
};

enum {
  APS_JPL_NO_ERROR = 0,
  APS_JPL_INIT,
  APS_JPL_INIT_CONST,
  APS_JPL_REINIT,
  APS_JPL_CONST,
  APS_JPL_GET
};

class APSJPLERR
{
  private:

    int ErrCode;

  public:

    APSJPLERR( const int aErrCode ) : ErrCode( aErrCode ) {}

    ~APSJPLERR( void ) {}

    int GetErrCode( void ) const
      { return( ErrCode ); }
};

//======================= APSJPLEph ==========================

class APSJPLEph
{
  private:

    void * ephem;
    std::map <const std::string,double> constants;  

  public:

    APSJPLEph( void );

    virtual ~APSJPLEph( void );

    int Init( const std::string & FilePath );

    double GetConst( const std::string & ConstName ) const;

    double GetAU( void ) const;

    int GetPosVelEph( const double Mjd, const int Target, const int Center, APSVec3d & Pos, APSVec3d & Vel ) const;

    APSVec3d GetPosEph( const double Mjd, const int Target, const int Center ) const;

    APSVec3d SunEquPos( const double Mjd ) const;

    APSVec3d EarthBaryEquPos( const double Mjd ) const;

    APSVec3d MoonEquPos( const double Mjd ) const;

    const std::map <const std::string,double> & GetAllConstants( void ) const
      { return( constants ); }

    void Print( std::ostream & s ) const;
};

}}

#endif

//---------------------------- End of file ---------------------------

