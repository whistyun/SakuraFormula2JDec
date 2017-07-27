{
    var decimalConstractor = "new BigDecimal("
   var negateMethod       = ".negate()"
   var opeMethod          = {
          "+": ".add("      ,
          "-": ".subtract(" ,
          "*": ".multiply(" ,
          "/": ".divide("   ,
          "%": ".remainder(",
          "^": ".pow("
     };

    function pushAll(to){
        for(var i=1;i< arguments.length; ++i){
            var elem = arguments[i];
            if(elem instanceof Array){
                for(var j=0; j<elem.length; ++j){
                    to.push(elem[j]);
                }
            }else{
                to.push(elem);
            }
        }
        return to;
    }

    function reduce(array, exec, initialValue){
        var res = initialValue
        for(var i=0; i<array.length; ++i){
            res = exec(res, array[i]);
        }
        return res;
    }

    function solveSIg(sigArray){
        var sigFlg = false;
        for(var i=0; i<sigArray.length; ++ i){
            if(sigArray[i]==="-"){
                sigFlg = !sigFlg;
            }
        }
        return sigFlg? negateMethod: "";
    }
    function conv(ope){
        return opeMethod[ope];
    }
}

/**
 * 数式(加減算の処理)
 * @return 文字列(プログラムコード)
 */
Expression
    = headOp:Sign _ head:Term tail:(_ ("+" / "-") _ Sign _ Term)* {
            var express = reduce(tail, function(lft, element) {
                var ope = element[1];
                var sig = element[3];
                var rgh = element[5];

                return pushAll(lft, conv(ope), rgh, sig, ")");
            }, head);

            if(express.length > 0){
                express.splice(1, 0, headOp)
            }

            return express.join('')
        }

/**
 * 数式(積、商、剰余の処理)
 * @return 文字列(プログラムコード)配列
 */
Term
    = head:PowTerm tail:(_ ("*" / "/" / "%") _ Sign _ PowTerm)* {
            return reduce(tail, function(lft, element) {
                var ope = element[1];
                var sig = element[3];
                var rgh = element[5];

                return pushAll(lft, conv(ope), rgh, sig, ")");
            }, head);
        }

/**
 * 数式(乗算の処理)
 * @return 文字列(プログラムコード)配列
 */
PowTerm
    = head:Factor tail:(_ ("^") _ Sign _ Factor)* {
            return reduce(tail, function(lft, element) {
                var ope = element[1];
                var sig = element[3];
                var rgh = element[5];

                return pushAll(lft, conv(ope), rgh, sig, ".intValue()", ")");
            }, [head]);
        }

/**
 * 関数
 * @return 文字列(プログラムコード)
 */
Factor
    = fn:Code? "(" _ expr:Expression append:( _ "," _ Expression)* _ ")" { 
        var str = (fn? fn:"") + "(" + expr;
        if(append){
            for(var i=0;i<append.length;++i){
                str += ", " + append[i][3];
            }
        }
        return str+")"; 
    }
    / Decimal

/**
 * 符号
 * @return 文字列(プログラムコード)
 */
Sign "sign"
    = sigarray:("-"/"+"/_1)* {
        return solveSIg(sigarray);
    }

/**
 * 数値データ
 * @return 文字列(プログラムコード)
 */
Decimal "decimal"
    = _ [0-9]+("." [0-9]+)? { return decimalConstractor + "\"" + text() + "\")" }
    / Code

/**
 * 変数
 * @return 文字列(プログラムコード)
 */
Code "code"
    = _ [a-zA-Z$_][a-zA-Z$_0-9]* _ ("." _[a-zA-Z$_][a-zA-Z$_0-9]* _ )* {return text();}

_1 "whitespace2"
    = [ \t\n\r]

_ "whitespace"
    = [ \t\n\r]*
