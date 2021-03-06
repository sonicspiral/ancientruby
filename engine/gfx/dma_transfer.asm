HDMATransferAttrMapAndTileMapToWRAMBank3::
	ld hl, .Function
	jp CallInSafeGFXMode

.Function:
	decoord 0, 0, wAttrMap
	ld hl, wScratchAttrMap
	call PadAttrMapForHDMATransfer
	decoord 0, 0
	ld hl, wScratchTileMap
	call PadTilemapForHDMATransfer
	ld a, $0
	ld [rVBK], a
	ld hl, wScratchTileMap
	call HDMATransferToWRAMBank3
	ld a, $1
	ld [rVBK], a
	ld hl, wScratchAttrMap
	call HDMATransferToWRAMBank3
	ret

HDMATransferTileMapToWRAMBank3::
	ld hl, .Function
	jp CallInSafeGFXMode

.Function:
	decoord 0, 0
	ld hl, wScratchTileMap
	call PadTilemapForHDMATransfer
	ld a, $0
	ld [rVBK], a
	ld hl, wScratchTileMap
	call HDMATransferToWRAMBank3
	ret

HDMATransferAttrMapToWRAMBank3:
	ld hl, .Function
	jp CallInSafeGFXMode

.Function:
	decoord 0, 0, wAttrMap
	ld hl, wScratchAttrMap
	call PadAttrMapForHDMATransfer
	ld a, $1
	ld [rVBK], a
	ld hl, wScratchAttrMap
	call HDMATransferToWRAMBank3
	ret

ReloadMapPart::
	ld hl, .Function
	jp CallInSafeGFXMode

.Function:
	decoord 0, 0, wAttrMap
	ld hl, wScratchAttrMap
	call PadAttrMapForHDMATransfer
	decoord 0, 0
	ld hl, wScratchTileMap
	call PadTilemapForHDMATransfer
	call DelayFrame

	di
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld hl, wScratchAttrMap
	call HDMATransfer_Wait127Scanlines_toBGMap
	ld a, $0
	ld [rVBK], a
	ld hl, wScratchTileMap
	call HDMATransfer_Wait127Scanlines_toBGMap
	pop af
	ld [rVBK], a
	ei

	ret

Mobile_ReloadMapPart:
	ld hl, ReloadMapPart ; useless
	ld hl, .Function
	jp CallInSafeGFXMode

.Function:
	decoord 0, 0, wAttrMap
	ld hl, wScratchAttrMap
	call PadAttrMapForHDMATransfer
	decoord 0, 0
	ld hl, wScratchTileMap
	call PadTilemapForHDMATransfer
	call DelayFrame

	di
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld hl, wScratchAttrMap
	call HDMATransfer_NoDI
	ld a, $0
	ld [rVBK], a
	ld hl, wScratchTileMap
	call HDMATransfer_NoDI
	pop af
	ld [rVBK], a
	ei

	ret

; unused
	ld hl, .unreferenced_1040da
	jp CallInSafeGFXMode

.unreferenced_1040da
	ld a, $1
	ld [rVBK], a
	ld a, BANK(w3_d800)
	ld [rSVBK], a
	ld de, w3_d800
	ld a, [hBGMapAddress + 1]
	ld [rHDMA1], a
	ld a, [hBGMapAddress]
	ld [rHDMA2], a
	ld a, d
	ld [rHDMA3], a
	ld a, e
	ld [rHDMA4], a
	ld a, $23
	ld [hDMATransfer], a
	call WaitDMATransfer
	ret

; unused
	ld hl, .unreferenced_104101
	jp CallInSafeGFXMode

.unreferenced_104101
	ld a, $1
	ld [rVBK], a
	ld a, BANK(w3_d800)
	ld [rSVBK], a
	ld hl, w3_d800
	call HDMATransferToWRAMBank3
	ret

OpenAndCloseMenu_HDMATransferTileMapAndAttrMap::
; OpenText
	ld hl, .Function
	jp CallInSafeGFXMode

.Function:
	; Transfer wAttrMap and Tilemap to BGMap
	; Fill vBGAttrs with $00
	; Fill vBGTiles with " "
	decoord 0, 0, wAttrMap
	ld hl, wScratchAttrMap
	call PadAttrMapForHDMATransfer
	decoord 0, 0
	ld hl, wScratchTileMap
	call PadTilemapForHDMATransfer
	call DelayFrame

	di
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld hl, wScratchAttrMap
	call HDMATransfer_Wait123Scanlines_toBGMap
	ld a, $0
	ld [rVBK], a
	ld hl, wScratchTileMap
	call HDMATransfer_Wait123Scanlines_toBGMap
	pop af
	ld [rVBK], a
	ei
	ret

Mobile_OpenAndCloseMenu_HDMATransferTileMapAndAttrMap:
	ld hl, .Function
	jp CallInSafeGFXMode

