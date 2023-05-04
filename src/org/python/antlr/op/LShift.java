// Autogenerated AST node
package org.python.antlr.op;

import org.python.antlr.base.operator;
import org.python.antlr.PythonTree;
import org.python.core.Py;
import org.python.core.PyObject;
import org.python.core.PyUnicode;
import org.python.core.PyType;
import org.python.expose.ExposedGet;
import org.python.expose.ExposedMethod;
import org.python.expose.ExposedNew;
import org.python.expose.ExposedType;

@ExposedType(name = "_ast.LShift", base = operator.class)
public class LShift extends PythonTree {
    public static final PyType TYPE = PyType.fromClass(LShift.class);

public LShift() {
}

public LShift(PyType subType) {
    super(subType);
}

@ExposedNew
@ExposedMethod
public void LShift___init__(PyObject[] args, String[] keywords) {}

    private final static PyUnicode[] fields = new PyUnicode[0];
    @ExposedGet(name = "_fields")
    public PyUnicode[] get_fields() { return fields; }

    private final static PyUnicode[] attributes = new PyUnicode[0];
    @ExposedGet(name = "_attributes")
    public PyUnicode[] get_attributes() { return attributes; }

    @ExposedMethod
    public PyObject __int__() {
        return LShift___int__();
    }

    final PyObject LShift___int__() {
        return Py.newInteger(8);
    }

}
