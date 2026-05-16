#include <stdio.h>

void increment1(int x)
{
    x = x+1;
}

void increment2(int x)
{
    x = x+1;
    //这里如果你要加return x;会报错，因为函数声明为void类型，不能返回值。
    // return x;
}

int increment3(int x)
{
    x = x+1;
    return x;
}

int main(void)
{
    int i  = 1, j = 2;
    increment1(i);
    increment1(j);
    printf("%d,%d\n",i,j);
    //i和j的值没有改变。
    //因为increment1函数首先没有返回值（void）
    //其次函数参数x是increment1函数的局部变量，调用函数时会将i和j的值复制给x。
    //函数内对x的修改不会影响i和j的值。

    increment2(i);
    increment2(j);
    printf("%d,%d\n",i,j);
    //同理，即使increment2函数中有return语句，但由于函数声明为void，无法返回值
    //因此i和j的值仍然没有改变。

    // i = increment2(i);
    // j = increment2(j);
    // printf("%d,%d\n",i,j);
    //即使你增加了对i和j的重新赋值，这么写会报错
    //因为increment2函数没有返回值（void)，不能赋值给i和j

    increment3(i);
    increment3(j);
    i = increment3(i);
    j = increment3(j);
    printf("%d,%d\n",i,j);
    //increment3函数才能实现对i和j进行加1的操作
    //因为increment3函数声明为int类型，能够返回一个整数值
    //函数内对x的修改后返回了新的值，调用函数时将返回值赋给i和j，成功实现了对i和j的修改。
    return 0;

}