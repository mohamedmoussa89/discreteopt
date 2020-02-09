#!/usr/bin/python
import os

def solve_it(input_data):    
    fh = open("input", 'w')
    for line in input_data:
      fh.write(line)
    fh.close()

    os.system(f"julia --quiet --project solver.jl input > output")

    result = []
    for line in open("output",'r'):
      result.append(line.strip())
    return "\n".join(result)


if __name__ == '__main__':
    import sys
    if len(sys.argv) > 1:
        file_location = sys.argv[1].strip()
        with open(file_location, 'r') as input_data_file:
            input_data = input_data_file.read()
        print(solve_it(input_data))
    else:
        print('This test requires an input file.  Please select one from the data directory. (i.e. python solver.py ./data/ks_4_0)')

