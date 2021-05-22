%Clear workspace
close all;
clear all;
clc;

% Load in audio files - Uncomment to test audio 1
load('audio_1_method_2_no_overlap.mat');
%load('audio_2_method_2_no_overlap.mat');

%Main Variables
nWindows = 195; 
nHarmonics = 30;
tStart = 1/fs;
tEnd = 0.05;
sampStart = 1;
sampEnd = 2205;

%%
%Method 2 -- The only changes here are in the cosine equation (Line 42) and nWindows value (line 13).
%Frequency is only indexed by i instead of both j and i. nWindows = 195
%since A is a 195x30 array in method 2
%%%

%Define time (Start at tStart, increment by the period until tEnd)

t= tStart:1/fs:tEnd;

%Define initial value for xSum and x. x(t) will be defined in for loop. x is
%the final reconstruction, using sum of all x(t) values. For now is will be
%defined as an array full of placeholder values

xSum = 0;
x = zeros(1,441000);

% Nested for loop will index through A and freqs array to recreate cosine equations
for j=1:nWindows
    for i=1:nHarmonics
        
        % Find cosine equation for A and freq values at (j,i)  
        xt = 2*abs(A(j,i))*cos(2*pi*freqs(i)*t+angle(A(j,i)));
        
        %Sum the cosines
        xSum = xt + xSum;
    end
    
    %Store 2205 samples equal to value of xt into the x array
    x(sampStart:sampEnd)=xSum;
    
    %Shift sample start/end values to next batch of 2205 samples
    sampStart = sampEnd +1;
    sampEnd = sampEnd +2205;
    
    %Shift time start value to next window
    tStart = tEnd+(1/fs);
    
    %Shift time end value to next window
    tEnd = (j+1)*0.05;
    
    %Reset xSum
    xSum = 0;
    
end

%Play sound
soundsc(x,fs)
