///////////////////////////////////////////////////////////////////////////////
/////////////  The Header File for the Buffer Manager /////////////////////////
///////////////////////////////////////////////////////////////////////////////

#ifndef BUF_H
#define BUF_H

#include "db.h"
#include "page.h"

#define NUMBUF 20   
// Default number of frames, artifically small number for ease of debugging.

#define HTSIZE 7
// Hash Table size
//You should define the necessary classes and data structures for the hash table, 
// and the queues for LSR, MRU, etc.

class HashTable {

    class node {
    public:
        PageId key;
        short value;
        node *next;
        node(PageId k, short v){key = k;value = v; next = NULL;};
    };
    node **hash;
public:
    HashTable ();
    ~HashTable();
    void put(PageId pid, short fid);
    short get(PageId pid);
    void remove(PageId pid);
    int HASH(int v){return ((233 * v + 666) % HTSIZE);}
};

/*******************ALL BELOW are purely local to buffer Manager********/

// You should create enums for internal errors in the buffer manager.
enum bufErrCodes  {BUFFERFULL, UNPINERROR, FREEERROR, FLUSHEMPTY};

class Replacer;

struct bufDiscribe {
    PageId pid;
    int cnt, pcp;
    bool dirty, hate;
    bufDiscribe(){pid=-1;cnt=pcp=0;dirty=false;hate=true;}
    void reset(PageId p){pid=p;cnt=1;pcp=0;dirty=false;hate=true;}
};

class BufMgr {

private:

    int numBuf;
    int *LRU, *MRU;
    short LRU_h, LRU_t, MRU_t, firstEmpty;
    bufDiscribe *bd;
    HashTable *table;

    short findReplacer();

    Status flushFrame(int frame);

    Status replacementChange(int frame, int pcp);
public:

    Page* bufPool; // The actual buffer pool

    BufMgr (int numbuf, Replacer *replacer = 0); 
    // Initializes a buffer manager managing "numbuf" buffers.
    // Disregard the "replacer" parameter for now. In the full 
    // implementation of minibase, it is a pointer to an object
    // representing one of several buffer pool replacement schemes.

    ~BufMgr();           // Flush all valid dirty pages to disk

    Status pinPage(PageId PageId_in_a_DB, Page*& page, int emptyPage=0);
        // Check if this page is in buffer pool, otherwise
        // find a frame for this page, read in and pin it.
        // also write out the old page if it's dirty before reading
        // if emptyPage==TRUE, then actually no read is done to bring
        // the page

    Status unpinPage(PageId globalPageId_in_a_DB, int dirty, int hate);
        // hate should be TRUE if the page is hated and FALSE otherwise
        // if pincount>0, decrement it and if it becomes zero,
        // put it in a group of replacement candidates.
        // if pincount=0 before this call, return error.

    Status newPage(PageId& firstPageId, Page*& firstpage, int howmany=1); 
        // call DB object to allocate a run of new pages and 
        // find a frame in the buffer pool for the first page
        // and pin it. If buffer is full, ask DB to deallocate 
        // all these pages and return error

    Status freePage(PageId globalPageId); 
        // user should call this method if it needs to delete a page
        // this routine will call DB to deallocate the page 

    Status flushPage(PageId pageid);
        // Used to flush a particular page of the buffer pool to disk
        // Should call the write_page method of the DB class

    Status flushAllPages();
    // Flush all pages of the buffer pool to disk, as per flushPage.

    /* DO NOT REMOVE THIS METHOD */    
    Status unpinPage(PageId globalPageId_in_a_DB, int dirty=FALSE)
        //for backward compatibility with the libraries
    {
      return unpinPage(globalPageId_in_a_DB, dirty, FALSE);
    }

    void print(int t);
};

#endif
