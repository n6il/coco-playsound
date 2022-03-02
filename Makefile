OBJS = coco-playsound-cc23.bin coco-playsound-cc1.bin coco-playsound-becker.bin coco-playsound-rs232pak.bin coco-playsound-player.bin

coco-playsound-player.bin: coco-playsound-player.asm
	lwasm -b -l$(@:bin=lst) -o$@ $?

dsk: $(OBJS)
	rm -f coco-playsound.dsk
	decb dskini coco-playsound.dsk
	decb copy playsnd.bas -t coco-playsound.dsk,PLAYSND.BAS
	decb copy coco-playsound-player.bin coco-playsound.dsk,PLAYSND.BIN -2 -b
	decb copy coco-playsound-cc23.bin coco-playsound.dsk,DWSMCC23.BIN -2 -b
	decb copy coco-playsound-cc1.bin coco-playsound.dsk,DWSMCC1.BIN -2 -b
	decb copy coco-playsound-becker.bin coco-playsound.dsk,DWSMBCK.BIN -2 -b
	decb copy coco-playsound-becker.bin coco-playsound.dsk,DWSM232.BIN -2 -b

clean:
	rm -f coco-playsound.dsk *.bin *.lst

coco-playsound-cc23.bin: coco-playsound-module.asm
	lwasm -b -l$(@:bin=lst) -o$@ $?
	
coco-playsound-cc1.bin: coco-playsound-module.asm
	lwasm -b -l$(@:bin=lst) -DBAUD38400=1 -o$@ $?
	
coco-playsound-becker.bin: coco-playsound-module.asm
	lwasm -b -l$(@:bin=lst) -DBECKER=1 -o$@ $?
	
coco-playsound-rs232pak.bin: coco-playsound-module.asm
	lwasm -b -l$(@:bin=lst) -DSY6551N=1 -o$@ $?
	
