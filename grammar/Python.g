/*
 [The 'BSD licence']
 Copyright (c) 2004 Terence Parr and Loring Craymer
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/** Python 3.5.1 Grammar
 *
 *  Terence Parr and Loring Craymer
 *  February 2004
 *
 *  Converted to ANTLR v3 November 2005 by Terence Parr.
 *
 *  This grammar was derived automatically from the Python 2.3.3
 *  parser grammar to get a syntactically correct ANTLR grammar
 *  for Python.  Then Terence hand tweaked it to be semantically
 *  correct; i.e., removed lookahead issues etc...  It is LL(1)
 *  except for the (sometimes optional) trailing commas and semi-colons.
 *  It needs two symbols of lookahead in this case.
 *
 *  Starting with Loring's preliminary lexer for Python, I modified it
 *  to do my version of the whole nasty INDENT/DEDENT issue just so I
 *  could understand the problem better.  This grammar requires
 *  PythonTokenStream.java to work.  Also I used some rules from the
 *  semi-formal grammar on the web for Python (automatically
 *  translated to ANTLR format by an ANTLR grammar, naturally <grin>).
 *  The lexical rules for python are particularly nasty and it took me
 *  a long time to get it 'right'; i.e., think about it in the proper
 *  way.  Resist changing the lexer unless you've used ANTLR a lot. ;)
 *
 *  I (Terence) tested this by running it on the jython-2.1/Lib
 *  directory of 40k lines of Python.
 *
 *  REQUIRES ANTLR v3
 *
 *
 *  Updated the original parser for Python 2.5 features. The parser has been
 *  altered to produce an AST - the AST work started from tne newcompiler
 *  grammar from Jim Baker.  The current parsing and compiling strategy looks
 *  like this:
 *
 *  Python source->Python.g->AST (org/python/parser/ast/*)->CodeCompiler(ASM)->.class
 *  May 2016 Modified by Isaiah Peng to match Python 3.5.1 syntax
 */

grammar Python;
options {
    ASTLabelType=PythonTree;
    output=AST;
}

tokens {
    INDENT;
    DEDENT;
    TRAILBACKSLASH; //For dangling backslashes when partial parsing.
}

@header {
package org.python.antlr;

import org.antlr.runtime.CommonToken;

import org.python.antlr.ParseException;
import org.python.antlr.PythonTree;
import org.python.antlr.ast.alias;
import org.python.antlr.ast.arg;
import org.python.antlr.ast.arguments;
import org.python.antlr.ast.Assert;
import org.python.antlr.ast.Assign;
import org.python.antlr.ast.AsyncFor;
import org.python.antlr.ast.AsyncFunctionDef;
import org.python.antlr.ast.AsyncWith;
import org.python.antlr.ast.Attribute;
import org.python.antlr.ast.AugAssign;
import org.python.antlr.ast.Await;
import org.python.antlr.ast.BinOp;
import org.python.antlr.ast.BoolOp;
import org.python.antlr.ast.boolopType;
import org.python.antlr.ast.Break;
import org.python.antlr.ast.Bytes;
import org.python.antlr.ast.Call;
import org.python.antlr.ast.ClassDef;
import org.python.antlr.ast.cmpopType;
import org.python.antlr.ast.Compare;
import org.python.antlr.ast.comprehension;
import org.python.antlr.ast.Context;
import org.python.antlr.ast.Continue;
import org.python.antlr.ast.Delete;
import org.python.antlr.ast.Dict;
import org.python.antlr.ast.DictComp;
import org.python.antlr.ast.Ellipsis;
import org.python.antlr.ast.ErrorMod;
import org.python.antlr.ast.ExceptHandler;
import org.python.antlr.ast.Expr;
import org.python.antlr.ast.Expression;
import org.python.antlr.ast.expr_contextType;
import org.python.antlr.ast.ExtSlice;
import org.python.antlr.ast.For;
import org.python.antlr.ast.FunctionDef;
import org.python.antlr.ast.GeneratorExp;
import org.python.antlr.ast.Global;
import org.python.antlr.ast.If;
import org.python.antlr.ast.IfExp;
import org.python.antlr.ast.Import;
import org.python.antlr.ast.ImportFrom;
import org.python.antlr.ast.Index;
import org.python.antlr.ast.Interactive;
import org.python.antlr.ast.keyword;
import org.python.antlr.ast.ListComp;
import org.python.antlr.ast.Lambda;
import org.python.antlr.ast.Module;
import org.python.antlr.ast.Name;
import org.python.antlr.ast.NameConstant;
import org.python.antlr.ast.Nonlocal;
import org.python.antlr.ast.Num;
import org.python.antlr.ast.operatorType;
import org.python.antlr.ast.Pass;
import org.python.antlr.ast.Raise;
import org.python.antlr.ast.Return;
import org.python.antlr.ast.Set;
import org.python.antlr.ast.SetComp;
import org.python.antlr.ast.Slice;
import org.python.antlr.ast.Starred;
import org.python.antlr.ast.Str;
import org.python.antlr.ast.Subscript;
import org.python.antlr.ast.TryExcept;
import org.python.antlr.ast.TryFinally;
import org.python.antlr.ast.Tuple;
import org.python.antlr.ast.unaryopType;
import org.python.antlr.ast.UnaryOp;
import org.python.antlr.ast.While;
import org.python.antlr.ast.With;
import org.python.antlr.ast.withitem;
import org.python.antlr.ast.Yield;
import org.python.antlr.ast.YieldFrom;
import org.python.antlr.base.excepthandler;
import org.python.antlr.base.expr;
import org.python.antlr.base.mod;
import org.python.antlr.base.slice;
import org.python.antlr.base.stmt;
import org.python.core.Py;
import org.python.core.PyObject;
import org.python.core.PyUnicode;

import java.math.BigInteger;
import java.util.Collections;
import java.util.Iterator;
import java.util.ListIterator;
}

@members {
    private ErrorHandler errorHandler;

    private GrammarActions actions = new GrammarActions();

    private String encoding;

    //Use to switch between python2 and python3 semantics.
    //true is python3, false is python2.
    private boolean python3 = true;

    private boolean printFunction = python3;
    private boolean unicodeLiterals = python3;

    public void setErrorHandler(ErrorHandler eh) {
        this.errorHandler = eh;
        actions.setErrorHandler(eh);
    }

    protected Object recoverFromMismatchedToken(IntStream input, int ttype, BitSet follow)
        throws RecognitionException {

        Object o = errorHandler.recoverFromMismatchedToken(this, input, ttype, follow);
        if (o != null) {
            return o;
        }
        return super.recoverFromMismatchedToken(input, ttype, follow);
    }

    public PythonParser(TokenStream input, String encoding) {
        this(input);
        this.encoding = encoding;
    }

    @Override
    public void reportError(RecognitionException e) {
      // Update syntax error count and output error.
      super.reportError(e);
      errorHandler.reportError(this, e);
    }

    @Override
    public void displayRecognitionError(String[] tokenNames, RecognitionException e) {
        //Do nothing. We will handle error display elsewhere.
    }
}

@rulecatch {
catch (RecognitionException re) {
    reportError(re);
    errorHandler.recover(this, input,re);
    retval.tree = (PythonTree)adaptor.errorNode(input, retval.start, input.LT(-1), re);
}
}

@lexer::header {
package org.python.antlr;
}

@lexer::members {
/** Handles context-sensitive lexing of implicit line joining such as
 *  the case where newline is ignored in cases like this:
 *  a = [3,
 *       4]
 */
int implicitLineJoiningLevel = 0;
int startPos=-1;

//For use in partial parsing.
public boolean eofWhileNested = false;
public boolean partial = false;
public boolean single = false;

//If you want to use another error recovery mechanism change this
//and the same one in the parser.
private ErrorHandler errorHandler;

    public void setErrorHandler(ErrorHandler eh) {
        this.errorHandler = eh;
    }

    /**
     *  Taken directly from antlr's Lexer.java -- needs to be re-integrated every time
     *  we upgrade from Antlr (need to consider a Lexer subclass, though the issue would
     *  remain).
     */
    public Token nextToken() {
        startPos = getCharPositionInLine();
        while (true) {
            state.token = null;
            state.channel = Token.DEFAULT_CHANNEL;
            state.tokenStartCharIndex = input.index();
            state.tokenStartCharPositionInLine = input.getCharPositionInLine();
            state.tokenStartLine = input.getLine();
            state.text = null;
            if ( input.LA(1)==CharStream.EOF ) {
                if (implicitLineJoiningLevel > 0) {
                    eofWhileNested = true;
                }
                return getEOFToken();
            }
            try {
                mTokens();
                if ( state.token==null ) {
                    emit();
                }
                else if ( state.token==Token.SKIP_TOKEN ) {
                    continue;
                }
                return state.token;
            } catch (NoViableAltException nva) {
                reportError(nva);
                errorHandler.recover(this, nva); // throw out current char and try again
            } catch (FailedPredicateException fp) {
                //XXX: added this for failed STRINGPART -- the FailedPredicateException
                //     hides a NoViableAltException.  This should be the only
                //     FailedPredicateException that gets thrown by the lexer.
                reportError(fp);
                errorHandler.recover(this, fp); // throw out current char and try again
            } catch (RecognitionException re) {
                reportError(re);
                // match() routine has already called recover()
            }
        }
    }

    public Token getEOFToken() {
        Token eof = new CommonToken(input,Token.EOF,
            Token.DEFAULT_CHANNEL,
            input.index(),input.index());
        eof.setLine(getLine());
        eof.setCharPositionInLine(getCharPositionInLine());
        return eof;
    }

    @Override
    public void displayRecognitionError(String[] tokenNames, RecognitionException e) {
        //Do nothing. We will handle error display elsewhere.
    }

}

//START OF PARSER RULES

