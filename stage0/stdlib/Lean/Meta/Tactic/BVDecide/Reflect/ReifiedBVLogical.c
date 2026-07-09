// Lean compiler output
// Module: Lean.Meta.Tactic.BVDecide.Reflect.ReifiedBVLogical
// Imports: public import Lean.Meta.Tactic.BVDecide.Reflect.Basic import Lean.Meta.Tactic.BVDecide.Reflect.ReifiedBVPred import Std.Tactic.BVDecide.Reflect
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
lean_object* l_Lean_Name_mkStr5(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkConst(lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr2(lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_M_atomsAssignment(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkAppB(lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Sym_shareCommonInc(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Level_ofNat(lean_object*);
lean_object* l_Lean_Name_mkStr1(lean_object*);
lean_object* l_Lean_mkApp6(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Name_mkStr4(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkApp4(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVPred_evalsAtAtoms___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVPred_boolAtom(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkApp3(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Lean_mkApp9(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "Eq"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "refl"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__0_value),LEAN_SCALAR_PTR_LITERAL(143, 37, 101, 248, 9, 246, 191, 223)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__2_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__1_value),LEAN_SCALAR_PTR_LITERAL(72, 6, 107, 181, 0, 125, 21, 187)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__2_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__3;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__4_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__4;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__5_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__5;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Bool"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6_value),LEAN_SCALAR_PTR_LITERAL(250, 44, 198, 216, 184, 195, 199, 178)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__7 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__7_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__8_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__8;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl(lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "trans"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__0_value),LEAN_SCALAR_PTR_LITERAL(143, 37, 101, 248, 9, 246, 191, 223)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__0_value),LEAN_SCALAR_PTR_LITERAL(157, 40, 198, 234, 16, 168, 79, 243)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__2;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "Std"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "Tactic"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "BVDecide"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 14, .m_capacity = 14, .m_length = 13, .m_data = "BVLogicalExpr"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__3_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "eval"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__4_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__3_value),LEAN_SCALAR_PTR_LITERAL(170, 137, 185, 0, 130, 201, 136, 210)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__4_value),LEAN_SCALAR_PTR_LITERAL(81, 172, 123, 74, 237, 247, 157, 191)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__6;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "BoolExpr"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__0_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "literal"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__1_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__1_value),LEAN_SCALAR_PTR_LITERAL(124, 170, 215, 35, 43, 27, 202, 11)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__3_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__3;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 7, .m_capacity = 7, .m_length = 6, .m_data = "BVPred"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__4_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__4_value),LEAN_SCALAR_PTR_LITERAL(12, 253, 4, 25, 159, 236, 140, 252)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_boolAtom(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_boolAtom___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "const"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(244, 184, 12, 163, 38, 128, 83, 107)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__2;
static const lean_closure_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_closure_object) + sizeof(void*)*1, .m_other = 0, .m_tag = 245}, .m_fun = (void*)l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___lam__0___boxed, .m_arity = 10, .m_num_fixed = 1, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1))} };
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__3_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 6, .m_capacity = 6, .m_length = 5, .m_data = "false"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__4_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__5_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6_value),LEAN_SCALAR_PTR_LITERAL(250, 44, 198, 216, 184, 195, 199, 178)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__5_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__4_value),LEAN_SCALAR_PTR_LITERAL(117, 151, 161, 190, 111, 237, 188, 218)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__5_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__6;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "true"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__7 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__7_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__8_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6_value),LEAN_SCALAR_PTR_LITERAL(250, 44, 198, 216, 184, 195, 199, 178)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__8_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__7_value),LEAN_SCALAR_PTR_LITERAL(22, 245, 194, 28, 184, 9, 113, 128)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__8_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__9;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg(uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst(uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 8, .m_capacity = 8, .m_length = 7, .m_data = "Reflect"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__0 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__0_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "and_congr"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__1 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__1_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_2),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__0_value),LEAN_SCALAR_PTR_LITERAL(32, 92, 17, 213, 68, 211, 219, 250)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_4 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6_value),LEAN_SCALAR_PTR_LITERAL(61, 74, 55, 212, 47, 213, 221, 101)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value_aux_4),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__1_value),LEAN_SCALAR_PTR_LITERAL(18, 149, 13, 143, 231, 41, 150, 146)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "xor_congr"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__3 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__3_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_2),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__0_value),LEAN_SCALAR_PTR_LITERAL(32, 92, 17, 213, 68, 211, 219, 250)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_4 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6_value),LEAN_SCALAR_PTR_LITERAL(61, 74, 55, 212, 47, 213, 221, 101)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value_aux_4),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__3_value),LEAN_SCALAR_PTR_LITERAL(143, 142, 245, 112, 164, 111, 120, 143)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "beq_congr"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__5 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__5_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_2),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__0_value),LEAN_SCALAR_PTR_LITERAL(32, 92, 17, 213, 68, 211, 219, 250)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_4 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6_value),LEAN_SCALAR_PTR_LITERAL(61, 74, 55, 212, 47, 213, 221, 101)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value_aux_4),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__5_value),LEAN_SCALAR_PTR_LITERAL(101, 115, 64, 1, 88, 223, 29, 42)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6_value;
static const lean_string_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 9, .m_capacity = 9, .m_length = 8, .m_data = "or_congr"};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__7 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__7_value;
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_2),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__0_value),LEAN_SCALAR_PTR_LITERAL(32, 92, 17, 213, 68, 211, 219, 250)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_4 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6_value),LEAN_SCALAR_PTR_LITERAL(61, 74, 55, 212, 47, 213, 221, 101)}};
static const lean_ctor_object l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value_aux_4),((lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__7_value),LEAN_SCALAR_PTR_LITERAL(183, 116, 6, 33, 14, 220, 127, 98)}};
static const lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8 = (const lean_object*)&l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8_value;
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate(uint8_t);
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___boxed(lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_spec__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___lam__0___boxed(lean_object**);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "gate"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(65, 48, 52, 229, 233, 139, 247, 222)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__2;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__3_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 5, .m_capacity = 5, .m_length = 4, .m_data = "Gate"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__3 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__3_value;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__4_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "and"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__4 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__4_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__3_value),LEAN_SCALAR_PTR_LITERAL(217, 25, 243, 65, 109, 17, 59, 185)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__4_value),LEAN_SCALAR_PTR_LITERAL(191, 125, 195, 121, 220, 103, 239, 120)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__6_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__6;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__7_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "xor"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__7 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__7_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__3_value),LEAN_SCALAR_PTR_LITERAL(217, 25, 243, 65, 109, 17, 59, 185)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__7_value),LEAN_SCALAR_PTR_LITERAL(64, 67, 164, 147, 7, 85, 189, 57)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__9_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__9;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__10_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "beq"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__10 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__10_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__3_value),LEAN_SCALAR_PTR_LITERAL(217, 25, 243, 65, 109, 17, 59, 185)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__10_value),LEAN_SCALAR_PTR_LITERAL(208, 118, 173, 79, 191, 184, 148, 203)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__12_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__12;
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__13_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 3, .m_capacity = 3, .m_length = 2, .m_data = "or"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__13 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__13_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__3_value),LEAN_SCALAR_PTR_LITERAL(217, 25, 243, 65, 109, 17, 59, 185)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__13_value),LEAN_SCALAR_PTR_LITERAL(37, 170, 13, 59, 155, 6, 165, 62)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__15_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__15;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg(lean_object*, lean_object*, lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate(lean_object*, lean_object*, lean_object*, lean_object*, uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 10, .m_capacity = 10, .m_length = 9, .m_data = "not_congr"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "not"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(244, 134, 245, 64, 53, 182, 217, 215)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__2;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyTernaryProof___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte_spec__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 11, .m_capacity = 11, .m_length = 10, .m_data = "cond_congr"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0___closed__0_value;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0___boxed(lean_object**);
static const lean_string_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__0_value = {.m_header = {.m_rc = 0, .m_cs_sz = 0, .m_other = 0, .m_tag = 249}, .m_size = 4, .m_capacity = 4, .m_length = 3, .m_data = "ite"};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__0 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__0_value;
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value_aux_0 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)(((size_t)(0) << 1) | 1)),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0_value),LEAN_SCALAR_PTR_LITERAL(48, 144, 193, 124, 159, 137, 91, 218)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value_aux_1 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value_aux_0),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1_value),LEAN_SCALAR_PTR_LITERAL(77, 161, 28, 104, 237, 118, 82, 71)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value_aux_2 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value_aux_1),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2_value),LEAN_SCALAR_PTR_LITERAL(160, 152, 89, 246, 197, 180, 246, 240)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value_aux_3 = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value_aux_2),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(78, 254, 9, 142, 35, 136, 25, 70)}};
static const lean_ctor_object l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value = {.m_header = {.m_rc = 0, .m_cs_sz = sizeof(lean_ctor_object) + sizeof(void*)*2 + 8, .m_other = 2, .m_tag = 1}, .m_objs = {((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value_aux_3),((lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__0_value),LEAN_SCALAR_PTR_LITERAL(222, 47, 143, 42, 137, 9, 112, 75)}};
static const lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1 = (const lean_object*)&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1_value;
static lean_once_cell_t l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__2_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__2;
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__3(void){
_start:
{
lean_object* v___x_6_; lean_object* v___x_7_; 
v___x_6_ = lean_unsigned_to_nat(1u);
v___x_7_ = l_Lean_Level_ofNat(v___x_6_);
return v___x_7_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__4(void){
_start:
{
lean_object* v___x_8_; lean_object* v___x_9_; lean_object* v___x_10_; 
v___x_8_ = lean_box(0);
v___x_9_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__3, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__3);
v___x_10_ = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(v___x_10_, 0, v___x_9_);
lean_ctor_set(v___x_10_, 1, v___x_8_);
return v___x_10_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__5(void){
_start:
{
lean_object* v___x_11_; lean_object* v___x_12_; lean_object* v___x_13_; 
v___x_11_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__4, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__4_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__4);
v___x_12_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__2));
v___x_13_ = l_Lean_mkConst(v___x_12_, v___x_11_);
return v___x_13_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__8(void){
_start:
{
lean_object* v___x_17_; lean_object* v___x_18_; lean_object* v___x_19_; 
v___x_17_ = lean_box(0);
v___x_18_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__7));
v___x_19_ = l_Lean_mkConst(v___x_18_, v___x_17_);
return v___x_19_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl(lean_object* v_expr_20_){
_start:
{
lean_object* v___x_21_; lean_object* v___x_22_; lean_object* v___x_23_; 
v___x_21_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__5, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__5_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__5);
v___x_22_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__8, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__8_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__8);
v___x_23_ = l_Lean_mkAppB(v___x_21_, v___x_22_, v_expr_20_);
return v___x_23_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__2(void){
_start:
{
lean_object* v___x_28_; lean_object* v___x_29_; lean_object* v___x_30_; 
v___x_28_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__4, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__4_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__4);
v___x_29_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__1));
v___x_30_ = l_Lean_mkConst(v___x_29_, v___x_28_);
return v___x_30_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans(lean_object* v_x_31_, lean_object* v_y_32_, lean_object* v_z_33_, lean_object* v_hxy_34_, lean_object* v_hyz_35_){
_start:
{
lean_object* v___x_36_; lean_object* v___x_37_; lean_object* v___x_38_; 
v___x_36_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__2, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkTrans___closed__2);
v___x_37_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__8, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__8_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__8);
v___x_38_ = l_Lean_mkApp6(v___x_36_, v___x_37_, v_x_31_, v_y_32_, v_z_33_, v_hxy_34_, v_hyz_35_);
return v___x_38_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__6(void){
_start:
{
lean_object* v___x_50_; lean_object* v___x_51_; lean_object* v___x_52_; 
v___x_50_ = lean_box(0);
v___x_51_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__5));
v___x_52_ = l_Lean_mkConst(v___x_51_, v___x_50_);
return v___x_52_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr(lean_object* v_expr_53_, lean_object* v_a_54_, lean_object* v_a_55_, lean_object* v_a_56_, lean_object* v_a_57_, lean_object* v_a_58_, lean_object* v_a_59_, lean_object* v_a_60_, lean_object* v_a_61_){
_start:
{
lean_object* v___x_63_; 
v___x_63_ = l_Lean_Meta_Tactic_BVDecide_M_atomsAssignment(v_a_54_, v_a_55_, v_a_56_, v_a_57_, v_a_58_, v_a_59_, v_a_60_, v_a_61_);
if (lean_obj_tag(v___x_63_) == 0)
{
lean_object* v_a_64_; lean_object* v___x_65_; lean_object* v___x_66_; lean_object* v___x_67_; 
v_a_64_ = lean_ctor_get(v___x_63_, 0);
lean_inc(v_a_64_);
lean_dec_ref_known(v___x_63_, 1);
v___x_65_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__6, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__6);
v___x_66_ = l_Lean_mkAppB(v___x_65_, v_a_64_, v_expr_53_);
v___x_67_ = l_Lean_Meta_Sym_shareCommonInc(v___x_66_, v_a_56_, v_a_57_, v_a_58_, v_a_59_, v_a_60_, v_a_61_);
return v___x_67_;
}
else
{
lean_dec_ref(v_expr_53_);
return v___x_63_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___boxed(lean_object* v_expr_68_, lean_object* v_a_69_, lean_object* v_a_70_, lean_object* v_a_71_, lean_object* v_a_72_, lean_object* v_a_73_, lean_object* v_a_74_, lean_object* v_a_75_, lean_object* v_a_76_, lean_object* v_a_77_){
_start:
{
lean_object* v_res_78_; 
v_res_78_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr(v_expr_68_, v_a_69_, v_a_70_, v_a_71_, v_a_72_, v_a_73_, v_a_74_, v_a_75_, v_a_76_);
lean_dec(v_a_76_);
lean_dec_ref(v_a_75_);
lean_dec(v_a_74_);
lean_dec_ref(v_a_73_);
lean_dec(v_a_72_);
lean_dec_ref(v_a_71_);
lean_dec(v_a_70_);
lean_dec_ref(v_a_69_);
return v_res_78_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__3(void){
_start:
{
lean_object* v___x_87_; lean_object* v___x_88_; lean_object* v___x_89_; 
v___x_87_ = lean_box(0);
v___x_88_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__2));
v___x_89_ = l_Lean_mkConst(v___x_88_, v___x_87_);
return v___x_89_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6(void){
_start:
{
lean_object* v___x_96_; lean_object* v___x_97_; lean_object* v___x_98_; 
v___x_96_ = lean_box(0);
v___x_97_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__5));
v___x_98_ = l_Lean_mkConst(v___x_97_, v___x_96_);
return v___x_98_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg(lean_object* v_bvPred_99_, lean_object* v_a_100_, lean_object* v_a_101_, lean_object* v_a_102_, lean_object* v_a_103_, lean_object* v_a_104_, lean_object* v_a_105_){
_start:
{
lean_object* v_bvPred_107_; lean_object* v_originalExpr_108_; lean_object* v_expr_109_; lean_object* v___x_110_; lean_object* v___x_111_; lean_object* v___x_112_; lean_object* v___x_113_; 
v_bvPred_107_ = lean_ctor_get(v_bvPred_99_, 0);
v_originalExpr_108_ = lean_ctor_get(v_bvPred_99_, 1);
lean_inc_ref(v_originalExpr_108_);
v_expr_109_ = lean_ctor_get(v_bvPred_99_, 3);
v___x_110_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__3, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__3_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__3);
v___x_111_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6);
lean_inc_ref(v_expr_109_);
v___x_112_ = l_Lean_mkAppB(v___x_110_, v___x_111_, v_expr_109_);
v___x_113_ = l_Lean_Meta_Sym_shareCommonInc(v___x_112_, v_a_100_, v_a_101_, v_a_102_, v_a_103_, v_a_104_, v_a_105_);
if (lean_obj_tag(v___x_113_) == 0)
{
lean_object* v_a_114_; lean_object* v___x_116_; uint8_t v_isShared_117_; uint8_t v_isSharedCheck_124_; 
v_a_114_ = lean_ctor_get(v___x_113_, 0);
v_isSharedCheck_124_ = !lean_is_exclusive(v___x_113_);
if (v_isSharedCheck_124_ == 0)
{
v___x_116_ = v___x_113_;
v_isShared_117_ = v_isSharedCheck_124_;
goto v_resetjp_115_;
}
else
{
lean_inc(v_a_114_);
lean_dec(v___x_113_);
v___x_116_ = lean_box(0);
v_isShared_117_ = v_isSharedCheck_124_;
goto v_resetjp_115_;
}
v_resetjp_115_:
{
lean_object* v_boolExpr_118_; lean_object* v___x_119_; lean_object* v___x_120_; lean_object* v___x_122_; 
lean_inc_ref(v_bvPred_107_);
v_boolExpr_118_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_boolExpr_118_, 0, v_bvPred_107_);
v___x_119_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVPred_evalsAtAtoms___boxed), 10, 1);
lean_closure_set(v___x_119_, 0, v_bvPred_99_);
v___x_120_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_120_, 0, v_boolExpr_118_);
lean_ctor_set(v___x_120_, 1, v_originalExpr_108_);
lean_ctor_set(v___x_120_, 2, v___x_119_);
lean_ctor_set(v___x_120_, 3, v_a_114_);
if (v_isShared_117_ == 0)
{
lean_ctor_set(v___x_116_, 0, v___x_120_);
v___x_122_ = v___x_116_;
goto v_reusejp_121_;
}
else
{
lean_object* v_reuseFailAlloc_123_; 
v_reuseFailAlloc_123_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_123_, 0, v___x_120_);
v___x_122_ = v_reuseFailAlloc_123_;
goto v_reusejp_121_;
}
v_reusejp_121_:
{
return v___x_122_;
}
}
}
else
{
lean_object* v_a_125_; lean_object* v___x_127_; uint8_t v_isShared_128_; uint8_t v_isSharedCheck_132_; 
lean_dec_ref(v_originalExpr_108_);
lean_dec_ref(v_bvPred_99_);
v_a_125_ = lean_ctor_get(v___x_113_, 0);
v_isSharedCheck_132_ = !lean_is_exclusive(v___x_113_);
if (v_isSharedCheck_132_ == 0)
{
v___x_127_ = v___x_113_;
v_isShared_128_ = v_isSharedCheck_132_;
goto v_resetjp_126_;
}
else
{
lean_inc(v_a_125_);
lean_dec(v___x_113_);
v___x_127_ = lean_box(0);
v_isShared_128_ = v_isSharedCheck_132_;
goto v_resetjp_126_;
}
v_resetjp_126_:
{
lean_object* v___x_130_; 
if (v_isShared_128_ == 0)
{
v___x_130_ = v___x_127_;
goto v_reusejp_129_;
}
else
{
lean_object* v_reuseFailAlloc_131_; 
v_reuseFailAlloc_131_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_131_, 0, v_a_125_);
v___x_130_ = v_reuseFailAlloc_131_;
goto v_reusejp_129_;
}
v_reusejp_129_:
{
return v___x_130_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___boxed(lean_object* v_bvPred_133_, lean_object* v_a_134_, lean_object* v_a_135_, lean_object* v_a_136_, lean_object* v_a_137_, lean_object* v_a_138_, lean_object* v_a_139_, lean_object* v_a_140_){
_start:
{
lean_object* v_res_141_; 
v_res_141_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg(v_bvPred_133_, v_a_134_, v_a_135_, v_a_136_, v_a_137_, v_a_138_, v_a_139_);
lean_dec(v_a_139_);
lean_dec_ref(v_a_138_);
lean_dec(v_a_137_);
lean_dec_ref(v_a_136_);
lean_dec(v_a_135_);
lean_dec_ref(v_a_134_);
return v_res_141_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred(lean_object* v_bvPred_142_, lean_object* v_a_143_, lean_object* v_a_144_, lean_object* v_a_145_, lean_object* v_a_146_, lean_object* v_a_147_, lean_object* v_a_148_, lean_object* v_a_149_, lean_object* v_a_150_){
_start:
{
lean_object* v___x_152_; 
v___x_152_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg(v_bvPred_142_, v_a_145_, v_a_146_, v_a_147_, v_a_148_, v_a_149_, v_a_150_);
return v___x_152_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___boxed(lean_object* v_bvPred_153_, lean_object* v_a_154_, lean_object* v_a_155_, lean_object* v_a_156_, lean_object* v_a_157_, lean_object* v_a_158_, lean_object* v_a_159_, lean_object* v_a_160_, lean_object* v_a_161_, lean_object* v_a_162_){
_start:
{
lean_object* v_res_163_; 
v_res_163_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred(v_bvPred_153_, v_a_154_, v_a_155_, v_a_156_, v_a_157_, v_a_158_, v_a_159_, v_a_160_, v_a_161_);
lean_dec(v_a_161_);
lean_dec_ref(v_a_160_);
lean_dec(v_a_159_);
lean_dec_ref(v_a_158_);
lean_dec(v_a_157_);
lean_dec_ref(v_a_156_);
lean_dec(v_a_155_);
lean_dec_ref(v_a_154_);
return v_res_163_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_boolAtom(lean_object* v_t_164_, lean_object* v_a_165_, lean_object* v_a_166_, lean_object* v_a_167_, lean_object* v_a_168_, lean_object* v_a_169_, lean_object* v_a_170_, lean_object* v_a_171_, lean_object* v_a_172_){
_start:
{
lean_object* v___x_174_; 
v___x_174_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVPred_boolAtom(v_t_164_, v_a_165_, v_a_166_, v_a_167_, v_a_168_, v_a_169_, v_a_170_, v_a_171_, v_a_172_);
if (lean_obj_tag(v___x_174_) == 0)
{
lean_object* v_a_175_; lean_object* v___x_177_; uint8_t v_isShared_178_; uint8_t v_isSharedCheck_208_; 
v_a_175_ = lean_ctor_get(v___x_174_, 0);
v_isSharedCheck_208_ = !lean_is_exclusive(v___x_174_);
if (v_isSharedCheck_208_ == 0)
{
v___x_177_ = v___x_174_;
v_isShared_178_ = v_isSharedCheck_208_;
goto v_resetjp_176_;
}
else
{
lean_inc(v_a_175_);
lean_dec(v___x_174_);
v___x_177_ = lean_box(0);
v_isShared_178_ = v_isSharedCheck_208_;
goto v_resetjp_176_;
}
v_resetjp_176_:
{
if (lean_obj_tag(v_a_175_) == 1)
{
lean_object* v_val_179_; lean_object* v___x_181_; uint8_t v_isShared_182_; uint8_t v_isSharedCheck_203_; 
lean_del_object(v___x_177_);
v_val_179_ = lean_ctor_get(v_a_175_, 0);
v_isSharedCheck_203_ = !lean_is_exclusive(v_a_175_);
if (v_isSharedCheck_203_ == 0)
{
v___x_181_ = v_a_175_;
v_isShared_182_ = v_isSharedCheck_203_;
goto v_resetjp_180_;
}
else
{
lean_inc(v_val_179_);
lean_dec(v_a_175_);
v___x_181_ = lean_box(0);
v_isShared_182_ = v_isSharedCheck_203_;
goto v_resetjp_180_;
}
v_resetjp_180_:
{
lean_object* v___x_183_; 
v___x_183_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg(v_val_179_, v_a_167_, v_a_168_, v_a_169_, v_a_170_, v_a_171_, v_a_172_);
if (lean_obj_tag(v___x_183_) == 0)
{
lean_object* v_a_184_; lean_object* v___x_186_; uint8_t v_isShared_187_; uint8_t v_isSharedCheck_194_; 
v_a_184_ = lean_ctor_get(v___x_183_, 0);
v_isSharedCheck_194_ = !lean_is_exclusive(v___x_183_);
if (v_isSharedCheck_194_ == 0)
{
v___x_186_ = v___x_183_;
v_isShared_187_ = v_isSharedCheck_194_;
goto v_resetjp_185_;
}
else
{
lean_inc(v_a_184_);
lean_dec(v___x_183_);
v___x_186_ = lean_box(0);
v_isShared_187_ = v_isSharedCheck_194_;
goto v_resetjp_185_;
}
v_resetjp_185_:
{
lean_object* v___x_189_; 
if (v_isShared_182_ == 0)
{
lean_ctor_set(v___x_181_, 0, v_a_184_);
v___x_189_ = v___x_181_;
goto v_reusejp_188_;
}
else
{
lean_object* v_reuseFailAlloc_193_; 
v_reuseFailAlloc_193_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_193_, 0, v_a_184_);
v___x_189_ = v_reuseFailAlloc_193_;
goto v_reusejp_188_;
}
v_reusejp_188_:
{
lean_object* v___x_191_; 
if (v_isShared_187_ == 0)
{
lean_ctor_set(v___x_186_, 0, v___x_189_);
v___x_191_ = v___x_186_;
goto v_reusejp_190_;
}
else
{
lean_object* v_reuseFailAlloc_192_; 
v_reuseFailAlloc_192_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_192_, 0, v___x_189_);
v___x_191_ = v_reuseFailAlloc_192_;
goto v_reusejp_190_;
}
v_reusejp_190_:
{
return v___x_191_;
}
}
}
}
else
{
lean_object* v_a_195_; lean_object* v___x_197_; uint8_t v_isShared_198_; uint8_t v_isSharedCheck_202_; 
lean_del_object(v___x_181_);
v_a_195_ = lean_ctor_get(v___x_183_, 0);
v_isSharedCheck_202_ = !lean_is_exclusive(v___x_183_);
if (v_isSharedCheck_202_ == 0)
{
v___x_197_ = v___x_183_;
v_isShared_198_ = v_isSharedCheck_202_;
goto v_resetjp_196_;
}
else
{
lean_inc(v_a_195_);
lean_dec(v___x_183_);
v___x_197_ = lean_box(0);
v_isShared_198_ = v_isSharedCheck_202_;
goto v_resetjp_196_;
}
v_resetjp_196_:
{
lean_object* v___x_200_; 
if (v_isShared_198_ == 0)
{
v___x_200_ = v___x_197_;
goto v_reusejp_199_;
}
else
{
lean_object* v_reuseFailAlloc_201_; 
v_reuseFailAlloc_201_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_201_, 0, v_a_195_);
v___x_200_ = v_reuseFailAlloc_201_;
goto v_reusejp_199_;
}
v_reusejp_199_:
{
return v___x_200_;
}
}
}
}
}
else
{
lean_object* v___x_204_; lean_object* v___x_206_; 
lean_dec(v_a_175_);
v___x_204_ = lean_box(0);
if (v_isShared_178_ == 0)
{
lean_ctor_set(v___x_177_, 0, v___x_204_);
v___x_206_ = v___x_177_;
goto v_reusejp_205_;
}
else
{
lean_object* v_reuseFailAlloc_207_; 
v_reuseFailAlloc_207_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_207_, 0, v___x_204_);
v___x_206_ = v_reuseFailAlloc_207_;
goto v_reusejp_205_;
}
v_reusejp_205_:
{
return v___x_206_;
}
}
}
}
else
{
lean_object* v_a_209_; lean_object* v___x_211_; uint8_t v_isShared_212_; uint8_t v_isSharedCheck_216_; 
v_a_209_ = lean_ctor_get(v___x_174_, 0);
v_isSharedCheck_216_ = !lean_is_exclusive(v___x_174_);
if (v_isSharedCheck_216_ == 0)
{
v___x_211_ = v___x_174_;
v_isShared_212_ = v_isSharedCheck_216_;
goto v_resetjp_210_;
}
else
{
lean_inc(v_a_209_);
lean_dec(v___x_174_);
v___x_211_ = lean_box(0);
v_isShared_212_ = v_isSharedCheck_216_;
goto v_resetjp_210_;
}
v_resetjp_210_:
{
lean_object* v___x_214_; 
if (v_isShared_212_ == 0)
{
v___x_214_ = v___x_211_;
goto v_reusejp_213_;
}
else
{
lean_object* v_reuseFailAlloc_215_; 
v_reuseFailAlloc_215_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_215_, 0, v_a_209_);
v___x_214_ = v_reuseFailAlloc_215_;
goto v_reusejp_213_;
}
v_reusejp_213_:
{
return v___x_214_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_boolAtom___boxed(lean_object* v_t_217_, lean_object* v_a_218_, lean_object* v_a_219_, lean_object* v_a_220_, lean_object* v_a_221_, lean_object* v_a_222_, lean_object* v_a_223_, lean_object* v_a_224_, lean_object* v_a_225_, lean_object* v_a_226_){
_start:
{
lean_object* v_res_227_; 
v_res_227_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_boolAtom(v_t_217_, v_a_218_, v_a_219_, v_a_220_, v_a_221_, v_a_222_, v_a_223_, v_a_224_, v_a_225_);
lean_dec(v_a_225_);
lean_dec_ref(v_a_224_);
lean_dec(v_a_223_);
lean_dec_ref(v_a_222_);
lean_dec(v_a_221_);
lean_dec_ref(v_a_220_);
lean_dec(v_a_219_);
lean_dec_ref(v_a_218_);
return v_res_227_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___lam__0(lean_object* v___x_228_, lean_object* v___y_229_, lean_object* v___y_230_, lean_object* v___y_231_, lean_object* v___y_232_, lean_object* v___y_233_, lean_object* v___y_234_, lean_object* v___y_235_, lean_object* v___y_236_){
_start:
{
lean_object* v___x_238_; 
v___x_238_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v___x_238_, 0, v___x_228_);
return v___x_238_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___lam__0___boxed(lean_object* v___x_239_, lean_object* v___y_240_, lean_object* v___y_241_, lean_object* v___y_242_, lean_object* v___y_243_, lean_object* v___y_244_, lean_object* v___y_245_, lean_object* v___y_246_, lean_object* v___y_247_, lean_object* v___y_248_){
_start:
{
lean_object* v_res_249_; 
v_res_249_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___lam__0(v___x_239_, v___y_240_, v___y_241_, v___y_242_, v___y_243_, v___y_244_, v___y_245_, v___y_246_, v___y_247_);
lean_dec(v___y_247_);
lean_dec_ref(v___y_246_);
lean_dec(v___y_245_);
lean_dec_ref(v___y_244_);
lean_dec(v___y_243_);
lean_dec_ref(v___y_242_);
lean_dec(v___y_241_);
lean_dec_ref(v___y_240_);
return v_res_249_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__2(void){
_start:
{
lean_object* v___x_257_; lean_object* v___x_258_; lean_object* v___x_259_; 
v___x_257_ = lean_box(0);
v___x_258_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__1));
v___x_259_ = l_Lean_mkConst(v___x_258_, v___x_257_);
return v___x_259_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__6(void){
_start:
{
lean_object* v___x_266_; lean_object* v___x_267_; lean_object* v___x_268_; 
v___x_266_ = lean_box(0);
v___x_267_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__5));
v___x_268_ = l_Lean_mkConst(v___x_267_, v___x_266_);
return v___x_268_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__9(void){
_start:
{
lean_object* v___x_273_; lean_object* v___x_274_; lean_object* v___x_275_; 
v___x_273_ = lean_box(0);
v___x_274_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__8));
v___x_275_ = l_Lean_mkConst(v___x_274_, v___x_273_);
return v___x_275_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg(uint8_t v_val_276_, lean_object* v_a_277_, lean_object* v_a_278_, lean_object* v_a_279_, lean_object* v_a_280_, lean_object* v_a_281_, lean_object* v_a_282_){
_start:
{
lean_object* v_boolExpr_284_; lean_object* v___x_285_; lean_object* v___x_286_; lean_object* v___y_288_; 
v_boolExpr_284_ = lean_alloc_ctor(1, 0, 1);
lean_ctor_set_uint8(v_boolExpr_284_, 0, v_val_276_);
v___x_285_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__2, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__2);
v___x_286_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6);
if (v_val_276_ == 0)
{
lean_object* v___x_309_; 
v___x_309_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__6);
v___y_288_ = v___x_309_;
goto v___jp_287_;
}
else
{
lean_object* v___x_310_; 
v___x_310_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__9, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__9);
v___y_288_ = v___x_310_;
goto v___jp_287_;
}
v___jp_287_:
{
lean_object* v___x_289_; lean_object* v___x_290_; 
lean_inc_ref(v___y_288_);
v___x_289_ = l_Lean_mkAppB(v___x_285_, v___x_286_, v___y_288_);
v___x_290_ = l_Lean_Meta_Sym_shareCommonInc(v___x_289_, v_a_277_, v_a_278_, v_a_279_, v_a_280_, v_a_281_, v_a_282_);
if (lean_obj_tag(v___x_290_) == 0)
{
lean_object* v_a_291_; lean_object* v___x_293_; uint8_t v_isShared_294_; uint8_t v_isSharedCheck_300_; 
v_a_291_ = lean_ctor_get(v___x_290_, 0);
v_isSharedCheck_300_ = !lean_is_exclusive(v___x_290_);
if (v_isSharedCheck_300_ == 0)
{
v___x_293_ = v___x_290_;
v_isShared_294_ = v_isSharedCheck_300_;
goto v_resetjp_292_;
}
else
{
lean_inc(v_a_291_);
lean_dec(v___x_290_);
v___x_293_ = lean_box(0);
v_isShared_294_ = v_isSharedCheck_300_;
goto v_resetjp_292_;
}
v_resetjp_292_:
{
lean_object* v___f_295_; lean_object* v___x_296_; lean_object* v___x_298_; 
v___f_295_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___closed__3));
lean_inc_ref(v___y_288_);
v___x_296_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_296_, 0, v_boolExpr_284_);
lean_ctor_set(v___x_296_, 1, v___y_288_);
lean_ctor_set(v___x_296_, 2, v___f_295_);
lean_ctor_set(v___x_296_, 3, v_a_291_);
if (v_isShared_294_ == 0)
{
lean_ctor_set(v___x_293_, 0, v___x_296_);
v___x_298_ = v___x_293_;
goto v_reusejp_297_;
}
else
{
lean_object* v_reuseFailAlloc_299_; 
v_reuseFailAlloc_299_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_299_, 0, v___x_296_);
v___x_298_ = v_reuseFailAlloc_299_;
goto v_reusejp_297_;
}
v_reusejp_297_:
{
return v___x_298_;
}
}
}
else
{
lean_object* v_a_301_; lean_object* v___x_303_; uint8_t v_isShared_304_; uint8_t v_isSharedCheck_308_; 
lean_dec_ref_known(v_boolExpr_284_, 0);
v_a_301_ = lean_ctor_get(v___x_290_, 0);
v_isSharedCheck_308_ = !lean_is_exclusive(v___x_290_);
if (v_isSharedCheck_308_ == 0)
{
v___x_303_ = v___x_290_;
v_isShared_304_ = v_isSharedCheck_308_;
goto v_resetjp_302_;
}
else
{
lean_inc(v_a_301_);
lean_dec(v___x_290_);
v___x_303_ = lean_box(0);
v_isShared_304_ = v_isSharedCheck_308_;
goto v_resetjp_302_;
}
v_resetjp_302_:
{
lean_object* v___x_306_; 
if (v_isShared_304_ == 0)
{
v___x_306_ = v___x_303_;
goto v_reusejp_305_;
}
else
{
lean_object* v_reuseFailAlloc_307_; 
v_reuseFailAlloc_307_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_307_, 0, v_a_301_);
v___x_306_ = v_reuseFailAlloc_307_;
goto v_reusejp_305_;
}
v_reusejp_305_:
{
return v___x_306_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg___boxed(lean_object* v_val_311_, lean_object* v_a_312_, lean_object* v_a_313_, lean_object* v_a_314_, lean_object* v_a_315_, lean_object* v_a_316_, lean_object* v_a_317_, lean_object* v_a_318_){
_start:
{
uint8_t v_val_boxed_319_; lean_object* v_res_320_; 
v_val_boxed_319_ = lean_unbox(v_val_311_);
v_res_320_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg(v_val_boxed_319_, v_a_312_, v_a_313_, v_a_314_, v_a_315_, v_a_316_, v_a_317_);
lean_dec(v_a_317_);
lean_dec_ref(v_a_316_);
lean_dec(v_a_315_);
lean_dec_ref(v_a_314_);
lean_dec(v_a_313_);
lean_dec_ref(v_a_312_);
return v_res_320_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst(uint8_t v_val_321_, lean_object* v_a_322_, lean_object* v_a_323_, lean_object* v_a_324_, lean_object* v_a_325_, lean_object* v_a_326_, lean_object* v_a_327_, lean_object* v_a_328_, lean_object* v_a_329_){
_start:
{
lean_object* v___x_331_; 
v___x_331_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___redArg(v_val_321_, v_a_324_, v_a_325_, v_a_326_, v_a_327_, v_a_328_, v_a_329_);
return v___x_331_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst___boxed(lean_object* v_val_332_, lean_object* v_a_333_, lean_object* v_a_334_, lean_object* v_a_335_, lean_object* v_a_336_, lean_object* v_a_337_, lean_object* v_a_338_, lean_object* v_a_339_, lean_object* v_a_340_, lean_object* v_a_341_){
_start:
{
uint8_t v_val_boxed_342_; lean_object* v_res_343_; 
v_val_boxed_342_ = lean_unbox(v_val_332_);
v_res_343_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkBoolConst(v_val_boxed_342_, v_a_333_, v_a_334_, v_a_335_, v_a_336_, v_a_337_, v_a_338_, v_a_339_, v_a_340_);
lean_dec(v_a_340_);
lean_dec_ref(v_a_339_);
lean_dec(v_a_338_);
lean_dec_ref(v_a_337_);
lean_dec(v_a_336_);
lean_dec_ref(v_a_335_);
lean_dec(v_a_334_);
lean_dec_ref(v_a_333_);
return v_res_343_;
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate(uint8_t v_gate_377_){
_start:
{
switch(v_gate_377_)
{
case 0:
{
lean_object* v___x_378_; 
v___x_378_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__2));
return v___x_378_;
}
case 1:
{
lean_object* v___x_379_; 
v___x_379_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__4));
return v___x_379_;
}
case 2:
{
lean_object* v___x_380_; 
v___x_380_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__6));
return v___x_380_;
}
default: 
{
lean_object* v___x_381_; 
v___x_381_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__8));
return v___x_381_;
}
}
}
}
LEAN_EXPORT lean_object* l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___boxed(lean_object* v_gate_382_){
_start:
{
uint8_t v_gate_boxed_383_; lean_object* v_res_384_; 
v_gate_boxed_383_ = lean_unbox(v_gate_382_);
v_res_384_ = l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate(v_gate_boxed_383_);
return v_res_384_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_spec__0(lean_object* v_fst_385_, lean_object* v_fproof_386_, lean_object* v_snd_387_, lean_object* v_sproof_388_){
_start:
{
if (lean_obj_tag(v_fproof_386_) == 0)
{
lean_dec_ref(v_snd_387_);
if (lean_obj_tag(v_sproof_388_) == 0)
{
lean_object* v___x_389_; 
lean_dec_ref(v_fst_385_);
v___x_389_ = lean_box(0);
return v___x_389_;
}
else
{
lean_object* v_val_390_; lean_object* v___x_392_; uint8_t v_isShared_393_; uint8_t v_isSharedCheck_399_; 
v_val_390_ = lean_ctor_get(v_sproof_388_, 0);
v_isSharedCheck_399_ = !lean_is_exclusive(v_sproof_388_);
if (v_isSharedCheck_399_ == 0)
{
v___x_392_ = v_sproof_388_;
v_isShared_393_ = v_isSharedCheck_399_;
goto v_resetjp_391_;
}
else
{
lean_inc(v_val_390_);
lean_dec(v_sproof_388_);
v___x_392_ = lean_box(0);
v_isShared_393_ = v_isSharedCheck_399_;
goto v_resetjp_391_;
}
v_resetjp_391_:
{
lean_object* v___x_394_; lean_object* v___x_395_; lean_object* v___x_397_; 
v___x_394_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl(v_fst_385_);
v___x_395_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_395_, 0, v___x_394_);
lean_ctor_set(v___x_395_, 1, v_val_390_);
if (v_isShared_393_ == 0)
{
lean_ctor_set(v___x_392_, 0, v___x_395_);
v___x_397_ = v___x_392_;
goto v_reusejp_396_;
}
else
{
lean_object* v_reuseFailAlloc_398_; 
v_reuseFailAlloc_398_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_398_, 0, v___x_395_);
v___x_397_ = v_reuseFailAlloc_398_;
goto v_reusejp_396_;
}
v_reusejp_396_:
{
return v___x_397_;
}
}
}
}
else
{
lean_dec_ref(v_fst_385_);
if (lean_obj_tag(v_sproof_388_) == 0)
{
lean_object* v_val_400_; lean_object* v___x_402_; uint8_t v_isShared_403_; uint8_t v_isSharedCheck_409_; 
v_val_400_ = lean_ctor_get(v_fproof_386_, 0);
v_isSharedCheck_409_ = !lean_is_exclusive(v_fproof_386_);
if (v_isSharedCheck_409_ == 0)
{
v___x_402_ = v_fproof_386_;
v_isShared_403_ = v_isSharedCheck_409_;
goto v_resetjp_401_;
}
else
{
lean_inc(v_val_400_);
lean_dec(v_fproof_386_);
v___x_402_ = lean_box(0);
v_isShared_403_ = v_isSharedCheck_409_;
goto v_resetjp_401_;
}
v_resetjp_401_:
{
lean_object* v___x_404_; lean_object* v___x_405_; lean_object* v___x_407_; 
v___x_404_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl(v_snd_387_);
v___x_405_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_405_, 0, v_val_400_);
lean_ctor_set(v___x_405_, 1, v___x_404_);
if (v_isShared_403_ == 0)
{
lean_ctor_set(v___x_402_, 0, v___x_405_);
v___x_407_ = v___x_402_;
goto v_reusejp_406_;
}
else
{
lean_object* v_reuseFailAlloc_408_; 
v_reuseFailAlloc_408_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_408_, 0, v___x_405_);
v___x_407_ = v_reuseFailAlloc_408_;
goto v_reusejp_406_;
}
v_reusejp_406_:
{
return v___x_407_;
}
}
}
else
{
lean_object* v_val_410_; lean_object* v_val_411_; lean_object* v___x_413_; uint8_t v_isShared_414_; uint8_t v_isSharedCheck_419_; 
lean_dec_ref(v_snd_387_);
v_val_410_ = lean_ctor_get(v_fproof_386_, 0);
lean_inc(v_val_410_);
lean_dec_ref_known(v_fproof_386_, 1);
v_val_411_ = lean_ctor_get(v_sproof_388_, 0);
v_isSharedCheck_419_ = !lean_is_exclusive(v_sproof_388_);
if (v_isSharedCheck_419_ == 0)
{
v___x_413_ = v_sproof_388_;
v_isShared_414_ = v_isSharedCheck_419_;
goto v_resetjp_412_;
}
else
{
lean_inc(v_val_411_);
lean_dec(v_sproof_388_);
v___x_413_ = lean_box(0);
v_isShared_414_ = v_isSharedCheck_419_;
goto v_resetjp_412_;
}
v_resetjp_412_:
{
lean_object* v___x_415_; lean_object* v___x_417_; 
v___x_415_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_415_, 0, v_val_410_);
lean_ctor_set(v___x_415_, 1, v_val_411_);
if (v_isShared_414_ == 0)
{
lean_ctor_set(v___x_413_, 0, v___x_415_);
v___x_417_ = v___x_413_;
goto v_reusejp_416_;
}
else
{
lean_object* v_reuseFailAlloc_418_; 
v_reuseFailAlloc_418_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_418_, 0, v___x_415_);
v___x_417_ = v_reuseFailAlloc_418_;
goto v_reusejp_416_;
}
v_reusejp_416_:
{
return v___x_417_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___lam__0(lean_object* v_expr_420_, lean_object* v_expr_421_, lean_object* v_lhs_422_, lean_object* v_rhs_423_, lean_object* v_congrThm_424_, lean_object* v___x_425_, lean_object* v_lhsExpr_426_, lean_object* v_rhsExpr_427_, lean_object* v___y_428_, lean_object* v___y_429_, lean_object* v___y_430_, lean_object* v___y_431_, lean_object* v___y_432_, lean_object* v___y_433_, lean_object* v___y_434_, lean_object* v___y_435_){
_start:
{
lean_object* v___x_437_; 
v___x_437_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr(v_expr_420_, v___y_428_, v___y_429_, v___y_430_, v___y_431_, v___y_432_, v___y_433_, v___y_434_, v___y_435_);
if (lean_obj_tag(v___x_437_) == 0)
{
lean_object* v_a_438_; lean_object* v___x_439_; 
v_a_438_ = lean_ctor_get(v___x_437_, 0);
lean_inc(v_a_438_);
lean_dec_ref_known(v___x_437_, 1);
v___x_439_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr(v_expr_421_, v___y_428_, v___y_429_, v___y_430_, v___y_431_, v___y_432_, v___y_433_, v___y_434_, v___y_435_);
if (lean_obj_tag(v___x_439_) == 0)
{
lean_object* v_a_440_; lean_object* v___x_441_; 
v_a_440_ = lean_ctor_get(v___x_439_, 0);
lean_inc(v_a_440_);
lean_dec_ref_known(v___x_439_, 1);
v___x_441_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(v_lhs_422_, v___y_428_, v___y_429_, v___y_430_, v___y_431_, v___y_432_, v___y_433_, v___y_434_, v___y_435_);
if (lean_obj_tag(v___x_441_) == 0)
{
lean_object* v_a_442_; lean_object* v___x_443_; 
v_a_442_ = lean_ctor_get(v___x_441_, 0);
lean_inc(v_a_442_);
lean_dec_ref_known(v___x_441_, 1);
v___x_443_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(v_rhs_423_, v___y_428_, v___y_429_, v___y_430_, v___y_431_, v___y_432_, v___y_433_, v___y_434_, v___y_435_);
if (lean_obj_tag(v___x_443_) == 0)
{
lean_object* v_a_444_; lean_object* v___x_446_; uint8_t v_isShared_447_; uint8_t v_isSharedCheck_468_; 
v_a_444_ = lean_ctor_get(v___x_443_, 0);
v_isSharedCheck_468_ = !lean_is_exclusive(v___x_443_);
if (v_isSharedCheck_468_ == 0)
{
v___x_446_ = v___x_443_;
v_isShared_447_ = v_isSharedCheck_468_;
goto v_resetjp_445_;
}
else
{
lean_inc(v_a_444_);
lean_dec(v___x_443_);
v___x_446_ = lean_box(0);
v_isShared_447_ = v_isSharedCheck_468_;
goto v_resetjp_445_;
}
v_resetjp_445_:
{
lean_object* v___x_448_; 
lean_inc(v_a_440_);
lean_inc(v_a_438_);
v___x_448_ = l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_spec__0(v_a_438_, v_a_442_, v_a_440_, v_a_444_);
if (lean_obj_tag(v___x_448_) == 1)
{
lean_object* v_val_449_; lean_object* v___x_451_; uint8_t v_isShared_452_; uint8_t v_isSharedCheck_463_; 
v_val_449_ = lean_ctor_get(v___x_448_, 0);
v_isSharedCheck_463_ = !lean_is_exclusive(v___x_448_);
if (v_isSharedCheck_463_ == 0)
{
v___x_451_ = v___x_448_;
v_isShared_452_ = v_isSharedCheck_463_;
goto v_resetjp_450_;
}
else
{
lean_inc(v_val_449_);
lean_dec(v___x_448_);
v___x_451_ = lean_box(0);
v_isShared_452_ = v_isSharedCheck_463_;
goto v_resetjp_450_;
}
v_resetjp_450_:
{
lean_object* v_fst_453_; lean_object* v_snd_454_; lean_object* v___x_455_; lean_object* v___x_456_; lean_object* v___x_458_; 
v_fst_453_ = lean_ctor_get(v_val_449_, 0);
lean_inc(v_fst_453_);
v_snd_454_ = lean_ctor_get(v_val_449_, 1);
lean_inc(v_snd_454_);
lean_dec(v_val_449_);
v___x_455_ = l_Lean_mkConst(v_congrThm_424_, v___x_425_);
v___x_456_ = l_Lean_mkApp6(v___x_455_, v_lhsExpr_426_, v_rhsExpr_427_, v_a_438_, v_a_440_, v_fst_453_, v_snd_454_);
if (v_isShared_452_ == 0)
{
lean_ctor_set(v___x_451_, 0, v___x_456_);
v___x_458_ = v___x_451_;
goto v_reusejp_457_;
}
else
{
lean_object* v_reuseFailAlloc_462_; 
v_reuseFailAlloc_462_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_462_, 0, v___x_456_);
v___x_458_ = v_reuseFailAlloc_462_;
goto v_reusejp_457_;
}
v_reusejp_457_:
{
lean_object* v___x_460_; 
if (v_isShared_447_ == 0)
{
lean_ctor_set(v___x_446_, 0, v___x_458_);
v___x_460_ = v___x_446_;
goto v_reusejp_459_;
}
else
{
lean_object* v_reuseFailAlloc_461_; 
v_reuseFailAlloc_461_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_461_, 0, v___x_458_);
v___x_460_ = v_reuseFailAlloc_461_;
goto v_reusejp_459_;
}
v_reusejp_459_:
{
return v___x_460_;
}
}
}
}
else
{
lean_object* v___x_464_; lean_object* v___x_466_; 
lean_dec(v___x_448_);
lean_dec(v_a_440_);
lean_dec(v_a_438_);
lean_dec_ref(v_rhsExpr_427_);
lean_dec_ref(v_lhsExpr_426_);
lean_dec(v___x_425_);
lean_dec(v_congrThm_424_);
v___x_464_ = lean_box(0);
if (v_isShared_447_ == 0)
{
lean_ctor_set(v___x_446_, 0, v___x_464_);
v___x_466_ = v___x_446_;
goto v_reusejp_465_;
}
else
{
lean_object* v_reuseFailAlloc_467_; 
v_reuseFailAlloc_467_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_467_, 0, v___x_464_);
v___x_466_ = v_reuseFailAlloc_467_;
goto v_reusejp_465_;
}
v_reusejp_465_:
{
return v___x_466_;
}
}
}
}
else
{
lean_dec(v_a_442_);
lean_dec(v_a_440_);
lean_dec(v_a_438_);
lean_dec_ref(v_rhsExpr_427_);
lean_dec_ref(v_lhsExpr_426_);
lean_dec(v___x_425_);
lean_dec(v_congrThm_424_);
return v___x_443_;
}
}
else
{
lean_dec(v_a_440_);
lean_dec(v_a_438_);
lean_dec_ref(v_rhsExpr_427_);
lean_dec_ref(v_lhsExpr_426_);
lean_dec(v___x_425_);
lean_dec(v_congrThm_424_);
lean_dec_ref(v_rhs_423_);
return v___x_441_;
}
}
else
{
lean_object* v_a_469_; lean_object* v___x_471_; uint8_t v_isShared_472_; uint8_t v_isSharedCheck_476_; 
lean_dec(v_a_438_);
lean_dec_ref(v_rhsExpr_427_);
lean_dec_ref(v_lhsExpr_426_);
lean_dec(v___x_425_);
lean_dec(v_congrThm_424_);
lean_dec_ref(v_rhs_423_);
lean_dec_ref(v_lhs_422_);
v_a_469_ = lean_ctor_get(v___x_439_, 0);
v_isSharedCheck_476_ = !lean_is_exclusive(v___x_439_);
if (v_isSharedCheck_476_ == 0)
{
v___x_471_ = v___x_439_;
v_isShared_472_ = v_isSharedCheck_476_;
goto v_resetjp_470_;
}
else
{
lean_inc(v_a_469_);
lean_dec(v___x_439_);
v___x_471_ = lean_box(0);
v_isShared_472_ = v_isSharedCheck_476_;
goto v_resetjp_470_;
}
v_resetjp_470_:
{
lean_object* v___x_474_; 
if (v_isShared_472_ == 0)
{
v___x_474_ = v___x_471_;
goto v_reusejp_473_;
}
else
{
lean_object* v_reuseFailAlloc_475_; 
v_reuseFailAlloc_475_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_475_, 0, v_a_469_);
v___x_474_ = v_reuseFailAlloc_475_;
goto v_reusejp_473_;
}
v_reusejp_473_:
{
return v___x_474_;
}
}
}
}
else
{
lean_object* v_a_477_; lean_object* v___x_479_; uint8_t v_isShared_480_; uint8_t v_isSharedCheck_484_; 
lean_dec_ref(v_rhsExpr_427_);
lean_dec_ref(v_lhsExpr_426_);
lean_dec(v___x_425_);
lean_dec(v_congrThm_424_);
lean_dec_ref(v_rhs_423_);
lean_dec_ref(v_lhs_422_);
lean_dec_ref(v_expr_421_);
v_a_477_ = lean_ctor_get(v___x_437_, 0);
v_isSharedCheck_484_ = !lean_is_exclusive(v___x_437_);
if (v_isSharedCheck_484_ == 0)
{
v___x_479_ = v___x_437_;
v_isShared_480_ = v_isSharedCheck_484_;
goto v_resetjp_478_;
}
else
{
lean_inc(v_a_477_);
lean_dec(v___x_437_);
v___x_479_ = lean_box(0);
v_isShared_480_ = v_isSharedCheck_484_;
goto v_resetjp_478_;
}
v_resetjp_478_:
{
lean_object* v___x_482_; 
if (v_isShared_480_ == 0)
{
v___x_482_ = v___x_479_;
goto v_reusejp_481_;
}
else
{
lean_object* v_reuseFailAlloc_483_; 
v_reuseFailAlloc_483_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_483_, 0, v_a_477_);
v___x_482_ = v_reuseFailAlloc_483_;
goto v_reusejp_481_;
}
v_reusejp_481_:
{
return v___x_482_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___lam__0___boxed(lean_object** _args){
lean_object* v_expr_485_ = _args[0];
lean_object* v_expr_486_ = _args[1];
lean_object* v_lhs_487_ = _args[2];
lean_object* v_rhs_488_ = _args[3];
lean_object* v_congrThm_489_ = _args[4];
lean_object* v___x_490_ = _args[5];
lean_object* v_lhsExpr_491_ = _args[6];
lean_object* v_rhsExpr_492_ = _args[7];
lean_object* v___y_493_ = _args[8];
lean_object* v___y_494_ = _args[9];
lean_object* v___y_495_ = _args[10];
lean_object* v___y_496_ = _args[11];
lean_object* v___y_497_ = _args[12];
lean_object* v___y_498_ = _args[13];
lean_object* v___y_499_ = _args[14];
lean_object* v___y_500_ = _args[15];
lean_object* v___y_501_ = _args[16];
_start:
{
lean_object* v_res_502_; 
v_res_502_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___lam__0(v_expr_485_, v_expr_486_, v_lhs_487_, v_rhs_488_, v_congrThm_489_, v___x_490_, v_lhsExpr_491_, v_rhsExpr_492_, v___y_493_, v___y_494_, v___y_495_, v___y_496_, v___y_497_, v___y_498_, v___y_499_, v___y_500_);
lean_dec(v___y_500_);
lean_dec_ref(v___y_499_);
lean_dec(v___y_498_);
lean_dec_ref(v___y_497_);
lean_dec(v___y_496_);
lean_dec_ref(v___y_495_);
lean_dec(v___y_494_);
lean_dec_ref(v___y_493_);
return v_res_502_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__2(void){
_start:
{
lean_object* v___x_510_; lean_object* v___x_511_; lean_object* v___x_512_; 
v___x_510_ = lean_box(0);
v___x_511_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__1));
v___x_512_ = l_Lean_mkConst(v___x_511_, v___x_510_);
return v___x_512_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__6(void){
_start:
{
lean_object* v___x_521_; lean_object* v___x_522_; lean_object* v___x_523_; 
v___x_521_ = lean_box(0);
v___x_522_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__5));
v___x_523_ = l_Lean_mkConst(v___x_522_, v___x_521_);
return v___x_523_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__9(void){
_start:
{
lean_object* v___x_531_; lean_object* v___x_532_; lean_object* v___x_533_; 
v___x_531_ = lean_box(0);
v___x_532_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__8));
v___x_533_ = l_Lean_mkConst(v___x_532_, v___x_531_);
return v___x_533_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__12(void){
_start:
{
lean_object* v___x_541_; lean_object* v___x_542_; lean_object* v___x_543_; 
v___x_541_ = lean_box(0);
v___x_542_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__11));
v___x_543_ = l_Lean_mkConst(v___x_542_, v___x_541_);
return v___x_543_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__15(void){
_start:
{
lean_object* v___x_551_; lean_object* v___x_552_; lean_object* v___x_553_; 
v___x_551_ = lean_box(0);
v___x_552_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__14));
v___x_553_ = l_Lean_mkConst(v___x_552_, v___x_551_);
return v___x_553_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg(lean_object* v_lhs_554_, lean_object* v_rhs_555_, lean_object* v_lhsExpr_556_, lean_object* v_rhsExpr_557_, uint8_t v_gate_558_, lean_object* v_origExpr_559_, lean_object* v_a_560_, lean_object* v_a_561_, lean_object* v_a_562_, lean_object* v_a_563_, lean_object* v_a_564_, lean_object* v_a_565_){
_start:
{
lean_object* v_bvExpr_567_; lean_object* v_expr_568_; lean_object* v_bvExpr_569_; lean_object* v_expr_570_; lean_object* v_congrThm_571_; lean_object* v_boolExpr_572_; lean_object* v___x_573_; lean_object* v___f_574_; lean_object* v___x_575_; lean_object* v___x_576_; lean_object* v___y_578_; 
v_bvExpr_567_ = lean_ctor_get(v_lhs_554_, 0);
v_expr_568_ = lean_ctor_get(v_lhs_554_, 3);
lean_inc_ref_n(v_expr_568_, 2);
v_bvExpr_569_ = lean_ctor_get(v_rhs_555_, 0);
v_expr_570_ = lean_ctor_get(v_rhs_555_, 3);
lean_inc_ref_n(v_expr_570_, 2);
v_congrThm_571_ = l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate(v_gate_558_);
lean_inc_ref(v_bvExpr_569_);
lean_inc_ref(v_bvExpr_567_);
v_boolExpr_572_ = lean_alloc_ctor(3, 2, 1);
lean_ctor_set(v_boolExpr_572_, 0, v_bvExpr_567_);
lean_ctor_set(v_boolExpr_572_, 1, v_bvExpr_569_);
lean_ctor_set_uint8(v_boolExpr_572_, sizeof(void*)*2, v_gate_558_);
v___x_573_ = lean_box(0);
v___f_574_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___lam__0___boxed), 17, 8);
lean_closure_set(v___f_574_, 0, v_expr_568_);
lean_closure_set(v___f_574_, 1, v_expr_570_);
lean_closure_set(v___f_574_, 2, v_lhs_554_);
lean_closure_set(v___f_574_, 3, v_rhs_555_);
lean_closure_set(v___f_574_, 4, v_congrThm_571_);
lean_closure_set(v___f_574_, 5, v___x_573_);
lean_closure_set(v___f_574_, 6, v_lhsExpr_556_);
lean_closure_set(v___f_574_, 7, v_rhsExpr_557_);
v___x_575_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__2, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__2);
v___x_576_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6);
switch(v_gate_558_)
{
case 0:
{
lean_object* v___x_598_; 
v___x_598_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__6);
v___y_578_ = v___x_598_;
goto v___jp_577_;
}
case 1:
{
lean_object* v___x_599_; 
v___x_599_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__9, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__9_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__9);
v___y_578_ = v___x_599_;
goto v___jp_577_;
}
case 2:
{
lean_object* v___x_600_; 
v___x_600_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__12, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__12_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__12);
v___y_578_ = v___x_600_;
goto v___jp_577_;
}
default: 
{
lean_object* v___x_601_; 
v___x_601_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__15, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__15_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___closed__15);
v___y_578_ = v___x_601_;
goto v___jp_577_;
}
}
v___jp_577_:
{
lean_object* v___x_579_; lean_object* v___x_580_; 
lean_inc_ref(v___y_578_);
v___x_579_ = l_Lean_mkApp4(v___x_575_, v___x_576_, v___y_578_, v_expr_568_, v_expr_570_);
v___x_580_ = l_Lean_Meta_Sym_shareCommonInc(v___x_579_, v_a_560_, v_a_561_, v_a_562_, v_a_563_, v_a_564_, v_a_565_);
if (lean_obj_tag(v___x_580_) == 0)
{
lean_object* v_a_581_; lean_object* v___x_583_; uint8_t v_isShared_584_; uint8_t v_isSharedCheck_589_; 
v_a_581_ = lean_ctor_get(v___x_580_, 0);
v_isSharedCheck_589_ = !lean_is_exclusive(v___x_580_);
if (v_isSharedCheck_589_ == 0)
{
v___x_583_ = v___x_580_;
v_isShared_584_ = v_isSharedCheck_589_;
goto v_resetjp_582_;
}
else
{
lean_inc(v_a_581_);
lean_dec(v___x_580_);
v___x_583_ = lean_box(0);
v_isShared_584_ = v_isSharedCheck_589_;
goto v_resetjp_582_;
}
v_resetjp_582_:
{
lean_object* v___x_585_; lean_object* v___x_587_; 
v___x_585_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_585_, 0, v_boolExpr_572_);
lean_ctor_set(v___x_585_, 1, v_origExpr_559_);
lean_ctor_set(v___x_585_, 2, v___f_574_);
lean_ctor_set(v___x_585_, 3, v_a_581_);
if (v_isShared_584_ == 0)
{
lean_ctor_set(v___x_583_, 0, v___x_585_);
v___x_587_ = v___x_583_;
goto v_reusejp_586_;
}
else
{
lean_object* v_reuseFailAlloc_588_; 
v_reuseFailAlloc_588_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_588_, 0, v___x_585_);
v___x_587_ = v_reuseFailAlloc_588_;
goto v_reusejp_586_;
}
v_reusejp_586_:
{
return v___x_587_;
}
}
}
else
{
lean_object* v_a_590_; lean_object* v___x_592_; uint8_t v_isShared_593_; uint8_t v_isSharedCheck_597_; 
lean_dec_ref(v___f_574_);
lean_dec_ref_known(v_boolExpr_572_, 2);
lean_dec_ref(v_origExpr_559_);
v_a_590_ = lean_ctor_get(v___x_580_, 0);
v_isSharedCheck_597_ = !lean_is_exclusive(v___x_580_);
if (v_isSharedCheck_597_ == 0)
{
v___x_592_ = v___x_580_;
v_isShared_593_ = v_isSharedCheck_597_;
goto v_resetjp_591_;
}
else
{
lean_inc(v_a_590_);
lean_dec(v___x_580_);
v___x_592_ = lean_box(0);
v_isShared_593_ = v_isSharedCheck_597_;
goto v_resetjp_591_;
}
v_resetjp_591_:
{
lean_object* v___x_595_; 
if (v_isShared_593_ == 0)
{
v___x_595_ = v___x_592_;
goto v_reusejp_594_;
}
else
{
lean_object* v_reuseFailAlloc_596_; 
v_reuseFailAlloc_596_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_596_, 0, v_a_590_);
v___x_595_ = v_reuseFailAlloc_596_;
goto v_reusejp_594_;
}
v_reusejp_594_:
{
return v___x_595_;
}
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg___boxed(lean_object* v_lhs_602_, lean_object* v_rhs_603_, lean_object* v_lhsExpr_604_, lean_object* v_rhsExpr_605_, lean_object* v_gate_606_, lean_object* v_origExpr_607_, lean_object* v_a_608_, lean_object* v_a_609_, lean_object* v_a_610_, lean_object* v_a_611_, lean_object* v_a_612_, lean_object* v_a_613_, lean_object* v_a_614_){
_start:
{
uint8_t v_gate_boxed_615_; lean_object* v_res_616_; 
v_gate_boxed_615_ = lean_unbox(v_gate_606_);
v_res_616_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg(v_lhs_602_, v_rhs_603_, v_lhsExpr_604_, v_rhsExpr_605_, v_gate_boxed_615_, v_origExpr_607_, v_a_608_, v_a_609_, v_a_610_, v_a_611_, v_a_612_, v_a_613_);
lean_dec(v_a_613_);
lean_dec_ref(v_a_612_);
lean_dec(v_a_611_);
lean_dec_ref(v_a_610_);
lean_dec(v_a_609_);
lean_dec_ref(v_a_608_);
return v_res_616_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate(lean_object* v_lhs_617_, lean_object* v_rhs_618_, lean_object* v_lhsExpr_619_, lean_object* v_rhsExpr_620_, uint8_t v_gate_621_, lean_object* v_origExpr_622_, lean_object* v_a_623_, lean_object* v_a_624_, lean_object* v_a_625_, lean_object* v_a_626_, lean_object* v_a_627_, lean_object* v_a_628_, lean_object* v_a_629_, lean_object* v_a_630_){
_start:
{
lean_object* v___x_632_; 
v___x_632_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___redArg(v_lhs_617_, v_rhs_618_, v_lhsExpr_619_, v_rhsExpr_620_, v_gate_621_, v_origExpr_622_, v_a_625_, v_a_626_, v_a_627_, v_a_628_, v_a_629_, v_a_630_);
return v___x_632_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate___boxed(lean_object* v_lhs_633_, lean_object* v_rhs_634_, lean_object* v_lhsExpr_635_, lean_object* v_rhsExpr_636_, lean_object* v_gate_637_, lean_object* v_origExpr_638_, lean_object* v_a_639_, lean_object* v_a_640_, lean_object* v_a_641_, lean_object* v_a_642_, lean_object* v_a_643_, lean_object* v_a_644_, lean_object* v_a_645_, lean_object* v_a_646_, lean_object* v_a_647_){
_start:
{
uint8_t v_gate_boxed_648_; lean_object* v_res_649_; 
v_gate_boxed_648_ = lean_unbox(v_gate_637_);
v_res_649_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate(v_lhs_633_, v_rhs_634_, v_lhsExpr_635_, v_rhsExpr_636_, v_gate_boxed_648_, v_origExpr_638_, v_a_639_, v_a_640_, v_a_641_, v_a_642_, v_a_643_, v_a_644_, v_a_645_, v_a_646_);
lean_dec(v_a_646_);
lean_dec_ref(v_a_645_);
lean_dec(v_a_644_);
lean_dec_ref(v_a_643_);
lean_dec(v_a_642_);
lean_dec_ref(v_a_641_);
lean_dec(v_a_640_);
lean_dec_ref(v_a_639_);
return v_res_649_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0(lean_object* v_sub_651_, lean_object* v_expr_652_, lean_object* v___x_653_, lean_object* v___x_654_, lean_object* v___x_655_, lean_object* v___x_656_, lean_object* v_subExpr_657_, lean_object* v___y_658_, lean_object* v___y_659_, lean_object* v___y_660_, lean_object* v___y_661_, lean_object* v___y_662_, lean_object* v___y_663_, lean_object* v___y_664_, lean_object* v___y_665_){
_start:
{
lean_object* v___x_667_; 
v___x_667_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(v_sub_651_, v___y_658_, v___y_659_, v___y_660_, v___y_661_, v___y_662_, v___y_663_, v___y_664_, v___y_665_);
if (lean_obj_tag(v___x_667_) == 0)
{
lean_object* v_a_668_; lean_object* v___x_670_; uint8_t v_isShared_671_; uint8_t v_isSharedCheck_707_; 
v_a_668_ = lean_ctor_get(v___x_667_, 0);
v_isSharedCheck_707_ = !lean_is_exclusive(v___x_667_);
if (v_isSharedCheck_707_ == 0)
{
v___x_670_ = v___x_667_;
v_isShared_671_ = v_isSharedCheck_707_;
goto v_resetjp_669_;
}
else
{
lean_inc(v_a_668_);
lean_dec(v___x_667_);
v___x_670_ = lean_box(0);
v_isShared_671_ = v_isSharedCheck_707_;
goto v_resetjp_669_;
}
v_resetjp_669_:
{
if (lean_obj_tag(v_a_668_) == 1)
{
lean_object* v_val_672_; lean_object* v___x_674_; uint8_t v_isShared_675_; uint8_t v_isSharedCheck_702_; 
lean_del_object(v___x_670_);
v_val_672_ = lean_ctor_get(v_a_668_, 0);
v_isSharedCheck_702_ = !lean_is_exclusive(v_a_668_);
if (v_isSharedCheck_702_ == 0)
{
v___x_674_ = v_a_668_;
v_isShared_675_ = v_isSharedCheck_702_;
goto v_resetjp_673_;
}
else
{
lean_inc(v_val_672_);
lean_dec(v_a_668_);
v___x_674_ = lean_box(0);
v_isShared_675_ = v_isSharedCheck_702_;
goto v_resetjp_673_;
}
v_resetjp_673_:
{
lean_object* v___x_676_; 
v___x_676_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr(v_expr_652_, v___y_658_, v___y_659_, v___y_660_, v___y_661_, v___y_662_, v___y_663_, v___y_664_, v___y_665_);
if (lean_obj_tag(v___x_676_) == 0)
{
lean_object* v_a_677_; lean_object* v___x_679_; uint8_t v_isShared_680_; uint8_t v_isSharedCheck_693_; 
v_a_677_ = lean_ctor_get(v___x_676_, 0);
v_isSharedCheck_693_ = !lean_is_exclusive(v___x_676_);
if (v_isSharedCheck_693_ == 0)
{
v___x_679_ = v___x_676_;
v_isShared_680_ = v_isSharedCheck_693_;
goto v_resetjp_678_;
}
else
{
lean_inc(v_a_677_);
lean_dec(v___x_676_);
v___x_679_ = lean_box(0);
v_isShared_680_ = v_isSharedCheck_693_;
goto v_resetjp_678_;
}
v_resetjp_678_:
{
lean_object* v___x_681_; lean_object* v___x_682_; lean_object* v___x_683_; lean_object* v___x_684_; lean_object* v___x_685_; lean_object* v___x_686_; lean_object* v___x_688_; 
v___x_681_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__0));
v___x_682_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6));
v___x_683_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0___closed__0));
v___x_684_ = l_Lean_Name_mkStr6(v___x_653_, v___x_654_, v___x_655_, v___x_681_, v___x_682_, v___x_683_);
v___x_685_ = l_Lean_mkConst(v___x_684_, v___x_656_);
v___x_686_ = l_Lean_mkApp3(v___x_685_, v_subExpr_657_, v_a_677_, v_val_672_);
if (v_isShared_675_ == 0)
{
lean_ctor_set(v___x_674_, 0, v___x_686_);
v___x_688_ = v___x_674_;
goto v_reusejp_687_;
}
else
{
lean_object* v_reuseFailAlloc_692_; 
v_reuseFailAlloc_692_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_692_, 0, v___x_686_);
v___x_688_ = v_reuseFailAlloc_692_;
goto v_reusejp_687_;
}
v_reusejp_687_:
{
lean_object* v___x_690_; 
if (v_isShared_680_ == 0)
{
lean_ctor_set(v___x_679_, 0, v___x_688_);
v___x_690_ = v___x_679_;
goto v_reusejp_689_;
}
else
{
lean_object* v_reuseFailAlloc_691_; 
v_reuseFailAlloc_691_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_691_, 0, v___x_688_);
v___x_690_ = v_reuseFailAlloc_691_;
goto v_reusejp_689_;
}
v_reusejp_689_:
{
return v___x_690_;
}
}
}
}
else
{
lean_object* v_a_694_; lean_object* v___x_696_; uint8_t v_isShared_697_; uint8_t v_isSharedCheck_701_; 
lean_del_object(v___x_674_);
lean_dec(v_val_672_);
lean_dec_ref(v_subExpr_657_);
lean_dec(v___x_656_);
lean_dec_ref(v___x_655_);
lean_dec_ref(v___x_654_);
lean_dec_ref(v___x_653_);
v_a_694_ = lean_ctor_get(v___x_676_, 0);
v_isSharedCheck_701_ = !lean_is_exclusive(v___x_676_);
if (v_isSharedCheck_701_ == 0)
{
v___x_696_ = v___x_676_;
v_isShared_697_ = v_isSharedCheck_701_;
goto v_resetjp_695_;
}
else
{
lean_inc(v_a_694_);
lean_dec(v___x_676_);
v___x_696_ = lean_box(0);
v_isShared_697_ = v_isSharedCheck_701_;
goto v_resetjp_695_;
}
v_resetjp_695_:
{
lean_object* v___x_699_; 
if (v_isShared_697_ == 0)
{
v___x_699_ = v___x_696_;
goto v_reusejp_698_;
}
else
{
lean_object* v_reuseFailAlloc_700_; 
v_reuseFailAlloc_700_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_700_, 0, v_a_694_);
v___x_699_ = v_reuseFailAlloc_700_;
goto v_reusejp_698_;
}
v_reusejp_698_:
{
return v___x_699_;
}
}
}
}
}
else
{
lean_object* v___x_703_; lean_object* v___x_705_; 
lean_dec(v_a_668_);
lean_dec_ref(v_subExpr_657_);
lean_dec(v___x_656_);
lean_dec_ref(v___x_655_);
lean_dec_ref(v___x_654_);
lean_dec_ref(v___x_653_);
lean_dec_ref(v_expr_652_);
v___x_703_ = lean_box(0);
if (v_isShared_671_ == 0)
{
lean_ctor_set(v___x_670_, 0, v___x_703_);
v___x_705_ = v___x_670_;
goto v_reusejp_704_;
}
else
{
lean_object* v_reuseFailAlloc_706_; 
v_reuseFailAlloc_706_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_706_, 0, v___x_703_);
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
else
{
lean_dec_ref(v_subExpr_657_);
lean_dec(v___x_656_);
lean_dec_ref(v___x_655_);
lean_dec_ref(v___x_654_);
lean_dec_ref(v___x_653_);
lean_dec_ref(v_expr_652_);
return v___x_667_;
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0___boxed(lean_object* v_sub_708_, lean_object* v_expr_709_, lean_object* v___x_710_, lean_object* v___x_711_, lean_object* v___x_712_, lean_object* v___x_713_, lean_object* v_subExpr_714_, lean_object* v___y_715_, lean_object* v___y_716_, lean_object* v___y_717_, lean_object* v___y_718_, lean_object* v___y_719_, lean_object* v___y_720_, lean_object* v___y_721_, lean_object* v___y_722_, lean_object* v___y_723_){
_start:
{
lean_object* v_res_724_; 
v_res_724_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0(v_sub_708_, v_expr_709_, v___x_710_, v___x_711_, v___x_712_, v___x_713_, v_subExpr_714_, v___y_715_, v___y_716_, v___y_717_, v___y_718_, v___y_719_, v___y_720_, v___y_721_, v___y_722_);
lean_dec(v___y_722_);
lean_dec_ref(v___y_721_);
lean_dec(v___y_720_);
lean_dec_ref(v___y_719_);
lean_dec(v___y_718_);
lean_dec_ref(v___y_717_);
lean_dec(v___y_716_);
lean_dec_ref(v___y_715_);
return v_res_724_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__2(void){
_start:
{
lean_object* v___x_732_; lean_object* v___x_733_; lean_object* v___x_734_; 
v___x_732_ = lean_box(0);
v___x_733_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__1));
v___x_734_ = l_Lean_mkConst(v___x_733_, v___x_732_);
return v___x_734_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg(lean_object* v_sub_735_, lean_object* v_subExpr_736_, lean_object* v_origExpr_737_, lean_object* v_a_738_, lean_object* v_a_739_, lean_object* v_a_740_, lean_object* v_a_741_, lean_object* v_a_742_, lean_object* v_a_743_){
_start:
{
lean_object* v_bvExpr_745_; lean_object* v_expr_746_; lean_object* v___x_747_; lean_object* v___x_748_; lean_object* v___x_749_; lean_object* v___x_750_; lean_object* v___x_751_; lean_object* v___x_752_; lean_object* v___x_753_; lean_object* v___x_754_; 
v_bvExpr_745_ = lean_ctor_get(v_sub_735_, 0);
lean_inc_ref(v_bvExpr_745_);
v_expr_746_ = lean_ctor_get(v_sub_735_, 3);
lean_inc_ref_n(v_expr_746_, 2);
v___x_747_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0));
v___x_748_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1));
v___x_749_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2));
v___x_750_ = lean_box(0);
v___x_751_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__2, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___closed__2);
v___x_752_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6);
v___x_753_ = l_Lean_mkAppB(v___x_751_, v___x_752_, v_expr_746_);
v___x_754_ = l_Lean_Meta_Sym_shareCommonInc(v___x_753_, v_a_738_, v_a_739_, v_a_740_, v_a_741_, v_a_742_, v_a_743_);
if (lean_obj_tag(v___x_754_) == 0)
{
lean_object* v_a_755_; lean_object* v___x_757_; uint8_t v_isShared_758_; uint8_t v_isSharedCheck_765_; 
v_a_755_ = lean_ctor_get(v___x_754_, 0);
v_isSharedCheck_765_ = !lean_is_exclusive(v___x_754_);
if (v_isSharedCheck_765_ == 0)
{
v___x_757_ = v___x_754_;
v_isShared_758_ = v_isSharedCheck_765_;
goto v_resetjp_756_;
}
else
{
lean_inc(v_a_755_);
lean_dec(v___x_754_);
v___x_757_ = lean_box(0);
v_isShared_758_ = v_isSharedCheck_765_;
goto v_resetjp_756_;
}
v_resetjp_756_:
{
lean_object* v___f_759_; lean_object* v_boolExpr_760_; lean_object* v___x_761_; lean_object* v___x_763_; 
v___f_759_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___lam__0___boxed), 16, 7);
lean_closure_set(v___f_759_, 0, v_sub_735_);
lean_closure_set(v___f_759_, 1, v_expr_746_);
lean_closure_set(v___f_759_, 2, v___x_747_);
lean_closure_set(v___f_759_, 3, v___x_748_);
lean_closure_set(v___f_759_, 4, v___x_749_);
lean_closure_set(v___f_759_, 5, v___x_750_);
lean_closure_set(v___f_759_, 6, v_subExpr_736_);
v_boolExpr_760_ = lean_alloc_ctor(2, 1, 0);
lean_ctor_set(v_boolExpr_760_, 0, v_bvExpr_745_);
v___x_761_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_761_, 0, v_boolExpr_760_);
lean_ctor_set(v___x_761_, 1, v_origExpr_737_);
lean_ctor_set(v___x_761_, 2, v___f_759_);
lean_ctor_set(v___x_761_, 3, v_a_755_);
if (v_isShared_758_ == 0)
{
lean_ctor_set(v___x_757_, 0, v___x_761_);
v___x_763_ = v___x_757_;
goto v_reusejp_762_;
}
else
{
lean_object* v_reuseFailAlloc_764_; 
v_reuseFailAlloc_764_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_764_, 0, v___x_761_);
v___x_763_ = v_reuseFailAlloc_764_;
goto v_reusejp_762_;
}
v_reusejp_762_:
{
return v___x_763_;
}
}
}
else
{
lean_object* v_a_766_; lean_object* v___x_768_; uint8_t v_isShared_769_; uint8_t v_isSharedCheck_773_; 
lean_dec_ref(v_expr_746_);
lean_dec_ref(v_bvExpr_745_);
lean_dec_ref(v_origExpr_737_);
lean_dec_ref(v_subExpr_736_);
lean_dec_ref(v_sub_735_);
v_a_766_ = lean_ctor_get(v___x_754_, 0);
v_isSharedCheck_773_ = !lean_is_exclusive(v___x_754_);
if (v_isSharedCheck_773_ == 0)
{
v___x_768_ = v___x_754_;
v_isShared_769_ = v_isSharedCheck_773_;
goto v_resetjp_767_;
}
else
{
lean_inc(v_a_766_);
lean_dec(v___x_754_);
v___x_768_ = lean_box(0);
v_isShared_769_ = v_isSharedCheck_773_;
goto v_resetjp_767_;
}
v_resetjp_767_:
{
lean_object* v___x_771_; 
if (v_isShared_769_ == 0)
{
v___x_771_ = v___x_768_;
goto v_reusejp_770_;
}
else
{
lean_object* v_reuseFailAlloc_772_; 
v_reuseFailAlloc_772_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_772_, 0, v_a_766_);
v___x_771_ = v_reuseFailAlloc_772_;
goto v_reusejp_770_;
}
v_reusejp_770_:
{
return v___x_771_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg___boxed(lean_object* v_sub_774_, lean_object* v_subExpr_775_, lean_object* v_origExpr_776_, lean_object* v_a_777_, lean_object* v_a_778_, lean_object* v_a_779_, lean_object* v_a_780_, lean_object* v_a_781_, lean_object* v_a_782_, lean_object* v_a_783_){
_start:
{
lean_object* v_res_784_; 
v_res_784_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg(v_sub_774_, v_subExpr_775_, v_origExpr_776_, v_a_777_, v_a_778_, v_a_779_, v_a_780_, v_a_781_, v_a_782_);
lean_dec(v_a_782_);
lean_dec_ref(v_a_781_);
lean_dec(v_a_780_);
lean_dec_ref(v_a_779_);
lean_dec(v_a_778_);
lean_dec_ref(v_a_777_);
return v_res_784_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot(lean_object* v_sub_785_, lean_object* v_subExpr_786_, lean_object* v_origExpr_787_, lean_object* v_a_788_, lean_object* v_a_789_, lean_object* v_a_790_, lean_object* v_a_791_, lean_object* v_a_792_, lean_object* v_a_793_, lean_object* v_a_794_, lean_object* v_a_795_){
_start:
{
lean_object* v___x_797_; 
v___x_797_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___redArg(v_sub_785_, v_subExpr_786_, v_origExpr_787_, v_a_790_, v_a_791_, v_a_792_, v_a_793_, v_a_794_, v_a_795_);
return v___x_797_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot___boxed(lean_object* v_sub_798_, lean_object* v_subExpr_799_, lean_object* v_origExpr_800_, lean_object* v_a_801_, lean_object* v_a_802_, lean_object* v_a_803_, lean_object* v_a_804_, lean_object* v_a_805_, lean_object* v_a_806_, lean_object* v_a_807_, lean_object* v_a_808_, lean_object* v_a_809_){
_start:
{
lean_object* v_res_810_; 
v_res_810_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkNot(v_sub_798_, v_subExpr_799_, v_origExpr_800_, v_a_801_, v_a_802_, v_a_803_, v_a_804_, v_a_805_, v_a_806_, v_a_807_, v_a_808_);
lean_dec(v_a_808_);
lean_dec_ref(v_a_807_);
lean_dec(v_a_806_);
lean_dec_ref(v_a_805_);
lean_dec(v_a_804_);
lean_dec_ref(v_a_803_);
lean_dec(v_a_802_);
lean_dec_ref(v_a_801_);
return v_res_810_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_M_simplifyTernaryProof___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte_spec__0(lean_object* v_fst_811_, lean_object* v_fproof_812_, lean_object* v_snd_813_, lean_object* v_sproof_814_, lean_object* v_thd_815_, lean_object* v_tproof_816_){
_start:
{
if (lean_obj_tag(v_fproof_812_) == 0)
{
lean_object* v___x_817_; 
v___x_817_ = l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_spec__0(v_snd_813_, v_sproof_814_, v_thd_815_, v_tproof_816_);
if (lean_obj_tag(v___x_817_) == 0)
{
lean_object* v___x_818_; 
lean_dec_ref(v_fst_811_);
v___x_818_ = lean_box(0);
return v___x_818_;
}
else
{
lean_object* v_val_819_; lean_object* v___x_821_; uint8_t v_isShared_822_; uint8_t v_isSharedCheck_828_; 
v_val_819_ = lean_ctor_get(v___x_817_, 0);
v_isSharedCheck_828_ = !lean_is_exclusive(v___x_817_);
if (v_isSharedCheck_828_ == 0)
{
v___x_821_ = v___x_817_;
v_isShared_822_ = v_isSharedCheck_828_;
goto v_resetjp_820_;
}
else
{
lean_inc(v_val_819_);
lean_dec(v___x_817_);
v___x_821_ = lean_box(0);
v_isShared_822_ = v_isSharedCheck_828_;
goto v_resetjp_820_;
}
v_resetjp_820_:
{
lean_object* v___x_823_; lean_object* v___x_824_; lean_object* v___x_826_; 
v___x_823_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl(v_fst_811_);
v___x_824_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_824_, 0, v___x_823_);
lean_ctor_set(v___x_824_, 1, v_val_819_);
if (v_isShared_822_ == 0)
{
lean_ctor_set(v___x_821_, 0, v___x_824_);
v___x_826_ = v___x_821_;
goto v_reusejp_825_;
}
else
{
lean_object* v_reuseFailAlloc_827_; 
v_reuseFailAlloc_827_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_827_, 0, v___x_824_);
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
else
{
lean_object* v_val_829_; lean_object* v___x_831_; uint8_t v_isShared_832_; uint8_t v_isSharedCheck_850_; 
lean_dec_ref(v_fst_811_);
v_val_829_ = lean_ctor_get(v_fproof_812_, 0);
v_isSharedCheck_850_ = !lean_is_exclusive(v_fproof_812_);
if (v_isSharedCheck_850_ == 0)
{
v___x_831_ = v_fproof_812_;
v_isShared_832_ = v_isSharedCheck_850_;
goto v_resetjp_830_;
}
else
{
lean_inc(v_val_829_);
lean_dec(v_fproof_812_);
v___x_831_ = lean_box(0);
v_isShared_832_ = v_isSharedCheck_850_;
goto v_resetjp_830_;
}
v_resetjp_830_:
{
lean_object* v___x_833_; 
lean_inc_ref(v_thd_815_);
lean_inc_ref(v_snd_813_);
v___x_833_ = l_Lean_Meta_Tactic_BVDecide_M_simplifyBinaryProof_x27___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_spec__0(v_snd_813_, v_sproof_814_, v_thd_815_, v_tproof_816_);
if (lean_obj_tag(v___x_833_) == 0)
{
lean_object* v___x_834_; lean_object* v___x_835_; lean_object* v___x_836_; lean_object* v___x_837_; lean_object* v___x_839_; 
v___x_834_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl(v_snd_813_);
v___x_835_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl(v_thd_815_);
v___x_836_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_836_, 0, v___x_834_);
lean_ctor_set(v___x_836_, 1, v___x_835_);
v___x_837_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_837_, 0, v_val_829_);
lean_ctor_set(v___x_837_, 1, v___x_836_);
if (v_isShared_832_ == 0)
{
lean_ctor_set(v___x_831_, 0, v___x_837_);
v___x_839_ = v___x_831_;
goto v_reusejp_838_;
}
else
{
lean_object* v_reuseFailAlloc_840_; 
v_reuseFailAlloc_840_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_840_, 0, v___x_837_);
v___x_839_ = v_reuseFailAlloc_840_;
goto v_reusejp_838_;
}
v_reusejp_838_:
{
return v___x_839_;
}
}
else
{
lean_object* v_val_841_; lean_object* v___x_843_; uint8_t v_isShared_844_; uint8_t v_isSharedCheck_849_; 
lean_del_object(v___x_831_);
lean_dec_ref(v_thd_815_);
lean_dec_ref(v_snd_813_);
v_val_841_ = lean_ctor_get(v___x_833_, 0);
v_isSharedCheck_849_ = !lean_is_exclusive(v___x_833_);
if (v_isSharedCheck_849_ == 0)
{
v___x_843_ = v___x_833_;
v_isShared_844_ = v_isSharedCheck_849_;
goto v_resetjp_842_;
}
else
{
lean_inc(v_val_841_);
lean_dec(v___x_833_);
v___x_843_ = lean_box(0);
v_isShared_844_ = v_isSharedCheck_849_;
goto v_resetjp_842_;
}
v_resetjp_842_:
{
lean_object* v___x_845_; lean_object* v___x_847_; 
v___x_845_ = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(v___x_845_, 0, v_val_829_);
lean_ctor_set(v___x_845_, 1, v_val_841_);
if (v_isShared_844_ == 0)
{
lean_ctor_set(v___x_843_, 0, v___x_845_);
v___x_847_ = v___x_843_;
goto v_reusejp_846_;
}
else
{
lean_object* v_reuseFailAlloc_848_; 
v_reuseFailAlloc_848_ = lean_alloc_ctor(1, 1, 0);
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
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0(lean_object* v_expr_852_, lean_object* v_expr_853_, lean_object* v_expr_854_, lean_object* v_discr_855_, lean_object* v_lhs_856_, lean_object* v_rhs_857_, lean_object* v___x_858_, lean_object* v___x_859_, lean_object* v___x_860_, lean_object* v___x_861_, lean_object* v_discrExpr_862_, lean_object* v_lhsExpr_863_, lean_object* v_rhsExpr_864_, lean_object* v___y_865_, lean_object* v___y_866_, lean_object* v___y_867_, lean_object* v___y_868_, lean_object* v___y_869_, lean_object* v___y_870_, lean_object* v___y_871_, lean_object* v___y_872_){
_start:
{
lean_object* v___x_874_; 
v___x_874_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr(v_expr_852_, v___y_865_, v___y_866_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_);
if (lean_obj_tag(v___x_874_) == 0)
{
lean_object* v_a_875_; lean_object* v___x_876_; 
v_a_875_ = lean_ctor_get(v___x_874_, 0);
lean_inc(v_a_875_);
lean_dec_ref_known(v___x_874_, 1);
v___x_876_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr(v_expr_853_, v___y_865_, v___y_866_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_);
if (lean_obj_tag(v___x_876_) == 0)
{
lean_object* v_a_877_; lean_object* v___x_878_; 
v_a_877_ = lean_ctor_get(v___x_876_, 0);
lean_inc(v_a_877_);
lean_dec_ref_known(v___x_876_, 1);
v___x_878_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr(v_expr_854_, v___y_865_, v___y_866_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_);
if (lean_obj_tag(v___x_878_) == 0)
{
lean_object* v_a_879_; lean_object* v___x_880_; 
v_a_879_ = lean_ctor_get(v___x_878_, 0);
lean_inc(v_a_879_);
lean_dec_ref_known(v___x_878_, 1);
v___x_880_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(v_discr_855_, v___y_865_, v___y_866_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_);
if (lean_obj_tag(v___x_880_) == 0)
{
lean_object* v_a_881_; lean_object* v___x_882_; 
v_a_881_ = lean_ctor_get(v___x_880_, 0);
lean_inc(v_a_881_);
lean_dec_ref_known(v___x_880_, 1);
v___x_882_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(v_lhs_856_, v___y_865_, v___y_866_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_);
if (lean_obj_tag(v___x_882_) == 0)
{
lean_object* v_a_883_; lean_object* v___x_884_; 
v_a_883_ = lean_ctor_get(v___x_882_, 0);
lean_inc(v_a_883_);
lean_dec_ref_known(v___x_882_, 1);
v___x_884_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_evalsAtAtoms(v_rhs_857_, v___y_865_, v___y_866_, v___y_867_, v___y_868_, v___y_869_, v___y_870_, v___y_871_, v___y_872_);
if (lean_obj_tag(v___x_884_) == 0)
{
lean_object* v_a_885_; lean_object* v___x_887_; uint8_t v_isShared_888_; uint8_t v_isSharedCheck_915_; 
v_a_885_ = lean_ctor_get(v___x_884_, 0);
v_isSharedCheck_915_ = !lean_is_exclusive(v___x_884_);
if (v_isSharedCheck_915_ == 0)
{
v___x_887_ = v___x_884_;
v_isShared_888_ = v_isSharedCheck_915_;
goto v_resetjp_886_;
}
else
{
lean_inc(v_a_885_);
lean_dec(v___x_884_);
v___x_887_ = lean_box(0);
v_isShared_888_ = v_isSharedCheck_915_;
goto v_resetjp_886_;
}
v_resetjp_886_:
{
lean_object* v___x_889_; 
lean_inc(v_a_879_);
lean_inc(v_a_877_);
lean_inc(v_a_875_);
v___x_889_ = l_Lean_Meta_Tactic_BVDecide_M_simplifyTernaryProof___at___00Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte_spec__0(v_a_875_, v_a_881_, v_a_877_, v_a_883_, v_a_879_, v_a_885_);
if (lean_obj_tag(v___x_889_) == 1)
{
lean_object* v_val_890_; lean_object* v___x_892_; uint8_t v_isShared_893_; uint8_t v_isSharedCheck_910_; 
v_val_890_ = lean_ctor_get(v___x_889_, 0);
v_isSharedCheck_910_ = !lean_is_exclusive(v___x_889_);
if (v_isSharedCheck_910_ == 0)
{
v___x_892_ = v___x_889_;
v_isShared_893_ = v_isSharedCheck_910_;
goto v_resetjp_891_;
}
else
{
lean_inc(v_val_890_);
lean_dec(v___x_889_);
v___x_892_ = lean_box(0);
v_isShared_893_ = v_isSharedCheck_910_;
goto v_resetjp_891_;
}
v_resetjp_891_:
{
lean_object* v_snd_894_; lean_object* v_fst_895_; lean_object* v_fst_896_; lean_object* v_snd_897_; lean_object* v___x_898_; lean_object* v___x_899_; lean_object* v___x_900_; lean_object* v___x_901_; lean_object* v___x_902_; lean_object* v___x_903_; lean_object* v___x_905_; 
v_snd_894_ = lean_ctor_get(v_val_890_, 1);
lean_inc(v_snd_894_);
v_fst_895_ = lean_ctor_get(v_val_890_, 0);
lean_inc(v_fst_895_);
lean_dec(v_val_890_);
v_fst_896_ = lean_ctor_get(v_snd_894_, 0);
lean_inc(v_fst_896_);
v_snd_897_ = lean_ctor_get(v_snd_894_, 1);
lean_inc(v_snd_897_);
lean_dec(v_snd_894_);
v___x_898_ = ((lean_object*)(l___private_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical_0__Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkGate_congrThmOfGate___closed__0));
v___x_899_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkRefl___closed__6));
v___x_900_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0___closed__0));
v___x_901_ = l_Lean_Name_mkStr6(v___x_858_, v___x_859_, v___x_860_, v___x_898_, v___x_899_, v___x_900_);
v___x_902_ = l_Lean_mkConst(v___x_901_, v___x_861_);
v___x_903_ = l_Lean_mkApp9(v___x_902_, v_discrExpr_862_, v_lhsExpr_863_, v_rhsExpr_864_, v_a_875_, v_a_877_, v_a_879_, v_fst_895_, v_fst_896_, v_snd_897_);
if (v_isShared_893_ == 0)
{
lean_ctor_set(v___x_892_, 0, v___x_903_);
v___x_905_ = v___x_892_;
goto v_reusejp_904_;
}
else
{
lean_object* v_reuseFailAlloc_909_; 
v_reuseFailAlloc_909_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_909_, 0, v___x_903_);
v___x_905_ = v_reuseFailAlloc_909_;
goto v_reusejp_904_;
}
v_reusejp_904_:
{
lean_object* v___x_907_; 
if (v_isShared_888_ == 0)
{
lean_ctor_set(v___x_887_, 0, v___x_905_);
v___x_907_ = v___x_887_;
goto v_reusejp_906_;
}
else
{
lean_object* v_reuseFailAlloc_908_; 
v_reuseFailAlloc_908_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_908_, 0, v___x_905_);
v___x_907_ = v_reuseFailAlloc_908_;
goto v_reusejp_906_;
}
v_reusejp_906_:
{
return v___x_907_;
}
}
}
}
else
{
lean_object* v___x_911_; lean_object* v___x_913_; 
lean_dec(v___x_889_);
lean_dec(v_a_879_);
lean_dec(v_a_877_);
lean_dec(v_a_875_);
lean_dec_ref(v_rhsExpr_864_);
lean_dec_ref(v_lhsExpr_863_);
lean_dec_ref(v_discrExpr_862_);
lean_dec(v___x_861_);
lean_dec_ref(v___x_860_);
lean_dec_ref(v___x_859_);
lean_dec_ref(v___x_858_);
v___x_911_ = lean_box(0);
if (v_isShared_888_ == 0)
{
lean_ctor_set(v___x_887_, 0, v___x_911_);
v___x_913_ = v___x_887_;
goto v_reusejp_912_;
}
else
{
lean_object* v_reuseFailAlloc_914_; 
v_reuseFailAlloc_914_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_914_, 0, v___x_911_);
v___x_913_ = v_reuseFailAlloc_914_;
goto v_reusejp_912_;
}
v_reusejp_912_:
{
return v___x_913_;
}
}
}
}
else
{
lean_dec(v_a_883_);
lean_dec(v_a_881_);
lean_dec(v_a_879_);
lean_dec(v_a_877_);
lean_dec(v_a_875_);
lean_dec_ref(v_rhsExpr_864_);
lean_dec_ref(v_lhsExpr_863_);
lean_dec_ref(v_discrExpr_862_);
lean_dec(v___x_861_);
lean_dec_ref(v___x_860_);
lean_dec_ref(v___x_859_);
lean_dec_ref(v___x_858_);
return v___x_884_;
}
}
else
{
lean_dec(v_a_881_);
lean_dec(v_a_879_);
lean_dec(v_a_877_);
lean_dec(v_a_875_);
lean_dec_ref(v_rhsExpr_864_);
lean_dec_ref(v_lhsExpr_863_);
lean_dec_ref(v_discrExpr_862_);
lean_dec(v___x_861_);
lean_dec_ref(v___x_860_);
lean_dec_ref(v___x_859_);
lean_dec_ref(v___x_858_);
lean_dec_ref(v_rhs_857_);
return v___x_882_;
}
}
else
{
lean_dec(v_a_879_);
lean_dec(v_a_877_);
lean_dec(v_a_875_);
lean_dec_ref(v_rhsExpr_864_);
lean_dec_ref(v_lhsExpr_863_);
lean_dec_ref(v_discrExpr_862_);
lean_dec(v___x_861_);
lean_dec_ref(v___x_860_);
lean_dec_ref(v___x_859_);
lean_dec_ref(v___x_858_);
lean_dec_ref(v_rhs_857_);
lean_dec_ref(v_lhs_856_);
return v___x_880_;
}
}
else
{
lean_object* v_a_916_; lean_object* v___x_918_; uint8_t v_isShared_919_; uint8_t v_isSharedCheck_923_; 
lean_dec(v_a_877_);
lean_dec(v_a_875_);
lean_dec_ref(v_rhsExpr_864_);
lean_dec_ref(v_lhsExpr_863_);
lean_dec_ref(v_discrExpr_862_);
lean_dec(v___x_861_);
lean_dec_ref(v___x_860_);
lean_dec_ref(v___x_859_);
lean_dec_ref(v___x_858_);
lean_dec_ref(v_rhs_857_);
lean_dec_ref(v_lhs_856_);
lean_dec_ref(v_discr_855_);
v_a_916_ = lean_ctor_get(v___x_878_, 0);
v_isSharedCheck_923_ = !lean_is_exclusive(v___x_878_);
if (v_isSharedCheck_923_ == 0)
{
v___x_918_ = v___x_878_;
v_isShared_919_ = v_isSharedCheck_923_;
goto v_resetjp_917_;
}
else
{
lean_inc(v_a_916_);
lean_dec(v___x_878_);
v___x_918_ = lean_box(0);
v_isShared_919_ = v_isSharedCheck_923_;
goto v_resetjp_917_;
}
v_resetjp_917_:
{
lean_object* v___x_921_; 
if (v_isShared_919_ == 0)
{
v___x_921_ = v___x_918_;
goto v_reusejp_920_;
}
else
{
lean_object* v_reuseFailAlloc_922_; 
v_reuseFailAlloc_922_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_922_, 0, v_a_916_);
v___x_921_ = v_reuseFailAlloc_922_;
goto v_reusejp_920_;
}
v_reusejp_920_:
{
return v___x_921_;
}
}
}
}
else
{
lean_object* v_a_924_; lean_object* v___x_926_; uint8_t v_isShared_927_; uint8_t v_isSharedCheck_931_; 
lean_dec(v_a_875_);
lean_dec_ref(v_rhsExpr_864_);
lean_dec_ref(v_lhsExpr_863_);
lean_dec_ref(v_discrExpr_862_);
lean_dec(v___x_861_);
lean_dec_ref(v___x_860_);
lean_dec_ref(v___x_859_);
lean_dec_ref(v___x_858_);
lean_dec_ref(v_rhs_857_);
lean_dec_ref(v_lhs_856_);
lean_dec_ref(v_discr_855_);
lean_dec_ref(v_expr_854_);
v_a_924_ = lean_ctor_get(v___x_876_, 0);
v_isSharedCheck_931_ = !lean_is_exclusive(v___x_876_);
if (v_isSharedCheck_931_ == 0)
{
v___x_926_ = v___x_876_;
v_isShared_927_ = v_isSharedCheck_931_;
goto v_resetjp_925_;
}
else
{
lean_inc(v_a_924_);
lean_dec(v___x_876_);
v___x_926_ = lean_box(0);
v_isShared_927_ = v_isSharedCheck_931_;
goto v_resetjp_925_;
}
v_resetjp_925_:
{
lean_object* v___x_929_; 
if (v_isShared_927_ == 0)
{
v___x_929_ = v___x_926_;
goto v_reusejp_928_;
}
else
{
lean_object* v_reuseFailAlloc_930_; 
v_reuseFailAlloc_930_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_930_, 0, v_a_924_);
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
lean_object* v_a_932_; lean_object* v___x_934_; uint8_t v_isShared_935_; uint8_t v_isSharedCheck_939_; 
lean_dec_ref(v_rhsExpr_864_);
lean_dec_ref(v_lhsExpr_863_);
lean_dec_ref(v_discrExpr_862_);
lean_dec(v___x_861_);
lean_dec_ref(v___x_860_);
lean_dec_ref(v___x_859_);
lean_dec_ref(v___x_858_);
lean_dec_ref(v_rhs_857_);
lean_dec_ref(v_lhs_856_);
lean_dec_ref(v_discr_855_);
lean_dec_ref(v_expr_854_);
lean_dec_ref(v_expr_853_);
v_a_932_ = lean_ctor_get(v___x_874_, 0);
v_isSharedCheck_939_ = !lean_is_exclusive(v___x_874_);
if (v_isSharedCheck_939_ == 0)
{
v___x_934_ = v___x_874_;
v_isShared_935_ = v_isSharedCheck_939_;
goto v_resetjp_933_;
}
else
{
lean_inc(v_a_932_);
lean_dec(v___x_874_);
v___x_934_ = lean_box(0);
v_isShared_935_ = v_isSharedCheck_939_;
goto v_resetjp_933_;
}
v_resetjp_933_:
{
lean_object* v___x_937_; 
if (v_isShared_935_ == 0)
{
v___x_937_ = v___x_934_;
goto v_reusejp_936_;
}
else
{
lean_object* v_reuseFailAlloc_938_; 
v_reuseFailAlloc_938_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_938_, 0, v_a_932_);
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
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0___boxed(lean_object** _args){
lean_object* v_expr_940_ = _args[0];
lean_object* v_expr_941_ = _args[1];
lean_object* v_expr_942_ = _args[2];
lean_object* v_discr_943_ = _args[3];
lean_object* v_lhs_944_ = _args[4];
lean_object* v_rhs_945_ = _args[5];
lean_object* v___x_946_ = _args[6];
lean_object* v___x_947_ = _args[7];
lean_object* v___x_948_ = _args[8];
lean_object* v___x_949_ = _args[9];
lean_object* v_discrExpr_950_ = _args[10];
lean_object* v_lhsExpr_951_ = _args[11];
lean_object* v_rhsExpr_952_ = _args[12];
lean_object* v___y_953_ = _args[13];
lean_object* v___y_954_ = _args[14];
lean_object* v___y_955_ = _args[15];
lean_object* v___y_956_ = _args[16];
lean_object* v___y_957_ = _args[17];
lean_object* v___y_958_ = _args[18];
lean_object* v___y_959_ = _args[19];
lean_object* v___y_960_ = _args[20];
lean_object* v___y_961_ = _args[21];
_start:
{
lean_object* v_res_962_; 
v_res_962_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0(v_expr_940_, v_expr_941_, v_expr_942_, v_discr_943_, v_lhs_944_, v_rhs_945_, v___x_946_, v___x_947_, v___x_948_, v___x_949_, v_discrExpr_950_, v_lhsExpr_951_, v_rhsExpr_952_, v___y_953_, v___y_954_, v___y_955_, v___y_956_, v___y_957_, v___y_958_, v___y_959_, v___y_960_);
lean_dec(v___y_960_);
lean_dec_ref(v___y_959_);
lean_dec(v___y_958_);
lean_dec_ref(v___y_957_);
lean_dec(v___y_956_);
lean_dec_ref(v___y_955_);
lean_dec(v___y_954_);
lean_dec_ref(v___y_953_);
return v_res_962_;
}
}
static lean_object* _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__2(void){
_start:
{
lean_object* v___x_970_; lean_object* v___x_971_; lean_object* v___x_972_; 
v___x_970_ = lean_box(0);
v___x_971_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__1));
v___x_972_ = l_Lean_mkConst(v___x_971_, v___x_970_);
return v___x_972_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg(lean_object* v_discr_973_, lean_object* v_lhs_974_, lean_object* v_rhs_975_, lean_object* v_discrExpr_976_, lean_object* v_lhsExpr_977_, lean_object* v_rhsExpr_978_, lean_object* v_origExpr_979_, lean_object* v_a_980_, lean_object* v_a_981_, lean_object* v_a_982_, lean_object* v_a_983_, lean_object* v_a_984_, lean_object* v_a_985_){
_start:
{
lean_object* v_bvExpr_987_; lean_object* v_expr_988_; lean_object* v_bvExpr_989_; lean_object* v_expr_990_; lean_object* v_bvExpr_991_; lean_object* v_expr_992_; lean_object* v___x_993_; lean_object* v___x_994_; lean_object* v___x_995_; lean_object* v___x_996_; lean_object* v___x_997_; lean_object* v___x_998_; lean_object* v___x_999_; lean_object* v___x_1000_; 
v_bvExpr_987_ = lean_ctor_get(v_discr_973_, 0);
lean_inc_ref(v_bvExpr_987_);
v_expr_988_ = lean_ctor_get(v_discr_973_, 3);
lean_inc_ref_n(v_expr_988_, 2);
v_bvExpr_989_ = lean_ctor_get(v_lhs_974_, 0);
lean_inc_ref(v_bvExpr_989_);
v_expr_990_ = lean_ctor_get(v_lhs_974_, 3);
lean_inc_ref_n(v_expr_990_, 2);
v_bvExpr_991_ = lean_ctor_get(v_rhs_975_, 0);
lean_inc_ref(v_bvExpr_991_);
v_expr_992_ = lean_ctor_get(v_rhs_975_, 3);
lean_inc_ref_n(v_expr_992_, 2);
v___x_993_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__0));
v___x_994_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__1));
v___x_995_ = ((lean_object*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkEvalExpr___closed__2));
v___x_996_ = lean_box(0);
v___x_997_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__2, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__2_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___closed__2);
v___x_998_ = lean_obj_once(&l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6, &l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6_once, _init_l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_ofPred___redArg___closed__6);
v___x_999_ = l_Lean_mkApp4(v___x_997_, v___x_998_, v_expr_988_, v_expr_990_, v_expr_992_);
v___x_1000_ = l_Lean_Meta_Sym_shareCommonInc(v___x_999_, v_a_980_, v_a_981_, v_a_982_, v_a_983_, v_a_984_, v_a_985_);
if (lean_obj_tag(v___x_1000_) == 0)
{
lean_object* v_a_1001_; lean_object* v___x_1003_; uint8_t v_isShared_1004_; uint8_t v_isSharedCheck_1011_; 
v_a_1001_ = lean_ctor_get(v___x_1000_, 0);
v_isSharedCheck_1011_ = !lean_is_exclusive(v___x_1000_);
if (v_isSharedCheck_1011_ == 0)
{
v___x_1003_ = v___x_1000_;
v_isShared_1004_ = v_isSharedCheck_1011_;
goto v_resetjp_1002_;
}
else
{
lean_inc(v_a_1001_);
lean_dec(v___x_1000_);
v___x_1003_ = lean_box(0);
v_isShared_1004_ = v_isSharedCheck_1011_;
goto v_resetjp_1002_;
}
v_resetjp_1002_:
{
lean_object* v___f_1005_; lean_object* v_boolExpr_1006_; lean_object* v___x_1007_; lean_object* v___x_1009_; 
v___f_1005_ = lean_alloc_closure((void*)(l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___lam__0___boxed), 22, 13);
lean_closure_set(v___f_1005_, 0, v_expr_988_);
lean_closure_set(v___f_1005_, 1, v_expr_990_);
lean_closure_set(v___f_1005_, 2, v_expr_992_);
lean_closure_set(v___f_1005_, 3, v_discr_973_);
lean_closure_set(v___f_1005_, 4, v_lhs_974_);
lean_closure_set(v___f_1005_, 5, v_rhs_975_);
lean_closure_set(v___f_1005_, 6, v___x_993_);
lean_closure_set(v___f_1005_, 7, v___x_994_);
lean_closure_set(v___f_1005_, 8, v___x_995_);
lean_closure_set(v___f_1005_, 9, v___x_996_);
lean_closure_set(v___f_1005_, 10, v_discrExpr_976_);
lean_closure_set(v___f_1005_, 11, v_lhsExpr_977_);
lean_closure_set(v___f_1005_, 12, v_rhsExpr_978_);
v_boolExpr_1006_ = lean_alloc_ctor(4, 3, 0);
lean_ctor_set(v_boolExpr_1006_, 0, v_bvExpr_987_);
lean_ctor_set(v_boolExpr_1006_, 1, v_bvExpr_989_);
lean_ctor_set(v_boolExpr_1006_, 2, v_bvExpr_991_);
v___x_1007_ = lean_alloc_ctor(0, 4, 0);
lean_ctor_set(v___x_1007_, 0, v_boolExpr_1006_);
lean_ctor_set(v___x_1007_, 1, v_origExpr_979_);
lean_ctor_set(v___x_1007_, 2, v___f_1005_);
lean_ctor_set(v___x_1007_, 3, v_a_1001_);
if (v_isShared_1004_ == 0)
{
lean_ctor_set(v___x_1003_, 0, v___x_1007_);
v___x_1009_ = v___x_1003_;
goto v_reusejp_1008_;
}
else
{
lean_object* v_reuseFailAlloc_1010_; 
v_reuseFailAlloc_1010_ = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1010_, 0, v___x_1007_);
v___x_1009_ = v_reuseFailAlloc_1010_;
goto v_reusejp_1008_;
}
v_reusejp_1008_:
{
return v___x_1009_;
}
}
}
else
{
lean_object* v_a_1012_; lean_object* v___x_1014_; uint8_t v_isShared_1015_; uint8_t v_isSharedCheck_1019_; 
lean_dec_ref(v_expr_992_);
lean_dec_ref(v_bvExpr_991_);
lean_dec_ref(v_expr_990_);
lean_dec_ref(v_bvExpr_989_);
lean_dec_ref(v_expr_988_);
lean_dec_ref(v_bvExpr_987_);
lean_dec_ref(v_origExpr_979_);
lean_dec_ref(v_rhsExpr_978_);
lean_dec_ref(v_lhsExpr_977_);
lean_dec_ref(v_discrExpr_976_);
lean_dec_ref(v_rhs_975_);
lean_dec_ref(v_lhs_974_);
lean_dec_ref(v_discr_973_);
v_a_1012_ = lean_ctor_get(v___x_1000_, 0);
v_isSharedCheck_1019_ = !lean_is_exclusive(v___x_1000_);
if (v_isSharedCheck_1019_ == 0)
{
v___x_1014_ = v___x_1000_;
v_isShared_1015_ = v_isSharedCheck_1019_;
goto v_resetjp_1013_;
}
else
{
lean_inc(v_a_1012_);
lean_dec(v___x_1000_);
v___x_1014_ = lean_box(0);
v_isShared_1015_ = v_isSharedCheck_1019_;
goto v_resetjp_1013_;
}
v_resetjp_1013_:
{
lean_object* v___x_1017_; 
if (v_isShared_1015_ == 0)
{
v___x_1017_ = v___x_1014_;
goto v_reusejp_1016_;
}
else
{
lean_object* v_reuseFailAlloc_1018_; 
v_reuseFailAlloc_1018_ = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(v_reuseFailAlloc_1018_, 0, v_a_1012_);
v___x_1017_ = v_reuseFailAlloc_1018_;
goto v_reusejp_1016_;
}
v_reusejp_1016_:
{
return v___x_1017_;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg___boxed(lean_object* v_discr_1020_, lean_object* v_lhs_1021_, lean_object* v_rhs_1022_, lean_object* v_discrExpr_1023_, lean_object* v_lhsExpr_1024_, lean_object* v_rhsExpr_1025_, lean_object* v_origExpr_1026_, lean_object* v_a_1027_, lean_object* v_a_1028_, lean_object* v_a_1029_, lean_object* v_a_1030_, lean_object* v_a_1031_, lean_object* v_a_1032_, lean_object* v_a_1033_){
_start:
{
lean_object* v_res_1034_; 
v_res_1034_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg(v_discr_1020_, v_lhs_1021_, v_rhs_1022_, v_discrExpr_1023_, v_lhsExpr_1024_, v_rhsExpr_1025_, v_origExpr_1026_, v_a_1027_, v_a_1028_, v_a_1029_, v_a_1030_, v_a_1031_, v_a_1032_);
lean_dec(v_a_1032_);
lean_dec_ref(v_a_1031_);
lean_dec(v_a_1030_);
lean_dec_ref(v_a_1029_);
lean_dec(v_a_1028_);
lean_dec_ref(v_a_1027_);
return v_res_1034_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte(lean_object* v_discr_1035_, lean_object* v_lhs_1036_, lean_object* v_rhs_1037_, lean_object* v_discrExpr_1038_, lean_object* v_lhsExpr_1039_, lean_object* v_rhsExpr_1040_, lean_object* v_origExpr_1041_, lean_object* v_a_1042_, lean_object* v_a_1043_, lean_object* v_a_1044_, lean_object* v_a_1045_, lean_object* v_a_1046_, lean_object* v_a_1047_, lean_object* v_a_1048_, lean_object* v_a_1049_){
_start:
{
lean_object* v___x_1051_; 
v___x_1051_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___redArg(v_discr_1035_, v_lhs_1036_, v_rhs_1037_, v_discrExpr_1038_, v_lhsExpr_1039_, v_rhsExpr_1040_, v_origExpr_1041_, v_a_1044_, v_a_1045_, v_a_1046_, v_a_1047_, v_a_1048_, v_a_1049_);
return v___x_1051_;
}
}
LEAN_EXPORT lean_object* l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte___boxed(lean_object* v_discr_1052_, lean_object* v_lhs_1053_, lean_object* v_rhs_1054_, lean_object* v_discrExpr_1055_, lean_object* v_lhsExpr_1056_, lean_object* v_rhsExpr_1057_, lean_object* v_origExpr_1058_, lean_object* v_a_1059_, lean_object* v_a_1060_, lean_object* v_a_1061_, lean_object* v_a_1062_, lean_object* v_a_1063_, lean_object* v_a_1064_, lean_object* v_a_1065_, lean_object* v_a_1066_, lean_object* v_a_1067_){
_start:
{
lean_object* v_res_1068_; 
v_res_1068_ = l_Lean_Meta_Tactic_BVDecide_ReifiedBVLogical_mkIte(v_discr_1052_, v_lhs_1053_, v_rhs_1054_, v_discrExpr_1055_, v_lhsExpr_1056_, v_rhsExpr_1057_, v_origExpr_1058_, v_a_1059_, v_a_1060_, v_a_1061_, v_a_1062_, v_a_1063_, v_a_1064_, v_a_1065_, v_a_1066_);
lean_dec(v_a_1066_);
lean_dec_ref(v_a_1065_);
lean_dec(v_a_1064_);
lean_dec_ref(v_a_1063_);
lean_dec(v_a_1062_);
lean_dec_ref(v_a_1061_);
lean_dec(v_a_1060_);
lean_dec_ref(v_a_1059_);
return v_res_1068_;
}
}
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(uint8_t builtin);
lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVPred(uint8_t builtin);
lean_object* runtime_initialize_Std_Tactic_BVDecide_Reflect(uint8_t builtin);
static bool _G_runtime_initialized = false;
LEAN_EXPORT lean_object* runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical(uint8_t builtin) {
lean_object * res;
if (_G_runtime_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_runtime_initialized = true;
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVPred(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Std_Tactic_BVDecide_Reflect(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
static bool _G_meta_initialized = false;
LEAN_EXPORT lean_object* meta_initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical(uint8_t builtin) {
lean_object * res;
if (_G_meta_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_meta_initialized = true;
return lean_io_result_mk_ok(lean_box(0));
}
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(uint8_t builtin);
lean_object* initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVPred(uint8_t builtin);
lean_object* initialize_Std_Tactic_BVDecide_Reflect(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Lean_Meta_Tactic_BVDecide_Reflect_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVPred(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Std_Tactic_BVDecide_Reflect(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = runtime_initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = meta_initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return initialize_Lean_Meta_Tactic_BVDecide_Reflect_ReifiedBVLogical(builtin);
}
#ifdef __cplusplus
}
#endif
