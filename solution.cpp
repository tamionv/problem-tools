#include <bits/stdc++.h>
using namespace std;

int main(){
    int a, b;
    cin >> a >> b;
    cout << a + b << endl;

#ifdef TESTING
    int maxval = atoi(getenv("maxval"));

    assert(a <= maxval);
    assert(b <= maxval);
#endif
    return 0;
}
