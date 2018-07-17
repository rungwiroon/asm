/*  Here are Michael Abrash's XMODE routines, converted to 32 bit
    protected mode, currently all tested for PMC extender.

    The only functions not yet tested are
        CopyScreenToScreenMaskedX
        CreateAlignedMaskedImageX  (2)

    Note that (2) uses memory allocation routines specified to PMC
    and hence won't link with BC/WC ...  But the ASM code is
    changeable and you can modify the allocation calls to
    whatever you need and reassemble.

    Also note that (2) was originally and someone compiled to asm
    using BCC32 for me.  I will include the C file, with the header
    for its use for anyone who needs them and prefers to make the
    changes to the C code.

    Note that I have added some palette functions, two in fact,
    and also modified the ShowPage to work with smooth vertical
    and horizontal scrolling.  In addition I moved some static data
    to global space to save a few bytes of space.

    In addition you must be using Tran's PMC/PMODE Dos Extender
    for these functions since I haven't converted them for
    DOS4GW yet.  I have not yet decided yet if I will or not
    and will make no promises towards this cause. :)

    Disclaimer: The conversion may not be the most optimal. Further
    I will not be responsible for any damaging consequences of using
    this, and I assume neither will Michael Abrash whose routines
    they were before the conversion process.

    This is released to FreeWare, and as such no cost is attached to
    product.  Please mention appropriate copyrights when using these
    routines and give credit to where it's due.

    (c) 1994 Kumanan Yogaratnam, all changes made.

    Note: If any of you out there is able to optimize this better,
    then please let me know at kyogarat@chat.carleton.ca where
    I will reside for atleast the next four years.
*/

/* MASKIM.H: structures used for storing and manipulating masked
   images */

/* Describes one alignment of a mask-image pair */

typedef struct {
   int ImageWidth; /* image width in addresses in display memory (also
                      mask width in bytes) */
   unsigned int ImagePtr; /* offset of image bitmap in display mem */
   char *MaskPtr;  /* pointer to mask bitmap */
} AlignedMaskedImage;

/* Describes all four alignments of a mask-image pair */

typedef struct {
   AlignedMaskedImage *Alignments[4]; /* ptrs to AlignedMaskedImage
                                      structs for four possible destination 
                                      image alignments */
} MaskedImage;


#pragma aux ReadPixelX "_*" parm caller []
#pragma aux FillPatternedX "_*" parm caller []
#pragma aux FillRectangleX "_*" parm caller []
#pragma aux CopySystemToScreenX "_*" parm caller []
#pragma aux CompySystemToScreenMaskedX "_*" parm caller []
#pragma aux CreateAlignedMaskedImage "_*" parm caller []
#pragma aux Set320x240Mode "_*" parm caller []
#pragma aux ResetModeX "_*" parm caller []
#pragma aux CopyScreenToScreenX "_*" parm caller []
#pragma aux CopyScreenToScreenMaskedX "_*" parm caller []
#pragma aux ShowPage "_*" parm caller []
#pragma aux WritePixel "_*" parm caller []
#pragma aux SetAllPalette "_*" parm caller []
#pragma aux SetIndexedPalette "_*" parm caller []

unsigned int ReadPixelX(int X, int Y, unsigned int PageBase);

void FillPatternedX(int StartX, int StartY, int EndX, int EndY,
   unsigned int PageBase, char* Pattern);

void FillRectangleX(int StartX, int StartY, int EndX, int EndY,
   unsigned int PageBase, int Color);

void CopySystemToScreenX(int SourceStartX, int SourceStartY,
   int SourceEndX, int SourceEndY, int DestStartX,
   int DestStartY, char* SourcePtr, unsigned int DestPageBase,
   int SourceBitmapWidth, int DestBitmapWidth);

void CopySystemToScreenMaskedX(int SourceStartX,
   int SourceStartY, int SourceEndX, int SourceEndY,
   int DestStartX, int DestStartY, char * SourcePtr,
   unsigned int DestPageBase, int SourceBitmapWidth,
   int DestBitmapWidth, char * MaskPtr);

unsigned int CreateAlignedMaskedImage(MaskedImage * ImageToSet,
   unsigned int DispMemStart, char * Image, int ImageWidth,
   int ImageHeight, char * Mask);

void Set320x240Mode(unsigned scrwidth);

void ResetModeX ();

unsigned int ReadPixelX(int X, int Y, unsigned int PageBase);

void CopyScreenToScreenX(int SourceStartX, int SourceStartY,
   int SourceEndX, int SourceEndY, int DestStartX,
   int DestStartY, unsigned int SourcePageBase,
   unsigned int DestPageBase, int SourceBitmapWidth,
   int DestBitmapWidth);

void CopyScreenToScreenMaskedX(int SourceStartX,
   int SourceStartY, int SourceEndX, int SourceEndY,
   int DestStartX, int DestStartY, MaskedImage * Source,
   unsigned int DestPageBase, int DestBitmapWidth);

void ShowPage(unsigned x, unsigned y);

void WritePixelX(int X, int Y, unsigned int PageBase, int Color);

void SetAllPalette (char *pbuf);

void SetIndexedPalette (int start, int endpal, char *pbuf);

