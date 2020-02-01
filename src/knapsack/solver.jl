module Knapsack

using LinearAlgebra

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
  selections::Array{Int, 1}
  Result(problem, is_optimal, selections) = new(objective(problem, selections), is_optimal, selections)
end


objective(problem::Problem, selections) = dot(problem.values, selections)


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
        println(result)
      end
    else
      println(stderr, "Could not locate input file.")
    end
  end

  if !ok

  end

end

main()

end