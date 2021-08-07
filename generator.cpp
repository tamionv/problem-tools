#include <bits/stdc++.h>
using namespace std;

int main() {
    int seed = atoi(getenv("testid")) + 12341, maxval = atoi(getenv("maxval"));

    mt19937 mt(seed);

    cout << uniform_int_distribution<int>(1, maxval)(mt) << ' '
         << uniform_int_distribution<int>(1, maxval)(mt);

    return 0;
}
