// Lean compiler output
// Module: Lean.Meta.Tactic.BVDecide.Normalize.Basic
// Imports: public import Lean.Meta.Tactic.BVDecide.Attr public import Std.Tactic.BVDecide.Syntax public import Lean.Meta.Sym.ExprPtr public import Lean.Meta.Sym.SymM public import Lean.Meta.Sym.Simp.SimpM public import Lean.Meta.Sym.AlphaShareBuilder import Lean.Meta.Sym.InferType import Lean.Meta.Sym.InstantiateMVarsS
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
lean_object* l_Std_DTreeMap_Internal_Impl_Const_get_x3f___at___00Lean_NameMap_find_x3f_spec__0___redArg(lean_object*, lean_object*);
lean_object* lean_st_ref_take(lean_object*);
lean_object* l_Lean_Name_beq___boxed(lean_object*, lean_object*);
lean_object* l_Lean_Name_hash___override___boxed(lean_object*);
lean_object* l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_st_ref_set(lean_object*, lean_object*);
uint8_t lean_name_eq(lean_object*, lean_object*);
uint8_t lean_expr_eqv(lean_object*, lean_object*);
lean_object* l_Lean_instBEqFVarId_beq___boxed(lean_object*, lean_object*);
lean_object* l_Lean_instHashableFVarId_hash___boxed(lean_object*);
lean_object* l_instMonadExceptOfEIO(lean_object*);
lean_object* l_Lean_instMonadAlwaysExceptStateRefT_x27___redArg(lean_object*);
lean_object* l_Lean_instMonadAlwaysExceptReaderT___redArg(lean_object*);
lean_object* l_Array_append___redArg(lean_object*, lean_object*);
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
lean_object* l_ReaderT_instMonadLift___lam__0___boxed(lean_object*, lean_object*, lean_object*);
lean_object* l_StateRefT_x27_lift___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
extern lean_object* l_Lean_Core_instMonadTraceCoreM;
lean_object* l_Lean_instMonadTraceOfMonadLift___redArg(lean_object*, lean_object*);
lean_object* lean_array_get_size(lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
lean_object* lean_st_ref_get(lean_object*);
lean_object* l_Lean_Meta_Sym_Internal_Sym_assertShared(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr3(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr1(lean_object*);
lean_object* l_Lean_Name_append(lean_object*, lean_object*);
uint8_t l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(lean_object*, lean_object*, lean_object*);
lean_object* l_ReaderT_instMonadFunctor___lam__0(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_StateRefT_x27_instMonadFunctor___aux__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
extern lean_object* l_Lean_Core_instMonadQuotationCoreM;
lean_object* l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(lean_object*, lean_object*, lean_object*);
extern lean_object* l_Lean_Meta_instAddMessageContextMetaM;
lean_object* l_Lean_instAddMessageContextOfMonadLift___redArg___lam__0(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_stringToMessageData(lean_object*);
lean_object* l_Lean_MessageData_ofExpr(lean_object*);
lean_object* l_Lean_addTrace___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_nat_dec_le(lean_object*, lean_object*);
size_t lean_usize_of_nat(lean_object*);
lean_object* l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, size_t, size_t, lean_object*);
lean_object* l_Lean_Meta_getPropHyps(lean_object*, lean_object*, lean_object*, lean_object*);
size_t lean_array_size(lean_object*);
uint8_t lean_usize_dec_lt(size_t, size_t);
lean_object* lean_array_uget(lean_object*, size_t);
lean_object* l_Lean_FVarId_getUserName___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_FVarId_getType___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_instantiateMVarsS(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_array_uset(lean_object*, size_t, lean_object*);
lean_object* l_Lean_mkFVar(lean_object*);
size_t lean_usize_add(size_t, size_t);
double lean_float_of_nat(lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* l_Lean_PersistentArray_push___redArg(lean_object*, lean_object*);
lean_object* l_Lean_MessageData_ofName(lean_object*);
lean_object* lean_io_mono_nanos_now();
double lean_float_div(double, double);
lean_object* l_Lean_replaceRef(lean_object*, lean_object*);
lean_object* l_Lean_PersistentArray_toArray___redArg(lean_object*);
lean_object* lean_array_uget_borrowed(lean_object*, size_t);
extern lean_object* l_Lean_trace_profiler;
lean_object* l_Lean_PersistentArray_append___redArg(lean_object*, lean_object*);
double lean_float_sub(double, double);
uint8_t lean_float_decLt(double, double);
extern lean_object* l_Lean_trace_profiler_useHeartbeats;
extern lean_object* l_Lean_trace_profiler_threshold;
lean_object* lean_io_get_num_heartbeats();
lean_object* l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_getLevel___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr2(lean_object*, lean_object*);
lean_object* l_Lean_mkConst(lean_object*, lean_object*);
lean_object* l_Lean_mkApp4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
lean_object* lean_nat_sub(lean_object*, lean_object*);
lean_object* lean_array_fget_borrowed(lean_object*, lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* l_Lean_Expr_const___override(lean_object*, lean_object*);
uint8_t l_Lean_Expr_isFalse(lean_object*);
lean_object* lean_array_push(lean_object*, lean_object*);
lean_object* l_Lean_MVarId_assign___redArg(lean_object*, lean_object*, lean_object*);
lean_object* l_WellFounded_opaqueFix_u2083___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_instExceptToTraceResultBool___lam__0___boxed(lean_object*);
lean_object* l_instMonadControlReaderT(lean_object*, lean_object*);
lean_object* l_instMonadControlStateRefT_x27(lean_object*, lean_object*, lean_object*);
lean_object* l_ReaderT_pure___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_instMonadControlTOfPure___redArg(lean_object*);
lean_object* l_instMonadControlTOfMonadControl___redArg___lam__3(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_instMonadControlTOfMonadControl___redArg___lam__4(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_MVarId_withContext___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_nat_mul(lean_object*, lean_object*);
lean_object* lean_nat_div(lean_object*, lean_object*);
lean_object* l_Nat_nextPowerOfTwo(lean_object*);
lean_object* lean_mk_array(lean_object*, lean_object*);
lean_object* lean_st_mk_ref(lean_object*);
lean_object* l_Lean_Core_checkSystem(lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_instBEqMVarId_beq(lean_object*, lean_object*);
uint8_t l_Std_DHashMap_Internal_Raw_u2080_contains___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
uint64_t lean_uint64_of_nat(lean_object*);
uint64_t lean_uint64_mix_hash(uint64_t, uint64_t);
uint64_t l_Lean_Expr_hash(lean_object*);
lean_object* l_Std_DHashMap_Internal_Raw_u2080_insert___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*);
lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces(lean_object*, lean_object*, lean_object*);
extern lean_object* l_Lean_KVMap_instValueBool;
lean_object* l_Lean_Option_get___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorIdx(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorIdx___boxed(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_simpleEnum_elim___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_simpleEnum_elim(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_enumWithDefault_elim___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_enumWithDefault_elim(lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 20, .m_capacity = 20, .m_length = 19, .m_data = "_inhabitedExprDummy"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__0_value),LEAN_SCALAR_PTR_LITERAL(37, 247, 56, 151, 29, 116, 116, 243)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__2;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__3;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static uint64_t l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash___closed__0;
LEAN_EXPORT uint64_t l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash___boxed(lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp___closed__0_value;
LEAN_EXPORT const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp___closed__0_value;
LEAN_EXPORT uint8_t l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq___boxed(lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp___closed__0_value;
LEAN_EXPORT const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "Eq"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "mp"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(143, 37, 101, 248, 9, 246, 191, 223)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__2_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(183, 66, 254, 161, 210, 133, 94, 78)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__2_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_instBEqFVarId_beq___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_instHashableFVarId_hash___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Name_beq___boxed, .m_arity = 2, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Name_hash___override___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*1 + 0, .m_other = 1, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1))}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__2_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__0;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Core_instMonadCoreM___lam__0___boxed, .m_arity = 5, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Core_instMonadCoreM___lam__1___boxed, .m_arity = 7, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_instMonadMetaM___lam__0___boxed, .m_arity = 7, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_instMonadMetaM___lam__1___boxed, .m_arity = 9, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___lam__0___boxed, .m_arity = 7, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__8_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__9;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__10_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__10;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11;
static const lean_array_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__12_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__12 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__12_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0___redArg(size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___lam__0___boxed, .m_arity = 9, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0(size_t, size_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_ReaderT_instMonadLift___lam__0___boxed, .m_arity = 3, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*3, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_StateRefT_x27_lift___boxed, .m_arity = 6, .m_num_fixed = 3, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)(((size_t)(0) << 1) | 1))} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__2;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__3;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__4;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__5;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__6;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Meta"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__8_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__9_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__9 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__9_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "bv"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__10 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__10_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__8_value),LEAN_SCALAR_PTR_LITERAL(211, 174, 49, 251, 64, 24, 251, 1)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__9_value),LEAN_SCALAR_PTR_LITERAL(194, 95, 140, 15, 16, 100, 236, 219)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__10_value),LEAN_SCALAR_PTR_LITERAL(139, 41, 106, 94, 234, 34, 111, 146)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__12_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trace"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__12 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__12_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__13_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__12_value),LEAN_SCALAR_PTR_LITERAL(212, 145, 141, 177, 67, 149, 127, 197)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__13 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__13_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__15_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_ReaderT_instMonadFunctor___lam__0, .m_arity = 4, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__15 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__15_value;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__16_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*3, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_StateRefT_x27_instMonadFunctor___aux__1___boxed, .m_arity = 7, .m_num_fixed = 3, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)(((size_t)(0) << 1) | 1))} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__16 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__16_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__17_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__17;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__18_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__18;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__19_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__19;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__20_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__20;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__21_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__21;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__22_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__22;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__23_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__23;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__24_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__24;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__25_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__25;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__26_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__26;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__27_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 21, .m_capacity = 21, .m_length = 20, .m_data = "Learned hypothesis: "};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__27 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__27_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__28_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__28;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps___lam__0___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___redArg(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__3(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "  ==>  "};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__0_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, uint8_t);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__11(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__7(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__10(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__12(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, uint8_t);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__12___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__13(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__8(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__8___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__9(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_array_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__14___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__14___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__14___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__14(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__15(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__2___boxed, .m_arity = 9, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__3(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__4(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__5(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__9(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, uint8_t);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__9___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__6(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__8(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__8___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__7(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__10(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, uint8_t);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__10___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__11(uint8_t, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__11___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__12(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__13(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__14(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__14___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__15(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__17(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__0___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg___lam__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg___lam__1(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 15, .m_capacity = 15, .m_length = 14, .m_data = "Running pass: "};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__0_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__1;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__0;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__1;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__2;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__3;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__4;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__5;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__6;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__7_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__7;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__8_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__8;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__9_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_instExceptToTraceResultBool___lam__0___boxed, .m_arity = 1, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__9 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__9_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 1, .m_capacity = 1, .m_length = 0, .m_data = ""};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__10 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__10_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__11_once = LEAN_ONCE_CELL_INITIALIZER;
static double l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__11;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__0;
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__1;
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg(lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__2(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__2___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4_spec__5(size_t, size_t, lean_object*);
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4_spec__5___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__6(lean_object*);
LEAN_EXPORT lean_object* l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__6___boxed(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__7(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__7___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___redArg(lean_object*);
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___redArg___boxed(lean_object*, lean_object*);
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static double l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__0;
static const lean_string_object l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 54, .m_capacity = 54, .m_length = 53, .m_data = "<exception thrown while producing trace node message>"};
static const lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__1 = (const lean_object*)&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__1_value;
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__2;
static lean_once_cell_t l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static double l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__3;
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3(lean_object*, uint8_t, lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___boxed(lean_object**);
static const lean_array_object l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_array_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 246}, .m_size = 0, .m_capacity = 0, .m_data = {}};
static const lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg___closed__0 = (const lean_object*)&l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_ctor_object l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 0, .m_other = 2, .m_tag = 0}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)(((size_t)(0) << 1) | 1))}};
static const lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__0 = (const lean_object*)&l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__0_value;
static const lean_string_object l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 35, .m_capacity = 35, .m_length = 34, .m_data = "Fixpoint iteration solved the goal"};
static const lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__1 = (const lean_object*)&l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__1_value;
static lean_once_cell_t l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__2;
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "bv_decide"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 28, .m_capacity = 28, .m_length = 27, .m_data = "Pipeline reached a fixpoint"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__2;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 19, .m_capacity = 19, .m_length = 18, .m_data = "Rerunning pipeline"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__3_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__4;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorIdx(lean_object* v_x_1_){
_start:
{
if (lean_obj_tag(v_x_1_) == 0)
{
lean_object* v___x_2_; 
v___x_2_ = lean_unsigned_to_nat(0u);
return v___x_2_;
}
else
{
lean_object* v___x_3_; 
v___x_3_ = lean_unsigned_to_nat(1u);
return v___x_3_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorIdx___boxed(lean_object* v_x_4_){
_start:
{
lean_object* v_res_5_; 
v_res_5_ = l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorIdx(v_x_4_);
lean_dec_ref(v_x_4_);
return v_res_5_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim___redArg(lean_object* v_t_6_, lean_object* v_k_7_){
_start:
{
lean_object* v_info_8_; lean_object* v_ctors_9_; lean_object* v___x_10_; 
v_info_8_ = lean_ctor_get(v_t_6_, 0);
lean_inc_ref(v_info_8_);
v_ctors_9_ = lean_ctor_get(v_t_6_, 1);
lean_inc_ref(v_ctors_9_);
lean_dec_ref(v_t_6_);
v___x_10_ = lean_apply_2(v_k_7_, v_info_8_, v_ctors_9_);
return v___x_10_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim(lean_object* v_motive_11_, lean_object* v_ctorIdx_12_, lean_object* v_t_13_, lean_object* v_h_14_, lean_object* v_k_15_){
_start:
{
lean_object* v___x_16_; 
v___x_16_ = l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim___redArg(v_t_13_, v_k_15_);
return v___x_16_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim___boxed(lean_object* v_motive_17_, lean_object* v_ctorIdx_18_, lean_object* v_t_19_, lean_object* v_h_20_, lean_object* v_k_21_){
_start:
{
lean_object* v_res_22_; 
v_res_22_ = l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim(v_motive_17_, v_ctorIdx_18_, v_t_19_, v_h_20_, v_k_21_);
lean_dec(v_ctorIdx_18_);
return v_res_22_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_simpleEnum_elim___redArg(lean_object* v_t_23_, lean_object* v_simpleEnum_24_){
_start:
{
lean_object* v___x_25_; 
v___x_25_ = l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim___redArg(v_t_23_, v_simpleEnum_24_);
return v___x_25_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_simpleEnum_elim(lean_object* v_motive_26_, lean_object* v_t_27_, lean_object* v_h_28_, lean_object* v_simpleEnum_29_){
_start:
{
lean_object* v___x_30_; 
v___x_30_ = l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim___redArg(v_t_27_, v_simpleEnum_29_);
return v___x_30_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_enumWithDefault_elim___redArg(lean_object* v_t_31_, lean_object* v_enumWithDefault_32_){
_start:
{
lean_object* v___x_33_; 
v___x_33_ = l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim___redArg(v_t_31_, v_enumWithDefault_32_);
return v___x_33_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_enumWithDefault_elim(lean_object* v_motive_34_, lean_object* v_t_35_, lean_object* v_h_36_, lean_object* v_enumWithDefault_37_){
_start:
{
lean_object* v___x_38_; 
v___x_38_ = l_Lean_Meta_Tactic_BVDecide_Normalize_MatchKind_ctorElim___redArg(v_t_35_, v_enumWithDefault_37_);
return v___x_38_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__2(void){
_start:
{
lean_object* v___x_42_; lean_object* v___x_43_; lean_object* v___x_44_; 
v___x_42_ = lean_box(0);
v___x_43_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__1));
v___x_44_ = l_Lean_Expr_const___override(v___x_43_, v___x_42_);
return v___x_44_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__3(void){
_start:
{
lean_object* v___x_45_; lean_object* v___x_46_; lean_object* v___x_47_; 
v___x_45_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__2, &l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__2);
v___x_46_ = lean_box(0);
v___x_47_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v___x_47_, 0, v___x_46_);
lean_ctor_set(v___x_47_, 1, v___x_45_);
lean_ctor_set(v___x_47_, 2, v___x_45_);
return v___x_47_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default(void){
_start:
{
lean_object* v___x_48_; 
v___x_48_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__3, &l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default___closed__3);
return v___x_48_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp(void){
_start:
{
lean_object* v___x_49_; 
v___x_49_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default;
return v___x_49_;
}
}
static uint64_t _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash___closed__0(void){
_start:
{
lean_object* v___x_50_; uint64_t v___x_51_; 
v___x_50_ = lean_unsigned_to_nat(1723u);
v___x_51_ = lean_uint64_of_nat(v___x_50_);
return v___x_51_;
}
}
LEAN_EXPORT uint64_t l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash(lean_object* v_x_52_){
_start:
{
lean_object* v_name_53_; lean_object* v_type_54_; lean_object* v_value_55_; uint64_t v___x_56_; uint64_t v___y_58_; 
v_name_53_ = lean_ctor_get(v_x_52_, 0);
v_type_54_ = lean_ctor_get(v_x_52_, 1);
v_value_55_ = lean_ctor_get(v_x_52_, 2);
v___x_56_ = 0ULL;
if (lean_obj_tag(v_name_53_) == 0)
{
uint64_t v___x_64_; 
v___x_64_ = lean_uint64_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash___closed__0, &l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash___closed__0_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash___closed__0);
v___y_58_ = v___x_64_;
goto v___jp_57_;
}
else
{
uint64_t v_hash_65_; 
v_hash_65_ = lean_ctor_get_uint64(v_name_53_, sizeof(void*)*2);
v___y_58_ = v_hash_65_;
goto v___jp_57_;
}
v___jp_57_:
{
uint64_t v___x_59_; uint64_t v___x_60_; uint64_t v___x_61_; uint64_t v___x_62_; uint64_t v___x_63_; 
v___x_59_ = lean_uint64_mix_hash(v___x_56_, v___y_58_);
v___x_60_ = l_Lean_Expr_hash(v_type_54_);
v___x_61_ = lean_uint64_mix_hash(v___x_59_, v___x_60_);
v___x_62_ = l_Lean_Expr_hash(v_value_55_);
v___x_63_ = lean_uint64_mix_hash(v___x_61_, v___x_62_);
return v___x_63_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash___boxed(lean_object* v_x_66_){
_start:
{
uint64_t v_res_67_; lean_object* v_r_68_; 
v_res_67_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instHashableHyp_hash(v_x_66_);
lean_dec_ref(v_x_66_);
v_r_68_ = lean_box_uint64(v_res_67_);
return v_r_68_;
}
}
LEAN_EXPORT uint8_t l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(lean_object* v_x_71_, lean_object* v_x_72_){
_start:
{
lean_object* v_name_73_; lean_object* v_type_74_; lean_object* v_value_75_; lean_object* v_name_76_; lean_object* v_type_77_; lean_object* v_value_78_; uint8_t v___x_79_; 
v_name_73_ = lean_ctor_get(v_x_71_, 0);
v_type_74_ = lean_ctor_get(v_x_71_, 1);
v_value_75_ = lean_ctor_get(v_x_71_, 2);
v_name_76_ = lean_ctor_get(v_x_72_, 0);
v_type_77_ = lean_ctor_get(v_x_72_, 1);
v_value_78_ = lean_ctor_get(v_x_72_, 2);
v___x_79_ = lean_name_eq(v_name_73_, v_name_76_);
if (v___x_79_ == 0)
{
return v___x_79_;
}
else
{
uint8_t v___x_80_; 
v___x_80_ = lean_expr_eqv(v_type_74_, v_type_77_);
if (v___x_80_ == 0)
{
return v___x_80_;
}
else
{
uint8_t v___x_81_; 
v___x_81_ = lean_expr_eqv(v_value_75_, v_value_78_);
return v___x_81_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq___boxed(lean_object* v_x_82_, lean_object* v_x_83_){
_start:
{
uint8_t v_res_84_; lean_object* v_r_85_; 
v_res_84_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(v_x_82_, v_x_83_);
lean_dec_ref(v_x_83_);
lean_dec_ref(v_x_82_);
v_r_85_ = lean_box(v_res_84_);
return v_r_85_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(lean_object* v_hyp_93_, lean_object* v_result_94_, lean_object* v_a_95_, lean_object* v_a_96_, lean_object* v_a_97_, lean_object* v_a_98_, lean_object* v_a_99_){
_start:
{
if (lean_obj_tag(v_result_94_) == 0)
{
lean_object* v___x_101_; 
lean_dec_ref_known(v_result_94_, 0);
v___x_101_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_101_, 0, v_hyp_93_);
return v___x_101_;
}
else
{
lean_object* v_e_x27_102_; lean_object* v_proof_103_; lean_object* v_name_104_; lean_object* v_type_105_; lean_object* v_value_106_; lean_object* v___x_108_; uint8_t v_isShared_109_; uint8_t v_isSharedCheck_135_; 
v_e_x27_102_ = lean_ctor_get(v_result_94_, 0);
lean_inc_ref(v_e_x27_102_);
v_proof_103_ = lean_ctor_get(v_result_94_, 1);
lean_inc_ref(v_proof_103_);
lean_dec_ref_known(v_result_94_, 2);
v_name_104_ = lean_ctor_get(v_hyp_93_, 0);
v_type_105_ = lean_ctor_get(v_hyp_93_, 1);
v_value_106_ = lean_ctor_get(v_hyp_93_, 2);
v_isSharedCheck_135_ = !lean_is_exclusive(v_hyp_93_);
if (v_isSharedCheck_135_ == 0)
{
v___x_108_ = v_hyp_93_;
v_isShared_109_ = v_isSharedCheck_135_;
goto v_resetjp_107_;
}
else
{
lean_inc(v_value_106_);
lean_inc(v_type_105_);
lean_inc(v_name_104_);
lean_dec(v_hyp_93_);
v___x_108_ = lean_box(0);
v_isShared_109_ = v_isSharedCheck_135_;
goto v_resetjp_107_;
}
v_resetjp_107_:
{
lean_object* v___x_110_; 
lean_inc_ref(v_type_105_);
v___x_110_ = l_Lean_Meta_Sym_getLevel___redArg(v_type_105_, v_a_95_, v_a_96_, v_a_97_, v_a_98_, v_a_99_);
if (lean_obj_tag(v___x_110_) == 0)
{
lean_object* v_a_111_; lean_object* v___x_113_; uint8_t v_isShared_114_; uint8_t v_isSharedCheck_126_; 
v_a_111_ = lean_ctor_get(v___x_110_, 0);
v_isSharedCheck_126_ = !lean_is_exclusive(v___x_110_);
if (v_isSharedCheck_126_ == 0)
{
v___x_113_ = v___x_110_;
v_isShared_114_ = v_isSharedCheck_126_;
goto v_resetjp_112_;
}
else
{
lean_inc(v_a_111_);
lean_dec(v___x_110_);
v___x_113_ = lean_box(0);
v_isShared_114_ = v_isSharedCheck_126_;
goto v_resetjp_112_;
}
v_resetjp_112_:
{
lean_object* v___x_115_; lean_object* v___x_116_; lean_object* v___x_117_; lean_object* v___x_118_; lean_object* v___x_119_; lean_object* v___x_121_; 
v___x_115_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___closed__2));
v___x_116_ = lean_box(0);
v___x_117_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v___x_117_, 0, v_a_111_);
lean_ctor_set(v___x_117_, 1, v___x_116_);
v___x_118_ = l_Lean_mkConst(v___x_115_, v___x_117_);
lean_inc_ref(v_e_x27_102_);
v___x_119_ = l_Lean_mkApp4(v___x_118_, v_type_105_, v_e_x27_102_, v_proof_103_, v_value_106_);
if (v_isShared_109_ == 0)
{
lean_ctor_set(v___x_108_, 2, v___x_119_);
lean_ctor_set(v___x_108_, 1, v_e_x27_102_);
v___x_121_ = v___x_108_;
goto v_reusejp_120_;
}
else
{
lean_object* v_reuseFailAlloc_125_; 
v_reuseFailAlloc_125_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v_reuseFailAlloc_125_, 0, v_name_104_);
lean_ctor_set(v_reuseFailAlloc_125_, 1, v_e_x27_102_);
lean_ctor_set(v_reuseFailAlloc_125_, 2, v___x_119_);
v___x_121_ = v_reuseFailAlloc_125_;
goto v_reusejp_120_;
}
v_reusejp_120_:
{
lean_object* v___x_123_; 
if (v_isShared_114_ == 0)
{
lean_ctor_set(v___x_113_, 0, v___x_121_);
v___x_123_ = v___x_113_;
goto v_reusejp_122_;
}
else
{
lean_object* v_reuseFailAlloc_124_; 
v_reuseFailAlloc_124_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_124_, 0, v___x_121_);
v___x_123_ = v_reuseFailAlloc_124_;
goto v_reusejp_122_;
}
v_reusejp_122_:
{
return v___x_123_;
}
}
}
}
else
{
lean_object* v_a_127_; lean_object* v___x_129_; uint8_t v_isShared_130_; uint8_t v_isSharedCheck_134_; 
lean_del_object(v___x_108_);
lean_dec_ref(v_value_106_);
lean_dec_ref(v_type_105_);
lean_dec(v_name_104_);
lean_dec_ref(v_proof_103_);
lean_dec_ref(v_e_x27_102_);
v_a_127_ = lean_ctor_get(v___x_110_, 0);
v_isSharedCheck_134_ = !lean_is_exclusive(v___x_110_);
if (v_isSharedCheck_134_ == 0)
{
v___x_129_ = v___x_110_;
v_isShared_130_ = v_isSharedCheck_134_;
goto v_resetjp_128_;
}
else
{
lean_inc(v_a_127_);
lean_dec(v___x_110_);
v___x_129_ = lean_box(0);
v_isShared_130_ = v_isSharedCheck_134_;
goto v_resetjp_128_;
}
v_resetjp_128_:
{
lean_object* v___x_132_; 
if (v_isShared_130_ == 0)
{
v___x_132_ = v___x_129_;
goto v_reusejp_131_;
}
else
{
lean_object* v_reuseFailAlloc_133_; 
v_reuseFailAlloc_133_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_133_, 0, v_a_127_);
v___x_132_ = v_reuseFailAlloc_133_;
goto v_reusejp_131_;
}
v_reusejp_131_:
{
return v___x_132_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg___boxed(lean_object* v_hyp_136_, lean_object* v_result_137_, lean_object* v_a_138_, lean_object* v_a_139_, lean_object* v_a_140_, lean_object* v_a_141_, lean_object* v_a_142_, lean_object* v_a_143_){
_start:
{
lean_object* v_res_144_; 
v_res_144_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(v_hyp_136_, v_result_137_, v_a_138_, v_a_139_, v_a_140_, v_a_141_, v_a_142_);
lean_dec(v_a_142_);
lean_dec_ref(v_a_141_);
lean_dec(v_a_140_);
lean_dec_ref(v_a_139_);
lean_dec(v_a_138_);
return v_res_144_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult(lean_object* v_hyp_145_, lean_object* v_result_146_, lean_object* v_a_147_, lean_object* v_a_148_, lean_object* v_a_149_, lean_object* v_a_150_, lean_object* v_a_151_, lean_object* v_a_152_){
_start:
{
lean_object* v___x_154_; 
v___x_154_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___redArg(v_hyp_145_, v_result_146_, v_a_148_, v_a_149_, v_a_150_, v_a_151_, v_a_152_);
return v___x_154_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult___boxed(lean_object* v_hyp_155_, lean_object* v_result_156_, lean_object* v_a_157_, lean_object* v_a_158_, lean_object* v_a_159_, lean_object* v_a_160_, lean_object* v_a_161_, lean_object* v_a_162_, lean_object* v_a_163_){
_start:
{
lean_object* v_res_164_; 
v_res_164_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Hyp_applySimpResult(v_hyp_155_, v_result_156_, v_a_157_, v_a_158_, v_a_159_, v_a_160_, v_a_161_, v_a_162_);
lean_dec(v_a_162_);
lean_dec_ref(v_a_161_);
lean_dec(v_a_160_);
lean_dec_ref(v_a_159_);
lean_dec(v_a_158_);
lean_dec_ref(v_a_157_);
return v_res_164_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig___redArg(lean_object* v_a_165_){
_start:
{
lean_object* v___x_167_; 
lean_inc_ref(v_a_165_);
v___x_167_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_167_, 0, v_a_165_);
return v___x_167_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig___redArg___boxed(lean_object* v_a_168_, lean_object* v_a_169_){
_start:
{
lean_object* v_res_170_; 
v_res_170_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig___redArg(v_a_168_);
lean_dec_ref(v_a_168_);
return v_res_170_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig(lean_object* v_a_171_, lean_object* v_a_172_, lean_object* v_a_173_, lean_object* v_a_174_, lean_object* v_a_175_, lean_object* v_a_176_, lean_object* v_a_177_, lean_object* v_a_178_){
_start:
{
lean_object* v___x_180_; 
lean_inc_ref(v_a_171_);
v___x_180_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_180_, 0, v_a_171_);
return v___x_180_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig___boxed(lean_object* v_a_181_, lean_object* v_a_182_, lean_object* v_a_183_, lean_object* v_a_184_, lean_object* v_a_185_, lean_object* v_a_186_, lean_object* v_a_187_, lean_object* v_a_188_, lean_object* v_a_189_){
_start:
{
lean_object* v_res_190_; 
v_res_190_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getConfig(v_a_181_, v_a_182_, v_a_183_, v_a_184_, v_a_185_, v_a_186_, v_a_187_, v_a_188_);
lean_dec(v_a_188_);
lean_dec_ref(v_a_187_);
lean_dec(v_a_186_);
lean_dec_ref(v_a_185_);
lean_dec(v_a_184_);
lean_dec_ref(v_a_183_);
lean_dec(v_a_182_);
lean_dec_ref(v_a_181_);
return v_res_190_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal___redArg(lean_object* v_a_191_){
_start:
{
lean_object* v___x_193_; lean_object* v_goal_194_; lean_object* v___x_195_; 
v___x_193_ = lean_st_ref_get(v_a_191_);
v_goal_194_ = lean_ctor_get(v___x_193_, 3);
lean_inc(v_goal_194_);
lean_dec(v___x_193_);
v___x_195_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_195_, 0, v_goal_194_);
return v___x_195_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal___redArg___boxed(lean_object* v_a_196_, lean_object* v_a_197_){
_start:
{
lean_object* v_res_198_; 
v_res_198_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal___redArg(v_a_196_);
lean_dec(v_a_196_);
return v_res_198_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal(lean_object* v_a_199_, lean_object* v_a_200_, lean_object* v_a_201_, lean_object* v_a_202_, lean_object* v_a_203_, lean_object* v_a_204_, lean_object* v_a_205_, lean_object* v_a_206_){
_start:
{
lean_object* v___x_208_; lean_object* v_goal_209_; lean_object* v___x_210_; 
v___x_208_ = lean_st_ref_get(v_a_200_);
v_goal_209_ = lean_ctor_get(v___x_208_, 3);
lean_inc(v_goal_209_);
lean_dec(v___x_208_);
v___x_210_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_210_, 0, v_goal_209_);
return v___x_210_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal___boxed(lean_object* v_a_211_, lean_object* v_a_212_, lean_object* v_a_213_, lean_object* v_a_214_, lean_object* v_a_215_, lean_object* v_a_216_, lean_object* v_a_217_, lean_object* v_a_218_, lean_object* v_a_219_){
_start:
{
lean_object* v_res_220_; 
v_res_220_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal(v_a_211_, v_a_212_, v_a_213_, v_a_214_, v_a_215_, v_a_216_, v_a_217_, v_a_218_);
lean_dec(v_a_218_);
lean_dec_ref(v_a_217_);
lean_dec(v_a_216_);
lean_dec_ref(v_a_215_);
lean_dec(v_a_214_);
lean_dec_ref(v_a_213_);
lean_dec(v_a_212_);
lean_dec_ref(v_a_211_);
return v_res_220_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal___redArg(lean_object* v_g_221_, lean_object* v_a_222_){
_start:
{
lean_object* v___x_224_; lean_object* v_fst_226_; lean_object* v_snd_227_; lean_object* v_rewriteCache_230_; lean_object* v_acNfCache_231_; lean_object* v_typeAnalysis_232_; lean_object* v_goal_233_; lean_object* v_hypotheses_234_; lean_object* v___x_236_; uint8_t v_isShared_237_; uint8_t v_isSharedCheck_248_; 
v___x_224_ = lean_st_ref_take(v_a_222_);
v_rewriteCache_230_ = lean_ctor_get(v___x_224_, 0);
v_acNfCache_231_ = lean_ctor_get(v___x_224_, 1);
v_typeAnalysis_232_ = lean_ctor_get(v___x_224_, 2);
v_goal_233_ = lean_ctor_get(v___x_224_, 3);
v_hypotheses_234_ = lean_ctor_get(v___x_224_, 4);
v_isSharedCheck_248_ = !lean_is_exclusive(v___x_224_);
if (v_isSharedCheck_248_ == 0)
{
v___x_236_ = v___x_224_;
v_isShared_237_ = v_isSharedCheck_248_;
goto v_resetjp_235_;
}
else
{
lean_inc(v_hypotheses_234_);
lean_inc(v_goal_233_);
lean_inc(v_typeAnalysis_232_);
lean_inc(v_acNfCache_231_);
lean_inc(v_rewriteCache_230_);
lean_dec(v___x_224_);
v___x_236_ = lean_box(0);
v_isShared_237_ = v_isSharedCheck_248_;
goto v_resetjp_235_;
}
v___jp_225_:
{
lean_object* v___x_228_; lean_object* v___x_229_; 
v___x_228_ = lean_st_ref_set(v_a_222_, v_snd_227_);
v___x_229_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_229_, 0, v_fst_226_);
return v___x_229_;
}
v_resetjp_235_:
{
lean_object* v___x_238_; uint8_t v___x_239_; 
v___x_238_ = lean_box(0);
v___x_239_ = l_Lean_instBEqMVarId_beq(v_g_221_, v_goal_233_);
lean_dec(v_goal_233_);
if (v___x_239_ == 0)
{
uint8_t v___x_240_; lean_object* v___x_242_; 
v___x_240_ = 1;
if (v_isShared_237_ == 0)
{
lean_ctor_set(v___x_236_, 3, v_g_221_);
v___x_242_ = v___x_236_;
goto v_reusejp_241_;
}
else
{
lean_object* v_reuseFailAlloc_243_; 
v_reuseFailAlloc_243_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_243_, 0, v_rewriteCache_230_);
lean_ctor_set(v_reuseFailAlloc_243_, 1, v_acNfCache_231_);
lean_ctor_set(v_reuseFailAlloc_243_, 2, v_typeAnalysis_232_);
lean_ctor_set(v_reuseFailAlloc_243_, 3, v_g_221_);
lean_ctor_set(v_reuseFailAlloc_243_, 4, v_hypotheses_234_);
v___x_242_ = v_reuseFailAlloc_243_;
goto v_reusejp_241_;
}
v_reusejp_241_:
{
lean_ctor_set_uint8(v___x_242_, sizeof(void*)*5, v___x_240_);
v_fst_226_ = v___x_238_;
v_snd_227_ = v___x_242_;
goto v___jp_225_;
}
}
else
{
uint8_t v___x_244_; lean_object* v___x_246_; 
v___x_244_ = 0;
if (v_isShared_237_ == 0)
{
lean_ctor_set(v___x_236_, 3, v_g_221_);
v___x_246_ = v___x_236_;
goto v_reusejp_245_;
}
else
{
lean_object* v_reuseFailAlloc_247_; 
v_reuseFailAlloc_247_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_247_, 0, v_rewriteCache_230_);
lean_ctor_set(v_reuseFailAlloc_247_, 1, v_acNfCache_231_);
lean_ctor_set(v_reuseFailAlloc_247_, 2, v_typeAnalysis_232_);
lean_ctor_set(v_reuseFailAlloc_247_, 3, v_g_221_);
lean_ctor_set(v_reuseFailAlloc_247_, 4, v_hypotheses_234_);
v___x_246_ = v_reuseFailAlloc_247_;
goto v_reusejp_245_;
}
v_reusejp_245_:
{
lean_ctor_set_uint8(v___x_246_, sizeof(void*)*5, v___x_244_);
v_fst_226_ = v___x_238_;
v_snd_227_ = v___x_246_;
goto v___jp_225_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal___redArg___boxed(lean_object* v_g_249_, lean_object* v_a_250_, lean_object* v_a_251_){
_start:
{
lean_object* v_res_252_; 
v_res_252_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal___redArg(v_g_249_, v_a_250_);
lean_dec(v_a_250_);
return v_res_252_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal(lean_object* v_g_253_, lean_object* v_a_254_, lean_object* v_a_255_, lean_object* v_a_256_, lean_object* v_a_257_, lean_object* v_a_258_, lean_object* v_a_259_, lean_object* v_a_260_, lean_object* v_a_261_){
_start:
{
lean_object* v___x_263_; lean_object* v_fst_265_; lean_object* v_snd_266_; lean_object* v_rewriteCache_269_; lean_object* v_acNfCache_270_; lean_object* v_typeAnalysis_271_; lean_object* v_goal_272_; lean_object* v_hypotheses_273_; lean_object* v___x_275_; uint8_t v_isShared_276_; uint8_t v_isSharedCheck_287_; 
v___x_263_ = lean_st_ref_take(v_a_255_);
v_rewriteCache_269_ = lean_ctor_get(v___x_263_, 0);
v_acNfCache_270_ = lean_ctor_get(v___x_263_, 1);
v_typeAnalysis_271_ = lean_ctor_get(v___x_263_, 2);
v_goal_272_ = lean_ctor_get(v___x_263_, 3);
v_hypotheses_273_ = lean_ctor_get(v___x_263_, 4);
v_isSharedCheck_287_ = !lean_is_exclusive(v___x_263_);
if (v_isSharedCheck_287_ == 0)
{
v___x_275_ = v___x_263_;
v_isShared_276_ = v_isSharedCheck_287_;
goto v_resetjp_274_;
}
else
{
lean_inc(v_hypotheses_273_);
lean_inc(v_goal_272_);
lean_inc(v_typeAnalysis_271_);
lean_inc(v_acNfCache_270_);
lean_inc(v_rewriteCache_269_);
lean_dec(v___x_263_);
v___x_275_ = lean_box(0);
v_isShared_276_ = v_isSharedCheck_287_;
goto v_resetjp_274_;
}
v___jp_264_:
{
lean_object* v___x_267_; lean_object* v___x_268_; 
v___x_267_ = lean_st_ref_set(v_a_255_, v_snd_266_);
v___x_268_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_268_, 0, v_fst_265_);
return v___x_268_;
}
v_resetjp_274_:
{
lean_object* v___x_277_; uint8_t v___x_278_; 
v___x_277_ = lean_box(0);
v___x_278_ = l_Lean_instBEqMVarId_beq(v_g_253_, v_goal_272_);
lean_dec(v_goal_272_);
if (v___x_278_ == 0)
{
uint8_t v___x_279_; lean_object* v___x_281_; 
v___x_279_ = 1;
if (v_isShared_276_ == 0)
{
lean_ctor_set(v___x_275_, 3, v_g_253_);
v___x_281_ = v___x_275_;
goto v_reusejp_280_;
}
else
{
lean_object* v_reuseFailAlloc_282_; 
v_reuseFailAlloc_282_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_282_, 0, v_rewriteCache_269_);
lean_ctor_set(v_reuseFailAlloc_282_, 1, v_acNfCache_270_);
lean_ctor_set(v_reuseFailAlloc_282_, 2, v_typeAnalysis_271_);
lean_ctor_set(v_reuseFailAlloc_282_, 3, v_g_253_);
lean_ctor_set(v_reuseFailAlloc_282_, 4, v_hypotheses_273_);
v___x_281_ = v_reuseFailAlloc_282_;
goto v_reusejp_280_;
}
v_reusejp_280_:
{
lean_ctor_set_uint8(v___x_281_, sizeof(void*)*5, v___x_279_);
v_fst_265_ = v___x_277_;
v_snd_266_ = v___x_281_;
goto v___jp_264_;
}
}
else
{
uint8_t v___x_283_; lean_object* v___x_285_; 
v___x_283_ = 0;
if (v_isShared_276_ == 0)
{
lean_ctor_set(v___x_275_, 3, v_g_253_);
v___x_285_ = v___x_275_;
goto v_reusejp_284_;
}
else
{
lean_object* v_reuseFailAlloc_286_; 
v_reuseFailAlloc_286_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_286_, 0, v_rewriteCache_269_);
lean_ctor_set(v_reuseFailAlloc_286_, 1, v_acNfCache_270_);
lean_ctor_set(v_reuseFailAlloc_286_, 2, v_typeAnalysis_271_);
lean_ctor_set(v_reuseFailAlloc_286_, 3, v_g_253_);
lean_ctor_set(v_reuseFailAlloc_286_, 4, v_hypotheses_273_);
v___x_285_ = v_reuseFailAlloc_286_;
goto v_reusejp_284_;
}
v_reusejp_284_:
{
lean_ctor_set_uint8(v___x_285_, sizeof(void*)*5, v___x_283_);
v_fst_265_ = v___x_277_;
v_snd_266_ = v___x_285_;
goto v___jp_264_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal___boxed(lean_object* v_g_288_, lean_object* v_a_289_, lean_object* v_a_290_, lean_object* v_a_291_, lean_object* v_a_292_, lean_object* v_a_293_, lean_object* v_a_294_, lean_object* v_a_295_, lean_object* v_a_296_, lean_object* v_a_297_){
_start:
{
lean_object* v_res_298_; 
v_res_298_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setGoal(v_g_288_, v_a_289_, v_a_290_, v_a_291_, v_a_292_, v_a_293_, v_a_294_, v_a_295_, v_a_296_);
lean_dec(v_a_296_);
lean_dec_ref(v_a_295_);
lean_dec(v_a_294_);
lean_dec_ref(v_a_293_);
lean_dec(v_a_292_);
lean_dec_ref(v_a_291_);
lean_dec(v_a_290_);
lean_dec_ref(v_a_289_);
return v_res_298_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange___redArg(lean_object* v_a_299_){
_start:
{
lean_object* v___x_301_; uint8_t v_didChange_302_; lean_object* v___x_303_; lean_object* v___x_304_; 
v___x_301_ = lean_st_ref_get(v_a_299_);
v_didChange_302_ = lean_ctor_get_uint8(v___x_301_, sizeof(void*)*5);
lean_dec(v___x_301_);
v___x_303_ = lean_box(v_didChange_302_);
v___x_304_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_304_, 0, v___x_303_);
return v___x_304_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange___redArg___boxed(lean_object* v_a_305_, lean_object* v_a_306_){
_start:
{
lean_object* v_res_307_; 
v_res_307_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange___redArg(v_a_305_);
lean_dec(v_a_305_);
return v_res_307_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange(lean_object* v_a_308_, lean_object* v_a_309_, lean_object* v_a_310_, lean_object* v_a_311_, lean_object* v_a_312_, lean_object* v_a_313_, lean_object* v_a_314_, lean_object* v_a_315_){
_start:
{
lean_object* v___x_317_; uint8_t v_didChange_318_; lean_object* v___x_319_; lean_object* v___x_320_; 
v___x_317_ = lean_st_ref_get(v_a_309_);
v_didChange_318_ = lean_ctor_get_uint8(v___x_317_, sizeof(void*)*5);
lean_dec(v___x_317_);
v___x_319_ = lean_box(v_didChange_318_);
v___x_320_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_320_, 0, v___x_319_);
return v___x_320_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange___boxed(lean_object* v_a_321_, lean_object* v_a_322_, lean_object* v_a_323_, lean_object* v_a_324_, lean_object* v_a_325_, lean_object* v_a_326_, lean_object* v_a_327_, lean_object* v_a_328_, lean_object* v_a_329_){
_start:
{
lean_object* v_res_330_; 
v_res_330_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_didChange(v_a_321_, v_a_322_, v_a_323_, v_a_324_, v_a_325_, v_a_326_, v_a_327_, v_a_328_);
lean_dec(v_a_328_);
lean_dec_ref(v_a_327_);
lean_dec(v_a_326_);
lean_dec_ref(v_a_325_);
lean_dec(v_a_324_);
lean_dec_ref(v_a_323_);
lean_dec(v_a_322_);
lean_dec_ref(v_a_321_);
return v_res_330_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange___redArg(lean_object* v_a_331_){
_start:
{
lean_object* v___x_333_; lean_object* v_rewriteCache_334_; lean_object* v_acNfCache_335_; lean_object* v_typeAnalysis_336_; lean_object* v_goal_337_; lean_object* v_hypotheses_338_; lean_object* v___x_340_; uint8_t v_isShared_341_; uint8_t v_isSharedCheck_349_; 
v___x_333_ = lean_st_ref_take(v_a_331_);
v_rewriteCache_334_ = lean_ctor_get(v___x_333_, 0);
v_acNfCache_335_ = lean_ctor_get(v___x_333_, 1);
v_typeAnalysis_336_ = lean_ctor_get(v___x_333_, 2);
v_goal_337_ = lean_ctor_get(v___x_333_, 3);
v_hypotheses_338_ = lean_ctor_get(v___x_333_, 4);
v_isSharedCheck_349_ = !lean_is_exclusive(v___x_333_);
if (v_isSharedCheck_349_ == 0)
{
v___x_340_ = v___x_333_;
v_isShared_341_ = v_isSharedCheck_349_;
goto v_resetjp_339_;
}
else
{
lean_inc(v_hypotheses_338_);
lean_inc(v_goal_337_);
lean_inc(v_typeAnalysis_336_);
lean_inc(v_acNfCache_335_);
lean_inc(v_rewriteCache_334_);
lean_dec(v___x_333_);
v___x_340_ = lean_box(0);
v_isShared_341_ = v_isSharedCheck_349_;
goto v_resetjp_339_;
}
v_resetjp_339_:
{
uint8_t v___x_342_; lean_object* v___x_344_; 
v___x_342_ = 0;
if (v_isShared_341_ == 0)
{
v___x_344_ = v___x_340_;
goto v_reusejp_343_;
}
else
{
lean_object* v_reuseFailAlloc_348_; 
v_reuseFailAlloc_348_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_348_, 0, v_rewriteCache_334_);
lean_ctor_set(v_reuseFailAlloc_348_, 1, v_acNfCache_335_);
lean_ctor_set(v_reuseFailAlloc_348_, 2, v_typeAnalysis_336_);
lean_ctor_set(v_reuseFailAlloc_348_, 3, v_goal_337_);
lean_ctor_set(v_reuseFailAlloc_348_, 4, v_hypotheses_338_);
v___x_344_ = v_reuseFailAlloc_348_;
goto v_reusejp_343_;
}
v_reusejp_343_:
{
lean_object* v___x_345_; lean_object* v___x_346_; lean_object* v___x_347_; 
lean_ctor_set_uint8(v___x_344_, sizeof(void*)*5, v___x_342_);
v___x_345_ = lean_st_ref_set(v_a_331_, v___x_344_);
v___x_346_ = lean_box(0);
v___x_347_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_347_, 0, v___x_346_);
return v___x_347_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange___redArg___boxed(lean_object* v_a_350_, lean_object* v_a_351_){
_start:
{
lean_object* v_res_352_; 
v_res_352_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange___redArg(v_a_350_);
lean_dec(v_a_350_);
return v_res_352_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange(lean_object* v_a_353_, lean_object* v_a_354_, lean_object* v_a_355_, lean_object* v_a_356_, lean_object* v_a_357_, lean_object* v_a_358_, lean_object* v_a_359_, lean_object* v_a_360_){
_start:
{
lean_object* v___x_362_; lean_object* v_rewriteCache_363_; lean_object* v_acNfCache_364_; lean_object* v_typeAnalysis_365_; lean_object* v_goal_366_; lean_object* v_hypotheses_367_; lean_object* v___x_369_; uint8_t v_isShared_370_; uint8_t v_isSharedCheck_378_; 
v___x_362_ = lean_st_ref_take(v_a_354_);
v_rewriteCache_363_ = lean_ctor_get(v___x_362_, 0);
v_acNfCache_364_ = lean_ctor_get(v___x_362_, 1);
v_typeAnalysis_365_ = lean_ctor_get(v___x_362_, 2);
v_goal_366_ = lean_ctor_get(v___x_362_, 3);
v_hypotheses_367_ = lean_ctor_get(v___x_362_, 4);
v_isSharedCheck_378_ = !lean_is_exclusive(v___x_362_);
if (v_isSharedCheck_378_ == 0)
{
v___x_369_ = v___x_362_;
v_isShared_370_ = v_isSharedCheck_378_;
goto v_resetjp_368_;
}
else
{
lean_inc(v_hypotheses_367_);
lean_inc(v_goal_366_);
lean_inc(v_typeAnalysis_365_);
lean_inc(v_acNfCache_364_);
lean_inc(v_rewriteCache_363_);
lean_dec(v___x_362_);
v___x_369_ = lean_box(0);
v_isShared_370_ = v_isSharedCheck_378_;
goto v_resetjp_368_;
}
v_resetjp_368_:
{
uint8_t v___x_371_; lean_object* v___x_373_; 
v___x_371_ = 0;
if (v_isShared_370_ == 0)
{
v___x_373_ = v___x_369_;
goto v_reusejp_372_;
}
else
{
lean_object* v_reuseFailAlloc_377_; 
v_reuseFailAlloc_377_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_377_, 0, v_rewriteCache_363_);
lean_ctor_set(v_reuseFailAlloc_377_, 1, v_acNfCache_364_);
lean_ctor_set(v_reuseFailAlloc_377_, 2, v_typeAnalysis_365_);
lean_ctor_set(v_reuseFailAlloc_377_, 3, v_goal_366_);
lean_ctor_set(v_reuseFailAlloc_377_, 4, v_hypotheses_367_);
v___x_373_ = v_reuseFailAlloc_377_;
goto v_reusejp_372_;
}
v_reusejp_372_:
{
lean_object* v___x_374_; lean_object* v___x_375_; lean_object* v___x_376_; 
lean_ctor_set_uint8(v___x_373_, sizeof(void*)*5, v___x_371_);
v___x_374_ = lean_st_ref_set(v_a_354_, v___x_373_);
v___x_375_ = lean_box(0);
v___x_376_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_376_, 0, v___x_375_);
return v___x_376_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange___boxed(lean_object* v_a_379_, lean_object* v_a_380_, lean_object* v_a_381_, lean_object* v_a_382_, lean_object* v_a_383_, lean_object* v_a_384_, lean_object* v_a_385_, lean_object* v_a_386_, lean_object* v_a_387_){
_start:
{
lean_object* v_res_388_; 
v_res_388_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_resetDidChange(v_a_379_, v_a_380_, v_a_381_, v_a_382_, v_a_383_, v_a_384_, v_a_385_, v_a_386_);
lean_dec(v_a_386_);
lean_dec_ref(v_a_385_);
lean_dec(v_a_384_);
lean_dec_ref(v_a_383_);
lean_dec(v_a_382_);
lean_dec_ref(v_a_381_);
lean_dec(v_a_380_);
lean_dec_ref(v_a_379_);
return v_res_388_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange___redArg(lean_object* v_a_389_){
_start:
{
lean_object* v___x_391_; lean_object* v_rewriteCache_392_; lean_object* v_acNfCache_393_; lean_object* v_typeAnalysis_394_; lean_object* v_goal_395_; lean_object* v_hypotheses_396_; lean_object* v___x_398_; uint8_t v_isShared_399_; uint8_t v_isSharedCheck_407_; 
v___x_391_ = lean_st_ref_take(v_a_389_);
v_rewriteCache_392_ = lean_ctor_get(v___x_391_, 0);
v_acNfCache_393_ = lean_ctor_get(v___x_391_, 1);
v_typeAnalysis_394_ = lean_ctor_get(v___x_391_, 2);
v_goal_395_ = lean_ctor_get(v___x_391_, 3);
v_hypotheses_396_ = lean_ctor_get(v___x_391_, 4);
v_isSharedCheck_407_ = !lean_is_exclusive(v___x_391_);
if (v_isSharedCheck_407_ == 0)
{
v___x_398_ = v___x_391_;
v_isShared_399_ = v_isSharedCheck_407_;
goto v_resetjp_397_;
}
else
{
lean_inc(v_hypotheses_396_);
lean_inc(v_goal_395_);
lean_inc(v_typeAnalysis_394_);
lean_inc(v_acNfCache_393_);
lean_inc(v_rewriteCache_392_);
lean_dec(v___x_391_);
v___x_398_ = lean_box(0);
v_isShared_399_ = v_isSharedCheck_407_;
goto v_resetjp_397_;
}
v_resetjp_397_:
{
uint8_t v___x_400_; lean_object* v___x_402_; 
v___x_400_ = 1;
if (v_isShared_399_ == 0)
{
v___x_402_ = v___x_398_;
goto v_reusejp_401_;
}
else
{
lean_object* v_reuseFailAlloc_406_; 
v_reuseFailAlloc_406_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_406_, 0, v_rewriteCache_392_);
lean_ctor_set(v_reuseFailAlloc_406_, 1, v_acNfCache_393_);
lean_ctor_set(v_reuseFailAlloc_406_, 2, v_typeAnalysis_394_);
lean_ctor_set(v_reuseFailAlloc_406_, 3, v_goal_395_);
lean_ctor_set(v_reuseFailAlloc_406_, 4, v_hypotheses_396_);
v___x_402_ = v_reuseFailAlloc_406_;
goto v_reusejp_401_;
}
v_reusejp_401_:
{
lean_object* v___x_403_; lean_object* v___x_404_; lean_object* v___x_405_; 
lean_ctor_set_uint8(v___x_402_, sizeof(void*)*5, v___x_400_);
v___x_403_ = lean_st_ref_set(v_a_389_, v___x_402_);
v___x_404_ = lean_box(0);
v___x_405_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_405_, 0, v___x_404_);
return v___x_405_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange___redArg___boxed(lean_object* v_a_408_, lean_object* v_a_409_){
_start:
{
lean_object* v_res_410_; 
v_res_410_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange___redArg(v_a_408_);
lean_dec(v_a_408_);
return v_res_410_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange(lean_object* v_a_411_, lean_object* v_a_412_, lean_object* v_a_413_, lean_object* v_a_414_, lean_object* v_a_415_, lean_object* v_a_416_, lean_object* v_a_417_, lean_object* v_a_418_){
_start:
{
lean_object* v___x_420_; lean_object* v_rewriteCache_421_; lean_object* v_acNfCache_422_; lean_object* v_typeAnalysis_423_; lean_object* v_goal_424_; lean_object* v_hypotheses_425_; lean_object* v___x_427_; uint8_t v_isShared_428_; uint8_t v_isSharedCheck_436_; 
v___x_420_ = lean_st_ref_take(v_a_412_);
v_rewriteCache_421_ = lean_ctor_get(v___x_420_, 0);
v_acNfCache_422_ = lean_ctor_get(v___x_420_, 1);
v_typeAnalysis_423_ = lean_ctor_get(v___x_420_, 2);
v_goal_424_ = lean_ctor_get(v___x_420_, 3);
v_hypotheses_425_ = lean_ctor_get(v___x_420_, 4);
v_isSharedCheck_436_ = !lean_is_exclusive(v___x_420_);
if (v_isSharedCheck_436_ == 0)
{
v___x_427_ = v___x_420_;
v_isShared_428_ = v_isSharedCheck_436_;
goto v_resetjp_426_;
}
else
{
lean_inc(v_hypotheses_425_);
lean_inc(v_goal_424_);
lean_inc(v_typeAnalysis_423_);
lean_inc(v_acNfCache_422_);
lean_inc(v_rewriteCache_421_);
lean_dec(v___x_420_);
v___x_427_ = lean_box(0);
v_isShared_428_ = v_isSharedCheck_436_;
goto v_resetjp_426_;
}
v_resetjp_426_:
{
uint8_t v___x_429_; lean_object* v___x_431_; 
v___x_429_ = 1;
if (v_isShared_428_ == 0)
{
v___x_431_ = v___x_427_;
goto v_reusejp_430_;
}
else
{
lean_object* v_reuseFailAlloc_435_; 
v_reuseFailAlloc_435_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_435_, 0, v_rewriteCache_421_);
lean_ctor_set(v_reuseFailAlloc_435_, 1, v_acNfCache_422_);
lean_ctor_set(v_reuseFailAlloc_435_, 2, v_typeAnalysis_423_);
lean_ctor_set(v_reuseFailAlloc_435_, 3, v_goal_424_);
lean_ctor_set(v_reuseFailAlloc_435_, 4, v_hypotheses_425_);
v___x_431_ = v_reuseFailAlloc_435_;
goto v_reusejp_430_;
}
v_reusejp_430_:
{
lean_object* v___x_432_; lean_object* v___x_433_; lean_object* v___x_434_; 
lean_ctor_set_uint8(v___x_431_, sizeof(void*)*5, v___x_429_);
v___x_432_ = lean_st_ref_set(v_a_412_, v___x_431_);
v___x_433_ = lean_box(0);
v___x_434_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_434_, 0, v___x_433_);
return v___x_434_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange___boxed(lean_object* v_a_437_, lean_object* v_a_438_, lean_object* v_a_439_, lean_object* v_a_440_, lean_object* v_a_441_, lean_object* v_a_442_, lean_object* v_a_443_, lean_object* v_a_444_, lean_object* v_a_445_){
_start:
{
lean_object* v_res_446_; 
v_res_446_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange(v_a_437_, v_a_438_, v_a_439_, v_a_440_, v_a_441_, v_a_442_, v_a_443_, v_a_444_);
lean_dec(v_a_444_);
lean_dec_ref(v_a_443_);
lean_dec(v_a_442_);
lean_dec_ref(v_a_441_);
lean_dec(v_a_440_);
lean_dec_ref(v_a_439_);
lean_dec(v_a_438_);
lean_dec_ref(v_a_437_);
return v_res_446_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg(lean_object* v_fvar_449_, lean_object* v_a_450_){
_start:
{
lean_object* v___x_452_; lean_object* v_rewriteCache_453_; lean_object* v___x_454_; lean_object* v___x_455_; uint8_t v___x_456_; lean_object* v___x_457_; lean_object* v___x_458_; 
v___x_452_ = lean_st_ref_get(v_a_450_);
v_rewriteCache_453_ = lean_ctor_get(v___x_452_, 0);
lean_inc_ref(v_rewriteCache_453_);
lean_dec(v___x_452_);
v___x_454_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0));
v___x_455_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1));
v___x_456_ = l_Std_DHashMap_Internal_Raw_u2080_contains___redArg(v___x_454_, v___x_455_, v_rewriteCache_453_, v_fvar_449_);
lean_dec_ref(v_rewriteCache_453_);
v___x_457_ = lean_box(v___x_456_);
v___x_458_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_458_, 0, v___x_457_);
return v___x_458_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___boxed(lean_object* v_fvar_459_, lean_object* v_a_460_, lean_object* v_a_461_){
_start:
{
lean_object* v_res_462_; 
v_res_462_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg(v_fvar_459_, v_a_460_);
lean_dec(v_a_460_);
return v_res_462_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten(lean_object* v_fvar_463_, lean_object* v_a_464_, lean_object* v_a_465_, lean_object* v_a_466_, lean_object* v_a_467_, lean_object* v_a_468_, lean_object* v_a_469_, lean_object* v_a_470_, lean_object* v_a_471_){
_start:
{
lean_object* v___x_473_; lean_object* v_rewriteCache_474_; lean_object* v___x_475_; lean_object* v___x_476_; uint8_t v___x_477_; lean_object* v___x_478_; lean_object* v___x_479_; 
v___x_473_ = lean_st_ref_get(v_a_465_);
v_rewriteCache_474_ = lean_ctor_get(v___x_473_, 0);
lean_inc_ref(v_rewriteCache_474_);
lean_dec(v___x_473_);
v___x_475_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0));
v___x_476_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1));
v___x_477_ = l_Std_DHashMap_Internal_Raw_u2080_contains___redArg(v___x_475_, v___x_476_, v_rewriteCache_474_, v_fvar_463_);
lean_dec_ref(v_rewriteCache_474_);
v___x_478_ = lean_box(v___x_477_);
v___x_479_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_479_, 0, v___x_478_);
return v___x_479_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___boxed(lean_object* v_fvar_480_, lean_object* v_a_481_, lean_object* v_a_482_, lean_object* v_a_483_, lean_object* v_a_484_, lean_object* v_a_485_, lean_object* v_a_486_, lean_object* v_a_487_, lean_object* v_a_488_, lean_object* v_a_489_){
_start:
{
lean_object* v_res_490_; 
v_res_490_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten(v_fvar_480_, v_a_481_, v_a_482_, v_a_483_, v_a_484_, v_a_485_, v_a_486_, v_a_487_, v_a_488_);
lean_dec(v_a_488_);
lean_dec_ref(v_a_487_);
lean_dec(v_a_486_);
lean_dec_ref(v_a_485_);
lean_dec(v_a_484_);
lean_dec_ref(v_a_483_);
lean_dec(v_a_482_);
lean_dec_ref(v_a_481_);
return v_res_490_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf___redArg(lean_object* v_fvar_491_, lean_object* v_a_492_){
_start:
{
lean_object* v___x_494_; lean_object* v_acNfCache_495_; lean_object* v___x_496_; lean_object* v___x_497_; uint8_t v___x_498_; lean_object* v___x_499_; lean_object* v___x_500_; 
v___x_494_ = lean_st_ref_get(v_a_492_);
v_acNfCache_495_ = lean_ctor_get(v___x_494_, 1);
lean_inc_ref(v_acNfCache_495_);
lean_dec(v___x_494_);
v___x_496_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0));
v___x_497_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1));
v___x_498_ = l_Std_DHashMap_Internal_Raw_u2080_contains___redArg(v___x_496_, v___x_497_, v_acNfCache_495_, v_fvar_491_);
lean_dec_ref(v_acNfCache_495_);
v___x_499_ = lean_box(v___x_498_);
v___x_500_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_500_, 0, v___x_499_);
return v___x_500_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf___redArg___boxed(lean_object* v_fvar_501_, lean_object* v_a_502_, lean_object* v_a_503_){
_start:
{
lean_object* v_res_504_; 
v_res_504_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf___redArg(v_fvar_501_, v_a_502_);
lean_dec(v_a_502_);
return v_res_504_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf(lean_object* v_fvar_505_, lean_object* v_a_506_, lean_object* v_a_507_, lean_object* v_a_508_, lean_object* v_a_509_, lean_object* v_a_510_, lean_object* v_a_511_, lean_object* v_a_512_, lean_object* v_a_513_){
_start:
{
lean_object* v___x_515_; lean_object* v_acNfCache_516_; lean_object* v___x_517_; lean_object* v___x_518_; uint8_t v___x_519_; lean_object* v___x_520_; lean_object* v___x_521_; 
v___x_515_ = lean_st_ref_get(v_a_507_);
v_acNfCache_516_ = lean_ctor_get(v___x_515_, 1);
lean_inc_ref(v_acNfCache_516_);
lean_dec(v___x_515_);
v___x_517_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0));
v___x_518_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1));
v___x_519_ = l_Std_DHashMap_Internal_Raw_u2080_contains___redArg(v___x_517_, v___x_518_, v_acNfCache_516_, v_fvar_505_);
lean_dec_ref(v_acNfCache_516_);
v___x_520_ = lean_box(v___x_519_);
v___x_521_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_521_, 0, v___x_520_);
return v___x_521_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf___boxed(lean_object* v_fvar_522_, lean_object* v_a_523_, lean_object* v_a_524_, lean_object* v_a_525_, lean_object* v_a_526_, lean_object* v_a_527_, lean_object* v_a_528_, lean_object* v_a_529_, lean_object* v_a_530_, lean_object* v_a_531_){
_start:
{
lean_object* v_res_532_; 
v_res_532_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkAcNf(v_fvar_522_, v_a_523_, v_a_524_, v_a_525_, v_a_526_, v_a_527_, v_a_528_, v_a_529_, v_a_530_);
lean_dec(v_a_530_);
lean_dec_ref(v_a_529_);
lean_dec(v_a_528_);
lean_dec_ref(v_a_527_);
lean_dec(v_a_526_);
lean_dec_ref(v_a_525_);
lean_dec(v_a_524_);
lean_dec_ref(v_a_523_);
return v_res_532_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished___redArg(lean_object* v_fvar_533_, lean_object* v_a_534_){
_start:
{
lean_object* v___x_536_; lean_object* v_rewriteCache_537_; lean_object* v_acNfCache_538_; lean_object* v_typeAnalysis_539_; lean_object* v_goal_540_; lean_object* v_hypotheses_541_; uint8_t v_didChange_542_; lean_object* v___x_544_; uint8_t v_isShared_545_; uint8_t v_isSharedCheck_555_; 
v___x_536_ = lean_st_ref_take(v_a_534_);
v_rewriteCache_537_ = lean_ctor_get(v___x_536_, 0);
v_acNfCache_538_ = lean_ctor_get(v___x_536_, 1);
v_typeAnalysis_539_ = lean_ctor_get(v___x_536_, 2);
v_goal_540_ = lean_ctor_get(v___x_536_, 3);
v_hypotheses_541_ = lean_ctor_get(v___x_536_, 4);
v_didChange_542_ = lean_ctor_get_uint8(v___x_536_, sizeof(void*)*5);
v_isSharedCheck_555_ = !lean_is_exclusive(v___x_536_);
if (v_isSharedCheck_555_ == 0)
{
v___x_544_ = v___x_536_;
v_isShared_545_ = v_isSharedCheck_555_;
goto v_resetjp_543_;
}
else
{
lean_inc(v_hypotheses_541_);
lean_inc(v_goal_540_);
lean_inc(v_typeAnalysis_539_);
lean_inc(v_acNfCache_538_);
lean_inc(v_rewriteCache_537_);
lean_dec(v___x_536_);
v___x_544_ = lean_box(0);
v_isShared_545_ = v_isSharedCheck_555_;
goto v_resetjp_543_;
}
v_resetjp_543_:
{
lean_object* v___x_546_; lean_object* v___x_547_; lean_object* v___x_548_; lean_object* v___x_549_; lean_object* v___x_551_; 
v___x_546_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0));
v___x_547_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1));
v___x_548_ = lean_box(0);
v___x_549_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_546_, v___x_547_, v_rewriteCache_537_, v_fvar_533_, v___x_548_);
if (v_isShared_545_ == 0)
{
lean_ctor_set(v___x_544_, 0, v___x_549_);
v___x_551_ = v___x_544_;
goto v_reusejp_550_;
}
else
{
lean_object* v_reuseFailAlloc_554_; 
v_reuseFailAlloc_554_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_554_, 0, v___x_549_);
lean_ctor_set(v_reuseFailAlloc_554_, 1, v_acNfCache_538_);
lean_ctor_set(v_reuseFailAlloc_554_, 2, v_typeAnalysis_539_);
lean_ctor_set(v_reuseFailAlloc_554_, 3, v_goal_540_);
lean_ctor_set(v_reuseFailAlloc_554_, 4, v_hypotheses_541_);
lean_ctor_set_uint8(v_reuseFailAlloc_554_, sizeof(void*)*5, v_didChange_542_);
v___x_551_ = v_reuseFailAlloc_554_;
goto v_reusejp_550_;
}
v_reusejp_550_:
{
lean_object* v___x_552_; lean_object* v___x_553_; 
v___x_552_ = lean_st_ref_set(v_a_534_, v___x_551_);
v___x_553_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_553_, 0, v___x_548_);
return v___x_553_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished___redArg___boxed(lean_object* v_fvar_556_, lean_object* v_a_557_, lean_object* v_a_558_){
_start:
{
lean_object* v_res_559_; 
v_res_559_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished___redArg(v_fvar_556_, v_a_557_);
lean_dec(v_a_557_);
return v_res_559_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished(lean_object* v_fvar_560_, lean_object* v_a_561_, lean_object* v_a_562_, lean_object* v_a_563_, lean_object* v_a_564_, lean_object* v_a_565_, lean_object* v_a_566_, lean_object* v_a_567_, lean_object* v_a_568_){
_start:
{
lean_object* v___x_570_; lean_object* v_rewriteCache_571_; lean_object* v_acNfCache_572_; lean_object* v_typeAnalysis_573_; lean_object* v_goal_574_; lean_object* v_hypotheses_575_; uint8_t v_didChange_576_; lean_object* v___x_578_; uint8_t v_isShared_579_; uint8_t v_isSharedCheck_589_; 
v___x_570_ = lean_st_ref_take(v_a_562_);
v_rewriteCache_571_ = lean_ctor_get(v___x_570_, 0);
v_acNfCache_572_ = lean_ctor_get(v___x_570_, 1);
v_typeAnalysis_573_ = lean_ctor_get(v___x_570_, 2);
v_goal_574_ = lean_ctor_get(v___x_570_, 3);
v_hypotheses_575_ = lean_ctor_get(v___x_570_, 4);
v_didChange_576_ = lean_ctor_get_uint8(v___x_570_, sizeof(void*)*5);
v_isSharedCheck_589_ = !lean_is_exclusive(v___x_570_);
if (v_isSharedCheck_589_ == 0)
{
v___x_578_ = v___x_570_;
v_isShared_579_ = v_isSharedCheck_589_;
goto v_resetjp_577_;
}
else
{
lean_inc(v_hypotheses_575_);
lean_inc(v_goal_574_);
lean_inc(v_typeAnalysis_573_);
lean_inc(v_acNfCache_572_);
lean_inc(v_rewriteCache_571_);
lean_dec(v___x_570_);
v___x_578_ = lean_box(0);
v_isShared_579_ = v_isSharedCheck_589_;
goto v_resetjp_577_;
}
v_resetjp_577_:
{
lean_object* v___x_580_; lean_object* v___x_581_; lean_object* v___x_582_; lean_object* v___x_583_; lean_object* v___x_585_; 
v___x_580_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0));
v___x_581_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1));
v___x_582_ = lean_box(0);
v___x_583_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_580_, v___x_581_, v_rewriteCache_571_, v_fvar_560_, v___x_582_);
if (v_isShared_579_ == 0)
{
lean_ctor_set(v___x_578_, 0, v___x_583_);
v___x_585_ = v___x_578_;
goto v_reusejp_584_;
}
else
{
lean_object* v_reuseFailAlloc_588_; 
v_reuseFailAlloc_588_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_588_, 0, v___x_583_);
lean_ctor_set(v_reuseFailAlloc_588_, 1, v_acNfCache_572_);
lean_ctor_set(v_reuseFailAlloc_588_, 2, v_typeAnalysis_573_);
lean_ctor_set(v_reuseFailAlloc_588_, 3, v_goal_574_);
lean_ctor_set(v_reuseFailAlloc_588_, 4, v_hypotheses_575_);
lean_ctor_set_uint8(v_reuseFailAlloc_588_, sizeof(void*)*5, v_didChange_576_);
v___x_585_ = v_reuseFailAlloc_588_;
goto v_reusejp_584_;
}
v_reusejp_584_:
{
lean_object* v___x_586_; lean_object* v___x_587_; 
v___x_586_ = lean_st_ref_set(v_a_562_, v___x_585_);
v___x_587_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_587_, 0, v___x_582_);
return v___x_587_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished___boxed(lean_object* v_fvar_590_, lean_object* v_a_591_, lean_object* v_a_592_, lean_object* v_a_593_, lean_object* v_a_594_, lean_object* v_a_595_, lean_object* v_a_596_, lean_object* v_a_597_, lean_object* v_a_598_, lean_object* v_a_599_){
_start:
{
lean_object* v_res_600_; 
v_res_600_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_rewriteFinished(v_fvar_590_, v_a_591_, v_a_592_, v_a_593_, v_a_594_, v_a_595_, v_a_596_, v_a_597_, v_a_598_);
lean_dec(v_a_598_);
lean_dec_ref(v_a_597_);
lean_dec(v_a_596_);
lean_dec_ref(v_a_595_);
lean_dec(v_a_594_);
lean_dec_ref(v_a_593_);
lean_dec(v_a_592_);
lean_dec_ref(v_a_591_);
return v_res_600_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished___redArg(lean_object* v_fvar_601_, lean_object* v_a_602_){
_start:
{
lean_object* v___x_604_; lean_object* v_rewriteCache_605_; lean_object* v_acNfCache_606_; lean_object* v_typeAnalysis_607_; lean_object* v_goal_608_; lean_object* v_hypotheses_609_; uint8_t v_didChange_610_; lean_object* v___x_612_; uint8_t v_isShared_613_; uint8_t v_isSharedCheck_623_; 
v___x_604_ = lean_st_ref_take(v_a_602_);
v_rewriteCache_605_ = lean_ctor_get(v___x_604_, 0);
v_acNfCache_606_ = lean_ctor_get(v___x_604_, 1);
v_typeAnalysis_607_ = lean_ctor_get(v___x_604_, 2);
v_goal_608_ = lean_ctor_get(v___x_604_, 3);
v_hypotheses_609_ = lean_ctor_get(v___x_604_, 4);
v_didChange_610_ = lean_ctor_get_uint8(v___x_604_, sizeof(void*)*5);
v_isSharedCheck_623_ = !lean_is_exclusive(v___x_604_);
if (v_isSharedCheck_623_ == 0)
{
v___x_612_ = v___x_604_;
v_isShared_613_ = v_isSharedCheck_623_;
goto v_resetjp_611_;
}
else
{
lean_inc(v_hypotheses_609_);
lean_inc(v_goal_608_);
lean_inc(v_typeAnalysis_607_);
lean_inc(v_acNfCache_606_);
lean_inc(v_rewriteCache_605_);
lean_dec(v___x_604_);
v___x_612_ = lean_box(0);
v_isShared_613_ = v_isSharedCheck_623_;
goto v_resetjp_611_;
}
v_resetjp_611_:
{
lean_object* v___x_614_; lean_object* v___x_615_; lean_object* v___x_616_; lean_object* v___x_617_; lean_object* v___x_619_; 
v___x_614_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0));
v___x_615_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1));
v___x_616_ = lean_box(0);
v___x_617_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_614_, v___x_615_, v_acNfCache_606_, v_fvar_601_, v___x_616_);
if (v_isShared_613_ == 0)
{
lean_ctor_set(v___x_612_, 1, v___x_617_);
v___x_619_ = v___x_612_;
goto v_reusejp_618_;
}
else
{
lean_object* v_reuseFailAlloc_622_; 
v_reuseFailAlloc_622_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_622_, 0, v_rewriteCache_605_);
lean_ctor_set(v_reuseFailAlloc_622_, 1, v___x_617_);
lean_ctor_set(v_reuseFailAlloc_622_, 2, v_typeAnalysis_607_);
lean_ctor_set(v_reuseFailAlloc_622_, 3, v_goal_608_);
lean_ctor_set(v_reuseFailAlloc_622_, 4, v_hypotheses_609_);
lean_ctor_set_uint8(v_reuseFailAlloc_622_, sizeof(void*)*5, v_didChange_610_);
v___x_619_ = v_reuseFailAlloc_622_;
goto v_reusejp_618_;
}
v_reusejp_618_:
{
lean_object* v___x_620_; lean_object* v___x_621_; 
v___x_620_ = lean_st_ref_set(v_a_602_, v___x_619_);
v___x_621_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_621_, 0, v___x_616_);
return v___x_621_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished___redArg___boxed(lean_object* v_fvar_624_, lean_object* v_a_625_, lean_object* v_a_626_){
_start:
{
lean_object* v_res_627_; 
v_res_627_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished___redArg(v_fvar_624_, v_a_625_);
lean_dec(v_a_625_);
return v_res_627_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished(lean_object* v_fvar_628_, lean_object* v_a_629_, lean_object* v_a_630_, lean_object* v_a_631_, lean_object* v_a_632_, lean_object* v_a_633_, lean_object* v_a_634_, lean_object* v_a_635_, lean_object* v_a_636_){
_start:
{
lean_object* v___x_638_; lean_object* v_rewriteCache_639_; lean_object* v_acNfCache_640_; lean_object* v_typeAnalysis_641_; lean_object* v_goal_642_; lean_object* v_hypotheses_643_; uint8_t v_didChange_644_; lean_object* v___x_646_; uint8_t v_isShared_647_; uint8_t v_isSharedCheck_657_; 
v___x_638_ = lean_st_ref_take(v_a_630_);
v_rewriteCache_639_ = lean_ctor_get(v___x_638_, 0);
v_acNfCache_640_ = lean_ctor_get(v___x_638_, 1);
v_typeAnalysis_641_ = lean_ctor_get(v___x_638_, 2);
v_goal_642_ = lean_ctor_get(v___x_638_, 3);
v_hypotheses_643_ = lean_ctor_get(v___x_638_, 4);
v_didChange_644_ = lean_ctor_get_uint8(v___x_638_, sizeof(void*)*5);
v_isSharedCheck_657_ = !lean_is_exclusive(v___x_638_);
if (v_isSharedCheck_657_ == 0)
{
v___x_646_ = v___x_638_;
v_isShared_647_ = v_isSharedCheck_657_;
goto v_resetjp_645_;
}
else
{
lean_inc(v_hypotheses_643_);
lean_inc(v_goal_642_);
lean_inc(v_typeAnalysis_641_);
lean_inc(v_acNfCache_640_);
lean_inc(v_rewriteCache_639_);
lean_dec(v___x_638_);
v___x_646_ = lean_box(0);
v_isShared_647_ = v_isSharedCheck_657_;
goto v_resetjp_645_;
}
v_resetjp_645_:
{
lean_object* v___x_648_; lean_object* v___x_649_; lean_object* v___x_650_; lean_object* v___x_651_; lean_object* v___x_653_; 
v___x_648_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__0));
v___x_649_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_checkRewritten___redArg___closed__1));
v___x_650_ = lean_box(0);
v___x_651_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_648_, v___x_649_, v_acNfCache_640_, v_fvar_628_, v___x_650_);
if (v_isShared_647_ == 0)
{
lean_ctor_set(v___x_646_, 1, v___x_651_);
v___x_653_ = v___x_646_;
goto v_reusejp_652_;
}
else
{
lean_object* v_reuseFailAlloc_656_; 
v_reuseFailAlloc_656_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_656_, 0, v_rewriteCache_639_);
lean_ctor_set(v_reuseFailAlloc_656_, 1, v___x_651_);
lean_ctor_set(v_reuseFailAlloc_656_, 2, v_typeAnalysis_641_);
lean_ctor_set(v_reuseFailAlloc_656_, 3, v_goal_642_);
lean_ctor_set(v_reuseFailAlloc_656_, 4, v_hypotheses_643_);
lean_ctor_set_uint8(v_reuseFailAlloc_656_, sizeof(void*)*5, v_didChange_644_);
v___x_653_ = v_reuseFailAlloc_656_;
goto v_reusejp_652_;
}
v_reusejp_652_:
{
lean_object* v___x_654_; lean_object* v___x_655_; 
v___x_654_ = lean_st_ref_set(v_a_630_, v___x_653_);
v___x_655_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_655_, 0, v___x_650_);
return v___x_655_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished___boxed(lean_object* v_fvar_658_, lean_object* v_a_659_, lean_object* v_a_660_, lean_object* v_a_661_, lean_object* v_a_662_, lean_object* v_a_663_, lean_object* v_a_664_, lean_object* v_a_665_, lean_object* v_a_666_, lean_object* v_a_667_){
_start:
{
lean_object* v_res_668_; 
v_res_668_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_acNfFinished(v_fvar_658_, v_a_659_, v_a_660_, v_a_661_, v_a_662_, v_a_663_, v_a_664_, v_a_665_, v_a_666_);
lean_dec(v_a_666_);
lean_dec_ref(v_a_665_);
lean_dec(v_a_664_);
lean_dec_ref(v_a_663_);
lean_dec(v_a_662_);
lean_dec_ref(v_a_661_);
lean_dec(v_a_660_);
lean_dec_ref(v_a_659_);
return v_res_668_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis___redArg(lean_object* v_a_669_){
_start:
{
lean_object* v___x_671_; lean_object* v_typeAnalysis_672_; lean_object* v___x_673_; 
v___x_671_ = lean_st_ref_get(v_a_669_);
v_typeAnalysis_672_ = lean_ctor_get(v___x_671_, 2);
lean_inc_ref(v_typeAnalysis_672_);
lean_dec(v___x_671_);
v___x_673_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_673_, 0, v_typeAnalysis_672_);
return v___x_673_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis___redArg___boxed(lean_object* v_a_674_, lean_object* v_a_675_){
_start:
{
lean_object* v_res_676_; 
v_res_676_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis___redArg(v_a_674_);
lean_dec(v_a_674_);
return v_res_676_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis(lean_object* v_a_677_, lean_object* v_a_678_, lean_object* v_a_679_, lean_object* v_a_680_, lean_object* v_a_681_, lean_object* v_a_682_, lean_object* v_a_683_, lean_object* v_a_684_){
_start:
{
lean_object* v___x_686_; lean_object* v_typeAnalysis_687_; lean_object* v___x_688_; 
v___x_686_ = lean_st_ref_get(v_a_678_);
v_typeAnalysis_687_ = lean_ctor_get(v___x_686_, 2);
lean_inc_ref(v_typeAnalysis_687_);
lean_dec(v___x_686_);
v___x_688_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_688_, 0, v_typeAnalysis_687_);
return v___x_688_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis___boxed(lean_object* v_a_689_, lean_object* v_a_690_, lean_object* v_a_691_, lean_object* v_a_692_, lean_object* v_a_693_, lean_object* v_a_694_, lean_object* v_a_695_, lean_object* v_a_696_, lean_object* v_a_697_){
_start:
{
lean_object* v_res_698_; 
v_res_698_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getTypeAnalysis(v_a_689_, v_a_690_, v_a_691_, v_a_692_, v_a_693_, v_a_694_, v_a_695_, v_a_696_);
lean_dec(v_a_696_);
lean_dec_ref(v_a_695_);
lean_dec(v_a_694_);
lean_dec_ref(v_a_693_);
lean_dec(v_a_692_);
lean_dec_ref(v_a_691_);
lean_dec(v_a_690_);
lean_dec_ref(v_a_689_);
return v_res_698_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg(lean_object* v_n_704_, lean_object* v_a_705_){
_start:
{
lean_object* v___x_707_; lean_object* v_typeAnalysis_708_; lean_object* v_interestingStructures_709_; lean_object* v_uninteresting_710_; lean_object* v___x_711_; lean_object* v___x_712_; uint8_t v___x_713_; 
v___x_707_ = lean_st_ref_get(v_a_705_);
v_typeAnalysis_708_ = lean_ctor_get(v___x_707_, 2);
lean_inc_ref(v_typeAnalysis_708_);
lean_dec(v___x_707_);
v_interestingStructures_709_ = lean_ctor_get(v_typeAnalysis_708_, 0);
lean_inc_ref(v_interestingStructures_709_);
v_uninteresting_710_ = lean_ctor_get(v_typeAnalysis_708_, 3);
lean_inc_ref(v_uninteresting_710_);
lean_dec_ref(v_typeAnalysis_708_);
v___x_711_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_712_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
lean_inc(v_n_704_);
v___x_713_ = l_Std_DHashMap_Internal_Raw_u2080_contains___redArg(v___x_711_, v___x_712_, v_uninteresting_710_, v_n_704_);
lean_dec_ref(v_uninteresting_710_);
if (v___x_713_ == 0)
{
uint8_t v___x_714_; 
v___x_714_ = l_Std_DHashMap_Internal_Raw_u2080_contains___redArg(v___x_711_, v___x_712_, v_interestingStructures_709_, v_n_704_);
lean_dec_ref(v_interestingStructures_709_);
if (v___x_714_ == 0)
{
lean_object* v___x_715_; lean_object* v___x_716_; 
v___x_715_ = lean_box(0);
v___x_716_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_716_, 0, v___x_715_);
return v___x_716_;
}
else
{
lean_object* v___x_717_; lean_object* v___x_718_; lean_object* v___x_719_; 
v___x_717_ = lean_box(v___x_714_);
v___x_718_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_718_, 0, v___x_717_);
v___x_719_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_719_, 0, v___x_718_);
return v___x_719_;
}
}
else
{
lean_object* v___x_720_; lean_object* v___x_721_; 
lean_dec_ref(v_interestingStructures_709_);
lean_dec(v_n_704_);
v___x_720_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__2));
v___x_721_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_721_, 0, v___x_720_);
return v___x_721_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___boxed(lean_object* v_n_722_, lean_object* v_a_723_, lean_object* v_a_724_){
_start:
{
lean_object* v_res_725_; 
v_res_725_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg(v_n_722_, v_a_723_);
lean_dec(v_a_723_);
return v_res_725_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure(lean_object* v_n_726_, lean_object* v_a_727_, lean_object* v_a_728_, lean_object* v_a_729_, lean_object* v_a_730_, lean_object* v_a_731_, lean_object* v_a_732_, lean_object* v_a_733_, lean_object* v_a_734_){
_start:
{
lean_object* v___x_736_; lean_object* v_typeAnalysis_737_; lean_object* v_interestingStructures_738_; lean_object* v_uninteresting_739_; lean_object* v___x_740_; lean_object* v___x_741_; uint8_t v___x_742_; 
v___x_736_ = lean_st_ref_get(v_a_728_);
v_typeAnalysis_737_ = lean_ctor_get(v___x_736_, 2);
lean_inc_ref(v_typeAnalysis_737_);
lean_dec(v___x_736_);
v_interestingStructures_738_ = lean_ctor_get(v_typeAnalysis_737_, 0);
lean_inc_ref(v_interestingStructures_738_);
v_uninteresting_739_ = lean_ctor_get(v_typeAnalysis_737_, 3);
lean_inc_ref(v_uninteresting_739_);
lean_dec_ref(v_typeAnalysis_737_);
v___x_740_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_741_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
lean_inc(v_n_726_);
v___x_742_ = l_Std_DHashMap_Internal_Raw_u2080_contains___redArg(v___x_740_, v___x_741_, v_uninteresting_739_, v_n_726_);
lean_dec_ref(v_uninteresting_739_);
if (v___x_742_ == 0)
{
uint8_t v___x_743_; 
v___x_743_ = l_Std_DHashMap_Internal_Raw_u2080_contains___redArg(v___x_740_, v___x_741_, v_interestingStructures_738_, v_n_726_);
lean_dec_ref(v_interestingStructures_738_);
if (v___x_743_ == 0)
{
lean_object* v___x_744_; lean_object* v___x_745_; 
v___x_744_ = lean_box(0);
v___x_745_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_745_, 0, v___x_744_);
return v___x_745_;
}
else
{
lean_object* v___x_746_; lean_object* v___x_747_; lean_object* v___x_748_; 
v___x_746_ = lean_box(v___x_743_);
v___x_747_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_747_, 0, v___x_746_);
v___x_748_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_748_, 0, v___x_747_);
return v___x_748_;
}
}
else
{
lean_object* v___x_749_; lean_object* v___x_750_; 
lean_dec_ref(v_interestingStructures_738_);
lean_dec(v_n_726_);
v___x_749_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__2));
v___x_750_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_750_, 0, v___x_749_);
return v___x_750_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___boxed(lean_object* v_n_751_, lean_object* v_a_752_, lean_object* v_a_753_, lean_object* v_a_754_, lean_object* v_a_755_, lean_object* v_a_756_, lean_object* v_a_757_, lean_object* v_a_758_, lean_object* v_a_759_, lean_object* v_a_760_){
_start:
{
lean_object* v_res_761_; 
v_res_761_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure(v_n_751_, v_a_752_, v_a_753_, v_a_754_, v_a_755_, v_a_756_, v_a_757_, v_a_758_, v_a_759_);
lean_dec(v_a_759_);
lean_dec_ref(v_a_758_);
lean_dec(v_a_757_);
lean_dec_ref(v_a_756_);
lean_dec(v_a_755_);
lean_dec_ref(v_a_754_);
lean_dec(v_a_753_);
lean_dec_ref(v_a_752_);
return v_res_761_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis___redArg(lean_object* v_f_762_, lean_object* v_a_763_){
_start:
{
lean_object* v___x_765_; lean_object* v_rewriteCache_766_; lean_object* v_acNfCache_767_; lean_object* v_typeAnalysis_768_; lean_object* v_goal_769_; lean_object* v_hypotheses_770_; uint8_t v_didChange_771_; lean_object* v___x_773_; uint8_t v_isShared_774_; uint8_t v_isSharedCheck_782_; 
v___x_765_ = lean_st_ref_take(v_a_763_);
v_rewriteCache_766_ = lean_ctor_get(v___x_765_, 0);
v_acNfCache_767_ = lean_ctor_get(v___x_765_, 1);
v_typeAnalysis_768_ = lean_ctor_get(v___x_765_, 2);
v_goal_769_ = lean_ctor_get(v___x_765_, 3);
v_hypotheses_770_ = lean_ctor_get(v___x_765_, 4);
v_didChange_771_ = lean_ctor_get_uint8(v___x_765_, sizeof(void*)*5);
v_isSharedCheck_782_ = !lean_is_exclusive(v___x_765_);
if (v_isSharedCheck_782_ == 0)
{
v___x_773_ = v___x_765_;
v_isShared_774_ = v_isSharedCheck_782_;
goto v_resetjp_772_;
}
else
{
lean_inc(v_hypotheses_770_);
lean_inc(v_goal_769_);
lean_inc(v_typeAnalysis_768_);
lean_inc(v_acNfCache_767_);
lean_inc(v_rewriteCache_766_);
lean_dec(v___x_765_);
v___x_773_ = lean_box(0);
v_isShared_774_ = v_isSharedCheck_782_;
goto v_resetjp_772_;
}
v_resetjp_772_:
{
lean_object* v___x_775_; lean_object* v___x_777_; 
v___x_775_ = lean_apply_1(v_f_762_, v_typeAnalysis_768_);
if (v_isShared_774_ == 0)
{
lean_ctor_set(v___x_773_, 2, v___x_775_);
v___x_777_ = v___x_773_;
goto v_reusejp_776_;
}
else
{
lean_object* v_reuseFailAlloc_781_; 
v_reuseFailAlloc_781_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_781_, 0, v_rewriteCache_766_);
lean_ctor_set(v_reuseFailAlloc_781_, 1, v_acNfCache_767_);
lean_ctor_set(v_reuseFailAlloc_781_, 2, v___x_775_);
lean_ctor_set(v_reuseFailAlloc_781_, 3, v_goal_769_);
lean_ctor_set(v_reuseFailAlloc_781_, 4, v_hypotheses_770_);
lean_ctor_set_uint8(v_reuseFailAlloc_781_, sizeof(void*)*5, v_didChange_771_);
v___x_777_ = v_reuseFailAlloc_781_;
goto v_reusejp_776_;
}
v_reusejp_776_:
{
lean_object* v___x_778_; lean_object* v___x_779_; lean_object* v___x_780_; 
v___x_778_ = lean_st_ref_set(v_a_763_, v___x_777_);
v___x_779_ = lean_box(0);
v___x_780_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_780_, 0, v___x_779_);
return v___x_780_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis___redArg___boxed(lean_object* v_f_783_, lean_object* v_a_784_, lean_object* v_a_785_){
_start:
{
lean_object* v_res_786_; 
v_res_786_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis___redArg(v_f_783_, v_a_784_);
lean_dec(v_a_784_);
return v_res_786_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis(lean_object* v_f_787_, lean_object* v_a_788_, lean_object* v_a_789_, lean_object* v_a_790_, lean_object* v_a_791_, lean_object* v_a_792_, lean_object* v_a_793_, lean_object* v_a_794_, lean_object* v_a_795_){
_start:
{
lean_object* v___x_797_; lean_object* v_rewriteCache_798_; lean_object* v_acNfCache_799_; lean_object* v_typeAnalysis_800_; lean_object* v_goal_801_; lean_object* v_hypotheses_802_; uint8_t v_didChange_803_; lean_object* v___x_805_; uint8_t v_isShared_806_; uint8_t v_isSharedCheck_814_; 
v___x_797_ = lean_st_ref_take(v_a_789_);
v_rewriteCache_798_ = lean_ctor_get(v___x_797_, 0);
v_acNfCache_799_ = lean_ctor_get(v___x_797_, 1);
v_typeAnalysis_800_ = lean_ctor_get(v___x_797_, 2);
v_goal_801_ = lean_ctor_get(v___x_797_, 3);
v_hypotheses_802_ = lean_ctor_get(v___x_797_, 4);
v_didChange_803_ = lean_ctor_get_uint8(v___x_797_, sizeof(void*)*5);
v_isSharedCheck_814_ = !lean_is_exclusive(v___x_797_);
if (v_isSharedCheck_814_ == 0)
{
v___x_805_ = v___x_797_;
v_isShared_806_ = v_isSharedCheck_814_;
goto v_resetjp_804_;
}
else
{
lean_inc(v_hypotheses_802_);
lean_inc(v_goal_801_);
lean_inc(v_typeAnalysis_800_);
lean_inc(v_acNfCache_799_);
lean_inc(v_rewriteCache_798_);
lean_dec(v___x_797_);
v___x_805_ = lean_box(0);
v_isShared_806_ = v_isSharedCheck_814_;
goto v_resetjp_804_;
}
v_resetjp_804_:
{
lean_object* v___x_807_; lean_object* v___x_809_; 
v___x_807_ = lean_apply_1(v_f_787_, v_typeAnalysis_800_);
if (v_isShared_806_ == 0)
{
lean_ctor_set(v___x_805_, 2, v___x_807_);
v___x_809_ = v___x_805_;
goto v_reusejp_808_;
}
else
{
lean_object* v_reuseFailAlloc_813_; 
v_reuseFailAlloc_813_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_813_, 0, v_rewriteCache_798_);
lean_ctor_set(v_reuseFailAlloc_813_, 1, v_acNfCache_799_);
lean_ctor_set(v_reuseFailAlloc_813_, 2, v___x_807_);
lean_ctor_set(v_reuseFailAlloc_813_, 3, v_goal_801_);
lean_ctor_set(v_reuseFailAlloc_813_, 4, v_hypotheses_802_);
lean_ctor_set_uint8(v_reuseFailAlloc_813_, sizeof(void*)*5, v_didChange_803_);
v___x_809_ = v_reuseFailAlloc_813_;
goto v_reusejp_808_;
}
v_reusejp_808_:
{
lean_object* v___x_810_; lean_object* v___x_811_; lean_object* v___x_812_; 
v___x_810_ = lean_st_ref_set(v_a_789_, v___x_809_);
v___x_811_ = lean_box(0);
v___x_812_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_812_, 0, v___x_811_);
return v___x_812_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis___boxed(lean_object* v_f_815_, lean_object* v_a_816_, lean_object* v_a_817_, lean_object* v_a_818_, lean_object* v_a_819_, lean_object* v_a_820_, lean_object* v_a_821_, lean_object* v_a_822_, lean_object* v_a_823_, lean_object* v_a_824_){
_start:
{
lean_object* v_res_825_; 
v_res_825_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_modifyTypeAnalysis(v_f_815_, v_a_816_, v_a_817_, v_a_818_, v_a_819_, v_a_820_, v_a_821_, v_a_822_, v_a_823_);
lean_dec(v_a_823_);
lean_dec_ref(v_a_822_);
lean_dec(v_a_821_);
lean_dec_ref(v_a_820_);
lean_dec(v_a_819_);
lean_dec_ref(v_a_818_);
lean_dec(v_a_817_);
lean_dec_ref(v_a_816_);
return v_res_825_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure___redArg(lean_object* v_n_826_, lean_object* v_a_827_){
_start:
{
lean_object* v___x_829_; lean_object* v_typeAnalysis_830_; lean_object* v_rewriteCache_831_; lean_object* v_acNfCache_832_; lean_object* v_goal_833_; lean_object* v_hypotheses_834_; uint8_t v_didChange_835_; lean_object* v___x_837_; uint8_t v_isShared_838_; uint8_t v_isSharedCheck_859_; 
v___x_829_ = lean_st_ref_take(v_a_827_);
v_typeAnalysis_830_ = lean_ctor_get(v___x_829_, 2);
v_rewriteCache_831_ = lean_ctor_get(v___x_829_, 0);
v_acNfCache_832_ = lean_ctor_get(v___x_829_, 1);
v_goal_833_ = lean_ctor_get(v___x_829_, 3);
v_hypotheses_834_ = lean_ctor_get(v___x_829_, 4);
v_didChange_835_ = lean_ctor_get_uint8(v___x_829_, sizeof(void*)*5);
v_isSharedCheck_859_ = !lean_is_exclusive(v___x_829_);
if (v_isSharedCheck_859_ == 0)
{
v___x_837_ = v___x_829_;
v_isShared_838_ = v_isSharedCheck_859_;
goto v_resetjp_836_;
}
else
{
lean_inc(v_hypotheses_834_);
lean_inc(v_goal_833_);
lean_inc(v_typeAnalysis_830_);
lean_inc(v_acNfCache_832_);
lean_inc(v_rewriteCache_831_);
lean_dec(v___x_829_);
v___x_837_ = lean_box(0);
v_isShared_838_ = v_isSharedCheck_859_;
goto v_resetjp_836_;
}
v_resetjp_836_:
{
lean_object* v_interestingStructures_839_; lean_object* v_interestingEnums_840_; lean_object* v_interestingMatchers_841_; lean_object* v_uninteresting_842_; lean_object* v___x_844_; uint8_t v_isShared_845_; uint8_t v_isSharedCheck_858_; 
v_interestingStructures_839_ = lean_ctor_get(v_typeAnalysis_830_, 0);
v_interestingEnums_840_ = lean_ctor_get(v_typeAnalysis_830_, 1);
v_interestingMatchers_841_ = lean_ctor_get(v_typeAnalysis_830_, 2);
v_uninteresting_842_ = lean_ctor_get(v_typeAnalysis_830_, 3);
v_isSharedCheck_858_ = !lean_is_exclusive(v_typeAnalysis_830_);
if (v_isSharedCheck_858_ == 0)
{
v___x_844_ = v_typeAnalysis_830_;
v_isShared_845_ = v_isSharedCheck_858_;
goto v_resetjp_843_;
}
else
{
lean_inc(v_uninteresting_842_);
lean_inc(v_interestingMatchers_841_);
lean_inc(v_interestingEnums_840_);
lean_inc(v_interestingStructures_839_);
lean_dec(v_typeAnalysis_830_);
v___x_844_ = lean_box(0);
v_isShared_845_ = v_isSharedCheck_858_;
goto v_resetjp_843_;
}
v_resetjp_843_:
{
lean_object* v___x_846_; lean_object* v___x_847_; lean_object* v___x_848_; lean_object* v___x_849_; lean_object* v___x_851_; 
v___x_846_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_847_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
v___x_848_ = lean_box(0);
v___x_849_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_846_, v___x_847_, v_interestingStructures_839_, v_n_826_, v___x_848_);
if (v_isShared_845_ == 0)
{
lean_ctor_set(v___x_844_, 0, v___x_849_);
v___x_851_ = v___x_844_;
goto v_reusejp_850_;
}
else
{
lean_object* v_reuseFailAlloc_857_; 
v_reuseFailAlloc_857_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_857_, 0, v___x_849_);
lean_ctor_set(v_reuseFailAlloc_857_, 1, v_interestingEnums_840_);
lean_ctor_set(v_reuseFailAlloc_857_, 2, v_interestingMatchers_841_);
lean_ctor_set(v_reuseFailAlloc_857_, 3, v_uninteresting_842_);
v___x_851_ = v_reuseFailAlloc_857_;
goto v_reusejp_850_;
}
v_reusejp_850_:
{
lean_object* v___x_853_; 
if (v_isShared_838_ == 0)
{
lean_ctor_set(v___x_837_, 2, v___x_851_);
v___x_853_ = v___x_837_;
goto v_reusejp_852_;
}
else
{
lean_object* v_reuseFailAlloc_856_; 
v_reuseFailAlloc_856_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_856_, 0, v_rewriteCache_831_);
lean_ctor_set(v_reuseFailAlloc_856_, 1, v_acNfCache_832_);
lean_ctor_set(v_reuseFailAlloc_856_, 2, v___x_851_);
lean_ctor_set(v_reuseFailAlloc_856_, 3, v_goal_833_);
lean_ctor_set(v_reuseFailAlloc_856_, 4, v_hypotheses_834_);
lean_ctor_set_uint8(v_reuseFailAlloc_856_, sizeof(void*)*5, v_didChange_835_);
v___x_853_ = v_reuseFailAlloc_856_;
goto v_reusejp_852_;
}
v_reusejp_852_:
{
lean_object* v___x_854_; lean_object* v___x_855_; 
v___x_854_ = lean_st_ref_set(v_a_827_, v___x_853_);
v___x_855_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_855_, 0, v___x_848_);
return v___x_855_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure___redArg___boxed(lean_object* v_n_860_, lean_object* v_a_861_, lean_object* v_a_862_){
_start:
{
lean_object* v_res_863_; 
v_res_863_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure___redArg(v_n_860_, v_a_861_);
lean_dec(v_a_861_);
return v_res_863_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure(lean_object* v_n_864_, lean_object* v_a_865_, lean_object* v_a_866_, lean_object* v_a_867_, lean_object* v_a_868_, lean_object* v_a_869_, lean_object* v_a_870_, lean_object* v_a_871_, lean_object* v_a_872_){
_start:
{
lean_object* v___x_874_; lean_object* v_typeAnalysis_875_; lean_object* v_rewriteCache_876_; lean_object* v_acNfCache_877_; lean_object* v_goal_878_; lean_object* v_hypotheses_879_; uint8_t v_didChange_880_; lean_object* v___x_882_; uint8_t v_isShared_883_; uint8_t v_isSharedCheck_904_; 
v___x_874_ = lean_st_ref_take(v_a_866_);
v_typeAnalysis_875_ = lean_ctor_get(v___x_874_, 2);
v_rewriteCache_876_ = lean_ctor_get(v___x_874_, 0);
v_acNfCache_877_ = lean_ctor_get(v___x_874_, 1);
v_goal_878_ = lean_ctor_get(v___x_874_, 3);
v_hypotheses_879_ = lean_ctor_get(v___x_874_, 4);
v_didChange_880_ = lean_ctor_get_uint8(v___x_874_, sizeof(void*)*5);
v_isSharedCheck_904_ = !lean_is_exclusive(v___x_874_);
if (v_isSharedCheck_904_ == 0)
{
v___x_882_ = v___x_874_;
v_isShared_883_ = v_isSharedCheck_904_;
goto v_resetjp_881_;
}
else
{
lean_inc(v_hypotheses_879_);
lean_inc(v_goal_878_);
lean_inc(v_typeAnalysis_875_);
lean_inc(v_acNfCache_877_);
lean_inc(v_rewriteCache_876_);
lean_dec(v___x_874_);
v___x_882_ = lean_box(0);
v_isShared_883_ = v_isSharedCheck_904_;
goto v_resetjp_881_;
}
v_resetjp_881_:
{
lean_object* v_interestingStructures_884_; lean_object* v_interestingEnums_885_; lean_object* v_interestingMatchers_886_; lean_object* v_uninteresting_887_; lean_object* v___x_889_; uint8_t v_isShared_890_; uint8_t v_isSharedCheck_903_; 
v_interestingStructures_884_ = lean_ctor_get(v_typeAnalysis_875_, 0);
v_interestingEnums_885_ = lean_ctor_get(v_typeAnalysis_875_, 1);
v_interestingMatchers_886_ = lean_ctor_get(v_typeAnalysis_875_, 2);
v_uninteresting_887_ = lean_ctor_get(v_typeAnalysis_875_, 3);
v_isSharedCheck_903_ = !lean_is_exclusive(v_typeAnalysis_875_);
if (v_isSharedCheck_903_ == 0)
{
v___x_889_ = v_typeAnalysis_875_;
v_isShared_890_ = v_isSharedCheck_903_;
goto v_resetjp_888_;
}
else
{
lean_inc(v_uninteresting_887_);
lean_inc(v_interestingMatchers_886_);
lean_inc(v_interestingEnums_885_);
lean_inc(v_interestingStructures_884_);
lean_dec(v_typeAnalysis_875_);
v___x_889_ = lean_box(0);
v_isShared_890_ = v_isSharedCheck_903_;
goto v_resetjp_888_;
}
v_resetjp_888_:
{
lean_object* v___x_891_; lean_object* v___x_892_; lean_object* v___x_893_; lean_object* v___x_894_; lean_object* v___x_896_; 
v___x_891_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_892_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
v___x_893_ = lean_box(0);
v___x_894_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_891_, v___x_892_, v_interestingStructures_884_, v_n_864_, v___x_893_);
if (v_isShared_890_ == 0)
{
lean_ctor_set(v___x_889_, 0, v___x_894_);
v___x_896_ = v___x_889_;
goto v_reusejp_895_;
}
else
{
lean_object* v_reuseFailAlloc_902_; 
v_reuseFailAlloc_902_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_902_, 0, v___x_894_);
lean_ctor_set(v_reuseFailAlloc_902_, 1, v_interestingEnums_885_);
lean_ctor_set(v_reuseFailAlloc_902_, 2, v_interestingMatchers_886_);
lean_ctor_set(v_reuseFailAlloc_902_, 3, v_uninteresting_887_);
v___x_896_ = v_reuseFailAlloc_902_;
goto v_reusejp_895_;
}
v_reusejp_895_:
{
lean_object* v___x_898_; 
if (v_isShared_883_ == 0)
{
lean_ctor_set(v___x_882_, 2, v___x_896_);
v___x_898_ = v___x_882_;
goto v_reusejp_897_;
}
else
{
lean_object* v_reuseFailAlloc_901_; 
v_reuseFailAlloc_901_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_901_, 0, v_rewriteCache_876_);
lean_ctor_set(v_reuseFailAlloc_901_, 1, v_acNfCache_877_);
lean_ctor_set(v_reuseFailAlloc_901_, 2, v___x_896_);
lean_ctor_set(v_reuseFailAlloc_901_, 3, v_goal_878_);
lean_ctor_set(v_reuseFailAlloc_901_, 4, v_hypotheses_879_);
lean_ctor_set_uint8(v_reuseFailAlloc_901_, sizeof(void*)*5, v_didChange_880_);
v___x_898_ = v_reuseFailAlloc_901_;
goto v_reusejp_897_;
}
v_reusejp_897_:
{
lean_object* v___x_899_; lean_object* v___x_900_; 
v___x_899_ = lean_st_ref_set(v_a_866_, v___x_898_);
v___x_900_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_900_, 0, v___x_893_);
return v___x_900_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure___boxed(lean_object* v_n_905_, lean_object* v_a_906_, lean_object* v_a_907_, lean_object* v_a_908_, lean_object* v_a_909_, lean_object* v_a_910_, lean_object* v_a_911_, lean_object* v_a_912_, lean_object* v_a_913_, lean_object* v_a_914_){
_start:
{
lean_object* v_res_915_; 
v_res_915_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingStructure(v_n_905_, v_a_906_, v_a_907_, v_a_908_, v_a_909_, v_a_910_, v_a_911_, v_a_912_, v_a_913_);
lean_dec(v_a_913_);
lean_dec_ref(v_a_912_);
lean_dec(v_a_911_);
lean_dec_ref(v_a_910_);
lean_dec(v_a_909_);
lean_dec_ref(v_a_908_);
lean_dec(v_a_907_);
lean_dec_ref(v_a_906_);
return v_res_915_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum___redArg(lean_object* v_n_916_, lean_object* v_a_917_){
_start:
{
lean_object* v___x_919_; lean_object* v_typeAnalysis_920_; lean_object* v_rewriteCache_921_; lean_object* v_acNfCache_922_; lean_object* v_goal_923_; lean_object* v_hypotheses_924_; uint8_t v_didChange_925_; lean_object* v___x_927_; uint8_t v_isShared_928_; uint8_t v_isSharedCheck_949_; 
v___x_919_ = lean_st_ref_take(v_a_917_);
v_typeAnalysis_920_ = lean_ctor_get(v___x_919_, 2);
v_rewriteCache_921_ = lean_ctor_get(v___x_919_, 0);
v_acNfCache_922_ = lean_ctor_get(v___x_919_, 1);
v_goal_923_ = lean_ctor_get(v___x_919_, 3);
v_hypotheses_924_ = lean_ctor_get(v___x_919_, 4);
v_didChange_925_ = lean_ctor_get_uint8(v___x_919_, sizeof(void*)*5);
v_isSharedCheck_949_ = !lean_is_exclusive(v___x_919_);
if (v_isSharedCheck_949_ == 0)
{
v___x_927_ = v___x_919_;
v_isShared_928_ = v_isSharedCheck_949_;
goto v_resetjp_926_;
}
else
{
lean_inc(v_hypotheses_924_);
lean_inc(v_goal_923_);
lean_inc(v_typeAnalysis_920_);
lean_inc(v_acNfCache_922_);
lean_inc(v_rewriteCache_921_);
lean_dec(v___x_919_);
v___x_927_ = lean_box(0);
v_isShared_928_ = v_isSharedCheck_949_;
goto v_resetjp_926_;
}
v_resetjp_926_:
{
lean_object* v_interestingStructures_929_; lean_object* v_interestingEnums_930_; lean_object* v_interestingMatchers_931_; lean_object* v_uninteresting_932_; lean_object* v___x_934_; uint8_t v_isShared_935_; uint8_t v_isSharedCheck_948_; 
v_interestingStructures_929_ = lean_ctor_get(v_typeAnalysis_920_, 0);
v_interestingEnums_930_ = lean_ctor_get(v_typeAnalysis_920_, 1);
v_interestingMatchers_931_ = lean_ctor_get(v_typeAnalysis_920_, 2);
v_uninteresting_932_ = lean_ctor_get(v_typeAnalysis_920_, 3);
v_isSharedCheck_948_ = !lean_is_exclusive(v_typeAnalysis_920_);
if (v_isSharedCheck_948_ == 0)
{
v___x_934_ = v_typeAnalysis_920_;
v_isShared_935_ = v_isSharedCheck_948_;
goto v_resetjp_933_;
}
else
{
lean_inc(v_uninteresting_932_);
lean_inc(v_interestingMatchers_931_);
lean_inc(v_interestingEnums_930_);
lean_inc(v_interestingStructures_929_);
lean_dec(v_typeAnalysis_920_);
v___x_934_ = lean_box(0);
v_isShared_935_ = v_isSharedCheck_948_;
goto v_resetjp_933_;
}
v_resetjp_933_:
{
lean_object* v___x_936_; lean_object* v___x_937_; lean_object* v___x_938_; lean_object* v___x_939_; lean_object* v___x_941_; 
v___x_936_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_937_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
v___x_938_ = lean_box(0);
v___x_939_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_936_, v___x_937_, v_interestingEnums_930_, v_n_916_, v___x_938_);
if (v_isShared_935_ == 0)
{
lean_ctor_set(v___x_934_, 1, v___x_939_);
v___x_941_ = v___x_934_;
goto v_reusejp_940_;
}
else
{
lean_object* v_reuseFailAlloc_947_; 
v_reuseFailAlloc_947_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_947_, 0, v_interestingStructures_929_);
lean_ctor_set(v_reuseFailAlloc_947_, 1, v___x_939_);
lean_ctor_set(v_reuseFailAlloc_947_, 2, v_interestingMatchers_931_);
lean_ctor_set(v_reuseFailAlloc_947_, 3, v_uninteresting_932_);
v___x_941_ = v_reuseFailAlloc_947_;
goto v_reusejp_940_;
}
v_reusejp_940_:
{
lean_object* v___x_943_; 
if (v_isShared_928_ == 0)
{
lean_ctor_set(v___x_927_, 2, v___x_941_);
v___x_943_ = v___x_927_;
goto v_reusejp_942_;
}
else
{
lean_object* v_reuseFailAlloc_946_; 
v_reuseFailAlloc_946_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_946_, 0, v_rewriteCache_921_);
lean_ctor_set(v_reuseFailAlloc_946_, 1, v_acNfCache_922_);
lean_ctor_set(v_reuseFailAlloc_946_, 2, v___x_941_);
lean_ctor_set(v_reuseFailAlloc_946_, 3, v_goal_923_);
lean_ctor_set(v_reuseFailAlloc_946_, 4, v_hypotheses_924_);
lean_ctor_set_uint8(v_reuseFailAlloc_946_, sizeof(void*)*5, v_didChange_925_);
v___x_943_ = v_reuseFailAlloc_946_;
goto v_reusejp_942_;
}
v_reusejp_942_:
{
lean_object* v___x_944_; lean_object* v___x_945_; 
v___x_944_ = lean_st_ref_set(v_a_917_, v___x_943_);
v___x_945_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_945_, 0, v___x_938_);
return v___x_945_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum___redArg___boxed(lean_object* v_n_950_, lean_object* v_a_951_, lean_object* v_a_952_){
_start:
{
lean_object* v_res_953_; 
v_res_953_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum___redArg(v_n_950_, v_a_951_);
lean_dec(v_a_951_);
return v_res_953_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum(lean_object* v_n_954_, lean_object* v_a_955_, lean_object* v_a_956_, lean_object* v_a_957_, lean_object* v_a_958_, lean_object* v_a_959_, lean_object* v_a_960_, lean_object* v_a_961_, lean_object* v_a_962_){
_start:
{
lean_object* v___x_964_; lean_object* v_typeAnalysis_965_; lean_object* v_rewriteCache_966_; lean_object* v_acNfCache_967_; lean_object* v_goal_968_; lean_object* v_hypotheses_969_; uint8_t v_didChange_970_; lean_object* v___x_972_; uint8_t v_isShared_973_; uint8_t v_isSharedCheck_994_; 
v___x_964_ = lean_st_ref_take(v_a_956_);
v_typeAnalysis_965_ = lean_ctor_get(v___x_964_, 2);
v_rewriteCache_966_ = lean_ctor_get(v___x_964_, 0);
v_acNfCache_967_ = lean_ctor_get(v___x_964_, 1);
v_goal_968_ = lean_ctor_get(v___x_964_, 3);
v_hypotheses_969_ = lean_ctor_get(v___x_964_, 4);
v_didChange_970_ = lean_ctor_get_uint8(v___x_964_, sizeof(void*)*5);
v_isSharedCheck_994_ = !lean_is_exclusive(v___x_964_);
if (v_isSharedCheck_994_ == 0)
{
v___x_972_ = v___x_964_;
v_isShared_973_ = v_isSharedCheck_994_;
goto v_resetjp_971_;
}
else
{
lean_inc(v_hypotheses_969_);
lean_inc(v_goal_968_);
lean_inc(v_typeAnalysis_965_);
lean_inc(v_acNfCache_967_);
lean_inc(v_rewriteCache_966_);
lean_dec(v___x_964_);
v___x_972_ = lean_box(0);
v_isShared_973_ = v_isSharedCheck_994_;
goto v_resetjp_971_;
}
v_resetjp_971_:
{
lean_object* v_interestingStructures_974_; lean_object* v_interestingEnums_975_; lean_object* v_interestingMatchers_976_; lean_object* v_uninteresting_977_; lean_object* v___x_979_; uint8_t v_isShared_980_; uint8_t v_isSharedCheck_993_; 
v_interestingStructures_974_ = lean_ctor_get(v_typeAnalysis_965_, 0);
v_interestingEnums_975_ = lean_ctor_get(v_typeAnalysis_965_, 1);
v_interestingMatchers_976_ = lean_ctor_get(v_typeAnalysis_965_, 2);
v_uninteresting_977_ = lean_ctor_get(v_typeAnalysis_965_, 3);
v_isSharedCheck_993_ = !lean_is_exclusive(v_typeAnalysis_965_);
if (v_isSharedCheck_993_ == 0)
{
v___x_979_ = v_typeAnalysis_965_;
v_isShared_980_ = v_isSharedCheck_993_;
goto v_resetjp_978_;
}
else
{
lean_inc(v_uninteresting_977_);
lean_inc(v_interestingMatchers_976_);
lean_inc(v_interestingEnums_975_);
lean_inc(v_interestingStructures_974_);
lean_dec(v_typeAnalysis_965_);
v___x_979_ = lean_box(0);
v_isShared_980_ = v_isSharedCheck_993_;
goto v_resetjp_978_;
}
v_resetjp_978_:
{
lean_object* v___x_981_; lean_object* v___x_982_; lean_object* v___x_983_; lean_object* v___x_984_; lean_object* v___x_986_; 
v___x_981_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_982_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
v___x_983_ = lean_box(0);
v___x_984_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_981_, v___x_982_, v_interestingEnums_975_, v_n_954_, v___x_983_);
if (v_isShared_980_ == 0)
{
lean_ctor_set(v___x_979_, 1, v___x_984_);
v___x_986_ = v___x_979_;
goto v_reusejp_985_;
}
else
{
lean_object* v_reuseFailAlloc_992_; 
v_reuseFailAlloc_992_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_992_, 0, v_interestingStructures_974_);
lean_ctor_set(v_reuseFailAlloc_992_, 1, v___x_984_);
lean_ctor_set(v_reuseFailAlloc_992_, 2, v_interestingMatchers_976_);
lean_ctor_set(v_reuseFailAlloc_992_, 3, v_uninteresting_977_);
v___x_986_ = v_reuseFailAlloc_992_;
goto v_reusejp_985_;
}
v_reusejp_985_:
{
lean_object* v___x_988_; 
if (v_isShared_973_ == 0)
{
lean_ctor_set(v___x_972_, 2, v___x_986_);
v___x_988_ = v___x_972_;
goto v_reusejp_987_;
}
else
{
lean_object* v_reuseFailAlloc_991_; 
v_reuseFailAlloc_991_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_991_, 0, v_rewriteCache_966_);
lean_ctor_set(v_reuseFailAlloc_991_, 1, v_acNfCache_967_);
lean_ctor_set(v_reuseFailAlloc_991_, 2, v___x_986_);
lean_ctor_set(v_reuseFailAlloc_991_, 3, v_goal_968_);
lean_ctor_set(v_reuseFailAlloc_991_, 4, v_hypotheses_969_);
lean_ctor_set_uint8(v_reuseFailAlloc_991_, sizeof(void*)*5, v_didChange_970_);
v___x_988_ = v_reuseFailAlloc_991_;
goto v_reusejp_987_;
}
v_reusejp_987_:
{
lean_object* v___x_989_; lean_object* v___x_990_; 
v___x_989_ = lean_st_ref_set(v_a_956_, v___x_988_);
v___x_990_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_990_, 0, v___x_983_);
return v___x_990_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum___boxed(lean_object* v_n_995_, lean_object* v_a_996_, lean_object* v_a_997_, lean_object* v_a_998_, lean_object* v_a_999_, lean_object* v_a_1000_, lean_object* v_a_1001_, lean_object* v_a_1002_, lean_object* v_a_1003_, lean_object* v_a_1004_){
_start:
{
lean_object* v_res_1005_; 
v_res_1005_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingEnum(v_n_995_, v_a_996_, v_a_997_, v_a_998_, v_a_999_, v_a_1000_, v_a_1001_, v_a_1002_, v_a_1003_);
lean_dec(v_a_1003_);
lean_dec_ref(v_a_1002_);
lean_dec(v_a_1001_);
lean_dec_ref(v_a_1000_);
lean_dec(v_a_999_);
lean_dec_ref(v_a_998_);
lean_dec(v_a_997_);
lean_dec_ref(v_a_996_);
return v_res_1005_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher___redArg(lean_object* v_n_1006_, lean_object* v_k_1007_, lean_object* v_a_1008_){
_start:
{
lean_object* v___x_1010_; lean_object* v_typeAnalysis_1011_; lean_object* v_rewriteCache_1012_; lean_object* v_acNfCache_1013_; lean_object* v_goal_1014_; lean_object* v_hypotheses_1015_; uint8_t v_didChange_1016_; lean_object* v___x_1018_; uint8_t v_isShared_1019_; uint8_t v_isSharedCheck_1040_; 
v___x_1010_ = lean_st_ref_take(v_a_1008_);
v_typeAnalysis_1011_ = lean_ctor_get(v___x_1010_, 2);
v_rewriteCache_1012_ = lean_ctor_get(v___x_1010_, 0);
v_acNfCache_1013_ = lean_ctor_get(v___x_1010_, 1);
v_goal_1014_ = lean_ctor_get(v___x_1010_, 3);
v_hypotheses_1015_ = lean_ctor_get(v___x_1010_, 4);
v_didChange_1016_ = lean_ctor_get_uint8(v___x_1010_, sizeof(void*)*5);
v_isSharedCheck_1040_ = !lean_is_exclusive(v___x_1010_);
if (v_isSharedCheck_1040_ == 0)
{
v___x_1018_ = v___x_1010_;
v_isShared_1019_ = v_isSharedCheck_1040_;
goto v_resetjp_1017_;
}
else
{
lean_inc(v_hypotheses_1015_);
lean_inc(v_goal_1014_);
lean_inc(v_typeAnalysis_1011_);
lean_inc(v_acNfCache_1013_);
lean_inc(v_rewriteCache_1012_);
lean_dec(v___x_1010_);
v___x_1018_ = lean_box(0);
v_isShared_1019_ = v_isSharedCheck_1040_;
goto v_resetjp_1017_;
}
v_resetjp_1017_:
{
lean_object* v_interestingStructures_1020_; lean_object* v_interestingEnums_1021_; lean_object* v_interestingMatchers_1022_; lean_object* v_uninteresting_1023_; lean_object* v___x_1025_; uint8_t v_isShared_1026_; uint8_t v_isSharedCheck_1039_; 
v_interestingStructures_1020_ = lean_ctor_get(v_typeAnalysis_1011_, 0);
v_interestingEnums_1021_ = lean_ctor_get(v_typeAnalysis_1011_, 1);
v_interestingMatchers_1022_ = lean_ctor_get(v_typeAnalysis_1011_, 2);
v_uninteresting_1023_ = lean_ctor_get(v_typeAnalysis_1011_, 3);
v_isSharedCheck_1039_ = !lean_is_exclusive(v_typeAnalysis_1011_);
if (v_isSharedCheck_1039_ == 0)
{
v___x_1025_ = v_typeAnalysis_1011_;
v_isShared_1026_ = v_isSharedCheck_1039_;
goto v_resetjp_1024_;
}
else
{
lean_inc(v_uninteresting_1023_);
lean_inc(v_interestingMatchers_1022_);
lean_inc(v_interestingEnums_1021_);
lean_inc(v_interestingStructures_1020_);
lean_dec(v_typeAnalysis_1011_);
v___x_1025_ = lean_box(0);
v_isShared_1026_ = v_isSharedCheck_1039_;
goto v_resetjp_1024_;
}
v_resetjp_1024_:
{
lean_object* v___x_1027_; lean_object* v___x_1028_; lean_object* v___x_1029_; lean_object* v___x_1031_; 
v___x_1027_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_1028_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
v___x_1029_ = l_Std_DHashMap_Internal_Raw_u2080_insert___redArg(v___x_1027_, v___x_1028_, v_interestingMatchers_1022_, v_n_1006_, v_k_1007_);
if (v_isShared_1026_ == 0)
{
lean_ctor_set(v___x_1025_, 2, v___x_1029_);
v___x_1031_ = v___x_1025_;
goto v_reusejp_1030_;
}
else
{
lean_object* v_reuseFailAlloc_1038_; 
v_reuseFailAlloc_1038_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_1038_, 0, v_interestingStructures_1020_);
lean_ctor_set(v_reuseFailAlloc_1038_, 1, v_interestingEnums_1021_);
lean_ctor_set(v_reuseFailAlloc_1038_, 2, v___x_1029_);
lean_ctor_set(v_reuseFailAlloc_1038_, 3, v_uninteresting_1023_);
v___x_1031_ = v_reuseFailAlloc_1038_;
goto v_reusejp_1030_;
}
v_reusejp_1030_:
{
lean_object* v___x_1033_; 
if (v_isShared_1019_ == 0)
{
lean_ctor_set(v___x_1018_, 2, v___x_1031_);
v___x_1033_ = v___x_1018_;
goto v_reusejp_1032_;
}
else
{
lean_object* v_reuseFailAlloc_1037_; 
v_reuseFailAlloc_1037_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_1037_, 0, v_rewriteCache_1012_);
lean_ctor_set(v_reuseFailAlloc_1037_, 1, v_acNfCache_1013_);
lean_ctor_set(v_reuseFailAlloc_1037_, 2, v___x_1031_);
lean_ctor_set(v_reuseFailAlloc_1037_, 3, v_goal_1014_);
lean_ctor_set(v_reuseFailAlloc_1037_, 4, v_hypotheses_1015_);
lean_ctor_set_uint8(v_reuseFailAlloc_1037_, sizeof(void*)*5, v_didChange_1016_);
v___x_1033_ = v_reuseFailAlloc_1037_;
goto v_reusejp_1032_;
}
v_reusejp_1032_:
{
lean_object* v___x_1034_; lean_object* v___x_1035_; lean_object* v___x_1036_; 
v___x_1034_ = lean_st_ref_set(v_a_1008_, v___x_1033_);
v___x_1035_ = lean_box(0);
v___x_1036_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1036_, 0, v___x_1035_);
return v___x_1036_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher___redArg___boxed(lean_object* v_n_1041_, lean_object* v_k_1042_, lean_object* v_a_1043_, lean_object* v_a_1044_){
_start:
{
lean_object* v_res_1045_; 
v_res_1045_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher___redArg(v_n_1041_, v_k_1042_, v_a_1043_);
lean_dec(v_a_1043_);
return v_res_1045_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher(lean_object* v_n_1046_, lean_object* v_k_1047_, lean_object* v_a_1048_, lean_object* v_a_1049_, lean_object* v_a_1050_, lean_object* v_a_1051_, lean_object* v_a_1052_, lean_object* v_a_1053_, lean_object* v_a_1054_, lean_object* v_a_1055_){
_start:
{
lean_object* v___x_1057_; lean_object* v_typeAnalysis_1058_; lean_object* v_rewriteCache_1059_; lean_object* v_acNfCache_1060_; lean_object* v_goal_1061_; lean_object* v_hypotheses_1062_; uint8_t v_didChange_1063_; lean_object* v___x_1065_; uint8_t v_isShared_1066_; uint8_t v_isSharedCheck_1087_; 
v___x_1057_ = lean_st_ref_take(v_a_1049_);
v_typeAnalysis_1058_ = lean_ctor_get(v___x_1057_, 2);
v_rewriteCache_1059_ = lean_ctor_get(v___x_1057_, 0);
v_acNfCache_1060_ = lean_ctor_get(v___x_1057_, 1);
v_goal_1061_ = lean_ctor_get(v___x_1057_, 3);
v_hypotheses_1062_ = lean_ctor_get(v___x_1057_, 4);
v_didChange_1063_ = lean_ctor_get_uint8(v___x_1057_, sizeof(void*)*5);
v_isSharedCheck_1087_ = !lean_is_exclusive(v___x_1057_);
if (v_isSharedCheck_1087_ == 0)
{
v___x_1065_ = v___x_1057_;
v_isShared_1066_ = v_isSharedCheck_1087_;
goto v_resetjp_1064_;
}
else
{
lean_inc(v_hypotheses_1062_);
lean_inc(v_goal_1061_);
lean_inc(v_typeAnalysis_1058_);
lean_inc(v_acNfCache_1060_);
lean_inc(v_rewriteCache_1059_);
lean_dec(v___x_1057_);
v___x_1065_ = lean_box(0);
v_isShared_1066_ = v_isSharedCheck_1087_;
goto v_resetjp_1064_;
}
v_resetjp_1064_:
{
lean_object* v_interestingStructures_1067_; lean_object* v_interestingEnums_1068_; lean_object* v_interestingMatchers_1069_; lean_object* v_uninteresting_1070_; lean_object* v___x_1072_; uint8_t v_isShared_1073_; uint8_t v_isSharedCheck_1086_; 
v_interestingStructures_1067_ = lean_ctor_get(v_typeAnalysis_1058_, 0);
v_interestingEnums_1068_ = lean_ctor_get(v_typeAnalysis_1058_, 1);
v_interestingMatchers_1069_ = lean_ctor_get(v_typeAnalysis_1058_, 2);
v_uninteresting_1070_ = lean_ctor_get(v_typeAnalysis_1058_, 3);
v_isSharedCheck_1086_ = !lean_is_exclusive(v_typeAnalysis_1058_);
if (v_isSharedCheck_1086_ == 0)
{
v___x_1072_ = v_typeAnalysis_1058_;
v_isShared_1073_ = v_isSharedCheck_1086_;
goto v_resetjp_1071_;
}
else
{
lean_inc(v_uninteresting_1070_);
lean_inc(v_interestingMatchers_1069_);
lean_inc(v_interestingEnums_1068_);
lean_inc(v_interestingStructures_1067_);
lean_dec(v_typeAnalysis_1058_);
v___x_1072_ = lean_box(0);
v_isShared_1073_ = v_isSharedCheck_1086_;
goto v_resetjp_1071_;
}
v_resetjp_1071_:
{
lean_object* v___x_1074_; lean_object* v___x_1075_; lean_object* v___x_1076_; lean_object* v___x_1078_; 
v___x_1074_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_1075_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
v___x_1076_ = l_Std_DHashMap_Internal_Raw_u2080_insert___redArg(v___x_1074_, v___x_1075_, v_interestingMatchers_1069_, v_n_1046_, v_k_1047_);
if (v_isShared_1073_ == 0)
{
lean_ctor_set(v___x_1072_, 2, v___x_1076_);
v___x_1078_ = v___x_1072_;
goto v_reusejp_1077_;
}
else
{
lean_object* v_reuseFailAlloc_1085_; 
v_reuseFailAlloc_1085_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_1085_, 0, v_interestingStructures_1067_);
lean_ctor_set(v_reuseFailAlloc_1085_, 1, v_interestingEnums_1068_);
lean_ctor_set(v_reuseFailAlloc_1085_, 2, v___x_1076_);
lean_ctor_set(v_reuseFailAlloc_1085_, 3, v_uninteresting_1070_);
v___x_1078_ = v_reuseFailAlloc_1085_;
goto v_reusejp_1077_;
}
v_reusejp_1077_:
{
lean_object* v___x_1080_; 
if (v_isShared_1066_ == 0)
{
lean_ctor_set(v___x_1065_, 2, v___x_1078_);
v___x_1080_ = v___x_1065_;
goto v_reusejp_1079_;
}
else
{
lean_object* v_reuseFailAlloc_1084_; 
v_reuseFailAlloc_1084_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_1084_, 0, v_rewriteCache_1059_);
lean_ctor_set(v_reuseFailAlloc_1084_, 1, v_acNfCache_1060_);
lean_ctor_set(v_reuseFailAlloc_1084_, 2, v___x_1078_);
lean_ctor_set(v_reuseFailAlloc_1084_, 3, v_goal_1061_);
lean_ctor_set(v_reuseFailAlloc_1084_, 4, v_hypotheses_1062_);
lean_ctor_set_uint8(v_reuseFailAlloc_1084_, sizeof(void*)*5, v_didChange_1063_);
v___x_1080_ = v_reuseFailAlloc_1084_;
goto v_reusejp_1079_;
}
v_reusejp_1079_:
{
lean_object* v___x_1081_; lean_object* v___x_1082_; lean_object* v___x_1083_; 
v___x_1081_ = lean_st_ref_set(v_a_1049_, v___x_1080_);
v___x_1082_ = lean_box(0);
v___x_1083_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1083_, 0, v___x_1082_);
return v___x_1083_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher___boxed(lean_object* v_n_1088_, lean_object* v_k_1089_, lean_object* v_a_1090_, lean_object* v_a_1091_, lean_object* v_a_1092_, lean_object* v_a_1093_, lean_object* v_a_1094_, lean_object* v_a_1095_, lean_object* v_a_1096_, lean_object* v_a_1097_, lean_object* v_a_1098_){
_start:
{
lean_object* v_res_1099_; 
v_res_1099_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markInterestingMatcher(v_n_1088_, v_k_1089_, v_a_1090_, v_a_1091_, v_a_1092_, v_a_1093_, v_a_1094_, v_a_1095_, v_a_1096_, v_a_1097_);
lean_dec(v_a_1097_);
lean_dec_ref(v_a_1096_);
lean_dec(v_a_1095_);
lean_dec_ref(v_a_1094_);
lean_dec(v_a_1093_);
lean_dec_ref(v_a_1092_);
lean_dec(v_a_1091_);
lean_dec_ref(v_a_1090_);
return v_res_1099_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst___redArg(lean_object* v_n_1100_, lean_object* v_a_1101_){
_start:
{
lean_object* v___x_1103_; lean_object* v_typeAnalysis_1104_; lean_object* v_rewriteCache_1105_; lean_object* v_acNfCache_1106_; lean_object* v_goal_1107_; lean_object* v_hypotheses_1108_; uint8_t v_didChange_1109_; lean_object* v___x_1111_; uint8_t v_isShared_1112_; uint8_t v_isSharedCheck_1133_; 
v___x_1103_ = lean_st_ref_take(v_a_1101_);
v_typeAnalysis_1104_ = lean_ctor_get(v___x_1103_, 2);
v_rewriteCache_1105_ = lean_ctor_get(v___x_1103_, 0);
v_acNfCache_1106_ = lean_ctor_get(v___x_1103_, 1);
v_goal_1107_ = lean_ctor_get(v___x_1103_, 3);
v_hypotheses_1108_ = lean_ctor_get(v___x_1103_, 4);
v_didChange_1109_ = lean_ctor_get_uint8(v___x_1103_, sizeof(void*)*5);
v_isSharedCheck_1133_ = !lean_is_exclusive(v___x_1103_);
if (v_isSharedCheck_1133_ == 0)
{
v___x_1111_ = v___x_1103_;
v_isShared_1112_ = v_isSharedCheck_1133_;
goto v_resetjp_1110_;
}
else
{
lean_inc(v_hypotheses_1108_);
lean_inc(v_goal_1107_);
lean_inc(v_typeAnalysis_1104_);
lean_inc(v_acNfCache_1106_);
lean_inc(v_rewriteCache_1105_);
lean_dec(v___x_1103_);
v___x_1111_ = lean_box(0);
v_isShared_1112_ = v_isSharedCheck_1133_;
goto v_resetjp_1110_;
}
v_resetjp_1110_:
{
lean_object* v_interestingStructures_1113_; lean_object* v_interestingEnums_1114_; lean_object* v_interestingMatchers_1115_; lean_object* v_uninteresting_1116_; lean_object* v___x_1118_; uint8_t v_isShared_1119_; uint8_t v_isSharedCheck_1132_; 
v_interestingStructures_1113_ = lean_ctor_get(v_typeAnalysis_1104_, 0);
v_interestingEnums_1114_ = lean_ctor_get(v_typeAnalysis_1104_, 1);
v_interestingMatchers_1115_ = lean_ctor_get(v_typeAnalysis_1104_, 2);
v_uninteresting_1116_ = lean_ctor_get(v_typeAnalysis_1104_, 3);
v_isSharedCheck_1132_ = !lean_is_exclusive(v_typeAnalysis_1104_);
if (v_isSharedCheck_1132_ == 0)
{
v___x_1118_ = v_typeAnalysis_1104_;
v_isShared_1119_ = v_isSharedCheck_1132_;
goto v_resetjp_1117_;
}
else
{
lean_inc(v_uninteresting_1116_);
lean_inc(v_interestingMatchers_1115_);
lean_inc(v_interestingEnums_1114_);
lean_inc(v_interestingStructures_1113_);
lean_dec(v_typeAnalysis_1104_);
v___x_1118_ = lean_box(0);
v_isShared_1119_ = v_isSharedCheck_1132_;
goto v_resetjp_1117_;
}
v_resetjp_1117_:
{
lean_object* v___x_1120_; lean_object* v___x_1121_; lean_object* v___x_1122_; lean_object* v___x_1123_; lean_object* v___x_1125_; 
v___x_1120_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_1121_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
v___x_1122_ = lean_box(0);
v___x_1123_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_1120_, v___x_1121_, v_uninteresting_1116_, v_n_1100_, v___x_1122_);
if (v_isShared_1119_ == 0)
{
lean_ctor_set(v___x_1118_, 3, v___x_1123_);
v___x_1125_ = v___x_1118_;
goto v_reusejp_1124_;
}
else
{
lean_object* v_reuseFailAlloc_1131_; 
v_reuseFailAlloc_1131_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_1131_, 0, v_interestingStructures_1113_);
lean_ctor_set(v_reuseFailAlloc_1131_, 1, v_interestingEnums_1114_);
lean_ctor_set(v_reuseFailAlloc_1131_, 2, v_interestingMatchers_1115_);
lean_ctor_set(v_reuseFailAlloc_1131_, 3, v___x_1123_);
v___x_1125_ = v_reuseFailAlloc_1131_;
goto v_reusejp_1124_;
}
v_reusejp_1124_:
{
lean_object* v___x_1127_; 
if (v_isShared_1112_ == 0)
{
lean_ctor_set(v___x_1111_, 2, v___x_1125_);
v___x_1127_ = v___x_1111_;
goto v_reusejp_1126_;
}
else
{
lean_object* v_reuseFailAlloc_1130_; 
v_reuseFailAlloc_1130_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_1130_, 0, v_rewriteCache_1105_);
lean_ctor_set(v_reuseFailAlloc_1130_, 1, v_acNfCache_1106_);
lean_ctor_set(v_reuseFailAlloc_1130_, 2, v___x_1125_);
lean_ctor_set(v_reuseFailAlloc_1130_, 3, v_goal_1107_);
lean_ctor_set(v_reuseFailAlloc_1130_, 4, v_hypotheses_1108_);
lean_ctor_set_uint8(v_reuseFailAlloc_1130_, sizeof(void*)*5, v_didChange_1109_);
v___x_1127_ = v_reuseFailAlloc_1130_;
goto v_reusejp_1126_;
}
v_reusejp_1126_:
{
lean_object* v___x_1128_; lean_object* v___x_1129_; 
v___x_1128_ = lean_st_ref_set(v_a_1101_, v___x_1127_);
v___x_1129_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1129_, 0, v___x_1122_);
return v___x_1129_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst___redArg___boxed(lean_object* v_n_1134_, lean_object* v_a_1135_, lean_object* v_a_1136_){
_start:
{
lean_object* v_res_1137_; 
v_res_1137_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst___redArg(v_n_1134_, v_a_1135_);
lean_dec(v_a_1135_);
return v_res_1137_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst(lean_object* v_n_1138_, lean_object* v_a_1139_, lean_object* v_a_1140_, lean_object* v_a_1141_, lean_object* v_a_1142_, lean_object* v_a_1143_, lean_object* v_a_1144_, lean_object* v_a_1145_, lean_object* v_a_1146_){
_start:
{
lean_object* v___x_1148_; lean_object* v_typeAnalysis_1149_; lean_object* v_rewriteCache_1150_; lean_object* v_acNfCache_1151_; lean_object* v_goal_1152_; lean_object* v_hypotheses_1153_; uint8_t v_didChange_1154_; lean_object* v___x_1156_; uint8_t v_isShared_1157_; uint8_t v_isSharedCheck_1178_; 
v___x_1148_ = lean_st_ref_take(v_a_1140_);
v_typeAnalysis_1149_ = lean_ctor_get(v___x_1148_, 2);
v_rewriteCache_1150_ = lean_ctor_get(v___x_1148_, 0);
v_acNfCache_1151_ = lean_ctor_get(v___x_1148_, 1);
v_goal_1152_ = lean_ctor_get(v___x_1148_, 3);
v_hypotheses_1153_ = lean_ctor_get(v___x_1148_, 4);
v_didChange_1154_ = lean_ctor_get_uint8(v___x_1148_, sizeof(void*)*5);
v_isSharedCheck_1178_ = !lean_is_exclusive(v___x_1148_);
if (v_isSharedCheck_1178_ == 0)
{
v___x_1156_ = v___x_1148_;
v_isShared_1157_ = v_isSharedCheck_1178_;
goto v_resetjp_1155_;
}
else
{
lean_inc(v_hypotheses_1153_);
lean_inc(v_goal_1152_);
lean_inc(v_typeAnalysis_1149_);
lean_inc(v_acNfCache_1151_);
lean_inc(v_rewriteCache_1150_);
lean_dec(v___x_1148_);
v___x_1156_ = lean_box(0);
v_isShared_1157_ = v_isSharedCheck_1178_;
goto v_resetjp_1155_;
}
v_resetjp_1155_:
{
lean_object* v_interestingStructures_1158_; lean_object* v_interestingEnums_1159_; lean_object* v_interestingMatchers_1160_; lean_object* v_uninteresting_1161_; lean_object* v___x_1163_; uint8_t v_isShared_1164_; uint8_t v_isSharedCheck_1177_; 
v_interestingStructures_1158_ = lean_ctor_get(v_typeAnalysis_1149_, 0);
v_interestingEnums_1159_ = lean_ctor_get(v_typeAnalysis_1149_, 1);
v_interestingMatchers_1160_ = lean_ctor_get(v_typeAnalysis_1149_, 2);
v_uninteresting_1161_ = lean_ctor_get(v_typeAnalysis_1149_, 3);
v_isSharedCheck_1177_ = !lean_is_exclusive(v_typeAnalysis_1149_);
if (v_isSharedCheck_1177_ == 0)
{
v___x_1163_ = v_typeAnalysis_1149_;
v_isShared_1164_ = v_isSharedCheck_1177_;
goto v_resetjp_1162_;
}
else
{
lean_inc(v_uninteresting_1161_);
lean_inc(v_interestingMatchers_1160_);
lean_inc(v_interestingEnums_1159_);
lean_inc(v_interestingStructures_1158_);
lean_dec(v_typeAnalysis_1149_);
v___x_1163_ = lean_box(0);
v_isShared_1164_ = v_isSharedCheck_1177_;
goto v_resetjp_1162_;
}
v_resetjp_1162_:
{
lean_object* v___x_1165_; lean_object* v___x_1166_; lean_object* v___x_1167_; lean_object* v___x_1168_; lean_object* v___x_1170_; 
v___x_1165_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__0));
v___x_1166_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_lookupInterestingStructure___redArg___closed__1));
v___x_1167_ = lean_box(0);
v___x_1168_ = l_Std_DHashMap_Internal_Raw_u2080_insertIfNew___redArg(v___x_1165_, v___x_1166_, v_uninteresting_1161_, v_n_1138_, v___x_1167_);
if (v_isShared_1164_ == 0)
{
lean_ctor_set(v___x_1163_, 3, v___x_1168_);
v___x_1170_ = v___x_1163_;
goto v_reusejp_1169_;
}
else
{
lean_object* v_reuseFailAlloc_1176_; 
v_reuseFailAlloc_1176_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v_reuseFailAlloc_1176_, 0, v_interestingStructures_1158_);
lean_ctor_set(v_reuseFailAlloc_1176_, 1, v_interestingEnums_1159_);
lean_ctor_set(v_reuseFailAlloc_1176_, 2, v_interestingMatchers_1160_);
lean_ctor_set(v_reuseFailAlloc_1176_, 3, v___x_1168_);
v___x_1170_ = v_reuseFailAlloc_1176_;
goto v_reusejp_1169_;
}
v_reusejp_1169_:
{
lean_object* v___x_1172_; 
if (v_isShared_1157_ == 0)
{
lean_ctor_set(v___x_1156_, 2, v___x_1170_);
v___x_1172_ = v___x_1156_;
goto v_reusejp_1171_;
}
else
{
lean_object* v_reuseFailAlloc_1175_; 
v_reuseFailAlloc_1175_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_1175_, 0, v_rewriteCache_1150_);
lean_ctor_set(v_reuseFailAlloc_1175_, 1, v_acNfCache_1151_);
lean_ctor_set(v_reuseFailAlloc_1175_, 2, v___x_1170_);
lean_ctor_set(v_reuseFailAlloc_1175_, 3, v_goal_1152_);
lean_ctor_set(v_reuseFailAlloc_1175_, 4, v_hypotheses_1153_);
lean_ctor_set_uint8(v_reuseFailAlloc_1175_, sizeof(void*)*5, v_didChange_1154_);
v___x_1172_ = v_reuseFailAlloc_1175_;
goto v_reusejp_1171_;
}
v_reusejp_1171_:
{
lean_object* v___x_1173_; lean_object* v___x_1174_; 
v___x_1173_ = lean_st_ref_set(v_a_1140_, v___x_1172_);
v___x_1174_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1174_, 0, v___x_1167_);
return v___x_1174_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst___boxed(lean_object* v_n_1179_, lean_object* v_a_1180_, lean_object* v_a_1181_, lean_object* v_a_1182_, lean_object* v_a_1183_, lean_object* v_a_1184_, lean_object* v_a_1185_, lean_object* v_a_1186_, lean_object* v_a_1187_, lean_object* v_a_1188_){
_start:
{
lean_object* v_res_1189_; 
v_res_1189_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_markUninterestingConst(v_n_1179_, v_a_1180_, v_a_1181_, v_a_1182_, v_a_1183_, v_a_1184_, v_a_1185_, v_a_1186_, v_a_1187_);
lean_dec(v_a_1187_);
lean_dec_ref(v_a_1186_);
lean_dec(v_a_1185_);
lean_dec_ref(v_a_1184_);
lean_dec(v_a_1183_);
lean_dec_ref(v_a_1182_);
lean_dec(v_a_1181_);
lean_dec_ref(v_a_1180_);
return v_res_1189_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___lam__0(lean_object* v___y_1190_, lean_object* v___y_1191_, lean_object* v___y_1192_, lean_object* v___y_1193_, lean_object* v___y_1194_, lean_object* v___y_1195_){
_start:
{
lean_object* v___x_1197_; 
v___x_1197_ = l_Lean_Meta_getPropHyps(v___y_1192_, v___y_1193_, v___y_1194_, v___y_1195_);
return v___x_1197_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___lam__0___boxed(lean_object* v___y_1198_, lean_object* v___y_1199_, lean_object* v___y_1200_, lean_object* v___y_1201_, lean_object* v___y_1202_, lean_object* v___y_1203_, lean_object* v___y_1204_){
_start:
{
lean_object* v_res_1205_; 
v_res_1205_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___lam__0(v___y_1198_, v___y_1199_, v___y_1200_, v___y_1201_, v___y_1202_, v___y_1203_);
lean_dec(v___y_1203_);
lean_dec_ref(v___y_1202_);
lean_dec(v___y_1201_);
lean_dec_ref(v___y_1200_);
lean_dec(v___y_1199_);
lean_dec_ref(v___y_1198_);
return v_res_1205_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__0(void){
_start:
{
lean_object* v___x_1206_; 
v___x_1206_ = l_instMonadEIO(lean_box(0));
return v___x_1206_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1(void){
_start:
{
lean_object* v___x_1207_; lean_object* v___x_1208_; 
v___x_1207_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__0, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__0_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__0);
v___x_1208_ = l_StateRefT_x27_instMonad___redArg(v___x_1207_);
return v___x_1208_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6(void){
_start:
{
lean_object* v___x_1213_; 
v___x_1213_ = l_instMonadControlReaderT(lean_box(0), lean_box(0));
return v___x_1213_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7(void){
_start:
{
lean_object* v___x_1214_; 
v___x_1214_ = l_instMonadControlStateRefT_x27(lean_box(0), lean_box(0), lean_box(0));
return v___x_1214_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__9(void){
_start:
{
lean_object* v___x_1216_; lean_object* v___x_1217_; lean_object* v___x_1218_; 
v___x_1216_ = lean_box(0);
v___x_1217_ = lean_unsigned_to_nat(16u);
v___x_1218_ = lean_mk_array(v___x_1217_, v___x_1216_);
return v___x_1218_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__10(void){
_start:
{
lean_object* v___x_1219_; lean_object* v___x_1220_; lean_object* v___x_1221_; 
v___x_1219_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__9, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__9);
v___x_1220_ = lean_unsigned_to_nat(0u);
v___x_1221_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1221_, 0, v___x_1220_);
lean_ctor_set(v___x_1221_, 1, v___x_1219_);
return v___x_1221_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11(void){
_start:
{
lean_object* v___x_1222_; lean_object* v___x_1223_; 
v___x_1222_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__10, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__10_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__10);
v___x_1223_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_1223_, 0, v___x_1222_);
lean_ctor_set(v___x_1223_, 1, v___x_1222_);
lean_ctor_set(v___x_1223_, 2, v___x_1222_);
lean_ctor_set(v___x_1223_, 3, v___x_1222_);
return v___x_1223_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg(lean_object* v_cfg_1226_, lean_object* v_goal_1227_, lean_object* v_x_1228_, lean_object* v_a_1229_, lean_object* v_a_1230_, lean_object* v_a_1231_, lean_object* v_a_1232_, lean_object* v_a_1233_, lean_object* v_a_1234_){
_start:
{
lean_object* v___x_1236_; lean_object* v_toApplicative_1237_; lean_object* v_toFunctor_1238_; lean_object* v_toSeq_1239_; lean_object* v_toSeqLeft_1240_; lean_object* v_toSeqRight_1241_; lean_object* v___f_1242_; lean_object* v___f_1243_; lean_object* v___f_1244_; lean_object* v___f_1245_; lean_object* v___x_1246_; lean_object* v___f_1247_; lean_object* v___f_1248_; lean_object* v___f_1249_; lean_object* v___x_1250_; lean_object* v___x_1251_; lean_object* v___x_1252_; lean_object* v_toApplicative_1253_; lean_object* v___x_1255_; uint8_t v_isShared_1256_; uint8_t v_isSharedCheck_1352_; 
v___x_1236_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1);
v_toApplicative_1237_ = lean_ctor_get(v___x_1236_, 0);
v_toFunctor_1238_ = lean_ctor_get(v_toApplicative_1237_, 0);
v_toSeq_1239_ = lean_ctor_get(v_toApplicative_1237_, 2);
v_toSeqLeft_1240_ = lean_ctor_get(v_toApplicative_1237_, 3);
v_toSeqRight_1241_ = lean_ctor_get(v_toApplicative_1237_, 4);
v___f_1242_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2));
v___f_1243_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3));
lean_inc_ref_n(v_toFunctor_1238_, 2);
v___f_1244_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1244_, 0, v_toFunctor_1238_);
v___f_1245_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1245_, 0, v_toFunctor_1238_);
v___x_1246_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1246_, 0, v___f_1244_);
lean_ctor_set(v___x_1246_, 1, v___f_1245_);
lean_inc(v_toSeqRight_1241_);
v___f_1247_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1247_, 0, v_toSeqRight_1241_);
lean_inc(v_toSeqLeft_1240_);
v___f_1248_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1248_, 0, v_toSeqLeft_1240_);
lean_inc(v_toSeq_1239_);
v___f_1249_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1249_, 0, v_toSeq_1239_);
v___x_1250_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_1250_, 0, v___x_1246_);
lean_ctor_set(v___x_1250_, 1, v___f_1242_);
lean_ctor_set(v___x_1250_, 2, v___f_1249_);
lean_ctor_set(v___x_1250_, 3, v___f_1248_);
lean_ctor_set(v___x_1250_, 4, v___f_1247_);
v___x_1251_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1251_, 0, v___x_1250_);
lean_ctor_set(v___x_1251_, 1, v___f_1243_);
v___x_1252_ = l_StateRefT_x27_instMonad___redArg(v___x_1251_);
v_toApplicative_1253_ = lean_ctor_get(v___x_1252_, 0);
v_isSharedCheck_1352_ = !lean_is_exclusive(v___x_1252_);
if (v_isSharedCheck_1352_ == 0)
{
lean_object* v_unused_1353_; 
v_unused_1353_ = lean_ctor_get(v___x_1252_, 1);
lean_dec(v_unused_1353_);
v___x_1255_ = v___x_1252_;
v_isShared_1256_ = v_isSharedCheck_1352_;
goto v_resetjp_1254_;
}
else
{
lean_inc(v_toApplicative_1253_);
lean_dec(v___x_1252_);
v___x_1255_ = lean_box(0);
v_isShared_1256_ = v_isSharedCheck_1352_;
goto v_resetjp_1254_;
}
v_resetjp_1254_:
{
lean_object* v_toFunctor_1257_; lean_object* v_toSeq_1258_; lean_object* v_toSeqLeft_1259_; lean_object* v_toSeqRight_1260_; lean_object* v___x_1262_; uint8_t v_isShared_1263_; uint8_t v_isSharedCheck_1350_; 
v_toFunctor_1257_ = lean_ctor_get(v_toApplicative_1253_, 0);
v_toSeq_1258_ = lean_ctor_get(v_toApplicative_1253_, 2);
v_toSeqLeft_1259_ = lean_ctor_get(v_toApplicative_1253_, 3);
v_toSeqRight_1260_ = lean_ctor_get(v_toApplicative_1253_, 4);
v_isSharedCheck_1350_ = !lean_is_exclusive(v_toApplicative_1253_);
if (v_isSharedCheck_1350_ == 0)
{
lean_object* v_unused_1351_; 
v_unused_1351_ = lean_ctor_get(v_toApplicative_1253_, 1);
lean_dec(v_unused_1351_);
v___x_1262_ = v_toApplicative_1253_;
v_isShared_1263_ = v_isSharedCheck_1350_;
goto v_resetjp_1261_;
}
else
{
lean_inc(v_toSeqRight_1260_);
lean_inc(v_toSeqLeft_1259_);
lean_inc(v_toSeq_1258_);
lean_inc(v_toFunctor_1257_);
lean_dec(v_toApplicative_1253_);
v___x_1262_ = lean_box(0);
v_isShared_1263_ = v_isSharedCheck_1350_;
goto v_resetjp_1261_;
}
v_resetjp_1261_:
{
lean_object* v___f_1264_; lean_object* v___f_1265_; lean_object* v___f_1266_; lean_object* v___f_1267_; lean_object* v___x_1268_; lean_object* v___f_1269_; lean_object* v___f_1270_; lean_object* v___f_1271_; lean_object* v___x_1273_; 
v___f_1264_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4));
v___f_1265_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5));
lean_inc_ref(v_toFunctor_1257_);
v___f_1266_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1266_, 0, v_toFunctor_1257_);
v___f_1267_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1267_, 0, v_toFunctor_1257_);
v___x_1268_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1268_, 0, v___f_1266_);
lean_ctor_set(v___x_1268_, 1, v___f_1267_);
v___f_1269_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1269_, 0, v_toSeqRight_1260_);
v___f_1270_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1270_, 0, v_toSeqLeft_1259_);
v___f_1271_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1271_, 0, v_toSeq_1258_);
if (v_isShared_1263_ == 0)
{
lean_ctor_set(v___x_1262_, 4, v___f_1269_);
lean_ctor_set(v___x_1262_, 3, v___f_1270_);
lean_ctor_set(v___x_1262_, 2, v___f_1271_);
lean_ctor_set(v___x_1262_, 1, v___f_1264_);
lean_ctor_set(v___x_1262_, 0, v___x_1268_);
v___x_1273_ = v___x_1262_;
goto v_reusejp_1272_;
}
else
{
lean_object* v_reuseFailAlloc_1349_; 
v_reuseFailAlloc_1349_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_1349_, 0, v___x_1268_);
lean_ctor_set(v_reuseFailAlloc_1349_, 1, v___f_1264_);
lean_ctor_set(v_reuseFailAlloc_1349_, 2, v___f_1271_);
lean_ctor_set(v_reuseFailAlloc_1349_, 3, v___f_1270_);
lean_ctor_set(v_reuseFailAlloc_1349_, 4, v___f_1269_);
v___x_1273_ = v_reuseFailAlloc_1349_;
goto v_reusejp_1272_;
}
v_reusejp_1272_:
{
lean_object* v___x_1275_; 
if (v_isShared_1256_ == 0)
{
lean_ctor_set(v___x_1255_, 1, v___f_1265_);
lean_ctor_set(v___x_1255_, 0, v___x_1273_);
v___x_1275_ = v___x_1255_;
goto v_reusejp_1274_;
}
else
{
lean_object* v_reuseFailAlloc_1348_; 
v_reuseFailAlloc_1348_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1348_, 0, v___x_1273_);
lean_ctor_set(v_reuseFailAlloc_1348_, 1, v___f_1265_);
v___x_1275_ = v_reuseFailAlloc_1348_;
goto v_reusejp_1274_;
}
v_reusejp_1274_:
{
lean_object* v___x_1276_; lean_object* v___x_1277_; lean_object* v___x_1278_; lean_object* v___x_1279_; lean_object* v_toApplicative_1280_; lean_object* v_toFunctor_1281_; lean_object* v_toSeq_1282_; lean_object* v_toSeqLeft_1283_; lean_object* v_toSeqRight_1284_; lean_object* v___f_1285_; lean_object* v___f_1286_; lean_object* v___f_1287_; lean_object* v___x_1288_; lean_object* v___f_1289_; lean_object* v___f_1290_; lean_object* v___f_1291_; lean_object* v___x_1292_; lean_object* v___x_1293_; lean_object* v___x_1294_; lean_object* v___x_1295_; lean_object* v___x_1296_; lean_object* v___f_1297_; lean_object* v___f_1298_; lean_object* v___x_1299_; lean_object* v___f_1300_; lean_object* v___f_1301_; lean_object* v___x_1302_; lean_object* v___x_1900__overap_1303_; lean_object* v___x_1304_; 
v___x_1276_ = l_StateRefT_x27_instMonad___redArg(v___x_1275_);
v___x_1277_ = l_ReaderT_instMonad___redArg(v___x_1276_);
v___x_1278_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6);
v___x_1279_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7);
v_toApplicative_1280_ = lean_ctor_get(v___x_1236_, 0);
v_toFunctor_1281_ = lean_ctor_get(v_toApplicative_1280_, 0);
v_toSeq_1282_ = lean_ctor_get(v_toApplicative_1280_, 2);
v_toSeqLeft_1283_ = lean_ctor_get(v_toApplicative_1280_, 3);
v_toSeqRight_1284_ = lean_ctor_get(v_toApplicative_1280_, 4);
v___f_1285_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__8));
lean_inc_ref_n(v_toFunctor_1281_, 2);
v___f_1286_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1286_, 0, v_toFunctor_1281_);
v___f_1287_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1287_, 0, v_toFunctor_1281_);
v___x_1288_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1288_, 0, v___f_1286_);
lean_ctor_set(v___x_1288_, 1, v___f_1287_);
lean_inc(v_toSeqRight_1284_);
v___f_1289_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1289_, 0, v_toSeqRight_1284_);
lean_inc(v_toSeqLeft_1283_);
v___f_1290_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1290_, 0, v_toSeqLeft_1283_);
lean_inc(v_toSeq_1282_);
v___f_1291_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1291_, 0, v_toSeq_1282_);
v___x_1292_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_1292_, 0, v___x_1288_);
lean_ctor_set(v___x_1292_, 1, v___f_1242_);
lean_ctor_set(v___x_1292_, 2, v___f_1291_);
lean_ctor_set(v___x_1292_, 3, v___f_1290_);
lean_ctor_set(v___x_1292_, 4, v___f_1289_);
v___x_1293_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1293_, 0, v___x_1292_);
lean_ctor_set(v___x_1293_, 1, v___f_1243_);
v___x_1294_ = l_StateRefT_x27_instMonad___redArg(v___x_1293_);
v___x_1295_ = lean_alloc_closure((void*)(l_ReaderT_pure___boxed), 6, 3);
lean_closure_set(v___x_1295_, 0, lean_box(0));
lean_closure_set(v___x_1295_, 1, lean_box(0));
lean_closure_set(v___x_1295_, 2, v___x_1294_);
v___x_1296_ = l_instMonadControlTOfPure___redArg(v___x_1295_);
lean_inc_ref(v___x_1296_);
v___f_1297_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__3), 4, 2);
lean_closure_set(v___f_1297_, 0, v___x_1279_);
lean_closure_set(v___f_1297_, 1, v___x_1296_);
v___f_1298_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__4), 4, 2);
lean_closure_set(v___f_1298_, 0, v___x_1279_);
lean_closure_set(v___f_1298_, 1, v___x_1296_);
v___x_1299_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1299_, 0, v___f_1297_);
lean_ctor_set(v___x_1299_, 1, v___f_1298_);
lean_inc_ref(v___x_1299_);
v___f_1300_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__3), 4, 2);
lean_closure_set(v___f_1300_, 0, v___x_1278_);
lean_closure_set(v___f_1300_, 1, v___x_1299_);
v___f_1301_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__4), 4, 2);
lean_closure_set(v___f_1301_, 0, v___x_1278_);
lean_closure_set(v___f_1301_, 1, v___x_1299_);
v___x_1302_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1302_, 0, v___f_1300_);
lean_ctor_set(v___x_1302_, 1, v___f_1301_);
lean_inc(v_goal_1227_);
v___x_1900__overap_1303_ = l_Lean_MVarId_withContext___redArg(v___x_1302_, v___x_1277_, v_goal_1227_, v___f_1285_);
lean_inc(v_a_1234_);
lean_inc_ref(v_a_1233_);
lean_inc(v_a_1232_);
lean_inc_ref(v_a_1231_);
lean_inc(v_a_1230_);
lean_inc_ref(v_a_1229_);
v___x_1304_ = lean_apply_7(v___x_1900__overap_1303_, v_a_1229_, v_a_1230_, v_a_1231_, v_a_1232_, v_a_1233_, v_a_1234_, lean_box(0));
if (lean_obj_tag(v___x_1304_) == 0)
{
lean_object* v_a_1305_; lean_object* v___x_1306_; lean_object* v___x_1307_; lean_object* v___x_1308_; lean_object* v___x_1309_; lean_object* v___x_1310_; lean_object* v___x_1311_; lean_object* v___x_1312_; lean_object* v___x_1313_; lean_object* v___x_1314_; lean_object* v___x_1315_; lean_object* v___x_1316_; lean_object* v___x_1317_; uint8_t v___x_1318_; lean_object* v___x_1319_; lean_object* v___x_1320_; lean_object* v___x_1321_; 
v_a_1305_ = lean_ctor_get(v___x_1304_, 0);
lean_inc(v_a_1305_);
lean_dec_ref_known(v___x_1304_, 1);
v___x_1306_ = lean_array_get_size(v_a_1305_);
lean_dec(v_a_1305_);
v___x_1307_ = lean_unsigned_to_nat(0u);
v___x_1308_ = lean_unsigned_to_nat(4u);
v___x_1309_ = lean_nat_mul(v___x_1306_, v___x_1308_);
v___x_1310_ = lean_unsigned_to_nat(3u);
v___x_1311_ = lean_nat_div(v___x_1309_, v___x_1310_);
lean_dec(v___x_1309_);
v___x_1312_ = l_Nat_nextPowerOfTwo(v___x_1311_);
lean_dec(v___x_1311_);
v___x_1313_ = lean_box(0);
v___x_1314_ = lean_mk_array(v___x_1312_, v___x_1313_);
v___x_1315_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1315_, 0, v___x_1307_);
lean_ctor_set(v___x_1315_, 1, v___x_1314_);
v___x_1316_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11);
v___x_1317_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__12));
v___x_1318_ = 0;
lean_inc_ref(v___x_1315_);
v___x_1319_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v___x_1319_, 0, v___x_1315_);
lean_ctor_set(v___x_1319_, 1, v___x_1315_);
lean_ctor_set(v___x_1319_, 2, v___x_1316_);
lean_ctor_set(v___x_1319_, 3, v_goal_1227_);
lean_ctor_set(v___x_1319_, 4, v___x_1317_);
lean_ctor_set_uint8(v___x_1319_, sizeof(void*)*5, v___x_1318_);
v___x_1320_ = lean_st_mk_ref(v___x_1319_);
lean_inc(v_a_1234_);
lean_inc_ref(v_a_1233_);
lean_inc(v_a_1232_);
lean_inc_ref(v_a_1231_);
lean_inc(v_a_1230_);
lean_inc_ref(v_a_1229_);
lean_inc(v___x_1320_);
v___x_1321_ = lean_apply_9(v_x_1228_, v_cfg_1226_, v___x_1320_, v_a_1229_, v_a_1230_, v_a_1231_, v_a_1232_, v_a_1233_, v_a_1234_, lean_box(0));
if (lean_obj_tag(v___x_1321_) == 0)
{
lean_object* v_a_1322_; lean_object* v___x_1324_; uint8_t v_isShared_1325_; uint8_t v_isSharedCheck_1331_; 
v_a_1322_ = lean_ctor_get(v___x_1321_, 0);
v_isSharedCheck_1331_ = !lean_is_exclusive(v___x_1321_);
if (v_isSharedCheck_1331_ == 0)
{
v___x_1324_ = v___x_1321_;
v_isShared_1325_ = v_isSharedCheck_1331_;
goto v_resetjp_1323_;
}
else
{
lean_inc(v_a_1322_);
lean_dec(v___x_1321_);
v___x_1324_ = lean_box(0);
v_isShared_1325_ = v_isSharedCheck_1331_;
goto v_resetjp_1323_;
}
v_resetjp_1323_:
{
lean_object* v___x_1326_; lean_object* v___x_1327_; lean_object* v___x_1329_; 
v___x_1326_ = lean_st_ref_get(v___x_1320_);
lean_dec(v___x_1320_);
v___x_1327_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1327_, 0, v_a_1322_);
lean_ctor_set(v___x_1327_, 1, v___x_1326_);
if (v_isShared_1325_ == 0)
{
lean_ctor_set(v___x_1324_, 0, v___x_1327_);
v___x_1329_ = v___x_1324_;
goto v_reusejp_1328_;
}
else
{
lean_object* v_reuseFailAlloc_1330_; 
v_reuseFailAlloc_1330_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1330_, 0, v___x_1327_);
v___x_1329_ = v_reuseFailAlloc_1330_;
goto v_reusejp_1328_;
}
v_reusejp_1328_:
{
return v___x_1329_;
}
}
}
else
{
lean_object* v_a_1332_; lean_object* v___x_1334_; uint8_t v_isShared_1335_; uint8_t v_isSharedCheck_1339_; 
lean_dec(v___x_1320_);
v_a_1332_ = lean_ctor_get(v___x_1321_, 0);
v_isSharedCheck_1339_ = !lean_is_exclusive(v___x_1321_);
if (v_isSharedCheck_1339_ == 0)
{
v___x_1334_ = v___x_1321_;
v_isShared_1335_ = v_isSharedCheck_1339_;
goto v_resetjp_1333_;
}
else
{
lean_inc(v_a_1332_);
lean_dec(v___x_1321_);
v___x_1334_ = lean_box(0);
v_isShared_1335_ = v_isSharedCheck_1339_;
goto v_resetjp_1333_;
}
v_resetjp_1333_:
{
lean_object* v___x_1337_; 
if (v_isShared_1335_ == 0)
{
v___x_1337_ = v___x_1334_;
goto v_reusejp_1336_;
}
else
{
lean_object* v_reuseFailAlloc_1338_; 
v_reuseFailAlloc_1338_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1338_, 0, v_a_1332_);
v___x_1337_ = v_reuseFailAlloc_1338_;
goto v_reusejp_1336_;
}
v_reusejp_1336_:
{
return v___x_1337_;
}
}
}
}
else
{
lean_object* v_a_1340_; lean_object* v___x_1342_; uint8_t v_isShared_1343_; uint8_t v_isSharedCheck_1347_; 
lean_dec_ref(v_x_1228_);
lean_dec(v_goal_1227_);
lean_dec_ref(v_cfg_1226_);
v_a_1340_ = lean_ctor_get(v___x_1304_, 0);
v_isSharedCheck_1347_ = !lean_is_exclusive(v___x_1304_);
if (v_isSharedCheck_1347_ == 0)
{
v___x_1342_ = v___x_1304_;
v_isShared_1343_ = v_isSharedCheck_1347_;
goto v_resetjp_1341_;
}
else
{
lean_inc(v_a_1340_);
lean_dec(v___x_1304_);
v___x_1342_ = lean_box(0);
v_isShared_1343_ = v_isSharedCheck_1347_;
goto v_resetjp_1341_;
}
v_resetjp_1341_:
{
lean_object* v___x_1345_; 
if (v_isShared_1343_ == 0)
{
v___x_1345_ = v___x_1342_;
goto v_reusejp_1344_;
}
else
{
lean_object* v_reuseFailAlloc_1346_; 
v_reuseFailAlloc_1346_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1346_, 0, v_a_1340_);
v___x_1345_ = v_reuseFailAlloc_1346_;
goto v_reusejp_1344_;
}
v_reusejp_1344_:
{
return v___x_1345_;
}
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___boxed(lean_object* v_cfg_1354_, lean_object* v_goal_1355_, lean_object* v_x_1356_, lean_object* v_a_1357_, lean_object* v_a_1358_, lean_object* v_a_1359_, lean_object* v_a_1360_, lean_object* v_a_1361_, lean_object* v_a_1362_, lean_object* v_a_1363_){
_start:
{
lean_object* v_res_1364_; 
v_res_1364_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg(v_cfg_1354_, v_goal_1355_, v_x_1356_, v_a_1357_, v_a_1358_, v_a_1359_, v_a_1360_, v_a_1361_, v_a_1362_);
lean_dec(v_a_1362_);
lean_dec_ref(v_a_1361_);
lean_dec(v_a_1360_);
lean_dec_ref(v_a_1359_);
lean_dec(v_a_1358_);
lean_dec_ref(v_a_1357_);
return v_res_1364_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run(lean_object* v_00_u03b1_1365_, lean_object* v_cfg_1366_, lean_object* v_goal_1367_, lean_object* v_x_1368_, lean_object* v_a_1369_, lean_object* v_a_1370_, lean_object* v_a_1371_, lean_object* v_a_1372_, lean_object* v_a_1373_, lean_object* v_a_1374_){
_start:
{
lean_object* v___x_1376_; lean_object* v_toApplicative_1377_; lean_object* v_toFunctor_1378_; lean_object* v_toSeq_1379_; lean_object* v_toSeqLeft_1380_; lean_object* v_toSeqRight_1381_; lean_object* v___f_1382_; lean_object* v___f_1383_; lean_object* v___f_1384_; lean_object* v___f_1385_; lean_object* v___x_1386_; lean_object* v___f_1387_; lean_object* v___f_1388_; lean_object* v___f_1389_; lean_object* v___x_1390_; lean_object* v___x_1391_; lean_object* v___x_1392_; lean_object* v_toApplicative_1393_; lean_object* v___x_1395_; uint8_t v_isShared_1396_; uint8_t v_isSharedCheck_1492_; 
v___x_1376_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1);
v_toApplicative_1377_ = lean_ctor_get(v___x_1376_, 0);
v_toFunctor_1378_ = lean_ctor_get(v_toApplicative_1377_, 0);
v_toSeq_1379_ = lean_ctor_get(v_toApplicative_1377_, 2);
v_toSeqLeft_1380_ = lean_ctor_get(v_toApplicative_1377_, 3);
v_toSeqRight_1381_ = lean_ctor_get(v_toApplicative_1377_, 4);
v___f_1382_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2));
v___f_1383_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3));
lean_inc_ref_n(v_toFunctor_1378_, 2);
v___f_1384_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1384_, 0, v_toFunctor_1378_);
v___f_1385_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1385_, 0, v_toFunctor_1378_);
v___x_1386_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1386_, 0, v___f_1384_);
lean_ctor_set(v___x_1386_, 1, v___f_1385_);
lean_inc(v_toSeqRight_1381_);
v___f_1387_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1387_, 0, v_toSeqRight_1381_);
lean_inc(v_toSeqLeft_1380_);
v___f_1388_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1388_, 0, v_toSeqLeft_1380_);
lean_inc(v_toSeq_1379_);
v___f_1389_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1389_, 0, v_toSeq_1379_);
v___x_1390_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_1390_, 0, v___x_1386_);
lean_ctor_set(v___x_1390_, 1, v___f_1382_);
lean_ctor_set(v___x_1390_, 2, v___f_1389_);
lean_ctor_set(v___x_1390_, 3, v___f_1388_);
lean_ctor_set(v___x_1390_, 4, v___f_1387_);
v___x_1391_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1391_, 0, v___x_1390_);
lean_ctor_set(v___x_1391_, 1, v___f_1383_);
v___x_1392_ = l_StateRefT_x27_instMonad___redArg(v___x_1391_);
v_toApplicative_1393_ = lean_ctor_get(v___x_1392_, 0);
v_isSharedCheck_1492_ = !lean_is_exclusive(v___x_1392_);
if (v_isSharedCheck_1492_ == 0)
{
lean_object* v_unused_1493_; 
v_unused_1493_ = lean_ctor_get(v___x_1392_, 1);
lean_dec(v_unused_1493_);
v___x_1395_ = v___x_1392_;
v_isShared_1396_ = v_isSharedCheck_1492_;
goto v_resetjp_1394_;
}
else
{
lean_inc(v_toApplicative_1393_);
lean_dec(v___x_1392_);
v___x_1395_ = lean_box(0);
v_isShared_1396_ = v_isSharedCheck_1492_;
goto v_resetjp_1394_;
}
v_resetjp_1394_:
{
lean_object* v_toFunctor_1397_; lean_object* v_toSeq_1398_; lean_object* v_toSeqLeft_1399_; lean_object* v_toSeqRight_1400_; lean_object* v___x_1402_; uint8_t v_isShared_1403_; uint8_t v_isSharedCheck_1490_; 
v_toFunctor_1397_ = lean_ctor_get(v_toApplicative_1393_, 0);
v_toSeq_1398_ = lean_ctor_get(v_toApplicative_1393_, 2);
v_toSeqLeft_1399_ = lean_ctor_get(v_toApplicative_1393_, 3);
v_toSeqRight_1400_ = lean_ctor_get(v_toApplicative_1393_, 4);
v_isSharedCheck_1490_ = !lean_is_exclusive(v_toApplicative_1393_);
if (v_isSharedCheck_1490_ == 0)
{
lean_object* v_unused_1491_; 
v_unused_1491_ = lean_ctor_get(v_toApplicative_1393_, 1);
lean_dec(v_unused_1491_);
v___x_1402_ = v_toApplicative_1393_;
v_isShared_1403_ = v_isSharedCheck_1490_;
goto v_resetjp_1401_;
}
else
{
lean_inc(v_toSeqRight_1400_);
lean_inc(v_toSeqLeft_1399_);
lean_inc(v_toSeq_1398_);
lean_inc(v_toFunctor_1397_);
lean_dec(v_toApplicative_1393_);
v___x_1402_ = lean_box(0);
v_isShared_1403_ = v_isSharedCheck_1490_;
goto v_resetjp_1401_;
}
v_resetjp_1401_:
{
lean_object* v___f_1404_; lean_object* v___f_1405_; lean_object* v___f_1406_; lean_object* v___f_1407_; lean_object* v___x_1408_; lean_object* v___f_1409_; lean_object* v___f_1410_; lean_object* v___f_1411_; lean_object* v___x_1413_; 
v___f_1404_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4));
v___f_1405_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5));
lean_inc_ref(v_toFunctor_1397_);
v___f_1406_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1406_, 0, v_toFunctor_1397_);
v___f_1407_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1407_, 0, v_toFunctor_1397_);
v___x_1408_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1408_, 0, v___f_1406_);
lean_ctor_set(v___x_1408_, 1, v___f_1407_);
v___f_1409_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1409_, 0, v_toSeqRight_1400_);
v___f_1410_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1410_, 0, v_toSeqLeft_1399_);
v___f_1411_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1411_, 0, v_toSeq_1398_);
if (v_isShared_1403_ == 0)
{
lean_ctor_set(v___x_1402_, 4, v___f_1409_);
lean_ctor_set(v___x_1402_, 3, v___f_1410_);
lean_ctor_set(v___x_1402_, 2, v___f_1411_);
lean_ctor_set(v___x_1402_, 1, v___f_1404_);
lean_ctor_set(v___x_1402_, 0, v___x_1408_);
v___x_1413_ = v___x_1402_;
goto v_reusejp_1412_;
}
else
{
lean_object* v_reuseFailAlloc_1489_; 
v_reuseFailAlloc_1489_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_1489_, 0, v___x_1408_);
lean_ctor_set(v_reuseFailAlloc_1489_, 1, v___f_1404_);
lean_ctor_set(v_reuseFailAlloc_1489_, 2, v___f_1411_);
lean_ctor_set(v_reuseFailAlloc_1489_, 3, v___f_1410_);
lean_ctor_set(v_reuseFailAlloc_1489_, 4, v___f_1409_);
v___x_1413_ = v_reuseFailAlloc_1489_;
goto v_reusejp_1412_;
}
v_reusejp_1412_:
{
lean_object* v___x_1415_; 
if (v_isShared_1396_ == 0)
{
lean_ctor_set(v___x_1395_, 1, v___f_1405_);
lean_ctor_set(v___x_1395_, 0, v___x_1413_);
v___x_1415_ = v___x_1395_;
goto v_reusejp_1414_;
}
else
{
lean_object* v_reuseFailAlloc_1488_; 
v_reuseFailAlloc_1488_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1488_, 0, v___x_1413_);
lean_ctor_set(v_reuseFailAlloc_1488_, 1, v___f_1405_);
v___x_1415_ = v_reuseFailAlloc_1488_;
goto v_reusejp_1414_;
}
v_reusejp_1414_:
{
lean_object* v___x_1416_; lean_object* v___x_1417_; lean_object* v___x_1418_; lean_object* v___x_1419_; lean_object* v_toApplicative_1420_; lean_object* v_toFunctor_1421_; lean_object* v_toSeq_1422_; lean_object* v_toSeqLeft_1423_; lean_object* v_toSeqRight_1424_; lean_object* v___f_1425_; lean_object* v___f_1426_; lean_object* v___f_1427_; lean_object* v___x_1428_; lean_object* v___f_1429_; lean_object* v___f_1430_; lean_object* v___f_1431_; lean_object* v___x_1432_; lean_object* v___x_1433_; lean_object* v___x_1434_; lean_object* v___x_1435_; lean_object* v___x_1436_; lean_object* v___f_1437_; lean_object* v___f_1438_; lean_object* v___x_1439_; lean_object* v___f_1440_; lean_object* v___f_1441_; lean_object* v___x_1442_; lean_object* v___x_2065__overap_1443_; lean_object* v___x_1444_; 
v___x_1416_ = l_StateRefT_x27_instMonad___redArg(v___x_1415_);
v___x_1417_ = l_ReaderT_instMonad___redArg(v___x_1416_);
v___x_1418_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6);
v___x_1419_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7);
v_toApplicative_1420_ = lean_ctor_get(v___x_1376_, 0);
v_toFunctor_1421_ = lean_ctor_get(v_toApplicative_1420_, 0);
v_toSeq_1422_ = lean_ctor_get(v_toApplicative_1420_, 2);
v_toSeqLeft_1423_ = lean_ctor_get(v_toApplicative_1420_, 3);
v_toSeqRight_1424_ = lean_ctor_get(v_toApplicative_1420_, 4);
v___f_1425_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__8));
lean_inc_ref_n(v_toFunctor_1421_, 2);
v___f_1426_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1426_, 0, v_toFunctor_1421_);
v___f_1427_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1427_, 0, v_toFunctor_1421_);
v___x_1428_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1428_, 0, v___f_1426_);
lean_ctor_set(v___x_1428_, 1, v___f_1427_);
lean_inc(v_toSeqRight_1424_);
v___f_1429_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1429_, 0, v_toSeqRight_1424_);
lean_inc(v_toSeqLeft_1423_);
v___f_1430_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1430_, 0, v_toSeqLeft_1423_);
lean_inc(v_toSeq_1422_);
v___f_1431_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1431_, 0, v_toSeq_1422_);
v___x_1432_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_1432_, 0, v___x_1428_);
lean_ctor_set(v___x_1432_, 1, v___f_1382_);
lean_ctor_set(v___x_1432_, 2, v___f_1431_);
lean_ctor_set(v___x_1432_, 3, v___f_1430_);
lean_ctor_set(v___x_1432_, 4, v___f_1429_);
v___x_1433_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1433_, 0, v___x_1432_);
lean_ctor_set(v___x_1433_, 1, v___f_1383_);
v___x_1434_ = l_StateRefT_x27_instMonad___redArg(v___x_1433_);
v___x_1435_ = lean_alloc_closure((void*)(l_ReaderT_pure___boxed), 6, 3);
lean_closure_set(v___x_1435_, 0, lean_box(0));
lean_closure_set(v___x_1435_, 1, lean_box(0));
lean_closure_set(v___x_1435_, 2, v___x_1434_);
v___x_1436_ = l_instMonadControlTOfPure___redArg(v___x_1435_);
lean_inc_ref(v___x_1436_);
v___f_1437_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__3), 4, 2);
lean_closure_set(v___f_1437_, 0, v___x_1419_);
lean_closure_set(v___f_1437_, 1, v___x_1436_);
v___f_1438_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__4), 4, 2);
lean_closure_set(v___f_1438_, 0, v___x_1419_);
lean_closure_set(v___f_1438_, 1, v___x_1436_);
v___x_1439_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1439_, 0, v___f_1437_);
lean_ctor_set(v___x_1439_, 1, v___f_1438_);
lean_inc_ref(v___x_1439_);
v___f_1440_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__3), 4, 2);
lean_closure_set(v___f_1440_, 0, v___x_1418_);
lean_closure_set(v___f_1440_, 1, v___x_1439_);
v___f_1441_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__4), 4, 2);
lean_closure_set(v___f_1441_, 0, v___x_1418_);
lean_closure_set(v___f_1441_, 1, v___x_1439_);
v___x_1442_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1442_, 0, v___f_1440_);
lean_ctor_set(v___x_1442_, 1, v___f_1441_);
lean_inc(v_goal_1367_);
v___x_2065__overap_1443_ = l_Lean_MVarId_withContext___redArg(v___x_1442_, v___x_1417_, v_goal_1367_, v___f_1425_);
lean_inc(v_a_1374_);
lean_inc_ref(v_a_1373_);
lean_inc(v_a_1372_);
lean_inc_ref(v_a_1371_);
lean_inc(v_a_1370_);
lean_inc_ref(v_a_1369_);
v___x_1444_ = lean_apply_7(v___x_2065__overap_1443_, v_a_1369_, v_a_1370_, v_a_1371_, v_a_1372_, v_a_1373_, v_a_1374_, lean_box(0));
if (lean_obj_tag(v___x_1444_) == 0)
{
lean_object* v_a_1445_; lean_object* v___x_1446_; lean_object* v___x_1447_; lean_object* v___x_1448_; lean_object* v___x_1449_; lean_object* v___x_1450_; lean_object* v___x_1451_; lean_object* v___x_1452_; lean_object* v___x_1453_; lean_object* v___x_1454_; lean_object* v___x_1455_; lean_object* v___x_1456_; lean_object* v___x_1457_; uint8_t v___x_1458_; lean_object* v___x_1459_; lean_object* v___x_1460_; lean_object* v___x_1461_; 
v_a_1445_ = lean_ctor_get(v___x_1444_, 0);
lean_inc(v_a_1445_);
lean_dec_ref_known(v___x_1444_, 1);
v___x_1446_ = lean_array_get_size(v_a_1445_);
lean_dec(v_a_1445_);
v___x_1447_ = lean_unsigned_to_nat(0u);
v___x_1448_ = lean_unsigned_to_nat(4u);
v___x_1449_ = lean_nat_mul(v___x_1446_, v___x_1448_);
v___x_1450_ = lean_unsigned_to_nat(3u);
v___x_1451_ = lean_nat_div(v___x_1449_, v___x_1450_);
lean_dec(v___x_1449_);
v___x_1452_ = l_Nat_nextPowerOfTwo(v___x_1451_);
lean_dec(v___x_1451_);
v___x_1453_ = lean_box(0);
v___x_1454_ = lean_mk_array(v___x_1452_, v___x_1453_);
v___x_1455_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1455_, 0, v___x_1447_);
lean_ctor_set(v___x_1455_, 1, v___x_1454_);
v___x_1456_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11);
v___x_1457_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__12));
v___x_1458_ = 0;
lean_inc_ref(v___x_1455_);
v___x_1459_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v___x_1459_, 0, v___x_1455_);
lean_ctor_set(v___x_1459_, 1, v___x_1455_);
lean_ctor_set(v___x_1459_, 2, v___x_1456_);
lean_ctor_set(v___x_1459_, 3, v_goal_1367_);
lean_ctor_set(v___x_1459_, 4, v___x_1457_);
lean_ctor_set_uint8(v___x_1459_, sizeof(void*)*5, v___x_1458_);
v___x_1460_ = lean_st_mk_ref(v___x_1459_);
lean_inc(v_a_1374_);
lean_inc_ref(v_a_1373_);
lean_inc(v_a_1372_);
lean_inc_ref(v_a_1371_);
lean_inc(v_a_1370_);
lean_inc_ref(v_a_1369_);
lean_inc(v___x_1460_);
v___x_1461_ = lean_apply_9(v_x_1368_, v_cfg_1366_, v___x_1460_, v_a_1369_, v_a_1370_, v_a_1371_, v_a_1372_, v_a_1373_, v_a_1374_, lean_box(0));
if (lean_obj_tag(v___x_1461_) == 0)
{
lean_object* v_a_1462_; lean_object* v___x_1464_; uint8_t v_isShared_1465_; uint8_t v_isSharedCheck_1471_; 
v_a_1462_ = lean_ctor_get(v___x_1461_, 0);
v_isSharedCheck_1471_ = !lean_is_exclusive(v___x_1461_);
if (v_isSharedCheck_1471_ == 0)
{
v___x_1464_ = v___x_1461_;
v_isShared_1465_ = v_isSharedCheck_1471_;
goto v_resetjp_1463_;
}
else
{
lean_inc(v_a_1462_);
lean_dec(v___x_1461_);
v___x_1464_ = lean_box(0);
v_isShared_1465_ = v_isSharedCheck_1471_;
goto v_resetjp_1463_;
}
v_resetjp_1463_:
{
lean_object* v___x_1466_; lean_object* v___x_1467_; lean_object* v___x_1469_; 
v___x_1466_ = lean_st_ref_get(v___x_1460_);
lean_dec(v___x_1460_);
v___x_1467_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1467_, 0, v_a_1462_);
lean_ctor_set(v___x_1467_, 1, v___x_1466_);
if (v_isShared_1465_ == 0)
{
lean_ctor_set(v___x_1464_, 0, v___x_1467_);
v___x_1469_ = v___x_1464_;
goto v_reusejp_1468_;
}
else
{
lean_object* v_reuseFailAlloc_1470_; 
v_reuseFailAlloc_1470_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1470_, 0, v___x_1467_);
v___x_1469_ = v_reuseFailAlloc_1470_;
goto v_reusejp_1468_;
}
v_reusejp_1468_:
{
return v___x_1469_;
}
}
}
else
{
lean_object* v_a_1472_; lean_object* v___x_1474_; uint8_t v_isShared_1475_; uint8_t v_isSharedCheck_1479_; 
lean_dec(v___x_1460_);
v_a_1472_ = lean_ctor_get(v___x_1461_, 0);
v_isSharedCheck_1479_ = !lean_is_exclusive(v___x_1461_);
if (v_isSharedCheck_1479_ == 0)
{
v___x_1474_ = v___x_1461_;
v_isShared_1475_ = v_isSharedCheck_1479_;
goto v_resetjp_1473_;
}
else
{
lean_inc(v_a_1472_);
lean_dec(v___x_1461_);
v___x_1474_ = lean_box(0);
v_isShared_1475_ = v_isSharedCheck_1479_;
goto v_resetjp_1473_;
}
v_resetjp_1473_:
{
lean_object* v___x_1477_; 
if (v_isShared_1475_ == 0)
{
v___x_1477_ = v___x_1474_;
goto v_reusejp_1476_;
}
else
{
lean_object* v_reuseFailAlloc_1478_; 
v_reuseFailAlloc_1478_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1478_, 0, v_a_1472_);
v___x_1477_ = v_reuseFailAlloc_1478_;
goto v_reusejp_1476_;
}
v_reusejp_1476_:
{
return v___x_1477_;
}
}
}
}
else
{
lean_object* v_a_1480_; lean_object* v___x_1482_; uint8_t v_isShared_1483_; uint8_t v_isSharedCheck_1487_; 
lean_dec_ref(v_x_1368_);
lean_dec(v_goal_1367_);
lean_dec_ref(v_cfg_1366_);
v_a_1480_ = lean_ctor_get(v___x_1444_, 0);
v_isSharedCheck_1487_ = !lean_is_exclusive(v___x_1444_);
if (v_isSharedCheck_1487_ == 0)
{
v___x_1482_ = v___x_1444_;
v_isShared_1483_ = v_isSharedCheck_1487_;
goto v_resetjp_1481_;
}
else
{
lean_inc(v_a_1480_);
lean_dec(v___x_1444_);
v___x_1482_ = lean_box(0);
v_isShared_1483_ = v_isSharedCheck_1487_;
goto v_resetjp_1481_;
}
v_resetjp_1481_:
{
lean_object* v___x_1485_; 
if (v_isShared_1483_ == 0)
{
v___x_1485_ = v___x_1482_;
goto v_reusejp_1484_;
}
else
{
lean_object* v_reuseFailAlloc_1486_; 
v_reuseFailAlloc_1486_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1486_, 0, v_a_1480_);
v___x_1485_ = v_reuseFailAlloc_1486_;
goto v_reusejp_1484_;
}
v_reusejp_1484_:
{
return v___x_1485_;
}
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___boxed(lean_object* v_00_u03b1_1494_, lean_object* v_cfg_1495_, lean_object* v_goal_1496_, lean_object* v_x_1497_, lean_object* v_a_1498_, lean_object* v_a_1499_, lean_object* v_a_1500_, lean_object* v_a_1501_, lean_object* v_a_1502_, lean_object* v_a_1503_, lean_object* v_a_1504_){
_start:
{
lean_object* v_res_1505_; 
v_res_1505_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run(v_00_u03b1_1494_, v_cfg_1495_, v_goal_1496_, v_x_1497_, v_a_1498_, v_a_1499_, v_a_1500_, v_a_1501_, v_a_1502_, v_a_1503_);
lean_dec(v_a_1503_);
lean_dec_ref(v_a_1502_);
lean_dec(v_a_1501_);
lean_dec_ref(v_a_1500_);
lean_dec(v_a_1499_);
lean_dec_ref(v_a_1498_);
return v_res_1505_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27___redArg(lean_object* v_cfg_1506_, lean_object* v_goal_1507_, lean_object* v_x_1508_, lean_object* v_a_1509_, lean_object* v_a_1510_, lean_object* v_a_1511_, lean_object* v_a_1512_, lean_object* v_a_1513_, lean_object* v_a_1514_){
_start:
{
lean_object* v___x_1516_; lean_object* v_toApplicative_1517_; lean_object* v_toFunctor_1518_; lean_object* v_toSeq_1519_; lean_object* v_toSeqLeft_1520_; lean_object* v_toSeqRight_1521_; lean_object* v___f_1522_; lean_object* v___f_1523_; lean_object* v___f_1524_; lean_object* v___f_1525_; lean_object* v___x_1526_; lean_object* v___f_1527_; lean_object* v___f_1528_; lean_object* v___f_1529_; lean_object* v___x_1530_; lean_object* v___x_1531_; lean_object* v___x_1532_; lean_object* v_toApplicative_1533_; lean_object* v___x_1535_; uint8_t v_isShared_1536_; uint8_t v_isSharedCheck_1623_; 
v___x_1516_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1);
v_toApplicative_1517_ = lean_ctor_get(v___x_1516_, 0);
v_toFunctor_1518_ = lean_ctor_get(v_toApplicative_1517_, 0);
v_toSeq_1519_ = lean_ctor_get(v_toApplicative_1517_, 2);
v_toSeqLeft_1520_ = lean_ctor_get(v_toApplicative_1517_, 3);
v_toSeqRight_1521_ = lean_ctor_get(v_toApplicative_1517_, 4);
v___f_1522_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2));
v___f_1523_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3));
lean_inc_ref_n(v_toFunctor_1518_, 2);
v___f_1524_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1524_, 0, v_toFunctor_1518_);
v___f_1525_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1525_, 0, v_toFunctor_1518_);
v___x_1526_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1526_, 0, v___f_1524_);
lean_ctor_set(v___x_1526_, 1, v___f_1525_);
lean_inc(v_toSeqRight_1521_);
v___f_1527_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1527_, 0, v_toSeqRight_1521_);
lean_inc(v_toSeqLeft_1520_);
v___f_1528_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1528_, 0, v_toSeqLeft_1520_);
lean_inc(v_toSeq_1519_);
v___f_1529_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1529_, 0, v_toSeq_1519_);
v___x_1530_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_1530_, 0, v___x_1526_);
lean_ctor_set(v___x_1530_, 1, v___f_1522_);
lean_ctor_set(v___x_1530_, 2, v___f_1529_);
lean_ctor_set(v___x_1530_, 3, v___f_1528_);
lean_ctor_set(v___x_1530_, 4, v___f_1527_);
v___x_1531_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1531_, 0, v___x_1530_);
lean_ctor_set(v___x_1531_, 1, v___f_1523_);
v___x_1532_ = l_StateRefT_x27_instMonad___redArg(v___x_1531_);
v_toApplicative_1533_ = lean_ctor_get(v___x_1532_, 0);
v_isSharedCheck_1623_ = !lean_is_exclusive(v___x_1532_);
if (v_isSharedCheck_1623_ == 0)
{
lean_object* v_unused_1624_; 
v_unused_1624_ = lean_ctor_get(v___x_1532_, 1);
lean_dec(v_unused_1624_);
v___x_1535_ = v___x_1532_;
v_isShared_1536_ = v_isSharedCheck_1623_;
goto v_resetjp_1534_;
}
else
{
lean_inc(v_toApplicative_1533_);
lean_dec(v___x_1532_);
v___x_1535_ = lean_box(0);
v_isShared_1536_ = v_isSharedCheck_1623_;
goto v_resetjp_1534_;
}
v_resetjp_1534_:
{
lean_object* v_toFunctor_1537_; lean_object* v_toSeq_1538_; lean_object* v_toSeqLeft_1539_; lean_object* v_toSeqRight_1540_; lean_object* v___x_1542_; uint8_t v_isShared_1543_; uint8_t v_isSharedCheck_1621_; 
v_toFunctor_1537_ = lean_ctor_get(v_toApplicative_1533_, 0);
v_toSeq_1538_ = lean_ctor_get(v_toApplicative_1533_, 2);
v_toSeqLeft_1539_ = lean_ctor_get(v_toApplicative_1533_, 3);
v_toSeqRight_1540_ = lean_ctor_get(v_toApplicative_1533_, 4);
v_isSharedCheck_1621_ = !lean_is_exclusive(v_toApplicative_1533_);
if (v_isSharedCheck_1621_ == 0)
{
lean_object* v_unused_1622_; 
v_unused_1622_ = lean_ctor_get(v_toApplicative_1533_, 1);
lean_dec(v_unused_1622_);
v___x_1542_ = v_toApplicative_1533_;
v_isShared_1543_ = v_isSharedCheck_1621_;
goto v_resetjp_1541_;
}
else
{
lean_inc(v_toSeqRight_1540_);
lean_inc(v_toSeqLeft_1539_);
lean_inc(v_toSeq_1538_);
lean_inc(v_toFunctor_1537_);
lean_dec(v_toApplicative_1533_);
v___x_1542_ = lean_box(0);
v_isShared_1543_ = v_isSharedCheck_1621_;
goto v_resetjp_1541_;
}
v_resetjp_1541_:
{
lean_object* v___f_1544_; lean_object* v___f_1545_; lean_object* v___f_1546_; lean_object* v___f_1547_; lean_object* v___x_1548_; lean_object* v___f_1549_; lean_object* v___f_1550_; lean_object* v___f_1551_; lean_object* v___x_1553_; 
v___f_1544_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4));
v___f_1545_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5));
lean_inc_ref(v_toFunctor_1537_);
v___f_1546_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1546_, 0, v_toFunctor_1537_);
v___f_1547_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1547_, 0, v_toFunctor_1537_);
v___x_1548_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1548_, 0, v___f_1546_);
lean_ctor_set(v___x_1548_, 1, v___f_1547_);
v___f_1549_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1549_, 0, v_toSeqRight_1540_);
v___f_1550_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1550_, 0, v_toSeqLeft_1539_);
v___f_1551_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1551_, 0, v_toSeq_1538_);
if (v_isShared_1543_ == 0)
{
lean_ctor_set(v___x_1542_, 4, v___f_1549_);
lean_ctor_set(v___x_1542_, 3, v___f_1550_);
lean_ctor_set(v___x_1542_, 2, v___f_1551_);
lean_ctor_set(v___x_1542_, 1, v___f_1544_);
lean_ctor_set(v___x_1542_, 0, v___x_1548_);
v___x_1553_ = v___x_1542_;
goto v_reusejp_1552_;
}
else
{
lean_object* v_reuseFailAlloc_1620_; 
v_reuseFailAlloc_1620_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_1620_, 0, v___x_1548_);
lean_ctor_set(v_reuseFailAlloc_1620_, 1, v___f_1544_);
lean_ctor_set(v_reuseFailAlloc_1620_, 2, v___f_1551_);
lean_ctor_set(v_reuseFailAlloc_1620_, 3, v___f_1550_);
lean_ctor_set(v_reuseFailAlloc_1620_, 4, v___f_1549_);
v___x_1553_ = v_reuseFailAlloc_1620_;
goto v_reusejp_1552_;
}
v_reusejp_1552_:
{
lean_object* v___x_1555_; 
if (v_isShared_1536_ == 0)
{
lean_ctor_set(v___x_1535_, 1, v___f_1545_);
lean_ctor_set(v___x_1535_, 0, v___x_1553_);
v___x_1555_ = v___x_1535_;
goto v_reusejp_1554_;
}
else
{
lean_object* v_reuseFailAlloc_1619_; 
v_reuseFailAlloc_1619_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1619_, 0, v___x_1553_);
lean_ctor_set(v_reuseFailAlloc_1619_, 1, v___f_1545_);
v___x_1555_ = v_reuseFailAlloc_1619_;
goto v_reusejp_1554_;
}
v_reusejp_1554_:
{
lean_object* v___x_1556_; lean_object* v___x_1557_; lean_object* v___x_1558_; lean_object* v___x_1559_; lean_object* v_toApplicative_1560_; lean_object* v_toFunctor_1561_; lean_object* v_toSeq_1562_; lean_object* v_toSeqLeft_1563_; lean_object* v_toSeqRight_1564_; lean_object* v___f_1565_; lean_object* v___f_1566_; lean_object* v___f_1567_; lean_object* v___x_1568_; lean_object* v___f_1569_; lean_object* v___f_1570_; lean_object* v___f_1571_; lean_object* v___x_1572_; lean_object* v___x_1573_; lean_object* v___x_1574_; lean_object* v___x_1575_; lean_object* v___x_1576_; lean_object* v___f_1577_; lean_object* v___f_1578_; lean_object* v___x_1579_; lean_object* v___f_1580_; lean_object* v___f_1581_; lean_object* v___x_1582_; lean_object* v___x_2348__overap_1583_; lean_object* v___x_1584_; 
v___x_1556_ = l_StateRefT_x27_instMonad___redArg(v___x_1555_);
v___x_1557_ = l_ReaderT_instMonad___redArg(v___x_1556_);
v___x_1558_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6);
v___x_1559_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7);
v_toApplicative_1560_ = lean_ctor_get(v___x_1516_, 0);
v_toFunctor_1561_ = lean_ctor_get(v_toApplicative_1560_, 0);
v_toSeq_1562_ = lean_ctor_get(v_toApplicative_1560_, 2);
v_toSeqLeft_1563_ = lean_ctor_get(v_toApplicative_1560_, 3);
v_toSeqRight_1564_ = lean_ctor_get(v_toApplicative_1560_, 4);
v___f_1565_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__8));
lean_inc_ref_n(v_toFunctor_1561_, 2);
v___f_1566_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1566_, 0, v_toFunctor_1561_);
v___f_1567_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1567_, 0, v_toFunctor_1561_);
v___x_1568_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1568_, 0, v___f_1566_);
lean_ctor_set(v___x_1568_, 1, v___f_1567_);
lean_inc(v_toSeqRight_1564_);
v___f_1569_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1569_, 0, v_toSeqRight_1564_);
lean_inc(v_toSeqLeft_1563_);
v___f_1570_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1570_, 0, v_toSeqLeft_1563_);
lean_inc(v_toSeq_1562_);
v___f_1571_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1571_, 0, v_toSeq_1562_);
v___x_1572_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_1572_, 0, v___x_1568_);
lean_ctor_set(v___x_1572_, 1, v___f_1522_);
lean_ctor_set(v___x_1572_, 2, v___f_1571_);
lean_ctor_set(v___x_1572_, 3, v___f_1570_);
lean_ctor_set(v___x_1572_, 4, v___f_1569_);
v___x_1573_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1573_, 0, v___x_1572_);
lean_ctor_set(v___x_1573_, 1, v___f_1523_);
v___x_1574_ = l_StateRefT_x27_instMonad___redArg(v___x_1573_);
v___x_1575_ = lean_alloc_closure((void*)(l_ReaderT_pure___boxed), 6, 3);
lean_closure_set(v___x_1575_, 0, lean_box(0));
lean_closure_set(v___x_1575_, 1, lean_box(0));
lean_closure_set(v___x_1575_, 2, v___x_1574_);
v___x_1576_ = l_instMonadControlTOfPure___redArg(v___x_1575_);
lean_inc_ref(v___x_1576_);
v___f_1577_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__3), 4, 2);
lean_closure_set(v___f_1577_, 0, v___x_1559_);
lean_closure_set(v___f_1577_, 1, v___x_1576_);
v___f_1578_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__4), 4, 2);
lean_closure_set(v___f_1578_, 0, v___x_1559_);
lean_closure_set(v___f_1578_, 1, v___x_1576_);
v___x_1579_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1579_, 0, v___f_1577_);
lean_ctor_set(v___x_1579_, 1, v___f_1578_);
lean_inc_ref(v___x_1579_);
v___f_1580_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__3), 4, 2);
lean_closure_set(v___f_1580_, 0, v___x_1558_);
lean_closure_set(v___f_1580_, 1, v___x_1579_);
v___f_1581_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__4), 4, 2);
lean_closure_set(v___f_1581_, 0, v___x_1558_);
lean_closure_set(v___f_1581_, 1, v___x_1579_);
v___x_1582_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1582_, 0, v___f_1580_);
lean_ctor_set(v___x_1582_, 1, v___f_1581_);
lean_inc(v_goal_1507_);
v___x_2348__overap_1583_ = l_Lean_MVarId_withContext___redArg(v___x_1582_, v___x_1557_, v_goal_1507_, v___f_1565_);
lean_inc(v_a_1514_);
lean_inc_ref(v_a_1513_);
lean_inc(v_a_1512_);
lean_inc_ref(v_a_1511_);
lean_inc(v_a_1510_);
lean_inc_ref(v_a_1509_);
v___x_1584_ = lean_apply_7(v___x_2348__overap_1583_, v_a_1509_, v_a_1510_, v_a_1511_, v_a_1512_, v_a_1513_, v_a_1514_, lean_box(0));
if (lean_obj_tag(v___x_1584_) == 0)
{
lean_object* v_a_1585_; lean_object* v___x_1586_; lean_object* v___x_1587_; lean_object* v___x_1588_; lean_object* v___x_1589_; lean_object* v___x_1590_; lean_object* v___x_1591_; lean_object* v___x_1592_; lean_object* v___x_1593_; lean_object* v___x_1594_; lean_object* v___x_1595_; lean_object* v___x_1596_; lean_object* v___x_1597_; uint8_t v___x_1598_; lean_object* v___x_1599_; lean_object* v___x_1600_; lean_object* v___x_1601_; 
v_a_1585_ = lean_ctor_get(v___x_1584_, 0);
lean_inc(v_a_1585_);
lean_dec_ref_known(v___x_1584_, 1);
v___x_1586_ = lean_array_get_size(v_a_1585_);
lean_dec(v_a_1585_);
v___x_1587_ = lean_unsigned_to_nat(0u);
v___x_1588_ = lean_unsigned_to_nat(4u);
v___x_1589_ = lean_nat_mul(v___x_1586_, v___x_1588_);
v___x_1590_ = lean_unsigned_to_nat(3u);
v___x_1591_ = lean_nat_div(v___x_1589_, v___x_1590_);
lean_dec(v___x_1589_);
v___x_1592_ = l_Nat_nextPowerOfTwo(v___x_1591_);
lean_dec(v___x_1591_);
v___x_1593_ = lean_box(0);
v___x_1594_ = lean_mk_array(v___x_1592_, v___x_1593_);
v___x_1595_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1595_, 0, v___x_1587_);
lean_ctor_set(v___x_1595_, 1, v___x_1594_);
v___x_1596_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11);
v___x_1597_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__12));
v___x_1598_ = 0;
lean_inc_ref(v___x_1595_);
v___x_1599_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v___x_1599_, 0, v___x_1595_);
lean_ctor_set(v___x_1599_, 1, v___x_1595_);
lean_ctor_set(v___x_1599_, 2, v___x_1596_);
lean_ctor_set(v___x_1599_, 3, v_goal_1507_);
lean_ctor_set(v___x_1599_, 4, v___x_1597_);
lean_ctor_set_uint8(v___x_1599_, sizeof(void*)*5, v___x_1598_);
v___x_1600_ = lean_st_mk_ref(v___x_1599_);
lean_inc(v_a_1514_);
lean_inc_ref(v_a_1513_);
lean_inc(v_a_1512_);
lean_inc_ref(v_a_1511_);
lean_inc(v_a_1510_);
lean_inc_ref(v_a_1509_);
lean_inc(v___x_1600_);
v___x_1601_ = lean_apply_9(v_x_1508_, v_cfg_1506_, v___x_1600_, v_a_1509_, v_a_1510_, v_a_1511_, v_a_1512_, v_a_1513_, v_a_1514_, lean_box(0));
if (lean_obj_tag(v___x_1601_) == 0)
{
lean_object* v_a_1602_; lean_object* v___x_1604_; uint8_t v_isShared_1605_; uint8_t v_isSharedCheck_1610_; 
v_a_1602_ = lean_ctor_get(v___x_1601_, 0);
v_isSharedCheck_1610_ = !lean_is_exclusive(v___x_1601_);
if (v_isSharedCheck_1610_ == 0)
{
v___x_1604_ = v___x_1601_;
v_isShared_1605_ = v_isSharedCheck_1610_;
goto v_resetjp_1603_;
}
else
{
lean_inc(v_a_1602_);
lean_dec(v___x_1601_);
v___x_1604_ = lean_box(0);
v_isShared_1605_ = v_isSharedCheck_1610_;
goto v_resetjp_1603_;
}
v_resetjp_1603_:
{
lean_object* v___x_1606_; lean_object* v___x_1608_; 
v___x_1606_ = lean_st_ref_get(v___x_1600_);
lean_dec(v___x_1600_);
lean_dec(v___x_1606_);
if (v_isShared_1605_ == 0)
{
v___x_1608_ = v___x_1604_;
goto v_reusejp_1607_;
}
else
{
lean_object* v_reuseFailAlloc_1609_; 
v_reuseFailAlloc_1609_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1609_, 0, v_a_1602_);
v___x_1608_ = v_reuseFailAlloc_1609_;
goto v_reusejp_1607_;
}
v_reusejp_1607_:
{
return v___x_1608_;
}
}
}
else
{
lean_dec(v___x_1600_);
return v___x_1601_;
}
}
else
{
lean_object* v_a_1611_; lean_object* v___x_1613_; uint8_t v_isShared_1614_; uint8_t v_isSharedCheck_1618_; 
lean_dec_ref(v_x_1508_);
lean_dec(v_goal_1507_);
lean_dec_ref(v_cfg_1506_);
v_a_1611_ = lean_ctor_get(v___x_1584_, 0);
v_isSharedCheck_1618_ = !lean_is_exclusive(v___x_1584_);
if (v_isSharedCheck_1618_ == 0)
{
v___x_1613_ = v___x_1584_;
v_isShared_1614_ = v_isSharedCheck_1618_;
goto v_resetjp_1612_;
}
else
{
lean_inc(v_a_1611_);
lean_dec(v___x_1584_);
v___x_1613_ = lean_box(0);
v_isShared_1614_ = v_isSharedCheck_1618_;
goto v_resetjp_1612_;
}
v_resetjp_1612_:
{
lean_object* v___x_1616_; 
if (v_isShared_1614_ == 0)
{
v___x_1616_ = v___x_1613_;
goto v_reusejp_1615_;
}
else
{
lean_object* v_reuseFailAlloc_1617_; 
v_reuseFailAlloc_1617_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1617_, 0, v_a_1611_);
v___x_1616_ = v_reuseFailAlloc_1617_;
goto v_reusejp_1615_;
}
v_reusejp_1615_:
{
return v___x_1616_;
}
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27___redArg___boxed(lean_object* v_cfg_1625_, lean_object* v_goal_1626_, lean_object* v_x_1627_, lean_object* v_a_1628_, lean_object* v_a_1629_, lean_object* v_a_1630_, lean_object* v_a_1631_, lean_object* v_a_1632_, lean_object* v_a_1633_, lean_object* v_a_1634_){
_start:
{
lean_object* v_res_1635_; 
v_res_1635_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27___redArg(v_cfg_1625_, v_goal_1626_, v_x_1627_, v_a_1628_, v_a_1629_, v_a_1630_, v_a_1631_, v_a_1632_, v_a_1633_);
lean_dec(v_a_1633_);
lean_dec_ref(v_a_1632_);
lean_dec(v_a_1631_);
lean_dec_ref(v_a_1630_);
lean_dec(v_a_1629_);
lean_dec_ref(v_a_1628_);
return v_res_1635_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27(lean_object* v_00_u03b1_1636_, lean_object* v_cfg_1637_, lean_object* v_goal_1638_, lean_object* v_x_1639_, lean_object* v_a_1640_, lean_object* v_a_1641_, lean_object* v_a_1642_, lean_object* v_a_1643_, lean_object* v_a_1644_, lean_object* v_a_1645_){
_start:
{
lean_object* v___x_1647_; lean_object* v_toApplicative_1648_; lean_object* v_toFunctor_1649_; lean_object* v_toSeq_1650_; lean_object* v_toSeqLeft_1651_; lean_object* v_toSeqRight_1652_; lean_object* v___f_1653_; lean_object* v___f_1654_; lean_object* v___f_1655_; lean_object* v___f_1656_; lean_object* v___x_1657_; lean_object* v___f_1658_; lean_object* v___f_1659_; lean_object* v___f_1660_; lean_object* v___x_1661_; lean_object* v___x_1662_; lean_object* v___x_1663_; lean_object* v_toApplicative_1664_; lean_object* v___x_1666_; uint8_t v_isShared_1667_; uint8_t v_isSharedCheck_1754_; 
v___x_1647_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1);
v_toApplicative_1648_ = lean_ctor_get(v___x_1647_, 0);
v_toFunctor_1649_ = lean_ctor_get(v_toApplicative_1648_, 0);
v_toSeq_1650_ = lean_ctor_get(v_toApplicative_1648_, 2);
v_toSeqLeft_1651_ = lean_ctor_get(v_toApplicative_1648_, 3);
v_toSeqRight_1652_ = lean_ctor_get(v_toApplicative_1648_, 4);
v___f_1653_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2));
v___f_1654_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3));
lean_inc_ref_n(v_toFunctor_1649_, 2);
v___f_1655_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1655_, 0, v_toFunctor_1649_);
v___f_1656_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1656_, 0, v_toFunctor_1649_);
v___x_1657_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1657_, 0, v___f_1655_);
lean_ctor_set(v___x_1657_, 1, v___f_1656_);
lean_inc(v_toSeqRight_1652_);
v___f_1658_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1658_, 0, v_toSeqRight_1652_);
lean_inc(v_toSeqLeft_1651_);
v___f_1659_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1659_, 0, v_toSeqLeft_1651_);
lean_inc(v_toSeq_1650_);
v___f_1660_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1660_, 0, v_toSeq_1650_);
v___x_1661_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_1661_, 0, v___x_1657_);
lean_ctor_set(v___x_1661_, 1, v___f_1653_);
lean_ctor_set(v___x_1661_, 2, v___f_1660_);
lean_ctor_set(v___x_1661_, 3, v___f_1659_);
lean_ctor_set(v___x_1661_, 4, v___f_1658_);
v___x_1662_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1662_, 0, v___x_1661_);
lean_ctor_set(v___x_1662_, 1, v___f_1654_);
v___x_1663_ = l_StateRefT_x27_instMonad___redArg(v___x_1662_);
v_toApplicative_1664_ = lean_ctor_get(v___x_1663_, 0);
v_isSharedCheck_1754_ = !lean_is_exclusive(v___x_1663_);
if (v_isSharedCheck_1754_ == 0)
{
lean_object* v_unused_1755_; 
v_unused_1755_ = lean_ctor_get(v___x_1663_, 1);
lean_dec(v_unused_1755_);
v___x_1666_ = v___x_1663_;
v_isShared_1667_ = v_isSharedCheck_1754_;
goto v_resetjp_1665_;
}
else
{
lean_inc(v_toApplicative_1664_);
lean_dec(v___x_1663_);
v___x_1666_ = lean_box(0);
v_isShared_1667_ = v_isSharedCheck_1754_;
goto v_resetjp_1665_;
}
v_resetjp_1665_:
{
lean_object* v_toFunctor_1668_; lean_object* v_toSeq_1669_; lean_object* v_toSeqLeft_1670_; lean_object* v_toSeqRight_1671_; lean_object* v___x_1673_; uint8_t v_isShared_1674_; uint8_t v_isSharedCheck_1752_; 
v_toFunctor_1668_ = lean_ctor_get(v_toApplicative_1664_, 0);
v_toSeq_1669_ = lean_ctor_get(v_toApplicative_1664_, 2);
v_toSeqLeft_1670_ = lean_ctor_get(v_toApplicative_1664_, 3);
v_toSeqRight_1671_ = lean_ctor_get(v_toApplicative_1664_, 4);
v_isSharedCheck_1752_ = !lean_is_exclusive(v_toApplicative_1664_);
if (v_isSharedCheck_1752_ == 0)
{
lean_object* v_unused_1753_; 
v_unused_1753_ = lean_ctor_get(v_toApplicative_1664_, 1);
lean_dec(v_unused_1753_);
v___x_1673_ = v_toApplicative_1664_;
v_isShared_1674_ = v_isSharedCheck_1752_;
goto v_resetjp_1672_;
}
else
{
lean_inc(v_toSeqRight_1671_);
lean_inc(v_toSeqLeft_1670_);
lean_inc(v_toSeq_1669_);
lean_inc(v_toFunctor_1668_);
lean_dec(v_toApplicative_1664_);
v___x_1673_ = lean_box(0);
v_isShared_1674_ = v_isSharedCheck_1752_;
goto v_resetjp_1672_;
}
v_resetjp_1672_:
{
lean_object* v___f_1675_; lean_object* v___f_1676_; lean_object* v___f_1677_; lean_object* v___f_1678_; lean_object* v___x_1679_; lean_object* v___f_1680_; lean_object* v___f_1681_; lean_object* v___f_1682_; lean_object* v___x_1684_; 
v___f_1675_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4));
v___f_1676_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5));
lean_inc_ref(v_toFunctor_1668_);
v___f_1677_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1677_, 0, v_toFunctor_1668_);
v___f_1678_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1678_, 0, v_toFunctor_1668_);
v___x_1679_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1679_, 0, v___f_1677_);
lean_ctor_set(v___x_1679_, 1, v___f_1678_);
v___f_1680_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1680_, 0, v_toSeqRight_1671_);
v___f_1681_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1681_, 0, v_toSeqLeft_1670_);
v___f_1682_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1682_, 0, v_toSeq_1669_);
if (v_isShared_1674_ == 0)
{
lean_ctor_set(v___x_1673_, 4, v___f_1680_);
lean_ctor_set(v___x_1673_, 3, v___f_1681_);
lean_ctor_set(v___x_1673_, 2, v___f_1682_);
lean_ctor_set(v___x_1673_, 1, v___f_1675_);
lean_ctor_set(v___x_1673_, 0, v___x_1679_);
v___x_1684_ = v___x_1673_;
goto v_reusejp_1683_;
}
else
{
lean_object* v_reuseFailAlloc_1751_; 
v_reuseFailAlloc_1751_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_1751_, 0, v___x_1679_);
lean_ctor_set(v_reuseFailAlloc_1751_, 1, v___f_1675_);
lean_ctor_set(v_reuseFailAlloc_1751_, 2, v___f_1682_);
lean_ctor_set(v_reuseFailAlloc_1751_, 3, v___f_1681_);
lean_ctor_set(v_reuseFailAlloc_1751_, 4, v___f_1680_);
v___x_1684_ = v_reuseFailAlloc_1751_;
goto v_reusejp_1683_;
}
v_reusejp_1683_:
{
lean_object* v___x_1686_; 
if (v_isShared_1667_ == 0)
{
lean_ctor_set(v___x_1666_, 1, v___f_1676_);
lean_ctor_set(v___x_1666_, 0, v___x_1684_);
v___x_1686_ = v___x_1666_;
goto v_reusejp_1685_;
}
else
{
lean_object* v_reuseFailAlloc_1750_; 
v_reuseFailAlloc_1750_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_1750_, 0, v___x_1684_);
lean_ctor_set(v_reuseFailAlloc_1750_, 1, v___f_1676_);
v___x_1686_ = v_reuseFailAlloc_1750_;
goto v_reusejp_1685_;
}
v_reusejp_1685_:
{
lean_object* v___x_1687_; lean_object* v___x_1688_; lean_object* v___x_1689_; lean_object* v___x_1690_; lean_object* v_toApplicative_1691_; lean_object* v_toFunctor_1692_; lean_object* v_toSeq_1693_; lean_object* v_toSeqLeft_1694_; lean_object* v_toSeqRight_1695_; lean_object* v___f_1696_; lean_object* v___f_1697_; lean_object* v___f_1698_; lean_object* v___x_1699_; lean_object* v___f_1700_; lean_object* v___f_1701_; lean_object* v___f_1702_; lean_object* v___x_1703_; lean_object* v___x_1704_; lean_object* v___x_1705_; lean_object* v___x_1706_; lean_object* v___x_1707_; lean_object* v___f_1708_; lean_object* v___f_1709_; lean_object* v___x_1710_; lean_object* v___f_1711_; lean_object* v___f_1712_; lean_object* v___x_1713_; lean_object* v___x_2538__overap_1714_; lean_object* v___x_1715_; 
v___x_1687_ = l_StateRefT_x27_instMonad___redArg(v___x_1686_);
v___x_1688_ = l_ReaderT_instMonad___redArg(v___x_1687_);
v___x_1689_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__6);
v___x_1690_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__7);
v_toApplicative_1691_ = lean_ctor_get(v___x_1647_, 0);
v_toFunctor_1692_ = lean_ctor_get(v_toApplicative_1691_, 0);
v_toSeq_1693_ = lean_ctor_get(v_toApplicative_1691_, 2);
v_toSeqLeft_1694_ = lean_ctor_get(v_toApplicative_1691_, 3);
v_toSeqRight_1695_ = lean_ctor_get(v_toApplicative_1691_, 4);
v___f_1696_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__8));
lean_inc_ref_n(v_toFunctor_1692_, 2);
v___f_1697_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_1697_, 0, v_toFunctor_1692_);
v___f_1698_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1698_, 0, v_toFunctor_1692_);
v___x_1699_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1699_, 0, v___f_1697_);
lean_ctor_set(v___x_1699_, 1, v___f_1698_);
lean_inc(v_toSeqRight_1695_);
v___f_1700_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_1700_, 0, v_toSeqRight_1695_);
lean_inc(v_toSeqLeft_1694_);
v___f_1701_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_1701_, 0, v_toSeqLeft_1694_);
lean_inc(v_toSeq_1693_);
v___f_1702_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_1702_, 0, v_toSeq_1693_);
v___x_1703_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_1703_, 0, v___x_1699_);
lean_ctor_set(v___x_1703_, 1, v___f_1653_);
lean_ctor_set(v___x_1703_, 2, v___f_1702_);
lean_ctor_set(v___x_1703_, 3, v___f_1701_);
lean_ctor_set(v___x_1703_, 4, v___f_1700_);
v___x_1704_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1704_, 0, v___x_1703_);
lean_ctor_set(v___x_1704_, 1, v___f_1654_);
v___x_1705_ = l_StateRefT_x27_instMonad___redArg(v___x_1704_);
v___x_1706_ = lean_alloc_closure((void*)(l_ReaderT_pure___boxed), 6, 3);
lean_closure_set(v___x_1706_, 0, lean_box(0));
lean_closure_set(v___x_1706_, 1, lean_box(0));
lean_closure_set(v___x_1706_, 2, v___x_1705_);
v___x_1707_ = l_instMonadControlTOfPure___redArg(v___x_1706_);
lean_inc_ref(v___x_1707_);
v___f_1708_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__3), 4, 2);
lean_closure_set(v___f_1708_, 0, v___x_1690_);
lean_closure_set(v___f_1708_, 1, v___x_1707_);
v___f_1709_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__4), 4, 2);
lean_closure_set(v___f_1709_, 0, v___x_1690_);
lean_closure_set(v___f_1709_, 1, v___x_1707_);
v___x_1710_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1710_, 0, v___f_1708_);
lean_ctor_set(v___x_1710_, 1, v___f_1709_);
lean_inc_ref(v___x_1710_);
v___f_1711_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__3), 4, 2);
lean_closure_set(v___f_1711_, 0, v___x_1689_);
lean_closure_set(v___f_1711_, 1, v___x_1710_);
v___f_1712_ = lean_alloc_closure((void*)(l_instMonadControlTOfMonadControl___redArg___lam__4), 4, 2);
lean_closure_set(v___f_1712_, 0, v___x_1689_);
lean_closure_set(v___f_1712_, 1, v___x_1710_);
v___x_1713_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1713_, 0, v___f_1711_);
lean_ctor_set(v___x_1713_, 1, v___f_1712_);
lean_inc(v_goal_1638_);
v___x_2538__overap_1714_ = l_Lean_MVarId_withContext___redArg(v___x_1713_, v___x_1688_, v_goal_1638_, v___f_1696_);
lean_inc(v_a_1645_);
lean_inc_ref(v_a_1644_);
lean_inc(v_a_1643_);
lean_inc_ref(v_a_1642_);
lean_inc(v_a_1641_);
lean_inc_ref(v_a_1640_);
v___x_1715_ = lean_apply_7(v___x_2538__overap_1714_, v_a_1640_, v_a_1641_, v_a_1642_, v_a_1643_, v_a_1644_, v_a_1645_, lean_box(0));
if (lean_obj_tag(v___x_1715_) == 0)
{
lean_object* v_a_1716_; lean_object* v___x_1717_; lean_object* v___x_1718_; lean_object* v___x_1719_; lean_object* v___x_1720_; lean_object* v___x_1721_; lean_object* v___x_1722_; lean_object* v___x_1723_; lean_object* v___x_1724_; lean_object* v___x_1725_; lean_object* v___x_1726_; lean_object* v___x_1727_; lean_object* v___x_1728_; uint8_t v___x_1729_; lean_object* v___x_1730_; lean_object* v___x_1731_; lean_object* v___x_1732_; 
v_a_1716_ = lean_ctor_get(v___x_1715_, 0);
lean_inc(v_a_1716_);
lean_dec_ref_known(v___x_1715_, 1);
v___x_1717_ = lean_array_get_size(v_a_1716_);
lean_dec(v_a_1716_);
v___x_1718_ = lean_unsigned_to_nat(0u);
v___x_1719_ = lean_unsigned_to_nat(4u);
v___x_1720_ = lean_nat_mul(v___x_1717_, v___x_1719_);
v___x_1721_ = lean_unsigned_to_nat(3u);
v___x_1722_ = lean_nat_div(v___x_1720_, v___x_1721_);
lean_dec(v___x_1720_);
v___x_1723_ = l_Nat_nextPowerOfTwo(v___x_1722_);
lean_dec(v___x_1722_);
v___x_1724_ = lean_box(0);
v___x_1725_ = lean_mk_array(v___x_1723_, v___x_1724_);
v___x_1726_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_1726_, 0, v___x_1718_);
lean_ctor_set(v___x_1726_, 1, v___x_1725_);
v___x_1727_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__11);
v___x_1728_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__12));
v___x_1729_ = 0;
lean_inc_ref(v___x_1726_);
v___x_1730_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v___x_1730_, 0, v___x_1726_);
lean_ctor_set(v___x_1730_, 1, v___x_1726_);
lean_ctor_set(v___x_1730_, 2, v___x_1727_);
lean_ctor_set(v___x_1730_, 3, v_goal_1638_);
lean_ctor_set(v___x_1730_, 4, v___x_1728_);
lean_ctor_set_uint8(v___x_1730_, sizeof(void*)*5, v___x_1729_);
v___x_1731_ = lean_st_mk_ref(v___x_1730_);
lean_inc(v_a_1645_);
lean_inc_ref(v_a_1644_);
lean_inc(v_a_1643_);
lean_inc_ref(v_a_1642_);
lean_inc(v_a_1641_);
lean_inc_ref(v_a_1640_);
lean_inc(v___x_1731_);
v___x_1732_ = lean_apply_9(v_x_1639_, v_cfg_1637_, v___x_1731_, v_a_1640_, v_a_1641_, v_a_1642_, v_a_1643_, v_a_1644_, v_a_1645_, lean_box(0));
if (lean_obj_tag(v___x_1732_) == 0)
{
lean_object* v_a_1733_; lean_object* v___x_1735_; uint8_t v_isShared_1736_; uint8_t v_isSharedCheck_1741_; 
v_a_1733_ = lean_ctor_get(v___x_1732_, 0);
v_isSharedCheck_1741_ = !lean_is_exclusive(v___x_1732_);
if (v_isSharedCheck_1741_ == 0)
{
v___x_1735_ = v___x_1732_;
v_isShared_1736_ = v_isSharedCheck_1741_;
goto v_resetjp_1734_;
}
else
{
lean_inc(v_a_1733_);
lean_dec(v___x_1732_);
v___x_1735_ = lean_box(0);
v_isShared_1736_ = v_isSharedCheck_1741_;
goto v_resetjp_1734_;
}
v_resetjp_1734_:
{
lean_object* v___x_1737_; lean_object* v___x_1739_; 
v___x_1737_ = lean_st_ref_get(v___x_1731_);
lean_dec(v___x_1731_);
lean_dec(v___x_1737_);
if (v_isShared_1736_ == 0)
{
v___x_1739_ = v___x_1735_;
goto v_reusejp_1738_;
}
else
{
lean_object* v_reuseFailAlloc_1740_; 
v_reuseFailAlloc_1740_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1740_, 0, v_a_1733_);
v___x_1739_ = v_reuseFailAlloc_1740_;
goto v_reusejp_1738_;
}
v_reusejp_1738_:
{
return v___x_1739_;
}
}
}
else
{
lean_dec(v___x_1731_);
return v___x_1732_;
}
}
else
{
lean_object* v_a_1742_; lean_object* v___x_1744_; uint8_t v_isShared_1745_; uint8_t v_isSharedCheck_1749_; 
lean_dec_ref(v_x_1639_);
lean_dec(v_goal_1638_);
lean_dec_ref(v_cfg_1637_);
v_a_1742_ = lean_ctor_get(v___x_1715_, 0);
v_isSharedCheck_1749_ = !lean_is_exclusive(v___x_1715_);
if (v_isSharedCheck_1749_ == 0)
{
v___x_1744_ = v___x_1715_;
v_isShared_1745_ = v_isSharedCheck_1749_;
goto v_resetjp_1743_;
}
else
{
lean_inc(v_a_1742_);
lean_dec(v___x_1715_);
v___x_1744_ = lean_box(0);
v_isShared_1745_ = v_isSharedCheck_1749_;
goto v_resetjp_1743_;
}
v_resetjp_1743_:
{
lean_object* v___x_1747_; 
if (v_isShared_1745_ == 0)
{
v___x_1747_ = v___x_1744_;
goto v_reusejp_1746_;
}
else
{
lean_object* v_reuseFailAlloc_1748_; 
v_reuseFailAlloc_1748_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1748_, 0, v_a_1742_);
v___x_1747_ = v_reuseFailAlloc_1748_;
goto v_reusejp_1746_;
}
v_reusejp_1746_:
{
return v___x_1747_;
}
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27___boxed(lean_object* v_00_u03b1_1756_, lean_object* v_cfg_1757_, lean_object* v_goal_1758_, lean_object* v_x_1759_, lean_object* v_a_1760_, lean_object* v_a_1761_, lean_object* v_a_1762_, lean_object* v_a_1763_, lean_object* v_a_1764_, lean_object* v_a_1765_, lean_object* v_a_1766_){
_start:
{
lean_object* v_res_1767_; 
v_res_1767_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run_x27(v_00_u03b1_1756_, v_cfg_1757_, v_goal_1758_, v_x_1759_, v_a_1760_, v_a_1761_, v_a_1762_, v_a_1763_, v_a_1764_, v_a_1765_);
lean_dec(v_a_1765_);
lean_dec_ref(v_a_1764_);
lean_dec(v_a_1763_);
lean_dec_ref(v_a_1762_);
lean_dec(v_a_1761_);
lean_dec_ref(v_a_1760_);
return v_res_1767_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg___lam__0(lean_object* v_x_1768_, lean_object* v___y_1769_, lean_object* v___y_1770_, lean_object* v___y_1771_, lean_object* v___y_1772_, lean_object* v___y_1773_, lean_object* v___y_1774_, lean_object* v___y_1775_, lean_object* v___y_1776_){
_start:
{
lean_object* v___x_1778_; 
lean_inc(v___y_1772_);
lean_inc_ref(v___y_1771_);
lean_inc(v___y_1770_);
lean_inc_ref(v___y_1769_);
v___x_1778_ = lean_apply_9(v_x_1768_, v___y_1769_, v___y_1770_, v___y_1771_, v___y_1772_, v___y_1773_, v___y_1774_, v___y_1775_, v___y_1776_, lean_box(0));
return v___x_1778_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg___lam__0___boxed(lean_object* v_x_1779_, lean_object* v___y_1780_, lean_object* v___y_1781_, lean_object* v___y_1782_, lean_object* v___y_1783_, lean_object* v___y_1784_, lean_object* v___y_1785_, lean_object* v___y_1786_, lean_object* v___y_1787_, lean_object* v___y_1788_){
_start:
{
lean_object* v_res_1789_; 
v_res_1789_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg___lam__0(v_x_1779_, v___y_1780_, v___y_1781_, v___y_1782_, v___y_1783_, v___y_1784_, v___y_1785_, v___y_1786_, v___y_1787_);
lean_dec(v___y_1783_);
lean_dec_ref(v___y_1782_);
lean_dec(v___y_1781_);
lean_dec_ref(v___y_1780_);
return v_res_1789_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg(lean_object* v_mvarId_1790_, lean_object* v_x_1791_, lean_object* v___y_1792_, lean_object* v___y_1793_, lean_object* v___y_1794_, lean_object* v___y_1795_, lean_object* v___y_1796_, lean_object* v___y_1797_, lean_object* v___y_1798_, lean_object* v___y_1799_){
_start:
{
lean_object* v___f_1801_; lean_object* v___x_1802_; 
lean_inc(v___y_1795_);
lean_inc_ref(v___y_1794_);
lean_inc(v___y_1793_);
lean_inc_ref(v___y_1792_);
v___f_1801_ = lean_alloc_closure((void*)(l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg___lam__0___boxed), 10, 5);
lean_closure_set(v___f_1801_, 0, v_x_1791_);
lean_closure_set(v___f_1801_, 1, v___y_1792_);
lean_closure_set(v___f_1801_, 2, v___y_1793_);
lean_closure_set(v___f_1801_, 3, v___y_1794_);
lean_closure_set(v___f_1801_, 4, v___y_1795_);
v___x_1802_ = l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_box(0), v_mvarId_1790_, v___f_1801_, v___y_1796_, v___y_1797_, v___y_1798_, v___y_1799_);
if (lean_obj_tag(v___x_1802_) == 0)
{
return v___x_1802_;
}
else
{
lean_object* v_a_1803_; lean_object* v___x_1805_; uint8_t v_isShared_1806_; uint8_t v_isSharedCheck_1810_; 
v_a_1803_ = lean_ctor_get(v___x_1802_, 0);
v_isSharedCheck_1810_ = !lean_is_exclusive(v___x_1802_);
if (v_isSharedCheck_1810_ == 0)
{
v___x_1805_ = v___x_1802_;
v_isShared_1806_ = v_isSharedCheck_1810_;
goto v_resetjp_1804_;
}
else
{
lean_inc(v_a_1803_);
lean_dec(v___x_1802_);
v___x_1805_ = lean_box(0);
v_isShared_1806_ = v_isSharedCheck_1810_;
goto v_resetjp_1804_;
}
v_resetjp_1804_:
{
lean_object* v___x_1808_; 
if (v_isShared_1806_ == 0)
{
v___x_1808_ = v___x_1805_;
goto v_reusejp_1807_;
}
else
{
lean_object* v_reuseFailAlloc_1809_; 
v_reuseFailAlloc_1809_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1809_, 0, v_a_1803_);
v___x_1808_ = v_reuseFailAlloc_1809_;
goto v_reusejp_1807_;
}
v_reusejp_1807_:
{
return v___x_1808_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg___boxed(lean_object* v_mvarId_1811_, lean_object* v_x_1812_, lean_object* v___y_1813_, lean_object* v___y_1814_, lean_object* v___y_1815_, lean_object* v___y_1816_, lean_object* v___y_1817_, lean_object* v___y_1818_, lean_object* v___y_1819_, lean_object* v___y_1820_, lean_object* v___y_1821_){
_start:
{
lean_object* v_res_1822_; 
v_res_1822_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg(v_mvarId_1811_, v_x_1812_, v___y_1813_, v___y_1814_, v___y_1815_, v___y_1816_, v___y_1817_, v___y_1818_, v___y_1819_, v___y_1820_);
lean_dec(v___y_1820_);
lean_dec_ref(v___y_1819_);
lean_dec(v___y_1818_);
lean_dec_ref(v___y_1817_);
lean_dec(v___y_1816_);
lean_dec_ref(v___y_1815_);
lean_dec(v___y_1814_);
lean_dec_ref(v___y_1813_);
return v_res_1822_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1(lean_object* v_00_u03b1_1823_, lean_object* v_mvarId_1824_, lean_object* v_x_1825_, lean_object* v___y_1826_, lean_object* v___y_1827_, lean_object* v___y_1828_, lean_object* v___y_1829_, lean_object* v___y_1830_, lean_object* v___y_1831_, lean_object* v___y_1832_, lean_object* v___y_1833_){
_start:
{
lean_object* v___x_1835_; 
v___x_1835_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg(v_mvarId_1824_, v_x_1825_, v___y_1826_, v___y_1827_, v___y_1828_, v___y_1829_, v___y_1830_, v___y_1831_, v___y_1832_, v___y_1833_);
return v___x_1835_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___boxed(lean_object* v_00_u03b1_1836_, lean_object* v_mvarId_1837_, lean_object* v_x_1838_, lean_object* v___y_1839_, lean_object* v___y_1840_, lean_object* v___y_1841_, lean_object* v___y_1842_, lean_object* v___y_1843_, lean_object* v___y_1844_, lean_object* v___y_1845_, lean_object* v___y_1846_, lean_object* v___y_1847_){
_start:
{
lean_object* v_res_1848_; 
v_res_1848_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1(v_00_u03b1_1836_, v_mvarId_1837_, v_x_1838_, v___y_1839_, v___y_1840_, v___y_1841_, v___y_1842_, v___y_1843_, v___y_1844_, v___y_1845_, v___y_1846_);
lean_dec(v___y_1846_);
lean_dec_ref(v___y_1845_);
lean_dec(v___y_1844_);
lean_dec_ref(v___y_1843_);
lean_dec(v___y_1842_);
lean_dec_ref(v___y_1841_);
lean_dec(v___y_1840_);
lean_dec_ref(v___y_1839_);
return v_res_1848_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0___redArg(size_t v_sz_1849_, size_t v_i_1850_, lean_object* v_bs_1851_, lean_object* v___y_1852_, lean_object* v___y_1853_, lean_object* v___y_1854_, lean_object* v___y_1855_, lean_object* v___y_1856_, lean_object* v___y_1857_){
_start:
{
uint8_t v___x_1859_; 
v___x_1859_ = lean_usize_dec_lt(v_i_1850_, v_sz_1849_);
if (v___x_1859_ == 0)
{
lean_object* v___x_1860_; 
v___x_1860_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_1860_, 0, v_bs_1851_);
return v___x_1860_;
}
else
{
lean_object* v_v_1861_; lean_object* v___x_1862_; 
v_v_1861_ = lean_array_uget(v_bs_1851_, v_i_1850_);
lean_inc(v_v_1861_);
v___x_1862_ = l_Lean_FVarId_getUserName___redArg(v_v_1861_, v___y_1854_, v___y_1856_, v___y_1857_);
if (lean_obj_tag(v___x_1862_) == 0)
{
lean_object* v_a_1863_; lean_object* v___x_1864_; 
v_a_1863_ = lean_ctor_get(v___x_1862_, 0);
lean_inc(v_a_1863_);
lean_dec_ref_known(v___x_1862_, 1);
lean_inc(v_v_1861_);
v___x_1864_ = l_Lean_FVarId_getType___redArg(v_v_1861_, v___y_1854_, v___y_1856_, v___y_1857_);
if (lean_obj_tag(v___x_1864_) == 0)
{
lean_object* v_a_1865_; lean_object* v___x_1866_; 
v_a_1865_ = lean_ctor_get(v___x_1864_, 0);
lean_inc(v_a_1865_);
lean_dec_ref_known(v___x_1864_, 1);
v___x_1866_ = l_Lean_Meta_Sym_instantiateMVarsS(v_a_1865_, v___y_1852_, v___y_1853_, v___y_1854_, v___y_1855_, v___y_1856_, v___y_1857_);
if (lean_obj_tag(v___x_1866_) == 0)
{
lean_object* v_a_1867_; lean_object* v___x_1868_; lean_object* v_bs_x27_1869_; lean_object* v___x_1870_; lean_object* v___x_1871_; size_t v___x_1872_; size_t v___x_1873_; lean_object* v___x_1874_; 
v_a_1867_ = lean_ctor_get(v___x_1866_, 0);
lean_inc(v_a_1867_);
lean_dec_ref_known(v___x_1866_, 1);
v___x_1868_ = lean_unsigned_to_nat(0u);
v_bs_x27_1869_ = lean_array_uset(v_bs_1851_, v_i_1850_, v___x_1868_);
v___x_1870_ = l_Lean_mkFVar(v_v_1861_);
v___x_1871_ = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(v___x_1871_, 0, v_a_1863_);
lean_ctor_set(v___x_1871_, 1, v_a_1867_);
lean_ctor_set(v___x_1871_, 2, v___x_1870_);
v___x_1872_ = ((size_t)1ULL);
v___x_1873_ = lean_usize_add(v_i_1850_, v___x_1872_);
v___x_1874_ = lean_array_uset(v_bs_x27_1869_, v_i_1850_, v___x_1871_);
v_i_1850_ = v___x_1873_;
v_bs_1851_ = v___x_1874_;
goto _start;
}
else
{
lean_object* v_a_1876_; lean_object* v___x_1878_; uint8_t v_isShared_1879_; uint8_t v_isSharedCheck_1883_; 
lean_dec(v_a_1863_);
lean_dec(v_v_1861_);
lean_dec_ref(v_bs_1851_);
v_a_1876_ = lean_ctor_get(v___x_1866_, 0);
v_isSharedCheck_1883_ = !lean_is_exclusive(v___x_1866_);
if (v_isSharedCheck_1883_ == 0)
{
v___x_1878_ = v___x_1866_;
v_isShared_1879_ = v_isSharedCheck_1883_;
goto v_resetjp_1877_;
}
else
{
lean_inc(v_a_1876_);
lean_dec(v___x_1866_);
v___x_1878_ = lean_box(0);
v_isShared_1879_ = v_isSharedCheck_1883_;
goto v_resetjp_1877_;
}
v_resetjp_1877_:
{
lean_object* v___x_1881_; 
if (v_isShared_1879_ == 0)
{
v___x_1881_ = v___x_1878_;
goto v_reusejp_1880_;
}
else
{
lean_object* v_reuseFailAlloc_1882_; 
v_reuseFailAlloc_1882_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1882_, 0, v_a_1876_);
v___x_1881_ = v_reuseFailAlloc_1882_;
goto v_reusejp_1880_;
}
v_reusejp_1880_:
{
return v___x_1881_;
}
}
}
}
else
{
lean_object* v_a_1884_; lean_object* v___x_1886_; uint8_t v_isShared_1887_; uint8_t v_isSharedCheck_1891_; 
lean_dec(v_a_1863_);
lean_dec(v_v_1861_);
lean_dec_ref(v_bs_1851_);
v_a_1884_ = lean_ctor_get(v___x_1864_, 0);
v_isSharedCheck_1891_ = !lean_is_exclusive(v___x_1864_);
if (v_isSharedCheck_1891_ == 0)
{
v___x_1886_ = v___x_1864_;
v_isShared_1887_ = v_isSharedCheck_1891_;
goto v_resetjp_1885_;
}
else
{
lean_inc(v_a_1884_);
lean_dec(v___x_1864_);
v___x_1886_ = lean_box(0);
v_isShared_1887_ = v_isSharedCheck_1891_;
goto v_resetjp_1885_;
}
v_resetjp_1885_:
{
lean_object* v___x_1889_; 
if (v_isShared_1887_ == 0)
{
v___x_1889_ = v___x_1886_;
goto v_reusejp_1888_;
}
else
{
lean_object* v_reuseFailAlloc_1890_; 
v_reuseFailAlloc_1890_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1890_, 0, v_a_1884_);
v___x_1889_ = v_reuseFailAlloc_1890_;
goto v_reusejp_1888_;
}
v_reusejp_1888_:
{
return v___x_1889_;
}
}
}
}
else
{
lean_object* v_a_1892_; lean_object* v___x_1894_; uint8_t v_isShared_1895_; uint8_t v_isSharedCheck_1899_; 
lean_dec(v_v_1861_);
lean_dec_ref(v_bs_1851_);
v_a_1892_ = lean_ctor_get(v___x_1862_, 0);
v_isSharedCheck_1899_ = !lean_is_exclusive(v___x_1862_);
if (v_isSharedCheck_1899_ == 0)
{
v___x_1894_ = v___x_1862_;
v_isShared_1895_ = v_isSharedCheck_1899_;
goto v_resetjp_1893_;
}
else
{
lean_inc(v_a_1892_);
lean_dec(v___x_1862_);
v___x_1894_ = lean_box(0);
v_isShared_1895_ = v_isSharedCheck_1899_;
goto v_resetjp_1893_;
}
v_resetjp_1893_:
{
lean_object* v___x_1897_; 
if (v_isShared_1895_ == 0)
{
v___x_1897_ = v___x_1894_;
goto v_reusejp_1896_;
}
else
{
lean_object* v_reuseFailAlloc_1898_; 
v_reuseFailAlloc_1898_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1898_, 0, v_a_1892_);
v___x_1897_ = v_reuseFailAlloc_1898_;
goto v_reusejp_1896_;
}
v_reusejp_1896_:
{
return v___x_1897_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0___redArg___boxed(lean_object* v_sz_1900_, lean_object* v_i_1901_, lean_object* v_bs_1902_, lean_object* v___y_1903_, lean_object* v___y_1904_, lean_object* v___y_1905_, lean_object* v___y_1906_, lean_object* v___y_1907_, lean_object* v___y_1908_, lean_object* v___y_1909_){
_start:
{
size_t v_sz_boxed_1910_; size_t v_i_boxed_1911_; lean_object* v_res_1912_; 
v_sz_boxed_1910_ = lean_unbox_usize(v_sz_1900_);
lean_dec(v_sz_1900_);
v_i_boxed_1911_ = lean_unbox_usize(v_i_1901_);
lean_dec(v_i_1901_);
v_res_1912_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0___redArg(v_sz_boxed_1910_, v_i_boxed_1911_, v_bs_1902_, v___y_1903_, v___y_1904_, v___y_1905_, v___y_1906_, v___y_1907_, v___y_1908_);
lean_dec(v___y_1908_);
lean_dec_ref(v___y_1907_);
lean_dec(v___y_1906_);
lean_dec_ref(v___y_1905_);
lean_dec(v___y_1904_);
lean_dec_ref(v___y_1903_);
return v_res_1912_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___lam__0(lean_object* v___y_1913_, lean_object* v___y_1914_, lean_object* v___y_1915_, lean_object* v___y_1916_, lean_object* v___y_1917_, lean_object* v___y_1918_, lean_object* v___y_1919_, lean_object* v___y_1920_){
_start:
{
lean_object* v___x_1922_; 
v___x_1922_ = l_Lean_Meta_getPropHyps(v___y_1917_, v___y_1918_, v___y_1919_, v___y_1920_);
if (lean_obj_tag(v___x_1922_) == 0)
{
lean_object* v_a_1923_; size_t v_sz_1924_; size_t v___x_1925_; lean_object* v___x_1926_; 
v_a_1923_ = lean_ctor_get(v___x_1922_, 0);
lean_inc(v_a_1923_);
lean_dec_ref_known(v___x_1922_, 1);
v_sz_1924_ = lean_array_size(v_a_1923_);
v___x_1925_ = ((size_t)0ULL);
v___x_1926_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0___redArg(v_sz_1924_, v___x_1925_, v_a_1923_, v___y_1915_, v___y_1916_, v___y_1917_, v___y_1918_, v___y_1919_, v___y_1920_);
if (lean_obj_tag(v___x_1926_) == 0)
{
lean_object* v_a_1927_; lean_object* v___x_1929_; uint8_t v_isShared_1930_; uint8_t v_isSharedCheck_1950_; 
v_a_1927_ = lean_ctor_get(v___x_1926_, 0);
v_isSharedCheck_1950_ = !lean_is_exclusive(v___x_1926_);
if (v_isSharedCheck_1950_ == 0)
{
v___x_1929_ = v___x_1926_;
v_isShared_1930_ = v_isSharedCheck_1950_;
goto v_resetjp_1928_;
}
else
{
lean_inc(v_a_1927_);
lean_dec(v___x_1926_);
v___x_1929_ = lean_box(0);
v_isShared_1930_ = v_isSharedCheck_1950_;
goto v_resetjp_1928_;
}
v_resetjp_1928_:
{
lean_object* v___x_1931_; lean_object* v_rewriteCache_1932_; lean_object* v_acNfCache_1933_; lean_object* v_typeAnalysis_1934_; lean_object* v_goal_1935_; uint8_t v_didChange_1936_; lean_object* v___x_1938_; uint8_t v_isShared_1939_; uint8_t v_isSharedCheck_1948_; 
v___x_1931_ = lean_st_ref_take(v___y_1914_);
v_rewriteCache_1932_ = lean_ctor_get(v___x_1931_, 0);
v_acNfCache_1933_ = lean_ctor_get(v___x_1931_, 1);
v_typeAnalysis_1934_ = lean_ctor_get(v___x_1931_, 2);
v_goal_1935_ = lean_ctor_get(v___x_1931_, 3);
v_didChange_1936_ = lean_ctor_get_uint8(v___x_1931_, sizeof(void*)*5);
v_isSharedCheck_1948_ = !lean_is_exclusive(v___x_1931_);
if (v_isSharedCheck_1948_ == 0)
{
lean_object* v_unused_1949_; 
v_unused_1949_ = lean_ctor_get(v___x_1931_, 4);
lean_dec(v_unused_1949_);
v___x_1938_ = v___x_1931_;
v_isShared_1939_ = v_isSharedCheck_1948_;
goto v_resetjp_1937_;
}
else
{
lean_inc(v_goal_1935_);
lean_inc(v_typeAnalysis_1934_);
lean_inc(v_acNfCache_1933_);
lean_inc(v_rewriteCache_1932_);
lean_dec(v___x_1931_);
v___x_1938_ = lean_box(0);
v_isShared_1939_ = v_isSharedCheck_1948_;
goto v_resetjp_1937_;
}
v_resetjp_1937_:
{
lean_object* v___x_1941_; 
if (v_isShared_1939_ == 0)
{
lean_ctor_set(v___x_1938_, 4, v_a_1927_);
v___x_1941_ = v___x_1938_;
goto v_reusejp_1940_;
}
else
{
lean_object* v_reuseFailAlloc_1947_; 
v_reuseFailAlloc_1947_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_1947_, 0, v_rewriteCache_1932_);
lean_ctor_set(v_reuseFailAlloc_1947_, 1, v_acNfCache_1933_);
lean_ctor_set(v_reuseFailAlloc_1947_, 2, v_typeAnalysis_1934_);
lean_ctor_set(v_reuseFailAlloc_1947_, 3, v_goal_1935_);
lean_ctor_set(v_reuseFailAlloc_1947_, 4, v_a_1927_);
lean_ctor_set_uint8(v_reuseFailAlloc_1947_, sizeof(void*)*5, v_didChange_1936_);
v___x_1941_ = v_reuseFailAlloc_1947_;
goto v_reusejp_1940_;
}
v_reusejp_1940_:
{
lean_object* v___x_1942_; lean_object* v___x_1943_; lean_object* v___x_1945_; 
v___x_1942_ = lean_st_ref_set(v___y_1914_, v___x_1941_);
v___x_1943_ = lean_box(0);
if (v_isShared_1930_ == 0)
{
lean_ctor_set(v___x_1929_, 0, v___x_1943_);
v___x_1945_ = v___x_1929_;
goto v_reusejp_1944_;
}
else
{
lean_object* v_reuseFailAlloc_1946_; 
v_reuseFailAlloc_1946_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1946_, 0, v___x_1943_);
v___x_1945_ = v_reuseFailAlloc_1946_;
goto v_reusejp_1944_;
}
v_reusejp_1944_:
{
return v___x_1945_;
}
}
}
}
}
else
{
lean_object* v_a_1951_; lean_object* v___x_1953_; uint8_t v_isShared_1954_; uint8_t v_isSharedCheck_1958_; 
v_a_1951_ = lean_ctor_get(v___x_1926_, 0);
v_isSharedCheck_1958_ = !lean_is_exclusive(v___x_1926_);
if (v_isSharedCheck_1958_ == 0)
{
v___x_1953_ = v___x_1926_;
v_isShared_1954_ = v_isSharedCheck_1958_;
goto v_resetjp_1952_;
}
else
{
lean_inc(v_a_1951_);
lean_dec(v___x_1926_);
v___x_1953_ = lean_box(0);
v_isShared_1954_ = v_isSharedCheck_1958_;
goto v_resetjp_1952_;
}
v_resetjp_1952_:
{
lean_object* v___x_1956_; 
if (v_isShared_1954_ == 0)
{
v___x_1956_ = v___x_1953_;
goto v_reusejp_1955_;
}
else
{
lean_object* v_reuseFailAlloc_1957_; 
v_reuseFailAlloc_1957_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1957_, 0, v_a_1951_);
v___x_1956_ = v_reuseFailAlloc_1957_;
goto v_reusejp_1955_;
}
v_reusejp_1955_:
{
return v___x_1956_;
}
}
}
}
else
{
lean_object* v_a_1959_; lean_object* v___x_1961_; uint8_t v_isShared_1962_; uint8_t v_isSharedCheck_1966_; 
v_a_1959_ = lean_ctor_get(v___x_1922_, 0);
v_isSharedCheck_1966_ = !lean_is_exclusive(v___x_1922_);
if (v_isSharedCheck_1966_ == 0)
{
v___x_1961_ = v___x_1922_;
v_isShared_1962_ = v_isSharedCheck_1966_;
goto v_resetjp_1960_;
}
else
{
lean_inc(v_a_1959_);
lean_dec(v___x_1922_);
v___x_1961_ = lean_box(0);
v_isShared_1962_ = v_isSharedCheck_1966_;
goto v_resetjp_1960_;
}
v_resetjp_1960_:
{
lean_object* v___x_1964_; 
if (v_isShared_1962_ == 0)
{
v___x_1964_ = v___x_1961_;
goto v_reusejp_1963_;
}
else
{
lean_object* v_reuseFailAlloc_1965_; 
v_reuseFailAlloc_1965_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1965_, 0, v_a_1959_);
v___x_1964_ = v_reuseFailAlloc_1965_;
goto v_reusejp_1963_;
}
v_reusejp_1963_:
{
return v___x_1964_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___lam__0___boxed(lean_object* v___y_1967_, lean_object* v___y_1968_, lean_object* v___y_1969_, lean_object* v___y_1970_, lean_object* v___y_1971_, lean_object* v___y_1972_, lean_object* v___y_1973_, lean_object* v___y_1974_, lean_object* v___y_1975_){
_start:
{
lean_object* v_res_1976_; 
v_res_1976_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___lam__0(v___y_1967_, v___y_1968_, v___y_1969_, v___y_1970_, v___y_1971_, v___y_1972_, v___y_1973_, v___y_1974_);
lean_dec(v___y_1974_);
lean_dec_ref(v___y_1973_);
lean_dec(v___y_1972_);
lean_dec_ref(v___y_1971_);
lean_dec(v___y_1970_);
lean_dec_ref(v___y_1969_);
lean_dec(v___y_1968_);
lean_dec_ref(v___y_1967_);
return v_res_1976_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal(lean_object* v_a_1978_, lean_object* v_a_1979_, lean_object* v_a_1980_, lean_object* v_a_1981_, lean_object* v_a_1982_, lean_object* v_a_1983_, lean_object* v_a_1984_, lean_object* v_a_1985_){
_start:
{
lean_object* v___x_1987_; lean_object* v_rewriteCache_1988_; lean_object* v_acNfCache_1989_; lean_object* v_typeAnalysis_1990_; lean_object* v_goal_1991_; lean_object* v_hypotheses_1992_; lean_object* v___x_1994_; uint8_t v_isShared_1995_; uint8_t v_isSharedCheck_2005_; 
v___x_1987_ = lean_st_ref_take(v_a_1979_);
v_rewriteCache_1988_ = lean_ctor_get(v___x_1987_, 0);
v_acNfCache_1989_ = lean_ctor_get(v___x_1987_, 1);
v_typeAnalysis_1990_ = lean_ctor_get(v___x_1987_, 2);
v_goal_1991_ = lean_ctor_get(v___x_1987_, 3);
v_hypotheses_1992_ = lean_ctor_get(v___x_1987_, 4);
v_isSharedCheck_2005_ = !lean_is_exclusive(v___x_1987_);
if (v_isSharedCheck_2005_ == 0)
{
v___x_1994_ = v___x_1987_;
v_isShared_1995_ = v_isSharedCheck_2005_;
goto v_resetjp_1993_;
}
else
{
lean_inc(v_hypotheses_1992_);
lean_inc(v_goal_1991_);
lean_inc(v_typeAnalysis_1990_);
lean_inc(v_acNfCache_1989_);
lean_inc(v_rewriteCache_1988_);
lean_dec(v___x_1987_);
v___x_1994_ = lean_box(0);
v_isShared_1995_ = v_isSharedCheck_2005_;
goto v_resetjp_1993_;
}
v_resetjp_1993_:
{
uint8_t v___x_1996_; lean_object* v___x_1998_; 
v___x_1996_ = 1;
if (v_isShared_1995_ == 0)
{
v___x_1998_ = v___x_1994_;
goto v_reusejp_1997_;
}
else
{
lean_object* v_reuseFailAlloc_2004_; 
v_reuseFailAlloc_2004_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_2004_, 0, v_rewriteCache_1988_);
lean_ctor_set(v_reuseFailAlloc_2004_, 1, v_acNfCache_1989_);
lean_ctor_set(v_reuseFailAlloc_2004_, 2, v_typeAnalysis_1990_);
lean_ctor_set(v_reuseFailAlloc_2004_, 3, v_goal_1991_);
lean_ctor_set(v_reuseFailAlloc_2004_, 4, v_hypotheses_1992_);
v___x_1998_ = v_reuseFailAlloc_2004_;
goto v_reusejp_1997_;
}
v_reusejp_1997_:
{
lean_object* v___x_1999_; lean_object* v___x_2000_; lean_object* v_goal_2001_; lean_object* v___f_2002_; lean_object* v___x_2003_; 
lean_ctor_set_uint8(v___x_1998_, sizeof(void*)*5, v___x_1996_);
v___x_1999_ = lean_st_ref_set(v_a_1979_, v___x_1998_);
v___x_2000_ = lean_st_ref_get(v_a_1979_);
v_goal_2001_ = lean_ctor_get(v___x_2000_, 3);
lean_inc(v_goal_2001_);
lean_dec(v___x_2000_);
v___f_2002_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___closed__0));
v___x_2003_ = l_Lean_MVarId_withContext___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__1___redArg(v_goal_2001_, v___f_2002_, v_a_1978_, v_a_1979_, v_a_1980_, v_a_1981_, v_a_1982_, v_a_1983_, v_a_1984_, v_a_1985_);
return v___x_2003_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal___boxed(lean_object* v_a_2006_, lean_object* v_a_2007_, lean_object* v_a_2008_, lean_object* v_a_2009_, lean_object* v_a_2010_, lean_object* v_a_2011_, lean_object* v_a_2012_, lean_object* v_a_2013_, lean_object* v_a_2014_){
_start:
{
lean_object* v_res_2015_; 
v_res_2015_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal(v_a_2006_, v_a_2007_, v_a_2008_, v_a_2009_, v_a_2010_, v_a_2011_, v_a_2012_, v_a_2013_);
lean_dec(v_a_2013_);
lean_dec_ref(v_a_2012_);
lean_dec(v_a_2011_);
lean_dec_ref(v_a_2010_);
lean_dec(v_a_2009_);
lean_dec_ref(v_a_2008_);
lean_dec(v_a_2007_);
lean_dec_ref(v_a_2006_);
return v_res_2015_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0(size_t v_sz_2016_, size_t v_i_2017_, lean_object* v_bs_2018_, lean_object* v___y_2019_, lean_object* v___y_2020_, lean_object* v___y_2021_, lean_object* v___y_2022_, lean_object* v___y_2023_, lean_object* v___y_2024_, lean_object* v___y_2025_, lean_object* v___y_2026_){
_start:
{
lean_object* v___x_2028_; 
v___x_2028_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0___redArg(v_sz_2016_, v_i_2017_, v_bs_2018_, v___y_2021_, v___y_2022_, v___y_2023_, v___y_2024_, v___y_2025_, v___y_2026_);
return v___x_2028_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0___boxed(lean_object* v_sz_2029_, lean_object* v_i_2030_, lean_object* v_bs_2031_, lean_object* v___y_2032_, lean_object* v___y_2033_, lean_object* v___y_2034_, lean_object* v___y_2035_, lean_object* v___y_2036_, lean_object* v___y_2037_, lean_object* v___y_2038_, lean_object* v___y_2039_, lean_object* v___y_2040_){
_start:
{
size_t v_sz_boxed_2041_; size_t v_i_boxed_2042_; lean_object* v_res_2043_; 
v_sz_boxed_2041_ = lean_unbox_usize(v_sz_2029_);
lean_dec(v_sz_2029_);
v_i_boxed_2042_ = lean_unbox_usize(v_i_2030_);
lean_dec(v_i_2030_);
v_res_2043_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_collectHypsFromGoal_spec__0(v_sz_boxed_2041_, v_i_boxed_2042_, v_bs_2031_, v___y_2032_, v___y_2033_, v___y_2034_, v___y_2035_, v___y_2036_, v___y_2037_, v___y_2038_, v___y_2039_);
lean_dec(v___y_2039_);
lean_dec_ref(v___y_2038_);
lean_dec(v___y_2037_);
lean_dec_ref(v___y_2036_);
lean_dec(v___y_2035_);
lean_dec_ref(v___y_2034_);
lean_dec(v___y_2033_);
lean_dec_ref(v___y_2032_);
return v_res_2043_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__2(void){
_start:
{
lean_object* v___x_2046_; lean_object* v___x_2047_; lean_object* v___x_2048_; 
v___x_2046_ = l_Lean_Core_instMonadTraceCoreM;
v___x_2047_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1));
v___x_2048_ = l_Lean_instMonadTraceOfMonadLift___redArg(v___x_2047_, v___x_2046_);
return v___x_2048_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__3(void){
_start:
{
lean_object* v___x_2049_; lean_object* v___f_2050_; lean_object* v___x_2051_; 
v___x_2049_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__2, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__2);
v___f_2050_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0));
v___x_2051_ = l_Lean_instMonadTraceOfMonadLift___redArg(v___f_2050_, v___x_2049_);
return v___x_2051_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__4(void){
_start:
{
lean_object* v___x_2052_; lean_object* v___x_2053_; lean_object* v___x_2054_; 
v___x_2052_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__3, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__3);
v___x_2053_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1));
v___x_2054_ = l_Lean_instMonadTraceOfMonadLift___redArg(v___x_2053_, v___x_2052_);
return v___x_2054_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__5(void){
_start:
{
lean_object* v___x_2055_; lean_object* v___f_2056_; lean_object* v___x_2057_; 
v___x_2055_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__4, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__4_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__4);
v___f_2056_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0));
v___x_2057_ = l_Lean_instMonadTraceOfMonadLift___redArg(v___f_2056_, v___x_2055_);
return v___x_2057_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__6(void){
_start:
{
lean_object* v___x_2058_; lean_object* v___x_2059_; lean_object* v___x_2060_; 
v___x_2058_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__5, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__5_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__5);
v___x_2059_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1));
v___x_2060_ = l_Lean_instMonadTraceOfMonadLift___redArg(v___x_2059_, v___x_2058_);
return v___x_2060_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7(void){
_start:
{
lean_object* v___x_2061_; lean_object* v___f_2062_; lean_object* v___x_2063_; 
v___x_2061_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__6, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__6);
v___f_2062_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0));
v___x_2063_ = l_Lean_instMonadTraceOfMonadLift___redArg(v___f_2062_, v___x_2061_);
return v___x_2063_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14(void){
_start:
{
lean_object* v_cls_2074_; lean_object* v___x_2075_; lean_object* v___x_2076_; 
v_cls_2074_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
v___x_2075_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__13));
v___x_2076_ = l_Lean_Name_append(v___x_2075_, v_cls_2074_);
return v___x_2076_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__17(void){
_start:
{
lean_object* v___x_2079_; lean_object* v___x_2080_; lean_object* v___x_2081_; lean_object* v___x_2082_; 
v___x_2079_ = l_Lean_Core_instMonadQuotationCoreM;
v___x_2080_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1));
v___x_2081_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__16));
v___x_2082_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___x_2081_, v___x_2080_, v___x_2079_);
return v___x_2082_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__18(void){
_start:
{
lean_object* v___x_2083_; lean_object* v___f_2084_; lean_object* v___f_2085_; lean_object* v___x_2086_; 
v___x_2083_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__17, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__17_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__17);
v___f_2084_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0));
v___f_2085_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__15));
v___x_2086_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___f_2085_, v___f_2084_, v___x_2083_);
return v___x_2086_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__19(void){
_start:
{
lean_object* v___x_2087_; lean_object* v___x_2088_; lean_object* v___x_2089_; lean_object* v___x_2090_; 
v___x_2087_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__18, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__18_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__18);
v___x_2088_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1));
v___x_2089_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__16));
v___x_2090_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___x_2089_, v___x_2088_, v___x_2087_);
return v___x_2090_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__20(void){
_start:
{
lean_object* v___x_2091_; lean_object* v___f_2092_; lean_object* v___f_2093_; lean_object* v___x_2094_; 
v___x_2091_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__19, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__19_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__19);
v___f_2092_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0));
v___f_2093_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__15));
v___x_2094_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___f_2093_, v___f_2092_, v___x_2091_);
return v___x_2094_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__21(void){
_start:
{
lean_object* v___x_2095_; lean_object* v___x_2096_; lean_object* v___x_2097_; lean_object* v___x_2098_; 
v___x_2095_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__20, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__20_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__20);
v___x_2096_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1));
v___x_2097_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__16));
v___x_2098_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___x_2097_, v___x_2096_, v___x_2095_);
return v___x_2098_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__22(void){
_start:
{
lean_object* v___x_2099_; lean_object* v___f_2100_; lean_object* v___f_2101_; lean_object* v___x_2102_; 
v___x_2099_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__21, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__21_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__21);
v___f_2100_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0));
v___f_2101_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__15));
v___x_2102_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___f_2101_, v___f_2100_, v___x_2099_);
return v___x_2102_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__23(void){
_start:
{
lean_object* v___x_2103_; lean_object* v___x_2104_; lean_object* v___f_2105_; 
v___x_2103_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1));
v___x_2104_ = l_Lean_Meta_instAddMessageContextMetaM;
v___f_2105_ = lean_alloc_closure((void*)(l_Lean_instAddMessageContextOfMonadLift___redArg___lam__0), 3, 2);
lean_closure_set(v___f_2105_, 0, v___x_2104_);
lean_closure_set(v___f_2105_, 1, v___x_2103_);
return v___f_2105_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__24(void){
_start:
{
lean_object* v___f_2106_; lean_object* v___f_2107_; lean_object* v___f_2108_; 
v___f_2106_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0));
v___f_2107_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__23, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__23_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__23);
v___f_2108_ = lean_alloc_closure((void*)(l_Lean_instAddMessageContextOfMonadLift___redArg___lam__0), 3, 2);
lean_closure_set(v___f_2108_, 0, v___f_2107_);
lean_closure_set(v___f_2108_, 1, v___f_2106_);
return v___f_2108_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__25(void){
_start:
{
lean_object* v___x_2109_; lean_object* v___f_2110_; lean_object* v___f_2111_; 
v___x_2109_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1));
v___f_2110_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__24, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__24_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__24);
v___f_2111_ = lean_alloc_closure((void*)(l_Lean_instAddMessageContextOfMonadLift___redArg___lam__0), 3, 2);
lean_closure_set(v___f_2111_, 0, v___f_2110_);
lean_closure_set(v___f_2111_, 1, v___x_2109_);
return v___f_2111_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__26(void){
_start:
{
lean_object* v___f_2112_; lean_object* v___f_2113_; lean_object* v___f_2114_; 
v___f_2112_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0));
v___f_2113_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__25, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__25_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__25);
v___f_2114_ = lean_alloc_closure((void*)(l_Lean_instAddMessageContextOfMonadLift___redArg___lam__0), 3, 2);
lean_closure_set(v___f_2114_, 0, v___f_2113_);
lean_closure_set(v___f_2114_, 1, v___f_2112_);
return v___f_2114_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__28(void){
_start:
{
lean_object* v___x_2116_; lean_object* v___x_2117_; 
v___x_2116_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__27));
v___x_2117_ = l_Lean_stringToMessageData(v___x_2116_);
return v___x_2117_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp(lean_object* v_hyp_2118_, lean_object* v_a_2119_, lean_object* v_a_2120_, lean_object* v_a_2121_, lean_object* v_a_2122_, lean_object* v_a_2123_, lean_object* v_a_2124_, lean_object* v_a_2125_, lean_object* v_a_2126_){
_start:
{
lean_object* v___y_2129_; lean_object* v___y_2149_; lean_object* v___y_2150_; lean_object* v___y_2151_; lean_object* v___y_2152_; lean_object* v___y_2153_; lean_object* v___y_2154_; lean_object* v___y_2155_; lean_object* v___x_2160_; lean_object* v_toApplicative_2161_; lean_object* v_toFunctor_2162_; lean_object* v_toSeq_2163_; lean_object* v_toSeqLeft_2164_; lean_object* v_toSeqRight_2165_; lean_object* v___f_2166_; lean_object* v___f_2167_; lean_object* v___f_2168_; lean_object* v___f_2169_; lean_object* v___x_2170_; lean_object* v___f_2171_; lean_object* v___f_2172_; lean_object* v___f_2173_; lean_object* v___x_2174_; lean_object* v___x_2175_; lean_object* v___x_2176_; lean_object* v_toApplicative_2177_; lean_object* v___x_2179_; uint8_t v_isShared_2180_; uint8_t v_isSharedCheck_2224_; 
v___x_2160_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1);
v_toApplicative_2161_ = lean_ctor_get(v___x_2160_, 0);
v_toFunctor_2162_ = lean_ctor_get(v_toApplicative_2161_, 0);
v_toSeq_2163_ = lean_ctor_get(v_toApplicative_2161_, 2);
v_toSeqLeft_2164_ = lean_ctor_get(v_toApplicative_2161_, 3);
v_toSeqRight_2165_ = lean_ctor_get(v_toApplicative_2161_, 4);
v___f_2166_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2));
v___f_2167_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3));
lean_inc_ref_n(v_toFunctor_2162_, 2);
v___f_2168_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_2168_, 0, v_toFunctor_2162_);
v___f_2169_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_2169_, 0, v_toFunctor_2162_);
v___x_2170_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2170_, 0, v___f_2168_);
lean_ctor_set(v___x_2170_, 1, v___f_2169_);
lean_inc(v_toSeqRight_2165_);
v___f_2171_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_2171_, 0, v_toSeqRight_2165_);
lean_inc(v_toSeqLeft_2164_);
v___f_2172_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_2172_, 0, v_toSeqLeft_2164_);
lean_inc(v_toSeq_2163_);
v___f_2173_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_2173_, 0, v_toSeq_2163_);
v___x_2174_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_2174_, 0, v___x_2170_);
lean_ctor_set(v___x_2174_, 1, v___f_2166_);
lean_ctor_set(v___x_2174_, 2, v___f_2173_);
lean_ctor_set(v___x_2174_, 3, v___f_2172_);
lean_ctor_set(v___x_2174_, 4, v___f_2171_);
v___x_2175_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2175_, 0, v___x_2174_);
lean_ctor_set(v___x_2175_, 1, v___f_2167_);
v___x_2176_ = l_StateRefT_x27_instMonad___redArg(v___x_2175_);
v_toApplicative_2177_ = lean_ctor_get(v___x_2176_, 0);
v_isSharedCheck_2224_ = !lean_is_exclusive(v___x_2176_);
if (v_isSharedCheck_2224_ == 0)
{
lean_object* v_unused_2225_; 
v_unused_2225_ = lean_ctor_get(v___x_2176_, 1);
lean_dec(v_unused_2225_);
v___x_2179_ = v___x_2176_;
v_isShared_2180_ = v_isSharedCheck_2224_;
goto v_resetjp_2178_;
}
else
{
lean_inc(v_toApplicative_2177_);
lean_dec(v___x_2176_);
v___x_2179_ = lean_box(0);
v_isShared_2180_ = v_isSharedCheck_2224_;
goto v_resetjp_2178_;
}
v___jp_2128_:
{
lean_object* v___x_2130_; lean_object* v_rewriteCache_2131_; lean_object* v_acNfCache_2132_; lean_object* v_typeAnalysis_2133_; lean_object* v_goal_2134_; lean_object* v_hypotheses_2135_; uint8_t v_didChange_2136_; lean_object* v___x_2138_; uint8_t v_isShared_2139_; uint8_t v_isSharedCheck_2147_; 
v___x_2130_ = lean_st_ref_take(v___y_2129_);
v_rewriteCache_2131_ = lean_ctor_get(v___x_2130_, 0);
v_acNfCache_2132_ = lean_ctor_get(v___x_2130_, 1);
v_typeAnalysis_2133_ = lean_ctor_get(v___x_2130_, 2);
v_goal_2134_ = lean_ctor_get(v___x_2130_, 3);
v_hypotheses_2135_ = lean_ctor_get(v___x_2130_, 4);
v_didChange_2136_ = lean_ctor_get_uint8(v___x_2130_, sizeof(void*)*5);
v_isSharedCheck_2147_ = !lean_is_exclusive(v___x_2130_);
if (v_isSharedCheck_2147_ == 0)
{
v___x_2138_ = v___x_2130_;
v_isShared_2139_ = v_isSharedCheck_2147_;
goto v_resetjp_2137_;
}
else
{
lean_inc(v_hypotheses_2135_);
lean_inc(v_goal_2134_);
lean_inc(v_typeAnalysis_2133_);
lean_inc(v_acNfCache_2132_);
lean_inc(v_rewriteCache_2131_);
lean_dec(v___x_2130_);
v___x_2138_ = lean_box(0);
v_isShared_2139_ = v_isSharedCheck_2147_;
goto v_resetjp_2137_;
}
v_resetjp_2137_:
{
lean_object* v___x_2140_; lean_object* v___x_2142_; 
v___x_2140_ = lean_array_push(v_hypotheses_2135_, v_hyp_2118_);
if (v_isShared_2139_ == 0)
{
lean_ctor_set(v___x_2138_, 4, v___x_2140_);
v___x_2142_ = v___x_2138_;
goto v_reusejp_2141_;
}
else
{
lean_object* v_reuseFailAlloc_2146_; 
v_reuseFailAlloc_2146_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_2146_, 0, v_rewriteCache_2131_);
lean_ctor_set(v_reuseFailAlloc_2146_, 1, v_acNfCache_2132_);
lean_ctor_set(v_reuseFailAlloc_2146_, 2, v_typeAnalysis_2133_);
lean_ctor_set(v_reuseFailAlloc_2146_, 3, v_goal_2134_);
lean_ctor_set(v_reuseFailAlloc_2146_, 4, v___x_2140_);
lean_ctor_set_uint8(v_reuseFailAlloc_2146_, sizeof(void*)*5, v_didChange_2136_);
v___x_2142_ = v_reuseFailAlloc_2146_;
goto v_reusejp_2141_;
}
v_reusejp_2141_:
{
lean_object* v___x_2143_; lean_object* v___x_2144_; lean_object* v___x_2145_; 
v___x_2143_ = lean_st_ref_set(v___y_2129_, v___x_2142_);
v___x_2144_ = lean_box(0);
v___x_2145_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2145_, 0, v___x_2144_);
return v___x_2145_;
}
}
}
v___jp_2148_:
{
lean_object* v___x_2156_; uint8_t v_debug_2157_; 
v___x_2156_ = lean_st_ref_get(v___y_2151_);
v_debug_2157_ = lean_ctor_get_uint8(v___x_2156_, sizeof(void*)*10);
lean_dec(v___x_2156_);
if (v_debug_2157_ == 0)
{
v___y_2129_ = v___y_2149_;
goto v___jp_2128_;
}
else
{
lean_object* v_type_2158_; lean_object* v___x_2159_; 
v_type_2158_ = lean_ctor_get(v_hyp_2118_, 1);
lean_inc_ref(v_type_2158_);
v___x_2159_ = l_Lean_Meta_Sym_Internal_Sym_assertShared(v_type_2158_, v___y_2150_, v___y_2151_, v___y_2152_, v___y_2153_, v___y_2154_, v___y_2155_);
if (lean_obj_tag(v___x_2159_) == 0)
{
lean_dec_ref_known(v___x_2159_, 1);
v___y_2129_ = v___y_2149_;
goto v___jp_2128_;
}
else
{
lean_dec_ref(v_hyp_2118_);
return v___x_2159_;
}
}
}
v_resetjp_2178_:
{
lean_object* v_toFunctor_2181_; lean_object* v_toSeq_2182_; lean_object* v_toSeqLeft_2183_; lean_object* v_toSeqRight_2184_; lean_object* v___x_2186_; uint8_t v_isShared_2187_; uint8_t v_isSharedCheck_2222_; 
v_toFunctor_2181_ = lean_ctor_get(v_toApplicative_2177_, 0);
v_toSeq_2182_ = lean_ctor_get(v_toApplicative_2177_, 2);
v_toSeqLeft_2183_ = lean_ctor_get(v_toApplicative_2177_, 3);
v_toSeqRight_2184_ = lean_ctor_get(v_toApplicative_2177_, 4);
v_isSharedCheck_2222_ = !lean_is_exclusive(v_toApplicative_2177_);
if (v_isSharedCheck_2222_ == 0)
{
lean_object* v_unused_2223_; 
v_unused_2223_ = lean_ctor_get(v_toApplicative_2177_, 1);
lean_dec(v_unused_2223_);
v___x_2186_ = v_toApplicative_2177_;
v_isShared_2187_ = v_isSharedCheck_2222_;
goto v_resetjp_2185_;
}
else
{
lean_inc(v_toSeqRight_2184_);
lean_inc(v_toSeqLeft_2183_);
lean_inc(v_toSeq_2182_);
lean_inc(v_toFunctor_2181_);
lean_dec(v_toApplicative_2177_);
v___x_2186_ = lean_box(0);
v_isShared_2187_ = v_isSharedCheck_2222_;
goto v_resetjp_2185_;
}
v_resetjp_2185_:
{
lean_object* v___f_2188_; lean_object* v___f_2189_; lean_object* v___f_2190_; lean_object* v___f_2191_; lean_object* v___x_2192_; lean_object* v___f_2193_; lean_object* v___f_2194_; lean_object* v___f_2195_; lean_object* v___x_2197_; 
v___f_2188_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4));
v___f_2189_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5));
lean_inc_ref(v_toFunctor_2181_);
v___f_2190_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_2190_, 0, v_toFunctor_2181_);
v___f_2191_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_2191_, 0, v_toFunctor_2181_);
v___x_2192_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2192_, 0, v___f_2190_);
lean_ctor_set(v___x_2192_, 1, v___f_2191_);
v___f_2193_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_2193_, 0, v_toSeqRight_2184_);
v___f_2194_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_2194_, 0, v_toSeqLeft_2183_);
v___f_2195_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_2195_, 0, v_toSeq_2182_);
if (v_isShared_2187_ == 0)
{
lean_ctor_set(v___x_2186_, 4, v___f_2193_);
lean_ctor_set(v___x_2186_, 3, v___f_2194_);
lean_ctor_set(v___x_2186_, 2, v___f_2195_);
lean_ctor_set(v___x_2186_, 1, v___f_2188_);
lean_ctor_set(v___x_2186_, 0, v___x_2192_);
v___x_2197_ = v___x_2186_;
goto v_reusejp_2196_;
}
else
{
lean_object* v_reuseFailAlloc_2221_; 
v_reuseFailAlloc_2221_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_2221_, 0, v___x_2192_);
lean_ctor_set(v_reuseFailAlloc_2221_, 1, v___f_2188_);
lean_ctor_set(v_reuseFailAlloc_2221_, 2, v___f_2195_);
lean_ctor_set(v_reuseFailAlloc_2221_, 3, v___f_2194_);
lean_ctor_set(v_reuseFailAlloc_2221_, 4, v___f_2193_);
v___x_2197_ = v_reuseFailAlloc_2221_;
goto v_reusejp_2196_;
}
v_reusejp_2196_:
{
lean_object* v___x_2199_; 
if (v_isShared_2180_ == 0)
{
lean_ctor_set(v___x_2179_, 1, v___f_2189_);
lean_ctor_set(v___x_2179_, 0, v___x_2197_);
v___x_2199_ = v___x_2179_;
goto v_reusejp_2198_;
}
else
{
lean_object* v_reuseFailAlloc_2220_; 
v_reuseFailAlloc_2220_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_2220_, 0, v___x_2197_);
lean_ctor_set(v_reuseFailAlloc_2220_, 1, v___f_2189_);
v___x_2199_ = v_reuseFailAlloc_2220_;
goto v_reusejp_2198_;
}
v_reusejp_2198_:
{
lean_object* v___x_2200_; lean_object* v___x_2201_; lean_object* v___x_2202_; lean_object* v___x_2203_; lean_object* v___x_2204_; lean_object* v_options_2205_; uint8_t v_hasTrace_2206_; 
v___x_2200_ = l_StateRefT_x27_instMonad___redArg(v___x_2199_);
v___x_2201_ = l_ReaderT_instMonad___redArg(v___x_2200_);
v___x_2202_ = l_StateRefT_x27_instMonad___redArg(v___x_2201_);
v___x_2203_ = l_ReaderT_instMonad___redArg(v___x_2202_);
v___x_2204_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7);
v_options_2205_ = lean_ctor_get(v_a_2125_, 2);
v_hasTrace_2206_ = lean_ctor_get_uint8(v_options_2205_, sizeof(void*)*1);
if (v_hasTrace_2206_ == 0)
{
lean_dec_ref(v___x_2203_);
v___y_2149_ = v_a_2120_;
v___y_2150_ = v_a_2121_;
v___y_2151_ = v_a_2122_;
v___y_2152_ = v_a_2123_;
v___y_2153_ = v_a_2124_;
v___y_2154_ = v_a_2125_;
v___y_2155_ = v_a_2126_;
goto v___jp_2148_;
}
else
{
lean_object* v_inheritedTraceOptions_2207_; lean_object* v_cls_2208_; lean_object* v___x_2209_; uint8_t v___x_2210_; 
v_inheritedTraceOptions_2207_ = lean_ctor_get(v_a_2125_, 13);
v_cls_2208_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
v___x_2209_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14);
v___x_2210_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_2207_, v_options_2205_, v___x_2209_);
if (v___x_2210_ == 0)
{
lean_dec_ref(v___x_2203_);
v___y_2149_ = v_a_2120_;
v___y_2150_ = v_a_2121_;
v___y_2151_ = v_a_2122_;
v___y_2152_ = v_a_2123_;
v___y_2153_ = v_a_2124_;
v___y_2154_ = v_a_2125_;
v___y_2155_ = v_a_2126_;
goto v___jp_2148_;
}
else
{
lean_object* v___x_2211_; lean_object* v_toMonadRef_2212_; lean_object* v_type_2213_; lean_object* v___f_2214_; lean_object* v___x_2215_; lean_object* v___x_2216_; lean_object* v___x_2217_; lean_object* v___x_5776__overap_2218_; lean_object* v___x_2219_; 
v___x_2211_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__22, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__22_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__22);
v_toMonadRef_2212_ = lean_ctor_get(v___x_2211_, 0);
v_type_2213_ = lean_ctor_get(v_hyp_2118_, 1);
v___f_2214_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__26, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__26_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__26);
v___x_2215_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__28, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__28_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__28);
lean_inc_ref(v_type_2213_);
v___x_2216_ = l_Lean_MessageData_ofExpr(v_type_2213_);
v___x_2217_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2217_, 0, v___x_2215_);
lean_ctor_set(v___x_2217_, 1, v___x_2216_);
lean_inc_ref(v_toMonadRef_2212_);
v___x_5776__overap_2218_ = l_Lean_addTrace___redArg(v___x_2203_, v___x_2204_, v_toMonadRef_2212_, v___f_2214_, v_cls_2208_, v___x_2217_);
lean_inc(v_a_2126_);
lean_inc_ref(v_a_2125_);
lean_inc(v_a_2124_);
lean_inc_ref(v_a_2123_);
lean_inc(v_a_2122_);
lean_inc_ref(v_a_2121_);
lean_inc(v_a_2120_);
lean_inc_ref(v_a_2119_);
v___x_2219_ = lean_apply_9(v___x_5776__overap_2218_, v_a_2119_, v_a_2120_, v_a_2121_, v_a_2122_, v_a_2123_, v_a_2124_, v_a_2125_, v_a_2126_, lean_box(0));
if (lean_obj_tag(v___x_2219_) == 0)
{
lean_dec_ref_known(v___x_2219_, 1);
v___y_2149_ = v_a_2120_;
v___y_2150_ = v_a_2121_;
v___y_2151_ = v_a_2122_;
v___y_2152_ = v_a_2123_;
v___y_2153_ = v_a_2124_;
v___y_2154_ = v_a_2125_;
v___y_2155_ = v_a_2126_;
goto v___jp_2148_;
}
else
{
lean_dec_ref(v_hyp_2118_);
return v___x_2219_;
}
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___boxed(lean_object* v_hyp_2226_, lean_object* v_a_2227_, lean_object* v_a_2228_, lean_object* v_a_2229_, lean_object* v_a_2230_, lean_object* v_a_2231_, lean_object* v_a_2232_, lean_object* v_a_2233_, lean_object* v_a_2234_, lean_object* v_a_2235_){
_start:
{
lean_object* v_res_2236_; 
v_res_2236_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp(v_hyp_2226_, v_a_2227_, v_a_2228_, v_a_2229_, v_a_2230_, v_a_2231_, v_a_2232_, v_a_2233_, v_a_2234_);
lean_dec(v_a_2234_);
lean_dec_ref(v_a_2233_);
lean_dec(v_a_2232_);
lean_dec_ref(v_a_2231_);
lean_dec(v_a_2230_);
lean_dec_ref(v_a_2229_);
lean_dec(v_a_2228_);
lean_dec_ref(v_a_2227_);
return v_res_2236_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps___lam__0(lean_object* v___x_2237_, lean_object* v___f_2238_, lean_object* v___x_2239_, lean_object* v___f_2240_, lean_object* v___x_2241_, lean_object* v___f_2242_, lean_object* v___x_2243_, lean_object* v___x_2244_, lean_object* v_x_2245_, lean_object* v___y_2246_, lean_object* v___y_2247_, lean_object* v___y_2248_, lean_object* v___y_2249_, lean_object* v___y_2250_, lean_object* v___y_2251_, lean_object* v___y_2252_, lean_object* v___y_2253_, lean_object* v___y_2254_){
_start:
{
lean_object* v___y_2257_; lean_object* v___y_2258_; lean_object* v___y_2259_; lean_object* v___y_2260_; lean_object* v___y_2261_; lean_object* v___y_2262_; lean_object* v_options_2269_; uint8_t v_hasTrace_2270_; 
v_options_2269_ = lean_ctor_get(v___y_2253_, 2);
v_hasTrace_2270_ = lean_ctor_get_uint8(v_options_2269_, sizeof(void*)*1);
if (v_hasTrace_2270_ == 0)
{
lean_dec_ref(v___x_2244_);
lean_dec_ref(v___x_2243_);
lean_dec(v___f_2242_);
lean_dec(v___x_2241_);
lean_dec(v___f_2240_);
lean_dec(v___x_2239_);
lean_dec(v___f_2238_);
lean_dec(v___x_2237_);
v___y_2257_ = v___y_2249_;
v___y_2258_ = v___y_2250_;
v___y_2259_ = v___y_2251_;
v___y_2260_ = v___y_2252_;
v___y_2261_ = v___y_2253_;
v___y_2262_ = v___y_2254_;
goto v___jp_2256_;
}
else
{
lean_object* v_inheritedTraceOptions_2271_; lean_object* v_cls_2272_; lean_object* v___x_2273_; uint8_t v___x_2274_; 
v_inheritedTraceOptions_2271_ = lean_ctor_get(v___y_2253_, 13);
v_cls_2272_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
v___x_2273_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14);
v___x_2274_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_2271_, v_options_2269_, v___x_2273_);
if (v___x_2274_ == 0)
{
lean_dec_ref(v___x_2244_);
lean_dec_ref(v___x_2243_);
lean_dec(v___f_2242_);
lean_dec(v___x_2241_);
lean_dec(v___f_2240_);
lean_dec(v___x_2239_);
lean_dec(v___f_2238_);
lean_dec(v___x_2237_);
v___y_2257_ = v___y_2249_;
v___y_2258_ = v___y_2250_;
v___y_2259_ = v___y_2251_;
v___y_2260_ = v___y_2252_;
v___y_2261_ = v___y_2253_;
v___y_2262_ = v___y_2254_;
goto v___jp_2256_;
}
else
{
lean_object* v___f_2275_; lean_object* v___x_2276_; lean_object* v___x_2277_; lean_object* v___x_2278_; lean_object* v___x_2279_; lean_object* v___x_2280_; lean_object* v___x_2281_; lean_object* v___x_2282_; lean_object* v___x_2283_; lean_object* v_toMonadRef_2284_; lean_object* v_type_2285_; lean_object* v___x_2286_; lean_object* v___f_2287_; lean_object* v___f_2288_; lean_object* v___f_2289_; lean_object* v___f_2290_; lean_object* v___x_2291_; lean_object* v___x_2292_; lean_object* v___x_2293_; lean_object* v___x_6007__overap_2294_; lean_object* v___x_2295_; 
v___f_2275_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__15));
v___x_2276_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__16));
v___x_2277_ = l_Lean_Core_instMonadQuotationCoreM;
v___x_2278_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___x_2276_, v___x_2237_, v___x_2277_);
v___x_2279_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___f_2275_, v___f_2238_, v___x_2278_);
lean_inc(v___x_2239_);
v___x_2280_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___x_2276_, v___x_2239_, v___x_2279_);
lean_inc(v___f_2240_);
v___x_2281_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___f_2275_, v___f_2240_, v___x_2280_);
lean_inc(v___x_2241_);
v___x_2282_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___x_2276_, v___x_2241_, v___x_2281_);
lean_inc(v___f_2242_);
v___x_2283_ = l_Lean_instMonadQuotationOfMonadFunctorOfMonadLift___redArg(v___f_2275_, v___f_2242_, v___x_2282_);
v_toMonadRef_2284_ = lean_ctor_get(v___x_2283_, 0);
lean_inc_ref(v_toMonadRef_2284_);
lean_dec_ref(v___x_2283_);
v_type_2285_ = lean_ctor_get(v___y_2246_, 1);
v___x_2286_ = l_Lean_Meta_instAddMessageContextMetaM;
v___f_2287_ = lean_alloc_closure((void*)(l_Lean_instAddMessageContextOfMonadLift___redArg___lam__0), 3, 2);
lean_closure_set(v___f_2287_, 0, v___x_2286_);
lean_closure_set(v___f_2287_, 1, v___x_2239_);
v___f_2288_ = lean_alloc_closure((void*)(l_Lean_instAddMessageContextOfMonadLift___redArg___lam__0), 3, 2);
lean_closure_set(v___f_2288_, 0, v___f_2287_);
lean_closure_set(v___f_2288_, 1, v___f_2240_);
v___f_2289_ = lean_alloc_closure((void*)(l_Lean_instAddMessageContextOfMonadLift___redArg___lam__0), 3, 2);
lean_closure_set(v___f_2289_, 0, v___f_2288_);
lean_closure_set(v___f_2289_, 1, v___x_2241_);
v___f_2290_ = lean_alloc_closure((void*)(l_Lean_instAddMessageContextOfMonadLift___redArg___lam__0), 3, 2);
lean_closure_set(v___f_2290_, 0, v___f_2289_);
lean_closure_set(v___f_2290_, 1, v___f_2242_);
v___x_2291_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__28, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__28_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__28);
lean_inc_ref(v_type_2285_);
v___x_2292_ = l_Lean_MessageData_ofExpr(v_type_2285_);
v___x_2293_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2293_, 0, v___x_2291_);
lean_ctor_set(v___x_2293_, 1, v___x_2292_);
v___x_6007__overap_2294_ = l_Lean_addTrace___redArg(v___x_2243_, v___x_2244_, v_toMonadRef_2284_, v___f_2290_, v_cls_2272_, v___x_2293_);
lean_inc(v___y_2254_);
lean_inc_ref(v___y_2253_);
lean_inc(v___y_2252_);
lean_inc_ref(v___y_2251_);
lean_inc(v___y_2250_);
lean_inc_ref(v___y_2249_);
lean_inc(v___y_2248_);
lean_inc_ref(v___y_2247_);
v___x_2295_ = lean_apply_9(v___x_6007__overap_2294_, v___y_2247_, v___y_2248_, v___y_2249_, v___y_2250_, v___y_2251_, v___y_2252_, v___y_2253_, v___y_2254_, lean_box(0));
if (lean_obj_tag(v___x_2295_) == 0)
{
lean_dec_ref_known(v___x_2295_, 1);
v___y_2257_ = v___y_2249_;
v___y_2258_ = v___y_2250_;
v___y_2259_ = v___y_2251_;
v___y_2260_ = v___y_2252_;
v___y_2261_ = v___y_2253_;
v___y_2262_ = v___y_2254_;
goto v___jp_2256_;
}
else
{
lean_dec_ref(v___y_2246_);
return v___x_2295_;
}
}
}
v___jp_2256_:
{
lean_object* v___x_2263_; uint8_t v_debug_2264_; 
v___x_2263_ = lean_st_ref_get(v___y_2258_);
v_debug_2264_ = lean_ctor_get_uint8(v___x_2263_, sizeof(void*)*10);
lean_dec(v___x_2263_);
if (v_debug_2264_ == 0)
{
lean_object* v___x_2265_; lean_object* v___x_2266_; 
lean_dec_ref(v___y_2246_);
v___x_2265_ = lean_box(0);
v___x_2266_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2266_, 0, v___x_2265_);
return v___x_2266_;
}
else
{
lean_object* v_type_2267_; lean_object* v___x_2268_; 
v_type_2267_ = lean_ctor_get(v___y_2246_, 1);
lean_inc_ref(v_type_2267_);
lean_dec_ref(v___y_2246_);
v___x_2268_ = l_Lean_Meta_Sym_Internal_Sym_assertShared(v_type_2267_, v___y_2257_, v___y_2258_, v___y_2259_, v___y_2260_, v___y_2261_, v___y_2262_);
return v___x_2268_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps___lam__0___boxed(lean_object** _args){
lean_object* v___x_2296_ = _args[0];
lean_object* v___f_2297_ = _args[1];
lean_object* v___x_2298_ = _args[2];
lean_object* v___f_2299_ = _args[3];
lean_object* v___x_2300_ = _args[4];
lean_object* v___f_2301_ = _args[5];
lean_object* v___x_2302_ = _args[6];
lean_object* v___x_2303_ = _args[7];
lean_object* v_x_2304_ = _args[8];
lean_object* v___y_2305_ = _args[9];
lean_object* v___y_2306_ = _args[10];
lean_object* v___y_2307_ = _args[11];
lean_object* v___y_2308_ = _args[12];
lean_object* v___y_2309_ = _args[13];
lean_object* v___y_2310_ = _args[14];
lean_object* v___y_2311_ = _args[15];
lean_object* v___y_2312_ = _args[16];
lean_object* v___y_2313_ = _args[17];
lean_object* v___y_2314_ = _args[18];
_start:
{
lean_object* v_res_2315_; 
v_res_2315_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps___lam__0(v___x_2296_, v___f_2297_, v___x_2298_, v___f_2299_, v___x_2300_, v___f_2301_, v___x_2302_, v___x_2303_, v_x_2304_, v___y_2305_, v___y_2306_, v___y_2307_, v___y_2308_, v___y_2309_, v___y_2310_, v___y_2311_, v___y_2312_, v___y_2313_);
lean_dec(v___y_2313_);
lean_dec_ref(v___y_2312_);
lean_dec(v___y_2311_);
lean_dec_ref(v___y_2310_);
lean_dec(v___y_2309_);
lean_dec_ref(v___y_2308_);
lean_dec(v___y_2307_);
lean_dec_ref(v___y_2306_);
return v_res_2315_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps(lean_object* v_hyps_2316_, lean_object* v_a_2317_, lean_object* v_a_2318_, lean_object* v_a_2319_, lean_object* v_a_2320_, lean_object* v_a_2321_, lean_object* v_a_2322_, lean_object* v_a_2323_, lean_object* v_a_2324_){
_start:
{
lean_object* v___y_2346_; lean_object* v___x_2347_; lean_object* v_toApplicative_2348_; lean_object* v_toFunctor_2349_; lean_object* v_toSeq_2350_; lean_object* v_toSeqLeft_2351_; lean_object* v_toSeqRight_2352_; lean_object* v___f_2353_; lean_object* v___f_2354_; lean_object* v___f_2355_; lean_object* v___f_2356_; lean_object* v___x_2357_; lean_object* v___f_2358_; lean_object* v___f_2359_; lean_object* v___f_2360_; lean_object* v___x_2361_; lean_object* v___x_2362_; lean_object* v___x_2363_; lean_object* v_toApplicative_2364_; lean_object* v___x_2366_; uint8_t v_isShared_2367_; uint8_t v_isSharedCheck_2412_; 
v___x_2347_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1);
v_toApplicative_2348_ = lean_ctor_get(v___x_2347_, 0);
v_toFunctor_2349_ = lean_ctor_get(v_toApplicative_2348_, 0);
v_toSeq_2350_ = lean_ctor_get(v_toApplicative_2348_, 2);
v_toSeqLeft_2351_ = lean_ctor_get(v_toApplicative_2348_, 3);
v_toSeqRight_2352_ = lean_ctor_get(v_toApplicative_2348_, 4);
v___f_2353_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2));
v___f_2354_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3));
lean_inc_ref_n(v_toFunctor_2349_, 2);
v___f_2355_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_2355_, 0, v_toFunctor_2349_);
v___f_2356_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_2356_, 0, v_toFunctor_2349_);
v___x_2357_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2357_, 0, v___f_2355_);
lean_ctor_set(v___x_2357_, 1, v___f_2356_);
lean_inc(v_toSeqRight_2352_);
v___f_2358_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_2358_, 0, v_toSeqRight_2352_);
lean_inc(v_toSeqLeft_2351_);
v___f_2359_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_2359_, 0, v_toSeqLeft_2351_);
lean_inc(v_toSeq_2350_);
v___f_2360_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_2360_, 0, v_toSeq_2350_);
v___x_2361_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_2361_, 0, v___x_2357_);
lean_ctor_set(v___x_2361_, 1, v___f_2353_);
lean_ctor_set(v___x_2361_, 2, v___f_2360_);
lean_ctor_set(v___x_2361_, 3, v___f_2359_);
lean_ctor_set(v___x_2361_, 4, v___f_2358_);
v___x_2362_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2362_, 0, v___x_2361_);
lean_ctor_set(v___x_2362_, 1, v___f_2354_);
v___x_2363_ = l_StateRefT_x27_instMonad___redArg(v___x_2362_);
v_toApplicative_2364_ = lean_ctor_get(v___x_2363_, 0);
v_isSharedCheck_2412_ = !lean_is_exclusive(v___x_2363_);
if (v_isSharedCheck_2412_ == 0)
{
lean_object* v_unused_2413_; 
v_unused_2413_ = lean_ctor_get(v___x_2363_, 1);
lean_dec(v_unused_2413_);
v___x_2366_ = v___x_2363_;
v_isShared_2367_ = v_isSharedCheck_2412_;
goto v_resetjp_2365_;
}
else
{
lean_inc(v_toApplicative_2364_);
lean_dec(v___x_2363_);
v___x_2366_ = lean_box(0);
v_isShared_2367_ = v_isSharedCheck_2412_;
goto v_resetjp_2365_;
}
v___jp_2326_:
{
lean_object* v___x_2327_; lean_object* v_rewriteCache_2328_; lean_object* v_acNfCache_2329_; lean_object* v_typeAnalysis_2330_; lean_object* v_goal_2331_; lean_object* v_hypotheses_2332_; uint8_t v_didChange_2333_; lean_object* v___x_2335_; uint8_t v_isShared_2336_; uint8_t v_isSharedCheck_2344_; 
v___x_2327_ = lean_st_ref_take(v_a_2318_);
v_rewriteCache_2328_ = lean_ctor_get(v___x_2327_, 0);
v_acNfCache_2329_ = lean_ctor_get(v___x_2327_, 1);
v_typeAnalysis_2330_ = lean_ctor_get(v___x_2327_, 2);
v_goal_2331_ = lean_ctor_get(v___x_2327_, 3);
v_hypotheses_2332_ = lean_ctor_get(v___x_2327_, 4);
v_didChange_2333_ = lean_ctor_get_uint8(v___x_2327_, sizeof(void*)*5);
v_isSharedCheck_2344_ = !lean_is_exclusive(v___x_2327_);
if (v_isSharedCheck_2344_ == 0)
{
v___x_2335_ = v___x_2327_;
v_isShared_2336_ = v_isSharedCheck_2344_;
goto v_resetjp_2334_;
}
else
{
lean_inc(v_hypotheses_2332_);
lean_inc(v_goal_2331_);
lean_inc(v_typeAnalysis_2330_);
lean_inc(v_acNfCache_2329_);
lean_inc(v_rewriteCache_2328_);
lean_dec(v___x_2327_);
v___x_2335_ = lean_box(0);
v_isShared_2336_ = v_isSharedCheck_2344_;
goto v_resetjp_2334_;
}
v_resetjp_2334_:
{
lean_object* v___x_2337_; lean_object* v___x_2339_; 
v___x_2337_ = l_Array_append___redArg(v_hypotheses_2332_, v_hyps_2316_);
lean_dec_ref(v_hyps_2316_);
if (v_isShared_2336_ == 0)
{
lean_ctor_set(v___x_2335_, 4, v___x_2337_);
v___x_2339_ = v___x_2335_;
goto v_reusejp_2338_;
}
else
{
lean_object* v_reuseFailAlloc_2343_; 
v_reuseFailAlloc_2343_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_2343_, 0, v_rewriteCache_2328_);
lean_ctor_set(v_reuseFailAlloc_2343_, 1, v_acNfCache_2329_);
lean_ctor_set(v_reuseFailAlloc_2343_, 2, v_typeAnalysis_2330_);
lean_ctor_set(v_reuseFailAlloc_2343_, 3, v_goal_2331_);
lean_ctor_set(v_reuseFailAlloc_2343_, 4, v___x_2337_);
lean_ctor_set_uint8(v_reuseFailAlloc_2343_, sizeof(void*)*5, v_didChange_2333_);
v___x_2339_ = v_reuseFailAlloc_2343_;
goto v_reusejp_2338_;
}
v_reusejp_2338_:
{
lean_object* v___x_2340_; lean_object* v___x_2341_; lean_object* v___x_2342_; 
v___x_2340_ = lean_st_ref_set(v_a_2318_, v___x_2339_);
v___x_2341_ = lean_box(0);
v___x_2342_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2342_, 0, v___x_2341_);
return v___x_2342_;
}
}
}
v___jp_2345_:
{
if (lean_obj_tag(v___y_2346_) == 0)
{
lean_dec_ref_known(v___y_2346_, 1);
goto v___jp_2326_;
}
else
{
lean_dec_ref(v_hyps_2316_);
return v___y_2346_;
}
}
v_resetjp_2365_:
{
lean_object* v_toFunctor_2368_; lean_object* v_toSeq_2369_; lean_object* v_toSeqLeft_2370_; lean_object* v_toSeqRight_2371_; lean_object* v___x_2373_; uint8_t v_isShared_2374_; uint8_t v_isSharedCheck_2410_; 
v_toFunctor_2368_ = lean_ctor_get(v_toApplicative_2364_, 0);
v_toSeq_2369_ = lean_ctor_get(v_toApplicative_2364_, 2);
v_toSeqLeft_2370_ = lean_ctor_get(v_toApplicative_2364_, 3);
v_toSeqRight_2371_ = lean_ctor_get(v_toApplicative_2364_, 4);
v_isSharedCheck_2410_ = !lean_is_exclusive(v_toApplicative_2364_);
if (v_isSharedCheck_2410_ == 0)
{
lean_object* v_unused_2411_; 
v_unused_2411_ = lean_ctor_get(v_toApplicative_2364_, 1);
lean_dec(v_unused_2411_);
v___x_2373_ = v_toApplicative_2364_;
v_isShared_2374_ = v_isSharedCheck_2410_;
goto v_resetjp_2372_;
}
else
{
lean_inc(v_toSeqRight_2371_);
lean_inc(v_toSeqLeft_2370_);
lean_inc(v_toSeq_2369_);
lean_inc(v_toFunctor_2368_);
lean_dec(v_toApplicative_2364_);
v___x_2373_ = lean_box(0);
v_isShared_2374_ = v_isSharedCheck_2410_;
goto v_resetjp_2372_;
}
v_resetjp_2372_:
{
lean_object* v___f_2375_; lean_object* v___f_2376_; lean_object* v___f_2377_; lean_object* v___f_2378_; lean_object* v___x_2379_; lean_object* v___f_2380_; lean_object* v___f_2381_; lean_object* v___f_2382_; lean_object* v___x_2384_; 
v___f_2375_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4));
v___f_2376_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5));
lean_inc_ref(v_toFunctor_2368_);
v___f_2377_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_2377_, 0, v_toFunctor_2368_);
v___f_2378_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_2378_, 0, v_toFunctor_2368_);
v___x_2379_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2379_, 0, v___f_2377_);
lean_ctor_set(v___x_2379_, 1, v___f_2378_);
v___f_2380_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_2380_, 0, v_toSeqRight_2371_);
v___f_2381_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_2381_, 0, v_toSeqLeft_2370_);
v___f_2382_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_2382_, 0, v_toSeq_2369_);
if (v_isShared_2374_ == 0)
{
lean_ctor_set(v___x_2373_, 4, v___f_2380_);
lean_ctor_set(v___x_2373_, 3, v___f_2381_);
lean_ctor_set(v___x_2373_, 2, v___f_2382_);
lean_ctor_set(v___x_2373_, 1, v___f_2375_);
lean_ctor_set(v___x_2373_, 0, v___x_2379_);
v___x_2384_ = v___x_2373_;
goto v_reusejp_2383_;
}
else
{
lean_object* v_reuseFailAlloc_2409_; 
v_reuseFailAlloc_2409_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_2409_, 0, v___x_2379_);
lean_ctor_set(v_reuseFailAlloc_2409_, 1, v___f_2375_);
lean_ctor_set(v_reuseFailAlloc_2409_, 2, v___f_2382_);
lean_ctor_set(v_reuseFailAlloc_2409_, 3, v___f_2381_);
lean_ctor_set(v_reuseFailAlloc_2409_, 4, v___f_2380_);
v___x_2384_ = v_reuseFailAlloc_2409_;
goto v_reusejp_2383_;
}
v_reusejp_2383_:
{
lean_object* v___x_2386_; 
if (v_isShared_2367_ == 0)
{
lean_ctor_set(v___x_2366_, 1, v___f_2376_);
lean_ctor_set(v___x_2366_, 0, v___x_2384_);
v___x_2386_ = v___x_2366_;
goto v_reusejp_2385_;
}
else
{
lean_object* v_reuseFailAlloc_2408_; 
v_reuseFailAlloc_2408_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_2408_, 0, v___x_2384_);
lean_ctor_set(v_reuseFailAlloc_2408_, 1, v___f_2376_);
v___x_2386_ = v_reuseFailAlloc_2408_;
goto v_reusejp_2385_;
}
v_reusejp_2385_:
{
lean_object* v___x_2387_; lean_object* v___x_2388_; lean_object* v___x_2389_; lean_object* v___x_2390_; lean_object* v___f_2391_; lean_object* v___x_2392_; lean_object* v___x_2393_; lean_object* v___x_2394_; lean_object* v___x_2395_; uint8_t v___x_2396_; 
v___x_2387_ = l_StateRefT_x27_instMonad___redArg(v___x_2386_);
v___x_2388_ = l_ReaderT_instMonad___redArg(v___x_2387_);
v___x_2389_ = l_StateRefT_x27_instMonad___redArg(v___x_2388_);
v___x_2390_ = l_ReaderT_instMonad___redArg(v___x_2389_);
v___f_2391_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__0));
v___x_2392_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__1));
v___x_2393_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7);
v___x_2394_ = lean_unsigned_to_nat(0u);
v___x_2395_ = lean_array_get_size(v_hyps_2316_);
v___x_2396_ = lean_nat_dec_lt(v___x_2394_, v___x_2395_);
if (v___x_2396_ == 0)
{
lean_dec_ref(v___x_2390_);
goto v___jp_2326_;
}
else
{
lean_object* v___f_2397_; lean_object* v___x_2398_; uint8_t v___x_2399_; 
lean_inc_ref(v___x_2390_);
v___f_2397_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps___lam__0___boxed), 19, 8);
lean_closure_set(v___f_2397_, 0, v___x_2392_);
lean_closure_set(v___f_2397_, 1, v___f_2391_);
lean_closure_set(v___f_2397_, 2, v___x_2392_);
lean_closure_set(v___f_2397_, 3, v___f_2391_);
lean_closure_set(v___f_2397_, 4, v___x_2392_);
lean_closure_set(v___f_2397_, 5, v___f_2391_);
lean_closure_set(v___f_2397_, 6, v___x_2390_);
lean_closure_set(v___f_2397_, 7, v___x_2393_);
v___x_2398_ = lean_box(0);
v___x_2399_ = lean_nat_dec_le(v___x_2395_, v___x_2395_);
if (v___x_2399_ == 0)
{
if (v___x_2396_ == 0)
{
lean_dec_ref(v___f_2397_);
lean_dec_ref(v___x_2390_);
goto v___jp_2326_;
}
else
{
size_t v___x_2400_; size_t v___x_2401_; lean_object* v___x_5635__overap_2402_; lean_object* v___x_2403_; 
v___x_2400_ = ((size_t)0ULL);
v___x_2401_ = lean_usize_of_nat(v___x_2395_);
lean_inc_ref(v_hyps_2316_);
v___x_5635__overap_2402_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v___x_2390_, v___f_2397_, v_hyps_2316_, v___x_2400_, v___x_2401_, v___x_2398_);
lean_inc(v_a_2324_);
lean_inc_ref(v_a_2323_);
lean_inc(v_a_2322_);
lean_inc_ref(v_a_2321_);
lean_inc(v_a_2320_);
lean_inc_ref(v_a_2319_);
lean_inc(v_a_2318_);
lean_inc_ref(v_a_2317_);
v___x_2403_ = lean_apply_9(v___x_5635__overap_2402_, v_a_2317_, v_a_2318_, v_a_2319_, v_a_2320_, v_a_2321_, v_a_2322_, v_a_2323_, v_a_2324_, lean_box(0));
v___y_2346_ = v___x_2403_;
goto v___jp_2345_;
}
}
else
{
size_t v___x_2404_; size_t v___x_2405_; lean_object* v___x_5639__overap_2406_; lean_object* v___x_2407_; 
v___x_2404_ = ((size_t)0ULL);
v___x_2405_ = lean_usize_of_nat(v___x_2395_);
lean_inc_ref(v_hyps_2316_);
v___x_5639__overap_2406_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v___x_2390_, v___f_2397_, v_hyps_2316_, v___x_2404_, v___x_2405_, v___x_2398_);
lean_inc(v_a_2324_);
lean_inc_ref(v_a_2323_);
lean_inc(v_a_2322_);
lean_inc_ref(v_a_2321_);
lean_inc(v_a_2320_);
lean_inc_ref(v_a_2319_);
lean_inc(v_a_2318_);
lean_inc_ref(v_a_2317_);
v___x_2407_ = lean_apply_9(v___x_5639__overap_2406_, v_a_2317_, v_a_2318_, v_a_2319_, v_a_2320_, v_a_2321_, v_a_2322_, v_a_2323_, v_a_2324_, lean_box(0));
v___y_2346_ = v___x_2407_;
goto v___jp_2345_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps___boxed(lean_object* v_hyps_2414_, lean_object* v_a_2415_, lean_object* v_a_2416_, lean_object* v_a_2417_, lean_object* v_a_2418_, lean_object* v_a_2419_, lean_object* v_a_2420_, lean_object* v_a_2421_, lean_object* v_a_2422_, lean_object* v_a_2423_){
_start:
{
lean_object* v_res_2424_; 
v_res_2424_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_addHyps(v_hyps_2414_, v_a_2415_, v_a_2416_, v_a_2417_, v_a_2418_, v_a_2419_, v_a_2420_, v_a_2421_, v_a_2422_);
lean_dec(v_a_2422_);
lean_dec_ref(v_a_2421_);
lean_dec(v_a_2420_);
lean_dec_ref(v_a_2419_);
lean_dec(v_a_2418_);
lean_dec_ref(v_a_2417_);
lean_dec(v_a_2416_);
lean_dec_ref(v_a_2415_);
return v_res_2424_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___redArg(lean_object* v_a_2425_){
_start:
{
lean_object* v___x_2427_; lean_object* v_hypotheses_2428_; lean_object* v___x_2429_; 
v___x_2427_ = lean_st_ref_get(v_a_2425_);
v_hypotheses_2428_ = lean_ctor_get(v___x_2427_, 4);
lean_inc_ref(v_hypotheses_2428_);
lean_dec(v___x_2427_);
v___x_2429_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2429_, 0, v_hypotheses_2428_);
return v___x_2429_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___redArg___boxed(lean_object* v_a_2430_, lean_object* v_a_2431_){
_start:
{
lean_object* v_res_2432_; 
v_res_2432_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___redArg(v_a_2430_);
lean_dec(v_a_2430_);
return v_res_2432_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps(lean_object* v_a_2433_, lean_object* v_a_2434_, lean_object* v_a_2435_, lean_object* v_a_2436_, lean_object* v_a_2437_, lean_object* v_a_2438_, lean_object* v_a_2439_, lean_object* v_a_2440_){
_start:
{
lean_object* v___x_2442_; lean_object* v_hypotheses_2443_; lean_object* v___x_2444_; 
v___x_2442_ = lean_st_ref_get(v_a_2434_);
v_hypotheses_2443_ = lean_ctor_get(v___x_2442_, 4);
lean_inc_ref(v_hypotheses_2443_);
lean_dec(v___x_2442_);
v___x_2444_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2444_, 0, v_hypotheses_2443_);
return v___x_2444_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed(lean_object* v_a_2445_, lean_object* v_a_2446_, lean_object* v_a_2447_, lean_object* v_a_2448_, lean_object* v_a_2449_, lean_object* v_a_2450_, lean_object* v_a_2451_, lean_object* v_a_2452_, lean_object* v_a_2453_){
_start:
{
lean_object* v_res_2454_; 
v_res_2454_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps(v_a_2445_, v_a_2446_, v_a_2447_, v_a_2448_, v_a_2449_, v_a_2450_, v_a_2451_, v_a_2452_);
lean_dec(v_a_2452_);
lean_dec_ref(v_a_2451_);
lean_dec(v_a_2450_);
lean_dec_ref(v_a_2449_);
lean_dec(v_a_2448_);
lean_dec_ref(v_a_2447_);
lean_dec(v_a_2446_);
lean_dec_ref(v_a_2445_);
return v_res_2454_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__0(lean_object* v_hyps_2455_, lean_object* v___y_2456_, lean_object* v___y_2457_, lean_object* v___y_2458_, lean_object* v___y_2459_, lean_object* v___y_2460_, lean_object* v___y_2461_, lean_object* v___y_2462_, lean_object* v___y_2463_){
_start:
{
lean_object* v___x_2465_; lean_object* v_rewriteCache_2466_; lean_object* v_acNfCache_2467_; lean_object* v_typeAnalysis_2468_; lean_object* v_goal_2469_; uint8_t v_didChange_2470_; lean_object* v___x_2472_; uint8_t v_isShared_2473_; uint8_t v_isSharedCheck_2480_; 
v___x_2465_ = lean_st_ref_take(v___y_2457_);
v_rewriteCache_2466_ = lean_ctor_get(v___x_2465_, 0);
v_acNfCache_2467_ = lean_ctor_get(v___x_2465_, 1);
v_typeAnalysis_2468_ = lean_ctor_get(v___x_2465_, 2);
v_goal_2469_ = lean_ctor_get(v___x_2465_, 3);
v_didChange_2470_ = lean_ctor_get_uint8(v___x_2465_, sizeof(void*)*5);
v_isSharedCheck_2480_ = !lean_is_exclusive(v___x_2465_);
if (v_isSharedCheck_2480_ == 0)
{
lean_object* v_unused_2481_; 
v_unused_2481_ = lean_ctor_get(v___x_2465_, 4);
lean_dec(v_unused_2481_);
v___x_2472_ = v___x_2465_;
v_isShared_2473_ = v_isSharedCheck_2480_;
goto v_resetjp_2471_;
}
else
{
lean_inc(v_goal_2469_);
lean_inc(v_typeAnalysis_2468_);
lean_inc(v_acNfCache_2467_);
lean_inc(v_rewriteCache_2466_);
lean_dec(v___x_2465_);
v___x_2472_ = lean_box(0);
v_isShared_2473_ = v_isSharedCheck_2480_;
goto v_resetjp_2471_;
}
v_resetjp_2471_:
{
lean_object* v___x_2475_; 
if (v_isShared_2473_ == 0)
{
lean_ctor_set(v___x_2472_, 4, v_hyps_2455_);
v___x_2475_ = v___x_2472_;
goto v_reusejp_2474_;
}
else
{
lean_object* v_reuseFailAlloc_2479_; 
v_reuseFailAlloc_2479_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_2479_, 0, v_rewriteCache_2466_);
lean_ctor_set(v_reuseFailAlloc_2479_, 1, v_acNfCache_2467_);
lean_ctor_set(v_reuseFailAlloc_2479_, 2, v_typeAnalysis_2468_);
lean_ctor_set(v_reuseFailAlloc_2479_, 3, v_goal_2469_);
lean_ctor_set(v_reuseFailAlloc_2479_, 4, v_hyps_2455_);
lean_ctor_set_uint8(v_reuseFailAlloc_2479_, sizeof(void*)*5, v_didChange_2470_);
v___x_2475_ = v_reuseFailAlloc_2479_;
goto v_reusejp_2474_;
}
v_reusejp_2474_:
{
lean_object* v___x_2476_; lean_object* v___x_2477_; lean_object* v___x_2478_; 
v___x_2476_ = lean_st_ref_set(v___y_2457_, v___x_2475_);
v___x_2477_ = lean_box(0);
v___x_2478_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2478_, 0, v___x_2477_);
return v___x_2478_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__0___boxed(lean_object* v_hyps_2482_, lean_object* v___y_2483_, lean_object* v___y_2484_, lean_object* v___y_2485_, lean_object* v___y_2486_, lean_object* v___y_2487_, lean_object* v___y_2488_, lean_object* v___y_2489_, lean_object* v___y_2490_, lean_object* v___y_2491_){
_start:
{
lean_object* v_res_2492_; 
v_res_2492_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__0(v_hyps_2482_, v___y_2483_, v___y_2484_, v___y_2485_, v___y_2486_, v___y_2487_, v___y_2488_, v___y_2489_, v___y_2490_);
lean_dec(v___y_2490_);
lean_dec_ref(v___y_2489_);
lean_dec(v___y_2488_);
lean_dec_ref(v___y_2487_);
lean_dec(v___y_2486_);
lean_dec_ref(v___y_2485_);
lean_dec(v___y_2484_);
lean_dec_ref(v___y_2483_);
return v_res_2492_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__1(lean_object* v_inst_2493_, lean_object* v_hyps_2494_){
_start:
{
lean_object* v___f_2495_; lean_object* v___x_2496_; 
v___f_2495_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__0___boxed), 10, 1);
lean_closure_set(v___f_2495_, 0, v_hyps_2494_);
v___x_2496_ = lean_apply_2(v_inst_2493_, lean_box(0), v___f_2495_);
return v___x_2496_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__2(lean_object* v___y_2497_, lean_object* v___y_2498_, lean_object* v___y_2499_, lean_object* v___y_2500_, lean_object* v___y_2501_, lean_object* v___y_2502_, lean_object* v___y_2503_, lean_object* v___y_2504_){
_start:
{
lean_object* v___x_2506_; lean_object* v_rewriteCache_2507_; lean_object* v_acNfCache_2508_; lean_object* v_typeAnalysis_2509_; lean_object* v_goal_2510_; uint8_t v_didChange_2511_; lean_object* v___x_2513_; uint8_t v_isShared_2514_; uint8_t v_isSharedCheck_2522_; 
v___x_2506_ = lean_st_ref_take(v___y_2498_);
v_rewriteCache_2507_ = lean_ctor_get(v___x_2506_, 0);
v_acNfCache_2508_ = lean_ctor_get(v___x_2506_, 1);
v_typeAnalysis_2509_ = lean_ctor_get(v___x_2506_, 2);
v_goal_2510_ = lean_ctor_get(v___x_2506_, 3);
v_didChange_2511_ = lean_ctor_get_uint8(v___x_2506_, sizeof(void*)*5);
v_isSharedCheck_2522_ = !lean_is_exclusive(v___x_2506_);
if (v_isSharedCheck_2522_ == 0)
{
lean_object* v_unused_2523_; 
v_unused_2523_ = lean_ctor_get(v___x_2506_, 4);
lean_dec(v_unused_2523_);
v___x_2513_ = v___x_2506_;
v_isShared_2514_ = v_isSharedCheck_2522_;
goto v_resetjp_2512_;
}
else
{
lean_inc(v_goal_2510_);
lean_inc(v_typeAnalysis_2509_);
lean_inc(v_acNfCache_2508_);
lean_inc(v_rewriteCache_2507_);
lean_dec(v___x_2506_);
v___x_2513_ = lean_box(0);
v_isShared_2514_ = v_isSharedCheck_2522_;
goto v_resetjp_2512_;
}
v_resetjp_2512_:
{
lean_object* v___x_2515_; lean_object* v___x_2517_; 
v___x_2515_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__12));
if (v_isShared_2514_ == 0)
{
lean_ctor_set(v___x_2513_, 4, v___x_2515_);
v___x_2517_ = v___x_2513_;
goto v_reusejp_2516_;
}
else
{
lean_object* v_reuseFailAlloc_2521_; 
v_reuseFailAlloc_2521_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_2521_, 0, v_rewriteCache_2507_);
lean_ctor_set(v_reuseFailAlloc_2521_, 1, v_acNfCache_2508_);
lean_ctor_set(v_reuseFailAlloc_2521_, 2, v_typeAnalysis_2509_);
lean_ctor_set(v_reuseFailAlloc_2521_, 3, v_goal_2510_);
lean_ctor_set(v_reuseFailAlloc_2521_, 4, v___x_2515_);
lean_ctor_set_uint8(v_reuseFailAlloc_2521_, sizeof(void*)*5, v_didChange_2511_);
v___x_2517_ = v_reuseFailAlloc_2521_;
goto v_reusejp_2516_;
}
v_reusejp_2516_:
{
lean_object* v___x_2518_; lean_object* v___x_2519_; lean_object* v___x_2520_; 
v___x_2518_ = lean_st_ref_set(v___y_2498_, v___x_2517_);
v___x_2519_ = lean_box(0);
v___x_2520_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2520_, 0, v___x_2519_);
return v___x_2520_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__2___boxed(lean_object* v___y_2524_, lean_object* v___y_2525_, lean_object* v___y_2526_, lean_object* v___y_2527_, lean_object* v___y_2528_, lean_object* v___y_2529_, lean_object* v___y_2530_, lean_object* v___y_2531_, lean_object* v___y_2532_){
_start:
{
lean_object* v_res_2533_; 
v_res_2533_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__2(v___y_2524_, v___y_2525_, v___y_2526_, v___y_2527_, v___y_2528_, v___y_2529_, v___y_2530_, v___y_2531_);
lean_dec(v___y_2531_);
lean_dec_ref(v___y_2530_);
lean_dec(v___y_2529_);
lean_dec_ref(v___y_2528_);
lean_dec(v___y_2527_);
lean_dec_ref(v___y_2526_);
lean_dec(v___y_2525_);
lean_dec_ref(v___y_2524_);
return v_res_2533_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__3(lean_object* v_toPure_2534_, lean_object* v_cls_2535_, lean_object* v_____do__lift_2536_, lean_object* v_____do__lift_2537_){
_start:
{
uint8_t v_hasTrace_2538_; 
v_hasTrace_2538_ = lean_ctor_get_uint8(v_____do__lift_2537_, sizeof(void*)*1);
if (v_hasTrace_2538_ == 0)
{
lean_object* v___x_2539_; lean_object* v___x_2540_; 
lean_dec(v_cls_2535_);
v___x_2539_ = lean_box(v_hasTrace_2538_);
v___x_2540_ = lean_apply_2(v_toPure_2534_, lean_box(0), v___x_2539_);
return v___x_2540_;
}
else
{
lean_object* v___x_2541_; lean_object* v___x_2542_; uint8_t v___x_2543_; lean_object* v___x_2544_; lean_object* v___x_2545_; 
v___x_2541_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__13));
v___x_2542_ = l_Lean_Name_append(v___x_2541_, v_cls_2535_);
v___x_2543_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_____do__lift_2536_, v_____do__lift_2537_, v___x_2542_);
lean_dec(v___x_2542_);
v___x_2544_ = lean_box(v___x_2543_);
v___x_2545_ = lean_apply_2(v_toPure_2534_, lean_box(0), v___x_2544_);
return v___x_2545_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__3___boxed(lean_object* v_toPure_2546_, lean_object* v_cls_2547_, lean_object* v_____do__lift_2548_, lean_object* v_____do__lift_2549_){
_start:
{
lean_object* v_res_2550_; 
v_res_2550_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__3(v_toPure_2546_, v_cls_2547_, v_____do__lift_2548_, v_____do__lift_2549_);
lean_dec_ref(v_____do__lift_2549_);
lean_dec_ref(v_____do__lift_2548_);
return v_res_2550_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__4(lean_object* v_toPure_2551_, lean_object* v_cls_2552_, lean_object* v_toBind_2553_, lean_object* v_inst_2554_, lean_object* v_____do__lift_2555_){
_start:
{
lean_object* v___f_2556_; lean_object* v___x_2557_; 
v___f_2556_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__3___boxed), 4, 3);
lean_closure_set(v___f_2556_, 0, v_toPure_2551_);
lean_closure_set(v___f_2556_, 1, v_cls_2552_);
lean_closure_set(v___f_2556_, 2, v_____do__lift_2555_);
v___x_2557_ = lean_apply_4(v_toBind_2553_, lean_box(0), lean_box(0), v_inst_2554_, v___f_2556_);
return v___x_2557_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1(void){
_start:
{
lean_object* v___x_2559_; lean_object* v___x_2560_; 
v___x_2559_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__0));
v___x_2560_ = l_Lean_stringToMessageData(v___x_2559_);
return v___x_2560_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5(lean_object* v_toPure_2561_, lean_object* v_a_2562_, lean_object* v___y_2563_, lean_object* v_inst_2564_, lean_object* v_inst_2565_, lean_object* v_inst_2566_, lean_object* v_inst_2567_, lean_object* v_cls_2568_, uint8_t v_____do__lift_2569_){
_start:
{
if (v_____do__lift_2569_ == 0)
{
lean_object* v___x_2570_; lean_object* v___x_2571_; 
lean_dec(v_cls_2568_);
lean_dec(v_inst_2567_);
lean_dec_ref(v_inst_2566_);
lean_dec_ref(v_inst_2565_);
lean_dec_ref(v_inst_2564_);
lean_dec_ref(v___y_2563_);
lean_dec_ref(v_a_2562_);
v___x_2570_ = lean_box(0);
v___x_2571_ = lean_apply_2(v_toPure_2561_, lean_box(0), v___x_2570_);
return v___x_2571_;
}
else
{
lean_object* v_type_2572_; lean_object* v_type_2573_; lean_object* v___x_2574_; lean_object* v___x_2575_; lean_object* v___x_2576_; lean_object* v___x_2577_; lean_object* v___x_2578_; lean_object* v___x_2579_; 
lean_dec(v_toPure_2561_);
v_type_2572_ = lean_ctor_get(v_a_2562_, 1);
lean_inc_ref(v_type_2572_);
lean_dec_ref(v_a_2562_);
v_type_2573_ = lean_ctor_get(v___y_2563_, 1);
lean_inc_ref(v_type_2573_);
lean_dec_ref(v___y_2563_);
v___x_2574_ = l_Lean_MessageData_ofExpr(v_type_2572_);
v___x_2575_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1);
v___x_2576_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2576_, 0, v___x_2574_);
lean_ctor_set(v___x_2576_, 1, v___x_2575_);
v___x_2577_ = l_Lean_MessageData_ofExpr(v_type_2573_);
v___x_2578_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2578_, 0, v___x_2576_);
lean_ctor_set(v___x_2578_, 1, v___x_2577_);
v___x_2579_ = l_Lean_addTrace___redArg(v_inst_2564_, v_inst_2565_, v_inst_2566_, v_inst_2567_, v_cls_2568_, v___x_2578_);
return v___x_2579_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___boxed(lean_object* v_toPure_2580_, lean_object* v_a_2581_, lean_object* v___y_2582_, lean_object* v_inst_2583_, lean_object* v_inst_2584_, lean_object* v_inst_2585_, lean_object* v_inst_2586_, lean_object* v_cls_2587_, lean_object* v_____do__lift_2588_){
_start:
{
uint8_t v_____do__lift_3056__boxed_2589_; lean_object* v_res_2590_; 
v_____do__lift_3056__boxed_2589_ = lean_unbox(v_____do__lift_2588_);
v_res_2590_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5(v_toPure_2580_, v_a_2581_, v___y_2582_, v_inst_2583_, v_inst_2584_, v_inst_2585_, v_inst_2586_, v_cls_2587_, v_____do__lift_3056__boxed_2589_);
return v_res_2590_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__6(lean_object* v_inst_2591_, lean_object* v_toPure_2592_, lean_object* v_toBind_2593_, lean_object* v_inst_2594_, lean_object* v_a_2595_, lean_object* v_inst_2596_, lean_object* v_inst_2597_, lean_object* v_inst_2598_, lean_object* v_x_2599_, lean_object* v___y_2600_){
_start:
{
lean_object* v_getInheritedTraceOptions_2601_; lean_object* v_cls_2602_; lean_object* v___f_2603_; lean_object* v___f_2604_; lean_object* v___x_2605_; lean_object* v___x_2606_; 
v_getInheritedTraceOptions_2601_ = lean_ctor_get(v_inst_2591_, 2);
lean_inc(v_getInheritedTraceOptions_2601_);
v_cls_2602_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
lean_inc_n(v_toBind_2593_, 2);
lean_inc(v_toPure_2592_);
v___f_2603_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__4), 5, 4);
lean_closure_set(v___f_2603_, 0, v_toPure_2592_);
lean_closure_set(v___f_2603_, 1, v_cls_2602_);
lean_closure_set(v___f_2603_, 2, v_toBind_2593_);
lean_closure_set(v___f_2603_, 3, v_inst_2594_);
v___f_2604_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___boxed), 9, 8);
lean_closure_set(v___f_2604_, 0, v_toPure_2592_);
lean_closure_set(v___f_2604_, 1, v_a_2595_);
lean_closure_set(v___f_2604_, 2, v___y_2600_);
lean_closure_set(v___f_2604_, 3, v_inst_2596_);
lean_closure_set(v___f_2604_, 4, v_inst_2591_);
lean_closure_set(v___f_2604_, 5, v_inst_2597_);
lean_closure_set(v___f_2604_, 6, v_inst_2598_);
lean_closure_set(v___f_2604_, 7, v_cls_2602_);
v___x_2605_ = lean_apply_4(v_toBind_2593_, lean_box(0), lean_box(0), v_getInheritedTraceOptions_2601_, v___f_2603_);
v___x_2606_ = lean_apply_4(v_toBind_2593_, lean_box(0), lean_box(0), v___x_2605_, v___f_2604_);
return v___x_2606_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__11(lean_object* v_toPure_2607_, lean_object* v_res_2608_, lean_object* v_____r_2609_){
_start:
{
lean_object* v___x_2610_; 
v___x_2610_ = lean_apply_2(v_toPure_2607_, lean_box(0), v_res_2608_);
return v___x_2610_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__7(lean_object* v_inst_2611_, lean_object* v_toBind_2612_, lean_object* v___f_2613_, lean_object* v_____r_2614_){
_start:
{
lean_object* v___x_2615_; lean_object* v___x_2616_; lean_object* v___x_2617_; 
v___x_2615_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_setDidChange___boxed), 9, 0);
v___x_2616_ = lean_apply_2(v_inst_2611_, lean_box(0), v___x_2615_);
v___x_2617_ = lean_apply_4(v_toBind_2612_, lean_box(0), lean_box(0), v___x_2616_, v___f_2613_);
return v___x_2617_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__10(lean_object* v___f_2618_, lean_object* v_____r_2619_){
_start:
{
lean_object* v___x_2620_; 
v___x_2620_ = lean_apply_1(v___f_2618_, v_____r_2619_);
return v___x_2620_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__12(lean_object* v___f_2621_, lean_object* v_a_2622_, lean_object* v_newHyp_2623_, lean_object* v_inst_2624_, lean_object* v_inst_2625_, lean_object* v_inst_2626_, lean_object* v_inst_2627_, lean_object* v_cls_2628_, lean_object* v_toBind_2629_, lean_object* v___f_2630_, uint8_t v_____do__lift_2631_){
_start:
{
if (v_____do__lift_2631_ == 0)
{
lean_object* v___x_2632_; lean_object* v___x_2633_; 
lean_dec(v___f_2630_);
lean_dec(v_toBind_2629_);
lean_dec(v_cls_2628_);
lean_dec(v_inst_2627_);
lean_dec_ref(v_inst_2626_);
lean_dec_ref(v_inst_2625_);
lean_dec_ref(v_inst_2624_);
lean_dec_ref(v_newHyp_2623_);
lean_dec_ref(v_a_2622_);
v___x_2632_ = lean_box(0);
v___x_2633_ = lean_apply_1(v___f_2621_, v___x_2632_);
return v___x_2633_;
}
else
{
lean_object* v_type_2634_; lean_object* v_type_2635_; lean_object* v___x_2636_; lean_object* v___x_2637_; lean_object* v___x_2638_; lean_object* v___x_2639_; lean_object* v___x_2640_; lean_object* v___x_2641_; lean_object* v___x_2642_; 
lean_dec(v___f_2621_);
v_type_2634_ = lean_ctor_get(v_a_2622_, 1);
lean_inc_ref(v_type_2634_);
lean_dec_ref(v_a_2622_);
v_type_2635_ = lean_ctor_get(v_newHyp_2623_, 1);
lean_inc_ref(v_type_2635_);
lean_dec_ref(v_newHyp_2623_);
v___x_2636_ = l_Lean_MessageData_ofExpr(v_type_2634_);
v___x_2637_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1);
v___x_2638_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2638_, 0, v___x_2636_);
lean_ctor_set(v___x_2638_, 1, v___x_2637_);
v___x_2639_ = l_Lean_MessageData_ofExpr(v_type_2635_);
v___x_2640_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2640_, 0, v___x_2638_);
lean_ctor_set(v___x_2640_, 1, v___x_2639_);
v___x_2641_ = l_Lean_addTrace___redArg(v_inst_2624_, v_inst_2625_, v_inst_2626_, v_inst_2627_, v_cls_2628_, v___x_2640_);
v___x_2642_ = lean_apply_4(v_toBind_2629_, lean_box(0), lean_box(0), v___x_2641_, v___f_2630_);
return v___x_2642_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__12___boxed(lean_object* v___f_2643_, lean_object* v_a_2644_, lean_object* v_newHyp_2645_, lean_object* v_inst_2646_, lean_object* v_inst_2647_, lean_object* v_inst_2648_, lean_object* v_inst_2649_, lean_object* v_cls_2650_, lean_object* v_toBind_2651_, lean_object* v___f_2652_, lean_object* v_____do__lift_2653_){
_start:
{
uint8_t v_____do__lift_3156__boxed_2654_; lean_object* v_res_2655_; 
v_____do__lift_3156__boxed_2654_ = lean_unbox(v_____do__lift_2653_);
v_res_2655_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__12(v___f_2643_, v_a_2644_, v_newHyp_2645_, v_inst_2646_, v_inst_2647_, v_inst_2648_, v_inst_2649_, v_cls_2650_, v_toBind_2651_, v___f_2652_, v_____do__lift_3156__boxed_2654_);
return v_res_2655_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__13(lean_object* v_toPure_2656_, lean_object* v_inst_2657_, lean_object* v_toBind_2658_, lean_object* v_inst_2659_, lean_object* v___f_2660_, lean_object* v_a_2661_, lean_object* v_inst_2662_, lean_object* v_inst_2663_, lean_object* v_inst_2664_, lean_object* v_inst_2665_, lean_object* v___f_2666_, lean_object* v_res_2667_){
_start:
{
lean_object* v___x_2668_; lean_object* v_zero_2669_; uint8_t v_isZero_2670_; 
v___x_2668_ = lean_array_get_size(v_res_2667_);
v_zero_2669_ = lean_unsigned_to_nat(0u);
v_isZero_2670_ = lean_nat_dec_eq(v___x_2668_, v_zero_2669_);
if (v_isZero_2670_ == 1)
{
lean_object* v___f_2671_; lean_object* v___f_2672_; lean_object* v___x_2673_; uint8_t v___x_2674_; 
lean_dec(v___f_2666_);
lean_dec(v_inst_2665_);
lean_dec_ref(v_inst_2664_);
lean_dec(v_inst_2663_);
lean_dec_ref(v_inst_2662_);
lean_dec_ref(v_a_2661_);
lean_inc_ref(v_res_2667_);
lean_inc(v_toPure_2656_);
v___f_2671_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__11), 3, 2);
lean_closure_set(v___f_2671_, 0, v_toPure_2656_);
lean_closure_set(v___f_2671_, 1, v_res_2667_);
lean_inc(v_toBind_2658_);
v___f_2672_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__7), 4, 3);
lean_closure_set(v___f_2672_, 0, v_inst_2657_);
lean_closure_set(v___f_2672_, 1, v_toBind_2658_);
lean_closure_set(v___f_2672_, 2, v___f_2671_);
v___x_2673_ = lean_box(0);
v___x_2674_ = lean_nat_dec_lt(v_zero_2669_, v___x_2668_);
if (v___x_2674_ == 0)
{
lean_object* v___x_2675_; lean_object* v___x_2676_; 
lean_dec_ref(v_res_2667_);
lean_dec(v___f_2660_);
lean_dec_ref(v_inst_2659_);
v___x_2675_ = lean_apply_2(v_toPure_2656_, lean_box(0), v___x_2673_);
v___x_2676_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v___x_2675_, v___f_2672_);
return v___x_2676_;
}
else
{
uint8_t v___x_2677_; 
v___x_2677_ = lean_nat_dec_le(v___x_2668_, v___x_2668_);
if (v___x_2677_ == 0)
{
if (v___x_2674_ == 0)
{
lean_object* v___x_2678_; lean_object* v___x_2679_; 
lean_dec_ref(v_res_2667_);
lean_dec(v___f_2660_);
lean_dec_ref(v_inst_2659_);
v___x_2678_ = lean_apply_2(v_toPure_2656_, lean_box(0), v___x_2673_);
v___x_2679_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v___x_2678_, v___f_2672_);
return v___x_2679_;
}
else
{
size_t v___x_2680_; size_t v___x_2681_; lean_object* v___x_2682_; lean_object* v___x_2683_; 
lean_dec(v_toPure_2656_);
v___x_2680_ = ((size_t)0ULL);
v___x_2681_ = lean_usize_of_nat(v___x_2668_);
v___x_2682_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v_inst_2659_, v___f_2660_, v_res_2667_, v___x_2680_, v___x_2681_, v___x_2673_);
v___x_2683_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v___x_2682_, v___f_2672_);
return v___x_2683_;
}
}
else
{
size_t v___x_2684_; size_t v___x_2685_; lean_object* v___x_2686_; lean_object* v___x_2687_; 
lean_dec(v_toPure_2656_);
v___x_2684_ = ((size_t)0ULL);
v___x_2685_ = lean_usize_of_nat(v___x_2668_);
v___x_2686_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v_inst_2659_, v___f_2660_, v_res_2667_, v___x_2684_, v___x_2685_, v___x_2673_);
v___x_2687_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v___x_2686_, v___f_2672_);
return v___x_2687_;
}
}
}
else
{
lean_object* v_one_2688_; lean_object* v_n_2689_; uint8_t v_isZero_2690_; 
lean_dec(v___f_2660_);
v_one_2688_ = lean_unsigned_to_nat(1u);
v_n_2689_ = lean_nat_sub(v___x_2668_, v_one_2688_);
v_isZero_2690_ = lean_nat_dec_eq(v_n_2689_, v_zero_2669_);
lean_dec(v_n_2689_);
if (v_isZero_2690_ == 1)
{
lean_object* v_newHyp_2691_; uint8_t v___x_2692_; 
lean_dec(v___f_2666_);
v_newHyp_2691_ = lean_array_fget_borrowed(v_res_2667_, v_zero_2669_);
v___x_2692_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(v_newHyp_2691_, v_a_2661_);
if (v___x_2692_ == 0)
{
lean_object* v_getInheritedTraceOptions_2693_; lean_object* v___f_2694_; lean_object* v___f_2695_; lean_object* v___f_2696_; lean_object* v_cls_2697_; lean_object* v___f_2698_; lean_object* v___f_2699_; lean_object* v___x_2700_; lean_object* v___x_2701_; 
lean_inc(v_newHyp_2691_);
v_getInheritedTraceOptions_2693_ = lean_ctor_get(v_inst_2662_, 2);
lean_inc(v_getInheritedTraceOptions_2693_);
lean_inc(v_toPure_2656_);
v___f_2694_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__11), 3, 2);
lean_closure_set(v___f_2694_, 0, v_toPure_2656_);
lean_closure_set(v___f_2694_, 1, v_res_2667_);
lean_inc_n(v_toBind_2658_, 4);
v___f_2695_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__7), 4, 3);
lean_closure_set(v___f_2695_, 0, v_inst_2657_);
lean_closure_set(v___f_2695_, 1, v_toBind_2658_);
lean_closure_set(v___f_2695_, 2, v___f_2694_);
lean_inc_ref(v___f_2695_);
v___f_2696_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__10), 2, 1);
lean_closure_set(v___f_2696_, 0, v___f_2695_);
v_cls_2697_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
v___f_2698_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__4), 5, 4);
lean_closure_set(v___f_2698_, 0, v_toPure_2656_);
lean_closure_set(v___f_2698_, 1, v_cls_2697_);
lean_closure_set(v___f_2698_, 2, v_toBind_2658_);
lean_closure_set(v___f_2698_, 3, v_inst_2663_);
v___f_2699_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__12___boxed), 11, 10);
lean_closure_set(v___f_2699_, 0, v___f_2695_);
lean_closure_set(v___f_2699_, 1, v_a_2661_);
lean_closure_set(v___f_2699_, 2, v_newHyp_2691_);
lean_closure_set(v___f_2699_, 3, v_inst_2659_);
lean_closure_set(v___f_2699_, 4, v_inst_2662_);
lean_closure_set(v___f_2699_, 5, v_inst_2664_);
lean_closure_set(v___f_2699_, 6, v_inst_2665_);
lean_closure_set(v___f_2699_, 7, v_cls_2697_);
lean_closure_set(v___f_2699_, 8, v_toBind_2658_);
lean_closure_set(v___f_2699_, 9, v___f_2696_);
v___x_2700_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v_getInheritedTraceOptions_2693_, v___f_2698_);
v___x_2701_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v___x_2700_, v___f_2699_);
return v___x_2701_;
}
else
{
lean_object* v___x_2702_; 
lean_dec(v_inst_2665_);
lean_dec_ref(v_inst_2664_);
lean_dec(v_inst_2663_);
lean_dec_ref(v_inst_2662_);
lean_dec_ref(v_a_2661_);
lean_dec_ref(v_inst_2659_);
lean_dec(v_toBind_2658_);
lean_dec(v_inst_2657_);
v___x_2702_ = lean_apply_2(v_toPure_2656_, lean_box(0), v_res_2667_);
return v___x_2702_;
}
}
else
{
lean_object* v___f_2703_; lean_object* v___f_2704_; lean_object* v___x_2705_; uint8_t v___x_2706_; 
lean_dec(v_inst_2665_);
lean_dec_ref(v_inst_2664_);
lean_dec(v_inst_2663_);
lean_dec_ref(v_inst_2662_);
lean_dec_ref(v_a_2661_);
lean_inc_ref(v_res_2667_);
lean_inc(v_toPure_2656_);
v___f_2703_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__11), 3, 2);
lean_closure_set(v___f_2703_, 0, v_toPure_2656_);
lean_closure_set(v___f_2703_, 1, v_res_2667_);
lean_inc(v_toBind_2658_);
v___f_2704_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__7), 4, 3);
lean_closure_set(v___f_2704_, 0, v_inst_2657_);
lean_closure_set(v___f_2704_, 1, v_toBind_2658_);
lean_closure_set(v___f_2704_, 2, v___f_2703_);
v___x_2705_ = lean_box(0);
v___x_2706_ = lean_nat_dec_lt(v_zero_2669_, v___x_2668_);
if (v___x_2706_ == 0)
{
lean_object* v___x_2707_; lean_object* v___x_2708_; 
lean_dec_ref(v_res_2667_);
lean_dec(v___f_2666_);
lean_dec_ref(v_inst_2659_);
v___x_2707_ = lean_apply_2(v_toPure_2656_, lean_box(0), v___x_2705_);
v___x_2708_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v___x_2707_, v___f_2704_);
return v___x_2708_;
}
else
{
uint8_t v___x_2709_; 
v___x_2709_ = lean_nat_dec_le(v___x_2668_, v___x_2668_);
if (v___x_2709_ == 0)
{
if (v___x_2706_ == 0)
{
lean_object* v___x_2710_; lean_object* v___x_2711_; 
lean_dec_ref(v_res_2667_);
lean_dec(v___f_2666_);
lean_dec_ref(v_inst_2659_);
v___x_2710_ = lean_apply_2(v_toPure_2656_, lean_box(0), v___x_2705_);
v___x_2711_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v___x_2710_, v___f_2704_);
return v___x_2711_;
}
else
{
size_t v___x_2712_; size_t v___x_2713_; lean_object* v___x_2714_; lean_object* v___x_2715_; 
lean_dec(v_toPure_2656_);
v___x_2712_ = ((size_t)0ULL);
v___x_2713_ = lean_usize_of_nat(v___x_2668_);
v___x_2714_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v_inst_2659_, v___f_2666_, v_res_2667_, v___x_2712_, v___x_2713_, v___x_2705_);
v___x_2715_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v___x_2714_, v___f_2704_);
return v___x_2715_;
}
}
else
{
size_t v___x_2716_; size_t v___x_2717_; lean_object* v___x_2718_; lean_object* v___x_2719_; 
lean_dec(v_toPure_2656_);
v___x_2716_ = ((size_t)0ULL);
v___x_2717_ = lean_usize_of_nat(v___x_2668_);
v___x_2718_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v_inst_2659_, v___f_2666_, v_res_2667_, v___x_2716_, v___x_2717_, v___x_2705_);
v___x_2719_ = lean_apply_4(v_toBind_2658_, lean_box(0), lean_box(0), v___x_2718_, v___f_2704_);
return v___x_2719_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__8(lean_object* v_bs_2720_, lean_object* v_toPure_2721_, lean_object* v_____do__lift_2722_){
_start:
{
lean_object* v___x_2723_; lean_object* v___x_2724_; 
v___x_2723_ = l_Array_append___redArg(v_bs_2720_, v_____do__lift_2722_);
v___x_2724_ = lean_apply_2(v_toPure_2721_, lean_box(0), v___x_2723_);
return v___x_2724_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__8___boxed(lean_object* v_bs_2725_, lean_object* v_toPure_2726_, lean_object* v_____do__lift_2727_){
_start:
{
lean_object* v_res_2728_; 
v_res_2728_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__8(v_bs_2725_, v_toPure_2726_, v_____do__lift_2727_);
lean_dec_ref(v_____do__lift_2727_);
return v_res_2728_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__9(lean_object* v_inst_2729_, lean_object* v_toPure_2730_, lean_object* v_toBind_2731_, lean_object* v_inst_2732_, lean_object* v_inst_2733_, lean_object* v_inst_2734_, lean_object* v_inst_2735_, lean_object* v_inst_2736_, lean_object* v_f_2737_, lean_object* v_bs_2738_, lean_object* v_a_2739_){
_start:
{
lean_object* v___f_2740_; lean_object* v___f_2741_; lean_object* v___f_2742_; lean_object* v___x_2743_; lean_object* v___x_2744_; lean_object* v___x_2745_; 
lean_inc(v_inst_2735_);
lean_inc_ref(v_inst_2734_);
lean_inc_ref(v_inst_2733_);
lean_inc_ref_n(v_a_2739_, 2);
lean_inc(v_inst_2732_);
lean_inc_n(v_toBind_2731_, 3);
lean_inc_n(v_toPure_2730_, 2);
lean_inc_ref(v_inst_2729_);
v___f_2740_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__6), 10, 8);
lean_closure_set(v___f_2740_, 0, v_inst_2729_);
lean_closure_set(v___f_2740_, 1, v_toPure_2730_);
lean_closure_set(v___f_2740_, 2, v_toBind_2731_);
lean_closure_set(v___f_2740_, 3, v_inst_2732_);
lean_closure_set(v___f_2740_, 4, v_a_2739_);
lean_closure_set(v___f_2740_, 5, v_inst_2733_);
lean_closure_set(v___f_2740_, 6, v_inst_2734_);
lean_closure_set(v___f_2740_, 7, v_inst_2735_);
lean_inc_ref(v___f_2740_);
v___f_2741_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__13), 12, 11);
lean_closure_set(v___f_2741_, 0, v_toPure_2730_);
lean_closure_set(v___f_2741_, 1, v_inst_2736_);
lean_closure_set(v___f_2741_, 2, v_toBind_2731_);
lean_closure_set(v___f_2741_, 3, v_inst_2733_);
lean_closure_set(v___f_2741_, 4, v___f_2740_);
lean_closure_set(v___f_2741_, 5, v_a_2739_);
lean_closure_set(v___f_2741_, 6, v_inst_2729_);
lean_closure_set(v___f_2741_, 7, v_inst_2732_);
lean_closure_set(v___f_2741_, 8, v_inst_2734_);
lean_closure_set(v___f_2741_, 9, v_inst_2735_);
lean_closure_set(v___f_2741_, 10, v___f_2740_);
v___f_2742_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__8___boxed), 3, 2);
lean_closure_set(v___f_2742_, 0, v_bs_2738_);
lean_closure_set(v___f_2742_, 1, v_toPure_2730_);
v___x_2743_ = lean_apply_1(v_f_2737_, v_a_2739_);
v___x_2744_ = lean_apply_4(v_toBind_2731_, lean_box(0), lean_box(0), v___x_2743_, v___f_2741_);
v___x_2745_ = lean_apply_4(v_toBind_2731_, lean_box(0), lean_box(0), v___x_2744_, v___f_2742_);
return v___x_2745_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__14(lean_object* v_hyps_2748_, lean_object* v_toPure_2749_, lean_object* v_toBind_2750_, lean_object* v___f_2751_, lean_object* v_inst_2752_, lean_object* v___f_2753_, lean_object* v_____r_2754_){
_start:
{
lean_object* v___x_2755_; lean_object* v___x_2756_; lean_object* v___x_2757_; uint8_t v___x_2758_; 
v___x_2755_ = lean_unsigned_to_nat(0u);
v___x_2756_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__14___closed__0));
v___x_2757_ = lean_array_get_size(v_hyps_2748_);
v___x_2758_ = lean_nat_dec_lt(v___x_2755_, v___x_2757_);
if (v___x_2758_ == 0)
{
lean_object* v___x_2759_; lean_object* v___x_2760_; 
lean_dec(v___f_2753_);
lean_dec_ref(v_inst_2752_);
lean_dec_ref(v_hyps_2748_);
v___x_2759_ = lean_apply_2(v_toPure_2749_, lean_box(0), v___x_2756_);
v___x_2760_ = lean_apply_4(v_toBind_2750_, lean_box(0), lean_box(0), v___x_2759_, v___f_2751_);
return v___x_2760_;
}
else
{
uint8_t v___x_2761_; 
v___x_2761_ = lean_nat_dec_le(v___x_2757_, v___x_2757_);
if (v___x_2761_ == 0)
{
if (v___x_2758_ == 0)
{
lean_object* v___x_2762_; lean_object* v___x_2763_; 
lean_dec(v___f_2753_);
lean_dec_ref(v_inst_2752_);
lean_dec_ref(v_hyps_2748_);
v___x_2762_ = lean_apply_2(v_toPure_2749_, lean_box(0), v___x_2756_);
v___x_2763_ = lean_apply_4(v_toBind_2750_, lean_box(0), lean_box(0), v___x_2762_, v___f_2751_);
return v___x_2763_;
}
else
{
size_t v___x_2764_; size_t v___x_2765_; lean_object* v___x_2766_; lean_object* v___x_2767_; 
lean_dec(v_toPure_2749_);
v___x_2764_ = ((size_t)0ULL);
v___x_2765_ = lean_usize_of_nat(v___x_2757_);
v___x_2766_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v_inst_2752_, v___f_2753_, v_hyps_2748_, v___x_2764_, v___x_2765_, v___x_2756_);
v___x_2767_ = lean_apply_4(v_toBind_2750_, lean_box(0), lean_box(0), v___x_2766_, v___f_2751_);
return v___x_2767_;
}
}
else
{
size_t v___x_2768_; size_t v___x_2769_; lean_object* v___x_2770_; lean_object* v___x_2771_; 
lean_dec(v_toPure_2749_);
v___x_2768_ = ((size_t)0ULL);
v___x_2769_ = lean_usize_of_nat(v___x_2757_);
v___x_2770_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v_inst_2752_, v___f_2753_, v_hyps_2748_, v___x_2768_, v___x_2769_, v___x_2756_);
v___x_2771_ = lean_apply_4(v_toBind_2750_, lean_box(0), lean_box(0), v___x_2770_, v___f_2751_);
return v___x_2771_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__15(lean_object* v_toPure_2772_, lean_object* v_toBind_2773_, lean_object* v___f_2774_, lean_object* v_inst_2775_, lean_object* v___f_2776_, lean_object* v_inst_2777_, lean_object* v___f_2778_, lean_object* v_hyps_2779_){
_start:
{
lean_object* v___f_2780_; lean_object* v___x_2781_; lean_object* v___x_2782_; 
lean_inc(v_toBind_2773_);
v___f_2780_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__14), 7, 6);
lean_closure_set(v___f_2780_, 0, v_hyps_2779_);
lean_closure_set(v___f_2780_, 1, v_toPure_2772_);
lean_closure_set(v___f_2780_, 2, v_toBind_2773_);
lean_closure_set(v___f_2780_, 3, v___f_2774_);
lean_closure_set(v___f_2780_, 4, v_inst_2775_);
lean_closure_set(v___f_2780_, 5, v___f_2776_);
v___x_2781_ = lean_apply_2(v_inst_2777_, lean_box(0), v___f_2778_);
v___x_2782_ = lean_apply_4(v_toBind_2773_, lean_box(0), lean_box(0), v___x_2781_, v___f_2780_);
return v___x_2782_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg(lean_object* v_inst_2784_, lean_object* v_inst_2785_, lean_object* v_inst_2786_, lean_object* v_inst_2787_, lean_object* v_inst_2788_, lean_object* v_inst_2789_, lean_object* v_f_2790_){
_start:
{
lean_object* v_toApplicative_2791_; lean_object* v_toBind_2792_; lean_object* v_toPure_2793_; lean_object* v___f_2794_; lean_object* v___f_2795_; lean_object* v___x_2796_; lean_object* v___x_2797_; lean_object* v___f_2798_; lean_object* v___f_2799_; lean_object* v___x_2800_; 
v_toApplicative_2791_ = lean_ctor_get(v_inst_2784_, 0);
v_toBind_2792_ = lean_ctor_get(v_inst_2784_, 1);
lean_inc_n(v_toBind_2792_, 3);
v_toPure_2793_ = lean_ctor_get(v_toApplicative_2791_, 1);
lean_inc_n(v_toPure_2793_, 2);
lean_inc_n(v_inst_2789_, 3);
v___f_2794_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__1), 2, 1);
lean_closure_set(v___f_2794_, 0, v_inst_2789_);
v___f_2795_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___closed__0));
v___x_2796_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed), 9, 0);
v___x_2797_ = lean_apply_2(v_inst_2789_, lean_box(0), v___x_2796_);
lean_inc_ref(v_inst_2784_);
v___f_2798_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__9), 11, 9);
lean_closure_set(v___f_2798_, 0, v_inst_2785_);
lean_closure_set(v___f_2798_, 1, v_toPure_2793_);
lean_closure_set(v___f_2798_, 2, v_toBind_2792_);
lean_closure_set(v___f_2798_, 3, v_inst_2786_);
lean_closure_set(v___f_2798_, 4, v_inst_2784_);
lean_closure_set(v___f_2798_, 5, v_inst_2788_);
lean_closure_set(v___f_2798_, 6, v_inst_2787_);
lean_closure_set(v___f_2798_, 7, v_inst_2789_);
lean_closure_set(v___f_2798_, 8, v_f_2790_);
v___f_2799_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__15), 8, 7);
lean_closure_set(v___f_2799_, 0, v_toPure_2793_);
lean_closure_set(v___f_2799_, 1, v_toBind_2792_);
lean_closure_set(v___f_2799_, 2, v___f_2794_);
lean_closure_set(v___f_2799_, 3, v_inst_2784_);
lean_closure_set(v___f_2799_, 4, v___f_2798_);
lean_closure_set(v___f_2799_, 5, v_inst_2789_);
lean_closure_set(v___f_2799_, 6, v___f_2795_);
v___x_2800_ = lean_apply_4(v_toBind_2792_, lean_box(0), lean_box(0), v___x_2797_, v___f_2799_);
return v___x_2800_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps(lean_object* v_m_2801_, lean_object* v_inst_2802_, lean_object* v_inst_2803_, lean_object* v_inst_2804_, lean_object* v_inst_2805_, lean_object* v_inst_2806_, lean_object* v_inst_2807_, lean_object* v_f_2808_){
_start:
{
lean_object* v_toApplicative_2809_; lean_object* v_toBind_2810_; lean_object* v_toPure_2811_; lean_object* v___f_2812_; lean_object* v___f_2813_; lean_object* v___x_2814_; lean_object* v___x_2815_; lean_object* v___f_2816_; lean_object* v___f_2817_; lean_object* v___x_2818_; 
v_toApplicative_2809_ = lean_ctor_get(v_inst_2802_, 0);
v_toBind_2810_ = lean_ctor_get(v_inst_2802_, 1);
lean_inc_n(v_toBind_2810_, 3);
v_toPure_2811_ = lean_ctor_get(v_toApplicative_2809_, 1);
lean_inc_n(v_toPure_2811_, 2);
lean_inc_n(v_inst_2807_, 3);
v___f_2812_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__1), 2, 1);
lean_closure_set(v___f_2812_, 0, v_inst_2807_);
v___f_2813_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___closed__0));
v___x_2814_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed), 9, 0);
v___x_2815_ = lean_apply_2(v_inst_2807_, lean_box(0), v___x_2814_);
lean_inc_ref(v_inst_2802_);
v___f_2816_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__9), 11, 9);
lean_closure_set(v___f_2816_, 0, v_inst_2803_);
lean_closure_set(v___f_2816_, 1, v_toPure_2811_);
lean_closure_set(v___f_2816_, 2, v_toBind_2810_);
lean_closure_set(v___f_2816_, 3, v_inst_2804_);
lean_closure_set(v___f_2816_, 4, v_inst_2802_);
lean_closure_set(v___f_2816_, 5, v_inst_2806_);
lean_closure_set(v___f_2816_, 6, v_inst_2805_);
lean_closure_set(v___f_2816_, 7, v_inst_2807_);
lean_closure_set(v___f_2816_, 8, v_f_2808_);
v___f_2817_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__15), 8, 7);
lean_closure_set(v___f_2817_, 0, v_toPure_2811_);
lean_closure_set(v___f_2817_, 1, v_toBind_2810_);
lean_closure_set(v___f_2817_, 2, v___f_2812_);
lean_closure_set(v___f_2817_, 3, v_inst_2802_);
lean_closure_set(v___f_2817_, 4, v___f_2816_);
lean_closure_set(v___f_2817_, 5, v_inst_2807_);
lean_closure_set(v___f_2817_, 6, v___f_2813_);
v___x_2818_ = lean_apply_4(v_toBind_2810_, lean_box(0), lean_box(0), v___x_2815_, v___f_2817_);
return v___x_2818_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__0(lean_object* v_toPure_2819_, lean_object* v_____do__lift_2820_){
_start:
{
lean_object* v___x_2821_; 
v___x_2821_ = lean_apply_2(v_toPure_2819_, lean_box(0), v_____do__lift_2820_);
return v___x_2821_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__1(lean_object* v_toPure_2822_, lean_object* v_____r_2823_){
_start:
{
uint8_t v___x_2824_; lean_object* v___x_2825_; lean_object* v___x_2826_; 
v___x_2824_ = 0;
v___x_2825_ = lean_box(v___x_2824_);
v___x_2826_ = lean_apply_2(v_toPure_2822_, lean_box(0), v___x_2825_);
return v___x_2826_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__2(lean_object* v_snd_2827_, lean_object* v___y_2828_, lean_object* v___y_2829_, lean_object* v___y_2830_, lean_object* v___y_2831_, lean_object* v___y_2832_, lean_object* v___y_2833_, lean_object* v___y_2834_, lean_object* v___y_2835_){
_start:
{
lean_object* v___x_2837_; lean_object* v_rewriteCache_2838_; lean_object* v_acNfCache_2839_; lean_object* v_typeAnalysis_2840_; lean_object* v_goal_2841_; uint8_t v_didChange_2842_; lean_object* v___x_2844_; uint8_t v_isShared_2845_; uint8_t v_isSharedCheck_2852_; 
v___x_2837_ = lean_st_ref_take(v___y_2829_);
v_rewriteCache_2838_ = lean_ctor_get(v___x_2837_, 0);
v_acNfCache_2839_ = lean_ctor_get(v___x_2837_, 1);
v_typeAnalysis_2840_ = lean_ctor_get(v___x_2837_, 2);
v_goal_2841_ = lean_ctor_get(v___x_2837_, 3);
v_didChange_2842_ = lean_ctor_get_uint8(v___x_2837_, sizeof(void*)*5);
v_isSharedCheck_2852_ = !lean_is_exclusive(v___x_2837_);
if (v_isSharedCheck_2852_ == 0)
{
lean_object* v_unused_2853_; 
v_unused_2853_ = lean_ctor_get(v___x_2837_, 4);
lean_dec(v_unused_2853_);
v___x_2844_ = v___x_2837_;
v_isShared_2845_ = v_isSharedCheck_2852_;
goto v_resetjp_2843_;
}
else
{
lean_inc(v_goal_2841_);
lean_inc(v_typeAnalysis_2840_);
lean_inc(v_acNfCache_2839_);
lean_inc(v_rewriteCache_2838_);
lean_dec(v___x_2837_);
v___x_2844_ = lean_box(0);
v_isShared_2845_ = v_isSharedCheck_2852_;
goto v_resetjp_2843_;
}
v_resetjp_2843_:
{
lean_object* v___x_2847_; 
if (v_isShared_2845_ == 0)
{
lean_ctor_set(v___x_2844_, 4, v_snd_2827_);
v___x_2847_ = v___x_2844_;
goto v_reusejp_2846_;
}
else
{
lean_object* v_reuseFailAlloc_2851_; 
v_reuseFailAlloc_2851_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_2851_, 0, v_rewriteCache_2838_);
lean_ctor_set(v_reuseFailAlloc_2851_, 1, v_acNfCache_2839_);
lean_ctor_set(v_reuseFailAlloc_2851_, 2, v_typeAnalysis_2840_);
lean_ctor_set(v_reuseFailAlloc_2851_, 3, v_goal_2841_);
lean_ctor_set(v_reuseFailAlloc_2851_, 4, v_snd_2827_);
lean_ctor_set_uint8(v_reuseFailAlloc_2851_, sizeof(void*)*5, v_didChange_2842_);
v___x_2847_ = v_reuseFailAlloc_2851_;
goto v_reusejp_2846_;
}
v_reusejp_2846_:
{
lean_object* v___x_2848_; lean_object* v___x_2849_; lean_object* v___x_2850_; 
v___x_2848_ = lean_st_ref_set(v___y_2829_, v___x_2847_);
v___x_2849_ = lean_box(0);
v___x_2850_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2850_, 0, v___x_2849_);
return v___x_2850_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__2___boxed(lean_object* v_snd_2854_, lean_object* v___y_2855_, lean_object* v___y_2856_, lean_object* v___y_2857_, lean_object* v___y_2858_, lean_object* v___y_2859_, lean_object* v___y_2860_, lean_object* v___y_2861_, lean_object* v___y_2862_, lean_object* v___y_2863_){
_start:
{
lean_object* v_res_2864_; 
v_res_2864_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__2(v_snd_2854_, v___y_2855_, v___y_2856_, v___y_2857_, v___y_2858_, v___y_2859_, v___y_2860_, v___y_2861_, v___y_2862_);
lean_dec(v___y_2862_);
lean_dec_ref(v___y_2861_);
lean_dec(v___y_2860_);
lean_dec_ref(v___y_2859_);
lean_dec(v___y_2858_);
lean_dec_ref(v___y_2857_);
lean_dec(v___y_2856_);
lean_dec_ref(v___y_2855_);
return v_res_2864_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__3(lean_object* v_inst_2865_, lean_object* v_toBind_2866_, lean_object* v___f_2867_, lean_object* v_toPure_2868_, lean_object* v_____s_2869_){
_start:
{
lean_object* v_fst_2870_; 
v_fst_2870_ = lean_ctor_get(v_____s_2869_, 0);
if (lean_obj_tag(v_fst_2870_) == 0)
{
lean_object* v_snd_2871_; lean_object* v___f_2872_; lean_object* v___x_2873_; lean_object* v___x_2874_; 
lean_dec(v_toPure_2868_);
v_snd_2871_ = lean_ctor_get(v_____s_2869_, 1);
lean_inc(v_snd_2871_);
lean_dec_ref(v_____s_2869_);
v___f_2872_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__2___boxed), 10, 1);
lean_closure_set(v___f_2872_, 0, v_snd_2871_);
v___x_2873_ = lean_apply_2(v_inst_2865_, lean_box(0), v___f_2872_);
v___x_2874_ = lean_apply_4(v_toBind_2866_, lean_box(0), lean_box(0), v___x_2873_, v___f_2867_);
return v___x_2874_;
}
else
{
lean_object* v_val_2875_; lean_object* v___x_2876_; 
lean_inc_ref(v_fst_2870_);
lean_dec_ref(v_____s_2869_);
lean_dec(v___f_2867_);
lean_dec(v_toBind_2866_);
lean_dec(v_inst_2865_);
v_val_2875_ = lean_ctor_get(v_fst_2870_, 0);
lean_inc(v_val_2875_);
lean_dec_ref_known(v_fst_2870_, 1);
v___x_2876_ = lean_apply_2(v_toPure_2868_, lean_box(0), v_val_2875_);
return v___x_2876_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__4(lean_object* v_toPure_2877_, lean_object* v_next_2878_, lean_object* v_G_2879_, lean_object* v_____do__lift_2880_){
_start:
{
if (lean_obj_tag(v_____do__lift_2880_) == 0)
{
lean_object* v_a_2881_; lean_object* v___x_2882_; 
lean_dec(v_G_2879_);
v_a_2881_ = lean_ctor_get(v_____do__lift_2880_, 0);
lean_inc(v_a_2881_);
lean_dec_ref_known(v_____do__lift_2880_, 1);
v___x_2882_ = lean_apply_2(v_toPure_2877_, lean_box(0), v_a_2881_);
return v___x_2882_;
}
else
{
lean_object* v_a_2883_; lean_object* v___x_2884_; lean_object* v___x_2885_; lean_object* v___x_2886_; 
lean_dec(v_toPure_2877_);
v_a_2883_ = lean_ctor_get(v_____do__lift_2880_, 0);
lean_inc(v_a_2883_);
lean_dec_ref_known(v_____do__lift_2880_, 1);
v___x_2884_ = lean_unsigned_to_nat(1u);
v___x_2885_ = lean_nat_add(v_next_2878_, v___x_2884_);
v___x_2886_ = lean_apply_4(v_G_2879_, v___x_2885_, v_a_2883_, lean_box(0), lean_box(0));
return v___x_2886_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__4___boxed(lean_object* v_toPure_2887_, lean_object* v_next_2888_, lean_object* v_G_2889_, lean_object* v_____do__lift_2890_){
_start:
{
lean_object* v_res_2891_; 
v_res_2891_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__4(v_toPure_2887_, v_next_2888_, v_G_2889_, v_____do__lift_2890_);
lean_dec(v_next_2888_);
return v_res_2891_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__5(lean_object* v_snd_2892_, lean_object* v_newHyp_2893_, lean_object* v___x_2894_, lean_object* v_toPure_2895_, lean_object* v_____r_2896_){
_start:
{
lean_object* v___x_2897_; lean_object* v___x_2898_; lean_object* v___x_2899_; lean_object* v___x_2900_; 
v___x_2897_ = lean_array_push(v_snd_2892_, v_newHyp_2893_);
v___x_2898_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2898_, 0, v___x_2894_);
lean_ctor_set(v___x_2898_, 1, v___x_2897_);
v___x_2899_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_2899_, 0, v___x_2898_);
v___x_2900_ = lean_apply_2(v_toPure_2895_, lean_box(0), v___x_2899_);
return v___x_2900_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__9(lean_object* v___f_2901_, lean_object* v_inst_2902_, lean_object* v_type_2903_, lean_object* v_toBind_2904_, lean_object* v___f_2905_, uint8_t v_____do__lift_2906_){
_start:
{
if (v_____do__lift_2906_ == 0)
{
lean_object* v___x_2907_; lean_object* v___x_2908_; 
lean_dec(v___f_2905_);
lean_dec(v_toBind_2904_);
lean_dec_ref(v_type_2903_);
lean_dec_ref(v_inst_2902_);
v___x_2907_ = lean_box(0);
v___x_2908_ = lean_apply_1(v___f_2901_, v___x_2907_);
return v___x_2908_;
}
else
{
lean_object* v_assertShared_2909_; lean_object* v___x_2910_; lean_object* v___x_2911_; 
lean_dec(v___f_2901_);
v_assertShared_2909_ = lean_ctor_get(v_inst_2902_, 1);
lean_inc(v_assertShared_2909_);
lean_dec_ref(v_inst_2902_);
v___x_2910_ = lean_apply_1(v_assertShared_2909_, v_type_2903_);
v___x_2911_ = lean_apply_4(v_toBind_2904_, lean_box(0), lean_box(0), v___x_2910_, v___f_2905_);
return v___x_2911_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__9___boxed(lean_object* v___f_2912_, lean_object* v_inst_2913_, lean_object* v_type_2914_, lean_object* v_toBind_2915_, lean_object* v___f_2916_, lean_object* v_____do__lift_2917_){
_start:
{
uint8_t v_____do__lift_2115__boxed_2918_; lean_object* v_res_2919_; 
v_____do__lift_2115__boxed_2918_ = lean_unbox(v_____do__lift_2917_);
v_res_2919_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__9(v___f_2912_, v_inst_2913_, v_type_2914_, v_toBind_2915_, v___f_2916_, v_____do__lift_2115__boxed_2918_);
return v_res_2919_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__6(lean_object* v_inst_2920_, lean_object* v_toBind_2921_, lean_object* v___f_2922_, lean_object* v_____r_2923_){
_start:
{
lean_object* v_isDebugEnabled_2924_; lean_object* v___x_2925_; 
v_isDebugEnabled_2924_ = lean_ctor_get(v_inst_2920_, 2);
lean_inc(v_isDebugEnabled_2924_);
lean_dec_ref(v_inst_2920_);
v___x_2925_ = lean_apply_4(v_toBind_2921_, lean_box(0), lean_box(0), v_isDebugEnabled_2924_, v___f_2922_);
return v___x_2925_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__8(lean_object* v_toPure_2926_, lean_object* v___x_2927_, lean_object* v_____do__lift_2928_, lean_object* v_____do__lift_2929_){
_start:
{
uint8_t v_hasTrace_2930_; 
v_hasTrace_2930_ = lean_ctor_get_uint8(v_____do__lift_2929_, sizeof(void*)*1);
if (v_hasTrace_2930_ == 0)
{
lean_object* v___x_2931_; lean_object* v___x_2932_; 
lean_dec(v___x_2927_);
v___x_2931_ = lean_box(v_hasTrace_2930_);
v___x_2932_ = lean_apply_2(v_toPure_2926_, lean_box(0), v___x_2931_);
return v___x_2932_;
}
else
{
lean_object* v___x_2933_; lean_object* v___x_2934_; uint8_t v___x_2935_; lean_object* v___x_2936_; lean_object* v___x_2937_; 
v___x_2933_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__13));
v___x_2934_ = l_Lean_Name_append(v___x_2933_, v___x_2927_);
v___x_2935_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_____do__lift_2928_, v_____do__lift_2929_, v___x_2934_);
lean_dec(v___x_2934_);
v___x_2936_ = lean_box(v___x_2935_);
v___x_2937_ = lean_apply_2(v_toPure_2926_, lean_box(0), v___x_2936_);
return v___x_2937_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__8___boxed(lean_object* v_toPure_2938_, lean_object* v___x_2939_, lean_object* v_____do__lift_2940_, lean_object* v_____do__lift_2941_){
_start:
{
lean_object* v_res_2942_; 
v_res_2942_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__8(v_toPure_2938_, v___x_2939_, v_____do__lift_2940_, v_____do__lift_2941_);
lean_dec_ref(v_____do__lift_2941_);
lean_dec_ref(v_____do__lift_2940_);
return v_res_2942_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__7(lean_object* v_toPure_2943_, lean_object* v___x_2944_, lean_object* v_toBind_2945_, lean_object* v_inst_2946_, lean_object* v_____do__lift_2947_){
_start:
{
lean_object* v___f_2948_; lean_object* v___x_2949_; 
v___f_2948_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__8___boxed), 4, 3);
lean_closure_set(v___f_2948_, 0, v_toPure_2943_);
lean_closure_set(v___f_2948_, 1, v___x_2944_);
lean_closure_set(v___f_2948_, 2, v_____do__lift_2947_);
v___x_2949_ = lean_apply_4(v_toBind_2945_, lean_box(0), lean_box(0), v_inst_2946_, v___f_2948_);
return v___x_2949_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__10(lean_object* v___f_2950_, lean_object* v_inst_2951_, lean_object* v___x_2952_, lean_object* v_type_2953_, lean_object* v_inst_2954_, lean_object* v_inst_2955_, lean_object* v_inst_2956_, lean_object* v___x_2957_, lean_object* v_toBind_2958_, lean_object* v___f_2959_, uint8_t v_____do__lift_2960_){
_start:
{
if (v_____do__lift_2960_ == 0)
{
lean_object* v___x_2961_; lean_object* v___x_2962_; 
lean_dec(v___f_2959_);
lean_dec(v_toBind_2958_);
lean_dec(v___x_2957_);
lean_dec(v_inst_2956_);
lean_dec_ref(v_inst_2955_);
lean_dec_ref(v_inst_2954_);
lean_dec_ref(v_type_2953_);
lean_dec_ref(v___x_2952_);
lean_dec_ref(v_inst_2951_);
v___x_2961_ = lean_box(0);
v___x_2962_ = lean_apply_1(v___f_2950_, v___x_2961_);
return v___x_2962_;
}
else
{
lean_object* v_toMonadRef_2963_; lean_object* v_type_2964_; lean_object* v___x_2965_; lean_object* v___x_2966_; lean_object* v___x_2967_; lean_object* v___x_2968_; lean_object* v___x_2969_; lean_object* v___x_2970_; lean_object* v___x_2971_; 
lean_dec(v___f_2950_);
v_toMonadRef_2963_ = lean_ctor_get(v_inst_2951_, 1);
lean_inc_ref(v_toMonadRef_2963_);
lean_dec_ref(v_inst_2951_);
v_type_2964_ = lean_ctor_get(v___x_2952_, 1);
lean_inc_ref(v_type_2964_);
lean_dec_ref(v___x_2952_);
v___x_2965_ = l_Lean_MessageData_ofExpr(v_type_2964_);
v___x_2966_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__5___closed__1);
v___x_2967_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2967_, 0, v___x_2965_);
lean_ctor_set(v___x_2967_, 1, v___x_2966_);
v___x_2968_ = l_Lean_MessageData_ofExpr(v_type_2953_);
v___x_2969_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_2969_, 0, v___x_2967_);
lean_ctor_set(v___x_2969_, 1, v___x_2968_);
v___x_2970_ = l_Lean_addTrace___redArg(v_inst_2954_, v_inst_2955_, v_toMonadRef_2963_, v_inst_2956_, v___x_2957_, v___x_2969_);
v___x_2971_ = lean_apply_4(v_toBind_2958_, lean_box(0), lean_box(0), v___x_2970_, v___f_2959_);
return v___x_2971_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__10___boxed(lean_object* v___f_2972_, lean_object* v_inst_2973_, lean_object* v___x_2974_, lean_object* v_type_2975_, lean_object* v_inst_2976_, lean_object* v_inst_2977_, lean_object* v_inst_2978_, lean_object* v___x_2979_, lean_object* v_toBind_2980_, lean_object* v___f_2981_, lean_object* v_____do__lift_2982_){
_start:
{
uint8_t v_____do__lift_2188__boxed_2983_; lean_object* v_res_2984_; 
v_____do__lift_2188__boxed_2983_ = lean_unbox(v_____do__lift_2982_);
v_res_2984_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__10(v___f_2972_, v_inst_2973_, v___x_2974_, v_type_2975_, v_inst_2976_, v_inst_2977_, v_inst_2978_, v___x_2979_, v_toBind_2980_, v___f_2981_, v_____do__lift_2188__boxed_2983_);
return v_res_2984_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__11(uint8_t v___x_2985_, lean_object* v_snd_2986_, lean_object* v_toPure_2987_, lean_object* v_____r_2988_){
_start:
{
lean_object* v___x_2989_; lean_object* v___x_2990_; lean_object* v___x_2991_; lean_object* v___x_2992_; lean_object* v___x_2993_; 
v___x_2989_ = lean_box(v___x_2985_);
v___x_2990_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_2990_, 0, v___x_2989_);
v___x_2991_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_2991_, 0, v___x_2990_);
lean_ctor_set(v___x_2991_, 1, v_snd_2986_);
v___x_2992_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_2992_, 0, v___x_2991_);
v___x_2993_ = lean_apply_2(v_toPure_2987_, lean_box(0), v___x_2992_);
return v___x_2993_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__11___boxed(lean_object* v___x_2994_, lean_object* v_snd_2995_, lean_object* v_toPure_2996_, lean_object* v_____r_2997_){
_start:
{
uint8_t v___x_2226__boxed_2998_; lean_object* v_res_2999_; 
v___x_2226__boxed_2998_ = lean_unbox(v___x_2994_);
v_res_2999_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__11(v___x_2226__boxed_2998_, v_snd_2995_, v_toPure_2996_, v_____r_2997_);
return v_res_2999_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__12(lean_object* v_inst_3000_, lean_object* v_value_3001_, lean_object* v_toBind_3002_, lean_object* v___f_3003_, lean_object* v_____do__lift_3004_){
_start:
{
lean_object* v___x_3005_; lean_object* v___x_3006_; 
v___x_3005_ = l_Lean_MVarId_assign___redArg(v_inst_3000_, v_____do__lift_3004_, v_value_3001_);
v___x_3006_ = lean_apply_4(v_toBind_3002_, lean_box(0), lean_box(0), v___x_3005_, v___f_3003_);
return v___x_3006_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__13(lean_object* v_snd_3007_, lean_object* v___x_3008_, lean_object* v_toPure_3009_, lean_object* v_inst_3010_, lean_object* v_toBind_3011_, lean_object* v_inst_3012_, lean_object* v_inst_3013_, lean_object* v_inst_3014_, lean_object* v_inst_3015_, lean_object* v___x_3016_, lean_object* v_inst_3017_, lean_object* v_inst_3018_, lean_object* v_inst_3019_, lean_object* v_newHyp_3020_){
_start:
{
lean_object* v_type_3021_; lean_object* v_value_3022_; uint8_t v___x_3023_; 
v_type_3021_ = lean_ctor_get(v_newHyp_3020_, 1);
v_value_3022_ = lean_ctor_get(v_newHyp_3020_, 2);
lean_inc_ref(v_type_3021_);
v___x_3023_ = l_Lean_Expr_isFalse(v_type_3021_);
if (v___x_3023_ == 0)
{
lean_object* v___f_3024_; lean_object* v___f_3025_; lean_object* v___f_3026_; lean_object* v___f_3027_; lean_object* v___f_3028_; lean_object* v___f_3029_; lean_object* v___f_3030_; uint8_t v___x_3038_; 
lean_dec_ref(v_inst_3019_);
lean_inc(v_toPure_3009_);
lean_inc(v___x_3008_);
lean_inc_ref(v_newHyp_3020_);
lean_inc(v_snd_3007_);
v___f_3024_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__5), 5, 4);
lean_closure_set(v___f_3024_, 0, v_snd_3007_);
lean_closure_set(v___f_3024_, 1, v_newHyp_3020_);
lean_closure_set(v___f_3024_, 2, v___x_3008_);
lean_closure_set(v___f_3024_, 3, v_toPure_3009_);
v___f_3025_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__10), 2, 1);
lean_closure_set(v___f_3025_, 0, v___f_3024_);
lean_inc_n(v_toBind_3011_, 3);
v___f_3026_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__7), 4, 3);
lean_closure_set(v___f_3026_, 0, v_inst_3010_);
lean_closure_set(v___f_3026_, 1, v_toBind_3011_);
lean_closure_set(v___f_3026_, 2, v___f_3025_);
lean_inc_ref(v___f_3026_);
v___f_3027_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__10), 2, 1);
lean_closure_set(v___f_3027_, 0, v___f_3026_);
lean_inc_ref(v_type_3021_);
lean_inc_ref(v_inst_3012_);
v___f_3028_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__9___boxed), 6, 5);
lean_closure_set(v___f_3028_, 0, v___f_3026_);
lean_closure_set(v___f_3028_, 1, v_inst_3012_);
lean_closure_set(v___f_3028_, 2, v_type_3021_);
lean_closure_set(v___f_3028_, 3, v_toBind_3011_);
lean_closure_set(v___f_3028_, 4, v___f_3027_);
v___f_3029_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__6), 4, 3);
lean_closure_set(v___f_3029_, 0, v_inst_3012_);
lean_closure_set(v___f_3029_, 1, v_toBind_3011_);
lean_closure_set(v___f_3029_, 2, v___f_3028_);
lean_inc_ref(v___f_3029_);
v___f_3030_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__10), 2, 1);
lean_closure_set(v___f_3030_, 0, v___f_3029_);
v___x_3038_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(v___x_3016_, v_newHyp_3020_);
if (v___x_3038_ == 0)
{
lean_inc_ref(v_type_3021_);
lean_dec_ref(v_newHyp_3020_);
lean_dec(v___x_3008_);
lean_dec(v_snd_3007_);
goto v___jp_3031_;
}
else
{
if (v___x_3023_ == 0)
{
lean_object* v___x_3039_; lean_object* v___x_3040_; 
lean_dec_ref(v___f_3030_);
lean_dec_ref(v___f_3029_);
lean_dec(v_inst_3018_);
lean_dec_ref(v_inst_3017_);
lean_dec_ref(v___x_3016_);
lean_dec_ref(v_inst_3015_);
lean_dec(v_inst_3014_);
lean_dec_ref(v_inst_3013_);
lean_dec(v_toBind_3011_);
v___x_3039_ = lean_box(0);
v___x_3040_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__5(v_snd_3007_, v_newHyp_3020_, v___x_3008_, v_toPure_3009_, v___x_3039_);
return v___x_3040_;
}
else
{
lean_inc_ref(v_type_3021_);
lean_dec_ref(v_newHyp_3020_);
lean_dec(v___x_3008_);
lean_dec(v_snd_3007_);
goto v___jp_3031_;
}
}
v___jp_3031_:
{
lean_object* v_getInheritedTraceOptions_3032_; lean_object* v___x_3033_; lean_object* v___f_3034_; lean_object* v___f_3035_; lean_object* v___x_3036_; lean_object* v___x_3037_; 
v_getInheritedTraceOptions_3032_ = lean_ctor_get(v_inst_3013_, 2);
lean_inc(v_getInheritedTraceOptions_3032_);
v___x_3033_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
lean_inc_n(v_toBind_3011_, 3);
v___f_3034_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__7), 5, 4);
lean_closure_set(v___f_3034_, 0, v_toPure_3009_);
lean_closure_set(v___f_3034_, 1, v___x_3033_);
lean_closure_set(v___f_3034_, 2, v_toBind_3011_);
lean_closure_set(v___f_3034_, 3, v_inst_3014_);
v___f_3035_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__10___boxed), 11, 10);
lean_closure_set(v___f_3035_, 0, v___f_3029_);
lean_closure_set(v___f_3035_, 1, v_inst_3015_);
lean_closure_set(v___f_3035_, 2, v___x_3016_);
lean_closure_set(v___f_3035_, 3, v_type_3021_);
lean_closure_set(v___f_3035_, 4, v_inst_3017_);
lean_closure_set(v___f_3035_, 5, v_inst_3013_);
lean_closure_set(v___f_3035_, 6, v_inst_3018_);
lean_closure_set(v___f_3035_, 7, v___x_3033_);
lean_closure_set(v___f_3035_, 8, v_toBind_3011_);
lean_closure_set(v___f_3035_, 9, v___f_3030_);
v___x_3036_ = lean_apply_4(v_toBind_3011_, lean_box(0), lean_box(0), v_getInheritedTraceOptions_3032_, v___f_3034_);
v___x_3037_ = lean_apply_4(v_toBind_3011_, lean_box(0), lean_box(0), v___x_3036_, v___f_3035_);
return v___x_3037_;
}
}
else
{
lean_object* v___x_3041_; lean_object* v___f_3042_; lean_object* v___f_3043_; lean_object* v___x_3044_; lean_object* v___x_3045_; lean_object* v___x_3046_; 
lean_inc_ref(v_value_3022_);
lean_dec_ref(v_newHyp_3020_);
lean_dec(v_inst_3018_);
lean_dec_ref(v_inst_3017_);
lean_dec_ref(v___x_3016_);
lean_dec_ref(v_inst_3015_);
lean_dec(v_inst_3014_);
lean_dec_ref(v_inst_3013_);
lean_dec_ref(v_inst_3012_);
lean_dec(v___x_3008_);
v___x_3041_ = lean_box(v___x_3023_);
v___f_3042_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__11___boxed), 4, 3);
lean_closure_set(v___f_3042_, 0, v___x_3041_);
lean_closure_set(v___f_3042_, 1, v_snd_3007_);
lean_closure_set(v___f_3042_, 2, v_toPure_3009_);
lean_inc(v_toBind_3011_);
v___f_3043_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__12), 5, 4);
lean_closure_set(v___f_3043_, 0, v_inst_3019_);
lean_closure_set(v___f_3043_, 1, v_value_3022_);
lean_closure_set(v___f_3043_, 2, v_toBind_3011_);
lean_closure_set(v___f_3043_, 3, v___f_3042_);
v___x_3044_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal___boxed), 9, 0);
v___x_3045_ = lean_apply_2(v_inst_3010_, lean_box(0), v___x_3044_);
v___x_3046_ = lean_apply_4(v_toBind_3011_, lean_box(0), lean_box(0), v___x_3045_, v___f_3043_);
return v___x_3046_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__14(lean_object* v___x_3047_, lean_object* v_toPure_3048_, lean_object* v_hyps_3049_, lean_object* v___x_3050_, lean_object* v_inst_3051_, lean_object* v_toBind_3052_, lean_object* v_inst_3053_, lean_object* v_inst_3054_, lean_object* v_inst_3055_, lean_object* v_inst_3056_, lean_object* v_inst_3057_, lean_object* v_inst_3058_, lean_object* v_inst_3059_, lean_object* v_f_3060_, lean_object* v___f_3061_, lean_object* v_next_3062_, lean_object* v_acc_3063_, lean_object* v_h_3064_, lean_object* v_G_3065_){
_start:
{
uint8_t v___x_3066_; 
v___x_3066_ = lean_nat_dec_lt(v_next_3062_, v___x_3047_);
if (v___x_3066_ == 0)
{
lean_object* v___x_3067_; 
lean_dec(v_G_3065_);
lean_dec(v_next_3062_);
lean_dec(v___f_3061_);
lean_dec(v_f_3060_);
lean_dec_ref(v_inst_3059_);
lean_dec(v_inst_3058_);
lean_dec_ref(v_inst_3057_);
lean_dec_ref(v_inst_3056_);
lean_dec(v_inst_3055_);
lean_dec_ref(v_inst_3054_);
lean_dec_ref(v_inst_3053_);
lean_dec(v_toBind_3052_);
lean_dec(v_inst_3051_);
lean_dec(v___x_3050_);
v___x_3067_ = lean_apply_2(v_toPure_3048_, lean_box(0), v_acc_3063_);
return v___x_3067_;
}
else
{
lean_object* v_snd_3068_; lean_object* v___f_3069_; lean_object* v___x_3070_; lean_object* v___f_3071_; lean_object* v___x_3072_; lean_object* v___x_3073_; lean_object* v___x_3074_; lean_object* v___x_3075_; 
v_snd_3068_ = lean_ctor_get(v_acc_3063_, 1);
lean_inc(v_snd_3068_);
lean_dec_ref(v_acc_3063_);
lean_inc(v_next_3062_);
lean_inc(v_toPure_3048_);
v___f_3069_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__4___boxed), 4, 3);
lean_closure_set(v___f_3069_, 0, v_toPure_3048_);
lean_closure_set(v___f_3069_, 1, v_next_3062_);
lean_closure_set(v___f_3069_, 2, v_G_3065_);
v___x_3070_ = lean_array_fget_borrowed(v_hyps_3049_, v_next_3062_);
lean_inc_n(v___x_3070_, 2);
lean_inc_n(v_toBind_3052_, 3);
v___f_3071_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__13), 14, 13);
lean_closure_set(v___f_3071_, 0, v_snd_3068_);
lean_closure_set(v___f_3071_, 1, v___x_3050_);
lean_closure_set(v___f_3071_, 2, v_toPure_3048_);
lean_closure_set(v___f_3071_, 3, v_inst_3051_);
lean_closure_set(v___f_3071_, 4, v_toBind_3052_);
lean_closure_set(v___f_3071_, 5, v_inst_3053_);
lean_closure_set(v___f_3071_, 6, v_inst_3054_);
lean_closure_set(v___f_3071_, 7, v_inst_3055_);
lean_closure_set(v___f_3071_, 8, v_inst_3056_);
lean_closure_set(v___f_3071_, 9, v___x_3070_);
lean_closure_set(v___f_3071_, 10, v_inst_3057_);
lean_closure_set(v___f_3071_, 11, v_inst_3058_);
lean_closure_set(v___f_3071_, 12, v_inst_3059_);
v___x_3072_ = lean_apply_2(v_f_3060_, v_next_3062_, v___x_3070_);
v___x_3073_ = lean_apply_4(v_toBind_3052_, lean_box(0), lean_box(0), v___x_3072_, v___f_3071_);
v___x_3074_ = lean_apply_4(v_toBind_3052_, lean_box(0), lean_box(0), v___x_3073_, v___f_3061_);
v___x_3075_ = lean_apply_4(v_toBind_3052_, lean_box(0), lean_box(0), v___x_3074_, v___f_3069_);
return v___x_3075_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__14___boxed(lean_object** _args){
lean_object* v___x_3076_ = _args[0];
lean_object* v_toPure_3077_ = _args[1];
lean_object* v_hyps_3078_ = _args[2];
lean_object* v___x_3079_ = _args[3];
lean_object* v_inst_3080_ = _args[4];
lean_object* v_toBind_3081_ = _args[5];
lean_object* v_inst_3082_ = _args[6];
lean_object* v_inst_3083_ = _args[7];
lean_object* v_inst_3084_ = _args[8];
lean_object* v_inst_3085_ = _args[9];
lean_object* v_inst_3086_ = _args[10];
lean_object* v_inst_3087_ = _args[11];
lean_object* v_inst_3088_ = _args[12];
lean_object* v_f_3089_ = _args[13];
lean_object* v___f_3090_ = _args[14];
lean_object* v_next_3091_ = _args[15];
lean_object* v_acc_3092_ = _args[16];
lean_object* v_h_3093_ = _args[17];
lean_object* v_G_3094_ = _args[18];
_start:
{
lean_object* v_res_3095_; 
v_res_3095_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__14(v___x_3076_, v_toPure_3077_, v_hyps_3078_, v___x_3079_, v_inst_3080_, v_toBind_3081_, v_inst_3082_, v_inst_3083_, v_inst_3084_, v_inst_3085_, v_inst_3086_, v_inst_3087_, v_inst_3088_, v_f_3089_, v___f_3090_, v_next_3091_, v_acc_3092_, v_h_3093_, v_G_3094_);
lean_dec_ref(v_hyps_3078_);
lean_dec(v___x_3076_);
return v_res_3095_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__15(lean_object* v_toPure_3096_, lean_object* v_inst_3097_, lean_object* v_toBind_3098_, lean_object* v_inst_3099_, lean_object* v_inst_3100_, lean_object* v_inst_3101_, lean_object* v_inst_3102_, lean_object* v_inst_3103_, lean_object* v_inst_3104_, lean_object* v_inst_3105_, lean_object* v_f_3106_, lean_object* v___f_3107_, lean_object* v___f_3108_, lean_object* v_hyps_3109_){
_start:
{
lean_object* v___x_3110_; lean_object* v_newHyps_3111_; lean_object* v___x_3112_; lean_object* v___x_3113_; lean_object* v___f_3114_; lean_object* v___x_3115_; lean_object* v___x_3116_; lean_object* v___x_3117_; 
v___x_3110_ = lean_array_get_size(v_hyps_3109_);
v_newHyps_3111_ = lean_mk_empty_array_with_capacity(v___x_3110_);
v___x_3112_ = lean_unsigned_to_nat(0u);
v___x_3113_ = lean_box(0);
lean_inc(v_toBind_3098_);
v___f_3114_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__14___boxed), 19, 15);
lean_closure_set(v___f_3114_, 0, v___x_3110_);
lean_closure_set(v___f_3114_, 1, v_toPure_3096_);
lean_closure_set(v___f_3114_, 2, v_hyps_3109_);
lean_closure_set(v___f_3114_, 3, v___x_3113_);
lean_closure_set(v___f_3114_, 4, v_inst_3097_);
lean_closure_set(v___f_3114_, 5, v_toBind_3098_);
lean_closure_set(v___f_3114_, 6, v_inst_3099_);
lean_closure_set(v___f_3114_, 7, v_inst_3100_);
lean_closure_set(v___f_3114_, 8, v_inst_3101_);
lean_closure_set(v___f_3114_, 9, v_inst_3102_);
lean_closure_set(v___f_3114_, 10, v_inst_3103_);
lean_closure_set(v___f_3114_, 11, v_inst_3104_);
lean_closure_set(v___f_3114_, 12, v_inst_3105_);
lean_closure_set(v___f_3114_, 13, v_f_3106_);
lean_closure_set(v___f_3114_, 14, v___f_3107_);
v___x_3115_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3115_, 0, v___x_3113_);
lean_ctor_set(v___x_3115_, 1, v_newHyps_3111_);
v___x_3116_ = l_WellFounded_opaqueFix_u2083___redArg(v___f_3114_, v___x_3112_, v___x_3115_, lean_box(0));
v___x_3117_ = lean_apply_4(v_toBind_3098_, lean_box(0), lean_box(0), v___x_3116_, v___f_3108_);
return v___x_3117_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg(lean_object* v_inst_3118_, lean_object* v_inst_3119_, lean_object* v_inst_3120_, lean_object* v_inst_3121_, lean_object* v_inst_3122_, lean_object* v_inst_3123_, lean_object* v_inst_3124_, lean_object* v_inst_3125_, lean_object* v_f_3126_){
_start:
{
lean_object* v_toApplicative_3127_; lean_object* v_toBind_3128_; lean_object* v_toPure_3129_; lean_object* v___x_3130_; lean_object* v___x_3131_; lean_object* v___f_3132_; lean_object* v___f_3133_; lean_object* v___f_3134_; lean_object* v___f_3135_; lean_object* v___x_3136_; 
v_toApplicative_3127_ = lean_ctor_get(v_inst_3118_, 0);
v_toBind_3128_ = lean_ctor_get(v_inst_3118_, 1);
lean_inc_n(v_toBind_3128_, 3);
v_toPure_3129_ = lean_ctor_get(v_toApplicative_3127_, 1);
lean_inc_n(v_toPure_3129_, 4);
v___x_3130_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed), 9, 0);
lean_inc_n(v_inst_3119_, 2);
v___x_3131_ = lean_apply_2(v_inst_3119_, lean_box(0), v___x_3130_);
v___f_3132_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__0), 2, 1);
lean_closure_set(v___f_3132_, 0, v_toPure_3129_);
v___f_3133_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__1), 2, 1);
lean_closure_set(v___f_3133_, 0, v_toPure_3129_);
v___f_3134_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__3), 5, 4);
lean_closure_set(v___f_3134_, 0, v_inst_3119_);
lean_closure_set(v___f_3134_, 1, v_toBind_3128_);
lean_closure_set(v___f_3134_, 2, v___f_3133_);
lean_closure_set(v___f_3134_, 3, v_toPure_3129_);
v___f_3135_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__15), 14, 13);
lean_closure_set(v___f_3135_, 0, v_toPure_3129_);
lean_closure_set(v___f_3135_, 1, v_inst_3119_);
lean_closure_set(v___f_3135_, 2, v_toBind_3128_);
lean_closure_set(v___f_3135_, 3, v_inst_3125_);
lean_closure_set(v___f_3135_, 4, v_inst_3122_);
lean_closure_set(v___f_3135_, 5, v_inst_3123_);
lean_closure_set(v___f_3135_, 6, v_inst_3120_);
lean_closure_set(v___f_3135_, 7, v_inst_3118_);
lean_closure_set(v___f_3135_, 8, v_inst_3124_);
lean_closure_set(v___f_3135_, 9, v_inst_3121_);
lean_closure_set(v___f_3135_, 10, v_f_3126_);
lean_closure_set(v___f_3135_, 11, v___f_3132_);
lean_closure_set(v___f_3135_, 12, v___f_3134_);
v___x_3136_ = lean_apply_4(v_toBind_3128_, lean_box(0), lean_box(0), v___x_3131_, v___f_3135_);
return v___x_3136_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps(lean_object* v_m_3137_, lean_object* v_inst_3138_, lean_object* v_inst_3139_, lean_object* v_inst_3140_, lean_object* v_inst_3141_, lean_object* v_inst_3142_, lean_object* v_inst_3143_, lean_object* v_inst_3144_, lean_object* v_inst_3145_, lean_object* v_f_3146_){
_start:
{
lean_object* v_toApplicative_3147_; lean_object* v_toBind_3148_; lean_object* v_toPure_3149_; lean_object* v___x_3150_; lean_object* v___x_3151_; lean_object* v___f_3152_; lean_object* v___f_3153_; lean_object* v___f_3154_; lean_object* v___f_3155_; lean_object* v___x_3156_; 
v_toApplicative_3147_ = lean_ctor_get(v_inst_3138_, 0);
v_toBind_3148_ = lean_ctor_get(v_inst_3138_, 1);
lean_inc_n(v_toBind_3148_, 3);
v_toPure_3149_ = lean_ctor_get(v_toApplicative_3147_, 1);
lean_inc_n(v_toPure_3149_, 4);
v___x_3150_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed), 9, 0);
lean_inc_n(v_inst_3139_, 2);
v___x_3151_ = lean_apply_2(v_inst_3139_, lean_box(0), v___x_3150_);
v___f_3152_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__0), 2, 1);
lean_closure_set(v___f_3152_, 0, v_toPure_3149_);
v___f_3153_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__1), 2, 1);
lean_closure_set(v___f_3153_, 0, v_toPure_3149_);
v___f_3154_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__3), 5, 4);
lean_closure_set(v___f_3154_, 0, v_inst_3139_);
lean_closure_set(v___f_3154_, 1, v_toBind_3148_);
lean_closure_set(v___f_3154_, 2, v___f_3153_);
lean_closure_set(v___f_3154_, 3, v_toPure_3149_);
v___f_3155_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__15), 14, 13);
lean_closure_set(v___f_3155_, 0, v_toPure_3149_);
lean_closure_set(v___f_3155_, 1, v_inst_3139_);
lean_closure_set(v___f_3155_, 2, v_toBind_3148_);
lean_closure_set(v___f_3155_, 3, v_inst_3145_);
lean_closure_set(v___f_3155_, 4, v_inst_3142_);
lean_closure_set(v___f_3155_, 5, v_inst_3143_);
lean_closure_set(v___f_3155_, 6, v_inst_3140_);
lean_closure_set(v___f_3155_, 7, v_inst_3138_);
lean_closure_set(v___f_3155_, 8, v_inst_3144_);
lean_closure_set(v___f_3155_, 9, v_inst_3141_);
lean_closure_set(v___f_3155_, 10, v_f_3146_);
lean_closure_set(v___f_3155_, 11, v___f_3152_);
lean_closure_set(v___f_3155_, 12, v___f_3154_);
v___x_3156_ = lean_apply_4(v_toBind_3148_, lean_box(0), lean_box(0), v___x_3151_, v___f_3155_);
return v___x_3156_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__17(lean_object* v_snd_3157_, lean_object* v___x_3158_, lean_object* v_toPure_3159_, lean_object* v_inst_3160_, lean_object* v_toBind_3161_, lean_object* v_inst_3162_, lean_object* v_inst_3163_, lean_object* v_inst_3164_, lean_object* v___x_3165_, lean_object* v_inst_3166_, lean_object* v_inst_3167_, lean_object* v_inst_3168_, lean_object* v_inst_3169_, lean_object* v_newHyp_3170_){
_start:
{
lean_object* v_type_3171_; lean_object* v_value_3172_; uint8_t v___x_3173_; 
v_type_3171_ = lean_ctor_get(v_newHyp_3170_, 1);
v_value_3172_ = lean_ctor_get(v_newHyp_3170_, 2);
lean_inc_ref(v_type_3171_);
v___x_3173_ = l_Lean_Expr_isFalse(v_type_3171_);
if (v___x_3173_ == 0)
{
lean_object* v___f_3174_; lean_object* v___f_3175_; lean_object* v___f_3176_; lean_object* v___f_3177_; lean_object* v___f_3178_; lean_object* v___f_3179_; lean_object* v___f_3180_; uint8_t v___x_3188_; 
lean_dec_ref(v_inst_3169_);
lean_inc(v_toPure_3159_);
lean_inc(v___x_3158_);
lean_inc_ref(v_newHyp_3170_);
lean_inc(v_snd_3157_);
v___f_3174_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__5), 5, 4);
lean_closure_set(v___f_3174_, 0, v_snd_3157_);
lean_closure_set(v___f_3174_, 1, v_newHyp_3170_);
lean_closure_set(v___f_3174_, 2, v___x_3158_);
lean_closure_set(v___f_3174_, 3, v_toPure_3159_);
v___f_3175_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__10), 2, 1);
lean_closure_set(v___f_3175_, 0, v___f_3174_);
lean_inc_n(v_toBind_3161_, 3);
v___f_3176_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__7), 4, 3);
lean_closure_set(v___f_3176_, 0, v_inst_3160_);
lean_closure_set(v___f_3176_, 1, v_toBind_3161_);
lean_closure_set(v___f_3176_, 2, v___f_3175_);
lean_inc_ref(v___f_3176_);
v___f_3177_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__10), 2, 1);
lean_closure_set(v___f_3177_, 0, v___f_3176_);
lean_inc_ref(v_type_3171_);
lean_inc_ref(v_inst_3162_);
v___f_3178_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__9___boxed), 6, 5);
lean_closure_set(v___f_3178_, 0, v___f_3176_);
lean_closure_set(v___f_3178_, 1, v_inst_3162_);
lean_closure_set(v___f_3178_, 2, v_type_3171_);
lean_closure_set(v___f_3178_, 3, v_toBind_3161_);
lean_closure_set(v___f_3178_, 4, v___f_3177_);
v___f_3179_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__6), 4, 3);
lean_closure_set(v___f_3179_, 0, v_inst_3162_);
lean_closure_set(v___f_3179_, 1, v_toBind_3161_);
lean_closure_set(v___f_3179_, 2, v___f_3178_);
lean_inc_ref(v___f_3179_);
v___f_3180_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_flatMapHyps___redArg___lam__10), 2, 1);
lean_closure_set(v___f_3180_, 0, v___f_3179_);
v___x_3188_ = l_Lean_Meta_Tactic_BVDecide_Normalize_instBEqHyp_beq(v___x_3165_, v_newHyp_3170_);
if (v___x_3188_ == 0)
{
lean_inc_ref(v_type_3171_);
lean_dec_ref(v_newHyp_3170_);
lean_dec(v___x_3158_);
lean_dec(v_snd_3157_);
goto v___jp_3181_;
}
else
{
if (v___x_3173_ == 0)
{
lean_object* v___x_3189_; lean_object* v___x_3190_; 
lean_dec_ref(v___f_3180_);
lean_dec_ref(v___f_3179_);
lean_dec(v_inst_3168_);
lean_dec(v_inst_3167_);
lean_dec_ref(v_inst_3166_);
lean_dec_ref(v___x_3165_);
lean_dec_ref(v_inst_3164_);
lean_dec_ref(v_inst_3163_);
lean_dec(v_toBind_3161_);
v___x_3189_ = lean_box(0);
v___x_3190_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__5(v_snd_3157_, v_newHyp_3170_, v___x_3158_, v_toPure_3159_, v___x_3189_);
return v___x_3190_;
}
else
{
lean_inc_ref(v_type_3171_);
lean_dec_ref(v_newHyp_3170_);
lean_dec(v___x_3158_);
lean_dec(v_snd_3157_);
goto v___jp_3181_;
}
}
v___jp_3181_:
{
lean_object* v_getInheritedTraceOptions_3182_; lean_object* v___x_3183_; lean_object* v___f_3184_; lean_object* v___f_3185_; lean_object* v___x_3186_; lean_object* v___x_3187_; 
v_getInheritedTraceOptions_3182_ = lean_ctor_get(v_inst_3163_, 2);
lean_inc(v_getInheritedTraceOptions_3182_);
v___x_3183_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
lean_inc_n(v_toBind_3161_, 3);
v___f_3184_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__10___boxed), 11, 10);
lean_closure_set(v___f_3184_, 0, v___f_3179_);
lean_closure_set(v___f_3184_, 1, v_inst_3164_);
lean_closure_set(v___f_3184_, 2, v___x_3165_);
lean_closure_set(v___f_3184_, 3, v_type_3171_);
lean_closure_set(v___f_3184_, 4, v_inst_3166_);
lean_closure_set(v___f_3184_, 5, v_inst_3163_);
lean_closure_set(v___f_3184_, 6, v_inst_3167_);
lean_closure_set(v___f_3184_, 7, v___x_3183_);
lean_closure_set(v___f_3184_, 8, v_toBind_3161_);
lean_closure_set(v___f_3184_, 9, v___f_3180_);
v___f_3185_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__7), 5, 4);
lean_closure_set(v___f_3185_, 0, v_toPure_3159_);
lean_closure_set(v___f_3185_, 1, v___x_3183_);
lean_closure_set(v___f_3185_, 2, v_toBind_3161_);
lean_closure_set(v___f_3185_, 3, v_inst_3168_);
v___x_3186_ = lean_apply_4(v_toBind_3161_, lean_box(0), lean_box(0), v_getInheritedTraceOptions_3182_, v___f_3185_);
v___x_3187_ = lean_apply_4(v_toBind_3161_, lean_box(0), lean_box(0), v___x_3186_, v___f_3184_);
return v___x_3187_;
}
}
else
{
lean_object* v___x_3191_; lean_object* v___f_3192_; lean_object* v___f_3193_; lean_object* v___x_3194_; lean_object* v___x_3195_; lean_object* v___x_3196_; 
lean_inc_ref(v_value_3172_);
lean_dec_ref(v_newHyp_3170_);
lean_dec(v_inst_3168_);
lean_dec(v_inst_3167_);
lean_dec_ref(v_inst_3166_);
lean_dec_ref(v___x_3165_);
lean_dec_ref(v_inst_3164_);
lean_dec_ref(v_inst_3163_);
lean_dec_ref(v_inst_3162_);
lean_dec(v___x_3158_);
v___x_3191_ = lean_box(v___x_3173_);
v___f_3192_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__11___boxed), 4, 3);
lean_closure_set(v___f_3192_, 0, v___x_3191_);
lean_closure_set(v___f_3192_, 1, v_snd_3157_);
lean_closure_set(v___f_3192_, 2, v_toPure_3159_);
lean_inc(v_toBind_3161_);
v___f_3193_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__12), 5, 4);
lean_closure_set(v___f_3193_, 0, v_inst_3169_);
lean_closure_set(v___f_3193_, 1, v_value_3172_);
lean_closure_set(v___f_3193_, 2, v_toBind_3161_);
lean_closure_set(v___f_3193_, 3, v___f_3192_);
v___x_3194_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getGoal___boxed), 9, 0);
v___x_3195_ = lean_apply_2(v_inst_3160_, lean_box(0), v___x_3194_);
v___x_3196_ = lean_apply_4(v_toBind_3161_, lean_box(0), lean_box(0), v___x_3195_, v___f_3193_);
return v___x_3196_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__0(lean_object* v___x_3197_, lean_object* v_toPure_3198_, lean_object* v_hyps_3199_, lean_object* v___x_3200_, lean_object* v_inst_3201_, lean_object* v_toBind_3202_, lean_object* v_inst_3203_, lean_object* v_inst_3204_, lean_object* v_inst_3205_, lean_object* v_inst_3206_, lean_object* v_inst_3207_, lean_object* v_inst_3208_, lean_object* v_inst_3209_, lean_object* v_f_3210_, lean_object* v___f_3211_, lean_object* v_next_3212_, lean_object* v_acc_3213_, lean_object* v_h_3214_, lean_object* v_G_3215_){
_start:
{
uint8_t v___x_3216_; 
v___x_3216_ = lean_nat_dec_lt(v_next_3212_, v___x_3197_);
if (v___x_3216_ == 0)
{
lean_object* v___x_3217_; 
lean_dec(v_G_3215_);
lean_dec(v_next_3212_);
lean_dec(v___f_3211_);
lean_dec(v_f_3210_);
lean_dec_ref(v_inst_3209_);
lean_dec(v_inst_3208_);
lean_dec(v_inst_3207_);
lean_dec_ref(v_inst_3206_);
lean_dec_ref(v_inst_3205_);
lean_dec_ref(v_inst_3204_);
lean_dec_ref(v_inst_3203_);
lean_dec(v_toBind_3202_);
lean_dec(v_inst_3201_);
lean_dec(v___x_3200_);
v___x_3217_ = lean_apply_2(v_toPure_3198_, lean_box(0), v_acc_3213_);
return v___x_3217_;
}
else
{
lean_object* v_snd_3218_; lean_object* v___f_3219_; lean_object* v___x_3220_; lean_object* v___f_3221_; lean_object* v___x_3222_; lean_object* v___x_3223_; lean_object* v___x_3224_; lean_object* v___x_3225_; 
v_snd_3218_ = lean_ctor_get(v_acc_3213_, 1);
lean_inc(v_snd_3218_);
lean_dec_ref(v_acc_3213_);
lean_inc(v_next_3212_);
lean_inc(v_toPure_3198_);
v___f_3219_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__4___boxed), 4, 3);
lean_closure_set(v___f_3219_, 0, v_toPure_3198_);
lean_closure_set(v___f_3219_, 1, v_next_3212_);
lean_closure_set(v___f_3219_, 2, v_G_3215_);
v___x_3220_ = lean_array_fget_borrowed(v_hyps_3199_, v_next_3212_);
lean_dec(v_next_3212_);
lean_inc_n(v___x_3220_, 2);
lean_inc_n(v_toBind_3202_, 3);
v___f_3221_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__17), 14, 13);
lean_closure_set(v___f_3221_, 0, v_snd_3218_);
lean_closure_set(v___f_3221_, 1, v___x_3200_);
lean_closure_set(v___f_3221_, 2, v_toPure_3198_);
lean_closure_set(v___f_3221_, 3, v_inst_3201_);
lean_closure_set(v___f_3221_, 4, v_toBind_3202_);
lean_closure_set(v___f_3221_, 5, v_inst_3203_);
lean_closure_set(v___f_3221_, 6, v_inst_3204_);
lean_closure_set(v___f_3221_, 7, v_inst_3205_);
lean_closure_set(v___f_3221_, 8, v___x_3220_);
lean_closure_set(v___f_3221_, 9, v_inst_3206_);
lean_closure_set(v___f_3221_, 10, v_inst_3207_);
lean_closure_set(v___f_3221_, 11, v_inst_3208_);
lean_closure_set(v___f_3221_, 12, v_inst_3209_);
v___x_3222_ = lean_apply_1(v_f_3210_, v___x_3220_);
v___x_3223_ = lean_apply_4(v_toBind_3202_, lean_box(0), lean_box(0), v___x_3222_, v___f_3221_);
v___x_3224_ = lean_apply_4(v_toBind_3202_, lean_box(0), lean_box(0), v___x_3223_, v___f_3211_);
v___x_3225_ = lean_apply_4(v_toBind_3202_, lean_box(0), lean_box(0), v___x_3224_, v___f_3219_);
return v___x_3225_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__0___boxed(lean_object** _args){
lean_object* v___x_3226_ = _args[0];
lean_object* v_toPure_3227_ = _args[1];
lean_object* v_hyps_3228_ = _args[2];
lean_object* v___x_3229_ = _args[3];
lean_object* v_inst_3230_ = _args[4];
lean_object* v_toBind_3231_ = _args[5];
lean_object* v_inst_3232_ = _args[6];
lean_object* v_inst_3233_ = _args[7];
lean_object* v_inst_3234_ = _args[8];
lean_object* v_inst_3235_ = _args[9];
lean_object* v_inst_3236_ = _args[10];
lean_object* v_inst_3237_ = _args[11];
lean_object* v_inst_3238_ = _args[12];
lean_object* v_f_3239_ = _args[13];
lean_object* v___f_3240_ = _args[14];
lean_object* v_next_3241_ = _args[15];
lean_object* v_acc_3242_ = _args[16];
lean_object* v_h_3243_ = _args[17];
lean_object* v_G_3244_ = _args[18];
_start:
{
lean_object* v_res_3245_; 
v_res_3245_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__0(v___x_3226_, v_toPure_3227_, v_hyps_3228_, v___x_3229_, v_inst_3230_, v_toBind_3231_, v_inst_3232_, v_inst_3233_, v_inst_3234_, v_inst_3235_, v_inst_3236_, v_inst_3237_, v_inst_3238_, v_f_3239_, v___f_3240_, v_next_3241_, v_acc_3242_, v_h_3243_, v_G_3244_);
lean_dec_ref(v_hyps_3228_);
lean_dec(v___x_3226_);
return v_res_3245_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__1(lean_object* v_toPure_3246_, lean_object* v_inst_3247_, lean_object* v_toBind_3248_, lean_object* v_inst_3249_, lean_object* v_inst_3250_, lean_object* v_inst_3251_, lean_object* v_inst_3252_, lean_object* v_inst_3253_, lean_object* v_inst_3254_, lean_object* v_inst_3255_, lean_object* v_f_3256_, lean_object* v___f_3257_, lean_object* v___f_3258_, lean_object* v_hyps_3259_){
_start:
{
lean_object* v___x_3260_; lean_object* v_newHyps_3261_; lean_object* v___x_3262_; lean_object* v___x_3263_; lean_object* v___f_3264_; lean_object* v___x_3265_; lean_object* v___x_3266_; lean_object* v___x_3267_; 
v___x_3260_ = lean_array_get_size(v_hyps_3259_);
v_newHyps_3261_ = lean_mk_empty_array_with_capacity(v___x_3260_);
v___x_3262_ = lean_unsigned_to_nat(0u);
v___x_3263_ = lean_box(0);
lean_inc(v_toBind_3248_);
v___f_3264_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__0___boxed), 19, 15);
lean_closure_set(v___f_3264_, 0, v___x_3260_);
lean_closure_set(v___f_3264_, 1, v_toPure_3246_);
lean_closure_set(v___f_3264_, 2, v_hyps_3259_);
lean_closure_set(v___f_3264_, 3, v___x_3263_);
lean_closure_set(v___f_3264_, 4, v_inst_3247_);
lean_closure_set(v___f_3264_, 5, v_toBind_3248_);
lean_closure_set(v___f_3264_, 6, v_inst_3249_);
lean_closure_set(v___f_3264_, 7, v_inst_3250_);
lean_closure_set(v___f_3264_, 8, v_inst_3251_);
lean_closure_set(v___f_3264_, 9, v_inst_3252_);
lean_closure_set(v___f_3264_, 10, v_inst_3253_);
lean_closure_set(v___f_3264_, 11, v_inst_3254_);
lean_closure_set(v___f_3264_, 12, v_inst_3255_);
lean_closure_set(v___f_3264_, 13, v_f_3256_);
lean_closure_set(v___f_3264_, 14, v___f_3257_);
v___x_3265_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3265_, 0, v___x_3263_);
lean_ctor_set(v___x_3265_, 1, v_newHyps_3261_);
v___x_3266_ = l_WellFounded_opaqueFix_u2083___redArg(v___f_3264_, v___x_3262_, v___x_3265_, lean_box(0));
v___x_3267_ = lean_apply_4(v_toBind_3248_, lean_box(0), lean_box(0), v___x_3266_, v___f_3258_);
return v___x_3267_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg(lean_object* v_inst_3268_, lean_object* v_inst_3269_, lean_object* v_inst_3270_, lean_object* v_inst_3271_, lean_object* v_inst_3272_, lean_object* v_inst_3273_, lean_object* v_inst_3274_, lean_object* v_inst_3275_, lean_object* v_f_3276_){
_start:
{
lean_object* v_toApplicative_3277_; lean_object* v_toBind_3278_; lean_object* v_toPure_3279_; lean_object* v___x_3280_; lean_object* v___x_3281_; lean_object* v___f_3282_; lean_object* v___f_3283_; lean_object* v___f_3284_; lean_object* v___f_3285_; lean_object* v___x_3286_; 
v_toApplicative_3277_ = lean_ctor_get(v_inst_3268_, 0);
v_toBind_3278_ = lean_ctor_get(v_inst_3268_, 1);
lean_inc_n(v_toBind_3278_, 3);
v_toPure_3279_ = lean_ctor_get(v_toApplicative_3277_, 1);
lean_inc_n(v_toPure_3279_, 4);
v___x_3280_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed), 9, 0);
lean_inc_n(v_inst_3269_, 2);
v___x_3281_ = lean_apply_2(v_inst_3269_, lean_box(0), v___x_3280_);
v___f_3282_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__1), 2, 1);
lean_closure_set(v___f_3282_, 0, v_toPure_3279_);
v___f_3283_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__3), 5, 4);
lean_closure_set(v___f_3283_, 0, v_inst_3269_);
lean_closure_set(v___f_3283_, 1, v_toBind_3278_);
lean_closure_set(v___f_3283_, 2, v___f_3282_);
lean_closure_set(v___f_3283_, 3, v_toPure_3279_);
v___f_3284_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__0), 2, 1);
lean_closure_set(v___f_3284_, 0, v_toPure_3279_);
v___f_3285_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__1), 14, 13);
lean_closure_set(v___f_3285_, 0, v_toPure_3279_);
lean_closure_set(v___f_3285_, 1, v_inst_3269_);
lean_closure_set(v___f_3285_, 2, v_toBind_3278_);
lean_closure_set(v___f_3285_, 3, v_inst_3275_);
lean_closure_set(v___f_3285_, 4, v_inst_3272_);
lean_closure_set(v___f_3285_, 5, v_inst_3270_);
lean_closure_set(v___f_3285_, 6, v_inst_3268_);
lean_closure_set(v___f_3285_, 7, v_inst_3274_);
lean_closure_set(v___f_3285_, 8, v_inst_3273_);
lean_closure_set(v___f_3285_, 9, v_inst_3271_);
lean_closure_set(v___f_3285_, 10, v_f_3276_);
lean_closure_set(v___f_3285_, 11, v___f_3284_);
lean_closure_set(v___f_3285_, 12, v___f_3283_);
v___x_3286_ = lean_apply_4(v_toBind_3278_, lean_box(0), lean_box(0), v___x_3281_, v___f_3285_);
return v___x_3286_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps(lean_object* v_m_3287_, lean_object* v_inst_3288_, lean_object* v_inst_3289_, lean_object* v_inst_3290_, lean_object* v_inst_3291_, lean_object* v_inst_3292_, lean_object* v_inst_3293_, lean_object* v_inst_3294_, lean_object* v_inst_3295_, lean_object* v_f_3296_){
_start:
{
lean_object* v_toApplicative_3297_; lean_object* v_toBind_3298_; lean_object* v_toPure_3299_; lean_object* v___x_3300_; lean_object* v___x_3301_; lean_object* v___f_3302_; lean_object* v___f_3303_; lean_object* v___f_3304_; lean_object* v___f_3305_; lean_object* v___x_3306_; 
v_toApplicative_3297_ = lean_ctor_get(v_inst_3288_, 0);
v_toBind_3298_ = lean_ctor_get(v_inst_3288_, 1);
lean_inc_n(v_toBind_3298_, 3);
v_toPure_3299_ = lean_ctor_get(v_toApplicative_3297_, 1);
lean_inc_n(v_toPure_3299_, 4);
v___x_3300_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed), 9, 0);
lean_inc_n(v_inst_3289_, 2);
v___x_3301_ = lean_apply_2(v_inst_3289_, lean_box(0), v___x_3300_);
v___f_3302_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__1), 2, 1);
lean_closure_set(v___f_3302_, 0, v_toPure_3299_);
v___f_3303_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__3), 5, 4);
lean_closure_set(v___f_3303_, 0, v_inst_3289_);
lean_closure_set(v___f_3303_, 1, v_toBind_3298_);
lean_closure_set(v___f_3303_, 2, v___f_3302_);
lean_closure_set(v___f_3303_, 3, v_toPure_3299_);
v___f_3304_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapIdxHyps___redArg___lam__0), 2, 1);
lean_closure_set(v___f_3304_, 0, v_toPure_3299_);
v___f_3305_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_mapHyps___redArg___lam__1), 14, 13);
lean_closure_set(v___f_3305_, 0, v_toPure_3299_);
lean_closure_set(v___f_3305_, 1, v_inst_3289_);
lean_closure_set(v___f_3305_, 2, v_toBind_3298_);
lean_closure_set(v___f_3305_, 3, v_inst_3295_);
lean_closure_set(v___f_3305_, 4, v_inst_3292_);
lean_closure_set(v___f_3305_, 5, v_inst_3290_);
lean_closure_set(v___f_3305_, 6, v_inst_3288_);
lean_closure_set(v___f_3305_, 7, v_inst_3294_);
lean_closure_set(v___f_3305_, 8, v_inst_3293_);
lean_closure_set(v___f_3305_, 9, v_inst_3291_);
lean_closure_set(v___f_3305_, 10, v_f_3296_);
lean_closure_set(v___f_3305_, 11, v___f_3304_);
lean_closure_set(v___f_3305_, 12, v___f_3303_);
v___x_3306_ = lean_apply_4(v_toBind_3298_, lean_box(0), lean_box(0), v___x_3301_, v___f_3305_);
return v___x_3306_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg___lam__0(lean_object* v_f_3307_, lean_object* v_x_3308_, lean_object* v___y_3309_){
_start:
{
lean_object* v___x_3310_; 
v___x_3310_ = lean_apply_1(v_f_3307_, v___y_3309_);
return v___x_3310_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg___lam__1(lean_object* v_toApplicative_3311_, lean_object* v_inst_3312_, lean_object* v___f_3313_, lean_object* v_hyps_3314_){
_start:
{
lean_object* v___x_3315_; lean_object* v___x_3316_; lean_object* v___x_3317_; uint8_t v___x_3318_; 
v___x_3315_ = lean_unsigned_to_nat(0u);
v___x_3316_ = lean_array_get_size(v_hyps_3314_);
v___x_3317_ = lean_box(0);
v___x_3318_ = lean_nat_dec_lt(v___x_3315_, v___x_3316_);
if (v___x_3318_ == 0)
{
lean_object* v_toPure_3319_; lean_object* v___x_3320_; 
lean_dec_ref(v_hyps_3314_);
lean_dec(v___f_3313_);
lean_dec_ref(v_inst_3312_);
v_toPure_3319_ = lean_ctor_get(v_toApplicative_3311_, 1);
lean_inc(v_toPure_3319_);
lean_dec_ref(v_toApplicative_3311_);
v___x_3320_ = lean_apply_2(v_toPure_3319_, lean_box(0), v___x_3317_);
return v___x_3320_;
}
else
{
uint8_t v___x_3321_; 
v___x_3321_ = lean_nat_dec_le(v___x_3316_, v___x_3316_);
if (v___x_3321_ == 0)
{
if (v___x_3318_ == 0)
{
lean_object* v_toPure_3322_; lean_object* v___x_3323_; 
lean_dec_ref(v_hyps_3314_);
lean_dec(v___f_3313_);
lean_dec_ref(v_inst_3312_);
v_toPure_3322_ = lean_ctor_get(v_toApplicative_3311_, 1);
lean_inc(v_toPure_3322_);
lean_dec_ref(v_toApplicative_3311_);
v___x_3323_ = lean_apply_2(v_toPure_3322_, lean_box(0), v___x_3317_);
return v___x_3323_;
}
else
{
size_t v___x_3324_; size_t v___x_3325_; lean_object* v___x_3326_; 
lean_dec_ref(v_toApplicative_3311_);
v___x_3324_ = ((size_t)0ULL);
v___x_3325_ = lean_usize_of_nat(v___x_3316_);
v___x_3326_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v_inst_3312_, v___f_3313_, v_hyps_3314_, v___x_3324_, v___x_3325_, v___x_3317_);
return v___x_3326_;
}
}
else
{
size_t v___x_3327_; size_t v___x_3328_; lean_object* v___x_3329_; 
lean_dec_ref(v_toApplicative_3311_);
v___x_3327_ = ((size_t)0ULL);
v___x_3328_ = lean_usize_of_nat(v___x_3316_);
v___x_3329_ = l___private_Init_Data_Array_Basic_0__Array_foldlMUnsafe_fold(lean_box(0), lean_box(0), lean_box(0), v_inst_3312_, v___f_3313_, v_hyps_3314_, v___x_3327_, v___x_3328_, v___x_3317_);
return v___x_3329_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg(lean_object* v_inst_3330_, lean_object* v_inst_3331_, lean_object* v_f_3332_){
_start:
{
lean_object* v_toApplicative_3333_; lean_object* v_toBind_3334_; lean_object* v___f_3335_; lean_object* v___f_3336_; lean_object* v___x_3337_; lean_object* v___x_3338_; lean_object* v___x_3339_; 
v_toApplicative_3333_ = lean_ctor_get(v_inst_3330_, 0);
lean_inc_ref(v_toApplicative_3333_);
v_toBind_3334_ = lean_ctor_get(v_inst_3330_, 1);
lean_inc(v_toBind_3334_);
v___f_3335_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg___lam__0), 3, 1);
lean_closure_set(v___f_3335_, 0, v_f_3332_);
v___f_3336_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg___lam__1), 4, 3);
lean_closure_set(v___f_3336_, 0, v_toApplicative_3333_);
lean_closure_set(v___f_3336_, 1, v_inst_3330_);
lean_closure_set(v___f_3336_, 2, v___f_3335_);
v___x_3337_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed), 9, 0);
v___x_3338_ = lean_apply_2(v_inst_3331_, lean_box(0), v___x_3337_);
v___x_3339_ = lean_apply_4(v_toBind_3334_, lean_box(0), lean_box(0), v___x_3338_, v___f_3336_);
return v___x_3339_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps(lean_object* v_m_3340_, lean_object* v_inst_3341_, lean_object* v_inst_3342_, lean_object* v_inst_3343_, lean_object* v_f_3344_){
_start:
{
lean_object* v_toApplicative_3345_; lean_object* v_toBind_3346_; lean_object* v___f_3347_; lean_object* v___f_3348_; lean_object* v___x_3349_; lean_object* v___x_3350_; lean_object* v___x_3351_; 
v_toApplicative_3345_ = lean_ctor_get(v_inst_3341_, 0);
lean_inc_ref(v_toApplicative_3345_);
v_toBind_3346_ = lean_ctor_get(v_inst_3341_, 1);
lean_inc(v_toBind_3346_);
v___f_3347_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg___lam__0), 3, 1);
lean_closure_set(v___f_3347_, 0, v_f_3344_);
v___f_3348_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___redArg___lam__1), 4, 3);
lean_closure_set(v___f_3348_, 0, v_toApplicative_3345_);
lean_closure_set(v___f_3348_, 1, v_inst_3341_);
lean_closure_set(v___f_3348_, 2, v___f_3347_);
v___x_3349_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_getHyps___boxed), 9, 0);
v___x_3350_ = lean_apply_2(v_inst_3342_, lean_box(0), v___x_3349_);
v___x_3351_ = lean_apply_4(v_toBind_3346_, lean_box(0), lean_box(0), v___x_3350_, v___f_3348_);
return v___x_3351_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps___boxed(lean_object* v_m_3352_, lean_object* v_inst_3353_, lean_object* v_inst_3354_, lean_object* v_inst_3355_, lean_object* v_f_3356_){
_start:
{
lean_object* v_res_3357_; 
v_res_3357_ = l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_forHyps(v_m_3352_, v_inst_3353_, v_inst_3354_, v_inst_3355_, v_f_3356_);
lean_dec_ref(v_inst_3355_);
return v_res_3357_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__1(void){
_start:
{
lean_object* v___x_3359_; lean_object* v___x_3360_; 
v___x_3359_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__0));
v___x_3360_ = l_Lean_stringToMessageData(v___x_3359_);
return v___x_3360_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0(lean_object* v_name_3361_, lean_object* v_x_3362_, lean_object* v___y_3363_, lean_object* v___y_3364_, lean_object* v___y_3365_, lean_object* v___y_3366_, lean_object* v___y_3367_, lean_object* v___y_3368_, lean_object* v___y_3369_, lean_object* v___y_3370_){
_start:
{
lean_object* v___x_3372_; lean_object* v___x_3373_; lean_object* v___x_3374_; lean_object* v___x_3375_; 
v___x_3372_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___closed__1);
v___x_3373_ = l_Lean_MessageData_ofName(v_name_3361_);
v___x_3374_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_3374_, 0, v___x_3372_);
lean_ctor_set(v___x_3374_, 1, v___x_3373_);
v___x_3375_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3375_, 0, v___x_3374_);
return v___x_3375_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___boxed(lean_object* v_name_3376_, lean_object* v_x_3377_, lean_object* v___y_3378_, lean_object* v___y_3379_, lean_object* v___y_3380_, lean_object* v___y_3381_, lean_object* v___y_3382_, lean_object* v___y_3383_, lean_object* v___y_3384_, lean_object* v___y_3385_, lean_object* v___y_3386_){
_start:
{
lean_object* v_res_3387_; 
v_res_3387_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0(v_name_3376_, v_x_3377_, v___y_3378_, v___y_3379_, v___y_3380_, v___y_3381_, v___y_3382_, v___y_3383_, v___y_3384_, v___y_3385_);
lean_dec(v___y_3385_);
lean_dec_ref(v___y_3384_);
lean_dec(v___y_3383_);
lean_dec_ref(v___y_3382_);
lean_dec(v___y_3381_);
lean_dec_ref(v___y_3380_);
lean_dec(v___y_3379_);
lean_dec_ref(v___y_3378_);
lean_dec_ref(v_x_3377_);
return v_res_3387_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__0(void){
_start:
{
lean_object* v___x_3388_; 
v___x_3388_ = l_instMonadExceptOfEIO(lean_box(0));
return v___x_3388_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__1(void){
_start:
{
lean_object* v___x_3389_; lean_object* v___x_3390_; 
v___x_3389_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__0, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__0_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__0);
v___x_3390_ = l_Lean_instMonadAlwaysExceptStateRefT_x27___redArg(v___x_3389_);
return v___x_3390_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__2(void){
_start:
{
lean_object* v___x_3391_; lean_object* v___x_3392_; 
v___x_3391_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__1);
v___x_3392_ = l_Lean_instMonadAlwaysExceptReaderT___redArg(v___x_3391_);
return v___x_3392_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__3(void){
_start:
{
lean_object* v___x_3393_; lean_object* v___x_3394_; 
v___x_3393_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__2, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__2);
v___x_3394_ = l_Lean_instMonadAlwaysExceptStateRefT_x27___redArg(v___x_3393_);
return v___x_3394_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__4(void){
_start:
{
lean_object* v___x_3395_; lean_object* v___x_3396_; 
v___x_3395_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__3, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__3);
v___x_3396_ = l_Lean_instMonadAlwaysExceptReaderT___redArg(v___x_3395_);
return v___x_3396_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__5(void){
_start:
{
lean_object* v___x_3397_; lean_object* v___x_3398_; 
v___x_3397_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__4, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__4_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__4);
v___x_3398_ = l_Lean_instMonadAlwaysExceptStateRefT_x27___redArg(v___x_3397_);
return v___x_3398_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__6(void){
_start:
{
lean_object* v___x_3399_; lean_object* v___x_3400_; 
v___x_3399_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__5, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__5_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__5);
v___x_3400_ = l_Lean_instMonadAlwaysExceptReaderT___redArg(v___x_3399_);
return v___x_3400_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__7(void){
_start:
{
lean_object* v___x_3401_; lean_object* v___x_3402_; 
v___x_3401_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__6, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__6);
v___x_3402_ = l_Lean_instMonadAlwaysExceptStateRefT_x27___redArg(v___x_3401_);
return v___x_3402_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__8(void){
_start:
{
lean_object* v___x_3403_; lean_object* v___x_3404_; 
v___x_3403_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__7, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__7);
v___x_3404_ = l_Lean_instMonadAlwaysExceptReaderT___redArg(v___x_3403_);
return v___x_3404_;
}
}
static double _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__11(void){
_start:
{
lean_object* v___x_3407_; double v___x_3408_; 
v___x_3407_ = lean_unsigned_to_nat(1000000000u);
v___x_3408_ = lean_float_of_nat(v___x_3407_);
return v___x_3408_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run(lean_object* v_pass_3409_, lean_object* v_a_3410_, lean_object* v_a_3411_, lean_object* v_a_3412_, lean_object* v_a_3413_, lean_object* v_a_3414_, lean_object* v_a_3415_, lean_object* v_a_3416_, lean_object* v_a_3417_){
_start:
{
lean_object* v___x_3419_; lean_object* v_toApplicative_3420_; lean_object* v_toFunctor_3421_; lean_object* v_toSeq_3422_; lean_object* v_toSeqLeft_3423_; lean_object* v_toSeqRight_3424_; lean_object* v___f_3425_; lean_object* v___f_3426_; lean_object* v___f_3427_; lean_object* v___f_3428_; lean_object* v___x_3429_; lean_object* v___f_3430_; lean_object* v___f_3431_; lean_object* v___f_3432_; lean_object* v___x_3433_; lean_object* v___x_3434_; lean_object* v___x_3435_; lean_object* v_toApplicative_3436_; lean_object* v___x_3438_; uint8_t v_isShared_3439_; uint8_t v_isSharedCheck_3577_; 
v___x_3419_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__1);
v_toApplicative_3420_ = lean_ctor_get(v___x_3419_, 0);
v_toFunctor_3421_ = lean_ctor_get(v_toApplicative_3420_, 0);
v_toSeq_3422_ = lean_ctor_get(v_toApplicative_3420_, 2);
v_toSeqLeft_3423_ = lean_ctor_get(v_toApplicative_3420_, 3);
v_toSeqRight_3424_ = lean_ctor_get(v_toApplicative_3420_, 4);
v___f_3425_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__2));
v___f_3426_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__3));
lean_inc_ref_n(v_toFunctor_3421_, 2);
v___f_3427_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_3427_, 0, v_toFunctor_3421_);
v___f_3428_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_3428_, 0, v_toFunctor_3421_);
v___x_3429_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3429_, 0, v___f_3427_);
lean_ctor_set(v___x_3429_, 1, v___f_3428_);
lean_inc(v_toSeqRight_3424_);
v___f_3430_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_3430_, 0, v_toSeqRight_3424_);
lean_inc(v_toSeqLeft_3423_);
v___f_3431_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_3431_, 0, v_toSeqLeft_3423_);
lean_inc(v_toSeq_3422_);
v___f_3432_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_3432_, 0, v_toSeq_3422_);
v___x_3433_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v___x_3433_, 0, v___x_3429_);
lean_ctor_set(v___x_3433_, 1, v___f_3425_);
lean_ctor_set(v___x_3433_, 2, v___f_3432_);
lean_ctor_set(v___x_3433_, 3, v___f_3431_);
lean_ctor_set(v___x_3433_, 4, v___f_3430_);
v___x_3434_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3434_, 0, v___x_3433_);
lean_ctor_set(v___x_3434_, 1, v___f_3426_);
v___x_3435_ = l_StateRefT_x27_instMonad___redArg(v___x_3434_);
v_toApplicative_3436_ = lean_ctor_get(v___x_3435_, 0);
v_isSharedCheck_3577_ = !lean_is_exclusive(v___x_3435_);
if (v_isSharedCheck_3577_ == 0)
{
lean_object* v_unused_3578_; 
v_unused_3578_ = lean_ctor_get(v___x_3435_, 1);
lean_dec(v_unused_3578_);
v___x_3438_ = v___x_3435_;
v_isShared_3439_ = v_isSharedCheck_3577_;
goto v_resetjp_3437_;
}
else
{
lean_inc(v_toApplicative_3436_);
lean_dec(v___x_3435_);
v___x_3438_ = lean_box(0);
v_isShared_3439_ = v_isSharedCheck_3577_;
goto v_resetjp_3437_;
}
v_resetjp_3437_:
{
lean_object* v_toFunctor_3440_; lean_object* v_toSeq_3441_; lean_object* v_toSeqLeft_3442_; lean_object* v_toSeqRight_3443_; lean_object* v___x_3445_; uint8_t v_isShared_3446_; uint8_t v_isSharedCheck_3575_; 
v_toFunctor_3440_ = lean_ctor_get(v_toApplicative_3436_, 0);
v_toSeq_3441_ = lean_ctor_get(v_toApplicative_3436_, 2);
v_toSeqLeft_3442_ = lean_ctor_get(v_toApplicative_3436_, 3);
v_toSeqRight_3443_ = lean_ctor_get(v_toApplicative_3436_, 4);
v_isSharedCheck_3575_ = !lean_is_exclusive(v_toApplicative_3436_);
if (v_isSharedCheck_3575_ == 0)
{
lean_object* v_unused_3576_; 
v_unused_3576_ = lean_ctor_get(v_toApplicative_3436_, 1);
lean_dec(v_unused_3576_);
v___x_3445_ = v_toApplicative_3436_;
v_isShared_3446_ = v_isSharedCheck_3575_;
goto v_resetjp_3444_;
}
else
{
lean_inc(v_toSeqRight_3443_);
lean_inc(v_toSeqLeft_3442_);
lean_inc(v_toSeq_3441_);
lean_inc(v_toFunctor_3440_);
lean_dec(v_toApplicative_3436_);
v___x_3445_ = lean_box(0);
v_isShared_3446_ = v_isSharedCheck_3575_;
goto v_resetjp_3444_;
}
v_resetjp_3444_:
{
lean_object* v___f_3447_; lean_object* v___f_3448_; lean_object* v___f_3449_; lean_object* v___f_3450_; lean_object* v___x_3451_; lean_object* v___f_3452_; lean_object* v___f_3453_; lean_object* v___f_3454_; lean_object* v___x_3456_; 
v___f_3447_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__4));
v___f_3448_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_run___redArg___closed__5));
lean_inc_ref(v_toFunctor_3440_);
v___f_3449_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__0), 6, 1);
lean_closure_set(v___f_3449_, 0, v_toFunctor_3440_);
v___f_3450_ = lean_alloc_closure((void*)(l_ReaderT_instFunctorOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_3450_, 0, v_toFunctor_3440_);
v___x_3451_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3451_, 0, v___f_3449_);
lean_ctor_set(v___x_3451_, 1, v___f_3450_);
v___f_3452_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__1), 6, 1);
lean_closure_set(v___f_3452_, 0, v_toSeqRight_3443_);
v___f_3453_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__3), 6, 1);
lean_closure_set(v___f_3453_, 0, v_toSeqLeft_3442_);
v___f_3454_ = lean_alloc_closure((void*)(l_ReaderT_instApplicativeOfMonad___redArg___lam__4), 6, 1);
lean_closure_set(v___f_3454_, 0, v_toSeq_3441_);
if (v_isShared_3446_ == 0)
{
lean_ctor_set(v___x_3445_, 4, v___f_3452_);
lean_ctor_set(v___x_3445_, 3, v___f_3453_);
lean_ctor_set(v___x_3445_, 2, v___f_3454_);
lean_ctor_set(v___x_3445_, 1, v___f_3447_);
lean_ctor_set(v___x_3445_, 0, v___x_3451_);
v___x_3456_ = v___x_3445_;
goto v_reusejp_3455_;
}
else
{
lean_object* v_reuseFailAlloc_3574_; 
v_reuseFailAlloc_3574_ = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(v_reuseFailAlloc_3574_, 0, v___x_3451_);
lean_ctor_set(v_reuseFailAlloc_3574_, 1, v___f_3447_);
lean_ctor_set(v_reuseFailAlloc_3574_, 2, v___f_3454_);
lean_ctor_set(v_reuseFailAlloc_3574_, 3, v___f_3453_);
lean_ctor_set(v_reuseFailAlloc_3574_, 4, v___f_3452_);
v___x_3456_ = v_reuseFailAlloc_3574_;
goto v_reusejp_3455_;
}
v_reusejp_3455_:
{
lean_object* v___x_3458_; 
if (v_isShared_3439_ == 0)
{
lean_ctor_set(v___x_3438_, 1, v___f_3448_);
lean_ctor_set(v___x_3438_, 0, v___x_3456_);
v___x_3458_ = v___x_3438_;
goto v_reusejp_3457_;
}
else
{
lean_object* v_reuseFailAlloc_3573_; 
v_reuseFailAlloc_3573_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3573_, 0, v___x_3456_);
lean_ctor_set(v_reuseFailAlloc_3573_, 1, v___f_3448_);
v___x_3458_ = v_reuseFailAlloc_3573_;
goto v_reusejp_3457_;
}
v_reusejp_3457_:
{
lean_object* v___x_3459_; lean_object* v___x_3460_; lean_object* v___x_3461_; lean_object* v___x_3462_; lean_object* v___x_3463_; lean_object* v___x_3464_; lean_object* v_toMonadRef_3465_; lean_object* v___x_3466_; lean_object* v_options_3467_; uint8_t v_hasTrace_3468_; 
v___x_3459_ = l_StateRefT_x27_instMonad___redArg(v___x_3458_);
v___x_3460_ = l_ReaderT_instMonad___redArg(v___x_3459_);
v___x_3461_ = l_StateRefT_x27_instMonad___redArg(v___x_3460_);
v___x_3462_ = l_ReaderT_instMonad___redArg(v___x_3461_);
v___x_3463_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__7);
v___x_3464_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__22, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__22_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__22);
v_toMonadRef_3465_ = lean_ctor_get(v___x_3464_, 0);
v___x_3466_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__8, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__8_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__8);
v_options_3467_ = lean_ctor_get(v_a_3416_, 2);
v_hasTrace_3468_ = lean_ctor_get_uint8(v_options_3467_, sizeof(void*)*1);
if (v_hasTrace_3468_ == 0)
{
lean_object* v_run_x27_3469_; lean_object* v___x_3470_; 
lean_dec_ref(v___x_3462_);
v_run_x27_3469_ = lean_ctor_get(v_pass_3409_, 1);
lean_inc_ref(v_run_x27_3469_);
lean_dec_ref(v_pass_3409_);
lean_inc(v_a_3417_);
lean_inc_ref(v_a_3416_);
lean_inc(v_a_3415_);
lean_inc_ref(v_a_3414_);
lean_inc(v_a_3413_);
lean_inc_ref(v_a_3412_);
lean_inc(v_a_3411_);
lean_inc_ref(v_a_3410_);
v___x_3470_ = lean_apply_9(v_run_x27_3469_, v_a_3410_, v_a_3411_, v_a_3412_, v_a_3413_, v_a_3414_, v_a_3415_, v_a_3416_, v_a_3417_, lean_box(0));
return v___x_3470_;
}
else
{
lean_object* v_name_3471_; lean_object* v_run_x27_3472_; lean_object* v___x_3474_; uint8_t v_isShared_3475_; uint8_t v_isSharedCheck_3572_; 
v_name_3471_ = lean_ctor_get(v_pass_3409_, 0);
v_run_x27_3472_ = lean_ctor_get(v_pass_3409_, 1);
v_isSharedCheck_3572_ = !lean_is_exclusive(v_pass_3409_);
if (v_isSharedCheck_3572_ == 0)
{
v___x_3474_ = v_pass_3409_;
v_isShared_3475_ = v_isSharedCheck_3572_;
goto v_resetjp_3473_;
}
else
{
lean_inc(v_run_x27_3472_);
lean_inc(v_name_3471_);
lean_dec(v_pass_3409_);
v___x_3474_ = lean_box(0);
v_isShared_3475_ = v_isSharedCheck_3572_;
goto v_resetjp_3473_;
}
v_resetjp_3473_:
{
lean_object* v_inheritedTraceOptions_3476_; lean_object* v___f_3477_; lean_object* v___f_3478_; lean_object* v___f_3479_; lean_object* v___x_3480_; lean_object* v___x_3481_; lean_object* v___x_3482_; uint8_t v___x_3483_; lean_object* v___y_3485_; lean_object* v___y_3486_; lean_object* v_a_3487_; lean_object* v___y_3503_; lean_object* v___y_3504_; lean_object* v_a_3505_; 
v_inheritedTraceOptions_3476_ = lean_ctor_get(v_a_3416_, 13);
v___f_3477_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___boxed), 11, 1);
lean_closure_set(v___f_3477_, 0, v_name_3471_);
v___f_3478_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__26, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__26_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__26);
v___f_3479_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__9));
v___x_3480_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
v___x_3481_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__10));
v___x_3482_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14);
v___x_3483_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_3476_, v_options_3467_, v___x_3482_);
if (v___x_3483_ == 0)
{
lean_object* v___x_3567_; lean_object* v___x_3568_; lean_object* v___x_3569_; uint8_t v___x_3570_; 
v___x_3567_ = l_Lean_KVMap_instValueBool;
v___x_3568_ = l_Lean_trace_profiler;
v___x_3569_ = l_Lean_Option_get___redArg(v___x_3567_, v_options_3467_, v___x_3568_);
v___x_3570_ = lean_unbox(v___x_3569_);
lean_dec(v___x_3569_);
if (v___x_3570_ == 0)
{
lean_object* v___x_3571_; 
lean_dec_ref(v___f_3477_);
lean_del_object(v___x_3474_);
lean_dec_ref(v___x_3462_);
lean_inc(v_a_3417_);
lean_inc_ref(v_a_3416_);
lean_inc(v_a_3415_);
lean_inc_ref(v_a_3414_);
lean_inc(v_a_3413_);
lean_inc_ref(v_a_3412_);
lean_inc(v_a_3411_);
lean_inc_ref(v_a_3410_);
v___x_3571_ = lean_apply_9(v_run_x27_3472_, v_a_3410_, v_a_3411_, v_a_3412_, v_a_3413_, v_a_3414_, v_a_3415_, v_a_3416_, v_a_3417_, lean_box(0));
return v___x_3571_;
}
else
{
goto v___jp_3515_;
}
}
else
{
goto v___jp_3515_;
}
v___jp_3484_:
{
lean_object* v___x_3488_; double v___x_3489_; double v___x_3490_; double v___x_3491_; double v___x_3492_; double v___x_3493_; lean_object* v___x_3494_; lean_object* v___x_3495_; lean_object* v___x_3497_; 
v___x_3488_ = lean_io_mono_nanos_now();
v___x_3489_ = lean_float_of_nat(v___y_3486_);
v___x_3490_ = lean_float_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__11, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__11_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__11);
v___x_3491_ = lean_float_div(v___x_3489_, v___x_3490_);
v___x_3492_ = lean_float_of_nat(v___x_3488_);
v___x_3493_ = lean_float_div(v___x_3492_, v___x_3490_);
v___x_3494_ = lean_box_float(v___x_3491_);
v___x_3495_ = lean_box_float(v___x_3493_);
if (v_isShared_3475_ == 0)
{
lean_ctor_set(v___x_3474_, 1, v___x_3495_);
lean_ctor_set(v___x_3474_, 0, v___x_3494_);
v___x_3497_ = v___x_3474_;
goto v_reusejp_3496_;
}
else
{
lean_object* v_reuseFailAlloc_3501_; 
v_reuseFailAlloc_3501_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v_reuseFailAlloc_3501_, 0, v___x_3494_);
lean_ctor_set(v_reuseFailAlloc_3501_, 1, v___x_3495_);
v___x_3497_ = v_reuseFailAlloc_3501_;
goto v_reusejp_3496_;
}
v_reusejp_3496_:
{
lean_object* v___x_3498_; lean_object* v___x_16945__overap_3499_; lean_object* v___x_3500_; 
v___x_3498_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3498_, 0, v_a_3487_);
lean_ctor_set(v___x_3498_, 1, v___x_3497_);
lean_inc_ref(v_toMonadRef_3465_);
v___x_16945__overap_3499_ = l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback(lean_box(0), lean_box(0), v___x_3462_, v___x_3463_, v_toMonadRef_3465_, v___f_3478_, lean_box(0), v___x_3466_, v___f_3479_, v___x_3480_, v_hasTrace_3468_, v___x_3481_, v_options_3467_, v___x_3483_, v___y_3485_, v___f_3477_, v___x_3498_);
lean_inc(v_a_3417_);
lean_inc_ref(v_a_3416_);
lean_inc(v_a_3415_);
lean_inc_ref(v_a_3414_);
lean_inc(v_a_3413_);
lean_inc_ref(v_a_3412_);
lean_inc(v_a_3411_);
lean_inc_ref(v_a_3410_);
v___x_3500_ = lean_apply_9(v___x_16945__overap_3499_, v_a_3410_, v_a_3411_, v_a_3412_, v_a_3413_, v_a_3414_, v_a_3415_, v_a_3416_, v_a_3417_, lean_box(0));
return v___x_3500_;
}
}
v___jp_3502_:
{
lean_object* v___x_3506_; double v___x_3507_; double v___x_3508_; lean_object* v___x_3509_; lean_object* v___x_3510_; lean_object* v___x_3511_; lean_object* v___x_3512_; lean_object* v___x_16966__overap_3513_; lean_object* v___x_3514_; 
v___x_3506_ = lean_io_get_num_heartbeats();
v___x_3507_ = lean_float_of_nat(v___y_3504_);
v___x_3508_ = lean_float_of_nat(v___x_3506_);
v___x_3509_ = lean_box_float(v___x_3507_);
v___x_3510_ = lean_box_float(v___x_3508_);
v___x_3511_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3511_, 0, v___x_3509_);
lean_ctor_set(v___x_3511_, 1, v___x_3510_);
v___x_3512_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3512_, 0, v_a_3505_);
lean_ctor_set(v___x_3512_, 1, v___x_3511_);
lean_inc_ref(v_toMonadRef_3465_);
v___x_16966__overap_3513_ = l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback(lean_box(0), lean_box(0), v___x_3462_, v___x_3463_, v_toMonadRef_3465_, v___f_3478_, lean_box(0), v___x_3466_, v___f_3479_, v___x_3480_, v_hasTrace_3468_, v___x_3481_, v_options_3467_, v___x_3483_, v___y_3503_, v___f_3477_, v___x_3512_);
lean_inc(v_a_3417_);
lean_inc_ref(v_a_3416_);
lean_inc(v_a_3415_);
lean_inc_ref(v_a_3414_);
lean_inc(v_a_3413_);
lean_inc_ref(v_a_3412_);
lean_inc(v_a_3411_);
lean_inc_ref(v_a_3410_);
v___x_3514_ = lean_apply_9(v___x_16966__overap_3513_, v_a_3410_, v_a_3411_, v_a_3412_, v_a_3413_, v_a_3414_, v_a_3415_, v_a_3416_, v_a_3417_, lean_box(0));
return v___x_3514_;
}
v___jp_3515_:
{
lean_object* v___x_16922__overap_3516_; lean_object* v___x_3517_; 
lean_inc_ref(v___x_3462_);
v___x_16922__overap_3516_ = l___private_Lean_Util_Trace_0__Lean_getResetTraces(lean_box(0), v___x_3462_, v___x_3463_);
lean_inc(v_a_3417_);
lean_inc_ref(v_a_3416_);
lean_inc(v_a_3415_);
lean_inc_ref(v_a_3414_);
lean_inc(v_a_3413_);
lean_inc_ref(v_a_3412_);
lean_inc(v_a_3411_);
lean_inc_ref(v_a_3410_);
v___x_3517_ = lean_apply_9(v___x_16922__overap_3516_, v_a_3410_, v_a_3411_, v_a_3412_, v_a_3413_, v_a_3414_, v_a_3415_, v_a_3416_, v_a_3417_, lean_box(0));
if (lean_obj_tag(v___x_3517_) == 0)
{
lean_object* v_a_3518_; lean_object* v___x_3519_; lean_object* v___x_3520_; lean_object* v___x_3521_; uint8_t v___x_3522_; 
v_a_3518_ = lean_ctor_get(v___x_3517_, 0);
lean_inc(v_a_3518_);
lean_dec_ref_known(v___x_3517_, 1);
v___x_3519_ = l_Lean_KVMap_instValueBool;
v___x_3520_ = l_Lean_trace_profiler_useHeartbeats;
v___x_3521_ = l_Lean_Option_get___redArg(v___x_3519_, v_options_3467_, v___x_3520_);
v___x_3522_ = lean_unbox(v___x_3521_);
lean_dec(v___x_3521_);
if (v___x_3522_ == 0)
{
lean_object* v___x_3523_; lean_object* v___x_3524_; 
v___x_3523_ = lean_io_mono_nanos_now();
lean_inc(v_a_3417_);
lean_inc_ref(v_a_3416_);
lean_inc(v_a_3415_);
lean_inc_ref(v_a_3414_);
lean_inc(v_a_3413_);
lean_inc_ref(v_a_3412_);
lean_inc(v_a_3411_);
lean_inc_ref(v_a_3410_);
v___x_3524_ = lean_apply_9(v_run_x27_3472_, v_a_3410_, v_a_3411_, v_a_3412_, v_a_3413_, v_a_3414_, v_a_3415_, v_a_3416_, v_a_3417_, lean_box(0));
if (lean_obj_tag(v___x_3524_) == 0)
{
lean_object* v_a_3525_; lean_object* v___x_3527_; uint8_t v_isShared_3528_; uint8_t v_isSharedCheck_3532_; 
v_a_3525_ = lean_ctor_get(v___x_3524_, 0);
v_isSharedCheck_3532_ = !lean_is_exclusive(v___x_3524_);
if (v_isSharedCheck_3532_ == 0)
{
v___x_3527_ = v___x_3524_;
v_isShared_3528_ = v_isSharedCheck_3532_;
goto v_resetjp_3526_;
}
else
{
lean_inc(v_a_3525_);
lean_dec(v___x_3524_);
v___x_3527_ = lean_box(0);
v_isShared_3528_ = v_isSharedCheck_3532_;
goto v_resetjp_3526_;
}
v_resetjp_3526_:
{
lean_object* v___x_3530_; 
if (v_isShared_3528_ == 0)
{
lean_ctor_set_tag(v___x_3527_, 1);
v___x_3530_ = v___x_3527_;
goto v_reusejp_3529_;
}
else
{
lean_object* v_reuseFailAlloc_3531_; 
v_reuseFailAlloc_3531_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3531_, 0, v_a_3525_);
v___x_3530_ = v_reuseFailAlloc_3531_;
goto v_reusejp_3529_;
}
v_reusejp_3529_:
{
v___y_3485_ = v_a_3518_;
v___y_3486_ = v___x_3523_;
v_a_3487_ = v___x_3530_;
goto v___jp_3484_;
}
}
}
else
{
lean_object* v_a_3533_; lean_object* v___x_3535_; uint8_t v_isShared_3536_; uint8_t v_isSharedCheck_3540_; 
v_a_3533_ = lean_ctor_get(v___x_3524_, 0);
v_isSharedCheck_3540_ = !lean_is_exclusive(v___x_3524_);
if (v_isSharedCheck_3540_ == 0)
{
v___x_3535_ = v___x_3524_;
v_isShared_3536_ = v_isSharedCheck_3540_;
goto v_resetjp_3534_;
}
else
{
lean_inc(v_a_3533_);
lean_dec(v___x_3524_);
v___x_3535_ = lean_box(0);
v_isShared_3536_ = v_isSharedCheck_3540_;
goto v_resetjp_3534_;
}
v_resetjp_3534_:
{
lean_object* v___x_3538_; 
if (v_isShared_3536_ == 0)
{
lean_ctor_set_tag(v___x_3535_, 0);
v___x_3538_ = v___x_3535_;
goto v_reusejp_3537_;
}
else
{
lean_object* v_reuseFailAlloc_3539_; 
v_reuseFailAlloc_3539_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3539_, 0, v_a_3533_);
v___x_3538_ = v_reuseFailAlloc_3539_;
goto v_reusejp_3537_;
}
v_reusejp_3537_:
{
v___y_3485_ = v_a_3518_;
v___y_3486_ = v___x_3523_;
v_a_3487_ = v___x_3538_;
goto v___jp_3484_;
}
}
}
}
else
{
lean_object* v___x_3541_; lean_object* v___x_3542_; 
lean_del_object(v___x_3474_);
v___x_3541_ = lean_io_get_num_heartbeats();
lean_inc(v_a_3417_);
lean_inc_ref(v_a_3416_);
lean_inc(v_a_3415_);
lean_inc_ref(v_a_3414_);
lean_inc(v_a_3413_);
lean_inc_ref(v_a_3412_);
lean_inc(v_a_3411_);
lean_inc_ref(v_a_3410_);
v___x_3542_ = lean_apply_9(v_run_x27_3472_, v_a_3410_, v_a_3411_, v_a_3412_, v_a_3413_, v_a_3414_, v_a_3415_, v_a_3416_, v_a_3417_, lean_box(0));
if (lean_obj_tag(v___x_3542_) == 0)
{
lean_object* v_a_3543_; lean_object* v___x_3545_; uint8_t v_isShared_3546_; uint8_t v_isSharedCheck_3550_; 
v_a_3543_ = lean_ctor_get(v___x_3542_, 0);
v_isSharedCheck_3550_ = !lean_is_exclusive(v___x_3542_);
if (v_isSharedCheck_3550_ == 0)
{
v___x_3545_ = v___x_3542_;
v_isShared_3546_ = v_isSharedCheck_3550_;
goto v_resetjp_3544_;
}
else
{
lean_inc(v_a_3543_);
lean_dec(v___x_3542_);
v___x_3545_ = lean_box(0);
v_isShared_3546_ = v_isSharedCheck_3550_;
goto v_resetjp_3544_;
}
v_resetjp_3544_:
{
lean_object* v___x_3548_; 
if (v_isShared_3546_ == 0)
{
lean_ctor_set_tag(v___x_3545_, 1);
v___x_3548_ = v___x_3545_;
goto v_reusejp_3547_;
}
else
{
lean_object* v_reuseFailAlloc_3549_; 
v_reuseFailAlloc_3549_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3549_, 0, v_a_3543_);
v___x_3548_ = v_reuseFailAlloc_3549_;
goto v_reusejp_3547_;
}
v_reusejp_3547_:
{
v___y_3503_ = v_a_3518_;
v___y_3504_ = v___x_3541_;
v_a_3505_ = v___x_3548_;
goto v___jp_3502_;
}
}
}
else
{
lean_object* v_a_3551_; lean_object* v___x_3553_; uint8_t v_isShared_3554_; uint8_t v_isSharedCheck_3558_; 
v_a_3551_ = lean_ctor_get(v___x_3542_, 0);
v_isSharedCheck_3558_ = !lean_is_exclusive(v___x_3542_);
if (v_isSharedCheck_3558_ == 0)
{
v___x_3553_ = v___x_3542_;
v_isShared_3554_ = v_isSharedCheck_3558_;
goto v_resetjp_3552_;
}
else
{
lean_inc(v_a_3551_);
lean_dec(v___x_3542_);
v___x_3553_ = lean_box(0);
v_isShared_3554_ = v_isSharedCheck_3558_;
goto v_resetjp_3552_;
}
v_resetjp_3552_:
{
lean_object* v___x_3556_; 
if (v_isShared_3554_ == 0)
{
lean_ctor_set_tag(v___x_3553_, 0);
v___x_3556_ = v___x_3553_;
goto v_reusejp_3555_;
}
else
{
lean_object* v_reuseFailAlloc_3557_; 
v_reuseFailAlloc_3557_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3557_, 0, v_a_3551_);
v___x_3556_ = v_reuseFailAlloc_3557_;
goto v_reusejp_3555_;
}
v_reusejp_3555_:
{
v___y_3503_ = v_a_3518_;
v___y_3504_ = v___x_3541_;
v_a_3505_ = v___x_3556_;
goto v___jp_3502_;
}
}
}
}
}
else
{
lean_object* v_a_3559_; lean_object* v___x_3561_; uint8_t v_isShared_3562_; uint8_t v_isSharedCheck_3566_; 
lean_dec_ref(v___f_3477_);
lean_del_object(v___x_3474_);
lean_dec_ref(v_run_x27_3472_);
lean_dec_ref(v___x_3462_);
v_a_3559_ = lean_ctor_get(v___x_3517_, 0);
v_isSharedCheck_3566_ = !lean_is_exclusive(v___x_3517_);
if (v_isSharedCheck_3566_ == 0)
{
v___x_3561_ = v___x_3517_;
v_isShared_3562_ = v_isSharedCheck_3566_;
goto v_resetjp_3560_;
}
else
{
lean_inc(v_a_3559_);
lean_dec(v___x_3517_);
v___x_3561_ = lean_box(0);
v_isShared_3562_ = v_isSharedCheck_3566_;
goto v_resetjp_3560_;
}
v_resetjp_3560_:
{
lean_object* v___x_3564_; 
if (v_isShared_3562_ == 0)
{
v___x_3564_ = v___x_3561_;
goto v_reusejp_3563_;
}
else
{
lean_object* v_reuseFailAlloc_3565_; 
v_reuseFailAlloc_3565_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3565_, 0, v_a_3559_);
v___x_3564_ = v_reuseFailAlloc_3565_;
goto v_reusejp_3563_;
}
v_reusejp_3563_:
{
return v___x_3564_;
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
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___boxed(lean_object* v_pass_3579_, lean_object* v_a_3580_, lean_object* v_a_3581_, lean_object* v_a_3582_, lean_object* v_a_3583_, lean_object* v_a_3584_, lean_object* v_a_3585_, lean_object* v_a_3586_, lean_object* v_a_3587_, lean_object* v_a_3588_){
_start:
{
lean_object* v_res_3589_; 
v_res_3589_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run(v_pass_3579_, v_a_3580_, v_a_3581_, v_a_3582_, v_a_3583_, v_a_3584_, v_a_3585_, v_a_3586_, v_a_3587_);
lean_dec(v_a_3587_);
lean_dec_ref(v_a_3586_);
lean_dec(v_a_3585_);
lean_dec_ref(v_a_3584_);
lean_dec(v_a_3583_);
lean_dec_ref(v_a_3582_);
lean_dec(v_a_3581_);
lean_dec_ref(v_a_3580_);
return v_res_3589_;
}
}
static lean_object* _init_l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__0(void){
_start:
{
lean_object* v___x_3590_; lean_object* v___x_3591_; lean_object* v___x_3592_; 
v___x_3590_ = lean_unsigned_to_nat(32u);
v___x_3591_ = lean_mk_empty_array_with_capacity(v___x_3590_);
v___x_3592_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3592_, 0, v___x_3591_);
return v___x_3592_;
}
}
static lean_object* _init_l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__1(void){
_start:
{
size_t v___x_3593_; lean_object* v___x_3594_; lean_object* v___x_3595_; lean_object* v___x_3596_; lean_object* v___x_3597_; lean_object* v___x_3598_; 
v___x_3593_ = ((size_t)5ULL);
v___x_3594_ = lean_unsigned_to_nat(0u);
v___x_3595_ = lean_unsigned_to_nat(32u);
v___x_3596_ = lean_mk_empty_array_with_capacity(v___x_3595_);
v___x_3597_ = lean_obj_once(&l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__0, &l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__0_once, _init_l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__0);
v___x_3598_ = lean_alloc_ctor(0, 4, sizeof(size_t)*1);
lean_ctor_set(v___x_3598_, 0, v___x_3597_);
lean_ctor_set(v___x_3598_, 1, v___x_3596_);
lean_ctor_set(v___x_3598_, 2, v___x_3594_);
lean_ctor_set(v___x_3598_, 3, v___x_3594_);
lean_ctor_set_usize(v___x_3598_, 4, v___x_3593_);
return v___x_3598_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg(lean_object* v___y_3599_){
_start:
{
lean_object* v___x_3601_; lean_object* v_traceState_3602_; lean_object* v_traces_3603_; lean_object* v___x_3604_; lean_object* v_traceState_3605_; lean_object* v_env_3606_; lean_object* v_nextMacroScope_3607_; lean_object* v_ngen_3608_; lean_object* v_auxDeclNGen_3609_; lean_object* v_cache_3610_; lean_object* v_messages_3611_; lean_object* v_infoState_3612_; lean_object* v_snapshotTasks_3613_; lean_object* v___x_3615_; uint8_t v_isShared_3616_; uint8_t v_isSharedCheck_3632_; 
v___x_3601_ = lean_st_ref_get(v___y_3599_);
v_traceState_3602_ = lean_ctor_get(v___x_3601_, 4);
lean_inc_ref(v_traceState_3602_);
lean_dec(v___x_3601_);
v_traces_3603_ = lean_ctor_get(v_traceState_3602_, 0);
lean_inc_ref(v_traces_3603_);
lean_dec_ref(v_traceState_3602_);
v___x_3604_ = lean_st_ref_take(v___y_3599_);
v_traceState_3605_ = lean_ctor_get(v___x_3604_, 4);
v_env_3606_ = lean_ctor_get(v___x_3604_, 0);
v_nextMacroScope_3607_ = lean_ctor_get(v___x_3604_, 1);
v_ngen_3608_ = lean_ctor_get(v___x_3604_, 2);
v_auxDeclNGen_3609_ = lean_ctor_get(v___x_3604_, 3);
v_cache_3610_ = lean_ctor_get(v___x_3604_, 5);
v_messages_3611_ = lean_ctor_get(v___x_3604_, 6);
v_infoState_3612_ = lean_ctor_get(v___x_3604_, 7);
v_snapshotTasks_3613_ = lean_ctor_get(v___x_3604_, 8);
v_isSharedCheck_3632_ = !lean_is_exclusive(v___x_3604_);
if (v_isSharedCheck_3632_ == 0)
{
v___x_3615_ = v___x_3604_;
v_isShared_3616_ = v_isSharedCheck_3632_;
goto v_resetjp_3614_;
}
else
{
lean_inc(v_snapshotTasks_3613_);
lean_inc(v_infoState_3612_);
lean_inc(v_messages_3611_);
lean_inc(v_cache_3610_);
lean_inc(v_traceState_3605_);
lean_inc(v_auxDeclNGen_3609_);
lean_inc(v_ngen_3608_);
lean_inc(v_nextMacroScope_3607_);
lean_inc(v_env_3606_);
lean_dec(v___x_3604_);
v___x_3615_ = lean_box(0);
v_isShared_3616_ = v_isSharedCheck_3632_;
goto v_resetjp_3614_;
}
v_resetjp_3614_:
{
uint64_t v_tid_3617_; lean_object* v___x_3619_; uint8_t v_isShared_3620_; uint8_t v_isSharedCheck_3630_; 
v_tid_3617_ = lean_ctor_get_uint64(v_traceState_3605_, sizeof(void*)*1);
v_isSharedCheck_3630_ = !lean_is_exclusive(v_traceState_3605_);
if (v_isSharedCheck_3630_ == 0)
{
lean_object* v_unused_3631_; 
v_unused_3631_ = lean_ctor_get(v_traceState_3605_, 0);
lean_dec(v_unused_3631_);
v___x_3619_ = v_traceState_3605_;
v_isShared_3620_ = v_isSharedCheck_3630_;
goto v_resetjp_3618_;
}
else
{
lean_dec(v_traceState_3605_);
v___x_3619_ = lean_box(0);
v_isShared_3620_ = v_isSharedCheck_3630_;
goto v_resetjp_3618_;
}
v_resetjp_3618_:
{
lean_object* v___x_3621_; lean_object* v___x_3623_; 
v___x_3621_ = lean_obj_once(&l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__1, &l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__1_once, _init_l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___closed__1);
if (v_isShared_3620_ == 0)
{
lean_ctor_set(v___x_3619_, 0, v___x_3621_);
v___x_3623_ = v___x_3619_;
goto v_reusejp_3622_;
}
else
{
lean_object* v_reuseFailAlloc_3629_; 
v_reuseFailAlloc_3629_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_3629_, 0, v___x_3621_);
lean_ctor_set_uint64(v_reuseFailAlloc_3629_, sizeof(void*)*1, v_tid_3617_);
v___x_3623_ = v_reuseFailAlloc_3629_;
goto v_reusejp_3622_;
}
v_reusejp_3622_:
{
lean_object* v___x_3625_; 
if (v_isShared_3616_ == 0)
{
lean_ctor_set(v___x_3615_, 4, v___x_3623_);
v___x_3625_ = v___x_3615_;
goto v_reusejp_3624_;
}
else
{
lean_object* v_reuseFailAlloc_3628_; 
v_reuseFailAlloc_3628_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_3628_, 0, v_env_3606_);
lean_ctor_set(v_reuseFailAlloc_3628_, 1, v_nextMacroScope_3607_);
lean_ctor_set(v_reuseFailAlloc_3628_, 2, v_ngen_3608_);
lean_ctor_set(v_reuseFailAlloc_3628_, 3, v_auxDeclNGen_3609_);
lean_ctor_set(v_reuseFailAlloc_3628_, 4, v___x_3623_);
lean_ctor_set(v_reuseFailAlloc_3628_, 5, v_cache_3610_);
lean_ctor_set(v_reuseFailAlloc_3628_, 6, v_messages_3611_);
lean_ctor_set(v_reuseFailAlloc_3628_, 7, v_infoState_3612_);
lean_ctor_set(v_reuseFailAlloc_3628_, 8, v_snapshotTasks_3613_);
v___x_3625_ = v_reuseFailAlloc_3628_;
goto v_reusejp_3624_;
}
v_reusejp_3624_:
{
lean_object* v___x_3626_; lean_object* v___x_3627_; 
v___x_3626_ = lean_st_ref_set(v___y_3599_, v___x_3625_);
v___x_3627_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3627_, 0, v_traces_3603_);
return v___x_3627_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg___boxed(lean_object* v___y_3633_, lean_object* v___y_3634_){
_start:
{
lean_object* v_res_3635_; 
v_res_3635_ = l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg(v___y_3633_);
lean_dec(v___y_3633_);
return v_res_3635_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1(lean_object* v___y_3636_, lean_object* v___y_3637_, lean_object* v___y_3638_, lean_object* v___y_3639_, lean_object* v___y_3640_, lean_object* v___y_3641_, lean_object* v___y_3642_, lean_object* v___y_3643_){
_start:
{
lean_object* v___x_3645_; 
v___x_3645_ = l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg(v___y_3643_);
return v___x_3645_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___boxed(lean_object* v___y_3646_, lean_object* v___y_3647_, lean_object* v___y_3648_, lean_object* v___y_3649_, lean_object* v___y_3650_, lean_object* v___y_3651_, lean_object* v___y_3652_, lean_object* v___y_3653_, lean_object* v___y_3654_){
_start:
{
lean_object* v_res_3655_; 
v_res_3655_ = l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1(v___y_3646_, v___y_3647_, v___y_3648_, v___y_3649_, v___y_3650_, v___y_3651_, v___y_3652_, v___y_3653_);
lean_dec(v___y_3653_);
lean_dec_ref(v___y_3652_);
lean_dec(v___y_3651_);
lean_dec_ref(v___y_3650_);
lean_dec(v___y_3649_);
lean_dec_ref(v___y_3648_);
lean_dec(v___y_3647_);
lean_dec_ref(v___y_3646_);
return v_res_3655_;
}
}
LEAN_EXPORT uint8_t l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__2(lean_object* v_opts_3656_, lean_object* v_opt_3657_){
_start:
{
lean_object* v_name_3658_; lean_object* v_defValue_3659_; lean_object* v_map_3660_; lean_object* v___x_3661_; 
v_name_3658_ = lean_ctor_get(v_opt_3657_, 0);
v_defValue_3659_ = lean_ctor_get(v_opt_3657_, 1);
v_map_3660_ = lean_ctor_get(v_opts_3656_, 0);
v___x_3661_ = l_Std_DTreeMap_Internal_Impl_Const_get_x3f___at___00Lean_NameMap_find_x3f_spec__0___redArg(v_map_3660_, v_name_3658_);
if (lean_obj_tag(v___x_3661_) == 0)
{
uint8_t v___x_3662_; 
v___x_3662_ = lean_unbox(v_defValue_3659_);
return v___x_3662_;
}
else
{
lean_object* v_val_3663_; 
v_val_3663_ = lean_ctor_get(v___x_3661_, 0);
lean_inc(v_val_3663_);
lean_dec_ref_known(v___x_3661_, 1);
if (lean_obj_tag(v_val_3663_) == 1)
{
uint8_t v_v_3664_; 
v_v_3664_ = lean_ctor_get_uint8(v_val_3663_, 0);
lean_dec_ref_known(v_val_3663_, 0);
return v_v_3664_;
}
else
{
uint8_t v___x_3665_; 
lean_dec(v_val_3663_);
v___x_3665_ = lean_unbox(v_defValue_3659_);
return v___x_3665_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__2___boxed(lean_object* v_opts_3666_, lean_object* v_opt_3667_){
_start:
{
uint8_t v_res_3668_; lean_object* v_r_3669_; 
v_res_3668_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__2(v_opts_3666_, v_opt_3667_);
lean_dec_ref(v_opt_3667_);
lean_dec_ref(v_opts_3666_);
v_r_3669_ = lean_box(v_res_3668_);
return v_r_3669_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0_spec__0(lean_object* v_msgData_3670_, lean_object* v___y_3671_, lean_object* v___y_3672_, lean_object* v___y_3673_, lean_object* v___y_3674_){
_start:
{
lean_object* v___x_3676_; lean_object* v_env_3677_; lean_object* v___x_3678_; lean_object* v_mctx_3679_; lean_object* v_lctx_3680_; lean_object* v_options_3681_; lean_object* v___x_3682_; lean_object* v___x_3683_; lean_object* v___x_3684_; 
v___x_3676_ = lean_st_ref_get(v___y_3674_);
v_env_3677_ = lean_ctor_get(v___x_3676_, 0);
lean_inc_ref(v_env_3677_);
lean_dec(v___x_3676_);
v___x_3678_ = lean_st_ref_get(v___y_3672_);
v_mctx_3679_ = lean_ctor_get(v___x_3678_, 0);
lean_inc_ref(v_mctx_3679_);
lean_dec(v___x_3678_);
v_lctx_3680_ = lean_ctor_get(v___y_3671_, 2);
v_options_3681_ = lean_ctor_get(v___y_3673_, 2);
lean_inc_ref(v_options_3681_);
lean_inc_ref(v_lctx_3680_);
v___x_3682_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_3682_, 0, v_env_3677_);
lean_ctor_set(v___x_3682_, 1, v_mctx_3679_);
lean_ctor_set(v___x_3682_, 2, v_lctx_3680_);
lean_ctor_set(v___x_3682_, 3, v_options_3681_);
v___x_3683_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v___x_3683_, 0, v___x_3682_);
lean_ctor_set(v___x_3683_, 1, v_msgData_3670_);
v___x_3684_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_3684_, 0, v___x_3683_);
return v___x_3684_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0_spec__0___boxed(lean_object* v_msgData_3685_, lean_object* v___y_3686_, lean_object* v___y_3687_, lean_object* v___y_3688_, lean_object* v___y_3689_, lean_object* v___y_3690_){
_start:
{
lean_object* v_res_3691_; 
v_res_3691_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0_spec__0(v_msgData_3685_, v___y_3686_, v___y_3687_, v___y_3688_, v___y_3689_);
lean_dec(v___y_3689_);
lean_dec_ref(v___y_3688_);
lean_dec(v___y_3687_);
lean_dec_ref(v___y_3686_);
return v_res_3691_;
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4_spec__5(size_t v_sz_3692_, size_t v_i_3693_, lean_object* v_bs_3694_){
_start:
{
uint8_t v___x_3695_; 
v___x_3695_ = lean_usize_dec_lt(v_i_3693_, v_sz_3692_);
if (v___x_3695_ == 0)
{
return v_bs_3694_;
}
else
{
lean_object* v_v_3696_; lean_object* v_msg_3697_; lean_object* v___x_3698_; lean_object* v_bs_x27_3699_; size_t v___x_3700_; size_t v___x_3701_; lean_object* v___x_3702_; 
v_v_3696_ = lean_array_uget_borrowed(v_bs_3694_, v_i_3693_);
v_msg_3697_ = lean_ctor_get(v_v_3696_, 1);
lean_inc_ref(v_msg_3697_);
v___x_3698_ = lean_unsigned_to_nat(0u);
v_bs_x27_3699_ = lean_array_uset(v_bs_3694_, v_i_3693_, v___x_3698_);
v___x_3700_ = ((size_t)1ULL);
v___x_3701_ = lean_usize_add(v_i_3693_, v___x_3700_);
v___x_3702_ = lean_array_uset(v_bs_x27_3699_, v_i_3693_, v_msg_3697_);
v_i_3693_ = v___x_3701_;
v_bs_3694_ = v___x_3702_;
goto _start;
}
}
}
LEAN_EXPORT lean_object* l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4_spec__5___boxed(lean_object* v_sz_3704_, lean_object* v_i_3705_, lean_object* v_bs_3706_){
_start:
{
size_t v_sz_boxed_3707_; size_t v_i_boxed_3708_; lean_object* v_res_3709_; 
v_sz_boxed_3707_ = lean_unbox_usize(v_sz_3704_);
lean_dec(v_sz_3704_);
v_i_boxed_3708_ = lean_unbox_usize(v_i_3705_);
lean_dec(v_i_3705_);
v_res_3709_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4_spec__5(v_sz_boxed_3707_, v_i_boxed_3708_, v_bs_3706_);
return v_res_3709_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4___redArg(lean_object* v_oldTraces_3710_, lean_object* v_data_3711_, lean_object* v_ref_3712_, lean_object* v_msg_3713_, lean_object* v___y_3714_, lean_object* v___y_3715_, lean_object* v___y_3716_, lean_object* v___y_3717_){
_start:
{
lean_object* v_fileName_3719_; lean_object* v_fileMap_3720_; lean_object* v_options_3721_; lean_object* v_currRecDepth_3722_; lean_object* v_maxRecDepth_3723_; lean_object* v_ref_3724_; lean_object* v_currNamespace_3725_; lean_object* v_openDecls_3726_; lean_object* v_initHeartbeats_3727_; lean_object* v_maxHeartbeats_3728_; lean_object* v_quotContext_3729_; lean_object* v_currMacroScope_3730_; uint8_t v_diag_3731_; lean_object* v_cancelTk_x3f_3732_; uint8_t v_suppressElabErrors_3733_; lean_object* v_inheritedTraceOptions_3734_; lean_object* v___x_3735_; lean_object* v_traceState_3736_; lean_object* v_traces_3737_; lean_object* v_ref_3738_; lean_object* v___x_3739_; lean_object* v___x_3740_; size_t v_sz_3741_; size_t v___x_3742_; lean_object* v___x_3743_; lean_object* v_msg_3744_; lean_object* v___x_3745_; lean_object* v_a_3746_; lean_object* v___x_3748_; uint8_t v_isShared_3749_; uint8_t v_isSharedCheck_3783_; 
v_fileName_3719_ = lean_ctor_get(v___y_3716_, 0);
v_fileMap_3720_ = lean_ctor_get(v___y_3716_, 1);
v_options_3721_ = lean_ctor_get(v___y_3716_, 2);
v_currRecDepth_3722_ = lean_ctor_get(v___y_3716_, 3);
v_maxRecDepth_3723_ = lean_ctor_get(v___y_3716_, 4);
v_ref_3724_ = lean_ctor_get(v___y_3716_, 5);
v_currNamespace_3725_ = lean_ctor_get(v___y_3716_, 6);
v_openDecls_3726_ = lean_ctor_get(v___y_3716_, 7);
v_initHeartbeats_3727_ = lean_ctor_get(v___y_3716_, 8);
v_maxHeartbeats_3728_ = lean_ctor_get(v___y_3716_, 9);
v_quotContext_3729_ = lean_ctor_get(v___y_3716_, 10);
v_currMacroScope_3730_ = lean_ctor_get(v___y_3716_, 11);
v_diag_3731_ = lean_ctor_get_uint8(v___y_3716_, sizeof(void*)*14);
v_cancelTk_x3f_3732_ = lean_ctor_get(v___y_3716_, 12);
v_suppressElabErrors_3733_ = lean_ctor_get_uint8(v___y_3716_, sizeof(void*)*14 + 1);
v_inheritedTraceOptions_3734_ = lean_ctor_get(v___y_3716_, 13);
v___x_3735_ = lean_st_ref_get(v___y_3717_);
v_traceState_3736_ = lean_ctor_get(v___x_3735_, 4);
lean_inc_ref(v_traceState_3736_);
lean_dec(v___x_3735_);
v_traces_3737_ = lean_ctor_get(v_traceState_3736_, 0);
lean_inc_ref(v_traces_3737_);
lean_dec_ref(v_traceState_3736_);
v_ref_3738_ = l_Lean_replaceRef(v_ref_3712_, v_ref_3724_);
lean_inc_ref(v_inheritedTraceOptions_3734_);
lean_inc(v_cancelTk_x3f_3732_);
lean_inc(v_currMacroScope_3730_);
lean_inc(v_quotContext_3729_);
lean_inc(v_maxHeartbeats_3728_);
lean_inc(v_initHeartbeats_3727_);
lean_inc(v_openDecls_3726_);
lean_inc(v_currNamespace_3725_);
lean_inc(v_maxRecDepth_3723_);
lean_inc(v_currRecDepth_3722_);
lean_inc_ref(v_options_3721_);
lean_inc_ref(v_fileMap_3720_);
lean_inc_ref(v_fileName_3719_);
v___x_3739_ = lean_alloc_ctor(0, 14, 2);
lean_ctor_set(v___x_3739_, 0, v_fileName_3719_);
lean_ctor_set(v___x_3739_, 1, v_fileMap_3720_);
lean_ctor_set(v___x_3739_, 2, v_options_3721_);
lean_ctor_set(v___x_3739_, 3, v_currRecDepth_3722_);
lean_ctor_set(v___x_3739_, 4, v_maxRecDepth_3723_);
lean_ctor_set(v___x_3739_, 5, v_ref_3738_);
lean_ctor_set(v___x_3739_, 6, v_currNamespace_3725_);
lean_ctor_set(v___x_3739_, 7, v_openDecls_3726_);
lean_ctor_set(v___x_3739_, 8, v_initHeartbeats_3727_);
lean_ctor_set(v___x_3739_, 9, v_maxHeartbeats_3728_);
lean_ctor_set(v___x_3739_, 10, v_quotContext_3729_);
lean_ctor_set(v___x_3739_, 11, v_currMacroScope_3730_);
lean_ctor_set(v___x_3739_, 12, v_cancelTk_x3f_3732_);
lean_ctor_set(v___x_3739_, 13, v_inheritedTraceOptions_3734_);
lean_ctor_set_uint8(v___x_3739_, sizeof(void*)*14, v_diag_3731_);
lean_ctor_set_uint8(v___x_3739_, sizeof(void*)*14 + 1, v_suppressElabErrors_3733_);
v___x_3740_ = l_Lean_PersistentArray_toArray___redArg(v_traces_3737_);
lean_dec_ref(v_traces_3737_);
v_sz_3741_ = lean_array_size(v___x_3740_);
v___x_3742_ = ((size_t)0ULL);
v___x_3743_ = l___private_Init_Data_Array_Basic_0__Array_mapMUnsafe_map___at___00__private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4_spec__5(v_sz_3741_, v___x_3742_, v___x_3740_);
v_msg_3744_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v_msg_3744_, 0, v_data_3711_);
lean_ctor_set(v_msg_3744_, 1, v_msg_3713_);
lean_ctor_set(v_msg_3744_, 2, v___x_3743_);
v___x_3745_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0_spec__0(v_msg_3744_, v___y_3714_, v___y_3715_, v___x_3739_, v___y_3717_);
lean_dec_ref_known(v___x_3739_, 14);
v_a_3746_ = lean_ctor_get(v___x_3745_, 0);
v_isSharedCheck_3783_ = !lean_is_exclusive(v___x_3745_);
if (v_isSharedCheck_3783_ == 0)
{
v___x_3748_ = v___x_3745_;
v_isShared_3749_ = v_isSharedCheck_3783_;
goto v_resetjp_3747_;
}
else
{
lean_inc(v_a_3746_);
lean_dec(v___x_3745_);
v___x_3748_ = lean_box(0);
v_isShared_3749_ = v_isSharedCheck_3783_;
goto v_resetjp_3747_;
}
v_resetjp_3747_:
{
lean_object* v___x_3750_; lean_object* v_traceState_3751_; lean_object* v_env_3752_; lean_object* v_nextMacroScope_3753_; lean_object* v_ngen_3754_; lean_object* v_auxDeclNGen_3755_; lean_object* v_cache_3756_; lean_object* v_messages_3757_; lean_object* v_infoState_3758_; lean_object* v_snapshotTasks_3759_; lean_object* v___x_3761_; uint8_t v_isShared_3762_; uint8_t v_isSharedCheck_3782_; 
v___x_3750_ = lean_st_ref_take(v___y_3717_);
v_traceState_3751_ = lean_ctor_get(v___x_3750_, 4);
v_env_3752_ = lean_ctor_get(v___x_3750_, 0);
v_nextMacroScope_3753_ = lean_ctor_get(v___x_3750_, 1);
v_ngen_3754_ = lean_ctor_get(v___x_3750_, 2);
v_auxDeclNGen_3755_ = lean_ctor_get(v___x_3750_, 3);
v_cache_3756_ = lean_ctor_get(v___x_3750_, 5);
v_messages_3757_ = lean_ctor_get(v___x_3750_, 6);
v_infoState_3758_ = lean_ctor_get(v___x_3750_, 7);
v_snapshotTasks_3759_ = lean_ctor_get(v___x_3750_, 8);
v_isSharedCheck_3782_ = !lean_is_exclusive(v___x_3750_);
if (v_isSharedCheck_3782_ == 0)
{
v___x_3761_ = v___x_3750_;
v_isShared_3762_ = v_isSharedCheck_3782_;
goto v_resetjp_3760_;
}
else
{
lean_inc(v_snapshotTasks_3759_);
lean_inc(v_infoState_3758_);
lean_inc(v_messages_3757_);
lean_inc(v_cache_3756_);
lean_inc(v_traceState_3751_);
lean_inc(v_auxDeclNGen_3755_);
lean_inc(v_ngen_3754_);
lean_inc(v_nextMacroScope_3753_);
lean_inc(v_env_3752_);
lean_dec(v___x_3750_);
v___x_3761_ = lean_box(0);
v_isShared_3762_ = v_isSharedCheck_3782_;
goto v_resetjp_3760_;
}
v_resetjp_3760_:
{
uint64_t v_tid_3763_; lean_object* v___x_3765_; uint8_t v_isShared_3766_; uint8_t v_isSharedCheck_3780_; 
v_tid_3763_ = lean_ctor_get_uint64(v_traceState_3751_, sizeof(void*)*1);
v_isSharedCheck_3780_ = !lean_is_exclusive(v_traceState_3751_);
if (v_isSharedCheck_3780_ == 0)
{
lean_object* v_unused_3781_; 
v_unused_3781_ = lean_ctor_get(v_traceState_3751_, 0);
lean_dec(v_unused_3781_);
v___x_3765_ = v_traceState_3751_;
v_isShared_3766_ = v_isSharedCheck_3780_;
goto v_resetjp_3764_;
}
else
{
lean_dec(v_traceState_3751_);
v___x_3765_ = lean_box(0);
v_isShared_3766_ = v_isSharedCheck_3780_;
goto v_resetjp_3764_;
}
v_resetjp_3764_:
{
lean_object* v___x_3767_; lean_object* v___x_3768_; lean_object* v___x_3770_; 
v___x_3767_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_3767_, 0, v_ref_3712_);
lean_ctor_set(v___x_3767_, 1, v_a_3746_);
v___x_3768_ = l_Lean_PersistentArray_push___redArg(v_oldTraces_3710_, v___x_3767_);
if (v_isShared_3766_ == 0)
{
lean_ctor_set(v___x_3765_, 0, v___x_3768_);
v___x_3770_ = v___x_3765_;
goto v_reusejp_3769_;
}
else
{
lean_object* v_reuseFailAlloc_3779_; 
v_reuseFailAlloc_3779_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_3779_, 0, v___x_3768_);
lean_ctor_set_uint64(v_reuseFailAlloc_3779_, sizeof(void*)*1, v_tid_3763_);
v___x_3770_ = v_reuseFailAlloc_3779_;
goto v_reusejp_3769_;
}
v_reusejp_3769_:
{
lean_object* v___x_3772_; 
if (v_isShared_3762_ == 0)
{
lean_ctor_set(v___x_3761_, 4, v___x_3770_);
v___x_3772_ = v___x_3761_;
goto v_reusejp_3771_;
}
else
{
lean_object* v_reuseFailAlloc_3778_; 
v_reuseFailAlloc_3778_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_3778_, 0, v_env_3752_);
lean_ctor_set(v_reuseFailAlloc_3778_, 1, v_nextMacroScope_3753_);
lean_ctor_set(v_reuseFailAlloc_3778_, 2, v_ngen_3754_);
lean_ctor_set(v_reuseFailAlloc_3778_, 3, v_auxDeclNGen_3755_);
lean_ctor_set(v_reuseFailAlloc_3778_, 4, v___x_3770_);
lean_ctor_set(v_reuseFailAlloc_3778_, 5, v_cache_3756_);
lean_ctor_set(v_reuseFailAlloc_3778_, 6, v_messages_3757_);
lean_ctor_set(v_reuseFailAlloc_3778_, 7, v_infoState_3758_);
lean_ctor_set(v_reuseFailAlloc_3778_, 8, v_snapshotTasks_3759_);
v___x_3772_ = v_reuseFailAlloc_3778_;
goto v_reusejp_3771_;
}
v_reusejp_3771_:
{
lean_object* v___x_3773_; lean_object* v___x_3774_; lean_object* v___x_3776_; 
v___x_3773_ = lean_st_ref_set(v___y_3717_, v___x_3772_);
v___x_3774_ = lean_box(0);
if (v_isShared_3749_ == 0)
{
lean_ctor_set(v___x_3748_, 0, v___x_3774_);
v___x_3776_ = v___x_3748_;
goto v_reusejp_3775_;
}
else
{
lean_object* v_reuseFailAlloc_3777_; 
v_reuseFailAlloc_3777_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3777_, 0, v___x_3774_);
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
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4___redArg___boxed(lean_object* v_oldTraces_3784_, lean_object* v_data_3785_, lean_object* v_ref_3786_, lean_object* v_msg_3787_, lean_object* v___y_3788_, lean_object* v___y_3789_, lean_object* v___y_3790_, lean_object* v___y_3791_, lean_object* v___y_3792_){
_start:
{
lean_object* v_res_3793_; 
v_res_3793_ = l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4___redArg(v_oldTraces_3784_, v_data_3785_, v_ref_3786_, v_msg_3787_, v___y_3788_, v___y_3789_, v___y_3790_, v___y_3791_);
lean_dec(v___y_3791_);
lean_dec_ref(v___y_3790_);
lean_dec(v___y_3789_);
lean_dec_ref(v___y_3788_);
return v_res_3793_;
}
}
LEAN_EXPORT uint8_t l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__6(lean_object* v_e_3794_){
_start:
{
if (lean_obj_tag(v_e_3794_) == 0)
{
uint8_t v___x_3795_; 
v___x_3795_ = 2;
return v___x_3795_;
}
else
{
lean_object* v_a_3796_; uint8_t v___x_3797_; 
v_a_3796_ = lean_ctor_get(v_e_3794_, 0);
v___x_3797_ = lean_unbox(v_a_3796_);
if (v___x_3797_ == 0)
{
uint8_t v___x_3798_; 
v___x_3798_ = 1;
return v___x_3798_;
}
else
{
uint8_t v___x_3799_; 
v___x_3799_ = 0;
return v___x_3799_;
}
}
}
}
LEAN_EXPORT lean_object* l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__6___boxed(lean_object* v_e_3800_){
_start:
{
uint8_t v_res_3801_; lean_object* v_r_3802_; 
v_res_3801_ = l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__6(v_e_3800_);
lean_dec_ref(v_e_3800_);
v_r_3802_ = lean_box(v_res_3801_);
return v_r_3802_;
}
}
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__7(lean_object* v_opts_3803_, lean_object* v_opt_3804_){
_start:
{
lean_object* v_name_3805_; lean_object* v_defValue_3806_; lean_object* v_map_3807_; lean_object* v___x_3808_; 
v_name_3805_ = lean_ctor_get(v_opt_3804_, 0);
v_defValue_3806_ = lean_ctor_get(v_opt_3804_, 1);
v_map_3807_ = lean_ctor_get(v_opts_3803_, 0);
v___x_3808_ = l_Std_DTreeMap_Internal_Impl_Const_get_x3f___at___00Lean_NameMap_find_x3f_spec__0___redArg(v_map_3807_, v_name_3805_);
if (lean_obj_tag(v___x_3808_) == 0)
{
lean_inc(v_defValue_3806_);
return v_defValue_3806_;
}
else
{
lean_object* v_val_3809_; 
v_val_3809_ = lean_ctor_get(v___x_3808_, 0);
lean_inc(v_val_3809_);
lean_dec_ref_known(v___x_3808_, 1);
if (lean_obj_tag(v_val_3809_) == 3)
{
lean_object* v_v_3810_; 
v_v_3810_ = lean_ctor_get(v_val_3809_, 0);
lean_inc(v_v_3810_);
lean_dec_ref_known(v_val_3809_, 1);
return v_v_3810_;
}
else
{
lean_dec(v_val_3809_);
lean_inc(v_defValue_3806_);
return v_defValue_3806_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__7___boxed(lean_object* v_opts_3811_, lean_object* v_opt_3812_){
_start:
{
lean_object* v_res_3813_; 
v_res_3813_ = l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__7(v_opts_3811_, v_opt_3812_);
lean_dec_ref(v_opt_3812_);
lean_dec_ref(v_opts_3811_);
return v_res_3813_;
}
}
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___redArg(lean_object* v_x_3814_){
_start:
{
if (lean_obj_tag(v_x_3814_) == 0)
{
lean_object* v_a_3816_; lean_object* v___x_3818_; uint8_t v_isShared_3819_; uint8_t v_isSharedCheck_3823_; 
v_a_3816_ = lean_ctor_get(v_x_3814_, 0);
v_isSharedCheck_3823_ = !lean_is_exclusive(v_x_3814_);
if (v_isSharedCheck_3823_ == 0)
{
v___x_3818_ = v_x_3814_;
v_isShared_3819_ = v_isSharedCheck_3823_;
goto v_resetjp_3817_;
}
else
{
lean_inc(v_a_3816_);
lean_dec(v_x_3814_);
v___x_3818_ = lean_box(0);
v_isShared_3819_ = v_isSharedCheck_3823_;
goto v_resetjp_3817_;
}
v_resetjp_3817_:
{
lean_object* v___x_3821_; 
if (v_isShared_3819_ == 0)
{
lean_ctor_set_tag(v___x_3818_, 1);
v___x_3821_ = v___x_3818_;
goto v_reusejp_3820_;
}
else
{
lean_object* v_reuseFailAlloc_3822_; 
v_reuseFailAlloc_3822_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3822_, 0, v_a_3816_);
v___x_3821_ = v_reuseFailAlloc_3822_;
goto v_reusejp_3820_;
}
v_reusejp_3820_:
{
return v___x_3821_;
}
}
}
else
{
lean_object* v_a_3824_; lean_object* v___x_3826_; uint8_t v_isShared_3827_; uint8_t v_isSharedCheck_3831_; 
v_a_3824_ = lean_ctor_get(v_x_3814_, 0);
v_isSharedCheck_3831_ = !lean_is_exclusive(v_x_3814_);
if (v_isSharedCheck_3831_ == 0)
{
v___x_3826_ = v_x_3814_;
v_isShared_3827_ = v_isSharedCheck_3831_;
goto v_resetjp_3825_;
}
else
{
lean_inc(v_a_3824_);
lean_dec(v_x_3814_);
v___x_3826_ = lean_box(0);
v_isShared_3827_ = v_isSharedCheck_3831_;
goto v_resetjp_3825_;
}
v_resetjp_3825_:
{
lean_object* v___x_3829_; 
if (v_isShared_3827_ == 0)
{
lean_ctor_set_tag(v___x_3826_, 0);
v___x_3829_ = v___x_3826_;
goto v_reusejp_3828_;
}
else
{
lean_object* v_reuseFailAlloc_3830_; 
v_reuseFailAlloc_3830_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3830_, 0, v_a_3824_);
v___x_3829_ = v_reuseFailAlloc_3830_;
goto v_reusejp_3828_;
}
v_reusejp_3828_:
{
return v___x_3829_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___redArg___boxed(lean_object* v_x_3832_, lean_object* v___y_3833_){
_start:
{
lean_object* v_res_3834_; 
v_res_3834_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___redArg(v_x_3832_);
return v_res_3834_;
}
}
static double _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__0(void){
_start:
{
lean_object* v___x_3835_; double v___x_3836_; 
v___x_3835_ = lean_unsigned_to_nat(0u);
v___x_3836_ = lean_float_of_nat(v___x_3835_);
return v___x_3836_;
}
}
static lean_object* _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__2(void){
_start:
{
lean_object* v___x_3838_; lean_object* v___x_3839_; 
v___x_3838_ = ((lean_object*)(l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__1));
v___x_3839_ = l_Lean_stringToMessageData(v___x_3838_);
return v___x_3839_;
}
}
static double _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__3(void){
_start:
{
lean_object* v___x_3840_; double v___x_3841_; 
v___x_3840_ = lean_unsigned_to_nat(1000u);
v___x_3841_ = lean_float_of_nat(v___x_3840_);
return v___x_3841_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3(lean_object* v_cls_3842_, uint8_t v_collapsed_3843_, lean_object* v_tag_3844_, lean_object* v_opts_3845_, uint8_t v_clsEnabled_3846_, lean_object* v_oldTraces_3847_, lean_object* v_msg_3848_, lean_object* v_resStartStop_3849_, lean_object* v___y_3850_, lean_object* v___y_3851_, lean_object* v___y_3852_, lean_object* v___y_3853_, lean_object* v___y_3854_, lean_object* v___y_3855_, lean_object* v___y_3856_, lean_object* v___y_3857_){
_start:
{
lean_object* v_fst_3859_; lean_object* v_snd_3860_; lean_object* v___y_3862_; lean_object* v___y_3863_; lean_object* v_data_3864_; lean_object* v_fst_3875_; lean_object* v_snd_3876_; lean_object* v___x_3877_; uint8_t v___x_3878_; lean_object* v___y_3880_; lean_object* v_a_3881_; uint8_t v___y_3896_; double v___y_3927_; 
v_fst_3859_ = lean_ctor_get(v_resStartStop_3849_, 0);
lean_inc(v_fst_3859_);
v_snd_3860_ = lean_ctor_get(v_resStartStop_3849_, 1);
lean_inc(v_snd_3860_);
lean_dec_ref(v_resStartStop_3849_);
v_fst_3875_ = lean_ctor_get(v_snd_3860_, 0);
lean_inc(v_fst_3875_);
v_snd_3876_ = lean_ctor_get(v_snd_3860_, 1);
lean_inc(v_snd_3876_);
lean_dec(v_snd_3860_);
v___x_3877_ = l_Lean_trace_profiler;
v___x_3878_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__2(v_opts_3845_, v___x_3877_);
if (v___x_3878_ == 0)
{
v___y_3896_ = v___x_3878_;
goto v___jp_3895_;
}
else
{
lean_object* v___x_3932_; uint8_t v___x_3933_; 
v___x_3932_ = l_Lean_trace_profiler_useHeartbeats;
v___x_3933_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__2(v_opts_3845_, v___x_3932_);
if (v___x_3933_ == 0)
{
lean_object* v___x_3934_; lean_object* v___x_3935_; double v___x_3936_; double v___x_3937_; double v___x_3938_; 
v___x_3934_ = l_Lean_trace_profiler_threshold;
v___x_3935_ = l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__7(v_opts_3845_, v___x_3934_);
v___x_3936_ = lean_float_of_nat(v___x_3935_);
v___x_3937_ = lean_float_once(&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__3, &l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__3_once, _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__3);
v___x_3938_ = lean_float_div(v___x_3936_, v___x_3937_);
v___y_3927_ = v___x_3938_;
goto v___jp_3926_;
}
else
{
lean_object* v___x_3939_; lean_object* v___x_3940_; double v___x_3941_; 
v___x_3939_ = l_Lean_trace_profiler_threshold;
v___x_3940_ = l_Lean_Option_get___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__7(v_opts_3845_, v___x_3939_);
v___x_3941_ = lean_float_of_nat(v___x_3940_);
v___y_3927_ = v___x_3941_;
goto v___jp_3926_;
}
}
v___jp_3861_:
{
lean_object* v___x_3865_; 
lean_inc(v___y_3862_);
v___x_3865_ = l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4___redArg(v_oldTraces_3847_, v_data_3864_, v___y_3862_, v___y_3863_, v___y_3854_, v___y_3855_, v___y_3856_, v___y_3857_);
if (lean_obj_tag(v___x_3865_) == 0)
{
lean_object* v___x_3866_; 
lean_dec_ref_known(v___x_3865_, 1);
v___x_3866_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___redArg(v_fst_3859_);
return v___x_3866_;
}
else
{
lean_object* v_a_3867_; lean_object* v___x_3869_; uint8_t v_isShared_3870_; uint8_t v_isSharedCheck_3874_; 
lean_dec(v_fst_3859_);
v_a_3867_ = lean_ctor_get(v___x_3865_, 0);
v_isSharedCheck_3874_ = !lean_is_exclusive(v___x_3865_);
if (v_isSharedCheck_3874_ == 0)
{
v___x_3869_ = v___x_3865_;
v_isShared_3870_ = v_isSharedCheck_3874_;
goto v_resetjp_3868_;
}
else
{
lean_inc(v_a_3867_);
lean_dec(v___x_3865_);
v___x_3869_ = lean_box(0);
v_isShared_3870_ = v_isSharedCheck_3874_;
goto v_resetjp_3868_;
}
v_resetjp_3868_:
{
lean_object* v___x_3872_; 
if (v_isShared_3870_ == 0)
{
v___x_3872_ = v___x_3869_;
goto v_reusejp_3871_;
}
else
{
lean_object* v_reuseFailAlloc_3873_; 
v_reuseFailAlloc_3873_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_3873_, 0, v_a_3867_);
v___x_3872_ = v_reuseFailAlloc_3873_;
goto v_reusejp_3871_;
}
v_reusejp_3871_:
{
return v___x_3872_;
}
}
}
}
v___jp_3879_:
{
uint8_t v_result_3882_; lean_object* v___x_3883_; lean_object* v___x_3884_; double v___x_3885_; lean_object* v_data_3886_; 
v_result_3882_ = l_Except_toTraceResult___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__6(v_fst_3859_);
v___x_3883_ = lean_box(v_result_3882_);
v___x_3884_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_3884_, 0, v___x_3883_);
v___x_3885_ = lean_float_once(&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__0, &l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__0_once, _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__0);
lean_inc_ref(v_tag_3844_);
lean_inc_ref(v___x_3884_);
lean_inc(v_cls_3842_);
v_data_3886_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v_data_3886_, 0, v_cls_3842_);
lean_ctor_set(v_data_3886_, 1, v___x_3884_);
lean_ctor_set(v_data_3886_, 2, v_tag_3844_);
lean_ctor_set_float(v_data_3886_, sizeof(void*)*3, v___x_3885_);
lean_ctor_set_float(v_data_3886_, sizeof(void*)*3 + 8, v___x_3885_);
lean_ctor_set_uint8(v_data_3886_, sizeof(void*)*3 + 16, v_collapsed_3843_);
if (v___x_3878_ == 0)
{
lean_dec_ref_known(v___x_3884_, 1);
lean_dec(v_snd_3876_);
lean_dec(v_fst_3875_);
lean_dec_ref(v_tag_3844_);
lean_dec(v_cls_3842_);
v___y_3862_ = v___y_3880_;
v___y_3863_ = v_a_3881_;
v_data_3864_ = v_data_3886_;
goto v___jp_3861_;
}
else
{
lean_object* v_data_3887_; double v___x_3888_; double v___x_3889_; 
lean_dec_ref_known(v_data_3886_, 3);
v_data_3887_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v_data_3887_, 0, v_cls_3842_);
lean_ctor_set(v_data_3887_, 1, v___x_3884_);
lean_ctor_set(v_data_3887_, 2, v_tag_3844_);
v___x_3888_ = lean_unbox_float(v_fst_3875_);
lean_dec(v_fst_3875_);
lean_ctor_set_float(v_data_3887_, sizeof(void*)*3, v___x_3888_);
v___x_3889_ = lean_unbox_float(v_snd_3876_);
lean_dec(v_snd_3876_);
lean_ctor_set_float(v_data_3887_, sizeof(void*)*3 + 8, v___x_3889_);
lean_ctor_set_uint8(v_data_3887_, sizeof(void*)*3 + 16, v_collapsed_3843_);
v___y_3862_ = v___y_3880_;
v___y_3863_ = v_a_3881_;
v_data_3864_ = v_data_3887_;
goto v___jp_3861_;
}
}
v___jp_3890_:
{
lean_object* v_ref_3891_; lean_object* v___x_3892_; 
v_ref_3891_ = lean_ctor_get(v___y_3856_, 5);
lean_inc(v___y_3857_);
lean_inc_ref(v___y_3856_);
lean_inc(v___y_3855_);
lean_inc_ref(v___y_3854_);
lean_inc(v___y_3853_);
lean_inc_ref(v___y_3852_);
lean_inc(v___y_3851_);
lean_inc_ref(v___y_3850_);
lean_inc(v_fst_3859_);
v___x_3892_ = lean_apply_10(v_msg_3848_, v_fst_3859_, v___y_3850_, v___y_3851_, v___y_3852_, v___y_3853_, v___y_3854_, v___y_3855_, v___y_3856_, v___y_3857_, lean_box(0));
if (lean_obj_tag(v___x_3892_) == 0)
{
lean_object* v_a_3893_; 
v_a_3893_ = lean_ctor_get(v___x_3892_, 0);
lean_inc(v_a_3893_);
lean_dec_ref_known(v___x_3892_, 1);
v___y_3880_ = v_ref_3891_;
v_a_3881_ = v_a_3893_;
goto v___jp_3879_;
}
else
{
lean_object* v___x_3894_; 
lean_dec_ref_known(v___x_3892_, 1);
v___x_3894_ = lean_obj_once(&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__2, &l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__2_once, _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__2);
v___y_3880_ = v_ref_3891_;
v_a_3881_ = v___x_3894_;
goto v___jp_3879_;
}
}
v___jp_3895_:
{
if (v_clsEnabled_3846_ == 0)
{
if (v___y_3896_ == 0)
{
lean_object* v___x_3897_; lean_object* v_traceState_3898_; lean_object* v_env_3899_; lean_object* v_nextMacroScope_3900_; lean_object* v_ngen_3901_; lean_object* v_auxDeclNGen_3902_; lean_object* v_cache_3903_; lean_object* v_messages_3904_; lean_object* v_infoState_3905_; lean_object* v_snapshotTasks_3906_; lean_object* v___x_3908_; uint8_t v_isShared_3909_; uint8_t v_isSharedCheck_3925_; 
lean_dec(v_snd_3876_);
lean_dec(v_fst_3875_);
lean_dec_ref(v_msg_3848_);
lean_dec_ref(v_tag_3844_);
lean_dec(v_cls_3842_);
v___x_3897_ = lean_st_ref_take(v___y_3857_);
v_traceState_3898_ = lean_ctor_get(v___x_3897_, 4);
v_env_3899_ = lean_ctor_get(v___x_3897_, 0);
v_nextMacroScope_3900_ = lean_ctor_get(v___x_3897_, 1);
v_ngen_3901_ = lean_ctor_get(v___x_3897_, 2);
v_auxDeclNGen_3902_ = lean_ctor_get(v___x_3897_, 3);
v_cache_3903_ = lean_ctor_get(v___x_3897_, 5);
v_messages_3904_ = lean_ctor_get(v___x_3897_, 6);
v_infoState_3905_ = lean_ctor_get(v___x_3897_, 7);
v_snapshotTasks_3906_ = lean_ctor_get(v___x_3897_, 8);
v_isSharedCheck_3925_ = !lean_is_exclusive(v___x_3897_);
if (v_isSharedCheck_3925_ == 0)
{
v___x_3908_ = v___x_3897_;
v_isShared_3909_ = v_isSharedCheck_3925_;
goto v_resetjp_3907_;
}
else
{
lean_inc(v_snapshotTasks_3906_);
lean_inc(v_infoState_3905_);
lean_inc(v_messages_3904_);
lean_inc(v_cache_3903_);
lean_inc(v_traceState_3898_);
lean_inc(v_auxDeclNGen_3902_);
lean_inc(v_ngen_3901_);
lean_inc(v_nextMacroScope_3900_);
lean_inc(v_env_3899_);
lean_dec(v___x_3897_);
v___x_3908_ = lean_box(0);
v_isShared_3909_ = v_isSharedCheck_3925_;
goto v_resetjp_3907_;
}
v_resetjp_3907_:
{
uint64_t v_tid_3910_; lean_object* v_traces_3911_; lean_object* v___x_3913_; uint8_t v_isShared_3914_; uint8_t v_isSharedCheck_3924_; 
v_tid_3910_ = lean_ctor_get_uint64(v_traceState_3898_, sizeof(void*)*1);
v_traces_3911_ = lean_ctor_get(v_traceState_3898_, 0);
v_isSharedCheck_3924_ = !lean_is_exclusive(v_traceState_3898_);
if (v_isSharedCheck_3924_ == 0)
{
v___x_3913_ = v_traceState_3898_;
v_isShared_3914_ = v_isSharedCheck_3924_;
goto v_resetjp_3912_;
}
else
{
lean_inc(v_traces_3911_);
lean_dec(v_traceState_3898_);
v___x_3913_ = lean_box(0);
v_isShared_3914_ = v_isSharedCheck_3924_;
goto v_resetjp_3912_;
}
v_resetjp_3912_:
{
lean_object* v___x_3915_; lean_object* v___x_3917_; 
v___x_3915_ = l_Lean_PersistentArray_append___redArg(v_oldTraces_3847_, v_traces_3911_);
lean_dec_ref(v_traces_3911_);
if (v_isShared_3914_ == 0)
{
lean_ctor_set(v___x_3913_, 0, v___x_3915_);
v___x_3917_ = v___x_3913_;
goto v_reusejp_3916_;
}
else
{
lean_object* v_reuseFailAlloc_3923_; 
v_reuseFailAlloc_3923_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_3923_, 0, v___x_3915_);
lean_ctor_set_uint64(v_reuseFailAlloc_3923_, sizeof(void*)*1, v_tid_3910_);
v___x_3917_ = v_reuseFailAlloc_3923_;
goto v_reusejp_3916_;
}
v_reusejp_3916_:
{
lean_object* v___x_3919_; 
if (v_isShared_3909_ == 0)
{
lean_ctor_set(v___x_3908_, 4, v___x_3917_);
v___x_3919_ = v___x_3908_;
goto v_reusejp_3918_;
}
else
{
lean_object* v_reuseFailAlloc_3922_; 
v_reuseFailAlloc_3922_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_3922_, 0, v_env_3899_);
lean_ctor_set(v_reuseFailAlloc_3922_, 1, v_nextMacroScope_3900_);
lean_ctor_set(v_reuseFailAlloc_3922_, 2, v_ngen_3901_);
lean_ctor_set(v_reuseFailAlloc_3922_, 3, v_auxDeclNGen_3902_);
lean_ctor_set(v_reuseFailAlloc_3922_, 4, v___x_3917_);
lean_ctor_set(v_reuseFailAlloc_3922_, 5, v_cache_3903_);
lean_ctor_set(v_reuseFailAlloc_3922_, 6, v_messages_3904_);
lean_ctor_set(v_reuseFailAlloc_3922_, 7, v_infoState_3905_);
lean_ctor_set(v_reuseFailAlloc_3922_, 8, v_snapshotTasks_3906_);
v___x_3919_ = v_reuseFailAlloc_3922_;
goto v_reusejp_3918_;
}
v_reusejp_3918_:
{
lean_object* v___x_3920_; lean_object* v___x_3921_; 
v___x_3920_ = lean_st_ref_set(v___y_3857_, v___x_3919_);
v___x_3921_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___redArg(v_fst_3859_);
return v___x_3921_;
}
}
}
}
}
else
{
goto v___jp_3890_;
}
}
else
{
goto v___jp_3890_;
}
}
v___jp_3926_:
{
double v___x_3928_; double v___x_3929_; double v___x_3930_; uint8_t v___x_3931_; 
v___x_3928_ = lean_unbox_float(v_snd_3876_);
v___x_3929_ = lean_unbox_float(v_fst_3875_);
v___x_3930_ = lean_float_sub(v___x_3928_, v___x_3929_);
v___x_3931_ = lean_float_decLt(v___y_3927_, v___x_3930_);
v___y_3896_ = v___x_3931_;
goto v___jp_3895_;
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___boxed(lean_object** _args){
lean_object* v_cls_3942_ = _args[0];
lean_object* v_collapsed_3943_ = _args[1];
lean_object* v_tag_3944_ = _args[2];
lean_object* v_opts_3945_ = _args[3];
lean_object* v_clsEnabled_3946_ = _args[4];
lean_object* v_oldTraces_3947_ = _args[5];
lean_object* v_msg_3948_ = _args[6];
lean_object* v_resStartStop_3949_ = _args[7];
lean_object* v___y_3950_ = _args[8];
lean_object* v___y_3951_ = _args[9];
lean_object* v___y_3952_ = _args[10];
lean_object* v___y_3953_ = _args[11];
lean_object* v___y_3954_ = _args[12];
lean_object* v___y_3955_ = _args[13];
lean_object* v___y_3956_ = _args[14];
lean_object* v___y_3957_ = _args[15];
lean_object* v___y_3958_ = _args[16];
_start:
{
uint8_t v_collapsed_boxed_3959_; uint8_t v_clsEnabled_boxed_3960_; lean_object* v_res_3961_; 
v_collapsed_boxed_3959_ = lean_unbox(v_collapsed_3943_);
v_clsEnabled_boxed_3960_ = lean_unbox(v_clsEnabled_3946_);
v_res_3961_ = l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3(v_cls_3942_, v_collapsed_boxed_3959_, v_tag_3944_, v_opts_3945_, v_clsEnabled_boxed_3960_, v_oldTraces_3947_, v_msg_3948_, v_resStartStop_3949_, v___y_3950_, v___y_3951_, v___y_3952_, v___y_3953_, v___y_3954_, v___y_3955_, v___y_3956_, v___y_3957_);
lean_dec(v___y_3957_);
lean_dec_ref(v___y_3956_);
lean_dec(v___y_3955_);
lean_dec_ref(v___y_3954_);
lean_dec(v___y_3953_);
lean_dec_ref(v___y_3952_);
lean_dec(v___y_3951_);
lean_dec_ref(v___y_3950_);
lean_dec_ref(v_opts_3945_);
return v_res_3961_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg(lean_object* v_cls_3964_, lean_object* v_msg_3965_, lean_object* v___y_3966_, lean_object* v___y_3967_, lean_object* v___y_3968_, lean_object* v___y_3969_){
_start:
{
lean_object* v_ref_3971_; lean_object* v___x_3972_; lean_object* v_a_3973_; lean_object* v___x_3975_; uint8_t v_isShared_3976_; uint8_t v_isSharedCheck_4017_; 
v_ref_3971_ = lean_ctor_get(v___y_3968_, 5);
v___x_3972_ = l_Lean_addMessageContextFull___at___00Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0_spec__0(v_msg_3965_, v___y_3966_, v___y_3967_, v___y_3968_, v___y_3969_);
v_a_3973_ = lean_ctor_get(v___x_3972_, 0);
v_isSharedCheck_4017_ = !lean_is_exclusive(v___x_3972_);
if (v_isSharedCheck_4017_ == 0)
{
v___x_3975_ = v___x_3972_;
v_isShared_3976_ = v_isSharedCheck_4017_;
goto v_resetjp_3974_;
}
else
{
lean_inc(v_a_3973_);
lean_dec(v___x_3972_);
v___x_3975_ = lean_box(0);
v_isShared_3976_ = v_isSharedCheck_4017_;
goto v_resetjp_3974_;
}
v_resetjp_3974_:
{
lean_object* v___x_3977_; lean_object* v_traceState_3978_; lean_object* v_env_3979_; lean_object* v_nextMacroScope_3980_; lean_object* v_ngen_3981_; lean_object* v_auxDeclNGen_3982_; lean_object* v_cache_3983_; lean_object* v_messages_3984_; lean_object* v_infoState_3985_; lean_object* v_snapshotTasks_3986_; lean_object* v___x_3988_; uint8_t v_isShared_3989_; uint8_t v_isSharedCheck_4016_; 
v___x_3977_ = lean_st_ref_take(v___y_3969_);
v_traceState_3978_ = lean_ctor_get(v___x_3977_, 4);
v_env_3979_ = lean_ctor_get(v___x_3977_, 0);
v_nextMacroScope_3980_ = lean_ctor_get(v___x_3977_, 1);
v_ngen_3981_ = lean_ctor_get(v___x_3977_, 2);
v_auxDeclNGen_3982_ = lean_ctor_get(v___x_3977_, 3);
v_cache_3983_ = lean_ctor_get(v___x_3977_, 5);
v_messages_3984_ = lean_ctor_get(v___x_3977_, 6);
v_infoState_3985_ = lean_ctor_get(v___x_3977_, 7);
v_snapshotTasks_3986_ = lean_ctor_get(v___x_3977_, 8);
v_isSharedCheck_4016_ = !lean_is_exclusive(v___x_3977_);
if (v_isSharedCheck_4016_ == 0)
{
v___x_3988_ = v___x_3977_;
v_isShared_3989_ = v_isSharedCheck_4016_;
goto v_resetjp_3987_;
}
else
{
lean_inc(v_snapshotTasks_3986_);
lean_inc(v_infoState_3985_);
lean_inc(v_messages_3984_);
lean_inc(v_cache_3983_);
lean_inc(v_traceState_3978_);
lean_inc(v_auxDeclNGen_3982_);
lean_inc(v_ngen_3981_);
lean_inc(v_nextMacroScope_3980_);
lean_inc(v_env_3979_);
lean_dec(v___x_3977_);
v___x_3988_ = lean_box(0);
v_isShared_3989_ = v_isSharedCheck_4016_;
goto v_resetjp_3987_;
}
v_resetjp_3987_:
{
uint64_t v_tid_3990_; lean_object* v_traces_3991_; lean_object* v___x_3993_; uint8_t v_isShared_3994_; uint8_t v_isSharedCheck_4015_; 
v_tid_3990_ = lean_ctor_get_uint64(v_traceState_3978_, sizeof(void*)*1);
v_traces_3991_ = lean_ctor_get(v_traceState_3978_, 0);
v_isSharedCheck_4015_ = !lean_is_exclusive(v_traceState_3978_);
if (v_isSharedCheck_4015_ == 0)
{
v___x_3993_ = v_traceState_3978_;
v_isShared_3994_ = v_isSharedCheck_4015_;
goto v_resetjp_3992_;
}
else
{
lean_inc(v_traces_3991_);
lean_dec(v_traceState_3978_);
v___x_3993_ = lean_box(0);
v_isShared_3994_ = v_isSharedCheck_4015_;
goto v_resetjp_3992_;
}
v_resetjp_3992_:
{
lean_object* v___x_3995_; double v___x_3996_; uint8_t v___x_3997_; lean_object* v___x_3998_; lean_object* v___x_3999_; lean_object* v___x_4000_; lean_object* v___x_4001_; lean_object* v___x_4002_; lean_object* v___x_4003_; lean_object* v___x_4005_; 
v___x_3995_ = lean_box(0);
v___x_3996_ = lean_float_once(&l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__0, &l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__0_once, _init_l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3___closed__0);
v___x_3997_ = 0;
v___x_3998_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__10));
v___x_3999_ = lean_alloc_ctor(0, 3, 17);
lean_ctor_set(v___x_3999_, 0, v_cls_3964_);
lean_ctor_set(v___x_3999_, 1, v___x_3995_);
lean_ctor_set(v___x_3999_, 2, v___x_3998_);
lean_ctor_set_float(v___x_3999_, sizeof(void*)*3, v___x_3996_);
lean_ctor_set_float(v___x_3999_, sizeof(void*)*3 + 8, v___x_3996_);
lean_ctor_set_uint8(v___x_3999_, sizeof(void*)*3 + 16, v___x_3997_);
v___x_4000_ = ((lean_object*)(l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg___closed__0));
v___x_4001_ = lean_alloc_ctor(9, 3, 0);
lean_ctor_set(v___x_4001_, 0, v___x_3999_);
lean_ctor_set(v___x_4001_, 1, v_a_3973_);
lean_ctor_set(v___x_4001_, 2, v___x_4000_);
lean_inc(v_ref_3971_);
v___x_4002_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_4002_, 0, v_ref_3971_);
lean_ctor_set(v___x_4002_, 1, v___x_4001_);
v___x_4003_ = l_Lean_PersistentArray_push___redArg(v_traces_3991_, v___x_4002_);
if (v_isShared_3994_ == 0)
{
lean_ctor_set(v___x_3993_, 0, v___x_4003_);
v___x_4005_ = v___x_3993_;
goto v_reusejp_4004_;
}
else
{
lean_object* v_reuseFailAlloc_4014_; 
v_reuseFailAlloc_4014_ = lean_alloc_ctor(0, 1, 8);
lean_ctor_set(v_reuseFailAlloc_4014_, 0, v___x_4003_);
lean_ctor_set_uint64(v_reuseFailAlloc_4014_, sizeof(void*)*1, v_tid_3990_);
v___x_4005_ = v_reuseFailAlloc_4014_;
goto v_reusejp_4004_;
}
v_reusejp_4004_:
{
lean_object* v___x_4007_; 
if (v_isShared_3989_ == 0)
{
lean_ctor_set(v___x_3988_, 4, v___x_4005_);
v___x_4007_ = v___x_3988_;
goto v_reusejp_4006_;
}
else
{
lean_object* v_reuseFailAlloc_4013_; 
v_reuseFailAlloc_4013_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_4013_, 0, v_env_3979_);
lean_ctor_set(v_reuseFailAlloc_4013_, 1, v_nextMacroScope_3980_);
lean_ctor_set(v_reuseFailAlloc_4013_, 2, v_ngen_3981_);
lean_ctor_set(v_reuseFailAlloc_4013_, 3, v_auxDeclNGen_3982_);
lean_ctor_set(v_reuseFailAlloc_4013_, 4, v___x_4005_);
lean_ctor_set(v_reuseFailAlloc_4013_, 5, v_cache_3983_);
lean_ctor_set(v_reuseFailAlloc_4013_, 6, v_messages_3984_);
lean_ctor_set(v_reuseFailAlloc_4013_, 7, v_infoState_3985_);
lean_ctor_set(v_reuseFailAlloc_4013_, 8, v_snapshotTasks_3986_);
v___x_4007_ = v_reuseFailAlloc_4013_;
goto v_reusejp_4006_;
}
v_reusejp_4006_:
{
lean_object* v___x_4008_; lean_object* v___x_4009_; lean_object* v___x_4011_; 
v___x_4008_ = lean_st_ref_set(v___y_3969_, v___x_4007_);
v___x_4009_ = lean_box(0);
if (v_isShared_3976_ == 0)
{
lean_ctor_set(v___x_3975_, 0, v___x_4009_);
v___x_4011_ = v___x_3975_;
goto v_reusejp_4010_;
}
else
{
lean_object* v_reuseFailAlloc_4012_; 
v_reuseFailAlloc_4012_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4012_, 0, v___x_4009_);
v___x_4011_ = v_reuseFailAlloc_4012_;
goto v_reusejp_4010_;
}
v_reusejp_4010_:
{
return v___x_4011_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg___boxed(lean_object* v_cls_4018_, lean_object* v_msg_4019_, lean_object* v___y_4020_, lean_object* v___y_4021_, lean_object* v___y_4022_, lean_object* v___y_4023_, lean_object* v___y_4024_){
_start:
{
lean_object* v_res_4025_; 
v_res_4025_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg(v_cls_4018_, v_msg_4019_, v___y_4020_, v___y_4021_, v___y_4022_, v___y_4023_);
lean_dec(v___y_4023_);
lean_dec_ref(v___y_4022_);
lean_dec(v___y_4021_);
lean_dec_ref(v___y_4020_);
return v_res_4025_;
}
}
static lean_object* _init_l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__2(void){
_start:
{
lean_object* v___x_4030_; lean_object* v___x_4031_; 
v___x_4030_ = ((lean_object*)(l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__1));
v___x_4031_ = l_Lean_stringToMessageData(v___x_4030_);
return v___x_4031_;
}
}
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg(lean_object* v_as_x27_4032_, lean_object* v_b_4033_, lean_object* v___y_4034_, lean_object* v___y_4035_, lean_object* v___y_4036_, lean_object* v___y_4037_, lean_object* v___y_4038_, lean_object* v___y_4039_, lean_object* v___y_4040_, lean_object* v___y_4041_){
_start:
{
if (lean_obj_tag(v_as_x27_4032_) == 0)
{
lean_object* v___x_4043_; 
v___x_4043_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_4043_, 0, v_b_4033_);
return v___x_4043_;
}
else
{
lean_object* v_head_4044_; lean_object* v_options_4045_; lean_object* v_tail_4046_; lean_object* v_name_4047_; lean_object* v_run_x27_4048_; lean_object* v_inheritedTraceOptions_4049_; uint8_t v_hasTrace_4050_; lean_object* v___x_4051_; uint8_t v___y_4053_; lean_object* v___x_4058_; lean_object* v___y_4060_; 
lean_dec_ref(v_b_4033_);
v_head_4044_ = lean_ctor_get(v_as_x27_4032_, 0);
v_options_4045_ = lean_ctor_get(v___y_4040_, 2);
v_tail_4046_ = lean_ctor_get(v_as_x27_4032_, 1);
v_name_4047_ = lean_ctor_get(v_head_4044_, 0);
v_run_x27_4048_ = lean_ctor_get(v_head_4044_, 1);
v_inheritedTraceOptions_4049_ = lean_ctor_get(v___y_4040_, 13);
v_hasTrace_4050_ = lean_ctor_get_uint8(v_options_4045_, sizeof(void*)*1);
v___x_4051_ = lean_box(0);
v___x_4058_ = ((lean_object*)(l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__0));
if (v_hasTrace_4050_ == 0)
{
lean_object* v___x_4088_; 
lean_inc_ref(v_run_x27_4048_);
lean_inc(v___y_4041_);
lean_inc_ref(v___y_4040_);
lean_inc(v___y_4039_);
lean_inc_ref(v___y_4038_);
lean_inc(v___y_4037_);
lean_inc_ref(v___y_4036_);
lean_inc(v___y_4035_);
lean_inc_ref(v___y_4034_);
v___x_4088_ = lean_apply_9(v_run_x27_4048_, v___y_4034_, v___y_4035_, v___y_4036_, v___y_4037_, v___y_4038_, v___y_4039_, v___y_4040_, v___y_4041_, lean_box(0));
v___y_4060_ = v___x_4088_;
goto v___jp_4059_;
}
else
{
lean_object* v___f_4089_; lean_object* v___x_4090_; lean_object* v___x_4091_; lean_object* v___x_4092_; uint8_t v___x_4093_; lean_object* v___y_4095_; lean_object* v___y_4096_; lean_object* v_a_4097_; lean_object* v___y_4110_; lean_object* v___y_4111_; lean_object* v_a_4112_; 
lean_inc(v_name_4047_);
v___f_4089_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___lam__0___boxed), 11, 1);
lean_closure_set(v___f_4089_, 0, v_name_4047_);
v___x_4090_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
v___x_4091_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__10));
v___x_4092_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14);
v___x_4093_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_4049_, v_options_4045_, v___x_4092_);
if (v___x_4093_ == 0)
{
lean_object* v___x_4162_; uint8_t v___x_4163_; 
v___x_4162_ = l_Lean_trace_profiler;
v___x_4163_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__2(v_options_4045_, v___x_4162_);
if (v___x_4163_ == 0)
{
lean_object* v___x_4164_; 
lean_dec_ref(v___f_4089_);
lean_inc_ref(v_run_x27_4048_);
lean_inc(v___y_4041_);
lean_inc_ref(v___y_4040_);
lean_inc(v___y_4039_);
lean_inc_ref(v___y_4038_);
lean_inc(v___y_4037_);
lean_inc_ref(v___y_4036_);
lean_inc(v___y_4035_);
lean_inc_ref(v___y_4034_);
v___x_4164_ = lean_apply_9(v_run_x27_4048_, v___y_4034_, v___y_4035_, v___y_4036_, v___y_4037_, v___y_4038_, v___y_4039_, v___y_4040_, v___y_4041_, lean_box(0));
v___y_4060_ = v___x_4164_;
goto v___jp_4059_;
}
else
{
goto v___jp_4121_;
}
}
else
{
goto v___jp_4121_;
}
v___jp_4094_:
{
lean_object* v___x_4098_; double v___x_4099_; double v___x_4100_; double v___x_4101_; double v___x_4102_; double v___x_4103_; lean_object* v___x_4104_; lean_object* v___x_4105_; lean_object* v___x_4106_; lean_object* v___x_4107_; lean_object* v___x_4108_; 
v___x_4098_ = lean_io_mono_nanos_now();
v___x_4099_ = lean_float_of_nat(v___y_4096_);
v___x_4100_ = lean_float_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__11, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__11_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_run___closed__11);
v___x_4101_ = lean_float_div(v___x_4099_, v___x_4100_);
v___x_4102_ = lean_float_of_nat(v___x_4098_);
v___x_4103_ = lean_float_div(v___x_4102_, v___x_4100_);
v___x_4104_ = lean_box_float(v___x_4101_);
v___x_4105_ = lean_box_float(v___x_4103_);
v___x_4106_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_4106_, 0, v___x_4104_);
lean_ctor_set(v___x_4106_, 1, v___x_4105_);
v___x_4107_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_4107_, 0, v_a_4097_);
lean_ctor_set(v___x_4107_, 1, v___x_4106_);
v___x_4108_ = l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3(v___x_4090_, v_hasTrace_4050_, v___x_4091_, v_options_4045_, v___x_4093_, v___y_4095_, v___f_4089_, v___x_4107_, v___y_4034_, v___y_4035_, v___y_4036_, v___y_4037_, v___y_4038_, v___y_4039_, v___y_4040_, v___y_4041_);
v___y_4060_ = v___x_4108_;
goto v___jp_4059_;
}
v___jp_4109_:
{
lean_object* v___x_4113_; double v___x_4114_; double v___x_4115_; lean_object* v___x_4116_; lean_object* v___x_4117_; lean_object* v___x_4118_; lean_object* v___x_4119_; lean_object* v___x_4120_; 
v___x_4113_ = lean_io_get_num_heartbeats();
v___x_4114_ = lean_float_of_nat(v___y_4111_);
v___x_4115_ = lean_float_of_nat(v___x_4113_);
v___x_4116_ = lean_box_float(v___x_4114_);
v___x_4117_ = lean_box_float(v___x_4115_);
v___x_4118_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_4118_, 0, v___x_4116_);
lean_ctor_set(v___x_4118_, 1, v___x_4117_);
v___x_4119_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_4119_, 0, v_a_4112_);
lean_ctor_set(v___x_4119_, 1, v___x_4118_);
v___x_4120_ = l___private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3(v___x_4090_, v_hasTrace_4050_, v___x_4091_, v_options_4045_, v___x_4093_, v___y_4110_, v___f_4089_, v___x_4119_, v___y_4034_, v___y_4035_, v___y_4036_, v___y_4037_, v___y_4038_, v___y_4039_, v___y_4040_, v___y_4041_);
v___y_4060_ = v___x_4120_;
goto v___jp_4059_;
}
v___jp_4121_:
{
lean_object* v___x_4122_; lean_object* v_a_4123_; lean_object* v___x_4124_; uint8_t v___x_4125_; 
v___x_4122_ = l___private_Lean_Util_Trace_0__Lean_getResetTraces___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__1___redArg(v___y_4041_);
v_a_4123_ = lean_ctor_get(v___x_4122_, 0);
lean_inc(v_a_4123_);
lean_dec_ref(v___x_4122_);
v___x_4124_ = l_Lean_trace_profiler_useHeartbeats;
v___x_4125_ = l_Lean_Option_get___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__2(v_options_4045_, v___x_4124_);
if (v___x_4125_ == 0)
{
lean_object* v___x_4126_; lean_object* v___x_4127_; 
v___x_4126_ = lean_io_mono_nanos_now();
lean_inc_ref(v_run_x27_4048_);
lean_inc(v___y_4041_);
lean_inc_ref(v___y_4040_);
lean_inc(v___y_4039_);
lean_inc_ref(v___y_4038_);
lean_inc(v___y_4037_);
lean_inc_ref(v___y_4036_);
lean_inc(v___y_4035_);
lean_inc_ref(v___y_4034_);
v___x_4127_ = lean_apply_9(v_run_x27_4048_, v___y_4034_, v___y_4035_, v___y_4036_, v___y_4037_, v___y_4038_, v___y_4039_, v___y_4040_, v___y_4041_, lean_box(0));
if (lean_obj_tag(v___x_4127_) == 0)
{
lean_object* v_a_4128_; lean_object* v___x_4130_; uint8_t v_isShared_4131_; uint8_t v_isSharedCheck_4135_; 
v_a_4128_ = lean_ctor_get(v___x_4127_, 0);
v_isSharedCheck_4135_ = !lean_is_exclusive(v___x_4127_);
if (v_isSharedCheck_4135_ == 0)
{
v___x_4130_ = v___x_4127_;
v_isShared_4131_ = v_isSharedCheck_4135_;
goto v_resetjp_4129_;
}
else
{
lean_inc(v_a_4128_);
lean_dec(v___x_4127_);
v___x_4130_ = lean_box(0);
v_isShared_4131_ = v_isSharedCheck_4135_;
goto v_resetjp_4129_;
}
v_resetjp_4129_:
{
lean_object* v___x_4133_; 
if (v_isShared_4131_ == 0)
{
lean_ctor_set_tag(v___x_4130_, 1);
v___x_4133_ = v___x_4130_;
goto v_reusejp_4132_;
}
else
{
lean_object* v_reuseFailAlloc_4134_; 
v_reuseFailAlloc_4134_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4134_, 0, v_a_4128_);
v___x_4133_ = v_reuseFailAlloc_4134_;
goto v_reusejp_4132_;
}
v_reusejp_4132_:
{
v___y_4095_ = v_a_4123_;
v___y_4096_ = v___x_4126_;
v_a_4097_ = v___x_4133_;
goto v___jp_4094_;
}
}
}
else
{
lean_object* v_a_4136_; lean_object* v___x_4138_; uint8_t v_isShared_4139_; uint8_t v_isSharedCheck_4143_; 
v_a_4136_ = lean_ctor_get(v___x_4127_, 0);
v_isSharedCheck_4143_ = !lean_is_exclusive(v___x_4127_);
if (v_isSharedCheck_4143_ == 0)
{
v___x_4138_ = v___x_4127_;
v_isShared_4139_ = v_isSharedCheck_4143_;
goto v_resetjp_4137_;
}
else
{
lean_inc(v_a_4136_);
lean_dec(v___x_4127_);
v___x_4138_ = lean_box(0);
v_isShared_4139_ = v_isSharedCheck_4143_;
goto v_resetjp_4137_;
}
v_resetjp_4137_:
{
lean_object* v___x_4141_; 
if (v_isShared_4139_ == 0)
{
lean_ctor_set_tag(v___x_4138_, 0);
v___x_4141_ = v___x_4138_;
goto v_reusejp_4140_;
}
else
{
lean_object* v_reuseFailAlloc_4142_; 
v_reuseFailAlloc_4142_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4142_, 0, v_a_4136_);
v___x_4141_ = v_reuseFailAlloc_4142_;
goto v_reusejp_4140_;
}
v_reusejp_4140_:
{
v___y_4095_ = v_a_4123_;
v___y_4096_ = v___x_4126_;
v_a_4097_ = v___x_4141_;
goto v___jp_4094_;
}
}
}
}
else
{
lean_object* v___x_4144_; lean_object* v___x_4145_; 
v___x_4144_ = lean_io_get_num_heartbeats();
lean_inc_ref(v_run_x27_4048_);
lean_inc(v___y_4041_);
lean_inc_ref(v___y_4040_);
lean_inc(v___y_4039_);
lean_inc_ref(v___y_4038_);
lean_inc(v___y_4037_);
lean_inc_ref(v___y_4036_);
lean_inc(v___y_4035_);
lean_inc_ref(v___y_4034_);
v___x_4145_ = lean_apply_9(v_run_x27_4048_, v___y_4034_, v___y_4035_, v___y_4036_, v___y_4037_, v___y_4038_, v___y_4039_, v___y_4040_, v___y_4041_, lean_box(0));
if (lean_obj_tag(v___x_4145_) == 0)
{
lean_object* v_a_4146_; lean_object* v___x_4148_; uint8_t v_isShared_4149_; uint8_t v_isSharedCheck_4153_; 
v_a_4146_ = lean_ctor_get(v___x_4145_, 0);
v_isSharedCheck_4153_ = !lean_is_exclusive(v___x_4145_);
if (v_isSharedCheck_4153_ == 0)
{
v___x_4148_ = v___x_4145_;
v_isShared_4149_ = v_isSharedCheck_4153_;
goto v_resetjp_4147_;
}
else
{
lean_inc(v_a_4146_);
lean_dec(v___x_4145_);
v___x_4148_ = lean_box(0);
v_isShared_4149_ = v_isSharedCheck_4153_;
goto v_resetjp_4147_;
}
v_resetjp_4147_:
{
lean_object* v___x_4151_; 
if (v_isShared_4149_ == 0)
{
lean_ctor_set_tag(v___x_4148_, 1);
v___x_4151_ = v___x_4148_;
goto v_reusejp_4150_;
}
else
{
lean_object* v_reuseFailAlloc_4152_; 
v_reuseFailAlloc_4152_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4152_, 0, v_a_4146_);
v___x_4151_ = v_reuseFailAlloc_4152_;
goto v_reusejp_4150_;
}
v_reusejp_4150_:
{
v___y_4110_ = v_a_4123_;
v___y_4111_ = v___x_4144_;
v_a_4112_ = v___x_4151_;
goto v___jp_4109_;
}
}
}
else
{
lean_object* v_a_4154_; lean_object* v___x_4156_; uint8_t v_isShared_4157_; uint8_t v_isSharedCheck_4161_; 
v_a_4154_ = lean_ctor_get(v___x_4145_, 0);
v_isSharedCheck_4161_ = !lean_is_exclusive(v___x_4145_);
if (v_isSharedCheck_4161_ == 0)
{
v___x_4156_ = v___x_4145_;
v_isShared_4157_ = v_isSharedCheck_4161_;
goto v_resetjp_4155_;
}
else
{
lean_inc(v_a_4154_);
lean_dec(v___x_4145_);
v___x_4156_ = lean_box(0);
v_isShared_4157_ = v_isSharedCheck_4161_;
goto v_resetjp_4155_;
}
v_resetjp_4155_:
{
lean_object* v___x_4159_; 
if (v_isShared_4157_ == 0)
{
lean_ctor_set_tag(v___x_4156_, 0);
v___x_4159_ = v___x_4156_;
goto v_reusejp_4158_;
}
else
{
lean_object* v_reuseFailAlloc_4160_; 
v_reuseFailAlloc_4160_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4160_, 0, v_a_4154_);
v___x_4159_ = v_reuseFailAlloc_4160_;
goto v_reusejp_4158_;
}
v_reusejp_4158_:
{
v___y_4110_ = v_a_4123_;
v___y_4111_ = v___x_4144_;
v_a_4112_ = v___x_4159_;
goto v___jp_4109_;
}
}
}
}
}
}
v___jp_4052_:
{
lean_object* v___x_4054_; lean_object* v___x_4055_; lean_object* v___x_4056_; lean_object* v___x_4057_; 
v___x_4054_ = lean_box(v___y_4053_);
v___x_4055_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_4055_, 0, v___x_4054_);
v___x_4056_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_4056_, 0, v___x_4055_);
lean_ctor_set(v___x_4056_, 1, v___x_4051_);
v___x_4057_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_4057_, 0, v___x_4056_);
return v___x_4057_;
}
v___jp_4059_:
{
if (lean_obj_tag(v___y_4060_) == 0)
{
lean_object* v_a_4061_; uint8_t v___x_4062_; 
v_a_4061_ = lean_ctor_get(v___y_4060_, 0);
lean_inc(v_a_4061_);
lean_dec_ref_known(v___y_4060_, 1);
v___x_4062_ = lean_unbox(v_a_4061_);
if (v___x_4062_ == 0)
{
lean_dec(v_a_4061_);
v_as_x27_4032_ = v_tail_4046_;
v_b_4033_ = v___x_4058_;
goto _start;
}
else
{
if (v_hasTrace_4050_ == 0)
{
uint8_t v___x_4064_; 
v___x_4064_ = lean_unbox(v_a_4061_);
lean_dec(v_a_4061_);
v___y_4053_ = v___x_4064_;
goto v___jp_4052_;
}
else
{
lean_object* v___x_4065_; lean_object* v___x_4066_; uint8_t v___x_4067_; 
v___x_4065_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
v___x_4066_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14);
v___x_4067_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_4049_, v_options_4045_, v___x_4066_);
if (v___x_4067_ == 0)
{
uint8_t v___x_4068_; 
v___x_4068_ = lean_unbox(v_a_4061_);
lean_dec(v_a_4061_);
v___y_4053_ = v___x_4068_;
goto v___jp_4052_;
}
else
{
lean_object* v___x_4069_; lean_object* v___x_4070_; 
v___x_4069_ = lean_obj_once(&l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__2, &l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__2_once, _init_l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__2);
v___x_4070_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg(v___x_4065_, v___x_4069_, v___y_4038_, v___y_4039_, v___y_4040_, v___y_4041_);
if (lean_obj_tag(v___x_4070_) == 0)
{
uint8_t v___x_4071_; 
lean_dec_ref_known(v___x_4070_, 1);
v___x_4071_ = lean_unbox(v_a_4061_);
lean_dec(v_a_4061_);
v___y_4053_ = v___x_4071_;
goto v___jp_4052_;
}
else
{
lean_object* v_a_4072_; lean_object* v___x_4074_; uint8_t v_isShared_4075_; uint8_t v_isSharedCheck_4079_; 
lean_dec(v_a_4061_);
v_a_4072_ = lean_ctor_get(v___x_4070_, 0);
v_isSharedCheck_4079_ = !lean_is_exclusive(v___x_4070_);
if (v_isSharedCheck_4079_ == 0)
{
v___x_4074_ = v___x_4070_;
v_isShared_4075_ = v_isSharedCheck_4079_;
goto v_resetjp_4073_;
}
else
{
lean_inc(v_a_4072_);
lean_dec(v___x_4070_);
v___x_4074_ = lean_box(0);
v_isShared_4075_ = v_isSharedCheck_4079_;
goto v_resetjp_4073_;
}
v_resetjp_4073_:
{
lean_object* v___x_4077_; 
if (v_isShared_4075_ == 0)
{
v___x_4077_ = v___x_4074_;
goto v_reusejp_4076_;
}
else
{
lean_object* v_reuseFailAlloc_4078_; 
v_reuseFailAlloc_4078_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4078_, 0, v_a_4072_);
v___x_4077_ = v_reuseFailAlloc_4078_;
goto v_reusejp_4076_;
}
v_reusejp_4076_:
{
return v___x_4077_;
}
}
}
}
}
}
}
else
{
lean_object* v_a_4080_; lean_object* v___x_4082_; uint8_t v_isShared_4083_; uint8_t v_isSharedCheck_4087_; 
v_a_4080_ = lean_ctor_get(v___y_4060_, 0);
v_isSharedCheck_4087_ = !lean_is_exclusive(v___y_4060_);
if (v_isSharedCheck_4087_ == 0)
{
v___x_4082_ = v___y_4060_;
v_isShared_4083_ = v_isSharedCheck_4087_;
goto v_resetjp_4081_;
}
else
{
lean_inc(v_a_4080_);
lean_dec(v___y_4060_);
v___x_4082_ = lean_box(0);
v_isShared_4083_ = v_isSharedCheck_4087_;
goto v_resetjp_4081_;
}
v_resetjp_4081_:
{
lean_object* v___x_4085_; 
if (v_isShared_4083_ == 0)
{
v___x_4085_ = v___x_4082_;
goto v_reusejp_4084_;
}
else
{
lean_object* v_reuseFailAlloc_4086_; 
v_reuseFailAlloc_4086_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4086_, 0, v_a_4080_);
v___x_4085_ = v_reuseFailAlloc_4086_;
goto v_reusejp_4084_;
}
v_reusejp_4084_:
{
return v___x_4085_;
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___boxed(lean_object* v_as_x27_4165_, lean_object* v_b_4166_, lean_object* v___y_4167_, lean_object* v___y_4168_, lean_object* v___y_4169_, lean_object* v___y_4170_, lean_object* v___y_4171_, lean_object* v___y_4172_, lean_object* v___y_4173_, lean_object* v___y_4174_, lean_object* v___y_4175_){
_start:
{
lean_object* v_res_4176_; 
v_res_4176_ = l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg(v_as_x27_4165_, v_b_4166_, v___y_4167_, v___y_4168_, v___y_4169_, v___y_4170_, v___y_4171_, v___y_4172_, v___y_4173_, v___y_4174_);
lean_dec(v___y_4174_);
lean_dec_ref(v___y_4173_);
lean_dec(v___y_4172_);
lean_dec_ref(v___y_4171_);
lean_dec(v___y_4170_);
lean_dec_ref(v___y_4169_);
lean_dec(v___y_4168_);
lean_dec_ref(v___y_4167_);
lean_dec(v_as_x27_4165_);
return v_res_4176_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__2(void){
_start:
{
lean_object* v___x_4179_; lean_object* v___x_4180_; 
v___x_4179_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__1));
v___x_4180_ = l_Lean_stringToMessageData(v___x_4179_);
return v___x_4180_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__4(void){
_start:
{
lean_object* v___x_4182_; lean_object* v___x_4183_; 
v___x_4182_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__3));
v___x_4183_ = l_Lean_stringToMessageData(v___x_4182_);
return v___x_4183_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline(lean_object* v_passes_4184_, lean_object* v_a_4185_, lean_object* v_a_4186_, lean_object* v_a_4187_, lean_object* v_a_4188_, lean_object* v_a_4189_, lean_object* v_a_4190_, lean_object* v_a_4191_, lean_object* v_a_4192_){
_start:
{
lean_object* v___x_4194_; lean_object* v___x_4195_; 
v___x_4194_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__0));
v___x_4195_ = l_Lean_Core_checkSystem(v___x_4194_, v_a_4191_, v_a_4192_);
if (lean_obj_tag(v___x_4195_) == 0)
{
lean_object* v___x_4196_; lean_object* v_rewriteCache_4197_; lean_object* v_acNfCache_4198_; lean_object* v_typeAnalysis_4199_; lean_object* v_goal_4200_; lean_object* v_hypotheses_4201_; lean_object* v___x_4203_; uint8_t v_isShared_4204_; uint8_t v_isSharedCheck_4284_; 
lean_dec_ref_known(v___x_4195_, 1);
v___x_4196_ = lean_st_ref_take(v_a_4186_);
v_rewriteCache_4197_ = lean_ctor_get(v___x_4196_, 0);
v_acNfCache_4198_ = lean_ctor_get(v___x_4196_, 1);
v_typeAnalysis_4199_ = lean_ctor_get(v___x_4196_, 2);
v_goal_4200_ = lean_ctor_get(v___x_4196_, 3);
v_hypotheses_4201_ = lean_ctor_get(v___x_4196_, 4);
v_isSharedCheck_4284_ = !lean_is_exclusive(v___x_4196_);
if (v_isSharedCheck_4284_ == 0)
{
v___x_4203_ = v___x_4196_;
v_isShared_4204_ = v_isSharedCheck_4284_;
goto v_resetjp_4202_;
}
else
{
lean_inc(v_hypotheses_4201_);
lean_inc(v_goal_4200_);
lean_inc(v_typeAnalysis_4199_);
lean_inc(v_acNfCache_4198_);
lean_inc(v_rewriteCache_4197_);
lean_dec(v___x_4196_);
v___x_4203_ = lean_box(0);
v_isShared_4204_ = v_isSharedCheck_4284_;
goto v_resetjp_4202_;
}
v_resetjp_4202_:
{
uint8_t v___x_4205_; lean_object* v___x_4207_; 
v___x_4205_ = 0;
if (v_isShared_4204_ == 0)
{
v___x_4207_ = v___x_4203_;
goto v_reusejp_4206_;
}
else
{
lean_object* v_reuseFailAlloc_4283_; 
v_reuseFailAlloc_4283_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v_reuseFailAlloc_4283_, 0, v_rewriteCache_4197_);
lean_ctor_set(v_reuseFailAlloc_4283_, 1, v_acNfCache_4198_);
lean_ctor_set(v_reuseFailAlloc_4283_, 2, v_typeAnalysis_4199_);
lean_ctor_set(v_reuseFailAlloc_4283_, 3, v_goal_4200_);
lean_ctor_set(v_reuseFailAlloc_4283_, 4, v_hypotheses_4201_);
v___x_4207_ = v_reuseFailAlloc_4283_;
goto v_reusejp_4206_;
}
v_reusejp_4206_:
{
lean_object* v___x_4208_; lean_object* v___x_4209_; lean_object* v___x_4210_; 
lean_ctor_set_uint8(v___x_4207_, sizeof(void*)*5, v___x_4205_);
v___x_4208_ = lean_st_ref_set(v_a_4186_, v___x_4207_);
v___x_4209_ = ((lean_object*)(l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg___closed__0));
v___x_4210_ = l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg(v_passes_4184_, v___x_4209_, v_a_4185_, v_a_4186_, v_a_4187_, v_a_4188_, v_a_4189_, v_a_4190_, v_a_4191_, v_a_4192_);
if (lean_obj_tag(v___x_4210_) == 0)
{
lean_object* v_a_4211_; lean_object* v___x_4213_; uint8_t v_isShared_4214_; uint8_t v_isSharedCheck_4274_; 
v_a_4211_ = lean_ctor_get(v___x_4210_, 0);
v_isSharedCheck_4274_ = !lean_is_exclusive(v___x_4210_);
if (v_isSharedCheck_4274_ == 0)
{
v___x_4213_ = v___x_4210_;
v_isShared_4214_ = v_isSharedCheck_4274_;
goto v_resetjp_4212_;
}
else
{
lean_inc(v_a_4211_);
lean_dec(v___x_4210_);
v___x_4213_ = lean_box(0);
v_isShared_4214_ = v_isSharedCheck_4274_;
goto v_resetjp_4212_;
}
v_resetjp_4212_:
{
lean_object* v_fst_4215_; 
v_fst_4215_ = lean_ctor_get(v_a_4211_, 0);
lean_inc(v_fst_4215_);
lean_dec(v_a_4211_);
if (lean_obj_tag(v_fst_4215_) == 0)
{
lean_object* v___x_4216_; uint8_t v_didChange_4217_; 
v___x_4216_ = lean_st_ref_get(v_a_4186_);
v_didChange_4217_ = lean_ctor_get_uint8(v___x_4216_, sizeof(void*)*5);
lean_dec(v___x_4216_);
if (v_didChange_4217_ == 0)
{
lean_object* v_options_4218_; uint8_t v_hasTrace_4219_; 
v_options_4218_ = lean_ctor_get(v_a_4191_, 2);
v_hasTrace_4219_ = lean_ctor_get_uint8(v_options_4218_, sizeof(void*)*1);
if (v_hasTrace_4219_ == 0)
{
lean_object* v___x_4220_; lean_object* v___x_4222_; 
v___x_4220_ = lean_box(v_didChange_4217_);
if (v_isShared_4214_ == 0)
{
lean_ctor_set(v___x_4213_, 0, v___x_4220_);
v___x_4222_ = v___x_4213_;
goto v_reusejp_4221_;
}
else
{
lean_object* v_reuseFailAlloc_4223_; 
v_reuseFailAlloc_4223_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4223_, 0, v___x_4220_);
v___x_4222_ = v_reuseFailAlloc_4223_;
goto v_reusejp_4221_;
}
v_reusejp_4221_:
{
return v___x_4222_;
}
}
else
{
lean_object* v_inheritedTraceOptions_4224_; lean_object* v___x_4225_; lean_object* v___x_4226_; uint8_t v___x_4227_; 
v_inheritedTraceOptions_4224_ = lean_ctor_get(v_a_4191_, 13);
v___x_4225_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
v___x_4226_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14);
v___x_4227_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_4224_, v_options_4218_, v___x_4226_);
if (v___x_4227_ == 0)
{
lean_object* v___x_4228_; lean_object* v___x_4230_; 
v___x_4228_ = lean_box(v_didChange_4217_);
if (v_isShared_4214_ == 0)
{
lean_ctor_set(v___x_4213_, 0, v___x_4228_);
v___x_4230_ = v___x_4213_;
goto v_reusejp_4229_;
}
else
{
lean_object* v_reuseFailAlloc_4231_; 
v_reuseFailAlloc_4231_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4231_, 0, v___x_4228_);
v___x_4230_ = v_reuseFailAlloc_4231_;
goto v_reusejp_4229_;
}
v_reusejp_4229_:
{
return v___x_4230_;
}
}
else
{
lean_object* v___x_4232_; lean_object* v___x_4233_; 
lean_del_object(v___x_4213_);
v___x_4232_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__2, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__2);
v___x_4233_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg(v___x_4225_, v___x_4232_, v_a_4189_, v_a_4190_, v_a_4191_, v_a_4192_);
if (lean_obj_tag(v___x_4233_) == 0)
{
lean_object* v___x_4235_; uint8_t v_isShared_4236_; uint8_t v_isSharedCheck_4241_; 
v_isSharedCheck_4241_ = !lean_is_exclusive(v___x_4233_);
if (v_isSharedCheck_4241_ == 0)
{
lean_object* v_unused_4242_; 
v_unused_4242_ = lean_ctor_get(v___x_4233_, 0);
lean_dec(v_unused_4242_);
v___x_4235_ = v___x_4233_;
v_isShared_4236_ = v_isSharedCheck_4241_;
goto v_resetjp_4234_;
}
else
{
lean_dec(v___x_4233_);
v___x_4235_ = lean_box(0);
v_isShared_4236_ = v_isSharedCheck_4241_;
goto v_resetjp_4234_;
}
v_resetjp_4234_:
{
lean_object* v___x_4237_; lean_object* v___x_4239_; 
v___x_4237_ = lean_box(v_didChange_4217_);
if (v_isShared_4236_ == 0)
{
lean_ctor_set(v___x_4235_, 0, v___x_4237_);
v___x_4239_ = v___x_4235_;
goto v_reusejp_4238_;
}
else
{
lean_object* v_reuseFailAlloc_4240_; 
v_reuseFailAlloc_4240_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4240_, 0, v___x_4237_);
v___x_4239_ = v_reuseFailAlloc_4240_;
goto v_reusejp_4238_;
}
v_reusejp_4238_:
{
return v___x_4239_;
}
}
}
else
{
lean_object* v_a_4243_; lean_object* v___x_4245_; uint8_t v_isShared_4246_; uint8_t v_isSharedCheck_4250_; 
v_a_4243_ = lean_ctor_get(v___x_4233_, 0);
v_isSharedCheck_4250_ = !lean_is_exclusive(v___x_4233_);
if (v_isSharedCheck_4250_ == 0)
{
v___x_4245_ = v___x_4233_;
v_isShared_4246_ = v_isSharedCheck_4250_;
goto v_resetjp_4244_;
}
else
{
lean_inc(v_a_4243_);
lean_dec(v___x_4233_);
v___x_4245_ = lean_box(0);
v_isShared_4246_ = v_isSharedCheck_4250_;
goto v_resetjp_4244_;
}
v_resetjp_4244_:
{
lean_object* v___x_4248_; 
if (v_isShared_4246_ == 0)
{
v___x_4248_ = v___x_4245_;
goto v_reusejp_4247_;
}
else
{
lean_object* v_reuseFailAlloc_4249_; 
v_reuseFailAlloc_4249_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4249_, 0, v_a_4243_);
v___x_4248_ = v_reuseFailAlloc_4249_;
goto v_reusejp_4247_;
}
v_reusejp_4247_:
{
return v___x_4248_;
}
}
}
}
}
}
else
{
lean_object* v_options_4251_; uint8_t v_hasTrace_4252_; 
lean_del_object(v___x_4213_);
v_options_4251_ = lean_ctor_get(v_a_4191_, 2);
v_hasTrace_4252_ = lean_ctor_get_uint8(v_options_4251_, sizeof(void*)*1);
if (v_hasTrace_4252_ == 0)
{
goto _start;
}
else
{
lean_object* v_inheritedTraceOptions_4254_; lean_object* v___x_4255_; lean_object* v___x_4256_; uint8_t v___x_4257_; 
v_inheritedTraceOptions_4254_ = lean_ctor_get(v_a_4191_, 13);
v___x_4255_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__11));
v___x_4256_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14, &l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_PreProcessM_pushHyp___closed__14);
v___x_4257_ = l___private_Lean_Util_Trace_0__Lean_checkTraceOption_go(v_inheritedTraceOptions_4254_, v_options_4251_, v___x_4256_);
if (v___x_4257_ == 0)
{
goto _start;
}
else
{
lean_object* v___x_4259_; lean_object* v___x_4260_; 
v___x_4259_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__4, &l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__4_once, _init_l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___closed__4);
v___x_4260_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg(v___x_4255_, v___x_4259_, v_a_4189_, v_a_4190_, v_a_4191_, v_a_4192_);
if (lean_obj_tag(v___x_4260_) == 0)
{
lean_dec_ref_known(v___x_4260_, 1);
goto _start;
}
else
{
lean_object* v_a_4262_; lean_object* v___x_4264_; uint8_t v_isShared_4265_; uint8_t v_isSharedCheck_4269_; 
v_a_4262_ = lean_ctor_get(v___x_4260_, 0);
v_isSharedCheck_4269_ = !lean_is_exclusive(v___x_4260_);
if (v_isSharedCheck_4269_ == 0)
{
v___x_4264_ = v___x_4260_;
v_isShared_4265_ = v_isSharedCheck_4269_;
goto v_resetjp_4263_;
}
else
{
lean_inc(v_a_4262_);
lean_dec(v___x_4260_);
v___x_4264_ = lean_box(0);
v_isShared_4265_ = v_isSharedCheck_4269_;
goto v_resetjp_4263_;
}
v_resetjp_4263_:
{
lean_object* v___x_4267_; 
if (v_isShared_4265_ == 0)
{
v___x_4267_ = v___x_4264_;
goto v_reusejp_4266_;
}
else
{
lean_object* v_reuseFailAlloc_4268_; 
v_reuseFailAlloc_4268_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4268_, 0, v_a_4262_);
v___x_4267_ = v_reuseFailAlloc_4268_;
goto v_reusejp_4266_;
}
v_reusejp_4266_:
{
return v___x_4267_;
}
}
}
}
}
}
}
else
{
lean_object* v_val_4270_; lean_object* v___x_4272_; 
v_val_4270_ = lean_ctor_get(v_fst_4215_, 0);
lean_inc(v_val_4270_);
lean_dec_ref_known(v_fst_4215_, 1);
if (v_isShared_4214_ == 0)
{
lean_ctor_set(v___x_4213_, 0, v_val_4270_);
v___x_4272_ = v___x_4213_;
goto v_reusejp_4271_;
}
else
{
lean_object* v_reuseFailAlloc_4273_; 
v_reuseFailAlloc_4273_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4273_, 0, v_val_4270_);
v___x_4272_ = v_reuseFailAlloc_4273_;
goto v_reusejp_4271_;
}
v_reusejp_4271_:
{
return v___x_4272_;
}
}
}
}
else
{
lean_object* v_a_4275_; lean_object* v___x_4277_; uint8_t v_isShared_4278_; uint8_t v_isSharedCheck_4282_; 
v_a_4275_ = lean_ctor_get(v___x_4210_, 0);
v_isSharedCheck_4282_ = !lean_is_exclusive(v___x_4210_);
if (v_isSharedCheck_4282_ == 0)
{
v___x_4277_ = v___x_4210_;
v_isShared_4278_ = v_isSharedCheck_4282_;
goto v_resetjp_4276_;
}
else
{
lean_inc(v_a_4275_);
lean_dec(v___x_4210_);
v___x_4277_ = lean_box(0);
v_isShared_4278_ = v_isSharedCheck_4282_;
goto v_resetjp_4276_;
}
v_resetjp_4276_:
{
lean_object* v___x_4280_; 
if (v_isShared_4278_ == 0)
{
v___x_4280_ = v___x_4277_;
goto v_reusejp_4279_;
}
else
{
lean_object* v_reuseFailAlloc_4281_; 
v_reuseFailAlloc_4281_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4281_, 0, v_a_4275_);
v___x_4280_ = v_reuseFailAlloc_4281_;
goto v_reusejp_4279_;
}
v_reusejp_4279_:
{
return v___x_4280_;
}
}
}
}
}
}
else
{
lean_object* v_a_4285_; lean_object* v___x_4287_; uint8_t v_isShared_4288_; uint8_t v_isSharedCheck_4292_; 
v_a_4285_ = lean_ctor_get(v___x_4195_, 0);
v_isSharedCheck_4292_ = !lean_is_exclusive(v___x_4195_);
if (v_isSharedCheck_4292_ == 0)
{
v___x_4287_ = v___x_4195_;
v_isShared_4288_ = v_isSharedCheck_4292_;
goto v_resetjp_4286_;
}
else
{
lean_inc(v_a_4285_);
lean_dec(v___x_4195_);
v___x_4287_ = lean_box(0);
v_isShared_4288_ = v_isSharedCheck_4292_;
goto v_resetjp_4286_;
}
v_resetjp_4286_:
{
lean_object* v___x_4290_; 
if (v_isShared_4288_ == 0)
{
v___x_4290_ = v___x_4287_;
goto v_reusejp_4289_;
}
else
{
lean_object* v_reuseFailAlloc_4291_; 
v_reuseFailAlloc_4291_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_4291_, 0, v_a_4285_);
v___x_4290_ = v_reuseFailAlloc_4291_;
goto v_reusejp_4289_;
}
v_reusejp_4289_:
{
return v___x_4290_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline___boxed(lean_object* v_passes_4293_, lean_object* v_a_4294_, lean_object* v_a_4295_, lean_object* v_a_4296_, lean_object* v_a_4297_, lean_object* v_a_4298_, lean_object* v_a_4299_, lean_object* v_a_4300_, lean_object* v_a_4301_, lean_object* v_a_4302_){
_start:
{
lean_object* v_res_4303_; 
v_res_4303_ = l_Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline(v_passes_4293_, v_a_4294_, v_a_4295_, v_a_4296_, v_a_4297_, v_a_4298_, v_a_4299_, v_a_4300_, v_a_4301_);
lean_dec(v_a_4301_);
lean_dec_ref(v_a_4300_);
lean_dec(v_a_4299_);
lean_dec_ref(v_a_4298_);
lean_dec(v_a_4297_);
lean_dec_ref(v_a_4296_);
lean_dec(v_a_4295_);
lean_dec_ref(v_a_4294_);
lean_dec(v_passes_4293_);
return v_res_4303_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0(lean_object* v_cls_4304_, lean_object* v_msg_4305_, lean_object* v___y_4306_, lean_object* v___y_4307_, lean_object* v___y_4308_, lean_object* v___y_4309_, lean_object* v___y_4310_, lean_object* v___y_4311_, lean_object* v___y_4312_, lean_object* v___y_4313_){
_start:
{
lean_object* v___x_4315_; 
v___x_4315_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___redArg(v_cls_4304_, v_msg_4305_, v___y_4310_, v___y_4311_, v___y_4312_, v___y_4313_);
return v___x_4315_;
}
}
LEAN_EXPORT lean_object* l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0___boxed(lean_object* v_cls_4316_, lean_object* v_msg_4317_, lean_object* v___y_4318_, lean_object* v___y_4319_, lean_object* v___y_4320_, lean_object* v___y_4321_, lean_object* v___y_4322_, lean_object* v___y_4323_, lean_object* v___y_4324_, lean_object* v___y_4325_, lean_object* v___y_4326_){
_start:
{
lean_object* v_res_4327_; 
v_res_4327_ = l_Lean_addTrace___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__0(v_cls_4316_, v_msg_4317_, v___y_4318_, v___y_4319_, v___y_4320_, v___y_4321_, v___y_4322_, v___y_4323_, v___y_4324_, v___y_4325_);
lean_dec(v___y_4325_);
lean_dec_ref(v___y_4324_);
lean_dec(v___y_4323_);
lean_dec_ref(v___y_4322_);
lean_dec(v___y_4321_);
lean_dec_ref(v___y_4320_);
lean_dec(v___y_4319_);
lean_dec_ref(v___y_4318_);
return v_res_4327_;
}
}
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5(lean_object* v_00_u03b1_4328_, lean_object* v_x_4329_, lean_object* v___y_4330_, lean_object* v___y_4331_, lean_object* v___y_4332_, lean_object* v___y_4333_, lean_object* v___y_4334_, lean_object* v___y_4335_, lean_object* v___y_4336_, lean_object* v___y_4337_){
_start:
{
lean_object* v___x_4339_; 
v___x_4339_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___redArg(v_x_4329_);
return v___x_4339_;
}
}
LEAN_EXPORT lean_object* l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5___boxed(lean_object* v_00_u03b1_4340_, lean_object* v_x_4341_, lean_object* v___y_4342_, lean_object* v___y_4343_, lean_object* v___y_4344_, lean_object* v___y_4345_, lean_object* v___y_4346_, lean_object* v___y_4347_, lean_object* v___y_4348_, lean_object* v___y_4349_, lean_object* v___y_4350_){
_start:
{
lean_object* v_res_4351_; 
v_res_4351_ = l_MonadExcept_ofExcept___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__5(v_00_u03b1_4340_, v_x_4341_, v___y_4342_, v___y_4343_, v___y_4344_, v___y_4345_, v___y_4346_, v___y_4347_, v___y_4348_, v___y_4349_);
lean_dec(v___y_4349_);
lean_dec_ref(v___y_4348_);
lean_dec(v___y_4347_);
lean_dec_ref(v___y_4346_);
lean_dec(v___y_4345_);
lean_dec_ref(v___y_4344_);
lean_dec(v___y_4343_);
lean_dec_ref(v___y_4342_);
return v_res_4351_;
}
}
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4(lean_object* v_as_4352_, lean_object* v_as_x27_4353_, lean_object* v_b_4354_, lean_object* v_a_4355_, lean_object* v___y_4356_, lean_object* v___y_4357_, lean_object* v___y_4358_, lean_object* v___y_4359_, lean_object* v___y_4360_, lean_object* v___y_4361_, lean_object* v___y_4362_, lean_object* v___y_4363_){
_start:
{
lean_object* v___x_4365_; 
v___x_4365_ = l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___redArg(v_as_x27_4353_, v_b_4354_, v___y_4356_, v___y_4357_, v___y_4358_, v___y_4359_, v___y_4360_, v___y_4361_, v___y_4362_, v___y_4363_);
return v___x_4365_;
}
}
LEAN_EXPORT lean_object* l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4___boxed(lean_object* v_as_4366_, lean_object* v_as_x27_4367_, lean_object* v_b_4368_, lean_object* v_a_4369_, lean_object* v___y_4370_, lean_object* v___y_4371_, lean_object* v___y_4372_, lean_object* v___y_4373_, lean_object* v___y_4374_, lean_object* v___y_4375_, lean_object* v___y_4376_, lean_object* v___y_4377_, lean_object* v___y_4378_){
_start:
{
lean_object* v_res_4379_; 
v_res_4379_ = l_List_forIn_x27_loop___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__4(v_as_4366_, v_as_x27_4367_, v_b_4368_, v_a_4369_, v___y_4370_, v___y_4371_, v___y_4372_, v___y_4373_, v___y_4374_, v___y_4375_, v___y_4376_, v___y_4377_);
lean_dec(v___y_4377_);
lean_dec_ref(v___y_4376_);
lean_dec(v___y_4375_);
lean_dec_ref(v___y_4374_);
lean_dec(v___y_4373_);
lean_dec_ref(v___y_4372_);
lean_dec(v___y_4371_);
lean_dec_ref(v___y_4370_);
lean_dec(v_as_x27_4367_);
lean_dec(v_as_4366_);
return v_res_4379_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4(lean_object* v_oldTraces_4380_, lean_object* v_data_4381_, lean_object* v_ref_4382_, lean_object* v_msg_4383_, lean_object* v___y_4384_, lean_object* v___y_4385_, lean_object* v___y_4386_, lean_object* v___y_4387_, lean_object* v___y_4388_, lean_object* v___y_4389_, lean_object* v___y_4390_, lean_object* v___y_4391_){
_start:
{
lean_object* v___x_4393_; 
v___x_4393_ = l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4___redArg(v_oldTraces_4380_, v_data_4381_, v_ref_4382_, v_msg_4383_, v___y_4388_, v___y_4389_, v___y_4390_, v___y_4391_);
return v___x_4393_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4___boxed(lean_object* v_oldTraces_4394_, lean_object* v_data_4395_, lean_object* v_ref_4396_, lean_object* v_msg_4397_, lean_object* v___y_4398_, lean_object* v___y_4399_, lean_object* v___y_4400_, lean_object* v___y_4401_, lean_object* v___y_4402_, lean_object* v___y_4403_, lean_object* v___y_4404_, lean_object* v___y_4405_, lean_object* v___y_4406_){
_start:
{
lean_object* v_res_4407_; 
v_res_4407_ = l___private_Lean_Util_Trace_0__Lean_addTraceNode___at___00__private_Lean_Util_Trace_0__Lean_withTraceNode_postCallback___at___00Lean_Meta_Tactic_BVDecide_Normalize_Pass_fixpointPipeline_spec__3_spec__4(v_oldTraces_4394_, v_data_4395_, v_ref_4396_, v_msg_4397_, v___y_4398_, v___y_4399_, v___y_4400_, v___y_4401_, v___y_4402_, v___y_4403_, v___y_4404_, v___y_4405_);
lean_dec(v___y_4405_);
lean_dec_ref(v___y_4404_);
lean_dec(v___y_4403_);
lean_dec_ref(v___y_4402_);
lean_dec(v___y_4401_);
lean_dec_ref(v___y_4400_);
lean_dec(v___y_4399_);
lean_dec_ref(v___y_4398_);
return v_res_4407_;
}
}
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Attr(uint8_t builtin);
lean_object* runtime_initialize_Std_Tactic_BVDecide_Syntax(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_ExprPtr(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_SymM(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Simp_SimpM(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_AlphaShareBuilder(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_InferType(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_InstantiateMVarsS(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Attr(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Std_Tactic_BVDecide_Syntax(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_ExprPtr(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_SymM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Simp_SimpM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_AlphaShareBuilder(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_InferType(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_InstantiateMVarsS(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default = _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default();
lean_mark_persistent(l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp_default);
l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp = _init_l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp();
lean_mark_persistent(l_Lean_Meta_Tactic_BVDecide_Normalize_instInhabitedHyp);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Attr(uint8_t builtin);
lean_object* initialize_Std_Tactic_BVDecide_Syntax(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_ExprPtr(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_SymM(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Simp_SimpM(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_AlphaShareBuilder(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_InferType(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_InstantiateMVarsS(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Lean_Meta_Tactic_BVDecide_Attr(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Std_Tactic_BVDecide_Syntax(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_ExprPtr(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_SymM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Simp_SimpM(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_AlphaShareBuilder(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_InferType(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_InstantiateMVarsS(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Meta_Tactic_BVDecide_Normalize_Basic(builtin);
}
#ifdef __cplusplus
}
#endif
