close all
clear all
%% Emd testing data

% Images. Compare image to itself.
    A = imread('comparision-sup-5th.png');
    B = imread('comparision-sup-5th.png');
    
% Histograms
nbins = 128;
[ca, ha] = imhist(A, nbins);
[cb, hb] = imhist(B, nbins);

% Features
f1 = ha;
f2 = hb;

% Weights
w1 = ca / sum(ca);
w2 = cb / sum(cb);

% Earth Mover's Distance
[f, fval] = emd(f1, f2, w1, w2, @gdf);

% Results
wtext = sprintf('fval = %f', fval);
figure('Name', wtext);
subplot(121);imshow(A);title('first image');
subplot(122);imshow(B);title('second image');

% Compare it too an image containing no passing patterns. 

 A = imread('comparision-sup-5th.png');
B = imread('proveblue.png');

% Histograms
nbins = 128;
[ca, ha] = imhist(A, nbins);
[cb, hb] = imhist(B, nbins);

% Features
f1 = ha;
f2 = hb;

% Weights
w1 = ca / sum(ca);
w2 = cb / sum(cb);

% Earth Mover's Distance
[f, fval] = emd(f1, f2, w1, w2, @gdf);

% Results
wtext = sprintf('fval = %f', fval);
figure('Name', wtext);
subplot(121);imshow(A);title('first image');
subplot(122);imshow(B);title('second image');



A = imread('comparision-sup-5th.png');
B=imread('random.png');

% Histograms
nbins = 128;
[ca, ha] = imhist(A, nbins);
[cb, hb] = imhist(B, nbins);

% Features
f1 = ha;
f2 = hb;

% Weights
w1 = ca / sum(ca);
w2 = cb / sum(cb);

% Earth Mover's Distance
[f, fval] = emd(f1, f2, w1, w2, @gdf);

% Results
wtext = sprintf('fval = %f', fval);
figure('Name', wtext);
subplot(121);imshow(A);title('first image');
subplot(122);imshow(B);title('second image');