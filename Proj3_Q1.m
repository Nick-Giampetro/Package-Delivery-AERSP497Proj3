%% Project 3 Question 1 - UAV Package Delivery
% Jackson Fezell, Nicholas Giampetro, Ankit Gupta

% Building the Map
map_size = ones(11);
i = 11; %starting row
j = 1;  %starting column

map = map_size;
trees = inf;

[map(9,3), map(9,4), map(8,4), map(8,5), map(8,6),...
    map(7,6), map(7,7), map(7,8), map(6,8), map(6,9)] = deal(trees);

% Defining the Distance and Unvisited Matrices
distance = inf*map_size;
distance(11,1) = 0;

unvisited = map_size;
unvisited(11,1) = 0;


while unvisited(1,11) == true;
% implement if statment to check corners and borders
% then the if statement can save a numeric value to a switch case
% use switch to determine how to check surrounding nodes on grid without breaking indicies

if map(i-1,j-1)==true

end
end
