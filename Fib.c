#include <stdio.h>
#include <time.h>
int recursFib(int n)
{
	if (n > 25)
	{
		return -1;
	}
	if (n < 2)
	{
		return n;
	}
	return recursFib(n - 1) + recursFib(n - 2);
}

int iterateFib(int n)
{
	if (n > 46)
	{
		return -1;
	}
	int a = 0, b = 1, c;
	for (int i = 0; i < n; i++)
	{
		c = a;
		a = a + b;
		b = c;
	}
	return a;
}

int proRecursFib(int a, int b, int n)
{
	if (n > 46)
	{
		return -1;
	}
	if (n >= 1)
	{
		return proRecursFib(a + b, a, n - 1);
	}
	return a;
}

void main()
{
	iterateFib(10);
	recursFib(10);
	proRecursFib(0, 1, 10);
}
// printf("F(40)=:\n");
// time_t start, end;
// start = clock();
// printf("递推: %lld ", ddFib(a));
// end = clock();
// printf("time=%d\n", end - start);

// start = clock();
// printf("普通递归：%lld ", Fib(a));
// end = clock();
// printf("time=%d\n", end - start);

// start = clock();
// printf("优化递归: %lld ", newFib(0, 1, a));
// end = clock();
// printf("time=%d\n", end - start);

// a = 10000;
// printf("F(1000)=:\n");
// start = clock();
// printf("递推: %lld ", ddFib(a));
// end = clock();
// printf("time=%d\n", end - start);

// // start = clock();
// // printf("普通递归：%lld ", Fib(a));
// // end = clock();
// // printf("time=%d\n", end - start);

// start = clock();
// printf("优化递归: %lld ", newFib(0, 1, a));
// end = clock();
// printf("time=%d\n", end - start);
