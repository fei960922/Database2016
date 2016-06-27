/*

    *************** Implementation of the Buffer Manager Layer ***************
    Author: Jerry Xu;
    Number: 5130309056;
    Class:  Database --- 2016 Summer;
    Version:
        0.1     2016/6/25 09:00     Start Writing;
        0.2     2016/6/26 22:00     Finish;
        1.0     2016/6/27 13:00     Pass TA Test;

*/

#include "buf.h"

// Define error message here
static const char* bufErrMsgs[] = { 
    "[ERROR] The buffer is full!",
    "[ERROR] Unpinning an non-exist page!",
    "[ERROR] Free the non-empty page!"
    "[ERROR] Flushing an empty page!"
};
// Create a static "error_string_table" object and register the error messages
// with minibase system 
static error_string_table bufTable(BUFMGR,bufErrMsgs);

BufMgr::BufMgr (int numbuf, Replacer *replacer) {
    numBuf = numbuf;
    LRU = new int[numbuf];
    MRU = new int[numbuf];
    LRU_h = LRU_t = MRU_t = firstEmpty = 0;
    bd = new bufDiscribe[numbuf];
    for (int i=0;i<numbuf;i++)
        LRU[i] = MRU[i] = -1;
    bufPool = new Page[numbuf];
    table = new HashTable();
}

Status BufMgr::pinPage(PageId PageId_in_a_DB, Page*& page, int emptyPage) {
    int frame = table->get(PageId_in_a_DB);
    if (frame==-1) {
        frame = findReplacer();
        if (frame==-1) return MINIBASE_FIRST_ERROR(BUFMGR,BUFFERFULL);
        Status st = MINIBASE_DB->read_page(PageId_in_a_DB, &(bufPool[frame]));
        if (st != OK) return MINIBASE_CHAIN_ERROR(BUFMGR, st);
        bd[frame].reset(PageId_in_a_DB);
        table->put(PageId_in_a_DB, frame);
    } else {
        if (bd[frame].cnt==0) replacementChange(frame, 0);
        bd[frame].cnt++;
    }
    page = &(bufPool[frame]);
    //cout<<"PIN "<<PageId_in_a_DB<<" -> "<<frame<<"\n ";print(2);
    return OK;
}

Status BufMgr::newPage(PageId& firstPageId, Page*& firstpage, int howmany) {
    Status st = MINIBASE_DB->allocate_page(firstPageId, howmany);
    if (st != OK) return MINIBASE_CHAIN_ERROR(BUFMGR, st);
    st = pinPage(firstPageId, firstpage, 1);
    if (st != OK) {
        MINIBASE_DB->deallocate_page(firstPageId, howmany);
        return st;
    }
    return OK;
}

Status BufMgr::flushPage(PageId pageid) {
    return flushFrame(table->get(pageid));
}

BufMgr::~BufMgr(){
    flushAllPages();
    delete[] LRU;
    delete[] MRU;
    delete[] bd;
    delete table;
    delete[] bufPool;
}

Status BufMgr::unpinPage(PageId globalPageId_in_a_DB, int dirty=FALSE, int hate = FALSE){
    int frame = table->get(globalPageId_in_a_DB);
    if (frame == -1 || bd[frame].cnt == 0) return MINIBASE_FIRST_ERROR(BUFMGR,UNPINERROR);
    bd[frame].cnt -= 1;
    bd[frame].dirty = bd[frame].dirty || dirty;
    bd[frame].hate = bd[frame].hate && hate;
    if (bd[frame].cnt==0)
        replacementChange(frame, 2-bd[frame].hate);
    //cout<<"UNPIN "<<globalPageId_in_a_DB<<" -> "<<frame<<" "<<hate<<"\n ";print(3);
    return OK;
}

Status BufMgr::freePage(PageId globalPageId){
    int frame = table->get(globalPageId);
    if (frame==-1 || bd[frame].cnt>0) return MINIBASE_FIRST_ERROR(BUFMGR,FREEERROR);
    Status st = MINIBASE_DB->deallocate_page(globalPageId, 1);
    if (st != OK) return MINIBASE_CHAIN_ERROR(BUFMGR, st);
    replacementChange(frame, 0);
    table->remove(bd[frame].pid);
    bd[frame].pid = -1;
    //cout<<"freePage:"<<globalPageId<<' '<<frame<<endl;
    if (firstEmpty>frame) firstEmpty = frame;
    return OK;
}

Status BufMgr::flushAllPages(){
    for (int i=0;i<numBuf;i++) flushFrame(i);
    return OK; 
}

