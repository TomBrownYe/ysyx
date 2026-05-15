#include<stdio.h>

int main(void){
    int x,n;
    printf("Please input x and n:");
    scanf("%d %d",&x,&n);//键盘输入x和n
    printf("%d over %d is %d\n",x,n,(x+n-1)/n);//x除以n的Ceiling值
    printf("%d over %d is %d\n",x,n,(x%n ==0)?(x/n):(x/n+1));//另一种Ceiling值的实现方法
    return 0;
}