//single_input: NEWLINE | simple_stmt | compound_stmt NEWLINE
single_input
@init {
    mod mtype = null;
}
@after {
    $single_input.tree = mtype;
}
    : NEWLINE* EOF
      {
        mtype = new Interactive($single_input.start, new ArrayList<stmt>());
      }
    | simple_stmt NEWLINE* EOF
      {
        mtype = new Interactive($single_input.start, actions.castStmts($simple_stmt.stypes));
      }
    | compound_stmt NEWLINE+ EOF
      {
        mtype = new Interactive($single_input.start, actions.castStmts($compound_stmt.tree));
      }
    ;
    //XXX: this block is duplicated in three places, how to extract?
    catch [RecognitionException re] {
        reportError(re);
        errorHandler.recover(this, input,re);
        PythonTree badNode = (PythonTree)adaptor.errorNode(input, retval.start, input.LT(-1), re);
        retval.tree = new ErrorMod(badNode);
    }

//file_input: (NEWLINE | stmt)* ENDMARKER
file_input
@init {
    mod mtype = null;
    List stypes = new ArrayList();
}
@after {
    if (!stypes.isEmpty()) {
        //The EOF token messes up the end offsets, so set them manually.
        //XXX: this may no longer be true now that PythonTokenSource is
        //     adjusting EOF offsets -- but needs testing before I remove
        //     this.
        PythonTree stop = (PythonTree)stypes.get(stypes.size() -1);
        mtype.setCharStopIndex(stop.getCharStopIndex());
        mtype.setTokenStopIndex(stop.getTokenStopIndex());
    }

    $file_input.tree = mtype;
}
    : (NEWLINE
      | stmt
      {
          if ($stmt.stypes != null) {
              stypes.addAll($stmt.stypes);
          }
      }
      )* EOF
         {
             mtype = new Module($file_input.start, actions.castStmts(stypes));
         }
    ;
    //XXX: this block is duplicated in three places, how to extract?
    catch [RecognitionException re] {
        reportError(re);
        errorHandler.recover(this, input,re);
        PythonTree badNode = (PythonTree)adaptor.errorNode(input, retval.start, input.LT(-1), re);
        retval.tree = new ErrorMod(badNode);
    }

//eval_input: testlist NEWLINE* ENDMARKER
eval_input
@init {
    mod mtype = null;
}
@after {
    $eval_input.tree = mtype;
}
    : LEADING_WS? (NEWLINE)* testlist[expr_contextType.Load] (NEWLINE)* EOF
      {
        mtype = new Expression($eval_input.start, actions.castExpr($testlist.tree));
      }
    ;
    //XXX: this block is duplicated in three places, how to extract?
    catch [RecognitionException re] {
        reportError(re);
        errorHandler.recover(this, input,re);
        PythonTree badNode = (PythonTree)adaptor.errorNode(input, retval.start, input.LT(-1), re);
        retval.tree = new ErrorMod(badNode);
    }


//not in CPython's Grammar file
dotted_attr
    returns [expr etype]
    : n1=NAME
      ( (DOT n2+=NAME)+
        {
            $etype = actions.makeDottedAttr($n1, $n2);
        }
      |
        {
            $etype = actions.makeNameNode($n1);
        }
      )
    ;

//not in CPython's Grammar file
name_or_print
    returns [Token tok]
    : NAME {
        $tok = $name_or_print.start;
    }
    | ASYNC {
        $tok = $name_or_print.start;
    }
    | AWAIT {
        $tok = $name_or_print.start;
    }
    ;

//not in CPython's Grammar file
//attr is here for Java  compatibility.  A Java foo.getIf() can be called from Jython as foo.if
//     so we need to support any keyword as an attribute.

attr
    : NAME
    | AND
    | AS
    | ASSERT
    | ASYNC
    | AWAIT
    | BREAK
    | CLASS
    | CONTINUE
    | DEF
    | DELETE
    | ELIF
    | EXCEPT
    | EXEC
    | FINALLY
    | FROM
    | FOR
    | GLOBAL
    | IF
    | IMPORT
    | IN
    | IS
    | LAMBDA
    | NONLOCAL
    | NOT
    | OR
    | ORELSE
    | PASS
    | RAISE
    | RETURN
    | TRY
    | WHILE
    | WITH
    | YIELD
    ;

//decorator: '@' dotted_name [ '(' [arglist] ')' ] NEWLINE
decorator
    returns [expr etype]
@after {
   $decorator.tree = $etype;
}
    : AT dotted_attr
    ( LPAREN
      ( arglist
        {
            $etype = actions.makeCall($LPAREN, $dotted_attr.etype, $arglist.args, $arglist.keywords);
        }
      |
        {
            $etype = actions.makeCall($LPAREN, $dotted_attr.etype);
        }
      )
      RPAREN
    |
      {
          $etype = actions.makeCall($LPAREN, $dotted_attr.etype);
      }
    ) NEWLINE
    ;

//decorators: decorator+
decorators
    returns [List etypes]
    : d+=decorator+
      {
          $etypes = $d;
      }
    ;

//async_funcdef: ASYNC funcdef
async_funcdef
@init {
    stmt stype = null;
}

@after {
    $async_funcdef.tree = stype;
}
    : ASYNC funcdef
    {
        stype = actions.makeAsyncFuncdef($ASYNC, $funcdef.tree);
    }
    ;

//decorated: decorators (classdef | funcdef | async_funcdef)
decorated
@init {
    stmt stype = null;
}

@after {
    $decorated.tree = stype;
}
    : decorators
        ( classdef
        {
            stype = actions.castStmt($classdef.tree);
            ((ClassDef) stype).setDecorator_list(actions.castExprs($decorators.etypes));
        }
        | funcdef
        {
            stype = actions.castStmt($funcdef.tree);
            ((FunctionDef) stype).setDecorator_list(actions.castExprs($decorators.etypes));
        }
        | async_funcdef
        {
            stype = actions.castStmt($async_funcdef.tree);
            ((AsyncFunctionDef) stype).setDecorator_list(actions.castExprs($decorators.etypes));
        }
        )
    ;

//funcdef: 'def' NAME parameters ['->' test] ':' suite
funcdef
@init {
    stmt stype = null;
}

@after {
    $funcdef.tree = stype;
}
    : DEF name_or_print parameters (ARROW test[expr_contextType.Load])? COLON suite[false]
    {
        stype = actions.makeFuncdef($DEF, $name_or_print.start, $parameters.args, $suite.stypes, actions.castExpr($test.tree));
    }
    ;

//parameters: '(' [typedargslist] ')'
parameters
    returns [arguments args]
    : LPAREN
      (typedargslist
        {
              $args = $typedargslist.args;
        }
      |
        {
            $args = new arguments($parameters.start, new ArrayList<arg>(), (arg)null,
            new ArrayList<arg>(), new ArrayList<expr>(), (arg) null, new ArrayList<expr>());
        }
      )
      RPAREN
    ;

//not in CPython's Grammar file
tdefparameter
    [List defaults] returns [arg etype]
@after {
   $tdefparameter.tree = $etype;
}
    : tfpdef (ASSIGN test[expr_contextType.Load])?
      {
          $etype = actions.castArg($tfpdef.tree);
          if ($ASSIGN != null) {
              defaults.add($test.tree);
          } else {
              defaults.add(null);
          }
      }
    ;

//not in CPython's Grammar file
vdefparameter
    [List defaults] returns [expr etype]
@after {
   $vdefparameter.tree = $etype;
}
    : vfpdef[expr_contextType.Param] (ASSIGN test[expr_contextType.Load])?
      {
          $etype = actions.castExpr($vfpdef.tree);
          if ($ASSIGN != null) {
              defaults.add($test.tree);
          } else {
              defaults.add(null);
          }
      }
    ;

//typedargslist: (tfpdef ['=' test] (',' tfpdef ['=' test])* [',' [
//        '*' [tfpdef] (',' tfpdef ['=' test])* [',' ['**' tfpdef [',']]]
//      | '**' tfpdef [',']]]
//  | '*' [tfpdef] (',' tfpdef ['=' test])* [',' ['**' tfpdef [',']]]
//  | '**' tfpdef [','])
typedargslist
    returns [arguments args]
@init {
    List defaults = new ArrayList();
    List kw_defaults = new ArrayList();
}
    : d+=tdefparameter[defaults] (options {greedy=true;}:COMMA d+=tdefparameter[defaults])*
      (COMMA
          (STAR (vararg=tfpdef)? (COMMA kw+=tdefparameter[kw_defaults] (options {greedy=true;}:COMMA kw+=tdefparameter[kw_defaults])*)? (COMMA DOUBLESTAR kwarg=tfpdef)?
          | DOUBLESTAR kwarg=tfpdef
          )?
      )?
      {
          //if ($STAR.tree != null && $vararg.tree == null && $kw.isEmpty()) {
          //    actions.errorNoNamedArguments($STAR.tree);
          //}

          $args = new arguments($typedargslist.start, actions.castArgs($d),
          actions.castArg($vararg.tree), actions.castArgs($kw),
          kw_defaults, actions.castArg($kwarg.tree), defaults);
      }
    | STAR (vararg=tfpdef)? (COMMA kw+=tdefparameter[kw_defaults] (options {greedy=true;}:COMMA kw+=tdefparameter[kw_defaults])*)? (COMMA DOUBLESTAR kwarg=tfpdef)?
      {
          $args = new arguments($typedargslist.start, actions.castArgs($d),
          actions.castArg($vararg.tree), actions.castArgs($kw),
          kw_defaults, actions.castArg($kwarg.tree), defaults);
      }
    | DOUBLESTAR kwarg=tfpdef
      {
          $args = new arguments($typedargslist.start, actions.castArgs($d), null,
          actions.castArgs($kw), kw_defaults, actions.castArg($kwarg.tree), defaults);
      }
    ;

//tfpdef: NAME [':' test]
tfpdef returns [arg etype]
@init {
  arg etype = null;
}
@after {
    if ($etype != null) {
        $tfpdef.tree = $etype;
    }
}
    : name_or_print (COLON test[expr_contextType.Load])?
      {
          $etype = new arg($name_or_print.tree, $name_or_print.text, actions.castExpr($test.tree));
      }
    ;

