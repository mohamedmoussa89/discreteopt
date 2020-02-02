function solver_dynamic(problem::Problem)
  cache = Dict{Tuple{Int, Int}, Int}()
  
  cache_hits = 0
  cache_misses = 0

  function optimal_cached(k, j)
    result = get(cache, (k,j), nothing)
    if result === nothing
      result = optimal(k, j)
      cache[(k, j)] = result
      cache_misses += 1
    else
      cache_hits += 1
    end
    result
  end
  
  function optimal(k, j)
    result = 0
    if (j > 0 && k > 0)
      w = problem.weights[j]
      v = problem.values[j]        
      if (k < w)
        result = optimal_cached(k, j-1)
      else
        result = max(optimal_cached(k, j-1), v + optimal_cached(k-w, j-1))
      end
    end
    return result
  end

  opt = optimal(problem.capacity, problem.item_count)
  Solution(opt, 0, [])

end