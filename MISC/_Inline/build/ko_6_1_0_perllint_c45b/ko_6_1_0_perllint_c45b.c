/*
 * This file was generated automatically by ExtUtils::ParseXS version 2.22 from the
 * contents of ko_6_1_0_perllint_c45b.xs. Do not edit this file, edit ko_6_1_0_perllint_c45b.xs instead.
 *
 *	ANY CHANGES MADE HERE WILL BE LOST! 
 *
 */

#line 1 "ko_6_1_0_perllint_c45b.xs"
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    void greet(SV* name1, ...) {
            Inline_Stack_Vars;
            int i;
            int j;
            for (i = 0; i < Inline_Stack_Items; i++)
                j = 2 * SvPV(Inline_Stack_Item(i), PL_na);
                printf("Hello %d!\n", j);
                
            Inline_Stack_Void;
                }


#line 28 "ko_6_1_0_perllint_c45b.c"
#ifndef PERL_UNUSED_VAR
#  define PERL_UNUSED_VAR(var) if (0) var = var
#endif

#ifndef PERL_ARGS_ASSERT_CROAK_XS_USAGE
#define PERL_ARGS_ASSERT_CROAK_XS_USAGE assert(cv); assert(params)

/* prototype to pass -Wmissing-prototypes */
STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params);

STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params)
{
    const GV *const gv = CvGV(cv);

    PERL_ARGS_ASSERT_CROAK_XS_USAGE;

    if (gv) {
        const char *const gvname = GvNAME(gv);
        const HV *const stash = GvSTASH(gv);
        const char *const hvname = stash ? HvNAME(stash) : NULL;

        if (hvname)
            Perl_croak(aTHX_ "Usage: %s::%s(%s)", hvname, gvname, params);
        else
            Perl_croak(aTHX_ "Usage: %s(%s)", gvname, params);
    } else {
        /* Pants. I don't think that it should be possible to get here. */
        Perl_croak(aTHX_ "Usage: CODE(0x%"UVxf")(%s)", PTR2UV(cv), params);
    }
}
#undef  PERL_ARGS_ASSERT_CROAK_XS_USAGE

#ifdef PERL_IMPLICIT_CONTEXT
#define croak_xs_usage(a,b)	S_croak_xs_usage(aTHX_ a,b)
#else
#define croak_xs_usage		S_croak_xs_usage
#endif

#endif

/* NOTE: the prototype of newXSproto() is different in versions of perls,
 * so we define a portable version of newXSproto()
 */
#ifdef newXS_flags
#define newXSproto_portable(name, c_impl, file, proto) newXS_flags(name, c_impl, file, proto, 0)
#else
#define newXSproto_portable(name, c_impl, file, proto) (PL_Sv=(SV*)newXS(name, c_impl, file), sv_setpv(PL_Sv, proto), (CV*)PL_Sv)
#endif /* !defined(newXS_flags) */

#line 80 "ko_6_1_0_perllint_c45b.c"

XS(XS_main_greet); /* prototype to pass -Wmissing-prototypes */
XS(XS_main_greet)
{
#ifdef dVAR
    dVAR; dXSARGS;
#else
    dXSARGS;
#endif
    if (items < 1)
       croak_xs_usage(cv,  "name1, ...");
    PERL_UNUSED_VAR(ax); /* -Wall */
    SP -= items;
    {
	SV *	name1 = ST(0);
#line 27 "ko_6_1_0_perllint_c45b.xs"
	I32* temp;
#line 98 "ko_6_1_0_perllint_c45b.c"
#line 29 "ko_6_1_0_perllint_c45b.xs"
	temp = PL_markstack_ptr++;
	greet(name1);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */
#line 109 "ko_6_1_0_perllint_c45b.c"
	PUTBACK;
	return;
    }
}

#ifdef __cplusplus
extern "C"
#endif
XS(boot_ko_6_1_0_perllint_c45b); /* prototype to pass -Wmissing-prototypes */
XS(boot_ko_6_1_0_perllint_c45b)
{
#ifdef dVAR
    dVAR; dXSARGS;
#else
    dXSARGS;
#endif
#if (PERL_REVISION == 5 && PERL_VERSION < 9)
    char* file = __FILE__;
#else
    const char* file = __FILE__;
#endif

    PERL_UNUSED_VAR(cv); /* -W */
    PERL_UNUSED_VAR(items); /* -W */
    XS_VERSION_BOOTCHECK ;

        newXS("main::greet", XS_main_greet, file);
#if (PERL_REVISION == 5 && PERL_VERSION >= 9)
  if (PL_unitcheckav)
       call_list(PL_scopestack_ix, PL_unitcheckav);
#endif
    XSRETURN_YES;
}

