#include <stdio.h>
#include <ctype.h>
#include <string.h>

void followfirst(char c, int idx, int prodIdx);
void follow(char c);
void findfirst(char c, int prodIdx, int ruleIdx);

int count = 8, m = 0, n = 0;
char calc_first[10][100], calc_follow[10][100], production[10][10];
char f[10], first[10];
int done[10], donee[10];

int main() {
    strcpy(production[0], "E=TR");
    strcpy(production[1], "R=+TR");
    strcpy(production[2], "R=#");
    strcpy(production[3], "T=FY");
    strcpy(production[4], "Y=*FY");
    strcpy(production[5], "Y=#");
    strcpy(production[6], "F=(E)");
    strcpy(production[7], "F=i");

    for (int k = 0; k < count; k++) {
        for (int kay = 0; kay < 100; kay++) {
            calc_first[k][kay] = calc_follow[k][kay] = '!';  
        }
    }

    int ptr = -1;
    for (int k = 0; k < count; k++) {
        char c = production[k][0];
        int alreadyProcessed = 0;
        for (int kay = 0; kay <= ptr; kay++) {
            if (c == done[kay]) {
                alreadyProcessed = 1;
                break;
            }
        }
        if (alreadyProcessed) continue;

        findfirst(c, 0, 0);
        done[++ptr] = c;
        printf("\n First(%c) = { ", c);
        calc_first[ptr][0] = c;
        for (int i = 0; i < n; i++) {
            int duplicate = 0;
            for (int lark = 0; lark < ptr; lark++) {
                if (first[i] == calc_first[ptr][lark]) {
                    duplicate = 1;
                    break;
                }
            }
            if (!duplicate) {
                printf("%c, ", first[i]);
                calc_first[ptr][ptr++] = first[i];
            }
        }
        printf("}\n");
    }

    printf("\n-----------------------------------------------\n\n");
    ptr = -1;
    for (int e = 0; e < count; e++) {
        char ck = production[e][0];
        int alreadyProcessed = 0;
        for (int kay = 0; kay <= ptr; kay++) {
            if (ck == donee[kay]) {
                alreadyProcessed = 1;
                break;
            }
        }
        if (alreadyProcessed) continue;

        follow(ck);
        donee[++ptr] = ck;
        printf(" Follow(%c) = { ", ck);
        calc_follow[ptr][0] = ck;
        for (int i = 0; i < m; i++) {
            int duplicate = 0;
            for (int lark = 0; lark < ptr; lark++) {
                if (f[i] == calc_follow[ptr][lark]) {
                    duplicate = 1;
                    break;
                }
            }
            if (!duplicate) {
                printf("%c, ", f[i]);
                calc_follow[ptr][ptr++] = f[i];
            }
        }
        printf(" }\n\n");
    }

    return 0;
}

void follow(char c) {
    if (production[0][0] == c) {
        f[m++] = '$';
    }
    for (int i = 0; i < count; i++) {
        for (int j = 2; j < 10; j++) {
            if (production[i][j] == c) {
                if (production[i][j + 1] != '\0') {
                    followfirst(production[i][j + 1], i, j + 2);
                }
                if (production[i][j + 1] == '\0' && c != production[i][0]) {
                    follow(production[i][0]);
                }
            }
        }
    }
}

void findfirst(char c, int prodIdx, int ruleIdx) {
    if (!isupper(c)) {
        first[n++] = c;
    }
    for (int j = 0; j < count; j++) {
        if (production[j][0] == c) {
            if (production[j][2] == '#') {
                if (production[prodIdx][ruleIdx] == '\0')
                    first[n++] = '#';
                else if (production[prodIdx][ruleIdx] != '\0' && (prodIdx != 0 || ruleIdx != 0)) {
                    findfirst(production[prodIdx][ruleIdx], prodIdx, ruleIdx + 1);
                } else {
                    first[n++] = '#';
                }
            }
            else if (!isupper(production[j][2])) {
                first[n++] = production[j][2];
            } else {
                findfirst(production[j][2], j, 3);
            }
        }
    }
}

void followfirst(char c, int prodIdx, int ruleIdx) {
    if (!isupper(c)) {
        f[m++] = c;
    } else {
        int i = 0, j = 1;
        while (calc_first[i][j] != '!') {
            if (calc_first[i][j] != '#') {
                f[m++] = calc_first[i][j];
            } else {
                if (production[prodIdx][ruleIdx] == '\0') {
                    follow(production[prodIdx][0]);
                } else {
                    followfirst(production[prodIdx][ruleIdx], prodIdx, ruleIdx + 1);
                }
            }
            j++;
        }
    }
}