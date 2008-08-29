// Autogenerated AST node
package org.python.antlr.ast;
import org.python.antlr.PythonTree;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.Token;
import java.io.DataOutputStream;
import java.io.IOException;

public class If extends stmtType {
    public exprType test;
    public stmtType[] body;
    public stmtType[] orelse;

    public static final String[] _fields = new String[]
    {"test","body","orelse"};

    public If(Token token, exprType test, stmtType[] body, stmtType[] orelse) {
        super(token);
        this.test = test;
        addChild(test);
        this.body = body;
        if (body != null) {
            for(int ibody=0;ibody<body.length;ibody++) {
                addChild(body[ibody]);
            }
        }
        this.orelse = orelse;
        if (orelse != null) {
            for(int iorelse=0;iorelse<orelse.length;iorelse++) {
                addChild(orelse[iorelse]);
            }
        }
    }

    public If(int ttype, Token token, exprType test, stmtType[] body,
    stmtType[] orelse) {
        super(ttype, token);
        this.test = test;
        addChild(test);
        this.body = body;
        if (body != null) {
            for(int ibody=0;ibody<body.length;ibody++) {
                addChild(body[ibody]);
            }
        }
        this.orelse = orelse;
        if (orelse != null) {
            for(int iorelse=0;iorelse<orelse.length;iorelse++) {
                addChild(orelse[iorelse]);
            }
        }
    }

    public If(PythonTree tree, exprType test, stmtType[] body, stmtType[]
    orelse) {
        super(tree);
        this.test = test;
        addChild(test);
        this.body = body;
        if (body != null) {
            for(int ibody=0;ibody<body.length;ibody++) {
                addChild(body[ibody]);
            }
        }
        this.orelse = orelse;
        if (orelse != null) {
            for(int iorelse=0;iorelse<orelse.length;iorelse++) {
                addChild(orelse[iorelse]);
            }
        }
    }

    public String toString() {
        return "If";
    }

    public String toStringTree() {
        StringBuffer sb = new StringBuffer("If(");
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
        return visitor.visitIf(this);
    }

    public void traverse(VisitorIF visitor) throws Exception {
        if (test != null)
            test.accept(visitor);
        if (body != null) {
            for (int i = 0; i < body.length; i++) {
                if (body[i] != null)
                    body[i].accept(visitor);
            }
        }
        if (orelse != null) {
            for (int i = 0; i < orelse.length; i++) {
                if (orelse[i] != null)
                    orelse[i].accept(visitor);
            }
        }
    }

    public int getLineno() {
        return getLine();
    }

    public int getCol_offset() {
        return getCharPositionInLine();
    }

}