//varargslist: (vfpdef ['=' test] (',' vfpdef ['=' test])* [',' [
//        '*' [vfpdef] (',' vfpdef ['=' test])* [',' ['**' vfpdef [',']]]
//      | '**' vfpdef [',']]]
//  | '*' [vfpdef] (',' vfpdef ['=' test])* [',' ['**' vfpdef [',']]]
//  | '**' vfpdef [',']
//)
varargslist
    returns [arguments args]
@init {
    List defaults = new ArrayList();
    List kw_defaults = new ArrayList();
}
    : d+=vdefparameter[defaults] (options {greedy=true;}:COMMA d+=vdefparameter[defaults])*
      (COMMA
          (STAR (vararg=vfpdef[expr_contextType.Param])? (COMMA kw+=vdefparameter[kw_defaults] (options {greedy=true;}:COMMA kw+=vdefparameter[kw_defaults])*)? (COMMA DOUBLESTAR kwarg=vfpdef[expr_contextType.Param])?
          | DOUBLESTAR kwarg=vfpdef[expr_contextType.Param]
          )?
      )?
      {
          $args = new arguments($varargslist.start, actions.castArgs($d),
          actions.castArg($vararg.tree), actions.castArgs($kw),
          kw_defaults, actions.castArg($kwarg.tree), defaults);
      }
    | STAR (vararg=vfpdef[expr_contextType.Param])? (COMMA kw+=vdefparameter[kw_defaults] (options {greedy=true;}:COMMA kw+=vdefparameter[kw_defaults])*)? (COMMA DOUBLESTAR kwarg=vfpdef[expr_contextType.Param])?
      {
          $args = new arguments($varargslist.start, actions.castArgs($d),
          actions.castArg($vararg.tree),
          actions.castArgs($kw), kw_defaults, actions.castArg($kwarg.tree), defaults);
      }
    | DOUBLESTAR kwarg=vfpdef[expr_contextType.Param]
      {
          $args = new arguments($varargslist.start, actions.castArgs($d), null,
          actions.castArgs($kw), kw_defaults,
          actions.castArg($kwarg.tree), defaults);
      }
    ;

//vfpdef: NAME
vfpdef[expr_contextType ctype]
@init {
    expr etype = null;
}
@after {
    if (etype != null) {
        $vfpdef.tree = etype;
    }
}
    : NAME
      {
          etype = new Name($NAME, $NAME.text, ctype);
      }
    ;

//stmt: simple_stmt | compound_stmt
stmt
    returns [List stypes]
    : simple_stmt
      {
          $stypes = $simple_stmt.stypes;
      }
    | compound_stmt
      {
          $stypes = new ArrayList();
          $stypes.add($compound_stmt.tree);
      }
    ;

//simple_stmt: small_stmt (';' small_stmt)* [';'] NEWLINE
simple_stmt
    returns [List stypes]
    : s+=small_stmt (options {greedy=true;}:SEMI s+=small_stmt)* (SEMI)? NEWLINE
      {
          $stypes = $s;
      }
    ;

//small_stmt: (expr_stmt | del_stmt | pass_stmt | flow_stmt |
//             import_stmt | global_stmt | nonlocal_stmt | assert_stmt)
small_stmt : expr_stmt
           | del_stmt
           | pass_stmt
           | flow_stmt
           | import_stmt
           | global_stmt
           | nonlocal_stmt
           | assert_stmt
           ;

//star_expr: '*' expr
star_expr
    [expr_contextType ctype] returns [expr etype]
@after {
    $star_expr.tree = $etype;
}
    : STAR expr[ctype] {
        $etype = new Starred($STAR, actions.castExpr($expr.tree), ctype);
    }
    ;

//expr_stmt: testlist_star_expr (augassign (yield_expr|testlist) |
//                     ('=' (yield_expr|testlist_star_expr))*)
expr_stmt
@init {
    stmt stype = null;
}
@after {
    if (stype != null) {
        $expr_stmt.tree = stype;
    }
}
    : ((testlist_star_expr[null] augassign) => lhs=testlist_star_expr[expr_contextType.AugStore]
        ( (aay=augassign y1=yield_expr
           {
               actions.checkAugAssign(actions.castExpr($lhs.tree));
               stype = new AugAssign($lhs.tree, actions.castExpr($lhs.tree), $aay.op, actions.castExpr($y1.etype));
           }
          )
        | (aat=augassign rhs=testlist_star_expr[expr_contextType.Load]
           {
               actions.checkAugAssign(actions.castExpr($lhs.tree));
               stype = new AugAssign($lhs.tree, actions.castExpr($lhs.tree), $aat.op, actions.castExpr($rhs.tree));
           }
          )
        )
    | (testlist_star_expr[null] ':' test[null] ASSIGN) => lhs=testlist_star_expr[expr_contextType.Store] ':' test[null]
        (
        | ((at=ASSIGN t+=testlist_star_expr[expr_contextType.Store])+
            {
                stype = new Assign($lhs.tree, actions.makeAssignTargets(
                    actions.castExpr($lhs.tree), $t), actions.makeAssignValue($t));
            }
          )
        | ((ay=ASSIGN y2+=yield_expr)+
            {
                stype = new Assign($lhs.start, actions.makeAssignTargets(
                    actions.castExpr($lhs.tree), $y2), actions.makeAssignValue($y2));
            }
          )
        )
    | (testlist_star_expr[null] ASSIGN) => lhs=testlist_star_expr[expr_contextType.Store]
        (
        | ((at=ASSIGN t+=testlist_star_expr[expr_contextType.Store])+
            {
                stype = new Assign($lhs.tree, actions.makeAssignTargets(
                    actions.castExpr($lhs.tree), $t), actions.makeAssignValue($t));
            }
          )
        | ((ay=ASSIGN y2+=yield_expr)+
            {
                stype = new Assign($lhs.start, actions.makeAssignTargets(
                    actions.castExpr($lhs.tree), $y2), actions.makeAssignValue($y2));
            }
          )
        )
    | lhs=testlist_star_expr[expr_contextType.Load]
      {
          stype = new Expr($lhs.start, actions.castExpr($lhs.tree));
      }
    )
    ;

//testlist_star_expr: (test|star_expr) (',' (test|star_expr))* [',']
testlist_star_expr[expr_contextType ctype]
@init {
    expr etype = null;
}
@after {
    if (etype != null) {
        $testlist_star_expr.tree = etype;
    }
}

    : ((test[null] | star_expr[null]) COMMA)
    => 
     (t+=test_or_star_expr[ctype]) (options {greedy=true;}:COMMA (t+=test_or_star_expr[ctype]))* (COMMA)?
      {
          etype = new Tuple($testlist_star_expr.start, actions.castExprs($t), ctype);
      }
    | (test[ctype]
    | star_expr[ctype])
    ;

//not in CPython's Grammar file
test_or_star_expr[expr_contextType ctype]
    : test[ctype]
    | star_expr[ctype]
    ;

//augassign: ('+=' | '-=' | '*=' | '/=' | '%=' | '&=' | '|=' | '^=' |
//            '<<=' | '>>=' | '**=' | '//=')
augassign
    returns [operatorType op]
    : PLUSEQUAL
        {
            $op = operatorType.Add;
        }
    | MINUSEQUAL
        {
            $op = operatorType.Sub;
        }
    | STAREQUAL
        {
            $op = operatorType.Mult;
        }
    | ATEQUAL
        {
            $op = operatorType.MatMult;
        }
    | SLASHEQUAL
        {
            $op = operatorType.Div;
        }
    | PERCENTEQUAL
        {
            $op = operatorType.Mod;
        }
    | AMPEREQUAL
        {
            $op = operatorType.BitAnd;
        }
    | VBAREQUAL
        {
            $op = operatorType.BitOr;
        }
    | CIRCUMFLEXEQUAL
        {
            $op = operatorType.BitXor;
        }
    | LEFTSHIFTEQUAL
        {
            $op = operatorType.LShift;
        }
    | RIGHTSHIFTEQUAL
        {
            $op = operatorType.RShift;
        }
    | DOUBLESTAREQUAL
        {
            $op = operatorType.Pow;
        }
    | DOUBLESLASHEQUAL
        {
            $op = operatorType.FloorDiv;
        }
    ;

//del_stmt: 'del' exprlist
del_stmt
@init {
    stmt stype = null;
}
@after {
   $del_stmt.tree = stype;
}
    : DELETE del_list
      {
          stype = new Delete($DELETE, $del_list.etypes);
      }
    ;

//pass_stmt: 'pass'
pass_stmt
@init {
    stmt stype = null;
}
@after {
   $pass_stmt.tree = stype;
}
    : PASS
      {
          stype = new Pass($PASS);
      }
    ;

//flow_stmt: break_stmt | continue_stmt | return_stmt | raise_stmt | yield_stmt
flow_stmt
    : break_stmt
    | continue_stmt
    | return_stmt
    | raise_stmt
    | yield_stmt
    ;

//break_stmt: 'break'
break_stmt
@init {
    stmt stype = null;
}
@after {
   $break_stmt.tree = stype;
}
    : BREAK
      {
          stype = new Break($BREAK);
      }
    ;

//continue_stmt: 'continue'
continue_stmt
@init {
    stmt stype = null;
}
@after {
   $continue_stmt.tree = stype;
}
    : CONTINUE
      {
          if (!$suite.isEmpty() && $suite::continueIllegal) {
              errorHandler.error("'continue' not supported inside 'finally' clause", new PythonTree($continue_stmt.start));
          }
          stype = new Continue($CONTINUE);
      }
    ;

//return_stmt: 'return' [testlist]
return_stmt
@init {
    stmt stype = null;
}
@after {
   $return_stmt.tree = stype;
}
    : RETURN
      (testlist[expr_contextType.Load]
       {
           stype = new Return($RETURN, actions.castExpr($testlist.tree));
       }
      |
       {
           stype = new Return($RETURN, null);
       }
      )
      ;

