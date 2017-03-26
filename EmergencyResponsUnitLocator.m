function EmergencyResponseUnitLocator()
	global city;
	city = load_locations();


	population = init_population(100);
	init_value = population(1);

	gens = [0];
	costs = [cost_of(init_value)];
	[x y] = coord_of(init_value);
	coords = [sprintf('(%d, %d)', x, y)];
	time = {sprintf('%f min', response_time_of(init_value))};
	xs = [x];
	ys = [y];

	fprintf('INITIAL COORDS: (%d, %d)\n', x, y);
	fprintf('INITIAL COST: %f\n[', cost_of(population(1)));

	for generation = 1:100
		[parents N] = truncation_selection(population, 0.50);
		children_ = crossover(parents, population, N);
		population = mutate(children_, 0.2, parents, population, N);

		loc_of_best = population(1);
		freq_of_best = city(loc_of_best);
		cost_of_best = cost_of(loc_of_best);
		[x y] = coord_of(loc_of_best);
		response_time_of_best = response_time_of(loc_of_best);

		%fprintf('gen: %d [%d %d]: %f %f\n', generation, x, y, cost_of_best, response_time_of_best)
		fprintf('=')

		gens = [gens; generation];
		costs = [costs; cost_of_best];
		coords = [coords; sprintf('(%d, %d)', x, y)];
		time = [time; sprintf('%f min', response_time_of_best)];

		xs = [xs; x];
		ys = [ys; y];
		
		grid on
		hold on
		subplot(2, 1, 1);
		scatter(xs, ys, 'filled');
		axis([0 10 0 10]);
		set(gca,'XTick',[0:10]);
		set(gca,'YTick',[0:10]);


		grid on
		hold on
		subplot(2,1,2);
		
		scatter(gens, costs, 'filled'), ...
		plot(gens, costs, 'r'), ...
		xlabel('Generations'), ...
		ylabel('Cost Value'), ...
		title('Cost Value Per Generation (100 Generations)')
		drawnow
	end

	fprintf(']')
	table(gens, coords, costs, time, 'VariableNames',{'Generations', 'ProposedCoordinates', 'CostValue','ResponseTime'})


end

function city = load_locations()

	city = [
		5 2 4 8 9 0 3 3 8 7;
		5 5 3 4 4 6 4 1 9 1;
		4 1 2 1 3 8 7 8 9 1;
		1 7 1 6 9 3 1 9 6 9;
		4 7 4 9 9 8 6 5 4 2;
		7 5 8 2 5 2 3 9 8 2;
		1 4 0 6 8 4 0 1 2 1;
		1 5 2 1 2 8 3 3 6 2;
		4 5 9 6 3 9 7 6 5 10;
		0 6 2 8 7 1 2 1 5 3;
	];
end

function [x y] = coord_of(pos)
	global city;
	[x y] = ind2sub(size(city), pos);
end

function time = response_time_of(fire_station)
	r = cost_of(fire_station);
	time = 1.7 + 3.4 * r;
end

function cost_ = cost_of(proposed)
	global city;

	cost_ = 0;

	for pos = 1:numel(city)
		if pos ~= proposed
			%pos
			non_proposed = pos;
			fire_freq = city(pos);
			cost_ = cost_ + distance_of(non_proposed, proposed, fire_freq);
		% else
		% 	pos
		% 	city(pos)
		end
	end
end

function distance_ = distance_of(non_proposed, proposed, fire_freq)
	n = non_proposed;
	fs = proposed;

	[xn  yn] = coord_of(n);
	[xfs yfs] = coord_of(fs);
	w = fire_freq;

	distance_ = w * sqrt( (xn-xfs)^2 + (yn-yfs)^2 );
end

function population = init_population(population_size)
	global city;
    % for each new chromosome of population,
    %   generate a random location order
    population = randperm(100);
end

function [parents N] = truncation_selection(population, proportion)
	
	global city;
	population_size = length(population);

    % put population matrix to population cell array
    cell_population = num2cell(population);

    % sort population cell array by fitness cost
    [~,sorted_fitnesses] = sort(cellfun(@(loc)cost_of(loc),cell_population));
    population = population(sorted_fitnesses);


    % get N-best fitnesses based on proportion
    N = population_size * proportion;

    % set N-best fitnesses as parents
    parents = population( 1:N );
end

function children_ = crossover(parents, population, N)
	global city;
	children_ = [];

	for parent_ = 1:2:length(parents)
		% CROSSOVER
		parent1 = parents(parent_);
		parent2 = parents(parent_ + 1);

		[x1 y1] = coord_of(parent1);
		[x2 y2] = coord_of(parent2);

		child = zeros(1, 2);

		if randi(2) == 1
			child(1) = x1;
		else
			child(1) = y1;
		end

		if randi(2) == 1
			child(2) = x2;
		else
			child(2) = y2;
		end

		xc = child(1);
		yc = child(2);
		location = sub2ind(size(city), xc, yc);

		%fprintf('%d %d\n', city(child(1), child(2)), city(location))

		children_ = [children_ location];
	end
	%children_
end

function new_population = mutate(children_, mutation_rate, parents, population, N)
	global city;
	
	new_population = [];
	population_size = length(population);
	N = N/2;

	for child = 1:length(children_)
		if rand(1) < mutation_rate
			[xc yc] = coord_of(children_(child));
			mutated = sub2ind(size(city), yc, xc);
			children_(child) = mutated;
		end
	end
	%children_
	%population( N+1:population_size )

	new_population = [children_ parents population( N+1:population_size )];

	cell_new_population = num2cell(new_population);

    % sort population cell array by fitness cost
    [~,sorted_fitnesses] = sort(cellfun(@(loc)cost_of(loc),cell_new_population));
    new_population = new_population(sorted_fitnesses);
    new_population = new_population(1:population_size);
    %new_population
end
