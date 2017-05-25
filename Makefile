
PREFIX?=	/usr/local
BINDIR?=	${PREFIX}/bin
MANDIR?=	${PREFIX}/man/man
RM?=		/bin/rm -i
SHELLCHECK?=	shellcheck

SCRIPTS=	run-one
MAN=		run-one.1

LINKS=	${BINDIR}/run-one ${BINDIR}/run-this-one          \
	${BINDIR}/run-one ${BINDIR}/run-one-constantly    \
	${BINDIR}/run-one ${BINDIR}/run-one-until-success \
	${BINDIR}/run-one ${BINDIR}/run-one-until-failure

MLINKS=	run-one.1 run-this-one.1          \
	run-one.1 run-one-constantly.1    \
	run-one.1 run-one-until-failure.1 \
	run-one.1 run-one-until-success.1

uninstall:
	@${RM} ${BINDIR}/${SCRIPTS}

.for ro bin in ${LINKS}
	@${RM} ${bin}
.endfor

	@${RM} ${MANDIR}1/${MAN}.gz

.for ro man in ${MLINKS}
	@${RM} ${MANDIR}1/${man}.gz
.endfor

test:
	${SHELLCHECK} ${SCRIPTS}

.include <bsd.prog.mk>
