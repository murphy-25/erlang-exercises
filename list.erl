-module(list).
-export([rduplicates/1, load/1]).

%Main method for removing duplicates and calculating length
%Takes in parameter L: a list such as ["hi", "mark", "goddard"].
rduplicates(L) -> Result = remove_duplicates(L), io:format("~p ",[Result]), io:fwrite("~p ", [len(Result)]).

%Main method for loading a file
%Takes in parameter F: the file name such as "test.txt".
load(F) ->
{ok, List} = file:read_file(F),
   L = binary_to_list(List),
   T = splitStr(string:to_lower(L)),
   Result = rduplicates(T),
Result.

%Calculates the length of a list
len(L) -> len(L, 0).
len([], Count) -> Count;
len([_|T], Count) -> len(T, Count+1).

%Removes any duplicates from a list
remove_duplicates([]) -> [];
remove_duplicates([H|T]) -> [H | [A || A <- remove_duplicates(T), A /= H]].

%splits string based on the given separator list.
splitStr(L) -> string:tokens(L," !@£$%^&*()-_+=[]{}:;?'/><.,\\\n\r\"0123456789").