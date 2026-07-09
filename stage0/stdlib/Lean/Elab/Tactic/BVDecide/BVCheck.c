// Lean compiler output
// Module: Lean.Elab.Tactic.BVDecide.BVCheck
// Imports: public import Lean.Elab.Tactic.BVDecide.BVDecide public import Lean.Meta.Tactic.TryThis import Lean.Meta.Tactic.BVDecide.TacticContext import Lean.Meta.Tactic.BVDecide.Normalize import Lean.Meta.Sym.Util
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
lean_object* lean_st_ref_take(lean_object*);
lean_object* l_Lean_MessageLog_add(lean_object*, lean_object*);
lean_object* lean_st_ref_set(lean_object*, lean_object*);
lean_object* l___private_Lean_Log_0__Lean_MessageData_appendDescriptionWidgetIfNamed(lean_object*);
lean_object* lean_st_ref_get(lean_object*);
lean_object* l_Lean_FileMap_toPosition(lean_object*, lean_object*);
uint8_t l_Lean_MessageData_hasTag(lean_object*, lean_object*);
lean_object* l_Lean_Syntax_getTailPos_x3f(lean_object*, uint8_t);
lean_object* l_Lean_replaceRef(lean_object*, lean_object*);
lean_object* l_Lean_Syntax_getPos_x3f(lean_object*, uint8_t);
uint8_t lean_string_dec_eq(lean_object*, lean_object*);
uint8_t l_Lean_instBEqMessageSeverity_beq(uint8_t, uint8_t);
extern lean_object* l_Lean_warningAsError;
lean_object* l_Std_DTreeMap_Internal_Impl_Const_get_x3f___at___00Lean_NameMap_find_x3f_spec__0___redArg(lean_object*, lean_object*);
uint8_t l_Lean_MessageData_hasSyntheticSorry(lean_object*);
lean_object* l_Lean_Name_mkStr4(lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t l_Lean_Syntax_isOfKind(lean_object*, lean_object*);
extern lean_object* l_Lean_Elab_unsupportedSyntaxExceptionId;
lean_object* l_Lean_Syntax_getArg(lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr1(lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_elabBVDecideConfig___redArg(lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_TSyntax_getString(lean_object*);
lean_object* l_System_FilePath_parent(lean_object*);
lean_object* l_Lean_stringToMessageData(lean_object*);
lean_object* l_Lean_MessageData_ofFormat(lean_object*);
lean_object* l_Lean_Elab_getBetterRef(lean_object*, lean_object*);
extern lean_object* l_Lean_Elab_pp_macroStack;
lean_object* l_Lean_MessageData_ofSyntax(lean_object*);
lean_object* l_Lean_indentD(lean_object*);
lean_object* l_System_FilePath_join(lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_TacticContext_new(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_getPropHyps(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Elab_Tactic_getMainGoal___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_array_get_size(lean_object*);
lean_object* lean_nat_mul(lean_object*, lean_object*);
lean_object* lean_nat_div(lean_object*, lean_object*);
lean_object* l_Nat_nextPowerOfTwo(lean_object*);
lean_object* lean_mk_array(lean_object*, lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
lean_object* lean_st_mk_ref(lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_Normalize_bvNormalize(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_lratChecker___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_M_run___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_SourceInfo_fromRef(lean_object*, uint8_t);
lean_object* l_Lean_Syntax_node2(lean_object*, lean_object*, lean_object*, lean_object*);
extern lean_object* l_Lean_MessageData_nil;
lean_object* l_Lean_Meta_Tactic_TryThis_addSuggestion(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_SymM_run___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Elab_Tactic_replaceMainGoal___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Elab_Tactic_withMainContext___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
extern lean_object* l_Lean_Elab_Tactic_tacticElabAttribute;
lean_object* l_Lean_KeyedDeclsAttribute_addBuiltin___redArg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__0;
static const lean_string_object l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 16, .m_capacity = 16, .m_length = 15, .m_data = "while expanding"};
static const lean_object* l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__1 = (const lean_object*)&l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__1_value;
static const lean_ctor_object l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*1 + 0, .m_other = 1, .m_tag = 3}, .m_objs = {((lean_object*)&l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__1_value)}};
static const lean_object* l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__2 = (const lean_object*)&l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__2_value;
static lean_once_cell_t l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__3;
LEAN_EXPORT lean_object* l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_Lean_Option_get___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__2(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__2___boxed(lean_object*, lean_object*);
static const lean_string_object l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 25, .m_capacity = 25, .m_length = 24, .m_data = "with resulting expansion"};
static const lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__0 = (const lean_object*)&l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__0_value;
static const lean_ctor_object l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*1 + 0, .m_other = 1, .m_tag = 3}, .m_objs = {((lean_object*)&l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__0_value)}};
static const lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__1 = (const lean_object*)&l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__1_value;
static lean_once_cell_t l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__2;
LEAN_EXPORT lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 37, .m_capacity = 37, .m_length = 36, .m_data = "cannot compute parent directory of `"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__0 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__0_value;
static lean_once_cell_t l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__1_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__1;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 2, .m_capacity = 2, .m_length = 1, .m_data = "`"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__2 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__2_value;
static lean_once_cell_t l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__3;
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_mkContext(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_mkContext___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg___closed__0;
LEAN_EXPORT lean_object* l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg();
LEAN_EXPORT lean_object* l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg___boxed(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Elab"};
static const lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__0 = (const lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__0_value;
static const lean_string_object l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__1 = (const lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__1_value;
static const lean_string_object l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 14, .m_capacity = 14, .m_length = 13, .m_data = "unsolvedGoals"};
static const lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__2 = (const lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__2_value;
static const lean_string_object l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 17, .m_capacity = 17, .m_length = 16, .m_data = "synthPlaceholder"};
static const lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__3 = (const lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__3_value;
static const lean_string_object l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "lean"};
static const lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__4 = (const lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__4_value;
static const lean_string_object l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 20, .m_capacity = 20, .m_length = 19, .m_data = "inductionWithNoAlts"};
static const lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__5 = (const lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__5_value;
static const lean_string_object l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 12, .m_capacity = 12, .m_length = 11, .m_data = "_namedError"};
static const lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__6 = (const lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__6_value;
static const lean_string_object l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trace"};
static const lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__7 = (const lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__7_value;
LEAN_EXPORT uint8_t l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0(uint8_t, uint8_t, lean_object*);
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 1, .m_capacity = 1, .m_length = 0, .m_data = ""};
static const lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___closed__0 = (const lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg(lean_object*, lean_object*, uint8_t, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2(lean_object*, uint8_t, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_once_cell_t l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__0;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 94, .m_capacity = 94, .m_length = 93, .m_data = "This goal can be closed by only applying bv_normalize, no need to keep the LRAT proof around."};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__1 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__1_value;
static lean_once_cell_t l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__2;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 13, .m_capacity = 13, .m_length = 12, .m_data = "bv_normalize"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__3 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__3_value;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "tactic"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__4 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__4_value;
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__4_value),LEAN_SCALAR_PTR_LITERAL(99, 76, 33, 121, 85, 143, 17, 224)}};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__5 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__5_value;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 12, .m_capacity = 12, .m_length = 11, .m_data = "bvNormalize"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__6 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__6_value;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "Try this:"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__7 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__7_value;
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1(lean_object*, lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___boxed(lean_object**);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__2(lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__2___boxed(lean_object**);
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Lean"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__0 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__0_value;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Parser"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__1 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__1_value;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "bvCheck"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__2 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__2_value;
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__0_value),LEAN_SCALAR_PTR_LITERAL(70, 193, 83, 126, 233, 67, 208, 165)}};
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3_value_aux_0),((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__1_value),LEAN_SCALAR_PTR_LITERAL(103, 136, 125, 166, 167, 98, 71, 111)}};
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3_value_aux_1),((lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(166, 58, 35, 182, 187, 130, 147, 254)}};
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3_value_aux_2),((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__2_value),LEAN_SCALAR_PTR_LITERAL(237, 160, 246, 114, 147, 242, 134, 91)}};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3_value;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "optConfig"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__4 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__4_value;
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__0_value),LEAN_SCALAR_PTR_LITERAL(70, 193, 83, 126, 233, 67, 208, 165)}};
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5_value_aux_0),((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__1_value),LEAN_SCALAR_PTR_LITERAL(103, 136, 125, 166, 167, 98, 71, 111)}};
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5_value_aux_1),((lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(166, 58, 35, 182, 187, 130, 147, 254)}};
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5_value_aux_2),((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__4_value),LEAN_SCALAR_PTR_LITERAL(137, 208, 10, 74, 108, 50, 106, 48)}};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5_value;
static const lean_string_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "str"};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__6 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__6_value;
static const lean_ctor_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__6_value),LEAN_SCALAR_PTR_LITERAL(255, 188, 142, 1, 190, 33, 34, 128)}};
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__7 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__7_value;
static const lean_closure_object l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*0, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__0___boxed, .m_arity = 7, .m_num_fixed = 0, .m_objs = {} };
static const lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__8 = (const lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__8_value;
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3(lean_object*, lean_object*, uint8_t, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "BVDecide"};
static const lean_object* l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__0 = (const lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__0_value;
static const lean_string_object l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "BVCheck"};
static const lean_object* l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__1 = (const lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__1_value;
static const lean_string_object l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 12, .m_capacity = 12, .m_length = 11, .m_data = "evalBvCheck"};
static const lean_object* l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__2 = (const lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__2_value;
static const lean_ctor_object l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__0_value),LEAN_SCALAR_PTR_LITERAL(70, 193, 83, 126, 233, 67, 208, 165)}};
static const lean_ctor_object l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_0),((lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__0_value),LEAN_SCALAR_PTR_LITERAL(52, 247, 248, 201, 92, 23, 188, 159)}};
static const lean_ctor_object l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_1),((lean_object*)&l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__1_value),LEAN_SCALAR_PTR_LITERAL(161, 230, 229, 85, 182, 144, 182, 176)}};
static const lean_ctor_object l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_2),((lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__0_value),LEAN_SCALAR_PTR_LITERAL(188, 95, 32, 5, 74, 186, 96, 166)}};
static const lean_ctor_object l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_4 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_3),((lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__1_value),LEAN_SCALAR_PTR_LITERAL(93, 73, 220, 166, 46, 65, 124, 223)}};
static const lean_ctor_object l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value_aux_4),((lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__2_value),LEAN_SCALAR_PTR_LITERAL(182, 6, 110, 156, 2, 215, 50, 89)}};
static const lean_object* l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3 = (const lean_object*)&l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3_value;
LEAN_EXPORT lean_object* l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1();
LEAN_EXPORT lean_object* l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___boxed(lean_object*);
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__0(lean_object* v_msgData_1_, lean_object* v___y_2_, lean_object* v___y_3_, lean_object* v___y_4_, lean_object* v___y_5_){
_start:
{
lean_object* v___x_7_; lean_object* v_env_8_; lean_object* v___x_9_; lean_object* v_mctx_10_; lean_object* v_lctx_11_; lean_object* v_options_12_; lean_object* v___x_13_; lean_object* v___x_14_; lean_object* v___x_15_; 
v___x_7_ = lean_st_ref_get(v___y_5_);
v_env_8_ = lean_ctor_get(v___x_7_, 0);
lean_inc_ref(v_env_8_);
lean_dec(v___x_7_);
v___x_9_ = lean_st_ref_get(v___y_3_);
v_mctx_10_ = lean_ctor_get(v___x_9_, 0);
lean_inc_ref(v_mctx_10_);
lean_dec(v___x_9_);
v_lctx_11_ = lean_ctor_get(v___y_2_, 2);
v_options_12_ = lean_ctor_get(v___y_4_, 2);
lean_inc_ref(v_options_12_);
lean_inc_ref(v_lctx_11_);
v___x_13_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_13_, 0, v_env_8_);
lean_ctor_set(v___x_13_, 1, v_mctx_10_);
lean_ctor_set(v___x_13_, 2, v_lctx_11_);
lean_ctor_set(v___x_13_, 3, v_options_12_);
v___x_14_ = lean_alloc_ctor(3, 2, 0);
lean_ctor_set(v___x_14_, 0, v___x_13_);
lean_ctor_set(v___x_14_, 1, v_msgData_1_);
v___x_15_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_15_, 0, v___x_14_);
return v___x_15_;
}
}
LEAN_EXPORT lean_object* l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__0___boxed(lean_object* v_msgData_16_, lean_object* v___y_17_, lean_object* v___y_18_, lean_object* v___y_19_, lean_object* v___y_20_, lean_object* v___y_21_){
_start:
{
lean_object* v_res_22_; 
v_res_22_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__0(v_msgData_16_, v___y_17_, v___y_18_, v___y_19_, v___y_20_);
lean_dec(v___y_20_);
lean_dec_ref(v___y_19_);
lean_dec(v___y_18_);
lean_dec_ref(v___y_17_);
return v_res_22_;
}
}
static lean_object* _init_l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__0(void){
_start:
{
lean_object* v___x_23_; lean_object* v___x_24_; 
v___x_23_ = lean_box(1);
v___x_24_ = l_Lean_MessageData_ofFormat(v___x_23_);
return v___x_24_;
}
}
static lean_object* _init_l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__3(void){
_start:
{
lean_object* v___x_28_; lean_object* v___x_29_; 
v___x_28_ = ((lean_object*)(l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__2));
v___x_29_ = l_Lean_MessageData_ofFormat(v___x_28_);
return v___x_29_;
}
}
LEAN_EXPORT lean_object* l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3(lean_object* v_x_30_, lean_object* v_x_31_){
_start:
{
if (lean_obj_tag(v_x_31_) == 0)
{
return v_x_30_;
}
else
{
lean_object* v_head_32_; lean_object* v_tail_33_; lean_object* v___x_35_; uint8_t v_isShared_36_; uint8_t v_isSharedCheck_55_; 
v_head_32_ = lean_ctor_get(v_x_31_, 0);
v_tail_33_ = lean_ctor_get(v_x_31_, 1);
v_isSharedCheck_55_ = !lean_is_exclusive(v_x_31_);
if (v_isSharedCheck_55_ == 0)
{
v___x_35_ = v_x_31_;
v_isShared_36_ = v_isSharedCheck_55_;
goto v_resetjp_34_;
}
else
{
lean_inc(v_tail_33_);
lean_inc(v_head_32_);
lean_dec(v_x_31_);
v___x_35_ = lean_box(0);
v_isShared_36_ = v_isSharedCheck_55_;
goto v_resetjp_34_;
}
v_resetjp_34_:
{
lean_object* v_before_37_; lean_object* v___x_39_; uint8_t v_isShared_40_; uint8_t v_isSharedCheck_53_; 
v_before_37_ = lean_ctor_get(v_head_32_, 0);
v_isSharedCheck_53_ = !lean_is_exclusive(v_head_32_);
if (v_isSharedCheck_53_ == 0)
{
lean_object* v_unused_54_; 
v_unused_54_ = lean_ctor_get(v_head_32_, 1);
lean_dec(v_unused_54_);
v___x_39_ = v_head_32_;
v_isShared_40_ = v_isSharedCheck_53_;
goto v_resetjp_38_;
}
else
{
lean_inc(v_before_37_);
lean_dec(v_head_32_);
v___x_39_ = lean_box(0);
v_isShared_40_ = v_isSharedCheck_53_;
goto v_resetjp_38_;
}
v_resetjp_38_:
{
lean_object* v___x_41_; lean_object* v___x_43_; 
v___x_41_ = lean_obj_once(&l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__0, &l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__0_once, _init_l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__0);
if (v_isShared_40_ == 0)
{
lean_ctor_set_tag(v___x_39_, 7);
lean_ctor_set(v___x_39_, 1, v___x_41_);
lean_ctor_set(v___x_39_, 0, v_x_30_);
v___x_43_ = v___x_39_;
goto v_reusejp_42_;
}
else
{
lean_object* v_reuseFailAlloc_52_; 
v_reuseFailAlloc_52_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v_reuseFailAlloc_52_, 0, v_x_30_);
lean_ctor_set(v_reuseFailAlloc_52_, 1, v___x_41_);
v___x_43_ = v_reuseFailAlloc_52_;
goto v_reusejp_42_;
}
v_reusejp_42_:
{
lean_object* v___x_44_; lean_object* v___x_46_; 
v___x_44_ = lean_obj_once(&l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__3, &l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__3_once, _init_l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__3);
if (v_isShared_36_ == 0)
{
lean_ctor_set_tag(v___x_35_, 7);
lean_ctor_set(v___x_35_, 1, v___x_44_);
lean_ctor_set(v___x_35_, 0, v___x_43_);
v___x_46_ = v___x_35_;
goto v_reusejp_45_;
}
else
{
lean_object* v_reuseFailAlloc_51_; 
v_reuseFailAlloc_51_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v_reuseFailAlloc_51_, 0, v___x_43_);
lean_ctor_set(v_reuseFailAlloc_51_, 1, v___x_44_);
v___x_46_ = v_reuseFailAlloc_51_;
goto v_reusejp_45_;
}
v_reusejp_45_:
{
lean_object* v___x_47_; lean_object* v___x_48_; lean_object* v___x_49_; 
v___x_47_ = l_Lean_MessageData_ofSyntax(v_before_37_);
v___x_48_ = l_Lean_indentD(v___x_47_);
v___x_49_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_49_, 0, v___x_46_);
lean_ctor_set(v___x_49_, 1, v___x_48_);
v_x_30_ = v___x_49_;
v_x_31_ = v_tail_33_;
goto _start;
}
}
}
}
}
}
}
LEAN_EXPORT uint8_t l_Lean_Option_get___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__2(lean_object* v_opts_56_, lean_object* v_opt_57_){
_start:
{
lean_object* v_name_58_; lean_object* v_defValue_59_; lean_object* v_map_60_; lean_object* v___x_61_; 
v_name_58_ = lean_ctor_get(v_opt_57_, 0);
v_defValue_59_ = lean_ctor_get(v_opt_57_, 1);
v_map_60_ = lean_ctor_get(v_opts_56_, 0);
v___x_61_ = l_Std_DTreeMap_Internal_Impl_Const_get_x3f___at___00Lean_NameMap_find_x3f_spec__0___redArg(v_map_60_, v_name_58_);
if (lean_obj_tag(v___x_61_) == 0)
{
uint8_t v___x_62_; 
v___x_62_ = lean_unbox(v_defValue_59_);
return v___x_62_;
}
else
{
lean_object* v_val_63_; 
v_val_63_ = lean_ctor_get(v___x_61_, 0);
lean_inc(v_val_63_);
lean_dec_ref_known(v___x_61_, 1);
if (lean_obj_tag(v_val_63_) == 1)
{
uint8_t v_v_64_; 
v_v_64_ = lean_ctor_get_uint8(v_val_63_, 0);
lean_dec_ref_known(v_val_63_, 0);
return v_v_64_;
}
else
{
uint8_t v___x_65_; 
lean_dec(v_val_63_);
v___x_65_ = lean_unbox(v_defValue_59_);
return v___x_65_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Option_get___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__2___boxed(lean_object* v_opts_66_, lean_object* v_opt_67_){
_start:
{
uint8_t v_res_68_; lean_object* v_r_69_; 
v_res_68_ = l_Lean_Option_get___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__2(v_opts_66_, v_opt_67_);
lean_dec_ref(v_opt_67_);
lean_dec_ref(v_opts_66_);
v_r_69_ = lean_box(v_res_68_);
return v_r_69_;
}
}
static lean_object* _init_l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__2(void){
_start:
{
lean_object* v___x_73_; lean_object* v___x_74_; 
v___x_73_ = ((lean_object*)(l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__1));
v___x_74_ = l_Lean_MessageData_ofFormat(v___x_73_);
return v___x_74_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg(lean_object* v_msgData_75_, lean_object* v_macroStack_76_, lean_object* v___y_77_){
_start:
{
lean_object* v_options_79_; lean_object* v___x_80_; uint8_t v___x_81_; 
v_options_79_ = lean_ctor_get(v___y_77_, 2);
v___x_80_ = l_Lean_Elab_pp_macroStack;
v___x_81_ = l_Lean_Option_get___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__2(v_options_79_, v___x_80_);
if (v___x_81_ == 0)
{
lean_object* v___x_82_; 
lean_dec(v_macroStack_76_);
v___x_82_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_82_, 0, v_msgData_75_);
return v___x_82_;
}
else
{
if (lean_obj_tag(v_macroStack_76_) == 0)
{
lean_object* v___x_83_; 
v___x_83_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_83_, 0, v_msgData_75_);
return v___x_83_;
}
else
{
lean_object* v_head_84_; lean_object* v_after_85_; lean_object* v___x_87_; uint8_t v_isShared_88_; uint8_t v_isSharedCheck_100_; 
v_head_84_ = lean_ctor_get(v_macroStack_76_, 0);
lean_inc(v_head_84_);
v_after_85_ = lean_ctor_get(v_head_84_, 1);
v_isSharedCheck_100_ = !lean_is_exclusive(v_head_84_);
if (v_isSharedCheck_100_ == 0)
{
lean_object* v_unused_101_; 
v_unused_101_ = lean_ctor_get(v_head_84_, 0);
lean_dec(v_unused_101_);
v___x_87_ = v_head_84_;
v_isShared_88_ = v_isSharedCheck_100_;
goto v_resetjp_86_;
}
else
{
lean_inc(v_after_85_);
lean_dec(v_head_84_);
v___x_87_ = lean_box(0);
v_isShared_88_ = v_isSharedCheck_100_;
goto v_resetjp_86_;
}
v_resetjp_86_:
{
lean_object* v___x_89_; lean_object* v___x_91_; 
v___x_89_ = lean_obj_once(&l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__0, &l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__0_once, _init_l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3___closed__0);
if (v_isShared_88_ == 0)
{
lean_ctor_set_tag(v___x_87_, 7);
lean_ctor_set(v___x_87_, 1, v___x_89_);
lean_ctor_set(v___x_87_, 0, v_msgData_75_);
v___x_91_ = v___x_87_;
goto v_reusejp_90_;
}
else
{
lean_object* v_reuseFailAlloc_99_; 
v_reuseFailAlloc_99_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v_reuseFailAlloc_99_, 0, v_msgData_75_);
lean_ctor_set(v_reuseFailAlloc_99_, 1, v___x_89_);
v___x_91_ = v_reuseFailAlloc_99_;
goto v_reusejp_90_;
}
v_reusejp_90_:
{
lean_object* v___x_92_; lean_object* v___x_93_; lean_object* v___x_94_; lean_object* v___x_95_; lean_object* v_msgData_96_; lean_object* v___x_97_; lean_object* v___x_98_; 
v___x_92_ = lean_obj_once(&l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__2, &l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__2_once, _init_l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___closed__2);
v___x_93_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_93_, 0, v___x_91_);
lean_ctor_set(v___x_93_, 1, v___x_92_);
v___x_94_ = l_Lean_MessageData_ofSyntax(v_after_85_);
v___x_95_ = l_Lean_indentD(v___x_94_);
v_msgData_96_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v_msgData_96_, 0, v___x_93_);
lean_ctor_set(v_msgData_96_, 1, v___x_95_);
v___x_97_ = l_List_foldl___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__3(v_msgData_96_, v_macroStack_76_);
v___x_98_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_98_, 0, v___x_97_);
return v___x_98_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg___boxed(lean_object* v_msgData_102_, lean_object* v_macroStack_103_, lean_object* v___y_104_, lean_object* v___y_105_){
_start:
{
lean_object* v_res_106_; 
v_res_106_ = l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg(v_msgData_102_, v_macroStack_103_, v___y_104_);
lean_dec_ref(v___y_104_);
return v_res_106_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0___redArg(lean_object* v_msg_107_, lean_object* v___y_108_, lean_object* v___y_109_, lean_object* v___y_110_, lean_object* v___y_111_, lean_object* v___y_112_, lean_object* v___y_113_){
_start:
{
lean_object* v_ref_115_; lean_object* v___x_116_; lean_object* v_a_117_; lean_object* v_macroStack_118_; lean_object* v___x_119_; lean_object* v___x_120_; lean_object* v_a_121_; lean_object* v___x_123_; uint8_t v_isShared_124_; uint8_t v_isSharedCheck_129_; 
v_ref_115_ = lean_ctor_get(v___y_112_, 5);
v___x_116_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__0(v_msg_107_, v___y_110_, v___y_111_, v___y_112_, v___y_113_);
v_a_117_ = lean_ctor_get(v___x_116_, 0);
lean_inc(v_a_117_);
lean_dec_ref(v___x_116_);
v_macroStack_118_ = lean_ctor_get(v___y_108_, 1);
v___x_119_ = l_Lean_Elab_getBetterRef(v_ref_115_, v_macroStack_118_);
lean_inc(v_macroStack_118_);
v___x_120_ = l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg(v_a_117_, v_macroStack_118_, v___y_112_);
v_a_121_ = lean_ctor_get(v___x_120_, 0);
v_isSharedCheck_129_ = !lean_is_exclusive(v___x_120_);
if (v_isSharedCheck_129_ == 0)
{
v___x_123_ = v___x_120_;
v_isShared_124_ = v_isSharedCheck_129_;
goto v_resetjp_122_;
}
else
{
lean_inc(v_a_121_);
lean_dec(v___x_120_);
v___x_123_ = lean_box(0);
v_isShared_124_ = v_isSharedCheck_129_;
goto v_resetjp_122_;
}
v_resetjp_122_:
{
lean_object* v___x_125_; lean_object* v___x_127_; 
v___x_125_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_125_, 0, v___x_119_);
lean_ctor_set(v___x_125_, 1, v_a_121_);
if (v_isShared_124_ == 0)
{
lean_ctor_set_tag(v___x_123_, 1);
lean_ctor_set(v___x_123_, 0, v___x_125_);
v___x_127_ = v___x_123_;
goto v_reusejp_126_;
}
else
{
lean_object* v_reuseFailAlloc_128_; 
v_reuseFailAlloc_128_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_128_, 0, v___x_125_);
v___x_127_ = v_reuseFailAlloc_128_;
goto v_reusejp_126_;
}
v_reusejp_126_:
{
return v___x_127_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0___redArg___boxed(lean_object* v_msg_130_, lean_object* v___y_131_, lean_object* v___y_132_, lean_object* v___y_133_, lean_object* v___y_134_, lean_object* v___y_135_, lean_object* v___y_136_, lean_object* v___y_137_){
_start:
{
lean_object* v_res_138_; 
v_res_138_ = l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0___redArg(v_msg_130_, v___y_131_, v___y_132_, v___y_133_, v___y_134_, v___y_135_, v___y_136_);
lean_dec(v___y_136_);
lean_dec_ref(v___y_135_);
lean_dec(v___y_134_);
lean_dec_ref(v___y_133_);
lean_dec(v___y_132_);
lean_dec_ref(v___y_131_);
return v_res_138_;
}
}
static lean_object* _init_l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__1(void){
_start:
{
lean_object* v___x_140_; lean_object* v___x_141_; 
v___x_140_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__0));
v___x_141_ = l_Lean_stringToMessageData(v___x_140_);
return v___x_141_;
}
}
static lean_object* _init_l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__3(void){
_start:
{
lean_object* v___x_143_; lean_object* v___x_144_; 
v___x_143_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__2));
v___x_144_ = l_Lean_stringToMessageData(v___x_143_);
return v___x_144_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir(lean_object* v_a_145_, lean_object* v_a_146_, lean_object* v_a_147_, lean_object* v_a_148_, lean_object* v_a_149_, lean_object* v_a_150_){
_start:
{
lean_object* v_fileName_152_; lean_object* v___x_153_; 
v_fileName_152_ = lean_ctor_get(v_a_149_, 0);
lean_inc_ref(v_fileName_152_);
v___x_153_ = l_System_FilePath_parent(v_fileName_152_);
if (lean_obj_tag(v___x_153_) == 1)
{
lean_object* v_val_154_; lean_object* v___x_156_; uint8_t v_isShared_157_; uint8_t v_isSharedCheck_161_; 
v_val_154_ = lean_ctor_get(v___x_153_, 0);
v_isSharedCheck_161_ = !lean_is_exclusive(v___x_153_);
if (v_isSharedCheck_161_ == 0)
{
v___x_156_ = v___x_153_;
v_isShared_157_ = v_isSharedCheck_161_;
goto v_resetjp_155_;
}
else
{
lean_inc(v_val_154_);
lean_dec(v___x_153_);
v___x_156_ = lean_box(0);
v_isShared_157_ = v_isSharedCheck_161_;
goto v_resetjp_155_;
}
v_resetjp_155_:
{
lean_object* v___x_159_; 
if (v_isShared_157_ == 0)
{
lean_ctor_set_tag(v___x_156_, 0);
v___x_159_ = v___x_156_;
goto v_reusejp_158_;
}
else
{
lean_object* v_reuseFailAlloc_160_; 
v_reuseFailAlloc_160_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_160_, 0, v_val_154_);
v___x_159_ = v_reuseFailAlloc_160_;
goto v_reusejp_158_;
}
v_reusejp_158_:
{
return v___x_159_;
}
}
}
else
{
lean_object* v___x_162_; lean_object* v___x_163_; lean_object* v___x_164_; lean_object* v___x_165_; lean_object* v___x_166_; lean_object* v___x_167_; lean_object* v___x_168_; 
lean_dec(v___x_153_);
v___x_162_ = lean_obj_once(&l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__1, &l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__1_once, _init_l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__1);
lean_inc_ref(v_fileName_152_);
v___x_163_ = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(v___x_163_, 0, v_fileName_152_);
v___x_164_ = l_Lean_MessageData_ofFormat(v___x_163_);
v___x_165_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_165_, 0, v___x_162_);
lean_ctor_set(v___x_165_, 1, v___x_164_);
v___x_166_ = lean_obj_once(&l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__3, &l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__3_once, _init_l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___closed__3);
v___x_167_ = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(v___x_167_, 0, v___x_165_);
lean_ctor_set(v___x_167_, 1, v___x_166_);
v___x_168_ = l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0___redArg(v___x_167_, v_a_145_, v_a_146_, v_a_147_, v_a_148_, v_a_149_, v_a_150_);
return v___x_168_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir___boxed(lean_object* v_a_169_, lean_object* v_a_170_, lean_object* v_a_171_, lean_object* v_a_172_, lean_object* v_a_173_, lean_object* v_a_174_, lean_object* v_a_175_){
_start:
{
lean_object* v_res_176_; 
v_res_176_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir(v_a_169_, v_a_170_, v_a_171_, v_a_172_, v_a_173_, v_a_174_);
lean_dec(v_a_174_);
lean_dec_ref(v_a_173_);
lean_dec(v_a_172_);
lean_dec_ref(v_a_171_);
lean_dec(v_a_170_);
lean_dec_ref(v_a_169_);
return v_res_176_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0(lean_object* v_00_u03b1_177_, lean_object* v_msg_178_, lean_object* v___y_179_, lean_object* v___y_180_, lean_object* v___y_181_, lean_object* v___y_182_, lean_object* v___y_183_, lean_object* v___y_184_){
_start:
{
lean_object* v___x_186_; 
v___x_186_ = l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0___redArg(v_msg_178_, v___y_179_, v___y_180_, v___y_181_, v___y_182_, v___y_183_, v___y_184_);
return v___x_186_;
}
}
LEAN_EXPORT lean_object* l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0___boxed(lean_object* v_00_u03b1_187_, lean_object* v_msg_188_, lean_object* v___y_189_, lean_object* v___y_190_, lean_object* v___y_191_, lean_object* v___y_192_, lean_object* v___y_193_, lean_object* v___y_194_, lean_object* v___y_195_){
_start:
{
lean_object* v_res_196_; 
v_res_196_ = l_Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0(v_00_u03b1_187_, v_msg_188_, v___y_189_, v___y_190_, v___y_191_, v___y_192_, v___y_193_, v___y_194_);
lean_dec(v___y_194_);
lean_dec_ref(v___y_193_);
lean_dec(v___y_192_);
lean_dec_ref(v___y_191_);
lean_dec(v___y_190_);
lean_dec_ref(v___y_189_);
return v_res_196_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1(lean_object* v_msgData_197_, lean_object* v_macroStack_198_, lean_object* v___y_199_, lean_object* v___y_200_, lean_object* v___y_201_, lean_object* v___y_202_, lean_object* v___y_203_, lean_object* v___y_204_){
_start:
{
lean_object* v___x_206_; 
v___x_206_ = l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___redArg(v_msgData_197_, v_macroStack_198_, v___y_203_);
return v___x_206_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1___boxed(lean_object* v_msgData_207_, lean_object* v_macroStack_208_, lean_object* v___y_209_, lean_object* v___y_210_, lean_object* v___y_211_, lean_object* v___y_212_, lean_object* v___y_213_, lean_object* v___y_214_, lean_object* v___y_215_){
_start:
{
lean_object* v_res_216_; 
v_res_216_ = l_Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1(v_msgData_207_, v_macroStack_208_, v___y_209_, v___y_210_, v___y_211_, v___y_212_, v___y_213_, v___y_214_);
lean_dec(v___y_214_);
lean_dec_ref(v___y_213_);
lean_dec(v___y_212_);
lean_dec_ref(v___y_211_);
lean_dec(v___y_210_);
lean_dec_ref(v___y_209_);
return v_res_216_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_mkContext(lean_object* v_lratPath_217_, lean_object* v_cfg_218_, lean_object* v_a_219_, lean_object* v_a_220_, lean_object* v_a_221_, lean_object* v_a_222_, lean_object* v_a_223_, lean_object* v_a_224_){
_start:
{
lean_object* v___x_226_; 
v___x_226_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir(v_a_219_, v_a_220_, v_a_221_, v_a_222_, v_a_223_, v_a_224_);
if (lean_obj_tag(v___x_226_) == 0)
{
lean_object* v_a_227_; lean_object* v___x_228_; lean_object* v___x_229_; 
v_a_227_ = lean_ctor_get(v___x_226_, 0);
lean_inc(v_a_227_);
lean_dec_ref_known(v___x_226_, 1);
v___x_228_ = l_System_FilePath_join(v_a_227_, v_lratPath_217_);
v___x_229_ = l_Lean_Meta_Tactic_BVDecide_TacticContext_new(v___x_228_, v_cfg_218_, v_a_219_, v_a_220_, v_a_221_, v_a_222_, v_a_223_, v_a_224_);
return v___x_229_;
}
else
{
lean_object* v_a_230_; lean_object* v___x_232_; uint8_t v_isShared_233_; uint8_t v_isSharedCheck_237_; 
lean_dec_ref(v_cfg_218_);
lean_dec_ref(v_lratPath_217_);
v_a_230_ = lean_ctor_get(v___x_226_, 0);
v_isSharedCheck_237_ = !lean_is_exclusive(v___x_226_);
if (v_isSharedCheck_237_ == 0)
{
v___x_232_ = v___x_226_;
v_isShared_233_ = v_isSharedCheck_237_;
goto v_resetjp_231_;
}
else
{
lean_inc(v_a_230_);
lean_dec(v___x_226_);
v___x_232_ = lean_box(0);
v_isShared_233_ = v_isSharedCheck_237_;
goto v_resetjp_231_;
}
v_resetjp_231_:
{
lean_object* v___x_235_; 
if (v_isShared_233_ == 0)
{
v___x_235_ = v___x_232_;
goto v_reusejp_234_;
}
else
{
lean_object* v_reuseFailAlloc_236_; 
v_reuseFailAlloc_236_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_236_, 0, v_a_230_);
v___x_235_ = v_reuseFailAlloc_236_;
goto v_reusejp_234_;
}
v_reusejp_234_:
{
return v___x_235_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_mkContext___boxed(lean_object* v_lratPath_238_, lean_object* v_cfg_239_, lean_object* v_a_240_, lean_object* v_a_241_, lean_object* v_a_242_, lean_object* v_a_243_, lean_object* v_a_244_, lean_object* v_a_245_, lean_object* v_a_246_){
_start:
{
lean_object* v_res_247_; 
v_res_247_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_mkContext(v_lratPath_238_, v_cfg_239_, v_a_240_, v_a_241_, v_a_242_, v_a_243_, v_a_244_, v_a_245_);
lean_dec(v_a_245_);
lean_dec_ref(v_a_244_);
lean_dec(v_a_243_);
lean_dec_ref(v_a_242_);
lean_dec(v_a_241_);
lean_dec_ref(v_a_240_);
return v_res_247_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck___lam__0(lean_object* v_g_248_, lean_object* v___x_249_, lean_object* v___x_250_, lean_object* v___y_251_, lean_object* v___y_252_, lean_object* v___y_253_, lean_object* v___y_254_, lean_object* v___y_255_, lean_object* v___y_256_, lean_object* v___y_257_, lean_object* v___y_258_){
_start:
{
lean_object* v___x_260_; 
v___x_260_ = l_Lean_Meta_Tactic_BVDecide_closeWithBVReflection___redArg(v_g_248_, v___x_249_, v___y_251_, v___y_252_, v___y_253_, v___y_254_, v___y_255_, v___y_256_, v___y_257_, v___y_258_);
if (lean_obj_tag(v___x_260_) == 0)
{
lean_object* v___x_262_; uint8_t v_isShared_263_; uint8_t v_isSharedCheck_267_; 
v_isSharedCheck_267_ = !lean_is_exclusive(v___x_260_);
if (v_isSharedCheck_267_ == 0)
{
lean_object* v_unused_268_; 
v_unused_268_ = lean_ctor_get(v___x_260_, 0);
lean_dec(v_unused_268_);
v___x_262_ = v___x_260_;
v_isShared_263_ = v_isSharedCheck_267_;
goto v_resetjp_261_;
}
else
{
lean_dec(v___x_260_);
v___x_262_ = lean_box(0);
v_isShared_263_ = v_isSharedCheck_267_;
goto v_resetjp_261_;
}
v_resetjp_261_:
{
lean_object* v___x_265_; 
if (v_isShared_263_ == 0)
{
lean_ctor_set(v___x_262_, 0, v___x_250_);
v___x_265_ = v___x_262_;
goto v_reusejp_264_;
}
else
{
lean_object* v_reuseFailAlloc_266_; 
v_reuseFailAlloc_266_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_266_, 0, v___x_250_);
v___x_265_ = v_reuseFailAlloc_266_;
goto v_reusejp_264_;
}
v_reusejp_264_:
{
return v___x_265_;
}
}
}
else
{
lean_object* v_a_269_; lean_object* v___x_271_; uint8_t v_isShared_272_; uint8_t v_isSharedCheck_276_; 
v_a_269_ = lean_ctor_get(v___x_260_, 0);
v_isSharedCheck_276_ = !lean_is_exclusive(v___x_260_);
if (v_isSharedCheck_276_ == 0)
{
v___x_271_ = v___x_260_;
v_isShared_272_ = v_isSharedCheck_276_;
goto v_resetjp_270_;
}
else
{
lean_inc(v_a_269_);
lean_dec(v___x_260_);
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
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck___lam__0___boxed(lean_object* v_g_277_, lean_object* v___x_278_, lean_object* v___x_279_, lean_object* v___y_280_, lean_object* v___y_281_, lean_object* v___y_282_, lean_object* v___y_283_, lean_object* v___y_284_, lean_object* v___y_285_, lean_object* v___y_286_, lean_object* v___y_287_, lean_object* v___y_288_){
_start:
{
lean_object* v_res_289_; 
v_res_289_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck___lam__0(v_g_277_, v___x_278_, v___x_279_, v___y_280_, v___y_281_, v___y_282_, v___y_283_, v___y_284_, v___y_285_, v___y_286_, v___y_287_);
lean_dec(v___y_287_);
lean_dec_ref(v___y_286_);
lean_dec(v___y_285_);
lean_dec_ref(v___y_284_);
lean_dec(v___y_283_);
lean_dec_ref(v___y_282_);
lean_dec(v___y_281_);
lean_dec_ref(v___y_280_);
return v_res_289_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck(lean_object* v_g_290_, lean_object* v_hypotheses_291_, lean_object* v_ctx_292_, lean_object* v_a_293_, lean_object* v_a_294_, lean_object* v_a_295_, lean_object* v_a_296_, lean_object* v_a_297_, lean_object* v_a_298_){
_start:
{
lean_object* v___x_300_; lean_object* v___x_301_; lean_object* v___f_302_; lean_object* v___x_303_; 
v___x_300_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_lratChecker___boxed), 9, 1);
lean_closure_set(v___x_300_, 0, v_ctx_292_);
v___x_301_ = lean_box(0);
v___f_302_ = lean_alloc_closure((void*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck___lam__0___boxed), 12, 3);
lean_closure_set(v___f_302_, 0, v_g_290_);
lean_closure_set(v___f_302_, 1, v___x_300_);
lean_closure_set(v___f_302_, 2, v___x_301_);
v___x_303_ = l_Lean_Meta_Tactic_BVDecide_M_run___redArg(v___f_302_, v_hypotheses_291_, v_a_293_, v_a_294_, v_a_295_, v_a_296_, v_a_297_, v_a_298_);
return v___x_303_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck___boxed(lean_object* v_g_304_, lean_object* v_hypotheses_305_, lean_object* v_ctx_306_, lean_object* v_a_307_, lean_object* v_a_308_, lean_object* v_a_309_, lean_object* v_a_310_, lean_object* v_a_311_, lean_object* v_a_312_, lean_object* v_a_313_){
_start:
{
lean_object* v_res_314_; 
v_res_314_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck(v_g_304_, v_hypotheses_305_, v_ctx_306_, v_a_307_, v_a_308_, v_a_309_, v_a_310_, v_a_311_, v_a_312_);
lean_dec(v_a_312_);
lean_dec_ref(v_a_311_);
lean_dec(v_a_310_);
lean_dec_ref(v_a_309_);
lean_dec(v_a_308_);
lean_dec_ref(v_a_307_);
return v_res_314_;
}
}
static lean_object* _init_l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg___closed__0(void){
_start:
{
lean_object* v___x_315_; lean_object* v___x_316_; lean_object* v___x_317_; 
v___x_315_ = lean_box(0);
v___x_316_ = l_Lean_Elab_unsupportedSyntaxExceptionId;
v___x_317_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v___x_317_, 0, v___x_316_);
lean_ctor_set(v___x_317_, 1, v___x_315_);
return v___x_317_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg(){
_start:
{
lean_object* v___x_319_; lean_object* v___x_320_; 
v___x_319_ = lean_obj_once(&l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg___closed__0, &l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg___closed__0_once, _init_l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg___closed__0);
v___x_320_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_320_, 0, v___x_319_);
return v___x_320_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg___boxed(lean_object* v___y_321_){
_start:
{
lean_object* v_res_322_; 
v_res_322_ = l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg();
return v_res_322_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0(lean_object* v_00_u03b1_323_, lean_object* v___y_324_, lean_object* v___y_325_, lean_object* v___y_326_, lean_object* v___y_327_, lean_object* v___y_328_, lean_object* v___y_329_, lean_object* v___y_330_, lean_object* v___y_331_){
_start:
{
lean_object* v___x_333_; 
v___x_333_ = l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg();
return v___x_333_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___boxed(lean_object* v_00_u03b1_334_, lean_object* v___y_335_, lean_object* v___y_336_, lean_object* v___y_337_, lean_object* v___y_338_, lean_object* v___y_339_, lean_object* v___y_340_, lean_object* v___y_341_, lean_object* v___y_342_, lean_object* v___y_343_){
_start:
{
lean_object* v_res_344_; 
v_res_344_ = l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0(v_00_u03b1_334_, v___y_335_, v___y_336_, v___y_337_, v___y_338_, v___y_339_, v___y_340_, v___y_341_, v___y_342_);
lean_dec(v___y_342_);
lean_dec_ref(v___y_341_);
lean_dec(v___y_340_);
lean_dec_ref(v___y_339_);
lean_dec(v___y_338_);
lean_dec_ref(v___y_337_);
lean_dec(v___y_336_);
lean_dec_ref(v___y_335_);
return v_res_344_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg___lam__0(lean_object* v_x_345_, lean_object* v___y_346_, lean_object* v___y_347_, lean_object* v___y_348_, lean_object* v___y_349_, lean_object* v___y_350_, lean_object* v___y_351_){
_start:
{
lean_object* v___x_353_; 
lean_inc(v___y_347_);
lean_inc_ref(v___y_346_);
v___x_353_ = lean_apply_7(v_x_345_, v___y_346_, v___y_347_, v___y_348_, v___y_349_, v___y_350_, v___y_351_, lean_box(0));
return v___x_353_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg___lam__0___boxed(lean_object* v_x_354_, lean_object* v___y_355_, lean_object* v___y_356_, lean_object* v___y_357_, lean_object* v___y_358_, lean_object* v___y_359_, lean_object* v___y_360_, lean_object* v___y_361_){
_start:
{
lean_object* v_res_362_; 
v_res_362_ = l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg___lam__0(v_x_354_, v___y_355_, v___y_356_, v___y_357_, v___y_358_, v___y_359_, v___y_360_);
lean_dec(v___y_356_);
lean_dec_ref(v___y_355_);
return v_res_362_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg(lean_object* v_mvarId_363_, lean_object* v_x_364_, lean_object* v___y_365_, lean_object* v___y_366_, lean_object* v___y_367_, lean_object* v___y_368_, lean_object* v___y_369_, lean_object* v___y_370_){
_start:
{
lean_object* v___f_372_; lean_object* v___x_373_; 
lean_inc(v___y_366_);
lean_inc_ref(v___y_365_);
v___f_372_ = lean_alloc_closure((void*)(l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg___lam__0___boxed), 8, 3);
lean_closure_set(v___f_372_, 0, v_x_364_);
lean_closure_set(v___f_372_, 1, v___y_365_);
lean_closure_set(v___f_372_, 2, v___y_366_);
v___x_373_ = l___private_Lean_Meta_Basic_0__Lean_Meta_withMVarContextImp(lean_box(0), v_mvarId_363_, v___f_372_, v___y_367_, v___y_368_, v___y_369_, v___y_370_);
if (lean_obj_tag(v___x_373_) == 0)
{
return v___x_373_;
}
else
{
lean_object* v_a_374_; lean_object* v___x_376_; uint8_t v_isShared_377_; uint8_t v_isSharedCheck_381_; 
v_a_374_ = lean_ctor_get(v___x_373_, 0);
v_isSharedCheck_381_ = !lean_is_exclusive(v___x_373_);
if (v_isSharedCheck_381_ == 0)
{
v___x_376_ = v___x_373_;
v_isShared_377_ = v_isSharedCheck_381_;
goto v_resetjp_375_;
}
else
{
lean_inc(v_a_374_);
lean_dec(v___x_373_);
v___x_376_ = lean_box(0);
v_isShared_377_ = v_isSharedCheck_381_;
goto v_resetjp_375_;
}
v_resetjp_375_:
{
lean_object* v___x_379_; 
if (v_isShared_377_ == 0)
{
v___x_379_ = v___x_376_;
goto v_reusejp_378_;
}
else
{
lean_object* v_reuseFailAlloc_380_; 
v_reuseFailAlloc_380_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_380_, 0, v_a_374_);
v___x_379_ = v_reuseFailAlloc_380_;
goto v_reusejp_378_;
}
v_reusejp_378_:
{
return v___x_379_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg___boxed(lean_object* v_mvarId_382_, lean_object* v_x_383_, lean_object* v___y_384_, lean_object* v___y_385_, lean_object* v___y_386_, lean_object* v___y_387_, lean_object* v___y_388_, lean_object* v___y_389_, lean_object* v___y_390_){
_start:
{
lean_object* v_res_391_; 
v_res_391_ = l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg(v_mvarId_382_, v_x_383_, v___y_384_, v___y_385_, v___y_386_, v___y_387_, v___y_388_, v___y_389_);
lean_dec(v___y_389_);
lean_dec_ref(v___y_388_);
lean_dec(v___y_387_);
lean_dec_ref(v___y_386_);
lean_dec(v___y_385_);
lean_dec_ref(v___y_384_);
return v_res_391_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1(lean_object* v_00_u03b1_392_, lean_object* v_mvarId_393_, lean_object* v_x_394_, lean_object* v___y_395_, lean_object* v___y_396_, lean_object* v___y_397_, lean_object* v___y_398_, lean_object* v___y_399_, lean_object* v___y_400_){
_start:
{
lean_object* v___x_402_; 
v___x_402_ = l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg(v_mvarId_393_, v_x_394_, v___y_395_, v___y_396_, v___y_397_, v___y_398_, v___y_399_, v___y_400_);
return v___x_402_;
}
}
LEAN_EXPORT lean_object* l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___boxed(lean_object* v_00_u03b1_403_, lean_object* v_mvarId_404_, lean_object* v_x_405_, lean_object* v___y_406_, lean_object* v___y_407_, lean_object* v___y_408_, lean_object* v___y_409_, lean_object* v___y_410_, lean_object* v___y_411_, lean_object* v___y_412_){
_start:
{
lean_object* v_res_413_; 
v_res_413_ = l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1(v_00_u03b1_403_, v_mvarId_404_, v_x_405_, v___y_406_, v___y_407_, v___y_408_, v___y_409_, v___y_410_, v___y_411_);
lean_dec(v___y_411_);
lean_dec_ref(v___y_410_);
lean_dec(v___y_409_);
lean_dec_ref(v___y_408_);
lean_dec(v___y_407_);
lean_dec_ref(v___y_406_);
return v_res_413_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__0(lean_object* v___y_414_, lean_object* v___y_415_, lean_object* v___y_416_, lean_object* v___y_417_, lean_object* v___y_418_, lean_object* v___y_419_){
_start:
{
lean_object* v___x_421_; 
v___x_421_ = l_Lean_Meta_getPropHyps(v___y_416_, v___y_417_, v___y_418_, v___y_419_);
return v___x_421_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__0___boxed(lean_object* v___y_422_, lean_object* v___y_423_, lean_object* v___y_424_, lean_object* v___y_425_, lean_object* v___y_426_, lean_object* v___y_427_, lean_object* v___y_428_){
_start:
{
lean_object* v_res_429_; 
v_res_429_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__0(v___y_422_, v___y_423_, v___y_424_, v___y_425_, v___y_426_, v___y_427_);
lean_dec(v___y_427_);
lean_dec_ref(v___y_426_);
lean_dec(v___y_425_);
lean_dec_ref(v___y_424_);
lean_dec(v___y_423_);
lean_dec_ref(v___y_422_);
return v_res_429_;
}
}
LEAN_EXPORT uint8_t l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0(uint8_t v___y_438_, uint8_t v_suppressElabErrors_439_, lean_object* v_x_440_){
_start:
{
if (lean_obj_tag(v_x_440_) == 1)
{
lean_object* v_pre_441_; 
v_pre_441_ = lean_ctor_get(v_x_440_, 0);
switch(lean_obj_tag(v_pre_441_))
{
case 1:
{
lean_object* v_pre_442_; 
v_pre_442_ = lean_ctor_get(v_pre_441_, 0);
switch(lean_obj_tag(v_pre_442_))
{
case 0:
{
lean_object* v_str_443_; lean_object* v_str_444_; lean_object* v___x_445_; uint8_t v___x_446_; 
v_str_443_ = lean_ctor_get(v_x_440_, 1);
v_str_444_ = lean_ctor_get(v_pre_441_, 1);
v___x_445_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__0));
v___x_446_ = lean_string_dec_eq(v_str_444_, v___x_445_);
if (v___x_446_ == 0)
{
lean_object* v___x_447_; uint8_t v___x_448_; 
v___x_447_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__1));
v___x_448_ = lean_string_dec_eq(v_str_444_, v___x_447_);
if (v___x_448_ == 0)
{
return v___y_438_;
}
else
{
lean_object* v___x_449_; uint8_t v___x_450_; 
v___x_449_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__2));
v___x_450_ = lean_string_dec_eq(v_str_443_, v___x_449_);
if (v___x_450_ == 0)
{
return v___y_438_;
}
else
{
return v_suppressElabErrors_439_;
}
}
}
else
{
lean_object* v___x_451_; uint8_t v___x_452_; 
v___x_451_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__3));
v___x_452_ = lean_string_dec_eq(v_str_443_, v___x_451_);
if (v___x_452_ == 0)
{
return v___y_438_;
}
else
{
return v_suppressElabErrors_439_;
}
}
}
case 1:
{
lean_object* v_pre_453_; 
v_pre_453_ = lean_ctor_get(v_pre_442_, 0);
if (lean_obj_tag(v_pre_453_) == 0)
{
lean_object* v_str_454_; lean_object* v_str_455_; lean_object* v_str_456_; lean_object* v___x_457_; uint8_t v___x_458_; 
v_str_454_ = lean_ctor_get(v_x_440_, 1);
v_str_455_ = lean_ctor_get(v_pre_441_, 1);
v_str_456_ = lean_ctor_get(v_pre_442_, 1);
v___x_457_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__4));
v___x_458_ = lean_string_dec_eq(v_str_456_, v___x_457_);
if (v___x_458_ == 0)
{
return v___y_438_;
}
else
{
lean_object* v___x_459_; uint8_t v___x_460_; 
v___x_459_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__5));
v___x_460_ = lean_string_dec_eq(v_str_455_, v___x_459_);
if (v___x_460_ == 0)
{
return v___y_438_;
}
else
{
lean_object* v___x_461_; uint8_t v___x_462_; 
v___x_461_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__6));
v___x_462_ = lean_string_dec_eq(v_str_454_, v___x_461_);
if (v___x_462_ == 0)
{
return v___y_438_;
}
else
{
return v_suppressElabErrors_439_;
}
}
}
}
else
{
return v___y_438_;
}
}
default: 
{
return v___y_438_;
}
}
}
case 0:
{
lean_object* v_str_463_; lean_object* v___x_464_; uint8_t v___x_465_; 
v_str_463_ = lean_ctor_get(v_x_440_, 1);
v___x_464_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__7));
v___x_465_ = lean_string_dec_eq(v_str_463_, v___x_464_);
if (v___x_465_ == 0)
{
return v___y_438_;
}
else
{
return v_suppressElabErrors_439_;
}
}
default: 
{
return v___y_438_;
}
}
}
else
{
return v___y_438_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___boxed(lean_object* v___y_466_, lean_object* v_suppressElabErrors_467_, lean_object* v_x_468_){
_start:
{
uint8_t v___y_23124__boxed_469_; uint8_t v_suppressElabErrors_boxed_470_; uint8_t v_res_471_; lean_object* v_r_472_; 
v___y_23124__boxed_469_ = lean_unbox(v___y_466_);
v_suppressElabErrors_boxed_470_ = lean_unbox(v_suppressElabErrors_467_);
v_res_471_ = l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0(v___y_23124__boxed_469_, v_suppressElabErrors_boxed_470_, v_x_468_);
lean_dec(v_x_468_);
v_r_472_ = lean_box(v_res_471_);
return v_r_472_;
}
}
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg(lean_object* v_ref_474_, lean_object* v_msgData_475_, uint8_t v_severity_476_, uint8_t v_isSilent_477_, lean_object* v___y_478_, lean_object* v___y_479_, lean_object* v___y_480_, lean_object* v___y_481_){
_start:
{
uint8_t v___y_484_; uint8_t v___y_485_; lean_object* v___y_486_; lean_object* v___y_487_; lean_object* v___y_488_; lean_object* v___y_489_; lean_object* v___y_490_; lean_object* v___y_491_; lean_object* v___y_492_; lean_object* v___y_520_; uint8_t v___y_521_; uint8_t v___y_522_; lean_object* v___y_523_; lean_object* v___y_524_; lean_object* v___y_525_; uint8_t v___y_526_; lean_object* v___y_527_; lean_object* v___y_545_; uint8_t v___y_546_; uint8_t v___y_547_; lean_object* v___y_548_; lean_object* v___y_549_; lean_object* v___y_550_; uint8_t v___y_551_; lean_object* v___y_552_; lean_object* v___y_556_; uint8_t v___y_557_; lean_object* v___y_558_; lean_object* v___y_559_; uint8_t v___y_560_; lean_object* v___y_561_; uint8_t v___y_562_; uint8_t v___x_567_; lean_object* v___y_569_; lean_object* v___y_570_; lean_object* v___y_571_; uint8_t v___y_572_; lean_object* v___y_573_; uint8_t v___y_574_; uint8_t v___y_575_; uint8_t v___y_577_; uint8_t v___x_592_; 
v___x_567_ = 2;
v___x_592_ = l_Lean_instBEqMessageSeverity_beq(v_severity_476_, v___x_567_);
if (v___x_592_ == 0)
{
v___y_577_ = v___x_592_;
goto v___jp_576_;
}
else
{
uint8_t v___x_593_; 
lean_inc_ref(v_msgData_475_);
v___x_593_ = l_Lean_MessageData_hasSyntheticSorry(v_msgData_475_);
v___y_577_ = v___x_593_;
goto v___jp_576_;
}
v___jp_483_:
{
lean_object* v___x_493_; lean_object* v_currNamespace_494_; lean_object* v_openDecls_495_; lean_object* v_env_496_; lean_object* v_nextMacroScope_497_; lean_object* v_ngen_498_; lean_object* v_auxDeclNGen_499_; lean_object* v_traceState_500_; lean_object* v_cache_501_; lean_object* v_messages_502_; lean_object* v_infoState_503_; lean_object* v_snapshotTasks_504_; lean_object* v___x_506_; uint8_t v_isShared_507_; uint8_t v_isSharedCheck_518_; 
v___x_493_ = lean_st_ref_take(v___y_492_);
v_currNamespace_494_ = lean_ctor_get(v___y_491_, 6);
v_openDecls_495_ = lean_ctor_get(v___y_491_, 7);
v_env_496_ = lean_ctor_get(v___x_493_, 0);
v_nextMacroScope_497_ = lean_ctor_get(v___x_493_, 1);
v_ngen_498_ = lean_ctor_get(v___x_493_, 2);
v_auxDeclNGen_499_ = lean_ctor_get(v___x_493_, 3);
v_traceState_500_ = lean_ctor_get(v___x_493_, 4);
v_cache_501_ = lean_ctor_get(v___x_493_, 5);
v_messages_502_ = lean_ctor_get(v___x_493_, 6);
v_infoState_503_ = lean_ctor_get(v___x_493_, 7);
v_snapshotTasks_504_ = lean_ctor_get(v___x_493_, 8);
v_isSharedCheck_518_ = !lean_is_exclusive(v___x_493_);
if (v_isSharedCheck_518_ == 0)
{
v___x_506_ = v___x_493_;
v_isShared_507_ = v_isSharedCheck_518_;
goto v_resetjp_505_;
}
else
{
lean_inc(v_snapshotTasks_504_);
lean_inc(v_infoState_503_);
lean_inc(v_messages_502_);
lean_inc(v_cache_501_);
lean_inc(v_traceState_500_);
lean_inc(v_auxDeclNGen_499_);
lean_inc(v_ngen_498_);
lean_inc(v_nextMacroScope_497_);
lean_inc(v_env_496_);
lean_dec(v___x_493_);
v___x_506_ = lean_box(0);
v_isShared_507_ = v_isSharedCheck_518_;
goto v_resetjp_505_;
}
v_resetjp_505_:
{
lean_object* v___x_508_; lean_object* v___x_509_; lean_object* v___x_510_; lean_object* v___x_511_; lean_object* v___x_513_; 
lean_inc(v_openDecls_495_);
lean_inc(v_currNamespace_494_);
v___x_508_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_508_, 0, v_currNamespace_494_);
lean_ctor_set(v___x_508_, 1, v_openDecls_495_);
v___x_509_ = lean_alloc_ctor(4, 2, 0);
lean_ctor_set(v___x_509_, 0, v___x_508_);
lean_ctor_set(v___x_509_, 1, v___y_490_);
lean_inc_ref(v___y_488_);
lean_inc_ref(v___y_489_);
v___x_510_ = lean_alloc_ctor(0, 5, 3);
lean_ctor_set(v___x_510_, 0, v___y_489_);
lean_ctor_set(v___x_510_, 1, v___y_486_);
lean_ctor_set(v___x_510_, 2, v___y_487_);
lean_ctor_set(v___x_510_, 3, v___y_488_);
lean_ctor_set(v___x_510_, 4, v___x_509_);
lean_ctor_set_uint8(v___x_510_, sizeof(void*)*5, v___y_485_);
lean_ctor_set_uint8(v___x_510_, sizeof(void*)*5 + 1, v___y_484_);
lean_ctor_set_uint8(v___x_510_, sizeof(void*)*5 + 2, v_isSilent_477_);
v___x_511_ = l_Lean_MessageLog_add(v___x_510_, v_messages_502_);
if (v_isShared_507_ == 0)
{
lean_ctor_set(v___x_506_, 6, v___x_511_);
v___x_513_ = v___x_506_;
goto v_reusejp_512_;
}
else
{
lean_object* v_reuseFailAlloc_517_; 
v_reuseFailAlloc_517_ = lean_alloc_ctor(0, 9, 0);
lean_ctor_set(v_reuseFailAlloc_517_, 0, v_env_496_);
lean_ctor_set(v_reuseFailAlloc_517_, 1, v_nextMacroScope_497_);
lean_ctor_set(v_reuseFailAlloc_517_, 2, v_ngen_498_);
lean_ctor_set(v_reuseFailAlloc_517_, 3, v_auxDeclNGen_499_);
lean_ctor_set(v_reuseFailAlloc_517_, 4, v_traceState_500_);
lean_ctor_set(v_reuseFailAlloc_517_, 5, v_cache_501_);
lean_ctor_set(v_reuseFailAlloc_517_, 6, v___x_511_);
lean_ctor_set(v_reuseFailAlloc_517_, 7, v_infoState_503_);
lean_ctor_set(v_reuseFailAlloc_517_, 8, v_snapshotTasks_504_);
v___x_513_ = v_reuseFailAlloc_517_;
goto v_reusejp_512_;
}
v_reusejp_512_:
{
lean_object* v___x_514_; lean_object* v___x_515_; lean_object* v___x_516_; 
v___x_514_ = lean_st_ref_set(v___y_492_, v___x_513_);
v___x_515_ = lean_box(0);
v___x_516_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_516_, 0, v___x_515_);
return v___x_516_;
}
}
}
v___jp_519_:
{
lean_object* v___x_528_; lean_object* v___x_529_; lean_object* v_a_530_; lean_object* v___x_532_; uint8_t v_isShared_533_; uint8_t v_isSharedCheck_543_; 
v___x_528_ = l___private_Lean_Log_0__Lean_MessageData_appendDescriptionWidgetIfNamed(v_msgData_475_);
v___x_529_ = l_Lean_addMessageContextFull___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__0(v___x_528_, v___y_478_, v___y_479_, v___y_480_, v___y_481_);
v_a_530_ = lean_ctor_get(v___x_529_, 0);
v_isSharedCheck_543_ = !lean_is_exclusive(v___x_529_);
if (v_isSharedCheck_543_ == 0)
{
v___x_532_ = v___x_529_;
v_isShared_533_ = v_isSharedCheck_543_;
goto v_resetjp_531_;
}
else
{
lean_inc(v_a_530_);
lean_dec(v___x_529_);
v___x_532_ = lean_box(0);
v_isShared_533_ = v_isSharedCheck_543_;
goto v_resetjp_531_;
}
v_resetjp_531_:
{
lean_object* v___x_534_; lean_object* v___x_535_; lean_object* v___x_536_; lean_object* v___x_537_; 
lean_inc_ref_n(v___y_523_, 2);
v___x_534_ = l_Lean_FileMap_toPosition(v___y_523_, v___y_525_);
lean_dec(v___y_525_);
v___x_535_ = l_Lean_FileMap_toPosition(v___y_523_, v___y_527_);
lean_dec(v___y_527_);
v___x_536_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v___x_536_, 0, v___x_535_);
v___x_537_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___closed__0));
if (v___y_526_ == 0)
{
lean_del_object(v___x_532_);
lean_dec_ref(v___y_520_);
v___y_484_ = v___y_522_;
v___y_485_ = v___y_521_;
v___y_486_ = v___x_534_;
v___y_487_ = v___x_536_;
v___y_488_ = v___x_537_;
v___y_489_ = v___y_524_;
v___y_490_ = v_a_530_;
v___y_491_ = v___y_480_;
v___y_492_ = v___y_481_;
goto v___jp_483_;
}
else
{
uint8_t v___x_538_; 
lean_inc(v_a_530_);
v___x_538_ = l_Lean_MessageData_hasTag(v___y_520_, v_a_530_);
if (v___x_538_ == 0)
{
lean_object* v___x_539_; lean_object* v___x_541_; 
lean_dec_ref_known(v___x_536_, 1);
lean_dec_ref(v___x_534_);
lean_dec(v_a_530_);
v___x_539_ = lean_box(0);
if (v_isShared_533_ == 0)
{
lean_ctor_set(v___x_532_, 0, v___x_539_);
v___x_541_ = v___x_532_;
goto v_reusejp_540_;
}
else
{
lean_object* v_reuseFailAlloc_542_; 
v_reuseFailAlloc_542_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_542_, 0, v___x_539_);
v___x_541_ = v_reuseFailAlloc_542_;
goto v_reusejp_540_;
}
v_reusejp_540_:
{
return v___x_541_;
}
}
else
{
lean_del_object(v___x_532_);
v___y_484_ = v___y_522_;
v___y_485_ = v___y_521_;
v___y_486_ = v___x_534_;
v___y_487_ = v___x_536_;
v___y_488_ = v___x_537_;
v___y_489_ = v___y_524_;
v___y_490_ = v_a_530_;
v___y_491_ = v___y_480_;
v___y_492_ = v___y_481_;
goto v___jp_483_;
}
}
}
}
v___jp_544_:
{
lean_object* v___x_553_; 
v___x_553_ = l_Lean_Syntax_getTailPos_x3f(v___y_548_, v___y_547_);
lean_dec(v___y_548_);
if (lean_obj_tag(v___x_553_) == 0)
{
lean_inc(v___y_552_);
v___y_520_ = v___y_545_;
v___y_521_ = v___y_547_;
v___y_522_ = v___y_546_;
v___y_523_ = v___y_549_;
v___y_524_ = v___y_550_;
v___y_525_ = v___y_552_;
v___y_526_ = v___y_551_;
v___y_527_ = v___y_552_;
goto v___jp_519_;
}
else
{
lean_object* v_val_554_; 
v_val_554_ = lean_ctor_get(v___x_553_, 0);
lean_inc(v_val_554_);
lean_dec_ref_known(v___x_553_, 1);
v___y_520_ = v___y_545_;
v___y_521_ = v___y_547_;
v___y_522_ = v___y_546_;
v___y_523_ = v___y_549_;
v___y_524_ = v___y_550_;
v___y_525_ = v___y_552_;
v___y_526_ = v___y_551_;
v___y_527_ = v_val_554_;
goto v___jp_519_;
}
}
v___jp_555_:
{
lean_object* v_ref_563_; lean_object* v___x_564_; 
v_ref_563_ = l_Lean_replaceRef(v_ref_474_, v___y_561_);
v___x_564_ = l_Lean_Syntax_getPos_x3f(v_ref_563_, v___y_557_);
if (lean_obj_tag(v___x_564_) == 0)
{
lean_object* v___x_565_; 
v___x_565_ = lean_unsigned_to_nat(0u);
v___y_545_ = v___y_556_;
v___y_546_ = v___y_562_;
v___y_547_ = v___y_557_;
v___y_548_ = v_ref_563_;
v___y_549_ = v___y_558_;
v___y_550_ = v___y_559_;
v___y_551_ = v___y_560_;
v___y_552_ = v___x_565_;
goto v___jp_544_;
}
else
{
lean_object* v_val_566_; 
v_val_566_ = lean_ctor_get(v___x_564_, 0);
lean_inc(v_val_566_);
lean_dec_ref_known(v___x_564_, 1);
v___y_545_ = v___y_556_;
v___y_546_ = v___y_562_;
v___y_547_ = v___y_557_;
v___y_548_ = v_ref_563_;
v___y_549_ = v___y_558_;
v___y_550_ = v___y_559_;
v___y_551_ = v___y_560_;
v___y_552_ = v_val_566_;
goto v___jp_544_;
}
}
v___jp_568_:
{
if (v___y_575_ == 0)
{
v___y_556_ = v___y_569_;
v___y_557_ = v___y_574_;
v___y_558_ = v___y_570_;
v___y_559_ = v___y_571_;
v___y_560_ = v___y_572_;
v___y_561_ = v___y_573_;
v___y_562_ = v_severity_476_;
goto v___jp_555_;
}
else
{
v___y_556_ = v___y_569_;
v___y_557_ = v___y_574_;
v___y_558_ = v___y_570_;
v___y_559_ = v___y_571_;
v___y_560_ = v___y_572_;
v___y_561_ = v___y_573_;
v___y_562_ = v___x_567_;
goto v___jp_555_;
}
}
v___jp_576_:
{
if (v___y_577_ == 0)
{
lean_object* v_fileName_578_; lean_object* v_fileMap_579_; lean_object* v_options_580_; lean_object* v_ref_581_; uint8_t v_suppressElabErrors_582_; lean_object* v___x_583_; lean_object* v___x_584_; lean_object* v___f_585_; uint8_t v___x_586_; uint8_t v___x_587_; 
v_fileName_578_ = lean_ctor_get(v___y_480_, 0);
v_fileMap_579_ = lean_ctor_get(v___y_480_, 1);
v_options_580_ = lean_ctor_get(v___y_480_, 2);
v_ref_581_ = lean_ctor_get(v___y_480_, 5);
v_suppressElabErrors_582_ = lean_ctor_get_uint8(v___y_480_, sizeof(void*)*14 + 1);
v___x_583_ = lean_box(v___y_577_);
v___x_584_ = lean_box(v_suppressElabErrors_582_);
v___f_585_ = lean_alloc_closure((void*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___boxed), 3, 2);
lean_closure_set(v___f_585_, 0, v___x_583_);
lean_closure_set(v___f_585_, 1, v___x_584_);
v___x_586_ = 1;
v___x_587_ = l_Lean_instBEqMessageSeverity_beq(v_severity_476_, v___x_586_);
if (v___x_587_ == 0)
{
v___y_569_ = v___f_585_;
v___y_570_ = v_fileMap_579_;
v___y_571_ = v_fileName_578_;
v___y_572_ = v_suppressElabErrors_582_;
v___y_573_ = v_ref_581_;
v___y_574_ = v___y_577_;
v___y_575_ = v___x_587_;
goto v___jp_568_;
}
else
{
lean_object* v___x_588_; uint8_t v___x_589_; 
v___x_588_ = l_Lean_warningAsError;
v___x_589_ = l_Lean_Option_get___at___00Lean_Elab_addMacroStack___at___00Lean_throwError___at___00Lean_Elab_Tactic_BVDecide_BVCheck_getSrcDir_spec__0_spec__1_spec__2(v_options_580_, v___x_588_);
v___y_569_ = v___f_585_;
v___y_570_ = v_fileMap_579_;
v___y_571_ = v_fileName_578_;
v___y_572_ = v_suppressElabErrors_582_;
v___y_573_ = v_ref_581_;
v___y_574_ = v___y_577_;
v___y_575_ = v___x_589_;
goto v___jp_568_;
}
}
else
{
lean_object* v___x_590_; lean_object* v___x_591_; 
lean_dec_ref(v_msgData_475_);
v___x_590_ = lean_box(0);
v___x_591_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_591_, 0, v___x_590_);
return v___x_591_;
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___boxed(lean_object* v_ref_594_, lean_object* v_msgData_595_, lean_object* v_severity_596_, lean_object* v_isSilent_597_, lean_object* v___y_598_, lean_object* v___y_599_, lean_object* v___y_600_, lean_object* v___y_601_, lean_object* v___y_602_){
_start:
{
uint8_t v_severity_boxed_603_; uint8_t v_isSilent_boxed_604_; lean_object* v_res_605_; 
v_severity_boxed_603_ = lean_unbox(v_severity_596_);
v_isSilent_boxed_604_ = lean_unbox(v_isSilent_597_);
v_res_605_ = l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg(v_ref_594_, v_msgData_595_, v_severity_boxed_603_, v_isSilent_boxed_604_, v___y_598_, v___y_599_, v___y_600_, v___y_601_);
lean_dec(v___y_601_);
lean_dec_ref(v___y_600_);
lean_dec(v___y_599_);
lean_dec_ref(v___y_598_);
lean_dec(v_ref_594_);
return v_res_605_;
}
}
LEAN_EXPORT lean_object* l_Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2(lean_object* v_msgData_606_, uint8_t v_severity_607_, uint8_t v_isSilent_608_, lean_object* v___y_609_, lean_object* v___y_610_, lean_object* v___y_611_, lean_object* v___y_612_, lean_object* v___y_613_, lean_object* v___y_614_, lean_object* v___y_615_, lean_object* v___y_616_){
_start:
{
lean_object* v_ref_618_; lean_object* v___x_619_; 
v_ref_618_ = lean_ctor_get(v___y_615_, 5);
v___x_619_ = l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg(v_ref_618_, v_msgData_606_, v_severity_607_, v_isSilent_608_, v___y_613_, v___y_614_, v___y_615_, v___y_616_);
return v___x_619_;
}
}
LEAN_EXPORT lean_object* l_Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2___boxed(lean_object* v_msgData_620_, lean_object* v_severity_621_, lean_object* v_isSilent_622_, lean_object* v___y_623_, lean_object* v___y_624_, lean_object* v___y_625_, lean_object* v___y_626_, lean_object* v___y_627_, lean_object* v___y_628_, lean_object* v___y_629_, lean_object* v___y_630_, lean_object* v___y_631_){
_start:
{
uint8_t v_severity_boxed_632_; uint8_t v_isSilent_boxed_633_; lean_object* v_res_634_; 
v_severity_boxed_632_ = lean_unbox(v_severity_621_);
v_isSilent_boxed_633_ = lean_unbox(v_isSilent_622_);
v_res_634_ = l_Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2(v_msgData_620_, v_severity_boxed_632_, v_isSilent_boxed_633_, v___y_623_, v___y_624_, v___y_625_, v___y_626_, v___y_627_, v___y_628_, v___y_629_, v___y_630_);
lean_dec(v___y_630_);
lean_dec_ref(v___y_629_);
lean_dec(v___y_628_);
lean_dec_ref(v___y_627_);
lean_dec(v___y_626_);
lean_dec_ref(v___y_625_);
lean_dec(v___y_624_);
lean_dec_ref(v___y_623_);
return v_res_634_;
}
}
LEAN_EXPORT lean_object* l_Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2(lean_object* v_msgData_635_, lean_object* v___y_636_, lean_object* v___y_637_, lean_object* v___y_638_, lean_object* v___y_639_, lean_object* v___y_640_, lean_object* v___y_641_, lean_object* v___y_642_, lean_object* v___y_643_){
_start:
{
uint8_t v___x_645_; uint8_t v___x_646_; lean_object* v___x_647_; 
v___x_645_ = 1;
v___x_646_ = 0;
v___x_647_ = l_Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2(v_msgData_635_, v___x_645_, v___x_646_, v___y_636_, v___y_637_, v___y_638_, v___y_639_, v___y_640_, v___y_641_, v___y_642_, v___y_643_);
return v___x_647_;
}
}
LEAN_EXPORT lean_object* l_Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2___boxed(lean_object* v_msgData_648_, lean_object* v___y_649_, lean_object* v___y_650_, lean_object* v___y_651_, lean_object* v___y_652_, lean_object* v___y_653_, lean_object* v___y_654_, lean_object* v___y_655_, lean_object* v___y_656_, lean_object* v___y_657_){
_start:
{
lean_object* v_res_658_; 
v_res_658_ = l_Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2(v_msgData_648_, v___y_649_, v___y_650_, v___y_651_, v___y_652_, v___y_653_, v___y_654_, v___y_655_, v___y_656_);
lean_dec(v___y_656_);
lean_dec_ref(v___y_655_);
lean_dec(v___y_654_);
lean_dec_ref(v___y_653_);
lean_dec(v___y_652_);
lean_dec_ref(v___y_651_);
lean_dec(v___y_650_);
lean_dec_ref(v___y_649_);
return v_res_658_;
}
}
static lean_object* _init_l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__0(void){
_start:
{
lean_object* v___x_659_; lean_object* v___x_660_; lean_object* v___x_661_; 
v___x_659_ = lean_box(0);
v___x_660_ = lean_unsigned_to_nat(16u);
v___x_661_ = lean_mk_array(v___x_660_, v___x_659_);
return v___x_661_;
}
}
static lean_object* _init_l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__2(void){
_start:
{
lean_object* v___x_663_; lean_object* v___x_664_; 
v___x_663_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__1));
v___x_664_ = l_Lean_stringToMessageData(v___x_663_);
return v___x_664_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1(lean_object* v_a_671_, lean_object* v___f_672_, lean_object* v___x_673_, uint8_t v___x_674_, lean_object* v_a_675_, lean_object* v_a_676_, lean_object* v___x_677_, lean_object* v___x_678_, lean_object* v___x_679_, lean_object* v___x_680_, lean_object* v_tk_681_, lean_object* v___y_682_, lean_object* v___y_683_, lean_object* v___y_684_, lean_object* v___y_685_, lean_object* v___y_686_, lean_object* v___y_687_){
_start:
{
lean_object* v___x_689_; 
lean_inc(v_a_671_);
v___x_689_ = l_Lean_MVarId_withContext___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__1___redArg(v_a_671_, v___f_672_, v___y_682_, v___y_683_, v___y_684_, v___y_685_, v___y_686_, v___y_687_);
if (lean_obj_tag(v___x_689_) == 0)
{
lean_object* v_a_690_; lean_object* v___x_691_; lean_object* v___x_692_; lean_object* v___x_693_; lean_object* v___x_694_; lean_object* v___x_695_; lean_object* v___x_696_; lean_object* v___x_697_; lean_object* v___x_698_; lean_object* v___x_699_; lean_object* v___x_700_; lean_object* v___x_701_; lean_object* v___x_702_; lean_object* v___x_703_; lean_object* v___x_704_; lean_object* v___x_705_; lean_object* v___y_707_; lean_object* v___x_717_; 
v_a_690_ = lean_ctor_get(v___x_689_, 0);
lean_inc(v_a_690_);
lean_dec_ref_known(v___x_689_, 1);
v___x_691_ = lean_array_get_size(v_a_690_);
lean_dec(v_a_690_);
v___x_692_ = lean_unsigned_to_nat(4u);
v___x_693_ = lean_nat_mul(v___x_691_, v___x_692_);
v___x_694_ = lean_unsigned_to_nat(3u);
v___x_695_ = lean_nat_div(v___x_693_, v___x_694_);
lean_dec(v___x_693_);
v___x_696_ = l_Nat_nextPowerOfTwo(v___x_695_);
lean_dec(v___x_695_);
v___x_697_ = lean_box(0);
v___x_698_ = lean_mk_array(v___x_696_, v___x_697_);
lean_inc_n(v___x_673_, 2);
v___x_699_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_699_, 0, v___x_673_);
lean_ctor_set(v___x_699_, 1, v___x_698_);
v___x_700_ = lean_obj_once(&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__0, &l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__0_once, _init_l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__0);
v___x_701_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_701_, 0, v___x_673_);
lean_ctor_set(v___x_701_, 1, v___x_700_);
lean_inc_ref_n(v___x_701_, 3);
v___x_702_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_702_, 0, v___x_701_);
lean_ctor_set(v___x_702_, 1, v___x_701_);
lean_ctor_set(v___x_702_, 2, v___x_701_);
lean_ctor_set(v___x_702_, 3, v___x_701_);
v___x_703_ = lean_mk_empty_array_with_capacity(v___x_673_);
lean_dec(v___x_673_);
lean_inc_ref(v___x_699_);
v___x_704_ = lean_alloc_ctor(0, 5, 1);
lean_ctor_set(v___x_704_, 0, v___x_699_);
lean_ctor_set(v___x_704_, 1, v___x_699_);
lean_ctor_set(v___x_704_, 2, v___x_702_);
lean_ctor_set(v___x_704_, 3, v_a_671_);
lean_ctor_set(v___x_704_, 4, v___x_703_);
lean_ctor_set_uint8(v___x_704_, sizeof(void*)*5, v___x_674_);
v___x_705_ = lean_st_mk_ref(v___x_704_);
v___x_717_ = l_Lean_Meta_Tactic_BVDecide_Normalize_bvNormalize(v_a_675_, v___x_705_, v___y_682_, v___y_683_, v___y_684_, v___y_685_, v___y_686_, v___y_687_);
if (lean_obj_tag(v___x_717_) == 0)
{
lean_object* v_a_718_; uint8_t v___x_719_; 
v_a_718_ = lean_ctor_get(v___x_717_, 0);
lean_inc(v_a_718_);
lean_dec_ref_known(v___x_717_, 1);
v___x_719_ = lean_unbox(v_a_718_);
lean_dec(v_a_718_);
if (v___x_719_ == 0)
{
lean_object* v___x_720_; lean_object* v___x_721_; lean_object* v_goal_722_; lean_object* v_hypotheses_723_; lean_object* v___x_724_; 
lean_dec(v_tk_681_);
lean_dec(v___x_680_);
lean_dec_ref(v___x_679_);
lean_dec_ref(v___x_678_);
lean_dec_ref(v___x_677_);
v___x_720_ = lean_st_ref_get(v___x_705_);
v___x_721_ = lean_st_ref_get(v___x_705_);
v_goal_722_ = lean_ctor_get(v___x_720_, 3);
lean_inc(v_goal_722_);
lean_dec(v___x_720_);
v_hypotheses_723_ = lean_ctor_get(v___x_721_, 4);
lean_inc_ref(v_hypotheses_723_);
lean_dec(v___x_721_);
v___x_724_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_bvCheck(v_goal_722_, v_hypotheses_723_, v_a_676_, v___y_682_, v___y_683_, v___y_684_, v___y_685_, v___y_686_, v___y_687_);
v___y_707_ = v___x_724_;
goto v___jp_706_;
}
else
{
lean_object* v_ref_725_; lean_object* v___x_726_; lean_object* v___x_727_; 
lean_dec_ref(v_a_676_);
v_ref_725_ = lean_ctor_get(v___y_686_, 5);
v___x_726_ = lean_obj_once(&l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__2, &l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__2_once, _init_l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__2);
v___x_727_ = l_Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2(v___x_726_, v_a_675_, v___x_705_, v___y_682_, v___y_683_, v___y_684_, v___y_685_, v___y_686_, v___y_687_);
if (lean_obj_tag(v___x_727_) == 0)
{
lean_object* v___x_729_; uint8_t v_isShared_730_; uint8_t v_isSharedCheck_748_; 
v_isSharedCheck_748_ = !lean_is_exclusive(v___x_727_);
if (v_isSharedCheck_748_ == 0)
{
lean_object* v_unused_749_; 
v_unused_749_ = lean_ctor_get(v___x_727_, 0);
lean_dec(v_unused_749_);
v___x_729_ = v___x_727_;
v_isShared_730_ = v_isSharedCheck_748_;
goto v_resetjp_728_;
}
else
{
lean_dec(v___x_727_);
v___x_729_ = lean_box(0);
v_isShared_730_ = v_isSharedCheck_748_;
goto v_resetjp_728_;
}
v_resetjp_728_:
{
lean_object* v___x_731_; lean_object* v___x_732_; lean_object* v___x_733_; lean_object* v___x_734_; lean_object* v___x_735_; lean_object* v___x_736_; lean_object* v___x_737_; lean_object* v___x_738_; lean_object* v___x_739_; lean_object* v___x_740_; lean_object* v___x_742_; 
v___x_731_ = l_Lean_SourceInfo_fromRef(v_ref_725_, v___x_674_);
v___x_732_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__3));
lean_inc(v___x_731_);
v___x_733_ = lean_alloc_ctor(2, 2, 0);
lean_ctor_set(v___x_733_, 0, v___x_731_);
lean_ctor_set(v___x_733_, 1, v___x_732_);
v___x_734_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__5));
v___x_735_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__6));
v___x_736_ = l_Lean_Name_mkStr4(v___x_677_, v___x_678_, v___x_679_, v___x_735_);
v___x_737_ = l_Lean_Syntax_node2(v___x_731_, v___x_736_, v___x_733_, v___x_680_);
v___x_738_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_738_, 0, v___x_734_);
lean_ctor_set(v___x_738_, 1, v___x_737_);
v___x_739_ = lean_box(0);
v___x_740_ = lean_alloc_ctor(0, 6, 0);
lean_ctor_set(v___x_740_, 0, v___x_738_);
lean_ctor_set(v___x_740_, 1, v___x_739_);
lean_ctor_set(v___x_740_, 2, v___x_739_);
lean_ctor_set(v___x_740_, 3, v___x_739_);
lean_ctor_set(v___x_740_, 4, v___x_739_);
lean_ctor_set(v___x_740_, 5, v___x_739_);
lean_inc(v_ref_725_);
if (v_isShared_730_ == 0)
{
lean_ctor_set_tag(v___x_729_, 1);
lean_ctor_set(v___x_729_, 0, v_ref_725_);
v___x_742_ = v___x_729_;
goto v_reusejp_741_;
}
else
{
lean_object* v_reuseFailAlloc_747_; 
v_reuseFailAlloc_747_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_747_, 0, v_ref_725_);
v___x_742_ = v_reuseFailAlloc_747_;
goto v_reusejp_741_;
}
v_reusejp_741_:
{
lean_object* v___x_743_; uint8_t v___x_744_; lean_object* v___x_745_; lean_object* v___x_746_; 
v___x_743_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___closed__7));
v___x_744_ = 4;
v___x_745_ = l_Lean_MessageData_nil;
v___x_746_ = l_Lean_Meta_Tactic_TryThis_addSuggestion(v_tk_681_, v___x_740_, v___x_742_, v___x_743_, v___x_739_, v___x_744_, v___x_745_, v___y_686_, v___y_687_);
v___y_707_ = v___x_746_;
goto v___jp_706_;
}
}
}
else
{
lean_dec(v_tk_681_);
lean_dec(v___x_680_);
lean_dec_ref(v___x_679_);
lean_dec_ref(v___x_678_);
lean_dec_ref(v___x_677_);
v___y_707_ = v___x_727_;
goto v___jp_706_;
}
}
}
else
{
lean_object* v_a_750_; lean_object* v___x_752_; uint8_t v_isShared_753_; uint8_t v_isSharedCheck_757_; 
lean_dec(v___x_705_);
lean_dec(v_tk_681_);
lean_dec(v___x_680_);
lean_dec_ref(v___x_679_);
lean_dec_ref(v___x_678_);
lean_dec_ref(v___x_677_);
lean_dec_ref(v_a_676_);
v_a_750_ = lean_ctor_get(v___x_717_, 0);
v_isSharedCheck_757_ = !lean_is_exclusive(v___x_717_);
if (v_isSharedCheck_757_ == 0)
{
v___x_752_ = v___x_717_;
v_isShared_753_ = v_isSharedCheck_757_;
goto v_resetjp_751_;
}
else
{
lean_inc(v_a_750_);
lean_dec(v___x_717_);
v___x_752_ = lean_box(0);
v_isShared_753_ = v_isSharedCheck_757_;
goto v_resetjp_751_;
}
v_resetjp_751_:
{
lean_object* v___x_755_; 
if (v_isShared_753_ == 0)
{
v___x_755_ = v___x_752_;
goto v_reusejp_754_;
}
else
{
lean_object* v_reuseFailAlloc_756_; 
v_reuseFailAlloc_756_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_756_, 0, v_a_750_);
v___x_755_ = v_reuseFailAlloc_756_;
goto v_reusejp_754_;
}
v_reusejp_754_:
{
return v___x_755_;
}
}
}
v___jp_706_:
{
if (lean_obj_tag(v___y_707_) == 0)
{
lean_object* v_a_708_; lean_object* v___x_710_; uint8_t v_isShared_711_; uint8_t v_isSharedCheck_716_; 
v_a_708_ = lean_ctor_get(v___y_707_, 0);
v_isSharedCheck_716_ = !lean_is_exclusive(v___y_707_);
if (v_isSharedCheck_716_ == 0)
{
v___x_710_ = v___y_707_;
v_isShared_711_ = v_isSharedCheck_716_;
goto v_resetjp_709_;
}
else
{
lean_inc(v_a_708_);
lean_dec(v___y_707_);
v___x_710_ = lean_box(0);
v_isShared_711_ = v_isSharedCheck_716_;
goto v_resetjp_709_;
}
v_resetjp_709_:
{
lean_object* v___x_712_; lean_object* v___x_714_; 
v___x_712_ = lean_st_ref_get(v___x_705_);
lean_dec(v___x_705_);
lean_dec(v___x_712_);
if (v_isShared_711_ == 0)
{
v___x_714_ = v___x_710_;
goto v_reusejp_713_;
}
else
{
lean_object* v_reuseFailAlloc_715_; 
v_reuseFailAlloc_715_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_715_, 0, v_a_708_);
v___x_714_ = v_reuseFailAlloc_715_;
goto v_reusejp_713_;
}
v_reusejp_713_:
{
return v___x_714_;
}
}
}
else
{
lean_dec(v___x_705_);
return v___y_707_;
}
}
}
else
{
lean_object* v_a_758_; lean_object* v___x_760_; uint8_t v_isShared_761_; uint8_t v_isSharedCheck_765_; 
lean_dec(v_tk_681_);
lean_dec(v___x_680_);
lean_dec_ref(v___x_679_);
lean_dec_ref(v___x_678_);
lean_dec_ref(v___x_677_);
lean_dec_ref(v_a_676_);
lean_dec(v___x_673_);
lean_dec(v_a_671_);
v_a_758_ = lean_ctor_get(v___x_689_, 0);
v_isSharedCheck_765_ = !lean_is_exclusive(v___x_689_);
if (v_isSharedCheck_765_ == 0)
{
v___x_760_ = v___x_689_;
v_isShared_761_ = v_isSharedCheck_765_;
goto v_resetjp_759_;
}
else
{
lean_inc(v_a_758_);
lean_dec(v___x_689_);
v___x_760_ = lean_box(0);
v_isShared_761_ = v_isSharedCheck_765_;
goto v_resetjp_759_;
}
v_resetjp_759_:
{
lean_object* v___x_763_; 
if (v_isShared_761_ == 0)
{
v___x_763_ = v___x_760_;
goto v_reusejp_762_;
}
else
{
lean_object* v_reuseFailAlloc_764_; 
v_reuseFailAlloc_764_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_764_, 0, v_a_758_);
v___x_763_ = v_reuseFailAlloc_764_;
goto v_reusejp_762_;
}
v_reusejp_762_:
{
return v___x_763_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___boxed(lean_object** _args){
lean_object* v_a_766_ = _args[0];
lean_object* v___f_767_ = _args[1];
lean_object* v___x_768_ = _args[2];
lean_object* v___x_769_ = _args[3];
lean_object* v_a_770_ = _args[4];
lean_object* v_a_771_ = _args[5];
lean_object* v___x_772_ = _args[6];
lean_object* v___x_773_ = _args[7];
lean_object* v___x_774_ = _args[8];
lean_object* v___x_775_ = _args[9];
lean_object* v_tk_776_ = _args[10];
lean_object* v___y_777_ = _args[11];
lean_object* v___y_778_ = _args[12];
lean_object* v___y_779_ = _args[13];
lean_object* v___y_780_ = _args[14];
lean_object* v___y_781_ = _args[15];
lean_object* v___y_782_ = _args[16];
lean_object* v___y_783_ = _args[17];
_start:
{
uint8_t v___x_23492__boxed_784_; lean_object* v_res_785_; 
v___x_23492__boxed_784_ = lean_unbox(v___x_769_);
v_res_785_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1(v_a_766_, v___f_767_, v___x_768_, v___x_23492__boxed_784_, v_a_770_, v_a_771_, v___x_772_, v___x_773_, v___x_774_, v___x_775_, v_tk_776_, v___y_777_, v___y_778_, v___y_779_, v___y_780_, v___y_781_, v___y_782_);
lean_dec(v___y_782_);
lean_dec_ref(v___y_781_);
lean_dec(v___y_780_);
lean_dec_ref(v___y_779_);
lean_dec(v___y_778_);
lean_dec_ref(v___y_777_);
lean_dec_ref(v_a_770_);
return v_res_785_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__2(lean_object* v___f_786_, lean_object* v___x_787_, uint8_t v___x_788_, lean_object* v_a_789_, lean_object* v_a_790_, lean_object* v___x_791_, lean_object* v___x_792_, lean_object* v___x_793_, lean_object* v___x_794_, lean_object* v_tk_795_, lean_object* v___y_796_, lean_object* v___y_797_, lean_object* v___y_798_, lean_object* v___y_799_, lean_object* v___y_800_, lean_object* v___y_801_, lean_object* v___y_802_, lean_object* v___y_803_){
_start:
{
lean_object* v___x_805_; 
v___x_805_ = l_Lean_Elab_Tactic_getMainGoal___redArg(v___y_797_, v___y_800_, v___y_801_, v___y_802_, v___y_803_);
if (lean_obj_tag(v___x_805_) == 0)
{
lean_object* v_a_806_; lean_object* v___x_807_; lean_object* v___f_808_; lean_object* v___x_809_; 
v_a_806_ = lean_ctor_get(v___x_805_, 0);
lean_inc(v_a_806_);
lean_dec_ref_known(v___x_805_, 1);
v___x_807_ = lean_box(v___x_788_);
v___f_808_ = lean_alloc_closure((void*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__1___boxed), 18, 11);
lean_closure_set(v___f_808_, 0, v_a_806_);
lean_closure_set(v___f_808_, 1, v___f_786_);
lean_closure_set(v___f_808_, 2, v___x_787_);
lean_closure_set(v___f_808_, 3, v___x_807_);
lean_closure_set(v___f_808_, 4, v_a_789_);
lean_closure_set(v___f_808_, 5, v_a_790_);
lean_closure_set(v___f_808_, 6, v___x_791_);
lean_closure_set(v___f_808_, 7, v___x_792_);
lean_closure_set(v___f_808_, 8, v___x_793_);
lean_closure_set(v___f_808_, 9, v___x_794_);
lean_closure_set(v___f_808_, 10, v_tk_795_);
v___x_809_ = l_Lean_Meta_Sym_SymM_run___redArg(v___f_808_, v___y_800_, v___y_801_, v___y_802_, v___y_803_);
if (lean_obj_tag(v___x_809_) == 0)
{
lean_object* v___x_810_; lean_object* v___x_811_; 
lean_dec_ref_known(v___x_809_, 1);
v___x_810_ = lean_box(0);
v___x_811_ = l_Lean_Elab_Tactic_replaceMainGoal___redArg(v___x_810_, v___y_797_, v___y_800_, v___y_801_, v___y_802_, v___y_803_);
if (lean_obj_tag(v___x_811_) == 0)
{
lean_object* v___x_813_; uint8_t v_isShared_814_; uint8_t v_isSharedCheck_819_; 
v_isSharedCheck_819_ = !lean_is_exclusive(v___x_811_);
if (v_isSharedCheck_819_ == 0)
{
lean_object* v_unused_820_; 
v_unused_820_ = lean_ctor_get(v___x_811_, 0);
lean_dec(v_unused_820_);
v___x_813_ = v___x_811_;
v_isShared_814_ = v_isSharedCheck_819_;
goto v_resetjp_812_;
}
else
{
lean_dec(v___x_811_);
v___x_813_ = lean_box(0);
v_isShared_814_ = v_isSharedCheck_819_;
goto v_resetjp_812_;
}
v_resetjp_812_:
{
lean_object* v___x_815_; lean_object* v___x_817_; 
v___x_815_ = lean_box(0);
if (v_isShared_814_ == 0)
{
lean_ctor_set(v___x_813_, 0, v___x_815_);
v___x_817_ = v___x_813_;
goto v_reusejp_816_;
}
else
{
lean_object* v_reuseFailAlloc_818_; 
v_reuseFailAlloc_818_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_818_, 0, v___x_815_);
v___x_817_ = v_reuseFailAlloc_818_;
goto v_reusejp_816_;
}
v_reusejp_816_:
{
return v___x_817_;
}
}
}
else
{
return v___x_811_;
}
}
else
{
return v___x_809_;
}
}
else
{
lean_object* v_a_821_; lean_object* v___x_823_; uint8_t v_isShared_824_; uint8_t v_isSharedCheck_828_; 
lean_dec(v_tk_795_);
lean_dec(v___x_794_);
lean_dec_ref(v___x_793_);
lean_dec_ref(v___x_792_);
lean_dec_ref(v___x_791_);
lean_dec_ref(v_a_790_);
lean_dec_ref(v_a_789_);
lean_dec(v___x_787_);
lean_dec_ref(v___f_786_);
v_a_821_ = lean_ctor_get(v___x_805_, 0);
v_isSharedCheck_828_ = !lean_is_exclusive(v___x_805_);
if (v_isSharedCheck_828_ == 0)
{
v___x_823_ = v___x_805_;
v_isShared_824_ = v_isSharedCheck_828_;
goto v_resetjp_822_;
}
else
{
lean_inc(v_a_821_);
lean_dec(v___x_805_);
v___x_823_ = lean_box(0);
v_isShared_824_ = v_isSharedCheck_828_;
goto v_resetjp_822_;
}
v_resetjp_822_:
{
lean_object* v___x_826_; 
if (v_isShared_824_ == 0)
{
v___x_826_ = v___x_823_;
goto v_reusejp_825_;
}
else
{
lean_object* v_reuseFailAlloc_827_; 
v_reuseFailAlloc_827_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_827_, 0, v_a_821_);
v___x_826_ = v_reuseFailAlloc_827_;
goto v_reusejp_825_;
}
v_reusejp_825_:
{
return v___x_826_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__2___boxed(lean_object** _args){
lean_object* v___f_829_ = _args[0];
lean_object* v___x_830_ = _args[1];
lean_object* v___x_831_ = _args[2];
lean_object* v_a_832_ = _args[3];
lean_object* v_a_833_ = _args[4];
lean_object* v___x_834_ = _args[5];
lean_object* v___x_835_ = _args[6];
lean_object* v___x_836_ = _args[7];
lean_object* v___x_837_ = _args[8];
lean_object* v_tk_838_ = _args[9];
lean_object* v___y_839_ = _args[10];
lean_object* v___y_840_ = _args[11];
lean_object* v___y_841_ = _args[12];
lean_object* v___y_842_ = _args[13];
lean_object* v___y_843_ = _args[14];
lean_object* v___y_844_ = _args[15];
lean_object* v___y_845_ = _args[16];
lean_object* v___y_846_ = _args[17];
lean_object* v___y_847_ = _args[18];
_start:
{
uint8_t v___x_23705__boxed_848_; lean_object* v_res_849_; 
v___x_23705__boxed_848_ = lean_unbox(v___x_831_);
v_res_849_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__2(v___f_829_, v___x_830_, v___x_23705__boxed_848_, v_a_832_, v_a_833_, v___x_834_, v___x_835_, v___x_836_, v___x_837_, v_tk_838_, v___y_839_, v___y_840_, v___y_841_, v___y_842_, v___y_843_, v___y_844_, v___y_845_, v___y_846_);
lean_dec(v___y_846_);
lean_dec_ref(v___y_845_);
lean_dec(v___y_844_);
lean_dec_ref(v___y_843_);
lean_dec(v___y_842_);
lean_dec_ref(v___y_841_);
lean_dec(v___y_840_);
lean_dec_ref(v___y_839_);
return v_res_849_;
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck(lean_object* v_x_868_, lean_object* v_a_869_, lean_object* v_a_870_, lean_object* v_a_871_, lean_object* v_a_872_, lean_object* v_a_873_, lean_object* v_a_874_, lean_object* v_a_875_, lean_object* v_a_876_){
_start:
{
lean_object* v___x_878_; lean_object* v___x_879_; lean_object* v___x_880_; lean_object* v___x_881_; uint8_t v___x_882_; 
v___x_878_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__0));
v___x_879_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__1));
v___x_880_ = ((lean_object*)(l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg___lam__0___closed__1));
v___x_881_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3));
lean_inc(v_x_868_);
v___x_882_ = l_Lean_Syntax_isOfKind(v_x_868_, v___x_881_);
if (v___x_882_ == 0)
{
lean_object* v___x_883_; 
lean_dec(v_x_868_);
v___x_883_ = l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg();
return v___x_883_;
}
else
{
lean_object* v___x_884_; lean_object* v___x_885_; lean_object* v___x_886_; uint8_t v___x_887_; 
v___x_884_ = lean_unsigned_to_nat(1u);
v___x_885_ = l_Lean_Syntax_getArg(v_x_868_, v___x_884_);
v___x_886_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__5));
lean_inc(v___x_885_);
v___x_887_ = l_Lean_Syntax_isOfKind(v___x_885_, v___x_886_);
if (v___x_887_ == 0)
{
lean_object* v___x_888_; 
lean_dec(v___x_885_);
lean_dec(v_x_868_);
v___x_888_ = l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg();
return v___x_888_;
}
else
{
lean_object* v___x_889_; lean_object* v_path_890_; lean_object* v___x_891_; uint8_t v___x_892_; 
v___x_889_ = lean_unsigned_to_nat(2u);
v_path_890_ = l_Lean_Syntax_getArg(v_x_868_, v___x_889_);
v___x_891_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__7));
lean_inc(v_path_890_);
v___x_892_ = l_Lean_Syntax_isOfKind(v_path_890_, v___x_891_);
if (v___x_892_ == 0)
{
lean_object* v___x_893_; 
lean_dec(v_path_890_);
lean_dec(v___x_885_);
lean_dec(v_x_868_);
v___x_893_ = l_Lean_Elab_throwUnsupportedSyntax___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__0___redArg();
return v___x_893_;
}
else
{
lean_object* v___x_894_; uint8_t v___x_895_; lean_object* v___x_896_; uint8_t v___x_897_; lean_object* v___x_898_; lean_object* v___x_899_; 
v___x_894_ = lean_unsigned_to_nat(10u);
v___x_895_ = 0;
v___x_896_ = lean_unsigned_to_nat(100000u);
v___x_897_ = 0;
v___x_898_ = lean_alloc_ctor(0, 2, 11);
lean_ctor_set(v___x_898_, 0, v___x_894_);
lean_ctor_set(v___x_898_, 1, v___x_896_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2, v___x_892_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 1, v___x_892_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 2, v___x_895_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 3, v___x_892_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 4, v___x_892_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 5, v___x_892_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 6, v___x_892_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 7, v___x_892_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 8, v___x_895_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 9, v___x_895_);
lean_ctor_set_uint8(v___x_898_, sizeof(void*)*2 + 10, v___x_897_);
lean_inc(v___x_885_);
v___x_899_ = l_Lean_Meta_Tactic_BVDecide_elabBVDecideConfig___redArg(v___x_885_, v___x_898_, v___x_892_, v_a_869_, v_a_875_, v_a_876_);
if (lean_obj_tag(v___x_899_) == 0)
{
lean_object* v_a_900_; lean_object* v___x_901_; lean_object* v___x_902_; 
v_a_900_ = lean_ctor_get(v___x_899_, 0);
lean_inc_n(v_a_900_, 2);
lean_dec_ref_known(v___x_899_, 1);
v___x_901_ = l_Lean_TSyntax_getString(v_path_890_);
lean_dec(v_path_890_);
v___x_902_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_mkContext(v___x_901_, v_a_900_, v_a_871_, v_a_872_, v_a_873_, v_a_874_, v_a_875_, v_a_876_);
if (lean_obj_tag(v___x_902_) == 0)
{
lean_object* v_a_903_; lean_object* v___f_904_; lean_object* v___x_905_; lean_object* v_tk_906_; lean_object* v___x_907_; lean_object* v___f_908_; lean_object* v___x_909_; 
v_a_903_ = lean_ctor_get(v___x_902_, 0);
lean_inc(v_a_903_);
lean_dec_ref_known(v___x_902_, 1);
v___f_904_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__8));
v___x_905_ = lean_unsigned_to_nat(0u);
v_tk_906_ = l_Lean_Syntax_getArg(v_x_868_, v___x_905_);
lean_dec(v_x_868_);
v___x_907_ = lean_box(v___x_895_);
v___f_908_ = lean_alloc_closure((void*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___lam__2___boxed), 19, 10);
lean_closure_set(v___f_908_, 0, v___f_904_);
lean_closure_set(v___f_908_, 1, v___x_905_);
lean_closure_set(v___f_908_, 2, v___x_907_);
lean_closure_set(v___f_908_, 3, v_a_900_);
lean_closure_set(v___f_908_, 4, v_a_903_);
lean_closure_set(v___f_908_, 5, v___x_878_);
lean_closure_set(v___f_908_, 6, v___x_879_);
lean_closure_set(v___f_908_, 7, v___x_880_);
lean_closure_set(v___f_908_, 8, v___x_885_);
lean_closure_set(v___f_908_, 9, v_tk_906_);
v___x_909_ = l_Lean_Elab_Tactic_withMainContext___redArg(v___f_908_, v_a_869_, v_a_870_, v_a_871_, v_a_872_, v_a_873_, v_a_874_, v_a_875_, v_a_876_);
return v___x_909_;
}
else
{
lean_object* v_a_910_; lean_object* v___x_912_; uint8_t v_isShared_913_; uint8_t v_isSharedCheck_917_; 
lean_dec(v_a_900_);
lean_dec(v___x_885_);
lean_dec(v_x_868_);
v_a_910_ = lean_ctor_get(v___x_902_, 0);
v_isSharedCheck_917_ = !lean_is_exclusive(v___x_902_);
if (v_isSharedCheck_917_ == 0)
{
v___x_912_ = v___x_902_;
v_isShared_913_ = v_isSharedCheck_917_;
goto v_resetjp_911_;
}
else
{
lean_inc(v_a_910_);
lean_dec(v___x_902_);
v___x_912_ = lean_box(0);
v_isShared_913_ = v_isSharedCheck_917_;
goto v_resetjp_911_;
}
v_resetjp_911_:
{
lean_object* v___x_915_; 
if (v_isShared_913_ == 0)
{
v___x_915_ = v___x_912_;
goto v_reusejp_914_;
}
else
{
lean_object* v_reuseFailAlloc_916_; 
v_reuseFailAlloc_916_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_916_, 0, v_a_910_);
v___x_915_ = v_reuseFailAlloc_916_;
goto v_reusejp_914_;
}
v_reusejp_914_:
{
return v___x_915_;
}
}
}
}
else
{
lean_object* v_a_918_; lean_object* v___x_920_; uint8_t v_isShared_921_; uint8_t v_isSharedCheck_925_; 
lean_dec(v_path_890_);
lean_dec(v___x_885_);
lean_dec(v_x_868_);
v_a_918_ = lean_ctor_get(v___x_899_, 0);
v_isSharedCheck_925_ = !lean_is_exclusive(v___x_899_);
if (v_isSharedCheck_925_ == 0)
{
v___x_920_ = v___x_899_;
v_isShared_921_ = v_isSharedCheck_925_;
goto v_resetjp_919_;
}
else
{
lean_inc(v_a_918_);
lean_dec(v___x_899_);
v___x_920_ = lean_box(0);
v_isShared_921_ = v_isSharedCheck_925_;
goto v_resetjp_919_;
}
v_resetjp_919_:
{
lean_object* v___x_923_; 
if (v_isShared_921_ == 0)
{
v___x_923_ = v___x_920_;
goto v_reusejp_922_;
}
else
{
lean_object* v_reuseFailAlloc_924_; 
v_reuseFailAlloc_924_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_924_, 0, v_a_918_);
v___x_923_ = v_reuseFailAlloc_924_;
goto v_reusejp_922_;
}
v_reusejp_922_:
{
return v___x_923_;
}
}
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___boxed(lean_object* v_x_926_, lean_object* v_a_927_, lean_object* v_a_928_, lean_object* v_a_929_, lean_object* v_a_930_, lean_object* v_a_931_, lean_object* v_a_932_, lean_object* v_a_933_, lean_object* v_a_934_, lean_object* v_a_935_){
_start:
{
lean_object* v_res_936_; 
v_res_936_ = l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck(v_x_926_, v_a_927_, v_a_928_, v_a_929_, v_a_930_, v_a_931_, v_a_932_, v_a_933_, v_a_934_);
lean_dec(v_a_934_);
lean_dec_ref(v_a_933_);
lean_dec(v_a_932_);
lean_dec_ref(v_a_931_);
lean_dec(v_a_930_);
lean_dec_ref(v_a_929_);
lean_dec(v_a_928_);
lean_dec_ref(v_a_927_);
return v_res_936_;
}
}
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3(lean_object* v_ref_937_, lean_object* v_msgData_938_, uint8_t v_severity_939_, uint8_t v_isSilent_940_, lean_object* v___y_941_, lean_object* v___y_942_, lean_object* v___y_943_, lean_object* v___y_944_, lean_object* v___y_945_, lean_object* v___y_946_, lean_object* v___y_947_, lean_object* v___y_948_){
_start:
{
lean_object* v___x_950_; 
v___x_950_ = l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___redArg(v_ref_937_, v_msgData_938_, v_severity_939_, v_isSilent_940_, v___y_945_, v___y_946_, v___y_947_, v___y_948_);
return v___x_950_;
}
}
LEAN_EXPORT lean_object* l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3___boxed(lean_object* v_ref_951_, lean_object* v_msgData_952_, lean_object* v_severity_953_, lean_object* v_isSilent_954_, lean_object* v___y_955_, lean_object* v___y_956_, lean_object* v___y_957_, lean_object* v___y_958_, lean_object* v___y_959_, lean_object* v___y_960_, lean_object* v___y_961_, lean_object* v___y_962_, lean_object* v___y_963_){
_start:
{
uint8_t v_severity_boxed_964_; uint8_t v_isSilent_boxed_965_; lean_object* v_res_966_; 
v_severity_boxed_964_ = lean_unbox(v_severity_953_);
v_isSilent_boxed_965_ = lean_unbox(v_isSilent_954_);
v_res_966_ = l_Lean_logAt___at___00Lean_log___at___00Lean_logWarning___at___00Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck_spec__2_spec__2_spec__3(v_ref_951_, v_msgData_952_, v_severity_boxed_964_, v_isSilent_boxed_965_, v___y_955_, v___y_956_, v___y_957_, v___y_958_, v___y_959_, v___y_960_, v___y_961_, v___y_962_);
lean_dec(v___y_962_);
lean_dec_ref(v___y_961_);
lean_dec(v___y_960_);
lean_dec_ref(v___y_959_);
lean_dec(v___y_958_);
lean_dec_ref(v___y_957_);
lean_dec(v___y_956_);
lean_dec_ref(v___y_955_);
lean_dec(v_ref_951_);
return v_res_966_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1(){
_start:
{
lean_object* v___x_978_; lean_object* v___x_979_; lean_object* v___x_980_; lean_object* v___x_981_; lean_object* v___x_982_; 
v___x_978_ = l_Lean_Elab_Tactic_tacticElabAttribute;
v___x_979_ = ((lean_object*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___closed__3));
v___x_980_ = ((lean_object*)(l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___closed__3));
v___x_981_ = lean_alloc_closure((void*)(l_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___boxed), 10, 0);
v___x_982_ = l_Lean_KeyedDeclsAttribute_addBuiltin___redArg(v___x_978_, v___x_979_, v___x_980_, v___x_981_);
return v___x_982_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1___boxed(lean_object* v_a_983_){
_start:
{
lean_object* v_res_984_; 
v_res_984_ = l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1();
return v_res_984_;
}
}
lean_object* runtime_initialize_Lean_Elab_Tactic_BVDecide_BVDecide(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_TryThis(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_TacticContext(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Sym_Util(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Elab_Tactic_BVDecide_BVCheck(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Lean_Elab_Tactic_BVDecide_BVDecide(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_TryThis(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_TacticContext(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Normalize(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Sym_Util(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = l___private_Lean_Elab_Tactic_BVDecide_BVCheck_0__Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck___regBuiltin_Lean_Elab_Tactic_BVDecide_BVCheck_evalBvCheck__1();
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Elab_Tactic_BVDecide_BVCheck(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Lean_Elab_Tactic_BVDecide_BVDecide(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_TryThis(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_BVDecide_TacticContext(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Normalize(uint8_t builtin);
lean_object* initialize_Lean_Meta_Sym_Util(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Elab_Tactic_BVDecide_BVCheck(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Lean_Elab_Tactic_BVDecide_BVDecide(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_TryThis(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_BVDecide_TacticContext(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_BVDecide_Normalize(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Sym_Util(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Elab_Tactic_BVDecide_BVCheck(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Elab_Tactic_BVDecide_BVCheck(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Elab_Tactic_BVDecide_BVCheck(builtin);
}
#ifdef __cplusplus
}
#endif