//yield_stmt: yield_expr
yield_stmt
@init {
    stmt stype = null;
}
@after {
   $yield_stmt.tree = stype;
}
    : yield_expr
      {
        stype = new Expr($yield_expr.start, actions.castExpr($yield_expr.etype));
      }
    ;

//raise_stmt: 'raise' [test ['from' test]]
raise_stmt
@init {
    stmt stype = null;
}
@after {
   $raise_stmt.tree = stype;
}
    : RAISE (t1=test[expr_contextType.Load] (FROM t2=test[expr_contextType.Load])?)?
    {
        stype = new Raise($RAISE, actions.castExpr($t1.tree), actions.castExpr($t2.tree));
    }
    ;

//import_stmt: import_name | import_from
import_stmt
    : import_name
    | import_from
    ;

//import_name: 'import' dotted_as_names
import_name
@init {
    stmt stype = null;
}
@after {
   $import_name.tree = stype;
}
    : IMPORT dotted_as_names
      {
          stype = new Import($IMPORT, $dotted_as_names.atypes);
      }
    ;

//import_from: ('from' (('.' | '...')* dotted_name | ('.' | '...')+)
//              'import' ('*' | '(' import_as_names ')' | import_as_names))
import_from
@init {
    stmt stype = null;
}
@after {
   $import_from.tree = stype;
}
    : FROM (d+=DOT* dotted_name | d+=DOT+) IMPORT
        (STAR
         {
             stype = new ImportFrom($FROM, actions.makeFromText($d, $dotted_name.names),
                 actions.makeModuleNameNode($d, $dotted_name.names),
                 actions.makeStarAlias($STAR), actions.makeLevel($d));
         }
        | i1=import_as_names
         {
             String dottedText = $dotted_name.text;
             if (dottedText != null && dottedText.equals("__future__")) {
                 List<alias> aliases = $i1.atypes;
                 for(alias a: aliases) {
                     if (a != null) {
                         if (a.getInternalName().equals("print_function")) {
                             printFunction = true;
                         } else if (a.getInternalName().equals("unicode_literals")) {
                             unicodeLiterals = true;
                         }
                     }
                 }
             }
             stype = new ImportFrom($FROM, actions.makeFromText($d, $dotted_name.names),
                 actions.makeModuleNameNode($d, $dotted_name.names),
                 actions.makeAliases($i1.atypes), actions.makeLevel($d));
         }
        | LPAREN i2=import_as_names COMMA? RPAREN
         {
             //XXX: this is almost a complete C&P of the code above - is there some way
             //     to factor it out?
             String dottedText = $dotted_name.text;
             if (dottedText != null && dottedText.equals("__future__")) {
                 List<alias> aliases = $i2.atypes;
                 for(alias a: aliases) {
                     if (a != null) {
                         if (a.getInternalName().equals("print_function")) {
                             printFunction = true;
                         } else if (a.getInternalName().equals("unicode_literals")) {
                             unicodeLiterals = true;
                         }
                     }
                 }
             }
             stype = new ImportFrom($FROM, actions.makeFromText($d, $dotted_name.names),
                 actions.makeModuleNameNode($d, $dotted_name.names),
                 actions.makeAliases($i2.atypes), actions.makeLevel($d));
         }
        )
    ;

//import_as_names: import_as_name (',' import_as_name)* [',']
import_as_names
    returns [List<alias> atypes]
    : n+=import_as_name (COMMA! n+=import_as_name)*
    {
        $atypes = $n;
    }
    ;

//import_as_name: NAME [('as' | NAME) NAME]
import_as_name
    returns [alias atype]
@after {
    $import_as_name.tree = $atype;
}
    : name=NAME (AS asname=NAME)?
    {
        $atype = new alias(actions.makeNameNode($name), actions.makeNameNode($asname));
    }
    ;

//XXX: when does CPython Grammar match "dotted_name NAME NAME"?
//dotted_as_name: dotted_name [('as' | NAME) NAME]
dotted_as_name
    returns [alias atype]
@after {
    $dotted_as_name.tree = $atype;
}
    : dotted_name (AS asname=NAME)?
    {
        $atype = new alias($dotted_name.names, actions.makeNameNode($asname));
    }
    ;

//dotted_as_names: dotted_as_name (',' dotted_as_name)*
dotted_as_names
    returns [List<alias> atypes]
    : d+=dotted_as_name (COMMA! d+=dotted_as_name)*
    {
        $atypes = $d;
    }
    ;

//dotted_name: NAME ('.' NAME)*
dotted_name
    returns [List<Name> names]
    : NAME (DOT dn+=attr)*
    {
        $names = actions.makeDottedName($NAME, $dn);
    }
    ;

//global_stmt: 'global' NAME (',' NAME)*
global_stmt
@init {
    stmt stype = null;
}
@after {
   $global_stmt.tree = stype;
}
    : GLOBAL n+=NAME (COMMA n+=NAME)*
      {
          stype = new Global($GLOBAL, actions.makeNames($n), actions.makeNameNodes($n));
      }
    ;

//nonlocal_stmt: 'nonlocal' NAME (',' NAME)*
nonlocal_stmt
@init {
    stmt stype = null;
}
@after {
   $nonlocal_stmt.tree = stype;
}
    : NONLOCAL n+=NAME (COMMA n+=NAME)*
      {
          stype = new Nonlocal($NONLOCAL, actions.makeNames($n), actions.makeNameNodes($n));
      }
    ;

//assert_stmt: 'assert' test [',' test]
assert_stmt
@init {
    stmt stype = null;
}
@after {
   $assert_stmt.tree = stype;
}
    : ASSERT t1=test[expr_contextType.Load] (COMMA t2=test[expr_contextType.Load])?
      {
          stype = new Assert($ASSERT, actions.castExpr($t1.tree), actions.castExpr($t2.tree));
      }
    ;

//compound_stmt: if_stmt | while_stmt | for_stmt | try_stmt | with_stmt | funcdef | classdef | decorated | async_stmt
compound_stmt
    : if_stmt
    | while_stmt
    | for_stmt
    | try_stmt
    | with_stmt
    | funcdef
    | classdef
    | decorated
    | async_stmt
    ;

//async_stmt: ASYNC (funcdef | with_stmt | for_stmt)
async_stmt
@init {
    stmt stype = null;
}
@after {
   $async_stmt.tree = stype;
}
    : ASYNC
        ( funcdef
        {
            stype = actions.makeAsyncFuncdef($ASYNC, $funcdef.tree);
        }
        | with_stmt
        {
            stype = actions.makeAsyncWith($ASYNC, $with_stmt.items, $with_stmt.stypes);
        }
        | for_stmt
        {
            stype = actions.makeAsyncFor($ASYNC, $for_stmt.tree);
        }
        )
    ;

//if_stmt: 'if' test ':' suite ('elif' test ':' suite)* ['else' ':' suite]
if_stmt
@init {
    stmt stype = null;
}
@after {
   $if_stmt.tree = stype;
}
    : IF test[expr_contextType.Load] COLON ifsuite=suite[false] elif_clause?
      {
          stype = new If($IF, actions.castExpr($test.tree), actions.castStmts($ifsuite.stypes),
              actions.makeElse($elif_clause.stypes, $elif_clause.tree));
      }
    ;

//not in CPython's Grammar file
elif_clause
    returns [List stypes]
@init {
    stmt stype = null;
}
@after {
   if (stype != null) {
       $elif_clause.tree = stype;
   }
}
    : else_clause
      {
          $stypes = $else_clause.stypes;
      }
    | ELIF test[expr_contextType.Load] COLON suite[false]
      (e2=elif_clause
       {
           stype = new If($test.start, actions.castExpr($test.tree), actions.castStmts($suite.stypes), actions.makeElse($e2.stypes, $e2.tree));
       }
      |
       {
           stype = new If($test.start, actions.castExpr($test.tree), actions.castStmts($suite.stypes), new ArrayList<stmt>());
       }
      )
    ;

//not in CPython's Grammar file
else_clause
    returns [List stypes]
    : ORELSE COLON elsesuite=suite[false]
      {
          $stypes = $suite.stypes;
      }
    ;

//while_stmt: 'while' test ':' suite ['else' ':' suite]
while_stmt
@init {
    stmt stype = null;
}
@after {
   $while_stmt.tree = stype;
}
    : WHILE test[expr_contextType.Load] COLON s1=suite[false] (ORELSE COLON s2=suite[false])?
      {
          stype = actions.makeWhile($WHILE, actions.castExpr($test.tree), $s1.stypes, $s2.stypes);
      }
    ;

//for_stmt: 'for' exprlist 'in' testlist ':' suite ['else' ':' suite]
for_stmt
@init {
    stmt stype = null;
}
@after {
   $for_stmt.tree = stype;
}
    : FOR exprlist[expr_contextType.Store] IN testlist[expr_contextType.Load] COLON s1=suite[false]
        (ORELSE COLON s2=suite[false])?
      {
          stype = actions.makeFor($FOR, $exprlist.etype, actions.castExpr($testlist.tree), $s1.stypes, $s2.stypes);
      }
    ;

//try_stmt: ('try' ':' suite
//           ((except_clause ':' suite)+
//           ['else' ':' suite]
//           ['finally' ':' suite] |
//           'finally' ':' suite))
try_stmt
@init {
    stmt stype = null;
}
@after {
   $try_stmt.tree = stype;
}
    : TRY COLON trysuite=suite[!$suite.isEmpty() && $suite::continueIllegal]
      ( e+=except_clause+ (ORELSE COLON elsesuite=suite[!$suite.isEmpty() && $suite::continueIllegal])? (FINALLY COLON finalsuite=suite[true])?
        {
            stype = actions.makeTryExcept($TRY, $trysuite.stypes, $e, $elsesuite.stypes, $finalsuite.stypes);
        }
      | FINALLY COLON finalsuite=suite[true]
        {
            stype = actions.makeTryFinally($TRY, $trysuite.stypes, $finalsuite.stypes);
        }
      )
      ;

