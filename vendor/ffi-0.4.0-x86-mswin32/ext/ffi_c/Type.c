#include <sys/param.h>
#include <sys/types.h>
#include <ruby.h>
#include <ffi.h>
#include "rbffi.h"
#include "compat.h"
#include "Types.h"
#include "Type.h"


typedef struct BuiltinType_ {
    Type type;
    char* name;
} BuiltinType;

static void builtin_type_free(BuiltinType *);

VALUE rbffi_TypeClass = Qnil;

static VALUE classBuiltinType = Qnil;

static VALUE
type_allocate(VALUE klass)
{
    Type* type;
    VALUE obj = Data_Make_Struct(klass, Type, NULL, -1, type);

    type->nativeType = -1;
    type->size = 0;
    type->alignment = 1;

    return obj;
}

static VALUE
type_initialize(VALUE self, VALUE value)
{
    Type* type;
    Type* other;

    Data_Get_Struct(self, Type, type);

    if (FIXNUM_P(value)) {
        type->nativeType = FIX2INT(value);
    } else if (rb_obj_is_kind_of(value, rbffi_TypeClass)) {
        Data_Get_Struct(value, Type, other);
        type->nativeType = other->nativeType;
        type->size = other->size;
        type->alignment = other->alignment;
    } else {
        rb_raise(rb_eArgError, "wrong type");
    }
    
    return self;
}

static VALUE
type_size(VALUE self)
{
    Type *type;

    Data_Get_Struct(self, Type, type);

    return INT2FIX(type->size);
}

static VALUE
type_alignment(VALUE self)
{
    Type *type;

    Data_Get_Struct(self, Type, type);

    return INT2FIX(type->alignment);
}

static VALUE
type_inspect(VALUE self)
{
    char buf[256];
    Type *type;

    Data_Get_Struct(self, Type, type);
    snprintf(buf, sizeof(buf), "#<FFI::Type:%p size=%d alignment=%d>", 
            type, type->size, type->alignment);

    return rb_str_new2(buf);
}

static VALUE
enum_allocate(VALUE klass)
{
    Type* type;
    VALUE obj;

    obj = Data_Make_Struct(klass, Type, NULL, -1, type);
    type->nativeType = NATIVE_ENUM;
    type->ffiType = &ffi_type_sint;
    type->size = ffi_type_sint.size;
    type->alignment = ffi_type_sint.alignment;

    return obj;
}

int
rbffi_Type_GetIntValue(VALUE type)
{
    if (rb_obj_is_kind_of(type, rbffi_TypeClass)) {
        Type* t;
        Data_Get_Struct(type, Type, t);
        return t->nativeType;
    } else {
        rb_raise(rb_eArgError, "Invalid type argument");
    }
}

static VALUE
builtin_type_new(VALUE klass, int nativeType, ffi_type* ffiType, const char* name)
{
    BuiltinType* type;
    VALUE obj = Data_Make_Struct(klass, BuiltinType, NULL, builtin_type_free, type);
    
    type->name = strdup(name);
    type->type.nativeType = nativeType;
    type->type.ffiType = ffiType;
    type->type.size = ffiType->size;
    type->type.alignment = ffiType->alignment;

    return obj;
}

static void
builtin_type_free(BuiltinType *type)
{
    free(type->name);
    xfree(type);
}

static VALUE
builtin_type_inspect(VALUE self)
{
    char buf[256];
    BuiltinType *type;

    Data_Get_Struct(self, BuiltinType, type);
    snprintf(buf, sizeof(buf), "#<FFI::Type::Builtin:%ssize=%d alignment=%d>",
            type->name, type->type.size, type->type.alignment);

    return rb_str_new2(buf);
}

