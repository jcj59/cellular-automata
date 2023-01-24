type state =
  | Dead
  | Alive

type bit = int
type byte = bit list
type rule = byte
type gameboard = state array
type gamegrid = gameboard array

exception AlreadyAlive
exception AlreadyDead

let rec make_n lst n = if List.length lst < n then make_n (0 :: lst) n else lst

let rec make_end_n lst n =
  if List.length lst < n then make_end_n (lst @ [ 0 ]) n else lst

(* [len gb] is the length of a given gameboard, [gb] *)
let len (gb : gameboard) = Array.length gb

let int_to_binary i =
  if i = 0 then [ 0 ]
  else
    let rec int_to_binary' i acc =
      if i = 0 then acc
      else
        let remainder = i mod 2 in
        int_to_binary' (i / 2) (remainder :: acc)
    in
    int_to_binary' i []

let binary_to_int binary =
  let rec binary_to_int' binary acc =
    match binary with
    | [] -> acc
    | h :: t -> binary_to_int' t ((acc * 2) + h)
  in
  binary_to_int' binary 0

let gb_to_byte (gb : gameboard) : bit list =
  let rec gb_to_byte' acc count =
    if count = len gb then acc
    else
      match gb.(count) with
      | Alive -> gb_to_byte' (1 :: acc) (count + 1)
      | Dead -> gb_to_byte' (0 :: acc) (count + 1)
  in
  gb_to_byte' [] 0 |> List.rev

let init_empty x : gameboard =
  if x = 0 then raise (Failure "Invalid board size")
  else
    let ary = Array.make x Dead in
    ary.(x / 2) <- Alive;
    ary

let neighborhood (gb : gameboard) x : state array =
  let array = Array.make 3 Dead in
  let rec make_nb count =
    if count = 3 then array
    else
      let st =
        if x = 0 && count = 0 then gb.(len gb - 1)
        else gb.((x - 1 + count) mod len gb)
      in
      array.(count) <- st;
      make_nb (count + 1)
  in
  make_nb 0

let birth_node gb x =
  if gb.(x) = Alive then raise AlreadyAlive else gb.(x) <- Alive

let kill_node gb x = if gb.(x) = Dead then raise AlreadyDead else gb.(x) <- Dead
let make_rule b = make_n (int_to_binary b) 8

let update_node (gb : gameboard) rule x =
  let neighborhood = neighborhood gb x in
  let rule = make_rule rule in
  match neighborhood |> gb_to_byte |> binary_to_int with
  | 7 -> if List.nth rule 0 = 1 then Alive else Dead
  | 6 -> if List.nth rule 1 = 1 then Alive else Dead
  | 5 -> if List.nth rule 2 = 1 then Alive else Dead
  | 4 -> if List.nth rule 3 = 1 then Alive else Dead
  | 3 -> if List.nth rule 4 = 1 then Alive else Dead
  | 2 -> if List.nth rule 5 = 1 then Alive else Dead
  | 1 -> if List.nth rule 6 = 1 then Alive else Dead
  | 0 -> if List.nth rule 7 = 1 then Alive else Dead
  | _ -> raise (Failure "Invalid neighborhood")

let update_board (gb : gameboard) rule =
  let new_gb = init_empty (len gb) in
  for i = 0 to len gb - 1 do
    new_gb.(i) <- update_node gb rule i
  done;
  new_gb

let gb_to_string (gb : gameboard) =
  Array.to_list gb
  |> List.map (fun x ->
         match x with
         | Dead -> "⬛"
         | Alive -> "⬜")
  |> List.fold_left ( ^ ) ""

let print_board (gb : gameboard) = print_endline (gb_to_string gb)

let rec print_loop gb rule x =
  let new_gb = update_board gb rule in
  if x = 0 then print_board gb
  else (
    print_board gb;
    print_loop new_gb rule (x - 1))

let make_grid (gb : gameboard) rule x =
  let len = len gb in
  let empty = init_empty len in
  let grid = Array.make x empty in
  let rec make_grid' gb count =
    if count = x then grid
    else
      let new_gb = update_board gb rule in
      grid.(count) <- new_gb;
      make_grid' new_gb (count + 1)
  in
  make_grid' gb 1

let print_grid grid = Array.iter print_board grid

let make_2d gb rule x =
  let len = len gb in
  let matrix = Array.make_matrix x len Dead in
  let rec make_2d' gb count =
    if count = x then (
      matrix.(0) <- init_empty len;
      matrix)
    else
      let new_gb = update_board gb rule in
      matrix.(count) <- new_gb;
      make_2d' new_gb (count + 1)
  in
  make_2d' gb 1
