%% Project 3 Question 1 - UAV Package Delivery
% Jackson Fezell, Nicholas Giampetro, Ankit Gupta

clc; clear; close all;


%% Problem Setup and Computation


% runs dijkstra is true, runs A* if false
RUN_DIJKSTRA = false;


% Building the Map
map_size = 11;
map_base = ones(map_size);

i_start = 1; %starting row
j_start = 1; %starting column
startNode = [i_start,j_start];

i_goal = 11; %ending row
j_goal = 11; %ending column
goalNode = [i_goal,j_goal];

map = map_base;
trees = false;

[map(3,3), map(3,4), map(4,4), map(4,5), map(4,6),...
    map(5,6), map(5,7), map(5,8), map(6,8), map(6,9)] = deal(trees);

map;
% Defining the Cost Matrix
cost = inf*map_base;
cost(startNode(1),startNode(2)) = 0;

[cost, visitedNodes] = minimumTravelCosts(startNode, goalNode, cost, map, map_size, RUN_DIJKSTRA);

[optimalPath, optimalCost] = findingOptimalPath(startNode, goalNode, cost, map_size);

%% Plotting the Results

%formatting the data for best plotting results
trueOptCost = flip(optimalCost);
trueOptPath = flip(optimalPath, 1);

plottingOptPath(:,1) = (map_size + 1) - trueOptPath(:,1);
plottingOptPath(:,2) = trueOptPath(:,2);

if RUN_DIJKSTRA == false
    [cost(3,3), cost(3,4), cost(4,4), cost(4,5), cost(4,6),...
        cost(5,6), cost(5,7), cost(5,8), cost(6,8), cost(6,9)] = deal(0);
end

plottingDistances = flip(cost, 1);

%plotting
figure(1)
imagesc(plottingDistances)
hold on;

plot(plottingOptPath(:,2), plottingOptPath(:,1), 'Color','r', 'LineWidth',2)
hold on;

plot(startNode(2), (map_size + 1) - startNode(1),'.','MarkerSize',25, 'Color','g') %starting location
hold on;

plot(goalNode(2), (map_size + 1) - goalNode(1),'.','MarkerSize',25, 'Color','r') %ending location

%title("The Optimal Travel Cost is " + trueOptCost(end))
if(RUN_DIJKSTRA==false)
    title ('A* Algorithm')
    trueOptCost(end)
end
if(RUN_DIJKSTRA==true)
    title('Dijkstra Algorithm')
    trueOptCost(end)
end
xticks(1:1:map_size)
yticks(1:1:map_size)
yticklabels(map_size:-1:1)
colormap('bone')
colorbar

%% Building the Minimum Distance Map

function [cost, visitedNodes] = minimumTravelCosts(startNode, goalNode, cost, map, map_size, RUN_DIJKSTRA)

k = 1; % keeps track of nodes visited
previousCost = 0; %initial cost at start
currentNode = startNode; %first node is the starting node
visitedNodes(:,:,k) = [previousCost, startNode]; %keeping track of all nodes visited, not checked neighbors

while goalNode(1) ~= currentNode(1) || goalNode(2) ~= currentNode(2)

    %counter for the number of neighbors checked
    c = 0;

    %loops to check all neighboring nodes
    for i=max(currentNode(1)-1, 1):min(currentNode(1)+1, map_size)
        
        for j=max(currentNode(2)-1, 1):min(currentNode(2)+1, map_size)
            
            nodeCheck = [i,j];

            if nodeCheck == currentNode
                map(i,j) = 0;
            end

            %checks to see if the next node has already been visited
            if map(i,j) == 0
                travel = false;
            else
                travel = true;
            end
            
            
            if travel == true

                c = c + 1;

                %checks which algorithm is running
                if RUN_DIJKSTRA == true
                    heuristic = 0;
                    weight = 0;
                elseif RUN_DIJKSTRA == false
                    node_end_dist = [goalNode(1)-i,goalNode(2)-j];
                    heuristic = norm(node_end_dist,2);
                    weight = 1; %changes how much you trust the heuristic
                end

                %finds the cost to travel to each node
                ij_dist = [i-currentNode(1),j-currentNode(2)];
                costCheck(c) = norm(ij_dist,2) + previousCost + weight*heuristic;

                %keeps track of the nodes that were checked
                checkedNodes(:,:,c) = [i,j];
                
                %assigns the cheapest cost to travel to a checked node
                if costCheck(c) < cost(i,j)
                    cost(i,j) = costCheck(c);
                end

            end
            
        end
          
    end
    
    %check other nodes for lowest value before setting node above as current
    
    %find the minimun cost to travel to new node
    previousCost = min(costCheck);

    %finding the indices of the iteration at which the minimum cost occured
    [~, colNew] = find(previousCost == costCheck);

    %assigning the corresponding checked node to min cost
    %since multiple might arise, select the first min cost node that was checked
    currentNode = checkedNodes(:,:,colNew(1));

    %checking other nodes that had the cheapest cost on the map, but were not yet explored
    for i=1:map_size
        for j=1:map_size
            if map(i,j) > 0 && cost(i,j) < previousCost
                currentNode = [i,j];
                previousCost = cost(i,j);
            end
        end
    end
    
    %keeping track of the amount of nodes visited and the order
    k = k + 1;

    %keep track of the best cost and node indices of the current move
    visitedNodes(:,:,k) = [previousCost, currentNode];

    %subtract the heuristic value associated with the node for the next iteration
    if RUN_DIJKSTRA == false
        previousCost = previousCost - weight*heuristic;
    end

    %resetting cost check array to inf to ensure no previous values mess up next iteration
    costCheck(:) = inf;

    %resetting node check array to [inf,inf] to ensure no previous values mess up next iteration
    for z=1:length(costCheck)
    checkedNodes(:,:,z) = [inf,inf];
    end

end
end


%% Finding the Optimal Path Back to Starting Node

function [optimalPath, optimalCost] = findingOptimalPath(startNode, goalNode, cost, map_size)

%setting up conditions for backtracking the optimal path
currentNode = goalNode;
k = 1;
optimalCost(k) = cost(goalNode(1), goalNode(2));
optimalPath(k,:) = goalNode;

while startNode(1) ~= currentNode(1) || startNode(2) ~= currentNode(2)

    %keeps track of the number of nodes checked
    c = 0;

    % iterations through neighboring nodes
    for i=max(currentNode(1)-1, 1):min(currentNode(1)+1, map_size)
        
        for j=max(currentNode(2)-1, 1):min(currentNode(2)+1, map_size)

            %makes sure that only neighboring nodes are being checked
            if (currentNode(1) == i && currentNode(2) == j) || cost(i,j) == inf
                backtrack = false;
            else
                backtrack = true;
            end

            %checking all neighboring nodes for cost to determine best path
            if backtrack == true

                %only increases when a neighbor is checked
                c = c + 1;

                %keeping track of all the neighbors' costs and locations
                neighborCosts(c) = cost(i,j);
                neighborPaths(c,:) = [i,j];
                    
            end

        end

    end

    %increasing the array index to add the next optimal move
    k = k + 1;

    %finding the lowest cost amongst the neighbors
    optimalCost(k) = min(neighborCosts);
    [~, colOpt] = find(optimalCost(k) == neighborCosts);
    optimalPath(k,:) = neighborPaths(colOpt(1),:);

    %assigning the new best node for the next iteration
    currentNode = optimalPath(k,:);

end
end