void
rbffi_Type_Init(VALUE moduleFFI)
{
    VALUE moduleNativeType;
    VALUE classType = rbffi_TypeClass = rb_define_class_under(moduleFFI, "Type", rb_cObject);
    VALUE classEnum =  rb_define_class_under(moduleFFI, "Enum", classType);
    classBuiltinType = rb_define_class_under(rbffi_TypeClass, "Builtin", rbffi_TypeClass);
    moduleNativeType = rb_define_module_under(moduleFFI, "NativeType");

    rb_global_variable(&rbffi_TypeClass);
    rb_global_variable(&classBuiltinType);
    rb_global_variable(&moduleNativeType);

    rb_define_alloc_func(classType, type_allocate);
    rb_define_method(classType, "initialize", type_initialize, 1);
    rb_define_method(classType, "size", type_size, 0);
    rb_define_method(classType, "alignment", type_alignment, 0);
    rb_define_method(classBuiltinType, "inspect", type_inspect, 0);

    // Make Type::Builtin non-allocatable
    rb_undef_method(CLASS_OF(classBuiltinType), "new");
    rb_define_method(classBuiltinType, "inspect", builtin_type_inspect, 0);

    rb_define_alloc_func(classEnum, enum_allocate);

    rb_global_variable(&rbffi_TypeClass);
    rb_global_variable(&classBuiltinType);

    // Define all the builtin types
    #define T(x, ffiType) do { \
        VALUE t = Qnil; \
        rb_define_const(classType, #x, t = builtin_type_new(classBuiltinType, NATIVE_##x, ffiType, #x)); \
        rb_define_const(moduleNativeType, #x, t); \
        rb_define_const(moduleFFI, "TYPE_" #x, t); \
    } while(0)

    T(VOID, &ffi_type_void);
    T(INT8, &ffi_type_sint8);
    T(UINT8, &ffi_type_uint8);
    T(INT16, &ffi_type_sint16);
    T(UINT16, &ffi_type_uint16);
    T(INT32, &ffi_type_sint32);
    T(UINT32, &ffi_type_uint32);
    T(INT64, &ffi_type_sint64);
    T(UINT64, &ffi_type_uint64);
    T(FLOAT32, &ffi_type_float);
    T(FLOAT64, &ffi_type_double);
    T(POINTER, &ffi_type_pointer);
    T(STRING, &ffi_type_pointer);
    T(RBXSTRING, &ffi_type_pointer);
    T(BUFFER_IN, &ffi_type_pointer);
    T(BUFFER_OUT, &ffi_type_pointer);
    T(BUFFER_INOUT, &ffi_type_pointer);
    T(ENUM, &ffi_type_sint);
    T(BOOL, &ffi_type_sint);


    T(CHAR_ARRAY, &ffi_type_void);
    T(VARARGS, &ffi_type_void);
    

    if (sizeof(long) == 4) {
        VALUE t = Qnil;
        rb_define_const(classType, "LONG", t = builtin_type_new(classBuiltinType, NATIVE_INT32, &ffi_type_slong, "LONG"));
        rb_define_const(moduleNativeType, "LONG", t);
        rb_define_const(moduleFFI, "TYPE_LONG", t);
        rb_define_const(classType, "ULONG", t = builtin_type_new(classBuiltinType, NATIVE_UINT32, &ffi_type_slong, "ULONG"));
        rb_define_const(moduleNativeType, "ULONG", t);
        rb_define_const(moduleFFI, "TYPE_ULONG", t);
    } else {
        VALUE t = Qnil;
        rb_define_const(classType, "LONG", t = builtin_type_new(classBuiltinType, NATIVE_INT64, &ffi_type_slong, "LONG"));
        rb_define_const(moduleNativeType, "LONG", t);
        rb_define_const(moduleFFI, "TYPE_LONG", t);
        rb_define_const(classType, "ULONG", t = builtin_type_new(classBuiltinType, NATIVE_UINT64, &ffi_type_slong, "ULONG"));
        rb_define_const(moduleNativeType, "ULONG", t);
        rb_define_const(moduleFFI, "TYPE_ULONG", t);
    }
}