short BufMgr::findReplacer() {
    int frame;
    if (firstEmpty<numBuf) {
        frame = firstEmpty;
        firstEmpty++;
        while (firstEmpty<numBuf && bd[firstEmpty].pid!=-1)
            firstEmpty++;
        return frame;
    }
    if (MRU_t > 0) frame = MRU[MRU_t - 1];
    else if (LRU_t > 0) frame = LRU[0]; 
    else return -1;
    if (bd[frame].dirty)
        MINIBASE_DB->write_page(bd[frame].pid, &(bufPool[frame]));
    replacementChange(frame, 0);
    table->remove(bd[frame].pid);
    return frame;
}

Status BufMgr::flushFrame(int frame) {
    if (frame == -1) return MINIBASE_FIRST_ERROR(BUFMGR, FLUSHEMPTY);
    if (bd[frame].pid==-1) 
        return OK;
    if (bd[frame].dirty) {
        MINIBASE_DB->write_page(bd[frame].pid, &(bufPool[frame]));
        bd[frame].dirty = false;
    }
    return OK;
}

Status BufMgr::replacementChange(int frame, int pcp){
    int ocp = bd[frame].pcp;
    if (ocp==1) {
        int t = MRU_t;
        while (MRU[t]!=frame && t>0) t--;
        for (int i=t;i<MRU_t-1;i++)
            swap(MRU[i], MRU[i+1]);
        MRU_t--;
    } else if (ocp==2) {
        int t = 0;
        while (LRU[t]!=frame && t<LRU_t-1) t++;
        for (int i=t;i<LRU_t-1;i++)
            swap(LRU[i], LRU[i+1]);
        LRU_t--;
    }
    if (pcp==1) {
        MRU[MRU_t] = frame;
        MRU_t++;
    } else if (pcp==2) {
        LRU[LRU_t] = frame;
        LRU_t++;
    }
    bd[frame].pcp = pcp;
    return OK;
}

HashTable::HashTable() {
    hash = new node*[HTSIZE];
    for (int i=0;i<HTSIZE;i++) hash[i] = NULL;
}
HashTable::~HashTable() {   
    node *t;
    for (int i=0;i<HTSIZE;i++)
        for (node *n=hash[i];n!=NULL;t=n->next,delete n,n=t);
        delete[] hash;
}
void HashTable::put(PageId key, short value) {
    node *n;
    for (n=hash[HASH(key)]; n!=NULL && n->next!=NULL && n->key!=key; n = n->next);
    if (n==NULL) hash[HASH(key)] = new node(key, value);
    else if (n->key==key) n->value = value;
    else n->next = new node(key, value);
}
short HashTable::get(PageId key) {
    node *n;
    for (n=hash[HASH(key)]; n!=NULL && n->key!=key; n = n->next);
    if (n==NULL) return -1;
    else return n->value;
}
void HashTable::remove(PageId key) {
    node *n = hash[HASH(key)];
    if (n != NULL && n->key == key) {
        hash[HASH(key)] = n->next;
        delete n;
    }
    for (; n!=NULL && n->next!=NULL && n->next->key!=key; n = n->next);
    if (n == NULL || n->next == NULL) return;
    if (n->next->key==key) {
        node *t = n->next->next;
        delete n->next;
        n->next = t;
    }
}

void BufMgr::print(int t) {
    cout<<t<<"  *Buffer size:"<<numBuf<<"*  firstEmpty:"<<firstEmpty<<endl;
    cout<<"pid: ";
    for (int i=0;i<numBuf;i++) cout<<bd[i].pid<<' ';
    cout<<endl;cout<<"cnt: ";
    for (int i=0;i<numBuf;i++) cout<<bd[i].cnt<<' ';
    cout<<endl;cout<<"pcp: ";
    for (int i=0;i<numBuf;i++) cout<<bd[i].pcp<<' ';
    cout<<endl;cout<<"dty: ";
    for (int i=0;i<numBuf;i++) cout<<bd[i].dirty<<' ';
    cout<<endl;cout<<"hte: ";
    for (int i=0;i<numBuf;i++) cout<<bd[i].hate<<' ';
    cout<<endl;cout<<"MRU: ";
    for (int i=0;i<MRU_t;i++)
        cout<<MRU[i]<<' ';
    cout<<endl;cout<<"LRU: ";
    for (int i=0;i<LRU_t;i++)
        cout<<LRU[i]<<' ';
    cout<<endl;cout<<"Hash:";
    for (int i=0;i<=30;i++) cout<<table->get(i)<<' ';
    cout<<endl;
}