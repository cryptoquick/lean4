// Lean compiler output
// Module: Lean.Meta.Tactic.BVDecide.Normalize.IntToBitVec
// Imports: public import Lean.Meta.Tactic.BVDecide.Normalize.Basic import Lean.Meta.Sym.Simp.Rewrite import Lean.Meta.Sym.InstantiateMVarsS import Lean.Meta.Sym.LitValues import Init.Data.UInt.IntToBitVec import Init.Data.SInt.IntToBitVec
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
lean_object* lean_st_ref_get(lean_object*);
extern lean_object* l_Lean_Meta_Tactic_BVDecide_symIntToBitVecExt;
lean_object* l_Lean_Meta_Sym_Simp_SymSimpExtension_getTheorems___redArg(lean_object*, lean_object*);
lean_object* l_Lean_Meta_getPropHyps(lean_object*, lean_object*, lean_object*, lean_object*);
size_t lean_array_size(lean_object*);
uint8_t lean_usize_dec_lt(size_t, size_t);
lean_object* lean_array_uget_borrowed(lean_object*, size_t);
lean_object* l_Lean_FVarId_getType___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_Expr_hasMVar(lean_object*);
lean_object* l_Lean_instantiateMVarsCore(lean_object*, lean_object*);
lean_object* lean_st_ref_take(lean_object*);
lean_object* lean_st_ref_set(lean_object*, lean_object*);
lean_object* l_Lean_Meta_instantiateMVarsIfMVarApp___redArg(lean_object*, lean_object*);
size_t lean_usize_add(size_t, size_t);
lean_object* l_Lean_Expr_cleanupAnnotations(lean_object*);
uint8_t l_Lean_Expr_isApp(lean_object*);
lean_object* l_Lean_Expr_appFnCleanup___redArg(lean_object*);
lean_object* l_Lean_Name_mkStr1(lean_object*);
uint8_t l_Lean_Expr_isConstOf(lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr3(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_getNatValue_x3f(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Level_ofNat(lean_object*);
lean_object* l_Lean_Name_mkStr2(lean_object*, lean_object*);
lean_object* l_Lean_mkConst(lean_object*, lean_object*);
lean_object* l_Lean_mkFVar(lean_object*);
lean_object* l_Lean_mkApp4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_instantiateMVarsS(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_getNatValue_x3f(lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_dischargeNone___redArg();
lean_object* l_Lean_Meta_Sym_Simp_Theorems_rewrite(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Expr_app___override(lean_object*, lean_object*);
lean_object* l_BitVec_ofNat(lean_object*, lean_object*);
lean_object* l_Lean_Expr_const___override(lean_object*, lean_object*);
lean_object* l_Lean_mkNatLit(lean_object*);
lean_object* l_Lean_mkAppB(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_shareCommonInc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_Result_withContextDependent(lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_mkEqTrans(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_array_get_size(lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
lean_object* lean_array_fget_borrowed(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_simp___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_SimpM_run_x27___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_Expr_isFalse(lean_object*);
lean_object* lean_array_push(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Internal_Sym_assertShared(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_append(lean_object*, lean_object*);
uint8_t l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_MessageData_ofExpr(lean_object*);
lean_object* l_Lean_stringToMessageData(lean_object*);
double lean_float_of_nat(lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* l_Lean_PersistentArray_push___redArg(lean_object*, lean_object*);
uint8_t l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(lean_object*, lean_object*);
uint64_t l_Lean_instHashableMVarId_hash(lean_object*);
size_t lean_uint64_to_usize(uint64_t);
size_t lean_usize_land(size_t, size_t);
lean_object* lean_usize_to_nat(size_t);
lean_object* lean_array_fget(lean_object*, lean_object*);
lean_object* lean_array_fset(lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_instBEqMVarId_beq(lean_object*, lean_object*);
lean_object* l_Lean_PersistentHashMap_mkCollisionNode___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
size_t lean_usize_shift_right(size_t, size_t);
lean_object* l_Lean_PersistentHashMap_mkEmptyEntries(lean_object*, lean_object*);
size_t lean_usize_sub(size_t, size_t);
size_t lean_usize_mul(size_t, size_t);
uint8_t lean_usize_dec_le(size_t, size_t);
lean_object* l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(lean_object*);
lean_object* l_Lean_instBEqFVarId_beq___boxed(lean_object*, lean_object*);
lean_object* l_Lean_instHashableFVarId_hash___boxed(lean_object*);
lean_object* l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Expr_eqv___boxed(lean_object*, lean_object*);
lean_object* l_Lean_Expr_hash___boxed(lean_object*);
static const lean_closure_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Expr_eqv___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__0_value;
static const lean_closure_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Expr_hash___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__1 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__1_value;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_instBEqFVarId_beq___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__0_value;
static const lean_closure_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_instHashableFVarId_hash___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__1 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__1_value;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "BitVec"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__0_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "ofNat"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__1 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__1_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(108, 178, 58, 132, 143, 189, 222, 74)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__2_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(101, 105, 192, 171, 214, 131, 43, 105)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__2 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__2_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__3;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*0 + 8, .m_other = 0, .m_tag = 0}, .m_objs = {LEAN_SCALAR_PTR_LITERAL(0, 0, 0, 0, 0, 0, 0, 0)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__4 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__4_value;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "Int64"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__0_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "toBitVec"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(67, 100, 38, 50, 157, 43, 83, 90)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__2_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(42, 26, 57, 165, 14, 135, 135, 191)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__2 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__2_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "Int32"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__3 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__3_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__4_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__3_value),LEAN_SCALAR_PTR_LITERAL(202, 24, 245, 188, 10, 96, 206, 241)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__4_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(231, 54, 185, 195, 30, 183, 107, 8)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__4 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__4_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "Int16"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__5 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__5_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__6_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__5_value),LEAN_SCALAR_PTR_LITERAL(61, 121, 89, 120, 57, 100, 28, 22)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__6_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(44, 210, 78, 221, 232, 52, 28, 161)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__6 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__6_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Int8"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__7 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__7_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__8_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__7_value),LEAN_SCALAR_PTR_LITERAL(17, 171, 155, 218, 43, 77, 1, 67)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__8_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(144, 114, 73, 21, 161, 185, 192, 185)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__8 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__8_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__9_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "UInt64"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__9 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__9_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__10_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__9_value),LEAN_SCALAR_PTR_LITERAL(58, 113, 45, 150, 103, 228, 0, 41)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__10_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(151, 144, 45, 221, 65, 48, 204, 242)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__10 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__10_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__11_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "UInt32"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__11 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__11_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__12_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__11_value),LEAN_SCALAR_PTR_LITERAL(98, 192, 58, 241, 186, 14, 255, 186)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__12_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__12_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(95, 106, 42, 185, 61, 138, 17, 12)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__12 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__12_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__13_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "UInt16"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__13 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__13_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__14_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__13_value),LEAN_SCALAR_PTR_LITERAL(6, 214, 154, 233, 192, 74, 99, 135)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__14_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__14_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(83, 21, 175, 117, 0, 32, 88, 5)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__14 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__14_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__15_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "UInt8"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__15 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__15_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__16_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__15_value),LEAN_SCALAR_PTR_LITERAL(144, 254, 64, 72, 7, 99, 197, 218)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__16_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__16_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(165, 247, 174, 117, 226, 108, 136, 114)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__16 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__16_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__17_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "ISize"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__17 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__17_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__18_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 11, .m_capacity = 11, .m_length = 10, .m_data = "toBitVec64"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__18 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__18_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__19_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__17_value),LEAN_SCALAR_PTR_LITERAL(110, 52, 237, 35, 121, 142, 86, 222)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__19_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__19_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__18_value),LEAN_SCALAR_PTR_LITERAL(51, 79, 88, 119, 92, 132, 69, 104)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__19 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__19_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__20_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 11, .m_capacity = 11, .m_length = 10, .m_data = "toBitVec32"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__20 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__20_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__21_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__17_value),LEAN_SCALAR_PTR_LITERAL(110, 52, 237, 35, 121, 142, 86, 222)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__21_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__21_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__20_value),LEAN_SCALAR_PTR_LITERAL(40, 3, 162, 24, 208, 1, 22, 97)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__21 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__21_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__22_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "USize"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__22 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__22_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__23_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__22_value),LEAN_SCALAR_PTR_LITERAL(109, 217, 26, 131, 232, 198, 207, 245)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__23_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__23_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__18_value),LEAN_SCALAR_PTR_LITERAL(116, 153, 59, 255, 117, 164, 81, 124)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__23 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__23_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__24_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__22_value),LEAN_SCALAR_PTR_LITERAL(109, 217, 26, 131, 232, 198, 207, 245)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__24_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__24_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__20_value),LEAN_SCALAR_PTR_LITERAL(231, 120, 16, 185, 133, 236, 22, 98)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__24 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__24_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__25_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 17, .m_capacity = 17, .m_length = 16, .m_data = "toBitVec32_ofNat"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__25 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__25_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__26_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__22_value),LEAN_SCALAR_PTR_LITERAL(109, 217, 26, 131, 232, 198, 207, 245)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__26_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__26_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__25_value),LEAN_SCALAR_PTR_LITERAL(36, 126, 106, 153, 203, 80, 154, 147)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__26 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__26_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__27_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__27;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__28_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 17, .m_capacity = 17, .m_length = 16, .m_data = "toBitVec64_ofNat"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__28 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__28_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__29_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__22_value),LEAN_SCALAR_PTR_LITERAL(109, 217, 26, 131, 232, 198, 207, 245)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__29_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__29_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__28_value),LEAN_SCALAR_PTR_LITERAL(8, 122, 79, 170, 199, 9, 205, 227)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__29 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__29_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__30_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__30;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__31_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__17_value),LEAN_SCALAR_PTR_LITERAL(110, 52, 237, 35, 121, 142, 86, 222)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__31_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__31_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__25_value),LEAN_SCALAR_PTR_LITERAL(227, 67, 19, 212, 150, 152, 220, 31)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__31 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__31_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__32_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__32;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__33_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__17_value),LEAN_SCALAR_PTR_LITERAL(110, 52, 237, 35, 121, 142, 86, 222)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__33_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__33_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__28_value),LEAN_SCALAR_PTR_LITERAL(199, 133, 200, 107, 224, 56, 254, 62)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__33 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__33_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__34_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__34;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 15, .m_capacity = 15, .m_length = 14, .m_data = "toBitVec_ofNat"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__36_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__15_value),LEAN_SCALAR_PTR_LITERAL(144, 254, 64, 72, 7, 99, 197, 218)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__36_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__36_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value),LEAN_SCALAR_PTR_LITERAL(247, 230, 213, 135, 10, 17, 158, 228)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__36 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__36_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__37_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__37;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__38_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__13_value),LEAN_SCALAR_PTR_LITERAL(6, 214, 154, 233, 192, 74, 99, 135)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__38_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__38_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value),LEAN_SCALAR_PTR_LITERAL(81, 243, 247, 74, 243, 200, 60, 150)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__38 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__38_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__39_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__39;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__40_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__11_value),LEAN_SCALAR_PTR_LITERAL(98, 192, 58, 241, 186, 14, 255, 186)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__40_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__40_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value),LEAN_SCALAR_PTR_LITERAL(93, 148, 255, 227, 8, 20, 120, 82)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__40 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__40_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__41_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__41;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__42_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__9_value),LEAN_SCALAR_PTR_LITERAL(58, 113, 45, 150, 103, 228, 0, 41)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__42_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__42_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value),LEAN_SCALAR_PTR_LITERAL(69, 129, 9, 3, 239, 75, 70, 86)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__42 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__42_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__43_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__43;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__44_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__7_value),LEAN_SCALAR_PTR_LITERAL(17, 171, 155, 218, 43, 77, 1, 67)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__44_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__44_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value),LEAN_SCALAR_PTR_LITERAL(226, 22, 215, 85, 74, 102, 124, 27)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__44 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__44_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__45_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__45;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__46_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__5_value),LEAN_SCALAR_PTR_LITERAL(61, 121, 89, 120, 57, 100, 28, 22)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__46_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__46_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value),LEAN_SCALAR_PTR_LITERAL(46, 105, 154, 220, 47, 238, 251, 60)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__46 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__46_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__47_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__47;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__48_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__3_value),LEAN_SCALAR_PTR_LITERAL(202, 24, 245, 188, 10, 96, 206, 241)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__48_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__48_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value),LEAN_SCALAR_PTR_LITERAL(149, 18, 246, 1, 255, 137, 120, 221)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__48 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__48_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__49_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__49;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__50_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(67, 100, 38, 50, 157, 43, 83, 90)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__50_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__50_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__35_value),LEAN_SCALAR_PTR_LITERAL(40, 68, 102, 45, 83, 225, 185, 90)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__50 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__50_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__51_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__51;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_ctor_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)(((size_t)(0) << 1) | 1))}};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__0 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__0_value;
static const lean_string_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "Eq"};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__1 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__1_value;
static const lean_ctor_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__1_value),LEAN_SCALAR_PTR_LITERAL(143, 37, 101, 248, 9, 246, 191, 223)}};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__2 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__2_value;
static const lean_string_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "System"};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__3 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__3_value;
static const lean_string_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "Platform"};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__4 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__4_value;
static const lean_string_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "numBits"};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__5 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__5_value;
static const lean_ctor_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__6_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__3_value),LEAN_SCALAR_PTR_LITERAL(244, 7, 92, 194, 164, 177, 167, 52)}};
static const lean_ctor_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__6_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__6_value_aux_0),((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__4_value),LEAN_SCALAR_PTR_LITERAL(128, 236, 129, 7, 244, 3, 115, 42)}};
static const lean_ctor_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__6_value_aux_1),((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__5_value),LEAN_SCALAR_PTR_LITERAL(195, 13, 33, 186, 170, 198, 65, 128)}};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__6 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__6_value;
static const lean_string_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "symm"};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__7 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__7_value;
static const lean_ctor_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__8_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__1_value),LEAN_SCALAR_PTR_LITERAL(143, 37, 101, 248, 9, 246, 191, 223)}};
static const lean_ctor_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__8_value_aux_0),((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__7_value),LEAN_SCALAR_PTR_LITERAL(220, 149, 144, 59, 77, 93, 25, 217)}};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__8 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__8_value;
static lean_once_cell_t l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__9;
static lean_once_cell_t l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__10_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__10;
static lean_once_cell_t l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__11_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__11;
static const lean_ctor_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__12_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*1 + 0, .m_other = 1, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1))}};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__12 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__12_value;
static const lean_ctor_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__13_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__12_value),((lean_object*)(((size_t)(0) << 1) | 1))}};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__13 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__13_value;
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1(lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___lam__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___lam__0___boxed, .m_arity = 5, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___closed__0_value;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*0 + 8, .m_other = 0, .m_tag = 0}, .m_objs = {LEAN_SCALAR_PTR_LITERAL(0, 0, 0, 0, 0, 0, 0, 0)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6___redArg(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg___closed__0;
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg(lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7___redArg(size_t, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static double l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__0;
static const lean_string_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 1, .m_capacity = 1, .m_length = 0, .m_data = ""};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__1 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__1_value;
static const lean_array_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__2 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__2_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__1(uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Meta"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__0 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__0_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__1 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__1_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "bv"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__2 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__2_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__3_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(211, 174, 49, 251, 64, 24, 251, 1)}};
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__3_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__3_value_aux_0),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(194, 95, 140, 15, 16, 100, 236, 219)}};
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__3_value_aux_1),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__2_value),LEAN_SCALAR_PTR_LITERAL(139, 41, 106, 94, 234, 34, 111, 146)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__3 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__3_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trace"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__4 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__4_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__4_value),LEAN_SCALAR_PTR_LITERAL(212, 145, 141, 177, 67, 149, 127, 197)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__5 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__5_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__6;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "  ==>  "};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__7 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__7_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__8_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__8;
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__0___boxed, .m_arity = 11, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__0_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__2___boxed, .m_arity = 10, .m_num_fixed = 1, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__0_value)} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__1_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 12, .m_capacity = 12, .m_length = 11, .m_data = "intToBitVec"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__2_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__2_value),LEAN_SCALAR_PTR_LITERAL(130, 217, 71, 86, 75, 235, 18, 78)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__3_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__3_value),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__1_value)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__4_value;
LEAN_EXPORT const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___closed__4_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4(lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7(lean_object*, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6_spec__7(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg(lean_object* v_e_3_, lean_object* v_a_4_){
_start:
{
lean_object* v___x_6_; lean_object* v_relevantTerms_7_; lean_object* v_relevantHyps_8_; lean_object* v___x_10_; uint8_t v_isShared_11_; uint8_t v_isSharedCheck_21_; 
v___x_6_ = lean_st_ref_take(v_a_4_);
v_relevantTerms_7_ = lean_ctor_get(v___x_6_, 0);
v_relevantHyps_8_ = lean_ctor_get(v___x_6_, 1);
v_isSharedCheck_21_ = !lean_is_exclusive(v___x_6_);
if (v_isSharedCheck_21_ == 0)
{
v___x_10_ = v___x_6_;
v_isShared_11_ = v_isSharedCheck_21_;
goto v_resetjp_9_;
}
else
{
lean_inc(v_relevantHyps_8_);
lean_inc(v_relevantTerms_7_);
lean_dec(v___x_6_);
v___x_10_ = lean_box(0);
v_isShared_11_ = v_isSharedCheck_21_;
goto v_resetjp_9_;
}
v_resetjp_9_:
{
lean_object* v___x_12_; lean_object* v___x_13_; lean_object* v___x_14_; lean_object* v___x_15_; lean_object* v___x_17_; 
v___x_12_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__0));
v___x_13_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__1));
v___x_14_ = lean_box(0);
v___x_15_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_12_, v___x_13_, v_relevantTerms_7_, v_e_3_, v___x_14_);
if (v_isShared_11_ == 0)
{
lean_ctor_set(v___x_10_, 0, v___x_15_);
v___x_17_ = v___x_10_;
goto v_reusejp_16_;
}
else
{
lean_object* v_reuseFailAlloc_20_; 
v_reuseFailAlloc_20_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_20_, 0, v___x_15_);
lean_ctor_set(v_reuseFailAlloc_20_, 1, v_relevantHyps_8_);
v___x_17_ = v_reuseFailAlloc_20_;
goto v_reusejp_16_;
}
v_reusejp_16_:
{
lean_object* v___x_18_; lean_object* v___x_19_; 
v___x_18_ = lean_st_ref_set(v_a_4_, v___x_17_);
v___x_19_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_19_, 0, v___x_14_);
return v___x_19_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___boxed(lean_object* v_e_22_, lean_object* v_a_23_, lean_object* v_a_24_){
_start:
{
lean_object* v_res_25_; 
v_res_25_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg(v_e_22_, v_a_23_);
lean_dec(v_a_23_);
return v_res_25_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm(lean_object* v_e_26_, lean_object* v_a_27_, lean_object* v_a_28_, lean_object* v_a_29_, lean_object* v_a_30_, lean_object* v_a_31_){
_start:
{
lean_object* v___x_33_; lean_object* v_relevantTerms_34_; lean_object* v_relevantHyps_35_; lean_object* v___x_37_; uint8_t v_isShared_38_; uint8_t v_isSharedCheck_48_; 
v___x_33_ = lean_st_ref_take(v_a_27_);
v_relevantTerms_34_ = lean_ctor_get(v___x_33_, 0);
v_relevantHyps_35_ = lean_ctor_get(v___x_33_, 1);
v_isSharedCheck_48_ = !lean_is_exclusive(v___x_33_);
if (v_isSharedCheck_48_ == 0)
{
v___x_37_ = v___x_33_;
v_isShared_38_ = v_isSharedCheck_48_;
goto v_resetjp_36_;
}
else
{
lean_inc(v_relevantHyps_35_);
lean_inc(v_relevantTerms_34_);
lean_dec(v___x_33_);
v___x_37_ = lean_box(0);
v_isShared_38_ = v_isSharedCheck_48_;
goto v_resetjp_36_;
}
v_resetjp_36_:
{
lean_object* v___x_39_; lean_object* v___x_40_; lean_object* v___x_41_; lean_object* v___x_42_; lean_object* v___x_44_; 
v___x_39_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__0));
v___x_40_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___redArg___closed__1));
v___x_41_ = lean_box(0);
v___x_42_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_39_, v___x_40_, v_relevantTerms_34_, v_e_26_, v___x_41_);
if (v_isShared_38_ == 0)
{
lean_ctor_set(v___x_37_, 0, v___x_42_);
v___x_44_ = v___x_37_;
goto v_reusejp_43_;
}
else
{
lean_object* v_reuseFailAlloc_47_; 
v_reuseFailAlloc_47_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_47_, 0, v___x_42_);
lean_ctor_set(v_reuseFailAlloc_47_, 1, v_relevantHyps_35_);
v___x_44_ = v_reuseFailAlloc_47_;
goto v_reusejp_43_;
}
v_reusejp_43_:
{
lean_object* v___x_45_; lean_object* v___x_46_; 
v___x_45_ = lean_st_ref_set(v_a_27_, v___x_44_);
v___x_46_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_46_, 0, v___x_41_);
return v___x_46_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm___boxed(lean_object* v_e_49_, lean_object* v_a_50_, lean_object* v_a_51_, lean_object* v_a_52_, lean_object* v_a_53_, lean_object* v_a_54_, lean_object* v_a_55_){
_start:
{
lean_object* v_res_56_; 
v_res_56_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeTerm(v_e_49_, v_a_50_, v_a_51_, v_a_52_, v_a_53_, v_a_54_);
lean_dec(v_a_54_);
lean_dec_ref(v_a_53_);
lean_dec(v_a_52_);
lean_dec_ref(v_a_51_);
lean_dec(v_a_50_);
return v_res_56_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg(lean_object* v_f_59_, lean_object* v_a_60_){
_start:
{
lean_object* v___x_62_; lean_object* v_relevantTerms_63_; lean_object* v_relevantHyps_64_; lean_object* v___x_66_; uint8_t v_isShared_67_; uint8_t v_isSharedCheck_77_; 
v___x_62_ = lean_st_ref_take(v_a_60_);
v_relevantTerms_63_ = lean_ctor_get(v___x_62_, 0);
v_relevantHyps_64_ = lean_ctor_get(v___x_62_, 1);
v_isSharedCheck_77_ = !lean_is_exclusive(v___x_62_);
if (v_isSharedCheck_77_ == 0)
{
v___x_66_ = v___x_62_;
v_isShared_67_ = v_isSharedCheck_77_;
goto v_resetjp_65_;
}
else
{
lean_inc(v_relevantHyps_64_);
lean_inc(v_relevantTerms_63_);
lean_dec(v___x_62_);
v___x_66_ = lean_box(0);
v_isShared_67_ = v_isSharedCheck_77_;
goto v_resetjp_65_;
}
v_resetjp_65_:
{
lean_object* v___x_68_; lean_object* v___x_69_; lean_object* v___x_70_; lean_object* v___x_71_; lean_object* v___x_73_; 
v___x_68_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__0));
v___x_69_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__1));
v___x_70_ = lean_box(0);
v___x_71_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_68_, v___x_69_, v_relevantHyps_64_, v_f_59_, v___x_70_);
if (v_isShared_67_ == 0)
{
lean_ctor_set(v___x_66_, 1, v___x_71_);
v___x_73_ = v___x_66_;
goto v_reusejp_72_;
}
else
{
lean_object* v_reuseFailAlloc_76_; 
v_reuseFailAlloc_76_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_76_, 0, v_relevantTerms_63_);
lean_ctor_set(v_reuseFailAlloc_76_, 1, v___x_71_);
v___x_73_ = v_reuseFailAlloc_76_;
goto v_reusejp_72_;
}
v_reusejp_72_:
{
lean_object* v___x_74_; lean_object* v___x_75_; 
v___x_74_ = lean_st_ref_set(v_a_60_, v___x_73_);
v___x_75_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_75_, 0, v___x_70_);
return v___x_75_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___boxed(lean_object* v_f_78_, lean_object* v_a_79_, lean_object* v_a_80_){
_start:
{
lean_object* v_res_81_; 
v_res_81_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg(v_f_78_, v_a_79_);
lean_dec(v_a_79_);
return v_res_81_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp(lean_object* v_f_82_, lean_object* v_a_83_, lean_object* v_a_84_, lean_object* v_a_85_, lean_object* v_a_86_, lean_object* v_a_87_){
_start:
{
lean_object* v___x_89_; lean_object* v_relevantTerms_90_; lean_object* v_relevantHyps_91_; lean_object* v___x_93_; uint8_t v_isShared_94_; uint8_t v_isSharedCheck_104_; 
v___x_89_ = lean_st_ref_take(v_a_83_);
v_relevantTerms_90_ = lean_ctor_get(v___x_89_, 0);
v_relevantHyps_91_ = lean_ctor_get(v___x_89_, 1);
v_isSharedCheck_104_ = !lean_is_exclusive(v___x_89_);
if (v_isSharedCheck_104_ == 0)
{
v___x_93_ = v___x_89_;
v_isShared_94_ = v_isSharedCheck_104_;
goto v_resetjp_92_;
}
else
{
lean_inc(v_relevantHyps_91_);
lean_inc(v_relevantTerms_90_);
lean_dec(v___x_89_);
v___x_93_ = lean_box(0);
v_isShared_94_ = v_isSharedCheck_104_;
goto v_resetjp_92_;
}
v_resetjp_92_:
{
lean_object* v___x_95_; lean_object* v___x_96_; lean_object* v___x_97_; lean_object* v___x_98_; lean_object* v___x_100_; 
v___x_95_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__0));
v___x_96_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___redArg___closed__1));
v___x_97_ = lean_box(0);
v___x_98_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_95_, v___x_96_, v_relevantHyps_91_, v_f_82_, v___x_97_);
if (v_isShared_94_ == 0)
{
lean_ctor_set(v___x_93_, 1, v___x_98_);
v___x_100_ = v___x_93_;
goto v_reusejp_99_;
}
else
{
lean_object* v_reuseFailAlloc_103_; 
v_reuseFailAlloc_103_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_103_, 0, v_relevantTerms_90_);
lean_ctor_set(v_reuseFailAlloc_103_, 1, v___x_98_);
v___x_100_ = v_reuseFailAlloc_103_;
goto v_reusejp_99_;
}
v_reusejp_99_:
{
lean_object* v___x_101_; lean_object* v___x_102_; 
v___x_101_ = lean_st_ref_set(v_a_83_, v___x_100_);
v___x_102_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_102_, 0, v___x_97_);
return v___x_102_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp___boxed(lean_object* v_f_105_, lean_object* v_a_106_, lean_object* v_a_107_, lean_object* v_a_108_, lean_object* v_a_109_, lean_object* v_a_110_, lean_object* v_a_111_){
_start:
{
lean_object* v_res_112_; 
v_res_112_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_M_addSizeHyp(v_f_105_, v_a_106_, v_a_107_, v_a_108_, v_a_109_, v_a_110_);
lean_dec(v_a_110_);
lean_dec_ref(v_a_109_);
lean_dec(v_a_108_);
lean_dec_ref(v_a_107_);
lean_dec(v_a_106_);
return v_res_112_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__3(void){
_start:
{
lean_object* v___x_118_; lean_object* v___x_119_; lean_object* v___x_120_; 
v___x_118_ = lean_box(0);
v___x_119_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__2));
v___x_120_ = l_Lean_Expr_const___override(v___x_119_, v___x_118_);
return v___x_120_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(lean_object* v_expr_123_, lean_object* v_width_124_, lean_object* v_thm_125_, lean_object* v_a_126_, lean_object* v_a_127_, lean_object* v_a_128_, lean_object* v_a_129_, lean_object* v_a_130_, lean_object* v_a_131_){
_start:
{
lean_object* v___x_133_; 
v___x_133_ = l_Lean_Meta_Sym_getNatValue_x3f(v_expr_123_);
if (lean_obj_tag(v___x_133_) == 1)
{
lean_object* v_val_134_; lean_object* v___x_135_; lean_object* v___x_136_; lean_object* v___x_137_; lean_object* v___x_138_; lean_object* v___x_139_; lean_object* v___x_140_; 
v_val_134_ = lean_ctor_get(v___x_133_, 0);
lean_inc(v_val_134_);
lean_dec_ref_known(v___x_133_, 1);
v___x_135_ = l_BitVec_ofNat(v_width_124_, v_val_134_);
v___x_136_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__3, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__3_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__3);
v___x_137_ = l_Lean_mkNatLit(v_width_124_);
v___x_138_ = l_Lean_mkNatLit(v___x_135_);
v___x_139_ = l_Lean_mkAppB(v___x_136_, v___x_137_, v___x_138_);
v___x_140_ = l_Lean_Meta_Sym_shareCommonInc(v___x_139_, v_a_126_, v_a_127_, v_a_128_, v_a_129_, v_a_130_, v_a_131_);
if (lean_obj_tag(v___x_140_) == 0)
{
lean_object* v_a_141_; lean_object* v___x_143_; uint8_t v_isShared_144_; uint8_t v_isSharedCheck_152_; 
v_a_141_ = lean_ctor_get(v___x_140_, 0);
v_isSharedCheck_152_ = !lean_is_exclusive(v___x_140_);
if (v_isSharedCheck_152_ == 0)
{
v___x_143_ = v___x_140_;
v_isShared_144_ = v_isSharedCheck_152_;
goto v_resetjp_142_;
}
else
{
lean_inc(v_a_141_);
lean_dec(v___x_140_);
v___x_143_ = lean_box(0);
v_isShared_144_ = v_isSharedCheck_152_;
goto v_resetjp_142_;
}
v_resetjp_142_:
{
lean_object* v___x_145_; lean_object* v___x_146_; uint8_t v___x_147_; lean_object* v___x_148_; lean_object* v___x_150_; 
v___x_145_ = l_Lean_mkNatLit(v_val_134_);
v___x_146_ = l_Lean_Expr_app___override(v_thm_125_, v___x_145_);
v___x_147_ = 0;
v___x_148_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v___x_148_, 0, v_a_141_);
lean_ctor_set(v___x_148_, 1, v___x_146_);
lean_ctor_set_uint8(v___x_148_, sizeof(void*)*2, v___x_147_);
lean_ctor_set_uint8(v___x_148_, sizeof(void*)*2 + 1, v___x_147_);
if (v_isShared_144_ == 0)
{
lean_ctor_set(v___x_143_, 0, v___x_148_);
v___x_150_ = v___x_143_;
goto v_reusejp_149_;
}
else
{
lean_object* v_reuseFailAlloc_151_; 
v_reuseFailAlloc_151_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_151_, 0, v___x_148_);
v___x_150_ = v_reuseFailAlloc_151_;
goto v_reusejp_149_;
}
v_reusejp_149_:
{
return v___x_150_;
}
}
}
else
{
lean_object* v_a_153_; lean_object* v___x_155_; uint8_t v_isShared_156_; uint8_t v_isSharedCheck_160_; 
lean_dec(v_val_134_);
lean_dec_ref(v_thm_125_);
v_a_153_ = lean_ctor_get(v___x_140_, 0);
v_isSharedCheck_160_ = !lean_is_exclusive(v___x_140_);
if (v_isSharedCheck_160_ == 0)
{
v___x_155_ = v___x_140_;
v_isShared_156_ = v_isSharedCheck_160_;
goto v_resetjp_154_;
}
else
{
lean_inc(v_a_153_);
lean_dec(v___x_140_);
v___x_155_ = lean_box(0);
v_isShared_156_ = v_isSharedCheck_160_;
goto v_resetjp_154_;
}
v_resetjp_154_:
{
lean_object* v___x_158_; 
if (v_isShared_156_ == 0)
{
v___x_158_ = v___x_155_;
goto v_reusejp_157_;
}
else
{
lean_object* v_reuseFailAlloc_159_; 
v_reuseFailAlloc_159_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_159_, 0, v_a_153_);
v___x_158_ = v_reuseFailAlloc_159_;
goto v_reusejp_157_;
}
v_reusejp_157_:
{
return v___x_158_;
}
}
}
}
else
{
lean_object* v___x_161_; lean_object* v___x_162_; 
lean_dec(v___x_133_);
lean_dec_ref(v_thm_125_);
lean_dec(v_width_124_);
v___x_161_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__4));
v___x_162_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_162_, 0, v___x_161_);
return v___x_162_;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___boxed(lean_object* v_expr_163_, lean_object* v_width_164_, lean_object* v_thm_165_, lean_object* v_a_166_, lean_object* v_a_167_, lean_object* v_a_168_, lean_object* v_a_169_, lean_object* v_a_170_, lean_object* v_a_171_, lean_object* v_a_172_){
_start:
{
lean_object* v_res_173_; 
v_res_173_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_expr_163_, v_width_164_, v_thm_165_, v_a_166_, v_a_167_, v_a_168_, v_a_169_, v_a_170_, v_a_171_);
lean_dec(v_a_171_);
lean_dec_ref(v_a_170_);
lean_dec(v_a_169_);
lean_dec_ref(v_a_168_);
lean_dec(v_a_167_);
lean_dec_ref(v_a_166_);
return v_res_173_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc(lean_object* v_expr_174_, lean_object* v_width_175_, lean_object* v_thm_176_, lean_object* v_a_177_, lean_object* v_a_178_, lean_object* v_a_179_, lean_object* v_a_180_, lean_object* v_a_181_, lean_object* v_a_182_, lean_object* v_a_183_, lean_object* v_a_184_, lean_object* v_a_185_){
_start:
{
lean_object* v___x_187_; 
v___x_187_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_expr_174_, v_width_175_, v_thm_176_, v_a_180_, v_a_181_, v_a_182_, v_a_183_, v_a_184_, v_a_185_);
return v___x_187_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___boxed(lean_object* v_expr_188_, lean_object* v_width_189_, lean_object* v_thm_190_, lean_object* v_a_191_, lean_object* v_a_192_, lean_object* v_a_193_, lean_object* v_a_194_, lean_object* v_a_195_, lean_object* v_a_196_, lean_object* v_a_197_, lean_object* v_a_198_, lean_object* v_a_199_, lean_object* v_a_200_){
_start:
{
lean_object* v_res_201_; 
v_res_201_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc(v_expr_188_, v_width_189_, v_thm_190_, v_a_191_, v_a_192_, v_a_193_, v_a_194_, v_a_195_, v_a_196_, v_a_197_, v_a_198_, v_a_199_);
lean_dec(v_a_199_);
lean_dec_ref(v_a_198_);
lean_dec(v_a_197_);
lean_dec_ref(v_a_196_);
lean_dec(v_a_195_);
lean_dec_ref(v_a_194_);
lean_dec(v_a_193_);
lean_dec_ref(v_a_192_);
lean_dec(v_a_191_);
return v_res_201_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__27(void){
_start:
{
lean_object* v___x_255_; lean_object* v___x_256_; lean_object* v___x_257_; 
v___x_255_ = lean_box(0);
v___x_256_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__26));
v___x_257_ = l_Lean_mkConst(v___x_256_, v___x_255_);
return v___x_257_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__30(void){
_start:
{
lean_object* v___x_262_; lean_object* v___x_263_; lean_object* v___x_264_; 
v___x_262_ = lean_box(0);
v___x_263_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__29));
v___x_264_ = l_Lean_mkConst(v___x_263_, v___x_262_);
return v___x_264_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__32(void){
_start:
{
lean_object* v___x_268_; lean_object* v___x_269_; lean_object* v___x_270_; 
v___x_268_ = lean_box(0);
v___x_269_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__31));
v___x_270_ = l_Lean_mkConst(v___x_269_, v___x_268_);
return v___x_270_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__34(void){
_start:
{
lean_object* v___x_274_; lean_object* v___x_275_; lean_object* v___x_276_; 
v___x_274_ = lean_box(0);
v___x_275_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__33));
v___x_276_ = l_Lean_mkConst(v___x_275_, v___x_274_);
return v___x_276_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__37(void){
_start:
{
lean_object* v___x_281_; lean_object* v___x_282_; lean_object* v___x_283_; 
v___x_281_ = lean_box(0);
v___x_282_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__36));
v___x_283_ = l_Lean_mkConst(v___x_282_, v___x_281_);
return v___x_283_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__39(void){
_start:
{
lean_object* v___x_287_; lean_object* v___x_288_; lean_object* v___x_289_; 
v___x_287_ = lean_box(0);
v___x_288_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__38));
v___x_289_ = l_Lean_mkConst(v___x_288_, v___x_287_);
return v___x_289_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__41(void){
_start:
{
lean_object* v___x_293_; lean_object* v___x_294_; lean_object* v___x_295_; 
v___x_293_ = lean_box(0);
v___x_294_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__40));
v___x_295_ = l_Lean_mkConst(v___x_294_, v___x_293_);
return v___x_295_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__43(void){
_start:
{
lean_object* v___x_299_; lean_object* v___x_300_; lean_object* v___x_301_; 
v___x_299_ = lean_box(0);
v___x_300_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__42));
v___x_301_ = l_Lean_mkConst(v___x_300_, v___x_299_);
return v___x_301_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__45(void){
_start:
{
lean_object* v___x_305_; lean_object* v___x_306_; lean_object* v___x_307_; 
v___x_305_ = lean_box(0);
v___x_306_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__44));
v___x_307_ = l_Lean_mkConst(v___x_306_, v___x_305_);
return v___x_307_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__47(void){
_start:
{
lean_object* v___x_311_; lean_object* v___x_312_; lean_object* v___x_313_; 
v___x_311_ = lean_box(0);
v___x_312_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__46));
v___x_313_ = l_Lean_mkConst(v___x_312_, v___x_311_);
return v___x_313_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__49(void){
_start:
{
lean_object* v___x_317_; lean_object* v___x_318_; lean_object* v___x_319_; 
v___x_317_ = lean_box(0);
v___x_318_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__48));
v___x_319_ = l_Lean_mkConst(v___x_318_, v___x_317_);
return v___x_319_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__51(void){
_start:
{
lean_object* v___x_323_; lean_object* v___x_324_; lean_object* v___x_325_; 
v___x_323_ = lean_box(0);
v___x_324_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__50));
v___x_325_ = l_Lean_mkConst(v___x_324_, v___x_323_);
return v___x_325_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg(lean_object* v_e_326_, lean_object* v_a_327_, lean_object* v_a_328_, lean_object* v_a_329_, lean_object* v_a_330_, lean_object* v_a_331_, lean_object* v_a_332_){
_start:
{
lean_object* v___x_334_; 
v___x_334_ = l_Lean_Meta_instantiateMVarsIfMVarApp___redArg(v_e_326_, v_a_330_);
if (lean_obj_tag(v___x_334_) == 0)
{
lean_object* v_a_335_; lean_object* v___x_337_; uint8_t v_isShared_338_; uint8_t v_isSharedCheck_415_; 
v_a_335_ = lean_ctor_get(v___x_334_, 0);
v_isSharedCheck_415_ = !lean_is_exclusive(v___x_334_);
if (v_isSharedCheck_415_ == 0)
{
v___x_337_ = v___x_334_;
v_isShared_338_ = v_isSharedCheck_415_;
goto v_resetjp_336_;
}
else
{
lean_inc(v_a_335_);
lean_dec(v___x_334_);
v___x_337_ = lean_box(0);
v_isShared_338_ = v_isSharedCheck_415_;
goto v_resetjp_336_;
}
v_resetjp_336_:
{
lean_object* v___x_344_; uint8_t v___x_345_; 
v___x_344_ = l_Lean_Expr_cleanupAnnotations(v_a_335_);
v___x_345_ = l_Lean_Expr_isApp(v___x_344_);
if (v___x_345_ == 0)
{
lean_dec_ref(v___x_344_);
goto v___jp_339_;
}
else
{
lean_object* v_arg_346_; lean_object* v___x_347_; lean_object* v___x_348_; uint8_t v___x_349_; 
v_arg_346_ = lean_ctor_get(v___x_344_, 1);
lean_inc_ref(v_arg_346_);
v___x_347_ = l_Lean_Expr_appFnCleanup___redArg(v___x_344_);
v___x_348_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__2));
v___x_349_ = l_Lean_Expr_isConstOf(v___x_347_, v___x_348_);
if (v___x_349_ == 0)
{
lean_object* v___x_350_; uint8_t v___x_351_; 
v___x_350_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__4));
v___x_351_ = l_Lean_Expr_isConstOf(v___x_347_, v___x_350_);
if (v___x_351_ == 0)
{
lean_object* v___x_352_; uint8_t v___x_353_; 
v___x_352_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__6));
v___x_353_ = l_Lean_Expr_isConstOf(v___x_347_, v___x_352_);
if (v___x_353_ == 0)
{
lean_object* v___x_354_; uint8_t v___x_355_; 
v___x_354_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__8));
v___x_355_ = l_Lean_Expr_isConstOf(v___x_347_, v___x_354_);
if (v___x_355_ == 0)
{
lean_object* v___x_356_; uint8_t v___x_357_; 
v___x_356_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__10));
v___x_357_ = l_Lean_Expr_isConstOf(v___x_347_, v___x_356_);
if (v___x_357_ == 0)
{
lean_object* v___x_358_; uint8_t v___x_359_; 
v___x_358_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__12));
v___x_359_ = l_Lean_Expr_isConstOf(v___x_347_, v___x_358_);
if (v___x_359_ == 0)
{
lean_object* v___x_360_; uint8_t v___x_361_; 
v___x_360_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__14));
v___x_361_ = l_Lean_Expr_isConstOf(v___x_347_, v___x_360_);
if (v___x_361_ == 0)
{
lean_object* v___x_362_; uint8_t v___x_363_; 
v___x_362_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__16));
v___x_363_ = l_Lean_Expr_isConstOf(v___x_347_, v___x_362_);
if (v___x_363_ == 0)
{
uint8_t v___x_364_; 
v___x_364_ = l_Lean_Expr_isApp(v___x_347_);
if (v___x_364_ == 0)
{
lean_dec_ref(v___x_347_);
lean_dec_ref(v_arg_346_);
goto v___jp_339_;
}
else
{
lean_object* v_arg_365_; lean_object* v___x_366_; lean_object* v___x_367_; uint8_t v___x_368_; 
v_arg_365_ = lean_ctor_get(v___x_347_, 1);
lean_inc_ref(v_arg_365_);
v___x_366_ = l_Lean_Expr_appFnCleanup___redArg(v___x_347_);
v___x_367_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__19));
v___x_368_ = l_Lean_Expr_isConstOf(v___x_366_, v___x_367_);
if (v___x_368_ == 0)
{
lean_object* v___x_369_; uint8_t v___x_370_; 
v___x_369_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__21));
v___x_370_ = l_Lean_Expr_isConstOf(v___x_366_, v___x_369_);
if (v___x_370_ == 0)
{
lean_object* v___x_371_; uint8_t v___x_372_; 
v___x_371_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__23));
v___x_372_ = l_Lean_Expr_isConstOf(v___x_366_, v___x_371_);
if (v___x_372_ == 0)
{
lean_object* v___x_373_; uint8_t v___x_374_; 
v___x_373_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__24));
v___x_374_ = l_Lean_Expr_isConstOf(v___x_366_, v___x_373_);
lean_dec_ref(v___x_366_);
if (v___x_374_ == 0)
{
lean_dec_ref(v_arg_365_);
lean_dec_ref(v_arg_346_);
goto v___jp_339_;
}
else
{
lean_object* v___x_375_; lean_object* v___x_376_; lean_object* v___x_377_; lean_object* v___x_378_; 
lean_del_object(v___x_337_);
v___x_375_ = lean_unsigned_to_nat(32u);
v___x_376_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__27, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__27_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__27);
v___x_377_ = l_Lean_Expr_app___override(v___x_376_, v_arg_346_);
v___x_378_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_365_, v___x_375_, v___x_377_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_378_;
}
}
else
{
lean_object* v___x_379_; lean_object* v___x_380_; lean_object* v___x_381_; lean_object* v___x_382_; 
lean_dec_ref(v___x_366_);
lean_del_object(v___x_337_);
v___x_379_ = lean_unsigned_to_nat(64u);
v___x_380_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__30, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__30_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__30);
v___x_381_ = l_Lean_Expr_app___override(v___x_380_, v_arg_346_);
v___x_382_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_365_, v___x_379_, v___x_381_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_382_;
}
}
else
{
lean_object* v___x_383_; lean_object* v___x_384_; lean_object* v___x_385_; lean_object* v___x_386_; 
lean_dec_ref(v___x_366_);
lean_del_object(v___x_337_);
v___x_383_ = lean_unsigned_to_nat(32u);
v___x_384_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__32, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__32_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__32);
v___x_385_ = l_Lean_Expr_app___override(v___x_384_, v_arg_346_);
v___x_386_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_365_, v___x_383_, v___x_385_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_386_;
}
}
else
{
lean_object* v___x_387_; lean_object* v___x_388_; lean_object* v___x_389_; lean_object* v___x_390_; 
lean_dec_ref(v___x_366_);
lean_del_object(v___x_337_);
v___x_387_ = lean_unsigned_to_nat(64u);
v___x_388_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__34, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__34_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__34);
v___x_389_ = l_Lean_Expr_app___override(v___x_388_, v_arg_346_);
v___x_390_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_365_, v___x_387_, v___x_389_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_390_;
}
}
}
else
{
lean_object* v___x_391_; lean_object* v___x_392_; lean_object* v___x_393_; 
lean_dec_ref(v___x_347_);
lean_del_object(v___x_337_);
v___x_391_ = lean_unsigned_to_nat(8u);
v___x_392_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__37, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__37_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__37);
v___x_393_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_346_, v___x_391_, v___x_392_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_393_;
}
}
else
{
lean_object* v___x_394_; lean_object* v___x_395_; lean_object* v___x_396_; 
lean_dec_ref(v___x_347_);
lean_del_object(v___x_337_);
v___x_394_ = lean_unsigned_to_nat(16u);
v___x_395_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__39, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__39_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__39);
v___x_396_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_346_, v___x_394_, v___x_395_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_396_;
}
}
else
{
lean_object* v___x_397_; lean_object* v___x_398_; lean_object* v___x_399_; 
lean_dec_ref(v___x_347_);
lean_del_object(v___x_337_);
v___x_397_ = lean_unsigned_to_nat(32u);
v___x_398_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__41, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__41_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__41);
v___x_399_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_346_, v___x_397_, v___x_398_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_399_;
}
}
else
{
lean_object* v___x_400_; lean_object* v___x_401_; lean_object* v___x_402_; 
lean_dec_ref(v___x_347_);
lean_del_object(v___x_337_);
v___x_400_ = lean_unsigned_to_nat(64u);
v___x_401_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__43, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__43_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__43);
v___x_402_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_346_, v___x_400_, v___x_401_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_402_;
}
}
else
{
lean_object* v___x_403_; lean_object* v___x_404_; lean_object* v___x_405_; 
lean_dec_ref(v___x_347_);
lean_del_object(v___x_337_);
v___x_403_ = lean_unsigned_to_nat(8u);
v___x_404_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__45, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__45_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__45);
v___x_405_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_346_, v___x_403_, v___x_404_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_405_;
}
}
else
{
lean_object* v___x_406_; lean_object* v___x_407_; lean_object* v___x_408_; 
lean_dec_ref(v___x_347_);
lean_del_object(v___x_337_);
v___x_406_ = lean_unsigned_to_nat(16u);
v___x_407_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__47, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__47_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__47);
v___x_408_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_346_, v___x_406_, v___x_407_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_408_;
}
}
else
{
lean_object* v___x_409_; lean_object* v___x_410_; lean_object* v___x_411_; 
lean_dec_ref(v___x_347_);
lean_del_object(v___x_337_);
v___x_409_ = lean_unsigned_to_nat(32u);
v___x_410_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__49, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__49_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__49);
v___x_411_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_346_, v___x_409_, v___x_410_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_411_;
}
}
else
{
lean_object* v___x_412_; lean_object* v___x_413_; lean_object* v___x_414_; 
lean_dec_ref(v___x_347_);
lean_del_object(v___x_337_);
v___x_412_ = lean_unsigned_to_nat(64u);
v___x_413_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__51, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__51_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___closed__51);
v___x_414_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg(v_arg_346_, v___x_412_, v___x_413_, v_a_327_, v_a_328_, v_a_329_, v_a_330_, v_a_331_, v_a_332_);
return v___x_414_;
}
}
v___jp_339_:
{
lean_object* v___x_340_; lean_object* v___x_342_; 
v___x_340_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__4));
if (v_isShared_338_ == 0)
{
lean_ctor_set(v___x_337_, 0, v___x_340_);
v___x_342_ = v___x_337_;
goto v_reusejp_341_;
}
else
{
lean_object* v_reuseFailAlloc_343_; 
v_reuseFailAlloc_343_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_343_, 0, v___x_340_);
v___x_342_ = v_reuseFailAlloc_343_;
goto v_reusejp_341_;
}
v_reusejp_341_:
{
return v___x_342_;
}
}
}
}
else
{
lean_object* v_a_416_; lean_object* v___x_418_; uint8_t v_isShared_419_; uint8_t v_isSharedCheck_423_; 
v_a_416_ = lean_ctor_get(v___x_334_, 0);
v_isSharedCheck_423_ = !lean_is_exclusive(v___x_334_);
if (v_isSharedCheck_423_ == 0)
{
v___x_418_ = v___x_334_;
v_isShared_419_ = v_isSharedCheck_423_;
goto v_resetjp_417_;
}
else
{
lean_inc(v_a_416_);
lean_dec(v___x_334_);
v___x_418_ = lean_box(0);
v_isShared_419_ = v_isSharedCheck_423_;
goto v_resetjp_417_;
}
v_resetjp_417_:
{
lean_object* v___x_421_; 
if (v_isShared_419_ == 0)
{
v___x_421_ = v___x_418_;
goto v_reusejp_420_;
}
else
{
lean_object* v_reuseFailAlloc_422_; 
v_reuseFailAlloc_422_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_422_, 0, v_a_416_);
v___x_421_ = v_reuseFailAlloc_422_;
goto v_reusejp_420_;
}
v_reusejp_420_:
{
return v___x_421_;
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg___boxed(lean_object* v_e_424_, lean_object* v_a_425_, lean_object* v_a_426_, lean_object* v_a_427_, lean_object* v_a_428_, lean_object* v_a_429_, lean_object* v_a_430_, lean_object* v_a_431_){
_start:
{
lean_object* v_res_432_; 
v_res_432_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg(v_e_424_, v_a_425_, v_a_426_, v_a_427_, v_a_428_, v_a_429_, v_a_430_);
lean_dec(v_a_430_);
lean_dec_ref(v_a_429_);
lean_dec(v_a_428_);
lean_dec_ref(v_a_427_);
lean_dec(v_a_426_);
lean_dec_ref(v_a_425_);
return v_res_432_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc(lean_object* v_e_433_, lean_object* v_a_434_, lean_object* v_a_435_, lean_object* v_a_436_, lean_object* v_a_437_, lean_object* v_a_438_, lean_object* v_a_439_, lean_object* v_a_440_, lean_object* v_a_441_, lean_object* v_a_442_){
_start:
{
lean_object* v___x_444_; 
v___x_444_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg(v_e_433_, v_a_437_, v_a_438_, v_a_439_, v_a_440_, v_a_441_, v_a_442_);
return v___x_444_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___boxed(lean_object* v_e_445_, lean_object* v_a_446_, lean_object* v_a_447_, lean_object* v_a_448_, lean_object* v_a_449_, lean_object* v_a_450_, lean_object* v_a_451_, lean_object* v_a_452_, lean_object* v_a_453_, lean_object* v_a_454_, lean_object* v_a_455_){
_start:
{
lean_object* v_res_456_; 
v_res_456_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc(v_e_445_, v_a_446_, v_a_447_, v_a_448_, v_a_449_, v_a_450_, v_a_451_, v_a_452_, v_a_453_, v_a_454_);
lean_dec(v_a_454_);
lean_dec_ref(v_a_453_);
lean_dec(v_a_452_);
lean_dec_ref(v_a_451_);
lean_dec(v_a_450_);
lean_dec_ref(v_a_449_);
lean_dec(v_a_448_);
lean_dec_ref(v_a_447_);
lean_dec(v_a_446_);
return v_res_456_;
}
}
LEAN_EXPORT lean_object* l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0___redArg(lean_object* v_e_457_, lean_object* v___y_458_){
_start:
{
uint8_t v___x_460_; 
v___x_460_ = l_Lean_Expr_hasMVar(v_e_457_);
if (v___x_460_ == 0)
{
lean_object* v___x_461_; 
v___x_461_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_461_, 0, v_e_457_);
return v___x_461_;
}
else
{
lean_object* v___x_462_; lean_object* v_mctx_463_; lean_object* v___x_464_; lean_object* v_fst_465_; lean_object* v_snd_466_; lean_object* v___x_467_; lean_object* v_cache_468_; lean_object* v_zetaDeltaFVarIds_469_; lean_object* v_postponed_470_; lean_object* v_diag_471_; lean_object* v___x_473_; uint8_t v_isShared_474_; uint8_t v_isSharedCheck_480_; 
v___x_462_ = lean_st_ref_get(v___y_458_);
v_mctx_463_ = lean_ctor_get(v___x_462_, 0);
lean_inc_ref(v_mctx_463_);
lean_dec(v___x_462_);
v___x_464_ = l_Lean_instantiateMVarsCore(v_mctx_463_, v_e_457_);
v_fst_465_ = lean_ctor_get(v___x_464_, 0);
lean_inc(v_fst_465_);
v_snd_466_ = lean_ctor_get(v___x_464_, 1);
lean_inc(v_snd_466_);
lean_dec_ref(v___x_464_);
v___x_467_ = lean_st_ref_take(v___y_458_);
v_cache_468_ = lean_ctor_get(v___x_467_, 1);
v_zetaDeltaFVarIds_469_ = lean_ctor_get(v___x_467_, 2);
v_postponed_470_ = lean_ctor_get(v___x_467_, 3);
v_diag_471_ = lean_ctor_get(v___x_467_, 4);
v_isSharedCheck_480_ = !lean_is_exclusive(v___x_467_);
if (v_isSharedCheck_480_ == 0)
{
lean_object* v_unused_481_; 
v_unused_481_ = lean_ctor_get(v___x_467_, 0);
lean_dec(v_unused_481_);
v___x_473_ = v___x_467_;
v_isShared_474_ = v_isSharedCheck_480_;
goto v_resetjp_472_;
}
else
{
lean_inc(v_diag_471_);
lean_inc(v_postponed_470_);
lean_inc(v_zetaDeltaFVarIds_469_);
lean_inc(v_cache_468_);
lean_dec(v___x_467_);
v___x_473_ = lean_box(0);
v_isShared_474_ = v_isSharedCheck_480_;
goto v_resetjp_472_;
}
v_resetjp_472_:
{
lean_object* v___x_476_; 
if (v_isShared_474_ == 0)
{
lean_ctor_set(v___x_473_, 0, v_snd_466_);
v___x_476_ = v___x_473_;
goto v_reusejp_475_;
}
else
{
lean_object* v_reuseFailAlloc_479_; 
v_reuseFailAlloc_479_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_479_, 0, v_snd_466_);
lean_ctor_set(v_reuseFailAlloc_479_, 1, v_cache_468_);
lean_ctor_set(v_reuseFailAlloc_479_, 2, v_zetaDeltaFVarIds_469_);
lean_ctor_set(v_reuseFailAlloc_479_, 3, v_postponed_470_);
lean_ctor_set(v_reuseFailAlloc_479_, 4, v_diag_471_);
v___x_476_ = v_reuseFailAlloc_479_;
goto v_reusejp_475_;
}
v_reusejp_475_:
{
lean_object* v___x_477_; lean_object* v___x_478_; 
v___x_477_ = lean_st_ref_set(v___y_458_, v___x_476_);
v___x_478_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_478_, 0, v_fst_465_);
return v___x_478_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0___redArg___boxed(lean_object* v_e_482_, lean_object* v___y_483_, lean_object* v___y_484_){
_start:
{
lean_object* v_res_485_; 
v_res_485_ = l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0___redArg(v_e_482_, v___y_483_);
lean_dec(v___y_483_);
return v_res_485_;
}
}
LEAN_EXPORT lean_object* l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0(lean_object* v_e_486_, lean_object* v___y_487_, lean_object* v___y_488_, lean_object* v___y_489_, lean_object* v___y_490_){
_start:
{
lean_object* v___x_492_; 
v___x_492_ = l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0___redArg(v_e_486_, v___y_488_);
return v___x_492_;
}
}
LEAN_EXPORT lean_object* l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0___boxed(lean_object* v_e_493_, lean_object* v___y_494_, lean_object* v___y_495_, lean_object* v___y_496_, lean_object* v___y_497_, lean_object* v___y_498_){
_start:
{
lean_object* v_res_499_; 
v_res_499_ = l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0(v_e_493_, v___y_494_, v___y_495_, v___y_496_, v___y_497_);
lean_dec(v___y_497_);
lean_dec_ref(v___y_496_);
lean_dec(v___y_495_);
lean_dec_ref(v___y_494_);
return v_res_499_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2___redArg(lean_object* v_mvarId_500_, lean_object* v_x_501_, lean_object* v___y_502_, lean_object* v___y_503_, lean_object* v___y_504_, lean_object* v___y_505_){
_start:
{
lean_object* v___x_507_; 
v___x_507_ = l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_box(0), v_mvarId_500_, v_x_501_, v___y_502_, v___y_503_, v___y_504_, v___y_505_);
if (lean_obj_tag(v___x_507_) == 0)
{
lean_object* v_a_508_; lean_object* v___x_510_; uint8_t v_isShared_511_; uint8_t v_isSharedCheck_515_; 
v_a_508_ = lean_ctor_get(v___x_507_, 0);
v_isSharedCheck_515_ = !lean_is_exclusive(v___x_507_);
if (v_isSharedCheck_515_ == 0)
{
v___x_510_ = v___x_507_;
v_isShared_511_ = v_isSharedCheck_515_;
goto v_resetjp_509_;
}
else
{
lean_inc(v_a_508_);
lean_dec(v___x_507_);
v___x_510_ = lean_box(0);
v_isShared_511_ = v_isSharedCheck_515_;
goto v_resetjp_509_;
}
v_resetjp_509_:
{
lean_object* v___x_513_; 
if (v_isShared_511_ == 0)
{
v___x_513_ = v___x_510_;
goto v_reusejp_512_;
}
else
{
lean_object* v_reuseFailAlloc_514_; 
v_reuseFailAlloc_514_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_514_, 0, v_a_508_);
v___x_513_ = v_reuseFailAlloc_514_;
goto v_reusejp_512_;
}
v_reusejp_512_:
{
return v___x_513_;
}
}
}
else
{
lean_object* v_a_516_; lean_object* v___x_518_; uint8_t v_isShared_519_; uint8_t v_isSharedCheck_523_; 
v_a_516_ = lean_ctor_get(v___x_507_, 0);
v_isSharedCheck_523_ = !lean_is_exclusive(v___x_507_);
if (v_isSharedCheck_523_ == 0)
{
v___x_518_ = v___x_507_;
v_isShared_519_ = v_isSharedCheck_523_;
goto v_resetjp_517_;
}
else
{
lean_inc(v_a_516_);
lean_dec(v___x_507_);
v___x_518_ = lean_box(0);
v_isShared_519_ = v_isSharedCheck_523_;
goto v_resetjp_517_;
}
v_resetjp_517_:
{
lean_object* v___x_521_; 
if (v_isShared_519_ == 0)
{
v___x_521_ = v___x_518_;
goto v_reusejp_520_;
}
else
{
lean_object* v_reuseFailAlloc_522_; 
v_reuseFailAlloc_522_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_522_, 0, v_a_516_);
v___x_521_ = v_reuseFailAlloc_522_;
goto v_reusejp_520_;
}
v_reusejp_520_:
{
return v___x_521_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2___redArg___boxed(lean_object* v_mvarId_524_, lean_object* v_x_525_, lean_object* v___y_526_, lean_object* v___y_527_, lean_object* v___y_528_, lean_object* v___y_529_, lean_object* v___y_530_){
_start:
{
lean_object* v_res_531_; 
v_res_531_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2___redArg(v_mvarId_524_, v_x_525_, v___y_526_, v___y_527_, v___y_528_, v___y_529_);
lean_dec(v___y_529_);
lean_dec_ref(v___y_528_);
lean_dec(v___y_527_);
lean_dec_ref(v___y_526_);
return v_res_531_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2(lean_object* v_00_u03b1_532_, lean_object* v_mvarId_533_, lean_object* v_x_534_, lean_object* v___y_535_, lean_object* v___y_536_, lean_object* v___y_537_, lean_object* v___y_538_){
_start:
{
lean_object* v___x_540_; 
v___x_540_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2___redArg(v_mvarId_533_, v_x_534_, v___y_535_, v___y_536_, v___y_537_, v___y_538_);
return v___x_540_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2___boxed(lean_object* v_00_u03b1_541_, lean_object* v_mvarId_542_, lean_object* v_x_543_, lean_object* v___y_544_, lean_object* v___y_545_, lean_object* v___y_546_, lean_object* v___y_547_, lean_object* v___y_548_){
_start:
{
lean_object* v_res_549_; 
v_res_549_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2(v_00_u03b1_541_, v_mvarId_542_, v_x_543_, v___y_544_, v___y_545_, v___y_546_, v___y_547_);
lean_dec(v___y_547_);
lean_dec_ref(v___y_546_);
lean_dec(v___y_545_);
lean_dec_ref(v___y_544_);
return v_res_549_;
}
}
static lean_object* _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__9(void){
_start:
{
lean_object* v___x_567_; lean_object* v___x_568_; 
v___x_567_ = lean_unsigned_to_nat(1u);
v___x_568_ = l_Lean_Level_ofNat(v___x_567_);
return v___x_568_;
}
}
static lean_object* _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__10(void){
_start:
{
lean_object* v___x_569_; lean_object* v___x_570_; lean_object* v___x_571_; 
v___x_569_ = lean_box(0);
v___x_570_ = lean_obj_once(&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__9, &l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__9_once, _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__9);
v___x_571_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v___x_571_, 0, v___x_570_);
lean_ctor_set(v___x_571_, 1, v___x_569_);
return v___x_571_;
}
}
static lean_object* _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__11(void){
_start:
{
lean_object* v___x_572_; lean_object* v___x_573_; lean_object* v___x_574_; 
v___x_572_ = lean_obj_once(&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__10, &l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__10_once, _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__10);
v___x_573_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__8));
v___x_574_ = l_Lean_mkConst(v___x_573_, v___x_572_);
return v___x_574_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1(lean_object* v_as_580_, size_t v_sz_581_, size_t v_i_582_, lean_object* v_b_583_, lean_object* v___y_584_, lean_object* v___y_585_, lean_object* v___y_586_, lean_object* v___y_587_){
_start:
{
uint8_t v___x_589_; 
v___x_589_ = lean_usize_dec_lt(v_i_582_, v_sz_581_);
if (v___x_589_ == 0)
{
lean_object* v___x_590_; 
v___x_590_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_590_, 0, v_b_583_);
return v___x_590_;
}
else
{
lean_object* v_a_591_; lean_object* v___x_592_; 
lean_dec_ref(v_b_583_);
v_a_591_ = lean_array_uget_borrowed(v_as_580_, v_i_582_);
lean_inc(v_a_591_);
v___x_592_ = l_Lean_FVarId_getType___redArg(v_a_591_, v___y_584_, v___y_586_, v___y_587_);
if (lean_obj_tag(v___x_592_) == 0)
{
lean_object* v_a_593_; lean_object* v___x_594_; 
v_a_593_ = lean_ctor_get(v___x_592_, 0);
lean_inc(v_a_593_);
lean_dec_ref_known(v___x_592_, 1);
v___x_594_ = l_Lean_instantiateMVars___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__0___redArg(v_a_593_, v___y_585_);
if (lean_obj_tag(v___x_594_) == 0)
{
lean_object* v_a_595_; lean_object* v___x_596_; 
v_a_595_ = lean_ctor_get(v___x_594_, 0);
lean_inc(v_a_595_);
lean_dec_ref_known(v___x_594_, 1);
v___x_596_ = l_Lean_Meta_instantiateMVarsIfMVarApp___redArg(v_a_595_, v___y_585_);
if (lean_obj_tag(v___x_596_) == 0)
{
lean_object* v_a_597_; lean_object* v_a_599_; lean_object* v___x_603_; lean_object* v___x_604_; lean_object* v___x_605_; uint8_t v___x_606_; 
v_a_597_ = lean_ctor_get(v___x_596_, 0);
lean_inc(v_a_597_);
lean_dec_ref_known(v___x_596_, 1);
v___x_603_ = lean_box(0);
v___x_604_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__0));
v___x_605_ = l_Lean_Expr_cleanupAnnotations(v_a_597_);
v___x_606_ = l_Lean_Expr_isApp(v___x_605_);
if (v___x_606_ == 0)
{
lean_dec_ref(v___x_605_);
v_a_599_ = v___x_604_;
goto v___jp_598_;
}
else
{
lean_object* v_arg_607_; lean_object* v___x_608_; uint8_t v___x_609_; 
v_arg_607_ = lean_ctor_get(v___x_605_, 1);
lean_inc_ref(v_arg_607_);
v___x_608_ = l_Lean_Expr_appFnCleanup___redArg(v___x_605_);
v___x_609_ = l_Lean_Expr_isApp(v___x_608_);
if (v___x_609_ == 0)
{
lean_dec_ref(v___x_608_);
lean_dec_ref(v_arg_607_);
v_a_599_ = v___x_604_;
goto v___jp_598_;
}
else
{
lean_object* v_arg_610_; lean_object* v___x_611_; uint8_t v___x_612_; 
v_arg_610_ = lean_ctor_get(v___x_608_, 1);
lean_inc_ref(v_arg_610_);
v___x_611_ = l_Lean_Expr_appFnCleanup___redArg(v___x_608_);
v___x_612_ = l_Lean_Expr_isApp(v___x_611_);
if (v___x_612_ == 0)
{
lean_dec_ref(v___x_611_);
lean_dec_ref(v_arg_610_);
lean_dec_ref(v_arg_607_);
v_a_599_ = v___x_604_;
goto v___jp_598_;
}
else
{
lean_object* v_arg_613_; lean_object* v___x_614_; lean_object* v___x_615_; uint8_t v___x_616_; 
v_arg_613_ = lean_ctor_get(v___x_611_, 1);
lean_inc_ref(v_arg_613_);
v___x_614_ = l_Lean_Expr_appFnCleanup___redArg(v___x_611_);
v___x_615_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__2));
v___x_616_ = l_Lean_Expr_isConstOf(v___x_614_, v___x_615_);
lean_dec_ref(v___x_614_);
if (v___x_616_ == 0)
{
lean_dec_ref(v_arg_613_);
lean_dec_ref(v_arg_610_);
lean_dec_ref(v_arg_607_);
v_a_599_ = v___x_604_;
goto v___jp_598_;
}
else
{
lean_object* v___x_617_; uint8_t v___x_618_; 
v___x_617_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__6));
v___x_618_ = l_Lean_Expr_isConstOf(v_arg_610_, v___x_617_);
if (v___x_618_ == 0)
{
uint8_t v___x_619_; 
v___x_619_ = l_Lean_Expr_isConstOf(v_arg_607_, v___x_617_);
if (v___x_619_ == 0)
{
lean_dec_ref(v_arg_613_);
lean_dec_ref(v_arg_610_);
lean_dec_ref(v_arg_607_);
v_a_599_ = v___x_604_;
goto v___jp_598_;
}
else
{
lean_object* v___x_620_; 
v___x_620_ = l_Lean_Meta_getNatValue_x3f(v_arg_610_, v___y_584_, v___y_585_, v___y_586_, v___y_587_);
if (lean_obj_tag(v___x_620_) == 0)
{
lean_object* v_a_621_; lean_object* v___x_623_; uint8_t v_isShared_624_; uint8_t v_isSharedCheck_646_; 
v_a_621_ = lean_ctor_get(v___x_620_, 0);
v_isSharedCheck_646_ = !lean_is_exclusive(v___x_620_);
if (v_isSharedCheck_646_ == 0)
{
v___x_623_ = v___x_620_;
v_isShared_624_ = v_isSharedCheck_646_;
goto v_resetjp_622_;
}
else
{
lean_inc(v_a_621_);
lean_dec(v___x_620_);
v___x_623_ = lean_box(0);
v_isShared_624_ = v_isSharedCheck_646_;
goto v_resetjp_622_;
}
v_resetjp_622_:
{
if (lean_obj_tag(v_a_621_) == 1)
{
lean_object* v_val_625_; lean_object* v___x_627_; uint8_t v_isShared_628_; uint8_t v_isSharedCheck_641_; 
v_val_625_ = lean_ctor_get(v_a_621_, 0);
v_isSharedCheck_641_ = !lean_is_exclusive(v_a_621_);
if (v_isSharedCheck_641_ == 0)
{
v___x_627_ = v_a_621_;
v_isShared_628_ = v_isSharedCheck_641_;
goto v_resetjp_626_;
}
else
{
lean_inc(v_val_625_);
lean_dec(v_a_621_);
v___x_627_ = lean_box(0);
v_isShared_628_ = v_isSharedCheck_641_;
goto v_resetjp_626_;
}
v_resetjp_626_:
{
lean_object* v___x_629_; lean_object* v___x_630_; lean_object* v___x_631_; lean_object* v___x_632_; lean_object* v___x_634_; 
v___x_629_ = lean_obj_once(&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__11, &l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__11_once, _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__11);
lean_inc(v_a_591_);
v___x_630_ = l_Lean_mkFVar(v_a_591_);
v___x_631_ = l_Lean_mkApp4(v___x_629_, v_arg_613_, v_arg_610_, v_arg_607_, v___x_630_);
v___x_632_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_632_, 0, v_val_625_);
lean_ctor_set(v___x_632_, 1, v___x_631_);
if (v_isShared_628_ == 0)
{
lean_ctor_set(v___x_627_, 0, v___x_632_);
v___x_634_ = v___x_627_;
goto v_reusejp_633_;
}
else
{
lean_object* v_reuseFailAlloc_640_; 
v_reuseFailAlloc_640_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_640_, 0, v___x_632_);
v___x_634_ = v_reuseFailAlloc_640_;
goto v_reusejp_633_;
}
v_reusejp_633_:
{
lean_object* v___x_635_; lean_object* v___x_636_; lean_object* v___x_638_; 
v___x_635_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_635_, 0, v___x_634_);
v___x_636_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_636_, 0, v___x_635_);
lean_ctor_set(v___x_636_, 1, v___x_603_);
if (v_isShared_624_ == 0)
{
lean_ctor_set(v___x_623_, 0, v___x_636_);
v___x_638_ = v___x_623_;
goto v_reusejp_637_;
}
else
{
lean_object* v_reuseFailAlloc_639_; 
v_reuseFailAlloc_639_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_639_, 0, v___x_636_);
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
else
{
lean_object* v___x_642_; lean_object* v___x_644_; 
lean_dec(v_a_621_);
lean_dec_ref(v_arg_613_);
lean_dec_ref(v_arg_610_);
lean_dec_ref(v_arg_607_);
v___x_642_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__13));
if (v_isShared_624_ == 0)
{
lean_ctor_set(v___x_623_, 0, v___x_642_);
v___x_644_ = v___x_623_;
goto v_reusejp_643_;
}
else
{
lean_object* v_reuseFailAlloc_645_; 
v_reuseFailAlloc_645_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_645_, 0, v___x_642_);
v___x_644_ = v_reuseFailAlloc_645_;
goto v_reusejp_643_;
}
v_reusejp_643_:
{
return v___x_644_;
}
}
}
}
else
{
lean_object* v_a_647_; lean_object* v___x_649_; uint8_t v_isShared_650_; uint8_t v_isSharedCheck_654_; 
lean_dec_ref(v_arg_613_);
lean_dec_ref(v_arg_610_);
lean_dec_ref(v_arg_607_);
v_a_647_ = lean_ctor_get(v___x_620_, 0);
v_isSharedCheck_654_ = !lean_is_exclusive(v___x_620_);
if (v_isSharedCheck_654_ == 0)
{
v___x_649_ = v___x_620_;
v_isShared_650_ = v_isSharedCheck_654_;
goto v_resetjp_648_;
}
else
{
lean_inc(v_a_647_);
lean_dec(v___x_620_);
v___x_649_ = lean_box(0);
v_isShared_650_ = v_isSharedCheck_654_;
goto v_resetjp_648_;
}
v_resetjp_648_:
{
lean_object* v___x_652_; 
if (v_isShared_650_ == 0)
{
v___x_652_ = v___x_649_;
goto v_reusejp_651_;
}
else
{
lean_object* v_reuseFailAlloc_653_; 
v_reuseFailAlloc_653_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_653_, 0, v_a_647_);
v___x_652_ = v_reuseFailAlloc_653_;
goto v_reusejp_651_;
}
v_reusejp_651_:
{
return v___x_652_;
}
}
}
}
}
else
{
lean_object* v___x_655_; 
lean_dec_ref(v_arg_613_);
lean_dec_ref(v_arg_610_);
v___x_655_ = l_Lean_Meta_getNatValue_x3f(v_arg_607_, v___y_584_, v___y_585_, v___y_586_, v___y_587_);
lean_dec_ref(v_arg_607_);
if (lean_obj_tag(v___x_655_) == 0)
{
lean_object* v_a_656_; lean_object* v___x_658_; uint8_t v_isShared_659_; uint8_t v_isSharedCheck_679_; 
v_a_656_ = lean_ctor_get(v___x_655_, 0);
v_isSharedCheck_679_ = !lean_is_exclusive(v___x_655_);
if (v_isSharedCheck_679_ == 0)
{
v___x_658_ = v___x_655_;
v_isShared_659_ = v_isSharedCheck_679_;
goto v_resetjp_657_;
}
else
{
lean_inc(v_a_656_);
lean_dec(v___x_655_);
v___x_658_ = lean_box(0);
v_isShared_659_ = v_isSharedCheck_679_;
goto v_resetjp_657_;
}
v_resetjp_657_:
{
if (lean_obj_tag(v_a_656_) == 1)
{
lean_object* v_val_660_; lean_object* v___x_662_; uint8_t v_isShared_663_; uint8_t v_isSharedCheck_674_; 
v_val_660_ = lean_ctor_get(v_a_656_, 0);
v_isSharedCheck_674_ = !lean_is_exclusive(v_a_656_);
if (v_isSharedCheck_674_ == 0)
{
v___x_662_ = v_a_656_;
v_isShared_663_ = v_isSharedCheck_674_;
goto v_resetjp_661_;
}
else
{
lean_inc(v_val_660_);
lean_dec(v_a_656_);
v___x_662_ = lean_box(0);
v_isShared_663_ = v_isSharedCheck_674_;
goto v_resetjp_661_;
}
v_resetjp_661_:
{
lean_object* v___x_664_; lean_object* v___x_665_; lean_object* v___x_667_; 
lean_inc(v_a_591_);
v___x_664_ = l_Lean_mkFVar(v_a_591_);
v___x_665_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_665_, 0, v_val_660_);
lean_ctor_set(v___x_665_, 1, v___x_664_);
if (v_isShared_663_ == 0)
{
lean_ctor_set(v___x_662_, 0, v___x_665_);
v___x_667_ = v___x_662_;
goto v_reusejp_666_;
}
else
{
lean_object* v_reuseFailAlloc_673_; 
v_reuseFailAlloc_673_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_673_, 0, v___x_665_);
v___x_667_ = v_reuseFailAlloc_673_;
goto v_reusejp_666_;
}
v_reusejp_666_:
{
lean_object* v___x_668_; lean_object* v___x_669_; lean_object* v___x_671_; 
v___x_668_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_668_, 0, v___x_667_);
v___x_669_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_669_, 0, v___x_668_);
lean_ctor_set(v___x_669_, 1, v___x_603_);
if (v_isShared_659_ == 0)
{
lean_ctor_set(v___x_658_, 0, v___x_669_);
v___x_671_ = v___x_658_;
goto v_reusejp_670_;
}
else
{
lean_object* v_reuseFailAlloc_672_; 
v_reuseFailAlloc_672_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_672_, 0, v___x_669_);
v___x_671_ = v_reuseFailAlloc_672_;
goto v_reusejp_670_;
}
v_reusejp_670_:
{
return v___x_671_;
}
}
}
}
else
{
lean_object* v___x_675_; lean_object* v___x_677_; 
lean_dec(v_a_656_);
v___x_675_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__13));
if (v_isShared_659_ == 0)
{
lean_ctor_set(v___x_658_, 0, v___x_675_);
v___x_677_ = v___x_658_;
goto v_reusejp_676_;
}
else
{
lean_object* v_reuseFailAlloc_678_; 
v_reuseFailAlloc_678_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_678_, 0, v___x_675_);
v___x_677_ = v_reuseFailAlloc_678_;
goto v_reusejp_676_;
}
v_reusejp_676_:
{
return v___x_677_;
}
}
}
}
else
{
lean_object* v_a_680_; lean_object* v___x_682_; uint8_t v_isShared_683_; uint8_t v_isSharedCheck_687_; 
v_a_680_ = lean_ctor_get(v___x_655_, 0);
v_isSharedCheck_687_ = !lean_is_exclusive(v___x_655_);
if (v_isSharedCheck_687_ == 0)
{
v___x_682_ = v___x_655_;
v_isShared_683_ = v_isSharedCheck_687_;
goto v_resetjp_681_;
}
else
{
lean_inc(v_a_680_);
lean_dec(v___x_655_);
v___x_682_ = lean_box(0);
v_isShared_683_ = v_isSharedCheck_687_;
goto v_resetjp_681_;
}
v_resetjp_681_:
{
lean_object* v___x_685_; 
if (v_isShared_683_ == 0)
{
v___x_685_ = v___x_682_;
goto v_reusejp_684_;
}
else
{
lean_object* v_reuseFailAlloc_686_; 
v_reuseFailAlloc_686_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_686_, 0, v_a_680_);
v___x_685_ = v_reuseFailAlloc_686_;
goto v_reusejp_684_;
}
v_reusejp_684_:
{
return v___x_685_;
}
}
}
}
}
}
}
}
v___jp_598_:
{
size_t v___x_600_; size_t v___x_601_; 
v___x_600_ = ((size_t)1ULL);
v___x_601_ = lean_usize_add(v_i_582_, v___x_600_);
lean_inc_ref(v_a_599_);
v_i_582_ = v___x_601_;
v_b_583_ = v_a_599_;
goto _start;
}
}
else
{
lean_object* v_a_688_; lean_object* v___x_690_; uint8_t v_isShared_691_; uint8_t v_isSharedCheck_695_; 
v_a_688_ = lean_ctor_get(v___x_596_, 0);
v_isSharedCheck_695_ = !lean_is_exclusive(v___x_596_);
if (v_isSharedCheck_695_ == 0)
{
v___x_690_ = v___x_596_;
v_isShared_691_ = v_isSharedCheck_695_;
goto v_resetjp_689_;
}
else
{
lean_inc(v_a_688_);
lean_dec(v___x_596_);
v___x_690_ = lean_box(0);
v_isShared_691_ = v_isSharedCheck_695_;
goto v_resetjp_689_;
}
v_resetjp_689_:
{
lean_object* v___x_693_; 
if (v_isShared_691_ == 0)
{
v___x_693_ = v___x_690_;
goto v_reusejp_692_;
}
else
{
lean_object* v_reuseFailAlloc_694_; 
v_reuseFailAlloc_694_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_694_, 0, v_a_688_);
v___x_693_ = v_reuseFailAlloc_694_;
goto v_reusejp_692_;
}
v_reusejp_692_:
{
return v___x_693_;
}
}
}
}
else
{
lean_object* v_a_696_; lean_object* v___x_698_; uint8_t v_isShared_699_; uint8_t v_isSharedCheck_703_; 
v_a_696_ = lean_ctor_get(v___x_594_, 0);
v_isSharedCheck_703_ = !lean_is_exclusive(v___x_594_);
if (v_isSharedCheck_703_ == 0)
{
v___x_698_ = v___x_594_;
v_isShared_699_ = v_isSharedCheck_703_;
goto v_resetjp_697_;
}
else
{
lean_inc(v_a_696_);
lean_dec(v___x_594_);
v___x_698_ = lean_box(0);
v_isShared_699_ = v_isSharedCheck_703_;
goto v_resetjp_697_;
}
v_resetjp_697_:
{
lean_object* v___x_701_; 
if (v_isShared_699_ == 0)
{
v___x_701_ = v___x_698_;
goto v_reusejp_700_;
}
else
{
lean_object* v_reuseFailAlloc_702_; 
v_reuseFailAlloc_702_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_702_, 0, v_a_696_);
v___x_701_ = v_reuseFailAlloc_702_;
goto v_reusejp_700_;
}
v_reusejp_700_:
{
return v___x_701_;
}
}
}
}
else
{
lean_object* v_a_704_; lean_object* v___x_706_; uint8_t v_isShared_707_; uint8_t v_isSharedCheck_711_; 
v_a_704_ = lean_ctor_get(v___x_592_, 0);
v_isSharedCheck_711_ = !lean_is_exclusive(v___x_592_);
if (v_isSharedCheck_711_ == 0)
{
v___x_706_ = v___x_592_;
v_isShared_707_ = v_isSharedCheck_711_;
goto v_resetjp_705_;
}
else
{
lean_inc(v_a_704_);
lean_dec(v___x_592_);
v___x_706_ = lean_box(0);
v_isShared_707_ = v_isSharedCheck_711_;
goto v_resetjp_705_;
}
v_resetjp_705_:
{
lean_object* v___x_709_; 
if (v_isShared_707_ == 0)
{
v___x_709_ = v___x_706_;
goto v_reusejp_708_;
}
else
{
lean_object* v_reuseFailAlloc_710_; 
v_reuseFailAlloc_710_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_710_, 0, v_a_704_);
v___x_709_ = v_reuseFailAlloc_710_;
goto v_reusejp_708_;
}
v_reusejp_708_:
{
return v___x_709_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___boxed(lean_object* v_as_712_, lean_object* v_sz_713_, lean_object* v_i_714_, lean_object* v_b_715_, lean_object* v___y_716_, lean_object* v___y_717_, lean_object* v___y_718_, lean_object* v___y_719_, lean_object* v___y_720_){
_start:
{
size_t v_sz_boxed_721_; size_t v_i_boxed_722_; lean_object* v_res_723_; 
v_sz_boxed_721_ = lean_unbox_usize(v_sz_713_);
lean_dec(v_sz_713_);
v_i_boxed_722_ = lean_unbox_usize(v_i_714_);
lean_dec(v_i_714_);
v_res_723_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1(v_as_712_, v_sz_boxed_721_, v_i_boxed_722_, v_b_715_, v___y_716_, v___y_717_, v___y_718_, v___y_719_);
lean_dec(v___y_719_);
lean_dec_ref(v___y_718_);
lean_dec(v___y_717_);
lean_dec_ref(v___y_716_);
lean_dec_ref(v_as_712_);
return v_res_723_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___lam__0(lean_object* v___y_724_, lean_object* v___y_725_, lean_object* v___y_726_, lean_object* v___y_727_){
_start:
{
lean_object* v___x_729_; 
v___x_729_ = l_Lean_Meta_getPropHyps(v___y_724_, v___y_725_, v___y_726_, v___y_727_);
if (lean_obj_tag(v___x_729_) == 0)
{
lean_object* v_a_730_; lean_object* v___x_731_; lean_object* v___x_732_; size_t v_sz_733_; size_t v___x_734_; lean_object* v___x_735_; 
v_a_730_ = lean_ctor_get(v___x_729_, 0);
lean_inc(v_a_730_);
lean_dec_ref_known(v___x_729_, 1);
v___x_731_ = lean_box(0);
v___x_732_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__0));
v_sz_733_ = lean_array_size(v_a_730_);
v___x_734_ = ((size_t)0ULL);
v___x_735_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1(v_a_730_, v_sz_733_, v___x_734_, v___x_732_, v___y_724_, v___y_725_, v___y_726_, v___y_727_);
lean_dec(v_a_730_);
if (lean_obj_tag(v___x_735_) == 0)
{
lean_object* v_a_736_; lean_object* v___x_738_; uint8_t v_isShared_739_; uint8_t v_isSharedCheck_748_; 
v_a_736_ = lean_ctor_get(v___x_735_, 0);
v_isSharedCheck_748_ = !lean_is_exclusive(v___x_735_);
if (v_isSharedCheck_748_ == 0)
{
v___x_738_ = v___x_735_;
v_isShared_739_ = v_isSharedCheck_748_;
goto v_resetjp_737_;
}
else
{
lean_inc(v_a_736_);
lean_dec(v___x_735_);
v___x_738_ = lean_box(0);
v_isShared_739_ = v_isSharedCheck_748_;
goto v_resetjp_737_;
}
v_resetjp_737_:
{
lean_object* v_fst_740_; 
v_fst_740_ = lean_ctor_get(v_a_736_, 0);
lean_inc(v_fst_740_);
lean_dec(v_a_736_);
if (lean_obj_tag(v_fst_740_) == 0)
{
lean_object* v___x_742_; 
if (v_isShared_739_ == 0)
{
lean_ctor_set(v___x_738_, 0, v___x_731_);
v___x_742_ = v___x_738_;
goto v_reusejp_741_;
}
else
{
lean_object* v_reuseFailAlloc_743_; 
v_reuseFailAlloc_743_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_743_, 0, v___x_731_);
v___x_742_ = v_reuseFailAlloc_743_;
goto v_reusejp_741_;
}
v_reusejp_741_:
{
return v___x_742_;
}
}
else
{
lean_object* v_val_744_; lean_object* v___x_746_; 
v_val_744_ = lean_ctor_get(v_fst_740_, 0);
lean_inc(v_val_744_);
lean_dec_ref_known(v_fst_740_, 1);
if (v_isShared_739_ == 0)
{
lean_ctor_set(v___x_738_, 0, v_val_744_);
v___x_746_ = v___x_738_;
goto v_reusejp_745_;
}
else
{
lean_object* v_reuseFailAlloc_747_; 
v_reuseFailAlloc_747_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_747_, 0, v_val_744_);
v___x_746_ = v_reuseFailAlloc_747_;
goto v_reusejp_745_;
}
v_reusejp_745_:
{
return v___x_746_;
}
}
}
}
else
{
lean_object* v_a_749_; lean_object* v___x_751_; uint8_t v_isShared_752_; uint8_t v_isSharedCheck_756_; 
v_a_749_ = lean_ctor_get(v___x_735_, 0);
v_isSharedCheck_756_ = !lean_is_exclusive(v___x_735_);
if (v_isSharedCheck_756_ == 0)
{
v___x_751_ = v___x_735_;
v_isShared_752_ = v_isSharedCheck_756_;
goto v_resetjp_750_;
}
else
{
lean_inc(v_a_749_);
lean_dec(v___x_735_);
v___x_751_ = lean_box(0);
v_isShared_752_ = v_isSharedCheck_756_;
goto v_resetjp_750_;
}
v_resetjp_750_:
{
lean_object* v___x_754_; 
if (v_isShared_752_ == 0)
{
v___x_754_ = v___x_751_;
goto v_reusejp_753_;
}
else
{
lean_object* v_reuseFailAlloc_755_; 
v_reuseFailAlloc_755_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_755_, 0, v_a_749_);
v___x_754_ = v_reuseFailAlloc_755_;
goto v_reusejp_753_;
}
v_reusejp_753_:
{
return v___x_754_;
}
}
}
}
else
{
lean_object* v_a_757_; lean_object* v___x_759_; uint8_t v_isShared_760_; uint8_t v_isSharedCheck_764_; 
v_a_757_ = lean_ctor_get(v___x_729_, 0);
v_isSharedCheck_764_ = !lean_is_exclusive(v___x_729_);
if (v_isSharedCheck_764_ == 0)
{
v___x_759_ = v___x_729_;
v_isShared_760_ = v_isSharedCheck_764_;
goto v_resetjp_758_;
}
else
{
lean_inc(v_a_757_);
lean_dec(v___x_729_);
v___x_759_ = lean_box(0);
v_isShared_760_ = v_isSharedCheck_764_;
goto v_resetjp_758_;
}
v_resetjp_758_:
{
lean_object* v___x_762_; 
if (v_isShared_760_ == 0)
{
v___x_762_ = v___x_759_;
goto v_reusejp_761_;
}
else
{
lean_object* v_reuseFailAlloc_763_; 
v_reuseFailAlloc_763_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_763_, 0, v_a_757_);
v___x_762_ = v_reuseFailAlloc_763_;
goto v_reusejp_761_;
}
v_reusejp_761_:
{
return v___x_762_;
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___lam__0___boxed(lean_object* v___y_765_, lean_object* v___y_766_, lean_object* v___y_767_, lean_object* v___y_768_, lean_object* v___y_769_){
_start:
{
lean_object* v_res_770_; 
v_res_770_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___lam__0(v___y_765_, v___y_766_, v___y_767_, v___y_768_);
lean_dec(v___y_768_);
lean_dec_ref(v___y_767_);
lean_dec(v___y_766_);
lean_dec_ref(v___y_765_);
return v_res_770_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq(lean_object* v_goal_772_, lean_object* v_a_773_, lean_object* v_a_774_, lean_object* v_a_775_, lean_object* v_a_776_){
_start:
{
lean_object* v___f_778_; lean_object* v___x_779_; 
v___f_778_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___closed__0));
v___x_779_ = l_Lean_MVarId_withContext___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__2___redArg(v_goal_772_, v___f_778_, v_a_773_, v_a_774_, v_a_775_, v_a_776_);
return v___x_779_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq___boxed(lean_object* v_goal_780_, lean_object* v_a_781_, lean_object* v_a_782_, lean_object* v_a_783_, lean_object* v_a_784_, lean_object* v_a_785_){
_start:
{
lean_object* v_res_786_; 
v_res_786_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq(v_goal_780_, v_a_781_, v_a_782_, v_a_783_, v_a_784_);
lean_dec(v_a_784_);
lean_dec_ref(v_a_783_);
lean_dec(v_a_782_);
lean_dec_ref(v_a_781_);
return v_res_786_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0(lean_object* v_a_789_, lean_object* v___y_790_, lean_object* v___y_791_, lean_object* v___y_792_, lean_object* v___y_793_, lean_object* v___y_794_, lean_object* v___y_795_, lean_object* v___y_796_, lean_object* v___y_797_, lean_object* v___y_798_, lean_object* v___y_799_){
_start:
{
if (lean_obj_tag(v_a_789_) == 1)
{
lean_object* v_val_801_; lean_object* v___x_803_; uint8_t v_isShared_804_; uint8_t v_isSharedCheck_863_; 
v_val_801_ = lean_ctor_get(v_a_789_, 0);
v_isSharedCheck_863_ = !lean_is_exclusive(v_a_789_);
if (v_isSharedCheck_863_ == 0)
{
v___x_803_ = v_a_789_;
v_isShared_804_ = v_isSharedCheck_863_;
goto v_resetjp_802_;
}
else
{
lean_inc(v_val_801_);
lean_dec(v_a_789_);
v___x_803_ = lean_box(0);
v_isShared_804_ = v_isSharedCheck_863_;
goto v_resetjp_802_;
}
v_resetjp_802_:
{
lean_object* v_fst_805_; lean_object* v_snd_806_; lean_object* v___x_807_; 
v_fst_805_ = lean_ctor_get(v_val_801_, 0);
lean_inc(v_fst_805_);
v_snd_806_ = lean_ctor_get(v_val_801_, 1);
lean_inc(v_snd_806_);
lean_dec(v_val_801_);
v___x_807_ = l_Lean_Meta_Sym_instantiateMVarsS(v___y_790_, v___y_794_, v___y_795_, v___y_796_, v___y_797_, v___y_798_, v___y_799_);
if (lean_obj_tag(v___x_807_) == 0)
{
lean_object* v_a_808_; lean_object* v___x_810_; uint8_t v_isShared_811_; uint8_t v_isSharedCheck_854_; 
v_a_808_ = lean_ctor_get(v___x_807_, 0);
v_isSharedCheck_854_ = !lean_is_exclusive(v___x_807_);
if (v_isSharedCheck_854_ == 0)
{
v___x_810_ = v___x_807_;
v_isShared_811_ = v_isSharedCheck_854_;
goto v_resetjp_809_;
}
else
{
lean_inc(v_a_808_);
lean_dec(v___x_807_);
v___x_810_ = lean_box(0);
v_isShared_811_ = v_isSharedCheck_854_;
goto v_resetjp_809_;
}
v_resetjp_809_:
{
lean_object* v___x_817_; uint8_t v___x_818_; 
v___x_817_ = l_Lean_Expr_cleanupAnnotations(v_a_808_);
v___x_818_ = l_Lean_Expr_isApp(v___x_817_);
if (v___x_818_ == 0)
{
lean_dec_ref(v___x_817_);
lean_dec(v_snd_806_);
lean_dec(v_fst_805_);
lean_del_object(v___x_803_);
goto v___jp_812_;
}
else
{
lean_object* v_arg_819_; lean_object* v___x_820_; uint8_t v___x_821_; 
v_arg_819_ = lean_ctor_get(v___x_817_, 1);
lean_inc_ref(v_arg_819_);
v___x_820_ = l_Lean_Expr_appFnCleanup___redArg(v___x_817_);
v___x_821_ = l_Lean_Expr_isApp(v___x_820_);
if (v___x_821_ == 0)
{
lean_dec_ref(v___x_820_);
lean_dec_ref(v_arg_819_);
lean_dec(v_snd_806_);
lean_dec(v_fst_805_);
lean_del_object(v___x_803_);
goto v___jp_812_;
}
else
{
lean_object* v_arg_822_; lean_object* v___x_823_; uint8_t v___x_824_; 
v_arg_822_ = lean_ctor_get(v___x_820_, 1);
lean_inc_ref(v_arg_822_);
v___x_823_ = l_Lean_Expr_appFnCleanup___redArg(v___x_820_);
v___x_824_ = l_Lean_Expr_isApp(v___x_823_);
if (v___x_824_ == 0)
{
lean_dec_ref(v___x_823_);
lean_dec_ref(v_arg_822_);
lean_dec_ref(v_arg_819_);
lean_dec(v_snd_806_);
lean_dec(v_fst_805_);
lean_del_object(v___x_803_);
goto v___jp_812_;
}
else
{
lean_object* v___x_825_; lean_object* v___x_826_; uint8_t v___x_827_; 
v___x_825_ = l_Lean_Expr_appFnCleanup___redArg(v___x_823_);
v___x_826_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__2));
v___x_827_ = l_Lean_Expr_isConstOf(v___x_825_, v___x_826_);
lean_dec_ref(v___x_825_);
if (v___x_827_ == 0)
{
lean_dec_ref(v_arg_822_);
lean_dec_ref(v_arg_819_);
lean_dec(v_snd_806_);
lean_dec(v_fst_805_);
lean_del_object(v___x_803_);
goto v___jp_812_;
}
else
{
lean_object* v___x_828_; uint8_t v___x_829_; 
lean_del_object(v___x_810_);
v___x_828_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00__private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq_spec__1___closed__6));
v___x_829_ = l_Lean_Expr_isConstOf(v_arg_822_, v___x_828_);
lean_dec_ref(v_arg_822_);
if (v___x_829_ == 0)
{
lean_object* v___x_830_; lean_object* v___x_832_; 
lean_dec_ref(v_arg_819_);
lean_dec(v_snd_806_);
lean_dec(v_fst_805_);
v___x_830_ = lean_alloc_ctor(0, 0, 1);
lean_ctor_set_uint8(v___x_830_, 0, v___x_829_);
if (v_isShared_804_ == 0)
{
lean_ctor_set_tag(v___x_803_, 0);
lean_ctor_set(v___x_803_, 0, v___x_830_);
v___x_832_ = v___x_803_;
goto v_reusejp_831_;
}
else
{
lean_object* v_reuseFailAlloc_833_; 
v_reuseFailAlloc_833_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_833_, 0, v___x_830_);
v___x_832_ = v_reuseFailAlloc_833_;
goto v_reusejp_831_;
}
v_reusejp_831_:
{
return v___x_832_;
}
}
else
{
lean_object* v___x_834_; 
v___x_834_ = l_Lean_Meta_Sym_getNatValue_x3f(v_arg_819_);
if (lean_obj_tag(v___x_834_) == 1)
{
lean_object* v_val_835_; lean_object* v___x_837_; uint8_t v_isShared_838_; uint8_t v_isSharedCheck_849_; 
lean_del_object(v___x_803_);
v_val_835_ = lean_ctor_get(v___x_834_, 0);
v_isSharedCheck_849_ = !lean_is_exclusive(v___x_834_);
if (v_isSharedCheck_849_ == 0)
{
v___x_837_ = v___x_834_;
v_isShared_838_ = v_isSharedCheck_849_;
goto v_resetjp_836_;
}
else
{
lean_inc(v_val_835_);
lean_dec(v___x_834_);
v___x_837_ = lean_box(0);
v_isShared_838_ = v_isSharedCheck_849_;
goto v_resetjp_836_;
}
v_resetjp_836_:
{
uint8_t v___x_839_; 
v___x_839_ = lean_nat_dec_eq(v_fst_805_, v_val_835_);
lean_dec(v_val_835_);
lean_dec(v_fst_805_);
if (v___x_839_ == 0)
{
lean_object* v___x_840_; lean_object* v___x_842_; 
lean_dec(v_snd_806_);
v___x_840_ = lean_alloc_ctor(0, 0, 1);
lean_ctor_set_uint8(v___x_840_, 0, v___x_839_);
if (v_isShared_838_ == 0)
{
lean_ctor_set_tag(v___x_837_, 0);
lean_ctor_set(v___x_837_, 0, v___x_840_);
v___x_842_ = v___x_837_;
goto v_reusejp_841_;
}
else
{
lean_object* v_reuseFailAlloc_843_; 
v_reuseFailAlloc_843_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_843_, 0, v___x_840_);
v___x_842_ = v_reuseFailAlloc_843_;
goto v_reusejp_841_;
}
v_reusejp_841_:
{
return v___x_842_;
}
}
else
{
uint8_t v___x_844_; lean_object* v___x_845_; lean_object* v___x_847_; 
v___x_844_ = 0;
v___x_845_ = lean_alloc_ctor(1, 1, 1);
lean_ctor_set(v___x_845_, 0, v_snd_806_);
lean_ctor_set_uint8(v___x_845_, sizeof(void*)*1, v___x_844_);
if (v_isShared_838_ == 0)
{
lean_ctor_set_tag(v___x_837_, 0);
lean_ctor_set(v___x_837_, 0, v___x_845_);
v___x_847_ = v___x_837_;
goto v_reusejp_846_;
}
else
{
lean_object* v_reuseFailAlloc_848_; 
v_reuseFailAlloc_848_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_848_, 0, v___x_845_);
v___x_847_ = v_reuseFailAlloc_848_;
goto v_reusejp_846_;
}
v_reusejp_846_:
{
return v___x_847_;
}
}
}
}
else
{
lean_object* v___x_850_; lean_object* v___x_852_; 
lean_dec(v___x_834_);
lean_dec(v_snd_806_);
lean_dec(v_fst_805_);
v___x_850_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0___closed__0));
if (v_isShared_804_ == 0)
{
lean_ctor_set_tag(v___x_803_, 0);
lean_ctor_set(v___x_803_, 0, v___x_850_);
v___x_852_ = v___x_803_;
goto v_reusejp_851_;
}
else
{
lean_object* v_reuseFailAlloc_853_; 
v_reuseFailAlloc_853_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_853_, 0, v___x_850_);
v___x_852_ = v_reuseFailAlloc_853_;
goto v_reusejp_851_;
}
v_reusejp_851_:
{
return v___x_852_;
}
}
}
}
}
}
}
v___jp_812_:
{
lean_object* v___x_813_; lean_object* v___x_815_; 
v___x_813_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0___closed__0));
if (v_isShared_811_ == 0)
{
lean_ctor_set(v___x_810_, 0, v___x_813_);
v___x_815_ = v___x_810_;
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
lean_object* v_a_855_; lean_object* v___x_857_; uint8_t v_isShared_858_; uint8_t v_isSharedCheck_862_; 
lean_dec(v_snd_806_);
lean_dec(v_fst_805_);
lean_del_object(v___x_803_);
v_a_855_ = lean_ctor_get(v___x_807_, 0);
v_isSharedCheck_862_ = !lean_is_exclusive(v___x_807_);
if (v_isSharedCheck_862_ == 0)
{
v___x_857_ = v___x_807_;
v_isShared_858_ = v_isSharedCheck_862_;
goto v_resetjp_856_;
}
else
{
lean_inc(v_a_855_);
lean_dec(v___x_807_);
v___x_857_ = lean_box(0);
v_isShared_858_ = v_isSharedCheck_862_;
goto v_resetjp_856_;
}
v_resetjp_856_:
{
lean_object* v___x_860_; 
if (v_isShared_858_ == 0)
{
v___x_860_ = v___x_857_;
goto v_reusejp_859_;
}
else
{
lean_object* v_reuseFailAlloc_861_; 
v_reuseFailAlloc_861_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_861_, 0, v_a_855_);
v___x_860_ = v_reuseFailAlloc_861_;
goto v_reusejp_859_;
}
v_reusejp_859_:
{
return v___x_860_;
}
}
}
}
}
else
{
lean_object* v___x_864_; 
lean_dec_ref(v___y_790_);
lean_dec(v_a_789_);
v___x_864_ = l_Lean_Meta_Sym_Simp_dischargeNone___redArg();
return v___x_864_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0___boxed(lean_object* v_a_865_, lean_object* v___y_866_, lean_object* v___y_867_, lean_object* v___y_868_, lean_object* v___y_869_, lean_object* v___y_870_, lean_object* v___y_871_, lean_object* v___y_872_, lean_object* v___y_873_, lean_object* v___y_874_, lean_object* v___y_875_, lean_object* v___y_876_){
_start:
{
lean_object* v_res_877_; 
v_res_877_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0(v_a_865_, v___y_866_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_, v___y_873_, v___y_874_, v___y_875_);
lean_dec(v___y_875_);
lean_dec_ref(v___y_874_);
lean_dec(v___y_873_);
lean_dec_ref(v___y_872_);
lean_dec(v___y_871_);
lean_dec_ref(v___y_870_);
lean_dec(v___y_869_);
lean_dec_ref(v___y_868_);
lean_dec(v___y_867_);
return v_res_877_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__1(lean_object* v_a_878_, lean_object* v___y_879_, lean_object* v_x_880_, lean_object* v___y_881_, lean_object* v___y_882_, lean_object* v___y_883_, lean_object* v___y_884_, lean_object* v___y_885_, lean_object* v___y_886_, lean_object* v___y_887_, lean_object* v___y_888_, lean_object* v___y_889_, lean_object* v___y_890_){
_start:
{
lean_object* v___x_892_; 
lean_inc_ref(v___y_881_);
v___x_892_ = l_Lean_Meta_Sym_Simp_Theorems_rewrite(v_a_878_, v___y_879_, v___y_881_, v___y_882_, v___y_883_, v___y_884_, v___y_885_, v___y_886_, v___y_887_, v___y_888_, v___y_889_, v___y_890_);
if (lean_obj_tag(v___x_892_) == 0)
{
lean_object* v_a_893_; 
v_a_893_ = lean_ctor_get(v___x_892_, 0);
lean_inc(v_a_893_);
if (lean_obj_tag(v_a_893_) == 0)
{
uint8_t v_done_894_; 
v_done_894_ = lean_ctor_get_uint8(v_a_893_, 0);
if (v_done_894_ == 0)
{
lean_object* v___x_896_; uint8_t v_isShared_897_; uint8_t v_isSharedCheck_908_; 
v_isSharedCheck_908_ = !lean_is_exclusive(v___x_892_);
if (v_isSharedCheck_908_ == 0)
{
lean_object* v_unused_909_; 
v_unused_909_ = lean_ctor_get(v___x_892_, 0);
lean_dec(v_unused_909_);
v___x_896_ = v___x_892_;
v_isShared_897_ = v_isSharedCheck_908_;
goto v_resetjp_895_;
}
else
{
lean_dec(v___x_892_);
v___x_896_ = lean_box(0);
v_isShared_897_ = v_isSharedCheck_908_;
goto v_resetjp_895_;
}
v_resetjp_895_:
{
uint8_t v_contextDependent_898_; lean_object* v___x_899_; 
v_contextDependent_898_ = lean_ctor_get_uint8(v_a_893_, 1);
lean_dec_ref_known(v_a_893_, 0);
v___x_899_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg(v___y_881_, v___y_885_, v___y_886_, v___y_887_, v___y_888_, v___y_889_, v___y_890_);
if (lean_obj_tag(v___x_899_) == 0)
{
lean_object* v_a_900_; uint8_t v___y_902_; 
v_a_900_ = lean_ctor_get(v___x_899_, 0);
lean_inc(v_a_900_);
if (v_contextDependent_898_ == 0)
{
lean_dec(v_a_900_);
lean_del_object(v___x_896_);
return v___x_899_;
}
else
{
uint8_t v___x_907_; 
lean_dec_ref_known(v___x_899_, 1);
v___x_907_ = 0;
v___y_902_ = v___x_907_;
goto v___jp_901_;
}
v___jp_901_:
{
lean_object* v___x_903_; lean_object* v___x_905_; 
v___x_903_ = l_Lean_Meta_Sym_Simp_Result_withContextDependent(v_a_900_);
if (v_isShared_897_ == 0)
{
lean_ctor_set(v___x_896_, 0, v___x_903_);
v___x_905_ = v___x_896_;
goto v_reusejp_904_;
}
else
{
lean_object* v_reuseFailAlloc_906_; 
v_reuseFailAlloc_906_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_906_, 0, v___x_903_);
v___x_905_ = v_reuseFailAlloc_906_;
goto v_reusejp_904_;
}
v_reusejp_904_:
{
return v___x_905_;
}
}
}
else
{
lean_del_object(v___x_896_);
return v___x_899_;
}
}
}
else
{
lean_dec_ref_known(v_a_893_, 0);
lean_dec_ref(v___y_881_);
return v___x_892_;
}
}
else
{
uint8_t v_done_910_; 
v_done_910_ = lean_ctor_get_uint8(v_a_893_, sizeof(void*)*2);
if (v_done_910_ == 0)
{
lean_object* v_e_x27_911_; lean_object* v_proof_912_; uint8_t v_contextDependent_913_; lean_object* v___x_915_; uint8_t v_isShared_916_; uint8_t v_isSharedCheck_961_; 
lean_dec_ref_known(v___x_892_, 1);
v_e_x27_911_ = lean_ctor_get(v_a_893_, 0);
v_proof_912_ = lean_ctor_get(v_a_893_, 1);
v_contextDependent_913_ = lean_ctor_get_uint8(v_a_893_, sizeof(void*)*2 + 1);
v_isSharedCheck_961_ = !lean_is_exclusive(v_a_893_);
if (v_isSharedCheck_961_ == 0)
{
v___x_915_ = v_a_893_;
v_isShared_916_ = v_isSharedCheck_961_;
goto v_resetjp_914_;
}
else
{
lean_inc(v_proof_912_);
lean_inc(v_e_x27_911_);
lean_dec(v_a_893_);
v___x_915_ = lean_box(0);
v_isShared_916_ = v_isSharedCheck_961_;
goto v_resetjp_914_;
}
v_resetjp_914_:
{
lean_object* v___x_917_; 
lean_inc_ref(v_e_x27_911_);
v___x_917_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc___redArg(v_e_x27_911_, v___y_885_, v___y_886_, v___y_887_, v___y_888_, v___y_889_, v___y_890_);
if (lean_obj_tag(v___x_917_) == 0)
{
lean_object* v_a_918_; lean_object* v___x_920_; uint8_t v_isShared_921_; uint8_t v_isSharedCheck_960_; 
v_a_918_ = lean_ctor_get(v___x_917_, 0);
v_isSharedCheck_960_ = !lean_is_exclusive(v___x_917_);
if (v_isSharedCheck_960_ == 0)
{
v___x_920_ = v___x_917_;
v_isShared_921_ = v_isSharedCheck_960_;
goto v_resetjp_919_;
}
else
{
lean_inc(v_a_918_);
lean_dec(v___x_917_);
v___x_920_ = lean_box(0);
v_isShared_921_ = v_isSharedCheck_960_;
goto v_resetjp_919_;
}
v_resetjp_919_:
{
if (lean_obj_tag(v_a_918_) == 0)
{
uint8_t v___x_922_; uint8_t v___y_924_; 
lean_dec_ref_known(v_a_918_, 0);
lean_dec_ref(v___y_881_);
v___x_922_ = 0;
if (v_contextDependent_913_ == 0)
{
v___y_924_ = v___x_922_;
goto v___jp_923_;
}
else
{
v___y_924_ = v_contextDependent_913_;
goto v___jp_923_;
}
v___jp_923_:
{
lean_object* v___x_926_; 
if (v_isShared_916_ == 0)
{
v___x_926_ = v___x_915_;
goto v_reusejp_925_;
}
else
{
lean_object* v_reuseFailAlloc_930_; 
v_reuseFailAlloc_930_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_930_, 0, v_e_x27_911_);
lean_ctor_set(v_reuseFailAlloc_930_, 1, v_proof_912_);
v___x_926_ = v_reuseFailAlloc_930_;
goto v_reusejp_925_;
}
v_reusejp_925_:
{
lean_object* v___x_928_; 
lean_ctor_set_uint8(v___x_926_, sizeof(void*)*2, v___x_922_);
lean_ctor_set_uint8(v___x_926_, sizeof(void*)*2 + 1, v___y_924_);
if (v_isShared_921_ == 0)
{
lean_ctor_set(v___x_920_, 0, v___x_926_);
v___x_928_ = v___x_920_;
goto v_reusejp_927_;
}
else
{
lean_object* v_reuseFailAlloc_929_; 
v_reuseFailAlloc_929_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_929_, 0, v___x_926_);
v___x_928_ = v_reuseFailAlloc_929_;
goto v_reusejp_927_;
}
v_reusejp_927_:
{
return v___x_928_;
}
}
}
}
else
{
lean_object* v_e_x27_931_; lean_object* v_proof_932_; lean_object* v___x_934_; uint8_t v_isShared_935_; uint8_t v_isSharedCheck_959_; 
lean_del_object(v___x_920_);
lean_del_object(v___x_915_);
v_e_x27_931_ = lean_ctor_get(v_a_918_, 0);
v_proof_932_ = lean_ctor_get(v_a_918_, 1);
v_isSharedCheck_959_ = !lean_is_exclusive(v_a_918_);
if (v_isSharedCheck_959_ == 0)
{
v___x_934_ = v_a_918_;
v_isShared_935_ = v_isSharedCheck_959_;
goto v_resetjp_933_;
}
else
{
lean_inc(v_proof_932_);
lean_inc(v_e_x27_931_);
lean_dec(v_a_918_);
v___x_934_ = lean_box(0);
v_isShared_935_ = v_isSharedCheck_959_;
goto v_resetjp_933_;
}
v_resetjp_933_:
{
uint8_t v___x_936_; lean_object* v___x_937_; 
v___x_936_ = 0;
lean_inc_ref(v_e_x27_931_);
v___x_937_ = l_Lean_Meta_Sym_Simp_mkEqTrans(v___y_881_, v_e_x27_911_, v_proof_912_, v_e_x27_931_, v_proof_932_, v___y_885_, v___y_886_, v___y_887_, v___y_888_, v___y_889_, v___y_890_);
if (lean_obj_tag(v___x_937_) == 0)
{
lean_object* v_a_938_; lean_object* v___x_940_; uint8_t v_isShared_941_; uint8_t v_isSharedCheck_950_; 
v_a_938_ = lean_ctor_get(v___x_937_, 0);
v_isSharedCheck_950_ = !lean_is_exclusive(v___x_937_);
if (v_isSharedCheck_950_ == 0)
{
v___x_940_ = v___x_937_;
v_isShared_941_ = v_isSharedCheck_950_;
goto v_resetjp_939_;
}
else
{
lean_inc(v_a_938_);
lean_dec(v___x_937_);
v___x_940_ = lean_box(0);
v_isShared_941_ = v_isSharedCheck_950_;
goto v_resetjp_939_;
}
v_resetjp_939_:
{
uint8_t v___y_943_; 
if (v_contextDependent_913_ == 0)
{
v___y_943_ = v___x_936_;
goto v___jp_942_;
}
else
{
v___y_943_ = v_contextDependent_913_;
goto v___jp_942_;
}
v___jp_942_:
{
lean_object* v___x_945_; 
if (v_isShared_935_ == 0)
{
lean_ctor_set(v___x_934_, 1, v_a_938_);
v___x_945_ = v___x_934_;
goto v_reusejp_944_;
}
else
{
lean_object* v_reuseFailAlloc_949_; 
v_reuseFailAlloc_949_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_949_, 0, v_e_x27_931_);
lean_ctor_set(v_reuseFailAlloc_949_, 1, v_a_938_);
v___x_945_ = v_reuseFailAlloc_949_;
goto v_reusejp_944_;
}
v_reusejp_944_:
{
lean_object* v___x_947_; 
lean_ctor_set_uint8(v___x_945_, sizeof(void*)*2, v___x_936_);
lean_ctor_set_uint8(v___x_945_, sizeof(void*)*2 + 1, v___y_943_);
if (v_isShared_941_ == 0)
{
lean_ctor_set(v___x_940_, 0, v___x_945_);
v___x_947_ = v___x_940_;
goto v_reusejp_946_;
}
else
{
lean_object* v_reuseFailAlloc_948_; 
v_reuseFailAlloc_948_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_948_, 0, v___x_945_);
v___x_947_ = v_reuseFailAlloc_948_;
goto v_reusejp_946_;
}
v_reusejp_946_:
{
return v___x_947_;
}
}
}
}
}
else
{
lean_object* v_a_951_; lean_object* v___x_953_; uint8_t v_isShared_954_; uint8_t v_isSharedCheck_958_; 
lean_del_object(v___x_934_);
lean_dec_ref(v_e_x27_931_);
v_a_951_ = lean_ctor_get(v___x_937_, 0);
v_isSharedCheck_958_ = !lean_is_exclusive(v___x_937_);
if (v_isSharedCheck_958_ == 0)
{
v___x_953_ = v___x_937_;
v_isShared_954_ = v_isSharedCheck_958_;
goto v_resetjp_952_;
}
else
{
lean_inc(v_a_951_);
lean_dec(v___x_937_);
v___x_953_ = lean_box(0);
v_isShared_954_ = v_isSharedCheck_958_;
goto v_resetjp_952_;
}
v_resetjp_952_:
{
lean_object* v___x_956_; 
if (v_isShared_954_ == 0)
{
v___x_956_ = v___x_953_;
goto v_reusejp_955_;
}
else
{
lean_object* v_reuseFailAlloc_957_; 
v_reuseFailAlloc_957_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_957_, 0, v_a_951_);
v___x_956_ = v_reuseFailAlloc_957_;
goto v_reusejp_955_;
}
v_reusejp_955_:
{
return v___x_956_;
}
}
}
}
}
}
}
else
{
lean_del_object(v___x_915_);
lean_dec_ref(v_proof_912_);
lean_dec_ref(v_e_x27_911_);
lean_dec_ref(v___y_881_);
return v___x_917_;
}
}
}
else
{
lean_dec_ref_known(v_a_893_, 2);
lean_dec_ref(v___y_881_);
return v___x_892_;
}
}
}
else
{
lean_dec_ref(v___y_881_);
return v___x_892_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__1___boxed(lean_object* v_a_962_, lean_object* v___y_963_, lean_object* v_x_964_, lean_object* v___y_965_, lean_object* v___y_966_, lean_object* v___y_967_, lean_object* v___y_968_, lean_object* v___y_969_, lean_object* v___y_970_, lean_object* v___y_971_, lean_object* v___y_972_, lean_object* v___y_973_, lean_object* v___y_974_, lean_object* v___y_975_){
_start:
{
lean_object* v_res_976_; 
v_res_976_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__1(v_a_962_, v___y_963_, v_x_964_, v___y_965_, v___y_966_, v___y_967_, v___y_968_, v___y_969_, v___y_970_, v___y_971_, v___y_972_, v___y_973_, v___y_974_);
lean_dec(v___y_974_);
lean_dec_ref(v___y_973_);
lean_dec(v___y_972_);
lean_dec_ref(v___y_971_);
lean_dec(v___y_970_);
lean_dec_ref(v___y_969_);
lean_dec(v___y_968_);
lean_dec_ref(v___y_967_);
lean_dec(v___y_966_);
lean_dec_ref(v_a_962_);
return v_res_976_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__2(lean_object* v_pre_977_, lean_object* v___f_978_, lean_object* v___y_979_, lean_object* v___y_980_, lean_object* v___y_981_, lean_object* v___y_982_, lean_object* v___y_983_, lean_object* v___y_984_, lean_object* v___y_985_, lean_object* v___y_986_, lean_object* v___y_987_, lean_object* v___y_988_){
_start:
{
lean_object* v___x_990_; 
lean_inc(v___y_988_);
lean_inc_ref(v___y_987_);
lean_inc(v___y_986_);
lean_inc_ref(v___y_985_);
lean_inc(v___y_984_);
lean_inc_ref(v___y_983_);
lean_inc(v___y_982_);
lean_inc_ref(v___y_981_);
lean_inc(v___y_980_);
lean_inc_ref(v___y_979_);
v___x_990_ = lean_apply_11(v_pre_977_, v___y_979_, v___y_980_, v___y_981_, v___y_982_, v___y_983_, v___y_984_, v___y_985_, v___y_986_, v___y_987_, v___y_988_, lean_box(0));
if (lean_obj_tag(v___x_990_) == 0)
{
lean_object* v_a_991_; lean_object* v___x_992_; 
v_a_991_ = lean_ctor_get(v___x_990_, 0);
lean_inc(v_a_991_);
v___x_992_ = lean_box(0);
if (lean_obj_tag(v_a_991_) == 0)
{
uint8_t v_done_993_; 
v_done_993_ = lean_ctor_get_uint8(v_a_991_, 0);
if (v_done_993_ == 0)
{
uint8_t v_contextDependent_994_; lean_object* v___x_995_; 
lean_dec_ref_known(v___x_990_, 1);
v_contextDependent_994_ = lean_ctor_get_uint8(v_a_991_, 1);
lean_dec_ref_known(v_a_991_, 0);
v___x_995_ = lean_apply_12(v___f_978_, v___x_992_, v___y_979_, v___y_980_, v___y_981_, v___y_982_, v___y_983_, v___y_984_, v___y_985_, v___y_986_, v___y_987_, v___y_988_, lean_box(0));
if (lean_obj_tag(v___x_995_) == 0)
{
lean_object* v_a_996_; uint8_t v___y_998_; 
v_a_996_ = lean_ctor_get(v___x_995_, 0);
lean_inc(v_a_996_);
if (v_contextDependent_994_ == 0)
{
lean_dec(v_a_996_);
return v___x_995_;
}
else
{
if (lean_obj_tag(v_a_996_) == 0)
{
uint8_t v_contextDependent_1008_; 
v_contextDependent_1008_ = lean_ctor_get_uint8(v_a_996_, 1);
v___y_998_ = v_contextDependent_1008_;
goto v___jp_997_;
}
else
{
uint8_t v_contextDependent_1009_; 
v_contextDependent_1009_ = lean_ctor_get_uint8(v_a_996_, sizeof(void*)*2 + 1);
v___y_998_ = v_contextDependent_1009_;
goto v___jp_997_;
}
}
v___jp_997_:
{
if (v___y_998_ == 0)
{
lean_object* v___x_1000_; uint8_t v_isShared_1001_; uint8_t v_isSharedCheck_1006_; 
v_isSharedCheck_1006_ = !lean_is_exclusive(v___x_995_);
if (v_isSharedCheck_1006_ == 0)
{
lean_object* v_unused_1007_; 
v_unused_1007_ = lean_ctor_get(v___x_995_, 0);
lean_dec(v_unused_1007_);
v___x_1000_ = v___x_995_;
v_isShared_1001_ = v_isSharedCheck_1006_;
goto v_resetjp_999_;
}
else
{
lean_dec(v___x_995_);
v___x_1000_ = lean_box(0);
v_isShared_1001_ = v_isSharedCheck_1006_;
goto v_resetjp_999_;
}
v_resetjp_999_:
{
lean_object* v___x_1002_; lean_object* v___x_1004_; 
v___x_1002_ = l_Lean_Meta_Sym_Simp_Result_withContextDependent(v_a_996_);
if (v_isShared_1001_ == 0)
{
lean_ctor_set(v___x_1000_, 0, v___x_1002_);
v___x_1004_ = v___x_1000_;
goto v_reusejp_1003_;
}
else
{
lean_object* v_reuseFailAlloc_1005_; 
v_reuseFailAlloc_1005_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1005_, 0, v___x_1002_);
v___x_1004_ = v_reuseFailAlloc_1005_;
goto v_reusejp_1003_;
}
v_reusejp_1003_:
{
return v___x_1004_;
}
}
}
else
{
lean_dec(v_a_996_);
return v___x_995_;
}
}
}
else
{
return v___x_995_;
}
}
else
{
lean_dec_ref_known(v_a_991_, 0);
lean_dec(v___y_988_);
lean_dec_ref(v___y_987_);
lean_dec(v___y_986_);
lean_dec_ref(v___y_985_);
lean_dec(v___y_984_);
lean_dec_ref(v___y_983_);
lean_dec(v___y_982_);
lean_dec_ref(v___y_981_);
lean_dec(v___y_980_);
lean_dec_ref(v___y_979_);
lean_dec_ref(v___f_978_);
return v___x_990_;
}
}
else
{
uint8_t v_done_1010_; 
v_done_1010_ = lean_ctor_get_uint8(v_a_991_, sizeof(void*)*2);
if (v_done_1010_ == 0)
{
lean_object* v_e_x27_1011_; lean_object* v_proof_1012_; uint8_t v_contextDependent_1013_; lean_object* v___x_1015_; uint8_t v_isShared_1016_; uint8_t v_isSharedCheck_1063_; 
lean_dec_ref_known(v___x_990_, 1);
v_e_x27_1011_ = lean_ctor_get(v_a_991_, 0);
v_proof_1012_ = lean_ctor_get(v_a_991_, 1);
v_contextDependent_1013_ = lean_ctor_get_uint8(v_a_991_, sizeof(void*)*2 + 1);
v_isSharedCheck_1063_ = !lean_is_exclusive(v_a_991_);
if (v_isSharedCheck_1063_ == 0)
{
v___x_1015_ = v_a_991_;
v_isShared_1016_ = v_isSharedCheck_1063_;
goto v_resetjp_1014_;
}
else
{
lean_inc(v_proof_1012_);
lean_inc(v_e_x27_1011_);
lean_dec(v_a_991_);
v___x_1015_ = lean_box(0);
v_isShared_1016_ = v_isSharedCheck_1063_;
goto v_resetjp_1014_;
}
v_resetjp_1014_:
{
lean_object* v___x_1017_; 
lean_inc(v___y_988_);
lean_inc_ref(v___y_987_);
lean_inc(v___y_986_);
lean_inc_ref(v___y_985_);
lean_inc(v___y_984_);
lean_inc_ref(v___y_983_);
lean_inc_ref(v_e_x27_1011_);
v___x_1017_ = lean_apply_12(v___f_978_, v___x_992_, v_e_x27_1011_, v___y_980_, v___y_981_, v___y_982_, v___y_983_, v___y_984_, v___y_985_, v___y_986_, v___y_987_, v___y_988_, lean_box(0));
if (lean_obj_tag(v___x_1017_) == 0)
{
lean_object* v_a_1018_; lean_object* v___x_1020_; uint8_t v_isShared_1021_; uint8_t v_isSharedCheck_1062_; 
v_a_1018_ = lean_ctor_get(v___x_1017_, 0);
v_isSharedCheck_1062_ = !lean_is_exclusive(v___x_1017_);
if (v_isSharedCheck_1062_ == 0)
{
v___x_1020_ = v___x_1017_;
v_isShared_1021_ = v_isSharedCheck_1062_;
goto v_resetjp_1019_;
}
else
{
lean_inc(v_a_1018_);
lean_dec(v___x_1017_);
v___x_1020_ = lean_box(0);
v_isShared_1021_ = v_isSharedCheck_1062_;
goto v_resetjp_1019_;
}
v_resetjp_1019_:
{
if (lean_obj_tag(v_a_1018_) == 0)
{
uint8_t v_done_1022_; uint8_t v_contextDependent_1023_; uint8_t v___y_1025_; 
lean_dec(v___y_988_);
lean_dec_ref(v___y_987_);
lean_dec(v___y_986_);
lean_dec_ref(v___y_985_);
lean_dec(v___y_984_);
lean_dec_ref(v___y_983_);
lean_dec_ref(v___y_979_);
v_done_1022_ = lean_ctor_get_uint8(v_a_1018_, 0);
v_contextDependent_1023_ = lean_ctor_get_uint8(v_a_1018_, 1);
lean_dec_ref_known(v_a_1018_, 0);
if (v_contextDependent_1013_ == 0)
{
v___y_1025_ = v_contextDependent_1023_;
goto v___jp_1024_;
}
else
{
v___y_1025_ = v_contextDependent_1013_;
goto v___jp_1024_;
}
v___jp_1024_:
{
lean_object* v___x_1027_; 
if (v_isShared_1016_ == 0)
{
v___x_1027_ = v___x_1015_;
goto v_reusejp_1026_;
}
else
{
lean_object* v_reuseFailAlloc_1031_; 
v_reuseFailAlloc_1031_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_1031_, 0, v_e_x27_1011_);
lean_ctor_set(v_reuseFailAlloc_1031_, 1, v_proof_1012_);
v___x_1027_ = v_reuseFailAlloc_1031_;
goto v_reusejp_1026_;
}
v_reusejp_1026_:
{
lean_object* v___x_1029_; 
lean_ctor_set_uint8(v___x_1027_, sizeof(void*)*2, v_done_1022_);
lean_ctor_set_uint8(v___x_1027_, sizeof(void*)*2 + 1, v___y_1025_);
if (v_isShared_1021_ == 0)
{
lean_ctor_set(v___x_1020_, 0, v___x_1027_);
v___x_1029_ = v___x_1020_;
goto v_reusejp_1028_;
}
else
{
lean_object* v_reuseFailAlloc_1030_; 
v_reuseFailAlloc_1030_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1030_, 0, v___x_1027_);
v___x_1029_ = v_reuseFailAlloc_1030_;
goto v_reusejp_1028_;
}
v_reusejp_1028_:
{
return v___x_1029_;
}
}
}
}
else
{
lean_object* v_e_x27_1032_; lean_object* v_proof_1033_; uint8_t v_done_1034_; uint8_t v_contextDependent_1035_; lean_object* v___x_1037_; uint8_t v_isShared_1038_; uint8_t v_isSharedCheck_1061_; 
lean_del_object(v___x_1020_);
lean_del_object(v___x_1015_);
v_e_x27_1032_ = lean_ctor_get(v_a_1018_, 0);
v_proof_1033_ = lean_ctor_get(v_a_1018_, 1);
v_done_1034_ = lean_ctor_get_uint8(v_a_1018_, sizeof(void*)*2);
v_contextDependent_1035_ = lean_ctor_get_uint8(v_a_1018_, sizeof(void*)*2 + 1);
v_isSharedCheck_1061_ = !lean_is_exclusive(v_a_1018_);
if (v_isSharedCheck_1061_ == 0)
{
v___x_1037_ = v_a_1018_;
v_isShared_1038_ = v_isSharedCheck_1061_;
goto v_resetjp_1036_;
}
else
{
lean_inc(v_proof_1033_);
lean_inc(v_e_x27_1032_);
lean_dec(v_a_1018_);
v___x_1037_ = lean_box(0);
v_isShared_1038_ = v_isSharedCheck_1061_;
goto v_resetjp_1036_;
}
v_resetjp_1036_:
{
lean_object* v___x_1039_; 
lean_inc_ref(v_e_x27_1032_);
v___x_1039_ = l_Lean_Meta_Sym_Simp_mkEqTrans(v___y_979_, v_e_x27_1011_, v_proof_1012_, v_e_x27_1032_, v_proof_1033_, v___y_983_, v___y_984_, v___y_985_, v___y_986_, v___y_987_, v___y_988_);
lean_dec(v___y_988_);
lean_dec_ref(v___y_987_);
lean_dec(v___y_986_);
lean_dec_ref(v___y_985_);
lean_dec(v___y_984_);
lean_dec_ref(v___y_983_);
if (lean_obj_tag(v___x_1039_) == 0)
{
lean_object* v_a_1040_; lean_object* v___x_1042_; uint8_t v_isShared_1043_; uint8_t v_isSharedCheck_1052_; 
v_a_1040_ = lean_ctor_get(v___x_1039_, 0);
v_isSharedCheck_1052_ = !lean_is_exclusive(v___x_1039_);
if (v_isSharedCheck_1052_ == 0)
{
v___x_1042_ = v___x_1039_;
v_isShared_1043_ = v_isSharedCheck_1052_;
goto v_resetjp_1041_;
}
else
{
lean_inc(v_a_1040_);
lean_dec(v___x_1039_);
v___x_1042_ = lean_box(0);
v_isShared_1043_ = v_isSharedCheck_1052_;
goto v_resetjp_1041_;
}
v_resetjp_1041_:
{
uint8_t v___y_1045_; 
if (v_contextDependent_1013_ == 0)
{
v___y_1045_ = v_contextDependent_1035_;
goto v___jp_1044_;
}
else
{
v___y_1045_ = v_contextDependent_1013_;
goto v___jp_1044_;
}
v___jp_1044_:
{
lean_object* v___x_1047_; 
if (v_isShared_1038_ == 0)
{
lean_ctor_set(v___x_1037_, 1, v_a_1040_);
v___x_1047_ = v___x_1037_;
goto v_reusejp_1046_;
}
else
{
lean_object* v_reuseFailAlloc_1051_; 
v_reuseFailAlloc_1051_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_1051_, 0, v_e_x27_1032_);
lean_ctor_set(v_reuseFailAlloc_1051_, 1, v_a_1040_);
lean_ctor_set_uint8(v_reuseFailAlloc_1051_, sizeof(void*)*2, v_done_1034_);
v___x_1047_ = v_reuseFailAlloc_1051_;
goto v_reusejp_1046_;
}
v_reusejp_1046_:
{
lean_object* v___x_1049_; 
lean_ctor_set_uint8(v___x_1047_, sizeof(void*)*2 + 1, v___y_1045_);
if (v_isShared_1043_ == 0)
{
lean_ctor_set(v___x_1042_, 0, v___x_1047_);
v___x_1049_ = v___x_1042_;
goto v_reusejp_1048_;
}
else
{
lean_object* v_reuseFailAlloc_1050_; 
v_reuseFailAlloc_1050_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1050_, 0, v___x_1047_);
v___x_1049_ = v_reuseFailAlloc_1050_;
goto v_reusejp_1048_;
}
v_reusejp_1048_:
{
return v___x_1049_;
}
}
}
}
}
else
{
lean_object* v_a_1053_; lean_object* v___x_1055_; uint8_t v_isShared_1056_; uint8_t v_isSharedCheck_1060_; 
lean_del_object(v___x_1037_);
lean_dec_ref(v_e_x27_1032_);
v_a_1053_ = lean_ctor_get(v___x_1039_, 0);
v_isSharedCheck_1060_ = !lean_is_exclusive(v___x_1039_);
if (v_isSharedCheck_1060_ == 0)
{
v___x_1055_ = v___x_1039_;
v_isShared_1056_ = v_isSharedCheck_1060_;
goto v_resetjp_1054_;
}
else
{
lean_inc(v_a_1053_);
lean_dec(v___x_1039_);
v___x_1055_ = lean_box(0);
v_isShared_1056_ = v_isSharedCheck_1060_;
goto v_resetjp_1054_;
}
v_resetjp_1054_:
{
lean_object* v___x_1058_; 
if (v_isShared_1056_ == 0)
{
v___x_1058_ = v___x_1055_;
goto v_reusejp_1057_;
}
else
{
lean_object* v_reuseFailAlloc_1059_; 
v_reuseFailAlloc_1059_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1059_, 0, v_a_1053_);
v___x_1058_ = v_reuseFailAlloc_1059_;
goto v_reusejp_1057_;
}
v_reusejp_1057_:
{
return v___x_1058_;
}
}
}
}
}
}
}
else
{
lean_del_object(v___x_1015_);
lean_dec_ref(v_proof_1012_);
lean_dec_ref(v_e_x27_1011_);
lean_dec(v___y_988_);
lean_dec_ref(v___y_987_);
lean_dec(v___y_986_);
lean_dec_ref(v___y_985_);
lean_dec(v___y_984_);
lean_dec_ref(v___y_983_);
lean_dec_ref(v___y_979_);
return v___x_1017_;
}
}
}
else
{
lean_dec_ref_known(v_a_991_, 2);
lean_dec(v___y_988_);
lean_dec_ref(v___y_987_);
lean_dec(v___y_986_);
lean_dec_ref(v___y_985_);
lean_dec(v___y_984_);
lean_dec_ref(v___y_983_);
lean_dec(v___y_982_);
lean_dec_ref(v___y_981_);
lean_dec(v___y_980_);
lean_dec_ref(v___y_979_);
lean_dec_ref(v___f_978_);
return v___x_990_;
}
}
}
else
{
lean_dec(v___y_988_);
lean_dec_ref(v___y_987_);
lean_dec(v___y_986_);
lean_dec_ref(v___y_985_);
lean_dec(v___y_984_);
lean_dec_ref(v___y_983_);
lean_dec(v___y_982_);
lean_dec_ref(v___y_981_);
lean_dec(v___y_980_);
lean_dec_ref(v___y_979_);
lean_dec_ref(v___f_978_);
return v___x_990_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__2___boxed(lean_object* v_pre_1064_, lean_object* v___f_1065_, lean_object* v___y_1066_, lean_object* v___y_1067_, lean_object* v___y_1068_, lean_object* v___y_1069_, lean_object* v___y_1070_, lean_object* v___y_1071_, lean_object* v___y_1072_, lean_object* v___y_1073_, lean_object* v___y_1074_, lean_object* v___y_1075_, lean_object* v___y_1076_){
_start:
{
lean_object* v_res_1077_; 
v_res_1077_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__2(v_pre_1064_, v___f_1065_, v___y_1066_, v___y_1067_, v___y_1068_, v___y_1069_, v___y_1070_, v___y_1071_, v___y_1072_, v___y_1073_, v___y_1074_, v___y_1075_);
return v_res_1077_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg(lean_object* v_goal_1078_, lean_object* v_methods_1079_, lean_object* v_a_1080_, lean_object* v_a_1081_, lean_object* v_a_1082_, lean_object* v_a_1083_){
_start:
{
lean_object* v___x_1085_; lean_object* v___x_1086_; 
v___x_1085_ = l_Lean_Meta_Tactic_BVDecide_symIntToBitVecExt;
v___x_1086_ = l_Lean_Meta_Sym_Simp_SymSimpExtension_getTheorems___redArg(v___x_1085_, v_a_1083_);
if (lean_obj_tag(v___x_1086_) == 0)
{
lean_object* v_a_1087_; lean_object* v___x_1088_; 
v_a_1087_ = lean_ctor_get(v___x_1086_, 0);
lean_inc(v_a_1087_);
lean_dec_ref_known(v___x_1086_, 1);
v___x_1088_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas_findNumBitsEq(v_goal_1078_, v_a_1080_, v_a_1081_, v_a_1082_, v_a_1083_);
if (lean_obj_tag(v___x_1088_) == 0)
{
lean_object* v_a_1089_; lean_object* v___x_1091_; uint8_t v_isShared_1092_; uint8_t v_isSharedCheck_1108_; 
v_a_1089_ = lean_ctor_get(v___x_1088_, 0);
v_isSharedCheck_1108_ = !lean_is_exclusive(v___x_1088_);
if (v_isSharedCheck_1108_ == 0)
{
v___x_1091_ = v___x_1088_;
v_isShared_1092_ = v_isSharedCheck_1108_;
goto v_resetjp_1090_;
}
else
{
lean_inc(v_a_1089_);
lean_dec(v___x_1088_);
v___x_1091_ = lean_box(0);
v_isShared_1092_ = v_isSharedCheck_1108_;
goto v_resetjp_1090_;
}
v_resetjp_1090_:
{
lean_object* v_pre_1093_; lean_object* v_post_1094_; lean_object* v___x_1096_; uint8_t v_isShared_1097_; uint8_t v_isSharedCheck_1107_; 
v_pre_1093_ = lean_ctor_get(v_methods_1079_, 0);
v_post_1094_ = lean_ctor_get(v_methods_1079_, 1);
v_isSharedCheck_1107_ = !lean_is_exclusive(v_methods_1079_);
if (v_isSharedCheck_1107_ == 0)
{
v___x_1096_ = v_methods_1079_;
v_isShared_1097_ = v_isSharedCheck_1107_;
goto v_resetjp_1095_;
}
else
{
lean_inc(v_post_1094_);
lean_inc(v_pre_1093_);
lean_dec(v_methods_1079_);
v___x_1096_ = lean_box(0);
v_isShared_1097_ = v_isSharedCheck_1107_;
goto v_resetjp_1095_;
}
v_resetjp_1095_:
{
lean_object* v___y_1098_; lean_object* v___f_1099_; lean_object* v___f_1100_; lean_object* v___x_1102_; 
v___y_1098_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__0___boxed), 12, 1);
lean_closure_set(v___y_1098_, 0, v_a_1089_);
v___f_1099_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__1___boxed), 14, 2);
lean_closure_set(v___f_1099_, 0, v_a_1087_);
lean_closure_set(v___f_1099_, 1, v___y_1098_);
v___f_1100_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___lam__2___boxed), 13, 2);
lean_closure_set(v___f_1100_, 0, v_pre_1093_);
lean_closure_set(v___f_1100_, 1, v___f_1099_);
if (v_isShared_1097_ == 0)
{
lean_ctor_set(v___x_1096_, 0, v___f_1100_);
v___x_1102_ = v___x_1096_;
goto v_reusejp_1101_;
}
else
{
lean_object* v_reuseFailAlloc_1106_; 
v_reuseFailAlloc_1106_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1106_, 0, v___f_1100_);
lean_ctor_set(v_reuseFailAlloc_1106_, 1, v_post_1094_);
v___x_1102_ = v_reuseFailAlloc_1106_;
goto v_reusejp_1101_;
}
v_reusejp_1101_:
{
lean_object* v___x_1104_; 
if (v_isShared_1092_ == 0)
{
lean_ctor_set(v___x_1091_, 0, v___x_1102_);
v___x_1104_ = v___x_1091_;
goto v_reusejp_1103_;
}
else
{
lean_object* v_reuseFailAlloc_1105_; 
v_reuseFailAlloc_1105_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1105_, 0, v___x_1102_);
v___x_1104_ = v_reuseFailAlloc_1105_;
goto v_reusejp_1103_;
}
v_reusejp_1103_:
{
return v___x_1104_;
}
}
}
}
}
else
{
lean_object* v_a_1109_; lean_object* v___x_1111_; uint8_t v_isShared_1112_; uint8_t v_isSharedCheck_1116_; 
lean_dec(v_a_1087_);
lean_dec_ref(v_methods_1079_);
v_a_1109_ = lean_ctor_get(v___x_1088_, 0);
v_isSharedCheck_1116_ = !lean_is_exclusive(v___x_1088_);
if (v_isSharedCheck_1116_ == 0)
{
v___x_1111_ = v___x_1088_;
v_isShared_1112_ = v_isSharedCheck_1116_;
goto v_resetjp_1110_;
}
else
{
lean_inc(v_a_1109_);
lean_dec(v___x_1088_);
v___x_1111_ = lean_box(0);
v_isShared_1112_ = v_isSharedCheck_1116_;
goto v_resetjp_1110_;
}
v_resetjp_1110_:
{
lean_object* v___x_1114_; 
if (v_isShared_1112_ == 0)
{
v___x_1114_ = v___x_1111_;
goto v_reusejp_1113_;
}
else
{
lean_object* v_reuseFailAlloc_1115_; 
v_reuseFailAlloc_1115_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1115_, 0, v_a_1109_);
v___x_1114_ = v_reuseFailAlloc_1115_;
goto v_reusejp_1113_;
}
v_reusejp_1113_:
{
return v___x_1114_;
}
}
}
}
else
{
lean_object* v_a_1117_; lean_object* v___x_1119_; uint8_t v_isShared_1120_; uint8_t v_isSharedCheck_1124_; 
lean_dec_ref(v_methods_1079_);
lean_dec(v_goal_1078_);
v_a_1117_ = lean_ctor_get(v___x_1086_, 0);
v_isSharedCheck_1124_ = !lean_is_exclusive(v___x_1086_);
if (v_isSharedCheck_1124_ == 0)
{
v___x_1119_ = v___x_1086_;
v_isShared_1120_ = v_isSharedCheck_1124_;
goto v_resetjp_1118_;
}
else
{
lean_inc(v_a_1117_);
lean_dec(v___x_1086_);
v___x_1119_ = lean_box(0);
v_isShared_1120_ = v_isSharedCheck_1124_;
goto v_resetjp_1118_;
}
v_resetjp_1118_:
{
lean_object* v___x_1122_; 
if (v_isShared_1120_ == 0)
{
v___x_1122_ = v___x_1119_;
goto v_reusejp_1121_;
}
else
{
lean_object* v_reuseFailAlloc_1123_; 
v_reuseFailAlloc_1123_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1123_, 0, v_a_1117_);
v___x_1122_ = v_reuseFailAlloc_1123_;
goto v_reusejp_1121_;
}
v_reusejp_1121_:
{
return v___x_1122_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg___boxed(lean_object* v_goal_1125_, lean_object* v_methods_1126_, lean_object* v_a_1127_, lean_object* v_a_1128_, lean_object* v_a_1129_, lean_object* v_a_1130_, lean_object* v_a_1131_){
_start:
{
lean_object* v_res_1132_; 
v_res_1132_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg(v_goal_1125_, v_methods_1126_, v_a_1127_, v_a_1128_, v_a_1129_, v_a_1130_);
lean_dec(v_a_1130_);
lean_dec_ref(v_a_1129_);
lean_dec(v_a_1128_);
lean_dec_ref(v_a_1127_);
return v_res_1132_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas(lean_object* v_goal_1133_, lean_object* v_methods_1134_, lean_object* v_a_1135_, lean_object* v_a_1136_, lean_object* v_a_1137_, lean_object* v_a_1138_, lean_object* v_a_1139_, lean_object* v_a_1140_){
_start:
{
lean_object* v___x_1142_; 
v___x_1142_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg(v_goal_1133_, v_methods_1134_, v_a_1137_, v_a_1138_, v_a_1139_, v_a_1140_);
return v___x_1142_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___boxed(lean_object* v_goal_1143_, lean_object* v_methods_1144_, lean_object* v_a_1145_, lean_object* v_a_1146_, lean_object* v_a_1147_, lean_object* v_a_1148_, lean_object* v_a_1149_, lean_object* v_a_1150_, lean_object* v_a_1151_){
_start:
{
lean_object* v_res_1152_; 
v_res_1152_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas(v_goal_1143_, v_methods_1144_, v_a_1145_, v_a_1146_, v_a_1147_, v_a_1148_, v_a_1149_, v_a_1150_);
lean_dec(v_a_1150_);
lean_dec_ref(v_a_1149_);
lean_dec(v_a_1148_);
lean_dec_ref(v_a_1147_);
lean_dec(v_a_1146_);
lean_dec_ref(v_a_1145_);
return v_res_1152_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg___lam__0(lean_object* v_x_1153_, lean_object* v___y_1154_, lean_object* v___y_1155_, lean_object* v___y_1156_, lean_object* v___y_1157_, lean_object* v___y_1158_, lean_object* v___y_1159_, lean_object* v___y_1160_, lean_object* v___y_1161_){
_start:
{
lean_object* v___x_1163_; 
lean_inc(v___y_1157_);
lean_inc_ref(v___y_1156_);
lean_inc(v___y_1155_);
lean_inc_ref(v___y_1154_);
v___x_1163_ = lean_apply_9(v_x_1153_, v___y_1154_, v___y_1155_, v___y_1156_, v___y_1157_, v___y_1158_, v___y_1159_, v___y_1160_, v___y_1161_, lean_box(0));
return v___x_1163_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg___lam__0___boxed(lean_object* v_x_1164_, lean_object* v___y_1165_, lean_object* v___y_1166_, lean_object* v___y_1167_, lean_object* v___y_1168_, lean_object* v___y_1169_, lean_object* v___y_1170_, lean_object* v___y_1171_, lean_object* v___y_1172_, lean_object* v___y_1173_){
_start:
{
lean_object* v_res_1174_; 
v_res_1174_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg___lam__0(v_x_1164_, v___y_1165_, v___y_1166_, v___y_1167_, v___y_1168_, v___y_1169_, v___y_1170_, v___y_1171_, v___y_1172_);
lean_dec(v___y_1168_);
lean_dec_ref(v___y_1167_);
lean_dec(v___y_1166_);
lean_dec_ref(v___y_1165_);
return v_res_1174_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg(lean_object* v_mvarId_1175_, lean_object* v_x_1176_, lean_object* v___y_1177_, lean_object* v___y_1178_, lean_object* v___y_1179_, lean_object* v___y_1180_, lean_object* v___y_1181_, lean_object* v___y_1182_, lean_object* v___y_1183_, lean_object* v___y_1184_){
_start:
{
lean_object* v___f_1186_; lean_object* v___x_1187_; 
lean_inc(v___y_1180_);
lean_inc_ref(v___y_1179_);
lean_inc(v___y_1178_);
lean_inc_ref(v___y_1177_);
v___f_1186_ = lean_alloc_closure((void*)(l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg___lam__0___boxed), 10, 5);
lean_closure_set(v___f_1186_, 0, v_x_1176_);
lean_closure_set(v___f_1186_, 1, v___y_1177_);
lean_closure_set(v___f_1186_, 2, v___y_1178_);
lean_closure_set(v___f_1186_, 3, v___y_1179_);
lean_closure_set(v___f_1186_, 4, v___y_1180_);
v___x_1187_ = l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_box(0), v_mvarId_1175_, v___f_1186_, v___y_1181_, v___y_1182_, v___y_1183_, v___y_1184_);
if (lean_obj_tag(v___x_1187_) == 0)
{
return v___x_1187_;
}
else
{
lean_object* v_a_1188_; lean_object* v___x_1190_; uint8_t v_isShared_1191_; uint8_t v_isSharedCheck_1195_; 
v_a_1188_ = lean_ctor_get(v___x_1187_, 0);
v_isSharedCheck_1195_ = !lean_is_exclusive(v___x_1187_);
if (v_isSharedCheck_1195_ == 0)
{
v___x_1190_ = v___x_1187_;
v_isShared_1191_ = v_isSharedCheck_1195_;
goto v_resetjp_1189_;
}
else
{
lean_inc(v_a_1188_);
lean_dec(v___x_1187_);
v___x_1190_ = lean_box(0);
v_isShared_1191_ = v_isSharedCheck_1195_;
goto v_resetjp_1189_;
}
v_resetjp_1189_:
{
lean_object* v___x_1193_; 
if (v_isShared_1191_ == 0)
{
v___x_1193_ = v___x_1190_;
goto v_reusejp_1192_;
}
else
{
lean_object* v_reuseFailAlloc_1194_; 
v_reuseFailAlloc_1194_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1194_, 0, v_a_1188_);
v___x_1193_ = v_reuseFailAlloc_1194_;
goto v_reusejp_1192_;
}
v_reusejp_1192_:
{
return v___x_1193_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg___boxed(lean_object* v_mvarId_1196_, lean_object* v_x_1197_, lean_object* v___y_1198_, lean_object* v___y_1199_, lean_object* v___y_1200_, lean_object* v___y_1201_, lean_object* v___y_1202_, lean_object* v___y_1203_, lean_object* v___y_1204_, lean_object* v___y_1205_, lean_object* v___y_1206_){
_start:
{
lean_object* v_res_1207_; 
v_res_1207_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg(v_mvarId_1196_, v_x_1197_, v___y_1198_, v___y_1199_, v___y_1200_, v___y_1201_, v___y_1202_, v___y_1203_, v___y_1204_, v___y_1205_);
lean_dec(v___y_1205_);
lean_dec_ref(v___y_1204_);
lean_dec(v___y_1203_);
lean_dec_ref(v___y_1202_);
lean_dec(v___y_1201_);
lean_dec_ref(v___y_1200_);
lean_dec(v___y_1199_);
lean_dec_ref(v___y_1198_);
return v_res_1207_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3(lean_object* v_00_u03b1_1208_, lean_object* v_mvarId_1209_, lean_object* v_x_1210_, lean_object* v___y_1211_, lean_object* v___y_1212_, lean_object* v___y_1213_, lean_object* v___y_1214_, lean_object* v___y_1215_, lean_object* v___y_1216_, lean_object* v___y_1217_, lean_object* v___y_1218_){
_start:
{
lean_object* v___x_1220_; 
v___x_1220_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg(v_mvarId_1209_, v_x_1210_, v___y_1211_, v___y_1212_, v___y_1213_, v___y_1214_, v___y_1215_, v___y_1216_, v___y_1217_, v___y_1218_);
return v___x_1220_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___boxed(lean_object* v_00_u03b1_1221_, lean_object* v_mvarId_1222_, lean_object* v_x_1223_, lean_object* v___y_1224_, lean_object* v___y_1225_, lean_object* v___y_1226_, lean_object* v___y_1227_, lean_object* v___y_1228_, lean_object* v___y_1229_, lean_object* v___y_1230_, lean_object* v___y_1231_, lean_object* v___y_1232_){
_start:
{
lean_object* v_res_1233_; 
v_res_1233_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3(v_00_u03b1_1221_, v_mvarId_1222_, v_x_1223_, v___y_1224_, v___y_1225_, v___y_1226_, v___y_1227_, v___y_1228_, v___y_1229_, v___y_1230_, v___y_1231_);
lean_dec(v___y_1231_);
lean_dec_ref(v___y_1230_);
lean_dec(v___y_1229_);
lean_dec_ref(v___y_1228_);
lean_dec(v___y_1227_);
lean_dec_ref(v___y_1226_);
lean_dec(v___y_1225_);
lean_dec_ref(v___y_1224_);
return v_res_1233_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__0(lean_object* v_x_1234_, lean_object* v___y_1235_, lean_object* v___y_1236_, lean_object* v___y_1237_, lean_object* v___y_1238_, lean_object* v___y_1239_, lean_object* v___y_1240_, lean_object* v___y_1241_, lean_object* v___y_1242_, lean_object* v___y_1243_){
_start:
{
lean_object* v___x_1245_; lean_object* v___x_1246_; 
v___x_1245_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec_0__Lean_Meta_Tactic_BVDecide_Normalize_toBitVecOfNatProc_runProc___redArg___closed__4));
v___x_1246_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1246_, 0, v___x_1245_);
return v___x_1246_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__0___boxed(lean_object* v_x_1247_, lean_object* v___y_1248_, lean_object* v___y_1249_, lean_object* v___y_1250_, lean_object* v___y_1251_, lean_object* v___y_1252_, lean_object* v___y_1253_, lean_object* v___y_1254_, lean_object* v___y_1255_, lean_object* v___y_1256_, lean_object* v___y_1257_){
_start:
{
lean_object* v_res_1258_; 
v_res_1258_ = l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__0(v_x_1247_, v___y_1248_, v___y_1249_, v___y_1250_, v___y_1251_, v___y_1252_, v___y_1253_, v___y_1254_, v___y_1255_, v___y_1256_);
lean_dec(v___y_1256_);
lean_dec_ref(v___y_1255_);
lean_dec(v___y_1254_);
lean_dec_ref(v___y_1253_);
lean_dec(v___y_1252_);
lean_dec_ref(v___y_1251_);
lean_dec(v___y_1250_);
lean_dec_ref(v___y_1249_);
lean_dec(v___y_1248_);
lean_dec_ref(v_x_1247_);
return v_res_1258_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(lean_object* v_x_1259_, lean_object* v_x_1260_, lean_object* v_x_1261_, lean_object* v_x_1262_){
_start:
{
lean_object* v_ks_1263_; lean_object* v_vs_1264_; lean_object* v___x_1266_; uint8_t v_isShared_1267_; uint8_t v_isSharedCheck_1288_; 
v_ks_1263_ = lean_ctor_get(v_x_1259_, 0);
v_vs_1264_ = lean_ctor_get(v_x_1259_, 1);
v_isSharedCheck_1288_ = !lean_is_exclusive(v_x_1259_);
if (v_isSharedCheck_1288_ == 0)
{
v___x_1266_ = v_x_1259_;
v_isShared_1267_ = v_isSharedCheck_1288_;
goto v_resetjp_1265_;
}
else
{
lean_inc(v_vs_1264_);
lean_inc(v_ks_1263_);
lean_dec(v_x_1259_);
v___x_1266_ = lean_box(0);
v_isShared_1267_ = v_isSharedCheck_1288_;
goto v_resetjp_1265_;
}
v_resetjp_1265_:
{
lean_object* v___x_1268_; uint8_t v___x_1269_; 
v___x_1268_ = lean_array_get_size(v_ks_1263_);
v___x_1269_ = lean_nat_dec_lt(v_x_1260_, v___x_1268_);
if (v___x_1269_ == 0)
{
lean_object* v___x_1270_; lean_object* v___x_1271_; lean_object* v___x_1273_; 
lean_dec(v_x_1260_);
v___x_1270_ = lean_array_push(v_ks_1263_, v_x_1261_);
v___x_1271_ = lean_array_push(v_vs_1264_, v_x_1262_);
if (v_isShared_1267_ == 0)
{
lean_ctor_set(v___x_1266_, 1, v___x_1271_);
lean_ctor_set(v___x_1266_, 0, v___x_1270_);
v___x_1273_ = v___x_1266_;
goto v_reusejp_1272_;
}
else
{
lean_object* v_reuseFailAlloc_1274_; 
v_reuseFailAlloc_1274_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1274_, 0, v___x_1270_);
lean_ctor_set(v_reuseFailAlloc_1274_, 1, v___x_1271_);
v___x_1273_ = v_reuseFailAlloc_1274_;
goto v_reusejp_1272_;
}
v_reusejp_1272_:
{
return v___x_1273_;
}
}
else
{
lean_object* v_k_x27_1275_; uint8_t v___x_1276_; 
v_k_x27_1275_ = lean_array_fget_borrowed(v_ks_1263_, v_x_1260_);
v___x_1276_ = l_Lean_instBEqMVarId_beq(v_x_1261_, v_k_x27_1275_);
if (v___x_1276_ == 0)
{
lean_object* v___x_1278_; 
if (v_isShared_1267_ == 0)
{
v___x_1278_ = v___x_1266_;
goto v_reusejp_1277_;
}
else
{
lean_object* v_reuseFailAlloc_1282_; 
v_reuseFailAlloc_1282_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1282_, 0, v_ks_1263_);
lean_ctor_set(v_reuseFailAlloc_1282_, 1, v_vs_1264_);
v___x_1278_ = v_reuseFailAlloc_1282_;
goto v_reusejp_1277_;
}
v_reusejp_1277_:
{
lean_object* v___x_1279_; lean_object* v___x_1280_; 
v___x_1279_ = lean_unsigned_to_nat(1u);
v___x_1280_ = lean_nat_add(v_x_1260_, v___x_1279_);
lean_dec(v_x_1260_);
v_x_1259_ = v___x_1278_;
v_x_1260_ = v___x_1280_;
goto _start;
}
}
else
{
lean_object* v___x_1283_; lean_object* v___x_1284_; lean_object* v___x_1286_; 
v___x_1283_ = lean_array_fset(v_ks_1263_, v_x_1260_, v_x_1261_);
v___x_1284_ = lean_array_fset(v_vs_1264_, v_x_1260_, v_x_1262_);
lean_dec(v_x_1260_);
if (v_isShared_1267_ == 0)
{
lean_ctor_set(v___x_1266_, 1, v___x_1284_);
lean_ctor_set(v___x_1266_, 0, v___x_1283_);
v___x_1286_ = v___x_1266_;
goto v_reusejp_1285_;
}
else
{
lean_object* v_reuseFailAlloc_1287_; 
v_reuseFailAlloc_1287_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1287_, 0, v___x_1283_);
lean_ctor_set(v_reuseFailAlloc_1287_, 1, v___x_1284_);
v___x_1286_ = v_reuseFailAlloc_1287_;
goto v_reusejp_1285_;
}
v_reusejp_1285_:
{
return v___x_1286_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6___redArg(lean_object* v_n_1289_, lean_object* v_k_1290_, lean_object* v_v_1291_){
_start:
{
lean_object* v___x_1292_; lean_object* v___x_1293_; 
v___x_1292_ = lean_unsigned_to_nat(0u);
v___x_1293_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(v_n_1289_, v___x_1292_, v_k_1290_, v_v_1291_);
return v___x_1293_;
}
}
static lean_object* _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg___closed__0(void){
_start:
{
lean_object* v___x_1294_; 
v___x_1294_ = l_Lean_PersistentHashMap_mkEmptyEntries(lean_box(0), lean_box(0));
return v___x_1294_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg(lean_object* v_x_1295_, size_t v_x_1296_, size_t v_x_1297_, lean_object* v_x_1298_, lean_object* v_x_1299_){
_start:
{
if (lean_obj_tag(v_x_1295_) == 0)
{
lean_object* v_es_1300_; size_t v___x_1301_; size_t v___x_1302_; lean_object* v_j_1303_; lean_object* v___x_1304_; uint8_t v___x_1305_; 
v_es_1300_ = lean_ctor_get(v_x_1295_, 0);
v___x_1301_ = ((size_t)31ULL);
v___x_1302_ = lean_usize_land(v_x_1296_, v___x_1301_);
v_j_1303_ = lean_usize_to_nat(v___x_1302_);
v___x_1304_ = lean_array_get_size(v_es_1300_);
v___x_1305_ = lean_nat_dec_lt(v_j_1303_, v___x_1304_);
if (v___x_1305_ == 0)
{
lean_dec(v_j_1303_);
lean_dec(v_x_1299_);
lean_dec(v_x_1298_);
return v_x_1295_;
}
else
{
lean_object* v___x_1307_; uint8_t v_isShared_1308_; uint8_t v_isSharedCheck_1344_; 
lean_inc_ref(v_es_1300_);
v_isSharedCheck_1344_ = !lean_is_exclusive(v_x_1295_);
if (v_isSharedCheck_1344_ == 0)
{
lean_object* v_unused_1345_; 
v_unused_1345_ = lean_ctor_get(v_x_1295_, 0);
lean_dec(v_unused_1345_);
v___x_1307_ = v_x_1295_;
v_isShared_1308_ = v_isSharedCheck_1344_;
goto v_resetjp_1306_;
}
else
{
lean_dec(v_x_1295_);
v___x_1307_ = lean_box(0);
v_isShared_1308_ = v_isSharedCheck_1344_;
goto v_resetjp_1306_;
}
v_resetjp_1306_:
{
lean_object* v_v_1309_; lean_object* v___x_1310_; lean_object* v_xs_x27_1311_; lean_object* v___y_1313_; 
v_v_1309_ = lean_array_fget(v_es_1300_, v_j_1303_);
v___x_1310_ = lean_box(0);
v_xs_x27_1311_ = lean_array_fset(v_es_1300_, v_j_1303_, v___x_1310_);
switch(lean_obj_tag(v_v_1309_))
{
case 0:
{
lean_object* v_key_1318_; lean_object* v_val_1319_; lean_object* v___x_1321_; uint8_t v_isShared_1322_; uint8_t v_isSharedCheck_1329_; 
v_key_1318_ = lean_ctor_get(v_v_1309_, 0);
v_val_1319_ = lean_ctor_get(v_v_1309_, 1);
v_isSharedCheck_1329_ = !lean_is_exclusive(v_v_1309_);
if (v_isSharedCheck_1329_ == 0)
{
v___x_1321_ = v_v_1309_;
v_isShared_1322_ = v_isSharedCheck_1329_;
goto v_resetjp_1320_;
}
else
{
lean_inc(v_val_1319_);
lean_inc(v_key_1318_);
lean_dec(v_v_1309_);
v___x_1321_ = lean_box(0);
v_isShared_1322_ = v_isSharedCheck_1329_;
goto v_resetjp_1320_;
}
v_resetjp_1320_:
{
uint8_t v___x_1323_; 
v___x_1323_ = l_Lean_instBEqMVarId_beq(v_x_1298_, v_key_1318_);
if (v___x_1323_ == 0)
{
lean_object* v___x_1324_; lean_object* v___x_1325_; 
lean_del_object(v___x_1321_);
v___x_1324_ = l_Lean_PersistentHashMap_mkCollisionNode___redArg(v_key_1318_, v_val_1319_, v_x_1298_, v_x_1299_);
v___x_1325_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_1325_, 0, v___x_1324_);
v___y_1313_ = v___x_1325_;
goto v___jp_1312_;
}
else
{
lean_object* v___x_1327_; 
lean_dec(v_val_1319_);
lean_dec(v_key_1318_);
if (v_isShared_1322_ == 0)
{
lean_ctor_set(v___x_1321_, 1, v_x_1299_);
lean_ctor_set(v___x_1321_, 0, v_x_1298_);
v___x_1327_ = v___x_1321_;
goto v_reusejp_1326_;
}
else
{
lean_object* v_reuseFailAlloc_1328_; 
v_reuseFailAlloc_1328_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1328_, 0, v_x_1298_);
lean_ctor_set(v_reuseFailAlloc_1328_, 1, v_x_1299_);
v___x_1327_ = v_reuseFailAlloc_1328_;
goto v_reusejp_1326_;
}
v_reusejp_1326_:
{
v___y_1313_ = v___x_1327_;
goto v___jp_1312_;
}
}
}
}
case 1:
{
lean_object* v_node_1330_; lean_object* v___x_1332_; uint8_t v_isShared_1333_; uint8_t v_isSharedCheck_1342_; 
v_node_1330_ = lean_ctor_get(v_v_1309_, 0);
v_isSharedCheck_1342_ = !lean_is_exclusive(v_v_1309_);
if (v_isSharedCheck_1342_ == 0)
{
v___x_1332_ = v_v_1309_;
v_isShared_1333_ = v_isSharedCheck_1342_;
goto v_resetjp_1331_;
}
else
{
lean_inc(v_node_1330_);
lean_dec(v_v_1309_);
v___x_1332_ = lean_box(0);
v_isShared_1333_ = v_isSharedCheck_1342_;
goto v_resetjp_1331_;
}
v_resetjp_1331_:
{
size_t v___x_1334_; size_t v___x_1335_; size_t v___x_1336_; size_t v___x_1337_; lean_object* v___x_1338_; lean_object* v___x_1340_; 
v___x_1334_ = ((size_t)5ULL);
v___x_1335_ = lean_usize_shift_right(v_x_1296_, v___x_1334_);
v___x_1336_ = ((size_t)1ULL);
v___x_1337_ = lean_usize_add(v_x_1297_, v___x_1336_);
v___x_1338_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg(v_node_1330_, v___x_1335_, v___x_1337_, v_x_1298_, v_x_1299_);
if (v_isShared_1333_ == 0)
{
lean_ctor_set(v___x_1332_, 0, v___x_1338_);
v___x_1340_ = v___x_1332_;
goto v_reusejp_1339_;
}
else
{
lean_object* v_reuseFailAlloc_1341_; 
v_reuseFailAlloc_1341_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1341_, 0, v___x_1338_);
v___x_1340_ = v_reuseFailAlloc_1341_;
goto v_reusejp_1339_;
}
v_reusejp_1339_:
{
v___y_1313_ = v___x_1340_;
goto v___jp_1312_;
}
}
}
default: 
{
lean_object* v___x_1343_; 
v___x_1343_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1343_, 0, v_x_1298_);
lean_ctor_set(v___x_1343_, 1, v_x_1299_);
v___y_1313_ = v___x_1343_;
goto v___jp_1312_;
}
}
v___jp_1312_:
{
lean_object* v___x_1314_; lean_object* v___x_1316_; 
v___x_1314_ = lean_array_fset(v_xs_x27_1311_, v_j_1303_, v___y_1313_);
lean_dec(v_j_1303_);
if (v_isShared_1308_ == 0)
{
lean_ctor_set(v___x_1307_, 0, v___x_1314_);
v___x_1316_ = v___x_1307_;
goto v_reusejp_1315_;
}
else
{
lean_object* v_reuseFailAlloc_1317_; 
v_reuseFailAlloc_1317_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1317_, 0, v___x_1314_);
v___x_1316_ = v_reuseFailAlloc_1317_;
goto v_reusejp_1315_;
}
v_reusejp_1315_:
{
return v___x_1316_;
}
}
}
}
}
else
{
lean_object* v_ks_1346_; lean_object* v_vs_1347_; lean_object* v___x_1349_; uint8_t v_isShared_1350_; uint8_t v_isSharedCheck_1367_; 
v_ks_1346_ = lean_ctor_get(v_x_1295_, 0);
v_vs_1347_ = lean_ctor_get(v_x_1295_, 1);
v_isSharedCheck_1367_ = !lean_is_exclusive(v_x_1295_);
if (v_isSharedCheck_1367_ == 0)
{
v___x_1349_ = v_x_1295_;
v_isShared_1350_ = v_isSharedCheck_1367_;
goto v_resetjp_1348_;
}
else
{
lean_inc(v_vs_1347_);
lean_inc(v_ks_1346_);
lean_dec(v_x_1295_);
v___x_1349_ = lean_box(0);
v_isShared_1350_ = v_isSharedCheck_1367_;
goto v_resetjp_1348_;
}
v_resetjp_1348_:
{
lean_object* v___x_1352_; 
if (v_isShared_1350_ == 0)
{
v___x_1352_ = v___x_1349_;
goto v_reusejp_1351_;
}
else
{
lean_object* v_reuseFailAlloc_1366_; 
v_reuseFailAlloc_1366_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1366_, 0, v_ks_1346_);
lean_ctor_set(v_reuseFailAlloc_1366_, 1, v_vs_1347_);
v___x_1352_ = v_reuseFailAlloc_1366_;
goto v_reusejp_1351_;
}
v_reusejp_1351_:
{
lean_object* v_newNode_1353_; uint8_t v___y_1355_; size_t v___x_1361_; uint8_t v___x_1362_; 
v_newNode_1353_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6___redArg(v___x_1352_, v_x_1298_, v_x_1299_);
v___x_1361_ = ((size_t)7ULL);
v___x_1362_ = lean_usize_dec_le(v___x_1361_, v_x_1297_);
if (v___x_1362_ == 0)
{
lean_object* v___x_1363_; lean_object* v___x_1364_; uint8_t v___x_1365_; 
v___x_1363_ = l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(v_newNode_1353_);
v___x_1364_ = lean_unsigned_to_nat(4u);
v___x_1365_ = lean_nat_dec_lt(v___x_1363_, v___x_1364_);
lean_dec(v___x_1363_);
v___y_1355_ = v___x_1365_;
goto v___jp_1354_;
}
else
{
v___y_1355_ = v___x_1362_;
goto v___jp_1354_;
}
v___jp_1354_:
{
if (v___y_1355_ == 0)
{
lean_object* v_ks_1356_; lean_object* v_vs_1357_; lean_object* v___x_1358_; lean_object* v___x_1359_; lean_object* v___x_1360_; 
v_ks_1356_ = lean_ctor_get(v_newNode_1353_, 0);
lean_inc_ref(v_ks_1356_);
v_vs_1357_ = lean_ctor_get(v_newNode_1353_, 1);
lean_inc_ref(v_vs_1357_);
lean_dec_ref(v_newNode_1353_);
v___x_1358_ = lean_unsigned_to_nat(0u);
v___x_1359_ = lean_obj_once(&l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg___closed__0, &l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg___closed__0_once, _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg___closed__0);
v___x_1360_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7___redArg(v_x_1297_, v_ks_1356_, v_vs_1357_, v___x_1358_, v___x_1359_);
lean_dec_ref(v_vs_1357_);
lean_dec_ref(v_ks_1356_);
return v___x_1360_;
}
else
{
return v_newNode_1353_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7___redArg(size_t v_depth_1368_, lean_object* v_keys_1369_, lean_object* v_vals_1370_, lean_object* v_i_1371_, lean_object* v_entries_1372_){
_start:
{
lean_object* v___x_1373_; uint8_t v___x_1374_; 
v___x_1373_ = lean_array_get_size(v_keys_1369_);
v___x_1374_ = lean_nat_dec_lt(v_i_1371_, v___x_1373_);
if (v___x_1374_ == 0)
{
lean_dec(v_i_1371_);
return v_entries_1372_;
}
else
{
lean_object* v_k_1375_; lean_object* v_v_1376_; uint64_t v___x_1377_; size_t v_h_1378_; size_t v___x_1379_; lean_object* v___x_1380_; size_t v___x_1381_; size_t v___x_1382_; size_t v___x_1383_; size_t v_h_1384_; lean_object* v___x_1385_; lean_object* v___x_1386_; 
v_k_1375_ = lean_array_fget_borrowed(v_keys_1369_, v_i_1371_);
v_v_1376_ = lean_array_fget_borrowed(v_vals_1370_, v_i_1371_);
v___x_1377_ = l_Lean_instHashableMVarId_hash(v_k_1375_);
v_h_1378_ = lean_uint64_to_usize(v___x_1377_);
v___x_1379_ = ((size_t)5ULL);
v___x_1380_ = lean_unsigned_to_nat(1u);
v___x_1381_ = ((size_t)1ULL);
v___x_1382_ = lean_usize_sub(v_depth_1368_, v___x_1381_);
v___x_1383_ = lean_usize_mul(v___x_1379_, v___x_1382_);
v_h_1384_ = lean_usize_shift_right(v_h_1378_, v___x_1383_);
v___x_1385_ = lean_nat_add(v_i_1371_, v___x_1380_);
lean_dec(v_i_1371_);
lean_inc(v_v_1376_);
lean_inc(v_k_1375_);
v___x_1386_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg(v_entries_1372_, v_h_1384_, v_depth_1368_, v_k_1375_, v_v_1376_);
v_i_1371_ = v___x_1385_;
v_entries_1372_ = v___x_1386_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7___redArg___boxed(lean_object* v_depth_1388_, lean_object* v_keys_1389_, lean_object* v_vals_1390_, lean_object* v_i_1391_, lean_object* v_entries_1392_){
_start:
{
size_t v_depth_boxed_1393_; lean_object* v_res_1394_; 
v_depth_boxed_1393_ = lean_unbox_usize(v_depth_1388_);
lean_dec(v_depth_1388_);
v_res_1394_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7___redArg(v_depth_boxed_1393_, v_keys_1389_, v_vals_1390_, v_i_1391_, v_entries_1392_);
lean_dec_ref(v_vals_1390_);
lean_dec_ref(v_keys_1389_);
return v_res_1394_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg___boxed(lean_object* v_x_1395_, lean_object* v_x_1396_, lean_object* v_x_1397_, lean_object* v_x_1398_, lean_object* v_x_1399_){
_start:
{
size_t v_x_28317__boxed_1400_; size_t v_x_28318__boxed_1401_; lean_object* v_res_1402_; 
v_x_28317__boxed_1400_ = lean_unbox_usize(v_x_1396_);
lean_dec(v_x_1396_);
v_x_28318__boxed_1401_ = lean_unbox_usize(v_x_1397_);
lean_dec(v_x_1397_);
v_res_1402_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg(v_x_1395_, v_x_28317__boxed_1400_, v_x_28318__boxed_1401_, v_x_1398_, v_x_1399_);
return v_res_1402_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2___redArg(lean_object* v_x_1403_, lean_object* v_x_1404_, lean_object* v_x_1405_){
_start:
{
uint64_t v___x_1406_; size_t v___x_1407_; size_t v___x_1408_; lean_object* v___x_1409_; 
v___x_1406_ = l_Lean_instHashableMVarId_hash(v_x_1404_);
v___x_1407_ = lean_uint64_to_usize(v___x_1406_);
v___x_1408_ = ((size_t)1ULL);
v___x_1409_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg(v_x_1403_, v___x_1407_, v___x_1408_, v_x_1404_, v_x_1405_);
return v___x_1409_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1___redArg(lean_object* v_mvarId_1410_, lean_object* v_val_1411_, lean_object* v___y_1412_){
_start:
{
lean_object* v___x_1414_; lean_object* v_mctx_1415_; lean_object* v_cache_1416_; lean_object* v_zetaDeltaFVarIds_1417_; lean_object* v_postponed_1418_; lean_object* v_diag_1419_; lean_object* v___x_1421_; uint8_t v_isShared_1422_; uint8_t v_isSharedCheck_1447_; 
v___x_1414_ = lean_st_ref_take(v___y_1412_);
v_mctx_1415_ = lean_ctor_get(v___x_1414_, 0);
v_cache_1416_ = lean_ctor_get(v___x_1414_, 1);
v_zetaDeltaFVarIds_1417_ = lean_ctor_get(v___x_1414_, 2);
v_postponed_1418_ = lean_ctor_get(v___x_1414_, 3);
v_diag_1419_ = lean_ctor_get(v___x_1414_, 4);
v_isSharedCheck_1447_ = !lean_is_exclusive(v___x_1414_);
if (v_isSharedCheck_1447_ == 0)
{
v___x_1421_ = v___x_1414_;
v_isShared_1422_ = v_isSharedCheck_1447_;
goto v_resetjp_1420_;
}
else
{
lean_inc(v_diag_1419_);
lean_inc(v_postponed_1418_);
lean_inc(v_zetaDeltaFVarIds_1417_);
lean_inc(v_cache_1416_);
lean_inc(v_mctx_1415_);
lean_dec(v___x_1414_);
v___x_1421_ = lean_box(0);
v_isShared_1422_ = v_isSharedCheck_1447_;
goto v_resetjp_1420_;
}
v_resetjp_1420_:
{
lean_object* v_depth_1423_; lean_object* v_levelAssignDepth_1424_; lean_object* v_lmvarCounter_1425_; lean_object* v_mvarCounter_1426_; lean_object* v_lDecls_1427_; lean_object* v_decls_1428_; lean_object* v_userNames_1429_; lean_object* v_lAssignment_1430_; lean_object* v_eAssignment_1431_; lean_object* v_dAssignment_1432_; lean_object* v___x_1434_; uint8_t v_isShared_1435_; uint8_t v_isSharedCheck_1446_; 
v_depth_1423_ = lean_ctor_get(v_mctx_1415_, 0);
v_levelAssignDepth_1424_ = lean_ctor_get(v_mctx_1415_, 1);
v_lmvarCounter_1425_ = lean_ctor_get(v_mctx_1415_, 2);
v_mvarCounter_1426_ = lean_ctor_get(v_mctx_1415_, 3);
v_lDecls_1427_ = lean_ctor_get(v_mctx_1415_, 4);
v_decls_1428_ = lean_ctor_get(v_mctx_1415_, 5);
v_userNames_1429_ = lean_ctor_get(v_mctx_1415_, 6);
v_lAssignment_1430_ = lean_ctor_get(v_mctx_1415_, 7);
v_eAssignment_1431_ = lean_ctor_get(v_mctx_1415_, 8);
v_dAssignment_1432_ = lean_ctor_get(v_mctx_1415_, 9);
v_isSharedCheck_1446_ = !lean_is_exclusive(v_mctx_1415_);
if (v_isSharedCheck_1446_ == 0)
{
v___x_1434_ = v_mctx_1415_;
v_isShared_1435_ = v_isSharedCheck_1446_;
goto v_resetjp_1433_;
}
else
{
lean_inc(v_dAssignment_1432_);
lean_inc(v_eAssignment_1431_);
lean_inc(v_lAssignment_1430_);
lean_inc(v_userNames_1429_);
lean_inc(v_decls_1428_);
lean_inc(v_lDecls_1427_);
lean_inc(v_mvarCounter_1426_);
lean_inc(v_lmvarCounter_1425_);
lean_inc(v_levelAssignDepth_1424_);
lean_inc(v_depth_1423_);
lean_dec(v_mctx_1415_);
v___x_1434_ = lean_box(0);
v_isShared_1435_ = v_isSharedCheck_1446_;
goto v_resetjp_1433_;
}
v_resetjp_1433_:
{
lean_object* v___x_1436_; lean_object* v___x_1438_; 
v___x_1436_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2___redArg(v_eAssignment_1431_, v_mvarId_1410_, v_val_1411_);
if (v_isShared_1435_ == 0)
{
lean_ctor_set(v___x_1434_, 8, v___x_1436_);
v___x_1438_ = v___x_1434_;
goto v_reusejp_1437_;
}
else
{
lean_object* v_reuseFailAlloc_1445_; 
v_reuseFailAlloc_1445_ = lean_alloc_ctor(0, 10, 0);
lean_ctor_set(v_reuseFailAlloc_1445_, 0, v_depth_1423_);
lean_ctor_set(v_reuseFailAlloc_1445_, 1, v_levelAssignDepth_1424_);
lean_ctor_set(v_reuseFailAlloc_1445_, 2, v_lmvarCounter_1425_);
lean_ctor_set(v_reuseFailAlloc_1445_, 3, v_mvarCounter_1426_);
lean_ctor_set(v_reuseFailAlloc_1445_, 4, v_lDecls_1427_);
lean_ctor_set(v_reuseFailAlloc_1445_, 5, v_decls_1428_);
lean_ctor_set(v_reuseFailAlloc_1445_, 6, v_userNames_1429_);
lean_ctor_set(v_reuseFailAlloc_1445_, 7, v_lAssignment_1430_);
lean_ctor_set(v_reuseFailAlloc_1445_, 8, v___x_1436_);
lean_ctor_set(v_reuseFailAlloc_1445_, 9, v_dAssignment_1432_);
v___x_1438_ = v_reuseFailAlloc_1445_;
goto v_reusejp_1437_;
}
v_reusejp_1437_:
{
lean_object* v___x_1440_; 
if (v_isShared_1422_ == 0)
{
lean_ctor_set(v___x_1421_, 0, v___x_1438_);
v___x_1440_ = v___x_1421_;
goto v_reusejp_1439_;
}
else
{
lean_object* v_reuseFailAlloc_1444_; 
v_reuseFailAlloc_1444_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_1444_, 0, v___x_1438_);
lean_ctor_set(v_reuseFailAlloc_1444_, 1, v_cache_1416_);
lean_ctor_set(v_reuseFailAlloc_1444_, 2, v_zetaDeltaFVarIds_1417_);
lean_ctor_set(v_reuseFailAlloc_1444_, 3, v_postponed_1418_);
lean_ctor_set(v_reuseFailAlloc_1444_, 4, v_diag_1419_);
v___x_1440_ = v_reuseFailAlloc_1444_;
goto v_reusejp_1439_;
}
v_reusejp_1439_:
{
lean_object* v___x_1441_; lean_object* v___x_1442_; lean_object* v___x_1443_; 
v___x_1441_ = lean_st_ref_set(v___y_1412_, v___x_1440_);
v___x_1442_ = lean_box(0);
v___x_1443_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1443_, 0, v___x_1442_);
return v___x_1443_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1___redArg___boxed(lean_object* v_mvarId_1448_, lean_object* v_val_1449_, lean_object* v___y_1450_, lean_object* v___y_1451_){
_start:
{
lean_object* v_res_1452_; 
v_res_1452_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1___redArg(v_mvarId_1448_, v_val_1449_, v___y_1450_);
lean_dec(v___y_1450_);
return v_res_1452_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0_spec__0(lean_object* v_msgData_1453_, lean_object* v___y_1454_, lean_object* v___y_1455_, lean_object* v___y_1456_, lean_object* v___y_1457_){
_start:
{
lean_object* v___x_1459_; lean_object* v_env_1460_; lean_object* v___x_1461_; lean_object* v_mctx_1462_; lean_object* v_lctx_1463_; lean_object* v_options_1464_; lean_object* v___x_1465_; lean_object* v___x_1466_; lean_object* v___x_1467_; 
v___x_1459_ = lean_st_ref_get(v___y_1457_);
v_env_1460_ = lean_ctor_get(v___x_1459_, 0);
lean_inc_ref(v_env_1460_);
lean_dec(v___x_1459_);
v___x_1461_ = lean_st_ref_get(v___y_1455_);
v_mctx_1462_ = lean_ctor_get(v___x_1461_, 0);
lean_inc_ref(v_mctx_1462_);
lean_dec(v___x_1461_);
v_lctx_1463_ = lean_ctor_get(v___y_1454_, 2);
v_options_1464_ = lean_ctor_get(v___y_1456_, 2);
lean_inc_ref(v_options_1464_);
lean_inc_ref(v_lctx_1463_);
v___x_1465_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_1465_, 0, v_env_1460_);
lean_ctor_set(v___x_1465_, 1, v_mctx_1462_);
lean_ctor_set(v___x_1465_, 2, v_lctx_1463_);
lean_ctor_set(v___x_1465_, 3, v_options_1464_);
v___x_1466_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v___x_1466_, 0, v___x_1465_);
lean_ctor_set(v___x_1466_, 1, v_msgData_1453_);
v___x_1467_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1467_, 0, v___x_1466_);
return v___x_1467_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0_spec__0___boxed(lean_object* v_msgData_1468_, lean_object* v___y_1469_, lean_object* v___y_1470_, lean_object* v___y_1471_, lean_object* v___y_1472_, lean_object* v___y_1473_){
_start:
{
lean_object* v_res_1474_; 
v_res_1474_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0_spec__0(v_msgData_1468_, v___y_1469_, v___y_1470_, v___y_1471_, v___y_1472_);
lean_dec(v___y_1472_);
lean_dec_ref(v___y_1471_);
lean_dec(v___y_1470_);
lean_dec_ref(v___y_1469_);
return v_res_1474_;
}
}
static double _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__0(void){
_start:
{
lean_object* v___x_1475_; double v___x_1476_; 
v___x_1475_ = lean_unsigned_to_nat(0u);
v___x_1476_ = lean_float_of_nat(v___x_1475_);
return v___x_1476_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg(lean_object* v_cls_1480_, lean_object* v_msg_1481_, lean_object* v___y_1482_, lean_object* v___y_1483_, lean_object* v___y_1484_, lean_object* v___y_1485_){
_start:
{
lean_object* v_ref_1487_; lean_object* v___x_1488_; lean_object* v_a_1489_; lean_object* v___x_1491_; uint8_t v_isShared_1492_; uint8_t v_isSharedCheck_1533_; 
v_ref_1487_ = lean_ctor_get(v___y_1484_, 5);
v___x_1488_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0_spec__0(v_msg_1481_, v___y_1482_, v___y_1483_, v___y_1484_, v___y_1485_);
v_a_1489_ = lean_ctor_get(v___x_1488_, 0);
v_isSharedCheck_1533_ = !lean_is_exclusive(v___x_1488_);
if (v_isSharedCheck_1533_ == 0)
{
v___x_1491_ = v___x_1488_;
v_isShared_1492_ = v_isSharedCheck_1533_;
goto v_resetjp_1490_;
}
else
{
lean_inc(v_a_1489_);
lean_dec(v___x_1488_);
v___x_1491_ = lean_box(0);
v_isShared_1492_ = v_isSharedCheck_1533_;
goto v_resetjp_1490_;
}
v_resetjp_1490_:
{
lean_object* v___x_1493_; lean_object* v_traceState_1494_; lean_object* v_env_1495_; lean_object* v_nextMacroScope_1496_; lean_object* v_ngen_1497_; lean_object* v_auxDeclNGen_1498_; lean_object* v_cache_1499_; lean_object* v_messages_1500_; lean_object* v_infoState_1501_; lean_object* v_snapshotTasks_1502_; lean_object* v___x_1504_; uint8_t v_isShared_1505_; uint8_t v_isSharedCheck_1532_; 
v___x_1493_ = lean_st_ref_take(v___y_1485_);
v_traceState_1494_ = lean_ctor_get(v___x_1493_, 4);
v_env_1495_ = lean_ctor_get(v___x_1493_, 0);
v_nextMacroScope_1496_ = lean_ctor_get(v___x_1493_, 1);
v_ngen_1497_ = lean_ctor_get(v___x_1493_, 2);
v_auxDeclNGen_1498_ = lean_ctor_get(v___x_1493_, 3);
v_cache_1499_ = lean_ctor_get(v___x_1493_, 5);
v_messages_1500_ = lean_ctor_get(v___x_1493_, 6);
v_infoState_1501_ = lean_ctor_get(v___x_1493_, 7);
v_snapshotTasks_1502_ = lean_ctor_get(v___x_1493_, 8);
v_isSharedCheck_1532_ = !lean_is_exclusive(v___x_1493_);
if (v_isSharedCheck_1532_ == 0)
{
v___x_1504_ = v___x_1493_;
v_isShared_1505_ = v_isSharedCheck_1532_;
goto v_resetjp_1503_;
}
else
{
lean_inc(v_snapshotTasks_1502_);
lean_inc(v_infoState_1501_);
lean_inc(v_messages_1500_);
lean_inc(v_cache_1499_);
lean_inc(v_traceState_1494_);
lean_inc(v_auxDeclNGen_1498_);
lean_inc(v_ngen_1497_);
lean_inc(v_nextMacroScope_1496_);
lean_inc(v_env_1495_);
lean_dec(v___x_1493_);
v___x_1504_ = lean_box(0);
v_isShared_1505_ = v_isSharedCheck_1532_;
goto v_resetjp_1503_;
}
v_resetjp_1503_:
{
uint64_t v_tid_1506_; lean_object* v_traces_1507_; lean_object* v___x_1509_; uint8_t v_isShared_1510_; uint8_t v_isSharedCheck_1531_; 
v_tid_1506_ = lean_ctor_get_uint64(v_traceState_1494_, sizeof(void*)*1);
v_traces_1507_ = lean_ctor_get(v_traceState_1494_, 0);
v_isSharedCheck_1531_ = !lean_is_exclusive(v_traceState_1494_);
if (v_isSharedCheck_1531_ == 0)
{
v___x_1509_ = v_traceState_1494_;
v_isShared_1510_ = v_isSharedCheck_1531_;
goto v_resetjp_1508_;
}
else
{
lean_inc(v_traces_1507_);
lean_dec(v_traceState_1494_);
v___x_1509_ = lean_box(0);
v_isShared_1510_ = v_isSharedCheck_1531_;
goto v_resetjp_1508_;
}
v_resetjp_1508_:
{
lean_object* v___x_1511_; double v___x_1512_; uint8_t v___x_1513_; lean_object* v___x_1514_; lean_object* v___x_1515_; lean_object* v___x_1516_; lean_object* v___x_1517_; lean_object* v___x_1518_; lean_object* v___x_1519_; lean_object* v___x_1521_; 
v___x_1511_ = lean_box(0);
v___x_1512_ = lean_float_once(&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__0, &l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__0_once, _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__0);
v___x_1513_ = 0;
v___x_1514_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__1));
v___x_1515_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v___x_1515_, 0, v_cls_1480_);
lean_ctor_set(v___x_1515_, 1, v___x_1511_);
lean_ctor_set(v___x_1515_, 2, v___x_1514_);
lean_ctor_set_float(v___x_1515_, sizeof(void*)*3, v___x_1512_);
lean_ctor_set_float(v___x_1515_, sizeof(void*)*3 + 8, v___x_1512_);
lean_ctor_set_uint8(v___x_1515_, sizeof(void*)*3 + 16, v___x_1513_);
v___x_1516_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___closed__2));
v___x_1517_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v___x_1517_, 0, v___x_1515_);
lean_ctor_set(v___x_1517_, 1, v_a_1489_);
lean_ctor_set(v___x_1517_, 2, v___x_1516_);
lean_inc(v_ref_1487_);
v___x_1518_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1518_, 0, v_ref_1487_);
lean_ctor_set(v___x_1518_, 1, v___x_1517_);
v___x_1519_ = l_Lean_PersistentArray_push___redArg(v_traces_1507_, v___x_1518_);
if (v_isShared_1510_ == 0)
{
lean_ctor_set(v___x_1509_, 0, v___x_1519_);
v___x_1521_ = v___x_1509_;
goto v_reusejp_1520_;
}
else
{
lean_object* v_reuseFailAlloc_1530_; 
v_reuseFailAlloc_1530_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_1530_, 0, v___x_1519_);
lean_ctor_set_uint64(v_reuseFailAlloc_1530_, sizeof(void*)*1, v_tid_1506_);
v___x_1521_ = v_reuseFailAlloc_1530_;
goto v_reusejp_1520_;
}
v_reusejp_1520_:
{
lean_object* v___x_1523_; 
if (v_isShared_1505_ == 0)
{
lean_ctor_set(v___x_1504_, 4, v___x_1521_);
v___x_1523_ = v___x_1504_;
goto v_reusejp_1522_;
}
else
{
lean_object* v_reuseFailAlloc_1529_; 
v_reuseFailAlloc_1529_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_1529_, 0, v_env_1495_);
lean_ctor_set(v_reuseFailAlloc_1529_, 1, v_nextMacroScope_1496_);
lean_ctor_set(v_reuseFailAlloc_1529_, 2, v_ngen_1497_);
lean_ctor_set(v_reuseFailAlloc_1529_, 3, v_auxDeclNGen_1498_);
lean_ctor_set(v_reuseFailAlloc_1529_, 4, v___x_1521_);
lean_ctor_set(v_reuseFailAlloc_1529_, 5, v_cache_1499_);
lean_ctor_set(v_reuseFailAlloc_1529_, 6, v_messages_1500_);
lean_ctor_set(v_reuseFailAlloc_1529_, 7, v_infoState_1501_);
lean_ctor_set(v_reuseFailAlloc_1529_, 8, v_snapshotTasks_1502_);
v___x_1523_ = v_reuseFailAlloc_1529_;
goto v_reusejp_1522_;
}
v_reusejp_1522_:
{
lean_object* v___x_1524_; lean_object* v___x_1525_; lean_object* v___x_1527_; 
v___x_1524_ = lean_st_ref_set(v___y_1485_, v___x_1523_);
v___x_1525_ = lean_box(0);
if (v_isShared_1492_ == 0)
{
lean_ctor_set(v___x_1491_, 0, v___x_1525_);
v___x_1527_ = v___x_1491_;
goto v_reusejp_1526_;
}
else
{
lean_object* v_reuseFailAlloc_1528_; 
v_reuseFailAlloc_1528_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1528_, 0, v___x_1525_);
v___x_1527_ = v_reuseFailAlloc_1528_;
goto v_reusejp_1526_;
}
v_reusejp_1526_:
{
return v___x_1527_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg___boxed(lean_object* v_cls_1534_, lean_object* v_msg_1535_, lean_object* v___y_1536_, lean_object* v___y_1537_, lean_object* v___y_1538_, lean_object* v___y_1539_, lean_object* v___y_1540_){
_start:
{
lean_object* v_res_1541_; 
v_res_1541_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg(v_cls_1534_, v_msg_1535_, v___y_1536_, v___y_1537_, v___y_1538_, v___y_1539_);
lean_dec(v___y_1539_);
lean_dec_ref(v___y_1538_);
lean_dec(v___y_1537_);
lean_dec_ref(v___y_1536_);
return v_res_1541_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__2(lean_object* v___f_1542_, lean_object* v_type_1543_, lean_object* v_____r_1544_, lean_object* v___y_1545_, lean_object* v___y_1546_, lean_object* v___y_1547_, lean_object* v___y_1548_, lean_object* v___y_1549_, lean_object* v___y_1550_, lean_object* v___y_1551_, lean_object* v___y_1552_){
_start:
{
lean_object* v___x_1554_; uint8_t v_debug_1555_; 
v___x_1554_ = lean_st_ref_get(v___y_1548_);
v_debug_1555_ = lean_ctor_get_uint8(v___x_1554_, sizeof(void*)*10);
lean_dec(v___x_1554_);
if (v_debug_1555_ == 0)
{
lean_object* v___x_1556_; lean_object* v___x_1557_; 
lean_dec_ref(v_type_1543_);
v___x_1556_ = lean_box(0);
lean_inc(v___y_1552_);
lean_inc_ref(v___y_1551_);
lean_inc(v___y_1550_);
lean_inc_ref(v___y_1549_);
lean_inc(v___y_1548_);
lean_inc_ref(v___y_1547_);
lean_inc(v___y_1546_);
lean_inc_ref(v___y_1545_);
v___x_1557_ = lean_apply_10(v___f_1542_, v___x_1556_, v___y_1545_, v___y_1546_, v___y_1547_, v___y_1548_, v___y_1549_, v___y_1550_, v___y_1551_, v___y_1552_, lean_box(0));
return v___x_1557_;
}
else
{
lean_object* v___x_1558_; 
v___x_1558_ = l_Lean_Meta_Sym_Internal_Sym_assertShared(v_type_1543_, v___y_1547_, v___y_1548_, v___y_1549_, v___y_1550_, v___y_1551_, v___y_1552_);
if (lean_obj_tag(v___x_1558_) == 0)
{
lean_object* v_a_1559_; lean_object* v___x_1560_; 
v_a_1559_ = lean_ctor_get(v___x_1558_, 0);
lean_inc(v_a_1559_);
lean_dec_ref_known(v___x_1558_, 1);
lean_inc(v___y_1552_);
lean_inc_ref(v___y_1551_);
lean_inc(v___y_1550_);
lean_inc_ref(v___y_1549_);
lean_inc(v___y_1548_);
lean_inc_ref(v___y_1547_);
lean_inc(v___y_1546_);
lean_inc_ref(v___y_1545_);
v___x_1560_ = lean_apply_10(v___f_1542_, v_a_1559_, v___y_1545_, v___y_1546_, v___y_1547_, v___y_1548_, v___y_1549_, v___y_1550_, v___y_1551_, v___y_1552_, lean_box(0));
return v___x_1560_;
}
else
{
lean_object* v_a_1561_; lean_object* v___x_1563_; uint8_t v_isShared_1564_; uint8_t v_isSharedCheck_1568_; 
lean_dec_ref(v___f_1542_);
v_a_1561_ = lean_ctor_get(v___x_1558_, 0);
v_isSharedCheck_1568_ = !lean_is_exclusive(v___x_1558_);
if (v_isSharedCheck_1568_ == 0)
{
v___x_1563_ = v___x_1558_;
v_isShared_1564_ = v_isSharedCheck_1568_;
goto v_resetjp_1562_;
}
else
{
lean_inc(v_a_1561_);
lean_dec(v___x_1558_);
v___x_1563_ = lean_box(0);
v_isShared_1564_ = v_isSharedCheck_1568_;
goto v_resetjp_1562_;
}
v_resetjp_1562_:
{
lean_object* v___x_1566_; 
if (v_isShared_1564_ == 0)
{
v___x_1566_ = v___x_1563_;
goto v_reusejp_1565_;
}
else
{
lean_object* v_reuseFailAlloc_1567_; 
v_reuseFailAlloc_1567_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1567_, 0, v_a_1561_);
v___x_1566_ = v_reuseFailAlloc_1567_;
goto v_reusejp_1565_;
}
v_reusejp_1565_:
{
return v___x_1566_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__2___boxed(lean_object* v___f_1569_, lean_object* v_type_1570_, lean_object* v_____r_1571_, lean_object* v___y_1572_, lean_object* v___y_1573_, lean_object* v___y_1574_, lean_object* v___y_1575_, lean_object* v___y_1576_, lean_object* v___y_1577_, lean_object* v___y_1578_, lean_object* v___y_1579_, lean_object* v___y_1580_){
_start:
{
lean_object* v_res_1581_; 
v_res_1581_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__2(v___f_1569_, v_type_1570_, v_____r_1571_, v___y_1572_, v___y_1573_, v___y_1574_, v___y_1575_, v___y_1576_, v___y_1577_, v___y_1578_, v___y_1579_);
lean_dec(v___y_1579_);
lean_dec_ref(v___y_1578_);
lean_dec(v___y_1577_);
lean_dec_ref(v___y_1576_);
lean_dec(v___y_1575_);
lean_dec_ref(v___y_1574_);
lean_dec(v___y_1573_);
lean_dec_ref(v___y_1572_);
return v_res_1581_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__1(uint8_t v___x_1582_, lean_object* v___f_1583_, lean_object* v_____r_1584_, lean_object* v___y_1585_, lean_object* v___y_1586_, lean_object* v___y_1587_, lean_object* v___y_1588_, lean_object* v___y_1589_, lean_object* v___y_1590_, lean_object* v___y_1591_, lean_object* v___y_1592_){
_start:
{
lean_object* v___x_1594_; lean_object* v_rewriteCache_1595_; lean_object* v_acNfCache_1596_; lean_object* v_typeAnalysis_1597_; lean_object* v_goal_1598_; lean_object* v_hypotheses_1599_; lean_object* v___x_1601_; uint8_t v_isShared_1602_; uint8_t v_isSharedCheck_1609_; 
v___x_1594_ = lean_st_ref_take(v___y_1586_);
v_rewriteCache_1595_ = lean_ctor_get(v___x_1594_, 0);
v_acNfCache_1596_ = lean_ctor_get(v___x_1594_, 1);
v_typeAnalysis_1597_ = lean_ctor_get(v___x_1594_, 2);
v_goal_1598_ = lean_ctor_get(v___x_1594_, 3);
v_hypotheses_1599_ = lean_ctor_get(v___x_1594_, 4);
v_isSharedCheck_1609_ = !lean_is_exclusive(v___x_1594_);
if (v_isSharedCheck_1609_ == 0)
{
v___x_1601_ = v___x_1594_;
v_isShared_1602_ = v_isSharedCheck_1609_;
goto v_resetjp_1600_;
}
else
{
lean_inc(v_hypotheses_1599_);
lean_inc(v_goal_1598_);
lean_inc(v_typeAnalysis_1597_);
lean_inc(v_acNfCache_1596_);
lean_inc(v_rewriteCache_1595_);
lean_dec(v___x_1594_);
v___x_1601_ = lean_box(0);
v_isShared_1602_ = v_isSharedCheck_1609_;
goto v_resetjp_1600_;
}
v_resetjp_1600_:
{
lean_object* v___x_1604_; 
if (v_isShared_1602_ == 0)
{
v___x_1604_ = v___x_1601_;
goto v_reusejp_1603_;
}
else
{
lean_object* v_reuseFailAlloc_1608_; 
v_reuseFailAlloc_1608_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_1608_, 0, v_rewriteCache_1595_);
lean_ctor_set(v_reuseFailAlloc_1608_, 1, v_acNfCache_1596_);
lean_ctor_set(v_reuseFailAlloc_1608_, 2, v_typeAnalysis_1597_);
lean_ctor_set(v_reuseFailAlloc_1608_, 3, v_goal_1598_);
lean_ctor_set(v_reuseFailAlloc_1608_, 4, v_hypotheses_1599_);
v___x_1604_ = v_reuseFailAlloc_1608_;
goto v_reusejp_1603_;
}
v_reusejp_1603_:
{
lean_object* v___x_1605_; lean_object* v___x_1606_; lean_object* v___x_1607_; 
lean_ctor_set_uint8(v___x_1604_, sizeof(void*)*5, v___x_1582_);
v___x_1605_ = lean_st_ref_set(v___y_1586_, v___x_1604_);
v___x_1606_ = lean_box(0);
lean_inc(v___y_1592_);
lean_inc_ref(v___y_1591_);
lean_inc(v___y_1590_);
lean_inc_ref(v___y_1589_);
lean_inc(v___y_1588_);
lean_inc_ref(v___y_1587_);
lean_inc(v___y_1586_);
lean_inc_ref(v___y_1585_);
v___x_1607_ = lean_apply_10(v___f_1583_, v___x_1606_, v___y_1585_, v___y_1586_, v___y_1587_, v___y_1588_, v___y_1589_, v___y_1590_, v___y_1591_, v___y_1592_, lean_box(0));
return v___x_1607_;
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__1___boxed(lean_object* v___x_1610_, lean_object* v___f_1611_, lean_object* v_____r_1612_, lean_object* v___y_1613_, lean_object* v___y_1614_, lean_object* v___y_1615_, lean_object* v___y_1616_, lean_object* v___y_1617_, lean_object* v___y_1618_, lean_object* v___y_1619_, lean_object* v___y_1620_, lean_object* v___y_1621_){
_start:
{
uint8_t v___x_28717__boxed_1622_; lean_object* v_res_1623_; 
v___x_28717__boxed_1622_ = lean_unbox(v___x_1610_);
v_res_1623_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__1(v___x_28717__boxed_1622_, v___f_1611_, v_____r_1612_, v___y_1613_, v___y_1614_, v___y_1615_, v___y_1616_, v___y_1617_, v___y_1618_, v___y_1619_, v___y_1620_);
lean_dec(v___y_1620_);
lean_dec_ref(v___y_1619_);
lean_dec(v___y_1618_);
lean_dec_ref(v___y_1617_);
lean_dec(v___y_1616_);
lean_dec_ref(v___y_1615_);
lean_dec(v___y_1614_);
lean_dec_ref(v___y_1613_);
return v_res_1623_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__0(lean_object* v_snd_1624_, lean_object* v_a_1625_, lean_object* v___x_1626_, lean_object* v_____r_1627_, lean_object* v___y_1628_, lean_object* v___y_1629_, lean_object* v___y_1630_, lean_object* v___y_1631_, lean_object* v___y_1632_, lean_object* v___y_1633_, lean_object* v___y_1634_, lean_object* v___y_1635_){
_start:
{
lean_object* v___x_1637_; lean_object* v___x_1638_; lean_object* v___x_1639_; lean_object* v___x_1640_; 
v___x_1637_ = lean_array_push(v_snd_1624_, v_a_1625_);
v___x_1638_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1638_, 0, v___x_1626_);
lean_ctor_set(v___x_1638_, 1, v___x_1637_);
v___x_1639_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_1639_, 0, v___x_1638_);
v___x_1640_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1640_, 0, v___x_1639_);
return v___x_1640_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__0___boxed(lean_object* v_snd_1641_, lean_object* v_a_1642_, lean_object* v___x_1643_, lean_object* v_____r_1644_, lean_object* v___y_1645_, lean_object* v___y_1646_, lean_object* v___y_1647_, lean_object* v___y_1648_, lean_object* v___y_1649_, lean_object* v___y_1650_, lean_object* v___y_1651_, lean_object* v___y_1652_, lean_object* v___y_1653_){
_start:
{
lean_object* v_res_1654_; 
v_res_1654_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__0(v_snd_1641_, v_a_1642_, v___x_1643_, v_____r_1644_, v___y_1645_, v___y_1646_, v___y_1647_, v___y_1648_, v___y_1649_, v___y_1650_, v___y_1651_, v___y_1652_);
lean_dec(v___y_1652_);
lean_dec_ref(v___y_1651_);
lean_dec(v___y_1650_);
lean_dec_ref(v___y_1649_);
lean_dec(v___y_1648_);
lean_dec_ref(v___y_1647_);
lean_dec(v___y_1646_);
lean_dec_ref(v___y_1645_);
return v_res_1654_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__6(void){
_start:
{
lean_object* v___x_1665_; lean_object* v___x_1666_; lean_object* v___x_1667_; 
v___x_1665_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__3));
v___x_1666_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__5));
v___x_1667_ = l_Lean_Name_append(v___x_1666_, v___x_1665_);
return v___x_1667_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__8(void){
_start:
{
lean_object* v___x_1669_; lean_object* v___x_1670_; 
v___x_1669_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__7));
v___x_1670_ = l_Lean_stringToMessageData(v___x_1669_);
return v___x_1670_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg(lean_object* v_upperBound_1671_, lean_object* v___x_1672_, lean_object* v_a_1673_, lean_object* v___x_1674_, lean_object* v_a_1675_, lean_object* v_b_1676_, lean_object* v___y_1677_, lean_object* v___y_1678_, lean_object* v___y_1679_, lean_object* v___y_1680_, lean_object* v___y_1681_, lean_object* v___y_1682_, lean_object* v___y_1683_, lean_object* v___y_1684_){
_start:
{
lean_object* v___y_1687_; uint8_t v___x_1709_; 
v___x_1709_ = lean_nat_dec_lt(v_a_1675_, v_upperBound_1671_);
if (v___x_1709_ == 0)
{
lean_object* v___x_1710_; 
lean_dec(v_a_1675_);
lean_dec_ref(v___x_1674_);
lean_dec_ref(v_a_1673_);
v___x_1710_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1710_, 0, v_b_1676_);
return v___x_1710_;
}
else
{
lean_object* v___x_1711_; lean_object* v_type_1712_; lean_object* v___x_1713_; lean_object* v___x_1714_; 
v___x_1711_ = lean_array_fget_borrowed(v___x_1672_, v_a_1675_);
v_type_1712_ = lean_ctor_get(v___x_1711_, 1);
lean_inc_ref(v_type_1712_);
v___x_1713_ = lean_alloc_closure((void*)(l_Lean_Meta_Sym_Simp_simp___boxed), 11, 1);
lean_closure_set(v___x_1713_, 0, v_type_1712_);
lean_inc_ref(v___x_1674_);
lean_inc_ref(v_a_1673_);
v___x_1714_ = l_Lean_Meta_Sym_Simp_SimpM_run_x27___redArg(v___x_1713_, v_a_1673_, v___x_1674_, v___y_1679_, v___y_1680_, v___y_1681_, v___y_1682_, v___y_1683_, v___y_1684_);
if (lean_obj_tag(v___x_1714_) == 0)
{
lean_object* v_a_1715_; lean_object* v___x_1716_; 
v_a_1715_ = lean_ctor_get(v___x_1714_, 0);
lean_inc(v_a_1715_);
lean_dec_ref_known(v___x_1714_, 1);
lean_inc(v___x_1711_);
v___x_1716_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(v___x_1711_, v_a_1715_, v___y_1680_, v___y_1681_, v___y_1682_, v___y_1683_, v___y_1684_);
if (lean_obj_tag(v___x_1716_) == 0)
{
lean_object* v_a_1717_; lean_object* v_snd_1718_; lean_object* v___x_1720_; uint8_t v_isShared_1721_; uint8_t v_isSharedCheck_1782_; 
v_a_1717_ = lean_ctor_get(v___x_1716_, 0);
lean_inc(v_a_1717_);
lean_dec_ref_known(v___x_1716_, 1);
v_snd_1718_ = lean_ctor_get(v_b_1676_, 1);
v_isSharedCheck_1782_ = !lean_is_exclusive(v_b_1676_);
if (v_isSharedCheck_1782_ == 0)
{
lean_object* v_unused_1783_; 
v_unused_1783_ = lean_ctor_get(v_b_1676_, 0);
lean_dec(v_unused_1783_);
v___x_1720_ = v_b_1676_;
v_isShared_1721_ = v_isSharedCheck_1782_;
goto v_resetjp_1719_;
}
else
{
lean_inc(v_snd_1718_);
lean_dec(v_b_1676_);
v___x_1720_ = lean_box(0);
v_isShared_1721_ = v_isSharedCheck_1782_;
goto v_resetjp_1719_;
}
v_resetjp_1719_:
{
lean_object* v_type_1722_; lean_object* v_value_1723_; uint8_t v___x_1724_; 
v_type_1722_ = lean_ctor_get(v_a_1717_, 1);
v_value_1723_ = lean_ctor_get(v_a_1717_, 2);
lean_inc_ref(v_type_1722_);
v___x_1724_ = l_Lean_Expr_isFalse(v_type_1722_);
if (v___x_1724_ == 0)
{
lean_object* v___x_1725_; lean_object* v___f_1726_; lean_object* v___x_1727_; lean_object* v___f_1728_; uint8_t v___x_1755_; 
lean_del_object(v___x_1720_);
v___x_1725_ = lean_box(0);
lean_inc(v_a_1717_);
lean_inc(v_snd_1718_);
v___f_1726_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__0___boxed), 13, 3);
lean_closure_set(v___f_1726_, 0, v_snd_1718_);
lean_closure_set(v___f_1726_, 1, v_a_1717_);
lean_closure_set(v___f_1726_, 2, v___x_1725_);
v___x_1727_ = lean_box(v___x_1709_);
v___f_1728_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__1___boxed), 12, 2);
lean_closure_set(v___f_1728_, 0, v___x_1727_);
lean_closure_set(v___f_1728_, 1, v___f_1726_);
v___x_1755_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(v___x_1711_, v_a_1717_);
if (v___x_1755_ == 0)
{
lean_inc_ref(v_type_1722_);
lean_dec(v_snd_1718_);
lean_dec(v_a_1717_);
goto v___jp_1732_;
}
else
{
if (v___x_1724_ == 0)
{
lean_object* v___x_1756_; lean_object* v___x_1757_; 
lean_dec_ref(v___f_1728_);
v___x_1756_ = lean_box(0);
v___x_1757_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__0(v_snd_1718_, v_a_1717_, v___x_1725_, v___x_1756_, v___y_1677_, v___y_1678_, v___y_1679_, v___y_1680_, v___y_1681_, v___y_1682_, v___y_1683_, v___y_1684_);
v___y_1687_ = v___x_1757_;
goto v___jp_1686_;
}
else
{
lean_inc_ref(v_type_1722_);
lean_dec(v_snd_1718_);
lean_dec(v_a_1717_);
goto v___jp_1732_;
}
}
v___jp_1729_:
{
lean_object* v___x_1730_; lean_object* v___x_1731_; 
v___x_1730_ = lean_box(0);
v___x_1731_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__2(v___f_1728_, v_type_1722_, v___x_1730_, v___y_1677_, v___y_1678_, v___y_1679_, v___y_1680_, v___y_1681_, v___y_1682_, v___y_1683_, v___y_1684_);
v___y_1687_ = v___x_1731_;
goto v___jp_1686_;
}
v___jp_1732_:
{
lean_object* v_options_1733_; uint8_t v_hasTrace_1734_; 
v_options_1733_ = lean_ctor_get(v___y_1683_, 2);
v_hasTrace_1734_ = lean_ctor_get_uint8(v_options_1733_, sizeof(void*)*1);
if (v_hasTrace_1734_ == 0)
{
goto v___jp_1729_;
}
else
{
lean_object* v_inheritedTraceOptions_1735_; lean_object* v___x_1736_; lean_object* v___x_1737_; uint8_t v___x_1738_; 
v_inheritedTraceOptions_1735_ = lean_ctor_get(v___y_1683_, 13);
v___x_1736_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__3));
v___x_1737_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__6, &l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__6_once, _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__6);
v___x_1738_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_1735_, v_options_1733_, v___x_1737_);
if (v___x_1738_ == 0)
{
goto v___jp_1729_;
}
else
{
lean_object* v___x_1739_; lean_object* v___x_1740_; lean_object* v___x_1741_; lean_object* v___x_1742_; lean_object* v___x_1743_; lean_object* v___x_1744_; 
lean_inc_ref(v_type_1712_);
v___x_1739_ = l_Lean_MessageData_ofExpr(v_type_1712_);
v___x_1740_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__8, &l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__8_once, _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___closed__8);
v___x_1741_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1741_, 0, v___x_1739_);
lean_ctor_set(v___x_1741_, 1, v___x_1740_);
lean_inc_ref(v_type_1722_);
v___x_1742_ = l_Lean_MessageData_ofExpr(v_type_1722_);
v___x_1743_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1743_, 0, v___x_1741_);
lean_ctor_set(v___x_1743_, 1, v___x_1742_);
v___x_1744_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg(v___x_1736_, v___x_1743_, v___y_1681_, v___y_1682_, v___y_1683_, v___y_1684_);
if (lean_obj_tag(v___x_1744_) == 0)
{
lean_object* v_a_1745_; lean_object* v___x_1746_; 
v_a_1745_ = lean_ctor_get(v___x_1744_, 0);
lean_inc(v_a_1745_);
lean_dec_ref_known(v___x_1744_, 1);
v___x_1746_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___lam__2(v___f_1728_, v_type_1722_, v_a_1745_, v___y_1677_, v___y_1678_, v___y_1679_, v___y_1680_, v___y_1681_, v___y_1682_, v___y_1683_, v___y_1684_);
v___y_1687_ = v___x_1746_;
goto v___jp_1686_;
}
else
{
lean_object* v_a_1747_; lean_object* v___x_1749_; uint8_t v_isShared_1750_; uint8_t v_isSharedCheck_1754_; 
lean_dec_ref(v___f_1728_);
lean_dec_ref(v_type_1722_);
lean_dec(v_a_1675_);
lean_dec_ref(v___x_1674_);
lean_dec_ref(v_a_1673_);
v_a_1747_ = lean_ctor_get(v___x_1744_, 0);
v_isSharedCheck_1754_ = !lean_is_exclusive(v___x_1744_);
if (v_isSharedCheck_1754_ == 0)
{
v___x_1749_ = v___x_1744_;
v_isShared_1750_ = v_isSharedCheck_1754_;
goto v_resetjp_1748_;
}
else
{
lean_inc(v_a_1747_);
lean_dec(v___x_1744_);
v___x_1749_ = lean_box(0);
v_isShared_1750_ = v_isSharedCheck_1754_;
goto v_resetjp_1748_;
}
v_resetjp_1748_:
{
lean_object* v___x_1752_; 
if (v_isShared_1750_ == 0)
{
v___x_1752_ = v___x_1749_;
goto v_reusejp_1751_;
}
else
{
lean_object* v_reuseFailAlloc_1753_; 
v_reuseFailAlloc_1753_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1753_, 0, v_a_1747_);
v___x_1752_ = v_reuseFailAlloc_1753_;
goto v_reusejp_1751_;
}
v_reusejp_1751_:
{
return v___x_1752_;
}
}
}
}
}
}
}
else
{
lean_object* v___x_1758_; lean_object* v_goal_1759_; lean_object* v___x_1760_; 
lean_inc_ref(v_value_1723_);
lean_dec(v_a_1717_);
lean_dec(v_a_1675_);
lean_dec_ref(v___x_1674_);
lean_dec_ref(v_a_1673_);
v___x_1758_ = lean_st_ref_get(v___y_1678_);
v_goal_1759_ = lean_ctor_get(v___x_1758_, 3);
lean_inc(v_goal_1759_);
lean_dec(v___x_1758_);
v___x_1760_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1___redArg(v_goal_1759_, v_value_1723_, v___y_1682_);
if (lean_obj_tag(v___x_1760_) == 0)
{
lean_object* v___x_1762_; uint8_t v_isShared_1763_; uint8_t v_isSharedCheck_1772_; 
v_isSharedCheck_1772_ = !lean_is_exclusive(v___x_1760_);
if (v_isSharedCheck_1772_ == 0)
{
lean_object* v_unused_1773_; 
v_unused_1773_ = lean_ctor_get(v___x_1760_, 0);
lean_dec(v_unused_1773_);
v___x_1762_ = v___x_1760_;
v_isShared_1763_ = v_isSharedCheck_1772_;
goto v_resetjp_1761_;
}
else
{
lean_dec(v___x_1760_);
v___x_1762_ = lean_box(0);
v_isShared_1763_ = v_isSharedCheck_1772_;
goto v_resetjp_1761_;
}
v_resetjp_1761_:
{
lean_object* v___x_1764_; lean_object* v___x_1765_; lean_object* v___x_1767_; 
v___x_1764_ = lean_box(v___x_1724_);
v___x_1765_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_1765_, 0, v___x_1764_);
if (v_isShared_1721_ == 0)
{
lean_ctor_set(v___x_1720_, 0, v___x_1765_);
v___x_1767_ = v___x_1720_;
goto v_reusejp_1766_;
}
else
{
lean_object* v_reuseFailAlloc_1771_; 
v_reuseFailAlloc_1771_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1771_, 0, v___x_1765_);
lean_ctor_set(v_reuseFailAlloc_1771_, 1, v_snd_1718_);
v___x_1767_ = v_reuseFailAlloc_1771_;
goto v_reusejp_1766_;
}
v_reusejp_1766_:
{
lean_object* v___x_1769_; 
if (v_isShared_1763_ == 0)
{
lean_ctor_set(v___x_1762_, 0, v___x_1767_);
v___x_1769_ = v___x_1762_;
goto v_reusejp_1768_;
}
else
{
lean_object* v_reuseFailAlloc_1770_; 
v_reuseFailAlloc_1770_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1770_, 0, v___x_1767_);
v___x_1769_ = v_reuseFailAlloc_1770_;
goto v_reusejp_1768_;
}
v_reusejp_1768_:
{
return v___x_1769_;
}
}
}
}
else
{
lean_object* v_a_1774_; lean_object* v___x_1776_; uint8_t v_isShared_1777_; uint8_t v_isSharedCheck_1781_; 
lean_del_object(v___x_1720_);
lean_dec(v_snd_1718_);
v_a_1774_ = lean_ctor_get(v___x_1760_, 0);
v_isSharedCheck_1781_ = !lean_is_exclusive(v___x_1760_);
if (v_isSharedCheck_1781_ == 0)
{
v___x_1776_ = v___x_1760_;
v_isShared_1777_ = v_isSharedCheck_1781_;
goto v_resetjp_1775_;
}
else
{
lean_inc(v_a_1774_);
lean_dec(v___x_1760_);
v___x_1776_ = lean_box(0);
v_isShared_1777_ = v_isSharedCheck_1781_;
goto v_resetjp_1775_;
}
v_resetjp_1775_:
{
lean_object* v___x_1779_; 
if (v_isShared_1777_ == 0)
{
v___x_1779_ = v___x_1776_;
goto v_reusejp_1778_;
}
else
{
lean_object* v_reuseFailAlloc_1780_; 
v_reuseFailAlloc_1780_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1780_, 0, v_a_1774_);
v___x_1779_ = v_reuseFailAlloc_1780_;
goto v_reusejp_1778_;
}
v_reusejp_1778_:
{
return v___x_1779_;
}
}
}
}
}
}
else
{
lean_object* v_a_1784_; lean_object* v___x_1786_; uint8_t v_isShared_1787_; uint8_t v_isSharedCheck_1791_; 
lean_dec_ref(v_b_1676_);
lean_dec(v_a_1675_);
lean_dec_ref(v___x_1674_);
lean_dec_ref(v_a_1673_);
v_a_1784_ = lean_ctor_get(v___x_1716_, 0);
v_isSharedCheck_1791_ = !lean_is_exclusive(v___x_1716_);
if (v_isSharedCheck_1791_ == 0)
{
v___x_1786_ = v___x_1716_;
v_isShared_1787_ = v_isSharedCheck_1791_;
goto v_resetjp_1785_;
}
else
{
lean_inc(v_a_1784_);
lean_dec(v___x_1716_);
v___x_1786_ = lean_box(0);
v_isShared_1787_ = v_isSharedCheck_1791_;
goto v_resetjp_1785_;
}
v_resetjp_1785_:
{
lean_object* v___x_1789_; 
if (v_isShared_1787_ == 0)
{
v___x_1789_ = v___x_1786_;
goto v_reusejp_1788_;
}
else
{
lean_object* v_reuseFailAlloc_1790_; 
v_reuseFailAlloc_1790_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1790_, 0, v_a_1784_);
v___x_1789_ = v_reuseFailAlloc_1790_;
goto v_reusejp_1788_;
}
v_reusejp_1788_:
{
return v___x_1789_;
}
}
}
}
else
{
lean_object* v_a_1792_; lean_object* v___x_1794_; uint8_t v_isShared_1795_; uint8_t v_isSharedCheck_1799_; 
lean_dec_ref(v_b_1676_);
lean_dec(v_a_1675_);
lean_dec_ref(v___x_1674_);
lean_dec_ref(v_a_1673_);
v_a_1792_ = lean_ctor_get(v___x_1714_, 0);
v_isSharedCheck_1799_ = !lean_is_exclusive(v___x_1714_);
if (v_isSharedCheck_1799_ == 0)
{
v___x_1794_ = v___x_1714_;
v_isShared_1795_ = v_isSharedCheck_1799_;
goto v_resetjp_1793_;
}
else
{
lean_inc(v_a_1792_);
lean_dec(v___x_1714_);
v___x_1794_ = lean_box(0);
v_isShared_1795_ = v_isSharedCheck_1799_;
goto v_resetjp_1793_;
}
v_resetjp_1793_:
{
lean_object* v___x_1797_; 
if (v_isShared_1795_ == 0)
{
v___x_1797_ = v___x_1794_;
goto v_reusejp_1796_;
}
else
{
lean_object* v_reuseFailAlloc_1798_; 
v_reuseFailAlloc_1798_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1798_, 0, v_a_1792_);
v___x_1797_ = v_reuseFailAlloc_1798_;
goto v_reusejp_1796_;
}
v_reusejp_1796_:
{
return v___x_1797_;
}
}
}
}
v___jp_1686_:
{
if (lean_obj_tag(v___y_1687_) == 0)
{
lean_object* v_a_1688_; lean_object* v___x_1690_; uint8_t v_isShared_1691_; uint8_t v_isSharedCheck_1700_; 
v_a_1688_ = lean_ctor_get(v___y_1687_, 0);
v_isSharedCheck_1700_ = !lean_is_exclusive(v___y_1687_);
if (v_isSharedCheck_1700_ == 0)
{
v___x_1690_ = v___y_1687_;
v_isShared_1691_ = v_isSharedCheck_1700_;
goto v_resetjp_1689_;
}
else
{
lean_inc(v_a_1688_);
lean_dec(v___y_1687_);
v___x_1690_ = lean_box(0);
v_isShared_1691_ = v_isSharedCheck_1700_;
goto v_resetjp_1689_;
}
v_resetjp_1689_:
{
if (lean_obj_tag(v_a_1688_) == 0)
{
lean_object* v_a_1692_; lean_object* v___x_1694_; 
lean_dec(v_a_1675_);
lean_dec_ref(v___x_1674_);
lean_dec_ref(v_a_1673_);
v_a_1692_ = lean_ctor_get(v_a_1688_, 0);
lean_inc(v_a_1692_);
lean_dec_ref_known(v_a_1688_, 1);
if (v_isShared_1691_ == 0)
{
lean_ctor_set(v___x_1690_, 0, v_a_1692_);
v___x_1694_ = v___x_1690_;
goto v_reusejp_1693_;
}
else
{
lean_object* v_reuseFailAlloc_1695_; 
v_reuseFailAlloc_1695_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1695_, 0, v_a_1692_);
v___x_1694_ = v_reuseFailAlloc_1695_;
goto v_reusejp_1693_;
}
v_reusejp_1693_:
{
return v___x_1694_;
}
}
else
{
lean_object* v_a_1696_; lean_object* v___x_1697_; lean_object* v___x_1698_; 
lean_del_object(v___x_1690_);
v_a_1696_ = lean_ctor_get(v_a_1688_, 0);
lean_inc(v_a_1696_);
lean_dec_ref_known(v_a_1688_, 1);
v___x_1697_ = lean_unsigned_to_nat(1u);
v___x_1698_ = lean_nat_add(v_a_1675_, v___x_1697_);
lean_dec(v_a_1675_);
v_a_1675_ = v___x_1698_;
v_b_1676_ = v_a_1696_;
goto _start;
}
}
}
else
{
lean_object* v_a_1701_; lean_object* v___x_1703_; uint8_t v_isShared_1704_; uint8_t v_isSharedCheck_1708_; 
lean_dec(v_a_1675_);
lean_dec_ref(v___x_1674_);
lean_dec_ref(v_a_1673_);
v_a_1701_ = lean_ctor_get(v___y_1687_, 0);
v_isSharedCheck_1708_ = !lean_is_exclusive(v___y_1687_);
if (v_isSharedCheck_1708_ == 0)
{
v___x_1703_ = v___y_1687_;
v_isShared_1704_ = v_isSharedCheck_1708_;
goto v_resetjp_1702_;
}
else
{
lean_inc(v_a_1701_);
lean_dec(v___y_1687_);
v___x_1703_ = lean_box(0);
v_isShared_1704_ = v_isSharedCheck_1708_;
goto v_resetjp_1702_;
}
v_resetjp_1702_:
{
lean_object* v___x_1706_; 
if (v_isShared_1704_ == 0)
{
v___x_1706_ = v___x_1703_;
goto v_reusejp_1705_;
}
else
{
lean_object* v_reuseFailAlloc_1707_; 
v_reuseFailAlloc_1707_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1707_, 0, v_a_1701_);
v___x_1706_ = v_reuseFailAlloc_1707_;
goto v_reusejp_1705_;
}
v_reusejp_1705_:
{
return v___x_1706_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg___boxed(lean_object* v_upperBound_1800_, lean_object* v___x_1801_, lean_object* v_a_1802_, lean_object* v___x_1803_, lean_object* v_a_1804_, lean_object* v_b_1805_, lean_object* v___y_1806_, lean_object* v___y_1807_, lean_object* v___y_1808_, lean_object* v___y_1809_, lean_object* v___y_1810_, lean_object* v___y_1811_, lean_object* v___y_1812_, lean_object* v___y_1813_, lean_object* v___y_1814_){
_start:
{
lean_object* v_res_1815_; 
v_res_1815_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg(v_upperBound_1800_, v___x_1801_, v_a_1802_, v___x_1803_, v_a_1804_, v_b_1805_, v___y_1806_, v___y_1807_, v___y_1808_, v___y_1809_, v___y_1810_, v___y_1811_, v___y_1812_, v___y_1813_);
lean_dec(v___y_1813_);
lean_dec_ref(v___y_1812_);
lean_dec(v___y_1811_);
lean_dec_ref(v___y_1810_);
lean_dec(v___y_1809_);
lean_dec_ref(v___y_1808_);
lean_dec(v___y_1807_);
lean_dec_ref(v___y_1806_);
lean_dec_ref(v___x_1801_);
lean_dec(v_upperBound_1800_);
return v_res_1815_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__1(lean_object* v_a_1816_, lean_object* v___x_1817_, lean_object* v___y_1818_, lean_object* v___y_1819_, lean_object* v___y_1820_, lean_object* v___y_1821_, lean_object* v___y_1822_, lean_object* v___y_1823_, lean_object* v___y_1824_, lean_object* v___y_1825_){
_start:
{
lean_object* v___x_1827_; lean_object* v_hypotheses_1828_; lean_object* v___x_1829_; lean_object* v_newHyps_1830_; lean_object* v___x_1831_; lean_object* v___x_1832_; lean_object* v___x_1833_; lean_object* v___x_1834_; 
v___x_1827_ = lean_st_ref_get(v___y_1819_);
v_hypotheses_1828_ = lean_ctor_get(v___x_1827_, 4);
lean_inc_ref(v_hypotheses_1828_);
lean_dec(v___x_1827_);
v___x_1829_ = lean_array_get_size(v_hypotheses_1828_);
v_newHyps_1830_ = lean_mk_empty_array_with_capacity(v___x_1829_);
v___x_1831_ = lean_unsigned_to_nat(0u);
v___x_1832_ = lean_box(0);
v___x_1833_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1833_, 0, v___x_1832_);
lean_ctor_set(v___x_1833_, 1, v_newHyps_1830_);
v___x_1834_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg(v___x_1829_, v_hypotheses_1828_, v_a_1816_, v___x_1817_, v___x_1831_, v___x_1833_, v___y_1818_, v___y_1819_, v___y_1820_, v___y_1821_, v___y_1822_, v___y_1823_, v___y_1824_, v___y_1825_);
lean_dec_ref(v_hypotheses_1828_);
if (lean_obj_tag(v___x_1834_) == 0)
{
lean_object* v_a_1835_; lean_object* v___x_1837_; uint8_t v_isShared_1838_; uint8_t v_isSharedCheck_1865_; 
v_a_1835_ = lean_ctor_get(v___x_1834_, 0);
v_isSharedCheck_1865_ = !lean_is_exclusive(v___x_1834_);
if (v_isSharedCheck_1865_ == 0)
{
v___x_1837_ = v___x_1834_;
v_isShared_1838_ = v_isSharedCheck_1865_;
goto v_resetjp_1836_;
}
else
{
lean_inc(v_a_1835_);
lean_dec(v___x_1834_);
v___x_1837_ = lean_box(0);
v_isShared_1838_ = v_isSharedCheck_1865_;
goto v_resetjp_1836_;
}
v_resetjp_1836_:
{
lean_object* v_fst_1839_; 
v_fst_1839_ = lean_ctor_get(v_a_1835_, 0);
if (lean_obj_tag(v_fst_1839_) == 0)
{
lean_object* v_snd_1840_; lean_object* v___x_1841_; lean_object* v_rewriteCache_1842_; lean_object* v_acNfCache_1843_; lean_object* v_typeAnalysis_1844_; lean_object* v_goal_1845_; uint8_t v_didChange_1846_; lean_object* v___x_1848_; uint8_t v_isShared_1849_; uint8_t v_isSharedCheck_1859_; 
v_snd_1840_ = lean_ctor_get(v_a_1835_, 1);
lean_inc(v_snd_1840_);
lean_dec(v_a_1835_);
v___x_1841_ = lean_st_ref_take(v___y_1819_);
v_rewriteCache_1842_ = lean_ctor_get(v___x_1841_, 0);
v_acNfCache_1843_ = lean_ctor_get(v___x_1841_, 1);
v_typeAnalysis_1844_ = lean_ctor_get(v___x_1841_, 2);
v_goal_1845_ = lean_ctor_get(v___x_1841_, 3);
v_didChange_1846_ = lean_ctor_get_uint8(v___x_1841_, sizeof(void*)*5);
v_isSharedCheck_1859_ = !lean_is_exclusive(v___x_1841_);
if (v_isSharedCheck_1859_ == 0)
{
lean_object* v_unused_1860_; 
v_unused_1860_ = lean_ctor_get(v___x_1841_, 4);
lean_dec(v_unused_1860_);
v___x_1848_ = v___x_1841_;
v_isShared_1849_ = v_isSharedCheck_1859_;
goto v_resetjp_1847_;
}
else
{
lean_inc(v_goal_1845_);
lean_inc(v_typeAnalysis_1844_);
lean_inc(v_acNfCache_1843_);
lean_inc(v_rewriteCache_1842_);
lean_dec(v___x_1841_);
v___x_1848_ = lean_box(0);
v_isShared_1849_ = v_isSharedCheck_1859_;
goto v_resetjp_1847_;
}
v_resetjp_1847_:
{
lean_object* v___x_1851_; 
if (v_isShared_1849_ == 0)
{
lean_ctor_set(v___x_1848_, 4, v_snd_1840_);
v___x_1851_ = v___x_1848_;
goto v_reusejp_1850_;
}
else
{
lean_object* v_reuseFailAlloc_1858_; 
v_reuseFailAlloc_1858_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_1858_, 0, v_rewriteCache_1842_);
lean_ctor_set(v_reuseFailAlloc_1858_, 1, v_acNfCache_1843_);
lean_ctor_set(v_reuseFailAlloc_1858_, 2, v_typeAnalysis_1844_);
lean_ctor_set(v_reuseFailAlloc_1858_, 3, v_goal_1845_);
lean_ctor_set(v_reuseFailAlloc_1858_, 4, v_snd_1840_);
lean_ctor_set_uint8(v_reuseFailAlloc_1858_, sizeof(void*)*5, v_didChange_1846_);
v___x_1851_ = v_reuseFailAlloc_1858_;
goto v_reusejp_1850_;
}
v_reusejp_1850_:
{
lean_object* v___x_1852_; uint8_t v___x_1853_; lean_object* v___x_1854_; lean_object* v___x_1856_; 
v___x_1852_ = lean_st_ref_set(v___y_1819_, v___x_1851_);
v___x_1853_ = 0;
v___x_1854_ = lean_box(v___x_1853_);
if (v_isShared_1838_ == 0)
{
lean_ctor_set(v___x_1837_, 0, v___x_1854_);
v___x_1856_ = v___x_1837_;
goto v_reusejp_1855_;
}
else
{
lean_object* v_reuseFailAlloc_1857_; 
v_reuseFailAlloc_1857_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1857_, 0, v___x_1854_);
v___x_1856_ = v_reuseFailAlloc_1857_;
goto v_reusejp_1855_;
}
v_reusejp_1855_:
{
return v___x_1856_;
}
}
}
}
else
{
lean_object* v_val_1861_; lean_object* v___x_1863_; 
lean_inc_ref(v_fst_1839_);
lean_dec(v_a_1835_);
v_val_1861_ = lean_ctor_get(v_fst_1839_, 0);
lean_inc(v_val_1861_);
lean_dec_ref_known(v_fst_1839_, 1);
if (v_isShared_1838_ == 0)
{
lean_ctor_set(v___x_1837_, 0, v_val_1861_);
v___x_1863_ = v___x_1837_;
goto v_reusejp_1862_;
}
else
{
lean_object* v_reuseFailAlloc_1864_; 
v_reuseFailAlloc_1864_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1864_, 0, v_val_1861_);
v___x_1863_ = v_reuseFailAlloc_1864_;
goto v_reusejp_1862_;
}
v_reusejp_1862_:
{
return v___x_1863_;
}
}
}
}
else
{
lean_object* v_a_1866_; lean_object* v___x_1868_; uint8_t v_isShared_1869_; uint8_t v_isSharedCheck_1873_; 
v_a_1866_ = lean_ctor_get(v___x_1834_, 0);
v_isSharedCheck_1873_ = !lean_is_exclusive(v___x_1834_);
if (v_isSharedCheck_1873_ == 0)
{
v___x_1868_ = v___x_1834_;
v_isShared_1869_ = v_isSharedCheck_1873_;
goto v_resetjp_1867_;
}
else
{
lean_inc(v_a_1866_);
lean_dec(v___x_1834_);
v___x_1868_ = lean_box(0);
v_isShared_1869_ = v_isSharedCheck_1873_;
goto v_resetjp_1867_;
}
v_resetjp_1867_:
{
lean_object* v___x_1871_; 
if (v_isShared_1869_ == 0)
{
v___x_1871_ = v___x_1868_;
goto v_reusejp_1870_;
}
else
{
lean_object* v_reuseFailAlloc_1872_; 
v_reuseFailAlloc_1872_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1872_, 0, v_a_1866_);
v___x_1871_ = v_reuseFailAlloc_1872_;
goto v_reusejp_1870_;
}
v_reusejp_1870_:
{
return v___x_1871_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__1___boxed(lean_object* v_a_1874_, lean_object* v___x_1875_, lean_object* v___y_1876_, lean_object* v___y_1877_, lean_object* v___y_1878_, lean_object* v___y_1879_, lean_object* v___y_1880_, lean_object* v___y_1881_, lean_object* v___y_1882_, lean_object* v___y_1883_, lean_object* v___y_1884_){
_start:
{
lean_object* v_res_1885_; 
v_res_1885_ = l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__1(v_a_1874_, v___x_1875_, v___y_1876_, v___y_1877_, v___y_1878_, v___y_1879_, v___y_1880_, v___y_1881_, v___y_1882_, v___y_1883_);
lean_dec(v___y_1883_);
lean_dec_ref(v___y_1882_);
lean_dec(v___y_1881_);
lean_dec_ref(v___y_1880_);
lean_dec(v___y_1879_);
lean_dec_ref(v___y_1878_);
lean_dec(v___y_1877_);
lean_dec_ref(v___y_1876_);
return v_res_1885_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__2(lean_object* v___f_1886_, lean_object* v___y_1887_, lean_object* v___y_1888_, lean_object* v___y_1889_, lean_object* v___y_1890_, lean_object* v___y_1891_, lean_object* v___y_1892_, lean_object* v___y_1893_, lean_object* v___y_1894_){
_start:
{
lean_object* v___x_1896_; lean_object* v_goal_1897_; lean_object* v___x_1898_; lean_object* v___x_1899_; 
v___x_1896_ = lean_st_ref_get(v___y_1888_);
v_goal_1897_ = lean_ctor_get(v___x_1896_, 3);
lean_inc_n(v_goal_1897_, 2);
lean_dec(v___x_1896_);
lean_inc_ref(v___f_1886_);
v___x_1898_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1898_, 0, v___f_1886_);
lean_ctor_set(v___x_1898_, 1, v___f_1886_);
v___x_1899_ = l_Lean_Meta_Tactic_BVDecide_Normalize_addIntToBitVecLemmas___redArg(v_goal_1897_, v___x_1898_, v___y_1891_, v___y_1892_, v___y_1893_, v___y_1894_);
if (lean_obj_tag(v___x_1899_) == 0)
{
lean_object* v_a_1900_; lean_object* v_maxSteps_1901_; lean_object* v___x_1902_; lean_object* v___x_1903_; lean_object* v___f_1904_; lean_object* v___x_1905_; 
v_a_1900_ = lean_ctor_get(v___x_1899_, 0);
lean_inc(v_a_1900_);
lean_dec_ref_known(v___x_1899_, 1);
v_maxSteps_1901_ = lean_ctor_get(v___y_1887_, 1);
v___x_1902_ = lean_unsigned_to_nat(2u);
lean_inc(v_maxSteps_1901_);
v___x_1903_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1903_, 0, v_maxSteps_1901_);
lean_ctor_set(v___x_1903_, 1, v___x_1902_);
v___f_1904_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__1___boxed), 11, 2);
lean_closure_set(v___f_1904_, 0, v_a_1900_);
lean_closure_set(v___f_1904_, 1, v___x_1903_);
v___x_1905_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__3___redArg(v_goal_1897_, v___f_1904_, v___y_1887_, v___y_1888_, v___y_1889_, v___y_1890_, v___y_1891_, v___y_1892_, v___y_1893_, v___y_1894_);
return v___x_1905_;
}
else
{
lean_object* v_a_1906_; lean_object* v___x_1908_; uint8_t v_isShared_1909_; uint8_t v_isSharedCheck_1913_; 
lean_dec(v_goal_1897_);
v_a_1906_ = lean_ctor_get(v___x_1899_, 0);
v_isSharedCheck_1913_ = !lean_is_exclusive(v___x_1899_);
if (v_isSharedCheck_1913_ == 0)
{
v___x_1908_ = v___x_1899_;
v_isShared_1909_ = v_isSharedCheck_1913_;
goto v_resetjp_1907_;
}
else
{
lean_inc(v_a_1906_);
lean_dec(v___x_1899_);
v___x_1908_ = lean_box(0);
v_isShared_1909_ = v_isSharedCheck_1913_;
goto v_resetjp_1907_;
}
v_resetjp_1907_:
{
lean_object* v___x_1911_; 
if (v_isShared_1909_ == 0)
{
v___x_1911_ = v___x_1908_;
goto v_reusejp_1910_;
}
else
{
lean_object* v_reuseFailAlloc_1912_; 
v_reuseFailAlloc_1912_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1912_, 0, v_a_1906_);
v___x_1911_ = v_reuseFailAlloc_1912_;
goto v_reusejp_1910_;
}
v_reusejp_1910_:
{
return v___x_1911_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__2___boxed(lean_object* v___f_1914_, lean_object* v___y_1915_, lean_object* v___y_1916_, lean_object* v___y_1917_, lean_object* v___y_1918_, lean_object* v___y_1919_, lean_object* v___y_1920_, lean_object* v___y_1921_, lean_object* v___y_1922_, lean_object* v___y_1923_){
_start:
{
lean_object* v_res_1924_; 
v_res_1924_ = l_Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass___lam__2(v___f_1914_, v___y_1915_, v___y_1916_, v___y_1917_, v___y_1918_, v___y_1919_, v___y_1920_, v___y_1921_, v___y_1922_);
lean_dec(v___y_1922_);
lean_dec_ref(v___y_1921_);
lean_dec(v___y_1920_);
lean_dec_ref(v___y_1919_);
lean_dec(v___y_1918_);
lean_dec_ref(v___y_1917_);
lean_dec(v___y_1916_);
lean_dec_ref(v___y_1915_);
return v_res_1924_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0(lean_object* v_cls_1935_, lean_object* v_msg_1936_, lean_object* v___y_1937_, lean_object* v___y_1938_, lean_object* v___y_1939_, lean_object* v___y_1940_, lean_object* v___y_1941_, lean_object* v___y_1942_, lean_object* v___y_1943_, lean_object* v___y_1944_){
_start:
{
lean_object* v___x_1946_; 
v___x_1946_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___redArg(v_cls_1935_, v_msg_1936_, v___y_1941_, v___y_1942_, v___y_1943_, v___y_1944_);
return v___x_1946_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0___boxed(lean_object* v_cls_1947_, lean_object* v_msg_1948_, lean_object* v___y_1949_, lean_object* v___y_1950_, lean_object* v___y_1951_, lean_object* v___y_1952_, lean_object* v___y_1953_, lean_object* v___y_1954_, lean_object* v___y_1955_, lean_object* v___y_1956_, lean_object* v___y_1957_){
_start:
{
lean_object* v_res_1958_; 
v_res_1958_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__0(v_cls_1947_, v_msg_1948_, v___y_1949_, v___y_1950_, v___y_1951_, v___y_1952_, v___y_1953_, v___y_1954_, v___y_1955_, v___y_1956_);
lean_dec(v___y_1956_);
lean_dec_ref(v___y_1955_);
lean_dec(v___y_1954_);
lean_dec_ref(v___y_1953_);
lean_dec(v___y_1952_);
lean_dec_ref(v___y_1951_);
lean_dec(v___y_1950_);
lean_dec_ref(v___y_1949_);
return v_res_1958_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1(lean_object* v_mvarId_1959_, lean_object* v_val_1960_, lean_object* v___y_1961_, lean_object* v___y_1962_, lean_object* v___y_1963_, lean_object* v___y_1964_, lean_object* v___y_1965_, lean_object* v___y_1966_, lean_object* v___y_1967_, lean_object* v___y_1968_){
_start:
{
lean_object* v___x_1970_; 
v___x_1970_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1___redArg(v_mvarId_1959_, v_val_1960_, v___y_1966_);
return v___x_1970_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1___boxed(lean_object* v_mvarId_1971_, lean_object* v_val_1972_, lean_object* v___y_1973_, lean_object* v___y_1974_, lean_object* v___y_1975_, lean_object* v___y_1976_, lean_object* v___y_1977_, lean_object* v___y_1978_, lean_object* v___y_1979_, lean_object* v___y_1980_, lean_object* v___y_1981_){
_start:
{
lean_object* v_res_1982_; 
v_res_1982_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1(v_mvarId_1971_, v_val_1972_, v___y_1973_, v___y_1974_, v___y_1975_, v___y_1976_, v___y_1977_, v___y_1978_, v___y_1979_, v___y_1980_);
lean_dec(v___y_1980_);
lean_dec_ref(v___y_1979_);
lean_dec(v___y_1978_);
lean_dec_ref(v___y_1977_);
lean_dec(v___y_1976_);
lean_dec_ref(v___y_1975_);
lean_dec(v___y_1974_);
lean_dec_ref(v___y_1973_);
return v_res_1982_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2(lean_object* v_upperBound_1983_, lean_object* v___x_1984_, lean_object* v_a_1985_, lean_object* v___x_1986_, lean_object* v_inst_1987_, lean_object* v_R_1988_, lean_object* v_a_1989_, lean_object* v_b_1990_, lean_object* v_c_1991_, lean_object* v___y_1992_, lean_object* v___y_1993_, lean_object* v___y_1994_, lean_object* v___y_1995_, lean_object* v___y_1996_, lean_object* v___y_1997_, lean_object* v___y_1998_, lean_object* v___y_1999_){
_start:
{
lean_object* v___x_2001_; 
v___x_2001_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___redArg(v_upperBound_1983_, v___x_1984_, v_a_1985_, v___x_1986_, v_a_1989_, v_b_1990_, v___y_1992_, v___y_1993_, v___y_1994_, v___y_1995_, v___y_1996_, v___y_1997_, v___y_1998_, v___y_1999_);
return v___x_2001_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2___boxed(lean_object** _args){
lean_object* v_upperBound_2002_ = _args[0];
lean_object* v___x_2003_ = _args[1];
lean_object* v_a_2004_ = _args[2];
lean_object* v___x_2005_ = _args[3];
lean_object* v_inst_2006_ = _args[4];
lean_object* v_R_2007_ = _args[5];
lean_object* v_a_2008_ = _args[6];
lean_object* v_b_2009_ = _args[7];
lean_object* v_c_2010_ = _args[8];
lean_object* v___y_2011_ = _args[9];
lean_object* v___y_2012_ = _args[10];
lean_object* v___y_2013_ = _args[11];
lean_object* v___y_2014_ = _args[12];
lean_object* v___y_2015_ = _args[13];
lean_object* v___y_2016_ = _args[14];
lean_object* v___y_2017_ = _args[15];
lean_object* v___y_2018_ = _args[16];
lean_object* v___y_2019_ = _args[17];
_start:
{
lean_object* v_res_2020_; 
v_res_2020_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__2(v_upperBound_2002_, v___x_2003_, v_a_2004_, v___x_2005_, v_inst_2006_, v_R_2007_, v_a_2008_, v_b_2009_, v_c_2010_, v___y_2011_, v___y_2012_, v___y_2013_, v___y_2014_, v___y_2015_, v___y_2016_, v___y_2017_, v___y_2018_);
lean_dec(v___y_2018_);
lean_dec_ref(v___y_2017_);
lean_dec(v___y_2016_);
lean_dec_ref(v___y_2015_);
lean_dec(v___y_2014_);
lean_dec_ref(v___y_2013_);
lean_dec(v___y_2012_);
lean_dec_ref(v___y_2011_);
lean_dec_ref(v___x_2003_);
lean_dec(v_upperBound_2002_);
return v_res_2020_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2(lean_object* v_00_u03b2_2021_, lean_object* v_x_2022_, lean_object* v_x_2023_, lean_object* v_x_2024_){
_start:
{
lean_object* v___x_2025_; 
v___x_2025_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2___redArg(v_x_2022_, v_x_2023_, v_x_2024_);
return v___x_2025_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4(lean_object* v_00_u03b2_2026_, lean_object* v_x_2027_, size_t v_x_2028_, size_t v_x_2029_, lean_object* v_x_2030_, lean_object* v_x_2031_){
_start:
{
lean_object* v___x_2032_; 
v___x_2032_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___redArg(v_x_2027_, v_x_2028_, v_x_2029_, v_x_2030_, v_x_2031_);
return v___x_2032_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4___boxed(lean_object* v_00_u03b2_2033_, lean_object* v_x_2034_, lean_object* v_x_2035_, lean_object* v_x_2036_, lean_object* v_x_2037_, lean_object* v_x_2038_){
_start:
{
size_t v_x_29430__boxed_2039_; size_t v_x_29431__boxed_2040_; lean_object* v_res_2041_; 
v_x_29430__boxed_2039_ = lean_unbox_usize(v_x_2035_);
lean_dec(v_x_2035_);
v_x_29431__boxed_2040_ = lean_unbox_usize(v_x_2036_);
lean_dec(v_x_2036_);
v_res_2041_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4(v_00_u03b2_2033_, v_x_2034_, v_x_29430__boxed_2039_, v_x_29431__boxed_2040_, v_x_2037_, v_x_2038_);
return v_res_2041_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6(lean_object* v_00_u03b2_2042_, lean_object* v_n_2043_, lean_object* v_k_2044_, lean_object* v_v_2045_){
_start:
{
lean_object* v___x_2046_; 
v___x_2046_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6___redArg(v_n_2043_, v_k_2044_, v_v_2045_);
return v___x_2046_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7(lean_object* v_00_u03b2_2047_, size_t v_depth_2048_, lean_object* v_keys_2049_, lean_object* v_vals_2050_, lean_object* v_heq_2051_, lean_object* v_i_2052_, lean_object* v_entries_2053_){
_start:
{
lean_object* v___x_2054_; 
v___x_2054_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7___redArg(v_depth_2048_, v_keys_2049_, v_vals_2050_, v_i_2052_, v_entries_2053_);
return v___x_2054_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7___boxed(lean_object* v_00_u03b2_2055_, lean_object* v_depth_2056_, lean_object* v_keys_2057_, lean_object* v_vals_2058_, lean_object* v_heq_2059_, lean_object* v_i_2060_, lean_object* v_entries_2061_){
_start:
{
size_t v_depth_boxed_2062_; lean_object* v_res_2063_; 
v_depth_boxed_2062_ = lean_unbox_usize(v_depth_2056_);
lean_dec(v_depth_2056_);
v_res_2063_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__7(v_00_u03b2_2055_, v_depth_boxed_2062_, v_keys_2057_, v_vals_2058_, v_heq_2059_, v_i_2060_, v_entries_2061_);
lean_dec_ref(v_vals_2058_);
lean_dec_ref(v_keys_2057_);
return v_res_2063_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6_spec__7(lean_object* v_00_u03b2_2064_, lean_object* v_x_2065_, lean_object* v_x_2066_, lean_object* v_x_2067_, lean_object* v_x_2068_){
_start:
{
lean_object* v___x_2069_; 
v___x_2069_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_intToBitVecPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(v_x_2065_, v_x_2066_, v_x_2067_, v_x_2068_);
return v___x_2069_;
}
}
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_Rewrite(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_InstantiateMVarsS(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_LitValues(uint8_t builtin);
lean_object* runtime_initialize_Init_Data_UInt_IntToBitVec(uint8_t builtin);
lean_object* runtime_initialize_Init_Data_SInt_IntToBitVec(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_InstantiateMVarsS(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_LitValues(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Init_Data_UInt_IntToBitVec(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Init_Data_SInt_IntToBitVec(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_Rewrite(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_InstantiateMVarsS(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_LitValues(uint8_t builtin);
lean_object* initialize_Init_Data_UInt_IntToBitVec(uint8_t builtin);
lean_object* initialize_Init_Data_SInt_IntToBitVec(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_InstantiateMVarsS(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_LitValues(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init_Data_UInt_IntToBitVec(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init_Data_SInt_IntToBitVec(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Meta_Tactic_BVDecide_Normalize_IntToBitVec(builtin);
}
#ifdef __cplusplus
}
#endif
