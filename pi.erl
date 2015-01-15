-module (pi).
-export([cal/0]).

cal() -> Result = 4 * cal(0,1,1), io:fwrite("~.5f \n", [Result]).

%Base Case
cal(RESULT, _, 1000007) -> RESULT;
%Recursion Step
cal(RESULT, SIGN, STEP) -> cal(RESULT+(SIGN*1/STEP), SIGN*-1, STEP+2).