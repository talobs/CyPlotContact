function [ separation, force, abcd_idx, abcd_val] = calculate_force(z, def, kc, z_points, p)
% calculates the force vectors based on the defelection
% with the relevant parameters using the Sader maethod

z_points_sorted = sort(z_points) ;
a_val = z_points_sorted(1) ;
b_val = z_points_sorted(2) ;
c_val = z_points_sorted(3) ;
d_val = z_points_sorted(4) ;
[~,a] = min(abs(z-a_val)) ;
[~,b] = min(abs(z-b_val)) ;
[~,c] = min(abs(z-c_val)) ;
[~,d] = min(abs(z-d_val)) ;
abcd_idx = [a b c d] ;
abcd_val = [a_val b_val c_val d_val];
ab_indices = linspace(a,b,abs(a-b)+1) ;
cd_indices = linspace(c,d,abs(c-d)+1) ;

cd_fit = fit(z(cd_indices),def(cd_indices),'poly1') ; % fit to the plateau of the deflection
def_lin_tiltcorc = def - (cd_fit.p1*z+cd_fit.p2) ; %corrected deflection

ab_fit = fit(z(ab_indices),def(ab_indices),'poly1') ; % fit to contact regime
z_surface =  -(ab_fit.p2-cd_fit.p2)/(ab_fit.p1-cd_fit.p1) ; % surface level
z_real = z - z_surface ; % z is set to zero at the surface

%separation = z  + def_corc - (z(a)+def_corc(a)) ; 
separation = z_real + def_lin_tiltcorc ;
sep_fit = fit(z(ab_indices),separation(ab_indices), 'poly1') ;
separation = separation - (sep_fit.p1.*z + sep_fit.p2) ;


poly_func = '' ;
def_poly_fit = fit(separation(cd_indices), def_lin_tiltcorc(cd_indices), ['poly' num2str(p)]) ;

for i = 0:p
    poly_func = [poly_func '+ def_poly_fit.p'  num2str(p+1-i) '*separation.^' num2str(i)] ;
end

def_poly_corc = def_lin_tiltcorc - eval(poly_func) ;
force = def_poly_corc*kc ;

abcd_val = separation(abcd_idx);
separation = separation(c:b);
force = force(c:b);

