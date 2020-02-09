module Knapsack

#using Pkg
#Pkg.activate(".")

using LinearAlgebra
using DataStructures
using PrettyTables
import Base.maximum

Float = Float64

struct Problem
  capacity::Int
  values::Array{Int, 1}
  weights::Array{Int ,1}
end

capacity(problem::Problem) = problem.capacity
itemcount(problem::Problem) = length(problem.values)
itemvalues(problem::Problem) = problem.values
itemweights(problem::Problem) = problem.weights

objective(problem::Problem, selections) = dot(problem.values, selections)
totalweight(problem::Problem, selections) = dot(problem.weights, selections)
validsolution(problem::Problem, selections) = totalweight(problem, selections) <= capacity(problem)

selecteditems(selections) = findall(selections .== 1)

struct SolverResult
  selections::BitArray{1}
  is_optimal::Bool
end

include("solver_greedy.jl")
include("solver_dynamic.jl")
include("solver_branchbound.jl")

function readinputfile(file_path)
  problem = nothing
  
  open(file_path) do fh
    parseint = x -> parse(Int, x)
    line = readline(fh)
    (n, K) = split(line) .|> parseint   

    values = Float[]
    weights = Float[]
    for i in 1:n
      line = readline(fh)    
      (v, w) = split(line) .|> parseint
      push!(values, v)
      push!(weights, w)
    end

    problem = Problem(K, values, weights)
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

  #root = "./data/knapsack/"
  #paths = readdir(root)
  #paths = [joinpath(root, p) for p in paths]

  #paths = ["./data/knapsack/ks_1000_0"]

  # Solve
  for file_path in paths    
   
    problem = readinputfile(file_path)
    if (problem === nothing)
      println("Could not read input file")
      continue
    end

    # results = [
    #   solver_greedydensity(problem), 
    #   solver_greedyvalue(problem), 
    #   solver_greedyweight(problem), 
    #   solver_branchbound(problem),
    # ]

    # solver_types = ["Greedy (D)", "Greedy (V)", "Greedy (W)", "Branch"]    
    # headers = ["Solver", "Objective", "Valid"]
    # selections = [result.selections for result in results]    
    # objectives = [objective(problem, sel) for sel in selections]
    # checks = [totalweight(problem, sel) <= capacity(problem) for sel in selections]
    # order = sortperm(objectives, rev=true)
    # data = hcat(solver_types[order], objectives[order], checks[order])
    # best = argmax(objectives)
    # pretty_table(data, headers)    

    result = solver_branchbound(problem)    
    obj = objective(problem, result.selections)
    is_opt = result.is_optimal ? 1 : 0
    selections = join([s ? 1 : 0 for s in result.selections], " ")
    println("$(obj) $(is_opt)")    
    println(selections)

  end

end

main()

end