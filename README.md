# problem-tools
Tools for making computer science olympiad problems.

The basic idea of this script is to be as unintrusive as possible; they basically automate a workflow I had already, removing the annoying parts. In general generators and solutions are given information through environment variables rather than parameters -- this is because this method makes it harder to give parameters "in the wrong order". The script needs three things:

* a `make`-able generator (usually will be a generator.cpp, which `make` already knows how to compile; however any type of generator can be used, as long as a proper makefile is created).
* a `make`-able solution (as above).
* a `subtasks.csv` file.

Examples of these can be found in the repository. The `subtasks.csv` file instructs the script on how subtasks are set. The first row is a header, and the following rows each correspond to a subtask. The header must contain a field named `#`, and can contain various other fields, which represent parameters to be transmitted to the generator. Each subsequent row, corresponding to a subtask, will generate the subtask according to the corresponding fields, and create as many tests as indicated in the field corresponding to `#`. For instance:
```
#,n,k
5,100,100
5,1000,1000
```
will generate 5 tests with `n=100`, `k=100`, and 5 tests with `n=1000`, `k=1000`. These are transmitted to the generator using environment variables viz: `n=1000 k=1000 ./generator`.

These are not the only environment variables transmitted to the generator. Three further variables are given:

* `taskid`, which tells the generator for which subtask it is generating (i.e. 1 for the first row, 2 for the second, etc.).
* `testid`, which tells the generator which test it is generating overall.
* `intaskid`, which tells the generator which test it is generating in the current subtask (i.e. 1 for the first test in the subtask, 2 for the second, etc.).

These are given to the generator because such information has proved useful in the past. Being told the task id may sometimes be needed as an "override" for certain specially generated subtasks. Being told the test number is useful to get a random seed. Being told the test index in the task may help to automatically vary the parameters of the test (e.g. the first test should have k = n, the second k = n / 2, the third k = n / 3, etc.).

Furthermore, when the solution is run, it is also told all the same information as the generator. This is crucial: it allows the solution to run assertions on the test cases. For instance, by getting the value of n for the subtask, it can just check if the values of n in the tests are appropriate. Of course when run on an online judge, the solution will not receive these environment variables. In order to make running assertions more easy (in C/C++), the generator and solution are compiled such that a `TESTING` macro is defined. Thus the following works as a `solution.cpp` file:

```
#include <bits/stdc++.h>
using namespace std;

int main(){
    int n; // suppose the input file consists of one n.
    cin >> n;

#ifdef TESTING
    int n_max = atoi(getenv("n"));
    assert(n <= n_max);
#endif

    return 0;
}
```

# What is contained in this repository

* The `maketests.sh` script.
* A minimal example (`generator.cpp`, `solution.cpp`, `subtasks.csv`), generating tests for a problem where we are asked to sum two integers.
* The README and LICENSE
