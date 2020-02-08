function upperbound_integer(problem::Problem, selections, i)
  # Check maximum value if we relax the integer constraint
  # 1) Sort remaining items by value density (this is already done)
  # 2) Choose top items until capacity filled (allowing taking of partial items)
  N = itemcount(problem)

  remaining_capacity = capacity(problem) - totalweight(problem, selections)
  upper_bound = objective(problem, selections)
  for item = i+1:N
    item_weight = itemweights(problem)[item]
    item_value = itemvalues(problem)[item]
    take = min(remaining_capacity, item_weight)
    remaining_capacity -= take  
    upper_bound += convert(Int, ceil((take / item_weight) * item_value))
    if (remaining_capacity == 0)
      break
    end
  end

  return upper_bound
end

function solver_branchbound_search(problem::Problem)
  N = itemcount(problem)

  best_obj = 0
  best_selections = Array{Int8}(undef, N)

  # Preallocate and initialise selections stack  
  selections = Array{Int8}(undef, N)
  selections_stack = Array{Int8}(undef, N, N)
  selections_stack[:, 1] .= 0

  # Item currently being chosen
  item_stack = Array{Int32}(undef, N)  
  item_stack[1] = 0

  stack_pos = 1

  while stack_pos > 0
    i = item_stack[stack_pos]
    for j = 1:N
      selections[j] = selections_stack[j, stack_pos]
    end
    stack_pos -= 1

    # Check current selection satisfies the capacity constraint
    if !validsolution(problem, selections)      
      continue
    end    

    # Check maximum possible value if we relax the capacity or integer constraint
    if i < N
      upper_bound = upperbound_integer(problem, selections, i)
      if (upper_bound < best_obj)
        continue
      end
    end
    
    # Compute actual objective value
    obj = objective(problem, selections)
    if (obj > best_obj)
      best_obj = obj
      best_selections .= selections
    end

    # Possible choices for next variable
    if (i < N)
      stack_pos += 1
      item_stack[stack_pos] = i+1
      for j = 1:N
        selections_stack[j, stack_pos] = selections[j]
      end
      selections_stack[i+1, stack_pos] = 0

      stack_pos += 1
      item_stack[stack_pos] = i+1
      for j = 1:N
        selections_stack[j, stack_pos] = selections[j]
      end
      selections_stack[i+1, stack_pos] = 1
    end

  end

  return SolverResult(best_selections, true)

end

struct Node
  selections::Array{Int8, 1}
  estimate::Int
  objective::Int  
end

function solver_branchboundbest_search(problem::Problem)
  all_nodes = Set{Node}()  
  push!(all_nodes, Node([], 0, 0))

  while length(all_nodes) > 0

    # Grab next node
    node = next_node
    delete!()

    

  end

end


function solver_branchbound(problem::Problem)
  # Reorder items by value density (smallest first)
  value_density = itemvalues(problem) ./ itemweights(problem)  
  p = sortperm(value_density, rev=true)
  p_inv = invperm(p)

  problem_sorted = Problem(capacity(problem), itemvalues(problem)[p], itemweights(problem)[p])
  @time result = solver_branchbound_search(problem_sorted)
  
  return SolverResult(result.selections[p_inv], result.is_optimal)
end