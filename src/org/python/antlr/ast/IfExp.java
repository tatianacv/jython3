// Autogenerated AST node
package org.python.antlr.ast;
import org.python.antlr.PythonTree;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.Token;
import java.io.DataOutputStream;
import java.io.IOException;

public class IfExp extends exprType {
    public exprType test;
    public exprType body;
    public exprType orelse;

    private final static String[] fields = new String[] {"test", "body",
                                                          "orelse"};
    public String[] get_fields() { return fields; }

    public IfExp(exprType test, exprType body, exprType orelse) {
        this.test = test;
        addChild(test);
        this.body = body;
        addChild(body);
        this.orelse = orelse;
        addChild(orelse);
    }

    public IfExp(Token token, exprType test, exprType body, exprType orelse) {
        super(token);
        this.test = test;
        addChild(test);
        this.body = body;
        addChild(body);
        this.orelse = orelse;
        addChild(orelse);
    }

    public IfExp(int ttype, Token token, exprType test, exprType body, exprType
    orelse) {
        super(ttype, token);
        this.test = test;
        addChild(test);
        this.body = body;
        addChild(body);
        this.orelse = orelse;
        addChild(orelse);
    }

    public IfExp(PythonTree tree, exprType test, exprType body, exprType
    orelse) {
        super(tree);
        this.test = test;
        addChild(test);
        this.body = body;
        addChild(body);
        this.orelse = orelse;
        addChild(orelse);
    }

    public String toString() {
        return "IfExp";
    }

    public String toStringTree() {
        StringBuffer sb = new StringBuffer("IfExp(");
        sb.append("test=");
        sb.append(dumpThis(test));
        sb.append(",");
        sb.append("body=");
        sb.append(dumpThis(body));
        sb.append(",");
        sb.append("orelse=");
        sb.append(dumpThis(orelse));
        sb.append(",");
        sb.append(")");
        return sb.toString();
    }

    public <R> R accept(VisitorIF<R> visitor) throws Exception {
        return visitor.visitIfExp(this);
    }

    public void traverse(VisitorIF visitor) throws Exception {
        if (test != null)
            test.accept(visitor);
        if (body != null)
            body.accept(visitor);
        if (orelse != null)
            orelse.accept(visitor);
    }

    public int getLineno() {
        return getLine();
    }

    public int getCol_offset() {
        return getCharPositionInLine();
    }

}
