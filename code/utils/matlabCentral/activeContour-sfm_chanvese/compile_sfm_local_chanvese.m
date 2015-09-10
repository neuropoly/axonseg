% compile_sfm_chanvese
%
% compiles sfm_chanvese_mex

disp('Compiling sfm_chanvese_mex...');
mex sfm_local_chanvese_mex.cpp llist.cpp energy3c.cpp lsops3c.cpp
disp('Compilation complete.');
disp('');
