coco-playsound.bin: coco-playsound.asm
	lwasm -b -lcoco-playsound.lst -ococo-playsound.bin coco-playsound.asm

dsk: coco-playsound.bin
	rm -f coco-playsound.dsk
	decb dskini coco-playsound.dsk
	decb copy coco-playsound.bin coco-playsound.dsk,PLAYSND.BIN -2 -b

clean:
	rm -f coco-playsound.dsk coco-playsound.bin coco-playsound.lst