//with_stmt: 'with' with_item (',' with_item)*  ':' suite
with_stmt returns [List items, List stypes]
@init {
    stmt stype = null;
}
@after {
   $with_stmt.tree = stype;
}
    : WITH w+=with_item (options {greedy=true;}:COMMA w+=with_item)* COLON suite[false]
    {
        $items = $w;
        $stypes = $suite.stypes;
        stype = actions.makeWith($WITH, $w, $suite.stypes);
    }
    ;

//with_item: test ['as' expr]
with_item
@init {
    withitem stype = null;
}
@after {
   $with_item.tree = stype;
}
    : test[expr_contextType.Load] (AS expr[expr_contextType.Store])?
      {
          expr item = actions.castExpr($test.tree);
          expr var = null;
          if ($expr.start != null) {
              var = actions.castExpr($expr.tree);
              actions.checkAssign(var);
          }
          stype = new withitem($test.start, item, var);
      }
    ;

//except_clause: 'except' [test ['as' NAME]]
except_clause
@init {
    excepthandler extype = null;
}
@after {
   $except_clause.tree = extype;
}
    : EXCEPT (t1=test[expr_contextType.Load] (AS NAME)?)? COLON suite[!$suite.isEmpty() && $suite::continueIllegal]
      {
          String name = null;
          if ($NAME != null) {
              name = $NAME.getText();
          }
          extype = new ExceptHandler($EXCEPT, actions.castExpr($t1.tree), name,
              actions.castStmts($suite.stypes));
      }
    ;

//suite: simple_stmt | NEWLINE INDENT stmt+ DEDENT
suite
    [boolean fromFinally] returns [List stypes]
scope {
    boolean continueIllegal;
}
@init {
    if ($suite::continueIllegal || fromFinally) {
        $suite::continueIllegal = true;
    } else {
        $suite::continueIllegal = false;
    }
    $stypes = new ArrayList();
}
    : simple_stmt
      {
          $stypes = $simple_stmt.stypes;
      }
    | NEWLINE INDENT
      (stmt
       {
           if ($stmt.stypes != null) {
               $stypes.addAll($stmt.stypes);
           }
       }
      )+ DEDENT
    ;

//test: or_test ['if' or_test 'else' test] | lambdef
test[expr_contextType ctype]
@init {
    expr etype = null;
}
@after {
   if (etype != null) {
       $test.tree = etype;
   }
}
    :o1=or_test[ctype]
      ( (IF or_test[null] ORELSE) => IF o2=or_test[ctype] ORELSE e=test[expr_contextType.Load]
         {
             etype = new IfExp($o1.start, actions.castExpr($o2.tree), actions.castExpr($o1.tree), actions.castExpr($e.tree));
         }
      |
     -> or_test
      )
    | lambdef
    ;

//test_nocond: or_test | lambdef_nocond
test_nocond[expr_contextType ctype]
@init {
    expr etype = null;
}
@after {
   if (etype != null) {
       $test_nocond.tree = etype;
   }
}
    : o1=or_test[ctype]
      ( (IF or_test[null] ORELSE) => IF o2=or_test[ctype] ORELSE e=test[expr_contextType.Load]
         {
             etype = new IfExp($o1.start, actions.castExpr($o2.tree), actions.castExpr($o1.tree), actions.castExpr($e.tree));
         }
      |
     -> or_test
      )
    | lambdef_nocond
    ;


//or_test: and_test ('or' and_test)*
or_test
    [expr_contextType ctype] returns [Token leftTok]
@after {
    if ($or != null) {
        Token tok = $left.start;
        if ($left.leftTok != null) {
            tok = $left.leftTok;
        }
        $or_test.tree = actions.makeBoolOp(tok, $left.tree, boolopType.Or, $right);
    }
}
    : left=and_test[ctype]
        ( (or=OR right+=and_test[ctype]
          )+
        |
       -> $left
        )
    ;

//and_test: not_test ('and' not_test)*
and_test
    [expr_contextType ctype] returns [Token leftTok]
@after {
    if ($and != null) {
        Token tok = $left.start;
        if ($left.leftTok != null) {
            tok = $left.leftTok;
        }
        $and_test.tree = actions.makeBoolOp(tok, $left.tree, boolopType.And, $right);
    }
}
    : left=not_test[ctype]
        ( (and=AND right+=not_test[ctype]
          )+
        |
       -> $left
        )
    ;

//not_test: 'not' not_test | comparison
not_test
    [expr_contextType ctype] returns [Token leftTok]
@init {
    expr etype = null;
}
@after {
   if (etype != null) {
       $not_test.tree = etype;
   }
}
    : NOT nt=not_test[ctype]
      {
          etype = new UnaryOp($NOT, unaryopType.Not, actions.castExpr($nt.tree));
      }
    | comparison[ctype]
      {
          $leftTok = $comparison.leftTok;
      }
    ;

//comparison: expr (comp_op expr)*
comparison
    [expr_contextType ctype] returns [Token leftTok]
@init {
    List cmps = new ArrayList();
}
@after {
    $leftTok = $left.leftTok;
    if (!cmps.isEmpty()) {
        $comparison.tree = new Compare($left.start, actions.castExpr($left.tree), actions.makeCmpOps(cmps),
            actions.castExprs($right));
    }
}
    : left=expr[ctype]
       ( ( comp_op right+=expr[ctype]
           {
               cmps.add($comp_op.op);
           }
         )+
       |
      -> $left
       )
    ;

//comp_op: '<'|'>'|'=='|'>='|'<='|'<>'|'!='|'in'|'not' 'in'|'is'|'is' 'not'
comp_op
    returns [cmpopType op]
    : LESS
      {
          $op = cmpopType.Lt;
      }
    | GREATER
      {
          $op = cmpopType.Gt;
      }
    | EQUAL
      {
          $op = cmpopType.Eq;
      }
    | GREATEREQUAL
      {
          $op = cmpopType.GtE;
      }
    | LESSEQUAL
      {
          $op = cmpopType.LtE;
      }
    | ALT_NOTEQUAL
      {
          $op = cmpopType.NotEq;
      }
    | NOTEQUAL
      {
          $op = cmpopType.NotEq;
      }
    | IN
      {
          $op = cmpopType.In;
      }
    | NOT IN
      {
          $op = cmpopType.NotIn;
      }
    | IS
      {
          $op = cmpopType.Is;
      }
    | IS NOT
      {
          $op = cmpopType.IsNot;
      }
    ;

//expr: xor_expr ('|' xor_expr)*
expr
    [expr_contextType ect] returns [Token leftTok]
scope {
    expr_contextType ctype;
}
@init {
    $expr::ctype = ect;
}
@after {
    $leftTok = $left.lparen;
    if ($op != null) {
        Token tok = $left.start;
        if ($left.lparen != null) {
            tok = $left.lparen;
        }
        $expr.tree = actions.makeBinOp(tok, $left.tree, operatorType.BitOr, $right);
    }
}
    : left=xor_expr
        ( (op=VBAR right+=xor_expr
          )+
        |
       -> $left
        )
    ;


//xor_expr: and_expr ('^' and_expr)*
xor_expr
    returns [Token lparen = null]
@after {
    if ($op != null) {
        Token tok = $left.start;
        if ($left.lparen != null) {
            tok = $left.lparen;
        }
        $xor_expr.tree = actions.makeBinOp(tok, $left.tree, operatorType.BitXor, $right);
    }
    $lparen = $left.lparen;
}
    : left=and_expr
        ( (op=CIRCUMFLEX right+=and_expr
          )+
        |
       -> $left
        )
    ;

//and_expr: shift_expr ('&' shift_expr)*
and_expr
    returns [Token lparen = null]
@after {
    if ($op != null) {
        Token tok = $left.start;
        if ($left.lparen != null) {
            tok = $left.lparen;
        }
        $and_expr.tree = actions.makeBinOp(tok, $left.tree, operatorType.BitAnd, $right);
    }
    $lparen = $left.lparen;
}
    : left=shift_expr
        ( (op=AMPER right+=shift_expr
          )+
        |
       -> $left
        )
    ;

//shift_expr: arith_expr (('<<'|'>>') arith_expr)*
shift_expr
    returns [Token lparen = null]
@init {
    List ops = new ArrayList();
    List toks = new ArrayList();
}
@after {
    if (!ops.isEmpty()) {
        Token tok = $left.start;
        if ($left.lparen != null) {
            tok = $left.lparen;
        }
        $shift_expr.tree = actions.makeBinOp(tok, $left.tree, ops, $right, toks);
    }
    $lparen = $left.lparen;
}
    : left=arith_expr
        ( ( shift_op right+=arith_expr
            {
                ops.add($shift_op.op);
                toks.add($shift_op.start);
            }
          )+
        |
       -> $left
        )
    ;

shift_op
    returns [operatorType op]
    : LEFTSHIFT
      {
          $op = operatorType.LShift;
      }
    | RIGHTSHIFT
      {
          $op = operatorType.RShift;
      }
    ;

//arith_expr: term (('+'|'-') term)*
arith_expr
    returns [Token lparen = null]
@init {
    List ops = new ArrayList();
    List toks = new ArrayList();
}
@after {
    if (!ops.isEmpty()) {
        Token tok = $left.start;
        if ($left.lparen != null) {
            tok = $left.lparen;
        }
        $arith_expr.tree = actions.makeBinOp(tok, $left.tree, ops, $right, toks);
    }
    $lparen = $left.lparen;
}
    : left=term
        ( (arith_op right+=term
           {
               ops.add($arith_op.op);
               toks.add($arith_op.start);
           }
          )+
        |
       -> $left
        )
    ;
    // This only happens when Antlr is allowed to do error recovery (for example if ListErrorHandler
    // is used.  It is at least possible that this is a bug in Antlr itself, so this needs further
    // investigation.  To reproduce, set errorHandler to ListErrorHandler and try to parse "[".
    catch [RewriteCardinalityException rce] {
        PythonTree badNode = (PythonTree)adaptor.errorNode(input, retval.start, input.LT(-1), null);
        retval.tree = badNode;
        errorHandler.error("Internal Parser Error", badNode);
    }

