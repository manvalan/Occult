//------------------------------------------------------------------------------
//
// File:    apsjpleph.cc
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

#include <sstream>
#include <stdint.h>

#include "apsjpleph.h"
#include "apsvec3d.h"

#include "jpl_eph.h"

namespace aps {

  namespace apsastrodata {

//======================= APSJPLEph ==========================

APSJPLEph :: APSJPLEph( void )
{
  ephem = 0;
}

APSJPLEph :: ~APSJPLEph( void )
{
  if( ephem ) {
    jpl_close_ephemeris( ephem );
  }
}

static const int JPL_MAX_CONST_NUM = 400;
static const int JPL_CONST_LENGTH  = 6;

int APSJPLEph :: Init( const std::string & FilePath )
{
  int RetCode = APS_JPL_NO_ERROR;

  if( ephem ) {
    return( APS_JPL_REINIT );
  }

  char   nams[ JPL_MAX_CONST_NUM ][ JPL_CONST_LENGTH ];
  double vals[ JPL_MAX_CONST_NUM ];
  int32_t   n_constants = 0;

  for( int i = 0; i < JPL_MAX_CONST_NUM; i++ ) {
    vals[ i ] = 0.0;

    for( int j = 0; j < JPL_CONST_LENGTH; j++ ) {
      nams[ i ][ j ] = 0;
    }
  }

  ephem = jpl_init_ephemeris( FilePath.c_str(), nams, vals );

  if( ephem ) {
    n_constants = (int32_t)jpl_get_long( ephem, JPL_EPHEM_N_CONSTANTS );

    for( int i = 0; i < n_constants; i++ ) {
      char tmp_str[ JPL_CONST_LENGTH + 1 ];

      for( int j = 0; j < JPL_CONST_LENGTH; j++ ) {
        tmp_str[ j ] = nams[ i ][ j ];
      }

      tmp_str[ JPL_CONST_LENGTH ] = 0x00;

      std::stringstream istrstream( tmp_str );

      std::string new_str;

      if( istrstream >> new_str ) {
        std::pair<const std::string,double> newPair = std::make_pair( new_str, vals[ i ] );
          
        constants.insert( newPair );
      }
      else {
        RetCode = APS_JPL_INIT_CONST;
      }
    }
  }
  else {
    RetCode = APS_JPL_INIT;
  }

  return( RetCode );
}

double APSJPLEph :: GetConst( const std::string & ConstName ) const
{
  std::map<const std::string,double>::const_iterator p = constants.find( ConstName );
        
  if( p != constants.end() ) {
    return( p->second );
  }

  throw APSJPLERR( APS_JPL_CONST );
}

double APSJPLEph :: GetAU( void ) const
{
  return( GetConst( "AU" ) );
}

int APSJPLEph :: GetPosVelEph( const double Mjd, const int Target, const int Center, APSVec3d & Pos, APSVec3d & Vel ) const
{
  double jpl_r[ 6 ];
  int    RetCode = 0;

  if( !jpl_pleph( ephem, Mjd + 2400000.5, Target, Center, jpl_r, 1 ) ) {
    Pos = APSVec3d( jpl_r[ 0 ], jpl_r[ 1 ], jpl_r[ 2 ] );
    Vel = APSVec3d( jpl_r[ 3 ], jpl_r[ 4 ], jpl_r[ 5 ] );
  }
  else {
    RetCode = 1;
  }

  return( RetCode );
}

APSVec3d APSJPLEph :: GetPosEph( const double Mjd, const int Target, const int Center ) const
{
  double jpl_r[ 6 ];

  if( !jpl_pleph( ephem, Mjd + 2400000.5, Target, Center, jpl_r, 0 ) ) {
    return( APSVec3d( jpl_r[ 0 ], jpl_r[ 1 ], jpl_r[ 2 ] ) );
  }
  else {
    throw APSJPLERR( APS_JPL_GET );
  }
}

APSVec3d APSJPLEph :: SunEquPos( const double Mjd ) const
{
  APSVec3d r_sun = GetPosEph( Mjd, static_cast<int>( Sun ), static_cast<int>( Earth ) );

  return( r_sun );
}

APSVec3d APSJPLEph :: EarthBaryEquPos( const double Mjd ) const
{
  APSVec3d r_bary = GetPosEph( Mjd, static_cast<int>( Earth ), static_cast<int>( Barycenter ) );

  return( r_bary );
}

APSVec3d APSJPLEph :: MoonEquPos( const double Mjd ) const
{
  APSVec3d r_moon = GetPosEph( Mjd, static_cast<int>( Moon ), static_cast<int>( Earth ) );

  return( r_moon );
}

void APSJPLEph :: Print( std::ostream & s ) const
{
  std::cout << "================ Begin of JPL constants ===================" << std::endl << std::endl;

  for( std::map<const std::string,double>::const_iterator i = constants.begin();
       i != constants.end(); ++i ) {
    std::cout << i->first << " " << i->second << std::endl;
  }

  std::cout << std::endl << "================== End of JPL constants ===================" << std::endl;
}

}}

//---------------------------- End of file ---------------------------
