lang Arith
  syn Expr =
  | Num Dyn
  | Add (Dyn, Dyn)

  sem eval =
  | Num n -> n
  | Add(t) ->
    let e1 = t.0 in
    let e2 = t.1 in
    addi (eval e1) (eval e2)
end

lang Bool
  syn Expr =
  | True
  | False
  | If(Dyn, Dyn, Dyn)

  sem eval =
  | True t -> true
  | False t -> false
  | If t ->
    let cnd = t.0 in
    let thn = t.1 in
    let els = t.2 in
    if eval cnd
    then eval thn
    else eval els
end

lang ArithBool = Arith + Bool

lang ArithBool2 = Arith + Bool
  syn Expr =
  | IsZero(Dyn)

  sem eval =
  | IsZero n ->
    if eqi (eval n) 0
    then true
    else false
end

utest eval (Add (Num 1, Num 2)) with 3 in
utest eval (If (IsZero (Num 0)
               ,Num 1
               ,Num 2)) with 1 in
()