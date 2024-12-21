#include <stdio.h>
#include <string.h>
#include <ctype.h>

int isKeyword(char *str) {
    char k[32][10] = {"auto", "break", "case", "char", "const", "continue", "default", "do",
                      "double", "else", "enum", "extern", "float", "for", "goto", "if", "int", "long", "register",
                      "return", "short", "signed", "sizeof", "static", "struct", "switch", "typedef", "union",
                      "unsigned", "void", "volatile", "while"};
    int i;
    for (i = 0; i < 32; i++)
        if (strcmp(k[i], str) == 0)
            return 1;
    return 0;
}

int isFunction(char *str) {
    if (strcmp(str, "main") == 0 || strcmp(str, "printf") == 0)
        return 1;
    return 0;
}

int main() {
    int charCount, lineNo = 1, serialNo = 0;
    char fn[20], c, buf[30];
    FILE *fp;
    printf("\nEnter the file name:");
    scanf("%s", fn);
    printf("\n\nS.No         Token             Lexeme                  Line No");
    fp = fopen(fn, "r");
    while ((c = fgetc(fp)) != EOF) {
        if (isalpha(c)) {
            buf[charCount = 0] = c;
            while (isalnum(c = fgetc(fp))) {
                buf[++charCount] = c;
            }
            buf[++charCount] = '\0';
            if (isKeyword(buf))
                printf("\n%4d        keyword          %7s      %20d", ++serialNo, buf, lineNo);
            else if (isFunction(buf))
                printf("\n%4d        function         %7s      %20d", ++serialNo, buf, lineNo);
            else
                printf("\n%4d       identifier        %7s      %20d", ++serialNo, buf, lineNo);
        } else if (isdigit(c)) {
            buf[charCount = 0] = c;
            while (isdigit(c = fgetc(fp)))
                buf[++charCount] = c;
            buf[++charCount] = '\0';
            printf("\n%4d         number          %7s      %7d", ++serialNo, buf, lineNo);
        } else if (c == '(' || c == ')')
            printf("\n%4d       parenthesis         %6c                  %7d", ++serialNo, c, lineNo);
        else if (c == '{' || c == '}')
            printf("\n%4d         brace             %6c                  %7d", ++serialNo, c, lineNo);
        else if (c == '[' || c == ']')
            printf("\n%4d       array index         %6c                  %7d", ++serialNo, c, lineNo);
        else if (c == ',' || c == ';')
            printf("\n%4d       punctuation         %6c                  %7d", ++serialNo, c, lineNo);
        else if (c == '"') {
            charCount = -1;
            while ((c = fgetc(fp)) != '"')
                buf[++charCount] = c;
            buf[++charCount] = '\0';
            printf("\n%4d         string           %7s      %20d", ++serialNo, buf, lineNo);
        } else if (c == ' ')
            continue;
        else if (c == '\n')
            ++lineNo;
        else
            printf("\n%4d         operator          %6c                  %7d", ++serialNo, c, lineNo);
    }
    fclose(fp);
    return 0;
}