.Function:
	; Transfer wAttrMap and Tilemap to BGMap
	; Fill vBGAttrs with $00
	; Fill vBGTiles with $ff
	decoord 0, 0, wAttrMap
	ld hl, wScratchAttrMap
	call PadAttrMapForHDMATransfer
	ld c, $ff
	decoord 0, 0
	ld hl, wScratchTileMap
	call PadMapForHDMATransfer

	ld a, $1
	ld [rVBK], a
	ld hl, wScratchAttrMap
	call HDMATransfer_Wait127Scanlines_toBGMap
	ld a, $0
	ld [rVBK], a
	ld hl, wScratchTileMap
	call HDMATransfer_Wait127Scanlines_toBGMap
	ret

CallInSafeGFXMode:
	ld a, [hBGMapMode]
	push af
	ld a, [hMapAnims]
	push af
	xor a
	ld [hBGMapMode], a
	ld [hMapAnims], a
	ld a, [rSVBK]
	push af
	ld a, BANK(wScratchTileMap)
	ld [rSVBK], a
	ld a, [rVBK]
	push af

	call ._hl_

	pop af
	ld [rVBK], a
	pop af
	ld [rSVBK], a
	pop af
	ld [hMapAnims], a
	pop af
	ld [hBGMapMode], a
	ret

._hl_
	jp hl

HDMATransferToWRAMBank3:
	call _LoadHDMAParameters
	ld a, $23
	ld [hDMATransfer], a

WaitDMATransfer:
.loop
	call DelayFrame
	ld a, [hDMATransfer]
	and a
	jr nz, .loop
	ret

HDMATransfer_Wait127Scanlines_toBGMap:
; HDMA transfer from hl to [hBGMapAddress]
; hBGMapAddress -> de
; 2 * SCREEN_HEIGHT -> c
	ld a, [hBGMapAddress + 1]
	ld d, a
	ld a, [hBGMapAddress]
	ld e, a
	ld c, 2 * SCREEN_HEIGHT
	jr HDMATransfer_Wait127Scanlines

HDMATransfer_Wait123Scanlines_toBGMap:
; HDMA transfer from hl to [hBGMapAddress]
; hBGMapAddress -> de
; 2 * SCREEN_HEIGHT -> c
; $7b --> b
	ld a, [hBGMapAddress + 1]
	ld d, a
	ld a, [hBGMapAddress]
	ld e, a
	ld c, 2 * SCREEN_HEIGHT
	jr HDMATransfer_Wait123Scanlines

HDMATransfer_NoDI:
; HDMA transfer from hl to [hBGMapAddress]
; [hBGMapAddress] --> de
; 2 * SCREEN_HEIGHT --> c
	ld a, [hBGMapAddress + 1]
	ld d, a
	ld a, [hBGMapAddress]
	ld e, a
	ld c, 2 * SCREEN_HEIGHT

	; [rHDMA1, rHDMA2] = hl & $fff0
	ld a, h
	ld [rHDMA1], a
	ld a, l
	and $f0
	ld [rHDMA2], a
	; [rHDMA3, rHDMA4] = de & $1ff0
	ld a, d
	and $1f
	ld [rHDMA3], a
	ld a, e
	and $f0
	ld [rHDMA4], a
	; b = c | %10000000
	ld a, c
	dec c
	or $80
	ld b, a
	; d = $7f - c + 1
	ld a, $7f
	sub c
	ld d, a
	; while [rLY] >= d: pass
.loop1
	ld a, [rLY]
	cp d
	jr nc, .loop1
	; while not [rSTAT] & 3: pass
.loop2
	ld a, [rSTAT]
	and $3
	jr z, .loop2
	; load the 5th byte of HDMA
	ld a, b
	ld [rHDMA5], a
	; wait until rLY advances (c + 1) times
	ld a, [rLY]
	inc c
	ld hl, rLY
.loop3
	cp [hl]
	jr z, .loop3
	ld a, [hl]
	dec c
	jr nz, .loop3
	ld hl, rHDMA5
	res 7, [hl]
	ret

HDMATransfer_Wait123Scanlines:
	ld b, $7b
	jr _continue_HDMATransfer

HDMATransfer_Wait127Scanlines:
	ld b, $7f
_continue_HDMATransfer:
; a lot of waiting around for hardware registers
	; [rHDMA1, rHDMA2] = hl & $fff0
	ld a, h
	ld [rHDMA1], a
	ld a, l
	and $f0 ; high nybble
	ld [rHDMA2], a
	; [rHDMA3, rHDMA4] = de & $1ff0
	ld a, d
	and $1f ; lower 5 bits
	ld [rHDMA3], a
	ld a, e
	and $f0 ; high nybble
	ld [rHDMA4], a
	; e = c | %10000000
	ld a, c
	dec c
	or $80
	ld e, a
	; d = b - c + 1
	ld a, b
	sub c
	ld d, a
	; while [rLY] >= d: pass
.ly_loop
	ld a, [rLY]
	cp d
	jr nc, .ly_loop

	di
	; while [rSTAT] & 3: pass
.rstat_loop_1
	ld a, [rSTAT]
	and $3
	jr nz, .rstat_loop_1
	; while not [rSTAT] & 3: pass
