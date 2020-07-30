close all
clear all
clc

root = '..\test\';

for i = 1:3
    rop = strcat(root, 'original\img', num2str(i), '\R.txt');
    gop = strcat(root, 'original\img', num2str(i), '\G.txt');
    bop = strcat(root, 'original\img', num2str(i), '\B.txt');
    
    rp = strcat(root, 'decoded\img', num2str(i), '-T0\R.txt');
    gp = strcat(root, 'decoded\img', num2str(i), '-T0\G.txt');
    bp = strcat(root, 'decoded\img', num2str(i), '-T0\B.txt');
    
    ro = dlmread(rop);
    ro = uint8(ro(1:128, 1:128));

    go = dlmread(gop);
    go = uint8(go(1:128, 1:128));

    bo = dlmread(bop);
    bo = uint8(bo(1:128, 1:128));

    r = dlmread(rp);
    r = uint8(r(1:128, 1:128));

    g = dlmread(gp);
    g = uint8(g(1:128, 1:128));

    b = dlmread(bp);
    b = uint8(b(1:128, 1:128));

    r_equality = isequal(r, ro);
    g_equality = isequal(g, go);
    b_equality = isequal(b, bo);

    if (r_equality && g_equality && b_equality)
        fprintf('Test %d Passed!\n', i);
    else
        fprintf('Test %d Faild!\n', i);
    end
end