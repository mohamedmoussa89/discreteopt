function solver_greedy(problem::Problem, scores)
  selections = zeros(Int, problem.item_count)

  # Sort items in order of criteria, largest to smallest
  sorted_order = sortperm(scores, rev=true)
  sorted_items = collect(1:problem.item_count)[sorted_order]  
  
  # Select items with highest score, up to available capacity
  total_weight = 0  
  for item in sorted_items
    item_weight = problem.weights[item]
    if (total_weight + item_weight) < problem.capacity
      selections[item] = 1
      total_weight += item_weight
    end
  end

  return Solution(objective(problem, selections), 0, selections)
end

solver_greedydensity(problem::Problem) = solver_greedy(problem, problem.values ./ problem.weights)
solver_greedyvalue(problem::Problem) = solver_greedy(problem, problem.values)
solver_greedyweight(problem::Problem) = solver_greedy(problem, -problem.weights )