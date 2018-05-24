# sengine mingmakefile
# (c) 2017-2018, Brian Stephenson
# brian@bstephen.me.uk
#
BITS	=	64
EXE	=	sengine
CC	=	gcc
LD	=	gcc
RELEASE	=	-O3 -NDEBUG
DEBUG	=	-g -O0 -DMOVESTAT 
CFLAGS	=	${DEBUG} -c -mtune=native -m${BITS} -Wall -std=gnu99
LDFLAGS	=	-o${EXE}
IND	=	astyle
INDOPTS	=	--style=kr --align-pointer=type --indent=tab=3 --indent=spaces \
		--pad-oper --unpad-paren --break-blocks --delete-empty-lines \
		--pad-header
MD5HDS	=	md5.h
MD5MODS	=	md5.c
MD5OBJS	=	md5.o
GXHDS	=	genx.h
GXMODS	=	genx.c charprops.c
GXOBJS	=	genx.o charprops.o
CHDS	=	sengine.h options.h
CMODS	=	sengine.c options.c init.c board.c direct.c dir_xml.c boardlist.c \
			memory.c
COBJS	=	sengine.o options.o init.o board.o direct.o dir_xml.o boardlist.o \
			memory.o
CASMS	=	sengine.asm options.asm init.asm board.asm direct.asm dir_xml.asm \
			boardlist.asm memory.asm

sengine:	${COBJS} ${MD5OBJS} ${GXOBJS}
	${LD}   ${LDFLAGS} ${COBJS} ${MD5OBJS} ${GXOBJS}
	cp ${EXE} ${HOME}/bin/${EXE}

sengine.o:	sengine.c ${CHDS} ${KHDS} ${MD5HDS} ${GXHDS}
	${CC} ${CFLAGS} sengine.c
	objconv -fnasm sengine.o
	
boardlist.o:	boardlist.c ${CHDS} ${KHDS} ${MD5HDS} ${GXHDS}
	${CC} ${CFLAGS} boardlist.c
	objconv -fnasm boardlist.o

direct.o:	direct.c ${CHDS} ${KHDS} ${MD5HDS} ${GXHDS}
	${CC} ${CFLAGS} direct.c
	objconv -fnasm direct.o

memory.o:	memory.c ${CHDS} ${KHDS} ${MD5HDS} ${GXHDS}
	${CC} ${CFLAGS} memory.c
	objconv -fnasm memory.o
	
dir_xml.o:	dir_xml.c ${CHDS} ${KHDS} ${MD5HDS} ${GXHDS}
	${CC} ${CFLAGS} dir_xml.c
	objconv -fnasm dir_xml.o
	
options.o:	options.c ${CHDS} ${KHDS} ${MD5HDS} ${GXHDS}
	${CC} ${CFLAGS} options.c
	objconv -fnasm options.o

init.o:	init.c ${CHDS} ${KHDS} ${MD5HDS} ${GXHDS}
	${CC} ${CFLAGS} init.c
	objconv -fnasm init.o

board.o:	board.c ${CHDS} ${KHDS} ${MD5HDS} ${GXHDS}
	${CC} ${CFLAGS} board.c
	objconv -fnasm board.o
	
md5.o:	md5.c ${MD5HDS}
	${CC} ${CFLAGS} md5.c
	
charprops.o:	charprops.c ${MD5HDS}
	${CC} ${CFLAGS} charprops.c
	
genx.o:	genx.c ${MD5HDS}
	${CC} ${CFLAGS} genx.c
	
clean:
	rm -f ${COBJS} ${CASMS} ${MD5OBJS} ${GXOBJS} ${EXE}  *orig

tidy:
	${IND} ${INDOPTS} ${CMODS} ${CHDS}

touch:
	touch ${CMODS} ${CHDS}
	
count:
	wc -l ${CMODS} ${CHDS} | sort -b -n	
