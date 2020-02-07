
function solver_dynamic(problem::Problem)
  cache = fill(Int32(-1), capacity(problem), itemcount(problem))
  
  cache_hits = 0
  cache_misses = 0

  function optimal_cached(k, j)
    if (k <= 0 || j <= 0)
      return 0
    end    

    result = cache[k,j]
    if result < 0
      result = optimal(k, j)
      cache[k,j] = result      
      cache_misses += 1
    else
      cache_hits += 1
    end
    result
  end
  
  function optimal(k, j)
    result = 0
    if (j > 0 && k > 0)
      w = itemweights(problem)[j]
      v = itemvalues(problem)[j]        
      if (k < w)
        result = optimal_cached(k, j-1)
      else
        result = max(optimal_cached(k, j-1), v + optimal_cached(k-w, j-1))
      end
    end
    return result
  end
  
  # Start 
  N = itemcount(problem)
  @time opt = optimal(capacity(problem), N)  

  # Determine selections  
  K = capacity(problem)
  selections = zeros(Int, N)  
  for i = reverse(1:N)
    if optimal_cached(K, i) == optimal_cached(K,i-1)
      # item was not included
    else
      # item was included 
      selections[i] = 1
      K = K - itemweights(problem)[i]
    end
  end

  SolverResult(selections, true)

end