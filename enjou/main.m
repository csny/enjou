//
//  main.m
//  enjou
//
//  Created by macbook on 2014/08/03.
//  Copyright (c) 2014年 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

unsigned long m;
unsigned int n;
unsigned int i,j;
unsigned int k,l;
unsigned long q[50], r[50];
bool s[50];
unsigned long t[50], u[50];
bool v[50];
unsigned long tmpnumber, tmpcost;
unsigned long mincost;

// 探索の関数
void corpcheck1(int j) {
    
    if(j > n-1) return; /* 全会社チェック終了 */
    tmpnumber += q[j];
    tmpcost += r[j];
    s[j]=YES;
    
    // 人月と予算チェック
    if(tmpnumber <= 200000){
        if(tmpnumber > m-1){
            if(mincost == 0) {
                mincost = tmpcost;
            }else if(tmpcost < mincost) {
                mincost = tmpcost;
            }
        }
        corpcheck1(j+1); /* i 番目の会社を残してチェック */
    }
    tmpnumber -= q[j];
    tmpcost -= r[j];
    s[j]=NO;
    corpcheck1(j+1); /* i 番目の会社を取り除いて次をチェック */
}

// 会社数が多い
void corpcheck2(int j) {
    
    if(j > n-1) return; /* 全会社チェック終了 */
    tmpnumber += t[j];
    tmpcost += u[j];
    v[j]=YES;
    
    // 人月と予算チェック
    if(tmpnumber <= 200000){
        if(tmpnumber > m-1){
            if(mincost == 0) {
                mincost = tmpcost;
            }else if(tmpcost < mincost) {
                mincost = tmpcost;
            }
        }
        corpcheck2(j+1); /* i 番目の会社を残してチェック */
    }
    tmpnumber -= t[j];
    tmpcost -= u[j];
    v[j]=NO;
    corpcheck2(j+1); /* i 番目の会社を取り除いて次をチェック */
}

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        // 入力
        scanf("%lu",&m);
        scanf("%u",&n);
        for (int i = 0; i < n; i++){
            scanf("%lu\n%lu", &q[i],&r[i]);
        }
        
        // 探索開始、会社数が多ければ適当にソート
        if (n > 20){
            k=0;
            l=n-1;
            for (int i = 0; i < n; i++){
                if (q[i] > m/2){
                    t[k]=q[i];
                    u[k]=r[i];
                    k++;
                }else{
                    t[l]=q[i];
                    u[l]=r[i];
                    l--;
                }
            }
            corpcheck2(0);
        } else {
            corpcheck1(0);
        }
        
        // 出力
        NSLog(@"%lu\n", mincost);
    }
    return 0;
}

