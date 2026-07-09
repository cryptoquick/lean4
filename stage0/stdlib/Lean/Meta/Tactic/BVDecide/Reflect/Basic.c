// Lean compiler output
// Module: Lean.Meta.Tactic.BVDecide.Reflect.Basic
// Imports: public import Std.Data.HashMap public import Std.Tactic.BVDecide.Bitblast.BVExpr.Basic import Lean.Data.RArray public import Lean.Meta.Sym.SymM public import Lean.Meta.Tactic.BVDecide.Normalize.Basic
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
lean_object* l_Lean_Level_ofNat(lean_object*);
lean_object* l_Lean_Name_mkStr5(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkConst(lean_object*, lean_object*);
lean_object* lean_array_push(lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr4(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_st_mk_ref(lean_object*);
lean_object* lean_st_ref_get(lean_object*);
lean_object* lean_array_get_size(lean_object*);
uint64_t l_Lean_Meta_Sym_hashPtrExpr_unsafe__1(lean_object*);
uint64_t lean_uint64_shift_right(uint64_t, uint64_t);
uint64_t lean_uint64_xor(uint64_t, uint64_t);
size_t lean_uint64_to_usize(uint64_t);
size_t lean_usize_of_nat(lean_object*);
size_t lean_usize_sub(size_t, size_t);
size_t lean_usize_land(size_t, size_t);
lean_object* lean_array_uget_borrowed(lean_object*, size_t);
uint8_t l___private_Lean_Meta_Sym_ExprPtr_0__Lean_Meta_Sym_isSameExpr_unsafe__1(lean_object*, lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
lean_object* lean_array_uset(lean_object*, size_t, lean_object*);
lean_object* lean_nat_mul(lean_object*, lean_object*);
lean_object* lean_nat_div(lean_object*, lean_object*);
uint8_t lean_nat_dec_le(lean_object*, lean_object*);
lean_object* lean_mk_array(lean_object*, lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
lean_object* lean_array_fget(lean_object*, lean_object*);
lean_object* lean_array_fset(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkNatLit(lean_object*);
lean_object* l_Lean_Expr_app___override(lean_object*, lean_object*);
uint8_t lean_usize_dec_lt(size_t, size_t);
lean_object* lean_array_uget(lean_object*, size_t);
size_t lean_usize_add(size_t, size_t);
lean_object* l_Lean_Name_mkStr2(lean_object*, lean_object*);
size_t lean_array_size(lean_object*);
lean_object* lean_array_fswap(lean_object*, lean_object*, lean_object*);
lean_object* lean_array_fget_borrowed(lean_object*, lean_object*);
lean_object* lean_nat_shiftr(lean_object*, lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
lean_object* lean_nat_sub(lean_object*, lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
uint8_t lean_usize_dec_eq(size_t, size_t);
lean_object* l_Lean_stringToMessageData(lean_object*);
lean_object* l_Lean_RArray_ofArray___redArg(lean_object*);
lean_object* l_Lean_Name_mkStr6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkAppB(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_RArray_toExpr___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_shareCommon(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_st_ref_take(lean_object*);
lean_object* lean_st_ref_set(lean_object*, lean_object*);
lean_object* l___private_Lean_Meta_Sym_ExprPtr_0__Lean_Meta_Sym_isSameExpr_unsafe__1___boxed(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_hashPtrExpr_unsafe__1___boxed(lean_object*);
lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkApp4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr3(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr1(lean_object*);
lean_object* l_Lean_Name_append(lean_object*, lean_object*);
uint8_t l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(lean_object*, lean_object*, lean_object*);
lean_object* l_Nat_reprFast(lean_object*);
lean_object* l_Lean_MessageData_ofFormat(lean_object*);
lean_object* l_Lean_MessageData_ofExpr(lean_object*);
double lean_float_of_nat(lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* l_Lean_PersistentArray_push___redArg(lean_object*, lean_object*);
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
lean_object* l_instInhabitedForall___redArg___lam__0___boxed(lean_object*, lean_object*);
lean_object* lean_panic_fn_borrowed(lean_object*, lean_object*);
lean_object* l_Lean_Expr_const___override(lean_object*, lean_object*);
lean_object* l_Lean_mkApp3(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkApp6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkApp5(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "Std"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "BVDecide"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "BVBinOp"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "and"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__4_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value),LEAN_SCALAR_PTR_LITERAL(173, 0, 131, 50, 199, 91, 123, 28)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__4_value),LEAN_SCALAR_PTR_LITERAL(67, 200, 193, 54, 191, 172, 208, 119)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__6;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "or"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__7 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__7_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value),LEAN_SCALAR_PTR_LITERAL(173, 0, 131, 50, 199, 91, 123, 28)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__7_value),LEAN_SCALAR_PTR_LITERAL(137, 33, 141, 132, 156, 154, 79, 232)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__9;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "xor"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__10 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__10_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value),LEAN_SCALAR_PTR_LITERAL(173, 0, 131, 50, 199, 91, 123, 28)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__10_value),LEAN_SCALAR_PTR_LITERAL(68, 221, 44, 95, 169, 9, 73, 176)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__12_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__12;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__13_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "add"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__13 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__13_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value),LEAN_SCALAR_PTR_LITERAL(173, 0, 131, 50, 199, 91, 123, 28)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__13_value),LEAN_SCALAR_PTR_LITERAL(236, 85, 182, 141, 252, 28, 21, 198)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__15_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__15;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__16_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "mul"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__16 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__16_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value),LEAN_SCALAR_PTR_LITERAL(173, 0, 131, 50, 199, 91, 123, 28)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__16_value),LEAN_SCALAR_PTR_LITERAL(66, 46, 226, 27, 15, 162, 209, 81)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__18_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__18;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__19_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "udiv"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__19 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__19_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value),LEAN_SCALAR_PTR_LITERAL(173, 0, 131, 50, 199, 91, 123, 28)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__19_value),LEAN_SCALAR_PTR_LITERAL(97, 106, 189, 172, 252, 249, 116, 143)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__21_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__21;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__22_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "umod"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__22 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__22_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value),LEAN_SCALAR_PTR_LITERAL(173, 0, 131, 50, 199, 91, 123, 28)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__22_value),LEAN_SCALAR_PTR_LITERAL(185, 164, 216, 8, 44, 82, 23, 11)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__24_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__24;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0(uint8_t);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___boxed(lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__3_value),LEAN_SCALAR_PTR_LITERAL(173, 0, 131, 50, 199, 91, 123, 28)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__2;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__3;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "BVUnOp"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "not"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(76, 14, 123, 74, 130, 241, 190, 47)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(30, 170, 248, 163, 146, 14, 228, 74)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__3;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 11, .m_capacity = 11, .m_length = 10, .m_data = "rotateLeft"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__4_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(76, 14, 123, 74, 130, 241, 190, 47)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__4_value),LEAN_SCALAR_PTR_LITERAL(29, 116, 55, 155, 243, 43, 27, 136)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__6;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 12, .m_capacity = 12, .m_length = 11, .m_data = "rotateRight"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__7 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__7_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(76, 14, 123, 74, 130, 241, 190, 47)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__7_value),LEAN_SCALAR_PTR_LITERAL(112, 197, 123, 204, 93, 250, 252, 249)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__9;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 21, .m_capacity = 21, .m_length = 20, .m_data = "arithShiftRightConst"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__10 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__10_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(76, 14, 123, 74, 130, 241, 190, 47)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__10_value),LEAN_SCALAR_PTR_LITERAL(88, 95, 189, 240, 90, 71, 117, 208)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__12_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__12;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__13_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "reverse"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__13 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__13_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(76, 14, 123, 74, 130, 241, 190, 47)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__13_value),LEAN_SCALAR_PTR_LITERAL(84, 226, 239, 81, 45, 17, 252, 180)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__15_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__15;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__16_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "clz"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__16 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__16_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(76, 14, 123, 74, 130, 241, 190, 47)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__16_value),LEAN_SCALAR_PTR_LITERAL(221, 66, 219, 130, 52, 97, 84, 10)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__18_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__18;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__19_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "cpop"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__19 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__19_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(76, 14, 123, 74, 130, 241, 190, 47)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__19_value),LEAN_SCALAR_PTR_LITERAL(214, 119, 73, 246, 51, 241, 221, 59)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__21_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__21;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0(lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(76, 14, 123, 74, 130, 241, 190, 47)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__2;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__3;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "BVExpr"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "var"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__1_value),LEAN_SCALAR_PTR_LITERAL(158, 7, 174, 153, 9, 234, 93, 144)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__3;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "const"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__4_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__4_value),LEAN_SCALAR_PTR_LITERAL(213, 213, 79, 77, 131, 135, 136, 165)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__6;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "BitVec"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__7 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__7_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "ofNat"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__8_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__9_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__7_value),LEAN_SCALAR_PTR_LITERAL(108, 178, 58, 132, 143, 189, 222, 74)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__9_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__9_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__8_value),LEAN_SCALAR_PTR_LITERAL(101, 105, 192, 171, 214, 131, 43, 105)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__9 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__9_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__10_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__10;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__11_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "extract"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__11 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__11_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__11_value),LEAN_SCALAR_PTR_LITERAL(13, 22, 63, 119, 146, 191, 248, 8)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__13_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__13;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__14_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "bin"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__14 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__14_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__14_value),LEAN_SCALAR_PTR_LITERAL(47, 182, 211, 92, 78, 225, 70, 26)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__16_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__16;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__17_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "un"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__17 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__17_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__17_value),LEAN_SCALAR_PTR_LITERAL(42, 186, 200, 92, 180, 128, 216, 181)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__19_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__19;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__20_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "Eq"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__20 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__20_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__21_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "refl"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__21 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__21_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__22_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__20_value),LEAN_SCALAR_PTR_LITERAL(143, 37, 101, 248, 9, 246, 191, 223)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__22_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__22_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__21_value),LEAN_SCALAR_PTR_LITERAL(72, 6, 107, 181, 0, 125, 21, 187)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__22 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__22_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__23_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__23;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__24_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__24;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__25_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__25;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__26_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "Nat"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__26 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__26_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__27_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__26_value),LEAN_SCALAR_PTR_LITERAL(155, 221, 223, 104, 58, 13, 204, 158)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__27 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__27_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__28_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__28;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__29_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "append"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__29 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__29_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__29_value),LEAN_SCALAR_PTR_LITERAL(148, 222, 207, 10, 98, 174, 247, 204)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__31_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__31;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__32_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "replicate"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__32 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__32_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__32_value),LEAN_SCALAR_PTR_LITERAL(105, 148, 101, 98, 245, 160, 38, 159)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__34_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__34;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__35_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "shiftLeft"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__35 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__35_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__35_value),LEAN_SCALAR_PTR_LITERAL(197, 209, 242, 75, 214, 61, 180, 95)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__37_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__37;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__38_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 11, .m_capacity = 11, .m_length = 10, .m_data = "shiftRight"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__38 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__38_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__38_value),LEAN_SCALAR_PTR_LITERAL(71, 199, 243, 56, 253, 18, 242, 226)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__40_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__40;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__41_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 16, .m_capacity = 16, .m_length = 15, .m_data = "arithShiftRight"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__41 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__41_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__41_value),LEAN_SCALAR_PTR_LITERAL(103, 53, 88, 127, 221, 158, 175, 136)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__43_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__43;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___lam__0(lean_object*, lean_object*);
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__1;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr(lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "BVBinPred"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "eq"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(223, 174, 16, 156, 11, 3, 67, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(110, 124, 151, 202, 173, 235, 72, 127)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__3;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "ult"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__4_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(223, 174, 16, 156, 11, 3, 67, 199)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__4_value),LEAN_SCALAR_PTR_LITERAL(64, 63, 119, 185, 54, 210, 178, 92)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__6;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0(uint8_t);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___boxed(lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(223, 174, 16, 156, 11, 3, 67, 199)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__2;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__3;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Gate"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(217, 25, 243, 65, 109, 17, 59, 185)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__4_value),LEAN_SCALAR_PTR_LITERAL(191, 125, 195, 121, 220, 103, 239, 120)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__2;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(217, 25, 243, 65, 109, 17, 59, 185)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__10_value),LEAN_SCALAR_PTR_LITERAL(64, 67, 164, 147, 7, 85, 189, 57)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__4;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "beq"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__5_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(217, 25, 243, 65, 109, 17, 59, 185)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__5_value),LEAN_SCALAR_PTR_LITERAL(208, 118, 173, 79, 191, 184, 148, 203)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__7;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(217, 25, 243, 65, 109, 17, 59, 185)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__7_value),LEAN_SCALAR_PTR_LITERAL(37, 170, 13, 59, 155, 6, 165, 62)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__9;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0(uint8_t);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___boxed(lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(217, 25, 243, 65, 109, 17, 59, 185)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__2;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__3;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "BVPred"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(12, 253, 4, 25, 159, 236, 140, 252)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__14_value),LEAN_SCALAR_PTR_LITERAL(36, 213, 64, 10, 224, 53, 8, 130)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__2;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "getLsbD"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__3_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(12, 253, 4, 25, 159, 236, 140, 252)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__3_value),LEAN_SCALAR_PTR_LITERAL(233, 227, 220, 143, 67, 138, 133, 64)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__5;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go(lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(12, 253, 4, 25, 159, 236, 140, 252)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__2;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__3;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "BoolExpr"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "literal"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(124, 170, 215, 35, 43, 27, 202, 11)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__3;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__4_value),LEAN_SCALAR_PTR_LITERAL(244, 184, 12, 163, 38, 128, 83, 107)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__5;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Bool"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__6 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__6_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "false"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__7 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__7_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__8_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__6_value),LEAN_SCALAR_PTR_LITERAL(250, 44, 198, 216, 184, 195, 199, 178)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__8_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__7_value),LEAN_SCALAR_PTR_LITERAL(117, 151, 161, 190, 111, 237, 188, 218)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__8_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__9;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "true"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__10 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__10_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__11_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__6_value),LEAN_SCALAR_PTR_LITERAL(250, 44, 198, 216, 184, 195, 199, 178)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__11_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__11_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__10_value),LEAN_SCALAR_PTR_LITERAL(22, 245, 194, 28, 184, 9, 113, 128)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__11 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__11_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__12_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__12;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(244, 134, 245, 64, 53, 182, 217, 215)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__14_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__14;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__15_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "gate"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__15 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__15_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__15_value),LEAN_SCALAR_PTR_LITERAL(65, 48, 52, 229, 233, 139, 247, 222)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__17_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__17;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__18_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "ite"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__18 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__18_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__18_value),LEAN_SCALAR_PTR_LITERAL(222, 47, 143, 42, 137, 9, 112, 75)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__20_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__20;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___lam__0(lean_object*, lean_object*);
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__1;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4_spec__5___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__4___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4_spec__5(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVPred_evalsAtAtoms(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVPred_evalsAtAtoms___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_run_spec__0(size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_run_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__0;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__1;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__2;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_run(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___lam__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___lam__0___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__2(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__2___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__3(lean_object*, size_t, size_t, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__0(size_t, size_t, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__0___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atoms___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atoms___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atoms(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atoms___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "mk"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___lam__0___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___lam__0___closed__0_value;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 66, .m_capacity = 66, .m_length = 65, .m_data = "updateAtomsAssignment should only be called when there is an atom"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__0_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__1;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 13, .m_capacity = 13, .m_length = 12, .m_data = "PackedBitVec"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__2 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__2_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),LEAN_SCALAR_PTR_LITERAL(43, 53, 240, 176, 234, 207, 251, 199)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value_aux_3),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__2_value),LEAN_SCALAR_PTR_LITERAL(53, 26, 122, 246, 246, 235, 136, 91)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3_value;
static const lean_closure_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*6, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___lam__0, .m_arity = 7, .m_num_fixed = 6, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__0_value),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__2_value),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__0_value),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__2_value),((lean_object*)(((size_t)(0) << 1) | 1))} };
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__4 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__4_value;
static lean_once_cell_t l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__5;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atomsAssignment(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atomsAssignment___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__0;
static const lean_closure_object l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Core_instMonadCoreM___lam__0___boxed, .m_arity = 5, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__1 = (const lean_object*)&l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__1_value;
static const lean_closure_object l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Core_instMonadCoreM___lam__1___boxed, .m_arity = 7, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__2 = (const lean_object*)&l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__2_value;
static const lean_closure_object l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_instMonadMetaM___lam__0___boxed, .m_arity = 7, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__3 = (const lean_object*)&l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__3_value;
static const lean_closure_object l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_instMonadMetaM___lam__1___boxed, .m_arity = 9, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__4 = (const lean_object*)&l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__4_value;
LEAN_EXPORT lean_object* l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static double l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__0;
static const lean_string_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 1, .m_capacity = 1, .m_length = 0, .m_data = ""};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__1 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__1_value;
static const lean_array_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__2 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__2_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Meta"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "bv"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__0_value),LEAN_SCALAR_PTR_LITERAL(211, 174, 49, 251, 64, 24, 251, 1)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__2_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__2_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(194, 95, 140, 15, 16, 100, 236, 219)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__2_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__1_value),LEAN_SCALAR_PTR_LITERAL(139, 41, 106, 94, 234, 34, 111, 146)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__2_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trace"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__3_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__3_value),LEAN_SCALAR_PTR_LITERAL(212, 145, 141, 177, 67, 149, 127, 197)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__4_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__5;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 19, .m_capacity = 19, .m_length = 18, .m_data = "New atom of width "};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__6 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__6_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__7;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 14, .m_capacity = 14, .m_length = 13, .m_data = ", synthetic\? "};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__8_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__9;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = ": "};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__10 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__10_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__11_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__11;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__12_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 40, .m_capacity = 40, .m_length = 39, .m_data = "Lean.Meta.Tactic.BVDecide.Reflect.Basic"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__12 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__12_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__13_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 35, .m_capacity = 35, .m_length = 34, .m_data = "Lean.Meta.Tactic.BVDecide.M.lookup"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__13 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__13_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__14_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 58, .m_capacity = 58, .m_length = 57, .m_data = "The same atom occurs with different widths, this is a bug"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__14 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__14_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__15_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__15;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup(lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyTernaryProof(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_getHyps___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_getHyps___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_getHyps(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_getHyps___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_run___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_run___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_run(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_run___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l___private_Lean_Meta_Sym_ExprPtr_0__Lean_Meta_Sym_isSameExpr_unsafe__1___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__0_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Sym_hashPtrExpr_unsafe__1___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__1_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVPredCache(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVPredCache___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVLogicalCache(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVLogicalCache___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__6(void){
_start:
{
lean_object* v___x_12_; lean_object* v___x_13_; lean_object* v___x_14_; 
v___x_12_ = lean_box(0);
v___x_13_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__5));
v___x_14_ = l_Lean_mkConst(v___x_13_, v___x_12_);
return v___x_14_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__9(void){
_start:
{
lean_object* v___x_22_; lean_object* v___x_23_; lean_object* v___x_24_; 
v___x_22_ = lean_box(0);
v___x_23_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__8));
v___x_24_ = l_Lean_mkConst(v___x_23_, v___x_22_);
return v___x_24_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__12(void){
_start:
{
lean_object* v___x_32_; lean_object* v___x_33_; lean_object* v___x_34_; 
v___x_32_ = lean_box(0);
v___x_33_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__11));
v___x_34_ = l_Lean_mkConst(v___x_33_, v___x_32_);
return v___x_34_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__15(void){
_start:
{
lean_object* v___x_42_; lean_object* v___x_43_; lean_object* v___x_44_; 
v___x_42_ = lean_box(0);
v___x_43_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__14));
v___x_44_ = l_Lean_mkConst(v___x_43_, v___x_42_);
return v___x_44_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__18(void){
_start:
{
lean_object* v___x_52_; lean_object* v___x_53_; lean_object* v___x_54_; 
v___x_52_ = lean_box(0);
v___x_53_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__17));
v___x_54_ = l_Lean_mkConst(v___x_53_, v___x_52_);
return v___x_54_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__21(void){
_start:
{
lean_object* v___x_62_; lean_object* v___x_63_; lean_object* v___x_64_; 
v___x_62_ = lean_box(0);
v___x_63_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__20));
v___x_64_ = l_Lean_mkConst(v___x_63_, v___x_62_);
return v___x_64_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__24(void){
_start:
{
lean_object* v___x_72_; lean_object* v___x_73_; lean_object* v___x_74_; 
v___x_72_ = lean_box(0);
v___x_73_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__23));
v___x_74_ = l_Lean_mkConst(v___x_73_, v___x_72_);
return v___x_74_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0(uint8_t v_x_75_){
_start:
{
switch(v_x_75_)
{
case 0:
{
lean_object* v___x_76_; 
v___x_76_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__6, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__6);
return v___x_76_;
}
case 1:
{
lean_object* v___x_77_; 
v___x_77_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__9, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__9);
return v___x_77_;
}
case 2:
{
lean_object* v___x_78_; 
v___x_78_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__12, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__12_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__12);
return v___x_78_;
}
case 3:
{
lean_object* v___x_79_; 
v___x_79_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__15, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__15_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__15);
return v___x_79_;
}
case 4:
{
lean_object* v___x_80_; 
v___x_80_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__18, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__18_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__18);
return v___x_80_;
}
case 5:
{
lean_object* v___x_81_; 
v___x_81_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__21, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__21_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__21);
return v___x_81_;
}
default: 
{
lean_object* v___x_82_; 
v___x_82_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__24, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__24_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__24);
return v___x_82_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___boxed(lean_object* v_x_83_){
_start:
{
uint8_t v_x_boxed_84_; lean_object* v_res_85_; 
v_x_boxed_84_ = lean_unbox(v_x_83_);
v_res_85_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0(v_x_boxed_84_);
return v_res_85_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__2(void){
_start:
{
lean_object* v___x_92_; lean_object* v___x_93_; lean_object* v___x_94_; 
v___x_92_ = lean_box(0);
v___x_93_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__1));
v___x_94_ = l_Lean_mkConst(v___x_93_, v___x_92_);
return v___x_94_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__3(void){
_start:
{
lean_object* v___x_95_; lean_object* v___f_96_; lean_object* v___x_97_; 
v___x_95_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__2, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__2);
v___f_96_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__0));
v___x_97_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_97_, 0, v___f_96_);
lean_ctor_set(v___x_97_, 1, v___x_95_);
return v___x_97_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp(void){
_start:
{
lean_object* v___x_98_; 
v___x_98_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___closed__3);
return v___x_98_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__3(void){
_start:
{
lean_object* v___x_107_; lean_object* v___x_108_; lean_object* v___x_109_; 
v___x_107_ = lean_box(0);
v___x_108_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__2));
v___x_109_ = l_Lean_mkConst(v___x_108_, v___x_107_);
return v___x_109_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__6(void){
_start:
{
lean_object* v___x_117_; lean_object* v___x_118_; lean_object* v___x_119_; 
v___x_117_ = lean_box(0);
v___x_118_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__5));
v___x_119_ = l_Lean_mkConst(v___x_118_, v___x_117_);
return v___x_119_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__9(void){
_start:
{
lean_object* v___x_127_; lean_object* v___x_128_; lean_object* v___x_129_; 
v___x_127_ = lean_box(0);
v___x_128_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__8));
v___x_129_ = l_Lean_mkConst(v___x_128_, v___x_127_);
return v___x_129_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__12(void){
_start:
{
lean_object* v___x_137_; lean_object* v___x_138_; lean_object* v___x_139_; 
v___x_137_ = lean_box(0);
v___x_138_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__11));
v___x_139_ = l_Lean_mkConst(v___x_138_, v___x_137_);
return v___x_139_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__15(void){
_start:
{
lean_object* v___x_147_; lean_object* v___x_148_; lean_object* v___x_149_; 
v___x_147_ = lean_box(0);
v___x_148_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__14));
v___x_149_ = l_Lean_mkConst(v___x_148_, v___x_147_);
return v___x_149_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__18(void){
_start:
{
lean_object* v___x_157_; lean_object* v___x_158_; lean_object* v___x_159_; 
v___x_157_ = lean_box(0);
v___x_158_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__17));
v___x_159_ = l_Lean_mkConst(v___x_158_, v___x_157_);
return v___x_159_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__21(void){
_start:
{
lean_object* v___x_167_; lean_object* v___x_168_; lean_object* v___x_169_; 
v___x_167_ = lean_box(0);
v___x_168_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__20));
v___x_169_ = l_Lean_mkConst(v___x_168_, v___x_167_);
return v___x_169_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0(lean_object* v_x_170_){
_start:
{
switch(lean_obj_tag(v_x_170_))
{
case 0:
{
lean_object* v___x_171_; 
v___x_171_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__3);
return v___x_171_;
}
case 1:
{
lean_object* v_n_172_; lean_object* v___x_173_; lean_object* v___x_174_; lean_object* v___x_175_; 
v_n_172_ = lean_ctor_get(v_x_170_, 0);
lean_inc(v_n_172_);
lean_dec_ref_known(v_x_170_, 1);
v___x_173_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__6, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__6);
v___x_174_ = l_Lean_mkNatLit(v_n_172_);
v___x_175_ = l_Lean_Expr_app___override(v___x_173_, v___x_174_);
return v___x_175_;
}
case 2:
{
lean_object* v_n_176_; lean_object* v___x_177_; lean_object* v___x_178_; lean_object* v___x_179_; 
v_n_176_ = lean_ctor_get(v_x_170_, 0);
lean_inc(v_n_176_);
lean_dec_ref_known(v_x_170_, 1);
v___x_177_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__9, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__9);
v___x_178_ = l_Lean_mkNatLit(v_n_176_);
v___x_179_ = l_Lean_Expr_app___override(v___x_177_, v___x_178_);
return v___x_179_;
}
case 3:
{
lean_object* v_n_180_; lean_object* v___x_181_; lean_object* v___x_182_; lean_object* v___x_183_; 
v_n_180_ = lean_ctor_get(v_x_170_, 0);
lean_inc(v_n_180_);
lean_dec_ref_known(v_x_170_, 1);
v___x_181_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__12, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__12_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__12);
v___x_182_ = l_Lean_mkNatLit(v_n_180_);
v___x_183_ = l_Lean_Expr_app___override(v___x_181_, v___x_182_);
return v___x_183_;
}
case 4:
{
lean_object* v___x_184_; 
v___x_184_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__15, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__15_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__15);
return v___x_184_;
}
case 5:
{
lean_object* v___x_185_; 
v___x_185_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__18, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__18_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__18);
return v___x_185_;
}
default: 
{
lean_object* v___x_186_; 
v___x_186_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__21, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__21_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__21);
return v___x_186_;
}
}
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__2(void){
_start:
{
lean_object* v___x_193_; lean_object* v___x_194_; lean_object* v___x_195_; 
v___x_193_ = lean_box(0);
v___x_194_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__1));
v___x_195_ = l_Lean_mkConst(v___x_194_, v___x_193_);
return v___x_195_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__3(void){
_start:
{
lean_object* v___x_196_; lean_object* v___f_197_; lean_object* v___x_198_; 
v___x_196_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__2, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__2);
v___f_197_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__0));
v___x_198_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_198_, 0, v___f_197_);
lean_ctor_set(v___x_198_, 1, v___x_196_);
return v___x_198_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp(void){
_start:
{
lean_object* v___x_199_; 
v___x_199_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___closed__3);
return v___x_199_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__3(void){
_start:
{
lean_object* v___x_208_; lean_object* v___x_209_; lean_object* v___x_210_; 
v___x_208_ = lean_box(0);
v___x_209_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__2));
v___x_210_ = l_Lean_mkConst(v___x_209_, v___x_208_);
return v___x_210_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__6(void){
_start:
{
lean_object* v___x_218_; lean_object* v___x_219_; lean_object* v___x_220_; 
v___x_218_ = lean_box(0);
v___x_219_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__5));
v___x_220_ = l_Lean_mkConst(v___x_219_, v___x_218_);
return v___x_220_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__10(void){
_start:
{
lean_object* v___x_226_; lean_object* v___x_227_; lean_object* v___x_228_; 
v___x_226_ = lean_box(0);
v___x_227_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__9));
v___x_228_ = l_Lean_Expr_const___override(v___x_227_, v___x_226_);
return v___x_228_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__13(void){
_start:
{
lean_object* v___x_236_; lean_object* v___x_237_; lean_object* v___x_238_; 
v___x_236_ = lean_box(0);
v___x_237_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__12));
v___x_238_ = l_Lean_mkConst(v___x_237_, v___x_236_);
return v___x_238_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__16(void){
_start:
{
lean_object* v___x_246_; lean_object* v___x_247_; lean_object* v___x_248_; 
v___x_246_ = lean_box(0);
v___x_247_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__15));
v___x_248_ = l_Lean_mkConst(v___x_247_, v___x_246_);
return v___x_248_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__19(void){
_start:
{
lean_object* v___x_256_; lean_object* v___x_257_; lean_object* v___x_258_; 
v___x_256_ = lean_box(0);
v___x_257_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__18));
v___x_258_ = l_Lean_mkConst(v___x_257_, v___x_256_);
return v___x_258_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__23(void){
_start:
{
lean_object* v___x_264_; lean_object* v___x_265_; 
v___x_264_ = lean_unsigned_to_nat(1u);
v___x_265_ = l_Lean_Level_ofNat(v___x_264_);
return v___x_265_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__24(void){
_start:
{
lean_object* v___x_266_; lean_object* v___x_267_; lean_object* v___x_268_; 
v___x_266_ = lean_box(0);
v___x_267_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__23, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__23_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__23);
v___x_268_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v___x_268_, 0, v___x_267_);
lean_ctor_set(v___x_268_, 1, v___x_266_);
return v___x_268_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__25(void){
_start:
{
lean_object* v___x_269_; lean_object* v___x_270_; lean_object* v___x_271_; 
v___x_269_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__24, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__24_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__24);
v___x_270_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__22));
v___x_271_ = l_Lean_mkConst(v___x_270_, v___x_269_);
return v___x_271_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__28(void){
_start:
{
lean_object* v___x_275_; lean_object* v___x_276_; lean_object* v___x_277_; 
v___x_275_ = lean_box(0);
v___x_276_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__27));
v___x_277_ = l_Lean_mkConst(v___x_276_, v___x_275_);
return v___x_277_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__31(void){
_start:
{
lean_object* v___x_285_; lean_object* v___x_286_; lean_object* v___x_287_; 
v___x_285_ = lean_box(0);
v___x_286_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__30));
v___x_287_ = l_Lean_mkConst(v___x_286_, v___x_285_);
return v___x_287_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__34(void){
_start:
{
lean_object* v___x_295_; lean_object* v___x_296_; lean_object* v___x_297_; 
v___x_295_ = lean_box(0);
v___x_296_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__33));
v___x_297_ = l_Lean_mkConst(v___x_296_, v___x_295_);
return v___x_297_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__37(void){
_start:
{
lean_object* v___x_305_; lean_object* v___x_306_; lean_object* v___x_307_; 
v___x_305_ = lean_box(0);
v___x_306_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__36));
v___x_307_ = l_Lean_mkConst(v___x_306_, v___x_305_);
return v___x_307_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__40(void){
_start:
{
lean_object* v___x_315_; lean_object* v___x_316_; lean_object* v___x_317_; 
v___x_315_ = lean_box(0);
v___x_316_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__39));
v___x_317_ = l_Lean_mkConst(v___x_316_, v___x_315_);
return v___x_317_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__43(void){
_start:
{
lean_object* v___x_325_; lean_object* v___x_326_; lean_object* v___x_327_; 
v___x_325_ = lean_box(0);
v___x_326_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__42));
v___x_327_ = l_Lean_mkConst(v___x_326_, v___x_325_);
return v___x_327_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(lean_object* v_w_328_, lean_object* v_a_329_){
_start:
{
switch(lean_obj_tag(v_a_329_))
{
case 0:
{
lean_object* v_idx_330_; lean_object* v___x_331_; lean_object* v___x_332_; lean_object* v___x_333_; lean_object* v___x_334_; 
v_idx_330_ = lean_ctor_get(v_a_329_, 1);
lean_inc(v_idx_330_);
lean_dec_ref_known(v_a_329_, 2);
v___x_331_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__3);
v___x_332_ = l_Lean_mkNatLit(v_w_328_);
v___x_333_ = l_Lean_mkNatLit(v_idx_330_);
v___x_334_ = l_Lean_mkAppB(v___x_331_, v___x_332_, v___x_333_);
return v___x_334_;
}
case 1:
{
lean_object* v_val_335_; lean_object* v___x_336_; lean_object* v___x_337_; lean_object* v___x_338_; lean_object* v___x_339_; lean_object* v___x_340_; lean_object* v___x_341_; 
v_val_335_ = lean_ctor_get(v_a_329_, 1);
lean_inc(v_val_335_);
lean_dec_ref_known(v_a_329_, 2);
v___x_336_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__6, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__6);
v___x_337_ = l_Lean_mkNatLit(v_w_328_);
v___x_338_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__10, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__10_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__10);
v___x_339_ = l_Lean_mkNatLit(v_val_335_);
lean_inc_ref(v___x_337_);
v___x_340_ = l_Lean_mkAppB(v___x_338_, v___x_337_, v___x_339_);
v___x_341_ = l_Lean_mkAppB(v___x_336_, v___x_337_, v___x_340_);
return v___x_341_;
}
case 2:
{
lean_object* v_w_342_; lean_object* v_start_343_; lean_object* v_expr_344_; lean_object* v___x_345_; lean_object* v___x_346_; lean_object* v___x_347_; lean_object* v___x_348_; lean_object* v___x_349_; lean_object* v___x_350_; 
v_w_342_ = lean_ctor_get(v_a_329_, 0);
lean_inc_n(v_w_342_, 2);
v_start_343_ = lean_ctor_get(v_a_329_, 1);
lean_inc(v_start_343_);
v_expr_344_ = lean_ctor_get(v_a_329_, 3);
lean_inc_ref(v_expr_344_);
lean_dec_ref_known(v_a_329_, 4);
v___x_345_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__13, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__13_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__13);
v___x_346_ = l_Lean_mkNatLit(v_w_342_);
v___x_347_ = l_Lean_mkNatLit(v_start_343_);
v___x_348_ = l_Lean_mkNatLit(v_w_328_);
v___x_349_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_342_, v_expr_344_);
v___x_350_ = l_Lean_mkApp4(v___x_345_, v___x_346_, v___x_347_, v___x_348_, v___x_349_);
return v___x_350_;
}
case 3:
{
lean_object* v_lhs_351_; uint8_t v_op_352_; lean_object* v_rhs_353_; lean_object* v___x_354_; lean_object* v___x_355_; lean_object* v___x_356_; lean_object* v___y_358_; 
v_lhs_351_ = lean_ctor_get(v_a_329_, 1);
lean_inc_ref(v_lhs_351_);
v_op_352_ = lean_ctor_get_uint8(v_a_329_, sizeof(void*)*3 + 8);
v_rhs_353_ = lean_ctor_get(v_a_329_, 2);
lean_inc_ref(v_rhs_353_);
lean_dec_ref_known(v_a_329_, 3);
v___x_354_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__16, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__16_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__16);
lean_inc_n(v_w_328_, 2);
v___x_355_ = l_Lean_mkNatLit(v_w_328_);
v___x_356_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_328_, v_lhs_351_);
switch(v_op_352_)
{
case 0:
{
lean_object* v___x_361_; 
v___x_361_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__6, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__6);
v___y_358_ = v___x_361_;
goto v___jp_357_;
}
case 1:
{
lean_object* v___x_362_; 
v___x_362_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__9, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__9);
v___y_358_ = v___x_362_;
goto v___jp_357_;
}
case 2:
{
lean_object* v___x_363_; 
v___x_363_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__12, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__12_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__12);
v___y_358_ = v___x_363_;
goto v___jp_357_;
}
case 3:
{
lean_object* v___x_364_; 
v___x_364_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__15, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__15_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__15);
v___y_358_ = v___x_364_;
goto v___jp_357_;
}
case 4:
{
lean_object* v___x_365_; 
v___x_365_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__18, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__18_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__18);
v___y_358_ = v___x_365_;
goto v___jp_357_;
}
case 5:
{
lean_object* v___x_366_; 
v___x_366_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__21, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__21_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__21);
v___y_358_ = v___x_366_;
goto v___jp_357_;
}
default: 
{
lean_object* v___x_367_; 
v___x_367_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__24, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__24_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp___lam__0___closed__24);
v___y_358_ = v___x_367_;
goto v___jp_357_;
}
}
v___jp_357_:
{
lean_object* v___x_359_; lean_object* v___x_360_; 
v___x_359_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_328_, v_rhs_353_);
lean_inc_ref(v___y_358_);
v___x_360_ = l_Lean_mkApp4(v___x_354_, v___x_355_, v___x_356_, v___y_358_, v___x_359_);
return v___x_360_;
}
}
case 4:
{
lean_object* v_op_368_; lean_object* v_operand_369_; lean_object* v___x_370_; lean_object* v___x_371_; lean_object* v___y_373_; 
v_op_368_ = lean_ctor_get(v_a_329_, 1);
lean_inc(v_op_368_);
v_operand_369_ = lean_ctor_get(v_a_329_, 2);
lean_inc_ref(v_operand_369_);
lean_dec_ref_known(v_a_329_, 3);
v___x_370_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__19, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__19_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__19);
lean_inc(v_w_328_);
v___x_371_ = l_Lean_mkNatLit(v_w_328_);
switch(lean_obj_tag(v_op_368_))
{
case 0:
{
lean_object* v___x_376_; 
v___x_376_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__3);
v___y_373_ = v___x_376_;
goto v___jp_372_;
}
case 1:
{
lean_object* v_n_377_; lean_object* v___x_378_; lean_object* v___x_379_; lean_object* v___x_380_; 
v_n_377_ = lean_ctor_get(v_op_368_, 0);
lean_inc(v_n_377_);
lean_dec_ref_known(v_op_368_, 1);
v___x_378_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__6, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__6);
v___x_379_ = l_Lean_mkNatLit(v_n_377_);
v___x_380_ = l_Lean_Expr_app___override(v___x_378_, v___x_379_);
v___y_373_ = v___x_380_;
goto v___jp_372_;
}
case 2:
{
lean_object* v_n_381_; lean_object* v___x_382_; lean_object* v___x_383_; lean_object* v___x_384_; 
v_n_381_ = lean_ctor_get(v_op_368_, 0);
lean_inc(v_n_381_);
lean_dec_ref_known(v_op_368_, 1);
v___x_382_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__9, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__9);
v___x_383_ = l_Lean_mkNatLit(v_n_381_);
v___x_384_ = l_Lean_Expr_app___override(v___x_382_, v___x_383_);
v___y_373_ = v___x_384_;
goto v___jp_372_;
}
case 3:
{
lean_object* v_n_385_; lean_object* v___x_386_; lean_object* v___x_387_; lean_object* v___x_388_; 
v_n_385_ = lean_ctor_get(v_op_368_, 0);
lean_inc(v_n_385_);
lean_dec_ref_known(v_op_368_, 1);
v___x_386_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__12, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__12_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__12);
v___x_387_ = l_Lean_mkNatLit(v_n_385_);
v___x_388_ = l_Lean_Expr_app___override(v___x_386_, v___x_387_);
v___y_373_ = v___x_388_;
goto v___jp_372_;
}
case 4:
{
lean_object* v___x_389_; 
v___x_389_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__15, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__15_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__15);
v___y_373_ = v___x_389_;
goto v___jp_372_;
}
case 5:
{
lean_object* v___x_390_; 
v___x_390_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__18, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__18_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__18);
v___y_373_ = v___x_390_;
goto v___jp_372_;
}
default: 
{
lean_object* v___x_391_; 
v___x_391_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__21, &l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__21_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp___lam__0___closed__21);
v___y_373_ = v___x_391_;
goto v___jp_372_;
}
}
v___jp_372_:
{
lean_object* v___x_374_; lean_object* v___x_375_; 
v___x_374_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_328_, v_operand_369_);
v___x_375_ = l_Lean_mkApp3(v___x_370_, v___x_371_, v___y_373_, v___x_374_);
return v___x_375_;
}
}
case 5:
{
lean_object* v_l_392_; lean_object* v_r_393_; lean_object* v_lhs_394_; lean_object* v_rhs_395_; lean_object* v_wExpr_396_; lean_object* v___x_397_; lean_object* v___x_398_; lean_object* v_proof_399_; lean_object* v___x_400_; lean_object* v___x_401_; lean_object* v___x_402_; lean_object* v___x_403_; lean_object* v___x_404_; lean_object* v___x_405_; 
v_l_392_ = lean_ctor_get(v_a_329_, 0);
lean_inc_n(v_l_392_, 2);
v_r_393_ = lean_ctor_get(v_a_329_, 1);
lean_inc_n(v_r_393_, 2);
v_lhs_394_ = lean_ctor_get(v_a_329_, 3);
lean_inc_ref(v_lhs_394_);
v_rhs_395_ = lean_ctor_get(v_a_329_, 4);
lean_inc_ref(v_rhs_395_);
lean_dec_ref_known(v_a_329_, 5);
v_wExpr_396_ = l_Lean_mkNatLit(v_w_328_);
v___x_397_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__25, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__25_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__25);
v___x_398_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__28, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__28_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__28);
lean_inc_ref(v_wExpr_396_);
v_proof_399_ = l_Lean_mkAppB(v___x_397_, v___x_398_, v_wExpr_396_);
v___x_400_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__31, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__31_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__31);
v___x_401_ = l_Lean_mkNatLit(v_l_392_);
v___x_402_ = l_Lean_mkNatLit(v_r_393_);
v___x_403_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_l_392_, v_lhs_394_);
v___x_404_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_r_393_, v_rhs_395_);
v___x_405_ = l_Lean_mkApp6(v___x_400_, v___x_401_, v___x_402_, v_wExpr_396_, v___x_403_, v___x_404_, v_proof_399_);
return v___x_405_;
}
case 6:
{
lean_object* v_w_406_; lean_object* v_n_407_; lean_object* v_expr_408_; lean_object* v_newWExpr_409_; lean_object* v___x_410_; lean_object* v___x_411_; lean_object* v_proof_412_; lean_object* v___x_413_; lean_object* v___x_414_; lean_object* v___x_415_; lean_object* v___x_416_; lean_object* v___x_417_; 
v_w_406_ = lean_ctor_get(v_a_329_, 0);
lean_inc_n(v_w_406_, 2);
v_n_407_ = lean_ctor_get(v_a_329_, 2);
lean_inc(v_n_407_);
v_expr_408_ = lean_ctor_get(v_a_329_, 3);
lean_inc_ref(v_expr_408_);
lean_dec_ref_known(v_a_329_, 4);
v_newWExpr_409_ = l_Lean_mkNatLit(v_w_328_);
v___x_410_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__25, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__25_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__25);
v___x_411_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__28, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__28_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__28);
lean_inc_ref(v_newWExpr_409_);
v_proof_412_ = l_Lean_mkAppB(v___x_410_, v___x_411_, v_newWExpr_409_);
v___x_413_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__34, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__34_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__34);
v___x_414_ = l_Lean_mkNatLit(v_w_406_);
v___x_415_ = l_Lean_mkNatLit(v_n_407_);
v___x_416_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_406_, v_expr_408_);
v___x_417_ = l_Lean_mkApp5(v___x_413_, v___x_414_, v_newWExpr_409_, v___x_415_, v___x_416_, v_proof_412_);
return v___x_417_;
}
case 7:
{
lean_object* v_n_418_; lean_object* v_lhs_419_; lean_object* v_rhs_420_; lean_object* v___x_421_; lean_object* v___x_422_; lean_object* v___x_423_; lean_object* v___x_424_; lean_object* v___x_425_; lean_object* v___x_426_; 
v_n_418_ = lean_ctor_get(v_a_329_, 1);
lean_inc_n(v_n_418_, 2);
v_lhs_419_ = lean_ctor_get(v_a_329_, 2);
lean_inc_ref(v_lhs_419_);
v_rhs_420_ = lean_ctor_get(v_a_329_, 3);
lean_inc_ref(v_rhs_420_);
lean_dec_ref_known(v_a_329_, 4);
v___x_421_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__37, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__37_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__37);
lean_inc(v_w_328_);
v___x_422_ = l_Lean_mkNatLit(v_w_328_);
v___x_423_ = l_Lean_mkNatLit(v_n_418_);
v___x_424_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_328_, v_lhs_419_);
v___x_425_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_n_418_, v_rhs_420_);
v___x_426_ = l_Lean_mkApp4(v___x_421_, v___x_422_, v___x_423_, v___x_424_, v___x_425_);
return v___x_426_;
}
case 8:
{
lean_object* v_n_427_; lean_object* v_lhs_428_; lean_object* v_rhs_429_; lean_object* v___x_430_; lean_object* v___x_431_; lean_object* v___x_432_; lean_object* v___x_433_; lean_object* v___x_434_; lean_object* v___x_435_; 
v_n_427_ = lean_ctor_get(v_a_329_, 1);
lean_inc_n(v_n_427_, 2);
v_lhs_428_ = lean_ctor_get(v_a_329_, 2);
lean_inc_ref(v_lhs_428_);
v_rhs_429_ = lean_ctor_get(v_a_329_, 3);
lean_inc_ref(v_rhs_429_);
lean_dec_ref_known(v_a_329_, 4);
v___x_430_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__40, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__40_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__40);
lean_inc(v_w_328_);
v___x_431_ = l_Lean_mkNatLit(v_w_328_);
v___x_432_ = l_Lean_mkNatLit(v_n_427_);
v___x_433_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_328_, v_lhs_428_);
v___x_434_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_n_427_, v_rhs_429_);
v___x_435_ = l_Lean_mkApp4(v___x_430_, v___x_431_, v___x_432_, v___x_433_, v___x_434_);
return v___x_435_;
}
default: 
{
lean_object* v_n_436_; lean_object* v_lhs_437_; lean_object* v_rhs_438_; lean_object* v___x_439_; lean_object* v___x_440_; lean_object* v___x_441_; lean_object* v___x_442_; lean_object* v___x_443_; lean_object* v___x_444_; 
v_n_436_ = lean_ctor_get(v_a_329_, 1);
lean_inc_n(v_n_436_, 2);
v_lhs_437_ = lean_ctor_get(v_a_329_, 2);
lean_inc_ref(v_lhs_437_);
v_rhs_438_ = lean_ctor_get(v_a_329_, 3);
lean_inc_ref(v_rhs_438_);
lean_dec_ref_known(v_a_329_, 4);
v___x_439_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__43, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__43_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go___closed__43);
lean_inc(v_w_328_);
v___x_440_ = l_Lean_mkNatLit(v_w_328_);
v___x_441_ = l_Lean_mkNatLit(v_n_436_);
v___x_442_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_328_, v_lhs_437_);
v___x_443_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_n_436_, v_rhs_438_);
v___x_444_ = l_Lean_mkApp4(v___x_439_, v___x_440_, v___x_441_, v___x_442_, v___x_443_);
return v___x_444_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___lam__0(lean_object* v_w_445_, lean_object* v_x_446_){
_start:
{
lean_object* v___x_447_; 
v___x_447_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_445_, v_x_446_);
return v___x_447_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__1(void){
_start:
{
lean_object* v___x_453_; lean_object* v___x_454_; lean_object* v___x_455_; 
v___x_453_ = lean_box(0);
v___x_454_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__0));
v___x_455_ = l_Lean_mkConst(v___x_454_, v___x_453_);
return v___x_455_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr(lean_object* v_w_456_){
_start:
{
lean_object* v___f_457_; lean_object* v___x_458_; lean_object* v___x_459_; lean_object* v___x_460_; lean_object* v___x_461_; 
lean_inc(v_w_456_);
v___f_457_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___lam__0), 2, 1);
lean_closure_set(v___f_457_, 0, v_w_456_);
v___x_458_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__1, &l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr___closed__1);
v___x_459_ = l_Lean_mkNatLit(v_w_456_);
v___x_460_ = l_Lean_Expr_app___override(v___x_458_, v___x_459_);
v___x_461_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_461_, 0, v___f_457_);
lean_ctor_set(v___x_461_, 1, v___x_460_);
return v___x_461_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__3(void){
_start:
{
lean_object* v___x_470_; lean_object* v___x_471_; lean_object* v___x_472_; 
v___x_470_ = lean_box(0);
v___x_471_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__2));
v___x_472_ = l_Lean_mkConst(v___x_471_, v___x_470_);
return v___x_472_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__6(void){
_start:
{
lean_object* v___x_480_; lean_object* v___x_481_; lean_object* v___x_482_; 
v___x_480_ = lean_box(0);
v___x_481_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__5));
v___x_482_ = l_Lean_mkConst(v___x_481_, v___x_480_);
return v___x_482_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0(uint8_t v_x_483_){
_start:
{
if (v_x_483_ == 0)
{
lean_object* v___x_484_; 
v___x_484_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__3);
return v___x_484_;
}
else
{
lean_object* v___x_485_; 
v___x_485_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__6, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__6);
return v___x_485_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___boxed(lean_object* v_x_486_){
_start:
{
uint8_t v_x_boxed_487_; lean_object* v_res_488_; 
v_x_boxed_487_ = lean_unbox(v_x_486_);
v_res_488_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0(v_x_boxed_487_);
return v_res_488_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__2(void){
_start:
{
lean_object* v___x_495_; lean_object* v___x_496_; lean_object* v___x_497_; 
v___x_495_ = lean_box(0);
v___x_496_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__1));
v___x_497_ = l_Lean_mkConst(v___x_496_, v___x_495_);
return v___x_497_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__3(void){
_start:
{
lean_object* v___x_498_; lean_object* v___f_499_; lean_object* v___x_500_; 
v___x_498_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__2, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__2);
v___f_499_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__0));
v___x_500_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_500_, 0, v___f_499_);
lean_ctor_set(v___x_500_, 1, v___x_498_);
return v___x_500_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred(void){
_start:
{
lean_object* v___x_501_; 
v___x_501_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___closed__3);
return v___x_501_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__2(void){
_start:
{
lean_object* v___x_509_; lean_object* v___x_510_; lean_object* v___x_511_; 
v___x_509_ = lean_box(0);
v___x_510_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__1));
v___x_511_ = l_Lean_mkConst(v___x_510_, v___x_509_);
return v___x_511_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__4(void){
_start:
{
lean_object* v___x_518_; lean_object* v___x_519_; lean_object* v___x_520_; 
v___x_518_ = lean_box(0);
v___x_519_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__3));
v___x_520_ = l_Lean_mkConst(v___x_519_, v___x_518_);
return v___x_520_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__7(void){
_start:
{
lean_object* v___x_528_; lean_object* v___x_529_; lean_object* v___x_530_; 
v___x_528_ = lean_box(0);
v___x_529_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__6));
v___x_530_ = l_Lean_mkConst(v___x_529_, v___x_528_);
return v___x_530_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__9(void){
_start:
{
lean_object* v___x_537_; lean_object* v___x_538_; lean_object* v___x_539_; 
v___x_537_ = lean_box(0);
v___x_538_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__8));
v___x_539_ = l_Lean_mkConst(v___x_538_, v___x_537_);
return v___x_539_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0(uint8_t v_x_540_){
_start:
{
switch(v_x_540_)
{
case 0:
{
lean_object* v___x_541_; 
v___x_541_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__2, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__2);
return v___x_541_;
}
case 1:
{
lean_object* v___x_542_; 
v___x_542_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__4, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__4_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__4);
return v___x_542_;
}
case 2:
{
lean_object* v___x_543_; 
v___x_543_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__7, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__7);
return v___x_543_;
}
default: 
{
lean_object* v___x_544_; 
v___x_544_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__9, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__9);
return v___x_544_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___boxed(lean_object* v_x_545_){
_start:
{
uint8_t v_x_boxed_546_; lean_object* v_res_547_; 
v_x_boxed_546_ = lean_unbox(v_x_545_);
v_res_547_ = l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0(v_x_boxed_546_);
return v_res_547_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__2(void){
_start:
{
lean_object* v___x_554_; lean_object* v___x_555_; lean_object* v___x_556_; 
v___x_554_ = lean_box(0);
v___x_555_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__1));
v___x_556_ = l_Lean_mkConst(v___x_555_, v___x_554_);
return v___x_556_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__3(void){
_start:
{
lean_object* v___x_557_; lean_object* v___f_558_; lean_object* v___x_559_; 
v___x_557_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__2, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__2);
v___f_558_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__0));
v___x_559_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_559_, 0, v___f_558_);
lean_ctor_set(v___x_559_, 1, v___x_557_);
return v___x_559_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate(void){
_start:
{
lean_object* v___x_560_; 
v___x_560_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___closed__3);
return v___x_560_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__2(void){
_start:
{
lean_object* v___x_568_; lean_object* v___x_569_; lean_object* v___x_570_; 
v___x_568_ = lean_box(0);
v___x_569_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__1));
v___x_570_ = l_Lean_mkConst(v___x_569_, v___x_568_);
return v___x_570_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__5(void){
_start:
{
lean_object* v___x_578_; lean_object* v___x_579_; lean_object* v___x_580_; 
v___x_578_ = lean_box(0);
v___x_579_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__4));
v___x_580_ = l_Lean_mkConst(v___x_579_, v___x_578_);
return v___x_580_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go(lean_object* v_a_581_){
_start:
{
if (lean_obj_tag(v_a_581_) == 0)
{
lean_object* v_w_582_; lean_object* v_lhs_583_; uint8_t v_op_584_; lean_object* v_rhs_585_; lean_object* v___x_586_; lean_object* v___x_587_; lean_object* v___x_588_; lean_object* v___y_590_; 
v_w_582_ = lean_ctor_get(v_a_581_, 0);
lean_inc_n(v_w_582_, 3);
v_lhs_583_ = lean_ctor_get(v_a_581_, 1);
lean_inc_ref(v_lhs_583_);
v_op_584_ = lean_ctor_get_uint8(v_a_581_, sizeof(void*)*3);
v_rhs_585_ = lean_ctor_get(v_a_581_, 2);
lean_inc_ref(v_rhs_585_);
lean_dec_ref_known(v_a_581_, 3);
v___x_586_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__2, &l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__2);
v___x_587_ = l_Lean_mkNatLit(v_w_582_);
v___x_588_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_582_, v_lhs_583_);
if (v_op_584_ == 0)
{
lean_object* v___x_593_; 
v___x_593_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__3);
v___y_590_ = v___x_593_;
goto v___jp_589_;
}
else
{
lean_object* v___x_594_; 
v___x_594_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__6, &l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred___lam__0___closed__6);
v___y_590_ = v___x_594_;
goto v___jp_589_;
}
v___jp_589_:
{
lean_object* v___x_591_; lean_object* v___x_592_; 
v___x_591_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_582_, v_rhs_585_);
lean_inc_ref(v___y_590_);
v___x_592_ = l_Lean_mkApp4(v___x_586_, v___x_587_, v___x_588_, v___y_590_, v___x_591_);
return v___x_592_;
}
}
else
{
lean_object* v_w_595_; lean_object* v_expr_596_; lean_object* v_idx_597_; lean_object* v___x_598_; lean_object* v___x_599_; lean_object* v___x_600_; lean_object* v___x_601_; lean_object* v___x_602_; 
v_w_595_ = lean_ctor_get(v_a_581_, 0);
lean_inc_n(v_w_595_, 2);
v_expr_596_ = lean_ctor_get(v_a_581_, 1);
lean_inc_ref(v_expr_596_);
v_idx_597_ = lean_ctor_get(v_a_581_, 2);
lean_inc(v_idx_597_);
lean_dec_ref_known(v_a_581_, 3);
v___x_598_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__5, &l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__5_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred_go___closed__5);
v___x_599_ = l_Lean_mkNatLit(v_w_595_);
v___x_600_ = l_Lean_Meta_Tactic_BVDecide_instToExprBVExpr_go(v_w_595_, v_expr_596_);
v___x_601_ = l_Lean_mkNatLit(v_idx_597_);
v___x_602_ = l_Lean_mkApp3(v___x_598_, v___x_599_, v___x_600_, v___x_601_);
return v___x_602_;
}
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__2(void){
_start:
{
lean_object* v___x_609_; lean_object* v___x_610_; lean_object* v___x_611_; 
v___x_609_ = lean_box(0);
v___x_610_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__1));
v___x_611_ = l_Lean_mkConst(v___x_610_, v___x_609_);
return v___x_611_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__3(void){
_start:
{
lean_object* v___x_612_; lean_object* v___f_613_; lean_object* v___x_614_; 
v___x_612_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__2, &l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__2);
v___f_613_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__0));
v___x_614_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_614_, 0, v___f_613_);
lean_ctor_set(v___x_614_, 1, v___x_612_);
return v___x_614_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred(void){
_start:
{
lean_object* v___x_615_; 
v___x_615_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred___closed__3);
return v___x_615_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__3(void){
_start:
{
lean_object* v___x_624_; lean_object* v___x_625_; lean_object* v___x_626_; 
v___x_624_ = lean_box(0);
v___x_625_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__2));
v___x_626_ = l_Lean_mkConst(v___x_625_, v___x_624_);
return v___x_626_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__5(void){
_start:
{
lean_object* v___x_633_; lean_object* v___x_634_; lean_object* v___x_635_; 
v___x_633_ = lean_box(0);
v___x_634_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__4));
v___x_635_ = l_Lean_mkConst(v___x_634_, v___x_633_);
return v___x_635_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__9(void){
_start:
{
lean_object* v___x_641_; lean_object* v___x_642_; lean_object* v___x_643_; 
v___x_641_ = lean_box(0);
v___x_642_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__8));
v___x_643_ = l_Lean_mkConst(v___x_642_, v___x_641_);
return v___x_643_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__12(void){
_start:
{
lean_object* v___x_648_; lean_object* v___x_649_; lean_object* v___x_650_; 
v___x_648_ = lean_box(0);
v___x_649_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__11));
v___x_650_ = l_Lean_mkConst(v___x_649_, v___x_648_);
return v___x_650_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__14(void){
_start:
{
lean_object* v___x_657_; lean_object* v___x_658_; lean_object* v___x_659_; 
v___x_657_ = lean_box(0);
v___x_658_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__13));
v___x_659_ = l_Lean_mkConst(v___x_658_, v___x_657_);
return v___x_659_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__17(void){
_start:
{
lean_object* v___x_667_; lean_object* v___x_668_; lean_object* v___x_669_; 
v___x_667_ = lean_box(0);
v___x_668_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__16));
v___x_669_ = l_Lean_mkConst(v___x_668_, v___x_667_);
return v___x_669_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__20(void){
_start:
{
lean_object* v___x_677_; lean_object* v___x_678_; lean_object* v___x_679_; 
v___x_677_ = lean_box(0);
v___x_678_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__19));
v___x_679_ = l_Lean_mkConst(v___x_678_, v___x_677_);
return v___x_679_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(lean_object* v_inst_680_, lean_object* v_a_681_){
_start:
{
switch(lean_obj_tag(v_a_681_))
{
case 0:
{
lean_object* v_a_682_; lean_object* v_toExpr_683_; lean_object* v_toTypeExpr_684_; lean_object* v___x_685_; lean_object* v___x_686_; lean_object* v___x_687_; 
v_a_682_ = lean_ctor_get(v_a_681_, 0);
lean_inc(v_a_682_);
lean_dec_ref_known(v_a_681_, 1);
v_toExpr_683_ = lean_ctor_get(v_inst_680_, 0);
lean_inc_ref(v_toExpr_683_);
v_toTypeExpr_684_ = lean_ctor_get(v_inst_680_, 1);
lean_inc_ref(v_toTypeExpr_684_);
lean_dec_ref(v_inst_680_);
v___x_685_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__3, &l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__3);
v___x_686_ = lean_apply_1(v_toExpr_683_, v_a_682_);
v___x_687_ = l_Lean_mkAppB(v___x_685_, v_toTypeExpr_684_, v___x_686_);
return v___x_687_;
}
case 1:
{
uint8_t v_a_688_; lean_object* v_toTypeExpr_689_; lean_object* v___x_690_; 
v_a_688_ = lean_ctor_get_uint8(v_a_681_, 0);
lean_dec_ref_known(v_a_681_, 0);
v_toTypeExpr_689_ = lean_ctor_get(v_inst_680_, 1);
lean_inc_ref(v_toTypeExpr_689_);
lean_dec_ref(v_inst_680_);
v___x_690_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__5, &l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__5_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__5);
if (v_a_688_ == 0)
{
lean_object* v___x_691_; lean_object* v___x_692_; 
v___x_691_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__9, &l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__9);
v___x_692_ = l_Lean_mkAppB(v___x_690_, v_toTypeExpr_689_, v___x_691_);
return v___x_692_;
}
else
{
lean_object* v___x_693_; lean_object* v___x_694_; 
v___x_693_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__12, &l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__12_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__12);
v___x_694_ = l_Lean_mkAppB(v___x_690_, v_toTypeExpr_689_, v___x_693_);
return v___x_694_;
}
}
case 2:
{
lean_object* v_a_695_; lean_object* v_toTypeExpr_696_; lean_object* v___x_697_; lean_object* v___x_698_; lean_object* v___x_699_; 
v_a_695_ = lean_ctor_get(v_a_681_, 0);
lean_inc_ref(v_a_695_);
lean_dec_ref_known(v_a_681_, 1);
v_toTypeExpr_696_ = lean_ctor_get(v_inst_680_, 1);
lean_inc_ref(v_toTypeExpr_696_);
v___x_697_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__14, &l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__14_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__14);
v___x_698_ = l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(v_inst_680_, v_a_695_);
v___x_699_ = l_Lean_mkAppB(v___x_697_, v_toTypeExpr_696_, v___x_698_);
return v___x_699_;
}
case 3:
{
uint8_t v_a_700_; lean_object* v_a_701_; lean_object* v_a_702_; lean_object* v_toTypeExpr_703_; lean_object* v___x_704_; lean_object* v___y_706_; 
v_a_700_ = lean_ctor_get_uint8(v_a_681_, sizeof(void*)*2);
v_a_701_ = lean_ctor_get(v_a_681_, 0);
lean_inc_ref(v_a_701_);
v_a_702_ = lean_ctor_get(v_a_681_, 1);
lean_inc_ref(v_a_702_);
lean_dec_ref_known(v_a_681_, 2);
v_toTypeExpr_703_ = lean_ctor_get(v_inst_680_, 1);
lean_inc_ref(v_toTypeExpr_703_);
v___x_704_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__17, &l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__17_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__17);
switch(v_a_700_)
{
case 0:
{
lean_object* v___x_710_; 
v___x_710_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__2, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__2);
v___y_706_ = v___x_710_;
goto v___jp_705_;
}
case 1:
{
lean_object* v___x_711_; 
v___x_711_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__4, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__4_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__4);
v___y_706_ = v___x_711_;
goto v___jp_705_;
}
case 2:
{
lean_object* v___x_712_; 
v___x_712_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__7, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__7);
v___y_706_ = v___x_712_;
goto v___jp_705_;
}
default: 
{
lean_object* v___x_713_; 
v___x_713_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__9, &l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate___lam__0___closed__9);
v___y_706_ = v___x_713_;
goto v___jp_705_;
}
}
v___jp_705_:
{
lean_object* v___x_707_; lean_object* v___x_708_; lean_object* v___x_709_; 
lean_inc_ref(v_inst_680_);
v___x_707_ = l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(v_inst_680_, v_a_701_);
v___x_708_ = l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(v_inst_680_, v_a_702_);
lean_inc_ref(v___y_706_);
v___x_709_ = l_Lean_mkApp4(v___x_704_, v_toTypeExpr_703_, v___y_706_, v___x_707_, v___x_708_);
return v___x_709_;
}
}
default: 
{
lean_object* v_a_714_; lean_object* v_a_715_; lean_object* v_a_716_; lean_object* v_toTypeExpr_717_; lean_object* v___x_718_; lean_object* v___x_719_; lean_object* v___x_720_; lean_object* v___x_721_; lean_object* v___x_722_; 
v_a_714_ = lean_ctor_get(v_a_681_, 0);
lean_inc_ref(v_a_714_);
v_a_715_ = lean_ctor_get(v_a_681_, 1);
lean_inc_ref(v_a_715_);
v_a_716_ = lean_ctor_get(v_a_681_, 2);
lean_inc_ref(v_a_716_);
lean_dec_ref_known(v_a_681_, 3);
v_toTypeExpr_717_ = lean_ctor_get(v_inst_680_, 1);
lean_inc_ref(v_toTypeExpr_717_);
v___x_718_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__20, &l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__20_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__20);
lean_inc_ref_n(v_inst_680_, 2);
v___x_719_ = l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(v_inst_680_, v_a_714_);
v___x_720_ = l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(v_inst_680_, v_a_715_);
v___x_721_ = l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(v_inst_680_, v_a_716_);
v___x_722_ = l_Lean_mkApp4(v___x_718_, v_toTypeExpr_717_, v___x_719_, v___x_720_, v___x_721_);
return v___x_722_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go(lean_object* v_00_u03b1_723_, lean_object* v_inst_724_, lean_object* v_a_725_){
_start:
{
lean_object* v___x_726_; 
v___x_726_ = l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(v_inst_724_, v_a_725_);
return v___x_726_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___lam__0(lean_object* v_inst_727_, lean_object* v_x_728_){
_start:
{
lean_object* v___x_729_; 
v___x_729_ = l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg(v_inst_727_, v_x_728_);
return v___x_729_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__1(void){
_start:
{
lean_object* v___x_735_; lean_object* v___x_736_; lean_object* v___x_737_; 
v___x_735_ = lean_box(0);
v___x_736_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__0));
v___x_737_ = l_Lean_mkConst(v___x_736_, v___x_735_);
return v___x_737_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg(lean_object* v_inst_738_){
_start:
{
lean_object* v_toTypeExpr_739_; lean_object* v___f_740_; lean_object* v___x_741_; lean_object* v___x_742_; lean_object* v___x_743_; 
v_toTypeExpr_739_ = lean_ctor_get(v_inst_738_, 1);
lean_inc_ref(v_toTypeExpr_739_);
v___f_740_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___lam__0), 2, 1);
lean_closure_set(v___f_740_, 0, v_inst_738_);
v___x_741_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg___closed__1);
v___x_742_ = l_Lean_Expr_app___override(v___x_741_, v_toTypeExpr_739_);
v___x_743_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_743_, 0, v___f_740_);
lean_ctor_set(v___x_743_, 1, v___x_742_);
return v___x_743_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr(lean_object* v_00_u03b1_744_, lean_object* v_inst_745_){
_start:
{
lean_object* v___x_746_; 
v___x_746_ = l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr___redArg(v_inst_745_);
return v___x_746_;
}
}
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2___redArg(lean_object* v_a_747_, lean_object* v_x_748_){
_start:
{
if (lean_obj_tag(v_x_748_) == 0)
{
uint8_t v___x_749_; 
v___x_749_ = 0;
return v___x_749_;
}
else
{
lean_object* v_key_750_; lean_object* v_tail_751_; uint8_t v___x_752_; 
v_key_750_ = lean_ctor_get(v_x_748_, 0);
v_tail_751_ = lean_ctor_get(v_x_748_, 2);
v___x_752_ = l___private_Lean_Meta_Sym_ExprPtr_0__Lean_Meta_Sym_isSameExpr_unsafe__1(v_key_750_, v_a_747_);
if (v___x_752_ == 0)
{
v_x_748_ = v_tail_751_;
goto _start;
}
else
{
return v___x_752_;
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2___redArg___boxed(lean_object* v_a_754_, lean_object* v_x_755_){
_start:
{
uint8_t v_res_756_; lean_object* v_r_757_; 
v_res_756_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2___redArg(v_a_754_, v_x_755_);
lean_dec(v_x_755_);
lean_dec_ref(v_a_754_);
v_r_757_ = lean_box(v_res_756_);
return v_r_757_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4_spec__5___redArg(lean_object* v_x_758_, lean_object* v_x_759_){
_start:
{
if (lean_obj_tag(v_x_759_) == 0)
{
return v_x_758_;
}
else
{
lean_object* v_key_760_; lean_object* v_value_761_; lean_object* v_tail_762_; lean_object* v___x_764_; uint8_t v_isShared_765_; uint8_t v_isSharedCheck_785_; 
v_key_760_ = lean_ctor_get(v_x_759_, 0);
v_value_761_ = lean_ctor_get(v_x_759_, 1);
v_tail_762_ = lean_ctor_get(v_x_759_, 2);
v_isSharedCheck_785_ = !lean_is_exclusive(v_x_759_);
if (v_isSharedCheck_785_ == 0)
{
v___x_764_ = v_x_759_;
v_isShared_765_ = v_isSharedCheck_785_;
goto v_resetjp_763_;
}
else
{
lean_inc(v_tail_762_);
lean_inc(v_value_761_);
lean_inc(v_key_760_);
lean_dec(v_x_759_);
v___x_764_ = lean_box(0);
v_isShared_765_ = v_isSharedCheck_785_;
goto v_resetjp_763_;
}
v_resetjp_763_:
{
lean_object* v___x_766_; uint64_t v___x_767_; uint64_t v___x_768_; uint64_t v___x_769_; uint64_t v_fold_770_; uint64_t v___x_771_; uint64_t v___x_772_; uint64_t v___x_773_; size_t v___x_774_; size_t v___x_775_; size_t v___x_776_; size_t v___x_777_; size_t v___x_778_; lean_object* v___x_779_; lean_object* v___x_781_; 
v___x_766_ = lean_array_get_size(v_x_758_);
v___x_767_ = l_Lean_Meta_Sym_hashPtrExpr_unsafe__1(v_key_760_);
v___x_768_ = 32ULL;
v___x_769_ = lean_uint64_shift_right(v___x_767_, v___x_768_);
v_fold_770_ = lean_uint64_xor(v___x_767_, v___x_769_);
v___x_771_ = 16ULL;
v___x_772_ = lean_uint64_shift_right(v_fold_770_, v___x_771_);
v___x_773_ = lean_uint64_xor(v_fold_770_, v___x_772_);
v___x_774_ = lean_uint64_to_usize(v___x_773_);
v___x_775_ = lean_usize_of_nat(v___x_766_);
v___x_776_ = ((size_t)1ULL);
v___x_777_ = lean_usize_sub(v___x_775_, v___x_776_);
v___x_778_ = lean_usize_land(v___x_774_, v___x_777_);
v___x_779_ = lean_array_uget_borrowed(v_x_758_, v___x_778_);
lean_inc(v___x_779_);
if (v_isShared_765_ == 0)
{
lean_ctor_set(v___x_764_, 2, v___x_779_);
v___x_781_ = v___x_764_;
goto v_reusejp_780_;
}
else
{
lean_object* v_reuseFailAlloc_784_; 
v_reuseFailAlloc_784_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v_reuseFailAlloc_784_, 0, v_key_760_);
lean_ctor_set(v_reuseFailAlloc_784_, 1, v_value_761_);
lean_ctor_set(v_reuseFailAlloc_784_, 2, v___x_779_);
v___x_781_ = v_reuseFailAlloc_784_;
goto v_reusejp_780_;
}
v_reusejp_780_:
{
lean_object* v___x_782_; 
v___x_782_ = lean_array_uset(v_x_758_, v___x_778_, v___x_781_);
v_x_758_ = v___x_782_;
v_x_759_ = v_tail_762_;
goto _start;
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4___redArg(lean_object* v_i_786_, lean_object* v_source_787_, lean_object* v_target_788_){
_start:
{
lean_object* v___x_789_; uint8_t v___x_790_; 
v___x_789_ = lean_array_get_size(v_source_787_);
v___x_790_ = lean_nat_dec_lt(v_i_786_, v___x_789_);
if (v___x_790_ == 0)
{
lean_dec_ref(v_source_787_);
lean_dec(v_i_786_);
return v_target_788_;
}
else
{
lean_object* v_es_791_; lean_object* v___x_792_; lean_object* v_source_793_; lean_object* v_target_794_; lean_object* v___x_795_; lean_object* v___x_796_; 
v_es_791_ = lean_array_fget(v_source_787_, v_i_786_);
v___x_792_ = lean_box(0);
v_source_793_ = lean_array_fset(v_source_787_, v_i_786_, v___x_792_);
v_target_794_ = l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4_spec__5___redArg(v_target_788_, v_es_791_);
v___x_795_ = lean_unsigned_to_nat(1u);
v___x_796_ = lean_nat_add(v_i_786_, v___x_795_);
lean_dec(v_i_786_);
v_i_786_ = v___x_796_;
v_source_787_ = v_source_793_;
v_target_788_ = v_target_794_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3___redArg(lean_object* v_data_798_){
_start:
{
lean_object* v___x_799_; lean_object* v___x_800_; lean_object* v_nbuckets_801_; lean_object* v___x_802_; lean_object* v___x_803_; lean_object* v___x_804_; lean_object* v___x_805_; 
v___x_799_ = lean_array_get_size(v_data_798_);
v___x_800_ = lean_unsigned_to_nat(2u);
v_nbuckets_801_ = lean_nat_mul(v___x_799_, v___x_800_);
v___x_802_ = lean_unsigned_to_nat(0u);
v___x_803_ = lean_box(0);
v___x_804_ = lean_mk_array(v_nbuckets_801_, v___x_803_);
v___x_805_ = l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4___redArg(v___x_802_, v_data_798_, v___x_804_);
return v___x_805_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__4___redArg(lean_object* v_a_806_, lean_object* v_b_807_, lean_object* v_x_808_){
_start:
{
if (lean_obj_tag(v_x_808_) == 0)
{
lean_dec(v_b_807_);
lean_dec_ref(v_a_806_);
return v_x_808_;
}
else
{
lean_object* v_key_809_; lean_object* v_value_810_; lean_object* v_tail_811_; lean_object* v___x_813_; uint8_t v_isShared_814_; uint8_t v_isSharedCheck_823_; 
v_key_809_ = lean_ctor_get(v_x_808_, 0);
v_value_810_ = lean_ctor_get(v_x_808_, 1);
v_tail_811_ = lean_ctor_get(v_x_808_, 2);
v_isSharedCheck_823_ = !lean_is_exclusive(v_x_808_);
if (v_isSharedCheck_823_ == 0)
{
v___x_813_ = v_x_808_;
v_isShared_814_ = v_isSharedCheck_823_;
goto v_resetjp_812_;
}
else
{
lean_inc(v_tail_811_);
lean_inc(v_value_810_);
lean_inc(v_key_809_);
lean_dec(v_x_808_);
v___x_813_ = lean_box(0);
v_isShared_814_ = v_isSharedCheck_823_;
goto v_resetjp_812_;
}
v_resetjp_812_:
{
uint8_t v___x_815_; 
v___x_815_ = l___private_Lean_Meta_Sym_ExprPtr_0__Lean_Meta_Sym_isSameExpr_unsafe__1(v_key_809_, v_a_806_);
if (v___x_815_ == 0)
{
lean_object* v___x_816_; lean_object* v___x_818_; 
v___x_816_ = l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__4___redArg(v_a_806_, v_b_807_, v_tail_811_);
if (v_isShared_814_ == 0)
{
lean_ctor_set(v___x_813_, 2, v___x_816_);
v___x_818_ = v___x_813_;
goto v_reusejp_817_;
}
else
{
lean_object* v_reuseFailAlloc_819_; 
v_reuseFailAlloc_819_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v_reuseFailAlloc_819_, 0, v_key_809_);
lean_ctor_set(v_reuseFailAlloc_819_, 1, v_value_810_);
lean_ctor_set(v_reuseFailAlloc_819_, 2, v___x_816_);
v___x_818_ = v_reuseFailAlloc_819_;
goto v_reusejp_817_;
}
v_reusejp_817_:
{
return v___x_818_;
}
}
else
{
lean_object* v___x_821_; 
lean_dec(v_value_810_);
lean_dec(v_key_809_);
if (v_isShared_814_ == 0)
{
lean_ctor_set(v___x_813_, 1, v_b_807_);
lean_ctor_set(v___x_813_, 0, v_a_806_);
v___x_821_ = v___x_813_;
goto v_reusejp_820_;
}
else
{
lean_object* v_reuseFailAlloc_822_; 
v_reuseFailAlloc_822_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v_reuseFailAlloc_822_, 0, v_a_806_);
lean_ctor_set(v_reuseFailAlloc_822_, 1, v_b_807_);
lean_ctor_set(v_reuseFailAlloc_822_, 2, v_tail_811_);
v___x_821_ = v_reuseFailAlloc_822_;
goto v_reusejp_820_;
}
v_reusejp_820_:
{
return v___x_821_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1___redArg(lean_object* v_m_824_, lean_object* v_a_825_, lean_object* v_b_826_){
_start:
{
lean_object* v_size_827_; lean_object* v_buckets_828_; lean_object* v___x_830_; uint8_t v_isShared_831_; uint8_t v_isSharedCheck_871_; 
v_size_827_ = lean_ctor_get(v_m_824_, 0);
v_buckets_828_ = lean_ctor_get(v_m_824_, 1);
v_isSharedCheck_871_ = !lean_is_exclusive(v_m_824_);
if (v_isSharedCheck_871_ == 0)
{
v___x_830_ = v_m_824_;
v_isShared_831_ = v_isSharedCheck_871_;
goto v_resetjp_829_;
}
else
{
lean_inc(v_buckets_828_);
lean_inc(v_size_827_);
lean_dec(v_m_824_);
v___x_830_ = lean_box(0);
v_isShared_831_ = v_isSharedCheck_871_;
goto v_resetjp_829_;
}
v_resetjp_829_:
{
lean_object* v___x_832_; uint64_t v___x_833_; uint64_t v___x_834_; uint64_t v___x_835_; uint64_t v_fold_836_; uint64_t v___x_837_; uint64_t v___x_838_; uint64_t v___x_839_; size_t v___x_840_; size_t v___x_841_; size_t v___x_842_; size_t v___x_843_; size_t v___x_844_; lean_object* v_bkt_845_; uint8_t v___x_846_; 
v___x_832_ = lean_array_get_size(v_buckets_828_);
v___x_833_ = l_Lean_Meta_Sym_hashPtrExpr_unsafe__1(v_a_825_);
v___x_834_ = 32ULL;
v___x_835_ = lean_uint64_shift_right(v___x_833_, v___x_834_);
v_fold_836_ = lean_uint64_xor(v___x_833_, v___x_835_);
v___x_837_ = 16ULL;
v___x_838_ = lean_uint64_shift_right(v_fold_836_, v___x_837_);
v___x_839_ = lean_uint64_xor(v_fold_836_, v___x_838_);
v___x_840_ = lean_uint64_to_usize(v___x_839_);
v___x_841_ = lean_usize_of_nat(v___x_832_);
v___x_842_ = ((size_t)1ULL);
v___x_843_ = lean_usize_sub(v___x_841_, v___x_842_);
v___x_844_ = lean_usize_land(v___x_840_, v___x_843_);
v_bkt_845_ = lean_array_uget_borrowed(v_buckets_828_, v___x_844_);
v___x_846_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2___redArg(v_a_825_, v_bkt_845_);
if (v___x_846_ == 0)
{
lean_object* v___x_847_; lean_object* v_size_x27_848_; lean_object* v___x_849_; lean_object* v_buckets_x27_850_; lean_object* v___x_851_; lean_object* v___x_852_; lean_object* v___x_853_; lean_object* v___x_854_; lean_object* v___x_855_; uint8_t v___x_856_; 
v___x_847_ = lean_unsigned_to_nat(1u);
v_size_x27_848_ = lean_nat_add(v_size_827_, v___x_847_);
lean_dec(v_size_827_);
lean_inc(v_bkt_845_);
v___x_849_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v___x_849_, 0, v_a_825_);
lean_ctor_set(v___x_849_, 1, v_b_826_);
lean_ctor_set(v___x_849_, 2, v_bkt_845_);
v_buckets_x27_850_ = lean_array_uset(v_buckets_828_, v___x_844_, v___x_849_);
v___x_851_ = lean_unsigned_to_nat(4u);
v___x_852_ = lean_nat_mul(v_size_x27_848_, v___x_851_);
v___x_853_ = lean_unsigned_to_nat(3u);
v___x_854_ = lean_nat_div(v___x_852_, v___x_853_);
lean_dec(v___x_852_);
v___x_855_ = lean_array_get_size(v_buckets_x27_850_);
v___x_856_ = lean_nat_dec_le(v___x_854_, v___x_855_);
lean_dec(v___x_854_);
if (v___x_856_ == 0)
{
lean_object* v_val_857_; lean_object* v___x_859_; 
v_val_857_ = l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3___redArg(v_buckets_x27_850_);
if (v_isShared_831_ == 0)
{
lean_ctor_set(v___x_830_, 1, v_val_857_);
lean_ctor_set(v___x_830_, 0, v_size_x27_848_);
v___x_859_ = v___x_830_;
goto v_reusejp_858_;
}
else
{
lean_object* v_reuseFailAlloc_860_; 
v_reuseFailAlloc_860_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_860_, 0, v_size_x27_848_);
lean_ctor_set(v_reuseFailAlloc_860_, 1, v_val_857_);
v___x_859_ = v_reuseFailAlloc_860_;
goto v_reusejp_858_;
}
v_reusejp_858_:
{
return v___x_859_;
}
}
else
{
lean_object* v___x_862_; 
if (v_isShared_831_ == 0)
{
lean_ctor_set(v___x_830_, 1, v_buckets_x27_850_);
lean_ctor_set(v___x_830_, 0, v_size_x27_848_);
v___x_862_ = v___x_830_;
goto v_reusejp_861_;
}
else
{
lean_object* v_reuseFailAlloc_863_; 
v_reuseFailAlloc_863_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_863_, 0, v_size_x27_848_);
lean_ctor_set(v_reuseFailAlloc_863_, 1, v_buckets_x27_850_);
v___x_862_ = v_reuseFailAlloc_863_;
goto v_reusejp_861_;
}
v_reusejp_861_:
{
return v___x_862_;
}
}
}
else
{
lean_object* v___x_864_; lean_object* v_buckets_x27_865_; lean_object* v___x_866_; lean_object* v___x_867_; lean_object* v___x_869_; 
lean_inc(v_bkt_845_);
v___x_864_ = lean_box(0);
v_buckets_x27_865_ = lean_array_uset(v_buckets_828_, v___x_844_, v___x_864_);
v___x_866_ = l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__4___redArg(v_a_825_, v_b_826_, v_bkt_845_);
v___x_867_ = lean_array_uset(v_buckets_x27_865_, v___x_844_, v___x_866_);
if (v_isShared_831_ == 0)
{
lean_ctor_set(v___x_830_, 1, v___x_867_);
v___x_869_ = v___x_830_;
goto v_reusejp_868_;
}
else
{
lean_object* v_reuseFailAlloc_870_; 
v_reuseFailAlloc_870_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_870_, 0, v_size_827_);
lean_ctor_set(v_reuseFailAlloc_870_, 1, v___x_867_);
v___x_869_ = v_reuseFailAlloc_870_;
goto v_reusejp_868_;
}
v_reusejp_868_:
{
return v___x_869_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0___redArg(lean_object* v_a_872_, lean_object* v_x_873_){
_start:
{
if (lean_obj_tag(v_x_873_) == 0)
{
lean_object* v___x_874_; 
v___x_874_ = lean_box(0);
return v___x_874_;
}
else
{
lean_object* v_key_875_; lean_object* v_value_876_; lean_object* v_tail_877_; uint8_t v___x_878_; 
v_key_875_ = lean_ctor_get(v_x_873_, 0);
v_value_876_ = lean_ctor_get(v_x_873_, 1);
v_tail_877_ = lean_ctor_get(v_x_873_, 2);
v___x_878_ = l___private_Lean_Meta_Sym_ExprPtr_0__Lean_Meta_Sym_isSameExpr_unsafe__1(v_key_875_, v_a_872_);
if (v___x_878_ == 0)
{
v_x_873_ = v_tail_877_;
goto _start;
}
else
{
lean_object* v___x_880_; 
lean_inc(v_value_876_);
v___x_880_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_880_, 0, v_value_876_);
return v___x_880_;
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0___redArg___boxed(lean_object* v_a_881_, lean_object* v_x_882_){
_start:
{
lean_object* v_res_883_; 
v_res_883_ = l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0___redArg(v_a_881_, v_x_882_);
lean_dec(v_x_882_);
lean_dec_ref(v_a_881_);
return v_res_883_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg(lean_object* v_m_884_, lean_object* v_a_885_){
_start:
{
lean_object* v_buckets_886_; lean_object* v___x_887_; uint64_t v___x_888_; uint64_t v___x_889_; uint64_t v___x_890_; uint64_t v_fold_891_; uint64_t v___x_892_; uint64_t v___x_893_; uint64_t v___x_894_; size_t v___x_895_; size_t v___x_896_; size_t v___x_897_; size_t v___x_898_; size_t v___x_899_; lean_object* v___x_900_; lean_object* v___x_901_; 
v_buckets_886_ = lean_ctor_get(v_m_884_, 1);
v___x_887_ = lean_array_get_size(v_buckets_886_);
v___x_888_ = l_Lean_Meta_Sym_hashPtrExpr_unsafe__1(v_a_885_);
v___x_889_ = 32ULL;
v___x_890_ = lean_uint64_shift_right(v___x_888_, v___x_889_);
v_fold_891_ = lean_uint64_xor(v___x_888_, v___x_890_);
v___x_892_ = 16ULL;
v___x_893_ = lean_uint64_shift_right(v_fold_891_, v___x_892_);
v___x_894_ = lean_uint64_xor(v_fold_891_, v___x_893_);
v___x_895_ = lean_uint64_to_usize(v___x_894_);
v___x_896_ = lean_usize_of_nat(v___x_887_);
v___x_897_ = ((size_t)1ULL);
v___x_898_ = lean_usize_sub(v___x_896_, v___x_897_);
v___x_899_ = lean_usize_land(v___x_895_, v___x_898_);
v___x_900_ = lean_array_uget_borrowed(v_buckets_886_, v___x_899_);
v___x_901_ = l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0___redArg(v_a_885_, v___x_900_);
return v___x_901_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg___boxed(lean_object* v_m_902_, lean_object* v_a_903_){
_start:
{
lean_object* v_res_904_; 
v_res_904_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg(v_m_902_, v_a_903_);
lean_dec_ref(v_a_903_);
lean_dec_ref(v_m_902_);
return v_res_904_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms(lean_object* v_reified_905_, lean_object* v_a_906_, lean_object* v_a_907_, lean_object* v_a_908_, lean_object* v_a_909_, lean_object* v_a_910_, lean_object* v_a_911_, lean_object* v_a_912_, lean_object* v_a_913_){
_start:
{
lean_object* v___x_915_; lean_object* v_originalExpr_916_; lean_object* v_evalsAtAtoms_x27_917_; lean_object* v_evalsAtCache_918_; lean_object* v___x_919_; 
v___x_915_ = lean_st_ref_get(v_a_907_);
v_originalExpr_916_ = lean_ctor_get(v_reified_905_, 2);
lean_inc_ref(v_originalExpr_916_);
v_evalsAtAtoms_x27_917_ = lean_ctor_get(v_reified_905_, 3);
lean_inc_ref(v_evalsAtAtoms_x27_917_);
lean_dec_ref(v_reified_905_);
v_evalsAtCache_918_ = lean_ctor_get(v___x_915_, 2);
lean_inc_ref(v_evalsAtCache_918_);
lean_dec(v___x_915_);
v___x_919_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg(v_evalsAtCache_918_, v_originalExpr_916_);
lean_dec_ref(v_evalsAtCache_918_);
if (lean_obj_tag(v___x_919_) == 0)
{
lean_object* v___x_920_; 
lean_inc(v_a_913_);
lean_inc_ref(v_a_912_);
lean_inc(v_a_911_);
lean_inc_ref(v_a_910_);
lean_inc(v_a_909_);
lean_inc_ref(v_a_908_);
lean_inc(v_a_907_);
lean_inc_ref(v_a_906_);
v___x_920_ = lean_apply_9(v_evalsAtAtoms_x27_917_, v_a_906_, v_a_907_, v_a_908_, v_a_909_, v_a_910_, v_a_911_, v_a_912_, v_a_913_, lean_box(0));
if (lean_obj_tag(v___x_920_) == 0)
{
lean_object* v_a_921_; lean_object* v___x_923_; uint8_t v_isShared_924_; uint8_t v_isSharedCheck_941_; 
v_a_921_ = lean_ctor_get(v___x_920_, 0);
v_isSharedCheck_941_ = !lean_is_exclusive(v___x_920_);
if (v_isSharedCheck_941_ == 0)
{
v___x_923_ = v___x_920_;
v_isShared_924_ = v_isSharedCheck_941_;
goto v_resetjp_922_;
}
else
{
lean_inc(v_a_921_);
lean_dec(v___x_920_);
v___x_923_ = lean_box(0);
v_isShared_924_ = v_isSharedCheck_941_;
goto v_resetjp_922_;
}
v_resetjp_922_:
{
lean_object* v___x_925_; lean_object* v_atoms_926_; lean_object* v_atomsAssignmentCache_927_; lean_object* v_evalsAtCache_928_; lean_object* v___x_930_; uint8_t v_isShared_931_; uint8_t v_isSharedCheck_940_; 
v___x_925_ = lean_st_ref_take(v_a_907_);
v_atoms_926_ = lean_ctor_get(v___x_925_, 0);
v_atomsAssignmentCache_927_ = lean_ctor_get(v___x_925_, 1);
v_evalsAtCache_928_ = lean_ctor_get(v___x_925_, 2);
v_isSharedCheck_940_ = !lean_is_exclusive(v___x_925_);
if (v_isSharedCheck_940_ == 0)
{
v___x_930_ = v___x_925_;
v_isShared_931_ = v_isSharedCheck_940_;
goto v_resetjp_929_;
}
else
{
lean_inc(v_evalsAtCache_928_);
lean_inc(v_atomsAssignmentCache_927_);
lean_inc(v_atoms_926_);
lean_dec(v___x_925_);
v___x_930_ = lean_box(0);
v_isShared_931_ = v_isSharedCheck_940_;
goto v_resetjp_929_;
}
v_resetjp_929_:
{
lean_object* v___x_932_; lean_object* v___x_934_; 
lean_inc(v_a_921_);
v___x_932_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1___redArg(v_evalsAtCache_928_, v_originalExpr_916_, v_a_921_);
if (v_isShared_931_ == 0)
{
lean_ctor_set(v___x_930_, 2, v___x_932_);
v___x_934_ = v___x_930_;
goto v_reusejp_933_;
}
else
{
lean_object* v_reuseFailAlloc_939_; 
v_reuseFailAlloc_939_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v_reuseFailAlloc_939_, 0, v_atoms_926_);
lean_ctor_set(v_reuseFailAlloc_939_, 1, v_atomsAssignmentCache_927_);
lean_ctor_set(v_reuseFailAlloc_939_, 2, v___x_932_);
v___x_934_ = v_reuseFailAlloc_939_;
goto v_reusejp_933_;
}
v_reusejp_933_:
{
lean_object* v___x_935_; lean_object* v___x_937_; 
v___x_935_ = lean_st_ref_set(v_a_907_, v___x_934_);
if (v_isShared_924_ == 0)
{
v___x_937_ = v___x_923_;
goto v_reusejp_936_;
}
else
{
lean_object* v_reuseFailAlloc_938_; 
v_reuseFailAlloc_938_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_938_, 0, v_a_921_);
v___x_937_ = v_reuseFailAlloc_938_;
goto v_reusejp_936_;
}
v_reusejp_936_:
{
return v___x_937_;
}
}
}
}
}
else
{
lean_dec_ref(v_originalExpr_916_);
return v___x_920_;
}
}
else
{
lean_object* v_val_942_; lean_object* v___x_944_; uint8_t v_isShared_945_; uint8_t v_isSharedCheck_949_; 
lean_dec_ref(v_evalsAtAtoms_x27_917_);
lean_dec_ref(v_originalExpr_916_);
v_val_942_ = lean_ctor_get(v___x_919_, 0);
v_isSharedCheck_949_ = !lean_is_exclusive(v___x_919_);
if (v_isSharedCheck_949_ == 0)
{
v___x_944_ = v___x_919_;
v_isShared_945_ = v_isSharedCheck_949_;
goto v_resetjp_943_;
}
else
{
lean_inc(v_val_942_);
lean_dec(v___x_919_);
v___x_944_ = lean_box(0);
v_isShared_945_ = v_isSharedCheck_949_;
goto v_resetjp_943_;
}
v_resetjp_943_:
{
lean_object* v___x_947_; 
if (v_isShared_945_ == 0)
{
lean_ctor_set_tag(v___x_944_, 0);
v___x_947_ = v___x_944_;
goto v_reusejp_946_;
}
else
{
lean_object* v_reuseFailAlloc_948_; 
v_reuseFailAlloc_948_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_948_, 0, v_val_942_);
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
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms___boxed(lean_object* v_reified_950_, lean_object* v_a_951_, lean_object* v_a_952_, lean_object* v_a_953_, lean_object* v_a_954_, lean_object* v_a_955_, lean_object* v_a_956_, lean_object* v_a_957_, lean_object* v_a_958_, lean_object* v_a_959_){
_start:
{
lean_object* v_res_960_; 
v_res_960_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms(v_reified_950_, v_a_951_, v_a_952_, v_a_953_, v_a_954_, v_a_955_, v_a_956_, v_a_957_, v_a_958_);
lean_dec(v_a_958_);
lean_dec_ref(v_a_957_);
lean_dec(v_a_956_);
lean_dec_ref(v_a_955_);
lean_dec(v_a_954_);
lean_dec_ref(v_a_953_);
lean_dec(v_a_952_);
lean_dec_ref(v_a_951_);
return v_res_960_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0(lean_object* v_00_u03b2_961_, lean_object* v_m_962_, lean_object* v_a_963_){
_start:
{
lean_object* v___x_964_; 
v___x_964_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg(v_m_962_, v_a_963_);
return v___x_964_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___boxed(lean_object* v_00_u03b2_965_, lean_object* v_m_966_, lean_object* v_a_967_){
_start:
{
lean_object* v_res_968_; 
v_res_968_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0(v_00_u03b2_965_, v_m_966_, v_a_967_);
lean_dec_ref(v_a_967_);
lean_dec_ref(v_m_966_);
return v_res_968_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1(lean_object* v_00_u03b2_969_, lean_object* v_m_970_, lean_object* v_a_971_, lean_object* v_b_972_){
_start:
{
lean_object* v___x_973_; 
v___x_973_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1___redArg(v_m_970_, v_a_971_, v_b_972_);
return v___x_973_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0(lean_object* v_00_u03b2_974_, lean_object* v_a_975_, lean_object* v_x_976_){
_start:
{
lean_object* v___x_977_; 
v___x_977_ = l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0___redArg(v_a_975_, v_x_976_);
return v___x_977_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0___boxed(lean_object* v_00_u03b2_978_, lean_object* v_a_979_, lean_object* v_x_980_){
_start:
{
lean_object* v_res_981_; 
v_res_981_ = l_Std_DHashMap_Internal_AssocList_get_x3f___at___00Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0_spec__0(v_00_u03b2_978_, v_a_979_, v_x_980_);
lean_dec(v_x_980_);
lean_dec_ref(v_a_979_);
return v_res_981_;
}
}
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2(lean_object* v_00_u03b2_982_, lean_object* v_a_983_, lean_object* v_x_984_){
_start:
{
uint8_t v___x_985_; 
v___x_985_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2___redArg(v_a_983_, v_x_984_);
return v___x_985_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2___boxed(lean_object* v_00_u03b2_986_, lean_object* v_a_987_, lean_object* v_x_988_){
_start:
{
uint8_t v_res_989_; lean_object* v_r_990_; 
v_res_989_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__2(v_00_u03b2_986_, v_a_987_, v_x_988_);
lean_dec(v_x_988_);
lean_dec_ref(v_a_987_);
v_r_990_ = lean_box(v_res_989_);
return v_r_990_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3(lean_object* v_00_u03b2_991_, lean_object* v_data_992_){
_start:
{
lean_object* v___x_993_; 
v___x_993_ = l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3___redArg(v_data_992_);
return v___x_993_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__4(lean_object* v_00_u03b2_994_, lean_object* v_a_995_, lean_object* v_b_996_, lean_object* v_x_997_){
_start:
{
lean_object* v___x_998_; 
v___x_998_ = l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__4___redArg(v_a_995_, v_b_996_, v_x_997_);
return v___x_998_;
}
}
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4(lean_object* v_00_u03b2_999_, lean_object* v_i_1000_, lean_object* v_source_1001_, lean_object* v_target_1002_){
_start:
{
lean_object* v___x_1003_; 
v___x_1003_ = l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4___redArg(v_i_1000_, v_source_1001_, v_target_1002_);
return v___x_1003_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4_spec__5(lean_object* v_00_u03b2_1004_, lean_object* v_x_1005_, lean_object* v_x_1006_){
_start:
{
lean_object* v___x_1007_; 
v___x_1007_ = l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1_spec__3_spec__4_spec__5___redArg(v_x_1005_, v_x_1006_);
return v___x_1007_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVPred_evalsAtAtoms(lean_object* v_reified_1008_, lean_object* v_a_1009_, lean_object* v_a_1010_, lean_object* v_a_1011_, lean_object* v_a_1012_, lean_object* v_a_1013_, lean_object* v_a_1014_, lean_object* v_a_1015_, lean_object* v_a_1016_){
_start:
{
lean_object* v___x_1018_; lean_object* v_originalExpr_1019_; lean_object* v_evalsAtAtoms_x27_1020_; lean_object* v_evalsAtCache_1021_; lean_object* v___x_1022_; 
v___x_1018_ = lean_st_ref_get(v_a_1010_);
v_originalExpr_1019_ = lean_ctor_get(v_reified_1008_, 1);
lean_inc_ref(v_originalExpr_1019_);
v_evalsAtAtoms_x27_1020_ = lean_ctor_get(v_reified_1008_, 2);
lean_inc_ref(v_evalsAtAtoms_x27_1020_);
lean_dec_ref(v_reified_1008_);
v_evalsAtCache_1021_ = lean_ctor_get(v___x_1018_, 2);
lean_inc_ref(v_evalsAtCache_1021_);
lean_dec(v___x_1018_);
v___x_1022_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg(v_evalsAtCache_1021_, v_originalExpr_1019_);
lean_dec_ref(v_evalsAtCache_1021_);
if (lean_obj_tag(v___x_1022_) == 0)
{
lean_object* v___x_1023_; 
lean_inc(v_a_1016_);
lean_inc_ref(v_a_1015_);
lean_inc(v_a_1014_);
lean_inc_ref(v_a_1013_);
lean_inc(v_a_1012_);
lean_inc_ref(v_a_1011_);
lean_inc(v_a_1010_);
lean_inc_ref(v_a_1009_);
v___x_1023_ = lean_apply_9(v_evalsAtAtoms_x27_1020_, v_a_1009_, v_a_1010_, v_a_1011_, v_a_1012_, v_a_1013_, v_a_1014_, v_a_1015_, v_a_1016_, lean_box(0));
if (lean_obj_tag(v___x_1023_) == 0)
{
lean_object* v_a_1024_; lean_object* v___x_1026_; uint8_t v_isShared_1027_; uint8_t v_isSharedCheck_1044_; 
v_a_1024_ = lean_ctor_get(v___x_1023_, 0);
v_isSharedCheck_1044_ = !lean_is_exclusive(v___x_1023_);
if (v_isSharedCheck_1044_ == 0)
{
v___x_1026_ = v___x_1023_;
v_isShared_1027_ = v_isSharedCheck_1044_;
goto v_resetjp_1025_;
}
else
{
lean_inc(v_a_1024_);
lean_dec(v___x_1023_);
v___x_1026_ = lean_box(0);
v_isShared_1027_ = v_isSharedCheck_1044_;
goto v_resetjp_1025_;
}
v_resetjp_1025_:
{
lean_object* v___x_1028_; lean_object* v_atoms_1029_; lean_object* v_atomsAssignmentCache_1030_; lean_object* v_evalsAtCache_1031_; lean_object* v___x_1033_; uint8_t v_isShared_1034_; uint8_t v_isSharedCheck_1043_; 
v___x_1028_ = lean_st_ref_take(v_a_1010_);
v_atoms_1029_ = lean_ctor_get(v___x_1028_, 0);
v_atomsAssignmentCache_1030_ = lean_ctor_get(v___x_1028_, 1);
v_evalsAtCache_1031_ = lean_ctor_get(v___x_1028_, 2);
v_isSharedCheck_1043_ = !lean_is_exclusive(v___x_1028_);
if (v_isSharedCheck_1043_ == 0)
{
v___x_1033_ = v___x_1028_;
v_isShared_1034_ = v_isSharedCheck_1043_;
goto v_resetjp_1032_;
}
else
{
lean_inc(v_evalsAtCache_1031_);
lean_inc(v_atomsAssignmentCache_1030_);
lean_inc(v_atoms_1029_);
lean_dec(v___x_1028_);
v___x_1033_ = lean_box(0);
v_isShared_1034_ = v_isSharedCheck_1043_;
goto v_resetjp_1032_;
}
v_resetjp_1032_:
{
lean_object* v___x_1035_; lean_object* v___x_1037_; 
lean_inc(v_a_1024_);
v___x_1035_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1___redArg(v_evalsAtCache_1031_, v_originalExpr_1019_, v_a_1024_);
if (v_isShared_1034_ == 0)
{
lean_ctor_set(v___x_1033_, 2, v___x_1035_);
v___x_1037_ = v___x_1033_;
goto v_reusejp_1036_;
}
else
{
lean_object* v_reuseFailAlloc_1042_; 
v_reuseFailAlloc_1042_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v_reuseFailAlloc_1042_, 0, v_atoms_1029_);
lean_ctor_set(v_reuseFailAlloc_1042_, 1, v_atomsAssignmentCache_1030_);
lean_ctor_set(v_reuseFailAlloc_1042_, 2, v___x_1035_);
v___x_1037_ = v_reuseFailAlloc_1042_;
goto v_reusejp_1036_;
}
v_reusejp_1036_:
{
lean_object* v___x_1038_; lean_object* v___x_1040_; 
v___x_1038_ = lean_st_ref_set(v_a_1010_, v___x_1037_);
if (v_isShared_1027_ == 0)
{
v___x_1040_ = v___x_1026_;
goto v_reusejp_1039_;
}
else
{
lean_object* v_reuseFailAlloc_1041_; 
v_reuseFailAlloc_1041_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1041_, 0, v_a_1024_);
v___x_1040_ = v_reuseFailAlloc_1041_;
goto v_reusejp_1039_;
}
v_reusejp_1039_:
{
return v___x_1040_;
}
}
}
}
}
else
{
lean_dec_ref(v_originalExpr_1019_);
return v___x_1023_;
}
}
else
{
lean_object* v_val_1045_; lean_object* v___x_1047_; uint8_t v_isShared_1048_; uint8_t v_isSharedCheck_1052_; 
lean_dec_ref(v_evalsAtAtoms_x27_1020_);
lean_dec_ref(v_originalExpr_1019_);
v_val_1045_ = lean_ctor_get(v___x_1022_, 0);
v_isSharedCheck_1052_ = !lean_is_exclusive(v___x_1022_);
if (v_isSharedCheck_1052_ == 0)
{
v___x_1047_ = v___x_1022_;
v_isShared_1048_ = v_isSharedCheck_1052_;
goto v_resetjp_1046_;
}
else
{
lean_inc(v_val_1045_);
lean_dec(v___x_1022_);
v___x_1047_ = lean_box(0);
v_isShared_1048_ = v_isSharedCheck_1052_;
goto v_resetjp_1046_;
}
v_resetjp_1046_:
{
lean_object* v___x_1050_; 
if (v_isShared_1048_ == 0)
{
lean_ctor_set_tag(v___x_1047_, 0);
v___x_1050_ = v___x_1047_;
goto v_reusejp_1049_;
}
else
{
lean_object* v_reuseFailAlloc_1051_; 
v_reuseFailAlloc_1051_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1051_, 0, v_val_1045_);
v___x_1050_ = v_reuseFailAlloc_1051_;
goto v_reusejp_1049_;
}
v_reusejp_1049_:
{
return v___x_1050_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVPred_evalsAtAtoms___boxed(lean_object* v_reified_1053_, lean_object* v_a_1054_, lean_object* v_a_1055_, lean_object* v_a_1056_, lean_object* v_a_1057_, lean_object* v_a_1058_, lean_object* v_a_1059_, lean_object* v_a_1060_, lean_object* v_a_1061_, lean_object* v_a_1062_){
_start:
{
lean_object* v_res_1063_; 
v_res_1063_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVPred_evalsAtAtoms(v_reified_1053_, v_a_1054_, v_a_1055_, v_a_1056_, v_a_1057_, v_a_1058_, v_a_1059_, v_a_1060_, v_a_1061_);
lean_dec(v_a_1061_);
lean_dec_ref(v_a_1060_);
lean_dec(v_a_1059_);
lean_dec_ref(v_a_1058_);
lean_dec(v_a_1057_);
lean_dec_ref(v_a_1056_);
lean_dec(v_a_1055_);
lean_dec_ref(v_a_1054_);
return v_res_1063_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(lean_object* v_reified_1064_, lean_object* v_a_1065_, lean_object* v_a_1066_, lean_object* v_a_1067_, lean_object* v_a_1068_, lean_object* v_a_1069_, lean_object* v_a_1070_, lean_object* v_a_1071_, lean_object* v_a_1072_){
_start:
{
lean_object* v___x_1074_; lean_object* v_originalExpr_1075_; lean_object* v_evalsAtAtoms_x27_1076_; lean_object* v_evalsAtCache_1077_; lean_object* v___x_1078_; 
v___x_1074_ = lean_st_ref_get(v_a_1066_);
v_originalExpr_1075_ = lean_ctor_get(v_reified_1064_, 1);
lean_inc_ref(v_originalExpr_1075_);
v_evalsAtAtoms_x27_1076_ = lean_ctor_get(v_reified_1064_, 2);
lean_inc_ref(v_evalsAtAtoms_x27_1076_);
lean_dec_ref(v_reified_1064_);
v_evalsAtCache_1077_ = lean_ctor_get(v___x_1074_, 2);
lean_inc_ref(v_evalsAtCache_1077_);
lean_dec(v___x_1074_);
v___x_1078_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg(v_evalsAtCache_1077_, v_originalExpr_1075_);
lean_dec_ref(v_evalsAtCache_1077_);
if (lean_obj_tag(v___x_1078_) == 0)
{
lean_object* v___x_1079_; 
lean_inc(v_a_1072_);
lean_inc_ref(v_a_1071_);
lean_inc(v_a_1070_);
lean_inc_ref(v_a_1069_);
lean_inc(v_a_1068_);
lean_inc_ref(v_a_1067_);
lean_inc(v_a_1066_);
lean_inc_ref(v_a_1065_);
v___x_1079_ = lean_apply_9(v_evalsAtAtoms_x27_1076_, v_a_1065_, v_a_1066_, v_a_1067_, v_a_1068_, v_a_1069_, v_a_1070_, v_a_1071_, v_a_1072_, lean_box(0));
if (lean_obj_tag(v___x_1079_) == 0)
{
lean_object* v_a_1080_; lean_object* v___x_1082_; uint8_t v_isShared_1083_; uint8_t v_isSharedCheck_1100_; 
v_a_1080_ = lean_ctor_get(v___x_1079_, 0);
v_isSharedCheck_1100_ = !lean_is_exclusive(v___x_1079_);
if (v_isSharedCheck_1100_ == 0)
{
v___x_1082_ = v___x_1079_;
v_isShared_1083_ = v_isSharedCheck_1100_;
goto v_resetjp_1081_;
}
else
{
lean_inc(v_a_1080_);
lean_dec(v___x_1079_);
v___x_1082_ = lean_box(0);
v_isShared_1083_ = v_isSharedCheck_1100_;
goto v_resetjp_1081_;
}
v_resetjp_1081_:
{
lean_object* v___x_1084_; lean_object* v_atoms_1085_; lean_object* v_atomsAssignmentCache_1086_; lean_object* v_evalsAtCache_1087_; lean_object* v___x_1089_; uint8_t v_isShared_1090_; uint8_t v_isSharedCheck_1099_; 
v___x_1084_ = lean_st_ref_take(v_a_1066_);
v_atoms_1085_ = lean_ctor_get(v___x_1084_, 0);
v_atomsAssignmentCache_1086_ = lean_ctor_get(v___x_1084_, 1);
v_evalsAtCache_1087_ = lean_ctor_get(v___x_1084_, 2);
v_isSharedCheck_1099_ = !lean_is_exclusive(v___x_1084_);
if (v_isSharedCheck_1099_ == 0)
{
v___x_1089_ = v___x_1084_;
v_isShared_1090_ = v_isSharedCheck_1099_;
goto v_resetjp_1088_;
}
else
{
lean_inc(v_evalsAtCache_1087_);
lean_inc(v_atomsAssignmentCache_1086_);
lean_inc(v_atoms_1085_);
lean_dec(v___x_1084_);
v___x_1089_ = lean_box(0);
v_isShared_1090_ = v_isSharedCheck_1099_;
goto v_resetjp_1088_;
}
v_resetjp_1088_:
{
lean_object* v___x_1091_; lean_object* v___x_1093_; 
lean_inc(v_a_1080_);
v___x_1091_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1___redArg(v_evalsAtCache_1087_, v_originalExpr_1075_, v_a_1080_);
if (v_isShared_1090_ == 0)
{
lean_ctor_set(v___x_1089_, 2, v___x_1091_);
v___x_1093_ = v___x_1089_;
goto v_reusejp_1092_;
}
else
{
lean_object* v_reuseFailAlloc_1098_; 
v_reuseFailAlloc_1098_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v_reuseFailAlloc_1098_, 0, v_atoms_1085_);
lean_ctor_set(v_reuseFailAlloc_1098_, 1, v_atomsAssignmentCache_1086_);
lean_ctor_set(v_reuseFailAlloc_1098_, 2, v___x_1091_);
v___x_1093_ = v_reuseFailAlloc_1098_;
goto v_reusejp_1092_;
}
v_reusejp_1092_:
{
lean_object* v___x_1094_; lean_object* v___x_1096_; 
v___x_1094_ = lean_st_ref_set(v_a_1066_, v___x_1093_);
if (v_isShared_1083_ == 0)
{
v___x_1096_ = v___x_1082_;
goto v_reusejp_1095_;
}
else
{
lean_object* v_reuseFailAlloc_1097_; 
v_reuseFailAlloc_1097_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1097_, 0, v_a_1080_);
v___x_1096_ = v_reuseFailAlloc_1097_;
goto v_reusejp_1095_;
}
v_reusejp_1095_:
{
return v___x_1096_;
}
}
}
}
}
else
{
lean_dec_ref(v_originalExpr_1075_);
return v___x_1079_;
}
}
else
{
lean_object* v_val_1101_; lean_object* v___x_1103_; uint8_t v_isShared_1104_; uint8_t v_isSharedCheck_1108_; 
lean_dec_ref(v_evalsAtAtoms_x27_1076_);
lean_dec_ref(v_originalExpr_1075_);
v_val_1101_ = lean_ctor_get(v___x_1078_, 0);
v_isSharedCheck_1108_ = !lean_is_exclusive(v___x_1078_);
if (v_isSharedCheck_1108_ == 0)
{
v___x_1103_ = v___x_1078_;
v_isShared_1104_ = v_isSharedCheck_1108_;
goto v_resetjp_1102_;
}
else
{
lean_inc(v_val_1101_);
lean_dec(v___x_1078_);
v___x_1103_ = lean_box(0);
v_isShared_1104_ = v_isSharedCheck_1108_;
goto v_resetjp_1102_;
}
v_resetjp_1102_:
{
lean_object* v___x_1106_; 
if (v_isShared_1104_ == 0)
{
lean_ctor_set_tag(v___x_1103_, 0);
v___x_1106_ = v___x_1103_;
goto v_reusejp_1105_;
}
else
{
lean_object* v_reuseFailAlloc_1107_; 
v_reuseFailAlloc_1107_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1107_, 0, v_val_1101_);
v___x_1106_ = v_reuseFailAlloc_1107_;
goto v_reusejp_1105_;
}
v_reusejp_1105_:
{
return v___x_1106_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms___boxed(lean_object* v_reified_1109_, lean_object* v_a_1110_, lean_object* v_a_1111_, lean_object* v_a_1112_, lean_object* v_a_1113_, lean_object* v_a_1114_, lean_object* v_a_1115_, lean_object* v_a_1116_, lean_object* v_a_1117_, lean_object* v_a_1118_){
_start:
{
lean_object* v_res_1119_; 
v_res_1119_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(v_reified_1109_, v_a_1110_, v_a_1111_, v_a_1112_, v_a_1113_, v_a_1114_, v_a_1115_, v_a_1116_, v_a_1117_);
lean_dec(v_a_1117_);
lean_dec_ref(v_a_1116_);
lean_dec(v_a_1115_);
lean_dec_ref(v_a_1114_);
lean_dec(v_a_1113_);
lean_dec_ref(v_a_1112_);
lean_dec(v_a_1111_);
lean_dec_ref(v_a_1110_);
return v_res_1119_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_run_spec__0(size_t v_sz_1120_, size_t v_i_1121_, lean_object* v_bs_1122_, lean_object* v___y_1123_, lean_object* v___y_1124_, lean_object* v___y_1125_, lean_object* v___y_1126_, lean_object* v___y_1127_, lean_object* v___y_1128_){
_start:
{
uint8_t v___x_1130_; 
v___x_1130_ = lean_usize_dec_lt(v_i_1121_, v_sz_1120_);
if (v___x_1130_ == 0)
{
lean_object* v___x_1131_; 
v___x_1131_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1131_, 0, v_bs_1122_);
return v___x_1131_;
}
else
{
lean_object* v_v_1132_; lean_object* v_name_1133_; lean_object* v_type_1134_; lean_object* v_value_1135_; lean_object* v___x_1137_; uint8_t v_isShared_1138_; uint8_t v_isSharedCheck_1158_; 
v_v_1132_ = lean_array_uget(v_bs_1122_, v_i_1121_);
v_name_1133_ = lean_ctor_get(v_v_1132_, 0);
v_type_1134_ = lean_ctor_get(v_v_1132_, 1);
v_value_1135_ = lean_ctor_get(v_v_1132_, 2);
v_isSharedCheck_1158_ = !lean_is_exclusive(v_v_1132_);
if (v_isSharedCheck_1158_ == 0)
{
v___x_1137_ = v_v_1132_;
v_isShared_1138_ = v_isSharedCheck_1158_;
goto v_resetjp_1136_;
}
else
{
lean_inc(v_value_1135_);
lean_inc(v_type_1134_);
lean_inc(v_name_1133_);
lean_dec(v_v_1132_);
v___x_1137_ = lean_box(0);
v_isShared_1138_ = v_isSharedCheck_1158_;
goto v_resetjp_1136_;
}
v_resetjp_1136_:
{
lean_object* v___x_1139_; 
v___x_1139_ = l_Lean_Meta_Sym_shareCommon(v_type_1134_, v___y_1123_, v___y_1124_, v___y_1125_, v___y_1126_, v___y_1127_, v___y_1128_);
if (lean_obj_tag(v___x_1139_) == 0)
{
lean_object* v_a_1140_; lean_object* v___x_1141_; lean_object* v_bs_x27_1142_; lean_object* v___x_1144_; 
v_a_1140_ = lean_ctor_get(v___x_1139_, 0);
lean_inc(v_a_1140_);
lean_dec_ref_known(v___x_1139_, 1);
v___x_1141_ = lean_unsigned_to_nat(0u);
v_bs_x27_1142_ = lean_array_uset(v_bs_1122_, v_i_1121_, v___x_1141_);
if (v_isShared_1138_ == 0)
{
lean_ctor_set(v___x_1137_, 1, v_a_1140_);
v___x_1144_ = v___x_1137_;
goto v_reusejp_1143_;
}
else
{
lean_object* v_reuseFailAlloc_1149_; 
v_reuseFailAlloc_1149_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v_reuseFailAlloc_1149_, 0, v_name_1133_);
lean_ctor_set(v_reuseFailAlloc_1149_, 1, v_a_1140_);
lean_ctor_set(v_reuseFailAlloc_1149_, 2, v_value_1135_);
v___x_1144_ = v_reuseFailAlloc_1149_;
goto v_reusejp_1143_;
}
v_reusejp_1143_:
{
size_t v___x_1145_; size_t v___x_1146_; lean_object* v___x_1147_; 
v___x_1145_ = ((size_t)1ULL);
v___x_1146_ = lean_usize_add(v_i_1121_, v___x_1145_);
v___x_1147_ = lean_array_uset(v_bs_x27_1142_, v_i_1121_, v___x_1144_);
v_i_1121_ = v___x_1146_;
v_bs_1122_ = v___x_1147_;
goto _start;
}
}
else
{
lean_object* v_a_1150_; lean_object* v___x_1152_; uint8_t v_isShared_1153_; uint8_t v_isSharedCheck_1157_; 
lean_del_object(v___x_1137_);
lean_dec_ref(v_value_1135_);
lean_dec(v_name_1133_);
lean_dec_ref(v_bs_1122_);
v_a_1150_ = lean_ctor_get(v___x_1139_, 0);
v_isSharedCheck_1157_ = !lean_is_exclusive(v___x_1139_);
if (v_isSharedCheck_1157_ == 0)
{
v___x_1152_ = v___x_1139_;
v_isShared_1153_ = v_isSharedCheck_1157_;
goto v_resetjp_1151_;
}
else
{
lean_inc(v_a_1150_);
lean_dec(v___x_1139_);
v___x_1152_ = lean_box(0);
v_isShared_1153_ = v_isSharedCheck_1157_;
goto v_resetjp_1151_;
}
v_resetjp_1151_:
{
lean_object* v___x_1155_; 
if (v_isShared_1153_ == 0)
{
v___x_1155_ = v___x_1152_;
goto v_reusejp_1154_;
}
else
{
lean_object* v_reuseFailAlloc_1156_; 
v_reuseFailAlloc_1156_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1156_, 0, v_a_1150_);
v___x_1155_ = v_reuseFailAlloc_1156_;
goto v_reusejp_1154_;
}
v_reusejp_1154_:
{
return v___x_1155_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_run_spec__0___boxed(lean_object* v_sz_1159_, lean_object* v_i_1160_, lean_object* v_bs_1161_, lean_object* v___y_1162_, lean_object* v___y_1163_, lean_object* v___y_1164_, lean_object* v___y_1165_, lean_object* v___y_1166_, lean_object* v___y_1167_, lean_object* v___y_1168_){
_start:
{
size_t v_sz_boxed_1169_; size_t v_i_boxed_1170_; lean_object* v_res_1171_; 
v_sz_boxed_1169_ = lean_unbox_usize(v_sz_1159_);
lean_dec(v_sz_1159_);
v_i_boxed_1170_ = lean_unbox_usize(v_i_1160_);
lean_dec(v_i_1160_);
v_res_1171_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_run_spec__0(v_sz_boxed_1169_, v_i_boxed_1170_, v_bs_1161_, v___y_1162_, v___y_1163_, v___y_1164_, v___y_1165_, v___y_1166_, v___y_1167_);
lean_dec(v___y_1167_);
lean_dec_ref(v___y_1166_);
lean_dec(v___y_1165_);
lean_dec_ref(v___y_1164_);
lean_dec(v___y_1163_);
lean_dec_ref(v___y_1162_);
return v_res_1171_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__0(void){
_start:
{
lean_object* v___x_1172_; lean_object* v___x_1173_; lean_object* v___x_1174_; 
v___x_1172_ = lean_box(0);
v___x_1173_ = lean_unsigned_to_nat(16u);
v___x_1174_ = lean_mk_array(v___x_1173_, v___x_1172_);
return v___x_1174_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__1(void){
_start:
{
lean_object* v___x_1175_; lean_object* v___x_1176_; lean_object* v___x_1177_; 
v___x_1175_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__0, &l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__0_once, _init_l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__0);
v___x_1176_ = lean_unsigned_to_nat(0u);
v___x_1177_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1177_, 0, v___x_1176_);
lean_ctor_set(v___x_1177_, 1, v___x_1175_);
return v___x_1177_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__2(void){
_start:
{
lean_object* v___x_1178_; lean_object* v___x_1179_; lean_object* v___x_1180_; 
v___x_1178_ = lean_box(0);
v___x_1179_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__1);
v___x_1180_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v___x_1180_, 0, v___x_1179_);
lean_ctor_set(v___x_1180_, 1, v___x_1178_);
lean_ctor_set(v___x_1180_, 2, v___x_1179_);
return v___x_1180_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___redArg(lean_object* v_m_1181_, lean_object* v_hypotheses_1182_, lean_object* v_a_1183_, lean_object* v_a_1184_, lean_object* v_a_1185_, lean_object* v_a_1186_, lean_object* v_a_1187_, lean_object* v_a_1188_){
_start:
{
size_t v_sz_1190_; size_t v___x_1191_; lean_object* v___x_1192_; 
v_sz_1190_ = lean_array_size(v_hypotheses_1182_);
v___x_1191_ = ((size_t)0ULL);
v___x_1192_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_run_spec__0(v_sz_1190_, v___x_1191_, v_hypotheses_1182_, v_a_1183_, v_a_1184_, v_a_1185_, v_a_1186_, v_a_1187_, v_a_1188_);
if (lean_obj_tag(v___x_1192_) == 0)
{
lean_object* v_a_1193_; lean_object* v___x_1194_; lean_object* v___x_1195_; lean_object* v___x_1196_; 
v_a_1193_ = lean_ctor_get(v___x_1192_, 0);
lean_inc(v_a_1193_);
lean_dec_ref_known(v___x_1192_, 1);
v___x_1194_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__2, &l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__2);
v___x_1195_ = lean_st_mk_ref(v___x_1194_);
lean_inc(v_a_1188_);
lean_inc_ref(v_a_1187_);
lean_inc(v_a_1186_);
lean_inc_ref(v_a_1185_);
lean_inc(v_a_1184_);
lean_inc_ref(v_a_1183_);
lean_inc(v___x_1195_);
v___x_1196_ = lean_apply_9(v_m_1181_, v_a_1193_, v___x_1195_, v_a_1183_, v_a_1184_, v_a_1185_, v_a_1186_, v_a_1187_, v_a_1188_, lean_box(0));
if (lean_obj_tag(v___x_1196_) == 0)
{
lean_object* v_a_1197_; lean_object* v___x_1199_; uint8_t v_isShared_1200_; uint8_t v_isSharedCheck_1205_; 
v_a_1197_ = lean_ctor_get(v___x_1196_, 0);
v_isSharedCheck_1205_ = !lean_is_exclusive(v___x_1196_);
if (v_isSharedCheck_1205_ == 0)
{
v___x_1199_ = v___x_1196_;
v_isShared_1200_ = v_isSharedCheck_1205_;
goto v_resetjp_1198_;
}
else
{
lean_inc(v_a_1197_);
lean_dec(v___x_1196_);
v___x_1199_ = lean_box(0);
v_isShared_1200_ = v_isSharedCheck_1205_;
goto v_resetjp_1198_;
}
v_resetjp_1198_:
{
lean_object* v___x_1201_; lean_object* v___x_1203_; 
v___x_1201_ = lean_st_ref_get(v___x_1195_);
lean_dec(v___x_1195_);
lean_dec(v___x_1201_);
if (v_isShared_1200_ == 0)
{
v___x_1203_ = v___x_1199_;
goto v_reusejp_1202_;
}
else
{
lean_object* v_reuseFailAlloc_1204_; 
v_reuseFailAlloc_1204_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1204_, 0, v_a_1197_);
v___x_1203_ = v_reuseFailAlloc_1204_;
goto v_reusejp_1202_;
}
v_reusejp_1202_:
{
return v___x_1203_;
}
}
}
else
{
lean_dec(v___x_1195_);
return v___x_1196_;
}
}
else
{
lean_object* v_a_1206_; lean_object* v___x_1208_; uint8_t v_isShared_1209_; uint8_t v_isSharedCheck_1213_; 
lean_dec_ref(v_m_1181_);
v_a_1206_ = lean_ctor_get(v___x_1192_, 0);
v_isSharedCheck_1213_ = !lean_is_exclusive(v___x_1192_);
if (v_isSharedCheck_1213_ == 0)
{
v___x_1208_ = v___x_1192_;
v_isShared_1209_ = v_isSharedCheck_1213_;
goto v_resetjp_1207_;
}
else
{
lean_inc(v_a_1206_);
lean_dec(v___x_1192_);
v___x_1208_ = lean_box(0);
v_isShared_1209_ = v_isSharedCheck_1213_;
goto v_resetjp_1207_;
}
v_resetjp_1207_:
{
lean_object* v___x_1211_; 
if (v_isShared_1209_ == 0)
{
v___x_1211_ = v___x_1208_;
goto v_reusejp_1210_;
}
else
{
lean_object* v_reuseFailAlloc_1212_; 
v_reuseFailAlloc_1212_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1212_, 0, v_a_1206_);
v___x_1211_ = v_reuseFailAlloc_1212_;
goto v_reusejp_1210_;
}
v_reusejp_1210_:
{
return v___x_1211_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___redArg___boxed(lean_object* v_m_1214_, lean_object* v_hypotheses_1215_, lean_object* v_a_1216_, lean_object* v_a_1217_, lean_object* v_a_1218_, lean_object* v_a_1219_, lean_object* v_a_1220_, lean_object* v_a_1221_, lean_object* v_a_1222_){
_start:
{
lean_object* v_res_1223_; 
v_res_1223_ = l_Lean_Meta_Tactic_BVDecide_M_run___redArg(v_m_1214_, v_hypotheses_1215_, v_a_1216_, v_a_1217_, v_a_1218_, v_a_1219_, v_a_1220_, v_a_1221_);
lean_dec(v_a_1221_);
lean_dec_ref(v_a_1220_);
lean_dec(v_a_1219_);
lean_dec_ref(v_a_1218_);
lean_dec(v_a_1217_);
lean_dec_ref(v_a_1216_);
return v_res_1223_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_run(lean_object* v_00_u03b1_1224_, lean_object* v_m_1225_, lean_object* v_hypotheses_1226_, lean_object* v_a_1227_, lean_object* v_a_1228_, lean_object* v_a_1229_, lean_object* v_a_1230_, lean_object* v_a_1231_, lean_object* v_a_1232_){
_start:
{
lean_object* v___x_1234_; 
v___x_1234_ = l_Lean_Meta_Tactic_BVDecide_M_run___redArg(v_m_1225_, v_hypotheses_1226_, v_a_1227_, v_a_1228_, v_a_1229_, v_a_1230_, v_a_1231_, v_a_1232_);
return v___x_1234_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___boxed(lean_object* v_00_u03b1_1235_, lean_object* v_m_1236_, lean_object* v_hypotheses_1237_, lean_object* v_a_1238_, lean_object* v_a_1239_, lean_object* v_a_1240_, lean_object* v_a_1241_, lean_object* v_a_1242_, lean_object* v_a_1243_, lean_object* v_a_1244_){
_start:
{
lean_object* v_res_1245_; 
v_res_1245_ = l_Lean_Meta_Tactic_BVDecide_M_run(v_00_u03b1_1235_, v_m_1236_, v_hypotheses_1237_, v_a_1238_, v_a_1239_, v_a_1240_, v_a_1241_, v_a_1242_, v_a_1243_);
lean_dec(v_a_1243_);
lean_dec_ref(v_a_1242_);
lean_dec(v_a_1241_);
lean_dec_ref(v_a_1240_);
lean_dec(v_a_1239_);
lean_dec_ref(v_a_1238_);
return v_res_1245_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1___redArg(lean_object* v_hi_1246_, lean_object* v_pivot_1247_, lean_object* v_as_1248_, lean_object* v_i_1249_, lean_object* v_k_1250_){
_start:
{
uint8_t v___x_1251_; 
v___x_1251_ = lean_nat_dec_lt(v_k_1250_, v_hi_1246_);
if (v___x_1251_ == 0)
{
lean_object* v___x_1252_; lean_object* v___x_1253_; 
lean_dec(v_k_1250_);
v___x_1252_ = lean_array_fswap(v_as_1248_, v_i_1249_, v_hi_1246_);
v___x_1253_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1253_, 0, v_i_1249_);
lean_ctor_set(v___x_1253_, 1, v___x_1252_);
return v___x_1253_;
}
else
{
lean_object* v___x_1254_; lean_object* v_snd_1255_; lean_object* v_snd_1256_; lean_object* v_atomNumber_1257_; lean_object* v_atomNumber_1258_; uint8_t v___x_1259_; 
v___x_1254_ = lean_array_fget_borrowed(v_as_1248_, v_k_1250_);
v_snd_1255_ = lean_ctor_get(v___x_1254_, 1);
v_snd_1256_ = lean_ctor_get(v_pivot_1247_, 1);
v_atomNumber_1257_ = lean_ctor_get(v_snd_1255_, 1);
v_atomNumber_1258_ = lean_ctor_get(v_snd_1256_, 1);
v___x_1259_ = lean_nat_dec_lt(v_atomNumber_1257_, v_atomNumber_1258_);
if (v___x_1259_ == 0)
{
lean_object* v___x_1260_; lean_object* v___x_1261_; 
v___x_1260_ = lean_unsigned_to_nat(1u);
v___x_1261_ = lean_nat_add(v_k_1250_, v___x_1260_);
lean_dec(v_k_1250_);
v_k_1250_ = v___x_1261_;
goto _start;
}
else
{
lean_object* v___x_1263_; lean_object* v___x_1264_; lean_object* v___x_1265_; lean_object* v___x_1266_; 
v___x_1263_ = lean_array_fswap(v_as_1248_, v_i_1249_, v_k_1250_);
v___x_1264_ = lean_unsigned_to_nat(1u);
v___x_1265_ = lean_nat_add(v_i_1249_, v___x_1264_);
lean_dec(v_i_1249_);
v___x_1266_ = lean_nat_add(v_k_1250_, v___x_1264_);
lean_dec(v_k_1250_);
v_as_1248_ = v___x_1263_;
v_i_1249_ = v___x_1265_;
v_k_1250_ = v___x_1266_;
goto _start;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1___redArg___boxed(lean_object* v_hi_1268_, lean_object* v_pivot_1269_, lean_object* v_as_1270_, lean_object* v_i_1271_, lean_object* v_k_1272_){
_start:
{
lean_object* v_res_1273_; 
v_res_1273_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1___redArg(v_hi_1268_, v_pivot_1269_, v_as_1270_, v_i_1271_, v_k_1272_);
lean_dec_ref(v_pivot_1269_);
lean_dec(v_hi_1268_);
return v_res_1273_;
}
}
LEAN_EXPORT uint8_t l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___lam__0(lean_object* v_x1_1274_, lean_object* v_x2_1275_){
_start:
{
lean_object* v_snd_1276_; lean_object* v_snd_1277_; lean_object* v_atomNumber_1278_; lean_object* v_atomNumber_1279_; uint8_t v___x_1280_; 
v_snd_1276_ = lean_ctor_get(v_x1_1274_, 1);
v_snd_1277_ = lean_ctor_get(v_x2_1275_, 1);
v_atomNumber_1278_ = lean_ctor_get(v_snd_1276_, 1);
v_atomNumber_1279_ = lean_ctor_get(v_snd_1277_, 1);
v___x_1280_ = lean_nat_dec_lt(v_atomNumber_1278_, v_atomNumber_1279_);
return v___x_1280_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___lam__0___boxed(lean_object* v_x1_1281_, lean_object* v_x2_1282_){
_start:
{
uint8_t v_res_1283_; lean_object* v_r_1284_; 
v_res_1283_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___lam__0(v_x1_1281_, v_x2_1282_);
lean_dec_ref(v_x2_1282_);
lean_dec_ref(v_x1_1281_);
v_r_1284_ = lean_box(v_res_1283_);
return v_r_1284_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg(lean_object* v_n_1285_, lean_object* v_as_1286_, lean_object* v_lo_1287_, lean_object* v_hi_1288_){
_start:
{
lean_object* v___y_1290_; uint8_t v___x_1300_; 
v___x_1300_ = lean_nat_dec_lt(v_lo_1287_, v_hi_1288_);
if (v___x_1300_ == 0)
{
lean_dec(v_lo_1287_);
return v_as_1286_;
}
else
{
lean_object* v___x_1301_; lean_object* v___x_1302_; lean_object* v_mid_1303_; lean_object* v___y_1305_; lean_object* v___y_1311_; lean_object* v___x_1316_; lean_object* v___x_1317_; uint8_t v___x_1318_; 
v___x_1301_ = lean_nat_add(v_lo_1287_, v_hi_1288_);
v___x_1302_ = lean_unsigned_to_nat(1u);
v_mid_1303_ = lean_nat_shiftr(v___x_1301_, v___x_1302_);
lean_dec(v___x_1301_);
v___x_1316_ = lean_array_fget_borrowed(v_as_1286_, v_mid_1303_);
v___x_1317_ = lean_array_fget_borrowed(v_as_1286_, v_lo_1287_);
v___x_1318_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___lam__0(v___x_1316_, v___x_1317_);
if (v___x_1318_ == 0)
{
v___y_1311_ = v_as_1286_;
goto v___jp_1310_;
}
else
{
lean_object* v___x_1319_; 
v___x_1319_ = lean_array_fswap(v_as_1286_, v_lo_1287_, v_mid_1303_);
v___y_1311_ = v___x_1319_;
goto v___jp_1310_;
}
v___jp_1304_:
{
lean_object* v___x_1306_; lean_object* v___x_1307_; uint8_t v___x_1308_; 
v___x_1306_ = lean_array_fget_borrowed(v___y_1305_, v_mid_1303_);
v___x_1307_ = lean_array_fget_borrowed(v___y_1305_, v_hi_1288_);
v___x_1308_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___lam__0(v___x_1306_, v___x_1307_);
if (v___x_1308_ == 0)
{
lean_dec(v_mid_1303_);
v___y_1290_ = v___y_1305_;
goto v___jp_1289_;
}
else
{
lean_object* v___x_1309_; 
v___x_1309_ = lean_array_fswap(v___y_1305_, v_mid_1303_, v_hi_1288_);
lean_dec(v_mid_1303_);
v___y_1290_ = v___x_1309_;
goto v___jp_1289_;
}
}
v___jp_1310_:
{
lean_object* v___x_1312_; lean_object* v___x_1313_; uint8_t v___x_1314_; 
v___x_1312_ = lean_array_fget_borrowed(v___y_1311_, v_hi_1288_);
v___x_1313_ = lean_array_fget_borrowed(v___y_1311_, v_lo_1287_);
v___x_1314_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___lam__0(v___x_1312_, v___x_1313_);
if (v___x_1314_ == 0)
{
v___y_1305_ = v___y_1311_;
goto v___jp_1304_;
}
else
{
lean_object* v___x_1315_; 
v___x_1315_ = lean_array_fswap(v___y_1311_, v_lo_1287_, v_hi_1288_);
v___y_1305_ = v___x_1315_;
goto v___jp_1304_;
}
}
}
v___jp_1289_:
{
lean_object* v_pivot_1291_; lean_object* v___x_1292_; lean_object* v_fst_1293_; lean_object* v_snd_1294_; uint8_t v___x_1295_; 
v_pivot_1291_ = lean_array_fget(v___y_1290_, v_hi_1288_);
lean_inc_n(v_lo_1287_, 2);
v___x_1292_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1___redArg(v_hi_1288_, v_pivot_1291_, v___y_1290_, v_lo_1287_, v_lo_1287_);
lean_dec(v_pivot_1291_);
v_fst_1293_ = lean_ctor_get(v___x_1292_, 0);
lean_inc(v_fst_1293_);
v_snd_1294_ = lean_ctor_get(v___x_1292_, 1);
lean_inc(v_snd_1294_);
lean_dec_ref(v___x_1292_);
v___x_1295_ = lean_nat_dec_le(v_hi_1288_, v_fst_1293_);
if (v___x_1295_ == 0)
{
lean_object* v___x_1296_; lean_object* v___x_1297_; lean_object* v___x_1298_; 
v___x_1296_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg(v_n_1285_, v_snd_1294_, v_lo_1287_, v_fst_1293_);
v___x_1297_ = lean_unsigned_to_nat(1u);
v___x_1298_ = lean_nat_add(v_fst_1293_, v___x_1297_);
lean_dec(v_fst_1293_);
v_as_1286_ = v___x_1296_;
v_lo_1287_ = v___x_1298_;
goto _start;
}
else
{
lean_dec(v_fst_1293_);
lean_dec(v_lo_1287_);
return v_snd_1294_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg___boxed(lean_object* v_n_1320_, lean_object* v_as_1321_, lean_object* v_lo_1322_, lean_object* v_hi_1323_){
_start:
{
lean_object* v_res_1324_; 
v_res_1324_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg(v_n_1320_, v_as_1321_, v_lo_1322_, v_hi_1323_);
lean_dec(v_hi_1323_);
lean_dec(v_n_1320_);
return v_res_1324_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__2(lean_object* v_x_1325_, lean_object* v_x_1326_){
_start:
{
if (lean_obj_tag(v_x_1326_) == 0)
{
return v_x_1325_;
}
else
{
lean_object* v_key_1327_; lean_object* v_value_1328_; lean_object* v_tail_1329_; lean_object* v___x_1330_; lean_object* v___x_1331_; 
v_key_1327_ = lean_ctor_get(v_x_1326_, 0);
v_value_1328_ = lean_ctor_get(v_x_1326_, 1);
v_tail_1329_ = lean_ctor_get(v_x_1326_, 2);
lean_inc(v_value_1328_);
lean_inc(v_key_1327_);
v___x_1330_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1330_, 0, v_key_1327_);
lean_ctor_set(v___x_1330_, 1, v_value_1328_);
v___x_1331_ = lean_array_push(v_x_1325_, v___x_1330_);
v_x_1325_ = v___x_1331_;
v_x_1326_ = v_tail_1329_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__2___boxed(lean_object* v_x_1333_, lean_object* v_x_1334_){
_start:
{
lean_object* v_res_1335_; 
v_res_1335_ = l_Std_DHashMap_Internal_AssocList_foldlM___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__2(v_x_1333_, v_x_1334_);
lean_dec(v_x_1334_);
return v_res_1335_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__3(lean_object* v_as_1336_, size_t v_i_1337_, size_t v_stop_1338_, lean_object* v_b_1339_){
_start:
{
uint8_t v___x_1340_; 
v___x_1340_ = lean_usize_dec_eq(v_i_1337_, v_stop_1338_);
if (v___x_1340_ == 0)
{
lean_object* v___x_1341_; lean_object* v___x_1342_; size_t v___x_1343_; size_t v___x_1344_; 
v___x_1341_ = lean_array_uget_borrowed(v_as_1336_, v_i_1337_);
v___x_1342_ = l_Std_DHashMap_Internal_AssocList_foldlM___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__2(v_b_1339_, v___x_1341_);
v___x_1343_ = ((size_t)1ULL);
v___x_1344_ = lean_usize_add(v_i_1337_, v___x_1343_);
v_i_1337_ = v___x_1344_;
v_b_1339_ = v___x_1342_;
goto _start;
}
else
{
return v_b_1339_;
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__3___boxed(lean_object* v_as_1346_, lean_object* v_i_1347_, lean_object* v_stop_1348_, lean_object* v_b_1349_){
_start:
{
size_t v_i_boxed_1350_; size_t v_stop_boxed_1351_; lean_object* v_res_1352_; 
v_i_boxed_1350_ = lean_unbox_usize(v_i_1347_);
lean_dec(v_i_1347_);
v_stop_boxed_1351_ = lean_unbox_usize(v_stop_1348_);
lean_dec(v_stop_1348_);
v_res_1352_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__3(v_as_1346_, v_i_boxed_1350_, v_stop_boxed_1351_, v_b_1349_);
lean_dec_ref(v_as_1346_);
return v_res_1352_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__0(size_t v_sz_1353_, size_t v_i_1354_, lean_object* v_bs_1355_){
_start:
{
uint8_t v___x_1356_; 
v___x_1356_ = lean_usize_dec_lt(v_i_1354_, v_sz_1353_);
if (v___x_1356_ == 0)
{
return v_bs_1355_;
}
else
{
lean_object* v_v_1357_; lean_object* v_snd_1358_; lean_object* v_fst_1359_; lean_object* v___x_1361_; uint8_t v_isShared_1362_; uint8_t v_isSharedCheck_1373_; 
v_v_1357_ = lean_array_uget(v_bs_1355_, v_i_1354_);
v_snd_1358_ = lean_ctor_get(v_v_1357_, 1);
v_fst_1359_ = lean_ctor_get(v_v_1357_, 0);
v_isSharedCheck_1373_ = !lean_is_exclusive(v_v_1357_);
if (v_isSharedCheck_1373_ == 0)
{
v___x_1361_ = v_v_1357_;
v_isShared_1362_ = v_isSharedCheck_1373_;
goto v_resetjp_1360_;
}
else
{
lean_inc(v_snd_1358_);
lean_inc(v_fst_1359_);
lean_dec(v_v_1357_);
v___x_1361_ = lean_box(0);
v_isShared_1362_ = v_isSharedCheck_1373_;
goto v_resetjp_1360_;
}
v_resetjp_1360_:
{
lean_object* v_width_1363_; lean_object* v___x_1364_; lean_object* v_bs_x27_1365_; lean_object* v___x_1367_; 
v_width_1363_ = lean_ctor_get(v_snd_1358_, 0);
lean_inc(v_width_1363_);
lean_dec(v_snd_1358_);
v___x_1364_ = lean_unsigned_to_nat(0u);
v_bs_x27_1365_ = lean_array_uset(v_bs_1355_, v_i_1354_, v___x_1364_);
if (v_isShared_1362_ == 0)
{
lean_ctor_set(v___x_1361_, 1, v_fst_1359_);
lean_ctor_set(v___x_1361_, 0, v_width_1363_);
v___x_1367_ = v___x_1361_;
goto v_reusejp_1366_;
}
else
{
lean_object* v_reuseFailAlloc_1372_; 
v_reuseFailAlloc_1372_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1372_, 0, v_width_1363_);
lean_ctor_set(v_reuseFailAlloc_1372_, 1, v_fst_1359_);
v___x_1367_ = v_reuseFailAlloc_1372_;
goto v_reusejp_1366_;
}
v_reusejp_1366_:
{
size_t v___x_1368_; size_t v___x_1369_; lean_object* v___x_1370_; 
v___x_1368_ = ((size_t)1ULL);
v___x_1369_ = lean_usize_add(v_i_1354_, v___x_1368_);
v___x_1370_ = lean_array_uset(v_bs_x27_1365_, v_i_1354_, v___x_1367_);
v_i_1354_ = v___x_1369_;
v_bs_1355_ = v___x_1370_;
goto _start;
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__0___boxed(lean_object* v_sz_1374_, lean_object* v_i_1375_, lean_object* v_bs_1376_){
_start:
{
size_t v_sz_boxed_1377_; size_t v_i_boxed_1378_; lean_object* v_res_1379_; 
v_sz_boxed_1377_ = lean_unbox_usize(v_sz_1374_);
lean_dec(v_sz_1374_);
v_i_boxed_1378_ = lean_unbox_usize(v_i_1375_);
lean_dec(v_i_1375_);
v_res_1379_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__0(v_sz_boxed_1377_, v_i_boxed_1378_, v_bs_1376_);
return v_res_1379_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atoms___redArg(lean_object* v_a_1380_){
_start:
{
lean_object* v___x_1382_; lean_object* v___y_1384_; lean_object* v___y_1390_; lean_object* v___y_1391_; lean_object* v___y_1392_; lean_object* v___y_1393_; lean_object* v___y_1396_; lean_object* v___y_1397_; lean_object* v___y_1398_; lean_object* v___y_1399_; lean_object* v___y_1402_; lean_object* v_atoms_1409_; lean_object* v_size_1410_; lean_object* v_buckets_1411_; lean_object* v___x_1412_; lean_object* v___x_1413_; lean_object* v___x_1414_; uint8_t v___x_1415_; 
v___x_1382_ = lean_st_ref_get(v_a_1380_);
v_atoms_1409_ = lean_ctor_get(v___x_1382_, 0);
lean_inc_ref(v_atoms_1409_);
lean_dec(v___x_1382_);
v_size_1410_ = lean_ctor_get(v_atoms_1409_, 0);
lean_inc(v_size_1410_);
v_buckets_1411_ = lean_ctor_get(v_atoms_1409_, 1);
lean_inc_ref(v_buckets_1411_);
lean_dec_ref(v_atoms_1409_);
v___x_1412_ = lean_mk_empty_array_with_capacity(v_size_1410_);
lean_dec(v_size_1410_);
v___x_1413_ = lean_unsigned_to_nat(0u);
v___x_1414_ = lean_array_get_size(v_buckets_1411_);
v___x_1415_ = lean_nat_dec_lt(v___x_1413_, v___x_1414_);
if (v___x_1415_ == 0)
{
lean_dec_ref(v_buckets_1411_);
v___y_1402_ = v___x_1412_;
goto v___jp_1401_;
}
else
{
uint8_t v___x_1416_; 
v___x_1416_ = lean_nat_dec_le(v___x_1414_, v___x_1414_);
if (v___x_1416_ == 0)
{
if (v___x_1415_ == 0)
{
lean_dec_ref(v_buckets_1411_);
v___y_1402_ = v___x_1412_;
goto v___jp_1401_;
}
else
{
size_t v___x_1417_; size_t v___x_1418_; lean_object* v___x_1419_; 
v___x_1417_ = ((size_t)0ULL);
v___x_1418_ = lean_usize_of_nat(v___x_1414_);
v___x_1419_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__3(v_buckets_1411_, v___x_1417_, v___x_1418_, v___x_1412_);
lean_dec_ref(v_buckets_1411_);
v___y_1402_ = v___x_1419_;
goto v___jp_1401_;
}
}
else
{
size_t v___x_1420_; size_t v___x_1421_; lean_object* v___x_1422_; 
v___x_1420_ = ((size_t)0ULL);
v___x_1421_ = lean_usize_of_nat(v___x_1414_);
v___x_1422_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__3(v_buckets_1411_, v___x_1420_, v___x_1421_, v___x_1412_);
lean_dec_ref(v_buckets_1411_);
v___y_1402_ = v___x_1422_;
goto v___jp_1401_;
}
}
v___jp_1383_:
{
size_t v_sz_1385_; size_t v___x_1386_; lean_object* v___x_1387_; lean_object* v___x_1388_; 
v_sz_1385_ = lean_array_size(v___y_1384_);
v___x_1386_ = ((size_t)0ULL);
v___x_1387_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__0(v_sz_1385_, v___x_1386_, v___y_1384_);
v___x_1388_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1388_, 0, v___x_1387_);
return v___x_1388_;
}
v___jp_1389_:
{
lean_object* v___x_1394_; 
v___x_1394_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg(v___y_1391_, v___y_1390_, v___y_1392_, v___y_1393_);
lean_dec(v___y_1393_);
lean_dec(v___y_1391_);
v___y_1384_ = v___x_1394_;
goto v___jp_1383_;
}
v___jp_1395_:
{
uint8_t v___x_1400_; 
v___x_1400_ = lean_nat_dec_le(v___y_1399_, v___y_1398_);
if (v___x_1400_ == 0)
{
lean_dec(v___y_1398_);
lean_inc(v___y_1399_);
v___y_1390_ = v___y_1397_;
v___y_1391_ = v___y_1396_;
v___y_1392_ = v___y_1399_;
v___y_1393_ = v___y_1399_;
goto v___jp_1389_;
}
else
{
v___y_1390_ = v___y_1397_;
v___y_1391_ = v___y_1396_;
v___y_1392_ = v___y_1399_;
v___y_1393_ = v___y_1398_;
goto v___jp_1389_;
}
}
v___jp_1401_:
{
lean_object* v___x_1403_; lean_object* v___x_1404_; uint8_t v___x_1405_; 
v___x_1403_ = lean_array_get_size(v___y_1402_);
v___x_1404_ = lean_unsigned_to_nat(0u);
v___x_1405_ = lean_nat_dec_eq(v___x_1403_, v___x_1404_);
if (v___x_1405_ == 0)
{
lean_object* v___x_1406_; lean_object* v___x_1407_; uint8_t v___x_1408_; 
v___x_1406_ = lean_unsigned_to_nat(1u);
v___x_1407_ = lean_nat_sub(v___x_1403_, v___x_1406_);
v___x_1408_ = lean_nat_dec_le(v___x_1404_, v___x_1407_);
if (v___x_1408_ == 0)
{
lean_inc(v___x_1407_);
v___y_1396_ = v___x_1403_;
v___y_1397_ = v___y_1402_;
v___y_1398_ = v___x_1407_;
v___y_1399_ = v___x_1407_;
goto v___jp_1395_;
}
else
{
v___y_1396_ = v___x_1403_;
v___y_1397_ = v___y_1402_;
v___y_1398_ = v___x_1407_;
v___y_1399_ = v___x_1404_;
goto v___jp_1395_;
}
}
else
{
v___y_1384_ = v___y_1402_;
goto v___jp_1383_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atoms___redArg___boxed(lean_object* v_a_1423_, lean_object* v_a_1424_){
_start:
{
lean_object* v_res_1425_; 
v_res_1425_ = l_Lean_Meta_Tactic_BVDecide_M_atoms___redArg(v_a_1423_);
lean_dec(v_a_1423_);
return v_res_1425_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atoms(lean_object* v_a_1426_, lean_object* v_a_1427_, lean_object* v_a_1428_, lean_object* v_a_1429_, lean_object* v_a_1430_, lean_object* v_a_1431_, lean_object* v_a_1432_, lean_object* v_a_1433_){
_start:
{
lean_object* v___x_1435_; 
v___x_1435_ = l_Lean_Meta_Tactic_BVDecide_M_atoms___redArg(v_a_1427_);
return v___x_1435_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atoms___boxed(lean_object* v_a_1436_, lean_object* v_a_1437_, lean_object* v_a_1438_, lean_object* v_a_1439_, lean_object* v_a_1440_, lean_object* v_a_1441_, lean_object* v_a_1442_, lean_object* v_a_1443_, lean_object* v_a_1444_){
_start:
{
lean_object* v_res_1445_; 
v_res_1445_ = l_Lean_Meta_Tactic_BVDecide_M_atoms(v_a_1436_, v_a_1437_, v_a_1438_, v_a_1439_, v_a_1440_, v_a_1441_, v_a_1442_, v_a_1443_);
lean_dec(v_a_1443_);
lean_dec_ref(v_a_1442_);
lean_dec(v_a_1441_);
lean_dec_ref(v_a_1440_);
lean_dec(v_a_1439_);
lean_dec_ref(v_a_1438_);
lean_dec(v_a_1437_);
lean_dec_ref(v_a_1436_);
return v_res_1445_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1(lean_object* v_n_1446_, lean_object* v_as_1447_, lean_object* v_lo_1448_, lean_object* v_hi_1449_, lean_object* v_w_1450_, lean_object* v_hlo_1451_, lean_object* v_hhi_1452_){
_start:
{
lean_object* v___x_1453_; 
v___x_1453_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___redArg(v_n_1446_, v_as_1447_, v_lo_1448_, v_hi_1449_);
return v___x_1453_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1___boxed(lean_object* v_n_1454_, lean_object* v_as_1455_, lean_object* v_lo_1456_, lean_object* v_hi_1457_, lean_object* v_w_1458_, lean_object* v_hlo_1459_, lean_object* v_hhi_1460_){
_start:
{
lean_object* v_res_1461_; 
v_res_1461_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1(v_n_1454_, v_as_1455_, v_lo_1456_, v_hi_1457_, v_w_1458_, v_hlo_1459_, v_hhi_1460_);
lean_dec(v_hi_1457_);
lean_dec(v_n_1454_);
return v_res_1461_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1(lean_object* v_n_1462_, lean_object* v_lo_1463_, lean_object* v_hi_1464_, lean_object* v_hhi_1465_, lean_object* v_pivot_1466_, lean_object* v_as_1467_, lean_object* v_i_1468_, lean_object* v_k_1469_, lean_object* v_ilo_1470_, lean_object* v_ik_1471_, lean_object* v_w_1472_){
_start:
{
lean_object* v___x_1473_; 
v___x_1473_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1___redArg(v_hi_1464_, v_pivot_1466_, v_as_1467_, v_i_1468_, v_k_1469_);
return v___x_1473_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1___boxed(lean_object* v_n_1474_, lean_object* v_lo_1475_, lean_object* v_hi_1476_, lean_object* v_hhi_1477_, lean_object* v_pivot_1478_, lean_object* v_as_1479_, lean_object* v_i_1480_, lean_object* v_k_1481_, lean_object* v_ilo_1482_, lean_object* v_ik_1483_, lean_object* v_w_1484_){
_start:
{
lean_object* v_res_1485_; 
v_res_1485_ = l___private_Init_Data_Array_QSort_Basic_0__Array_qpartition_loop___at___00__private_Init_Data_Array_QSort_Basic_0__Array_qsort_sort___at___00Lean_Meta_Tactic_BVDecide_M_atoms_spec__1_spec__1(v_n_1474_, v_lo_1475_, v_hi_1476_, v_hhi_1477_, v_pivot_1478_, v_as_1479_, v_i_1480_, v_k_1481_, v_ilo_1482_, v_ik_1483_, v_w_1484_);
lean_dec_ref(v_pivot_1478_);
lean_dec(v_hi_1476_);
lean_dec(v_lo_1475_);
lean_dec(v_n_1474_);
return v_res_1485_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___lam__0(lean_object* v___x_1487_, lean_object* v___x_1488_, lean_object* v___x_1489_, lean_object* v___x_1490_, lean_object* v___x_1491_, lean_object* v___x_1492_, lean_object* v_x_1493_){
_start:
{
lean_object* v_fst_1494_; lean_object* v_snd_1495_; lean_object* v___x_1496_; lean_object* v___x_1497_; lean_object* v___x_1498_; lean_object* v___x_1499_; lean_object* v___x_1500_; 
v_fst_1494_ = lean_ctor_get(v_x_1493_, 0);
lean_inc(v_fst_1494_);
v_snd_1495_ = lean_ctor_get(v_x_1493_, 1);
lean_inc(v_snd_1495_);
lean_dec_ref(v_x_1493_);
v___x_1496_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___lam__0___closed__0));
v___x_1497_ = l_Lean_Name_mkStr6(v___x_1487_, v___x_1488_, v___x_1489_, v___x_1490_, v___x_1491_, v___x_1496_);
v___x_1498_ = l_Lean_mkConst(v___x_1497_, v___x_1492_);
v___x_1499_ = l_Lean_mkNatLit(v_fst_1494_);
v___x_1500_ = l_Lean_mkAppB(v___x_1498_, v___x_1499_, v_snd_1495_);
return v___x_1500_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0_spec__0(lean_object* v_msgData_1501_, lean_object* v___y_1502_, lean_object* v___y_1503_, lean_object* v___y_1504_, lean_object* v___y_1505_){
_start:
{
lean_object* v___x_1507_; lean_object* v_env_1508_; lean_object* v___x_1509_; lean_object* v_mctx_1510_; lean_object* v_lctx_1511_; lean_object* v_options_1512_; lean_object* v___x_1513_; lean_object* v___x_1514_; lean_object* v___x_1515_; 
v___x_1507_ = lean_st_ref_get(v___y_1505_);
v_env_1508_ = lean_ctor_get(v___x_1507_, 0);
lean_inc_ref(v_env_1508_);
lean_dec(v___x_1507_);
v___x_1509_ = lean_st_ref_get(v___y_1503_);
v_mctx_1510_ = lean_ctor_get(v___x_1509_, 0);
lean_inc_ref(v_mctx_1510_);
lean_dec(v___x_1509_);
v_lctx_1511_ = lean_ctor_get(v___y_1502_, 2);
v_options_1512_ = lean_ctor_get(v___y_1504_, 2);
lean_inc_ref(v_options_1512_);
lean_inc_ref(v_lctx_1511_);
v___x_1513_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_1513_, 0, v_env_1508_);
lean_ctor_set(v___x_1513_, 1, v_mctx_1510_);
lean_ctor_set(v___x_1513_, 2, v_lctx_1511_);
lean_ctor_set(v___x_1513_, 3, v_options_1512_);
v___x_1514_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v___x_1514_, 0, v___x_1513_);
lean_ctor_set(v___x_1514_, 1, v_msgData_1501_);
v___x_1515_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1515_, 0, v___x_1514_);
return v___x_1515_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0_spec__0___boxed(lean_object* v_msgData_1516_, lean_object* v___y_1517_, lean_object* v___y_1518_, lean_object* v___y_1519_, lean_object* v___y_1520_, lean_object* v___y_1521_){
_start:
{
lean_object* v_res_1522_; 
v_res_1522_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0_spec__0(v_msgData_1516_, v___y_1517_, v___y_1518_, v___y_1519_, v___y_1520_);
lean_dec(v___y_1520_);
lean_dec_ref(v___y_1519_);
lean_dec(v___y_1518_);
lean_dec_ref(v___y_1517_);
return v_res_1522_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0___redArg(lean_object* v_msg_1523_, lean_object* v___y_1524_, lean_object* v___y_1525_, lean_object* v___y_1526_, lean_object* v___y_1527_){
_start:
{
lean_object* v_ref_1529_; lean_object* v___x_1530_; lean_object* v_a_1531_; lean_object* v___x_1533_; uint8_t v_isShared_1534_; uint8_t v_isSharedCheck_1539_; 
v_ref_1529_ = lean_ctor_get(v___y_1526_, 5);
v___x_1530_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0_spec__0(v_msg_1523_, v___y_1524_, v___y_1525_, v___y_1526_, v___y_1527_);
v_a_1531_ = lean_ctor_get(v___x_1530_, 0);
v_isSharedCheck_1539_ = !lean_is_exclusive(v___x_1530_);
if (v_isSharedCheck_1539_ == 0)
{
v___x_1533_ = v___x_1530_;
v_isShared_1534_ = v_isSharedCheck_1539_;
goto v_resetjp_1532_;
}
else
{
lean_inc(v_a_1531_);
lean_dec(v___x_1530_);
v___x_1533_ = lean_box(0);
v_isShared_1534_ = v_isSharedCheck_1539_;
goto v_resetjp_1532_;
}
v_resetjp_1532_:
{
lean_object* v___x_1535_; lean_object* v___x_1537_; 
lean_inc(v_ref_1529_);
v___x_1535_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1535_, 0, v_ref_1529_);
lean_ctor_set(v___x_1535_, 1, v_a_1531_);
if (v_isShared_1534_ == 0)
{
lean_ctor_set_tag(v___x_1533_, 1);
lean_ctor_set(v___x_1533_, 0, v___x_1535_);
v___x_1537_ = v___x_1533_;
goto v_reusejp_1536_;
}
else
{
lean_object* v_reuseFailAlloc_1538_; 
v_reuseFailAlloc_1538_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1538_, 0, v___x_1535_);
v___x_1537_ = v_reuseFailAlloc_1538_;
goto v_reusejp_1536_;
}
v_reusejp_1536_:
{
return v___x_1537_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0___redArg___boxed(lean_object* v_msg_1540_, lean_object* v___y_1541_, lean_object* v___y_1542_, lean_object* v___y_1543_, lean_object* v___y_1544_, lean_object* v___y_1545_){
_start:
{
lean_object* v_res_1546_; 
v_res_1546_ = l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0___redArg(v_msg_1540_, v___y_1541_, v___y_1542_, v___y_1543_, v___y_1544_);
lean_dec(v___y_1544_);
lean_dec_ref(v___y_1543_);
lean_dec(v___y_1542_);
lean_dec_ref(v___y_1541_);
return v_res_1546_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__1(void){
_start:
{
lean_object* v___x_1548_; lean_object* v___x_1549_; 
v___x_1548_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__0));
v___x_1549_ = l_Lean_stringToMessageData(v___x_1548_);
return v___x_1549_;
}
}
static lean_object* _init_l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__5(void){
_start:
{
lean_object* v___x_1564_; lean_object* v___x_1565_; lean_object* v___x_1566_; 
v___x_1564_ = lean_box(0);
v___x_1565_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__3));
v___x_1566_ = l_Lean_mkConst(v___x_1565_, v___x_1564_);
return v___x_1566_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment(lean_object* v_a_1567_, lean_object* v_a_1568_, lean_object* v_a_1569_, lean_object* v_a_1570_, lean_object* v_a_1571_, lean_object* v_a_1572_, lean_object* v_a_1573_, lean_object* v_a_1574_){
_start:
{
lean_object* v___x_1576_; lean_object* v_a_1577_; lean_object* v___x_1578_; lean_object* v___x_1579_; uint8_t v___x_1580_; 
v___x_1576_ = l_Lean_Meta_Tactic_BVDecide_M_atoms___redArg(v_a_1568_);
v_a_1577_ = lean_ctor_get(v___x_1576_, 0);
lean_inc(v_a_1577_);
lean_dec_ref(v___x_1576_);
v___x_1578_ = lean_unsigned_to_nat(0u);
v___x_1579_ = lean_array_get_size(v_a_1577_);
v___x_1580_ = lean_nat_dec_lt(v___x_1578_, v___x_1579_);
if (v___x_1580_ == 0)
{
lean_object* v___x_1581_; lean_object* v___x_1582_; 
lean_dec(v_a_1577_);
v___x_1581_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__1, &l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__1_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__1);
v___x_1582_ = l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0___redArg(v___x_1581_, v_a_1571_, v_a_1572_, v_a_1573_, v_a_1574_);
return v___x_1582_;
}
else
{
lean_object* v___x_1583_; lean_object* v___f_1584_; lean_object* v___x_1585_; lean_object* v___x_1586_; 
v___x_1583_ = l_Lean_RArray_ofArray___redArg(v_a_1577_);
v___f_1584_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__4));
v___x_1585_ = lean_obj_once(&l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__5, &l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__5_once, _init_l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___closed__5);
v___x_1586_ = l_Lean_RArray_toExpr___redArg(v___x_1585_, v___f_1584_, v___x_1583_, v_a_1571_, v_a_1572_, v_a_1573_, v_a_1574_);
if (lean_obj_tag(v___x_1586_) == 0)
{
lean_object* v_a_1587_; lean_object* v___x_1589_; uint8_t v_isShared_1590_; uint8_t v_isSharedCheck_1615_; 
v_a_1587_ = lean_ctor_get(v___x_1586_, 0);
v_isSharedCheck_1615_ = !lean_is_exclusive(v___x_1586_);
if (v_isSharedCheck_1615_ == 0)
{
v___x_1589_ = v___x_1586_;
v_isShared_1590_ = v_isSharedCheck_1615_;
goto v_resetjp_1588_;
}
else
{
lean_inc(v_a_1587_);
lean_dec(v___x_1586_);
v___x_1589_ = lean_box(0);
v_isShared_1590_ = v_isSharedCheck_1615_;
goto v_resetjp_1588_;
}
v_resetjp_1588_:
{
lean_object* v___x_1591_; 
v___x_1591_ = l_Lean_Meta_Sym_shareCommon(v_a_1587_, v_a_1569_, v_a_1570_, v_a_1571_, v_a_1572_, v_a_1573_, v_a_1574_);
if (lean_obj_tag(v___x_1591_) == 0)
{
lean_object* v_a_1592_; lean_object* v___x_1594_; uint8_t v_isShared_1595_; uint8_t v_isSharedCheck_1614_; 
v_a_1592_ = lean_ctor_get(v___x_1591_, 0);
v_isSharedCheck_1614_ = !lean_is_exclusive(v___x_1591_);
if (v_isSharedCheck_1614_ == 0)
{
v___x_1594_ = v___x_1591_;
v_isShared_1595_ = v_isSharedCheck_1614_;
goto v_resetjp_1593_;
}
else
{
lean_inc(v_a_1592_);
lean_dec(v___x_1591_);
v___x_1594_ = lean_box(0);
v_isShared_1595_ = v_isSharedCheck_1614_;
goto v_resetjp_1593_;
}
v_resetjp_1593_:
{
lean_object* v___x_1596_; lean_object* v_atoms_1597_; lean_object* v_evalsAtCache_1598_; lean_object* v___x_1600_; uint8_t v_isShared_1601_; uint8_t v_isSharedCheck_1612_; 
v___x_1596_ = lean_st_ref_take(v_a_1568_);
v_atoms_1597_ = lean_ctor_get(v___x_1596_, 0);
v_evalsAtCache_1598_ = lean_ctor_get(v___x_1596_, 2);
v_isSharedCheck_1612_ = !lean_is_exclusive(v___x_1596_);
if (v_isSharedCheck_1612_ == 0)
{
lean_object* v_unused_1613_; 
v_unused_1613_ = lean_ctor_get(v___x_1596_, 1);
lean_dec(v_unused_1613_);
v___x_1600_ = v___x_1596_;
v_isShared_1601_ = v_isSharedCheck_1612_;
goto v_resetjp_1599_;
}
else
{
lean_inc(v_evalsAtCache_1598_);
lean_inc(v_atoms_1597_);
lean_dec(v___x_1596_);
v___x_1600_ = lean_box(0);
v_isShared_1601_ = v_isSharedCheck_1612_;
goto v_resetjp_1599_;
}
v_resetjp_1599_:
{
lean_object* v___x_1603_; 
lean_inc(v_a_1592_);
if (v_isShared_1590_ == 0)
{
lean_ctor_set_tag(v___x_1589_, 1);
lean_ctor_set(v___x_1589_, 0, v_a_1592_);
v___x_1603_ = v___x_1589_;
goto v_reusejp_1602_;
}
else
{
lean_object* v_reuseFailAlloc_1611_; 
v_reuseFailAlloc_1611_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1611_, 0, v_a_1592_);
v___x_1603_ = v_reuseFailAlloc_1611_;
goto v_reusejp_1602_;
}
v_reusejp_1602_:
{
lean_object* v___x_1605_; 
if (v_isShared_1601_ == 0)
{
lean_ctor_set(v___x_1600_, 1, v___x_1603_);
v___x_1605_ = v___x_1600_;
goto v_reusejp_1604_;
}
else
{
lean_object* v_reuseFailAlloc_1610_; 
v_reuseFailAlloc_1610_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v_reuseFailAlloc_1610_, 0, v_atoms_1597_);
lean_ctor_set(v_reuseFailAlloc_1610_, 1, v___x_1603_);
lean_ctor_set(v_reuseFailAlloc_1610_, 2, v_evalsAtCache_1598_);
v___x_1605_ = v_reuseFailAlloc_1610_;
goto v_reusejp_1604_;
}
v_reusejp_1604_:
{
lean_object* v___x_1606_; lean_object* v___x_1608_; 
v___x_1606_ = lean_st_ref_set(v_a_1568_, v___x_1605_);
if (v_isShared_1595_ == 0)
{
v___x_1608_ = v___x_1594_;
goto v_reusejp_1607_;
}
else
{
lean_object* v_reuseFailAlloc_1609_; 
v_reuseFailAlloc_1609_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1609_, 0, v_a_1592_);
v___x_1608_ = v_reuseFailAlloc_1609_;
goto v_reusejp_1607_;
}
v_reusejp_1607_:
{
return v___x_1608_;
}
}
}
}
}
}
else
{
lean_del_object(v___x_1589_);
return v___x_1591_;
}
}
}
else
{
return v___x_1586_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment___boxed(lean_object* v_a_1616_, lean_object* v_a_1617_, lean_object* v_a_1618_, lean_object* v_a_1619_, lean_object* v_a_1620_, lean_object* v_a_1621_, lean_object* v_a_1622_, lean_object* v_a_1623_, lean_object* v_a_1624_){
_start:
{
lean_object* v_res_1625_; 
v_res_1625_ = l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment(v_a_1616_, v_a_1617_, v_a_1618_, v_a_1619_, v_a_1620_, v_a_1621_, v_a_1622_, v_a_1623_);
lean_dec(v_a_1623_);
lean_dec_ref(v_a_1622_);
lean_dec(v_a_1621_);
lean_dec_ref(v_a_1620_);
lean_dec(v_a_1619_);
lean_dec_ref(v_a_1618_);
lean_dec(v_a_1617_);
lean_dec_ref(v_a_1616_);
return v_res_1625_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0(lean_object* v_00_u03b1_1626_, lean_object* v_msg_1627_, lean_object* v___y_1628_, lean_object* v___y_1629_, lean_object* v___y_1630_, lean_object* v___y_1631_, lean_object* v___y_1632_, lean_object* v___y_1633_, lean_object* v___y_1634_, lean_object* v___y_1635_){
_start:
{
lean_object* v___x_1637_; 
v___x_1637_ = l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0___redArg(v_msg_1627_, v___y_1632_, v___y_1633_, v___y_1634_, v___y_1635_);
return v___x_1637_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0___boxed(lean_object* v_00_u03b1_1638_, lean_object* v_msg_1639_, lean_object* v___y_1640_, lean_object* v___y_1641_, lean_object* v___y_1642_, lean_object* v___y_1643_, lean_object* v___y_1644_, lean_object* v___y_1645_, lean_object* v___y_1646_, lean_object* v___y_1647_, lean_object* v___y_1648_){
_start:
{
lean_object* v_res_1649_; 
v_res_1649_ = l_Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0(v_00_u03b1_1638_, v_msg_1639_, v___y_1640_, v___y_1641_, v___y_1642_, v___y_1643_, v___y_1644_, v___y_1645_, v___y_1646_, v___y_1647_);
lean_dec(v___y_1647_);
lean_dec_ref(v___y_1646_);
lean_dec(v___y_1645_);
lean_dec_ref(v___y_1644_);
lean_dec(v___y_1643_);
lean_dec_ref(v___y_1642_);
lean_dec(v___y_1641_);
lean_dec_ref(v___y_1640_);
return v_res_1649_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atomsAssignment(lean_object* v_a_1650_, lean_object* v_a_1651_, lean_object* v_a_1652_, lean_object* v_a_1653_, lean_object* v_a_1654_, lean_object* v_a_1655_, lean_object* v_a_1656_, lean_object* v_a_1657_){
_start:
{
lean_object* v___x_1659_; lean_object* v_atomsAssignmentCache_1660_; 
v___x_1659_ = lean_st_ref_get(v_a_1651_);
v_atomsAssignmentCache_1660_ = lean_ctor_get(v___x_1659_, 1);
lean_inc(v_atomsAssignmentCache_1660_);
lean_dec(v___x_1659_);
if (lean_obj_tag(v_atomsAssignmentCache_1660_) == 0)
{
lean_object* v___x_1661_; 
v___x_1661_ = l___private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment(v_a_1650_, v_a_1651_, v_a_1652_, v_a_1653_, v_a_1654_, v_a_1655_, v_a_1656_, v_a_1657_);
return v___x_1661_;
}
else
{
lean_object* v_val_1662_; lean_object* v___x_1664_; uint8_t v_isShared_1665_; uint8_t v_isSharedCheck_1669_; 
v_val_1662_ = lean_ctor_get(v_atomsAssignmentCache_1660_, 0);
v_isSharedCheck_1669_ = !lean_is_exclusive(v_atomsAssignmentCache_1660_);
if (v_isSharedCheck_1669_ == 0)
{
v___x_1664_ = v_atomsAssignmentCache_1660_;
v_isShared_1665_ = v_isSharedCheck_1669_;
goto v_resetjp_1663_;
}
else
{
lean_inc(v_val_1662_);
lean_dec(v_atomsAssignmentCache_1660_);
v___x_1664_ = lean_box(0);
v_isShared_1665_ = v_isSharedCheck_1669_;
goto v_resetjp_1663_;
}
v_resetjp_1663_:
{
lean_object* v___x_1667_; 
if (v_isShared_1665_ == 0)
{
lean_ctor_set_tag(v___x_1664_, 0);
v___x_1667_ = v___x_1664_;
goto v_reusejp_1666_;
}
else
{
lean_object* v_reuseFailAlloc_1668_; 
v_reuseFailAlloc_1668_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1668_, 0, v_val_1662_);
v___x_1667_ = v_reuseFailAlloc_1668_;
goto v_reusejp_1666_;
}
v_reusejp_1666_:
{
return v___x_1667_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_atomsAssignment___boxed(lean_object* v_a_1670_, lean_object* v_a_1671_, lean_object* v_a_1672_, lean_object* v_a_1673_, lean_object* v_a_1674_, lean_object* v_a_1675_, lean_object* v_a_1676_, lean_object* v_a_1677_, lean_object* v_a_1678_){
_start:
{
lean_object* v_res_1679_; 
v_res_1679_ = l_Lean_Meta_Tactic_BVDecide_M_atomsAssignment(v_a_1670_, v_a_1671_, v_a_1672_, v_a_1673_, v_a_1674_, v_a_1675_, v_a_1676_, v_a_1677_);
lean_dec(v_a_1677_);
lean_dec_ref(v_a_1676_);
lean_dec(v_a_1675_);
lean_dec_ref(v_a_1674_);
lean_dec(v_a_1673_);
lean_dec_ref(v_a_1672_);
lean_dec(v_a_1671_);
lean_dec_ref(v_a_1670_);
return v_res_1679_;
}
}
static lean_object* _init_l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__0(void){
_start:
{
lean_object* v___x_1680_; 
v___x_1680_ = l_instMonadEIO(lean_box(0));
return v___x_1680_;
}
}
LEAN_EXPORT lean_object* l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1(lean_object* v_msg_1685_, lean_object* v___y_1686_, lean_object* v___y_1687_, lean_object* v___y_1688_, lean_object* v___y_1689_, lean_object* v___y_1690_, lean_object* v___y_1691_, lean_object* v___y_1692_, lean_object* v___y_1693_){
_start:
{
lean_object* v___x_1695_; lean_object* v___x_1696_; lean_object* v_toApplicative_1697_; lean_object* v___x_1699_; uint8_t v_isShared_1700_; uint8_t v_isSharedCheck_1762_; 
v___x_1695_ = lean_obj_once(&l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__0, &l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__0_once, _init_l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__0);
v___x_1696_ = l_StateRefT_x27_instMonad___redArg(v___x_1695_);
v_toApplicative_1697_ = lean_ctor_get(v___x_1696_, 0);
v_isSharedCheck_1762_ = !lean_is_exclusive(v___x_1696_);
if (v_isSharedCheck_1762_ == 0)
{
lean_object* v_unused_1763_; 
v_unused_1763_ = lean_ctor_get(v___x_1696_, 1);
lean_dec(v_unused_1763_);
v___x_1699_ = v___x_1696_;
v_isShared_1700_ = v_isSharedCheck_1762_;
goto v_resetjp_1698_;
}
else
{
lean_inc(v_toApplicative_1697_);
lean_dec(v___x_1696_);
v___x_1699_ = lean_box(0);
v_isShared_1700_ = v_isSharedCheck_1762_;
goto v_resetjp_1698_;
}
v_resetjp_1698_:
{
lean_object* v_toFunctor_1701_; lean_object* v_toSeq_1702_; lean_object* v_toSeqLeft_1703_; lean_object* v_toSeqRight_1704_; lean_object* v___x_1706_; uint8_t v_isShared_1707_; uint8_t v_isSharedCheck_1760_; 
v_toFunctor_1701_ = lean_ctor_get(v_toApplicative_1697_, 0);
v_toSeq_1702_ = lean_ctor_get(v_toApplicative_1697_, 2);
v_toSeqLeft_1703_ = lean_ctor_get(v_toApplicative_1697_, 3);
v_toSeqRight_1704_ = lean_ctor_get(v_toApplicative_1697_, 4);
v_isSharedCheck_1760_ = !lean_is_exclusive(v_toApplicative_1697_);
if (v_isSharedCheck_1760_ == 0)
{
lean_object* v_unused_1761_; 
v_unused_1761_ = lean_ctor_get(v_toApplicative_1697_, 1);
lean_dec(v_unused_1761_);
v___x_1706_ = v_toApplicative_1697_;
v_isShared_1707_ = v_isSharedCheck_1760_;
goto v_resetjp_1705_;
}
else
{
lean_inc(v_toSeqRight_1704_);
lean_inc(v_toSeqLeft_1703_);
lean_inc(v_toSeq_1702_);
lean_inc(v_toFunctor_1701_);
lean_dec(v_toApplicative_1697_);
v___x_1706_ = lean_box(0);
v_isShared_1707_ = v_isSharedCheck_1760_;
goto v_resetjp_1705_;
}
v_resetjp_1705_:
{
lean_object* v___f_1708_; lean_object* v___f_1709_; lean_object* v___f_1710_; lean_object* v___f_1711_; lean_object* v___x_1712_; lean_object* v___f_1713_; lean_object* v___f_1714_; lean_object* v___f_1715_; lean_object* v___x_1717_; 
v___f_1708_ = ((lean_object*)(l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__1));
v___f_1709_ = ((lean_object*)(l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__2));
lean_inc_ref(v_toFunctor_1701_);
v___f_1710_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1710_, 0, v_toFunctor_1701_);
v___f_1711_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1711_, 0, v_toFunctor_1701_);
v___x_1712_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1712_, 0, v___f_1710_);
lean_ctor_set(v___x_1712_, 1, v___f_1711_);
v___f_1713_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1713_, 0, v_toSeqRight_1704_);
v___f_1714_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1714_, 0, v_toSeqLeft_1703_);
v___f_1715_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1715_, 0, v_toSeq_1702_);
if (v_isShared_1707_ == 0)
{
lean_ctor_set(v___x_1706_, 4, v___f_1713_);
lean_ctor_set(v___x_1706_, 3, v___f_1714_);
lean_ctor_set(v___x_1706_, 2, v___f_1715_);
lean_ctor_set(v___x_1706_, 1, v___f_1708_);
lean_ctor_set(v___x_1706_, 0, v___x_1712_);
v___x_1717_ = v___x_1706_;
goto v_reusejp_1716_;
}
else
{
lean_object* v_reuseFailAlloc_1759_; 
v_reuseFailAlloc_1759_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_1759_, 0, v___x_1712_);
lean_ctor_set(v_reuseFailAlloc_1759_, 1, v___f_1708_);
lean_ctor_set(v_reuseFailAlloc_1759_, 2, v___f_1715_);
lean_ctor_set(v_reuseFailAlloc_1759_, 3, v___f_1714_);
lean_ctor_set(v_reuseFailAlloc_1759_, 4, v___f_1713_);
v___x_1717_ = v_reuseFailAlloc_1759_;
goto v_reusejp_1716_;
}
v_reusejp_1716_:
{
lean_object* v___x_1719_; 
if (v_isShared_1700_ == 0)
{
lean_ctor_set(v___x_1699_, 1, v___f_1709_);
lean_ctor_set(v___x_1699_, 0, v___x_1717_);
v___x_1719_ = v___x_1699_;
goto v_reusejp_1718_;
}
else
{
lean_object* v_reuseFailAlloc_1758_; 
v_reuseFailAlloc_1758_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1758_, 0, v___x_1717_);
lean_ctor_set(v_reuseFailAlloc_1758_, 1, v___f_1709_);
v___x_1719_ = v_reuseFailAlloc_1758_;
goto v_reusejp_1718_;
}
v_reusejp_1718_:
{
lean_object* v___x_1720_; lean_object* v_toApplicative_1721_; lean_object* v___x_1723_; uint8_t v_isShared_1724_; uint8_t v_isSharedCheck_1756_; 
v___x_1720_ = l_StateRefT_x27_instMonad___redArg(v___x_1719_);
v_toApplicative_1721_ = lean_ctor_get(v___x_1720_, 0);
v_isSharedCheck_1756_ = !lean_is_exclusive(v___x_1720_);
if (v_isSharedCheck_1756_ == 0)
{
lean_object* v_unused_1757_; 
v_unused_1757_ = lean_ctor_get(v___x_1720_, 1);
lean_dec(v_unused_1757_);
v___x_1723_ = v___x_1720_;
v_isShared_1724_ = v_isSharedCheck_1756_;
goto v_resetjp_1722_;
}
else
{
lean_inc(v_toApplicative_1721_);
lean_dec(v___x_1720_);
v___x_1723_ = lean_box(0);
v_isShared_1724_ = v_isSharedCheck_1756_;
goto v_resetjp_1722_;
}
v_resetjp_1722_:
{
lean_object* v_toFunctor_1725_; lean_object* v_toSeq_1726_; lean_object* v_toSeqLeft_1727_; lean_object* v_toSeqRight_1728_; lean_object* v___x_1730_; uint8_t v_isShared_1731_; uint8_t v_isSharedCheck_1754_; 
v_toFunctor_1725_ = lean_ctor_get(v_toApplicative_1721_, 0);
v_toSeq_1726_ = lean_ctor_get(v_toApplicative_1721_, 2);
v_toSeqLeft_1727_ = lean_ctor_get(v_toApplicative_1721_, 3);
v_toSeqRight_1728_ = lean_ctor_get(v_toApplicative_1721_, 4);
v_isSharedCheck_1754_ = !lean_is_exclusive(v_toApplicative_1721_);
if (v_isSharedCheck_1754_ == 0)
{
lean_object* v_unused_1755_; 
v_unused_1755_ = lean_ctor_get(v_toApplicative_1721_, 1);
lean_dec(v_unused_1755_);
v___x_1730_ = v_toApplicative_1721_;
v_isShared_1731_ = v_isSharedCheck_1754_;
goto v_resetjp_1729_;
}
else
{
lean_inc(v_toSeqRight_1728_);
lean_inc(v_toSeqLeft_1727_);
lean_inc(v_toSeq_1726_);
lean_inc(v_toFunctor_1725_);
lean_dec(v_toApplicative_1721_);
v___x_1730_ = lean_box(0);
v_isShared_1731_ = v_isSharedCheck_1754_;
goto v_resetjp_1729_;
}
v_resetjp_1729_:
{
lean_object* v___f_1732_; lean_object* v___f_1733_; lean_object* v___f_1734_; lean_object* v___f_1735_; lean_object* v___x_1736_; lean_object* v___f_1737_; lean_object* v___f_1738_; lean_object* v___f_1739_; lean_object* v___x_1741_; 
v___f_1732_ = ((lean_object*)(l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__3));
v___f_1733_ = ((lean_object*)(l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___closed__4));
lean_inc_ref(v_toFunctor_1725_);
v___f_1734_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1734_, 0, v_toFunctor_1725_);
v___f_1735_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1735_, 0, v_toFunctor_1725_);
v___x_1736_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1736_, 0, v___f_1734_);
lean_ctor_set(v___x_1736_, 1, v___f_1735_);
v___f_1737_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1737_, 0, v_toSeqRight_1728_);
v___f_1738_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1738_, 0, v_toSeqLeft_1727_);
v___f_1739_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1739_, 0, v_toSeq_1726_);
if (v_isShared_1731_ == 0)
{
lean_ctor_set(v___x_1730_, 4, v___f_1737_);
lean_ctor_set(v___x_1730_, 3, v___f_1738_);
lean_ctor_set(v___x_1730_, 2, v___f_1739_);
lean_ctor_set(v___x_1730_, 1, v___f_1732_);
lean_ctor_set(v___x_1730_, 0, v___x_1736_);
v___x_1741_ = v___x_1730_;
goto v_reusejp_1740_;
}
else
{
lean_object* v_reuseFailAlloc_1753_; 
v_reuseFailAlloc_1753_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_1753_, 0, v___x_1736_);
lean_ctor_set(v_reuseFailAlloc_1753_, 1, v___f_1732_);
lean_ctor_set(v_reuseFailAlloc_1753_, 2, v___f_1739_);
lean_ctor_set(v_reuseFailAlloc_1753_, 3, v___f_1738_);
lean_ctor_set(v_reuseFailAlloc_1753_, 4, v___f_1737_);
v___x_1741_ = v_reuseFailAlloc_1753_;
goto v_reusejp_1740_;
}
v_reusejp_1740_:
{
lean_object* v___x_1743_; 
if (v_isShared_1724_ == 0)
{
lean_ctor_set(v___x_1723_, 1, v___f_1733_);
lean_ctor_set(v___x_1723_, 0, v___x_1741_);
v___x_1743_ = v___x_1723_;
goto v_reusejp_1742_;
}
else
{
lean_object* v_reuseFailAlloc_1752_; 
v_reuseFailAlloc_1752_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1752_, 0, v___x_1741_);
lean_ctor_set(v_reuseFailAlloc_1752_, 1, v___f_1733_);
v___x_1743_ = v_reuseFailAlloc_1752_;
goto v_reusejp_1742_;
}
v_reusejp_1742_:
{
lean_object* v___x_1744_; lean_object* v___x_1745_; lean_object* v___x_1746_; lean_object* v___x_1747_; lean_object* v___x_1748_; lean_object* v___f_1749_; lean_object* v___x_13012__overap_1750_; lean_object* v___x_1751_; 
v___x_1744_ = l_StateRefT_x27_instMonad___redArg(v___x_1743_);
v___x_1745_ = l_ReaderT_instMonad___redArg(v___x_1744_);
v___x_1746_ = l_StateRefT_x27_instMonad___redArg(v___x_1745_);
v___x_1747_ = lean_box(0);
v___x_1748_ = l_instInhabitedOfMonad___redArg(v___x_1746_, v___x_1747_);
v___f_1749_ = lean_alloc_closure((void*)(l_instInhabitedForall___redArg___lam__0___boxed), 2, 1);
lean_closure_set(v___f_1749_, 0, v___x_1748_);
v___x_13012__overap_1750_ = lean_panic_fn_borrowed(v___f_1749_, v_msg_1685_);
lean_dec_ref(v___f_1749_);
lean_inc(v___y_1693_);
lean_inc_ref(v___y_1692_);
lean_inc(v___y_1691_);
lean_inc_ref(v___y_1690_);
lean_inc(v___y_1689_);
lean_inc_ref(v___y_1688_);
lean_inc(v___y_1687_);
lean_inc_ref(v___y_1686_);
v___x_1751_ = lean_apply_9(v___x_13012__overap_1750_, v___y_1686_, v___y_1687_, v___y_1688_, v___y_1689_, v___y_1690_, v___y_1691_, v___y_1692_, v___y_1693_, lean_box(0));
return v___x_1751_;
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
LEAN_EXPORT lean_object* l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1___boxed(lean_object* v_msg_1764_, lean_object* v___y_1765_, lean_object* v___y_1766_, lean_object* v___y_1767_, lean_object* v___y_1768_, lean_object* v___y_1769_, lean_object* v___y_1770_, lean_object* v___y_1771_, lean_object* v___y_1772_, lean_object* v___y_1773_){
_start:
{
lean_object* v_res_1774_; 
v_res_1774_ = l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1(v_msg_1764_, v___y_1765_, v___y_1766_, v___y_1767_, v___y_1768_, v___y_1769_, v___y_1770_, v___y_1771_, v___y_1772_);
lean_dec(v___y_1772_);
lean_dec_ref(v___y_1771_);
lean_dec(v___y_1770_);
lean_dec_ref(v___y_1769_);
lean_dec(v___y_1768_);
lean_dec_ref(v___y_1767_);
lean_dec(v___y_1766_);
lean_dec_ref(v___y_1765_);
return v_res_1774_;
}
}
static double _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__0(void){
_start:
{
lean_object* v___x_1775_; double v___x_1776_; 
v___x_1775_ = lean_unsigned_to_nat(0u);
v___x_1776_ = lean_float_of_nat(v___x_1775_);
return v___x_1776_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg(lean_object* v_cls_1780_, lean_object* v_msg_1781_, lean_object* v___y_1782_, lean_object* v___y_1783_, lean_object* v___y_1784_, lean_object* v___y_1785_){
_start:
{
lean_object* v_ref_1787_; lean_object* v___x_1788_; lean_object* v_a_1789_; lean_object* v___x_1791_; uint8_t v_isShared_1792_; uint8_t v_isSharedCheck_1833_; 
v_ref_1787_ = lean_ctor_get(v___y_1784_, 5);
v___x_1788_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00__private_Lean_Meta_Tactic_BVDecide_Reflect_Basic_0__Lean_Meta_Tactic_BVDecide_M_atomsAssignment_updateAtomsAssignment_spec__0_spec__0(v_msg_1781_, v___y_1782_, v___y_1783_, v___y_1784_, v___y_1785_);
v_a_1789_ = lean_ctor_get(v___x_1788_, 0);
v_isSharedCheck_1833_ = !lean_is_exclusive(v___x_1788_);
if (v_isSharedCheck_1833_ == 0)
{
v___x_1791_ = v___x_1788_;
v_isShared_1792_ = v_isSharedCheck_1833_;
goto v_resetjp_1790_;
}
else
{
lean_inc(v_a_1789_);
lean_dec(v___x_1788_);
v___x_1791_ = lean_box(0);
v_isShared_1792_ = v_isSharedCheck_1833_;
goto v_resetjp_1790_;
}
v_resetjp_1790_:
{
lean_object* v___x_1793_; lean_object* v_traceState_1794_; lean_object* v_env_1795_; lean_object* v_nextMacroScope_1796_; lean_object* v_ngen_1797_; lean_object* v_auxDeclNGen_1798_; lean_object* v_cache_1799_; lean_object* v_messages_1800_; lean_object* v_infoState_1801_; lean_object* v_snapshotTasks_1802_; lean_object* v___x_1804_; uint8_t v_isShared_1805_; uint8_t v_isSharedCheck_1832_; 
v___x_1793_ = lean_st_ref_take(v___y_1785_);
v_traceState_1794_ = lean_ctor_get(v___x_1793_, 4);
v_env_1795_ = lean_ctor_get(v___x_1793_, 0);
v_nextMacroScope_1796_ = lean_ctor_get(v___x_1793_, 1);
v_ngen_1797_ = lean_ctor_get(v___x_1793_, 2);
v_auxDeclNGen_1798_ = lean_ctor_get(v___x_1793_, 3);
v_cache_1799_ = lean_ctor_get(v___x_1793_, 5);
v_messages_1800_ = lean_ctor_get(v___x_1793_, 6);
v_infoState_1801_ = lean_ctor_get(v___x_1793_, 7);
v_snapshotTasks_1802_ = lean_ctor_get(v___x_1793_, 8);
v_isSharedCheck_1832_ = !lean_is_exclusive(v___x_1793_);
if (v_isSharedCheck_1832_ == 0)
{
v___x_1804_ = v___x_1793_;
v_isShared_1805_ = v_isSharedCheck_1832_;
goto v_resetjp_1803_;
}
else
{
lean_inc(v_snapshotTasks_1802_);
lean_inc(v_infoState_1801_);
lean_inc(v_messages_1800_);
lean_inc(v_cache_1799_);
lean_inc(v_traceState_1794_);
lean_inc(v_auxDeclNGen_1798_);
lean_inc(v_ngen_1797_);
lean_inc(v_nextMacroScope_1796_);
lean_inc(v_env_1795_);
lean_dec(v___x_1793_);
v___x_1804_ = lean_box(0);
v_isShared_1805_ = v_isSharedCheck_1832_;
goto v_resetjp_1803_;
}
v_resetjp_1803_:
{
uint64_t v_tid_1806_; lean_object* v_traces_1807_; lean_object* v___x_1809_; uint8_t v_isShared_1810_; uint8_t v_isSharedCheck_1831_; 
v_tid_1806_ = lean_ctor_get_uint64(v_traceState_1794_, sizeof(void*)*1);
v_traces_1807_ = lean_ctor_get(v_traceState_1794_, 0);
v_isSharedCheck_1831_ = !lean_is_exclusive(v_traceState_1794_);
if (v_isSharedCheck_1831_ == 0)
{
v___x_1809_ = v_traceState_1794_;
v_isShared_1810_ = v_isSharedCheck_1831_;
goto v_resetjp_1808_;
}
else
{
lean_inc(v_traces_1807_);
lean_dec(v_traceState_1794_);
v___x_1809_ = lean_box(0);
v_isShared_1810_ = v_isSharedCheck_1831_;
goto v_resetjp_1808_;
}
v_resetjp_1808_:
{
lean_object* v___x_1811_; double v___x_1812_; uint8_t v___x_1813_; lean_object* v___x_1814_; lean_object* v___x_1815_; lean_object* v___x_1816_; lean_object* v___x_1817_; lean_object* v___x_1818_; lean_object* v___x_1819_; lean_object* v___x_1821_; 
v___x_1811_ = lean_box(0);
v___x_1812_ = lean_float_once(&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__0, &l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__0_once, _init_l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__0);
v___x_1813_ = 0;
v___x_1814_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__1));
v___x_1815_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v___x_1815_, 0, v_cls_1780_);
lean_ctor_set(v___x_1815_, 1, v___x_1811_);
lean_ctor_set(v___x_1815_, 2, v___x_1814_);
lean_ctor_set_float(v___x_1815_, sizeof(void*)*3, v___x_1812_);
lean_ctor_set_float(v___x_1815_, sizeof(void*)*3 + 8, v___x_1812_);
lean_ctor_set_uint8(v___x_1815_, sizeof(void*)*3 + 16, v___x_1813_);
v___x_1816_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___closed__2));
v___x_1817_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v___x_1817_, 0, v___x_1815_);
lean_ctor_set(v___x_1817_, 1, v_a_1789_);
lean_ctor_set(v___x_1817_, 2, v___x_1816_);
lean_inc(v_ref_1787_);
v___x_1818_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1818_, 0, v_ref_1787_);
lean_ctor_set(v___x_1818_, 1, v___x_1817_);
v___x_1819_ = l_Lean_PersistentArray_push___redArg(v_traces_1807_, v___x_1818_);
if (v_isShared_1810_ == 0)
{
lean_ctor_set(v___x_1809_, 0, v___x_1819_);
v___x_1821_ = v___x_1809_;
goto v_reusejp_1820_;
}
else
{
lean_object* v_reuseFailAlloc_1830_; 
v_reuseFailAlloc_1830_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_1830_, 0, v___x_1819_);
lean_ctor_set_uint64(v_reuseFailAlloc_1830_, sizeof(void*)*1, v_tid_1806_);
v___x_1821_ = v_reuseFailAlloc_1830_;
goto v_reusejp_1820_;
}
v_reusejp_1820_:
{
lean_object* v___x_1823_; 
if (v_isShared_1805_ == 0)
{
lean_ctor_set(v___x_1804_, 4, v___x_1821_);
v___x_1823_ = v___x_1804_;
goto v_reusejp_1822_;
}
else
{
lean_object* v_reuseFailAlloc_1829_; 
v_reuseFailAlloc_1829_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_1829_, 0, v_env_1795_);
lean_ctor_set(v_reuseFailAlloc_1829_, 1, v_nextMacroScope_1796_);
lean_ctor_set(v_reuseFailAlloc_1829_, 2, v_ngen_1797_);
lean_ctor_set(v_reuseFailAlloc_1829_, 3, v_auxDeclNGen_1798_);
lean_ctor_set(v_reuseFailAlloc_1829_, 4, v___x_1821_);
lean_ctor_set(v_reuseFailAlloc_1829_, 5, v_cache_1799_);
lean_ctor_set(v_reuseFailAlloc_1829_, 6, v_messages_1800_);
lean_ctor_set(v_reuseFailAlloc_1829_, 7, v_infoState_1801_);
lean_ctor_set(v_reuseFailAlloc_1829_, 8, v_snapshotTasks_1802_);
v___x_1823_ = v_reuseFailAlloc_1829_;
goto v_reusejp_1822_;
}
v_reusejp_1822_:
{
lean_object* v___x_1824_; lean_object* v___x_1825_; lean_object* v___x_1827_; 
v___x_1824_ = lean_st_ref_set(v___y_1785_, v___x_1823_);
v___x_1825_ = lean_box(0);
if (v_isShared_1792_ == 0)
{
lean_ctor_set(v___x_1791_, 0, v___x_1825_);
v___x_1827_ = v___x_1791_;
goto v_reusejp_1826_;
}
else
{
lean_object* v_reuseFailAlloc_1828_; 
v_reuseFailAlloc_1828_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1828_, 0, v___x_1825_);
v___x_1827_ = v_reuseFailAlloc_1828_;
goto v_reusejp_1826_;
}
v_reusejp_1826_:
{
return v___x_1827_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg___boxed(lean_object* v_cls_1834_, lean_object* v_msg_1835_, lean_object* v___y_1836_, lean_object* v___y_1837_, lean_object* v___y_1838_, lean_object* v___y_1839_, lean_object* v___y_1840_){
_start:
{
lean_object* v_res_1841_; 
v_res_1841_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg(v_cls_1834_, v_msg_1835_, v___y_1836_, v___y_1837_, v___y_1838_, v___y_1839_);
lean_dec(v___y_1839_);
lean_dec_ref(v___y_1838_);
lean_dec(v___y_1837_);
lean_dec_ref(v___y_1836_);
return v_res_1841_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__5(void){
_start:
{
lean_object* v___x_1851_; lean_object* v___x_1852_; lean_object* v___x_1853_; 
v___x_1851_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__2));
v___x_1852_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__4));
v___x_1853_ = l_Lean_Name_append(v___x_1852_, v___x_1851_);
return v___x_1853_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__7(void){
_start:
{
lean_object* v___x_1855_; lean_object* v___x_1856_; 
v___x_1855_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__6));
v___x_1856_ = l_Lean_stringToMessageData(v___x_1855_);
return v___x_1856_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__9(void){
_start:
{
lean_object* v___x_1858_; lean_object* v___x_1859_; 
v___x_1858_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__8));
v___x_1859_ = l_Lean_stringToMessageData(v___x_1858_);
return v___x_1859_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__11(void){
_start:
{
lean_object* v___x_1861_; lean_object* v___x_1862_; 
v___x_1861_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__10));
v___x_1862_ = l_Lean_stringToMessageData(v___x_1861_);
return v___x_1862_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__15(void){
_start:
{
lean_object* v___x_1866_; lean_object* v___x_1867_; lean_object* v___x_1868_; lean_object* v___x_1869_; lean_object* v___x_1870_; lean_object* v___x_1871_; 
v___x_1866_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__14));
v___x_1867_ = lean_unsigned_to_nat(6u);
v___x_1868_ = lean_unsigned_to_nat(318u);
v___x_1869_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__13));
v___x_1870_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__12));
v___x_1871_ = l_mkPanicMessageWithDecl(v___x_1870_, v___x_1869_, v___x_1868_, v___x_1867_, v___x_1866_);
return v___x_1871_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup(lean_object* v_e_1872_, lean_object* v_width_1873_, uint8_t v_synthetic_1874_, lean_object* v_a_1875_, lean_object* v_a_1876_, lean_object* v_a_1877_, lean_object* v_a_1878_, lean_object* v_a_1879_, lean_object* v_a_1880_, lean_object* v_a_1881_, lean_object* v_a_1882_){
_start:
{
lean_object* v___y_1885_; lean_object* v___x_1904_; lean_object* v_atoms_1905_; lean_object* v___x_1906_; 
v___x_1904_ = lean_st_ref_get(v_a_1876_);
v_atoms_1905_ = lean_ctor_get(v___x_1904_, 0);
lean_inc_ref(v_atoms_1905_);
lean_dec(v___x_1904_);
v___x_1906_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__0___redArg(v_atoms_1905_, v_e_1872_);
lean_dec_ref(v_atoms_1905_);
if (lean_obj_tag(v___x_1906_) == 0)
{
lean_object* v_options_1907_; uint8_t v_hasTrace_1908_; 
v_options_1907_ = lean_ctor_get(v_a_1881_, 2);
v_hasTrace_1908_ = lean_ctor_get_uint8(v_options_1907_, sizeof(void*)*1);
if (v_hasTrace_1908_ == 0)
{
v___y_1885_ = v_a_1876_;
goto v___jp_1884_;
}
else
{
lean_object* v_inheritedTraceOptions_1909_; lean_object* v___x_1910_; lean_object* v___x_1911_; uint8_t v___x_1912_; 
v_inheritedTraceOptions_1909_ = lean_ctor_get(v_a_1881_, 13);
v___x_1910_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__2));
v___x_1911_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__5, &l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__5_once, _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__5);
v___x_1912_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_1909_, v_options_1907_, v___x_1911_);
if (v___x_1912_ == 0)
{
v___y_1885_ = v_a_1876_;
goto v___jp_1884_;
}
else
{
lean_object* v___x_1913_; lean_object* v___x_1914_; lean_object* v___x_1915_; lean_object* v___x_1916_; lean_object* v___x_1917_; lean_object* v___x_1918_; lean_object* v___x_1919_; lean_object* v___y_1921_; 
v___x_1913_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__7, &l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__7);
lean_inc(v_width_1873_);
v___x_1914_ = l_Nat_reprFast(v_width_1873_);
v___x_1915_ = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(v___x_1915_, 0, v___x_1914_);
v___x_1916_ = l_Lean_MessageData_ofFormat(v___x_1915_);
v___x_1917_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1917_, 0, v___x_1913_);
lean_ctor_set(v___x_1917_, 1, v___x_1916_);
v___x_1918_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__9, &l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__9);
v___x_1919_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1919_, 0, v___x_1917_);
lean_ctor_set(v___x_1919_, 1, v___x_1918_);
if (v_synthetic_1874_ == 0)
{
lean_object* v___x_1938_; 
v___x_1938_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__7));
v___y_1921_ = v___x_1938_;
goto v___jp_1920_;
}
else
{
lean_object* v___x_1939_; 
v___x_1939_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_instToExprBoolExpr_go___redArg___closed__10));
v___y_1921_ = v___x_1939_;
goto v___jp_1920_;
}
v___jp_1920_:
{
lean_object* v___x_1922_; lean_object* v___x_1923_; lean_object* v___x_1924_; lean_object* v___x_1925_; lean_object* v___x_1926_; lean_object* v___x_1927_; lean_object* v___x_1928_; lean_object* v___x_1929_; 
lean_inc_ref(v___y_1921_);
v___x_1922_ = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(v___x_1922_, 0, v___y_1921_);
v___x_1923_ = l_Lean_MessageData_ofFormat(v___x_1922_);
v___x_1924_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1924_, 0, v___x_1919_);
lean_ctor_set(v___x_1924_, 1, v___x_1923_);
v___x_1925_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__11, &l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__11_once, _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__11);
v___x_1926_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1926_, 0, v___x_1924_);
lean_ctor_set(v___x_1926_, 1, v___x_1925_);
lean_inc_ref(v_e_1872_);
v___x_1927_ = l_Lean_MessageData_ofExpr(v_e_1872_);
v___x_1928_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1928_, 0, v___x_1926_);
lean_ctor_set(v___x_1928_, 1, v___x_1927_);
v___x_1929_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg(v___x_1910_, v___x_1928_, v_a_1879_, v_a_1880_, v_a_1881_, v_a_1882_);
if (lean_obj_tag(v___x_1929_) == 0)
{
lean_dec_ref_known(v___x_1929_, 1);
v___y_1885_ = v_a_1876_;
goto v___jp_1884_;
}
else
{
lean_object* v_a_1930_; lean_object* v___x_1932_; uint8_t v_isShared_1933_; uint8_t v_isSharedCheck_1937_; 
lean_dec(v_width_1873_);
lean_dec_ref(v_e_1872_);
v_a_1930_ = lean_ctor_get(v___x_1929_, 0);
v_isSharedCheck_1937_ = !lean_is_exclusive(v___x_1929_);
if (v_isSharedCheck_1937_ == 0)
{
v___x_1932_ = v___x_1929_;
v_isShared_1933_ = v_isSharedCheck_1937_;
goto v_resetjp_1931_;
}
else
{
lean_inc(v_a_1930_);
lean_dec(v___x_1929_);
v___x_1932_ = lean_box(0);
v_isShared_1933_ = v_isSharedCheck_1937_;
goto v_resetjp_1931_;
}
v_resetjp_1931_:
{
lean_object* v___x_1935_; 
if (v_isShared_1933_ == 0)
{
v___x_1935_ = v___x_1932_;
goto v_reusejp_1934_;
}
else
{
lean_object* v_reuseFailAlloc_1936_; 
v_reuseFailAlloc_1936_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1936_, 0, v_a_1930_);
v___x_1935_ = v_reuseFailAlloc_1936_;
goto v_reusejp_1934_;
}
v_reusejp_1934_:
{
return v___x_1935_;
}
}
}
}
}
}
}
else
{
lean_object* v_val_1940_; lean_object* v___x_1942_; uint8_t v_isShared_1943_; uint8_t v_isSharedCheck_1968_; 
lean_dec_ref(v_e_1872_);
v_val_1940_ = lean_ctor_get(v___x_1906_, 0);
v_isSharedCheck_1968_ = !lean_is_exclusive(v___x_1906_);
if (v_isSharedCheck_1968_ == 0)
{
v___x_1942_ = v___x_1906_;
v_isShared_1943_ = v_isSharedCheck_1968_;
goto v_resetjp_1941_;
}
else
{
lean_inc(v_val_1940_);
lean_dec(v___x_1906_);
v___x_1942_ = lean_box(0);
v_isShared_1943_ = v_isSharedCheck_1968_;
goto v_resetjp_1941_;
}
v_resetjp_1941_:
{
lean_object* v_width_1944_; lean_object* v_atomNumber_1945_; uint8_t v___x_1946_; 
v_width_1944_ = lean_ctor_get(v_val_1940_, 0);
lean_inc(v_width_1944_);
v_atomNumber_1945_ = lean_ctor_get(v_val_1940_, 1);
lean_inc(v_atomNumber_1945_);
lean_dec(v_val_1940_);
v___x_1946_ = lean_nat_dec_eq(v_width_1873_, v_width_1944_);
lean_dec(v_width_1944_);
lean_dec(v_width_1873_);
if (v___x_1946_ == 0)
{
lean_object* v___x_1947_; lean_object* v___x_1948_; 
lean_del_object(v___x_1942_);
v___x_1947_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__15, &l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__15_once, _init_l_Lean_Meta_Tactic_BVDecide_M_lookup___closed__15);
v___x_1948_ = l_panic___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__1(v___x_1947_, v_a_1875_, v_a_1876_, v_a_1877_, v_a_1878_, v_a_1879_, v_a_1880_, v_a_1881_, v_a_1882_);
if (lean_obj_tag(v___x_1948_) == 0)
{
lean_object* v___x_1950_; uint8_t v_isShared_1951_; uint8_t v_isSharedCheck_1955_; 
v_isSharedCheck_1955_ = !lean_is_exclusive(v___x_1948_);
if (v_isSharedCheck_1955_ == 0)
{
lean_object* v_unused_1956_; 
v_unused_1956_ = lean_ctor_get(v___x_1948_, 0);
lean_dec(v_unused_1956_);
v___x_1950_ = v___x_1948_;
v_isShared_1951_ = v_isSharedCheck_1955_;
goto v_resetjp_1949_;
}
else
{
lean_dec(v___x_1948_);
v___x_1950_ = lean_box(0);
v_isShared_1951_ = v_isSharedCheck_1955_;
goto v_resetjp_1949_;
}
v_resetjp_1949_:
{
lean_object* v___x_1953_; 
if (v_isShared_1951_ == 0)
{
lean_ctor_set(v___x_1950_, 0, v_atomNumber_1945_);
v___x_1953_ = v___x_1950_;
goto v_reusejp_1952_;
}
else
{
lean_object* v_reuseFailAlloc_1954_; 
v_reuseFailAlloc_1954_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1954_, 0, v_atomNumber_1945_);
v___x_1953_ = v_reuseFailAlloc_1954_;
goto v_reusejp_1952_;
}
v_reusejp_1952_:
{
return v___x_1953_;
}
}
}
else
{
lean_object* v_a_1957_; lean_object* v___x_1959_; uint8_t v_isShared_1960_; uint8_t v_isSharedCheck_1964_; 
lean_dec(v_atomNumber_1945_);
v_a_1957_ = lean_ctor_get(v___x_1948_, 0);
v_isSharedCheck_1964_ = !lean_is_exclusive(v___x_1948_);
if (v_isSharedCheck_1964_ == 0)
{
v___x_1959_ = v___x_1948_;
v_isShared_1960_ = v_isSharedCheck_1964_;
goto v_resetjp_1958_;
}
else
{
lean_inc(v_a_1957_);
lean_dec(v___x_1948_);
v___x_1959_ = lean_box(0);
v_isShared_1960_ = v_isSharedCheck_1964_;
goto v_resetjp_1958_;
}
v_resetjp_1958_:
{
lean_object* v___x_1962_; 
if (v_isShared_1960_ == 0)
{
v___x_1962_ = v___x_1959_;
goto v_reusejp_1961_;
}
else
{
lean_object* v_reuseFailAlloc_1963_; 
v_reuseFailAlloc_1963_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1963_, 0, v_a_1957_);
v___x_1962_ = v_reuseFailAlloc_1963_;
goto v_reusejp_1961_;
}
v_reusejp_1961_:
{
return v___x_1962_;
}
}
}
}
else
{
lean_object* v___x_1966_; 
if (v_isShared_1943_ == 0)
{
lean_ctor_set_tag(v___x_1942_, 0);
lean_ctor_set(v___x_1942_, 0, v_atomNumber_1945_);
v___x_1966_ = v___x_1942_;
goto v_reusejp_1965_;
}
else
{
lean_object* v_reuseFailAlloc_1967_; 
v_reuseFailAlloc_1967_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1967_, 0, v_atomNumber_1945_);
v___x_1966_ = v_reuseFailAlloc_1967_;
goto v_reusejp_1965_;
}
v_reusejp_1965_:
{
return v___x_1966_;
}
}
}
}
v___jp_1884_:
{
lean_object* v___x_1886_; lean_object* v_atoms_1887_; lean_object* v___x_1889_; uint8_t v_isShared_1890_; uint8_t v_isSharedCheck_1901_; 
v___x_1886_ = lean_st_ref_take(v___y_1885_);
v_atoms_1887_ = lean_ctor_get(v___x_1886_, 0);
v_isSharedCheck_1901_ = !lean_is_exclusive(v___x_1886_);
if (v_isSharedCheck_1901_ == 0)
{
lean_object* v_unused_1902_; lean_object* v_unused_1903_; 
v_unused_1902_ = lean_ctor_get(v___x_1886_, 2);
lean_dec(v_unused_1902_);
v_unused_1903_ = lean_ctor_get(v___x_1886_, 1);
lean_dec(v_unused_1903_);
v___x_1889_ = v___x_1886_;
v_isShared_1890_ = v_isSharedCheck_1901_;
goto v_resetjp_1888_;
}
else
{
lean_inc(v_atoms_1887_);
lean_dec(v___x_1886_);
v___x_1889_ = lean_box(0);
v_isShared_1890_ = v_isSharedCheck_1901_;
goto v_resetjp_1888_;
}
v_resetjp_1888_:
{
lean_object* v_size_1891_; lean_object* v___x_1892_; lean_object* v___x_1893_; lean_object* v___x_1894_; lean_object* v___x_1895_; lean_object* v___x_1897_; 
v_size_1891_ = lean_ctor_get(v_atoms_1887_, 0);
lean_inc_n(v_size_1891_, 2);
v___x_1892_ = lean_alloc_ctor(0, 2, 1);
lean_ctor_set(v___x_1892_, 0, v_width_1873_);
lean_ctor_set(v___x_1892_, 1, v_size_1891_);
lean_ctor_set_uint8(v___x_1892_, sizeof(void*)*2, v_synthetic_1874_);
v___x_1893_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVExpr_evalsAtAtoms_spec__1___redArg(v_atoms_1887_, v_e_1872_, v___x_1892_);
v___x_1894_ = lean_box(0);
v___x_1895_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_M_run___redArg___closed__1);
if (v_isShared_1890_ == 0)
{
lean_ctor_set(v___x_1889_, 2, v___x_1895_);
lean_ctor_set(v___x_1889_, 1, v___x_1894_);
lean_ctor_set(v___x_1889_, 0, v___x_1893_);
v___x_1897_ = v___x_1889_;
goto v_reusejp_1896_;
}
else
{
lean_object* v_reuseFailAlloc_1900_; 
v_reuseFailAlloc_1900_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v_reuseFailAlloc_1900_, 0, v___x_1893_);
lean_ctor_set(v_reuseFailAlloc_1900_, 1, v___x_1894_);
lean_ctor_set(v_reuseFailAlloc_1900_, 2, v___x_1895_);
v___x_1897_ = v_reuseFailAlloc_1900_;
goto v_reusejp_1896_;
}
v_reusejp_1896_:
{
lean_object* v___x_1898_; lean_object* v___x_1899_; 
v___x_1898_ = lean_st_ref_set(v___y_1885_, v___x_1897_);
v___x_1899_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1899_, 0, v_size_1891_);
return v___x_1899_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_lookup___boxed(lean_object* v_e_1969_, lean_object* v_width_1970_, lean_object* v_synthetic_1971_, lean_object* v_a_1972_, lean_object* v_a_1973_, lean_object* v_a_1974_, lean_object* v_a_1975_, lean_object* v_a_1976_, lean_object* v_a_1977_, lean_object* v_a_1978_, lean_object* v_a_1979_, lean_object* v_a_1980_){
_start:
{
uint8_t v_synthetic_boxed_1981_; lean_object* v_res_1982_; 
v_synthetic_boxed_1981_ = lean_unbox(v_synthetic_1971_);
v_res_1982_ = l_Lean_Meta_Tactic_BVDecide_M_lookup(v_e_1969_, v_width_1970_, v_synthetic_boxed_1981_, v_a_1972_, v_a_1973_, v_a_1974_, v_a_1975_, v_a_1976_, v_a_1977_, v_a_1978_, v_a_1979_);
lean_dec(v_a_1979_);
lean_dec_ref(v_a_1978_);
lean_dec(v_a_1977_);
lean_dec_ref(v_a_1976_);
lean_dec(v_a_1975_);
lean_dec_ref(v_a_1974_);
lean_dec(v_a_1973_);
lean_dec_ref(v_a_1972_);
return v_res_1982_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0(lean_object* v_cls_1983_, lean_object* v_msg_1984_, lean_object* v___y_1985_, lean_object* v___y_1986_, lean_object* v___y_1987_, lean_object* v___y_1988_, lean_object* v___y_1989_, lean_object* v___y_1990_, lean_object* v___y_1991_, lean_object* v___y_1992_){
_start:
{
lean_object* v___x_1994_; 
v___x_1994_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___redArg(v_cls_1983_, v_msg_1984_, v___y_1989_, v___y_1990_, v___y_1991_, v___y_1992_);
return v___x_1994_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0___boxed(lean_object* v_cls_1995_, lean_object* v_msg_1996_, lean_object* v___y_1997_, lean_object* v___y_1998_, lean_object* v___y_1999_, lean_object* v___y_2000_, lean_object* v___y_2001_, lean_object* v___y_2002_, lean_object* v___y_2003_, lean_object* v___y_2004_, lean_object* v___y_2005_){
_start:
{
lean_object* v_res_2006_; 
v_res_2006_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_M_lookup_spec__0(v_cls_1995_, v_msg_1996_, v___y_1997_, v___y_1998_, v___y_1999_, v___y_2000_, v___y_2001_, v___y_2002_, v___y_2003_, v___y_2004_);
lean_dec(v___y_2004_);
lean_dec_ref(v___y_2003_);
lean_dec(v___y_2002_);
lean_dec_ref(v___y_2001_);
lean_dec(v___y_2000_);
lean_dec_ref(v___y_1999_);
lean_dec(v___y_1998_);
lean_dec_ref(v___y_1997_);
return v_res_2006_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27(lean_object* v_mkFRefl_2007_, lean_object* v_fst_2008_, lean_object* v_fproof_2009_, lean_object* v_mkSRefl_2010_, lean_object* v_snd_2011_, lean_object* v_sproof_2012_){
_start:
{
if (lean_obj_tag(v_fproof_2009_) == 0)
{
lean_dec_ref(v_snd_2011_);
lean_dec_ref(v_mkSRefl_2010_);
if (lean_obj_tag(v_sproof_2012_) == 0)
{
lean_object* v___x_2013_; 
lean_dec_ref(v_fst_2008_);
lean_dec_ref(v_mkFRefl_2007_);
v___x_2013_ = lean_box(0);
return v___x_2013_;
}
else
{
lean_object* v_val_2014_; lean_object* v___x_2016_; uint8_t v_isShared_2017_; uint8_t v_isSharedCheck_2023_; 
v_val_2014_ = lean_ctor_get(v_sproof_2012_, 0);
v_isSharedCheck_2023_ = !lean_is_exclusive(v_sproof_2012_);
if (v_isSharedCheck_2023_ == 0)
{
v___x_2016_ = v_sproof_2012_;
v_isShared_2017_ = v_isSharedCheck_2023_;
goto v_resetjp_2015_;
}
else
{
lean_inc(v_val_2014_);
lean_dec(v_sproof_2012_);
v___x_2016_ = lean_box(0);
v_isShared_2017_ = v_isSharedCheck_2023_;
goto v_resetjp_2015_;
}
v_resetjp_2015_:
{
lean_object* v___x_2018_; lean_object* v___x_2019_; lean_object* v___x_2021_; 
v___x_2018_ = lean_apply_1(v_mkFRefl_2007_, v_fst_2008_);
v___x_2019_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2019_, 0, v___x_2018_);
lean_ctor_set(v___x_2019_, 1, v_val_2014_);
if (v_isShared_2017_ == 0)
{
lean_ctor_set(v___x_2016_, 0, v___x_2019_);
v___x_2021_ = v___x_2016_;
goto v_reusejp_2020_;
}
else
{
lean_object* v_reuseFailAlloc_2022_; 
v_reuseFailAlloc_2022_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2022_, 0, v___x_2019_);
v___x_2021_ = v_reuseFailAlloc_2022_;
goto v_reusejp_2020_;
}
v_reusejp_2020_:
{
return v___x_2021_;
}
}
}
}
else
{
lean_dec_ref(v_fst_2008_);
lean_dec_ref(v_mkFRefl_2007_);
if (lean_obj_tag(v_sproof_2012_) == 0)
{
lean_object* v_val_2024_; lean_object* v___x_2026_; uint8_t v_isShared_2027_; uint8_t v_isSharedCheck_2033_; 
v_val_2024_ = lean_ctor_get(v_fproof_2009_, 0);
v_isSharedCheck_2033_ = !lean_is_exclusive(v_fproof_2009_);
if (v_isSharedCheck_2033_ == 0)
{
v___x_2026_ = v_fproof_2009_;
v_isShared_2027_ = v_isSharedCheck_2033_;
goto v_resetjp_2025_;
}
else
{
lean_inc(v_val_2024_);
lean_dec(v_fproof_2009_);
v___x_2026_ = lean_box(0);
v_isShared_2027_ = v_isSharedCheck_2033_;
goto v_resetjp_2025_;
}
v_resetjp_2025_:
{
lean_object* v___x_2028_; lean_object* v___x_2029_; lean_object* v___x_2031_; 
v___x_2028_ = lean_apply_1(v_mkSRefl_2010_, v_snd_2011_);
v___x_2029_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2029_, 0, v_val_2024_);
lean_ctor_set(v___x_2029_, 1, v___x_2028_);
if (v_isShared_2027_ == 0)
{
lean_ctor_set(v___x_2026_, 0, v___x_2029_);
v___x_2031_ = v___x_2026_;
goto v_reusejp_2030_;
}
else
{
lean_object* v_reuseFailAlloc_2032_; 
v_reuseFailAlloc_2032_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2032_, 0, v___x_2029_);
v___x_2031_ = v_reuseFailAlloc_2032_;
goto v_reusejp_2030_;
}
v_reusejp_2030_:
{
return v___x_2031_;
}
}
}
else
{
lean_object* v_val_2034_; lean_object* v_val_2035_; lean_object* v___x_2037_; uint8_t v_isShared_2038_; uint8_t v_isSharedCheck_2043_; 
lean_dec_ref(v_snd_2011_);
lean_dec_ref(v_mkSRefl_2010_);
v_val_2034_ = lean_ctor_get(v_fproof_2009_, 0);
lean_inc(v_val_2034_);
lean_dec_ref_known(v_fproof_2009_, 1);
v_val_2035_ = lean_ctor_get(v_sproof_2012_, 0);
v_isSharedCheck_2043_ = !lean_is_exclusive(v_sproof_2012_);
if (v_isSharedCheck_2043_ == 0)
{
v___x_2037_ = v_sproof_2012_;
v_isShared_2038_ = v_isSharedCheck_2043_;
goto v_resetjp_2036_;
}
else
{
lean_inc(v_val_2035_);
lean_dec(v_sproof_2012_);
v___x_2037_ = lean_box(0);
v_isShared_2038_ = v_isSharedCheck_2043_;
goto v_resetjp_2036_;
}
v_resetjp_2036_:
{
lean_object* v___x_2039_; lean_object* v___x_2041_; 
v___x_2039_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2039_, 0, v_val_2034_);
lean_ctor_set(v___x_2039_, 1, v_val_2035_);
if (v_isShared_2038_ == 0)
{
lean_ctor_set(v___x_2037_, 0, v___x_2039_);
v___x_2041_ = v___x_2037_;
goto v_reusejp_2040_;
}
else
{
lean_object* v_reuseFailAlloc_2042_; 
v_reuseFailAlloc_2042_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2042_, 0, v___x_2039_);
v___x_2041_ = v_reuseFailAlloc_2042_;
goto v_reusejp_2040_;
}
v_reusejp_2040_:
{
return v___x_2041_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof(lean_object* v_mkRefl_2044_, lean_object* v_fst_2045_, lean_object* v_fproof_2046_, lean_object* v_snd_2047_, lean_object* v_sproof_2048_){
_start:
{
lean_object* v___x_2049_; 
lean_inc_ref(v_mkRefl_2044_);
v___x_2049_ = l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27(v_mkRefl_2044_, v_fst_2045_, v_fproof_2046_, v_mkRefl_2044_, v_snd_2047_, v_sproof_2048_);
return v___x_2049_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyTernaryProof(lean_object* v_mkRefl_2050_, lean_object* v_fst_2051_, lean_object* v_fproof_2052_, lean_object* v_snd_2053_, lean_object* v_sproof_2054_, lean_object* v_thd_2055_, lean_object* v_tproof_2056_){
_start:
{
if (lean_obj_tag(v_fproof_2052_) == 0)
{
lean_object* v___x_2057_; 
lean_inc_ref_n(v_mkRefl_2050_, 2);
v___x_2057_ = l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27(v_mkRefl_2050_, v_snd_2053_, v_sproof_2054_, v_mkRefl_2050_, v_thd_2055_, v_tproof_2056_);
if (lean_obj_tag(v___x_2057_) == 0)
{
lean_object* v___x_2058_; 
lean_dec_ref(v_fst_2051_);
lean_dec_ref(v_mkRefl_2050_);
v___x_2058_ = lean_box(0);
return v___x_2058_;
}
else
{
lean_object* v_val_2059_; lean_object* v___x_2061_; uint8_t v_isShared_2062_; uint8_t v_isSharedCheck_2068_; 
v_val_2059_ = lean_ctor_get(v___x_2057_, 0);
v_isSharedCheck_2068_ = !lean_is_exclusive(v___x_2057_);
if (v_isSharedCheck_2068_ == 0)
{
v___x_2061_ = v___x_2057_;
v_isShared_2062_ = v_isSharedCheck_2068_;
goto v_resetjp_2060_;
}
else
{
lean_inc(v_val_2059_);
lean_dec(v___x_2057_);
v___x_2061_ = lean_box(0);
v_isShared_2062_ = v_isSharedCheck_2068_;
goto v_resetjp_2060_;
}
v_resetjp_2060_:
{
lean_object* v___x_2063_; lean_object* v___x_2064_; lean_object* v___x_2066_; 
v___x_2063_ = lean_apply_1(v_mkRefl_2050_, v_fst_2051_);
v___x_2064_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2064_, 0, v___x_2063_);
lean_ctor_set(v___x_2064_, 1, v_val_2059_);
if (v_isShared_2062_ == 0)
{
lean_ctor_set(v___x_2061_, 0, v___x_2064_);
v___x_2066_ = v___x_2061_;
goto v_reusejp_2065_;
}
else
{
lean_object* v_reuseFailAlloc_2067_; 
v_reuseFailAlloc_2067_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2067_, 0, v___x_2064_);
v___x_2066_ = v_reuseFailAlloc_2067_;
goto v_reusejp_2065_;
}
v_reusejp_2065_:
{
return v___x_2066_;
}
}
}
}
else
{
lean_object* v_val_2069_; lean_object* v___x_2071_; uint8_t v_isShared_2072_; uint8_t v_isSharedCheck_2090_; 
lean_dec_ref(v_fst_2051_);
v_val_2069_ = lean_ctor_get(v_fproof_2052_, 0);
v_isSharedCheck_2090_ = !lean_is_exclusive(v_fproof_2052_);
if (v_isSharedCheck_2090_ == 0)
{
v___x_2071_ = v_fproof_2052_;
v_isShared_2072_ = v_isSharedCheck_2090_;
goto v_resetjp_2070_;
}
else
{
lean_inc(v_val_2069_);
lean_dec(v_fproof_2052_);
v___x_2071_ = lean_box(0);
v_isShared_2072_ = v_isSharedCheck_2090_;
goto v_resetjp_2070_;
}
v_resetjp_2070_:
{
lean_object* v___x_2073_; 
lean_inc_ref(v_thd_2055_);
lean_inc_ref(v_snd_2053_);
lean_inc_ref_n(v_mkRefl_2050_, 2);
v___x_2073_ = l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27(v_mkRefl_2050_, v_snd_2053_, v_sproof_2054_, v_mkRefl_2050_, v_thd_2055_, v_tproof_2056_);
if (lean_obj_tag(v___x_2073_) == 0)
{
lean_object* v___x_2074_; lean_object* v___x_2075_; lean_object* v___x_2076_; lean_object* v___x_2077_; lean_object* v___x_2079_; 
lean_inc_ref(v_mkRefl_2050_);
v___x_2074_ = lean_apply_1(v_mkRefl_2050_, v_snd_2053_);
v___x_2075_ = lean_apply_1(v_mkRefl_2050_, v_thd_2055_);
v___x_2076_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2076_, 0, v___x_2074_);
lean_ctor_set(v___x_2076_, 1, v___x_2075_);
v___x_2077_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2077_, 0, v_val_2069_);
lean_ctor_set(v___x_2077_, 1, v___x_2076_);
if (v_isShared_2072_ == 0)
{
lean_ctor_set(v___x_2071_, 0, v___x_2077_);
v___x_2079_ = v___x_2071_;
goto v_reusejp_2078_;
}
else
{
lean_object* v_reuseFailAlloc_2080_; 
v_reuseFailAlloc_2080_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2080_, 0, v___x_2077_);
v___x_2079_ = v_reuseFailAlloc_2080_;
goto v_reusejp_2078_;
}
v_reusejp_2078_:
{
return v___x_2079_;
}
}
else
{
lean_object* v_val_2081_; lean_object* v___x_2083_; uint8_t v_isShared_2084_; uint8_t v_isSharedCheck_2089_; 
lean_del_object(v___x_2071_);
lean_dec_ref(v_thd_2055_);
lean_dec_ref(v_snd_2053_);
lean_dec_ref(v_mkRefl_2050_);
v_val_2081_ = lean_ctor_get(v___x_2073_, 0);
v_isSharedCheck_2089_ = !lean_is_exclusive(v___x_2073_);
if (v_isSharedCheck_2089_ == 0)
{
v___x_2083_ = v___x_2073_;
v_isShared_2084_ = v_isSharedCheck_2089_;
goto v_resetjp_2082_;
}
else
{
lean_inc(v_val_2081_);
lean_dec(v___x_2073_);
v___x_2083_ = lean_box(0);
v_isShared_2084_ = v_isSharedCheck_2089_;
goto v_resetjp_2082_;
}
v_resetjp_2082_:
{
lean_object* v___x_2085_; lean_object* v___x_2087_; 
v___x_2085_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2085_, 0, v_val_2069_);
lean_ctor_set(v___x_2085_, 1, v_val_2081_);
if (v_isShared_2084_ == 0)
{
lean_ctor_set(v___x_2083_, 0, v___x_2085_);
v___x_2087_ = v___x_2083_;
goto v_reusejp_2086_;
}
else
{
lean_object* v_reuseFailAlloc_2088_; 
v_reuseFailAlloc_2088_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2088_, 0, v___x_2085_);
v___x_2087_ = v_reuseFailAlloc_2088_;
goto v_reusejp_2086_;
}
v_reusejp_2086_:
{
return v___x_2087_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_getHyps___redArg(lean_object* v_a_2091_){
_start:
{
lean_object* v___x_2093_; 
lean_inc_ref(v_a_2091_);
v___x_2093_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2093_, 0, v_a_2091_);
return v___x_2093_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_getHyps___redArg___boxed(lean_object* v_a_2094_, lean_object* v_a_2095_){
_start:
{
lean_object* v_res_2096_; 
v_res_2096_ = l_Lean_Meta_Tactic_BVDecide_M_getHyps___redArg(v_a_2094_);
lean_dec_ref(v_a_2094_);
return v_res_2096_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_getHyps(lean_object* v_a_2097_, lean_object* v_a_2098_, lean_object* v_a_2099_, lean_object* v_a_2100_, lean_object* v_a_2101_, lean_object* v_a_2102_, lean_object* v_a_2103_, lean_object* v_a_2104_){
_start:
{
lean_object* v___x_2106_; 
lean_inc_ref(v_a_2097_);
v___x_2106_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2106_, 0, v_a_2097_);
return v___x_2106_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_getHyps___boxed(lean_object* v_a_2107_, lean_object* v_a_2108_, lean_object* v_a_2109_, lean_object* v_a_2110_, lean_object* v_a_2111_, lean_object* v_a_2112_, lean_object* v_a_2113_, lean_object* v_a_2114_, lean_object* v_a_2115_){
_start:
{
lean_object* v_res_2116_; 
v_res_2116_ = l_Lean_Meta_Tactic_BVDecide_M_getHyps(v_a_2107_, v_a_2108_, v_a_2109_, v_a_2110_, v_a_2111_, v_a_2112_, v_a_2113_, v_a_2114_);
lean_dec(v_a_2114_);
lean_dec_ref(v_a_2113_);
lean_dec(v_a_2112_);
lean_dec_ref(v_a_2111_);
lean_dec(v_a_2110_);
lean_dec_ref(v_a_2109_);
lean_dec(v_a_2108_);
lean_dec_ref(v_a_2107_);
return v_res_2116_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_run___redArg(lean_object* v_m_2117_, lean_object* v_state_2118_, lean_object* v_a_2119_, lean_object* v_a_2120_, lean_object* v_a_2121_, lean_object* v_a_2122_, lean_object* v_a_2123_, lean_object* v_a_2124_, lean_object* v_a_2125_, lean_object* v_a_2126_){
_start:
{
lean_object* v___x_2128_; lean_object* v___x_2129_; 
v___x_2128_ = lean_st_mk_ref(v_state_2118_);
lean_inc(v_a_2126_);
lean_inc_ref(v_a_2125_);
lean_inc(v_a_2124_);
lean_inc_ref(v_a_2123_);
lean_inc(v_a_2122_);
lean_inc_ref(v_a_2121_);
lean_inc(v_a_2120_);
lean_inc_ref(v_a_2119_);
lean_inc(v___x_2128_);
v___x_2129_ = lean_apply_10(v_m_2117_, v___x_2128_, v_a_2119_, v_a_2120_, v_a_2121_, v_a_2122_, v_a_2123_, v_a_2124_, v_a_2125_, v_a_2126_, lean_box(0));
if (lean_obj_tag(v___x_2129_) == 0)
{
lean_object* v_a_2130_; lean_object* v___x_2132_; uint8_t v_isShared_2133_; uint8_t v_isSharedCheck_2140_; 
v_a_2130_ = lean_ctor_get(v___x_2129_, 0);
v_isSharedCheck_2140_ = !lean_is_exclusive(v___x_2129_);
if (v_isSharedCheck_2140_ == 0)
{
v___x_2132_ = v___x_2129_;
v_isShared_2133_ = v_isSharedCheck_2140_;
goto v_resetjp_2131_;
}
else
{
lean_inc(v_a_2130_);
lean_dec(v___x_2129_);
v___x_2132_ = lean_box(0);
v_isShared_2133_ = v_isSharedCheck_2140_;
goto v_resetjp_2131_;
}
v_resetjp_2131_:
{
lean_object* v___x_2134_; lean_object* v_lemmas_2135_; lean_object* v___x_2136_; lean_object* v___x_2138_; 
v___x_2134_ = lean_st_ref_get(v___x_2128_);
lean_dec(v___x_2128_);
v_lemmas_2135_ = lean_ctor_get(v___x_2134_, 0);
lean_inc_ref(v_lemmas_2135_);
lean_dec(v___x_2134_);
v___x_2136_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2136_, 0, v_a_2130_);
lean_ctor_set(v___x_2136_, 1, v_lemmas_2135_);
if (v_isShared_2133_ == 0)
{
lean_ctor_set(v___x_2132_, 0, v___x_2136_);
v___x_2138_ = v___x_2132_;
goto v_reusejp_2137_;
}
else
{
lean_object* v_reuseFailAlloc_2139_; 
v_reuseFailAlloc_2139_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2139_, 0, v___x_2136_);
v___x_2138_ = v_reuseFailAlloc_2139_;
goto v_reusejp_2137_;
}
v_reusejp_2137_:
{
return v___x_2138_;
}
}
}
else
{
lean_object* v_a_2141_; lean_object* v___x_2143_; uint8_t v_isShared_2144_; uint8_t v_isSharedCheck_2148_; 
lean_dec(v___x_2128_);
v_a_2141_ = lean_ctor_get(v___x_2129_, 0);
v_isSharedCheck_2148_ = !lean_is_exclusive(v___x_2129_);
if (v_isSharedCheck_2148_ == 0)
{
v___x_2143_ = v___x_2129_;
v_isShared_2144_ = v_isSharedCheck_2148_;
goto v_resetjp_2142_;
}
else
{
lean_inc(v_a_2141_);
lean_dec(v___x_2129_);
v___x_2143_ = lean_box(0);
v_isShared_2144_ = v_isSharedCheck_2148_;
goto v_resetjp_2142_;
}
v_resetjp_2142_:
{
lean_object* v___x_2146_; 
if (v_isShared_2144_ == 0)
{
v___x_2146_ = v___x_2143_;
goto v_reusejp_2145_;
}
else
{
lean_object* v_reuseFailAlloc_2147_; 
v_reuseFailAlloc_2147_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2147_, 0, v_a_2141_);
v___x_2146_ = v_reuseFailAlloc_2147_;
goto v_reusejp_2145_;
}
v_reusejp_2145_:
{
return v___x_2146_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_run___redArg___boxed(lean_object* v_m_2149_, lean_object* v_state_2150_, lean_object* v_a_2151_, lean_object* v_a_2152_, lean_object* v_a_2153_, lean_object* v_a_2154_, lean_object* v_a_2155_, lean_object* v_a_2156_, lean_object* v_a_2157_, lean_object* v_a_2158_, lean_object* v_a_2159_){
_start:
{
lean_object* v_res_2160_; 
v_res_2160_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_run___redArg(v_m_2149_, v_state_2150_, v_a_2151_, v_a_2152_, v_a_2153_, v_a_2154_, v_a_2155_, v_a_2156_, v_a_2157_, v_a_2158_);
lean_dec(v_a_2158_);
lean_dec_ref(v_a_2157_);
lean_dec(v_a_2156_);
lean_dec_ref(v_a_2155_);
lean_dec(v_a_2154_);
lean_dec_ref(v_a_2153_);
lean_dec(v_a_2152_);
lean_dec_ref(v_a_2151_);
return v_res_2160_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_run(lean_object* v_00_u03b1_2161_, lean_object* v_m_2162_, lean_object* v_state_2163_, lean_object* v_a_2164_, lean_object* v_a_2165_, lean_object* v_a_2166_, lean_object* v_a_2167_, lean_object* v_a_2168_, lean_object* v_a_2169_, lean_object* v_a_2170_, lean_object* v_a_2171_){
_start:
{
lean_object* v___x_2173_; 
v___x_2173_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_run___redArg(v_m_2162_, v_state_2163_, v_a_2164_, v_a_2165_, v_a_2166_, v_a_2167_, v_a_2168_, v_a_2169_, v_a_2170_, v_a_2171_);
return v___x_2173_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_run___boxed(lean_object* v_00_u03b1_2174_, lean_object* v_m_2175_, lean_object* v_state_2176_, lean_object* v_a_2177_, lean_object* v_a_2178_, lean_object* v_a_2179_, lean_object* v_a_2180_, lean_object* v_a_2181_, lean_object* v_a_2182_, lean_object* v_a_2183_, lean_object* v_a_2184_, lean_object* v_a_2185_){
_start:
{
lean_object* v_res_2186_; 
v_res_2186_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_run(v_00_u03b1_2174_, v_m_2175_, v_state_2176_, v_a_2177_, v_a_2178_, v_a_2179_, v_a_2180_, v_a_2181_, v_a_2182_, v_a_2183_, v_a_2184_);
lean_dec(v_a_2184_);
lean_dec_ref(v_a_2183_);
lean_dec(v_a_2182_);
lean_dec_ref(v_a_2181_);
lean_dec(v_a_2180_);
lean_dec_ref(v_a_2179_);
lean_dec(v_a_2178_);
lean_dec_ref(v_a_2177_);
return v_res_2186_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma___redArg(lean_object* v_lemma_2187_, lean_object* v_a_2188_){
_start:
{
lean_object* v___x_2190_; lean_object* v_lemmas_2191_; lean_object* v_bvExprCache_2192_; lean_object* v_bvPredCache_2193_; lean_object* v_bvLogicalCache_2194_; lean_object* v___x_2196_; uint8_t v_isShared_2197_; uint8_t v_isSharedCheck_2205_; 
v___x_2190_ = lean_st_ref_take(v_a_2188_);
v_lemmas_2191_ = lean_ctor_get(v___x_2190_, 0);
v_bvExprCache_2192_ = lean_ctor_get(v___x_2190_, 1);
v_bvPredCache_2193_ = lean_ctor_get(v___x_2190_, 2);
v_bvLogicalCache_2194_ = lean_ctor_get(v___x_2190_, 3);
v_isSharedCheck_2205_ = !lean_is_exclusive(v___x_2190_);
if (v_isSharedCheck_2205_ == 0)
{
v___x_2196_ = v___x_2190_;
v_isShared_2197_ = v_isSharedCheck_2205_;
goto v_resetjp_2195_;
}
else
{
lean_inc(v_bvLogicalCache_2194_);
lean_inc(v_bvPredCache_2193_);
lean_inc(v_bvExprCache_2192_);
lean_inc(v_lemmas_2191_);
lean_dec(v___x_2190_);
v___x_2196_ = lean_box(0);
v_isShared_2197_ = v_isSharedCheck_2205_;
goto v_resetjp_2195_;
}
v_resetjp_2195_:
{
lean_object* v___x_2198_; lean_object* v___x_2200_; 
v___x_2198_ = lean_array_push(v_lemmas_2191_, v_lemma_2187_);
if (v_isShared_2197_ == 0)
{
lean_ctor_set(v___x_2196_, 0, v___x_2198_);
v___x_2200_ = v___x_2196_;
goto v_reusejp_2199_;
}
else
{
lean_object* v_reuseFailAlloc_2204_; 
v_reuseFailAlloc_2204_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_2204_, 0, v___x_2198_);
lean_ctor_set(v_reuseFailAlloc_2204_, 1, v_bvExprCache_2192_);
lean_ctor_set(v_reuseFailAlloc_2204_, 2, v_bvPredCache_2193_);
lean_ctor_set(v_reuseFailAlloc_2204_, 3, v_bvLogicalCache_2194_);
v___x_2200_ = v_reuseFailAlloc_2204_;
goto v_reusejp_2199_;
}
v_reusejp_2199_:
{
lean_object* v___x_2201_; lean_object* v___x_2202_; lean_object* v___x_2203_; 
v___x_2201_ = lean_st_ref_set(v_a_2188_, v___x_2200_);
v___x_2202_ = lean_box(0);
v___x_2203_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2203_, 0, v___x_2202_);
return v___x_2203_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma___redArg___boxed(lean_object* v_lemma_2206_, lean_object* v_a_2207_, lean_object* v_a_2208_){
_start:
{
lean_object* v_res_2209_; 
v_res_2209_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma___redArg(v_lemma_2206_, v_a_2207_);
lean_dec(v_a_2207_);
return v_res_2209_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma(lean_object* v_lemma_2210_, lean_object* v_a_2211_, lean_object* v_a_2212_, lean_object* v_a_2213_, lean_object* v_a_2214_, lean_object* v_a_2215_, lean_object* v_a_2216_, lean_object* v_a_2217_, lean_object* v_a_2218_, lean_object* v_a_2219_){
_start:
{
lean_object* v___x_2221_; 
v___x_2221_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma___redArg(v_lemma_2210_, v_a_2211_);
return v___x_2221_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma___boxed(lean_object* v_lemma_2222_, lean_object* v_a_2223_, lean_object* v_a_2224_, lean_object* v_a_2225_, lean_object* v_a_2226_, lean_object* v_a_2227_, lean_object* v_a_2228_, lean_object* v_a_2229_, lean_object* v_a_2230_, lean_object* v_a_2231_, lean_object* v_a_2232_){
_start:
{
lean_object* v_res_2233_; 
v_res_2233_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_addLemma(v_lemma_2222_, v_a_2223_, v_a_2224_, v_a_2225_, v_a_2226_, v_a_2227_, v_a_2228_, v_a_2229_, v_a_2230_, v_a_2231_);
lean_dec(v_a_2231_);
lean_dec_ref(v_a_2230_);
lean_dec(v_a_2229_);
lean_dec_ref(v_a_2228_);
lean_dec(v_a_2227_);
lean_dec_ref(v_a_2226_);
lean_dec(v_a_2225_);
lean_dec_ref(v_a_2224_);
lean_dec(v_a_2223_);
return v_res_2233_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache(lean_object* v_e_2236_, lean_object* v_f_2237_, lean_object* v_a_2238_, lean_object* v_a_2239_, lean_object* v_a_2240_, lean_object* v_a_2241_, lean_object* v_a_2242_, lean_object* v_a_2243_, lean_object* v_a_2244_, lean_object* v_a_2245_, lean_object* v_a_2246_){
_start:
{
lean_object* v___x_2248_; lean_object* v_bvExprCache_2249_; lean_object* v___f_2250_; lean_object* v___f_2251_; lean_object* v___x_2252_; 
v___x_2248_ = lean_st_ref_get(v_a_2238_);
v_bvExprCache_2249_ = lean_ctor_get(v___x_2248_, 1);
lean_inc_ref(v_bvExprCache_2249_);
lean_dec(v___x_2248_);
v___f_2250_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__0));
v___f_2251_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__1));
lean_inc_ref(v_e_2236_);
v___x_2252_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___redArg(v___f_2250_, v___f_2251_, v_bvExprCache_2249_, v_e_2236_);
lean_dec_ref(v_bvExprCache_2249_);
if (lean_obj_tag(v___x_2252_) == 0)
{
lean_object* v___x_2253_; 
lean_inc(v_a_2246_);
lean_inc_ref(v_a_2245_);
lean_inc(v_a_2244_);
lean_inc_ref(v_a_2243_);
lean_inc(v_a_2242_);
lean_inc_ref(v_a_2241_);
lean_inc(v_a_2240_);
lean_inc_ref(v_a_2239_);
lean_inc(v_a_2238_);
lean_inc_ref(v_e_2236_);
v___x_2253_ = lean_apply_11(v_f_2237_, v_e_2236_, v_a_2238_, v_a_2239_, v_a_2240_, v_a_2241_, v_a_2242_, v_a_2243_, v_a_2244_, v_a_2245_, v_a_2246_, lean_box(0));
if (lean_obj_tag(v___x_2253_) == 0)
{
lean_object* v_a_2254_; lean_object* v___x_2256_; uint8_t v_isShared_2257_; uint8_t v_isSharedCheck_2275_; 
v_a_2254_ = lean_ctor_get(v___x_2253_, 0);
v_isSharedCheck_2275_ = !lean_is_exclusive(v___x_2253_);
if (v_isSharedCheck_2275_ == 0)
{
v___x_2256_ = v___x_2253_;
v_isShared_2257_ = v_isSharedCheck_2275_;
goto v_resetjp_2255_;
}
else
{
lean_inc(v_a_2254_);
lean_dec(v___x_2253_);
v___x_2256_ = lean_box(0);
v_isShared_2257_ = v_isSharedCheck_2275_;
goto v_resetjp_2255_;
}
v_resetjp_2255_:
{
lean_object* v___x_2258_; lean_object* v_lemmas_2259_; lean_object* v_bvExprCache_2260_; lean_object* v_bvPredCache_2261_; lean_object* v_bvLogicalCache_2262_; lean_object* v___x_2264_; uint8_t v_isShared_2265_; uint8_t v_isSharedCheck_2274_; 
v___x_2258_ = lean_st_ref_take(v_a_2238_);
v_lemmas_2259_ = lean_ctor_get(v___x_2258_, 0);
v_bvExprCache_2260_ = lean_ctor_get(v___x_2258_, 1);
v_bvPredCache_2261_ = lean_ctor_get(v___x_2258_, 2);
v_bvLogicalCache_2262_ = lean_ctor_get(v___x_2258_, 3);
v_isSharedCheck_2274_ = !lean_is_exclusive(v___x_2258_);
if (v_isSharedCheck_2274_ == 0)
{
v___x_2264_ = v___x_2258_;
v_isShared_2265_ = v_isSharedCheck_2274_;
goto v_resetjp_2263_;
}
else
{
lean_inc(v_bvLogicalCache_2262_);
lean_inc(v_bvPredCache_2261_);
lean_inc(v_bvExprCache_2260_);
lean_inc(v_lemmas_2259_);
lean_dec(v___x_2258_);
v___x_2264_ = lean_box(0);
v_isShared_2265_ = v_isSharedCheck_2274_;
goto v_resetjp_2263_;
}
v_resetjp_2263_:
{
lean_object* v___x_2266_; lean_object* v___x_2268_; 
lean_inc(v_a_2254_);
v___x_2266_ = l_Std_DHashMap_Internal_Raw_u2080_insert___redArg(v___f_2250_, v___f_2251_, v_bvExprCache_2260_, v_e_2236_, v_a_2254_);
if (v_isShared_2265_ == 0)
{
lean_ctor_set(v___x_2264_, 1, v___x_2266_);
v___x_2268_ = v___x_2264_;
goto v_reusejp_2267_;
}
else
{
lean_object* v_reuseFailAlloc_2273_; 
v_reuseFailAlloc_2273_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_2273_, 0, v_lemmas_2259_);
lean_ctor_set(v_reuseFailAlloc_2273_, 1, v___x_2266_);
lean_ctor_set(v_reuseFailAlloc_2273_, 2, v_bvPredCache_2261_);
lean_ctor_set(v_reuseFailAlloc_2273_, 3, v_bvLogicalCache_2262_);
v___x_2268_ = v_reuseFailAlloc_2273_;
goto v_reusejp_2267_;
}
v_reusejp_2267_:
{
lean_object* v___x_2269_; lean_object* v___x_2271_; 
v___x_2269_ = lean_st_ref_set(v_a_2238_, v___x_2268_);
if (v_isShared_2257_ == 0)
{
v___x_2271_ = v___x_2256_;
goto v_reusejp_2270_;
}
else
{
lean_object* v_reuseFailAlloc_2272_; 
v_reuseFailAlloc_2272_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2272_, 0, v_a_2254_);
v___x_2271_ = v_reuseFailAlloc_2272_;
goto v_reusejp_2270_;
}
v_reusejp_2270_:
{
return v___x_2271_;
}
}
}
}
}
else
{
lean_dec_ref(v_e_2236_);
return v___x_2253_;
}
}
else
{
lean_object* v_val_2276_; lean_object* v___x_2278_; uint8_t v_isShared_2279_; uint8_t v_isSharedCheck_2283_; 
lean_dec_ref(v_f_2237_);
lean_dec_ref(v_e_2236_);
v_val_2276_ = lean_ctor_get(v___x_2252_, 0);
v_isSharedCheck_2283_ = !lean_is_exclusive(v___x_2252_);
if (v_isSharedCheck_2283_ == 0)
{
v___x_2278_ = v___x_2252_;
v_isShared_2279_ = v_isSharedCheck_2283_;
goto v_resetjp_2277_;
}
else
{
lean_inc(v_val_2276_);
lean_dec(v___x_2252_);
v___x_2278_ = lean_box(0);
v_isShared_2279_ = v_isSharedCheck_2283_;
goto v_resetjp_2277_;
}
v_resetjp_2277_:
{
lean_object* v___x_2281_; 
if (v_isShared_2279_ == 0)
{
lean_ctor_set_tag(v___x_2278_, 0);
v___x_2281_ = v___x_2278_;
goto v_reusejp_2280_;
}
else
{
lean_object* v_reuseFailAlloc_2282_; 
v_reuseFailAlloc_2282_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2282_, 0, v_val_2276_);
v___x_2281_ = v_reuseFailAlloc_2282_;
goto v_reusejp_2280_;
}
v_reusejp_2280_:
{
return v___x_2281_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___boxed(lean_object* v_e_2284_, lean_object* v_f_2285_, lean_object* v_a_2286_, lean_object* v_a_2287_, lean_object* v_a_2288_, lean_object* v_a_2289_, lean_object* v_a_2290_, lean_object* v_a_2291_, lean_object* v_a_2292_, lean_object* v_a_2293_, lean_object* v_a_2294_, lean_object* v_a_2295_){
_start:
{
lean_object* v_res_2296_; 
v_res_2296_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache(v_e_2284_, v_f_2285_, v_a_2286_, v_a_2287_, v_a_2288_, v_a_2289_, v_a_2290_, v_a_2291_, v_a_2292_, v_a_2293_, v_a_2294_);
lean_dec(v_a_2294_);
lean_dec_ref(v_a_2293_);
lean_dec(v_a_2292_);
lean_dec_ref(v_a_2291_);
lean_dec(v_a_2290_);
lean_dec_ref(v_a_2289_);
lean_dec(v_a_2288_);
lean_dec_ref(v_a_2287_);
lean_dec(v_a_2286_);
return v_res_2296_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVPredCache(lean_object* v_e_2297_, lean_object* v_f_2298_, lean_object* v_a_2299_, lean_object* v_a_2300_, lean_object* v_a_2301_, lean_object* v_a_2302_, lean_object* v_a_2303_, lean_object* v_a_2304_, lean_object* v_a_2305_, lean_object* v_a_2306_, lean_object* v_a_2307_){
_start:
{
lean_object* v___x_2309_; lean_object* v_bvPredCache_2310_; lean_object* v___f_2311_; lean_object* v___f_2312_; lean_object* v___x_2313_; 
v___x_2309_ = lean_st_ref_get(v_a_2299_);
v_bvPredCache_2310_ = lean_ctor_get(v___x_2309_, 2);
lean_inc_ref(v_bvPredCache_2310_);
lean_dec(v___x_2309_);
v___f_2311_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__0));
v___f_2312_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__1));
lean_inc_ref(v_e_2297_);
v___x_2313_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___redArg(v___f_2311_, v___f_2312_, v_bvPredCache_2310_, v_e_2297_);
lean_dec_ref(v_bvPredCache_2310_);
if (lean_obj_tag(v___x_2313_) == 0)
{
lean_object* v___x_2314_; 
lean_inc(v_a_2307_);
lean_inc_ref(v_a_2306_);
lean_inc(v_a_2305_);
lean_inc_ref(v_a_2304_);
lean_inc(v_a_2303_);
lean_inc_ref(v_a_2302_);
lean_inc(v_a_2301_);
lean_inc_ref(v_a_2300_);
lean_inc(v_a_2299_);
lean_inc_ref(v_e_2297_);
v___x_2314_ = lean_apply_11(v_f_2298_, v_e_2297_, v_a_2299_, v_a_2300_, v_a_2301_, v_a_2302_, v_a_2303_, v_a_2304_, v_a_2305_, v_a_2306_, v_a_2307_, lean_box(0));
if (lean_obj_tag(v___x_2314_) == 0)
{
lean_object* v_a_2315_; lean_object* v___x_2317_; uint8_t v_isShared_2318_; uint8_t v_isSharedCheck_2336_; 
v_a_2315_ = lean_ctor_get(v___x_2314_, 0);
v_isSharedCheck_2336_ = !lean_is_exclusive(v___x_2314_);
if (v_isSharedCheck_2336_ == 0)
{
v___x_2317_ = v___x_2314_;
v_isShared_2318_ = v_isSharedCheck_2336_;
goto v_resetjp_2316_;
}
else
{
lean_inc(v_a_2315_);
lean_dec(v___x_2314_);
v___x_2317_ = lean_box(0);
v_isShared_2318_ = v_isSharedCheck_2336_;
goto v_resetjp_2316_;
}
v_resetjp_2316_:
{
lean_object* v___x_2319_; lean_object* v_lemmas_2320_; lean_object* v_bvExprCache_2321_; lean_object* v_bvPredCache_2322_; lean_object* v_bvLogicalCache_2323_; lean_object* v___x_2325_; uint8_t v_isShared_2326_; uint8_t v_isSharedCheck_2335_; 
v___x_2319_ = lean_st_ref_take(v_a_2299_);
v_lemmas_2320_ = lean_ctor_get(v___x_2319_, 0);
v_bvExprCache_2321_ = lean_ctor_get(v___x_2319_, 1);
v_bvPredCache_2322_ = lean_ctor_get(v___x_2319_, 2);
v_bvLogicalCache_2323_ = lean_ctor_get(v___x_2319_, 3);
v_isSharedCheck_2335_ = !lean_is_exclusive(v___x_2319_);
if (v_isSharedCheck_2335_ == 0)
{
v___x_2325_ = v___x_2319_;
v_isShared_2326_ = v_isSharedCheck_2335_;
goto v_resetjp_2324_;
}
else
{
lean_inc(v_bvLogicalCache_2323_);
lean_inc(v_bvPredCache_2322_);
lean_inc(v_bvExprCache_2321_);
lean_inc(v_lemmas_2320_);
lean_dec(v___x_2319_);
v___x_2325_ = lean_box(0);
v_isShared_2326_ = v_isSharedCheck_2335_;
goto v_resetjp_2324_;
}
v_resetjp_2324_:
{
lean_object* v___x_2327_; lean_object* v___x_2329_; 
lean_inc(v_a_2315_);
v___x_2327_ = l_Std_DHashMap_Internal_Raw_u2080_insert___redArg(v___f_2311_, v___f_2312_, v_bvPredCache_2322_, v_e_2297_, v_a_2315_);
if (v_isShared_2326_ == 0)
{
lean_ctor_set(v___x_2325_, 2, v___x_2327_);
v___x_2329_ = v___x_2325_;
goto v_reusejp_2328_;
}
else
{
lean_object* v_reuseFailAlloc_2334_; 
v_reuseFailAlloc_2334_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_2334_, 0, v_lemmas_2320_);
lean_ctor_set(v_reuseFailAlloc_2334_, 1, v_bvExprCache_2321_);
lean_ctor_set(v_reuseFailAlloc_2334_, 2, v___x_2327_);
lean_ctor_set(v_reuseFailAlloc_2334_, 3, v_bvLogicalCache_2323_);
v___x_2329_ = v_reuseFailAlloc_2334_;
goto v_reusejp_2328_;
}
v_reusejp_2328_:
{
lean_object* v___x_2330_; lean_object* v___x_2332_; 
v___x_2330_ = lean_st_ref_set(v_a_2299_, v___x_2329_);
if (v_isShared_2318_ == 0)
{
v___x_2332_ = v___x_2317_;
goto v_reusejp_2331_;
}
else
{
lean_object* v_reuseFailAlloc_2333_; 
v_reuseFailAlloc_2333_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2333_, 0, v_a_2315_);
v___x_2332_ = v_reuseFailAlloc_2333_;
goto v_reusejp_2331_;
}
v_reusejp_2331_:
{
return v___x_2332_;
}
}
}
}
}
else
{
lean_dec_ref(v_e_2297_);
return v___x_2314_;
}
}
else
{
lean_object* v_val_2337_; lean_object* v___x_2339_; uint8_t v_isShared_2340_; uint8_t v_isSharedCheck_2344_; 
lean_dec_ref(v_f_2298_);
lean_dec_ref(v_e_2297_);
v_val_2337_ = lean_ctor_get(v___x_2313_, 0);
v_isSharedCheck_2344_ = !lean_is_exclusive(v___x_2313_);
if (v_isSharedCheck_2344_ == 0)
{
v___x_2339_ = v___x_2313_;
v_isShared_2340_ = v_isSharedCheck_2344_;
goto v_resetjp_2338_;
}
else
{
lean_inc(v_val_2337_);
lean_dec(v___x_2313_);
v___x_2339_ = lean_box(0);
v_isShared_2340_ = v_isSharedCheck_2344_;
goto v_resetjp_2338_;
}
v_resetjp_2338_:
{
lean_object* v___x_2342_; 
if (v_isShared_2340_ == 0)
{
lean_ctor_set_tag(v___x_2339_, 0);
v___x_2342_ = v___x_2339_;
goto v_reusejp_2341_;
}
else
{
lean_object* v_reuseFailAlloc_2343_; 
v_reuseFailAlloc_2343_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2343_, 0, v_val_2337_);
v___x_2342_ = v_reuseFailAlloc_2343_;
goto v_reusejp_2341_;
}
v_reusejp_2341_:
{
return v___x_2342_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVPredCache___boxed(lean_object* v_e_2345_, lean_object* v_f_2346_, lean_object* v_a_2347_, lean_object* v_a_2348_, lean_object* v_a_2349_, lean_object* v_a_2350_, lean_object* v_a_2351_, lean_object* v_a_2352_, lean_object* v_a_2353_, lean_object* v_a_2354_, lean_object* v_a_2355_, lean_object* v_a_2356_){
_start:
{
lean_object* v_res_2357_; 
v_res_2357_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVPredCache(v_e_2345_, v_f_2346_, v_a_2347_, v_a_2348_, v_a_2349_, v_a_2350_, v_a_2351_, v_a_2352_, v_a_2353_, v_a_2354_, v_a_2355_);
lean_dec(v_a_2355_);
lean_dec_ref(v_a_2354_);
lean_dec(v_a_2353_);
lean_dec_ref(v_a_2352_);
lean_dec(v_a_2351_);
lean_dec_ref(v_a_2350_);
lean_dec(v_a_2349_);
lean_dec_ref(v_a_2348_);
lean_dec(v_a_2347_);
return v_res_2357_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVLogicalCache(lean_object* v_e_2358_, lean_object* v_f_2359_, lean_object* v_a_2360_, lean_object* v_a_2361_, lean_object* v_a_2362_, lean_object* v_a_2363_, lean_object* v_a_2364_, lean_object* v_a_2365_, lean_object* v_a_2366_, lean_object* v_a_2367_, lean_object* v_a_2368_){
_start:
{
lean_object* v___x_2370_; lean_object* v_bvLogicalCache_2371_; lean_object* v___f_2372_; lean_object* v___f_2373_; lean_object* v___x_2374_; 
v___x_2370_ = lean_st_ref_get(v_a_2360_);
v_bvLogicalCache_2371_ = lean_ctor_get(v___x_2370_, 3);
lean_inc_ref(v_bvLogicalCache_2371_);
lean_dec(v___x_2370_);
v___f_2372_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__0));
v___f_2373_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVExprCache___closed__1));
lean_inc_ref(v_e_2358_);
v___x_2374_ = l_Std_DHashMap_Internal_Raw_u2080_Const_get_x3f___redArg(v___f_2372_, v___f_2373_, v_bvLogicalCache_2371_, v_e_2358_);
lean_dec_ref(v_bvLogicalCache_2371_);
if (lean_obj_tag(v___x_2374_) == 0)
{
lean_object* v___x_2375_; 
lean_inc(v_a_2368_);
lean_inc_ref(v_a_2367_);
lean_inc(v_a_2366_);
lean_inc_ref(v_a_2365_);
lean_inc(v_a_2364_);
lean_inc_ref(v_a_2363_);
lean_inc(v_a_2362_);
lean_inc_ref(v_a_2361_);
lean_inc(v_a_2360_);
lean_inc_ref(v_e_2358_);
v___x_2375_ = lean_apply_11(v_f_2359_, v_e_2358_, v_a_2360_, v_a_2361_, v_a_2362_, v_a_2363_, v_a_2364_, v_a_2365_, v_a_2366_, v_a_2367_, v_a_2368_, lean_box(0));
if (lean_obj_tag(v___x_2375_) == 0)
{
lean_object* v_a_2376_; lean_object* v___x_2378_; uint8_t v_isShared_2379_; uint8_t v_isSharedCheck_2397_; 
v_a_2376_ = lean_ctor_get(v___x_2375_, 0);
v_isSharedCheck_2397_ = !lean_is_exclusive(v___x_2375_);
if (v_isSharedCheck_2397_ == 0)
{
v___x_2378_ = v___x_2375_;
v_isShared_2379_ = v_isSharedCheck_2397_;
goto v_resetjp_2377_;
}
else
{
lean_inc(v_a_2376_);
lean_dec(v___x_2375_);
v___x_2378_ = lean_box(0);
v_isShared_2379_ = v_isSharedCheck_2397_;
goto v_resetjp_2377_;
}
v_resetjp_2377_:
{
lean_object* v___x_2380_; lean_object* v_lemmas_2381_; lean_object* v_bvExprCache_2382_; lean_object* v_bvPredCache_2383_; lean_object* v_bvLogicalCache_2384_; lean_object* v___x_2386_; uint8_t v_isShared_2387_; uint8_t v_isSharedCheck_2396_; 
v___x_2380_ = lean_st_ref_take(v_a_2360_);
v_lemmas_2381_ = lean_ctor_get(v___x_2380_, 0);
v_bvExprCache_2382_ = lean_ctor_get(v___x_2380_, 1);
v_bvPredCache_2383_ = lean_ctor_get(v___x_2380_, 2);
v_bvLogicalCache_2384_ = lean_ctor_get(v___x_2380_, 3);
v_isSharedCheck_2396_ = !lean_is_exclusive(v___x_2380_);
if (v_isSharedCheck_2396_ == 0)
{
v___x_2386_ = v___x_2380_;
v_isShared_2387_ = v_isSharedCheck_2396_;
goto v_resetjp_2385_;
}
else
{
lean_inc(v_bvLogicalCache_2384_);
lean_inc(v_bvPredCache_2383_);
lean_inc(v_bvExprCache_2382_);
lean_inc(v_lemmas_2381_);
lean_dec(v___x_2380_);
v___x_2386_ = lean_box(0);
v_isShared_2387_ = v_isSharedCheck_2396_;
goto v_resetjp_2385_;
}
v_resetjp_2385_:
{
lean_object* v___x_2388_; lean_object* v___x_2390_; 
lean_inc(v_a_2376_);
v___x_2388_ = l_Std_DHashMap_Internal_Raw_u2080_insert___redArg(v___f_2372_, v___f_2373_, v_bvLogicalCache_2384_, v_e_2358_, v_a_2376_);
if (v_isShared_2387_ == 0)
{
lean_ctor_set(v___x_2386_, 3, v___x_2388_);
v___x_2390_ = v___x_2386_;
goto v_reusejp_2389_;
}
else
{
lean_object* v_reuseFailAlloc_2395_; 
v_reuseFailAlloc_2395_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_2395_, 0, v_lemmas_2381_);
lean_ctor_set(v_reuseFailAlloc_2395_, 1, v_bvExprCache_2382_);
lean_ctor_set(v_reuseFailAlloc_2395_, 2, v_bvPredCache_2383_);
lean_ctor_set(v_reuseFailAlloc_2395_, 3, v___x_2388_);
v___x_2390_ = v_reuseFailAlloc_2395_;
goto v_reusejp_2389_;
}
v_reusejp_2389_:
{
lean_object* v___x_2391_; lean_object* v___x_2393_; 
v___x_2391_ = lean_st_ref_set(v_a_2360_, v___x_2390_);
if (v_isShared_2379_ == 0)
{
v___x_2393_ = v___x_2378_;
goto v_reusejp_2392_;
}
else
{
lean_object* v_reuseFailAlloc_2394_; 
v_reuseFailAlloc_2394_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2394_, 0, v_a_2376_);
v___x_2393_ = v_reuseFailAlloc_2394_;
goto v_reusejp_2392_;
}
v_reusejp_2392_:
{
return v___x_2393_;
}
}
}
}
}
else
{
lean_dec_ref(v_e_2358_);
return v___x_2375_;
}
}
else
{
lean_object* v_val_2398_; lean_object* v___x_2400_; uint8_t v_isShared_2401_; uint8_t v_isSharedCheck_2405_; 
lean_dec_ref(v_f_2359_);
lean_dec_ref(v_e_2358_);
v_val_2398_ = lean_ctor_get(v___x_2374_, 0);
v_isSharedCheck_2405_ = !lean_is_exclusive(v___x_2374_);
if (v_isSharedCheck_2405_ == 0)
{
v___x_2400_ = v___x_2374_;
v_isShared_2401_ = v_isSharedCheck_2405_;
goto v_resetjp_2399_;
}
else
{
lean_inc(v_val_2398_);
lean_dec(v___x_2374_);
v___x_2400_ = lean_box(0);
v_isShared_2401_ = v_isSharedCheck_2405_;
goto v_resetjp_2399_;
}
v_resetjp_2399_:
{
lean_object* v___x_2403_; 
if (v_isShared_2401_ == 0)
{
lean_ctor_set_tag(v___x_2400_, 0);
v___x_2403_ = v___x_2400_;
goto v_reusejp_2402_;
}
else
{
lean_object* v_reuseFailAlloc_2404_; 
v_reuseFailAlloc_2404_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_2404_, 0, v_val_2398_);
v___x_2403_ = v_reuseFailAlloc_2404_;
goto v_reusejp_2402_;
}
v_reusejp_2402_:
{
return v___x_2403_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVLogicalCache___boxed(lean_object* v_e_2406_, lean_object* v_f_2407_, lean_object* v_a_2408_, lean_object* v_a_2409_, lean_object* v_a_2410_, lean_object* v_a_2411_, lean_object* v_a_2412_, lean_object* v_a_2413_, lean_object* v_a_2414_, lean_object* v_a_2415_, lean_object* v_a_2416_, lean_object* v_a_2417_){
_start:
{
lean_object* v_res_2418_; 
v_res_2418_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_withBVLogicalCache(v_e_2406_, v_f_2407_, v_a_2408_, v_a_2409_, v_a_2410_, v_a_2411_, v_a_2412_, v_a_2413_, v_a_2414_, v_a_2415_, v_a_2416_);
lean_dec(v_a_2416_);
lean_dec_ref(v_a_2415_);
lean_dec(v_a_2414_);
lean_dec_ref(v_a_2413_);
lean_dec(v_a_2412_);
lean_dec_ref(v_a_2411_);
lean_dec(v_a_2410_);
lean_dec_ref(v_a_2409_);
lean_dec(v_a_2408_);
return v_res_2418_;
}
}
lean_object* runtime_initialize_Std_Data_HashMap(uint8_t builtin);
lean_object* runtime_initialize_Std_Tactic_BVDecide_Bitblast_BVExpr_Basic(uint8_t builtin);
lean_object* runtime_initialize_Lean_Data_RArray(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_SymM(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Std_Data_HashMap(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Std_Tactic_BVDecide_Bitblast_BVExpr_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Data_RArray(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_SymM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp = _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp();
lean_mark_persistent(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinOp);
l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp = _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp();
lean_mark_persistent(l_Lean_Meta_Tactic_BVDecide_instToExprBVUnOp);
l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred = _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred();
lean_mark_persistent(l_Lean_Meta_Tactic_BVDecide_instToExprBVBinPred);
l_Lean_Meta_Tactic_BVDecide_instToExprGate = _init_l_Lean_Meta_Tactic_BVDecide_instToExprGate();
lean_mark_persistent(l_Lean_Meta_Tactic_BVDecide_instToExprGate);
l_Lean_Meta_Tactic_BVDecide_instToExprBVPred = _init_l_Lean_Meta_Tactic_BVDecide_instToExprBVPred();
lean_mark_persistent(l_Lean_Meta_Tactic_BVDecide_instToExprBVPred);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Std_Data_HashMap(uint8_t builtin);
lean_object* initialize_Std_Tactic_BVDecide_Bitblast_BVExpr_Basic(uint8_t builtin);
lean_object* initialize_Lean_Data_RArray(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_SymM(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Std_Data_HashMap(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Std_Tactic_BVDecide_Bitblast_BVExpr_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Data_RArray(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_SymM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(builtin);
}
#ifdef __cplusplus
}
#endif
