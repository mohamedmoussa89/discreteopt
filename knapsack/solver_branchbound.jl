function objective_upperbound(problem::Problem, selections, i)
  # Estimate an upper bound if we relax the integer constraint  
  # Keeps selecting remaining items, sorted by value density
  N = itemcount(problem)
  remaining_capacity = capacity(problem) - totalweight(problem, selections)
  upper_bound = objective(problem, selections)  

  rng = i:N  
  item_values = itemvalues(problem)[rng]
  item_weights = itemweights(problem)[rng]

  for (value, weight) in zip(item_values, item_weights)    
    take = min(remaining_capacity, weight)
    remaining_capacity -= take      
    upper_bound += (take / weight) * value
    if (remaining_capacity == 0)
      break
    end    
  end

  return upper_bound
end


struct Node
  item::Int
  selections::Array{Int8, 1}    
  objective::Int
  estimate::Float
end

Base.isless(a::Node, b::Node) = a.estimate < b.estimate

function solver_branchboundbest_search(problem::Problem)
  heap = BinaryMaxHeap{Node}()
  
  N = itemcount(problem)  
  push!(heap, Node(0, zeros(Int8, N), 0, 0))  
  best = top(heap)  

  while !isempty(heap)    
    node = pop!(heap)
    next_item = node.item + 1    

    if next_item <= itemcount(problem)
      for choice = 0:1        
        selections = copy(node.selections)
        selections[next_item] = choice        

        if validsolution(problem, selections)    
          next_node = Node(next_item, selections, 
                         objective(problem, selections), 
                         objective_upperbound(problem, selections, next_item+1)) 
          
          if next_node.estimate > best.objective            
            push!(heap, next_node)
            if next_node.objective > best.objective
              best = next_node
            end
          end     
        end             
      end  

    end

  end

  return SolverResult(best.selections, true)

end


function solver_branchbound(problem::Problem)
  # Order items in decreasing value density
  value_density = itemvalues(problem) ./ itemweights(problem)
  p = sortperm(value_density, rev=true)
  p_inv = invperm(p)
  
  problem_sorted = Problem(capacity(problem), itemvalues(problem)[p], itemweights(problem)[p])
  result = solver_branchboundbest_search(problem_sorted)

  return SolverResult(result.selections[p_inv], result.is_optimal)
end