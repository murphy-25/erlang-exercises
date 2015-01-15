-module (ccharcount).
-export ([load/1, countsplit/3]).

%Main method:
%   - Load file
%   - Format text
%   - Split text
%   - Send to individual processes
%   - Collect & processes result from processes
load(F) ->
{ok, Bin} = file:read_file(F),
   List = binary_to_list(Bin),
   Length = round(length(List)/21),
   Ls = string:to_lower(List),
   Sl = split(Ls, Length),
   io:fwrite("Loaded and Split~n"),
   NowTime = now(),
   spawner(Sl, 1, self()),
   Result = receiver([], 0),
   ElaspedTime = now(),
   T = timer:now_diff(ElaspedTime,NowTime)*0.000001,
   io:fwrite("Result: ~p~n Time Taken:~ps~n",[Result, T]).

%Method to join the results from the indivdual processes.
join_result([], [], Q) -> Q;
join_result(H, [], []) -> H;
join_result([H|T], [G|F], Q) ->
    Num = element(2, H),
    Num2 = element(2, G),
    W = setelement(2, G, Num+Num2),
    K = Q ++ [W],
    join_result(T, F, K).

%Method which receives the results from each count process.
receiver(R, 21) -> R;
receiver(R, C) ->
    receive 
      {Pid, Result} -> T = join_result(Result, R, []),
                       Pid ! stop
    end,
    receiver(T, C+1).

%Spawns a number of processes needed.
spawner([H|T], N, Receiver) ->
  Pid = spawn(?MODULE, countsplit, [H, [], Receiver]),
  io:fwrite("Starting Process #~p, with PID: ~p~n",[N, Pid]),
  spawner(T,N+1, Receiver);
spawner([], N, _) -> io:fwrite("Spawned: ~p Processes~n",[N-1]).

%Determines the number of each character in given segment.
countsplit([], R, _) -> R;
countsplit(L, R, Receiver) ->
   Result = go(L),
   R2 = join(R, Result),
   Receiver ! {self(),R2}.

%Joins the results together
join([], []) -> [];
join([], R) -> R;
join([H1|T1], [H2|T2]) ->
   {_,N} = H1,
   {C1,N1} = H2,
   [{C1, N+N1}] ++ join(T1, T2).

%Split the loaded file in segments
split([], _) -> [];
split(List, Length) ->
   S1 = string:substr(List, 1, Length),
   case length(List) > Length of
      true -> S2 = string:substr(List, Length+1, length(List));
      false -> S2 = []
   end,
[S1] ++ split(S2, Length).

%Counts the number of characters in segment.
count(_, [], N) -> N;
count(Ch, [H|T], N) ->
   case Ch==H of
   true -> count(Ch, T, N+1);
   false -> count(Ch, T, N)
end.

%Method to get number of characters and format them in tuples.
go(L)->
   Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
rgo(Alph,L,[]).

rgo([],_,Result) -> Result;
rgo([H|T], L, Result) ->
   N = count(H, L, 0),
   Result2 = Result ++ [{[H],N}],
   rgo(T, L, Result2).