pkg load image


originalRgb = im2double(imread("./imgs/Imagem.jpg"));
originalHsv = rgb2hsv(originalRgb);


figure();
imshow(originalRgb);
figure();
imshow(originalHsv);

width = 1600;  # Comprimento equivale ao N?mero de Colunas (n)
height = 900; # Altura equivale a N?mero  de Linhas (m)
p = (2 * height); # 2m
q = (2 * width); # 2n

# As dimens?es da transformada s?o 3200x1800
fftImage = fft2(originalHsv(:, :, 3), p, q); # Aplica a transformada

shiftedMatrix = fftshift(fftImage); # Centraliza a transformada

spectre = uint8(abs(shiftedMatrix)); # Calcula o Spectro de Fourier

figure();
imshow(spectre);
imwrite(spectre, './output/spectre.png');

filter = rgb2gray(im2double(imread("./filter/filter.png")));
figure();
imshow(filter);

filteredMatrix = shiftedMatrix .* filter;

unshiftedMatrix = ifftshift(filteredMatrix);

ifftImage = real(ifft2(unshiftedMatrix));
finalResult = originalHsv;
finalResult(:, :, 3)= ifftImage(1:height, 1:width);

resultImg = im2uint8(finalResult);

figure();
imshow(finalResult );
imwrite(finalResult , './output/result.png');


