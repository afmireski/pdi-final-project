pkg load image

function filter = buildMyNotchFilter(filter, p, q)
  boxH = 300
  boxV = 30
  filter(1:((p/2)-boxV), ((q/2)-4):((q/2)+4)) = 0;
  filter(((p/2)+boxV):p, ((q/2)-4):((q/2)+4)) = 0;

  filter((p/2)-3:(p/2)+3, 1:(q/2)-boxH) = 0;
  filter((p/2)-3:(p/2)+3, (q/2)+boxH:q) = 0;
endfunction

originalRgb = im2double(imread("./imgs/Imagem.jpg"));
originalHsv = rgb2hsv(originalRgb);

hue = originalHsv(:, :, 1);
saturation = originalHsv(:, :, 2);
value = originalHsv(:, :, 3);


figure();
imshow(originalRgb);
imwrite(originalRgb, './steps/0_original.png');
#figure();
#imshow(originalHsv);

width = 1600;  # Comprimento equivale ao N?mero de Colunas (n)
height = 900; # Altura equivale a N?mero  de Linhas (m)
p = (2 * height); # 2m
q = (2 * width); # 2n

# As dimens?es da transformada s?o 3200x1800
fftImage = fft2(value, p, q); # Aplica a transformada

shiftedMatrix = fftshift(fftImage); # Centraliza a transformada

spectre = uint8(abs(shiftedMatrix)); # Calcula o Spectro de Fourier

#figure();
#imshow(spectre);
imwrite(spectre, './steps/1_spectre.png');

filter = im2double(imread("./filter/filter_v2.png"));
#filter = buildMyNotchFilter(filter, p, q);
imwrite(filter, './steps/2_filter.png');

filteredMatrix = shiftedMatrix .* filter;

fspectre = uint8(abs(filteredMatrix));
imwrite(fspectre, './steps/3_fspectre.png');

unshiftedMatrix = ifftshift(filteredMatrix); # Descentraliza a imagem

ifftImage = real(ifft2(unshiftedMatrix)); # Aplica a transformada inversa
newValue = ifftImage(1:height, 1:width);

imwrite(newValue , './steps/4_newValue.png');
finalResult = cat(3, hue, saturation, newValue );

resultImg = hsv2rgb(finalResult);

figure();
imshow(resultImg);
imwrite(resultImg , './steps/5_result.png');
imwrite(resultImg , './output/result.png');