arith_op
    returns [operatorType op]
    : PLUS
      {
          $op = operatorType.Add;
      }
    | MINUS
      {
          $op = operatorType.Sub;
      }
    ;

//term: factor (('*'|'@'|'/'|'%'|'//') factor)*
term
    returns [Token lparen = null]
@init {
    List ops = new ArrayList();
    List toks = new ArrayList();
}
@after {
    $lparen = $left.lparen;
    if (!ops.isEmpty()) {
        Token tok = $left.start;
        if ($left.lparen != null) {
            tok = $left.lparen;
        }
        $term.tree = actions.makeBinOp(tok, $left.tree, ops, $right, toks);
    }
}
    : left=factor
        ( (term_op right+=factor
          {
              ops.add($term_op.op);
              toks.add($term_op.start);
          }
          )+
        |
       -> $left
        )
    ;

term_op
    returns [operatorType op]
    : STAR
      {
          $op = operatorType.Mult;
      }
    | AT
      {
          $op = operatorType.MatMult;
      }
    | SLASH
      {
          $op = operatorType.Div;
      }
    | PERCENT
      {
          $op = operatorType.Mod;
      }
    | DOUBLESLASH
      {
          $op = operatorType.FloorDiv;
      }
    ;

//factor: ('+'|'-'|'~') factor | power
factor
    returns [expr etype, Token lparen = null]
@after {
    $factor.tree = $etype;
}
    : PLUS p=factor
      {
          $etype = new UnaryOp($PLUS, unaryopType.UAdd, $p.etype);
      }
    | MINUS m=factor
      {
          $etype = actions.negate($MINUS, $m.etype);
      }
    | TILDE t=factor
      {
          $etype = new UnaryOp($TILDE, unaryopType.Invert, $t.etype);
      }
    | power
      {
          $etype = actions.castExpr($power.tree);
          $lparen = $power.lparen;
      }
    ;

//power: atom_expr ['**' factor]
power
    returns [expr etype, Token lparen = null]
@after {
    $power.tree = $etype;
}
    : atom_expr (options {greedy=true;}:d=DOUBLESTAR factor)?
      {
          $lparen = $atom_expr.lparen;
          $etype = actions.castExpr($atom_expr.tree);
          if ($d != null) {
              List right = new ArrayList();
              right.add($factor.tree);
              $etype = actions.makeBinOp($atom_expr.start, $etype, operatorType.Pow, right);
          }
      }
    ;

//atom_expr: [AWAIT] atom trailer*
atom_expr
    returns [expr etype, Token lparen = null]
@after {
    $atom_expr.tree = $etype;
}
    : AWAIT atom (t+=trailer[$atom.start, $atom.tree])*
      {
          $lparen = $atom.lparen;
          //XXX: This could be better.
          $etype = actions.castExpr($atom.tree);
          if ($t != null) {
              for(Object o : $t) {
                  actions.recurseSetContext($etype, expr_contextType.Load);
                  if (o instanceof Call) {
                      Call c = (Call)o;
                      c.setCharStartIndex($etype.getCharStartIndex());
                      c.setFunc((PyObject)$etype);
                      $etype = c;
                  } else if (o instanceof Subscript) {
                      Subscript c = (Subscript)o;
                      c.setCharStartIndex($etype.getCharStartIndex());
                      c.setValue((PyObject)$etype);
                      $etype = c;
                  } else if (o instanceof Attribute) {
                      Attribute c = (Attribute)o;
                      c.setCharStartIndex($etype.getCharStartIndex());
                      c.setValue((PyObject)$etype);
                      $etype = c;
                  }
              }
          }
          $etype = new Await($AWAIT, $etype);
      }
    | atom (t+=trailer[$atom.start, $atom.tree])*
      {
          $lparen = $atom.lparen;
          //XXX: This could be better.
          $etype = actions.castExpr($atom.tree);
          if ($t != null) {
              for(Object o : $t) {
                  actions.recurseSetContext($etype, expr_contextType.Load);
                  if (o instanceof Call) {
                      Call c = (Call)o;
                      c.setFunc((PyObject)$etype);
                      $etype = c;
                  } else if (o instanceof Subscript) {
                      Subscript c = (Subscript)o;
                      c.setValue((PyObject)$etype);
                      $etype = c;
                  } else if (o instanceof Attribute) {
                      Attribute c = (Attribute)o;
                      c.setCharStartIndex($etype.getCharStartIndex());
                      c.setValue((PyObject)$etype);
                      $etype = c;
                  }
              }
          }
      }
    // XXX remove this once await becomes a proper keyword
    | AWAIT
      {
          $etype = new Name($AWAIT, $AWAIT.text, expr_contextType.Load);
      }
    ;

//atom: ('(' [yield_expr|testlist_comp] ')' |
//       '[' [testlist_comp] ']' |
//       '{' [dictorsetmaker] '}' |
//       '`' testlist1 '`' |
//       NAME | NUMBER | STRING+ | '...' | 'True' | 'False' | 'None')
atom
    returns [Token lparen = null]
@init {
    expr etype = null;
}
@after {
   if (etype != null) {
       $atom.tree = etype;
   }
}
    : LPAREN
      {
          $lparen = $LPAREN;
      }
      ( yield_expr
        {
            etype = $yield_expr.etype;
        }
      | testlist_comp[$LPAREN]
     -> testlist_comp
      |
        {
            etype = new Tuple($LPAREN, new ArrayList<expr>(), $expr::ctype);
        }
      )
      RPAREN
    | LBRACK
      (testlist_comp[$LBRACK]
     -> testlist_comp
      |
       {
           etype = new org.python.antlr.ast.List($LBRACK, new ArrayList<expr>(), $expr::ctype);
       }
      )
      RBRACK
    | LCURLY
       (dictorsetmaker[$LCURLY]
      -> dictorsetmaker
       |
        {
            etype = new Dict($LCURLY, new ArrayList<expr>(), new ArrayList<expr>());
        }
       )
       RCURLY
     | NAME
       {
            etype = new Name($NAME, $NAME.text, $expr::ctype);
       }
     | INT
       {
           etype = new Num($INT, actions.makeInt($INT));
       }
     | LONGINT
       {
           etype = new Num($LONGINT, actions.makeInt($LONGINT));
       }
     | FLOAT
       {
           etype = new Num($FLOAT, actions.makeFloat($FLOAT));
       }
     | COMPLEX
       {
           etype = new Num($COMPLEX, actions.makeComplex($COMPLEX));
       }
     | d=DOT DOT DOT
       {
          etype = new Ellipsis($d);
       }
     | (S+=STRING)+
       {
           Object str = actions.extractStrings($S, encoding, unicodeLiterals);
           if (str instanceof String) {
               etype = new Bytes(actions.extractStringToken($S), (String) str);
           } else {
               etype = new Str(actions.extractStringToken($S), str);
           }
       }
     ;

//testlist_comp: (test|star_expr) ( comp_for | (',' (test|star_expr))* [','] )
testlist_comp[Token lpar]
@init {
    expr etype = null;
    List gens = new ArrayList();
}
@after {
    if (etype != null) {
        $testlist_comp.tree = etype;
    }
}
    : t+=test_or_star_expr[$expr::ctype]
        ( (options {k=2;}: c1=COMMA t+=test_or_star_expr[$expr::ctype])* (c2=COMMA)?
         { $c1 != null || $c2 != null }?
           {
               if ($lpar.getText().equals("(")) {
                  etype = new Tuple($lpar, actions.castExprs($t), $expr::ctype);
               } else {
                  etype = new org.python.antlr.ast.List($lpar, actions.castExprs($t), $expr::ctype);
               }
           }
        |
           {
               if ($lpar.getText().equals("[")) {
                  etype = new org.python.antlr.ast.List($lpar, actions.castExprs($t), $expr::ctype);
               }
           }
        | (comp_for[gens]
           {
               Collections.reverse(gens);
               List<comprehension> c = gens;
               expr e = actions.castExpr($t.get(0));
               if (e instanceof Context) {
                   ((Context)e).setContext(expr_contextType.Load);
               }

               if ($lpar.getText().equals("(")) {
                  etype = new GeneratorExp($testlist_comp.start, e, c);
               } else {
                  etype = new ListComp($testlist_comp.start, e, c);
               }
           }
          )
        )
    ;

//lambdef: 'lambda' [varargslist] ':' test
lambdef
@init {
    expr etype = null;
}
@after {
    $lambdef.tree = etype;
}
    : LAMBDA (varargslist)? COLON test[expr_contextType.Load]
      {
          arguments a = $varargslist.args;
          if (a == null) {
              a = new arguments($LAMBDA, new ArrayList<arg>(), (arg)null,
              new ArrayList<arg>(), new ArrayList<expr>(), (arg)null, new ArrayList<expr>());
          }
          etype = new Lambda($LAMBDA, a, actions.castExpr($test.tree));
      }
    ;

//lambdef_nocond: 'lambda' [varargslist] ':' test_nocond
lambdef_nocond
@init {
    expr etype = null;
}
@after {
    $lambdef_nocond.tree = etype;
}
    : LAMBDA (varargslist)? COLON test_nocond[expr_contextType.Load]
      {
          arguments a = $varargslist.args;
          if (a == null) {
              a = new arguments($LAMBDA, new ArrayList<arg>(), (arg)null, new ArrayList<arg>(), new ArrayList<expr>(), (arg) null, new ArrayList<expr>());
          }
          etype = new Lambda($LAMBDA, a, actions.castExpr($test_nocond.tree));
      }
    ;


