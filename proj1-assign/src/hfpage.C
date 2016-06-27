/*

    *************** Implementation of the Heap file Page ***************
    Author: Jerry Xu;
    Number: 5130309056;
    Class:  Database --- 2016 Summer;
    Version:
        0.1     2016/6/24 09:00     Start Writing;
        0.2     2016/6/25 22:00     Finish;
        1.0     2016/6/27 13:00     Pass TA Test;

*/

#include <iostream>
#include <stdlib.h>
#include <memory.h>

#include "hfpage.h"
#include "heapfile.h"
#include "buf.h"
#include "db.h"

// **********************************************************
// page class constructor

void HFPage::init(PageId pageNo) {
    nextPage = prevPage = INVALID_PAGE;
    slotCnt = 0;
    curPage = pageNo;
    usedPtr = MAX_SPACE - DPFIXED;
    freeSpace = MAX_SPACE - DPFIXED + 4;
    slot[0].offset = slot[0].length = EMPTY_SLOT;
}

// **********************************************************
// dump page utlity
void HFPage::dumpPage() {
    int i;
    cout << "dumpPage, this: " << this << endl;
    cout << "curPage= " << curPage << ", nextPage=" << nextPage << endl;
    cout << "usedPtr=" << usedPtr << ",  freeSpace=" << freeSpace
         << ", slotCnt=" << slotCnt << endl;
    for (i=0; i < slotCnt; i++) {
        cout << "slot["<< i <<"].offset=" << slot[i].offset
             << ", slot["<< i << "].length=" << slot[i].length << endl;
    }
}

// **********************************************************
PageId HFPage::getPrevPage() {return prevPage;}

// **********************************************************
void HFPage::setPrevPage(PageId pageNo) {prevPage = pageNo;}
// **********************************************************
void HFPage::setNextPage(PageId pageNo) {nextPage = pageNo;}

// **********************************************************
PageId HFPage::getNextPage() {return nextPage;}

// **********************************************************
// Add a new record to the page. Returns OK if everything went OK
// otherwise, returns DONE if sufficient space does not exist
// RID of the new record is returned via rid parameter.
Status HFPage::insertRecord(char* recPtr, int recLen, RID& rid) {
    short sn = 0;
    while (sn<slotCnt && slot[sn].length!=EMPTY_SLOT) sn++;
    if (recLen>freeSpace) return DONE;
    if (sn == slotCnt) {
        if (recLen + 4>freeSpace) return DONE;
        slotCnt++;
        freeSpace -= sizeof(slot_t);
    }
    usedPtr -= recLen;
    freeSpace -= recLen;
    rid.pageNo = curPage;
    rid.slotNo = sn;
    slot[sn].length = recLen;
    slot[sn].offset = usedPtr;
    memmove(data + usedPtr, recPtr, recLen);
    //cout<<rid.slotNo<<' '<<slot[sn].offset<<' '<<slot[sn].length<<' '<<usedPtr<<' '<<freeSpace<<endl;
    return OK;
}

// **********************************************************
// Delete a record from a page. Returns OK if everything went okay.
// Compacts remaining records but leaves a hole in the slot array.
// Use memmove() rather than memcpy() as space may overlap.
Status HFPage::deleteRecord(const RID& rid) {
	short sn = rid.slotNo;
    if (rid.pageNo != curPage || sn >= slotCnt || sn < 0) return DONE;
    short len = slot[sn].length;
    short ost = slot[sn].offset;
    if (len == EMPTY_SLOT) return DONE;
    //cout<<rid.slotNo<<' '<<ost<<' '<<len<<' '<<usedPtr<<' '<<ost - usedPtr<<endl;
    if (ost != usedPtr)
	    memmove(data + usedPtr + len, data + usedPtr, ost - usedPtr);
    for (int i=0;i<slotCnt;i++) 
		if (slot[i].length!=EMPTY_SLOT && slot[i].offset<ost)
			slot[i].offset += len;
    slot[sn].length = slot[sn].offset = EMPTY_SLOT;
	while (slotCnt>0 && slot[slotCnt-1].length == EMPTY_SLOT){
		slotCnt --;
		freeSpace += 4;
	}
    freeSpace += len;
    usedPtr += len;
    return OK;
}

// **********************************************************
// returns RID of first record on page
Status HFPage::firstRecord(RID& firstRid) {
    short sn = 0;
    while (sn<slotCnt && slot[sn].length==EMPTY_SLOT) sn++;
    if (sn == slotCnt) return DONE;
    firstRid.pageNo = curPage;
    firstRid.slotNo = sn;
    return OK;
}

// **********************************************************
// returns RID of next record on the page
// returns DONE if no more records exist on the page; otherwise OK
Status HFPage::nextRecord (RID curRid, RID& nextRid) {
    short sn = curRid.slotNo + 1;
    if (sn == slotCnt) return DONE;
	if (curRid.pageNo != curPage || sn >= slotCnt || sn < 0) return FAIL;
    while (sn<slotCnt && slot[sn].length==EMPTY_SLOT) sn++;
    if (sn == slotCnt) return DONE;
    nextRid.pageNo = curPage;
    nextRid.slotNo = sn;
    return OK;
}

// **********************************************************
// returns length and copies out record with RID rid
Status HFPage::getRecord(RID rid, char* recPtr, int& recLen) {
    short sn = rid.slotNo;
    memmove(recPtr, data + slot[sn].offset, slot[sn].length);
    recLen = slot[sn].length;
    return OK;
}

// **********************************************************
// returns length and pointer to record with RID rid.  The difference
// between this and getRecord is that getRecord copies out the record
// into recPtr, while this function returns a pointer to the record
// in recPtr.
Status HFPage::returnRecord(RID rid, char*& recPtr, int& recLen) {
    short sn = rid.slotNo;
	if (rid.pageNo != curPage || sn >= slotCnt || sn < 0) return DONE;
    recPtr = data + slot[sn].offset;
    recLen = slot[sn].length;
	if (recLen == EMPTY_SLOT) return DONE;
    return OK;
}

// **********************************************************
// Returns the amount of available space on the heap file page
int HFPage::available_space(void) {
    return (freeSpace<(MAX_SPACE - DPFIXED)?freeSpace:(MAX_SPACE - DPFIXED));
}

// **********************************************************
// Returns 1 if the HFPage is empty, and 0 otherwise.
// It scans the slot directory looking for a non-empty slot.
bool HFPage::empty(void) {
    short sn = 0;
    while (sn<slotCnt && slot[sn].length==EMPTY_SLOT) sn++;
    if (sn == slotCnt) return 1;
    else return 0;
}
