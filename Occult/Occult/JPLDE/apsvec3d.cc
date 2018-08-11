//------------------------------------------------------------------------------
//
// File:    apsvec3d.cc
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

#include "apsvec3d.h"
#include "apsmathconst.h"

#include <math.h>

namespace aps {

  namespace apsmathlib {

//======================= APSVec3d ==========================

APSVec3d :: APSVec3d( const Polar & polar ) : APSAbsVec( 3 ), m_r( polar.r ), m_theta( polar.theta ),
                                              m_phi( polar.phi ), m_bPolarValid( true )
{
  const double cosEl = cos( m_theta );

  m_Vec[ 0 ] = polar.r * cos( m_phi ) * cosEl;
  m_Vec[ 1 ] = polar.r * sin( m_phi ) * cosEl;
  m_Vec[ 2 ] = polar.r * sin( m_theta );
}

void APSVec3d :: CalcPolarAngles( void )
{
  const double rhoSqr = m_Vec[ 0 ] * m_Vec[ 0 ] + m_Vec[ 1 ] * m_Vec[ 1 ]; 

  m_r = sqrt( rhoSqr + m_Vec[ 2 ] * m_Vec[ 2 ] );
    
  if( ( m_Vec[ 0 ] == 0.0 ) && ( m_Vec[ 1 ] == 0.0 ) ) { 
    m_phi = 0.0;
  }
  else {
    m_phi = atan2( m_Vec[ 1 ], m_Vec[ 0 ] );
  }

  if( m_phi < 0.0 ) {
    m_phi += 2.0 * pi;
  }

  const double rho = sqrt( rhoSqr );

  if( ( m_Vec[ 2 ] == 0.0 ) && ( rho == 0.0 ) ) { 
    m_theta = 0.0;
  }
  else {
    m_theta = atan2( m_Vec[ 2 ], rho );
  }
}

double APSVec3d :: operator [] ( const pol_index Index )
{
  if ( !m_bPolarValid ) {
    CalcPolarAngles();
    m_bPolarValid = true;
  }
  
  switch ( Index ) {
    case r:
      return( m_r );
    case theta:
      return( m_theta );
    default:
      return( m_phi );
  }
}

bool APSVec3d :: operator == ( const APSVec3d & Vec ) const
{
  if( m_Vec[ 0 ] != Vec.m_Vec[ 0 ] ) {
    return( false );
  }

  if( m_Vec[ 1 ] != Vec.m_Vec[ 1 ] ) {
    return( false );
  }

  if( m_Vec[ 2 ] != Vec.m_Vec[ 2 ] ) {
    return( false );
  }

  return( true );
}

bool APSVec3d :: operator != ( const APSVec3d & Vec ) const
{
  if( m_Vec[ 0 ] != Vec.m_Vec[ 0 ] ) {
    return( true );
  }

  if( m_Vec[ 1 ] != Vec.m_Vec[ 1 ] ) {
    return( true );
  }

  if( m_Vec[ 2 ] != Vec.m_Vec[ 2 ] ) {
    return( true );
  }

  return( false );
}

double Norm( const APSVec3d & Vec )
{
  return( sqrt( Dot( Vec, Vec ) ) );
}

APSVec3d operator * ( const double fScalar, const APSVec3d & Vec )
{
  return( APSVec3d( fScalar * Vec.m_Vec[ 0 ], fScalar * Vec.m_Vec[ 1 ], fScalar * Vec.m_Vec[ 2 ] ) );
}

APSVec3d operator * ( const APSVec3d & Vec, const double fScalar )
{
  return( fScalar * Vec );
}

APSVec3d operator / ( const APSVec3d & Vec, const double fScalar )
{
  return( APSVec3d( Vec.m_Vec[ 0 ] / fScalar, Vec.m_Vec[ 1 ] / fScalar, Vec.m_Vec[ 2 ] / fScalar ) );
}

APSVec3d operator - ( const APSVec3d & Vec )
{
  return( APSVec3d( -Vec.m_Vec[ 0 ], -Vec.m_Vec[ 1 ], -Vec.m_Vec[ 2 ] ) );
}

APSVec3d operator + ( const APSVec3d & left, const APSVec3d & right )   
{
  return( APSVec3d( left.m_Vec[ 0 ] + right.m_Vec[ 0 ], 
                    left.m_Vec[ 1 ] + right.m_Vec[ 1 ], 
                    left.m_Vec[ 2 ] + right.m_Vec[ 2 ] ) );
}

APSVec3d operator - ( const APSVec3d & left, const APSVec3d & right )    
{
  return( APSVec3d( left.m_Vec[ 0 ] - right.m_Vec[ 0 ], 
                    left.m_Vec[ 1 ] - right.m_Vec[ 1 ], 
                    left.m_Vec[ 2 ] - right.m_Vec[ 2 ] ) );
}

APSVec3d Cross( const APSVec3d & left, const APSVec3d & right )
{
  APSVec3d vResult;
    
  vResult.m_Vec[ 0 ] = left.m_Vec[ 1 ] * right.m_Vec[ 2 ] - 
                       left.m_Vec[ 2 ] * right.m_Vec[ 1 ];

  vResult.m_Vec[ 1 ] = left.m_Vec[ 2 ] * right.m_Vec[ 0 ] - 
                       left.m_Vec[ 0 ] * right.m_Vec[ 2 ];

  vResult.m_Vec[ 2 ] = left.m_Vec[ 0 ] * right.m_Vec[ 1 ] - 
                       left.m_Vec[ 1 ] * right.m_Vec[ 0 ];
    
  return( vResult );
}

}}

//---------------------------- End of file ---------------------------
