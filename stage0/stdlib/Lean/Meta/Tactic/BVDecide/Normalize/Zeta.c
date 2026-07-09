// Lean compiler output
// Module: Lean.Meta.Tactic.BVDecide.Normalize.Zeta
// Imports: public import Lean.Meta.Tactic.BVDecide.Normalize.Basic import Lean.Meta.Sym.Simp.Theorems import Lean.Meta.Sym.DSimp
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
lean_object* lean_array_push(lean_object*, lean_object*);
lean_object* lean_array_fget_borrowed(lean_object*, lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
lean_object* l_Lean_PersistentHashMap_mkEmptyEntries(lean_object*, lean_object*);
size_t lean_usize_sub(size_t, size_t);
size_t lean_usize_mul(size_t, size_t);
uint8_t lean_usize_dec_le(size_t, size_t);
lean_object* l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(lean_object*);
lean_object* l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr1(lean_object*);
lean_object* lean_st_ref_get(lean_object*);
lean_object* l_Lean_Meta_Sym_Internal_Sym_assertShared(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr3(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_append(lean_object*, lean_object*);
uint8_t l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_MessageData_ofExpr(lean_object*);
lean_object* l_Lean_stringToMessageData(lean_object*);
lean_object* lean_st_ref_take(lean_object*);
double lean_float_of_nat(lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* l_Lean_PersistentArray_push___redArg(lean_object*, lean_object*);
lean_object* lean_st_ref_set(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_DSimp_zeta___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_DSimp_zetaDeltaAll___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_DSimp_dsimp___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_DSimp_DSimpM_run_x27___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_Expr_isFalse(lean_object*);
uint8_t l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(lean_object*, lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6___redArg(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg___closed__0;
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg(lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7___redArg(size_t, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__3(uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*0 + 8, .m_other = 0, .m_tag = 0}, .m_objs = {LEAN_SCALAR_PTR_LITERAL(0, 0, 0, 0, 0, 0, 0, 0)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1___closed__0 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1___closed__0_value;
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static double l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__0;
static const lean_string_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 1, .m_capacity = 1, .m_length = 0, .m_data = ""};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__1 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__1_value;
static const lean_array_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__2 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__2_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Meta"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__0 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__0_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__1 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__1_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "bv"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__2 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__2_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__3_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(211, 174, 49, 251, 64, 24, 251, 1)}};
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__3_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__3_value_aux_0),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(194, 95, 140, 15, 16, 100, 236, 219)}};
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__3_value_aux_1),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__2_value),LEAN_SCALAR_PTR_LITERAL(139, 41, 106, 94, 234, 34, 111, 146)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__3 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__3_value;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trace"};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__4 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__4_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__4_value),LEAN_SCALAR_PTR_LITERAL(212, 145, 141, 177, 67, 149, 127, 197)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__5 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__5_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__6;
static const lean_string_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "  ==>  "};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__7 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__7_value;
static lean_once_cell_t l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__8_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__8;
static const lean_closure_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__9_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__0___boxed, .m_arity = 11, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__9 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__9_value;
static const lean_closure_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1___boxed, .m_arity = 11, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__10 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__10_value;
static const lean_ctor_object l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__11_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__9_value),((lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__10_value)}};
static const lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__11 = (const lean_object*)&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__11_value;
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__1___boxed, .m_arity = 9, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "zetaPass"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__1_value),LEAN_SCALAR_PTR_LITERAL(193, 218, 201, 190, 32, 98, 30, 98)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__2_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__2_value),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__0_value)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__3_value;
LEAN_EXPORT const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___closed__3_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4(lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7(lean_object*, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6_spec__7(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg___lam__0(lean_object* v_x_1_, lean_object* v___y_2_, lean_object* v___y_3_, lean_object* v___y_4_, lean_object* v___y_5_, lean_object* v___y_6_, lean_object* v___y_7_, lean_object* v___y_8_, lean_object* v___y_9_){
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
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg___lam__0___boxed(lean_object* v_x_12_, lean_object* v___y_13_, lean_object* v___y_14_, lean_object* v___y_15_, lean_object* v___y_16_, lean_object* v___y_17_, lean_object* v___y_18_, lean_object* v___y_19_, lean_object* v___y_20_, lean_object* v___y_21_){
_start:
{
lean_object* v_res_22_; 
v_res_22_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg___lam__0(v_x_12_, v___y_13_, v___y_14_, v___y_15_, v___y_16_, v___y_17_, v___y_18_, v___y_19_, v___y_20_);
lean_dec(v___y_16_);
lean_dec_ref(v___y_15_);
lean_dec(v___y_14_);
lean_dec_ref(v___y_13_);
return v_res_22_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg(lean_object* v_mvarId_23_, lean_object* v_x_24_, lean_object* v___y_25_, lean_object* v___y_26_, lean_object* v___y_27_, lean_object* v___y_28_, lean_object* v___y_29_, lean_object* v___y_30_, lean_object* v___y_31_, lean_object* v___y_32_){
_start:
{
lean_object* v___f_34_; lean_object* v___x_35_; 
lean_inc(v___y_28_);
lean_inc_ref(v___y_27_);
lean_inc(v___y_26_);
lean_inc_ref(v___y_25_);
v___f_34_ = lean_alloc_closure((void*)(l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg___lam__0___boxed), 10, 5);
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
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg___boxed(lean_object* v_mvarId_44_, lean_object* v_x_45_, lean_object* v___y_46_, lean_object* v___y_47_, lean_object* v___y_48_, lean_object* v___y_49_, lean_object* v___y_50_, lean_object* v___y_51_, lean_object* v___y_52_, lean_object* v___y_53_, lean_object* v___y_54_){
_start:
{
lean_object* v_res_55_; 
v_res_55_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg(v_mvarId_44_, v_x_45_, v___y_46_, v___y_47_, v___y_48_, v___y_49_, v___y_50_, v___y_51_, v___y_52_, v___y_53_);
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
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3(lean_object* v_00_u03b1_56_, lean_object* v_mvarId_57_, lean_object* v_x_58_, lean_object* v___y_59_, lean_object* v___y_60_, lean_object* v___y_61_, lean_object* v___y_62_, lean_object* v___y_63_, lean_object* v___y_64_, lean_object* v___y_65_, lean_object* v___y_66_){
_start:
{
lean_object* v___x_68_; 
v___x_68_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg(v_mvarId_57_, v_x_58_, v___y_59_, v___y_60_, v___y_61_, v___y_62_, v___y_63_, v___y_64_, v___y_65_, v___y_66_);
return v___x_68_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___boxed(lean_object* v_00_u03b1_69_, lean_object* v_mvarId_70_, lean_object* v_x_71_, lean_object* v___y_72_, lean_object* v___y_73_, lean_object* v___y_74_, lean_object* v___y_75_, lean_object* v___y_76_, lean_object* v___y_77_, lean_object* v___y_78_, lean_object* v___y_79_, lean_object* v___y_80_){
_start:
{
lean_object* v_res_81_; 
v_res_81_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3(v_00_u03b1_69_, v_mvarId_70_, v_x_71_, v___y_72_, v___y_73_, v___y_74_, v___y_75_, v___y_76_, v___y_77_, v___y_78_, v___y_79_);
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
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(lean_object* v_x_82_, lean_object* v_x_83_, lean_object* v_x_84_, lean_object* v_x_85_){
_start:
{
lean_object* v_ks_86_; lean_object* v_vs_87_; lean_object* v___x_89_; uint8_t v_isShared_90_; uint8_t v_isSharedCheck_111_; 
v_ks_86_ = lean_ctor_get(v_x_82_, 0);
v_vs_87_ = lean_ctor_get(v_x_82_, 1);
v_isSharedCheck_111_ = !lean_is_exclusive(v_x_82_);
if (v_isSharedCheck_111_ == 0)
{
v___x_89_ = v_x_82_;
v_isShared_90_ = v_isSharedCheck_111_;
goto v_resetjp_88_;
}
else
{
lean_inc(v_vs_87_);
lean_inc(v_ks_86_);
lean_dec(v_x_82_);
v___x_89_ = lean_box(0);
v_isShared_90_ = v_isSharedCheck_111_;
goto v_resetjp_88_;
}
v_resetjp_88_:
{
lean_object* v___x_91_; uint8_t v___x_92_; 
v___x_91_ = lean_array_get_size(v_ks_86_);
v___x_92_ = lean_nat_dec_lt(v_x_83_, v___x_91_);
if (v___x_92_ == 0)
{
lean_object* v___x_93_; lean_object* v___x_94_; lean_object* v___x_96_; 
lean_dec(v_x_83_);
v___x_93_ = lean_array_push(v_ks_86_, v_x_84_);
v___x_94_ = lean_array_push(v_vs_87_, v_x_85_);
if (v_isShared_90_ == 0)
{
lean_ctor_set(v___x_89_, 1, v___x_94_);
lean_ctor_set(v___x_89_, 0, v___x_93_);
v___x_96_ = v___x_89_;
goto v_reusejp_95_;
}
else
{
lean_object* v_reuseFailAlloc_97_; 
v_reuseFailAlloc_97_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_97_, 0, v___x_93_);
lean_ctor_set(v_reuseFailAlloc_97_, 1, v___x_94_);
v___x_96_ = v_reuseFailAlloc_97_;
goto v_reusejp_95_;
}
v_reusejp_95_:
{
return v___x_96_;
}
}
else
{
lean_object* v_k_x27_98_; uint8_t v___x_99_; 
v_k_x27_98_ = lean_array_fget_borrowed(v_ks_86_, v_x_83_);
v___x_99_ = l_Lean_instBEqMVarId_beq(v_x_84_, v_k_x27_98_);
if (v___x_99_ == 0)
{
lean_object* v___x_101_; 
if (v_isShared_90_ == 0)
{
v___x_101_ = v___x_89_;
goto v_reusejp_100_;
}
else
{
lean_object* v_reuseFailAlloc_105_; 
v_reuseFailAlloc_105_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_105_, 0, v_ks_86_);
lean_ctor_set(v_reuseFailAlloc_105_, 1, v_vs_87_);
v___x_101_ = v_reuseFailAlloc_105_;
goto v_reusejp_100_;
}
v_reusejp_100_:
{
lean_object* v___x_102_; lean_object* v___x_103_; 
v___x_102_ = lean_unsigned_to_nat(1u);
v___x_103_ = lean_nat_add(v_x_83_, v___x_102_);
lean_dec(v_x_83_);
v_x_82_ = v___x_101_;
v_x_83_ = v___x_103_;
goto _start;
}
}
else
{
lean_object* v___x_106_; lean_object* v___x_107_; lean_object* v___x_109_; 
v___x_106_ = lean_array_fset(v_ks_86_, v_x_83_, v_x_84_);
v___x_107_ = lean_array_fset(v_vs_87_, v_x_83_, v_x_85_);
lean_dec(v_x_83_);
if (v_isShared_90_ == 0)
{
lean_ctor_set(v___x_89_, 1, v___x_107_);
lean_ctor_set(v___x_89_, 0, v___x_106_);
v___x_109_ = v___x_89_;
goto v_reusejp_108_;
}
else
{
lean_object* v_reuseFailAlloc_110_; 
v_reuseFailAlloc_110_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_110_, 0, v___x_106_);
lean_ctor_set(v_reuseFailAlloc_110_, 1, v___x_107_);
v___x_109_ = v_reuseFailAlloc_110_;
goto v_reusejp_108_;
}
v_reusejp_108_:
{
return v___x_109_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6___redArg(lean_object* v_n_112_, lean_object* v_k_113_, lean_object* v_v_114_){
_start:
{
lean_object* v___x_115_; lean_object* v___x_116_; 
v___x_115_ = lean_unsigned_to_nat(0u);
v___x_116_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(v_n_112_, v___x_115_, v_k_113_, v_v_114_);
return v___x_116_;
}
}
static lean_object* _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg___closed__0(void){
_start:
{
lean_object* v___x_117_; 
v___x_117_ = l_Lean_PersistentHashMap_mkEmptyEntries(lean_box(0), lean_box(0));
return v___x_117_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg(lean_object* v_x_118_, size_t v_x_119_, size_t v_x_120_, lean_object* v_x_121_, lean_object* v_x_122_){
_start:
{
if (lean_obj_tag(v_x_118_) == 0)
{
lean_object* v_es_123_; size_t v___x_124_; size_t v___x_125_; lean_object* v_j_126_; lean_object* v___x_127_; uint8_t v___x_128_; 
v_es_123_ = lean_ctor_get(v_x_118_, 0);
v___x_124_ = ((size_t)31ULL);
v___x_125_ = lean_usize_land(v_x_119_, v___x_124_);
v_j_126_ = lean_usize_to_nat(v___x_125_);
v___x_127_ = lean_array_get_size(v_es_123_);
v___x_128_ = lean_nat_dec_lt(v_j_126_, v___x_127_);
if (v___x_128_ == 0)
{
lean_dec(v_j_126_);
lean_dec(v_x_122_);
lean_dec(v_x_121_);
return v_x_118_;
}
else
{
lean_object* v___x_130_; uint8_t v_isShared_131_; uint8_t v_isSharedCheck_167_; 
lean_inc_ref(v_es_123_);
v_isSharedCheck_167_ = !lean_is_exclusive(v_x_118_);
if (v_isSharedCheck_167_ == 0)
{
lean_object* v_unused_168_; 
v_unused_168_ = lean_ctor_get(v_x_118_, 0);
lean_dec(v_unused_168_);
v___x_130_ = v_x_118_;
v_isShared_131_ = v_isSharedCheck_167_;
goto v_resetjp_129_;
}
else
{
lean_dec(v_x_118_);
v___x_130_ = lean_box(0);
v_isShared_131_ = v_isSharedCheck_167_;
goto v_resetjp_129_;
}
v_resetjp_129_:
{
lean_object* v_v_132_; lean_object* v___x_133_; lean_object* v_xs_x27_134_; lean_object* v___y_136_; 
v_v_132_ = lean_array_fget(v_es_123_, v_j_126_);
v___x_133_ = lean_box(0);
v_xs_x27_134_ = lean_array_fset(v_es_123_, v_j_126_, v___x_133_);
switch(lean_obj_tag(v_v_132_))
{
case 0:
{
lean_object* v_key_141_; lean_object* v_val_142_; lean_object* v___x_144_; uint8_t v_isShared_145_; uint8_t v_isSharedCheck_152_; 
v_key_141_ = lean_ctor_get(v_v_132_, 0);
v_val_142_ = lean_ctor_get(v_v_132_, 1);
v_isSharedCheck_152_ = !lean_is_exclusive(v_v_132_);
if (v_isSharedCheck_152_ == 0)
{
v___x_144_ = v_v_132_;
v_isShared_145_ = v_isSharedCheck_152_;
goto v_resetjp_143_;
}
else
{
lean_inc(v_val_142_);
lean_inc(v_key_141_);
lean_dec(v_v_132_);
v___x_144_ = lean_box(0);
v_isShared_145_ = v_isSharedCheck_152_;
goto v_resetjp_143_;
}
v_resetjp_143_:
{
uint8_t v___x_146_; 
v___x_146_ = l_Lean_instBEqMVarId_beq(v_x_121_, v_key_141_);
if (v___x_146_ == 0)
{
lean_object* v___x_147_; lean_object* v___x_148_; 
lean_del_object(v___x_144_);
v___x_147_ = l_Lean_PersistentHashMap_mkCollisionNode___redArg(v_key_141_, v_val_142_, v_x_121_, v_x_122_);
v___x_148_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_148_, 0, v___x_147_);
v___y_136_ = v___x_148_;
goto v___jp_135_;
}
else
{
lean_object* v___x_150_; 
lean_dec(v_val_142_);
lean_dec(v_key_141_);
if (v_isShared_145_ == 0)
{
lean_ctor_set(v___x_144_, 1, v_x_122_);
lean_ctor_set(v___x_144_, 0, v_x_121_);
v___x_150_ = v___x_144_;
goto v_reusejp_149_;
}
else
{
lean_object* v_reuseFailAlloc_151_; 
v_reuseFailAlloc_151_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_151_, 0, v_x_121_);
lean_ctor_set(v_reuseFailAlloc_151_, 1, v_x_122_);
v___x_150_ = v_reuseFailAlloc_151_;
goto v_reusejp_149_;
}
v_reusejp_149_:
{
v___y_136_ = v___x_150_;
goto v___jp_135_;
}
}
}
}
case 1:
{
lean_object* v_node_153_; lean_object* v___x_155_; uint8_t v_isShared_156_; uint8_t v_isSharedCheck_165_; 
v_node_153_ = lean_ctor_get(v_v_132_, 0);
v_isSharedCheck_165_ = !lean_is_exclusive(v_v_132_);
if (v_isSharedCheck_165_ == 0)
{
v___x_155_ = v_v_132_;
v_isShared_156_ = v_isSharedCheck_165_;
goto v_resetjp_154_;
}
else
{
lean_inc(v_node_153_);
lean_dec(v_v_132_);
v___x_155_ = lean_box(0);
v_isShared_156_ = v_isSharedCheck_165_;
goto v_resetjp_154_;
}
v_resetjp_154_:
{
size_t v___x_157_; size_t v___x_158_; size_t v___x_159_; size_t v___x_160_; lean_object* v___x_161_; lean_object* v___x_163_; 
v___x_157_ = ((size_t)5ULL);
v___x_158_ = lean_usize_shift_right(v_x_119_, v___x_157_);
v___x_159_ = ((size_t)1ULL);
v___x_160_ = lean_usize_add(v_x_120_, v___x_159_);
v___x_161_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg(v_node_153_, v___x_158_, v___x_160_, v_x_121_, v_x_122_);
if (v_isShared_156_ == 0)
{
lean_ctor_set(v___x_155_, 0, v___x_161_);
v___x_163_ = v___x_155_;
goto v_reusejp_162_;
}
else
{
lean_object* v_reuseFailAlloc_164_; 
v_reuseFailAlloc_164_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_164_, 0, v___x_161_);
v___x_163_ = v_reuseFailAlloc_164_;
goto v_reusejp_162_;
}
v_reusejp_162_:
{
v___y_136_ = v___x_163_;
goto v___jp_135_;
}
}
}
default: 
{
lean_object* v___x_166_; 
v___x_166_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_166_, 0, v_x_121_);
lean_ctor_set(v___x_166_, 1, v_x_122_);
v___y_136_ = v___x_166_;
goto v___jp_135_;
}
}
v___jp_135_:
{
lean_object* v___x_137_; lean_object* v___x_139_; 
v___x_137_ = lean_array_fset(v_xs_x27_134_, v_j_126_, v___y_136_);
lean_dec(v_j_126_);
if (v_isShared_131_ == 0)
{
lean_ctor_set(v___x_130_, 0, v___x_137_);
v___x_139_ = v___x_130_;
goto v_reusejp_138_;
}
else
{
lean_object* v_reuseFailAlloc_140_; 
v_reuseFailAlloc_140_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_140_, 0, v___x_137_);
v___x_139_ = v_reuseFailAlloc_140_;
goto v_reusejp_138_;
}
v_reusejp_138_:
{
return v___x_139_;
}
}
}
}
}
else
{
lean_object* v_ks_169_; lean_object* v_vs_170_; lean_object* v___x_172_; uint8_t v_isShared_173_; uint8_t v_isSharedCheck_190_; 
v_ks_169_ = lean_ctor_get(v_x_118_, 0);
v_vs_170_ = lean_ctor_get(v_x_118_, 1);
v_isSharedCheck_190_ = !lean_is_exclusive(v_x_118_);
if (v_isSharedCheck_190_ == 0)
{
v___x_172_ = v_x_118_;
v_isShared_173_ = v_isSharedCheck_190_;
goto v_resetjp_171_;
}
else
{
lean_inc(v_vs_170_);
lean_inc(v_ks_169_);
lean_dec(v_x_118_);
v___x_172_ = lean_box(0);
v_isShared_173_ = v_isSharedCheck_190_;
goto v_resetjp_171_;
}
v_resetjp_171_:
{
lean_object* v___x_175_; 
if (v_isShared_173_ == 0)
{
v___x_175_ = v___x_172_;
goto v_reusejp_174_;
}
else
{
lean_object* v_reuseFailAlloc_189_; 
v_reuseFailAlloc_189_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_189_, 0, v_ks_169_);
lean_ctor_set(v_reuseFailAlloc_189_, 1, v_vs_170_);
v___x_175_ = v_reuseFailAlloc_189_;
goto v_reusejp_174_;
}
v_reusejp_174_:
{
lean_object* v_newNode_176_; uint8_t v___y_178_; size_t v___x_184_; uint8_t v___x_185_; 
v_newNode_176_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6___redArg(v___x_175_, v_x_121_, v_x_122_);
v___x_184_ = ((size_t)7ULL);
v___x_185_ = lean_usize_dec_le(v___x_184_, v_x_120_);
if (v___x_185_ == 0)
{
lean_object* v___x_186_; lean_object* v___x_187_; uint8_t v___x_188_; 
v___x_186_ = l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(v_newNode_176_);
v___x_187_ = lean_unsigned_to_nat(4u);
v___x_188_ = lean_nat_dec_lt(v___x_186_, v___x_187_);
lean_dec(v___x_186_);
v___y_178_ = v___x_188_;
goto v___jp_177_;
}
else
{
v___y_178_ = v___x_185_;
goto v___jp_177_;
}
v___jp_177_:
{
if (v___y_178_ == 0)
{
lean_object* v_ks_179_; lean_object* v_vs_180_; lean_object* v___x_181_; lean_object* v___x_182_; lean_object* v___x_183_; 
v_ks_179_ = lean_ctor_get(v_newNode_176_, 0);
lean_inc_ref(v_ks_179_);
v_vs_180_ = lean_ctor_get(v_newNode_176_, 1);
lean_inc_ref(v_vs_180_);
lean_dec_ref(v_newNode_176_);
v___x_181_ = lean_unsigned_to_nat(0u);
v___x_182_ = lean_obj_once(&l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg___closed__0, &l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg___closed__0_once, _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg___closed__0);
v___x_183_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7___redArg(v_x_120_, v_ks_179_, v_vs_180_, v___x_181_, v___x_182_);
lean_dec_ref(v_vs_180_);
lean_dec_ref(v_ks_179_);
return v___x_183_;
}
else
{
return v_newNode_176_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7___redArg(size_t v_depth_191_, lean_object* v_keys_192_, lean_object* v_vals_193_, lean_object* v_i_194_, lean_object* v_entries_195_){
_start:
{
lean_object* v___x_196_; uint8_t v___x_197_; 
v___x_196_ = lean_array_get_size(v_keys_192_);
v___x_197_ = lean_nat_dec_lt(v_i_194_, v___x_196_);
if (v___x_197_ == 0)
{
lean_dec(v_i_194_);
return v_entries_195_;
}
else
{
lean_object* v_k_198_; lean_object* v_v_199_; uint64_t v___x_200_; size_t v_h_201_; size_t v___x_202_; lean_object* v___x_203_; size_t v___x_204_; size_t v___x_205_; size_t v___x_206_; size_t v_h_207_; lean_object* v___x_208_; lean_object* v___x_209_; 
v_k_198_ = lean_array_fget_borrowed(v_keys_192_, v_i_194_);
v_v_199_ = lean_array_fget_borrowed(v_vals_193_, v_i_194_);
v___x_200_ = l_Lean_instHashableMVarId_hash(v_k_198_);
v_h_201_ = lean_uint64_to_usize(v___x_200_);
v___x_202_ = ((size_t)5ULL);
v___x_203_ = lean_unsigned_to_nat(1u);
v___x_204_ = ((size_t)1ULL);
v___x_205_ = lean_usize_sub(v_depth_191_, v___x_204_);
v___x_206_ = lean_usize_mul(v___x_202_, v___x_205_);
v_h_207_ = lean_usize_shift_right(v_h_201_, v___x_206_);
v___x_208_ = lean_nat_add(v_i_194_, v___x_203_);
lean_dec(v_i_194_);
lean_inc(v_v_199_);
lean_inc(v_k_198_);
v___x_209_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg(v_entries_195_, v_h_207_, v_depth_191_, v_k_198_, v_v_199_);
v_i_194_ = v___x_208_;
v_entries_195_ = v___x_209_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7___redArg___boxed(lean_object* v_depth_211_, lean_object* v_keys_212_, lean_object* v_vals_213_, lean_object* v_i_214_, lean_object* v_entries_215_){
_start:
{
size_t v_depth_boxed_216_; lean_object* v_res_217_; 
v_depth_boxed_216_ = lean_unbox_usize(v_depth_211_);
lean_dec(v_depth_211_);
v_res_217_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7___redArg(v_depth_boxed_216_, v_keys_212_, v_vals_213_, v_i_214_, v_entries_215_);
lean_dec_ref(v_vals_213_);
lean_dec_ref(v_keys_212_);
return v_res_217_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg___boxed(lean_object* v_x_218_, lean_object* v_x_219_, lean_object* v_x_220_, lean_object* v_x_221_, lean_object* v_x_222_){
_start:
{
size_t v_x_24514__boxed_223_; size_t v_x_24515__boxed_224_; lean_object* v_res_225_; 
v_x_24514__boxed_223_ = lean_unbox_usize(v_x_219_);
lean_dec(v_x_219_);
v_x_24515__boxed_224_ = lean_unbox_usize(v_x_220_);
lean_dec(v_x_220_);
v_res_225_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg(v_x_218_, v_x_24514__boxed_223_, v_x_24515__boxed_224_, v_x_221_, v_x_222_);
return v_res_225_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2___redArg(lean_object* v_x_226_, lean_object* v_x_227_, lean_object* v_x_228_){
_start:
{
uint64_t v___x_229_; size_t v___x_230_; size_t v___x_231_; lean_object* v___x_232_; 
v___x_229_ = l_Lean_instHashableMVarId_hash(v_x_227_);
v___x_230_ = lean_uint64_to_usize(v___x_229_);
v___x_231_ = ((size_t)1ULL);
v___x_232_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg(v_x_226_, v___x_230_, v___x_231_, v_x_227_, v_x_228_);
return v___x_232_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1___redArg(lean_object* v_mvarId_233_, lean_object* v_val_234_, lean_object* v___y_235_){
_start:
{
lean_object* v___x_237_; lean_object* v_mctx_238_; lean_object* v_cache_239_; lean_object* v_zetaDeltaFVarIds_240_; lean_object* v_postponed_241_; lean_object* v_diag_242_; lean_object* v___x_244_; uint8_t v_isShared_245_; uint8_t v_isSharedCheck_270_; 
v___x_237_ = lean_st_ref_take(v___y_235_);
v_mctx_238_ = lean_ctor_get(v___x_237_, 0);
v_cache_239_ = lean_ctor_get(v___x_237_, 1);
v_zetaDeltaFVarIds_240_ = lean_ctor_get(v___x_237_, 2);
v_postponed_241_ = lean_ctor_get(v___x_237_, 3);
v_diag_242_ = lean_ctor_get(v___x_237_, 4);
v_isSharedCheck_270_ = !lean_is_exclusive(v___x_237_);
if (v_isSharedCheck_270_ == 0)
{
v___x_244_ = v___x_237_;
v_isShared_245_ = v_isSharedCheck_270_;
goto v_resetjp_243_;
}
else
{
lean_inc(v_diag_242_);
lean_inc(v_postponed_241_);
lean_inc(v_zetaDeltaFVarIds_240_);
lean_inc(v_cache_239_);
lean_inc(v_mctx_238_);
lean_dec(v___x_237_);
v___x_244_ = lean_box(0);
v_isShared_245_ = v_isSharedCheck_270_;
goto v_resetjp_243_;
}
v_resetjp_243_:
{
lean_object* v_depth_246_; lean_object* v_levelAssignDepth_247_; lean_object* v_lmvarCounter_248_; lean_object* v_mvarCounter_249_; lean_object* v_lDecls_250_; lean_object* v_decls_251_; lean_object* v_userNames_252_; lean_object* v_lAssignment_253_; lean_object* v_eAssignment_254_; lean_object* v_dAssignment_255_; lean_object* v___x_257_; uint8_t v_isShared_258_; uint8_t v_isSharedCheck_269_; 
v_depth_246_ = lean_ctor_get(v_mctx_238_, 0);
v_levelAssignDepth_247_ = lean_ctor_get(v_mctx_238_, 1);
v_lmvarCounter_248_ = lean_ctor_get(v_mctx_238_, 2);
v_mvarCounter_249_ = lean_ctor_get(v_mctx_238_, 3);
v_lDecls_250_ = lean_ctor_get(v_mctx_238_, 4);
v_decls_251_ = lean_ctor_get(v_mctx_238_, 5);
v_userNames_252_ = lean_ctor_get(v_mctx_238_, 6);
v_lAssignment_253_ = lean_ctor_get(v_mctx_238_, 7);
v_eAssignment_254_ = lean_ctor_get(v_mctx_238_, 8);
v_dAssignment_255_ = lean_ctor_get(v_mctx_238_, 9);
v_isSharedCheck_269_ = !lean_is_exclusive(v_mctx_238_);
if (v_isSharedCheck_269_ == 0)
{
v___x_257_ = v_mctx_238_;
v_isShared_258_ = v_isSharedCheck_269_;
goto v_resetjp_256_;
}
else
{
lean_inc(v_dAssignment_255_);
lean_inc(v_eAssignment_254_);
lean_inc(v_lAssignment_253_);
lean_inc(v_userNames_252_);
lean_inc(v_decls_251_);
lean_inc(v_lDecls_250_);
lean_inc(v_mvarCounter_249_);
lean_inc(v_lmvarCounter_248_);
lean_inc(v_levelAssignDepth_247_);
lean_inc(v_depth_246_);
lean_dec(v_mctx_238_);
v___x_257_ = lean_box(0);
v_isShared_258_ = v_isSharedCheck_269_;
goto v_resetjp_256_;
}
v_resetjp_256_:
{
lean_object* v___x_259_; lean_object* v___x_261_; 
v___x_259_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2___redArg(v_eAssignment_254_, v_mvarId_233_, v_val_234_);
if (v_isShared_258_ == 0)
{
lean_ctor_set(v___x_257_, 8, v___x_259_);
v___x_261_ = v___x_257_;
goto v_reusejp_260_;
}
else
{
lean_object* v_reuseFailAlloc_268_; 
v_reuseFailAlloc_268_ = lean_alloc_ctor(0, 10, 0);
lean_ctor_set(v_reuseFailAlloc_268_, 0, v_depth_246_);
lean_ctor_set(v_reuseFailAlloc_268_, 1, v_levelAssignDepth_247_);
lean_ctor_set(v_reuseFailAlloc_268_, 2, v_lmvarCounter_248_);
lean_ctor_set(v_reuseFailAlloc_268_, 3, v_mvarCounter_249_);
lean_ctor_set(v_reuseFailAlloc_268_, 4, v_lDecls_250_);
lean_ctor_set(v_reuseFailAlloc_268_, 5, v_decls_251_);
lean_ctor_set(v_reuseFailAlloc_268_, 6, v_userNames_252_);
lean_ctor_set(v_reuseFailAlloc_268_, 7, v_lAssignment_253_);
lean_ctor_set(v_reuseFailAlloc_268_, 8, v___x_259_);
lean_ctor_set(v_reuseFailAlloc_268_, 9, v_dAssignment_255_);
v___x_261_ = v_reuseFailAlloc_268_;
goto v_reusejp_260_;
}
v_reusejp_260_:
{
lean_object* v___x_263_; 
if (v_isShared_245_ == 0)
{
lean_ctor_set(v___x_244_, 0, v___x_261_);
v___x_263_ = v___x_244_;
goto v_reusejp_262_;
}
else
{
lean_object* v_reuseFailAlloc_267_; 
v_reuseFailAlloc_267_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_267_, 0, v___x_261_);
lean_ctor_set(v_reuseFailAlloc_267_, 1, v_cache_239_);
lean_ctor_set(v_reuseFailAlloc_267_, 2, v_zetaDeltaFVarIds_240_);
lean_ctor_set(v_reuseFailAlloc_267_, 3, v_postponed_241_);
lean_ctor_set(v_reuseFailAlloc_267_, 4, v_diag_242_);
v___x_263_ = v_reuseFailAlloc_267_;
goto v_reusejp_262_;
}
v_reusejp_262_:
{
lean_object* v___x_264_; lean_object* v___x_265_; lean_object* v___x_266_; 
v___x_264_ = lean_st_ref_set(v___y_235_, v___x_263_);
v___x_265_ = lean_box(0);
v___x_266_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_266_, 0, v___x_265_);
return v___x_266_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1___redArg___boxed(lean_object* v_mvarId_271_, lean_object* v_val_272_, lean_object* v___y_273_, lean_object* v___y_274_){
_start:
{
lean_object* v_res_275_; 
v_res_275_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1___redArg(v_mvarId_271_, v_val_272_, v___y_273_);
lean_dec(v___y_273_);
return v_res_275_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__4(lean_object* v___f_276_, lean_object* v_a_277_, lean_object* v_____r_278_, lean_object* v___y_279_, lean_object* v___y_280_, lean_object* v___y_281_, lean_object* v___y_282_, lean_object* v___y_283_, lean_object* v___y_284_, lean_object* v___y_285_, lean_object* v___y_286_){
_start:
{
lean_object* v___x_288_; uint8_t v_debug_289_; 
v___x_288_ = lean_st_ref_get(v___y_282_);
v_debug_289_ = lean_ctor_get_uint8(v___x_288_, sizeof(void*)*10);
lean_dec(v___x_288_);
if (v_debug_289_ == 0)
{
lean_object* v___x_290_; lean_object* v___x_291_; 
lean_dec_ref(v_a_277_);
v___x_290_ = lean_box(0);
lean_inc(v___y_286_);
lean_inc_ref(v___y_285_);
lean_inc(v___y_284_);
lean_inc_ref(v___y_283_);
lean_inc(v___y_282_);
lean_inc_ref(v___y_281_);
lean_inc(v___y_280_);
lean_inc_ref(v___y_279_);
v___x_291_ = lean_apply_10(v___f_276_, v___x_290_, v___y_279_, v___y_280_, v___y_281_, v___y_282_, v___y_283_, v___y_284_, v___y_285_, v___y_286_, lean_box(0));
return v___x_291_;
}
else
{
lean_object* v___x_292_; 
v___x_292_ = l_Lean_Meta_Sym_Internal_Sym_assertShared(v_a_277_, v___y_281_, v___y_282_, v___y_283_, v___y_284_, v___y_285_, v___y_286_);
if (lean_obj_tag(v___x_292_) == 0)
{
lean_object* v_a_293_; lean_object* v___x_294_; 
v_a_293_ = lean_ctor_get(v___x_292_, 0);
lean_inc(v_a_293_);
lean_dec_ref_known(v___x_292_, 1);
lean_inc(v___y_286_);
lean_inc_ref(v___y_285_);
lean_inc(v___y_284_);
lean_inc_ref(v___y_283_);
lean_inc(v___y_282_);
lean_inc_ref(v___y_281_);
lean_inc(v___y_280_);
lean_inc_ref(v___y_279_);
v___x_294_ = lean_apply_10(v___f_276_, v_a_293_, v___y_279_, v___y_280_, v___y_281_, v___y_282_, v___y_283_, v___y_284_, v___y_285_, v___y_286_, lean_box(0));
return v___x_294_;
}
else
{
lean_object* v_a_295_; lean_object* v___x_297_; uint8_t v_isShared_298_; uint8_t v_isSharedCheck_302_; 
lean_dec_ref(v___f_276_);
v_a_295_ = lean_ctor_get(v___x_292_, 0);
v_isSharedCheck_302_ = !lean_is_exclusive(v___x_292_);
if (v_isSharedCheck_302_ == 0)
{
v___x_297_ = v___x_292_;
v_isShared_298_ = v_isSharedCheck_302_;
goto v_resetjp_296_;
}
else
{
lean_inc(v_a_295_);
lean_dec(v___x_292_);
v___x_297_ = lean_box(0);
v_isShared_298_ = v_isSharedCheck_302_;
goto v_resetjp_296_;
}
v_resetjp_296_:
{
lean_object* v___x_300_; 
if (v_isShared_298_ == 0)
{
v___x_300_ = v___x_297_;
goto v_reusejp_299_;
}
else
{
lean_object* v_reuseFailAlloc_301_; 
v_reuseFailAlloc_301_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_301_, 0, v_a_295_);
v___x_300_ = v_reuseFailAlloc_301_;
goto v_reusejp_299_;
}
v_reusejp_299_:
{
return v___x_300_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__4___boxed(lean_object* v___f_303_, lean_object* v_a_304_, lean_object* v_____r_305_, lean_object* v___y_306_, lean_object* v___y_307_, lean_object* v___y_308_, lean_object* v___y_309_, lean_object* v___y_310_, lean_object* v___y_311_, lean_object* v___y_312_, lean_object* v___y_313_, lean_object* v___y_314_){
_start:
{
lean_object* v_res_315_; 
v_res_315_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__4(v___f_303_, v_a_304_, v_____r_305_, v___y_306_, v___y_307_, v___y_308_, v___y_309_, v___y_310_, v___y_311_, v___y_312_, v___y_313_);
lean_dec(v___y_313_);
lean_dec_ref(v___y_312_);
lean_dec(v___y_311_);
lean_dec_ref(v___y_310_);
lean_dec(v___y_309_);
lean_dec_ref(v___y_308_);
lean_dec(v___y_307_);
lean_dec_ref(v___y_306_);
return v_res_315_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__0(lean_object* v___y_316_, lean_object* v___y_317_, lean_object* v___y_318_, lean_object* v___y_319_, lean_object* v___y_320_, lean_object* v___y_321_, lean_object* v___y_322_, lean_object* v___y_323_, lean_object* v___y_324_, lean_object* v___y_325_){
_start:
{
lean_object* v___x_327_; 
lean_inc_ref(v___y_316_);
v___x_327_ = l_Lean_Meta_Sym_DSimp_zeta___redArg(v___y_316_, v___y_320_, v___y_321_, v___y_322_, v___y_323_, v___y_324_, v___y_325_);
if (lean_obj_tag(v___x_327_) == 0)
{
lean_object* v_a_328_; 
v_a_328_ = lean_ctor_get(v___x_327_, 0);
lean_inc(v_a_328_);
if (lean_obj_tag(v_a_328_) == 0)
{
uint8_t v_done_329_; 
v_done_329_ = lean_ctor_get_uint8(v_a_328_, 0);
lean_dec_ref_known(v_a_328_, 0);
if (v_done_329_ == 0)
{
lean_object* v___x_330_; 
lean_dec_ref_known(v___x_327_, 1);
v___x_330_ = l_Lean_Meta_Sym_DSimp_zetaDeltaAll___redArg(v___y_316_, v___y_322_, v___y_324_, v___y_325_);
return v___x_330_;
}
else
{
lean_dec_ref(v___y_316_);
return v___x_327_;
}
}
else
{
uint8_t v_done_331_; 
lean_dec_ref(v___y_316_);
v_done_331_ = lean_ctor_get_uint8(v_a_328_, sizeof(void*)*1);
if (v_done_331_ == 0)
{
lean_object* v_e_x27_332_; lean_object* v___x_334_; uint8_t v_isShared_335_; uint8_t v_isSharedCheck_350_; 
lean_dec_ref_known(v___x_327_, 1);
v_e_x27_332_ = lean_ctor_get(v_a_328_, 0);
v_isSharedCheck_350_ = !lean_is_exclusive(v_a_328_);
if (v_isSharedCheck_350_ == 0)
{
v___x_334_ = v_a_328_;
v_isShared_335_ = v_isSharedCheck_350_;
goto v_resetjp_333_;
}
else
{
lean_inc(v_e_x27_332_);
lean_dec(v_a_328_);
v___x_334_ = lean_box(0);
v_isShared_335_ = v_isSharedCheck_350_;
goto v_resetjp_333_;
}
v_resetjp_333_:
{
lean_object* v___x_336_; 
lean_inc_ref(v_e_x27_332_);
v___x_336_ = l_Lean_Meta_Sym_DSimp_zetaDeltaAll___redArg(v_e_x27_332_, v___y_322_, v___y_324_, v___y_325_);
if (lean_obj_tag(v___x_336_) == 0)
{
lean_object* v_a_337_; 
v_a_337_ = lean_ctor_get(v___x_336_, 0);
lean_inc(v_a_337_);
if (lean_obj_tag(v_a_337_) == 0)
{
lean_object* v___x_339_; uint8_t v_isShared_340_; uint8_t v_isSharedCheck_348_; 
v_isSharedCheck_348_ = !lean_is_exclusive(v___x_336_);
if (v_isSharedCheck_348_ == 0)
{
lean_object* v_unused_349_; 
v_unused_349_ = lean_ctor_get(v___x_336_, 0);
lean_dec(v_unused_349_);
v___x_339_ = v___x_336_;
v_isShared_340_ = v_isSharedCheck_348_;
goto v_resetjp_338_;
}
else
{
lean_dec(v___x_336_);
v___x_339_ = lean_box(0);
v_isShared_340_ = v_isSharedCheck_348_;
goto v_resetjp_338_;
}
v_resetjp_338_:
{
uint8_t v_done_341_; lean_object* v___x_343_; 
v_done_341_ = lean_ctor_get_uint8(v_a_337_, 0);
lean_dec_ref_known(v_a_337_, 0);
if (v_isShared_335_ == 0)
{
v___x_343_ = v___x_334_;
goto v_reusejp_342_;
}
else
{
lean_object* v_reuseFailAlloc_347_; 
v_reuseFailAlloc_347_ = lean_alloc_ctor(1, 1, 1);
lean_ctor_set(v_reuseFailAlloc_347_, 0, v_e_x27_332_);
v___x_343_ = v_reuseFailAlloc_347_;
goto v_reusejp_342_;
}
v_reusejp_342_:
{
lean_object* v___x_345_; 
lean_ctor_set_uint8(v___x_343_, sizeof(void*)*1, v_done_341_);
if (v_isShared_340_ == 0)
{
lean_ctor_set(v___x_339_, 0, v___x_343_);
v___x_345_ = v___x_339_;
goto v_reusejp_344_;
}
else
{
lean_object* v_reuseFailAlloc_346_; 
v_reuseFailAlloc_346_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_346_, 0, v___x_343_);
v___x_345_ = v_reuseFailAlloc_346_;
goto v_reusejp_344_;
}
v_reusejp_344_:
{
return v___x_345_;
}
}
}
}
else
{
lean_dec_ref_known(v_a_337_, 1);
lean_del_object(v___x_334_);
lean_dec_ref(v_e_x27_332_);
return v___x_336_;
}
}
else
{
lean_del_object(v___x_334_);
lean_dec_ref(v_e_x27_332_);
return v___x_336_;
}
}
}
else
{
lean_dec_ref_known(v_a_328_, 1);
return v___x_327_;
}
}
}
else
{
lean_dec_ref(v___y_316_);
return v___x_327_;
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__0___boxed(lean_object* v___y_351_, lean_object* v___y_352_, lean_object* v___y_353_, lean_object* v___y_354_, lean_object* v___y_355_, lean_object* v___y_356_, lean_object* v___y_357_, lean_object* v___y_358_, lean_object* v___y_359_, lean_object* v___y_360_, lean_object* v___y_361_){
_start:
{
lean_object* v_res_362_; 
v_res_362_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__0(v___y_351_, v___y_352_, v___y_353_, v___y_354_, v___y_355_, v___y_356_, v___y_357_, v___y_358_, v___y_359_, v___y_360_);
lean_dec(v___y_360_);
lean_dec_ref(v___y_359_);
lean_dec(v___y_358_);
lean_dec_ref(v___y_357_);
lean_dec(v___y_356_);
lean_dec_ref(v___y_355_);
lean_dec(v___y_354_);
lean_dec(v___y_353_);
lean_dec(v___y_352_);
return v_res_362_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__3(uint8_t v___x_363_, lean_object* v___f_364_, lean_object* v_____r_365_, lean_object* v___y_366_, lean_object* v___y_367_, lean_object* v___y_368_, lean_object* v___y_369_, lean_object* v___y_370_, lean_object* v___y_371_, lean_object* v___y_372_, lean_object* v___y_373_){
_start:
{
lean_object* v___x_375_; lean_object* v_rewriteCache_376_; lean_object* v_acNfCache_377_; lean_object* v_typeAnalysis_378_; lean_object* v_goal_379_; lean_object* v_hypotheses_380_; lean_object* v___x_382_; uint8_t v_isShared_383_; uint8_t v_isSharedCheck_390_; 
v___x_375_ = lean_st_ref_take(v___y_367_);
v_rewriteCache_376_ = lean_ctor_get(v___x_375_, 0);
v_acNfCache_377_ = lean_ctor_get(v___x_375_, 1);
v_typeAnalysis_378_ = lean_ctor_get(v___x_375_, 2);
v_goal_379_ = lean_ctor_get(v___x_375_, 3);
v_hypotheses_380_ = lean_ctor_get(v___x_375_, 4);
v_isSharedCheck_390_ = !lean_is_exclusive(v___x_375_);
if (v_isSharedCheck_390_ == 0)
{
v___x_382_ = v___x_375_;
v_isShared_383_ = v_isSharedCheck_390_;
goto v_resetjp_381_;
}
else
{
lean_inc(v_hypotheses_380_);
lean_inc(v_goal_379_);
lean_inc(v_typeAnalysis_378_);
lean_inc(v_acNfCache_377_);
lean_inc(v_rewriteCache_376_);
lean_dec(v___x_375_);
v___x_382_ = lean_box(0);
v_isShared_383_ = v_isSharedCheck_390_;
goto v_resetjp_381_;
}
v_resetjp_381_:
{
lean_object* v___x_385_; 
if (v_isShared_383_ == 0)
{
v___x_385_ = v___x_382_;
goto v_reusejp_384_;
}
else
{
lean_object* v_reuseFailAlloc_389_; 
v_reuseFailAlloc_389_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_389_, 0, v_rewriteCache_376_);
lean_ctor_set(v_reuseFailAlloc_389_, 1, v_acNfCache_377_);
lean_ctor_set(v_reuseFailAlloc_389_, 2, v_typeAnalysis_378_);
lean_ctor_set(v_reuseFailAlloc_389_, 3, v_goal_379_);
lean_ctor_set(v_reuseFailAlloc_389_, 4, v_hypotheses_380_);
v___x_385_ = v_reuseFailAlloc_389_;
goto v_reusejp_384_;
}
v_reusejp_384_:
{
lean_object* v___x_386_; lean_object* v___x_387_; lean_object* v___x_388_; 
lean_ctor_set_uint8(v___x_385_, sizeof(void*)*5, v___x_363_);
v___x_386_ = lean_st_ref_set(v___y_367_, v___x_385_);
v___x_387_ = lean_box(0);
lean_inc(v___y_373_);
lean_inc_ref(v___y_372_);
lean_inc(v___y_371_);
lean_inc_ref(v___y_370_);
lean_inc(v___y_369_);
lean_inc_ref(v___y_368_);
lean_inc(v___y_367_);
lean_inc_ref(v___y_366_);
v___x_388_ = lean_apply_10(v___f_364_, v___x_387_, v___y_366_, v___y_367_, v___y_368_, v___y_369_, v___y_370_, v___y_371_, v___y_372_, v___y_373_, lean_box(0));
return v___x_388_;
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__3___boxed(lean_object* v___x_391_, lean_object* v___f_392_, lean_object* v_____r_393_, lean_object* v___y_394_, lean_object* v___y_395_, lean_object* v___y_396_, lean_object* v___y_397_, lean_object* v___y_398_, lean_object* v___y_399_, lean_object* v___y_400_, lean_object* v___y_401_, lean_object* v___y_402_){
_start:
{
uint8_t v___x_24876__boxed_403_; lean_object* v_res_404_; 
v___x_24876__boxed_403_ = lean_unbox(v___x_391_);
v_res_404_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__3(v___x_24876__boxed_403_, v___f_392_, v_____r_393_, v___y_394_, v___y_395_, v___y_396_, v___y_397_, v___y_398_, v___y_399_, v___y_400_, v___y_401_);
lean_dec(v___y_401_);
lean_dec_ref(v___y_400_);
lean_dec(v___y_399_);
lean_dec_ref(v___y_398_);
lean_dec(v___y_397_);
lean_dec_ref(v___y_396_);
lean_dec(v___y_395_);
lean_dec_ref(v___y_394_);
return v_res_404_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1(lean_object* v_x_407_, lean_object* v___y_408_, lean_object* v___y_409_, lean_object* v___y_410_, lean_object* v___y_411_, lean_object* v___y_412_, lean_object* v___y_413_, lean_object* v___y_414_, lean_object* v___y_415_, lean_object* v___y_416_){
_start:
{
lean_object* v___x_418_; lean_object* v___x_419_; 
v___x_418_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1___closed__0));
v___x_419_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_419_, 0, v___x_418_);
return v___x_419_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1___boxed(lean_object* v_x_420_, lean_object* v___y_421_, lean_object* v___y_422_, lean_object* v___y_423_, lean_object* v___y_424_, lean_object* v___y_425_, lean_object* v___y_426_, lean_object* v___y_427_, lean_object* v___y_428_, lean_object* v___y_429_, lean_object* v___y_430_){
_start:
{
lean_object* v_res_431_; 
v_res_431_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__1(v_x_420_, v___y_421_, v___y_422_, v___y_423_, v___y_424_, v___y_425_, v___y_426_, v___y_427_, v___y_428_, v___y_429_);
lean_dec(v___y_429_);
lean_dec_ref(v___y_428_);
lean_dec(v___y_427_);
lean_dec_ref(v___y_426_);
lean_dec(v___y_425_);
lean_dec_ref(v___y_424_);
lean_dec(v___y_423_);
lean_dec(v___y_422_);
lean_dec(v___y_421_);
lean_dec_ref(v_x_420_);
return v_res_431_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0_spec__0(lean_object* v_msgData_432_, lean_object* v___y_433_, lean_object* v___y_434_, lean_object* v___y_435_, lean_object* v___y_436_){
_start:
{
lean_object* v___x_438_; lean_object* v_env_439_; lean_object* v___x_440_; lean_object* v_mctx_441_; lean_object* v_lctx_442_; lean_object* v_options_443_; lean_object* v___x_444_; lean_object* v___x_445_; lean_object* v___x_446_; 
v___x_438_ = lean_st_ref_get(v___y_436_);
v_env_439_ = lean_ctor_get(v___x_438_, 0);
lean_inc_ref(v_env_439_);
lean_dec(v___x_438_);
v___x_440_ = lean_st_ref_get(v___y_434_);
v_mctx_441_ = lean_ctor_get(v___x_440_, 0);
lean_inc_ref(v_mctx_441_);
lean_dec(v___x_440_);
v_lctx_442_ = lean_ctor_get(v___y_433_, 2);
v_options_443_ = lean_ctor_get(v___y_435_, 2);
lean_inc_ref(v_options_443_);
lean_inc_ref(v_lctx_442_);
v___x_444_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_444_, 0, v_env_439_);
lean_ctor_set(v___x_444_, 1, v_mctx_441_);
lean_ctor_set(v___x_444_, 2, v_lctx_442_);
lean_ctor_set(v___x_444_, 3, v_options_443_);
v___x_445_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v___x_445_, 0, v___x_444_);
lean_ctor_set(v___x_445_, 1, v_msgData_432_);
v___x_446_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_446_, 0, v___x_445_);
return v___x_446_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0_spec__0___boxed(lean_object* v_msgData_447_, lean_object* v___y_448_, lean_object* v___y_449_, lean_object* v___y_450_, lean_object* v___y_451_, lean_object* v___y_452_){
_start:
{
lean_object* v_res_453_; 
v_res_453_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0_spec__0(v_msgData_447_, v___y_448_, v___y_449_, v___y_450_, v___y_451_);
lean_dec(v___y_451_);
lean_dec_ref(v___y_450_);
lean_dec(v___y_449_);
lean_dec_ref(v___y_448_);
return v_res_453_;
}
}
static double _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__0(void){
_start:
{
lean_object* v___x_454_; double v___x_455_; 
v___x_454_ = lean_unsigned_to_nat(0u);
v___x_455_ = lean_float_of_nat(v___x_454_);
return v___x_455_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg(lean_object* v_cls_459_, lean_object* v_msg_460_, lean_object* v___y_461_, lean_object* v___y_462_, lean_object* v___y_463_, lean_object* v___y_464_){
_start:
{
lean_object* v_ref_466_; lean_object* v___x_467_; lean_object* v_a_468_; lean_object* v___x_470_; uint8_t v_isShared_471_; uint8_t v_isSharedCheck_512_; 
v_ref_466_ = lean_ctor_get(v___y_463_, 5);
v___x_467_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0_spec__0(v_msg_460_, v___y_461_, v___y_462_, v___y_463_, v___y_464_);
v_a_468_ = lean_ctor_get(v___x_467_, 0);
v_isSharedCheck_512_ = !lean_is_exclusive(v___x_467_);
if (v_isSharedCheck_512_ == 0)
{
v___x_470_ = v___x_467_;
v_isShared_471_ = v_isSharedCheck_512_;
goto v_resetjp_469_;
}
else
{
lean_inc(v_a_468_);
lean_dec(v___x_467_);
v___x_470_ = lean_box(0);
v_isShared_471_ = v_isSharedCheck_512_;
goto v_resetjp_469_;
}
v_resetjp_469_:
{
lean_object* v___x_472_; lean_object* v_traceState_473_; lean_object* v_env_474_; lean_object* v_nextMacroScope_475_; lean_object* v_ngen_476_; lean_object* v_auxDeclNGen_477_; lean_object* v_cache_478_; lean_object* v_messages_479_; lean_object* v_infoState_480_; lean_object* v_snapshotTasks_481_; lean_object* v___x_483_; uint8_t v_isShared_484_; uint8_t v_isSharedCheck_511_; 
v___x_472_ = lean_st_ref_take(v___y_464_);
v_traceState_473_ = lean_ctor_get(v___x_472_, 4);
v_env_474_ = lean_ctor_get(v___x_472_, 0);
v_nextMacroScope_475_ = lean_ctor_get(v___x_472_, 1);
v_ngen_476_ = lean_ctor_get(v___x_472_, 2);
v_auxDeclNGen_477_ = lean_ctor_get(v___x_472_, 3);
v_cache_478_ = lean_ctor_get(v___x_472_, 5);
v_messages_479_ = lean_ctor_get(v___x_472_, 6);
v_infoState_480_ = lean_ctor_get(v___x_472_, 7);
v_snapshotTasks_481_ = lean_ctor_get(v___x_472_, 8);
v_isSharedCheck_511_ = !lean_is_exclusive(v___x_472_);
if (v_isSharedCheck_511_ == 0)
{
v___x_483_ = v___x_472_;
v_isShared_484_ = v_isSharedCheck_511_;
goto v_resetjp_482_;
}
else
{
lean_inc(v_snapshotTasks_481_);
lean_inc(v_infoState_480_);
lean_inc(v_messages_479_);
lean_inc(v_cache_478_);
lean_inc(v_traceState_473_);
lean_inc(v_auxDeclNGen_477_);
lean_inc(v_ngen_476_);
lean_inc(v_nextMacroScope_475_);
lean_inc(v_env_474_);
lean_dec(v___x_472_);
v___x_483_ = lean_box(0);
v_isShared_484_ = v_isSharedCheck_511_;
goto v_resetjp_482_;
}
v_resetjp_482_:
{
uint64_t v_tid_485_; lean_object* v_traces_486_; lean_object* v___x_488_; uint8_t v_isShared_489_; uint8_t v_isSharedCheck_510_; 
v_tid_485_ = lean_ctor_get_uint64(v_traceState_473_, sizeof(void*)*1);
v_traces_486_ = lean_ctor_get(v_traceState_473_, 0);
v_isSharedCheck_510_ = !lean_is_exclusive(v_traceState_473_);
if (v_isSharedCheck_510_ == 0)
{
v___x_488_ = v_traceState_473_;
v_isShared_489_ = v_isSharedCheck_510_;
goto v_resetjp_487_;
}
else
{
lean_inc(v_traces_486_);
lean_dec(v_traceState_473_);
v___x_488_ = lean_box(0);
v_isShared_489_ = v_isSharedCheck_510_;
goto v_resetjp_487_;
}
v_resetjp_487_:
{
lean_object* v___x_490_; double v___x_491_; uint8_t v___x_492_; lean_object* v___x_493_; lean_object* v___x_494_; lean_object* v___x_495_; lean_object* v___x_496_; lean_object* v___x_497_; lean_object* v___x_498_; lean_object* v___x_500_; 
v___x_490_ = lean_box(0);
v___x_491_ = lean_float_once(&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__0, &l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__0_once, _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__0);
v___x_492_ = 0;
v___x_493_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__1));
v___x_494_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v___x_494_, 0, v_cls_459_);
lean_ctor_set(v___x_494_, 1, v___x_490_);
lean_ctor_set(v___x_494_, 2, v___x_493_);
lean_ctor_set_float(v___x_494_, sizeof(void*)*3, v___x_491_);
lean_ctor_set_float(v___x_494_, sizeof(void*)*3 + 8, v___x_491_);
lean_ctor_set_uint8(v___x_494_, sizeof(void*)*3 + 16, v___x_492_);
v___x_495_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___closed__2));
v___x_496_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v___x_496_, 0, v___x_494_);
lean_ctor_set(v___x_496_, 1, v_a_468_);
lean_ctor_set(v___x_496_, 2, v___x_495_);
lean_inc(v_ref_466_);
v___x_497_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_497_, 0, v_ref_466_);
lean_ctor_set(v___x_497_, 1, v___x_496_);
v___x_498_ = l_Lean_PersistentArray_push___redArg(v_traces_486_, v___x_497_);
if (v_isShared_489_ == 0)
{
lean_ctor_set(v___x_488_, 0, v___x_498_);
v___x_500_ = v___x_488_;
goto v_reusejp_499_;
}
else
{
lean_object* v_reuseFailAlloc_509_; 
v_reuseFailAlloc_509_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_509_, 0, v___x_498_);
lean_ctor_set_uint64(v_reuseFailAlloc_509_, sizeof(void*)*1, v_tid_485_);
v___x_500_ = v_reuseFailAlloc_509_;
goto v_reusejp_499_;
}
v_reusejp_499_:
{
lean_object* v___x_502_; 
if (v_isShared_484_ == 0)
{
lean_ctor_set(v___x_483_, 4, v___x_500_);
v___x_502_ = v___x_483_;
goto v_reusejp_501_;
}
else
{
lean_object* v_reuseFailAlloc_508_; 
v_reuseFailAlloc_508_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_508_, 0, v_env_474_);
lean_ctor_set(v_reuseFailAlloc_508_, 1, v_nextMacroScope_475_);
lean_ctor_set(v_reuseFailAlloc_508_, 2, v_ngen_476_);
lean_ctor_set(v_reuseFailAlloc_508_, 3, v_auxDeclNGen_477_);
lean_ctor_set(v_reuseFailAlloc_508_, 4, v___x_500_);
lean_ctor_set(v_reuseFailAlloc_508_, 5, v_cache_478_);
lean_ctor_set(v_reuseFailAlloc_508_, 6, v_messages_479_);
lean_ctor_set(v_reuseFailAlloc_508_, 7, v_infoState_480_);
lean_ctor_set(v_reuseFailAlloc_508_, 8, v_snapshotTasks_481_);
v___x_502_ = v_reuseFailAlloc_508_;
goto v_reusejp_501_;
}
v_reusejp_501_:
{
lean_object* v___x_503_; lean_object* v___x_504_; lean_object* v___x_506_; 
v___x_503_ = lean_st_ref_set(v___y_464_, v___x_502_);
v___x_504_ = lean_box(0);
if (v_isShared_471_ == 0)
{
lean_ctor_set(v___x_470_, 0, v___x_504_);
v___x_506_ = v___x_470_;
goto v_reusejp_505_;
}
else
{
lean_object* v_reuseFailAlloc_507_; 
v_reuseFailAlloc_507_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_507_, 0, v___x_504_);
v___x_506_ = v_reuseFailAlloc_507_;
goto v_reusejp_505_;
}
v_reusejp_505_:
{
return v___x_506_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg___boxed(lean_object* v_cls_513_, lean_object* v_msg_514_, lean_object* v___y_515_, lean_object* v___y_516_, lean_object* v___y_517_, lean_object* v___y_518_, lean_object* v___y_519_){
_start:
{
lean_object* v_res_520_; 
v_res_520_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg(v_cls_513_, v_msg_514_, v___y_515_, v___y_516_, v___y_517_, v___y_518_);
lean_dec(v___y_518_);
lean_dec_ref(v___y_517_);
lean_dec(v___y_516_);
lean_dec_ref(v___y_515_);
return v_res_520_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__2(lean_object* v_snd_521_, lean_object* v___x_522_, lean_object* v___x_523_, lean_object* v_____r_524_, lean_object* v___y_525_, lean_object* v___y_526_, lean_object* v___y_527_, lean_object* v___y_528_, lean_object* v___y_529_, lean_object* v___y_530_, lean_object* v___y_531_, lean_object* v___y_532_){
_start:
{
lean_object* v___x_534_; lean_object* v___x_535_; lean_object* v___x_536_; lean_object* v___x_537_; 
v___x_534_ = lean_array_push(v_snd_521_, v___x_522_);
v___x_535_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_535_, 0, v___x_523_);
lean_ctor_set(v___x_535_, 1, v___x_534_);
v___x_536_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_536_, 0, v___x_535_);
v___x_537_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_537_, 0, v___x_536_);
return v___x_537_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__2___boxed(lean_object* v_snd_538_, lean_object* v___x_539_, lean_object* v___x_540_, lean_object* v_____r_541_, lean_object* v___y_542_, lean_object* v___y_543_, lean_object* v___y_544_, lean_object* v___y_545_, lean_object* v___y_546_, lean_object* v___y_547_, lean_object* v___y_548_, lean_object* v___y_549_, lean_object* v___y_550_){
_start:
{
lean_object* v_res_551_; 
v_res_551_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__2(v_snd_538_, v___x_539_, v___x_540_, v_____r_541_, v___y_542_, v___y_543_, v___y_544_, v___y_545_, v___y_546_, v___y_547_, v___y_548_, v___y_549_);
lean_dec(v___y_549_);
lean_dec_ref(v___y_548_);
lean_dec(v___y_547_);
lean_dec_ref(v___y_546_);
lean_dec(v___y_545_);
lean_dec_ref(v___y_544_);
lean_dec(v___y_543_);
lean_dec_ref(v___y_542_);
return v_res_551_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__6(void){
_start:
{
lean_object* v___x_562_; lean_object* v___x_563_; lean_object* v___x_564_; 
v___x_562_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__3));
v___x_563_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__5));
v___x_564_ = l_Lean_Name_append(v___x_563_, v___x_562_);
return v___x_564_;
}
}
static lean_object* _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__8(void){
_start:
{
lean_object* v___x_566_; lean_object* v___x_567_; 
v___x_566_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__7));
v___x_567_ = l_Lean_stringToMessageData(v___x_566_);
return v___x_567_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg(lean_object* v_upperBound_573_, lean_object* v___x_574_, lean_object* v_config_575_, lean_object* v_a_576_, lean_object* v_b_577_, lean_object* v___y_578_, lean_object* v___y_579_, lean_object* v___y_580_, lean_object* v___y_581_, lean_object* v___y_582_, lean_object* v___y_583_, lean_object* v___y_584_, lean_object* v___y_585_){
_start:
{
lean_object* v___y_588_; lean_object* v___y_611_; uint8_t v___x_614_; 
v___x_614_ = lean_nat_dec_lt(v_a_576_, v_upperBound_573_);
if (v___x_614_ == 0)
{
lean_object* v___x_615_; 
lean_dec(v_a_576_);
lean_dec(v_config_575_);
v___x_615_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_615_, 0, v_b_577_);
return v___x_615_;
}
else
{
lean_object* v___x_616_; lean_object* v_name_617_; lean_object* v_type_618_; lean_object* v_value_619_; lean_object* v___y_621_; lean_object* v___y_622_; lean_object* v_methods_645_; lean_object* v___x_646_; lean_object* v___x_647_; 
v___x_616_ = lean_array_fget_borrowed(v___x_574_, v_a_576_);
v_name_617_ = lean_ctor_get(v___x_616_, 0);
v_type_618_ = lean_ctor_get(v___x_616_, 1);
v_value_619_ = lean_ctor_get(v___x_616_, 2);
v_methods_645_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__11));
lean_inc_ref(v_type_618_);
v___x_646_ = lean_alloc_closure((void*)(l_Lean_Meta_Sym_DSimp_dsimp___boxed), 11, 1);
lean_closure_set(v___x_646_, 0, v_type_618_);
lean_inc(v_config_575_);
v___x_647_ = l_Lean_Meta_Sym_DSimp_DSimpM_run_x27___redArg(v___x_646_, v_methods_645_, v_config_575_, v___y_580_, v___y_581_, v___y_582_, v___y_583_, v___y_584_, v___y_585_);
if (lean_obj_tag(v___x_647_) == 0)
{
lean_object* v_a_648_; lean_object* v_snd_649_; lean_object* v___x_651_; uint8_t v_isShared_652_; uint8_t v_isSharedCheck_690_; 
v_a_648_ = lean_ctor_get(v___x_647_, 0);
lean_inc(v_a_648_);
lean_dec_ref_known(v___x_647_, 1);
v_snd_649_ = lean_ctor_get(v_b_577_, 1);
v_isSharedCheck_690_ = !lean_is_exclusive(v_b_577_);
if (v_isSharedCheck_690_ == 0)
{
lean_object* v_unused_691_; 
v_unused_691_ = lean_ctor_get(v_b_577_, 0);
lean_dec(v_unused_691_);
v___x_651_ = v_b_577_;
v_isShared_652_ = v_isSharedCheck_690_;
goto v_resetjp_650_;
}
else
{
lean_inc(v_snd_649_);
lean_dec(v_b_577_);
v___x_651_ = lean_box(0);
v_isShared_652_ = v_isSharedCheck_690_;
goto v_resetjp_650_;
}
v_resetjp_650_:
{
lean_object* v___x_653_; lean_object* v_a_655_; 
v___x_653_ = lean_box(0);
if (lean_obj_tag(v_a_648_) == 0)
{
lean_dec_ref_known(v_a_648_, 0);
lean_inc_ref(v_type_618_);
v_a_655_ = v_type_618_;
goto v___jp_654_;
}
else
{
lean_object* v_e_x27_689_; 
v_e_x27_689_ = lean_ctor_get(v_a_648_, 0);
lean_inc_ref(v_e_x27_689_);
lean_dec_ref_known(v_a_648_, 1);
v_a_655_ = v_e_x27_689_;
goto v___jp_654_;
}
v___jp_654_:
{
lean_object* v___x_656_; uint8_t v___x_657_; 
lean_inc_ref(v_value_619_);
lean_inc_ref_n(v_a_655_, 2);
lean_inc(v_name_617_);
v___x_656_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v___x_656_, 0, v_name_617_);
lean_ctor_set(v___x_656_, 1, v_a_655_);
lean_ctor_set(v___x_656_, 2, v_value_619_);
v___x_657_ = l_Lean_Expr_isFalse(v_a_655_);
if (v___x_657_ == 0)
{
lean_object* v___f_658_; lean_object* v___x_659_; lean_object* v___f_660_; lean_object* v___f_661_; uint8_t v___x_662_; 
lean_del_object(v___x_651_);
lean_inc_ref(v___x_656_);
lean_inc(v_snd_649_);
v___f_658_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__2___boxed), 13, 3);
lean_closure_set(v___f_658_, 0, v_snd_649_);
lean_closure_set(v___f_658_, 1, v___x_656_);
lean_closure_set(v___f_658_, 2, v___x_653_);
v___x_659_ = lean_box(v___x_614_);
v___f_660_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__3___boxed), 12, 2);
lean_closure_set(v___f_660_, 0, v___x_659_);
lean_closure_set(v___f_660_, 1, v___f_658_);
lean_inc_ref(v_a_655_);
v___f_661_ = lean_alloc_closure((void*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__4___boxed), 12, 2);
lean_closure_set(v___f_661_, 0, v___f_660_);
lean_closure_set(v___f_661_, 1, v_a_655_);
v___x_662_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(v___x_616_, v___x_656_);
if (v___x_662_ == 0)
{
lean_dec_ref_known(v___x_656_, 3);
lean_dec(v_snd_649_);
v___y_621_ = v_a_655_;
v___y_622_ = v___f_661_;
goto v___jp_620_;
}
else
{
if (v___x_657_ == 0)
{
lean_object* v___x_663_; lean_object* v___x_664_; 
lean_dec_ref(v___f_661_);
lean_dec_ref(v_a_655_);
v___x_663_ = lean_box(0);
v___x_664_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___lam__2(v_snd_649_, v___x_656_, v___x_653_, v___x_663_, v___y_578_, v___y_579_, v___y_580_, v___y_581_, v___y_582_, v___y_583_, v___y_584_, v___y_585_);
v___y_588_ = v___x_664_;
goto v___jp_587_;
}
else
{
lean_dec_ref_known(v___x_656_, 3);
lean_dec(v_snd_649_);
v___y_621_ = v_a_655_;
v___y_622_ = v___f_661_;
goto v___jp_620_;
}
}
}
else
{
lean_object* v___x_665_; lean_object* v_goal_666_; lean_object* v___x_667_; 
lean_dec_ref_known(v___x_656_, 3);
lean_dec_ref(v_a_655_);
lean_dec(v_a_576_);
lean_dec(v_config_575_);
v___x_665_ = lean_st_ref_get(v___y_579_);
v_goal_666_ = lean_ctor_get(v___x_665_, 3);
lean_inc(v_goal_666_);
lean_dec(v___x_665_);
lean_inc_ref(v_value_619_);
v___x_667_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1___redArg(v_goal_666_, v_value_619_, v___y_583_);
if (lean_obj_tag(v___x_667_) == 0)
{
lean_object* v___x_669_; uint8_t v_isShared_670_; uint8_t v_isSharedCheck_679_; 
v_isSharedCheck_679_ = !lean_is_exclusive(v___x_667_);
if (v_isSharedCheck_679_ == 0)
{
lean_object* v_unused_680_; 
v_unused_680_ = lean_ctor_get(v___x_667_, 0);
lean_dec(v_unused_680_);
v___x_669_ = v___x_667_;
v_isShared_670_ = v_isSharedCheck_679_;
goto v_resetjp_668_;
}
else
{
lean_dec(v___x_667_);
v___x_669_ = lean_box(0);
v_isShared_670_ = v_isSharedCheck_679_;
goto v_resetjp_668_;
}
v_resetjp_668_:
{
lean_object* v___x_671_; lean_object* v___x_672_; lean_object* v___x_674_; 
v___x_671_ = lean_box(v___x_657_);
v___x_672_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_672_, 0, v___x_671_);
if (v_isShared_652_ == 0)
{
lean_ctor_set(v___x_651_, 0, v___x_672_);
v___x_674_ = v___x_651_;
goto v_reusejp_673_;
}
else
{
lean_object* v_reuseFailAlloc_678_; 
v_reuseFailAlloc_678_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_678_, 0, v___x_672_);
lean_ctor_set(v_reuseFailAlloc_678_, 1, v_snd_649_);
v___x_674_ = v_reuseFailAlloc_678_;
goto v_reusejp_673_;
}
v_reusejp_673_:
{
lean_object* v___x_676_; 
if (v_isShared_670_ == 0)
{
lean_ctor_set(v___x_669_, 0, v___x_674_);
v___x_676_ = v___x_669_;
goto v_reusejp_675_;
}
else
{
lean_object* v_reuseFailAlloc_677_; 
v_reuseFailAlloc_677_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_677_, 0, v___x_674_);
v___x_676_ = v_reuseFailAlloc_677_;
goto v_reusejp_675_;
}
v_reusejp_675_:
{
return v___x_676_;
}
}
}
}
else
{
lean_object* v_a_681_; lean_object* v___x_683_; uint8_t v_isShared_684_; uint8_t v_isSharedCheck_688_; 
lean_del_object(v___x_651_);
lean_dec(v_snd_649_);
v_a_681_ = lean_ctor_get(v___x_667_, 0);
v_isSharedCheck_688_ = !lean_is_exclusive(v___x_667_);
if (v_isSharedCheck_688_ == 0)
{
v___x_683_ = v___x_667_;
v_isShared_684_ = v_isSharedCheck_688_;
goto v_resetjp_682_;
}
else
{
lean_inc(v_a_681_);
lean_dec(v___x_667_);
v___x_683_ = lean_box(0);
v_isShared_684_ = v_isSharedCheck_688_;
goto v_resetjp_682_;
}
v_resetjp_682_:
{
lean_object* v___x_686_; 
if (v_isShared_684_ == 0)
{
v___x_686_ = v___x_683_;
goto v_reusejp_685_;
}
else
{
lean_object* v_reuseFailAlloc_687_; 
v_reuseFailAlloc_687_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_687_, 0, v_a_681_);
v___x_686_ = v_reuseFailAlloc_687_;
goto v_reusejp_685_;
}
v_reusejp_685_:
{
return v___x_686_;
}
}
}
}
}
}
}
else
{
lean_object* v_a_692_; lean_object* v___x_694_; uint8_t v_isShared_695_; uint8_t v_isSharedCheck_699_; 
lean_dec_ref(v_b_577_);
lean_dec(v_a_576_);
lean_dec(v_config_575_);
v_a_692_ = lean_ctor_get(v___x_647_, 0);
v_isSharedCheck_699_ = !lean_is_exclusive(v___x_647_);
if (v_isSharedCheck_699_ == 0)
{
v___x_694_ = v___x_647_;
v_isShared_695_ = v_isSharedCheck_699_;
goto v_resetjp_693_;
}
else
{
lean_inc(v_a_692_);
lean_dec(v___x_647_);
v___x_694_ = lean_box(0);
v_isShared_695_ = v_isSharedCheck_699_;
goto v_resetjp_693_;
}
v_resetjp_693_:
{
lean_object* v___x_697_; 
if (v_isShared_695_ == 0)
{
v___x_697_ = v___x_694_;
goto v_reusejp_696_;
}
else
{
lean_object* v_reuseFailAlloc_698_; 
v_reuseFailAlloc_698_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_698_, 0, v_a_692_);
v___x_697_ = v_reuseFailAlloc_698_;
goto v_reusejp_696_;
}
v_reusejp_696_:
{
return v___x_697_;
}
}
}
v___jp_620_:
{
lean_object* v_options_623_; uint8_t v_hasTrace_624_; 
v_options_623_ = lean_ctor_get(v___y_584_, 2);
v_hasTrace_624_ = lean_ctor_get_uint8(v_options_623_, sizeof(void*)*1);
if (v_hasTrace_624_ == 0)
{
lean_dec_ref(v___y_621_);
v___y_611_ = v___y_622_;
goto v___jp_610_;
}
else
{
lean_object* v_inheritedTraceOptions_625_; lean_object* v___x_626_; lean_object* v___x_627_; uint8_t v___x_628_; 
v_inheritedTraceOptions_625_ = lean_ctor_get(v___y_584_, 13);
v___x_626_ = ((lean_object*)(l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__3));
v___x_627_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__6, &l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__6_once, _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__6);
v___x_628_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_625_, v_options_623_, v___x_627_);
if (v___x_628_ == 0)
{
lean_dec_ref(v___y_621_);
v___y_611_ = v___y_622_;
goto v___jp_610_;
}
else
{
lean_object* v___x_629_; lean_object* v___x_630_; lean_object* v___x_631_; lean_object* v___x_632_; lean_object* v___x_633_; lean_object* v___x_634_; 
lean_inc_ref(v_type_618_);
v___x_629_ = l_Lean_MessageData_ofExpr(v_type_618_);
v___x_630_ = lean_obj_once(&l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__8, &l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__8_once, _init_l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___closed__8);
v___x_631_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_631_, 0, v___x_629_);
lean_ctor_set(v___x_631_, 1, v___x_630_);
v___x_632_ = l_Lean_MessageData_ofExpr(v___y_621_);
v___x_633_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_633_, 0, v___x_631_);
lean_ctor_set(v___x_633_, 1, v___x_632_);
v___x_634_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg(v___x_626_, v___x_633_, v___y_582_, v___y_583_, v___y_584_, v___y_585_);
if (lean_obj_tag(v___x_634_) == 0)
{
lean_object* v_a_635_; lean_object* v___x_636_; 
v_a_635_ = lean_ctor_get(v___x_634_, 0);
lean_inc(v_a_635_);
lean_dec_ref_known(v___x_634_, 1);
lean_inc(v___y_585_);
lean_inc_ref(v___y_584_);
lean_inc(v___y_583_);
lean_inc_ref(v___y_582_);
lean_inc(v___y_581_);
lean_inc_ref(v___y_580_);
lean_inc(v___y_579_);
lean_inc_ref(v___y_578_);
v___x_636_ = lean_apply_10(v___y_622_, v_a_635_, v___y_578_, v___y_579_, v___y_580_, v___y_581_, v___y_582_, v___y_583_, v___y_584_, v___y_585_, lean_box(0));
v___y_588_ = v___x_636_;
goto v___jp_587_;
}
else
{
lean_object* v_a_637_; lean_object* v___x_639_; uint8_t v_isShared_640_; uint8_t v_isSharedCheck_644_; 
lean_dec_ref(v___y_622_);
lean_dec(v_a_576_);
lean_dec(v_config_575_);
v_a_637_ = lean_ctor_get(v___x_634_, 0);
v_isSharedCheck_644_ = !lean_is_exclusive(v___x_634_);
if (v_isSharedCheck_644_ == 0)
{
v___x_639_ = v___x_634_;
v_isShared_640_ = v_isSharedCheck_644_;
goto v_resetjp_638_;
}
else
{
lean_inc(v_a_637_);
lean_dec(v___x_634_);
v___x_639_ = lean_box(0);
v_isShared_640_ = v_isSharedCheck_644_;
goto v_resetjp_638_;
}
v_resetjp_638_:
{
lean_object* v___x_642_; 
if (v_isShared_640_ == 0)
{
v___x_642_ = v___x_639_;
goto v_reusejp_641_;
}
else
{
lean_object* v_reuseFailAlloc_643_; 
v_reuseFailAlloc_643_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_643_, 0, v_a_637_);
v___x_642_ = v_reuseFailAlloc_643_;
goto v_reusejp_641_;
}
v_reusejp_641_:
{
return v___x_642_;
}
}
}
}
}
}
}
v___jp_587_:
{
if (lean_obj_tag(v___y_588_) == 0)
{
lean_object* v_a_589_; lean_object* v___x_591_; uint8_t v_isShared_592_; uint8_t v_isSharedCheck_601_; 
v_a_589_ = lean_ctor_get(v___y_588_, 0);
v_isSharedCheck_601_ = !lean_is_exclusive(v___y_588_);
if (v_isSharedCheck_601_ == 0)
{
v___x_591_ = v___y_588_;
v_isShared_592_ = v_isSharedCheck_601_;
goto v_resetjp_590_;
}
else
{
lean_inc(v_a_589_);
lean_dec(v___y_588_);
v___x_591_ = lean_box(0);
v_isShared_592_ = v_isSharedCheck_601_;
goto v_resetjp_590_;
}
v_resetjp_590_:
{
if (lean_obj_tag(v_a_589_) == 0)
{
lean_object* v_a_593_; lean_object* v___x_595_; 
lean_dec(v_a_576_);
lean_dec(v_config_575_);
v_a_593_ = lean_ctor_get(v_a_589_, 0);
lean_inc(v_a_593_);
lean_dec_ref_known(v_a_589_, 1);
if (v_isShared_592_ == 0)
{
lean_ctor_set(v___x_591_, 0, v_a_593_);
v___x_595_ = v___x_591_;
goto v_reusejp_594_;
}
else
{
lean_object* v_reuseFailAlloc_596_; 
v_reuseFailAlloc_596_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_596_, 0, v_a_593_);
v___x_595_ = v_reuseFailAlloc_596_;
goto v_reusejp_594_;
}
v_reusejp_594_:
{
return v___x_595_;
}
}
else
{
lean_object* v_a_597_; lean_object* v___x_598_; lean_object* v___x_599_; 
lean_del_object(v___x_591_);
v_a_597_ = lean_ctor_get(v_a_589_, 0);
lean_inc(v_a_597_);
lean_dec_ref_known(v_a_589_, 1);
v___x_598_ = lean_unsigned_to_nat(1u);
v___x_599_ = lean_nat_add(v_a_576_, v___x_598_);
lean_dec(v_a_576_);
v_a_576_ = v___x_599_;
v_b_577_ = v_a_597_;
goto _start;
}
}
}
else
{
lean_object* v_a_602_; lean_object* v___x_604_; uint8_t v_isShared_605_; uint8_t v_isSharedCheck_609_; 
lean_dec(v_a_576_);
lean_dec(v_config_575_);
v_a_602_ = lean_ctor_get(v___y_588_, 0);
v_isSharedCheck_609_ = !lean_is_exclusive(v___y_588_);
if (v_isSharedCheck_609_ == 0)
{
v___x_604_ = v___y_588_;
v_isShared_605_ = v_isSharedCheck_609_;
goto v_resetjp_603_;
}
else
{
lean_inc(v_a_602_);
lean_dec(v___y_588_);
v___x_604_ = lean_box(0);
v_isShared_605_ = v_isSharedCheck_609_;
goto v_resetjp_603_;
}
v_resetjp_603_:
{
lean_object* v___x_607_; 
if (v_isShared_605_ == 0)
{
v___x_607_ = v___x_604_;
goto v_reusejp_606_;
}
else
{
lean_object* v_reuseFailAlloc_608_; 
v_reuseFailAlloc_608_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_608_, 0, v_a_602_);
v___x_607_ = v_reuseFailAlloc_608_;
goto v_reusejp_606_;
}
v_reusejp_606_:
{
return v___x_607_;
}
}
}
}
v___jp_610_:
{
lean_object* v___x_612_; lean_object* v___x_613_; 
v___x_612_ = lean_box(0);
lean_inc(v___y_585_);
lean_inc_ref(v___y_584_);
lean_inc(v___y_583_);
lean_inc_ref(v___y_582_);
lean_inc(v___y_581_);
lean_inc_ref(v___y_580_);
lean_inc(v___y_579_);
lean_inc_ref(v___y_578_);
v___x_613_ = lean_apply_10(v___y_611_, v___x_612_, v___y_578_, v___y_579_, v___y_580_, v___y_581_, v___y_582_, v___y_583_, v___y_584_, v___y_585_, lean_box(0));
v___y_588_ = v___x_613_;
goto v___jp_587_;
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg___boxed(lean_object* v_upperBound_700_, lean_object* v___x_701_, lean_object* v_config_702_, lean_object* v_a_703_, lean_object* v_b_704_, lean_object* v___y_705_, lean_object* v___y_706_, lean_object* v___y_707_, lean_object* v___y_708_, lean_object* v___y_709_, lean_object* v___y_710_, lean_object* v___y_711_, lean_object* v___y_712_, lean_object* v___y_713_){
_start:
{
lean_object* v_res_714_; 
v_res_714_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg(v_upperBound_700_, v___x_701_, v_config_702_, v_a_703_, v_b_704_, v___y_705_, v___y_706_, v___y_707_, v___y_708_, v___y_709_, v___y_710_, v___y_711_, v___y_712_);
lean_dec(v___y_712_);
lean_dec_ref(v___y_711_);
lean_dec(v___y_710_);
lean_dec_ref(v___y_709_);
lean_dec(v___y_708_);
lean_dec_ref(v___y_707_);
lean_dec(v___y_706_);
lean_dec_ref(v___y_705_);
lean_dec_ref(v___x_701_);
lean_dec(v_upperBound_700_);
return v_res_714_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__0(lean_object* v_maxSteps_715_, lean_object* v___y_716_, lean_object* v___y_717_, lean_object* v___y_718_, lean_object* v___y_719_, lean_object* v___y_720_, lean_object* v___y_721_, lean_object* v___y_722_, lean_object* v___y_723_){
_start:
{
lean_object* v___x_725_; lean_object* v_hypotheses_726_; lean_object* v___x_727_; lean_object* v_newHyps_728_; lean_object* v___x_729_; lean_object* v___x_730_; lean_object* v___x_731_; lean_object* v___x_732_; 
v___x_725_ = lean_st_ref_get(v___y_717_);
v_hypotheses_726_ = lean_ctor_get(v___x_725_, 4);
lean_inc_ref(v_hypotheses_726_);
lean_dec(v___x_725_);
v___x_727_ = lean_array_get_size(v_hypotheses_726_);
v_newHyps_728_ = lean_mk_empty_array_with_capacity(v___x_727_);
v___x_729_ = lean_unsigned_to_nat(0u);
v___x_730_ = lean_box(0);
v___x_731_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_731_, 0, v___x_730_);
lean_ctor_set(v___x_731_, 1, v_newHyps_728_);
v___x_732_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg(v___x_727_, v_hypotheses_726_, v_maxSteps_715_, v___x_729_, v___x_731_, v___y_716_, v___y_717_, v___y_718_, v___y_719_, v___y_720_, v___y_721_, v___y_722_, v___y_723_);
lean_dec_ref(v_hypotheses_726_);
if (lean_obj_tag(v___x_732_) == 0)
{
lean_object* v_a_733_; lean_object* v___x_735_; uint8_t v_isShared_736_; uint8_t v_isSharedCheck_763_; 
v_a_733_ = lean_ctor_get(v___x_732_, 0);
v_isSharedCheck_763_ = !lean_is_exclusive(v___x_732_);
if (v_isSharedCheck_763_ == 0)
{
v___x_735_ = v___x_732_;
v_isShared_736_ = v_isSharedCheck_763_;
goto v_resetjp_734_;
}
else
{
lean_inc(v_a_733_);
lean_dec(v___x_732_);
v___x_735_ = lean_box(0);
v_isShared_736_ = v_isSharedCheck_763_;
goto v_resetjp_734_;
}
v_resetjp_734_:
{
lean_object* v_fst_737_; 
v_fst_737_ = lean_ctor_get(v_a_733_, 0);
if (lean_obj_tag(v_fst_737_) == 0)
{
lean_object* v_snd_738_; lean_object* v___x_739_; lean_object* v_rewriteCache_740_; lean_object* v_acNfCache_741_; lean_object* v_typeAnalysis_742_; lean_object* v_goal_743_; uint8_t v_didChange_744_; lean_object* v___x_746_; uint8_t v_isShared_747_; uint8_t v_isSharedCheck_757_; 
v_snd_738_ = lean_ctor_get(v_a_733_, 1);
lean_inc(v_snd_738_);
lean_dec(v_a_733_);
v___x_739_ = lean_st_ref_take(v___y_717_);
v_rewriteCache_740_ = lean_ctor_get(v___x_739_, 0);
v_acNfCache_741_ = lean_ctor_get(v___x_739_, 1);
v_typeAnalysis_742_ = lean_ctor_get(v___x_739_, 2);
v_goal_743_ = lean_ctor_get(v___x_739_, 3);
v_didChange_744_ = lean_ctor_get_uint8(v___x_739_, sizeof(void*)*5);
v_isSharedCheck_757_ = !lean_is_exclusive(v___x_739_);
if (v_isSharedCheck_757_ == 0)
{
lean_object* v_unused_758_; 
v_unused_758_ = lean_ctor_get(v___x_739_, 4);
lean_dec(v_unused_758_);
v___x_746_ = v___x_739_;
v_isShared_747_ = v_isSharedCheck_757_;
goto v_resetjp_745_;
}
else
{
lean_inc(v_goal_743_);
lean_inc(v_typeAnalysis_742_);
lean_inc(v_acNfCache_741_);
lean_inc(v_rewriteCache_740_);
lean_dec(v___x_739_);
v___x_746_ = lean_box(0);
v_isShared_747_ = v_isSharedCheck_757_;
goto v_resetjp_745_;
}
v_resetjp_745_:
{
lean_object* v___x_749_; 
if (v_isShared_747_ == 0)
{
lean_ctor_set(v___x_746_, 4, v_snd_738_);
v___x_749_ = v___x_746_;
goto v_reusejp_748_;
}
else
{
lean_object* v_reuseFailAlloc_756_; 
v_reuseFailAlloc_756_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_756_, 0, v_rewriteCache_740_);
lean_ctor_set(v_reuseFailAlloc_756_, 1, v_acNfCache_741_);
lean_ctor_set(v_reuseFailAlloc_756_, 2, v_typeAnalysis_742_);
lean_ctor_set(v_reuseFailAlloc_756_, 3, v_goal_743_);
lean_ctor_set(v_reuseFailAlloc_756_, 4, v_snd_738_);
lean_ctor_set_uint8(v_reuseFailAlloc_756_, sizeof(void*)*5, v_didChange_744_);
v___x_749_ = v_reuseFailAlloc_756_;
goto v_reusejp_748_;
}
v_reusejp_748_:
{
lean_object* v___x_750_; uint8_t v___x_751_; lean_object* v___x_752_; lean_object* v___x_754_; 
v___x_750_ = lean_st_ref_set(v___y_717_, v___x_749_);
v___x_751_ = 0;
v___x_752_ = lean_box(v___x_751_);
if (v_isShared_736_ == 0)
{
lean_ctor_set(v___x_735_, 0, v___x_752_);
v___x_754_ = v___x_735_;
goto v_reusejp_753_;
}
else
{
lean_object* v_reuseFailAlloc_755_; 
v_reuseFailAlloc_755_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_755_, 0, v___x_752_);
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
lean_object* v_val_759_; lean_object* v___x_761_; 
lean_inc_ref(v_fst_737_);
lean_dec(v_a_733_);
v_val_759_ = lean_ctor_get(v_fst_737_, 0);
lean_inc(v_val_759_);
lean_dec_ref_known(v_fst_737_, 1);
if (v_isShared_736_ == 0)
{
lean_ctor_set(v___x_735_, 0, v_val_759_);
v___x_761_ = v___x_735_;
goto v_reusejp_760_;
}
else
{
lean_object* v_reuseFailAlloc_762_; 
v_reuseFailAlloc_762_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_762_, 0, v_val_759_);
v___x_761_ = v_reuseFailAlloc_762_;
goto v_reusejp_760_;
}
v_reusejp_760_:
{
return v___x_761_;
}
}
}
}
else
{
lean_object* v_a_764_; lean_object* v___x_766_; uint8_t v_isShared_767_; uint8_t v_isSharedCheck_771_; 
v_a_764_ = lean_ctor_get(v___x_732_, 0);
v_isSharedCheck_771_ = !lean_is_exclusive(v___x_732_);
if (v_isSharedCheck_771_ == 0)
{
v___x_766_ = v___x_732_;
v_isShared_767_ = v_isSharedCheck_771_;
goto v_resetjp_765_;
}
else
{
lean_inc(v_a_764_);
lean_dec(v___x_732_);
v___x_766_ = lean_box(0);
v_isShared_767_ = v_isSharedCheck_771_;
goto v_resetjp_765_;
}
v_resetjp_765_:
{
lean_object* v___x_769_; 
if (v_isShared_767_ == 0)
{
v___x_769_ = v___x_766_;
goto v_reusejp_768_;
}
else
{
lean_object* v_reuseFailAlloc_770_; 
v_reuseFailAlloc_770_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_770_, 0, v_a_764_);
v___x_769_ = v_reuseFailAlloc_770_;
goto v_reusejp_768_;
}
v_reusejp_768_:
{
return v___x_769_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__0___boxed(lean_object* v_maxSteps_772_, lean_object* v___y_773_, lean_object* v___y_774_, lean_object* v___y_775_, lean_object* v___y_776_, lean_object* v___y_777_, lean_object* v___y_778_, lean_object* v___y_779_, lean_object* v___y_780_, lean_object* v___y_781_){
_start:
{
lean_object* v_res_782_; 
v_res_782_ = l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__0(v_maxSteps_772_, v___y_773_, v___y_774_, v___y_775_, v___y_776_, v___y_777_, v___y_778_, v___y_779_, v___y_780_);
lean_dec(v___y_780_);
lean_dec_ref(v___y_779_);
lean_dec(v___y_778_);
lean_dec_ref(v___y_777_);
lean_dec(v___y_776_);
lean_dec_ref(v___y_775_);
lean_dec(v___y_774_);
lean_dec_ref(v___y_773_);
return v_res_782_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__1(lean_object* v___y_783_, lean_object* v___y_784_, lean_object* v___y_785_, lean_object* v___y_786_, lean_object* v___y_787_, lean_object* v___y_788_, lean_object* v___y_789_, lean_object* v___y_790_){
_start:
{
lean_object* v___x_792_; lean_object* v_maxSteps_793_; lean_object* v_goal_794_; lean_object* v___f_795_; lean_object* v___x_796_; 
v___x_792_ = lean_st_ref_get(v___y_784_);
v_maxSteps_793_ = lean_ctor_get(v___y_783_, 1);
v_goal_794_ = lean_ctor_get(v___x_792_, 3);
lean_inc(v_goal_794_);
lean_dec(v___x_792_);
lean_inc(v_maxSteps_793_);
v___f_795_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__0___boxed), 10, 1);
lean_closure_set(v___f_795_, 0, v_maxSteps_793_);
v___x_796_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__3___redArg(v_goal_794_, v___f_795_, v___y_783_, v___y_784_, v___y_785_, v___y_786_, v___y_787_, v___y_788_, v___y_789_, v___y_790_);
return v___x_796_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__1___boxed(lean_object* v___y_797_, lean_object* v___y_798_, lean_object* v___y_799_, lean_object* v___y_800_, lean_object* v___y_801_, lean_object* v___y_802_, lean_object* v___y_803_, lean_object* v___y_804_, lean_object* v___y_805_){
_start:
{
lean_object* v_res_806_; 
v_res_806_ = l_Lean_Meta_Tactic_BVDecide_Normalize_zetaPass___lam__1(v___y_797_, v___y_798_, v___y_799_, v___y_800_, v___y_801_, v___y_802_, v___y_803_, v___y_804_);
lean_dec(v___y_804_);
lean_dec_ref(v___y_803_);
lean_dec(v___y_802_);
lean_dec_ref(v___y_801_);
lean_dec(v___y_800_);
lean_dec_ref(v___y_799_);
lean_dec(v___y_798_);
lean_dec_ref(v___y_797_);
return v_res_806_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0(lean_object* v_cls_815_, lean_object* v_msg_816_, lean_object* v___y_817_, lean_object* v___y_818_, lean_object* v___y_819_, lean_object* v___y_820_, lean_object* v___y_821_, lean_object* v___y_822_, lean_object* v___y_823_, lean_object* v___y_824_){
_start:
{
lean_object* v___x_826_; 
v___x_826_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___redArg(v_cls_815_, v_msg_816_, v___y_821_, v___y_822_, v___y_823_, v___y_824_);
return v___x_826_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0___boxed(lean_object* v_cls_827_, lean_object* v_msg_828_, lean_object* v___y_829_, lean_object* v___y_830_, lean_object* v___y_831_, lean_object* v___y_832_, lean_object* v___y_833_, lean_object* v___y_834_, lean_object* v___y_835_, lean_object* v___y_836_, lean_object* v___y_837_){
_start:
{
lean_object* v_res_838_; 
v_res_838_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__0(v_cls_827_, v_msg_828_, v___y_829_, v___y_830_, v___y_831_, v___y_832_, v___y_833_, v___y_834_, v___y_835_, v___y_836_);
lean_dec(v___y_836_);
lean_dec_ref(v___y_835_);
lean_dec(v___y_834_);
lean_dec_ref(v___y_833_);
lean_dec(v___y_832_);
lean_dec_ref(v___y_831_);
lean_dec(v___y_830_);
lean_dec_ref(v___y_829_);
return v_res_838_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1(lean_object* v_mvarId_839_, lean_object* v_val_840_, lean_object* v___y_841_, lean_object* v___y_842_, lean_object* v___y_843_, lean_object* v___y_844_, lean_object* v___y_845_, lean_object* v___y_846_, lean_object* v___y_847_, lean_object* v___y_848_){
_start:
{
lean_object* v___x_850_; 
v___x_850_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1___redArg(v_mvarId_839_, v_val_840_, v___y_846_);
return v___x_850_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1___boxed(lean_object* v_mvarId_851_, lean_object* v_val_852_, lean_object* v___y_853_, lean_object* v___y_854_, lean_object* v___y_855_, lean_object* v___y_856_, lean_object* v___y_857_, lean_object* v___y_858_, lean_object* v___y_859_, lean_object* v___y_860_, lean_object* v___y_861_){
_start:
{
lean_object* v_res_862_; 
v_res_862_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1(v_mvarId_851_, v_val_852_, v___y_853_, v___y_854_, v___y_855_, v___y_856_, v___y_857_, v___y_858_, v___y_859_, v___y_860_);
lean_dec(v___y_860_);
lean_dec_ref(v___y_859_);
lean_dec(v___y_858_);
lean_dec_ref(v___y_857_);
lean_dec(v___y_856_);
lean_dec_ref(v___y_855_);
lean_dec(v___y_854_);
lean_dec_ref(v___y_853_);
return v_res_862_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2(lean_object* v_upperBound_863_, lean_object* v___x_864_, lean_object* v_config_865_, lean_object* v_inst_866_, lean_object* v_R_867_, lean_object* v_a_868_, lean_object* v_b_869_, lean_object* v_c_870_, lean_object* v___y_871_, lean_object* v___y_872_, lean_object* v___y_873_, lean_object* v___y_874_, lean_object* v___y_875_, lean_object* v___y_876_, lean_object* v___y_877_, lean_object* v___y_878_){
_start:
{
lean_object* v___x_880_; 
v___x_880_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___redArg(v_upperBound_863_, v___x_864_, v_config_865_, v_a_868_, v_b_869_, v___y_871_, v___y_872_, v___y_873_, v___y_874_, v___y_875_, v___y_876_, v___y_877_, v___y_878_);
return v___x_880_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2___boxed(lean_object** _args){
lean_object* v_upperBound_881_ = _args[0];
lean_object* v___x_882_ = _args[1];
lean_object* v_config_883_ = _args[2];
lean_object* v_inst_884_ = _args[3];
lean_object* v_R_885_ = _args[4];
lean_object* v_a_886_ = _args[5];
lean_object* v_b_887_ = _args[6];
lean_object* v_c_888_ = _args[7];
lean_object* v___y_889_ = _args[8];
lean_object* v___y_890_ = _args[9];
lean_object* v___y_891_ = _args[10];
lean_object* v___y_892_ = _args[11];
lean_object* v___y_893_ = _args[12];
lean_object* v___y_894_ = _args[13];
lean_object* v___y_895_ = _args[14];
lean_object* v___y_896_ = _args[15];
lean_object* v___y_897_ = _args[16];
_start:
{
lean_object* v_res_898_; 
v_res_898_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__2(v_upperBound_881_, v___x_882_, v_config_883_, v_inst_884_, v_R_885_, v_a_886_, v_b_887_, v_c_888_, v___y_889_, v___y_890_, v___y_891_, v___y_892_, v___y_893_, v___y_894_, v___y_895_, v___y_896_);
lean_dec(v___y_896_);
lean_dec_ref(v___y_895_);
lean_dec(v___y_894_);
lean_dec_ref(v___y_893_);
lean_dec(v___y_892_);
lean_dec_ref(v___y_891_);
lean_dec(v___y_890_);
lean_dec_ref(v___y_889_);
lean_dec_ref(v___x_882_);
lean_dec(v_upperBound_881_);
return v_res_898_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2(lean_object* v_00_u03b2_899_, lean_object* v_x_900_, lean_object* v_x_901_, lean_object* v_x_902_){
_start:
{
lean_object* v___x_903_; 
v___x_903_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2___redArg(v_x_900_, v_x_901_, v_x_902_);
return v___x_903_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4(lean_object* v_00_u03b2_904_, lean_object* v_x_905_, size_t v_x_906_, size_t v_x_907_, lean_object* v_x_908_, lean_object* v_x_909_){
_start:
{
lean_object* v___x_910_; 
v___x_910_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___redArg(v_x_905_, v_x_906_, v_x_907_, v_x_908_, v_x_909_);
return v___x_910_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4___boxed(lean_object* v_00_u03b2_911_, lean_object* v_x_912_, lean_object* v_x_913_, lean_object* v_x_914_, lean_object* v_x_915_, lean_object* v_x_916_){
_start:
{
size_t v_x_25715__boxed_917_; size_t v_x_25716__boxed_918_; lean_object* v_res_919_; 
v_x_25715__boxed_917_ = lean_unbox_usize(v_x_913_);
lean_dec(v_x_913_);
v_x_25716__boxed_918_ = lean_unbox_usize(v_x_914_);
lean_dec(v_x_914_);
v_res_919_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4(v_00_u03b2_911_, v_x_912_, v_x_25715__boxed_917_, v_x_25716__boxed_918_, v_x_915_, v_x_916_);
return v_res_919_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6(lean_object* v_00_u03b2_920_, lean_object* v_n_921_, lean_object* v_k_922_, lean_object* v_v_923_){
_start:
{
lean_object* v___x_924_; 
v___x_924_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6___redArg(v_n_921_, v_k_922_, v_v_923_);
return v___x_924_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7(lean_object* v_00_u03b2_925_, size_t v_depth_926_, lean_object* v_keys_927_, lean_object* v_vals_928_, lean_object* v_heq_929_, lean_object* v_i_930_, lean_object* v_entries_931_){
_start:
{
lean_object* v___x_932_; 
v___x_932_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7___redArg(v_depth_926_, v_keys_927_, v_vals_928_, v_i_930_, v_entries_931_);
return v___x_932_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7___boxed(lean_object* v_00_u03b2_933_, lean_object* v_depth_934_, lean_object* v_keys_935_, lean_object* v_vals_936_, lean_object* v_heq_937_, lean_object* v_i_938_, lean_object* v_entries_939_){
_start:
{
size_t v_depth_boxed_940_; lean_object* v_res_941_; 
v_depth_boxed_940_ = lean_unbox_usize(v_depth_934_);
lean_dec(v_depth_934_);
v_res_941_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__7(v_00_u03b2_933_, v_depth_boxed_940_, v_keys_935_, v_vals_936_, v_heq_937_, v_i_938_, v_entries_939_);
lean_dec_ref(v_vals_936_);
lean_dec_ref(v_keys_935_);
return v_res_941_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6_spec__7(lean_object* v_00_u03b2_942_, lean_object* v_x_943_, lean_object* v_x_944_, lean_object* v_x_945_, lean_object* v_x_946_){
_start:
{
lean_object* v___x_947_; 
v___x_947_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_Normalize_zetaPass_spec__1_spec__2_spec__4_spec__6_spec__7___redArg(v_x_943_, v_x_944_, v_x_945_, v_x_946_);
return v___x_947_;
}
}
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_Theorems(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_DSimp(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Zeta(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_Theorems(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_DSimp(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Zeta(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_Theorems(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_DSimp(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Zeta(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_Theorems(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_DSimp(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Zeta(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Zeta(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Meta_Tactic_BVDecide_Normalize_Zeta(builtin);
}
#ifdef __cplusplus
}
#endif
