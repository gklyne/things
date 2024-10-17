// CommonDmensions.scad

delta = 0.01 ;
clearance = 0.1 ;

// Common screw/nut dimensions

m_clearance = 0.25 ;        // Clearance for close-clearance holes
m2_5    = 2.5+m_clearance ; // Close clearance hole for M2.5 screw
m3      = 3+m_clearance ;   // Close clearance hole for M3 screw
m4      = 4+m_clearance ;   // Close clearance hole for M4 screw
m5      = 5+m_clearance ;   // Close clearance hole for M5 screw
m6      = 6+m_clearance ;   // Close clearance hole for M6 screw/sleeve
m8      = 8+m_clearance ;   // Close clearance hole for M8 screw/sleeve

m2_5_nut_af = 5.0 ;         // M2.5 nut a/f size
m2_5_nut_t  = 2.0 ;         // M2.5 nut thickness (for recess)
m2_5_csink  = m2_5*2 ;      // M2.5 countersink diameter

m3_nut_af    = 5.5 ;        // M3 nut a/f size
m3_nut_t     = 2.2 ;        // M3 nut thickness (for recess)
m3_slimnut_t = 1.5 ;        // M3 nut thickness (for recess)
m3_hinge_dia = 8.0 ;        // M3 hinge knuckle diameter
m3_csink     = m3*2 ;       // M3 countersink diameter

m4_nut_af    = 7 ;          // M4 nut a/f size
m4_nut_t     = 3.1 ;        // M4 nut thickness (for recess)
m4_slimnut_t = 2.5 ;        // M4 slim nut thickness (for recess)
m4_nylock_t  = 4.3 ;        // M4 nylock nut thickness (for recess)
m4_csink     = m4*2 ;       // M4 countersink diameter
m4_washer_d  = 8.9 ;        // M4 washer diameter
m4_washer_t  = 0.9 ;        // M4 washer thickness

m8_nut_af    = 13 ;         // M8 nut a/f size
m8_nut_t     = 6.5 ;        // M8 nut thickness (for recess)
m8_slimnut_t = 4 ;          // M8 slim nut thickness (for recess)
