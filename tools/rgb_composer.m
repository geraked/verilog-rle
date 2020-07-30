close all
clear all
clc

root = '..\test\decoded\img';

for i = 1:3
    pt = strcat(root, num2str(i), '-T0', '\');

    r = dlmread(strcat(pt, 'R.txt'));
    r = uint8(r(1:128, 1:128));
    g = dlmread(strcat(pt, 'G.txt'));
    g = uint8(g(1:128, 1:128));
    b = dlmread(strcat(pt, 'B.txt'));
    b = uint8(b(1:128, 1:128));

    x = cat(3, r, g, b);
    imwrite(x, strcat(pt, 'img.jpg'));
    
    pt = strcat(root, num2str(i), '-T30', '\');
    
    r = dlmread(strcat(pt, 'R.txt'));
    r = uint8(r(1:128, 1:128));
    g = dlmread(strcat(pt, 'G.txt'));
    g = uint8(g(1:128, 1:128));
    b = dlmread(strcat(pt, 'B.txt'));
    b = uint8(b(1:128, 1:128));

    x = cat(3, r, g, b);
    imwrite(x, strcat(pt, 'img.jpg'));    
end