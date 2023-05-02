// Autogenerated AST node
package org.python.antlr.ast;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.Token;
import org.python.antlr.AST;
import org.python.antlr.PythonTree;
import org.python.antlr.adapter.AstAdapters;
import org.python.antlr.base.excepthandler;
import org.python.antlr.base.expr;
import org.python.antlr.base.mod;
import org.python.antlr.base.slice;
import org.python.antlr.base.stmt;
import org.python.core.ArgParser;
import org.python.core.AstList;
import org.python.core.Py;
import org.python.core.PyObject;
import org.python.core.PyUnicode;
import org.python.core.PyStringMap;
import org.python.core.PyType;
import org.python.core.Visitproc;
import org.python.expose.ExposedGet;
import org.python.expose.ExposedMethod;
import org.python.expose.ExposedNew;
import org.python.expose.ExposedSet;
import org.python.expose.ExposedType;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.ArrayList;

@ExposedType(name = "_ast.DictComp", base = expr.class)
public class DictComp extends expr {
public static final PyType TYPE = PyType.fromClass(DictComp.class);
    private expr key;
    public expr getInternalKey() {
        return key;
    }
    @ExposedGet(name = "key")
    public PyObject getKey() {
        return key;
    }
    @ExposedSet(name = "key")
    public void setKey(PyObject key) {
        this.key = AstAdapters.py2expr(key);
    }

    private expr value;
    public expr getInternalValue() {
        return value;
    }
    @ExposedGet(name = "value")
    public PyObject getValue() {
        return value;
    }
    @ExposedSet(name = "value")
    public void setValue(PyObject value) {
        this.value = AstAdapters.py2expr(value);
    }

    private java.util.List<comprehension> generators;
    public java.util.List<comprehension> getInternalGenerators() {
        return generators;
    }
    @ExposedGet(name = "generators")
    public PyObject getGenerators() {
        return new AstList(generators, AstAdapters.comprehensionAdapter);
    }
    @ExposedSet(name = "generators")
    public void setGenerators(PyObject generators) {
        this.generators = AstAdapters.py2comprehensionList(generators);
    }


    private final static PyUnicode[] fields =
    new PyUnicode[] {new PyUnicode("key"), new PyUnicode("value"), new PyUnicode("generators")};
    @ExposedGet(name = "_fields")
    public PyUnicode[] get_fields() { return fields; }

    private final static PyUnicode[] attributes =
    new PyUnicode[] {new PyUnicode("lineno"), new PyUnicode("col_offset")};
    @ExposedGet(name = "_attributes")
    public PyUnicode[] get_attributes() { return attributes; }

    public DictComp(PyType subType) {
        super(subType);
    }
    public DictComp() {
        this(TYPE);
    }
    @ExposedNew
    @ExposedMethod
    public void DictComp___init__(PyObject[] args, String[] keywords) {
        ArgParser ap = new ArgParser("DictComp", args, keywords, new String[]
            {"key", "value", "generators", "lineno", "col_offset"}, 3, true);
        setKey(ap.getPyObject(0, Py.None));
        setValue(ap.getPyObject(1, Py.None));
        setGenerators(ap.getPyObject(2, Py.None));
        int lin = ap.getInt(3, -1);
        if (lin != -1) {
            setLineno(lin);
        }

        int col = ap.getInt(4, -1);
        if (col != -1) {
            setLineno(col);
        }

    }

    public DictComp(PyObject key, PyObject value, PyObject generators) {
        setKey(key);
        setValue(value);
        setGenerators(generators);
    }

    public DictComp(Token token, expr key, expr value, java.util.List<comprehension> generators) {
        super(token);
        this.key = key;
        addChild(key);
        this.value = value;
        addChild(value);
        this.generators = generators;
        if (generators == null) {
            this.generators = new ArrayList<comprehension>();
        }
        for(PythonTree t : this.generators) {
            addChild(t);
        }
    }

    public DictComp(Integer ttype, Token token, expr key, expr value, java.util.List<comprehension>
    generators) {
        super(ttype, token);
        this.key = key;
        addChild(key);
        this.value = value;
        addChild(value);
        this.generators = generators;
        if (generators == null) {
            this.generators = new ArrayList<comprehension>();
        }
        for(PythonTree t : this.generators) {
            addChild(t);
        }
    }

    public DictComp(PythonTree tree, expr key, expr value, java.util.List<comprehension>
    generators) {
        super(tree);
        this.key = key;
        addChild(key);
        this.value = value;
        addChild(value);
        this.generators = generators;
        if (generators == null) {
            this.generators = new ArrayList<comprehension>();
        }
        for(PythonTree t : this.generators) {
            addChild(t);
        }
    }

    @ExposedGet(name = "repr")
    public String toString() {
        return "DictComp";
    }

    public String toStringTree() {
        StringBuffer sb = new StringBuffer("DictComp(");
        sb.append("key=");
        sb.append(dumpThis(key));
        sb.append(",");
        sb.append("value=");
        sb.append(dumpThis(value));
        sb.append(",");
        sb.append("generators=");
        sb.append(dumpThis(generators));
        sb.append(",");
        sb.append(")");
        return sb.toString();
    }

    public <R> R accept(VisitorIF<R> visitor) throws Exception {
        return visitor.visitDictComp(this);
    }

    public void traverse(VisitorIF<?> visitor) throws Exception {
        if (key != null)
            key.accept(visitor);
        if (value != null)
            value.accept(visitor);
        if (generators != null) {
            for (PythonTree t : generators) {
                if (t != null)
                    t.accept(visitor);
            }
        }
    }

    public PyObject __dict__;

    @Override
    public PyObject fastGetDict() {
        ensureDict();
        return __dict__;
    }

    @ExposedGet(name = "__dict__")
    public PyObject getDict() {
        return fastGetDict();
    }

    private void ensureDict() {
        if (__dict__ == null) {
            __dict__ = new PyStringMap();
        }
    }

    private int lineno = -1;
    @ExposedGet(name = "lineno")
    public int getLineno() {
        if (lineno != -1) {
            return lineno;
        }
        return getLine();
    }

    @ExposedSet(name = "lineno")
    public void setLineno(int num) {
        lineno = num;
    }

    private int col_offset = -1;
    @ExposedGet(name = "col_offset")
    public int getCol_offset() {
        if (col_offset != -1) {
            return col_offset;
        }
        return getCharPositionInLine();
    }

    @ExposedSet(name = "col_offset")
    public void setCol_offset(int num) {
        col_offset = num;
    }

}
