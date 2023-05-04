// Autogenerated AST node
package org.python.antlr.ast;
import org.antlr.runtime.Token;
import org.python.antlr.PythonTree;
import org.python.antlr.adapter.AstAdapters;
import org.python.antlr.base.expr;
import org.python.core.ArgParser;
import org.python.core.Py;
import org.python.core.PyObject;
import org.python.core.PyUnicode;
import org.python.core.PyStringMap;
import org.python.core.PyType;
import org.python.expose.ExposedGet;
import org.python.expose.ExposedMethod;
import org.python.expose.ExposedNew;
import org.python.expose.ExposedSet;
import org.python.expose.ExposedType;

@ExposedType(name = "_ast.BinOp", base = expr.class)
public class BinOp extends expr {
public static final PyType TYPE = PyType.fromClass(BinOp.class);
    private expr left;
    public expr getInternalLeft() {
        return left;
    }
    @ExposedGet(name = "left")
    public PyObject getLeft() {
        return left;
    }
    @ExposedSet(name = "left")
    public void setLeft(PyObject left) {
        this.left = AstAdapters.py2expr(left);
    }

    private operatorType op;
    public operatorType getInternalOp() {
        return op;
    }
    @ExposedGet(name = "op")
    public PyObject getOp() {
        return AstAdapters.operator2py(op);
    }
    @ExposedSet(name = "op")
    public void setOp(PyObject op) {
        this.op = AstAdapters.py2operator(op);
    }

    private expr right;
    public expr getInternalRight() {
        return right;
    }
    @ExposedGet(name = "right")
    public PyObject getRight() {
        return right;
    }
    @ExposedSet(name = "right")
    public void setRight(PyObject right) {
        this.right = AstAdapters.py2expr(right);
    }


    private final static PyUnicode[] fields =
    new PyUnicode[] {new PyUnicode("left"), new PyUnicode("op"), new PyUnicode("right")};
    @ExposedGet(name = "_fields")
    public PyUnicode[] get_fields() { return fields; }

    private final static PyUnicode[] attributes =
    new PyUnicode[] {new PyUnicode("lineno"), new PyUnicode("col_offset")};
    @ExposedGet(name = "_attributes")
    public PyUnicode[] get_attributes() { return attributes; }

    public BinOp(PyType subType) {
        super(subType);
    }
    public BinOp() {
        this(TYPE);
    }
    @ExposedNew
    @ExposedMethod
    public void BinOp___init__(PyObject[] args, String[] keywords) {
        ArgParser ap = new ArgParser("BinOp", args, keywords, new String[]
            {"left", "op", "right", "lineno", "col_offset"}, 3, true);
        setLeft(ap.getPyObject(0, Py.None));
        setOp(ap.getPyObject(1, Py.None));
        setRight(ap.getPyObject(2, Py.None));
        int lin = ap.getInt(3, -1);
        if (lin != -1) {
            setLineno(lin);
        }

        int col = ap.getInt(4, -1);
        if (col != -1) {
            setLineno(col);
        }

    }

    public BinOp(PyObject left, PyObject op, PyObject right) {
        setLeft(left);
        setOp(op);
        setRight(right);
    }

    public BinOp(Token token, expr left, operatorType op, expr right) {
        super(token);
        this.left = left;
        addChild(left);
        this.op = op;
        this.right = right;
        addChild(right);
    }

    public BinOp(Integer ttype, Token token, expr left, operatorType op, expr right) {
        super(ttype, token);
        this.left = left;
        addChild(left);
        this.op = op;
        this.right = right;
        addChild(right);
    }

    public BinOp(PythonTree tree, expr left, operatorType op, expr right) {
        super(tree);
        this.left = left;
        addChild(left);
        this.op = op;
        this.right = right;
        addChild(right);
    }

    @ExposedGet(name = "repr")
    public String toString() {
        return "BinOp";
    }

    public String toStringTree() {
        StringBuffer sb = new StringBuffer("BinOp(");
        sb.append("left=");
        sb.append(dumpThis(left));
        sb.append(",");
        sb.append("op=");
        sb.append(dumpThis(op));
        sb.append(",");
        sb.append("right=");
        sb.append(dumpThis(right));
        sb.append(",");
        sb.append(")");
        return sb.toString();
    }

    public <R> R accept(VisitorIF<R> visitor) throws Exception {
        return visitor.visitBinOp(this);
    }

    public void traverse(VisitorIF<?> visitor) throws Exception {
        if (left != null)
            left.accept(visitor);
        if (right != null)
            right.accept(visitor);
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
