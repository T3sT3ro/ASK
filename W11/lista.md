# Lista 11

1. translation:
    - _addr. translation_ - mechanism in MMU changing VA(virtual address) to PA(physical address)
    - _TLB_ - Translation Look-Aside Buffer - small cache for PGTBL(Page Table) entries
    ```none
                                16 lines
              4 sets           /         4 block/line
                    \         /         /
    addr      -TLBT- TLBI  -CI-       CO
    0x027c -> 000010  01   1111=(0xF) 00 -> MISS (VPN=0x09) -> PPN=0x17 => CACHE MISS => MEM
    0x03a9 -> 000011  10   1010=(0xA) 01 -> MISS (VPN=0x0E) -> PPN=0x11 => CACHE MISS => MEM
    0x0040 -> 000000  01   0000=(0x0) 00 -> MISS (VPN=0x01) -> PAGE MISS (major fault)
    ```

2. page table update:
    - TLB _fully associative_ - no index, just tag
    - LRU
    - page size = 4KiB = 2<sup>12</sup> bytes -> p = 12
    - _page table_ holds all entries for VA -> PA
    - _swap-in_ when PPN in PGTBL is 'disk' - appending page to PGTBL and mapping
    - _page frame_ is a continues memory block mapped by page
    - _page fault_: minor on TLB MISS, PGTBL HIT; major on PGTBL MISS, swap-in; invalid on swap-in invalid PPN

    `4669(0x123D):   0001 0010 0011 1101 -> TLBT=1   -> TLB MISS    => PGTBL MISS (major, swap-in)`  
        __PGTBL[1]__=`{1,13}` __TLB[0]__=`{1,1,4,13}`  
    `2227(0x8B3):    0000 1000 1011 0011 -> TLBT=0   -> TLB MISS    => PGTBL HIT (minor)`
                              __TLB[1]__=`{1,0,5,5}`  
    `13916(0x365C):  0011 0110 0101 1100 -> TLBT=3   -> TLB HIT`  
                              __TLB[2]__=`{1,3,6,6}`  
    `34587(0x871B):  1000 0111 0001 1011 -> TLBT=8   -> TLB MISS    => PGTBL MISS (major, swap-in)`  
        __PGTBL[8]__=`{1,14}` __TLB[3]__=`{1,8,7,14}`  
    `48870(0xBEE6):  1011 1110 1110 0110 -> TLBT=11  -> TLB MISS    => PGTBL HIT(minor)`  
                              __TLB[0]__=`{1,11,8,12}`  
    `12608(0x3140):  0011 0001 0100 0000 -> TLBT=3   -> TLB HIT`  
                              __TLB[2]__=`{1,3,9,6}`  
    `49225(0xC049):  1100 0000 0100 1001 -> TLBT=12  -> TLB MISS    => PGTBL MISS (invalid, seg. fault)`  
        __ERROR__

    | Valid? | Tag | LRU | PPN |
    | ------ | --- | --- | --- |
    |   1    |  11 |  8  |  12 |
    |   1    |  0  |  5  |  5  |
    |   1    |  3  |  9  |  6  |
    |   1    |  8  |  7  |  14 |

    | VPN | Valid? | PPN |
    |-----|--------|-----|
    | 0   |   1    |  5  |
    | 1   |   1    |  13 |
    | 2   |   0    | disk|
    | 3   |   1    |  6  |
    | 4   |   1    |  9  |
    | 5   |   1    |  11 |
    | 6   |   0    | disk|
    | 7   |   1    |  4  |
    | 8   |   1    |  14 |
    | 9   |   0    | disk|
    | 10  |   1    |  3  |
    | 11  |   1    |  12 |
    | 12  |   1    |  15 |

3. page table sizes:
    - 32-bit VA address
    - page size = 4KiB = 2<sup>12</sup>
    - PGTBL entry = 4 bytes
    - process using 1GiB = 2<sup>30</sup> address space
    1. 1 level PGTBL:  
        - pages = addresses/page size = 2<sup>32</sup>/2<sup>12</sup> = 2<sup>20</sup> pages
        - pages\*entry size = 2<sup>20</sup>\*4=4MB
    2. 2 level PGTBL, catalogue(outer table) with 1024=2^<sup>10</sup> entries
        - entries in 2 lvl PGTBL = 2<sup>20</sup>/2<sup>10</sup>=2<sup>10</sup>
        - 10 bits for catalogue, 10 bits for page table
        - best - sequential addresses usage - lvl2 tables = proces/pageSize/lvl2 table size = 2<sup>30</sup>/2<sup>12</sup>/2<sup>10</sup> = 2<sup>8</sup>  
          Size = entrySize\*(catalogue entries + 2nd lvl tables \* 2nd lvl entries) = 4B\*(2<sup>10</sup>+2<sup>8</sup>\*2<sup>10</sup>)=4KiB + 1MiB
        - pages needed = process address size / page size = 2<sup>30</sup>/2<sup>12</sup>=2<sup>18</sup>
        - worst - all 2nd level tables needed - 2^18 pages needed so all lvl 1 entries used:  
          Size = entrySize\*(catalogue + all 2nd lvl tables*entries per 2nd lvl table) = 4B\*(2<sup>10</sup>+2<sup>10</sup>\*2<sup>10</sup>)=4KiB + 4MiB

