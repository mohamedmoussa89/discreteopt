function solver_greedy(problem::Problem)
  # Choose items in order of (value / weight) density  
  items = sort([(v/w, i) for (i, (v, w)) in enumerate(zip(problem.values, problem.weights))], rev=true)

  return Result(0, 0, [])
end