function solver_greedy(problem::Problem)
  selections = zeros(Int, problem.item_count)

  # Compute value/weight density for items
  density = problem.values ./ problem.weights

  # Sort items in order of density, largest to smallest  
  sorted_order = sortperm(density, rev=true)
  sorted_items = collect(1:problem.item_count)[sorted_order]
  
  total_weight = 0  
  for item in sorted_items
    item_weight = problem.weights[item]
    if (total_weight + item_weight) < problem.capacity
      selections[item] = 1
      total_weight += item_weight
    end
  end

  return Result(problem, 0, selections)
end