//trailer: '(' [arglist] ')' | '[' subscriptlist ']' | '.' NAME
trailer [Token begin, PythonTree ptree]
@init {
    expr etype = null;
    Token end = null;
}
@after {
    if (etype != null) {
        etype.setCharStopIndex(((org.antlr.runtime.CommonToken)end).getStopIndex() + 1);
        $trailer.tree = etype;
    }
}
    : LPAREN
      (arglist
       {
           etype = new Call($begin, actions.castExpr($ptree), actions.castExprs($arglist.args),
             actions.makeKeywords($arglist.keywords));
       }
      |
       {
           etype = new Call($begin, actions.castExpr($ptree), new ArrayList<expr>(), new ArrayList<keyword>());
       }
      )
      RPAREN
      {
            end = $RPAREN;
      }
    | LBRACK subscriptlist[$begin] RBRACK
      {
          etype = new Subscript($begin, actions.castExpr($ptree), actions.castSlice($subscriptlist.tree), $expr::ctype);
          end = $RBRACK;
      }
    | DOT attr
      {
          etype = new Attribute($begin, actions.castExpr($ptree), new Name($attr.tree, $attr.text, expr_contextType.Load), $expr::ctype);
          end = $attr.tree.getToken(); 
      }
    ;

//subscriptlist: subscript (',' subscript)* [',']
subscriptlist[Token begin]
@init {
    slice sltype = null;
}
@after {
   $subscriptlist.tree = sltype;
}
    : sub+=subscript (options {greedy=true;}:c1=COMMA sub+=subscript)* (c2=COMMA)?
      {
          sltype = actions.makeSliceType($begin, $c1, $c2, $sub);
      }
    ;

//subscript: test | [test] ':' [test] [sliceop]
subscript
    returns [slice sltype]
@after {
    $subscript.tree = $sltype;
}
    : (test[null] COLON)
   => lower=test[expr_contextType.Load] (c1=COLON (upper1=test[expr_contextType.Load])? (sliceop)?)?
      {
          $sltype = actions.makeSubscript($lower.tree, $c1, $upper1.tree, $sliceop.tree);
      }
    | (COLON)
   => c2=COLON (upper2=test[expr_contextType.Load])? (sliceop)?
      {
          $sltype = actions.makeSubscript(null, $c2, $upper2.tree, $sliceop.tree);
      }
    | test[expr_contextType.Load]
      {
          $sltype = new Index($test.start, actions.castExpr($test.tree));
      }
    ;

//sliceop: ':' [test]
sliceop
@init {
    expr etype = null;
}
@after {
    if (etype != null) {
        $sliceop.tree = etype;
    }
}
    : COLON
     (test[expr_contextType.Load]
    -> test
     |
       {
           etype = new Name($COLON, "None", expr_contextType.Load);
       }
     )
    ;

//exprlist: expr (',' expr)* [',']
exprlist
    [expr_contextType ctype] returns [expr etype]
    : (expr[null] COMMA) => e+=expr[ctype] (options {k=2;}: COMMA e+=expr[ctype])* (COMMA)?
       {
           $etype = new Tuple($exprlist.start, actions.castExprs($e), ctype);
       }
    | expr[ctype]
      {
        $etype = actions.castExpr($expr.tree);
      }
    ;

//not in CPython's Grammar file
//Needed as an exprlist that does not produce tuples for del_stmt.
del_list
    returns [List<expr> etypes]
    : e+=expr[expr_contextType.Del] (options {k=2;}: COMMA e+=expr[expr_contextType.Del])* (COMMA)?
      {
          $etypes = actions.makeDeleteList($e);
      }
    ;

//testlist: test (',' test)* [',']
testlist[expr_contextType ctype]
@init {
    expr etype = null;
}
@after {
    if (etype != null) {
        $testlist.tree = etype;
    }
}
    : (test[null] COMMA)
   => t+=test[ctype] (options {k=2;}: COMMA t+=test[ctype])* (COMMA)?
      {
          etype = new Tuple($testlist.start, actions.castExprs($t), ctype);
      }
    | test[ctype]
    ;

//dictorsetmaker: ( ((test ':' test | '**' expr)
//                   (comp_for | (',' (test ':' test | '**' expr))* [','])) |
//                  ((test | star_expr)
//                   (comp_for | (',' (test | star_expr))* [','])) )
dictorsetmaker[Token lcurly]
@init {
    List gens = new ArrayList();
    expr etype = null;
}
@after {
    if (etype != null) {
        $dictorsetmaker.tree = etype;
    }
}
    : (test[expr_contextType.Load] COLON | DOUBLESTAR) => (k+=test[expr_contextType.Load] COLON v+=test[expr_contextType.Load] | DOUBLESTAR uv+=expr[expr_contextType.Load])
         ( comp_for[gens]
           {
              Collections.reverse(gens);
              List<comprehension> c = gens;
              etype = new DictComp($dictorsetmaker.start, actions.castExpr($k.get(0)), actions.castExpr($v.get(0)), c);
           }
         | (options {k=2;}:COMMA (k+=test[expr_contextType.Load] COLON v+=test[expr_contextType.Load] | DOUBLESTAR uv+=expr[expr_contextType.Load]))*
           {
              etype = new Dict($lcurly, actions.castExprs($k), actions.castExprs($v, $uv));
           }
         (COMMA)?)
    | (k+=test[expr_contextType.Load] | s+=star_expr[expr_contextType.Load])
         ( comp_for[gens]
           {
               Collections.reverse(gens);
               List<comprehension> c = gens;
               expr e = actions.castExpr($k.get(0));
               if (e instanceof Context) {
                   ((Context)e).setContext(expr_contextType.Load);
               }
               etype = new SetComp($lcurly, actions.castExpr($k.get(0)), c);
           }
         | (COMMA (k+=test[expr_contextType.Load] | s+=star_expr[expr_contextType.Load]))*
           {
               etype = new Set($lcurly, actions.castExprs($k, $s));
           }
         (COMMA)?)
    ;

//classdef: 'class' NAME ['(' [arglist] ')'] ':' suite
classdef
@init {
    stmt stype = null;
}
@after {
   $classdef.tree = stype;
}
    : CLASS NAME (LPAREN arglist? RPAREN)? COLON suite[false]
      {
          stype = actions.makeClass($CLASS, $NAME,
                                    $arglist.args,
                                    $arglist.keywords,
                                    $suite.stypes);
      }
    ;

//arglist: (argument ',')* (argument [',']
arglist
    returns [List args, List keywords]
@init {
    List args = new ArrayList();
    List keywords = new ArrayList();
    List gens = new ArrayList();
    boolean first = true;
}
    : argument[args, keywords, gens, first] (COMMA argument[args, keywords, gens, first])* COMMA?
      {
        $args = args;
        $keywords = keywords;
      }
    ;

//argument: ( test [comp_for] |
//            test '=' test |
//            '**' test |
//            '*' test )
argument
    [List args, List keywords, List gens, boolean first] returns [boolean genarg]
    : t1=test[expr_contextType.Load]
      ( comp_for[$gens]
        {
            if (!first) {
                actions.errorGenExpNotSoleArg($comp_for.tree);
            }
            $first = false;
            $genarg = true;
            Collections.reverse($gens);
            List<comprehension> c = $gens;
            $args.add(new GeneratorExp($t1.start, actions.castExpr($t1.tree), c));
        }
      | ASSIGN t2=test[expr_contextType.Load]
        {
            expr newkey = actions.castExpr($t1.tree);
            //Loop through all current keys and fail on duplicate.
            for(Object o: $keywords) {
                List list = (List)o;
                Object oldkey = list.get(0);
                if (oldkey instanceof Name && newkey instanceof Name) {
                    if (((Name)oldkey).getId().equals(((Name)newkey).getId())) {
                        errorHandler.error("keyword arguments repeated", $t1.tree);
                    }
                }
            }
            List<expr> exprs = new ArrayList<expr>();
            exprs.add(newkey);
            exprs.add(actions.castExpr($t2.tree));
            $keywords.add(exprs);

        }
      |
        {
            if (!$keywords.isEmpty()) {
              actions.errorPositionalArgFollowsKeywordArg($t1.tree);
            }
            $args.add($t1.tree);
        }
      )
    | STAR s=test[expr_contextType.Load]
        {
            expr etype = new Starred($STAR, actions.castExpr($s.tree), expr_contextType.Load);
            $args.add(etype);
        }

    | DOUBLESTAR k=test[expr_contextType.Load]
      {
          List<expr> exprs = new ArrayList<>();
          exprs.add(null);
          exprs.add(actions.castExpr($k.tree));
          $keywords.add(exprs);
      }
    ;

//comp_iter: comp_for | comp_if
comp_iter [List gens, List ifs]
    : comp_for[gens]
    | comp_if[gens, ifs]
    ;

//comp_for: 'for' exprlist 'in' or_test [comp_iter]
comp_for [List gens]
@init {
    List ifs = new ArrayList();
}
    : FOR exprlist[expr_contextType.Store] IN or_test[expr_contextType.Load] comp_iter[gens, ifs]?
      {
          Collections.reverse(ifs);
          gens.add(new comprehension($FOR, $exprlist.etype, actions.castExpr($or_test.tree), ifs));
      }
    ;

//comp_if: 'if' test_nocond [comp_iter]
comp_if[List gens, List ifs]
    : IF test_nocond[expr_contextType.Load] comp_iter[gens, ifs]?
      {
        ifs.add(actions.castExpr($test_nocond.tree));
      }
    ;

//yield_expr: 'yield' [yield_arg]
yield_expr
    returns [expr etype]
@after {
    //needed for y2+=yield_expr
    $yield_expr.tree = $etype;
}
    : YIELD yield_arg?
      {
          if (!$yield_arg.isYieldFrom) {
              $etype = new Yield($YIELD, actions.castExpr($yield_arg.tree));
          } else {
              $etype = new YieldFrom($YIELD, actions.castExpr($yield_arg.tree));
          }
      }
    ;

//yield_arg: 'from' test | testlist
yield_arg
    returns [expr etype, boolean isYieldFrom]
@init {
    expr etype = null;
}
@after {
    if (etype != null) {
        $yield_arg.tree = etype;
    }
}
    : FROM test[expr_contextType.Load] {
        etype = actions.castExpr($test.tree);
        $isYieldFrom = true;
    }
    | testlist[expr_contextType.Load] {
        etype = actions.castExpr($testlist.tree);
        $isYieldFrom = false;
    }
    ;

