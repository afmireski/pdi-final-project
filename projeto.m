pkg load image


originalRgb = im2double(imread("./imgs/Imagem.jpg"));
originalHsv = rgb2hsv(originalRgb);


figure();
imshow(originalRgb);
imwrite(originalRgb, './step/0_original.png')
#figure();
#imshow(originalHsv);

width = 1600;  # Comprimento equivale ao N?mero de Colunas (n)
height = 900; # Altura equivale a N?mero  de Linhas (m)
p = (2 * height); # 2m
q = (2 * width); # 2n

# As dimens?es da transformada s?o 3200x1800
fftImage = fft2(originalHsv(:, :, 3), p, q); # Aplica a transformada

shiftedMatrix = fftshift(fftImage); # Centraliza a transformada

spectre = uint8(abs(shiftedMatrix)); # Calcula o Spectro de Fourier

#figure();
#imshow(spectre);
imwrite(spectre, './step/1_spectre.png');

filter = im2double(imread("./filter/filter_bw.png"));
imwrite(filter, './step/2_filter.png');

filteredMatrix = shiftedMatrix .* filter;

fspectre = uint8(abs(filteredMatrix));
imwrite(fspectre, './step/3_fspectre.png');

unshiftedMatrix = ifftshift(filteredMatrix); # Descentraliza a imagem

ifftImage = real(ifft2(unshiftedMatrix)); # Aplica a transformada inversa
finalResult = originalHsv;

imwrite(ifftImage(1:height, 1:width), './step/4_ifft.png');
finalResult(:, :, 3)= ifftImage(1:height, 1:width);

resultImg = hsv2rgb(finalResult);

figure();
imshow(resultImg);
imwrite(resultImg , './step/5_result.png');
imwrite(resultImg , './output/result.png');


