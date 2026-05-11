#include <stdio.h>

int main(void) {
    printf("%c\n",'%');
    // 能输出%的代码还有以下几种：
    printf("%%\n");//%%表示输出一个%，所以可以输出一个%。这是stdio.h库中printf()函数的一个特殊用法。
    putchar('%');// putchar()函数只能输出一个字符，所以只能输出一个%，如果要输出两个%，需要调用两次putchar()函数。
    printf("\n%s\n","%");
    return 0;
}