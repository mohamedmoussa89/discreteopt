module Knapsack

Float = Float64

struct Problem
  item_count::Int
  capacity::Int
  values::Array{Float, 1}
  weights::Array{Float ,1}
end

struct Result
  objective::Float
  is_optimal::Bool
  variables::Array{Int, 1}
end


include("solver_greedy.jl")
solve(problem::Problem) = solver_greedy(problem)
  

function parseinputfile(handle)
  parseint = x -> parse(Int, x)

  line = readline(handle)
  (n, K) = split(line) .|> parseint
  
  values = Float[]
  weights = Float[]
  for line in readlines(handle)
    (v, w) = split(line) .|> parseint
    push!(values, v)
    push!(weights, w)
  end

  Problem(n, K, values, weights)  
end


function main()
  ok = false

  if length(ARGS) == 1
    file_path = ARGS[1]
    if isfile(file_path)
      fh = open(file_path)
      problem = parseinputfile(fh)
      close(fh)
      if problem !== nothing 
        ok = true
        result = solve(problem)
        display(result)
      end
    end
  end

  if !ok

  end

end

main()

end