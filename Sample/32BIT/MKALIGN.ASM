	.386p
	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "MKALIGN.C"
	?debug	T "MKALIGN.C"
_TEXT	segment byte public use32 'CODE'
_TEXT	ends
_DATA	segment dword public use32 'DATA'
_DATA	ends
_BSS	segment dword public use32 'BSS'
_BSS	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_TEXT	segment byte public use32 'CODE'
c@	label	byte
	assume	cs:_TEXT
_CreateAlignedMaskedImage       proc    near
   ;	
   ;	unsigned int CreateAlignedMaskedImage(MaskedImage * ImageToSet,
   ;	
	?debug	L 18
@11@55:
	enter	48,0
	push	edi
	push	esi
   ;	
   ;	   unsigned int DispMemStart, char * Image, int ImageWidth,
   ;	   int ImageHeight, char * Mask)
   ;	{
   ;	   int Align, ScanLine, BitNum, Size, TempImageWidth;
   ;	   unsigned char MaskTemp;
   ;	   unsigned int DispMemOffset = DispMemStart;
   ;	
	?debug	L 24
@12@0:
	mov	dword ptr [ebp-4],edx
   ;	
   ;	   AlignedMaskedImage *WorkingAMImage;
   ;	   char *NewMaskPtr, *OldMaskPtr;
   ;	
   ;	   /* Generate each of the four alignments in turn */
   ;	   for (Align = 0; Align < 4; Align++) {
   ;	
	?debug	L 29
@12@28:
	xor	edi,edi
	mov	dword ptr [ebp-8],eax
@12@70:
	mov	dword ptr [ebp-12],edx
@12@99:
	mov	dword ptr [ebp-16],ebx
@12@128:
	jmp	near ptr @28
@13:
   ;	
   ;	
   ;	      /* Allocate space for the AlignedMaskedImage struct for this
   ;	         alignment */
   ;	      if ((WorkingAMImage = ImageToSet->Alignments[Align] =
   ;	
	?debug	L 33
	push	12
	call	near ptr MALLOC
	lea	edx,dword ptr [edi*4]
	mov	ecx,dword ptr [ebp-8]
@13@89:
	mov	dword ptr [ecx+edx],eax
	mov	esi,eax
	test	esi,esi
	jne	short @15
   ;	
   ;	            malloc(sizeof(AlignedMaskedImage))) == NULL)
   ;	         return 0;
   ;	
	?debug	L 35
	xor	eax,eax
	?debug	L 76
	jmp	near ptr @31
@15:
   ;	
   ;	
   ;	      WorkingAMImage->ImageWidth =
   ;	
	?debug	L 37
	mov	eax,dword ptr [ebp+16]
	lea	edx,dword ptr [eax+edi]
	add	edx,3
	mov	eax,edx
	mov	ecx,4
	cdq
	idiv	ecx
	mov	dword ptr [esi],eax
   ;	
   ;	            (ImageWidth + Align + 3) / 4; /* width in 4-pixel sets */
   ;	
   ;	      WorkingAMImage->ImagePtr = DispMemOffset; /* image dest */
   ;	
	?debug	L 40
	mov	eax,dword ptr [ebp-4]
	mov	dword ptr [esi+4],eax
   ;	
   ;	
   ;	      /* Download this alignment of the image */
   ;	      CopySystemToScreenX(0, 0, ImageWidth, ImageHeight, Align, 0,
   ;	
	?debug	L 43
	mov	edx,dword ptr [esi]
	shl	edx,2
	push	dword ptr [ebp+12]
	push	edi
	push	0
	push	dword ptr [ebp-16]
	push	eax
	mov	eax,dword ptr [ebp+16]
	push	eax
	push	edx
	xor	eax,eax
	xor	edx,edx
	mov	dword ptr [ebp-20],ebx
	mov	ebx,dword ptr [ebp+16]
        call    near ptr _CopySystemToScreenX
   ;	
   ;	            Image, DispMemOffset, ImageWidth,
   ;	            WorkingAMImage->ImageWidth * 4);
   ;	
   ;	      /* Calculate the number of bytes needed to store the mask in
   ;	         nibble (Map Mask-ready) form, then allocate that space */
   ;	      Size = WorkingAMImage->ImageWidth * ImageHeight;
   ;	
	?debug	L 49
	mov	eax,dword ptr [esi]
	imul	eax,dword ptr [ebp+12]
   ;	
   ;	
   ;	      if ((WorkingAMImage->MaskPtr = malloc(Size)) == NULL)
   ;	
	?debug	L 51
@16@35:
	mov	edx,eax
	push	edx
	mov	dword ptr [ebp-24],eax
@16@89:
	call	near ptr MALLOC
	mov	dword ptr [esi+8],eax
	test	eax,eax
	jne	short @18
   ;	
   ;	         return 0;
   ;	
	?debug	L 52
	xor	eax,eax
	?debug	L 76
	jmp	near ptr @31
@18:
   ;	
   ;	
   ;	      /* Generate this nibble oriented (Map Mask-ready) alignment of
   ;	         the mask, one scan line at a time */
   ;	      OldMaskPtr = Mask;
   ;	
	?debug	L 56
	mov	eax,dword ptr [ebp+8]
   ;	
   ;	      NewMaskPtr = WorkingAMImage->MaskPtr;
   ;	
	?debug	L 57
@18@28:
	mov	edx,dword ptr [esi+8]
   ;	
   ;	      for (ScanLine = 0; ScanLine < ImageHeight; ScanLine++) {
   ;	
	?debug	L 58
@18@56:
	mov	dword ptr [ebp-28],0
@18@83:
	mov	dword ptr [ebp-32],eax
@18@112:
	mov	dword ptr [ebp-36],edx
@18@141:
	jmp	short @26
@19:
   ;	
   ;	         BitNum = Align;
   ;	
	?debug	L 59
	mov	ebx,edi
   ;	
   ;	         MaskTemp = 0;
   ;	
	?debug	L 60
	mov	byte ptr [ebp-40],0
   ;	
   ;	         TempImageWidth = ImageWidth;
   ;	
	?debug	L 61
@19@40:
	mov	eax,dword ptr [ebp+16]
@19@69:
	mov	dword ptr [ebp-44],eax
@19@98:
@20:
   ;	
   ;	         do {
   ;	            /* Set the mask bit for next pixel according to its alignment */
   ;	            MaskTemp |= (*OldMaskPtr++ != 0) << BitNum;
   ;	
	?debug	L 64
	mov	eax,dword ptr [ebp-32]
@20@29:
	cmp	byte ptr [eax],0
	setne	dl
	movzx	edx,dl
	mov	ecx,ebx
	mov	dword ptr [ebp-48],ecx
	mov	ecx,dword ptr [ebp-48]
	shl	dl,cl
	or	byte ptr [ebp-40],dl
@20@188:
	inc	eax
   ;	
   ;	            if (++BitNum > 3) {
   ;	
	?debug	L 65
@20@198:
	inc	ebx
	cmp	ebx,3
	mov	dword ptr [ebp-32],eax
@20@249:
	jle	short @22
   ;	
   ;	               *NewMaskPtr++ = MaskTemp;
   ;	
	?debug	L 66
	mov	al,byte ptr [ebp-40]
	mov	edx,dword ptr [ebp-36]
@21@56:
	mov	byte ptr [edx],al
	inc	edx
   ;	
   ;	               MaskTemp = BitNum = 0;
   ;	
	?debug	L 67
@21@90:
	xor	ebx,ebx
	mov	byte ptr [ebp-40],bl
@21@131:
	mov	dword ptr [ebp-36],edx
@21@160:
@22:
   ;	
   ;	            }
   ;	         } while (--TempImageWidth);
   ;	
	?debug	L 69
	dec	dword ptr [ebp-44]
@22@25:
	cmp	dword ptr [ebp-44],0
	jne	short @20
   ;	
   ;	         /* Set any partial final mask on this scan line */
   ;	         if (BitNum != 0) *NewMaskPtr++ = MaskTemp;
   ;	
	?debug	L 71
	test	ebx,ebx
	je	short @25
	mov	al,byte ptr [ebp-40]
	mov	edx,dword ptr [ebp-36]
@24@56:
	mov	byte ptr [edx],al
	inc	edx
@24@90:
	mov	dword ptr [ebp-36],edx
@24@119:
@25:
	?debug	L 58
	inc	dword ptr [ebp-28]
@25@25:
@26:
	mov	eax,dword ptr [ebp+12]
	cmp	dword ptr [ebp-28],eax
	jl	short @19
   ;	
   ;	      }
   ;	      DispMemOffset += Size; /* mark off the space we just used */
   ;	
	?debug	L 73
	mov	eax,dword ptr [ebp-24]
	add	dword ptr [ebp-4],eax
	?debug	L 29
@27@57:
	inc	edi
@28:
	cmp	edi,4
	jl	near ptr @13
   ;	
   ;	   }
   ;	   return DispMemOffset - DispMemStart;
   ;	
	?debug	L 75
	mov	eax,dword ptr [ebp-4]
	sub	eax,dword ptr [ebp-12]
	?debug	L 76
@31:
@31@0:
	pop	esi
	pop	edi
	leave
	ret	12
_CreateAlignedMaskedImage       endp
_TEXT	ends
	extrn	MALLOC:near
        extrn   _CopySystemToScreenX:near
        public  _CreateAlignedMaskedImage
_DATA	segment dword public use32 'DATA'
d@	label	byte
d@w	label	word
d@d	label	dword
s@	label	byte
_DATA	ends
_BSS	segment dword public use32 'BSS'
b@	label	byte
b@w	label	word
b@d	label	dword
_BSS	ends
	end
