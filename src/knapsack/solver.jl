module Knapsack

using Pkg
Pkg.activate(".")

using LinearAlgebra
using PrettyTables
import Base.maximum

Float = Float64

struct Problem
  item_count::Int
  capacity::Int
  values::Array{Float, 1}
  weights::Array{Float ,1}
end

struct Solution
  objective::Float
  is_optimal::Bool
  selections::Array{Int, 1}
end

objective(problem::Problem, selections) = dot(problem.values, selections)
selecteditems(selections) = findall(selections .== 1)
maximum(solutions::AbstractArray{Solution}) = solutions[argmax([sol.objective for sol in solutions])]

include("solver_greedy.jl")

function readinputfile(file_path)
  problem = nothing
  
  open(file_path) do fh
    parseint = x -> parse(Int, x)
    line = readline(fh)
    (n, K) = split(line) .|> parseint   

    values = Float[]
    weights = Float[]
    for line in readlines(fh)
      (v, w) = split(line) .|> parseint
      push!(values, v)
      push!(weights, w)
    end

    problem = Problem(n, K, values, weights)
  end

  return problem
end

function main()
  # Get files from given argument
  # Arguments can either be a file or directory
  paths = []
  for arg in ARGS
    if isfile(arg)
      push!(paths, arg)      
    elseif isdir(arg)
      for item in readdir(arg)
        full_path = joinpath(arg, item)
        if isfile(full_path)
          push!(paths, full_path)
        end
      end
    end
  end

  # Solve
  for file_path in paths
    println(file_path)
    
    problem = readinputfile(file_path)
    if (problem === nothing)
      println("Could not read input file")
      continue
    end

    results = [
      solver_greedydensity(problem), 
      solver_greedyvalue(problem), 
      solver_greedyweight(problem)
    ]

    solver_types = ["Greedy (D)", "Greedy (V)", "Greedy (W)"]

    headers = ["Solver", "Objective"]
    objectives = [result.objective for result in results]    
    data = hcat(solver_types, objectives)
    best = argmax(objectives)
    pretty_table(data, headers)
    println("Best is $(solver_types[best])")
    println()
  end

end

main()

end