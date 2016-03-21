%  Test script

% function test_AxonStatsCalculation(testCase)
% 
% img_test = imread('BW_test_stats.jpg');
% actSolution = as_stats_axons(img_test);
% expSolution = [2 1];
% verifyEqual(testCase,actSolution,expSolution)
% 
% end



%% TEST 1 - Axon stats computation from a binary image

img_test = imread('test_BW.jpg');
img_test = im2bw(img_test);
[Stats_struct,var_names] = as_stats_axons(img_test);

nbr_objects = size(cat(1,Stats_struct.Area),1);
expSolution = 7;
assert(isequal(nbr_objects,expSolution),'Error while calculating axon stats in as_stats_axons function');

%% TEST 2 - 




%% TEST 3 - 





%% TEST 4 - 





%% TEST 4 - Axon stats computation from a binary image


