.rstat_loop_2
	ld a, [rSTAT]
	and $3
	jr z, .rstat_loop_2
	; load the 5th byte of HDMA
	ld a, e
	ld [rHDMA5], a
	; wait until rLY advances (c + 1) times
	ld a, [rLY]
	inc c
	ld hl, rLY
.final_ly_loop
	cp [hl]
	jr z, .final_ly_loop
	ld a, [hl]
	dec c
	jr nz, .final_ly_loop
	ld hl, rHDMA5
	res 7, [hl]
	ei

	ret

_LoadHDMAParameters:
	ld a, h
	ld [rHDMA1], a
	ld a, l
	ld [rHDMA2], a
	ld a, [hBGMapAddress + 1]
	and $1f
	ld [rHDMA3], a
	ld a, [hBGMapAddress]
	ld [rHDMA4], a
	ret

PadTilemapForHDMATransfer:
	ld c, " "
	jr PadMapForHDMATransfer

PadAttrMapForHDMATransfer:
	ld c, $0

PadMapForHDMATransfer:
; pad a 20x18 map to 32x18 for HDMA transfer
; back up the padding value in c to hMapObjectIndexBuffer
	ld a, [hMapObjectIndexBuffer]
	push af
	ld a, c
	ld [hMapObjectIndexBuffer], a

; for each row on the screen
	ld c, SCREEN_HEIGHT
.loop1
; for each tile in the row
	ld b, SCREEN_WIDTH
.loop2
; copy from de to hl
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .loop2

; load the original padding value of c into hl for 32 - 20 = 12 rows
	ld a, [hMapObjectIndexBuffer]
	ld b, BG_MAP_WIDTH - SCREEN_WIDTH
.loop3
	ld [hli], a
	dec b
	jr nz, .loop3

	dec c
	jr nz, .loop1

; restore the original value of hMapObjectIndexBuffer
	pop af
	ld [hMapObjectIndexBuffer], a
	ret

_Get2bpp::
	; 2bpp when [rLCDC] & $80
	; switch to WRAM bank 6
	ld a, [rSVBK]
	push af
	ld a, BANK(wScratchTileMap)
	ld [rSVBK], a

	push bc
	push hl

	; Copy c tiles of the 2bpp from b:de to wScratchTileMap
	ld a, b ; bank
	ld l, c ; number of tiles
	ld h, $0
	; multiply by 16 (16 bytes of a 2bpp = 8 x 8 tile)
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld b, h
	ld c, l
	ld h, d ; address
	ld l, e
	ld de, wScratchTileMap
	call FarCopyBytes

	pop hl
	pop bc

	push bc
	call DelayFrame
	pop bc

	ld d, h
	ld e, l
	ld hl, wScratchTileMap
	call HDMATransfer_Wait127Scanlines

	; restore the previous bank
	pop af
	ld [rSVBK], a
	ret

_Get1bpp::
	; 1bpp when [rLCDC] & $80
.loop
	ld a, c
	cp $10
	jp c, .bankswitch
	jp z, .bankswitch
	push bc
	push hl
	push de
	ld c, $10
	call .bankswitch
	pop de
	ld hl, $80
	add hl, de
	ld d, h
	ld e, l
	pop hl
	lb bc, 1, 0
	add hl, bc
	pop bc
	ld a, c
	sub $10
	ld c, a
	jr .loop

.bankswitch
	ld a, [rSVBK]
	push af
	ld a, BANK(wScratchTileMap)
	ld [rSVBK], a

	push bc
	push hl

	ld a, b
	ld l, c
	ld h, $0
	add hl, hl ; multiply by 8
	add hl, hl ; multiply by 8
	add hl, hl ; multiply by 8
	ld c, l
	ld b, h
	ld h, d
	ld l, e
	ld de, wScratchTileMap
	call FarCopyBytesDouble_DoubleBankSwitch

	pop hl
	pop bc

	push bc
	call DelayFrame
	pop bc

	ld d, h
	ld e, l
	ld hl, wScratchTileMap
	call HDMATransfer_Wait127Scanlines

	pop af
	ld [rSVBK], a
	ret

HDMATransfer_OnlyTopFourRows:
	ld hl, .Function
	jp CallInSafeGFXMode

.Function:
	ld hl, wScratchTileMap
	decoord 0, 0
	call .Copy
	ld hl, wScratchTileMap + $80
	decoord 0, 0, wAttrMap
	call .Copy
	ld a, $1
	ld [rVBK], a
	ld c, $8
	ld hl, wScratchTileMap + $80
	debgcoord 0, 0, vBGMap1
	call HDMATransfer_Wait127Scanlines
	ld a, $0
	ld [rVBK], a
	ld c, $8
	ld hl, wScratchTileMap
	debgcoord 0, 0, vBGMap1
	call HDMATransfer_Wait127Scanlines
	ret

.Copy:
	ld b, 4
.outer_loop
	ld c, SCREEN_WIDTH
.inner_loop
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .inner_loop
	ld a, l
	add BG_MAP_WIDTH - SCREEN_WIDTH
	ld l, a
	ld a, h
	adc 0
	ld h, a
	dec b
	jr nz, .outer_loop
	ret
