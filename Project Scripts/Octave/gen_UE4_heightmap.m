%gen_UE4_heightmap.m
%Ocatave script -  Converts Elevation data to a suitable scaled form for 
%integration in the Unreal 4 degin engine
%Modified: 05/07/2015
%Req. Packages: image

%Dimension of input elevation file
inputdim = [1009 1009];
%input file name - raw elevation data  (*.bin)
filename = 'adelaide30km_0.bin';
%output file name - modified elevation data for unreal 4 engine (*.r16)
outputfilename = 'heightmap1.r16';

%import elevation data
fid = fopen(filename);
heights = fread(fid, inputdim, 'short');
fclose(fid);

%Convert negative elevations to sea level
for x = 1 : size(heights, 1)
    for y = 1 : size(heights, 2)
       if heights(x,y) < 0
           heights(x,y) = 0;
       end
    end
end

heights = fliplr(heights);

% rescale to ue4 height range
scalez = 200; %Scale factor (100% equivalent to 256m in UE4)
heightsue4 = heights * 32768/(256*scalez/100) + 32768; 

%interploate elevation data to UE4 dimensions
%interplation methods - linear, bilinear, cubic, bicubic.
%Note: depending on the system certain high order interploation schemes may 
%not work due to memory limitations
heightsue4 = imresize(heightsue4, [4033 4033], 'bilinear');

%export interplated height map to file
fid = fopen(outputfilename, 'w');

fwrite(fid, heightsue4, 'ushort');

fclose(fid);
