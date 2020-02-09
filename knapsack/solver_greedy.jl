
function solver_greedy(problem::Problem, scores)    
  @assert length(scores) == itemcount(problem)

  selections = falses(itemcount(problem))

  # Determine order sorted by score, largest to smallest
  sorted_order = sortperm(scores, rev=true)
  sorted_items = collect(1:itemcount(problem))[sorted_order]  
  
  # Select items with highest score, up to available capacity
  total_weight = 0  
  for item in sorted_items
    item_weight = itemweights(problem)[item]
    if (total_weight + item_weight) < capacity(problem)
      selections[item] = 1
      total_weight += item_weight
    end
  end

  return SolverResult(selections, false)
end

solver_greedydensity(problem::Problem) = solver_greedy(problem, itemvalues(problem) ./ itemweights(problem))
solver_greedyvalue(problem::Problem) = solver_greedy(problem, itemvalues(problem))
solver_greedyweight(problem::Problem) = solver_greedy(problem, -itemweights(problem))