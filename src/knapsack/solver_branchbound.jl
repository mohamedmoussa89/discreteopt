function solver_branch(problem::Problem)

  best_obj = typemin(Float)
  best_selection = Nothing

  stack = [Int[]]
  while length(stack) > 0

    selections = pop!(stack)
    i = length(selections)    

    if (i < problem.item_count)
      for status = 0:1
        push!(stack, vcat(selections, [status]))
      end
      

    else      
      obj = objective(problem, selections)
      total = totalweight(problem, selections)
      if (valid(problem, selections) && obj > best_obj)
        best_obj = obj
        best_selection = selections
      end
      
    end

  end

  return Solution(best_obj, true, best_selection)

end