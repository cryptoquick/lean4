// Lean compiler output
// Module: Lean.Meta.Tactic.BVDecide.Normalize.Structures
// Imports: public import Lean.Meta.Tactic.BVDecide.Normalize.TypeAnalysis public import Lean.Meta.Sym.Simp.SimpM import Lean.Meta.Tactic.BVDecide.Normalize.ApplyControlFlow import Lean.Meta.Tactic.Ext import Lean.Meta.Sym.Simp.Theorems import Lean.Meta.Sym.Simp.Rewrite import Lean.Meta.Sym.Util
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
lean_object* lean_array_get_size(lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
lean_object* lean_array_fget_borrowed(lean_object*, lean_object*);
uint8_t lean_name_eq(lean_object*, lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
lean_object* l_Lean_Meta_mkConstWithFreshMVarLevels(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_infer_type(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_forallMetaTelescopeReducing(lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkAppN(lean_object*, lean_object*);
lean_object* lean_nat_sub(lean_object*, lean_object*);
lean_object* l_Lean_getStructureInfo(lean_object*, lean_object*);
lean_object* lean_st_ref_get(lean_object*);
lean_object* l_Lean_isInductiveCore_x3f(lean_object*, lean_object*);
lean_object* l_Lean_stringToMessageData(lean_object*);
lean_object* l_Lean_MessageData_ofConstName(lean_object*, uint8_t);
lean_object* l_List_head_x21___redArg(lean_object*, lean_object*);
lean_object* l_Lean_Environment_findAsync_x3f(lean_object*, lean_object*, uint8_t);
lean_object* l_Lean_AsyncConstantInfo_toConstantInfo(lean_object*);
lean_object* l_mkPanicMessageWithDecl(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_instMonadEIO(lean_object*);
lean_object* l_StateRefT_x27_instMonad___redArg(lean_object*);
lean_object* l_Lean_Core_instMonadCoreM___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Core_instMonadCoreM___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_ReaderT_instFunctorOfMonad___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_ReaderT_instFunctorOfMonad___redArg___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_ReaderT_instApplicativeOfMonad___redArg___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_ReaderT_instApplicativeOfMonad___redArg___lam__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_ReaderT_instApplicativeOfMonad___redArg___lam__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_instMonadMetaM___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_instMonadMetaM___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_ReaderT_instMonad___redArg(lean_object*);
lean_object* l_instInhabitedOfMonad___redArg(lean_object*, lean_object*);
lean_object* lean_panic_fn_borrowed(lean_object*, lean_object*);
lean_object* lean_array_pop(lean_object*);
lean_object* l_Lean_Meta_mkProjFn___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_shareCommonInc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_inferType(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_unfoldReducible(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_shareCommon(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_isProp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Expr_getAppFn(lean_object*);
uint64_t lean_uint64_shift_right(uint64_t, uint64_t);
uint64_t lean_uint64_xor(uint64_t, uint64_t);
size_t lean_uint64_to_usize(uint64_t);
size_t lean_usize_of_nat(lean_object*);
size_t lean_usize_sub(size_t, size_t);
size_t lean_usize_land(size_t, size_t);
lean_object* lean_array_uget_borrowed(lean_object*, size_t);
uint64_t lean_uint64_of_nat(lean_object*);
lean_object* l_Lean_Expr_sort___override(lean_object*);
lean_object* l_Lean_Expr_getAppNumArgs(lean_object*);
lean_object* lean_mk_array(lean_object*, lean_object*);
lean_object* l___private_Lean_Expr_0__Lean_Expr_getAppArgsAux(lean_object*, lean_object*, lean_object*);
lean_object* lean_array_push(lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr1(lean_object*);
uint8_t l_Lean_instBEqMVarId_beq(lean_object*, lean_object*);
lean_object* lean_array_fset(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_Result_withContextDependent(lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_mkEqTrans(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_PersistentHashMap_mkEmptyEntriesArray(lean_object*, lean_object*);
lean_object* lean_usize_to_nat(size_t);
lean_object* lean_array_get_borrowed(lean_object*, lean_object*, lean_object*);
size_t lean_usize_shift_right(size_t, size_t);
lean_object* l_Lean_replaceRef(lean_object*, lean_object*);
uint8_t l_Lean_Name_isAnonymous(lean_object*);
lean_object* l_Lean_Environment_setExporting(lean_object*, uint8_t);
uint8_t l_Lean_Environment_contains(lean_object*, lean_object*, uint8_t);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
extern lean_object* l_Lean_Options_empty;
lean_object* l_Lean_Environment_getModuleIdxFor_x3f(lean_object*, lean_object*);
lean_object* l_Lean_MessageData_note(lean_object*);
lean_object* l_Lean_Environment_header(lean_object*);
lean_object* l_Lean_EnvironmentHeader_moduleNames(lean_object*);
lean_object* lean_array_get(lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_isPrivateName(lean_object*);
lean_object* l_Lean_MessageData_ofName(lean_object*);
extern lean_object* l_Lean_unknownIdentifierMessageTag;
uint64_t l_Lean_instHashableMVarId_hash(lean_object*);
size_t lean_usize_mul(size_t, size_t);
lean_object* lean_array_fget(lean_object*, lean_object*);
lean_object* l_Lean_PersistentHashMap_mkCollisionNode___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
size_t lean_usize_add(size_t, size_t);
lean_object* l_Lean_PersistentHashMap_mkEmptyEntries(lean_object*, lean_object*);
uint8_t lean_usize_dec_le(size_t, size_t);
lean_object* l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_dischargeNone___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_Theorems_rewrite(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_usize_dec_lt(size_t, size_t);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
uint8_t l_Lean_LocalDecl_isLet(lean_object*, uint8_t);
uint8_t l_Lean_LocalDecl_isImplementationDetail(lean_object*);
lean_object* l_Lean_LocalDecl_type(lean_object*);
lean_object* l_Lean_LocalDecl_fvarId(lean_object*);
lean_object* l_Lean_mkFVar(lean_object*);
lean_object* l_Lean_StructureInfo_getProjFn_x3f(lean_object*, lean_object*);
lean_object* l_Lean_Environment_findConstVal_x3f(lean_object*, lean_object*, uint8_t);
lean_object* l_Lean_Expr_getForallArity(lean_object*);
lean_object* lean_array_uset(lean_object*, size_t, lean_object*);
lean_object* lean_nat_mul(lean_object*, lean_object*);
lean_object* lean_nat_div(lean_object*, lean_object*);
uint8_t lean_nat_dec_le(lean_object*, lean_object*);
lean_object* lean_array_set(lean_object*, lean_object*, lean_object*);
extern lean_object* l_Lean_instInhabitedExpr;
lean_object* l_Lean_Meta_mkEqRefl(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_usize_dec_eq(size_t, size_t);
lean_object* l_Lean_Meta_Sym_Internal_Sym_assertShared(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr3(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_append(lean_object*, lean_object*);
uint8_t l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_MessageData_ofExpr(lean_object*);
lean_object* lean_st_ref_take(lean_object*);
double lean_float_of_nat(lean_object*);
lean_object* l_Lean_PersistentArray_push___redArg(lean_object*, lean_object*);
lean_object* lean_st_ref_set(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_applyCondSimproc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
size_t lean_array_size(lean_object*);
lean_object* l_Array_append___redArg(lean_object*, lean_object*);
extern lean_object* l_Lean_Meta_Ext_instInhabitedExtTheorem_default;
lean_object* lean_string_append(lean_object*, lean_object*);
lean_object* l_Lean_Name_str___override(lean_object*, lean_object*);
extern lean_object* l_Lean_Meta_Ext_extExtension;
extern lean_object* l_Lean_Meta_Ext_instInhabitedExtTheorems_default;
lean_object* l_Lean_ScopedEnvExtension_getState___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_DiscrTree_getMatch___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_array_fswap(lean_object*, lean_object*, lean_object*);
lean_object* l_Array_reverse___redArg(lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_mkTheoremFromDecl(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_Theorems_insert(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_applyIteSimproc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addDefaultTypeAnalysisLemmas(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_simp___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_SimpM_run_x27___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_Expr_isFalse(lean_object*);
uint8_t l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(lean_object*, lean_object*);
lean_object* l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0___redArg___boxed(lean_object*, lean_object*);
static lean_once_cell_t l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static uint64_t l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0;
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___boxed(lean_object*, lean_object*);
static const lean_ctor_object l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*0 + 8, .m_other = 0, .m_tag = 0}, .m_objs = {LEAN_SCALAR_PTR_LITERAL(0, 0, 0, 0, 0, 0, 0, 0)}};
static const lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___closed__0 = (const lean_object*)&l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0;
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_mkConstAppWithMVars(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_mkConstAppWithMVars___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_InsertionSort_0__Array_insertionSort_swapLoop___at___00__private_Init_Data_Array_InsertionSort_0__Array_insertionSort_traverse___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__1_spec__2___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_InsertionSort_0__Array_insertionSort_traverse___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__1(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0___redArg(lean_object*, size_t, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__2(lean_object*, lean_object*, size_t, size_t, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "_iff"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___closed__0_value;
static const lean_array_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___closed__1 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___closed__1_value;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0(lean_object*, lean_object*, size_t, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_InsertionSort_0__Array_insertionSort_swapLoop___at___00__private_Init_Data_Array_InsertionSort_0__Array_insertionSort_traverse___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__1_spec__2(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Sym_Simp_dischargeNone___boxed, .m_arity = 11, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5_spec__10(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5_spec__10___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 2, .m_capacity = 2, .m_length = 1, .m_data = "`"};
static const lean_object* l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__0 = (const lean_object*)&l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__0_value;
static lean_once_cell_t l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1;
static const lean_string_object l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 27, .m_capacity = 27, .m_length = 26, .m_data = "` is not an inductive type"};
static const lean_object* l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__2 = (const lean_object*)&l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__2_value;
static lean_once_cell_t l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__3;
LEAN_EXPORT lean_object* l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__0;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__1;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__2;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__3;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__4;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__5;
static const lean_string_object l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 24, .m_capacity = 24, .m_length = 23, .m_data = "A private declaration `"};
static const lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__6 = (const lean_object*)&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__6_value;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__7;
static const lean_string_object l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 79, .m_capacity = 79, .m_length = 78, .m_data = "` (from the current module) exists but would need to be public to access here."};
static const lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__8 = (const lean_object*)&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__8_value;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__9;
static const lean_string_object l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 23, .m_capacity = 23, .m_length = 22, .m_data = "A public declaration `"};
static const lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__10 = (const lean_object*)&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__10_value;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__11_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__11;
static const lean_string_object l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__12_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 68, .m_capacity = 68, .m_length = 67, .m_data = "` exists but is imported privately; consider adding `public import "};
static const lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__12 = (const lean_object*)&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__12_value;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__13_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__13;
static const lean_string_object l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__14_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "`."};
static const lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__14 = (const lean_object*)&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__14_value;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__15_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__15;
static const lean_string_object l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__16_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "` (from `"};
static const lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__16 = (const lean_object*)&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__16_value;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__17_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__17;
static const lean_string_object l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__18_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 54, .m_capacity = 54, .m_length = 53, .m_data = "`) exists but would need to be public to access here."};
static const lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__18 = (const lean_object*)&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__18_value;
static lean_once_cell_t l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__19_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__19;
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 19, .m_capacity = 19, .m_length = 18, .m_data = "Unknown constant `"};
static const lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__0 = (const lean_object*)&l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__0_value;
static lean_once_cell_t l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__1;
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7_spec__15___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__3___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__6___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static double l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__0;
static const lean_string_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 1, .m_capacity = 1, .m_length = 0, .m_data = ""};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__1 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__1_value;
static const lean_array_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__2 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__2_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Meta"};
static const lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__0 = (const lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__0_value;
static const lean_string_object l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__1 = (const lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__1_value;
static const lean_string_object l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "bv"};
static const lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__2 = (const lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__2_value;
static const lean_ctor_object l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__0_value),LEAN_SCALAR_PTR_LITERAL(211, 174, 49, 251, 64, 24, 251, 1)}};
static const lean_ctor_object l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3_value_aux_0),((lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__1_value),LEAN_SCALAR_PTR_LITERAL(194, 95, 140, 15, 16, 100, 236, 219)}};
static const lean_ctor_object l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3_value_aux_1),((lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__2_value),LEAN_SCALAR_PTR_LITERAL(139, 41, 106, 94, 234, 34, 111, 146)}};
static const lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3 = (const lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3_value;
static const lean_string_object l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trace"};
static const lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__4 = (const lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__4_value;
static const lean_ctor_object l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__4_value),LEAN_SCALAR_PTR_LITERAL(212, 145, 141, 177, 67, 149, 127, 197)}};
static const lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__5 = (const lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__5_value;
static lean_once_cell_t l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6;
static const lean_string_object l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 16, .m_capacity = 16, .m_length = 15, .m_data = "Using ext_iff: "};
static const lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__7 = (const lean_object*)&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__7_value;
static lean_once_cell_t l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__8_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__8;
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__7(lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__7___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__0;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__1;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__2;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__3;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__4;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__5;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__6;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__3(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__6(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7_spec__15(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__1(uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4_spec__5___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4___redArg(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg___closed__0;
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg(lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5___redArg(size_t, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "  ==>  "};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__0 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__0_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__1;
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__0___boxed, .m_arity = 11, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__0_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__0_value),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__0_value)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__1 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__1_value;
static const lean_closure_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__1___boxed, .m_arity = 10, .m_num_fixed = 1, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__1_value)} };
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__2 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__2_value;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2(lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5(lean_object*, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4_spec__5(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__0;
static const lean_closure_object l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Core_instMonadCoreM___lam__0___boxed, .m_arity = 5, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__1 = (const lean_object*)&l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__1_value;
static const lean_closure_object l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Core_instMonadCoreM___lam__1___boxed, .m_arity = 7, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__2 = (const lean_object*)&l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__2_value;
static const lean_closure_object l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_instMonadMetaM___lam__0___boxed, .m_arity = 7, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__3 = (const lean_object*)&l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__3_value;
static const lean_closure_object l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_instMonadMetaM___lam__1___boxed, .m_arity = 9, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__4 = (const lean_object*)&l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__4_value;
LEAN_EXPORT lean_object* l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 23, .m_capacity = 23, .m_length = 22, .m_data = "` is not a constructor"};
static const lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__0 = (const lean_object*)&l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__0_value;
static lean_once_cell_t l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__1;
static const lean_string_object l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 14, .m_capacity = 14, .m_length = 13, .m_data = "Lean.MonadEnv"};
static const lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__2 = (const lean_object*)&l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__2_value;
static const lean_string_object l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 13, .m_capacity = 13, .m_length = 12, .m_data = "Lean.isCtor\?"};
static const lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__3 = (const lean_object*)&l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__3_value;
static const lean_string_object l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 34, .m_capacity = 34, .m_length = 33, .m_data = "unreachable code has been reached"};
static const lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__4 = (const lean_object*)&l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__4_value;
static lean_once_cell_t l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__5;
LEAN_EXPORT lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg___boxed(lean_object*, lean_object*);
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 2, .m_capacity = 2, .m_length = 1, .m_data = "h"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___closed__0 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___closed__0_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(176, 181, 207, 77, 197, 87, 68, 121)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___closed__1 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___closed__1_value;
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5___redArg(lean_object*, lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2(lean_object*, lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9___redArg(lean_object*, lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3(lean_object*, lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 21, .m_capacity = 21, .m_length = 20, .m_data = "Learned hypothesis: "};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__0 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__0_value;
static lean_once_cell_t l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__1;
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg(lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_array_object l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1___boxed, .m_arity = 9, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 11, .m_capacity = 11, .m_length = 10, .m_data = "structures"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__1_value),LEAN_SCALAR_PTR_LITERAL(74, 214, 82, 86, 36, 11, 245, 232)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__2_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__2_value),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__0_value)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__3_value;
LEAN_EXPORT const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___closed__3_value;
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___boxed(lean_object**);
LEAN_EXPORT lean_object* l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5(lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5(lean_object*, lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9(lean_object*, lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0___redArg(lean_object* v_a_1_, lean_object* v_x_2_){
_start:
{
if (lean_obj_tag(v_x_2_) == 0)
{
lean_object* v___x_3_; 
v___x_3_ = lean_box(0);
return v___x_3_;
}
else
{
lean_object* v_key_4_; lean_object* v_value_5_; lean_object* v_tail_6_; uint8_t v___x_7_; 
v_key_4_ = lean_ctor_get(v_x_2_, 0);
v_value_5_ = lean_ctor_get(v_x_2_, 1);
v_tail_6_ = lean_ctor_get(v_x_2_, 2);
v___x_7_ = lean_name_eq(v_key_4_, v_a_1_);
if (v___x_7_ == 0)
{
v_x_2_ = v_tail_6_;
goto _start;
}
else
{
lean_object* v___x_9_; 
lean_inc(v_value_5_);
v___x_9_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_9_, 0, v_value_5_);
return v___x_9_;
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0___redArg___boxed(lean_object* v_a_10_, lean_object* v_x_11_){
_start:
{
lean_object* v_res_12_; 
v_res_12_ = l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0___redArg(v_a_10_, v_x_11_);
lean_dec(v_x_11_);
lean_dec(v_a_10_);
return v_res_12_;
}
}
static uint64_t _init_l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0(void){
_start:
{
lean_object* v___x_13_; uint64_t v___x_14_; 
v___x_13_ = lean_unsigned_to_nat(1723u);
v___x_14_ = lean_uint64_of_nat(v___x_13_);
return v___x_14_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg(lean_object* v_m_15_, lean_object* v_a_16_){
_start:
{
lean_object* v_buckets_17_; lean_object* v___x_18_; uint64_t v___y_20_; 
v_buckets_17_ = lean_ctor_get(v_m_15_, 1);
v___x_18_ = lean_array_get_size(v_buckets_17_);
if (lean_obj_tag(v_a_16_) == 0)
{
uint64_t v___x_34_; 
v___x_34_ = lean_uint64_once(&l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0, &l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0_once, _init_l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0);
v___y_20_ = v___x_34_;
goto v___jp_19_;
}
else
{
uint64_t v_hash_35_; 
v_hash_35_ = lean_ctor_get_uint64(v_a_16_, sizeof(void*)*2);
v___y_20_ = v_hash_35_;
goto v___jp_19_;
}
v___jp_19_:
{
uint64_t v___x_21_; uint64_t v___x_22_; uint64_t v_fold_23_; uint64_t v___x_24_; uint64_t v___x_25_; uint64_t v___x_26_; size_t v___x_27_; size_t v___x_28_; size_t v___x_29_; size_t v___x_30_; size_t v___x_31_; lean_object* v___x_32_; lean_object* v___x_33_; 
v___x_21_ = 32ULL;
v___x_22_ = lean_uint64_shift_right(v___y_20_, v___x_21_);
v_fold_23_ = lean_uint64_xor(v___y_20_, v___x_22_);
v___x_24_ = 16ULL;
v___x_25_ = lean_uint64_shift_right(v_fold_23_, v___x_24_);
v___x_26_ = lean_uint64_xor(v_fold_23_, v___x_25_);
v___x_27_ = lean_uint64_to_usize(v___x_26_);
v___x_28_ = lean_usize_of_nat(v___x_18_);
v___x_29_ = ((size_t)1ULL);
v___x_30_ = lean_usize_sub(v___x_28_, v___x_29_);
v___x_31_ = lean_usize_land(v___x_27_, v___x_30_);
v___x_32_ = lean_array_uget_borrowed(v_buckets_17_, v___x_31_);
v___x_33_ = l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0___redArg(v_a_16_, v___x_32_);
return v___x_33_;
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___boxed(lean_object* v_m_36_, lean_object* v_a_37_){
_start:
{
lean_object* v_res_38_; 
v_res_38_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg(v_m_36_, v_a_37_);
lean_dec(v_a_37_);
lean_dec_ref(v_m_36_);
return v_res_38_;
}
}
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg(lean_object* v_val_41_, lean_object* v_ctors_42_, lean_object* v_x_43_, lean_object* v_x_44_, lean_object* v_x_45_, lean_object* v___y_46_, lean_object* v___y_47_, lean_object* v___y_48_, lean_object* v___y_49_){
_start:
{
if (lean_obj_tag(v_x_43_) == 5)
{
lean_object* v_fn_51_; lean_object* v_arg_52_; lean_object* v___x_53_; lean_object* v___x_54_; lean_object* v___x_55_; 
v_fn_51_ = lean_ctor_get(v_x_43_, 0);
lean_inc_ref(v_fn_51_);
v_arg_52_ = lean_ctor_get(v_x_43_, 1);
lean_inc_ref(v_arg_52_);
lean_dec_ref_known(v_x_43_, 2);
v___x_53_ = lean_array_set(v_x_44_, v_x_45_, v_arg_52_);
v___x_54_ = lean_unsigned_to_nat(1u);
v___x_55_ = lean_nat_sub(v_x_45_, v___x_54_);
lean_dec(v_x_45_);
v_x_43_ = v_fn_51_;
v_x_44_ = v___x_53_;
v_x_45_ = v___x_55_;
goto _start;
}
else
{
lean_dec(v_x_45_);
if (lean_obj_tag(v_x_43_) == 4)
{
lean_object* v_declName_57_; lean_object* v_offset_58_; lean_object* v_ctorName_59_; uint8_t v___x_60_; 
v_declName_57_ = lean_ctor_get(v_x_43_, 0);
lean_inc(v_declName_57_);
lean_dec_ref_known(v_x_43_, 2);
v_offset_58_ = lean_ctor_get(v_val_41_, 1);
v_ctorName_59_ = lean_ctor_get(v_val_41_, 2);
v___x_60_ = lean_name_eq(v_declName_57_, v_ctorName_59_);
if (v___x_60_ == 0)
{
lean_object* v___x_61_; lean_object* v___x_62_; 
lean_dec(v_declName_57_);
lean_dec_ref(v_x_44_);
v___x_61_ = lean_alloc_ctor(0, 0, 2);
lean_ctor_set_uint8(v___x_61_, 0, v___x_60_);
lean_ctor_set_uint8(v___x_61_, 1, v___x_60_);
v___x_62_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_62_, 0, v___x_61_);
return v___x_62_;
}
else
{
lean_object* v___x_63_; 
v___x_63_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg(v_ctors_42_, v_declName_57_);
lean_dec(v_declName_57_);
if (lean_obj_tag(v___x_63_) == 1)
{
lean_object* v_val_64_; lean_object* v___x_66_; uint8_t v_isShared_67_; uint8_t v_isSharedCheck_95_; 
v_val_64_ = lean_ctor_get(v___x_63_, 0);
v_isSharedCheck_95_ = !lean_is_exclusive(v___x_63_);
if (v_isSharedCheck_95_ == 0)
{
v___x_66_ = v___x_63_;
v_isShared_67_ = v_isSharedCheck_95_;
goto v_resetjp_65_;
}
else
{
lean_inc(v_val_64_);
lean_dec(v___x_63_);
v___x_66_ = lean_box(0);
v_isShared_67_ = v_isSharedCheck_95_;
goto v_resetjp_65_;
}
v_resetjp_65_:
{
lean_object* v___x_68_; uint8_t v___x_69_; 
v___x_68_ = lean_array_get_size(v_x_44_);
v___x_69_ = lean_nat_dec_eq(v_val_64_, v___x_68_);
lean_dec(v_val_64_);
if (v___x_69_ == 0)
{
lean_object* v___x_70_; lean_object* v___x_72_; 
lean_dec_ref(v_x_44_);
v___x_70_ = lean_alloc_ctor(0, 0, 2);
lean_ctor_set_uint8(v___x_70_, 0, v___x_69_);
lean_ctor_set_uint8(v___x_70_, 1, v___x_69_);
if (v_isShared_67_ == 0)
{
lean_ctor_set_tag(v___x_66_, 0);
lean_ctor_set(v___x_66_, 0, v___x_70_);
v___x_72_ = v___x_66_;
goto v_reusejp_71_;
}
else
{
lean_object* v_reuseFailAlloc_73_; 
v_reuseFailAlloc_73_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_73_, 0, v___x_70_);
v___x_72_ = v_reuseFailAlloc_73_;
goto v_reusejp_71_;
}
v_reusejp_71_:
{
return v___x_72_;
}
}
else
{
lean_object* v___x_74_; lean_object* v_result_75_; lean_object* v___x_76_; 
lean_del_object(v___x_66_);
v___x_74_ = l_Lean_instInhabitedExpr;
v_result_75_ = lean_array_get(v___x_74_, v_x_44_, v_offset_58_);
lean_dec_ref(v_x_44_);
lean_inc(v_result_75_);
v___x_76_ = l_Lean_Meta_mkEqRefl(v_result_75_, v___y_46_, v___y_47_, v___y_48_, v___y_49_);
if (lean_obj_tag(v___x_76_) == 0)
{
lean_object* v_a_77_; lean_object* v___x_79_; uint8_t v_isShared_80_; uint8_t v_isSharedCheck_86_; 
v_a_77_ = lean_ctor_get(v___x_76_, 0);
v_isSharedCheck_86_ = !lean_is_exclusive(v___x_76_);
if (v_isSharedCheck_86_ == 0)
{
v___x_79_ = v___x_76_;
v_isShared_80_ = v_isSharedCheck_86_;
goto v_resetjp_78_;
}
else
{
lean_inc(v_a_77_);
lean_dec(v___x_76_);
v___x_79_ = lean_box(0);
v_isShared_80_ = v_isSharedCheck_86_;
goto v_resetjp_78_;
}
v_resetjp_78_:
{
uint8_t v___x_81_; lean_object* v___x_82_; lean_object* v___x_84_; 
v___x_81_ = 0;
v___x_82_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v___x_82_, 0, v_result_75_);
lean_ctor_set(v___x_82_, 1, v_a_77_);
lean_ctor_set_uint8(v___x_82_, sizeof(void*)*2, v___x_81_);
lean_ctor_set_uint8(v___x_82_, sizeof(void*)*2 + 1, v___x_81_);
if (v_isShared_80_ == 0)
{
lean_ctor_set(v___x_79_, 0, v___x_82_);
v___x_84_ = v___x_79_;
goto v_reusejp_83_;
}
else
{
lean_object* v_reuseFailAlloc_85_; 
v_reuseFailAlloc_85_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_85_, 0, v___x_82_);
v___x_84_ = v_reuseFailAlloc_85_;
goto v_reusejp_83_;
}
v_reusejp_83_:
{
return v___x_84_;
}
}
}
else
{
lean_object* v_a_87_; lean_object* v___x_89_; uint8_t v_isShared_90_; uint8_t v_isSharedCheck_94_; 
lean_dec(v_result_75_);
v_a_87_ = lean_ctor_get(v___x_76_, 0);
v_isSharedCheck_94_ = !lean_is_exclusive(v___x_76_);
if (v_isSharedCheck_94_ == 0)
{
v___x_89_ = v___x_76_;
v_isShared_90_ = v_isSharedCheck_94_;
goto v_resetjp_88_;
}
else
{
lean_inc(v_a_87_);
lean_dec(v___x_76_);
v___x_89_ = lean_box(0);
v_isShared_90_ = v_isSharedCheck_94_;
goto v_resetjp_88_;
}
v_resetjp_88_:
{
lean_object* v___x_92_; 
if (v_isShared_90_ == 0)
{
v___x_92_ = v___x_89_;
goto v_reusejp_91_;
}
else
{
lean_object* v_reuseFailAlloc_93_; 
v_reuseFailAlloc_93_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_93_, 0, v_a_87_);
v___x_92_ = v_reuseFailAlloc_93_;
goto v_reusejp_91_;
}
v_reusejp_91_:
{
return v___x_92_;
}
}
}
}
}
}
else
{
lean_object* v___x_96_; lean_object* v___x_97_; 
lean_dec(v___x_63_);
lean_dec_ref(v_x_44_);
v___x_96_ = ((lean_object*)(l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___closed__0));
v___x_97_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_97_, 0, v___x_96_);
return v___x_97_;
}
}
}
else
{
lean_object* v___x_98_; lean_object* v___x_99_; 
lean_dec_ref(v_x_44_);
lean_dec_ref(v_x_43_);
v___x_98_ = ((lean_object*)(l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___closed__0));
v___x_99_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_99_, 0, v___x_98_);
return v___x_99_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___boxed(lean_object* v_val_100_, lean_object* v_ctors_101_, lean_object* v_x_102_, lean_object* v_x_103_, lean_object* v_x_104_, lean_object* v___y_105_, lean_object* v___y_106_, lean_object* v___y_107_, lean_object* v___y_108_, lean_object* v___y_109_){
_start:
{
lean_object* v_res_110_; 
v_res_110_ = l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg(v_val_100_, v_ctors_101_, v_x_102_, v_x_103_, v_x_104_, v___y_105_, v___y_106_, v___y_107_, v___y_108_);
lean_dec(v___y_108_);
lean_dec_ref(v___y_107_);
lean_dec(v___y_106_);
lean_dec_ref(v___y_105_);
lean_dec_ref(v_ctors_101_);
lean_dec_ref(v_val_100_);
return v_res_110_;
}
}
static lean_object* _init_l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0(void){
_start:
{
lean_object* v___x_111_; lean_object* v_dummy_112_; 
v___x_111_ = lean_box(0);
v_dummy_112_ = l_Lean_Expr_sort___override(v___x_111_);
return v_dummy_112_;
}
}
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2(lean_object* v_projFns_113_, lean_object* v_ctors_114_, lean_object* v_x_115_, lean_object* v_x_116_, lean_object* v_x_117_, lean_object* v___y_118_, lean_object* v___y_119_, lean_object* v___y_120_, lean_object* v___y_121_, lean_object* v___y_122_, lean_object* v___y_123_, lean_object* v___y_124_, lean_object* v___y_125_, lean_object* v___y_126_){
_start:
{
if (lean_obj_tag(v_x_115_) == 5)
{
lean_object* v_fn_128_; lean_object* v_arg_129_; lean_object* v___x_130_; lean_object* v___x_131_; lean_object* v___x_132_; 
v_fn_128_ = lean_ctor_get(v_x_115_, 0);
lean_inc_ref(v_fn_128_);
v_arg_129_ = lean_ctor_get(v_x_115_, 1);
lean_inc_ref(v_arg_129_);
lean_dec_ref_known(v_x_115_, 2);
v___x_130_ = lean_array_set(v_x_116_, v_x_117_, v_arg_129_);
v___x_131_ = lean_unsigned_to_nat(1u);
v___x_132_ = lean_nat_sub(v_x_117_, v___x_131_);
lean_dec(v_x_117_);
v_x_115_ = v_fn_128_;
v_x_116_ = v___x_130_;
v_x_117_ = v___x_132_;
goto _start;
}
else
{
lean_dec(v_x_117_);
if (lean_obj_tag(v_x_115_) == 4)
{
lean_object* v_declName_134_; lean_object* v___x_135_; 
v_declName_134_ = lean_ctor_get(v_x_115_, 0);
lean_inc(v_declName_134_);
lean_dec_ref_known(v_x_115_, 2);
v___x_135_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg(v_projFns_113_, v_declName_134_);
lean_dec(v_declName_134_);
if (lean_obj_tag(v___x_135_) == 1)
{
lean_object* v_val_136_; lean_object* v___x_138_; uint8_t v_isShared_139_; uint8_t v_isSharedCheck_156_; 
v_val_136_ = lean_ctor_get(v___x_135_, 0);
v_isSharedCheck_156_ = !lean_is_exclusive(v___x_135_);
if (v_isSharedCheck_156_ == 0)
{
v___x_138_ = v___x_135_;
v_isShared_139_ = v_isSharedCheck_156_;
goto v_resetjp_137_;
}
else
{
lean_inc(v_val_136_);
lean_dec(v___x_135_);
v___x_138_ = lean_box(0);
v_isShared_139_ = v_isSharedCheck_156_;
goto v_resetjp_137_;
}
v_resetjp_137_:
{
lean_object* v_arity_140_; lean_object* v___x_141_; uint8_t v___x_142_; 
v_arity_140_ = lean_ctor_get(v_val_136_, 0);
v___x_141_ = lean_array_get_size(v_x_116_);
v___x_142_ = lean_nat_dec_eq(v___x_141_, v_arity_140_);
if (v___x_142_ == 0)
{
lean_object* v___x_143_; lean_object* v___x_145_; 
lean_dec(v_val_136_);
lean_dec_ref(v_x_116_);
v___x_143_ = lean_alloc_ctor(0, 0, 2);
lean_ctor_set_uint8(v___x_143_, 0, v___x_142_);
lean_ctor_set_uint8(v___x_143_, 1, v___x_142_);
if (v_isShared_139_ == 0)
{
lean_ctor_set_tag(v___x_138_, 0);
lean_ctor_set(v___x_138_, 0, v___x_143_);
v___x_145_ = v___x_138_;
goto v_reusejp_144_;
}
else
{
lean_object* v_reuseFailAlloc_146_; 
v_reuseFailAlloc_146_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_146_, 0, v___x_143_);
v___x_145_ = v_reuseFailAlloc_146_;
goto v_reusejp_144_;
}
v_reusejp_144_:
{
return v___x_145_;
}
}
else
{
lean_object* v___x_147_; lean_object* v___x_148_; lean_object* v___x_149_; lean_object* v_structArg_150_; lean_object* v_dummy_151_; lean_object* v_nargs_152_; lean_object* v___x_153_; lean_object* v___x_154_; lean_object* v___x_155_; 
lean_del_object(v___x_138_);
v___x_147_ = l_Lean_instInhabitedExpr;
v___x_148_ = lean_unsigned_to_nat(1u);
v___x_149_ = lean_nat_sub(v___x_141_, v___x_148_);
v_structArg_150_ = lean_array_get(v___x_147_, v_x_116_, v___x_149_);
lean_dec(v___x_149_);
lean_dec_ref(v_x_116_);
v_dummy_151_ = lean_obj_once(&l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0, &l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0_once, _init_l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0);
v_nargs_152_ = l_Lean_Expr_getAppNumArgs(v_structArg_150_);
lean_inc(v_nargs_152_);
v___x_153_ = lean_mk_array(v_nargs_152_, v_dummy_151_);
v___x_154_ = lean_nat_sub(v_nargs_152_, v___x_148_);
lean_dec(v_nargs_152_);
v___x_155_ = l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg(v_val_136_, v_ctors_114_, v_structArg_150_, v___x_153_, v___x_154_, v___y_123_, v___y_124_, v___y_125_, v___y_126_);
lean_dec(v_val_136_);
return v___x_155_;
}
}
}
else
{
lean_object* v___x_157_; lean_object* v___x_158_; 
lean_dec(v___x_135_);
lean_dec_ref(v_x_116_);
v___x_157_ = ((lean_object*)(l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___closed__0));
v___x_158_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_158_, 0, v___x_157_);
return v___x_158_;
}
}
else
{
lean_object* v___x_159_; lean_object* v___x_160_; 
lean_dec_ref(v_x_116_);
lean_dec_ref(v_x_115_);
v___x_159_ = ((lean_object*)(l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___closed__0));
v___x_160_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_160_, 0, v___x_159_);
return v___x_160_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___boxed(lean_object* v_projFns_161_, lean_object* v_ctors_162_, lean_object* v_x_163_, lean_object* v_x_164_, lean_object* v_x_165_, lean_object* v___y_166_, lean_object* v___y_167_, lean_object* v___y_168_, lean_object* v___y_169_, lean_object* v___y_170_, lean_object* v___y_171_, lean_object* v___y_172_, lean_object* v___y_173_, lean_object* v___y_174_, lean_object* v___y_175_){
_start:
{
lean_object* v_res_176_; 
v_res_176_ = l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2(v_projFns_161_, v_ctors_162_, v_x_163_, v_x_164_, v_x_165_, v___y_166_, v___y_167_, v___y_168_, v___y_169_, v___y_170_, v___y_171_, v___y_172_, v___y_173_, v___y_174_);
lean_dec(v___y_174_);
lean_dec_ref(v___y_173_);
lean_dec(v___y_172_);
lean_dec_ref(v___y_171_);
lean_dec(v___y_170_);
lean_dec_ref(v___y_169_);
lean_dec(v___y_168_);
lean_dec_ref(v___y_167_);
lean_dec(v___y_166_);
lean_dec_ref(v_ctors_162_);
lean_dec_ref(v_projFns_161_);
return v_res_176_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc(lean_object* v_projFns_177_, lean_object* v_ctors_178_, lean_object* v_e_179_, lean_object* v_a_180_, lean_object* v_a_181_, lean_object* v_a_182_, lean_object* v_a_183_, lean_object* v_a_184_, lean_object* v_a_185_, lean_object* v_a_186_, lean_object* v_a_187_, lean_object* v_a_188_){
_start:
{
lean_object* v_dummy_190_; lean_object* v_nargs_191_; lean_object* v___x_192_; lean_object* v___x_193_; lean_object* v___x_194_; lean_object* v___x_195_; 
v_dummy_190_ = lean_obj_once(&l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0, &l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0_once, _init_l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0);
v_nargs_191_ = l_Lean_Expr_getAppNumArgs(v_e_179_);
lean_inc(v_nargs_191_);
v___x_192_ = lean_mk_array(v_nargs_191_, v_dummy_190_);
v___x_193_ = lean_unsigned_to_nat(1u);
v___x_194_ = lean_nat_sub(v_nargs_191_, v___x_193_);
lean_dec(v_nargs_191_);
v___x_195_ = l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2(v_projFns_177_, v_ctors_178_, v_e_179_, v___x_192_, v___x_194_, v_a_180_, v_a_181_, v_a_182_, v_a_183_, v_a_184_, v_a_185_, v_a_186_, v_a_187_, v_a_188_);
return v___x_195_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc___boxed(lean_object* v_projFns_196_, lean_object* v_ctors_197_, lean_object* v_e_198_, lean_object* v_a_199_, lean_object* v_a_200_, lean_object* v_a_201_, lean_object* v_a_202_, lean_object* v_a_203_, lean_object* v_a_204_, lean_object* v_a_205_, lean_object* v_a_206_, lean_object* v_a_207_, lean_object* v_a_208_){
_start:
{
lean_object* v_res_209_; 
v_res_209_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc(v_projFns_196_, v_ctors_197_, v_e_198_, v_a_199_, v_a_200_, v_a_201_, v_a_202_, v_a_203_, v_a_204_, v_a_205_, v_a_206_, v_a_207_);
lean_dec(v_a_207_);
lean_dec_ref(v_a_206_);
lean_dec(v_a_205_);
lean_dec_ref(v_a_204_);
lean_dec(v_a_203_);
lean_dec_ref(v_a_202_);
lean_dec(v_a_201_);
lean_dec_ref(v_a_200_);
lean_dec(v_a_199_);
lean_dec_ref(v_ctors_197_);
lean_dec_ref(v_projFns_196_);
return v_res_209_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0(lean_object* v_00_u03b2_210_, lean_object* v_m_211_, lean_object* v_a_212_){
_start:
{
lean_object* v___x_213_; 
v___x_213_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg(v_m_211_, v_a_212_);
return v___x_213_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___boxed(lean_object* v_00_u03b2_214_, lean_object* v_m_215_, lean_object* v_a_216_){
_start:
{
lean_object* v_res_217_; 
v_res_217_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0(v_00_u03b2_214_, v_m_215_, v_a_216_);
lean_dec(v_a_216_);
lean_dec_ref(v_m_215_);
return v_res_217_;
}
}
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1(lean_object* v_val_218_, lean_object* v_ctors_219_, lean_object* v_x_220_, lean_object* v_x_221_, lean_object* v_x_222_, lean_object* v___y_223_, lean_object* v___y_224_, lean_object* v___y_225_, lean_object* v___y_226_, lean_object* v___y_227_, lean_object* v___y_228_, lean_object* v___y_229_, lean_object* v___y_230_, lean_object* v___y_231_){
_start:
{
lean_object* v___x_233_; 
v___x_233_ = l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg(v_val_218_, v_ctors_219_, v_x_220_, v_x_221_, v_x_222_, v___y_228_, v___y_229_, v___y_230_, v___y_231_);
return v___x_233_;
}
}
LEAN_EXPORT lean_object* l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___boxed(lean_object* v_val_234_, lean_object* v_ctors_235_, lean_object* v_x_236_, lean_object* v_x_237_, lean_object* v_x_238_, lean_object* v___y_239_, lean_object* v___y_240_, lean_object* v___y_241_, lean_object* v___y_242_, lean_object* v___y_243_, lean_object* v___y_244_, lean_object* v___y_245_, lean_object* v___y_246_, lean_object* v___y_247_, lean_object* v___y_248_){
_start:
{
lean_object* v_res_249_; 
v_res_249_ = l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1(v_val_234_, v_ctors_235_, v_x_236_, v_x_237_, v_x_238_, v___y_239_, v___y_240_, v___y_241_, v___y_242_, v___y_243_, v___y_244_, v___y_245_, v___y_246_, v___y_247_);
lean_dec(v___y_247_);
lean_dec_ref(v___y_246_);
lean_dec(v___y_245_);
lean_dec_ref(v___y_244_);
lean_dec(v___y_243_);
lean_dec_ref(v___y_242_);
lean_dec(v___y_241_);
lean_dec_ref(v___y_240_);
lean_dec(v___y_239_);
lean_dec_ref(v_ctors_235_);
lean_dec_ref(v_val_234_);
return v_res_249_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0(lean_object* v_00_u03b2_250_, lean_object* v_a_251_, lean_object* v_x_252_){
_start:
{
lean_object* v___x_253_; 
v___x_253_ = l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0___redArg(v_a_251_, v_x_252_);
return v___x_253_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0___boxed(lean_object* v_00_u03b2_254_, lean_object* v_a_255_, lean_object* v_x_256_){
_start:
{
lean_object* v_res_257_; 
v_res_257_ = l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0_spec__0(v_00_u03b2_254_, v_a_255_, v_x_256_);
lean_dec(v_x_256_);
lean_dec(v_a_255_);
return v_res_257_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_mkConstAppWithMVars(lean_object* v_declName_258_, lean_object* v_a_259_, lean_object* v_a_260_, lean_object* v_a_261_, lean_object* v_a_262_){
_start:
{
lean_object* v___x_264_; 
v___x_264_ = l_Lean_Meta_mkConstWithFreshMVarLevels(v_declName_258_, v_a_259_, v_a_260_, v_a_261_, v_a_262_);
if (lean_obj_tag(v___x_264_) == 0)
{
lean_object* v_a_265_; lean_object* v___x_266_; 
v_a_265_ = lean_ctor_get(v___x_264_, 0);
lean_inc_n(v_a_265_, 2);
lean_dec_ref_known(v___x_264_, 1);
lean_inc(v_a_262_);
lean_inc_ref(v_a_261_);
lean_inc(v_a_260_);
lean_inc_ref(v_a_259_);
v___x_266_ = lean_infer_type(v_a_265_, v_a_259_, v_a_260_, v_a_261_, v_a_262_);
if (lean_obj_tag(v___x_266_) == 0)
{
lean_object* v_a_267_; lean_object* v___x_268_; uint8_t v___x_269_; lean_object* v___x_270_; 
v_a_267_ = lean_ctor_get(v___x_266_, 0);
lean_inc(v_a_267_);
lean_dec_ref_known(v___x_266_, 1);
v___x_268_ = lean_box(0);
v___x_269_ = 0;
v___x_270_ = l_Lean_Meta_forallMetaTelescopeReducing(v_a_267_, v___x_268_, v___x_269_, v_a_259_, v_a_260_, v_a_261_, v_a_262_);
if (lean_obj_tag(v___x_270_) == 0)
{
lean_object* v_a_271_; lean_object* v___x_273_; uint8_t v_isShared_274_; uint8_t v_isSharedCheck_280_; 
v_a_271_ = lean_ctor_get(v___x_270_, 0);
v_isSharedCheck_280_ = !lean_is_exclusive(v___x_270_);
if (v_isSharedCheck_280_ == 0)
{
v___x_273_ = v___x_270_;
v_isShared_274_ = v_isSharedCheck_280_;
goto v_resetjp_272_;
}
else
{
lean_inc(v_a_271_);
lean_dec(v___x_270_);
v___x_273_ = lean_box(0);
v_isShared_274_ = v_isSharedCheck_280_;
goto v_resetjp_272_;
}
v_resetjp_272_:
{
lean_object* v_fst_275_; lean_object* v___x_276_; lean_object* v___x_278_; 
v_fst_275_ = lean_ctor_get(v_a_271_, 0);
lean_inc(v_fst_275_);
lean_dec(v_a_271_);
v___x_276_ = l_Lean_mkAppN(v_a_265_, v_fst_275_);
lean_dec(v_fst_275_);
if (v_isShared_274_ == 0)
{
lean_ctor_set(v___x_273_, 0, v___x_276_);
v___x_278_ = v___x_273_;
goto v_reusejp_277_;
}
else
{
lean_object* v_reuseFailAlloc_279_; 
v_reuseFailAlloc_279_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_279_, 0, v___x_276_);
v___x_278_ = v_reuseFailAlloc_279_;
goto v_reusejp_277_;
}
v_reusejp_277_:
{
return v___x_278_;
}
}
}
else
{
lean_object* v_a_281_; lean_object* v___x_283_; uint8_t v_isShared_284_; uint8_t v_isSharedCheck_288_; 
lean_dec(v_a_265_);
v_a_281_ = lean_ctor_get(v___x_270_, 0);
v_isSharedCheck_288_ = !lean_is_exclusive(v___x_270_);
if (v_isSharedCheck_288_ == 0)
{
v___x_283_ = v___x_270_;
v_isShared_284_ = v_isSharedCheck_288_;
goto v_resetjp_282_;
}
else
{
lean_inc(v_a_281_);
lean_dec(v___x_270_);
v___x_283_ = lean_box(0);
v_isShared_284_ = v_isSharedCheck_288_;
goto v_resetjp_282_;
}
v_resetjp_282_:
{
lean_object* v___x_286_; 
if (v_isShared_284_ == 0)
{
v___x_286_ = v___x_283_;
goto v_reusejp_285_;
}
else
{
lean_object* v_reuseFailAlloc_287_; 
v_reuseFailAlloc_287_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_287_, 0, v_a_281_);
v___x_286_ = v_reuseFailAlloc_287_;
goto v_reusejp_285_;
}
v_reusejp_285_:
{
return v___x_286_;
}
}
}
}
else
{
lean_dec(v_a_265_);
return v___x_266_;
}
}
else
{
return v___x_264_;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_mkConstAppWithMVars___boxed(lean_object* v_declName_289_, lean_object* v_a_290_, lean_object* v_a_291_, lean_object* v_a_292_, lean_object* v_a_293_, lean_object* v_a_294_){
_start:
{
lean_object* v_res_295_; 
v_res_295_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_mkConstAppWithMVars(v_declName_289_, v_a_290_, v_a_291_, v_a_292_, v_a_293_);
lean_dec(v_a_293_);
lean_dec_ref(v_a_292_);
lean_dec(v_a_291_);
lean_dec_ref(v_a_290_);
return v_res_295_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_InsertionSort_0__Array_insertionSort_swapLoop___at___00__private_Init_Data_Array_InsertionSort_0__Array_insertionSort_traverse___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__1_spec__2___redArg(lean_object* v_xs_296_, lean_object* v_j_297_){
_start:
{
lean_object* v_zero_298_; uint8_t v_isZero_299_; 
v_zero_298_ = lean_unsigned_to_nat(0u);
v_isZero_299_ = lean_nat_dec_eq(v_j_297_, v_zero_298_);
if (v_isZero_299_ == 1)
{
lean_dec(v_j_297_);
return v_xs_296_;
}
else
{
lean_object* v___x_300_; lean_object* v_priority_301_; lean_object* v_one_302_; lean_object* v_n_303_; lean_object* v___x_304_; lean_object* v_priority_305_; uint8_t v___x_306_; 
v___x_300_ = lean_array_fget_borrowed(v_xs_296_, v_j_297_);
v_priority_301_ = lean_ctor_get(v___x_300_, 1);
v_one_302_ = lean_unsigned_to_nat(1u);
v_n_303_ = lean_nat_sub(v_j_297_, v_one_302_);
v___x_304_ = lean_array_fget_borrowed(v_xs_296_, v_n_303_);
v_priority_305_ = lean_ctor_get(v___x_304_, 1);
v___x_306_ = lean_nat_dec_lt(v_priority_301_, v_priority_305_);
if (v___x_306_ == 0)
{
lean_dec(v_n_303_);
lean_dec(v_j_297_);
return v_xs_296_;
}
else
{
lean_object* v___x_307_; 
v___x_307_ = lean_array_fswap(v_xs_296_, v_j_297_, v_n_303_);
lean_dec(v_j_297_);
v_xs_296_ = v___x_307_;
v_j_297_ = v_n_303_;
goto _start;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_InsertionSort_0__Array_insertionSort_traverse___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__1(lean_object* v_xs_309_, lean_object* v_i_310_, lean_object* v_fuel_311_){
_start:
{
lean_object* v_zero_312_; uint8_t v_isZero_313_; 
v_zero_312_ = lean_unsigned_to_nat(0u);
v_isZero_313_ = lean_nat_dec_eq(v_fuel_311_, v_zero_312_);
if (v_isZero_313_ == 1)
{
lean_dec(v_fuel_311_);
lean_dec(v_i_310_);
return v_xs_309_;
}
else
{
lean_object* v___x_314_; uint8_t v___x_315_; 
v___x_314_ = lean_array_get_size(v_xs_309_);
v___x_315_ = lean_nat_dec_lt(v_i_310_, v___x_314_);
if (v___x_315_ == 0)
{
lean_dec(v_fuel_311_);
lean_dec(v_i_310_);
return v_xs_309_;
}
else
{
lean_object* v_one_316_; lean_object* v_n_317_; lean_object* v___x_318_; lean_object* v___x_319_; 
v_one_316_ = lean_unsigned_to_nat(1u);
v_n_317_ = lean_nat_sub(v_fuel_311_, v_one_316_);
lean_dec(v_fuel_311_);
lean_inc(v_i_310_);
v___x_318_ = l___private_Init_Data_Array_InsertionSort_0__Array_insertionSort_swapLoop___at___00__private_Init_Data_Array_InsertionSort_0__Array_insertionSort_traverse___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__1_spec__2___redArg(v_xs_309_, v_i_310_);
v___x_319_ = lean_nat_add(v_i_310_, v_one_316_);
lean_dec(v_i_310_);
v_xs_309_ = v___x_318_;
v_i_310_ = v___x_319_;
v_fuel_311_ = v_n_317_;
goto _start;
}
}
}
}
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1___redArg(lean_object* v_keys_321_, lean_object* v_i_322_, lean_object* v_k_323_){
_start:
{
lean_object* v___x_324_; uint8_t v___x_325_; 
v___x_324_ = lean_array_get_size(v_keys_321_);
v___x_325_ = lean_nat_dec_lt(v_i_322_, v___x_324_);
if (v___x_325_ == 0)
{
lean_dec(v_i_322_);
return v___x_325_;
}
else
{
lean_object* v_k_x27_326_; uint8_t v___x_327_; 
v_k_x27_326_ = lean_array_fget_borrowed(v_keys_321_, v_i_322_);
v___x_327_ = lean_name_eq(v_k_323_, v_k_x27_326_);
if (v___x_327_ == 0)
{
lean_object* v___x_328_; lean_object* v___x_329_; 
v___x_328_ = lean_unsigned_to_nat(1u);
v___x_329_ = lean_nat_add(v_i_322_, v___x_328_);
lean_dec(v_i_322_);
v_i_322_ = v___x_329_;
goto _start;
}
else
{
lean_dec(v_i_322_);
return v___x_327_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1___redArg___boxed(lean_object* v_keys_331_, lean_object* v_i_332_, lean_object* v_k_333_){
_start:
{
uint8_t v_res_334_; lean_object* v_r_335_; 
v_res_334_ = l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1___redArg(v_keys_331_, v_i_332_, v_k_333_);
lean_dec(v_k_333_);
lean_dec_ref(v_keys_331_);
v_r_335_ = lean_box(v_res_334_);
return v_r_335_;
}
}
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0___redArg(lean_object* v_x_336_, size_t v_x_337_, lean_object* v_x_338_){
_start:
{
if (lean_obj_tag(v_x_336_) == 0)
{
lean_object* v_es_339_; lean_object* v___x_340_; size_t v___x_341_; size_t v___x_342_; lean_object* v_j_343_; lean_object* v___x_344_; 
v_es_339_ = lean_ctor_get(v_x_336_, 0);
v___x_340_ = lean_box(2);
v___x_341_ = ((size_t)31ULL);
v___x_342_ = lean_usize_land(v_x_337_, v___x_341_);
v_j_343_ = lean_usize_to_nat(v___x_342_);
v___x_344_ = lean_array_get_borrowed(v___x_340_, v_es_339_, v_j_343_);
lean_dec(v_j_343_);
switch(lean_obj_tag(v___x_344_))
{
case 0:
{
lean_object* v_key_345_; uint8_t v___x_346_; 
v_key_345_ = lean_ctor_get(v___x_344_, 0);
v___x_346_ = lean_name_eq(v_x_338_, v_key_345_);
return v___x_346_;
}
case 1:
{
lean_object* v_node_347_; size_t v___x_348_; size_t v___x_349_; 
v_node_347_ = lean_ctor_get(v___x_344_, 0);
v___x_348_ = ((size_t)5ULL);
v___x_349_ = lean_usize_shift_right(v_x_337_, v___x_348_);
v_x_336_ = v_node_347_;
v_x_337_ = v___x_349_;
goto _start;
}
default: 
{
uint8_t v___x_351_; 
v___x_351_ = 0;
return v___x_351_;
}
}
}
else
{
lean_object* v_ks_352_; lean_object* v___x_353_; uint8_t v___x_354_; 
v_ks_352_ = lean_ctor_get(v_x_336_, 0);
v___x_353_ = lean_unsigned_to_nat(0u);
v___x_354_ = l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1___redArg(v_ks_352_, v___x_353_, v_x_338_);
return v___x_354_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0___redArg___boxed(lean_object* v_x_355_, lean_object* v_x_356_, lean_object* v_x_357_){
_start:
{
size_t v_x_1610__boxed_358_; uint8_t v_res_359_; lean_object* v_r_360_; 
v_x_1610__boxed_358_ = lean_unbox_usize(v_x_356_);
lean_dec(v_x_356_);
v_res_359_ = l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0___redArg(v_x_355_, v_x_1610__boxed_358_, v_x_357_);
lean_dec(v_x_357_);
lean_dec_ref(v_x_355_);
v_r_360_ = lean_box(v_res_359_);
return v_r_360_;
}
}
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0___redArg(lean_object* v_x_361_, lean_object* v_x_362_){
_start:
{
uint64_t v___y_364_; 
if (lean_obj_tag(v_x_362_) == 0)
{
uint64_t v___x_367_; 
v___x_367_ = lean_uint64_once(&l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0, &l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0_once, _init_l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0);
v___y_364_ = v___x_367_;
goto v___jp_363_;
}
else
{
uint64_t v_hash_368_; 
v_hash_368_ = lean_ctor_get_uint64(v_x_362_, sizeof(void*)*2);
v___y_364_ = v_hash_368_;
goto v___jp_363_;
}
v___jp_363_:
{
size_t v___x_365_; uint8_t v___x_366_; 
v___x_365_ = lean_uint64_to_usize(v___y_364_);
v___x_366_ = l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0___redArg(v_x_361_, v___x_365_, v_x_362_);
return v___x_366_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0___redArg___boxed(lean_object* v_x_369_, lean_object* v_x_370_){
_start:
{
uint8_t v_res_371_; lean_object* v_r_372_; 
v_res_371_ = l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0___redArg(v_x_369_, v_x_370_);
lean_dec(v_x_370_);
lean_dec_ref(v_x_369_);
v_r_372_ = lean_box(v_res_371_);
return v_r_372_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__2(lean_object* v___x_373_, lean_object* v_as_374_, size_t v_i_375_, size_t v_stop_376_, lean_object* v_b_377_){
_start:
{
lean_object* v___y_379_; uint8_t v___x_383_; 
v___x_383_ = lean_usize_dec_eq(v_i_375_, v_stop_376_);
if (v___x_383_ == 0)
{
lean_object* v_erased_384_; lean_object* v___x_385_; lean_object* v_declName_386_; uint8_t v___x_387_; 
v_erased_384_ = lean_ctor_get(v___x_373_, 1);
v___x_385_ = lean_array_uget_borrowed(v_as_374_, v_i_375_);
v_declName_386_ = lean_ctor_get(v___x_385_, 0);
v___x_387_ = l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0___redArg(v_erased_384_, v_declName_386_);
if (v___x_387_ == 0)
{
lean_object* v___x_388_; 
lean_inc(v___x_385_);
v___x_388_ = lean_array_push(v_b_377_, v___x_385_);
v___y_379_ = v___x_388_;
goto v___jp_378_;
}
else
{
v___y_379_ = v_b_377_;
goto v___jp_378_;
}
}
else
{
return v_b_377_;
}
v___jp_378_:
{
size_t v___x_380_; size_t v___x_381_; 
v___x_380_ = ((size_t)1ULL);
v___x_381_ = lean_usize_add(v_i_375_, v___x_380_);
v_i_375_ = v___x_381_;
v_b_377_ = v___y_379_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__2___boxed(lean_object* v___x_389_, lean_object* v_as_390_, lean_object* v_i_391_, lean_object* v_stop_392_, lean_object* v_b_393_){
_start:
{
size_t v_i_boxed_394_; size_t v_stop_boxed_395_; lean_object* v_res_396_; 
v_i_boxed_394_ = lean_unbox_usize(v_i_391_);
lean_dec(v_i_391_);
v_stop_boxed_395_ = lean_unbox_usize(v_stop_392_);
lean_dec(v_stop_392_);
v_res_396_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__2(v___x_389_, v_as_390_, v_i_boxed_394_, v_stop_boxed_395_, v_b_393_);
lean_dec_ref(v_as_390_);
lean_dec_ref(v___x_389_);
return v_res_396_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f(lean_object* v_info_400_, lean_object* v_a_401_, lean_object* v_a_402_, lean_object* v_a_403_, lean_object* v_a_404_){
_start:
{
lean_object* v_a_407_; lean_object* v_toConstantVal_431_; lean_object* v_name_432_; lean_object* v___x_433_; 
v_toConstantVal_431_ = lean_ctor_get(v_info_400_, 0);
lean_inc_ref(v_toConstantVal_431_);
lean_dec_ref(v_info_400_);
v_name_432_ = lean_ctor_get(v_toConstantVal_431_, 0);
lean_inc(v_name_432_);
lean_dec_ref(v_toConstantVal_431_);
v___x_433_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_mkConstAppWithMVars(v_name_432_, v_a_401_, v_a_402_, v_a_403_, v_a_404_);
if (lean_obj_tag(v___x_433_) == 0)
{
lean_object* v_a_434_; lean_object* v___x_435_; lean_object* v_env_436_; lean_object* v___x_437_; lean_object* v_ext_438_; lean_object* v_toEnvExtension_439_; lean_object* v_asyncMode_440_; lean_object* v___x_441_; lean_object* v___x_442_; lean_object* v_tree_443_; lean_object* v___x_444_; 
v_a_434_ = lean_ctor_get(v___x_433_, 0);
lean_inc(v_a_434_);
lean_dec_ref_known(v___x_433_, 1);
v___x_435_ = lean_st_ref_get(v_a_404_);
v_env_436_ = lean_ctor_get(v___x_435_, 0);
lean_inc_ref(v_env_436_);
lean_dec(v___x_435_);
v___x_437_ = l_Lean_Meta_Ext_extExtension;
v_ext_438_ = lean_ctor_get(v___x_437_, 1);
v_toEnvExtension_439_ = lean_ctor_get(v_ext_438_, 0);
v_asyncMode_440_ = lean_ctor_get(v_toEnvExtension_439_, 2);
v___x_441_ = l_Lean_Meta_Ext_instInhabitedExtTheorems_default;
v___x_442_ = l_Lean_ScopedEnvExtension_getState___redArg(v___x_441_, v___x_437_, v_env_436_, v_asyncMode_440_);
v_tree_443_ = lean_ctor_get(v___x_442_, 0);
lean_inc_ref(v_tree_443_);
v___x_444_ = l_Lean_Meta_DiscrTree_getMatch___redArg(v_tree_443_, v_a_434_, v_a_401_, v_a_402_, v_a_403_, v_a_404_);
lean_dec_ref(v_tree_443_);
if (lean_obj_tag(v___x_444_) == 0)
{
lean_object* v_a_445_; lean_object* v___y_447_; lean_object* v___x_452_; lean_object* v___x_453_; lean_object* v___x_454_; uint8_t v___x_455_; 
v_a_445_ = lean_ctor_get(v___x_444_, 0);
lean_inc(v_a_445_);
lean_dec_ref_known(v___x_444_, 1);
v___x_452_ = lean_unsigned_to_nat(0u);
v___x_453_ = lean_array_get_size(v_a_445_);
v___x_454_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___closed__1));
v___x_455_ = lean_nat_dec_lt(v___x_452_, v___x_453_);
if (v___x_455_ == 0)
{
lean_dec(v_a_445_);
lean_dec(v___x_442_);
v___y_447_ = v___x_454_;
goto v___jp_446_;
}
else
{
uint8_t v___x_456_; 
v___x_456_ = lean_nat_dec_le(v___x_453_, v___x_453_);
if (v___x_456_ == 0)
{
if (v___x_455_ == 0)
{
lean_dec(v_a_445_);
lean_dec(v___x_442_);
v___y_447_ = v___x_454_;
goto v___jp_446_;
}
else
{
size_t v___x_457_; size_t v___x_458_; lean_object* v___x_459_; 
v___x_457_ = ((size_t)0ULL);
v___x_458_ = lean_usize_of_nat(v___x_453_);
v___x_459_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__2(v___x_442_, v_a_445_, v___x_457_, v___x_458_, v___x_454_);
lean_dec(v_a_445_);
lean_dec(v___x_442_);
v___y_447_ = v___x_459_;
goto v___jp_446_;
}
}
else
{
size_t v___x_460_; size_t v___x_461_; lean_object* v___x_462_; 
v___x_460_ = ((size_t)0ULL);
v___x_461_ = lean_usize_of_nat(v___x_453_);
v___x_462_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__2(v___x_442_, v_a_445_, v___x_460_, v___x_461_, v___x_454_);
lean_dec(v_a_445_);
lean_dec(v___x_442_);
v___y_447_ = v___x_462_;
goto v___jp_446_;
}
}
v___jp_446_:
{
lean_object* v___x_448_; lean_object* v___x_449_; lean_object* v___x_450_; lean_object* v___x_451_; 
v___x_448_ = lean_unsigned_to_nat(0u);
v___x_449_ = lean_array_get_size(v___y_447_);
v___x_450_ = l___private_Init_Data_Array_InsertionSort_0__Array_insertionSort_traverse___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__1(v___y_447_, v___x_448_, v___x_449_);
v___x_451_ = l_Array_reverse___redArg(v___x_450_);
v_a_407_ = v___x_451_;
goto v___jp_406_;
}
}
else
{
lean_dec(v___x_442_);
if (lean_obj_tag(v___x_444_) == 0)
{
lean_object* v_a_463_; 
v_a_463_ = lean_ctor_get(v___x_444_, 0);
lean_inc(v_a_463_);
lean_dec_ref_known(v___x_444_, 1);
v_a_407_ = v_a_463_;
goto v___jp_406_;
}
else
{
lean_object* v_a_464_; lean_object* v___x_466_; uint8_t v_isShared_467_; uint8_t v_isSharedCheck_471_; 
v_a_464_ = lean_ctor_get(v___x_444_, 0);
v_isSharedCheck_471_ = !lean_is_exclusive(v___x_444_);
if (v_isSharedCheck_471_ == 0)
{
v___x_466_ = v___x_444_;
v_isShared_467_ = v_isSharedCheck_471_;
goto v_resetjp_465_;
}
else
{
lean_inc(v_a_464_);
lean_dec(v___x_444_);
v___x_466_ = lean_box(0);
v_isShared_467_ = v_isSharedCheck_471_;
goto v_resetjp_465_;
}
v_resetjp_465_:
{
lean_object* v___x_469_; 
if (v_isShared_467_ == 0)
{
v___x_469_ = v___x_466_;
goto v_reusejp_468_;
}
else
{
lean_object* v_reuseFailAlloc_470_; 
v_reuseFailAlloc_470_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_470_, 0, v_a_464_);
v___x_469_ = v_reuseFailAlloc_470_;
goto v_reusejp_468_;
}
v_reusejp_468_:
{
return v___x_469_;
}
}
}
}
}
else
{
lean_object* v_a_472_; lean_object* v___x_474_; uint8_t v_isShared_475_; uint8_t v_isSharedCheck_479_; 
v_a_472_ = lean_ctor_get(v___x_433_, 0);
v_isSharedCheck_479_ = !lean_is_exclusive(v___x_433_);
if (v_isSharedCheck_479_ == 0)
{
v___x_474_ = v___x_433_;
v_isShared_475_ = v_isSharedCheck_479_;
goto v_resetjp_473_;
}
else
{
lean_inc(v_a_472_);
lean_dec(v___x_433_);
v___x_474_ = lean_box(0);
v_isShared_475_ = v_isSharedCheck_479_;
goto v_resetjp_473_;
}
v_resetjp_473_:
{
lean_object* v___x_477_; 
if (v_isShared_475_ == 0)
{
v___x_477_ = v___x_474_;
goto v_reusejp_476_;
}
else
{
lean_object* v_reuseFailAlloc_478_; 
v_reuseFailAlloc_478_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_478_, 0, v_a_472_);
v___x_477_ = v_reuseFailAlloc_478_;
goto v_reusejp_476_;
}
v_reusejp_476_:
{
return v___x_477_;
}
}
}
v___jp_406_:
{
lean_object* v___x_408_; lean_object* v___x_409_; uint8_t v___x_410_; 
v___x_408_ = lean_array_get_size(v_a_407_);
v___x_409_ = lean_unsigned_to_nat(0u);
v___x_410_ = lean_nat_dec_eq(v___x_408_, v___x_409_);
if (v___x_410_ == 0)
{
lean_object* v___x_411_; lean_object* v___x_412_; lean_object* v_declName_413_; 
v___x_411_ = l_Lean_Meta_Ext_instInhabitedExtTheorem_default;
v___x_412_ = lean_array_get(v___x_411_, v_a_407_, v___x_409_);
lean_dec_ref(v_a_407_);
v_declName_413_ = lean_ctor_get(v___x_412_, 0);
lean_inc(v_declName_413_);
lean_dec(v___x_412_);
if (lean_obj_tag(v_declName_413_) == 1)
{
lean_object* v_pre_414_; lean_object* v_str_415_; lean_object* v___x_416_; lean_object* v_env_417_; uint8_t v___x_418_; lean_object* v___x_419_; lean_object* v___x_420_; lean_object* v___x_421_; uint8_t v___x_422_; 
v_pre_414_ = lean_ctor_get(v_declName_413_, 0);
lean_inc(v_pre_414_);
v_str_415_ = lean_ctor_get(v_declName_413_, 1);
lean_inc_ref(v_str_415_);
lean_dec_ref_known(v_declName_413_, 2);
v___x_416_ = lean_st_ref_get(v_a_404_);
v_env_417_ = lean_ctor_get(v___x_416_, 0);
lean_inc_ref(v_env_417_);
lean_dec(v___x_416_);
v___x_418_ = 1;
v___x_419_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___closed__0));
v___x_420_ = lean_string_append(v_str_415_, v___x_419_);
v___x_421_ = l_Lean_Name_str___override(v_pre_414_, v___x_420_);
lean_inc(v___x_421_);
v___x_422_ = l_Lean_Environment_contains(v_env_417_, v___x_421_, v___x_418_);
if (v___x_422_ == 0)
{
lean_object* v___x_423_; lean_object* v___x_424_; 
lean_dec(v___x_421_);
v___x_423_ = lean_box(0);
v___x_424_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_424_, 0, v___x_423_);
return v___x_424_;
}
else
{
lean_object* v___x_425_; lean_object* v___x_426_; 
v___x_425_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_425_, 0, v___x_421_);
v___x_426_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_426_, 0, v___x_425_);
return v___x_426_;
}
}
else
{
lean_object* v___x_427_; lean_object* v___x_428_; 
lean_dec(v_declName_413_);
v___x_427_ = lean_box(0);
v___x_428_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_428_, 0, v___x_427_);
return v___x_428_;
}
}
else
{
lean_object* v___x_429_; lean_object* v___x_430_; 
lean_dec_ref(v_a_407_);
v___x_429_ = lean_box(0);
v___x_430_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_430_, 0, v___x_429_);
return v___x_430_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f___boxed(lean_object* v_info_480_, lean_object* v_a_481_, lean_object* v_a_482_, lean_object* v_a_483_, lean_object* v_a_484_, lean_object* v_a_485_){
_start:
{
lean_object* v_res_486_; 
v_res_486_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f(v_info_480_, v_a_481_, v_a_482_, v_a_483_, v_a_484_);
lean_dec(v_a_484_);
lean_dec_ref(v_a_483_);
lean_dec(v_a_482_);
lean_dec_ref(v_a_481_);
return v_res_486_;
}
}
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0(lean_object* v_00_u03b2_487_, lean_object* v_x_488_, lean_object* v_x_489_){
_start:
{
uint8_t v___x_490_; 
v___x_490_ = l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0___redArg(v_x_488_, v_x_489_);
return v___x_490_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0___boxed(lean_object* v_00_u03b2_491_, lean_object* v_x_492_, lean_object* v_x_493_){
_start:
{
uint8_t v_res_494_; lean_object* v_r_495_; 
v_res_494_ = l_Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0(v_00_u03b2_491_, v_x_492_, v_x_493_);
lean_dec(v_x_493_);
lean_dec_ref(v_x_492_);
v_r_495_ = lean_box(v_res_494_);
return v_r_495_;
}
}
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0(lean_object* v_00_u03b2_496_, lean_object* v_x_497_, size_t v_x_498_, lean_object* v_x_499_){
_start:
{
uint8_t v___x_500_; 
v___x_500_ = l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0___redArg(v_x_497_, v_x_498_, v_x_499_);
return v___x_500_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0___boxed(lean_object* v_00_u03b2_501_, lean_object* v_x_502_, lean_object* v_x_503_, lean_object* v_x_504_){
_start:
{
size_t v_x_1841__boxed_505_; uint8_t v_res_506_; lean_object* v_r_507_; 
v_x_1841__boxed_505_ = lean_unbox_usize(v_x_503_);
lean_dec(v_x_503_);
v_res_506_ = l_Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0(v_00_u03b2_501_, v_x_502_, v_x_1841__boxed_505_, v_x_504_);
lean_dec(v_x_504_);
lean_dec_ref(v_x_502_);
v_r_507_ = lean_box(v_res_506_);
return v_r_507_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_InsertionSort_0__Array_insertionSort_swapLoop___at___00__private_Init_Data_Array_InsertionSort_0__Array_insertionSort_traverse___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__1_spec__2(lean_object* v_xs_508_, lean_object* v_j_509_, lean_object* v_h_510_){
_start:
{
lean_object* v___x_511_; 
v___x_511_ = l___private_Init_Data_Array_InsertionSort_0__Array_insertionSort_swapLoop___at___00__private_Init_Data_Array_InsertionSort_0__Array_insertionSort_traverse___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__1_spec__2___redArg(v_xs_508_, v_j_509_);
return v___x_511_;
}
}
LEAN_EXPORT uint8_t l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1(lean_object* v_00_u03b2_512_, lean_object* v_keys_513_, lean_object* v_vals_514_, lean_object* v_heq_515_, lean_object* v_i_516_, lean_object* v_k_517_){
_start:
{
uint8_t v___x_518_; 
v___x_518_ = l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1___redArg(v_keys_513_, v_i_516_, v_k_517_);
return v___x_518_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1___boxed(lean_object* v_00_u03b2_519_, lean_object* v_keys_520_, lean_object* v_vals_521_, lean_object* v_heq_522_, lean_object* v_i_523_, lean_object* v_k_524_){
_start:
{
uint8_t v_res_525_; lean_object* v_r_526_; 
v_res_525_ = l_Lean_PersistentHashMap_containsAtAux___at___00Lean_PersistentHashMap_containsAux___at___00Lean_PersistentHashMap_contains___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f_spec__0_spec__0_spec__1(v_00_u03b2_519_, v_keys_520_, v_vals_521_, v_heq_522_, v_i_523_, v_k_524_);
lean_dec(v_k_524_);
lean_dec_ref(v_vals_521_);
lean_dec_ref(v_keys_520_);
v_r_526_ = lean_box(v_res_525_);
return v_r_526_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0(lean_object* v_fst_528_, lean_object* v_x_529_, lean_object* v___y_530_, lean_object* v___y_531_, lean_object* v___y_532_, lean_object* v___y_533_, lean_object* v___y_534_, lean_object* v___y_535_, lean_object* v___y_536_, lean_object* v___y_537_, lean_object* v___y_538_, lean_object* v___y_539_){
_start:
{
lean_object* v___x_541_; lean_object* v___x_542_; 
v___x_541_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0___closed__0));
v___x_542_ = l_Lean_Meta_Sym_Simp_Theorems_rewrite(v_fst_528_, v___x_541_, v___y_530_, v___y_531_, v___y_532_, v___y_533_, v___y_534_, v___y_535_, v___y_536_, v___y_537_, v___y_538_, v___y_539_);
return v___x_542_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0___boxed(lean_object* v_fst_543_, lean_object* v_x_544_, lean_object* v___y_545_, lean_object* v___y_546_, lean_object* v___y_547_, lean_object* v___y_548_, lean_object* v___y_549_, lean_object* v___y_550_, lean_object* v___y_551_, lean_object* v___y_552_, lean_object* v___y_553_, lean_object* v___y_554_, lean_object* v___y_555_){
_start:
{
lean_object* v_res_556_; 
v_res_556_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0(v_fst_543_, v_x_544_, v___y_545_, v___y_546_, v___y_547_, v___y_548_, v___y_549_, v___y_550_, v___y_551_, v___y_552_, v___y_553_, v___y_554_);
lean_dec(v___y_554_);
lean_dec_ref(v___y_553_);
lean_dec(v___y_552_);
lean_dec_ref(v___y_551_);
lean_dec(v___y_550_);
lean_dec_ref(v___y_549_);
lean_dec(v___y_548_);
lean_dec_ref(v___y_547_);
lean_dec(v___y_546_);
lean_dec(v_fst_543_);
return v_res_556_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__1(lean_object* v_fst_557_, lean_object* v_fst_558_, lean_object* v_snd_559_, lean_object* v_x_560_, lean_object* v___y_561_, lean_object* v___y_562_, lean_object* v___y_563_, lean_object* v___y_564_, lean_object* v___y_565_, lean_object* v___y_566_, lean_object* v___y_567_, lean_object* v___y_568_, lean_object* v___y_569_, lean_object* v___y_570_){
_start:
{
lean_object* v___x_572_; 
lean_inc_ref(v___y_561_);
v___x_572_ = l_Lean_Meta_Tactic_BVDecide_Normalize_applyCondSimproc(v_fst_557_, v___y_561_, v___y_562_, v___y_563_, v___y_564_, v___y_565_, v___y_566_, v___y_567_, v___y_568_, v___y_569_, v___y_570_);
if (lean_obj_tag(v___x_572_) == 0)
{
lean_object* v_a_573_; 
v_a_573_ = lean_ctor_get(v___x_572_, 0);
lean_inc(v_a_573_);
if (lean_obj_tag(v_a_573_) == 0)
{
uint8_t v_done_574_; 
v_done_574_ = lean_ctor_get_uint8(v_a_573_, 0);
if (v_done_574_ == 0)
{
uint8_t v_contextDependent_575_; lean_object* v___x_576_; 
lean_dec_ref_known(v___x_572_, 1);
v_contextDependent_575_ = lean_ctor_get_uint8(v_a_573_, 1);
lean_dec_ref_known(v_a_573_, 0);
v___x_576_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc(v_fst_558_, v_snd_559_, v___y_561_, v___y_562_, v___y_563_, v___y_564_, v___y_565_, v___y_566_, v___y_567_, v___y_568_, v___y_569_, v___y_570_);
if (lean_obj_tag(v___x_576_) == 0)
{
lean_object* v_a_577_; uint8_t v___y_579_; 
v_a_577_ = lean_ctor_get(v___x_576_, 0);
lean_inc(v_a_577_);
if (v_contextDependent_575_ == 0)
{
lean_dec(v_a_577_);
return v___x_576_;
}
else
{
if (lean_obj_tag(v_a_577_) == 0)
{
uint8_t v_contextDependent_589_; 
v_contextDependent_589_ = lean_ctor_get_uint8(v_a_577_, 1);
v___y_579_ = v_contextDependent_589_;
goto v___jp_578_;
}
else
{
uint8_t v___x_590_; 
v___x_590_ = 0;
v___y_579_ = v___x_590_;
goto v___jp_578_;
}
}
v___jp_578_:
{
if (v___y_579_ == 0)
{
lean_object* v___x_581_; uint8_t v_isShared_582_; uint8_t v_isSharedCheck_587_; 
v_isSharedCheck_587_ = !lean_is_exclusive(v___x_576_);
if (v_isSharedCheck_587_ == 0)
{
lean_object* v_unused_588_; 
v_unused_588_ = lean_ctor_get(v___x_576_, 0);
lean_dec(v_unused_588_);
v___x_581_ = v___x_576_;
v_isShared_582_ = v_isSharedCheck_587_;
goto v_resetjp_580_;
}
else
{
lean_dec(v___x_576_);
v___x_581_ = lean_box(0);
v_isShared_582_ = v_isSharedCheck_587_;
goto v_resetjp_580_;
}
v_resetjp_580_:
{
lean_object* v___x_583_; lean_object* v___x_585_; 
v___x_583_ = l_Lean_Meta_Sym_Simp_Result_withContextDependent(v_a_577_);
if (v_isShared_582_ == 0)
{
lean_ctor_set(v___x_581_, 0, v___x_583_);
v___x_585_ = v___x_581_;
goto v_reusejp_584_;
}
else
{
lean_object* v_reuseFailAlloc_586_; 
v_reuseFailAlloc_586_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_586_, 0, v___x_583_);
v___x_585_ = v_reuseFailAlloc_586_;
goto v_reusejp_584_;
}
v_reusejp_584_:
{
return v___x_585_;
}
}
}
else
{
lean_dec(v_a_577_);
return v___x_576_;
}
}
}
else
{
return v___x_576_;
}
}
else
{
lean_dec_ref_known(v_a_573_, 0);
lean_dec_ref(v___y_561_);
return v___x_572_;
}
}
else
{
uint8_t v_done_591_; 
v_done_591_ = lean_ctor_get_uint8(v_a_573_, sizeof(void*)*2);
if (v_done_591_ == 0)
{
lean_object* v_e_x27_592_; lean_object* v_proof_593_; uint8_t v_contextDependent_594_; lean_object* v___x_596_; uint8_t v_isShared_597_; uint8_t v_isSharedCheck_643_; 
lean_dec_ref_known(v___x_572_, 1);
v_e_x27_592_ = lean_ctor_get(v_a_573_, 0);
v_proof_593_ = lean_ctor_get(v_a_573_, 1);
v_contextDependent_594_ = lean_ctor_get_uint8(v_a_573_, sizeof(void*)*2 + 1);
v_isSharedCheck_643_ = !lean_is_exclusive(v_a_573_);
if (v_isSharedCheck_643_ == 0)
{
v___x_596_ = v_a_573_;
v_isShared_597_ = v_isSharedCheck_643_;
goto v_resetjp_595_;
}
else
{
lean_inc(v_proof_593_);
lean_inc(v_e_x27_592_);
lean_dec(v_a_573_);
v___x_596_ = lean_box(0);
v_isShared_597_ = v_isSharedCheck_643_;
goto v_resetjp_595_;
}
v_resetjp_595_:
{
lean_object* v___x_598_; 
lean_inc_ref(v_e_x27_592_);
v___x_598_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc(v_fst_558_, v_snd_559_, v_e_x27_592_, v___y_562_, v___y_563_, v___y_564_, v___y_565_, v___y_566_, v___y_567_, v___y_568_, v___y_569_, v___y_570_);
if (lean_obj_tag(v___x_598_) == 0)
{
lean_object* v_a_599_; lean_object* v___x_601_; uint8_t v_isShared_602_; uint8_t v_isSharedCheck_642_; 
v_a_599_ = lean_ctor_get(v___x_598_, 0);
v_isSharedCheck_642_ = !lean_is_exclusive(v___x_598_);
if (v_isSharedCheck_642_ == 0)
{
v___x_601_ = v___x_598_;
v_isShared_602_ = v_isSharedCheck_642_;
goto v_resetjp_600_;
}
else
{
lean_inc(v_a_599_);
lean_dec(v___x_598_);
v___x_601_ = lean_box(0);
v_isShared_602_ = v_isSharedCheck_642_;
goto v_resetjp_600_;
}
v_resetjp_600_:
{
if (lean_obj_tag(v_a_599_) == 0)
{
uint8_t v_done_603_; uint8_t v_contextDependent_604_; uint8_t v___y_606_; 
lean_dec_ref(v___y_561_);
v_done_603_ = lean_ctor_get_uint8(v_a_599_, 0);
v_contextDependent_604_ = lean_ctor_get_uint8(v_a_599_, 1);
lean_dec_ref_known(v_a_599_, 0);
if (v_contextDependent_594_ == 0)
{
v___y_606_ = v_contextDependent_604_;
goto v___jp_605_;
}
else
{
v___y_606_ = v_contextDependent_594_;
goto v___jp_605_;
}
v___jp_605_:
{
lean_object* v___x_608_; 
if (v_isShared_597_ == 0)
{
v___x_608_ = v___x_596_;
goto v_reusejp_607_;
}
else
{
lean_object* v_reuseFailAlloc_612_; 
v_reuseFailAlloc_612_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_612_, 0, v_e_x27_592_);
lean_ctor_set(v_reuseFailAlloc_612_, 1, v_proof_593_);
v___x_608_ = v_reuseFailAlloc_612_;
goto v_reusejp_607_;
}
v_reusejp_607_:
{
lean_object* v___x_610_; 
lean_ctor_set_uint8(v___x_608_, sizeof(void*)*2, v_done_603_);
lean_ctor_set_uint8(v___x_608_, sizeof(void*)*2 + 1, v___y_606_);
if (v_isShared_602_ == 0)
{
lean_ctor_set(v___x_601_, 0, v___x_608_);
v___x_610_ = v___x_601_;
goto v_reusejp_609_;
}
else
{
lean_object* v_reuseFailAlloc_611_; 
v_reuseFailAlloc_611_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_611_, 0, v___x_608_);
v___x_610_ = v_reuseFailAlloc_611_;
goto v_reusejp_609_;
}
v_reusejp_609_:
{
return v___x_610_;
}
}
}
}
else
{
lean_object* v_e_x27_613_; lean_object* v_proof_614_; lean_object* v___x_616_; uint8_t v_isShared_617_; uint8_t v_isSharedCheck_641_; 
lean_del_object(v___x_601_);
lean_del_object(v___x_596_);
v_e_x27_613_ = lean_ctor_get(v_a_599_, 0);
v_proof_614_ = lean_ctor_get(v_a_599_, 1);
v_isSharedCheck_641_ = !lean_is_exclusive(v_a_599_);
if (v_isSharedCheck_641_ == 0)
{
v___x_616_ = v_a_599_;
v_isShared_617_ = v_isSharedCheck_641_;
goto v_resetjp_615_;
}
else
{
lean_inc(v_proof_614_);
lean_inc(v_e_x27_613_);
lean_dec(v_a_599_);
v___x_616_ = lean_box(0);
v_isShared_617_ = v_isSharedCheck_641_;
goto v_resetjp_615_;
}
v_resetjp_615_:
{
uint8_t v___x_618_; lean_object* v___x_619_; 
v___x_618_ = 0;
lean_inc_ref(v_e_x27_613_);
v___x_619_ = l_Lean_Meta_Sym_Simp_mkEqTrans(v___y_561_, v_e_x27_592_, v_proof_593_, v_e_x27_613_, v_proof_614_, v___y_565_, v___y_566_, v___y_567_, v___y_568_, v___y_569_, v___y_570_);
if (lean_obj_tag(v___x_619_) == 0)
{
lean_object* v_a_620_; lean_object* v___x_622_; uint8_t v_isShared_623_; uint8_t v_isSharedCheck_632_; 
v_a_620_ = lean_ctor_get(v___x_619_, 0);
v_isSharedCheck_632_ = !lean_is_exclusive(v___x_619_);
if (v_isSharedCheck_632_ == 0)
{
v___x_622_ = v___x_619_;
v_isShared_623_ = v_isSharedCheck_632_;
goto v_resetjp_621_;
}
else
{
lean_inc(v_a_620_);
lean_dec(v___x_619_);
v___x_622_ = lean_box(0);
v_isShared_623_ = v_isSharedCheck_632_;
goto v_resetjp_621_;
}
v_resetjp_621_:
{
uint8_t v___y_625_; 
if (v_contextDependent_594_ == 0)
{
v___y_625_ = v___x_618_;
goto v___jp_624_;
}
else
{
v___y_625_ = v_contextDependent_594_;
goto v___jp_624_;
}
v___jp_624_:
{
lean_object* v___x_627_; 
if (v_isShared_617_ == 0)
{
lean_ctor_set(v___x_616_, 1, v_a_620_);
v___x_627_ = v___x_616_;
goto v_reusejp_626_;
}
else
{
lean_object* v_reuseFailAlloc_631_; 
v_reuseFailAlloc_631_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_631_, 0, v_e_x27_613_);
lean_ctor_set(v_reuseFailAlloc_631_, 1, v_a_620_);
v___x_627_ = v_reuseFailAlloc_631_;
goto v_reusejp_626_;
}
v_reusejp_626_:
{
lean_object* v___x_629_; 
lean_ctor_set_uint8(v___x_627_, sizeof(void*)*2, v___x_618_);
lean_ctor_set_uint8(v___x_627_, sizeof(void*)*2 + 1, v___y_625_);
if (v_isShared_623_ == 0)
{
lean_ctor_set(v___x_622_, 0, v___x_627_);
v___x_629_ = v___x_622_;
goto v_reusejp_628_;
}
else
{
lean_object* v_reuseFailAlloc_630_; 
v_reuseFailAlloc_630_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_630_, 0, v___x_627_);
v___x_629_ = v_reuseFailAlloc_630_;
goto v_reusejp_628_;
}
v_reusejp_628_:
{
return v___x_629_;
}
}
}
}
}
else
{
lean_object* v_a_633_; lean_object* v___x_635_; uint8_t v_isShared_636_; uint8_t v_isSharedCheck_640_; 
lean_del_object(v___x_616_);
lean_dec_ref(v_e_x27_613_);
v_a_633_ = lean_ctor_get(v___x_619_, 0);
v_isSharedCheck_640_ = !lean_is_exclusive(v___x_619_);
if (v_isSharedCheck_640_ == 0)
{
v___x_635_ = v___x_619_;
v_isShared_636_ = v_isSharedCheck_640_;
goto v_resetjp_634_;
}
else
{
lean_inc(v_a_633_);
lean_dec(v___x_619_);
v___x_635_ = lean_box(0);
v_isShared_636_ = v_isSharedCheck_640_;
goto v_resetjp_634_;
}
v_resetjp_634_:
{
lean_object* v___x_638_; 
if (v_isShared_636_ == 0)
{
v___x_638_ = v___x_635_;
goto v_reusejp_637_;
}
else
{
lean_object* v_reuseFailAlloc_639_; 
v_reuseFailAlloc_639_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_639_, 0, v_a_633_);
v___x_638_ = v_reuseFailAlloc_639_;
goto v_reusejp_637_;
}
v_reusejp_637_:
{
return v___x_638_;
}
}
}
}
}
}
}
else
{
lean_del_object(v___x_596_);
lean_dec_ref(v_proof_593_);
lean_dec_ref(v_e_x27_592_);
lean_dec_ref(v___y_561_);
return v___x_598_;
}
}
}
else
{
lean_dec_ref_known(v_a_573_, 2);
lean_dec_ref(v___y_561_);
return v___x_572_;
}
}
}
else
{
lean_dec_ref(v___y_561_);
return v___x_572_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__1___boxed(lean_object* v_fst_644_, lean_object* v_fst_645_, lean_object* v_snd_646_, lean_object* v_x_647_, lean_object* v___y_648_, lean_object* v___y_649_, lean_object* v___y_650_, lean_object* v___y_651_, lean_object* v___y_652_, lean_object* v___y_653_, lean_object* v___y_654_, lean_object* v___y_655_, lean_object* v___y_656_, lean_object* v___y_657_, lean_object* v___y_658_){
_start:
{
lean_object* v_res_659_; 
v_res_659_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__1(v_fst_644_, v_fst_645_, v_snd_646_, v_x_647_, v___y_648_, v___y_649_, v___y_650_, v___y_651_, v___y_652_, v___y_653_, v___y_654_, v___y_655_, v___y_656_, v___y_657_);
lean_dec(v___y_657_);
lean_dec_ref(v___y_656_);
lean_dec(v___y_655_);
lean_dec_ref(v___y_654_);
lean_dec(v___y_653_);
lean_dec_ref(v___y_652_);
lean_dec(v___y_651_);
lean_dec_ref(v___y_650_);
lean_dec(v___y_649_);
lean_dec(v_snd_646_);
lean_dec(v_fst_645_);
lean_dec(v_fst_644_);
return v_res_659_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__2(lean_object* v_fst_660_, lean_object* v___f_661_, lean_object* v_x_662_, lean_object* v___y_663_, lean_object* v___y_664_, lean_object* v___y_665_, lean_object* v___y_666_, lean_object* v___y_667_, lean_object* v___y_668_, lean_object* v___y_669_, lean_object* v___y_670_, lean_object* v___y_671_, lean_object* v___y_672_){
_start:
{
lean_object* v___x_674_; 
lean_inc_ref(v___y_663_);
v___x_674_ = l_Lean_Meta_Tactic_BVDecide_Normalize_applyIteSimproc(v_fst_660_, v___y_663_, v___y_664_, v___y_665_, v___y_666_, v___y_667_, v___y_668_, v___y_669_, v___y_670_, v___y_671_, v___y_672_);
if (lean_obj_tag(v___x_674_) == 0)
{
lean_object* v_a_675_; lean_object* v___x_676_; 
v_a_675_ = lean_ctor_get(v___x_674_, 0);
lean_inc(v_a_675_);
v___x_676_ = lean_box(0);
if (lean_obj_tag(v_a_675_) == 0)
{
uint8_t v_done_677_; 
v_done_677_ = lean_ctor_get_uint8(v_a_675_, 0);
if (v_done_677_ == 0)
{
uint8_t v_contextDependent_678_; lean_object* v___x_679_; 
lean_dec_ref_known(v___x_674_, 1);
v_contextDependent_678_ = lean_ctor_get_uint8(v_a_675_, 1);
lean_dec_ref_known(v_a_675_, 0);
lean_inc(v___y_672_);
lean_inc_ref(v___y_671_);
lean_inc(v___y_670_);
lean_inc_ref(v___y_669_);
lean_inc(v___y_668_);
lean_inc_ref(v___y_667_);
lean_inc(v___y_666_);
lean_inc_ref(v___y_665_);
lean_inc(v___y_664_);
v___x_679_ = lean_apply_12(v___f_661_, v___x_676_, v___y_663_, v___y_664_, v___y_665_, v___y_666_, v___y_667_, v___y_668_, v___y_669_, v___y_670_, v___y_671_, v___y_672_, lean_box(0));
if (lean_obj_tag(v___x_679_) == 0)
{
lean_object* v_a_680_; uint8_t v___y_682_; 
v_a_680_ = lean_ctor_get(v___x_679_, 0);
lean_inc(v_a_680_);
if (v_contextDependent_678_ == 0)
{
lean_dec(v_a_680_);
return v___x_679_;
}
else
{
if (lean_obj_tag(v_a_680_) == 0)
{
uint8_t v_contextDependent_692_; 
v_contextDependent_692_ = lean_ctor_get_uint8(v_a_680_, 1);
v___y_682_ = v_contextDependent_692_;
goto v___jp_681_;
}
else
{
uint8_t v_contextDependent_693_; 
v_contextDependent_693_ = lean_ctor_get_uint8(v_a_680_, sizeof(void*)*2 + 1);
v___y_682_ = v_contextDependent_693_;
goto v___jp_681_;
}
}
v___jp_681_:
{
if (v___y_682_ == 0)
{
lean_object* v___x_684_; uint8_t v_isShared_685_; uint8_t v_isSharedCheck_690_; 
v_isSharedCheck_690_ = !lean_is_exclusive(v___x_679_);
if (v_isSharedCheck_690_ == 0)
{
lean_object* v_unused_691_; 
v_unused_691_ = lean_ctor_get(v___x_679_, 0);
lean_dec(v_unused_691_);
v___x_684_ = v___x_679_;
v_isShared_685_ = v_isSharedCheck_690_;
goto v_resetjp_683_;
}
else
{
lean_dec(v___x_679_);
v___x_684_ = lean_box(0);
v_isShared_685_ = v_isSharedCheck_690_;
goto v_resetjp_683_;
}
v_resetjp_683_:
{
lean_object* v___x_686_; lean_object* v___x_688_; 
v___x_686_ = l_Lean_Meta_Sym_Simp_Result_withContextDependent(v_a_680_);
if (v_isShared_685_ == 0)
{
lean_ctor_set(v___x_684_, 0, v___x_686_);
v___x_688_ = v___x_684_;
goto v_reusejp_687_;
}
else
{
lean_object* v_reuseFailAlloc_689_; 
v_reuseFailAlloc_689_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_689_, 0, v___x_686_);
v___x_688_ = v_reuseFailAlloc_689_;
goto v_reusejp_687_;
}
v_reusejp_687_:
{
return v___x_688_;
}
}
}
else
{
lean_dec(v_a_680_);
return v___x_679_;
}
}
}
else
{
return v___x_679_;
}
}
else
{
lean_dec_ref_known(v_a_675_, 0);
lean_dec_ref(v___y_663_);
lean_dec_ref(v___f_661_);
return v___x_674_;
}
}
else
{
uint8_t v_done_694_; 
v_done_694_ = lean_ctor_get_uint8(v_a_675_, sizeof(void*)*2);
if (v_done_694_ == 0)
{
lean_object* v_e_x27_695_; lean_object* v_proof_696_; uint8_t v_contextDependent_697_; lean_object* v___x_699_; uint8_t v_isShared_700_; uint8_t v_isSharedCheck_747_; 
lean_dec_ref_known(v___x_674_, 1);
v_e_x27_695_ = lean_ctor_get(v_a_675_, 0);
v_proof_696_ = lean_ctor_get(v_a_675_, 1);
v_contextDependent_697_ = lean_ctor_get_uint8(v_a_675_, sizeof(void*)*2 + 1);
v_isSharedCheck_747_ = !lean_is_exclusive(v_a_675_);
if (v_isSharedCheck_747_ == 0)
{
v___x_699_ = v_a_675_;
v_isShared_700_ = v_isSharedCheck_747_;
goto v_resetjp_698_;
}
else
{
lean_inc(v_proof_696_);
lean_inc(v_e_x27_695_);
lean_dec(v_a_675_);
v___x_699_ = lean_box(0);
v_isShared_700_ = v_isSharedCheck_747_;
goto v_resetjp_698_;
}
v_resetjp_698_:
{
lean_object* v___x_701_; 
lean_inc(v___y_672_);
lean_inc_ref(v___y_671_);
lean_inc(v___y_670_);
lean_inc_ref(v___y_669_);
lean_inc(v___y_668_);
lean_inc_ref(v___y_667_);
lean_inc(v___y_666_);
lean_inc_ref(v___y_665_);
lean_inc(v___y_664_);
lean_inc_ref(v_e_x27_695_);
v___x_701_ = lean_apply_12(v___f_661_, v___x_676_, v_e_x27_695_, v___y_664_, v___y_665_, v___y_666_, v___y_667_, v___y_668_, v___y_669_, v___y_670_, v___y_671_, v___y_672_, lean_box(0));
if (lean_obj_tag(v___x_701_) == 0)
{
lean_object* v_a_702_; lean_object* v___x_704_; uint8_t v_isShared_705_; uint8_t v_isSharedCheck_746_; 
v_a_702_ = lean_ctor_get(v___x_701_, 0);
v_isSharedCheck_746_ = !lean_is_exclusive(v___x_701_);
if (v_isSharedCheck_746_ == 0)
{
v___x_704_ = v___x_701_;
v_isShared_705_ = v_isSharedCheck_746_;
goto v_resetjp_703_;
}
else
{
lean_inc(v_a_702_);
lean_dec(v___x_701_);
v___x_704_ = lean_box(0);
v_isShared_705_ = v_isSharedCheck_746_;
goto v_resetjp_703_;
}
v_resetjp_703_:
{
if (lean_obj_tag(v_a_702_) == 0)
{
uint8_t v_done_706_; uint8_t v_contextDependent_707_; uint8_t v___y_709_; 
lean_dec_ref(v___y_663_);
v_done_706_ = lean_ctor_get_uint8(v_a_702_, 0);
v_contextDependent_707_ = lean_ctor_get_uint8(v_a_702_, 1);
lean_dec_ref_known(v_a_702_, 0);
if (v_contextDependent_697_ == 0)
{
v___y_709_ = v_contextDependent_707_;
goto v___jp_708_;
}
else
{
v___y_709_ = v_contextDependent_697_;
goto v___jp_708_;
}
v___jp_708_:
{
lean_object* v___x_711_; 
if (v_isShared_700_ == 0)
{
v___x_711_ = v___x_699_;
goto v_reusejp_710_;
}
else
{
lean_object* v_reuseFailAlloc_715_; 
v_reuseFailAlloc_715_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_715_, 0, v_e_x27_695_);
lean_ctor_set(v_reuseFailAlloc_715_, 1, v_proof_696_);
v___x_711_ = v_reuseFailAlloc_715_;
goto v_reusejp_710_;
}
v_reusejp_710_:
{
lean_object* v___x_713_; 
lean_ctor_set_uint8(v___x_711_, sizeof(void*)*2, v_done_706_);
lean_ctor_set_uint8(v___x_711_, sizeof(void*)*2 + 1, v___y_709_);
if (v_isShared_705_ == 0)
{
lean_ctor_set(v___x_704_, 0, v___x_711_);
v___x_713_ = v___x_704_;
goto v_reusejp_712_;
}
else
{
lean_object* v_reuseFailAlloc_714_; 
v_reuseFailAlloc_714_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_714_, 0, v___x_711_);
v___x_713_ = v_reuseFailAlloc_714_;
goto v_reusejp_712_;
}
v_reusejp_712_:
{
return v___x_713_;
}
}
}
}
else
{
lean_object* v_e_x27_716_; lean_object* v_proof_717_; uint8_t v_done_718_; uint8_t v_contextDependent_719_; lean_object* v___x_721_; uint8_t v_isShared_722_; uint8_t v_isSharedCheck_745_; 
lean_del_object(v___x_704_);
lean_del_object(v___x_699_);
v_e_x27_716_ = lean_ctor_get(v_a_702_, 0);
v_proof_717_ = lean_ctor_get(v_a_702_, 1);
v_done_718_ = lean_ctor_get_uint8(v_a_702_, sizeof(void*)*2);
v_contextDependent_719_ = lean_ctor_get_uint8(v_a_702_, sizeof(void*)*2 + 1);
v_isSharedCheck_745_ = !lean_is_exclusive(v_a_702_);
if (v_isSharedCheck_745_ == 0)
{
v___x_721_ = v_a_702_;
v_isShared_722_ = v_isSharedCheck_745_;
goto v_resetjp_720_;
}
else
{
lean_inc(v_proof_717_);
lean_inc(v_e_x27_716_);
lean_dec(v_a_702_);
v___x_721_ = lean_box(0);
v_isShared_722_ = v_isSharedCheck_745_;
goto v_resetjp_720_;
}
v_resetjp_720_:
{
lean_object* v___x_723_; 
lean_inc_ref(v_e_x27_716_);
v___x_723_ = l_Lean_Meta_Sym_Simp_mkEqTrans(v___y_663_, v_e_x27_695_, v_proof_696_, v_e_x27_716_, v_proof_717_, v___y_667_, v___y_668_, v___y_669_, v___y_670_, v___y_671_, v___y_672_);
if (lean_obj_tag(v___x_723_) == 0)
{
lean_object* v_a_724_; lean_object* v___x_726_; uint8_t v_isShared_727_; uint8_t v_isSharedCheck_736_; 
v_a_724_ = lean_ctor_get(v___x_723_, 0);
v_isSharedCheck_736_ = !lean_is_exclusive(v___x_723_);
if (v_isSharedCheck_736_ == 0)
{
v___x_726_ = v___x_723_;
v_isShared_727_ = v_isSharedCheck_736_;
goto v_resetjp_725_;
}
else
{
lean_inc(v_a_724_);
lean_dec(v___x_723_);
v___x_726_ = lean_box(0);
v_isShared_727_ = v_isSharedCheck_736_;
goto v_resetjp_725_;
}
v_resetjp_725_:
{
uint8_t v___y_729_; 
if (v_contextDependent_697_ == 0)
{
v___y_729_ = v_contextDependent_719_;
goto v___jp_728_;
}
else
{
v___y_729_ = v_contextDependent_697_;
goto v___jp_728_;
}
v___jp_728_:
{
lean_object* v___x_731_; 
if (v_isShared_722_ == 0)
{
lean_ctor_set(v___x_721_, 1, v_a_724_);
v___x_731_ = v___x_721_;
goto v_reusejp_730_;
}
else
{
lean_object* v_reuseFailAlloc_735_; 
v_reuseFailAlloc_735_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_735_, 0, v_e_x27_716_);
lean_ctor_set(v_reuseFailAlloc_735_, 1, v_a_724_);
lean_ctor_set_uint8(v_reuseFailAlloc_735_, sizeof(void*)*2, v_done_718_);
v___x_731_ = v_reuseFailAlloc_735_;
goto v_reusejp_730_;
}
v_reusejp_730_:
{
lean_object* v___x_733_; 
lean_ctor_set_uint8(v___x_731_, sizeof(void*)*2 + 1, v___y_729_);
if (v_isShared_727_ == 0)
{
lean_ctor_set(v___x_726_, 0, v___x_731_);
v___x_733_ = v___x_726_;
goto v_reusejp_732_;
}
else
{
lean_object* v_reuseFailAlloc_734_; 
v_reuseFailAlloc_734_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_734_, 0, v___x_731_);
v___x_733_ = v_reuseFailAlloc_734_;
goto v_reusejp_732_;
}
v_reusejp_732_:
{
return v___x_733_;
}
}
}
}
}
else
{
lean_object* v_a_737_; lean_object* v___x_739_; uint8_t v_isShared_740_; uint8_t v_isSharedCheck_744_; 
lean_del_object(v___x_721_);
lean_dec_ref(v_e_x27_716_);
v_a_737_ = lean_ctor_get(v___x_723_, 0);
v_isSharedCheck_744_ = !lean_is_exclusive(v___x_723_);
if (v_isSharedCheck_744_ == 0)
{
v___x_739_ = v___x_723_;
v_isShared_740_ = v_isSharedCheck_744_;
goto v_resetjp_738_;
}
else
{
lean_inc(v_a_737_);
lean_dec(v___x_723_);
v___x_739_ = lean_box(0);
v_isShared_740_ = v_isSharedCheck_744_;
goto v_resetjp_738_;
}
v_resetjp_738_:
{
lean_object* v___x_742_; 
if (v_isShared_740_ == 0)
{
v___x_742_ = v___x_739_;
goto v_reusejp_741_;
}
else
{
lean_object* v_reuseFailAlloc_743_; 
v_reuseFailAlloc_743_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_743_, 0, v_a_737_);
v___x_742_ = v_reuseFailAlloc_743_;
goto v_reusejp_741_;
}
v_reusejp_741_:
{
return v___x_742_;
}
}
}
}
}
}
}
else
{
lean_del_object(v___x_699_);
lean_dec_ref(v_proof_696_);
lean_dec_ref(v_e_x27_695_);
lean_dec_ref(v___y_663_);
return v___x_701_;
}
}
}
else
{
lean_dec_ref_known(v_a_675_, 2);
lean_dec_ref(v___y_663_);
lean_dec_ref(v___f_661_);
return v___x_674_;
}
}
}
else
{
lean_dec_ref(v___y_663_);
lean_dec_ref(v___f_661_);
return v___x_674_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__2___boxed(lean_object* v_fst_748_, lean_object* v___f_749_, lean_object* v_x_750_, lean_object* v___y_751_, lean_object* v___y_752_, lean_object* v___y_753_, lean_object* v___y_754_, lean_object* v___y_755_, lean_object* v___y_756_, lean_object* v___y_757_, lean_object* v___y_758_, lean_object* v___y_759_, lean_object* v___y_760_, lean_object* v___y_761_){
_start:
{
lean_object* v_res_762_; 
v_res_762_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__2(v_fst_748_, v___f_749_, v_x_750_, v___y_751_, v___y_752_, v___y_753_, v___y_754_, v___y_755_, v___y_756_, v___y_757_, v___y_758_, v___y_759_, v___y_760_);
lean_dec(v___y_760_);
lean_dec_ref(v___y_759_);
lean_dec(v___y_758_);
lean_dec_ref(v___y_757_);
lean_dec(v___y_756_);
lean_dec_ref(v___y_755_);
lean_dec(v___y_754_);
lean_dec_ref(v___y_753_);
lean_dec(v___y_752_);
lean_dec(v_fst_748_);
return v_res_762_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__3(lean_object* v_post_763_, lean_object* v___f_764_, lean_object* v___y_765_, lean_object* v___y_766_, lean_object* v___y_767_, lean_object* v___y_768_, lean_object* v___y_769_, lean_object* v___y_770_, lean_object* v___y_771_, lean_object* v___y_772_, lean_object* v___y_773_, lean_object* v___y_774_){
_start:
{
lean_object* v___x_776_; 
lean_inc(v___y_774_);
lean_inc_ref(v___y_773_);
lean_inc(v___y_772_);
lean_inc_ref(v___y_771_);
lean_inc(v___y_770_);
lean_inc_ref(v___y_769_);
lean_inc(v___y_768_);
lean_inc_ref(v___y_767_);
lean_inc(v___y_766_);
lean_inc_ref(v___y_765_);
v___x_776_ = lean_apply_11(v_post_763_, v___y_765_, v___y_766_, v___y_767_, v___y_768_, v___y_769_, v___y_770_, v___y_771_, v___y_772_, v___y_773_, v___y_774_, lean_box(0));
if (lean_obj_tag(v___x_776_) == 0)
{
lean_object* v_a_777_; lean_object* v___x_778_; 
v_a_777_ = lean_ctor_get(v___x_776_, 0);
lean_inc(v_a_777_);
v___x_778_ = lean_box(0);
if (lean_obj_tag(v_a_777_) == 0)
{
uint8_t v_done_779_; 
v_done_779_ = lean_ctor_get_uint8(v_a_777_, 0);
if (v_done_779_ == 0)
{
uint8_t v_contextDependent_780_; lean_object* v___x_781_; 
lean_dec_ref_known(v___x_776_, 1);
v_contextDependent_780_ = lean_ctor_get_uint8(v_a_777_, 1);
lean_dec_ref_known(v_a_777_, 0);
v___x_781_ = lean_apply_12(v___f_764_, v___x_778_, v___y_765_, v___y_766_, v___y_767_, v___y_768_, v___y_769_, v___y_770_, v___y_771_, v___y_772_, v___y_773_, v___y_774_, lean_box(0));
if (lean_obj_tag(v___x_781_) == 0)
{
lean_object* v_a_782_; uint8_t v___y_784_; 
v_a_782_ = lean_ctor_get(v___x_781_, 0);
lean_inc(v_a_782_);
if (v_contextDependent_780_ == 0)
{
lean_dec(v_a_782_);
return v___x_781_;
}
else
{
if (lean_obj_tag(v_a_782_) == 0)
{
uint8_t v_contextDependent_794_; 
v_contextDependent_794_ = lean_ctor_get_uint8(v_a_782_, 1);
v___y_784_ = v_contextDependent_794_;
goto v___jp_783_;
}
else
{
uint8_t v_contextDependent_795_; 
v_contextDependent_795_ = lean_ctor_get_uint8(v_a_782_, sizeof(void*)*2 + 1);
v___y_784_ = v_contextDependent_795_;
goto v___jp_783_;
}
}
v___jp_783_:
{
if (v___y_784_ == 0)
{
lean_object* v___x_786_; uint8_t v_isShared_787_; uint8_t v_isSharedCheck_792_; 
v_isSharedCheck_792_ = !lean_is_exclusive(v___x_781_);
if (v_isSharedCheck_792_ == 0)
{
lean_object* v_unused_793_; 
v_unused_793_ = lean_ctor_get(v___x_781_, 0);
lean_dec(v_unused_793_);
v___x_786_ = v___x_781_;
v_isShared_787_ = v_isSharedCheck_792_;
goto v_resetjp_785_;
}
else
{
lean_dec(v___x_781_);
v___x_786_ = lean_box(0);
v_isShared_787_ = v_isSharedCheck_792_;
goto v_resetjp_785_;
}
v_resetjp_785_:
{
lean_object* v___x_788_; lean_object* v___x_790_; 
v___x_788_ = l_Lean_Meta_Sym_Simp_Result_withContextDependent(v_a_782_);
if (v_isShared_787_ == 0)
{
lean_ctor_set(v___x_786_, 0, v___x_788_);
v___x_790_ = v___x_786_;
goto v_reusejp_789_;
}
else
{
lean_object* v_reuseFailAlloc_791_; 
v_reuseFailAlloc_791_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_791_, 0, v___x_788_);
v___x_790_ = v_reuseFailAlloc_791_;
goto v_reusejp_789_;
}
v_reusejp_789_:
{
return v___x_790_;
}
}
}
else
{
lean_dec(v_a_782_);
return v___x_781_;
}
}
}
else
{
return v___x_781_;
}
}
else
{
lean_dec_ref_known(v_a_777_, 0);
lean_dec(v___y_774_);
lean_dec_ref(v___y_773_);
lean_dec(v___y_772_);
lean_dec_ref(v___y_771_);
lean_dec(v___y_770_);
lean_dec_ref(v___y_769_);
lean_dec(v___y_768_);
lean_dec_ref(v___y_767_);
lean_dec(v___y_766_);
lean_dec_ref(v___y_765_);
lean_dec_ref(v___f_764_);
return v___x_776_;
}
}
else
{
uint8_t v_done_796_; 
v_done_796_ = lean_ctor_get_uint8(v_a_777_, sizeof(void*)*2);
if (v_done_796_ == 0)
{
lean_object* v_e_x27_797_; lean_object* v_proof_798_; uint8_t v_contextDependent_799_; lean_object* v___x_801_; uint8_t v_isShared_802_; uint8_t v_isSharedCheck_849_; 
lean_dec_ref_known(v___x_776_, 1);
v_e_x27_797_ = lean_ctor_get(v_a_777_, 0);
v_proof_798_ = lean_ctor_get(v_a_777_, 1);
v_contextDependent_799_ = lean_ctor_get_uint8(v_a_777_, sizeof(void*)*2 + 1);
v_isSharedCheck_849_ = !lean_is_exclusive(v_a_777_);
if (v_isSharedCheck_849_ == 0)
{
v___x_801_ = v_a_777_;
v_isShared_802_ = v_isSharedCheck_849_;
goto v_resetjp_800_;
}
else
{
lean_inc(v_proof_798_);
lean_inc(v_e_x27_797_);
lean_dec(v_a_777_);
v___x_801_ = lean_box(0);
v_isShared_802_ = v_isSharedCheck_849_;
goto v_resetjp_800_;
}
v_resetjp_800_:
{
lean_object* v___x_803_; 
lean_inc(v___y_774_);
lean_inc_ref(v___y_773_);
lean_inc(v___y_772_);
lean_inc_ref(v___y_771_);
lean_inc(v___y_770_);
lean_inc_ref(v___y_769_);
lean_inc_ref(v_e_x27_797_);
v___x_803_ = lean_apply_12(v___f_764_, v___x_778_, v_e_x27_797_, v___y_766_, v___y_767_, v___y_768_, v___y_769_, v___y_770_, v___y_771_, v___y_772_, v___y_773_, v___y_774_, lean_box(0));
if (lean_obj_tag(v___x_803_) == 0)
{
lean_object* v_a_804_; lean_object* v___x_806_; uint8_t v_isShared_807_; uint8_t v_isSharedCheck_848_; 
v_a_804_ = lean_ctor_get(v___x_803_, 0);
v_isSharedCheck_848_ = !lean_is_exclusive(v___x_803_);
if (v_isSharedCheck_848_ == 0)
{
v___x_806_ = v___x_803_;
v_isShared_807_ = v_isSharedCheck_848_;
goto v_resetjp_805_;
}
else
{
lean_inc(v_a_804_);
lean_dec(v___x_803_);
v___x_806_ = lean_box(0);
v_isShared_807_ = v_isSharedCheck_848_;
goto v_resetjp_805_;
}
v_resetjp_805_:
{
if (lean_obj_tag(v_a_804_) == 0)
{
uint8_t v_done_808_; uint8_t v_contextDependent_809_; uint8_t v___y_811_; 
lean_dec(v___y_774_);
lean_dec_ref(v___y_773_);
lean_dec(v___y_772_);
lean_dec_ref(v___y_771_);
lean_dec(v___y_770_);
lean_dec_ref(v___y_769_);
lean_dec_ref(v___y_765_);
v_done_808_ = lean_ctor_get_uint8(v_a_804_, 0);
v_contextDependent_809_ = lean_ctor_get_uint8(v_a_804_, 1);
lean_dec_ref_known(v_a_804_, 0);
if (v_contextDependent_799_ == 0)
{
v___y_811_ = v_contextDependent_809_;
goto v___jp_810_;
}
else
{
v___y_811_ = v_contextDependent_799_;
goto v___jp_810_;
}
v___jp_810_:
{
lean_object* v___x_813_; 
if (v_isShared_802_ == 0)
{
v___x_813_ = v___x_801_;
goto v_reusejp_812_;
}
else
{
lean_object* v_reuseFailAlloc_817_; 
v_reuseFailAlloc_817_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_817_, 0, v_e_x27_797_);
lean_ctor_set(v_reuseFailAlloc_817_, 1, v_proof_798_);
v___x_813_ = v_reuseFailAlloc_817_;
goto v_reusejp_812_;
}
v_reusejp_812_:
{
lean_object* v___x_815_; 
lean_ctor_set_uint8(v___x_813_, sizeof(void*)*2, v_done_808_);
lean_ctor_set_uint8(v___x_813_, sizeof(void*)*2 + 1, v___y_811_);
if (v_isShared_807_ == 0)
{
lean_ctor_set(v___x_806_, 0, v___x_813_);
v___x_815_ = v___x_806_;
goto v_reusejp_814_;
}
else
{
lean_object* v_reuseFailAlloc_816_; 
v_reuseFailAlloc_816_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_816_, 0, v___x_813_);
v___x_815_ = v_reuseFailAlloc_816_;
goto v_reusejp_814_;
}
v_reusejp_814_:
{
return v___x_815_;
}
}
}
}
else
{
lean_object* v_e_x27_818_; lean_object* v_proof_819_; uint8_t v_done_820_; uint8_t v_contextDependent_821_; lean_object* v___x_823_; uint8_t v_isShared_824_; uint8_t v_isSharedCheck_847_; 
lean_del_object(v___x_806_);
lean_del_object(v___x_801_);
v_e_x27_818_ = lean_ctor_get(v_a_804_, 0);
v_proof_819_ = lean_ctor_get(v_a_804_, 1);
v_done_820_ = lean_ctor_get_uint8(v_a_804_, sizeof(void*)*2);
v_contextDependent_821_ = lean_ctor_get_uint8(v_a_804_, sizeof(void*)*2 + 1);
v_isSharedCheck_847_ = !lean_is_exclusive(v_a_804_);
if (v_isSharedCheck_847_ == 0)
{
v___x_823_ = v_a_804_;
v_isShared_824_ = v_isSharedCheck_847_;
goto v_resetjp_822_;
}
else
{
lean_inc(v_proof_819_);
lean_inc(v_e_x27_818_);
lean_dec(v_a_804_);
v___x_823_ = lean_box(0);
v_isShared_824_ = v_isSharedCheck_847_;
goto v_resetjp_822_;
}
v_resetjp_822_:
{
lean_object* v___x_825_; 
lean_inc_ref(v_e_x27_818_);
v___x_825_ = l_Lean_Meta_Sym_Simp_mkEqTrans(v___y_765_, v_e_x27_797_, v_proof_798_, v_e_x27_818_, v_proof_819_, v___y_769_, v___y_770_, v___y_771_, v___y_772_, v___y_773_, v___y_774_);
lean_dec(v___y_774_);
lean_dec_ref(v___y_773_);
lean_dec(v___y_772_);
lean_dec_ref(v___y_771_);
lean_dec(v___y_770_);
lean_dec_ref(v___y_769_);
if (lean_obj_tag(v___x_825_) == 0)
{
lean_object* v_a_826_; lean_object* v___x_828_; uint8_t v_isShared_829_; uint8_t v_isSharedCheck_838_; 
v_a_826_ = lean_ctor_get(v___x_825_, 0);
v_isSharedCheck_838_ = !lean_is_exclusive(v___x_825_);
if (v_isSharedCheck_838_ == 0)
{
v___x_828_ = v___x_825_;
v_isShared_829_ = v_isSharedCheck_838_;
goto v_resetjp_827_;
}
else
{
lean_inc(v_a_826_);
lean_dec(v___x_825_);
v___x_828_ = lean_box(0);
v_isShared_829_ = v_isSharedCheck_838_;
goto v_resetjp_827_;
}
v_resetjp_827_:
{
uint8_t v___y_831_; 
if (v_contextDependent_799_ == 0)
{
v___y_831_ = v_contextDependent_821_;
goto v___jp_830_;
}
else
{
v___y_831_ = v_contextDependent_799_;
goto v___jp_830_;
}
v___jp_830_:
{
lean_object* v___x_833_; 
if (v_isShared_824_ == 0)
{
lean_ctor_set(v___x_823_, 1, v_a_826_);
v___x_833_ = v___x_823_;
goto v_reusejp_832_;
}
else
{
lean_object* v_reuseFailAlloc_837_; 
v_reuseFailAlloc_837_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_837_, 0, v_e_x27_818_);
lean_ctor_set(v_reuseFailAlloc_837_, 1, v_a_826_);
lean_ctor_set_uint8(v_reuseFailAlloc_837_, sizeof(void*)*2, v_done_820_);
v___x_833_ = v_reuseFailAlloc_837_;
goto v_reusejp_832_;
}
v_reusejp_832_:
{
lean_object* v___x_835_; 
lean_ctor_set_uint8(v___x_833_, sizeof(void*)*2 + 1, v___y_831_);
if (v_isShared_829_ == 0)
{
lean_ctor_set(v___x_828_, 0, v___x_833_);
v___x_835_ = v___x_828_;
goto v_reusejp_834_;
}
else
{
lean_object* v_reuseFailAlloc_836_; 
v_reuseFailAlloc_836_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_836_, 0, v___x_833_);
v___x_835_ = v_reuseFailAlloc_836_;
goto v_reusejp_834_;
}
v_reusejp_834_:
{
return v___x_835_;
}
}
}
}
}
else
{
lean_object* v_a_839_; lean_object* v___x_841_; uint8_t v_isShared_842_; uint8_t v_isSharedCheck_846_; 
lean_del_object(v___x_823_);
lean_dec_ref(v_e_x27_818_);
v_a_839_ = lean_ctor_get(v___x_825_, 0);
v_isSharedCheck_846_ = !lean_is_exclusive(v___x_825_);
if (v_isSharedCheck_846_ == 0)
{
v___x_841_ = v___x_825_;
v_isShared_842_ = v_isSharedCheck_846_;
goto v_resetjp_840_;
}
else
{
lean_inc(v_a_839_);
lean_dec(v___x_825_);
v___x_841_ = lean_box(0);
v_isShared_842_ = v_isSharedCheck_846_;
goto v_resetjp_840_;
}
v_resetjp_840_:
{
lean_object* v___x_844_; 
if (v_isShared_842_ == 0)
{
v___x_844_ = v___x_841_;
goto v_reusejp_843_;
}
else
{
lean_object* v_reuseFailAlloc_845_; 
v_reuseFailAlloc_845_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_845_, 0, v_a_839_);
v___x_844_ = v_reuseFailAlloc_845_;
goto v_reusejp_843_;
}
v_reusejp_843_:
{
return v___x_844_;
}
}
}
}
}
}
}
else
{
lean_del_object(v___x_801_);
lean_dec_ref(v_proof_798_);
lean_dec_ref(v_e_x27_797_);
lean_dec(v___y_774_);
lean_dec_ref(v___y_773_);
lean_dec(v___y_772_);
lean_dec_ref(v___y_771_);
lean_dec(v___y_770_);
lean_dec_ref(v___y_769_);
lean_dec_ref(v___y_765_);
return v___x_803_;
}
}
}
else
{
lean_dec_ref_known(v_a_777_, 2);
lean_dec(v___y_774_);
lean_dec_ref(v___y_773_);
lean_dec(v___y_772_);
lean_dec_ref(v___y_771_);
lean_dec(v___y_770_);
lean_dec_ref(v___y_769_);
lean_dec(v___y_768_);
lean_dec_ref(v___y_767_);
lean_dec(v___y_766_);
lean_dec_ref(v___y_765_);
lean_dec_ref(v___f_764_);
return v___x_776_;
}
}
}
else
{
lean_dec(v___y_774_);
lean_dec_ref(v___y_773_);
lean_dec(v___y_772_);
lean_dec_ref(v___y_771_);
lean_dec(v___y_770_);
lean_dec_ref(v___y_769_);
lean_dec(v___y_768_);
lean_dec_ref(v___y_767_);
lean_dec(v___y_766_);
lean_dec_ref(v___y_765_);
lean_dec_ref(v___f_764_);
return v___x_776_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__3___boxed(lean_object* v_post_850_, lean_object* v___f_851_, lean_object* v___y_852_, lean_object* v___y_853_, lean_object* v___y_854_, lean_object* v___y_855_, lean_object* v___y_856_, lean_object* v___y_857_, lean_object* v___y_858_, lean_object* v___y_859_, lean_object* v___y_860_, lean_object* v___y_861_, lean_object* v___y_862_){
_start:
{
lean_object* v_res_863_; 
v_res_863_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__3(v_post_850_, v___f_851_, v___y_852_, v___y_853_, v___y_854_, v___y_855_, v___y_856_, v___y_857_, v___y_858_, v___y_859_, v___y_860_, v___y_861_);
return v_res_863_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__4(lean_object* v_pre_864_, lean_object* v___f_865_, lean_object* v___y_866_, lean_object* v___y_867_, lean_object* v___y_868_, lean_object* v___y_869_, lean_object* v___y_870_, lean_object* v___y_871_, lean_object* v___y_872_, lean_object* v___y_873_, lean_object* v___y_874_, lean_object* v___y_875_){
_start:
{
lean_object* v___x_877_; 
lean_inc(v___y_875_);
lean_inc_ref(v___y_874_);
lean_inc(v___y_873_);
lean_inc_ref(v___y_872_);
lean_inc(v___y_871_);
lean_inc_ref(v___y_870_);
lean_inc(v___y_869_);
lean_inc_ref(v___y_868_);
lean_inc(v___y_867_);
lean_inc_ref(v___y_866_);
v___x_877_ = lean_apply_11(v_pre_864_, v___y_866_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_, v___y_873_, v___y_874_, v___y_875_, lean_box(0));
if (lean_obj_tag(v___x_877_) == 0)
{
lean_object* v_a_878_; lean_object* v___x_879_; 
v_a_878_ = lean_ctor_get(v___x_877_, 0);
lean_inc(v_a_878_);
v___x_879_ = lean_box(0);
if (lean_obj_tag(v_a_878_) == 0)
{
uint8_t v_done_880_; 
v_done_880_ = lean_ctor_get_uint8(v_a_878_, 0);
if (v_done_880_ == 0)
{
uint8_t v_contextDependent_881_; lean_object* v___x_882_; 
lean_dec_ref_known(v___x_877_, 1);
v_contextDependent_881_ = lean_ctor_get_uint8(v_a_878_, 1);
lean_dec_ref_known(v_a_878_, 0);
v___x_882_ = lean_apply_12(v___f_865_, v___x_879_, v___y_866_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_, v___y_873_, v___y_874_, v___y_875_, lean_box(0));
if (lean_obj_tag(v___x_882_) == 0)
{
lean_object* v_a_883_; uint8_t v___y_885_; 
v_a_883_ = lean_ctor_get(v___x_882_, 0);
lean_inc(v_a_883_);
if (v_contextDependent_881_ == 0)
{
lean_dec(v_a_883_);
return v___x_882_;
}
else
{
if (lean_obj_tag(v_a_883_) == 0)
{
uint8_t v_contextDependent_895_; 
v_contextDependent_895_ = lean_ctor_get_uint8(v_a_883_, 1);
v___y_885_ = v_contextDependent_895_;
goto v___jp_884_;
}
else
{
uint8_t v_contextDependent_896_; 
v_contextDependent_896_ = lean_ctor_get_uint8(v_a_883_, sizeof(void*)*2 + 1);
v___y_885_ = v_contextDependent_896_;
goto v___jp_884_;
}
}
v___jp_884_:
{
if (v___y_885_ == 0)
{
lean_object* v___x_887_; uint8_t v_isShared_888_; uint8_t v_isSharedCheck_893_; 
v_isSharedCheck_893_ = !lean_is_exclusive(v___x_882_);
if (v_isSharedCheck_893_ == 0)
{
lean_object* v_unused_894_; 
v_unused_894_ = lean_ctor_get(v___x_882_, 0);
lean_dec(v_unused_894_);
v___x_887_ = v___x_882_;
v_isShared_888_ = v_isSharedCheck_893_;
goto v_resetjp_886_;
}
else
{
lean_dec(v___x_882_);
v___x_887_ = lean_box(0);
v_isShared_888_ = v_isSharedCheck_893_;
goto v_resetjp_886_;
}
v_resetjp_886_:
{
lean_object* v___x_889_; lean_object* v___x_891_; 
v___x_889_ = l_Lean_Meta_Sym_Simp_Result_withContextDependent(v_a_883_);
if (v_isShared_888_ == 0)
{
lean_ctor_set(v___x_887_, 0, v___x_889_);
v___x_891_ = v___x_887_;
goto v_reusejp_890_;
}
else
{
lean_object* v_reuseFailAlloc_892_; 
v_reuseFailAlloc_892_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_892_, 0, v___x_889_);
v___x_891_ = v_reuseFailAlloc_892_;
goto v_reusejp_890_;
}
v_reusejp_890_:
{
return v___x_891_;
}
}
}
else
{
lean_dec(v_a_883_);
return v___x_882_;
}
}
}
else
{
return v___x_882_;
}
}
else
{
lean_dec_ref_known(v_a_878_, 0);
lean_dec(v___y_875_);
lean_dec_ref(v___y_874_);
lean_dec(v___y_873_);
lean_dec_ref(v___y_872_);
lean_dec(v___y_871_);
lean_dec_ref(v___y_870_);
lean_dec(v___y_869_);
lean_dec_ref(v___y_868_);
lean_dec(v___y_867_);
lean_dec_ref(v___y_866_);
lean_dec_ref(v___f_865_);
return v___x_877_;
}
}
else
{
uint8_t v_done_897_; 
v_done_897_ = lean_ctor_get_uint8(v_a_878_, sizeof(void*)*2);
if (v_done_897_ == 0)
{
lean_object* v_e_x27_898_; lean_object* v_proof_899_; uint8_t v_contextDependent_900_; lean_object* v___x_902_; uint8_t v_isShared_903_; uint8_t v_isSharedCheck_950_; 
lean_dec_ref_known(v___x_877_, 1);
v_e_x27_898_ = lean_ctor_get(v_a_878_, 0);
v_proof_899_ = lean_ctor_get(v_a_878_, 1);
v_contextDependent_900_ = lean_ctor_get_uint8(v_a_878_, sizeof(void*)*2 + 1);
v_isSharedCheck_950_ = !lean_is_exclusive(v_a_878_);
if (v_isSharedCheck_950_ == 0)
{
v___x_902_ = v_a_878_;
v_isShared_903_ = v_isSharedCheck_950_;
goto v_resetjp_901_;
}
else
{
lean_inc(v_proof_899_);
lean_inc(v_e_x27_898_);
lean_dec(v_a_878_);
v___x_902_ = lean_box(0);
v_isShared_903_ = v_isSharedCheck_950_;
goto v_resetjp_901_;
}
v_resetjp_901_:
{
lean_object* v___x_904_; 
lean_inc(v___y_875_);
lean_inc_ref(v___y_874_);
lean_inc(v___y_873_);
lean_inc_ref(v___y_872_);
lean_inc(v___y_871_);
lean_inc_ref(v___y_870_);
lean_inc_ref(v_e_x27_898_);
v___x_904_ = lean_apply_12(v___f_865_, v___x_879_, v_e_x27_898_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_, v___y_873_, v___y_874_, v___y_875_, lean_box(0));
if (lean_obj_tag(v___x_904_) == 0)
{
lean_object* v_a_905_; lean_object* v___x_907_; uint8_t v_isShared_908_; uint8_t v_isSharedCheck_949_; 
v_a_905_ = lean_ctor_get(v___x_904_, 0);
v_isSharedCheck_949_ = !lean_is_exclusive(v___x_904_);
if (v_isSharedCheck_949_ == 0)
{
v___x_907_ = v___x_904_;
v_isShared_908_ = v_isSharedCheck_949_;
goto v_resetjp_906_;
}
else
{
lean_inc(v_a_905_);
lean_dec(v___x_904_);
v___x_907_ = lean_box(0);
v_isShared_908_ = v_isSharedCheck_949_;
goto v_resetjp_906_;
}
v_resetjp_906_:
{
if (lean_obj_tag(v_a_905_) == 0)
{
uint8_t v_done_909_; uint8_t v_contextDependent_910_; uint8_t v___y_912_; 
lean_dec(v___y_875_);
lean_dec_ref(v___y_874_);
lean_dec(v___y_873_);
lean_dec_ref(v___y_872_);
lean_dec(v___y_871_);
lean_dec_ref(v___y_870_);
lean_dec_ref(v___y_866_);
v_done_909_ = lean_ctor_get_uint8(v_a_905_, 0);
v_contextDependent_910_ = lean_ctor_get_uint8(v_a_905_, 1);
lean_dec_ref_known(v_a_905_, 0);
if (v_contextDependent_900_ == 0)
{
v___y_912_ = v_contextDependent_910_;
goto v___jp_911_;
}
else
{
v___y_912_ = v_contextDependent_900_;
goto v___jp_911_;
}
v___jp_911_:
{
lean_object* v___x_914_; 
if (v_isShared_903_ == 0)
{
v___x_914_ = v___x_902_;
goto v_reusejp_913_;
}
else
{
lean_object* v_reuseFailAlloc_918_; 
v_reuseFailAlloc_918_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_918_, 0, v_e_x27_898_);
lean_ctor_set(v_reuseFailAlloc_918_, 1, v_proof_899_);
v___x_914_ = v_reuseFailAlloc_918_;
goto v_reusejp_913_;
}
v_reusejp_913_:
{
lean_object* v___x_916_; 
lean_ctor_set_uint8(v___x_914_, sizeof(void*)*2, v_done_909_);
lean_ctor_set_uint8(v___x_914_, sizeof(void*)*2 + 1, v___y_912_);
if (v_isShared_908_ == 0)
{
lean_ctor_set(v___x_907_, 0, v___x_914_);
v___x_916_ = v___x_907_;
goto v_reusejp_915_;
}
else
{
lean_object* v_reuseFailAlloc_917_; 
v_reuseFailAlloc_917_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_917_, 0, v___x_914_);
v___x_916_ = v_reuseFailAlloc_917_;
goto v_reusejp_915_;
}
v_reusejp_915_:
{
return v___x_916_;
}
}
}
}
else
{
lean_object* v_e_x27_919_; lean_object* v_proof_920_; uint8_t v_done_921_; uint8_t v_contextDependent_922_; lean_object* v___x_924_; uint8_t v_isShared_925_; uint8_t v_isSharedCheck_948_; 
lean_del_object(v___x_907_);
lean_del_object(v___x_902_);
v_e_x27_919_ = lean_ctor_get(v_a_905_, 0);
v_proof_920_ = lean_ctor_get(v_a_905_, 1);
v_done_921_ = lean_ctor_get_uint8(v_a_905_, sizeof(void*)*2);
v_contextDependent_922_ = lean_ctor_get_uint8(v_a_905_, sizeof(void*)*2 + 1);
v_isSharedCheck_948_ = !lean_is_exclusive(v_a_905_);
if (v_isSharedCheck_948_ == 0)
{
v___x_924_ = v_a_905_;
v_isShared_925_ = v_isSharedCheck_948_;
goto v_resetjp_923_;
}
else
{
lean_inc(v_proof_920_);
lean_inc(v_e_x27_919_);
lean_dec(v_a_905_);
v___x_924_ = lean_box(0);
v_isShared_925_ = v_isSharedCheck_948_;
goto v_resetjp_923_;
}
v_resetjp_923_:
{
lean_object* v___x_926_; 
lean_inc_ref(v_e_x27_919_);
v___x_926_ = l_Lean_Meta_Sym_Simp_mkEqTrans(v___y_866_, v_e_x27_898_, v_proof_899_, v_e_x27_919_, v_proof_920_, v___y_870_, v___y_871_, v___y_872_, v___y_873_, v___y_874_, v___y_875_);
lean_dec(v___y_875_);
lean_dec_ref(v___y_874_);
lean_dec(v___y_873_);
lean_dec_ref(v___y_872_);
lean_dec(v___y_871_);
lean_dec_ref(v___y_870_);
if (lean_obj_tag(v___x_926_) == 0)
{
lean_object* v_a_927_; lean_object* v___x_929_; uint8_t v_isShared_930_; uint8_t v_isSharedCheck_939_; 
v_a_927_ = lean_ctor_get(v___x_926_, 0);
v_isSharedCheck_939_ = !lean_is_exclusive(v___x_926_);
if (v_isSharedCheck_939_ == 0)
{
v___x_929_ = v___x_926_;
v_isShared_930_ = v_isSharedCheck_939_;
goto v_resetjp_928_;
}
else
{
lean_inc(v_a_927_);
lean_dec(v___x_926_);
v___x_929_ = lean_box(0);
v_isShared_930_ = v_isSharedCheck_939_;
goto v_resetjp_928_;
}
v_resetjp_928_:
{
uint8_t v___y_932_; 
if (v_contextDependent_900_ == 0)
{
v___y_932_ = v_contextDependent_922_;
goto v___jp_931_;
}
else
{
v___y_932_ = v_contextDependent_900_;
goto v___jp_931_;
}
v___jp_931_:
{
lean_object* v___x_934_; 
if (v_isShared_925_ == 0)
{
lean_ctor_set(v___x_924_, 1, v_a_927_);
v___x_934_ = v___x_924_;
goto v_reusejp_933_;
}
else
{
lean_object* v_reuseFailAlloc_938_; 
v_reuseFailAlloc_938_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_938_, 0, v_e_x27_919_);
lean_ctor_set(v_reuseFailAlloc_938_, 1, v_a_927_);
lean_ctor_set_uint8(v_reuseFailAlloc_938_, sizeof(void*)*2, v_done_921_);
v___x_934_ = v_reuseFailAlloc_938_;
goto v_reusejp_933_;
}
v_reusejp_933_:
{
lean_object* v___x_936_; 
lean_ctor_set_uint8(v___x_934_, sizeof(void*)*2 + 1, v___y_932_);
if (v_isShared_930_ == 0)
{
lean_ctor_set(v___x_929_, 0, v___x_934_);
v___x_936_ = v___x_929_;
goto v_reusejp_935_;
}
else
{
lean_object* v_reuseFailAlloc_937_; 
v_reuseFailAlloc_937_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_937_, 0, v___x_934_);
v___x_936_ = v_reuseFailAlloc_937_;
goto v_reusejp_935_;
}
v_reusejp_935_:
{
return v___x_936_;
}
}
}
}
}
else
{
lean_object* v_a_940_; lean_object* v___x_942_; uint8_t v_isShared_943_; uint8_t v_isSharedCheck_947_; 
lean_del_object(v___x_924_);
lean_dec_ref(v_e_x27_919_);
v_a_940_ = lean_ctor_get(v___x_926_, 0);
v_isSharedCheck_947_ = !lean_is_exclusive(v___x_926_);
if (v_isSharedCheck_947_ == 0)
{
v___x_942_ = v___x_926_;
v_isShared_943_ = v_isSharedCheck_947_;
goto v_resetjp_941_;
}
else
{
lean_inc(v_a_940_);
lean_dec(v___x_926_);
v___x_942_ = lean_box(0);
v_isShared_943_ = v_isSharedCheck_947_;
goto v_resetjp_941_;
}
v_resetjp_941_:
{
lean_object* v___x_945_; 
if (v_isShared_943_ == 0)
{
v___x_945_ = v___x_942_;
goto v_reusejp_944_;
}
else
{
lean_object* v_reuseFailAlloc_946_; 
v_reuseFailAlloc_946_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_946_, 0, v_a_940_);
v___x_945_ = v_reuseFailAlloc_946_;
goto v_reusejp_944_;
}
v_reusejp_944_:
{
return v___x_945_;
}
}
}
}
}
}
}
else
{
lean_del_object(v___x_902_);
lean_dec_ref(v_proof_899_);
lean_dec_ref(v_e_x27_898_);
lean_dec(v___y_875_);
lean_dec_ref(v___y_874_);
lean_dec(v___y_873_);
lean_dec_ref(v___y_872_);
lean_dec(v___y_871_);
lean_dec_ref(v___y_870_);
lean_dec_ref(v___y_866_);
return v___x_904_;
}
}
}
else
{
lean_dec_ref_known(v_a_878_, 2);
lean_dec(v___y_875_);
lean_dec_ref(v___y_874_);
lean_dec(v___y_873_);
lean_dec_ref(v___y_872_);
lean_dec(v___y_871_);
lean_dec_ref(v___y_870_);
lean_dec(v___y_869_);
lean_dec_ref(v___y_868_);
lean_dec(v___y_867_);
lean_dec_ref(v___y_866_);
lean_dec_ref(v___f_865_);
return v___x_877_;
}
}
}
else
{
lean_dec(v___y_875_);
lean_dec_ref(v___y_874_);
lean_dec(v___y_873_);
lean_dec_ref(v___y_872_);
lean_dec(v___y_871_);
lean_dec_ref(v___y_870_);
lean_dec(v___y_869_);
lean_dec_ref(v___y_868_);
lean_dec(v___y_867_);
lean_dec_ref(v___y_866_);
lean_dec_ref(v___f_865_);
return v___x_877_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__4___boxed(lean_object* v_pre_951_, lean_object* v___f_952_, lean_object* v___y_953_, lean_object* v___y_954_, lean_object* v___y_955_, lean_object* v___y_956_, lean_object* v___y_957_, lean_object* v___y_958_, lean_object* v___y_959_, lean_object* v___y_960_, lean_object* v___y_961_, lean_object* v___y_962_, lean_object* v___y_963_){
_start:
{
lean_object* v_res_964_; 
v_res_964_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__4(v_pre_951_, v___f_952_, v___y_953_, v___y_954_, v___y_955_, v___y_956_, v___y_957_, v___y_958_, v___y_959_, v___y_960_, v___y_961_, v___y_962_);
return v_res_964_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5_spec__10(lean_object* v_msgData_965_, lean_object* v___y_966_, lean_object* v___y_967_, lean_object* v___y_968_, lean_object* v___y_969_){
_start:
{
lean_object* v___x_971_; lean_object* v_env_972_; lean_object* v___x_973_; lean_object* v_mctx_974_; lean_object* v_lctx_975_; lean_object* v_options_976_; lean_object* v___x_977_; lean_object* v___x_978_; lean_object* v___x_979_; 
v___x_971_ = lean_st_ref_get(v___y_969_);
v_env_972_ = lean_ctor_get(v___x_971_, 0);
lean_inc_ref(v_env_972_);
lean_dec(v___x_971_);
v___x_973_ = lean_st_ref_get(v___y_967_);
v_mctx_974_ = lean_ctor_get(v___x_973_, 0);
lean_inc_ref(v_mctx_974_);
lean_dec(v___x_973_);
v_lctx_975_ = lean_ctor_get(v___y_966_, 2);
v_options_976_ = lean_ctor_get(v___y_968_, 2);
lean_inc_ref(v_options_976_);
lean_inc_ref(v_lctx_975_);
v___x_977_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_977_, 0, v_env_972_);
lean_ctor_set(v___x_977_, 1, v_mctx_974_);
lean_ctor_set(v___x_977_, 2, v_lctx_975_);
lean_ctor_set(v___x_977_, 3, v_options_976_);
v___x_978_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v___x_978_, 0, v___x_977_);
lean_ctor_set(v___x_978_, 1, v_msgData_965_);
v___x_979_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_979_, 0, v___x_978_);
return v___x_979_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5_spec__10___boxed(lean_object* v_msgData_980_, lean_object* v___y_981_, lean_object* v___y_982_, lean_object* v___y_983_, lean_object* v___y_984_, lean_object* v___y_985_){
_start:
{
lean_object* v_res_986_; 
v_res_986_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5_spec__10(v_msgData_980_, v___y_981_, v___y_982_, v___y_983_, v___y_984_);
lean_dec(v___y_984_);
lean_dec_ref(v___y_983_);
lean_dec(v___y_982_);
lean_dec_ref(v___y_981_);
return v_res_986_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___redArg(lean_object* v_msg_987_, lean_object* v___y_988_, lean_object* v___y_989_, lean_object* v___y_990_, lean_object* v___y_991_){
_start:
{
lean_object* v_ref_993_; lean_object* v___x_994_; lean_object* v_a_995_; lean_object* v___x_997_; uint8_t v_isShared_998_; uint8_t v_isSharedCheck_1003_; 
v_ref_993_ = lean_ctor_get(v___y_990_, 5);
v___x_994_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5_spec__10(v_msg_987_, v___y_988_, v___y_989_, v___y_990_, v___y_991_);
v_a_995_ = lean_ctor_get(v___x_994_, 0);
v_isSharedCheck_1003_ = !lean_is_exclusive(v___x_994_);
if (v_isSharedCheck_1003_ == 0)
{
v___x_997_ = v___x_994_;
v_isShared_998_ = v_isSharedCheck_1003_;
goto v_resetjp_996_;
}
else
{
lean_inc(v_a_995_);
lean_dec(v___x_994_);
v___x_997_ = lean_box(0);
v_isShared_998_ = v_isSharedCheck_1003_;
goto v_resetjp_996_;
}
v_resetjp_996_:
{
lean_object* v___x_999_; lean_object* v___x_1001_; 
lean_inc(v_ref_993_);
v___x_999_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_999_, 0, v_ref_993_);
lean_ctor_set(v___x_999_, 1, v_a_995_);
if (v_isShared_998_ == 0)
{
lean_ctor_set_tag(v___x_997_, 1);
lean_ctor_set(v___x_997_, 0, v___x_999_);
v___x_1001_ = v___x_997_;
goto v_reusejp_1000_;
}
else
{
lean_object* v_reuseFailAlloc_1002_; 
v_reuseFailAlloc_1002_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1002_, 0, v___x_999_);
v___x_1001_ = v_reuseFailAlloc_1002_;
goto v_reusejp_1000_;
}
v_reusejp_1000_:
{
return v___x_1001_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___redArg___boxed(lean_object* v_msg_1004_, lean_object* v___y_1005_, lean_object* v___y_1006_, lean_object* v___y_1007_, lean_object* v___y_1008_, lean_object* v___y_1009_){
_start:
{
lean_object* v_res_1010_; 
v_res_1010_ = l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___redArg(v_msg_1004_, v___y_1005_, v___y_1006_, v___y_1007_, v___y_1008_);
lean_dec(v___y_1008_);
lean_dec_ref(v___y_1007_);
lean_dec(v___y_1006_);
lean_dec_ref(v___y_1005_);
return v_res_1010_;
}
}
static lean_object* _init_l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1(void){
_start:
{
lean_object* v___x_1012_; lean_object* v___x_1013_; 
v___x_1012_ = ((lean_object*)(l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__0));
v___x_1013_ = l_Lean_stringToMessageData(v___x_1012_);
return v___x_1013_;
}
}
static lean_object* _init_l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__3(void){
_start:
{
lean_object* v___x_1015_; lean_object* v___x_1016_; 
v___x_1015_ = ((lean_object*)(l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__2));
v___x_1016_ = l_Lean_stringToMessageData(v___x_1015_);
return v___x_1016_;
}
}
LEAN_EXPORT lean_object* l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0(lean_object* v_constName_1017_, lean_object* v___y_1018_, lean_object* v___y_1019_, lean_object* v___y_1020_, lean_object* v___y_1021_, lean_object* v___y_1022_, lean_object* v___y_1023_, lean_object* v___y_1024_, lean_object* v___y_1025_){
_start:
{
lean_object* v___x_1027_; lean_object* v_env_1028_; lean_object* v___x_1029_; 
v___x_1027_ = lean_st_ref_get(v___y_1025_);
v_env_1028_ = lean_ctor_get(v___x_1027_, 0);
lean_inc_ref(v_env_1028_);
lean_dec(v___x_1027_);
lean_inc(v_constName_1017_);
v___x_1029_ = l_Lean_isInductiveCore_x3f(v_env_1028_, v_constName_1017_);
if (lean_obj_tag(v___x_1029_) == 0)
{
lean_object* v___x_1030_; uint8_t v___x_1031_; lean_object* v___x_1032_; lean_object* v___x_1033_; lean_object* v___x_1034_; lean_object* v___x_1035_; lean_object* v___x_1036_; 
v___x_1030_ = lean_obj_once(&l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1, &l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1_once, _init_l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1);
v___x_1031_ = 0;
v___x_1032_ = l_Lean_MessageData_ofConstName(v_constName_1017_, v___x_1031_);
v___x_1033_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1033_, 0, v___x_1030_);
lean_ctor_set(v___x_1033_, 1, v___x_1032_);
v___x_1034_ = lean_obj_once(&l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__3, &l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__3_once, _init_l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__3);
v___x_1035_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1035_, 0, v___x_1033_);
lean_ctor_set(v___x_1035_, 1, v___x_1034_);
v___x_1036_ = l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___redArg(v___x_1035_, v___y_1022_, v___y_1023_, v___y_1024_, v___y_1025_);
return v___x_1036_;
}
else
{
lean_object* v_val_1037_; lean_object* v___x_1039_; uint8_t v_isShared_1040_; uint8_t v_isSharedCheck_1044_; 
lean_dec(v_constName_1017_);
v_val_1037_ = lean_ctor_get(v___x_1029_, 0);
v_isSharedCheck_1044_ = !lean_is_exclusive(v___x_1029_);
if (v_isSharedCheck_1044_ == 0)
{
v___x_1039_ = v___x_1029_;
v_isShared_1040_ = v_isSharedCheck_1044_;
goto v_resetjp_1038_;
}
else
{
lean_inc(v_val_1037_);
lean_dec(v___x_1029_);
v___x_1039_ = lean_box(0);
v_isShared_1040_ = v_isSharedCheck_1044_;
goto v_resetjp_1038_;
}
v_resetjp_1038_:
{
lean_object* v___x_1042_; 
if (v_isShared_1040_ == 0)
{
lean_ctor_set_tag(v___x_1039_, 0);
v___x_1042_ = v___x_1039_;
goto v_reusejp_1041_;
}
else
{
lean_object* v_reuseFailAlloc_1043_; 
v_reuseFailAlloc_1043_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1043_, 0, v_val_1037_);
v___x_1042_ = v_reuseFailAlloc_1043_;
goto v_reusejp_1041_;
}
v_reusejp_1041_:
{
return v___x_1042_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___boxed(lean_object* v_constName_1045_, lean_object* v___y_1046_, lean_object* v___y_1047_, lean_object* v___y_1048_, lean_object* v___y_1049_, lean_object* v___y_1050_, lean_object* v___y_1051_, lean_object* v___y_1052_, lean_object* v___y_1053_, lean_object* v___y_1054_){
_start:
{
lean_object* v_res_1055_; 
v_res_1055_ = l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0(v_constName_1045_, v___y_1046_, v___y_1047_, v___y_1048_, v___y_1049_, v___y_1050_, v___y_1051_, v___y_1052_, v___y_1053_);
lean_dec(v___y_1053_);
lean_dec_ref(v___y_1052_);
lean_dec(v___y_1051_);
lean_dec_ref(v___y_1050_);
lean_dec(v___y_1049_);
lean_dec_ref(v___y_1048_);
lean_dec(v___y_1047_);
lean_dec_ref(v___y_1046_);
return v_res_1055_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16___redArg(lean_object* v_ref_1056_, lean_object* v_msg_1057_, lean_object* v___y_1058_, lean_object* v___y_1059_, lean_object* v___y_1060_, lean_object* v___y_1061_, lean_object* v___y_1062_, lean_object* v___y_1063_, lean_object* v___y_1064_, lean_object* v___y_1065_){
_start:
{
lean_object* v_fileName_1067_; lean_object* v_fileMap_1068_; lean_object* v_options_1069_; lean_object* v_currRecDepth_1070_; lean_object* v_maxRecDepth_1071_; lean_object* v_ref_1072_; lean_object* v_currNamespace_1073_; lean_object* v_openDecls_1074_; lean_object* v_initHeartbeats_1075_; lean_object* v_maxHeartbeats_1076_; lean_object* v_quotContext_1077_; lean_object* v_currMacroScope_1078_; uint8_t v_diag_1079_; lean_object* v_cancelTk_x3f_1080_; uint8_t v_suppressElabErrors_1081_; lean_object* v_inheritedTraceOptions_1082_; lean_object* v_ref_1083_; lean_object* v___x_1084_; lean_object* v___x_1085_; 
v_fileName_1067_ = lean_ctor_get(v___y_1064_, 0);
v_fileMap_1068_ = lean_ctor_get(v___y_1064_, 1);
v_options_1069_ = lean_ctor_get(v___y_1064_, 2);
v_currRecDepth_1070_ = lean_ctor_get(v___y_1064_, 3);
v_maxRecDepth_1071_ = lean_ctor_get(v___y_1064_, 4);
v_ref_1072_ = lean_ctor_get(v___y_1064_, 5);
v_currNamespace_1073_ = lean_ctor_get(v___y_1064_, 6);
v_openDecls_1074_ = lean_ctor_get(v___y_1064_, 7);
v_initHeartbeats_1075_ = lean_ctor_get(v___y_1064_, 8);
v_maxHeartbeats_1076_ = lean_ctor_get(v___y_1064_, 9);
v_quotContext_1077_ = lean_ctor_get(v___y_1064_, 10);
v_currMacroScope_1078_ = lean_ctor_get(v___y_1064_, 11);
v_diag_1079_ = lean_ctor_get_uint8(v___y_1064_, sizeof(void*)*14);
v_cancelTk_x3f_1080_ = lean_ctor_get(v___y_1064_, 12);
v_suppressElabErrors_1081_ = lean_ctor_get_uint8(v___y_1064_, sizeof(void*)*14 + 1);
v_inheritedTraceOptions_1082_ = lean_ctor_get(v___y_1064_, 13);
v_ref_1083_ = l_Lean_replaceRef(v_ref_1056_, v_ref_1072_);
lean_inc_ref(v_inheritedTraceOptions_1082_);
lean_inc(v_cancelTk_x3f_1080_);
lean_inc(v_currMacroScope_1078_);
lean_inc(v_quotContext_1077_);
lean_inc(v_maxHeartbeats_1076_);
lean_inc(v_initHeartbeats_1075_);
lean_inc(v_openDecls_1074_);
lean_inc(v_currNamespace_1073_);
lean_inc(v_maxRecDepth_1071_);
lean_inc(v_currRecDepth_1070_);
lean_inc_ref(v_options_1069_);
lean_inc_ref(v_fileMap_1068_);
lean_inc_ref(v_fileName_1067_);
v___x_1084_ = lean_alloc_ctor(0, 14, 2);
lean_ctor_set(v___x_1084_, 0, v_fileName_1067_);
lean_ctor_set(v___x_1084_, 1, v_fileMap_1068_);
lean_ctor_set(v___x_1084_, 2, v_options_1069_);
lean_ctor_set(v___x_1084_, 3, v_currRecDepth_1070_);
lean_ctor_set(v___x_1084_, 4, v_maxRecDepth_1071_);
lean_ctor_set(v___x_1084_, 5, v_ref_1083_);
lean_ctor_set(v___x_1084_, 6, v_currNamespace_1073_);
lean_ctor_set(v___x_1084_, 7, v_openDecls_1074_);
lean_ctor_set(v___x_1084_, 8, v_initHeartbeats_1075_);
lean_ctor_set(v___x_1084_, 9, v_maxHeartbeats_1076_);
lean_ctor_set(v___x_1084_, 10, v_quotContext_1077_);
lean_ctor_set(v___x_1084_, 11, v_currMacroScope_1078_);
lean_ctor_set(v___x_1084_, 12, v_cancelTk_x3f_1080_);
lean_ctor_set(v___x_1084_, 13, v_inheritedTraceOptions_1082_);
lean_ctor_set_uint8(v___x_1084_, sizeof(void*)*14, v_diag_1079_);
lean_ctor_set_uint8(v___x_1084_, sizeof(void*)*14 + 1, v_suppressElabErrors_1081_);
v___x_1085_ = l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___redArg(v_msg_1057_, v___y_1062_, v___y_1063_, v___x_1084_, v___y_1065_);
lean_dec_ref_known(v___x_1084_, 14);
return v___x_1085_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16___redArg___boxed(lean_object* v_ref_1086_, lean_object* v_msg_1087_, lean_object* v___y_1088_, lean_object* v___y_1089_, lean_object* v___y_1090_, lean_object* v___y_1091_, lean_object* v___y_1092_, lean_object* v___y_1093_, lean_object* v___y_1094_, lean_object* v___y_1095_, lean_object* v___y_1096_){
_start:
{
lean_object* v_res_1097_; 
v_res_1097_ = l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16___redArg(v_ref_1086_, v_msg_1087_, v___y_1088_, v___y_1089_, v___y_1090_, v___y_1091_, v___y_1092_, v___y_1093_, v___y_1094_, v___y_1095_);
lean_dec(v___y_1095_);
lean_dec_ref(v___y_1094_);
lean_dec(v___y_1093_);
lean_dec_ref(v___y_1092_);
lean_dec(v___y_1091_);
lean_dec_ref(v___y_1090_);
lean_dec(v___y_1089_);
lean_dec_ref(v___y_1088_);
lean_dec(v_ref_1086_);
return v_res_1097_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__0(void){
_start:
{
lean_object* v___x_1098_; 
v___x_1098_ = l_Lean_PersistentHashMap_mkEmptyEntriesArray(lean_box(0), lean_box(0));
return v___x_1098_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__1(void){
_start:
{
lean_object* v___x_1099_; lean_object* v___x_1100_; 
v___x_1099_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__0, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__0_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__0);
v___x_1100_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1100_, 0, v___x_1099_);
return v___x_1100_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__2(void){
_start:
{
lean_object* v___x_1101_; lean_object* v___x_1102_; lean_object* v___x_1103_; 
v___x_1101_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__1, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__1_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__1);
v___x_1102_ = lean_unsigned_to_nat(0u);
v___x_1103_ = lean_alloc_ctor(0, 10, 0);
lean_ctor_set(v___x_1103_, 0, v___x_1102_);
lean_ctor_set(v___x_1103_, 1, v___x_1102_);
lean_ctor_set(v___x_1103_, 2, v___x_1102_);
lean_ctor_set(v___x_1103_, 3, v___x_1102_);
lean_ctor_set(v___x_1103_, 4, v___x_1101_);
lean_ctor_set(v___x_1103_, 5, v___x_1101_);
lean_ctor_set(v___x_1103_, 6, v___x_1101_);
lean_ctor_set(v___x_1103_, 7, v___x_1101_);
lean_ctor_set(v___x_1103_, 8, v___x_1101_);
lean_ctor_set(v___x_1103_, 9, v___x_1101_);
return v___x_1103_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__3(void){
_start:
{
lean_object* v___x_1104_; lean_object* v___x_1105_; lean_object* v___x_1106_; 
v___x_1104_ = lean_unsigned_to_nat(32u);
v___x_1105_ = lean_mk_empty_array_with_capacity(v___x_1104_);
v___x_1106_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1106_, 0, v___x_1105_);
return v___x_1106_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__4(void){
_start:
{
size_t v___x_1107_; lean_object* v___x_1108_; lean_object* v___x_1109_; lean_object* v___x_1110_; lean_object* v___x_1111_; lean_object* v___x_1112_; 
v___x_1107_ = ((size_t)5ULL);
v___x_1108_ = lean_unsigned_to_nat(0u);
v___x_1109_ = lean_unsigned_to_nat(32u);
v___x_1110_ = lean_mk_empty_array_with_capacity(v___x_1109_);
v___x_1111_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__3, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__3_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__3);
v___x_1112_ = lean_alloc_ctor(0, 4, sizeof(size_t)*1);
lean_ctor_set(v___x_1112_, 0, v___x_1111_);
lean_ctor_set(v___x_1112_, 1, v___x_1110_);
lean_ctor_set(v___x_1112_, 2, v___x_1108_);
lean_ctor_set(v___x_1112_, 3, v___x_1108_);
lean_ctor_set_usize(v___x_1112_, 4, v___x_1107_);
return v___x_1112_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__5(void){
_start:
{
lean_object* v___x_1113_; lean_object* v___x_1114_; lean_object* v___x_1115_; lean_object* v___x_1116_; 
v___x_1113_ = lean_box(1);
v___x_1114_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__4, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__4_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__4);
v___x_1115_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__1, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__1_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__1);
v___x_1116_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v___x_1116_, 0, v___x_1115_);
lean_ctor_set(v___x_1116_, 1, v___x_1114_);
lean_ctor_set(v___x_1116_, 2, v___x_1113_);
return v___x_1116_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__7(void){
_start:
{
lean_object* v___x_1118_; lean_object* v___x_1119_; 
v___x_1118_ = ((lean_object*)(l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__6));
v___x_1119_ = l_Lean_stringToMessageData(v___x_1118_);
return v___x_1119_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__9(void){
_start:
{
lean_object* v___x_1121_; lean_object* v___x_1122_; 
v___x_1121_ = ((lean_object*)(l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__8));
v___x_1122_ = l_Lean_stringToMessageData(v___x_1121_);
return v___x_1122_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__11(void){
_start:
{
lean_object* v___x_1124_; lean_object* v___x_1125_; 
v___x_1124_ = ((lean_object*)(l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__10));
v___x_1125_ = l_Lean_stringToMessageData(v___x_1124_);
return v___x_1125_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__13(void){
_start:
{
lean_object* v___x_1127_; lean_object* v___x_1128_; 
v___x_1127_ = ((lean_object*)(l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__12));
v___x_1128_ = l_Lean_stringToMessageData(v___x_1127_);
return v___x_1128_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__15(void){
_start:
{
lean_object* v___x_1130_; lean_object* v___x_1131_; 
v___x_1130_ = ((lean_object*)(l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__14));
v___x_1131_ = l_Lean_stringToMessageData(v___x_1130_);
return v___x_1131_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__17(void){
_start:
{
lean_object* v___x_1133_; lean_object* v___x_1134_; 
v___x_1133_ = ((lean_object*)(l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__16));
v___x_1134_ = l_Lean_stringToMessageData(v___x_1133_);
return v___x_1134_;
}
}
static lean_object* _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__19(void){
_start:
{
lean_object* v___x_1136_; lean_object* v___x_1137_; 
v___x_1136_ = ((lean_object*)(l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__18));
v___x_1137_ = l_Lean_stringToMessageData(v___x_1136_);
return v___x_1137_;
}
}
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg(lean_object* v_msg_1138_, lean_object* v_declHint_1139_, lean_object* v___y_1140_){
_start:
{
lean_object* v___x_1142_; lean_object* v_env_1143_; uint8_t v___x_1144_; 
v___x_1142_ = lean_st_ref_get(v___y_1140_);
v_env_1143_ = lean_ctor_get(v___x_1142_, 0);
lean_inc_ref(v_env_1143_);
lean_dec(v___x_1142_);
v___x_1144_ = l_Lean_Name_isAnonymous(v_declHint_1139_);
if (v___x_1144_ == 0)
{
uint8_t v_isExporting_1145_; 
v_isExporting_1145_ = lean_ctor_get_uint8(v_env_1143_, sizeof(void*)*8);
if (v_isExporting_1145_ == 0)
{
lean_object* v___x_1146_; 
lean_dec_ref(v_env_1143_);
lean_dec(v_declHint_1139_);
v___x_1146_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1146_, 0, v_msg_1138_);
return v___x_1146_;
}
else
{
lean_object* v___x_1147_; uint8_t v___x_1148_; 
lean_inc_ref(v_env_1143_);
v___x_1147_ = l_Lean_Environment_setExporting(v_env_1143_, v___x_1144_);
lean_inc(v_declHint_1139_);
lean_inc_ref(v___x_1147_);
v___x_1148_ = l_Lean_Environment_contains(v___x_1147_, v_declHint_1139_, v_isExporting_1145_);
if (v___x_1148_ == 0)
{
lean_object* v___x_1149_; 
lean_dec_ref(v___x_1147_);
lean_dec_ref(v_env_1143_);
lean_dec(v_declHint_1139_);
v___x_1149_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1149_, 0, v_msg_1138_);
return v___x_1149_;
}
else
{
lean_object* v___x_1150_; lean_object* v___x_1151_; lean_object* v___x_1152_; lean_object* v___x_1153_; lean_object* v___x_1154_; lean_object* v_c_1155_; lean_object* v___x_1156_; 
v___x_1150_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__2, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__2_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__2);
v___x_1151_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__5, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__5_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__5);
v___x_1152_ = l_Lean_Options_empty;
v___x_1153_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_1153_, 0, v___x_1147_);
lean_ctor_set(v___x_1153_, 1, v___x_1150_);
lean_ctor_set(v___x_1153_, 2, v___x_1151_);
lean_ctor_set(v___x_1153_, 3, v___x_1152_);
lean_inc(v_declHint_1139_);
v___x_1154_ = l_Lean_MessageData_ofConstName(v_declHint_1139_, v___x_1144_);
v_c_1155_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v_c_1155_, 0, v___x_1153_);
lean_ctor_set(v_c_1155_, 1, v___x_1154_);
v___x_1156_ = l_Lean_Environment_getModuleIdxFor_x3f(v_env_1143_, v_declHint_1139_);
if (lean_obj_tag(v___x_1156_) == 0)
{
lean_object* v___x_1157_; lean_object* v___x_1158_; lean_object* v___x_1159_; lean_object* v___x_1160_; lean_object* v___x_1161_; lean_object* v___x_1162_; lean_object* v___x_1163_; 
lean_dec_ref(v_env_1143_);
lean_dec(v_declHint_1139_);
v___x_1157_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__7, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__7_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__7);
v___x_1158_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1158_, 0, v___x_1157_);
lean_ctor_set(v___x_1158_, 1, v_c_1155_);
v___x_1159_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__9, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__9_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__9);
v___x_1160_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1160_, 0, v___x_1158_);
lean_ctor_set(v___x_1160_, 1, v___x_1159_);
v___x_1161_ = l_Lean_MessageData_note(v___x_1160_);
v___x_1162_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1162_, 0, v_msg_1138_);
lean_ctor_set(v___x_1162_, 1, v___x_1161_);
v___x_1163_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1163_, 0, v___x_1162_);
return v___x_1163_;
}
else
{
lean_object* v_val_1164_; lean_object* v___x_1166_; uint8_t v_isShared_1167_; uint8_t v_isSharedCheck_1199_; 
v_val_1164_ = lean_ctor_get(v___x_1156_, 0);
v_isSharedCheck_1199_ = !lean_is_exclusive(v___x_1156_);
if (v_isSharedCheck_1199_ == 0)
{
v___x_1166_ = v___x_1156_;
v_isShared_1167_ = v_isSharedCheck_1199_;
goto v_resetjp_1165_;
}
else
{
lean_inc(v_val_1164_);
lean_dec(v___x_1156_);
v___x_1166_ = lean_box(0);
v_isShared_1167_ = v_isSharedCheck_1199_;
goto v_resetjp_1165_;
}
v_resetjp_1165_:
{
lean_object* v___x_1168_; lean_object* v___x_1169_; lean_object* v___x_1170_; lean_object* v_mod_1171_; uint8_t v___x_1172_; 
v___x_1168_ = lean_box(0);
v___x_1169_ = l_Lean_Environment_header(v_env_1143_);
lean_dec_ref(v_env_1143_);
v___x_1170_ = l_Lean_EnvironmentHeader_moduleNames(v___x_1169_);
v_mod_1171_ = lean_array_get(v___x_1168_, v___x_1170_, v_val_1164_);
lean_dec(v_val_1164_);
lean_dec_ref(v___x_1170_);
v___x_1172_ = l_Lean_isPrivateName(v_declHint_1139_);
lean_dec(v_declHint_1139_);
if (v___x_1172_ == 0)
{
lean_object* v___x_1173_; lean_object* v___x_1174_; lean_object* v___x_1175_; lean_object* v___x_1176_; lean_object* v___x_1177_; lean_object* v___x_1178_; lean_object* v___x_1179_; lean_object* v___x_1180_; lean_object* v___x_1181_; lean_object* v___x_1182_; lean_object* v___x_1184_; 
v___x_1173_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__11, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__11_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__11);
v___x_1174_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1174_, 0, v___x_1173_);
lean_ctor_set(v___x_1174_, 1, v_c_1155_);
v___x_1175_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__13, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__13_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__13);
v___x_1176_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1176_, 0, v___x_1174_);
lean_ctor_set(v___x_1176_, 1, v___x_1175_);
v___x_1177_ = l_Lean_MessageData_ofName(v_mod_1171_);
v___x_1178_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1178_, 0, v___x_1176_);
lean_ctor_set(v___x_1178_, 1, v___x_1177_);
v___x_1179_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__15, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__15_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__15);
v___x_1180_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1180_, 0, v___x_1178_);
lean_ctor_set(v___x_1180_, 1, v___x_1179_);
v___x_1181_ = l_Lean_MessageData_note(v___x_1180_);
v___x_1182_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1182_, 0, v_msg_1138_);
lean_ctor_set(v___x_1182_, 1, v___x_1181_);
if (v_isShared_1167_ == 0)
{
lean_ctor_set_tag(v___x_1166_, 0);
lean_ctor_set(v___x_1166_, 0, v___x_1182_);
v___x_1184_ = v___x_1166_;
goto v_reusejp_1183_;
}
else
{
lean_object* v_reuseFailAlloc_1185_; 
v_reuseFailAlloc_1185_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1185_, 0, v___x_1182_);
v___x_1184_ = v_reuseFailAlloc_1185_;
goto v_reusejp_1183_;
}
v_reusejp_1183_:
{
return v___x_1184_;
}
}
else
{
lean_object* v___x_1186_; lean_object* v___x_1187_; lean_object* v___x_1188_; lean_object* v___x_1189_; lean_object* v___x_1190_; lean_object* v___x_1191_; lean_object* v___x_1192_; lean_object* v___x_1193_; lean_object* v___x_1194_; lean_object* v___x_1195_; lean_object* v___x_1197_; 
v___x_1186_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__7, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__7_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__7);
v___x_1187_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1187_, 0, v___x_1186_);
lean_ctor_set(v___x_1187_, 1, v_c_1155_);
v___x_1188_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__17, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__17_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__17);
v___x_1189_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1189_, 0, v___x_1187_);
lean_ctor_set(v___x_1189_, 1, v___x_1188_);
v___x_1190_ = l_Lean_MessageData_ofName(v_mod_1171_);
v___x_1191_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1191_, 0, v___x_1189_);
lean_ctor_set(v___x_1191_, 1, v___x_1190_);
v___x_1192_ = lean_obj_once(&l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__19, &l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__19_once, _init_l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___closed__19);
v___x_1193_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1193_, 0, v___x_1191_);
lean_ctor_set(v___x_1193_, 1, v___x_1192_);
v___x_1194_ = l_Lean_MessageData_note(v___x_1193_);
v___x_1195_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1195_, 0, v_msg_1138_);
lean_ctor_set(v___x_1195_, 1, v___x_1194_);
if (v_isShared_1167_ == 0)
{
lean_ctor_set_tag(v___x_1166_, 0);
lean_ctor_set(v___x_1166_, 0, v___x_1195_);
v___x_1197_ = v___x_1166_;
goto v_reusejp_1196_;
}
else
{
lean_object* v_reuseFailAlloc_1198_; 
v_reuseFailAlloc_1198_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1198_, 0, v___x_1195_);
v___x_1197_ = v_reuseFailAlloc_1198_;
goto v_reusejp_1196_;
}
v_reusejp_1196_:
{
return v___x_1197_;
}
}
}
}
}
}
}
else
{
lean_object* v___x_1200_; 
lean_dec_ref(v_env_1143_);
lean_dec(v_declHint_1139_);
v___x_1200_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1200_, 0, v_msg_1138_);
return v___x_1200_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg___boxed(lean_object* v_msg_1201_, lean_object* v_declHint_1202_, lean_object* v___y_1203_, lean_object* v___y_1204_){
_start:
{
lean_object* v_res_1205_; 
v_res_1205_ = l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg(v_msg_1201_, v_declHint_1202_, v___y_1203_);
lean_dec(v___y_1203_);
return v_res_1205_;
}
}
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15(lean_object* v_msg_1206_, lean_object* v_declHint_1207_, lean_object* v___y_1208_, lean_object* v___y_1209_, lean_object* v___y_1210_, lean_object* v___y_1211_, lean_object* v___y_1212_, lean_object* v___y_1213_, lean_object* v___y_1214_, lean_object* v___y_1215_){
_start:
{
lean_object* v___x_1217_; lean_object* v_a_1218_; lean_object* v___x_1220_; uint8_t v_isShared_1221_; uint8_t v_isSharedCheck_1227_; 
v___x_1217_ = l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg(v_msg_1206_, v_declHint_1207_, v___y_1215_);
v_a_1218_ = lean_ctor_get(v___x_1217_, 0);
v_isSharedCheck_1227_ = !lean_is_exclusive(v___x_1217_);
if (v_isSharedCheck_1227_ == 0)
{
v___x_1220_ = v___x_1217_;
v_isShared_1221_ = v_isSharedCheck_1227_;
goto v_resetjp_1219_;
}
else
{
lean_inc(v_a_1218_);
lean_dec(v___x_1217_);
v___x_1220_ = lean_box(0);
v_isShared_1221_ = v_isSharedCheck_1227_;
goto v_resetjp_1219_;
}
v_resetjp_1219_:
{
lean_object* v___x_1222_; lean_object* v___x_1223_; lean_object* v___x_1225_; 
v___x_1222_ = l_Lean_unknownIdentifierMessageTag;
v___x_1223_ = lean_alloc_ctor(8, 2, 0);
lean_ctor_set(v___x_1223_, 0, v___x_1222_);
lean_ctor_set(v___x_1223_, 1, v_a_1218_);
if (v_isShared_1221_ == 0)
{
lean_ctor_set(v___x_1220_, 0, v___x_1223_);
v___x_1225_ = v___x_1220_;
goto v_reusejp_1224_;
}
else
{
lean_object* v_reuseFailAlloc_1226_; 
v_reuseFailAlloc_1226_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1226_, 0, v___x_1223_);
v___x_1225_ = v_reuseFailAlloc_1226_;
goto v_reusejp_1224_;
}
v_reusejp_1224_:
{
return v___x_1225_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15___boxed(lean_object* v_msg_1228_, lean_object* v_declHint_1229_, lean_object* v___y_1230_, lean_object* v___y_1231_, lean_object* v___y_1232_, lean_object* v___y_1233_, lean_object* v___y_1234_, lean_object* v___y_1235_, lean_object* v___y_1236_, lean_object* v___y_1237_, lean_object* v___y_1238_){
_start:
{
lean_object* v_res_1239_; 
v_res_1239_ = l_Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15(v_msg_1228_, v_declHint_1229_, v___y_1230_, v___y_1231_, v___y_1232_, v___y_1233_, v___y_1234_, v___y_1235_, v___y_1236_, v___y_1237_);
lean_dec(v___y_1237_);
lean_dec_ref(v___y_1236_);
lean_dec(v___y_1235_);
lean_dec_ref(v___y_1234_);
lean_dec(v___y_1233_);
lean_dec_ref(v___y_1232_);
lean_dec(v___y_1231_);
lean_dec_ref(v___y_1230_);
return v_res_1239_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11___redArg(lean_object* v_ref_1240_, lean_object* v_msg_1241_, lean_object* v_declHint_1242_, lean_object* v___y_1243_, lean_object* v___y_1244_, lean_object* v___y_1245_, lean_object* v___y_1246_, lean_object* v___y_1247_, lean_object* v___y_1248_, lean_object* v___y_1249_, lean_object* v___y_1250_){
_start:
{
lean_object* v___x_1252_; lean_object* v_a_1253_; lean_object* v___x_1254_; 
v___x_1252_ = l_Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15(v_msg_1241_, v_declHint_1242_, v___y_1243_, v___y_1244_, v___y_1245_, v___y_1246_, v___y_1247_, v___y_1248_, v___y_1249_, v___y_1250_);
v_a_1253_ = lean_ctor_get(v___x_1252_, 0);
lean_inc(v_a_1253_);
lean_dec_ref(v___x_1252_);
v___x_1254_ = l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16___redArg(v_ref_1240_, v_a_1253_, v___y_1243_, v___y_1244_, v___y_1245_, v___y_1246_, v___y_1247_, v___y_1248_, v___y_1249_, v___y_1250_);
return v___x_1254_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11___redArg___boxed(lean_object* v_ref_1255_, lean_object* v_msg_1256_, lean_object* v_declHint_1257_, lean_object* v___y_1258_, lean_object* v___y_1259_, lean_object* v___y_1260_, lean_object* v___y_1261_, lean_object* v___y_1262_, lean_object* v___y_1263_, lean_object* v___y_1264_, lean_object* v___y_1265_, lean_object* v___y_1266_){
_start:
{
lean_object* v_res_1267_; 
v_res_1267_ = l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11___redArg(v_ref_1255_, v_msg_1256_, v_declHint_1257_, v___y_1258_, v___y_1259_, v___y_1260_, v___y_1261_, v___y_1262_, v___y_1263_, v___y_1264_, v___y_1265_);
lean_dec(v___y_1265_);
lean_dec_ref(v___y_1264_);
lean_dec(v___y_1263_);
lean_dec_ref(v___y_1262_);
lean_dec(v___y_1261_);
lean_dec_ref(v___y_1260_);
lean_dec(v___y_1259_);
lean_dec_ref(v___y_1258_);
lean_dec(v_ref_1255_);
return v_res_1267_;
}
}
static lean_object* _init_l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__1(void){
_start:
{
lean_object* v___x_1269_; lean_object* v___x_1270_; 
v___x_1269_ = ((lean_object*)(l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__0));
v___x_1270_ = l_Lean_stringToMessageData(v___x_1269_);
return v___x_1270_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg(lean_object* v_ref_1271_, lean_object* v_constName_1272_, lean_object* v___y_1273_, lean_object* v___y_1274_, lean_object* v___y_1275_, lean_object* v___y_1276_, lean_object* v___y_1277_, lean_object* v___y_1278_, lean_object* v___y_1279_, lean_object* v___y_1280_){
_start:
{
lean_object* v___x_1282_; uint8_t v___x_1283_; lean_object* v___x_1284_; lean_object* v___x_1285_; lean_object* v___x_1286_; lean_object* v___x_1287_; lean_object* v___x_1288_; 
v___x_1282_ = lean_obj_once(&l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__1, &l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__1_once, _init_l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___closed__1);
v___x_1283_ = 0;
lean_inc(v_constName_1272_);
v___x_1284_ = l_Lean_MessageData_ofConstName(v_constName_1272_, v___x_1283_);
v___x_1285_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1285_, 0, v___x_1282_);
lean_ctor_set(v___x_1285_, 1, v___x_1284_);
v___x_1286_ = lean_obj_once(&l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1, &l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1_once, _init_l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1);
v___x_1287_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1287_, 0, v___x_1285_);
lean_ctor_set(v___x_1287_, 1, v___x_1286_);
v___x_1288_ = l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11___redArg(v_ref_1271_, v___x_1287_, v_constName_1272_, v___y_1273_, v___y_1274_, v___y_1275_, v___y_1276_, v___y_1277_, v___y_1278_, v___y_1279_, v___y_1280_);
return v___x_1288_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg___boxed(lean_object* v_ref_1289_, lean_object* v_constName_1290_, lean_object* v___y_1291_, lean_object* v___y_1292_, lean_object* v___y_1293_, lean_object* v___y_1294_, lean_object* v___y_1295_, lean_object* v___y_1296_, lean_object* v___y_1297_, lean_object* v___y_1298_, lean_object* v___y_1299_){
_start:
{
lean_object* v_res_1300_; 
v_res_1300_ = l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg(v_ref_1289_, v_constName_1290_, v___y_1291_, v___y_1292_, v___y_1293_, v___y_1294_, v___y_1295_, v___y_1296_, v___y_1297_, v___y_1298_);
lean_dec(v___y_1298_);
lean_dec_ref(v___y_1297_);
lean_dec(v___y_1296_);
lean_dec_ref(v___y_1295_);
lean_dec(v___y_1294_);
lean_dec_ref(v___y_1293_);
lean_dec(v___y_1292_);
lean_dec_ref(v___y_1291_);
lean_dec(v_ref_1289_);
return v_res_1300_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2___redArg(lean_object* v_constName_1301_, lean_object* v___y_1302_, lean_object* v___y_1303_, lean_object* v___y_1304_, lean_object* v___y_1305_, lean_object* v___y_1306_, lean_object* v___y_1307_, lean_object* v___y_1308_, lean_object* v___y_1309_){
_start:
{
lean_object* v_ref_1311_; lean_object* v___x_1312_; 
v_ref_1311_ = lean_ctor_get(v___y_1308_, 5);
v___x_1312_ = l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg(v_ref_1311_, v_constName_1301_, v___y_1302_, v___y_1303_, v___y_1304_, v___y_1305_, v___y_1306_, v___y_1307_, v___y_1308_, v___y_1309_);
return v___x_1312_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2___redArg___boxed(lean_object* v_constName_1313_, lean_object* v___y_1314_, lean_object* v___y_1315_, lean_object* v___y_1316_, lean_object* v___y_1317_, lean_object* v___y_1318_, lean_object* v___y_1319_, lean_object* v___y_1320_, lean_object* v___y_1321_, lean_object* v___y_1322_){
_start:
{
lean_object* v_res_1323_; 
v_res_1323_ = l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2___redArg(v_constName_1313_, v___y_1314_, v___y_1315_, v___y_1316_, v___y_1317_, v___y_1318_, v___y_1319_, v___y_1320_, v___y_1321_);
lean_dec(v___y_1321_);
lean_dec_ref(v___y_1320_);
lean_dec(v___y_1319_);
lean_dec_ref(v___y_1318_);
lean_dec(v___y_1317_);
lean_dec_ref(v___y_1316_);
lean_dec(v___y_1315_);
lean_dec_ref(v___y_1314_);
return v_res_1323_;
}
}
LEAN_EXPORT lean_object* l_Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1(lean_object* v_constName_1324_, lean_object* v___y_1325_, lean_object* v___y_1326_, lean_object* v___y_1327_, lean_object* v___y_1328_, lean_object* v___y_1329_, lean_object* v___y_1330_, lean_object* v___y_1331_, lean_object* v___y_1332_){
_start:
{
lean_object* v___x_1334_; lean_object* v_env_1335_; uint8_t v___x_1336_; lean_object* v___x_1337_; 
v___x_1334_ = lean_st_ref_get(v___y_1332_);
v_env_1335_ = lean_ctor_get(v___x_1334_, 0);
lean_inc_ref(v_env_1335_);
lean_dec(v___x_1334_);
v___x_1336_ = 0;
lean_inc(v_constName_1324_);
v___x_1337_ = l_Lean_Environment_findConstVal_x3f(v_env_1335_, v_constName_1324_, v___x_1336_);
if (lean_obj_tag(v___x_1337_) == 0)
{
lean_object* v___x_1338_; 
v___x_1338_ = l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2___redArg(v_constName_1324_, v___y_1325_, v___y_1326_, v___y_1327_, v___y_1328_, v___y_1329_, v___y_1330_, v___y_1331_, v___y_1332_);
return v___x_1338_;
}
else
{
lean_object* v_val_1339_; lean_object* v___x_1341_; uint8_t v_isShared_1342_; uint8_t v_isSharedCheck_1346_; 
lean_dec(v_constName_1324_);
v_val_1339_ = lean_ctor_get(v___x_1337_, 0);
v_isSharedCheck_1346_ = !lean_is_exclusive(v___x_1337_);
if (v_isSharedCheck_1346_ == 0)
{
v___x_1341_ = v___x_1337_;
v_isShared_1342_ = v_isSharedCheck_1346_;
goto v_resetjp_1340_;
}
else
{
lean_inc(v_val_1339_);
lean_dec(v___x_1337_);
v___x_1341_ = lean_box(0);
v_isShared_1342_ = v_isSharedCheck_1346_;
goto v_resetjp_1340_;
}
v_resetjp_1340_:
{
lean_object* v___x_1344_; 
if (v_isShared_1342_ == 0)
{
lean_ctor_set_tag(v___x_1341_, 0);
v___x_1344_ = v___x_1341_;
goto v_reusejp_1343_;
}
else
{
lean_object* v_reuseFailAlloc_1345_; 
v_reuseFailAlloc_1345_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1345_, 0, v_val_1339_);
v___x_1344_ = v_reuseFailAlloc_1345_;
goto v_reusejp_1343_;
}
v_reusejp_1343_:
{
return v___x_1344_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1___boxed(lean_object* v_constName_1347_, lean_object* v___y_1348_, lean_object* v___y_1349_, lean_object* v___y_1350_, lean_object* v___y_1351_, lean_object* v___y_1352_, lean_object* v___y_1353_, lean_object* v___y_1354_, lean_object* v___y_1355_, lean_object* v___y_1356_){
_start:
{
lean_object* v_res_1357_; 
v_res_1357_ = l_Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1(v_constName_1347_, v___y_1348_, v___y_1349_, v___y_1350_, v___y_1351_, v___y_1352_, v___y_1353_, v___y_1354_, v___y_1355_);
lean_dec(v___y_1355_);
lean_dec_ref(v___y_1354_);
lean_dec(v___y_1353_);
lean_dec_ref(v___y_1352_);
lean_dec(v___y_1351_);
lean_dec_ref(v___y_1350_);
lean_dec(v___y_1349_);
lean_dec_ref(v___y_1348_);
return v_res_1357_;
}
}
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___redArg(lean_object* v_a_1358_, lean_object* v_x_1359_){
_start:
{
if (lean_obj_tag(v_x_1359_) == 0)
{
uint8_t v___x_1360_; 
v___x_1360_ = 0;
return v___x_1360_;
}
else
{
lean_object* v_key_1361_; lean_object* v_tail_1362_; uint8_t v___x_1363_; 
v_key_1361_ = lean_ctor_get(v_x_1359_, 0);
v_tail_1362_ = lean_ctor_get(v_x_1359_, 2);
v___x_1363_ = lean_name_eq(v_key_1361_, v_a_1358_);
if (v___x_1363_ == 0)
{
v_x_1359_ = v_tail_1362_;
goto _start;
}
else
{
return v___x_1363_;
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___redArg___boxed(lean_object* v_a_1365_, lean_object* v_x_1366_){
_start:
{
uint8_t v_res_1367_; lean_object* v_r_1368_; 
v_res_1367_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___redArg(v_a_1365_, v_x_1366_);
lean_dec(v_x_1366_);
lean_dec(v_a_1365_);
v_r_1368_ = lean_box(v_res_1367_);
return v_r_1368_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7_spec__15___redArg(lean_object* v_x_1369_, lean_object* v_x_1370_){
_start:
{
if (lean_obj_tag(v_x_1370_) == 0)
{
return v_x_1369_;
}
else
{
lean_object* v_key_1371_; lean_object* v_value_1372_; lean_object* v_tail_1373_; lean_object* v___x_1375_; uint8_t v_isShared_1376_; uint8_t v_isSharedCheck_1399_; 
v_key_1371_ = lean_ctor_get(v_x_1370_, 0);
v_value_1372_ = lean_ctor_get(v_x_1370_, 1);
v_tail_1373_ = lean_ctor_get(v_x_1370_, 2);
v_isSharedCheck_1399_ = !lean_is_exclusive(v_x_1370_);
if (v_isSharedCheck_1399_ == 0)
{
v___x_1375_ = v_x_1370_;
v_isShared_1376_ = v_isSharedCheck_1399_;
goto v_resetjp_1374_;
}
else
{
lean_inc(v_tail_1373_);
lean_inc(v_value_1372_);
lean_inc(v_key_1371_);
lean_dec(v_x_1370_);
v___x_1375_ = lean_box(0);
v_isShared_1376_ = v_isSharedCheck_1399_;
goto v_resetjp_1374_;
}
v_resetjp_1374_:
{
lean_object* v___x_1377_; uint64_t v___y_1379_; 
v___x_1377_ = lean_array_get_size(v_x_1369_);
if (lean_obj_tag(v_key_1371_) == 0)
{
uint64_t v___x_1397_; 
v___x_1397_ = lean_uint64_once(&l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0, &l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0_once, _init_l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0);
v___y_1379_ = v___x_1397_;
goto v___jp_1378_;
}
else
{
uint64_t v_hash_1398_; 
v_hash_1398_ = lean_ctor_get_uint64(v_key_1371_, sizeof(void*)*2);
v___y_1379_ = v_hash_1398_;
goto v___jp_1378_;
}
v___jp_1378_:
{
uint64_t v___x_1380_; uint64_t v___x_1381_; uint64_t v_fold_1382_; uint64_t v___x_1383_; uint64_t v___x_1384_; uint64_t v___x_1385_; size_t v___x_1386_; size_t v___x_1387_; size_t v___x_1388_; size_t v___x_1389_; size_t v___x_1390_; lean_object* v___x_1391_; lean_object* v___x_1393_; 
v___x_1380_ = 32ULL;
v___x_1381_ = lean_uint64_shift_right(v___y_1379_, v___x_1380_);
v_fold_1382_ = lean_uint64_xor(v___y_1379_, v___x_1381_);
v___x_1383_ = 16ULL;
v___x_1384_ = lean_uint64_shift_right(v_fold_1382_, v___x_1383_);
v___x_1385_ = lean_uint64_xor(v_fold_1382_, v___x_1384_);
v___x_1386_ = lean_uint64_to_usize(v___x_1385_);
v___x_1387_ = lean_usize_of_nat(v___x_1377_);
v___x_1388_ = ((size_t)1ULL);
v___x_1389_ = lean_usize_sub(v___x_1387_, v___x_1388_);
v___x_1390_ = lean_usize_land(v___x_1386_, v___x_1389_);
v___x_1391_ = lean_array_uget_borrowed(v_x_1369_, v___x_1390_);
lean_inc(v___x_1391_);
if (v_isShared_1376_ == 0)
{
lean_ctor_set(v___x_1375_, 2, v___x_1391_);
v___x_1393_ = v___x_1375_;
goto v_reusejp_1392_;
}
else
{
lean_object* v_reuseFailAlloc_1396_; 
v_reuseFailAlloc_1396_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v_reuseFailAlloc_1396_, 0, v_key_1371_);
lean_ctor_set(v_reuseFailAlloc_1396_, 1, v_value_1372_);
lean_ctor_set(v_reuseFailAlloc_1396_, 2, v___x_1391_);
v___x_1393_ = v_reuseFailAlloc_1396_;
goto v_reusejp_1392_;
}
v_reusejp_1392_:
{
lean_object* v___x_1394_; 
v___x_1394_ = lean_array_uset(v_x_1369_, v___x_1390_, v___x_1393_);
v_x_1369_ = v___x_1394_;
v_x_1370_ = v_tail_1373_;
goto _start;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7___redArg(lean_object* v_i_1400_, lean_object* v_source_1401_, lean_object* v_target_1402_){
_start:
{
lean_object* v___x_1403_; uint8_t v___x_1404_; 
v___x_1403_ = lean_array_get_size(v_source_1401_);
v___x_1404_ = lean_nat_dec_lt(v_i_1400_, v___x_1403_);
if (v___x_1404_ == 0)
{
lean_dec_ref(v_source_1401_);
lean_dec(v_i_1400_);
return v_target_1402_;
}
else
{
lean_object* v_es_1405_; lean_object* v___x_1406_; lean_object* v_source_1407_; lean_object* v_target_1408_; lean_object* v___x_1409_; lean_object* v___x_1410_; 
v_es_1405_ = lean_array_fget(v_source_1401_, v_i_1400_);
v___x_1406_ = lean_box(0);
v_source_1407_ = lean_array_fset(v_source_1401_, v_i_1400_, v___x_1406_);
v_target_1408_ = l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7_spec__15___redArg(v_target_1402_, v_es_1405_);
v___x_1409_ = lean_unsigned_to_nat(1u);
v___x_1410_ = lean_nat_add(v_i_1400_, v___x_1409_);
lean_dec(v_i_1400_);
v_i_1400_ = v___x_1410_;
v_source_1401_ = v_source_1407_;
v_target_1402_ = v_target_1408_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5___redArg(lean_object* v_data_1412_){
_start:
{
lean_object* v___x_1413_; lean_object* v___x_1414_; lean_object* v_nbuckets_1415_; lean_object* v___x_1416_; lean_object* v___x_1417_; lean_object* v___x_1418_; lean_object* v___x_1419_; 
v___x_1413_ = lean_array_get_size(v_data_1412_);
v___x_1414_ = lean_unsigned_to_nat(2u);
v_nbuckets_1415_ = lean_nat_mul(v___x_1413_, v___x_1414_);
v___x_1416_ = lean_unsigned_to_nat(0u);
v___x_1417_ = lean_box(0);
v___x_1418_ = lean_mk_array(v_nbuckets_1415_, v___x_1417_);
v___x_1419_ = l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7___redArg(v___x_1416_, v_data_1412_, v___x_1418_);
return v___x_1419_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__3___redArg(lean_object* v_m_1420_, lean_object* v_a_1421_, lean_object* v_b_1422_){
_start:
{
lean_object* v_size_1423_; lean_object* v_buckets_1424_; lean_object* v___x_1425_; uint64_t v___y_1427_; 
v_size_1423_ = lean_ctor_get(v_m_1420_, 0);
v_buckets_1424_ = lean_ctor_get(v_m_1420_, 1);
v___x_1425_ = lean_array_get_size(v_buckets_1424_);
if (lean_obj_tag(v_a_1421_) == 0)
{
uint64_t v___x_1464_; 
v___x_1464_ = lean_uint64_once(&l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0, &l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0_once, _init_l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0);
v___y_1427_ = v___x_1464_;
goto v___jp_1426_;
}
else
{
uint64_t v_hash_1465_; 
v_hash_1465_ = lean_ctor_get_uint64(v_a_1421_, sizeof(void*)*2);
v___y_1427_ = v_hash_1465_;
goto v___jp_1426_;
}
v___jp_1426_:
{
uint64_t v___x_1428_; uint64_t v___x_1429_; uint64_t v_fold_1430_; uint64_t v___x_1431_; uint64_t v___x_1432_; uint64_t v___x_1433_; size_t v___x_1434_; size_t v___x_1435_; size_t v___x_1436_; size_t v___x_1437_; size_t v___x_1438_; lean_object* v_bkt_1439_; uint8_t v___x_1440_; 
v___x_1428_ = 32ULL;
v___x_1429_ = lean_uint64_shift_right(v___y_1427_, v___x_1428_);
v_fold_1430_ = lean_uint64_xor(v___y_1427_, v___x_1429_);
v___x_1431_ = 16ULL;
v___x_1432_ = lean_uint64_shift_right(v_fold_1430_, v___x_1431_);
v___x_1433_ = lean_uint64_xor(v_fold_1430_, v___x_1432_);
v___x_1434_ = lean_uint64_to_usize(v___x_1433_);
v___x_1435_ = lean_usize_of_nat(v___x_1425_);
v___x_1436_ = ((size_t)1ULL);
v___x_1437_ = lean_usize_sub(v___x_1435_, v___x_1436_);
v___x_1438_ = lean_usize_land(v___x_1434_, v___x_1437_);
v_bkt_1439_ = lean_array_uget_borrowed(v_buckets_1424_, v___x_1438_);
v___x_1440_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___redArg(v_a_1421_, v_bkt_1439_);
if (v___x_1440_ == 0)
{
lean_object* v___x_1442_; uint8_t v_isShared_1443_; uint8_t v_isSharedCheck_1461_; 
lean_inc_ref(v_buckets_1424_);
lean_inc(v_size_1423_);
v_isSharedCheck_1461_ = !lean_is_exclusive(v_m_1420_);
if (v_isSharedCheck_1461_ == 0)
{
lean_object* v_unused_1462_; lean_object* v_unused_1463_; 
v_unused_1462_ = lean_ctor_get(v_m_1420_, 1);
lean_dec(v_unused_1462_);
v_unused_1463_ = lean_ctor_get(v_m_1420_, 0);
lean_dec(v_unused_1463_);
v___x_1442_ = v_m_1420_;
v_isShared_1443_ = v_isSharedCheck_1461_;
goto v_resetjp_1441_;
}
else
{
lean_dec(v_m_1420_);
v___x_1442_ = lean_box(0);
v_isShared_1443_ = v_isSharedCheck_1461_;
goto v_resetjp_1441_;
}
v_resetjp_1441_:
{
lean_object* v___x_1444_; lean_object* v_size_x27_1445_; lean_object* v___x_1446_; lean_object* v_buckets_x27_1447_; lean_object* v___x_1448_; lean_object* v___x_1449_; lean_object* v___x_1450_; lean_object* v___x_1451_; lean_object* v___x_1452_; uint8_t v___x_1453_; 
v___x_1444_ = lean_unsigned_to_nat(1u);
v_size_x27_1445_ = lean_nat_add(v_size_1423_, v___x_1444_);
lean_dec(v_size_1423_);
lean_inc(v_bkt_1439_);
v___x_1446_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v___x_1446_, 0, v_a_1421_);
lean_ctor_set(v___x_1446_, 1, v_b_1422_);
lean_ctor_set(v___x_1446_, 2, v_bkt_1439_);
v_buckets_x27_1447_ = lean_array_uset(v_buckets_1424_, v___x_1438_, v___x_1446_);
v___x_1448_ = lean_unsigned_to_nat(4u);
v___x_1449_ = lean_nat_mul(v_size_x27_1445_, v___x_1448_);
v___x_1450_ = lean_unsigned_to_nat(3u);
v___x_1451_ = lean_nat_div(v___x_1449_, v___x_1450_);
lean_dec(v___x_1449_);
v___x_1452_ = lean_array_get_size(v_buckets_x27_1447_);
v___x_1453_ = lean_nat_dec_le(v___x_1451_, v___x_1452_);
lean_dec(v___x_1451_);
if (v___x_1453_ == 0)
{
lean_object* v_val_1454_; lean_object* v___x_1456_; 
v_val_1454_ = l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5___redArg(v_buckets_x27_1447_);
if (v_isShared_1443_ == 0)
{
lean_ctor_set(v___x_1442_, 1, v_val_1454_);
lean_ctor_set(v___x_1442_, 0, v_size_x27_1445_);
v___x_1456_ = v___x_1442_;
goto v_reusejp_1455_;
}
else
{
lean_object* v_reuseFailAlloc_1457_; 
v_reuseFailAlloc_1457_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1457_, 0, v_size_x27_1445_);
lean_ctor_set(v_reuseFailAlloc_1457_, 1, v_val_1454_);
v___x_1456_ = v_reuseFailAlloc_1457_;
goto v_reusejp_1455_;
}
v_reusejp_1455_:
{
return v___x_1456_;
}
}
else
{
lean_object* v___x_1459_; 
if (v_isShared_1443_ == 0)
{
lean_ctor_set(v___x_1442_, 1, v_buckets_x27_1447_);
lean_ctor_set(v___x_1442_, 0, v_size_x27_1445_);
v___x_1459_ = v___x_1442_;
goto v_reusejp_1458_;
}
else
{
lean_object* v_reuseFailAlloc_1460_; 
v_reuseFailAlloc_1460_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1460_, 0, v_size_x27_1445_);
lean_ctor_set(v_reuseFailAlloc_1460_, 1, v_buckets_x27_1447_);
v___x_1459_ = v_reuseFailAlloc_1460_;
goto v_reusejp_1458_;
}
v_reusejp_1458_:
{
return v___x_1459_;
}
}
}
}
else
{
lean_dec(v_b_1422_);
lean_dec(v_a_1421_);
return v_m_1420_;
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__6___redArg(lean_object* v_a_1466_, lean_object* v_b_1467_, lean_object* v_x_1468_){
_start:
{
if (lean_obj_tag(v_x_1468_) == 0)
{
lean_dec(v_b_1467_);
lean_dec(v_a_1466_);
return v_x_1468_;
}
else
{
lean_object* v_key_1469_; lean_object* v_value_1470_; lean_object* v_tail_1471_; lean_object* v___x_1473_; uint8_t v_isShared_1474_; uint8_t v_isSharedCheck_1483_; 
v_key_1469_ = lean_ctor_get(v_x_1468_, 0);
v_value_1470_ = lean_ctor_get(v_x_1468_, 1);
v_tail_1471_ = lean_ctor_get(v_x_1468_, 2);
v_isSharedCheck_1483_ = !lean_is_exclusive(v_x_1468_);
if (v_isSharedCheck_1483_ == 0)
{
v___x_1473_ = v_x_1468_;
v_isShared_1474_ = v_isSharedCheck_1483_;
goto v_resetjp_1472_;
}
else
{
lean_inc(v_tail_1471_);
lean_inc(v_value_1470_);
lean_inc(v_key_1469_);
lean_dec(v_x_1468_);
v___x_1473_ = lean_box(0);
v_isShared_1474_ = v_isSharedCheck_1483_;
goto v_resetjp_1472_;
}
v_resetjp_1472_:
{
uint8_t v___x_1475_; 
v___x_1475_ = lean_name_eq(v_key_1469_, v_a_1466_);
if (v___x_1475_ == 0)
{
lean_object* v___x_1476_; lean_object* v___x_1478_; 
v___x_1476_ = l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__6___redArg(v_a_1466_, v_b_1467_, v_tail_1471_);
if (v_isShared_1474_ == 0)
{
lean_ctor_set(v___x_1473_, 2, v___x_1476_);
v___x_1478_ = v___x_1473_;
goto v_reusejp_1477_;
}
else
{
lean_object* v_reuseFailAlloc_1479_; 
v_reuseFailAlloc_1479_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v_reuseFailAlloc_1479_, 0, v_key_1469_);
lean_ctor_set(v_reuseFailAlloc_1479_, 1, v_value_1470_);
lean_ctor_set(v_reuseFailAlloc_1479_, 2, v___x_1476_);
v___x_1478_ = v_reuseFailAlloc_1479_;
goto v_reusejp_1477_;
}
v_reusejp_1477_:
{
return v___x_1478_;
}
}
else
{
lean_object* v___x_1481_; 
lean_dec(v_value_1470_);
lean_dec(v_key_1469_);
if (v_isShared_1474_ == 0)
{
lean_ctor_set(v___x_1473_, 1, v_b_1467_);
lean_ctor_set(v___x_1473_, 0, v_a_1466_);
v___x_1481_ = v___x_1473_;
goto v_reusejp_1480_;
}
else
{
lean_object* v_reuseFailAlloc_1482_; 
v_reuseFailAlloc_1482_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v_reuseFailAlloc_1482_, 0, v_a_1466_);
lean_ctor_set(v_reuseFailAlloc_1482_, 1, v_b_1467_);
lean_ctor_set(v_reuseFailAlloc_1482_, 2, v_tail_1471_);
v___x_1481_ = v_reuseFailAlloc_1482_;
goto v_reusejp_1480_;
}
v_reusejp_1480_:
{
return v___x_1481_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2___redArg(lean_object* v_m_1484_, lean_object* v_a_1485_, lean_object* v_b_1486_){
_start:
{
lean_object* v_size_1487_; lean_object* v_buckets_1488_; lean_object* v___x_1490_; uint8_t v_isShared_1491_; uint8_t v_isSharedCheck_1534_; 
v_size_1487_ = lean_ctor_get(v_m_1484_, 0);
v_buckets_1488_ = lean_ctor_get(v_m_1484_, 1);
v_isSharedCheck_1534_ = !lean_is_exclusive(v_m_1484_);
if (v_isSharedCheck_1534_ == 0)
{
v___x_1490_ = v_m_1484_;
v_isShared_1491_ = v_isSharedCheck_1534_;
goto v_resetjp_1489_;
}
else
{
lean_inc(v_buckets_1488_);
lean_inc(v_size_1487_);
lean_dec(v_m_1484_);
v___x_1490_ = lean_box(0);
v_isShared_1491_ = v_isSharedCheck_1534_;
goto v_resetjp_1489_;
}
v_resetjp_1489_:
{
lean_object* v___x_1492_; uint64_t v___y_1494_; 
v___x_1492_ = lean_array_get_size(v_buckets_1488_);
if (lean_obj_tag(v_a_1485_) == 0)
{
uint64_t v___x_1532_; 
v___x_1532_ = lean_uint64_once(&l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0, &l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0_once, _init_l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0);
v___y_1494_ = v___x_1532_;
goto v___jp_1493_;
}
else
{
uint64_t v_hash_1533_; 
v_hash_1533_ = lean_ctor_get_uint64(v_a_1485_, sizeof(void*)*2);
v___y_1494_ = v_hash_1533_;
goto v___jp_1493_;
}
v___jp_1493_:
{
uint64_t v___x_1495_; uint64_t v___x_1496_; uint64_t v_fold_1497_; uint64_t v___x_1498_; uint64_t v___x_1499_; uint64_t v___x_1500_; size_t v___x_1501_; size_t v___x_1502_; size_t v___x_1503_; size_t v___x_1504_; size_t v___x_1505_; lean_object* v_bkt_1506_; uint8_t v___x_1507_; 
v___x_1495_ = 32ULL;
v___x_1496_ = lean_uint64_shift_right(v___y_1494_, v___x_1495_);
v_fold_1497_ = lean_uint64_xor(v___y_1494_, v___x_1496_);
v___x_1498_ = 16ULL;
v___x_1499_ = lean_uint64_shift_right(v_fold_1497_, v___x_1498_);
v___x_1500_ = lean_uint64_xor(v_fold_1497_, v___x_1499_);
v___x_1501_ = lean_uint64_to_usize(v___x_1500_);
v___x_1502_ = lean_usize_of_nat(v___x_1492_);
v___x_1503_ = ((size_t)1ULL);
v___x_1504_ = lean_usize_sub(v___x_1502_, v___x_1503_);
v___x_1505_ = lean_usize_land(v___x_1501_, v___x_1504_);
v_bkt_1506_ = lean_array_uget_borrowed(v_buckets_1488_, v___x_1505_);
v___x_1507_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___redArg(v_a_1485_, v_bkt_1506_);
if (v___x_1507_ == 0)
{
lean_object* v___x_1508_; lean_object* v_size_x27_1509_; lean_object* v___x_1510_; lean_object* v_buckets_x27_1511_; lean_object* v___x_1512_; lean_object* v___x_1513_; lean_object* v___x_1514_; lean_object* v___x_1515_; lean_object* v___x_1516_; uint8_t v___x_1517_; 
v___x_1508_ = lean_unsigned_to_nat(1u);
v_size_x27_1509_ = lean_nat_add(v_size_1487_, v___x_1508_);
lean_dec(v_size_1487_);
lean_inc(v_bkt_1506_);
v___x_1510_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v___x_1510_, 0, v_a_1485_);
lean_ctor_set(v___x_1510_, 1, v_b_1486_);
lean_ctor_set(v___x_1510_, 2, v_bkt_1506_);
v_buckets_x27_1511_ = lean_array_uset(v_buckets_1488_, v___x_1505_, v___x_1510_);
v___x_1512_ = lean_unsigned_to_nat(4u);
v___x_1513_ = lean_nat_mul(v_size_x27_1509_, v___x_1512_);
v___x_1514_ = lean_unsigned_to_nat(3u);
v___x_1515_ = lean_nat_div(v___x_1513_, v___x_1514_);
lean_dec(v___x_1513_);
v___x_1516_ = lean_array_get_size(v_buckets_x27_1511_);
v___x_1517_ = lean_nat_dec_le(v___x_1515_, v___x_1516_);
lean_dec(v___x_1515_);
if (v___x_1517_ == 0)
{
lean_object* v_val_1518_; lean_object* v___x_1520_; 
v_val_1518_ = l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5___redArg(v_buckets_x27_1511_);
if (v_isShared_1491_ == 0)
{
lean_ctor_set(v___x_1490_, 1, v_val_1518_);
lean_ctor_set(v___x_1490_, 0, v_size_x27_1509_);
v___x_1520_ = v___x_1490_;
goto v_reusejp_1519_;
}
else
{
lean_object* v_reuseFailAlloc_1521_; 
v_reuseFailAlloc_1521_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1521_, 0, v_size_x27_1509_);
lean_ctor_set(v_reuseFailAlloc_1521_, 1, v_val_1518_);
v___x_1520_ = v_reuseFailAlloc_1521_;
goto v_reusejp_1519_;
}
v_reusejp_1519_:
{
return v___x_1520_;
}
}
else
{
lean_object* v___x_1523_; 
if (v_isShared_1491_ == 0)
{
lean_ctor_set(v___x_1490_, 1, v_buckets_x27_1511_);
lean_ctor_set(v___x_1490_, 0, v_size_x27_1509_);
v___x_1523_ = v___x_1490_;
goto v_reusejp_1522_;
}
else
{
lean_object* v_reuseFailAlloc_1524_; 
v_reuseFailAlloc_1524_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1524_, 0, v_size_x27_1509_);
lean_ctor_set(v_reuseFailAlloc_1524_, 1, v_buckets_x27_1511_);
v___x_1523_ = v_reuseFailAlloc_1524_;
goto v_reusejp_1522_;
}
v_reusejp_1522_:
{
return v___x_1523_;
}
}
}
else
{
lean_object* v___x_1525_; lean_object* v_buckets_x27_1526_; lean_object* v___x_1527_; lean_object* v___x_1528_; lean_object* v___x_1530_; 
lean_inc(v_bkt_1506_);
v___x_1525_ = lean_box(0);
v_buckets_x27_1526_ = lean_array_uset(v_buckets_1488_, v___x_1505_, v___x_1525_);
v___x_1527_ = l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__6___redArg(v_a_1485_, v_b_1486_, v_bkt_1506_);
v___x_1528_ = lean_array_uset(v_buckets_x27_1526_, v___x_1505_, v___x_1527_);
if (v_isShared_1491_ == 0)
{
lean_ctor_set(v___x_1490_, 1, v___x_1528_);
v___x_1530_ = v___x_1490_;
goto v_reusejp_1529_;
}
else
{
lean_object* v_reuseFailAlloc_1531_; 
v_reuseFailAlloc_1531_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1531_, 0, v_size_1487_);
lean_ctor_set(v_reuseFailAlloc_1531_, 1, v___x_1528_);
v___x_1530_ = v_reuseFailAlloc_1531_;
goto v_reusejp_1529_;
}
v_reusejp_1529_:
{
return v___x_1530_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4___redArg(lean_object* v_upperBound_1535_, lean_object* v___x_1536_, lean_object* v_a_1537_, lean_object* v___x_1538_, lean_object* v_a_1539_, lean_object* v_b_1540_, lean_object* v___y_1541_, lean_object* v___y_1542_, lean_object* v___y_1543_, lean_object* v___y_1544_, lean_object* v___y_1545_, lean_object* v___y_1546_, lean_object* v___y_1547_, lean_object* v___y_1548_){
_start:
{
lean_object* v_a_1551_; uint8_t v___x_1555_; 
v___x_1555_ = lean_nat_dec_lt(v_a_1539_, v_upperBound_1535_);
if (v___x_1555_ == 0)
{
lean_object* v___x_1556_; 
lean_dec(v_a_1539_);
lean_dec(v___x_1538_);
v___x_1556_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1556_, 0, v_b_1540_);
return v___x_1556_;
}
else
{
lean_object* v_fst_1557_; lean_object* v_snd_1558_; lean_object* v___x_1560_; uint8_t v_isShared_1561_; uint8_t v_isSharedCheck_1596_; 
v_fst_1557_ = lean_ctor_get(v_b_1540_, 0);
v_snd_1558_ = lean_ctor_get(v_b_1540_, 1);
v_isSharedCheck_1596_ = !lean_is_exclusive(v_b_1540_);
if (v_isSharedCheck_1596_ == 0)
{
v___x_1560_ = v_b_1540_;
v_isShared_1561_ = v_isSharedCheck_1596_;
goto v_resetjp_1559_;
}
else
{
lean_inc(v_snd_1558_);
lean_inc(v_fst_1557_);
lean_dec(v_b_1540_);
v___x_1560_ = lean_box(0);
v_isShared_1561_ = v_isSharedCheck_1596_;
goto v_resetjp_1559_;
}
v_resetjp_1559_:
{
lean_object* v___x_1562_; 
v___x_1562_ = l_Lean_StructureInfo_getProjFn_x3f(v___x_1536_, v_a_1539_);
if (lean_obj_tag(v___x_1562_) == 1)
{
lean_object* v_val_1563_; lean_object* v___x_1564_; 
v_val_1563_ = lean_ctor_get(v___x_1562_, 0);
lean_inc_n(v_val_1563_, 2);
lean_dec_ref_known(v___x_1562_, 1);
v___x_1564_ = l_Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1(v_val_1563_, v___y_1541_, v___y_1542_, v___y_1543_, v___y_1544_, v___y_1545_, v___y_1546_, v___y_1547_, v___y_1548_);
if (lean_obj_tag(v___x_1564_) == 0)
{
lean_object* v_a_1565_; lean_object* v_type_1566_; lean_object* v___x_1568_; uint8_t v_isShared_1569_; uint8_t v_isSharedCheck_1582_; 
v_a_1565_ = lean_ctor_get(v___x_1564_, 0);
lean_inc(v_a_1565_);
lean_dec_ref_known(v___x_1564_, 1);
v_type_1566_ = lean_ctor_get(v_a_1565_, 2);
v_isSharedCheck_1582_ = !lean_is_exclusive(v_a_1565_);
if (v_isSharedCheck_1582_ == 0)
{
lean_object* v_unused_1583_; lean_object* v_unused_1584_; 
v_unused_1583_ = lean_ctor_get(v_a_1565_, 1);
lean_dec(v_unused_1583_);
v_unused_1584_ = lean_ctor_get(v_a_1565_, 0);
lean_dec(v_unused_1584_);
v___x_1568_ = v_a_1565_;
v_isShared_1569_ = v_isSharedCheck_1582_;
goto v_resetjp_1567_;
}
else
{
lean_inc(v_type_1566_);
lean_dec(v_a_1565_);
v___x_1568_ = lean_box(0);
v_isShared_1569_ = v_isSharedCheck_1582_;
goto v_resetjp_1567_;
}
v_resetjp_1567_:
{
lean_object* v_numParams_1570_; lean_object* v___x_1571_; lean_object* v___x_1572_; lean_object* v___x_1573_; lean_object* v___x_1574_; lean_object* v___x_1576_; 
v_numParams_1570_ = lean_ctor_get(v_a_1537_, 1);
v___x_1571_ = l_Lean_Expr_getForallArity(v_type_1566_);
v___x_1572_ = lean_box(0);
lean_inc(v_val_1563_);
v___x_1573_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__3___redArg(v_fst_1557_, v_val_1563_, v___x_1572_);
v___x_1574_ = lean_nat_add(v_a_1539_, v_numParams_1570_);
lean_inc(v___x_1538_);
if (v_isShared_1569_ == 0)
{
lean_ctor_set(v___x_1568_, 2, v___x_1538_);
lean_ctor_set(v___x_1568_, 1, v___x_1574_);
lean_ctor_set(v___x_1568_, 0, v___x_1571_);
v___x_1576_ = v___x_1568_;
goto v_reusejp_1575_;
}
else
{
lean_object* v_reuseFailAlloc_1581_; 
v_reuseFailAlloc_1581_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v_reuseFailAlloc_1581_, 0, v___x_1571_);
lean_ctor_set(v_reuseFailAlloc_1581_, 1, v___x_1574_);
lean_ctor_set(v_reuseFailAlloc_1581_, 2, v___x_1538_);
v___x_1576_ = v_reuseFailAlloc_1581_;
goto v_reusejp_1575_;
}
v_reusejp_1575_:
{
lean_object* v___x_1577_; lean_object* v___x_1579_; 
v___x_1577_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2___redArg(v_snd_1558_, v_val_1563_, v___x_1576_);
if (v_isShared_1561_ == 0)
{
lean_ctor_set(v___x_1560_, 1, v___x_1577_);
lean_ctor_set(v___x_1560_, 0, v___x_1573_);
v___x_1579_ = v___x_1560_;
goto v_reusejp_1578_;
}
else
{
lean_object* v_reuseFailAlloc_1580_; 
v_reuseFailAlloc_1580_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1580_, 0, v___x_1573_);
lean_ctor_set(v_reuseFailAlloc_1580_, 1, v___x_1577_);
v___x_1579_ = v_reuseFailAlloc_1580_;
goto v_reusejp_1578_;
}
v_reusejp_1578_:
{
v_a_1551_ = v___x_1579_;
goto v___jp_1550_;
}
}
}
}
else
{
lean_object* v_a_1585_; lean_object* v___x_1587_; uint8_t v_isShared_1588_; uint8_t v_isSharedCheck_1592_; 
lean_dec(v_val_1563_);
lean_del_object(v___x_1560_);
lean_dec(v_snd_1558_);
lean_dec(v_fst_1557_);
lean_dec(v_a_1539_);
lean_dec(v___x_1538_);
v_a_1585_ = lean_ctor_get(v___x_1564_, 0);
v_isSharedCheck_1592_ = !lean_is_exclusive(v___x_1564_);
if (v_isSharedCheck_1592_ == 0)
{
v___x_1587_ = v___x_1564_;
v_isShared_1588_ = v_isSharedCheck_1592_;
goto v_resetjp_1586_;
}
else
{
lean_inc(v_a_1585_);
lean_dec(v___x_1564_);
v___x_1587_ = lean_box(0);
v_isShared_1588_ = v_isSharedCheck_1592_;
goto v_resetjp_1586_;
}
v_resetjp_1586_:
{
lean_object* v___x_1590_; 
if (v_isShared_1588_ == 0)
{
v___x_1590_ = v___x_1587_;
goto v_reusejp_1589_;
}
else
{
lean_object* v_reuseFailAlloc_1591_; 
v_reuseFailAlloc_1591_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1591_, 0, v_a_1585_);
v___x_1590_ = v_reuseFailAlloc_1591_;
goto v_reusejp_1589_;
}
v_reusejp_1589_:
{
return v___x_1590_;
}
}
}
}
else
{
lean_object* v___x_1594_; 
lean_dec(v___x_1562_);
if (v_isShared_1561_ == 0)
{
v___x_1594_ = v___x_1560_;
goto v_reusejp_1593_;
}
else
{
lean_object* v_reuseFailAlloc_1595_; 
v_reuseFailAlloc_1595_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1595_, 0, v_fst_1557_);
lean_ctor_set(v_reuseFailAlloc_1595_, 1, v_snd_1558_);
v___x_1594_ = v_reuseFailAlloc_1595_;
goto v_reusejp_1593_;
}
v_reusejp_1593_:
{
v_a_1551_ = v___x_1594_;
goto v___jp_1550_;
}
}
}
}
v___jp_1550_:
{
lean_object* v___x_1552_; lean_object* v___x_1553_; 
v___x_1552_ = lean_unsigned_to_nat(1u);
v___x_1553_ = lean_nat_add(v_a_1539_, v___x_1552_);
lean_dec(v_a_1539_);
v_a_1539_ = v___x_1553_;
v_b_1540_ = v_a_1551_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4___redArg___boxed(lean_object* v_upperBound_1597_, lean_object* v___x_1598_, lean_object* v_a_1599_, lean_object* v___x_1600_, lean_object* v_a_1601_, lean_object* v_b_1602_, lean_object* v___y_1603_, lean_object* v___y_1604_, lean_object* v___y_1605_, lean_object* v___y_1606_, lean_object* v___y_1607_, lean_object* v___y_1608_, lean_object* v___y_1609_, lean_object* v___y_1610_, lean_object* v___y_1611_){
_start:
{
lean_object* v_res_1612_; 
v_res_1612_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4___redArg(v_upperBound_1597_, v___x_1598_, v_a_1599_, v___x_1600_, v_a_1601_, v_b_1602_, v___y_1603_, v___y_1604_, v___y_1605_, v___y_1606_, v___y_1607_, v___y_1608_, v___y_1609_, v___y_1610_);
lean_dec(v___y_1610_);
lean_dec_ref(v___y_1609_);
lean_dec(v___y_1608_);
lean_dec_ref(v___y_1607_);
lean_dec(v___y_1606_);
lean_dec_ref(v___y_1605_);
lean_dec(v___y_1604_);
lean_dec_ref(v___y_1603_);
lean_dec_ref(v_a_1599_);
lean_dec_ref(v___x_1598_);
lean_dec(v_upperBound_1597_);
return v_res_1612_;
}
}
static double _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__0(void){
_start:
{
lean_object* v___x_1613_; double v___x_1614_; 
v___x_1613_ = lean_unsigned_to_nat(0u);
v___x_1614_ = lean_float_of_nat(v___x_1613_);
return v___x_1614_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg(lean_object* v_cls_1618_, lean_object* v_msg_1619_, lean_object* v___y_1620_, lean_object* v___y_1621_, lean_object* v___y_1622_, lean_object* v___y_1623_){
_start:
{
lean_object* v_ref_1625_; lean_object* v___x_1626_; lean_object* v_a_1627_; lean_object* v___x_1629_; uint8_t v_isShared_1630_; uint8_t v_isSharedCheck_1671_; 
v_ref_1625_ = lean_ctor_get(v___y_1622_, 5);
v___x_1626_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5_spec__10(v_msg_1619_, v___y_1620_, v___y_1621_, v___y_1622_, v___y_1623_);
v_a_1627_ = lean_ctor_get(v___x_1626_, 0);
v_isSharedCheck_1671_ = !lean_is_exclusive(v___x_1626_);
if (v_isSharedCheck_1671_ == 0)
{
v___x_1629_ = v___x_1626_;
v_isShared_1630_ = v_isSharedCheck_1671_;
goto v_resetjp_1628_;
}
else
{
lean_inc(v_a_1627_);
lean_dec(v___x_1626_);
v___x_1629_ = lean_box(0);
v_isShared_1630_ = v_isSharedCheck_1671_;
goto v_resetjp_1628_;
}
v_resetjp_1628_:
{
lean_object* v___x_1631_; lean_object* v_traceState_1632_; lean_object* v_env_1633_; lean_object* v_nextMacroScope_1634_; lean_object* v_ngen_1635_; lean_object* v_auxDeclNGen_1636_; lean_object* v_cache_1637_; lean_object* v_messages_1638_; lean_object* v_infoState_1639_; lean_object* v_snapshotTasks_1640_; lean_object* v___x_1642_; uint8_t v_isShared_1643_; uint8_t v_isSharedCheck_1670_; 
v___x_1631_ = lean_st_ref_take(v___y_1623_);
v_traceState_1632_ = lean_ctor_get(v___x_1631_, 4);
v_env_1633_ = lean_ctor_get(v___x_1631_, 0);
v_nextMacroScope_1634_ = lean_ctor_get(v___x_1631_, 1);
v_ngen_1635_ = lean_ctor_get(v___x_1631_, 2);
v_auxDeclNGen_1636_ = lean_ctor_get(v___x_1631_, 3);
v_cache_1637_ = lean_ctor_get(v___x_1631_, 5);
v_messages_1638_ = lean_ctor_get(v___x_1631_, 6);
v_infoState_1639_ = lean_ctor_get(v___x_1631_, 7);
v_snapshotTasks_1640_ = lean_ctor_get(v___x_1631_, 8);
v_isSharedCheck_1670_ = !lean_is_exclusive(v___x_1631_);
if (v_isSharedCheck_1670_ == 0)
{
v___x_1642_ = v___x_1631_;
v_isShared_1643_ = v_isSharedCheck_1670_;
goto v_resetjp_1641_;
}
else
{
lean_inc(v_snapshotTasks_1640_);
lean_inc(v_infoState_1639_);
lean_inc(v_messages_1638_);
lean_inc(v_cache_1637_);
lean_inc(v_traceState_1632_);
lean_inc(v_auxDeclNGen_1636_);
lean_inc(v_ngen_1635_);
lean_inc(v_nextMacroScope_1634_);
lean_inc(v_env_1633_);
lean_dec(v___x_1631_);
v___x_1642_ = lean_box(0);
v_isShared_1643_ = v_isSharedCheck_1670_;
goto v_resetjp_1641_;
}
v_resetjp_1641_:
{
uint64_t v_tid_1644_; lean_object* v_traces_1645_; lean_object* v___x_1647_; uint8_t v_isShared_1648_; uint8_t v_isSharedCheck_1669_; 
v_tid_1644_ = lean_ctor_get_uint64(v_traceState_1632_, sizeof(void*)*1);
v_traces_1645_ = lean_ctor_get(v_traceState_1632_, 0);
v_isSharedCheck_1669_ = !lean_is_exclusive(v_traceState_1632_);
if (v_isSharedCheck_1669_ == 0)
{
v___x_1647_ = v_traceState_1632_;
v_isShared_1648_ = v_isSharedCheck_1669_;
goto v_resetjp_1646_;
}
else
{
lean_inc(v_traces_1645_);
lean_dec(v_traceState_1632_);
v___x_1647_ = lean_box(0);
v_isShared_1648_ = v_isSharedCheck_1669_;
goto v_resetjp_1646_;
}
v_resetjp_1646_:
{
lean_object* v___x_1649_; double v___x_1650_; uint8_t v___x_1651_; lean_object* v___x_1652_; lean_object* v___x_1653_; lean_object* v___x_1654_; lean_object* v___x_1655_; lean_object* v___x_1656_; lean_object* v___x_1657_; lean_object* v___x_1659_; 
v___x_1649_ = lean_box(0);
v___x_1650_ = lean_float_once(&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__0, &l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__0_once, _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__0);
v___x_1651_ = 0;
v___x_1652_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__1));
v___x_1653_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v___x_1653_, 0, v_cls_1618_);
lean_ctor_set(v___x_1653_, 1, v___x_1649_);
lean_ctor_set(v___x_1653_, 2, v___x_1652_);
lean_ctor_set_float(v___x_1653_, sizeof(void*)*3, v___x_1650_);
lean_ctor_set_float(v___x_1653_, sizeof(void*)*3 + 8, v___x_1650_);
lean_ctor_set_uint8(v___x_1653_, sizeof(void*)*3 + 16, v___x_1651_);
v___x_1654_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___closed__2));
v___x_1655_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v___x_1655_, 0, v___x_1653_);
lean_ctor_set(v___x_1655_, 1, v_a_1627_);
lean_ctor_set(v___x_1655_, 2, v___x_1654_);
lean_inc(v_ref_1625_);
v___x_1656_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1656_, 0, v_ref_1625_);
lean_ctor_set(v___x_1656_, 1, v___x_1655_);
v___x_1657_ = l_Lean_PersistentArray_push___redArg(v_traces_1645_, v___x_1656_);
if (v_isShared_1648_ == 0)
{
lean_ctor_set(v___x_1647_, 0, v___x_1657_);
v___x_1659_ = v___x_1647_;
goto v_reusejp_1658_;
}
else
{
lean_object* v_reuseFailAlloc_1668_; 
v_reuseFailAlloc_1668_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_1668_, 0, v___x_1657_);
lean_ctor_set_uint64(v_reuseFailAlloc_1668_, sizeof(void*)*1, v_tid_1644_);
v___x_1659_ = v_reuseFailAlloc_1668_;
goto v_reusejp_1658_;
}
v_reusejp_1658_:
{
lean_object* v___x_1661_; 
if (v_isShared_1643_ == 0)
{
lean_ctor_set(v___x_1642_, 4, v___x_1659_);
v___x_1661_ = v___x_1642_;
goto v_reusejp_1660_;
}
else
{
lean_object* v_reuseFailAlloc_1667_; 
v_reuseFailAlloc_1667_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_1667_, 0, v_env_1633_);
lean_ctor_set(v_reuseFailAlloc_1667_, 1, v_nextMacroScope_1634_);
lean_ctor_set(v_reuseFailAlloc_1667_, 2, v_ngen_1635_);
lean_ctor_set(v_reuseFailAlloc_1667_, 3, v_auxDeclNGen_1636_);
lean_ctor_set(v_reuseFailAlloc_1667_, 4, v___x_1659_);
lean_ctor_set(v_reuseFailAlloc_1667_, 5, v_cache_1637_);
lean_ctor_set(v_reuseFailAlloc_1667_, 6, v_messages_1638_);
lean_ctor_set(v_reuseFailAlloc_1667_, 7, v_infoState_1639_);
lean_ctor_set(v_reuseFailAlloc_1667_, 8, v_snapshotTasks_1640_);
v___x_1661_ = v_reuseFailAlloc_1667_;
goto v_reusejp_1660_;
}
v_reusejp_1660_:
{
lean_object* v___x_1662_; lean_object* v___x_1663_; lean_object* v___x_1665_; 
v___x_1662_ = lean_st_ref_set(v___y_1623_, v___x_1661_);
v___x_1663_ = lean_box(0);
if (v_isShared_1630_ == 0)
{
lean_ctor_set(v___x_1629_, 0, v___x_1663_);
v___x_1665_ = v___x_1629_;
goto v_reusejp_1664_;
}
else
{
lean_object* v_reuseFailAlloc_1666_; 
v_reuseFailAlloc_1666_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1666_, 0, v___x_1663_);
v___x_1665_ = v_reuseFailAlloc_1666_;
goto v_reusejp_1664_;
}
v_reusejp_1664_:
{
return v___x_1665_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg___boxed(lean_object* v_cls_1672_, lean_object* v_msg_1673_, lean_object* v___y_1674_, lean_object* v___y_1675_, lean_object* v___y_1676_, lean_object* v___y_1677_, lean_object* v___y_1678_){
_start:
{
lean_object* v_res_1679_; 
v_res_1679_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg(v_cls_1672_, v_msg_1673_, v___y_1674_, v___y_1675_, v___y_1676_, v___y_1677_);
lean_dec(v___y_1677_);
lean_dec_ref(v___y_1676_);
lean_dec(v___y_1675_);
lean_dec_ref(v___y_1674_);
return v_res_1679_;
}
}
static lean_object* _init_l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6(void){
_start:
{
lean_object* v___x_1690_; lean_object* v___x_1691_; lean_object* v___x_1692_; 
v___x_1690_ = ((lean_object*)(l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3));
v___x_1691_ = ((lean_object*)(l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__5));
v___x_1692_ = l_Lean_Name_append(v___x_1691_, v___x_1690_);
return v___x_1692_;
}
}
static lean_object* _init_l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__8(void){
_start:
{
lean_object* v___x_1694_; lean_object* v___x_1695_; 
v___x_1694_ = ((lean_object*)(l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__7));
v___x_1695_ = l_Lean_stringToMessageData(v___x_1694_);
return v___x_1695_;
}
}
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6(lean_object* v___x_1696_, lean_object* v_a_1697_, lean_object* v_a_1698_, lean_object* v___y_1699_, lean_object* v___y_1700_, lean_object* v___y_1701_, lean_object* v___y_1702_, lean_object* v___y_1703_, lean_object* v___y_1704_, lean_object* v___y_1705_, lean_object* v___y_1706_){
_start:
{
if (lean_obj_tag(v_a_1697_) == 0)
{
lean_object* v___x_1708_; lean_object* v___x_1709_; 
lean_dec_ref(v___x_1696_);
v___x_1708_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_1708_, 0, v_a_1698_);
v___x_1709_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1709_, 0, v___x_1708_);
return v___x_1709_;
}
else
{
lean_object* v_key_1710_; lean_object* v_tail_1711_; lean_object* v___x_1712_; 
v_key_1710_ = lean_ctor_get(v_a_1697_, 0);
lean_inc_n(v_key_1710_, 2);
v_tail_1711_ = lean_ctor_get(v_a_1697_, 2);
lean_inc(v_tail_1711_);
lean_dec_ref_known(v_a_1697_, 3);
v___x_1712_ = l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0(v_key_1710_, v___y_1699_, v___y_1700_, v___y_1701_, v___y_1702_, v___y_1703_, v___y_1704_, v___y_1705_, v___y_1706_);
if (lean_obj_tag(v___x_1712_) == 0)
{
lean_object* v_a_1713_; lean_object* v_ctors_1714_; lean_object* v___x_1715_; lean_object* v___x_1716_; lean_object* v___x_1717_; 
v_a_1713_ = lean_ctor_get(v___x_1712_, 0);
lean_inc(v_a_1713_);
lean_dec_ref_known(v___x_1712_, 1);
v_ctors_1714_ = lean_ctor_get(v_a_1713_, 4);
v___x_1715_ = lean_box(0);
v___x_1716_ = l_List_head_x21___redArg(v___x_1715_, v_ctors_1714_);
lean_inc(v___x_1716_);
v___x_1717_ = l_Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1(v___x_1716_, v___y_1699_, v___y_1700_, v___y_1701_, v___y_1702_, v___y_1703_, v___y_1704_, v___y_1705_, v___y_1706_);
if (lean_obj_tag(v___x_1717_) == 0)
{
lean_object* v_snd_1718_; lean_object* v_snd_1719_; lean_object* v_a_1720_; lean_object* v_fst_1721_; lean_object* v___x_1723_; uint8_t v_isShared_1724_; uint8_t v_isSharedCheck_1832_; 
v_snd_1718_ = lean_ctor_get(v_a_1698_, 1);
lean_inc(v_snd_1718_);
v_snd_1719_ = lean_ctor_get(v_snd_1718_, 1);
lean_inc(v_snd_1719_);
v_a_1720_ = lean_ctor_get(v___x_1717_, 0);
lean_inc(v_a_1720_);
lean_dec_ref_known(v___x_1717_, 1);
v_fst_1721_ = lean_ctor_get(v_a_1698_, 0);
v_isSharedCheck_1832_ = !lean_is_exclusive(v_a_1698_);
if (v_isSharedCheck_1832_ == 0)
{
lean_object* v_unused_1833_; 
v_unused_1833_ = lean_ctor_get(v_a_1698_, 1);
lean_dec(v_unused_1833_);
v___x_1723_ = v_a_1698_;
v_isShared_1724_ = v_isSharedCheck_1832_;
goto v_resetjp_1722_;
}
else
{
lean_inc(v_fst_1721_);
lean_dec(v_a_1698_);
v___x_1723_ = lean_box(0);
v_isShared_1724_ = v_isSharedCheck_1832_;
goto v_resetjp_1722_;
}
v_resetjp_1722_:
{
lean_object* v_fst_1725_; lean_object* v___x_1727_; uint8_t v_isShared_1728_; uint8_t v_isSharedCheck_1830_; 
v_fst_1725_ = lean_ctor_get(v_snd_1718_, 0);
v_isSharedCheck_1830_ = !lean_is_exclusive(v_snd_1718_);
if (v_isSharedCheck_1830_ == 0)
{
lean_object* v_unused_1831_; 
v_unused_1831_ = lean_ctor_get(v_snd_1718_, 1);
lean_dec(v_unused_1831_);
v___x_1727_ = v_snd_1718_;
v_isShared_1728_ = v_isSharedCheck_1830_;
goto v_resetjp_1726_;
}
else
{
lean_inc(v_fst_1725_);
lean_dec(v_snd_1718_);
v___x_1727_ = lean_box(0);
v_isShared_1728_ = v_isSharedCheck_1830_;
goto v_resetjp_1726_;
}
v_resetjp_1726_:
{
lean_object* v_fst_1729_; lean_object* v_snd_1730_; lean_object* v___x_1732_; uint8_t v_isShared_1733_; uint8_t v_isSharedCheck_1829_; 
v_fst_1729_ = lean_ctor_get(v_snd_1719_, 0);
v_snd_1730_ = lean_ctor_get(v_snd_1719_, 1);
v_isSharedCheck_1829_ = !lean_is_exclusive(v_snd_1719_);
if (v_isSharedCheck_1829_ == 0)
{
v___x_1732_ = v_snd_1719_;
v_isShared_1733_ = v_isSharedCheck_1829_;
goto v_resetjp_1731_;
}
else
{
lean_inc(v_snd_1730_);
lean_inc(v_fst_1729_);
lean_dec(v_snd_1719_);
v___x_1732_ = lean_box(0);
v_isShared_1733_ = v_isSharedCheck_1829_;
goto v_resetjp_1731_;
}
v_resetjp_1731_:
{
lean_object* v_type_1734_; lean_object* v___x_1735_; 
v_type_1734_ = lean_ctor_get(v_a_1720_, 2);
lean_inc_ref(v_type_1734_);
lean_dec(v_a_1720_);
lean_inc(v_a_1713_);
v___x_1735_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_findExtIff_x3f(v_a_1713_, v___y_1703_, v___y_1704_, v___y_1705_, v___y_1706_);
if (lean_obj_tag(v___x_1735_) == 0)
{
lean_object* v_a_1736_; lean_object* v___x_1737_; lean_object* v___x_1738_; lean_object* v_extTheorems_1740_; lean_object* v___y_1741_; lean_object* v___y_1742_; lean_object* v___y_1743_; lean_object* v___y_1744_; lean_object* v___y_1745_; lean_object* v___y_1746_; lean_object* v___y_1747_; lean_object* v___y_1748_; 
v_a_1736_ = lean_ctor_get(v___x_1735_, 0);
lean_inc(v_a_1736_);
lean_dec_ref_known(v___x_1735_, 1);
v___x_1737_ = l_Lean_Expr_getForallArity(v_type_1734_);
lean_inc(v___x_1716_);
v___x_1738_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2___redArg(v_snd_1730_, v___x_1716_, v___x_1737_);
if (lean_obj_tag(v_a_1736_) == 1)
{
lean_object* v_val_1782_; lean_object* v___y_1784_; lean_object* v___y_1785_; lean_object* v___y_1786_; lean_object* v___y_1787_; lean_object* v___y_1788_; lean_object* v___y_1789_; lean_object* v___y_1790_; lean_object* v___y_1791_; lean_object* v_options_1803_; uint8_t v_hasTrace_1804_; 
v_val_1782_ = lean_ctor_get(v_a_1736_, 0);
lean_inc(v_val_1782_);
lean_dec_ref_known(v_a_1736_, 1);
v_options_1803_ = lean_ctor_get(v___y_1705_, 2);
v_hasTrace_1804_ = lean_ctor_get_uint8(v_options_1803_, sizeof(void*)*1);
if (v_hasTrace_1804_ == 0)
{
v___y_1784_ = v___y_1699_;
v___y_1785_ = v___y_1700_;
v___y_1786_ = v___y_1701_;
v___y_1787_ = v___y_1702_;
v___y_1788_ = v___y_1703_;
v___y_1789_ = v___y_1704_;
v___y_1790_ = v___y_1705_;
v___y_1791_ = v___y_1706_;
goto v___jp_1783_;
}
else
{
lean_object* v_inheritedTraceOptions_1805_; lean_object* v___x_1806_; lean_object* v___x_1807_; uint8_t v___x_1808_; 
v_inheritedTraceOptions_1805_ = lean_ctor_get(v___y_1705_, 13);
v___x_1806_ = ((lean_object*)(l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3));
v___x_1807_ = lean_obj_once(&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6, &l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6_once, _init_l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6);
v___x_1808_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_1805_, v_options_1803_, v___x_1807_);
if (v___x_1808_ == 0)
{
v___y_1784_ = v___y_1699_;
v___y_1785_ = v___y_1700_;
v___y_1786_ = v___y_1701_;
v___y_1787_ = v___y_1702_;
v___y_1788_ = v___y_1703_;
v___y_1789_ = v___y_1704_;
v___y_1790_ = v___y_1705_;
v___y_1791_ = v___y_1706_;
goto v___jp_1783_;
}
else
{
lean_object* v___x_1809_; lean_object* v___x_1810_; lean_object* v___x_1811_; lean_object* v___x_1812_; 
v___x_1809_ = lean_obj_once(&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__8, &l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__8_once, _init_l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__8);
lean_inc(v_val_1782_);
v___x_1810_ = l_Lean_MessageData_ofName(v_val_1782_);
v___x_1811_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1811_, 0, v___x_1809_);
lean_ctor_set(v___x_1811_, 1, v___x_1810_);
v___x_1812_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg(v___x_1806_, v___x_1811_, v___y_1703_, v___y_1704_, v___y_1705_, v___y_1706_);
if (lean_obj_tag(v___x_1812_) == 0)
{
lean_dec_ref_known(v___x_1812_, 1);
v___y_1784_ = v___y_1699_;
v___y_1785_ = v___y_1700_;
v___y_1786_ = v___y_1701_;
v___y_1787_ = v___y_1702_;
v___y_1788_ = v___y_1703_;
v___y_1789_ = v___y_1704_;
v___y_1790_ = v___y_1705_;
v___y_1791_ = v___y_1706_;
goto v___jp_1783_;
}
else
{
lean_object* v_a_1813_; lean_object* v___x_1815_; uint8_t v_isShared_1816_; uint8_t v_isSharedCheck_1820_; 
lean_dec(v_val_1782_);
lean_dec_ref(v___x_1738_);
lean_del_object(v___x_1732_);
lean_dec(v_fst_1729_);
lean_del_object(v___x_1727_);
lean_dec(v_fst_1725_);
lean_del_object(v___x_1723_);
lean_dec(v_fst_1721_);
lean_dec(v___x_1716_);
lean_dec(v_a_1713_);
lean_dec(v_tail_1711_);
lean_dec(v_key_1710_);
lean_dec_ref(v___x_1696_);
v_a_1813_ = lean_ctor_get(v___x_1812_, 0);
v_isSharedCheck_1820_ = !lean_is_exclusive(v___x_1812_);
if (v_isSharedCheck_1820_ == 0)
{
v___x_1815_ = v___x_1812_;
v_isShared_1816_ = v_isSharedCheck_1820_;
goto v_resetjp_1814_;
}
else
{
lean_inc(v_a_1813_);
lean_dec(v___x_1812_);
v___x_1815_ = lean_box(0);
v_isShared_1816_ = v_isSharedCheck_1820_;
goto v_resetjp_1814_;
}
v_resetjp_1814_:
{
lean_object* v___x_1818_; 
if (v_isShared_1816_ == 0)
{
v___x_1818_ = v___x_1815_;
goto v_reusejp_1817_;
}
else
{
lean_object* v_reuseFailAlloc_1819_; 
v_reuseFailAlloc_1819_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1819_, 0, v_a_1813_);
v___x_1818_ = v_reuseFailAlloc_1819_;
goto v_reusejp_1817_;
}
v_reusejp_1817_:
{
return v___x_1818_;
}
}
}
}
}
v___jp_1783_:
{
lean_object* v___x_1792_; 
v___x_1792_ = l_Lean_Meta_Sym_Simp_mkTheoremFromDecl(v_val_1782_, v___y_1788_, v___y_1789_, v___y_1790_, v___y_1791_);
if (lean_obj_tag(v___x_1792_) == 0)
{
lean_object* v_a_1793_; lean_object* v___x_1794_; 
v_a_1793_ = lean_ctor_get(v___x_1792_, 0);
lean_inc(v_a_1793_);
lean_dec_ref_known(v___x_1792_, 1);
v___x_1794_ = l_Lean_Meta_Sym_Simp_Theorems_insert(v_fst_1721_, v_a_1793_);
v_extTheorems_1740_ = v___x_1794_;
v___y_1741_ = v___y_1784_;
v___y_1742_ = v___y_1785_;
v___y_1743_ = v___y_1786_;
v___y_1744_ = v___y_1787_;
v___y_1745_ = v___y_1788_;
v___y_1746_ = v___y_1789_;
v___y_1747_ = v___y_1790_;
v___y_1748_ = v___y_1791_;
goto v___jp_1739_;
}
else
{
lean_object* v_a_1795_; lean_object* v___x_1797_; uint8_t v_isShared_1798_; uint8_t v_isSharedCheck_1802_; 
lean_dec_ref(v___x_1738_);
lean_del_object(v___x_1732_);
lean_dec(v_fst_1729_);
lean_del_object(v___x_1727_);
lean_dec(v_fst_1725_);
lean_del_object(v___x_1723_);
lean_dec(v_fst_1721_);
lean_dec(v___x_1716_);
lean_dec(v_a_1713_);
lean_dec(v_tail_1711_);
lean_dec(v_key_1710_);
lean_dec_ref(v___x_1696_);
v_a_1795_ = lean_ctor_get(v___x_1792_, 0);
v_isSharedCheck_1802_ = !lean_is_exclusive(v___x_1792_);
if (v_isSharedCheck_1802_ == 0)
{
v___x_1797_ = v___x_1792_;
v_isShared_1798_ = v_isSharedCheck_1802_;
goto v_resetjp_1796_;
}
else
{
lean_inc(v_a_1795_);
lean_dec(v___x_1792_);
v___x_1797_ = lean_box(0);
v_isShared_1798_ = v_isSharedCheck_1802_;
goto v_resetjp_1796_;
}
v_resetjp_1796_:
{
lean_object* v___x_1800_; 
if (v_isShared_1798_ == 0)
{
v___x_1800_ = v___x_1797_;
goto v_reusejp_1799_;
}
else
{
lean_object* v_reuseFailAlloc_1801_; 
v_reuseFailAlloc_1801_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1801_, 0, v_a_1795_);
v___x_1800_ = v_reuseFailAlloc_1801_;
goto v_reusejp_1799_;
}
v_reusejp_1799_:
{
return v___x_1800_;
}
}
}
}
}
else
{
lean_dec(v_a_1736_);
v_extTheorems_1740_ = v_fst_1721_;
v___y_1741_ = v___y_1699_;
v___y_1742_ = v___y_1700_;
v___y_1743_ = v___y_1701_;
v___y_1744_ = v___y_1702_;
v___y_1745_ = v___y_1703_;
v___y_1746_ = v___y_1704_;
v___y_1747_ = v___y_1705_;
v___y_1748_ = v___y_1706_;
goto v___jp_1739_;
}
v___jp_1739_:
{
lean_object* v___x_1749_; lean_object* v_fieldNames_1750_; lean_object* v___x_1751_; lean_object* v___x_1752_; lean_object* v___x_1754_; 
lean_inc_ref(v___x_1696_);
v___x_1749_ = l_Lean_getStructureInfo(v___x_1696_, v_key_1710_);
v_fieldNames_1750_ = lean_ctor_get(v___x_1749_, 1);
lean_inc_ref(v_fieldNames_1750_);
v___x_1751_ = lean_array_get_size(v_fieldNames_1750_);
lean_dec_ref(v_fieldNames_1750_);
v___x_1752_ = lean_unsigned_to_nat(0u);
if (v_isShared_1733_ == 0)
{
lean_ctor_set(v___x_1732_, 1, v_fst_1729_);
lean_ctor_set(v___x_1732_, 0, v_fst_1725_);
v___x_1754_ = v___x_1732_;
goto v_reusejp_1753_;
}
else
{
lean_object* v_reuseFailAlloc_1781_; 
v_reuseFailAlloc_1781_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1781_, 0, v_fst_1725_);
lean_ctor_set(v_reuseFailAlloc_1781_, 1, v_fst_1729_);
v___x_1754_ = v_reuseFailAlloc_1781_;
goto v_reusejp_1753_;
}
v_reusejp_1753_:
{
lean_object* v___x_1755_; 
v___x_1755_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4___redArg(v___x_1751_, v___x_1749_, v_a_1713_, v___x_1716_, v___x_1752_, v___x_1754_, v___y_1741_, v___y_1742_, v___y_1743_, v___y_1744_, v___y_1745_, v___y_1746_, v___y_1747_, v___y_1748_);
lean_dec(v_a_1713_);
lean_dec_ref(v___x_1749_);
if (lean_obj_tag(v___x_1755_) == 0)
{
lean_object* v_a_1756_; lean_object* v_fst_1757_; lean_object* v_snd_1758_; lean_object* v___x_1760_; uint8_t v_isShared_1761_; uint8_t v_isSharedCheck_1772_; 
v_a_1756_ = lean_ctor_get(v___x_1755_, 0);
lean_inc(v_a_1756_);
lean_dec_ref_known(v___x_1755_, 1);
v_fst_1757_ = lean_ctor_get(v_a_1756_, 0);
v_snd_1758_ = lean_ctor_get(v_a_1756_, 1);
v_isSharedCheck_1772_ = !lean_is_exclusive(v_a_1756_);
if (v_isSharedCheck_1772_ == 0)
{
v___x_1760_ = v_a_1756_;
v_isShared_1761_ = v_isSharedCheck_1772_;
goto v_resetjp_1759_;
}
else
{
lean_inc(v_snd_1758_);
lean_inc(v_fst_1757_);
lean_dec(v_a_1756_);
v___x_1760_ = lean_box(0);
v_isShared_1761_ = v_isSharedCheck_1772_;
goto v_resetjp_1759_;
}
v_resetjp_1759_:
{
lean_object* v___x_1763_; 
if (v_isShared_1761_ == 0)
{
lean_ctor_set(v___x_1760_, 1, v___x_1738_);
lean_ctor_set(v___x_1760_, 0, v_snd_1758_);
v___x_1763_ = v___x_1760_;
goto v_reusejp_1762_;
}
else
{
lean_object* v_reuseFailAlloc_1771_; 
v_reuseFailAlloc_1771_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1771_, 0, v_snd_1758_);
lean_ctor_set(v_reuseFailAlloc_1771_, 1, v___x_1738_);
v___x_1763_ = v_reuseFailAlloc_1771_;
goto v_reusejp_1762_;
}
v_reusejp_1762_:
{
lean_object* v___x_1765_; 
if (v_isShared_1728_ == 0)
{
lean_ctor_set(v___x_1727_, 1, v___x_1763_);
lean_ctor_set(v___x_1727_, 0, v_fst_1757_);
v___x_1765_ = v___x_1727_;
goto v_reusejp_1764_;
}
else
{
lean_object* v_reuseFailAlloc_1770_; 
v_reuseFailAlloc_1770_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1770_, 0, v_fst_1757_);
lean_ctor_set(v_reuseFailAlloc_1770_, 1, v___x_1763_);
v___x_1765_ = v_reuseFailAlloc_1770_;
goto v_reusejp_1764_;
}
v_reusejp_1764_:
{
lean_object* v___x_1767_; 
if (v_isShared_1724_ == 0)
{
lean_ctor_set(v___x_1723_, 1, v___x_1765_);
lean_ctor_set(v___x_1723_, 0, v_extTheorems_1740_);
v___x_1767_ = v___x_1723_;
goto v_reusejp_1766_;
}
else
{
lean_object* v_reuseFailAlloc_1769_; 
v_reuseFailAlloc_1769_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1769_, 0, v_extTheorems_1740_);
lean_ctor_set(v_reuseFailAlloc_1769_, 1, v___x_1765_);
v___x_1767_ = v_reuseFailAlloc_1769_;
goto v_reusejp_1766_;
}
v_reusejp_1766_:
{
v_a_1697_ = v_tail_1711_;
v_a_1698_ = v___x_1767_;
goto _start;
}
}
}
}
}
else
{
lean_object* v_a_1773_; lean_object* v___x_1775_; uint8_t v_isShared_1776_; uint8_t v_isSharedCheck_1780_; 
lean_dec_ref(v_extTheorems_1740_);
lean_dec_ref(v___x_1738_);
lean_del_object(v___x_1727_);
lean_del_object(v___x_1723_);
lean_dec(v_tail_1711_);
lean_dec_ref(v___x_1696_);
v_a_1773_ = lean_ctor_get(v___x_1755_, 0);
v_isSharedCheck_1780_ = !lean_is_exclusive(v___x_1755_);
if (v_isSharedCheck_1780_ == 0)
{
v___x_1775_ = v___x_1755_;
v_isShared_1776_ = v_isSharedCheck_1780_;
goto v_resetjp_1774_;
}
else
{
lean_inc(v_a_1773_);
lean_dec(v___x_1755_);
v___x_1775_ = lean_box(0);
v_isShared_1776_ = v_isSharedCheck_1780_;
goto v_resetjp_1774_;
}
v_resetjp_1774_:
{
lean_object* v___x_1778_; 
if (v_isShared_1776_ == 0)
{
v___x_1778_ = v___x_1775_;
goto v_reusejp_1777_;
}
else
{
lean_object* v_reuseFailAlloc_1779_; 
v_reuseFailAlloc_1779_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1779_, 0, v_a_1773_);
v___x_1778_ = v_reuseFailAlloc_1779_;
goto v_reusejp_1777_;
}
v_reusejp_1777_:
{
return v___x_1778_;
}
}
}
}
}
}
else
{
lean_object* v_a_1821_; lean_object* v___x_1823_; uint8_t v_isShared_1824_; uint8_t v_isSharedCheck_1828_; 
lean_dec_ref(v_type_1734_);
lean_del_object(v___x_1732_);
lean_dec(v_snd_1730_);
lean_dec(v_fst_1729_);
lean_del_object(v___x_1727_);
lean_dec(v_fst_1725_);
lean_del_object(v___x_1723_);
lean_dec(v_fst_1721_);
lean_dec(v___x_1716_);
lean_dec(v_a_1713_);
lean_dec(v_tail_1711_);
lean_dec(v_key_1710_);
lean_dec_ref(v___x_1696_);
v_a_1821_ = lean_ctor_get(v___x_1735_, 0);
v_isSharedCheck_1828_ = !lean_is_exclusive(v___x_1735_);
if (v_isSharedCheck_1828_ == 0)
{
v___x_1823_ = v___x_1735_;
v_isShared_1824_ = v_isSharedCheck_1828_;
goto v_resetjp_1822_;
}
else
{
lean_inc(v_a_1821_);
lean_dec(v___x_1735_);
v___x_1823_ = lean_box(0);
v_isShared_1824_ = v_isSharedCheck_1828_;
goto v_resetjp_1822_;
}
v_resetjp_1822_:
{
lean_object* v___x_1826_; 
if (v_isShared_1824_ == 0)
{
v___x_1826_ = v___x_1823_;
goto v_reusejp_1825_;
}
else
{
lean_object* v_reuseFailAlloc_1827_; 
v_reuseFailAlloc_1827_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1827_, 0, v_a_1821_);
v___x_1826_ = v_reuseFailAlloc_1827_;
goto v_reusejp_1825_;
}
v_reusejp_1825_:
{
return v___x_1826_;
}
}
}
}
}
}
}
else
{
lean_object* v_a_1834_; lean_object* v___x_1836_; uint8_t v_isShared_1837_; uint8_t v_isSharedCheck_1841_; 
lean_dec(v___x_1716_);
lean_dec(v_a_1713_);
lean_dec(v_tail_1711_);
lean_dec(v_key_1710_);
lean_dec_ref(v_a_1698_);
lean_dec_ref(v___x_1696_);
v_a_1834_ = lean_ctor_get(v___x_1717_, 0);
v_isSharedCheck_1841_ = !lean_is_exclusive(v___x_1717_);
if (v_isSharedCheck_1841_ == 0)
{
v___x_1836_ = v___x_1717_;
v_isShared_1837_ = v_isSharedCheck_1841_;
goto v_resetjp_1835_;
}
else
{
lean_inc(v_a_1834_);
lean_dec(v___x_1717_);
v___x_1836_ = lean_box(0);
v_isShared_1837_ = v_isSharedCheck_1841_;
goto v_resetjp_1835_;
}
v_resetjp_1835_:
{
lean_object* v___x_1839_; 
if (v_isShared_1837_ == 0)
{
v___x_1839_ = v___x_1836_;
goto v_reusejp_1838_;
}
else
{
lean_object* v_reuseFailAlloc_1840_; 
v_reuseFailAlloc_1840_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1840_, 0, v_a_1834_);
v___x_1839_ = v_reuseFailAlloc_1840_;
goto v_reusejp_1838_;
}
v_reusejp_1838_:
{
return v___x_1839_;
}
}
}
}
else
{
lean_object* v_a_1842_; lean_object* v___x_1844_; uint8_t v_isShared_1845_; uint8_t v_isSharedCheck_1849_; 
lean_dec(v_tail_1711_);
lean_dec(v_key_1710_);
lean_dec_ref(v_a_1698_);
lean_dec_ref(v___x_1696_);
v_a_1842_ = lean_ctor_get(v___x_1712_, 0);
v_isSharedCheck_1849_ = !lean_is_exclusive(v___x_1712_);
if (v_isSharedCheck_1849_ == 0)
{
v___x_1844_ = v___x_1712_;
v_isShared_1845_ = v_isSharedCheck_1849_;
goto v_resetjp_1843_;
}
else
{
lean_inc(v_a_1842_);
lean_dec(v___x_1712_);
v___x_1844_ = lean_box(0);
v_isShared_1845_ = v_isSharedCheck_1849_;
goto v_resetjp_1843_;
}
v_resetjp_1843_:
{
lean_object* v___x_1847_; 
if (v_isShared_1845_ == 0)
{
v___x_1847_ = v___x_1844_;
goto v_reusejp_1846_;
}
else
{
lean_object* v_reuseFailAlloc_1848_; 
v_reuseFailAlloc_1848_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1848_, 0, v_a_1842_);
v___x_1847_ = v_reuseFailAlloc_1848_;
goto v_reusejp_1846_;
}
v_reusejp_1846_:
{
return v___x_1847_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___boxed(lean_object* v___x_1850_, lean_object* v_a_1851_, lean_object* v_a_1852_, lean_object* v___y_1853_, lean_object* v___y_1854_, lean_object* v___y_1855_, lean_object* v___y_1856_, lean_object* v___y_1857_, lean_object* v___y_1858_, lean_object* v___y_1859_, lean_object* v___y_1860_, lean_object* v___y_1861_){
_start:
{
lean_object* v_res_1862_; 
v_res_1862_ = l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6(v___x_1850_, v_a_1851_, v_a_1852_, v___y_1853_, v___y_1854_, v___y_1855_, v___y_1856_, v___y_1857_, v___y_1858_, v___y_1859_, v___y_1860_);
lean_dec(v___y_1860_);
lean_dec_ref(v___y_1859_);
lean_dec(v___y_1858_);
lean_dec_ref(v___y_1857_);
lean_dec(v___y_1856_);
lean_dec_ref(v___y_1855_);
lean_dec(v___y_1854_);
lean_dec_ref(v___y_1853_);
return v_res_1862_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__7(lean_object* v___x_1863_, lean_object* v_as_1864_, size_t v_sz_1865_, size_t v_i_1866_, lean_object* v_b_1867_, lean_object* v___y_1868_, lean_object* v___y_1869_, lean_object* v___y_1870_, lean_object* v___y_1871_, lean_object* v___y_1872_, lean_object* v___y_1873_, lean_object* v___y_1874_, lean_object* v___y_1875_){
_start:
{
uint8_t v___x_1877_; 
v___x_1877_ = lean_usize_dec_lt(v_i_1866_, v_sz_1865_);
if (v___x_1877_ == 0)
{
lean_object* v___x_1878_; 
lean_dec_ref(v___x_1863_);
v___x_1878_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1878_, 0, v_b_1867_);
return v___x_1878_;
}
else
{
lean_object* v_a_1879_; lean_object* v___x_1880_; 
v_a_1879_ = lean_array_uget_borrowed(v_as_1864_, v_i_1866_);
lean_inc(v_a_1879_);
lean_inc_ref(v___x_1863_);
v___x_1880_ = l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6(v___x_1863_, v_a_1879_, v_b_1867_, v___y_1868_, v___y_1869_, v___y_1870_, v___y_1871_, v___y_1872_, v___y_1873_, v___y_1874_, v___y_1875_);
if (lean_obj_tag(v___x_1880_) == 0)
{
lean_object* v_a_1881_; lean_object* v___x_1883_; uint8_t v_isShared_1884_; uint8_t v_isSharedCheck_1893_; 
v_a_1881_ = lean_ctor_get(v___x_1880_, 0);
v_isSharedCheck_1893_ = !lean_is_exclusive(v___x_1880_);
if (v_isSharedCheck_1893_ == 0)
{
v___x_1883_ = v___x_1880_;
v_isShared_1884_ = v_isSharedCheck_1893_;
goto v_resetjp_1882_;
}
else
{
lean_inc(v_a_1881_);
lean_dec(v___x_1880_);
v___x_1883_ = lean_box(0);
v_isShared_1884_ = v_isSharedCheck_1893_;
goto v_resetjp_1882_;
}
v_resetjp_1882_:
{
if (lean_obj_tag(v_a_1881_) == 0)
{
lean_object* v_a_1885_; lean_object* v___x_1887_; 
lean_dec_ref(v___x_1863_);
v_a_1885_ = lean_ctor_get(v_a_1881_, 0);
lean_inc(v_a_1885_);
lean_dec_ref_known(v_a_1881_, 1);
if (v_isShared_1884_ == 0)
{
lean_ctor_set(v___x_1883_, 0, v_a_1885_);
v___x_1887_ = v___x_1883_;
goto v_reusejp_1886_;
}
else
{
lean_object* v_reuseFailAlloc_1888_; 
v_reuseFailAlloc_1888_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1888_, 0, v_a_1885_);
v___x_1887_ = v_reuseFailAlloc_1888_;
goto v_reusejp_1886_;
}
v_reusejp_1886_:
{
return v___x_1887_;
}
}
else
{
lean_object* v_a_1889_; size_t v___x_1890_; size_t v___x_1891_; 
lean_del_object(v___x_1883_);
v_a_1889_ = lean_ctor_get(v_a_1881_, 0);
lean_inc(v_a_1889_);
lean_dec_ref_known(v_a_1881_, 1);
v___x_1890_ = ((size_t)1ULL);
v___x_1891_ = lean_usize_add(v_i_1866_, v___x_1890_);
v_i_1866_ = v___x_1891_;
v_b_1867_ = v_a_1889_;
goto _start;
}
}
}
else
{
lean_object* v_a_1894_; lean_object* v___x_1896_; uint8_t v_isShared_1897_; uint8_t v_isSharedCheck_1901_; 
lean_dec_ref(v___x_1863_);
v_a_1894_ = lean_ctor_get(v___x_1880_, 0);
v_isSharedCheck_1901_ = !lean_is_exclusive(v___x_1880_);
if (v_isSharedCheck_1901_ == 0)
{
v___x_1896_ = v___x_1880_;
v_isShared_1897_ = v_isSharedCheck_1901_;
goto v_resetjp_1895_;
}
else
{
lean_inc(v_a_1894_);
lean_dec(v___x_1880_);
v___x_1896_ = lean_box(0);
v_isShared_1897_ = v_isSharedCheck_1901_;
goto v_resetjp_1895_;
}
v_resetjp_1895_:
{
lean_object* v___x_1899_; 
if (v_isShared_1897_ == 0)
{
v___x_1899_ = v___x_1896_;
goto v_reusejp_1898_;
}
else
{
lean_object* v_reuseFailAlloc_1900_; 
v_reuseFailAlloc_1900_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1900_, 0, v_a_1894_);
v___x_1899_ = v_reuseFailAlloc_1900_;
goto v_reusejp_1898_;
}
v_reusejp_1898_:
{
return v___x_1899_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__7___boxed(lean_object* v___x_1902_, lean_object* v_as_1903_, lean_object* v_sz_1904_, lean_object* v_i_1905_, lean_object* v_b_1906_, lean_object* v___y_1907_, lean_object* v___y_1908_, lean_object* v___y_1909_, lean_object* v___y_1910_, lean_object* v___y_1911_, lean_object* v___y_1912_, lean_object* v___y_1913_, lean_object* v___y_1914_, lean_object* v___y_1915_){
_start:
{
size_t v_sz_boxed_1916_; size_t v_i_boxed_1917_; lean_object* v_res_1918_; 
v_sz_boxed_1916_ = lean_unbox_usize(v_sz_1904_);
lean_dec(v_sz_1904_);
v_i_boxed_1917_ = lean_unbox_usize(v_i_1905_);
lean_dec(v_i_1905_);
v_res_1918_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__7(v___x_1902_, v_as_1903_, v_sz_boxed_1916_, v_i_boxed_1917_, v_b_1906_, v___y_1907_, v___y_1908_, v___y_1909_, v___y_1910_, v___y_1911_, v___y_1912_, v___y_1913_, v___y_1914_);
lean_dec(v___y_1914_);
lean_dec_ref(v___y_1913_);
lean_dec(v___y_1912_);
lean_dec_ref(v___y_1911_);
lean_dec(v___y_1910_);
lean_dec_ref(v___y_1909_);
lean_dec(v___y_1908_);
lean_dec_ref(v___y_1907_);
lean_dec_ref(v_as_1903_);
return v_res_1918_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__0(void){
_start:
{
lean_object* v___x_1919_; lean_object* v___x_1920_; lean_object* v___x_1921_; 
v___x_1919_ = lean_box(0);
v___x_1920_ = lean_unsigned_to_nat(16u);
v___x_1921_ = lean_mk_array(v___x_1920_, v___x_1919_);
return v___x_1921_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__1(void){
_start:
{
lean_object* v___x_1922_; lean_object* v___x_1923_; lean_object* v_projFns_1924_; 
v___x_1922_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__0, &l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__0_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__0);
v___x_1923_ = lean_unsigned_to_nat(0u);
v_projFns_1924_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_projFns_1924_, 0, v___x_1923_);
lean_ctor_set(v_projFns_1924_, 1, v___x_1922_);
return v_projFns_1924_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__2(void){
_start:
{
lean_object* v___x_1925_; 
v___x_1925_ = l_Lean_PersistentHashMap_mkEmptyEntriesArray(lean_box(0), lean_box(0));
return v___x_1925_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__3(void){
_start:
{
lean_object* v___x_1926_; lean_object* v_extTheorems_1927_; 
v___x_1926_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__2, &l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__2);
v_extTheorems_1927_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_extTheorems_1927_, 0, v___x_1926_);
return v_extTheorems_1927_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__4(void){
_start:
{
lean_object* v_projFns_1928_; lean_object* v___x_1929_; 
v_projFns_1928_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__1);
v___x_1929_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1929_, 0, v_projFns_1928_);
lean_ctor_set(v___x_1929_, 1, v_projFns_1928_);
return v___x_1929_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__5(void){
_start:
{
lean_object* v___x_1930_; lean_object* v_projFns_1931_; lean_object* v___x_1932_; 
v___x_1930_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__4, &l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__4_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__4);
v_projFns_1931_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__1);
v___x_1932_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1932_, 0, v_projFns_1931_);
lean_ctor_set(v___x_1932_, 1, v___x_1930_);
return v___x_1932_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__6(void){
_start:
{
lean_object* v___x_1933_; lean_object* v_extTheorems_1934_; lean_object* v___x_1935_; 
v___x_1933_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__5, &l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__5_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__5);
v_extTheorems_1934_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__3, &l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__3);
v___x_1935_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1935_, 0, v_extTheorems_1934_);
lean_ctor_set(v___x_1935_, 1, v___x_1933_);
return v___x_1935_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas(lean_object* v_methods_1936_, lean_object* v_a_1937_, lean_object* v_a_1938_, lean_object* v_a_1939_, lean_object* v_a_1940_, lean_object* v_a_1941_, lean_object* v_a_1942_, lean_object* v_a_1943_, lean_object* v_a_1944_){
_start:
{
lean_object* v___x_1946_; lean_object* v___x_1947_; lean_object* v_typeAnalysis_1948_; lean_object* v_interestingStructures_1949_; lean_object* v_env_1950_; lean_object* v_buckets_1951_; lean_object* v___x_1952_; size_t v_sz_1953_; size_t v___x_1954_; lean_object* v___x_1955_; 
v___x_1946_ = lean_st_ref_get(v_a_1938_);
v___x_1947_ = lean_st_ref_get(v_a_1944_);
v_typeAnalysis_1948_ = lean_ctor_get(v___x_1946_, 2);
lean_inc_ref(v_typeAnalysis_1948_);
lean_dec(v___x_1946_);
v_interestingStructures_1949_ = lean_ctor_get(v_typeAnalysis_1948_, 0);
lean_inc_ref(v_interestingStructures_1949_);
lean_dec_ref(v_typeAnalysis_1948_);
v_env_1950_ = lean_ctor_get(v___x_1947_, 0);
lean_inc_ref(v_env_1950_);
lean_dec(v___x_1947_);
v_buckets_1951_ = lean_ctor_get(v_interestingStructures_1949_, 1);
lean_inc_ref(v_buckets_1951_);
lean_dec_ref(v_interestingStructures_1949_);
v___x_1952_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__6, &l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___closed__6);
v_sz_1953_ = lean_array_size(v_buckets_1951_);
v___x_1954_ = ((size_t)0ULL);
v___x_1955_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__7(v_env_1950_, v_buckets_1951_, v_sz_1953_, v___x_1954_, v___x_1952_, v_a_1937_, v_a_1938_, v_a_1939_, v_a_1940_, v_a_1941_, v_a_1942_, v_a_1943_, v_a_1944_);
lean_dec_ref(v_buckets_1951_);
if (lean_obj_tag(v___x_1955_) == 0)
{
lean_object* v_a_1956_; lean_object* v___x_1958_; uint8_t v_isShared_1959_; uint8_t v_isSharedCheck_1983_; 
v_a_1956_ = lean_ctor_get(v___x_1955_, 0);
v_isSharedCheck_1983_ = !lean_is_exclusive(v___x_1955_);
if (v_isSharedCheck_1983_ == 0)
{
v___x_1958_ = v___x_1955_;
v_isShared_1959_ = v_isSharedCheck_1983_;
goto v_resetjp_1957_;
}
else
{
lean_inc(v_a_1956_);
lean_dec(v___x_1955_);
v___x_1958_ = lean_box(0);
v_isShared_1959_ = v_isSharedCheck_1983_;
goto v_resetjp_1957_;
}
v_resetjp_1957_:
{
lean_object* v_snd_1960_; lean_object* v_snd_1961_; lean_object* v_fst_1962_; lean_object* v_fst_1963_; lean_object* v_fst_1964_; lean_object* v_snd_1965_; lean_object* v_pre_1966_; lean_object* v_post_1967_; lean_object* v___x_1969_; uint8_t v_isShared_1970_; uint8_t v_isSharedCheck_1982_; 
v_snd_1960_ = lean_ctor_get(v_a_1956_, 1);
lean_inc(v_snd_1960_);
v_snd_1961_ = lean_ctor_get(v_snd_1960_, 1);
lean_inc(v_snd_1961_);
v_fst_1962_ = lean_ctor_get(v_a_1956_, 0);
lean_inc(v_fst_1962_);
lean_dec(v_a_1956_);
v_fst_1963_ = lean_ctor_get(v_snd_1960_, 0);
lean_inc(v_fst_1963_);
lean_dec(v_snd_1960_);
v_fst_1964_ = lean_ctor_get(v_snd_1961_, 0);
lean_inc(v_fst_1964_);
v_snd_1965_ = lean_ctor_get(v_snd_1961_, 1);
lean_inc(v_snd_1965_);
lean_dec(v_snd_1961_);
v_pre_1966_ = lean_ctor_get(v_methods_1936_, 0);
v_post_1967_ = lean_ctor_get(v_methods_1936_, 1);
v_isSharedCheck_1982_ = !lean_is_exclusive(v_methods_1936_);
if (v_isSharedCheck_1982_ == 0)
{
v___x_1969_ = v_methods_1936_;
v_isShared_1970_ = v_isSharedCheck_1982_;
goto v_resetjp_1968_;
}
else
{
lean_inc(v_post_1967_);
lean_inc(v_pre_1966_);
lean_dec(v_methods_1936_);
v___x_1969_ = lean_box(0);
v_isShared_1970_ = v_isSharedCheck_1982_;
goto v_resetjp_1968_;
}
v_resetjp_1968_:
{
lean_object* v___f_1971_; lean_object* v___f_1972_; lean_object* v___f_1973_; lean_object* v___f_1974_; lean_object* v___f_1975_; lean_object* v___x_1977_; 
v___f_1971_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__0___boxed), 13, 1);
lean_closure_set(v___f_1971_, 0, v_fst_1962_);
lean_inc(v_fst_1963_);
v___f_1972_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__1___boxed), 15, 3);
lean_closure_set(v___f_1972_, 0, v_fst_1963_);
lean_closure_set(v___f_1972_, 1, v_fst_1964_);
lean_closure_set(v___f_1972_, 2, v_snd_1965_);
v___f_1973_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__2___boxed), 14, 2);
lean_closure_set(v___f_1973_, 0, v_fst_1963_);
lean_closure_set(v___f_1973_, 1, v___f_1972_);
v___f_1974_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__3___boxed), 13, 2);
lean_closure_set(v___f_1974_, 0, v_post_1967_);
lean_closure_set(v___f_1974_, 1, v___f_1971_);
v___f_1975_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___lam__4___boxed), 13, 2);
lean_closure_set(v___f_1975_, 0, v_pre_1966_);
lean_closure_set(v___f_1975_, 1, v___f_1973_);
if (v_isShared_1970_ == 0)
{
lean_ctor_set(v___x_1969_, 1, v___f_1974_);
lean_ctor_set(v___x_1969_, 0, v___f_1975_);
v___x_1977_ = v___x_1969_;
goto v_reusejp_1976_;
}
else
{
lean_object* v_reuseFailAlloc_1981_; 
v_reuseFailAlloc_1981_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1981_, 0, v___f_1975_);
lean_ctor_set(v_reuseFailAlloc_1981_, 1, v___f_1974_);
v___x_1977_ = v_reuseFailAlloc_1981_;
goto v_reusejp_1976_;
}
v_reusejp_1976_:
{
lean_object* v___x_1979_; 
if (v_isShared_1959_ == 0)
{
lean_ctor_set(v___x_1958_, 0, v___x_1977_);
v___x_1979_ = v___x_1958_;
goto v_reusejp_1978_;
}
else
{
lean_object* v_reuseFailAlloc_1980_; 
v_reuseFailAlloc_1980_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1980_, 0, v___x_1977_);
v___x_1979_ = v_reuseFailAlloc_1980_;
goto v_reusejp_1978_;
}
v_reusejp_1978_:
{
return v___x_1979_;
}
}
}
}
}
else
{
lean_object* v_a_1984_; lean_object* v___x_1986_; uint8_t v_isShared_1987_; uint8_t v_isSharedCheck_1991_; 
lean_dec_ref(v_methods_1936_);
v_a_1984_ = lean_ctor_get(v___x_1955_, 0);
v_isSharedCheck_1991_ = !lean_is_exclusive(v___x_1955_);
if (v_isSharedCheck_1991_ == 0)
{
v___x_1986_ = v___x_1955_;
v_isShared_1987_ = v_isSharedCheck_1991_;
goto v_resetjp_1985_;
}
else
{
lean_inc(v_a_1984_);
lean_dec(v___x_1955_);
v___x_1986_ = lean_box(0);
v_isShared_1987_ = v_isSharedCheck_1991_;
goto v_resetjp_1985_;
}
v_resetjp_1985_:
{
lean_object* v___x_1989_; 
if (v_isShared_1987_ == 0)
{
v___x_1989_ = v___x_1986_;
goto v_reusejp_1988_;
}
else
{
lean_object* v_reuseFailAlloc_1990_; 
v_reuseFailAlloc_1990_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1990_, 0, v_a_1984_);
v___x_1989_ = v_reuseFailAlloc_1990_;
goto v_reusejp_1988_;
}
v_reusejp_1988_:
{
return v___x_1989_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas___boxed(lean_object* v_methods_1992_, lean_object* v_a_1993_, lean_object* v_a_1994_, lean_object* v_a_1995_, lean_object* v_a_1996_, lean_object* v_a_1997_, lean_object* v_a_1998_, lean_object* v_a_1999_, lean_object* v_a_2000_, lean_object* v_a_2001_){
_start:
{
lean_object* v_res_2002_; 
v_res_2002_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas(v_methods_1992_, v_a_1993_, v_a_1994_, v_a_1995_, v_a_1996_, v_a_1997_, v_a_1998_, v_a_1999_, v_a_2000_);
lean_dec(v_a_2000_);
lean_dec_ref(v_a_1999_);
lean_dec(v_a_1998_);
lean_dec_ref(v_a_1997_);
lean_dec(v_a_1996_);
lean_dec_ref(v_a_1995_);
lean_dec(v_a_1994_);
lean_dec_ref(v_a_1993_);
return v_res_2002_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2(lean_object* v_00_u03b2_2003_, lean_object* v_m_2004_, lean_object* v_a_2005_, lean_object* v_b_2006_){
_start:
{
lean_object* v___x_2007_; 
v___x_2007_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2___redArg(v_m_2004_, v_a_2005_, v_b_2006_);
return v___x_2007_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__3(lean_object* v_00_u03b2_2008_, lean_object* v_m_2009_, lean_object* v_a_2010_, lean_object* v_b_2011_){
_start:
{
lean_object* v___x_2012_; 
v___x_2012_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__3___redArg(v_m_2009_, v_a_2010_, v_b_2011_);
return v___x_2012_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4(lean_object* v_upperBound_2013_, lean_object* v___x_2014_, lean_object* v_a_2015_, lean_object* v___x_2016_, lean_object* v_inst_2017_, lean_object* v_R_2018_, lean_object* v_a_2019_, lean_object* v_b_2020_, lean_object* v_c_2021_, lean_object* v___y_2022_, lean_object* v___y_2023_, lean_object* v___y_2024_, lean_object* v___y_2025_, lean_object* v___y_2026_, lean_object* v___y_2027_, lean_object* v___y_2028_, lean_object* v___y_2029_){
_start:
{
lean_object* v___x_2031_; 
v___x_2031_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4___redArg(v_upperBound_2013_, v___x_2014_, v_a_2015_, v___x_2016_, v_a_2019_, v_b_2020_, v___y_2022_, v___y_2023_, v___y_2024_, v___y_2025_, v___y_2026_, v___y_2027_, v___y_2028_, v___y_2029_);
return v___x_2031_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4___boxed(lean_object** _args){
lean_object* v_upperBound_2032_ = _args[0];
lean_object* v___x_2033_ = _args[1];
lean_object* v_a_2034_ = _args[2];
lean_object* v___x_2035_ = _args[3];
lean_object* v_inst_2036_ = _args[4];
lean_object* v_R_2037_ = _args[5];
lean_object* v_a_2038_ = _args[6];
lean_object* v_b_2039_ = _args[7];
lean_object* v_c_2040_ = _args[8];
lean_object* v___y_2041_ = _args[9];
lean_object* v___y_2042_ = _args[10];
lean_object* v___y_2043_ = _args[11];
lean_object* v___y_2044_ = _args[12];
lean_object* v___y_2045_ = _args[13];
lean_object* v___y_2046_ = _args[14];
lean_object* v___y_2047_ = _args[15];
lean_object* v___y_2048_ = _args[16];
lean_object* v___y_2049_ = _args[17];
_start:
{
lean_object* v_res_2050_; 
v_res_2050_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__4(v_upperBound_2032_, v___x_2033_, v_a_2034_, v___x_2035_, v_inst_2036_, v_R_2037_, v_a_2038_, v_b_2039_, v_c_2040_, v___y_2041_, v___y_2042_, v___y_2043_, v___y_2044_, v___y_2045_, v___y_2046_, v___y_2047_, v___y_2048_);
lean_dec(v___y_2048_);
lean_dec_ref(v___y_2047_);
lean_dec(v___y_2046_);
lean_dec_ref(v___y_2045_);
lean_dec(v___y_2044_);
lean_dec_ref(v___y_2043_);
lean_dec(v___y_2042_);
lean_dec_ref(v___y_2041_);
lean_dec_ref(v_a_2034_);
lean_dec_ref(v___x_2033_);
lean_dec(v_upperBound_2032_);
return v_res_2050_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5(lean_object* v_cls_2051_, lean_object* v_msg_2052_, lean_object* v___y_2053_, lean_object* v___y_2054_, lean_object* v___y_2055_, lean_object* v___y_2056_, lean_object* v___y_2057_, lean_object* v___y_2058_, lean_object* v___y_2059_, lean_object* v___y_2060_){
_start:
{
lean_object* v___x_2062_; 
v___x_2062_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg(v_cls_2051_, v_msg_2052_, v___y_2057_, v___y_2058_, v___y_2059_, v___y_2060_);
return v___x_2062_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___boxed(lean_object* v_cls_2063_, lean_object* v_msg_2064_, lean_object* v___y_2065_, lean_object* v___y_2066_, lean_object* v___y_2067_, lean_object* v___y_2068_, lean_object* v___y_2069_, lean_object* v___y_2070_, lean_object* v___y_2071_, lean_object* v___y_2072_, lean_object* v___y_2073_){
_start:
{
lean_object* v_res_2074_; 
v_res_2074_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5(v_cls_2063_, v_msg_2064_, v___y_2065_, v___y_2066_, v___y_2067_, v___y_2068_, v___y_2069_, v___y_2070_, v___y_2071_, v___y_2072_);
lean_dec(v___y_2072_);
lean_dec_ref(v___y_2071_);
lean_dec(v___y_2070_);
lean_dec_ref(v___y_2069_);
lean_dec(v___y_2068_);
lean_dec_ref(v___y_2067_);
lean_dec(v___y_2066_);
lean_dec_ref(v___y_2065_);
return v_res_2074_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0(lean_object* v_00_u03b1_2075_, lean_object* v_msg_2076_, lean_object* v___y_2077_, lean_object* v___y_2078_, lean_object* v___y_2079_, lean_object* v___y_2080_, lean_object* v___y_2081_, lean_object* v___y_2082_, lean_object* v___y_2083_, lean_object* v___y_2084_){
_start:
{
lean_object* v___x_2086_; 
v___x_2086_ = l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___redArg(v_msg_2076_, v___y_2081_, v___y_2082_, v___y_2083_, v___y_2084_);
return v___x_2086_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___boxed(lean_object* v_00_u03b1_2087_, lean_object* v_msg_2088_, lean_object* v___y_2089_, lean_object* v___y_2090_, lean_object* v___y_2091_, lean_object* v___y_2092_, lean_object* v___y_2093_, lean_object* v___y_2094_, lean_object* v___y_2095_, lean_object* v___y_2096_, lean_object* v___y_2097_){
_start:
{
lean_object* v_res_2098_; 
v_res_2098_ = l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0(v_00_u03b1_2087_, v_msg_2088_, v___y_2089_, v___y_2090_, v___y_2091_, v___y_2092_, v___y_2093_, v___y_2094_, v___y_2095_, v___y_2096_);
lean_dec(v___y_2096_);
lean_dec_ref(v___y_2095_);
lean_dec(v___y_2094_);
lean_dec_ref(v___y_2093_);
lean_dec(v___y_2092_);
lean_dec_ref(v___y_2091_);
lean_dec(v___y_2090_);
lean_dec_ref(v___y_2089_);
return v_res_2098_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2(lean_object* v_00_u03b1_2099_, lean_object* v_constName_2100_, lean_object* v___y_2101_, lean_object* v___y_2102_, lean_object* v___y_2103_, lean_object* v___y_2104_, lean_object* v___y_2105_, lean_object* v___y_2106_, lean_object* v___y_2107_, lean_object* v___y_2108_){
_start:
{
lean_object* v___x_2110_; 
v___x_2110_ = l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2___redArg(v_constName_2100_, v___y_2101_, v___y_2102_, v___y_2103_, v___y_2104_, v___y_2105_, v___y_2106_, v___y_2107_, v___y_2108_);
return v___x_2110_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2___boxed(lean_object* v_00_u03b1_2111_, lean_object* v_constName_2112_, lean_object* v___y_2113_, lean_object* v___y_2114_, lean_object* v___y_2115_, lean_object* v___y_2116_, lean_object* v___y_2117_, lean_object* v___y_2118_, lean_object* v___y_2119_, lean_object* v___y_2120_, lean_object* v___y_2121_){
_start:
{
lean_object* v_res_2122_; 
v_res_2122_ = l_Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2(v_00_u03b1_2111_, v_constName_2112_, v___y_2113_, v___y_2114_, v___y_2115_, v___y_2116_, v___y_2117_, v___y_2118_, v___y_2119_, v___y_2120_);
lean_dec(v___y_2120_);
lean_dec_ref(v___y_2119_);
lean_dec(v___y_2118_);
lean_dec_ref(v___y_2117_);
lean_dec(v___y_2116_);
lean_dec_ref(v___y_2115_);
lean_dec(v___y_2114_);
lean_dec_ref(v___y_2113_);
return v_res_2122_;
}
}
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4(lean_object* v_00_u03b2_2123_, lean_object* v_a_2124_, lean_object* v_x_2125_){
_start:
{
uint8_t v___x_2126_; 
v___x_2126_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___redArg(v_a_2124_, v_x_2125_);
return v___x_2126_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___boxed(lean_object* v_00_u03b2_2127_, lean_object* v_a_2128_, lean_object* v_x_2129_){
_start:
{
uint8_t v_res_2130_; lean_object* v_r_2131_; 
v_res_2130_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4(v_00_u03b2_2127_, v_a_2128_, v_x_2129_);
lean_dec(v_x_2129_);
lean_dec(v_a_2128_);
v_r_2131_ = lean_box(v_res_2130_);
return v_r_2131_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5(lean_object* v_00_u03b2_2132_, lean_object* v_data_2133_){
_start:
{
lean_object* v___x_2134_; 
v___x_2134_ = l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5___redArg(v_data_2133_);
return v___x_2134_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__6(lean_object* v_00_u03b2_2135_, lean_object* v_a_2136_, lean_object* v_b_2137_, lean_object* v_x_2138_){
_start:
{
lean_object* v___x_2139_; 
v___x_2139_ = l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__6___redArg(v_a_2136_, v_b_2137_, v_x_2138_);
return v___x_2139_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3(lean_object* v_00_u03b1_2140_, lean_object* v_ref_2141_, lean_object* v_constName_2142_, lean_object* v___y_2143_, lean_object* v___y_2144_, lean_object* v___y_2145_, lean_object* v___y_2146_, lean_object* v___y_2147_, lean_object* v___y_2148_, lean_object* v___y_2149_, lean_object* v___y_2150_){
_start:
{
lean_object* v___x_2152_; 
v___x_2152_ = l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___redArg(v_ref_2141_, v_constName_2142_, v___y_2143_, v___y_2144_, v___y_2145_, v___y_2146_, v___y_2147_, v___y_2148_, v___y_2149_, v___y_2150_);
return v___x_2152_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3___boxed(lean_object* v_00_u03b1_2153_, lean_object* v_ref_2154_, lean_object* v_constName_2155_, lean_object* v___y_2156_, lean_object* v___y_2157_, lean_object* v___y_2158_, lean_object* v___y_2159_, lean_object* v___y_2160_, lean_object* v___y_2161_, lean_object* v___y_2162_, lean_object* v___y_2163_, lean_object* v___y_2164_){
_start:
{
lean_object* v_res_2165_; 
v_res_2165_ = l_Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3(v_00_u03b1_2153_, v_ref_2154_, v_constName_2155_, v___y_2156_, v___y_2157_, v___y_2158_, v___y_2159_, v___y_2160_, v___y_2161_, v___y_2162_, v___y_2163_);
lean_dec(v___y_2163_);
lean_dec_ref(v___y_2162_);
lean_dec(v___y_2161_);
lean_dec_ref(v___y_2160_);
lean_dec(v___y_2159_);
lean_dec_ref(v___y_2158_);
lean_dec(v___y_2157_);
lean_dec_ref(v___y_2156_);
lean_dec(v_ref_2154_);
return v_res_2165_;
}
}
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7(lean_object* v_00_u03b2_2166_, lean_object* v_i_2167_, lean_object* v_source_2168_, lean_object* v_target_2169_){
_start:
{
lean_object* v___x_2170_; 
v___x_2170_ = l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7___redArg(v_i_2167_, v_source_2168_, v_target_2169_);
return v___x_2170_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11(lean_object* v_00_u03b1_2171_, lean_object* v_ref_2172_, lean_object* v_msg_2173_, lean_object* v_declHint_2174_, lean_object* v___y_2175_, lean_object* v___y_2176_, lean_object* v___y_2177_, lean_object* v___y_2178_, lean_object* v___y_2179_, lean_object* v___y_2180_, lean_object* v___y_2181_, lean_object* v___y_2182_){
_start:
{
lean_object* v___x_2184_; 
v___x_2184_ = l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11___redArg(v_ref_2172_, v_msg_2173_, v_declHint_2174_, v___y_2175_, v___y_2176_, v___y_2177_, v___y_2178_, v___y_2179_, v___y_2180_, v___y_2181_, v___y_2182_);
return v___x_2184_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11___boxed(lean_object* v_00_u03b1_2185_, lean_object* v_ref_2186_, lean_object* v_msg_2187_, lean_object* v_declHint_2188_, lean_object* v___y_2189_, lean_object* v___y_2190_, lean_object* v___y_2191_, lean_object* v___y_2192_, lean_object* v___y_2193_, lean_object* v___y_2194_, lean_object* v___y_2195_, lean_object* v___y_2196_, lean_object* v___y_2197_){
_start:
{
lean_object* v_res_2198_; 
v_res_2198_ = l_Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11(v_00_u03b1_2185_, v_ref_2186_, v_msg_2187_, v_declHint_2188_, v___y_2189_, v___y_2190_, v___y_2191_, v___y_2192_, v___y_2193_, v___y_2194_, v___y_2195_, v___y_2196_);
lean_dec(v___y_2196_);
lean_dec_ref(v___y_2195_);
lean_dec(v___y_2194_);
lean_dec_ref(v___y_2193_);
lean_dec(v___y_2192_);
lean_dec_ref(v___y_2191_);
lean_dec(v___y_2190_);
lean_dec_ref(v___y_2189_);
lean_dec(v_ref_2186_);
return v_res_2198_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7_spec__15(lean_object* v_00_u03b2_2199_, lean_object* v_x_2200_, lean_object* v_x_2201_){
_start:
{
lean_object* v___x_2202_; 
v___x_2202_ = l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__5_spec__7_spec__15___redArg(v_x_2200_, v_x_2201_);
return v___x_2202_;
}
}
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17(lean_object* v_msg_2203_, lean_object* v_declHint_2204_, lean_object* v___y_2205_, lean_object* v___y_2206_, lean_object* v___y_2207_, lean_object* v___y_2208_, lean_object* v___y_2209_, lean_object* v___y_2210_, lean_object* v___y_2211_, lean_object* v___y_2212_){
_start:
{
lean_object* v___x_2214_; 
v___x_2214_ = l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___redArg(v_msg_2203_, v_declHint_2204_, v___y_2212_);
return v___x_2214_;
}
}
LEAN_EXPORT lean_object* l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17___boxed(lean_object* v_msg_2215_, lean_object* v_declHint_2216_, lean_object* v___y_2217_, lean_object* v___y_2218_, lean_object* v___y_2219_, lean_object* v___y_2220_, lean_object* v___y_2221_, lean_object* v___y_2222_, lean_object* v___y_2223_, lean_object* v___y_2224_, lean_object* v___y_2225_){
_start:
{
lean_object* v_res_2226_; 
v_res_2226_ = l_Lean_mkUnknownIdentifierMessageCore___at___00Lean_mkUnknownIdentifierMessage___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__15_spec__17(v_msg_2215_, v_declHint_2216_, v___y_2217_, v___y_2218_, v___y_2219_, v___y_2220_, v___y_2221_, v___y_2222_, v___y_2223_, v___y_2224_);
lean_dec(v___y_2224_);
lean_dec_ref(v___y_2223_);
lean_dec(v___y_2222_);
lean_dec_ref(v___y_2221_);
lean_dec(v___y_2220_);
lean_dec_ref(v___y_2219_);
lean_dec(v___y_2218_);
lean_dec_ref(v___y_2217_);
return v_res_2226_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16(lean_object* v_00_u03b1_2227_, lean_object* v_ref_2228_, lean_object* v_msg_2229_, lean_object* v___y_2230_, lean_object* v___y_2231_, lean_object* v___y_2232_, lean_object* v___y_2233_, lean_object* v___y_2234_, lean_object* v___y_2235_, lean_object* v___y_2236_, lean_object* v___y_2237_){
_start:
{
lean_object* v___x_2239_; 
v___x_2239_ = l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16___redArg(v_ref_2228_, v_msg_2229_, v___y_2230_, v___y_2231_, v___y_2232_, v___y_2233_, v___y_2234_, v___y_2235_, v___y_2236_, v___y_2237_);
return v___x_2239_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16___boxed(lean_object* v_00_u03b1_2240_, lean_object* v_ref_2241_, lean_object* v_msg_2242_, lean_object* v___y_2243_, lean_object* v___y_2244_, lean_object* v___y_2245_, lean_object* v___y_2246_, lean_object* v___y_2247_, lean_object* v___y_2248_, lean_object* v___y_2249_, lean_object* v___y_2250_, lean_object* v___y_2251_){
_start:
{
lean_object* v_res_2252_; 
v_res_2252_ = l_Lean_throwErrorAt___at___00Lean_throwUnknownIdentifierAt___at___00Lean_throwUnknownConstantAt___at___00Lean_throwUnknownConstant___at___00Lean_getConstVal___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__1_spec__2_spec__3_spec__11_spec__16(v_00_u03b1_2240_, v_ref_2241_, v_msg_2242_, v___y_2243_, v___y_2244_, v___y_2245_, v___y_2246_, v___y_2247_, v___y_2248_, v___y_2249_, v___y_2250_);
lean_dec(v___y_2250_);
lean_dec_ref(v___y_2249_);
lean_dec(v___y_2248_);
lean_dec_ref(v___y_2247_);
lean_dec(v___y_2246_);
lean_dec_ref(v___y_2245_);
lean_dec(v___y_2244_);
lean_dec_ref(v___y_2243_);
lean_dec(v_ref_2241_);
return v_res_2252_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg___lam__0(lean_object* v_x_2253_, lean_object* v___y_2254_, lean_object* v___y_2255_, lean_object* v___y_2256_, lean_object* v___y_2257_, lean_object* v___y_2258_, lean_object* v___y_2259_, lean_object* v___y_2260_, lean_object* v___y_2261_){
_start:
{
lean_object* v___x_2263_; 
lean_inc(v___y_2257_);
lean_inc_ref(v___y_2256_);
lean_inc(v___y_2255_);
lean_inc_ref(v___y_2254_);
v___x_2263_ = lean_apply_9(v_x_2253_, v___y_2254_, v___y_2255_, v___y_2256_, v___y_2257_, v___y_2258_, v___y_2259_, v___y_2260_, v___y_2261_, lean_box(0));
return v___x_2263_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg___lam__0___boxed(lean_object* v_x_2264_, lean_object* v___y_2265_, lean_object* v___y_2266_, lean_object* v___y_2267_, lean_object* v___y_2268_, lean_object* v___y_2269_, lean_object* v___y_2270_, lean_object* v___y_2271_, lean_object* v___y_2272_, lean_object* v___y_2273_){
_start:
{
lean_object* v_res_2274_; 
v_res_2274_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg___lam__0(v_x_2264_, v___y_2265_, v___y_2266_, v___y_2267_, v___y_2268_, v___y_2269_, v___y_2270_, v___y_2271_, v___y_2272_);
lean_dec(v___y_2268_);
lean_dec_ref(v___y_2267_);
lean_dec(v___y_2266_);
lean_dec_ref(v___y_2265_);
return v_res_2274_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg(lean_object* v_mvarId_2275_, lean_object* v_x_2276_, lean_object* v___y_2277_, lean_object* v___y_2278_, lean_object* v___y_2279_, lean_object* v___y_2280_, lean_object* v___y_2281_, lean_object* v___y_2282_, lean_object* v___y_2283_, lean_object* v___y_2284_){
_start:
{
lean_object* v___f_2286_; lean_object* v___x_2287_; 
lean_inc(v___y_2280_);
lean_inc_ref(v___y_2279_);
lean_inc(v___y_2278_);
lean_inc_ref(v___y_2277_);
v___f_2286_ = lean_alloc_closure((void*)(l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg___lam__0___boxed), 10, 5);
lean_closure_set(v___f_2286_, 0, v_x_2276_);
lean_closure_set(v___f_2286_, 1, v___y_2277_);
lean_closure_set(v___f_2286_, 2, v___y_2278_);
lean_closure_set(v___f_2286_, 3, v___y_2279_);
lean_closure_set(v___f_2286_, 4, v___y_2280_);
v___x_2287_ = l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_box(0), v_mvarId_2275_, v___f_2286_, v___y_2281_, v___y_2282_, v___y_2283_, v___y_2284_);
if (lean_obj_tag(v___x_2287_) == 0)
{
return v___x_2287_;
}
else
{
lean_object* v_a_2288_; lean_object* v___x_2290_; uint8_t v_isShared_2291_; uint8_t v_isSharedCheck_2295_; 
v_a_2288_ = lean_ctor_get(v___x_2287_, 0);
v_isSharedCheck_2295_ = !lean_is_exclusive(v___x_2287_);
if (v_isSharedCheck_2295_ == 0)
{
v___x_2290_ = v___x_2287_;
v_isShared_2291_ = v_isSharedCheck_2295_;
goto v_resetjp_2289_;
}
else
{
lean_inc(v_a_2288_);
lean_dec(v___x_2287_);
v___x_2290_ = lean_box(0);
v_isShared_2291_ = v_isSharedCheck_2295_;
goto v_resetjp_2289_;
}
v_resetjp_2289_:
{
lean_object* v___x_2293_; 
if (v_isShared_2291_ == 0)
{
v___x_2293_ = v___x_2290_;
goto v_reusejp_2292_;
}
else
{
lean_object* v_reuseFailAlloc_2294_; 
v_reuseFailAlloc_2294_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2294_, 0, v_a_2288_);
v___x_2293_ = v_reuseFailAlloc_2294_;
goto v_reusejp_2292_;
}
v_reusejp_2292_:
{
return v___x_2293_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg___boxed(lean_object* v_mvarId_2296_, lean_object* v_x_2297_, lean_object* v___y_2298_, lean_object* v___y_2299_, lean_object* v___y_2300_, lean_object* v___y_2301_, lean_object* v___y_2302_, lean_object* v___y_2303_, lean_object* v___y_2304_, lean_object* v___y_2305_, lean_object* v___y_2306_){
_start:
{
lean_object* v_res_2307_; 
v_res_2307_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg(v_mvarId_2296_, v_x_2297_, v___y_2298_, v___y_2299_, v___y_2300_, v___y_2301_, v___y_2302_, v___y_2303_, v___y_2304_, v___y_2305_);
lean_dec(v___y_2305_);
lean_dec_ref(v___y_2304_);
lean_dec(v___y_2303_);
lean_dec_ref(v___y_2302_);
lean_dec(v___y_2301_);
lean_dec_ref(v___y_2300_);
lean_dec(v___y_2299_);
lean_dec_ref(v___y_2298_);
return v_res_2307_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2(lean_object* v_00_u03b1_2308_, lean_object* v_mvarId_2309_, lean_object* v_x_2310_, lean_object* v___y_2311_, lean_object* v___y_2312_, lean_object* v___y_2313_, lean_object* v___y_2314_, lean_object* v___y_2315_, lean_object* v___y_2316_, lean_object* v___y_2317_, lean_object* v___y_2318_){
_start:
{
lean_object* v___x_2320_; 
v___x_2320_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg(v_mvarId_2309_, v_x_2310_, v___y_2311_, v___y_2312_, v___y_2313_, v___y_2314_, v___y_2315_, v___y_2316_, v___y_2317_, v___y_2318_);
return v___x_2320_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___boxed(lean_object* v_00_u03b1_2321_, lean_object* v_mvarId_2322_, lean_object* v_x_2323_, lean_object* v___y_2324_, lean_object* v___y_2325_, lean_object* v___y_2326_, lean_object* v___y_2327_, lean_object* v___y_2328_, lean_object* v___y_2329_, lean_object* v___y_2330_, lean_object* v___y_2331_, lean_object* v___y_2332_){
_start:
{
lean_object* v_res_2333_; 
v_res_2333_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2(v_00_u03b1_2321_, v_mvarId_2322_, v_x_2323_, v___y_2324_, v___y_2325_, v___y_2326_, v___y_2327_, v___y_2328_, v___y_2329_, v___y_2330_, v___y_2331_);
lean_dec(v___y_2331_);
lean_dec_ref(v___y_2330_);
lean_dec(v___y_2329_);
lean_dec_ref(v___y_2328_);
lean_dec(v___y_2327_);
lean_dec_ref(v___y_2326_);
lean_dec(v___y_2325_);
lean_dec_ref(v___y_2324_);
return v_res_2333_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__0(lean_object* v_x_2334_, lean_object* v___y_2335_, lean_object* v___y_2336_, lean_object* v___y_2337_, lean_object* v___y_2338_, lean_object* v___y_2339_, lean_object* v___y_2340_, lean_object* v___y_2341_, lean_object* v___y_2342_, lean_object* v___y_2343_){
_start:
{
lean_object* v___x_2345_; lean_object* v___x_2346_; 
v___x_2345_ = ((lean_object*)(l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__1___redArg___closed__0));
v___x_2346_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2346_, 0, v___x_2345_);
return v___x_2346_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__0___boxed(lean_object* v_x_2347_, lean_object* v___y_2348_, lean_object* v___y_2349_, lean_object* v___y_2350_, lean_object* v___y_2351_, lean_object* v___y_2352_, lean_object* v___y_2353_, lean_object* v___y_2354_, lean_object* v___y_2355_, lean_object* v___y_2356_, lean_object* v___y_2357_){
_start:
{
lean_object* v_res_2358_; 
v_res_2358_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__0(v_x_2347_, v___y_2348_, v___y_2349_, v___y_2350_, v___y_2351_, v___y_2352_, v___y_2353_, v___y_2354_, v___y_2355_, v___y_2356_);
lean_dec(v___y_2356_);
lean_dec_ref(v___y_2355_);
lean_dec(v___y_2354_);
lean_dec_ref(v___y_2353_);
lean_dec(v___y_2352_);
lean_dec_ref(v___y_2351_);
lean_dec(v___y_2350_);
lean_dec_ref(v___y_2349_);
lean_dec(v___y_2348_);
lean_dec_ref(v_x_2347_);
return v_res_2358_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__1(uint8_t v___x_2359_, lean_object* v___f_2360_, lean_object* v_____r_2361_, lean_object* v___y_2362_, lean_object* v___y_2363_, lean_object* v___y_2364_, lean_object* v___y_2365_, lean_object* v___y_2366_, lean_object* v___y_2367_, lean_object* v___y_2368_, lean_object* v___y_2369_){
_start:
{
lean_object* v___x_2371_; lean_object* v_rewriteCache_2372_; lean_object* v_acNfCache_2373_; lean_object* v_typeAnalysis_2374_; lean_object* v_goal_2375_; lean_object* v_hypotheses_2376_; lean_object* v___x_2378_; uint8_t v_isShared_2379_; uint8_t v_isSharedCheck_2386_; 
v___x_2371_ = lean_st_ref_take(v___y_2363_);
v_rewriteCache_2372_ = lean_ctor_get(v___x_2371_, 0);
v_acNfCache_2373_ = lean_ctor_get(v___x_2371_, 1);
v_typeAnalysis_2374_ = lean_ctor_get(v___x_2371_, 2);
v_goal_2375_ = lean_ctor_get(v___x_2371_, 3);
v_hypotheses_2376_ = lean_ctor_get(v___x_2371_, 4);
v_isSharedCheck_2386_ = !lean_is_exclusive(v___x_2371_);
if (v_isSharedCheck_2386_ == 0)
{
v___x_2378_ = v___x_2371_;
v_isShared_2379_ = v_isSharedCheck_2386_;
goto v_resetjp_2377_;
}
else
{
lean_inc(v_hypotheses_2376_);
lean_inc(v_goal_2375_);
lean_inc(v_typeAnalysis_2374_);
lean_inc(v_acNfCache_2373_);
lean_inc(v_rewriteCache_2372_);
lean_dec(v___x_2371_);
v___x_2378_ = lean_box(0);
v_isShared_2379_ = v_isSharedCheck_2386_;
goto v_resetjp_2377_;
}
v_resetjp_2377_:
{
lean_object* v___x_2381_; 
if (v_isShared_2379_ == 0)
{
v___x_2381_ = v___x_2378_;
goto v_reusejp_2380_;
}
else
{
lean_object* v_reuseFailAlloc_2385_; 
v_reuseFailAlloc_2385_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_2385_, 0, v_rewriteCache_2372_);
lean_ctor_set(v_reuseFailAlloc_2385_, 1, v_acNfCache_2373_);
lean_ctor_set(v_reuseFailAlloc_2385_, 2, v_typeAnalysis_2374_);
lean_ctor_set(v_reuseFailAlloc_2385_, 3, v_goal_2375_);
lean_ctor_set(v_reuseFailAlloc_2385_, 4, v_hypotheses_2376_);
v___x_2381_ = v_reuseFailAlloc_2385_;
goto v_reusejp_2380_;
}
v_reusejp_2380_:
{
lean_object* v___x_2382_; lean_object* v___x_2383_; lean_object* v___x_2384_; 
lean_ctor_set_uint8(v___x_2381_, sizeof(void*)*5, v___x_2359_);
v___x_2382_ = lean_st_ref_set(v___y_2363_, v___x_2381_);
v___x_2383_ = lean_box(0);
lean_inc(v___y_2369_);
lean_inc_ref(v___y_2368_);
lean_inc(v___y_2367_);
lean_inc_ref(v___y_2366_);
lean_inc(v___y_2365_);
lean_inc_ref(v___y_2364_);
lean_inc(v___y_2363_);
lean_inc_ref(v___y_2362_);
v___x_2384_ = lean_apply_10(v___f_2360_, v___x_2383_, v___y_2362_, v___y_2363_, v___y_2364_, v___y_2365_, v___y_2366_, v___y_2367_, v___y_2368_, v___y_2369_, lean_box(0));
return v___x_2384_;
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__1___boxed(lean_object* v___x_2387_, lean_object* v___f_2388_, lean_object* v_____r_2389_, lean_object* v___y_2390_, lean_object* v___y_2391_, lean_object* v___y_2392_, lean_object* v___y_2393_, lean_object* v___y_2394_, lean_object* v___y_2395_, lean_object* v___y_2396_, lean_object* v___y_2397_, lean_object* v___y_2398_){
_start:
{
uint8_t v___x_29134__boxed_2399_; lean_object* v_res_2400_; 
v___x_29134__boxed_2399_ = lean_unbox(v___x_2387_);
v_res_2400_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__1(v___x_29134__boxed_2399_, v___f_2388_, v_____r_2389_, v___y_2390_, v___y_2391_, v___y_2392_, v___y_2393_, v___y_2394_, v___y_2395_, v___y_2396_, v___y_2397_);
lean_dec(v___y_2397_);
lean_dec_ref(v___y_2396_);
lean_dec(v___y_2395_);
lean_dec_ref(v___y_2394_);
lean_dec(v___y_2393_);
lean_dec_ref(v___y_2392_);
lean_dec(v___y_2391_);
lean_dec_ref(v___y_2390_);
return v_res_2400_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__2(lean_object* v___f_2401_, lean_object* v_type_2402_, lean_object* v_____r_2403_, lean_object* v___y_2404_, lean_object* v___y_2405_, lean_object* v___y_2406_, lean_object* v___y_2407_, lean_object* v___y_2408_, lean_object* v___y_2409_, lean_object* v___y_2410_, lean_object* v___y_2411_){
_start:
{
lean_object* v___x_2413_; uint8_t v_debug_2414_; 
v___x_2413_ = lean_st_ref_get(v___y_2407_);
v_debug_2414_ = lean_ctor_get_uint8(v___x_2413_, sizeof(void*)*10);
lean_dec(v___x_2413_);
if (v_debug_2414_ == 0)
{
lean_object* v___x_2415_; lean_object* v___x_2416_; 
lean_dec_ref(v_type_2402_);
v___x_2415_ = lean_box(0);
lean_inc(v___y_2411_);
lean_inc_ref(v___y_2410_);
lean_inc(v___y_2409_);
lean_inc_ref(v___y_2408_);
lean_inc(v___y_2407_);
lean_inc_ref(v___y_2406_);
lean_inc(v___y_2405_);
lean_inc_ref(v___y_2404_);
v___x_2416_ = lean_apply_10(v___f_2401_, v___x_2415_, v___y_2404_, v___y_2405_, v___y_2406_, v___y_2407_, v___y_2408_, v___y_2409_, v___y_2410_, v___y_2411_, lean_box(0));
return v___x_2416_;
}
else
{
lean_object* v___x_2417_; 
v___x_2417_ = l_Lean_Meta_Sym_Internal_Sym_assertShared(v_type_2402_, v___y_2406_, v___y_2407_, v___y_2408_, v___y_2409_, v___y_2410_, v___y_2411_);
if (lean_obj_tag(v___x_2417_) == 0)
{
lean_object* v_a_2418_; lean_object* v___x_2419_; 
v_a_2418_ = lean_ctor_get(v___x_2417_, 0);
lean_inc(v_a_2418_);
lean_dec_ref_known(v___x_2417_, 1);
lean_inc(v___y_2411_);
lean_inc_ref(v___y_2410_);
lean_inc(v___y_2409_);
lean_inc_ref(v___y_2408_);
lean_inc(v___y_2407_);
lean_inc_ref(v___y_2406_);
lean_inc(v___y_2405_);
lean_inc_ref(v___y_2404_);
v___x_2419_ = lean_apply_10(v___f_2401_, v_a_2418_, v___y_2404_, v___y_2405_, v___y_2406_, v___y_2407_, v___y_2408_, v___y_2409_, v___y_2410_, v___y_2411_, lean_box(0));
return v___x_2419_;
}
else
{
lean_object* v_a_2420_; lean_object* v___x_2422_; uint8_t v_isShared_2423_; uint8_t v_isSharedCheck_2427_; 
lean_dec_ref(v___f_2401_);
v_a_2420_ = lean_ctor_get(v___x_2417_, 0);
v_isSharedCheck_2427_ = !lean_is_exclusive(v___x_2417_);
if (v_isSharedCheck_2427_ == 0)
{
v___x_2422_ = v___x_2417_;
v_isShared_2423_ = v_isSharedCheck_2427_;
goto v_resetjp_2421_;
}
else
{
lean_inc(v_a_2420_);
lean_dec(v___x_2417_);
v___x_2422_ = lean_box(0);
v_isShared_2423_ = v_isSharedCheck_2427_;
goto v_resetjp_2421_;
}
v_resetjp_2421_:
{
lean_object* v___x_2425_; 
if (v_isShared_2423_ == 0)
{
v___x_2425_ = v___x_2422_;
goto v_reusejp_2424_;
}
else
{
lean_object* v_reuseFailAlloc_2426_; 
v_reuseFailAlloc_2426_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2426_, 0, v_a_2420_);
v___x_2425_ = v_reuseFailAlloc_2426_;
goto v_reusejp_2424_;
}
v_reusejp_2424_:
{
return v___x_2425_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__2___boxed(lean_object* v___f_2428_, lean_object* v_type_2429_, lean_object* v_____r_2430_, lean_object* v___y_2431_, lean_object* v___y_2432_, lean_object* v___y_2433_, lean_object* v___y_2434_, lean_object* v___y_2435_, lean_object* v___y_2436_, lean_object* v___y_2437_, lean_object* v___y_2438_, lean_object* v___y_2439_){
_start:
{
lean_object* v_res_2440_; 
v_res_2440_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__2(v___f_2428_, v_type_2429_, v_____r_2430_, v___y_2431_, v___y_2432_, v___y_2433_, v___y_2434_, v___y_2435_, v___y_2436_, v___y_2437_, v___y_2438_);
lean_dec(v___y_2438_);
lean_dec_ref(v___y_2437_);
lean_dec(v___y_2436_);
lean_dec_ref(v___y_2435_);
lean_dec(v___y_2434_);
lean_dec_ref(v___y_2433_);
lean_dec(v___y_2432_);
lean_dec_ref(v___y_2431_);
return v_res_2440_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4_spec__5___redArg(lean_object* v_x_2441_, lean_object* v_x_2442_, lean_object* v_x_2443_, lean_object* v_x_2444_){
_start:
{
lean_object* v_ks_2445_; lean_object* v_vs_2446_; lean_object* v___x_2448_; uint8_t v_isShared_2449_; uint8_t v_isSharedCheck_2470_; 
v_ks_2445_ = lean_ctor_get(v_x_2441_, 0);
v_vs_2446_ = lean_ctor_get(v_x_2441_, 1);
v_isSharedCheck_2470_ = !lean_is_exclusive(v_x_2441_);
if (v_isSharedCheck_2470_ == 0)
{
v___x_2448_ = v_x_2441_;
v_isShared_2449_ = v_isSharedCheck_2470_;
goto v_resetjp_2447_;
}
else
{
lean_inc(v_vs_2446_);
lean_inc(v_ks_2445_);
lean_dec(v_x_2441_);
v___x_2448_ = lean_box(0);
v_isShared_2449_ = v_isSharedCheck_2470_;
goto v_resetjp_2447_;
}
v_resetjp_2447_:
{
lean_object* v___x_2450_; uint8_t v___x_2451_; 
v___x_2450_ = lean_array_get_size(v_ks_2445_);
v___x_2451_ = lean_nat_dec_lt(v_x_2442_, v___x_2450_);
if (v___x_2451_ == 0)
{
lean_object* v___x_2452_; lean_object* v___x_2453_; lean_object* v___x_2455_; 
lean_dec(v_x_2442_);
v___x_2452_ = lean_array_push(v_ks_2445_, v_x_2443_);
v___x_2453_ = lean_array_push(v_vs_2446_, v_x_2444_);
if (v_isShared_2449_ == 0)
{
lean_ctor_set(v___x_2448_, 1, v___x_2453_);
lean_ctor_set(v___x_2448_, 0, v___x_2452_);
v___x_2455_ = v___x_2448_;
goto v_reusejp_2454_;
}
else
{
lean_object* v_reuseFailAlloc_2456_; 
v_reuseFailAlloc_2456_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_2456_, 0, v___x_2452_);
lean_ctor_set(v_reuseFailAlloc_2456_, 1, v___x_2453_);
v___x_2455_ = v_reuseFailAlloc_2456_;
goto v_reusejp_2454_;
}
v_reusejp_2454_:
{
return v___x_2455_;
}
}
else
{
lean_object* v_k_x27_2457_; uint8_t v___x_2458_; 
v_k_x27_2457_ = lean_array_fget_borrowed(v_ks_2445_, v_x_2442_);
v___x_2458_ = l_Lean_instBEqMVarId_beq(v_x_2443_, v_k_x27_2457_);
if (v___x_2458_ == 0)
{
lean_object* v___x_2460_; 
if (v_isShared_2449_ == 0)
{
v___x_2460_ = v___x_2448_;
goto v_reusejp_2459_;
}
else
{
lean_object* v_reuseFailAlloc_2464_; 
v_reuseFailAlloc_2464_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_2464_, 0, v_ks_2445_);
lean_ctor_set(v_reuseFailAlloc_2464_, 1, v_vs_2446_);
v___x_2460_ = v_reuseFailAlloc_2464_;
goto v_reusejp_2459_;
}
v_reusejp_2459_:
{
lean_object* v___x_2461_; lean_object* v___x_2462_; 
v___x_2461_ = lean_unsigned_to_nat(1u);
v___x_2462_ = lean_nat_add(v_x_2442_, v___x_2461_);
lean_dec(v_x_2442_);
v_x_2441_ = v___x_2460_;
v_x_2442_ = v___x_2462_;
goto _start;
}
}
else
{
lean_object* v___x_2465_; lean_object* v___x_2466_; lean_object* v___x_2468_; 
v___x_2465_ = lean_array_fset(v_ks_2445_, v_x_2442_, v_x_2443_);
v___x_2466_ = lean_array_fset(v_vs_2446_, v_x_2442_, v_x_2444_);
lean_dec(v_x_2442_);
if (v_isShared_2449_ == 0)
{
lean_ctor_set(v___x_2448_, 1, v___x_2466_);
lean_ctor_set(v___x_2448_, 0, v___x_2465_);
v___x_2468_ = v___x_2448_;
goto v_reusejp_2467_;
}
else
{
lean_object* v_reuseFailAlloc_2469_; 
v_reuseFailAlloc_2469_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_2469_, 0, v___x_2465_);
lean_ctor_set(v_reuseFailAlloc_2469_, 1, v___x_2466_);
v___x_2468_ = v_reuseFailAlloc_2469_;
goto v_reusejp_2467_;
}
v_reusejp_2467_:
{
return v___x_2468_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4___redArg(lean_object* v_n_2471_, lean_object* v_k_2472_, lean_object* v_v_2473_){
_start:
{
lean_object* v___x_2474_; lean_object* v___x_2475_; 
v___x_2474_ = lean_unsigned_to_nat(0u);
v___x_2475_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4_spec__5___redArg(v_n_2471_, v___x_2474_, v_k_2472_, v_v_2473_);
return v___x_2475_;
}
}
static lean_object* _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg___closed__0(void){
_start:
{
lean_object* v___x_2476_; 
v___x_2476_ = l_Lean_PersistentHashMap_mkEmptyEntries(lean_box(0), lean_box(0));
return v___x_2476_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg(lean_object* v_x_2477_, size_t v_x_2478_, size_t v_x_2479_, lean_object* v_x_2480_, lean_object* v_x_2481_){
_start:
{
if (lean_obj_tag(v_x_2477_) == 0)
{
lean_object* v_es_2482_; size_t v___x_2483_; size_t v___x_2484_; lean_object* v_j_2485_; lean_object* v___x_2486_; uint8_t v___x_2487_; 
v_es_2482_ = lean_ctor_get(v_x_2477_, 0);
v___x_2483_ = ((size_t)31ULL);
v___x_2484_ = lean_usize_land(v_x_2478_, v___x_2483_);
v_j_2485_ = lean_usize_to_nat(v___x_2484_);
v___x_2486_ = lean_array_get_size(v_es_2482_);
v___x_2487_ = lean_nat_dec_lt(v_j_2485_, v___x_2486_);
if (v___x_2487_ == 0)
{
lean_dec(v_j_2485_);
lean_dec(v_x_2481_);
lean_dec(v_x_2480_);
return v_x_2477_;
}
else
{
lean_object* v___x_2489_; uint8_t v_isShared_2490_; uint8_t v_isSharedCheck_2526_; 
lean_inc_ref(v_es_2482_);
v_isSharedCheck_2526_ = !lean_is_exclusive(v_x_2477_);
if (v_isSharedCheck_2526_ == 0)
{
lean_object* v_unused_2527_; 
v_unused_2527_ = lean_ctor_get(v_x_2477_, 0);
lean_dec(v_unused_2527_);
v___x_2489_ = v_x_2477_;
v_isShared_2490_ = v_isSharedCheck_2526_;
goto v_resetjp_2488_;
}
else
{
lean_dec(v_x_2477_);
v___x_2489_ = lean_box(0);
v_isShared_2490_ = v_isSharedCheck_2526_;
goto v_resetjp_2488_;
}
v_resetjp_2488_:
{
lean_object* v_v_2491_; lean_object* v___x_2492_; lean_object* v_xs_x27_2493_; lean_object* v___y_2495_; 
v_v_2491_ = lean_array_fget(v_es_2482_, v_j_2485_);
v___x_2492_ = lean_box(0);
v_xs_x27_2493_ = lean_array_fset(v_es_2482_, v_j_2485_, v___x_2492_);
switch(lean_obj_tag(v_v_2491_))
{
case 0:
{
lean_object* v_key_2500_; lean_object* v_val_2501_; lean_object* v___x_2503_; uint8_t v_isShared_2504_; uint8_t v_isSharedCheck_2511_; 
v_key_2500_ = lean_ctor_get(v_v_2491_, 0);
v_val_2501_ = lean_ctor_get(v_v_2491_, 1);
v_isSharedCheck_2511_ = !lean_is_exclusive(v_v_2491_);
if (v_isSharedCheck_2511_ == 0)
{
v___x_2503_ = v_v_2491_;
v_isShared_2504_ = v_isSharedCheck_2511_;
goto v_resetjp_2502_;
}
else
{
lean_inc(v_val_2501_);
lean_inc(v_key_2500_);
lean_dec(v_v_2491_);
v___x_2503_ = lean_box(0);
v_isShared_2504_ = v_isSharedCheck_2511_;
goto v_resetjp_2502_;
}
v_resetjp_2502_:
{
uint8_t v___x_2505_; 
v___x_2505_ = l_Lean_instBEqMVarId_beq(v_x_2480_, v_key_2500_);
if (v___x_2505_ == 0)
{
lean_object* v___x_2506_; lean_object* v___x_2507_; 
lean_del_object(v___x_2503_);
v___x_2506_ = l_Lean_PersistentHashMap_mkCollisionNode___redArg(v_key_2500_, v_val_2501_, v_x_2480_, v_x_2481_);
v___x_2507_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_2507_, 0, v___x_2506_);
v___y_2495_ = v___x_2507_;
goto v___jp_2494_;
}
else
{
lean_object* v___x_2509_; 
lean_dec(v_val_2501_);
lean_dec(v_key_2500_);
if (v_isShared_2504_ == 0)
{
lean_ctor_set(v___x_2503_, 1, v_x_2481_);
lean_ctor_set(v___x_2503_, 0, v_x_2480_);
v___x_2509_ = v___x_2503_;
goto v_reusejp_2508_;
}
else
{
lean_object* v_reuseFailAlloc_2510_; 
v_reuseFailAlloc_2510_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_2510_, 0, v_x_2480_);
lean_ctor_set(v_reuseFailAlloc_2510_, 1, v_x_2481_);
v___x_2509_ = v_reuseFailAlloc_2510_;
goto v_reusejp_2508_;
}
v_reusejp_2508_:
{
v___y_2495_ = v___x_2509_;
goto v___jp_2494_;
}
}
}
}
case 1:
{
lean_object* v_node_2512_; lean_object* v___x_2514_; uint8_t v_isShared_2515_; uint8_t v_isSharedCheck_2524_; 
v_node_2512_ = lean_ctor_get(v_v_2491_, 0);
v_isSharedCheck_2524_ = !lean_is_exclusive(v_v_2491_);
if (v_isSharedCheck_2524_ == 0)
{
v___x_2514_ = v_v_2491_;
v_isShared_2515_ = v_isSharedCheck_2524_;
goto v_resetjp_2513_;
}
else
{
lean_inc(v_node_2512_);
lean_dec(v_v_2491_);
v___x_2514_ = lean_box(0);
v_isShared_2515_ = v_isSharedCheck_2524_;
goto v_resetjp_2513_;
}
v_resetjp_2513_:
{
size_t v___x_2516_; size_t v___x_2517_; size_t v___x_2518_; size_t v___x_2519_; lean_object* v___x_2520_; lean_object* v___x_2522_; 
v___x_2516_ = ((size_t)5ULL);
v___x_2517_ = lean_usize_shift_right(v_x_2478_, v___x_2516_);
v___x_2518_ = ((size_t)1ULL);
v___x_2519_ = lean_usize_add(v_x_2479_, v___x_2518_);
v___x_2520_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg(v_node_2512_, v___x_2517_, v___x_2519_, v_x_2480_, v_x_2481_);
if (v_isShared_2515_ == 0)
{
lean_ctor_set(v___x_2514_, 0, v___x_2520_);
v___x_2522_ = v___x_2514_;
goto v_reusejp_2521_;
}
else
{
lean_object* v_reuseFailAlloc_2523_; 
v_reuseFailAlloc_2523_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2523_, 0, v___x_2520_);
v___x_2522_ = v_reuseFailAlloc_2523_;
goto v_reusejp_2521_;
}
v_reusejp_2521_:
{
v___y_2495_ = v___x_2522_;
goto v___jp_2494_;
}
}
}
default: 
{
lean_object* v___x_2525_; 
v___x_2525_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2525_, 0, v_x_2480_);
lean_ctor_set(v___x_2525_, 1, v_x_2481_);
v___y_2495_ = v___x_2525_;
goto v___jp_2494_;
}
}
v___jp_2494_:
{
lean_object* v___x_2496_; lean_object* v___x_2498_; 
v___x_2496_ = lean_array_fset(v_xs_x27_2493_, v_j_2485_, v___y_2495_);
lean_dec(v_j_2485_);
if (v_isShared_2490_ == 0)
{
lean_ctor_set(v___x_2489_, 0, v___x_2496_);
v___x_2498_ = v___x_2489_;
goto v_reusejp_2497_;
}
else
{
lean_object* v_reuseFailAlloc_2499_; 
v_reuseFailAlloc_2499_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2499_, 0, v___x_2496_);
v___x_2498_ = v_reuseFailAlloc_2499_;
goto v_reusejp_2497_;
}
v_reusejp_2497_:
{
return v___x_2498_;
}
}
}
}
}
else
{
lean_object* v_ks_2528_; lean_object* v_vs_2529_; lean_object* v___x_2531_; uint8_t v_isShared_2532_; uint8_t v_isSharedCheck_2549_; 
v_ks_2528_ = lean_ctor_get(v_x_2477_, 0);
v_vs_2529_ = lean_ctor_get(v_x_2477_, 1);
v_isSharedCheck_2549_ = !lean_is_exclusive(v_x_2477_);
if (v_isSharedCheck_2549_ == 0)
{
v___x_2531_ = v_x_2477_;
v_isShared_2532_ = v_isSharedCheck_2549_;
goto v_resetjp_2530_;
}
else
{
lean_inc(v_vs_2529_);
lean_inc(v_ks_2528_);
lean_dec(v_x_2477_);
v___x_2531_ = lean_box(0);
v_isShared_2532_ = v_isSharedCheck_2549_;
goto v_resetjp_2530_;
}
v_resetjp_2530_:
{
lean_object* v___x_2534_; 
if (v_isShared_2532_ == 0)
{
v___x_2534_ = v___x_2531_;
goto v_reusejp_2533_;
}
else
{
lean_object* v_reuseFailAlloc_2548_; 
v_reuseFailAlloc_2548_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_2548_, 0, v_ks_2528_);
lean_ctor_set(v_reuseFailAlloc_2548_, 1, v_vs_2529_);
v___x_2534_ = v_reuseFailAlloc_2548_;
goto v_reusejp_2533_;
}
v_reusejp_2533_:
{
lean_object* v_newNode_2535_; uint8_t v___y_2537_; size_t v___x_2543_; uint8_t v___x_2544_; 
v_newNode_2535_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4___redArg(v___x_2534_, v_x_2480_, v_x_2481_);
v___x_2543_ = ((size_t)7ULL);
v___x_2544_ = lean_usize_dec_le(v___x_2543_, v_x_2479_);
if (v___x_2544_ == 0)
{
lean_object* v___x_2545_; lean_object* v___x_2546_; uint8_t v___x_2547_; 
v___x_2545_ = l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(v_newNode_2535_);
v___x_2546_ = lean_unsigned_to_nat(4u);
v___x_2547_ = lean_nat_dec_lt(v___x_2545_, v___x_2546_);
lean_dec(v___x_2545_);
v___y_2537_ = v___x_2547_;
goto v___jp_2536_;
}
else
{
v___y_2537_ = v___x_2544_;
goto v___jp_2536_;
}
v___jp_2536_:
{
if (v___y_2537_ == 0)
{
lean_object* v_ks_2538_; lean_object* v_vs_2539_; lean_object* v___x_2540_; lean_object* v___x_2541_; lean_object* v___x_2542_; 
v_ks_2538_ = lean_ctor_get(v_newNode_2535_, 0);
lean_inc_ref(v_ks_2538_);
v_vs_2539_ = lean_ctor_get(v_newNode_2535_, 1);
lean_inc_ref(v_vs_2539_);
lean_dec_ref(v_newNode_2535_);
v___x_2540_ = lean_unsigned_to_nat(0u);
v___x_2541_ = lean_obj_once(&l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg___closed__0, &l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg___closed__0_once, _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg___closed__0);
v___x_2542_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5___redArg(v_x_2479_, v_ks_2538_, v_vs_2539_, v___x_2540_, v___x_2541_);
lean_dec_ref(v_vs_2539_);
lean_dec_ref(v_ks_2538_);
return v___x_2542_;
}
else
{
return v_newNode_2535_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5___redArg(size_t v_depth_2550_, lean_object* v_keys_2551_, lean_object* v_vals_2552_, lean_object* v_i_2553_, lean_object* v_entries_2554_){
_start:
{
lean_object* v___x_2555_; uint8_t v___x_2556_; 
v___x_2555_ = lean_array_get_size(v_keys_2551_);
v___x_2556_ = lean_nat_dec_lt(v_i_2553_, v___x_2555_);
if (v___x_2556_ == 0)
{
lean_dec(v_i_2553_);
return v_entries_2554_;
}
else
{
lean_object* v_k_2557_; lean_object* v_v_2558_; uint64_t v___x_2559_; size_t v_h_2560_; size_t v___x_2561_; lean_object* v___x_2562_; size_t v___x_2563_; size_t v___x_2564_; size_t v___x_2565_; size_t v_h_2566_; lean_object* v___x_2567_; lean_object* v___x_2568_; 
v_k_2557_ = lean_array_fget_borrowed(v_keys_2551_, v_i_2553_);
v_v_2558_ = lean_array_fget_borrowed(v_vals_2552_, v_i_2553_);
v___x_2559_ = l_Lean_instHashableMVarId_hash(v_k_2557_);
v_h_2560_ = lean_uint64_to_usize(v___x_2559_);
v___x_2561_ = ((size_t)5ULL);
v___x_2562_ = lean_unsigned_to_nat(1u);
v___x_2563_ = ((size_t)1ULL);
v___x_2564_ = lean_usize_sub(v_depth_2550_, v___x_2563_);
v___x_2565_ = lean_usize_mul(v___x_2561_, v___x_2564_);
v_h_2566_ = lean_usize_shift_right(v_h_2560_, v___x_2565_);
v___x_2567_ = lean_nat_add(v_i_2553_, v___x_2562_);
lean_dec(v_i_2553_);
lean_inc(v_v_2558_);
lean_inc(v_k_2557_);
v___x_2568_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg(v_entries_2554_, v_h_2566_, v_depth_2550_, v_k_2557_, v_v_2558_);
v_i_2553_ = v___x_2567_;
v_entries_2554_ = v___x_2568_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5___redArg___boxed(lean_object* v_depth_2570_, lean_object* v_keys_2571_, lean_object* v_vals_2572_, lean_object* v_i_2573_, lean_object* v_entries_2574_){
_start:
{
size_t v_depth_boxed_2575_; lean_object* v_res_2576_; 
v_depth_boxed_2575_ = lean_unbox_usize(v_depth_2570_);
lean_dec(v_depth_2570_);
v_res_2576_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5___redArg(v_depth_boxed_2575_, v_keys_2571_, v_vals_2572_, v_i_2573_, v_entries_2574_);
lean_dec_ref(v_vals_2572_);
lean_dec_ref(v_keys_2571_);
return v_res_2576_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg___boxed(lean_object* v_x_2577_, lean_object* v_x_2578_, lean_object* v_x_2579_, lean_object* v_x_2580_, lean_object* v_x_2581_){
_start:
{
size_t v_x_29330__boxed_2582_; size_t v_x_29331__boxed_2583_; lean_object* v_res_2584_; 
v_x_29330__boxed_2582_ = lean_unbox_usize(v_x_2578_);
lean_dec(v_x_2578_);
v_x_29331__boxed_2583_ = lean_unbox_usize(v_x_2579_);
lean_dec(v_x_2579_);
v_res_2584_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg(v_x_2577_, v_x_29330__boxed_2582_, v_x_29331__boxed_2583_, v_x_2580_, v_x_2581_);
return v_res_2584_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0___redArg(lean_object* v_x_2585_, lean_object* v_x_2586_, lean_object* v_x_2587_){
_start:
{
uint64_t v___x_2588_; size_t v___x_2589_; size_t v___x_2590_; lean_object* v___x_2591_; 
v___x_2588_ = l_Lean_instHashableMVarId_hash(v_x_2586_);
v___x_2589_ = lean_uint64_to_usize(v___x_2588_);
v___x_2590_ = ((size_t)1ULL);
v___x_2591_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg(v_x_2585_, v___x_2589_, v___x_2590_, v_x_2586_, v_x_2587_);
return v___x_2591_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0___redArg(lean_object* v_mvarId_2592_, lean_object* v_val_2593_, lean_object* v___y_2594_){
_start:
{
lean_object* v___x_2596_; lean_object* v_mctx_2597_; lean_object* v_cache_2598_; lean_object* v_zetaDeltaFVarIds_2599_; lean_object* v_postponed_2600_; lean_object* v_diag_2601_; lean_object* v___x_2603_; uint8_t v_isShared_2604_; uint8_t v_isSharedCheck_2629_; 
v___x_2596_ = lean_st_ref_take(v___y_2594_);
v_mctx_2597_ = lean_ctor_get(v___x_2596_, 0);
v_cache_2598_ = lean_ctor_get(v___x_2596_, 1);
v_zetaDeltaFVarIds_2599_ = lean_ctor_get(v___x_2596_, 2);
v_postponed_2600_ = lean_ctor_get(v___x_2596_, 3);
v_diag_2601_ = lean_ctor_get(v___x_2596_, 4);
v_isSharedCheck_2629_ = !lean_is_exclusive(v___x_2596_);
if (v_isSharedCheck_2629_ == 0)
{
v___x_2603_ = v___x_2596_;
v_isShared_2604_ = v_isSharedCheck_2629_;
goto v_resetjp_2602_;
}
else
{
lean_inc(v_diag_2601_);
lean_inc(v_postponed_2600_);
lean_inc(v_zetaDeltaFVarIds_2599_);
lean_inc(v_cache_2598_);
lean_inc(v_mctx_2597_);
lean_dec(v___x_2596_);
v___x_2603_ = lean_box(0);
v_isShared_2604_ = v_isSharedCheck_2629_;
goto v_resetjp_2602_;
}
v_resetjp_2602_:
{
lean_object* v_depth_2605_; lean_object* v_levelAssignDepth_2606_; lean_object* v_lmvarCounter_2607_; lean_object* v_mvarCounter_2608_; lean_object* v_lDecls_2609_; lean_object* v_decls_2610_; lean_object* v_userNames_2611_; lean_object* v_lAssignment_2612_; lean_object* v_eAssignment_2613_; lean_object* v_dAssignment_2614_; lean_object* v___x_2616_; uint8_t v_isShared_2617_; uint8_t v_isSharedCheck_2628_; 
v_depth_2605_ = lean_ctor_get(v_mctx_2597_, 0);
v_levelAssignDepth_2606_ = lean_ctor_get(v_mctx_2597_, 1);
v_lmvarCounter_2607_ = lean_ctor_get(v_mctx_2597_, 2);
v_mvarCounter_2608_ = lean_ctor_get(v_mctx_2597_, 3);
v_lDecls_2609_ = lean_ctor_get(v_mctx_2597_, 4);
v_decls_2610_ = lean_ctor_get(v_mctx_2597_, 5);
v_userNames_2611_ = lean_ctor_get(v_mctx_2597_, 6);
v_lAssignment_2612_ = lean_ctor_get(v_mctx_2597_, 7);
v_eAssignment_2613_ = lean_ctor_get(v_mctx_2597_, 8);
v_dAssignment_2614_ = lean_ctor_get(v_mctx_2597_, 9);
v_isSharedCheck_2628_ = !lean_is_exclusive(v_mctx_2597_);
if (v_isSharedCheck_2628_ == 0)
{
v___x_2616_ = v_mctx_2597_;
v_isShared_2617_ = v_isSharedCheck_2628_;
goto v_resetjp_2615_;
}
else
{
lean_inc(v_dAssignment_2614_);
lean_inc(v_eAssignment_2613_);
lean_inc(v_lAssignment_2612_);
lean_inc(v_userNames_2611_);
lean_inc(v_decls_2610_);
lean_inc(v_lDecls_2609_);
lean_inc(v_mvarCounter_2608_);
lean_inc(v_lmvarCounter_2607_);
lean_inc(v_levelAssignDepth_2606_);
lean_inc(v_depth_2605_);
lean_dec(v_mctx_2597_);
v___x_2616_ = lean_box(0);
v_isShared_2617_ = v_isSharedCheck_2628_;
goto v_resetjp_2615_;
}
v_resetjp_2615_:
{
lean_object* v___x_2618_; lean_object* v___x_2620_; 
v___x_2618_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0___redArg(v_eAssignment_2613_, v_mvarId_2592_, v_val_2593_);
if (v_isShared_2617_ == 0)
{
lean_ctor_set(v___x_2616_, 8, v___x_2618_);
v___x_2620_ = v___x_2616_;
goto v_reusejp_2619_;
}
else
{
lean_object* v_reuseFailAlloc_2627_; 
v_reuseFailAlloc_2627_ = lean_alloc_ctor(0, 10, 0);
lean_ctor_set(v_reuseFailAlloc_2627_, 0, v_depth_2605_);
lean_ctor_set(v_reuseFailAlloc_2627_, 1, v_levelAssignDepth_2606_);
lean_ctor_set(v_reuseFailAlloc_2627_, 2, v_lmvarCounter_2607_);
lean_ctor_set(v_reuseFailAlloc_2627_, 3, v_mvarCounter_2608_);
lean_ctor_set(v_reuseFailAlloc_2627_, 4, v_lDecls_2609_);
lean_ctor_set(v_reuseFailAlloc_2627_, 5, v_decls_2610_);
lean_ctor_set(v_reuseFailAlloc_2627_, 6, v_userNames_2611_);
lean_ctor_set(v_reuseFailAlloc_2627_, 7, v_lAssignment_2612_);
lean_ctor_set(v_reuseFailAlloc_2627_, 8, v___x_2618_);
lean_ctor_set(v_reuseFailAlloc_2627_, 9, v_dAssignment_2614_);
v___x_2620_ = v_reuseFailAlloc_2627_;
goto v_reusejp_2619_;
}
v_reusejp_2619_:
{
lean_object* v___x_2622_; 
if (v_isShared_2604_ == 0)
{
lean_ctor_set(v___x_2603_, 0, v___x_2620_);
v___x_2622_ = v___x_2603_;
goto v_reusejp_2621_;
}
else
{
lean_object* v_reuseFailAlloc_2626_; 
v_reuseFailAlloc_2626_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_2626_, 0, v___x_2620_);
lean_ctor_set(v_reuseFailAlloc_2626_, 1, v_cache_2598_);
lean_ctor_set(v_reuseFailAlloc_2626_, 2, v_zetaDeltaFVarIds_2599_);
lean_ctor_set(v_reuseFailAlloc_2626_, 3, v_postponed_2600_);
lean_ctor_set(v_reuseFailAlloc_2626_, 4, v_diag_2601_);
v___x_2622_ = v_reuseFailAlloc_2626_;
goto v_reusejp_2621_;
}
v_reusejp_2621_:
{
lean_object* v___x_2623_; lean_object* v___x_2624_; lean_object* v___x_2625_; 
v___x_2623_ = lean_st_ref_set(v___y_2594_, v___x_2622_);
v___x_2624_ = lean_box(0);
v___x_2625_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2625_, 0, v___x_2624_);
return v___x_2625_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0___redArg___boxed(lean_object* v_mvarId_2630_, lean_object* v_val_2631_, lean_object* v___y_2632_, lean_object* v___y_2633_){
_start:
{
lean_object* v_res_2634_; 
v_res_2634_ = l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0___redArg(v_mvarId_2630_, v_val_2631_, v___y_2632_);
lean_dec(v___y_2632_);
return v_res_2634_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__0(lean_object* v_snd_2635_, lean_object* v_a_2636_, lean_object* v___x_2637_, lean_object* v_____r_2638_, lean_object* v___y_2639_, lean_object* v___y_2640_, lean_object* v___y_2641_, lean_object* v___y_2642_, lean_object* v___y_2643_, lean_object* v___y_2644_, lean_object* v___y_2645_, lean_object* v___y_2646_){
_start:
{
lean_object* v___x_2648_; lean_object* v___x_2649_; lean_object* v___x_2650_; lean_object* v___x_2651_; 
v___x_2648_ = lean_array_push(v_snd_2635_, v_a_2636_);
v___x_2649_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2649_, 0, v___x_2637_);
lean_ctor_set(v___x_2649_, 1, v___x_2648_);
v___x_2650_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_2650_, 0, v___x_2649_);
v___x_2651_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2651_, 0, v___x_2650_);
return v___x_2651_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__0___boxed(lean_object* v_snd_2652_, lean_object* v_a_2653_, lean_object* v___x_2654_, lean_object* v_____r_2655_, lean_object* v___y_2656_, lean_object* v___y_2657_, lean_object* v___y_2658_, lean_object* v___y_2659_, lean_object* v___y_2660_, lean_object* v___y_2661_, lean_object* v___y_2662_, lean_object* v___y_2663_, lean_object* v___y_2664_){
_start:
{
lean_object* v_res_2665_; 
v_res_2665_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__0(v_snd_2652_, v_a_2653_, v___x_2654_, v_____r_2655_, v___y_2656_, v___y_2657_, v___y_2658_, v___y_2659_, v___y_2660_, v___y_2661_, v___y_2662_, v___y_2663_);
lean_dec(v___y_2663_);
lean_dec_ref(v___y_2662_);
lean_dec(v___y_2661_);
lean_dec_ref(v___y_2660_);
lean_dec(v___y_2659_);
lean_dec_ref(v___y_2658_);
lean_dec(v___y_2657_);
lean_dec_ref(v___y_2656_);
return v_res_2665_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__1(void){
_start:
{
lean_object* v___x_2667_; lean_object* v___x_2668_; 
v___x_2667_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__0));
v___x_2668_ = l_Lean_stringToMessageData(v___x_2667_);
return v___x_2668_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg(lean_object* v_upperBound_2669_, lean_object* v___x_2670_, lean_object* v_a_2671_, lean_object* v___x_2672_, lean_object* v_a_2673_, lean_object* v_b_2674_, lean_object* v___y_2675_, lean_object* v___y_2676_, lean_object* v___y_2677_, lean_object* v___y_2678_, lean_object* v___y_2679_, lean_object* v___y_2680_, lean_object* v___y_2681_, lean_object* v___y_2682_){
_start:
{
lean_object* v___y_2685_; uint8_t v___x_2707_; 
v___x_2707_ = lean_nat_dec_lt(v_a_2673_, v_upperBound_2669_);
if (v___x_2707_ == 0)
{
lean_object* v___x_2708_; 
lean_dec(v_a_2673_);
lean_dec_ref(v___x_2672_);
lean_dec_ref(v_a_2671_);
v___x_2708_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2708_, 0, v_b_2674_);
return v___x_2708_;
}
else
{
lean_object* v___x_2709_; lean_object* v_type_2710_; lean_object* v___x_2711_; lean_object* v___x_2712_; 
v___x_2709_ = lean_array_fget_borrowed(v___x_2670_, v_a_2673_);
v_type_2710_ = lean_ctor_get(v___x_2709_, 1);
lean_inc_ref(v_type_2710_);
v___x_2711_ = lean_alloc_closure((void*)(l_Lean_Meta_Sym_Simp_simp___boxed), 11, 1);
lean_closure_set(v___x_2711_, 0, v_type_2710_);
lean_inc_ref(v___x_2672_);
lean_inc_ref(v_a_2671_);
v___x_2712_ = l_Lean_Meta_Sym_Simp_SimpM_run_x27___redArg(v___x_2711_, v_a_2671_, v___x_2672_, v___y_2677_, v___y_2678_, v___y_2679_, v___y_2680_, v___y_2681_, v___y_2682_);
if (lean_obj_tag(v___x_2712_) == 0)
{
lean_object* v_a_2713_; lean_object* v___x_2714_; 
v_a_2713_ = lean_ctor_get(v___x_2712_, 0);
lean_inc(v_a_2713_);
lean_dec_ref_known(v___x_2712_, 1);
lean_inc(v___x_2709_);
v___x_2714_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(v___x_2709_, v_a_2713_, v___y_2678_, v___y_2679_, v___y_2680_, v___y_2681_, v___y_2682_);
if (lean_obj_tag(v___x_2714_) == 0)
{
lean_object* v_a_2715_; lean_object* v_snd_2716_; lean_object* v___x_2718_; uint8_t v_isShared_2719_; uint8_t v_isSharedCheck_2780_; 
v_a_2715_ = lean_ctor_get(v___x_2714_, 0);
lean_inc(v_a_2715_);
lean_dec_ref_known(v___x_2714_, 1);
v_snd_2716_ = lean_ctor_get(v_b_2674_, 1);
v_isSharedCheck_2780_ = !lean_is_exclusive(v_b_2674_);
if (v_isSharedCheck_2780_ == 0)
{
lean_object* v_unused_2781_; 
v_unused_2781_ = lean_ctor_get(v_b_2674_, 0);
lean_dec(v_unused_2781_);
v___x_2718_ = v_b_2674_;
v_isShared_2719_ = v_isSharedCheck_2780_;
goto v_resetjp_2717_;
}
else
{
lean_inc(v_snd_2716_);
lean_dec(v_b_2674_);
v___x_2718_ = lean_box(0);
v_isShared_2719_ = v_isSharedCheck_2780_;
goto v_resetjp_2717_;
}
v_resetjp_2717_:
{
lean_object* v_type_2720_; lean_object* v_value_2721_; uint8_t v___x_2722_; 
v_type_2720_ = lean_ctor_get(v_a_2715_, 1);
v_value_2721_ = lean_ctor_get(v_a_2715_, 2);
lean_inc_ref(v_type_2720_);
v___x_2722_ = l_Lean_Expr_isFalse(v_type_2720_);
if (v___x_2722_ == 0)
{
lean_object* v___x_2723_; lean_object* v___f_2724_; lean_object* v___x_2725_; lean_object* v___f_2726_; uint8_t v___x_2753_; 
lean_del_object(v___x_2718_);
v___x_2723_ = lean_box(0);
lean_inc(v_a_2715_);
lean_inc(v_snd_2716_);
v___f_2724_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__0___boxed), 13, 3);
lean_closure_set(v___f_2724_, 0, v_snd_2716_);
lean_closure_set(v___f_2724_, 1, v_a_2715_);
lean_closure_set(v___f_2724_, 2, v___x_2723_);
v___x_2725_ = lean_box(v___x_2707_);
v___f_2726_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__1___boxed), 12, 2);
lean_closure_set(v___f_2726_, 0, v___x_2725_);
lean_closure_set(v___f_2726_, 1, v___f_2724_);
v___x_2753_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(v___x_2709_, v_a_2715_);
if (v___x_2753_ == 0)
{
lean_inc_ref(v_type_2720_);
lean_dec(v_snd_2716_);
lean_dec(v_a_2715_);
goto v___jp_2730_;
}
else
{
if (v___x_2722_ == 0)
{
lean_object* v___x_2754_; lean_object* v___x_2755_; 
lean_dec_ref(v___f_2726_);
v___x_2754_ = lean_box(0);
v___x_2755_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__0(v_snd_2716_, v_a_2715_, v___x_2723_, v___x_2754_, v___y_2675_, v___y_2676_, v___y_2677_, v___y_2678_, v___y_2679_, v___y_2680_, v___y_2681_, v___y_2682_);
v___y_2685_ = v___x_2755_;
goto v___jp_2684_;
}
else
{
lean_inc_ref(v_type_2720_);
lean_dec(v_snd_2716_);
lean_dec(v_a_2715_);
goto v___jp_2730_;
}
}
v___jp_2727_:
{
lean_object* v___x_2728_; lean_object* v___x_2729_; 
v___x_2728_ = lean_box(0);
v___x_2729_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__2(v___f_2726_, v_type_2720_, v___x_2728_, v___y_2675_, v___y_2676_, v___y_2677_, v___y_2678_, v___y_2679_, v___y_2680_, v___y_2681_, v___y_2682_);
v___y_2685_ = v___x_2729_;
goto v___jp_2684_;
}
v___jp_2730_:
{
lean_object* v_options_2731_; uint8_t v_hasTrace_2732_; 
v_options_2731_ = lean_ctor_get(v___y_2681_, 2);
v_hasTrace_2732_ = lean_ctor_get_uint8(v_options_2731_, sizeof(void*)*1);
if (v_hasTrace_2732_ == 0)
{
goto v___jp_2727_;
}
else
{
lean_object* v_inheritedTraceOptions_2733_; lean_object* v___x_2734_; lean_object* v___x_2735_; uint8_t v___x_2736_; 
v_inheritedTraceOptions_2733_ = lean_ctor_get(v___y_2681_, 13);
v___x_2734_ = ((lean_object*)(l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3));
v___x_2735_ = lean_obj_once(&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6, &l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6_once, _init_l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6);
v___x_2736_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_2733_, v_options_2731_, v___x_2735_);
if (v___x_2736_ == 0)
{
goto v___jp_2727_;
}
else
{
lean_object* v___x_2737_; lean_object* v___x_2738_; lean_object* v___x_2739_; lean_object* v___x_2740_; lean_object* v___x_2741_; lean_object* v___x_2742_; 
lean_inc_ref(v_type_2710_);
v___x_2737_ = l_Lean_MessageData_ofExpr(v_type_2710_);
v___x_2738_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__1, &l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__1_once, _init_l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___closed__1);
v___x_2739_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2739_, 0, v___x_2737_);
lean_ctor_set(v___x_2739_, 1, v___x_2738_);
lean_inc_ref(v_type_2720_);
v___x_2740_ = l_Lean_MessageData_ofExpr(v_type_2720_);
v___x_2741_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2741_, 0, v___x_2739_);
lean_ctor_set(v___x_2741_, 1, v___x_2740_);
v___x_2742_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg(v___x_2734_, v___x_2741_, v___y_2679_, v___y_2680_, v___y_2681_, v___y_2682_);
if (lean_obj_tag(v___x_2742_) == 0)
{
lean_object* v_a_2743_; lean_object* v___x_2744_; 
v_a_2743_ = lean_ctor_get(v___x_2742_, 0);
lean_inc(v_a_2743_);
lean_dec_ref_known(v___x_2742_, 1);
v___x_2744_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___lam__2(v___f_2726_, v_type_2720_, v_a_2743_, v___y_2675_, v___y_2676_, v___y_2677_, v___y_2678_, v___y_2679_, v___y_2680_, v___y_2681_, v___y_2682_);
v___y_2685_ = v___x_2744_;
goto v___jp_2684_;
}
else
{
lean_object* v_a_2745_; lean_object* v___x_2747_; uint8_t v_isShared_2748_; uint8_t v_isSharedCheck_2752_; 
lean_dec_ref(v___f_2726_);
lean_dec_ref(v_type_2720_);
lean_dec(v_a_2673_);
lean_dec_ref(v___x_2672_);
lean_dec_ref(v_a_2671_);
v_a_2745_ = lean_ctor_get(v___x_2742_, 0);
v_isSharedCheck_2752_ = !lean_is_exclusive(v___x_2742_);
if (v_isSharedCheck_2752_ == 0)
{
v___x_2747_ = v___x_2742_;
v_isShared_2748_ = v_isSharedCheck_2752_;
goto v_resetjp_2746_;
}
else
{
lean_inc(v_a_2745_);
lean_dec(v___x_2742_);
v___x_2747_ = lean_box(0);
v_isShared_2748_ = v_isSharedCheck_2752_;
goto v_resetjp_2746_;
}
v_resetjp_2746_:
{
lean_object* v___x_2750_; 
if (v_isShared_2748_ == 0)
{
v___x_2750_ = v___x_2747_;
goto v_reusejp_2749_;
}
else
{
lean_object* v_reuseFailAlloc_2751_; 
v_reuseFailAlloc_2751_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2751_, 0, v_a_2745_);
v___x_2750_ = v_reuseFailAlloc_2751_;
goto v_reusejp_2749_;
}
v_reusejp_2749_:
{
return v___x_2750_;
}
}
}
}
}
}
}
else
{
lean_object* v___x_2756_; lean_object* v_goal_2757_; lean_object* v___x_2758_; 
lean_inc_ref(v_value_2721_);
lean_dec(v_a_2715_);
lean_dec(v_a_2673_);
lean_dec_ref(v___x_2672_);
lean_dec_ref(v_a_2671_);
v___x_2756_ = lean_st_ref_get(v___y_2676_);
v_goal_2757_ = lean_ctor_get(v___x_2756_, 3);
lean_inc(v_goal_2757_);
lean_dec(v___x_2756_);
v___x_2758_ = l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0___redArg(v_goal_2757_, v_value_2721_, v___y_2680_);
if (lean_obj_tag(v___x_2758_) == 0)
{
lean_object* v___x_2760_; uint8_t v_isShared_2761_; uint8_t v_isSharedCheck_2770_; 
v_isSharedCheck_2770_ = !lean_is_exclusive(v___x_2758_);
if (v_isSharedCheck_2770_ == 0)
{
lean_object* v_unused_2771_; 
v_unused_2771_ = lean_ctor_get(v___x_2758_, 0);
lean_dec(v_unused_2771_);
v___x_2760_ = v___x_2758_;
v_isShared_2761_ = v_isSharedCheck_2770_;
goto v_resetjp_2759_;
}
else
{
lean_dec(v___x_2758_);
v___x_2760_ = lean_box(0);
v_isShared_2761_ = v_isSharedCheck_2770_;
goto v_resetjp_2759_;
}
v_resetjp_2759_:
{
lean_object* v___x_2762_; lean_object* v___x_2763_; lean_object* v___x_2765_; 
v___x_2762_ = lean_box(v___x_2722_);
v___x_2763_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_2763_, 0, v___x_2762_);
if (v_isShared_2719_ == 0)
{
lean_ctor_set(v___x_2718_, 0, v___x_2763_);
v___x_2765_ = v___x_2718_;
goto v_reusejp_2764_;
}
else
{
lean_object* v_reuseFailAlloc_2769_; 
v_reuseFailAlloc_2769_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_2769_, 0, v___x_2763_);
lean_ctor_set(v_reuseFailAlloc_2769_, 1, v_snd_2716_);
v___x_2765_ = v_reuseFailAlloc_2769_;
goto v_reusejp_2764_;
}
v_reusejp_2764_:
{
lean_object* v___x_2767_; 
if (v_isShared_2761_ == 0)
{
lean_ctor_set(v___x_2760_, 0, v___x_2765_);
v___x_2767_ = v___x_2760_;
goto v_reusejp_2766_;
}
else
{
lean_object* v_reuseFailAlloc_2768_; 
v_reuseFailAlloc_2768_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2768_, 0, v___x_2765_);
v___x_2767_ = v_reuseFailAlloc_2768_;
goto v_reusejp_2766_;
}
v_reusejp_2766_:
{
return v___x_2767_;
}
}
}
}
else
{
lean_object* v_a_2772_; lean_object* v___x_2774_; uint8_t v_isShared_2775_; uint8_t v_isSharedCheck_2779_; 
lean_del_object(v___x_2718_);
lean_dec(v_snd_2716_);
v_a_2772_ = lean_ctor_get(v___x_2758_, 0);
v_isSharedCheck_2779_ = !lean_is_exclusive(v___x_2758_);
if (v_isSharedCheck_2779_ == 0)
{
v___x_2774_ = v___x_2758_;
v_isShared_2775_ = v_isSharedCheck_2779_;
goto v_resetjp_2773_;
}
else
{
lean_inc(v_a_2772_);
lean_dec(v___x_2758_);
v___x_2774_ = lean_box(0);
v_isShared_2775_ = v_isSharedCheck_2779_;
goto v_resetjp_2773_;
}
v_resetjp_2773_:
{
lean_object* v___x_2777_; 
if (v_isShared_2775_ == 0)
{
v___x_2777_ = v___x_2774_;
goto v_reusejp_2776_;
}
else
{
lean_object* v_reuseFailAlloc_2778_; 
v_reuseFailAlloc_2778_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2778_, 0, v_a_2772_);
v___x_2777_ = v_reuseFailAlloc_2778_;
goto v_reusejp_2776_;
}
v_reusejp_2776_:
{
return v___x_2777_;
}
}
}
}
}
}
else
{
lean_object* v_a_2782_; lean_object* v___x_2784_; uint8_t v_isShared_2785_; uint8_t v_isSharedCheck_2789_; 
lean_dec_ref(v_b_2674_);
lean_dec(v_a_2673_);
lean_dec_ref(v___x_2672_);
lean_dec_ref(v_a_2671_);
v_a_2782_ = lean_ctor_get(v___x_2714_, 0);
v_isSharedCheck_2789_ = !lean_is_exclusive(v___x_2714_);
if (v_isSharedCheck_2789_ == 0)
{
v___x_2784_ = v___x_2714_;
v_isShared_2785_ = v_isSharedCheck_2789_;
goto v_resetjp_2783_;
}
else
{
lean_inc(v_a_2782_);
lean_dec(v___x_2714_);
v___x_2784_ = lean_box(0);
v_isShared_2785_ = v_isSharedCheck_2789_;
goto v_resetjp_2783_;
}
v_resetjp_2783_:
{
lean_object* v___x_2787_; 
if (v_isShared_2785_ == 0)
{
v___x_2787_ = v___x_2784_;
goto v_reusejp_2786_;
}
else
{
lean_object* v_reuseFailAlloc_2788_; 
v_reuseFailAlloc_2788_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2788_, 0, v_a_2782_);
v___x_2787_ = v_reuseFailAlloc_2788_;
goto v_reusejp_2786_;
}
v_reusejp_2786_:
{
return v___x_2787_;
}
}
}
}
else
{
lean_object* v_a_2790_; lean_object* v___x_2792_; uint8_t v_isShared_2793_; uint8_t v_isSharedCheck_2797_; 
lean_dec_ref(v_b_2674_);
lean_dec(v_a_2673_);
lean_dec_ref(v___x_2672_);
lean_dec_ref(v_a_2671_);
v_a_2790_ = lean_ctor_get(v___x_2712_, 0);
v_isSharedCheck_2797_ = !lean_is_exclusive(v___x_2712_);
if (v_isSharedCheck_2797_ == 0)
{
v___x_2792_ = v___x_2712_;
v_isShared_2793_ = v_isSharedCheck_2797_;
goto v_resetjp_2791_;
}
else
{
lean_inc(v_a_2790_);
lean_dec(v___x_2712_);
v___x_2792_ = lean_box(0);
v_isShared_2793_ = v_isSharedCheck_2797_;
goto v_resetjp_2791_;
}
v_resetjp_2791_:
{
lean_object* v___x_2795_; 
if (v_isShared_2793_ == 0)
{
v___x_2795_ = v___x_2792_;
goto v_reusejp_2794_;
}
else
{
lean_object* v_reuseFailAlloc_2796_; 
v_reuseFailAlloc_2796_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2796_, 0, v_a_2790_);
v___x_2795_ = v_reuseFailAlloc_2796_;
goto v_reusejp_2794_;
}
v_reusejp_2794_:
{
return v___x_2795_;
}
}
}
}
v___jp_2684_:
{
if (lean_obj_tag(v___y_2685_) == 0)
{
lean_object* v_a_2686_; lean_object* v___x_2688_; uint8_t v_isShared_2689_; uint8_t v_isSharedCheck_2698_; 
v_a_2686_ = lean_ctor_get(v___y_2685_, 0);
v_isSharedCheck_2698_ = !lean_is_exclusive(v___y_2685_);
if (v_isSharedCheck_2698_ == 0)
{
v___x_2688_ = v___y_2685_;
v_isShared_2689_ = v_isSharedCheck_2698_;
goto v_resetjp_2687_;
}
else
{
lean_inc(v_a_2686_);
lean_dec(v___y_2685_);
v___x_2688_ = lean_box(0);
v_isShared_2689_ = v_isSharedCheck_2698_;
goto v_resetjp_2687_;
}
v_resetjp_2687_:
{
if (lean_obj_tag(v_a_2686_) == 0)
{
lean_object* v_a_2690_; lean_object* v___x_2692_; 
lean_dec(v_a_2673_);
lean_dec_ref(v___x_2672_);
lean_dec_ref(v_a_2671_);
v_a_2690_ = lean_ctor_get(v_a_2686_, 0);
lean_inc(v_a_2690_);
lean_dec_ref_known(v_a_2686_, 1);
if (v_isShared_2689_ == 0)
{
lean_ctor_set(v___x_2688_, 0, v_a_2690_);
v___x_2692_ = v___x_2688_;
goto v_reusejp_2691_;
}
else
{
lean_object* v_reuseFailAlloc_2693_; 
v_reuseFailAlloc_2693_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2693_, 0, v_a_2690_);
v___x_2692_ = v_reuseFailAlloc_2693_;
goto v_reusejp_2691_;
}
v_reusejp_2691_:
{
return v___x_2692_;
}
}
else
{
lean_object* v_a_2694_; lean_object* v___x_2695_; lean_object* v___x_2696_; 
lean_del_object(v___x_2688_);
v_a_2694_ = lean_ctor_get(v_a_2686_, 0);
lean_inc(v_a_2694_);
lean_dec_ref_known(v_a_2686_, 1);
v___x_2695_ = lean_unsigned_to_nat(1u);
v___x_2696_ = lean_nat_add(v_a_2673_, v___x_2695_);
lean_dec(v_a_2673_);
v_a_2673_ = v___x_2696_;
v_b_2674_ = v_a_2694_;
goto _start;
}
}
}
else
{
lean_object* v_a_2699_; lean_object* v___x_2701_; uint8_t v_isShared_2702_; uint8_t v_isSharedCheck_2706_; 
lean_dec(v_a_2673_);
lean_dec_ref(v___x_2672_);
lean_dec_ref(v_a_2671_);
v_a_2699_ = lean_ctor_get(v___y_2685_, 0);
v_isSharedCheck_2706_ = !lean_is_exclusive(v___y_2685_);
if (v_isSharedCheck_2706_ == 0)
{
v___x_2701_ = v___y_2685_;
v_isShared_2702_ = v_isSharedCheck_2706_;
goto v_resetjp_2700_;
}
else
{
lean_inc(v_a_2699_);
lean_dec(v___y_2685_);
v___x_2701_ = lean_box(0);
v_isShared_2702_ = v_isSharedCheck_2706_;
goto v_resetjp_2700_;
}
v_resetjp_2700_:
{
lean_object* v___x_2704_; 
if (v_isShared_2702_ == 0)
{
v___x_2704_ = v___x_2701_;
goto v_reusejp_2703_;
}
else
{
lean_object* v_reuseFailAlloc_2705_; 
v_reuseFailAlloc_2705_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2705_, 0, v_a_2699_);
v___x_2704_ = v_reuseFailAlloc_2705_;
goto v_reusejp_2703_;
}
v_reusejp_2703_:
{
return v___x_2704_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg___boxed(lean_object* v_upperBound_2798_, lean_object* v___x_2799_, lean_object* v_a_2800_, lean_object* v___x_2801_, lean_object* v_a_2802_, lean_object* v_b_2803_, lean_object* v___y_2804_, lean_object* v___y_2805_, lean_object* v___y_2806_, lean_object* v___y_2807_, lean_object* v___y_2808_, lean_object* v___y_2809_, lean_object* v___y_2810_, lean_object* v___y_2811_, lean_object* v___y_2812_){
_start:
{
lean_object* v_res_2813_; 
v_res_2813_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg(v_upperBound_2798_, v___x_2799_, v_a_2800_, v___x_2801_, v_a_2802_, v_b_2803_, v___y_2804_, v___y_2805_, v___y_2806_, v___y_2807_, v___y_2808_, v___y_2809_, v___y_2810_, v___y_2811_);
lean_dec(v___y_2811_);
lean_dec_ref(v___y_2810_);
lean_dec(v___y_2809_);
lean_dec_ref(v___y_2808_);
lean_dec(v___y_2807_);
lean_dec_ref(v___y_2806_);
lean_dec(v___y_2805_);
lean_dec_ref(v___y_2804_);
lean_dec_ref(v___x_2799_);
lean_dec(v_upperBound_2798_);
return v_res_2813_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__1(lean_object* v_methods_2814_, lean_object* v___y_2815_, lean_object* v___y_2816_, lean_object* v___y_2817_, lean_object* v___y_2818_, lean_object* v___y_2819_, lean_object* v___y_2820_, lean_object* v___y_2821_, lean_object* v___y_2822_){
_start:
{
lean_object* v___x_2824_; 
v___x_2824_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas(v_methods_2814_, v___y_2815_, v___y_2816_, v___y_2817_, v___y_2818_, v___y_2819_, v___y_2820_, v___y_2821_, v___y_2822_);
if (lean_obj_tag(v___x_2824_) == 0)
{
lean_object* v_a_2825_; lean_object* v___x_2826_; 
v_a_2825_ = lean_ctor_get(v___x_2824_, 0);
lean_inc(v_a_2825_);
lean_dec_ref_known(v___x_2824_, 1);
v___x_2826_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addDefaultTypeAnalysisLemmas(v_a_2825_, v___y_2815_, v___y_2816_, v___y_2817_, v___y_2818_, v___y_2819_, v___y_2820_, v___y_2821_, v___y_2822_);
if (lean_obj_tag(v___x_2826_) == 0)
{
lean_object* v_a_2827_; lean_object* v___x_2828_; lean_object* v_hypotheses_2829_; lean_object* v_maxSteps_2830_; lean_object* v___x_2831_; lean_object* v_newHyps_2832_; lean_object* v___x_2833_; lean_object* v___x_2834_; lean_object* v___x_2835_; lean_object* v___x_2836_; lean_object* v___x_2837_; lean_object* v___x_2838_; 
v_a_2827_ = lean_ctor_get(v___x_2826_, 0);
lean_inc(v_a_2827_);
lean_dec_ref_known(v___x_2826_, 1);
v___x_2828_ = lean_st_ref_get(v___y_2816_);
v_hypotheses_2829_ = lean_ctor_get(v___x_2828_, 4);
lean_inc_ref(v_hypotheses_2829_);
lean_dec(v___x_2828_);
v_maxSteps_2830_ = lean_ctor_get(v___y_2815_, 1);
v___x_2831_ = lean_array_get_size(v_hypotheses_2829_);
v_newHyps_2832_ = lean_mk_empty_array_with_capacity(v___x_2831_);
v___x_2833_ = lean_unsigned_to_nat(0u);
v___x_2834_ = lean_unsigned_to_nat(2u);
lean_inc(v_maxSteps_2830_);
v___x_2835_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2835_, 0, v_maxSteps_2830_);
lean_ctor_set(v___x_2835_, 1, v___x_2834_);
v___x_2836_ = lean_box(0);
v___x_2837_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2837_, 0, v___x_2836_);
lean_ctor_set(v___x_2837_, 1, v_newHyps_2832_);
v___x_2838_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg(v___x_2831_, v_hypotheses_2829_, v_a_2827_, v___x_2835_, v___x_2833_, v___x_2837_, v___y_2815_, v___y_2816_, v___y_2817_, v___y_2818_, v___y_2819_, v___y_2820_, v___y_2821_, v___y_2822_);
lean_dec_ref(v_hypotheses_2829_);
if (lean_obj_tag(v___x_2838_) == 0)
{
lean_object* v_a_2839_; lean_object* v___x_2841_; uint8_t v_isShared_2842_; uint8_t v_isSharedCheck_2869_; 
v_a_2839_ = lean_ctor_get(v___x_2838_, 0);
v_isSharedCheck_2869_ = !lean_is_exclusive(v___x_2838_);
if (v_isSharedCheck_2869_ == 0)
{
v___x_2841_ = v___x_2838_;
v_isShared_2842_ = v_isSharedCheck_2869_;
goto v_resetjp_2840_;
}
else
{
lean_inc(v_a_2839_);
lean_dec(v___x_2838_);
v___x_2841_ = lean_box(0);
v_isShared_2842_ = v_isSharedCheck_2869_;
goto v_resetjp_2840_;
}
v_resetjp_2840_:
{
lean_object* v_fst_2843_; 
v_fst_2843_ = lean_ctor_get(v_a_2839_, 0);
if (lean_obj_tag(v_fst_2843_) == 0)
{
lean_object* v_snd_2844_; lean_object* v___x_2845_; lean_object* v_rewriteCache_2846_; lean_object* v_acNfCache_2847_; lean_object* v_typeAnalysis_2848_; lean_object* v_goal_2849_; uint8_t v_didChange_2850_; lean_object* v___x_2852_; uint8_t v_isShared_2853_; uint8_t v_isSharedCheck_2863_; 
v_snd_2844_ = lean_ctor_get(v_a_2839_, 1);
lean_inc(v_snd_2844_);
lean_dec(v_a_2839_);
v___x_2845_ = lean_st_ref_take(v___y_2816_);
v_rewriteCache_2846_ = lean_ctor_get(v___x_2845_, 0);
v_acNfCache_2847_ = lean_ctor_get(v___x_2845_, 1);
v_typeAnalysis_2848_ = lean_ctor_get(v___x_2845_, 2);
v_goal_2849_ = lean_ctor_get(v___x_2845_, 3);
v_didChange_2850_ = lean_ctor_get_uint8(v___x_2845_, sizeof(void*)*5);
v_isSharedCheck_2863_ = !lean_is_exclusive(v___x_2845_);
if (v_isSharedCheck_2863_ == 0)
{
lean_object* v_unused_2864_; 
v_unused_2864_ = lean_ctor_get(v___x_2845_, 4);
lean_dec(v_unused_2864_);
v___x_2852_ = v___x_2845_;
v_isShared_2853_ = v_isSharedCheck_2863_;
goto v_resetjp_2851_;
}
else
{
lean_inc(v_goal_2849_);
lean_inc(v_typeAnalysis_2848_);
lean_inc(v_acNfCache_2847_);
lean_inc(v_rewriteCache_2846_);
lean_dec(v___x_2845_);
v___x_2852_ = lean_box(0);
v_isShared_2853_ = v_isSharedCheck_2863_;
goto v_resetjp_2851_;
}
v_resetjp_2851_:
{
lean_object* v___x_2855_; 
if (v_isShared_2853_ == 0)
{
lean_ctor_set(v___x_2852_, 4, v_snd_2844_);
v___x_2855_ = v___x_2852_;
goto v_reusejp_2854_;
}
else
{
lean_object* v_reuseFailAlloc_2862_; 
v_reuseFailAlloc_2862_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_2862_, 0, v_rewriteCache_2846_);
lean_ctor_set(v_reuseFailAlloc_2862_, 1, v_acNfCache_2847_);
lean_ctor_set(v_reuseFailAlloc_2862_, 2, v_typeAnalysis_2848_);
lean_ctor_set(v_reuseFailAlloc_2862_, 3, v_goal_2849_);
lean_ctor_set(v_reuseFailAlloc_2862_, 4, v_snd_2844_);
lean_ctor_set_uint8(v_reuseFailAlloc_2862_, sizeof(void*)*5, v_didChange_2850_);
v___x_2855_ = v_reuseFailAlloc_2862_;
goto v_reusejp_2854_;
}
v_reusejp_2854_:
{
lean_object* v___x_2856_; uint8_t v___x_2857_; lean_object* v___x_2858_; lean_object* v___x_2860_; 
v___x_2856_ = lean_st_ref_set(v___y_2816_, v___x_2855_);
v___x_2857_ = 0;
v___x_2858_ = lean_box(v___x_2857_);
if (v_isShared_2842_ == 0)
{
lean_ctor_set(v___x_2841_, 0, v___x_2858_);
v___x_2860_ = v___x_2841_;
goto v_reusejp_2859_;
}
else
{
lean_object* v_reuseFailAlloc_2861_; 
v_reuseFailAlloc_2861_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2861_, 0, v___x_2858_);
v___x_2860_ = v_reuseFailAlloc_2861_;
goto v_reusejp_2859_;
}
v_reusejp_2859_:
{
return v___x_2860_;
}
}
}
}
else
{
lean_object* v_val_2865_; lean_object* v___x_2867_; 
lean_inc_ref(v_fst_2843_);
lean_dec(v_a_2839_);
v_val_2865_ = lean_ctor_get(v_fst_2843_, 0);
lean_inc(v_val_2865_);
lean_dec_ref_known(v_fst_2843_, 1);
if (v_isShared_2842_ == 0)
{
lean_ctor_set(v___x_2841_, 0, v_val_2865_);
v___x_2867_ = v___x_2841_;
goto v_reusejp_2866_;
}
else
{
lean_object* v_reuseFailAlloc_2868_; 
v_reuseFailAlloc_2868_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2868_, 0, v_val_2865_);
v___x_2867_ = v_reuseFailAlloc_2868_;
goto v_reusejp_2866_;
}
v_reusejp_2866_:
{
return v___x_2867_;
}
}
}
}
else
{
lean_object* v_a_2870_; lean_object* v___x_2872_; uint8_t v_isShared_2873_; uint8_t v_isSharedCheck_2877_; 
v_a_2870_ = lean_ctor_get(v___x_2838_, 0);
v_isSharedCheck_2877_ = !lean_is_exclusive(v___x_2838_);
if (v_isSharedCheck_2877_ == 0)
{
v___x_2872_ = v___x_2838_;
v_isShared_2873_ = v_isSharedCheck_2877_;
goto v_resetjp_2871_;
}
else
{
lean_inc(v_a_2870_);
lean_dec(v___x_2838_);
v___x_2872_ = lean_box(0);
v_isShared_2873_ = v_isSharedCheck_2877_;
goto v_resetjp_2871_;
}
v_resetjp_2871_:
{
lean_object* v___x_2875_; 
if (v_isShared_2873_ == 0)
{
v___x_2875_ = v___x_2872_;
goto v_reusejp_2874_;
}
else
{
lean_object* v_reuseFailAlloc_2876_; 
v_reuseFailAlloc_2876_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2876_, 0, v_a_2870_);
v___x_2875_ = v_reuseFailAlloc_2876_;
goto v_reusejp_2874_;
}
v_reusejp_2874_:
{
return v___x_2875_;
}
}
}
}
else
{
lean_object* v_a_2878_; lean_object* v___x_2880_; uint8_t v_isShared_2881_; uint8_t v_isSharedCheck_2885_; 
v_a_2878_ = lean_ctor_get(v___x_2826_, 0);
v_isSharedCheck_2885_ = !lean_is_exclusive(v___x_2826_);
if (v_isSharedCheck_2885_ == 0)
{
v___x_2880_ = v___x_2826_;
v_isShared_2881_ = v_isSharedCheck_2885_;
goto v_resetjp_2879_;
}
else
{
lean_inc(v_a_2878_);
lean_dec(v___x_2826_);
v___x_2880_ = lean_box(0);
v_isShared_2881_ = v_isSharedCheck_2885_;
goto v_resetjp_2879_;
}
v_resetjp_2879_:
{
lean_object* v___x_2883_; 
if (v_isShared_2881_ == 0)
{
v___x_2883_ = v___x_2880_;
goto v_reusejp_2882_;
}
else
{
lean_object* v_reuseFailAlloc_2884_; 
v_reuseFailAlloc_2884_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2884_, 0, v_a_2878_);
v___x_2883_ = v_reuseFailAlloc_2884_;
goto v_reusejp_2882_;
}
v_reusejp_2882_:
{
return v___x_2883_;
}
}
}
}
else
{
lean_object* v_a_2886_; lean_object* v___x_2888_; uint8_t v_isShared_2889_; uint8_t v_isSharedCheck_2893_; 
v_a_2886_ = lean_ctor_get(v___x_2824_, 0);
v_isSharedCheck_2893_ = !lean_is_exclusive(v___x_2824_);
if (v_isSharedCheck_2893_ == 0)
{
v___x_2888_ = v___x_2824_;
v_isShared_2889_ = v_isSharedCheck_2893_;
goto v_resetjp_2887_;
}
else
{
lean_inc(v_a_2886_);
lean_dec(v___x_2824_);
v___x_2888_ = lean_box(0);
v_isShared_2889_ = v_isSharedCheck_2893_;
goto v_resetjp_2887_;
}
v_resetjp_2887_:
{
lean_object* v___x_2891_; 
if (v_isShared_2889_ == 0)
{
v___x_2891_ = v___x_2888_;
goto v_reusejp_2890_;
}
else
{
lean_object* v_reuseFailAlloc_2892_; 
v_reuseFailAlloc_2892_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2892_, 0, v_a_2886_);
v___x_2891_ = v_reuseFailAlloc_2892_;
goto v_reusejp_2890_;
}
v_reusejp_2890_:
{
return v___x_2891_;
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__1___boxed(lean_object* v_methods_2894_, lean_object* v___y_2895_, lean_object* v___y_2896_, lean_object* v___y_2897_, lean_object* v___y_2898_, lean_object* v___y_2899_, lean_object* v___y_2900_, lean_object* v___y_2901_, lean_object* v___y_2902_, lean_object* v___y_2903_){
_start:
{
lean_object* v_res_2904_; 
v_res_2904_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___lam__1(v_methods_2894_, v___y_2895_, v___y_2896_, v___y_2897_, v___y_2898_, v___y_2899_, v___y_2900_, v___y_2901_, v___y_2902_);
lean_dec(v___y_2902_);
lean_dec_ref(v___y_2901_);
lean_dec(v___y_2900_);
lean_dec_ref(v___y_2899_);
lean_dec(v___y_2898_);
lean_dec_ref(v___y_2897_);
lean_dec(v___y_2896_);
lean_dec_ref(v___y_2895_);
return v_res_2904_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess(lean_object* v_goal_2910_, lean_object* v_a_2911_, lean_object* v_a_2912_, lean_object* v_a_2913_, lean_object* v_a_2914_, lean_object* v_a_2915_, lean_object* v_a_2916_, lean_object* v_a_2917_, lean_object* v_a_2918_){
_start:
{
lean_object* v___f_2920_; lean_object* v___x_2921_; 
v___f_2920_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___closed__2));
v___x_2921_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg(v_goal_2910_, v___f_2920_, v_a_2911_, v_a_2912_, v_a_2913_, v_a_2914_, v_a_2915_, v_a_2916_, v_a_2917_, v_a_2918_);
return v___x_2921_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess___boxed(lean_object* v_goal_2922_, lean_object* v_a_2923_, lean_object* v_a_2924_, lean_object* v_a_2925_, lean_object* v_a_2926_, lean_object* v_a_2927_, lean_object* v_a_2928_, lean_object* v_a_2929_, lean_object* v_a_2930_, lean_object* v_a_2931_){
_start:
{
lean_object* v_res_2932_; 
v_res_2932_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess(v_goal_2922_, v_a_2923_, v_a_2924_, v_a_2925_, v_a_2926_, v_a_2927_, v_a_2928_, v_a_2929_, v_a_2930_);
lean_dec(v_a_2930_);
lean_dec_ref(v_a_2929_);
lean_dec(v_a_2928_);
lean_dec_ref(v_a_2927_);
lean_dec(v_a_2926_);
lean_dec_ref(v_a_2925_);
lean_dec(v_a_2924_);
lean_dec_ref(v_a_2923_);
return v_res_2932_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0(lean_object* v_mvarId_2933_, lean_object* v_val_2934_, lean_object* v___y_2935_, lean_object* v___y_2936_, lean_object* v___y_2937_, lean_object* v___y_2938_, lean_object* v___y_2939_, lean_object* v___y_2940_, lean_object* v___y_2941_, lean_object* v___y_2942_){
_start:
{
lean_object* v___x_2944_; 
v___x_2944_ = l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0___redArg(v_mvarId_2933_, v_val_2934_, v___y_2940_);
return v___x_2944_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0___boxed(lean_object* v_mvarId_2945_, lean_object* v_val_2946_, lean_object* v___y_2947_, lean_object* v___y_2948_, lean_object* v___y_2949_, lean_object* v___y_2950_, lean_object* v___y_2951_, lean_object* v___y_2952_, lean_object* v___y_2953_, lean_object* v___y_2954_, lean_object* v___y_2955_){
_start:
{
lean_object* v_res_2956_; 
v_res_2956_ = l_Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0(v_mvarId_2945_, v_val_2946_, v___y_2947_, v___y_2948_, v___y_2949_, v___y_2950_, v___y_2951_, v___y_2952_, v___y_2953_, v___y_2954_);
lean_dec(v___y_2954_);
lean_dec_ref(v___y_2953_);
lean_dec(v___y_2952_);
lean_dec_ref(v___y_2951_);
lean_dec(v___y_2950_);
lean_dec_ref(v___y_2949_);
lean_dec(v___y_2948_);
lean_dec_ref(v___y_2947_);
return v_res_2956_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1(lean_object* v_upperBound_2957_, lean_object* v___x_2958_, lean_object* v_a_2959_, lean_object* v___x_2960_, lean_object* v_inst_2961_, lean_object* v_R_2962_, lean_object* v_a_2963_, lean_object* v_b_2964_, lean_object* v_c_2965_, lean_object* v___y_2966_, lean_object* v___y_2967_, lean_object* v___y_2968_, lean_object* v___y_2969_, lean_object* v___y_2970_, lean_object* v___y_2971_, lean_object* v___y_2972_, lean_object* v___y_2973_){
_start:
{
lean_object* v___x_2975_; 
v___x_2975_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___redArg(v_upperBound_2957_, v___x_2958_, v_a_2959_, v___x_2960_, v_a_2963_, v_b_2964_, v___y_2966_, v___y_2967_, v___y_2968_, v___y_2969_, v___y_2970_, v___y_2971_, v___y_2972_, v___y_2973_);
return v___x_2975_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1___boxed(lean_object** _args){
lean_object* v_upperBound_2976_ = _args[0];
lean_object* v___x_2977_ = _args[1];
lean_object* v_a_2978_ = _args[2];
lean_object* v___x_2979_ = _args[3];
lean_object* v_inst_2980_ = _args[4];
lean_object* v_R_2981_ = _args[5];
lean_object* v_a_2982_ = _args[6];
lean_object* v_b_2983_ = _args[7];
lean_object* v_c_2984_ = _args[8];
lean_object* v___y_2985_ = _args[9];
lean_object* v___y_2986_ = _args[10];
lean_object* v___y_2987_ = _args[11];
lean_object* v___y_2988_ = _args[12];
lean_object* v___y_2989_ = _args[13];
lean_object* v___y_2990_ = _args[14];
lean_object* v___y_2991_ = _args[15];
lean_object* v___y_2992_ = _args[16];
lean_object* v___y_2993_ = _args[17];
_start:
{
lean_object* v_res_2994_; 
v_res_2994_ = l_WellFounded_opaqueFix_u2083___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__1(v_upperBound_2976_, v___x_2977_, v_a_2978_, v___x_2979_, v_inst_2980_, v_R_2981_, v_a_2982_, v_b_2983_, v_c_2984_, v___y_2985_, v___y_2986_, v___y_2987_, v___y_2988_, v___y_2989_, v___y_2990_, v___y_2991_, v___y_2992_);
lean_dec(v___y_2992_);
lean_dec_ref(v___y_2991_);
lean_dec(v___y_2990_);
lean_dec_ref(v___y_2989_);
lean_dec(v___y_2988_);
lean_dec_ref(v___y_2987_);
lean_dec(v___y_2986_);
lean_dec_ref(v___y_2985_);
lean_dec_ref(v___x_2977_);
lean_dec(v_upperBound_2976_);
return v_res_2994_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0(lean_object* v_00_u03b2_2995_, lean_object* v_x_2996_, lean_object* v_x_2997_, lean_object* v_x_2998_){
_start:
{
lean_object* v___x_2999_; 
v___x_2999_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0___redArg(v_x_2996_, v_x_2997_, v_x_2998_);
return v___x_2999_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2(lean_object* v_00_u03b2_3000_, lean_object* v_x_3001_, size_t v_x_3002_, size_t v_x_3003_, lean_object* v_x_3004_, lean_object* v_x_3005_){
_start:
{
lean_object* v___x_3006_; 
v___x_3006_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___redArg(v_x_3001_, v_x_3002_, v_x_3003_, v_x_3004_, v_x_3005_);
return v___x_3006_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2___boxed(lean_object* v_00_u03b2_3007_, lean_object* v_x_3008_, lean_object* v_x_3009_, lean_object* v_x_3010_, lean_object* v_x_3011_, lean_object* v_x_3012_){
_start:
{
size_t v_x_30108__boxed_3013_; size_t v_x_30109__boxed_3014_; lean_object* v_res_3015_; 
v_x_30108__boxed_3013_ = lean_unbox_usize(v_x_3009_);
lean_dec(v_x_3009_);
v_x_30109__boxed_3014_ = lean_unbox_usize(v_x_3010_);
lean_dec(v_x_3010_);
v_res_3015_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2(v_00_u03b2_3007_, v_x_3008_, v_x_30108__boxed_3013_, v_x_30109__boxed_3014_, v_x_3011_, v_x_3012_);
return v_res_3015_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4(lean_object* v_00_u03b2_3016_, lean_object* v_n_3017_, lean_object* v_k_3018_, lean_object* v_v_3019_){
_start:
{
lean_object* v___x_3020_; 
v___x_3020_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4___redArg(v_n_3017_, v_k_3018_, v_v_3019_);
return v___x_3020_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5(lean_object* v_00_u03b2_3021_, size_t v_depth_3022_, lean_object* v_keys_3023_, lean_object* v_vals_3024_, lean_object* v_heq_3025_, lean_object* v_i_3026_, lean_object* v_entries_3027_){
_start:
{
lean_object* v___x_3028_; 
v___x_3028_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5___redArg(v_depth_3022_, v_keys_3023_, v_vals_3024_, v_i_3026_, v_entries_3027_);
return v___x_3028_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5___boxed(lean_object* v_00_u03b2_3029_, lean_object* v_depth_3030_, lean_object* v_keys_3031_, lean_object* v_vals_3032_, lean_object* v_heq_3033_, lean_object* v_i_3034_, lean_object* v_entries_3035_){
_start:
{
size_t v_depth_boxed_3036_; lean_object* v_res_3037_; 
v_depth_boxed_3036_ = lean_unbox_usize(v_depth_3030_);
lean_dec(v_depth_3030_);
v_res_3037_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__5(v_00_u03b2_3029_, v_depth_boxed_3036_, v_keys_3031_, v_vals_3032_, v_heq_3033_, v_i_3034_, v_entries_3035_);
lean_dec_ref(v_vals_3032_);
lean_dec_ref(v_keys_3031_);
return v_res_3037_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4_spec__5(lean_object* v_00_u03b2_3038_, lean_object* v_x_3039_, lean_object* v_x_3040_, lean_object* v_x_3041_, lean_object* v_x_3042_){
_start:
{
lean_object* v___x_3043_; 
v___x_3043_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__0_spec__0_spec__2_spec__4_spec__5___redArg(v_x_3039_, v_x_3040_, v_x_3041_, v_x_3042_);
return v___x_3043_;
}
}
static lean_object* _init_l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__0(void){
_start:
{
lean_object* v___x_3044_; 
v___x_3044_ = l_instMonadEIO(lean_box(0));
return v___x_3044_;
}
}
LEAN_EXPORT lean_object* l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4(lean_object* v_msg_3049_, lean_object* v___y_3050_, lean_object* v___y_3051_, lean_object* v___y_3052_, lean_object* v___y_3053_, lean_object* v___y_3054_, lean_object* v___y_3055_, lean_object* v___y_3056_, lean_object* v___y_3057_){
_start:
{
lean_object* v___x_3059_; lean_object* v___x_3060_; lean_object* v_toApplicative_3061_; lean_object* v___x_3063_; uint8_t v_isShared_3064_; uint8_t v_isSharedCheck_3126_; 
v___x_3059_ = lean_obj_once(&l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__0, &l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__0_once, _init_l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__0);
v___x_3060_ = l_StateRefT_x27_instMonad___redArg(v___x_3059_);
v_toApplicative_3061_ = lean_ctor_get(v___x_3060_, 0);
v_isSharedCheck_3126_ = !lean_is_exclusive(v___x_3060_);
if (v_isSharedCheck_3126_ == 0)
{
lean_object* v_unused_3127_; 
v_unused_3127_ = lean_ctor_get(v___x_3060_, 1);
lean_dec(v_unused_3127_);
v___x_3063_ = v___x_3060_;
v_isShared_3064_ = v_isSharedCheck_3126_;
goto v_resetjp_3062_;
}
else
{
lean_inc(v_toApplicative_3061_);
lean_dec(v___x_3060_);
v___x_3063_ = lean_box(0);
v_isShared_3064_ = v_isSharedCheck_3126_;
goto v_resetjp_3062_;
}
v_resetjp_3062_:
{
lean_object* v_toFunctor_3065_; lean_object* v_toSeq_3066_; lean_object* v_toSeqLeft_3067_; lean_object* v_toSeqRight_3068_; lean_object* v___x_3070_; uint8_t v_isShared_3071_; uint8_t v_isSharedCheck_3124_; 
v_toFunctor_3065_ = lean_ctor_get(v_toApplicative_3061_, 0);
v_toSeq_3066_ = lean_ctor_get(v_toApplicative_3061_, 2);
v_toSeqLeft_3067_ = lean_ctor_get(v_toApplicative_3061_, 3);
v_toSeqRight_3068_ = lean_ctor_get(v_toApplicative_3061_, 4);
v_isSharedCheck_3124_ = !lean_is_exclusive(v_toApplicative_3061_);
if (v_isSharedCheck_3124_ == 0)
{
lean_object* v_unused_3125_; 
v_unused_3125_ = lean_ctor_get(v_toApplicative_3061_, 1);
lean_dec(v_unused_3125_);
v___x_3070_ = v_toApplicative_3061_;
v_isShared_3071_ = v_isSharedCheck_3124_;
goto v_resetjp_3069_;
}
else
{
lean_inc(v_toSeqRight_3068_);
lean_inc(v_toSeqLeft_3067_);
lean_inc(v_toSeq_3066_);
lean_inc(v_toFunctor_3065_);
lean_dec(v_toApplicative_3061_);
v___x_3070_ = lean_box(0);
v_isShared_3071_ = v_isSharedCheck_3124_;
goto v_resetjp_3069_;
}
v_resetjp_3069_:
{
lean_object* v___f_3072_; lean_object* v___f_3073_; lean_object* v___f_3074_; lean_object* v___f_3075_; lean_object* v___x_3076_; lean_object* v___f_3077_; lean_object* v___f_3078_; lean_object* v___f_3079_; lean_object* v___x_3081_; 
v___f_3072_ = ((lean_object*)(l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__1));
v___f_3073_ = ((lean_object*)(l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__2));
lean_inc_ref(v_toFunctor_3065_);
v___f_3074_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_3074_, 0, v_toFunctor_3065_);
v___f_3075_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_3075_, 0, v_toFunctor_3065_);
v___x_3076_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3076_, 0, v___f_3074_);
lean_ctor_set(v___x_3076_, 1, v___f_3075_);
v___f_3077_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_3077_, 0, v_toSeqRight_3068_);
v___f_3078_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_3078_, 0, v_toSeqLeft_3067_);
v___f_3079_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_3079_, 0, v_toSeq_3066_);
if (v_isShared_3071_ == 0)
{
lean_ctor_set(v___x_3070_, 4, v___f_3077_);
lean_ctor_set(v___x_3070_, 3, v___f_3078_);
lean_ctor_set(v___x_3070_, 2, v___f_3079_);
lean_ctor_set(v___x_3070_, 1, v___f_3072_);
lean_ctor_set(v___x_3070_, 0, v___x_3076_);
v___x_3081_ = v___x_3070_;
goto v_reusejp_3080_;
}
else
{
lean_object* v_reuseFailAlloc_3123_; 
v_reuseFailAlloc_3123_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_3123_, 0, v___x_3076_);
lean_ctor_set(v_reuseFailAlloc_3123_, 1, v___f_3072_);
lean_ctor_set(v_reuseFailAlloc_3123_, 2, v___f_3079_);
lean_ctor_set(v_reuseFailAlloc_3123_, 3, v___f_3078_);
lean_ctor_set(v_reuseFailAlloc_3123_, 4, v___f_3077_);
v___x_3081_ = v_reuseFailAlloc_3123_;
goto v_reusejp_3080_;
}
v_reusejp_3080_:
{
lean_object* v___x_3083_; 
if (v_isShared_3064_ == 0)
{
lean_ctor_set(v___x_3063_, 1, v___f_3073_);
lean_ctor_set(v___x_3063_, 0, v___x_3081_);
v___x_3083_ = v___x_3063_;
goto v_reusejp_3082_;
}
else
{
lean_object* v_reuseFailAlloc_3122_; 
v_reuseFailAlloc_3122_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3122_, 0, v___x_3081_);
lean_ctor_set(v_reuseFailAlloc_3122_, 1, v___f_3073_);
v___x_3083_ = v_reuseFailAlloc_3122_;
goto v_reusejp_3082_;
}
v_reusejp_3082_:
{
lean_object* v___x_3084_; lean_object* v_toApplicative_3085_; lean_object* v___x_3087_; uint8_t v_isShared_3088_; uint8_t v_isSharedCheck_3120_; 
v___x_3084_ = l_StateRefT_x27_instMonad___redArg(v___x_3083_);
v_toApplicative_3085_ = lean_ctor_get(v___x_3084_, 0);
v_isSharedCheck_3120_ = !lean_is_exclusive(v___x_3084_);
if (v_isSharedCheck_3120_ == 0)
{
lean_object* v_unused_3121_; 
v_unused_3121_ = lean_ctor_get(v___x_3084_, 1);
lean_dec(v_unused_3121_);
v___x_3087_ = v___x_3084_;
v_isShared_3088_ = v_isSharedCheck_3120_;
goto v_resetjp_3086_;
}
else
{
lean_inc(v_toApplicative_3085_);
lean_dec(v___x_3084_);
v___x_3087_ = lean_box(0);
v_isShared_3088_ = v_isSharedCheck_3120_;
goto v_resetjp_3086_;
}
v_resetjp_3086_:
{
lean_object* v_toFunctor_3089_; lean_object* v_toSeq_3090_; lean_object* v_toSeqLeft_3091_; lean_object* v_toSeqRight_3092_; lean_object* v___x_3094_; uint8_t v_isShared_3095_; uint8_t v_isSharedCheck_3118_; 
v_toFunctor_3089_ = lean_ctor_get(v_toApplicative_3085_, 0);
v_toSeq_3090_ = lean_ctor_get(v_toApplicative_3085_, 2);
v_toSeqLeft_3091_ = lean_ctor_get(v_toApplicative_3085_, 3);
v_toSeqRight_3092_ = lean_ctor_get(v_toApplicative_3085_, 4);
v_isSharedCheck_3118_ = !lean_is_exclusive(v_toApplicative_3085_);
if (v_isSharedCheck_3118_ == 0)
{
lean_object* v_unused_3119_; 
v_unused_3119_ = lean_ctor_get(v_toApplicative_3085_, 1);
lean_dec(v_unused_3119_);
v___x_3094_ = v_toApplicative_3085_;
v_isShared_3095_ = v_isSharedCheck_3118_;
goto v_resetjp_3093_;
}
else
{
lean_inc(v_toSeqRight_3092_);
lean_inc(v_toSeqLeft_3091_);
lean_inc(v_toSeq_3090_);
lean_inc(v_toFunctor_3089_);
lean_dec(v_toApplicative_3085_);
v___x_3094_ = lean_box(0);
v_isShared_3095_ = v_isSharedCheck_3118_;
goto v_resetjp_3093_;
}
v_resetjp_3093_:
{
lean_object* v___f_3096_; lean_object* v___f_3097_; lean_object* v___f_3098_; lean_object* v___f_3099_; lean_object* v___x_3100_; lean_object* v___f_3101_; lean_object* v___f_3102_; lean_object* v___f_3103_; lean_object* v___x_3105_; 
v___f_3096_ = ((lean_object*)(l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__3));
v___f_3097_ = ((lean_object*)(l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___closed__4));
lean_inc_ref(v_toFunctor_3089_);
v___f_3098_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_3098_, 0, v_toFunctor_3089_);
v___f_3099_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_3099_, 0, v_toFunctor_3089_);
v___x_3100_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3100_, 0, v___f_3098_);
lean_ctor_set(v___x_3100_, 1, v___f_3099_);
v___f_3101_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_3101_, 0, v_toSeqRight_3092_);
v___f_3102_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_3102_, 0, v_toSeqLeft_3091_);
v___f_3103_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_3103_, 0, v_toSeq_3090_);
if (v_isShared_3095_ == 0)
{
lean_ctor_set(v___x_3094_, 4, v___f_3101_);
lean_ctor_set(v___x_3094_, 3, v___f_3102_);
lean_ctor_set(v___x_3094_, 2, v___f_3103_);
lean_ctor_set(v___x_3094_, 1, v___f_3096_);
lean_ctor_set(v___x_3094_, 0, v___x_3100_);
v___x_3105_ = v___x_3094_;
goto v_reusejp_3104_;
}
else
{
lean_object* v_reuseFailAlloc_3117_; 
v_reuseFailAlloc_3117_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_3117_, 0, v___x_3100_);
lean_ctor_set(v_reuseFailAlloc_3117_, 1, v___f_3096_);
lean_ctor_set(v_reuseFailAlloc_3117_, 2, v___f_3103_);
lean_ctor_set(v_reuseFailAlloc_3117_, 3, v___f_3102_);
lean_ctor_set(v_reuseFailAlloc_3117_, 4, v___f_3101_);
v___x_3105_ = v_reuseFailAlloc_3117_;
goto v_reusejp_3104_;
}
v_reusejp_3104_:
{
lean_object* v___x_3107_; 
if (v_isShared_3088_ == 0)
{
lean_ctor_set(v___x_3087_, 1, v___f_3097_);
lean_ctor_set(v___x_3087_, 0, v___x_3105_);
v___x_3107_ = v___x_3087_;
goto v_reusejp_3106_;
}
else
{
lean_object* v_reuseFailAlloc_3116_; 
v_reuseFailAlloc_3116_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3116_, 0, v___x_3105_);
lean_ctor_set(v_reuseFailAlloc_3116_, 1, v___f_3097_);
v___x_3107_ = v_reuseFailAlloc_3116_;
goto v_reusejp_3106_;
}
v_reusejp_3106_:
{
lean_object* v___x_3108_; lean_object* v___x_3109_; lean_object* v___x_3110_; lean_object* v___x_3111_; lean_object* v___x_3112_; lean_object* v___x_3113_; lean_object* v___x_63967__overap_3114_; lean_object* v___x_3115_; 
v___x_3108_ = l_StateRefT_x27_instMonad___redArg(v___x_3107_);
v___x_3109_ = l_ReaderT_instMonad___redArg(v___x_3108_);
v___x_3110_ = l_StateRefT_x27_instMonad___redArg(v___x_3109_);
v___x_3111_ = l_ReaderT_instMonad___redArg(v___x_3110_);
v___x_3112_ = lean_box(0);
v___x_3113_ = l_instInhabitedOfMonad___redArg(v___x_3111_, v___x_3112_);
v___x_63967__overap_3114_ = lean_panic_fn_borrowed(v___x_3113_, v_msg_3049_);
lean_dec(v___x_3113_);
lean_inc(v___y_3057_);
lean_inc_ref(v___y_3056_);
lean_inc(v___y_3055_);
lean_inc_ref(v___y_3054_);
lean_inc(v___y_3053_);
lean_inc_ref(v___y_3052_);
lean_inc(v___y_3051_);
lean_inc_ref(v___y_3050_);
v___x_3115_ = lean_apply_9(v___x_63967__overap_3114_, v___y_3050_, v___y_3051_, v___y_3052_, v___y_3053_, v___y_3054_, v___y_3055_, v___y_3056_, v___y_3057_, lean_box(0));
return v___x_3115_;
}
}
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4___boxed(lean_object* v_msg_3128_, lean_object* v___y_3129_, lean_object* v___y_3130_, lean_object* v___y_3131_, lean_object* v___y_3132_, lean_object* v___y_3133_, lean_object* v___y_3134_, lean_object* v___y_3135_, lean_object* v___y_3136_, lean_object* v___y_3137_){
_start:
{
lean_object* v_res_3138_; 
v_res_3138_ = l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4(v_msg_3128_, v___y_3129_, v___y_3130_, v___y_3131_, v___y_3132_, v___y_3133_, v___y_3134_, v___y_3135_, v___y_3136_);
lean_dec(v___y_3136_);
lean_dec_ref(v___y_3135_);
lean_dec(v___y_3134_);
lean_dec_ref(v___y_3133_);
lean_dec(v___y_3132_);
lean_dec_ref(v___y_3131_);
lean_dec(v___y_3130_);
lean_dec_ref(v___y_3129_);
return v_res_3138_;
}
}
static lean_object* _init_l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__1(void){
_start:
{
lean_object* v___x_3140_; lean_object* v___x_3141_; 
v___x_3140_ = ((lean_object*)(l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__0));
v___x_3141_ = l_Lean_stringToMessageData(v___x_3140_);
return v___x_3141_;
}
}
static lean_object* _init_l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__5(void){
_start:
{
lean_object* v___x_3145_; lean_object* v___x_3146_; lean_object* v___x_3147_; lean_object* v___x_3148_; lean_object* v___x_3149_; lean_object* v___x_3150_; 
v___x_3145_ = ((lean_object*)(l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__4));
v___x_3146_ = lean_unsigned_to_nat(11u);
v___x_3147_ = lean_unsigned_to_nat(122u);
v___x_3148_ = ((lean_object*)(l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__3));
v___x_3149_ = ((lean_object*)(l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__2));
v___x_3150_ = l_mkPanicMessageWithDecl(v___x_3149_, v___x_3148_, v___x_3147_, v___x_3146_, v___x_3145_);
return v___x_3150_;
}
}
LEAN_EXPORT lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2(lean_object* v_constName_3151_, lean_object* v___y_3152_, lean_object* v___y_3153_, lean_object* v___y_3154_, lean_object* v___y_3155_, lean_object* v___y_3156_, lean_object* v___y_3157_, lean_object* v___y_3158_, lean_object* v___y_3159_){
_start:
{
lean_object* v___x_3169_; lean_object* v_env_3170_; uint8_t v___x_3171_; lean_object* v___x_3172_; 
v___x_3169_ = lean_st_ref_get(v___y_3159_);
v_env_3170_ = lean_ctor_get(v___x_3169_, 0);
lean_inc_ref(v_env_3170_);
lean_dec(v___x_3169_);
v___x_3171_ = 0;
lean_inc(v_constName_3151_);
v___x_3172_ = l_Lean_Environment_findAsync_x3f(v_env_3170_, v_constName_3151_, v___x_3171_);
if (lean_obj_tag(v___x_3172_) == 1)
{
lean_object* v_val_3173_; uint8_t v_kind_3174_; 
v_val_3173_ = lean_ctor_get(v___x_3172_, 0);
lean_inc(v_val_3173_);
lean_dec_ref_known(v___x_3172_, 1);
v_kind_3174_ = lean_ctor_get_uint8(v_val_3173_, sizeof(void*)*3);
if (v_kind_3174_ == 6)
{
lean_object* v___x_3175_; 
v___x_3175_ = l_Lean_AsyncConstantInfo_toConstantInfo(v_val_3173_);
if (lean_obj_tag(v___x_3175_) == 6)
{
lean_object* v_val_3176_; lean_object* v___x_3178_; uint8_t v_isShared_3179_; uint8_t v_isSharedCheck_3183_; 
lean_dec(v_constName_3151_);
v_val_3176_ = lean_ctor_get(v___x_3175_, 0);
v_isSharedCheck_3183_ = !lean_is_exclusive(v___x_3175_);
if (v_isSharedCheck_3183_ == 0)
{
v___x_3178_ = v___x_3175_;
v_isShared_3179_ = v_isSharedCheck_3183_;
goto v_resetjp_3177_;
}
else
{
lean_inc(v_val_3176_);
lean_dec(v___x_3175_);
v___x_3178_ = lean_box(0);
v_isShared_3179_ = v_isSharedCheck_3183_;
goto v_resetjp_3177_;
}
v_resetjp_3177_:
{
lean_object* v___x_3181_; 
if (v_isShared_3179_ == 0)
{
lean_ctor_set_tag(v___x_3178_, 0);
v___x_3181_ = v___x_3178_;
goto v_reusejp_3180_;
}
else
{
lean_object* v_reuseFailAlloc_3182_; 
v_reuseFailAlloc_3182_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3182_, 0, v_val_3176_);
v___x_3181_ = v_reuseFailAlloc_3182_;
goto v_reusejp_3180_;
}
v_reusejp_3180_:
{
return v___x_3181_;
}
}
}
else
{
lean_object* v___x_3184_; lean_object* v___x_3185_; 
lean_dec_ref(v___x_3175_);
v___x_3184_ = lean_obj_once(&l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__5, &l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__5_once, _init_l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__5);
v___x_3185_ = l_panic___at___00Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2_spec__4(v___x_3184_, v___y_3152_, v___y_3153_, v___y_3154_, v___y_3155_, v___y_3156_, v___y_3157_, v___y_3158_, v___y_3159_);
if (lean_obj_tag(v___x_3185_) == 0)
{
lean_object* v_a_3186_; lean_object* v___x_3188_; uint8_t v_isShared_3189_; uint8_t v_isSharedCheck_3194_; 
v_a_3186_ = lean_ctor_get(v___x_3185_, 0);
v_isSharedCheck_3194_ = !lean_is_exclusive(v___x_3185_);
if (v_isSharedCheck_3194_ == 0)
{
v___x_3188_ = v___x_3185_;
v_isShared_3189_ = v_isSharedCheck_3194_;
goto v_resetjp_3187_;
}
else
{
lean_inc(v_a_3186_);
lean_dec(v___x_3185_);
v___x_3188_ = lean_box(0);
v_isShared_3189_ = v_isSharedCheck_3194_;
goto v_resetjp_3187_;
}
v_resetjp_3187_:
{
if (lean_obj_tag(v_a_3186_) == 0)
{
lean_del_object(v___x_3188_);
goto v___jp_3161_;
}
else
{
lean_object* v_val_3190_; lean_object* v___x_3192_; 
lean_dec(v_constName_3151_);
v_val_3190_ = lean_ctor_get(v_a_3186_, 0);
lean_inc(v_val_3190_);
lean_dec_ref_known(v_a_3186_, 1);
if (v_isShared_3189_ == 0)
{
lean_ctor_set(v___x_3188_, 0, v_val_3190_);
v___x_3192_ = v___x_3188_;
goto v_reusejp_3191_;
}
else
{
lean_object* v_reuseFailAlloc_3193_; 
v_reuseFailAlloc_3193_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3193_, 0, v_val_3190_);
v___x_3192_ = v_reuseFailAlloc_3193_;
goto v_reusejp_3191_;
}
v_reusejp_3191_:
{
return v___x_3192_;
}
}
}
}
else
{
lean_object* v_a_3195_; lean_object* v___x_3197_; uint8_t v_isShared_3198_; uint8_t v_isSharedCheck_3202_; 
lean_dec(v_constName_3151_);
v_a_3195_ = lean_ctor_get(v___x_3185_, 0);
v_isSharedCheck_3202_ = !lean_is_exclusive(v___x_3185_);
if (v_isSharedCheck_3202_ == 0)
{
v___x_3197_ = v___x_3185_;
v_isShared_3198_ = v_isSharedCheck_3202_;
goto v_resetjp_3196_;
}
else
{
lean_inc(v_a_3195_);
lean_dec(v___x_3185_);
v___x_3197_ = lean_box(0);
v_isShared_3198_ = v_isSharedCheck_3202_;
goto v_resetjp_3196_;
}
v_resetjp_3196_:
{
lean_object* v___x_3200_; 
if (v_isShared_3198_ == 0)
{
v___x_3200_ = v___x_3197_;
goto v_reusejp_3199_;
}
else
{
lean_object* v_reuseFailAlloc_3201_; 
v_reuseFailAlloc_3201_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3201_, 0, v_a_3195_);
v___x_3200_ = v_reuseFailAlloc_3201_;
goto v_reusejp_3199_;
}
v_reusejp_3199_:
{
return v___x_3200_;
}
}
}
}
}
else
{
lean_dec(v_val_3173_);
goto v___jp_3161_;
}
}
else
{
lean_dec(v___x_3172_);
goto v___jp_3161_;
}
v___jp_3161_:
{
lean_object* v___x_3162_; uint8_t v___x_3163_; lean_object* v___x_3164_; lean_object* v___x_3165_; lean_object* v___x_3166_; lean_object* v___x_3167_; lean_object* v___x_3168_; 
v___x_3162_ = lean_obj_once(&l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1, &l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1_once, _init_l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0___closed__1);
v___x_3163_ = 0;
v___x_3164_ = l_Lean_MessageData_ofConstName(v_constName_3151_, v___x_3163_);
v___x_3165_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_3165_, 0, v___x_3162_);
lean_ctor_set(v___x_3165_, 1, v___x_3164_);
v___x_3166_ = lean_obj_once(&l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__1, &l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__1_once, _init_l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___closed__1);
v___x_3167_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_3167_, 0, v___x_3165_);
lean_ctor_set(v___x_3167_, 1, v___x_3166_);
v___x_3168_ = l_Lean_throwError___at___00Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0_spec__0___redArg(v___x_3167_, v___y_3156_, v___y_3157_, v___y_3158_, v___y_3159_);
return v___x_3168_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2___boxed(lean_object* v_constName_3203_, lean_object* v___y_3204_, lean_object* v___y_3205_, lean_object* v___y_3206_, lean_object* v___y_3207_, lean_object* v___y_3208_, lean_object* v___y_3209_, lean_object* v___y_3210_, lean_object* v___y_3211_, lean_object* v___y_3212_){
_start:
{
lean_object* v_res_3213_; 
v_res_3213_ = l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2(v_constName_3203_, v___y_3204_, v___y_3205_, v___y_3206_, v___y_3207_, v___y_3208_, v___y_3209_, v___y_3210_, v___y_3211_);
lean_dec(v___y_3211_);
lean_dec_ref(v___y_3210_);
lean_dec(v___y_3209_);
lean_dec_ref(v___y_3208_);
lean_dec(v___y_3207_);
lean_dec_ref(v___y_3206_);
lean_dec(v___y_3205_);
lean_dec_ref(v___y_3204_);
return v_res_3213_;
}
}
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg(lean_object* v_m_3214_, lean_object* v_a_3215_){
_start:
{
lean_object* v_buckets_3216_; lean_object* v___x_3217_; uint64_t v___y_3219_; 
v_buckets_3216_ = lean_ctor_get(v_m_3214_, 1);
v___x_3217_ = lean_array_get_size(v_buckets_3216_);
if (lean_obj_tag(v_a_3215_) == 0)
{
uint64_t v___x_3233_; 
v___x_3233_ = lean_uint64_once(&l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0, &l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0_once, _init_l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__0___redArg___closed__0);
v___y_3219_ = v___x_3233_;
goto v___jp_3218_;
}
else
{
uint64_t v_hash_3234_; 
v_hash_3234_ = lean_ctor_get_uint64(v_a_3215_, sizeof(void*)*2);
v___y_3219_ = v_hash_3234_;
goto v___jp_3218_;
}
v___jp_3218_:
{
uint64_t v___x_3220_; uint64_t v___x_3221_; uint64_t v_fold_3222_; uint64_t v___x_3223_; uint64_t v___x_3224_; uint64_t v___x_3225_; size_t v___x_3226_; size_t v___x_3227_; size_t v___x_3228_; size_t v___x_3229_; size_t v___x_3230_; lean_object* v___x_3231_; uint8_t v___x_3232_; 
v___x_3220_ = 32ULL;
v___x_3221_ = lean_uint64_shift_right(v___y_3219_, v___x_3220_);
v_fold_3222_ = lean_uint64_xor(v___y_3219_, v___x_3221_);
v___x_3223_ = 16ULL;
v___x_3224_ = lean_uint64_shift_right(v_fold_3222_, v___x_3223_);
v___x_3225_ = lean_uint64_xor(v_fold_3222_, v___x_3224_);
v___x_3226_ = lean_uint64_to_usize(v___x_3225_);
v___x_3227_ = lean_usize_of_nat(v___x_3217_);
v___x_3228_ = ((size_t)1ULL);
v___x_3229_ = lean_usize_sub(v___x_3227_, v___x_3228_);
v___x_3230_ = lean_usize_land(v___x_3226_, v___x_3229_);
v___x_3231_ = lean_array_uget_borrowed(v_buckets_3216_, v___x_3230_);
v___x_3232_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__2_spec__4___redArg(v_a_3215_, v___x_3231_);
return v___x_3232_;
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg___boxed(lean_object* v_m_3235_, lean_object* v_a_3236_){
_start:
{
uint8_t v_res_3237_; lean_object* v_r_3238_; 
v_res_3237_ = l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg(v_m_3235_, v_a_3236_);
lean_dec(v_a_3236_);
lean_dec_ref(v_m_3235_);
v_r_3238_ = lean_box(v_res_3237_);
return v_r_3238_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg(lean_object* v_upperBound_3242_, lean_object* v_a_3243_, lean_object* v_fst_3244_, lean_object* v_snd_3245_, lean_object* v_fst_3246_, lean_object* v_interesting_3247_, lean_object* v_a_3248_, lean_object* v_b_3249_, lean_object* v___y_3250_, lean_object* v___y_3251_, lean_object* v___y_3252_, lean_object* v___y_3253_, lean_object* v___y_3254_, lean_object* v___y_3255_){
_start:
{
lean_object* v_a_3258_; uint8_t v___x_3262_; 
v___x_3262_ = lean_nat_dec_lt(v_a_3248_, v_upperBound_3242_);
if (v___x_3262_ == 0)
{
lean_object* v___x_3263_; 
lean_dec(v_a_3248_);
lean_dec_ref(v_fst_3246_);
lean_dec(v_fst_3244_);
lean_dec_ref(v_a_3243_);
v___x_3263_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3263_, 0, v_b_3249_);
return v___x_3263_;
}
else
{
lean_object* v___x_3264_; 
lean_inc_ref(v_fst_3246_);
lean_inc(v_a_3248_);
lean_inc(v_fst_3244_);
lean_inc_ref(v_a_3243_);
v___x_3264_ = l_Lean_Meta_mkProjFn___redArg(v_a_3243_, v_fst_3244_, v_snd_3245_, v_a_3248_, v_fst_3246_, v___y_3255_);
if (lean_obj_tag(v___x_3264_) == 0)
{
lean_object* v_a_3265_; lean_object* v___x_3266_; 
v_a_3265_ = lean_ctor_get(v___x_3264_, 0);
lean_inc(v_a_3265_);
lean_dec_ref_known(v___x_3264_, 1);
v___x_3266_ = l_Lean_Meta_Sym_shareCommonInc(v_a_3265_, v___y_3250_, v___y_3251_, v___y_3252_, v___y_3253_, v___y_3254_, v___y_3255_);
if (lean_obj_tag(v___x_3266_) == 0)
{
lean_object* v_a_3267_; lean_object* v___x_3268_; 
v_a_3267_ = lean_ctor_get(v___x_3266_, 0);
lean_inc_n(v_a_3267_, 2);
lean_dec_ref_known(v___x_3266_, 1);
v___x_3268_ = l_Lean_Meta_Sym_inferType(v_a_3267_, v___y_3250_, v___y_3251_, v___y_3252_, v___y_3253_, v___y_3254_, v___y_3255_);
if (lean_obj_tag(v___x_3268_) == 0)
{
lean_object* v_a_3269_; lean_object* v___x_3270_; 
v_a_3269_ = lean_ctor_get(v___x_3268_, 0);
lean_inc(v_a_3269_);
lean_dec_ref_known(v___x_3268_, 1);
v___x_3270_ = l_Lean_Meta_Sym_unfoldReducible(v_a_3269_, v___y_3252_, v___y_3253_, v___y_3254_, v___y_3255_);
if (lean_obj_tag(v___x_3270_) == 0)
{
lean_object* v_a_3271_; lean_object* v___x_3272_; 
v_a_3271_ = lean_ctor_get(v___x_3270_, 0);
lean_inc(v_a_3271_);
lean_dec_ref_known(v___x_3270_, 1);
v___x_3272_ = l_Lean_Meta_Sym_shareCommon(v_a_3271_, v___y_3250_, v___y_3251_, v___y_3252_, v___y_3253_, v___y_3254_, v___y_3255_);
if (lean_obj_tag(v___x_3272_) == 0)
{
lean_object* v_a_3273_; lean_object* v___x_3274_; 
v_a_3273_ = lean_ctor_get(v___x_3272_, 0);
lean_inc_n(v_a_3273_, 2);
lean_dec_ref_known(v___x_3272_, 1);
v___x_3274_ = l_Lean_Meta_isProp(v_a_3273_, v___y_3252_, v___y_3253_, v___y_3254_, v___y_3255_);
if (lean_obj_tag(v___x_3274_) == 0)
{
lean_object* v_a_3275_; uint8_t v___x_3276_; 
v_a_3275_ = lean_ctor_get(v___x_3274_, 0);
lean_inc(v_a_3275_);
lean_dec_ref_known(v___x_3274_, 1);
v___x_3276_ = lean_unbox(v_a_3275_);
lean_dec(v_a_3275_);
if (v___x_3276_ == 0)
{
lean_object* v_fst_3277_; lean_object* v_snd_3278_; lean_object* v___x_3280_; uint8_t v_isShared_3281_; uint8_t v_isSharedCheck_3305_; 
v_fst_3277_ = lean_ctor_get(v_b_3249_, 0);
v_snd_3278_ = lean_ctor_get(v_b_3249_, 1);
v_isSharedCheck_3305_ = !lean_is_exclusive(v_b_3249_);
if (v_isSharedCheck_3305_ == 0)
{
v___x_3280_ = v_b_3249_;
v_isShared_3281_ = v_isSharedCheck_3305_;
goto v_resetjp_3279_;
}
else
{
lean_inc(v_snd_3278_);
lean_inc(v_fst_3277_);
lean_dec(v_b_3249_);
v___x_3280_ = lean_box(0);
v_isShared_3281_ = v_isSharedCheck_3305_;
goto v_resetjp_3279_;
}
v_resetjp_3279_:
{
lean_object* v___x_3282_; 
v___x_3282_ = l_Lean_Expr_getAppFn(v_a_3273_);
if (lean_obj_tag(v___x_3282_) == 4)
{
lean_object* v_declName_3283_; lean_object* v_us_3284_; uint8_t v___x_3285_; 
v_declName_3283_ = lean_ctor_get(v___x_3282_, 0);
lean_inc(v_declName_3283_);
v_us_3284_ = lean_ctor_get(v___x_3282_, 1);
lean_inc(v_us_3284_);
lean_dec_ref_known(v___x_3282_, 2);
v___x_3285_ = l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg(v_interesting_3247_, v_declName_3283_);
if (v___x_3285_ == 0)
{
lean_object* v___x_3287_; 
lean_dec(v_us_3284_);
lean_dec(v_declName_3283_);
lean_dec(v_a_3273_);
lean_dec(v_a_3267_);
if (v_isShared_3281_ == 0)
{
v___x_3287_ = v___x_3280_;
goto v_reusejp_3286_;
}
else
{
lean_object* v_reuseFailAlloc_3288_; 
v_reuseFailAlloc_3288_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3288_, 0, v_fst_3277_);
lean_ctor_set(v_reuseFailAlloc_3288_, 1, v_snd_3278_);
v___x_3287_ = v_reuseFailAlloc_3288_;
goto v_reusejp_3286_;
}
v_reusejp_3286_:
{
v_a_3258_ = v___x_3287_;
goto v___jp_3257_;
}
}
else
{
lean_object* v_dummy_3289_; lean_object* v_nargs_3290_; lean_object* v___x_3291_; lean_object* v___x_3292_; lean_object* v___x_3293_; lean_object* v___x_3294_; lean_object* v___x_3296_; 
v_dummy_3289_ = lean_obj_once(&l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0, &l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0_once, _init_l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0);
v_nargs_3290_ = l_Lean_Expr_getAppNumArgs(v_a_3273_);
lean_inc(v_nargs_3290_);
v___x_3291_ = lean_mk_array(v_nargs_3290_, v_dummy_3289_);
v___x_3292_ = lean_unsigned_to_nat(1u);
v___x_3293_ = lean_nat_sub(v_nargs_3290_, v___x_3292_);
lean_dec(v_nargs_3290_);
v___x_3294_ = l___private_Lean_Expr_0__Lean_Expr_getAppArgsAux(v_a_3273_, v___x_3291_, v___x_3293_);
if (v_isShared_3281_ == 0)
{
lean_ctor_set(v___x_3280_, 1, v___x_3294_);
lean_ctor_set(v___x_3280_, 0, v_us_3284_);
v___x_3296_ = v___x_3280_;
goto v_reusejp_3295_;
}
else
{
lean_object* v_reuseFailAlloc_3301_; 
v_reuseFailAlloc_3301_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3301_, 0, v_us_3284_);
lean_ctor_set(v_reuseFailAlloc_3301_, 1, v___x_3294_);
v___x_3296_ = v_reuseFailAlloc_3301_;
goto v_reusejp_3295_;
}
v_reusejp_3295_:
{
lean_object* v___x_3297_; lean_object* v___x_3298_; lean_object* v___x_3299_; lean_object* v___x_3300_; 
v___x_3297_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3297_, 0, v_declName_3283_);
lean_ctor_set(v___x_3297_, 1, v___x_3296_);
v___x_3298_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3298_, 0, v_a_3267_);
lean_ctor_set(v___x_3298_, 1, v___x_3297_);
v___x_3299_ = lean_array_push(v_fst_3277_, v___x_3298_);
v___x_3300_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3300_, 0, v___x_3299_);
lean_ctor_set(v___x_3300_, 1, v_snd_3278_);
v_a_3258_ = v___x_3300_;
goto v___jp_3257_;
}
}
}
else
{
lean_object* v___x_3303_; 
lean_dec_ref(v___x_3282_);
lean_dec(v_a_3273_);
lean_dec(v_a_3267_);
if (v_isShared_3281_ == 0)
{
v___x_3303_ = v___x_3280_;
goto v_reusejp_3302_;
}
else
{
lean_object* v_reuseFailAlloc_3304_; 
v_reuseFailAlloc_3304_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3304_, 0, v_fst_3277_);
lean_ctor_set(v_reuseFailAlloc_3304_, 1, v_snd_3278_);
v___x_3303_ = v_reuseFailAlloc_3304_;
goto v_reusejp_3302_;
}
v_reusejp_3302_:
{
v_a_3258_ = v___x_3303_;
goto v___jp_3257_;
}
}
}
}
else
{
lean_object* v_fst_3306_; lean_object* v_snd_3307_; lean_object* v___x_3309_; uint8_t v_isShared_3310_; uint8_t v_isSharedCheck_3317_; 
v_fst_3306_ = lean_ctor_get(v_b_3249_, 0);
v_snd_3307_ = lean_ctor_get(v_b_3249_, 1);
v_isSharedCheck_3317_ = !lean_is_exclusive(v_b_3249_);
if (v_isSharedCheck_3317_ == 0)
{
v___x_3309_ = v_b_3249_;
v_isShared_3310_ = v_isSharedCheck_3317_;
goto v_resetjp_3308_;
}
else
{
lean_inc(v_snd_3307_);
lean_inc(v_fst_3306_);
lean_dec(v_b_3249_);
v___x_3309_ = lean_box(0);
v_isShared_3310_ = v_isSharedCheck_3317_;
goto v_resetjp_3308_;
}
v_resetjp_3308_:
{
lean_object* v___x_3311_; lean_object* v___x_3312_; lean_object* v___x_3313_; lean_object* v___x_3315_; 
v___x_3311_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___closed__1));
v___x_3312_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v___x_3312_, 0, v___x_3311_);
lean_ctor_set(v___x_3312_, 1, v_a_3273_);
lean_ctor_set(v___x_3312_, 2, v_a_3267_);
v___x_3313_ = lean_array_push(v_snd_3307_, v___x_3312_);
if (v_isShared_3310_ == 0)
{
lean_ctor_set(v___x_3309_, 1, v___x_3313_);
v___x_3315_ = v___x_3309_;
goto v_reusejp_3314_;
}
else
{
lean_object* v_reuseFailAlloc_3316_; 
v_reuseFailAlloc_3316_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3316_, 0, v_fst_3306_);
lean_ctor_set(v_reuseFailAlloc_3316_, 1, v___x_3313_);
v___x_3315_ = v_reuseFailAlloc_3316_;
goto v_reusejp_3314_;
}
v_reusejp_3314_:
{
v_a_3258_ = v___x_3315_;
goto v___jp_3257_;
}
}
}
}
else
{
lean_object* v_a_3318_; lean_object* v___x_3320_; uint8_t v_isShared_3321_; uint8_t v_isSharedCheck_3325_; 
lean_dec(v_a_3273_);
lean_dec(v_a_3267_);
lean_dec_ref(v_b_3249_);
lean_dec(v_a_3248_);
lean_dec_ref(v_fst_3246_);
lean_dec(v_fst_3244_);
lean_dec_ref(v_a_3243_);
v_a_3318_ = lean_ctor_get(v___x_3274_, 0);
v_isSharedCheck_3325_ = !lean_is_exclusive(v___x_3274_);
if (v_isSharedCheck_3325_ == 0)
{
v___x_3320_ = v___x_3274_;
v_isShared_3321_ = v_isSharedCheck_3325_;
goto v_resetjp_3319_;
}
else
{
lean_inc(v_a_3318_);
lean_dec(v___x_3274_);
v___x_3320_ = lean_box(0);
v_isShared_3321_ = v_isSharedCheck_3325_;
goto v_resetjp_3319_;
}
v_resetjp_3319_:
{
lean_object* v___x_3323_; 
if (v_isShared_3321_ == 0)
{
v___x_3323_ = v___x_3320_;
goto v_reusejp_3322_;
}
else
{
lean_object* v_reuseFailAlloc_3324_; 
v_reuseFailAlloc_3324_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3324_, 0, v_a_3318_);
v___x_3323_ = v_reuseFailAlloc_3324_;
goto v_reusejp_3322_;
}
v_reusejp_3322_:
{
return v___x_3323_;
}
}
}
}
else
{
lean_object* v_a_3326_; lean_object* v___x_3328_; uint8_t v_isShared_3329_; uint8_t v_isSharedCheck_3333_; 
lean_dec(v_a_3267_);
lean_dec_ref(v_b_3249_);
lean_dec(v_a_3248_);
lean_dec_ref(v_fst_3246_);
lean_dec(v_fst_3244_);
lean_dec_ref(v_a_3243_);
v_a_3326_ = lean_ctor_get(v___x_3272_, 0);
v_isSharedCheck_3333_ = !lean_is_exclusive(v___x_3272_);
if (v_isSharedCheck_3333_ == 0)
{
v___x_3328_ = v___x_3272_;
v_isShared_3329_ = v_isSharedCheck_3333_;
goto v_resetjp_3327_;
}
else
{
lean_inc(v_a_3326_);
lean_dec(v___x_3272_);
v___x_3328_ = lean_box(0);
v_isShared_3329_ = v_isSharedCheck_3333_;
goto v_resetjp_3327_;
}
v_resetjp_3327_:
{
lean_object* v___x_3331_; 
if (v_isShared_3329_ == 0)
{
v___x_3331_ = v___x_3328_;
goto v_reusejp_3330_;
}
else
{
lean_object* v_reuseFailAlloc_3332_; 
v_reuseFailAlloc_3332_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3332_, 0, v_a_3326_);
v___x_3331_ = v_reuseFailAlloc_3332_;
goto v_reusejp_3330_;
}
v_reusejp_3330_:
{
return v___x_3331_;
}
}
}
}
else
{
lean_object* v_a_3334_; lean_object* v___x_3336_; uint8_t v_isShared_3337_; uint8_t v_isSharedCheck_3341_; 
lean_dec(v_a_3267_);
lean_dec_ref(v_b_3249_);
lean_dec(v_a_3248_);
lean_dec_ref(v_fst_3246_);
lean_dec(v_fst_3244_);
lean_dec_ref(v_a_3243_);
v_a_3334_ = lean_ctor_get(v___x_3270_, 0);
v_isSharedCheck_3341_ = !lean_is_exclusive(v___x_3270_);
if (v_isSharedCheck_3341_ == 0)
{
v___x_3336_ = v___x_3270_;
v_isShared_3337_ = v_isSharedCheck_3341_;
goto v_resetjp_3335_;
}
else
{
lean_inc(v_a_3334_);
lean_dec(v___x_3270_);
v___x_3336_ = lean_box(0);
v_isShared_3337_ = v_isSharedCheck_3341_;
goto v_resetjp_3335_;
}
v_resetjp_3335_:
{
lean_object* v___x_3339_; 
if (v_isShared_3337_ == 0)
{
v___x_3339_ = v___x_3336_;
goto v_reusejp_3338_;
}
else
{
lean_object* v_reuseFailAlloc_3340_; 
v_reuseFailAlloc_3340_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3340_, 0, v_a_3334_);
v___x_3339_ = v_reuseFailAlloc_3340_;
goto v_reusejp_3338_;
}
v_reusejp_3338_:
{
return v___x_3339_;
}
}
}
}
else
{
lean_object* v_a_3342_; lean_object* v___x_3344_; uint8_t v_isShared_3345_; uint8_t v_isSharedCheck_3349_; 
lean_dec(v_a_3267_);
lean_dec_ref(v_b_3249_);
lean_dec(v_a_3248_);
lean_dec_ref(v_fst_3246_);
lean_dec(v_fst_3244_);
lean_dec_ref(v_a_3243_);
v_a_3342_ = lean_ctor_get(v___x_3268_, 0);
v_isSharedCheck_3349_ = !lean_is_exclusive(v___x_3268_);
if (v_isSharedCheck_3349_ == 0)
{
v___x_3344_ = v___x_3268_;
v_isShared_3345_ = v_isSharedCheck_3349_;
goto v_resetjp_3343_;
}
else
{
lean_inc(v_a_3342_);
lean_dec(v___x_3268_);
v___x_3344_ = lean_box(0);
v_isShared_3345_ = v_isSharedCheck_3349_;
goto v_resetjp_3343_;
}
v_resetjp_3343_:
{
lean_object* v___x_3347_; 
if (v_isShared_3345_ == 0)
{
v___x_3347_ = v___x_3344_;
goto v_reusejp_3346_;
}
else
{
lean_object* v_reuseFailAlloc_3348_; 
v_reuseFailAlloc_3348_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3348_, 0, v_a_3342_);
v___x_3347_ = v_reuseFailAlloc_3348_;
goto v_reusejp_3346_;
}
v_reusejp_3346_:
{
return v___x_3347_;
}
}
}
}
else
{
lean_object* v_a_3350_; lean_object* v___x_3352_; uint8_t v_isShared_3353_; uint8_t v_isSharedCheck_3357_; 
lean_dec_ref(v_b_3249_);
lean_dec(v_a_3248_);
lean_dec_ref(v_fst_3246_);
lean_dec(v_fst_3244_);
lean_dec_ref(v_a_3243_);
v_a_3350_ = lean_ctor_get(v___x_3266_, 0);
v_isSharedCheck_3357_ = !lean_is_exclusive(v___x_3266_);
if (v_isSharedCheck_3357_ == 0)
{
v___x_3352_ = v___x_3266_;
v_isShared_3353_ = v_isSharedCheck_3357_;
goto v_resetjp_3351_;
}
else
{
lean_inc(v_a_3350_);
lean_dec(v___x_3266_);
v___x_3352_ = lean_box(0);
v_isShared_3353_ = v_isSharedCheck_3357_;
goto v_resetjp_3351_;
}
v_resetjp_3351_:
{
lean_object* v___x_3355_; 
if (v_isShared_3353_ == 0)
{
v___x_3355_ = v___x_3352_;
goto v_reusejp_3354_;
}
else
{
lean_object* v_reuseFailAlloc_3356_; 
v_reuseFailAlloc_3356_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3356_, 0, v_a_3350_);
v___x_3355_ = v_reuseFailAlloc_3356_;
goto v_reusejp_3354_;
}
v_reusejp_3354_:
{
return v___x_3355_;
}
}
}
}
else
{
lean_object* v_a_3358_; lean_object* v___x_3360_; uint8_t v_isShared_3361_; uint8_t v_isSharedCheck_3365_; 
lean_dec_ref(v_b_3249_);
lean_dec(v_a_3248_);
lean_dec_ref(v_fst_3246_);
lean_dec(v_fst_3244_);
lean_dec_ref(v_a_3243_);
v_a_3358_ = lean_ctor_get(v___x_3264_, 0);
v_isSharedCheck_3365_ = !lean_is_exclusive(v___x_3264_);
if (v_isSharedCheck_3365_ == 0)
{
v___x_3360_ = v___x_3264_;
v_isShared_3361_ = v_isSharedCheck_3365_;
goto v_resetjp_3359_;
}
else
{
lean_inc(v_a_3358_);
lean_dec(v___x_3264_);
v___x_3360_ = lean_box(0);
v_isShared_3361_ = v_isSharedCheck_3365_;
goto v_resetjp_3359_;
}
v_resetjp_3359_:
{
lean_object* v___x_3363_; 
if (v_isShared_3361_ == 0)
{
v___x_3363_ = v___x_3360_;
goto v_reusejp_3362_;
}
else
{
lean_object* v_reuseFailAlloc_3364_; 
v_reuseFailAlloc_3364_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3364_, 0, v_a_3358_);
v___x_3363_ = v_reuseFailAlloc_3364_;
goto v_reusejp_3362_;
}
v_reusejp_3362_:
{
return v___x_3363_;
}
}
}
}
v___jp_3257_:
{
lean_object* v___x_3259_; lean_object* v___x_3260_; 
v___x_3259_ = lean_unsigned_to_nat(1u);
v___x_3260_ = lean_nat_add(v_a_3248_, v___x_3259_);
lean_dec(v_a_3248_);
v_a_3248_ = v___x_3260_;
v_b_3249_ = v_a_3258_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg___boxed(lean_object* v_upperBound_3366_, lean_object* v_a_3367_, lean_object* v_fst_3368_, lean_object* v_snd_3369_, lean_object* v_fst_3370_, lean_object* v_interesting_3371_, lean_object* v_a_3372_, lean_object* v_b_3373_, lean_object* v___y_3374_, lean_object* v___y_3375_, lean_object* v___y_3376_, lean_object* v___y_3377_, lean_object* v___y_3378_, lean_object* v___y_3379_, lean_object* v___y_3380_){
_start:
{
lean_object* v_res_3381_; 
v_res_3381_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg(v_upperBound_3366_, v_a_3367_, v_fst_3368_, v_snd_3369_, v_fst_3370_, v_interesting_3371_, v_a_3372_, v_b_3373_, v___y_3374_, v___y_3375_, v___y_3376_, v___y_3377_, v___y_3378_, v___y_3379_);
lean_dec(v___y_3379_);
lean_dec_ref(v___y_3378_);
lean_dec(v___y_3377_);
lean_dec_ref(v___y_3376_);
lean_dec(v___y_3375_);
lean_dec_ref(v___y_3374_);
lean_dec_ref(v_interesting_3371_);
lean_dec_ref(v_snd_3369_);
lean_dec(v_upperBound_3366_);
return v_res_3381_;
}
}
LEAN_EXPORT lean_object* l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4___redArg(lean_object* v___x_3382_, lean_object* v_interesting_3383_, lean_object* v_a_3384_, lean_object* v___y_3385_, lean_object* v___y_3386_, lean_object* v___y_3387_, lean_object* v___y_3388_, lean_object* v___y_3389_, lean_object* v___y_3390_, lean_object* v___y_3391_, lean_object* v___y_3392_){
_start:
{
lean_object* v_fst_3394_; lean_object* v_snd_3395_; lean_object* v___x_3397_; uint8_t v_isShared_3398_; uint8_t v_isSharedCheck_3461_; 
v_fst_3394_ = lean_ctor_get(v_a_3384_, 0);
v_snd_3395_ = lean_ctor_get(v_a_3384_, 1);
v_isSharedCheck_3461_ = !lean_is_exclusive(v_a_3384_);
if (v_isSharedCheck_3461_ == 0)
{
v___x_3397_ = v_a_3384_;
v_isShared_3398_ = v_isSharedCheck_3461_;
goto v_resetjp_3396_;
}
else
{
lean_inc(v_snd_3395_);
lean_inc(v_fst_3394_);
lean_dec(v_a_3384_);
v___x_3397_ = lean_box(0);
v_isShared_3398_ = v_isSharedCheck_3461_;
goto v_resetjp_3396_;
}
v_resetjp_3396_:
{
lean_object* v___x_3399_; lean_object* v___x_3400_; uint8_t v___x_3401_; 
v___x_3399_ = lean_unsigned_to_nat(0u);
v___x_3400_ = lean_array_get_size(v_fst_3394_);
v___x_3401_ = lean_nat_dec_lt(v___x_3399_, v___x_3400_);
if (v___x_3401_ == 0)
{
lean_object* v___x_3403_; 
lean_dec_ref(v___x_3382_);
if (v_isShared_3398_ == 0)
{
v___x_3403_ = v___x_3397_;
goto v_reusejp_3402_;
}
else
{
lean_object* v_reuseFailAlloc_3405_; 
v_reuseFailAlloc_3405_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3405_, 0, v_fst_3394_);
lean_ctor_set(v_reuseFailAlloc_3405_, 1, v_snd_3395_);
v___x_3403_ = v_reuseFailAlloc_3405_;
goto v_reusejp_3402_;
}
v_reusejp_3402_:
{
lean_object* v___x_3404_; 
v___x_3404_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3404_, 0, v___x_3403_);
return v___x_3404_;
}
}
else
{
lean_object* v___x_3406_; lean_object* v___x_3407_; lean_object* v___x_3408_; lean_object* v_snd_3409_; lean_object* v_snd_3410_; lean_object* v_fst_3411_; lean_object* v_fst_3412_; lean_object* v_fst_3413_; lean_object* v_snd_3414_; lean_object* v___x_3416_; uint8_t v_isShared_3417_; uint8_t v_isSharedCheck_3460_; 
lean_del_object(v___x_3397_);
v___x_3406_ = lean_unsigned_to_nat(1u);
v___x_3407_ = lean_nat_sub(v___x_3400_, v___x_3406_);
v___x_3408_ = lean_array_fget_borrowed(v_fst_3394_, v___x_3407_);
lean_dec(v___x_3407_);
v_snd_3409_ = lean_ctor_get(v___x_3408_, 1);
v_snd_3410_ = lean_ctor_get(v_snd_3409_, 1);
lean_inc(v_snd_3410_);
v_fst_3411_ = lean_ctor_get(v___x_3408_, 0);
lean_inc(v_fst_3411_);
v_fst_3412_ = lean_ctor_get(v_snd_3409_, 0);
v_fst_3413_ = lean_ctor_get(v_snd_3410_, 0);
v_snd_3414_ = lean_ctor_get(v_snd_3410_, 1);
v_isSharedCheck_3460_ = !lean_is_exclusive(v_snd_3410_);
if (v_isSharedCheck_3460_ == 0)
{
v___x_3416_ = v_snd_3410_;
v_isShared_3417_ = v_isSharedCheck_3460_;
goto v_resetjp_3415_;
}
else
{
lean_inc(v_snd_3414_);
lean_inc(v_fst_3413_);
lean_dec(v_snd_3410_);
v___x_3416_ = lean_box(0);
v_isShared_3417_ = v_isSharedCheck_3460_;
goto v_resetjp_3415_;
}
v_resetjp_3415_:
{
lean_object* v___x_3418_; lean_object* v___x_3419_; 
lean_inc_n(v_fst_3412_, 2);
lean_inc_ref(v___x_3382_);
v___x_3418_ = l_Lean_getStructureInfo(v___x_3382_, v_fst_3412_);
v___x_3419_ = l_Lean_getConstInfoInduct___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__0(v_fst_3412_, v___y_3385_, v___y_3386_, v___y_3387_, v___y_3388_, v___y_3389_, v___y_3390_, v___y_3391_, v___y_3392_);
if (lean_obj_tag(v___x_3419_) == 0)
{
lean_object* v_a_3420_; lean_object* v_ctors_3421_; lean_object* v___x_3422_; lean_object* v___x_3423_; lean_object* v___x_3424_; 
v_a_3420_ = lean_ctor_get(v___x_3419_, 0);
lean_inc(v_a_3420_);
lean_dec_ref_known(v___x_3419_, 1);
v_ctors_3421_ = lean_ctor_get(v_a_3420_, 4);
lean_inc(v_ctors_3421_);
lean_dec(v_a_3420_);
v___x_3422_ = lean_box(0);
v___x_3423_ = l_List_head_x21___redArg(v___x_3422_, v_ctors_3421_);
lean_dec(v_ctors_3421_);
v___x_3424_ = l_Lean_getConstInfoCtor___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__2(v___x_3423_, v___y_3385_, v___y_3386_, v___y_3387_, v___y_3388_, v___y_3389_, v___y_3390_, v___y_3391_, v___y_3392_);
if (lean_obj_tag(v___x_3424_) == 0)
{
lean_object* v_a_3425_; lean_object* v_fieldNames_3426_; lean_object* v___x_3427_; lean_object* v___x_3428_; lean_object* v___x_3430_; 
v_a_3425_ = lean_ctor_get(v___x_3424_, 0);
lean_inc(v_a_3425_);
lean_dec_ref_known(v___x_3424_, 1);
v_fieldNames_3426_ = lean_ctor_get(v___x_3418_, 1);
lean_inc_ref(v_fieldNames_3426_);
lean_dec_ref(v___x_3418_);
v___x_3427_ = lean_array_get_size(v_fieldNames_3426_);
lean_dec_ref(v_fieldNames_3426_);
v___x_3428_ = lean_array_pop(v_fst_3394_);
if (v_isShared_3417_ == 0)
{
lean_ctor_set(v___x_3416_, 1, v_snd_3395_);
lean_ctor_set(v___x_3416_, 0, v___x_3428_);
v___x_3430_ = v___x_3416_;
goto v_reusejp_3429_;
}
else
{
lean_object* v_reuseFailAlloc_3443_; 
v_reuseFailAlloc_3443_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3443_, 0, v___x_3428_);
lean_ctor_set(v_reuseFailAlloc_3443_, 1, v_snd_3395_);
v___x_3430_ = v_reuseFailAlloc_3443_;
goto v_reusejp_3429_;
}
v_reusejp_3429_:
{
lean_object* v___x_3431_; 
v___x_3431_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg(v___x_3427_, v_a_3425_, v_fst_3413_, v_snd_3414_, v_fst_3411_, v_interesting_3383_, v___x_3399_, v___x_3430_, v___y_3387_, v___y_3388_, v___y_3389_, v___y_3390_, v___y_3391_, v___y_3392_);
lean_dec(v_snd_3414_);
if (lean_obj_tag(v___x_3431_) == 0)
{
lean_object* v_a_3432_; lean_object* v_fst_3433_; lean_object* v_snd_3434_; lean_object* v___x_3436_; uint8_t v_isShared_3437_; uint8_t v_isSharedCheck_3442_; 
v_a_3432_ = lean_ctor_get(v___x_3431_, 0);
lean_inc(v_a_3432_);
lean_dec_ref_known(v___x_3431_, 1);
v_fst_3433_ = lean_ctor_get(v_a_3432_, 0);
v_snd_3434_ = lean_ctor_get(v_a_3432_, 1);
v_isSharedCheck_3442_ = !lean_is_exclusive(v_a_3432_);
if (v_isSharedCheck_3442_ == 0)
{
v___x_3436_ = v_a_3432_;
v_isShared_3437_ = v_isSharedCheck_3442_;
goto v_resetjp_3435_;
}
else
{
lean_inc(v_snd_3434_);
lean_inc(v_fst_3433_);
lean_dec(v_a_3432_);
v___x_3436_ = lean_box(0);
v_isShared_3437_ = v_isSharedCheck_3442_;
goto v_resetjp_3435_;
}
v_resetjp_3435_:
{
lean_object* v___x_3439_; 
if (v_isShared_3437_ == 0)
{
v___x_3439_ = v___x_3436_;
goto v_reusejp_3438_;
}
else
{
lean_object* v_reuseFailAlloc_3441_; 
v_reuseFailAlloc_3441_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3441_, 0, v_fst_3433_);
lean_ctor_set(v_reuseFailAlloc_3441_, 1, v_snd_3434_);
v___x_3439_ = v_reuseFailAlloc_3441_;
goto v_reusejp_3438_;
}
v_reusejp_3438_:
{
v_a_3384_ = v___x_3439_;
goto _start;
}
}
}
else
{
lean_dec_ref(v___x_3382_);
return v___x_3431_;
}
}
}
else
{
lean_object* v_a_3444_; lean_object* v___x_3446_; uint8_t v_isShared_3447_; uint8_t v_isSharedCheck_3451_; 
lean_dec_ref(v___x_3418_);
lean_del_object(v___x_3416_);
lean_dec(v_snd_3414_);
lean_dec(v_fst_3413_);
lean_dec(v_fst_3411_);
lean_dec(v_snd_3395_);
lean_dec(v_fst_3394_);
lean_dec_ref(v___x_3382_);
v_a_3444_ = lean_ctor_get(v___x_3424_, 0);
v_isSharedCheck_3451_ = !lean_is_exclusive(v___x_3424_);
if (v_isSharedCheck_3451_ == 0)
{
v___x_3446_ = v___x_3424_;
v_isShared_3447_ = v_isSharedCheck_3451_;
goto v_resetjp_3445_;
}
else
{
lean_inc(v_a_3444_);
lean_dec(v___x_3424_);
v___x_3446_ = lean_box(0);
v_isShared_3447_ = v_isSharedCheck_3451_;
goto v_resetjp_3445_;
}
v_resetjp_3445_:
{
lean_object* v___x_3449_; 
if (v_isShared_3447_ == 0)
{
v___x_3449_ = v___x_3446_;
goto v_reusejp_3448_;
}
else
{
lean_object* v_reuseFailAlloc_3450_; 
v_reuseFailAlloc_3450_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3450_, 0, v_a_3444_);
v___x_3449_ = v_reuseFailAlloc_3450_;
goto v_reusejp_3448_;
}
v_reusejp_3448_:
{
return v___x_3449_;
}
}
}
}
else
{
lean_object* v_a_3452_; lean_object* v___x_3454_; uint8_t v_isShared_3455_; uint8_t v_isSharedCheck_3459_; 
lean_dec_ref(v___x_3418_);
lean_del_object(v___x_3416_);
lean_dec(v_snd_3414_);
lean_dec(v_fst_3413_);
lean_dec(v_fst_3411_);
lean_dec(v_snd_3395_);
lean_dec(v_fst_3394_);
lean_dec_ref(v___x_3382_);
v_a_3452_ = lean_ctor_get(v___x_3419_, 0);
v_isSharedCheck_3459_ = !lean_is_exclusive(v___x_3419_);
if (v_isSharedCheck_3459_ == 0)
{
v___x_3454_ = v___x_3419_;
v_isShared_3455_ = v_isSharedCheck_3459_;
goto v_resetjp_3453_;
}
else
{
lean_inc(v_a_3452_);
lean_dec(v___x_3419_);
v___x_3454_ = lean_box(0);
v_isShared_3455_ = v_isSharedCheck_3459_;
goto v_resetjp_3453_;
}
v_resetjp_3453_:
{
lean_object* v___x_3457_; 
if (v_isShared_3455_ == 0)
{
v___x_3457_ = v___x_3454_;
goto v_reusejp_3456_;
}
else
{
lean_object* v_reuseFailAlloc_3458_; 
v_reuseFailAlloc_3458_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3458_, 0, v_a_3452_);
v___x_3457_ = v_reuseFailAlloc_3458_;
goto v_reusejp_3456_;
}
v_reusejp_3456_:
{
return v___x_3457_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4___redArg___boxed(lean_object* v___x_3462_, lean_object* v_interesting_3463_, lean_object* v_a_3464_, lean_object* v___y_3465_, lean_object* v___y_3466_, lean_object* v___y_3467_, lean_object* v___y_3468_, lean_object* v___y_3469_, lean_object* v___y_3470_, lean_object* v___y_3471_, lean_object* v___y_3472_, lean_object* v___y_3473_){
_start:
{
lean_object* v_res_3474_; 
v_res_3474_ = l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4___redArg(v___x_3462_, v_interesting_3463_, v_a_3464_, v___y_3465_, v___y_3466_, v___y_3467_, v___y_3468_, v___y_3469_, v___y_3470_, v___y_3471_, v___y_3472_);
lean_dec(v___y_3472_);
lean_dec_ref(v___y_3471_);
lean_dec(v___y_3470_);
lean_dec_ref(v___y_3469_);
lean_dec(v___y_3468_);
lean_dec_ref(v___y_3467_);
lean_dec(v___y_3466_);
lean_dec_ref(v___y_3465_);
lean_dec_ref(v_interesting_3463_);
return v_res_3474_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5___redArg(lean_object* v___x_3475_, lean_object* v_interesting_3476_, lean_object* v_as_3477_, size_t v_sz_3478_, size_t v_i_3479_, lean_object* v_b_3480_, lean_object* v___y_3481_, lean_object* v___y_3482_, lean_object* v___y_3483_, lean_object* v___y_3484_, lean_object* v___y_3485_, lean_object* v___y_3486_){
_start:
{
uint8_t v___x_3488_; 
v___x_3488_ = lean_usize_dec_lt(v_i_3479_, v_sz_3478_);
if (v___x_3488_ == 0)
{
lean_object* v___x_3489_; 
v___x_3489_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3489_, 0, v_b_3480_);
return v___x_3489_;
}
else
{
lean_object* v_snd_3490_; lean_object* v___x_3492_; uint8_t v_isShared_3493_; uint8_t v_isSharedCheck_3536_; 
v_snd_3490_ = lean_ctor_get(v_b_3480_, 1);
v_isSharedCheck_3536_ = !lean_is_exclusive(v_b_3480_);
if (v_isSharedCheck_3536_ == 0)
{
lean_object* v_unused_3537_; 
v_unused_3537_ = lean_ctor_get(v_b_3480_, 0);
lean_dec(v_unused_3537_);
v___x_3492_ = v_b_3480_;
v_isShared_3493_ = v_isSharedCheck_3536_;
goto v_resetjp_3491_;
}
else
{
lean_inc(v_snd_3490_);
lean_dec(v_b_3480_);
v___x_3492_ = lean_box(0);
v_isShared_3493_ = v_isSharedCheck_3536_;
goto v_resetjp_3491_;
}
v_resetjp_3491_:
{
lean_object* v___x_3494_; lean_object* v_a_3496_; lean_object* v_a_3503_; 
v___x_3494_ = lean_box(0);
v_a_3503_ = lean_array_uget_borrowed(v_as_3477_, v_i_3479_);
if (lean_obj_tag(v_a_3503_) == 0)
{
v_a_3496_ = v_snd_3490_;
goto v___jp_3495_;
}
else
{
lean_object* v_val_3504_; lean_object* v___x_3505_; uint8_t v___x_3506_; uint8_t v___x_3507_; 
v_val_3504_ = lean_ctor_get(v_a_3503_, 0);
v___x_3505_ = lean_unsigned_to_nat(0u);
v___x_3506_ = lean_nat_dec_eq(v___x_3475_, v___x_3505_);
v___x_3507_ = l_Lean_LocalDecl_isLet(v_val_3504_, v___x_3506_);
if (v___x_3507_ == 0)
{
uint8_t v___x_3508_; 
v___x_3508_ = l_Lean_LocalDecl_isImplementationDetail(v_val_3504_);
if (v___x_3508_ == 0)
{
lean_object* v___x_3509_; lean_object* v___x_3510_; 
v___x_3509_ = l_Lean_LocalDecl_type(v_val_3504_);
v___x_3510_ = l_Lean_Expr_getAppFn(v___x_3509_);
if (lean_obj_tag(v___x_3510_) == 4)
{
lean_object* v_declName_3511_; lean_object* v_us_3512_; uint8_t v___x_3513_; 
v_declName_3511_ = lean_ctor_get(v___x_3510_, 0);
lean_inc(v_declName_3511_);
v_us_3512_ = lean_ctor_get(v___x_3510_, 1);
lean_inc(v_us_3512_);
lean_dec_ref_known(v___x_3510_, 2);
v___x_3513_ = l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg(v_interesting_3476_, v_declName_3511_);
if (v___x_3513_ == 0)
{
lean_dec(v_us_3512_);
lean_dec(v_declName_3511_);
lean_dec_ref(v___x_3509_);
v_a_3496_ = v_snd_3490_;
goto v___jp_3495_;
}
else
{
lean_object* v___x_3514_; lean_object* v___x_3515_; lean_object* v___x_3516_; 
v___x_3514_ = l_Lean_LocalDecl_fvarId(v_val_3504_);
v___x_3515_ = l_Lean_mkFVar(v___x_3514_);
v___x_3516_ = l_Lean_Meta_Sym_shareCommonInc(v___x_3515_, v___y_3481_, v___y_3482_, v___y_3483_, v___y_3484_, v___y_3485_, v___y_3486_);
if (lean_obj_tag(v___x_3516_) == 0)
{
lean_object* v_a_3517_; lean_object* v_dummy_3518_; lean_object* v_nargs_3519_; lean_object* v___x_3520_; lean_object* v___x_3521_; lean_object* v___x_3522_; lean_object* v___x_3523_; lean_object* v___x_3524_; lean_object* v___x_3525_; lean_object* v___x_3526_; lean_object* v___x_3527_; 
v_a_3517_ = lean_ctor_get(v___x_3516_, 0);
lean_inc(v_a_3517_);
lean_dec_ref_known(v___x_3516_, 1);
v_dummy_3518_ = lean_obj_once(&l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0, &l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0_once, _init_l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0);
v_nargs_3519_ = l_Lean_Expr_getAppNumArgs(v___x_3509_);
lean_inc(v_nargs_3519_);
v___x_3520_ = lean_mk_array(v_nargs_3519_, v_dummy_3518_);
v___x_3521_ = lean_unsigned_to_nat(1u);
v___x_3522_ = lean_nat_sub(v_nargs_3519_, v___x_3521_);
lean_dec(v_nargs_3519_);
v___x_3523_ = l___private_Lean_Expr_0__Lean_Expr_getAppArgsAux(v___x_3509_, v___x_3520_, v___x_3522_);
v___x_3524_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3524_, 0, v_us_3512_);
lean_ctor_set(v___x_3524_, 1, v___x_3523_);
v___x_3525_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3525_, 0, v_declName_3511_);
lean_ctor_set(v___x_3525_, 1, v___x_3524_);
v___x_3526_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3526_, 0, v_a_3517_);
lean_ctor_set(v___x_3526_, 1, v___x_3525_);
v___x_3527_ = lean_array_push(v_snd_3490_, v___x_3526_);
v_a_3496_ = v___x_3527_;
goto v___jp_3495_;
}
else
{
lean_object* v_a_3528_; lean_object* v___x_3530_; uint8_t v_isShared_3531_; uint8_t v_isSharedCheck_3535_; 
lean_dec(v_us_3512_);
lean_dec(v_declName_3511_);
lean_dec_ref(v___x_3509_);
lean_del_object(v___x_3492_);
lean_dec(v_snd_3490_);
v_a_3528_ = lean_ctor_get(v___x_3516_, 0);
v_isSharedCheck_3535_ = !lean_is_exclusive(v___x_3516_);
if (v_isSharedCheck_3535_ == 0)
{
v___x_3530_ = v___x_3516_;
v_isShared_3531_ = v_isSharedCheck_3535_;
goto v_resetjp_3529_;
}
else
{
lean_inc(v_a_3528_);
lean_dec(v___x_3516_);
v___x_3530_ = lean_box(0);
v_isShared_3531_ = v_isSharedCheck_3535_;
goto v_resetjp_3529_;
}
v_resetjp_3529_:
{
lean_object* v___x_3533_; 
if (v_isShared_3531_ == 0)
{
v___x_3533_ = v___x_3530_;
goto v_reusejp_3532_;
}
else
{
lean_object* v_reuseFailAlloc_3534_; 
v_reuseFailAlloc_3534_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3534_, 0, v_a_3528_);
v___x_3533_ = v_reuseFailAlloc_3534_;
goto v_reusejp_3532_;
}
v_reusejp_3532_:
{
return v___x_3533_;
}
}
}
}
}
else
{
lean_dec_ref(v___x_3510_);
lean_dec_ref(v___x_3509_);
v_a_3496_ = v_snd_3490_;
goto v___jp_3495_;
}
}
else
{
v_a_3496_ = v_snd_3490_;
goto v___jp_3495_;
}
}
else
{
v_a_3496_ = v_snd_3490_;
goto v___jp_3495_;
}
}
v___jp_3495_:
{
lean_object* v___x_3498_; 
if (v_isShared_3493_ == 0)
{
lean_ctor_set(v___x_3492_, 1, v_a_3496_);
lean_ctor_set(v___x_3492_, 0, v___x_3494_);
v___x_3498_ = v___x_3492_;
goto v_reusejp_3497_;
}
else
{
lean_object* v_reuseFailAlloc_3502_; 
v_reuseFailAlloc_3502_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3502_, 0, v___x_3494_);
lean_ctor_set(v_reuseFailAlloc_3502_, 1, v_a_3496_);
v___x_3498_ = v_reuseFailAlloc_3502_;
goto v_reusejp_3497_;
}
v_reusejp_3497_:
{
size_t v___x_3499_; size_t v___x_3500_; 
v___x_3499_ = ((size_t)1ULL);
v___x_3500_ = lean_usize_add(v_i_3479_, v___x_3499_);
v_i_3479_ = v___x_3500_;
v_b_3480_ = v___x_3498_;
goto _start;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5___redArg___boxed(lean_object* v___x_3538_, lean_object* v_interesting_3539_, lean_object* v_as_3540_, lean_object* v_sz_3541_, lean_object* v_i_3542_, lean_object* v_b_3543_, lean_object* v___y_3544_, lean_object* v___y_3545_, lean_object* v___y_3546_, lean_object* v___y_3547_, lean_object* v___y_3548_, lean_object* v___y_3549_, lean_object* v___y_3550_){
_start:
{
size_t v_sz_boxed_3551_; size_t v_i_boxed_3552_; lean_object* v_res_3553_; 
v_sz_boxed_3551_ = lean_unbox_usize(v_sz_3541_);
lean_dec(v_sz_3541_);
v_i_boxed_3552_ = lean_unbox_usize(v_i_3542_);
lean_dec(v_i_3542_);
v_res_3553_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5___redArg(v___x_3538_, v_interesting_3539_, v_as_3540_, v_sz_boxed_3551_, v_i_boxed_3552_, v_b_3543_, v___y_3544_, v___y_3545_, v___y_3546_, v___y_3547_, v___y_3548_, v___y_3549_);
lean_dec(v___y_3549_);
lean_dec_ref(v___y_3548_);
lean_dec(v___y_3547_);
lean_dec_ref(v___y_3546_);
lean_dec(v___y_3545_);
lean_dec_ref(v___y_3544_);
lean_dec_ref(v_as_3540_);
lean_dec_ref(v_interesting_3539_);
lean_dec(v___x_3538_);
return v_res_3553_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2(lean_object* v___x_3554_, lean_object* v_interesting_3555_, lean_object* v_as_3556_, size_t v_sz_3557_, size_t v_i_3558_, lean_object* v_b_3559_, lean_object* v___y_3560_, lean_object* v___y_3561_, lean_object* v___y_3562_, lean_object* v___y_3563_, lean_object* v___y_3564_, lean_object* v___y_3565_, lean_object* v___y_3566_, lean_object* v___y_3567_){
_start:
{
uint8_t v___x_3569_; 
v___x_3569_ = lean_usize_dec_lt(v_i_3558_, v_sz_3557_);
if (v___x_3569_ == 0)
{
lean_object* v___x_3570_; 
v___x_3570_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3570_, 0, v_b_3559_);
return v___x_3570_;
}
else
{
lean_object* v_snd_3571_; lean_object* v___x_3573_; uint8_t v_isShared_3574_; uint8_t v_isSharedCheck_3617_; 
v_snd_3571_ = lean_ctor_get(v_b_3559_, 1);
v_isSharedCheck_3617_ = !lean_is_exclusive(v_b_3559_);
if (v_isSharedCheck_3617_ == 0)
{
lean_object* v_unused_3618_; 
v_unused_3618_ = lean_ctor_get(v_b_3559_, 0);
lean_dec(v_unused_3618_);
v___x_3573_ = v_b_3559_;
v_isShared_3574_ = v_isSharedCheck_3617_;
goto v_resetjp_3572_;
}
else
{
lean_inc(v_snd_3571_);
lean_dec(v_b_3559_);
v___x_3573_ = lean_box(0);
v_isShared_3574_ = v_isSharedCheck_3617_;
goto v_resetjp_3572_;
}
v_resetjp_3572_:
{
lean_object* v___x_3575_; lean_object* v_a_3577_; lean_object* v_a_3584_; 
v___x_3575_ = lean_box(0);
v_a_3584_ = lean_array_uget_borrowed(v_as_3556_, v_i_3558_);
if (lean_obj_tag(v_a_3584_) == 0)
{
v_a_3577_ = v_snd_3571_;
goto v___jp_3576_;
}
else
{
lean_object* v_val_3585_; lean_object* v___x_3586_; uint8_t v___x_3587_; uint8_t v___x_3588_; 
v_val_3585_ = lean_ctor_get(v_a_3584_, 0);
v___x_3586_ = lean_unsigned_to_nat(0u);
v___x_3587_ = lean_nat_dec_eq(v___x_3554_, v___x_3586_);
v___x_3588_ = l_Lean_LocalDecl_isLet(v_val_3585_, v___x_3587_);
if (v___x_3588_ == 0)
{
uint8_t v___x_3589_; 
v___x_3589_ = l_Lean_LocalDecl_isImplementationDetail(v_val_3585_);
if (v___x_3589_ == 0)
{
lean_object* v___x_3590_; lean_object* v___x_3591_; 
v___x_3590_ = l_Lean_LocalDecl_type(v_val_3585_);
v___x_3591_ = l_Lean_Expr_getAppFn(v___x_3590_);
if (lean_obj_tag(v___x_3591_) == 4)
{
lean_object* v_declName_3592_; lean_object* v_us_3593_; uint8_t v___x_3594_; 
v_declName_3592_ = lean_ctor_get(v___x_3591_, 0);
lean_inc(v_declName_3592_);
v_us_3593_ = lean_ctor_get(v___x_3591_, 1);
lean_inc(v_us_3593_);
lean_dec_ref_known(v___x_3591_, 2);
v___x_3594_ = l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg(v_interesting_3555_, v_declName_3592_);
if (v___x_3594_ == 0)
{
lean_dec(v_us_3593_);
lean_dec(v_declName_3592_);
lean_dec_ref(v___x_3590_);
v_a_3577_ = v_snd_3571_;
goto v___jp_3576_;
}
else
{
lean_object* v___x_3595_; lean_object* v___x_3596_; lean_object* v___x_3597_; 
v___x_3595_ = l_Lean_LocalDecl_fvarId(v_val_3585_);
v___x_3596_ = l_Lean_mkFVar(v___x_3595_);
v___x_3597_ = l_Lean_Meta_Sym_shareCommonInc(v___x_3596_, v___y_3562_, v___y_3563_, v___y_3564_, v___y_3565_, v___y_3566_, v___y_3567_);
if (lean_obj_tag(v___x_3597_) == 0)
{
lean_object* v_a_3598_; lean_object* v_dummy_3599_; lean_object* v_nargs_3600_; lean_object* v___x_3601_; lean_object* v___x_3602_; lean_object* v___x_3603_; lean_object* v___x_3604_; lean_object* v___x_3605_; lean_object* v___x_3606_; lean_object* v___x_3607_; lean_object* v___x_3608_; 
v_a_3598_ = lean_ctor_get(v___x_3597_, 0);
lean_inc(v_a_3598_);
lean_dec_ref_known(v___x_3597_, 1);
v_dummy_3599_ = lean_obj_once(&l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0, &l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0_once, _init_l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0);
v_nargs_3600_ = l_Lean_Expr_getAppNumArgs(v___x_3590_);
lean_inc(v_nargs_3600_);
v___x_3601_ = lean_mk_array(v_nargs_3600_, v_dummy_3599_);
v___x_3602_ = lean_unsigned_to_nat(1u);
v___x_3603_ = lean_nat_sub(v_nargs_3600_, v___x_3602_);
lean_dec(v_nargs_3600_);
v___x_3604_ = l___private_Lean_Expr_0__Lean_Expr_getAppArgsAux(v___x_3590_, v___x_3601_, v___x_3603_);
v___x_3605_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3605_, 0, v_us_3593_);
lean_ctor_set(v___x_3605_, 1, v___x_3604_);
v___x_3606_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3606_, 0, v_declName_3592_);
lean_ctor_set(v___x_3606_, 1, v___x_3605_);
v___x_3607_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3607_, 0, v_a_3598_);
lean_ctor_set(v___x_3607_, 1, v___x_3606_);
v___x_3608_ = lean_array_push(v_snd_3571_, v___x_3607_);
v_a_3577_ = v___x_3608_;
goto v___jp_3576_;
}
else
{
lean_object* v_a_3609_; lean_object* v___x_3611_; uint8_t v_isShared_3612_; uint8_t v_isSharedCheck_3616_; 
lean_dec(v_us_3593_);
lean_dec(v_declName_3592_);
lean_dec_ref(v___x_3590_);
lean_del_object(v___x_3573_);
lean_dec(v_snd_3571_);
v_a_3609_ = lean_ctor_get(v___x_3597_, 0);
v_isSharedCheck_3616_ = !lean_is_exclusive(v___x_3597_);
if (v_isSharedCheck_3616_ == 0)
{
v___x_3611_ = v___x_3597_;
v_isShared_3612_ = v_isSharedCheck_3616_;
goto v_resetjp_3610_;
}
else
{
lean_inc(v_a_3609_);
lean_dec(v___x_3597_);
v___x_3611_ = lean_box(0);
v_isShared_3612_ = v_isSharedCheck_3616_;
goto v_resetjp_3610_;
}
v_resetjp_3610_:
{
lean_object* v___x_3614_; 
if (v_isShared_3612_ == 0)
{
v___x_3614_ = v___x_3611_;
goto v_reusejp_3613_;
}
else
{
lean_object* v_reuseFailAlloc_3615_; 
v_reuseFailAlloc_3615_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3615_, 0, v_a_3609_);
v___x_3614_ = v_reuseFailAlloc_3615_;
goto v_reusejp_3613_;
}
v_reusejp_3613_:
{
return v___x_3614_;
}
}
}
}
}
else
{
lean_dec_ref(v___x_3591_);
lean_dec_ref(v___x_3590_);
v_a_3577_ = v_snd_3571_;
goto v___jp_3576_;
}
}
else
{
v_a_3577_ = v_snd_3571_;
goto v___jp_3576_;
}
}
else
{
v_a_3577_ = v_snd_3571_;
goto v___jp_3576_;
}
}
v___jp_3576_:
{
lean_object* v___x_3579_; 
if (v_isShared_3574_ == 0)
{
lean_ctor_set(v___x_3573_, 1, v_a_3577_);
lean_ctor_set(v___x_3573_, 0, v___x_3575_);
v___x_3579_ = v___x_3573_;
goto v_reusejp_3578_;
}
else
{
lean_object* v_reuseFailAlloc_3583_; 
v_reuseFailAlloc_3583_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3583_, 0, v___x_3575_);
lean_ctor_set(v_reuseFailAlloc_3583_, 1, v_a_3577_);
v___x_3579_ = v_reuseFailAlloc_3583_;
goto v_reusejp_3578_;
}
v_reusejp_3578_:
{
size_t v___x_3580_; size_t v___x_3581_; lean_object* v___x_3582_; 
v___x_3580_ = ((size_t)1ULL);
v___x_3581_ = lean_usize_add(v_i_3558_, v___x_3580_);
v___x_3582_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5___redArg(v___x_3554_, v_interesting_3555_, v_as_3556_, v_sz_3557_, v___x_3581_, v___x_3579_, v___y_3562_, v___y_3563_, v___y_3564_, v___y_3565_, v___y_3566_, v___y_3567_);
return v___x_3582_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2___boxed(lean_object* v___x_3619_, lean_object* v_interesting_3620_, lean_object* v_as_3621_, lean_object* v_sz_3622_, lean_object* v_i_3623_, lean_object* v_b_3624_, lean_object* v___y_3625_, lean_object* v___y_3626_, lean_object* v___y_3627_, lean_object* v___y_3628_, lean_object* v___y_3629_, lean_object* v___y_3630_, lean_object* v___y_3631_, lean_object* v___y_3632_, lean_object* v___y_3633_){
_start:
{
size_t v_sz_boxed_3634_; size_t v_i_boxed_3635_; lean_object* v_res_3636_; 
v_sz_boxed_3634_ = lean_unbox_usize(v_sz_3622_);
lean_dec(v_sz_3622_);
v_i_boxed_3635_ = lean_unbox_usize(v_i_3623_);
lean_dec(v_i_3623_);
v_res_3636_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2(v___x_3619_, v_interesting_3620_, v_as_3621_, v_sz_boxed_3634_, v_i_boxed_3635_, v_b_3624_, v___y_3625_, v___y_3626_, v___y_3627_, v___y_3628_, v___y_3629_, v___y_3630_, v___y_3631_, v___y_3632_);
lean_dec(v___y_3632_);
lean_dec_ref(v___y_3631_);
lean_dec(v___y_3630_);
lean_dec_ref(v___y_3629_);
lean_dec(v___y_3628_);
lean_dec_ref(v___y_3627_);
lean_dec(v___y_3626_);
lean_dec_ref(v___y_3625_);
lean_dec_ref(v_as_3621_);
lean_dec_ref(v_interesting_3620_);
lean_dec(v___x_3619_);
return v_res_3636_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9___redArg(lean_object* v___x_3637_, lean_object* v_interesting_3638_, lean_object* v_as_3639_, size_t v_sz_3640_, size_t v_i_3641_, lean_object* v_b_3642_, lean_object* v___y_3643_, lean_object* v___y_3644_, lean_object* v___y_3645_, lean_object* v___y_3646_, lean_object* v___y_3647_, lean_object* v___y_3648_){
_start:
{
uint8_t v___x_3650_; 
v___x_3650_ = lean_usize_dec_lt(v_i_3641_, v_sz_3640_);
if (v___x_3650_ == 0)
{
lean_object* v___x_3651_; 
v___x_3651_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3651_, 0, v_b_3642_);
return v___x_3651_;
}
else
{
lean_object* v_snd_3652_; lean_object* v___x_3654_; uint8_t v_isShared_3655_; uint8_t v_isSharedCheck_3698_; 
v_snd_3652_ = lean_ctor_get(v_b_3642_, 1);
v_isSharedCheck_3698_ = !lean_is_exclusive(v_b_3642_);
if (v_isSharedCheck_3698_ == 0)
{
lean_object* v_unused_3699_; 
v_unused_3699_ = lean_ctor_get(v_b_3642_, 0);
lean_dec(v_unused_3699_);
v___x_3654_ = v_b_3642_;
v_isShared_3655_ = v_isSharedCheck_3698_;
goto v_resetjp_3653_;
}
else
{
lean_inc(v_snd_3652_);
lean_dec(v_b_3642_);
v___x_3654_ = lean_box(0);
v_isShared_3655_ = v_isSharedCheck_3698_;
goto v_resetjp_3653_;
}
v_resetjp_3653_:
{
lean_object* v___x_3656_; lean_object* v_a_3658_; lean_object* v_a_3665_; 
v___x_3656_ = lean_box(0);
v_a_3665_ = lean_array_uget_borrowed(v_as_3639_, v_i_3641_);
if (lean_obj_tag(v_a_3665_) == 0)
{
v_a_3658_ = v_snd_3652_;
goto v___jp_3657_;
}
else
{
lean_object* v_val_3666_; lean_object* v___x_3667_; uint8_t v___x_3668_; uint8_t v___x_3669_; 
v_val_3666_ = lean_ctor_get(v_a_3665_, 0);
v___x_3667_ = lean_unsigned_to_nat(0u);
v___x_3668_ = lean_nat_dec_eq(v___x_3637_, v___x_3667_);
v___x_3669_ = l_Lean_LocalDecl_isLet(v_val_3666_, v___x_3668_);
if (v___x_3669_ == 0)
{
uint8_t v___x_3670_; 
v___x_3670_ = l_Lean_LocalDecl_isImplementationDetail(v_val_3666_);
if (v___x_3670_ == 0)
{
lean_object* v___x_3671_; lean_object* v___x_3672_; 
v___x_3671_ = l_Lean_LocalDecl_type(v_val_3666_);
v___x_3672_ = l_Lean_Expr_getAppFn(v___x_3671_);
if (lean_obj_tag(v___x_3672_) == 4)
{
lean_object* v_declName_3673_; lean_object* v_us_3674_; uint8_t v___x_3675_; 
v_declName_3673_ = lean_ctor_get(v___x_3672_, 0);
lean_inc(v_declName_3673_);
v_us_3674_ = lean_ctor_get(v___x_3672_, 1);
lean_inc(v_us_3674_);
lean_dec_ref_known(v___x_3672_, 2);
v___x_3675_ = l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg(v_interesting_3638_, v_declName_3673_);
if (v___x_3675_ == 0)
{
lean_dec(v_us_3674_);
lean_dec(v_declName_3673_);
lean_dec_ref(v___x_3671_);
v_a_3658_ = v_snd_3652_;
goto v___jp_3657_;
}
else
{
lean_object* v___x_3676_; lean_object* v___x_3677_; lean_object* v___x_3678_; 
v___x_3676_ = l_Lean_LocalDecl_fvarId(v_val_3666_);
v___x_3677_ = l_Lean_mkFVar(v___x_3676_);
v___x_3678_ = l_Lean_Meta_Sym_shareCommonInc(v___x_3677_, v___y_3643_, v___y_3644_, v___y_3645_, v___y_3646_, v___y_3647_, v___y_3648_);
if (lean_obj_tag(v___x_3678_) == 0)
{
lean_object* v_a_3679_; lean_object* v_dummy_3680_; lean_object* v_nargs_3681_; lean_object* v___x_3682_; lean_object* v___x_3683_; lean_object* v___x_3684_; lean_object* v___x_3685_; lean_object* v___x_3686_; lean_object* v___x_3687_; lean_object* v___x_3688_; lean_object* v___x_3689_; 
v_a_3679_ = lean_ctor_get(v___x_3678_, 0);
lean_inc(v_a_3679_);
lean_dec_ref_known(v___x_3678_, 1);
v_dummy_3680_ = lean_obj_once(&l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0, &l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0_once, _init_l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0);
v_nargs_3681_ = l_Lean_Expr_getAppNumArgs(v___x_3671_);
lean_inc(v_nargs_3681_);
v___x_3682_ = lean_mk_array(v_nargs_3681_, v_dummy_3680_);
v___x_3683_ = lean_unsigned_to_nat(1u);
v___x_3684_ = lean_nat_sub(v_nargs_3681_, v___x_3683_);
lean_dec(v_nargs_3681_);
v___x_3685_ = l___private_Lean_Expr_0__Lean_Expr_getAppArgsAux(v___x_3671_, v___x_3682_, v___x_3684_);
v___x_3686_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3686_, 0, v_us_3674_);
lean_ctor_set(v___x_3686_, 1, v___x_3685_);
v___x_3687_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3687_, 0, v_declName_3673_);
lean_ctor_set(v___x_3687_, 1, v___x_3686_);
v___x_3688_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3688_, 0, v_a_3679_);
lean_ctor_set(v___x_3688_, 1, v___x_3687_);
v___x_3689_ = lean_array_push(v_snd_3652_, v___x_3688_);
v_a_3658_ = v___x_3689_;
goto v___jp_3657_;
}
else
{
lean_object* v_a_3690_; lean_object* v___x_3692_; uint8_t v_isShared_3693_; uint8_t v_isSharedCheck_3697_; 
lean_dec(v_us_3674_);
lean_dec(v_declName_3673_);
lean_dec_ref(v___x_3671_);
lean_del_object(v___x_3654_);
lean_dec(v_snd_3652_);
v_a_3690_ = lean_ctor_get(v___x_3678_, 0);
v_isSharedCheck_3697_ = !lean_is_exclusive(v___x_3678_);
if (v_isSharedCheck_3697_ == 0)
{
v___x_3692_ = v___x_3678_;
v_isShared_3693_ = v_isSharedCheck_3697_;
goto v_resetjp_3691_;
}
else
{
lean_inc(v_a_3690_);
lean_dec(v___x_3678_);
v___x_3692_ = lean_box(0);
v_isShared_3693_ = v_isSharedCheck_3697_;
goto v_resetjp_3691_;
}
v_resetjp_3691_:
{
lean_object* v___x_3695_; 
if (v_isShared_3693_ == 0)
{
v___x_3695_ = v___x_3692_;
goto v_reusejp_3694_;
}
else
{
lean_object* v_reuseFailAlloc_3696_; 
v_reuseFailAlloc_3696_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3696_, 0, v_a_3690_);
v___x_3695_ = v_reuseFailAlloc_3696_;
goto v_reusejp_3694_;
}
v_reusejp_3694_:
{
return v___x_3695_;
}
}
}
}
}
else
{
lean_dec_ref(v___x_3672_);
lean_dec_ref(v___x_3671_);
v_a_3658_ = v_snd_3652_;
goto v___jp_3657_;
}
}
else
{
v_a_3658_ = v_snd_3652_;
goto v___jp_3657_;
}
}
else
{
v_a_3658_ = v_snd_3652_;
goto v___jp_3657_;
}
}
v___jp_3657_:
{
lean_object* v___x_3660_; 
if (v_isShared_3655_ == 0)
{
lean_ctor_set(v___x_3654_, 1, v_a_3658_);
lean_ctor_set(v___x_3654_, 0, v___x_3656_);
v___x_3660_ = v___x_3654_;
goto v_reusejp_3659_;
}
else
{
lean_object* v_reuseFailAlloc_3664_; 
v_reuseFailAlloc_3664_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3664_, 0, v___x_3656_);
lean_ctor_set(v_reuseFailAlloc_3664_, 1, v_a_3658_);
v___x_3660_ = v_reuseFailAlloc_3664_;
goto v_reusejp_3659_;
}
v_reusejp_3659_:
{
size_t v___x_3661_; size_t v___x_3662_; 
v___x_3661_ = ((size_t)1ULL);
v___x_3662_ = lean_usize_add(v_i_3641_, v___x_3661_);
v_i_3641_ = v___x_3662_;
v_b_3642_ = v___x_3660_;
goto _start;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9___redArg___boxed(lean_object* v___x_3700_, lean_object* v_interesting_3701_, lean_object* v_as_3702_, lean_object* v_sz_3703_, lean_object* v_i_3704_, lean_object* v_b_3705_, lean_object* v___y_3706_, lean_object* v___y_3707_, lean_object* v___y_3708_, lean_object* v___y_3709_, lean_object* v___y_3710_, lean_object* v___y_3711_, lean_object* v___y_3712_){
_start:
{
size_t v_sz_boxed_3713_; size_t v_i_boxed_3714_; lean_object* v_res_3715_; 
v_sz_boxed_3713_ = lean_unbox_usize(v_sz_3703_);
lean_dec(v_sz_3703_);
v_i_boxed_3714_ = lean_unbox_usize(v_i_3704_);
lean_dec(v_i_3704_);
v_res_3715_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9___redArg(v___x_3700_, v_interesting_3701_, v_as_3702_, v_sz_boxed_3713_, v_i_boxed_3714_, v_b_3705_, v___y_3706_, v___y_3707_, v___y_3708_, v___y_3709_, v___y_3710_, v___y_3711_);
lean_dec(v___y_3711_);
lean_dec_ref(v___y_3710_);
lean_dec(v___y_3709_);
lean_dec_ref(v___y_3708_);
lean_dec(v___y_3707_);
lean_dec_ref(v___y_3706_);
lean_dec_ref(v_as_3702_);
lean_dec_ref(v_interesting_3701_);
lean_dec(v___x_3700_);
return v_res_3715_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3(lean_object* v___x_3716_, lean_object* v_interesting_3717_, lean_object* v_as_3718_, size_t v_sz_3719_, size_t v_i_3720_, lean_object* v_b_3721_, lean_object* v___y_3722_, lean_object* v___y_3723_, lean_object* v___y_3724_, lean_object* v___y_3725_, lean_object* v___y_3726_, lean_object* v___y_3727_, lean_object* v___y_3728_, lean_object* v___y_3729_){
_start:
{
uint8_t v___x_3731_; 
v___x_3731_ = lean_usize_dec_lt(v_i_3720_, v_sz_3719_);
if (v___x_3731_ == 0)
{
lean_object* v___x_3732_; 
v___x_3732_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3732_, 0, v_b_3721_);
return v___x_3732_;
}
else
{
lean_object* v_snd_3733_; lean_object* v___x_3735_; uint8_t v_isShared_3736_; uint8_t v_isSharedCheck_3779_; 
v_snd_3733_ = lean_ctor_get(v_b_3721_, 1);
v_isSharedCheck_3779_ = !lean_is_exclusive(v_b_3721_);
if (v_isSharedCheck_3779_ == 0)
{
lean_object* v_unused_3780_; 
v_unused_3780_ = lean_ctor_get(v_b_3721_, 0);
lean_dec(v_unused_3780_);
v___x_3735_ = v_b_3721_;
v_isShared_3736_ = v_isSharedCheck_3779_;
goto v_resetjp_3734_;
}
else
{
lean_inc(v_snd_3733_);
lean_dec(v_b_3721_);
v___x_3735_ = lean_box(0);
v_isShared_3736_ = v_isSharedCheck_3779_;
goto v_resetjp_3734_;
}
v_resetjp_3734_:
{
lean_object* v___x_3737_; lean_object* v_a_3739_; lean_object* v_a_3746_; 
v___x_3737_ = lean_box(0);
v_a_3746_ = lean_array_uget_borrowed(v_as_3718_, v_i_3720_);
if (lean_obj_tag(v_a_3746_) == 0)
{
v_a_3739_ = v_snd_3733_;
goto v___jp_3738_;
}
else
{
lean_object* v_val_3747_; lean_object* v___x_3748_; uint8_t v___x_3749_; uint8_t v___x_3750_; 
v_val_3747_ = lean_ctor_get(v_a_3746_, 0);
v___x_3748_ = lean_unsigned_to_nat(0u);
v___x_3749_ = lean_nat_dec_eq(v___x_3716_, v___x_3748_);
v___x_3750_ = l_Lean_LocalDecl_isLet(v_val_3747_, v___x_3749_);
if (v___x_3750_ == 0)
{
uint8_t v___x_3751_; 
v___x_3751_ = l_Lean_LocalDecl_isImplementationDetail(v_val_3747_);
if (v___x_3751_ == 0)
{
lean_object* v___x_3752_; lean_object* v___x_3753_; 
v___x_3752_ = l_Lean_LocalDecl_type(v_val_3747_);
v___x_3753_ = l_Lean_Expr_getAppFn(v___x_3752_);
if (lean_obj_tag(v___x_3753_) == 4)
{
lean_object* v_declName_3754_; lean_object* v_us_3755_; uint8_t v___x_3756_; 
v_declName_3754_ = lean_ctor_get(v___x_3753_, 0);
lean_inc(v_declName_3754_);
v_us_3755_ = lean_ctor_get(v___x_3753_, 1);
lean_inc(v_us_3755_);
lean_dec_ref_known(v___x_3753_, 2);
v___x_3756_ = l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg(v_interesting_3717_, v_declName_3754_);
if (v___x_3756_ == 0)
{
lean_dec(v_us_3755_);
lean_dec(v_declName_3754_);
lean_dec_ref(v___x_3752_);
v_a_3739_ = v_snd_3733_;
goto v___jp_3738_;
}
else
{
lean_object* v___x_3757_; lean_object* v___x_3758_; lean_object* v___x_3759_; 
v___x_3757_ = l_Lean_LocalDecl_fvarId(v_val_3747_);
v___x_3758_ = l_Lean_mkFVar(v___x_3757_);
v___x_3759_ = l_Lean_Meta_Sym_shareCommonInc(v___x_3758_, v___y_3724_, v___y_3725_, v___y_3726_, v___y_3727_, v___y_3728_, v___y_3729_);
if (lean_obj_tag(v___x_3759_) == 0)
{
lean_object* v_a_3760_; lean_object* v_dummy_3761_; lean_object* v_nargs_3762_; lean_object* v___x_3763_; lean_object* v___x_3764_; lean_object* v___x_3765_; lean_object* v___x_3766_; lean_object* v___x_3767_; lean_object* v___x_3768_; lean_object* v___x_3769_; lean_object* v___x_3770_; 
v_a_3760_ = lean_ctor_get(v___x_3759_, 0);
lean_inc(v_a_3760_);
lean_dec_ref_known(v___x_3759_, 1);
v_dummy_3761_ = lean_obj_once(&l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0, &l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0_once, _init_l_Lean_Expr_withAppAux___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_projCtorProc_spec__2___closed__0);
v_nargs_3762_ = l_Lean_Expr_getAppNumArgs(v___x_3752_);
lean_inc(v_nargs_3762_);
v___x_3763_ = lean_mk_array(v_nargs_3762_, v_dummy_3761_);
v___x_3764_ = lean_unsigned_to_nat(1u);
v___x_3765_ = lean_nat_sub(v_nargs_3762_, v___x_3764_);
lean_dec(v_nargs_3762_);
v___x_3766_ = l___private_Lean_Expr_0__Lean_Expr_getAppArgsAux(v___x_3752_, v___x_3763_, v___x_3765_);
v___x_3767_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3767_, 0, v_us_3755_);
lean_ctor_set(v___x_3767_, 1, v___x_3766_);
v___x_3768_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3768_, 0, v_declName_3754_);
lean_ctor_set(v___x_3768_, 1, v___x_3767_);
v___x_3769_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3769_, 0, v_a_3760_);
lean_ctor_set(v___x_3769_, 1, v___x_3768_);
v___x_3770_ = lean_array_push(v_snd_3733_, v___x_3769_);
v_a_3739_ = v___x_3770_;
goto v___jp_3738_;
}
else
{
lean_object* v_a_3771_; lean_object* v___x_3773_; uint8_t v_isShared_3774_; uint8_t v_isSharedCheck_3778_; 
lean_dec(v_us_3755_);
lean_dec(v_declName_3754_);
lean_dec_ref(v___x_3752_);
lean_del_object(v___x_3735_);
lean_dec(v_snd_3733_);
v_a_3771_ = lean_ctor_get(v___x_3759_, 0);
v_isSharedCheck_3778_ = !lean_is_exclusive(v___x_3759_);
if (v_isSharedCheck_3778_ == 0)
{
v___x_3773_ = v___x_3759_;
v_isShared_3774_ = v_isSharedCheck_3778_;
goto v_resetjp_3772_;
}
else
{
lean_inc(v_a_3771_);
lean_dec(v___x_3759_);
v___x_3773_ = lean_box(0);
v_isShared_3774_ = v_isSharedCheck_3778_;
goto v_resetjp_3772_;
}
v_resetjp_3772_:
{
lean_object* v___x_3776_; 
if (v_isShared_3774_ == 0)
{
v___x_3776_ = v___x_3773_;
goto v_reusejp_3775_;
}
else
{
lean_object* v_reuseFailAlloc_3777_; 
v_reuseFailAlloc_3777_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3777_, 0, v_a_3771_);
v___x_3776_ = v_reuseFailAlloc_3777_;
goto v_reusejp_3775_;
}
v_reusejp_3775_:
{
return v___x_3776_;
}
}
}
}
}
else
{
lean_dec_ref(v___x_3753_);
lean_dec_ref(v___x_3752_);
v_a_3739_ = v_snd_3733_;
goto v___jp_3738_;
}
}
else
{
v_a_3739_ = v_snd_3733_;
goto v___jp_3738_;
}
}
else
{
v_a_3739_ = v_snd_3733_;
goto v___jp_3738_;
}
}
v___jp_3738_:
{
lean_object* v___x_3741_; 
if (v_isShared_3736_ == 0)
{
lean_ctor_set(v___x_3735_, 1, v_a_3739_);
lean_ctor_set(v___x_3735_, 0, v___x_3737_);
v___x_3741_ = v___x_3735_;
goto v_reusejp_3740_;
}
else
{
lean_object* v_reuseFailAlloc_3745_; 
v_reuseFailAlloc_3745_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3745_, 0, v___x_3737_);
lean_ctor_set(v_reuseFailAlloc_3745_, 1, v_a_3739_);
v___x_3741_ = v_reuseFailAlloc_3745_;
goto v_reusejp_3740_;
}
v_reusejp_3740_:
{
size_t v___x_3742_; size_t v___x_3743_; lean_object* v___x_3744_; 
v___x_3742_ = ((size_t)1ULL);
v___x_3743_ = lean_usize_add(v_i_3720_, v___x_3742_);
v___x_3744_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9___redArg(v___x_3716_, v_interesting_3717_, v_as_3718_, v_sz_3719_, v___x_3743_, v___x_3741_, v___y_3724_, v___y_3725_, v___y_3726_, v___y_3727_, v___y_3728_, v___y_3729_);
return v___x_3744_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3___boxed(lean_object* v___x_3781_, lean_object* v_interesting_3782_, lean_object* v_as_3783_, lean_object* v_sz_3784_, lean_object* v_i_3785_, lean_object* v_b_3786_, lean_object* v___y_3787_, lean_object* v___y_3788_, lean_object* v___y_3789_, lean_object* v___y_3790_, lean_object* v___y_3791_, lean_object* v___y_3792_, lean_object* v___y_3793_, lean_object* v___y_3794_, lean_object* v___y_3795_){
_start:
{
size_t v_sz_boxed_3796_; size_t v_i_boxed_3797_; lean_object* v_res_3798_; 
v_sz_boxed_3796_ = lean_unbox_usize(v_sz_3784_);
lean_dec(v_sz_3784_);
v_i_boxed_3797_ = lean_unbox_usize(v_i_3785_);
lean_dec(v_i_3785_);
v_res_3798_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3(v___x_3781_, v_interesting_3782_, v_as_3783_, v_sz_boxed_3796_, v_i_boxed_3797_, v_b_3786_, v___y_3787_, v___y_3788_, v___y_3789_, v___y_3790_, v___y_3791_, v___y_3792_, v___y_3793_, v___y_3794_);
lean_dec(v___y_3794_);
lean_dec_ref(v___y_3793_);
lean_dec(v___y_3792_);
lean_dec_ref(v___y_3791_);
lean_dec(v___y_3790_);
lean_dec_ref(v___y_3789_);
lean_dec(v___y_3788_);
lean_dec_ref(v___y_3787_);
lean_dec_ref(v_as_3783_);
lean_dec_ref(v_interesting_3782_);
lean_dec(v___x_3781_);
return v_res_3798_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1(lean_object* v_init_3799_, lean_object* v___x_3800_, lean_object* v_interesting_3801_, lean_object* v_n_3802_, lean_object* v_b_3803_, lean_object* v___y_3804_, lean_object* v___y_3805_, lean_object* v___y_3806_, lean_object* v___y_3807_, lean_object* v___y_3808_, lean_object* v___y_3809_, lean_object* v___y_3810_, lean_object* v___y_3811_){
_start:
{
if (lean_obj_tag(v_n_3802_) == 0)
{
lean_object* v_cs_3813_; lean_object* v___x_3814_; lean_object* v___x_3815_; size_t v_sz_3816_; size_t v___x_3817_; lean_object* v___x_3818_; 
v_cs_3813_ = lean_ctor_get(v_n_3802_, 0);
v___x_3814_ = lean_box(0);
v___x_3815_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3815_, 0, v___x_3814_);
lean_ctor_set(v___x_3815_, 1, v_b_3803_);
v_sz_3816_ = lean_array_size(v_cs_3813_);
v___x_3817_ = ((size_t)0ULL);
v___x_3818_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__2(v_init_3799_, v___x_3800_, v_interesting_3801_, v_cs_3813_, v_sz_3816_, v___x_3817_, v___x_3815_, v___y_3804_, v___y_3805_, v___y_3806_, v___y_3807_, v___y_3808_, v___y_3809_, v___y_3810_, v___y_3811_);
if (lean_obj_tag(v___x_3818_) == 0)
{
lean_object* v_a_3819_; lean_object* v___x_3821_; uint8_t v_isShared_3822_; uint8_t v_isSharedCheck_3833_; 
v_a_3819_ = lean_ctor_get(v___x_3818_, 0);
v_isSharedCheck_3833_ = !lean_is_exclusive(v___x_3818_);
if (v_isSharedCheck_3833_ == 0)
{
v___x_3821_ = v___x_3818_;
v_isShared_3822_ = v_isSharedCheck_3833_;
goto v_resetjp_3820_;
}
else
{
lean_inc(v_a_3819_);
lean_dec(v___x_3818_);
v___x_3821_ = lean_box(0);
v_isShared_3822_ = v_isSharedCheck_3833_;
goto v_resetjp_3820_;
}
v_resetjp_3820_:
{
lean_object* v_fst_3823_; 
v_fst_3823_ = lean_ctor_get(v_a_3819_, 0);
if (lean_obj_tag(v_fst_3823_) == 0)
{
lean_object* v_snd_3824_; lean_object* v___x_3825_; lean_object* v___x_3827_; 
v_snd_3824_ = lean_ctor_get(v_a_3819_, 1);
lean_inc(v_snd_3824_);
lean_dec(v_a_3819_);
v___x_3825_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_3825_, 0, v_snd_3824_);
if (v_isShared_3822_ == 0)
{
lean_ctor_set(v___x_3821_, 0, v___x_3825_);
v___x_3827_ = v___x_3821_;
goto v_reusejp_3826_;
}
else
{
lean_object* v_reuseFailAlloc_3828_; 
v_reuseFailAlloc_3828_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3828_, 0, v___x_3825_);
v___x_3827_ = v_reuseFailAlloc_3828_;
goto v_reusejp_3826_;
}
v_reusejp_3826_:
{
return v___x_3827_;
}
}
else
{
lean_object* v_val_3829_; lean_object* v___x_3831_; 
lean_inc_ref(v_fst_3823_);
lean_dec(v_a_3819_);
v_val_3829_ = lean_ctor_get(v_fst_3823_, 0);
lean_inc(v_val_3829_);
lean_dec_ref_known(v_fst_3823_, 1);
if (v_isShared_3822_ == 0)
{
lean_ctor_set(v___x_3821_, 0, v_val_3829_);
v___x_3831_ = v___x_3821_;
goto v_reusejp_3830_;
}
else
{
lean_object* v_reuseFailAlloc_3832_; 
v_reuseFailAlloc_3832_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3832_, 0, v_val_3829_);
v___x_3831_ = v_reuseFailAlloc_3832_;
goto v_reusejp_3830_;
}
v_reusejp_3830_:
{
return v___x_3831_;
}
}
}
}
else
{
lean_object* v_a_3834_; lean_object* v___x_3836_; uint8_t v_isShared_3837_; uint8_t v_isSharedCheck_3841_; 
v_a_3834_ = lean_ctor_get(v___x_3818_, 0);
v_isSharedCheck_3841_ = !lean_is_exclusive(v___x_3818_);
if (v_isSharedCheck_3841_ == 0)
{
v___x_3836_ = v___x_3818_;
v_isShared_3837_ = v_isSharedCheck_3841_;
goto v_resetjp_3835_;
}
else
{
lean_inc(v_a_3834_);
lean_dec(v___x_3818_);
v___x_3836_ = lean_box(0);
v_isShared_3837_ = v_isSharedCheck_3841_;
goto v_resetjp_3835_;
}
v_resetjp_3835_:
{
lean_object* v___x_3839_; 
if (v_isShared_3837_ == 0)
{
v___x_3839_ = v___x_3836_;
goto v_reusejp_3838_;
}
else
{
lean_object* v_reuseFailAlloc_3840_; 
v_reuseFailAlloc_3840_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3840_, 0, v_a_3834_);
v___x_3839_ = v_reuseFailAlloc_3840_;
goto v_reusejp_3838_;
}
v_reusejp_3838_:
{
return v___x_3839_;
}
}
}
}
else
{
lean_object* v_vs_3842_; lean_object* v___x_3843_; lean_object* v___x_3844_; size_t v_sz_3845_; size_t v___x_3846_; lean_object* v___x_3847_; 
v_vs_3842_ = lean_ctor_get(v_n_3802_, 0);
v___x_3843_ = lean_box(0);
v___x_3844_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3844_, 0, v___x_3843_);
lean_ctor_set(v___x_3844_, 1, v_b_3803_);
v_sz_3845_ = lean_array_size(v_vs_3842_);
v___x_3846_ = ((size_t)0ULL);
v___x_3847_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3(v___x_3800_, v_interesting_3801_, v_vs_3842_, v_sz_3845_, v___x_3846_, v___x_3844_, v___y_3804_, v___y_3805_, v___y_3806_, v___y_3807_, v___y_3808_, v___y_3809_, v___y_3810_, v___y_3811_);
if (lean_obj_tag(v___x_3847_) == 0)
{
lean_object* v_a_3848_; lean_object* v___x_3850_; uint8_t v_isShared_3851_; uint8_t v_isSharedCheck_3862_; 
v_a_3848_ = lean_ctor_get(v___x_3847_, 0);
v_isSharedCheck_3862_ = !lean_is_exclusive(v___x_3847_);
if (v_isSharedCheck_3862_ == 0)
{
v___x_3850_ = v___x_3847_;
v_isShared_3851_ = v_isSharedCheck_3862_;
goto v_resetjp_3849_;
}
else
{
lean_inc(v_a_3848_);
lean_dec(v___x_3847_);
v___x_3850_ = lean_box(0);
v_isShared_3851_ = v_isSharedCheck_3862_;
goto v_resetjp_3849_;
}
v_resetjp_3849_:
{
lean_object* v_fst_3852_; 
v_fst_3852_ = lean_ctor_get(v_a_3848_, 0);
if (lean_obj_tag(v_fst_3852_) == 0)
{
lean_object* v_snd_3853_; lean_object* v___x_3854_; lean_object* v___x_3856_; 
v_snd_3853_ = lean_ctor_get(v_a_3848_, 1);
lean_inc(v_snd_3853_);
lean_dec(v_a_3848_);
v___x_3854_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_3854_, 0, v_snd_3853_);
if (v_isShared_3851_ == 0)
{
lean_ctor_set(v___x_3850_, 0, v___x_3854_);
v___x_3856_ = v___x_3850_;
goto v_reusejp_3855_;
}
else
{
lean_object* v_reuseFailAlloc_3857_; 
v_reuseFailAlloc_3857_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3857_, 0, v___x_3854_);
v___x_3856_ = v_reuseFailAlloc_3857_;
goto v_reusejp_3855_;
}
v_reusejp_3855_:
{
return v___x_3856_;
}
}
else
{
lean_object* v_val_3858_; lean_object* v___x_3860_; 
lean_inc_ref(v_fst_3852_);
lean_dec(v_a_3848_);
v_val_3858_ = lean_ctor_get(v_fst_3852_, 0);
lean_inc(v_val_3858_);
lean_dec_ref_known(v_fst_3852_, 1);
if (v_isShared_3851_ == 0)
{
lean_ctor_set(v___x_3850_, 0, v_val_3858_);
v___x_3860_ = v___x_3850_;
goto v_reusejp_3859_;
}
else
{
lean_object* v_reuseFailAlloc_3861_; 
v_reuseFailAlloc_3861_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3861_, 0, v_val_3858_);
v___x_3860_ = v_reuseFailAlloc_3861_;
goto v_reusejp_3859_;
}
v_reusejp_3859_:
{
return v___x_3860_;
}
}
}
}
else
{
lean_object* v_a_3863_; lean_object* v___x_3865_; uint8_t v_isShared_3866_; uint8_t v_isSharedCheck_3870_; 
v_a_3863_ = lean_ctor_get(v___x_3847_, 0);
v_isSharedCheck_3870_ = !lean_is_exclusive(v___x_3847_);
if (v_isSharedCheck_3870_ == 0)
{
v___x_3865_ = v___x_3847_;
v_isShared_3866_ = v_isSharedCheck_3870_;
goto v_resetjp_3864_;
}
else
{
lean_inc(v_a_3863_);
lean_dec(v___x_3847_);
v___x_3865_ = lean_box(0);
v_isShared_3866_ = v_isSharedCheck_3870_;
goto v_resetjp_3864_;
}
v_resetjp_3864_:
{
lean_object* v___x_3868_; 
if (v_isShared_3866_ == 0)
{
v___x_3868_ = v___x_3865_;
goto v_reusejp_3867_;
}
else
{
lean_object* v_reuseFailAlloc_3869_; 
v_reuseFailAlloc_3869_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3869_, 0, v_a_3863_);
v___x_3868_ = v_reuseFailAlloc_3869_;
goto v_reusejp_3867_;
}
v_reusejp_3867_:
{
return v___x_3868_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__2(lean_object* v_init_3871_, lean_object* v___x_3872_, lean_object* v_interesting_3873_, lean_object* v_as_3874_, size_t v_sz_3875_, size_t v_i_3876_, lean_object* v_b_3877_, lean_object* v___y_3878_, lean_object* v___y_3879_, lean_object* v___y_3880_, lean_object* v___y_3881_, lean_object* v___y_3882_, lean_object* v___y_3883_, lean_object* v___y_3884_, lean_object* v___y_3885_){
_start:
{
uint8_t v___x_3887_; 
v___x_3887_ = lean_usize_dec_lt(v_i_3876_, v_sz_3875_);
if (v___x_3887_ == 0)
{
lean_object* v___x_3888_; 
v___x_3888_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3888_, 0, v_b_3877_);
return v___x_3888_;
}
else
{
lean_object* v_snd_3889_; lean_object* v___x_3891_; uint8_t v_isShared_3892_; uint8_t v_isSharedCheck_3923_; 
v_snd_3889_ = lean_ctor_get(v_b_3877_, 1);
v_isSharedCheck_3923_ = !lean_is_exclusive(v_b_3877_);
if (v_isSharedCheck_3923_ == 0)
{
lean_object* v_unused_3924_; 
v_unused_3924_ = lean_ctor_get(v_b_3877_, 0);
lean_dec(v_unused_3924_);
v___x_3891_ = v_b_3877_;
v_isShared_3892_ = v_isSharedCheck_3923_;
goto v_resetjp_3890_;
}
else
{
lean_inc(v_snd_3889_);
lean_dec(v_b_3877_);
v___x_3891_ = lean_box(0);
v_isShared_3892_ = v_isSharedCheck_3923_;
goto v_resetjp_3890_;
}
v_resetjp_3890_:
{
lean_object* v_a_3893_; lean_object* v___x_3894_; 
v_a_3893_ = lean_array_uget_borrowed(v_as_3874_, v_i_3876_);
lean_inc(v_snd_3889_);
v___x_3894_ = l_Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1(v_init_3871_, v___x_3872_, v_interesting_3873_, v_a_3893_, v_snd_3889_, v___y_3878_, v___y_3879_, v___y_3880_, v___y_3881_, v___y_3882_, v___y_3883_, v___y_3884_, v___y_3885_);
if (lean_obj_tag(v___x_3894_) == 0)
{
lean_object* v_a_3895_; lean_object* v___x_3897_; uint8_t v_isShared_3898_; uint8_t v_isSharedCheck_3914_; 
v_a_3895_ = lean_ctor_get(v___x_3894_, 0);
v_isSharedCheck_3914_ = !lean_is_exclusive(v___x_3894_);
if (v_isSharedCheck_3914_ == 0)
{
v___x_3897_ = v___x_3894_;
v_isShared_3898_ = v_isSharedCheck_3914_;
goto v_resetjp_3896_;
}
else
{
lean_inc(v_a_3895_);
lean_dec(v___x_3894_);
v___x_3897_ = lean_box(0);
v_isShared_3898_ = v_isSharedCheck_3914_;
goto v_resetjp_3896_;
}
v_resetjp_3896_:
{
if (lean_obj_tag(v_a_3895_) == 0)
{
lean_object* v___x_3899_; lean_object* v___x_3901_; 
v___x_3899_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_3899_, 0, v_a_3895_);
if (v_isShared_3892_ == 0)
{
lean_ctor_set(v___x_3891_, 0, v___x_3899_);
v___x_3901_ = v___x_3891_;
goto v_reusejp_3900_;
}
else
{
lean_object* v_reuseFailAlloc_3905_; 
v_reuseFailAlloc_3905_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3905_, 0, v___x_3899_);
lean_ctor_set(v_reuseFailAlloc_3905_, 1, v_snd_3889_);
v___x_3901_ = v_reuseFailAlloc_3905_;
goto v_reusejp_3900_;
}
v_reusejp_3900_:
{
lean_object* v___x_3903_; 
if (v_isShared_3898_ == 0)
{
lean_ctor_set(v___x_3897_, 0, v___x_3901_);
v___x_3903_ = v___x_3897_;
goto v_reusejp_3902_;
}
else
{
lean_object* v_reuseFailAlloc_3904_; 
v_reuseFailAlloc_3904_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3904_, 0, v___x_3901_);
v___x_3903_ = v_reuseFailAlloc_3904_;
goto v_reusejp_3902_;
}
v_reusejp_3902_:
{
return v___x_3903_;
}
}
}
else
{
lean_object* v_a_3906_; lean_object* v___x_3907_; lean_object* v___x_3909_; 
lean_del_object(v___x_3897_);
lean_dec(v_snd_3889_);
v_a_3906_ = lean_ctor_get(v_a_3895_, 0);
lean_inc(v_a_3906_);
lean_dec_ref_known(v_a_3895_, 1);
v___x_3907_ = lean_box(0);
if (v_isShared_3892_ == 0)
{
lean_ctor_set(v___x_3891_, 1, v_a_3906_);
lean_ctor_set(v___x_3891_, 0, v___x_3907_);
v___x_3909_ = v___x_3891_;
goto v_reusejp_3908_;
}
else
{
lean_object* v_reuseFailAlloc_3913_; 
v_reuseFailAlloc_3913_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3913_, 0, v___x_3907_);
lean_ctor_set(v_reuseFailAlloc_3913_, 1, v_a_3906_);
v___x_3909_ = v_reuseFailAlloc_3913_;
goto v_reusejp_3908_;
}
v_reusejp_3908_:
{
size_t v___x_3910_; size_t v___x_3911_; 
v___x_3910_ = ((size_t)1ULL);
v___x_3911_ = lean_usize_add(v_i_3876_, v___x_3910_);
v_i_3876_ = v___x_3911_;
v_b_3877_ = v___x_3909_;
goto _start;
}
}
}
}
else
{
lean_object* v_a_3915_; lean_object* v___x_3917_; uint8_t v_isShared_3918_; uint8_t v_isSharedCheck_3922_; 
lean_del_object(v___x_3891_);
lean_dec(v_snd_3889_);
v_a_3915_ = lean_ctor_get(v___x_3894_, 0);
v_isSharedCheck_3922_ = !lean_is_exclusive(v___x_3894_);
if (v_isSharedCheck_3922_ == 0)
{
v___x_3917_ = v___x_3894_;
v_isShared_3918_ = v_isSharedCheck_3922_;
goto v_resetjp_3916_;
}
else
{
lean_inc(v_a_3915_);
lean_dec(v___x_3894_);
v___x_3917_ = lean_box(0);
v_isShared_3918_ = v_isSharedCheck_3922_;
goto v_resetjp_3916_;
}
v_resetjp_3916_:
{
lean_object* v___x_3920_; 
if (v_isShared_3918_ == 0)
{
v___x_3920_ = v___x_3917_;
goto v_reusejp_3919_;
}
else
{
lean_object* v_reuseFailAlloc_3921_; 
v_reuseFailAlloc_3921_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3921_, 0, v_a_3915_);
v___x_3920_ = v_reuseFailAlloc_3921_;
goto v_reusejp_3919_;
}
v_reusejp_3919_:
{
return v___x_3920_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__2___boxed(lean_object* v_init_3925_, lean_object* v___x_3926_, lean_object* v_interesting_3927_, lean_object* v_as_3928_, lean_object* v_sz_3929_, lean_object* v_i_3930_, lean_object* v_b_3931_, lean_object* v___y_3932_, lean_object* v___y_3933_, lean_object* v___y_3934_, lean_object* v___y_3935_, lean_object* v___y_3936_, lean_object* v___y_3937_, lean_object* v___y_3938_, lean_object* v___y_3939_, lean_object* v___y_3940_){
_start:
{
size_t v_sz_boxed_3941_; size_t v_i_boxed_3942_; lean_object* v_res_3943_; 
v_sz_boxed_3941_ = lean_unbox_usize(v_sz_3929_);
lean_dec(v_sz_3929_);
v_i_boxed_3942_ = lean_unbox_usize(v_i_3930_);
lean_dec(v_i_3930_);
v_res_3943_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__2(v_init_3925_, v___x_3926_, v_interesting_3927_, v_as_3928_, v_sz_boxed_3941_, v_i_boxed_3942_, v_b_3931_, v___y_3932_, v___y_3933_, v___y_3934_, v___y_3935_, v___y_3936_, v___y_3937_, v___y_3938_, v___y_3939_);
lean_dec(v___y_3939_);
lean_dec_ref(v___y_3938_);
lean_dec(v___y_3937_);
lean_dec_ref(v___y_3936_);
lean_dec(v___y_3935_);
lean_dec_ref(v___y_3934_);
lean_dec(v___y_3933_);
lean_dec_ref(v___y_3932_);
lean_dec_ref(v_as_3928_);
lean_dec_ref(v_interesting_3927_);
lean_dec(v___x_3926_);
lean_dec_ref(v_init_3925_);
return v_res_3943_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1___boxed(lean_object* v_init_3944_, lean_object* v___x_3945_, lean_object* v_interesting_3946_, lean_object* v_n_3947_, lean_object* v_b_3948_, lean_object* v___y_3949_, lean_object* v___y_3950_, lean_object* v___y_3951_, lean_object* v___y_3952_, lean_object* v___y_3953_, lean_object* v___y_3954_, lean_object* v___y_3955_, lean_object* v___y_3956_, lean_object* v___y_3957_){
_start:
{
lean_object* v_res_3958_; 
v_res_3958_ = l_Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1(v_init_3944_, v___x_3945_, v_interesting_3946_, v_n_3947_, v_b_3948_, v___y_3949_, v___y_3950_, v___y_3951_, v___y_3952_, v___y_3953_, v___y_3954_, v___y_3955_, v___y_3956_);
lean_dec(v___y_3956_);
lean_dec_ref(v___y_3955_);
lean_dec(v___y_3954_);
lean_dec_ref(v___y_3953_);
lean_dec(v___y_3952_);
lean_dec_ref(v___y_3951_);
lean_dec(v___y_3950_);
lean_dec_ref(v___y_3949_);
lean_dec_ref(v_n_3947_);
lean_dec_ref(v_interesting_3946_);
lean_dec(v___x_3945_);
lean_dec_ref(v_init_3944_);
return v_res_3958_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1(lean_object* v___x_3959_, lean_object* v_interesting_3960_, lean_object* v_t_3961_, lean_object* v_init_3962_, lean_object* v___y_3963_, lean_object* v___y_3964_, lean_object* v___y_3965_, lean_object* v___y_3966_, lean_object* v___y_3967_, lean_object* v___y_3968_, lean_object* v___y_3969_, lean_object* v___y_3970_){
_start:
{
lean_object* v_root_3972_; lean_object* v_tail_3973_; lean_object* v___x_3974_; 
v_root_3972_ = lean_ctor_get(v_t_3961_, 0);
v_tail_3973_ = lean_ctor_get(v_t_3961_, 1);
lean_inc_ref(v_init_3962_);
v___x_3974_ = l_Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1(v_init_3962_, v___x_3959_, v_interesting_3960_, v_root_3972_, v_init_3962_, v___y_3963_, v___y_3964_, v___y_3965_, v___y_3966_, v___y_3967_, v___y_3968_, v___y_3969_, v___y_3970_);
lean_dec_ref(v_init_3962_);
if (lean_obj_tag(v___x_3974_) == 0)
{
lean_object* v_a_3975_; lean_object* v___x_3977_; uint8_t v_isShared_3978_; uint8_t v_isSharedCheck_4011_; 
v_a_3975_ = lean_ctor_get(v___x_3974_, 0);
v_isSharedCheck_4011_ = !lean_is_exclusive(v___x_3974_);
if (v_isSharedCheck_4011_ == 0)
{
v___x_3977_ = v___x_3974_;
v_isShared_3978_ = v_isSharedCheck_4011_;
goto v_resetjp_3976_;
}
else
{
lean_inc(v_a_3975_);
lean_dec(v___x_3974_);
v___x_3977_ = lean_box(0);
v_isShared_3978_ = v_isSharedCheck_4011_;
goto v_resetjp_3976_;
}
v_resetjp_3976_:
{
if (lean_obj_tag(v_a_3975_) == 0)
{
lean_object* v_a_3979_; lean_object* v___x_3981_; 
v_a_3979_ = lean_ctor_get(v_a_3975_, 0);
lean_inc(v_a_3979_);
lean_dec_ref_known(v_a_3975_, 1);
if (v_isShared_3978_ == 0)
{
lean_ctor_set(v___x_3977_, 0, v_a_3979_);
v___x_3981_ = v___x_3977_;
goto v_reusejp_3980_;
}
else
{
lean_object* v_reuseFailAlloc_3982_; 
v_reuseFailAlloc_3982_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3982_, 0, v_a_3979_);
v___x_3981_ = v_reuseFailAlloc_3982_;
goto v_reusejp_3980_;
}
v_reusejp_3980_:
{
return v___x_3981_;
}
}
else
{
lean_object* v_a_3983_; lean_object* v___x_3984_; lean_object* v___x_3985_; size_t v_sz_3986_; size_t v___x_3987_; lean_object* v___x_3988_; 
lean_del_object(v___x_3977_);
v_a_3983_ = lean_ctor_get(v_a_3975_, 0);
lean_inc(v_a_3983_);
lean_dec_ref_known(v_a_3975_, 1);
v___x_3984_ = lean_box(0);
v___x_3985_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3985_, 0, v___x_3984_);
lean_ctor_set(v___x_3985_, 1, v_a_3983_);
v_sz_3986_ = lean_array_size(v_tail_3973_);
v___x_3987_ = ((size_t)0ULL);
v___x_3988_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2(v___x_3959_, v_interesting_3960_, v_tail_3973_, v_sz_3986_, v___x_3987_, v___x_3985_, v___y_3963_, v___y_3964_, v___y_3965_, v___y_3966_, v___y_3967_, v___y_3968_, v___y_3969_, v___y_3970_);
if (lean_obj_tag(v___x_3988_) == 0)
{
lean_object* v_a_3989_; lean_object* v___x_3991_; uint8_t v_isShared_3992_; uint8_t v_isSharedCheck_4002_; 
v_a_3989_ = lean_ctor_get(v___x_3988_, 0);
v_isSharedCheck_4002_ = !lean_is_exclusive(v___x_3988_);
if (v_isSharedCheck_4002_ == 0)
{
v___x_3991_ = v___x_3988_;
v_isShared_3992_ = v_isSharedCheck_4002_;
goto v_resetjp_3990_;
}
else
{
lean_inc(v_a_3989_);
lean_dec(v___x_3988_);
v___x_3991_ = lean_box(0);
v_isShared_3992_ = v_isSharedCheck_4002_;
goto v_resetjp_3990_;
}
v_resetjp_3990_:
{
lean_object* v_fst_3993_; 
v_fst_3993_ = lean_ctor_get(v_a_3989_, 0);
if (lean_obj_tag(v_fst_3993_) == 0)
{
lean_object* v_snd_3994_; lean_object* v___x_3996_; 
v_snd_3994_ = lean_ctor_get(v_a_3989_, 1);
lean_inc(v_snd_3994_);
lean_dec(v_a_3989_);
if (v_isShared_3992_ == 0)
{
lean_ctor_set(v___x_3991_, 0, v_snd_3994_);
v___x_3996_ = v___x_3991_;
goto v_reusejp_3995_;
}
else
{
lean_object* v_reuseFailAlloc_3997_; 
v_reuseFailAlloc_3997_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3997_, 0, v_snd_3994_);
v___x_3996_ = v_reuseFailAlloc_3997_;
goto v_reusejp_3995_;
}
v_reusejp_3995_:
{
return v___x_3996_;
}
}
else
{
lean_object* v_val_3998_; lean_object* v___x_4000_; 
lean_inc_ref(v_fst_3993_);
lean_dec(v_a_3989_);
v_val_3998_ = lean_ctor_get(v_fst_3993_, 0);
lean_inc(v_val_3998_);
lean_dec_ref_known(v_fst_3993_, 1);
if (v_isShared_3992_ == 0)
{
lean_ctor_set(v___x_3991_, 0, v_val_3998_);
v___x_4000_ = v___x_3991_;
goto v_reusejp_3999_;
}
else
{
lean_object* v_reuseFailAlloc_4001_; 
v_reuseFailAlloc_4001_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4001_, 0, v_val_3998_);
v___x_4000_ = v_reuseFailAlloc_4001_;
goto v_reusejp_3999_;
}
v_reusejp_3999_:
{
return v___x_4000_;
}
}
}
}
else
{
lean_object* v_a_4003_; lean_object* v___x_4005_; uint8_t v_isShared_4006_; uint8_t v_isSharedCheck_4010_; 
v_a_4003_ = lean_ctor_get(v___x_3988_, 0);
v_isSharedCheck_4010_ = !lean_is_exclusive(v___x_3988_);
if (v_isSharedCheck_4010_ == 0)
{
v___x_4005_ = v___x_3988_;
v_isShared_4006_ = v_isSharedCheck_4010_;
goto v_resetjp_4004_;
}
else
{
lean_inc(v_a_4003_);
lean_dec(v___x_3988_);
v___x_4005_ = lean_box(0);
v_isShared_4006_ = v_isSharedCheck_4010_;
goto v_resetjp_4004_;
}
v_resetjp_4004_:
{
lean_object* v___x_4008_; 
if (v_isShared_4006_ == 0)
{
v___x_4008_ = v___x_4005_;
goto v_reusejp_4007_;
}
else
{
lean_object* v_reuseFailAlloc_4009_; 
v_reuseFailAlloc_4009_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4009_, 0, v_a_4003_);
v___x_4008_ = v_reuseFailAlloc_4009_;
goto v_reusejp_4007_;
}
v_reusejp_4007_:
{
return v___x_4008_;
}
}
}
}
}
}
else
{
lean_object* v_a_4012_; lean_object* v___x_4014_; uint8_t v_isShared_4015_; uint8_t v_isSharedCheck_4019_; 
v_a_4012_ = lean_ctor_get(v___x_3974_, 0);
v_isSharedCheck_4019_ = !lean_is_exclusive(v___x_3974_);
if (v_isSharedCheck_4019_ == 0)
{
v___x_4014_ = v___x_3974_;
v_isShared_4015_ = v_isSharedCheck_4019_;
goto v_resetjp_4013_;
}
else
{
lean_inc(v_a_4012_);
lean_dec(v___x_3974_);
v___x_4014_ = lean_box(0);
v_isShared_4015_ = v_isSharedCheck_4019_;
goto v_resetjp_4013_;
}
v_resetjp_4013_:
{
lean_object* v___x_4017_; 
if (v_isShared_4015_ == 0)
{
v___x_4017_ = v___x_4014_;
goto v_reusejp_4016_;
}
else
{
lean_object* v_reuseFailAlloc_4018_; 
v_reuseFailAlloc_4018_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4018_, 0, v_a_4012_);
v___x_4017_ = v_reuseFailAlloc_4018_;
goto v_reusejp_4016_;
}
v_reusejp_4016_:
{
return v___x_4017_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1___boxed(lean_object* v___x_4020_, lean_object* v_interesting_4021_, lean_object* v_t_4022_, lean_object* v_init_4023_, lean_object* v___y_4024_, lean_object* v___y_4025_, lean_object* v___y_4026_, lean_object* v___y_4027_, lean_object* v___y_4028_, lean_object* v___y_4029_, lean_object* v___y_4030_, lean_object* v___y_4031_, lean_object* v___y_4032_){
_start:
{
lean_object* v_res_4033_; 
v_res_4033_ = l_Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1(v___x_4020_, v_interesting_4021_, v_t_4022_, v_init_4023_, v___y_4024_, v___y_4025_, v___y_4026_, v___y_4027_, v___y_4028_, v___y_4029_, v___y_4030_, v___y_4031_);
lean_dec(v___y_4031_);
lean_dec_ref(v___y_4030_);
lean_dec(v___y_4029_);
lean_dec_ref(v___y_4028_);
lean_dec(v___y_4027_);
lean_dec_ref(v___y_4026_);
lean_dec(v___y_4025_);
lean_dec_ref(v___y_4024_);
lean_dec_ref(v_t_4022_);
lean_dec_ref(v_interesting_4021_);
lean_dec(v___x_4020_);
return v_res_4033_;
}
}
static lean_object* _init_l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__1(void){
_start:
{
lean_object* v___x_4035_; lean_object* v___x_4036_; 
v___x_4035_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__0));
v___x_4036_ = l_Lean_stringToMessageData(v___x_4035_);
return v___x_4036_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg(lean_object* v_as_4037_, size_t v_i_4038_, size_t v_stop_4039_, lean_object* v_b_4040_, lean_object* v___y_4041_, lean_object* v___y_4042_, lean_object* v___y_4043_, lean_object* v___y_4044_, lean_object* v___y_4045_, lean_object* v___y_4046_){
_start:
{
lean_object* v_a_4049_; lean_object* v___y_4054_; uint8_t v___x_4056_; 
v___x_4056_ = lean_usize_dec_eq(v_i_4038_, v_stop_4039_);
if (v___x_4056_ == 0)
{
lean_object* v_options_4057_; lean_object* v_inheritedTraceOptions_4058_; uint8_t v_hasTrace_4059_; lean_object* v___x_4060_; lean_object* v___y_4062_; lean_object* v___y_4063_; lean_object* v___y_4064_; lean_object* v___y_4065_; lean_object* v___y_4066_; lean_object* v___y_4067_; 
v_options_4057_ = lean_ctor_get(v___y_4045_, 2);
v_inheritedTraceOptions_4058_ = lean_ctor_get(v___y_4045_, 13);
v_hasTrace_4059_ = lean_ctor_get_uint8(v_options_4057_, sizeof(void*)*1);
v___x_4060_ = lean_array_uget_borrowed(v_as_4037_, v_i_4038_);
if (v_hasTrace_4059_ == 0)
{
v___y_4062_ = v___y_4041_;
v___y_4063_ = v___y_4042_;
v___y_4064_ = v___y_4043_;
v___y_4065_ = v___y_4044_;
v___y_4066_ = v___y_4045_;
v___y_4067_ = v___y_4046_;
goto v___jp_4061_;
}
else
{
lean_object* v_cls_4073_; lean_object* v___x_4074_; uint8_t v___x_4075_; 
v_cls_4073_ = ((lean_object*)(l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__3));
v___x_4074_ = lean_obj_once(&l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6, &l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6_once, _init_l___private_Std_Data_DHashMap_Internal_AssocList_Basic_0__Std_DHashMap_Internal_AssocList_forInStep_go___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__6___closed__6);
v___x_4075_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_4058_, v_options_4057_, v___x_4074_);
if (v___x_4075_ == 0)
{
v___y_4062_ = v___y_4041_;
v___y_4063_ = v___y_4042_;
v___y_4064_ = v___y_4043_;
v___y_4065_ = v___y_4044_;
v___y_4066_ = v___y_4045_;
v___y_4067_ = v___y_4046_;
goto v___jp_4061_;
}
else
{
lean_object* v_type_4076_; lean_object* v___x_4077_; lean_object* v___x_4078_; lean_object* v___x_4079_; lean_object* v___x_4080_; 
v_type_4076_ = lean_ctor_get(v___x_4060_, 1);
v___x_4077_ = lean_obj_once(&l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__1, &l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__1_once, _init_l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___closed__1);
lean_inc_ref(v_type_4076_);
v___x_4078_ = l_Lean_MessageData_ofExpr(v_type_4076_);
v___x_4079_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_4079_, 0, v___x_4077_);
lean_ctor_set(v___x_4079_, 1, v___x_4078_);
v___x_4080_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_addStructureSimpLemmas_spec__5___redArg(v_cls_4073_, v___x_4079_, v___y_4043_, v___y_4044_, v___y_4045_, v___y_4046_);
if (lean_obj_tag(v___x_4080_) == 0)
{
lean_dec_ref_known(v___x_4080_, 1);
v___y_4062_ = v___y_4041_;
v___y_4063_ = v___y_4042_;
v___y_4064_ = v___y_4043_;
v___y_4065_ = v___y_4044_;
v___y_4066_ = v___y_4045_;
v___y_4067_ = v___y_4046_;
goto v___jp_4061_;
}
else
{
v___y_4054_ = v___x_4080_;
goto v___jp_4053_;
}
}
}
v___jp_4061_:
{
lean_object* v___x_4068_; uint8_t v_debug_4069_; 
v___x_4068_ = lean_st_ref_get(v___y_4063_);
v_debug_4069_ = lean_ctor_get_uint8(v___x_4068_, sizeof(void*)*10);
lean_dec(v___x_4068_);
if (v_debug_4069_ == 0)
{
lean_object* v___x_4070_; 
v___x_4070_ = lean_box(0);
v_a_4049_ = v___x_4070_;
goto v___jp_4048_;
}
else
{
lean_object* v_type_4071_; lean_object* v___x_4072_; 
v_type_4071_ = lean_ctor_get(v___x_4060_, 1);
lean_inc_ref(v_type_4071_);
v___x_4072_ = l_Lean_Meta_Sym_Internal_Sym_assertShared(v_type_4071_, v___y_4062_, v___y_4063_, v___y_4064_, v___y_4065_, v___y_4066_, v___y_4067_);
v___y_4054_ = v___x_4072_;
goto v___jp_4053_;
}
}
}
else
{
lean_object* v___x_4081_; 
v___x_4081_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_4081_, 0, v_b_4040_);
return v___x_4081_;
}
v___jp_4048_:
{
size_t v___x_4050_; size_t v___x_4051_; 
v___x_4050_ = ((size_t)1ULL);
v___x_4051_ = lean_usize_add(v_i_4038_, v___x_4050_);
v_i_4038_ = v___x_4051_;
v_b_4040_ = v_a_4049_;
goto _start;
}
v___jp_4053_:
{
if (lean_obj_tag(v___y_4054_) == 0)
{
lean_object* v_a_4055_; 
v_a_4055_ = lean_ctor_get(v___y_4054_, 0);
lean_inc(v_a_4055_);
lean_dec_ref_known(v___y_4054_, 1);
v_a_4049_ = v_a_4055_;
goto v___jp_4048_;
}
else
{
return v___y_4054_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg___boxed(lean_object* v_as_4082_, lean_object* v_i_4083_, lean_object* v_stop_4084_, lean_object* v_b_4085_, lean_object* v___y_4086_, lean_object* v___y_4087_, lean_object* v___y_4088_, lean_object* v___y_4089_, lean_object* v___y_4090_, lean_object* v___y_4091_, lean_object* v___y_4092_){
_start:
{
size_t v_i_boxed_4093_; size_t v_stop_boxed_4094_; lean_object* v_res_4095_; 
v_i_boxed_4093_ = lean_unbox_usize(v_i_4083_);
lean_dec(v_i_4083_);
v_stop_boxed_4094_ = lean_unbox_usize(v_stop_4084_);
lean_dec(v_stop_4084_);
v_res_4095_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg(v_as_4082_, v_i_boxed_4093_, v_stop_boxed_4094_, v_b_4085_, v___y_4086_, v___y_4087_, v___y_4088_, v___y_4089_, v___y_4090_, v___y_4091_);
lean_dec(v___y_4091_);
lean_dec_ref(v___y_4090_);
lean_dec(v___y_4089_);
lean_dec_ref(v___y_4088_);
lean_dec(v___y_4087_);
lean_dec_ref(v___y_4086_);
lean_dec_ref(v_as_4082_);
return v_res_4095_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__0(lean_object* v_size_4096_, lean_object* v_interestingStructures_4097_, lean_object* v___x_4098_, lean_object* v___x_4099_, lean_object* v_goal_4100_, lean_object* v___y_4101_, lean_object* v___y_4102_, lean_object* v___y_4103_, lean_object* v___y_4104_, lean_object* v___y_4105_, lean_object* v___y_4106_, lean_object* v___y_4107_, lean_object* v___y_4108_){
_start:
{
lean_object* v_lctx_4110_; lean_object* v_decls_4111_; lean_object* v___x_4112_; 
v_lctx_4110_ = lean_ctor_get(v___y_4105_, 2);
v_decls_4111_ = lean_ctor_get(v_lctx_4110_, 1);
v___x_4112_ = l_Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1(v_size_4096_, v_interestingStructures_4097_, v_decls_4111_, v___x_4098_, v___y_4101_, v___y_4102_, v___y_4103_, v___y_4104_, v___y_4105_, v___y_4106_, v___y_4107_, v___y_4108_);
if (lean_obj_tag(v___x_4112_) == 0)
{
lean_object* v_a_4113_; lean_object* v___x_4114_; lean_object* v_env_4115_; lean_object* v___x_4116_; lean_object* v___x_4117_; lean_object* v___x_4118_; 
v_a_4113_ = lean_ctor_get(v___x_4112_, 0);
lean_inc(v_a_4113_);
lean_dec_ref_known(v___x_4112_, 1);
v___x_4114_ = lean_st_ref_get(v___y_4108_);
v_env_4115_ = lean_ctor_get(v___x_4114_, 0);
lean_inc_ref(v_env_4115_);
lean_dec(v___x_4114_);
v___x_4116_ = lean_mk_empty_array_with_capacity(v___x_4099_);
v___x_4117_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_4117_, 0, v_a_4113_);
lean_ctor_set(v___x_4117_, 1, v___x_4116_);
v___x_4118_ = l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4___redArg(v_env_4115_, v_interestingStructures_4097_, v___x_4117_, v___y_4101_, v___y_4102_, v___y_4103_, v___y_4104_, v___y_4105_, v___y_4106_, v___y_4107_, v___y_4108_);
if (lean_obj_tag(v___x_4118_) == 0)
{
lean_object* v_a_4119_; lean_object* v_snd_4120_; lean_object* v___y_4140_; lean_object* v___x_4149_; uint8_t v___x_4150_; 
v_a_4119_ = lean_ctor_get(v___x_4118_, 0);
lean_inc(v_a_4119_);
lean_dec_ref_known(v___x_4118_, 1);
v_snd_4120_ = lean_ctor_get(v_a_4119_, 1);
lean_inc(v_snd_4120_);
lean_dec(v_a_4119_);
v___x_4149_ = lean_array_get_size(v_snd_4120_);
v___x_4150_ = lean_nat_dec_lt(v___x_4099_, v___x_4149_);
if (v___x_4150_ == 0)
{
goto v___jp_4121_;
}
else
{
lean_object* v___x_4151_; uint8_t v___x_4152_; 
v___x_4151_ = lean_box(0);
v___x_4152_ = lean_nat_dec_le(v___x_4149_, v___x_4149_);
if (v___x_4152_ == 0)
{
if (v___x_4150_ == 0)
{
goto v___jp_4121_;
}
else
{
size_t v___x_4153_; size_t v___x_4154_; lean_object* v___x_4155_; 
v___x_4153_ = ((size_t)0ULL);
v___x_4154_ = lean_usize_of_nat(v___x_4149_);
v___x_4155_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg(v_snd_4120_, v___x_4153_, v___x_4154_, v___x_4151_, v___y_4103_, v___y_4104_, v___y_4105_, v___y_4106_, v___y_4107_, v___y_4108_);
v___y_4140_ = v___x_4155_;
goto v___jp_4139_;
}
}
else
{
size_t v___x_4156_; size_t v___x_4157_; lean_object* v___x_4158_; 
v___x_4156_ = ((size_t)0ULL);
v___x_4157_ = lean_usize_of_nat(v___x_4149_);
v___x_4158_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg(v_snd_4120_, v___x_4156_, v___x_4157_, v___x_4151_, v___y_4103_, v___y_4104_, v___y_4105_, v___y_4106_, v___y_4107_, v___y_4108_);
v___y_4140_ = v___x_4158_;
goto v___jp_4139_;
}
}
v___jp_4121_:
{
lean_object* v___x_4122_; lean_object* v_rewriteCache_4123_; lean_object* v_acNfCache_4124_; lean_object* v_typeAnalysis_4125_; lean_object* v_goal_4126_; lean_object* v_hypotheses_4127_; uint8_t v_didChange_4128_; lean_object* v___x_4130_; uint8_t v_isShared_4131_; uint8_t v_isSharedCheck_4138_; 
v___x_4122_ = lean_st_ref_take(v___y_4102_);
v_rewriteCache_4123_ = lean_ctor_get(v___x_4122_, 0);
v_acNfCache_4124_ = lean_ctor_get(v___x_4122_, 1);
v_typeAnalysis_4125_ = lean_ctor_get(v___x_4122_, 2);
v_goal_4126_ = lean_ctor_get(v___x_4122_, 3);
v_hypotheses_4127_ = lean_ctor_get(v___x_4122_, 4);
v_didChange_4128_ = lean_ctor_get_uint8(v___x_4122_, sizeof(void*)*5);
v_isSharedCheck_4138_ = !lean_is_exclusive(v___x_4122_);
if (v_isSharedCheck_4138_ == 0)
{
v___x_4130_ = v___x_4122_;
v_isShared_4131_ = v_isSharedCheck_4138_;
goto v_resetjp_4129_;
}
else
{
lean_inc(v_hypotheses_4127_);
lean_inc(v_goal_4126_);
lean_inc(v_typeAnalysis_4125_);
lean_inc(v_acNfCache_4124_);
lean_inc(v_rewriteCache_4123_);
lean_dec(v___x_4122_);
v___x_4130_ = lean_box(0);
v_isShared_4131_ = v_isSharedCheck_4138_;
goto v_resetjp_4129_;
}
v_resetjp_4129_:
{
lean_object* v___x_4132_; lean_object* v___x_4134_; 
v___x_4132_ = l_Array_append___redArg(v_hypotheses_4127_, v_snd_4120_);
lean_dec(v_snd_4120_);
if (v_isShared_4131_ == 0)
{
lean_ctor_set(v___x_4130_, 4, v___x_4132_);
v___x_4134_ = v___x_4130_;
goto v_reusejp_4133_;
}
else
{
lean_object* v_reuseFailAlloc_4137_; 
v_reuseFailAlloc_4137_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_4137_, 0, v_rewriteCache_4123_);
lean_ctor_set(v_reuseFailAlloc_4137_, 1, v_acNfCache_4124_);
lean_ctor_set(v_reuseFailAlloc_4137_, 2, v_typeAnalysis_4125_);
lean_ctor_set(v_reuseFailAlloc_4137_, 3, v_goal_4126_);
lean_ctor_set(v_reuseFailAlloc_4137_, 4, v___x_4132_);
lean_ctor_set_uint8(v_reuseFailAlloc_4137_, sizeof(void*)*5, v_didChange_4128_);
v___x_4134_ = v_reuseFailAlloc_4137_;
goto v_reusejp_4133_;
}
v_reusejp_4133_:
{
lean_object* v___x_4135_; lean_object* v___x_4136_; 
v___x_4135_ = lean_st_ref_set(v___y_4102_, v___x_4134_);
v___x_4136_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess(v_goal_4100_, v___y_4101_, v___y_4102_, v___y_4103_, v___y_4104_, v___y_4105_, v___y_4106_, v___y_4107_, v___y_4108_);
return v___x_4136_;
}
}
}
v___jp_4139_:
{
if (lean_obj_tag(v___y_4140_) == 0)
{
lean_dec_ref_known(v___y_4140_, 1);
goto v___jp_4121_;
}
else
{
lean_object* v_a_4141_; lean_object* v___x_4143_; uint8_t v_isShared_4144_; uint8_t v_isSharedCheck_4148_; 
lean_dec(v_snd_4120_);
lean_dec(v_goal_4100_);
v_a_4141_ = lean_ctor_get(v___y_4140_, 0);
v_isSharedCheck_4148_ = !lean_is_exclusive(v___y_4140_);
if (v_isSharedCheck_4148_ == 0)
{
v___x_4143_ = v___y_4140_;
v_isShared_4144_ = v_isSharedCheck_4148_;
goto v_resetjp_4142_;
}
else
{
lean_inc(v_a_4141_);
lean_dec(v___y_4140_);
v___x_4143_ = lean_box(0);
v_isShared_4144_ = v_isSharedCheck_4148_;
goto v_resetjp_4142_;
}
v_resetjp_4142_:
{
lean_object* v___x_4146_; 
if (v_isShared_4144_ == 0)
{
v___x_4146_ = v___x_4143_;
goto v_reusejp_4145_;
}
else
{
lean_object* v_reuseFailAlloc_4147_; 
v_reuseFailAlloc_4147_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4147_, 0, v_a_4141_);
v___x_4146_ = v_reuseFailAlloc_4147_;
goto v_reusejp_4145_;
}
v_reusejp_4145_:
{
return v___x_4146_;
}
}
}
}
}
else
{
lean_object* v_a_4159_; lean_object* v___x_4161_; uint8_t v_isShared_4162_; uint8_t v_isSharedCheck_4166_; 
lean_dec(v_goal_4100_);
v_a_4159_ = lean_ctor_get(v___x_4118_, 0);
v_isSharedCheck_4166_ = !lean_is_exclusive(v___x_4118_);
if (v_isSharedCheck_4166_ == 0)
{
v___x_4161_ = v___x_4118_;
v_isShared_4162_ = v_isSharedCheck_4166_;
goto v_resetjp_4160_;
}
else
{
lean_inc(v_a_4159_);
lean_dec(v___x_4118_);
v___x_4161_ = lean_box(0);
v_isShared_4162_ = v_isSharedCheck_4166_;
goto v_resetjp_4160_;
}
v_resetjp_4160_:
{
lean_object* v___x_4164_; 
if (v_isShared_4162_ == 0)
{
v___x_4164_ = v___x_4161_;
goto v_reusejp_4163_;
}
else
{
lean_object* v_reuseFailAlloc_4165_; 
v_reuseFailAlloc_4165_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4165_, 0, v_a_4159_);
v___x_4164_ = v_reuseFailAlloc_4165_;
goto v_reusejp_4163_;
}
v_reusejp_4163_:
{
return v___x_4164_;
}
}
}
}
else
{
lean_object* v_a_4167_; lean_object* v___x_4169_; uint8_t v_isShared_4170_; uint8_t v_isSharedCheck_4174_; 
lean_dec(v_goal_4100_);
v_a_4167_ = lean_ctor_get(v___x_4112_, 0);
v_isSharedCheck_4174_ = !lean_is_exclusive(v___x_4112_);
if (v_isSharedCheck_4174_ == 0)
{
v___x_4169_ = v___x_4112_;
v_isShared_4170_ = v_isSharedCheck_4174_;
goto v_resetjp_4168_;
}
else
{
lean_inc(v_a_4167_);
lean_dec(v___x_4112_);
v___x_4169_ = lean_box(0);
v_isShared_4170_ = v_isSharedCheck_4174_;
goto v_resetjp_4168_;
}
v_resetjp_4168_:
{
lean_object* v___x_4172_; 
if (v_isShared_4170_ == 0)
{
v___x_4172_ = v___x_4169_;
goto v_reusejp_4171_;
}
else
{
lean_object* v_reuseFailAlloc_4173_; 
v_reuseFailAlloc_4173_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4173_, 0, v_a_4167_);
v___x_4172_ = v_reuseFailAlloc_4173_;
goto v_reusejp_4171_;
}
v_reusejp_4171_:
{
return v___x_4172_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__0___boxed(lean_object* v_size_4175_, lean_object* v_interestingStructures_4176_, lean_object* v___x_4177_, lean_object* v___x_4178_, lean_object* v_goal_4179_, lean_object* v___y_4180_, lean_object* v___y_4181_, lean_object* v___y_4182_, lean_object* v___y_4183_, lean_object* v___y_4184_, lean_object* v___y_4185_, lean_object* v___y_4186_, lean_object* v___y_4187_, lean_object* v___y_4188_){
_start:
{
lean_object* v_res_4189_; 
v_res_4189_ = l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__0(v_size_4175_, v_interestingStructures_4176_, v___x_4177_, v___x_4178_, v_goal_4179_, v___y_4180_, v___y_4181_, v___y_4182_, v___y_4183_, v___y_4184_, v___y_4185_, v___y_4186_, v___y_4187_);
lean_dec(v___y_4187_);
lean_dec_ref(v___y_4186_);
lean_dec(v___y_4185_);
lean_dec_ref(v___y_4184_);
lean_dec(v___y_4183_);
lean_dec_ref(v___y_4182_);
lean_dec(v___y_4181_);
lean_dec_ref(v___y_4180_);
lean_dec(v___x_4178_);
lean_dec_ref(v_interestingStructures_4176_);
lean_dec(v_size_4175_);
return v_res_4189_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1(lean_object* v___y_4192_, lean_object* v___y_4193_, lean_object* v___y_4194_, lean_object* v___y_4195_, lean_object* v___y_4196_, lean_object* v___y_4197_, lean_object* v___y_4198_, lean_object* v___y_4199_){
_start:
{
lean_object* v___x_4201_; lean_object* v_typeAnalysis_4202_; lean_object* v_interestingStructures_4203_; lean_object* v_size_4204_; lean_object* v___x_4205_; uint8_t v___x_4206_; 
v___x_4201_ = lean_st_ref_get(v___y_4193_);
v_typeAnalysis_4202_ = lean_ctor_get(v___x_4201_, 2);
lean_inc_ref(v_typeAnalysis_4202_);
lean_dec(v___x_4201_);
v_interestingStructures_4203_ = lean_ctor_get(v_typeAnalysis_4202_, 0);
lean_inc_ref(v_interestingStructures_4203_);
lean_dec_ref(v_typeAnalysis_4202_);
v_size_4204_ = lean_ctor_get(v_interestingStructures_4203_, 0);
lean_inc(v_size_4204_);
v___x_4205_ = lean_unsigned_to_nat(0u);
v___x_4206_ = lean_nat_dec_eq(v_size_4204_, v___x_4205_);
if (v___x_4206_ == 0)
{
lean_object* v___x_4207_; lean_object* v_goal_4208_; lean_object* v___x_4209_; lean_object* v___f_4210_; lean_object* v___x_4211_; 
v___x_4207_ = lean_st_ref_get(v___y_4193_);
v_goal_4208_ = lean_ctor_get(v___x_4207_, 3);
lean_inc_n(v_goal_4208_, 2);
lean_dec(v___x_4207_);
v___x_4209_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1___closed__0));
v___f_4210_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__0___boxed), 14, 5);
lean_closure_set(v___f_4210_, 0, v_size_4204_);
lean_closure_set(v___f_4210_, 1, v_interestingStructures_4203_);
lean_closure_set(v___f_4210_, 2, v___x_4209_);
lean_closure_set(v___f_4210_, 3, v___x_4205_);
lean_closure_set(v___f_4210_, 4, v_goal_4208_);
v___x_4211_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_Structures_0__Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_postprocess_spec__2___redArg(v_goal_4208_, v___f_4210_, v___y_4192_, v___y_4193_, v___y_4194_, v___y_4195_, v___y_4196_, v___y_4197_, v___y_4198_, v___y_4199_);
return v___x_4211_;
}
else
{
uint8_t v___x_4212_; lean_object* v___x_4213_; lean_object* v___x_4214_; 
lean_dec(v_size_4204_);
lean_dec_ref(v_interestingStructures_4203_);
v___x_4212_ = 0;
v___x_4213_ = lean_box(v___x_4212_);
v___x_4214_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_4214_, 0, v___x_4213_);
return v___x_4214_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1___boxed(lean_object* v___y_4215_, lean_object* v___y_4216_, lean_object* v___y_4217_, lean_object* v___y_4218_, lean_object* v___y_4219_, lean_object* v___y_4220_, lean_object* v___y_4221_, lean_object* v___y_4222_, lean_object* v___y_4223_){
_start:
{
lean_object* v_res_4224_; 
v_res_4224_ = l_Lean_Meta_Tactic_BVDecide_Normalize_structuresPass___lam__1(v___y_4215_, v___y_4216_, v___y_4217_, v___y_4218_, v___y_4219_, v___y_4220_, v___y_4221_, v___y_4222_);
lean_dec(v___y_4222_);
lean_dec_ref(v___y_4221_);
lean_dec(v___y_4220_);
lean_dec_ref(v___y_4219_);
lean_dec(v___y_4218_);
lean_dec_ref(v___y_4217_);
lean_dec(v___y_4216_);
lean_dec_ref(v___y_4215_);
return v_res_4224_;
}
}
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0(lean_object* v_00_u03b2_4233_, lean_object* v_m_4234_, lean_object* v_a_4235_){
_start:
{
uint8_t v___x_4236_; 
v___x_4236_ = l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___redArg(v_m_4234_, v_a_4235_);
return v___x_4236_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0___boxed(lean_object* v_00_u03b2_4237_, lean_object* v_m_4238_, lean_object* v_a_4239_){
_start:
{
uint8_t v_res_4240_; lean_object* v_r_4241_; 
v_res_4240_ = l_Std_DHashMap_Internal_Raw_u2080_contains___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__0(v_00_u03b2_4237_, v_m_4238_, v_a_4239_);
lean_dec(v_a_4239_);
lean_dec_ref(v_m_4238_);
v_r_4241_ = lean_box(v_res_4240_);
return v_r_4241_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3(lean_object* v_upperBound_4242_, lean_object* v_a_4243_, lean_object* v_fst_4244_, lean_object* v_snd_4245_, lean_object* v_fst_4246_, lean_object* v_interesting_4247_, lean_object* v_inst_4248_, lean_object* v_R_4249_, lean_object* v_a_4250_, lean_object* v_b_4251_, lean_object* v_c_4252_, lean_object* v___y_4253_, lean_object* v___y_4254_, lean_object* v___y_4255_, lean_object* v___y_4256_, lean_object* v___y_4257_, lean_object* v___y_4258_, lean_object* v___y_4259_, lean_object* v___y_4260_){
_start:
{
lean_object* v___x_4262_; 
v___x_4262_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___redArg(v_upperBound_4242_, v_a_4243_, v_fst_4244_, v_snd_4245_, v_fst_4246_, v_interesting_4247_, v_a_4250_, v_b_4251_, v___y_4255_, v___y_4256_, v___y_4257_, v___y_4258_, v___y_4259_, v___y_4260_);
return v___x_4262_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3___boxed(lean_object** _args){
lean_object* v_upperBound_4263_ = _args[0];
lean_object* v_a_4264_ = _args[1];
lean_object* v_fst_4265_ = _args[2];
lean_object* v_snd_4266_ = _args[3];
lean_object* v_fst_4267_ = _args[4];
lean_object* v_interesting_4268_ = _args[5];
lean_object* v_inst_4269_ = _args[6];
lean_object* v_R_4270_ = _args[7];
lean_object* v_a_4271_ = _args[8];
lean_object* v_b_4272_ = _args[9];
lean_object* v_c_4273_ = _args[10];
lean_object* v___y_4274_ = _args[11];
lean_object* v___y_4275_ = _args[12];
lean_object* v___y_4276_ = _args[13];
lean_object* v___y_4277_ = _args[14];
lean_object* v___y_4278_ = _args[15];
lean_object* v___y_4279_ = _args[16];
lean_object* v___y_4280_ = _args[17];
lean_object* v___y_4281_ = _args[18];
lean_object* v___y_4282_ = _args[19];
_start:
{
lean_object* v_res_4283_; 
v_res_4283_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__3(v_upperBound_4263_, v_a_4264_, v_fst_4265_, v_snd_4266_, v_fst_4267_, v_interesting_4268_, v_inst_4269_, v_R_4270_, v_a_4271_, v_b_4272_, v_c_4273_, v___y_4274_, v___y_4275_, v___y_4276_, v___y_4277_, v___y_4278_, v___y_4279_, v___y_4280_, v___y_4281_);
lean_dec(v___y_4281_);
lean_dec_ref(v___y_4280_);
lean_dec(v___y_4279_);
lean_dec_ref(v___y_4278_);
lean_dec(v___y_4277_);
lean_dec_ref(v___y_4276_);
lean_dec(v___y_4275_);
lean_dec_ref(v___y_4274_);
lean_dec_ref(v_interesting_4268_);
lean_dec_ref(v_snd_4266_);
lean_dec(v_upperBound_4263_);
return v_res_4283_;
}
}
LEAN_EXPORT lean_object* l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4(lean_object* v___x_4284_, lean_object* v_interesting_4285_, lean_object* v_inst_4286_, lean_object* v_a_4287_, lean_object* v___y_4288_, lean_object* v___y_4289_, lean_object* v___y_4290_, lean_object* v___y_4291_, lean_object* v___y_4292_, lean_object* v___y_4293_, lean_object* v___y_4294_, lean_object* v___y_4295_){
_start:
{
lean_object* v___x_4297_; 
v___x_4297_ = l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4___redArg(v___x_4284_, v_interesting_4285_, v_a_4287_, v___y_4288_, v___y_4289_, v___y_4290_, v___y_4291_, v___y_4292_, v___y_4293_, v___y_4294_, v___y_4295_);
return v___x_4297_;
}
}
LEAN_EXPORT lean_object* l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4___boxed(lean_object* v___x_4298_, lean_object* v_interesting_4299_, lean_object* v_inst_4300_, lean_object* v_a_4301_, lean_object* v___y_4302_, lean_object* v___y_4303_, lean_object* v___y_4304_, lean_object* v___y_4305_, lean_object* v___y_4306_, lean_object* v___y_4307_, lean_object* v___y_4308_, lean_object* v___y_4309_, lean_object* v___y_4310_){
_start:
{
lean_object* v_res_4311_; 
v_res_4311_ = l___private_Init_While_0__repeatM_erased___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__4(v___x_4298_, v_interesting_4299_, v_inst_4300_, v_a_4301_, v___y_4302_, v___y_4303_, v___y_4304_, v___y_4305_, v___y_4306_, v___y_4307_, v___y_4308_, v___y_4309_);
lean_dec(v___y_4309_);
lean_dec_ref(v___y_4308_);
lean_dec(v___y_4307_);
lean_dec_ref(v___y_4306_);
lean_dec(v___y_4305_);
lean_dec_ref(v___y_4304_);
lean_dec(v___y_4303_);
lean_dec_ref(v___y_4302_);
lean_dec_ref(v_interesting_4299_);
return v_res_4311_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5(lean_object* v_as_4312_, size_t v_i_4313_, size_t v_stop_4314_, lean_object* v_b_4315_, lean_object* v___y_4316_, lean_object* v___y_4317_, lean_object* v___y_4318_, lean_object* v___y_4319_, lean_object* v___y_4320_, lean_object* v___y_4321_, lean_object* v___y_4322_, lean_object* v___y_4323_){
_start:
{
lean_object* v___x_4325_; 
v___x_4325_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___redArg(v_as_4312_, v_i_4313_, v_stop_4314_, v_b_4315_, v___y_4318_, v___y_4319_, v___y_4320_, v___y_4321_, v___y_4322_, v___y_4323_);
return v___x_4325_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5___boxed(lean_object* v_as_4326_, lean_object* v_i_4327_, lean_object* v_stop_4328_, lean_object* v_b_4329_, lean_object* v___y_4330_, lean_object* v___y_4331_, lean_object* v___y_4332_, lean_object* v___y_4333_, lean_object* v___y_4334_, lean_object* v___y_4335_, lean_object* v___y_4336_, lean_object* v___y_4337_, lean_object* v___y_4338_){
_start:
{
size_t v_i_boxed_4339_; size_t v_stop_boxed_4340_; lean_object* v_res_4341_; 
v_i_boxed_4339_ = lean_unbox_usize(v_i_4327_);
lean_dec(v_i_4327_);
v_stop_boxed_4340_ = lean_unbox_usize(v_stop_4328_);
lean_dec(v_stop_4328_);
v_res_4341_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__5(v_as_4326_, v_i_boxed_4339_, v_stop_boxed_4340_, v_b_4329_, v___y_4330_, v___y_4331_, v___y_4332_, v___y_4333_, v___y_4334_, v___y_4335_, v___y_4336_, v___y_4337_);
lean_dec(v___y_4337_);
lean_dec_ref(v___y_4336_);
lean_dec(v___y_4335_);
lean_dec_ref(v___y_4334_);
lean_dec(v___y_4333_);
lean_dec_ref(v___y_4332_);
lean_dec(v___y_4331_);
lean_dec_ref(v___y_4330_);
lean_dec_ref(v_as_4326_);
return v_res_4341_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5(lean_object* v___x_4342_, lean_object* v_interesting_4343_, lean_object* v_as_4344_, size_t v_sz_4345_, size_t v_i_4346_, lean_object* v_b_4347_, lean_object* v___y_4348_, lean_object* v___y_4349_, lean_object* v___y_4350_, lean_object* v___y_4351_, lean_object* v___y_4352_, lean_object* v___y_4353_, lean_object* v___y_4354_, lean_object* v___y_4355_){
_start:
{
lean_object* v___x_4357_; 
v___x_4357_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5___redArg(v___x_4342_, v_interesting_4343_, v_as_4344_, v_sz_4345_, v_i_4346_, v_b_4347_, v___y_4350_, v___y_4351_, v___y_4352_, v___y_4353_, v___y_4354_, v___y_4355_);
return v___x_4357_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5___boxed(lean_object* v___x_4358_, lean_object* v_interesting_4359_, lean_object* v_as_4360_, lean_object* v_sz_4361_, lean_object* v_i_4362_, lean_object* v_b_4363_, lean_object* v___y_4364_, lean_object* v___y_4365_, lean_object* v___y_4366_, lean_object* v___y_4367_, lean_object* v___y_4368_, lean_object* v___y_4369_, lean_object* v___y_4370_, lean_object* v___y_4371_, lean_object* v___y_4372_){
_start:
{
size_t v_sz_boxed_4373_; size_t v_i_boxed_4374_; lean_object* v_res_4375_; 
v_sz_boxed_4373_ = lean_unbox_usize(v_sz_4361_);
lean_dec(v_sz_4361_);
v_i_boxed_4374_ = lean_unbox_usize(v_i_4362_);
lean_dec(v_i_4362_);
v_res_4375_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__2_spec__5(v___x_4358_, v_interesting_4359_, v_as_4360_, v_sz_boxed_4373_, v_i_boxed_4374_, v_b_4363_, v___y_4364_, v___y_4365_, v___y_4366_, v___y_4367_, v___y_4368_, v___y_4369_, v___y_4370_, v___y_4371_);
lean_dec(v___y_4371_);
lean_dec_ref(v___y_4370_);
lean_dec(v___y_4369_);
lean_dec_ref(v___y_4368_);
lean_dec(v___y_4367_);
lean_dec_ref(v___y_4366_);
lean_dec(v___y_4365_);
lean_dec_ref(v___y_4364_);
lean_dec_ref(v_as_4360_);
lean_dec_ref(v_interesting_4359_);
lean_dec(v___x_4358_);
return v_res_4375_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9(lean_object* v___x_4376_, lean_object* v_interesting_4377_, lean_object* v_as_4378_, size_t v_sz_4379_, size_t v_i_4380_, lean_object* v_b_4381_, lean_object* v___y_4382_, lean_object* v___y_4383_, lean_object* v___y_4384_, lean_object* v___y_4385_, lean_object* v___y_4386_, lean_object* v___y_4387_, lean_object* v___y_4388_, lean_object* v___y_4389_){
_start:
{
lean_object* v___x_4391_; 
v___x_4391_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9___redArg(v___x_4376_, v_interesting_4377_, v_as_4378_, v_sz_4379_, v_i_4380_, v_b_4381_, v___y_4384_, v___y_4385_, v___y_4386_, v___y_4387_, v___y_4388_, v___y_4389_);
return v___x_4391_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9___boxed(lean_object* v___x_4392_, lean_object* v_interesting_4393_, lean_object* v_as_4394_, lean_object* v_sz_4395_, lean_object* v_i_4396_, lean_object* v_b_4397_, lean_object* v___y_4398_, lean_object* v___y_4399_, lean_object* v___y_4400_, lean_object* v___y_4401_, lean_object* v___y_4402_, lean_object* v___y_4403_, lean_object* v___y_4404_, lean_object* v___y_4405_, lean_object* v___y_4406_){
_start:
{
size_t v_sz_boxed_4407_; size_t v_i_boxed_4408_; lean_object* v_res_4409_; 
v_sz_boxed_4407_ = lean_unbox_usize(v_sz_4395_);
lean_dec(v_sz_4395_);
v_i_boxed_4408_ = lean_unbox_usize(v_i_4396_);
lean_dec(v_i_4396_);
v_res_4409_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_PersistentArray_forInAux___at___00Lean_PersistentArray_forIn___at___00Lean_Meta_Tactic_BVDecide_Normalize_structuresPass_spec__1_spec__1_spec__3_spec__9(v___x_4392_, v_interesting_4393_, v_as_4394_, v_sz_boxed_4407_, v_i_boxed_4408_, v_b_4397_, v___y_4398_, v___y_4399_, v___y_4400_, v___y_4401_, v___y_4402_, v___y_4403_, v___y_4404_, v___y_4405_);
lean_dec(v___y_4405_);
lean_dec_ref(v___y_4404_);
lean_dec(v___y_4403_);
lean_dec_ref(v___y_4402_);
lean_dec(v___y_4401_);
lean_dec_ref(v___y_4400_);
lean_dec(v___y_4399_);
lean_dec_ref(v___y_4398_);
lean_dec_ref(v_as_4394_);
lean_dec_ref(v_interesting_4393_);
lean_dec(v___x_4392_);
return v_res_4409_;
}
}
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_TypeAnalysis(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_SimpM(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_ApplyControlFlow(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_Ext(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_Theorems(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_Rewrite(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Util(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Structures(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_TypeAnalysis(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_SimpM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_ApplyControlFlow(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_Ext(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_Theorems(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Util(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Structures(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_TypeAnalysis(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_SimpM(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_ApplyControlFlow(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_Ext(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_Theorems(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_Rewrite(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Util(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Structures(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Lean_Meta_Tactic_BVDecide_Normalize_TypeAnalysis(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_SimpM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_BVDecide_Normalize_ApplyControlFlow(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_Ext(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_Theorems(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Util(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Structures(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Structures(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Meta_Tactic_BVDecide_Normalize_Structures(builtin);
}
#ifdef __cplusplus
}
#endif
