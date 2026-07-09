// Lean compiler output
// Module: Lean.Meta.Tactic.BVDecide.Prover.Basic
// Imports: public import Lean.Meta.Tactic.BVDecide.Reflect public import Lean.Meta.Tactic.BVDecide.Counterexample public import Lean.Meta.Tactic.BVDecide.LRAT.Cert import Lean.Meta.Sym.SymM import Lean.Meta.Sym.Util
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
double lean_float_of_nat(lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
lean_object* l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_array_get_size(lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
lean_object* lean_array_push(lean_object*, lean_object*);
lean_object* lean_array_fget_borrowed(lean_object*, lean_object*);
uint8_t l_Lean_instBEqMVarId_beq(lean_object*, lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
lean_object* lean_array_fset(lean_object*, lean_object*, lean_object*);
lean_object* lean_st_ref_get(lean_object*);
lean_object* l_Lean_replaceRef(lean_object*, lean_object*);
lean_object* l_Lean_PersistentArray_toArray___redArg(lean_object*);
size_t lean_array_size(lean_object*);
uint8_t lean_usize_dec_lt(size_t, size_t);
lean_object* lean_array_uget_borrowed(lean_object*, size_t);
lean_object* lean_array_uset(lean_object*, size_t, lean_object*);
size_t lean_usize_add(size_t, size_t);
lean_object* lean_st_ref_take(lean_object*);
lean_object* l_Lean_PersistentArray_push___redArg(lean_object*, lean_object*);
lean_object* lean_st_ref_set(lean_object*, lean_object*);
extern lean_object* l_Lean_trace_profiler;
lean_object* l_Std_DTreeMap_Internal_Impl_Const_get_x3f___at___00Lean_NameMap_find_x3f_spec__0___redArg(lean_object*, lean_object*);
lean_object* l_Lean_stringToMessageData(lean_object*);
lean_object* l_Lean_PersistentArray_append___redArg(lean_object*, lean_object*);
double lean_float_sub(double, double);
uint8_t lean_float_decLt(double, double);
extern lean_object* l_Lean_trace_profiler_useHeartbeats;
extern lean_object* l_Lean_trace_profiler_threshold;
double lean_float_div(double, double);
uint64_t lean_uint64_of_nat(lean_object*);
uint64_t lean_uint64_shift_right(uint64_t, uint64_t);
uint64_t lean_uint64_xor(uint64_t, uint64_t);
size_t lean_uint64_to_usize(uint64_t);
size_t lean_usize_of_nat(lean_object*);
size_t lean_usize_sub(size_t, size_t);
size_t lean_usize_land(size_t, size_t);
lean_object* lean_nat_mul(lean_object*, lean_object*);
lean_object* lean_nat_div(lean_object*, lean_object*);
uint8_t lean_nat_dec_le(lean_object*, lean_object*);
lean_object* lean_mk_array(lean_object*, lean_object*);
lean_object* lean_array_fget(lean_object*, lean_object*);
uint64_t l_Lean_instHashableMVarId_hash(lean_object*);
size_t lean_usize_mul(size_t, size_t);
size_t lean_usize_shift_right(size_t, size_t);
lean_object* lean_usize_to_nat(size_t);
lean_object* l_Lean_PersistentHashMap_mkCollisionNode___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_PersistentHashMap_mkEmptyEntries(lean_object*, lean_object*);
uint8_t lean_usize_dec_le(size_t, size_t);
lean_object* l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(lean_object*);
lean_object* l_List_reverse___redArg(lean_object*);
uint8_t lean_usize_dec_eq(size_t, size_t);
lean_object* l_Lean_Name_mkStr1(lean_object*);
lean_object* l_Lean_Name_append(lean_object*, lean_object*);
uint8_t l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(lean_object*, lean_object*, lean_object*);
lean_object* l_Std_Tactic_BVDecide_BVPred_toString(lean_object*);
lean_object* lean_string_append(lean_object*, lean_object*);
lean_object* l_Std_Tactic_BVDecide_Gate_toString(uint8_t);
lean_object* l_Lean_MessageData_ofFormat(lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* l_Lean_Core_checkSystem(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_SatAtBVLogical_of___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_LemmaM_run___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Array_append___redArg(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_Internal_Sym_assertShared(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Array_toSubarray___redArg(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_SatAtBVLogical_and___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_ShareCommon_shareCommon___redArg(lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_SatAtBVLogical_proveFalse___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_io_mono_nanos_now();
lean_object* lean_io_get_num_heartbeats();
lean_object* l_Lean_Name_mkStr3(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "bv_decide"};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__0 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__0_value;
static const lean_array_object l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__1 = (const lean_object*)&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__1_value;
static lean_once_cell_t l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__2;
static lean_once_cell_t l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__3;
static lean_once_cell_t l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__4;
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0(lean_object*, size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 443, .m_capacity = 443, .m_length = 442, .m_data = "None of the hypotheses are in the supported BitVec fragment after applying preprocessing.\nThere are three potential reasons for this:\n1. If you are using custom BitVec constructs simplify them to built-in ones.\n2. If your problem is using only built-in ones it might currently be out of reach.\n   Consider expressing it in terms of different operations that are better supported.\n3. The original goal was reduced to False and is thus invalid."};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*1 + 0, .m_other = 1, .m_tag = 3}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__0_value)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__2;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__0;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__1;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__2;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__0;
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__1;
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg(lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__8(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__8___boxed(lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 35, .m_capacity = 35, .m_length = 34, .m_data = "Reflecting goal into BVLogicalExpr"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*1 + 0, .m_other = 1, .m_tag = 3}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__0_value)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__2;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__15(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__15___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12_spec__17(size_t, size_t, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12_spec__17___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__14(lean_object*);
LEAN_EXPORT lean_object* l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__14___boxed(lean_object*);
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___redArg(lean_object*);
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___redArg___boxed(lean_object*, lean_object*);
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static double l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__0;
static const lean_string_object l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 54, .m_capacity = 54, .m_length = 53, .m_data = "<exception thrown while producing trace node message>"};
static const lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__1 = (const lean_object*)&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__1_value;
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__2;
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static double l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__3;
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9(lean_object*, uint8_t, lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldrM___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__3(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldrM___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__3___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__4(lean_object*, size_t, size_t, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "false"};
static const lean_object* l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__0 = (const lean_object*)&l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__0_value;
static const lean_string_object l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "true"};
static const lean_object* l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__1 = (const lean_object*)&l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__1_value;
static const lean_string_object l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 2, .m_capacity = 2, .m_length = 1, .m_data = "!"};
static const lean_object* l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__2 = (const lean_object*)&l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__2_value;
static const lean_string_object l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 2, .m_capacity = 2, .m_length = 1, .m_data = "("};
static const lean_object* l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__3 = (const lean_object*)&l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__3_value;
static const lean_string_object l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 2, .m_capacity = 2, .m_length = 1, .m_data = " "};
static const lean_object* l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__4 = (const lean_object*)&l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__4_value;
static const lean_string_object l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 2, .m_capacity = 2, .m_length = 1, .m_data = ")"};
static const lean_object* l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__5 = (const lean_object*)&l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__5_value;
static const lean_string_object l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "(if "};
static const lean_object* l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__6 = (const lean_object*)&l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__6_value;
LEAN_EXPORT lean_object* l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5(lean_object*);
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__6___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15_spec__19___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20_spec__23___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20___redArg(lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg___closed__0;
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg(lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21___redArg(size_t, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_mapTR_loop___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__0(lean_object*, lean_object*);
static const lean_string_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 1, .m_capacity = 1, .m_length = 0, .m_data = ""};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___closed__0 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___closed__0_value;
static const lean_array_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___closed__1 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___closed__1_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__0;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__1;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trace"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__2_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__2_value),LEAN_SCALAR_PTR_LITERAL(212, 145, 141, 177, 67, 149, 127, 197)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__3_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 34, .m_capacity = 34, .m_length = 33, .m_data = "Reflected bv logical expression: "};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__4_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__5;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static double l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__6;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1(lean_object*, lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___boxed, .m_arity = 10, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Meta"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__1_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__2_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "bv"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__3_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__4_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(211, 174, 49, 251, 64, 24, 251, 1)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__4_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__4_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__2_value),LEAN_SCALAR_PTR_LITERAL(194, 95, 140, 15, 16, 100, 236, 219)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__4_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__3_value),LEAN_SCALAR_PTR_LITERAL(139, 41, 106, 94, 234, 34, 111, 146)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__4_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__6(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10(lean_object*, lean_object*, size_t, size_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21(lean_object*, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15_spec__19(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20_spec__23(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg___lam__0(lean_object* v_x_1_, lean_object* v___y_2_, lean_object* v___y_3_, lean_object* v___y_4_, lean_object* v___y_5_, lean_object* v___y_6_, lean_object* v___y_7_, lean_object* v___y_8_, lean_object* v___y_9_){
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
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg___lam__0___boxed(lean_object* v_x_12_, lean_object* v___y_13_, lean_object* v___y_14_, lean_object* v___y_15_, lean_object* v___y_16_, lean_object* v___y_17_, lean_object* v___y_18_, lean_object* v___y_19_, lean_object* v___y_20_, lean_object* v___y_21_){
_start:
{
lean_object* v_res_22_; 
v_res_22_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg___lam__0(v_x_12_, v___y_13_, v___y_14_, v___y_15_, v___y_16_, v___y_17_, v___y_18_, v___y_19_, v___y_20_);
lean_dec(v___y_16_);
lean_dec_ref(v___y_15_);
lean_dec(v___y_14_);
lean_dec_ref(v___y_13_);
return v_res_22_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg(lean_object* v_mvarId_23_, lean_object* v_x_24_, lean_object* v___y_25_, lean_object* v___y_26_, lean_object* v___y_27_, lean_object* v___y_28_, lean_object* v___y_29_, lean_object* v___y_30_, lean_object* v___y_31_, lean_object* v___y_32_){
_start:
{
lean_object* v___f_34_; lean_object* v___x_35_; 
lean_inc(v___y_28_);
lean_inc_ref(v___y_27_);
lean_inc(v___y_26_);
lean_inc_ref(v___y_25_);
v___f_34_ = lean_alloc_closure((void*)(l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg___lam__0___boxed), 10, 5);
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
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg___boxed(lean_object* v_mvarId_44_, lean_object* v_x_45_, lean_object* v___y_46_, lean_object* v___y_47_, lean_object* v___y_48_, lean_object* v___y_49_, lean_object* v___y_50_, lean_object* v___y_51_, lean_object* v___y_52_, lean_object* v___y_53_, lean_object* v___y_54_){
_start:
{
lean_object* v_res_55_; 
v_res_55_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg(v_mvarId_44_, v_x_45_, v___y_46_, v___y_47_, v___y_48_, v___y_49_, v___y_50_, v___y_51_, v___y_52_, v___y_53_);
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
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3(lean_object* v_00_u03b1_56_, lean_object* v_mvarId_57_, lean_object* v_x_58_, lean_object* v___y_59_, lean_object* v___y_60_, lean_object* v___y_61_, lean_object* v___y_62_, lean_object* v___y_63_, lean_object* v___y_64_, lean_object* v___y_65_, lean_object* v___y_66_){
_start:
{
lean_object* v___x_68_; 
v___x_68_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg(v_mvarId_57_, v_x_58_, v___y_59_, v___y_60_, v___y_61_, v___y_62_, v___y_63_, v___y_64_, v___y_65_, v___y_66_);
return v___x_68_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___boxed(lean_object* v_00_u03b1_69_, lean_object* v_mvarId_70_, lean_object* v_x_71_, lean_object* v___y_72_, lean_object* v___y_73_, lean_object* v___y_74_, lean_object* v___y_75_, lean_object* v___y_76_, lean_object* v___y_77_, lean_object* v___y_78_, lean_object* v___y_79_, lean_object* v___y_80_){
_start:
{
lean_object* v_res_81_; 
v_res_81_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3(v_00_u03b1_69_, v_mvarId_70_, v_x_71_, v___y_72_, v___y_73_, v___y_74_, v___y_75_, v___y_76_, v___y_77_, v___y_78_, v___y_79_);
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
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1___redArg(lean_object* v_a_82_, lean_object* v_b_83_, lean_object* v___y_84_, lean_object* v___y_85_, lean_object* v___y_86_, lean_object* v___y_87_, lean_object* v___y_88_, lean_object* v___y_89_){
_start:
{
lean_object* v_array_91_; lean_object* v_start_92_; lean_object* v_stop_93_; lean_object* v___x_95_; uint8_t v_isShared_96_; uint8_t v_isSharedCheck_108_; 
v_array_91_ = lean_ctor_get(v_a_82_, 0);
v_start_92_ = lean_ctor_get(v_a_82_, 1);
v_stop_93_ = lean_ctor_get(v_a_82_, 2);
v_isSharedCheck_108_ = !lean_is_exclusive(v_a_82_);
if (v_isSharedCheck_108_ == 0)
{
v___x_95_ = v_a_82_;
v_isShared_96_ = v_isSharedCheck_108_;
goto v_resetjp_94_;
}
else
{
lean_inc(v_stop_93_);
lean_inc(v_start_92_);
lean_inc(v_array_91_);
lean_dec(v_a_82_);
v___x_95_ = lean_box(0);
v_isShared_96_ = v_isSharedCheck_108_;
goto v_resetjp_94_;
}
v_resetjp_94_:
{
uint8_t v___x_97_; 
v___x_97_ = lean_nat_dec_lt(v_start_92_, v_stop_93_);
if (v___x_97_ == 0)
{
lean_object* v___x_98_; 
lean_del_object(v___x_95_);
lean_dec(v_stop_93_);
lean_dec(v_start_92_);
lean_dec_ref(v_array_91_);
v___x_98_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_98_, 0, v_b_83_);
return v___x_98_;
}
else
{
lean_object* v___x_99_; lean_object* v___x_100_; 
v___x_99_ = lean_array_fget_borrowed(v_array_91_, v_start_92_);
lean_inc(v___x_99_);
v___x_100_ = l_Lean_Meta_Tactic_BVDecide_SatAtBVLogical_and___redArg(v_b_83_, v___x_99_, v___y_84_, v___y_85_, v___y_86_, v___y_87_, v___y_88_, v___y_89_);
if (lean_obj_tag(v___x_100_) == 0)
{
lean_object* v_a_101_; lean_object* v___x_102_; lean_object* v___x_103_; lean_object* v___x_105_; 
v_a_101_ = lean_ctor_get(v___x_100_, 0);
lean_inc(v_a_101_);
lean_dec_ref_known(v___x_100_, 1);
v___x_102_ = lean_unsigned_to_nat(1u);
v___x_103_ = lean_nat_add(v_start_92_, v___x_102_);
lean_dec(v_start_92_);
if (v_isShared_96_ == 0)
{
lean_ctor_set(v___x_95_, 1, v___x_103_);
v___x_105_ = v___x_95_;
goto v_reusejp_104_;
}
else
{
lean_object* v_reuseFailAlloc_107_; 
v_reuseFailAlloc_107_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v_reuseFailAlloc_107_, 0, v_array_91_);
lean_ctor_set(v_reuseFailAlloc_107_, 1, v___x_103_);
lean_ctor_set(v_reuseFailAlloc_107_, 2, v_stop_93_);
v___x_105_ = v_reuseFailAlloc_107_;
goto v_reusejp_104_;
}
v_reusejp_104_:
{
v_a_82_ = v___x_105_;
v_b_83_ = v_a_101_;
goto _start;
}
}
else
{
lean_del_object(v___x_95_);
lean_dec(v_stop_93_);
lean_dec(v_start_92_);
lean_dec_ref(v_array_91_);
return v___x_100_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1___redArg___boxed(lean_object* v_a_109_, lean_object* v_b_110_, lean_object* v___y_111_, lean_object* v___y_112_, lean_object* v___y_113_, lean_object* v___y_114_, lean_object* v___y_115_, lean_object* v___y_116_, lean_object* v___y_117_){
_start:
{
lean_object* v_res_118_; 
v_res_118_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1___redArg(v_a_109_, v_b_110_, v___y_111_, v___y_112_, v___y_113_, v___y_114_, v___y_115_, v___y_116_);
lean_dec(v___y_116_);
lean_dec_ref(v___y_115_);
lean_dec(v___y_114_);
lean_dec_ref(v___y_113_);
lean_dec(v___y_112_);
lean_dec_ref(v___y_111_);
return v_res_118_;
}
}
static lean_object* _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__2(void){
_start:
{
lean_object* v___x_122_; lean_object* v___x_123_; lean_object* v___x_124_; 
v___x_122_ = lean_box(0);
v___x_123_ = lean_unsigned_to_nat(16u);
v___x_124_ = lean_mk_array(v___x_123_, v___x_122_);
return v___x_124_;
}
}
static lean_object* _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__3(void){
_start:
{
lean_object* v___x_125_; lean_object* v___x_126_; lean_object* v___x_127_; 
v___x_125_ = lean_obj_once(&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__2, &l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__2_once, _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__2);
v___x_126_ = lean_unsigned_to_nat(0u);
v___x_127_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_127_, 0, v___x_126_);
lean_ctor_set(v___x_127_, 1, v___x_125_);
return v___x_127_;
}
}
static lean_object* _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__4(void){
_start:
{
lean_object* v___x_128_; lean_object* v_sats_129_; lean_object* v___x_130_; 
v___x_128_ = lean_obj_once(&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__3, &l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__3_once, _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__3);
v_sats_129_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__1));
v___x_130_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_130_, 0, v_sats_129_);
lean_ctor_set(v___x_130_, 1, v___x_128_);
lean_ctor_set(v___x_130_, 2, v___x_128_);
lean_ctor_set(v___x_130_, 3, v___x_128_);
return v___x_130_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0(lean_object* v_as_131_, size_t v_sz_132_, size_t v_i_133_, lean_object* v_b_134_, lean_object* v___y_135_, lean_object* v___y_136_, lean_object* v___y_137_, lean_object* v___y_138_, lean_object* v___y_139_, lean_object* v___y_140_, lean_object* v___y_141_, lean_object* v___y_142_){
_start:
{
lean_object* v_a_145_; uint8_t v___x_149_; 
v___x_149_ = lean_usize_dec_lt(v_i_133_, v_sz_132_);
if (v___x_149_ == 0)
{
lean_object* v___x_150_; 
v___x_150_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_150_, 0, v_b_134_);
return v___x_150_;
}
else
{
lean_object* v___x_151_; lean_object* v___x_152_; 
v___x_151_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__0));
v___x_152_ = l_Lean_Core_checkSystem(v___x_151_, v___y_141_, v___y_142_);
if (lean_obj_tag(v___x_152_) == 0)
{
lean_object* v___x_153_; uint8_t v_debug_154_; lean_object* v_a_155_; lean_object* v___y_157_; lean_object* v___y_158_; lean_object* v___y_159_; lean_object* v___y_160_; lean_object* v___y_161_; lean_object* v___y_162_; lean_object* v___y_163_; lean_object* v___y_164_; 
lean_dec_ref_known(v___x_152_, 1);
v___x_153_ = lean_st_ref_get(v___y_138_);
v_debug_154_ = lean_ctor_get_uint8(v___x_153_, sizeof(void*)*10);
lean_dec(v___x_153_);
v_a_155_ = lean_array_uget_borrowed(v_as_131_, v_i_133_);
if (v_debug_154_ == 0)
{
v___y_157_ = v___y_135_;
v___y_158_ = v___y_136_;
v___y_159_ = v___y_137_;
v___y_160_ = v___y_138_;
v___y_161_ = v___y_139_;
v___y_162_ = v___y_140_;
v___y_163_ = v___y_141_;
v___y_164_ = v___y_142_;
goto v___jp_156_;
}
else
{
lean_object* v_type_182_; lean_object* v___x_183_; 
v_type_182_ = lean_ctor_get(v_a_155_, 1);
lean_inc_ref(v_type_182_);
v___x_183_ = l_Lean_Meta_Sym_Internal_Sym_assertShared(v_type_182_, v___y_137_, v___y_138_, v___y_139_, v___y_140_, v___y_141_, v___y_142_);
if (lean_obj_tag(v___x_183_) == 0)
{
lean_dec_ref_known(v___x_183_, 1);
v___y_157_ = v___y_135_;
v___y_158_ = v___y_136_;
v___y_159_ = v___y_137_;
v___y_160_ = v___y_138_;
v___y_161_ = v___y_139_;
v___y_162_ = v___y_140_;
v___y_163_ = v___y_141_;
v___y_164_ = v___y_142_;
goto v___jp_156_;
}
else
{
lean_object* v_a_184_; lean_object* v___x_186_; uint8_t v_isShared_187_; uint8_t v_isSharedCheck_191_; 
lean_dec_ref(v_b_134_);
v_a_184_ = lean_ctor_get(v___x_183_, 0);
v_isSharedCheck_191_ = !lean_is_exclusive(v___x_183_);
if (v_isSharedCheck_191_ == 0)
{
v___x_186_ = v___x_183_;
v_isShared_187_ = v_isSharedCheck_191_;
goto v_resetjp_185_;
}
else
{
lean_inc(v_a_184_);
lean_dec(v___x_183_);
v___x_186_ = lean_box(0);
v_isShared_187_ = v_isSharedCheck_191_;
goto v_resetjp_185_;
}
v_resetjp_185_:
{
lean_object* v___x_189_; 
if (v_isShared_187_ == 0)
{
v___x_189_ = v___x_186_;
goto v_reusejp_188_;
}
else
{
lean_object* v_reuseFailAlloc_190_; 
v_reuseFailAlloc_190_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_190_, 0, v_a_184_);
v___x_189_ = v_reuseFailAlloc_190_;
goto v_reusejp_188_;
}
v_reusejp_188_:
{
return v___x_189_;
}
}
}
}
v___jp_156_:
{
lean_object* v___x_165_; lean_object* v___x_166_; lean_object* v___x_167_; 
lean_inc(v_a_155_);
v___x_165_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_SatAtBVLogical_of___boxed), 11, 1);
lean_closure_set(v___x_165_, 0, v_a_155_);
v___x_166_ = lean_obj_once(&l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__4, &l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__4_once, _init_l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__4);
v___x_167_ = l_Lean_Meta_Tactic_BVDecide_LemmaM_run___redArg(v___x_165_, v___x_166_, v___y_157_, v___y_158_, v___y_159_, v___y_160_, v___y_161_, v___y_162_, v___y_163_, v___y_164_);
if (lean_obj_tag(v___x_167_) == 0)
{
lean_object* v_a_168_; lean_object* v_fst_169_; 
v_a_168_ = lean_ctor_get(v___x_167_, 0);
lean_inc(v_a_168_);
lean_dec_ref_known(v___x_167_, 1);
v_fst_169_ = lean_ctor_get(v_a_168_, 0);
lean_inc(v_fst_169_);
if (lean_obj_tag(v_fst_169_) == 1)
{
lean_object* v_snd_170_; lean_object* v_val_171_; lean_object* v___x_172_; lean_object* v___x_173_; 
v_snd_170_ = lean_ctor_get(v_a_168_, 1);
lean_inc(v_snd_170_);
lean_dec(v_a_168_);
v_val_171_ = lean_ctor_get(v_fst_169_, 0);
lean_inc(v_val_171_);
lean_dec_ref_known(v_fst_169_, 1);
v___x_172_ = l_Array_append___redArg(v_b_134_, v_snd_170_);
lean_dec(v_snd_170_);
v___x_173_ = lean_array_push(v___x_172_, v_val_171_);
v_a_145_ = v___x_173_;
goto v___jp_144_;
}
else
{
lean_dec(v_fst_169_);
lean_dec(v_a_168_);
v_a_145_ = v_b_134_;
goto v___jp_144_;
}
}
else
{
lean_object* v_a_174_; lean_object* v___x_176_; uint8_t v_isShared_177_; uint8_t v_isSharedCheck_181_; 
lean_dec_ref(v_b_134_);
v_a_174_ = lean_ctor_get(v___x_167_, 0);
v_isSharedCheck_181_ = !lean_is_exclusive(v___x_167_);
if (v_isSharedCheck_181_ == 0)
{
v___x_176_ = v___x_167_;
v_isShared_177_ = v_isSharedCheck_181_;
goto v_resetjp_175_;
}
else
{
lean_inc(v_a_174_);
lean_dec(v___x_167_);
v___x_176_ = lean_box(0);
v_isShared_177_ = v_isSharedCheck_181_;
goto v_resetjp_175_;
}
v_resetjp_175_:
{
lean_object* v___x_179_; 
if (v_isShared_177_ == 0)
{
v___x_179_ = v___x_176_;
goto v_reusejp_178_;
}
else
{
lean_object* v_reuseFailAlloc_180_; 
v_reuseFailAlloc_180_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_180_, 0, v_a_174_);
v___x_179_ = v_reuseFailAlloc_180_;
goto v_reusejp_178_;
}
v_reusejp_178_:
{
return v___x_179_;
}
}
}
}
}
else
{
lean_object* v_a_192_; lean_object* v___x_194_; uint8_t v_isShared_195_; uint8_t v_isSharedCheck_199_; 
lean_dec_ref(v_b_134_);
v_a_192_ = lean_ctor_get(v___x_152_, 0);
v_isSharedCheck_199_ = !lean_is_exclusive(v___x_152_);
if (v_isSharedCheck_199_ == 0)
{
v___x_194_ = v___x_152_;
v_isShared_195_ = v_isSharedCheck_199_;
goto v_resetjp_193_;
}
else
{
lean_inc(v_a_192_);
lean_dec(v___x_152_);
v___x_194_ = lean_box(0);
v_isShared_195_ = v_isSharedCheck_199_;
goto v_resetjp_193_;
}
v_resetjp_193_:
{
lean_object* v___x_197_; 
if (v_isShared_195_ == 0)
{
v___x_197_ = v___x_194_;
goto v_reusejp_196_;
}
else
{
lean_object* v_reuseFailAlloc_198_; 
v_reuseFailAlloc_198_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_198_, 0, v_a_192_);
v___x_197_ = v_reuseFailAlloc_198_;
goto v_reusejp_196_;
}
v_reusejp_196_:
{
return v___x_197_;
}
}
}
}
v___jp_144_:
{
size_t v___x_146_; size_t v___x_147_; 
v___x_146_ = ((size_t)1ULL);
v___x_147_ = lean_usize_add(v_i_133_, v___x_146_);
v_i_133_ = v___x_147_;
v_b_134_ = v_a_145_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___boxed(lean_object* v_as_200_, lean_object* v_sz_201_, lean_object* v_i_202_, lean_object* v_b_203_, lean_object* v___y_204_, lean_object* v___y_205_, lean_object* v___y_206_, lean_object* v___y_207_, lean_object* v___y_208_, lean_object* v___y_209_, lean_object* v___y_210_, lean_object* v___y_211_, lean_object* v___y_212_){
_start:
{
size_t v_sz_boxed_213_; size_t v_i_boxed_214_; lean_object* v_res_215_; 
v_sz_boxed_213_ = lean_unbox_usize(v_sz_201_);
lean_dec(v_sz_201_);
v_i_boxed_214_ = lean_unbox_usize(v_i_202_);
lean_dec(v_i_202_);
v_res_215_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0(v_as_200_, v_sz_boxed_213_, v_i_boxed_214_, v_b_203_, v___y_204_, v___y_205_, v___y_206_, v___y_207_, v___y_208_, v___y_209_, v___y_210_, v___y_211_);
lean_dec(v___y_211_);
lean_dec_ref(v___y_210_);
lean_dec(v___y_209_);
lean_dec_ref(v___y_208_);
lean_dec(v___y_207_);
lean_dec_ref(v___y_206_);
lean_dec(v___y_205_);
lean_dec_ref(v___y_204_);
lean_dec_ref(v_as_200_);
return v_res_215_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2_spec__2(lean_object* v_msgData_216_, lean_object* v___y_217_, lean_object* v___y_218_, lean_object* v___y_219_, lean_object* v___y_220_){
_start:
{
lean_object* v___x_222_; lean_object* v_env_223_; lean_object* v___x_224_; lean_object* v_mctx_225_; lean_object* v_lctx_226_; lean_object* v_options_227_; lean_object* v___x_228_; lean_object* v___x_229_; lean_object* v___x_230_; 
v___x_222_ = lean_st_ref_get(v___y_220_);
v_env_223_ = lean_ctor_get(v___x_222_, 0);
lean_inc_ref(v_env_223_);
lean_dec(v___x_222_);
v___x_224_ = lean_st_ref_get(v___y_218_);
v_mctx_225_ = lean_ctor_get(v___x_224_, 0);
lean_inc_ref(v_mctx_225_);
lean_dec(v___x_224_);
v_lctx_226_ = lean_ctor_get(v___y_217_, 2);
v_options_227_ = lean_ctor_get(v___y_219_, 2);
lean_inc_ref(v_options_227_);
lean_inc_ref(v_lctx_226_);
v___x_228_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_228_, 0, v_env_223_);
lean_ctor_set(v___x_228_, 1, v_mctx_225_);
lean_ctor_set(v___x_228_, 2, v_lctx_226_);
lean_ctor_set(v___x_228_, 3, v_options_227_);
v___x_229_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v___x_229_, 0, v___x_228_);
lean_ctor_set(v___x_229_, 1, v_msgData_216_);
v___x_230_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_230_, 0, v___x_229_);
return v___x_230_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2_spec__2___boxed(lean_object* v_msgData_231_, lean_object* v___y_232_, lean_object* v___y_233_, lean_object* v___y_234_, lean_object* v___y_235_, lean_object* v___y_236_){
_start:
{
lean_object* v_res_237_; 
v_res_237_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2_spec__2(v_msgData_231_, v___y_232_, v___y_233_, v___y_234_, v___y_235_);
lean_dec(v___y_235_);
lean_dec_ref(v___y_234_);
lean_dec(v___y_233_);
lean_dec_ref(v___y_232_);
return v_res_237_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2___redArg(lean_object* v_msg_238_, lean_object* v___y_239_, lean_object* v___y_240_, lean_object* v___y_241_, lean_object* v___y_242_){
_start:
{
lean_object* v_ref_244_; lean_object* v___x_245_; lean_object* v_a_246_; lean_object* v___x_248_; uint8_t v_isShared_249_; uint8_t v_isSharedCheck_254_; 
v_ref_244_ = lean_ctor_get(v___y_241_, 5);
v___x_245_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2_spec__2(v_msg_238_, v___y_239_, v___y_240_, v___y_241_, v___y_242_);
v_a_246_ = lean_ctor_get(v___x_245_, 0);
v_isSharedCheck_254_ = !lean_is_exclusive(v___x_245_);
if (v_isSharedCheck_254_ == 0)
{
v___x_248_ = v___x_245_;
v_isShared_249_ = v_isSharedCheck_254_;
goto v_resetjp_247_;
}
else
{
lean_inc(v_a_246_);
lean_dec(v___x_245_);
v___x_248_ = lean_box(0);
v_isShared_249_ = v_isSharedCheck_254_;
goto v_resetjp_247_;
}
v_resetjp_247_:
{
lean_object* v___x_250_; lean_object* v___x_252_; 
lean_inc(v_ref_244_);
v___x_250_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_250_, 0, v_ref_244_);
lean_ctor_set(v___x_250_, 1, v_a_246_);
if (v_isShared_249_ == 0)
{
lean_ctor_set_tag(v___x_248_, 1);
lean_ctor_set(v___x_248_, 0, v___x_250_);
v___x_252_ = v___x_248_;
goto v_reusejp_251_;
}
else
{
lean_object* v_reuseFailAlloc_253_; 
v_reuseFailAlloc_253_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_253_, 0, v___x_250_);
v___x_252_ = v_reuseFailAlloc_253_;
goto v_reusejp_251_;
}
v_reusejp_251_:
{
return v___x_252_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2___redArg___boxed(lean_object* v_msg_255_, lean_object* v___y_256_, lean_object* v___y_257_, lean_object* v___y_258_, lean_object* v___y_259_, lean_object* v___y_260_){
_start:
{
lean_object* v_res_261_; 
v_res_261_ = l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2___redArg(v_msg_255_, v___y_256_, v___y_257_, v___y_258_, v___y_259_);
lean_dec(v___y_259_);
lean_dec_ref(v___y_258_);
lean_dec(v___y_257_);
lean_dec_ref(v___y_256_);
return v_res_261_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__2(void){
_start:
{
lean_object* v___x_265_; lean_object* v___x_266_; 
v___x_265_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__1));
v___x_266_ = l_Lean_MessageData_ofFormat(v___x_265_);
return v___x_266_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0(lean_object* v_sats_267_, lean_object* v___x_268_, lean_object* v_unusedHypotheses_269_, lean_object* v___y_270_, lean_object* v___y_271_, lean_object* v___y_272_, lean_object* v___y_273_, lean_object* v___y_274_, lean_object* v___y_275_, lean_object* v___y_276_, lean_object* v___y_277_){
_start:
{
size_t v_sz_279_; size_t v___x_280_; lean_object* v___x_281_; 
v_sz_279_ = lean_array_size(v___y_270_);
v___x_280_ = ((size_t)0ULL);
v___x_281_ = l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0(v___y_270_, v_sz_279_, v___x_280_, v_sats_267_, v___y_270_, v___y_271_, v___y_272_, v___y_273_, v___y_274_, v___y_275_, v___y_276_, v___y_277_);
if (lean_obj_tag(v___x_281_) == 0)
{
lean_object* v_a_282_; lean_object* v___x_283_; uint8_t v___x_284_; 
v_a_282_ = lean_ctor_get(v___x_281_, 0);
lean_inc(v_a_282_);
lean_dec_ref_known(v___x_281_, 1);
v___x_283_ = lean_array_get_size(v_a_282_);
v___x_284_ = lean_nat_dec_eq(v___x_283_, v___x_268_);
if (v___x_284_ == 0)
{
lean_object* v___x_285_; lean_object* v___x_286_; lean_object* v___x_287_; lean_object* v___x_288_; 
v___x_285_ = lean_array_fget(v_a_282_, v___x_268_);
v___x_286_ = lean_unsigned_to_nat(1u);
v___x_287_ = l_Array_toSubarray___redArg(v_a_282_, v___x_286_, v___x_283_);
v___x_288_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1___redArg(v___x_287_, v___x_285_, v___y_272_, v___y_273_, v___y_274_, v___y_275_, v___y_276_, v___y_277_);
if (lean_obj_tag(v___x_288_) == 0)
{
lean_object* v_a_289_; lean_object* v___x_291_; uint8_t v_isShared_292_; uint8_t v_isSharedCheck_301_; 
v_a_289_ = lean_ctor_get(v___x_288_, 0);
v_isSharedCheck_301_ = !lean_is_exclusive(v___x_288_);
if (v_isSharedCheck_301_ == 0)
{
v___x_291_ = v___x_288_;
v_isShared_292_ = v_isSharedCheck_301_;
goto v_resetjp_290_;
}
else
{
lean_inc(v_a_289_);
lean_dec(v___x_288_);
v___x_291_ = lean_box(0);
v_isShared_292_ = v_isSharedCheck_301_;
goto v_resetjp_290_;
}
v_resetjp_290_:
{
lean_object* v_bvExpr_293_; lean_object* v_expr_294_; lean_object* v___x_295_; lean_object* v___x_296_; lean_object* v___x_297_; lean_object* v___x_299_; 
v_bvExpr_293_ = lean_ctor_get(v_a_289_, 0);
v_expr_294_ = lean_ctor_get(v_a_289_, 2);
lean_inc_ref(v_expr_294_);
lean_inc_ref(v_bvExpr_293_);
v___x_295_ = l_Lean_ShareCommon_shareCommon___redArg(v_bvExpr_293_);
v___x_296_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_SatAtBVLogical_proveFalse___boxed), 11, 1);
lean_closure_set(v___x_296_, 0, v_a_289_);
v___x_297_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_297_, 0, v___x_295_);
lean_ctor_set(v___x_297_, 1, v___x_296_);
lean_ctor_set(v___x_297_, 2, v_unusedHypotheses_269_);
lean_ctor_set(v___x_297_, 3, v_expr_294_);
if (v_isShared_292_ == 0)
{
lean_ctor_set(v___x_291_, 0, v___x_297_);
v___x_299_ = v___x_291_;
goto v_reusejp_298_;
}
else
{
lean_object* v_reuseFailAlloc_300_; 
v_reuseFailAlloc_300_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_300_, 0, v___x_297_);
v___x_299_ = v_reuseFailAlloc_300_;
goto v_reusejp_298_;
}
v_reusejp_298_:
{
return v___x_299_;
}
}
}
else
{
lean_object* v_a_302_; lean_object* v___x_304_; uint8_t v_isShared_305_; uint8_t v_isSharedCheck_309_; 
lean_dec_ref(v_unusedHypotheses_269_);
v_a_302_ = lean_ctor_get(v___x_288_, 0);
v_isSharedCheck_309_ = !lean_is_exclusive(v___x_288_);
if (v_isSharedCheck_309_ == 0)
{
v___x_304_ = v___x_288_;
v_isShared_305_ = v_isSharedCheck_309_;
goto v_resetjp_303_;
}
else
{
lean_inc(v_a_302_);
lean_dec(v___x_288_);
v___x_304_ = lean_box(0);
v_isShared_305_ = v_isSharedCheck_309_;
goto v_resetjp_303_;
}
v_resetjp_303_:
{
lean_object* v___x_307_; 
if (v_isShared_305_ == 0)
{
v___x_307_ = v___x_304_;
goto v_reusejp_306_;
}
else
{
lean_object* v_reuseFailAlloc_308_; 
v_reuseFailAlloc_308_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_308_, 0, v_a_302_);
v___x_307_ = v_reuseFailAlloc_308_;
goto v_reusejp_306_;
}
v_reusejp_306_:
{
return v___x_307_;
}
}
}
}
else
{
lean_object* v___x_310_; lean_object* v___x_311_; 
lean_dec(v_a_282_);
lean_dec_ref(v_unusedHypotheses_269_);
v___x_310_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__2, &l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___closed__2);
v___x_311_ = l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2___redArg(v___x_310_, v___y_274_, v___y_275_, v___y_276_, v___y_277_);
return v___x_311_;
}
}
else
{
lean_object* v_a_312_; lean_object* v___x_314_; uint8_t v_isShared_315_; uint8_t v_isSharedCheck_319_; 
lean_dec_ref(v_unusedHypotheses_269_);
v_a_312_ = lean_ctor_get(v___x_281_, 0);
v_isSharedCheck_319_ = !lean_is_exclusive(v___x_281_);
if (v_isSharedCheck_319_ == 0)
{
v___x_314_ = v___x_281_;
v_isShared_315_ = v_isSharedCheck_319_;
goto v_resetjp_313_;
}
else
{
lean_inc(v_a_312_);
lean_dec(v___x_281_);
v___x_314_ = lean_box(0);
v_isShared_315_ = v_isSharedCheck_319_;
goto v_resetjp_313_;
}
v_resetjp_313_:
{
lean_object* v___x_317_; 
if (v_isShared_315_ == 0)
{
v___x_317_ = v___x_314_;
goto v_reusejp_316_;
}
else
{
lean_object* v_reuseFailAlloc_318_; 
v_reuseFailAlloc_318_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_318_, 0, v_a_312_);
v___x_317_ = v_reuseFailAlloc_318_;
goto v_reusejp_316_;
}
v_reusejp_316_:
{
return v___x_317_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___boxed(lean_object* v_sats_320_, lean_object* v___x_321_, lean_object* v_unusedHypotheses_322_, lean_object* v___y_323_, lean_object* v___y_324_, lean_object* v___y_325_, lean_object* v___y_326_, lean_object* v___y_327_, lean_object* v___y_328_, lean_object* v___y_329_, lean_object* v___y_330_, lean_object* v___y_331_){
_start:
{
lean_object* v_res_332_; 
v_res_332_ = l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0(v_sats_320_, v___x_321_, v_unusedHypotheses_322_, v___y_323_, v___y_324_, v___y_325_, v___y_326_, v___y_327_, v___y_328_, v___y_329_, v___y_330_);
lean_dec(v___y_330_);
lean_dec_ref(v___y_329_);
lean_dec(v___y_328_);
lean_dec_ref(v___y_327_);
lean_dec(v___y_326_);
lean_dec_ref(v___y_325_);
lean_dec(v___y_324_);
lean_dec_ref(v___y_323_);
lean_dec(v___x_321_);
return v_res_332_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__0(void){
_start:
{
lean_object* v___x_333_; lean_object* v___x_334_; lean_object* v___x_335_; 
v___x_333_ = lean_box(0);
v___x_334_ = lean_unsigned_to_nat(16u);
v___x_335_ = lean_mk_array(v___x_334_, v___x_333_);
return v___x_335_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__1(void){
_start:
{
lean_object* v___x_336_; lean_object* v___x_337_; lean_object* v_unusedHypotheses_338_; 
v___x_336_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__0, &l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__0_once, _init_l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__0);
v___x_337_ = lean_unsigned_to_nat(0u);
v_unusedHypotheses_338_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_unusedHypotheses_338_, 0, v___x_337_);
lean_ctor_set(v_unusedHypotheses_338_, 1, v___x_336_);
return v_unusedHypotheses_338_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__2(void){
_start:
{
lean_object* v_unusedHypotheses_339_; lean_object* v___x_340_; lean_object* v_sats_341_; lean_object* v___f_342_; 
v_unusedHypotheses_339_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__1, &l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__1);
v___x_340_ = lean_unsigned_to_nat(0u);
v_sats_341_ = ((lean_object*)(l___private_Init_Data_Array_Basic_0__Array_forIn_x27Unsafe_loop___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__0___closed__1));
v___f_342_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_reflectBV___lam__0___boxed), 12, 3);
lean_closure_set(v___f_342_, 0, v_sats_341_);
lean_closure_set(v___f_342_, 1, v___x_340_);
lean_closure_set(v___f_342_, 2, v_unusedHypotheses_339_);
return v___f_342_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV(lean_object* v_g_343_, lean_object* v_a_344_, lean_object* v_a_345_, lean_object* v_a_346_, lean_object* v_a_347_, lean_object* v_a_348_, lean_object* v_a_349_, lean_object* v_a_350_, lean_object* v_a_351_){
_start:
{
lean_object* v___f_353_; lean_object* v___x_354_; 
v___f_353_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__2, &l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_reflectBV___closed__2);
v___x_354_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg(v_g_343_, v___f_353_, v_a_344_, v_a_345_, v_a_346_, v_a_347_, v_a_348_, v_a_349_, v_a_350_, v_a_351_);
return v___x_354_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_reflectBV___boxed(lean_object* v_g_355_, lean_object* v_a_356_, lean_object* v_a_357_, lean_object* v_a_358_, lean_object* v_a_359_, lean_object* v_a_360_, lean_object* v_a_361_, lean_object* v_a_362_, lean_object* v_a_363_, lean_object* v_a_364_){
_start:
{
lean_object* v_res_365_; 
v_res_365_ = l_Lean_Meta_Tactic_BVDecide_reflectBV(v_g_355_, v_a_356_, v_a_357_, v_a_358_, v_a_359_, v_a_360_, v_a_361_, v_a_362_, v_a_363_);
lean_dec(v_a_363_);
lean_dec_ref(v_a_362_);
lean_dec(v_a_361_);
lean_dec_ref(v_a_360_);
lean_dec(v_a_359_);
lean_dec_ref(v_a_358_);
lean_dec(v_a_357_);
lean_dec_ref(v_a_356_);
return v_res_365_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1(lean_object* v_inst_366_, lean_object* v_R_367_, lean_object* v_a_368_, lean_object* v_b_369_, lean_object* v_c_370_, lean_object* v___y_371_, lean_object* v___y_372_, lean_object* v___y_373_, lean_object* v___y_374_, lean_object* v___y_375_, lean_object* v___y_376_, lean_object* v___y_377_, lean_object* v___y_378_){
_start:
{
lean_object* v___x_380_; 
v___x_380_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1___redArg(v_a_368_, v_b_369_, v___y_373_, v___y_374_, v___y_375_, v___y_376_, v___y_377_, v___y_378_);
return v___x_380_;
}
}
LEAN_EXPORT lean_object* l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1___boxed(lean_object* v_inst_381_, lean_object* v_R_382_, lean_object* v_a_383_, lean_object* v_b_384_, lean_object* v_c_385_, lean_object* v___y_386_, lean_object* v___y_387_, lean_object* v___y_388_, lean_object* v___y_389_, lean_object* v___y_390_, lean_object* v___y_391_, lean_object* v___y_392_, lean_object* v___y_393_, lean_object* v___y_394_){
_start:
{
lean_object* v_res_395_; 
v_res_395_ = l_WellFounded_opaqueFix_u2083___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__1(v_inst_381_, v_R_382_, v_a_383_, v_b_384_, v_c_385_, v___y_386_, v___y_387_, v___y_388_, v___y_389_, v___y_390_, v___y_391_, v___y_392_, v___y_393_);
lean_dec(v___y_393_);
lean_dec_ref(v___y_392_);
lean_dec(v___y_391_);
lean_dec_ref(v___y_390_);
lean_dec(v___y_389_);
lean_dec_ref(v___y_388_);
lean_dec(v___y_387_);
lean_dec_ref(v___y_386_);
return v_res_395_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2(lean_object* v_00_u03b1_396_, lean_object* v_msg_397_, lean_object* v___y_398_, lean_object* v___y_399_, lean_object* v___y_400_, lean_object* v___y_401_, lean_object* v___y_402_, lean_object* v___y_403_, lean_object* v___y_404_, lean_object* v___y_405_){
_start:
{
lean_object* v___x_407_; 
v___x_407_ = l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2___redArg(v_msg_397_, v___y_402_, v___y_403_, v___y_404_, v___y_405_);
return v___x_407_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2___boxed(lean_object* v_00_u03b1_408_, lean_object* v_msg_409_, lean_object* v___y_410_, lean_object* v___y_411_, lean_object* v___y_412_, lean_object* v___y_413_, lean_object* v___y_414_, lean_object* v___y_415_, lean_object* v___y_416_, lean_object* v___y_417_, lean_object* v___y_418_){
_start:
{
lean_object* v_res_419_; 
v_res_419_ = l_Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2(v_00_u03b1_408_, v_msg_409_, v___y_410_, v___y_411_, v___y_412_, v___y_413_, v___y_414_, v___y_415_, v___y_416_, v___y_417_);
lean_dec(v___y_417_);
lean_dec_ref(v___y_416_);
lean_dec(v___y_415_);
lean_dec_ref(v___y_414_);
lean_dec(v___y_413_);
lean_dec_ref(v___y_412_);
lean_dec(v___y_411_);
lean_dec_ref(v___y_410_);
return v_res_419_;
}
}
static lean_object* _init_l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__0(void){
_start:
{
lean_object* v___x_420_; lean_object* v___x_421_; lean_object* v___x_422_; 
v___x_420_ = lean_unsigned_to_nat(32u);
v___x_421_ = lean_mk_empty_array_with_capacity(v___x_420_);
v___x_422_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_422_, 0, v___x_421_);
return v___x_422_;
}
}
static lean_object* _init_l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__1(void){
_start:
{
size_t v___x_423_; lean_object* v___x_424_; lean_object* v___x_425_; lean_object* v___x_426_; lean_object* v___x_427_; lean_object* v___x_428_; 
v___x_423_ = ((size_t)5ULL);
v___x_424_ = lean_unsigned_to_nat(0u);
v___x_425_ = lean_unsigned_to_nat(32u);
v___x_426_ = lean_mk_empty_array_with_capacity(v___x_425_);
v___x_427_ = lean_obj_once(&l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__0, &l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__0_once, _init_l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__0);
v___x_428_ = lean_alloc_ctor(0, 4, sizeof(size_t)*1);
lean_ctor_set(v___x_428_, 0, v___x_427_);
lean_ctor_set(v___x_428_, 1, v___x_426_);
lean_ctor_set(v___x_428_, 2, v___x_424_);
lean_ctor_set(v___x_428_, 3, v___x_424_);
lean_ctor_set_usize(v___x_428_, 4, v___x_423_);
return v___x_428_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg(lean_object* v___y_429_){
_start:
{
lean_object* v___x_431_; lean_object* v_traceState_432_; lean_object* v_traces_433_; lean_object* v___x_434_; lean_object* v_traceState_435_; lean_object* v_env_436_; lean_object* v_nextMacroScope_437_; lean_object* v_ngen_438_; lean_object* v_auxDeclNGen_439_; lean_object* v_cache_440_; lean_object* v_messages_441_; lean_object* v_infoState_442_; lean_object* v_snapshotTasks_443_; lean_object* v___x_445_; uint8_t v_isShared_446_; uint8_t v_isSharedCheck_462_; 
v___x_431_ = lean_st_ref_get(v___y_429_);
v_traceState_432_ = lean_ctor_get(v___x_431_, 4);
lean_inc_ref(v_traceState_432_);
lean_dec(v___x_431_);
v_traces_433_ = lean_ctor_get(v_traceState_432_, 0);
lean_inc_ref(v_traces_433_);
lean_dec_ref(v_traceState_432_);
v___x_434_ = lean_st_ref_take(v___y_429_);
v_traceState_435_ = lean_ctor_get(v___x_434_, 4);
v_env_436_ = lean_ctor_get(v___x_434_, 0);
v_nextMacroScope_437_ = lean_ctor_get(v___x_434_, 1);
v_ngen_438_ = lean_ctor_get(v___x_434_, 2);
v_auxDeclNGen_439_ = lean_ctor_get(v___x_434_, 3);
v_cache_440_ = lean_ctor_get(v___x_434_, 5);
v_messages_441_ = lean_ctor_get(v___x_434_, 6);
v_infoState_442_ = lean_ctor_get(v___x_434_, 7);
v_snapshotTasks_443_ = lean_ctor_get(v___x_434_, 8);
v_isSharedCheck_462_ = !lean_is_exclusive(v___x_434_);
if (v_isSharedCheck_462_ == 0)
{
v___x_445_ = v___x_434_;
v_isShared_446_ = v_isSharedCheck_462_;
goto v_resetjp_444_;
}
else
{
lean_inc(v_snapshotTasks_443_);
lean_inc(v_infoState_442_);
lean_inc(v_messages_441_);
lean_inc(v_cache_440_);
lean_inc(v_traceState_435_);
lean_inc(v_auxDeclNGen_439_);
lean_inc(v_ngen_438_);
lean_inc(v_nextMacroScope_437_);
lean_inc(v_env_436_);
lean_dec(v___x_434_);
v___x_445_ = lean_box(0);
v_isShared_446_ = v_isSharedCheck_462_;
goto v_resetjp_444_;
}
v_resetjp_444_:
{
uint64_t v_tid_447_; lean_object* v___x_449_; uint8_t v_isShared_450_; uint8_t v_isSharedCheck_460_; 
v_tid_447_ = lean_ctor_get_uint64(v_traceState_435_, sizeof(void*)*1);
v_isSharedCheck_460_ = !lean_is_exclusive(v_traceState_435_);
if (v_isSharedCheck_460_ == 0)
{
lean_object* v_unused_461_; 
v_unused_461_ = lean_ctor_get(v_traceState_435_, 0);
lean_dec(v_unused_461_);
v___x_449_ = v_traceState_435_;
v_isShared_450_ = v_isSharedCheck_460_;
goto v_resetjp_448_;
}
else
{
lean_dec(v_traceState_435_);
v___x_449_ = lean_box(0);
v_isShared_450_ = v_isSharedCheck_460_;
goto v_resetjp_448_;
}
v_resetjp_448_:
{
lean_object* v___x_451_; lean_object* v___x_453_; 
v___x_451_ = lean_obj_once(&l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__1, &l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__1_once, _init_l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___closed__1);
if (v_isShared_450_ == 0)
{
lean_ctor_set(v___x_449_, 0, v___x_451_);
v___x_453_ = v___x_449_;
goto v_reusejp_452_;
}
else
{
lean_object* v_reuseFailAlloc_459_; 
v_reuseFailAlloc_459_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_459_, 0, v___x_451_);
lean_ctor_set_uint64(v_reuseFailAlloc_459_, sizeof(void*)*1, v_tid_447_);
v___x_453_ = v_reuseFailAlloc_459_;
goto v_reusejp_452_;
}
v_reusejp_452_:
{
lean_object* v___x_455_; 
if (v_isShared_446_ == 0)
{
lean_ctor_set(v___x_445_, 4, v___x_453_);
v___x_455_ = v___x_445_;
goto v_reusejp_454_;
}
else
{
lean_object* v_reuseFailAlloc_458_; 
v_reuseFailAlloc_458_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_458_, 0, v_env_436_);
lean_ctor_set(v_reuseFailAlloc_458_, 1, v_nextMacroScope_437_);
lean_ctor_set(v_reuseFailAlloc_458_, 2, v_ngen_438_);
lean_ctor_set(v_reuseFailAlloc_458_, 3, v_auxDeclNGen_439_);
lean_ctor_set(v_reuseFailAlloc_458_, 4, v___x_453_);
lean_ctor_set(v_reuseFailAlloc_458_, 5, v_cache_440_);
lean_ctor_set(v_reuseFailAlloc_458_, 6, v_messages_441_);
lean_ctor_set(v_reuseFailAlloc_458_, 7, v_infoState_442_);
lean_ctor_set(v_reuseFailAlloc_458_, 8, v_snapshotTasks_443_);
v___x_455_ = v_reuseFailAlloc_458_;
goto v_reusejp_454_;
}
v_reusejp_454_:
{
lean_object* v___x_456_; lean_object* v___x_457_; 
v___x_456_ = lean_st_ref_set(v___y_429_, v___x_455_);
v___x_457_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_457_, 0, v_traces_433_);
return v___x_457_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg___boxed(lean_object* v___y_463_, lean_object* v___y_464_){
_start:
{
lean_object* v_res_465_; 
v_res_465_ = l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg(v___y_463_);
lean_dec(v___y_463_);
return v_res_465_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7(lean_object* v___y_466_, lean_object* v___y_467_, lean_object* v___y_468_, lean_object* v___y_469_, lean_object* v___y_470_, lean_object* v___y_471_, lean_object* v___y_472_, lean_object* v___y_473_){
_start:
{
lean_object* v___x_475_; 
v___x_475_ = l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg(v___y_473_);
return v___x_475_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___boxed(lean_object* v___y_476_, lean_object* v___y_477_, lean_object* v___y_478_, lean_object* v___y_479_, lean_object* v___y_480_, lean_object* v___y_481_, lean_object* v___y_482_, lean_object* v___y_483_, lean_object* v___y_484_){
_start:
{
lean_object* v_res_485_; 
v_res_485_ = l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7(v___y_476_, v___y_477_, v___y_478_, v___y_479_, v___y_480_, v___y_481_, v___y_482_, v___y_483_);
lean_dec(v___y_483_);
lean_dec_ref(v___y_482_);
lean_dec(v___y_481_);
lean_dec_ref(v___y_480_);
lean_dec(v___y_479_);
lean_dec_ref(v___y_478_);
lean_dec(v___y_477_);
lean_dec_ref(v___y_476_);
return v_res_485_;
}
}
LEAN_EXPORT uint8_t l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__8(lean_object* v_opts_486_, lean_object* v_opt_487_){
_start:
{
lean_object* v_name_488_; lean_object* v_defValue_489_; lean_object* v_map_490_; lean_object* v___x_491_; 
v_name_488_ = lean_ctor_get(v_opt_487_, 0);
v_defValue_489_ = lean_ctor_get(v_opt_487_, 1);
v_map_490_ = lean_ctor_get(v_opts_486_, 0);
v___x_491_ = l_Std_DTreeMap_Internal_Impl_Const_get_x3f___at___00Lean_NameMap_find_x3f_spec__0___redArg(v_map_490_, v_name_488_);
if (lean_obj_tag(v___x_491_) == 0)
{
uint8_t v___x_492_; 
v___x_492_ = lean_unbox(v_defValue_489_);
return v___x_492_;
}
else
{
lean_object* v_val_493_; 
v_val_493_ = lean_ctor_get(v___x_491_, 0);
lean_inc(v_val_493_);
lean_dec_ref_known(v___x_491_, 1);
if (lean_obj_tag(v_val_493_) == 1)
{
uint8_t v_v_494_; 
v_v_494_ = lean_ctor_get_uint8(v_val_493_, 0);
lean_dec_ref_known(v_val_493_, 0);
return v_v_494_;
}
else
{
uint8_t v___x_495_; 
lean_dec(v_val_493_);
v___x_495_ = lean_unbox(v_defValue_489_);
return v___x_495_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__8___boxed(lean_object* v_opts_496_, lean_object* v_opt_497_){
_start:
{
uint8_t v_res_498_; lean_object* v_r_499_; 
v_res_498_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__8(v_opts_496_, v_opt_497_);
lean_dec_ref(v_opt_497_);
lean_dec_ref(v_opts_496_);
v_r_499_ = lean_box(v_res_498_);
return v_r_499_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__2(void){
_start:
{
lean_object* v___x_503_; lean_object* v___x_504_; 
v___x_503_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__1));
v___x_504_ = l_Lean_MessageData_ofFormat(v___x_503_);
return v___x_504_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0(lean_object* v_x_505_, lean_object* v___y_506_, lean_object* v___y_507_, lean_object* v___y_508_, lean_object* v___y_509_, lean_object* v___y_510_, lean_object* v___y_511_, lean_object* v___y_512_, lean_object* v___y_513_){
_start:
{
lean_object* v___x_515_; lean_object* v___x_516_; 
v___x_515_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__2, &l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___closed__2);
v___x_516_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_516_, 0, v___x_515_);
return v___x_516_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0___boxed(lean_object* v_x_517_, lean_object* v___y_518_, lean_object* v___y_519_, lean_object* v___y_520_, lean_object* v___y_521_, lean_object* v___y_522_, lean_object* v___y_523_, lean_object* v___y_524_, lean_object* v___y_525_, lean_object* v___y_526_){
_start:
{
lean_object* v_res_527_; 
v_res_527_ = l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__0(v_x_517_, v___y_518_, v___y_519_, v___y_520_, v___y_521_, v___y_522_, v___y_523_, v___y_524_, v___y_525_);
lean_dec(v___y_525_);
lean_dec_ref(v___y_524_);
lean_dec(v___y_523_);
lean_dec_ref(v___y_522_);
lean_dec(v___y_521_);
lean_dec_ref(v___y_520_);
lean_dec(v___y_519_);
lean_dec_ref(v___y_518_);
lean_dec_ref(v_x_517_);
return v_res_527_;
}
}
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__15(lean_object* v_opts_528_, lean_object* v_opt_529_){
_start:
{
lean_object* v_name_530_; lean_object* v_defValue_531_; lean_object* v_map_532_; lean_object* v___x_533_; 
v_name_530_ = lean_ctor_get(v_opt_529_, 0);
v_defValue_531_ = lean_ctor_get(v_opt_529_, 1);
v_map_532_ = lean_ctor_get(v_opts_528_, 0);
v___x_533_ = l_Std_DTreeMap_Internal_Impl_Const_get_x3f___at___00Lean_NameMap_find_x3f_spec__0___redArg(v_map_532_, v_name_530_);
if (lean_obj_tag(v___x_533_) == 0)
{
lean_inc(v_defValue_531_);
return v_defValue_531_;
}
else
{
lean_object* v_val_534_; 
v_val_534_ = lean_ctor_get(v___x_533_, 0);
lean_inc(v_val_534_);
lean_dec_ref_known(v___x_533_, 1);
if (lean_obj_tag(v_val_534_) == 3)
{
lean_object* v_v_535_; 
v_v_535_ = lean_ctor_get(v_val_534_, 0);
lean_inc(v_v_535_);
lean_dec_ref_known(v_val_534_, 1);
return v_v_535_;
}
else
{
lean_dec(v_val_534_);
lean_inc(v_defValue_531_);
return v_defValue_531_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__15___boxed(lean_object* v_opts_536_, lean_object* v_opt_537_){
_start:
{
lean_object* v_res_538_; 
v_res_538_ = l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__15(v_opts_536_, v_opt_537_);
lean_dec_ref(v_opt_537_);
lean_dec_ref(v_opts_536_);
return v_res_538_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12_spec__17(size_t v_sz_539_, size_t v_i_540_, lean_object* v_bs_541_){
_start:
{
uint8_t v___x_542_; 
v___x_542_ = lean_usize_dec_lt(v_i_540_, v_sz_539_);
if (v___x_542_ == 0)
{
return v_bs_541_;
}
else
{
lean_object* v_v_543_; lean_object* v_msg_544_; lean_object* v___x_545_; lean_object* v_bs_x27_546_; size_t v___x_547_; size_t v___x_548_; lean_object* v___x_549_; 
v_v_543_ = lean_array_uget_borrowed(v_bs_541_, v_i_540_);
v_msg_544_ = lean_ctor_get(v_v_543_, 1);
lean_inc_ref(v_msg_544_);
v___x_545_ = lean_unsigned_to_nat(0u);
v_bs_x27_546_ = lean_array_uset(v_bs_541_, v_i_540_, v___x_545_);
v___x_547_ = ((size_t)1ULL);
v___x_548_ = lean_usize_add(v_i_540_, v___x_547_);
v___x_549_ = lean_array_uset(v_bs_x27_546_, v_i_540_, v_msg_544_);
v_i_540_ = v___x_548_;
v_bs_541_ = v___x_549_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12_spec__17___boxed(lean_object* v_sz_551_, lean_object* v_i_552_, lean_object* v_bs_553_){
_start:
{
size_t v_sz_boxed_554_; size_t v_i_boxed_555_; lean_object* v_res_556_; 
v_sz_boxed_554_ = lean_unbox_usize(v_sz_551_);
lean_dec(v_sz_551_);
v_i_boxed_555_ = lean_unbox_usize(v_i_552_);
lean_dec(v_i_552_);
v_res_556_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12_spec__17(v_sz_boxed_554_, v_i_boxed_555_, v_bs_553_);
return v_res_556_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12___redArg(lean_object* v_oldTraces_557_, lean_object* v_data_558_, lean_object* v_ref_559_, lean_object* v_msg_560_, lean_object* v___y_561_, lean_object* v___y_562_, lean_object* v___y_563_, lean_object* v___y_564_){
_start:
{
lean_object* v_fileName_566_; lean_object* v_fileMap_567_; lean_object* v_options_568_; lean_object* v_currRecDepth_569_; lean_object* v_maxRecDepth_570_; lean_object* v_ref_571_; lean_object* v_currNamespace_572_; lean_object* v_openDecls_573_; lean_object* v_initHeartbeats_574_; lean_object* v_maxHeartbeats_575_; lean_object* v_quotContext_576_; lean_object* v_currMacroScope_577_; uint8_t v_diag_578_; lean_object* v_cancelTk_x3f_579_; uint8_t v_suppressElabErrors_580_; lean_object* v_inheritedTraceOptions_581_; lean_object* v___x_582_; lean_object* v_traceState_583_; lean_object* v_traces_584_; lean_object* v_ref_585_; lean_object* v___x_586_; lean_object* v___x_587_; size_t v_sz_588_; size_t v___x_589_; lean_object* v___x_590_; lean_object* v_msg_591_; lean_object* v___x_592_; lean_object* v_a_593_; lean_object* v___x_595_; uint8_t v_isShared_596_; uint8_t v_isSharedCheck_630_; 
v_fileName_566_ = lean_ctor_get(v___y_563_, 0);
v_fileMap_567_ = lean_ctor_get(v___y_563_, 1);
v_options_568_ = lean_ctor_get(v___y_563_, 2);
v_currRecDepth_569_ = lean_ctor_get(v___y_563_, 3);
v_maxRecDepth_570_ = lean_ctor_get(v___y_563_, 4);
v_ref_571_ = lean_ctor_get(v___y_563_, 5);
v_currNamespace_572_ = lean_ctor_get(v___y_563_, 6);
v_openDecls_573_ = lean_ctor_get(v___y_563_, 7);
v_initHeartbeats_574_ = lean_ctor_get(v___y_563_, 8);
v_maxHeartbeats_575_ = lean_ctor_get(v___y_563_, 9);
v_quotContext_576_ = lean_ctor_get(v___y_563_, 10);
v_currMacroScope_577_ = lean_ctor_get(v___y_563_, 11);
v_diag_578_ = lean_ctor_get_uint8(v___y_563_, sizeof(void*)*14);
v_cancelTk_x3f_579_ = lean_ctor_get(v___y_563_, 12);
v_suppressElabErrors_580_ = lean_ctor_get_uint8(v___y_563_, sizeof(void*)*14 + 1);
v_inheritedTraceOptions_581_ = lean_ctor_get(v___y_563_, 13);
v___x_582_ = lean_st_ref_get(v___y_564_);
v_traceState_583_ = lean_ctor_get(v___x_582_, 4);
lean_inc_ref(v_traceState_583_);
lean_dec(v___x_582_);
v_traces_584_ = lean_ctor_get(v_traceState_583_, 0);
lean_inc_ref(v_traces_584_);
lean_dec_ref(v_traceState_583_);
v_ref_585_ = l_Lean_replaceRef(v_ref_559_, v_ref_571_);
lean_inc_ref(v_inheritedTraceOptions_581_);
lean_inc(v_cancelTk_x3f_579_);
lean_inc(v_currMacroScope_577_);
lean_inc(v_quotContext_576_);
lean_inc(v_maxHeartbeats_575_);
lean_inc(v_initHeartbeats_574_);
lean_inc(v_openDecls_573_);
lean_inc(v_currNamespace_572_);
lean_inc(v_maxRecDepth_570_);
lean_inc(v_currRecDepth_569_);
lean_inc_ref(v_options_568_);
lean_inc_ref(v_fileMap_567_);
lean_inc_ref(v_fileName_566_);
v___x_586_ = lean_alloc_ctor(0, 14, 2);
lean_ctor_set(v___x_586_, 0, v_fileName_566_);
lean_ctor_set(v___x_586_, 1, v_fileMap_567_);
lean_ctor_set(v___x_586_, 2, v_options_568_);
lean_ctor_set(v___x_586_, 3, v_currRecDepth_569_);
lean_ctor_set(v___x_586_, 4, v_maxRecDepth_570_);
lean_ctor_set(v___x_586_, 5, v_ref_585_);
lean_ctor_set(v___x_586_, 6, v_currNamespace_572_);
lean_ctor_set(v___x_586_, 7, v_openDecls_573_);
lean_ctor_set(v___x_586_, 8, v_initHeartbeats_574_);
lean_ctor_set(v___x_586_, 9, v_maxHeartbeats_575_);
lean_ctor_set(v___x_586_, 10, v_quotContext_576_);
lean_ctor_set(v___x_586_, 11, v_currMacroScope_577_);
lean_ctor_set(v___x_586_, 12, v_cancelTk_x3f_579_);
lean_ctor_set(v___x_586_, 13, v_inheritedTraceOptions_581_);
lean_ctor_set_uint8(v___x_586_, sizeof(void*)*14, v_diag_578_);
lean_ctor_set_uint8(v___x_586_, sizeof(void*)*14 + 1, v_suppressElabErrors_580_);
v___x_587_ = l_Lean_PersistentArray_toArray___redArg(v_traces_584_);
lean_dec_ref(v_traces_584_);
v_sz_588_ = lean_array_size(v___x_587_);
v___x_589_ = ((size_t)0ULL);
v___x_590_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12_spec__17(v_sz_588_, v___x_589_, v___x_587_);
v_msg_591_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v_msg_591_, 0, v_data_558_);
lean_ctor_set(v_msg_591_, 1, v_msg_560_);
lean_ctor_set(v_msg_591_, 2, v___x_590_);
v___x_592_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2_spec__2(v_msg_591_, v___y_561_, v___y_562_, v___x_586_, v___y_564_);
lean_dec_ref_known(v___x_586_, 14);
v_a_593_ = lean_ctor_get(v___x_592_, 0);
v_isSharedCheck_630_ = !lean_is_exclusive(v___x_592_);
if (v_isSharedCheck_630_ == 0)
{
v___x_595_ = v___x_592_;
v_isShared_596_ = v_isSharedCheck_630_;
goto v_resetjp_594_;
}
else
{
lean_inc(v_a_593_);
lean_dec(v___x_592_);
v___x_595_ = lean_box(0);
v_isShared_596_ = v_isSharedCheck_630_;
goto v_resetjp_594_;
}
v_resetjp_594_:
{
lean_object* v___x_597_; lean_object* v_traceState_598_; lean_object* v_env_599_; lean_object* v_nextMacroScope_600_; lean_object* v_ngen_601_; lean_object* v_auxDeclNGen_602_; lean_object* v_cache_603_; lean_object* v_messages_604_; lean_object* v_infoState_605_; lean_object* v_snapshotTasks_606_; lean_object* v___x_608_; uint8_t v_isShared_609_; uint8_t v_isSharedCheck_629_; 
v___x_597_ = lean_st_ref_take(v___y_564_);
v_traceState_598_ = lean_ctor_get(v___x_597_, 4);
v_env_599_ = lean_ctor_get(v___x_597_, 0);
v_nextMacroScope_600_ = lean_ctor_get(v___x_597_, 1);
v_ngen_601_ = lean_ctor_get(v___x_597_, 2);
v_auxDeclNGen_602_ = lean_ctor_get(v___x_597_, 3);
v_cache_603_ = lean_ctor_get(v___x_597_, 5);
v_messages_604_ = lean_ctor_get(v___x_597_, 6);
v_infoState_605_ = lean_ctor_get(v___x_597_, 7);
v_snapshotTasks_606_ = lean_ctor_get(v___x_597_, 8);
v_isSharedCheck_629_ = !lean_is_exclusive(v___x_597_);
if (v_isSharedCheck_629_ == 0)
{
v___x_608_ = v___x_597_;
v_isShared_609_ = v_isSharedCheck_629_;
goto v_resetjp_607_;
}
else
{
lean_inc(v_snapshotTasks_606_);
lean_inc(v_infoState_605_);
lean_inc(v_messages_604_);
lean_inc(v_cache_603_);
lean_inc(v_traceState_598_);
lean_inc(v_auxDeclNGen_602_);
lean_inc(v_ngen_601_);
lean_inc(v_nextMacroScope_600_);
lean_inc(v_env_599_);
lean_dec(v___x_597_);
v___x_608_ = lean_box(0);
v_isShared_609_ = v_isSharedCheck_629_;
goto v_resetjp_607_;
}
v_resetjp_607_:
{
uint64_t v_tid_610_; lean_object* v___x_612_; uint8_t v_isShared_613_; uint8_t v_isSharedCheck_627_; 
v_tid_610_ = lean_ctor_get_uint64(v_traceState_598_, sizeof(void*)*1);
v_isSharedCheck_627_ = !lean_is_exclusive(v_traceState_598_);
if (v_isSharedCheck_627_ == 0)
{
lean_object* v_unused_628_; 
v_unused_628_ = lean_ctor_get(v_traceState_598_, 0);
lean_dec(v_unused_628_);
v___x_612_ = v_traceState_598_;
v_isShared_613_ = v_isSharedCheck_627_;
goto v_resetjp_611_;
}
else
{
lean_dec(v_traceState_598_);
v___x_612_ = lean_box(0);
v_isShared_613_ = v_isSharedCheck_627_;
goto v_resetjp_611_;
}
v_resetjp_611_:
{
lean_object* v___x_614_; lean_object* v___x_615_; lean_object* v___x_617_; 
v___x_614_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_614_, 0, v_ref_559_);
lean_ctor_set(v___x_614_, 1, v_a_593_);
v___x_615_ = l_Lean_PersistentArray_push___redArg(v_oldTraces_557_, v___x_614_);
if (v_isShared_613_ == 0)
{
lean_ctor_set(v___x_612_, 0, v___x_615_);
v___x_617_ = v___x_612_;
goto v_reusejp_616_;
}
else
{
lean_object* v_reuseFailAlloc_626_; 
v_reuseFailAlloc_626_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_626_, 0, v___x_615_);
lean_ctor_set_uint64(v_reuseFailAlloc_626_, sizeof(void*)*1, v_tid_610_);
v___x_617_ = v_reuseFailAlloc_626_;
goto v_reusejp_616_;
}
v_reusejp_616_:
{
lean_object* v___x_619_; 
if (v_isShared_609_ == 0)
{
lean_ctor_set(v___x_608_, 4, v___x_617_);
v___x_619_ = v___x_608_;
goto v_reusejp_618_;
}
else
{
lean_object* v_reuseFailAlloc_625_; 
v_reuseFailAlloc_625_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_625_, 0, v_env_599_);
lean_ctor_set(v_reuseFailAlloc_625_, 1, v_nextMacroScope_600_);
lean_ctor_set(v_reuseFailAlloc_625_, 2, v_ngen_601_);
lean_ctor_set(v_reuseFailAlloc_625_, 3, v_auxDeclNGen_602_);
lean_ctor_set(v_reuseFailAlloc_625_, 4, v___x_617_);
lean_ctor_set(v_reuseFailAlloc_625_, 5, v_cache_603_);
lean_ctor_set(v_reuseFailAlloc_625_, 6, v_messages_604_);
lean_ctor_set(v_reuseFailAlloc_625_, 7, v_infoState_605_);
lean_ctor_set(v_reuseFailAlloc_625_, 8, v_snapshotTasks_606_);
v___x_619_ = v_reuseFailAlloc_625_;
goto v_reusejp_618_;
}
v_reusejp_618_:
{
lean_object* v___x_620_; lean_object* v___x_621_; lean_object* v___x_623_; 
v___x_620_ = lean_st_ref_set(v___y_564_, v___x_619_);
v___x_621_ = lean_box(0);
if (v_isShared_596_ == 0)
{
lean_ctor_set(v___x_595_, 0, v___x_621_);
v___x_623_ = v___x_595_;
goto v_reusejp_622_;
}
else
{
lean_object* v_reuseFailAlloc_624_; 
v_reuseFailAlloc_624_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_624_, 0, v___x_621_);
v___x_623_ = v_reuseFailAlloc_624_;
goto v_reusejp_622_;
}
v_reusejp_622_:
{
return v___x_623_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12___redArg___boxed(lean_object* v_oldTraces_631_, lean_object* v_data_632_, lean_object* v_ref_633_, lean_object* v_msg_634_, lean_object* v___y_635_, lean_object* v___y_636_, lean_object* v___y_637_, lean_object* v___y_638_, lean_object* v___y_639_){
_start:
{
lean_object* v_res_640_; 
v_res_640_ = l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12___redArg(v_oldTraces_631_, v_data_632_, v_ref_633_, v_msg_634_, v___y_635_, v___y_636_, v___y_637_, v___y_638_);
lean_dec(v___y_638_);
lean_dec_ref(v___y_637_);
lean_dec(v___y_636_);
lean_dec_ref(v___y_635_);
return v_res_640_;
}
}
LEAN_EXPORT uint8_t l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__14(lean_object* v_e_641_){
_start:
{
if (lean_obj_tag(v_e_641_) == 0)
{
uint8_t v___x_642_; 
v___x_642_ = 2;
return v___x_642_;
}
else
{
uint8_t v___x_643_; 
v___x_643_ = 0;
return v___x_643_;
}
}
}
LEAN_EXPORT lean_object* l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__14___boxed(lean_object* v_e_644_){
_start:
{
uint8_t v_res_645_; lean_object* v_r_646_; 
v_res_645_ = l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__14(v_e_644_);
lean_dec_ref(v_e_644_);
v_r_646_ = lean_box(v_res_645_);
return v_r_646_;
}
}
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___redArg(lean_object* v_x_647_){
_start:
{
if (lean_obj_tag(v_x_647_) == 0)
{
lean_object* v_a_649_; lean_object* v___x_651_; uint8_t v_isShared_652_; uint8_t v_isSharedCheck_656_; 
v_a_649_ = lean_ctor_get(v_x_647_, 0);
v_isSharedCheck_656_ = !lean_is_exclusive(v_x_647_);
if (v_isSharedCheck_656_ == 0)
{
v___x_651_ = v_x_647_;
v_isShared_652_ = v_isSharedCheck_656_;
goto v_resetjp_650_;
}
else
{
lean_inc(v_a_649_);
lean_dec(v_x_647_);
v___x_651_ = lean_box(0);
v_isShared_652_ = v_isSharedCheck_656_;
goto v_resetjp_650_;
}
v_resetjp_650_:
{
lean_object* v___x_654_; 
if (v_isShared_652_ == 0)
{
lean_ctor_set_tag(v___x_651_, 1);
v___x_654_ = v___x_651_;
goto v_reusejp_653_;
}
else
{
lean_object* v_reuseFailAlloc_655_; 
v_reuseFailAlloc_655_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_655_, 0, v_a_649_);
v___x_654_ = v_reuseFailAlloc_655_;
goto v_reusejp_653_;
}
v_reusejp_653_:
{
return v___x_654_;
}
}
}
else
{
lean_object* v_a_657_; lean_object* v___x_659_; uint8_t v_isShared_660_; uint8_t v_isSharedCheck_664_; 
v_a_657_ = lean_ctor_get(v_x_647_, 0);
v_isSharedCheck_664_ = !lean_is_exclusive(v_x_647_);
if (v_isSharedCheck_664_ == 0)
{
v___x_659_ = v_x_647_;
v_isShared_660_ = v_isSharedCheck_664_;
goto v_resetjp_658_;
}
else
{
lean_inc(v_a_657_);
lean_dec(v_x_647_);
v___x_659_ = lean_box(0);
v_isShared_660_ = v_isSharedCheck_664_;
goto v_resetjp_658_;
}
v_resetjp_658_:
{
lean_object* v___x_662_; 
if (v_isShared_660_ == 0)
{
lean_ctor_set_tag(v___x_659_, 0);
v___x_662_ = v___x_659_;
goto v_reusejp_661_;
}
else
{
lean_object* v_reuseFailAlloc_663_; 
v_reuseFailAlloc_663_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_663_, 0, v_a_657_);
v___x_662_ = v_reuseFailAlloc_663_;
goto v_reusejp_661_;
}
v_reusejp_661_:
{
return v___x_662_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___redArg___boxed(lean_object* v_x_665_, lean_object* v___y_666_){
_start:
{
lean_object* v_res_667_; 
v_res_667_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___redArg(v_x_665_);
return v_res_667_;
}
}
static double _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__0(void){
_start:
{
lean_object* v___x_668_; double v___x_669_; 
v___x_668_ = lean_unsigned_to_nat(0u);
v___x_669_ = lean_float_of_nat(v___x_668_);
return v___x_669_;
}
}
static lean_object* _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__2(void){
_start:
{
lean_object* v___x_671_; lean_object* v___x_672_; 
v___x_671_ = ((lean_object*)(l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__1));
v___x_672_ = l_Lean_stringToMessageData(v___x_671_);
return v___x_672_;
}
}
static double _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__3(void){
_start:
{
lean_object* v___x_673_; double v___x_674_; 
v___x_673_ = lean_unsigned_to_nat(1000u);
v___x_674_ = lean_float_of_nat(v___x_673_);
return v___x_674_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9(lean_object* v_cls_675_, uint8_t v_collapsed_676_, lean_object* v_tag_677_, lean_object* v_opts_678_, uint8_t v_clsEnabled_679_, lean_object* v_oldTraces_680_, lean_object* v_msg_681_, lean_object* v_resStartStop_682_, lean_object* v___y_683_, lean_object* v___y_684_, lean_object* v___y_685_, lean_object* v___y_686_, lean_object* v___y_687_, lean_object* v___y_688_, lean_object* v___y_689_, lean_object* v___y_690_){
_start:
{
lean_object* v_fst_692_; lean_object* v_snd_693_; lean_object* v___y_695_; lean_object* v___y_696_; lean_object* v_data_697_; lean_object* v_fst_708_; lean_object* v_snd_709_; lean_object* v___x_710_; uint8_t v___x_711_; lean_object* v___y_713_; lean_object* v_a_714_; uint8_t v___y_729_; double v___y_760_; 
v_fst_692_ = lean_ctor_get(v_resStartStop_682_, 0);
lean_inc(v_fst_692_);
v_snd_693_ = lean_ctor_get(v_resStartStop_682_, 1);
lean_inc(v_snd_693_);
lean_dec_ref(v_resStartStop_682_);
v_fst_708_ = lean_ctor_get(v_snd_693_, 0);
lean_inc(v_fst_708_);
v_snd_709_ = lean_ctor_get(v_snd_693_, 1);
lean_inc(v_snd_709_);
lean_dec(v_snd_693_);
v___x_710_ = l_Lean_trace_profiler;
v___x_711_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__8(v_opts_678_, v___x_710_);
if (v___x_711_ == 0)
{
v___y_729_ = v___x_711_;
goto v___jp_728_;
}
else
{
lean_object* v___x_765_; uint8_t v___x_766_; 
v___x_765_ = l_Lean_trace_profiler_useHeartbeats;
v___x_766_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__8(v_opts_678_, v___x_765_);
if (v___x_766_ == 0)
{
lean_object* v___x_767_; lean_object* v___x_768_; double v___x_769_; double v___x_770_; double v___x_771_; 
v___x_767_ = l_Lean_trace_profiler_threshold;
v___x_768_ = l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__15(v_opts_678_, v___x_767_);
v___x_769_ = lean_float_of_nat(v___x_768_);
v___x_770_ = lean_float_once(&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__3, &l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__3_once, _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__3);
v___x_771_ = lean_float_div(v___x_769_, v___x_770_);
v___y_760_ = v___x_771_;
goto v___jp_759_;
}
else
{
lean_object* v___x_772_; lean_object* v___x_773_; double v___x_774_; 
v___x_772_ = l_Lean_trace_profiler_threshold;
v___x_773_ = l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__15(v_opts_678_, v___x_772_);
v___x_774_ = lean_float_of_nat(v___x_773_);
v___y_760_ = v___x_774_;
goto v___jp_759_;
}
}
v___jp_694_:
{
lean_object* v___x_698_; 
lean_inc(v___y_696_);
v___x_698_ = l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12___redArg(v_oldTraces_680_, v_data_697_, v___y_696_, v___y_695_, v___y_687_, v___y_688_, v___y_689_, v___y_690_);
if (lean_obj_tag(v___x_698_) == 0)
{
lean_object* v___x_699_; 
lean_dec_ref_known(v___x_698_, 1);
v___x_699_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___redArg(v_fst_692_);
return v___x_699_;
}
else
{
lean_object* v_a_700_; lean_object* v___x_702_; uint8_t v_isShared_703_; uint8_t v_isSharedCheck_707_; 
lean_dec(v_fst_692_);
v_a_700_ = lean_ctor_get(v___x_698_, 0);
v_isSharedCheck_707_ = !lean_is_exclusive(v___x_698_);
if (v_isSharedCheck_707_ == 0)
{
v___x_702_ = v___x_698_;
v_isShared_703_ = v_isSharedCheck_707_;
goto v_resetjp_701_;
}
else
{
lean_inc(v_a_700_);
lean_dec(v___x_698_);
v___x_702_ = lean_box(0);
v_isShared_703_ = v_isSharedCheck_707_;
goto v_resetjp_701_;
}
v_resetjp_701_:
{
lean_object* v___x_705_; 
if (v_isShared_703_ == 0)
{
v___x_705_ = v___x_702_;
goto v_reusejp_704_;
}
else
{
lean_object* v_reuseFailAlloc_706_; 
v_reuseFailAlloc_706_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_706_, 0, v_a_700_);
v___x_705_ = v_reuseFailAlloc_706_;
goto v_reusejp_704_;
}
v_reusejp_704_:
{
return v___x_705_;
}
}
}
}
v___jp_712_:
{
uint8_t v_result_715_; lean_object* v___x_716_; lean_object* v___x_717_; double v___x_718_; lean_object* v_data_719_; 
v_result_715_ = l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__14(v_fst_692_);
v___x_716_ = lean_box(v_result_715_);
v___x_717_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_717_, 0, v___x_716_);
v___x_718_ = lean_float_once(&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__0, &l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__0_once, _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__0);
lean_inc_ref(v_tag_677_);
lean_inc_ref(v___x_717_);
lean_inc(v_cls_675_);
v_data_719_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v_data_719_, 0, v_cls_675_);
lean_ctor_set(v_data_719_, 1, v___x_717_);
lean_ctor_set(v_data_719_, 2, v_tag_677_);
lean_ctor_set_float(v_data_719_, sizeof(void*)*3, v___x_718_);
lean_ctor_set_float(v_data_719_, sizeof(void*)*3 + 8, v___x_718_);
lean_ctor_set_uint8(v_data_719_, sizeof(void*)*3 + 16, v_collapsed_676_);
if (v___x_711_ == 0)
{
lean_dec_ref_known(v___x_717_, 1);
lean_dec(v_snd_709_);
lean_dec(v_fst_708_);
lean_dec_ref(v_tag_677_);
lean_dec(v_cls_675_);
v___y_695_ = v_a_714_;
v___y_696_ = v___y_713_;
v_data_697_ = v_data_719_;
goto v___jp_694_;
}
else
{
lean_object* v_data_720_; double v___x_721_; double v___x_722_; 
lean_dec_ref_known(v_data_719_, 3);
v_data_720_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v_data_720_, 0, v_cls_675_);
lean_ctor_set(v_data_720_, 1, v___x_717_);
lean_ctor_set(v_data_720_, 2, v_tag_677_);
v___x_721_ = lean_unbox_float(v_fst_708_);
lean_dec(v_fst_708_);
lean_ctor_set_float(v_data_720_, sizeof(void*)*3, v___x_721_);
v___x_722_ = lean_unbox_float(v_snd_709_);
lean_dec(v_snd_709_);
lean_ctor_set_float(v_data_720_, sizeof(void*)*3 + 8, v___x_722_);
lean_ctor_set_uint8(v_data_720_, sizeof(void*)*3 + 16, v_collapsed_676_);
v___y_695_ = v_a_714_;
v___y_696_ = v___y_713_;
v_data_697_ = v_data_720_;
goto v___jp_694_;
}
}
v___jp_723_:
{
lean_object* v_ref_724_; lean_object* v___x_725_; 
v_ref_724_ = lean_ctor_get(v___y_689_, 5);
lean_inc(v___y_690_);
lean_inc_ref(v___y_689_);
lean_inc(v___y_688_);
lean_inc_ref(v___y_687_);
lean_inc(v___y_686_);
lean_inc_ref(v___y_685_);
lean_inc(v___y_684_);
lean_inc_ref(v___y_683_);
lean_inc(v_fst_692_);
v___x_725_ = lean_apply_10(v_msg_681_, v_fst_692_, v___y_683_, v___y_684_, v___y_685_, v___y_686_, v___y_687_, v___y_688_, v___y_689_, v___y_690_, lean_box(0));
if (lean_obj_tag(v___x_725_) == 0)
{
lean_object* v_a_726_; 
v_a_726_ = lean_ctor_get(v___x_725_, 0);
lean_inc(v_a_726_);
lean_dec_ref_known(v___x_725_, 1);
v___y_713_ = v_ref_724_;
v_a_714_ = v_a_726_;
goto v___jp_712_;
}
else
{
lean_object* v___x_727_; 
lean_dec_ref_known(v___x_725_, 1);
v___x_727_ = lean_obj_once(&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__2, &l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__2_once, _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__2);
v___y_713_ = v_ref_724_;
v_a_714_ = v___x_727_;
goto v___jp_712_;
}
}
v___jp_728_:
{
if (v_clsEnabled_679_ == 0)
{
if (v___y_729_ == 0)
{
lean_object* v___x_730_; lean_object* v_traceState_731_; lean_object* v_env_732_; lean_object* v_nextMacroScope_733_; lean_object* v_ngen_734_; lean_object* v_auxDeclNGen_735_; lean_object* v_cache_736_; lean_object* v_messages_737_; lean_object* v_infoState_738_; lean_object* v_snapshotTasks_739_; lean_object* v___x_741_; uint8_t v_isShared_742_; uint8_t v_isSharedCheck_758_; 
lean_dec(v_snd_709_);
lean_dec(v_fst_708_);
lean_dec_ref(v_msg_681_);
lean_dec_ref(v_tag_677_);
lean_dec(v_cls_675_);
v___x_730_ = lean_st_ref_take(v___y_690_);
v_traceState_731_ = lean_ctor_get(v___x_730_, 4);
v_env_732_ = lean_ctor_get(v___x_730_, 0);
v_nextMacroScope_733_ = lean_ctor_get(v___x_730_, 1);
v_ngen_734_ = lean_ctor_get(v___x_730_, 2);
v_auxDeclNGen_735_ = lean_ctor_get(v___x_730_, 3);
v_cache_736_ = lean_ctor_get(v___x_730_, 5);
v_messages_737_ = lean_ctor_get(v___x_730_, 6);
v_infoState_738_ = lean_ctor_get(v___x_730_, 7);
v_snapshotTasks_739_ = lean_ctor_get(v___x_730_, 8);
v_isSharedCheck_758_ = !lean_is_exclusive(v___x_730_);
if (v_isSharedCheck_758_ == 0)
{
v___x_741_ = v___x_730_;
v_isShared_742_ = v_isSharedCheck_758_;
goto v_resetjp_740_;
}
else
{
lean_inc(v_snapshotTasks_739_);
lean_inc(v_infoState_738_);
lean_inc(v_messages_737_);
lean_inc(v_cache_736_);
lean_inc(v_traceState_731_);
lean_inc(v_auxDeclNGen_735_);
lean_inc(v_ngen_734_);
lean_inc(v_nextMacroScope_733_);
lean_inc(v_env_732_);
lean_dec(v___x_730_);
v___x_741_ = lean_box(0);
v_isShared_742_ = v_isSharedCheck_758_;
goto v_resetjp_740_;
}
v_resetjp_740_:
{
uint64_t v_tid_743_; lean_object* v_traces_744_; lean_object* v___x_746_; uint8_t v_isShared_747_; uint8_t v_isSharedCheck_757_; 
v_tid_743_ = lean_ctor_get_uint64(v_traceState_731_, sizeof(void*)*1);
v_traces_744_ = lean_ctor_get(v_traceState_731_, 0);
v_isSharedCheck_757_ = !lean_is_exclusive(v_traceState_731_);
if (v_isSharedCheck_757_ == 0)
{
v___x_746_ = v_traceState_731_;
v_isShared_747_ = v_isSharedCheck_757_;
goto v_resetjp_745_;
}
else
{
lean_inc(v_traces_744_);
lean_dec(v_traceState_731_);
v___x_746_ = lean_box(0);
v_isShared_747_ = v_isSharedCheck_757_;
goto v_resetjp_745_;
}
v_resetjp_745_:
{
lean_object* v___x_748_; lean_object* v___x_750_; 
v___x_748_ = l_Lean_PersistentArray_append___redArg(v_oldTraces_680_, v_traces_744_);
lean_dec_ref(v_traces_744_);
if (v_isShared_747_ == 0)
{
lean_ctor_set(v___x_746_, 0, v___x_748_);
v___x_750_ = v___x_746_;
goto v_reusejp_749_;
}
else
{
lean_object* v_reuseFailAlloc_756_; 
v_reuseFailAlloc_756_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_756_, 0, v___x_748_);
lean_ctor_set_uint64(v_reuseFailAlloc_756_, sizeof(void*)*1, v_tid_743_);
v___x_750_ = v_reuseFailAlloc_756_;
goto v_reusejp_749_;
}
v_reusejp_749_:
{
lean_object* v___x_752_; 
if (v_isShared_742_ == 0)
{
lean_ctor_set(v___x_741_, 4, v___x_750_);
v___x_752_ = v___x_741_;
goto v_reusejp_751_;
}
else
{
lean_object* v_reuseFailAlloc_755_; 
v_reuseFailAlloc_755_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_755_, 0, v_env_732_);
lean_ctor_set(v_reuseFailAlloc_755_, 1, v_nextMacroScope_733_);
lean_ctor_set(v_reuseFailAlloc_755_, 2, v_ngen_734_);
lean_ctor_set(v_reuseFailAlloc_755_, 3, v_auxDeclNGen_735_);
lean_ctor_set(v_reuseFailAlloc_755_, 4, v___x_750_);
lean_ctor_set(v_reuseFailAlloc_755_, 5, v_cache_736_);
lean_ctor_set(v_reuseFailAlloc_755_, 6, v_messages_737_);
lean_ctor_set(v_reuseFailAlloc_755_, 7, v_infoState_738_);
lean_ctor_set(v_reuseFailAlloc_755_, 8, v_snapshotTasks_739_);
v___x_752_ = v_reuseFailAlloc_755_;
goto v_reusejp_751_;
}
v_reusejp_751_:
{
lean_object* v___x_753_; lean_object* v___x_754_; 
v___x_753_ = lean_st_ref_set(v___y_690_, v___x_752_);
v___x_754_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___redArg(v_fst_692_);
return v___x_754_;
}
}
}
}
}
else
{
goto v___jp_723_;
}
}
else
{
goto v___jp_723_;
}
}
v___jp_759_:
{
double v___x_761_; double v___x_762_; double v___x_763_; uint8_t v___x_764_; 
v___x_761_ = lean_unbox_float(v_snd_709_);
v___x_762_ = lean_unbox_float(v_fst_708_);
v___x_763_ = lean_float_sub(v___x_761_, v___x_762_);
v___x_764_ = lean_float_decLt(v___y_760_, v___x_763_);
v___y_729_ = v___x_764_;
goto v___jp_728_;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___boxed(lean_object** _args){
lean_object* v_cls_775_ = _args[0];
lean_object* v_collapsed_776_ = _args[1];
lean_object* v_tag_777_ = _args[2];
lean_object* v_opts_778_ = _args[3];
lean_object* v_clsEnabled_779_ = _args[4];
lean_object* v_oldTraces_780_ = _args[5];
lean_object* v_msg_781_ = _args[6];
lean_object* v_resStartStop_782_ = _args[7];
lean_object* v___y_783_ = _args[8];
lean_object* v___y_784_ = _args[9];
lean_object* v___y_785_ = _args[10];
lean_object* v___y_786_ = _args[11];
lean_object* v___y_787_ = _args[12];
lean_object* v___y_788_ = _args[13];
lean_object* v___y_789_ = _args[14];
lean_object* v___y_790_ = _args[15];
lean_object* v___y_791_ = _args[16];
_start:
{
uint8_t v_collapsed_boxed_792_; uint8_t v_clsEnabled_boxed_793_; lean_object* v_res_794_; 
v_collapsed_boxed_792_ = lean_unbox(v_collapsed_776_);
v_clsEnabled_boxed_793_ = lean_unbox(v_clsEnabled_779_);
v_res_794_ = l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9(v_cls_775_, v_collapsed_boxed_792_, v_tag_777_, v_opts_778_, v_clsEnabled_boxed_793_, v_oldTraces_780_, v_msg_781_, v_resStartStop_782_, v___y_783_, v___y_784_, v___y_785_, v___y_786_, v___y_787_, v___y_788_, v___y_789_, v___y_790_);
lean_dec(v___y_790_);
lean_dec_ref(v___y_789_);
lean_dec(v___y_788_);
lean_dec_ref(v___y_787_);
lean_dec(v___y_786_);
lean_dec_ref(v___y_785_);
lean_dec(v___y_784_);
lean_dec_ref(v___y_783_);
lean_dec_ref(v_opts_778_);
return v_res_794_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldrM___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__3(lean_object* v_x_795_, lean_object* v_x_796_){
_start:
{
if (lean_obj_tag(v_x_796_) == 0)
{
lean_inc(v_x_795_);
return v_x_795_;
}
else
{
lean_object* v_key_797_; lean_object* v_value_798_; lean_object* v_tail_799_; lean_object* v___x_800_; lean_object* v___x_801_; lean_object* v___x_802_; 
v_key_797_ = lean_ctor_get(v_x_796_, 0);
v_value_798_ = lean_ctor_get(v_x_796_, 1);
v_tail_799_ = lean_ctor_get(v_x_796_, 2);
v___x_800_ = l_Std_DHashMap_Internal_AssocList_foldrM___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__3(v_x_795_, v_tail_799_);
lean_inc(v_value_798_);
lean_inc(v_key_797_);
v___x_801_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_801_, 0, v_key_797_);
lean_ctor_set(v___x_801_, 1, v_value_798_);
v___x_802_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v___x_802_, 0, v___x_801_);
lean_ctor_set(v___x_802_, 1, v___x_800_);
return v___x_802_;
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldrM___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__3___boxed(lean_object* v_x_803_, lean_object* v_x_804_){
_start:
{
lean_object* v_res_805_; 
v_res_805_ = l_Std_DHashMap_Internal_AssocList_foldrM___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__3(v_x_803_, v_x_804_);
lean_dec(v_x_804_);
lean_dec(v_x_803_);
return v_res_805_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__4(lean_object* v_as_806_, size_t v_i_807_, size_t v_stop_808_, lean_object* v_b_809_){
_start:
{
uint8_t v___x_810_; 
v___x_810_ = lean_usize_dec_eq(v_i_807_, v_stop_808_);
if (v___x_810_ == 0)
{
size_t v___x_811_; size_t v___x_812_; lean_object* v___x_813_; lean_object* v___x_814_; 
v___x_811_ = ((size_t)1ULL);
v___x_812_ = lean_usize_sub(v_i_807_, v___x_811_);
v___x_813_ = lean_array_uget_borrowed(v_as_806_, v___x_812_);
v___x_814_ = l_Std_DHashMap_Internal_AssocList_foldrM___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__3(v_b_809_, v___x_813_);
lean_dec(v_b_809_);
v_i_807_ = v___x_812_;
v_b_809_ = v___x_814_;
goto _start;
}
else
{
return v_b_809_;
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__4___boxed(lean_object* v_as_816_, lean_object* v_i_817_, lean_object* v_stop_818_, lean_object* v_b_819_){
_start:
{
size_t v_i_boxed_820_; size_t v_stop_boxed_821_; lean_object* v_res_822_; 
v_i_boxed_820_ = lean_unbox_usize(v_i_817_);
lean_dec(v_i_817_);
v_stop_boxed_821_ = lean_unbox_usize(v_stop_818_);
lean_dec(v_stop_818_);
v_res_822_ = l___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__4(v_as_816_, v_i_boxed_820_, v_stop_boxed_821_, v_b_819_);
lean_dec_ref(v_as_816_);
return v_res_822_;
}
}
LEAN_EXPORT lean_object* l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5(lean_object* v_x_830_){
_start:
{
switch(lean_obj_tag(v_x_830_))
{
case 0:
{
lean_object* v_a_831_; lean_object* v___x_832_; 
v_a_831_ = lean_ctor_get(v_x_830_, 0);
lean_inc(v_a_831_);
lean_dec_ref_known(v_x_830_, 1);
v___x_832_ = l_Std_Tactic_BVDecide_BVPred_toString(v_a_831_);
return v___x_832_;
}
case 1:
{
uint8_t v_a_833_; 
v_a_833_ = lean_ctor_get_uint8(v_x_830_, 0);
lean_dec_ref_known(v_x_830_, 0);
if (v_a_833_ == 0)
{
lean_object* v___x_834_; 
v___x_834_ = ((lean_object*)(l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__0));
return v___x_834_;
}
else
{
lean_object* v___x_835_; 
v___x_835_ = ((lean_object*)(l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__1));
return v___x_835_;
}
}
case 2:
{
lean_object* v_a_836_; lean_object* v___x_837_; lean_object* v___x_838_; lean_object* v___x_839_; 
v_a_836_ = lean_ctor_get(v_x_830_, 0);
lean_inc_ref(v_a_836_);
lean_dec_ref_known(v_x_830_, 1);
v___x_837_ = ((lean_object*)(l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__2));
v___x_838_ = l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5(v_a_836_);
v___x_839_ = lean_string_append(v___x_837_, v___x_838_);
lean_dec_ref(v___x_838_);
return v___x_839_;
}
case 3:
{
uint8_t v_a_840_; lean_object* v_a_841_; lean_object* v_a_842_; lean_object* v___x_843_; lean_object* v___x_844_; lean_object* v___x_845_; lean_object* v___x_846_; lean_object* v___x_847_; lean_object* v___x_848_; lean_object* v___x_849_; lean_object* v___x_850_; lean_object* v___x_851_; lean_object* v___x_852_; lean_object* v___x_853_; lean_object* v___x_854_; 
v_a_840_ = lean_ctor_get_uint8(v_x_830_, sizeof(void*)*2);
v_a_841_ = lean_ctor_get(v_x_830_, 0);
lean_inc_ref(v_a_841_);
v_a_842_ = lean_ctor_get(v_x_830_, 1);
lean_inc_ref(v_a_842_);
lean_dec_ref_known(v_x_830_, 2);
v___x_843_ = ((lean_object*)(l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__3));
v___x_844_ = l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5(v_a_841_);
v___x_845_ = lean_string_append(v___x_843_, v___x_844_);
lean_dec_ref(v___x_844_);
v___x_846_ = ((lean_object*)(l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__4));
v___x_847_ = lean_string_append(v___x_845_, v___x_846_);
v___x_848_ = l_Std_Tactic_BVDecide_Gate_toString(v_a_840_);
v___x_849_ = lean_string_append(v___x_847_, v___x_848_);
lean_dec_ref(v___x_848_);
v___x_850_ = lean_string_append(v___x_849_, v___x_846_);
v___x_851_ = l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5(v_a_842_);
v___x_852_ = lean_string_append(v___x_850_, v___x_851_);
lean_dec_ref(v___x_851_);
v___x_853_ = ((lean_object*)(l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__5));
v___x_854_ = lean_string_append(v___x_852_, v___x_853_);
return v___x_854_;
}
default: 
{
lean_object* v_a_855_; lean_object* v_a_856_; lean_object* v_a_857_; lean_object* v___x_858_; lean_object* v___x_859_; lean_object* v___x_860_; lean_object* v___x_861_; lean_object* v___x_862_; lean_object* v___x_863_; lean_object* v___x_864_; lean_object* v___x_865_; lean_object* v___x_866_; lean_object* v___x_867_; lean_object* v___x_868_; lean_object* v___x_869_; 
v_a_855_ = lean_ctor_get(v_x_830_, 0);
lean_inc_ref(v_a_855_);
v_a_856_ = lean_ctor_get(v_x_830_, 1);
lean_inc_ref(v_a_856_);
v_a_857_ = lean_ctor_get(v_x_830_, 2);
lean_inc_ref(v_a_857_);
lean_dec_ref_known(v_x_830_, 3);
v___x_858_ = ((lean_object*)(l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__6));
v___x_859_ = l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5(v_a_855_);
v___x_860_ = lean_string_append(v___x_858_, v___x_859_);
lean_dec_ref(v___x_859_);
v___x_861_ = ((lean_object*)(l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__4));
v___x_862_ = lean_string_append(v___x_860_, v___x_861_);
v___x_863_ = l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5(v_a_856_);
v___x_864_ = lean_string_append(v___x_862_, v___x_863_);
lean_dec_ref(v___x_863_);
v___x_865_ = lean_string_append(v___x_864_, v___x_861_);
v___x_866_ = l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5(v_a_857_);
v___x_867_ = lean_string_append(v___x_865_, v___x_866_);
lean_dec_ref(v___x_866_);
v___x_868_ = ((lean_object*)(l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5___closed__5));
v___x_869_ = lean_string_append(v___x_867_, v___x_868_);
return v___x_869_;
}
}
}
}
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4___redArg(lean_object* v_a_870_, lean_object* v_x_871_){
_start:
{
if (lean_obj_tag(v_x_871_) == 0)
{
uint8_t v___x_872_; 
v___x_872_ = 0;
return v___x_872_;
}
else
{
lean_object* v_key_873_; lean_object* v_tail_874_; uint8_t v___x_875_; 
v_key_873_ = lean_ctor_get(v_x_871_, 0);
v_tail_874_ = lean_ctor_get(v_x_871_, 2);
v___x_875_ = lean_nat_dec_eq(v_key_873_, v_a_870_);
if (v___x_875_ == 0)
{
v_x_871_ = v_tail_874_;
goto _start;
}
else
{
return v___x_875_;
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4___redArg___boxed(lean_object* v_a_877_, lean_object* v_x_878_){
_start:
{
uint8_t v_res_879_; lean_object* v_r_880_; 
v_res_879_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4___redArg(v_a_877_, v_x_878_);
lean_dec(v_x_878_);
lean_dec(v_a_877_);
v_r_880_ = lean_box(v_res_879_);
return v_r_880_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__6___redArg(lean_object* v_a_881_, lean_object* v_b_882_, lean_object* v_x_883_){
_start:
{
if (lean_obj_tag(v_x_883_) == 0)
{
lean_dec(v_b_882_);
lean_dec(v_a_881_);
return v_x_883_;
}
else
{
lean_object* v_key_884_; lean_object* v_value_885_; lean_object* v_tail_886_; lean_object* v___x_888_; uint8_t v_isShared_889_; uint8_t v_isSharedCheck_898_; 
v_key_884_ = lean_ctor_get(v_x_883_, 0);
v_value_885_ = lean_ctor_get(v_x_883_, 1);
v_tail_886_ = lean_ctor_get(v_x_883_, 2);
v_isSharedCheck_898_ = !lean_is_exclusive(v_x_883_);
if (v_isSharedCheck_898_ == 0)
{
v___x_888_ = v_x_883_;
v_isShared_889_ = v_isSharedCheck_898_;
goto v_resetjp_887_;
}
else
{
lean_inc(v_tail_886_);
lean_inc(v_value_885_);
lean_inc(v_key_884_);
lean_dec(v_x_883_);
v___x_888_ = lean_box(0);
v_isShared_889_ = v_isSharedCheck_898_;
goto v_resetjp_887_;
}
v_resetjp_887_:
{
uint8_t v___x_890_; 
v___x_890_ = lean_nat_dec_eq(v_key_884_, v_a_881_);
if (v___x_890_ == 0)
{
lean_object* v___x_891_; lean_object* v___x_893_; 
v___x_891_ = l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__6___redArg(v_a_881_, v_b_882_, v_tail_886_);
if (v_isShared_889_ == 0)
{
lean_ctor_set(v___x_888_, 2, v___x_891_);
v___x_893_ = v___x_888_;
goto v_reusejp_892_;
}
else
{
lean_object* v_reuseFailAlloc_894_; 
v_reuseFailAlloc_894_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v_reuseFailAlloc_894_, 0, v_key_884_);
lean_ctor_set(v_reuseFailAlloc_894_, 1, v_value_885_);
lean_ctor_set(v_reuseFailAlloc_894_, 2, v___x_891_);
v___x_893_ = v_reuseFailAlloc_894_;
goto v_reusejp_892_;
}
v_reusejp_892_:
{
return v___x_893_;
}
}
else
{
lean_object* v___x_896_; 
lean_dec(v_value_885_);
lean_dec(v_key_884_);
if (v_isShared_889_ == 0)
{
lean_ctor_set(v___x_888_, 1, v_b_882_);
lean_ctor_set(v___x_888_, 0, v_a_881_);
v___x_896_ = v___x_888_;
goto v_reusejp_895_;
}
else
{
lean_object* v_reuseFailAlloc_897_; 
v_reuseFailAlloc_897_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v_reuseFailAlloc_897_, 0, v_a_881_);
lean_ctor_set(v_reuseFailAlloc_897_, 1, v_b_882_);
lean_ctor_set(v_reuseFailAlloc_897_, 2, v_tail_886_);
v___x_896_ = v_reuseFailAlloc_897_;
goto v_reusejp_895_;
}
v_reusejp_895_:
{
return v___x_896_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15_spec__19___redArg(lean_object* v_x_899_, lean_object* v_x_900_){
_start:
{
if (lean_obj_tag(v_x_900_) == 0)
{
return v_x_899_;
}
else
{
lean_object* v_key_901_; lean_object* v_value_902_; lean_object* v_tail_903_; lean_object* v___x_905_; uint8_t v_isShared_906_; uint8_t v_isSharedCheck_926_; 
v_key_901_ = lean_ctor_get(v_x_900_, 0);
v_value_902_ = lean_ctor_get(v_x_900_, 1);
v_tail_903_ = lean_ctor_get(v_x_900_, 2);
v_isSharedCheck_926_ = !lean_is_exclusive(v_x_900_);
if (v_isSharedCheck_926_ == 0)
{
v___x_905_ = v_x_900_;
v_isShared_906_ = v_isSharedCheck_926_;
goto v_resetjp_904_;
}
else
{
lean_inc(v_tail_903_);
lean_inc(v_value_902_);
lean_inc(v_key_901_);
lean_dec(v_x_900_);
v___x_905_ = lean_box(0);
v_isShared_906_ = v_isSharedCheck_926_;
goto v_resetjp_904_;
}
v_resetjp_904_:
{
lean_object* v___x_907_; uint64_t v___x_908_; uint64_t v___x_909_; uint64_t v___x_910_; uint64_t v_fold_911_; uint64_t v___x_912_; uint64_t v___x_913_; uint64_t v___x_914_; size_t v___x_915_; size_t v___x_916_; size_t v___x_917_; size_t v___x_918_; size_t v___x_919_; lean_object* v___x_920_; lean_object* v___x_922_; 
v___x_907_ = lean_array_get_size(v_x_899_);
v___x_908_ = lean_uint64_of_nat(v_key_901_);
v___x_909_ = 32ULL;
v___x_910_ = lean_uint64_shift_right(v___x_908_, v___x_909_);
v_fold_911_ = lean_uint64_xor(v___x_908_, v___x_910_);
v___x_912_ = 16ULL;
v___x_913_ = lean_uint64_shift_right(v_fold_911_, v___x_912_);
v___x_914_ = lean_uint64_xor(v_fold_911_, v___x_913_);
v___x_915_ = lean_uint64_to_usize(v___x_914_);
v___x_916_ = lean_usize_of_nat(v___x_907_);
v___x_917_ = ((size_t)1ULL);
v___x_918_ = lean_usize_sub(v___x_916_, v___x_917_);
v___x_919_ = lean_usize_land(v___x_915_, v___x_918_);
v___x_920_ = lean_array_uget_borrowed(v_x_899_, v___x_919_);
lean_inc(v___x_920_);
if (v_isShared_906_ == 0)
{
lean_ctor_set(v___x_905_, 2, v___x_920_);
v___x_922_ = v___x_905_;
goto v_reusejp_921_;
}
else
{
lean_object* v_reuseFailAlloc_925_; 
v_reuseFailAlloc_925_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v_reuseFailAlloc_925_, 0, v_key_901_);
lean_ctor_set(v_reuseFailAlloc_925_, 1, v_value_902_);
lean_ctor_set(v_reuseFailAlloc_925_, 2, v___x_920_);
v___x_922_ = v_reuseFailAlloc_925_;
goto v_reusejp_921_;
}
v_reusejp_921_:
{
lean_object* v___x_923_; 
v___x_923_ = lean_array_uset(v_x_899_, v___x_919_, v___x_922_);
v_x_899_ = v___x_923_;
v_x_900_ = v_tail_903_;
goto _start;
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15___redArg(lean_object* v_i_927_, lean_object* v_source_928_, lean_object* v_target_929_){
_start:
{
lean_object* v___x_930_; uint8_t v___x_931_; 
v___x_930_ = lean_array_get_size(v_source_928_);
v___x_931_ = lean_nat_dec_lt(v_i_927_, v___x_930_);
if (v___x_931_ == 0)
{
lean_dec_ref(v_source_928_);
lean_dec(v_i_927_);
return v_target_929_;
}
else
{
lean_object* v_es_932_; lean_object* v___x_933_; lean_object* v_source_934_; lean_object* v_target_935_; lean_object* v___x_936_; lean_object* v___x_937_; 
v_es_932_ = lean_array_fget(v_source_928_, v_i_927_);
v___x_933_ = lean_box(0);
v_source_934_ = lean_array_fset(v_source_928_, v_i_927_, v___x_933_);
v_target_935_ = l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15_spec__19___redArg(v_target_929_, v_es_932_);
v___x_936_ = lean_unsigned_to_nat(1u);
v___x_937_ = lean_nat_add(v_i_927_, v___x_936_);
lean_dec(v_i_927_);
v_i_927_ = v___x_937_;
v_source_928_ = v_source_934_;
v_target_929_ = v_target_935_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5___redArg(lean_object* v_data_939_){
_start:
{
lean_object* v___x_940_; lean_object* v___x_941_; lean_object* v_nbuckets_942_; lean_object* v___x_943_; lean_object* v___x_944_; lean_object* v___x_945_; lean_object* v___x_946_; 
v___x_940_ = lean_array_get_size(v_data_939_);
v___x_941_ = lean_unsigned_to_nat(2u);
v_nbuckets_942_ = lean_nat_mul(v___x_940_, v___x_941_);
v___x_943_ = lean_unsigned_to_nat(0u);
v___x_944_ = lean_box(0);
v___x_945_ = lean_mk_array(v_nbuckets_942_, v___x_944_);
v___x_946_ = l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15___redArg(v___x_943_, v_data_939_, v___x_945_);
return v___x_946_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1___redArg(lean_object* v_m_947_, lean_object* v_a_948_, lean_object* v_b_949_){
_start:
{
lean_object* v_size_950_; lean_object* v_buckets_951_; lean_object* v___x_953_; uint8_t v_isShared_954_; uint8_t v_isSharedCheck_994_; 
v_size_950_ = lean_ctor_get(v_m_947_, 0);
v_buckets_951_ = lean_ctor_get(v_m_947_, 1);
v_isSharedCheck_994_ = !lean_is_exclusive(v_m_947_);
if (v_isSharedCheck_994_ == 0)
{
v___x_953_ = v_m_947_;
v_isShared_954_ = v_isSharedCheck_994_;
goto v_resetjp_952_;
}
else
{
lean_inc(v_buckets_951_);
lean_inc(v_size_950_);
lean_dec(v_m_947_);
v___x_953_ = lean_box(0);
v_isShared_954_ = v_isSharedCheck_994_;
goto v_resetjp_952_;
}
v_resetjp_952_:
{
lean_object* v___x_955_; uint64_t v___x_956_; uint64_t v___x_957_; uint64_t v___x_958_; uint64_t v_fold_959_; uint64_t v___x_960_; uint64_t v___x_961_; uint64_t v___x_962_; size_t v___x_963_; size_t v___x_964_; size_t v___x_965_; size_t v___x_966_; size_t v___x_967_; lean_object* v_bkt_968_; uint8_t v___x_969_; 
v___x_955_ = lean_array_get_size(v_buckets_951_);
v___x_956_ = lean_uint64_of_nat(v_a_948_);
v___x_957_ = 32ULL;
v___x_958_ = lean_uint64_shift_right(v___x_956_, v___x_957_);
v_fold_959_ = lean_uint64_xor(v___x_956_, v___x_958_);
v___x_960_ = 16ULL;
v___x_961_ = lean_uint64_shift_right(v_fold_959_, v___x_960_);
v___x_962_ = lean_uint64_xor(v_fold_959_, v___x_961_);
v___x_963_ = lean_uint64_to_usize(v___x_962_);
v___x_964_ = lean_usize_of_nat(v___x_955_);
v___x_965_ = ((size_t)1ULL);
v___x_966_ = lean_usize_sub(v___x_964_, v___x_965_);
v___x_967_ = lean_usize_land(v___x_963_, v___x_966_);
v_bkt_968_ = lean_array_uget_borrowed(v_buckets_951_, v___x_967_);
v___x_969_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4___redArg(v_a_948_, v_bkt_968_);
if (v___x_969_ == 0)
{
lean_object* v___x_970_; lean_object* v_size_x27_971_; lean_object* v___x_972_; lean_object* v_buckets_x27_973_; lean_object* v___x_974_; lean_object* v___x_975_; lean_object* v___x_976_; lean_object* v___x_977_; lean_object* v___x_978_; uint8_t v___x_979_; 
v___x_970_ = lean_unsigned_to_nat(1u);
v_size_x27_971_ = lean_nat_add(v_size_950_, v___x_970_);
lean_dec(v_size_950_);
lean_inc(v_bkt_968_);
v___x_972_ = lean_alloc_ctor(1, 3, 0);
lean_ctor_set(v___x_972_, 0, v_a_948_);
lean_ctor_set(v___x_972_, 1, v_b_949_);
lean_ctor_set(v___x_972_, 2, v_bkt_968_);
v_buckets_x27_973_ = lean_array_uset(v_buckets_951_, v___x_967_, v___x_972_);
v___x_974_ = lean_unsigned_to_nat(4u);
v___x_975_ = lean_nat_mul(v_size_x27_971_, v___x_974_);
v___x_976_ = lean_unsigned_to_nat(3u);
v___x_977_ = lean_nat_div(v___x_975_, v___x_976_);
lean_dec(v___x_975_);
v___x_978_ = lean_array_get_size(v_buckets_x27_973_);
v___x_979_ = lean_nat_dec_le(v___x_977_, v___x_978_);
lean_dec(v___x_977_);
if (v___x_979_ == 0)
{
lean_object* v_val_980_; lean_object* v___x_982_; 
v_val_980_ = l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5___redArg(v_buckets_x27_973_);
if (v_isShared_954_ == 0)
{
lean_ctor_set(v___x_953_, 1, v_val_980_);
lean_ctor_set(v___x_953_, 0, v_size_x27_971_);
v___x_982_ = v___x_953_;
goto v_reusejp_981_;
}
else
{
lean_object* v_reuseFailAlloc_983_; 
v_reuseFailAlloc_983_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_983_, 0, v_size_x27_971_);
lean_ctor_set(v_reuseFailAlloc_983_, 1, v_val_980_);
v___x_982_ = v_reuseFailAlloc_983_;
goto v_reusejp_981_;
}
v_reusejp_981_:
{
return v___x_982_;
}
}
else
{
lean_object* v___x_985_; 
if (v_isShared_954_ == 0)
{
lean_ctor_set(v___x_953_, 1, v_buckets_x27_973_);
lean_ctor_set(v___x_953_, 0, v_size_x27_971_);
v___x_985_ = v___x_953_;
goto v_reusejp_984_;
}
else
{
lean_object* v_reuseFailAlloc_986_; 
v_reuseFailAlloc_986_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_986_, 0, v_size_x27_971_);
lean_ctor_set(v_reuseFailAlloc_986_, 1, v_buckets_x27_973_);
v___x_985_ = v_reuseFailAlloc_986_;
goto v_reusejp_984_;
}
v_reusejp_984_:
{
return v___x_985_;
}
}
}
else
{
lean_object* v___x_987_; lean_object* v_buckets_x27_988_; lean_object* v___x_989_; lean_object* v___x_990_; lean_object* v___x_992_; 
lean_inc(v_bkt_968_);
v___x_987_ = lean_box(0);
v_buckets_x27_988_ = lean_array_uset(v_buckets_951_, v___x_967_, v___x_987_);
v___x_989_ = l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__6___redArg(v_a_948_, v_b_949_, v_bkt_968_);
v___x_990_ = lean_array_uset(v_buckets_x27_988_, v___x_967_, v___x_989_);
if (v_isShared_954_ == 0)
{
lean_ctor_set(v___x_953_, 1, v___x_990_);
v___x_992_ = v___x_953_;
goto v_reusejp_991_;
}
else
{
lean_object* v_reuseFailAlloc_993_; 
v_reuseFailAlloc_993_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_993_, 0, v_size_950_);
lean_ctor_set(v_reuseFailAlloc_993_, 1, v___x_990_);
v___x_992_ = v_reuseFailAlloc_993_;
goto v_reusejp_991_;
}
v_reusejp_991_:
{
return v___x_992_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___redArg(lean_object* v_as_x27_995_, lean_object* v_b_996_){
_start:
{
if (lean_obj_tag(v_as_x27_995_) == 0)
{
return v_b_996_;
}
else
{
lean_object* v_head_997_; lean_object* v_tail_998_; lean_object* v_fst_999_; lean_object* v_snd_1000_; lean_object* v_r_1001_; 
v_head_997_ = lean_ctor_get(v_as_x27_995_, 0);
v_tail_998_ = lean_ctor_get(v_as_x27_995_, 1);
v_fst_999_ = lean_ctor_get(v_head_997_, 0);
v_snd_1000_ = lean_ctor_get(v_head_997_, 1);
lean_inc(v_snd_1000_);
lean_inc(v_fst_999_);
v_r_1001_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1___redArg(v_b_996_, v_fst_999_, v_snd_1000_);
v_as_x27_995_ = v_tail_998_;
v_b_996_ = v_r_1001_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___redArg___boxed(lean_object* v_as_x27_1003_, lean_object* v_b_1004_){
_start:
{
lean_object* v_res_1005_; 
v_res_1005_ = l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___redArg(v_as_x27_1003_, v_b_1004_);
lean_dec(v_as_x27_1003_);
return v_res_1005_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1(lean_object* v_m_1006_, lean_object* v_l_1007_){
_start:
{
lean_object* v___x_1008_; 
v___x_1008_ = l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___redArg(v_l_1007_, v_m_1006_);
return v___x_1008_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1___boxed(lean_object* v_m_1009_, lean_object* v_l_1010_){
_start:
{
lean_object* v_res_1011_; 
v_res_1011_ = l_Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1(v_m_1009_, v_l_1010_);
lean_dec(v_l_1010_);
return v_res_1011_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20_spec__23___redArg(lean_object* v_x_1012_, lean_object* v_x_1013_, lean_object* v_x_1014_, lean_object* v_x_1015_){
_start:
{
lean_object* v_ks_1016_; lean_object* v_vs_1017_; lean_object* v___x_1019_; uint8_t v_isShared_1020_; uint8_t v_isSharedCheck_1041_; 
v_ks_1016_ = lean_ctor_get(v_x_1012_, 0);
v_vs_1017_ = lean_ctor_get(v_x_1012_, 1);
v_isSharedCheck_1041_ = !lean_is_exclusive(v_x_1012_);
if (v_isSharedCheck_1041_ == 0)
{
v___x_1019_ = v_x_1012_;
v_isShared_1020_ = v_isSharedCheck_1041_;
goto v_resetjp_1018_;
}
else
{
lean_inc(v_vs_1017_);
lean_inc(v_ks_1016_);
lean_dec(v_x_1012_);
v___x_1019_ = lean_box(0);
v_isShared_1020_ = v_isSharedCheck_1041_;
goto v_resetjp_1018_;
}
v_resetjp_1018_:
{
lean_object* v___x_1021_; uint8_t v___x_1022_; 
v___x_1021_ = lean_array_get_size(v_ks_1016_);
v___x_1022_ = lean_nat_dec_lt(v_x_1013_, v___x_1021_);
if (v___x_1022_ == 0)
{
lean_object* v___x_1023_; lean_object* v___x_1024_; lean_object* v___x_1026_; 
lean_dec(v_x_1013_);
v___x_1023_ = lean_array_push(v_ks_1016_, v_x_1014_);
v___x_1024_ = lean_array_push(v_vs_1017_, v_x_1015_);
if (v_isShared_1020_ == 0)
{
lean_ctor_set(v___x_1019_, 1, v___x_1024_);
lean_ctor_set(v___x_1019_, 0, v___x_1023_);
v___x_1026_ = v___x_1019_;
goto v_reusejp_1025_;
}
else
{
lean_object* v_reuseFailAlloc_1027_; 
v_reuseFailAlloc_1027_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1027_, 0, v___x_1023_);
lean_ctor_set(v_reuseFailAlloc_1027_, 1, v___x_1024_);
v___x_1026_ = v_reuseFailAlloc_1027_;
goto v_reusejp_1025_;
}
v_reusejp_1025_:
{
return v___x_1026_;
}
}
else
{
lean_object* v_k_x27_1028_; uint8_t v___x_1029_; 
v_k_x27_1028_ = lean_array_fget_borrowed(v_ks_1016_, v_x_1013_);
v___x_1029_ = l_Lean_instBEqMVarId_beq(v_x_1014_, v_k_x27_1028_);
if (v___x_1029_ == 0)
{
lean_object* v___x_1031_; 
if (v_isShared_1020_ == 0)
{
v___x_1031_ = v___x_1019_;
goto v_reusejp_1030_;
}
else
{
lean_object* v_reuseFailAlloc_1035_; 
v_reuseFailAlloc_1035_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1035_, 0, v_ks_1016_);
lean_ctor_set(v_reuseFailAlloc_1035_, 1, v_vs_1017_);
v___x_1031_ = v_reuseFailAlloc_1035_;
goto v_reusejp_1030_;
}
v_reusejp_1030_:
{
lean_object* v___x_1032_; lean_object* v___x_1033_; 
v___x_1032_ = lean_unsigned_to_nat(1u);
v___x_1033_ = lean_nat_add(v_x_1013_, v___x_1032_);
lean_dec(v_x_1013_);
v_x_1012_ = v___x_1031_;
v_x_1013_ = v___x_1033_;
goto _start;
}
}
else
{
lean_object* v___x_1036_; lean_object* v___x_1037_; lean_object* v___x_1039_; 
v___x_1036_ = lean_array_fset(v_ks_1016_, v_x_1013_, v_x_1014_);
v___x_1037_ = lean_array_fset(v_vs_1017_, v_x_1013_, v_x_1015_);
lean_dec(v_x_1013_);
if (v_isShared_1020_ == 0)
{
lean_ctor_set(v___x_1019_, 1, v___x_1037_);
lean_ctor_set(v___x_1019_, 0, v___x_1036_);
v___x_1039_ = v___x_1019_;
goto v_reusejp_1038_;
}
else
{
lean_object* v_reuseFailAlloc_1040_; 
v_reuseFailAlloc_1040_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1040_, 0, v___x_1036_);
lean_ctor_set(v_reuseFailAlloc_1040_, 1, v___x_1037_);
v___x_1039_ = v_reuseFailAlloc_1040_;
goto v_reusejp_1038_;
}
v_reusejp_1038_:
{
return v___x_1039_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20___redArg(lean_object* v_n_1042_, lean_object* v_k_1043_, lean_object* v_v_1044_){
_start:
{
lean_object* v___x_1045_; lean_object* v___x_1046_; 
v___x_1045_ = lean_unsigned_to_nat(0u);
v___x_1046_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20_spec__23___redArg(v_n_1042_, v___x_1045_, v_k_1043_, v_v_1044_);
return v___x_1046_;
}
}
static lean_object* _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg___closed__0(void){
_start:
{
lean_object* v___x_1047_; 
v___x_1047_ = l_Lean_PersistentHashMap_mkEmptyEntries(lean_box(0), lean_box(0));
return v___x_1047_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg(lean_object* v_x_1048_, size_t v_x_1049_, size_t v_x_1050_, lean_object* v_x_1051_, lean_object* v_x_1052_){
_start:
{
if (lean_obj_tag(v_x_1048_) == 0)
{
lean_object* v_es_1053_; size_t v___x_1054_; size_t v___x_1055_; lean_object* v_j_1056_; lean_object* v___x_1057_; uint8_t v___x_1058_; 
v_es_1053_ = lean_ctor_get(v_x_1048_, 0);
v___x_1054_ = ((size_t)31ULL);
v___x_1055_ = lean_usize_land(v_x_1049_, v___x_1054_);
v_j_1056_ = lean_usize_to_nat(v___x_1055_);
v___x_1057_ = lean_array_get_size(v_es_1053_);
v___x_1058_ = lean_nat_dec_lt(v_j_1056_, v___x_1057_);
if (v___x_1058_ == 0)
{
lean_dec(v_j_1056_);
lean_dec(v_x_1052_);
lean_dec(v_x_1051_);
return v_x_1048_;
}
else
{
lean_object* v___x_1060_; uint8_t v_isShared_1061_; uint8_t v_isSharedCheck_1097_; 
lean_inc_ref(v_es_1053_);
v_isSharedCheck_1097_ = !lean_is_exclusive(v_x_1048_);
if (v_isSharedCheck_1097_ == 0)
{
lean_object* v_unused_1098_; 
v_unused_1098_ = lean_ctor_get(v_x_1048_, 0);
lean_dec(v_unused_1098_);
v___x_1060_ = v_x_1048_;
v_isShared_1061_ = v_isSharedCheck_1097_;
goto v_resetjp_1059_;
}
else
{
lean_dec(v_x_1048_);
v___x_1060_ = lean_box(0);
v_isShared_1061_ = v_isSharedCheck_1097_;
goto v_resetjp_1059_;
}
v_resetjp_1059_:
{
lean_object* v_v_1062_; lean_object* v___x_1063_; lean_object* v_xs_x27_1064_; lean_object* v___y_1066_; 
v_v_1062_ = lean_array_fget(v_es_1053_, v_j_1056_);
v___x_1063_ = lean_box(0);
v_xs_x27_1064_ = lean_array_fset(v_es_1053_, v_j_1056_, v___x_1063_);
switch(lean_obj_tag(v_v_1062_))
{
case 0:
{
lean_object* v_key_1071_; lean_object* v_val_1072_; lean_object* v___x_1074_; uint8_t v_isShared_1075_; uint8_t v_isSharedCheck_1082_; 
v_key_1071_ = lean_ctor_get(v_v_1062_, 0);
v_val_1072_ = lean_ctor_get(v_v_1062_, 1);
v_isSharedCheck_1082_ = !lean_is_exclusive(v_v_1062_);
if (v_isSharedCheck_1082_ == 0)
{
v___x_1074_ = v_v_1062_;
v_isShared_1075_ = v_isSharedCheck_1082_;
goto v_resetjp_1073_;
}
else
{
lean_inc(v_val_1072_);
lean_inc(v_key_1071_);
lean_dec(v_v_1062_);
v___x_1074_ = lean_box(0);
v_isShared_1075_ = v_isSharedCheck_1082_;
goto v_resetjp_1073_;
}
v_resetjp_1073_:
{
uint8_t v___x_1076_; 
v___x_1076_ = l_Lean_instBEqMVarId_beq(v_x_1051_, v_key_1071_);
if (v___x_1076_ == 0)
{
lean_object* v___x_1077_; lean_object* v___x_1078_; 
lean_del_object(v___x_1074_);
v___x_1077_ = l_Lean_PersistentHashMap_mkCollisionNode___redArg(v_key_1071_, v_val_1072_, v_x_1051_, v_x_1052_);
v___x_1078_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_1078_, 0, v___x_1077_);
v___y_1066_ = v___x_1078_;
goto v___jp_1065_;
}
else
{
lean_object* v___x_1080_; 
lean_dec(v_val_1072_);
lean_dec(v_key_1071_);
if (v_isShared_1075_ == 0)
{
lean_ctor_set(v___x_1074_, 1, v_x_1052_);
lean_ctor_set(v___x_1074_, 0, v_x_1051_);
v___x_1080_ = v___x_1074_;
goto v_reusejp_1079_;
}
else
{
lean_object* v_reuseFailAlloc_1081_; 
v_reuseFailAlloc_1081_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1081_, 0, v_x_1051_);
lean_ctor_set(v_reuseFailAlloc_1081_, 1, v_x_1052_);
v___x_1080_ = v_reuseFailAlloc_1081_;
goto v_reusejp_1079_;
}
v_reusejp_1079_:
{
v___y_1066_ = v___x_1080_;
goto v___jp_1065_;
}
}
}
}
case 1:
{
lean_object* v_node_1083_; lean_object* v___x_1085_; uint8_t v_isShared_1086_; uint8_t v_isSharedCheck_1095_; 
v_node_1083_ = lean_ctor_get(v_v_1062_, 0);
v_isSharedCheck_1095_ = !lean_is_exclusive(v_v_1062_);
if (v_isSharedCheck_1095_ == 0)
{
v___x_1085_ = v_v_1062_;
v_isShared_1086_ = v_isSharedCheck_1095_;
goto v_resetjp_1084_;
}
else
{
lean_inc(v_node_1083_);
lean_dec(v_v_1062_);
v___x_1085_ = lean_box(0);
v_isShared_1086_ = v_isSharedCheck_1095_;
goto v_resetjp_1084_;
}
v_resetjp_1084_:
{
size_t v___x_1087_; size_t v___x_1088_; size_t v___x_1089_; size_t v___x_1090_; lean_object* v___x_1091_; lean_object* v___x_1093_; 
v___x_1087_ = ((size_t)5ULL);
v___x_1088_ = lean_usize_shift_right(v_x_1049_, v___x_1087_);
v___x_1089_ = ((size_t)1ULL);
v___x_1090_ = lean_usize_add(v_x_1050_, v___x_1089_);
v___x_1091_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg(v_node_1083_, v___x_1088_, v___x_1090_, v_x_1051_, v_x_1052_);
if (v_isShared_1086_ == 0)
{
lean_ctor_set(v___x_1085_, 0, v___x_1091_);
v___x_1093_ = v___x_1085_;
goto v_reusejp_1092_;
}
else
{
lean_object* v_reuseFailAlloc_1094_; 
v_reuseFailAlloc_1094_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1094_, 0, v___x_1091_);
v___x_1093_ = v_reuseFailAlloc_1094_;
goto v_reusejp_1092_;
}
v_reusejp_1092_:
{
v___y_1066_ = v___x_1093_;
goto v___jp_1065_;
}
}
}
default: 
{
lean_object* v___x_1096_; 
v___x_1096_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1096_, 0, v_x_1051_);
lean_ctor_set(v___x_1096_, 1, v_x_1052_);
v___y_1066_ = v___x_1096_;
goto v___jp_1065_;
}
}
v___jp_1065_:
{
lean_object* v___x_1067_; lean_object* v___x_1069_; 
v___x_1067_ = lean_array_fset(v_xs_x27_1064_, v_j_1056_, v___y_1066_);
lean_dec(v_j_1056_);
if (v_isShared_1061_ == 0)
{
lean_ctor_set(v___x_1060_, 0, v___x_1067_);
v___x_1069_ = v___x_1060_;
goto v_reusejp_1068_;
}
else
{
lean_object* v_reuseFailAlloc_1070_; 
v_reuseFailAlloc_1070_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1070_, 0, v___x_1067_);
v___x_1069_ = v_reuseFailAlloc_1070_;
goto v_reusejp_1068_;
}
v_reusejp_1068_:
{
return v___x_1069_;
}
}
}
}
}
else
{
lean_object* v_ks_1099_; lean_object* v_vs_1100_; lean_object* v___x_1102_; uint8_t v_isShared_1103_; uint8_t v_isSharedCheck_1120_; 
v_ks_1099_ = lean_ctor_get(v_x_1048_, 0);
v_vs_1100_ = lean_ctor_get(v_x_1048_, 1);
v_isSharedCheck_1120_ = !lean_is_exclusive(v_x_1048_);
if (v_isSharedCheck_1120_ == 0)
{
v___x_1102_ = v_x_1048_;
v_isShared_1103_ = v_isSharedCheck_1120_;
goto v_resetjp_1101_;
}
else
{
lean_inc(v_vs_1100_);
lean_inc(v_ks_1099_);
lean_dec(v_x_1048_);
v___x_1102_ = lean_box(0);
v_isShared_1103_ = v_isSharedCheck_1120_;
goto v_resetjp_1101_;
}
v_resetjp_1101_:
{
lean_object* v___x_1105_; 
if (v_isShared_1103_ == 0)
{
v___x_1105_ = v___x_1102_;
goto v_reusejp_1104_;
}
else
{
lean_object* v_reuseFailAlloc_1119_; 
v_reuseFailAlloc_1119_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1119_, 0, v_ks_1099_);
lean_ctor_set(v_reuseFailAlloc_1119_, 1, v_vs_1100_);
v___x_1105_ = v_reuseFailAlloc_1119_;
goto v_reusejp_1104_;
}
v_reusejp_1104_:
{
lean_object* v_newNode_1106_; uint8_t v___y_1108_; size_t v___x_1114_; uint8_t v___x_1115_; 
v_newNode_1106_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20___redArg(v___x_1105_, v_x_1051_, v_x_1052_);
v___x_1114_ = ((size_t)7ULL);
v___x_1115_ = lean_usize_dec_le(v___x_1114_, v_x_1050_);
if (v___x_1115_ == 0)
{
lean_object* v___x_1116_; lean_object* v___x_1117_; uint8_t v___x_1118_; 
v___x_1116_ = l_Lean_PersistentHashMap_getCollisionNodeSize___redArg(v_newNode_1106_);
v___x_1117_ = lean_unsigned_to_nat(4u);
v___x_1118_ = lean_nat_dec_lt(v___x_1116_, v___x_1117_);
lean_dec(v___x_1116_);
v___y_1108_ = v___x_1118_;
goto v___jp_1107_;
}
else
{
v___y_1108_ = v___x_1115_;
goto v___jp_1107_;
}
v___jp_1107_:
{
if (v___y_1108_ == 0)
{
lean_object* v_ks_1109_; lean_object* v_vs_1110_; lean_object* v___x_1111_; lean_object* v___x_1112_; lean_object* v___x_1113_; 
v_ks_1109_ = lean_ctor_get(v_newNode_1106_, 0);
lean_inc_ref(v_ks_1109_);
v_vs_1110_ = lean_ctor_get(v_newNode_1106_, 1);
lean_inc_ref(v_vs_1110_);
lean_dec_ref(v_newNode_1106_);
v___x_1111_ = lean_unsigned_to_nat(0u);
v___x_1112_ = lean_obj_once(&l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg___closed__0, &l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg___closed__0_once, _init_l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg___closed__0);
v___x_1113_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21___redArg(v_x_1050_, v_ks_1109_, v_vs_1110_, v___x_1111_, v___x_1112_);
lean_dec_ref(v_vs_1110_);
lean_dec_ref(v_ks_1109_);
return v___x_1113_;
}
else
{
return v_newNode_1106_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21___redArg(size_t v_depth_1121_, lean_object* v_keys_1122_, lean_object* v_vals_1123_, lean_object* v_i_1124_, lean_object* v_entries_1125_){
_start:
{
lean_object* v___x_1126_; uint8_t v___x_1127_; 
v___x_1126_ = lean_array_get_size(v_keys_1122_);
v___x_1127_ = lean_nat_dec_lt(v_i_1124_, v___x_1126_);
if (v___x_1127_ == 0)
{
lean_dec(v_i_1124_);
return v_entries_1125_;
}
else
{
lean_object* v_k_1128_; lean_object* v_v_1129_; uint64_t v___x_1130_; size_t v_h_1131_; size_t v___x_1132_; lean_object* v___x_1133_; size_t v___x_1134_; size_t v___x_1135_; size_t v___x_1136_; size_t v_h_1137_; lean_object* v___x_1138_; lean_object* v___x_1139_; 
v_k_1128_ = lean_array_fget_borrowed(v_keys_1122_, v_i_1124_);
v_v_1129_ = lean_array_fget_borrowed(v_vals_1123_, v_i_1124_);
v___x_1130_ = l_Lean_instHashableMVarId_hash(v_k_1128_);
v_h_1131_ = lean_uint64_to_usize(v___x_1130_);
v___x_1132_ = ((size_t)5ULL);
v___x_1133_ = lean_unsigned_to_nat(1u);
v___x_1134_ = ((size_t)1ULL);
v___x_1135_ = lean_usize_sub(v_depth_1121_, v___x_1134_);
v___x_1136_ = lean_usize_mul(v___x_1132_, v___x_1135_);
v_h_1137_ = lean_usize_shift_right(v_h_1131_, v___x_1136_);
v___x_1138_ = lean_nat_add(v_i_1124_, v___x_1133_);
lean_dec(v_i_1124_);
lean_inc(v_v_1129_);
lean_inc(v_k_1128_);
v___x_1139_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg(v_entries_1125_, v_h_1137_, v_depth_1121_, v_k_1128_, v_v_1129_);
v_i_1124_ = v___x_1138_;
v_entries_1125_ = v___x_1139_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21___redArg___boxed(lean_object* v_depth_1141_, lean_object* v_keys_1142_, lean_object* v_vals_1143_, lean_object* v_i_1144_, lean_object* v_entries_1145_){
_start:
{
size_t v_depth_boxed_1146_; lean_object* v_res_1147_; 
v_depth_boxed_1146_ = lean_unbox_usize(v_depth_1141_);
lean_dec(v_depth_1141_);
v_res_1147_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21___redArg(v_depth_boxed_1146_, v_keys_1142_, v_vals_1143_, v_i_1144_, v_entries_1145_);
lean_dec_ref(v_vals_1143_);
lean_dec_ref(v_keys_1142_);
return v_res_1147_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg___boxed(lean_object* v_x_1148_, lean_object* v_x_1149_, lean_object* v_x_1150_, lean_object* v_x_1151_, lean_object* v_x_1152_){
_start:
{
size_t v_x_41050__boxed_1153_; size_t v_x_41051__boxed_1154_; lean_object* v_res_1155_; 
v_x_41050__boxed_1153_ = lean_unbox_usize(v_x_1149_);
lean_dec(v_x_1149_);
v_x_41051__boxed_1154_ = lean_unbox_usize(v_x_1150_);
lean_dec(v_x_1150_);
v_res_1155_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg(v_x_1148_, v_x_41050__boxed_1153_, v_x_41051__boxed_1154_, v_x_1151_, v_x_1152_);
return v_res_1155_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4___redArg(lean_object* v_x_1156_, lean_object* v_x_1157_, lean_object* v_x_1158_){
_start:
{
uint64_t v___x_1159_; size_t v___x_1160_; size_t v___x_1161_; lean_object* v___x_1162_; 
v___x_1159_ = l_Lean_instHashableMVarId_hash(v_x_1157_);
v___x_1160_ = lean_uint64_to_usize(v___x_1159_);
v___x_1161_ = ((size_t)1ULL);
v___x_1162_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg(v_x_1156_, v___x_1160_, v___x_1161_, v_x_1157_, v_x_1158_);
return v___x_1162_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2___redArg(lean_object* v_mvarId_1163_, lean_object* v_val_1164_, lean_object* v___y_1165_){
_start:
{
lean_object* v___x_1167_; lean_object* v_mctx_1168_; lean_object* v_cache_1169_; lean_object* v_zetaDeltaFVarIds_1170_; lean_object* v_postponed_1171_; lean_object* v_diag_1172_; lean_object* v___x_1174_; uint8_t v_isShared_1175_; uint8_t v_isSharedCheck_1200_; 
v___x_1167_ = lean_st_ref_take(v___y_1165_);
v_mctx_1168_ = lean_ctor_get(v___x_1167_, 0);
v_cache_1169_ = lean_ctor_get(v___x_1167_, 1);
v_zetaDeltaFVarIds_1170_ = lean_ctor_get(v___x_1167_, 2);
v_postponed_1171_ = lean_ctor_get(v___x_1167_, 3);
v_diag_1172_ = lean_ctor_get(v___x_1167_, 4);
v_isSharedCheck_1200_ = !lean_is_exclusive(v___x_1167_);
if (v_isSharedCheck_1200_ == 0)
{
v___x_1174_ = v___x_1167_;
v_isShared_1175_ = v_isSharedCheck_1200_;
goto v_resetjp_1173_;
}
else
{
lean_inc(v_diag_1172_);
lean_inc(v_postponed_1171_);
lean_inc(v_zetaDeltaFVarIds_1170_);
lean_inc(v_cache_1169_);
lean_inc(v_mctx_1168_);
lean_dec(v___x_1167_);
v___x_1174_ = lean_box(0);
v_isShared_1175_ = v_isSharedCheck_1200_;
goto v_resetjp_1173_;
}
v_resetjp_1173_:
{
lean_object* v_depth_1176_; lean_object* v_levelAssignDepth_1177_; lean_object* v_lmvarCounter_1178_; lean_object* v_mvarCounter_1179_; lean_object* v_lDecls_1180_; lean_object* v_decls_1181_; lean_object* v_userNames_1182_; lean_object* v_lAssignment_1183_; lean_object* v_eAssignment_1184_; lean_object* v_dAssignment_1185_; lean_object* v___x_1187_; uint8_t v_isShared_1188_; uint8_t v_isSharedCheck_1199_; 
v_depth_1176_ = lean_ctor_get(v_mctx_1168_, 0);
v_levelAssignDepth_1177_ = lean_ctor_get(v_mctx_1168_, 1);
v_lmvarCounter_1178_ = lean_ctor_get(v_mctx_1168_, 2);
v_mvarCounter_1179_ = lean_ctor_get(v_mctx_1168_, 3);
v_lDecls_1180_ = lean_ctor_get(v_mctx_1168_, 4);
v_decls_1181_ = lean_ctor_get(v_mctx_1168_, 5);
v_userNames_1182_ = lean_ctor_get(v_mctx_1168_, 6);
v_lAssignment_1183_ = lean_ctor_get(v_mctx_1168_, 7);
v_eAssignment_1184_ = lean_ctor_get(v_mctx_1168_, 8);
v_dAssignment_1185_ = lean_ctor_get(v_mctx_1168_, 9);
v_isSharedCheck_1199_ = !lean_is_exclusive(v_mctx_1168_);
if (v_isSharedCheck_1199_ == 0)
{
v___x_1187_ = v_mctx_1168_;
v_isShared_1188_ = v_isSharedCheck_1199_;
goto v_resetjp_1186_;
}
else
{
lean_inc(v_dAssignment_1185_);
lean_inc(v_eAssignment_1184_);
lean_inc(v_lAssignment_1183_);
lean_inc(v_userNames_1182_);
lean_inc(v_decls_1181_);
lean_inc(v_lDecls_1180_);
lean_inc(v_mvarCounter_1179_);
lean_inc(v_lmvarCounter_1178_);
lean_inc(v_levelAssignDepth_1177_);
lean_inc(v_depth_1176_);
lean_dec(v_mctx_1168_);
v___x_1187_ = lean_box(0);
v_isShared_1188_ = v_isSharedCheck_1199_;
goto v_resetjp_1186_;
}
v_resetjp_1186_:
{
lean_object* v___x_1189_; lean_object* v___x_1191_; 
v___x_1189_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4___redArg(v_eAssignment_1184_, v_mvarId_1163_, v_val_1164_);
if (v_isShared_1188_ == 0)
{
lean_ctor_set(v___x_1187_, 8, v___x_1189_);
v___x_1191_ = v___x_1187_;
goto v_reusejp_1190_;
}
else
{
lean_object* v_reuseFailAlloc_1198_; 
v_reuseFailAlloc_1198_ = lean_alloc_ctor(0, 10, 0);
lean_ctor_set(v_reuseFailAlloc_1198_, 0, v_depth_1176_);
lean_ctor_set(v_reuseFailAlloc_1198_, 1, v_levelAssignDepth_1177_);
lean_ctor_set(v_reuseFailAlloc_1198_, 2, v_lmvarCounter_1178_);
lean_ctor_set(v_reuseFailAlloc_1198_, 3, v_mvarCounter_1179_);
lean_ctor_set(v_reuseFailAlloc_1198_, 4, v_lDecls_1180_);
lean_ctor_set(v_reuseFailAlloc_1198_, 5, v_decls_1181_);
lean_ctor_set(v_reuseFailAlloc_1198_, 6, v_userNames_1182_);
lean_ctor_set(v_reuseFailAlloc_1198_, 7, v_lAssignment_1183_);
lean_ctor_set(v_reuseFailAlloc_1198_, 8, v___x_1189_);
lean_ctor_set(v_reuseFailAlloc_1198_, 9, v_dAssignment_1185_);
v___x_1191_ = v_reuseFailAlloc_1198_;
goto v_reusejp_1190_;
}
v_reusejp_1190_:
{
lean_object* v___x_1193_; 
if (v_isShared_1175_ == 0)
{
lean_ctor_set(v___x_1174_, 0, v___x_1191_);
v___x_1193_ = v___x_1174_;
goto v_reusejp_1192_;
}
else
{
lean_object* v_reuseFailAlloc_1197_; 
v_reuseFailAlloc_1197_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_1197_, 0, v___x_1191_);
lean_ctor_set(v_reuseFailAlloc_1197_, 1, v_cache_1169_);
lean_ctor_set(v_reuseFailAlloc_1197_, 2, v_zetaDeltaFVarIds_1170_);
lean_ctor_set(v_reuseFailAlloc_1197_, 3, v_postponed_1171_);
lean_ctor_set(v_reuseFailAlloc_1197_, 4, v_diag_1172_);
v___x_1193_ = v_reuseFailAlloc_1197_;
goto v_reusejp_1192_;
}
v_reusejp_1192_:
{
lean_object* v___x_1194_; lean_object* v___x_1195_; lean_object* v___x_1196_; 
v___x_1194_ = lean_st_ref_set(v___y_1165_, v___x_1193_);
v___x_1195_ = lean_box(0);
v___x_1196_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1196_, 0, v___x_1195_);
return v___x_1196_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2___redArg___boxed(lean_object* v_mvarId_1201_, lean_object* v_val_1202_, lean_object* v___y_1203_, lean_object* v___y_1204_){
_start:
{
lean_object* v_res_1205_; 
v_res_1205_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2___redArg(v_mvarId_1201_, v_val_1202_, v___y_1203_);
lean_dec(v___y_1203_);
return v_res_1205_;
}
}
LEAN_EXPORT lean_object* l_List_mapTR_loop___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__0(lean_object* v_a_1206_, lean_object* v_a_1207_){
_start:
{
if (lean_obj_tag(v_a_1206_) == 0)
{
lean_object* v___x_1208_; 
v___x_1208_ = l_List_reverse___redArg(v_a_1207_);
return v___x_1208_;
}
else
{
lean_object* v_head_1209_; lean_object* v_snd_1210_; lean_object* v_tail_1211_; lean_object* v___x_1213_; uint8_t v_isShared_1214_; uint8_t v_isSharedCheck_1234_; 
v_head_1209_ = lean_ctor_get(v_a_1206_, 0);
lean_inc(v_head_1209_);
v_snd_1210_ = lean_ctor_get(v_head_1209_, 1);
lean_inc(v_snd_1210_);
v_tail_1211_ = lean_ctor_get(v_a_1206_, 1);
v_isSharedCheck_1234_ = !lean_is_exclusive(v_a_1206_);
if (v_isSharedCheck_1234_ == 0)
{
lean_object* v_unused_1235_; 
v_unused_1235_ = lean_ctor_get(v_a_1206_, 0);
lean_dec(v_unused_1235_);
v___x_1213_ = v_a_1206_;
v_isShared_1214_ = v_isSharedCheck_1234_;
goto v_resetjp_1212_;
}
else
{
lean_inc(v_tail_1211_);
lean_dec(v_a_1206_);
v___x_1213_ = lean_box(0);
v_isShared_1214_ = v_isSharedCheck_1234_;
goto v_resetjp_1212_;
}
v_resetjp_1212_:
{
lean_object* v_fst_1215_; lean_object* v___x_1217_; uint8_t v_isShared_1218_; uint8_t v_isSharedCheck_1232_; 
v_fst_1215_ = lean_ctor_get(v_head_1209_, 0);
v_isSharedCheck_1232_ = !lean_is_exclusive(v_head_1209_);
if (v_isSharedCheck_1232_ == 0)
{
lean_object* v_unused_1233_; 
v_unused_1233_ = lean_ctor_get(v_head_1209_, 1);
lean_dec(v_unused_1233_);
v___x_1217_ = v_head_1209_;
v_isShared_1218_ = v_isSharedCheck_1232_;
goto v_resetjp_1216_;
}
else
{
lean_inc(v_fst_1215_);
lean_dec(v_head_1209_);
v___x_1217_ = lean_box(0);
v_isShared_1218_ = v_isSharedCheck_1232_;
goto v_resetjp_1216_;
}
v_resetjp_1216_:
{
lean_object* v_width_1219_; lean_object* v_atomNumber_1220_; uint8_t v_synthetic_1221_; lean_object* v___x_1222_; lean_object* v___x_1224_; 
v_width_1219_ = lean_ctor_get(v_snd_1210_, 0);
lean_inc(v_width_1219_);
v_atomNumber_1220_ = lean_ctor_get(v_snd_1210_, 1);
lean_inc(v_atomNumber_1220_);
v_synthetic_1221_ = lean_ctor_get_uint8(v_snd_1210_, sizeof(void*)*2);
lean_dec(v_snd_1210_);
v___x_1222_ = lean_box(v_synthetic_1221_);
if (v_isShared_1218_ == 0)
{
lean_ctor_set(v___x_1217_, 1, v___x_1222_);
v___x_1224_ = v___x_1217_;
goto v_reusejp_1223_;
}
else
{
lean_object* v_reuseFailAlloc_1231_; 
v_reuseFailAlloc_1231_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1231_, 0, v_fst_1215_);
lean_ctor_set(v_reuseFailAlloc_1231_, 1, v___x_1222_);
v___x_1224_ = v_reuseFailAlloc_1231_;
goto v_reusejp_1223_;
}
v_reusejp_1223_:
{
lean_object* v___x_1225_; lean_object* v___x_1226_; lean_object* v___x_1228_; 
v___x_1225_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1225_, 0, v_width_1219_);
lean_ctor_set(v___x_1225_, 1, v___x_1224_);
v___x_1226_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1226_, 0, v_atomNumber_1220_);
lean_ctor_set(v___x_1226_, 1, v___x_1225_);
if (v_isShared_1214_ == 0)
{
lean_ctor_set(v___x_1213_, 1, v_a_1207_);
lean_ctor_set(v___x_1213_, 0, v___x_1226_);
v___x_1228_ = v___x_1213_;
goto v_reusejp_1227_;
}
else
{
lean_object* v_reuseFailAlloc_1230_; 
v_reuseFailAlloc_1230_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1230_, 0, v___x_1226_);
lean_ctor_set(v_reuseFailAlloc_1230_, 1, v_a_1207_);
v___x_1228_ = v_reuseFailAlloc_1230_;
goto v_reusejp_1227_;
}
v_reusejp_1227_:
{
v_a_1206_ = v_tail_1211_;
v_a_1207_ = v___x_1228_;
goto _start;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg(lean_object* v_cls_1239_, lean_object* v_msg_1240_, lean_object* v___y_1241_, lean_object* v___y_1242_, lean_object* v___y_1243_, lean_object* v___y_1244_){
_start:
{
lean_object* v_ref_1246_; lean_object* v___x_1247_; lean_object* v_a_1248_; lean_object* v___x_1250_; uint8_t v_isShared_1251_; uint8_t v_isSharedCheck_1292_; 
v_ref_1246_ = lean_ctor_get(v___y_1243_, 5);
v___x_1247_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__2_spec__2(v_msg_1240_, v___y_1241_, v___y_1242_, v___y_1243_, v___y_1244_);
v_a_1248_ = lean_ctor_get(v___x_1247_, 0);
v_isSharedCheck_1292_ = !lean_is_exclusive(v___x_1247_);
if (v_isSharedCheck_1292_ == 0)
{
v___x_1250_ = v___x_1247_;
v_isShared_1251_ = v_isSharedCheck_1292_;
goto v_resetjp_1249_;
}
else
{
lean_inc(v_a_1248_);
lean_dec(v___x_1247_);
v___x_1250_ = lean_box(0);
v_isShared_1251_ = v_isSharedCheck_1292_;
goto v_resetjp_1249_;
}
v_resetjp_1249_:
{
lean_object* v___x_1252_; lean_object* v_traceState_1253_; lean_object* v_env_1254_; lean_object* v_nextMacroScope_1255_; lean_object* v_ngen_1256_; lean_object* v_auxDeclNGen_1257_; lean_object* v_cache_1258_; lean_object* v_messages_1259_; lean_object* v_infoState_1260_; lean_object* v_snapshotTasks_1261_; lean_object* v___x_1263_; uint8_t v_isShared_1264_; uint8_t v_isSharedCheck_1291_; 
v___x_1252_ = lean_st_ref_take(v___y_1244_);
v_traceState_1253_ = lean_ctor_get(v___x_1252_, 4);
v_env_1254_ = lean_ctor_get(v___x_1252_, 0);
v_nextMacroScope_1255_ = lean_ctor_get(v___x_1252_, 1);
v_ngen_1256_ = lean_ctor_get(v___x_1252_, 2);
v_auxDeclNGen_1257_ = lean_ctor_get(v___x_1252_, 3);
v_cache_1258_ = lean_ctor_get(v___x_1252_, 5);
v_messages_1259_ = lean_ctor_get(v___x_1252_, 6);
v_infoState_1260_ = lean_ctor_get(v___x_1252_, 7);
v_snapshotTasks_1261_ = lean_ctor_get(v___x_1252_, 8);
v_isSharedCheck_1291_ = !lean_is_exclusive(v___x_1252_);
if (v_isSharedCheck_1291_ == 0)
{
v___x_1263_ = v___x_1252_;
v_isShared_1264_ = v_isSharedCheck_1291_;
goto v_resetjp_1262_;
}
else
{
lean_inc(v_snapshotTasks_1261_);
lean_inc(v_infoState_1260_);
lean_inc(v_messages_1259_);
lean_inc(v_cache_1258_);
lean_inc(v_traceState_1253_);
lean_inc(v_auxDeclNGen_1257_);
lean_inc(v_ngen_1256_);
lean_inc(v_nextMacroScope_1255_);
lean_inc(v_env_1254_);
lean_dec(v___x_1252_);
v___x_1263_ = lean_box(0);
v_isShared_1264_ = v_isSharedCheck_1291_;
goto v_resetjp_1262_;
}
v_resetjp_1262_:
{
uint64_t v_tid_1265_; lean_object* v_traces_1266_; lean_object* v___x_1268_; uint8_t v_isShared_1269_; uint8_t v_isSharedCheck_1290_; 
v_tid_1265_ = lean_ctor_get_uint64(v_traceState_1253_, sizeof(void*)*1);
v_traces_1266_ = lean_ctor_get(v_traceState_1253_, 0);
v_isSharedCheck_1290_ = !lean_is_exclusive(v_traceState_1253_);
if (v_isSharedCheck_1290_ == 0)
{
v___x_1268_ = v_traceState_1253_;
v_isShared_1269_ = v_isSharedCheck_1290_;
goto v_resetjp_1267_;
}
else
{
lean_inc(v_traces_1266_);
lean_dec(v_traceState_1253_);
v___x_1268_ = lean_box(0);
v_isShared_1269_ = v_isSharedCheck_1290_;
goto v_resetjp_1267_;
}
v_resetjp_1267_:
{
lean_object* v___x_1270_; double v___x_1271_; uint8_t v___x_1272_; lean_object* v___x_1273_; lean_object* v___x_1274_; lean_object* v___x_1275_; lean_object* v___x_1276_; lean_object* v___x_1277_; lean_object* v___x_1278_; lean_object* v___x_1280_; 
v___x_1270_ = lean_box(0);
v___x_1271_ = lean_float_once(&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__0, &l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__0_once, _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9___closed__0);
v___x_1272_ = 0;
v___x_1273_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___closed__0));
v___x_1274_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v___x_1274_, 0, v_cls_1239_);
lean_ctor_set(v___x_1274_, 1, v___x_1270_);
lean_ctor_set(v___x_1274_, 2, v___x_1273_);
lean_ctor_set_float(v___x_1274_, sizeof(void*)*3, v___x_1271_);
lean_ctor_set_float(v___x_1274_, sizeof(void*)*3 + 8, v___x_1271_);
lean_ctor_set_uint8(v___x_1274_, sizeof(void*)*3 + 16, v___x_1272_);
v___x_1275_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___closed__1));
v___x_1276_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v___x_1276_, 0, v___x_1274_);
lean_ctor_set(v___x_1276_, 1, v_a_1248_);
lean_ctor_set(v___x_1276_, 2, v___x_1275_);
lean_inc(v_ref_1246_);
v___x_1277_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1277_, 0, v_ref_1246_);
lean_ctor_set(v___x_1277_, 1, v___x_1276_);
v___x_1278_ = l_Lean_PersistentArray_push___redArg(v_traces_1266_, v___x_1277_);
if (v_isShared_1269_ == 0)
{
lean_ctor_set(v___x_1268_, 0, v___x_1278_);
v___x_1280_ = v___x_1268_;
goto v_reusejp_1279_;
}
else
{
lean_object* v_reuseFailAlloc_1289_; 
v_reuseFailAlloc_1289_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_1289_, 0, v___x_1278_);
lean_ctor_set_uint64(v_reuseFailAlloc_1289_, sizeof(void*)*1, v_tid_1265_);
v___x_1280_ = v_reuseFailAlloc_1289_;
goto v_reusejp_1279_;
}
v_reusejp_1279_:
{
lean_object* v___x_1282_; 
if (v_isShared_1264_ == 0)
{
lean_ctor_set(v___x_1263_, 4, v___x_1280_);
v___x_1282_ = v___x_1263_;
goto v_reusejp_1281_;
}
else
{
lean_object* v_reuseFailAlloc_1288_; 
v_reuseFailAlloc_1288_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_1288_, 0, v_env_1254_);
lean_ctor_set(v_reuseFailAlloc_1288_, 1, v_nextMacroScope_1255_);
lean_ctor_set(v_reuseFailAlloc_1288_, 2, v_ngen_1256_);
lean_ctor_set(v_reuseFailAlloc_1288_, 3, v_auxDeclNGen_1257_);
lean_ctor_set(v_reuseFailAlloc_1288_, 4, v___x_1280_);
lean_ctor_set(v_reuseFailAlloc_1288_, 5, v_cache_1258_);
lean_ctor_set(v_reuseFailAlloc_1288_, 6, v_messages_1259_);
lean_ctor_set(v_reuseFailAlloc_1288_, 7, v_infoState_1260_);
lean_ctor_set(v_reuseFailAlloc_1288_, 8, v_snapshotTasks_1261_);
v___x_1282_ = v_reuseFailAlloc_1288_;
goto v_reusejp_1281_;
}
v_reusejp_1281_:
{
lean_object* v___x_1283_; lean_object* v___x_1284_; lean_object* v___x_1286_; 
v___x_1283_ = lean_st_ref_set(v___y_1244_, v___x_1282_);
v___x_1284_ = lean_box(0);
if (v_isShared_1251_ == 0)
{
lean_ctor_set(v___x_1250_, 0, v___x_1284_);
v___x_1286_ = v___x_1250_;
goto v_reusejp_1285_;
}
else
{
lean_object* v_reuseFailAlloc_1287_; 
v_reuseFailAlloc_1287_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1287_, 0, v___x_1284_);
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
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___boxed(lean_object* v_cls_1293_, lean_object* v_msg_1294_, lean_object* v___y_1295_, lean_object* v___y_1296_, lean_object* v___y_1297_, lean_object* v___y_1298_, lean_object* v___y_1299_){
_start:
{
lean_object* v_res_1300_; 
v_res_1300_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg(v_cls_1293_, v_msg_1294_, v___y_1295_, v___y_1296_, v___y_1297_, v___y_1298_);
lean_dec(v___y_1298_);
lean_dec_ref(v___y_1297_);
lean_dec(v___y_1296_);
lean_dec_ref(v___y_1295_);
return v_res_1300_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__0(void){
_start:
{
lean_object* v___x_1301_; lean_object* v___x_1302_; lean_object* v___x_1303_; 
v___x_1301_ = lean_box(0);
v___x_1302_ = lean_unsigned_to_nat(16u);
v___x_1303_ = lean_mk_array(v___x_1302_, v___x_1301_);
return v___x_1303_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__1(void){
_start:
{
lean_object* v___x_1304_; lean_object* v___x_1305_; lean_object* v___x_1306_; 
v___x_1304_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__0, &l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__0_once, _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__0);
v___x_1305_ = lean_unsigned_to_nat(0u);
v___x_1306_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1306_, 0, v___x_1305_);
lean_ctor_set(v___x_1306_, 1, v___x_1304_);
return v___x_1306_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__5(void){
_start:
{
lean_object* v___x_1311_; lean_object* v___x_1312_; 
v___x_1311_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__4));
v___x_1312_ = l_Lean_stringToMessageData(v___x_1311_);
return v___x_1312_;
}
}
static double _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__6(void){
_start:
{
lean_object* v___x_1313_; double v___x_1314_; 
v___x_1313_ = lean_unsigned_to_nat(1000000000u);
v___x_1314_ = lean_float_of_nat(v___x_1313_);
return v___x_1314_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1(lean_object* v_unsatProver_1315_, lean_object* v_g_1316_, lean_object* v_cls_1317_, uint8_t v___x_1318_, lean_object* v___x_1319_, lean_object* v___f_1320_, lean_object* v___y_1321_, lean_object* v___y_1322_, lean_object* v___y_1323_, lean_object* v___y_1324_, lean_object* v___y_1325_, lean_object* v___y_1326_, lean_object* v___y_1327_, lean_object* v___y_1328_){
_start:
{
lean_object* v___y_1331_; lean_object* v___y_1332_; lean_object* v___y_1333_; lean_object* v___y_1334_; lean_object* v___y_1335_; lean_object* v___y_1336_; lean_object* v___y_1337_; lean_object* v___y_1338_; lean_object* v___y_1339_; lean_object* v___y_1340_; lean_object* v___y_1401_; lean_object* v___y_1402_; lean_object* v___y_1403_; lean_object* v___y_1404_; lean_object* v___y_1405_; lean_object* v___y_1406_; lean_object* v___y_1407_; lean_object* v___y_1408_; lean_object* v___y_1409_; lean_object* v_options_1420_; lean_object* v_inheritedTraceOptions_1421_; uint8_t v_hasTrace_1422_; lean_object* v___y_1424_; 
v_options_1420_ = lean_ctor_get(v___y_1327_, 2);
v_inheritedTraceOptions_1421_ = lean_ctor_get(v___y_1327_, 13);
v_hasTrace_1422_ = lean_ctor_get_uint8(v_options_1420_, sizeof(void*)*1);
if (v_hasTrace_1422_ == 0)
{
lean_object* v___x_1453_; 
lean_dec_ref(v___f_1320_);
lean_dec_ref(v___x_1319_);
lean_inc(v_g_1316_);
v___x_1453_ = l_Lean_Meta_Tactic_BVDecide_reflectBV(v_g_1316_, v___y_1321_, v___y_1322_, v___y_1323_, v___y_1324_, v___y_1325_, v___y_1326_, v___y_1327_, v___y_1328_);
v___y_1424_ = v___x_1453_;
goto v___jp_1423_;
}
else
{
lean_object* v___x_1454_; lean_object* v___x_1455_; uint8_t v___x_1456_; lean_object* v___y_1458_; lean_object* v___y_1459_; lean_object* v_a_1460_; lean_object* v___y_1473_; lean_object* v___y_1474_; lean_object* v_a_1475_; 
v___x_1454_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__3));
lean_inc(v_cls_1317_);
v___x_1455_ = l_Lean_Name_append(v___x_1454_, v_cls_1317_);
v___x_1456_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_1421_, v_options_1420_, v___x_1455_);
lean_dec(v___x_1455_);
if (v___x_1456_ == 0)
{
lean_object* v___x_1525_; uint8_t v___x_1526_; 
v___x_1525_ = l_Lean_trace_profiler;
v___x_1526_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__8(v_options_1420_, v___x_1525_);
if (v___x_1526_ == 0)
{
lean_object* v___x_1527_; 
lean_dec_ref(v___f_1320_);
lean_dec_ref(v___x_1319_);
lean_inc(v_g_1316_);
v___x_1527_ = l_Lean_Meta_Tactic_BVDecide_reflectBV(v_g_1316_, v___y_1321_, v___y_1322_, v___y_1323_, v___y_1324_, v___y_1325_, v___y_1326_, v___y_1327_, v___y_1328_);
v___y_1424_ = v___x_1527_;
goto v___jp_1423_;
}
else
{
goto v___jp_1484_;
}
}
else
{
goto v___jp_1484_;
}
v___jp_1457_:
{
lean_object* v___x_1461_; double v___x_1462_; double v___x_1463_; double v___x_1464_; double v___x_1465_; double v___x_1466_; lean_object* v___x_1467_; lean_object* v___x_1468_; lean_object* v___x_1469_; lean_object* v___x_1470_; lean_object* v___x_1471_; 
v___x_1461_ = lean_io_mono_nanos_now();
v___x_1462_ = lean_float_of_nat(v___y_1458_);
v___x_1463_ = lean_float_once(&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__6, &l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__6);
v___x_1464_ = lean_float_div(v___x_1462_, v___x_1463_);
v___x_1465_ = lean_float_of_nat(v___x_1461_);
v___x_1466_ = lean_float_div(v___x_1465_, v___x_1463_);
v___x_1467_ = lean_box_float(v___x_1464_);
v___x_1468_ = lean_box_float(v___x_1466_);
v___x_1469_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1469_, 0, v___x_1467_);
lean_ctor_set(v___x_1469_, 1, v___x_1468_);
v___x_1470_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1470_, 0, v_a_1460_);
lean_ctor_set(v___x_1470_, 1, v___x_1469_);
lean_inc(v_cls_1317_);
v___x_1471_ = l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9(v_cls_1317_, v___x_1318_, v___x_1319_, v_options_1420_, v___x_1456_, v___y_1459_, v___f_1320_, v___x_1470_, v___y_1321_, v___y_1322_, v___y_1323_, v___y_1324_, v___y_1325_, v___y_1326_, v___y_1327_, v___y_1328_);
v___y_1424_ = v___x_1471_;
goto v___jp_1423_;
}
v___jp_1472_:
{
lean_object* v___x_1476_; double v___x_1477_; double v___x_1478_; lean_object* v___x_1479_; lean_object* v___x_1480_; lean_object* v___x_1481_; lean_object* v___x_1482_; lean_object* v___x_1483_; 
v___x_1476_ = lean_io_get_num_heartbeats();
v___x_1477_ = lean_float_of_nat(v___y_1473_);
v___x_1478_ = lean_float_of_nat(v___x_1476_);
v___x_1479_ = lean_box_float(v___x_1477_);
v___x_1480_ = lean_box_float(v___x_1478_);
v___x_1481_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1481_, 0, v___x_1479_);
lean_ctor_set(v___x_1481_, 1, v___x_1480_);
v___x_1482_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1482_, 0, v_a_1475_);
lean_ctor_set(v___x_1482_, 1, v___x_1481_);
lean_inc(v_cls_1317_);
v___x_1483_ = l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9(v_cls_1317_, v___x_1318_, v___x_1319_, v_options_1420_, v___x_1456_, v___y_1474_, v___f_1320_, v___x_1482_, v___y_1321_, v___y_1322_, v___y_1323_, v___y_1324_, v___y_1325_, v___y_1326_, v___y_1327_, v___y_1328_);
v___y_1424_ = v___x_1483_;
goto v___jp_1423_;
}
v___jp_1484_:
{
lean_object* v___x_1485_; lean_object* v_a_1486_; lean_object* v___x_1487_; uint8_t v___x_1488_; 
v___x_1485_ = l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__7___redArg(v___y_1328_);
v_a_1486_ = lean_ctor_get(v___x_1485_, 0);
lean_inc(v_a_1486_);
lean_dec_ref(v___x_1485_);
v___x_1487_ = l_Lean_trace_profiler_useHeartbeats;
v___x_1488_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__8(v_options_1420_, v___x_1487_);
if (v___x_1488_ == 0)
{
lean_object* v___x_1489_; lean_object* v___x_1490_; 
v___x_1489_ = lean_io_mono_nanos_now();
lean_inc(v_g_1316_);
v___x_1490_ = l_Lean_Meta_Tactic_BVDecide_reflectBV(v_g_1316_, v___y_1321_, v___y_1322_, v___y_1323_, v___y_1324_, v___y_1325_, v___y_1326_, v___y_1327_, v___y_1328_);
if (lean_obj_tag(v___x_1490_) == 0)
{
lean_object* v_a_1491_; lean_object* v___x_1493_; uint8_t v_isShared_1494_; uint8_t v_isSharedCheck_1498_; 
v_a_1491_ = lean_ctor_get(v___x_1490_, 0);
v_isSharedCheck_1498_ = !lean_is_exclusive(v___x_1490_);
if (v_isSharedCheck_1498_ == 0)
{
v___x_1493_ = v___x_1490_;
v_isShared_1494_ = v_isSharedCheck_1498_;
goto v_resetjp_1492_;
}
else
{
lean_inc(v_a_1491_);
lean_dec(v___x_1490_);
v___x_1493_ = lean_box(0);
v_isShared_1494_ = v_isSharedCheck_1498_;
goto v_resetjp_1492_;
}
v_resetjp_1492_:
{
lean_object* v___x_1496_; 
if (v_isShared_1494_ == 0)
{
lean_ctor_set_tag(v___x_1493_, 1);
v___x_1496_ = v___x_1493_;
goto v_reusejp_1495_;
}
else
{
lean_object* v_reuseFailAlloc_1497_; 
v_reuseFailAlloc_1497_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1497_, 0, v_a_1491_);
v___x_1496_ = v_reuseFailAlloc_1497_;
goto v_reusejp_1495_;
}
v_reusejp_1495_:
{
v___y_1458_ = v___x_1489_;
v___y_1459_ = v_a_1486_;
v_a_1460_ = v___x_1496_;
goto v___jp_1457_;
}
}
}
else
{
lean_object* v_a_1499_; lean_object* v___x_1501_; uint8_t v_isShared_1502_; uint8_t v_isSharedCheck_1506_; 
v_a_1499_ = lean_ctor_get(v___x_1490_, 0);
v_isSharedCheck_1506_ = !lean_is_exclusive(v___x_1490_);
if (v_isSharedCheck_1506_ == 0)
{
v___x_1501_ = v___x_1490_;
v_isShared_1502_ = v_isSharedCheck_1506_;
goto v_resetjp_1500_;
}
else
{
lean_inc(v_a_1499_);
lean_dec(v___x_1490_);
v___x_1501_ = lean_box(0);
v_isShared_1502_ = v_isSharedCheck_1506_;
goto v_resetjp_1500_;
}
v_resetjp_1500_:
{
lean_object* v___x_1504_; 
if (v_isShared_1502_ == 0)
{
lean_ctor_set_tag(v___x_1501_, 0);
v___x_1504_ = v___x_1501_;
goto v_reusejp_1503_;
}
else
{
lean_object* v_reuseFailAlloc_1505_; 
v_reuseFailAlloc_1505_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1505_, 0, v_a_1499_);
v___x_1504_ = v_reuseFailAlloc_1505_;
goto v_reusejp_1503_;
}
v_reusejp_1503_:
{
v___y_1458_ = v___x_1489_;
v___y_1459_ = v_a_1486_;
v_a_1460_ = v___x_1504_;
goto v___jp_1457_;
}
}
}
}
else
{
lean_object* v___x_1507_; lean_object* v___x_1508_; 
v___x_1507_ = lean_io_get_num_heartbeats();
lean_inc(v_g_1316_);
v___x_1508_ = l_Lean_Meta_Tactic_BVDecide_reflectBV(v_g_1316_, v___y_1321_, v___y_1322_, v___y_1323_, v___y_1324_, v___y_1325_, v___y_1326_, v___y_1327_, v___y_1328_);
if (lean_obj_tag(v___x_1508_) == 0)
{
lean_object* v_a_1509_; lean_object* v___x_1511_; uint8_t v_isShared_1512_; uint8_t v_isSharedCheck_1516_; 
v_a_1509_ = lean_ctor_get(v___x_1508_, 0);
v_isSharedCheck_1516_ = !lean_is_exclusive(v___x_1508_);
if (v_isSharedCheck_1516_ == 0)
{
v___x_1511_ = v___x_1508_;
v_isShared_1512_ = v_isSharedCheck_1516_;
goto v_resetjp_1510_;
}
else
{
lean_inc(v_a_1509_);
lean_dec(v___x_1508_);
v___x_1511_ = lean_box(0);
v_isShared_1512_ = v_isSharedCheck_1516_;
goto v_resetjp_1510_;
}
v_resetjp_1510_:
{
lean_object* v___x_1514_; 
if (v_isShared_1512_ == 0)
{
lean_ctor_set_tag(v___x_1511_, 1);
v___x_1514_ = v___x_1511_;
goto v_reusejp_1513_;
}
else
{
lean_object* v_reuseFailAlloc_1515_; 
v_reuseFailAlloc_1515_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1515_, 0, v_a_1509_);
v___x_1514_ = v_reuseFailAlloc_1515_;
goto v_reusejp_1513_;
}
v_reusejp_1513_:
{
v___y_1473_ = v___x_1507_;
v___y_1474_ = v_a_1486_;
v_a_1475_ = v___x_1514_;
goto v___jp_1472_;
}
}
}
else
{
lean_object* v_a_1517_; lean_object* v___x_1519_; uint8_t v_isShared_1520_; uint8_t v_isSharedCheck_1524_; 
v_a_1517_ = lean_ctor_get(v___x_1508_, 0);
v_isSharedCheck_1524_ = !lean_is_exclusive(v___x_1508_);
if (v_isSharedCheck_1524_ == 0)
{
v___x_1519_ = v___x_1508_;
v_isShared_1520_ = v_isSharedCheck_1524_;
goto v_resetjp_1518_;
}
else
{
lean_inc(v_a_1517_);
lean_dec(v___x_1508_);
v___x_1519_ = lean_box(0);
v_isShared_1520_ = v_isSharedCheck_1524_;
goto v_resetjp_1518_;
}
v_resetjp_1518_:
{
lean_object* v___x_1522_; 
if (v_isShared_1520_ == 0)
{
lean_ctor_set_tag(v___x_1519_, 0);
v___x_1522_ = v___x_1519_;
goto v_reusejp_1521_;
}
else
{
lean_object* v_reuseFailAlloc_1523_; 
v_reuseFailAlloc_1523_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1523_, 0, v_a_1517_);
v___x_1522_ = v_reuseFailAlloc_1523_;
goto v_reusejp_1521_;
}
v_reusejp_1521_:
{
v___y_1473_ = v___x_1507_;
v___y_1474_ = v_a_1486_;
v_a_1475_ = v___x_1522_;
goto v___jp_1472_;
}
}
}
}
}
}
v___jp_1330_:
{
lean_object* v___x_1341_; lean_object* v___x_1342_; lean_object* v___x_1343_; lean_object* v___x_1344_; lean_object* v___x_1345_; 
v___x_1341_ = lean_box(0);
v___x_1342_ = l_List_mapTR_loop___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__0(v___y_1340_, v___x_1341_);
v___x_1343_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__1, &l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__1);
v___x_1344_ = l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___redArg(v___x_1342_, v___x_1343_);
lean_dec(v___x_1342_);
lean_inc(v___y_1334_);
lean_inc_ref(v___y_1331_);
lean_inc(v___y_1339_);
lean_inc_ref(v___y_1335_);
lean_inc_ref(v___y_1337_);
lean_inc(v_g_1316_);
v___x_1345_ = lean_apply_8(v_unsatProver_1315_, v_g_1316_, v___y_1337_, v___x_1344_, v___y_1335_, v___y_1339_, v___y_1331_, v___y_1334_, lean_box(0));
if (lean_obj_tag(v___x_1345_) == 0)
{
lean_object* v_a_1346_; lean_object* v___x_1348_; uint8_t v_isShared_1349_; uint8_t v_isSharedCheck_1391_; 
v_a_1346_ = lean_ctor_get(v___x_1345_, 0);
v_isSharedCheck_1391_ = !lean_is_exclusive(v___x_1345_);
if (v_isSharedCheck_1391_ == 0)
{
v___x_1348_ = v___x_1345_;
v_isShared_1349_ = v_isSharedCheck_1391_;
goto v_resetjp_1347_;
}
else
{
lean_inc(v_a_1346_);
lean_dec(v___x_1345_);
v___x_1348_ = lean_box(0);
v_isShared_1349_ = v_isSharedCheck_1391_;
goto v_resetjp_1347_;
}
v_resetjp_1347_:
{
if (lean_obj_tag(v_a_1346_) == 0)
{
lean_object* v_a_1350_; lean_object* v___x_1352_; uint8_t v_isShared_1353_; uint8_t v_isSharedCheck_1360_; 
lean_dec_ref(v___y_1337_);
lean_dec(v_g_1316_);
v_a_1350_ = lean_ctor_get(v_a_1346_, 0);
v_isSharedCheck_1360_ = !lean_is_exclusive(v_a_1346_);
if (v_isSharedCheck_1360_ == 0)
{
v___x_1352_ = v_a_1346_;
v_isShared_1353_ = v_isSharedCheck_1360_;
goto v_resetjp_1351_;
}
else
{
lean_inc(v_a_1350_);
lean_dec(v_a_1346_);
v___x_1352_ = lean_box(0);
v_isShared_1353_ = v_isSharedCheck_1360_;
goto v_resetjp_1351_;
}
v_resetjp_1351_:
{
lean_object* v___x_1355_; 
if (v_isShared_1353_ == 0)
{
v___x_1355_ = v___x_1352_;
goto v_reusejp_1354_;
}
else
{
lean_object* v_reuseFailAlloc_1359_; 
v_reuseFailAlloc_1359_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1359_, 0, v_a_1350_);
v___x_1355_ = v_reuseFailAlloc_1359_;
goto v_reusejp_1354_;
}
v_reusejp_1354_:
{
lean_object* v___x_1357_; 
if (v_isShared_1349_ == 0)
{
lean_ctor_set(v___x_1348_, 0, v___x_1355_);
v___x_1357_ = v___x_1348_;
goto v_reusejp_1356_;
}
else
{
lean_object* v_reuseFailAlloc_1358_; 
v_reuseFailAlloc_1358_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1358_, 0, v___x_1355_);
v___x_1357_ = v_reuseFailAlloc_1358_;
goto v_reusejp_1356_;
}
v_reusejp_1356_:
{
return v___x_1357_;
}
}
}
}
else
{
lean_object* v_a_1361_; lean_object* v___x_1363_; uint8_t v_isShared_1364_; uint8_t v_isSharedCheck_1390_; 
lean_del_object(v___x_1348_);
v_a_1361_ = lean_ctor_get(v_a_1346_, 0);
v_isSharedCheck_1390_ = !lean_is_exclusive(v_a_1346_);
if (v_isSharedCheck_1390_ == 0)
{
v___x_1363_ = v_a_1346_;
v_isShared_1364_ = v_isSharedCheck_1390_;
goto v_resetjp_1362_;
}
else
{
lean_inc(v_a_1361_);
lean_dec(v_a_1346_);
v___x_1363_ = lean_box(0);
v_isShared_1364_ = v_isSharedCheck_1390_;
goto v_resetjp_1362_;
}
v_resetjp_1362_:
{
lean_object* v_proof_1365_; lean_object* v_cert_1366_; lean_object* v_proveFalse_1367_; lean_object* v___x_1368_; 
v_proof_1365_ = lean_ctor_get(v_a_1361_, 0);
lean_inc_ref(v_proof_1365_);
v_cert_1366_ = lean_ctor_get(v_a_1361_, 1);
lean_inc(v_cert_1366_);
lean_dec(v_a_1361_);
v_proveFalse_1367_ = lean_ctor_get(v___y_1337_, 1);
lean_inc_ref(v_proveFalse_1367_);
lean_dec_ref(v___y_1337_);
lean_inc(v___y_1334_);
lean_inc_ref(v___y_1331_);
lean_inc(v___y_1339_);
lean_inc_ref(v___y_1335_);
lean_inc(v___y_1338_);
lean_inc_ref(v___y_1332_);
lean_inc(v___y_1336_);
lean_inc_ref(v___y_1333_);
v___x_1368_ = lean_apply_10(v_proveFalse_1367_, v_proof_1365_, v___y_1333_, v___y_1336_, v___y_1332_, v___y_1338_, v___y_1335_, v___y_1339_, v___y_1331_, v___y_1334_, lean_box(0));
if (lean_obj_tag(v___x_1368_) == 0)
{
lean_object* v_a_1369_; lean_object* v___x_1370_; lean_object* v___x_1372_; uint8_t v_isShared_1373_; uint8_t v_isSharedCheck_1380_; 
v_a_1369_ = lean_ctor_get(v___x_1368_, 0);
lean_inc(v_a_1369_);
lean_dec_ref_known(v___x_1368_, 1);
v___x_1370_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2___redArg(v_g_1316_, v_a_1369_, v___y_1339_);
v_isSharedCheck_1380_ = !lean_is_exclusive(v___x_1370_);
if (v_isSharedCheck_1380_ == 0)
{
lean_object* v_unused_1381_; 
v_unused_1381_ = lean_ctor_get(v___x_1370_, 0);
lean_dec(v_unused_1381_);
v___x_1372_ = v___x_1370_;
v_isShared_1373_ = v_isSharedCheck_1380_;
goto v_resetjp_1371_;
}
else
{
lean_dec(v___x_1370_);
v___x_1372_ = lean_box(0);
v_isShared_1373_ = v_isSharedCheck_1380_;
goto v_resetjp_1371_;
}
v_resetjp_1371_:
{
lean_object* v___x_1375_; 
if (v_isShared_1364_ == 0)
{
lean_ctor_set(v___x_1363_, 0, v_cert_1366_);
v___x_1375_ = v___x_1363_;
goto v_reusejp_1374_;
}
else
{
lean_object* v_reuseFailAlloc_1379_; 
v_reuseFailAlloc_1379_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1379_, 0, v_cert_1366_);
v___x_1375_ = v_reuseFailAlloc_1379_;
goto v_reusejp_1374_;
}
v_reusejp_1374_:
{
lean_object* v___x_1377_; 
if (v_isShared_1373_ == 0)
{
lean_ctor_set(v___x_1372_, 0, v___x_1375_);
v___x_1377_ = v___x_1372_;
goto v_reusejp_1376_;
}
else
{
lean_object* v_reuseFailAlloc_1378_; 
v_reuseFailAlloc_1378_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1378_, 0, v___x_1375_);
v___x_1377_ = v_reuseFailAlloc_1378_;
goto v_reusejp_1376_;
}
v_reusejp_1376_:
{
return v___x_1377_;
}
}
}
}
else
{
lean_object* v_a_1382_; lean_object* v___x_1384_; uint8_t v_isShared_1385_; uint8_t v_isSharedCheck_1389_; 
lean_dec(v_cert_1366_);
lean_del_object(v___x_1363_);
lean_dec(v_g_1316_);
v_a_1382_ = lean_ctor_get(v___x_1368_, 0);
v_isSharedCheck_1389_ = !lean_is_exclusive(v___x_1368_);
if (v_isSharedCheck_1389_ == 0)
{
v___x_1384_ = v___x_1368_;
v_isShared_1385_ = v_isSharedCheck_1389_;
goto v_resetjp_1383_;
}
else
{
lean_inc(v_a_1382_);
lean_dec(v___x_1368_);
v___x_1384_ = lean_box(0);
v_isShared_1385_ = v_isSharedCheck_1389_;
goto v_resetjp_1383_;
}
v_resetjp_1383_:
{
lean_object* v___x_1387_; 
if (v_isShared_1385_ == 0)
{
v___x_1387_ = v___x_1384_;
goto v_reusejp_1386_;
}
else
{
lean_object* v_reuseFailAlloc_1388_; 
v_reuseFailAlloc_1388_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1388_, 0, v_a_1382_);
v___x_1387_ = v_reuseFailAlloc_1388_;
goto v_reusejp_1386_;
}
v_reusejp_1386_:
{
return v___x_1387_;
}
}
}
}
}
}
}
else
{
lean_object* v_a_1392_; lean_object* v___x_1394_; uint8_t v_isShared_1395_; uint8_t v_isSharedCheck_1399_; 
lean_dec_ref(v___y_1337_);
lean_dec(v_g_1316_);
v_a_1392_ = lean_ctor_get(v___x_1345_, 0);
v_isSharedCheck_1399_ = !lean_is_exclusive(v___x_1345_);
if (v_isSharedCheck_1399_ == 0)
{
v___x_1394_ = v___x_1345_;
v_isShared_1395_ = v_isSharedCheck_1399_;
goto v_resetjp_1393_;
}
else
{
lean_inc(v_a_1392_);
lean_dec(v___x_1345_);
v___x_1394_ = lean_box(0);
v_isShared_1395_ = v_isSharedCheck_1399_;
goto v_resetjp_1393_;
}
v_resetjp_1393_:
{
lean_object* v___x_1397_; 
if (v_isShared_1395_ == 0)
{
v___x_1397_ = v___x_1394_;
goto v_reusejp_1396_;
}
else
{
lean_object* v_reuseFailAlloc_1398_; 
v_reuseFailAlloc_1398_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1398_, 0, v_a_1392_);
v___x_1397_ = v_reuseFailAlloc_1398_;
goto v_reusejp_1396_;
}
v_reusejp_1396_:
{
return v___x_1397_;
}
}
}
}
v___jp_1400_:
{
lean_object* v___x_1410_; lean_object* v_atoms_1411_; lean_object* v_buckets_1412_; lean_object* v___x_1413_; lean_object* v___x_1414_; lean_object* v___x_1415_; uint8_t v___x_1416_; 
v___x_1410_ = lean_st_ref_get(v___y_1403_);
v_atoms_1411_ = lean_ctor_get(v___x_1410_, 0);
lean_inc_ref(v_atoms_1411_);
lean_dec(v___x_1410_);
v_buckets_1412_ = lean_ctor_get(v_atoms_1411_, 1);
lean_inc_ref(v_buckets_1412_);
lean_dec_ref(v_atoms_1411_);
v___x_1413_ = lean_box(0);
v___x_1414_ = lean_array_get_size(v_buckets_1412_);
v___x_1415_ = lean_unsigned_to_nat(0u);
v___x_1416_ = lean_nat_dec_lt(v___x_1415_, v___x_1414_);
if (v___x_1416_ == 0)
{
lean_dec_ref(v_buckets_1412_);
v___y_1331_ = v___y_1408_;
v___y_1332_ = v___y_1404_;
v___y_1333_ = v___y_1402_;
v___y_1334_ = v___y_1409_;
v___y_1335_ = v___y_1406_;
v___y_1336_ = v___y_1403_;
v___y_1337_ = v___y_1401_;
v___y_1338_ = v___y_1405_;
v___y_1339_ = v___y_1407_;
v___y_1340_ = v___x_1413_;
goto v___jp_1330_;
}
else
{
size_t v___x_1417_; size_t v___x_1418_; lean_object* v___x_1419_; 
v___x_1417_ = lean_usize_of_nat(v___x_1414_);
v___x_1418_ = ((size_t)0ULL);
v___x_1419_ = l___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__4(v_buckets_1412_, v___x_1417_, v___x_1418_, v___x_1413_);
lean_dec_ref(v_buckets_1412_);
v___y_1331_ = v___y_1408_;
v___y_1332_ = v___y_1404_;
v___y_1333_ = v___y_1402_;
v___y_1334_ = v___y_1409_;
v___y_1335_ = v___y_1406_;
v___y_1336_ = v___y_1403_;
v___y_1337_ = v___y_1401_;
v___y_1338_ = v___y_1405_;
v___y_1339_ = v___y_1407_;
v___y_1340_ = v___x_1419_;
goto v___jp_1330_;
}
}
v___jp_1423_:
{
if (lean_obj_tag(v___y_1424_) == 0)
{
if (v_hasTrace_1422_ == 0)
{
lean_object* v_a_1425_; 
lean_dec(v_cls_1317_);
v_a_1425_ = lean_ctor_get(v___y_1424_, 0);
lean_inc(v_a_1425_);
lean_dec_ref_known(v___y_1424_, 1);
v___y_1401_ = v_a_1425_;
v___y_1402_ = v___y_1321_;
v___y_1403_ = v___y_1322_;
v___y_1404_ = v___y_1323_;
v___y_1405_ = v___y_1324_;
v___y_1406_ = v___y_1325_;
v___y_1407_ = v___y_1326_;
v___y_1408_ = v___y_1327_;
v___y_1409_ = v___y_1328_;
goto v___jp_1400_;
}
else
{
lean_object* v_a_1426_; lean_object* v___x_1427_; lean_object* v___x_1428_; uint8_t v___x_1429_; 
v_a_1426_ = lean_ctor_get(v___y_1424_, 0);
lean_inc(v_a_1426_);
lean_dec_ref_known(v___y_1424_, 1);
v___x_1427_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__3));
lean_inc(v_cls_1317_);
v___x_1428_ = l_Lean_Name_append(v___x_1427_, v_cls_1317_);
v___x_1429_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_1421_, v_options_1420_, v___x_1428_);
lean_dec(v___x_1428_);
if (v___x_1429_ == 0)
{
lean_dec(v_cls_1317_);
v___y_1401_ = v_a_1426_;
v___y_1402_ = v___y_1321_;
v___y_1403_ = v___y_1322_;
v___y_1404_ = v___y_1323_;
v___y_1405_ = v___y_1324_;
v___y_1406_ = v___y_1325_;
v___y_1407_ = v___y_1326_;
v___y_1408_ = v___y_1327_;
v___y_1409_ = v___y_1328_;
goto v___jp_1400_;
}
else
{
lean_object* v_bvExpr_1430_; lean_object* v___x_1431_; lean_object* v___x_1432_; lean_object* v___x_1433_; lean_object* v___x_1434_; lean_object* v___x_1435_; lean_object* v___x_1436_; 
v_bvExpr_1430_ = lean_ctor_get(v_a_1426_, 0);
v___x_1431_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__5, &l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__5_once, _init_l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___closed__5);
lean_inc_ref(v_bvExpr_1430_);
v___x_1432_ = l_Std_Tactic_BVDecide_BoolExpr_toString___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__5(v_bvExpr_1430_);
v___x_1433_ = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(v___x_1433_, 0, v___x_1432_);
v___x_1434_ = l_Lean_MessageData_ofFormat(v___x_1433_);
v___x_1435_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_1435_, 0, v___x_1431_);
lean_ctor_set(v___x_1435_, 1, v___x_1434_);
v___x_1436_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg(v_cls_1317_, v___x_1435_, v___y_1325_, v___y_1326_, v___y_1327_, v___y_1328_);
if (lean_obj_tag(v___x_1436_) == 0)
{
lean_dec_ref_known(v___x_1436_, 1);
v___y_1401_ = v_a_1426_;
v___y_1402_ = v___y_1321_;
v___y_1403_ = v___y_1322_;
v___y_1404_ = v___y_1323_;
v___y_1405_ = v___y_1324_;
v___y_1406_ = v___y_1325_;
v___y_1407_ = v___y_1326_;
v___y_1408_ = v___y_1327_;
v___y_1409_ = v___y_1328_;
goto v___jp_1400_;
}
else
{
lean_object* v_a_1437_; lean_object* v___x_1439_; uint8_t v_isShared_1440_; uint8_t v_isSharedCheck_1444_; 
lean_dec(v_a_1426_);
lean_dec(v_g_1316_);
lean_dec_ref(v_unsatProver_1315_);
v_a_1437_ = lean_ctor_get(v___x_1436_, 0);
v_isSharedCheck_1444_ = !lean_is_exclusive(v___x_1436_);
if (v_isSharedCheck_1444_ == 0)
{
v___x_1439_ = v___x_1436_;
v_isShared_1440_ = v_isSharedCheck_1444_;
goto v_resetjp_1438_;
}
else
{
lean_inc(v_a_1437_);
lean_dec(v___x_1436_);
v___x_1439_ = lean_box(0);
v_isShared_1440_ = v_isSharedCheck_1444_;
goto v_resetjp_1438_;
}
v_resetjp_1438_:
{
lean_object* v___x_1442_; 
if (v_isShared_1440_ == 0)
{
v___x_1442_ = v___x_1439_;
goto v_reusejp_1441_;
}
else
{
lean_object* v_reuseFailAlloc_1443_; 
v_reuseFailAlloc_1443_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1443_, 0, v_a_1437_);
v___x_1442_ = v_reuseFailAlloc_1443_;
goto v_reusejp_1441_;
}
v_reusejp_1441_:
{
return v___x_1442_;
}
}
}
}
}
}
else
{
lean_object* v_a_1445_; lean_object* v___x_1447_; uint8_t v_isShared_1448_; uint8_t v_isSharedCheck_1452_; 
lean_dec(v_cls_1317_);
lean_dec(v_g_1316_);
lean_dec_ref(v_unsatProver_1315_);
v_a_1445_ = lean_ctor_get(v___y_1424_, 0);
v_isSharedCheck_1452_ = !lean_is_exclusive(v___y_1424_);
if (v_isSharedCheck_1452_ == 0)
{
v___x_1447_ = v___y_1424_;
v_isShared_1448_ = v_isSharedCheck_1452_;
goto v_resetjp_1446_;
}
else
{
lean_inc(v_a_1445_);
lean_dec(v___y_1424_);
v___x_1447_ = lean_box(0);
v_isShared_1448_ = v_isSharedCheck_1452_;
goto v_resetjp_1446_;
}
v_resetjp_1446_:
{
lean_object* v___x_1450_; 
if (v_isShared_1448_ == 0)
{
v___x_1450_ = v___x_1447_;
goto v_reusejp_1449_;
}
else
{
lean_object* v_reuseFailAlloc_1451_; 
v_reuseFailAlloc_1451_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1451_, 0, v_a_1445_);
v___x_1450_ = v_reuseFailAlloc_1451_;
goto v_reusejp_1449_;
}
v_reusejp_1449_:
{
return v___x_1450_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___boxed(lean_object* v_unsatProver_1528_, lean_object* v_g_1529_, lean_object* v_cls_1530_, lean_object* v___x_1531_, lean_object* v___x_1532_, lean_object* v___f_1533_, lean_object* v___y_1534_, lean_object* v___y_1535_, lean_object* v___y_1536_, lean_object* v___y_1537_, lean_object* v___y_1538_, lean_object* v___y_1539_, lean_object* v___y_1540_, lean_object* v___y_1541_, lean_object* v___y_1542_){
_start:
{
uint8_t v___x_41453__boxed_1543_; lean_object* v_res_1544_; 
v___x_41453__boxed_1543_ = lean_unbox(v___x_1531_);
v_res_1544_ = l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1(v_unsatProver_1528_, v_g_1529_, v_cls_1530_, v___x_41453__boxed_1543_, v___x_1532_, v___f_1533_, v___y_1534_, v___y_1535_, v___y_1536_, v___y_1537_, v___y_1538_, v___y_1539_, v___y_1540_, v___y_1541_);
lean_dec(v___y_1541_);
lean_dec_ref(v___y_1540_);
lean_dec(v___y_1539_);
lean_dec_ref(v___y_1538_);
lean_dec(v___y_1537_);
lean_dec_ref(v___y_1536_);
lean_dec(v___y_1535_);
lean_dec_ref(v___y_1534_);
return v_res_1544_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg(lean_object* v_g_1553_, lean_object* v_unsatProver_1554_, lean_object* v_a_1555_, lean_object* v_a_1556_, lean_object* v_a_1557_, lean_object* v_a_1558_, lean_object* v_a_1559_, lean_object* v_a_1560_, lean_object* v_a_1561_, lean_object* v_a_1562_){
_start:
{
lean_object* v___f_1564_; lean_object* v_cls_1565_; uint8_t v___x_1566_; lean_object* v___x_1567_; lean_object* v___x_1568_; lean_object* v___f_1569_; lean_object* v___x_1570_; 
v___f_1564_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__0));
v_cls_1565_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___closed__4));
v___x_1566_ = 1;
v___x_1567_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg___closed__0));
v___x_1568_ = lean_box(v___x_1566_);
lean_inc(v_g_1553_);
v___f_1569_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___lam__1___boxed), 15, 6);
lean_closure_set(v___f_1569_, 0, v_unsatProver_1554_);
lean_closure_set(v___f_1569_, 1, v_g_1553_);
lean_closure_set(v___f_1569_, 2, v_cls_1565_);
lean_closure_set(v___f_1569_, 3, v___x_1568_);
lean_closure_set(v___f_1569_, 4, v___x_1567_);
lean_closure_set(v___f_1569_, 5, v___f_1564_);
v___x_1570_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_reflectBV_spec__3___redArg(v_g_1553_, v___f_1569_, v_a_1555_, v_a_1556_, v_a_1557_, v_a_1558_, v_a_1559_, v_a_1560_, v_a_1561_, v_a_1562_);
return v___x_1570_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg___boxed(lean_object* v_g_1571_, lean_object* v_unsatProver_1572_, lean_object* v_a_1573_, lean_object* v_a_1574_, lean_object* v_a_1575_, lean_object* v_a_1576_, lean_object* v_a_1577_, lean_object* v_a_1578_, lean_object* v_a_1579_, lean_object* v_a_1580_, lean_object* v_a_1581_){
_start:
{
lean_object* v_res_1582_; 
v_res_1582_ = l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg(v_g_1571_, v_unsatProver_1572_, v_a_1573_, v_a_1574_, v_a_1575_, v_a_1576_, v_a_1577_, v_a_1578_, v_a_1579_, v_a_1580_);
lean_dec(v_a_1580_);
lean_dec_ref(v_a_1579_);
lean_dec(v_a_1578_);
lean_dec_ref(v_a_1577_);
lean_dec(v_a_1576_);
lean_dec_ref(v_a_1575_);
lean_dec(v_a_1574_);
lean_dec_ref(v_a_1573_);
return v_res_1582_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection(lean_object* v_00_u03b1_1583_, lean_object* v_g_1584_, lean_object* v_unsatProver_1585_, lean_object* v_a_1586_, lean_object* v_a_1587_, lean_object* v_a_1588_, lean_object* v_a_1589_, lean_object* v_a_1590_, lean_object* v_a_1591_, lean_object* v_a_1592_, lean_object* v_a_1593_){
_start:
{
lean_object* v___x_1595_; 
v___x_1595_ = l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg(v_g_1584_, v_unsatProver_1585_, v_a_1586_, v_a_1587_, v_a_1588_, v_a_1589_, v_a_1590_, v_a_1591_, v_a_1592_, v_a_1593_);
return v___x_1595_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___boxed(lean_object* v_00_u03b1_1596_, lean_object* v_g_1597_, lean_object* v_unsatProver_1598_, lean_object* v_a_1599_, lean_object* v_a_1600_, lean_object* v_a_1601_, lean_object* v_a_1602_, lean_object* v_a_1603_, lean_object* v_a_1604_, lean_object* v_a_1605_, lean_object* v_a_1606_, lean_object* v_a_1607_){
_start:
{
lean_object* v_res_1608_; 
v_res_1608_ = l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection(v_00_u03b1_1596_, v_g_1597_, v_unsatProver_1598_, v_a_1599_, v_a_1600_, v_a_1601_, v_a_1602_, v_a_1603_, v_a_1604_, v_a_1605_, v_a_1606_);
lean_dec(v_a_1606_);
lean_dec_ref(v_a_1605_);
lean_dec(v_a_1604_);
lean_dec_ref(v_a_1603_);
lean_dec(v_a_1602_);
lean_dec_ref(v_a_1601_);
lean_dec(v_a_1600_);
lean_dec_ref(v_a_1599_);
return v_res_1608_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2(lean_object* v_mvarId_1609_, lean_object* v_val_1610_, lean_object* v___y_1611_, lean_object* v___y_1612_, lean_object* v___y_1613_, lean_object* v___y_1614_, lean_object* v___y_1615_, lean_object* v___y_1616_, lean_object* v___y_1617_, lean_object* v___y_1618_){
_start:
{
lean_object* v___x_1620_; 
v___x_1620_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2___redArg(v_mvarId_1609_, v_val_1610_, v___y_1616_);
return v___x_1620_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2___boxed(lean_object* v_mvarId_1621_, lean_object* v_val_1622_, lean_object* v___y_1623_, lean_object* v___y_1624_, lean_object* v___y_1625_, lean_object* v___y_1626_, lean_object* v___y_1627_, lean_object* v___y_1628_, lean_object* v___y_1629_, lean_object* v___y_1630_, lean_object* v___y_1631_){
_start:
{
lean_object* v_res_1632_; 
v_res_1632_ = l_Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2(v_mvarId_1621_, v_val_1622_, v___y_1623_, v___y_1624_, v___y_1625_, v___y_1626_, v___y_1627_, v___y_1628_, v___y_1629_, v___y_1630_);
lean_dec(v___y_1630_);
lean_dec_ref(v___y_1629_);
lean_dec(v___y_1628_);
lean_dec_ref(v___y_1627_);
lean_dec(v___y_1626_);
lean_dec_ref(v___y_1625_);
lean_dec(v___y_1624_);
lean_dec_ref(v___y_1623_);
return v_res_1632_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6(lean_object* v_cls_1633_, lean_object* v_msg_1634_, lean_object* v___y_1635_, lean_object* v___y_1636_, lean_object* v___y_1637_, lean_object* v___y_1638_, lean_object* v___y_1639_, lean_object* v___y_1640_, lean_object* v___y_1641_, lean_object* v___y_1642_){
_start:
{
lean_object* v___x_1644_; 
v___x_1644_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___redArg(v_cls_1633_, v_msg_1634_, v___y_1639_, v___y_1640_, v___y_1641_, v___y_1642_);
return v___x_1644_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6___boxed(lean_object* v_cls_1645_, lean_object* v_msg_1646_, lean_object* v___y_1647_, lean_object* v___y_1648_, lean_object* v___y_1649_, lean_object* v___y_1650_, lean_object* v___y_1651_, lean_object* v___y_1652_, lean_object* v___y_1653_, lean_object* v___y_1654_, lean_object* v___y_1655_){
_start:
{
lean_object* v_res_1656_; 
v_res_1656_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__6(v_cls_1645_, v_msg_1646_, v___y_1647_, v___y_1648_, v___y_1649_, v___y_1650_, v___y_1651_, v___y_1652_, v___y_1653_, v___y_1654_);
lean_dec(v___y_1654_);
lean_dec_ref(v___y_1653_);
lean_dec(v___y_1652_);
lean_dec_ref(v___y_1651_);
lean_dec(v___y_1650_);
lean_dec_ref(v___y_1649_);
lean_dec(v___y_1648_);
lean_dec_ref(v___y_1647_);
return v_res_1656_;
}
}
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13(lean_object* v_00_u03b1_1657_, lean_object* v_x_1658_, lean_object* v___y_1659_, lean_object* v___y_1660_, lean_object* v___y_1661_, lean_object* v___y_1662_, lean_object* v___y_1663_, lean_object* v___y_1664_, lean_object* v___y_1665_, lean_object* v___y_1666_){
_start:
{
lean_object* v___x_1668_; 
v___x_1668_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___redArg(v_x_1658_);
return v___x_1668_;
}
}
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13___boxed(lean_object* v_00_u03b1_1669_, lean_object* v_x_1670_, lean_object* v___y_1671_, lean_object* v___y_1672_, lean_object* v___y_1673_, lean_object* v___y_1674_, lean_object* v___y_1675_, lean_object* v___y_1676_, lean_object* v___y_1677_, lean_object* v___y_1678_, lean_object* v___y_1679_){
_start:
{
lean_object* v_res_1680_; 
v_res_1680_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__13(v_00_u03b1_1669_, v_x_1670_, v___y_1671_, v___y_1672_, v___y_1673_, v___y_1674_, v___y_1675_, v___y_1676_, v___y_1677_, v___y_1678_);
lean_dec(v___y_1678_);
lean_dec_ref(v___y_1677_);
lean_dec(v___y_1676_);
lean_dec_ref(v___y_1675_);
lean_dec(v___y_1674_);
lean_dec_ref(v___y_1673_);
lean_dec(v___y_1672_);
lean_dec_ref(v___y_1671_);
return v_res_1680_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1(lean_object* v_00_u03b2_1681_, lean_object* v_m_1682_, lean_object* v_a_1683_, lean_object* v_b_1684_){
_start:
{
lean_object* v___x_1685_; 
v___x_1685_ = l_Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1___redArg(v_m_1682_, v_a_1683_, v_b_1684_);
return v___x_1685_;
}
}
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2(lean_object* v_as_1686_, lean_object* v_as_x27_1687_, lean_object* v_b_1688_, lean_object* v_a_1689_){
_start:
{
lean_object* v___x_1690_; 
v___x_1690_ = l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___redArg(v_as_x27_1687_, v_b_1688_);
return v___x_1690_;
}
}
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2___boxed(lean_object* v_as_1691_, lean_object* v_as_x27_1692_, lean_object* v_b_1693_, lean_object* v_a_1694_){
_start:
{
lean_object* v_res_1695_; 
v_res_1695_ = l_List_forIn_x27_loop___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__2(v_as_1691_, v_as_x27_1692_, v_b_1693_, v_a_1694_);
lean_dec(v_as_x27_1692_);
lean_dec(v_as_1691_);
return v_res_1695_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4(lean_object* v_00_u03b2_1696_, lean_object* v_x_1697_, lean_object* v_x_1698_, lean_object* v_x_1699_){
_start:
{
lean_object* v___x_1700_; 
v___x_1700_ = l_Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4___redArg(v_x_1697_, v_x_1698_, v_x_1699_);
return v___x_1700_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12(lean_object* v_oldTraces_1701_, lean_object* v_data_1702_, lean_object* v_ref_1703_, lean_object* v_msg_1704_, lean_object* v___y_1705_, lean_object* v___y_1706_, lean_object* v___y_1707_, lean_object* v___y_1708_, lean_object* v___y_1709_, lean_object* v___y_1710_, lean_object* v___y_1711_, lean_object* v___y_1712_){
_start:
{
lean_object* v___x_1714_; 
v___x_1714_ = l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12___redArg(v_oldTraces_1701_, v_data_1702_, v_ref_1703_, v_msg_1704_, v___y_1709_, v___y_1710_, v___y_1711_, v___y_1712_);
return v___x_1714_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12___boxed(lean_object* v_oldTraces_1715_, lean_object* v_data_1716_, lean_object* v_ref_1717_, lean_object* v_msg_1718_, lean_object* v___y_1719_, lean_object* v___y_1720_, lean_object* v___y_1721_, lean_object* v___y_1722_, lean_object* v___y_1723_, lean_object* v___y_1724_, lean_object* v___y_1725_, lean_object* v___y_1726_, lean_object* v___y_1727_){
_start:
{
lean_object* v_res_1728_; 
v_res_1728_ = l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__9_spec__12(v_oldTraces_1715_, v_data_1716_, v_ref_1717_, v_msg_1718_, v___y_1719_, v___y_1720_, v___y_1721_, v___y_1722_, v___y_1723_, v___y_1724_, v___y_1725_, v___y_1726_);
lean_dec(v___y_1726_);
lean_dec_ref(v___y_1725_);
lean_dec(v___y_1724_);
lean_dec_ref(v___y_1723_);
lean_dec(v___y_1722_);
lean_dec_ref(v___y_1721_);
lean_dec(v___y_1720_);
lean_dec_ref(v___y_1719_);
return v_res_1728_;
}
}
LEAN_EXPORT uint8_t l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4(lean_object* v_00_u03b2_1729_, lean_object* v_a_1730_, lean_object* v_x_1731_){
_start:
{
uint8_t v___x_1732_; 
v___x_1732_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4___redArg(v_a_1730_, v_x_1731_);
return v___x_1732_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4___boxed(lean_object* v_00_u03b2_1733_, lean_object* v_a_1734_, lean_object* v_x_1735_){
_start:
{
uint8_t v_res_1736_; lean_object* v_r_1737_; 
v_res_1736_ = l_Std_DHashMap_Internal_AssocList_contains___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__4(v_00_u03b2_1733_, v_a_1734_, v_x_1735_);
lean_dec(v_x_1735_);
lean_dec(v_a_1734_);
v_r_1737_ = lean_box(v_res_1736_);
return v_r_1737_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5(lean_object* v_00_u03b2_1738_, lean_object* v_data_1739_){
_start:
{
lean_object* v___x_1740_; 
v___x_1740_ = l_Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5___redArg(v_data_1739_);
return v___x_1740_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__6(lean_object* v_00_u03b2_1741_, lean_object* v_a_1742_, lean_object* v_b_1743_, lean_object* v_x_1744_){
_start:
{
lean_object* v___x_1745_; 
v___x_1745_ = l_Std_DHashMap_Internal_AssocList_replace___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__6___redArg(v_a_1742_, v_b_1743_, v_x_1744_);
return v___x_1745_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10(lean_object* v_00_u03b2_1746_, lean_object* v_x_1747_, size_t v_x_1748_, size_t v_x_1749_, lean_object* v_x_1750_, lean_object* v_x_1751_){
_start:
{
lean_object* v___x_1752_; 
v___x_1752_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___redArg(v_x_1747_, v_x_1748_, v_x_1749_, v_x_1750_, v_x_1751_);
return v___x_1752_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10___boxed(lean_object* v_00_u03b2_1753_, lean_object* v_x_1754_, lean_object* v_x_1755_, lean_object* v_x_1756_, lean_object* v_x_1757_, lean_object* v_x_1758_){
_start:
{
size_t v_x_42084__boxed_1759_; size_t v_x_42085__boxed_1760_; lean_object* v_res_1761_; 
v_x_42084__boxed_1759_ = lean_unbox_usize(v_x_1755_);
lean_dec(v_x_1755_);
v_x_42085__boxed_1760_ = lean_unbox_usize(v_x_1756_);
lean_dec(v_x_1756_);
v_res_1761_ = l_Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10(v_00_u03b2_1753_, v_x_1754_, v_x_42084__boxed_1759_, v_x_42085__boxed_1760_, v_x_1757_, v_x_1758_);
return v_res_1761_;
}
}
LEAN_EXPORT lean_object* l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15(lean_object* v_00_u03b2_1762_, lean_object* v_i_1763_, lean_object* v_source_1764_, lean_object* v_target_1765_){
_start:
{
lean_object* v___x_1766_; 
v___x_1766_ = l___private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15___redArg(v_i_1763_, v_source_1764_, v_target_1765_);
return v___x_1766_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20(lean_object* v_00_u03b2_1767_, lean_object* v_n_1768_, lean_object* v_k_1769_, lean_object* v_v_1770_){
_start:
{
lean_object* v___x_1771_; 
v___x_1771_ = l_Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20___redArg(v_n_1768_, v_k_1769_, v_v_1770_);
return v___x_1771_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21(lean_object* v_00_u03b2_1772_, size_t v_depth_1773_, lean_object* v_keys_1774_, lean_object* v_vals_1775_, lean_object* v_heq_1776_, lean_object* v_i_1777_, lean_object* v_entries_1778_){
_start:
{
lean_object* v___x_1779_; 
v___x_1779_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21___redArg(v_depth_1773_, v_keys_1774_, v_vals_1775_, v_i_1777_, v_entries_1778_);
return v___x_1779_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21___boxed(lean_object* v_00_u03b2_1780_, lean_object* v_depth_1781_, lean_object* v_keys_1782_, lean_object* v_vals_1783_, lean_object* v_heq_1784_, lean_object* v_i_1785_, lean_object* v_entries_1786_){
_start:
{
size_t v_depth_boxed_1787_; lean_object* v_res_1788_; 
v_depth_boxed_1787_ = lean_unbox_usize(v_depth_1781_);
lean_dec(v_depth_1781_);
v_res_1788_ = l___private_Lean_Data_PersistentHashMap_0__Lean_PersistentHashMap_insertAux_traverse___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__21(v_00_u03b2_1780_, v_depth_boxed_1787_, v_keys_1782_, v_vals_1783_, v_heq_1784_, v_i_1785_, v_entries_1786_);
lean_dec_ref(v_vals_1783_);
lean_dec_ref(v_keys_1782_);
return v_res_1788_;
}
}
LEAN_EXPORT lean_object* l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15_spec__19(lean_object* v_00_u03b2_1789_, lean_object* v_x_1790_, lean_object* v_x_1791_){
_start:
{
lean_object* v___x_1792_; 
v___x_1792_ = l_Std_DHashMap_Internal_AssocList_foldlM___at___00__private_Std_Data_DHashMap_Internal_Defs_0__Std_DHashMap_Internal_Raw_u2080_expand_go___at___00Std_DHashMap_Internal_Raw_u2080_expand___at___00Std_DHashMap_Internal_Raw_u2080_insert___at___00Std_DHashMap_Internal_Raw_u2080_Const_insertMany___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__1_spec__1_spec__5_spec__15_spec__19___redArg(v_x_1790_, v_x_1791_);
return v___x_1792_;
}
}
LEAN_EXPORT lean_object* l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20_spec__23(lean_object* v_00_u03b2_1793_, lean_object* v_x_1794_, lean_object* v_x_1795_, lean_object* v_x_1796_, lean_object* v_x_1797_){
_start:
{
lean_object* v___x_1798_; 
v___x_1798_ = l_Lean_PersistentHashMap_insertAtCollisionNodeAux___at___00Lean_PersistentHashMap_insertAtCollisionNode___at___00Lean_PersistentHashMap_insertAux___at___00Lean_PersistentHashMap_insert___at___00Lean_MVarId_assign___at___00Lean_Meta_Tactic_BVDecide_closeWithBVReflection_spec__2_spec__4_spec__10_spec__20_spec__23___redArg(v_x_1794_, v_x_1795_, v_x_1796_, v_x_1797_);
return v___x_1798_;
}
}
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Counterexample(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_LRAT_Cert(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_SymM(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Util(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Prover_Basic(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Counterexample(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_LRAT_Cert(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_SymM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Util(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Meta_Tactic_BVDecide_Prover_Basic(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Reflect(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Counterexample(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_BVDecide_LRAT_Cert(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_SymM(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Util(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Meta_Tactic_BVDecide_Prover_Basic(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Lean_Meta_Tactic_BVDecide_Reflect(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_BVDecide_Counterexample(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_BVDecide_LRAT_Cert(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_SymM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Util(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Prover_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Meta_Tactic_BVDecide_Prover_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Meta_Tactic_BVDecide_Prover_Basic(builtin);
}
#ifdef __cplusplus
}
#endif
