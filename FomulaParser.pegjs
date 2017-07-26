{
    function solveSIg(sigArray){
        var sigFlg = false;
        for(var i=0; i<sigArray.length; ++ i){
            if(sigArray[i]==="-"){
                sigFlg = !sigFlg;
            }
        }
        return sigFlg? ".negate()": "";
    }
    function conv(ope){
        return ({
            "+": ".add("      ,
            "-": ".subtract(" ,
            "*": ".multiply(" ,
            "/": ".divide("   ,
            "%": ".remainder(",
            "^": ".pow("
        })[ope];
    }
}

Expression
    = headOp:("-"/_1)* _ head:Term tail:(_ ("+" / "-") _ ("-"/_1)* _ Term)* {
            return tail.reduce(function(lft, element) {
                var ope = element[1];
                var sig = element[3];
                var rgh = element[5];

                return lft + conv(ope) + rgh + solveSIg(sig) + ")";
            }, head + solveSIg(headOp));
        }

Term
    = head:PowTerm tail:(_ ("*" / "/" / "%") _ ("-"/_1)* _ PowTerm)* {
            return tail.reduce(function(lft, element) {
                var ope = element[1];
                var sig = element[3];
                var rgh = element[5];

                return lft + conv(ope) + rgh + solveSIg(sig) + ")";
            }, head);
        }

PowTerm
    = head:Factor tail:(_ ("^") _ ("-"/_1)* _ Factor)* {
            return tail.reduce(function(lft, element) {
                var ope = element[1];
                var sig = element[3];
                var rgh = element[5];

                return lft + conv(ope) + rgh + solveSIg(sig) + ".intValue()" + ")";
            }, head);
        }

Factor
    = fn:Code? "(" _ expr:Expression _ ")" { 
        return (fn? fn:"") + "(" + expr + ")"; 
    }
    / Integer

Integer "integer"
    = _ [0-9]+("." [0-9]+)? { return "new BigDecimal(\"" + text() + "\")" }
    / Code

Code "code"
    = _ [a-zA-Z$_][a-zA-Z$_0-9]* _ ("." _[a-zA-Z$_][a-zA-Z$_0-9]* _ )* {return text();}

_1 "whitespace2"
    = [ \t\n\r]

_ "whitespace"
    = [ \t\n\r]*
