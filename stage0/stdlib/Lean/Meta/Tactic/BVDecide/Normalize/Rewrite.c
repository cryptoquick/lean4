// Lean compiler output
// Module: Lean.Meta.Tactic.BVDecide.Normalize.Rewrite
// Imports: public import Lean.Meta.Tactic.BVDecide.Normalize.Basic import Lean.Meta.Tactic.BVDecide.Normalize.Simproc import Lean.Meta.Sym.Simp.Rewrite import Lean.Meta.Sym.Simp.EvalGround import Lean.Meta.Sym.DSimp
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
lean_object* lean_array_push(lean_object*, lean_object*);
lean_object* l_Lean_PersistentHashMap_mkEmptyEntries(lean_object*, lean_object*);
lean_object* lean_st_ref_take(lean_object*);
uint64_t l_Lean_instHashableMVarId_hash(lean_object*);
size_t lean_uint64_to_usize(uint64_t);
size_t lean_usize_land(size_t, size_t);
lean_object* lean_usize_to_nat(size_t);
lean_object* lean_array_get_size(lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
lean_object* lean_array_fget(lean_object*, lean_object*);
lean_object* lean_array_fset(lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_instBEqMVarId_beq(lean_object*, lean_object*);
lean_object* l_Lean_PersistentHashMap_mkCollisionNode___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
size_t lean_usize_shift_right(size_t, size_t);
size_t lean_usize_add(size_t, size_t);
lean_object* lean_array_fget_borrowed(lean_object*, lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
size_t lean_usize_sub(size_t, size_t);
size_t lean_usize_mul(size_t, size_t);
uint8_t lean_usize_dec_le(size_t, size_t);
lean_object* l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(lean_object*);
lean_object* lean_st_ref_set(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_DSimp_evalGround___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteDsimproc___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr3(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr1(lean_object*);
lean_object* l_Lean_Name_append(lean_object*, lean_object*);
lean_object* lean_st_ref_get(lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
uint8_t l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_MessageData_ofExpr(lean_object*);
lean_object* l_Lean_stringToMessageData(lean_object*);
double lean_float_of_nat(lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* l_Lean_PersistentArray_push___redArg(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_DSimp_dsimp___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_DSimp_DSimpM_run_x27___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_simp___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_SimpM_run_x27___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_Expr_isFalse(lean_object*);
lean_object* l_Lean_Meta_Sym_Internal_Sym_assertShared(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_evalGround___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_evalGround___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_Result_withContextDependent(lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_mkEqTrans(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_mkDischargerFromSimproc___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteSimproc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_Theorems_rewrite(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Simp_SymSimpExtension_getTheorems___redArg(lean_object*, lean_object*);
extern lean_object* l_Lean_Meta_Tactic_BVDecide_bvNormalizeExt;
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*0 + 8, .m_other = 0, .m_tag = 0}, .m_objs = {LEAN_SCALAR_PTR_LITERAL(0, 0, 0, 0, 0, 0, 0, 0)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__3(uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static double l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__0;
static const lean_string_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 1, .m_capacity = 1, .m_length = 0, .m_data = ""};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__1 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__1_value;
static const lean_array_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__2 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__2_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6___redArg(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg___closed__0;
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg(lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7___redArg(size_t, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*0 + 8, .m_other = 0, .m_tag = 0}, .m_objs = {LEAN_SCALAR_PTR_LITERAL(0, 0, 0, 0, 0, 0, 0, 0)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0___closed__0 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0___closed__0_value;
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Meta"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__0 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__0_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__1 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__1_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "bv"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__2 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__2_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__3_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(211, 174, 49, 251, 64, 24, 251, 1)}};
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__3_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__3_value_aux_0),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(194, 95, 140, 15, 16, 100, 236, 219)}};
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__3_value_aux_1),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__2_value),LEAN_SCALAR_PTR_LITERAL(139, 41, 106, 94, 234, 34, 111, 146)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__3 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__3_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trace"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__4 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__4_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__4_value),LEAN_SCALAR_PTR_LITERAL(212, 145, 141, 177, 67, 149, 127, 197)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__5 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__5_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__6;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "  ==>  "};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__7 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__7_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__8_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__8;
static const lean_closure_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__9_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0___boxed, .m_arity = 11, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__9 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__9_value;
static const lean_closure_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__1___boxed, .m_arity = 12, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(255) << 1) | 1))} };
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__10 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__10_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__11_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__9_value),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__10_value)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__11 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__11_value;
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Sym_Simp_evalGround___boxed, .m_arity = 12, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(255) << 1) | 1))} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___closed__0_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Sym_Simp_mkDischargerFromSimproc___boxed, .m_arity = 12, .m_num_fixed = 1, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___closed__0_value)} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___closed__1_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0___boxed, .m_arity = 11, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 13, .m_capacity = 13, .m_length = 12, .m_data = "rewriteRules"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__1_value),LEAN_SCALAR_PTR_LITERAL(39, 217, 1, 104, 84, 94, 139, 227)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__2_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__3;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__4;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4(lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7(lean_object*, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6_spec__7(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg___lam__0(lean_object* v_x_1_, lean_object* v___y_2_, lean_object* v___y_3_, lean_object* v___y_4_, lean_object* v___y_5_, lean_object* v___y_6_, lean_object* v___y_7_, lean_object* v___y_8_, lean_object* v___y_9_){
_start:
{
lean_object* v___x_11_; 
lean_inc(v___y_5_);
lean_inc_ref(v___y_4_);
lean_inc(v___y_3_);
lean_inc_ref(v___y_2_);
v___x_11_ = lean_apply_9(v_x_1_, v___y_2_, v___y_3_, v___y_4_, v___y_5_, v___y_6_, v___y_7_, v___y_8_, v___y_9_, lean_box(0));
return v___x_11_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg___lam__0___boxed(lean_object* v_x_12_, lean_object* v___y_13_, lean_object* v___y_14_, lean_object* v___y_15_, lean_object* v___y_16_, lean_object* v___y_17_, lean_object* v___y_18_, lean_object* v___y_19_, lean_object* v___y_20_, lean_object* v___y_21_){
_start:
{
lean_object* v_res_22_; 
v_res_22_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg___lam__0(v_x_12_, v___y_13_, v___y_14_, v___y_15_, v___y_16_, v___y_17_, v___y_18_, v___y_19_, v___y_20_);
lean_dec(v___y_16_);
lean_dec_ref(v___y_15_);
lean_dec(v___y_14_);
lean_dec_ref(v___y_13_);
return v_res_22_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg(lean_object* v_mvarId_23_, lean_object* v_x_24_, lean_object* v___y_25_, lean_object* v___y_26_, lean_object* v___y_27_, lean_object* v___y_28_, lean_object* v___y_29_, lean_object* v___y_30_, lean_object* v___y_31_, lean_object* v___y_32_){
_start:
{
lean_object* v___f_34_; lean_object* v___x_35_; 
lean_inc(v___y_28_);
lean_inc_ref(v___y_27_);
lean_inc(v___y_26_);
lean_inc_ref(v___y_25_);
v___f_34_ = lean_alloc_closure((void*)(l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg___lam__0___boxed), 10, 5);
lean_closure_set(v___f_34_, 0, v_x_24_);
lean_closure_set(v___f_34_, 1, v___y_25_);
lean_closure_set(v___f_34_, 2, v___y_26_);
lean_closure_set(v___f_34_, 3, v___y_27_);
lean_closure_set(v___f_34_, 4, v___y_28_);
v___x_35_ = l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_box(0), v_mvarId_23_, v___f_34_, v___y_29_, v___y_30_, v___y_31_, v___y_32_);
if (lean_obj_tag(v___x_35_) == 0)
{
return v___x_35_;
}
else
{
lean_object* v_a_36_; lean_object* v___x_38_; uint8_t v_isShared_39_; uint8_t v_isSharedCheck_43_; 
v_a_36_ = lean_ctor_get(v___x_35_, 0);
v_isSharedCheck_43_ = !lean_is_exclusive(v___x_35_);
if (v_isSharedCheck_43_ == 0)
{
v___x_38_ = v___x_35_;
v_isShared_39_ = v_isSharedCheck_43_;
goto v_resetjp_37_;
}
else
{
lean_inc(v_a_36_);
lean_dec(v___x_35_);
v___x_38_ = lean_box(0);
v_isShared_39_ = v_isSharedCheck_43_;
goto v_resetjp_37_;
}
v_resetjp_37_:
{
lean_object* v___x_41_; 
if (v_isShared_39_ == 0)
{
v___x_41_ = v___x_38_;
goto v_reusejp_40_;
}
else
{
lean_object* v_reuseFailAlloc_42_; 
v_reuseFailAlloc_42_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_42_, 0, v_a_36_);
v___x_41_ = v_reuseFailAlloc_42_;
goto v_reusejp_40_;
}
v_reusejp_40_:
{
return v___x_41_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg___boxed(lean_object* v_mvarId_44_, lean_object* v_x_45_, lean_object* v___y_46_, lean_object* v___y_47_, lean_object* v___y_48_, lean_object* v___y_49_, lean_object* v___y_50_, lean_object* v___y_51_, lean_object* v___y_52_, lean_object* v___y_53_, lean_object* v___y_54_){
_start:
{
lean_object* v_res_55_; 
v_res_55_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg(v_mvarId_44_, v_x_45_, v___y_46_, v___y_47_, v___y_48_, v___y_49_, v___y_50_, v___y_51_, v___y_52_, v___y_53_);
lean_dec(v___y_53_);
lean_dec_ref(v___y_52_);
lean_dec(v___y_51_);
lean_dec_ref(v___y_50_);
lean_dec(v___y_49_);
lean_dec_ref(v___y_48_);
lean_dec(v___y_47_);
lean_dec_ref(v___y_46_);
return v_res_55_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3(lean_object* v_00_u03b1_56_, lean_object* v_mvarId_57_, lean_object* v_x_58_, lean_object* v___y_59_, lean_object* v___y_60_, lean_object* v___y_61_, lean_object* v___y_62_, lean_object* v___y_63_, lean_object* v___y_64_, lean_object* v___y_65_, lean_object* v___y_66_){
_start:
{
lean_object* v___x_68_; 
v___x_68_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg(v_mvarId_57_, v_x_58_, v___y_59_, v___y_60_, v___y_61_, v___y_62_, v___y_63_, v___y_64_, v___y_65_, v___y_66_);
return v___x_68_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___boxed(lean_object* v_00_u03b1_69_, lean_object* v_mvarId_70_, lean_object* v_x_71_, lean_object* v___y_72_, lean_object* v___y_73_, lean_object* v___y_74_, lean_object* v___y_75_, lean_object* v___y_76_, lean_object* v___y_77_, lean_object* v___y_78_, lean_object* v___y_79_, lean_object* v___y_80_){
_start:
{
lean_object* v_res_81_; 
v_res_81_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3(v_00_u03b1_69_, v_mvarId_70_, v_x_71_, v___y_72_, v___y_73_, v___y_74_, v___y_75_, v___y_76_, v___y_77_, v___y_78_, v___y_79_);
lean_dec(v___y_79_);
lean_dec_ref(v___y_78_);
lean_dec(v___y_77_);
lean_dec_ref(v___y_76_);
lean_dec(v___y_75_);
lean_dec_ref(v___y_74_);
lean_dec(v___y_73_);
lean_dec_ref(v___y_72_);
return v_res_81_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0(lean_object* v_x_84_, lean_object* v___y_85_, lean_object* v___y_86_, lean_object* v___y_87_, lean_object* v___y_88_, lean_object* v___y_89_, lean_object* v___y_90_, lean_object* v___y_91_, lean_object* v___y_92_, lean_object* v___y_93_){
_start:
{
lean_object* v___x_95_; lean_object* v___x_96_; 
v___x_95_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0___closed__0));
v___x_96_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_96_, 0, v___x_95_);
return v___x_96_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0___boxed(lean_object* v_x_97_, lean_object* v___y_98_, lean_object* v___y_99_, lean_object* v___y_100_, lean_object* v___y_101_, lean_object* v___y_102_, lean_object* v___y_103_, lean_object* v___y_104_, lean_object* v___y_105_, lean_object* v___y_106_, lean_object* v___y_107_){
_start:
{
lean_object* v_res_108_; 
v_res_108_ = l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__0(v_x_97_, v___y_98_, v___y_99_, v___y_100_, v___y_101_, v___y_102_, v___y_103_, v___y_104_, v___y_105_, v___y_106_);
lean_dec(v___y_106_);
lean_dec_ref(v___y_105_);
lean_dec(v___y_104_);
lean_dec_ref(v___y_103_);
lean_dec(v___y_102_);
lean_dec_ref(v___y_101_);
lean_dec(v___y_100_);
lean_dec_ref(v___y_99_);
lean_dec(v___y_98_);
lean_dec_ref(v_x_97_);
return v_res_108_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__1(lean_object* v_a_109_, lean_object* v___x_110_, lean_object* v_x_111_, lean_object* v___y_112_, lean_object* v___y_113_, lean_object* v___y_114_, lean_object* v___y_115_, lean_object* v___y_116_, lean_object* v___y_117_, lean_object* v___y_118_, lean_object* v___y_119_, lean_object* v___y_120_, lean_object* v___y_121_){
_start:
{
lean_object* v___x_123_; 
lean_inc_ref(v___y_112_);
v___x_123_ = l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteSimproc(v___y_112_, v___y_113_, v___y_114_, v___y_115_, v___y_116_, v___y_117_, v___y_118_, v___y_119_, v___y_120_, v___y_121_);
if (lean_obj_tag(v___x_123_) == 0)
{
lean_object* v_a_124_; 
v_a_124_ = lean_ctor_get(v___x_123_, 0);
lean_inc(v_a_124_);
if (lean_obj_tag(v_a_124_) == 0)
{
uint8_t v_done_125_; 
v_done_125_ = lean_ctor_get_uint8(v_a_124_, 0);
if (v_done_125_ == 0)
{
uint8_t v_contextDependent_126_; lean_object* v___x_127_; 
lean_dec_ref_known(v___x_123_, 1);
v_contextDependent_126_ = lean_ctor_get_uint8(v_a_124_, 1);
lean_dec_ref_known(v_a_124_, 0);
v___x_127_ = l_Lean_Meta_Sym_Simp_Theorems_rewrite(v_a_109_, v___x_110_, v___y_112_, v___y_113_, v___y_114_, v___y_115_, v___y_116_, v___y_117_, v___y_118_, v___y_119_, v___y_120_, v___y_121_);
if (lean_obj_tag(v___x_127_) == 0)
{
lean_object* v_a_128_; uint8_t v___y_130_; 
v_a_128_ = lean_ctor_get(v___x_127_, 0);
lean_inc(v_a_128_);
if (v_contextDependent_126_ == 0)
{
lean_dec(v_a_128_);
return v___x_127_;
}
else
{
if (lean_obj_tag(v_a_128_) == 0)
{
uint8_t v_contextDependent_140_; 
v_contextDependent_140_ = lean_ctor_get_uint8(v_a_128_, 1);
v___y_130_ = v_contextDependent_140_;
goto v___jp_129_;
}
else
{
uint8_t v_contextDependent_141_; 
v_contextDependent_141_ = lean_ctor_get_uint8(v_a_128_, sizeof(void*)*2 + 1);
v___y_130_ = v_contextDependent_141_;
goto v___jp_129_;
}
}
v___jp_129_:
{
if (v___y_130_ == 0)
{
lean_object* v___x_132_; uint8_t v_isShared_133_; uint8_t v_isSharedCheck_138_; 
v_isSharedCheck_138_ = !lean_is_exclusive(v___x_127_);
if (v_isSharedCheck_138_ == 0)
{
lean_object* v_unused_139_; 
v_unused_139_ = lean_ctor_get(v___x_127_, 0);
lean_dec(v_unused_139_);
v___x_132_ = v___x_127_;
v_isShared_133_ = v_isSharedCheck_138_;
goto v_resetjp_131_;
}
else
{
lean_dec(v___x_127_);
v___x_132_ = lean_box(0);
v_isShared_133_ = v_isSharedCheck_138_;
goto v_resetjp_131_;
}
v_resetjp_131_:
{
lean_object* v___x_134_; lean_object* v___x_136_; 
v___x_134_ = l_Lean_Meta_Sym_Simp_Result_withContextDependent(v_a_128_);
if (v_isShared_133_ == 0)
{
lean_ctor_set(v___x_132_, 0, v___x_134_);
v___x_136_ = v___x_132_;
goto v_reusejp_135_;
}
else
{
lean_object* v_reuseFailAlloc_137_; 
v_reuseFailAlloc_137_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_137_, 0, v___x_134_);
v___x_136_ = v_reuseFailAlloc_137_;
goto v_reusejp_135_;
}
v_reusejp_135_:
{
return v___x_136_;
}
}
}
else
{
lean_dec(v_a_128_);
return v___x_127_;
}
}
}
else
{
return v___x_127_;
}
}
else
{
lean_dec_ref_known(v_a_124_, 0);
lean_dec_ref(v___y_112_);
lean_dec_ref(v___x_110_);
return v___x_123_;
}
}
else
{
uint8_t v_done_142_; 
v_done_142_ = lean_ctor_get_uint8(v_a_124_, sizeof(void*)*2);
if (v_done_142_ == 0)
{
lean_object* v_e_x27_143_; lean_object* v_proof_144_; uint8_t v_contextDependent_145_; lean_object* v___x_147_; uint8_t v_isShared_148_; uint8_t v_isSharedCheck_195_; 
lean_dec_ref_known(v___x_123_, 1);
v_e_x27_143_ = lean_ctor_get(v_a_124_, 0);
v_proof_144_ = lean_ctor_get(v_a_124_, 1);
v_contextDependent_145_ = lean_ctor_get_uint8(v_a_124_, sizeof(void*)*2 + 1);
v_isSharedCheck_195_ = !lean_is_exclusive(v_a_124_);
if (v_isSharedCheck_195_ == 0)
{
v___x_147_ = v_a_124_;
v_isShared_148_ = v_isSharedCheck_195_;
goto v_resetjp_146_;
}
else
{
lean_inc(v_proof_144_);
lean_inc(v_e_x27_143_);
lean_dec(v_a_124_);
v___x_147_ = lean_box(0);
v_isShared_148_ = v_isSharedCheck_195_;
goto v_resetjp_146_;
}
v_resetjp_146_:
{
lean_object* v___x_149_; 
lean_inc_ref(v_e_x27_143_);
v___x_149_ = l_Lean_Meta_Sym_Simp_Theorems_rewrite(v_a_109_, v___x_110_, v_e_x27_143_, v___y_113_, v___y_114_, v___y_115_, v___y_116_, v___y_117_, v___y_118_, v___y_119_, v___y_120_, v___y_121_);
if (lean_obj_tag(v___x_149_) == 0)
{
lean_object* v_a_150_; lean_object* v___x_152_; uint8_t v_isShared_153_; uint8_t v_isSharedCheck_194_; 
v_a_150_ = lean_ctor_get(v___x_149_, 0);
v_isSharedCheck_194_ = !lean_is_exclusive(v___x_149_);
if (v_isSharedCheck_194_ == 0)
{
v___x_152_ = v___x_149_;
v_isShared_153_ = v_isSharedCheck_194_;
goto v_resetjp_151_;
}
else
{
lean_inc(v_a_150_);
lean_dec(v___x_149_);
v___x_152_ = lean_box(0);
v_isShared_153_ = v_isSharedCheck_194_;
goto v_resetjp_151_;
}
v_resetjp_151_:
{
if (lean_obj_tag(v_a_150_) == 0)
{
uint8_t v_done_154_; uint8_t v_contextDependent_155_; uint8_t v___y_157_; 
lean_dec_ref(v___y_112_);
v_done_154_ = lean_ctor_get_uint8(v_a_150_, 0);
v_contextDependent_155_ = lean_ctor_get_uint8(v_a_150_, 1);
lean_dec_ref_known(v_a_150_, 0);
if (v_contextDependent_145_ == 0)
{
v___y_157_ = v_contextDependent_155_;
goto v___jp_156_;
}
else
{
v___y_157_ = v_contextDependent_145_;
goto v___jp_156_;
}
v___jp_156_:
{
lean_object* v___x_159_; 
if (v_isShared_148_ == 0)
{
v___x_159_ = v___x_147_;
goto v_reusejp_158_;
}
else
{
lean_object* v_reuseFailAlloc_163_; 
v_reuseFailAlloc_163_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_163_, 0, v_e_x27_143_);
lean_ctor_set(v_reuseFailAlloc_163_, 1, v_proof_144_);
v___x_159_ = v_reuseFailAlloc_163_;
goto v_reusejp_158_;
}
v_reusejp_158_:
{
lean_object* v___x_161_; 
lean_ctor_set_uint8(v___x_159_, sizeof(void*)*2, v_done_154_);
lean_ctor_set_uint8(v___x_159_, sizeof(void*)*2 + 1, v___y_157_);
if (v_isShared_153_ == 0)
{
lean_ctor_set(v___x_152_, 0, v___x_159_);
v___x_161_ = v___x_152_;
goto v_reusejp_160_;
}
else
{
lean_object* v_reuseFailAlloc_162_; 
v_reuseFailAlloc_162_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_162_, 0, v___x_159_);
v___x_161_ = v_reuseFailAlloc_162_;
goto v_reusejp_160_;
}
v_reusejp_160_:
{
return v___x_161_;
}
}
}
}
else
{
lean_object* v_e_x27_164_; lean_object* v_proof_165_; uint8_t v_done_166_; uint8_t v_contextDependent_167_; lean_object* v___x_169_; uint8_t v_isShared_170_; uint8_t v_isSharedCheck_193_; 
lean_del_object(v___x_152_);
lean_del_object(v___x_147_);
v_e_x27_164_ = lean_ctor_get(v_a_150_, 0);
v_proof_165_ = lean_ctor_get(v_a_150_, 1);
v_done_166_ = lean_ctor_get_uint8(v_a_150_, sizeof(void*)*2);
v_contextDependent_167_ = lean_ctor_get_uint8(v_a_150_, sizeof(void*)*2 + 1);
v_isSharedCheck_193_ = !lean_is_exclusive(v_a_150_);
if (v_isSharedCheck_193_ == 0)
{
v___x_169_ = v_a_150_;
v_isShared_170_ = v_isSharedCheck_193_;
goto v_resetjp_168_;
}
else
{
lean_inc(v_proof_165_);
lean_inc(v_e_x27_164_);
lean_dec(v_a_150_);
v___x_169_ = lean_box(0);
v_isShared_170_ = v_isSharedCheck_193_;
goto v_resetjp_168_;
}
v_resetjp_168_:
{
lean_object* v___x_171_; 
lean_inc_ref(v_e_x27_164_);
v___x_171_ = l_Lean_Meta_Sym_Simp_mkEqTrans(v___y_112_, v_e_x27_143_, v_proof_144_, v_e_x27_164_, v_proof_165_, v___y_116_, v___y_117_, v___y_118_, v___y_119_, v___y_120_, v___y_121_);
if (lean_obj_tag(v___x_171_) == 0)
{
lean_object* v_a_172_; lean_object* v___x_174_; uint8_t v_isShared_175_; uint8_t v_isSharedCheck_184_; 
v_a_172_ = lean_ctor_get(v___x_171_, 0);
v_isSharedCheck_184_ = !lean_is_exclusive(v___x_171_);
if (v_isSharedCheck_184_ == 0)
{
v___x_174_ = v___x_171_;
v_isShared_175_ = v_isSharedCheck_184_;
goto v_resetjp_173_;
}
else
{
lean_inc(v_a_172_);
lean_dec(v___x_171_);
v___x_174_ = lean_box(0);
v_isShared_175_ = v_isSharedCheck_184_;
goto v_resetjp_173_;
}
v_resetjp_173_:
{
uint8_t v___y_177_; 
if (v_contextDependent_145_ == 0)
{
v___y_177_ = v_contextDependent_167_;
goto v___jp_176_;
}
else
{
v___y_177_ = v_contextDependent_145_;
goto v___jp_176_;
}
v___jp_176_:
{
lean_object* v___x_179_; 
if (v_isShared_170_ == 0)
{
lean_ctor_set(v___x_169_, 1, v_a_172_);
v___x_179_ = v___x_169_;
goto v_reusejp_178_;
}
else
{
lean_object* v_reuseFailAlloc_183_; 
v_reuseFailAlloc_183_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_183_, 0, v_e_x27_164_);
lean_ctor_set(v_reuseFailAlloc_183_, 1, v_a_172_);
lean_ctor_set_uint8(v_reuseFailAlloc_183_, sizeof(void*)*2, v_done_166_);
v___x_179_ = v_reuseFailAlloc_183_;
goto v_reusejp_178_;
}
v_reusejp_178_:
{
lean_object* v___x_181_; 
lean_ctor_set_uint8(v___x_179_, sizeof(void*)*2 + 1, v___y_177_);
if (v_isShared_175_ == 0)
{
lean_ctor_set(v___x_174_, 0, v___x_179_);
v___x_181_ = v___x_174_;
goto v_reusejp_180_;
}
else
{
lean_object* v_reuseFailAlloc_182_; 
v_reuseFailAlloc_182_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_182_, 0, v___x_179_);
v___x_181_ = v_reuseFailAlloc_182_;
goto v_reusejp_180_;
}
v_reusejp_180_:
{
return v___x_181_;
}
}
}
}
}
else
{
lean_object* v_a_185_; lean_object* v___x_187_; uint8_t v_isShared_188_; uint8_t v_isSharedCheck_192_; 
lean_del_object(v___x_169_);
lean_dec_ref(v_e_x27_164_);
v_a_185_ = lean_ctor_get(v___x_171_, 0);
v_isSharedCheck_192_ = !lean_is_exclusive(v___x_171_);
if (v_isSharedCheck_192_ == 0)
{
v___x_187_ = v___x_171_;
v_isShared_188_ = v_isSharedCheck_192_;
goto v_resetjp_186_;
}
else
{
lean_inc(v_a_185_);
lean_dec(v___x_171_);
v___x_187_ = lean_box(0);
v_isShared_188_ = v_isSharedCheck_192_;
goto v_resetjp_186_;
}
v_resetjp_186_:
{
lean_object* v___x_190_; 
if (v_isShared_188_ == 0)
{
v___x_190_ = v___x_187_;
goto v_reusejp_189_;
}
else
{
lean_object* v_reuseFailAlloc_191_; 
v_reuseFailAlloc_191_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_191_, 0, v_a_185_);
v___x_190_ = v_reuseFailAlloc_191_;
goto v_reusejp_189_;
}
v_reusejp_189_:
{
return v___x_190_;
}
}
}
}
}
}
}
else
{
lean_del_object(v___x_147_);
lean_dec_ref(v_proof_144_);
lean_dec_ref(v_e_x27_143_);
lean_dec_ref(v___y_112_);
return v___x_149_;
}
}
}
else
{
lean_dec_ref_known(v_a_124_, 2);
lean_dec_ref(v___y_112_);
lean_dec_ref(v___x_110_);
return v___x_123_;
}
}
}
else
{
lean_dec_ref(v___y_112_);
lean_dec_ref(v___x_110_);
return v___x_123_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__1___boxed(lean_object* v_a_196_, lean_object* v___x_197_, lean_object* v_x_198_, lean_object* v___y_199_, lean_object* v___y_200_, lean_object* v___y_201_, lean_object* v___y_202_, lean_object* v___y_203_, lean_object* v___y_204_, lean_object* v___y_205_, lean_object* v___y_206_, lean_object* v___y_207_, lean_object* v___y_208_, lean_object* v___y_209_){
_start:
{
lean_object* v_res_210_; 
v_res_210_ = l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__1(v_a_196_, v___x_197_, v_x_198_, v___y_199_, v___y_200_, v___y_201_, v___y_202_, v___y_203_, v___y_204_, v___y_205_, v___y_206_, v___y_207_, v___y_208_);
lean_dec(v___y_208_);
lean_dec_ref(v___y_207_);
lean_dec(v___y_206_);
lean_dec_ref(v___y_205_);
lean_dec(v___y_204_);
lean_dec_ref(v___y_203_);
lean_dec(v___y_202_);
lean_dec_ref(v___y_201_);
lean_dec(v___y_200_);
lean_dec_ref(v_a_196_);
return v_res_210_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__2(lean_object* v___x_211_, lean_object* v___f_212_, lean_object* v___y_213_, lean_object* v___y_214_, lean_object* v___y_215_, lean_object* v___y_216_, lean_object* v___y_217_, lean_object* v___y_218_, lean_object* v___y_219_, lean_object* v___y_220_, lean_object* v___y_221_, lean_object* v___y_222_){
_start:
{
lean_object* v___x_224_; 
lean_inc_ref(v___y_213_);
v___x_224_ = l_Lean_Meta_Sym_Simp_evalGround___redArg(v___x_211_, v___y_213_, v___y_217_, v___y_218_, v___y_219_, v___y_220_, v___y_221_, v___y_222_);
if (lean_obj_tag(v___x_224_) == 0)
{
lean_object* v_a_225_; lean_object* v___x_226_; 
v_a_225_ = lean_ctor_get(v___x_224_, 0);
lean_inc(v_a_225_);
v___x_226_ = lean_box(0);
if (lean_obj_tag(v_a_225_) == 0)
{
uint8_t v_done_227_; 
v_done_227_ = lean_ctor_get_uint8(v_a_225_, 0);
if (v_done_227_ == 0)
{
uint8_t v_contextDependent_228_; lean_object* v___x_229_; 
lean_dec_ref_known(v___x_224_, 1);
v_contextDependent_228_ = lean_ctor_get_uint8(v_a_225_, 1);
lean_dec_ref_known(v_a_225_, 0);
v___x_229_ = lean_apply_12(v___f_212_, v___x_226_, v___y_213_, v___y_214_, v___y_215_, v___y_216_, v___y_217_, v___y_218_, v___y_219_, v___y_220_, v___y_221_, v___y_222_, lean_box(0));
if (lean_obj_tag(v___x_229_) == 0)
{
lean_object* v_a_230_; uint8_t v___y_232_; 
v_a_230_ = lean_ctor_get(v___x_229_, 0);
lean_inc(v_a_230_);
if (v_contextDependent_228_ == 0)
{
lean_dec(v_a_230_);
return v___x_229_;
}
else
{
if (lean_obj_tag(v_a_230_) == 0)
{
uint8_t v_contextDependent_242_; 
v_contextDependent_242_ = lean_ctor_get_uint8(v_a_230_, 1);
v___y_232_ = v_contextDependent_242_;
goto v___jp_231_;
}
else
{
uint8_t v_contextDependent_243_; 
v_contextDependent_243_ = lean_ctor_get_uint8(v_a_230_, sizeof(void*)*2 + 1);
v___y_232_ = v_contextDependent_243_;
goto v___jp_231_;
}
}
v___jp_231_:
{
if (v___y_232_ == 0)
{
lean_object* v___x_234_; uint8_t v_isShared_235_; uint8_t v_isSharedCheck_240_; 
v_isSharedCheck_240_ = !lean_is_exclusive(v___x_229_);
if (v_isSharedCheck_240_ == 0)
{
lean_object* v_unused_241_; 
v_unused_241_ = lean_ctor_get(v___x_229_, 0);
lean_dec(v_unused_241_);
v___x_234_ = v___x_229_;
v_isShared_235_ = v_isSharedCheck_240_;
goto v_resetjp_233_;
}
else
{
lean_dec(v___x_229_);
v___x_234_ = lean_box(0);
v_isShared_235_ = v_isSharedCheck_240_;
goto v_resetjp_233_;
}
v_resetjp_233_:
{
lean_object* v___x_236_; lean_object* v___x_238_; 
v___x_236_ = l_Lean_Meta_Sym_Simp_Result_withContextDependent(v_a_230_);
if (v_isShared_235_ == 0)
{
lean_ctor_set(v___x_234_, 0, v___x_236_);
v___x_238_ = v___x_234_;
goto v_reusejp_237_;
}
else
{
lean_object* v_reuseFailAlloc_239_; 
v_reuseFailAlloc_239_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_239_, 0, v___x_236_);
v___x_238_ = v_reuseFailAlloc_239_;
goto v_reusejp_237_;
}
v_reusejp_237_:
{
return v___x_238_;
}
}
}
else
{
lean_dec(v_a_230_);
return v___x_229_;
}
}
}
else
{
return v___x_229_;
}
}
else
{
lean_dec_ref_known(v_a_225_, 0);
lean_dec(v___y_222_);
lean_dec_ref(v___y_221_);
lean_dec(v___y_220_);
lean_dec_ref(v___y_219_);
lean_dec(v___y_218_);
lean_dec_ref(v___y_217_);
lean_dec(v___y_216_);
lean_dec_ref(v___y_215_);
lean_dec(v___y_214_);
lean_dec_ref(v___y_213_);
lean_dec_ref(v___f_212_);
return v___x_224_;
}
}
else
{
uint8_t v_done_244_; 
v_done_244_ = lean_ctor_get_uint8(v_a_225_, sizeof(void*)*2);
if (v_done_244_ == 0)
{
lean_object* v_e_x27_245_; lean_object* v_proof_246_; uint8_t v_contextDependent_247_; lean_object* v___x_249_; uint8_t v_isShared_250_; uint8_t v_isSharedCheck_297_; 
lean_dec_ref_known(v___x_224_, 1);
v_e_x27_245_ = lean_ctor_get(v_a_225_, 0);
v_proof_246_ = lean_ctor_get(v_a_225_, 1);
v_contextDependent_247_ = lean_ctor_get_uint8(v_a_225_, sizeof(void*)*2 + 1);
v_isSharedCheck_297_ = !lean_is_exclusive(v_a_225_);
if (v_isSharedCheck_297_ == 0)
{
v___x_249_ = v_a_225_;
v_isShared_250_ = v_isSharedCheck_297_;
goto v_resetjp_248_;
}
else
{
lean_inc(v_proof_246_);
lean_inc(v_e_x27_245_);
lean_dec(v_a_225_);
v___x_249_ = lean_box(0);
v_isShared_250_ = v_isSharedCheck_297_;
goto v_resetjp_248_;
}
v_resetjp_248_:
{
lean_object* v___x_251_; 
lean_inc(v___y_222_);
lean_inc_ref(v___y_221_);
lean_inc(v___y_220_);
lean_inc_ref(v___y_219_);
lean_inc(v___y_218_);
lean_inc_ref(v___y_217_);
lean_inc_ref(v_e_x27_245_);
v___x_251_ = lean_apply_12(v___f_212_, v___x_226_, v_e_x27_245_, v___y_214_, v___y_215_, v___y_216_, v___y_217_, v___y_218_, v___y_219_, v___y_220_, v___y_221_, v___y_222_, lean_box(0));
if (lean_obj_tag(v___x_251_) == 0)
{
lean_object* v_a_252_; lean_object* v___x_254_; uint8_t v_isShared_255_; uint8_t v_isSharedCheck_296_; 
v_a_252_ = lean_ctor_get(v___x_251_, 0);
v_isSharedCheck_296_ = !lean_is_exclusive(v___x_251_);
if (v_isSharedCheck_296_ == 0)
{
v___x_254_ = v___x_251_;
v_isShared_255_ = v_isSharedCheck_296_;
goto v_resetjp_253_;
}
else
{
lean_inc(v_a_252_);
lean_dec(v___x_251_);
v___x_254_ = lean_box(0);
v_isShared_255_ = v_isSharedCheck_296_;
goto v_resetjp_253_;
}
v_resetjp_253_:
{
if (lean_obj_tag(v_a_252_) == 0)
{
uint8_t v_done_256_; uint8_t v_contextDependent_257_; uint8_t v___y_259_; 
lean_dec(v___y_222_);
lean_dec_ref(v___y_221_);
lean_dec(v___y_220_);
lean_dec_ref(v___y_219_);
lean_dec(v___y_218_);
lean_dec_ref(v___y_217_);
lean_dec_ref(v___y_213_);
v_done_256_ = lean_ctor_get_uint8(v_a_252_, 0);
v_contextDependent_257_ = lean_ctor_get_uint8(v_a_252_, 1);
lean_dec_ref_known(v_a_252_, 0);
if (v_contextDependent_247_ == 0)
{
v___y_259_ = v_contextDependent_257_;
goto v___jp_258_;
}
else
{
v___y_259_ = v_contextDependent_247_;
goto v___jp_258_;
}
v___jp_258_:
{
lean_object* v___x_261_; 
if (v_isShared_250_ == 0)
{
v___x_261_ = v___x_249_;
goto v_reusejp_260_;
}
else
{
lean_object* v_reuseFailAlloc_265_; 
v_reuseFailAlloc_265_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_265_, 0, v_e_x27_245_);
lean_ctor_set(v_reuseFailAlloc_265_, 1, v_proof_246_);
v___x_261_ = v_reuseFailAlloc_265_;
goto v_reusejp_260_;
}
v_reusejp_260_:
{
lean_object* v___x_263_; 
lean_ctor_set_uint8(v___x_261_, sizeof(void*)*2, v_done_256_);
lean_ctor_set_uint8(v___x_261_, sizeof(void*)*2 + 1, v___y_259_);
if (v_isShared_255_ == 0)
{
lean_ctor_set(v___x_254_, 0, v___x_261_);
v___x_263_ = v___x_254_;
goto v_reusejp_262_;
}
else
{
lean_object* v_reuseFailAlloc_264_; 
v_reuseFailAlloc_264_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_264_, 0, v___x_261_);
v___x_263_ = v_reuseFailAlloc_264_;
goto v_reusejp_262_;
}
v_reusejp_262_:
{
return v___x_263_;
}
}
}
}
else
{
lean_object* v_e_x27_266_; lean_object* v_proof_267_; uint8_t v_done_268_; uint8_t v_contextDependent_269_; lean_object* v___x_271_; uint8_t v_isShared_272_; uint8_t v_isSharedCheck_295_; 
lean_del_object(v___x_254_);
lean_del_object(v___x_249_);
v_e_x27_266_ = lean_ctor_get(v_a_252_, 0);
v_proof_267_ = lean_ctor_get(v_a_252_, 1);
v_done_268_ = lean_ctor_get_uint8(v_a_252_, sizeof(void*)*2);
v_contextDependent_269_ = lean_ctor_get_uint8(v_a_252_, sizeof(void*)*2 + 1);
v_isSharedCheck_295_ = !lean_is_exclusive(v_a_252_);
if (v_isSharedCheck_295_ == 0)
{
v___x_271_ = v_a_252_;
v_isShared_272_ = v_isSharedCheck_295_;
goto v_resetjp_270_;
}
else
{
lean_inc(v_proof_267_);
lean_inc(v_e_x27_266_);
lean_dec(v_a_252_);
v___x_271_ = lean_box(0);
v_isShared_272_ = v_isSharedCheck_295_;
goto v_resetjp_270_;
}
v_resetjp_270_:
{
lean_object* v___x_273_; 
lean_inc_ref(v_e_x27_266_);
v___x_273_ = l_Lean_Meta_Sym_Simp_mkEqTrans(v___y_213_, v_e_x27_245_, v_proof_246_, v_e_x27_266_, v_proof_267_, v___y_217_, v___y_218_, v___y_219_, v___y_220_, v___y_221_, v___y_222_);
lean_dec(v___y_222_);
lean_dec_ref(v___y_221_);
lean_dec(v___y_220_);
lean_dec_ref(v___y_219_);
lean_dec(v___y_218_);
lean_dec_ref(v___y_217_);
if (lean_obj_tag(v___x_273_) == 0)
{
lean_object* v_a_274_; lean_object* v___x_276_; uint8_t v_isShared_277_; uint8_t v_isSharedCheck_286_; 
v_a_274_ = lean_ctor_get(v___x_273_, 0);
v_isSharedCheck_286_ = !lean_is_exclusive(v___x_273_);
if (v_isSharedCheck_286_ == 0)
{
v___x_276_ = v___x_273_;
v_isShared_277_ = v_isSharedCheck_286_;
goto v_resetjp_275_;
}
else
{
lean_inc(v_a_274_);
lean_dec(v___x_273_);
v___x_276_ = lean_box(0);
v_isShared_277_ = v_isSharedCheck_286_;
goto v_resetjp_275_;
}
v_resetjp_275_:
{
uint8_t v___y_279_; 
if (v_contextDependent_247_ == 0)
{
v___y_279_ = v_contextDependent_269_;
goto v___jp_278_;
}
else
{
v___y_279_ = v_contextDependent_247_;
goto v___jp_278_;
}
v___jp_278_:
{
lean_object* v___x_281_; 
if (v_isShared_272_ == 0)
{
lean_ctor_set(v___x_271_, 1, v_a_274_);
v___x_281_ = v___x_271_;
goto v_reusejp_280_;
}
else
{
lean_object* v_reuseFailAlloc_285_; 
v_reuseFailAlloc_285_ = lean_alloc_ctor(1, 2, 2);
lean_ctor_set(v_reuseFailAlloc_285_, 0, v_e_x27_266_);
lean_ctor_set(v_reuseFailAlloc_285_, 1, v_a_274_);
lean_ctor_set_uint8(v_reuseFailAlloc_285_, sizeof(void*)*2, v_done_268_);
v___x_281_ = v_reuseFailAlloc_285_;
goto v_reusejp_280_;
}
v_reusejp_280_:
{
lean_object* v___x_283_; 
lean_ctor_set_uint8(v___x_281_, sizeof(void*)*2 + 1, v___y_279_);
if (v_isShared_277_ == 0)
{
lean_ctor_set(v___x_276_, 0, v___x_281_);
v___x_283_ = v___x_276_;
goto v_reusejp_282_;
}
else
{
lean_object* v_reuseFailAlloc_284_; 
v_reuseFailAlloc_284_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_284_, 0, v___x_281_);
v___x_283_ = v_reuseFailAlloc_284_;
goto v_reusejp_282_;
}
v_reusejp_282_:
{
return v___x_283_;
}
}
}
}
}
else
{
lean_object* v_a_287_; lean_object* v___x_289_; uint8_t v_isShared_290_; uint8_t v_isSharedCheck_294_; 
lean_del_object(v___x_271_);
lean_dec_ref(v_e_x27_266_);
v_a_287_ = lean_ctor_get(v___x_273_, 0);
v_isSharedCheck_294_ = !lean_is_exclusive(v___x_273_);
if (v_isSharedCheck_294_ == 0)
{
v___x_289_ = v___x_273_;
v_isShared_290_ = v_isSharedCheck_294_;
goto v_resetjp_288_;
}
else
{
lean_inc(v_a_287_);
lean_dec(v___x_273_);
v___x_289_ = lean_box(0);
v_isShared_290_ = v_isSharedCheck_294_;
goto v_resetjp_288_;
}
v_resetjp_288_:
{
lean_object* v___x_292_; 
if (v_isShared_290_ == 0)
{
v___x_292_ = v___x_289_;
goto v_reusejp_291_;
}
else
{
lean_object* v_reuseFailAlloc_293_; 
v_reuseFailAlloc_293_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_293_, 0, v_a_287_);
v___x_292_ = v_reuseFailAlloc_293_;
goto v_reusejp_291_;
}
v_reusejp_291_:
{
return v___x_292_;
}
}
}
}
}
}
}
else
{
lean_del_object(v___x_249_);
lean_dec_ref(v_proof_246_);
lean_dec_ref(v_e_x27_245_);
lean_dec(v___y_222_);
lean_dec_ref(v___y_221_);
lean_dec(v___y_220_);
lean_dec_ref(v___y_219_);
lean_dec(v___y_218_);
lean_dec_ref(v___y_217_);
lean_dec_ref(v___y_213_);
return v___x_251_;
}
}
}
else
{
lean_dec_ref_known(v_a_225_, 2);
lean_dec(v___y_222_);
lean_dec_ref(v___y_221_);
lean_dec(v___y_220_);
lean_dec_ref(v___y_219_);
lean_dec(v___y_218_);
lean_dec_ref(v___y_217_);
lean_dec(v___y_216_);
lean_dec_ref(v___y_215_);
lean_dec(v___y_214_);
lean_dec_ref(v___y_213_);
lean_dec_ref(v___f_212_);
return v___x_224_;
}
}
}
else
{
lean_dec(v___y_222_);
lean_dec_ref(v___y_221_);
lean_dec(v___y_220_);
lean_dec_ref(v___y_219_);
lean_dec(v___y_218_);
lean_dec_ref(v___y_217_);
lean_dec(v___y_216_);
lean_dec_ref(v___y_215_);
lean_dec(v___y_214_);
lean_dec_ref(v___y_213_);
lean_dec_ref(v___f_212_);
return v___x_224_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__2___boxed(lean_object* v___x_298_, lean_object* v___f_299_, lean_object* v___y_300_, lean_object* v___y_301_, lean_object* v___y_302_, lean_object* v___y_303_, lean_object* v___y_304_, lean_object* v___y_305_, lean_object* v___y_306_, lean_object* v___y_307_, lean_object* v___y_308_, lean_object* v___y_309_, lean_object* v___y_310_){
_start:
{
lean_object* v_res_311_; 
v_res_311_ = l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__2(v___x_298_, v___f_299_, v___y_300_, v___y_301_, v___y_302_, v___y_303_, v___y_304_, v___y_305_, v___y_306_, v___y_307_, v___y_308_, v___y_309_);
lean_dec(v___x_298_);
return v_res_311_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__3(uint8_t v___x_312_, lean_object* v___f_313_, lean_object* v_____r_314_, lean_object* v___y_315_, lean_object* v___y_316_, lean_object* v___y_317_, lean_object* v___y_318_, lean_object* v___y_319_, lean_object* v___y_320_, lean_object* v___y_321_, lean_object* v___y_322_){
_start:
{
lean_object* v___x_324_; lean_object* v_rewriteCache_325_; lean_object* v_acNfCache_326_; lean_object* v_typeAnalysis_327_; lean_object* v_goal_328_; lean_object* v_hypotheses_329_; lean_object* v___x_331_; uint8_t v_isShared_332_; uint8_t v_isSharedCheck_339_; 
v___x_324_ = lean_st_ref_take(v___y_316_);
v_rewriteCache_325_ = lean_ctor_get(v___x_324_, 0);
v_acNfCache_326_ = lean_ctor_get(v___x_324_, 1);
v_typeAnalysis_327_ = lean_ctor_get(v___x_324_, 2);
v_goal_328_ = lean_ctor_get(v___x_324_, 3);
v_hypotheses_329_ = lean_ctor_get(v___x_324_, 4);
v_isSharedCheck_339_ = !lean_is_exclusive(v___x_324_);
if (v_isSharedCheck_339_ == 0)
{
v___x_331_ = v___x_324_;
v_isShared_332_ = v_isSharedCheck_339_;
goto v_resetjp_330_;
}
else
{
lean_inc(v_hypotheses_329_);
lean_inc(v_goal_328_);
lean_inc(v_typeAnalysis_327_);
lean_inc(v_acNfCache_326_);
lean_inc(v_rewriteCache_325_);
lean_dec(v___x_324_);
v___x_331_ = lean_box(0);
v_isShared_332_ = v_isSharedCheck_339_;
goto v_resetjp_330_;
}
v_resetjp_330_:
{
lean_object* v___x_334_; 
if (v_isShared_332_ == 0)
{
v___x_334_ = v___x_331_;
goto v_reusejp_333_;
}
else
{
lean_object* v_reuseFailAlloc_338_; 
v_reuseFailAlloc_338_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_338_, 0, v_rewriteCache_325_);
lean_ctor_set(v_reuseFailAlloc_338_, 1, v_acNfCache_326_);
lean_ctor_set(v_reuseFailAlloc_338_, 2, v_typeAnalysis_327_);
lean_ctor_set(v_reuseFailAlloc_338_, 3, v_goal_328_);
lean_ctor_set(v_reuseFailAlloc_338_, 4, v_hypotheses_329_);
v___x_334_ = v_reuseFailAlloc_338_;
goto v_reusejp_333_;
}
v_reusejp_333_:
{
lean_object* v___x_335_; lean_object* v___x_336_; lean_object* v___x_337_; 
lean_ctor_set_uint8(v___x_334_, sizeof(void*)*5, v___x_312_);
v___x_335_ = lean_st_ref_set(v___y_316_, v___x_334_);
v___x_336_ = lean_box(0);
lean_inc(v___y_322_);
lean_inc_ref(v___y_321_);
lean_inc(v___y_320_);
lean_inc_ref(v___y_319_);
lean_inc(v___y_318_);
lean_inc_ref(v___y_317_);
lean_inc(v___y_316_);
lean_inc_ref(v___y_315_);
v___x_337_ = lean_apply_10(v___f_313_, v___x_336_, v___y_315_, v___y_316_, v___y_317_, v___y_318_, v___y_319_, v___y_320_, v___y_321_, v___y_322_, lean_box(0));
return v___x_337_;
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__3___boxed(lean_object* v___x_340_, lean_object* v___f_341_, lean_object* v_____r_342_, lean_object* v___y_343_, lean_object* v___y_344_, lean_object* v___y_345_, lean_object* v___y_346_, lean_object* v___y_347_, lean_object* v___y_348_, lean_object* v___y_349_, lean_object* v___y_350_, lean_object* v___y_351_){
_start:
{
uint8_t v___x_33702__boxed_352_; lean_object* v_res_353_; 
v___x_33702__boxed_352_ = lean_unbox(v___x_340_);
v_res_353_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__3(v___x_33702__boxed_352_, v___f_341_, v_____r_342_, v___y_343_, v___y_344_, v___y_345_, v___y_346_, v___y_347_, v___y_348_, v___y_349_, v___y_350_);
lean_dec(v___y_350_);
lean_dec_ref(v___y_349_);
lean_dec(v___y_348_);
lean_dec_ref(v___y_347_);
lean_dec(v___y_346_);
lean_dec_ref(v___y_345_);
lean_dec(v___y_344_);
lean_dec_ref(v___y_343_);
return v_res_353_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0_spec__0(lean_object* v_msgData_354_, lean_object* v___y_355_, lean_object* v___y_356_, lean_object* v___y_357_, lean_object* v___y_358_){
_start:
{
lean_object* v___x_360_; lean_object* v_env_361_; lean_object* v___x_362_; lean_object* v_mctx_363_; lean_object* v_lctx_364_; lean_object* v_options_365_; lean_object* v___x_366_; lean_object* v___x_367_; lean_object* v___x_368_; 
v___x_360_ = lean_st_ref_get(v___y_358_);
v_env_361_ = lean_ctor_get(v___x_360_, 0);
lean_inc_ref(v_env_361_);
lean_dec(v___x_360_);
v___x_362_ = lean_st_ref_get(v___y_356_);
v_mctx_363_ = lean_ctor_get(v___x_362_, 0);
lean_inc_ref(v_mctx_363_);
lean_dec(v___x_362_);
v_lctx_364_ = lean_ctor_get(v___y_355_, 2);
v_options_365_ = lean_ctor_get(v___y_357_, 2);
lean_inc_ref(v_options_365_);
lean_inc_ref(v_lctx_364_);
v___x_366_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_366_, 0, v_env_361_);
lean_ctor_set(v___x_366_, 1, v_mctx_363_);
lean_ctor_set(v___x_366_, 2, v_lctx_364_);
lean_ctor_set(v___x_366_, 3, v_options_365_);
v___x_367_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v___x_367_, 0, v___x_366_);
lean_ctor_set(v___x_367_, 1, v_msgData_354_);
v___x_368_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_368_, 0, v___x_367_);
return v___x_368_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0_spec__0___boxed(lean_object* v_msgData_369_, lean_object* v___y_370_, lean_object* v___y_371_, lean_object* v___y_372_, lean_object* v___y_373_, lean_object* v___y_374_){
_start:
{
lean_object* v_res_375_; 
v_res_375_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0_spec__0(v_msgData_369_, v___y_370_, v___y_371_, v___y_372_, v___y_373_);
lean_dec(v___y_373_);
lean_dec_ref(v___y_372_);
lean_dec(v___y_371_);
lean_dec_ref(v___y_370_);
return v_res_375_;
}
}
static double _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__0(void){
_start:
{
lean_object* v___x_376_; double v___x_377_; 
v___x_376_ = lean_unsigned_to_nat(0u);
v___x_377_ = lean_float_of_nat(v___x_376_);
return v___x_377_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg(lean_object* v_cls_381_, lean_object* v_msg_382_, lean_object* v___y_383_, lean_object* v___y_384_, lean_object* v___y_385_, lean_object* v___y_386_){
_start:
{
lean_object* v_ref_388_; lean_object* v___x_389_; lean_object* v_a_390_; lean_object* v___x_392_; uint8_t v_isShared_393_; uint8_t v_isSharedCheck_434_; 
v_ref_388_ = lean_ctor_get(v___y_385_, 5);
v___x_389_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0_spec__0(v_msg_382_, v___y_383_, v___y_384_, v___y_385_, v___y_386_);
v_a_390_ = lean_ctor_get(v___x_389_, 0);
v_isSharedCheck_434_ = !lean_is_exclusive(v___x_389_);
if (v_isSharedCheck_434_ == 0)
{
v___x_392_ = v___x_389_;
v_isShared_393_ = v_isSharedCheck_434_;
goto v_resetjp_391_;
}
else
{
lean_inc(v_a_390_);
lean_dec(v___x_389_);
v___x_392_ = lean_box(0);
v_isShared_393_ = v_isSharedCheck_434_;
goto v_resetjp_391_;
}
v_resetjp_391_:
{
lean_object* v___x_394_; lean_object* v_traceState_395_; lean_object* v_env_396_; lean_object* v_nextMacroScope_397_; lean_object* v_ngen_398_; lean_object* v_auxDeclNGen_399_; lean_object* v_cache_400_; lean_object* v_messages_401_; lean_object* v_infoState_402_; lean_object* v_snapshotTasks_403_; lean_object* v___x_405_; uint8_t v_isShared_406_; uint8_t v_isSharedCheck_433_; 
v___x_394_ = lean_st_ref_take(v___y_386_);
v_traceState_395_ = lean_ctor_get(v___x_394_, 4);
v_env_396_ = lean_ctor_get(v___x_394_, 0);
v_nextMacroScope_397_ = lean_ctor_get(v___x_394_, 1);
v_ngen_398_ = lean_ctor_get(v___x_394_, 2);
v_auxDeclNGen_399_ = lean_ctor_get(v___x_394_, 3);
v_cache_400_ = lean_ctor_get(v___x_394_, 5);
v_messages_401_ = lean_ctor_get(v___x_394_, 6);
v_infoState_402_ = lean_ctor_get(v___x_394_, 7);
v_snapshotTasks_403_ = lean_ctor_get(v___x_394_, 8);
v_isSharedCheck_433_ = !lean_is_exclusive(v___x_394_);
if (v_isSharedCheck_433_ == 0)
{
v___x_405_ = v___x_394_;
v_isShared_406_ = v_isSharedCheck_433_;
goto v_resetjp_404_;
}
else
{
lean_inc(v_snapshotTasks_403_);
lean_inc(v_infoState_402_);
lean_inc(v_messages_401_);
lean_inc(v_cache_400_);
lean_inc(v_traceState_395_);
lean_inc(v_auxDeclNGen_399_);
lean_inc(v_ngen_398_);
lean_inc(v_nextMacroScope_397_);
lean_inc(v_env_396_);
lean_dec(v___x_394_);
v___x_405_ = lean_box(0);
v_isShared_406_ = v_isSharedCheck_433_;
goto v_resetjp_404_;
}
v_resetjp_404_:
{
uint64_t v_tid_407_; lean_object* v_traces_408_; lean_object* v___x_410_; uint8_t v_isShared_411_; uint8_t v_isSharedCheck_432_; 
v_tid_407_ = lean_ctor_get_uint64(v_traceState_395_, sizeof(void*)*1);
v_traces_408_ = lean_ctor_get(v_traceState_395_, 0);
v_isSharedCheck_432_ = !lean_is_exclusive(v_traceState_395_);
if (v_isSharedCheck_432_ == 0)
{
v___x_410_ = v_traceState_395_;
v_isShared_411_ = v_isSharedCheck_432_;
goto v_resetjp_409_;
}
else
{
lean_inc(v_traces_408_);
lean_dec(v_traceState_395_);
v___x_410_ = lean_box(0);
v_isShared_411_ = v_isSharedCheck_432_;
goto v_resetjp_409_;
}
v_resetjp_409_:
{
lean_object* v___x_412_; double v___x_413_; uint8_t v___x_414_; lean_object* v___x_415_; lean_object* v___x_416_; lean_object* v___x_417_; lean_object* v___x_418_; lean_object* v___x_419_; lean_object* v___x_420_; lean_object* v___x_422_; 
v___x_412_ = lean_box(0);
v___x_413_ = lean_float_once(&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__0, &l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__0_once, _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__0);
v___x_414_ = 0;
v___x_415_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__1));
v___x_416_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v___x_416_, 0, v_cls_381_);
lean_ctor_set(v___x_416_, 1, v___x_412_);
lean_ctor_set(v___x_416_, 2, v___x_415_);
lean_ctor_set_float(v___x_416_, sizeof(void*)*3, v___x_413_);
lean_ctor_set_float(v___x_416_, sizeof(void*)*3 + 8, v___x_413_);
lean_ctor_set_uint8(v___x_416_, sizeof(void*)*3 + 16, v___x_414_);
v___x_417_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___closed__2));
v___x_418_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v___x_418_, 0, v___x_416_);
lean_ctor_set(v___x_418_, 1, v_a_390_);
lean_ctor_set(v___x_418_, 2, v___x_417_);
lean_inc(v_ref_388_);
v___x_419_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_419_, 0, v_ref_388_);
lean_ctor_set(v___x_419_, 1, v___x_418_);
v___x_420_ = l_Lean_PersistentArray_push___redArg(v_traces_408_, v___x_419_);
if (v_isShared_411_ == 0)
{
lean_ctor_set(v___x_410_, 0, v___x_420_);
v___x_422_ = v___x_410_;
goto v_reusejp_421_;
}
else
{
lean_object* v_reuseFailAlloc_431_; 
v_reuseFailAlloc_431_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_431_, 0, v___x_420_);
lean_ctor_set_uint64(v_reuseFailAlloc_431_, sizeof(void*)*1, v_tid_407_);
v___x_422_ = v_reuseFailAlloc_431_;
goto v_reusejp_421_;
}
v_reusejp_421_:
{
lean_object* v___x_424_; 
if (v_isShared_406_ == 0)
{
lean_ctor_set(v___x_405_, 4, v___x_422_);
v___x_424_ = v___x_405_;
goto v_reusejp_423_;
}
else
{
lean_object* v_reuseFailAlloc_430_; 
v_reuseFailAlloc_430_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_430_, 0, v_env_396_);
lean_ctor_set(v_reuseFailAlloc_430_, 1, v_nextMacroScope_397_);
lean_ctor_set(v_reuseFailAlloc_430_, 2, v_ngen_398_);
lean_ctor_set(v_reuseFailAlloc_430_, 3, v_auxDeclNGen_399_);
lean_ctor_set(v_reuseFailAlloc_430_, 4, v___x_422_);
lean_ctor_set(v_reuseFailAlloc_430_, 5, v_cache_400_);
lean_ctor_set(v_reuseFailAlloc_430_, 6, v_messages_401_);
lean_ctor_set(v_reuseFailAlloc_430_, 7, v_infoState_402_);
lean_ctor_set(v_reuseFailAlloc_430_, 8, v_snapshotTasks_403_);
v___x_424_ = v_reuseFailAlloc_430_;
goto v_reusejp_423_;
}
v_reusejp_423_:
{
lean_object* v___x_425_; lean_object* v___x_426_; lean_object* v___x_428_; 
v___x_425_ = lean_st_ref_set(v___y_386_, v___x_424_);
v___x_426_ = lean_box(0);
if (v_isShared_393_ == 0)
{
lean_ctor_set(v___x_392_, 0, v___x_426_);
v___x_428_ = v___x_392_;
goto v_reusejp_427_;
}
else
{
lean_object* v_reuseFailAlloc_429_; 
v_reuseFailAlloc_429_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_429_, 0, v___x_426_);
v___x_428_ = v_reuseFailAlloc_429_;
goto v_reusejp_427_;
}
v_reusejp_427_:
{
return v___x_428_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg___boxed(lean_object* v_cls_435_, lean_object* v_msg_436_, lean_object* v___y_437_, lean_object* v___y_438_, lean_object* v___y_439_, lean_object* v___y_440_, lean_object* v___y_441_){
_start:
{
lean_object* v_res_442_; 
v_res_442_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg(v_cls_435_, v_msg_436_, v___y_437_, v___y_438_, v___y_439_, v___y_440_);
lean_dec(v___y_440_);
lean_dec_ref(v___y_439_);
lean_dec(v___y_438_);
lean_dec_ref(v___y_437_);
return v_res_442_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__1(lean_object* v___x_443_, lean_object* v___y_444_, lean_object* v___y_445_, lean_object* v___y_446_, lean_object* v___y_447_, lean_object* v___y_448_, lean_object* v___y_449_, lean_object* v___y_450_, lean_object* v___y_451_, lean_object* v___y_452_, lean_object* v___y_453_){
_start:
{
lean_object* v___x_455_; 
lean_inc_ref(v___y_444_);
v___x_455_ = l_Lean_Meta_Sym_DSimp_evalGround___redArg(v___x_443_, v___y_444_, v___y_448_, v___y_449_, v___y_450_, v___y_451_, v___y_452_, v___y_453_);
if (lean_obj_tag(v___x_455_) == 0)
{
lean_object* v_a_456_; 
v_a_456_ = lean_ctor_get(v___x_455_, 0);
lean_inc(v_a_456_);
if (lean_obj_tag(v_a_456_) == 0)
{
uint8_t v_done_457_; 
v_done_457_ = lean_ctor_get_uint8(v_a_456_, 0);
lean_dec_ref_known(v_a_456_, 0);
if (v_done_457_ == 0)
{
lean_object* v___x_458_; 
lean_dec_ref_known(v___x_455_, 1);
v___x_458_ = l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteDsimproc___redArg(v___y_444_, v___y_448_, v___y_449_, v___y_450_, v___y_451_, v___y_452_, v___y_453_);
return v___x_458_;
}
else
{
lean_dec_ref(v___y_444_);
return v___x_455_;
}
}
else
{
uint8_t v_done_459_; 
lean_dec_ref(v___y_444_);
v_done_459_ = lean_ctor_get_uint8(v_a_456_, sizeof(void*)*1);
if (v_done_459_ == 0)
{
lean_object* v_e_x27_460_; lean_object* v___x_462_; uint8_t v_isShared_463_; uint8_t v_isSharedCheck_478_; 
lean_dec_ref_known(v___x_455_, 1);
v_e_x27_460_ = lean_ctor_get(v_a_456_, 0);
v_isSharedCheck_478_ = !lean_is_exclusive(v_a_456_);
if (v_isSharedCheck_478_ == 0)
{
v___x_462_ = v_a_456_;
v_isShared_463_ = v_isSharedCheck_478_;
goto v_resetjp_461_;
}
else
{
lean_inc(v_e_x27_460_);
lean_dec(v_a_456_);
v___x_462_ = lean_box(0);
v_isShared_463_ = v_isSharedCheck_478_;
goto v_resetjp_461_;
}
v_resetjp_461_:
{
lean_object* v___x_464_; 
lean_inc_ref(v_e_x27_460_);
v___x_464_ = l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteDsimproc___redArg(v_e_x27_460_, v___y_448_, v___y_449_, v___y_450_, v___y_451_, v___y_452_, v___y_453_);
if (lean_obj_tag(v___x_464_) == 0)
{
lean_object* v_a_465_; 
v_a_465_ = lean_ctor_get(v___x_464_, 0);
lean_inc(v_a_465_);
if (lean_obj_tag(v_a_465_) == 0)
{
lean_object* v___x_467_; uint8_t v_isShared_468_; uint8_t v_isSharedCheck_476_; 
v_isSharedCheck_476_ = !lean_is_exclusive(v___x_464_);
if (v_isSharedCheck_476_ == 0)
{
lean_object* v_unused_477_; 
v_unused_477_ = lean_ctor_get(v___x_464_, 0);
lean_dec(v_unused_477_);
v___x_467_ = v___x_464_;
v_isShared_468_ = v_isSharedCheck_476_;
goto v_resetjp_466_;
}
else
{
lean_dec(v___x_464_);
v___x_467_ = lean_box(0);
v_isShared_468_ = v_isSharedCheck_476_;
goto v_resetjp_466_;
}
v_resetjp_466_:
{
uint8_t v_done_469_; lean_object* v___x_471_; 
v_done_469_ = lean_ctor_get_uint8(v_a_465_, 0);
lean_dec_ref_known(v_a_465_, 0);
if (v_isShared_463_ == 0)
{
v___x_471_ = v___x_462_;
goto v_reusejp_470_;
}
else
{
lean_object* v_reuseFailAlloc_475_; 
v_reuseFailAlloc_475_ = lean_alloc_ctor(1, 1, 1);
lean_ctor_set(v_reuseFailAlloc_475_, 0, v_e_x27_460_);
v___x_471_ = v_reuseFailAlloc_475_;
goto v_reusejp_470_;
}
v_reusejp_470_:
{
lean_object* v___x_473_; 
lean_ctor_set_uint8(v___x_471_, sizeof(void*)*1, v_done_469_);
if (v_isShared_468_ == 0)
{
lean_ctor_set(v___x_467_, 0, v___x_471_);
v___x_473_ = v___x_467_;
goto v_reusejp_472_;
}
else
{
lean_object* v_reuseFailAlloc_474_; 
v_reuseFailAlloc_474_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_474_, 0, v___x_471_);
v___x_473_ = v_reuseFailAlloc_474_;
goto v_reusejp_472_;
}
v_reusejp_472_:
{
return v___x_473_;
}
}
}
}
else
{
lean_dec_ref_known(v_a_465_, 1);
lean_del_object(v___x_462_);
lean_dec_ref(v_e_x27_460_);
return v___x_464_;
}
}
else
{
lean_del_object(v___x_462_);
lean_dec_ref(v_e_x27_460_);
return v___x_464_;
}
}
}
else
{
lean_dec_ref_known(v_a_456_, 1);
return v___x_455_;
}
}
}
else
{
lean_dec_ref(v___y_444_);
return v___x_455_;
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__1___boxed(lean_object* v___x_479_, lean_object* v___y_480_, lean_object* v___y_481_, lean_object* v___y_482_, lean_object* v___y_483_, lean_object* v___y_484_, lean_object* v___y_485_, lean_object* v___y_486_, lean_object* v___y_487_, lean_object* v___y_488_, lean_object* v___y_489_, lean_object* v___y_490_){
_start:
{
lean_object* v_res_491_; 
v_res_491_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__1(v___x_479_, v___y_480_, v___y_481_, v___y_482_, v___y_483_, v___y_484_, v___y_485_, v___y_486_, v___y_487_, v___y_488_, v___y_489_);
lean_dec(v___y_489_);
lean_dec_ref(v___y_488_);
lean_dec(v___y_487_);
lean_dec_ref(v___y_486_);
lean_dec(v___y_485_);
lean_dec_ref(v___y_484_);
lean_dec(v___y_483_);
lean_dec(v___y_482_);
lean_dec(v___y_481_);
lean_dec(v___x_479_);
return v_res_491_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__2(lean_object* v_snd_492_, lean_object* v_a_493_, lean_object* v___x_494_, lean_object* v_____r_495_, lean_object* v___y_496_, lean_object* v___y_497_, lean_object* v___y_498_, lean_object* v___y_499_, lean_object* v___y_500_, lean_object* v___y_501_, lean_object* v___y_502_, lean_object* v___y_503_){
_start:
{
lean_object* v___x_505_; lean_object* v___x_506_; lean_object* v___x_507_; lean_object* v___x_508_; 
v___x_505_ = lean_array_push(v_snd_492_, v_a_493_);
v___x_506_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_506_, 0, v___x_494_);
lean_ctor_set(v___x_506_, 1, v___x_505_);
v___x_507_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_507_, 0, v___x_506_);
v___x_508_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_508_, 0, v___x_507_);
return v___x_508_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__2___boxed(lean_object* v_snd_509_, lean_object* v_a_510_, lean_object* v___x_511_, lean_object* v_____r_512_, lean_object* v___y_513_, lean_object* v___y_514_, lean_object* v___y_515_, lean_object* v___y_516_, lean_object* v___y_517_, lean_object* v___y_518_, lean_object* v___y_519_, lean_object* v___y_520_, lean_object* v___y_521_){
_start:
{
lean_object* v_res_522_; 
v_res_522_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__2(v_snd_509_, v_a_510_, v___x_511_, v_____r_512_, v___y_513_, v___y_514_, v___y_515_, v___y_516_, v___y_517_, v___y_518_, v___y_519_, v___y_520_);
lean_dec(v___y_520_);
lean_dec_ref(v___y_519_);
lean_dec(v___y_518_);
lean_dec_ref(v___y_517_);
lean_dec(v___y_516_);
lean_dec_ref(v___y_515_);
lean_dec(v___y_514_);
lean_dec_ref(v___y_513_);
return v_res_522_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__4(lean_object* v___f_523_, lean_object* v_type_524_, lean_object* v_____r_525_, lean_object* v___y_526_, lean_object* v___y_527_, lean_object* v___y_528_, lean_object* v___y_529_, lean_object* v___y_530_, lean_object* v___y_531_, lean_object* v___y_532_, lean_object* v___y_533_){
_start:
{
lean_object* v___x_535_; uint8_t v_debug_536_; 
v___x_535_ = lean_st_ref_get(v___y_529_);
v_debug_536_ = lean_ctor_get_uint8(v___x_535_, sizeof(void*)*10);
lean_dec(v___x_535_);
if (v_debug_536_ == 0)
{
lean_object* v___x_537_; lean_object* v___x_538_; 
lean_dec_ref(v_type_524_);
v___x_537_ = lean_box(0);
lean_inc(v___y_533_);
lean_inc_ref(v___y_532_);
lean_inc(v___y_531_);
lean_inc_ref(v___y_530_);
lean_inc(v___y_529_);
lean_inc_ref(v___y_528_);
lean_inc(v___y_527_);
lean_inc_ref(v___y_526_);
v___x_538_ = lean_apply_10(v___f_523_, v___x_537_, v___y_526_, v___y_527_, v___y_528_, v___y_529_, v___y_530_, v___y_531_, v___y_532_, v___y_533_, lean_box(0));
return v___x_538_;
}
else
{
lean_object* v___x_539_; 
v___x_539_ = l_Lean_Meta_Sym_Internal_Sym_assertShared(v_type_524_, v___y_528_, v___y_529_, v___y_530_, v___y_531_, v___y_532_, v___y_533_);
if (lean_obj_tag(v___x_539_) == 0)
{
lean_object* v_a_540_; lean_object* v___x_541_; 
v_a_540_ = lean_ctor_get(v___x_539_, 0);
lean_inc(v_a_540_);
lean_dec_ref_known(v___x_539_, 1);
lean_inc(v___y_533_);
lean_inc_ref(v___y_532_);
lean_inc(v___y_531_);
lean_inc_ref(v___y_530_);
lean_inc(v___y_529_);
lean_inc_ref(v___y_528_);
lean_inc(v___y_527_);
lean_inc_ref(v___y_526_);
v___x_541_ = lean_apply_10(v___f_523_, v_a_540_, v___y_526_, v___y_527_, v___y_528_, v___y_529_, v___y_530_, v___y_531_, v___y_532_, v___y_533_, lean_box(0));
return v___x_541_;
}
else
{
lean_object* v_a_542_; lean_object* v___x_544_; uint8_t v_isShared_545_; uint8_t v_isSharedCheck_549_; 
lean_dec_ref(v___f_523_);
v_a_542_ = lean_ctor_get(v___x_539_, 0);
v_isSharedCheck_549_ = !lean_is_exclusive(v___x_539_);
if (v_isSharedCheck_549_ == 0)
{
v___x_544_ = v___x_539_;
v_isShared_545_ = v_isSharedCheck_549_;
goto v_resetjp_543_;
}
else
{
lean_inc(v_a_542_);
lean_dec(v___x_539_);
v___x_544_ = lean_box(0);
v_isShared_545_ = v_isSharedCheck_549_;
goto v_resetjp_543_;
}
v_resetjp_543_:
{
lean_object* v___x_547_; 
if (v_isShared_545_ == 0)
{
v___x_547_ = v___x_544_;
goto v_reusejp_546_;
}
else
{
lean_object* v_reuseFailAlloc_548_; 
v_reuseFailAlloc_548_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_548_, 0, v_a_542_);
v___x_547_ = v_reuseFailAlloc_548_;
goto v_reusejp_546_;
}
v_reusejp_546_:
{
return v___x_547_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__4___boxed(lean_object* v___f_550_, lean_object* v_type_551_, lean_object* v_____r_552_, lean_object* v___y_553_, lean_object* v___y_554_, lean_object* v___y_555_, lean_object* v___y_556_, lean_object* v___y_557_, lean_object* v___y_558_, lean_object* v___y_559_, lean_object* v___y_560_, lean_object* v___y_561_){
_start:
{
lean_object* v_res_562_; 
v_res_562_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__4(v___f_550_, v_type_551_, v_____r_552_, v___y_553_, v___y_554_, v___y_555_, v___y_556_, v___y_557_, v___y_558_, v___y_559_, v___y_560_);
lean_dec(v___y_560_);
lean_dec_ref(v___y_559_);
lean_dec(v___y_558_);
lean_dec_ref(v___y_557_);
lean_dec(v___y_556_);
lean_dec_ref(v___y_555_);
lean_dec(v___y_554_);
lean_dec_ref(v___y_553_);
return v_res_562_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(lean_object* v_x_563_, lean_object* v_x_564_, lean_object* v_x_565_, lean_object* v_x_566_){
_start:
{
lean_object* v_ks_567_; lean_object* v_vs_568_; lean_object* v___x_570_; uint8_t v_isShared_571_; uint8_t v_isSharedCheck_592_; 
v_ks_567_ = lean_ctor_get(v_x_563_, 0);
v_vs_568_ = lean_ctor_get(v_x_563_, 1);
v_isSharedCheck_592_ = !lean_is_exclusive(v_x_563_);
if (v_isSharedCheck_592_ == 0)
{
v___x_570_ = v_x_563_;
v_isShared_571_ = v_isSharedCheck_592_;
goto v_resetjp_569_;
}
else
{
lean_inc(v_vs_568_);
lean_inc(v_ks_567_);
lean_dec(v_x_563_);
v___x_570_ = lean_box(0);
v_isShared_571_ = v_isSharedCheck_592_;
goto v_resetjp_569_;
}
v_resetjp_569_:
{
lean_object* v___x_572_; uint8_t v___x_573_; 
v___x_572_ = lean_array_get_size(v_ks_567_);
v___x_573_ = lean_nat_dec_lt(v_x_564_, v___x_572_);
if (v___x_573_ == 0)
{
lean_object* v___x_574_; lean_object* v___x_575_; lean_object* v___x_577_; 
lean_dec(v_x_564_);
v___x_574_ = lean_array_push(v_ks_567_, v_x_565_);
v___x_575_ = lean_array_push(v_vs_568_, v_x_566_);
if (v_isShared_571_ == 0)
{
lean_ctor_set(v___x_570_, 1, v___x_575_);
lean_ctor_set(v___x_570_, 0, v___x_574_);
v___x_577_ = v___x_570_;
goto v_reusejp_576_;
}
else
{
lean_object* v_reuseFailAlloc_578_; 
v_reuseFailAlloc_578_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_578_, 0, v___x_574_);
lean_ctor_set(v_reuseFailAlloc_578_, 1, v___x_575_);
v___x_577_ = v_reuseFailAlloc_578_;
goto v_reusejp_576_;
}
v_reusejp_576_:
{
return v___x_577_;
}
}
else
{
lean_object* v_k_x27_579_; uint8_t v___x_580_; 
v_k_x27_579_ = lean_array_fget_borrowed(v_ks_567_, v_x_564_);
v___x_580_ = l_Lean_instBEqMVarId_beq(v_x_565_, v_k_x27_579_);
if (v___x_580_ == 0)
{
lean_object* v___x_582_; 
if (v_isShared_571_ == 0)
{
v___x_582_ = v___x_570_;
goto v_reusejp_581_;
}
else
{
lean_object* v_reuseFailAlloc_586_; 
v_reuseFailAlloc_586_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_586_, 0, v_ks_567_);
lean_ctor_set(v_reuseFailAlloc_586_, 1, v_vs_568_);
v___x_582_ = v_reuseFailAlloc_586_;
goto v_reusejp_581_;
}
v_reusejp_581_:
{
lean_object* v___x_583_; lean_object* v___x_584_; 
v___x_583_ = lean_unsigned_to_nat(1u);
v___x_584_ = lean_nat_add(v_x_564_, v___x_583_);
lean_dec(v_x_564_);
v_x_563_ = v___x_582_;
v_x_564_ = v___x_584_;
goto _start;
}
}
else
{
lean_object* v___x_587_; lean_object* v___x_588_; lean_object* v___x_590_; 
v___x_587_ = lean_array_fset(v_ks_567_, v_x_564_, v_x_565_);
v___x_588_ = lean_array_fset(v_vs_568_, v_x_564_, v_x_566_);
lean_dec(v_x_564_);
if (v_isShared_571_ == 0)
{
lean_ctor_set(v___x_570_, 1, v___x_588_);
lean_ctor_set(v___x_570_, 0, v___x_587_);
v___x_590_ = v___x_570_;
goto v_reusejp_589_;
}
else
{
lean_object* v_reuseFailAlloc_591_; 
v_reuseFailAlloc_591_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_591_, 0, v___x_587_);
lean_ctor_set(v_reuseFailAlloc_591_, 1, v___x_588_);
v___x_590_ = v_reuseFailAlloc_591_;
goto v_reusejp_589_;
}
v_reusejp_589_:
{
return v___x_590_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6___redArg(lean_object* v_n_593_, lean_object* v_k_594_, lean_object* v_v_595_){
_start:
{
lean_object* v___x_596_; lean_object* v___x_597_; 
v___x_596_ = lean_unsigned_to_nat(0u);
v___x_597_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(v_n_593_, v___x_596_, v_k_594_, v_v_595_);
return v___x_597_;
}
}
static lean_object* _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg___closed__0(void){
_start:
{
lean_object* v___x_598_; 
v___x_598_ = l_Lean_PersistentHashMap_mkEmptyEntries(lean_box(0), lean_box(0));
return v___x_598_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg(lean_object* v_x_599_, size_t v_x_600_, size_t v_x_601_, lean_object* v_x_602_, lean_object* v_x_603_){
_start:
{
if (lean_obj_tag(v_x_599_) == 0)
{
lean_object* v_es_604_; size_t v___x_605_; size_t v___x_606_; lean_object* v_j_607_; lean_object* v___x_608_; uint8_t v___x_609_; 
v_es_604_ = lean_ctor_get(v_x_599_, 0);
v___x_605_ = ((size_t)31ULL);
v___x_606_ = lean_usize_land(v_x_600_, v___x_605_);
v_j_607_ = lean_usize_to_nat(v___x_606_);
v___x_608_ = lean_array_get_size(v_es_604_);
v___x_609_ = lean_nat_dec_lt(v_j_607_, v___x_608_);
if (v___x_609_ == 0)
{
lean_dec(v_j_607_);
lean_dec(v_x_603_);
lean_dec(v_x_602_);
return v_x_599_;
}
else
{
lean_object* v___x_611_; uint8_t v_isShared_612_; uint8_t v_isSharedCheck_648_; 
lean_inc_ref(v_es_604_);
v_isSharedCheck_648_ = !lean_is_exclusive(v_x_599_);
if (v_isSharedCheck_648_ == 0)
{
lean_object* v_unused_649_; 
v_unused_649_ = lean_ctor_get(v_x_599_, 0);
lean_dec(v_unused_649_);
v___x_611_ = v_x_599_;
v_isShared_612_ = v_isSharedCheck_648_;
goto v_resetjp_610_;
}
else
{
lean_dec(v_x_599_);
v___x_611_ = lean_box(0);
v_isShared_612_ = v_isSharedCheck_648_;
goto v_resetjp_610_;
}
v_resetjp_610_:
{
lean_object* v_v_613_; lean_object* v___x_614_; lean_object* v_xs_x27_615_; lean_object* v___y_617_; 
v_v_613_ = lean_array_fget(v_es_604_, v_j_607_);
v___x_614_ = lean_box(0);
v_xs_x27_615_ = lean_array_fset(v_es_604_, v_j_607_, v___x_614_);
switch(lean_obj_tag(v_v_613_))
{
case 0:
{
lean_object* v_key_622_; lean_object* v_val_623_; lean_object* v___x_625_; uint8_t v_isShared_626_; uint8_t v_isSharedCheck_633_; 
v_key_622_ = lean_ctor_get(v_v_613_, 0);
v_val_623_ = lean_ctor_get(v_v_613_, 1);
v_isSharedCheck_633_ = !lean_is_exclusive(v_v_613_);
if (v_isSharedCheck_633_ == 0)
{
v___x_625_ = v_v_613_;
v_isShared_626_ = v_isSharedCheck_633_;
goto v_resetjp_624_;
}
else
{
lean_inc(v_val_623_);
lean_inc(v_key_622_);
lean_dec(v_v_613_);
v___x_625_ = lean_box(0);
v_isShared_626_ = v_isSharedCheck_633_;
goto v_resetjp_624_;
}
v_resetjp_624_:
{
uint8_t v___x_627_; 
v___x_627_ = l_Lean_instBEqMVarId_beq(v_x_602_, v_key_622_);
if (v___x_627_ == 0)
{
lean_object* v___x_628_; lean_object* v___x_629_; 
lean_del_object(v___x_625_);
v___x_628_ = l_Lean_PersistentHashMap_mkCollisionNode___redArg(v_key_622_, v_val_623_, v_x_602_, v_x_603_);
v___x_629_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_629_, 0, v___x_628_);
v___y_617_ = v___x_629_;
goto v___jp_616_;
}
else
{
lean_object* v___x_631_; 
lean_dec(v_val_623_);
lean_dec(v_key_622_);
if (v_isShared_626_ == 0)
{
lean_ctor_set(v___x_625_, 1, v_x_603_);
lean_ctor_set(v___x_625_, 0, v_x_602_);
v___x_631_ = v___x_625_;
goto v_reusejp_630_;
}
else
{
lean_object* v_reuseFailAlloc_632_; 
v_reuseFailAlloc_632_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_632_, 0, v_x_602_);
lean_ctor_set(v_reuseFailAlloc_632_, 1, v_x_603_);
v___x_631_ = v_reuseFailAlloc_632_;
goto v_reusejp_630_;
}
v_reusejp_630_:
{
v___y_617_ = v___x_631_;
goto v___jp_616_;
}
}
}
}
case 1:
{
lean_object* v_node_634_; lean_object* v___x_636_; uint8_t v_isShared_637_; uint8_t v_isSharedCheck_646_; 
v_node_634_ = lean_ctor_get(v_v_613_, 0);
v_isSharedCheck_646_ = !lean_is_exclusive(v_v_613_);
if (v_isSharedCheck_646_ == 0)
{
v___x_636_ = v_v_613_;
v_isShared_637_ = v_isSharedCheck_646_;
goto v_resetjp_635_;
}
else
{
lean_inc(v_node_634_);
lean_dec(v_v_613_);
v___x_636_ = lean_box(0);
v_isShared_637_ = v_isSharedCheck_646_;
goto v_resetjp_635_;
}
v_resetjp_635_:
{
size_t v___x_638_; size_t v___x_639_; size_t v___x_640_; size_t v___x_641_; lean_object* v___x_642_; lean_object* v___x_644_; 
v___x_638_ = ((size_t)5ULL);
v___x_639_ = lean_usize_shift_right(v_x_600_, v___x_638_);
v___x_640_ = ((size_t)1ULL);
v___x_641_ = lean_usize_add(v_x_601_, v___x_640_);
v___x_642_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg(v_node_634_, v___x_639_, v___x_641_, v_x_602_, v_x_603_);
if (v_isShared_637_ == 0)
{
lean_ctor_set(v___x_636_, 0, v___x_642_);
v___x_644_ = v___x_636_;
goto v_reusejp_643_;
}
else
{
lean_object* v_reuseFailAlloc_645_; 
v_reuseFailAlloc_645_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_645_, 0, v___x_642_);
v___x_644_ = v_reuseFailAlloc_645_;
goto v_reusejp_643_;
}
v_reusejp_643_:
{
v___y_617_ = v___x_644_;
goto v___jp_616_;
}
}
}
default: 
{
lean_object* v___x_647_; 
v___x_647_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_647_, 0, v_x_602_);
lean_ctor_set(v___x_647_, 1, v_x_603_);
v___y_617_ = v___x_647_;
goto v___jp_616_;
}
}
v___jp_616_:
{
lean_object* v___x_618_; lean_object* v___x_620_; 
v___x_618_ = lean_array_fset(v_xs_x27_615_, v_j_607_, v___y_617_);
lean_dec(v_j_607_);
if (v_isShared_612_ == 0)
{
lean_ctor_set(v___x_611_, 0, v___x_618_);
v___x_620_ = v___x_611_;
goto v_reusejp_619_;
}
else
{
lean_object* v_reuseFailAlloc_621_; 
v_reuseFailAlloc_621_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_621_, 0, v___x_618_);
v___x_620_ = v_reuseFailAlloc_621_;
goto v_reusejp_619_;
}
v_reusejp_619_:
{
return v___x_620_;
}
}
}
}
}
else
{
lean_object* v_ks_650_; lean_object* v_vs_651_; lean_object* v___x_653_; uint8_t v_isShared_654_; uint8_t v_isSharedCheck_671_; 
v_ks_650_ = lean_ctor_get(v_x_599_, 0);
v_vs_651_ = lean_ctor_get(v_x_599_, 1);
v_isSharedCheck_671_ = !lean_is_exclusive(v_x_599_);
if (v_isSharedCheck_671_ == 0)
{
v___x_653_ = v_x_599_;
v_isShared_654_ = v_isSharedCheck_671_;
goto v_resetjp_652_;
}
else
{
lean_inc(v_vs_651_);
lean_inc(v_ks_650_);
lean_dec(v_x_599_);
v___x_653_ = lean_box(0);
v_isShared_654_ = v_isSharedCheck_671_;
goto v_resetjp_652_;
}
v_resetjp_652_:
{
lean_object* v___x_656_; 
if (v_isShared_654_ == 0)
{
v___x_656_ = v___x_653_;
goto v_reusejp_655_;
}
else
{
lean_object* v_reuseFailAlloc_670_; 
v_reuseFailAlloc_670_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_670_, 0, v_ks_650_);
lean_ctor_set(v_reuseFailAlloc_670_, 1, v_vs_651_);
v___x_656_ = v_reuseFailAlloc_670_;
goto v_reusejp_655_;
}
v_reusejp_655_:
{
lean_object* v_newNode_657_; uint8_t v___y_659_; size_t v___x_665_; uint8_t v___x_666_; 
v_newNode_657_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6___redArg(v___x_656_, v_x_602_, v_x_603_);
v___x_665_ = ((size_t)7ULL);
v___x_666_ = lean_usize_dec_le(v___x_665_, v_x_601_);
if (v___x_666_ == 0)
{
lean_object* v___x_667_; lean_object* v___x_668_; uint8_t v___x_669_; 
v___x_667_ = l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(v_newNode_657_);
v___x_668_ = lean_unsigned_to_nat(4u);
v___x_669_ = lean_nat_dec_lt(v___x_667_, v___x_668_);
lean_dec(v___x_667_);
v___y_659_ = v___x_669_;
goto v___jp_658_;
}
else
{
v___y_659_ = v___x_666_;
goto v___jp_658_;
}
v___jp_658_:
{
if (v___y_659_ == 0)
{
lean_object* v_ks_660_; lean_object* v_vs_661_; lean_object* v___x_662_; lean_object* v___x_663_; lean_object* v___x_664_; 
v_ks_660_ = lean_ctor_get(v_newNode_657_, 0);
lean_inc_ref(v_ks_660_);
v_vs_661_ = lean_ctor_get(v_newNode_657_, 1);
lean_inc_ref(v_vs_661_);
lean_dec_ref(v_newNode_657_);
v___x_662_ = lean_unsigned_to_nat(0u);
v___x_663_ = lean_obj_once(&l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg___closed__0, &l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg___closed__0_once, _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg___closed__0);
v___x_664_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7___redArg(v_x_601_, v_ks_660_, v_vs_661_, v___x_662_, v___x_663_);
lean_dec_ref(v_vs_661_);
lean_dec_ref(v_ks_660_);
return v___x_664_;
}
else
{
return v_newNode_657_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7___redArg(size_t v_depth_672_, lean_object* v_keys_673_, lean_object* v_vals_674_, lean_object* v_i_675_, lean_object* v_entries_676_){
_start:
{
lean_object* v___x_677_; uint8_t v___x_678_; 
v___x_677_ = lean_array_get_size(v_keys_673_);
v___x_678_ = lean_nat_dec_lt(v_i_675_, v___x_677_);
if (v___x_678_ == 0)
{
lean_dec(v_i_675_);
return v_entries_676_;
}
else
{
lean_object* v_k_679_; lean_object* v_v_680_; uint64_t v___x_681_; size_t v_h_682_; size_t v___x_683_; lean_object* v___x_684_; size_t v___x_685_; size_t v___x_686_; size_t v___x_687_; size_t v_h_688_; lean_object* v___x_689_; lean_object* v___x_690_; 
v_k_679_ = lean_array_fget_borrowed(v_keys_673_, v_i_675_);
v_v_680_ = lean_array_fget_borrowed(v_vals_674_, v_i_675_);
v___x_681_ = l_Lean_instHashableMVarId_hash(v_k_679_);
v_h_682_ = lean_uint64_to_usize(v___x_681_);
v___x_683_ = ((size_t)5ULL);
v___x_684_ = lean_unsigned_to_nat(1u);
v___x_685_ = ((size_t)1ULL);
v___x_686_ = lean_usize_sub(v_depth_672_, v___x_685_);
v___x_687_ = lean_usize_mul(v___x_683_, v___x_686_);
v_h_688_ = lean_usize_shift_right(v_h_682_, v___x_687_);
v___x_689_ = lean_nat_add(v_i_675_, v___x_684_);
lean_dec(v_i_675_);
lean_inc(v_v_680_);
lean_inc(v_k_679_);
v___x_690_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg(v_entries_676_, v_h_688_, v_depth_672_, v_k_679_, v_v_680_);
v_i_675_ = v___x_689_;
v_entries_676_ = v___x_690_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7___redArg___boxed(lean_object* v_depth_692_, lean_object* v_keys_693_, lean_object* v_vals_694_, lean_object* v_i_695_, lean_object* v_entries_696_){
_start:
{
size_t v_depth_boxed_697_; lean_object* v_res_698_; 
v_depth_boxed_697_ = lean_unbox_usize(v_depth_692_);
lean_dec(v_depth_692_);
v_res_698_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7___redArg(v_depth_boxed_697_, v_keys_693_, v_vals_694_, v_i_695_, v_entries_696_);
lean_dec_ref(v_vals_694_);
lean_dec_ref(v_keys_693_);
return v_res_698_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg___boxed(lean_object* v_x_699_, lean_object* v_x_700_, lean_object* v_x_701_, lean_object* v_x_702_, lean_object* v_x_703_){
_start:
{
size_t v_x_34156__boxed_704_; size_t v_x_34157__boxed_705_; lean_object* v_res_706_; 
v_x_34156__boxed_704_ = lean_unbox_usize(v_x_700_);
lean_dec(v_x_700_);
v_x_34157__boxed_705_ = lean_unbox_usize(v_x_701_);
lean_dec(v_x_701_);
v_res_706_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg(v_x_699_, v_x_34156__boxed_704_, v_x_34157__boxed_705_, v_x_702_, v_x_703_);
return v_res_706_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2___redArg(lean_object* v_x_707_, lean_object* v_x_708_, lean_object* v_x_709_){
_start:
{
uint64_t v___x_710_; size_t v___x_711_; size_t v___x_712_; lean_object* v___x_713_; 
v___x_710_ = l_Lean_instHashableMVarId_hash(v_x_708_);
v___x_711_ = lean_uint64_to_usize(v___x_710_);
v___x_712_ = ((size_t)1ULL);
v___x_713_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg(v_x_707_, v___x_711_, v___x_712_, v_x_708_, v_x_709_);
return v___x_713_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1___redArg(lean_object* v_mvarId_714_, lean_object* v_val_715_, lean_object* v___y_716_){
_start:
{
lean_object* v___x_718_; lean_object* v_mctx_719_; lean_object* v_cache_720_; lean_object* v_zetaDeltaFVarIds_721_; lean_object* v_postponed_722_; lean_object* v_diag_723_; lean_object* v___x_725_; uint8_t v_isShared_726_; uint8_t v_isSharedCheck_751_; 
v___x_718_ = lean_st_ref_take(v___y_716_);
v_mctx_719_ = lean_ctor_get(v___x_718_, 0);
v_cache_720_ = lean_ctor_get(v___x_718_, 1);
v_zetaDeltaFVarIds_721_ = lean_ctor_get(v___x_718_, 2);
v_postponed_722_ = lean_ctor_get(v___x_718_, 3);
v_diag_723_ = lean_ctor_get(v___x_718_, 4);
v_isSharedCheck_751_ = !lean_is_exclusive(v___x_718_);
if (v_isSharedCheck_751_ == 0)
{
v___x_725_ = v___x_718_;
v_isShared_726_ = v_isSharedCheck_751_;
goto v_resetjp_724_;
}
else
{
lean_inc(v_diag_723_);
lean_inc(v_postponed_722_);
lean_inc(v_zetaDeltaFVarIds_721_);
lean_inc(v_cache_720_);
lean_inc(v_mctx_719_);
lean_dec(v___x_718_);
v___x_725_ = lean_box(0);
v_isShared_726_ = v_isSharedCheck_751_;
goto v_resetjp_724_;
}
v_resetjp_724_:
{
lean_object* v_depth_727_; lean_object* v_levelAssignDepth_728_; lean_object* v_lmvarCounter_729_; lean_object* v_mvarCounter_730_; lean_object* v_lDecls_731_; lean_object* v_decls_732_; lean_object* v_userNames_733_; lean_object* v_lAssignment_734_; lean_object* v_eAssignment_735_; lean_object* v_dAssignment_736_; lean_object* v___x_738_; uint8_t v_isShared_739_; uint8_t v_isSharedCheck_750_; 
v_depth_727_ = lean_ctor_get(v_mctx_719_, 0);
v_levelAssignDepth_728_ = lean_ctor_get(v_mctx_719_, 1);
v_lmvarCounter_729_ = lean_ctor_get(v_mctx_719_, 2);
v_mvarCounter_730_ = lean_ctor_get(v_mctx_719_, 3);
v_lDecls_731_ = lean_ctor_get(v_mctx_719_, 4);
v_decls_732_ = lean_ctor_get(v_mctx_719_, 5);
v_userNames_733_ = lean_ctor_get(v_mctx_719_, 6);
v_lAssignment_734_ = lean_ctor_get(v_mctx_719_, 7);
v_eAssignment_735_ = lean_ctor_get(v_mctx_719_, 8);
v_dAssignment_736_ = lean_ctor_get(v_mctx_719_, 9);
v_isSharedCheck_750_ = !lean_is_exclusive(v_mctx_719_);
if (v_isSharedCheck_750_ == 0)
{
v___x_738_ = v_mctx_719_;
v_isShared_739_ = v_isSharedCheck_750_;
goto v_resetjp_737_;
}
else
{
lean_inc(v_dAssignment_736_);
lean_inc(v_eAssignment_735_);
lean_inc(v_lAssignment_734_);
lean_inc(v_userNames_733_);
lean_inc(v_decls_732_);
lean_inc(v_lDecls_731_);
lean_inc(v_mvarCounter_730_);
lean_inc(v_lmvarCounter_729_);
lean_inc(v_levelAssignDepth_728_);
lean_inc(v_depth_727_);
lean_dec(v_mctx_719_);
v___x_738_ = lean_box(0);
v_isShared_739_ = v_isSharedCheck_750_;
goto v_resetjp_737_;
}
v_resetjp_737_:
{
lean_object* v___x_740_; lean_object* v___x_742_; 
v___x_740_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2___redArg(v_eAssignment_735_, v_mvarId_714_, v_val_715_);
if (v_isShared_739_ == 0)
{
lean_ctor_set(v___x_738_, 8, v___x_740_);
v___x_742_ = v___x_738_;
goto v_reusejp_741_;
}
else
{
lean_object* v_reuseFailAlloc_749_; 
v_reuseFailAlloc_749_ = lean_alloc_ctor(0, 10, 0);
lean_ctor_set(v_reuseFailAlloc_749_, 0, v_depth_727_);
lean_ctor_set(v_reuseFailAlloc_749_, 1, v_levelAssignDepth_728_);
lean_ctor_set(v_reuseFailAlloc_749_, 2, v_lmvarCounter_729_);
lean_ctor_set(v_reuseFailAlloc_749_, 3, v_mvarCounter_730_);
lean_ctor_set(v_reuseFailAlloc_749_, 4, v_lDecls_731_);
lean_ctor_set(v_reuseFailAlloc_749_, 5, v_decls_732_);
lean_ctor_set(v_reuseFailAlloc_749_, 6, v_userNames_733_);
lean_ctor_set(v_reuseFailAlloc_749_, 7, v_lAssignment_734_);
lean_ctor_set(v_reuseFailAlloc_749_, 8, v___x_740_);
lean_ctor_set(v_reuseFailAlloc_749_, 9, v_dAssignment_736_);
v___x_742_ = v_reuseFailAlloc_749_;
goto v_reusejp_741_;
}
v_reusejp_741_:
{
lean_object* v___x_744_; 
if (v_isShared_726_ == 0)
{
lean_ctor_set(v___x_725_, 0, v___x_742_);
v___x_744_ = v___x_725_;
goto v_reusejp_743_;
}
else
{
lean_object* v_reuseFailAlloc_748_; 
v_reuseFailAlloc_748_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_748_, 0, v___x_742_);
lean_ctor_set(v_reuseFailAlloc_748_, 1, v_cache_720_);
lean_ctor_set(v_reuseFailAlloc_748_, 2, v_zetaDeltaFVarIds_721_);
lean_ctor_set(v_reuseFailAlloc_748_, 3, v_postponed_722_);
lean_ctor_set(v_reuseFailAlloc_748_, 4, v_diag_723_);
v___x_744_ = v_reuseFailAlloc_748_;
goto v_reusejp_743_;
}
v_reusejp_743_:
{
lean_object* v___x_745_; lean_object* v___x_746_; lean_object* v___x_747_; 
v___x_745_ = lean_st_ref_set(v___y_716_, v___x_744_);
v___x_746_ = lean_box(0);
v___x_747_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_747_, 0, v___x_746_);
return v___x_747_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1___redArg___boxed(lean_object* v_mvarId_752_, lean_object* v_val_753_, lean_object* v___y_754_, lean_object* v___y_755_){
_start:
{
lean_object* v_res_756_; 
v_res_756_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1___redArg(v_mvarId_752_, v_val_753_, v___y_754_);
lean_dec(v___y_754_);
return v_res_756_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0(lean_object* v_x_759_, lean_object* v___y_760_, lean_object* v___y_761_, lean_object* v___y_762_, lean_object* v___y_763_, lean_object* v___y_764_, lean_object* v___y_765_, lean_object* v___y_766_, lean_object* v___y_767_, lean_object* v___y_768_){
_start:
{
lean_object* v___x_770_; lean_object* v___x_771_; 
v___x_770_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0___closed__0));
v___x_771_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_771_, 0, v___x_770_);
return v___x_771_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0___boxed(lean_object* v_x_772_, lean_object* v___y_773_, lean_object* v___y_774_, lean_object* v___y_775_, lean_object* v___y_776_, lean_object* v___y_777_, lean_object* v___y_778_, lean_object* v___y_779_, lean_object* v___y_780_, lean_object* v___y_781_, lean_object* v___y_782_){
_start:
{
lean_object* v_res_783_; 
v_res_783_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__0(v_x_772_, v___y_773_, v___y_774_, v___y_775_, v___y_776_, v___y_777_, v___y_778_, v___y_779_, v___y_780_, v___y_781_);
lean_dec(v___y_781_);
lean_dec_ref(v___y_780_);
lean_dec(v___y_779_);
lean_dec_ref(v___y_778_);
lean_dec(v___y_777_);
lean_dec_ref(v___y_776_);
lean_dec(v___y_775_);
lean_dec(v___y_774_);
lean_dec(v___y_773_);
lean_dec_ref(v_x_772_);
return v_res_783_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__6(void){
_start:
{
lean_object* v___x_794_; lean_object* v___x_795_; lean_object* v___x_796_; 
v___x_794_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__3));
v___x_795_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__5));
v___x_796_ = l_Lean_Name_append(v___x_795_, v___x_794_);
return v___x_796_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__8(void){
_start:
{
lean_object* v___x_798_; lean_object* v___x_799_; 
v___x_798_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__7));
v___x_799_ = l_Lean_stringToMessageData(v___x_798_);
return v___x_799_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg(lean_object* v_upperBound_806_, lean_object* v___x_807_, lean_object* v___x_808_, lean_object* v___x_809_, lean_object* v___x_810_, lean_object* v_a_811_, lean_object* v_b_812_, lean_object* v___y_813_, lean_object* v___y_814_, lean_object* v___y_815_, lean_object* v___y_816_, lean_object* v___y_817_, lean_object* v___y_818_, lean_object* v___y_819_, lean_object* v___y_820_){
_start:
{
lean_object* v___y_823_; lean_object* v___y_846_; uint8_t v___x_849_; 
v___x_849_ = lean_nat_dec_lt(v_a_811_, v_upperBound_806_);
if (v___x_849_ == 0)
{
lean_object* v___x_850_; 
lean_dec(v_a_811_);
lean_dec_ref(v___x_810_);
lean_dec_ref(v___x_809_);
lean_dec(v___x_808_);
v___x_850_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_850_, 0, v_b_812_);
return v___x_850_;
}
else
{
lean_object* v___x_851_; lean_object* v_name_852_; lean_object* v_type_853_; lean_object* v_value_854_; lean_object* v___y_856_; lean_object* v___y_857_; lean_object* v___x_880_; lean_object* v___x_881_; lean_object* v___x_882_; 
v___x_851_ = lean_array_fget_borrowed(v___x_807_, v_a_811_);
v_name_852_ = lean_ctor_get(v___x_851_, 0);
v_type_853_ = lean_ctor_get(v___x_851_, 1);
v_value_854_ = lean_ctor_get(v___x_851_, 2);
v___x_880_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__11));
lean_inc_ref(v_type_853_);
v___x_881_ = lean_alloc_closure((void*)(l_Lean_Meta_Sym_DSimp_dsimp___boxed), 11, 1);
lean_closure_set(v___x_881_, 0, v_type_853_);
lean_inc(v___x_808_);
v___x_882_ = l_Lean_Meta_Sym_DSimp_DSimpM_run_x27___redArg(v___x_881_, v___x_880_, v___x_808_, v___y_815_, v___y_816_, v___y_817_, v___y_818_, v___y_819_, v___y_820_);
if (lean_obj_tag(v___x_882_) == 0)
{
lean_object* v_a_883_; lean_object* v_snd_884_; lean_object* v___x_886_; uint8_t v_isShared_887_; uint8_t v_isSharedCheck_948_; 
v_a_883_ = lean_ctor_get(v___x_882_, 0);
lean_inc(v_a_883_);
lean_dec_ref_known(v___x_882_, 1);
v_snd_884_ = lean_ctor_get(v_b_812_, 1);
v_isSharedCheck_948_ = !lean_is_exclusive(v_b_812_);
if (v_isSharedCheck_948_ == 0)
{
lean_object* v_unused_949_; 
v_unused_949_ = lean_ctor_get(v_b_812_, 0);
lean_dec(v_unused_949_);
v___x_886_ = v_b_812_;
v_isShared_887_ = v_isSharedCheck_948_;
goto v_resetjp_885_;
}
else
{
lean_inc(v_snd_884_);
lean_dec(v_b_812_);
v___x_886_ = lean_box(0);
v_isShared_887_ = v_isSharedCheck_948_;
goto v_resetjp_885_;
}
v_resetjp_885_:
{
lean_object* v___x_888_; lean_object* v_a_890_; 
v___x_888_ = lean_box(0);
if (lean_obj_tag(v_a_883_) == 0)
{
lean_dec_ref_known(v_a_883_, 0);
lean_inc_ref(v_type_853_);
v_a_890_ = v_type_853_;
goto v___jp_889_;
}
else
{
lean_object* v_e_x27_947_; 
v_e_x27_947_ = lean_ctor_get(v_a_883_, 0);
lean_inc_ref(v_e_x27_947_);
lean_dec_ref_known(v_a_883_, 1);
v_a_890_ = v_e_x27_947_;
goto v___jp_889_;
}
v___jp_889_:
{
lean_object* v___x_891_; lean_object* v___x_892_; lean_object* v___x_893_; 
lean_inc_ref(v_value_854_);
lean_inc_ref(v_a_890_);
lean_inc(v_name_852_);
v___x_891_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v___x_891_, 0, v_name_852_);
lean_ctor_set(v___x_891_, 1, v_a_890_);
lean_ctor_set(v___x_891_, 2, v_value_854_);
v___x_892_ = lean_alloc_closure((void*)(l_Lean_Meta_Sym_Simp_simp___boxed), 11, 1);
lean_closure_set(v___x_892_, 0, v_a_890_);
lean_inc_ref(v___x_810_);
lean_inc_ref(v___x_809_);
v___x_893_ = l_Lean_Meta_Sym_Simp_SimpM_run_x27___redArg(v___x_892_, v___x_809_, v___x_810_, v___y_815_, v___y_816_, v___y_817_, v___y_818_, v___y_819_, v___y_820_);
if (lean_obj_tag(v___x_893_) == 0)
{
lean_object* v_a_894_; lean_object* v___x_895_; 
v_a_894_ = lean_ctor_get(v___x_893_, 0);
lean_inc(v_a_894_);
lean_dec_ref_known(v___x_893_, 1);
v___x_895_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(v___x_891_, v_a_894_, v___y_816_, v___y_817_, v___y_818_, v___y_819_, v___y_820_);
if (lean_obj_tag(v___x_895_) == 0)
{
lean_object* v_a_896_; lean_object* v_type_897_; lean_object* v_value_898_; uint8_t v___x_899_; 
v_a_896_ = lean_ctor_get(v___x_895_, 0);
lean_inc(v_a_896_);
lean_dec_ref_known(v___x_895_, 1);
v_type_897_ = lean_ctor_get(v_a_896_, 1);
v_value_898_ = lean_ctor_get(v_a_896_, 2);
lean_inc_ref(v_type_897_);
v___x_899_ = l_Lean_Expr_isFalse(v_type_897_);
if (v___x_899_ == 0)
{
lean_object* v___f_900_; lean_object* v___x_901_; lean_object* v___f_902_; lean_object* v___f_903_; uint8_t v___x_904_; 
lean_del_object(v___x_886_);
lean_inc(v_a_896_);
lean_inc(v_snd_884_);
v___f_900_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__2___boxed), 13, 3);
lean_closure_set(v___f_900_, 0, v_snd_884_);
lean_closure_set(v___f_900_, 1, v_a_896_);
lean_closure_set(v___f_900_, 2, v___x_888_);
v___x_901_ = lean_box(v___x_849_);
v___f_902_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__3___boxed), 12, 2);
lean_closure_set(v___f_902_, 0, v___x_901_);
lean_closure_set(v___f_902_, 1, v___f_900_);
lean_inc_ref(v_type_897_);
v___f_903_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__4___boxed), 12, 2);
lean_closure_set(v___f_903_, 0, v___f_902_);
lean_closure_set(v___f_903_, 1, v_type_897_);
v___x_904_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(v___x_851_, v_a_896_);
if (v___x_904_ == 0)
{
lean_inc_ref(v_type_897_);
lean_dec(v_a_896_);
lean_dec(v_snd_884_);
v___y_856_ = v_type_897_;
v___y_857_ = v___f_903_;
goto v___jp_855_;
}
else
{
if (v___x_899_ == 0)
{
lean_object* v___x_905_; lean_object* v___x_906_; 
lean_dec_ref(v___f_903_);
v___x_905_ = lean_box(0);
v___x_906_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___lam__2(v_snd_884_, v_a_896_, v___x_888_, v___x_905_, v___y_813_, v___y_814_, v___y_815_, v___y_816_, v___y_817_, v___y_818_, v___y_819_, v___y_820_);
v___y_823_ = v___x_906_;
goto v___jp_822_;
}
else
{
lean_inc_ref(v_type_897_);
lean_dec(v_a_896_);
lean_dec(v_snd_884_);
v___y_856_ = v_type_897_;
v___y_857_ = v___f_903_;
goto v___jp_855_;
}
}
}
else
{
lean_object* v___x_907_; lean_object* v_goal_908_; lean_object* v___x_909_; 
lean_inc_ref(v_value_898_);
lean_dec(v_a_896_);
lean_dec(v_a_811_);
lean_dec_ref(v___x_810_);
lean_dec_ref(v___x_809_);
lean_dec(v___x_808_);
v___x_907_ = lean_st_ref_get(v___y_814_);
v_goal_908_ = lean_ctor_get(v___x_907_, 3);
lean_inc(v_goal_908_);
lean_dec(v___x_907_);
v___x_909_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1___redArg(v_goal_908_, v_value_898_, v___y_818_);
if (lean_obj_tag(v___x_909_) == 0)
{
lean_object* v___x_911_; uint8_t v_isShared_912_; uint8_t v_isSharedCheck_921_; 
v_isSharedCheck_921_ = !lean_is_exclusive(v___x_909_);
if (v_isSharedCheck_921_ == 0)
{
lean_object* v_unused_922_; 
v_unused_922_ = lean_ctor_get(v___x_909_, 0);
lean_dec(v_unused_922_);
v___x_911_ = v___x_909_;
v_isShared_912_ = v_isSharedCheck_921_;
goto v_resetjp_910_;
}
else
{
lean_dec(v___x_909_);
v___x_911_ = lean_box(0);
v_isShared_912_ = v_isSharedCheck_921_;
goto v_resetjp_910_;
}
v_resetjp_910_:
{
lean_object* v___x_913_; lean_object* v___x_914_; lean_object* v___x_916_; 
v___x_913_ = lean_box(v___x_899_);
v___x_914_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_914_, 0, v___x_913_);
if (v_isShared_887_ == 0)
{
lean_ctor_set(v___x_886_, 0, v___x_914_);
v___x_916_ = v___x_886_;
goto v_reusejp_915_;
}
else
{
lean_object* v_reuseFailAlloc_920_; 
v_reuseFailAlloc_920_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_920_, 0, v___x_914_);
lean_ctor_set(v_reuseFailAlloc_920_, 1, v_snd_884_);
v___x_916_ = v_reuseFailAlloc_920_;
goto v_reusejp_915_;
}
v_reusejp_915_:
{
lean_object* v___x_918_; 
if (v_isShared_912_ == 0)
{
lean_ctor_set(v___x_911_, 0, v___x_916_);
v___x_918_ = v___x_911_;
goto v_reusejp_917_;
}
else
{
lean_object* v_reuseFailAlloc_919_; 
v_reuseFailAlloc_919_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_919_, 0, v___x_916_);
v___x_918_ = v_reuseFailAlloc_919_;
goto v_reusejp_917_;
}
v_reusejp_917_:
{
return v___x_918_;
}
}
}
}
else
{
lean_object* v_a_923_; lean_object* v___x_925_; uint8_t v_isShared_926_; uint8_t v_isSharedCheck_930_; 
lean_del_object(v___x_886_);
lean_dec(v_snd_884_);
v_a_923_ = lean_ctor_get(v___x_909_, 0);
v_isSharedCheck_930_ = !lean_is_exclusive(v___x_909_);
if (v_isSharedCheck_930_ == 0)
{
v___x_925_ = v___x_909_;
v_isShared_926_ = v_isSharedCheck_930_;
goto v_resetjp_924_;
}
else
{
lean_inc(v_a_923_);
lean_dec(v___x_909_);
v___x_925_ = lean_box(0);
v_isShared_926_ = v_isSharedCheck_930_;
goto v_resetjp_924_;
}
v_resetjp_924_:
{
lean_object* v___x_928_; 
if (v_isShared_926_ == 0)
{
v___x_928_ = v___x_925_;
goto v_reusejp_927_;
}
else
{
lean_object* v_reuseFailAlloc_929_; 
v_reuseFailAlloc_929_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_929_, 0, v_a_923_);
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
}
else
{
lean_object* v_a_931_; lean_object* v___x_933_; uint8_t v_isShared_934_; uint8_t v_isSharedCheck_938_; 
lean_del_object(v___x_886_);
lean_dec(v_snd_884_);
lean_dec(v_a_811_);
lean_dec_ref(v___x_810_);
lean_dec_ref(v___x_809_);
lean_dec(v___x_808_);
v_a_931_ = lean_ctor_get(v___x_895_, 0);
v_isSharedCheck_938_ = !lean_is_exclusive(v___x_895_);
if (v_isSharedCheck_938_ == 0)
{
v___x_933_ = v___x_895_;
v_isShared_934_ = v_isSharedCheck_938_;
goto v_resetjp_932_;
}
else
{
lean_inc(v_a_931_);
lean_dec(v___x_895_);
v___x_933_ = lean_box(0);
v_isShared_934_ = v_isSharedCheck_938_;
goto v_resetjp_932_;
}
v_resetjp_932_:
{
lean_object* v___x_936_; 
if (v_isShared_934_ == 0)
{
v___x_936_ = v___x_933_;
goto v_reusejp_935_;
}
else
{
lean_object* v_reuseFailAlloc_937_; 
v_reuseFailAlloc_937_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_937_, 0, v_a_931_);
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
else
{
lean_object* v_a_939_; lean_object* v___x_941_; uint8_t v_isShared_942_; uint8_t v_isSharedCheck_946_; 
lean_dec_ref_known(v___x_891_, 3);
lean_del_object(v___x_886_);
lean_dec(v_snd_884_);
lean_dec(v_a_811_);
lean_dec_ref(v___x_810_);
lean_dec_ref(v___x_809_);
lean_dec(v___x_808_);
v_a_939_ = lean_ctor_get(v___x_893_, 0);
v_isSharedCheck_946_ = !lean_is_exclusive(v___x_893_);
if (v_isSharedCheck_946_ == 0)
{
v___x_941_ = v___x_893_;
v_isShared_942_ = v_isSharedCheck_946_;
goto v_resetjp_940_;
}
else
{
lean_inc(v_a_939_);
lean_dec(v___x_893_);
v___x_941_ = lean_box(0);
v_isShared_942_ = v_isSharedCheck_946_;
goto v_resetjp_940_;
}
v_resetjp_940_:
{
lean_object* v___x_944_; 
if (v_isShared_942_ == 0)
{
v___x_944_ = v___x_941_;
goto v_reusejp_943_;
}
else
{
lean_object* v_reuseFailAlloc_945_; 
v_reuseFailAlloc_945_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_945_, 0, v_a_939_);
v___x_944_ = v_reuseFailAlloc_945_;
goto v_reusejp_943_;
}
v_reusejp_943_:
{
return v___x_944_;
}
}
}
}
}
}
else
{
lean_object* v_a_950_; lean_object* v___x_952_; uint8_t v_isShared_953_; uint8_t v_isSharedCheck_957_; 
lean_dec_ref(v_b_812_);
lean_dec(v_a_811_);
lean_dec_ref(v___x_810_);
lean_dec_ref(v___x_809_);
lean_dec(v___x_808_);
v_a_950_ = lean_ctor_get(v___x_882_, 0);
v_isSharedCheck_957_ = !lean_is_exclusive(v___x_882_);
if (v_isSharedCheck_957_ == 0)
{
v___x_952_ = v___x_882_;
v_isShared_953_ = v_isSharedCheck_957_;
goto v_resetjp_951_;
}
else
{
lean_inc(v_a_950_);
lean_dec(v___x_882_);
v___x_952_ = lean_box(0);
v_isShared_953_ = v_isSharedCheck_957_;
goto v_resetjp_951_;
}
v_resetjp_951_:
{
lean_object* v___x_955_; 
if (v_isShared_953_ == 0)
{
v___x_955_ = v___x_952_;
goto v_reusejp_954_;
}
else
{
lean_object* v_reuseFailAlloc_956_; 
v_reuseFailAlloc_956_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_956_, 0, v_a_950_);
v___x_955_ = v_reuseFailAlloc_956_;
goto v_reusejp_954_;
}
v_reusejp_954_:
{
return v___x_955_;
}
}
}
v___jp_855_:
{
lean_object* v_options_858_; uint8_t v_hasTrace_859_; 
v_options_858_ = lean_ctor_get(v___y_819_, 2);
v_hasTrace_859_ = lean_ctor_get_uint8(v_options_858_, sizeof(void*)*1);
if (v_hasTrace_859_ == 0)
{
lean_dec_ref(v___y_856_);
v___y_846_ = v___y_857_;
goto v___jp_845_;
}
else
{
lean_object* v_inheritedTraceOptions_860_; lean_object* v___x_861_; lean_object* v___x_862_; uint8_t v___x_863_; 
v_inheritedTraceOptions_860_ = lean_ctor_get(v___y_819_, 13);
v___x_861_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__3));
v___x_862_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__6, &l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__6_once, _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__6);
v___x_863_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_860_, v_options_858_, v___x_862_);
if (v___x_863_ == 0)
{
lean_dec_ref(v___y_856_);
v___y_846_ = v___y_857_;
goto v___jp_845_;
}
else
{
lean_object* v___x_864_; lean_object* v___x_865_; lean_object* v___x_866_; lean_object* v___x_867_; lean_object* v___x_868_; lean_object* v___x_869_; 
lean_inc_ref(v_type_853_);
v___x_864_ = l_Lean_MessageData_ofExpr(v_type_853_);
v___x_865_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__8, &l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__8_once, _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___closed__8);
v___x_866_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_866_, 0, v___x_864_);
lean_ctor_set(v___x_866_, 1, v___x_865_);
v___x_867_ = l_Lean_MessageData_ofExpr(v___y_856_);
v___x_868_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_868_, 0, v___x_866_);
lean_ctor_set(v___x_868_, 1, v___x_867_);
v___x_869_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg(v___x_861_, v___x_868_, v___y_817_, v___y_818_, v___y_819_, v___y_820_);
if (lean_obj_tag(v___x_869_) == 0)
{
lean_object* v_a_870_; lean_object* v___x_871_; 
v_a_870_ = lean_ctor_get(v___x_869_, 0);
lean_inc(v_a_870_);
lean_dec_ref_known(v___x_869_, 1);
lean_inc(v___y_820_);
lean_inc_ref(v___y_819_);
lean_inc(v___y_818_);
lean_inc_ref(v___y_817_);
lean_inc(v___y_816_);
lean_inc_ref(v___y_815_);
lean_inc(v___y_814_);
lean_inc_ref(v___y_813_);
v___x_871_ = lean_apply_10(v___y_857_, v_a_870_, v___y_813_, v___y_814_, v___y_815_, v___y_816_, v___y_817_, v___y_818_, v___y_819_, v___y_820_, lean_box(0));
v___y_823_ = v___x_871_;
goto v___jp_822_;
}
else
{
lean_object* v_a_872_; lean_object* v___x_874_; uint8_t v_isShared_875_; uint8_t v_isSharedCheck_879_; 
lean_dec_ref(v___y_857_);
lean_dec(v_a_811_);
lean_dec_ref(v___x_810_);
lean_dec_ref(v___x_809_);
lean_dec(v___x_808_);
v_a_872_ = lean_ctor_get(v___x_869_, 0);
v_isSharedCheck_879_ = !lean_is_exclusive(v___x_869_);
if (v_isSharedCheck_879_ == 0)
{
v___x_874_ = v___x_869_;
v_isShared_875_ = v_isSharedCheck_879_;
goto v_resetjp_873_;
}
else
{
lean_inc(v_a_872_);
lean_dec(v___x_869_);
v___x_874_ = lean_box(0);
v_isShared_875_ = v_isSharedCheck_879_;
goto v_resetjp_873_;
}
v_resetjp_873_:
{
lean_object* v___x_877_; 
if (v_isShared_875_ == 0)
{
v___x_877_ = v___x_874_;
goto v_reusejp_876_;
}
else
{
lean_object* v_reuseFailAlloc_878_; 
v_reuseFailAlloc_878_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_878_, 0, v_a_872_);
v___x_877_ = v_reuseFailAlloc_878_;
goto v_reusejp_876_;
}
v_reusejp_876_:
{
return v___x_877_;
}
}
}
}
}
}
}
v___jp_822_:
{
if (lean_obj_tag(v___y_823_) == 0)
{
lean_object* v_a_824_; lean_object* v___x_826_; uint8_t v_isShared_827_; uint8_t v_isSharedCheck_836_; 
v_a_824_ = lean_ctor_get(v___y_823_, 0);
v_isSharedCheck_836_ = !lean_is_exclusive(v___y_823_);
if (v_isSharedCheck_836_ == 0)
{
v___x_826_ = v___y_823_;
v_isShared_827_ = v_isSharedCheck_836_;
goto v_resetjp_825_;
}
else
{
lean_inc(v_a_824_);
lean_dec(v___y_823_);
v___x_826_ = lean_box(0);
v_isShared_827_ = v_isSharedCheck_836_;
goto v_resetjp_825_;
}
v_resetjp_825_:
{
if (lean_obj_tag(v_a_824_) == 0)
{
lean_object* v_a_828_; lean_object* v___x_830_; 
lean_dec(v_a_811_);
lean_dec_ref(v___x_810_);
lean_dec_ref(v___x_809_);
lean_dec(v___x_808_);
v_a_828_ = lean_ctor_get(v_a_824_, 0);
lean_inc(v_a_828_);
lean_dec_ref_known(v_a_824_, 1);
if (v_isShared_827_ == 0)
{
lean_ctor_set(v___x_826_, 0, v_a_828_);
v___x_830_ = v___x_826_;
goto v_reusejp_829_;
}
else
{
lean_object* v_reuseFailAlloc_831_; 
v_reuseFailAlloc_831_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_831_, 0, v_a_828_);
v___x_830_ = v_reuseFailAlloc_831_;
goto v_reusejp_829_;
}
v_reusejp_829_:
{
return v___x_830_;
}
}
else
{
lean_object* v_a_832_; lean_object* v___x_833_; lean_object* v___x_834_; 
lean_del_object(v___x_826_);
v_a_832_ = lean_ctor_get(v_a_824_, 0);
lean_inc(v_a_832_);
lean_dec_ref_known(v_a_824_, 1);
v___x_833_ = lean_unsigned_to_nat(1u);
v___x_834_ = lean_nat_add(v_a_811_, v___x_833_);
lean_dec(v_a_811_);
v_a_811_ = v___x_834_;
v_b_812_ = v_a_832_;
goto _start;
}
}
}
else
{
lean_object* v_a_837_; lean_object* v___x_839_; uint8_t v_isShared_840_; uint8_t v_isSharedCheck_844_; 
lean_dec(v_a_811_);
lean_dec_ref(v___x_810_);
lean_dec_ref(v___x_809_);
lean_dec(v___x_808_);
v_a_837_ = lean_ctor_get(v___y_823_, 0);
v_isSharedCheck_844_ = !lean_is_exclusive(v___y_823_);
if (v_isSharedCheck_844_ == 0)
{
v___x_839_ = v___y_823_;
v_isShared_840_ = v_isSharedCheck_844_;
goto v_resetjp_838_;
}
else
{
lean_inc(v_a_837_);
lean_dec(v___y_823_);
v___x_839_ = lean_box(0);
v_isShared_840_ = v_isSharedCheck_844_;
goto v_resetjp_838_;
}
v_resetjp_838_:
{
lean_object* v___x_842_; 
if (v_isShared_840_ == 0)
{
v___x_842_ = v___x_839_;
goto v_reusejp_841_;
}
else
{
lean_object* v_reuseFailAlloc_843_; 
v_reuseFailAlloc_843_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_843_, 0, v_a_837_);
v___x_842_ = v_reuseFailAlloc_843_;
goto v_reusejp_841_;
}
v_reusejp_841_:
{
return v___x_842_;
}
}
}
}
v___jp_845_:
{
lean_object* v___x_847_; lean_object* v___x_848_; 
v___x_847_ = lean_box(0);
lean_inc(v___y_820_);
lean_inc_ref(v___y_819_);
lean_inc(v___y_818_);
lean_inc_ref(v___y_817_);
lean_inc(v___y_816_);
lean_inc_ref(v___y_815_);
lean_inc(v___y_814_);
lean_inc_ref(v___y_813_);
v___x_848_ = lean_apply_10(v___y_846_, v___x_847_, v___y_813_, v___y_814_, v___y_815_, v___y_816_, v___y_817_, v___y_818_, v___y_819_, v___y_820_, lean_box(0));
v___y_823_ = v___x_848_;
goto v___jp_822_;
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg___boxed(lean_object* v_upperBound_958_, lean_object* v___x_959_, lean_object* v___x_960_, lean_object* v___x_961_, lean_object* v___x_962_, lean_object* v_a_963_, lean_object* v_b_964_, lean_object* v___y_965_, lean_object* v___y_966_, lean_object* v___y_967_, lean_object* v___y_968_, lean_object* v___y_969_, lean_object* v___y_970_, lean_object* v___y_971_, lean_object* v___y_972_, lean_object* v___y_973_){
_start:
{
lean_object* v_res_974_; 
v_res_974_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg(v_upperBound_958_, v___x_959_, v___x_960_, v___x_961_, v___x_962_, v_a_963_, v_b_964_, v___y_965_, v___y_966_, v___y_967_, v___y_968_, v___y_969_, v___y_970_, v___y_971_, v___y_972_);
lean_dec(v___y_972_);
lean_dec_ref(v___y_971_);
lean_dec(v___y_970_);
lean_dec_ref(v___y_969_);
lean_dec(v___y_968_);
lean_dec_ref(v___y_967_);
lean_dec(v___y_966_);
lean_dec_ref(v___y_965_);
lean_dec_ref(v___x_959_);
lean_dec(v_upperBound_958_);
return v_res_974_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__3(lean_object* v_maxSteps_975_, lean_object* v___x_976_, lean_object* v___x_977_, lean_object* v___y_978_, lean_object* v___y_979_, lean_object* v___y_980_, lean_object* v___y_981_, lean_object* v___y_982_, lean_object* v___y_983_, lean_object* v___y_984_, lean_object* v___y_985_){
_start:
{
lean_object* v___x_987_; lean_object* v_hypotheses_988_; lean_object* v___x_989_; lean_object* v_newHyps_990_; lean_object* v___x_991_; lean_object* v___x_992_; lean_object* v___x_993_; lean_object* v___x_994_; 
v___x_987_ = lean_st_ref_get(v___y_979_);
v_hypotheses_988_ = lean_ctor_get(v___x_987_, 4);
lean_inc_ref(v_hypotheses_988_);
lean_dec(v___x_987_);
v___x_989_ = lean_array_get_size(v_hypotheses_988_);
v_newHyps_990_ = lean_mk_empty_array_with_capacity(v___x_989_);
v___x_991_ = lean_unsigned_to_nat(0u);
v___x_992_ = lean_box(0);
v___x_993_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_993_, 0, v___x_992_);
lean_ctor_set(v___x_993_, 1, v_newHyps_990_);
v___x_994_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg(v___x_989_, v_hypotheses_988_, v_maxSteps_975_, v___x_976_, v___x_977_, v___x_991_, v___x_993_, v___y_978_, v___y_979_, v___y_980_, v___y_981_, v___y_982_, v___y_983_, v___y_984_, v___y_985_);
lean_dec_ref(v_hypotheses_988_);
if (lean_obj_tag(v___x_994_) == 0)
{
lean_object* v_a_995_; lean_object* v___x_997_; uint8_t v_isShared_998_; uint8_t v_isSharedCheck_1025_; 
v_a_995_ = lean_ctor_get(v___x_994_, 0);
v_isSharedCheck_1025_ = !lean_is_exclusive(v___x_994_);
if (v_isSharedCheck_1025_ == 0)
{
v___x_997_ = v___x_994_;
v_isShared_998_ = v_isSharedCheck_1025_;
goto v_resetjp_996_;
}
else
{
lean_inc(v_a_995_);
lean_dec(v___x_994_);
v___x_997_ = lean_box(0);
v_isShared_998_ = v_isSharedCheck_1025_;
goto v_resetjp_996_;
}
v_resetjp_996_:
{
lean_object* v_fst_999_; 
v_fst_999_ = lean_ctor_get(v_a_995_, 0);
if (lean_obj_tag(v_fst_999_) == 0)
{
lean_object* v_snd_1000_; lean_object* v___x_1001_; lean_object* v_rewriteCache_1002_; lean_object* v_acNfCache_1003_; lean_object* v_typeAnalysis_1004_; lean_object* v_goal_1005_; uint8_t v_didChange_1006_; lean_object* v___x_1008_; uint8_t v_isShared_1009_; uint8_t v_isSharedCheck_1019_; 
v_snd_1000_ = lean_ctor_get(v_a_995_, 1);
lean_inc(v_snd_1000_);
lean_dec(v_a_995_);
v___x_1001_ = lean_st_ref_take(v___y_979_);
v_rewriteCache_1002_ = lean_ctor_get(v___x_1001_, 0);
v_acNfCache_1003_ = lean_ctor_get(v___x_1001_, 1);
v_typeAnalysis_1004_ = lean_ctor_get(v___x_1001_, 2);
v_goal_1005_ = lean_ctor_get(v___x_1001_, 3);
v_didChange_1006_ = lean_ctor_get_uint8(v___x_1001_, sizeof(void*)*5);
v_isSharedCheck_1019_ = !lean_is_exclusive(v___x_1001_);
if (v_isSharedCheck_1019_ == 0)
{
lean_object* v_unused_1020_; 
v_unused_1020_ = lean_ctor_get(v___x_1001_, 4);
lean_dec(v_unused_1020_);
v___x_1008_ = v___x_1001_;
v_isShared_1009_ = v_isSharedCheck_1019_;
goto v_resetjp_1007_;
}
else
{
lean_inc(v_goal_1005_);
lean_inc(v_typeAnalysis_1004_);
lean_inc(v_acNfCache_1003_);
lean_inc(v_rewriteCache_1002_);
lean_dec(v___x_1001_);
v___x_1008_ = lean_box(0);
v_isShared_1009_ = v_isSharedCheck_1019_;
goto v_resetjp_1007_;
}
v_resetjp_1007_:
{
lean_object* v___x_1011_; 
if (v_isShared_1009_ == 0)
{
lean_ctor_set(v___x_1008_, 4, v_snd_1000_);
v___x_1011_ = v___x_1008_;
goto v_reusejp_1010_;
}
else
{
lean_object* v_reuseFailAlloc_1018_; 
v_reuseFailAlloc_1018_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_1018_, 0, v_rewriteCache_1002_);
lean_ctor_set(v_reuseFailAlloc_1018_, 1, v_acNfCache_1003_);
lean_ctor_set(v_reuseFailAlloc_1018_, 2, v_typeAnalysis_1004_);
lean_ctor_set(v_reuseFailAlloc_1018_, 3, v_goal_1005_);
lean_ctor_set(v_reuseFailAlloc_1018_, 4, v_snd_1000_);
lean_ctor_set_uint8(v_reuseFailAlloc_1018_, sizeof(void*)*5, v_didChange_1006_);
v___x_1011_ = v_reuseFailAlloc_1018_;
goto v_reusejp_1010_;
}
v_reusejp_1010_:
{
lean_object* v___x_1012_; uint8_t v___x_1013_; lean_object* v___x_1014_; lean_object* v___x_1016_; 
v___x_1012_ = lean_st_ref_set(v___y_979_, v___x_1011_);
v___x_1013_ = 0;
v___x_1014_ = lean_box(v___x_1013_);
if (v_isShared_998_ == 0)
{
lean_ctor_set(v___x_997_, 0, v___x_1014_);
v___x_1016_ = v___x_997_;
goto v_reusejp_1015_;
}
else
{
lean_object* v_reuseFailAlloc_1017_; 
v_reuseFailAlloc_1017_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1017_, 0, v___x_1014_);
v___x_1016_ = v_reuseFailAlloc_1017_;
goto v_reusejp_1015_;
}
v_reusejp_1015_:
{
return v___x_1016_;
}
}
}
}
else
{
lean_object* v_val_1021_; lean_object* v___x_1023_; 
lean_inc_ref(v_fst_999_);
lean_dec(v_a_995_);
v_val_1021_ = lean_ctor_get(v_fst_999_, 0);
lean_inc(v_val_1021_);
lean_dec_ref_known(v_fst_999_, 1);
if (v_isShared_998_ == 0)
{
lean_ctor_set(v___x_997_, 0, v_val_1021_);
v___x_1023_ = v___x_997_;
goto v_reusejp_1022_;
}
else
{
lean_object* v_reuseFailAlloc_1024_; 
v_reuseFailAlloc_1024_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1024_, 0, v_val_1021_);
v___x_1023_ = v_reuseFailAlloc_1024_;
goto v_reusejp_1022_;
}
v_reusejp_1022_:
{
return v___x_1023_;
}
}
}
}
else
{
lean_object* v_a_1026_; lean_object* v___x_1028_; uint8_t v_isShared_1029_; uint8_t v_isSharedCheck_1033_; 
v_a_1026_ = lean_ctor_get(v___x_994_, 0);
v_isSharedCheck_1033_ = !lean_is_exclusive(v___x_994_);
if (v_isSharedCheck_1033_ == 0)
{
v___x_1028_ = v___x_994_;
v_isShared_1029_ = v_isSharedCheck_1033_;
goto v_resetjp_1027_;
}
else
{
lean_inc(v_a_1026_);
lean_dec(v___x_994_);
v___x_1028_ = lean_box(0);
v_isShared_1029_ = v_isSharedCheck_1033_;
goto v_resetjp_1027_;
}
v_resetjp_1027_:
{
lean_object* v___x_1031_; 
if (v_isShared_1029_ == 0)
{
v___x_1031_ = v___x_1028_;
goto v_reusejp_1030_;
}
else
{
lean_object* v_reuseFailAlloc_1032_; 
v_reuseFailAlloc_1032_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1032_, 0, v_a_1026_);
v___x_1031_ = v_reuseFailAlloc_1032_;
goto v_reusejp_1030_;
}
v_reusejp_1030_:
{
return v___x_1031_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__3___boxed(lean_object* v_maxSteps_1034_, lean_object* v___x_1035_, lean_object* v___x_1036_, lean_object* v___y_1037_, lean_object* v___y_1038_, lean_object* v___y_1039_, lean_object* v___y_1040_, lean_object* v___y_1041_, lean_object* v___y_1042_, lean_object* v___y_1043_, lean_object* v___y_1044_, lean_object* v___y_1045_){
_start:
{
lean_object* v_res_1046_; 
v_res_1046_ = l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__3(v_maxSteps_1034_, v___x_1035_, v___x_1036_, v___y_1037_, v___y_1038_, v___y_1039_, v___y_1040_, v___y_1041_, v___y_1042_, v___y_1043_, v___y_1044_);
lean_dec(v___y_1044_);
lean_dec_ref(v___y_1043_);
lean_dec(v___y_1042_);
lean_dec_ref(v___y_1041_);
lean_dec(v___y_1040_);
lean_dec_ref(v___y_1039_);
lean_dec(v___y_1038_);
lean_dec_ref(v___y_1037_);
return v_res_1046_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4(lean_object* v___x_1051_, lean_object* v___f_1052_, lean_object* v___y_1053_, lean_object* v___y_1054_, lean_object* v___y_1055_, lean_object* v___y_1056_, lean_object* v___y_1057_, lean_object* v___y_1058_, lean_object* v___y_1059_, lean_object* v___y_1060_){
_start:
{
lean_object* v___x_1062_; 
v___x_1062_ = l_Lean_Meta_Sym_Simp_SymSimpExtension_getTheorems___redArg(v___x_1051_, v___y_1060_);
if (lean_obj_tag(v___x_1062_) == 0)
{
lean_object* v_a_1063_; lean_object* v___x_1064_; lean_object* v_maxSteps_1065_; lean_object* v_goal_1066_; lean_object* v___x_1067_; lean_object* v___x_1068_; lean_object* v___x_1069_; lean_object* v___x_1070_; lean_object* v___f_1071_; lean_object* v___f_1072_; lean_object* v___x_1073_; lean_object* v___f_1074_; lean_object* v___x_1075_; 
v_a_1063_ = lean_ctor_get(v___x_1062_, 0);
lean_inc(v_a_1063_);
lean_dec_ref_known(v___x_1062_, 1);
v___x_1064_ = lean_st_ref_get(v___y_1054_);
v_maxSteps_1065_ = lean_ctor_get(v___y_1053_, 1);
v_goal_1066_ = lean_ctor_get(v___x_1064_, 3);
lean_inc(v_goal_1066_);
lean_dec(v___x_1064_);
v___x_1067_ = lean_unsigned_to_nat(255u);
v___x_1068_ = lean_unsigned_to_nat(2u);
lean_inc_n(v_maxSteps_1065_, 2);
v___x_1069_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1069_, 0, v_maxSteps_1065_);
lean_ctor_set(v___x_1069_, 1, v___x_1068_);
v___x_1070_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___closed__1));
v___f_1071_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__1___boxed), 14, 2);
lean_closure_set(v___f_1071_, 0, v_a_1063_);
lean_closure_set(v___f_1071_, 1, v___x_1070_);
v___f_1072_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__2___boxed), 13, 2);
lean_closure_set(v___f_1072_, 0, v___x_1067_);
lean_closure_set(v___f_1072_, 1, v___f_1071_);
v___x_1073_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1073_, 0, v___f_1052_);
lean_ctor_set(v___x_1073_, 1, v___f_1072_);
v___f_1074_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__3___boxed), 12, 3);
lean_closure_set(v___f_1074_, 0, v_maxSteps_1065_);
lean_closure_set(v___f_1074_, 1, v___x_1073_);
lean_closure_set(v___f_1074_, 2, v___x_1069_);
v___x_1075_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__3___redArg(v_goal_1066_, v___f_1074_, v___y_1053_, v___y_1054_, v___y_1055_, v___y_1056_, v___y_1057_, v___y_1058_, v___y_1059_, v___y_1060_);
return v___x_1075_;
}
else
{
lean_object* v_a_1076_; lean_object* v___x_1078_; uint8_t v_isShared_1079_; uint8_t v_isSharedCheck_1083_; 
lean_dec_ref(v___f_1052_);
v_a_1076_ = lean_ctor_get(v___x_1062_, 0);
v_isSharedCheck_1083_ = !lean_is_exclusive(v___x_1062_);
if (v_isSharedCheck_1083_ == 0)
{
v___x_1078_ = v___x_1062_;
v_isShared_1079_ = v_isSharedCheck_1083_;
goto v_resetjp_1077_;
}
else
{
lean_inc(v_a_1076_);
lean_dec(v___x_1062_);
v___x_1078_ = lean_box(0);
v_isShared_1079_ = v_isSharedCheck_1083_;
goto v_resetjp_1077_;
}
v_resetjp_1077_:
{
lean_object* v___x_1081_; 
if (v_isShared_1079_ == 0)
{
v___x_1081_ = v___x_1078_;
goto v_reusejp_1080_;
}
else
{
lean_object* v_reuseFailAlloc_1082_; 
v_reuseFailAlloc_1082_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1082_, 0, v_a_1076_);
v___x_1081_ = v_reuseFailAlloc_1082_;
goto v_reusejp_1080_;
}
v_reusejp_1080_:
{
return v___x_1081_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___boxed(lean_object* v___x_1084_, lean_object* v___f_1085_, lean_object* v___y_1086_, lean_object* v___y_1087_, lean_object* v___y_1088_, lean_object* v___y_1089_, lean_object* v___y_1090_, lean_object* v___y_1091_, lean_object* v___y_1092_, lean_object* v___y_1093_, lean_object* v___y_1094_){
_start:
{
lean_object* v_res_1095_; 
v_res_1095_ = l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4(v___x_1084_, v___f_1085_, v___y_1086_, v___y_1087_, v___y_1088_, v___y_1089_, v___y_1090_, v___y_1091_, v___y_1092_, v___y_1093_);
lean_dec(v___y_1093_);
lean_dec_ref(v___y_1092_);
lean_dec(v___y_1091_);
lean_dec_ref(v___y_1090_);
lean_dec(v___y_1089_);
lean_dec_ref(v___y_1088_);
lean_dec(v___y_1087_);
lean_dec_ref(v___y_1086_);
lean_dec_ref(v___x_1084_);
return v_res_1095_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__3(void){
_start:
{
lean_object* v___f_1100_; lean_object* v___x_1101_; lean_object* v___f_1102_; 
v___f_1100_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__0));
v___x_1101_ = l_Lean_Meta_Tactic_BVDecide_bvNormalizeExt;
v___f_1102_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___lam__4___boxed), 11, 2);
lean_closure_set(v___f_1102_, 0, v___x_1101_);
lean_closure_set(v___f_1102_, 1, v___f_1100_);
return v___f_1102_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__4(void){
_start:
{
lean_object* v___f_1103_; lean_object* v___x_1104_; lean_object* v___x_1105_; 
v___f_1103_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__3, &l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__3);
v___x_1104_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__2));
v___x_1105_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1105_, 0, v___x_1104_);
lean_ctor_set(v___x_1105_, 1, v___f_1103_);
return v___x_1105_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass(void){
_start:
{
lean_object* v___x_1106_; 
v___x_1106_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__4, &l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__4_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass___closed__4);
return v___x_1106_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0(lean_object* v_cls_1107_, lean_object* v_msg_1108_, lean_object* v___y_1109_, lean_object* v___y_1110_, lean_object* v___y_1111_, lean_object* v___y_1112_, lean_object* v___y_1113_, lean_object* v___y_1114_, lean_object* v___y_1115_, lean_object* v___y_1116_){
_start:
{
lean_object* v___x_1118_; 
v___x_1118_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___redArg(v_cls_1107_, v_msg_1108_, v___y_1113_, v___y_1114_, v___y_1115_, v___y_1116_);
return v___x_1118_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0___boxed(lean_object* v_cls_1119_, lean_object* v_msg_1120_, lean_object* v___y_1121_, lean_object* v___y_1122_, lean_object* v___y_1123_, lean_object* v___y_1124_, lean_object* v___y_1125_, lean_object* v___y_1126_, lean_object* v___y_1127_, lean_object* v___y_1128_, lean_object* v___y_1129_){
_start:
{
lean_object* v_res_1130_; 
v_res_1130_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__0(v_cls_1119_, v_msg_1120_, v___y_1121_, v___y_1122_, v___y_1123_, v___y_1124_, v___y_1125_, v___y_1126_, v___y_1127_, v___y_1128_);
lean_dec(v___y_1128_);
lean_dec_ref(v___y_1127_);
lean_dec(v___y_1126_);
lean_dec_ref(v___y_1125_);
lean_dec(v___y_1124_);
lean_dec_ref(v___y_1123_);
lean_dec(v___y_1122_);
lean_dec_ref(v___y_1121_);
return v_res_1130_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1(lean_object* v_mvarId_1131_, lean_object* v_val_1132_, lean_object* v___y_1133_, lean_object* v___y_1134_, lean_object* v___y_1135_, lean_object* v___y_1136_, lean_object* v___y_1137_, lean_object* v___y_1138_, lean_object* v___y_1139_, lean_object* v___y_1140_){
_start:
{
lean_object* v___x_1142_; 
v___x_1142_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1___redArg(v_mvarId_1131_, v_val_1132_, v___y_1138_);
return v___x_1142_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1___boxed(lean_object* v_mvarId_1143_, lean_object* v_val_1144_, lean_object* v___y_1145_, lean_object* v___y_1146_, lean_object* v___y_1147_, lean_object* v___y_1148_, lean_object* v___y_1149_, lean_object* v___y_1150_, lean_object* v___y_1151_, lean_object* v___y_1152_, lean_object* v___y_1153_){
_start:
{
lean_object* v_res_1154_; 
v_res_1154_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1(v_mvarId_1143_, v_val_1144_, v___y_1145_, v___y_1146_, v___y_1147_, v___y_1148_, v___y_1149_, v___y_1150_, v___y_1151_, v___y_1152_);
lean_dec(v___y_1152_);
lean_dec_ref(v___y_1151_);
lean_dec(v___y_1150_);
lean_dec_ref(v___y_1149_);
lean_dec(v___y_1148_);
lean_dec_ref(v___y_1147_);
lean_dec(v___y_1146_);
lean_dec_ref(v___y_1145_);
return v_res_1154_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2(lean_object* v_upperBound_1155_, lean_object* v___x_1156_, lean_object* v___x_1157_, lean_object* v___x_1158_, lean_object* v___x_1159_, lean_object* v_inst_1160_, lean_object* v_R_1161_, lean_object* v_a_1162_, lean_object* v_b_1163_, lean_object* v_c_1164_, lean_object* v___y_1165_, lean_object* v___y_1166_, lean_object* v___y_1167_, lean_object* v___y_1168_, lean_object* v___y_1169_, lean_object* v___y_1170_, lean_object* v___y_1171_, lean_object* v___y_1172_){
_start:
{
lean_object* v___x_1174_; 
v___x_1174_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___redArg(v_upperBound_1155_, v___x_1156_, v___x_1157_, v___x_1158_, v___x_1159_, v_a_1162_, v_b_1163_, v___y_1165_, v___y_1166_, v___y_1167_, v___y_1168_, v___y_1169_, v___y_1170_, v___y_1171_, v___y_1172_);
return v___x_1174_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2___boxed(lean_object** _args){
lean_object* v_upperBound_1175_ = _args[0];
lean_object* v___x_1176_ = _args[1];
lean_object* v___x_1177_ = _args[2];
lean_object* v___x_1178_ = _args[3];
lean_object* v___x_1179_ = _args[4];
lean_object* v_inst_1180_ = _args[5];
lean_object* v_R_1181_ = _args[6];
lean_object* v_a_1182_ = _args[7];
lean_object* v_b_1183_ = _args[8];
lean_object* v_c_1184_ = _args[9];
lean_object* v___y_1185_ = _args[10];
lean_object* v___y_1186_ = _args[11];
lean_object* v___y_1187_ = _args[12];
lean_object* v___y_1188_ = _args[13];
lean_object* v___y_1189_ = _args[14];
lean_object* v___y_1190_ = _args[15];
lean_object* v___y_1191_ = _args[16];
lean_object* v___y_1192_ = _args[17];
lean_object* v___y_1193_ = _args[18];
_start:
{
lean_object* v_res_1194_; 
v_res_1194_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__2(v_upperBound_1175_, v___x_1176_, v___x_1177_, v___x_1178_, v___x_1179_, v_inst_1180_, v_R_1181_, v_a_1182_, v_b_1183_, v_c_1184_, v___y_1185_, v___y_1186_, v___y_1187_, v___y_1188_, v___y_1189_, v___y_1190_, v___y_1191_, v___y_1192_);
lean_dec(v___y_1192_);
lean_dec_ref(v___y_1191_);
lean_dec(v___y_1190_);
lean_dec_ref(v___y_1189_);
lean_dec(v___y_1188_);
lean_dec_ref(v___y_1187_);
lean_dec(v___y_1186_);
lean_dec_ref(v___y_1185_);
lean_dec_ref(v___x_1176_);
lean_dec(v_upperBound_1175_);
return v_res_1194_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2(lean_object* v_00_u03b2_1195_, lean_object* v_x_1196_, lean_object* v_x_1197_, lean_object* v_x_1198_){
_start:
{
lean_object* v___x_1199_; 
v___x_1199_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2___redArg(v_x_1196_, v_x_1197_, v_x_1198_);
return v___x_1199_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4(lean_object* v_00_u03b2_1200_, lean_object* v_x_1201_, size_t v_x_1202_, size_t v_x_1203_, lean_object* v_x_1204_, lean_object* v_x_1205_){
_start:
{
lean_object* v___x_1206_; 
v___x_1206_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___redArg(v_x_1201_, v_x_1202_, v_x_1203_, v_x_1204_, v_x_1205_);
return v___x_1206_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4___boxed(lean_object* v_00_u03b2_1207_, lean_object* v_x_1208_, lean_object* v_x_1209_, lean_object* v_x_1210_, lean_object* v_x_1211_, lean_object* v_x_1212_){
_start:
{
size_t v_x_35115__boxed_1213_; size_t v_x_35116__boxed_1214_; lean_object* v_res_1215_; 
v_x_35115__boxed_1213_ = lean_unbox_usize(v_x_1209_);
lean_dec(v_x_1209_);
v_x_35116__boxed_1214_ = lean_unbox_usize(v_x_1210_);
lean_dec(v_x_1210_);
v_res_1215_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4(v_00_u03b2_1207_, v_x_1208_, v_x_35115__boxed_1213_, v_x_35116__boxed_1214_, v_x_1211_, v_x_1212_);
return v_res_1215_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6(lean_object* v_00_u03b2_1216_, lean_object* v_n_1217_, lean_object* v_k_1218_, lean_object* v_v_1219_){
_start:
{
lean_object* v___x_1220_; 
v___x_1220_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6___redArg(v_n_1217_, v_k_1218_, v_v_1219_);
return v___x_1220_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7(lean_object* v_00_u03b2_1221_, size_t v_depth_1222_, lean_object* v_keys_1223_, lean_object* v_vals_1224_, lean_object* v_heq_1225_, lean_object* v_i_1226_, lean_object* v_entries_1227_){
_start:
{
lean_object* v___x_1228_; 
v___x_1228_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7___redArg(v_depth_1222_, v_keys_1223_, v_vals_1224_, v_i_1226_, v_entries_1227_);
return v___x_1228_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7___boxed(lean_object* v_00_u03b2_1229_, lean_object* v_depth_1230_, lean_object* v_keys_1231_, lean_object* v_vals_1232_, lean_object* v_heq_1233_, lean_object* v_i_1234_, lean_object* v_entries_1235_){
_start:
{
size_t v_depth_boxed_1236_; lean_object* v_res_1237_; 
v_depth_boxed_1236_ = lean_unbox_usize(v_depth_1230_);
lean_dec(v_depth_1230_);
v_res_1237_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__7(v_00_u03b2_1229_, v_depth_boxed_1236_, v_keys_1231_, v_vals_1232_, v_heq_1233_, v_i_1234_, v_entries_1235_);
lean_dec_ref(v_vals_1232_);
lean_dec_ref(v_keys_1231_);
return v_res_1237_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6_spec__7(lean_object* v_00_u03b2_1238_, lean_object* v_x_1239_, lean_object* v_x_1240_, lean_object* v_x_1241_, lean_object* v_x_1242_){
_start:
{
lean_object* v___x_1243_; 
v___x_1243_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(v_x_1239_, v_x_1240_, v_x_1241_, v_x_1242_);
return v___x_1243_;
}
}
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Simproc(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_Rewrite(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_EvalGround(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_DSimp(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Rewrite(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Simproc(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_EvalGround(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_DSimp(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass = _init_l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass();
lean_mark_persistent(l_Lean_Meta_Tactic_BVDecide_Normalize_rewriteRulesPass);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Rewrite(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Simproc(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_Rewrite(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_EvalGround(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_DSimp(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Rewrite(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_BVDecide_Normalize_Simproc(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_EvalGround(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_DSimp(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Rewrite(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Meta_Tactic_BVDecide_Normalize_Rewrite(builtin);
}
#ifdef __cplusplus
}
#endif