4. Clearing TLB:
    Switching context demands switching mapping function for virtual addresses. If TLB wasn't cleared, the TLB could potentially generate HIT! onto wrong PA. Clearing TLB is a simple method to generate compulsory misses for new PGTBL entries to load into TLB. Some architectures (ARM, MIPS) use address space identifiers for entries in TLB, so with hardware single TLB-entry removal they can save time needed to fill TLB with only missing entries on fast context switch (A-> short, small process B -> A).

5. Working set:
    - _Working set_ defines amount of memory that the process requires in given time interval
    - searching for _TLB reach_ - amount of memory accessible from the TLB = TLB size * page size
    - 4-way set associative TLB, 64 entries
    - _Huge page_ - as name implies, huge page... For calculations, huge page has 4MiB size instead of 4KiB
    - optimistic: full TLB use -> 4KiB\*64 entrues = 256 KiB
    - pessimistic: 5 pages of same set, constant swapping - working set is 4 entries -> 4KiB*4 = 16KiB
    - Huge pages are 10 times bigger, hence the range is 10 times wider

6. Page Table Entries:

    ```none
    |63|62__52|51____________________12|11___9|8|7_|6|5|4_|3_|2__|1__|0__|
    |XD|unused|PGTBL physical base addr|unused|G|PS|?|A|CD|WT|U/S|R/W|P=1| - PGTBL catalogue entries
    |XD|unused|PGTBL physical base addr|unused|G|? |D|A|CD|WT|U/S|R/W|P=1| - PGTBL entries
                \
                40 most significant bits force 4KiB alignment

    XD - execution disable
    G  - global page (don't evict from TLB)
    PS - huge page
    ?  - empty bit
    D  - dirty bit
    A  - reference bit, set by MMU on reads/writes, cleared by software
    CD - chaching enabled/disabled for child table
    WT - write-through or write-back cache policy for child page table
    U/S- user/supervisor(kernel) mode access perm. for all reachable pages
    R/W- read-only or read-write access perm for all reachable pages
    P  - child page table present in physical memory(valid)
    ```

    - cache usage flags: `WT`,`CD`
    - VM algorithms helpers: `P`,`A`,`PS`,`G`,`D`
    - permissions: `W/R`,`U/S`,`XD`

7. parallelizing VA->PA translation with VIPT:

    ``` none
    VA: |        VPN        |    VPO    |
     |  |         |         |     |     |
     V  | addr. translation | no change |
     |  |         |         |     |     |
    PA: |        PPN        |    PPO    |
        |         CT        |  CI | CO  |
    ```

    - physically indexed/tagged - index/tag read from physical address (after translation)
    - with bits determining CI in virtal and physical address cache indexing can take place while address translation occurs, and later the translated addresses tag is checked. Cache prepares set for tag comparison while TLB is translating address, doesn't wait for whole PPA to send request to cache like in physically indexed, physically taggerd (PIPT). No need to bother with homonyms and synonyms as in VIVT

8. VIVT, homonyms and synonyms (different processes, ):
    - homonym - same virtual address mapped onto different physical address
    - synonym - same physical address mapped by many virtual address
    - homonym problems: tag may not uniquely identify cache data, leading to wrong data reads in cache
    - homonym solutions:
        - tag VA with virtual space ID (ASID)
        - use physical tags (VIPT) instead
        - flush cache on context switching
    - synonyms problems:
        - various VA to same PA - frames shared between processes or multipple mappings of frame withing same address space
        - same data cached in several lines, on write only one synonym is updated, subsequent read on other synonym has old data
        - physical tagging and ASIDs don't help
    - synonyms solutions:
        - hardware synonyms detection
        - flush cache on context switch - doesn't help with same VASpace synonyms
        - synonyms detection and ensure of all read-only, or only one synonym mapped