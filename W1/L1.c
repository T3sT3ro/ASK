//
// Created by Tooster on 25.02.2018.
//

#include "stdlib.h"
#include "stdint-gcc.h"
uint32_t z1(uint32_t x, uint32_t k, uint32_t i){
    x = (x&(~(1<<k))) | (((x>>i)&1)<<k);
    return x;
}

uint32_t z2(uint32_t x){
    uint32_t c = (x&0x55555555) + (x&(0x55555555<<1));
    c = (x&0x33333333) + (x&(0x33333333<<1));
    c = (x&0x0f0f0f0f) + (x&(0x0f0f0f0f<<1));
    c = (x&0x00ff00ff) + (x&(0x00ff00ff<<1));
    c = (x&0x0000ffff) + (x&(0x0000ffff<<1));
    return c;
}

void secret(uint8_t *to, uint8_t *from, size_t count) {
    static void *array[8] = {&&_0, &&_1, &&_2, &&_3, &&_4, &&_5, &&_6, &&_7};

    size_t n = (count + 7) / 8;
    goto *array[count%8];
    wh_loop:
    _0: *to++ = *from++;
    _7: *to++ = *from++;
    _6:*to++ = *from++;
    _5:*to++ = *from++;
    _4:*to++ = *from++;
    _3:*to++ = *from++;
    _2:*to++ = *from++;
    _1:*to++ = *from++;
    if(--n > 0) goto wh_loop;

}


int main() {

    uint8_t t1[] = {1,2,3,4,5,6,7,8,9,10,11,12,13};
    uint8_t t2[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

    secret(t2+3, t1+5, 4);
    return 0;

}
