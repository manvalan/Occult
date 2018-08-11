//------------------------------------------------------------------------------
//
// File:    apsvec3d.h
//
// Purpose: 3D vector for double elements.
//   
// (c) 2005 Plekhanov Andrey
//
// Initial version 0.1 09.10.2005
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

#ifndef APSVEC3D_H
#define APSVEC3D_H

#include "apsabsvec.h"

namespace aps {

  namespace apsmathlib {

enum r_index
{ 
  x = 0,
  y = 1,
  z = 2
};

enum pol_index
{ 
  phi   = 0,  // azimuth of vector
  theta = 1,  // altitude of vector
  r     = 2   // norm of vector
};

struct Polar
{
  Polar( void ) :
         phi( 0.0 ), theta( 0.0 ), r( 0.0 ) {};

  Polar( const double Az, const double Elev, const double R = 1.0 ) :
         phi( Az ), theta( Elev ), r( R ) {};

  double phi;    // azimuth of vector
  double theta;  // altitude of vector
  double r;      // norm of vector
};

//======================= APSVec3d ==========================

class APSVec3d : public APSAbsVec
{
  private:

    double m_r;             // norm of vector
    double m_theta;         // polar angle (altitude)
    double m_phi;           // polar angle (azimuth)
    bool   m_bPolarValid;   // status flag for validity of polar coordinates
    double m_Vec[ 3 ];      // components of vector

    void CalcPolarAngles( void );

  public:

    APSVec3d( void ) : APSAbsVec( 3 ), m_r( 0.0 ), m_theta( 0.0 ), m_phi( 0.0 ), m_bPolarValid( false )
      { m_Vec[ 0 ] = 0.0; m_Vec[ 1 ] = 0.0; m_Vec[ 2 ] = 0.0; }

    APSVec3d ( const double X, const double Y, const double Z ) : APSAbsVec( 3 ),
               m_r( 0.0 ), m_theta( 0.0 ), m_phi( 0.0 ), m_bPolarValid( false )
      { m_Vec[ 0 ] = X; m_Vec[ 1 ] = Y; m_Vec[ 2 ] = Z; }

    APSVec3d( const Polar& polar );

    double operator [] ( const r_index Index ) const
      { return( m_Vec[ Index ] ); }

    double operator [] ( const pol_index Index );

    const double * get( void ) const
      { return( &m_Vec[ 0 ] ); }

    bool operator == ( const APSVec3d & Vec ) const;

    bool operator != ( const APSVec3d & Vec ) const;

    void operator += ( const APSVec3d & Vec )
      { m_Vec[ 0 ] += Vec.m_Vec[ 0 ]; m_Vec[ 1 ] += Vec.m_Vec[ 1 ]; m_Vec[ 2 ] += Vec.m_Vec[ 2 ]; m_bPolarValid = false; }
    
    void operator -= (const APSVec3d & Vec )
      { m_Vec[ 0 ] -= Vec.m_Vec[ 0 ]; m_Vec[ 1 ] -= Vec.m_Vec[ 1 ]; m_Vec[ 2 ] -= Vec.m_Vec[ 2 ]; m_bPolarValid = false; }

    friend double Dot( const APSVec3d & left, const APSVec3d & right )
      { return( left.m_Vec[ 0 ] * right.m_Vec[ 0 ] + left.m_Vec[ 1 ] * right.m_Vec[ 1 ] + left.m_Vec[ 2 ] * right.m_Vec[ 2 ] ); }

    friend double Norm( const APSVec3d & Vec );

    friend APSVec3d operator * ( const double fScalar, const APSVec3d & Vec );

    friend APSVec3d operator * ( const APSVec3d & Vec, const double fScalar );
    
    friend APSVec3d operator / ( const APSVec3d & Vec, const double fScalar );

    friend APSVec3d operator - ( const APSVec3d & Vec);

    friend APSVec3d operator + ( const APSVec3d & left, const APSVec3d & right );    

    friend APSVec3d operator - ( const APSVec3d & left, const APSVec3d & right );    

    friend APSVec3d Cross( const APSVec3d & left, const APSVec3d & right );
};

double Norm( const APSVec3d & Vec );

}}

#endif

//---------------------------- End of file ---------------------------