//START OF LEXER RULES
AS        : 'as' ;
ASSERT    : 'assert' ;
ASYNC     : 'async' ;
AWAIT     : 'await' ;
BREAK     : 'break' ;
CLASS     : 'class' ;
CONTINUE  : 'continue' ;
DEF       : 'def' ;
DELETE    : 'del' ;
ELIF      : 'elif' ;
EXCEPT    : 'except' ;
EXEC      : 'exec1' ;
FINALLY   : 'finally' ;
FROM      : 'from' ;
FOR       : 'for' ;
GLOBAL    : 'global' ;
IF        : 'if' ;
IMPORT    : 'import' ;
IN        : 'in' ;
IS        : 'is' ;
LAMBDA    : 'lambda' ;
NONLOCAL  : 'nonlocal' ;
ORELSE    : 'else' ;
PASS      : 'pass'  ;
RAISE     : 'raise' ;
RETURN    : 'return' ;
TRY       : 'try' ;
WHILE     : 'while' ;
WITH      : 'with' ;
YIELD     : 'yield' ;

LPAREN    : '(' {implicitLineJoiningLevel++;} ;

RPAREN    : ')' {implicitLineJoiningLevel--;} ;

LBRACK    : '[' {implicitLineJoiningLevel++;} ;

RBRACK    : ']' {implicitLineJoiningLevel--;} ;

COLON     : ':' ;

COMMA    : ',' ;

SEMI    : ';' ;

PLUS    : '+' ;

MINUS    : '-' ;

STAR    : '*' ;

SLASH    : '/' ;

VBAR    : '|' ;

AMPER    : '&' ;

LESS    : '<' ;

GREATER    : '>' ;

ASSIGN    : '=' ;

PERCENT    : '%' ;

BACKQUOTE    : '`' ;

LCURLY    : '{' {implicitLineJoiningLevel++;} ;

RCURLY    : '}' {implicitLineJoiningLevel--;} ;

CIRCUMFLEX    : '^' ;

TILDE    : '~' ;

EQUAL    : '==' ;

NOTEQUAL    : '!=' ;

ALT_NOTEQUAL: '<>' ;

LESSEQUAL    : '<=' ;

LEFTSHIFT    : '<<' ;

GREATEREQUAL    : '>=' ;

RIGHTSHIFT    : '>>' ;

PLUSEQUAL    : '+=' ;

MINUSEQUAL    : '-=' ;

DOUBLESTAR    : '**' ;

STAREQUAL    : '*=' ;

ATEQUAL     : '@=' ;

DOUBLESLASH    : '//' ;

SLASHEQUAL    : '/=' ;

VBAREQUAL    : '|=' ;

PERCENTEQUAL    : '%=' ;

AMPEREQUAL    : '&=' ;

CIRCUMFLEXEQUAL    : '^=' ;

LEFTSHIFTEQUAL    : '<<=' ;

RIGHTSHIFTEQUAL    : '>>=' ;

DOUBLESTAREQUAL    : '**=' ;

DOUBLESLASHEQUAL    : '//=' ;

ARROW : '->' ;

DOT : '.' ;

AT : '@' ;

AND : 'and' ;

OR : 'or' ;

NOT : 'not' ;

FLOAT
    :   '.' DIGITS (Exponent)?
    |   DIGITS '.' Exponent
    |   DIGITS ('.' (DIGITS (Exponent)?)? | Exponent)
    ;

LONGINT
    :   INT ('l'|'L')
    ;

fragment
Exponent
    :    ('e' | 'E') ( '+' | '-' )? DIGITS
    ;

INT :   // Hex
        '0' ('x' | 'X') ( '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' )+ ('_' ( '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' )+)*
    |   // Octal
        '0' ('o' | 'O') ( '0' .. '7' )+ ('_' ( '0' .. '7' )+)*
    |   // Binary
        '0' ('b' | 'B') ( '0' .. '1' )+ ('_' ( '0' .. '1' )+)*
    |   // Decimal
        ( '0' .. '9' )+ ('_' ('0'..'9')+)*
;

COMPLEX
    :   DIGITS+ ('j'|'J')
    |   FLOAT ('j'|'J')
    ;

fragment
DIGITS : ( '0' .. '9' )+ ;

fragment
LETTER :   'a'..'z'|'A'..'Z'|'\u00C0'..'\u00D6'|'\u00D8'..'\u00F6'|'\u00F8'..'\u00FF'|'\u0100'..'\uFFFE'|'_'
       ;

NAME : LETTER ( LETTER | DIGITS)*
     ;

/** Match various string types.  Note that greedy=false implies '''
 *  should make us exit loop not continue.
 */
STRING
    :   ('f'|'r'|'u'|'b'|'ur'|'br'|'R'|'U'|'B'|'UR'|'BR'|'uR'|'Ur'|'Br'|'bR'|'rb'|'rB'|'Rb'|'RB')?
        (   '\'\'\'' (options {greedy=false;}:TRIAPOS)* '\'\'\''
        |   '"""' (options {greedy=false;}:TRIQUOTE)* '"""'
        |   '"' (ESC|~('\\'|'\n'|'"'))* '"'
        |   '\'' (ESC|~('\\'|'\n'|'\''))* '\''
        ) {
           if (state.tokenStartLine != input.getLine()) {
               state.tokenStartLine = input.getLine();
               state.tokenStartCharPositionInLine = -2;
           }
        }
    ;

/** the two '"'? cause a warning -- is there a way to avoid that? */
fragment
TRIQUOTE
    : '"'? '"'? (ESC|~('\\'|'"'))+
    ;

/** the two '\''? cause a warning -- is there a way to avoid that? */
fragment
TRIAPOS
    : '\''? '\''? (ESC|~('\\'|'\''))+
    ;

fragment
ESC
    :    '\\' .
    ;

/** Consume a newline and any whitespace at start of next line
 *  unless the next line contains only white space, in that case
 *  emit a newline.
 */
CONTINUED_LINE
    :    '\\' ('\r')? '\n' (' '|'\t')*  { $channel=HIDDEN; }
         ( COMMENT
         | nl=NEWLINE
           {
               emit(new CommonToken(NEWLINE,nl.getText()));
           }
         |
         ) {
               if (input.LA(1) == -1) {
                   throw new ParseException("unexpected character after line continuation character");
               }
           }
    ;

/** Treat a sequence of blank lines as a single blank line.  If
 *  nested within a (..), {..}, or [..], then ignore newlines.
 *  If the first newline starts in column one, they are to be ignored.
 *
 *  Frank Wierzbicki added: Also ignore FORMFEEDS (\u000C).
 */
NEWLINE
@init {
    int newlines = 0;
}
    :   (('\u000C')?('\r')? '\n' {newlines++; } )+ {
         if ( startPos==0 || implicitLineJoiningLevel>0 )
            $channel=HIDDEN;
        }
    ;

WS  :    {startPos>0}?=> (' '|'\t'|'\u000C')+ {$channel=HIDDEN;}
    ;

/** Grab everything before a real symbol.  Then if newline, kill it
 *  as this is a blank line.  If whitespace followed by comment, kill it
 *  as it's a comment on a line by itself.
 *
 *  Ignore leading whitespace when nested in [..], (..), {..}.
 */
LEADING_WS
@init {
    int spaces = 0;
    int newlines = 0;
}
    :   {startPos==0}?=>
        (   {implicitLineJoiningLevel>0}? ( ' ' | '\t' )+ {$channel=HIDDEN;}
        |    (     ' '  { spaces++; }
             |    '\t' { spaces += 8; spaces -= (spaces \% 8); }
             )+
             ( ('\r')? '\n' {newlines++; }
             )* {
                   if (input.LA(1) != -1 || newlines == 0) {
                       // make a string of n spaces where n is column number - 1
                       char[] indentation = new char[spaces];
                       for (int i=0; i<spaces; i++) {
                           indentation[i] = ' ';
                       }
                       CommonToken c = new CommonToken(LEADING_WS,new String(indentation));
                       c.setLine(input.getLine());
                       c.setCharPositionInLine(input.getCharPositionInLine());
                       c.setStartIndex(input.index() - 1);
                       c.setStopIndex(input.index() - 1);
                       emit(c);
                       // kill trailing newline if present and then ignore
                       if (newlines != 0) {
                           if (state.token!=null) {
                               state.token.setChannel(HIDDEN);
                           } else {
                               $channel=HIDDEN;
                           }
                       }
                   } else if (this.single && newlines == 1) {
                       // This is here for this case in interactive mode:
                       //
                       // def foo():
                       //   print 1
                       //   <spaces but no code>
                       //
                       // The above would complete in interactive mode instead
                       // of giving ... to wait for more input.
                       //
                       throw new ParseException("Trailing space in single mode.");
                   } else {
                       // make a string of n newlines
                       char[] nls = new char[newlines];
                       for (int i=0; i<newlines; i++) {
                           nls[i] = '\n';
                       }
                       CommonToken c = new CommonToken(NEWLINE,new String(nls));
                       c.setLine(input.getLine());
                       c.setCharPositionInLine(input.getCharPositionInLine());
                       c.setStartIndex(input.index() - 1);
                       c.setStopIndex(input.index() - 1);
                       emit(c);
                   }
                }
        )
    ;

/** Comments not on line by themselves are turned into newlines.

    b = a # end of line comment

    or

    a = [1, # weird
         2]

    This rule is invoked directly by nextToken when the comment is in
    first column or when comment is on end of nonwhitespace line.

    Only match \n here if we didn't start on left edge; let NEWLINE return that.
    Kill if newlines if we live on a line by ourselves

    Consume any leading whitespace if it starts on left edge.
 */
COMMENT
@init {
    $channel=HIDDEN;
}
    :    {startPos==0}?=> (' '|'\t')* '#' (~'\n')* '\n'+
    |    '#' (~'\n')* // let NEWLINE handle \n unless char pos==0 for '#'
    ;

