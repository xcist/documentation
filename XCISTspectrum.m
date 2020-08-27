function [newE,newI] = XCISTspectrum(kVp, angle, dE)

  % ------------------------------------------------------------------------------
  % Created: B. De Man, August 27, 2020, 2020 - GE Research, Niskayuna, NY 12065, USA
  % Last modified: B. De Man, August 27, 2020, 2020 - GE Research, Niskayuna, NY 12065, USA
  %
  % Function to generate normalized, unfiltered X-ray CT spectrum for tungsten anode for tube voltages between
  % 80 kVp and 140 kVp and for target angles between 5 and 9 degrees.
  % Spectra were initialized based using SpekPY (physics-based tool) and iteratively updated based on empirical
  % CT data and gradient-ascent minimization of the attenuation least squares error (post-log).
  % The spectra are compactly parametrized using a 17 parameter vector. The average RMS
  % attenuation errors were 0.026, 0.011, 0.007 and 0.006 at 80, 100, 120 and 140 kVp respectively.
  % A detailed description of the spectrum estimation methodology is reported in :
  %     "Spectrum estimation for X-ray computed tomography"
  %     Paul FitzGerald, Stephen Araujo, Mingye Wu, Bruno De Man
  %     Submitted to Medical Physics
  % This development was supported by the National Cancer Institute of the National Institutes of Health under
  % Award Number U01CA231860 (ITCR grant). The content is solely the responsibility of the authors and does not
  % necessarily represent the official views of the National Institutes of Health.
  %
  % Inputs
  %    kVp: X-ray tube voltage
  %    angle: X-ray tube target angle (or takeoff angle of the x-ray beam relative to the target surface)
  %    dE: desire spectrum sampling density (in keV)
  %
  % Outputs
  %    newE: array of all keV values at which the spectrum is defined
  %    newI: array of all normalized photon count values of the spectrum
  %       (note that I scales inversely proportional with dE to preserve total counts)
  %
  % Example usage
  %    [E,I]=XCISTspectrum(120);
  %    figure; plot(E,I); grid on;
  %
  % Limitations
  %    Only produces normalized spectra. Users should scale the output to the desired total number of photons.
  %    Only valid for Tungsten targets
  %    Input parameter space is limited to 80-140 kVp and 5-9 degrees
  %    Does not include any inherent tube filtration.
  % ------------------------------------------------------------------------------

  %-------------------------------------------------------------------
  % validate inputs
  %-------------------------------------------------------------------
  if kVp < 80 | kVp > 140
    error('Tube voltage has to be between 80 and 140 kVp !')
  end
  if nargin < 2
    angle=7.0;
  end
  if angle < 5 | angle > 9
    error('Angle has to be between 5 and 9 degrees !')
  end
  if nargin < 3
    dE=1.0;
  end
  if dE < 0.5 | dE > 20
    error('Sampling density angle has to be between 0.5 and 20 keV !')
  end

  %-------------------------------------------------------------------
  % spectrum parameters
  %-------------------------------------------------------------------
  allparams=zeros(19,3,4);
  allparams(:,:,1)=...
  [        0         0         0
	   0.3626    0.3829    0.5826
	   26.5907   30.0794   36.8236
	   71.4718   78.9024   82.7957
	   125.4300  125.6408  131.2411
	   105.9248  105.9871  104.9238
	   81.6998   80.1716   77.4566
	   51.1205   49.6109   47.2950
	   33.2238   33.3052   31.9747
	   19.5478   19.3776   18.5015
	   -19.5478  -19.3776  -18.5015
	   -58.6434  -58.1327  -55.5044
	   -117.2868 -116.2654 -111.0089
	   -195.4781 -193.7756 -185.0148
           0         0         0
	   36.3735   39.8779   40.4810
	   63.8694   69.4547   71.3607
	   30.6341   31.6915   33.1604
	   16.6512   15.5828   17.4690];

  allparams(:,:,2)=...
  [        0         0         0
           0         0         0
	   11.3630   10.9994   17.9281
	   42.8692   46.8344   52.2382
	   68.5482   69.3482   72.8265
	   73.1170   73.4030   73.5939
	   65.2276   63.8287   62.4773
	   50.3641   48.6826   46.8594
	   34.7269   35.6589   35.3440
	   29.9762   30.3889   29.7940
	   19.3368   19.1640   18.3610
	   7.2480    7.1871    6.5785
	   -14.4960  -14.3742  -13.1570
	   -43.4880  -43.1227  -39.4710
           0         0         0
	   107.0045  113.7751  118.8213
	   191.1371  202.6912  211.7474
	   73.1713   76.4303   79.2580
	   18.2510   18.2267   18.9965];

  allparams(:,:,3)=...
  [        0         0         0
           0         0         0
	   9.8298    8.1181   13.6798
	   30.6989   32.9405   37.9516
	   46.7789   48.1178   51.3262
	   55.3399   55.6869   56.6865
	   52.8371   51.3765   50.9857
	   44.2042   42.3971   41.1895
	   28.7365   29.8792   30.4512
	   26.5260   27.3196   27.3380
	   21.5729   21.6445   21.1288
	   15.8592   15.6821   14.9121
	   6.7885    6.7561    6.0091
	   -6.7885   -6.7561   -6.0091
           0         0         0
	   138.9171  146.2977  153.3816
	   249.5662  262.4256  274.5463
	   95.1027   98.6927  102.4479
	   21.9952   22.2889   23.2269];

  allparams(:,:,4)=...
  [        0         0         0
           0         0         0
	   8.9293    6.5538   12.0495
	   23.0121   24.2020   29.1267
	   35.8588   36.9669   40.4828
	   44.2194   44.5648   46.1326
	   44.3101   42.9476   43.0958
	   38.9084   37.1170   36.3141
	   23.2813   24.5805   25.5531
	   22.4201   23.3772   23.8571
	   19.8576   20.1227   19.9501
	   16.5687   16.4395   15.9445
	   11.1949   10.9434   10.2288
	   3.8723    3.9236    3.3054
           0         0         0
	   154.9455  162.6106  171.0913
	   279.3838  292.8296  307.2269
	   107.6205  111.0876  115.5967
	   25.1904   25.3800   26.5679];

  %-------------------------------------------------------------------
  % Interpolate in angle
  %-------------------------------------------------------------------
  angleparams=zeros(19,4);
  for i=1:19
    for j=1:4
      pp=polyfit([5,7,9],[allparams(i,:,j)],2);
      angleparams(i,j)=(polyval(pp,angle));
    end
  end
  
  %-------------------------------------------------------------------
  % Interpolate in tube voltage
  %-------------------------------------------------------------------
  params=zeros(19,1);
  for i=1:19
    params(i)=max(spline([80,100,120,140],angleparams(i,:),kVp),0);
  end

  %-------------------------------------------------------------------
  % Define spline left and right of K-edge and characteristic peaks
  %-------------------------------------------------------------------
  % Define spline left of K-edge
  ee=[15,20,26,32,38,46,56,66]; % spline knot energies below K-edge
  ii=params(1:8);

  % Define spline right of K-edge
  ee2=[70.25,75,85,95,110,130]; % spline knot energies above K-edge
  index=find(ee2<kVp);
  if ~isempty(index)
    ee2=[ee2(index),kVp];
  else
    ee2=[69.75,kVp];
  end
  ii2=params(9:9+length(ee2)-1);

  % Define characteristic peaks
  eek=[57.982,59.318,67.244,69.100]; % 4 characteristic peaks (drop the fifth one at 69.517)
  iik=params(16:19);

  %-------------------------------------------------------------------
  % Generate new spectrum with sampling distance dE
  %-------------------------------------------------------------------
  % Interpolate from knots left of K-edge
  newE=dE/2:dE:kVp; %define the new energy coordinates
  indexl=find(newE<=69.5); %indices where we want to interpolate from left size of K-edge
  xx=newE(indexl);
  yy=spline([ee],[ii],xx)*dE/0.5; %re-scale to correct absolute count depending on keV sampling density
  yy(find(xx<ee(1)))=0; % set to zero left of first knot

  % Eliminate oscillations below 30 keV
  therefix=find(xx<30);
  f1=0.98^(dE/0.5);
  f2=0.8^(dE/0.5);
  for i=1:length(therefix)
    i2=therefix(end-i+1);
    if yy(i2)>f1*yy(i2+1)
      yy(i2)=f2*yy(i2+1);
    end
  end

  % Interpolate right side of K-edge
  indexr=find(newE>69.5); %indices where we want to interpolate from right size of K-edge
  xx2=newE(indexr); %re-scale to correct absolute count depending on keV sampling density
  yy2=spline(ee2,ii2,xx2)*dE/0.5;
  yy2(find(xx2>kVp))=0; % set to zero right of last knot

  % Stack left and right sides together
  newI=max([yy,yy2],0);

  % Add counts for characteristic peak #1
  index=find(newE>eek(1));indexh=index(1); indexl=indexh-1; %find coords that straddle the peak
  dxx=newE(indexh)-newE(indexl);
  newI(indexl)=newI(indexl)+iik(1)*(newE(indexh)-eek(1))/dxx; %spread counts across two nearest energies
  newI(indexh)=newI(indexh)+iik(1)*(eek(1)-newE(indexl))/dxx;

  % Add counts for characteristic peak #2
  index=find(newE>eek(2));indexh=index(1); indexl=indexh-1;
  dxx=newE(indexh)-newE(indexl);
  newI(indexl)=newI(indexl)+iik(2)*(newE(indexh)-eek(2))/dxx;
  newI(indexh)=newI(indexh)+iik(2)*(eek(2)-newE(indexl))/dxx;

  % Add counts for characteristic peak #3
  index=find(newE>eek(3));indexh=index(1); indexl=indexh-1;
  dxx=newE(indexh)-newE(indexl);
  newI(indexl)=newI(indexl)+iik(3)*(newE(indexh)-eek(3))/dxx;
  newI(indexh)=newI(indexh)+iik(3)*(eek(3)-newE(indexl))/dxx;

  % Add counts for characteristic peak #4
  index=find(newE>eek(4));indexh=index(1); indexl=indexh-1;
  dxx=newE(indexh)-newE(indexl);
  newI(indexl)=newI(indexl)+iik(4)*(newE(indexh)-eek(4))/dxx;
  newI(indexh)=newI(indexh)+iik(4)*(eek(4)-newE(indexl))/dxx;
