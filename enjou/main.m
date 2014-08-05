//
//  main.m
//  enjou
//
//  Created by macbook on 2014/08/03.
//  Copyright (c) 2014年 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

long m; // 必要な人数
int n; // 会社数
//int i,j;
int q[50]; // 会社ごとの人数を入れる配列
long r[50]; // 会社ごとの発注費用を入れる配列
bool s[50]; // 会社ごとに使う使わないのフラグを入れる配列
int t[50];
long u[50];
bool v[50];
long costperman[50]; // 会社ごとの一人当たりの単価を入れる配列
long tmpnumber, tmpcost; // 人数とコストを加算していくための一時的な変数
long mincost; // 更新された最安値を入れる変数


// テスト用
int jchi;
int testnumber[50];
long testcost[50];
bool testflag[50];
const long answer = 14499;

// テスト用配列メモ
void arraymemo(int a[], long b[], bool c[], int jt){
    for (int i = 0; i < jt; i++){
        testnumber[i] = a[i];
        testcost[i] = b[i];
        testflag[i] = c[i];
    }
}


// 全探索
void corpcheck1(int j) {
    
    // j番目の会社情報を加算する前にチェック
    if(j > n-1) {return;} /* 全会社チェック終了 */
    if(tmpnumber >= m){return;} /* 枝落とし */
    
    tmpnumber += q[j];
    tmpcost += r[j];
    s[j]=YES;
    
    // 人月と予算チェック
    if(tmpnumber >= m){
        if(mincost == 0) {
            mincost = tmpcost;
        }else if(tmpcost < mincost) {
            mincost = tmpcost;
        }
    }
    
    corpcheck1(j+1); /* j番目の会社を残してチェック */
    
    tmpnumber -= q[j];
    tmpcost -= r[j];
    s[j]=NO;
    
    corpcheck1(j+1); /* j番目の会社を取り除いて次をチェック */
}

// ソート前提の探索
void corpcheck2(int j) {
    
    // j番目の会社情報を加算する前にチェック
    if(j > n-1) return; /* 全会社チェック終了 */
    if(tmpnumber >= m){return;} /* 枝落とし */
    
    tmpnumber += t[j];
    tmpcost += u[j];
    v[j]=YES;
    
    // 人月と予算チェック
    if(tmpnumber >= m){
        if(mincost == 0) {
            mincost = tmpcost;
        }else if(tmpcost < mincost) {
            mincost = tmpcost;
            //if (mincost == answer){
            //    jchi = j;
            //    arraymemo(t,u,v,j+1);
            //}
        }
    }
    
    corpcheck2(j+1); /* j番目の会社を残してチェック */
    
    // m値の4/5までひたすら加算して、それ以降全探索
    if(tmpnumber > m*4/5){
        tmpnumber -= t[j];
        tmpcost -= u[j];
        v[j]=NO;
        
        corpcheck2(j+1); /* j番目の会社を取り除いて次をチェック */
    }
}


// クックソート
/*
 * 軸要素の選択
 * 順に見て、最初に見つかった異なる2つの要素のうち、
 * 大きいほうの番号を返します。
 * 全部同じ要素の場合は -1 を返します。
 */
int pivot(long a[],int i,int j){
    int k=i+1;
    while(k<=j && a[i]==a[k]) k++;
    if(k>j) return -1;
    if(a[i]>=a[k]) return i;
    return k;
}

/*
 * パーティション分割
 * a[i]～a[j]の間で、x を軸として分割します。
 * x より小さい要素は前に、大きい要素はうしろに来ます。
 * 大きい要素の開始番号を返します。
 */
int partition(long a[], int b[], long c[], int i,int j,long x){
    int y=i,z=j;
    
    // 検索が交差するまで繰り返します
    while(y<=z){
        
        // 軸要素以上のデータを探します
        while(y<=j && a[y]<x)  y++;
        
        // 軸要素未満のデータを探します
        while(z>=i && a[z]>=x) z--;
        
        // 配列を入れ替えてる部分
        if(y>z) break;
        long fa=a[y];
        int fb=b[y];
        long fc=c[y];
        a[y]=a[z];
        b[y]=b[z];
        c[y]=c[z];
        a[z]=fa;
        b[z]=fb;
        c[z]=fc;
        y++; z--;
    }
    return y;
}

/*
 * クイックソート（再帰用）
 * 配列aの、a[i]からa[j]を並べ替えます。
 */
void quickSort(long a[],int b[],long c[],int i,int j){
    if(i==j) return;
    int p=pivot(a,i,j);
    if(p!=-1){
        int k=partition(a,b,c,i,j,a[p]);
        quickSort(a,b,c,i,k-1);
        quickSort(a,b,c,k,j);
    }
}


int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        // 入力
        scanf("%ld",&m);
        scanf("%d",&n);
        
        if(m > 200000 | m < 1 | n > 50 | n < 1) { // 制限を外すときは、配列の定義修正も忘れずに
            NSLog(@"m,n値を見直してください");
            return 0;
        }
        
        // 探索開始
        // 全探索版-会社数が少なければ全探索
        
        if(n<15){
            
            for (int i = 0; i < n; i++){
                scanf("%d\n%ld", &q[i],&r[i]);
            }
            //NSDate *startDate = [NSDate date]; // 使う場合、if-elseの枠から出さないとエラー吐く
            corpcheck1(0);
        }else{
        
        // ソートして深掘り版-会社数が多ければこっち
        
            for (int i = 0; i < n; i++){
                scanf("%d\n%ld", &t[i],&u[i]);
            }
            //NSDate *startDate = [NSDate date]; // 使う場合、if-elseの枠から出さないとエラー吐く
            for (int i = 0; i < n; i++){
                costperman[i]=u[i]/t[i];
            }
        //  人単価の安い順にクイックソート
            quickSort(costperman,t,u,0,n-1);
            //arraymemo(t,u,v,n);
            corpcheck2(0);
        }
    
        // 出力
        NSLog(@"%ld\n", mincost);
        // 計測時間出力
        //NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
        //NSLog(@"time is %lf (sec)", interval);
    
        // テスト出力
        //NSLog(@"jchi is %d. m,n is %ld,%d.", jchi,m,n);
        //NSLog(@"以下は配列(arraymemo)");
        //NSLog(@"使用フラグ 社員数 予算");
        //for (i =0;i<jchi+1;i++){
        //    NSLog(@"%d %d %ld", testflag[i],testnumber[i],testcost[i]);
        //}
        
    }
    return 0;
}

