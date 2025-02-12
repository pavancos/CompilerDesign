#include <stdio.h>
#include <string.h>

char input[20];
int len, ln = 0, err = 0;

void E();
void E1();
void T();
void T1();
void F();
void match(char topChar);

void E()
{
    T();
    E1();
}

void E1()
{
    if (input[0] == '+')
    {
        match('+');
        T();
        E1();
    }
    else
    {
        return;
    }
}

void T()
{
    F();
    T1();
}

void T1()
{
    if (input[0] == '*')
    {
        match('*');
        F();
        T1();
    }
    else
    {
        return;
    }
}

void F()
{
    if (input[0] == '(')
    {
        match('(');
        E();
        match(')');
    }
    else
    {
        match('i');
    }
}

void match(char topChar)
{
    if (input[0] == topChar)
    {
        printf("\n%s popped %c", input, topChar);
        ln++;
        memmove(input, input + 1, strlen(input));
    }
    else
    {
        printf("\nError: '%c' was expected but found '%c'", topChar, input[0]);
        err++;
    }
}

int main()
{
    printf("Enter the Input: ");
    fgets(input, sizeof(input), stdin);
    input[strcspn(input, "\n")] = '\0';

    len = strlen(input);
    input[len] = '$';
    input[len + 1] = '\0';

    E();

    if (err == 0 && ln == len)
    {
        printf("\n\nString parsed successfully!!!");
    }
    else
    {
        printf("\n\nString is not parsed successfully\nErrors occurred or Input contains invalid characters\n\n");
    }
    return 0;
}
