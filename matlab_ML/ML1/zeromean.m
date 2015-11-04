function outdata = zeromean(indata, start, stop)
%outdata = zeromean(indata, start, stop)
%
%Subtracts the mean value from each column in the matrix from each value
%in each column. Start and stop sample values are optional. Indata is a
%NSamps x NChans matrix, such as that returned by rd_onetr_allch (c.f.).
%

%Modification History
%  Written 6/126/95  PJ
%  Additional error checking added 10/11/95 by BCR
%  Modified to properly handle the case of no start and stop entered RS 10/31/95
%  Fixed some of the other error checks    RS 10/31/95

if (nargin < 1) | (size(indata,1)==0) | (size(indata,1)==0)
    error('Function requires at least one argument, a rectangular matrix.');
    end;
    
if nargin == 1
    start = 1; 
    stop = size(indata,1);
    end;

if nargin == 2
    if start >= size(indata,1)
        error('Start argument must be less than # of data matrix rows.');
    end;
    stop = size(indata,1);
    end;
if nargin >= 3
    if start >= size(indata,1)
        error('Start argument must be less than # of data matrix rows.');
    end;
    if stop > size(indata,1)
        error('Stop argument must be less than # of data matrix rows.');
    end;
    if stop <= start
        error('Stop argument must be greater than start argument.');
    end;
    if nargin > 3
        disp('Ignoring arguments beyond the third.');
    end;
    end;

outdata = zeros(size(indata));

datamean = mean(indata(start:stop,:));  % returns a row-vector with mean of each column
datamean = ones(size(indata,1),1) * datamean; % turns mean vector into matrix

outdata = indata - datamean;
return