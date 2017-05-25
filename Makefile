
PREFIX?=	/usr/local
BINDIR?=	${PREFIX}/bin
MANDIR?=	${PREFIX}/man/man

SCRIPTS=	run-one
MAN=		run-one.1

LINKS=	${BINDIR}/run-one ${BINDIR}/run-this-one          \
	${BINDIR}/run-one ${BINDIR}/run-one-until-success \
	${BINDIR}/run-one ${BINDIR}/run-one-until-failure

MLINKS=	run-one.1 run-this-one.1          \
	run-one.1 run-one-until-failure.1 \
	run-one.1 run-one-until-success.1

.include <bsd.prog.mk>
