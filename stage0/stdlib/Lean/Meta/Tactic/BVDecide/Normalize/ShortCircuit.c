// Lean compiler output
// Module: Lean.Meta.Tactic.BVDecide.Normalize.ShortCircuit
// Imports: public import Lean.Meta.Tactic.BVDecide.Normalize.Basic public import Std.Tactic.BVDecide.Normalize.BitVec import Lean.Meta.Sym.Simp.Theorems import Lean.Meta.Sym.Simp.Rewrite
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
lean_object* lean_array_get_size(lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
lean_object* lean_array_fget_borrowed(lean_object*, lean_object*);
lean_object* l_Lean_Expr_cleanupAnnotations(lean_object*);
uint8_t l_Lean_Expr_isApp(lean_object*);
lean_object* l_Lean_Expr_appFnCleanup___redArg(lean_object*);
lean_object* l_Lean_Name_mkStr2(lean_object*, lean_object*);
uint8_t l_Lean_Expr_isConstOf(lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr1(lean_object*);
uint8_t l___private_Lean_Meta_Sym_ExprPtr_0__Lean_Meta_Sym_isSameExpr_unsafe__1(lean_object*, lean_object*);
lean_object* l_Lean_mkConst(lean_object*, lean_object*);
lean_object* l_Lean_Level_ofNat(lean_object*);
lean_object* l_Lean_mkApp4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Expr_app___override(lean_object*, lean_object*);
lean_object* l_Lean_mkAppB(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_shareCommonInc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_simp___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_SimpM_run_x27___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_Expr_isFalse(lean_object*);
lean_object* lean_array_push(lean_object*, lean_object*);
lean_object* lean_st_ref_take(lean_object*);
lean_object* lean_st_ref_set(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Internal_Sym_assertShared(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr3(lean_object*, lean_object*, lean_object*);
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
size_t lean_usize_add(size_t, size_t);
lean_object* l_Lean_PersistentHashMap_mkEmptyEntries(lean_object*, lean_object*);
size_t lean_usize_sub(size_t, size_t);
size_t lean_usize_mul(size_t, size_t);
uint8_t lean_usize_dec_le(size_t, size_t);
lean_object* l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(lean_object*);
lean_object* l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc_withDoneResult___redArg___lam__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc_withDoneResult___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc_withDoneResult(lean_object*, lean_object*, lean_object*);
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*0 + 8, .m_other = 0, .m_tag = 0}, .m_objs = {LEAN_SCALAR_PTR_LITERAL(0, 0, 0, 0, 0, 0, 0, 0)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0___closed__0_value;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "BEq"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__0_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "beq"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__1 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__1_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__0_value),LEAN_SCALAR_PTR_LITERAL(195, 188, 39, 55, 57, 152, 88, 223)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__2_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__1_value),LEAN_SCALAR_PTR_LITERAL(82, 52, 243, 194, 7, 226, 90, 135)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__2 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__2_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "BitVec"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__3 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__3_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__3_value),LEAN_SCALAR_PTR_LITERAL(108, 178, 58, 132, 143, 189, 222, 74)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__4 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__4_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "HMul"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__5 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__5_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "hMul"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__6 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__6_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__7_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__5_value),LEAN_SCALAR_PTR_LITERAL(254, 113, 255, 140, 142, 9, 169, 40)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__7_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__6_value),LEAN_SCALAR_PTR_LITERAL(248, 227, 200, 215, 229, 255, 92, 22)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__7 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__7_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Bool"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__8 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__8_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__9_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "not"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__9 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__9_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__10_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__8_value),LEAN_SCALAR_PTR_LITERAL(250, 44, 198, 216, 184, 195, 199, 178)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__10_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__9_value),LEAN_SCALAR_PTR_LITERAL(208, 215, 171, 150, 192, 180, 249, 22)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__10 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__10_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__11_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__11;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__12_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__12;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__13_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__13;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__14_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__14;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__15_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "and"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__15 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__15_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__16_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__8_value),LEAN_SCALAR_PTR_LITERAL(250, 44, 198, 216, 184, 195, 199, 178)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__16_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__16_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__15_value),LEAN_SCALAR_PTR_LITERAL(160, 26, 8, 228, 104, 32, 82, 85)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__16 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__16_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__17_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__17;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__18_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "Std"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__18 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__18_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__19_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__19 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__19_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__20_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "BVDecide"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__20 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__20_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__21_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "Normalize"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__21 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__21_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__22_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 31, .m_capacity = 31, .m_length = 30, .m_data = "mul_beq_mul_short_circuit_left"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__22 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__22_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__18_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__19_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_1),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__20_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_2),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__21_value),LEAN_SCALAR_PTR_LITERAL(105, 120, 51, 161, 199, 191, 75, 23)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_4 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_3),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__3_value),LEAN_SCALAR_PTR_LITERAL(6, 181, 64, 73, 102, 44, 61, 193)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value_aux_4),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__22_value),LEAN_SCALAR_PTR_LITERAL(53, 48, 36, 136, 58, 30, 220, 150)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__24_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__24;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__25_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 32, .m_capacity = 32, .m_length = 31, .m_data = "mul_beq_mul_short_circuit_right"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__25 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__25_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__18_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__19_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_1),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__20_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_2),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__21_value),LEAN_SCALAR_PTR_LITERAL(105, 120, 51, 161, 199, 191, 75, 23)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_4 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_3),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__3_value),LEAN_SCALAR_PTR_LITERAL(6, 181, 64, 73, 102, 44, 61, 193)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value_aux_4),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__25_value),LEAN_SCALAR_PTR_LITERAL(98, 146, 161, 224, 242, 166, 216, 103)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__27_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__27;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6___redArg(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg___closed__0;
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg(lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7___redArg(size_t, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__2(uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static double l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__0;
static const lean_string_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 1, .m_capacity = 1, .m_length = 0, .m_data = ""};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__1 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__1_value;
static const lean_array_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__2 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__2_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__0___boxed, .m_arity = 11, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__0 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__0_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__1;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Meta"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__2 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__2_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "bv"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__3 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__3_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__4_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__2_value),LEAN_SCALAR_PTR_LITERAL(211, 174, 49, 251, 64, 24, 251, 1)}};
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__4_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__4_value_aux_0),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__19_value),LEAN_SCALAR_PTR_LITERAL(194, 95, 140, 15, 16, 100, 236, 219)}};
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__4_value_aux_1),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__3_value),LEAN_SCALAR_PTR_LITERAL(139, 41, 106, 94, 234, 34, 111, 146)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__4 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__4_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trace"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__5 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__5_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__5_value),LEAN_SCALAR_PTR_LITERAL(212, 145, 141, 177, 67, 149, 127, 197)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__6 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__6_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__7;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "  ==>  "};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__8 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__8_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__9;
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__1___boxed, .m_arity = 9, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 17, .m_capacity = 17, .m_length = 16, .m_data = "shortCircuitPass"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__1_value),LEAN_SCALAR_PTR_LITERAL(45, 197, 199, 240, 107, 41, 97, 28)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__2_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__2_value),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__0_value)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__3_value;
LEAN_EXPORT const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___closed__3_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4(lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7(lean_object*, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6_spec__7(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc_withDoneResult___redArg___lam__0(lean_object* v_toPure_1_, lean_object* v_x_2_){
_start:
{
if (lean_obj_tag(v_x_2_) == 0)
{
uint8_t v_contextDependent_3_; lean_object* v___x_5_; uint8_t v_isShared_6_; uint8_t v_isSharedCheck_12_; 
v_contextDependent_3_ = lean_ctor_get_uint8(v_x_2_, 1);
v_isSharedCheck_12_ = !lean_is_exclusive(v_x_2_);
if (v_isSharedCheck_12_ == 0)
{
v___x_5_ = v_x_2_;
v_isShared_6_ = v_isSharedCheck_12_;
goto v_resetjp_4_;
}
else
{
lean_dec(v_x_2_);
v___x_5_ = lean_box(0);
v_isShared_6_ = v_isSharedCheck_12_;
goto v_resetjp_4_;
}
v_resetjp_4_:
{
uint8_t v___x_7_; lean_object* v___x_9_; 
v___x_7_ = 1;
if (v_isShared_6_ == 0)
{
v___x_9_ = v___x_5_;
goto v_reusejp_8_;
}
else
{
lean_object* v_reuseFailAlloc_11_; 
v_reuseFailAlloc_11_ = lean_alloc_ctor(0, 0, 2);
lean_ctor_set_uint8(v_reuseFailAlloc_11_, 1, v_contextDependent_3_);
v___x_9_ = v_reuseFailAlloc_11_;
goto v_reusejp_8_;
}
v_reusejp_8_:
{
lean_object* v___x_10_; 
lean_ctor_set_uint8(v___x_9_, 0, v___x_7_);
v___x_10_ = lean_apply_2(v_toPure_1_, lean_box(0), v___x_9_);
return v___x_10_;
}
}
}
else
{
lean_object* v_e_x27_13_; lean_object* v_proof_14_; uint8_t v_contextDependent_15_; lean_object* v___x_17_; uint8_t v_isShared_18_; uint8_t v_isSharedCheck_24_; 
v_e_x27_13_ = lean_ctor_get(v_x_2_, 0);
v_proof_14_ = lean_ctor_get(v_x_2_, 1);
v_contextDependent_15_ = lean_ctor_get_uint8(v_x_2_, sizeof(void*)*2 + 1);
v_isSharedCheck_24_ = !lean_is_exclusive(v_x_2_);
if (v_isSharedCheck_24_ == 0)
{
v___x_17_ = v_x_2_;
v_isShared_18_ = v_isSharedCheck_24_;
goto v_resetjp_16_;
}
else
{
lean_inc(v_proof_14_);
lean_inc(v_e_x27_13_);
lean_dec(v_x_2_);
v___x_17_ = lean_box(0);
v_isShared_18_ = v_isSharedCheck_24_;
goto v_resetjp_16_;
}
v_resetjp_16_:
{
uint8_t v___x_19_; lean_object* v___x_21_; 
v___x_19_ = 1;
if (v_isShared_18_ == 0)
{
v___x_21_ = v___x_17_;
goto v_reusejp_20_;
}
else
{
lean_object* v_reuseFailAlloc_23_; 
v_reuseFailAlloc_23_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_23_, 0, v_e_x27_13_);
lean_ctor_set(v_reuseFailAlloc_23_, 1, v_proof_14_);
lean_ctor_set_uint8(v_reuseFailAlloc_23_, sizeof(void*)*2 + 1, v_contextDependent_15_);
v___x_21_ = v_reuseFailAlloc_23_;
goto v_reusejp_20_;
}
v_reusejp_20_:
{
lean_object* v___x_22_; 
lean_ctor_set_uint8(v___x_21_, sizeof(void*)*2, v___x_19_);
v___x_22_ = lean_apply_2(v_toPure_1_, lean_box(0), v___x_21_);
return v___x_22_;
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc_withDoneResult___redArg(lean_object* v_inst_25_, lean_object* v_x_26_){
_start:
{
lean_object* v_toApplicative_27_; lean_object* v_toBind_28_; lean_object* v_toPure_29_; lean_object* v___f_30_; lean_object* v___x_31_; 
v_toApplicative_27_ = lean_ctor_get(v_inst_25_, 0);
lean_inc_ref(v_toApplicative_27_);
v_toBind_28_ = lean_ctor_get(v_inst_25_, 1);
lean_inc(v_toBind_28_);
lean_dec_ref(v_inst_25_);
v_toPure_29_ = lean_ctor_get(v_toApplicative_27_, 1);
lean_inc(v_toPure_29_);
lean_dec_ref(v_toApplicative_27_);
v___f_30_ = lean_alloc_closure((void*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc_withDoneResult___redArg___lam__0), 2, 1);
lean_closure_set(v___f_30_, 0, v_toPure_29_);
v___x_31_ = lean_apply_4(v_toBind_28_, lean_box(0), lean_box(0), v_x_26_, v___f_30_);
return v___x_31_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc_withDoneResult(lean_object* v_m_32_, lean_object* v_inst_33_, lean_object* v_x_34_){
_start:
{
lean_object* v_toApplicative_35_; lean_object* v_toBind_36_; lean_object* v_toPure_37_; lean_object* v___f_38_; lean_object* v___x_39_; 
v_toApplicative_35_ = lean_ctor_get(v_inst_33_, 0);
lean_inc_ref(v_toApplicative_35_);
v_toBind_36_ = lean_ctor_get(v_inst_33_, 1);
lean_inc(v_toBind_36_);
lean_dec_ref(v_inst_33_);
v_toPure_37_ = lean_ctor_get(v_toApplicative_35_, 1);
lean_inc(v_toPure_37_);
lean_dec_ref(v_toApplicative_35_);
v___f_38_ = lean_alloc_closure((void*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc_withDoneResult___redArg___lam__0), 2, 1);
lean_closure_set(v___f_38_, 0, v_toPure_37_);
v___x_39_ = lean_apply_4(v_toBind_36_, lean_box(0), lean_box(0), v_x_34_, v___f_38_);
return v___x_39_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(lean_object* v_x_42_, lean_object* v___y_43_, lean_object* v___y_44_, lean_object* v___y_45_, lean_object* v___y_46_, lean_object* v___y_47_, lean_object* v___y_48_, lean_object* v___y_49_, lean_object* v___y_50_, lean_object* v___y_51_){
_start:
{
lean_object* v___x_53_; lean_object* v___x_54_; 
v___x_53_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0___closed__0));
v___x_54_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_54_, 0, v___x_53_);
return v___x_54_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0___boxed(lean_object* v_x_55_, lean_object* v___y_56_, lean_object* v___y_57_, lean_object* v___y_58_, lean_object* v___y_59_, lean_object* v___y_60_, lean_object* v___y_61_, lean_object* v___y_62_, lean_object* v___y_63_, lean_object* v___y_64_, lean_object* v___y_65_){
_start:
{
lean_object* v_res_66_; 
v_res_66_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v_x_55_, v___y_56_, v___y_57_, v___y_58_, v___y_59_, v___y_60_, v___y_61_, v___y_62_, v___y_63_, v___y_64_);
lean_dec(v___y_64_);
lean_dec_ref(v___y_63_);
lean_dec(v___y_62_);
lean_dec_ref(v___y_61_);
lean_dec(v___y_60_);
lean_dec_ref(v___y_59_);
lean_dec(v___y_58_);
lean_dec_ref(v___y_57_);
lean_dec(v___y_56_);
return v_res_66_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__11(void){
_start:
{
lean_object* v___x_85_; lean_object* v___x_86_; lean_object* v___x_87_; 
v___x_85_ = lean_box(0);
v___x_86_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__10));
v___x_87_ = l_Lean_mkConst(v___x_86_, v___x_85_);
return v___x_87_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__12(void){
_start:
{
lean_object* v___x_88_; lean_object* v___x_89_; 
v___x_88_ = lean_unsigned_to_nat(0u);
v___x_89_ = l_Lean_Level_ofNat(v___x_88_);
return v___x_89_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__13(void){
_start:
{
lean_object* v___x_90_; lean_object* v___x_91_; lean_object* v___x_92_; 
v___x_90_ = lean_box(0);
v___x_91_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__12, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__12_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__12);
v___x_92_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v___x_92_, 0, v___x_91_);
lean_ctor_set(v___x_92_, 1, v___x_90_);
return v___x_92_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__14(void){
_start:
{
lean_object* v___x_93_; lean_object* v___x_94_; lean_object* v___x_95_; 
v___x_93_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__13, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__13_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__13);
v___x_94_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__2));
v___x_95_ = l_Lean_mkConst(v___x_94_, v___x_93_);
return v___x_95_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__17(void){
_start:
{
lean_object* v___x_100_; lean_object* v___x_101_; lean_object* v___x_102_; 
v___x_100_ = lean_box(0);
v___x_101_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__16));
v___x_102_ = l_Lean_mkConst(v___x_101_, v___x_100_);
return v___x_102_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__24(void){
_start:
{
lean_object* v___x_115_; lean_object* v___x_116_; lean_object* v___x_117_; 
v___x_115_ = lean_box(0);
v___x_116_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__23));
v___x_117_ = l_Lean_mkConst(v___x_116_, v___x_115_);
return v___x_117_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__27(void){
_start:
{
lean_object* v___x_126_; lean_object* v___x_127_; lean_object* v___x_128_; 
v___x_126_ = lean_box(0);
v___x_127_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__26));
v___x_128_ = l_Lean_mkConst(v___x_127_, v___x_126_);
return v___x_128_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc(lean_object* v_e_129_, lean_object* v_a_130_, lean_object* v_a_131_, lean_object* v_a_132_, lean_object* v_a_133_, lean_object* v_a_134_, lean_object* v_a_135_, lean_object* v_a_136_, lean_object* v_a_137_, lean_object* v_a_138_){
_start:
{
lean_object* v_e_x27_141_; lean_object* v_proof_142_; uint8_t v_contextDependent_143_; uint8_t v_contextDependent_148_; lean_object* v___y_153_; lean_object* v___x_159_; uint8_t v___x_160_; 
lean_inc_ref(v_e_129_);
v___x_159_ = l_Lean_Expr_cleanupAnnotations(v_e_129_);
v___x_160_ = l_Lean_Expr_isApp(v___x_159_);
if (v___x_160_ == 0)
{
lean_object* v___x_161_; lean_object* v___x_162_; 
lean_dec_ref(v___x_159_);
lean_dec_ref(v_e_129_);
v___x_161_ = lean_box(0);
v___x_162_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_161_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_162_;
goto v___jp_152_;
}
else
{
lean_object* v_arg_163_; lean_object* v___x_164_; uint8_t v___x_165_; 
v_arg_163_ = lean_ctor_get(v___x_159_, 1);
lean_inc_ref(v_arg_163_);
v___x_164_ = l_Lean_Expr_appFnCleanup___redArg(v___x_159_);
v___x_165_ = l_Lean_Expr_isApp(v___x_164_);
if (v___x_165_ == 0)
{
lean_object* v___x_166_; lean_object* v___x_167_; 
lean_dec_ref(v___x_164_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_166_ = lean_box(0);
v___x_167_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_166_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_167_;
goto v___jp_152_;
}
else
{
lean_object* v_arg_168_; lean_object* v___x_169_; uint8_t v___x_170_; 
v_arg_168_ = lean_ctor_get(v___x_164_, 1);
lean_inc_ref(v_arg_168_);
v___x_169_ = l_Lean_Expr_appFnCleanup___redArg(v___x_164_);
v___x_170_ = l_Lean_Expr_isApp(v___x_169_);
if (v___x_170_ == 0)
{
lean_object* v___x_171_; lean_object* v___x_172_; 
lean_dec_ref(v___x_169_);
lean_dec_ref(v_arg_168_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_171_ = lean_box(0);
v___x_172_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_171_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_172_;
goto v___jp_152_;
}
else
{
lean_object* v_arg_173_; lean_object* v___x_174_; uint8_t v___x_175_; 
v_arg_173_ = lean_ctor_get(v___x_169_, 1);
lean_inc_ref(v_arg_173_);
v___x_174_ = l_Lean_Expr_appFnCleanup___redArg(v___x_169_);
v___x_175_ = l_Lean_Expr_isApp(v___x_174_);
if (v___x_175_ == 0)
{
lean_object* v___x_176_; lean_object* v___x_177_; 
lean_dec_ref(v___x_174_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_168_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_176_ = lean_box(0);
v___x_177_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_176_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_177_;
goto v___jp_152_;
}
else
{
lean_object* v_arg_178_; lean_object* v___x_179_; lean_object* v___x_180_; uint8_t v___x_181_; 
v_arg_178_ = lean_ctor_get(v___x_174_, 1);
lean_inc_ref(v_arg_178_);
v___x_179_ = l_Lean_Expr_appFnCleanup___redArg(v___x_174_);
v___x_180_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__2));
v___x_181_ = l_Lean_Expr_isConstOf(v___x_179_, v___x_180_);
lean_dec_ref(v___x_179_);
if (v___x_181_ == 0)
{
lean_object* v___x_182_; lean_object* v___x_183_; 
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_168_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_182_ = lean_box(0);
v___x_183_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_182_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_183_;
goto v___jp_152_;
}
else
{
lean_object* v___x_184_; uint8_t v___x_185_; 
lean_inc_ref(v_arg_178_);
v___x_184_ = l_Lean_Expr_cleanupAnnotations(v_arg_178_);
v___x_185_ = l_Lean_Expr_isApp(v___x_184_);
if (v___x_185_ == 0)
{
lean_object* v___x_186_; lean_object* v___x_187_; 
lean_dec_ref(v___x_184_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_168_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_186_ = lean_box(0);
v___x_187_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_186_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_187_;
goto v___jp_152_;
}
else
{
lean_object* v_arg_188_; lean_object* v___x_189_; lean_object* v___x_190_; uint8_t v___x_191_; 
v_arg_188_ = lean_ctor_get(v___x_184_, 1);
lean_inc_ref(v_arg_188_);
v___x_189_ = l_Lean_Expr_appFnCleanup___redArg(v___x_184_);
v___x_190_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__4));
v___x_191_ = l_Lean_Expr_isConstOf(v___x_189_, v___x_190_);
lean_dec_ref(v___x_189_);
if (v___x_191_ == 0)
{
lean_object* v___x_192_; lean_object* v___x_193_; 
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_168_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_192_ = lean_box(0);
v___x_193_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_192_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_193_;
goto v___jp_152_;
}
else
{
lean_object* v___x_194_; uint8_t v___x_195_; 
v___x_194_ = l_Lean_Expr_cleanupAnnotations(v_arg_168_);
v___x_195_ = l_Lean_Expr_isApp(v___x_194_);
if (v___x_195_ == 0)
{
lean_object* v___x_196_; lean_object* v___x_197_; 
lean_dec_ref(v___x_194_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_196_ = lean_box(0);
v___x_197_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_196_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_197_;
goto v___jp_152_;
}
else
{
lean_object* v_arg_198_; lean_object* v___x_199_; uint8_t v___x_200_; 
v_arg_198_ = lean_ctor_get(v___x_194_, 1);
lean_inc_ref(v_arg_198_);
v___x_199_ = l_Lean_Expr_appFnCleanup___redArg(v___x_194_);
v___x_200_ = l_Lean_Expr_isApp(v___x_199_);
if (v___x_200_ == 0)
{
lean_object* v___x_201_; lean_object* v___x_202_; 
lean_dec_ref(v___x_199_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_201_ = lean_box(0);
v___x_202_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_201_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_202_;
goto v___jp_152_;
}
else
{
lean_object* v_arg_203_; lean_object* v___x_204_; uint8_t v___x_205_; 
v_arg_203_ = lean_ctor_get(v___x_199_, 1);
lean_inc_ref(v_arg_203_);
v___x_204_ = l_Lean_Expr_appFnCleanup___redArg(v___x_199_);
v___x_205_ = l_Lean_Expr_isApp(v___x_204_);
if (v___x_205_ == 0)
{
lean_object* v___x_206_; lean_object* v___x_207_; 
lean_dec_ref(v___x_204_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_206_ = lean_box(0);
v___x_207_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_206_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_207_;
goto v___jp_152_;
}
else
{
lean_object* v___x_208_; uint8_t v___x_209_; 
v___x_208_ = l_Lean_Expr_appFnCleanup___redArg(v___x_204_);
v___x_209_ = l_Lean_Expr_isApp(v___x_208_);
if (v___x_209_ == 0)
{
lean_object* v___x_210_; lean_object* v___x_211_; 
lean_dec_ref(v___x_208_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_210_ = lean_box(0);
v___x_211_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_210_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_211_;
goto v___jp_152_;
}
else
{
lean_object* v___x_212_; uint8_t v___x_213_; 
v___x_212_ = l_Lean_Expr_appFnCleanup___redArg(v___x_208_);
v___x_213_ = l_Lean_Expr_isApp(v___x_212_);
if (v___x_213_ == 0)
{
lean_object* v___x_214_; lean_object* v___x_215_; 
lean_dec_ref(v___x_212_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_214_ = lean_box(0);
v___x_215_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_214_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_215_;
goto v___jp_152_;
}
else
{
lean_object* v___x_216_; uint8_t v___x_217_; 
v___x_216_ = l_Lean_Expr_appFnCleanup___redArg(v___x_212_);
v___x_217_ = l_Lean_Expr_isApp(v___x_216_);
if (v___x_217_ == 0)
{
lean_object* v___x_218_; lean_object* v___x_219_; 
lean_dec_ref(v___x_216_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_218_ = lean_box(0);
v___x_219_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_218_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_219_;
goto v___jp_152_;
}
else
{
lean_object* v___x_220_; lean_object* v___x_221_; uint8_t v___x_222_; 
v___x_220_ = l_Lean_Expr_appFnCleanup___redArg(v___x_216_);
v___x_221_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__7));
v___x_222_ = l_Lean_Expr_isConstOf(v___x_220_, v___x_221_);
lean_dec_ref(v___x_220_);
if (v___x_222_ == 0)
{
lean_object* v___x_223_; lean_object* v___x_224_; 
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_arg_163_);
lean_dec_ref(v_e_129_);
v___x_223_ = lean_box(0);
v___x_224_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_223_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_224_;
goto v___jp_152_;
}
else
{
lean_object* v___x_225_; uint8_t v___x_226_; 
v___x_225_ = l_Lean_Expr_cleanupAnnotations(v_arg_163_);
v___x_226_ = l_Lean_Expr_isApp(v___x_225_);
if (v___x_226_ == 0)
{
lean_object* v___x_227_; lean_object* v___x_228_; 
lean_dec_ref(v___x_225_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_e_129_);
v___x_227_ = lean_box(0);
v___x_228_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_227_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_228_;
goto v___jp_152_;
}
else
{
lean_object* v_arg_229_; lean_object* v___x_230_; uint8_t v___x_231_; 
v_arg_229_ = lean_ctor_get(v___x_225_, 1);
lean_inc_ref(v_arg_229_);
v___x_230_ = l_Lean_Expr_appFnCleanup___redArg(v___x_225_);
v___x_231_ = l_Lean_Expr_isApp(v___x_230_);
if (v___x_231_ == 0)
{
lean_object* v___x_232_; lean_object* v___x_233_; 
lean_dec_ref(v___x_230_);
lean_dec_ref(v_arg_229_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_e_129_);
v___x_232_ = lean_box(0);
v___x_233_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_232_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_233_;
goto v___jp_152_;
}
else
{
lean_object* v_arg_234_; lean_object* v___x_235_; uint8_t v___x_236_; 
v_arg_234_ = lean_ctor_get(v___x_230_, 1);
lean_inc_ref(v_arg_234_);
v___x_235_ = l_Lean_Expr_appFnCleanup___redArg(v___x_230_);
v___x_236_ = l_Lean_Expr_isApp(v___x_235_);
if (v___x_236_ == 0)
{
lean_object* v___x_237_; lean_object* v___x_238_; 
lean_dec_ref(v___x_235_);
lean_dec_ref(v_arg_234_);
lean_dec_ref(v_arg_229_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_e_129_);
v___x_237_ = lean_box(0);
v___x_238_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_237_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_238_;
goto v___jp_152_;
}
else
{
lean_object* v___x_239_; uint8_t v___x_240_; 
v___x_239_ = l_Lean_Expr_appFnCleanup___redArg(v___x_235_);
v___x_240_ = l_Lean_Expr_isApp(v___x_239_);
if (v___x_240_ == 0)
{
lean_object* v___x_241_; lean_object* v___x_242_; 
lean_dec_ref(v___x_239_);
lean_dec_ref(v_arg_234_);
lean_dec_ref(v_arg_229_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_e_129_);
v___x_241_ = lean_box(0);
v___x_242_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_241_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_242_;
goto v___jp_152_;
}
else
{
lean_object* v___x_243_; uint8_t v___x_244_; 
v___x_243_ = l_Lean_Expr_appFnCleanup___redArg(v___x_239_);
v___x_244_ = l_Lean_Expr_isApp(v___x_243_);
if (v___x_244_ == 0)
{
lean_object* v___x_245_; lean_object* v___x_246_; 
lean_dec_ref(v___x_243_);
lean_dec_ref(v_arg_234_);
lean_dec_ref(v_arg_229_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_e_129_);
v___x_245_ = lean_box(0);
v___x_246_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_245_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_246_;
goto v___jp_152_;
}
else
{
lean_object* v___x_247_; uint8_t v___x_248_; 
v___x_247_ = l_Lean_Expr_appFnCleanup___redArg(v___x_243_);
v___x_248_ = l_Lean_Expr_isApp(v___x_247_);
if (v___x_248_ == 0)
{
lean_object* v___x_249_; lean_object* v___x_250_; 
lean_dec_ref(v___x_247_);
lean_dec_ref(v_arg_234_);
lean_dec_ref(v_arg_229_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_e_129_);
v___x_249_ = lean_box(0);
v___x_250_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_249_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_250_;
goto v___jp_152_;
}
else
{
lean_object* v___x_251_; uint8_t v___x_252_; 
v___x_251_ = l_Lean_Expr_appFnCleanup___redArg(v___x_247_);
v___x_252_ = l_Lean_Expr_isConstOf(v___x_251_, v___x_221_);
lean_dec_ref(v___x_251_);
if (v___x_252_ == 0)
{
lean_object* v___x_253_; lean_object* v___x_254_; 
lean_dec_ref(v_arg_234_);
lean_dec_ref(v_arg_229_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_e_129_);
v___x_253_ = lean_box(0);
v___x_254_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0(v___x_253_, v_a_130_, v_a_131_, v_a_132_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
v___y_153_ = v___x_254_;
goto v___jp_152_;
}
else
{
uint8_t v___x_255_; 
v___x_255_ = l___private_Lean_Meta_Sym_ExprPtr_0__Lean_Meta_Sym_isSameExpr_unsafe__1(v_arg_203_, v_arg_234_);
if (v___x_255_ == 0)
{
uint8_t v___x_256_; 
v___x_256_ = l___private_Lean_Meta_Sym_ExprPtr_0__Lean_Meta_Sym_isSameExpr_unsafe__1(v_arg_198_, v_arg_229_);
lean_dec_ref(v_arg_229_);
if (v___x_256_ == 0)
{
lean_dec_ref(v_arg_234_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
lean_dec_ref(v_arg_178_);
lean_dec_ref(v_arg_173_);
lean_dec_ref(v_e_129_);
v_contextDependent_148_ = v___x_256_;
goto v___jp_147_;
}
else
{
lean_object* v___x_257_; lean_object* v___x_258_; lean_object* v___x_259_; lean_object* v_condition1_260_; lean_object* v_condition2_261_; lean_object* v___x_262_; lean_object* v___x_263_; lean_object* v___x_264_; lean_object* v___x_265_; 
v___x_257_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__11, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__11_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__11);
v___x_258_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__14, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__14_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__14);
lean_inc_ref(v_arg_234_);
lean_inc_ref(v_arg_203_);
v___x_259_ = l_Lean_mkApp4(v___x_258_, v_arg_178_, v_arg_173_, v_arg_203_, v_arg_234_);
v_condition1_260_ = l_Lean_Expr_app___override(v___x_257_, v___x_259_);
v_condition2_261_ = l_Lean_Expr_app___override(v___x_257_, v_e_129_);
v___x_262_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__17, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__17_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__17);
v___x_263_ = l_Lean_mkAppB(v___x_262_, v_condition1_260_, v_condition2_261_);
v___x_264_ = l_Lean_Expr_app___override(v___x_257_, v___x_263_);
v___x_265_ = l_Lean_Meta_Sym_shareCommonInc(v___x_264_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
if (lean_obj_tag(v___x_265_) == 0)
{
lean_object* v_a_266_; lean_object* v___x_267_; lean_object* v___x_268_; 
v_a_266_ = lean_ctor_get(v___x_265_, 0);
lean_inc(v_a_266_);
lean_dec_ref_known(v___x_265_, 1);
v___x_267_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__24, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__24_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__24);
v___x_268_ = l_Lean_mkApp4(v___x_267_, v_arg_188_, v_arg_203_, v_arg_234_, v_arg_198_);
v_e_x27_141_ = v_a_266_;
v_proof_142_ = v___x_268_;
v_contextDependent_143_ = v___x_255_;
goto v___jp_140_;
}
else
{
lean_object* v_a_269_; lean_object* v___x_271_; uint8_t v_isShared_272_; uint8_t v_isSharedCheck_276_; 
lean_dec_ref(v_arg_234_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
v_a_269_ = lean_ctor_get(v___x_265_, 0);
v_isSharedCheck_276_ = !lean_is_exclusive(v___x_265_);
if (v_isSharedCheck_276_ == 0)
{
v___x_271_ = v___x_265_;
v_isShared_272_ = v_isSharedCheck_276_;
goto v_resetjp_270_;
}
else
{
lean_inc(v_a_269_);
lean_dec(v___x_265_);
v___x_271_ = lean_box(0);
v_isShared_272_ = v_isSharedCheck_276_;
goto v_resetjp_270_;
}
v_resetjp_270_:
{
lean_object* v___x_274_; 
if (v_isShared_272_ == 0)
{
v___x_274_ = v___x_271_;
goto v_reusejp_273_;
}
else
{
lean_object* v_reuseFailAlloc_275_; 
v_reuseFailAlloc_275_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_275_, 0, v_a_269_);
v___x_274_ = v_reuseFailAlloc_275_;
goto v_reusejp_273_;
}
v_reusejp_273_:
{
return v___x_274_;
}
}
}
}
}
else
{
lean_object* v___x_277_; lean_object* v___x_278_; lean_object* v___x_279_; lean_object* v_condition1_280_; lean_object* v_condition2_281_; lean_object* v___x_282_; lean_object* v___x_283_; lean_object* v___x_284_; lean_object* v___x_285_; 
lean_dec_ref(v_arg_234_);
v___x_277_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__11, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__11_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__11);
v___x_278_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__14, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__14_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__14);
lean_inc_ref(v_arg_229_);
lean_inc_ref(v_arg_198_);
v___x_279_ = l_Lean_mkApp4(v___x_278_, v_arg_178_, v_arg_173_, v_arg_198_, v_arg_229_);
v_condition1_280_ = l_Lean_Expr_app___override(v___x_277_, v___x_279_);
v_condition2_281_ = l_Lean_Expr_app___override(v___x_277_, v_e_129_);
v___x_282_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__17, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__17_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__17);
v___x_283_ = l_Lean_mkAppB(v___x_282_, v_condition1_280_, v_condition2_281_);
v___x_284_ = l_Lean_Expr_app___override(v___x_277_, v___x_283_);
v___x_285_ = l_Lean_Meta_Sym_shareCommonInc(v___x_284_, v_a_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_);
if (lean_obj_tag(v___x_285_) == 0)
{
lean_object* v_a_286_; lean_object* v___x_287_; lean_object* v___x_288_; uint8_t v___x_289_; 
v_a_286_ = lean_ctor_get(v___x_285_, 0);
lean_inc(v_a_286_);
lean_dec_ref_known(v___x_285_, 1);
v___x_287_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__27, &l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__27_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___closed__27);
v___x_288_ = l_Lean_mkApp4(v___x_287_, v_arg_188_, v_arg_203_, v_arg_198_, v_arg_229_);
v___x_289_ = 0;
v_e_x27_141_ = v_a_286_;
v_proof_142_ = v___x_288_;
v_contextDependent_143_ = v___x_289_;
goto v___jp_140_;
}
else
{
lean_object* v_a_290_; lean_object* v___x_292_; uint8_t v_isShared_293_; uint8_t v_isSharedCheck_297_; 
lean_dec_ref(v_arg_229_);
lean_dec_ref(v_arg_203_);
lean_dec_ref(v_arg_198_);
lean_dec_ref(v_arg_188_);
v_a_290_ = lean_ctor_get(v___x_285_, 0);
v_isSharedCheck_297_ = !lean_is_exclusive(v___x_285_);
if (v_isSharedCheck_297_ == 0)
{
v___x_292_ = v___x_285_;
v_isShared_293_ = v_isSharedCheck_297_;
goto v_resetjp_291_;
}
else
{
lean_inc(v_a_290_);
lean_dec(v___x_285_);
v___x_292_ = lean_box(0);
v_isShared_293_ = v_isSharedCheck_297_;
goto v_resetjp_291_;
}
v_resetjp_291_:
{
lean_object* v___x_295_; 
if (v_isShared_293_ == 0)
{
v___x_295_ = v___x_292_;
goto v_reusejp_294_;
}
else
{
lean_object* v_reuseFailAlloc_296_; 
v_reuseFailAlloc_296_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_296_, 0, v_a_290_);
v___x_295_ = v_reuseFailAlloc_296_;
goto v_reusejp_294_;
}
v_reusejp_294_:
{
return v___x_295_;
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
}
}
}
}
}
v___jp_140_:
{
uint8_t v___x_144_; lean_object* v___x_145_; lean_object* v___x_146_; 
v___x_144_ = 1;
v___x_145_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v___x_145_, 0, v_e_x27_141_);
lean_ctor_set(v___x_145_, 1, v_proof_142_);
lean_ctor_set_uint8(v___x_145_, sizeof(void*)*2, v___x_144_);
lean_ctor_set_uint8(v___x_145_, sizeof(void*)*2 + 1, v_contextDependent_143_);
v___x_146_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_146_, 0, v___x_145_);
return v___x_146_;
}
v___jp_147_:
{
uint8_t v___x_149_; lean_object* v___x_150_; lean_object* v___x_151_; 
v___x_149_ = 1;
v___x_150_ = lean_alloc_ctor(0, 0, 2);
lean_ctor_set_uint8(v___x_150_, 0, v___x_149_);
lean_ctor_set_uint8(v___x_150_, 1, v_contextDependent_148_);
v___x_151_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_151_, 0, v___x_150_);
return v___x_151_;
}
v___jp_152_:
{
lean_object* v_a_154_; 
v_a_154_ = lean_ctor_get(v___y_153_, 0);
lean_inc(v_a_154_);
lean_dec_ref(v___y_153_);
if (lean_obj_tag(v_a_154_) == 0)
{
uint8_t v_contextDependent_155_; 
v_contextDependent_155_ = lean_ctor_get_uint8(v_a_154_, 1);
lean_dec_ref_known(v_a_154_, 0);
v_contextDependent_148_ = v_contextDependent_155_;
goto v___jp_147_;
}
else
{
lean_object* v_e_x27_156_; lean_object* v_proof_157_; uint8_t v_contextDependent_158_; 
v_e_x27_156_ = lean_ctor_get(v_a_154_, 0);
lean_inc_ref(v_e_x27_156_);
v_proof_157_ = lean_ctor_get(v_a_154_, 1);
lean_inc_ref(v_proof_157_);
v_contextDependent_158_ = lean_ctor_get_uint8(v_a_154_, sizeof(void*)*2 + 1);
lean_dec_ref_known(v_a_154_, 2);
v_e_x27_141_ = v_e_x27_156_;
v_proof_142_ = v_proof_157_;
v_contextDependent_143_ = v_contextDependent_158_;
goto v___jp_140_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___boxed(lean_object* v_e_298_, lean_object* v_a_299_, lean_object* v_a_300_, lean_object* v_a_301_, lean_object* v_a_302_, lean_object* v_a_303_, lean_object* v_a_304_, lean_object* v_a_305_, lean_object* v_a_306_, lean_object* v_a_307_, lean_object* v_a_308_){
_start:
{
lean_object* v_res_309_; 
v_res_309_ = l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc(v_e_298_, v_a_299_, v_a_300_, v_a_301_, v_a_302_, v_a_303_, v_a_304_, v_a_305_, v_a_306_, v_a_307_);
lean_dec(v_a_307_);
lean_dec_ref(v_a_306_);
lean_dec(v_a_305_);
lean_dec_ref(v_a_304_);
lean_dec(v_a_303_);
lean_dec_ref(v_a_302_);
lean_dec(v_a_301_);
lean_dec_ref(v_a_300_);
lean_dec(v_a_299_);
return v_res_309_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg___lam__0(lean_object* v_x_310_, lean_object* v___y_311_, lean_object* v___y_312_, lean_object* v___y_313_, lean_object* v___y_314_, lean_object* v___y_315_, lean_object* v___y_316_, lean_object* v___y_317_, lean_object* v___y_318_){
_start:
{
lean_object* v___x_320_; 
lean_inc(v___y_314_);
lean_inc_ref(v___y_313_);
lean_inc(v___y_312_);
lean_inc_ref(v___y_311_);
v___x_320_ = lean_apply_9(v_x_310_, v___y_311_, v___y_312_, v___y_313_, v___y_314_, v___y_315_, v___y_316_, v___y_317_, v___y_318_, lean_box(0));
return v___x_320_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg___lam__0___boxed(lean_object* v_x_321_, lean_object* v___y_322_, lean_object* v___y_323_, lean_object* v___y_324_, lean_object* v___y_325_, lean_object* v___y_326_, lean_object* v___y_327_, lean_object* v___y_328_, lean_object* v___y_329_, lean_object* v___y_330_){
_start:
{
lean_object* v_res_331_; 
v_res_331_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg___lam__0(v_x_321_, v___y_322_, v___y_323_, v___y_324_, v___y_325_, v___y_326_, v___y_327_, v___y_328_, v___y_329_);
lean_dec(v___y_325_);
lean_dec_ref(v___y_324_);
lean_dec(v___y_323_);
lean_dec_ref(v___y_322_);
return v_res_331_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg(lean_object* v_mvarId_332_, lean_object* v_x_333_, lean_object* v___y_334_, lean_object* v___y_335_, lean_object* v___y_336_, lean_object* v___y_337_, lean_object* v___y_338_, lean_object* v___y_339_, lean_object* v___y_340_, lean_object* v___y_341_){
_start:
{
lean_object* v___f_343_; lean_object* v___x_344_; 
lean_inc(v___y_337_);
lean_inc_ref(v___y_336_);
lean_inc(v___y_335_);
lean_inc_ref(v___y_334_);
v___f_343_ = lean_alloc_closure((void*)(l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg___lam__0___boxed), 10, 5);
lean_closure_set(v___f_343_, 0, v_x_333_);
lean_closure_set(v___f_343_, 1, v___y_334_);
lean_closure_set(v___f_343_, 2, v___y_335_);
lean_closure_set(v___f_343_, 3, v___y_336_);
lean_closure_set(v___f_343_, 4, v___y_337_);
v___x_344_ = l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_box(0), v_mvarId_332_, v___f_343_, v___y_338_, v___y_339_, v___y_340_, v___y_341_);
if (lean_obj_tag(v___x_344_) == 0)
{
return v___x_344_;
}
else
{
lean_object* v_a_345_; lean_object* v___x_347_; uint8_t v_isShared_348_; uint8_t v_isSharedCheck_352_; 
v_a_345_ = lean_ctor_get(v___x_344_, 0);
v_isSharedCheck_352_ = !lean_is_exclusive(v___x_344_);
if (v_isSharedCheck_352_ == 0)
{
v___x_347_ = v___x_344_;
v_isShared_348_ = v_isSharedCheck_352_;
goto v_resetjp_346_;
}
else
{
lean_inc(v_a_345_);
lean_dec(v___x_344_);
v___x_347_ = lean_box(0);
v_isShared_348_ = v_isSharedCheck_352_;
goto v_resetjp_346_;
}
v_resetjp_346_:
{
lean_object* v___x_350_; 
if (v_isShared_348_ == 0)
{
v___x_350_ = v___x_347_;
goto v_reusejp_349_;
}
else
{
lean_object* v_reuseFailAlloc_351_; 
v_reuseFailAlloc_351_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_351_, 0, v_a_345_);
v___x_350_ = v_reuseFailAlloc_351_;
goto v_reusejp_349_;
}
v_reusejp_349_:
{
return v___x_350_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg___boxed(lean_object* v_mvarId_353_, lean_object* v_x_354_, lean_object* v___y_355_, lean_object* v___y_356_, lean_object* v___y_357_, lean_object* v___y_358_, lean_object* v___y_359_, lean_object* v___y_360_, lean_object* v___y_361_, lean_object* v___y_362_, lean_object* v___y_363_){
_start:
{
lean_object* v_res_364_; 
v_res_364_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg(v_mvarId_353_, v_x_354_, v___y_355_, v___y_356_, v___y_357_, v___y_358_, v___y_359_, v___y_360_, v___y_361_, v___y_362_);
lean_dec(v___y_362_);
lean_dec_ref(v___y_361_);
lean_dec(v___y_360_);
lean_dec_ref(v___y_359_);
lean_dec(v___y_358_);
lean_dec_ref(v___y_357_);
lean_dec(v___y_356_);
lean_dec_ref(v___y_355_);
return v_res_364_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3(lean_object* v_00_u03b1_365_, lean_object* v_mvarId_366_, lean_object* v_x_367_, lean_object* v___y_368_, lean_object* v___y_369_, lean_object* v___y_370_, lean_object* v___y_371_, lean_object* v___y_372_, lean_object* v___y_373_, lean_object* v___y_374_, lean_object* v___y_375_){
_start:
{
lean_object* v___x_377_; 
v___x_377_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg(v_mvarId_366_, v_x_367_, v___y_368_, v___y_369_, v___y_370_, v___y_371_, v___y_372_, v___y_373_, v___y_374_, v___y_375_);
return v___x_377_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___boxed(lean_object* v_00_u03b1_378_, lean_object* v_mvarId_379_, lean_object* v_x_380_, lean_object* v___y_381_, lean_object* v___y_382_, lean_object* v___y_383_, lean_object* v___y_384_, lean_object* v___y_385_, lean_object* v___y_386_, lean_object* v___y_387_, lean_object* v___y_388_, lean_object* v___y_389_){
_start:
{
lean_object* v_res_390_; 
v_res_390_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3(v_00_u03b1_378_, v_mvarId_379_, v_x_380_, v___y_381_, v___y_382_, v___y_383_, v___y_384_, v___y_385_, v___y_386_, v___y_387_, v___y_388_);
lean_dec(v___y_388_);
lean_dec_ref(v___y_387_);
lean_dec(v___y_386_);
lean_dec_ref(v___y_385_);
lean_dec(v___y_384_);
lean_dec_ref(v___y_383_);
lean_dec(v___y_382_);
lean_dec_ref(v___y_381_);
return v_res_390_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__3(lean_object* v___f_391_, lean_object* v_type_392_, lean_object* v_____r_393_, lean_object* v___y_394_, lean_object* v___y_395_, lean_object* v___y_396_, lean_object* v___y_397_, lean_object* v___y_398_, lean_object* v___y_399_, lean_object* v___y_400_, lean_object* v___y_401_){
_start:
{
lean_object* v___x_403_; uint8_t v_debug_404_; 
v___x_403_ = lean_st_ref_get(v___y_397_);
v_debug_404_ = lean_ctor_get_uint8(v___x_403_, sizeof(void*)*10);
lean_dec(v___x_403_);
if (v_debug_404_ == 0)
{
lean_object* v___x_405_; lean_object* v___x_406_; 
lean_dec_ref(v_type_392_);
v___x_405_ = lean_box(0);
lean_inc(v___y_401_);
lean_inc_ref(v___y_400_);
lean_inc(v___y_399_);
lean_inc_ref(v___y_398_);
lean_inc(v___y_397_);
lean_inc_ref(v___y_396_);
lean_inc(v___y_395_);
lean_inc_ref(v___y_394_);
v___x_406_ = lean_apply_10(v___f_391_, v___x_405_, v___y_394_, v___y_395_, v___y_396_, v___y_397_, v___y_398_, v___y_399_, v___y_400_, v___y_401_, lean_box(0));
return v___x_406_;
}
else
{
lean_object* v___x_407_; 
v___x_407_ = l_Lean_Meta_Sym_Internal_Sym_assertShared(v_type_392_, v___y_396_, v___y_397_, v___y_398_, v___y_399_, v___y_400_, v___y_401_);
if (lean_obj_tag(v___x_407_) == 0)
{
lean_object* v_a_408_; lean_object* v___x_409_; 
v_a_408_ = lean_ctor_get(v___x_407_, 0);
lean_inc(v_a_408_);
lean_dec_ref_known(v___x_407_, 1);
lean_inc(v___y_401_);
lean_inc_ref(v___y_400_);
lean_inc(v___y_399_);
lean_inc_ref(v___y_398_);
lean_inc(v___y_397_);
lean_inc_ref(v___y_396_);
lean_inc(v___y_395_);
lean_inc_ref(v___y_394_);
v___x_409_ = lean_apply_10(v___f_391_, v_a_408_, v___y_394_, v___y_395_, v___y_396_, v___y_397_, v___y_398_, v___y_399_, v___y_400_, v___y_401_, lean_box(0));
return v___x_409_;
}
else
{
lean_object* v_a_410_; lean_object* v___x_412_; uint8_t v_isShared_413_; uint8_t v_isSharedCheck_417_; 
lean_dec_ref(v___f_391_);
v_a_410_ = lean_ctor_get(v___x_407_, 0);
v_isSharedCheck_417_ = !lean_is_exclusive(v___x_407_);
if (v_isSharedCheck_417_ == 0)
{
v___x_412_ = v___x_407_;
v_isShared_413_ = v_isSharedCheck_417_;
goto v_resetjp_411_;
}
else
{
lean_inc(v_a_410_);
lean_dec(v___x_407_);
v___x_412_ = lean_box(0);
v_isShared_413_ = v_isSharedCheck_417_;
goto v_resetjp_411_;
}
v_resetjp_411_:
{
lean_object* v___x_415_; 
if (v_isShared_413_ == 0)
{
v___x_415_ = v___x_412_;
goto v_reusejp_414_;
}
else
{
lean_object* v_reuseFailAlloc_416_; 
v_reuseFailAlloc_416_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_416_, 0, v_a_410_);
v___x_415_ = v_reuseFailAlloc_416_;
goto v_reusejp_414_;
}
v_reusejp_414_:
{
return v___x_415_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__3___boxed(lean_object* v___f_418_, lean_object* v_type_419_, lean_object* v_____r_420_, lean_object* v___y_421_, lean_object* v___y_422_, lean_object* v___y_423_, lean_object* v___y_424_, lean_object* v___y_425_, lean_object* v___y_426_, lean_object* v___y_427_, lean_object* v___y_428_, lean_object* v___y_429_){
_start:
{
lean_object* v_res_430_; 
v_res_430_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__3(v___f_418_, v_type_419_, v_____r_420_, v___y_421_, v___y_422_, v___y_423_, v___y_424_, v___y_425_, v___y_426_, v___y_427_, v___y_428_);
lean_dec(v___y_428_);
lean_dec_ref(v___y_427_);
lean_dec(v___y_426_);
lean_dec_ref(v___y_425_);
lean_dec(v___y_424_);
lean_dec_ref(v___y_423_);
lean_dec(v___y_422_);
lean_dec_ref(v___y_421_);
return v_res_430_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(lean_object* v_x_431_, lean_object* v_x_432_, lean_object* v_x_433_, lean_object* v_x_434_){
_start:
{
lean_object* v_ks_435_; lean_object* v_vs_436_; lean_object* v___x_438_; uint8_t v_isShared_439_; uint8_t v_isSharedCheck_460_; 
v_ks_435_ = lean_ctor_get(v_x_431_, 0);
v_vs_436_ = lean_ctor_get(v_x_431_, 1);
v_isSharedCheck_460_ = !lean_is_exclusive(v_x_431_);
if (v_isSharedCheck_460_ == 0)
{
v___x_438_ = v_x_431_;
v_isShared_439_ = v_isSharedCheck_460_;
goto v_resetjp_437_;
}
else
{
lean_inc(v_vs_436_);
lean_inc(v_ks_435_);
lean_dec(v_x_431_);
v___x_438_ = lean_box(0);
v_isShared_439_ = v_isSharedCheck_460_;
goto v_resetjp_437_;
}
v_resetjp_437_:
{
lean_object* v___x_440_; uint8_t v___x_441_; 
v___x_440_ = lean_array_get_size(v_ks_435_);
v___x_441_ = lean_nat_dec_lt(v_x_432_, v___x_440_);
if (v___x_441_ == 0)
{
lean_object* v___x_442_; lean_object* v___x_443_; lean_object* v___x_445_; 
lean_dec(v_x_432_);
v___x_442_ = lean_array_push(v_ks_435_, v_x_433_);
v___x_443_ = lean_array_push(v_vs_436_, v_x_434_);
if (v_isShared_439_ == 0)
{
lean_ctor_set(v___x_438_, 1, v___x_443_);
lean_ctor_set(v___x_438_, 0, v___x_442_);
v___x_445_ = v___x_438_;
goto v_reusejp_444_;
}
else
{
lean_object* v_reuseFailAlloc_446_; 
v_reuseFailAlloc_446_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_446_, 0, v___x_442_);
lean_ctor_set(v_reuseFailAlloc_446_, 1, v___x_443_);
v___x_445_ = v_reuseFailAlloc_446_;
goto v_reusejp_444_;
}
v_reusejp_444_:
{
return v___x_445_;
}
}
else
{
lean_object* v_k_x27_447_; uint8_t v___x_448_; 
v_k_x27_447_ = lean_array_fget_borrowed(v_ks_435_, v_x_432_);
v___x_448_ = l_Lean_instBEqMVarId_beq(v_x_433_, v_k_x27_447_);
if (v___x_448_ == 0)
{
lean_object* v___x_450_; 
if (v_isShared_439_ == 0)
{
v___x_450_ = v___x_438_;
goto v_reusejp_449_;
}
else
{
lean_object* v_reuseFailAlloc_454_; 
v_reuseFailAlloc_454_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_454_, 0, v_ks_435_);
lean_ctor_set(v_reuseFailAlloc_454_, 1, v_vs_436_);
v___x_450_ = v_reuseFailAlloc_454_;
goto v_reusejp_449_;
}
v_reusejp_449_:
{
lean_object* v___x_451_; lean_object* v___x_452_; 
v___x_451_ = lean_unsigned_to_nat(1u);
v___x_452_ = lean_nat_add(v_x_432_, v___x_451_);
lean_dec(v_x_432_);
v_x_431_ = v___x_450_;
v_x_432_ = v___x_452_;
goto _start;
}
}
else
{
lean_object* v___x_455_; lean_object* v___x_456_; lean_object* v___x_458_; 
v___x_455_ = lean_array_fset(v_ks_435_, v_x_432_, v_x_433_);
v___x_456_ = lean_array_fset(v_vs_436_, v_x_432_, v_x_434_);
lean_dec(v_x_432_);
if (v_isShared_439_ == 0)
{
lean_ctor_set(v___x_438_, 1, v___x_456_);
lean_ctor_set(v___x_438_, 0, v___x_455_);
v___x_458_ = v___x_438_;
goto v_reusejp_457_;
}
else
{
lean_object* v_reuseFailAlloc_459_; 
v_reuseFailAlloc_459_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_459_, 0, v___x_455_);
lean_ctor_set(v_reuseFailAlloc_459_, 1, v___x_456_);
v___x_458_ = v_reuseFailAlloc_459_;
goto v_reusejp_457_;
}
v_reusejp_457_:
{
return v___x_458_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6___redArg(lean_object* v_n_461_, lean_object* v_k_462_, lean_object* v_v_463_){
_start:
{
lean_object* v___x_464_; lean_object* v___x_465_; 
v___x_464_ = lean_unsigned_to_nat(0u);
v___x_465_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(v_n_461_, v___x_464_, v_k_462_, v_v_463_);
return v___x_465_;
}
}
static lean_object* _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg___closed__0(void){
_start:
{
lean_object* v___x_466_; 
v___x_466_ = l_Lean_PersistentHashMap_mkEmptyEntries(lean_box(0), lean_box(0));
return v___x_466_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg(lean_object* v_x_467_, size_t v_x_468_, size_t v_x_469_, lean_object* v_x_470_, lean_object* v_x_471_){
_start:
{
if (lean_obj_tag(v_x_467_) == 0)
{
lean_object* v_es_472_; size_t v___x_473_; size_t v___x_474_; lean_object* v_j_475_; lean_object* v___x_476_; uint8_t v___x_477_; 
v_es_472_ = lean_ctor_get(v_x_467_, 0);
v___x_473_ = ((size_t)31ULL);
v___x_474_ = lean_usize_land(v_x_468_, v___x_473_);
v_j_475_ = lean_usize_to_nat(v___x_474_);
v___x_476_ = lean_array_get_size(v_es_472_);
v___x_477_ = lean_nat_dec_lt(v_j_475_, v___x_476_);
if (v___x_477_ == 0)
{
lean_dec(v_j_475_);
lean_dec(v_x_471_);
lean_dec(v_x_470_);
return v_x_467_;
}
else
{
lean_object* v___x_479_; uint8_t v_isShared_480_; uint8_t v_isSharedCheck_516_; 
lean_inc_ref(v_es_472_);
v_isSharedCheck_516_ = !lean_is_exclusive(v_x_467_);
if (v_isSharedCheck_516_ == 0)
{
lean_object* v_unused_517_; 
v_unused_517_ = lean_ctor_get(v_x_467_, 0);
lean_dec(v_unused_517_);
v___x_479_ = v_x_467_;
v_isShared_480_ = v_isSharedCheck_516_;
goto v_resetjp_478_;
}
else
{
lean_dec(v_x_467_);
v___x_479_ = lean_box(0);
v_isShared_480_ = v_isSharedCheck_516_;
goto v_resetjp_478_;
}
v_resetjp_478_:
{
lean_object* v_v_481_; lean_object* v___x_482_; lean_object* v_xs_x27_483_; lean_object* v___y_485_; 
v_v_481_ = lean_array_fget(v_es_472_, v_j_475_);
v___x_482_ = lean_box(0);
v_xs_x27_483_ = lean_array_fset(v_es_472_, v_j_475_, v___x_482_);
switch(lean_obj_tag(v_v_481_))
{
case 0:
{
lean_object* v_key_490_; lean_object* v_val_491_; lean_object* v___x_493_; uint8_t v_isShared_494_; uint8_t v_isSharedCheck_501_; 
v_key_490_ = lean_ctor_get(v_v_481_, 0);
v_val_491_ = lean_ctor_get(v_v_481_, 1);
v_isSharedCheck_501_ = !lean_is_exclusive(v_v_481_);
if (v_isSharedCheck_501_ == 0)
{
v___x_493_ = v_v_481_;
v_isShared_494_ = v_isSharedCheck_501_;
goto v_resetjp_492_;
}
else
{
lean_inc(v_val_491_);
lean_inc(v_key_490_);
lean_dec(v_v_481_);
v___x_493_ = lean_box(0);
v_isShared_494_ = v_isSharedCheck_501_;
goto v_resetjp_492_;
}
v_resetjp_492_:
{
uint8_t v___x_495_; 
v___x_495_ = l_Lean_instBEqMVarId_beq(v_x_470_, v_key_490_);
if (v___x_495_ == 0)
{
lean_object* v___x_496_; lean_object* v___x_497_; 
lean_del_object(v___x_493_);
v___x_496_ = l_Lean_PersistentHashMap_mkCollisionNode___redArg(v_key_490_, v_val_491_, v_x_470_, v_x_471_);
v___x_497_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_497_, 0, v___x_496_);
v___y_485_ = v___x_497_;
goto v___jp_484_;
}
else
{
lean_object* v___x_499_; 
lean_dec(v_val_491_);
lean_dec(v_key_490_);
if (v_isShared_494_ == 0)
{
lean_ctor_set(v___x_493_, 1, v_x_471_);
lean_ctor_set(v___x_493_, 0, v_x_470_);
v___x_499_ = v___x_493_;
goto v_reusejp_498_;
}
else
{
lean_object* v_reuseFailAlloc_500_; 
v_reuseFailAlloc_500_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_500_, 0, v_x_470_);
lean_ctor_set(v_reuseFailAlloc_500_, 1, v_x_471_);
v___x_499_ = v_reuseFailAlloc_500_;
goto v_reusejp_498_;
}
v_reusejp_498_:
{
v___y_485_ = v___x_499_;
goto v___jp_484_;
}
}
}
}
case 1:
{
lean_object* v_node_502_; lean_object* v___x_504_; uint8_t v_isShared_505_; uint8_t v_isSharedCheck_514_; 
v_node_502_ = lean_ctor_get(v_v_481_, 0);
v_isSharedCheck_514_ = !lean_is_exclusive(v_v_481_);
if (v_isSharedCheck_514_ == 0)
{
v___x_504_ = v_v_481_;
v_isShared_505_ = v_isSharedCheck_514_;
goto v_resetjp_503_;
}
else
{
lean_inc(v_node_502_);
lean_dec(v_v_481_);
v___x_504_ = lean_box(0);
v_isShared_505_ = v_isSharedCheck_514_;
goto v_resetjp_503_;
}
v_resetjp_503_:
{
size_t v___x_506_; size_t v___x_507_; size_t v___x_508_; size_t v___x_509_; lean_object* v___x_510_; lean_object* v___x_512_; 
v___x_506_ = ((size_t)5ULL);
v___x_507_ = lean_usize_shift_right(v_x_468_, v___x_506_);
v___x_508_ = ((size_t)1ULL);
v___x_509_ = lean_usize_add(v_x_469_, v___x_508_);
v___x_510_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg(v_node_502_, v___x_507_, v___x_509_, v_x_470_, v_x_471_);
if (v_isShared_505_ == 0)
{
lean_ctor_set(v___x_504_, 0, v___x_510_);
v___x_512_ = v___x_504_;
goto v_reusejp_511_;
}
else
{
lean_object* v_reuseFailAlloc_513_; 
v_reuseFailAlloc_513_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_513_, 0, v___x_510_);
v___x_512_ = v_reuseFailAlloc_513_;
goto v_reusejp_511_;
}
v_reusejp_511_:
{
v___y_485_ = v___x_512_;
goto v___jp_484_;
}
}
}
default: 
{
lean_object* v___x_515_; 
v___x_515_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_515_, 0, v_x_470_);
lean_ctor_set(v___x_515_, 1, v_x_471_);
v___y_485_ = v___x_515_;
goto v___jp_484_;
}
}
v___jp_484_:
{
lean_object* v___x_486_; lean_object* v___x_488_; 
v___x_486_ = lean_array_fset(v_xs_x27_483_, v_j_475_, v___y_485_);
lean_dec(v_j_475_);
if (v_isShared_480_ == 0)
{
lean_ctor_set(v___x_479_, 0, v___x_486_);
v___x_488_ = v___x_479_;
goto v_reusejp_487_;
}
else
{
lean_object* v_reuseFailAlloc_489_; 
v_reuseFailAlloc_489_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_489_, 0, v___x_486_);
v___x_488_ = v_reuseFailAlloc_489_;
goto v_reusejp_487_;
}
v_reusejp_487_:
{
return v___x_488_;
}
}
}
}
}
else
{
lean_object* v_ks_518_; lean_object* v_vs_519_; lean_object* v___x_521_; uint8_t v_isShared_522_; uint8_t v_isSharedCheck_539_; 
v_ks_518_ = lean_ctor_get(v_x_467_, 0);
v_vs_519_ = lean_ctor_get(v_x_467_, 1);
v_isSharedCheck_539_ = !lean_is_exclusive(v_x_467_);
if (v_isSharedCheck_539_ == 0)
{
v___x_521_ = v_x_467_;
v_isShared_522_ = v_isSharedCheck_539_;
goto v_resetjp_520_;
}
else
{
lean_inc(v_vs_519_);
lean_inc(v_ks_518_);
lean_dec(v_x_467_);
v___x_521_ = lean_box(0);
v_isShared_522_ = v_isSharedCheck_539_;
goto v_resetjp_520_;
}
v_resetjp_520_:
{
lean_object* v___x_524_; 
if (v_isShared_522_ == 0)
{
v___x_524_ = v___x_521_;
goto v_reusejp_523_;
}
else
{
lean_object* v_reuseFailAlloc_538_; 
v_reuseFailAlloc_538_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_538_, 0, v_ks_518_);
lean_ctor_set(v_reuseFailAlloc_538_, 1, v_vs_519_);
v___x_524_ = v_reuseFailAlloc_538_;
goto v_reusejp_523_;
}
v_reusejp_523_:
{
lean_object* v_newNode_525_; uint8_t v___y_527_; size_t v___x_533_; uint8_t v___x_534_; 
v_newNode_525_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6___redArg(v___x_524_, v_x_470_, v_x_471_);
v___x_533_ = ((size_t)7ULL);
v___x_534_ = lean_usize_dec_le(v___x_533_, v_x_469_);
if (v___x_534_ == 0)
{
lean_object* v___x_535_; lean_object* v___x_536_; uint8_t v___x_537_; 
v___x_535_ = l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(v_newNode_525_);
v___x_536_ = lean_unsigned_to_nat(4u);
v___x_537_ = lean_nat_dec_lt(v___x_535_, v___x_536_);
lean_dec(v___x_535_);
v___y_527_ = v___x_537_;
goto v___jp_526_;
}
else
{
v___y_527_ = v___x_534_;
goto v___jp_526_;
}
v___jp_526_:
{
if (v___y_527_ == 0)
{
lean_object* v_ks_528_; lean_object* v_vs_529_; lean_object* v___x_530_; lean_object* v___x_531_; lean_object* v___x_532_; 
v_ks_528_ = lean_ctor_get(v_newNode_525_, 0);
lean_inc_ref(v_ks_528_);
v_vs_529_ = lean_ctor_get(v_newNode_525_, 1);
lean_inc_ref(v_vs_529_);
lean_dec_ref(v_newNode_525_);
v___x_530_ = lean_unsigned_to_nat(0u);
v___x_531_ = lean_obj_once(&l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg___closed__0, &l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg___closed__0_once, _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg___closed__0);
v___x_532_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7___redArg(v_x_469_, v_ks_528_, v_vs_529_, v___x_530_, v___x_531_);
lean_dec_ref(v_vs_529_);
lean_dec_ref(v_ks_528_);
return v___x_532_;
}
else
{
return v_newNode_525_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7___redArg(size_t v_depth_540_, lean_object* v_keys_541_, lean_object* v_vals_542_, lean_object* v_i_543_, lean_object* v_entries_544_){
_start:
{
lean_object* v___x_545_; uint8_t v___x_546_; 
v___x_545_ = lean_array_get_size(v_keys_541_);
v___x_546_ = lean_nat_dec_lt(v_i_543_, v___x_545_);
if (v___x_546_ == 0)
{
lean_dec(v_i_543_);
return v_entries_544_;
}
else
{
lean_object* v_k_547_; lean_object* v_v_548_; uint64_t v___x_549_; size_t v_h_550_; size_t v___x_551_; lean_object* v___x_552_; size_t v___x_553_; size_t v___x_554_; size_t v___x_555_; size_t v_h_556_; lean_object* v___x_557_; lean_object* v___x_558_; 
v_k_547_ = lean_array_fget_borrowed(v_keys_541_, v_i_543_);
v_v_548_ = lean_array_fget_borrowed(v_vals_542_, v_i_543_);
v___x_549_ = l_Lean_instHashableMVarId_hash(v_k_547_);
v_h_550_ = lean_uint64_to_usize(v___x_549_);
v___x_551_ = ((size_t)5ULL);
v___x_552_ = lean_unsigned_to_nat(1u);
v___x_553_ = ((size_t)1ULL);
v___x_554_ = lean_usize_sub(v_depth_540_, v___x_553_);
v___x_555_ = lean_usize_mul(v___x_551_, v___x_554_);
v_h_556_ = lean_usize_shift_right(v_h_550_, v___x_555_);
v___x_557_ = lean_nat_add(v_i_543_, v___x_552_);
lean_dec(v_i_543_);
lean_inc(v_v_548_);
lean_inc(v_k_547_);
v___x_558_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg(v_entries_544_, v_h_556_, v_depth_540_, v_k_547_, v_v_548_);
v_i_543_ = v___x_557_;
v_entries_544_ = v___x_558_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7___redArg___boxed(lean_object* v_depth_560_, lean_object* v_keys_561_, lean_object* v_vals_562_, lean_object* v_i_563_, lean_object* v_entries_564_){
_start:
{
size_t v_depth_boxed_565_; lean_object* v_res_566_; 
v_depth_boxed_565_ = lean_unbox_usize(v_depth_560_);
lean_dec(v_depth_560_);
v_res_566_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7___redArg(v_depth_boxed_565_, v_keys_561_, v_vals_562_, v_i_563_, v_entries_564_);
lean_dec_ref(v_vals_562_);
lean_dec_ref(v_keys_561_);
return v_res_566_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg___boxed(lean_object* v_x_567_, lean_object* v_x_568_, lean_object* v_x_569_, lean_object* v_x_570_, lean_object* v_x_571_){
_start:
{
size_t v_x_23622__boxed_572_; size_t v_x_23623__boxed_573_; lean_object* v_res_574_; 
v_x_23622__boxed_572_ = lean_unbox_usize(v_x_568_);
lean_dec(v_x_568_);
v_x_23623__boxed_573_ = lean_unbox_usize(v_x_569_);
lean_dec(v_x_569_);
v_res_574_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg(v_x_567_, v_x_23622__boxed_572_, v_x_23623__boxed_573_, v_x_570_, v_x_571_);
return v_res_574_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2___redArg(lean_object* v_x_575_, lean_object* v_x_576_, lean_object* v_x_577_){
_start:
{
uint64_t v___x_578_; size_t v___x_579_; size_t v___x_580_; lean_object* v___x_581_; 
v___x_578_ = l_Lean_instHashableMVarId_hash(v_x_576_);
v___x_579_ = lean_uint64_to_usize(v___x_578_);
v___x_580_ = ((size_t)1ULL);
v___x_581_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg(v_x_575_, v___x_579_, v___x_580_, v_x_576_, v_x_577_);
return v___x_581_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1___redArg(lean_object* v_mvarId_582_, lean_object* v_val_583_, lean_object* v___y_584_){
_start:
{
lean_object* v___x_586_; lean_object* v_mctx_587_; lean_object* v_cache_588_; lean_object* v_zetaDeltaFVarIds_589_; lean_object* v_postponed_590_; lean_object* v_diag_591_; lean_object* v___x_593_; uint8_t v_isShared_594_; uint8_t v_isSharedCheck_619_; 
v___x_586_ = lean_st_ref_take(v___y_584_);
v_mctx_587_ = lean_ctor_get(v___x_586_, 0);
v_cache_588_ = lean_ctor_get(v___x_586_, 1);
v_zetaDeltaFVarIds_589_ = lean_ctor_get(v___x_586_, 2);
v_postponed_590_ = lean_ctor_get(v___x_586_, 3);
v_diag_591_ = lean_ctor_get(v___x_586_, 4);
v_isSharedCheck_619_ = !lean_is_exclusive(v___x_586_);
if (v_isSharedCheck_619_ == 0)
{
v___x_593_ = v___x_586_;
v_isShared_594_ = v_isSharedCheck_619_;
goto v_resetjp_592_;
}
else
{
lean_inc(v_diag_591_);
lean_inc(v_postponed_590_);
lean_inc(v_zetaDeltaFVarIds_589_);
lean_inc(v_cache_588_);
lean_inc(v_mctx_587_);
lean_dec(v___x_586_);
v___x_593_ = lean_box(0);
v_isShared_594_ = v_isSharedCheck_619_;
goto v_resetjp_592_;
}
v_resetjp_592_:
{
lean_object* v_depth_595_; lean_object* v_levelAssignDepth_596_; lean_object* v_lmvarCounter_597_; lean_object* v_mvarCounter_598_; lean_object* v_lDecls_599_; lean_object* v_decls_600_; lean_object* v_userNames_601_; lean_object* v_lAssignment_602_; lean_object* v_eAssignment_603_; lean_object* v_dAssignment_604_; lean_object* v___x_606_; uint8_t v_isShared_607_; uint8_t v_isSharedCheck_618_; 
v_depth_595_ = lean_ctor_get(v_mctx_587_, 0);
v_levelAssignDepth_596_ = lean_ctor_get(v_mctx_587_, 1);
v_lmvarCounter_597_ = lean_ctor_get(v_mctx_587_, 2);
v_mvarCounter_598_ = lean_ctor_get(v_mctx_587_, 3);
v_lDecls_599_ = lean_ctor_get(v_mctx_587_, 4);
v_decls_600_ = lean_ctor_get(v_mctx_587_, 5);
v_userNames_601_ = lean_ctor_get(v_mctx_587_, 6);
v_lAssignment_602_ = lean_ctor_get(v_mctx_587_, 7);
v_eAssignment_603_ = lean_ctor_get(v_mctx_587_, 8);
v_dAssignment_604_ = lean_ctor_get(v_mctx_587_, 9);
v_isSharedCheck_618_ = !lean_is_exclusive(v_mctx_587_);
if (v_isSharedCheck_618_ == 0)
{
v___x_606_ = v_mctx_587_;
v_isShared_607_ = v_isSharedCheck_618_;
goto v_resetjp_605_;
}
else
{
lean_inc(v_dAssignment_604_);
lean_inc(v_eAssignment_603_);
lean_inc(v_lAssignment_602_);
lean_inc(v_userNames_601_);
lean_inc(v_decls_600_);
lean_inc(v_lDecls_599_);
lean_inc(v_mvarCounter_598_);
lean_inc(v_lmvarCounter_597_);
lean_inc(v_levelAssignDepth_596_);
lean_inc(v_depth_595_);
lean_dec(v_mctx_587_);
v___x_606_ = lean_box(0);
v_isShared_607_ = v_isSharedCheck_618_;
goto v_resetjp_605_;
}
v_resetjp_605_:
{
lean_object* v___x_608_; lean_object* v___x_610_; 
v___x_608_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2___redArg(v_eAssignment_603_, v_mvarId_582_, v_val_583_);
if (v_isShared_607_ == 0)
{
lean_ctor_set(v___x_606_, 8, v___x_608_);
v___x_610_ = v___x_606_;
goto v_reusejp_609_;
}
else
{
lean_object* v_reuseFailAlloc_617_; 
v_reuseFailAlloc_617_ = lean_alloc_ctor(0, 10, 0);
lean_ctor_set(v_reuseFailAlloc_617_, 0, v_depth_595_);
lean_ctor_set(v_reuseFailAlloc_617_, 1, v_levelAssignDepth_596_);
lean_ctor_set(v_reuseFailAlloc_617_, 2, v_lmvarCounter_597_);
lean_ctor_set(v_reuseFailAlloc_617_, 3, v_mvarCounter_598_);
lean_ctor_set(v_reuseFailAlloc_617_, 4, v_lDecls_599_);
lean_ctor_set(v_reuseFailAlloc_617_, 5, v_decls_600_);
lean_ctor_set(v_reuseFailAlloc_617_, 6, v_userNames_601_);
lean_ctor_set(v_reuseFailAlloc_617_, 7, v_lAssignment_602_);
lean_ctor_set(v_reuseFailAlloc_617_, 8, v___x_608_);
lean_ctor_set(v_reuseFailAlloc_617_, 9, v_dAssignment_604_);
v___x_610_ = v_reuseFailAlloc_617_;
goto v_reusejp_609_;
}
v_reusejp_609_:
{
lean_object* v___x_612_; 
if (v_isShared_594_ == 0)
{
lean_ctor_set(v___x_593_, 0, v___x_610_);
v___x_612_ = v___x_593_;
goto v_reusejp_611_;
}
else
{
lean_object* v_reuseFailAlloc_616_; 
v_reuseFailAlloc_616_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_616_, 0, v___x_610_);
lean_ctor_set(v_reuseFailAlloc_616_, 1, v_cache_588_);
lean_ctor_set(v_reuseFailAlloc_616_, 2, v_zetaDeltaFVarIds_589_);
lean_ctor_set(v_reuseFailAlloc_616_, 3, v_postponed_590_);
lean_ctor_set(v_reuseFailAlloc_616_, 4, v_diag_591_);
v___x_612_ = v_reuseFailAlloc_616_;
goto v_reusejp_611_;
}
v_reusejp_611_:
{
lean_object* v___x_613_; lean_object* v___x_614_; lean_object* v___x_615_; 
v___x_613_ = lean_st_ref_set(v___y_584_, v___x_612_);
v___x_614_ = lean_box(0);
v___x_615_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_615_, 0, v___x_614_);
return v___x_615_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1___redArg___boxed(lean_object* v_mvarId_620_, lean_object* v_val_621_, lean_object* v___y_622_, lean_object* v___y_623_){
_start:
{
lean_object* v_res_624_; 
v_res_624_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1___redArg(v_mvarId_620_, v_val_621_, v___y_622_);
lean_dec(v___y_622_);
return v_res_624_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__2(uint8_t v___x_625_, lean_object* v___f_626_, lean_object* v_____r_627_, lean_object* v___y_628_, lean_object* v___y_629_, lean_object* v___y_630_, lean_object* v___y_631_, lean_object* v___y_632_, lean_object* v___y_633_, lean_object* v___y_634_, lean_object* v___y_635_){
_start:
{
lean_object* v___x_637_; lean_object* v_rewriteCache_638_; lean_object* v_acNfCache_639_; lean_object* v_typeAnalysis_640_; lean_object* v_goal_641_; lean_object* v_hypotheses_642_; lean_object* v___x_644_; uint8_t v_isShared_645_; uint8_t v_isSharedCheck_652_; 
v___x_637_ = lean_st_ref_take(v___y_629_);
v_rewriteCache_638_ = lean_ctor_get(v___x_637_, 0);
v_acNfCache_639_ = lean_ctor_get(v___x_637_, 1);
v_typeAnalysis_640_ = lean_ctor_get(v___x_637_, 2);
v_goal_641_ = lean_ctor_get(v___x_637_, 3);
v_hypotheses_642_ = lean_ctor_get(v___x_637_, 4);
v_isSharedCheck_652_ = !lean_is_exclusive(v___x_637_);
if (v_isSharedCheck_652_ == 0)
{
v___x_644_ = v___x_637_;
v_isShared_645_ = v_isSharedCheck_652_;
goto v_resetjp_643_;
}
else
{
lean_inc(v_hypotheses_642_);
lean_inc(v_goal_641_);
lean_inc(v_typeAnalysis_640_);
lean_inc(v_acNfCache_639_);
lean_inc(v_rewriteCache_638_);
lean_dec(v___x_637_);
v___x_644_ = lean_box(0);
v_isShared_645_ = v_isSharedCheck_652_;
goto v_resetjp_643_;
}
v_resetjp_643_:
{
lean_object* v___x_647_; 
if (v_isShared_645_ == 0)
{
v___x_647_ = v___x_644_;
goto v_reusejp_646_;
}
else
{
lean_object* v_reuseFailAlloc_651_; 
v_reuseFailAlloc_651_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_651_, 0, v_rewriteCache_638_);
lean_ctor_set(v_reuseFailAlloc_651_, 1, v_acNfCache_639_);
lean_ctor_set(v_reuseFailAlloc_651_, 2, v_typeAnalysis_640_);
lean_ctor_set(v_reuseFailAlloc_651_, 3, v_goal_641_);
lean_ctor_set(v_reuseFailAlloc_651_, 4, v_hypotheses_642_);
v___x_647_ = v_reuseFailAlloc_651_;
goto v_reusejp_646_;
}
v_reusejp_646_:
{
lean_object* v___x_648_; lean_object* v___x_649_; lean_object* v___x_650_; 
lean_ctor_set_uint8(v___x_647_, sizeof(void*)*5, v___x_625_);
v___x_648_ = lean_st_ref_set(v___y_629_, v___x_647_);
v___x_649_ = lean_box(0);
lean_inc(v___y_635_);
lean_inc_ref(v___y_634_);
lean_inc(v___y_633_);
lean_inc_ref(v___y_632_);
lean_inc(v___y_631_);
lean_inc_ref(v___y_630_);
lean_inc(v___y_629_);
lean_inc_ref(v___y_628_);
v___x_650_ = lean_apply_10(v___f_626_, v___x_649_, v___y_628_, v___y_629_, v___y_630_, v___y_631_, v___y_632_, v___y_633_, v___y_634_, v___y_635_, lean_box(0));
return v___x_650_;
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__2___boxed(lean_object* v___x_653_, lean_object* v___f_654_, lean_object* v_____r_655_, lean_object* v___y_656_, lean_object* v___y_657_, lean_object* v___y_658_, lean_object* v___y_659_, lean_object* v___y_660_, lean_object* v___y_661_, lean_object* v___y_662_, lean_object* v___y_663_, lean_object* v___y_664_){
_start:
{
uint8_t v___x_23835__boxed_665_; lean_object* v_res_666_; 
v___x_23835__boxed_665_ = lean_unbox(v___x_653_);
v_res_666_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__2(v___x_23835__boxed_665_, v___f_654_, v_____r_655_, v___y_656_, v___y_657_, v___y_658_, v___y_659_, v___y_660_, v___y_661_, v___y_662_, v___y_663_);
lean_dec(v___y_663_);
lean_dec_ref(v___y_662_);
lean_dec(v___y_661_);
lean_dec_ref(v___y_660_);
lean_dec(v___y_659_);
lean_dec_ref(v___y_658_);
lean_dec(v___y_657_);
lean_dec_ref(v___y_656_);
return v_res_666_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__1(lean_object* v_snd_667_, lean_object* v_a_668_, lean_object* v___x_669_, lean_object* v_____r_670_, lean_object* v___y_671_, lean_object* v___y_672_, lean_object* v___y_673_, lean_object* v___y_674_, lean_object* v___y_675_, lean_object* v___y_676_, lean_object* v___y_677_, lean_object* v___y_678_){
_start:
{
lean_object* v___x_680_; lean_object* v___x_681_; lean_object* v___x_682_; lean_object* v___x_683_; 
v___x_680_ = lean_array_push(v_snd_667_, v_a_668_);
v___x_681_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_681_, 0, v___x_669_);
lean_ctor_set(v___x_681_, 1, v___x_680_);
v___x_682_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_682_, 0, v___x_681_);
v___x_683_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_683_, 0, v___x_682_);
return v___x_683_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__1___boxed(lean_object* v_snd_684_, lean_object* v_a_685_, lean_object* v___x_686_, lean_object* v_____r_687_, lean_object* v___y_688_, lean_object* v___y_689_, lean_object* v___y_690_, lean_object* v___y_691_, lean_object* v___y_692_, lean_object* v___y_693_, lean_object* v___y_694_, lean_object* v___y_695_, lean_object* v___y_696_){
_start:
{
lean_object* v_res_697_; 
v_res_697_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__1(v_snd_684_, v_a_685_, v___x_686_, v_____r_687_, v___y_688_, v___y_689_, v___y_690_, v___y_691_, v___y_692_, v___y_693_, v___y_694_, v___y_695_);
lean_dec(v___y_695_);
lean_dec_ref(v___y_694_);
lean_dec(v___y_693_);
lean_dec_ref(v___y_692_);
lean_dec(v___y_691_);
lean_dec_ref(v___y_690_);
lean_dec(v___y_689_);
lean_dec_ref(v___y_688_);
return v_res_697_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0_spec__0(lean_object* v_msgData_698_, lean_object* v___y_699_, lean_object* v___y_700_, lean_object* v___y_701_, lean_object* v___y_702_){
_start:
{
lean_object* v___x_704_; lean_object* v_env_705_; lean_object* v___x_706_; lean_object* v_mctx_707_; lean_object* v_lctx_708_; lean_object* v_options_709_; lean_object* v___x_710_; lean_object* v___x_711_; lean_object* v___x_712_; 
v___x_704_ = lean_st_ref_get(v___y_702_);
v_env_705_ = lean_ctor_get(v___x_704_, 0);
lean_inc_ref(v_env_705_);
lean_dec(v___x_704_);
v___x_706_ = lean_st_ref_get(v___y_700_);
v_mctx_707_ = lean_ctor_get(v___x_706_, 0);
lean_inc_ref(v_mctx_707_);
lean_dec(v___x_706_);
v_lctx_708_ = lean_ctor_get(v___y_699_, 2);
v_options_709_ = lean_ctor_get(v___y_701_, 2);
lean_inc_ref(v_options_709_);
lean_inc_ref(v_lctx_708_);
v___x_710_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_710_, 0, v_env_705_);
lean_ctor_set(v___x_710_, 1, v_mctx_707_);
lean_ctor_set(v___x_710_, 2, v_lctx_708_);
lean_ctor_set(v___x_710_, 3, v_options_709_);
v___x_711_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v___x_711_, 0, v___x_710_);
lean_ctor_set(v___x_711_, 1, v_msgData_698_);
v___x_712_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_712_, 0, v___x_711_);
return v___x_712_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0_spec__0___boxed(lean_object* v_msgData_713_, lean_object* v___y_714_, lean_object* v___y_715_, lean_object* v___y_716_, lean_object* v___y_717_, lean_object* v___y_718_){
_start:
{
lean_object* v_res_719_; 
v_res_719_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0_spec__0(v_msgData_713_, v___y_714_, v___y_715_, v___y_716_, v___y_717_);
lean_dec(v___y_717_);
lean_dec_ref(v___y_716_);
lean_dec(v___y_715_);
lean_dec_ref(v___y_714_);
return v_res_719_;
}
}
static double _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__0(void){
_start:
{
lean_object* v___x_720_; double v___x_721_; 
v___x_720_ = lean_unsigned_to_nat(0u);
v___x_721_ = lean_float_of_nat(v___x_720_);
return v___x_721_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg(lean_object* v_cls_725_, lean_object* v_msg_726_, lean_object* v___y_727_, lean_object* v___y_728_, lean_object* v___y_729_, lean_object* v___y_730_){
_start:
{
lean_object* v_ref_732_; lean_object* v___x_733_; lean_object* v_a_734_; lean_object* v___x_736_; uint8_t v_isShared_737_; uint8_t v_isSharedCheck_778_; 
v_ref_732_ = lean_ctor_get(v___y_729_, 5);
v___x_733_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0_spec__0(v_msg_726_, v___y_727_, v___y_728_, v___y_729_, v___y_730_);
v_a_734_ = lean_ctor_get(v___x_733_, 0);
v_isSharedCheck_778_ = !lean_is_exclusive(v___x_733_);
if (v_isSharedCheck_778_ == 0)
{
v___x_736_ = v___x_733_;
v_isShared_737_ = v_isSharedCheck_778_;
goto v_resetjp_735_;
}
else
{
lean_inc(v_a_734_);
lean_dec(v___x_733_);
v___x_736_ = lean_box(0);
v_isShared_737_ = v_isSharedCheck_778_;
goto v_resetjp_735_;
}
v_resetjp_735_:
{
lean_object* v___x_738_; lean_object* v_traceState_739_; lean_object* v_env_740_; lean_object* v_nextMacroScope_741_; lean_object* v_ngen_742_; lean_object* v_auxDeclNGen_743_; lean_object* v_cache_744_; lean_object* v_messages_745_; lean_object* v_infoState_746_; lean_object* v_snapshotTasks_747_; lean_object* v___x_749_; uint8_t v_isShared_750_; uint8_t v_isSharedCheck_777_; 
v___x_738_ = lean_st_ref_take(v___y_730_);
v_traceState_739_ = lean_ctor_get(v___x_738_, 4);
v_env_740_ = lean_ctor_get(v___x_738_, 0);
v_nextMacroScope_741_ = lean_ctor_get(v___x_738_, 1);
v_ngen_742_ = lean_ctor_get(v___x_738_, 2);
v_auxDeclNGen_743_ = lean_ctor_get(v___x_738_, 3);
v_cache_744_ = lean_ctor_get(v___x_738_, 5);
v_messages_745_ = lean_ctor_get(v___x_738_, 6);
v_infoState_746_ = lean_ctor_get(v___x_738_, 7);
v_snapshotTasks_747_ = lean_ctor_get(v___x_738_, 8);
v_isSharedCheck_777_ = !lean_is_exclusive(v___x_738_);
if (v_isSharedCheck_777_ == 0)
{
v___x_749_ = v___x_738_;
v_isShared_750_ = v_isSharedCheck_777_;
goto v_resetjp_748_;
}
else
{
lean_inc(v_snapshotTasks_747_);
lean_inc(v_infoState_746_);
lean_inc(v_messages_745_);
lean_inc(v_cache_744_);
lean_inc(v_traceState_739_);
lean_inc(v_auxDeclNGen_743_);
lean_inc(v_ngen_742_);
lean_inc(v_nextMacroScope_741_);
lean_inc(v_env_740_);
lean_dec(v___x_738_);
v___x_749_ = lean_box(0);
v_isShared_750_ = v_isSharedCheck_777_;
goto v_resetjp_748_;
}
v_resetjp_748_:
{
uint64_t v_tid_751_; lean_object* v_traces_752_; lean_object* v___x_754_; uint8_t v_isShared_755_; uint8_t v_isSharedCheck_776_; 
v_tid_751_ = lean_ctor_get_uint64(v_traceState_739_, sizeof(void*)*1);
v_traces_752_ = lean_ctor_get(v_traceState_739_, 0);
v_isSharedCheck_776_ = !lean_is_exclusive(v_traceState_739_);
if (v_isSharedCheck_776_ == 0)
{
v___x_754_ = v_traceState_739_;
v_isShared_755_ = v_isSharedCheck_776_;
goto v_resetjp_753_;
}
else
{
lean_inc(v_traces_752_);
lean_dec(v_traceState_739_);
v___x_754_ = lean_box(0);
v_isShared_755_ = v_isSharedCheck_776_;
goto v_resetjp_753_;
}
v_resetjp_753_:
{
lean_object* v___x_756_; double v___x_757_; uint8_t v___x_758_; lean_object* v___x_759_; lean_object* v___x_760_; lean_object* v___x_761_; lean_object* v___x_762_; lean_object* v___x_763_; lean_object* v___x_764_; lean_object* v___x_766_; 
v___x_756_ = lean_box(0);
v___x_757_ = lean_float_once(&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__0, &l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__0_once, _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__0);
v___x_758_ = 0;
v___x_759_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__1));
v___x_760_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v___x_760_, 0, v_cls_725_);
lean_ctor_set(v___x_760_, 1, v___x_756_);
lean_ctor_set(v___x_760_, 2, v___x_759_);
lean_ctor_set_float(v___x_760_, sizeof(void*)*3, v___x_757_);
lean_ctor_set_float(v___x_760_, sizeof(void*)*3 + 8, v___x_757_);
lean_ctor_set_uint8(v___x_760_, sizeof(void*)*3 + 16, v___x_758_);
v___x_761_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___closed__2));
v___x_762_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v___x_762_, 0, v___x_760_);
lean_ctor_set(v___x_762_, 1, v_a_734_);
lean_ctor_set(v___x_762_, 2, v___x_761_);
lean_inc(v_ref_732_);
v___x_763_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_763_, 0, v_ref_732_);
lean_ctor_set(v___x_763_, 1, v___x_762_);
v___x_764_ = l_Lean_PersistentArray_push___redArg(v_traces_752_, v___x_763_);
if (v_isShared_755_ == 0)
{
lean_ctor_set(v___x_754_, 0, v___x_764_);
v___x_766_ = v___x_754_;
goto v_reusejp_765_;
}
else
{
lean_object* v_reuseFailAlloc_775_; 
v_reuseFailAlloc_775_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_775_, 0, v___x_764_);
lean_ctor_set_uint64(v_reuseFailAlloc_775_, sizeof(void*)*1, v_tid_751_);
v___x_766_ = v_reuseFailAlloc_775_;
goto v_reusejp_765_;
}
v_reusejp_765_:
{
lean_object* v___x_768_; 
if (v_isShared_750_ == 0)
{
lean_ctor_set(v___x_749_, 4, v___x_766_);
v___x_768_ = v___x_749_;
goto v_reusejp_767_;
}
else
{
lean_object* v_reuseFailAlloc_774_; 
v_reuseFailAlloc_774_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_774_, 0, v_env_740_);
lean_ctor_set(v_reuseFailAlloc_774_, 1, v_nextMacroScope_741_);
lean_ctor_set(v_reuseFailAlloc_774_, 2, v_ngen_742_);
lean_ctor_set(v_reuseFailAlloc_774_, 3, v_auxDeclNGen_743_);
lean_ctor_set(v_reuseFailAlloc_774_, 4, v___x_766_);
lean_ctor_set(v_reuseFailAlloc_774_, 5, v_cache_744_);
lean_ctor_set(v_reuseFailAlloc_774_, 6, v_messages_745_);
lean_ctor_set(v_reuseFailAlloc_774_, 7, v_infoState_746_);
lean_ctor_set(v_reuseFailAlloc_774_, 8, v_snapshotTasks_747_);
v___x_768_ = v_reuseFailAlloc_774_;
goto v_reusejp_767_;
}
v_reusejp_767_:
{
lean_object* v___x_769_; lean_object* v___x_770_; lean_object* v___x_772_; 
v___x_769_ = lean_st_ref_set(v___y_730_, v___x_768_);
v___x_770_ = lean_box(0);
if (v_isShared_737_ == 0)
{
lean_ctor_set(v___x_736_, 0, v___x_770_);
v___x_772_ = v___x_736_;
goto v_reusejp_771_;
}
else
{
lean_object* v_reuseFailAlloc_773_; 
v_reuseFailAlloc_773_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_773_, 0, v___x_770_);
v___x_772_ = v_reuseFailAlloc_773_;
goto v_reusejp_771_;
}
v_reusejp_771_:
{
return v___x_772_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg___boxed(lean_object* v_cls_779_, lean_object* v_msg_780_, lean_object* v___y_781_, lean_object* v___y_782_, lean_object* v___y_783_, lean_object* v___y_784_, lean_object* v___y_785_){
_start:
{
lean_object* v_res_786_; 
v_res_786_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg(v_cls_779_, v_msg_780_, v___y_781_, v___y_782_, v___y_783_, v___y_784_);
lean_dec(v___y_784_);
lean_dec_ref(v___y_783_);
lean_dec(v___y_782_);
lean_dec_ref(v___y_781_);
return v_res_786_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__0(lean_object* v_x_787_, lean_object* v___y_788_, lean_object* v___y_789_, lean_object* v___y_790_, lean_object* v___y_791_, lean_object* v___y_792_, lean_object* v___y_793_, lean_object* v___y_794_, lean_object* v___y_795_, lean_object* v___y_796_){
_start:
{
lean_object* v___x_798_; lean_object* v___x_799_; 
v___x_798_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___lam__0___closed__0));
v___x_799_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_799_, 0, v___x_798_);
return v___x_799_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__0___boxed(lean_object* v_x_800_, lean_object* v___y_801_, lean_object* v___y_802_, lean_object* v___y_803_, lean_object* v___y_804_, lean_object* v___y_805_, lean_object* v___y_806_, lean_object* v___y_807_, lean_object* v___y_808_, lean_object* v___y_809_, lean_object* v___y_810_){
_start:
{
lean_object* v_res_811_; 
v_res_811_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__0(v_x_800_, v___y_801_, v___y_802_, v___y_803_, v___y_804_, v___y_805_, v___y_806_, v___y_807_, v___y_808_, v___y_809_);
lean_dec(v___y_809_);
lean_dec_ref(v___y_808_);
lean_dec(v___y_807_);
lean_dec_ref(v___y_806_);
lean_dec(v___y_805_);
lean_dec_ref(v___y_804_);
lean_dec(v___y_803_);
lean_dec_ref(v___y_802_);
lean_dec(v___y_801_);
lean_dec_ref(v_x_800_);
return v_res_811_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__1(void){
_start:
{
lean_object* v___x_813_; lean_object* v___f_814_; lean_object* v_methods_815_; 
v___x_813_ = lean_alloc_closure((void*)(l___private_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit_0__Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitProc___boxed), 11, 0);
v___f_814_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__0));
v_methods_815_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_methods_815_, 0, v___f_814_);
lean_ctor_set(v_methods_815_, 1, v___x_813_);
return v_methods_815_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__7(void){
_start:
{
lean_object* v___x_825_; lean_object* v___x_826_; lean_object* v___x_827_; 
v___x_825_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__4));
v___x_826_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__6));
v___x_827_ = l_Lean_Name_append(v___x_826_, v___x_825_);
return v___x_827_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__9(void){
_start:
{
lean_object* v___x_829_; lean_object* v___x_830_; 
v___x_829_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__8));
v___x_830_ = l_Lean_stringToMessageData(v___x_829_);
return v___x_830_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg(lean_object* v_upperBound_831_, lean_object* v___x_832_, lean_object* v_config_833_, lean_object* v_a_834_, lean_object* v_b_835_, lean_object* v___y_836_, lean_object* v___y_837_, lean_object* v___y_838_, lean_object* v___y_839_, lean_object* v___y_840_, lean_object* v___y_841_, lean_object* v___y_842_, lean_object* v___y_843_){
_start:
{
lean_object* v___y_846_; uint8_t v___x_868_; 
v___x_868_ = lean_nat_dec_lt(v_a_834_, v_upperBound_831_);
if (v___x_868_ == 0)
{
lean_object* v___x_869_; 
lean_dec(v_a_834_);
lean_dec_ref(v_config_833_);
v___x_869_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_869_, 0, v_b_835_);
return v___x_869_;
}
else
{
lean_object* v___x_870_; lean_object* v_type_871_; lean_object* v_methods_872_; lean_object* v___x_873_; lean_object* v___x_874_; 
v___x_870_ = lean_array_fget_borrowed(v___x_832_, v_a_834_);
v_type_871_ = lean_ctor_get(v___x_870_, 1);
v_methods_872_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__1, &l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__1_once, _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__1);
lean_inc_ref(v_type_871_);
v___x_873_ = lean_alloc_closure((void*)(l_Lean_Meta_Sym_Simp_simp___boxed), 11, 1);
lean_closure_set(v___x_873_, 0, v_type_871_);
lean_inc_ref(v_config_833_);
v___x_874_ = l_Lean_Meta_Sym_Simp_SimpM_run_x27___redArg(v___x_873_, v_methods_872_, v_config_833_, v___y_838_, v___y_839_, v___y_840_, v___y_841_, v___y_842_, v___y_843_);
if (lean_obj_tag(v___x_874_) == 0)
{
lean_object* v_a_875_; lean_object* v___x_876_; 
v_a_875_ = lean_ctor_get(v___x_874_, 0);
lean_inc(v_a_875_);
lean_dec_ref_known(v___x_874_, 1);
lean_inc(v___x_870_);
v___x_876_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(v___x_870_, v_a_875_, v___y_839_, v___y_840_, v___y_841_, v___y_842_, v___y_843_);
if (lean_obj_tag(v___x_876_) == 0)
{
lean_object* v_a_877_; lean_object* v_snd_878_; lean_object* v___x_880_; uint8_t v_isShared_881_; uint8_t v_isSharedCheck_942_; 
v_a_877_ = lean_ctor_get(v___x_876_, 0);
lean_inc(v_a_877_);
lean_dec_ref_known(v___x_876_, 1);
v_snd_878_ = lean_ctor_get(v_b_835_, 1);
v_isSharedCheck_942_ = !lean_is_exclusive(v_b_835_);
if (v_isSharedCheck_942_ == 0)
{
lean_object* v_unused_943_; 
v_unused_943_ = lean_ctor_get(v_b_835_, 0);
lean_dec(v_unused_943_);
v___x_880_ = v_b_835_;
v_isShared_881_ = v_isSharedCheck_942_;
goto v_resetjp_879_;
}
else
{
lean_inc(v_snd_878_);
lean_dec(v_b_835_);
v___x_880_ = lean_box(0);
v_isShared_881_ = v_isSharedCheck_942_;
goto v_resetjp_879_;
}
v_resetjp_879_:
{
lean_object* v_type_882_; lean_object* v_value_883_; uint8_t v___x_884_; 
v_type_882_ = lean_ctor_get(v_a_877_, 1);
v_value_883_ = lean_ctor_get(v_a_877_, 2);
lean_inc_ref(v_type_882_);
v___x_884_ = l_Lean_Expr_isFalse(v_type_882_);
if (v___x_884_ == 0)
{
lean_object* v___x_885_; lean_object* v___f_886_; lean_object* v___x_887_; lean_object* v___f_888_; uint8_t v___x_915_; 
lean_del_object(v___x_880_);
v___x_885_ = lean_box(0);
lean_inc(v_a_877_);
lean_inc(v_snd_878_);
v___f_886_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__1___boxed), 13, 3);
lean_closure_set(v___f_886_, 0, v_snd_878_);
lean_closure_set(v___f_886_, 1, v_a_877_);
lean_closure_set(v___f_886_, 2, v___x_885_);
v___x_887_ = lean_box(v___x_868_);
v___f_888_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__2___boxed), 12, 2);
lean_closure_set(v___f_888_, 0, v___x_887_);
lean_closure_set(v___f_888_, 1, v___f_886_);
v___x_915_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(v___x_870_, v_a_877_);
if (v___x_915_ == 0)
{
lean_inc_ref(v_type_882_);
lean_dec(v_snd_878_);
lean_dec(v_a_877_);
goto v___jp_892_;
}
else
{
if (v___x_884_ == 0)
{
lean_object* v___x_916_; lean_object* v___x_917_; 
lean_dec_ref(v___f_888_);
v___x_916_ = lean_box(0);
v___x_917_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__1(v_snd_878_, v_a_877_, v___x_885_, v___x_916_, v___y_836_, v___y_837_, v___y_838_, v___y_839_, v___y_840_, v___y_841_, v___y_842_, v___y_843_);
v___y_846_ = v___x_917_;
goto v___jp_845_;
}
else
{
lean_inc_ref(v_type_882_);
lean_dec(v_snd_878_);
lean_dec(v_a_877_);
goto v___jp_892_;
}
}
v___jp_889_:
{
lean_object* v___x_890_; lean_object* v___x_891_; 
v___x_890_ = lean_box(0);
v___x_891_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__3(v___f_888_, v_type_882_, v___x_890_, v___y_836_, v___y_837_, v___y_838_, v___y_839_, v___y_840_, v___y_841_, v___y_842_, v___y_843_);
v___y_846_ = v___x_891_;
goto v___jp_845_;
}
v___jp_892_:
{
lean_object* v_options_893_; uint8_t v_hasTrace_894_; 
v_options_893_ = lean_ctor_get(v___y_842_, 2);
v_hasTrace_894_ = lean_ctor_get_uint8(v_options_893_, sizeof(void*)*1);
if (v_hasTrace_894_ == 0)
{
goto v___jp_889_;
}
else
{
lean_object* v_inheritedTraceOptions_895_; lean_object* v___x_896_; lean_object* v___x_897_; uint8_t v___x_898_; 
v_inheritedTraceOptions_895_ = lean_ctor_get(v___y_842_, 13);
v___x_896_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__4));
v___x_897_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__7, &l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__7_once, _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__7);
v___x_898_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_895_, v_options_893_, v___x_897_);
if (v___x_898_ == 0)
{
goto v___jp_889_;
}
else
{
lean_object* v___x_899_; lean_object* v___x_900_; lean_object* v___x_901_; lean_object* v___x_902_; lean_object* v___x_903_; lean_object* v___x_904_; 
lean_inc_ref(v_type_871_);
v___x_899_ = l_Lean_MessageData_ofExpr(v_type_871_);
v___x_900_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__9, &l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__9_once, _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___closed__9);
v___x_901_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_901_, 0, v___x_899_);
lean_ctor_set(v___x_901_, 1, v___x_900_);
lean_inc_ref(v_type_882_);
v___x_902_ = l_Lean_MessageData_ofExpr(v_type_882_);
v___x_903_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_903_, 0, v___x_901_);
lean_ctor_set(v___x_903_, 1, v___x_902_);
v___x_904_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg(v___x_896_, v___x_903_, v___y_840_, v___y_841_, v___y_842_, v___y_843_);
if (lean_obj_tag(v___x_904_) == 0)
{
lean_object* v_a_905_; lean_object* v___x_906_; 
v_a_905_ = lean_ctor_get(v___x_904_, 0);
lean_inc(v_a_905_);
lean_dec_ref_known(v___x_904_, 1);
v___x_906_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___lam__3(v___f_888_, v_type_882_, v_a_905_, v___y_836_, v___y_837_, v___y_838_, v___y_839_, v___y_840_, v___y_841_, v___y_842_, v___y_843_);
v___y_846_ = v___x_906_;
goto v___jp_845_;
}
else
{
lean_object* v_a_907_; lean_object* v___x_909_; uint8_t v_isShared_910_; uint8_t v_isSharedCheck_914_; 
lean_dec_ref(v___f_888_);
lean_dec_ref(v_type_882_);
lean_dec(v_a_834_);
lean_dec_ref(v_config_833_);
v_a_907_ = lean_ctor_get(v___x_904_, 0);
v_isSharedCheck_914_ = !lean_is_exclusive(v___x_904_);
if (v_isSharedCheck_914_ == 0)
{
v___x_909_ = v___x_904_;
v_isShared_910_ = v_isSharedCheck_914_;
goto v_resetjp_908_;
}
else
{
lean_inc(v_a_907_);
lean_dec(v___x_904_);
v___x_909_ = lean_box(0);
v_isShared_910_ = v_isSharedCheck_914_;
goto v_resetjp_908_;
}
v_resetjp_908_:
{
lean_object* v___x_912_; 
if (v_isShared_910_ == 0)
{
v___x_912_ = v___x_909_;
goto v_reusejp_911_;
}
else
{
lean_object* v_reuseFailAlloc_913_; 
v_reuseFailAlloc_913_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_913_, 0, v_a_907_);
v___x_912_ = v_reuseFailAlloc_913_;
goto v_reusejp_911_;
}
v_reusejp_911_:
{
return v___x_912_;
}
}
}
}
}
}
}
else
{
lean_object* v___x_918_; lean_object* v_goal_919_; lean_object* v___x_920_; 
lean_inc_ref(v_value_883_);
lean_dec(v_a_877_);
lean_dec(v_a_834_);
lean_dec_ref(v_config_833_);
v___x_918_ = lean_st_ref_get(v___y_837_);
v_goal_919_ = lean_ctor_get(v___x_918_, 3);
lean_inc(v_goal_919_);
lean_dec(v___x_918_);
v___x_920_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1___redArg(v_goal_919_, v_value_883_, v___y_841_);
if (lean_obj_tag(v___x_920_) == 0)
{
lean_object* v___x_922_; uint8_t v_isShared_923_; uint8_t v_isSharedCheck_932_; 
v_isSharedCheck_932_ = !lean_is_exclusive(v___x_920_);
if (v_isSharedCheck_932_ == 0)
{
lean_object* v_unused_933_; 
v_unused_933_ = lean_ctor_get(v___x_920_, 0);
lean_dec(v_unused_933_);
v___x_922_ = v___x_920_;
v_isShared_923_ = v_isSharedCheck_932_;
goto v_resetjp_921_;
}
else
{
lean_dec(v___x_920_);
v___x_922_ = lean_box(0);
v_isShared_923_ = v_isSharedCheck_932_;
goto v_resetjp_921_;
}
v_resetjp_921_:
{
lean_object* v___x_924_; lean_object* v___x_925_; lean_object* v___x_927_; 
v___x_924_ = lean_box(v___x_884_);
v___x_925_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_925_, 0, v___x_924_);
if (v_isShared_881_ == 0)
{
lean_ctor_set(v___x_880_, 0, v___x_925_);
v___x_927_ = v___x_880_;
goto v_reusejp_926_;
}
else
{
lean_object* v_reuseFailAlloc_931_; 
v_reuseFailAlloc_931_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_931_, 0, v___x_925_);
lean_ctor_set(v_reuseFailAlloc_931_, 1, v_snd_878_);
v___x_927_ = v_reuseFailAlloc_931_;
goto v_reusejp_926_;
}
v_reusejp_926_:
{
lean_object* v___x_929_; 
if (v_isShared_923_ == 0)
{
lean_ctor_set(v___x_922_, 0, v___x_927_);
v___x_929_ = v___x_922_;
goto v_reusejp_928_;
}
else
{
lean_object* v_reuseFailAlloc_930_; 
v_reuseFailAlloc_930_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_930_, 0, v___x_927_);
v___x_929_ = v_reuseFailAlloc_930_;
goto v_reusejp_928_;
}
v_reusejp_928_:
{
return v___x_929_;
}
}
}
}
else
{
lean_object* v_a_934_; lean_object* v___x_936_; uint8_t v_isShared_937_; uint8_t v_isSharedCheck_941_; 
lean_del_object(v___x_880_);
lean_dec(v_snd_878_);
v_a_934_ = lean_ctor_get(v___x_920_, 0);
v_isSharedCheck_941_ = !lean_is_exclusive(v___x_920_);
if (v_isSharedCheck_941_ == 0)
{
v___x_936_ = v___x_920_;
v_isShared_937_ = v_isSharedCheck_941_;
goto v_resetjp_935_;
}
else
{
lean_inc(v_a_934_);
lean_dec(v___x_920_);
v___x_936_ = lean_box(0);
v_isShared_937_ = v_isSharedCheck_941_;
goto v_resetjp_935_;
}
v_resetjp_935_:
{
lean_object* v___x_939_; 
if (v_isShared_937_ == 0)
{
v___x_939_ = v___x_936_;
goto v_reusejp_938_;
}
else
{
lean_object* v_reuseFailAlloc_940_; 
v_reuseFailAlloc_940_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_940_, 0, v_a_934_);
v___x_939_ = v_reuseFailAlloc_940_;
goto v_reusejp_938_;
}
v_reusejp_938_:
{
return v___x_939_;
}
}
}
}
}
}
else
{
lean_object* v_a_944_; lean_object* v___x_946_; uint8_t v_isShared_947_; uint8_t v_isSharedCheck_951_; 
lean_dec_ref(v_b_835_);
lean_dec(v_a_834_);
lean_dec_ref(v_config_833_);
v_a_944_ = lean_ctor_get(v___x_876_, 0);
v_isSharedCheck_951_ = !lean_is_exclusive(v___x_876_);
if (v_isSharedCheck_951_ == 0)
{
v___x_946_ = v___x_876_;
v_isShared_947_ = v_isSharedCheck_951_;
goto v_resetjp_945_;
}
else
{
lean_inc(v_a_944_);
lean_dec(v___x_876_);
v___x_946_ = lean_box(0);
v_isShared_947_ = v_isSharedCheck_951_;
goto v_resetjp_945_;
}
v_resetjp_945_:
{
lean_object* v___x_949_; 
if (v_isShared_947_ == 0)
{
v___x_949_ = v___x_946_;
goto v_reusejp_948_;
}
else
{
lean_object* v_reuseFailAlloc_950_; 
v_reuseFailAlloc_950_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_950_, 0, v_a_944_);
v___x_949_ = v_reuseFailAlloc_950_;
goto v_reusejp_948_;
}
v_reusejp_948_:
{
return v___x_949_;
}
}
}
}
else
{
lean_object* v_a_952_; lean_object* v___x_954_; uint8_t v_isShared_955_; uint8_t v_isSharedCheck_959_; 
lean_dec_ref(v_b_835_);
lean_dec(v_a_834_);
lean_dec_ref(v_config_833_);
v_a_952_ = lean_ctor_get(v___x_874_, 0);
v_isSharedCheck_959_ = !lean_is_exclusive(v___x_874_);
if (v_isSharedCheck_959_ == 0)
{
v___x_954_ = v___x_874_;
v_isShared_955_ = v_isSharedCheck_959_;
goto v_resetjp_953_;
}
else
{
lean_inc(v_a_952_);
lean_dec(v___x_874_);
v___x_954_ = lean_box(0);
v_isShared_955_ = v_isSharedCheck_959_;
goto v_resetjp_953_;
}
v_resetjp_953_:
{
lean_object* v___x_957_; 
if (v_isShared_955_ == 0)
{
v___x_957_ = v___x_954_;
goto v_reusejp_956_;
}
else
{
lean_object* v_reuseFailAlloc_958_; 
v_reuseFailAlloc_958_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_958_, 0, v_a_952_);
v___x_957_ = v_reuseFailAlloc_958_;
goto v_reusejp_956_;
}
v_reusejp_956_:
{
return v___x_957_;
}
}
}
}
v___jp_845_:
{
if (lean_obj_tag(v___y_846_) == 0)
{
lean_object* v_a_847_; lean_object* v___x_849_; uint8_t v_isShared_850_; uint8_t v_isSharedCheck_859_; 
v_a_847_ = lean_ctor_get(v___y_846_, 0);
v_isSharedCheck_859_ = !lean_is_exclusive(v___y_846_);
if (v_isSharedCheck_859_ == 0)
{
v___x_849_ = v___y_846_;
v_isShared_850_ = v_isSharedCheck_859_;
goto v_resetjp_848_;
}
else
{
lean_inc(v_a_847_);
lean_dec(v___y_846_);
v___x_849_ = lean_box(0);
v_isShared_850_ = v_isSharedCheck_859_;
goto v_resetjp_848_;
}
v_resetjp_848_:
{
if (lean_obj_tag(v_a_847_) == 0)
{
lean_object* v_a_851_; lean_object* v___x_853_; 
lean_dec(v_a_834_);
lean_dec_ref(v_config_833_);
v_a_851_ = lean_ctor_get(v_a_847_, 0);
lean_inc(v_a_851_);
lean_dec_ref_known(v_a_847_, 1);
if (v_isShared_850_ == 0)
{
lean_ctor_set(v___x_849_, 0, v_a_851_);
v___x_853_ = v___x_849_;
goto v_reusejp_852_;
}
else
{
lean_object* v_reuseFailAlloc_854_; 
v_reuseFailAlloc_854_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_854_, 0, v_a_851_);
v___x_853_ = v_reuseFailAlloc_854_;
goto v_reusejp_852_;
}
v_reusejp_852_:
{
return v___x_853_;
}
}
else
{
lean_object* v_a_855_; lean_object* v___x_856_; lean_object* v___x_857_; 
lean_del_object(v___x_849_);
v_a_855_ = lean_ctor_get(v_a_847_, 0);
lean_inc(v_a_855_);
lean_dec_ref_known(v_a_847_, 1);
v___x_856_ = lean_unsigned_to_nat(1u);
v___x_857_ = lean_nat_add(v_a_834_, v___x_856_);
lean_dec(v_a_834_);
v_a_834_ = v___x_857_;
v_b_835_ = v_a_855_;
goto _start;
}
}
}
else
{
lean_object* v_a_860_; lean_object* v___x_862_; uint8_t v_isShared_863_; uint8_t v_isSharedCheck_867_; 
lean_dec(v_a_834_);
lean_dec_ref(v_config_833_);
v_a_860_ = lean_ctor_get(v___y_846_, 0);
v_isSharedCheck_867_ = !lean_is_exclusive(v___y_846_);
if (v_isSharedCheck_867_ == 0)
{
v___x_862_ = v___y_846_;
v_isShared_863_ = v_isSharedCheck_867_;
goto v_resetjp_861_;
}
else
{
lean_inc(v_a_860_);
lean_dec(v___y_846_);
v___x_862_ = lean_box(0);
v_isShared_863_ = v_isSharedCheck_867_;
goto v_resetjp_861_;
}
v_resetjp_861_:
{
lean_object* v___x_865_; 
if (v_isShared_863_ == 0)
{
v___x_865_ = v___x_862_;
goto v_reusejp_864_;
}
else
{
lean_object* v_reuseFailAlloc_866_; 
v_reuseFailAlloc_866_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_866_, 0, v_a_860_);
v___x_865_ = v_reuseFailAlloc_866_;
goto v_reusejp_864_;
}
v_reusejp_864_:
{
return v___x_865_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg___boxed(lean_object* v_upperBound_960_, lean_object* v___x_961_, lean_object* v_config_962_, lean_object* v_a_963_, lean_object* v_b_964_, lean_object* v___y_965_, lean_object* v___y_966_, lean_object* v___y_967_, lean_object* v___y_968_, lean_object* v___y_969_, lean_object* v___y_970_, lean_object* v___y_971_, lean_object* v___y_972_, lean_object* v___y_973_){
_start:
{
lean_object* v_res_974_; 
v_res_974_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg(v_upperBound_960_, v___x_961_, v_config_962_, v_a_963_, v_b_964_, v___y_965_, v___y_966_, v___y_967_, v___y_968_, v___y_969_, v___y_970_, v___y_971_, v___y_972_);
lean_dec(v___y_972_);
lean_dec_ref(v___y_971_);
lean_dec(v___y_970_);
lean_dec_ref(v___y_969_);
lean_dec(v___y_968_);
lean_dec_ref(v___y_967_);
lean_dec(v___y_966_);
lean_dec_ref(v___y_965_);
lean_dec_ref(v___x_961_);
lean_dec(v_upperBound_960_);
return v_res_974_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__0(lean_object* v_config_975_, lean_object* v___y_976_, lean_object* v___y_977_, lean_object* v___y_978_, lean_object* v___y_979_, lean_object* v___y_980_, lean_object* v___y_981_, lean_object* v___y_982_, lean_object* v___y_983_){
_start:
{
lean_object* v___x_985_; lean_object* v_hypotheses_986_; lean_object* v___x_987_; lean_object* v_newHyps_988_; lean_object* v___x_989_; lean_object* v___x_990_; lean_object* v___x_991_; lean_object* v___x_992_; 
v___x_985_ = lean_st_ref_get(v___y_977_);
v_hypotheses_986_ = lean_ctor_get(v___x_985_, 4);
lean_inc_ref(v_hypotheses_986_);
lean_dec(v___x_985_);
v___x_987_ = lean_array_get_size(v_hypotheses_986_);
v_newHyps_988_ = lean_mk_empty_array_with_capacity(v___x_987_);
v___x_989_ = lean_unsigned_to_nat(0u);
v___x_990_ = lean_box(0);
v___x_991_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_991_, 0, v___x_990_);
lean_ctor_set(v___x_991_, 1, v_newHyps_988_);
v___x_992_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg(v___x_987_, v_hypotheses_986_, v_config_975_, v___x_989_, v___x_991_, v___y_976_, v___y_977_, v___y_978_, v___y_979_, v___y_980_, v___y_981_, v___y_982_, v___y_983_);
lean_dec_ref(v_hypotheses_986_);
if (lean_obj_tag(v___x_992_) == 0)
{
lean_object* v_a_993_; lean_object* v___x_995_; uint8_t v_isShared_996_; uint8_t v_isSharedCheck_1023_; 
v_a_993_ = lean_ctor_get(v___x_992_, 0);
v_isSharedCheck_1023_ = !lean_is_exclusive(v___x_992_);
if (v_isSharedCheck_1023_ == 0)
{
v___x_995_ = v___x_992_;
v_isShared_996_ = v_isSharedCheck_1023_;
goto v_resetjp_994_;
}
else
{
lean_inc(v_a_993_);
lean_dec(v___x_992_);
v___x_995_ = lean_box(0);
v_isShared_996_ = v_isSharedCheck_1023_;
goto v_resetjp_994_;
}
v_resetjp_994_:
{
lean_object* v_fst_997_; 
v_fst_997_ = lean_ctor_get(v_a_993_, 0);
if (lean_obj_tag(v_fst_997_) == 0)
{
lean_object* v_snd_998_; lean_object* v___x_999_; lean_object* v_rewriteCache_1000_; lean_object* v_acNfCache_1001_; lean_object* v_typeAnalysis_1002_; lean_object* v_goal_1003_; uint8_t v_didChange_1004_; lean_object* v___x_1006_; uint8_t v_isShared_1007_; uint8_t v_isSharedCheck_1017_; 
v_snd_998_ = lean_ctor_get(v_a_993_, 1);
lean_inc(v_snd_998_);
lean_dec(v_a_993_);
v___x_999_ = lean_st_ref_take(v___y_977_);
v_rewriteCache_1000_ = lean_ctor_get(v___x_999_, 0);
v_acNfCache_1001_ = lean_ctor_get(v___x_999_, 1);
v_typeAnalysis_1002_ = lean_ctor_get(v___x_999_, 2);
v_goal_1003_ = lean_ctor_get(v___x_999_, 3);
v_didChange_1004_ = lean_ctor_get_uint8(v___x_999_, sizeof(void*)*5);
v_isSharedCheck_1017_ = !lean_is_exclusive(v___x_999_);
if (v_isSharedCheck_1017_ == 0)
{
lean_object* v_unused_1018_; 
v_unused_1018_ = lean_ctor_get(v___x_999_, 4);
lean_dec(v_unused_1018_);
v___x_1006_ = v___x_999_;
v_isShared_1007_ = v_isSharedCheck_1017_;
goto v_resetjp_1005_;
}
else
{
lean_inc(v_goal_1003_);
lean_inc(v_typeAnalysis_1002_);
lean_inc(v_acNfCache_1001_);
lean_inc(v_rewriteCache_1000_);
lean_dec(v___x_999_);
v___x_1006_ = lean_box(0);
v_isShared_1007_ = v_isSharedCheck_1017_;
goto v_resetjp_1005_;
}
v_resetjp_1005_:
{
lean_object* v___x_1009_; 
if (v_isShared_1007_ == 0)
{
lean_ctor_set(v___x_1006_, 4, v_snd_998_);
v___x_1009_ = v___x_1006_;
goto v_reusejp_1008_;
}
else
{
lean_object* v_reuseFailAlloc_1016_; 
v_reuseFailAlloc_1016_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_1016_, 0, v_rewriteCache_1000_);
lean_ctor_set(v_reuseFailAlloc_1016_, 1, v_acNfCache_1001_);
lean_ctor_set(v_reuseFailAlloc_1016_, 2, v_typeAnalysis_1002_);
lean_ctor_set(v_reuseFailAlloc_1016_, 3, v_goal_1003_);
lean_ctor_set(v_reuseFailAlloc_1016_, 4, v_snd_998_);
lean_ctor_set_uint8(v_reuseFailAlloc_1016_, sizeof(void*)*5, v_didChange_1004_);
v___x_1009_ = v_reuseFailAlloc_1016_;
goto v_reusejp_1008_;
}
v_reusejp_1008_:
{
lean_object* v___x_1010_; uint8_t v___x_1011_; lean_object* v___x_1012_; lean_object* v___x_1014_; 
v___x_1010_ = lean_st_ref_set(v___y_977_, v___x_1009_);
v___x_1011_ = 0;
v___x_1012_ = lean_box(v___x_1011_);
if (v_isShared_996_ == 0)
{
lean_ctor_set(v___x_995_, 0, v___x_1012_);
v___x_1014_ = v___x_995_;
goto v_reusejp_1013_;
}
else
{
lean_object* v_reuseFailAlloc_1015_; 
v_reuseFailAlloc_1015_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1015_, 0, v___x_1012_);
v___x_1014_ = v_reuseFailAlloc_1015_;
goto v_reusejp_1013_;
}
v_reusejp_1013_:
{
return v___x_1014_;
}
}
}
}
else
{
lean_object* v_val_1019_; lean_object* v___x_1021_; 
lean_inc_ref(v_fst_997_);
lean_dec(v_a_993_);
v_val_1019_ = lean_ctor_get(v_fst_997_, 0);
lean_inc(v_val_1019_);
lean_dec_ref_known(v_fst_997_, 1);
if (v_isShared_996_ == 0)
{
lean_ctor_set(v___x_995_, 0, v_val_1019_);
v___x_1021_ = v___x_995_;
goto v_reusejp_1020_;
}
else
{
lean_object* v_reuseFailAlloc_1022_; 
v_reuseFailAlloc_1022_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1022_, 0, v_val_1019_);
v___x_1021_ = v_reuseFailAlloc_1022_;
goto v_reusejp_1020_;
}
v_reusejp_1020_:
{
return v___x_1021_;
}
}
}
}
else
{
lean_object* v_a_1024_; lean_object* v___x_1026_; uint8_t v_isShared_1027_; uint8_t v_isSharedCheck_1031_; 
v_a_1024_ = lean_ctor_get(v___x_992_, 0);
v_isSharedCheck_1031_ = !lean_is_exclusive(v___x_992_);
if (v_isSharedCheck_1031_ == 0)
{
v___x_1026_ = v___x_992_;
v_isShared_1027_ = v_isSharedCheck_1031_;
goto v_resetjp_1025_;
}
else
{
lean_inc(v_a_1024_);
lean_dec(v___x_992_);
v___x_1026_ = lean_box(0);
v_isShared_1027_ = v_isSharedCheck_1031_;
goto v_resetjp_1025_;
}
v_resetjp_1025_:
{
lean_object* v___x_1029_; 
if (v_isShared_1027_ == 0)
{
v___x_1029_ = v___x_1026_;
goto v_reusejp_1028_;
}
else
{
lean_object* v_reuseFailAlloc_1030_; 
v_reuseFailAlloc_1030_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1030_, 0, v_a_1024_);
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
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__0___boxed(lean_object* v_config_1032_, lean_object* v___y_1033_, lean_object* v___y_1034_, lean_object* v___y_1035_, lean_object* v___y_1036_, lean_object* v___y_1037_, lean_object* v___y_1038_, lean_object* v___y_1039_, lean_object* v___y_1040_, lean_object* v___y_1041_){
_start:
{
lean_object* v_res_1042_; 
v_res_1042_ = l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__0(v_config_1032_, v___y_1033_, v___y_1034_, v___y_1035_, v___y_1036_, v___y_1037_, v___y_1038_, v___y_1039_, v___y_1040_);
lean_dec(v___y_1040_);
lean_dec_ref(v___y_1039_);
lean_dec(v___y_1038_);
lean_dec_ref(v___y_1037_);
lean_dec(v___y_1036_);
lean_dec_ref(v___y_1035_);
lean_dec(v___y_1034_);
lean_dec_ref(v___y_1033_);
return v_res_1042_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__1(lean_object* v___y_1043_, lean_object* v___y_1044_, lean_object* v___y_1045_, lean_object* v___y_1046_, lean_object* v___y_1047_, lean_object* v___y_1048_, lean_object* v___y_1049_, lean_object* v___y_1050_){
_start:
{
lean_object* v___x_1052_; lean_object* v_maxSteps_1053_; lean_object* v_goal_1054_; lean_object* v___x_1055_; lean_object* v_config_1056_; lean_object* v___f_1057_; lean_object* v___x_1058_; 
v___x_1052_ = lean_st_ref_get(v___y_1044_);
v_maxSteps_1053_ = lean_ctor_get(v___y_1043_, 1);
v_goal_1054_ = lean_ctor_get(v___x_1052_, 3);
lean_inc(v_goal_1054_);
lean_dec(v___x_1052_);
v___x_1055_ = lean_unsigned_to_nat(2u);
lean_inc(v_maxSteps_1053_);
v_config_1056_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_config_1056_, 0, v_maxSteps_1053_);
lean_ctor_set(v_config_1056_, 1, v___x_1055_);
v___f_1057_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__0___boxed), 10, 1);
lean_closure_set(v___f_1057_, 0, v_config_1056_);
v___x_1058_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__3___redArg(v_goal_1054_, v___f_1057_, v___y_1043_, v___y_1044_, v___y_1045_, v___y_1046_, v___y_1047_, v___y_1048_, v___y_1049_, v___y_1050_);
return v___x_1058_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__1___boxed(lean_object* v___y_1059_, lean_object* v___y_1060_, lean_object* v___y_1061_, lean_object* v___y_1062_, lean_object* v___y_1063_, lean_object* v___y_1064_, lean_object* v___y_1065_, lean_object* v___y_1066_, lean_object* v___y_1067_){
_start:
{
lean_object* v_res_1068_; 
v_res_1068_ = l_Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass___lam__1(v___y_1059_, v___y_1060_, v___y_1061_, v___y_1062_, v___y_1063_, v___y_1064_, v___y_1065_, v___y_1066_);
lean_dec(v___y_1066_);
lean_dec_ref(v___y_1065_);
lean_dec(v___y_1064_);
lean_dec_ref(v___y_1063_);
lean_dec(v___y_1062_);
lean_dec_ref(v___y_1061_);
lean_dec(v___y_1060_);
lean_dec_ref(v___y_1059_);
return v_res_1068_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0(lean_object* v_cls_1077_, lean_object* v_msg_1078_, lean_object* v___y_1079_, lean_object* v___y_1080_, lean_object* v___y_1081_, lean_object* v___y_1082_, lean_object* v___y_1083_, lean_object* v___y_1084_, lean_object* v___y_1085_, lean_object* v___y_1086_){
_start:
{
lean_object* v___x_1088_; 
v___x_1088_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___redArg(v_cls_1077_, v_msg_1078_, v___y_1083_, v___y_1084_, v___y_1085_, v___y_1086_);
return v___x_1088_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0___boxed(lean_object* v_cls_1089_, lean_object* v_msg_1090_, lean_object* v___y_1091_, lean_object* v___y_1092_, lean_object* v___y_1093_, lean_object* v___y_1094_, lean_object* v___y_1095_, lean_object* v___y_1096_, lean_object* v___y_1097_, lean_object* v___y_1098_, lean_object* v___y_1099_){
_start:
{
lean_object* v_res_1100_; 
v_res_1100_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__0(v_cls_1089_, v_msg_1090_, v___y_1091_, v___y_1092_, v___y_1093_, v___y_1094_, v___y_1095_, v___y_1096_, v___y_1097_, v___y_1098_);
lean_dec(v___y_1098_);
lean_dec_ref(v___y_1097_);
lean_dec(v___y_1096_);
lean_dec_ref(v___y_1095_);
lean_dec(v___y_1094_);
lean_dec_ref(v___y_1093_);
lean_dec(v___y_1092_);
lean_dec_ref(v___y_1091_);
return v_res_1100_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1(lean_object* v_mvarId_1101_, lean_object* v_val_1102_, lean_object* v___y_1103_, lean_object* v___y_1104_, lean_object* v___y_1105_, lean_object* v___y_1106_, lean_object* v___y_1107_, lean_object* v___y_1108_, lean_object* v___y_1109_, lean_object* v___y_1110_){
_start:
{
lean_object* v___x_1112_; 
v___x_1112_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1___redArg(v_mvarId_1101_, v_val_1102_, v___y_1108_);
return v___x_1112_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1___boxed(lean_object* v_mvarId_1113_, lean_object* v_val_1114_, lean_object* v___y_1115_, lean_object* v___y_1116_, lean_object* v___y_1117_, lean_object* v___y_1118_, lean_object* v___y_1119_, lean_object* v___y_1120_, lean_object* v___y_1121_, lean_object* v___y_1122_, lean_object* v___y_1123_){
_start:
{
lean_object* v_res_1124_; 
v_res_1124_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1(v_mvarId_1113_, v_val_1114_, v___y_1115_, v___y_1116_, v___y_1117_, v___y_1118_, v___y_1119_, v___y_1120_, v___y_1121_, v___y_1122_);
lean_dec(v___y_1122_);
lean_dec_ref(v___y_1121_);
lean_dec(v___y_1120_);
lean_dec_ref(v___y_1119_);
lean_dec(v___y_1118_);
lean_dec_ref(v___y_1117_);
lean_dec(v___y_1116_);
lean_dec_ref(v___y_1115_);
return v_res_1124_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2(lean_object* v_upperBound_1125_, lean_object* v___x_1126_, lean_object* v_config_1127_, lean_object* v_inst_1128_, lean_object* v_R_1129_, lean_object* v_a_1130_, lean_object* v_b_1131_, lean_object* v_c_1132_, lean_object* v___y_1133_, lean_object* v___y_1134_, lean_object* v___y_1135_, lean_object* v___y_1136_, lean_object* v___y_1137_, lean_object* v___y_1138_, lean_object* v___y_1139_, lean_object* v___y_1140_){
_start:
{
lean_object* v___x_1142_; 
v___x_1142_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___redArg(v_upperBound_1125_, v___x_1126_, v_config_1127_, v_a_1130_, v_b_1131_, v___y_1133_, v___y_1134_, v___y_1135_, v___y_1136_, v___y_1137_, v___y_1138_, v___y_1139_, v___y_1140_);
return v___x_1142_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2___boxed(lean_object** _args){
lean_object* v_upperBound_1143_ = _args[0];
lean_object* v___x_1144_ = _args[1];
lean_object* v_config_1145_ = _args[2];
lean_object* v_inst_1146_ = _args[3];
lean_object* v_R_1147_ = _args[4];
lean_object* v_a_1148_ = _args[5];
lean_object* v_b_1149_ = _args[6];
lean_object* v_c_1150_ = _args[7];
lean_object* v___y_1151_ = _args[8];
lean_object* v___y_1152_ = _args[9];
lean_object* v___y_1153_ = _args[10];
lean_object* v___y_1154_ = _args[11];
lean_object* v___y_1155_ = _args[12];
lean_object* v___y_1156_ = _args[13];
lean_object* v___y_1157_ = _args[14];
lean_object* v___y_1158_ = _args[15];
lean_object* v___y_1159_ = _args[16];
_start:
{
lean_object* v_res_1160_; 
v_res_1160_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__2(v_upperBound_1143_, v___x_1144_, v_config_1145_, v_inst_1146_, v_R_1147_, v_a_1148_, v_b_1149_, v_c_1150_, v___y_1151_, v___y_1152_, v___y_1153_, v___y_1154_, v___y_1155_, v___y_1156_, v___y_1157_, v___y_1158_);
lean_dec(v___y_1158_);
lean_dec_ref(v___y_1157_);
lean_dec(v___y_1156_);
lean_dec_ref(v___y_1155_);
lean_dec(v___y_1154_);
lean_dec_ref(v___y_1153_);
lean_dec(v___y_1152_);
lean_dec_ref(v___y_1151_);
lean_dec_ref(v___x_1144_);
lean_dec(v_upperBound_1143_);
return v_res_1160_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2(lean_object* v_00_u03b2_1161_, lean_object* v_x_1162_, lean_object* v_x_1163_, lean_object* v_x_1164_){
_start:
{
lean_object* v___x_1165_; 
v___x_1165_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2___redArg(v_x_1162_, v_x_1163_, v_x_1164_);
return v___x_1165_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4(lean_object* v_00_u03b2_1166_, lean_object* v_x_1167_, size_t v_x_1168_, size_t v_x_1169_, lean_object* v_x_1170_, lean_object* v_x_1171_){
_start:
{
lean_object* v___x_1172_; 
v___x_1172_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___redArg(v_x_1167_, v_x_1168_, v_x_1169_, v_x_1170_, v_x_1171_);
return v___x_1172_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4___boxed(lean_object* v_00_u03b2_1173_, lean_object* v_x_1174_, lean_object* v_x_1175_, lean_object* v_x_1176_, lean_object* v_x_1177_, lean_object* v_x_1178_){
_start:
{
size_t v_x_24671__boxed_1179_; size_t v_x_24672__boxed_1180_; lean_object* v_res_1181_; 
v_x_24671__boxed_1179_ = lean_unbox_usize(v_x_1175_);
lean_dec(v_x_1175_);
v_x_24672__boxed_1180_ = lean_unbox_usize(v_x_1176_);
lean_dec(v_x_1176_);
v_res_1181_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4(v_00_u03b2_1173_, v_x_1174_, v_x_24671__boxed_1179_, v_x_24672__boxed_1180_, v_x_1177_, v_x_1178_);
return v_res_1181_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6(lean_object* v_00_u03b2_1182_, lean_object* v_n_1183_, lean_object* v_k_1184_, lean_object* v_v_1185_){
_start:
{
lean_object* v___x_1186_; 
v___x_1186_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6___redArg(v_n_1183_, v_k_1184_, v_v_1185_);
return v___x_1186_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7(lean_object* v_00_u03b2_1187_, size_t v_depth_1188_, lean_object* v_keys_1189_, lean_object* v_vals_1190_, lean_object* v_heq_1191_, lean_object* v_i_1192_, lean_object* v_entries_1193_){
_start:
{
lean_object* v___x_1194_; 
v___x_1194_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7___redArg(v_depth_1188_, v_keys_1189_, v_vals_1190_, v_i_1192_, v_entries_1193_);
return v___x_1194_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7___boxed(lean_object* v_00_u03b2_1195_, lean_object* v_depth_1196_, lean_object* v_keys_1197_, lean_object* v_vals_1198_, lean_object* v_heq_1199_, lean_object* v_i_1200_, lean_object* v_entries_1201_){
_start:
{
size_t v_depth_boxed_1202_; lean_object* v_res_1203_; 
v_depth_boxed_1202_ = lean_unbox_usize(v_depth_1196_);
lean_dec(v_depth_1196_);
v_res_1203_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__7(v_00_u03b2_1195_, v_depth_boxed_1202_, v_keys_1197_, v_vals_1198_, v_heq_1199_, v_i_1200_, v_entries_1201_);
lean_dec_ref(v_vals_1198_);
lean_dec_ref(v_keys_1197_);
return v_res_1203_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6_spec__7(lean_object* v_00_u03b2_1204_, lean_object* v_x_1205_, lean_object* v_x_1206_, lean_object* v_x_1207_, lean_object* v_x_1208_){
_start:
{
lean_object* v___x_1209_; 
v___x_1209_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_shortCircuitPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(v_x_1205_, v_x_1206_, v_x_1207_, v_x_1208_);
return v___x_1209_;
}
}
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
lean_object* runtime_initialize_Std_Tactic_BVDecide_Normalize_BitVec(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_Theorems(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_Rewrite(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Std_Tactic_BVDecide_Normalize_BitVec(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_Theorems(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
lean_object* initialize_Std_Tactic_BVDecide_Normalize_BitVec(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_Theorems(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_Rewrite(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Std_Tactic_BVDecide_Normalize_BitVec(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_Theorems(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Meta_Tactic_BVDecide_Normalize_ShortCircuit(builtin);
}
#ifdef __cplusplus
}
#endif
