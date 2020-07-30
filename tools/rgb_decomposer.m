close all
clear all
clc

root = '..\test\original\';

for i = 1:3
    imgp = strcat(root, 'img', num2str(i), '\img.jpg');
    rp = strcat(root, 'img', num2str(i), '\R.txt');
    gp = strcat(root, 'img', num2str(i), '\G.txt');
    bp = strcat(root, 'img', num2str(i), '\B.txt');
    coep = strcat(root, 'img', num2str(i), '\RGB.coe');
    
    x = imread(imgp);
    r = x(:,:,1);
    g = x(:,:,2);
    b = x(:,:,3);

    dlmwrite(rp, r);
    dlmwrite(gp, g);
    dlmwrite(bp, b);
    
    coef = fopen(coep, 'w');
    fprintf(coef, 'memory_initialization_radix = 10;\nmemory_initialization_vector =\n');
    fclose(coef);
    
    dlmwrite(coep, r, '-append', 'delimiter', ' ', 'roffset', 2);
    dlmwrite(coep, g, '-append', 'delimiter', ' ', 'roffset', 2);
    dlmwrite(coep, b, '-append', 'delimiter', ' ', 'roffset', 2);
    
    coef = fopen(coep, 'a');
    fprintf(coef, ';');
    fclose(coef);   
end