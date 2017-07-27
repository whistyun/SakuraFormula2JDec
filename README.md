SakuraFormula2JDec
==================

概要
----

SakuraFormula2JDecは、サクラエディタのマクロとして動作し、
テキスト上の数式を、JavaのBigDecimal用の計算式に変換します。


変換例
------

|数式|変換後|
|---|---|
| a + 3 * 4         | /* a + 3 * 4 */ a .add(new BigDecimal("3").multiply(new BigDecimal("4"))) |
| (b.c +3.4)^3      | /* (b.c +3.4)^3 */ (b.c .add(new BigDecimal("3.4"))).pow(new BigDecimal("3").intValue()) |
| user_func(3+2)/-3 | /* user_func(3+2)/-3 */ user_func(new BigDecimal("3").add(new BigDecimal("2"))).divide(new BigDecimal("3").negate()) |

数式の数値には、実数(####.###)と、変数(Javaで使用できる変数に相当)を指定できます。
演算子は四則演算(+-/*)のほか、剰余(%)と冪乗(^)が使用できます。

＊冪乗と割算には制限事項あり(後述)

機能としては不十分(引数を複数指定できない、流れるようなインターフェースを記述できない)ですが、
関数を記述した場合、関数名を据え置きでJavaのコードに変換します。

数式を変換する際、元の数式をコメントアウトして残すようになっています。
コメントそのものを消した場合は、スクリプト中の変数「OPTION_LEAVE_FORMULA_AS_A_COMMENT」をfalseに変更してください。


使用方法
------

「SakuraFormula2JDec.js」を、サクラエディタのマクロとして登録してください。
サクラエディタ上で、変換をかけたいテキストを選択しマクロを実行してください。 

[参考:マクロ登録方法]
http://sakura-editor.sourceforge.net/htmlhelp/HLP000201.html


制限事項
------

* **配列が使用できない**: 
数式の変数、関数に配列を記述することはできません(例: 1.08 * details[2].cash )

* **冪乗の計算について**: 
BigDecimalの冪乗計算用のメソッドの仕様上、肩には整数しか使用できません(OK例: 2^3、NG例: 2^3.5)
変換時は強制的に整数に変えられます。

* **割算の計算について**: 
BigDecimalで割算を行う場合、有効桁数の設定が必要不可欠(でないと、「1/3」など小数部が無限に続く計算でエラーとなります)ですが、
SakuraFormula2JDecには、有効桁数指定のための機能が実装されておりません。