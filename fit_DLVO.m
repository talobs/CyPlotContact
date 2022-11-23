function [] = fit_DLVO(handles) %y in nN and x in nm
k_B = 1.38e-23 ; %boltzman constant
e = 1.6e-19 ; %electron charge [C]
Na = 6.022e23 ; %avogadro's number
eps_0 = 8.854e-12 ; % vacuum's permitivity
d = 5e-6 ;
R = (d/2) ; % bead radius [m]


[x_points, ~] = ginput(2) ;
x_points = sort(x_points) ;
x_a = x_points(1) ;
x_b = x_points(2) ;

for i = 1:length(handles.selected_groups)
    group_idx = handles.selected_groups(i) ;
    x = handles.groups(group_idx).obj.sep_app*1e9 ;
    y = handles.groups(group_idx).obj.force_app*1e9 ;%handles.groups(group_idx).obj.force_app*1e9 ;
    a_idx = icp(x, x_a) ;
    b_idx = icp(x, x_b) ;
    
    
    if isfield(handles.groups(group_idx).obj.param, 'T_C')
        T_C = handles.groups(group_idx).obj.param.T_C ;
    else
        T_C = 25 ;
    end
    
    if isfield(handles.groups(group_idx).obj.param, 'n')
        n_nominal= handles.groups(group_idx).obj.param.n*Na ;
    else
        continue ;
    end
    
    z = 1 ;
    T_K = 273.15 + T_C ;
    q = e*z ; %ion's charge[C]
    eps_r = 87.740 - 0.4008*T_C + 9.398e-4*T_C^2 - 1.410e-6*T_C^3 ; % Malmberg, C. G., and A. A. Maryott. "Dielectric constant of water from 00 to 1000 C." Journal of research of the National Bureau of Standards 56.1 (1956): 1-8.

    l_d_nominal = sqrt(k_B*T_K*eps_0*eps_r/(2*q^2*n_nominal))*1e9 ; % nm
    l_d_tolerance = .1 ;

    hammaker_nominal =2.2e-21 ;
    c_nominal = hammaker_nominal*(R/6)*1e27 ;
    c_tolerance = .0 ;

    f = fit(x(a_idx:b_idx), y(a_idx:b_idx), 'a*exp(-x/b)-c/x^2+e', 'Lower', [0 l_d_nominal*(1-l_d_tolerance) max([0 c_nominal*(1-c_tolerance)]) -.0],...
        'Upper', [20 l_d_nominal*(1+l_d_tolerance) c_nominal*(1+c_tolerance) .0 ]) ;

    l_d = f.b*1e-9 ; % debye length [m]
    n = T_K*k_B*eps_0*eps_r/(2*(q*l_d)^2) ; %[m^-3]
    Z = (f.a*1e-9)*l_d/R ; % interaction constant
    psi_0 = 4*k_B*T_K/q*atanh(e*sqrt(Z)/(8*k_B*T_K*sqrt(pi*eps_0*eps_r))) ; % surface potential [V]
    sigma = eps_0*eps_r*psi_0/l_d/e ;

    fit_struct.fit_obj = f ;
    fit_struct.x = x ; %[nm]
    fit_struct.y = f.a*exp(-x/f.b)-f.c./x.^2+f.e; %[nN]

    fit_struct.param_in.T_C = T_C ;
    fit_struct.param_in.z = z ;
    fit_struct.param_in.d = d ;

    fit_struct.param_out.l_d = l_d*1e9 ; %nm
    fit_struct.param_out.n = n/Na ; %mM
    fit_struct.param_out.psi_0 = psi_0*1e3 ; %mV
    fit_struct.param_out.sigma = sigma*1e-18 ; %e/nm
    fit_struct.param_out.A = 6*(f.c*1e-27)/R ; % J



    fit_struct.param_out.C = (f.c*1e-27)*6/R ; %Hammaker constant

    fit_struct.text = {...
        ['DLVO Fit'] ;...
        ['Scrn. Length: ', num2str(l_d*1e9, '%.2f'), ' nm'] ;...
        ['Mes. Salt Con.: ', num2str(n/Na, '%.2f'), ' mM'] ;...
        ['Surf. Potential: ', num2str(psi_0*1e3, '%.2f'), ' mV'];... 
        ['Sur. Charge: ', num2str(sigma*1e-18, '%.3f'), ' e/{nm}^2'] ;...
        ['Hammaker Const.: ', num2str((f.c*1e-27)*6/R, '%.1e'), ' J']} ;
    
        handles.groups(group_idx).fit_DLVO = fit_struct ;
end

guidata(handles.figure_main, handles) ;
plot_groups(handles) ;

