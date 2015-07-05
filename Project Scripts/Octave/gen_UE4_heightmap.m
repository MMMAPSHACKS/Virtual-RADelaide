%gen_UE4_heightmap.m
%Ocatave script -  Converts elevation data to a form suitable scaled for 
%integration into the unreal engine platform
%Modified: 05/07/2015
%Req. Packages: image

pkg load image

%Dimensions of elevation data
inputdim = [1009 1009];
%input file name - raw elevation data  (*.bin)
filename = 'adelaide30km_0.bin';
%output file name - modified elevation data for unreal 4 engine (*.r16)
outputfilename = 'heightmap1.r16';

%import elevation data
fid = fopen(filename);
heights = fread(fid, inputdim, 'short');
fclose(fid);

%Convert negative elevations to sea level i.e., 0
for x = 1 : size(heights, 1)
    for y = 1 : size(heights, 2)
       if heights(x,y) < 0
           heights(x,y) = 0;
       end
    end
end

heights = fliplr(heights);

% rescale to ue4 height range
scalez = 200; %Scale factor (100% scale equivalent to [-256, 256] heights m in UE4)

%scale heights for the unreal engine
heightsue4 = heights * 32768/(256*scalez/100) + 32768; 

%interploate elevation data to UE4 dimensions
%interplation methods - linear, bilinear, cubic, bicubic.
%Note: depending on the system high order interploation schemes may 
%not work due to memory limitations
heightsue4 = imresize(heightsue4, [4033 4033], 'bilinear');

%export interplated height map to file
fid = fopen(outputfilename, 'w');

fwrite(fid, heightsue4, 'ushort');

fclose(fid);
