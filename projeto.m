pkg load image


function r = melhoraContraste(img, m, n)
  y = 0.8; # gama

  r = img .^ y; # Aplica uma opera??o
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

figure();
imshow(spectre);
imwrite(spectre, './steps/1_spectre.png');

filter = im2double(imread("./filter/filter.png")); # Obt?m o filtro
imwrite(filter, './steps/2_filter.png');

filteredMatrix = shiftedMatrix .* filter; # Aplica o filtro

fspectre = uint8(abs(filteredMatrix)); # Salva o espectro com o filtro aplicado
imwrite(fspectre, './steps/3_fspectre.png');

unshiftedMatrix = ifftshift(filteredMatrix); # Descentraliza a imagem

ifftImage = real(ifft2(unshiftedMatrix)); # Aplica a transformada inversa
newValue = ifftImage(1:height, 1:width); # Obt?m a intensidade processada
contrasteV = real(melhoraContraste(newValue, height, width)); # Melhora o contraste

imwrite(newValue , './steps/4_newValue.png');
imwrite(contrasteV, './steps/4.1_newValueC.png');
finalResult = cat(3, hue, saturation, newValue ); # Gera a imagem final juntando os tr?s componentes

# Converte os resultados para RGB
resultImg = hsv2rgb(finalResult);
resultConstraste = hsv2rgb(cat(3, hue, saturation, contrasteV ));

figure();
imshow(resultImg);
figure();
imshow(resultConstraste);

imwrite(resultImg , './steps/5_result.png');
imwrite(resultConstraste, './steps/5.1_resultC.png');
imwrite(resultImg , './output/result.png');
imwrite(resultConstraste , './output/resultMelhorado.png');


