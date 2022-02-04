% helper functions
list_concat([],L,L).
list_concat([X1|L1],L2,[X1|L3]):-list_concat(L1,L2,L3).

list_insert(X,[],[X]).
list_insert(X,[H|T],[H|L]):- list_insert(X,T,L).

list_split(L,0,[],L).
list_split([H|T],N,[H|S],L):- N1 is N-1,list_split(T,N1,S,L).

list_length([],0).
list_length([H|T],N):-list_length(T,N1),N is N1+1.

list_pop([],[],[]).
list_pop([H|T],H,T).

list_delete(X,[],[]).
list_delete(X, [X], []).
list_delete(X,[X|L1], L1).
list_delete(X, [Y|L2], [Y|L1]) :- list_delete(X,L2,L1).

min_elem(empty,2147483647).
min_elem(node(N,empty,empty),N).
min_elem(node(N,L,R),M):-min_elem(L,M1),min_elem(R,M2),T is min(M1,M2),M is min(N,T).

max_elem(empty,-2147483648).
max_elem(node(N,empty,empty),N).
max_elem(node(N,L,R),M):-max_elem(L,M1),max_elem(R,M2),T is max(M1,M2),M is max(N,T).

trPre_helper([],L,L).
trPre_helper([empty|T],V,L):-trPre_helper(T,V,L).
trPre_helper([node(N,A,B)|T],V,L):-list_concat(V,[N],V1),list_concat([A,B],T,L2),trPre_helper(L2,V1,L).

trIn_helper(empty,[],[]).
trIn_helper(empty,[node(N,A,B)|T],L):-trIn_helper(B,T,L1),list_concat([N],L1,L).
trIn_helper(node(N,A,B),S,L):-list_concat([node(N,A,B)],S,S1),trIn_helper(A,S1,L).

trPost_helper([],[]).
trPost_helper([empty|T],L):-trPost_helper(T,L).
trPost_helper([node(N,A,B)|T],L):-list_concat([B,A],T,S2),trPost_helper(S2,L1),list_concat(L1,[N],L).

ibt(empty).
ibt(node(N,L,R)):-integer(N),ibt(L),ibt(R).

% 1. size
size(empty,0).
size(node(_,L,R),N):-size(L,N1),size(R,N2),N is 1+N1+N2.

% 2. height
height(empty,0).
height(node(_,L,R),N):-height(L,N1),height(R,N2),M is max(N1,N2),N is 1+M.

% 3. preorder
preorder(empty,[]).
preorder(node(N,A,B),L):-preorder(A,L1),preorder(B,L2),list_concat(L1,L2,L3),list_concat([N],L3,L).

% 4. inorder
inorder(empty,[]).
inorder(node(N,A,B),L):-inorder(A,L1),inorder(B,L2),list_insert(N,L1,L3),list_concat(L3,L2,L).

% 5. postorder
postorder(empty,[]).
postorder(node(N,A,B),L):-postorder(A,L1),postorder(B,L2),list_concat(L1,L2,L3),list_concat(L3,[N],L).

% 6. trPreorder
trPreorder(empty,[]).
trPreorder(node(N,A,B),L):-trPre_helper([node(N,A,B)],[],L).

% 7. trInorder
trInorder(empty,[]).
trInorder(node(N,A,B),L):-trIn_helper(node(N,A,B),[],L).

% 8. trPostorder
trPostorder(empty,[]).
trPostorder(node(N,A,B),L):-trPost_helper([node(N,A,B)],L).

% 9. eulerTour
eulerTour(empty,[]).
eulerTour(node(N,A,B),L):-eulerTour(A,L1),eulerTour(B,L2),list_concat([N],L1,L3),list_concat(L3,[N],L4),list_concat(L4,L2,L5),list_concat(L5,[N],L).

% 10. preET
preET(BT,L):-preorder(BT,L).

% 11. inET
inET(BT,L):-inorder(BT,L).

% 12. postET
postET(BT,L):-postorder(BT,L).

% 13. toString
toString(empty,'()').
toString(node(N,L,R),S):-toString(L,S1),toString(R,S2),number_string(N,SN),string_concat('(',SN,R1),string_concat(R1,', ',R2),string_concat(R2,S1,R3),string_concat(R3,', ',R4),string_concat(R4,S2,R5),string_concat(R5,')',S).

% 14. isBalanced
isBalanced(empty).
isBalanced(node(_,L,R)):-isBalanced(L),isBalanced(R),height(L,N1),height(R,N2),M1 is max(N1,N2),M2 is min(N1,N2),M1-M2=<1.

% 15. isBST
isBST(empty).
isBST(node(N,empty,empty)).
isBST(node(N,L,R)):-isBST(L),isBST(R),min_elem(R,M1),max_elem(L,M2),N<M1,N>M2.

% 16. makeBST
makeBST([],empty).
makeBST([N],node(N,empty,empty)).
makeBST(L,T):-sort(L,L1),list_length(L1,LEN),SP is LEN//2,list_split(L1,SP,A1,B1),list_pop(B1,M,B2),makeBST(A1,A),makeBST(B2,B),T=node(M,A,B).

% 17. lookup
lookup(N,node(N,_,_)).
lookup(N,node(M,_,R)):-N>M,lookup(N,R).
lookup(N,node(M,L,_)):-N<M,lookup(N,L).

% 18. insert
insert(N,empty,node(N,empty,empty)).
insert(N,node(N,L,R),node(N,L,R)).
insert(N,node(V,L,R),T):-N>V,insert(N,R,R2),T=node(V,L,R2).
insert(N,node(V,L,R),T):-N<V,insert(N,L,L2),T=node(V,L2,R).

% 19. delete
delete(N,BST1,BST2):-inorder(BST1,L),list_delete(N,L,L1),makeBST(L1,BST2).
